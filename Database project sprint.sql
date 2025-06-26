
-- DDL: Create Tables

create table Trainee (
    trainee_id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    email VARCHAR(100),
    background VARCHAR(100)
);

create table Trainer (
    trainer_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialty VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100)
);

create table Course (
    course_id INT PRIMARY KEY,
    title VARCHAR(100),
    category VARCHAR(50),
    duration_hours INT,
    level VARCHAR(20)
);

create table Schedule (
    schedule_id INT PRIMARY KEY,
    course_id INT,
    trainer_id INT,
    start_date DATE,
    end_date DATE,
    time_slot VARCHAR(20),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id)
);

create table Enrollment (
    enrollment_id INT PRIMARY KEY,
    trainee_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (trainee_id) REFERENCES Trainee(trainee_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

-- DML: Insert Data

-- Trainee
insert into Trainee values
(1, 'Aisha Al-Harthy', 'Female', 'aisha@example.com', 'Engineering'),
(2, 'Sultan Al-Farsi', 'Male', 'sultan@example.com', 'Business'),
(3, 'Mariam Al-Saadi', 'Female', 'mariam@example.com', 'Marketing'),
(4, 'Omar Al-Balushi', 'Male', 'omar@example.com', 'Computer Science'),
(5, 'Fatma Al-Hinai', 'Female', 'fatma@example.com', 'Data Science');

select * from Trainee

-- Trainer
insert into Trainer values
(1, 'Khalid Al-Maawali', 'Databases', '96891234567', 'khalid@example.com'),
(2, 'Noura Al-Kindi', 'Web Development', '96892345678', 'noura@example.com'),
(3, 'Salim Al-Harthy', 'Data Science', '96893456789', 'salim@example.com');

select * from trainer      

-- Course
insert into Course values
(1, 'Database Fundamentals', 'Databases', 20, 'Beginner'),
(2, 'Web Development Basics', 'Web', 30, 'Beginner'),
(3, 'Data Science Introduction', 'Data Science', 25, 'Intermediate'),
(4, 'Advanced SQL Queries', 'Databases', 15, 'Advanced');

select * from Course

-- Schedule
insert into Schedule values
(1, 1, 1, '2025-07-01', '2025-07-10', 'Morning'),
(2, 2, 2, '2025-07-05', '2025-07-20', 'Evening'),
(3, 3, 3, '2025-07-10', '2025-07-25', 'Weekend'),
(4, 4, 1, '2025-07-15', '2025-07-22', 'Morning');

select * from Schedule

-- Enrollment
insert into Enrollment values
(1, 1, 1, '2025-06-01'),
(2, 2, 1, '2025-06-02'),
(3, 3, 2, '2025-06-03'),
(4, 4, 3, '2025-06-04'),
(5, 5, 3, '2025-06-05'),
(6, 1, 4, '2025-06-06');

select * from Enrollment

-- DML Operations: UPDATE, DELETE, DROP

update Trainee
set background = 'AI & Data Science'
where trainee_id = 5;


--  Show all available courses
select title, level, category FROM Course;

--  View beginner-level Data Science courses
select title from Course where level = 'Beginner' and category = 'Data Science';

-- Courses a specific trainee is enrolled in
select C.title
from Enrollment E
join Course C on E.course_id = C.course_id
where E.trainee_id = 1;

--  Schedule for trainee's enrolled courses
select S.start_date, S.time_slot
from Enrollment E
join Schedule S on E.course_id = S.course_id
where E.trainee_id = 1;

-- Count of courses a trainee is enrolled in
select count(*) as enrolled_courses
from Enrollment
where trainee_id = 1;

--  Course titles, trainer names, and time slots for a trainee
select C.title, T.name as trainer, S.time_slot
from Enrollment E
JOIN Schedule S on E.course_id = S.course_id
JOIN Trainer T on S.trainer_id = T.trainer_id
JOIN Course C ON C.course_id = E.course_id
where E.trainee_id = 1;



-- List all courses the trainer is assigned to
select C.title
from Schedule S
JOIN Course C on S.course_id = C.course_id
where S.trainer_id = 1;

-- Show upcoming sessions for a trainer
select start_date, end_date, time_slot
from Schedule
where trainer_id = 1;

--  Count of trainees enrolled in each of trainer’s courses
select C.title, count(E.trainee_id) as enrolled_count
from Schedule S
JOIN Course C ON S.course_id = C.course_id
LEFT JOIN Enrollment E ON C.course_id = E.course_id
where S.trainer_id = 1
group by C.title;

-- List names and emails of trainees for each course the trainer teaches
select T.name, T.email
from Enrollment E
JOIN Trainee T on E.trainee_id = T.trainee_id
where E.course_id IN (
    select course_id from Schedule where trainer_id = 1
);

--  Show trainer's contact info and their assigned courses
select T.phone, T.email, C.title
from Trainer T
JOIN Schedule S on T.trainer_id = S.trainer_id
JOIN Course C on S.course_id = C.course_id
where T.trainer_id = 1;

--Count number of courses a trainer teaches
select count(DISTINCT course_id) as course_count
from Schedule
where trainer_id = 1;


insert into Course values (5, 'AI Basics', 'AI', 20, 'Beginner');

--  Create a new schedule for a trainer
insert into Schedule values (5, 5, 3, '2025-08-01', '2025-08-10', 'Evening');

--  View all trainee enrollments with course title and schedule info
select T.name AS trainee, C.title AS course, S.start_date, S.time_slot
FROM Enrollment E
JOIN Trainee T on E.trainee_id = T.trainee_id
JOIN Course C on E.course_id = C.course_id
JOIN Schedule S on C.course_id = S.course_id;

-- Show how many courses each trainer is assigned to
select T.name, COUNT(DISTINCT S.course_id) AS assigned_courses
from Trainer T
LEFT JOIN Schedule S ON T.trainer_id = S.trainer_id
group by T.name;

-- List all trainees enrolled in "Data Basics"

select T.name, T.email
from Trainee T
JOIN Enrollment E on T.trainee_id = E.trainee_id
JOIN Course C on E.course_id = C.course_id
where C.title = 'Data Basics';

-- Identify course with highest number of enrollments

select top 1 C.title, count(E.trainee_id) as total_enrollments
from Course C
JOIN Enrollment E on C.course_id = E.course_id
group by C.title
order by total_enrollments DESC;

-- Display all schedules sorted by start date
select * from Schedule order by start_date ASC;

-- right join : Show all courses and any trainees enrolled in them (including courses with no enrollments)
select C.title, T.name as trainee
from Course C
right join Enrollment E on C.course_id = E.course_id
right join Trainee T on E.trainee_id = T.trainee_id;



-- full outer join : Show all possible trainee-course combinations including unmatched records
select C.title, T.name as trainee
from Course C
full outer join Enrollment E on C.course_id = E.course_id
FULL outer join Trainee T on E.trainee_id = T.trainee_id;



-- cross join : Get all possible combinations of trainees and courses (useful for recommendations or testing)
select T.name as trainee, C.title as course
From Trainee T
cross join Course C;


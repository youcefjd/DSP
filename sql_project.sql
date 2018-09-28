/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:


The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.


Bookings (bookid, facid, memid, starttime, slots)
Facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
Members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate)

/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

Answer: SELECT name FROM Facilities 
            WHERE membercost = 0.0

/* Q2: How many facilities do not charge a fee to members? */

Answer: SELECT COUNT(name) FROM Facilities 
            WHERE membercost = 0.0

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

Answer: SELECT facid, name, membercost, monthlymaintenance FROM Facilities 
            WHERE membercost < 0.2*monthlymaintenance

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

Answer: SELECT * FROM Facilities 
            WHERE facid IN (1,5)

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

Answer: SELECT name, 
            CASE WHEN monthlymaintenance >100
                THEN  'expensive'
                ELSE  'cheap'
            END 
        FROM Facilities
       

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

Answer: SELECT firstname, surname FROM Members 
            WHERE joindate = (SELECT MAX(joindate) FROM Memmbers)


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

Answer: SELECT DISTINCT Members.firstname || ' ' || Members.surname AS member, Facilities.name AS Facility
            FROM Members
            INNER JOIN Bookings ON (Members.memid = Bookings.memid)
            INNER JOIN Facilities ON (Bookings.facid = Facilities.facid)
            WHERE Facilities.name LIKE 'Tennis%'
        ORDER BY member, facility;


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

Answer: SELECT Members.firstname || ' ' || Members.surname AS member, Facilities.name AS facility,
            (CASE WHEN Members.memid = 0 THEN Facilities.guestcost * Bookings.slots
            ELSE Facilities.membercost * Bookings.slots END) AS Cost
            FROM Members 
            INNER JOIN Bookings ON (Members.memid = Bookings.memid)
            INNER JOIN Facilities ON (Bookings.facid = Facilities.facid)
            WHERE (date_trunc('day', Bookings.starttime) = '2012-09-14') AND
            ((Members.memid = 0 AND Bookings.slots * Facilities.guestcost > 30) OR
            (Members.memid > 0 AND Bookings.slots * Facilities.membercost > 30))
        ORDER BY cost DESC;


/* Q9: This time, produce the same result as in Q8, but using a subquery. */


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

Answer: SELECT Facilities.name, SUM(Bookings.slots * (
            CASE WHEN Bookings.memid = 0 
                THEN Facilities.guestcost 
            ELSE Facilities.membercost END)) AS Revenue
        FROM Bookings
            INNER JOIN Facilities ON Bookings.facid = Facilities.facid
        GROUP BY Facilities.name
        HAVING SUM(Bookings.slots * ...) < 1000
        ORDER BY revenue;
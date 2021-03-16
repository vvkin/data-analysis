CREATE TABLE dates (
    id serial PRIMARY KEY,
    day smallint,
    month smallint,
    year int NOT NULL
);

CREATE TABLE genres (
    id serial PRIMARY KEY,
    name varchar(80) NOT NULL
);

CREATE TABLE countries (
    id serial PRIMARY KEY,
    name varchar(255) NOT NULL
);

CREATE TABLE languages (
    id serial PRIMARY KEY,
    name varchar(255) NOT NULL
);

CREATE TABLE persons (
    id serial PRIMARY KEY,
    name varchar(500) NOT NULL
);

CREATE TABLE companies (
    id serial PRIMARY KEY,
    name varchar(255) NOT NULL
);

CREATE TABLE movies (
    id serial PRIMARY KEY,
    genre_id int REFERENCES genres (id),
    director_id int REFERENCES persons (id),
    writer_id int REFERENCES persons (id),
    country_id int REFERENCES countries (id),
    language_id int REFERENCES languages (id),
    company_id int REFERENCES companies (id),
    name varchar(255) NOT NULL,
    description text
);

CREATE TABLE categories (
    id serial PRIMARY KEY,
    name varchar(255) NOT NULL
);

CREATE TABLE oscars (
    id serial PRIMARY KEY,
    date_id int REFERENCES dates (id),
    person_id int REFERENCES persons (id),
    category_id int REFERENCES categories (id),
    ceremony_number int,
    is_winner boolean DEFAULT FALSE
);

CREATE TABLE fact_types (
    id serial PRIMARY KEY,
    type_name varchar(255) NOT NULL
);

CREATE TABLE ranking_types (
    id serial PRIMARY KEY,
    type_name varchar(255) NOT NULL
);

CREATE TABLE rankings (
    id serial PRIMARY KEY,
    type_id int REFERENCES ranking_types (id),
    users_score float,
    users_norm float,
    users_votes int,
    users_reviews int,
    critics_score float, 
    critics_norm float,
    critics_reviews int
);

CREATE TABLE facts (
    id bigserial PRIMARY KEY,
    type_id int REFERENCES fact_types (id) NOT NULL,
    movie_id int REFERENCES movies (id) NOT NULL,
    movie_date_id int REFERENCES dates (id) NOT NULL,
    ranking_date_id int REFERENCES dates (id),
    oscar_id int REFERENCES oscars (id),
    imdb_id int REFERENCES rankings (id),
    metacritic_id int REFERENCES rankings (id),
    rotten_tomatoes_id int REFERENCES rankings (id),
    fandango_id int REFERENCES rankings (id),
    duration int,
    budget float,
    usa_income float,
    worldwide_income float
);

CREATE OR REPLACE PROCEDURE fill_dates()
LANGUAGE plpgsql
AS $$
DECLARE curr_date date;
    BEGIN
        FOR curr_date IN (
          SELECT * FROM
            generate_series(timestamp '1890-01-01', '2021-01-01', '1 day')
        )
        LOOP
            INSERT INTO dates (day, month, year)
            VALUES (
                EXTRACT (day FROM curr_date),
                EXTRACT (month FROM curr_date),
                EXTRACT (year FROM curr_date)
            );
        END LOOP;
        
        FOR year IN 1890..2021 LOOP
            INSERT INTO dates (day, month, year)
            VALUES (NULL, NULL, year);
        END LOOP;
    END;
$$;
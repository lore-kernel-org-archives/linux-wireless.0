Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37819 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZCZK6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 06:58:16 -0400
Subject: Re: [RFC] regulatory information interpretation rules
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	Richard Farina <sidhayn@gmail.com>
In-Reply-To: <1237712542.5100.766.camel@johannes.local> (sfid-20090322_100234_495492_0385D4F0)
References: <1237712542.5100.766.camel@johannes.local>
	 (sfid-20090322_100234_495492_0385D4F0)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jK0SdcKTzHLO9NeuFinq"
Date: Thu, 26 Mar 2009 11:57:39 +0100
Message-Id: <1238065059.4331.28.camel@johannes.local> (sfid-20090326_115820_137341_2C611338)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jK0SdcKTzHLO9NeuFinq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-22 at 10:02 +0100, Johannes Berg wrote:
> Ok, so I'm thinking about the interpretation rules for the regulatory
> information. I even dreamt about this tonight, unfortunately...

[...]

> Now how should you interpret this? I'll propose the following
> interpretation rules (and show how you arrive at the required
> interpretation from above):
>=20
>  1) MIN values are really something like MIN+, i.e. approaching the MIN
>     from above, that means that the value "2452 MHz" falls into the
>     first of the ranges, not the second [3]
>=20
>  2) The entire band a channel occupies needs to be covered by (any
>     number of) contiguous rules.
>=20
>  3) The MAXBW value specifies what maximum bandwidth a channel can use
>     which has its center frequency (!) falling into the given range.
>=20
>  4) The FLAGS specify restrictions that any channel _overlapping_ the
>     given range has to operate under.
>=20
> That is all. Now let me show how to interpret this.

Let me rewrite those rules, more formally.

Let's take an example regdomain with "n" rules:

country EX:
	(MIN_1 - MAX_1 @ BW_1), (MAXAG_1, TXPWR_1), FLAGS_1
	...
	(MIN_n - MAX_n @ BW_n), (MAXAG_n, TXPWR_n), FLAGS_n

And let's say we need to determine whether a channel, which
(disregarding modulation for a moment) is determined by its center
frequency and bandwidth:
	CHANNEL =3D (CENTER, BW)

Then the rules are as follows, now using the notation outlined here:
http://en.wikipedia.org/wiki/Interval_(mathematics)#Notations_for_intervals=
 (I'd use latex notation if I knew everybody was familiar with it, you have=
 to do with some words instead)

 0) (stated outside rules before) for all 1 <=3D k < n : MAX_k <=3D MIN_{k+=
1}
    [1]

 1) each rule in the regdomain covers the frequency range (MIN_1, MAX_1]
    [2]

 2) given C =3D union (over all k =3D 1 .. n) of (MIN_k, MAX_k] it must be
    true that (CENTER - BW/2, CENTER + BW/2) is a subset of C

 3) it must be true for all 1 <=3D k <=3D n:
	if CENTER in (MIN_k, MAX_k] : BW <=3D BW_k   [3]

 4) This is easier to formulate algorithmically:
    USE_FLAGS =3D 0
    for k =3D 1 .. n
        if CENTER in (MIN_k, MAX_k]:
            USE_FLAGS |=3D FLAGS_k

johannes

[1] this says "no overlap" but also "must be sorted" which can be
    beneficial
[2] this is a useless rule given the way I formulated rules 3 and 4, but
    it helps think about how it works
[3] given rule 0) the if only matches (at most) once


--=-jK0SdcKTzHLO9NeuFinq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJy1+hAAoJEKVg1VMiehFYmNYP/3GnGQPxi65pkmziGFOVAUru
fs4v5WZ5NOuXbrZBxqStAWFCpw20lkw26CnwZCPiGTiLtf/rZpbebMjOrLSR1bxr
op81U2ltyhtZyotc0daYGg1+CHjoZkiGTnUAPGsrPfMq+4QXEe9ZPe++RjQMOUfj
ASdg2xdV7j4xCVGX4iX9UY1E+8SDmjOjhe5Bojy1jjPZ98icgNqw9k/zFBfaX2IU
eBjMJnoj9iNpYC7kYfZBhF3hDgtwvRnMO7ZWnVyEIRua7bzm6Sa0t5G19b3/mOYZ
Enukfx02h79rqqyczDkTZr0z5sqSIf9/KrMp0z237NOPPGBq0Oey/oYRiIuh1Dk3
mDPxjuQAjljpVTLY87q/+vodgR82NhLpUO/ykHL3X3RbK6XloFL/N63U2l7d5Wz1
uK0aJMIEFj1Sz4ZJ2JdWNAHlXWXcDoVNOCfa/b6BooxOUCRj59hzQa4K6qQ5PC7u
9ThxD0zDUdz86Z+GlwXE2JrdqxSM2jxRRa4kcnJRRqNbg6LAxPl2ePXP6JF1kM8S
9GWNVHIQZ0qWARy2PuY7dJ0h0qlG7CPSrYR+qdaQC63mkn3OSfMAxXBPxekmw4B1
gH8Y5o7NGAPRUvQNcYo3AMX1N2ASld3EeOf1eII0nt5uyonT02AauM+GfVw4jJBJ
sD6arwIWYdDd03/4EpJk
=+KUp
-----END PGP SIGNATURE-----

--=-jK0SdcKTzHLO9NeuFinq--


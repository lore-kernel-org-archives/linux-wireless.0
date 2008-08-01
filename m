Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbYHAMyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 08:54:45 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1ba2fa240808010540g660cdaa9p1158a27061e3fcd@mail.gmail.com> (sfid-20080801_144007_421549_BFCC209F)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217425854.10489.125.camel@johannes.berg>
	 <1ba2fa240807300659p4d743f31se265f550a2da0dd1@mail.gmail.com>
	 <1217431179.10489.134.camel@johannes.berg>
	 <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com>
	 <1217509511.10489.140.camel@johannes.berg>
	 <1ba2fa240807311114t3e1b4fb3oe6643fbe28f2c2ac@mail.gmail.com>
	 <1217528597.10489.150.camel@johannes.berg>
	 <1ba2fa240807311216u1a45cf22j219046ab357b0910@mail.gmail.com>
	 <1217592554.8621.23.camel@johannes.berg>
	 <1ba2fa240808010540g660cdaa9p1158a27061e3fcd@mail.gmail.com>
	 (sfid-20080801_144007_421549_BFCC209F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JY5oLm3UPAeoJHOp3Bmr"
Date: Fri, 01 Aug 2008 14:54:39 +0200
Message-Id: <1217595279.8621.38.camel@johannes.berg> (sfid-20080801_145449_897169_666FF62E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JY5oLm3UPAeoJHOp3Bmr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-01 at 15:40 +0300, Tomas Winkler wrote:

> >> > Right. Which brings us back to the original point, why does the hw n=
eed
> >> > to make the scheduling decision between agg and non-agg?
> >>
> >> There is no scheduling between aag and legacy queue in the sense of
> >> qdisc .
> >
> > Right. So why are you saying we should have a separate qdisc for it?
>=20
> I need a sw queue for it.

Sure, you need to buffer packets, but that's a whole different beast.

> >> The aggregation need to be taken from single stream as
> >> explained before,
> >
> > I think we simply agree on that. Which brings me back to my original
> > point: to provide fairness within that stream we shouldn't have separat=
e
> > qdiscs for agg/non-agg parts of the stream.
>=20
> You agree on the fact that it's a seperate stream but you still
> doesn't want separate queue for it....

Actually, no, I don't think it's a separate stream, I think aggregation
frames are taken from the AC stream. I thought you meant that.

> >> Iwlwifi has HW support for it that that's the whole story we just need
> >> queueing support from the software buffering stopping and starting
> >> queue and last but not least there is a classification just an
> >> extension of the regular AC scheduling.  The fairness between legacy
> >> and agg queue must be provided by actually 'not scheduling'
> >
> > I don't understand what you mean by "not scheduling".
>=20
> Not scheduling mean not string to prioritize streams in SW. I guess it me=
ans RR.

But that's entirely user dependent if we allow actual qdiscs.

>  AIUI from the
> > specs, there is no scheduling between aggregation/non-aggregation
> > queues, or "within an AC" as I would say it.
> >
> > Therefore, I think we should remove the extra software queues and split
> > up the single-AC stream into the different hardware queues in the
> > driver, to be reunited in the FIFOs.
>=20
> Aggregation is a separate stream even on the air it has it's own
> rhythm.  For example
> from AP perspective you an have 3 streams for the same TID for 3
> stations. Each station
> has it's own rate of processing aggregation stream.  It may vary on
> number of packets and size of the aggregation
> this is determine in association time.
> So shell I stop the whole AC queue just because on station is slower?

If you want to draw up scenarios here, how about this one:

=46rom an AP perspective, assume three streams for the same TID for three
stations. No aggregation involved. Say they all receive a fixed bitrate
video stream. Assume you need all the airtime to transmit the three
video streams when all stations are fairly close. Now one of them is
further away and is a bit slower than the others. This will lead to
contention, right? So now, frames will queue up in the AC queue for this
TID, penalising all three stations. Do you agree so far?

Now, enter aggregation. The way I think of it (and Jouni seems to agree)
is that the spec intended for aggregation to be a mechanism to reduce
the required airtime by making the transmission more efficient with less
space.

On the other hand, you seem to think of aggregation as a QoS mechanism,
and I think that's wrong.

Ideally, for the first two fast stations would allow enough airtime to
be freed up so that the third station can still receive the video
stream.

When that is not the case, however, we disagree. I think that because
aggregation isn't a QoS mechanism, it should behave the same way as in
the case where no stations have aggregation enabled, and stall the whole
queue. On the other hand, you think it is a QoS mechanism, and let
streams for the fast stations be interleaved with the slow station,
leaving only frames for the slow station piling up.

Is my analysis of what you are saying correct? If so, I think we cannot
solve the fundamental disagreement here without actually going and
asking for other people's opinion on the 11n draft.

johannes

--=-JY5oLm3UPAeoJHOp3Bmr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkweLAAoJEKVg1VMiehFYRbcP/32p7qThyOqFZ7cpyn5PKVfV
6k55zC1hZRbWtL6PLdgyEet12rLAddjGzi5iwDuBmqPssYch36FHItZ0uBu4hRVi
33lp63mbrrlLUrTnUNN9Rd3j4/c75dXSmwnFQaBAwGR7AYl99jjCxbKNvcBhttBJ
gtsrMXJ3R9gJ21iI7K9XBlLQmNSg/cUaK7sy1Eq2D8hH0rmv7i1XZ/CCBNwRjjJe
/5RZVkcAVFYoVHkMfvI2MwtiwdqLb8PmXi+4HDCOWUCNcgSVyUbQpCt/XMr5jlH8
ytgisyh0IKt1wQAGgiOtm+nVVNKNcTWl9yXOvUjJ8hdGCZeQL4WGFaPSYW0KNhc/
lTx6KG6wY/UR5rSGGdBO6rwEJm9UEQls6x1TL/fCq6jlyviXsna1Rg0KGl6kGh3x
9YHzshvKpZ5ya8FatWQTy5bp4fIzKMNFy0e3vUBFXMEzFQfuvHKBixEJZN1CLYfA
iGgS2WwamFf/MTk6z2TeTHq2AAtmsGH9Nwtcwi2LDkxmYXh3wWdCbrp9QUqMo30b
dC5giBN99FVvEcUTubeM+FOKaMFB6p8V0FICLXzT4anFz9O9dI2fpwJ1B2FENQOo
7qH7uCDchuq1uMHy4RftYYTb8TDEOFU8wrH1ZFB7dX47BgDWhLaV2wzAgn1UIP7m
ov/yb+VBABsYL33NUn8g
=gx0A
-----END PGP SIGNATURE-----

--=-JY5oLm3UPAeoJHOp3Bmr--


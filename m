Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYLIVQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 16:16:50 -0500
Subject: Re: [PATCH 1/2] Add signal strength and bandwith to nl80211station
	info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Henning Rogge <rogge@fgan.de>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812092050.29545.hrogge@googlemail.com> (sfid-20081209_205034_859734_39B592C2)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812071917.07075.hrogge@googlemail.com>
	 <1228765415.22164.107.camel@johannes.berg>
	 <200812092050.29545.hrogge@googlemail.com>
	 (sfid-20081209_205034_859734_39B592C2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TXDbctT2YlcF+LPCFGxm"
Date: Tue, 09 Dec 2008 22:16:12 +0100
Message-Id: <1228857372.1029.25.camel@johannes.berg> (sfid-20081209_221654_084476_68ECB7D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TXDbctT2YlcF+LPCFGxm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 20:50 +0100, Henning Rogge wrote:
> On Monday 08 December 2008 20:43:35 you wrote:
> > And on your second patch:
> > > +static u16 nl80211_calculate_bitrate(struct rate_info *rate)
> > > +{
> > > +       int modulation, streams, bitrate;
> > > +
> > > +       if (!(rate->flags & RATE_INFO_FLAGS_MCS))
> > > +               return rate->legacy;
> > > +
> > > +       modulation =3D rate->mcs & 7;
> > > +       streams =3D rate->mcs >> 3;
>=20
> > I don't think this gives correct results for MCS rates 32 through 76,
> > does it? It should at least not calculate anything then. If we did it i=
n
> > userspace then programs could also actually calculate the correct rate
> > as a float, rather than this approximation. Not that it'll matter, I
> > guess. Doesn't anybody know how to do the actual calculation?

> It had a small type (corrected in the new patches), but I think the value=
s are=20
> good. I have attached a test programm to this mail that outputs the bandw=
ith=20
> values calculated by the function.

No, that's the thing, for 32 through 76 the calculated values are
totally wrong, that isn't a logical extension of the scheme, MCS 73 for
20 MHz for example is:

four streams, using 64-qam, 64-qam, 16-qam, qpsk with a coding rate of
3/4 for a net bitrate of 195.0 MBits

johannes

--=-TXDbctT2YlcF+LPCFGxm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPuAZAAoJEKVg1VMiehFYj2YP/2WxIOCGTiKKT5c0HbUIz5MQ
wjB+/GDY1r+Ck3wYN+kvlIPalj2m/CAmnFjCNTk164BHZJdGWLZNgzAnvK7Dnhoi
NOFXnMcLqaa3uZvUZxvMDybmEV9wy7zD4Wb46eExquL9SpTJWQEr4d0cStiufVA9
6lEQYPQSD8JEeVjwTGZ+9IciyYE5dn1sBCbn7I3/1IsXvsHMoCRkcPOv0mdnTjbK
PMi6TJ6MwwwCW0RtgTlntxtqjMVn3HBOLtXV6ifFHy0YZbNSCHBFxuw7MUKSZGwr
ac0HeWU4qdX1YpcDlbTOfZu5fEA+xwf5gNsGYYgdRsuhuBY+6gp/jpap9swr87e4
niG5St3k01WNTnA6Vs9c285nUc9sQfCZegkEfRUfFTMzNIOiPRy5jC9aRN2ojPmq
wjVDe9QFZZ2xu4AvZaGphJX/aZq1mKLsyILodBywQM9b4PfH72vTo7kKU0dz3UFB
hR2bPYI6DySSa0eaomNzmJTKDEnptdWEN7+Hm5ecirf51Ia6/sgckB9OkBgZ2BK3
kNfvzs9fIKQ6GMVEjUu3Sc8bsTbjYyHmvQ+tb2Hnua884cYPiTCCuIbdzgI4ARyt
8jJxktmRmRUcp4wxXT8k/d/lT6VophNlapozLgegkn6Obm/2ePc6NYqfw1cnojY4
mEAFDDGoHa5tHu1QbsTM
=MXH3
-----END PGP SIGNATURE-----

--=-TXDbctT2YlcF+LPCFGxm--


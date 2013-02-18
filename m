Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:25532 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751652Ab3BRQIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 11:08:05 -0500
Date: Mon, 18 Feb 2013 17:07:05 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
Message-ID: <20130218160705.GD4162@open-mesh.com> (sfid-20130218_170809_945880_6075D3A2)
References: <20130215171938.GA4140@pandem0nium>
 <1361197831.8555.23.camel@jlt4.sipsolutions.net>
 <1361197982.8555.24.camel@jlt4.sipsolutions.net>
 <20130218144622.GA4162@open-mesh.com>
 <1361201387.8555.32.camel@jlt4.sipsolutions.net>
 <20130218153833.GB4162@open-mesh.com>
 <1361202206.8555.34.camel@jlt4.sipsolutions.net>
 <20130218154906.GC4162@open-mesh.com>
 <1361203098.8555.35.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OROCMA9jn6tkzFBc"
In-Reply-To: <1361203098.8555.35.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--OROCMA9jn6tkzFBc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 18, 2013 at 07:58:18 -0800, Johannes Berg wrote:
> On Mon, 2013-02-18 at 16:49 +0100, Antonio Quartulli wrote:
> > On Mon, Feb 18, 2013 at 07:43:26 -0800, Johannes Berg wrote:
> > > > I did not like this approach because the sta_info struct is so big =
that
> > > > when we want to fill the stats substruct only we will waste a lot o=
f bytes.
> > >=20
> > > I don't understand your point.
> > >=20
> > > struct sta_info {
> > >    ...
> > >    struct stats stats;
> > > };
> >=20
> > My concern is about those "..." that we are allocating within the sta_i=
nfo struct
> > that we will never use for every non-peer station.
> >=20
> > While if we used the struct below (with its own hash table), we would a=
llocate
> > only the space needed for the stats.
> >=20
> > >=20
> > > struct stats_entry {
> > >    struct hash/list/whatever;
> > >    struct stats stats;
> > > };
> > >=20
> >=20
> >=20
> > no?
> > Maybe I misunderstood your idea?
>=20
> But I'm not saying that these are mutually exclusive, I'm saying both
> should exist.

Ah ok..Sorry, but I did not take this as an option :)

So, if I understood correctly, this means one table lookup for peer station=
s,
while two table lookups for non peers (first in sta_hash, which will fail).=
 Right?

This would save one look up for each peer, since we have to do perform one =
of
them anyway (now I fully understood your previous statement!).

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--OROCMA9jn6tkzFBc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRIlGpAAoJEADl0hg6qKeOd9oP/2NTQpCupELt/WsuNP0h+V+v
rgi8ayjr1LLkIGBgFrT3P9LWPCCk4/SrEHm0J0knd0W/95WyLJXn9HY9EdbKZb/y
GDG+5w1fUjAuoZbOKjoZ2321J86hpYcuFBRl2JO9EEyilMwFqUYMc8CRiU33meke
Lw0tAEekF5PvlVT6qpajEiH7O6soCQwFaJeHjsl7SkxkYF0UkwZOtF1RF8b6BFEd
YFiuKCBQ5OesTefmEidjWk3l9tAvU4rOJtPrGkWfYC31xc4pmgVlKhm/ZzUQLE6V
aRxAjSSTvkYv7Qa0N8kejD6t8n2TMFb6Km9jiHBpw3QjV+qToQhfL0yfnucs8xwv
iuRciwiojSMWUgS37+kVOtR5FkcwgsaNwlX7tqkhJLAuSTQoglwSa1qFlZXT54s8
443vHdIfN5xfMlT1ciL8f4ReT4fB4MBa68NBdZzXbK59rk22SA7k2mPjs02zyRSv
ay6fT/ZMEWakWtfmik/qfwcKkyUykzS31a9f+MhXVqrUB3OkDsaP3JuO/MGQYG/T
GUch3h19KpVVtGZ8fckZLr3+Px3qmL3GtzrMrh3aBekd6F39zolsM5tRG6rIuUIt
O5By9wzksbVBZIsSWycQw6ALGo/bzgvock5atYzvjZJAVdj7N9foc7Fei6pEVwOU
VQ9UnISIdnD4N2on9WwD
=Lyow
-----END PGP SIGNATURE-----

--OROCMA9jn6tkzFBc--

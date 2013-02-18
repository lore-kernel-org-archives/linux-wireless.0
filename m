Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:3312 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751852Ab3BROrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 09:47:25 -0500
Date: Mon, 18 Feb 2013 15:46:23 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
Message-ID: <20130218144622.GA4162@open-mesh.com> (sfid-20130218_154730_107752_602FC27C)
References: <20130215171938.GA4140@pandem0nium>
 <1361197831.8555.23.camel@jlt4.sipsolutions.net>
 <1361197982.8555.24.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
In-Reply-To: <1361197982.8555.24.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 18, 2013 at 06:33:02 -0800, Johannes Berg wrote:
> On Mon, 2013-02-18 at 15:30 +0100, Johannes Berg wrote:
> > On Fri, 2013-02-15 at 18:19 +0100, Simon Wunderlich wrote:
> >=20
> > > Commands we would like to propose are:
> > >  * start collecting - this feature should not run by default to avoid=
 bloating memory for users who
> > >    don't even need this
> > >  * stop collecting
> > >  * read - dumps the data for all stations
> > >  * read + reset - dump the data and reset information for all station=
s. This should also clean up stations,
> > >    at least those which are not connected to the BSS, to not bloat th=
e station table.
> > >=20
> > > I guess the right position to implement this is mac80211 receive path=
=2E Our intended platform
> > > is ath9k/ath5k, but that feature should work with any mac80211 driver=
=2E We don't care if sta_info
> > > structs are allocated or custom structures are used, as long as we ca=
n receive a list of stations
> > > which includes peer and non-peer stations, along with their statistic=
s.
> > >=20
> > > We are looking forward to your thoughts. :)
> >=20
> > I would argue that since most of the sta_info struct is used for
> > operational stuff, you shouldn't use it, but have a separate struct and
> > maybe embed that separate struct in sta_info for its statistics.
> >=20
> > I'd also not use the existing nl80211 station APIs since this could be
> > an optional feature for many things, and it will likely break existing
> > expectations, e.g. that all stations listed by "iw wlan0 station dump"
> > are clients connected to an AP interface.
> >=20
> > It could be argued that this API then should also not even include the
> > connected stations when listing ones, i.e. explicitly be non-connected
> > stations.
>=20
> Or maybe use the APIs, but require including a special attribute in the
> dump/get request message in order to dump/get the/a non-connected
> station(s), and only include those attributes that are relevant.

In my current implementation I created a "twin hash-table". It contains
statistics for *all* the stations (peer and non-peer).

I think that instead of embedding this new struct (let's call it sta_stats)=
 into
the sta_info one, it would be easier to let them be independent (this is wh=
y I
created the twin hash) and then create
a pointer from the sta_info to the related sta_stats.

For the API I think we should create a new nl80211 command.
If we simply add a
flag to the normal "station dump" command, we would not have all the attrib=
utes
to print (keep in mind station dump prints attributes that are in sta_info =
and
that are not in sta_stats).


Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRIj6+AAoJEADl0hg6qKeOiv4QAKf4JwKITiORvgIwOoDhl9+y
d4caVwMrXI4m1iuByrVYmsHHuscp2xGk5eJajGmoefH0zqaHYnES8HVRCWKReZkV
W04rqf+f4FsHCb6bf95hHDh7Je5rnqYXNJa0FzzEqHqDP7Bkt6rONyKuqMjjLzc1
Kk3iZF4hIemgKZEmo4radw3+90Ay2C/RQt1nUfv0hNsC+Cqwgi6zvxxW5LJtvkJZ
kMRSm1jORFaVLT05Qj3cQ/ofdzEOmgzVZakDn0XHkAF3exTvc/aU62sdIz/ES3mG
1jlHrvzK/xYI8C1AXN7P1Iiohe4mxlKxw0tImcuU9l0jFsEbuvdNVXy1rpc4fyLH
PVxqJP2QVOvEtHskczu6Xpc7fdyyFD1F7812n2HsYlZXvI3QkBBdvqsMaAwg7HvX
VAdlpD7C7oP2elk3mso7/QLklqihGA5mGua2CLk5SVp+gmOmV4e/ZUL5L69NVi7N
C75f4UF4KIUNLmX+aEl7+idgkHv2bk0E3sLecvj8jzGw5STXFSivqwRsBuMlpQDo
a7t+BirMgoDQXcp5ZkfpeEIdsJu6erBZgw8HttLwQcihKlS1P6/zRFMP9lKoQ7l1
SIrfR4tXX1mEuRFispy5pSOT7PQheCkJW0yFjQkiXLEHejH6BCD89VxCnD7USbkx
pVsA7HTsTwe3p2V0DZen
=9awQ
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--

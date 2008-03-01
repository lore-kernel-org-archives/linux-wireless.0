Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbYCAKQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 05:16:19 -0500
Subject: Re: [PATCH 01/13 v2] o11s: (nl80211/cfg80211) support for mesh
	interfaces and mesh paths
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1204335110.7735.30.camel@localhost> (sfid-20080301_013020_804923_984AFACD)
References: <47be7703.20f8720a.1044.6474@mx.google.com>
	 (sfid-20080222_071730_424685_4330467A)  <1203695866.7082.49.camel@johannes.berg>
	 (sfid-20080222_155831_933711_8528D283)  <1203955392.13162.111.camel@johannes.berg>
	 <1204335110.7735.30.camel@localhost> (sfid-20080301_013020_804923_984AFACD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-u00O3zrfAsjRBh04Rzzq"
Date: Sat, 01 Mar 2008 11:16:10 +0100
Message-Id: <1204366570.3938.72.camel@johannes.berg> (sfid-20080301_101641_097242_570E22DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u00O3zrfAsjRBh04Rzzq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-02-29 at 17:31 -0800, Luis Carlos Cobo wrote:
> On Mon, 2008-02-25 at 17:03 +0100, Johannes Berg wrote:
> > Can you do that in both nl80211 and mac80211 for both STAs and paths?
> > Look at net/netlink/genetlink.c ctrl_dumpfamily() for an example.
>=20
> I'm not sure I completely get what changes are necessary.

Actually, none are. I was totally wrong about all the stuff. Sorry.

> What I understand is that I should acquire (if idx =3D=3D 0) and release
> (just before returning -ENOENT) the rtnl_lock() from within (mac80211 or
> equivalent) dump_station function instead of from nl80211_dump_station.
> Is this the whole idea?

That was completely wrong, I was trying to guarantee a consistent dump
but that is impossible.

johannes

--=-u00O3zrfAsjRBh04Rzzq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8ks6aVg1VMiehFYAQICwRAAoq5GsWAh4yJBEQJnxn17Z6GcBxhBqKlG
hNzcMZNyzCYFPEA6WY21l8WnTgO+dBJKneqEmU3rPxEL/yLB/AuHf6+1VEF9kcP5
M6dJxloxL7SDHsn+pafvPzCoG5olbR/0ppgqhXvJ54QXjo2FD2uSPkkDETZ6/TPn
DDYj0gP2UW/qYArVkx8lLNrsjX0A8tQpwUjwwjgiagolptQaf1rNQ4vLgkXO7lwA
5/AoA/eny4kaI8QbxreJwOG1v6Wrn50k4IqFB+HUBtRq3v0D/hcZSzlalp7FAMsm
orJeAQgcI8trVlU+6aY+5s9BJhiWFHNsniSlsI2yo04Trv4mZ53OnUzxIe3SIBE9
8eQWm32RrX3G+W/s7jCcAUTPiK28lGk2SUvR6Pg8ymhasENM4JSyyxPHgwV4YNJu
nVwhkFe408LfjeaFrKo0BwrArf95kgHWvTA9+eexhrsdSR0jIA2vNoR9jyVWEzDZ
iJtL/BbwC3yb2TG2g3YELDJMKjJwAGC4omt1gKC6vqpWp1tNWQDmvLb9d9wuDtt9
gKza1cyEsCwfthx3N+gLdizUEKEcQ/UENOaur8QgfiF4Yvr52Cy+LmfaQuR4k2gH
2sTO4HQxJ/ziUk6ybNtVl9fsoFlvaeVD6vksZUxrnirUVKv5AqRgJRmWxoHtYJZc
43u0paFMfiE=
=GtRB
-----END PGP SIGNATURE-----

--=-u00O3zrfAsjRBh04Rzzq--


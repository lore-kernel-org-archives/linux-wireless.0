Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45224 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYCAJ1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 04:27:08 -0500
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
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OyWpSupn2AX8kJ2CWnfu"
Date: Sat, 01 Mar 2008 10:26:56 +0100
Message-Id: <1204363616.3938.63.camel@johannes.berg> (sfid-20080301_092736_447642_1501FDE0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OyWpSupn2AX8kJ2CWnfu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-02-29 at 17:31 -0800, Luis Carlos Cobo wrote:
> On Mon, 2008-02-25 at 17:03 +0100, Johannes Berg wrote:
> > Can you do that in both nl80211 and mac80211 for both STAs and paths?
> > Look at net/netlink/genetlink.c ctrl_dumpfamily() for an example.
>=20
> I'm not sure I completely get what changes are necessary.
>=20
> What I understand is that I should acquire (if idx =3D=3D 0) and release
> (just before returning -ENOENT) the rtnl_lock() from within (mac80211 or
> equivalent) dump_station function instead of from nl80211_dump_station.
> Is this the whole idea?

I think it's a bit more complicated because nl80211's dump_station() can
also be invoked multiple times.

To guarantee the cfg80211 rtnl_lock() promise, dump_station() should
acquire the rtnl and all locks it needs when it first enters the
function (oh. that's actually a bug in the other functions too, they
should acquire the mutex conditionally, will fix).

mac80211 also needs to acquire the sta_lock because otherwise stations
can be added or removed while dumping.

I suppose the struct netlink_callback needs to be passed through to
mac80211's dump function with the limitation that the first two entries
are already used by nl80211...

johannes

--=-OyWpSupn2AX8kJ2CWnfu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8khX6Vg1VMiehFYAQI0Aw/9Gr5EJx+Ud/XMQU9LoKRGrYLWGcp5gv9G
wtNEI2SHhuT85AS2CnKTB6NXM9UI2dyxTjJf/SfZ1kAjEtM+h2G84g1GcJiaU7JY
a3DX/xKTyaVu2rJOmAA9vnwR4yDXbEoAwuUDBb1eh9X/k62t9QmabG/WhYGKsYHK
fLu5xm+YIX5XzWX6oTcyNqWR8wcR2jE++YQN2J3cUDDVr9wZ+RdQWRURNJHEBFZJ
bMAJFP0hBRMa/PccuqsN/eaQimJN89UD0O2N/5+8U1Nj4pWySRZF2zI0FN7bctz0
uYxu3aPxv5wkuQJ5g4pGrZ7bnS4L9hWjz7ZtsebKuUkYmS5c3Ex3b0cd6oNfYOMC
Hw4Z1tImknb+DSWQ82tC9hRgonzj2j7PdpV5AhZmIw1ier8FubZ+93Zq211dVH51
IzjxyMpdABo0Wi/lBjaSaO2R9uYZb4rsMIjRPPiNvGn6ppWE0H04o+fH6iiCkb0D
IZq++Yow+KcUDOQNrkvJtOsD23Uyfn1i6cNSW35O8r2kgc9KRXBBtuV/HeaNiIYJ
X+++YU22rZdH/t0ifvn8p3D6Vyg7aVXyizBmU0AEK31zuiQ6urNmnHDBDjCYp784
ZE7hhmkpvBFMo/h+pNUnPdDjGRQz20KSFzP6eT1oV1eGEuEeSBJJA1RPKGyp2Bfc
JiJjYrNM+ic=
=8+wc
-----END PGP SIGNATURE-----

--=-OyWpSupn2AX8kJ2CWnfu--


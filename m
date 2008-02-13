Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38570 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYBMMIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 07:08:14 -0500
Subject: Re: [PATCH 02/13] o11s: (nl80211/cfg80211) support for mesh
	interfaces and set_mesh_cfg command
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1202516743.7025.20.camel@localhost> (sfid-20080209_002444_593114_CF652DE8)
References: <47a7825f.03b48c0a.7362.5cd9@mx.google.com>
	 (sfid-20080204_212410_095702_D5CB4C0C)  <1202343489.9965.47.camel@johannes.berg>
	 <1202516743.7025.20.camel@localhost> (sfid-20080209_002444_593114_CF652DE8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uiAmiUpomsyPlseddLyT"
Date: Wed, 13 Feb 2008 08:51:29 +0100
Message-Id: <1202889089.8931.14.camel@johannes.berg> (sfid-20080213_120823_236709_C3C070AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uiAmiUpomsyPlseddLyT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Somehow I kept this around, sorry...

> The mesh ID works as the SSID for mesh networks, on mesh beacons/probes
> SSID is set to the wildcard value to avoid interfering with non-mesh
> STAs.

Right. So it's just the mesh identifier.

> An MP only opens a peer link with a neighboring mesh peer if you have
> the same mesh configuration. This mesh configuration is composed by the
> mesh ID and path discovery protocol/metric/congestion control IDs. Once
> the link is open the mesh ID is not included in the frames. Let me know
> if you want more info.

We don't have settings for the other control IDs yet, or did I miss
them?

> It might be a good idea as you suggest in another thread to refuse to
> change the mesh id for running interfaces as it would make a lot of
> information stale, will consider it.

Ok. I think this is quite a difference to the SSID where you can roam
between networks, but I guess that roaming between different mesh
networks doesn't really make sense since the point is to be part of the
mesh...

I still think the mesh parameters could be per-interface attributes
rather than require a new command, but I'm not too fixed on the idea
either (although currently it breaks the get/set/new/del grouping.

Another, off-topic in this thread, question: How is beaconing defined
for a mesh point? Is it similar to how it works in an IBSS?

johannes

--=-uiAmiUpomsyPlseddLyT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7KhgKVg1VMiehFYAQKC5g/+McqXBvoIZvtxVeo5woKRPCTyVGGJ50ru
t3sWUCJpw7HsPieGDQhjqEIbacigXVa88aCWDiLB6PWbHelxNiG5YkRtj44yljn9
94BwEEnPV/qi68dkcgNIi/ZoHpaUqEdrey3oPZzLcwpHw1UONuhz0H5F9m/icv9x
8+YGAHWoMjxAXvfD1XfVNIHFxeX2egm6POokDg/hJ4zBbICnQPvmdMbsx4oqQyke
Z3UNngwSHyiIoM4Xw8cOkcqIcYBiSfytH4BDYxT91DOUa2ukQmm0zyaBmTlcmyIV
x3tnYJVmTNn5IwZxT+PSFiT0+Ul9a9Pbj451RwPG/mSeiSBwM1gQUqtyjkefAZmA
S9V8epauLBhmiOwQmLWrcvcgwEWHSOZ2kUn+xiwu1cworsOHNU+vYGqRi9mA6S4J
4hdiBNnGyUdAV2U75B6ugjInxKV+Oc4t0FzKpyYwrJ+lPTxl+5I3/8IZv3i0i2Ao
Co0Pg/ZDt58XfRLLcq3SM0jB9sUlCo4tp/RiPKFV5lkMiHDYy+lk0VnJS3b5J1CU
pkyT2rE1jEauFWm7GKz+9ovXztzd3jcifca4bKVgIuP3SqgWl1y0z+W/4ojxxfqb
dzhhrnlII0fAT+rdje1/gnabqjnsJgPob5Z6cX5fcmvMdmfgfbhSIeDg4Rl0kGXq
SLK/iYUzU4E=
=tls4
-----END PGP SIGNATURE-----

--=-uiAmiUpomsyPlseddLyT--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55630 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421AbZKRVVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 16:21:32 -0500
Subject: Re: mac80211 breaks suspend to disk
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1258579170.4525.2.camel@maxim-laptop>
References: <1258568836.4512.13.camel@maxim-laptop>
	 <20091118202802.GE2911@tuxdriver.com>
	 <1258576749.8018.7.camel@maxim-laptop>
	 <1258578199.30511.80.camel@johannes.local>
	 <1258579170.4525.2.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-J29kL52cClE+otMq3R1T"
Date: Wed, 18 Nov 2009 22:21:01 +0100
Message-ID: <1258579261.30511.84.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-J29kL52cClE+otMq3R1T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-18 at 23:19 +0200, Maxim Levitsky wrote:

> > Then again, we drop RX frames while local->suspended is true, and I
> > guess we don't really care about missing a few more frames when we're
> > just waking up, so it should be OK to keep suspended =3D=3D true while =
doing
> > the startup.
> >=20
> > EXCEPT drivers are going to start using ieee80211_queue_work() already
> > then from the callbacks, which we must allow.
> >=20
> > So ... maybe this?
>=20
>=20
> This will likely fix this problem.
> I will run my suspend/resume loop for a while and let you know if it
> works.

Thanks. I'll take another look at the code to see if there's another
code path that could now end in warnings, but I don't think so.

I suppose you could reduce your AP's beacon interval to make it more
likely to trigger.

johannes

--=-J29kL52cClE+otMq3R1T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBGU5AAoJEODzc/N7+QmaHmIP/3/G5FObmM1K70/JOFDUiuS0
LCusauVAUyVfhnfH/bMKHtaX7IV3hQis2ipYP4F0y/D6nFh3pcNERNJnZEIplJjq
jZWbRR312JnKK/8Yze3Z7eh9saBEpldLtPlVpJVTnmKhTgDCqltP5cRGeGw1MIdM
kLX0ZkE7ffB5I7+JmXjH3Z5fbTfBlKlTsnpG1f5d5HvZRsvE8WOoM93NgEsC4IDe
k0+WlZVje/bIZgUcO/f8jMVEe4rkEwf/6cx7ZpQOB7G7eS+5avNAwk2rKkaeJ0mL
VdGcjLHKQmVmOjl8Rlj5hEWcGMPh/DBXOHrWFJ3pUFN2y3cfP1IOBk41/VXSnwfE
dIa5U3w7sMrjt9xgIyiErVe3g4Bh7ODhtYRKTVnI6WUt7r8E607SJRdtZfNkgUoK
HITDZK0/FeWKRmZ3rVBaXWZbDSkwbLaFUCi0638oorVyDauExWPAzEOQdIlisxiT
FzOupI0T2I5NAqr3MNyg2sgTTeHnO0DfYsLGZYEhP/BTwFfaYaJm5Ej+aOA0IAAJ
v6ZpIucWqUAkmkH0T0p4Usql9efC/XV59bI2M3rze/4mhO/6NhkJ+vPqpJIYn3cX
Tdt/r2DNBuMeNHL5+fQ7GTDgcrfEgrwFrR4663llOBg8hX5XCaeWfc/Q2edIN/GV
VFM3Otj7MEGuSIxo18Lx
=LuoU
-----END PGP SIGNATURE-----

--=-J29kL52cClE+otMq3R1T--


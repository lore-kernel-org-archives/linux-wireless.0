Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZFFRmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:42:19 -0400
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200906052101.47168.mb@bu3sch.de>
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net>
	 <200906052101.47168.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Z9s+/RukPsmSQ2oYzIaM"
Date: Sat, 06 Jun 2009 19:42:18 +0200
Message-Id: <1244310138.17485.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Z9s+/RukPsmSQ2oYzIaM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-06-05 at 21:01 +0200, Michael Buesch wrote:

> >      The rfkill polling routine brings the interface back to the initia=
lized
> >      state if it is found to be uninitialized. This way the rfkill swit=
ch
> >      may be interpreted. In addition, the radio LED is not turned on in=
 the
> >      initialization routine unless the rfkill switch is on.
>=20
> This is pretty silly behavior IMO. Just to bring it to the point:
> We initialize a huge wireless MAC, PHY and Radio that consume several wat=
ts of power
> just to poll a silly RF-kill bit.

1) you're MUCH overstating the power consumption
2) we don't actually have to turn on the PHY, just the MAC core, if we
   can do that, but that requires some refactoring afaict

> We can't we just accept that the RF-kill status is unknown while the devi=
ce is down?

No, because then we don't know whether we can allow users to bring up
the device. We could work around that and bring it up, check rfkill, and
bring it back down return -ERFKILL to the user then. But then guess what
will happen: userspace will have to poll rfkill again.

> I really do hate all that rfkill crap and I'm still refusing to sign off =
on anything that's
> related to rfkill (like I did for the past year or so). If people want th=
is merged,
> somebody else maintain and sign it off, please.

Fine. Just don't stand in my way then.

johannes

--=-Z9s+/RukPsmSQ2oYzIaM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKqp3AAoJEODzc/N7+Qma9rQP/3pmphN/OZC6NMK1ew29DVpl
B0yCHp+p96kH5+MHp9I2GK/bmEduxM0DLOz4iJfCcBXPWiQLGfSi3FQaCMrjmuFQ
TP3D8125zCDE8cI87LTq5JaQBDRiWhygoaVG7NDU8EFh9fwRo/73lILTpMATqvYY
9TY2UjNiVSvPmDE+eRghwBs2BMzoCyTO2Ak4OGGvJdOKOXS/R9zytuBdxJxuZ9re
O4QbNC6KwZe86bBldjyTc8tN/ShMQMWO98RPOich2QJysqnyd1NWEGR4xoXDxnpk
67At6cNn6K1UZfnWe8+AfeB6Li7Df+Fc4u0G3Z0w+Kli34XLdmm2YNaXp17vrDGw
FLFccQfOI5W7gCN7g1ZLhnYfxmIenlBaB6j+8/xAHfLDmnx1ShTYj0fpynk+a8eg
hkHbSswk1f9r+mm1jKsxlYkpRTxb61Bx6qsRLaG98QgCApW5ihzvon4Vwk4mINfF
jbRCPbSygY6GtCZVIlijRFGhq/5vXA4obXv0eTqr5xdtTgMtX4Tbromt5DpF9yp+
+lfZ1XTo4bYWdYauIOaCXoXBkVhHE4wp8D997LFO+pMistGei9oSEHQTaVl7LG8S
iVZSvUtHn8vukQpdT0pZtcw3a8YipknhqPYGG7rQ2IKKWdC8VOvsjesILaH79WVe
9/QED+KqDjf4qkOPGMeP
=7u3o
-----END PGP SIGNATURE-----

--=-Z9s+/RukPsmSQ2oYzIaM--


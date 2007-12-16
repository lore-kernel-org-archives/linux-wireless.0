Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbXLPWRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:17:49 -0500
Subject: Re: b43 problem with led trigger registration
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1197842962.4653.27.camel@localhost.localdomain>
References: <1197822019.4138.2.camel@johannes.berg>
	 <1197837505.6769.25.camel@johannes.berg>
	 <1197837799.4653.21.camel@localhost.localdomain>
	 <200712162157.00759.mb@bu3sch.de>
	 <1197842962.4653.27.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dlzgASjMXaYD1KJ5LwUz"
Date: Sun, 16 Dec 2007 23:17:44 +0100
Message-Id: <1197843464.6769.43.camel@johannes.berg> (sfid-20071216_221752_911620_ED7307E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dlzgASjMXaYD1KJ5LwUz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Eeek, yes, its the LED core's fault.
> dc47206e552c0850ad11f7e9a1fca0a3c92f5d65 is needed for various reasons
> but that means the patch below is also needed. Its been compile tested,
> once its runtime tested I'll push asap.

Any reason you're using an rw semaphore rather than a simple mutex?
Nothing here is a hot-path, is it, and the led registrations are
mutually exclusive anyway, no?

johannes

--=-dlzgASjMXaYD1KJ5LwUz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2WkB6Vg1VMiehFYAQJwLw/+I6J2F2K84k1N5bCW7E8d6Tsv4rwf3otE
qbSznxOlcLNBz5v661HZMwDJv7Qpc6evjpVGIhW5W7pMb+AAawO3UlPnGuP8vem5
vrzruoNM/GR1omahPgI2pzCWmwTJaFDzq2eZifJuPzyVPVg7Gvv16KzAOT7vTHsD
VSviU7tPp1tDTZhM8ANoGgSziMemXgPpAXLoQ/Hg7FTLrzAsF+isYbt+bldGVa8a
6cWRakUTaR9yw3hpSM3t9ubtf/dxQAx+5bmnnwo3vBjAZMzzADa7ryjQgCmwa31f
CasXQAXx/0Bb5A6036zGklxVF2auz0Gs0Pkot1fU2kO4irSKyM/1SuL0zx65UMIr
1OdrlP32E0Q6u9nY2tYorS0GOBJWaoN255ukMRilMgoGFMXTWetM9OZAdiks9epL
mS7Z6mR6wFq0d5rOO5hIbqa+QnSvQ39OoeWmOvMtSGb612HhHaVFt6VfixtFtSGL
RvRY65mAd8VcC+OoJlKA9MGLRtt2dEDaaaV4unWCXISlDLArhILuIz86UdOpN4GV
Nl8a6xaASUh7NO48+EvUZDENS1cd6tRjp2wTyDXx80XHY9ZkdTlylL/mB4/QH0Zu
377VolwmPm5wEu1WFYvuyqIISu1sPGK/Ffv651KwidfG9KYL5n0HsmVUXe4RVxDJ
CM0wRGOWd0c=
=+dpL
-----END PGP SIGNATURE-----

--=-dlzgASjMXaYD1KJ5LwUz--


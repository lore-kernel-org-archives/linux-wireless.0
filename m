Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38682 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbXLPT7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 14:59:41 -0500
Subject: Re: b43 problem with led trigger registration
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Richard Purdie <rpurdie@openedhand.com>
In-Reply-To: <200712162036.11084.mb@bu3sch.de> (sfid-20071216_193853_032514_3571F981)
References: <1197822019.4138.2.camel@johannes.berg>
	 <200712162036.11084.mb@bu3sch.de> (sfid-20071216_193853_032514_3571F981)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YQnbPNpAh0LwZ9fpJ99+"
Date: Sun, 16 Dec 2007 20:59:36 +0100
Message-Id: <1197835176.6769.21.camel@johannes.berg> (sfid-20071216_195944_678763_E2E6F4EE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YQnbPNpAh0LwZ9fpJ99+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I have no idea where we enter atomic state.

Uh huh...

drivers/leds/led-triggers.c:led_trigger_register:

|        read_lock(&leds_list_lock);
|        list_for_each_entry(led_cdev, &leds_list, node) {
|                down_write(&led_cdev->trigger_lock);

introduced in

commit dc47206e552c0850ad11f7e9a1fca0a3c92f5d65
Author: Richard Purdie <rpurdie@rpsys.net>
Date:   Sat Nov 10 13:29:04 2007 +0000

    leds: Fix led trigger locking bugs

I guess the read_lock needs to be a mutex/rw semaphore.

johannes

--=-YQnbPNpAh0LwZ9fpJ99+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2WDp6Vg1VMiehFYAQK/cxAAoxDx8XSOYfv5ntBD4Y+AWjH6RB1oBRkC
z7wGDi4dvCFtdTTyB8NDcboJUZlgw9DYZ9PLflaMtAAikc/+DEp2zaOv/zefmdDQ
FufGOy7Mo6FCZoTKVMVeYbBxLB8atVS7hrtGDmXuA19b+6bp19i1LbLanWu0GTcc
Xbs9BB0jZQfF9FIm6XUqmrnzlkuOO9VGTuR6bDW37yO56cy1ECcb68bOZbd3W8fH
ULXjWd18CwiGawEIBhY9r/oAEGFcu/gtPuvrwKWwaDKe8IcMDF5WRmibRX2V3ZFk
mFX1Rxp8G/pxkxB3M3QM92JSbvEyY9oKK+BNCXDzYCKS5UKALBeBpaOfF9Xfd+D/
JLzZ/FGNYpKoZfC+8d+vo4CGCmEauNFwBYwsNsjo10Se3WXs/w4/ztC1cvg34U3M
ItYzmxxbbImQr0Ox5EU4nZPaeml3iF9Maoe8jkXg/Mf8QWnKT8wduZavmosyP+vl
du3W25ulI+0/IUsCWLygOAYq3+LSG3eIrQfB294IZC2+Spdu+D3ZjazFm9Nx/mSG
Ygis9rD4lfe+8JTrOX8566w4t85c0r8zWuP4EDel05WDveUfnP+uP5LpFjGcF/rG
A+1R/XWzsjA+EyMV9aEB5BZqG5mEU6ZiPhUYdntyPlg107H/AN4x3l7hTZ2Q/KMy
npI71EFLOPk=
=WfuQ
-----END PGP SIGNATURE-----

--=-YQnbPNpAh0LwZ9fpJ99+--


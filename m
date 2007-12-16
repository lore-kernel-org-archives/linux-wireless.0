Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbXLPUi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 15:38:28 -0500
Subject: Re: b43 problem with led trigger registration
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Richard Purdie <rpurdie@openedhand.com>
In-Reply-To: <200712162126.56483.mb@bu3sch.de>
References: <1197822019.4138.2.camel@johannes.berg>
	 <200712162036.11084.mb@bu3sch.de> <1197835176.6769.21.camel@johannes.berg>
	 <200712162126.56483.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C4ugSvK+HLKYvO1o2dJU"
Date: Sun, 16 Dec 2007 21:38:25 +0100
Message-Id: <1197837505.6769.25.camel@johannes.berg> (sfid-20071216_203834_318779_C51C7629)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C4ugSvK+HLKYvO1o2dJU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > drivers/leds/led-triggers.c:led_trigger_register:
> >=20
> > |        read_lock(&leds_list_lock);
> > |        list_for_each_entry(led_cdev, &leds_list, node) {
> > |                down_write(&led_cdev->trigger_lock);
> >=20
> > introduced in
> >=20
> > commit dc47206e552c0850ad11f7e9a1fca0a3c92f5d65
> > Author: Richard Purdie <rpurdie@rpsys.net>
> > Date:   Sat Nov 10 13:29:04 2007 +0000
> >=20
> >     leds: Fix led trigger locking bugs
> >=20
> > I guess the read_lock needs to be a mutex/rw semaphore.
>=20
> Uh, yes. Was this patch tested at all?

Not with default triggers, I guess. The code in question only triggers
when a default is assigned to any LED I think.

johannes

--=-C4ugSvK+HLKYvO1o2dJU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2WMwKVg1VMiehFYAQK67w/9GVmbqd5NMFM53Agj02FA3Mp/hZnoNVcb
bsvJCnU9Nzi454vDjrRC9cnjxeSB/r6npDC1hjDVO6CiwGs7VH6Ztb2h7iDQNtax
yk4NgZXWJ6jpG4v+QE1HKY22kY4OuJXjaWkrql0+9QTtZgprlOIXlcmRRX5KSvft
/klWVhiugwdIQd2zfnKoJcJnYiPUfq6cFISbuMiyAREMtDiTgn4eLAbZY4x1awuA
2PyVox4yOSHSPiauRWodCv8Usz2kvThMVgiUiCHGQmjS1rpWz1AYubUVxJEBkZ4s
fhWPDwSUHdufbsV9HKNzR9+Td9Ev84tvyWAeFdFeDnBzVUK6PtXoPovOuxvA945p
2JgAB3yVwIUrm8yVV08rEGD4jxuWfqMXpSLcsR3+3ktVu3mV3cCrzjYr/Vk2qCEh
V5rHPxlz6XR+19FTtN3jxGPzpv3wkjK/ZzQ+PRfNP2w80yX2TjPhUl0lwGNbEb6+
sfk8kfgQTyv+kxD59uWLu0XXWmlTETAWyAgCeQdPxWeU4ejY1bJWUCAbyp3Amxwk
QGcD2nAXPbMPf5NO1sX+FRgjiWvJ/s1/DSoP3lvBIR7lbbuuYH/76AB9GqTJfpGV
aob7cn/4VDgd3eqz9OtxITrmp9JfZ+Cxm70sasPVST1QzgEN447xdfvmpVrZJL5p
kXjWQLv7fAw=
=Fik9
-----END PGP SIGNATURE-----

--=-C4ugSvK+HLKYvO1o2dJU--


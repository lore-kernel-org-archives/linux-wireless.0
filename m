Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web4.futuron.fi ([217.149.52.4]:45899 "EHLO web4.futuron.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbZLBNFG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 08:05:06 -0500
Received: from [85.23.66.41] (helo=[192.168.69.231])
	by web4.futuron.fi with esmtpsa (SSLv3:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <antti@kaijanmaki.net>)
	id 1NFoGi-00076s-Qp
	for linux-wireless@vger.kernel.org; Wed, 02 Dec 2009 14:25:16 +0200
Subject: New rtl8187 rfkill support blocks my wlan for good.
From: Antti =?ISO-8859-1?Q?Kaijanm=E4ki?= <antti@kaijanmaki.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Leae+iy4RY7yYGYPSZOt"
Date: Wed, 02 Dec 2009 14:25:09 +0200
Message-ID: <1259756709.31590.62.camel@peura.elisa-laajakaista.fi>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Leae+iy4RY7yYGYPSZOt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I wanted to give a try to your compat-wireless bleeding edge drivers. I
have an RTL8187 based wlan chip on my laptop. After installing the
driver I was not able to use the WiFi anymore as the driver reports that
the kill switch is active no matter in what position I turn the switch
on the side of the laptop.

Here's the dmesg output of the chip detection:

[   20.686680] phy0: Selected rate control algorithm 'minstrel'
[   20.687554] phy0: hwaddr 00:1b:9e:eb:77:98, RTL8187BvE V0 + rtl8225z2
[   20.710529] rtl8187: Customer ID is 0x04
[   20.710588] Registered led device: rtl8187-phy0::tx
[   20.710611] Registered led device: rtl8187-phy0::rx
[   20.711393] rtl8187: wireless switch is off

I checked the driver and found the rtl8187_rfkill.c. I added some
prink's to see what's happening and noticed that the physical switch did
affect different bit than the one tested in the current driver. This
change enables the correct behavior on my laptop:

--- rtl8187_rfkill.c.orig	2009-12-02 14:12:34.646597569 +0200
+++ rtl8187_rfkill.c	2009-12-02 14:10:09.474593370 +0200
@@ -28,7 +28,7 @@ static bool rtl8187_is_radio_enabled(str
 	rtl818x_iowrite8(priv, &priv->map->GPIO0, gpio & ~0x02);
 	gpio =3D rtl818x_ioread8(priv, &priv->map->GPIO1);
=20
-	return gpio & 0x02;
+	return gpio & 0x04;
 }


I tried to contact Realtek to provide me with some specs so that I can
verify the register in question, but all I received was a reply with the
realtek's reference driver attached. I haven't got any answer to my
follow-up request for the specification.=20

I looked through the reference driver but could not find anything
informational. I didn't have time to do a full review, though.

Without the specification I can't tell how this can be fixed. People
have reported success with the current driver, haven't they, so the bit
is correct for them.

As soon as distributions start shipping the new rtl8187 driver there are
people whose wlan stops working. I don't know if the killswitch with
rtl8187 chipsets is suppose to be only created with software but at
least in my laptop it didn't matter in which position the switch was
with older drivers, the radio worked anyway.=20

Any thoughts how to continue with this?


 -- Antti


--=-Leae+iy4RY7yYGYPSZOt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digitaalisesti allekirjoitettu viestin osa

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAksWXKAACgkQFYSsxt2pELHkPwCgoVld14vjaQZe9nu5/+ld6egA
5o8AoMOrnPJJz9D8Ldqi1xRr0idJhLjU
=jNp0
-----END PGP SIGNATURE-----

--=-Leae+iy4RY7yYGYPSZOt--


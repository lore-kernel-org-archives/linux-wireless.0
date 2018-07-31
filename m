Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:45030 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbeGaWCt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 18:02:49 -0400
Date: Tue, 31 Jul 2018 21:14:16 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Subject: b43legacy/leds: Ensure NUL-termination of LED name string
Message-ID: <20180731211416.36cde729@wiggum> (sfid-20180731_222050_989825_DA82FDB9)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/m/bIotj7L.9vDffAAcLlzaJ"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/m/bIotj7L.9vDffAAcLlzaJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

strncpy might not NUL-terminate the string, if the name equals the buffer s=
ize.
Use strlcpy instead.

Signed-off-by: Michael Buesch <m@bues.ch>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/broadcom/b43legacy/leds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/leds.c b/drivers/net/w=
ireless/broadcom/b43legacy/leds.c
index fd4565389c77..bc922118b6ac 100644
--- a/drivers/net/wireless/broadcom/b43legacy/leds.c
+++ b/drivers/net/wireless/broadcom/b43legacy/leds.c
@@ -101,7 +101,7 @@ static int b43legacy_register_led(struct b43legacy_wlde=
v *dev,
 	led->dev =3D dev;
 	led->index =3D led_index;
 	led->activelow =3D activelow;
-	strncpy(led->name, name, sizeof(led->name));
+	strlcpy(led->name, name, sizeof(led->name));
=20
 	led->led_dev.name =3D led->name;
 	led->led_dev.default_trigger =3D default_trigger;

--=20
Michael

--Sig_/m/bIotj7L.9vDffAAcLlzaJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAltgtQgACgkQ9TK+HZCN
iw4bMRAAirnF3XxgifPnj5TNg+aF1jumy5N6HUda3lEpcxZPcaZBzG8b/kqOlq/8
5RbG3uikKPVrVeIztrJPaQy92w3pWsvnJWfavNniiG7hnuy4eps1jRYO9ZZf2DGj
1KFefH1z2bu35ztU+xAkHbGV/DCo+peOM05b7arYgMp2vTw6v7h2Klpn9oHssgnq
ESU5TqERAjxGO3Cj4ELnaSHWtJGOaWViMJxgn1Bmq4P+IBByFtpof2xYVH9JF92c
z8ipNO5HQyKKJzYXsiZeAtOEaUISxgiP1OvJVljZHqeeCu8++yXQN9l6+l+Vw7th
1VQP5Q7iQ02uy19AwQSA7IRiTJZVHE4CFNdzxuw6T7YfN2Irk9xEmZYke1txhWsX
an2r8CyqvUwNsN9o2cgQYCUzmU1zHUexnB0L32WnaPAmDqnQHoKbdBhVIW+fQFvB
/XV1fdhWUPSFzYHjn/lGSBNT6UeECqLwXWaj1UR8vkTOhct3S5XLQ8KvtdOI4S7l
/iuqCq+dfUboJ7mwVb03iGZD+tS+2FxE9xqFEBkkI9ESm10RpRvzjdXpfOCJSL8n
t3ZmdBnFtyGIQiF8AVs4I8PXVmT1egX8YcbLmHHEQbDy+l1pR+A5TT4TWZMScbI8
R4cmamRzsb0jXkCa5aNzFWzAL6rQ7Ejpv84TilV5tGeAQ8JngkI=
=J3qq
-----END PGP SIGNATURE-----

--Sig_/m/bIotj7L.9vDffAAcLlzaJ--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36549 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbcAXKca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2016 05:32:30 -0500
Received: by mail-lb0-f174.google.com with SMTP id oh2so60807932lbb.3
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2016 02:32:29 -0800 (PST)
Subject: Re: [Bug 110551] iwlwifi: dvm: cannot turn off wifi LED
References: <bug-110551-148371@https.bugzilla.kernel.org/>
 <bug-110551-148371-jY9LWPEyBc@https.bugzilla.kernel.org/>
Cc: bugzilla-daemon@bugzilla.kernel.org
To: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
From: Hubert Tarasiuk <hubert.tarasiuk@gmail.com>
Message-ID: <56A4A837.5030509@gmail.com> (sfid-20160124_113234_727946_E14252E4)
Date: Sun, 24 Jan 2016 11:32:23 +0100
MIME-Version: 1.0
In-Reply-To: <bug-110551-148371-jY9LWPEyBc@https.bugzilla.kernel.org/>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uCOJENAeQs8jr0iqHdOEljxWsw9OavoAv"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uCOJENAeQs8jr0iqHdOEljxWsw9OavoAv
Content-Type: multipart/mixed;
 boundary="------------010900040507080908060007"

This is a multi-part message in MIME format.
--------------010900040507080908060007
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Attached is the patch for bug 110551.

W dniu 24.01.2016 o 11:16, bugzilla-daemon@bugzilla.kernel.org pisze:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D110551
>=20
> --- Comment #13 from Emmanuel Grumbach <emmanuel.grumbach@intel.com> --=
-
> https://bugzilla.kernel.org/attachment.cgi?id=3D201271
>=20
> This one seems to have a fix for the module param as well.
> I would much prefer you to send the patch to the wireless mailing list =
rather
> than attaching it to this bugzilla.
>=20

--------------010900040507080908060007
Content-Type: text/x-patch;
 name="0001-iwlwifi-dvm-handle-zero-brightness-for-wifi-LED.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-iwlwifi-dvm-handle-zero-brightness-for-wifi-LED.patch"

=46rom 40e783a5464e43722d87b5cb0c3d3899f3f7417e Mon Sep 17 00:00:00 2001
From: Hubert Tarasiuk <hubert.tarasiuk@gmail.com>
Date: Mon, 4 Jan 2016 23:45:18 +0100
Subject: [PATCH] iwlwifi: dvm: handle zero brightness for wifi LED

This fixes bug 110551 with regard to sysfs.

Misleading behaviour when 'led_mode=3D3' is passed to iwlwifi is still
to be fixed (either by changing the option description or by making
the LED permanently dark in such case).

Signed-off-by: Hubert Tarasiuk <hubert.tarasiuk@gmail.com>
---
 drivers/net/wireless/iwlwifi/dvm/led.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/led.c b/drivers/net/wireles=
s/iwlwifi/dvm/led.c
index ca4d669..218617a 100644
--- a/drivers/net/wireless/iwlwifi/dvm/led.c
+++ b/drivers/net/wireless/iwlwifi/dvm/led.c
@@ -154,11 +154,14 @@ static void iwl_led_brightness_set(struct led_class=
dev *led_cdev,
 {
 	struct iwl_priv *priv =3D container_of(led_cdev, struct iwl_priv, led);=

 	unsigned long on =3D 0;
+	unsigned long off =3D 0;
=20
 	if (brightness > 0)
 		on =3D IWL_LED_SOLID;
+	else
+		off =3D IWL_LED_SOLID;
=20
-	iwl_led_cmd(priv, on, 0);
+	iwl_led_cmd(priv, on, off);
 }
=20
 static int iwl_led_blink_set(struct led_classdev *led_cdev,
--=20
2.7.0


--------------010900040507080908060007--

--uCOJENAeQs8jr0iqHdOEljxWsw9OavoAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWpKg3AAoJEGzXtIeRP38CDD0H/3oIrDtrlqQw0B7ELweG6eoJ
xWEk4vmUfu8dJO9s09wAQT1CqY/SHK2ePVFfjThIKAuSQXLfPC5WYwGN4EdUTR0m
5l2WGm1bkSz2c/oODdXmMiiE1MAb2H7S6WK9mW9zRuLawtJtef1Wyok2UHfJ/IC5
PoZ5avwx1p4rwPUFCZsevxF+uuREyZy2B9dtfc6WYphdErKeG29ee4PbG9vmLTga
6Mj3dutJwdQCr1k46dWz43zY8MiEw8Xk2BijrUGIYiNH7xzAERdAsD3XaagYTLNf
hAmaELju/uI2f3IDZIAG4YbneYplalyuHu1moDNmpcLLwePw+74gRl13CujYSrQ=
=NTzl
-----END PGP SIGNATURE-----

--uCOJENAeQs8jr0iqHdOEljxWsw9OavoAv--

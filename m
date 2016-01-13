Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34309 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbcAMWdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 17:33:47 -0500
Received: by mail-lf0-f53.google.com with SMTP id 17so62719496lfz.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2016 14:33:46 -0800 (PST)
Subject: [Bug 110551] iwlwifi: dvm: cannot turn off wifi LED
References: <CALwVF7Q2ApSy0DR4JS1qkovg=EoLot2ABaLimhXkMmKp0hwq6w@mail.gmail.com>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
From: Hubert Tarasiuk <hubert.tarasiuk@gmail.com>
Message-ID: <5696D0C5.8080501@gmail.com> (sfid-20160113_233350_219865_73DA094C)
Date: Wed, 13 Jan 2016 23:33:41 +0100
MIME-Version: 1.0
In-Reply-To: <CALwVF7Q2ApSy0DR4JS1qkovg=EoLot2ABaLimhXkMmKp0hwq6w@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SInoIxWHElmxroJ9Qc9hQXCHpVLKWxuKg"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SInoIxWHElmxroJ9Qc9hQXCHpVLKWxuKg
Content-Type: multipart/mixed;
 boundary="------------060400070906080800090900"

This is a multi-part message in MIME format.
--------------060400070906080800090900
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Re-sending as plain-text.


--- Tre=C5=9B=C4=87 przekazanej wiadomo=C5=9Bci ---
Temat: 	[Bug 110551] iwlwifi: dvm: cannot turn off wifi LED
Data: 	Wed, 13 Jan 2016 23:31:28 +0100
Nadawca: 	Hubert Tarasiuk <hubert.tarasiuk@gmail.com>
Adresat: 	emmanuel.grumbach@intel.com
Kopia: 	linux-wireless@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.o=
rg



Hi Emmanuel,

Actually to properly handle led_mode=3D3 option is not as easy as it seem=
s.
Even if I initially turn of the LED in case of led_mode=3D3, it still get=
s
turned on after doing
# ifconfig wlan0 down && ifconfig wlan0 up

Maybe if I have more time later I can investigate further on how to
avoid this behaviour. (the LED trigger is set to none according to
sysfs) Or you have an idea on how to stop this behaviour?

Otherwise I would suggest that you apply the patch that I posted on
bugzilla (attached) that fixes sysfs handling. It is then easy to keep
the LED on or off as desired using simple shell scripts.

Thank you,
Hubert

On Tue, Jan 12, 2016 at 7:58 AM,=C3=82 <bugzilla-daemon@bugzilla.kernel.o=
rg
<mailto:bugzilla-daemon@bugzilla.kernel.org>>=C3=82 wrote:

    https://bugzilla.kernel.org/show_bug.cgi?id=3D110551

    --- Comment #1 from Emmanuel Grumbach <emmanuel.grumbach@intel.com
    <mailto:emmanuel.grumbach@intel.com>> ---
    Your bug is fine, but I'd prefer if you'd send the patch :)

    you can send it to me and CC=C3=82 linux-wireless@vger.kernel.org
    <mailto:linux-wireless@vger.kernel.org>

    thanks.

    --
    You are receiving this mail because:
    You are on the CC list for the bug.
    You reported the bug.




--------------060400070906080800090900
Content-Type: text/x-patch;
 name="0001-iwlwifi-allow-led-turn-off-in-iwl-dvm-module.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-iwlwifi-allow-led-turn-off-in-iwl-dvm-module.patch"

=46rom 132afdea768bea0a5dc0f46417b261138b9b0286 Mon Sep 17 00:00:00 2001
From: Hubert Tarasiuk <hubert.tarasiuk@gmail.com>
Date: Mon, 4 Jan 2016 23:45:18 +0100
Subject: [PATCH] iwlwifi: allow led turn off in iwl dvm module

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
2.6.4


--------------060400070906080800090900--

--SInoIxWHElmxroJ9Qc9hQXCHpVLKWxuKg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWltDHAAoJEGzXtIeRP38CSCkH/jCkejvsyxnPrCwg4M9b1OqJ
SnBEgnRzkT/luApiElYKgeP0u1sASyUfzZP761H1aJ5h83AeIcVqOFGcSUroaaI/
OnjffxxuWYtStRfh001fejrbYn1LBl/3PQG+KvQaMMWB4n8LGhO5pMhK5a0RzQQn
lVWgTEjY98uv8i++xG5SHw9JGLoKv9muIKuLmY8PuRl0VFxz1NW0PWXxzBxjvBZQ
8Bd/cc5dOAb+rVv4JosYdNUwVhtUZ4fJwvwIPkTrF1GkFuyxHU+9VKXfdluxCsQu
j4amBwEoWEp2HAufwY6/2nH8XUrAo3CSvnjjeJ2/xgknOCF0KNFe9wxki0z3SZc=
=H4sB
-----END PGP SIGNATURE-----

--SInoIxWHElmxroJ9Qc9hQXCHpVLKWxuKg--

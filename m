Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50425 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbcDKTFF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 15:05:05 -0400
Subject: Re: [PATCH] Revert regression in ath9k on AR9281
To: Gustav Frederiksen <lkml2017@openmailbox.org>,
	Julian Calaby <julian.calaby@gmail.com>
References: <998e52a27823047910627da08e917c06@openmailbox.org>
 <CAGRGNgVtD8PS7BePJ=RTbxOOYjqE39kChuhZxtOUO-S9Y95p6w@mail.gmail.com>
 <6567cc33c0ca681364c6510a7797c459@openmailbox.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <570BF557.40705@rempel-privat.de> (sfid-20160411_210510_907622_C0D74D2C)
Date: Mon, 11 Apr 2016 21:04:55 +0200
MIME-Version: 1.0
In-Reply-To: <6567cc33c0ca681364c6510a7797c459@openmailbox.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="l8towVcPHCeNFHJ4eMXXBeoo1MwMR4UwA"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--l8towVcPHCeNFHJ4eMXXBeoo1MwMR4UwA
Content-Type: multipart/mixed; boundary="TfCsJnPd9h5fTI4GMEQp0uqhM0TElWTX7"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Gustav Frederiksen <lkml2017@openmailbox.org>,
 Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <570BF557.40705@rempel-privat.de>
Subject: Re: [PATCH] Revert regression in ath9k on AR9281
References: <998e52a27823047910627da08e917c06@openmailbox.org>
 <CAGRGNgVtD8PS7BePJ=RTbxOOYjqE39kChuhZxtOUO-S9Y95p6w@mail.gmail.com>
 <6567cc33c0ca681364c6510a7797c459@openmailbox.org>
In-Reply-To: <6567cc33c0ca681364c6510a7797c459@openmailbox.org>

--TfCsJnPd9h5fTI4GMEQp0uqhM0TElWTX7
Content-Type: multipart/mixed;
 boundary="------------070004090306040708090801"

This is a multi-part message in MIME format.
--------------070004090306040708090801
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Gustav,

thank you for your work.
Can you please test attached patch.

Am 11.04.2016 um 04:28 schrieb Gustav Frederiksen:
> Hi,
> thank you for taking the time to answer my previous email and for
> providing those useful tips.
=2E...

--=20
Regards,
Oleksij

--------------070004090306040708090801
Content-Type: text/x-patch;
 name="ath_fix.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="ath_fix.patch"

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wi=
reless/ath/ath9k/ar5008_phy.c
index 8f87930..1b271b9 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -274,6 +274,9 @@ void ar5008_hw_cmn_spur_mitigate(struct ath_hw *ah,
 	};
 	static const int inc[4] =3D { 0, 100, 0, 0 };
=20
+	memset(&mask_m, 0, sizeof(int8_t) * 123);
+	memset(&mask_p, 0, sizeof(int8_t) * 123);
+
 	cur_bin =3D -6000;
 	upper =3D bin + 100;
 	lower =3D bin - 100;
@@ -424,14 +427,9 @@ static void ar5008_hw_spur_mitigate(struct ath_hw *a=
h,
 	int tmp, new;
 	int i;
=20
-	int8_t mask_m[123];
-	int8_t mask_p[123];
 	int cur_bb_spur;
 	bool is2GHz =3D IS_CHAN_2GHZ(chan);
=20
-	memset(&mask_m, 0, sizeof(int8_t) * 123);
-	memset(&mask_p, 0, sizeof(int8_t) * 123);
-
 	for (i =3D 0; i < AR_EEPROM_MODAL_SPURS; i++) {
 		cur_bb_spur =3D ah->eep_ops->get_spur_channel(ah, i, is2GHz);
 		if (AR_NO_SPUR =3D=3D cur_bb_spur)
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wi=
reless/ath/ath9k/ar9002_phy.c
index db66245..53d7445 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -178,14 +178,9 @@ static void ar9002_hw_spur_mitigate(struct ath_hw *a=
h,
 	int i;
 	struct chan_centers centers;
=20
-	int8_t mask_m[123];
-	int8_t mask_p[123];
 	int cur_bb_spur;
 	bool is2GHz =3D IS_CHAN_2GHZ(chan);
=20
-	memset(&mask_m, 0, sizeof(int8_t) * 123);
-	memset(&mask_p, 0, sizeof(int8_t) * 123);
-
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 	freq =3D centers.synth_center;
=20

--------------070004090306040708090801--

--TfCsJnPd9h5fTI4GMEQp0uqhM0TElWTX7--

--l8towVcPHCeNFHJ4eMXXBeoo1MwMR4UwA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlcL9VwACgkQHwImuRkmbWku0gD/UeSTI2q16GhQXT9j/BI3FPtw
fLw+s4rg6XcZQGfngncA/1hVFed4SlTp7krj24uitAdkctsUQfUWXhYX/NipKDgS
=iotc
-----END PGP SIGNATURE-----

--l8towVcPHCeNFHJ4eMXXBeoo1MwMR4UwA--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:22573 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab2LKKKw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 05:10:52 -0500
Date: Tue, 11 Dec 2012 12:04:07 +0200
From: Daniel Golle <dgolle@allnet.de>
To: <linux-wireless@vger.kernel.org>
CC: <users@rt2x00.serialmonkey.com>, <juhosg@openwrt.org>,
	<sgruszka@redhat.com>, <helmut.schaa@googlemail.com>,
	<gwingerde@gmail.com>, <john@phrozen.org>
Subject: [PATCH 2/3] rt2x00: allow disabling bands through platform_data
Message-ID: <20121211100404.GA7817@earthship.arig> (sfid-20121211_111055_292869_2B24DD6B)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Daniel Golle <dgolle@allnet.de>

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt=
2x00/rt2x00.h
index 355cff5..c67e769 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -426,6 +426,7 @@ struct hw_mode_spec {
 	unsigned int supported_bands;
 #define SUPPORT_BAND_2GHZ	0x00000001
 #define SUPPORT_BAND_5GHZ	0x00000002
+#define SUPPORT_BAND_BOTH	(SUPPORT_BAND_2GHZ | SUPPORT_BAND_5GHZ)
=20
 	unsigned int supported_rates;
 #define SUPPORT_RATE_CCK	0x00000001
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless=
/rt2x00/rt2x00dev.c
index d454488..b7856bf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -835,6 +835,22 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev =
*rt2x00dev,
 	unsigned int num_rates;
 	unsigned int i;
=20
+	if (rt2x00dev->dev->platform_data) {
+		struct rt2x00_platform_data *pdata;
+
+		pdata =3D rt2x00dev->dev->platform_data;
+		if (pdata->disable_2ghz)
+			spec->supported_bands &=3D ~SUPPORT_BAND_2GHZ;
+		if (pdata->disable_5ghz)
+			spec->supported_bands &=3D ~SUPPORT_BAND_5GHZ;
+	}
+
+	if ((spec->supported_bands & SUPPORT_BAND_BOTH) =3D=3D 0) {
+		ERROR(rt2x00dev, "No supported bands\n");
+		return -EINVAL;
+	}
+
+
 	num_rates =3D 0;
 	if (spec->supported_rates & SUPPORT_RATE_CCK)
 		num_rates +=3D 4;
diff --git a/include/linux/rt2x00_platform.h b/include/linux/rt2x00_platfor=
m.h
index 80effa7..b4c7768 100644
--- a/include/linux/rt2x00_platform.h
+++ b/include/linux/rt2x00_platform.h
@@ -14,6 +14,9 @@
=20
 struct rt2x00_platform_data {
 	char *eeprom_file_name;
+
+	int disable_2ghz;
+	int disable_5ghz;
 };
=20
 #endif /* _RT2X00_PLATFORM_H */
--=20
1.8.0.1


--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxwUUAAoJEDy9cKN/1Et0ykwP/1PSgUR1zNebSc/hhp4ytIxA
xfMYIpTVwcZGX5K1K0UfAjti4zZmdhBoFSqICEGstUfirSY/m9xK8cBJcvxSHef9
QWThSzNIBAop+8SXcHIG2GVcZ+tKai5322SRHUD4UPBqNPnos/+8317DBEUl1h/l
0ZNcA4D0CiNNbMGmNni6QgxN3JtjE0asnOHWG2btgGkeHvUcBEpxD3acdawvA3cs
W6nyPV40ErKQiMrLfOa/nWGXY7OVNhwynrncyUZ3LdAfX9wQ1rLOBX4ndZUCwBtF
HOhQ7wrdyV5R94qz7Bi5iKT/n+3l1WuLRNqU5oaYBr4Ahy1rfpTyaTMgt/NXpOdK
twsXfa9vv+VpfZzjLgRNdsg0boxdAdgGENv3k1/GJEVclQZY5+HLJZPSiz95QWHo
hEXy3mRah/CsdyZA/99+3PJINjr4iiZeYftHpWvk9JMuAZOwVW0hyt1nodeEiqWO
8fn6RSBDumSNIv8T8jwYnKAwwAWQGnjuH8i78jOu6CJXBmhi+5fIodMUHKdLD+gc
gwXxk3CyI3WM3Z8HCENhFmnXA+1MfLfm1QVDzZjADvn3e8gFlMKEYUMvnMK6EhHs
xZ3MH0kkG7A+yj8wNZ2u3KDvei89Ejl9iccue/0DSWuSBIQoYbeGQqESxuBUWe3q
56dy7ETdKWKJxI2lbKfx
=mAMl
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:38638 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2DBOel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 10:34:41 -0400
Date: Mon, 2 Apr 2012 10:25:25 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: [PATCH 1/2] rtl8192de: Clean up and fix 92D cut version constants
 and macros.
Message-ID: <20120402142525.GA20611@alittletooquiet.net> (sfid-20120402_163444_779716_CAAEF2FD)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Forest Bond <forest.bond@rapidrollout.com>

The previous definitions included both {B,C,D,E}_CUT_VERSION and
CHIP_92D_{C,D}_CUT with conflicting values for the C and D cut versions,
and literal hex values were used in the IS_92D_{C,D,E}_CUT macros.  So
we clean all this up and in doing so enable cut-specific code paths for
cuts C and D, which would not have been executed because the
CHIP_92D_{C,D}_CUT constants were wrong and the cut version was thus
recorded incorrectly.

Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
---
 drivers/net/wireless/rtlwifi/rtl8192de/def.h |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/def.h b/drivers/net/wir=
eless/rtlwifi/rtl8192de/def.h
index eafdf76..260ac7e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/def.h
@@ -151,9 +151,6 @@ enum version_8192d {
=20
 /* for 92D */
 #define CHIP_92D_SINGLEPHY		BIT(9)
-#define C_CUT_VERSION			BIT(13)
-#define D_CUT_VERSION			((BIT(12)|BIT(13)))
-#define E_CUT_VERSION			BIT(14)
=20
 /* Chip specific */
 #define CHIP_BONDING_IDENTIFIER(_value)	(((_value)>>22)&0x3)
@@ -173,7 +170,11 @@ enum version_8192d {
 #define RF_TYPE_1T2R			BIT(4)
 #define RF_TYPE_2T2R			BIT(5)
 #define CHIP_VENDOR_UMC			BIT(7)
-#define B_CUT_VERSION			BIT(12)
+#define CHIP_92D_A_CUT			(0<<12)
+#define CHIP_92D_B_CUT			(1<<12)
+#define CHIP_92D_C_CUT			(2<<12)
+#define CHIP_92D_D_CUT			(3<<12)
+#define CHIP_92D_E_CUT			(4<<12)
=20
 /* MASK */
 #define IC_TYPE_MASK			(BIT(0)|BIT(1)|BIT(2))
@@ -205,15 +206,13 @@ enum version_8192d {
 					 CHIP_92D) ? true : false)
 #define IS_92D_C_CUT(version)		((IS_92D(version)) ?		\
 				 ((GET_CVID_CUT_VERSION(version) =3D=3D	\
-				 0x2000) ? true : false) : false)
+				 CHIP_92D_C_CUT) ? true : false) : false)
 #define IS_92D_D_CUT(version)			((IS_92D(version)) ?	\
 				 ((GET_CVID_CUT_VERSION(version) =3D=3D	\
-				 0x3000) ? true : false) : false)
+				 CHIP_92D_D_CUT) ? true : false) : false)
 #define IS_92D_E_CUT(version)		((IS_92D(version)) ?		\
 				 ((GET_CVID_CUT_VERSION(version) =3D=3D	\
-				 0x4000) ? true : false) : false)
-#define CHIP_92D_C_CUT			BIT(10)
-#define CHIP_92D_D_CUT			BIT(11)
+				 CHIP_92D_E_CUT) ? true : false) : false)
=20
 enum rf_optype {
 	RF_OP_BY_SW_3WIRE =3D 0,
--=20
1.7.0.4

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk95ttUACgkQRO4fQQdv5AwcSwCfdXon7ck+DtjytjyZnWbtZLCT
thYAn0EO6clsaE7ZmT7yZT3QPENYB8c3
=saGm
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:34347 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbbEUUUf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 16:20:35 -0400
Date: Thu, 21 May 2015 21:44:21 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix EFUSE_ANA8M map value
Message-ID: <20150521214421.15983b0a@milhouse> (sfid-20150521_222039_763195_746FBF1C)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ehl1hOo2/NXpDdRE0hEr6CI"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/ehl1hOo2/NXpDdRE0hEr6CI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The map entry EFUSE_ANA8M is supposed to be a bit mask of the SYS_CLK regis=
ter (see efuse.c)
It doesn't make sense to assign the enumeration value EFUSE_ANA8M. Assign t=
he bitmask ANA8M instead.
rtl8192se does not have ANA8M, so use 0 as bitmask.

Signed-off-by: Michael Buesch <m@bues.ch>

---

This is RFC, because I don't really know the device.
The rtl8192se part of the patch is just a guess, because this driver's reg.=
h doesn't have an ANA8M define.

Index: wireless-drivers-next/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-drivers-next.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-drivers-next/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -282,7 +282,7 @@ static struct rtl_hal_cfg rtl92ce_hal_cf
 	.maps[EFUSE_PWC_EV12V] =3D PWC_EV12V,
 	.maps[EFUSE_FEN_ELDR] =3D FEN_ELDR,
 	.maps[EFUSE_LOADER_CLK_EN] =3D LOADER_CLK_EN,
-	.maps[EFUSE_ANA8M] =3D EFUSE_ANA8M,
+	.maps[EFUSE_ANA8M] =3D ANA8M,
 	.maps[EFUSE_HWSET_MAX_SIZE] =3D HWSET_MAX_SIZE,
 	.maps[EFUSE_MAX_SECTION_MAP] =3D EFUSE_MAX_SECTION,
 	.maps[EFUSE_REAL_CONTENT_SIZE] =3D EFUSE_REAL_CONTENT_LEN,
Index: wireless-drivers-next/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-drivers-next.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-drivers-next/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -206,7 +206,7 @@ static struct rtl_hal_cfg rtl92cu_hal_cf
 	.maps[EFUSE_PWC_EV12V] =3D PWC_EV12V,
 	.maps[EFUSE_FEN_ELDR] =3D FEN_ELDR,
 	.maps[EFUSE_LOADER_CLK_EN] =3D LOADER_CLK_EN,
-	.maps[EFUSE_ANA8M] =3D EFUSE_ANA8M,
+	.maps[EFUSE_ANA8M] =3D ANA8M,
 	.maps[EFUSE_HWSET_MAX_SIZE] =3D HWSET_MAX_SIZE,
 	.maps[EFUSE_MAX_SECTION_MAP] =3D EFUSE_MAX_SECTION,
 	.maps[EFUSE_REAL_CONTENT_SIZE] =3D EFUSE_REAL_CONTENT_LEN,
Index: wireless-drivers-next/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-drivers-next.orig/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ wireless-drivers-next/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -330,7 +330,7 @@ static struct rtl_hal_cfg rtl92se_hal_cf
 	.maps[EFUSE_PWC_EV12V] =3D 0, /* nouse for 8192se */
 	.maps[EFUSE_FEN_ELDR] =3D 0, /* nouse for 8192se */
 	.maps[EFUSE_LOADER_CLK_EN] =3D 0,/* nouse for 8192se */
-	.maps[EFUSE_ANA8M] =3D EFUSE_ANA8M,
+	.maps[EFUSE_ANA8M] =3D 0, /* nouse for 8192se */
 	.maps[EFUSE_HWSET_MAX_SIZE] =3D HWSET_MAX_SIZE_92S,
 	.maps[EFUSE_MAX_SECTION_MAP] =3D EFUSE_MAX_SECTION,
 	.maps[EFUSE_REAL_CONTENT_SIZE] =3D EFUSE_REAL_CONTENT_LEN,

--Sig_/ehl1hOo2/NXpDdRE0hEr6CI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVXjWYAAoJEPUyvh2QjYsOp58QANELX2HFbyVd/fbmqcuYp1Jl
KL5/w0FXJuiRGiVgJxfMkmgrC0AK2XWdYRldRgVoel3zZvxYu4f/vXmKUMhMvAk0
IvE7aQBjQp1kA2UfpzyPJ3S4DiLxO3TBBGspS+UQvi6tEalWgQF6arzPeP6CDlKs
O1xOm8chAD6IODbp9RU7imdpyLqH0AkGBCyKfTadL6FXxJuT4b4ALXKMLsNTrHlz
scmFDBEpPAdCgDfADZR1H1dRdeki+fIf3fddnFx9WQY3/Zsiwm96CKHz3hCEKxc3
Id/1lfNhWM3WKg5TxdDMIOeTCLiNz5PShgsHKnUoj0/dXfjTQtELUJkdMFGDIi8E
04ZTgMTuyXVPTN+rkqAkW6OONQMmevmfRloyPmhhZV+rDhcBuj3Ezd8CDX71GTjl
IPpCUr19XIPcyb9otr9YYoN1Q+YsgSYm9rF2id4sqHYvyLZQtMGiLwWO9mhVTDWX
Vpzz/atsIpgM8+ggDUZ/P1a2dJM1gvFFVrLt0lYktbKVP1LAP23PM+W21IaczF1l
90acqCXQ9Xd9o6AceI0wUVXEDPbRE3CPcSWr6INs12XrGdMRWGckfX89lmydFg2x
wQMoP25bZjfp37T6FIlqlhfuqqHFk0HAgbxvG+51hs8NpAwWDxAl4+ByPhXQI5YU
G25yXwiBMGccEoxyKW4d
=cscs
-----END PGP SIGNATURE-----

--Sig_/ehl1hOo2/NXpDdRE0hEr6CI--

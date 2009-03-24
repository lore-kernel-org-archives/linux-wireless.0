Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36847 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860AbZCXAT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 20:19:57 -0400
Message-ID: <49C82719.3080108@hauke-m.de> (sfid-20090324_012001_239909_04E64376)
Date: Tue, 24 Mar 2009 01:19:37 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] compat-2.6: Add AR9170 driver
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5D3700BBA74688F5F6DF800A"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5D3700BBA74688F5F6DF800A
Content-Type: multipart/mixed;
 boundary="------------090703000604090104000607"

This is a multi-part message in MIME format.
--------------090703000604090104000607
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This adds the AR9170 driver to compat-wireless.

Hauke

--------------090703000604090104000607
Content-Type: text/x-diff;
 name="0001-Add-AR9170-driver.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="0001-Add-AR9170-driver.patch"

=46rom 7e9fb52516801f4dcc0c200ce8911d24ec472bc7 Mon Sep 17 00:00:00 2001
From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Tue, 24 Mar 2009 01:14:41 +0100
Subject: [PATCH] Add AR9170 driver.
 The AR9170 configuration is only activated on kernel 2.6.28 and later, b=
ecause the older kernel misses some needed functions.


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk               |    8 ++++++++
 scripts/admin-update.sh |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index 84bf609..d8b705a 100644
--- a/config.mk
+++ b/config.mk
@@ -259,6 +259,14 @@ CONFIG_RTL8187=3Dm
=20
 CONFIG_AT76C50X_USB=3Dm
=20
+# Activate AR9170 support only on kernel >=3D 2.6.28.
+# The needed USB poison feature was added in this kernel release.
+ifeq ($(shell test $(KERNEL_SUBLEVEL) -ge 28 && echo yes),yes)
+CONFIG_AR9170_COMMON=3Dm
+CONFIG_AR9170_USB=3Dm
+CONFIG_AR9170_LEDS=3Dy
+endif
+
 # RT2500USB does not require firmware
 CONFIG_RT2500USB=3Dm
 CONFIG_RT2800USB=3Dm
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 0226053..881db66 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -59,6 +59,7 @@ DRIVERS=3D"$DRIVERS drivers/net/wireless/p54"
 DRIVERS=3D"$DRIVERS drivers/net/wireless/rtl818x"
 DRIVERS=3D"$DRIVERS drivers/net/wireless/libertas_tf"
 DRIVERS=3D"$DRIVERS drivers/net/wireless/ipw2x00"
+DRIVERS=3D"$DRIVERS drivers/net/wireless/ar9170"
=20
 # Drivers that belong the the wireless directory
 DRIVER_FILES=3D"adm8211.c  adm8211.h"
--=20
1.5.6.3


--------------090703000604090104000607--

--------------enig5D3700BBA74688F5F6DF800A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJJyCcgAAoJEIZ0px9YPRMycc8P/2jDo81oW8GSaCXpmaWe811J
DTrZfTzY9BGE03b3KxmitI9ZU8lGylUvSws5sAmfUhzbFWFGGOk1XXP3iiMRmZL/
ZErgU0ptYMO/1FXcuji+q5yjq5dYQIitch/mTcBTJawtZjw2b4wXRIOTT3mvCWWC
LWRhf3yURfevjRJCM1hLbaAYJPu1YTVJHFIQFKWdrmdE6V122nXjInQpSdb6AMSB
NUVByQJRGj2bnWs4f4wkjgfy+N9hN9aElock6DDepryrtGg5HOBzUJUjquONoS26
EM+ciuXi7HTgBGn/tyfA5JD/4GVpIB4LoxCqeDdxQdx5UhAXCXoXbEUYN4EA1Z9G
TA9N6Mo+fH6NpfsZYcmFiHoNtUrW6yY3Y6zQx0YcuiGVbWS4EtmubK2lZlavAwCX
5oaR29DH5ba0bKZYR7Dj0tiD8URe8b2ZR+npjq0Jelh9rKqkCTeK0Q0TIw5D2ygC
XOnfPOQAcr9vqgDJsXyuAhs4Wff2l7QkrZ6zxfQ6yCO47Mw1PiQet7TdMPfqnwyT
Dn34hT/bRKjXeZzEG2Gm6tJZhH+zoZ25RypFS9uS4RA1NsoGhLwwgkBfxLVgJJVo
QsPhcOYLgCsG2uI6MNYuNdTL80Xk5OP9by/QKVpdcp8/8+/PmsP0cDmPwBCKzjFZ
w2CG4R7/jXyTy7YMoQBZ
=M9Ob
-----END PGP SIGNATURE-----

--------------enig5D3700BBA74688F5F6DF800A--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39858 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbYBPPMr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2008 10:12:47 -0500
Message-ID: <47B6FD58.5010004@hauke-m.de> (sfid-20080216_151250_937553_A513709E)
Date: Sat, 16 Feb 2008 16:12:24 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Patch for compat-wireless-2.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF927980E90ACBDC507FBB6EC"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF927980E90ACBDC507FBB6EC
Content-Type: multipart/mixed;
 boundary="------------060908020000090807030907"

This is a multi-part message in MIME format.
--------------060908020000090807030907
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi

This patch fixes some compile errors in the newest version of
compat-wireless-2.6. I have tested it with kernel 2.6.24 and 2.6.22

--
Hauke Mehrtens

--------------060908020000090807030907
Content-Type: text/x-patch;
 name="compat-wireless-2.6.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="compat-wireless-2.6.diff"

diff --git a/compat/compat.diff b/compat/compat.diff
index c857ea2..49325b5 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -633,3 +633,34 @@
  obj-$(CONFIG_EEPROM_93CX6)	+=3D eeprom_93cx6.o
 -obj-$(CONFIG_INTEL_MENLOW)	+=3D intel_menlow.o
 -obj-$(CONFIG_ENCLOSURE_SERVICES) +=3D enclosure.o
+--- a/drivers/net/wireless/zd1211rw/zd_chip.c	2008-02-15 16:29:43.000000=
000 -0500
++++ b/drivers/net/wireless/zd1211rw/zd_chip.c	2008-02-15 16:29:43.000000=
000 -0500
+@@ -1280,7 +1280,7 @@ int zd_chip_control_leds(struct zd_chip *chip, enu=
m led_status status)
+ 	other_led =3D chip->link_led =3D=3D LED1 ? LED2 : LED1;
+=20
+ 	switch (status) {
+-	case LED_OFF:
++	case LED_OFF_ZD:
+ 		ioreqs[0].value =3D FW_LINK_OFF;
+ 		ioreqs[1].value =3D v[1] & ~(LED1|LED2);
+ 		break;
+--- a/drivers/net/wireless/zd1211rw/zd_chip.h	2008-02-15 16:29:43.000000=
000 -0500
++++ b/drivers/net/wireless/zd1211rw/zd_chip.h	2008-02-15 16:29:43.000000=
000 -0500
+@@ -890,7 +890,7 @@ int zd_chip_lock_phy_regs(struct zd_chip *chip);
+ int zd_chip_unlock_phy_regs(struct zd_chip *chip);
+=20
+ enum led_status {
+-	LED_OFF =3D 0,
++	LED_OFF_ZD =3D 0,
+ 	LED_SCANNING =3D 1,
+ 	LED_ASSOCIATED =3D 2,
+ };
+--- a/drivers/net/wireless/zd1211rw/zd_mac.c	2008-02-15 16:29:43.0000000=
00 -0500
++++ b/drivers/net/wireless/zd1211rw/zd_mac.c	2008-02-15 16:29:43.0000000=
00 -0500
+@@ -965,5 +965,5 @@ static void housekeeping_disable(struct zd_mac *mac)=

+ 	dev_dbg_f(zd_mac_dev(mac), "\n");
+ 	cancel_rearming_delayed_workqueue(zd_workqueue,
+ 		&mac->housekeeping.link_led_work);
+-	zd_chip_control_leds(&mac->chip, LED_OFF);
++	zd_chip_control_leds(&mac->chip, LED_OFF_ZD);
+ }
diff --git a/compat/compat.h b/compat/compat.h
index b438a5a..a25192d 100644
--- a/compat/compat.h
+++ b/compat/compat.h
@@ -10,6 +10,8 @@
 #include <linux/scatterlist.h>
 #include <linux/usb.h>
 #include <linux/compat_autoconf.h>
+#include <linux/hw_random.h>
+#include <linux/leds.h>
=20
 /* Compat work for 2.6.22 and 2.6.23 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
@@ -17,7 +19,7 @@
 /* From include/linux/mod_devicetable.h */
=20
 /* SSB core, see drivers/ssb/ */
-#ifndef CONFIG_SSB
+#ifndef SSB_DEVICE
 struct ssb_device_id {
 	__u16   vendor;
 	__u16   coreid;
@@ -190,4 +192,20 @@ static inline void set_freezable(void) {}
 #endif /* CONFIG_PM_SLEEP */
=20
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23)) */
+
+/* Compat work for 2.6.24 */
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25))
+
+static inline void __hwrng_unregister(struct hwrng *rng, bool suspended)=

+{
+	hwrng_unregister(rng);
+}
+
+static inline void led_classdev_unregister_suspended(struct led_classdev=
 *lcd)
+{
+	led_classdev_unregister(lcd);
+}
+
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25)) */
 #endif /* LINUX_26_COMPAT_H */
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 5f6e9e1..147a01e 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -18,7 +18,7 @@
 GIT_URL=3D"git://git.kernel.org/pub/scm/linux/kernel/git/linville/wirele=
ss-testing.git"
=20
 INCLUDE_LINUX=3D"ieee80211.h nl80211.h wireless.h"
-INCLUDE_LINUX=3D"$INCLUDE_LINUX pci_ids.h bitops.h eeprom_93cx6.h"
+INCLUDE_LINUX=3D"$INCLUDE_LINUX pci_ids.h bitops.h eeprom_93cx6.h pm_qos=
_params.h"
=20
 # For rndis_wext
 INCLUDE_LINUX_USB=3D"usbnet.h rndis_host.h"

--------------060908020000090807030907--

--------------enigF927980E90ACBDC507FBB6EC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIVAwUBR7b9Y4Z0px9YPRMyAQJ7QA//dS0V8UOLVlQ5cCfmXLpEP4DsVI8h+3D4
Xl3GNgV9Rg7EF8dS6ezrKIYSWiKNrJ7QSQcjvkIbu/7bcg1Zz5DnGkcYRHDaYZoT
YsXnPlTvGy3Yk6d0YRbAZ879RBYQCBwBL31h6/dirfWKjBboqRHPNqcoen4lf8vv
8cGurVU9rQm3mu7S2/pGycsuNYUJWltRshXvE1Ut6Xjrr2oMqYnxKB9koMnF7CYM
d/dPWhd2lRg3A8XiZfI5NsDyBv9THmkBW5h/u+oI5kpq1LJ6FYjBAQmsfNVuZz8X
VTWBdCr5WGte171f2bO7TJtiIMrj3fNUUIAER7bhUmBi/9rBDFoYCvA48Bsawb64
Flbk/P5JKABwwaynmm8/ZHUmL5m95CUxkGvFunAtpfJZCxf9FbwY9ChAolbO/bTA
r7FAlNY766v78rwzuT1IwnhHVr31X9/3Hh58GDNoVab71LAPxYi5h8Q8rKMaxj67
vCzN2SlT4woXV2aHzO4FUMb3zXWWthlPfyCMwX+b92yKGiQNBoM2oR13+VNAtk4J
Hy2mcIgqr96lToTtwvFeR3FC+8oMHF8JHrqD96gGt0xH38qkHe2FGP2BmD5gFnCZ
AwRe786vItM0GTge2Mcc/46b4TE1D2uTTHp4soxwjSoPUMtTz+Vec0Wpu61OkDQ0
oEzv8D0mlSA=
=u55w
-----END PGP SIGNATURE-----

--------------enigF927980E90ACBDC507FBB6EC--

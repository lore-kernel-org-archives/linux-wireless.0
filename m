Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43770 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZC3P0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 11:26:35 -0400
Date: Mon, 30 Mar 2009 10:26:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] b43legacy: Do not select HW_RANDOM
Message-ID: <49d0e498.VVNw6/FIi1OemoLq%Larry.Finger@lwfinger.net> (sfid-20090330_172646_328099_5E8D1E0B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Auto-depend on HW_RANDOM, rather than "select"ing it.
This way the user has the choice to enable or disable HWRNG support.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John, please queue for 2.6.31.



Index: wireless-testing/drivers/net/wireless/b43legacy/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/Kconfig
+++ wireless-testing/drivers/net/wireless/b43legacy/Kconfig
@@ -3,7 +3,6 @@ config B43LEGACY
 	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211 && HAS_DMA
 	select SSB
 	select FW_LOADER
-	select HW_RANDOM
 	---help---
 	  b43legacy is a driver for 802.11b devices from Broadcom (BCM4301 and
 	  BCM4303) and early model 802.11g chips (BCM4306 Ver. 2) used in the
@@ -51,6 +50,13 @@ config B43LEGACY_RFKILL
 	depends on B43LEGACY && (RFKILL = y || RFKILL = B43LEGACY) && RFKILL_INPUT && (INPUT_POLLDEV = y || INPUT_POLLDEV = B43LEGACY)
 	default y
 
+# This config option automatically enables b43 HW-RNG support,
+# if the HW-RNG core is enabled.
+config B43legacy_HWRNG
+	bool
+	depends on B43legacy && (HW_RANDOM = y || HW_RANDOM = B43legacy)
+	default y
+
 config B43LEGACY_DEBUG
 	bool "Broadcom 43xx-legacy debugging"
 	depends on B43LEGACY
Index: wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
@@ -596,9 +596,11 @@ struct b43legacy_wl {
 	/* Stats about the wireless interface */
 	struct ieee80211_low_level_stats ieee_stats;
 
+#ifdef CONFIG_B43legacy_RNG
 	struct hwrng rng;
 	u8 rng_initialized;
 	char rng_name[30 + 1];
+#endif
 
 	/* The RF-kill button */
 	struct b43legacy_rfkill rfkill;
Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c
@@ -2394,6 +2394,7 @@ static void b43legacy_security_init(stru
 				  dev->max_nr_keys - 8);
 }
 
+#ifdef CONFIG_B43legacy_HWRNG
 static int b43legacy_rng_read(struct hwrng *rng, u32 *data)
 {
 	struct b43legacy_wl *wl = (struct b43legacy_wl *)rng->priv;
@@ -2409,17 +2410,21 @@ static int b43legacy_rng_read(struct hwr
 
 	return (sizeof(u16));
 }
+#endif
 
 static void b43legacy_rng_exit(struct b43legacy_wl *wl)
 {
+#ifdef CONFIG_B43legacy_HWRNG
 	if (wl->rng_initialized)
 		hwrng_unregister(&wl->rng);
+#endif
 }
 
 static int b43legacy_rng_init(struct b43legacy_wl *wl)
 {
-	int err;
+	int err = 0;
 
+#ifdef CONFIG_B43legacy_HWRNG
 	snprintf(wl->rng_name, ARRAY_SIZE(wl->rng_name),
 		 "%s_%s", KBUILD_MODNAME, wiphy_name(wl->hw->wiphy));
 	wl->rng.name = wl->rng_name;
@@ -2433,6 +2438,7 @@ static int b43legacy_rng_init(struct b43
 		       "number generator (%d)\n", err);
 	}
 
+#endif
 	return err;
 }
 

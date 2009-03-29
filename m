Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58717 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbZC2LYV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 07:24:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Do not "select" HW_RANDOM
Date: Sun, 29 Mar 2009 13:19:31 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903291319.31484.mb@bu3sch.de> (sfid-20090329_132425_022514_C11156C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Auto-depend on HW_RANDOM, rather than "select"ing it.
This way the user has the choice to enable or disable HWRNG support.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for the next feature release.


Index: wireless-testing/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Kconfig	2009-03-29 13:08:19.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/Kconfig	2009-03-29 13:08:21.000000000 +0200
@@ -3,7 +3,6 @@ config B43
 	depends on SSB_POSSIBLE && MAC80211 && WLAN_80211 && HAS_DMA
 	select SSB
 	select FW_LOADER
-	select HW_RANDOM
 	---help---
 	  b43 is a driver for the Broadcom 43xx series wireless devices.
 
@@ -106,6 +105,13 @@ config B43_RFKILL
 	depends on B43 && (RFKILL = y || RFKILL = B43) && RFKILL_INPUT && (INPUT_POLLDEV = y || INPUT_POLLDEV = B43)
 	default y
 
+# This config option automatically enables b43 HW-RNG support,
+# if the HW-RNG core is enabled.
+config B43_HWRNG
+	bool
+	depends on B43 && (HW_RANDOM = y || HW_RANDOM = B43)
+	default y
+
 config B43_DEBUG
 	bool "Broadcom 43xx debugging"
 	depends on B43
Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2009-03-29 13:08:19.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-03-29 13:08:21.000000000 +0200
@@ -625,9 +625,11 @@ struct b43_wl {
 	/* Stats about the wireless interface */
 	struct ieee80211_low_level_stats ieee_stats;
 
+#ifdef CONFIG_B43_HWRNG
 	struct hwrng rng;
-	u8 rng_initialized;
+	bool rng_initialized;
 	char rng_name[30 + 1];
+#endif /* CONFIG_B43_HWRNG */
 
 	/* The RF-kill button */
 	struct b43_rfkill rfkill;
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-03-29 13:08:19.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-03-29 13:09:40.000000000 +0200
@@ -2980,6 +2980,7 @@ static void b43_security_init(struct b43
 	b43_clear_keys(dev);
 }
 
+#ifdef CONFIG_B43_HWRNG
 static int b43_rng_read(struct hwrng *rng, u32 *data)
 {
 	struct b43_wl *wl = (struct b43_wl *)rng->priv;
@@ -2995,17 +2996,21 @@ static int b43_rng_read(struct hwrng *rn
 
 	return (sizeof(u16));
 }
+#endif /* CONFIG_B43_HWRNG */
 
 static void b43_rng_exit(struct b43_wl *wl)
 {
+#ifdef CONFIG_B43_HWRNG
 	if (wl->rng_initialized)
 		hwrng_unregister(&wl->rng);
+#endif /* CONFIG_B43_HWRNG */
 }
 
 static int b43_rng_init(struct b43_wl *wl)
 {
-	int err;
+	int err = 0;
 
+#ifdef CONFIG_B43_HWRNG
 	snprintf(wl->rng_name, ARRAY_SIZE(wl->rng_name),
 		 "%s_%s", KBUILD_MODNAME, wiphy_name(wl->hw->wiphy));
 	wl->rng.name = wl->rng_name;
@@ -3018,6 +3023,7 @@ static int b43_rng_init(struct b43_wl *w
 		b43err(wl, "Failed to register the random "
 		       "number generator (%d)\n", err);
 	}
+#endif /* CONFIG_B43_HWRNG */
 
 	return err;
 }

-- 
Greetings, Michael.

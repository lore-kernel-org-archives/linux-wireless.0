Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZC3BvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 21:51:05 -0400
Date: Sun, 29 Mar 2009 20:50:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Do not select HW_RANDOM
Message-ID: <49d02577.Hcf9JT1rjzxhf7CH%Larry.Finger@lwfinger.net> (sfid-20090330_035111_520932_691E0CBA)
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

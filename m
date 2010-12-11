Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42428 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab0LKXvg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Dec 2010 18:51:36 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 6/8] ath9k_hw: clean up SREV version checks
Date: Sun, 12 Dec 2010 00:51:12 +0100
Message-Id: <1292111474-70939-6-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292111474-70939-5-git-send-email-nbd@openwrt.org>
References: <1292111474-70939-1-git-send-email-nbd@openwrt.org>
 <1292111474-70939-2-git-send-email-nbd@openwrt.org>
 <1292111474-70939-3-git-send-email-nbd@openwrt.org>
 <1292111474-70939-4-git-send-email-nbd@openwrt.org>
 <1292111474-70939-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no need to have separate callbacks for pre-AR9003 vs AR9003
SREV version checks, so just merge those into one function.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |   19 -------------------
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |   13 -------------
 drivers/net/wireless/ath/ath9k/hw.c        |   21 +++++++++++++--------
 drivers/net/wireless/ath/ath9k/hw.h        |    2 --
 4 files changed, 13 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 7d5cb20..fdb5a83 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -26,24 +26,6 @@ MODULE_PARM_DESC(nohwcrypt, "Force new ANI for AR5008, AR9001, AR9002");
 
 /* General hardware code for the A5008/AR9001/AR9002 hadware families */
 
-static bool ar9002_hw_macversion_supported(u32 macversion)
-{
-	switch (macversion) {
-	case AR_SREV_VERSION_5416_PCI:
-	case AR_SREV_VERSION_5416_PCIE:
-	case AR_SREV_VERSION_9160:
-	case AR_SREV_VERSION_9100:
-	case AR_SREV_VERSION_9280:
-	case AR_SREV_VERSION_9285:
-	case AR_SREV_VERSION_9287:
-	case AR_SREV_VERSION_9271:
-		return true;
-	default:
-		break;
-	}
-	return false;
-}
-
 static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 {
 	if (AR_SREV_9271(ah)) {
@@ -565,7 +547,6 @@ void ar9002_hw_attach_ops(struct ath_hw *ah)
 
 	priv_ops->init_mode_regs = ar9002_hw_init_mode_regs;
 	priv_ops->init_mode_gain_regs = ar9002_hw_init_mode_gain_regs;
-	priv_ops->macversion_supported = ar9002_hw_macversion_supported;
 
 	ops->config_pci_powersave = ar9002_hw_configpcipowersave;
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 21a5bfe..6137634 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -21,18 +21,6 @@
 
 /* General hardware code for the AR9003 hadware family */
 
-static bool ar9003_hw_macversion_supported(u32 macversion)
-{
-	switch (macversion) {
-	case AR_SREV_VERSION_9300:
-	case AR_SREV_VERSION_9485:
-		return true;
-	default:
-		break;
-	}
-	return false;
-}
-
 /*
  * The AR9003 family uses a new INI format (pre, core, post
  * arrays per subsystem). This provides support for the
@@ -322,7 +310,6 @@ void ar9003_hw_attach_ops(struct ath_hw *ah)
 
 	priv_ops->init_mode_regs = ar9003_hw_init_mode_regs;
 	priv_ops->init_mode_gain_regs = ar9003_hw_init_mode_gain_regs;
-	priv_ops->macversion_supported = ar9003_hw_macversion_supported;
 
 	ops->config_pci_powersave = ar9003_hw_configpcipowersave;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f2298f2..06028e3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -54,13 +54,6 @@ static void ath9k_hw_init_mode_regs(struct ath_hw *ah)
 	ath9k_hw_private_ops(ah)->init_mode_regs(ah);
 }
 
-static bool ath9k_hw_macversion_supported(struct ath_hw *ah)
-{
-	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
-
-	return priv_ops->macversion_supported(ah->hw_version.macVersion);
-}
-
 static u32 ath9k_hw_compute_pll_control(struct ath_hw *ah,
 					struct ath9k_channel *chan)
 {
@@ -534,7 +527,19 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	else
 		ah->config.max_txtrig_level = MAX_TX_FIFO_THRESHOLD;
 
-	if (!ath9k_hw_macversion_supported(ah)) {
+	switch (ah->hw_version.macVersion) {
+	case AR_SREV_VERSION_5416_PCI:
+	case AR_SREV_VERSION_5416_PCIE:
+	case AR_SREV_VERSION_9160:
+	case AR_SREV_VERSION_9100:
+	case AR_SREV_VERSION_9280:
+	case AR_SREV_VERSION_9285:
+	case AR_SREV_VERSION_9287:
+	case AR_SREV_VERSION_9271:
+	case AR_SREV_VERSION_9300:
+	case AR_SREV_VERSION_9485:
+		break;
+	default:
 		ath_err(common,
 			"Mac Chip Rev 0x%02x.%x is not supported by this driver\n",
 			ah->hw_version.macVersion, ah->hw_version.macRev);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 910d3c6..e99b395 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -532,7 +532,6 @@ struct ath_hw_radar_conf {
  *
  * @init_mode_regs: Initializes mode registers
  * @init_mode_gain_regs: Initialize TX/RX gain registers
- * @macversion_supported: If this specific mac revision is supported
  *
  * @rf_set_freq: change frequency
  * @spur_mitigate_freq: spur mitigation
@@ -554,7 +553,6 @@ struct ath_hw_private_ops {
 
 	void (*init_mode_regs)(struct ath_hw *ah);
 	void (*init_mode_gain_regs)(struct ath_hw *ah);
-	bool (*macversion_supported)(u32 macversion);
 	void (*setup_calibration)(struct ath_hw *ah,
 				  struct ath9k_cal_list *currCal);
 
-- 
1.7.3.2


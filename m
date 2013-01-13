Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34594 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab3AMSzN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2013 13:55:13 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.8 2/2] ath9k_hw: fix RF bank initialization
Date: Sun, 13 Jan 2013 19:54:58 +0100
Message-Id: <1358103298-4017-2-git-send-email-nbd@openwrt.org> (sfid-20130113_195527_938543_D3B1AE39)
In-Reply-To: <1358103298-4017-1-git-send-email-nbd@openwrt.org>
References: <1358103298-4017-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ar900*_init_mode_regs needs to be called before RF banks are allocated,
otherwise the storage size of RF banks isn't known. This patch fixes
a memory overrun that can show up as a crash on unloading the module.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c | 12 ++++++++----
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |  2 +-
 drivers/net/wireless/ath/ath9k/hw.c        |  7 -------
 drivers/net/wireless/ath/ath9k/hw.h        |  2 --
 4 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 82f2083..a4654d3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -23,13 +23,13 @@
 
 /* General hardware code for the A5008/AR9001/AR9002 hadware families */
 
-static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
+static int ar9002_hw_init_mode_regs(struct ath_hw *ah)
 {
 	if (AR_SREV_9271(ah)) {
 		INIT_INI_ARRAY(&ah->iniModes, ar9271Modes_9271);
 		INIT_INI_ARRAY(&ah->iniCommon, ar9271Common_9271);
 		INIT_INI_ARRAY(&ah->iniModes_9271_ANI_reg, ar9271Modes_9271_ANI_reg);
-		return;
+		return 0;
 	}
 
 	if (ah->config.pcie_clock_req)
@@ -99,7 +99,7 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 
 		data = devm_kzalloc(ah->dev, size, GFP_KERNEL);
 		if (!data)
-			return;
+			return -ENOMEM;
 
 		memcpy(data, addac->ia_array, size);
 		addac->ia_array = data;
@@ -115,6 +115,7 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
 		       ar9287Common_japan_2484_cck_fir_coeff_9287_1_1);
 	}
+	return 0;
 }
 
 static void ar9280_20_hw_init_rxgain_ini(struct ath_hw *ah)
@@ -410,7 +411,10 @@ int ar9002_hw_attach_ops(struct ath_hw *ah)
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 	int ret;
 
-	priv_ops->init_mode_regs = ar9002_hw_init_mode_regs;
+	ret = ar9002_hw_init_mode_regs(ah);
+	if (ret)
+		return ret;
+
 	priv_ops->init_mode_gain_regs = ar9002_hw_init_mode_gain_regs;
 
 	ops->config_pci_powersave = ar9002_hw_configpcipowersave;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 5dd2f16..a3523c9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -704,7 +704,7 @@ void ar9003_hw_attach_ops(struct ath_hw *ah)
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
-	priv_ops->init_mode_regs = ar9003_hw_init_mode_regs;
+	ar9003_hw_init_mode_regs(ah);
 	priv_ops->init_mode_gain_regs = ar9003_hw_init_mode_gain_regs;
 
 	ops->config_pci_powersave = ar9003_hw_configpcipowersave;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index caf0626..a7448d1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -54,11 +54,6 @@ static void ath9k_hw_init_cal_settings(struct ath_hw *ah)
 	ath9k_hw_private_ops(ah)->init_cal_settings(ah);
 }
 
-static void ath9k_hw_init_mode_regs(struct ath_hw *ah)
-{
-	ath9k_hw_private_ops(ah)->init_mode_regs(ah);
-}
-
 static u32 ath9k_hw_compute_pll_control(struct ath_hw *ah,
 					struct ath9k_channel *chan)
 {
@@ -670,8 +665,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
 
-	ath9k_hw_init_mode_regs(ah);
-
 	if (!ah->is_pciexpress)
 		ath9k_hw_disablepcie(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 2e292f9..04a3f3a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -600,7 +600,6 @@ struct ath_hw_radar_conf {
  * @init_cal_settings: setup types of calibrations supported
  * @init_cal: starts actual calibration
  *
- * @init_mode_regs: Initializes mode registers
  * @init_mode_gain_regs: Initialize TX/RX gain registers
  *
  * @rf_set_freq: change frequency
@@ -619,7 +618,6 @@ struct ath_hw_private_ops {
 	void (*init_cal_settings)(struct ath_hw *ah);
 	bool (*init_cal)(struct ath_hw *ah, struct ath9k_channel *chan);
 
-	void (*init_mode_regs)(struct ath_hw *ah);
 	void (*init_mode_gain_regs)(struct ath_hw *ah);
 	void (*setup_calibration)(struct ath_hw *ah,
 				  struct ath9k_cal_list *currCal);
-- 
1.8.0.2


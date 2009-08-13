Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52946 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbZHMEEL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 00:04:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 21:04:13 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19075.37072.217575.619146@gargle.gargle.HOWL>
Date: Thu, 13 Aug 2009 09:34:32 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] ath9k: Remove duplicate variables
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

diversity_control and antenna_switch_swap are already
present in ath9k_ops_config. Remove duplicate occurrences
in ath_hw.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    7 ++-----
 drivers/net/wireless/ath/ath9k/hw.h  |   16 +++++++---------
 drivers/net/wireless/ath/ath9k/phy.c |   12 +++++-------
 3 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0e83e98..6eef7b4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -407,7 +407,7 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.cck_trig_high = 200;
 	ah->config.cck_trig_low = 100;
 	ah->config.enable_ani = 1;
-	ah->config.diversity_control = 0;
+	ah->config.diversity_control = ATH9K_ANT_VARIABLE;
 	ah->config.antenna_switch_swap = 0;
 
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
@@ -452,9 +452,6 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->regulatory.power_limit = MAX_RATE_POWER;
 	ah->regulatory.tp_scale = ATH9K_TP_SCALE_MAX;
 	ah->atim_window = 0;
-	ah->diversity_control = ah->config.diversity_control;
-	ah->antenna_switch_swap =
-		ah->config.antenna_switch_swap;
 	ah->sta_id1_defaults = AR_STA_ID1_CRPT_MIC_ENABLE;
 	ah->beacon_interval = 100;
 	ah->enable_32kHz_clock = DONT_USE_32KHZ;
@@ -3891,7 +3888,7 @@ bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
 			break;
 		}
 	} else {
-		ah->diversity_control = settings;
+		ah->config.diversity_control = settings;
 	}
 
 	return true;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0e65873..0336981 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -127,6 +127,12 @@ enum wireless_mode {
 	ATH9K_MODE_MAX,
 };
 
+enum ath9k_ant_setting {
+	ATH9K_ANT_VARIABLE = 0,
+	ATH9K_ANT_FIXED_A,
+	ATH9K_ANT_FIXED_B
+};
+
 enum ath9k_hw_caps {
 	ATH9K_HW_CAP_MIC_AESCCM                 = BIT(0),
 	ATH9K_HW_CAP_MIC_CKIP                   = BIT(1),
@@ -191,7 +197,7 @@ struct ath9k_ops_config {
 	u32 cck_trig_high;
 	u32 cck_trig_low;
 	u32 enable_ani;
-	u16 diversity_control;
+	enum ath9k_ant_setting diversity_control;
 	u16 antenna_switch_swap;
 	int serialize_regmode;
 	bool intr_mitigation;
@@ -330,12 +336,6 @@ enum ath9k_power_mode {
 	ATH9K_PM_UNDEFINED
 };
 
-enum ath9k_ant_setting {
-	ATH9K_ANT_VARIABLE = 0,
-	ATH9K_ANT_FIXED_A,
-	ATH9K_ANT_FIXED_B
-};
-
 enum ath9k_tp_scale {
 	ATH9K_TP_SCALE_MAX = 0,
 	ATH9K_TP_SCALE_50,
@@ -437,8 +437,6 @@ struct ath_hw {
 	u32 txurn_interrupt_mask;
 	bool chip_fullsleep;
 	u32 atim_window;
-	u16 antenna_switch_swap;
-	enum ath9k_ant_setting diversity_control;
 
 	/* Calibration */
 	enum ath9k_cal_types supp_cals;
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index 59bb3ce..63bf9a3 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -353,18 +353,16 @@ ath9k_hw_decrease_chain_power(struct ath_hw *ah, struct ath9k_channel *chan)
 	u32 bank6SelMask;
 	u32 *bank6Temp = ah->bank6Temp;
 
-	switch (ah->diversity_control) {
+	switch (ah->config.diversity_control) {
 	case ATH9K_ANT_FIXED_A:
 		bank6SelMask =
-		    (ah->
-		     antenna_switch_swap & ANTSWAP_AB) ? REDUCE_CHAIN_0 :
-		    REDUCE_CHAIN_1;
+		    (ah->config.antenna_switch_swap & ANTSWAP_AB) ?
+			REDUCE_CHAIN_0 : REDUCE_CHAIN_1;
 		break;
 	case ATH9K_ANT_FIXED_B:
 		bank6SelMask =
-		    (ah->
-		     antenna_switch_swap & ANTSWAP_AB) ? REDUCE_CHAIN_1 :
-		    REDUCE_CHAIN_0;
+		    (ah->config.antenna_switch_swap & ANTSWAP_AB) ?
+			REDUCE_CHAIN_1 : REDUCE_CHAIN_0;
 		break;
 	case ATH9K_ANT_VARIABLE:
 		return;
-- 
1.6.4


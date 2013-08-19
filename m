Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:60676 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3HSFhj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 01:37:39 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Add antenna diversity tweak for CUS198
Date: Mon, 19 Aug 2013 11:04:01 +0530
Message-Id: <1376890441-13070-1-git-send-email-sujith@msujith.org> (sfid-20130819_073747_125077_F1C27B1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This improves RX diversity and performance for AR9485.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 5 +++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    | 2 ++
 drivers/net/wireless/ath/ath9k/hw.h            | 1 +
 drivers/net/wireless/ath/ath9k/init.c          | 1 +
 4 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index abdc7ee..a6846ab 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3825,6 +3825,11 @@ static void ar9003_hw_atten_apply(struct ath_hw *ah, struct ath9k_channel *chan)
 			else
 				value = ar9003_hw_atten_chain_get_margin(ah, i, chan);
 
+			if (ah->config.alt_mingainidx)
+				REG_RMW_FIELD(ah, AR_PHY_EXT_ATTEN_CTL_0,
+					      AR_PHY_EXT_ATTEN_CTL_XATTEN1_MARGIN,
+					      value);
+
 			REG_RMW_FIELD(ah, ext_atten_reg[i],
 				      AR_PHY_EXT_ATTEN_CTL_XATTEN1_MARGIN,
 				      value);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 23c019d..6fd7523 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -148,6 +148,8 @@
 #define AR_PHY_SFCORR_SPUR_SUBCHNL_SD_S   28
 #define AR_PHY_EXT_CCA_THRESH62 0x007F0000
 #define AR_PHY_EXT_CCA_THRESH62_S       16
+#define AR_PHY_EXTCHN_PWRTHR1_ANT_DIV_ALT_ANT_MINGAINIDX    0x0000FF00
+#define AR_PHY_EXTCHN_PWRTHR1_ANT_DIV_ALT_ANT_MINGAINIDX_S  8
 #define AR_PHY_EXT_MINCCA_PWR   0x01FF0000
 #define AR_PHY_EXT_MINCCA_PWR_S 16
 #define AR_PHY_EXT_CYCPWR_THR1 0x0000FE00L
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 64ff8e6..fa543a6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -314,6 +314,7 @@ struct ath9k_ops_config {
 	u32 xlna_gpio;
 	u32 ant_ctrl_comm2g_switch_enable;
 	bool xatten_margin_cfg;
+	bool alt_mingainidx;
 };
 
 enum ath9k_int {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index abf1eb5..19b46c7 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -534,6 +534,7 @@ static void ath9k_init_platform(struct ath_softc *sc)
 			       ATH9K_PCI_CUS230)) {
 		ah->config.xlna_gpio = 9;
 		ah->config.xatten_margin_cfg = true;
+		ah->config.alt_mingainidx = true;
 		ah->config.ant_ctrl_comm2g_switch_enable = 0x000BBB88;
 		sc->ant_comb.low_rssi_thresh = 20;
 		sc->ant_comb.fast_div_bias = 3;
-- 
1.8.3.4


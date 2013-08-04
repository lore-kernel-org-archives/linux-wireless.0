Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:55420 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3HDIzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Aug 2013 04:55:46 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/11] ath9k: Program HW for WB195 diversity
Date: Sun,  4 Aug 2013 14:21:59 +0530
Message-Id: <1375606322-9983-8-git-send-email-sujith@msujith.org> (sfid-20130804_105610_728684_9BAD32D0)
In-Reply-To: <1375606322-9983-1-git-send-email-sujith@msujith.org>
References: <1375606322-9983-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The MC_GAIN_CTL/CCK_DETECT registers have to be programmed
with the correct configuration values if WLAN/BT RX diversity
is enabled. Add this and also take care of the BTCOEX mode
when fast diversity is enabled/disabled.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c | 60 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9002_phy.h |  6 +++
 2 files changed, 66 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index f400351..456d8b9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -555,6 +555,65 @@ static void ar9002_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_MULTICHAIN_GAIN_CTL, regval);
 }
 
+static void ar9002_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
+{
+	struct ath_btcoex_hw *btcoex = &ah->btcoex_hw;
+	u8 antdiv_ctrl1, antdiv_ctrl2;
+	u32 regval;
+
+	if (enable) {
+		antdiv_ctrl1 = ATH_BT_COEX_ANTDIV_CONTROL1_ENABLE;
+		antdiv_ctrl2 = ATH_BT_COEX_ANTDIV_CONTROL2_ENABLE;
+
+		/*
+		 * Don't disable BT ant to allow BB to control SWCOM.
+		 */
+		btcoex->bt_coex_mode2 &= (~(AR_BT_DISABLE_BT_ANT));
+		REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex->bt_coex_mode2);
+
+		REG_WRITE(ah, AR_PHY_SWITCH_COM, ATH_BT_COEX_ANT_DIV_SWITCH_COM);
+		REG_RMW(ah, AR_PHY_SWITCH_CHAIN_0, 0, 0xf0000000);
+	} else {
+		/*
+		 * Disable antenna diversity, use LNA1 only.
+		 */
+		antdiv_ctrl1 = ATH_BT_COEX_ANTDIV_CONTROL1_FIXED_A;
+		antdiv_ctrl2 = ATH_BT_COEX_ANTDIV_CONTROL2_FIXED_A;
+
+		/*
+		 * Disable BT Ant. to allow concurrent BT and WLAN receive.
+		 */
+		btcoex->bt_coex_mode2 |= AR_BT_DISABLE_BT_ANT;
+		REG_WRITE(ah, AR_BT_COEX_MODE2, btcoex->bt_coex_mode2);
+
+		/*
+		 * Program SWCOM table to make sure RF switch always parks
+		 * at BT side.
+		 */
+		REG_WRITE(ah, AR_PHY_SWITCH_COM, 0);
+		REG_RMW(ah, AR_PHY_SWITCH_CHAIN_0, 0, 0xf0000000);
+	}
+
+	regval = REG_READ(ah, AR_PHY_MULTICHAIN_GAIN_CTL);
+	regval &= (~(AR_PHY_9285_ANT_DIV_CTL_ALL));
+        /*
+	 * Clear ant_fast_div_bias [14:9] since for WB195,
+	 * the main LNA is always LNA1.
+	 */
+	regval &= (~(AR_PHY_9285_FAST_DIV_BIAS));
+	regval |= SM(antdiv_ctrl1, AR_PHY_9285_ANT_DIV_CTL);
+	regval |= SM(antdiv_ctrl2, AR_PHY_9285_ANT_DIV_ALT_LNACONF);
+	regval |= SM((antdiv_ctrl2 >> 2), AR_PHY_9285_ANT_DIV_MAIN_LNACONF);
+	regval |= SM((antdiv_ctrl1 >> 1), AR_PHY_9285_ANT_DIV_ALT_GAINTB);
+	regval |= SM((antdiv_ctrl1 >> 2), AR_PHY_9285_ANT_DIV_MAIN_GAINTB);
+	REG_WRITE(ah, AR_PHY_MULTICHAIN_GAIN_CTL, regval);
+
+	regval = REG_READ(ah, AR_PHY_CCK_DETECT);
+	regval &= (~AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV);
+	regval |= SM((antdiv_ctrl1 >> 3), AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV);
+	REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
+}
+
 static void ar9002_hw_spectral_scan_config(struct ath_hw *ah,
 				    struct ath_spec_scan *param)
 {
@@ -630,6 +689,7 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 
 	ops->antdiv_comb_conf_get = ar9002_hw_antdiv_comb_conf_get;
 	ops->antdiv_comb_conf_set = ar9002_hw_antdiv_comb_conf_set;
+	ops->set_bt_ant_diversity = ar9002_hw_set_bt_ant_diversity;
 	ops->spectral_scan_config = ar9002_hw_spectral_scan_config;
 	ops->spectral_scan_trigger = ar9002_hw_spectral_scan_trigger;
 	ops->spectral_scan_wait = ar9002_hw_spectral_scan_wait;
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
index d3f0928..6314ae2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
@@ -320,6 +320,12 @@
 #define AR_PHY_9285_ANT_DIV_GAINTB_0        0
 #define AR_PHY_9285_ANT_DIV_GAINTB_1        1
 
+#define ATH_BT_COEX_ANTDIV_CONTROL1_ENABLE  0x0b
+#define ATH_BT_COEX_ANTDIV_CONTROL2_ENABLE  0x09
+#define ATH_BT_COEX_ANTDIV_CONTROL1_FIXED_A 0x04
+#define ATH_BT_COEX_ANTDIV_CONTROL2_FIXED_A 0x09
+#define ATH_BT_COEX_ANT_DIV_SWITCH_COM      0x66666666
+
 #define AR_PHY_EXT_CCA0             0x99b8
 #define AR_PHY_EXT_CCA0_THRESH62    0x000000FF
 #define AR_PHY_EXT_CCA0_THRESH62_S  0
-- 
1.8.3.4


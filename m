Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:39722 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3HDIzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Aug 2013 04:55:52 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/11] ath9k: Support ANT diversity for WB225
Date: Sun,  4 Aug 2013 14:22:02 +0530
Message-Id: <1375606322-9983-11-git-send-email-sujith@msujith.org> (sfid-20130804_105604_640667_3E5F9AD2)
In-Reply-To: <1375606322-9983-1-git-send-email-sujith@msujith.org>
References: <1375606322-9983-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

WB225 based cards like CUS198 and CUS230 support
both fast antenna diversity and LNA combining. Add support
for this and also program the SWCOM register with the
correct "ant_ctrl_comm2g_switch_enable" value.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   5 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |   2 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 120 +++++++++++++++++--------
 3 files changed, 86 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index c2f1f18..178052f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3541,13 +3541,12 @@ static u16 ar9003_switch_com_spdt_get(struct ath_hw *ah, bool is2ghz)
 	return le16_to_cpu(ar9003_modal_header(ah, is2ghz)->switchcomspdt);
 }
 
-
-static u32 ar9003_hw_ant_ctrl_common_get(struct ath_hw *ah, bool is2ghz)
+u32 ar9003_hw_ant_ctrl_common_get(struct ath_hw *ah, bool is2ghz)
 {
 	return le32_to_cpu(ar9003_modal_header(ah, is2ghz)->antCtrlCommon);
 }
 
-static u32 ar9003_hw_ant_ctrl_common_2_get(struct ath_hw *ah, bool is2ghz)
+u32 ar9003_hw_ant_ctrl_common_2_get(struct ath_hw *ah, bool is2ghz)
 {
 	return le32_to_cpu(ar9003_modal_header(ah, is2ghz)->antCtrlCommon2);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 874f657..75d4fb4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -334,6 +334,8 @@ struct ar9300_eeprom {
 
 s32 ar9003_hw_get_tx_gain_idx(struct ath_hw *ah);
 s32 ar9003_hw_get_rx_gain_idx(struct ath_hw *ah);
+u32 ar9003_hw_ant_ctrl_common_get(struct ath_hw *ah, bool is2ghz);
+u32 ar9003_hw_ant_ctrl_common_2_get(struct ath_hw *ah, bool is2ghz);
 
 u8 *ar9003_get_spur_chan_ptr(struct ath_hw *ah, bool is_2ghz);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 55021f1..4898829 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1414,58 +1414,102 @@ static void ar9003_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 
 static void ar9003_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 {
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	u8 ant_div_ctl1;
 	u32 regval;
 
-	if (!AR_SREV_9565(ah))
+	if (!AR_SREV_9485(ah) && !AR_SREV_9565(ah))
 		return;
 
+	if (AR_SREV_9485(ah)) {
+		regval = ar9003_hw_ant_ctrl_common_2_get(ah,
+						 IS_CHAN_2GHZ(ah->curchan));
+		if (enable) {
+			regval &= ~AR_SWITCH_TABLE_COM2_ALL;
+			regval |= ah->config.ant_ctrl_comm2g_switch_enable;
+		}
+		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM_2,
+			      AR_SWITCH_TABLE_COM2_ALL, regval);
+	}
+
 	ant_div_ctl1 = ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
 
+	/*
+	 * Set MAIN/ALT LNA conf.
+	 * Set MAIN/ALT gain_tb.
+	 */
 	regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
 	regval &= (~AR_ANT_DIV_CTRL_ALL);
 	regval |= (ant_div_ctl1 & 0x3f) << AR_ANT_DIV_CTRL_ALL_S;
-	regval &= ~AR_PHY_ANT_DIV_LNADIV;
-	regval |= ((ant_div_ctl1 >> 6) & 0x1) << AR_PHY_ANT_DIV_LNADIV_S;
-
-	if (enable)
-		regval |= AR_ANT_DIV_ENABLE;
-
 	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
 
-	regval = REG_READ(ah, AR_PHY_CCK_DETECT);
-	regval &= ~AR_FAST_DIV_ENABLE;
-	regval |= ((ant_div_ctl1 >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;
-
-	if (enable)
-		regval |= AR_FAST_DIV_ENABLE;
-
-	REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
-
-	if (enable) {
-		REG_SET_BIT(ah, AR_PHY_MC_GAIN_CTRL,
-			    (1 << AR_PHY_ANT_SW_RX_PROT_S));
-		if (ah->curchan && IS_CHAN_2GHZ(ah->curchan))
-			REG_SET_BIT(ah, AR_PHY_RESTART,
-				    AR_PHY_RESTART_ENABLE_DIV_M2FLAG);
-		REG_SET_BIT(ah, AR_BTCOEX_WL_LNADIV,
-			    AR_BTCOEX_WL_LNADIV_FORCE_ON);
-	} else {
-		REG_CLR_BIT(ah, AR_PHY_MC_GAIN_CTRL, AR_ANT_DIV_ENABLE);
-		REG_CLR_BIT(ah, AR_PHY_MC_GAIN_CTRL,
-			    (1 << AR_PHY_ANT_SW_RX_PROT_S));
-		REG_CLR_BIT(ah, AR_PHY_CCK_DETECT, AR_FAST_DIV_ENABLE);
-		REG_CLR_BIT(ah, AR_BTCOEX_WL_LNADIV,
-			    AR_BTCOEX_WL_LNADIV_FORCE_ON);
-
+	if (AR_SREV_9485_11(ah)) {
+		/*
+		 * Enable LNA diversity.
+		 */
 		regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
-		regval &= ~(AR_PHY_ANT_DIV_MAIN_LNACONF |
-			AR_PHY_ANT_DIV_ALT_LNACONF |
-			AR_PHY_ANT_DIV_MAIN_GAINTB |
-			AR_PHY_ANT_DIV_ALT_GAINTB);
-		regval |= (ATH_ANT_DIV_COMB_LNA1 << AR_PHY_ANT_DIV_MAIN_LNACONF_S);
-		regval |= (ATH_ANT_DIV_COMB_LNA2 << AR_PHY_ANT_DIV_ALT_LNACONF_S);
+		regval &= ~AR_PHY_ANT_DIV_LNADIV;
+		regval |= ((ant_div_ctl1 >> 6) & 0x1) << AR_PHY_ANT_DIV_LNADIV_S;
+		if (enable)
+			regval |= AR_ANT_DIV_ENABLE;
+
 		REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
+
+		/*
+		 * Enable fast antenna diversity.
+		 */
+		regval = REG_READ(ah, AR_PHY_CCK_DETECT);
+		regval &= ~AR_FAST_DIV_ENABLE;
+		regval |= ((ant_div_ctl1 >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;
+		if (enable)
+			regval |= AR_FAST_DIV_ENABLE;
+
+		REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
+
+		if (pCap->hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
+			regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
+			regval &= (~(AR_PHY_ANT_DIV_MAIN_LNACONF |
+				     AR_PHY_ANT_DIV_ALT_LNACONF |
+				     AR_PHY_ANT_DIV_ALT_GAINTB |
+				     AR_PHY_ANT_DIV_MAIN_GAINTB));
+			/*
+			 * Set MAIN to LNA1 and ALT to LNA2 at the
+			 * beginning.
+			 */
+			regval |= (ATH_ANT_DIV_COMB_LNA1 <<
+				   AR_PHY_ANT_DIV_MAIN_LNACONF_S);
+			regval |= (ATH_ANT_DIV_COMB_LNA2 <<
+				   AR_PHY_ANT_DIV_ALT_LNACONF_S);
+			REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
+		}
+	} else if (AR_SREV_9565(ah)) {
+		if (enable) {
+			REG_SET_BIT(ah, AR_PHY_MC_GAIN_CTRL,
+				    (1 << AR_PHY_ANT_SW_RX_PROT_S));
+			if (ah->curchan && IS_CHAN_2GHZ(ah->curchan))
+				REG_SET_BIT(ah, AR_PHY_RESTART,
+					    AR_PHY_RESTART_ENABLE_DIV_M2FLAG);
+			REG_SET_BIT(ah, AR_BTCOEX_WL_LNADIV,
+				    AR_BTCOEX_WL_LNADIV_FORCE_ON);
+		} else {
+			REG_CLR_BIT(ah, AR_PHY_MC_GAIN_CTRL, AR_ANT_DIV_ENABLE);
+			REG_CLR_BIT(ah, AR_PHY_MC_GAIN_CTRL,
+				    (1 << AR_PHY_ANT_SW_RX_PROT_S));
+			REG_CLR_BIT(ah, AR_PHY_CCK_DETECT, AR_FAST_DIV_ENABLE);
+			REG_CLR_BIT(ah, AR_BTCOEX_WL_LNADIV,
+				    AR_BTCOEX_WL_LNADIV_FORCE_ON);
+
+			regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
+			regval &= ~(AR_PHY_ANT_DIV_MAIN_LNACONF |
+				    AR_PHY_ANT_DIV_ALT_LNACONF |
+				    AR_PHY_ANT_DIV_MAIN_GAINTB |
+				    AR_PHY_ANT_DIV_ALT_GAINTB);
+			regval |= (ATH_ANT_DIV_COMB_LNA1 <<
+				   AR_PHY_ANT_DIV_MAIN_LNACONF_S);
+			regval |= (ATH_ANT_DIV_COMB_LNA2 <<
+				   AR_PHY_ANT_DIV_ALT_LNACONF_S);
+			REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
+		}
 	}
 }
 
-- 
1.8.3.4


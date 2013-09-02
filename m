Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46260 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab3IBIc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 04:32:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 3/8] ath9k: Fix antenna diversity init for AR9565
Date: Mon,  2 Sep 2013 13:59:01 +0530
Message-Id: <1378110546-22305-3-git-send-email-sujith@msujith.org> (sfid-20130902_103306_175173_1D56B94B)
In-Reply-To: <1378110546-22305-1-git-send-email-sujith@msujith.org>
References: <21028.19411.335796.192256@gargle.gargle.HOWL>
 <1378110546-22305-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Program the HW registers (AR_PHY_CCK_DETECT, AR_PHY_MC_GAIN_CTRL)
with the correct values for AR9565 to allow LNA combining.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 17 ++++++++++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 17 ++++++++++++-----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 6af2d73..5982256 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3659,9 +3659,23 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 		if (AR_SREV_9565(ah)) {
 			if (common->bt_ant_diversity) {
 				regval |= (1 << AR_PHY_ANT_SW_RX_PROT_S);
+
+				REG_SET_BIT(ah, AR_PHY_RESTART,
+					    AR_PHY_RESTART_ENABLE_DIV_M2FLAG);
+
+				/* Force WLAN LNA diversity ON */
+				REG_SET_BIT(ah, AR_BTCOEX_WL_LNADIV,
+					    AR_BTCOEX_WL_LNADIV_FORCE_ON);
 			} else {
 				regval &= ~(1 << AR_PHY_ANT_DIV_LNADIV_S);
 				regval &= ~(1 << AR_PHY_ANT_SW_RX_PROT_S);
+
+				REG_CLR_BIT(ah, AR_PHY_MC_GAIN_CTRL,
+					    (1 << AR_PHY_ANT_SW_RX_PROT_S));
+
+				/* Force WLAN LNA diversity OFF */
+				REG_CLR_BIT(ah, AR_BTCOEX_WL_LNADIV,
+					    AR_BTCOEX_WL_LNADIV_FORCE_ON);
 			}
 		}
 
@@ -3672,7 +3686,8 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 		regval &= (~AR_FAST_DIV_ENABLE);
 		regval |= ((value >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;
 
-		if (AR_SREV_9485(ah) && common->bt_ant_diversity)
+		if ((AR_SREV_9485(ah) || AR_SREV_9565(ah))
+		    && common->bt_ant_diversity)
 			regval |= AR_FAST_DIV_ENABLE;
 
 		REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index e897648..9ca9b2c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1489,17 +1489,24 @@ static void ar9003_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
 	} else if (AR_SREV_9565(ah)) {
 		if (enable) {
 			REG_SET_BIT(ah, AR_PHY_MC_GAIN_CTRL,
+				    AR_ANT_DIV_ENABLE);
+			REG_SET_BIT(ah, AR_PHY_MC_GAIN_CTRL,
 				    (1 << AR_PHY_ANT_SW_RX_PROT_S));
-			if (ah->curchan && IS_CHAN_2GHZ(ah->curchan))
-				REG_SET_BIT(ah, AR_PHY_RESTART,
-					    AR_PHY_RESTART_ENABLE_DIV_M2FLAG);
+			REG_SET_BIT(ah, AR_PHY_CCK_DETECT,
+				    AR_FAST_DIV_ENABLE);
+			REG_SET_BIT(ah, AR_PHY_RESTART,
+				    AR_PHY_RESTART_ENABLE_DIV_M2FLAG);
 			REG_SET_BIT(ah, AR_BTCOEX_WL_LNADIV,
 				    AR_BTCOEX_WL_LNADIV_FORCE_ON);
 		} else {
-			REG_CLR_BIT(ah, AR_PHY_MC_GAIN_CTRL, AR_ANT_DIV_ENABLE);
+			REG_CLR_BIT(ah, AR_PHY_MC_GAIN_CTRL,
+				    AR_ANT_DIV_ENABLE);
 			REG_CLR_BIT(ah, AR_PHY_MC_GAIN_CTRL,
 				    (1 << AR_PHY_ANT_SW_RX_PROT_S));
-			REG_CLR_BIT(ah, AR_PHY_CCK_DETECT, AR_FAST_DIV_ENABLE);
+			REG_CLR_BIT(ah, AR_PHY_CCK_DETECT,
+				    AR_FAST_DIV_ENABLE);
+			REG_CLR_BIT(ah, AR_PHY_RESTART,
+				    AR_PHY_RESTART_ENABLE_DIV_M2FLAG);
 			REG_CLR_BIT(ah, AR_BTCOEX_WL_LNADIV,
 				    AR_BTCOEX_WL_LNADIV_FORCE_ON);
 
-- 
1.8.4


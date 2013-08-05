Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:51881 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3HEJmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 05:42:05 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ath9k: Fix antenna control init for AR9485
Date: Mon,  5 Aug 2013 15:08:27 +0530
Message-Id: <1375695508-1997-2-git-send-email-sujith@msujith.org> (sfid-20130805_114211_145583_183C6D63)
In-Reply-To: <1375695508-1997-1-git-send-email-sujith@msujith.org>
References: <1375695508-1997-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 178052f..abdc7ee 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3614,6 +3614,11 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 	}
 
 	value = ar9003_hw_ant_ctrl_common_2_get(ah, is2ghz);
+	if (AR_SREV_9485(ah) && common->bt_ant_diversity) {
+		regval &= ~AR_SWITCH_TABLE_COM2_ALL;
+		regval |= ah->config.ant_ctrl_comm2g_switch_enable;
+
+	}
 	REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM_2, AR_SWITCH_TABLE_COM2_ALL, value);
 
 	if ((AR_SREV_9462(ah)) && (ah->rxchainmask == 0x2)) {
@@ -3645,6 +3650,9 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 		regval &= (~AR_PHY_ANT_DIV_LNADIV);
 		regval |= ((value >> 6) & 0x1) << AR_PHY_ANT_DIV_LNADIV_S;
 
+		if (AR_SREV_9485(ah) && common->bt_ant_diversity)
+			regval |= AR_ANT_DIV_ENABLE;
+
 		if (AR_SREV_9565(ah)) {
 			if (common->bt_ant_diversity) {
 				regval |= (1 << AR_PHY_ANT_SW_RX_PROT_S);
@@ -3656,10 +3664,14 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 
 		REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
 
-		/*enable fast_div */
+		/* enable fast_div */
 		regval = REG_READ(ah, AR_PHY_CCK_DETECT);
 		regval &= (~AR_FAST_DIV_ENABLE);
 		regval |= ((value >> 7) & 0x1) << AR_FAST_DIV_ENABLE_S;
+
+		if (AR_SREV_9485(ah) && common->bt_ant_diversity)
+			regval |= AR_FAST_DIV_ENABLE;
+
 		REG_WRITE(ah, AR_PHY_CCK_DETECT, regval);
 
 		if (pCap->hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
-- 
1.8.3.4


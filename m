Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:60370 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3CDHOj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 02:14:39 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] ath9k_hw: Fix fixed antenna for AR9462
Date: Mon,  4 Mar 2013 12:42:55 +0530
Message-Id: <1362381175-9634-4-git-send-email-sujith@msujith.org> (sfid-20130304_081445_454022_5804F750)
In-Reply-To: <1362381175-9634-1-git-send-email-sujith@msujith.org>
References: <1362381175-9634-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When the RX chainmask is set to 0x2 for AR9462, certain values
from chain1 have to be programmed for chain0 also.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 881e989..e6b92ff 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3606,6 +3606,12 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 	value = ar9003_hw_ant_ctrl_common_2_get(ah, is2ghz);
 	REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM_2, AR_SWITCH_TABLE_COM2_ALL, value);
 
+	if ((AR_SREV_9462(ah)) && (ah->rxchainmask == 0x2)) {
+		value = ar9003_hw_ant_ctrl_chain_get(ah, 1, is2ghz);
+		REG_RMW_FIELD(ah, switch_chain_reg[0],
+			      AR_SWITCH_TABLE_ALL, value);
+	}
+
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
 		if ((ah->rxchainmask & BIT(chain)) ||
 		    (ah->txchainmask & BIT(chain))) {
@@ -3772,6 +3778,17 @@ static void ar9003_hw_atten_apply(struct ath_hw *ah, struct ath9k_channel *chan)
 					  AR_PHY_EXT_ATTEN_CTL_2,
 					 };
 
+	if ((AR_SREV_9462(ah)) && (ah->rxchainmask == 0x2)) {
+		value = ar9003_hw_atten_chain_get(ah, 1, chan);
+		REG_RMW_FIELD(ah, ext_atten_reg[0],
+			      AR_PHY_EXT_ATTEN_CTL_XATTEN1_DB, value);
+
+		value = ar9003_hw_atten_chain_get_margin(ah, 1, chan);
+		REG_RMW_FIELD(ah, ext_atten_reg[0],
+			      AR_PHY_EXT_ATTEN_CTL_XATTEN1_MARGIN,
+			      value);
+	}
+
 	/* Test value. if 0 then attenuation is unused. Don't load anything. */
 	for (i = 0; i < 3; i++) {
 		if (ah->txchainmask & BIT(i)) {
-- 
1.8.1.5


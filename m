Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38925 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab1DLNSn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 09:18:43 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 06:18:17 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 17/22] ath9k_hw: Configure chain switch table and attenuation control only for active chains
Date: Tue, 12 Apr 2011 18:47:50 +0530
Message-ID: <1302614273-2063-10-git-send-email-vasanth@atheros.com>
In-Reply-To: <1302614273-2063-1-git-send-email-vasanth@atheros.com>
References: <1302614273-2063-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   44 ++++++++++++++----------
 1 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 262fb62..fd9b8c4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3501,23 +3501,28 @@ static u16 ar9003_hw_ant_ctrl_chain_get(struct ath_hw *ah,
 
 static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 {
+	int chain;
+	static const u32 switch_chain_reg[AR9300_MAX_CHAINS] = {
+			AR_PHY_SWITCH_CHAIN_0,
+			AR_PHY_SWITCH_CHAIN_1,
+			AR_PHY_SWITCH_CHAIN_2,
+	};
+
 	u32 value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
+
 	REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM, AR_SWITCH_TABLE_COM_ALL, value);
 
 	value = ar9003_hw_ant_ctrl_common_2_get(ah, is2ghz);
 	REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM_2, AR_SWITCH_TABLE_COM2_ALL, value);
 
-	value = ar9003_hw_ant_ctrl_chain_get(ah, 0, is2ghz);
-	REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_0, AR_SWITCH_TABLE_ALL, value);
-
-	if (!AR_SREV_9485(ah)) {
-		value = ar9003_hw_ant_ctrl_chain_get(ah, 1, is2ghz);
-		REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_1, AR_SWITCH_TABLE_ALL,
-			      value);
-
-		value = ar9003_hw_ant_ctrl_chain_get(ah, 2, is2ghz);
-		REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_2, AR_SWITCH_TABLE_ALL,
-			      value);
+	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
+		if ((ah->rxchainmask & BIT(chain)) ||
+		    (ah->txchainmask & BIT(chain))) {
+			value = ar9003_hw_ant_ctrl_chain_get(ah, chain,
+							     is2ghz);
+			REG_RMW_FIELD(ah, switch_chain_reg[chain],
+				      AR_SWITCH_TABLE_ALL, value);
+		}
 	}
 
 	if (AR_SREV_9485(ah)) {
@@ -3638,13 +3643,16 @@ static void ar9003_hw_atten_apply(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	/* Test value. if 0 then attenuation is unused. Don't load anything. */
 	for (i = 0; i < 3; i++) {
-		value = ar9003_hw_atten_chain_get(ah, i, chan);
-		REG_RMW_FIELD(ah, ext_atten_reg[i],
-			      AR_PHY_EXT_ATTEN_CTL_XATTEN1_DB, value);
-
-		value = ar9003_hw_atten_chain_get_margin(ah, i, chan);
-		REG_RMW_FIELD(ah, ext_atten_reg[i],
-			      AR_PHY_EXT_ATTEN_CTL_XATTEN1_MARGIN, value);
+		if (ah->txchainmask & BIT(i)) {
+			value = ar9003_hw_atten_chain_get(ah, i, chan);
+			REG_RMW_FIELD(ah, ext_atten_reg[i],
+				      AR_PHY_EXT_ATTEN_CTL_XATTEN1_DB, value);
+
+			value = ar9003_hw_atten_chain_get_margin(ah, i, chan);
+			REG_RMW_FIELD(ah, ext_atten_reg[i],
+				      AR_PHY_EXT_ATTEN_CTL_XATTEN1_MARGIN,
+				      value);
+		}
 	}
 }
 
-- 
1.7.0.4


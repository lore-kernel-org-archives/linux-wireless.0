Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:47083 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaKKHGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 02:06:04 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 4/6] ath9k: Fix high tx power in multi-chain mode
Date: Tue, 11 Nov 2014 12:37:22 +0530
Message-Id: <1415689644-29693-5-git-send-email-sujith@msujith.org> (sfid-20141111_080615_790455_5EE3E642)
In-Reply-To: <1415689644-29693-1-git-send-email-sujith@msujith.org>
References: <1415689644-29693-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

For multi-chain chips, if the thermometer is switched off for a chain
which can be disabled by software(e.g tx_chainmask=0x1), the measured tx
power is about 5dB higher than target power.

Set thermometer on for all chains to fix this issue.

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 80c6eac..a5f4b19 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4084,25 +4084,27 @@ static void ar9003_hw_thermometer_apply(struct ath_hw *ah)
 
 	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX4,
 		      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
-	if (ah->caps.tx_chainmask & BIT(1))
+	if (!AR_SREV_9330(ah) && !AR_SREV_9485(ah)) {
 		REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX4,
 			      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
-	if (ah->caps.tx_chainmask & BIT(2))
-		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
-			      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
+		if (!AR_SREV_9340(ah) && !AR_SREV_9462(ah) && !AR_SREV_9531(ah))
+			REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
+				      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR,
+				      therm_on);
+	}
 
 	therm_on = (thermometer < 0) ? 0 : (thermometer == 0);
 	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX4,
 		      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
-	if (ah->caps.tx_chainmask & BIT(1)) {
+	if (!AR_SREV_9330(ah) && !AR_SREV_9485(ah)) {
 		therm_on = (thermometer < 0) ? 0 : (thermometer == 1);
 		REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX4,
 			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
-	}
-	if (ah->caps.tx_chainmask & BIT(2)) {
-		therm_on = (thermometer < 0) ? 0 : (thermometer == 2);
-		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
-			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
+		if (!AR_SREV_9340(ah) && !AR_SREV_9462(ah) && !AR_SREV_9531(ah)) {
+			therm_on = (thermometer < 0) ? 0 : (thermometer == 2);
+			REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
+				      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
+		}
 	}
 }
 
-- 
2.1.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40763 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaKPAjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 19:39:49 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	Miaoqing Pan <miaoqing@qca.qualcomm.com>
Subject: [PATCH v2 06/11] ath9k: Fix thermometer programming
Date: Sun, 16 Nov 2014 06:11:05 +0530
Message-Id: <1416098470-14122-7-git-send-email-sujith@msujith.org> (sfid-20141116_013953_371573_DF3321B2)
In-Reply-To: <1416098470-14122-1-git-send-email-sujith@msujith.org>
References: <1416098470-14122-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The registers that control the on-chip thermometer
need to be programmed based on the chainmask that
the solution supports, not the chainmask that is
present in the eeprom.

Cc: Miaoqing Pan <miaoqing@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 80c6eac..e726e40 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4079,27 +4079,28 @@ static int ar9003_hw_get_thermometer(struct ath_hw *ah)
 
 static void ar9003_hw_thermometer_apply(struct ath_hw *ah)
 {
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	int thermometer = ar9003_hw_get_thermometer(ah);
 	u8 therm_on = (thermometer < 0) ? 0 : 1;
 
 	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX4,
 		      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
-	if (ah->caps.tx_chainmask & BIT(1))
+	if (pCap->chip_chainmask & BIT(1))
 		REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX4,
 			      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
-	if (ah->caps.tx_chainmask & BIT(2))
+	if (pCap->chip_chainmask & BIT(2))
 		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
 			      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
 
 	therm_on = (thermometer < 0) ? 0 : (thermometer == 0);
 	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX4,
 		      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
-	if (ah->caps.tx_chainmask & BIT(1)) {
+	if (pCap->chip_chainmask & BIT(1)) {
 		therm_on = (thermometer < 0) ? 0 : (thermometer == 1);
 		REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX4,
 			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
 	}
-	if (ah->caps.tx_chainmask & BIT(2)) {
+	if (pCap->chip_chainmask & BIT(2)) {
 		therm_on = (thermometer < 0) ? 0 : (thermometer == 2);
 		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
 			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
-- 
2.1.3


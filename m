Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:36074 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbcCRCQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:16:34 -0400
Received: by mail-pf0-f173.google.com with SMTP id u190so145883717pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:16:34 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Ivan Safonov <insafonov@gmail.com>,
	Miaoqing Pan <miaoqing@codeaurora.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 01/19] ath9k: Remove unnecessary ?: operator
Date: Fri, 18 Mar 2016 13:16:26 +1100
Message-Id: <61d140e53a590054c5981788ed12fdda9ef4c0bb.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_031638_147536_C118A3C8)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivan Safonov <insafonov@gmail.com>

"(thermometer < 0) ? 0 : (thermometer == X)" is equivalent to
"thermometer == X" for X >= 0.

Signed-off-by: Ivan Safonov <insafonov@gmail.com>
[Updated commit message]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 54ed2f7..a049f8d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4097,16 +4097,16 @@ static void ar9003_hw_thermometer_apply(struct ath_hw *ah)
 		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
 			      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
 
-	therm_on = (thermometer < 0) ? 0 : (thermometer == 0);
+	therm_on = thermometer == 0;
 	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX4,
 		      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
 	if (pCap->chip_chainmask & BIT(1)) {
-		therm_on = (thermometer < 0) ? 0 : (thermometer == 1);
+		therm_on = thermometer == 1;
 		REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX4,
 			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
 	}
 	if (pCap->chip_chainmask & BIT(2)) {
-		therm_on = (thermometer < 0) ? 0 : (thermometer == 2);
+		therm_on = thermometer == 2;
 		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
 			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
 	}
-- 
2.7.0


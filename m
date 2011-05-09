Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51772 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1EINlg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 09:41:36 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 06:41:07 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 1/4] ath9k_hw: Corrected xpabiaslevel register settings for AR9340
Date: Mon, 9 May 2011 19:11:26 +0530
Message-ID: <1304948489-14585-1-git-send-email-rmanoharan@atheros.com> (sfid-20110509_154139_268081_06687D98)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 3b13c1b..37f86c0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3442,17 +3442,15 @@ static void ar9003_hw_xpa_bias_level_apply(struct ath_hw *ah, bool is2ghz)
 {
 	int bias = ar9003_hw_xpa_bias_level_get(ah, is2ghz);
 
-	if (AR_SREV_9485(ah))
+	if (AR_SREV_9485(ah) || AR_SREV_9340(ah))
 		REG_RMW_FIELD(ah, AR_CH0_TOP2, AR_CH0_TOP2_XPABIASLVL, bias);
 	else {
 		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
-		if (!AR_SREV_9340(ah)) {
-			REG_RMW_FIELD(ah, AR_CH0_THERM,
-				      AR_CH0_THERM_XPABIASLVL_MSB,
-				      bias >> 2);
-			REG_RMW_FIELD(ah, AR_CH0_THERM,
-				      AR_CH0_THERM_XPASHORT2GND, 1);
-		}
+		REG_RMW_FIELD(ah, AR_CH0_THERM,
+				AR_CH0_THERM_XPABIASLVL_MSB,
+				bias >> 2);
+		REG_RMW_FIELD(ah, AR_CH0_THERM,
+				AR_CH0_THERM_XPASHORT2GND, 1);
 	}
 }
 
-- 
1.7.5.1


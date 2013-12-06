Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48155 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab3LFLEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:04:06 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 16/16] ath9k: Apply tuning caps for AR9330 and AR9485
Date: Fri,  6 Dec 2013 16:28:54 +0530
Message-Id: <1386327534-31105-17-git-send-email-sujith@msujith.org> (sfid-20131206_120412_660581_F297BBB0)
In-Reply-To: <1386327534-31105-1-git-send-email-sujith@msujith.org>
References: <1386327534-31105-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 2845ace..ec317d6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3965,7 +3965,7 @@ static void ar9003_hw_apply_tuning_caps(struct ath_hw *ah)
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
 	u8 tuning_caps_param = eep->baseEepHeader.params_for_tuning_caps[0];
 
-	if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah))
+	if (AR_SREV_9340(ah))
 		return;
 
 	if (eep->baseEepHeader.featureEnable & 0x40) {
-- 
1.8.4.2


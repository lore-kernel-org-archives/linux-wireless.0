Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33735 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3KZB4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 20:56:19 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] ath9k: Fix XLNA bias strength
Date: Tue, 26 Nov 2013 07:21:39 +0530
Message-Id: <1385430699-26333-1-git-send-email-sujith@msujith.org> (sfid-20131126_025623_347801_46011554)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The EEPROM parameter to determine whether the bias
strength values for XLNA have to be applied is part
of the miscConfiguration field and not featureEnable.

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d96e879..130657d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4037,7 +4037,7 @@ static void ar9003_hw_xlna_bias_strength_apply(struct ath_hw *ah, bool is2ghz)
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
 	u8 bias;
 
-	if (!(eep->baseEepHeader.featureEnable & 0x40))
+	if (!(eep->baseEepHeader.miscConfiguration & 0x40))
 		return;
 
 	if (!AR_SREV_9300(ah))
-- 
1.8.4.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:33621 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbcFQJ6g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 05:58:36 -0400
From: Sven Eckelmann <sven@narfation.org>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Subject: [PATCH] ath9k: Fix programming of minCCA power threshold
Date: Fri, 17 Jun 2016 11:58:20 +0200
Message-Id: <1466157500-30791-1-git-send-email-sven@narfation.org> (sfid-20160617_115840_251052_E2D93D56)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function ar9003_hw_apply_minccapwr_thresh takes as second parameter not
a pointer to the channel but a boolean value describing whether the channel
is 2.4GHz or not. This broke (according to the origin commit) the ETSI
regulatory compliance on 5GHz channels.

Fixes: 3533bf6b15a0 ("ath9k: Fix regulatory compliance")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index dec1a31..e2083f4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4176,7 +4176,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	if (!AR_SREV_9330(ah) && !AR_SREV_9340(ah) && !AR_SREV_9531(ah))
 		ar9003_hw_internal_regulator_apply(ah);
 	ar9003_hw_apply_tuning_caps(ah);
-	ar9003_hw_apply_minccapwr_thresh(ah, chan);
+	ar9003_hw_apply_minccapwr_thresh(ah, is2ghz);
 	ar9003_hw_txend_to_xpa_off_apply(ah, is2ghz);
 	ar9003_hw_thermometer_apply(ah);
 	ar9003_hw_thermo_cal_apply(ah);
-- 
2.8.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:58733 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711Ab3LFLEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:04:04 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/16] ath9k: Fix internal regulator for AR955x
Date: Fri,  6 Dec 2013 16:28:53 +0530
Message-Id: <1386327534-31105-16-git-send-email-sujith@msujith.org> (sfid-20131206_120414_805801_0BE9DE24)
In-Reply-To: <1386327534-31105-1-git-send-email-sujith@msujith.org>
References: <1386327534-31105-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The internal regulator needs to be programmed
correctly for AR955x.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 130657d..2845ace 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4122,7 +4122,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	ar9003_hw_xlna_bias_strength_apply(ah, is2ghz);
 	ar9003_hw_atten_apply(ah, chan);
 	ar9003_hw_quick_drop_apply(ah, chan->channel);
-	if (!AR_SREV_9330(ah) && !AR_SREV_9340(ah) && !AR_SREV_9550(ah))
+	if (!AR_SREV_9330(ah) && !AR_SREV_9340(ah))
 		ar9003_hw_internal_regulator_apply(ah);
 	ar9003_hw_apply_tuning_caps(ah);
 	ar9003_hw_txend_to_xpa_off_apply(ah, is2ghz);
-- 
1.8.4.2


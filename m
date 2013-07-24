Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:39262 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3GXIY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 04:24:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] ath9k: Print LNA combining mode during init
Date: Wed, 24 Jul 2013 13:51:27 +0530
Message-Id: <1374654090-24408-2-git-send-email-sujith@msujith.org> (sfid-20130724_102509_305295_5BBFA73A)
In-Reply-To: <1374654090-24408-1-git-send-email-sujith@msujith.org>
References: <1374654090-24408-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d55d97c..8bd602c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2559,34 +2559,28 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	if (AR_SREV_9287_11_OR_LATER(ah) || AR_SREV_9271(ah))
 		pCap->hw_caps |= ATH9K_HW_CAP_SGI_20;
 
-	if (AR_SREV_9285(ah))
+	if (AR_SREV_9285(ah)) {
 		if (ah->eep_ops->get_eeprom(ah, EEP_MODAL_VER) >= 3) {
 			ant_div_ctl1 =
 				ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
-			if ((ant_div_ctl1 & 0x1) && ((ant_div_ctl1 >> 3) & 0x1))
+			if ((ant_div_ctl1 & 0x1) && ((ant_div_ctl1 >> 3) & 0x1)) {
 				pCap->hw_caps |= ATH9K_HW_CAP_ANT_DIV_COMB;
+				ath_info(common, "Enable LNA combining\n");
+			}
 		}
+	}
+
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		if (ah->eep_ops->get_eeprom(ah, EEP_CHAIN_MASK_REDUCE))
 			pCap->hw_caps |= ATH9K_HW_CAP_APM;
 	}
 
-
 	if (AR_SREV_9330(ah) || AR_SREV_9485(ah) || AR_SREV_9565(ah)) {
 		ant_div_ctl1 = ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
-		/*
-		 * enable the diversity-combining algorithm only when
-		 * both enable_lna_div and enable_fast_div are set
-		 *		Table for Diversity
-		 * ant_div_alt_lnaconf		bit 0-1
-		 * ant_div_main_lnaconf		bit 2-3
-		 * ant_div_alt_gaintb		bit 4
-		 * ant_div_main_gaintb		bit 5
-		 * enable_ant_div_lnadiv	bit 6
-		 * enable_ant_fast_div		bit 7
-		 */
-		if ((ant_div_ctl1 >> 0x6) == 0x3)
+		if ((ant_div_ctl1 >> 0x6) == 0x3) {
 			pCap->hw_caps |= ATH9K_HW_CAP_ANT_DIV_COMB;
+			ath_info(common, "Enable LNA combining\n");
+		}
 	}
 
 	if (ath9k_hw_dfs_tested(ah))
-- 
1.8.3.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-02.prod.sin2.secureserver.net ([182.50.145.5]:58884
	"EHLO sg2plout10-02.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab3ACGw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 01:52:29 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ath9k_hw: Enable calibration types in init_cal_settings
Date: Thu,  3 Jan 2013 12:21:21 +0530
Message-Id: <1357195883-8516-1-git-send-email-sujith@msujith.org> (sfid-20130103_075234_776507_256ADFAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Doing this in ath9k_hw_fill_cap_info() is odd and it's
cleaner to do this in the init function for calibration.
Also, setup the supported calibration type in init_cal_settings.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 17 +++++++++++------
 drivers/net/wireless/ath/ath9k/hw.c           |  7 -------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 8b0d8dc..598b847 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -323,6 +323,14 @@ static const struct ath9k_percal_data iq_cal_single_sample = {
 static void ar9003_hw_init_cal_settings(struct ath_hw *ah)
 {
 	ah->iq_caldata.calData = &iq_cal_single_sample;
+
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		ah->enabled_cals |= TX_IQ_CAL;
+		if (AR_SREV_9485_OR_LATER(ah))
+			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
+	}
+
+	ah->supp_cals = IQ_MISMATCH_CAL;
 }
 
 /*
@@ -1131,13 +1139,10 @@ skip_tx_iqcal:
 
 	/* Initialize list pointers */
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
-	ah->supp_cals = IQ_MISMATCH_CAL;
 
-	if (ah->supp_cals & IQ_MISMATCH_CAL) {
-		INIT_CAL(&ah->iq_caldata);
-		INSERT_CAL(ah, &ah->iq_caldata);
-		ath_dbg(common, CALIBRATE, "enabling IQ Calibration\n");
-	}
+	INIT_CAL(&ah->iq_caldata);
+	INSERT_CAL(ah, &ah->iq_caldata);
+	ath_dbg(common, CALIBRATE, "enabling IQ Calibration\n");
 
 	if (ah->supp_cals & TEMP_COMP_CAL) {
 		INIT_CAL(&ah->tempCompCalData);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7cb7870..5d73e92 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2576,12 +2576,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		rx_chainmask >>= 1;
 	}
 
-	if (AR_SREV_9300_20_OR_LATER(ah)) {
-		ah->enabled_cals |= TX_IQ_CAL;
-		if (AR_SREV_9485_OR_LATER(ah))
-			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
-	}
-
 	if (AR_SREV_9462(ah) || AR_SREV_9565(ah)) {
 		if (!(ah->ent_mode & AR_ENT_OTP_49GHZ_DISABLE))
 			pCap->hw_caps |= ATH9K_HW_CAP_MCI;
@@ -2590,7 +2584,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			pCap->hw_caps |= ATH9K_HW_CAP_RTT;
 	}
 
-
 	if (AR_SREV_9280_20_OR_LATER(ah)) {
 		pCap->hw_caps |= ATH9K_HW_WOW_DEVICE_CAPABLE |
 				 ATH9K_HW_WOW_PATTERN_MATCH_EXACT;
-- 
1.8.1


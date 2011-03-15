Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47522 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab1COOZ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 10:25:28 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 07:25:05 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 2/4] ath9k_hw: Fix throughput drops in HT40 mode for AR9287 chips
Date: Tue, 15 Mar 2011 19:55:36 +0530
Message-ID: <1300199138-11851-2-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1300199138-11851-1-git-send-email-rmanoharan@atheros.com>
References: <1300199138-11851-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Doing adc gain calibration for AR9287 chips is causing
throughput drops in HT40 mode. Remove ADC Gain from supported
calibration list.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |   43 ++++++++++++++++++++-----
 1 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 76388c6..cb611b2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -26,6 +26,27 @@ enum ar9002_cal_types {
 	IQ_MISMATCH_CAL = BIT(2),
 };
 
+static bool ar9002_hw_is_cal_supported(struct ath_hw *ah,
+				struct ath9k_channel *chan,
+				enum ar9002_cal_types cal_type)
+{
+	bool supported = false;
+	switch (ah->supp_cals & cal_type) {
+	case IQ_MISMATCH_CAL:
+		/* Run IQ Mismatch for non-CCK only */
+		if (!IS_CHAN_B(chan))
+			supported = true;
+		break;
+	case ADC_GAIN_CAL:
+	case ADC_DC_CAL:
+		/* Run ADC Gain Cal for non-CCK & non 2GHz-HT20 only */
+		if (!IS_CHAN_B(chan) &&
+		    !(IS_CHAN_2GHZ(chan) && IS_CHAN_HT20(chan)))
+			supported = true;
+		break;
+	}
+	return supported;
+}
 
 static void ar9002_hw_setup_calibration(struct ath_hw *ah,
 					struct ath9k_cal_list *currCal)
@@ -858,26 +879,32 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 	if (AR_SREV_9100(ah) || AR_SREV_9160_10_OR_LATER(ah)) {
 		ah->supp_cals = IQ_MISMATCH_CAL;
 
-		if (AR_SREV_9160_10_OR_LATER(ah) &&
-		    !(IS_CHAN_2GHZ(chan) && IS_CHAN_HT20(chan))) {
+		if (AR_SREV_9160_10_OR_LATER(ah))
 			ah->supp_cals |= ADC_GAIN_CAL | ADC_DC_CAL;
 
+		if (AR_SREV_9287(ah))
+			ah->supp_cals &= ~ADC_GAIN_CAL;
 
+		if (ar9002_hw_is_cal_supported(ah, chan, ADC_GAIN_CAL)) {
 			INIT_CAL(&ah->adcgain_caldata);
 			INSERT_CAL(ah, &ah->adcgain_caldata);
 			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"enabling ADC Gain Calibration.\n");
+					"enabling ADC Gain Calibration.\n");
+		}
 
+		if (ar9002_hw_is_cal_supported(ah, chan, ADC_DC_CAL)) {
 			INIT_CAL(&ah->adcdc_caldata);
 			INSERT_CAL(ah, &ah->adcdc_caldata);
 			ath_dbg(common, ATH_DBG_CALIBRATE,
-				"enabling ADC DC Calibration.\n");
+					"enabling ADC DC Calibration.\n");
 		}
 
-		INIT_CAL(&ah->iq_caldata);
-		INSERT_CAL(ah, &ah->iq_caldata);
-		ath_dbg(common, ATH_DBG_CALIBRATE,
-			"enabling IQ Calibration.\n");
+		if (ar9002_hw_is_cal_supported(ah, chan, IQ_MISMATCH_CAL)) {
+			INIT_CAL(&ah->iq_caldata);
+			INSERT_CAL(ah, &ah->iq_caldata);
+			ath_dbg(common, ATH_DBG_CALIBRATE,
+					"enabling IQ Calibration.\n");
+		}
 
 		ah->cal_list_curr = ah->cal_list;
 
-- 
1.7.4.1


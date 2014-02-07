Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38661 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaBGFAq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 00:00:46 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 6/7] ath9k: Expand the IQ coefficient array
Date: Fri,  7 Feb 2014 10:29:54 +0530
Message-Id: <1391749195-24381-7-git-send-email-sujith@msujith.org> (sfid-20140207_060059_841161_F43B9B84)
In-Reply-To: <1391749195-24381-1-git-send-email-sujith@msujith.org>
References: <1391749195-24381-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This will be used for storing data for mutiple
IQ calibration runs, for AR955x.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 41 ++++++++++++++-------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 4a02ceb..6f2a994 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -26,8 +26,8 @@
 #define MAXIQCAL        3
 
 struct coeff {
-	int mag_coeff[AR9300_MAX_CHAINS][MAX_MEASUREMENT];
-	int phs_coeff[AR9300_MAX_CHAINS][MAX_MEASUREMENT];
+	int mag_coeff[AR9300_MAX_CHAINS][MAX_MEASUREMENT][MAXIQCAL];
+	int phs_coeff[AR9300_MAX_CHAINS][MAX_MEASUREMENT][MAXIQCAL];
 	int iqc_coeff[2];
 };
 
@@ -840,7 +840,8 @@ static bool ar9003_hw_calc_iq_corr(struct ath_hw *ah,
 	return true;
 }
 
-static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
+static void ar9003_hw_detect_outlier(int mp_coeff[][MAXIQCAL],
+				     int nmeasurement,
 				     int max_delta)
 {
 	int mp_max = -64, max_idx = 0;
@@ -849,20 +850,20 @@ static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
 
 	/* find min/max mismatch across all calibrated gains */
 	for (i = 0; i < nmeasurement; i++) {
-		if (mp_coeff[i] > mp_max) {
-			mp_max = mp_coeff[i];
+		if (mp_coeff[i][0] > mp_max) {
+			mp_max = mp_coeff[i][0];
 			max_idx = i;
-		} else if (mp_coeff[i] < mp_min) {
-			mp_min = mp_coeff[i];
+		} else if (mp_coeff[i][0] < mp_min) {
+			mp_min = mp_coeff[i][0];
 			min_idx = i;
 		}
 	}
 
 	/* find average (exclude max abs value) */
 	for (i = 0; i < nmeasurement; i++) {
-		if ((abs(mp_coeff[i]) < abs(mp_max)) ||
-		    (abs(mp_coeff[i]) < abs(mp_min))) {
-			mp_avg += mp_coeff[i];
+		if ((abs(mp_coeff[i][0]) < abs(mp_max)) ||
+		    (abs(mp_coeff[i][0]) < abs(mp_min))) {
+			mp_avg += mp_coeff[i][0];
 			mp_count++;
 		}
 	}
@@ -874,7 +875,7 @@ static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
 	if (mp_count)
 		mp_avg /= mp_count;
 	else
-		mp_avg = mp_coeff[nmeasurement - 1];
+		mp_avg = mp_coeff[nmeasurement - 1][0];
 
 	/* detect outlier */
 	if (abs(mp_max - mp_min) > max_delta) {
@@ -883,7 +884,7 @@ static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
 		else
 			outlier_idx = min_idx;
 
-		mp_coeff[outlier_idx] = mp_avg;
+		mp_coeff[outlier_idx][0] = mp_avg;
 	}
 }
 
@@ -934,8 +935,8 @@ static void ar9003_hw_tx_iq_cal_outlier_detection(struct ath_hw *ah,
 		}
 
 		for (im = 0; im < nmeasurement; im++) {
-			magnitude = coeff->mag_coeff[i][im];
-			phase = coeff->phs_coeff[i][im];
+			magnitude = coeff->mag_coeff[i][im][0];
+			phase = coeff->phs_coeff[i][im][0];
 
 			coeff->iqc_coeff[0] =
 				(phase & 0x7f) | ((magnitude & 0x7f) << 7);
@@ -1071,15 +1072,15 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah,
 				goto tx_iqcal_fail;
 			}
 
-			coeff.phs_coeff[i][im] =
+			coeff.phs_coeff[i][im][iqcal_idx] =
 				coeff.iqc_coeff[0] & 0x7f;
-			coeff.mag_coeff[i][im] =
+			coeff.mag_coeff[i][im][iqcal_idx] =
 				(coeff.iqc_coeff[0] >> 7) & 0x7f;
 
-			if (coeff.mag_coeff[i][im] > 63)
-				coeff.mag_coeff[i][im] -= 128;
-			if (coeff.phs_coeff[i][im] > 63)
-				coeff.phs_coeff[i][im] -= 128;
+			if (coeff.mag_coeff[i][im][iqcal_idx] > 63)
+				coeff.mag_coeff[i][im][iqcal_idx] -= 128;
+			if (coeff.phs_coeff[i][im][iqcal_idx] > 63)
+				coeff.phs_coeff[i][im][iqcal_idx] -= 128;
 		}
 	}
 	ar9003_hw_tx_iq_cal_outlier_detection(ah, &coeff, is_reusable);
-- 
1.8.5.3


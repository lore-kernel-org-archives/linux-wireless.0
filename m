Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:49724 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaBGFAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 00:00:45 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 7/7] ath9k: Calculate IQ-CAL median
Date: Fri,  7 Feb 2014 10:29:55 +0530
Message-Id: <1391749195-24381-8-git-send-email-sujith@msujith.org> (sfid-20140207_060056_954654_0769E9EF)
In-Reply-To: <1391749195-24381-1-git-send-email-sujith@msujith.org>
References: <1391749195-24381-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch adds a routine to calculate the median IQ correction
values for AR955x, which is used for outlier detection.
The normal method which is used for all other chips is
bypassed for AR955x.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 91 +++++++++++++++++++++++----
 1 file changed, 79 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 6f2a994..8bd4474 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -923,15 +923,22 @@ static void ar9003_hw_tx_iq_cal_outlier_detection(struct ath_hw *ah,
 		if (nmeasurement > MAX_MEASUREMENT)
 			nmeasurement = MAX_MEASUREMENT;
 
-		/* detect outlier only if nmeasurement > 1 */
-		if (nmeasurement > 1) {
-			/* Detect magnitude outlier */
-			ar9003_hw_detect_outlier(coeff->mag_coeff[i],
-					nmeasurement, MAX_MAG_DELTA);
-
-			/* Detect phase outlier */
-			ar9003_hw_detect_outlier(coeff->phs_coeff[i],
-					nmeasurement, MAX_PHS_DELTA);
+		/*
+		 * Skip normal outlier detection for AR9550.
+		 */
+		if (!AR_SREV_9550(ah)) {
+			/* detect outlier only if nmeasurement > 1 */
+			if (nmeasurement > 1) {
+				/* Detect magnitude outlier */
+				ar9003_hw_detect_outlier(coeff->mag_coeff[i],
+							 nmeasurement,
+							 MAX_MAG_DELTA);
+
+				/* Detect phase outlier */
+				ar9003_hw_detect_outlier(coeff->phs_coeff[i],
+							 nmeasurement,
+							 MAX_PHS_DELTA);
+			}
 		}
 
 		for (im = 0; im < nmeasurement; im++) {
@@ -996,6 +1003,60 @@ static bool ar9003_hw_tx_iq_cal_run(struct ath_hw *ah)
 	return true;
 }
 
+static void __ar955x_tx_iq_cal_sort(struct ath_hw *ah,
+				    struct coeff *coeff,
+				    int i, int nmeasurement)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	int im, ix, iy, temp;
+
+	for (im = 0; im < nmeasurement; im++) {
+		for (ix = 0; ix < MAXIQCAL - 1; ix++) {
+			for (iy = ix + 1; iy <= MAXIQCAL - 1; iy++) {
+				if (coeff->mag_coeff[i][im][iy] <
+				    coeff->mag_coeff[i][im][ix]) {
+					temp = coeff->mag_coeff[i][im][ix];
+					coeff->mag_coeff[i][im][ix] =
+						coeff->mag_coeff[i][im][iy];
+					coeff->mag_coeff[i][im][iy] = temp;
+				}
+				if (coeff->phs_coeff[i][im][iy] <
+				    coeff->phs_coeff[i][im][ix]) {
+					temp = coeff->phs_coeff[i][im][ix];
+					coeff->phs_coeff[i][im][ix] =
+						coeff->phs_coeff[i][im][iy];
+					coeff->phs_coeff[i][im][iy] = temp;
+				}
+			}
+		}
+		coeff->mag_coeff[i][im][0] = coeff->mag_coeff[i][im][MAXIQCAL / 2];
+		coeff->phs_coeff[i][im][0] = coeff->phs_coeff[i][im][MAXIQCAL / 2];
+
+		ath_dbg(common, CALIBRATE,
+			"IQCAL: Median [ch%d][gain%d]: mag = %d phase = %d\n",
+			i, im,
+			coeff->mag_coeff[i][im][0],
+			coeff->phs_coeff[i][im][0]);
+	}
+}
+
+static bool ar955x_tx_iq_cal_median(struct ath_hw *ah,
+				    struct coeff *coeff,
+				    int iqcal_idx,
+				    int nmeasurement)
+{
+	int i;
+
+	if ((iqcal_idx + 1) != MAXIQCAL)
+		return false;
+
+	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+		__ar955x_tx_iq_cal_sort(ah, coeff, i, nmeasurement);
+	}
+
+	return true;
+}
+
 static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah,
 					  int iqcal_idx,
 					  bool is_reusable)
@@ -1011,10 +1072,11 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah,
 		AR_PHY_CHAN_INFO_TAB_1,
 		AR_PHY_CHAN_INFO_TAB_2,
 	};
-	struct coeff coeff;
+	static struct coeff coeff;
 	s32 iq_res[6];
 	int i, im, j;
-	int nmeasurement;
+	int nmeasurement = 0;
+	bool outlier_detect = true;
 
 	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
 		if (!(ah->txchainmask & (1 << i)))
@@ -1083,7 +1145,12 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah,
 				coeff.phs_coeff[i][im][iqcal_idx] -= 128;
 		}
 	}
-	ar9003_hw_tx_iq_cal_outlier_detection(ah, &coeff, is_reusable);
+
+	if (AR_SREV_9550(ah))
+		outlier_detect = ar955x_tx_iq_cal_median(ah, &coeff,
+							 iqcal_idx, nmeasurement);
+	if (outlier_detect)
+		ar9003_hw_tx_iq_cal_outlier_detection(ah, &coeff, is_reusable);
 
 	return;
 
-- 
1.8.5.3


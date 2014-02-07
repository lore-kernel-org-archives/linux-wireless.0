Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:55676 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaBGFAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 00:00:43 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 4/7] ath9k: Fix magnitude/phase calculation
Date: Fri,  7 Feb 2014 10:29:52 +0530
Message-Id: <1391749195-24381-5-git-send-email-sujith@msujith.org> (sfid-20140207_060102_245099_946EB0F1)
In-Reply-To: <1391749195-24381-1-git-send-email-sujith@msujith.org>
References: <1391749195-24381-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Incorrect values are programmed in the registers
containing the IQ correction coefficients by the IQ-CAL
post-processing code. Fix this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 9210beb..6d4cb00 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -891,6 +891,7 @@ static void ar9003_hw_tx_iq_cal_outlier_detection(struct ath_hw *ah,
 						  bool is_reusable)
 {
 	int i, im, nmeasurement;
+	int magnitude, phase;
 	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS];
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 
@@ -932,9 +933,11 @@ static void ar9003_hw_tx_iq_cal_outlier_detection(struct ath_hw *ah,
 		}
 
 		for (im = 0; im < nmeasurement; im++) {
+			magnitude = coeff->mag_coeff[i][im];
+			phase = coeff->phs_coeff[i][im];
 
-			coeff->iqc_coeff[0] = (coeff->mag_coeff[i][im] & 0x7f) |
-				((coeff->phs_coeff[i][im] & 0x7f) << 7);
+			coeff->iqc_coeff[0] =
+				(phase & 0x7f) | ((magnitude & 0x7f) << 7);
 
 			if ((im % 2) == 0)
 				REG_RMW_FIELD(ah, tx_corr_coeff[im][i],
@@ -1065,8 +1068,9 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah, bool is_reusable)
 				goto tx_iqcal_fail;
 			}
 
-			coeff.mag_coeff[i][im] = coeff.iqc_coeff[0] & 0x7f;
 			coeff.phs_coeff[i][im] =
+				coeff.iqc_coeff[0] & 0x7f;
+			coeff.mag_coeff[i][im] =
 				(coeff.iqc_coeff[0] >> 7) & 0x7f;
 
 			if (coeff.mag_coeff[i][im] > 63)
-- 
1.8.5.3


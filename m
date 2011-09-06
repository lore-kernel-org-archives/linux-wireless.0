Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9232 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1IFQ3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 12:29:25 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Kai Shi <kaishi@qca.qualcomm.com>
Subject: [PATCH v2] ath9k_hw: Fix magnitude/phase average in TxIQ Calibration
Date: Tue, 6 Sep 2011 21:59:51 +0530
Message-ID: <1315326591-2938-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110906_182929_847005_263CB886)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k_hw: Fix Tx IQ Calibration hang issue in
AR9003 chips" did not consider more than one potential sample
while calculating magnitude/phase average if more than one
sample has the same value which could affect post-processing
of outlier detection that causes an undesirable Tx IQ
correction value will be assigned to tx gain settings where
outlier happens.

Cc: Kai Shi <kaishi@qca.qualcomm.com>
Reported-by: Paul Stewart <pstew@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index ee3a8a2..695d9d3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -615,11 +615,10 @@ static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
 {
 	int mp_max = -64, max_idx = 0;
 	int mp_min = 63, min_idx = 0;
-	int mp_avg = 0, i, outlier_idx = 0;
+	int mp_avg = 0, i, outlier_idx = 0, mp_count = 0;
 
 	/* find min/max mismatch across all calibrated gains */
 	for (i = 0; i < nmeasurement; i++) {
-		mp_avg += mp_coeff[i];
 		if (mp_coeff[i] > mp_max) {
 			mp_max = mp_coeff[i];
 			max_idx = i;
@@ -632,10 +631,20 @@ static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
 	/* find average (exclude max abs value) */
 	for (i = 0; i < nmeasurement; i++) {
 		if ((abs(mp_coeff[i]) < abs(mp_max)) ||
-		    (abs(mp_coeff[i]) < abs(mp_min)))
+		    (abs(mp_coeff[i]) < abs(mp_min))) {
 			mp_avg += mp_coeff[i];
+			mp_count++;
+		}
 	}
-	mp_avg /= (nmeasurement - 1);
+
+	/*
+	 * finding mean magnitude/phase if possible, otherwise
+	 * just use the last value as the mean
+	 */
+	if (mp_count)
+		mp_avg /= mp_count;
+	else
+		mp_avg = mp_coeff[nmeasurement - 1];
 
 	/* detect outlier */
 	if (abs(mp_max - mp_min) > max_delta) {
-- 
1.7.6.1


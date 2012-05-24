Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36383 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2EXDzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 23:55:06 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20413.45274.740324.328021@gargle.gargle.HOWL> (sfid-20120524_055511_802363_CFF83B60)
Date: Thu, 24 May 2012 09:24:02 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 14/22] ath9k_hw: fix IQ calibration chain index
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chain index to perform IQ calibration is counted to number of valid
tx chains and then used for indexing chain specific registers. If the
chainmask is set to 0x2 (i.e chain 1 only), still it accesses chain 0
registers for chain 1. So use real chain index instead sequential one.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index f83a4a2..d7deb8c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -653,7 +653,6 @@ static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
 }
 
 static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
-						 u8 num_chains,
 						 struct coeff *coeff,
 						 bool is_reusable)
 {
@@ -677,7 +676,9 @@ static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
 	}
 
 	/* Load the average of 2 passes */
-	for (i = 0; i < num_chains; i++) {
+	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+		if (!(ah->txchainmask & (1 << i)))
+			continue;
 		nmeasurement = REG_READ_FIELD(ah,
 				AR_PHY_TX_IQCAL_STATUS_B0,
 				AR_PHY_CALIBRATED_GAINS_0);
@@ -767,16 +768,13 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah, bool is_reusable)
 	};
 	struct coeff coeff;
 	s32 iq_res[6];
-	u8 num_chains = 0;
 	int i, im, j;
 	int nmeasurement;
 
 	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
-		if (ah->txchainmask & (1 << i))
-			num_chains++;
-	}
+		if (!(ah->txchainmask & (1 << i)))
+			continue;
 
-	for (i = 0; i < num_chains; i++) {
 		nmeasurement = REG_READ_FIELD(ah,
 				AR_PHY_TX_IQCAL_STATUS_B0,
 				AR_PHY_CALIBRATED_GAINS_0);
@@ -839,8 +837,7 @@ static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah, bool is_reusable)
 				coeff.phs_coeff[i][im] -= 128;
 		}
 	}
-	ar9003_hw_tx_iqcal_load_avg_2_passes(ah, num_chains,
-					     &coeff, is_reusable);
+	ar9003_hw_tx_iqcal_load_avg_2_passes(ah, &coeff, is_reusable);
 
 	return;
 
-- 
1.7.10.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33324 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab2EROG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 10:06:56 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 03/10] ath9k_hw: fix IQ calibration chain index
Date: Fri, 18 May 2012 19:37:26 +0530
Message-ID: <1337350053-15491-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120518_160659_523793_A2E0290A)
In-Reply-To: <1337350053-15491-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1337350053-15491-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
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


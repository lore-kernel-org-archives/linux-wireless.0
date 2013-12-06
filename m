Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:47641 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569Ab3LFLED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Dec 2013 06:04:03 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/16] ath9k: Enable manual peak calibration for AR9331 v1.1
Date: Fri,  6 Dec 2013 16:28:52 +0530
Message-Id: <1386327534-31105-15-git-send-email-sujith@msujith.org> (sfid-20131206_122459_938990_9EDFEB30)
In-Reply-To: <1386327534-31105-1-git-send-email-sujith@msujith.org>
References: <1386327534-31105-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 29 ++++++++++++++++++---------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index aa01272..97e09d5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -898,7 +898,7 @@ static void ar9003_hw_tx_iq_cal_reload(struct ath_hw *ah)
 
 static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
 {
-	int offset[8], total = 0, test;
+	int offset[8] = {0}, total = 0, test;
 	int agc_out, i;
 
 	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_GAINSTAGES(chain),
@@ -923,12 +923,18 @@ static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
 		      AR_PHY_65NM_RXRF_AGC_AGC_ON_OVR, 0x1);
 	REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
 		      AR_PHY_65NM_RXRF_AGC_AGC_CAL_OVR, 0x1);
-	if (is_2g)
-		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
-			      AR_PHY_65NM_RXRF_AGC_AGC2G_DBDAC_OVR, 0x0);
-	else
+
+	if (AR_SREV_9330_11(ah)) {
 		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
-			      AR_PHY_65NM_RXRF_AGC_AGC5G_DBDAC_OVR, 0x0);
+			      AR_PHY_65NM_RXRF_AGC_AGC2G_CALDAC_OVR, 0x0);
+	} else {
+		if (is_2g)
+			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+				      AR_PHY_65NM_RXRF_AGC_AGC2G_DBDAC_OVR, 0x0);
+		else
+			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+				      AR_PHY_65NM_RXRF_AGC_AGC5G_DBDAC_OVR, 0x0);
+	}
 
 	for (i = 6; i > 0; i--) {
 		offset[i] = BIT(i - 1);
@@ -964,9 +970,9 @@ static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
 		      AR_PHY_65NM_RXRF_AGC_AGC_CAL_OVR, 0);
 }
 
-static void ar9003_hw_do_manual_peak_cal(struct ath_hw *ah,
-					 struct ath9k_channel *chan,
-					 bool run_rtt_cal)
+static void ar9003_hw_do_pcoem_manual_peak_cal(struct ath_hw *ah,
+					       struct ath9k_channel *chan,
+					       bool run_rtt_cal)
 {
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	int i;
@@ -1145,7 +1151,7 @@ skip_tx_iqcal:
 				       AR_PHY_AGC_CONTROL_CAL,
 				       0, AH_WAIT_TIMEOUT);
 
-		ar9003_hw_do_manual_peak_cal(ah, chan, run_rtt_cal);
+		ar9003_hw_do_pcoem_manual_peak_cal(ah, chan, run_rtt_cal);
 	}
 
 	if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE) {
@@ -1267,6 +1273,9 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 
 skip_tx_iqcal:
 	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
+		if (AR_SREV_9330_11(ah))
+			ar9003_hw_manual_peak_cal(ah, 0, IS_CHAN_2GHZ(chan));
+
 		/* Calibrate the AGC */
 		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
 			  REG_READ(ah, AR_PHY_AGC_CONTROL) |
-- 
1.8.4.2


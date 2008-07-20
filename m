Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:42022 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393AbYGTDqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 23:46:34 -0400
Date: Sun, 20 Jul 2008 06:47:12 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 9/12] ath5k: Update phy calibration functions
Message-ID: <20080720034712.GI7440@makis> (sfid-20080720_054636_354774_41266E59)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Enable I/Q calibration each time we have correction results (we were only enabling calibration during reset). If we don't we commit the same results each time calibration routine is called.
 * Add some documentation and a TODO on nf calibration
 * Return -EAGAIN on noise floor timeout/failure

 Changes-licensed-under: ISC
 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index cbc362d..dc05f98 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -2052,6 +2052,8 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
  * http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO1&Sect2=HITOFF&d=PALL \
  * &p=1&u=%2Fnetahtml%2FPTO%2Fsrchnum.htm&r=1&f=G&l=50&s1=7245893.PN.&OS=PN/7
  *
+ * XXX: Since during noise floor calibration antennas are detached acording to
+ * the pattent, we should stop tx queues here.
  */
 int
 ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq)
@@ -2061,7 +2063,7 @@ ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq)
 	s32 noise_floor;
 
 	/*
-	 * Enable noise floor calibration and wait until completion
+	 * Enable noise floor calibration
 	 */
 	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
 				AR5K_PHY_AGCCTL_NF);
@@ -2071,7 +2073,7 @@ ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq)
 	if (ret) {
 		ATH5K_ERR(ah->ah_sc,
 			"noise floor calibration timeout (%uMHz)\n", freq);
-		return ret;
+		return -EAGAIN;
 	}
 
 	/* Wait until the noise floor is calibrated and read the value */
@@ -2093,7 +2095,7 @@ ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq)
 	if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
 		ATH5K_ERR(ah->ah_sc,
 			"noise floor calibration failed (%uMHz)\n", freq);
-		return -EIO;
+		return -EAGAIN;
 	}
 
 	ah->ah_noise_floor = noise_floor;
@@ -2206,38 +2208,66 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 }
 
 /*
- * Perform a PHY calibration on RF5111/5112
+ * Perform a PHY calibration on RF5111/5112 and newer chips
  */
 static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	u32 i_pwr, q_pwr;
 	s32 iq_corr, i_coff, i_coffd, q_coff, q_coffd;
+	int i;
 	ATH5K_TRACE(ah->ah_sc);
 
 	if (!ah->ah_calibration ||
-			ath5k_hw_reg_read(ah, AR5K_PHY_IQ) & AR5K_PHY_IQ_RUN)
+		ath5k_hw_reg_read(ah, AR5K_PHY_IQ) & AR5K_PHY_IQ_RUN)
 		goto done;
 
-	ah->ah_calibration = false;
+	/* Calibration has finished, get the results and re-run */
+	for (i = 0; i <= 10; i++) {
+		iq_corr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_CORR);
+		i_pwr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_PWR_I);
+		q_pwr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_PWR_Q);
+	}
 
-	iq_corr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_CORR);
-	i_pwr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_PWR_I);
-	q_pwr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_PWR_Q);
 	i_coffd = ((i_pwr >> 1) + (q_pwr >> 1)) >> 7;
-	q_coffd = q_pwr >> 6;
+	q_coffd = q_pwr >> 7;
 
+	/* No correction */
 	if (i_coffd == 0 || q_coffd == 0)
 		goto done;
 
 	i_coff = ((-iq_corr) / i_coffd) & 0x3f;
-	q_coff = (((s32)i_pwr / q_coffd) - 64) & 0x1f;
 
-	/* Commit new IQ value */
+	/* Boundary check */
+	if (i_coff > 31)
+		i_coff = 31;
+	if (i_coff < -32)
+		i_coff = -32;
+
+	q_coff = (((s32)i_pwr / q_coffd) - 128) & 0x1f;
+
+	/* Boundary check */
+	if (q_coff > 15)
+		q_coff = 15;
+	if (q_coff < -16)
+		q_coff = -16;
+
+	/* Commit new I/Q value */
 	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_ENABLE |
 		((u32)q_coff) | ((u32)i_coff << AR5K_PHY_IQ_CORR_Q_I_COFF_S));
 
+	/* Re-enable calibration -if we don't we'll commit
+	 * the same values again and again */
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ,
+			AR5K_PHY_IQ_CAL_NUM_LOG_MAX, 15);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_RUN);
+
 done:
+
+	/* TODO: Separate noise floor calibration from I/Q calibration
+	 * since noise floor calibration interrupts rx path while I/Q
+	 * calibration doesn't. We don't need to run noise floor calibration
+	 * as often as I/Q calibration.*/
 	ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
 
 	/* Request RF gain */


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13859 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab0LAHfV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:35:21 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:35:07 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 22/26] ath9k_hw: Add IQ cal changes for AR9485
Date: Tue, 30 Nov 2010 23:32:51 -0800
Message-ID: <1291188775-13707-23-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |  242 ++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h   |   16 ++-
 2 files changed, 255 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index c3867cd..799906f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -18,6 +18,16 @@
 #include "hw-ops.h"
 #include "ar9003_phy.h"
 
+#define MPASS	3
+#define MAX_MEASUREMENT	8
+#define MAX_DIFFERENCE	10
+
+struct coeff {
+	int mag_coeff[AR9300_MAX_CHAINS][MAX_MEASUREMENT][MPASS];
+	int phs_coeff[AR9300_MAX_CHAINS][MAX_MEASUREMENT][MPASS];
+	int iqc_coeff[2];
+};
+
 enum ar9003_cal_types {
 	IQ_MISMATCH_CAL = BIT(0),
 	TEMP_COMP_CAL = BIT(1),
@@ -714,6 +724,229 @@ TX_IQ_CAL_FAILED:
 	ath_print(common, ATH_DBG_CALIBRATE, "Tx IQ Cal failed\n");
 }
 
+static bool ar9003_hw_compute_closest_pass_and_avg(int *mp_coeff, int *mp_avg)
+{
+	int diff[MPASS];
+
+	diff[0] = abs(mp_coeff[0] - mp_coeff[1]);
+	diff[1] = abs(mp_coeff[1] - mp_coeff[2]);
+	diff[2] = abs(mp_coeff[2] - mp_coeff[0]);
+
+	if (diff[0] > MAX_MEASUREMENT &&
+	    diff[1] > MAX_MEASUREMENT &&
+	    diff[2] > MAX_MEASUREMENT)
+		return false;
+
+	if (diff[0] <= diff[1] && diff[0] <= diff[2])
+		*mp_avg = (mp_coeff[0] + mp_coeff[1]) / 2;
+	else if (diff[1] <= diff[2])
+		*mp_avg = (mp_coeff[1] + mp_coeff[2]) / 2;
+	else
+		*mp_avg = (mp_coeff[2] + mp_coeff[0]) / 2;
+
+	return true;
+}
+
+static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
+						 u8 num_chains,
+						 struct coeff *coeff)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	int i, im, nmeasurement;
+	int magnitude, phase;
+	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS];
+
+	memset(tx_corr_coeff, 0, sizeof(tx_corr_coeff));
+	for (i = 0; i < MAX_MEASUREMENT / 2; i++) {
+		tx_corr_coeff[i * 2][0] = tx_corr_coeff[(i * 2) + 1][0] =
+					AR_PHY_TX_IQCAL_CORR_COEFF_B0(i);
+		if (!AR_SREV_9485(ah)) {
+			tx_corr_coeff[i * 2][1] =
+			tx_corr_coeff[(i * 2) + 1][1] =
+					AR_PHY_TX_IQCAL_CORR_COEFF_B1(i);
+
+			tx_corr_coeff[i * 2][2] =
+			tx_corr_coeff[(i * 2) + 1][2] =
+					AR_PHY_TX_IQCAL_CORR_COEFF_B2(i);
+		}
+	}
+
+	/* Load the average of 2 passes */
+	for (i = 0; i < num_chains; i++) {
+		if (AR_SREV_9485(ah))
+			nmeasurement = REG_READ_FIELD(ah,
+					AR_PHY_TX_IQCAL_STATUS_B0_9485,
+					AR_PHY_CALIBRATED_GAINS_0);
+		else
+			nmeasurement = REG_READ_FIELD(ah,
+					AR_PHY_TX_IQCAL_STATUS_B0,
+					AR_PHY_CALIBRATED_GAINS_0);
+
+		if (nmeasurement > MAX_MEASUREMENT)
+			nmeasurement = MAX_MEASUREMENT;
+
+		for (im = 0; im < nmeasurement; im++) {
+			/*
+			 * Determine which 2 passes are closest and compute avg
+			 * magnitude
+			 */
+			if (!ar9003_hw_compute_closest_pass_and_avg(coeff->mag_coeff[i][im],
+								    &magnitude))
+				goto disable_txiqcal;
+
+			/*
+			 * Determine which 2 passes are closest and compute avg
+			 * phase
+			 */
+			if (!ar9003_hw_compute_closest_pass_and_avg(coeff->phs_coeff[i][im],
+								    &phase))
+				goto disable_txiqcal;
+
+			coeff->iqc_coeff[0] = (magnitude & 0x7f) |
+					      ((phase & 0x7f) << 7);
+
+			if ((im % 2) == 0)
+				REG_RMW_FIELD(ah, tx_corr_coeff[im][i],
+					AR_PHY_TX_IQCAL_CORR_COEFF_00_COEFF_TABLE,
+					coeff->iqc_coeff[0]);
+			else
+				REG_RMW_FIELD(ah, tx_corr_coeff[im][i],
+					AR_PHY_TX_IQCAL_CORR_COEFF_01_COEFF_TABLE,
+					coeff->iqc_coeff[0]);
+		}
+	}
+
+	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_3,
+		      AR_PHY_TX_IQCAL_CONTROL_3_IQCORR_EN, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_RX_IQCAL_CORR_B0,
+		      AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN, 0x1);
+
+	return;
+
+disable_txiqcal:
+	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_3,
+		      AR_PHY_TX_IQCAL_CONTROL_3_IQCORR_EN, 0x0);
+	REG_RMW_FIELD(ah, AR_PHY_RX_IQCAL_CORR_B0,
+		      AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN, 0x0);
+
+	ath_print(common, ATH_DBG_CALIBRATE, "TX IQ Cal disabled\n");
+}
+
+static void ar9003_hw_tx_iq_cal_run(struct ath_hw *ah)
+{
+	u8 tx_gain_forced;
+
+	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_1_9485,
+		      AR_PHY_TX_IQCAQL_CONTROL_1_IQCORR_I_Q_COFF_DELPT, DELPT);
+	tx_gain_forced = REG_READ_FIELD(ah, AR_PHY_TX_FORCED_GAIN,
+					AR_PHY_TXGAIN_FORCE);
+	if (tx_gain_forced)
+		REG_RMW_FIELD(ah, AR_PHY_TX_FORCED_GAIN,
+			      AR_PHY_TXGAIN_FORCE, 0);
+
+	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_START_9485,
+		      AR_PHY_TX_IQCAL_START_DO_CAL_9485, 1);
+}
+
+static void ar9003_hw_tx_iq_cal_post_proc(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	const u32 txiqcal_status[AR9300_MAX_CHAINS] = {
+		AR_PHY_TX_IQCAL_STATUS_B0_9485,
+		AR_PHY_TX_IQCAL_STATUS_B1,
+		AR_PHY_TX_IQCAL_STATUS_B2,
+	};
+	const u_int32_t chan_info_tab[] = {
+		AR_PHY_CHAN_INFO_TAB_0,
+		AR_PHY_CHAN_INFO_TAB_1,
+		AR_PHY_CHAN_INFO_TAB_2,
+	};
+	struct coeff coeff;
+	s32 iq_res[6];
+	u8 num_chains = 0;
+	int i, ip, im, j;
+	int nmeasurement;
+
+	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+		if (ah->txchainmask & (1 << i))
+			num_chains++;
+	}
+
+	for (ip = 0; ip < MPASS; ip++) {
+		for (i = 0; i < num_chains; i++) {
+			nmeasurement = REG_READ_FIELD(ah,
+					AR_PHY_TX_IQCAL_STATUS_B0_9485,
+					AR_PHY_CALIBRATED_GAINS_0);
+			if (nmeasurement > MAX_MEASUREMENT)
+				nmeasurement = MAX_MEASUREMENT;
+
+			for (im = 0; im < nmeasurement; im++) {
+				ath_print(common, ATH_DBG_CALIBRATE,
+					  "Doing Tx IQ Cal for chain %d.\n", i);
+
+				if (REG_READ(ah, txiqcal_status[i]) &
+				    AR_PHY_TX_IQCAL_STATUS_FAILED) {
+					ath_print(common, ATH_DBG_CALIBRATE,
+					"Tx IQ Cal failed for chain %d.\n", i);
+					goto tx_iqcal_fail;
+				}
+
+				for (j = 0; j < 3; j++) {
+					u32 idx = 2 * j, offset = 4 * (3 * im + j);
+
+					REG_RMW_FIELD(ah,
+						AR_PHY_CHAN_INFO_MEMORY,
+						AR_PHY_CHAN_INFO_TAB_S2_READ,
+						0);
+
+					/* 32 bits */
+					iq_res[idx] = REG_READ(ah,
+							chan_info_tab[i] +
+							offset);
+
+					REG_RMW_FIELD(ah,
+						AR_PHY_CHAN_INFO_MEMORY,
+						AR_PHY_CHAN_INFO_TAB_S2_READ,
+						1);
+
+					/* 16 bits */
+					iq_res[idx + 1] = 0xffff & REG_READ(ah,
+							  chan_info_tab[i] + offset);
+
+					ath_print(common, ATH_DBG_CALIBRATE,
+						  "IQ RES[%d]=0x%x"
+						  "IQ_RES[%d]=0x%x\n",
+						  idx, iq_res[idx], idx + 1,
+						  iq_res[idx + 1]);
+				}
+
+				if (!ar9003_hw_calc_iq_corr(ah, i, iq_res,
+							    coeff.iqc_coeff)) {
+					ath_print(common, ATH_DBG_CALIBRATE,
+					 "Failed in calculation of IQ correction.\n");
+					goto tx_iqcal_fail;
+				}
+
+				coeff.mag_coeff[i][im][ip] =
+						coeff.iqc_coeff[0] & 0x7f;
+				coeff.phs_coeff[i][im][ip] =
+						(coeff.iqc_coeff[0] >> 7) & 0x7f;
+
+				if (coeff.mag_coeff[i][im][ip] > 63)
+					coeff.mag_coeff[i][im][ip] -= 128;
+				if (coeff.phs_coeff[i][im][ip] > 63)
+					coeff.phs_coeff[i][im][ip] -= 128;
+			}
+		}
+	}
+	ar9003_hw_tx_iqcal_load_avg_2_passes(ah, num_chains, &coeff);
+
+	return;
+
+tx_iqcal_fail:
+	ath_print(common, ATH_DBG_CALIBRATE, "Tx IQ Cal failed\n");
+	return;
+}
 static bool ar9003_hw_init_cal(struct ath_hw *ah,
 			       struct ath9k_channel *chan)
 {
@@ -735,7 +968,11 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 		ar9003_hw_set_chain_masks(ah, 0x7, 0x7);
 
 	/* Do Tx IQ Calibration */
-	ar9003_hw_tx_iq_cal(ah);
+	if (AR_SREV_9485(ah))
+		ar9003_hw_tx_iq_cal_run(ah);
+	else
+		ar9003_hw_tx_iq_cal(ah);
+
 	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
 	udelay(5);
 	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
@@ -754,6 +991,9 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 		return false;
 	}
 
+	if (AR_SREV_9485(ah))
+		ar9003_hw_tx_iq_cal_post_proc(ah);
+
 	/* Revert chainmasks to their original values before NF cal */
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index abb4ec1..74e0da9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -546,6 +546,12 @@
 
 #define AR_PHY_TXGAIN_TABLE      (AR_SM_BASE + 0x300)
 
+#define AR_PHY_TX_IQCAL_START_9485		(AR_SM_BASE + 0x3c4)
+#define AR_PHY_TX_IQCAL_START_DO_CAL_9485	0x80000000
+#define AR_PHY_TX_IQCAL_START_DO_CAL_9485_S	31
+#define AR_PHY_TX_IQCAL_CONTROL_1_9485		(AR_SM_BASE + 0x3c8)
+#define AR_PHY_TX_IQCAL_STATUS_B0_9485		(AR_SM_BASE + 0x3f0)
+
 #define AR_PHY_TX_IQCAL_CONTROL_1   (AR_SM_BASE + 0x448)
 #define AR_PHY_TX_IQCAL_START       (AR_SM_BASE + 0x440)
 #define AR_PHY_TX_IQCAL_STATUS_B0   (AR_SM_BASE + 0x48c)
@@ -713,6 +719,7 @@
 #define AR_PHY_TPCGR1_FORCED_DAC_GAIN_S 1
 #define AR_PHY_TPCGR1_FORCE_DAC_GAIN    0x00000001
 #define AR_PHY_TXGAIN_FORCE               0x00000001
+#define AR_PHY_TXGAIN_FORCE_S		  0
 #define AR_PHY_TXGAIN_FORCED_PADVGNRA     0x00003c00
 #define AR_PHY_TXGAIN_FORCED_PADVGNRA_S   10
 #define AR_PHY_TXGAIN_FORCED_PADVGNRB     0x0003c000
@@ -755,8 +762,13 @@
 #define AR_PHY_TX_IQCAL_START_DO_CAL_S      0
 
 #define AR_PHY_TX_IQCAL_STATUS_FAILED    0x00000001
-#define AR_PHY_TX_IQCAL_CORR_COEFF_01_COEFF_TABLE      0x00003fff
-#define AR_PHY_TX_IQCAL_CORR_COEFF_01_COEFF_TABLE_S    0
+#define AR_PHY_CALIBRATED_GAINS_0	 0x3e
+#define AR_PHY_CALIBRATED_GAINS_0_S	 1
+
+#define AR_PHY_TX_IQCAL_CORR_COEFF_00_COEFF_TABLE      0x00003fff
+#define AR_PHY_TX_IQCAL_CORR_COEFF_00_COEFF_TABLE_S    0
+#define AR_PHY_TX_IQCAL_CORR_COEFF_01_COEFF_TABLE      0x0fffc000
+#define AR_PHY_TX_IQCAL_CORR_COEFF_01_COEFF_TABLE_S    14
 
 #define AR_PHY_65NM_CH0_RXTX4_THERM_ON          0x10000000
 #define AR_PHY_65NM_CH0_RXTX4_THERM_ON_S        28
-- 
1.7.0.4


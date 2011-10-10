Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49731 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1JJFvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 01:51:08 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH v2 04/13] ath9k_hw: Improve fast channel change for AR9003 chips
Date: Mon, 10 Oct 2011 11:21:09 +0530
Message-ID: <1318225878-7283-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111010_075112_125611_5E5CF7D9)
In-Reply-To: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to reduce the overall scan time, fast channel change
should be implemented properly. This patch adds fast channel
change support across band switch or channel mode switch
instead of doing full chip reset. During the fastcc, tx iqcal
measurements are preserved and will be reloaded after successful
the channel change.

This patch also addressed fast channel issue where the STA can not
see APs in higher than operating channel on 5GHz band after
the association.

Cc: Paul Stewart <pstew@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   72 +++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |   69 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h   |    3 +
 drivers/net/wireless/ath/ath9k/hw-ops.h       |    7 +++
 drivers/net/wireless/ath/ath9k/hw.c           |   32 +++++++++++
 drivers/net/wireless/ath/ath9k/hw.h           |    8 +++
 6 files changed, 186 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index e4b1a83..026aa5b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -18,7 +18,7 @@
 #include "hw-ops.h"
 #include "ar9003_phy.h"
 
-#define MAX_MEASUREMENT	8
+#define MAX_MEASUREMENT	MAX_IQCAL_MEASUREMENT
 #define MAX_MAG_DELTA	11
 #define MAX_PHS_DELTA	10
 
@@ -663,6 +663,7 @@ static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
 {
 	int i, im, nmeasurement;
 	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS];
+	struct ath9k_hw_cal_data *caldata = ah->caldata;
 
 	memset(tx_corr_coeff, 0, sizeof(tx_corr_coeff));
 	for (i = 0; i < MAX_MEASUREMENT / 2; i++) {
@@ -712,13 +713,21 @@ static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,
 				REG_RMW_FIELD(ah, tx_corr_coeff[im][i],
 					AR_PHY_TX_IQCAL_CORR_COEFF_01_COEFF_TABLE,
 					coeff->iqc_coeff[0]);
+
+			if (caldata)
+				caldata->tx_corr_coeff[im][i] =
+					coeff->iqc_coeff[0];
 		}
+		if (caldata)
+			caldata->num_measures[i] = nmeasurement;
 	}
 
 	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_3,
 		      AR_PHY_TX_IQCAL_CONTROL_3_IQCORR_EN, 0x1);
 	REG_RMW_FIELD(ah, AR_PHY_RX_IQCAL_CORR_B0,
 		      AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN, 0x1);
+	if (caldata)
+		caldata->done_txiqcal_once = true;
 
 	return;
 
@@ -845,10 +854,55 @@ tx_iqcal_fail:
 	ath_dbg(common, ATH_DBG_CALIBRATE, "Tx IQ Cal failed\n");
 	return;
 }
+
+static void ar9003_hw_tx_iq_cal_reload(struct ath_hw *ah)
+{
+	struct ath9k_hw_cal_data *caldata = ah->caldata;
+	u32 tx_corr_coeff[MAX_MEASUREMENT][AR9300_MAX_CHAINS];
+	int i, im;
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
+	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+		if (!(ah->txchainmask & (1 << i)))
+			continue;
+
+		for (im = 0; im < caldata->num_measures[i]; im++) {
+			if ((im % 2) == 0)
+				REG_RMW_FIELD(ah, tx_corr_coeff[im][i],
+				     AR_PHY_TX_IQCAL_CORR_COEFF_00_COEFF_TABLE,
+				     caldata->tx_corr_coeff[im][i]);
+			else
+				REG_RMW_FIELD(ah, tx_corr_coeff[im][i],
+				     AR_PHY_TX_IQCAL_CORR_COEFF_01_COEFF_TABLE,
+				     caldata->tx_corr_coeff[im][i]);
+		}
+	}
+
+	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_3,
+		      AR_PHY_TX_IQCAL_CONTROL_3_IQCORR_EN, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_RX_IQCAL_CORR_B0,
+		      AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN, 0x1);
+}
+
 static bool ar9003_hw_init_cal(struct ath_hw *ah,
 			       struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	bool txiqcal_done = false;
 
 	/* Do Tx IQ Calibration */
@@ -860,9 +914,15 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	 * For AR9485 or later chips, TxIQ cal runs as part of
 	 * AGC calibration
 	 */
-	if (AR_SREV_9485_OR_LATER(ah))
+	if (AR_SREV_9485_OR_LATER(ah) && !AR_SREV_9340(ah)) {
+		if (caldata && !caldata->done_txiqcal_once)
+			REG_SET_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
+				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
+		else
+			REG_CLR_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
+				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
 		txiqcal_done = true;
-	else {
+	} else {
 		txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
 		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
 		udelay(5);
@@ -884,6 +944,8 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 
 	if (txiqcal_done)
 		ar9003_hw_tx_iq_cal_post_proc(ah);
+	else if (caldata && caldata->done_txiqcal_once)
+		ar9003_hw_tx_iq_cal_reload(ah);
 
 	ath9k_hw_loadnf(ah, chan);
 	ath9k_hw_start_nfcal(ah, true);
@@ -912,8 +974,8 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	if (ah->cal_list_curr)
 		ath9k_hw_reset_calibration(ah, ah->cal_list_curr);
 
-	if (ah->caldata)
-		ah->caldata->CalValid = 0;
+	if (caldata)
+		caldata->CalValid = 0;
 
 	return true;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 7db6e86..c01ee82 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -690,6 +690,7 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	if (AR_SREV_9480(ah))
 		ar9003_hw_prog_ini(ah, &ah->ini_BTCOEX_MAX_TXPWR, 1);
 
+	ah->modes_index = modesIndex;
 	ar9003_hw_override_ini(ah);
 	ar9003_hw_set_channel_regs(ah, chan);
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
@@ -1256,6 +1257,73 @@ static void ar9003_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
 }
 
+static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
+				      struct ath9k_channel *chan,
+				      u8 *ini_reloaded)
+{
+	unsigned int regWrites = 0;
+	u32 modesIndex;
+
+	switch (chan->chanmode) {
+	case CHANNEL_A:
+	case CHANNEL_A_HT20:
+		modesIndex = 1;
+		break;
+	case CHANNEL_A_HT40PLUS:
+	case CHANNEL_A_HT40MINUS:
+		modesIndex = 2;
+		break;
+	case CHANNEL_G:
+	case CHANNEL_G_HT20:
+	case CHANNEL_B:
+		modesIndex = 4;
+		break;
+	case CHANNEL_G_HT40PLUS:
+	case CHANNEL_G_HT40MINUS:
+		modesIndex = 3;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (modesIndex == ah->modes_index) {
+		*ini_reloaded = false;
+		goto set_rfmode;
+	}
+
+	ar9003_hw_prog_ini(ah, &ah->iniSOC[ATH_INI_POST], modesIndex);
+	ar9003_hw_prog_ini(ah, &ah->iniMac[ATH_INI_POST], modesIndex);
+	ar9003_hw_prog_ini(ah, &ah->iniBB[ATH_INI_POST], modesIndex);
+	ar9003_hw_prog_ini(ah, &ah->iniRadio[ATH_INI_POST], modesIndex);
+	if (AR_SREV_9480_20(ah))
+		ar9003_hw_prog_ini(ah,
+				&ah->ini_radio_post_sys2ant,
+				modesIndex);
+
+	REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
+
+	/*
+	 * For 5GHz channels requiring Fast Clock, apply
+	 * different modal values.
+	 */
+	if (IS_CHAN_A_FAST_CLOCK(ah, chan))
+		REG_WRITE_ARRAY(&ah->iniModesAdditional, modesIndex, regWrites);
+
+	if (AR_SREV_9330(ah))
+		REG_WRITE_ARRAY(&ah->iniModesAdditional, 1, regWrites);
+
+	if (AR_SREV_9340(ah) && !ah->is_clk_25mhz)
+		REG_WRITE_ARRAY(&ah->iniModesAdditional_40M, 1, regWrites);
+
+	ah->modes_index = modesIndex;
+	*ini_reloaded = true;
+
+set_rfmode:
+	ar9003_hw_set_rfmode(ah, chan);
+	return 0;
+}
+
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -1284,6 +1352,7 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->do_getnf = ar9003_hw_do_getnf;
 	priv_ops->ani_cache_ini_regs = ar9003_hw_ani_cache_ini_regs;
 	priv_ops->set_radar_params = ar9003_hw_set_radar_params;
+	priv_ops->fast_chan_change = ar9003_hw_fast_chan_change;
 
 	ops->antdiv_comb_conf_get = ar9003_hw_antdiv_comb_conf_get;
 	ops->antdiv_comb_conf_set = ar9003_hw_antdiv_comb_conf_set;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 6cea546..c6ed51f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -572,6 +572,8 @@
 
 #define AR_PHY_TXGAIN_TABLE      (AR_SM_BASE + 0x300)
 
+#define AR_PHY_TX_IQCAL_CONTROL_0   (AR_SM_BASE + AR_SREV_9485(ah) ? \
+						 0x3c4 : 0x444)
 #define AR_PHY_TX_IQCAL_CONTROL_1   (AR_SM_BASE + AR_SREV_9485(ah) ? \
 						 0x3c8 : 0x448)
 #define AR_PHY_TX_IQCAL_START       (AR_SM_BASE + AR_SREV_9485(ah) ? \
@@ -823,6 +825,7 @@
 #define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT   0x01000000
 #define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT_S 24
 #define AR_PHY_CHANNEL_STATUS_RX_CLEAR      0x00000004
+#define AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL                   0x80000000
 #define AR_PHY_TX_IQCAL_CONTROL_1_IQCORR_I_Q_COFF_DELPT             0x01fc0000
 #define AR_PHY_TX_IQCAL_CONTROL_1_IQCORR_I_Q_COFF_DELPT_S                   18
 #define AR_PHY_TX_IQCAL_START_DO_CAL	    0x00000001
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index e9782d1..e74c233 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -205,4 +205,11 @@ static inline void ath9k_hw_setup_calibration(struct ath_hw *ah,
 	ath9k_hw_private_ops(ah)->setup_calibration(ah, currCal);
 }
 
+static inline int ath9k_hw_fast_chan_change(struct ath_hw *ah,
+					    struct ath9k_channel *chan,
+					    u8 *ini_reloaded)
+{
+	return ath9k_hw_private_ops(ah)->fast_chan_change(ah, chan,
+							  ini_reloaded);
+}
 #endif /* ATH9K_HW_OPS_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 42ebe8f..a71e14a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1394,6 +1394,14 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	struct ieee80211_channel *channel = chan->chan;
 	u32 qnum;
 	int r;
+	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
+	bool band_switch, mode_diff;
+	u8 ini_reloaded;
+
+	band_switch = (chan->channelFlags & (CHANNEL_2GHZ | CHANNEL_5GHZ)) !=
+		      (ah->curchan->channelFlags & (CHANNEL_2GHZ |
+						    CHANNEL_5GHZ));
+	mode_diff = (chan->chanmode != ah->curchan->chanmode);
 
 	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
 		if (ath9k_hw_numtxpending(ah, qnum)) {
@@ -1408,6 +1416,18 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 		return false;
 	}
 
+	if (edma && (band_switch || mode_diff)) {
+		ath9k_hw_mark_phy_inactive(ah);
+		udelay(5);
+
+		ath9k_hw_init_pll(ah, NULL);
+
+		if (ath9k_hw_fast_chan_change(ah, chan, &ini_reloaded)) {
+			ath_err(common, "Failed to do fast channel change\n");
+			return false;
+		}
+	}
+
 	ath9k_hw_set_channel_regs(ah, chan);
 
 	r = ath9k_hw_rf_set_freq(ah, chan);
@@ -1431,6 +1451,16 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 
 	ath9k_hw_spur_mitigate_freq(ah, chan);
 
+	if (edma && (band_switch || mode_diff)) {
+		if (band_switch || ini_reloaded)
+			ah->eep_ops->set_board_values(ah, chan);
+
+		ath9k_hw_init_bb(ah, chan);
+
+		if (band_switch || ini_reloaded)
+			ath9k_hw_init_cal(ah, chan);
+	}
+
 	return true;
 }
 
@@ -1684,6 +1714,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_init_bb(ah, chan);
 
+	if (caldata)
+		caldata->done_txiqcal_once = false;
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 24889f7..04db968 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -337,6 +337,8 @@ enum ath9k_int {
 	 CHANNEL_HT40PLUS |			\
 	 CHANNEL_HT40MINUS)
 
+#define MAX_IQCAL_MEASUREMENT	8
+
 struct ath9k_hw_cal_data {
 	u16 channel;
 	u32 channelFlags;
@@ -346,8 +348,11 @@ struct ath9k_hw_cal_data {
 	bool paprd_done;
 	bool nfcal_pending;
 	bool nfcal_interference;
+	bool done_txiqcal_once;
 	u16 small_signal_gain[AR9300_MAX_CHAINS];
 	u32 pa_table[AR9300_MAX_CHAINS][PAPRD_TABLE_SZ];
+	u32 num_measures[AR9300_MAX_CHAINS];
+	int tx_corr_coeff[MAX_IQCAL_MEASUREMENT][AR9300_MAX_CHAINS];
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
 };
 
@@ -591,6 +596,8 @@ struct ath_hw_private_ops {
 	void (*do_getnf)(struct ath_hw *ah, int16_t nfarray[NUM_NF_READINGS]);
 	void (*set_radar_params)(struct ath_hw *ah,
 				 struct ath_hw_radar_conf *conf);
+	int (*fast_chan_change)(struct ath_hw *ah, struct ath9k_channel *chan,
+				u8 *ini_reloaded);
 
 	/* ANI */
 	void (*ani_cache_ini_regs)(struct ath_hw *ah);
@@ -692,6 +699,7 @@ struct ath_hw {
 	atomic_t intr_ref_cnt;
 	bool chip_fullsleep;
 	u32 atim_window;
+	u32 modes_index;
 
 	/* Calibration */
 	u32 supp_cals;
-- 
1.7.7


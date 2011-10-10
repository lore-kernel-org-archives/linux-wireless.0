Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8500 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1JJFv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 01:51:27 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 07/13] ath9k_hw: Cleanup Tx calibrations for AR9003 chips
Date: Mon, 10 Oct 2011 11:21:12 +0530
Message-ID: <1318225878-7283-7-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111010_075130_210790_30A830BC)
In-Reply-To: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently Tx IQ calibration is enabled by default for all AR9003
chips. But for AR9480, the calibration status should be read from
chip after processing ini. And also the carrier leak calibration
status is checked during init cal. As the init_cal is being called
for fast channel change too, the tx_cl status only be read after
full reset. Hence moving that into process ini function.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |   27 +++++++++++++------------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |   12 +++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h   |    1 +
 drivers/net/wireless/ath/ath9k/hw.c           |    5 ++++
 drivers/net/wireless/ath/ath9k/hw.h           |    7 ++++++
 5 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 5f40638..3506e7b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -906,15 +906,13 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	bool txiqcal_done = false, txclcal_done = false;
-	bool is_reusable = true, txclcal_enabled;
+	bool is_reusable = true;
+	int i, j;
 	u32 cl_idx[AR9300_MAX_CHAINS] = { AR_PHY_CL_TAB_0,
 					  AR_PHY_CL_TAB_1,
 					  AR_PHY_CL_TAB_2 };
 
-	txclcal_enabled = !!(REG_READ(ah, AR_PHY_CL_CAL_CTL) &
-				      AR_PHY_CL_CAL_ENABLE);
-
-	if (txclcal_enabled) {
+	if (ah->enabled_cals & TX_CL_CAL) {
 		if (caldata && caldata->done_txclcal_once)
 			REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL,
 				    AR_PHY_CL_CAL_ENABLE);
@@ -923,6 +921,9 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 				    AR_PHY_CL_CAL_ENABLE);
 	}
 
+	if (!(ah->enabled_cals & TX_IQ_CAL))
+		goto skip_tx_iqcal;
+
 	/* Do Tx IQ Calibration */
 	REG_RMW_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_1,
 		      AR_PHY_TX_IQCAL_CONTROL_1_IQCORR_I_Q_COFF_DELPT,
@@ -932,7 +933,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	 * For AR9485 or later chips, TxIQ cal runs as part of
 	 * AGC calibration
 	 */
-	if (AR_SREV_9485_OR_LATER(ah) && !AR_SREV_9340(ah)) {
+	if (ah->enabled_cals & TX_IQ_ON_AGC_CAL) {
 		if (caldata && !caldata->done_txiqcal_once)
 			REG_SET_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
 				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
@@ -940,13 +941,14 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 			REG_CLR_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
 				    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
 		txiqcal_done = true;
-	} else {
-		txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
-		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
-		udelay(5);
-		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+		goto skip_tx_iqcal;
 	}
+	txiqcal_done = ar9003_hw_tx_iq_cal_run(ah);
+	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
+	udelay(5);
+	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
 
+skip_tx_iqcal:
 	/* Calibrate the AGC */
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
 		  REG_READ(ah, AR_PHY_AGC_CONTROL) |
@@ -966,8 +968,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 		ar9003_hw_tx_iq_cal_reload(ah);
 
 #define CL_TAB_ENTRY(reg_base)	(reg_base + (4 * j))
-	if (caldata && txclcal_enabled) {
-		int i, j;
+	if (caldata && (ah->enabled_cals & TX_CL_CAL)) {
 		txclcal_done = !!(REG_READ(ah, AR_PHY_AGC_CONTROL) &
 					   AR_PHY_AGC_CONTROL_CLC_SUCCESS);
 		if (caldata->done_txclcal_once) {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index c01ee82..3bf7c81 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -702,6 +702,18 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 				 channel->max_power * 2,
 				 min((u32) MAX_RATE_POWER,
 				 (u32) regulatory->power_limit), false);
+	if (AR_SREV_9480(ah)) {
+		if (REG_READ_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_0,
+				AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL))
+			ah->enabled_cals |= TX_IQ_CAL;
+		else
+			ah->enabled_cals &= ~TX_IQ_CAL;
+
+		if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE)
+			ah->enabled_cals |= TX_CL_CAL;
+		else
+			ah->enabled_cals &= ~TX_CL_CAL;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index c6ed51f..ef90ab7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -826,6 +826,7 @@
 #define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT_S 24
 #define AR_PHY_CHANNEL_STATUS_RX_CLEAR      0x00000004
 #define AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL                   0x80000000
+#define AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL_S                         31
 #define AR_PHY_TX_IQCAL_CONTROL_1_IQCORR_I_Q_COFF_DELPT             0x01fc0000
 #define AR_PHY_TX_IQCAL_CONTROL_1_IQCORR_I_Q_COFF_DELPT_S                   18
 #define AR_PHY_TX_IQCAL_START_DO_CAL	    0x00000001
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e2cae1a..067f968 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2328,6 +2328,11 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		rx_chainmask >>= 1;
 	}
 
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		ah->enabled_cals |= TX_IQ_CAL;
+		if (!AR_SREV_9330(ah))
+			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
+	}
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0a8aef9..5ac013a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -642,6 +642,12 @@ struct ath_nf_limits {
 	s16 nominal;
 };
 
+enum ath_cal_list {
+	TX_IQ_CAL         =	BIT(0),
+	TX_IQ_ON_AGC_CAL  =	BIT(1),
+	TX_CL_CAL         =	BIT(2),
+};
+
 /* ah_flags */
 #define AH_USE_EEPROM   0x1
 #define AH_UNPLUGGED    0x2 /* The card has been physically removed. */
@@ -741,6 +747,7 @@ struct ath_hw {
 		int32_t sign[AR5416_MAX_CHAINS];
 	} meas3;
 	u16 cal_samples;
+	u8 enabled_cals;
 
 	u32 sta_id1_defaults;
 	u32 misc_mode;
-- 
1.7.7


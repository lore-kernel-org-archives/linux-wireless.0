Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:35994 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab3IKLKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 07:10:36 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] ath9k: Fix PeakDetect calibration for AR9462
Date: Wed, 11 Sep 2013 16:36:32 +0530
Message-Id: <1378897592-19199-2-git-send-email-sujith@msujith.org> (sfid-20130911_131040_106043_F370E90A)
In-Reply-To: <1378897592-19199-1-git-send-email-sujith@msujith.org>
References: <1378897592-19199-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since HW PeakDetect calibration is turned on for AR9462,
various conditions have to be handled in the driver:

* Enable agc_cal when loading RTT fails.
* Disable SW PeakDetect calibration when RTT calibration is not enabled.
* Keep SW PeakDetect calibration result in driver.
* Update RTT table according to the saved value.
* Write RTT back after modifying SW RTT table.
* Enable local mode for PeakDetect calibration and restore values.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 57 +++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/ar9003_rtt.c   | 52 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.h           |  2 +
 3 files changed, 99 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 687173c..22934d3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -965,18 +965,44 @@ static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
 }
 
 static void ar9003_hw_do_manual_peak_cal(struct ath_hw *ah,
-					 struct ath9k_channel *chan)
+					 struct ath9k_channel *chan,
+					 bool run_rtt_cal)
 {
+	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	int i;
 
 	if (!AR_SREV_9462(ah) && !AR_SREV_9565(ah) && !AR_SREV_9485(ah))
 		return;
 
+	if ((ah->caps.hw_caps & ATH9K_HW_CAP_RTT) && !run_rtt_cal)
+		return;
+
 	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
 		if (!(ah->rxchainmask & (1 << i)))
 			continue;
 		ar9003_hw_manual_peak_cal(ah, i, IS_CHAN_2GHZ(chan));
 	}
+
+	if (caldata)
+		set_bit(SW_PKDET_DONE, &caldata->cal_flags);
+
+	if ((ah->caps.hw_caps & ATH9K_HW_CAP_RTT) && caldata) {
+		if (IS_CHAN_2GHZ(chan)){
+			caldata->caldac[0] = REG_READ_FIELD(ah,
+						    AR_PHY_65NM_RXRF_AGC(0),
+						    AR_PHY_65NM_RXRF_AGC_AGC2G_CALDAC_OVR);
+			caldata->caldac[1] = REG_READ_FIELD(ah,
+						    AR_PHY_65NM_RXRF_AGC(1),
+						    AR_PHY_65NM_RXRF_AGC_AGC2G_CALDAC_OVR);
+		} else {
+			caldata->caldac[0] = REG_READ_FIELD(ah,
+						    AR_PHY_65NM_RXRF_AGC(0),
+						    AR_PHY_65NM_RXRF_AGC_AGC5G_CALDAC_OVR);
+			caldata->caldac[1] = REG_READ_FIELD(ah,
+						    AR_PHY_65NM_RXRF_AGC(1),
+						    AR_PHY_65NM_RXRF_AGC_AGC5G_CALDAC_OVR);
+		}
+	}
 }
 
 static void ar9003_hw_cl_cal_post_proc(struct ath_hw *ah, bool is_reusable)
@@ -1047,13 +1073,18 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 		ar9003_hw_rtt_clear_hist(ah);
 	}
 
-	if (rtt && !run_rtt_cal) {
-		agc_ctrl = REG_READ(ah, AR_PHY_AGC_CONTROL);
-		agc_supp_cals &= agc_ctrl;
-		agc_ctrl &= ~(AR_PHY_AGC_CONTROL_OFFSET_CAL |
-			     AR_PHY_AGC_CONTROL_FLTR_CAL |
-			     AR_PHY_AGC_CONTROL_PKDET_CAL);
-		REG_WRITE(ah, AR_PHY_AGC_CONTROL, agc_ctrl);
+	if (rtt) {
+		if (!run_rtt_cal) {
+			agc_ctrl = REG_READ(ah, AR_PHY_AGC_CONTROL);
+			agc_supp_cals &= agc_ctrl;
+			agc_ctrl &= ~(AR_PHY_AGC_CONTROL_OFFSET_CAL |
+				      AR_PHY_AGC_CONTROL_FLTR_CAL |
+				      AR_PHY_AGC_CONTROL_PKDET_CAL);
+			REG_WRITE(ah, AR_PHY_AGC_CONTROL, agc_ctrl);
+		} else {
+			if (ah->ah_flags & AH_FASTCC)
+				run_agc_cal = true;
+		}
 	}
 
 	if (ah->enabled_cals & TX_CL_CAL) {
@@ -1124,7 +1155,7 @@ skip_tx_iqcal:
 				       AR_PHY_AGC_CONTROL_CAL,
 				       0, AH_WAIT_TIMEOUT);
 
-		ar9003_hw_do_manual_peak_cal(ah, chan);
+		ar9003_hw_do_manual_peak_cal(ah, chan, run_rtt_cal);
 	}
 
 	if (REG_READ(ah, AR_PHY_CL_CAL_CTL) & AR_PHY_CL_CAL_ENABLE) {
@@ -1159,12 +1190,16 @@ skip_tx_iqcal:
 
 	if (run_rtt_cal && caldata) {
 		if (is_reusable) {
-			if (!ath9k_hw_rfbus_req(ah))
+			if (!ath9k_hw_rfbus_req(ah)) {
 				ath_err(ath9k_hw_common(ah),
 					"Could not stop baseband\n");
-			else
+			} else {
 				ar9003_hw_rtt_fill_hist(ah);
 
+				if (test_bit(SW_PKDET_DONE, &caldata->cal_flags))
+					ar9003_hw_rtt_load_hist(ah);
+			}
+
 			ath9k_hw_rfbus_done(ah);
 		}
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_rtt.c b/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
index e398c18..9344188 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_rtt.c
@@ -118,6 +118,27 @@ void ar9003_hw_rtt_load_hist(struct ath_hw *ah)
 	}
 }
 
+static void ar9003_hw_patch_rtt(struct ath_hw *ah, int index, int chain)
+{
+	int agc, caldac;
+
+	if (!test_bit(SW_PKDET_DONE, &ah->caldata->cal_flags))
+		return;
+
+	if ((index != 5) || (chain >= 2))
+		return;
+
+	agc = REG_READ_FIELD(ah, AR_PHY_65NM_RXRF_AGC(chain),
+			     AR_PHY_65NM_RXRF_AGC_AGC_OVERRIDE);
+	if (!agc)
+		return;
+
+	caldac = ah->caldata->caldac[chain];
+	ah->caldata->rtt_table[chain][index] &= 0xFFFF05FF;
+	caldac = (caldac & 0x20) | ((caldac & 0x1F) << 7);
+	ah->caldata->rtt_table[chain][index] |= (caldac << 4);
+}
+
 static int ar9003_hw_rtt_fill_hist_entry(struct ath_hw *ah, u8 chain, u32 index)
 {
 	u32 val;
@@ -155,6 +176,9 @@ void ar9003_hw_rtt_fill_hist(struct ath_hw *ah)
 		for (i = 0; i < MAX_RTT_TABLE_ENTRY; i++) {
 			ah->caldata->rtt_table[chain][i] =
 				ar9003_hw_rtt_fill_hist_entry(ah, chain, i);
+
+			ar9003_hw_patch_rtt(ah, i, chain);
+
 			ath_dbg(ath9k_hw_common(ah), CALIBRATE,
 				"RTT value at idx %d, chain %d is: 0x%x\n",
 				i, chain, ah->caldata->rtt_table[chain][i]);
@@ -186,11 +210,37 @@ bool ar9003_hw_rtt_restore(struct ath_hw *ah, struct ath9k_channel *chan)
 	if (!ah->caldata)
 		return false;
 
+	if (test_bit(SW_PKDET_DONE, &ah->caldata->cal_flags)) {
+		if (IS_CHAN_2GHZ(chan)){
+			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(0),
+				      AR_PHY_65NM_RXRF_AGC_AGC2G_CALDAC_OVR,
+				      ah->caldata->caldac[0]);
+			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(1),
+				      AR_PHY_65NM_RXRF_AGC_AGC2G_CALDAC_OVR,
+				      ah->caldata->caldac[1]);
+		} else {
+			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(0),
+				      AR_PHY_65NM_RXRF_AGC_AGC5G_CALDAC_OVR,
+				      ah->caldata->caldac[0]);
+			REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(1),
+				      AR_PHY_65NM_RXRF_AGC_AGC5G_CALDAC_OVR,
+				      ah->caldata->caldac[1]);
+		}
+		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(1),
+			      AR_PHY_65NM_RXRF_AGC_AGC_OVERRIDE, 0x1);
+		REG_RMW_FIELD(ah, AR_PHY_65NM_RXRF_AGC(0),
+			      AR_PHY_65NM_RXRF_AGC_AGC_OVERRIDE, 0x1);
+	}
+
 	if (!test_bit(RTT_DONE, &ah->caldata->cal_flags))
 		return false;
 
 	ar9003_hw_rtt_enable(ah);
-	ar9003_hw_rtt_set_mask(ah, 0x10);
+
+	if (test_bit(SW_PKDET_DONE, &ah->caldata->cal_flags))
+		ar9003_hw_rtt_set_mask(ah, 0x30);
+	else
+		ar9003_hw_rtt_set_mask(ah, 0x10);
 
 	if (!ath9k_hw_rfbus_req(ah)) {
 		ath_err(ath9k_hw_common(ah), "Could not stop baseband\n");
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 2df1095..cc27324 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -412,6 +412,7 @@ enum ath9k_cal_flags {
 	NFCAL_INTF,
 	TXIQCAL_DONE,
 	TXCLCAL_DONE,
+	SW_PKDET_DONE,
 };
 
 struct ath9k_hw_cal_data {
@@ -422,6 +423,7 @@ struct ath9k_hw_cal_data {
 	int32_t CalValid;
 	int8_t iCoff;
 	int8_t qCoff;
+	u8 caldac[2];
 	u16 small_signal_gain[AR9300_MAX_CHAINS];
 	u32 pa_table[AR9300_MAX_CHAINS][PAPRD_TABLE_SZ];
 	u32 num_measures[AR9300_MAX_CHAINS];
-- 
1.8.4


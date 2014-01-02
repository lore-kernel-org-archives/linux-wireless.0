Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:39771 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaABEl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jan 2014 23:41:28 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix AR955x RX sensitivity
Date: Thu,  2 Jan 2014 10:06:21 +0530
Message-Id: <1388637381-24493-1-git-send-email-sujith@msujith.org> (sfid-20140102_054133_549635_4E9F3A9D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

AR955x has problems with RX sensitivity in 2G. This patch
adds a routine to select range_osdac dynamically on a
per-chain basis to address this issue.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 223 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h   |  10 ++
 2 files changed, 233 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 97e09d5..8c145cd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -326,6 +326,224 @@ static void ar9003_hw_init_cal_settings(struct ath_hw *ah)
 	ah->supp_cals = IQ_MISMATCH_CAL;
 }
 
+#define OFF_UPPER_LT 24
+#define OFF_LOWER_LT 7
+
+static bool ar9003_hw_dynamic_osdac_selection(struct ath_hw *ah,
+					      bool txiqcal_done)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	int ch0_done, osdac_ch0, dc_off_ch0_i1, dc_off_ch0_q1, dc_off_ch0_i2,
+		dc_off_ch0_q2, dc_off_ch0_i3, dc_off_ch0_q3;
+	int ch1_done, osdac_ch1, dc_off_ch1_i1, dc_off_ch1_q1, dc_off_ch1_i2,
+		dc_off_ch1_q2, dc_off_ch1_i3, dc_off_ch1_q3;
+	int ch2_done, osdac_ch2, dc_off_ch2_i1, dc_off_ch2_q1, dc_off_ch2_i2,
+		dc_off_ch2_q2, dc_off_ch2_i3, dc_off_ch2_q3;
+	bool status;
+	u32 temp, val;
+
+	/*
+	 * Clear offset and IQ calibration, run AGC cal.
+	 */
+	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_OFFSET_CAL);
+	REG_CLR_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
+		    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
+	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
+		  REG_READ(ah, AR_PHY_AGC_CONTROL) | AR_PHY_AGC_CONTROL_CAL);
+
+	status = ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
+			       AR_PHY_AGC_CONTROL_CAL,
+			       0, AH_WAIT_TIMEOUT);
+	if (!status) {
+		ath_dbg(common, CALIBRATE,
+			"AGC cal without offset cal failed to complete in 1ms");
+		return false;
+	}
+
+	/*
+	 * Allow only offset calibration and disable the others
+	 * (Carrier Leak calibration, TX Filter calibration and
+	 *  Peak Detector offset calibration).
+	 */
+	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_OFFSET_CAL);
+	REG_CLR_BIT(ah, AR_PHY_CL_CAL_CTL,
+		    AR_PHY_CL_CAL_ENABLE);
+	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_FLTR_CAL);
+	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_PKDET_CAL);
+
+	ch0_done = 0;
+	ch1_done = 0;
+	ch2_done = 0;
+
+	while ((ch0_done == 0) || (ch1_done == 0) || (ch2_done == 0)) {
+		osdac_ch0 = (REG_READ(ah, AR_PHY_65NM_CH0_BB1) >> 30) & 0x3;
+		osdac_ch1 = (REG_READ(ah, AR_PHY_65NM_CH1_BB1) >> 30) & 0x3;
+		osdac_ch2 = (REG_READ(ah, AR_PHY_65NM_CH2_BB1) >> 30) & 0x3;
+
+		REG_SET_BIT(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+
+		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
+			  REG_READ(ah, AR_PHY_AGC_CONTROL) | AR_PHY_AGC_CONTROL_CAL);
+
+		status = ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL,
+				       AR_PHY_AGC_CONTROL_CAL,
+				       0, AH_WAIT_TIMEOUT);
+		if (!status) {
+			ath_dbg(common, CALIBRATE,
+				"DC offset cal failed to complete in 1ms");
+			return false;
+		}
+
+		REG_CLR_BIT(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+
+		/*
+		 * High gain.
+		 */
+		REG_WRITE(ah, AR_PHY_65NM_CH0_BB3,
+			  ((REG_READ(ah, AR_PHY_65NM_CH0_BB3) & 0xfffffcff) | (1 << 8)));
+		REG_WRITE(ah, AR_PHY_65NM_CH1_BB3,
+			  ((REG_READ(ah, AR_PHY_65NM_CH1_BB3) & 0xfffffcff) | (1 << 8)));
+		REG_WRITE(ah, AR_PHY_65NM_CH2_BB3,
+			  ((REG_READ(ah, AR_PHY_65NM_CH2_BB3) & 0xfffffcff) | (1 << 8)));
+
+		temp = REG_READ(ah, AR_PHY_65NM_CH0_BB3);
+		dc_off_ch0_i1 = (temp >> 26) & 0x1f;
+		dc_off_ch0_q1 = (temp >> 21) & 0x1f;
+
+		temp = REG_READ(ah, AR_PHY_65NM_CH1_BB3);
+		dc_off_ch1_i1 = (temp >> 26) & 0x1f;
+		dc_off_ch1_q1 = (temp >> 21) & 0x1f;
+
+		temp = REG_READ(ah, AR_PHY_65NM_CH2_BB3);
+		dc_off_ch2_i1 = (temp >> 26) & 0x1f;
+		dc_off_ch2_q1 = (temp >> 21) & 0x1f;
+
+		/*
+		 * Low gain.
+		 */
+		REG_WRITE(ah, AR_PHY_65NM_CH0_BB3,
+			  ((REG_READ(ah, AR_PHY_65NM_CH0_BB3) & 0xfffffcff) | (2 << 8)));
+		REG_WRITE(ah, AR_PHY_65NM_CH1_BB3,
+			  ((REG_READ(ah, AR_PHY_65NM_CH1_BB3) & 0xfffffcff) | (2 << 8)));
+		REG_WRITE(ah, AR_PHY_65NM_CH2_BB3,
+			  ((REG_READ(ah, AR_PHY_65NM_CH2_BB3) & 0xfffffcff) | (2 << 8)));
+
+		temp = REG_READ(ah, AR_PHY_65NM_CH0_BB3);
+		dc_off_ch0_i2 = (temp >> 26) & 0x1f;
+		dc_off_ch0_q2 = (temp >> 21) & 0x1f;
+
+		temp = REG_READ(ah, AR_PHY_65NM_CH1_BB3);
+		dc_off_ch1_i2 = (temp >> 26) & 0x1f;
+		dc_off_ch1_q2 = (temp >> 21) & 0x1f;
+
+		temp = REG_READ(ah, AR_PHY_65NM_CH2_BB3);
+		dc_off_ch2_i2 = (temp >> 26) & 0x1f;
+		dc_off_ch2_q2 = (temp >> 21) & 0x1f;
+
+		/*
+		 * Loopback.
+		 */
+		REG_WRITE(ah, AR_PHY_65NM_CH0_BB3,
+			  ((REG_READ(ah, AR_PHY_65NM_CH0_BB3) & 0xfffffcff) | (3 << 8)));
+		REG_WRITE(ah, AR_PHY_65NM_CH1_BB3,
+			  ((REG_READ(ah, AR_PHY_65NM_CH1_BB3) & 0xfffffcff) | (3 << 8)));
+		REG_WRITE(ah, AR_PHY_65NM_CH2_BB3,
+			  ((REG_READ(ah, AR_PHY_65NM_CH2_BB3) & 0xfffffcff) | (3 << 8)));
+
+		temp = REG_READ(ah, AR_PHY_65NM_CH0_BB3);
+		dc_off_ch0_i3 = (temp >> 26) & 0x1f;
+		dc_off_ch0_q3 = (temp >> 21) & 0x1f;
+
+		temp = REG_READ(ah, AR_PHY_65NM_CH1_BB3);
+		dc_off_ch1_i3 = (temp >> 26) & 0x1f;
+		dc_off_ch1_q3 = (temp >> 21) & 0x1f;
+
+		temp = REG_READ(ah, AR_PHY_65NM_CH2_BB3);
+		dc_off_ch2_i3 = (temp >> 26) & 0x1f;
+		dc_off_ch2_q3 = (temp >> 21) & 0x1f;
+
+		if ((dc_off_ch0_i1 > OFF_UPPER_LT) || (dc_off_ch0_i1 < OFF_LOWER_LT) ||
+		    (dc_off_ch0_i2 > OFF_UPPER_LT) || (dc_off_ch0_i2 < OFF_LOWER_LT) ||
+		    (dc_off_ch0_i3 > OFF_UPPER_LT) || (dc_off_ch0_i3 < OFF_LOWER_LT) ||
+		    (dc_off_ch0_q1 > OFF_UPPER_LT) || (dc_off_ch0_q1 < OFF_LOWER_LT) ||
+		    (dc_off_ch0_q2 > OFF_UPPER_LT) || (dc_off_ch0_q2 < OFF_LOWER_LT) ||
+		    (dc_off_ch0_q3 > OFF_UPPER_LT) || (dc_off_ch0_q3 < OFF_LOWER_LT)) {
+			if (osdac_ch0 == 3) {
+				ch0_done = 1;
+			} else {
+				osdac_ch0++;
+
+				val = REG_READ(ah, AR_PHY_65NM_CH0_BB1) & 0x3fffffff;
+				val |= (osdac_ch0 << 30);
+				REG_WRITE(ah, AR_PHY_65NM_CH0_BB1, val);
+
+				ch0_done = 0;
+			}
+		} else {
+			ch0_done = 1;
+		}
+
+		if ((dc_off_ch1_i1 > OFF_UPPER_LT) || (dc_off_ch1_i1 < OFF_LOWER_LT) ||
+		    (dc_off_ch1_i2 > OFF_UPPER_LT) || (dc_off_ch1_i2 < OFF_LOWER_LT) ||
+		    (dc_off_ch1_i3 > OFF_UPPER_LT) || (dc_off_ch1_i3 < OFF_LOWER_LT) ||
+		    (dc_off_ch1_q1 > OFF_UPPER_LT) || (dc_off_ch1_q1 < OFF_LOWER_LT) ||
+		    (dc_off_ch1_q2 > OFF_UPPER_LT) || (dc_off_ch1_q2 < OFF_LOWER_LT) ||
+		    (dc_off_ch1_q3 > OFF_UPPER_LT) || (dc_off_ch1_q3 < OFF_LOWER_LT)) {
+			if (osdac_ch1 == 3) {
+				ch1_done = 1;
+			} else {
+				osdac_ch1++;
+
+				val = REG_READ(ah, AR_PHY_65NM_CH1_BB1) & 0x3fffffff;
+				val |= (osdac_ch1 << 30);
+				REG_WRITE(ah, AR_PHY_65NM_CH1_BB1, val);
+
+				ch1_done = 0;
+			}
+		} else {
+			ch1_done = 1;
+		}
+
+		if ((dc_off_ch2_i1 > OFF_UPPER_LT) || (dc_off_ch2_i1 < OFF_LOWER_LT) ||
+		    (dc_off_ch2_i2 > OFF_UPPER_LT) || (dc_off_ch2_i2 < OFF_LOWER_LT) ||
+		    (dc_off_ch2_i3 > OFF_UPPER_LT) || (dc_off_ch2_i3 < OFF_LOWER_LT) ||
+		    (dc_off_ch2_q1 > OFF_UPPER_LT) || (dc_off_ch2_q1 < OFF_LOWER_LT) ||
+		    (dc_off_ch2_q2 > OFF_UPPER_LT) || (dc_off_ch2_q2 < OFF_LOWER_LT) ||
+		    (dc_off_ch2_q3 > OFF_UPPER_LT) || (dc_off_ch2_q3 < OFF_LOWER_LT)) {
+			if (osdac_ch2 == 3) {
+				ch2_done = 1;
+			} else {
+				osdac_ch2++;
+
+				val = REG_READ(ah, AR_PHY_65NM_CH2_BB1) & 0x3fffffff;
+				val |= (osdac_ch2 << 30);
+				REG_WRITE(ah, AR_PHY_65NM_CH2_BB1, val);
+
+				ch2_done = 0;
+			}
+		} else {
+			ch2_done = 1;
+		}
+	}
+
+	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_OFFSET_CAL);
+	REG_SET_BIT(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+
+	/*
+	 * We don't need to check txiqcal_done here since it is always
+	 * set for AR9550.
+	 */
+	REG_SET_BIT(ah, AR_PHY_TX_IQCAL_CONTROL_0,
+		    AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL);
+
+	return true;
+}
+
 /*
  * solve 4x4 linear equation used in loopback iq cal.
  */
@@ -1271,6 +1489,11 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 		REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
 	}
 
+	if (AR_SREV_9550(ah) && IS_CHAN_2GHZ(chan)) {
+		if (!ar9003_hw_dynamic_osdac_selection(ah, txiqcal_done))
+			return false;
+	}
+
 skip_tx_iqcal:
 	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
 		if (AR_SREV_9330_11(ah))
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 94a8598..5076715 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -670,6 +670,16 @@
 #define AR_PHY_65NM_CH1_RXTX4       0x1650c
 #define AR_PHY_65NM_CH2_RXTX4       0x1690c
 
+#define AR_PHY_65NM_CH0_BB1         0x16140
+#define AR_PHY_65NM_CH0_BB2         0x16144
+#define AR_PHY_65NM_CH0_BB3         0x16148
+#define AR_PHY_65NM_CH1_BB1         0x16540
+#define AR_PHY_65NM_CH1_BB2         0x16544
+#define AR_PHY_65NM_CH1_BB3         0x16548
+#define AR_PHY_65NM_CH2_BB1         0x16940
+#define AR_PHY_65NM_CH2_BB2         0x16944
+#define AR_PHY_65NM_CH2_BB3         0x16948
+
 #define AR_PHY_65NM_CH0_SYNTH12_VREFMUL3           0x00780000
 #define AR_PHY_65NM_CH0_SYNTH12_VREFMUL3_S         19
 #define AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK         0x00000004
-- 
1.8.5.2


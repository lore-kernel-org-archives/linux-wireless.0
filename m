Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30613 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab0DEJSM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Apr 2010 05:18:12 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 05 Apr 2010 02:18:11 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath9k: Add support for newer AR9285 chipsets.
Date: Mon, 5 Apr 2010 14:48:04 +0530
Message-ID: <1270459086-2504-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for a modified newer version of AR9285
chipsets.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c    |   59 +++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.c       |   29 ++++++--
 drivers/net/wireless/ath/ath9k/initvals.h |  109 +++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/phy.h      |   14 +++-
 drivers/net/wireless/ath/ath9k/reg.h      |   13 +++-
 5 files changed, 201 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index d5026e4..064f5b5 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -18,6 +18,7 @@
 
 /* We can tune this as we go by monitoring really low values */
 #define ATH9K_NF_TOO_LOW	-60
+#define AR9285_CLCAL_REDO_THRESH    1
 
 /* AR5416 may return very high value (like -31 dBm), in those cases the nf
  * is incorrect and we should use the static NF value. Later we can try to
@@ -1091,7 +1092,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 EXPORT_SYMBOL(ath9k_hw_calibrate);
 
 /* Carrier leakage Calibration fix */
-static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
+static bool ar9285_cl_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
@@ -1132,6 +1133,62 @@ static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 	return true;
 }
 
+static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	int i;
+	u_int32_t txgain_max;
+	u_int32_t clc_gain, gain_mask = 0, clc_num = 0;
+	u_int32_t reg_clc_I0, reg_clc_Q0;
+	u_int32_t i0_num = 0;
+	u_int32_t q0_num = 0;
+	u_int32_t total_num = 0;
+	u_int32_t reg_rf2g5_org;
+	bool retv = true;
+
+	if (!(ar9285_cl_cal(ah, chan)))
+		return false;
+
+	txgain_max = MS(REG_READ(ah, AR_PHY_TX_PWRCTRL7),
+			AR_PHY_TX_PWRCTRL_TX_GAIN_TAB_MAX);
+
+	for (i = 0; i < (txgain_max+1); i++) {
+		clc_gain = (REG_READ(ah, (AR_PHY_TX_GAIN_TBL1+(i<<2))) &
+			   AR_PHY_TX_GAIN_CLC) >> AR_PHY_TX_GAIN_CLC_S;
+		if (!(gain_mask & (1 << clc_gain))) {
+			gain_mask |= (1 << clc_gain);
+			clc_num++;
+		}
+	}
+
+	for (i = 0; i < clc_num; i++) {
+		reg_clc_I0 = (REG_READ(ah, (AR_PHY_CLC_TBL1 + (i << 2)))
+			      & AR_PHY_CLC_I0) >> AR_PHY_CLC_I0_S;
+		reg_clc_Q0 = (REG_READ(ah, (AR_PHY_CLC_TBL1 + (i << 2)))
+			      & AR_PHY_CLC_Q0) >> AR_PHY_CLC_Q0_S;
+		if (reg_clc_I0 == 0)
+			i0_num++;
+
+		if (reg_clc_Q0 == 0)
+			q0_num++;
+	}
+	total_num = i0_num + q0_num;
+	if (total_num > AR9285_CLCAL_REDO_THRESH) {
+		reg_rf2g5_org = REG_READ(ah, AR9285_RF2G5);
+		if (AR_SREV_9285E_20(ah)) {
+			REG_WRITE(ah, AR9285_RF2G5,
+				  (reg_rf2g5_org & AR9285_RF2G5_IC50TX) |
+				  AR9285_RF2G5_IC50TX_XE_SET);
+		} else {
+			REG_WRITE(ah, AR9285_RF2G5,
+				  (reg_rf2g5_org & AR9285_RF2G5_IC50TX) |
+				  AR9285_RF2G5_IC50TX_SET);
+		}
+		retv = ar9285_cl_cal(ah, chan);
+		REG_WRITE(ah, AR9285_RF2G5, reg_rf2g5_org);
+	}
+	return retv;
+}
+
 bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 77db932..a4826d5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -816,15 +816,30 @@ static void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
 
 		/* txgain table */
 		if (txgain_type == AR5416_EEP_TXGAIN_HIGH_POWER) {
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9285Modes_high_power_tx_gain_9285_1_2,
-			ARRAY_SIZE(ar9285Modes_high_power_tx_gain_9285_1_2), 6);
+			if (AR_SREV_9285E_20(ah)) {
+				INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9285Modes_XE2_0_high_power,
+				ARRAY_SIZE(
+				  ar9285Modes_XE2_0_high_power), 6);
+			} else {
+				INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9285Modes_high_power_tx_gain_9285_1_2,
+				ARRAY_SIZE(
+				  ar9285Modes_high_power_tx_gain_9285_1_2), 6);
+			}
 		} else {
-			INIT_INI_ARRAY(&ah->iniModesTxGain,
-			ar9285Modes_original_tx_gain_9285_1_2,
-			ARRAY_SIZE(ar9285Modes_original_tx_gain_9285_1_2), 6);
+			if (AR_SREV_9285E_20(ah)) {
+				INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9285Modes_XE2_0_normal_power,
+				ARRAY_SIZE(
+				  ar9285Modes_XE2_0_normal_power), 6);
+			} else {
+				INIT_INI_ARRAY(&ah->iniModesTxGain,
+				ar9285Modes_original_tx_gain_9285_1_2,
+				ARRAY_SIZE(
+				  ar9285Modes_original_tx_gain_9285_1_2), 6);
+			}
 		}
-
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/initvals.h b/drivers/net/wireless/ath/ath9k/initvals.h
index 177bdeb..455e9d3 100644
--- a/drivers/net/wireless/ath/ath9k/initvals.h
+++ b/drivers/net/wireless/ath/ath9k/initvals.h
@@ -4184,7 +4184,7 @@ static const u_int32_t ar9285Modes_9285_1_2[][6] = {
     { 0x00009a44, 0x00000000, 0x00000000, 0x000581a8, 0x000581a8, 0x00000000 },
     { 0x00009a48, 0x00000000, 0x00000000, 0x00058284, 0x00058284, 0x00000000 },
     { 0x00009a4c, 0x00000000, 0x00000000, 0x00058288, 0x00058288, 0x00000000 },
-    { 0x00009a50, 0x00000000, 0x00000000, 0x00058220, 0x00058220, 0x00000000 },
+    { 0x00009a50, 0x00000000, 0x00000000, 0x00058224, 0x00058224, 0x00000000 },
     { 0x00009a54, 0x00000000, 0x00000000, 0x00058290, 0x00058290, 0x00000000 },
     { 0x00009a58, 0x00000000, 0x00000000, 0x00058300, 0x00058300, 0x00000000 },
     { 0x00009a5c, 0x00000000, 0x00000000, 0x00058304, 0x00058304, 0x00000000 },
@@ -4198,8 +4198,8 @@ static const u_int32_t ar9285Modes_9285_1_2[][6] = {
     { 0x00009a7c, 0x00000000, 0x00000000, 0x0006870c, 0x0006870c, 0x00000000 },
     { 0x00009a80, 0x00000000, 0x00000000, 0x00068780, 0x00068780, 0x00000000 },
     { 0x00009a84, 0x00000000, 0x00000000, 0x00068784, 0x00068784, 0x00000000 },
-    { 0x00009a88, 0x00000000, 0x00000000, 0x00078b04, 0x00078b04, 0x00000000 },
-    { 0x00009a8c, 0x00000000, 0x00000000, 0x00078b08, 0x00078b08, 0x00000000 },
+    { 0x00009a88, 0x00000000, 0x00000000, 0x00078b00, 0x00078b00, 0x00000000 },
+    { 0x00009a8c, 0x00000000, 0x00000000, 0x00078b04, 0x00078b04, 0x00000000 },
     { 0x00009a90, 0x00000000, 0x00000000, 0x00078b08, 0x00078b08, 0x00000000 },
     { 0x00009a94, 0x00000000, 0x00000000, 0x00078b0c, 0x00078b0c, 0x00000000 },
     { 0x00009a98, 0x00000000, 0x00000000, 0x00078b80, 0x00078b80, 0x00000000 },
@@ -4312,7 +4312,7 @@ static const u_int32_t ar9285Modes_9285_1_2[][6] = {
     { 0x0000aa44, 0x00000000, 0x00000000, 0x000581a8, 0x000581a8, 0x00000000 },
     { 0x0000aa48, 0x00000000, 0x00000000, 0x00058284, 0x00058284, 0x00000000 },
     { 0x0000aa4c, 0x00000000, 0x00000000, 0x00058288, 0x00058288, 0x00000000 },
-    { 0x0000aa50, 0x00000000, 0x00000000, 0x00058220, 0x00058220, 0x00000000 },
+    { 0x0000aa50, 0x00000000, 0x00000000, 0x00058224, 0x00058224, 0x00000000 },
     { 0x0000aa54, 0x00000000, 0x00000000, 0x00058290, 0x00058290, 0x00000000 },
     { 0x0000aa58, 0x00000000, 0x00000000, 0x00058300, 0x00058300, 0x00000000 },
     { 0x0000aa5c, 0x00000000, 0x00000000, 0x00058304, 0x00058304, 0x00000000 },
@@ -4326,8 +4326,8 @@ static const u_int32_t ar9285Modes_9285_1_2[][6] = {
     { 0x0000aa7c, 0x00000000, 0x00000000, 0x0006870c, 0x0006870c, 0x00000000 },
     { 0x0000aa80, 0x00000000, 0x00000000, 0x00068780, 0x00068780, 0x00000000 },
     { 0x0000aa84, 0x00000000, 0x00000000, 0x00068784, 0x00068784, 0x00000000 },
-    { 0x0000aa88, 0x00000000, 0x00000000, 0x00078b04, 0x00078b04, 0x00000000 },
-    { 0x0000aa8c, 0x00000000, 0x00000000, 0x00078b08, 0x00078b08, 0x00000000 },
+    { 0x0000aa88, 0x00000000, 0x00000000, 0x00078b00, 0x00078b00, 0x00000000 },
+    { 0x0000aa8c, 0x00000000, 0x00000000, 0x00078b04, 0x00078b04, 0x00000000 },
     { 0x0000aa90, 0x00000000, 0x00000000, 0x00078b08, 0x00078b08, 0x00000000 },
     { 0x0000aa94, 0x00000000, 0x00000000, 0x00078b0c, 0x00078b0c, 0x00000000 },
     { 0x0000aa98, 0x00000000, 0x00000000, 0x00078b80, 0x00078b80, 0x00000000 },
@@ -4731,17 +4731,12 @@ static const u_int32_t ar9285Common_9285_1_2[][2] = {
     { 0x00007808, 0x54214514 },
     { 0x0000780c, 0x02025830 },
     { 0x00007810, 0x71c0d388 },
-    { 0x00007814, 0x924934a8 },
     { 0x0000781c, 0x00000000 },
     { 0x00007824, 0x00d86fff },
-    { 0x00007828, 0x26d2491b },
     { 0x0000782c, 0x6e36d97b },
-    { 0x00007830, 0xedb6d96e },
     { 0x00007834, 0x71400087 },
-    { 0x0000783c, 0x0001fffe },
-    { 0x00007840, 0xffeb1a20 },
     { 0x00007844, 0x000c0db6 },
-    { 0x00007848, 0x6db61b6f },
+    { 0x00007848, 0x6db6246f },
     { 0x0000784c, 0x6d9b66db },
     { 0x00007850, 0x6d8c6dba },
     { 0x00007854, 0x00040000 },
@@ -4777,7 +4772,12 @@ static const u_int32_t ar9285Modes_high_power_tx_gain_9285_1_2[][6] = {
     { 0x0000a34c, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
     { 0x0000a350, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
     { 0x0000a354, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x00007814, 0x924934a8, 0x924934a8, 0x924934a8, 0x924934a8, 0x924934a8 },
+    { 0x00007828, 0x26d2491b, 0x26d2491b, 0x26d2491b, 0x26d2491b, 0x26d2491b },
+    { 0x00007830, 0xedb6d96e, 0xedb6d96e, 0xedb6d96e, 0xedb6d96e, 0xedb6d96e },
     { 0x00007838, 0xfac68803, 0xfac68803, 0xfac68803, 0xfac68803, 0xfac68803 },
+    { 0x0000783c, 0x0001fffe, 0x0001fffe, 0x0001fffe, 0x0001fffe, 0x0001fffe },
+    { 0x00007840, 0xffeb1a20, 0xffeb1a20, 0xffeb1a20, 0xffeb1a20, 0xffeb1a20 },
     { 0x0000786c, 0x08609ebe, 0x08609ebe, 0x08609ebe, 0x08609ebe, 0x08609ebe },
     { 0x00007820, 0x00000c00, 0x00000c00, 0x00000c00, 0x00000c00, 0x00000c00 },
     { 0x0000a274, 0x0a22a652, 0x0a22a652, 0x0a216652, 0x0a216652, 0x0a22a652 },
@@ -4813,7 +4813,12 @@ static const u_int32_t ar9285Modes_original_tx_gain_9285_1_2[][6] = {
     { 0x0000a34c, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
     { 0x0000a350, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
     { 0x0000a354, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x00007814, 0x924934a8, 0x924934a8, 0x924934a8, 0x924934a8, 0x924934a8 },
+    { 0x00007828, 0x26d2491b, 0x26d2491b, 0x26d2491b, 0x26d2491b, 0x26d2491b },
+    { 0x00007830, 0xedb6d96e, 0xedb6d96e, 0xedb6d96e, 0xedb6d96e, 0xedb6d96e },
     { 0x00007838, 0xfac68801, 0xfac68801, 0xfac68801, 0xfac68801, 0xfac68801 },
+    { 0x0000783c, 0x0001fffe, 0x0001fffe, 0x0001fffe, 0x0001fffe, 0x0001fffe },
+    { 0x00007840, 0xffeb1a20, 0xffeb1a20, 0xffeb1a20, 0xffeb1a20, 0xffeb1a20 },
     { 0x0000786c, 0x48609eb4, 0x48609eb4, 0x48609eb4, 0x48609eb4, 0x48609eb4 },
     { 0x00007820, 0x00000c04, 0x00000c04, 0x00000c04, 0x00000c04, 0x00000c04 },
     { 0x0000a274, 0x0a21c652, 0x0a21c652, 0x0a21a652, 0x0a21a652, 0x0a22a652 },
@@ -4825,6 +4830,86 @@ static const u_int32_t ar9285Modes_original_tx_gain_9285_1_2[][6] = {
     { 0x0000a3e0, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c },
 };
 
+static const u_int32_t ar9285Modes_XE2_0_normal_power[][6] = {
+    { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
+    { 0x0000a304, 0x00000000, 0x00000000, 0x00009200, 0x00009200, 0x00000000 },
+    { 0x0000a308, 0x00000000, 0x00000000, 0x00010208, 0x00010208, 0x00000000 },
+    { 0x0000a30c, 0x00000000, 0x00000000, 0x00019608, 0x00019608, 0x00000000 },
+    { 0x0000a310, 0x00000000, 0x00000000, 0x00022618, 0x00022618, 0x00000000 },
+    { 0x0000a314, 0x00000000, 0x00000000, 0x0002a6c9, 0x0002a6c9, 0x00000000 },
+    { 0x0000a318, 0x00000000, 0x00000000, 0x00031710, 0x00031710, 0x00000000 },
+    { 0x0000a31c, 0x00000000, 0x00000000, 0x00035718, 0x00035718, 0x00000000 },
+    { 0x0000a320, 0x00000000, 0x00000000, 0x00038758, 0x00038758, 0x00000000 },
+    { 0x0000a324, 0x00000000, 0x00000000, 0x0003c75a, 0x0003c75a, 0x00000000 },
+    { 0x0000a328, 0x00000000, 0x00000000, 0x0004075c, 0x0004075c, 0x00000000 },
+    { 0x0000a32c, 0x00000000, 0x00000000, 0x0004475e, 0x0004475e, 0x00000000 },
+    { 0x0000a330, 0x00000000, 0x00000000, 0x0004679f, 0x0004679f, 0x00000000 },
+    { 0x0000a334, 0x00000000, 0x00000000, 0x000487df, 0x000487df, 0x00000000 },
+    { 0x0000a338, 0x0003891e, 0x0003891e, 0x0003891e, 0x0003891e, 0x00000000 },
+    { 0x0000a33c, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x00000000 },
+    { 0x0000a340, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a344, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a348, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a34c, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a350, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a354, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x00007814, 0x92497ca8, 0x92497ca8, 0x92497ca8, 0x92497ca8, 0x92497ca8 },
+    { 0x00007828, 0x4ad2491b, 0x4ad2491b, 0x2ad2491b, 0x4ad2491b, 0x4ad2491b },
+    { 0x00007830, 0xedb6da6e, 0xedb6da6e, 0xedb6da6e, 0xedb6da6e, 0xedb6dbae },
+    { 0x00007838, 0xdac71441, 0xdac71441, 0xdac71441, 0xdac71441, 0xdac71441 },
+    { 0x0000783c, 0x2481f6fe, 0x2481f6fe, 0x2481f6fe, 0x2481f6fe, 0x2481f6fe },
+    { 0x00007840, 0xba5f638c, 0xba5f638c, 0xba5f638c, 0xba5f638c, 0xba5f638c },
+    { 0x0000786c, 0x48609eb4, 0x48609eb4, 0x48609eb4, 0x48609eb4, 0x48609eb4 },
+    { 0x00007820, 0x00000c04, 0x00000c04, 0x00000c04, 0x00000c04, 0x00000c04 },
+    { 0x0000a274, 0x0a21c652, 0x0a21c652, 0x0a21a652, 0x0a21a652, 0x0a22a652 },
+    { 0x0000a278, 0x39ce739c, 0x39ce739c, 0x39ce739c, 0x39ce739c, 0x39ce739c },
+    { 0x0000a27c, 0x050e039c, 0x050e039c, 0x050e039c, 0x050e039c, 0x050e039c },
+    { 0x0000a394, 0x39ce739c, 0x39ce739c, 0x39ce739c, 0x39ce739c, 0x39ce739c },
+    { 0x0000a398, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c },
+    { 0x0000a3dc, 0x39ce739c, 0x39ce739c, 0x39ce739c, 0x39ce739c, 0x39ce739c },
+    { 0x0000a3e0, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c, 0x0000039c },
+};
+
+static const u_int32_t ar9285Modes_XE2_0_high_power[][6] = {
+    { 0x0000a300, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 },
+    { 0x0000a304, 0x00000000, 0x00000000, 0x00006200, 0x00006200, 0x00000000 },
+    { 0x0000a308, 0x00000000, 0x00000000, 0x00008201, 0x00008201, 0x00000000 },
+    { 0x0000a30c, 0x00000000, 0x00000000, 0x0000b240, 0x0000b240, 0x00000000 },
+    { 0x0000a310, 0x00000000, 0x00000000, 0x0000d241, 0x0000d241, 0x00000000 },
+    { 0x0000a314, 0x00000000, 0x00000000, 0x0000f600, 0x0000f600, 0x00000000 },
+    { 0x0000a318, 0x00000000, 0x00000000, 0x00012800, 0x00012800, 0x00000000 },
+    { 0x0000a31c, 0x00000000, 0x00000000, 0x00016802, 0x00016802, 0x00000000 },
+    { 0x0000a320, 0x00000000, 0x00000000, 0x0001b805, 0x0001b805, 0x00000000 },
+    { 0x0000a324, 0x00000000, 0x00000000, 0x00021a80, 0x00021a80, 0x00000000 },
+    { 0x0000a328, 0x00000000, 0x00000000, 0x00028b00, 0x00028b00, 0x00000000 },
+    { 0x0000a32c, 0x00000000, 0x00000000, 0x0002ab40, 0x0002ab40, 0x00000000 },
+    { 0x0000a330, 0x00000000, 0x00000000, 0x0002cd80, 0x0002cd80, 0x00000000 },
+    { 0x0000a334, 0x00000000, 0x00000000, 0x00033d82, 0x00033d82, 0x00000000 },
+    { 0x0000a338, 0x0003891e, 0x0003891e, 0x0003891e, 0x0003891e, 0x00000000 },
+    { 0x0000a33c, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x0003a95e, 0x00000000 },
+    { 0x0000a340, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a344, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a348, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a34c, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a350, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x0000a354, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x0003e9df, 0x00000000 },
+    { 0x00007814, 0x92497ca8, 0x92497ca8, 0x92497ca8, 0x92497ca8, 0x92497ca8 },
+    { 0x00007828, 0x4ad2491b, 0x4ad2491b, 0x2ad2491b, 0x4ad2491b, 0x4ad2491b },
+    { 0x00007830, 0xedb6da6e, 0xedb6da6e, 0xedb6da6e, 0xedb6da6e, 0xedb6da6e },
+    { 0x00007838, 0xdac71443, 0xdac71443, 0xdac71443, 0xdac71443, 0xdac71443 },
+    { 0x0000783c, 0x2481f6fe, 0x2481f6fe, 0x2481f6fe, 0x2481f6fe, 0x2481f6fe },
+    { 0x00007840, 0xba5f638c, 0xba5f638c, 0xba5f638c, 0xba5f638c, 0xba5f638c },
+    { 0x0000786c, 0x08609ebe, 0x08609ebe, 0x08609ebe, 0x08609ebe, 0x08609ebe },
+    { 0x00007820, 0x00000c00, 0x00000c00, 0x00000c00, 0x00000c00, 0x00000c00 },
+    { 0x0000a274, 0x0a22a652, 0x0a22a652, 0x0a216652, 0x0a216652, 0x0a22a652 },
+    { 0x0000a278, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7 },
+    { 0x0000a27c, 0x050380e7, 0x050380e7, 0x050380e7, 0x050380e7, 0x050380e7 },
+    { 0x0000a394, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7 },
+    { 0x0000a398, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7 },
+    { 0x0000a3dc, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7, 0x0e739ce7 },
+    { 0x0000a3e0, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7, 0x000000e7 },
+};
+
 static const u_int32_t ar9285PciePhy_clkreq_always_on_L1_9285_1_2[][2] = {
     {0x00004040,  0x9248fd00 },
     {0x00004040,  0x24924924 },
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 0999a49..0132e4c 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -503,6 +503,8 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
 #define AR_PHY_TX_PWRCTRL_ERR_EST_MODE_S   24
 
 #define AR_PHY_TX_PWRCTRL7       0xa274
+#define AR_PHY_TX_PWRCTRL_TX_GAIN_TAB_MAX   0x0007E000
+#define AR_PHY_TX_PWRCTRL_TX_GAIN_TAB_MAX_S 13
 #define AR_PHY_TX_PWRCTRL_INIT_TX_GAIN     0x01F80000
 #define AR_PHY_TX_PWRCTRL_INIT_TX_GAIN_S   19
 
@@ -513,8 +515,16 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
 #define AR_PHY_TX_PWRCTRL9_RES_DC_REMOVAL_S 31
 
 #define AR_PHY_TX_GAIN_TBL1      0xa300
-#define AR_PHY_TX_GAIN                     0x0007F000
-#define AR_PHY_TX_GAIN_S                   12
+#define AR_PHY_TX_GAIN_CLC       0x0000001E
+#define AR_PHY_TX_GAIN_CLC_S     1
+#define AR_PHY_TX_GAIN           0x0007F000
+#define AR_PHY_TX_GAIN_S         12
+
+#define AR_PHY_CLC_TBL1      0xa35c
+#define AR_PHY_CLC_I0        0x07ff0000
+#define AR_PHY_CLC_I0_S      16
+#define AR_PHY_CLC_Q0        0x0000ffd0
+#define AR_PHY_CLC_Q0_S      5
 
 #define AR_PHY_CH0_TX_PWRCTRL11  0xa398
 #define AR_PHY_CH1_TX_PWRCTRL11  0xb398
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 198e41d..7e36ad7 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -679,7 +679,7 @@
 
 #define AR_WA                		0x4004
 #define AR_WA_D3_L1_DISABLE		(1 << 14)
-#define AR9285_WA_DEFAULT 		0x004a05cb
+#define AR9285_WA_DEFAULT		0x004a050b
 #define AR9280_WA_DEFAULT           	0x0040073b
 #define AR_WA_DEFAULT               	0x0000073f
 
@@ -845,6 +845,10 @@
     (AR_SREV_9271(_ah) && \
      ((_ah)->hw_version.macRev == AR_SREV_REVISION_9271_11))
 
+#define AR_SREV_9285E_20(_ah) \
+    (AR_SREV_9285_12_OR_LATER(_ah) && \
+     ((REG_READ(_ah, AR_AN_SYNTH9) & 0x7) == 0x1))
+
 #define AR_RADIO_SREV_MAJOR                   0xf0
 #define AR_RAD5133_SREV_MAJOR                 0xc0
 #define AR_RAD2133_SREV_MAJOR                 0xd0
@@ -1181,6 +1185,13 @@ enum {
 #define AR9285_AN_RF2G4_DB2_4    0x00003800
 #define AR9285_AN_RF2G4_DB2_4_S    11
 
+#define AR9285_RF2G5			0x7830
+#define AR9285_RF2G5_IC50TX		0xfffff8ff
+#define AR9285_RF2G5_IC50TX_SET		0x00000400
+#define AR9285_RF2G5_IC50TX_XE_SET	0x00000500
+#define AR9285_RF2G5_IC50TX_CLEAR	0x00000700
+#define AR9285_RF2G5_IC50TX_CLEAR_S	8
+
 /* AR9271 : 0x7828, 0x782c different setting from AR9285 */
 #define AR9271_AN_RF2G3_OB_cck		0x001C0000
 #define AR9271_AN_RF2G3_OB_cck_S	18
-- 
1.7.0.3


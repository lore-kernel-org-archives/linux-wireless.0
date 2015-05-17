Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:61823 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbbEQTti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 15:49:38 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] ath9k: split ar5008_hw_spur_mitigate and reuse common code in ar9002_hw_spur_mitigate.
Date: Sun, 17 May 2015 21:49:19 +0200
Message-Id: <1431892159-7563-1-git-send-email-linux@rempel-privat.de> (sfid-20150517_214940_924838_5C55CE69)
In-Reply-To: <5556D95E.40706@openwrt.org>
References: <5556D95E.40706@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ar5008 and ar9002]_hw_spur_mitigate have big portion of identical code.
This patch will move common part of ar5008_hw_spur_mitigate to
ar5008_hw_cmn_spur_mitigate and reuse it in ar9002_hw_spur_mitigate.

As noticed by Joe Perches I reuse ar9002_hw_spur_mitigate (const) version of
declarations for pilot_mask_reg and chan_mask_reg.

There should be no other difference with original code.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 155 +++++++++++++++-------------
 drivers/net/wireless/ath/ath9k/ar9002_phy.c | 144 +-------------------------
 drivers/net/wireless/ath/ath9k/hw.h         |   2 +
 3 files changed, 87 insertions(+), 214 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 6c23d27..8f87930 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -254,86 +254,25 @@ static int ar5008_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	return 0;
 }
 
-/**
- * ar5008_hw_spur_mitigate - convert baseband spur frequency for external radios
- * @ah: atheros hardware structure
- * @chan:
- *
- * For non single-chip solutions. Converts to baseband spur frequency given the
- * input channel frequency and compute register settings below.
- */
-static void ar5008_hw_spur_mitigate(struct ath_hw *ah,
-				    struct ath9k_channel *chan)
+void ar5008_hw_cmn_spur_mitigate(struct ath_hw *ah,
+			  struct ath9k_channel *chan, int bin)
 {
-	int bb_spur = AR_NO_SPUR;
-	int bin, cur_bin;
-	int spur_freq_sd;
-	int spur_delta_phase;
-	int denominator;
+	int cur_bin;
 	int upper, lower, cur_vit_mask;
-	int tmp, new;
 	int i;
-	static int pilot_mask_reg[4] = {
+	int8_t mask_m[123];
+	int8_t mask_p[123];
+	int8_t mask_amt;
+	int tmp_mask;
+	static const int pilot_mask_reg[4] = {
 		AR_PHY_TIMING7, AR_PHY_TIMING8,
 		AR_PHY_PILOT_MASK_01_30, AR_PHY_PILOT_MASK_31_60
 	};
-	static int chan_mask_reg[4] = {
+	static const int chan_mask_reg[4] = {
 		AR_PHY_TIMING9, AR_PHY_TIMING10,
 		AR_PHY_CHANNEL_MASK_01_30, AR_PHY_CHANNEL_MASK_31_60
 	};
-	static int inc[4] = { 0, 100, 0, 0 };
-
-	int8_t mask_m[123];
-	int8_t mask_p[123];
-	int8_t mask_amt;
-	int tmp_mask;
-	int cur_bb_spur;
-	bool is2GHz = IS_CHAN_2GHZ(chan);
-
-	memset(&mask_m, 0, sizeof(int8_t) * 123);
-	memset(&mask_p, 0, sizeof(int8_t) * 123);
-
-	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
-		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);
-		if (AR_NO_SPUR == cur_bb_spur)
-			break;
-		cur_bb_spur = cur_bb_spur - (chan->channel * 10);
-		if ((cur_bb_spur > -95) && (cur_bb_spur < 95)) {
-			bb_spur = cur_bb_spur;
-			break;
-		}
-	}
-
-	if (AR_NO_SPUR == bb_spur)
-		return;
-
-	bin = bb_spur * 32;
-
-	tmp = REG_READ(ah, AR_PHY_TIMING_CTRL4(0));
-	new = tmp | (AR_PHY_TIMING_CTRL4_ENABLE_SPUR_RSSI |
-		     AR_PHY_TIMING_CTRL4_ENABLE_SPUR_FILTER |
-		     AR_PHY_TIMING_CTRL4_ENABLE_CHAN_MASK |
-		     AR_PHY_TIMING_CTRL4_ENABLE_PILOT_MASK);
-
-	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0), new);
-
-	new = (AR_PHY_SPUR_REG_MASK_RATE_CNTL |
-	       AR_PHY_SPUR_REG_ENABLE_MASK_PPM |
-	       AR_PHY_SPUR_REG_MASK_RATE_SELECT |
-	       AR_PHY_SPUR_REG_ENABLE_VIT_SPUR_RSSI |
-	       SM(SPUR_RSSI_THRESH, AR_PHY_SPUR_REG_SPUR_RSSI_THRESH));
-	REG_WRITE(ah, AR_PHY_SPUR_REG, new);
-
-	spur_delta_phase = ((bb_spur * 524288) / 100) &
-		AR_PHY_TIMING11_SPUR_DELTA_PHASE;
-
-	denominator = IS_CHAN_2GHZ(chan) ? 440 : 400;
-	spur_freq_sd = ((bb_spur * 2048) / denominator) & 0x3ff;
-
-	new = (AR_PHY_TIMING11_USE_SPUR_IN_AGC |
-	       SM(spur_freq_sd, AR_PHY_TIMING11_SPUR_FREQ_SD) |
-	       SM(spur_delta_phase, AR_PHY_TIMING11_SPUR_DELTA_PHASE));
-	REG_WRITE(ah, AR_PHY_TIMING11, new);
+	static const int inc[4] = { 0, 100, 0, 0 };
 
 	cur_bin = -6000;
 	upper = bin + 100;
@@ -343,6 +282,7 @@ static void ar5008_hw_spur_mitigate(struct ath_hw *ah,
 		int pilot_mask = 0;
 		int chan_mask = 0;
 		int bp = 0;
+
 		for (bp = 0; bp < 30; bp++) {
 			if ((cur_bin > lower) && (cur_bin < upper)) {
 				pilot_mask = pilot_mask | 0x1 << bp;
@@ -361,7 +301,6 @@ static void ar5008_hw_spur_mitigate(struct ath_hw *ah,
 
 	for (i = 0; i < 123; i++) {
 		if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
-
 			/* workaround for gcc bug #37014 */
 			volatile int tmp_v = abs(cur_vit_mask - bin);
 
@@ -467,6 +406,78 @@ static void ar5008_hw_spur_mitigate(struct ath_hw *ah,
 }
 
 /**
+ * ar5008_hw_spur_mitigate - convert baseband spur frequency for external radios
+ * @ah: atheros hardware structure
+ * @chan:
+ *
+ * For non single-chip solutions. Converts to baseband spur frequency given the
+ * input channel frequency and compute register settings below.
+ */
+static void ar5008_hw_spur_mitigate(struct ath_hw *ah,
+				    struct ath9k_channel *chan)
+{
+	int bb_spur = AR_NO_SPUR;
+	int bin;
+	int spur_freq_sd;
+	int spur_delta_phase;
+	int denominator;
+	int tmp, new;
+	int i;
+
+	int8_t mask_m[123];
+	int8_t mask_p[123];
+	int cur_bb_spur;
+	bool is2GHz = IS_CHAN_2GHZ(chan);
+
+	memset(&mask_m, 0, sizeof(int8_t) * 123);
+	memset(&mask_p, 0, sizeof(int8_t) * 123);
+
+	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
+		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);
+		if (AR_NO_SPUR == cur_bb_spur)
+			break;
+		cur_bb_spur = cur_bb_spur - (chan->channel * 10);
+		if ((cur_bb_spur > -95) && (cur_bb_spur < 95)) {
+			bb_spur = cur_bb_spur;
+			break;
+		}
+	}
+
+	if (AR_NO_SPUR == bb_spur)
+		return;
+
+	bin = bb_spur * 32;
+
+	tmp = REG_READ(ah, AR_PHY_TIMING_CTRL4(0));
+	new = tmp | (AR_PHY_TIMING_CTRL4_ENABLE_SPUR_RSSI |
+		     AR_PHY_TIMING_CTRL4_ENABLE_SPUR_FILTER |
+		     AR_PHY_TIMING_CTRL4_ENABLE_CHAN_MASK |
+		     AR_PHY_TIMING_CTRL4_ENABLE_PILOT_MASK);
+
+	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0), new);
+
+	new = (AR_PHY_SPUR_REG_MASK_RATE_CNTL |
+	       AR_PHY_SPUR_REG_ENABLE_MASK_PPM |
+	       AR_PHY_SPUR_REG_MASK_RATE_SELECT |
+	       AR_PHY_SPUR_REG_ENABLE_VIT_SPUR_RSSI |
+	       SM(SPUR_RSSI_THRESH, AR_PHY_SPUR_REG_SPUR_RSSI_THRESH));
+	REG_WRITE(ah, AR_PHY_SPUR_REG, new);
+
+	spur_delta_phase = ((bb_spur * 524288) / 100) &
+		AR_PHY_TIMING11_SPUR_DELTA_PHASE;
+
+	denominator = IS_CHAN_2GHZ(chan) ? 440 : 400;
+	spur_freq_sd = ((bb_spur * 2048) / denominator) & 0x3ff;
+
+	new = (AR_PHY_TIMING11_USE_SPUR_IN_AGC |
+	       SM(spur_freq_sd, AR_PHY_TIMING11_SPUR_FREQ_SD) |
+	       SM(spur_delta_phase, AR_PHY_TIMING11_SPUR_DELTA_PHASE));
+	REG_WRITE(ah, AR_PHY_TIMING11, new);
+
+	ar5008_hw_cmn_spur_mitigate(ah, chan, bin);
+}
+
+/**
  * ar5008_hw_rf_alloc_ext_banks - allocates banks for external radio programming
  * @ah: atheros hardware structure
  *
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index fc08162..db66245 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -169,29 +169,17 @@ static void ar9002_hw_spur_mitigate(struct ath_hw *ah,
 {
 	int bb_spur = AR_NO_SPUR;
 	int freq;
-	int bin, cur_bin;
+	int bin;
 	int bb_spur_off, spur_subchannel_sd;
 	int spur_freq_sd;
 	int spur_delta_phase;
 	int denominator;
-	int upper, lower, cur_vit_mask;
 	int tmp, newVal;
 	int i;
-	static const int pilot_mask_reg[4] = {
-		AR_PHY_TIMING7, AR_PHY_TIMING8,
-		AR_PHY_PILOT_MASK_01_30, AR_PHY_PILOT_MASK_31_60
-	};
-	static const int chan_mask_reg[4] = {
-		AR_PHY_TIMING9, AR_PHY_TIMING10,
-		AR_PHY_CHANNEL_MASK_01_30, AR_PHY_CHANNEL_MASK_31_60
-	};
-	static const int inc[4] = { 0, 100, 0, 0 };
 	struct chan_centers centers;
 
 	int8_t mask_m[123];
 	int8_t mask_p[123];
-	int8_t mask_amt;
-	int tmp_mask;
 	int cur_bb_spur;
 	bool is2GHz = IS_CHAN_2GHZ(chan);
 
@@ -288,135 +276,7 @@ static void ar9002_hw_spur_mitigate(struct ath_hw *ah,
 	newVal = spur_subchannel_sd << AR_PHY_SFCORR_SPUR_SUBCHNL_SD_S;
 	REG_WRITE(ah, AR_PHY_SFCORR_EXT, newVal);
 
-	cur_bin = -6000;
-	upper = bin + 100;
-	lower = bin - 100;
-
-	for (i = 0; i < 4; i++) {
-		int pilot_mask = 0;
-		int chan_mask = 0;
-		int bp = 0;
-		for (bp = 0; bp < 30; bp++) {
-			if ((cur_bin > lower) && (cur_bin < upper)) {
-				pilot_mask = pilot_mask | 0x1 << bp;
-				chan_mask = chan_mask | 0x1 << bp;
-			}
-			cur_bin += 100;
-		}
-		cur_bin += inc[i];
-		REG_WRITE(ah, pilot_mask_reg[i], pilot_mask);
-		REG_WRITE(ah, chan_mask_reg[i], chan_mask);
-	}
-
-	cur_vit_mask = 6100;
-	upper = bin + 120;
-	lower = bin - 120;
-
-	for (i = 0; i < 123; i++) {
-		if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
-
-			/* workaround for gcc bug #37014 */
-			volatile int tmp_v = abs(cur_vit_mask - bin);
-
-			if (tmp_v < 75)
-				mask_amt = 1;
-			else
-				mask_amt = 0;
-			if (cur_vit_mask < 0)
-				mask_m[abs(cur_vit_mask / 100)] = mask_amt;
-			else
-				mask_p[cur_vit_mask / 100] = mask_amt;
-		}
-		cur_vit_mask -= 100;
-	}
-
-	tmp_mask = (mask_m[46] << 30) | (mask_m[47] << 28)
-		| (mask_m[48] << 26) | (mask_m[49] << 24)
-		| (mask_m[50] << 22) | (mask_m[51] << 20)
-		| (mask_m[52] << 18) | (mask_m[53] << 16)
-		| (mask_m[54] << 14) | (mask_m[55] << 12)
-		| (mask_m[56] << 10) | (mask_m[57] << 8)
-		| (mask_m[58] << 6) | (mask_m[59] << 4)
-		| (mask_m[60] << 2) | (mask_m[61] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK_1, tmp_mask);
-	REG_WRITE(ah, AR_PHY_VIT_MASK2_M_46_61, tmp_mask);
-
-	tmp_mask = (mask_m[31] << 28)
-		| (mask_m[32] << 26) | (mask_m[33] << 24)
-		| (mask_m[34] << 22) | (mask_m[35] << 20)
-		| (mask_m[36] << 18) | (mask_m[37] << 16)
-		| (mask_m[48] << 14) | (mask_m[39] << 12)
-		| (mask_m[40] << 10) | (mask_m[41] << 8)
-		| (mask_m[42] << 6) | (mask_m[43] << 4)
-		| (mask_m[44] << 2) | (mask_m[45] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK_2, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_M_31_45, tmp_mask);
-
-	tmp_mask = (mask_m[16] << 30) | (mask_m[16] << 28)
-		| (mask_m[18] << 26) | (mask_m[18] << 24)
-		| (mask_m[20] << 22) | (mask_m[20] << 20)
-		| (mask_m[22] << 18) | (mask_m[22] << 16)
-		| (mask_m[24] << 14) | (mask_m[24] << 12)
-		| (mask_m[25] << 10) | (mask_m[26] << 8)
-		| (mask_m[27] << 6) | (mask_m[28] << 4)
-		| (mask_m[29] << 2) | (mask_m[30] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK_3, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_M_16_30, tmp_mask);
-
-	tmp_mask = (mask_m[0] << 30) | (mask_m[1] << 28)
-		| (mask_m[2] << 26) | (mask_m[3] << 24)
-		| (mask_m[4] << 22) | (mask_m[5] << 20)
-		| (mask_m[6] << 18) | (mask_m[7] << 16)
-		| (mask_m[8] << 14) | (mask_m[9] << 12)
-		| (mask_m[10] << 10) | (mask_m[11] << 8)
-		| (mask_m[12] << 6) | (mask_m[13] << 4)
-		| (mask_m[14] << 2) | (mask_m[15] << 0);
-	REG_WRITE(ah, AR_PHY_MASK_CTL, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_M_00_15, tmp_mask);
-
-	tmp_mask = (mask_p[15] << 28)
-		| (mask_p[14] << 26) | (mask_p[13] << 24)
-		| (mask_p[12] << 22) | (mask_p[11] << 20)
-		| (mask_p[10] << 18) | (mask_p[9] << 16)
-		| (mask_p[8] << 14) | (mask_p[7] << 12)
-		| (mask_p[6] << 10) | (mask_p[5] << 8)
-		| (mask_p[4] << 6) | (mask_p[3] << 4)
-		| (mask_p[2] << 2) | (mask_p[1] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK2_1, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_P_15_01, tmp_mask);
-
-	tmp_mask = (mask_p[30] << 28)
-		| (mask_p[29] << 26) | (mask_p[28] << 24)
-		| (mask_p[27] << 22) | (mask_p[26] << 20)
-		| (mask_p[25] << 18) | (mask_p[24] << 16)
-		| (mask_p[23] << 14) | (mask_p[22] << 12)
-		| (mask_p[21] << 10) | (mask_p[20] << 8)
-		| (mask_p[19] << 6) | (mask_p[18] << 4)
-		| (mask_p[17] << 2) | (mask_p[16] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK2_2, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_P_30_16, tmp_mask);
-
-	tmp_mask = (mask_p[45] << 28)
-		| (mask_p[44] << 26) | (mask_p[43] << 24)
-		| (mask_p[42] << 22) | (mask_p[41] << 20)
-		| (mask_p[40] << 18) | (mask_p[39] << 16)
-		| (mask_p[38] << 14) | (mask_p[37] << 12)
-		| (mask_p[36] << 10) | (mask_p[35] << 8)
-		| (mask_p[34] << 6) | (mask_p[33] << 4)
-		| (mask_p[32] << 2) | (mask_p[31] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK2_3, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_P_45_31, tmp_mask);
-
-	tmp_mask = (mask_p[61] << 30) | (mask_p[60] << 28)
-		| (mask_p[59] << 26) | (mask_p[58] << 24)
-		| (mask_p[57] << 22) | (mask_p[56] << 20)
-		| (mask_p[55] << 18) | (mask_p[54] << 16)
-		| (mask_p[53] << 14) | (mask_p[52] << 12)
-		| (mask_p[51] << 10) | (mask_p[50] << 8)
-		| (mask_p[49] << 6) | (mask_p[48] << 4)
-		| (mask_p[47] << 2) | (mask_p[46] << 0);
-	REG_WRITE(ah, AR_PHY_BIN_MASK2_4, tmp_mask);
-	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
+	ar5008_hw_cmn_spur_mitigate(ah, chan, bin);
 
 	REGWRITE_BUFFER_FLUSH(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c1d2d03..e8454db 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1119,6 +1119,8 @@ bool ar9003_is_paprd_enabled(struct ath_hw *ah);
 void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx);
 void ar9003_hw_init_rate_txpower(struct ath_hw *ah, u8 *rate_array,
 				 struct ath9k_channel *chan);
+void ar5008_hw_cmn_spur_mitigate(struct ath_hw *ah,
+				 struct ath9k_channel *chan, int bin);
 void ar5008_hw_init_rate_txpower(struct ath_hw *ah, int16_t *rate_array,
 				 struct ath9k_channel *chan, int ht40_delta);
 
-- 
1.9.1


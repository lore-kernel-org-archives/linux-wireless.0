Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54698 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 11/15] ath9k_hw: order phy.c code and integrate spur mitigation
Date: Mon, 19 Oct 2009 02:33:42 -0400
Message-Id: <1255934026-20686-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reorders phy.c routines in the order in the order in which they are used
and also moves the spur mitigation helpers for each type of chip into phy.c
as they are RF related.

This patch has no functional changes.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |  453 --------------------
 drivers/net/wireless/ath/ath9k/phy.c |  779 +++++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/phy.h |   19 +-
 3 files changed, 637 insertions(+), 614 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e0d696d..68f5bbc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -30,8 +30,6 @@ static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan);
 static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
 			      struct ar5416_eeprom_def *pEepData,
 			      u32 reg, u32 value);
-static void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
-static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
 
 MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Support for Atheros 802.11n wireless LAN cards.");
@@ -1929,457 +1927,6 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	return true;
 }
 
-static void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	int bb_spur = AR_NO_SPUR;
-	int freq;
-	int bin, cur_bin;
-	int bb_spur_off, spur_subchannel_sd;
-	int spur_freq_sd;
-	int spur_delta_phase;
-	int denominator;
-	int upper, lower, cur_vit_mask;
-	int tmp, newVal;
-	int i;
-	int pilot_mask_reg[4] = { AR_PHY_TIMING7, AR_PHY_TIMING8,
-			  AR_PHY_PILOT_MASK_01_30, AR_PHY_PILOT_MASK_31_60
-	};
-	int chan_mask_reg[4] = { AR_PHY_TIMING9, AR_PHY_TIMING10,
-			 AR_PHY_CHANNEL_MASK_01_30, AR_PHY_CHANNEL_MASK_31_60
-	};
-	int inc[4] = { 0, 100, 0, 0 };
-	struct chan_centers centers;
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
-	ath9k_hw_get_channel_centers(ah, chan, &centers);
-	freq = centers.synth_center;
-
-	ah->config.spurmode = SPUR_ENABLE_EEPROM;
-	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
-		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);
-
-		if (is2GHz)
-			cur_bb_spur = (cur_bb_spur / 10) + AR_BASE_FREQ_2GHZ;
-		else
-			cur_bb_spur = (cur_bb_spur / 10) + AR_BASE_FREQ_5GHZ;
-
-		if (AR_NO_SPUR == cur_bb_spur)
-			break;
-		cur_bb_spur = cur_bb_spur - freq;
-
-		if (IS_CHAN_HT40(chan)) {
-			if ((cur_bb_spur > -AR_SPUR_FEEQ_BOUND_HT40) &&
-			    (cur_bb_spur < AR_SPUR_FEEQ_BOUND_HT40)) {
-				bb_spur = cur_bb_spur;
-				break;
-			}
-		} else if ((cur_bb_spur > -AR_SPUR_FEEQ_BOUND_HT20) &&
-			   (cur_bb_spur < AR_SPUR_FEEQ_BOUND_HT20)) {
-			bb_spur = cur_bb_spur;
-			break;
-		}
-	}
-
-	if (AR_NO_SPUR == bb_spur) {
-		REG_CLR_BIT(ah, AR_PHY_FORCE_CLKEN_CCK,
-			    AR_PHY_FORCE_CLKEN_CCK_MRC_MUX);
-		return;
-	} else {
-		REG_CLR_BIT(ah, AR_PHY_FORCE_CLKEN_CCK,
-			    AR_PHY_FORCE_CLKEN_CCK_MRC_MUX);
-	}
-
-	bin = bb_spur * 320;
-
-	tmp = REG_READ(ah, AR_PHY_TIMING_CTRL4(0));
-
-	newVal = tmp | (AR_PHY_TIMING_CTRL4_ENABLE_SPUR_RSSI |
-			AR_PHY_TIMING_CTRL4_ENABLE_SPUR_FILTER |
-			AR_PHY_TIMING_CTRL4_ENABLE_CHAN_MASK |
-			AR_PHY_TIMING_CTRL4_ENABLE_PILOT_MASK);
-	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0), newVal);
-
-	newVal = (AR_PHY_SPUR_REG_MASK_RATE_CNTL |
-		  AR_PHY_SPUR_REG_ENABLE_MASK_PPM |
-		  AR_PHY_SPUR_REG_MASK_RATE_SELECT |
-		  AR_PHY_SPUR_REG_ENABLE_VIT_SPUR_RSSI |
-		  SM(SPUR_RSSI_THRESH, AR_PHY_SPUR_REG_SPUR_RSSI_THRESH));
-	REG_WRITE(ah, AR_PHY_SPUR_REG, newVal);
-
-	if (IS_CHAN_HT40(chan)) {
-		if (bb_spur < 0) {
-			spur_subchannel_sd = 1;
-			bb_spur_off = bb_spur + 10;
-		} else {
-			spur_subchannel_sd = 0;
-			bb_spur_off = bb_spur - 10;
-		}
-	} else {
-		spur_subchannel_sd = 0;
-		bb_spur_off = bb_spur;
-	}
-
-	if (IS_CHAN_HT40(chan))
-		spur_delta_phase =
-			((bb_spur * 262144) /
-			 10) & AR_PHY_TIMING11_SPUR_DELTA_PHASE;
-	else
-		spur_delta_phase =
-			((bb_spur * 524288) /
-			 10) & AR_PHY_TIMING11_SPUR_DELTA_PHASE;
-
-	denominator = IS_CHAN_2GHZ(chan) ? 44 : 40;
-	spur_freq_sd = ((bb_spur_off * 2048) / denominator) & 0x3ff;
-
-	newVal = (AR_PHY_TIMING11_USE_SPUR_IN_AGC |
-		  SM(spur_freq_sd, AR_PHY_TIMING11_SPUR_FREQ_SD) |
-		  SM(spur_delta_phase, AR_PHY_TIMING11_SPUR_DELTA_PHASE));
-	REG_WRITE(ah, AR_PHY_TIMING11, newVal);
-
-	newVal = spur_subchannel_sd << AR_PHY_SFCORR_SPUR_SUBCHNL_SD_S;
-	REG_WRITE(ah, AR_PHY_SFCORR_EXT, newVal);
-
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
-}
-
-static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	int bb_spur = AR_NO_SPUR;
-	int bin, cur_bin;
-	int spur_freq_sd;
-	int spur_delta_phase;
-	int denominator;
-	int upper, lower, cur_vit_mask;
-	int tmp, new;
-	int i;
-	int pilot_mask_reg[4] = { AR_PHY_TIMING7, AR_PHY_TIMING8,
-			  AR_PHY_PILOT_MASK_01_30, AR_PHY_PILOT_MASK_31_60
-	};
-	int chan_mask_reg[4] = { AR_PHY_TIMING9, AR_PHY_TIMING10,
-			 AR_PHY_CHANNEL_MASK_01_30, AR_PHY_CHANNEL_MASK_31_60
-	};
-	int inc[4] = { 0, 100, 0, 0 };
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
-
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
-}
-
 static void ath9k_enable_rfkill(struct ath_hw *ah)
 {
 	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index bfcb9af..8e4c3bd 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -52,96 +52,13 @@
  * Used for both the chipsets with an external AR2133/AR5133 radios and
  * single-chip devices.
  */
-void
-ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex, u32 freqIndex,
-		    int regWrites)
+void ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex,
+			 u32 freqIndex, int regWrites)
 {
 	REG_WRITE_ARRAY(&ah->iniBB_RfGain, freqIndex, regWrites);
 }
 
 /**
- * ath9k_hw_set_channel - tune to a channel on the external AR2133/AR5133 radios
- * @ah: atheros hardware stucture
- * @chan:
- *
- * For the external AR2133/AR5133 radios, takes the MHz channel value and set
- * the channel value. Assumes writes enabled to analog bus and bank6 register
- * cache in ah->analogBank6Data.
- */
-int ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 channelSel = 0;
-	u32 bModeSynth = 0;
-	u32 aModeRefSel = 0;
-	u32 reg32 = 0;
-	u16 freq;
-	struct chan_centers centers;
-
-	ath9k_hw_get_channel_centers(ah, chan, &centers);
-	freq = centers.synth_center;
-
-	if (freq < 4800) {
-		u32 txctl;
-
-		if (((freq - 2192) % 5) == 0) {
-			channelSel = ((freq - 672) * 2 - 3040) / 10;
-			bModeSynth = 0;
-		} else if (((freq - 2224) % 5) == 0) {
-			channelSel = ((freq - 704) * 2 - 3040) / 10;
-			bModeSynth = 1;
-		} else {
-			ath_print(common, ATH_DBG_FATAL,
-				  "Invalid channel %u MHz\n", freq);
-			return -EINVAL;
-		}
-
-		channelSel = (channelSel << 2) & 0xff;
-		channelSel = ath9k_hw_reverse_bits(channelSel, 8);
-
-		txctl = REG_READ(ah, AR_PHY_CCK_TX_CTRL);
-		if (freq == 2484) {
-
-			REG_WRITE(ah, AR_PHY_CCK_TX_CTRL,
-				  txctl | AR_PHY_CCK_TX_CTRL_JAPAN);
-		} else {
-			REG_WRITE(ah, AR_PHY_CCK_TX_CTRL,
-				  txctl & ~AR_PHY_CCK_TX_CTRL_JAPAN);
-		}
-
-	} else if ((freq % 20) == 0 && freq >= 5120) {
-		channelSel =
-		    ath9k_hw_reverse_bits(((freq - 4800) / 20 << 2), 8);
-		aModeRefSel = ath9k_hw_reverse_bits(1, 2);
-	} else if ((freq % 10) == 0) {
-		channelSel =
-		    ath9k_hw_reverse_bits(((freq - 4800) / 10 << 1), 8);
-		if (AR_SREV_9100(ah) || AR_SREV_9160_10_OR_LATER(ah))
-			aModeRefSel = ath9k_hw_reverse_bits(2, 2);
-		else
-			aModeRefSel = ath9k_hw_reverse_bits(1, 2);
-	} else if ((freq % 5) == 0) {
-		channelSel = ath9k_hw_reverse_bits((freq - 4800) / 5, 8);
-		aModeRefSel = ath9k_hw_reverse_bits(1, 2);
-	} else {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Invalid channel %u MHz\n", freq);
-		return -EINVAL;
-	}
-
-	reg32 =
-	    (channelSel << 8) | (aModeRefSel << 2) | (bModeSynth << 1) |
-	    (1 << 5) | 0x1;
-
-	REG_WRITE(ah, AR_PHY(0x37), reg32);
-
-	ah->curchan = chan;
-	ah->curchan_rad_index = -1;
-
-	return 0;
-}
-
-/**
  * ath9k_hw_ar9280_set_channel - set channel on single-chip device
  * @ah: atheros hardware structure
  * @chan:
@@ -255,6 +172,622 @@ int ath9k_hw_ar9280_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 }
 
 /**
+ * ath9k_hw_9280_spur_mitigate - convert baseband spur frequency
+ * @ah: atheros hardware structure
+ * @chan:
+ *
+ * For single-chip solutions. Converts to baseband spur frequency given the
+ * input channel frequency and compute register settings below.
+ */
+void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	int bb_spur = AR_NO_SPUR;
+	int freq;
+	int bin, cur_bin;
+	int bb_spur_off, spur_subchannel_sd;
+	int spur_freq_sd;
+	int spur_delta_phase;
+	int denominator;
+	int upper, lower, cur_vit_mask;
+	int tmp, newVal;
+	int i;
+	int pilot_mask_reg[4] = { AR_PHY_TIMING7, AR_PHY_TIMING8,
+			  AR_PHY_PILOT_MASK_01_30, AR_PHY_PILOT_MASK_31_60
+	};
+	int chan_mask_reg[4] = { AR_PHY_TIMING9, AR_PHY_TIMING10,
+			 AR_PHY_CHANNEL_MASK_01_30, AR_PHY_CHANNEL_MASK_31_60
+	};
+	int inc[4] = { 0, 100, 0, 0 };
+	struct chan_centers centers;
+
+	int8_t mask_m[123];
+	int8_t mask_p[123];
+	int8_t mask_amt;
+	int tmp_mask;
+	int cur_bb_spur;
+	bool is2GHz = IS_CHAN_2GHZ(chan);
+
+	memset(&mask_m, 0, sizeof(int8_t) * 123);
+	memset(&mask_p, 0, sizeof(int8_t) * 123);
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+	freq = centers.synth_center;
+
+	ah->config.spurmode = SPUR_ENABLE_EEPROM;
+	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
+		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);
+
+		if (is2GHz)
+			cur_bb_spur = (cur_bb_spur / 10) + AR_BASE_FREQ_2GHZ;
+		else
+			cur_bb_spur = (cur_bb_spur / 10) + AR_BASE_FREQ_5GHZ;
+
+		if (AR_NO_SPUR == cur_bb_spur)
+			break;
+		cur_bb_spur = cur_bb_spur - freq;
+
+		if (IS_CHAN_HT40(chan)) {
+			if ((cur_bb_spur > -AR_SPUR_FEEQ_BOUND_HT40) &&
+			    (cur_bb_spur < AR_SPUR_FEEQ_BOUND_HT40)) {
+				bb_spur = cur_bb_spur;
+				break;
+			}
+		} else if ((cur_bb_spur > -AR_SPUR_FEEQ_BOUND_HT20) &&
+			   (cur_bb_spur < AR_SPUR_FEEQ_BOUND_HT20)) {
+			bb_spur = cur_bb_spur;
+			break;
+		}
+	}
+
+	if (AR_NO_SPUR == bb_spur) {
+		REG_CLR_BIT(ah, AR_PHY_FORCE_CLKEN_CCK,
+			    AR_PHY_FORCE_CLKEN_CCK_MRC_MUX);
+		return;
+	} else {
+		REG_CLR_BIT(ah, AR_PHY_FORCE_CLKEN_CCK,
+			    AR_PHY_FORCE_CLKEN_CCK_MRC_MUX);
+	}
+
+	bin = bb_spur * 320;
+
+	tmp = REG_READ(ah, AR_PHY_TIMING_CTRL4(0));
+
+	newVal = tmp | (AR_PHY_TIMING_CTRL4_ENABLE_SPUR_RSSI |
+			AR_PHY_TIMING_CTRL4_ENABLE_SPUR_FILTER |
+			AR_PHY_TIMING_CTRL4_ENABLE_CHAN_MASK |
+			AR_PHY_TIMING_CTRL4_ENABLE_PILOT_MASK);
+	REG_WRITE(ah, AR_PHY_TIMING_CTRL4(0), newVal);
+
+	newVal = (AR_PHY_SPUR_REG_MASK_RATE_CNTL |
+		  AR_PHY_SPUR_REG_ENABLE_MASK_PPM |
+		  AR_PHY_SPUR_REG_MASK_RATE_SELECT |
+		  AR_PHY_SPUR_REG_ENABLE_VIT_SPUR_RSSI |
+		  SM(SPUR_RSSI_THRESH, AR_PHY_SPUR_REG_SPUR_RSSI_THRESH));
+	REG_WRITE(ah, AR_PHY_SPUR_REG, newVal);
+
+	if (IS_CHAN_HT40(chan)) {
+		if (bb_spur < 0) {
+			spur_subchannel_sd = 1;
+			bb_spur_off = bb_spur + 10;
+		} else {
+			spur_subchannel_sd = 0;
+			bb_spur_off = bb_spur - 10;
+		}
+	} else {
+		spur_subchannel_sd = 0;
+		bb_spur_off = bb_spur;
+	}
+
+	if (IS_CHAN_HT40(chan))
+		spur_delta_phase =
+			((bb_spur * 262144) /
+			 10) & AR_PHY_TIMING11_SPUR_DELTA_PHASE;
+	else
+		spur_delta_phase =
+			((bb_spur * 524288) /
+			 10) & AR_PHY_TIMING11_SPUR_DELTA_PHASE;
+
+	denominator = IS_CHAN_2GHZ(chan) ? 44 : 40;
+	spur_freq_sd = ((bb_spur_off * 2048) / denominator) & 0x3ff;
+
+	newVal = (AR_PHY_TIMING11_USE_SPUR_IN_AGC |
+		  SM(spur_freq_sd, AR_PHY_TIMING11_SPUR_FREQ_SD) |
+		  SM(spur_delta_phase, AR_PHY_TIMING11_SPUR_DELTA_PHASE));
+	REG_WRITE(ah, AR_PHY_TIMING11, newVal);
+
+	newVal = spur_subchannel_sd << AR_PHY_SFCORR_SPUR_SUBCHNL_SD_S;
+	REG_WRITE(ah, AR_PHY_SFCORR_EXT, newVal);
+
+	cur_bin = -6000;
+	upper = bin + 100;
+	lower = bin - 100;
+
+	for (i = 0; i < 4; i++) {
+		int pilot_mask = 0;
+		int chan_mask = 0;
+		int bp = 0;
+		for (bp = 0; bp < 30; bp++) {
+			if ((cur_bin > lower) && (cur_bin < upper)) {
+				pilot_mask = pilot_mask | 0x1 << bp;
+				chan_mask = chan_mask | 0x1 << bp;
+			}
+			cur_bin += 100;
+		}
+		cur_bin += inc[i];
+		REG_WRITE(ah, pilot_mask_reg[i], pilot_mask);
+		REG_WRITE(ah, chan_mask_reg[i], chan_mask);
+	}
+
+	cur_vit_mask = 6100;
+	upper = bin + 120;
+	lower = bin - 120;
+
+	for (i = 0; i < 123; i++) {
+		if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
+
+			/* workaround for gcc bug #37014 */
+			volatile int tmp_v = abs(cur_vit_mask - bin);
+
+			if (tmp_v < 75)
+				mask_amt = 1;
+			else
+				mask_amt = 0;
+			if (cur_vit_mask < 0)
+				mask_m[abs(cur_vit_mask / 100)] = mask_amt;
+			else
+				mask_p[cur_vit_mask / 100] = mask_amt;
+		}
+		cur_vit_mask -= 100;
+	}
+
+	tmp_mask = (mask_m[46] << 30) | (mask_m[47] << 28)
+		| (mask_m[48] << 26) | (mask_m[49] << 24)
+		| (mask_m[50] << 22) | (mask_m[51] << 20)
+		| (mask_m[52] << 18) | (mask_m[53] << 16)
+		| (mask_m[54] << 14) | (mask_m[55] << 12)
+		| (mask_m[56] << 10) | (mask_m[57] << 8)
+		| (mask_m[58] << 6) | (mask_m[59] << 4)
+		| (mask_m[60] << 2) | (mask_m[61] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK_1, tmp_mask);
+	REG_WRITE(ah, AR_PHY_VIT_MASK2_M_46_61, tmp_mask);
+
+	tmp_mask = (mask_m[31] << 28)
+		| (mask_m[32] << 26) | (mask_m[33] << 24)
+		| (mask_m[34] << 22) | (mask_m[35] << 20)
+		| (mask_m[36] << 18) | (mask_m[37] << 16)
+		| (mask_m[48] << 14) | (mask_m[39] << 12)
+		| (mask_m[40] << 10) | (mask_m[41] << 8)
+		| (mask_m[42] << 6) | (mask_m[43] << 4)
+		| (mask_m[44] << 2) | (mask_m[45] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK_2, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_M_31_45, tmp_mask);
+
+	tmp_mask = (mask_m[16] << 30) | (mask_m[16] << 28)
+		| (mask_m[18] << 26) | (mask_m[18] << 24)
+		| (mask_m[20] << 22) | (mask_m[20] << 20)
+		| (mask_m[22] << 18) | (mask_m[22] << 16)
+		| (mask_m[24] << 14) | (mask_m[24] << 12)
+		| (mask_m[25] << 10) | (mask_m[26] << 8)
+		| (mask_m[27] << 6) | (mask_m[28] << 4)
+		| (mask_m[29] << 2) | (mask_m[30] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK_3, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_M_16_30, tmp_mask);
+
+	tmp_mask = (mask_m[0] << 30) | (mask_m[1] << 28)
+		| (mask_m[2] << 26) | (mask_m[3] << 24)
+		| (mask_m[4] << 22) | (mask_m[5] << 20)
+		| (mask_m[6] << 18) | (mask_m[7] << 16)
+		| (mask_m[8] << 14) | (mask_m[9] << 12)
+		| (mask_m[10] << 10) | (mask_m[11] << 8)
+		| (mask_m[12] << 6) | (mask_m[13] << 4)
+		| (mask_m[14] << 2) | (mask_m[15] << 0);
+	REG_WRITE(ah, AR_PHY_MASK_CTL, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_M_00_15, tmp_mask);
+
+	tmp_mask = (mask_p[15] << 28)
+		| (mask_p[14] << 26) | (mask_p[13] << 24)
+		| (mask_p[12] << 22) | (mask_p[11] << 20)
+		| (mask_p[10] << 18) | (mask_p[9] << 16)
+		| (mask_p[8] << 14) | (mask_p[7] << 12)
+		| (mask_p[6] << 10) | (mask_p[5] << 8)
+		| (mask_p[4] << 6) | (mask_p[3] << 4)
+		| (mask_p[2] << 2) | (mask_p[1] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_1, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_15_01, tmp_mask);
+
+	tmp_mask = (mask_p[30] << 28)
+		| (mask_p[29] << 26) | (mask_p[28] << 24)
+		| (mask_p[27] << 22) | (mask_p[26] << 20)
+		| (mask_p[25] << 18) | (mask_p[24] << 16)
+		| (mask_p[23] << 14) | (mask_p[22] << 12)
+		| (mask_p[21] << 10) | (mask_p[20] << 8)
+		| (mask_p[19] << 6) | (mask_p[18] << 4)
+		| (mask_p[17] << 2) | (mask_p[16] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_2, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_30_16, tmp_mask);
+
+	tmp_mask = (mask_p[45] << 28)
+		| (mask_p[44] << 26) | (mask_p[43] << 24)
+		| (mask_p[42] << 22) | (mask_p[41] << 20)
+		| (mask_p[40] << 18) | (mask_p[39] << 16)
+		| (mask_p[38] << 14) | (mask_p[37] << 12)
+		| (mask_p[36] << 10) | (mask_p[35] << 8)
+		| (mask_p[34] << 6) | (mask_p[33] << 4)
+		| (mask_p[32] << 2) | (mask_p[31] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_3, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_45_31, tmp_mask);
+
+	tmp_mask = (mask_p[61] << 30) | (mask_p[60] << 28)
+		| (mask_p[59] << 26) | (mask_p[58] << 24)
+		| (mask_p[57] << 22) | (mask_p[56] << 20)
+		| (mask_p[55] << 18) | (mask_p[54] << 16)
+		| (mask_p[53] << 14) | (mask_p[52] << 12)
+		| (mask_p[51] << 10) | (mask_p[50] << 8)
+		| (mask_p[49] << 6) | (mask_p[48] << 4)
+		| (mask_p[47] << 2) | (mask_p[46] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_4, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
+}
+
+/* All code below is for non single-chip solutions */
+
+/**
+ * ath9k_hw_set_channel - tune to a channel on the external AR2133/AR5133 radios
+ * @ah: atheros hardware stucture
+ * @chan:
+ *
+ * For the external AR2133/AR5133 radios, takes the MHz channel value and set
+ * the channel value. Assumes writes enabled to analog bus and bank6 register
+ * cache in ah->analogBank6Data.
+ */
+int ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 channelSel = 0;
+	u32 bModeSynth = 0;
+	u32 aModeRefSel = 0;
+	u32 reg32 = 0;
+	u16 freq;
+	struct chan_centers centers;
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+	freq = centers.synth_center;
+
+	if (freq < 4800) {
+		u32 txctl;
+
+		if (((freq - 2192) % 5) == 0) {
+			channelSel = ((freq - 672) * 2 - 3040) / 10;
+			bModeSynth = 0;
+		} else if (((freq - 2224) % 5) == 0) {
+			channelSel = ((freq - 704) * 2 - 3040) / 10;
+			bModeSynth = 1;
+		} else {
+			ath_print(common, ATH_DBG_FATAL,
+				  "Invalid channel %u MHz\n", freq);
+			return -EINVAL;
+		}
+
+		channelSel = (channelSel << 2) & 0xff;
+		channelSel = ath9k_hw_reverse_bits(channelSel, 8);
+
+		txctl = REG_READ(ah, AR_PHY_CCK_TX_CTRL);
+		if (freq == 2484) {
+
+			REG_WRITE(ah, AR_PHY_CCK_TX_CTRL,
+				  txctl | AR_PHY_CCK_TX_CTRL_JAPAN);
+		} else {
+			REG_WRITE(ah, AR_PHY_CCK_TX_CTRL,
+				  txctl & ~AR_PHY_CCK_TX_CTRL_JAPAN);
+		}
+
+	} else if ((freq % 20) == 0 && freq >= 5120) {
+		channelSel =
+		    ath9k_hw_reverse_bits(((freq - 4800) / 20 << 2), 8);
+		aModeRefSel = ath9k_hw_reverse_bits(1, 2);
+	} else if ((freq % 10) == 0) {
+		channelSel =
+		    ath9k_hw_reverse_bits(((freq - 4800) / 10 << 1), 8);
+		if (AR_SREV_9100(ah) || AR_SREV_9160_10_OR_LATER(ah))
+			aModeRefSel = ath9k_hw_reverse_bits(2, 2);
+		else
+			aModeRefSel = ath9k_hw_reverse_bits(1, 2);
+	} else if ((freq % 5) == 0) {
+		channelSel = ath9k_hw_reverse_bits((freq - 4800) / 5, 8);
+		aModeRefSel = ath9k_hw_reverse_bits(1, 2);
+	} else {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Invalid channel %u MHz\n", freq);
+		return -EINVAL;
+	}
+
+	reg32 =
+	    (channelSel << 8) | (aModeRefSel << 2) | (bModeSynth << 1) |
+	    (1 << 5) | 0x1;
+
+	REG_WRITE(ah, AR_PHY(0x37), reg32);
+
+	ah->curchan = chan;
+	ah->curchan_rad_index = -1;
+
+	return 0;
+}
+
+/**
+ * ath9k_hw_spur_mitigate - convert baseband spur frequency for external radios
+ * @ah: atheros hardware structure
+ * @chan:
+ *
+ * For non single-chip solutions. Converts to baseband spur frequency given the
+ * input channel frequency and compute register settings below.
+ */
+void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	int bb_spur = AR_NO_SPUR;
+	int bin, cur_bin;
+	int spur_freq_sd;
+	int spur_delta_phase;
+	int denominator;
+	int upper, lower, cur_vit_mask;
+	int tmp, new;
+	int i;
+	int pilot_mask_reg[4] = { AR_PHY_TIMING7, AR_PHY_TIMING8,
+			  AR_PHY_PILOT_MASK_01_30, AR_PHY_PILOT_MASK_31_60
+	};
+	int chan_mask_reg[4] = { AR_PHY_TIMING9, AR_PHY_TIMING10,
+			 AR_PHY_CHANNEL_MASK_01_30, AR_PHY_CHANNEL_MASK_31_60
+	};
+	int inc[4] = { 0, 100, 0, 0 };
+
+	int8_t mask_m[123];
+	int8_t mask_p[123];
+	int8_t mask_amt;
+	int tmp_mask;
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
+	cur_bin = -6000;
+	upper = bin + 100;
+	lower = bin - 100;
+
+	for (i = 0; i < 4; i++) {
+		int pilot_mask = 0;
+		int chan_mask = 0;
+		int bp = 0;
+		for (bp = 0; bp < 30; bp++) {
+			if ((cur_bin > lower) && (cur_bin < upper)) {
+				pilot_mask = pilot_mask | 0x1 << bp;
+				chan_mask = chan_mask | 0x1 << bp;
+			}
+			cur_bin += 100;
+		}
+		cur_bin += inc[i];
+		REG_WRITE(ah, pilot_mask_reg[i], pilot_mask);
+		REG_WRITE(ah, chan_mask_reg[i], chan_mask);
+	}
+
+	cur_vit_mask = 6100;
+	upper = bin + 120;
+	lower = bin - 120;
+
+	for (i = 0; i < 123; i++) {
+		if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
+
+			/* workaround for gcc bug #37014 */
+			volatile int tmp_v = abs(cur_vit_mask - bin);
+
+			if (tmp_v < 75)
+				mask_amt = 1;
+			else
+				mask_amt = 0;
+			if (cur_vit_mask < 0)
+				mask_m[abs(cur_vit_mask / 100)] = mask_amt;
+			else
+				mask_p[cur_vit_mask / 100] = mask_amt;
+		}
+		cur_vit_mask -= 100;
+	}
+
+	tmp_mask = (mask_m[46] << 30) | (mask_m[47] << 28)
+		| (mask_m[48] << 26) | (mask_m[49] << 24)
+		| (mask_m[50] << 22) | (mask_m[51] << 20)
+		| (mask_m[52] << 18) | (mask_m[53] << 16)
+		| (mask_m[54] << 14) | (mask_m[55] << 12)
+		| (mask_m[56] << 10) | (mask_m[57] << 8)
+		| (mask_m[58] << 6) | (mask_m[59] << 4)
+		| (mask_m[60] << 2) | (mask_m[61] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK_1, tmp_mask);
+	REG_WRITE(ah, AR_PHY_VIT_MASK2_M_46_61, tmp_mask);
+
+	tmp_mask = (mask_m[31] << 28)
+		| (mask_m[32] << 26) | (mask_m[33] << 24)
+		| (mask_m[34] << 22) | (mask_m[35] << 20)
+		| (mask_m[36] << 18) | (mask_m[37] << 16)
+		| (mask_m[48] << 14) | (mask_m[39] << 12)
+		| (mask_m[40] << 10) | (mask_m[41] << 8)
+		| (mask_m[42] << 6) | (mask_m[43] << 4)
+		| (mask_m[44] << 2) | (mask_m[45] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK_2, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_M_31_45, tmp_mask);
+
+	tmp_mask = (mask_m[16] << 30) | (mask_m[16] << 28)
+		| (mask_m[18] << 26) | (mask_m[18] << 24)
+		| (mask_m[20] << 22) | (mask_m[20] << 20)
+		| (mask_m[22] << 18) | (mask_m[22] << 16)
+		| (mask_m[24] << 14) | (mask_m[24] << 12)
+		| (mask_m[25] << 10) | (mask_m[26] << 8)
+		| (mask_m[27] << 6) | (mask_m[28] << 4)
+		| (mask_m[29] << 2) | (mask_m[30] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK_3, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_M_16_30, tmp_mask);
+
+	tmp_mask = (mask_m[0] << 30) | (mask_m[1] << 28)
+		| (mask_m[2] << 26) | (mask_m[3] << 24)
+		| (mask_m[4] << 22) | (mask_m[5] << 20)
+		| (mask_m[6] << 18) | (mask_m[7] << 16)
+		| (mask_m[8] << 14) | (mask_m[9] << 12)
+		| (mask_m[10] << 10) | (mask_m[11] << 8)
+		| (mask_m[12] << 6) | (mask_m[13] << 4)
+		| (mask_m[14] << 2) | (mask_m[15] << 0);
+	REG_WRITE(ah, AR_PHY_MASK_CTL, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_M_00_15, tmp_mask);
+
+	tmp_mask = (mask_p[15] << 28)
+		| (mask_p[14] << 26) | (mask_p[13] << 24)
+		| (mask_p[12] << 22) | (mask_p[11] << 20)
+		| (mask_p[10] << 18) | (mask_p[9] << 16)
+		| (mask_p[8] << 14) | (mask_p[7] << 12)
+		| (mask_p[6] << 10) | (mask_p[5] << 8)
+		| (mask_p[4] << 6) | (mask_p[3] << 4)
+		| (mask_p[2] << 2) | (mask_p[1] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_1, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_15_01, tmp_mask);
+
+	tmp_mask = (mask_p[30] << 28)
+		| (mask_p[29] << 26) | (mask_p[28] << 24)
+		| (mask_p[27] << 22) | (mask_p[26] << 20)
+		| (mask_p[25] << 18) | (mask_p[24] << 16)
+		| (mask_p[23] << 14) | (mask_p[22] << 12)
+		| (mask_p[21] << 10) | (mask_p[20] << 8)
+		| (mask_p[19] << 6) | (mask_p[18] << 4)
+		| (mask_p[17] << 2) | (mask_p[16] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_2, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_30_16, tmp_mask);
+
+	tmp_mask = (mask_p[45] << 28)
+		| (mask_p[44] << 26) | (mask_p[43] << 24)
+		| (mask_p[42] << 22) | (mask_p[41] << 20)
+		| (mask_p[40] << 18) | (mask_p[39] << 16)
+		| (mask_p[38] << 14) | (mask_p[37] << 12)
+		| (mask_p[36] << 10) | (mask_p[35] << 8)
+		| (mask_p[34] << 6) | (mask_p[33] << 4)
+		| (mask_p[32] << 2) | (mask_p[31] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_3, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_45_31, tmp_mask);
+
+	tmp_mask = (mask_p[61] << 30) | (mask_p[60] << 28)
+		| (mask_p[59] << 26) | (mask_p[58] << 24)
+		| (mask_p[57] << 22) | (mask_p[56] << 20)
+		| (mask_p[55] << 18) | (mask_p[54] << 16)
+		| (mask_p[53] << 14) | (mask_p[52] << 12)
+		| (mask_p[51] << 10) | (mask_p[50] << 8)
+		| (mask_p[49] << 6) | (mask_p[48] << 4)
+		| (mask_p[47] << 2) | (mask_p[46] << 0);
+	REG_WRITE(ah, AR_PHY_BIN_MASK2_4, tmp_mask);
+	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
+}
+
+/**
+ * ath9k_hw_rf_alloc_ext_banks - allocates banks for external radio programming
+ * @ah: atheros hardware structure
+ *
+ * Only required for older devices with external AR2133/AR5133 radios.
+ */
+int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah)
+{
+#define ATH_ALLOC_BANK(bank, size) do { \
+		bank = kzalloc((sizeof(u32) * size), GFP_KERNEL); \
+		if (!bank) { \
+			ath_print(common, ATH_DBG_FATAL, \
+				  "Cannot allocate RF banks\n"); \
+			return -ENOMEM; \
+		} \
+	} while (0);
+
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
+
+	ATH_ALLOC_BANK(ah->analogBank0Data, ah->iniBank0.ia_rows);
+	ATH_ALLOC_BANK(ah->analogBank1Data, ah->iniBank1.ia_rows);
+	ATH_ALLOC_BANK(ah->analogBank2Data, ah->iniBank2.ia_rows);
+	ATH_ALLOC_BANK(ah->analogBank3Data, ah->iniBank3.ia_rows);
+	ATH_ALLOC_BANK(ah->analogBank6Data, ah->iniBank6.ia_rows);
+	ATH_ALLOC_BANK(ah->analogBank6TPCData, ah->iniBank6TPC.ia_rows);
+	ATH_ALLOC_BANK(ah->analogBank7Data, ah->iniBank7.ia_rows);
+	ATH_ALLOC_BANK(ah->addac5416_21,
+		       ah->iniAddac.ia_rows * ah->iniAddac.ia_columns);
+	ATH_ALLOC_BANK(ah->bank6Temp, ah->iniBank6.ia_rows);
+
+	return 0;
+#undef ATH_ALLOC_BANK
+}
+
+
+/**
+ * ath9k_hw_rf_free_ext_banks - Free memory for analog bank scratch buffers
+ * @ah: atheros hardware struture
+ * For the external AR2133/AR5133 radios banks.
+ */
+void
+ath9k_hw_rf_free_ext_banks(struct ath_hw *ah)
+{
+#define ATH_FREE_BANK(bank) do { \
+		kfree(bank); \
+		bank = NULL; \
+	} while (0);
+
+	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
+
+	ATH_FREE_BANK(ah->analogBank0Data);
+	ATH_FREE_BANK(ah->analogBank1Data);
+	ATH_FREE_BANK(ah->analogBank2Data);
+	ATH_FREE_BANK(ah->analogBank3Data);
+	ATH_FREE_BANK(ah->analogBank6Data);
+	ATH_FREE_BANK(ah->analogBank6TPCData);
+	ATH_FREE_BANK(ah->analogBank7Data);
+	ATH_FREE_BANK(ah->addac5416_21);
+	ATH_FREE_BANK(ah->bank6Temp);
+
+#undef ATH_FREE_BANK
+}
+
+/**
  * ath9k_phy_modify_rx_buffer() - perform analog swizzling of parameters
  * @rfbuf:
  * @reg32:
@@ -265,10 +798,9 @@ int ath9k_hw_ar9280_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
  * Performs analog "swizzling" of parameters into their location.
  * Used on external AR2133/AR5133 radios.
  */
-static void
-ath9k_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
-			   u32 numBits, u32 firstBit,
-			   u32 column)
+static void ath9k_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
+				       u32 numBits, u32 firstBit,
+				       u32 column)
 {
 	u32 tmp32, mask, arrayEntry, lastBit;
 	int32_t bitPosition, bitsLeft;
@@ -304,9 +836,8 @@ ath9k_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
  * all rf registers. This routine requires access to the analog
  * rf device. This is not required for single-chip devices.
  */
-bool
-ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
-		     u16 modesIndex)
+bool ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
+			  u16 modesIndex)
 {
 	u32 eepMinorRev;
 	u32 ob5GHz = 0, db5GHz = 0;
@@ -384,70 +915,6 @@ ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 }
 
 /**
- * ath9k_hw_rf_free_ext_banks - Free memory for analog bank scratch buffers
- * @ah: atheros hardware struture
- * For the external AR2133/AR5133 radios banks.
- */
-void
-ath9k_hw_rf_free_ext_banks(struct ath_hw *ah)
-{
-#define ATH_FREE_BANK(bank) do { \
-		kfree(bank); \
-		bank = NULL; \
-	} while (0);
-
-	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
-
-	ATH_FREE_BANK(ah->analogBank0Data);
-	ATH_FREE_BANK(ah->analogBank1Data);
-	ATH_FREE_BANK(ah->analogBank2Data);
-	ATH_FREE_BANK(ah->analogBank3Data);
-	ATH_FREE_BANK(ah->analogBank6Data);
-	ATH_FREE_BANK(ah->analogBank6TPCData);
-	ATH_FREE_BANK(ah->analogBank7Data);
-	ATH_FREE_BANK(ah->addac5416_21);
-	ATH_FREE_BANK(ah->bank6Temp);
-
-#undef ATH_FREE_BANK
-}
-
-/**
- * ath9k_hw_rf_alloc_ext_banks - allocates banks for external radio programming
- * @ah: atheros hardware structure
- *
- * Only required for older devices with external AR2133/AR5133 radios.
- */
-int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah)
-{
-#define ATH_ALLOC_BANK(bank, size) do { \
-		bank = kzalloc((sizeof(u32) * size), GFP_KERNEL); \
-		if (!bank) { \
-			ath_print(common, ATH_DBG_FATAL, \
-				  "Cannot allocate RF banks\n"); \
-			return -ENOMEM; \
-		} \
-	} while (0);
-
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
-
-	ATH_ALLOC_BANK(ah->analogBank0Data, ah->iniBank0.ia_rows);
-	ATH_ALLOC_BANK(ah->analogBank1Data, ah->iniBank1.ia_rows);
-	ATH_ALLOC_BANK(ah->analogBank2Data, ah->iniBank2.ia_rows);
-	ATH_ALLOC_BANK(ah->analogBank3Data, ah->iniBank3.ia_rows);
-	ATH_ALLOC_BANK(ah->analogBank6Data, ah->iniBank6.ia_rows);
-	ATH_ALLOC_BANK(ah->analogBank6TPCData, ah->iniBank6TPC.ia_rows);
-	ATH_ALLOC_BANK(ah->analogBank7Data, ah->iniBank7.ia_rows);
-	ATH_ALLOC_BANK(ah->addac5416_21,
-		       ah->iniAddac.ia_rows * ah->iniAddac.ia_columns);
-	ATH_ALLOC_BANK(ah->bank6Temp, ah->iniBank6.ia_rows);
-
-	return 0;
-#undef ATH_ALLOC_BANK
-}
-
-/**
  * ath9k_hw_decrease_chain_power()
  *
  * @ah: atheros hardware structure
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index a0b484e..4420f80 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -17,19 +17,28 @@
 #ifndef PHY_H
 #define PHY_H
 
-int ath9k_hw_ar9280_set_channel(struct ath_hw *ah, struct ath9k_channel *chan);
-int ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan);
+/* Common between single chip and non single-chip solutions */
 void ath9k_hw_write_regs(struct ath_hw *ah, u32 modesIndex,
 			 u32 freqIndex, int regWrites);
+
+/* Single chip radio settings */
+int ath9k_hw_ar9280_set_channel(struct ath_hw *ah, struct ath9k_channel *chan);
+void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
+
+/* Routines below are for non single-chip solutions */
+int ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan);
+void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
+
+int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah);
+void ath9k_hw_rf_free_ext_banks(struct ath_hw *ah);
+
 bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
 			  struct ath9k_channel *chan,
 			  u16 modesIndex);
+
 void ath9k_hw_decrease_chain_power(struct ath_hw *ah,
 				   struct ath9k_channel *chan);
 
-void ath9k_hw_rf_free_ext_banks(struct ath_hw *ah);
-int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah);
-
 #define AR_PHY_BASE     0x9800
 #define AR_PHY(_n)      (AR_PHY_BASE + ((_n)<<2))
 
-- 
1.6.0.4


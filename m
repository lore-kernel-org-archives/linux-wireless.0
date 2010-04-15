Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab0DODax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 09/97] ath9k_hw: Move some RF ops to the private callbacks
Date: Wed, 14 Apr 2010 23:29:23 -0400
Message-Id: <1271302251-9075-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PHY split is easier done in a few steps. First move
the RF ops to the private ops and rename them accordingly.
We split PHY stuff up first for the AR5008 and AR9002
families. There are some callbacks that AR9002 share
with the AR5008 familiy so we set those first, if AR9002
has some different callbacks it will override them upon
hardware init.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile            |    3 +-
 drivers/net/wireless/ath/ath9k/ani.c               |    1 +
 .../net/wireless/ath/ath9k/{phy.c => ar5008_phy.c} |  884 ++++++++++----------
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |  450 ++++++++++
 drivers/net/wireless/ath/ath9k/ar9002_phy.h        |  581 +++++++++++++
 drivers/net/wireless/ath/ath9k/calib.c             |    1 +
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |    1 +
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |    1 +
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |    1 +
 drivers/net/wireless/ath/ath9k/hw-ops.h            |  113 +++
 drivers/net/wireless/ath/ath9k/hw.c                |  467 +----------
 drivers/net/wireless/ath/ath9k/hw.h                |   46 +-
 drivers/net/wireless/ath/ath9k/init.c              |    2 +-
 drivers/net/wireless/ath/ath9k/phy.h               |  576 +-------------
 14 files changed, 1673 insertions(+), 1454 deletions(-)
 rename drivers/net/wireless/ath/ath9k/{phy.c => ar5008_phy.c} (54%)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_phy.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_phy.h

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 97133be..db63ba2 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -14,13 +14,14 @@ ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
 obj-$(CONFIG_ATH9K) += ath9k.o
 
 ath9k_hw-y:=	hw.o \
+		ar9002_phy.o \
+		ar5008_phy.o \
 		eeprom.o \
 		eeprom_def.o \
 		eeprom_4k.o \
 		eeprom_9287.o \
 		calib.o \
 		ani.o \
-		phy.o \
 		btcoex.o \
 		mac.o \
 
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 2a0cd64..031802c 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -15,6 +15,7 @@
  */
 
 #include "hw.h"
+#include "ar9002_phy.h"
 
 static int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
 					struct ath9k_channel *chan)
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
similarity index 54%
rename from drivers/net/wireless/ath/ath9k/phy.c
rename to drivers/net/wireless/ath/ath9k/ar5008_phy.c
index c45f5b8..982b0d3 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2008-2010 Atheros Communications Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -14,410 +14,15 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-/**
- * DOC: Programming Atheros 802.11n analog front end radios
- *
- * AR5416 MAC based PCI devices and AR518 MAC based PCI-Express
- * devices have either an external AR2133 analog front end radio for single
- * band 2.4 GHz communication or an AR5133 analog front end radio for dual
- * band 2.4 GHz / 5 GHz communication.
- *
- * All devices after the AR5416 and AR5418 family starting with the AR9280
- * have their analog front radios, MAC/BB and host PCIe/USB interface embedded
- * into a single-chip and require less programming.
- *
- * The following single-chips exist with a respective embedded radio:
- *
- * AR9280 - 11n dual-band 2x2 MIMO for PCIe
- * AR9281 - 11n single-band 1x2 MIMO for PCIe
- * AR9285 - 11n single-band 1x1 for PCIe
- * AR9287 - 11n single-band 2x2 MIMO for PCIe
- *
- * AR9220 - 11n dual-band 2x2 MIMO for PCI
- * AR9223 - 11n single-band 2x2 MIMO for PCI
- *
- * AR9287 - 11n single-band 1x1 MIMO for USB
- */
-
-#include <linux/slab.h>
-
 #include "hw.h"
-
-/**
- * ath9k_hw_ar9280_set_channel - set channel on single-chip device
- * @ah: atheros hardware structure
- * @chan:
- *
- * This is the function to change channel on single-chip devices, that is
- * all devices after ar9280.
- *
- * This function takes the channel value in MHz and sets
- * hardware channel value. Assumes writes have been enabled to analog bus.
- *
- * Actual Expression,
- *
- * For 2GHz channel,
- * Channel Frequency = (3/4) * freq_ref * (chansel[8:0] + chanfrac[16:0]/2^17)
- * (freq_ref = 40MHz)
- *
- * For 5GHz channel,
- * Channel Frequency = (3/2) * freq_ref * (chansel[8:0] + chanfrac[16:0]/2^10)
- * (freq_ref = 40MHz/(24>>amodeRefSel))
- */
-int ath9k_hw_ar9280_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	u16 bMode, fracMode, aModeRefSel = 0;
-	u32 freq, ndiv, channelSel = 0, channelFrac = 0, reg32 = 0;
-	struct chan_centers centers;
-	u32 refDivA = 24;
-
-	ath9k_hw_get_channel_centers(ah, chan, &centers);
-	freq = centers.synth_center;
-
-	reg32 = REG_READ(ah, AR_PHY_SYNTH_CONTROL);
-	reg32 &= 0xc0000000;
-
-	if (freq < 4800) { /* 2 GHz, fractional mode */
-		u32 txctl;
-		int regWrites = 0;
-
-		bMode = 1;
-		fracMode = 1;
-		aModeRefSel = 0;
-		channelSel = (freq * 0x10000) / 15;
-
-		if (AR_SREV_9287_11_OR_LATER(ah)) {
-			if (freq == 2484) {
-				/* Enable channel spreading for channel 14 */
-				REG_WRITE_ARRAY(&ah->iniCckfirJapan2484,
-						1, regWrites);
-			} else {
-				REG_WRITE_ARRAY(&ah->iniCckfirNormal,
-						1, regWrites);
-			}
-		} else {
-			txctl = REG_READ(ah, AR_PHY_CCK_TX_CTRL);
-			if (freq == 2484) {
-				/* Enable channel spreading for channel 14 */
-				REG_WRITE(ah, AR_PHY_CCK_TX_CTRL,
-					  txctl | AR_PHY_CCK_TX_CTRL_JAPAN);
-			} else {
-				REG_WRITE(ah, AR_PHY_CCK_TX_CTRL,
-					  txctl &~ AR_PHY_CCK_TX_CTRL_JAPAN);
-			}
-		}
-	} else {
-		bMode = 0;
-		fracMode = 0;
-
-		switch(ah->eep_ops->get_eeprom(ah, EEP_FRAC_N_5G)) {
-		case 0:
-			if ((freq % 20) == 0) {
-				aModeRefSel = 3;
-			} else if ((freq % 10) == 0) {
-				aModeRefSel = 2;
-			}
-			if (aModeRefSel)
-				break;
-		case 1:
-		default:
-			aModeRefSel = 0;
-			/*
-			 * Enable 2G (fractional) mode for channels
-			 * which are 5MHz spaced.
-			 */
-			fracMode = 1;
-			refDivA = 1;
-			channelSel = (freq * 0x8000) / 15;
-
-			/* RefDivA setting */
-			REG_RMW_FIELD(ah, AR_AN_SYNTH9,
-				      AR_AN_SYNTH9_REFDIVA, refDivA);
-
-		}
-
-		if (!fracMode) {
-			ndiv = (freq * (refDivA >> aModeRefSel)) / 60;
-			channelSel = ndiv & 0x1ff;
-			channelFrac = (ndiv & 0xfffffe00) * 2;
-			channelSel = (channelSel << 17) | channelFrac;
-		}
-	}
-
-	reg32 = reg32 |
-	    (bMode << 29) |
-	    (fracMode << 28) | (aModeRefSel << 26) | (channelSel);
-
-	REG_WRITE(ah, AR_PHY_SYNTH_CONTROL, reg32);
-
-	ah->curchan = chan;
-	ah->curchan_rad_index = -1;
-
-	return 0;
-}
-
-/**
- * ath9k_hw_9280_spur_mitigate - convert baseband spur frequency
- * @ah: atheros hardware structure
- * @chan:
- *
- * For single-chip solutions. Converts to baseband spur frequency given the
- * input channel frequency and compute register settings below.
- */
-void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
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
+#include "hw-ops.h"
+#include "../regd.h"
+#include "ar9002_phy.h"
 
 /* All code below is for non single-chip solutions */
 
 /**
- * ath9k_phy_modify_rx_buffer() - perform analog swizzling of parameters
+ * ar5008_hw_phy_modify_rx_buffer() - perform analog swizzling of parameters
  * @rfbuf:
  * @reg32:
  * @numBits:
@@ -427,9 +32,9 @@ void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
  * Performs analog "swizzling" of parameters into their location.
  * Used on external AR2133/AR5133 radios.
  */
-static void ath9k_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
-				       u32 numBits, u32 firstBit,
-				       u32 column)
+static void ar5008_hw_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
+					   u32 numBits, u32 firstBit,
+					   u32 column)
 {
 	u32 tmp32, mask, arrayEntry, lastBit;
 	int32_t bitPosition, bitsLeft;
@@ -480,16 +85,15 @@ static void ath9k_phy_modify_rx_buffer(u32 *rfBuf, u32 reg32,
  *  2nd Mod:
  *    Less than 2412 uses value of 0, 2412 and above uses value of 2
  */
-static void ath9k_hw_force_bias(struct ath_hw *ah, u16 synth_freq)
+static void ar5008_hw_force_bias(struct ath_hw *ah, u16 synth_freq)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 tmp_reg;
 	int reg_writes = 0;
 	u32 new_bias = 0;
 
-	if (!AR_SREV_5416(ah) || synth_freq >= 3000) {
+	if (!AR_SREV_5416(ah) || synth_freq >= 3000)
 		return;
-	}
 
 	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
 
@@ -508,14 +112,14 @@ static void ath9k_hw_force_bias(struct ath_hw *ah, u16 synth_freq)
 		  new_bias, synth_freq);
 
 	/* swizzle rf_pwd_icsyndiv */
-	ath9k_phy_modify_rx_buffer(ah->analogBank6Data, tmp_reg, 3, 181, 3);
+	ar5008_hw_phy_modify_rx_buffer(ah->analogBank6Data, tmp_reg, 3, 181, 3);
 
 	/* write Bank 6 with new params */
 	REG_WRITE_RF_ARRAY(&ah->iniBank6, ah->analogBank6Data, reg_writes);
 }
 
 /**
- * ath9k_hw_set_channel - tune to a channel on the external AR2133/AR5133 radios
+ * ar5008_hw_set_channel - tune to a channel on the external AR2133/AR5133 radios
  * @ah: atheros hardware stucture
  * @chan:
  *
@@ -523,7 +127,7 @@ static void ath9k_hw_force_bias(struct ath_hw *ah, u16 synth_freq)
  * the channel value. Assumes writes enabled to analog bus and bank6 register
  * cache in ah->analogBank6Data.
  */
-int ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
+static int ar5008_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 channelSel = 0;
@@ -584,7 +188,7 @@ int ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 		return -EINVAL;
 	}
 
-	ath9k_hw_force_bias(ah, freq);
+	ar5008_hw_force_bias(ah, freq);
 
 	reg32 =
 	    (channelSel << 8) | (aModeRefSel << 2) | (bModeSynth << 1) |
@@ -599,14 +203,15 @@ int ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 }
 
 /**
- * ath9k_hw_spur_mitigate - convert baseband spur frequency for external radios
+ * ar5008_hw_spur_mitigate - convert baseband spur frequency for external radios
  * @ah: atheros hardware structure
  * @chan:
  *
  * For non single-chip solutions. Converts to baseband spur frequency given the
  * input channel frequency and compute register settings below.
  */
-void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
+static void ar5008_hw_spur_mitigate(struct ath_hw *ah,
+				    struct ath9k_channel *chan)
 {
 	int bb_spur = AR_NO_SPUR;
 	int bin, cur_bin;
@@ -808,12 +413,12 @@ void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan)
 }
 
 /**
- * ath9k_hw_rf_alloc_ext_banks - allocates banks for external radio programming
+ * ar5008_hw_rf_alloc_ext_banks - allocates banks for external radio programming
  * @ah: atheros hardware structure
  *
  * Only required for older devices with external AR2133/AR5133 radios.
  */
-int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah)
+static int ar5008_hw_rf_alloc_ext_banks(struct ath_hw *ah)
 {
 #define ATH_ALLOC_BANK(bank, size) do { \
 		bank = kzalloc((sizeof(u32) * size), GFP_KERNEL); \
@@ -845,12 +450,11 @@ int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah)
 
 
 /**
- * ath9k_hw_rf_free_ext_banks - Free memory for analog bank scratch buffers
+ * ar5008_hw_rf_free_ext_banks - Free memory for analog bank scratch buffers
  * @ah: atheros hardware struture
  * For the external AR2133/AR5133 radios banks.
  */
-void
-ath9k_hw_rf_free_ext_banks(struct ath_hw *ah)
+static void ar5008_hw_rf_free_ext_banks(struct ath_hw *ah)
 {
 #define ATH_FREE_BANK(bank) do { \
 		kfree(bank); \
@@ -873,7 +477,7 @@ ath9k_hw_rf_free_ext_banks(struct ath_hw *ah)
 }
 
 /* *
- * ath9k_hw_set_rf_regs - programs rf registers based on EEPROM
+ * ar5008_hw_set_rf_regs - programs rf registers based on EEPROM
  * @ah: atheros hardware structure
  * @chan:
  * @modesIndex:
@@ -884,8 +488,9 @@ ath9k_hw_rf_free_ext_banks(struct ath_hw *ah)
  * all rf registers. This routine requires access to the analog
  * rf device. This is not required for single-chip devices.
  */
-bool ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
-			  u16 modesIndex)
+static bool ar5008_hw_set_rf_regs(struct ath_hw *ah,
+				  struct ath9k_channel *chan,
+				  u16 modesIndex)
 {
 	u32 eepMinorRev;
 	u32 ob5GHz = 0, db5GHz = 0;
@@ -928,17 +533,17 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 		if (IS_CHAN_2GHZ(chan)) {
 			ob2GHz = ah->eep_ops->get_eeprom(ah, EEP_OB_2);
 			db2GHz = ah->eep_ops->get_eeprom(ah, EEP_DB_2);
-			ath9k_phy_modify_rx_buffer(ah->analogBank6Data,
-						   ob2GHz, 3, 197, 0);
-			ath9k_phy_modify_rx_buffer(ah->analogBank6Data,
-						   db2GHz, 3, 194, 0);
+			ar5008_hw_phy_modify_rx_buffer(ah->analogBank6Data,
+						       ob2GHz, 3, 197, 0);
+			ar5008_hw_phy_modify_rx_buffer(ah->analogBank6Data,
+						       db2GHz, 3, 194, 0);
 		} else {
 			ob5GHz = ah->eep_ops->get_eeprom(ah, EEP_OB_5);
 			db5GHz = ah->eep_ops->get_eeprom(ah, EEP_DB_5);
-			ath9k_phy_modify_rx_buffer(ah->analogBank6Data,
-						   ob5GHz, 3, 203, 0);
-			ath9k_phy_modify_rx_buffer(ah->analogBank6Data,
-						   db5GHz, 3, 200, 0);
+			ar5008_hw_phy_modify_rx_buffer(ah->analogBank6Data,
+						       ob5GHz, 3, 203, 0);
+			ar5008_hw_phy_modify_rx_buffer(ah->analogBank6Data,
+						       db5GHz, 3, 200, 0);
 		}
 	}
 
@@ -961,3 +566,426 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	return true;
 }
+
+static void ar5008_hw_init_bb(struct ath_hw *ah,
+			      struct ath9k_channel *chan)
+{
+	u32 synthDelay;
+
+	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
+	if (IS_CHAN_B(chan))
+		synthDelay = (4 * synthDelay) / 22;
+	else
+		synthDelay /= 10;
+
+	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
+
+	udelay(synthDelay + BASE_ACTIVATE_DELAY);
+}
+
+static void ar5008_hw_init_chain_masks(struct ath_hw *ah)
+{
+	int rx_chainmask, tx_chainmask;
+
+	rx_chainmask = ah->rxchainmask;
+	tx_chainmask = ah->txchainmask;
+
+	switch (rx_chainmask) {
+	case 0x5:
+		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
+			    AR_PHY_SWAP_ALT_CHAIN);
+	case 0x3:
+		if (ah->hw_version.macVersion == AR_SREV_REVISION_5416_10) {
+			REG_WRITE(ah, AR_PHY_RX_CHAINMASK, 0x7);
+			REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, 0x7);
+			break;
+		}
+	case 0x1:
+	case 0x2:
+	case 0x7:
+		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx_chainmask);
+		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx_chainmask);
+		break;
+	default:
+		break;
+	}
+
+	REG_WRITE(ah, AR_SELFGEN_MASK, tx_chainmask);
+	if (tx_chainmask == 0x5) {
+		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
+			    AR_PHY_SWAP_ALT_CHAIN);
+	}
+	if (AR_SREV_9100(ah))
+		REG_WRITE(ah, AR_PHY_ANALOG_SWAP,
+			  REG_READ(ah, AR_PHY_ANALOG_SWAP) | 0x00000001);
+}
+
+static void ar5008_hw_override_ini(struct ath_hw *ah,
+				   struct ath9k_channel *chan)
+{
+	u32 val;
+
+	/*
+	 * Set the RX_ABORT and RX_DIS and clear if off only after
+	 * RXE is set for MAC. This prevents frames with corrupted
+	 * descriptor status.
+	 */
+	REG_SET_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
+
+	if (AR_SREV_9280_10_OR_LATER(ah)) {
+		val = REG_READ(ah, AR_PCU_MISC_MODE2);
+
+		if (!AR_SREV_9271(ah))
+			val &= ~AR_PCU_MISC_MODE2_HWWAR1;
+
+		if (AR_SREV_9287_10_OR_LATER(ah))
+			val = val & (~AR_PCU_MISC_MODE2_HWWAR2);
+
+		REG_WRITE(ah, AR_PCU_MISC_MODE2, val);
+	}
+
+	if (!AR_SREV_5416_20_OR_LATER(ah) ||
+	    AR_SREV_9280_10_OR_LATER(ah))
+		return;
+	/*
+	 * Disable BB clock gating
+	 * Necessary to avoid issues on AR5416 2.0
+	 */
+	REG_WRITE(ah, 0x9800 + (651 << 2), 0x11);
+
+	/*
+	 * Disable RIFS search on some chips to avoid baseband
+	 * hang issues.
+	 */
+	if (AR_SREV_9100(ah) || AR_SREV_9160(ah)) {
+		val = REG_READ(ah, AR_PHY_HEAVY_CLIP_FACTOR_RIFS);
+		val &= ~AR_PHY_RIFS_INIT_DELAY;
+		REG_WRITE(ah, AR_PHY_HEAVY_CLIP_FACTOR_RIFS, val);
+	}
+}
+
+static void ar5008_hw_set_channel_regs(struct ath_hw *ah,
+				       struct ath9k_channel *chan)
+{
+	u32 phymode;
+	u32 enableDacFifo = 0;
+
+	if (AR_SREV_9285_10_OR_LATER(ah))
+		enableDacFifo = (REG_READ(ah, AR_PHY_TURBO) &
+					 AR_PHY_FC_ENABLE_DAC_FIFO);
+
+	phymode = AR_PHY_FC_HT_EN | AR_PHY_FC_SHORT_GI_40
+		| AR_PHY_FC_SINGLE_HT_LTF1 | AR_PHY_FC_WALSH | enableDacFifo;
+
+	if (IS_CHAN_HT40(chan)) {
+		phymode |= AR_PHY_FC_DYN2040_EN;
+
+		if ((chan->chanmode == CHANNEL_A_HT40PLUS) ||
+		    (chan->chanmode == CHANNEL_G_HT40PLUS))
+			phymode |= AR_PHY_FC_DYN2040_PRI_CH;
+
+	}
+	REG_WRITE(ah, AR_PHY_TURBO, phymode);
+
+	ath9k_hw_set11nmac2040(ah);
+
+	REG_WRITE(ah, AR_GTXTO, 25 << AR_GTXTO_TIMEOUT_LIMIT_S);
+	REG_WRITE(ah, AR_CST, 0xF << AR_CST_TIMEOUT_LIMIT_S);
+}
+
+
+static int ar5008_hw_process_ini(struct ath_hw *ah,
+				 struct ath9k_channel *chan)
+{
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+	int i, regWrites = 0;
+	struct ieee80211_channel *channel = chan->chan;
+	u32 modesIndex, freqIndex;
+
+	switch (chan->chanmode) {
+	case CHANNEL_A:
+	case CHANNEL_A_HT20:
+		modesIndex = 1;
+		freqIndex = 1;
+		break;
+	case CHANNEL_A_HT40PLUS:
+	case CHANNEL_A_HT40MINUS:
+		modesIndex = 2;
+		freqIndex = 1;
+		break;
+	case CHANNEL_G:
+	case CHANNEL_G_HT20:
+	case CHANNEL_B:
+		modesIndex = 4;
+		freqIndex = 2;
+		break;
+	case CHANNEL_G_HT40PLUS:
+	case CHANNEL_G_HT40MINUS:
+		modesIndex = 3;
+		freqIndex = 2;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (AR_SREV_9287_12_OR_LATER(ah)) {
+		/* Enable ASYNC FIFO */
+		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
+				AR_MAC_PCU_ASYNC_FIFO_REG3_DATAPATH_SEL);
+		REG_SET_BIT(ah, AR_PHY_MODE, AR_PHY_MODE_ASYNCFIFO);
+		REG_CLR_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
+				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
+		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
+				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
+	}
+
+	/*
+	 * Set correct baseband to analog shift setting to
+	 * access analog chips.
+	 */
+	REG_WRITE(ah, AR_PHY(0), 0x00000007);
+
+	/* Write ADDAC shifts */
+	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_EXTERNAL_RADIO);
+	ah->eep_ops->set_addac(ah, chan);
+
+	if (AR_SREV_5416_22_OR_LATER(ah)) {
+		REG_WRITE_ARRAY(&ah->iniAddac, 1, regWrites);
+	} else {
+		struct ar5416IniArray temp;
+		u32 addacSize =
+			sizeof(u32) * ah->iniAddac.ia_rows *
+			ah->iniAddac.ia_columns;
+
+		/* For AR5416 2.0/2.1 */
+		memcpy(ah->addac5416_21,
+		       ah->iniAddac.ia_array, addacSize);
+
+		/* override CLKDRV value at [row, column] = [31, 1] */
+		(ah->addac5416_21)[31 * ah->iniAddac.ia_columns + 1] = 0;
+
+		temp.ia_array = ah->addac5416_21;
+		temp.ia_columns = ah->iniAddac.ia_columns;
+		temp.ia_rows = ah->iniAddac.ia_rows;
+		REG_WRITE_ARRAY(&temp, 1, regWrites);
+	}
+
+	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_INTERNAL_ADDAC);
+
+	for (i = 0; i < ah->iniModes.ia_rows; i++) {
+		u32 reg = INI_RA(&ah->iniModes, i, 0);
+		u32 val = INI_RA(&ah->iniModes, i, modesIndex);
+
+		if (reg == AR_AN_TOP2 && ah->need_an_top2_fixup)
+			val &= ~AR_AN_TOP2_PWDCLKIND;
+
+		REG_WRITE(ah, reg, val);
+
+		if (reg >= 0x7800 && reg < 0x78a0
+		    && ah->config.analog_shiftreg) {
+			udelay(100);
+		}
+
+		DO_DELAY(regWrites);
+	}
+
+	if (AR_SREV_9280(ah) || AR_SREV_9287_10_OR_LATER(ah))
+		REG_WRITE_ARRAY(&ah->iniModesRxGain, modesIndex, regWrites);
+
+	if (AR_SREV_9280(ah) || AR_SREV_9285_12_OR_LATER(ah) ||
+	    AR_SREV_9287_10_OR_LATER(ah))
+		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
+
+	if (AR_SREV_9271_10(ah))
+		REG_WRITE_ARRAY(&ah->iniModes_9271_1_0_only,
+				modesIndex, regWrites);
+
+	/* Write common array parameters */
+	for (i = 0; i < ah->iniCommon.ia_rows; i++) {
+		u32 reg = INI_RA(&ah->iniCommon, i, 0);
+		u32 val = INI_RA(&ah->iniCommon, i, 1);
+
+		REG_WRITE(ah, reg, val);
+
+		if (reg >= 0x7800 && reg < 0x78a0
+		    && ah->config.analog_shiftreg) {
+			udelay(100);
+		}
+
+		DO_DELAY(regWrites);
+	}
+
+	if (AR_SREV_9271(ah)) {
+		if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) == 1)
+			REG_WRITE_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
+					modesIndex, regWrites);
+		else
+			REG_WRITE_ARRAY(&ah->iniModes_normal_power_tx_gain_9271,
+					modesIndex, regWrites);
+	}
+
+	REG_WRITE_ARRAY(&ah->iniBB_RfGain, freqIndex, regWrites);
+
+	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan)) {
+		REG_WRITE_ARRAY(&ah->iniModesAdditional, modesIndex,
+				regWrites);
+	}
+
+	ar5008_hw_override_ini(ah, chan);
+	ar5008_hw_set_channel_regs(ah, chan);
+	ar5008_hw_init_chain_masks(ah);
+	ath9k_olc_init(ah);
+
+	/* Set TX power */
+	ah->eep_ops->set_txpower(ah, chan,
+				 ath9k_regd_get_ctl(regulatory, chan),
+				 channel->max_antenna_gain * 2,
+				 channel->max_power * 2,
+				 min((u32) MAX_RATE_POWER,
+				 (u32) regulatory->power_limit));
+
+	/* Write analog registers */
+	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "ar5416SetRfRegs failed\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void ar5008_hw_set_rfmode(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	u32 rfMode = 0;
+
+	if (chan == NULL)
+		return;
+
+	rfMode |= (IS_CHAN_B(chan) || IS_CHAN_G(chan))
+		? AR_PHY_MODE_DYNAMIC : AR_PHY_MODE_OFDM;
+
+	if (!AR_SREV_9280_10_OR_LATER(ah))
+		rfMode |= (IS_CHAN_5GHZ(chan)) ?
+			AR_PHY_MODE_RF5GHZ : AR_PHY_MODE_RF2GHZ;
+
+	if ((AR_SREV_9280_20(ah) || AR_SREV_9300_20_OR_LATER(ah))
+	    && IS_CHAN_A_5MHZ_SPACED(chan))
+		rfMode |= (AR_PHY_MODE_DYNAMIC | AR_PHY_MODE_DYN_CCK_DISABLE);
+
+	REG_WRITE(ah, AR_PHY_MODE, rfMode);
+}
+
+static void ar5008_hw_mark_phy_inactive(struct ath_hw *ah)
+{
+	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
+}
+
+static void ar5008_hw_set_delta_slope(struct ath_hw *ah,
+				      struct ath9k_channel *chan)
+{
+	u32 coef_scaled, ds_coef_exp, ds_coef_man;
+	u32 clockMhzScaled = 0x64000000;
+	struct chan_centers centers;
+
+	if (IS_CHAN_HALF_RATE(chan))
+		clockMhzScaled = clockMhzScaled >> 1;
+	else if (IS_CHAN_QUARTER_RATE(chan))
+		clockMhzScaled = clockMhzScaled >> 2;
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+	coef_scaled = clockMhzScaled / centers.synth_center;
+
+	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
+				      &ds_coef_exp);
+
+	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
+		      AR_PHY_TIMING3_DSC_MAN, ds_coef_man);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
+		      AR_PHY_TIMING3_DSC_EXP, ds_coef_exp);
+
+	coef_scaled = (9 * coef_scaled) / 10;
+
+	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
+				      &ds_coef_exp);
+
+	REG_RMW_FIELD(ah, AR_PHY_HALFGI,
+		      AR_PHY_HALFGI_DSC_MAN, ds_coef_man);
+	REG_RMW_FIELD(ah, AR_PHY_HALFGI,
+		      AR_PHY_HALFGI_DSC_EXP, ds_coef_exp);
+}
+
+static bool ar5008_hw_rfbus_req(struct ath_hw *ah)
+{
+	REG_WRITE(ah, AR_PHY_RFBUS_REQ, AR_PHY_RFBUS_REQ_EN);
+	return ath9k_hw_wait(ah, AR_PHY_RFBUS_GRANT, AR_PHY_RFBUS_GRANT_EN,
+			   AR_PHY_RFBUS_GRANT_EN, AH_WAIT_TIMEOUT);
+}
+
+static void ar5008_hw_rfbus_done(struct ath_hw *ah)
+{
+	u32 synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
+	if (IS_CHAN_B(ah->curchan))
+		synthDelay = (4 * synthDelay) / 22;
+	else
+		synthDelay /= 10;
+
+	udelay(synthDelay + BASE_ACTIVATE_DELAY);
+
+	REG_WRITE(ah, AR_PHY_RFBUS_REQ, 0);
+}
+
+static void ar5008_hw_enable_rfkill(struct ath_hw *ah)
+{
+	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
+		    AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
+
+	REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
+		    AR_GPIO_INPUT_MUX2_RFSILENT);
+
+	ath9k_hw_cfg_gpio_input(ah, ah->rfkill_gpio);
+	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
+}
+
+static void ar5008_restore_chainmask(struct ath_hw *ah)
+{
+	int rx_chainmask = ah->rxchainmask;
+
+	if ((rx_chainmask == 0x5) || (rx_chainmask == 0x3)) {
+		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx_chainmask);
+		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx_chainmask);
+	}
+}
+
+static void ar5008_set_diversity(struct ath_hw *ah, bool value)
+{
+	u32 v = REG_READ(ah, AR_PHY_CCK_DETECT);
+	if (value)
+		v |= AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
+	else
+		v &= ~AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
+	REG_WRITE(ah, AR_PHY_CCK_DETECT, v);
+}
+
+void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
+{
+	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+
+	priv_ops->rf_set_freq = ar5008_hw_set_channel;
+	priv_ops->spur_mitigate_freq = ar5008_hw_spur_mitigate;
+
+	priv_ops->rf_alloc_ext_banks = ar5008_hw_rf_alloc_ext_banks;
+	priv_ops->rf_free_ext_banks = ar5008_hw_rf_free_ext_banks;
+	priv_ops->set_rf_regs = ar5008_hw_set_rf_regs;
+	priv_ops->set_channel_regs = ar5008_hw_set_channel_regs;
+	priv_ops->init_bb = ar5008_hw_init_bb;
+	priv_ops->process_ini = ar5008_hw_process_ini;
+	priv_ops->set_rfmode = ar5008_hw_set_rfmode;
+	priv_ops->mark_phy_inactive = ar5008_hw_mark_phy_inactive;
+	priv_ops->set_delta_slope = ar5008_hw_set_delta_slope;
+	priv_ops->rfbus_req = ar5008_hw_rfbus_req;
+	priv_ops->rfbus_done = ar5008_hw_rfbus_done;
+	priv_ops->enable_rfkill = ar5008_hw_enable_rfkill;
+	priv_ops->restore_chainmask = ar5008_restore_chainmask;
+	priv_ops->set_diversity = ar5008_set_diversity;
+}
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
new file mode 100644
index 0000000..29b50ca
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -0,0 +1,450 @@
+/*
+ * Copyright (c) 2008-2010 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+/**
+ * DOC: Programming Atheros 802.11n analog front end radios
+ *
+ * AR5416 MAC based PCI devices and AR518 MAC based PCI-Express
+ * devices have either an external AR2133 analog front end radio for single
+ * band 2.4 GHz communication or an AR5133 analog front end radio for dual
+ * band 2.4 GHz / 5 GHz communication.
+ *
+ * All devices after the AR5416 and AR5418 family starting with the AR9280
+ * have their analog front radios, MAC/BB and host PCIe/USB interface embedded
+ * into a single-chip and require less programming.
+ *
+ * The following single-chips exist with a respective embedded radio:
+ *
+ * AR9280 - 11n dual-band 2x2 MIMO for PCIe
+ * AR9281 - 11n single-band 1x2 MIMO for PCIe
+ * AR9285 - 11n single-band 1x1 for PCIe
+ * AR9287 - 11n single-band 2x2 MIMO for PCIe
+ *
+ * AR9220 - 11n dual-band 2x2 MIMO for PCI
+ * AR9223 - 11n single-band 2x2 MIMO for PCI
+ *
+ * AR9287 - 11n single-band 1x1 MIMO for USB
+ */
+
+#include "hw.h"
+#include "ar9002_phy.h"
+
+/**
+ * ar9002_hw_set_channel - set channel on single-chip device
+ * @ah: atheros hardware structure
+ * @chan:
+ *
+ * This is the function to change channel on single-chip devices, that is
+ * all devices after ar9280.
+ *
+ * This function takes the channel value in MHz and sets
+ * hardware channel value. Assumes writes have been enabled to analog bus.
+ *
+ * Actual Expression,
+ *
+ * For 2GHz channel,
+ * Channel Frequency = (3/4) * freq_ref * (chansel[8:0] + chanfrac[16:0]/2^17)
+ * (freq_ref = 40MHz)
+ *
+ * For 5GHz channel,
+ * Channel Frequency = (3/2) * freq_ref * (chansel[8:0] + chanfrac[16:0]/2^10)
+ * (freq_ref = 40MHz/(24>>amodeRefSel))
+ */
+static int ar9002_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	u16 bMode, fracMode, aModeRefSel = 0;
+	u32 freq, ndiv, channelSel = 0, channelFrac = 0, reg32 = 0;
+	struct chan_centers centers;
+	u32 refDivA = 24;
+
+	ath9k_hw_get_channel_centers(ah, chan, &centers);
+	freq = centers.synth_center;
+
+	reg32 = REG_READ(ah, AR_PHY_SYNTH_CONTROL);
+	reg32 &= 0xc0000000;
+
+	if (freq < 4800) { /* 2 GHz, fractional mode */
+		u32 txctl;
+		int regWrites = 0;
+
+		bMode = 1;
+		fracMode = 1;
+		aModeRefSel = 0;
+		channelSel = (freq * 0x10000) / 15;
+
+		if (AR_SREV_9287_11_OR_LATER(ah)) {
+			if (freq == 2484) {
+				/* Enable channel spreading for channel 14 */
+				REG_WRITE_ARRAY(&ah->iniCckfirJapan2484,
+						1, regWrites);
+			} else {
+				REG_WRITE_ARRAY(&ah->iniCckfirNormal,
+						1, regWrites);
+			}
+		} else {
+			txctl = REG_READ(ah, AR_PHY_CCK_TX_CTRL);
+			if (freq == 2484) {
+				/* Enable channel spreading for channel 14 */
+				REG_WRITE(ah, AR_PHY_CCK_TX_CTRL,
+					  txctl | AR_PHY_CCK_TX_CTRL_JAPAN);
+			} else {
+				REG_WRITE(ah, AR_PHY_CCK_TX_CTRL,
+					  txctl & ~AR_PHY_CCK_TX_CTRL_JAPAN);
+			}
+		}
+	} else {
+		bMode = 0;
+		fracMode = 0;
+
+		switch (ah->eep_ops->get_eeprom(ah, EEP_FRAC_N_5G)) {
+		case 0:
+			if ((freq % 20) == 0)
+				aModeRefSel = 3;
+			else if ((freq % 10) == 0)
+				aModeRefSel = 2;
+			if (aModeRefSel)
+				break;
+		case 1:
+		default:
+			aModeRefSel = 0;
+			/*
+			 * Enable 2G (fractional) mode for channels
+			 * which are 5MHz spaced.
+			 */
+			fracMode = 1;
+			refDivA = 1;
+			channelSel = (freq * 0x8000) / 15;
+
+			/* RefDivA setting */
+			REG_RMW_FIELD(ah, AR_AN_SYNTH9,
+				      AR_AN_SYNTH9_REFDIVA, refDivA);
+
+		}
+
+		if (!fracMode) {
+			ndiv = (freq * (refDivA >> aModeRefSel)) / 60;
+			channelSel = ndiv & 0x1ff;
+			channelFrac = (ndiv & 0xfffffe00) * 2;
+			channelSel = (channelSel << 17) | channelFrac;
+		}
+	}
+
+	reg32 = reg32 |
+	    (bMode << 29) |
+	    (fracMode << 28) | (aModeRefSel << 26) | (channelSel);
+
+	REG_WRITE(ah, AR_PHY_SYNTH_CONTROL, reg32);
+
+	ah->curchan = chan;
+	ah->curchan_rad_index = -1;
+
+	return 0;
+}
+
+/**
+ * ar9002_hw_spur_mitigate - convert baseband spur frequency
+ * @ah: atheros hardware structure
+ * @chan:
+ *
+ * For single-chip solutions. Converts to baseband spur frequency given the
+ * input channel frequency and compute register settings below.
+ */
+static void ar9002_hw_spur_mitigate(struct ath_hw *ah,
+				    struct ath9k_channel *chan)
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
+static void ar9002_olc_init(struct ath_hw *ah)
+{
+	u32 i;
+
+	if (!OLC_FOR_AR9280_20_LATER)
+		return;
+
+	if (OLC_FOR_AR9287_10_LATER) {
+		REG_SET_BIT(ah, AR_PHY_TX_PWRCTRL9,
+				AR_PHY_TX_PWRCTRL9_RES_DC_REMOVAL);
+		ath9k_hw_analog_shift_rmw(ah, AR9287_AN_TXPC0,
+				AR9287_AN_TXPC0_TXPCMODE,
+				AR9287_AN_TXPC0_TXPCMODE_S,
+				AR9287_AN_TXPC0_TXPCMODE_TEMPSENSE);
+		udelay(100);
+	} else {
+		for (i = 0; i < AR9280_TX_GAIN_TABLE_SIZE; i++)
+			ah->originalGain[i] =
+				MS(REG_READ(ah, AR_PHY_TX_GAIN_TBL1 + i * 4),
+						AR_PHY_TX_GAIN);
+		ah->PDADCdelta = 0;
+	}
+}
+
+void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
+{
+	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+
+	priv_ops->set_rf_regs = NULL;
+	priv_ops->rf_alloc_ext_banks = NULL;
+	priv_ops->rf_free_ext_banks = NULL;
+	priv_ops->rf_set_freq = ar9002_hw_set_channel;
+	priv_ops->spur_mitigate_freq = ar9002_hw_spur_mitigate;
+	priv_ops->olc_init = ar9002_olc_init;
+}
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
new file mode 100644
index 0000000..4fe204e
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
@@ -0,0 +1,581 @@
+/*
+ * Copyright (c) 2008-2010 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef AR9002_PHY_H
+#define AR9002_PHY_H
+
+#define AR_PHY_TEST             0x9800
+#define PHY_AGC_CLR             0x10000000
+#define RFSILENT_BB             0x00002000
+
+#define AR_PHY_TURBO                0x9804
+#define AR_PHY_FC_TURBO_MODE        0x00000001
+#define AR_PHY_FC_TURBO_SHORT       0x00000002
+#define AR_PHY_FC_DYN2040_EN        0x00000004
+#define AR_PHY_FC_DYN2040_PRI_ONLY  0x00000008
+#define AR_PHY_FC_DYN2040_PRI_CH    0x00000010
+/* For 25 MHz channel spacing -- not used but supported by hw */
+#define AR_PHY_FC_DYN2040_EXT_CH    0x00000020
+#define AR_PHY_FC_HT_EN             0x00000040
+#define AR_PHY_FC_SHORT_GI_40       0x00000080
+#define AR_PHY_FC_WALSH             0x00000100
+#define AR_PHY_FC_SINGLE_HT_LTF1    0x00000200
+#define AR_PHY_FC_ENABLE_DAC_FIFO   0x00000800
+
+#define AR_PHY_TEST2			0x9808
+
+#define AR_PHY_TIMING2           0x9810
+#define AR_PHY_TIMING3           0x9814
+#define AR_PHY_TIMING3_DSC_MAN   0xFFFE0000
+#define AR_PHY_TIMING3_DSC_MAN_S 17
+#define AR_PHY_TIMING3_DSC_EXP   0x0001E000
+#define AR_PHY_TIMING3_DSC_EXP_S 13
+
+#define AR_PHY_CHIP_ID_REV_0      0x80
+#define AR_PHY_CHIP_ID_REV_1      0x81
+#define AR_PHY_CHIP_ID_9160_REV_0 0xb0
+
+#define AR_PHY_ACTIVE       0x981C
+#define AR_PHY_ACTIVE_EN    0x00000001
+#define AR_PHY_ACTIVE_DIS   0x00000000
+
+#define AR_PHY_RF_CTL2             0x9824
+#define AR_PHY_TX_END_DATA_START   0x000000FF
+#define AR_PHY_TX_END_DATA_START_S 0
+#define AR_PHY_TX_END_PA_ON        0x0000FF00
+#define AR_PHY_TX_END_PA_ON_S      8
+
+#define AR_PHY_RF_CTL3                  0x9828
+#define AR_PHY_TX_END_TO_A2_RX_ON       0x00FF0000
+#define AR_PHY_TX_END_TO_A2_RX_ON_S     16
+
+#define AR_PHY_ADC_CTL                  0x982C
+#define AR_PHY_ADC_CTL_OFF_INBUFGAIN    0x00000003
+#define AR_PHY_ADC_CTL_OFF_INBUFGAIN_S  0
+#define AR_PHY_ADC_CTL_OFF_PWDDAC       0x00002000
+#define AR_PHY_ADC_CTL_OFF_PWDBANDGAP   0x00004000
+#define AR_PHY_ADC_CTL_OFF_PWDADC       0x00008000
+#define AR_PHY_ADC_CTL_ON_INBUFGAIN     0x00030000
+#define AR_PHY_ADC_CTL_ON_INBUFGAIN_S   16
+
+#define AR_PHY_ADC_SERIAL_CTL       0x9830
+#define AR_PHY_SEL_INTERNAL_ADDAC   0x00000000
+#define AR_PHY_SEL_EXTERNAL_RADIO   0x00000001
+
+#define AR_PHY_RF_CTL4                    0x9834
+#define AR_PHY_RF_CTL4_TX_END_XPAB_OFF    0xFF000000
+#define AR_PHY_RF_CTL4_TX_END_XPAB_OFF_S  24
+#define AR_PHY_RF_CTL4_TX_END_XPAA_OFF    0x00FF0000
+#define AR_PHY_RF_CTL4_TX_END_XPAA_OFF_S  16
+#define AR_PHY_RF_CTL4_FRAME_XPAB_ON      0x0000FF00
+#define AR_PHY_RF_CTL4_FRAME_XPAB_ON_S    8
+#define AR_PHY_RF_CTL4_FRAME_XPAA_ON      0x000000FF
+#define AR_PHY_RF_CTL4_FRAME_XPAA_ON_S    0
+
+#define AR_PHY_TSTDAC_CONST               0x983c
+
+#define AR_PHY_SETTLING          0x9844
+#define AR_PHY_SETTLING_SWITCH   0x00003F80
+#define AR_PHY_SETTLING_SWITCH_S 7
+
+#define AR_PHY_RXGAIN                   0x9848
+#define AR_PHY_RXGAIN_TXRX_ATTEN        0x0003F000
+#define AR_PHY_RXGAIN_TXRX_ATTEN_S      12
+#define AR_PHY_RXGAIN_TXRX_RF_MAX       0x007C0000
+#define AR_PHY_RXGAIN_TXRX_RF_MAX_S     18
+#define AR9280_PHY_RXGAIN_TXRX_ATTEN    0x00003F80
+#define AR9280_PHY_RXGAIN_TXRX_ATTEN_S  7
+#define AR9280_PHY_RXGAIN_TXRX_MARGIN   0x001FC000
+#define AR9280_PHY_RXGAIN_TXRX_MARGIN_S 14
+
+#define AR_PHY_DESIRED_SZ           0x9850
+#define AR_PHY_DESIRED_SZ_ADC       0x000000FF
+#define AR_PHY_DESIRED_SZ_ADC_S     0
+#define AR_PHY_DESIRED_SZ_PGA       0x0000FF00
+#define AR_PHY_DESIRED_SZ_PGA_S     8
+#define AR_PHY_DESIRED_SZ_TOT_DES   0x0FF00000
+#define AR_PHY_DESIRED_SZ_TOT_DES_S 20
+
+#define AR_PHY_FIND_SIG           0x9858
+#define AR_PHY_FIND_SIG_FIRSTEP   0x0003F000
+#define AR_PHY_FIND_SIG_FIRSTEP_S 12
+#define AR_PHY_FIND_SIG_FIRPWR    0x03FC0000
+#define AR_PHY_FIND_SIG_FIRPWR_S  18
+
+#define AR_PHY_AGC_CTL1                  0x985C
+#define AR_PHY_AGC_CTL1_COARSE_LOW       0x00007F80
+#define AR_PHY_AGC_CTL1_COARSE_LOW_S     7
+#define AR_PHY_AGC_CTL1_COARSE_HIGH      0x003F8000
+#define AR_PHY_AGC_CTL1_COARSE_HIGH_S    15
+
+#define AR_PHY_AGC_CONTROL               0x9860
+#define AR_PHY_AGC_CONTROL_CAL           0x00000001
+#define AR_PHY_AGC_CONTROL_NF            0x00000002
+#define AR_PHY_AGC_CONTROL_ENABLE_NF     0x00008000
+#define AR_PHY_AGC_CONTROL_FLTR_CAL      0x00010000
+#define AR_PHY_AGC_CONTROL_NO_UPDATE_NF  0x00020000
+
+#define AR_PHY_CCA                  0x9864
+#define AR_PHY_MINCCA_PWR           0x0FF80000
+#define AR_PHY_MINCCA_PWR_S         19
+#define AR_PHY_CCA_THRESH62         0x0007F000
+#define AR_PHY_CCA_THRESH62_S       12
+#define AR9280_PHY_MINCCA_PWR       0x1FF00000
+#define AR9280_PHY_MINCCA_PWR_S     20
+#define AR9280_PHY_CCA_THRESH62     0x000FF000
+#define AR9280_PHY_CCA_THRESH62_S   12
+
+#define AR_PHY_SFCORR_LOW                    0x986C
+#define AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW  0x00000001
+#define AR_PHY_SFCORR_LOW_M2COUNT_THR_LOW    0x00003F00
+#define AR_PHY_SFCORR_LOW_M2COUNT_THR_LOW_S  8
+#define AR_PHY_SFCORR_LOW_M1_THRESH_LOW      0x001FC000
+#define AR_PHY_SFCORR_LOW_M1_THRESH_LOW_S    14
+#define AR_PHY_SFCORR_LOW_M2_THRESH_LOW      0x0FE00000
+#define AR_PHY_SFCORR_LOW_M2_THRESH_LOW_S    21
+
+#define AR_PHY_SFCORR                0x9868
+#define AR_PHY_SFCORR_M2COUNT_THR    0x0000001F
+#define AR_PHY_SFCORR_M2COUNT_THR_S  0
+#define AR_PHY_SFCORR_M1_THRESH      0x00FE0000
+#define AR_PHY_SFCORR_M1_THRESH_S    17
+#define AR_PHY_SFCORR_M2_THRESH      0x7F000000
+#define AR_PHY_SFCORR_M2_THRESH_S    24
+
+#define AR_PHY_SLEEP_CTR_CONTROL    0x9870
+#define AR_PHY_SLEEP_CTR_LIMIT      0x9874
+#define AR_PHY_SYNTH_CONTROL        0x9874
+#define AR_PHY_SLEEP_SCAL           0x9878
+
+#define AR_PHY_PLL_CTL          0x987c
+#define AR_PHY_PLL_CTL_40       0xaa
+#define AR_PHY_PLL_CTL_40_5413  0x04
+#define AR_PHY_PLL_CTL_44       0xab
+#define AR_PHY_PLL_CTL_44_2133  0xeb
+#define AR_PHY_PLL_CTL_40_2133  0xea
+
+#define AR_PHY_SPECTRAL_SCAN			0x9910  /* AR9280 spectral scan configuration register */
+#define	AR_PHY_SPECTRAL_SCAN_ENABLE		0x1
+#define AR_PHY_SPECTRAL_SCAN_ENA		0x00000001  /* Enable spectral scan, reg 68, bit 0 */
+#define AR_PHY_SPECTRAL_SCAN_ENA_S		0  /* Enable spectral scan, reg 68, bit 0 */
+#define AR_PHY_SPECTRAL_SCAN_ACTIVE		0x00000002  /* Activate spectral scan reg 68, bit 1*/
+#define AR_PHY_SPECTRAL_SCAN_ACTIVE_S		1  /* Activate spectral scan reg 68, bit 1*/
+#define AR_PHY_SPECTRAL_SCAN_FFT_PERIOD		0x000000F0  /* Interval for FFT reports, reg 68, bits 4-7*/
+#define AR_PHY_SPECTRAL_SCAN_FFT_PERIOD_S	4
+#define AR_PHY_SPECTRAL_SCAN_PERIOD		0x0000FF00  /* Interval for FFT reports, reg 68, bits 8-15*/
+#define AR_PHY_SPECTRAL_SCAN_PERIOD_S		8
+#define AR_PHY_SPECTRAL_SCAN_COUNT		0x00FF0000  /* Number of reports, reg 68, bits 16-23*/
+#define AR_PHY_SPECTRAL_SCAN_COUNT_S		16
+#define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT	0x01000000  /* Short repeat, reg 68, bit 24*/
+#define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT_S	24  /* Short repeat, reg 68, bit 24*/
+
+#define AR_PHY_RX_DELAY           0x9914
+#define AR_PHY_SEARCH_START_DELAY 0x9918
+#define AR_PHY_RX_DELAY_DELAY     0x00003FFF
+
+#define AR_PHY_TIMING_CTRL4(_i)     (0x9920 + ((_i) << 12))
+#define AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF 0x01F
+#define AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF_S   0
+#define AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF 0x7E0
+#define AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF_S   5
+#define AR_PHY_TIMING_CTRL4_IQCORR_ENABLE   0x800
+#define AR_PHY_TIMING_CTRL4_IQCAL_LOG_COUNT_MAX 0xF000
+#define AR_PHY_TIMING_CTRL4_IQCAL_LOG_COUNT_MAX_S   12
+#define AR_PHY_TIMING_CTRL4_DO_CAL    0x10000
+
+#define AR_PHY_TIMING_CTRL4_ENABLE_SPUR_RSSI	0x80000000
+#define	AR_PHY_TIMING_CTRL4_ENABLE_SPUR_FILTER	0x40000000
+#define	AR_PHY_TIMING_CTRL4_ENABLE_CHAN_MASK	0x20000000
+#define	AR_PHY_TIMING_CTRL4_ENABLE_PILOT_MASK	0x10000000
+
+#define AR_PHY_TIMING5               0x9924
+#define AR_PHY_TIMING5_CYCPWR_THR1   0x000000FE
+#define AR_PHY_TIMING5_CYCPWR_THR1_S 1
+
+#define AR_PHY_POWER_TX_RATE1               0x9934
+#define AR_PHY_POWER_TX_RATE2               0x9938
+#define AR_PHY_POWER_TX_RATE_MAX            0x993c
+#define AR_PHY_POWER_TX_RATE_MAX_TPC_ENABLE 0x00000040
+
+#define AR_PHY_FRAME_CTL            0x9944
+#define AR_PHY_FRAME_CTL_TX_CLIP    0x00000038
+#define AR_PHY_FRAME_CTL_TX_CLIP_S  3
+
+#define AR_PHY_TXPWRADJ                   0x994C
+#define AR_PHY_TXPWRADJ_CCK_GAIN_DELTA    0x00000FC0
+#define AR_PHY_TXPWRADJ_CCK_GAIN_DELTA_S  6
+#define AR_PHY_TXPWRADJ_CCK_PCDAC_INDEX   0x00FC0000
+#define AR_PHY_TXPWRADJ_CCK_PCDAC_INDEX_S 18
+
+#define AR_PHY_RADAR_EXT      0x9940
+#define AR_PHY_RADAR_EXT_ENA  0x00004000
+
+#define AR_PHY_RADAR_0          0x9954
+#define AR_PHY_RADAR_0_ENA      0x00000001
+#define AR_PHY_RADAR_0_FFT_ENA  0x80000000
+#define AR_PHY_RADAR_0_INBAND   0x0000003e
+#define AR_PHY_RADAR_0_INBAND_S 1
+#define AR_PHY_RADAR_0_PRSSI    0x00000FC0
+#define AR_PHY_RADAR_0_PRSSI_S  6
+#define AR_PHY_RADAR_0_HEIGHT   0x0003F000
+#define AR_PHY_RADAR_0_HEIGHT_S 12
+#define AR_PHY_RADAR_0_RRSSI    0x00FC0000
+#define AR_PHY_RADAR_0_RRSSI_S  18
+#define AR_PHY_RADAR_0_FIRPWR   0x7F000000
+#define AR_PHY_RADAR_0_FIRPWR_S 24
+
+#define AR_PHY_RADAR_1                  0x9958
+#define AR_PHY_RADAR_1_RELPWR_ENA       0x00800000
+#define AR_PHY_RADAR_1_USE_FIR128       0x00400000
+#define AR_PHY_RADAR_1_RELPWR_THRESH    0x003F0000
+#define AR_PHY_RADAR_1_RELPWR_THRESH_S  16
+#define AR_PHY_RADAR_1_BLOCK_CHECK      0x00008000
+#define AR_PHY_RADAR_1_MAX_RRSSI        0x00004000
+#define AR_PHY_RADAR_1_RELSTEP_CHECK    0x00002000
+#define AR_PHY_RADAR_1_RELSTEP_THRESH   0x00001F00
+#define AR_PHY_RADAR_1_RELSTEP_THRESH_S 8
+#define AR_PHY_RADAR_1_MAXLEN           0x000000FF
+#define AR_PHY_RADAR_1_MAXLEN_S         0
+
+#define AR_PHY_SWITCH_CHAIN_0     0x9960
+#define AR_PHY_SWITCH_COM         0x9964
+
+#define AR_PHY_SIGMA_DELTA            0x996C
+#define AR_PHY_SIGMA_DELTA_ADC_SEL    0x00000003
+#define AR_PHY_SIGMA_DELTA_ADC_SEL_S  0
+#define AR_PHY_SIGMA_DELTA_FILT2      0x000000F8
+#define AR_PHY_SIGMA_DELTA_FILT2_S    3
+#define AR_PHY_SIGMA_DELTA_FILT1      0x00001F00
+#define AR_PHY_SIGMA_DELTA_FILT1_S    8
+#define AR_PHY_SIGMA_DELTA_ADC_CLIP   0x01FFE000
+#define AR_PHY_SIGMA_DELTA_ADC_CLIP_S 13
+
+#define AR_PHY_RESTART          0x9970
+#define AR_PHY_RESTART_DIV_GC   0x001C0000
+#define AR_PHY_RESTART_DIV_GC_S 18
+
+#define AR_PHY_RFBUS_REQ        0x997C
+#define AR_PHY_RFBUS_REQ_EN     0x00000001
+
+#define	AR_PHY_TIMING7		        0x9980
+#define	AR_PHY_TIMING8		        0x9984
+#define	AR_PHY_TIMING8_PILOT_MASK_2	0x000FFFFF
+#define	AR_PHY_TIMING8_PILOT_MASK_2_S	0
+
+#define	AR_PHY_BIN_MASK2_1	0x9988
+#define	AR_PHY_BIN_MASK2_2	0x998c
+#define	AR_PHY_BIN_MASK2_3	0x9990
+#define	AR_PHY_BIN_MASK2_4	0x9994
+
+#define	AR_PHY_BIN_MASK_1	0x9900
+#define	AR_PHY_BIN_MASK_2	0x9904
+#define	AR_PHY_BIN_MASK_3	0x9908
+
+#define	AR_PHY_MASK_CTL		0x990c
+
+#define	AR_PHY_BIN_MASK2_4_MASK_4	0x00003FFF
+#define	AR_PHY_BIN_MASK2_4_MASK_4_S	0
+
+#define	AR_PHY_TIMING9		        0x9998
+#define	AR_PHY_TIMING10		        0x999c
+#define	AR_PHY_TIMING10_PILOT_MASK_2	0x000FFFFF
+#define	AR_PHY_TIMING10_PILOT_MASK_2_S	0
+
+#define	AR_PHY_TIMING11			        0x99a0
+#define	AR_PHY_TIMING11_SPUR_DELTA_PHASE	0x000FFFFF
+#define	AR_PHY_TIMING11_SPUR_DELTA_PHASE_S	0
+#define	AR_PHY_TIMING11_SPUR_FREQ_SD		0x3FF00000
+#define	AR_PHY_TIMING11_SPUR_FREQ_SD_S		20
+#define AR_PHY_TIMING11_USE_SPUR_IN_AGC		0x40000000
+#define AR_PHY_TIMING11_USE_SPUR_IN_SELFCOR	0x80000000
+
+#define AR_PHY_RX_CHAINMASK     0x99a4
+#define AR_PHY_NEW_ADC_DC_GAIN_CORR(_i) (0x99b4 + ((_i) << 12))
+#define AR_PHY_NEW_ADC_GAIN_CORR_ENABLE 0x40000000
+#define AR_PHY_NEW_ADC_DC_OFFSET_CORR_ENABLE 0x80000000
+
+#define AR_PHY_MULTICHAIN_GAIN_CTL          0x99ac
+#define AR_PHY_9285_ANT_DIV_CTL_ALL         0x7f000000
+#define AR_PHY_9285_ANT_DIV_CTL             0x01000000
+#define AR_PHY_9285_ANT_DIV_CTL_S           24
+#define AR_PHY_9285_ANT_DIV_ALT_LNACONF     0x06000000
+#define AR_PHY_9285_ANT_DIV_ALT_LNACONF_S   25
+#define AR_PHY_9285_ANT_DIV_MAIN_LNACONF    0x18000000
+#define AR_PHY_9285_ANT_DIV_MAIN_LNACONF_S  27
+#define AR_PHY_9285_ANT_DIV_ALT_GAINTB      0x20000000
+#define AR_PHY_9285_ANT_DIV_ALT_GAINTB_S    29
+#define AR_PHY_9285_ANT_DIV_MAIN_GAINTB     0x40000000
+#define AR_PHY_9285_ANT_DIV_MAIN_GAINTB_S   30
+#define AR_PHY_9285_ANT_DIV_LNA1            2
+#define AR_PHY_9285_ANT_DIV_LNA2            1
+#define AR_PHY_9285_ANT_DIV_LNA1_PLUS_LNA2  3
+#define AR_PHY_9285_ANT_DIV_LNA1_MINUS_LNA2 0
+#define AR_PHY_9285_ANT_DIV_GAINTB_0        0
+#define AR_PHY_9285_ANT_DIV_GAINTB_1        1
+
+#define AR_PHY_EXT_CCA0             0x99b8
+#define AR_PHY_EXT_CCA0_THRESH62    0x000000FF
+#define AR_PHY_EXT_CCA0_THRESH62_S  0
+
+#define AR_PHY_EXT_CCA                  0x99bc
+#define AR_PHY_EXT_CCA_CYCPWR_THR1      0x0000FE00
+#define AR_PHY_EXT_CCA_CYCPWR_THR1_S    9
+#define AR_PHY_EXT_CCA_THRESH62         0x007F0000
+#define AR_PHY_EXT_CCA_THRESH62_S       16
+#define AR_PHY_EXT_MINCCA_PWR           0xFF800000
+#define AR_PHY_EXT_MINCCA_PWR_S         23
+#define AR9280_PHY_EXT_MINCCA_PWR       0x01FF0000
+#define AR9280_PHY_EXT_MINCCA_PWR_S     16
+
+#define AR_PHY_SFCORR_EXT                 0x99c0
+#define AR_PHY_SFCORR_EXT_M1_THRESH       0x0000007F
+#define AR_PHY_SFCORR_EXT_M1_THRESH_S     0
+#define AR_PHY_SFCORR_EXT_M2_THRESH       0x00003F80
+#define AR_PHY_SFCORR_EXT_M2_THRESH_S     7
+#define AR_PHY_SFCORR_EXT_M1_THRESH_LOW   0x001FC000
+#define AR_PHY_SFCORR_EXT_M1_THRESH_LOW_S 14
+#define AR_PHY_SFCORR_EXT_M2_THRESH_LOW   0x0FE00000
+#define AR_PHY_SFCORR_EXT_M2_THRESH_LOW_S 21
+#define AR_PHY_SFCORR_SPUR_SUBCHNL_SD_S   28
+
+#define AR_PHY_HALFGI           0x99D0
+#define AR_PHY_HALFGI_DSC_MAN   0x0007FFF0
+#define AR_PHY_HALFGI_DSC_MAN_S 4
+#define AR_PHY_HALFGI_DSC_EXP   0x0000000F
+#define AR_PHY_HALFGI_DSC_EXP_S 0
+
+#define AR_PHY_CHAN_INFO_MEMORY               0x99DC
+#define AR_PHY_CHAN_INFO_MEMORY_CAPTURE_MASK  0x0001
+
+#define AR_PHY_HEAVY_CLIP_ENABLE         0x99E0
+
+#define AR_PHY_HEAVY_CLIP_FACTOR_RIFS    0x99EC
+#define AR_PHY_RIFS_INIT_DELAY         0x03ff0000
+
+#define AR_PHY_M_SLEEP      0x99f0
+#define AR_PHY_REFCLKDLY    0x99f4
+#define AR_PHY_REFCLKPD     0x99f8
+
+#define AR_PHY_CALMODE      0x99f0
+
+#define AR_PHY_CALMODE_IQ           0x00000000
+#define AR_PHY_CALMODE_ADC_GAIN     0x00000001
+#define AR_PHY_CALMODE_ADC_DC_PER   0x00000002
+#define AR_PHY_CALMODE_ADC_DC_INIT  0x00000003
+
+#define AR_PHY_CAL_MEAS_0(_i)     (0x9c10 + ((_i) << 12))
+#define AR_PHY_CAL_MEAS_1(_i)     (0x9c14 + ((_i) << 12))
+#define AR_PHY_CAL_MEAS_2(_i)     (0x9c18 + ((_i) << 12))
+#define AR_PHY_CAL_MEAS_3(_i)     (0x9c1c + ((_i) << 12))
+
+#define AR_PHY_CURRENT_RSSI 0x9c1c
+#define AR9280_PHY_CURRENT_RSSI 0x9c3c
+
+#define AR_PHY_RFBUS_GRANT       0x9C20
+#define AR_PHY_RFBUS_GRANT_EN    0x00000001
+
+#define AR_PHY_CHAN_INFO_GAIN_DIFF             0x9CF4
+#define AR_PHY_CHAN_INFO_GAIN_DIFF_UPPER_LIMIT 320
+
+#define AR_PHY_CHAN_INFO_GAIN          0x9CFC
+
+#define AR_PHY_MODE         0xA200
+#define AR_PHY_MODE_ASYNCFIFO 0x80
+#define AR_PHY_MODE_AR2133  0x08
+#define AR_PHY_MODE_AR5111  0x00
+#define AR_PHY_MODE_AR5112  0x08
+#define AR_PHY_MODE_DYNAMIC 0x04
+#define AR_PHY_MODE_RF2GHZ  0x02
+#define AR_PHY_MODE_RF5GHZ  0x00
+#define AR_PHY_MODE_CCK     0x01
+#define AR_PHY_MODE_OFDM    0x00
+#define AR_PHY_MODE_DYN_CCK_DISABLE 0x100
+
+#define AR_PHY_CCK_TX_CTRL       0xA204
+#define AR_PHY_CCK_TX_CTRL_JAPAN 0x00000010
+#define AR_PHY_CCK_TX_CTRL_TX_DAC_SCALE_CCK         0x0000000C
+#define AR_PHY_CCK_TX_CTRL_TX_DAC_SCALE_CCK_S       2
+
+#define AR_PHY_CCK_DETECT                           0xA208
+#define AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK          0x0000003F
+#define AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK_S        0
+/* [12:6] settling time for antenna switch */
+#define AR_PHY_CCK_DETECT_ANT_SWITCH_TIME           0x00001FC0
+#define AR_PHY_CCK_DETECT_ANT_SWITCH_TIME_S         6
+#define AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV    0x2000
+#define AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV_S  13
+
+#define AR_PHY_GAIN_2GHZ                0xA20C
+#define AR_PHY_GAIN_2GHZ_RXTX_MARGIN    0x00FC0000
+#define AR_PHY_GAIN_2GHZ_RXTX_MARGIN_S  18
+#define AR_PHY_GAIN_2GHZ_BSW_MARGIN     0x00003C00
+#define AR_PHY_GAIN_2GHZ_BSW_MARGIN_S   10
+#define AR_PHY_GAIN_2GHZ_BSW_ATTEN      0x0000001F
+#define AR_PHY_GAIN_2GHZ_BSW_ATTEN_S    0
+
+#define AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN     0x003E0000
+#define AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN_S   17
+#define AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN     0x0001F000
+#define AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN_S   12
+#define AR_PHY_GAIN_2GHZ_XATTEN2_DB         0x00000FC0
+#define AR_PHY_GAIN_2GHZ_XATTEN2_DB_S       6
+#define AR_PHY_GAIN_2GHZ_XATTEN1_DB         0x0000003F
+#define AR_PHY_GAIN_2GHZ_XATTEN1_DB_S       0
+
+#define AR_PHY_CCK_RXCTRL4  0xA21C
+#define AR_PHY_CCK_RXCTRL4_FREQ_EST_SHORT   0x01F80000
+#define AR_PHY_CCK_RXCTRL4_FREQ_EST_SHORT_S 19
+
+#define AR_PHY_DAG_CTRLCCK  0xA228
+#define AR_PHY_DAG_CTRLCCK_EN_RSSI_THR  0x00000200
+#define AR_PHY_DAG_CTRLCCK_RSSI_THR     0x0001FC00
+#define AR_PHY_DAG_CTRLCCK_RSSI_THR_S   10
+
+#define AR_PHY_FORCE_CLKEN_CCK              0xA22C
+#define AR_PHY_FORCE_CLKEN_CCK_MRC_MUX      0x00000040
+
+#define AR_PHY_POWER_TX_RATE3   0xA234
+#define AR_PHY_POWER_TX_RATE4   0xA238
+
+#define AR_PHY_SCRM_SEQ_XR       0xA23C
+#define AR_PHY_HEADER_DETECT_XR  0xA240
+#define AR_PHY_CHIRP_DETECTED_XR 0xA244
+#define AR_PHY_BLUETOOTH         0xA254
+
+#define AR_PHY_TPCRG1   0xA258
+#define AR_PHY_TPCRG1_NUM_PD_GAIN   0x0000c000
+#define AR_PHY_TPCRG1_NUM_PD_GAIN_S 14
+
+#define AR_PHY_TPCRG1_PD_GAIN_1    0x00030000
+#define AR_PHY_TPCRG1_PD_GAIN_1_S  16
+#define AR_PHY_TPCRG1_PD_GAIN_2    0x000C0000
+#define AR_PHY_TPCRG1_PD_GAIN_2_S  18
+#define AR_PHY_TPCRG1_PD_GAIN_3    0x00300000
+#define AR_PHY_TPCRG1_PD_GAIN_3_S  20
+
+#define AR_PHY_TPCRG1_PD_CAL_ENABLE   0x00400000
+#define AR_PHY_TPCRG1_PD_CAL_ENABLE_S 22
+
+#define AR_PHY_TX_PWRCTRL4       0xa264
+#define AR_PHY_TX_PWRCTRL_PD_AVG_VALID     0x00000001
+#define AR_PHY_TX_PWRCTRL_PD_AVG_VALID_S   0
+#define AR_PHY_TX_PWRCTRL_PD_AVG_OUT       0x000001FE
+#define AR_PHY_TX_PWRCTRL_PD_AVG_OUT_S     1
+
+#define AR_PHY_TX_PWRCTRL6_0     0xa270
+#define AR_PHY_TX_PWRCTRL6_1     0xb270
+#define AR_PHY_TX_PWRCTRL_ERR_EST_MODE     0x03000000
+#define AR_PHY_TX_PWRCTRL_ERR_EST_MODE_S   24
+
+#define AR_PHY_TX_PWRCTRL7       0xa274
+#define AR_PHY_TX_PWRCTRL_INIT_TX_GAIN     0x01F80000
+#define AR_PHY_TX_PWRCTRL_INIT_TX_GAIN_S   19
+
+#define AR_PHY_TX_PWRCTRL9       0xa27C
+#define AR_PHY_TX_DESIRED_SCALE_CCK        0x00007C00
+#define AR_PHY_TX_DESIRED_SCALE_CCK_S      10
+#define AR_PHY_TX_PWRCTRL9_RES_DC_REMOVAL  0x80000000
+#define AR_PHY_TX_PWRCTRL9_RES_DC_REMOVAL_S 31
+
+#define AR_PHY_TX_GAIN_TBL1      0xa300
+#define AR_PHY_TX_GAIN                     0x0007F000
+#define AR_PHY_TX_GAIN_S                   12
+
+#define AR_PHY_CH0_TX_PWRCTRL11  0xa398
+#define AR_PHY_CH1_TX_PWRCTRL11  0xb398
+#define AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP   0x0000FC00
+#define AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP_S 10
+
+#define AR_PHY_VIT_MASK2_M_46_61 0xa3a0
+#define AR_PHY_MASK2_M_31_45     0xa3a4
+#define AR_PHY_MASK2_M_16_30     0xa3a8
+#define AR_PHY_MASK2_M_00_15     0xa3ac
+#define AR_PHY_MASK2_P_15_01     0xa3b8
+#define AR_PHY_MASK2_P_30_16     0xa3bc
+#define AR_PHY_MASK2_P_45_31     0xa3c0
+#define AR_PHY_MASK2_P_61_45     0xa3c4
+#define AR_PHY_SPUR_REG          0x994c
+
+#define AR_PHY_SPUR_REG_MASK_RATE_CNTL       (0xFF << 18)
+#define AR_PHY_SPUR_REG_MASK_RATE_CNTL_S     18
+
+#define AR_PHY_SPUR_REG_ENABLE_MASK_PPM      0x20000
+#define AR_PHY_SPUR_REG_MASK_RATE_SELECT     (0xFF << 9)
+#define AR_PHY_SPUR_REG_MASK_RATE_SELECT_S   9
+#define AR_PHY_SPUR_REG_ENABLE_VIT_SPUR_RSSI 0x100
+#define AR_PHY_SPUR_REG_SPUR_RSSI_THRESH     0x7F
+#define AR_PHY_SPUR_REG_SPUR_RSSI_THRESH_S   0
+
+#define AR_PHY_PILOT_MASK_01_30   0xa3b0
+#define AR_PHY_PILOT_MASK_31_60   0xa3b4
+
+#define AR_PHY_CHANNEL_MASK_01_30 0x99d4
+#define AR_PHY_CHANNEL_MASK_31_60 0x99d8
+
+#define AR_PHY_ANALOG_SWAP      0xa268
+#define AR_PHY_SWAP_ALT_CHAIN   0x00000040
+
+#define AR_PHY_TPCRG5   0xA26C
+#define AR_PHY_TPCRG5_PD_GAIN_OVERLAP       0x0000000F
+#define AR_PHY_TPCRG5_PD_GAIN_OVERLAP_S     0
+#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1    0x000003F0
+#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1_S  4
+#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2    0x0000FC00
+#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2_S  10
+#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3    0x003F0000
+#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3_S  16
+#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4    0x0FC00000
+#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4_S  22
+
+/* Carrier leak calibration control, do it after AGC calibration */
+#define AR_PHY_CL_CAL_CTL       0xA358
+#define AR_PHY_CL_CAL_ENABLE    0x00000002
+#define AR_PHY_PARALLEL_CAL_ENABLE    0x00000001
+
+#define AR_PHY_POWER_TX_RATE5   0xA38C
+#define AR_PHY_POWER_TX_RATE6   0xA390
+
+#define AR_PHY_CAL_CHAINMASK    0xA39C
+
+#define AR_PHY_POWER_TX_SUB     0xA3C8
+#define AR_PHY_POWER_TX_RATE7   0xA3CC
+#define AR_PHY_POWER_TX_RATE8   0xA3D0
+#define AR_PHY_POWER_TX_RATE9   0xA3D4
+
+#define AR_PHY_XPA_CFG		0xA3D8
+#define AR_PHY_FORCE_XPA_CFG	0x000000001
+#define AR_PHY_FORCE_XPA_CFG_S	0
+
+#define AR_PHY_CH1_CCA          0xa864
+#define AR_PHY_CH1_MINCCA_PWR   0x0FF80000
+#define AR_PHY_CH1_MINCCA_PWR_S 19
+#define AR9280_PHY_CH1_MINCCA_PWR   0x1FF00000
+#define AR9280_PHY_CH1_MINCCA_PWR_S 20
+
+#define AR_PHY_CH2_CCA          0xb864
+#define AR_PHY_CH2_MINCCA_PWR   0x0FF80000
+#define AR_PHY_CH2_MINCCA_PWR_S 19
+
+#define AR_PHY_CH1_EXT_CCA          0xa9bc
+#define AR_PHY_CH1_EXT_MINCCA_PWR   0xFF800000
+#define AR_PHY_CH1_EXT_MINCCA_PWR_S 23
+#define AR9280_PHY_CH1_EXT_MINCCA_PWR   0x01FF0000
+#define AR9280_PHY_CH1_EXT_MINCCA_PWR_S 16
+
+#define AR_PHY_CH2_EXT_CCA          0xb9bc
+#define AR_PHY_CH2_EXT_MINCCA_PWR   0xFF800000
+#define AR_PHY_CH2_EXT_MINCCA_PWR_S 23
+
+#endif
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 064f5b5..eba85ad 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -15,6 +15,7 @@
  */
 
 #include "hw.h"
+#include "ar9002_phy.h"
 
 /* We can tune this as we go by monitoring really low values */
 #define ATH9K_NF_TOO_LOW	-60
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 0354fe5..97279a5 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -15,6 +15,7 @@
  */
 
 #include "hw.h"
+#include "ar9002_phy.h"
 
 static int ath9k_hw_4k_get_eeprom_ver(struct ath_hw *ah)
 {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index d8ca94c..e57c5b4 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -15,6 +15,7 @@
  */
 
 #include "hw.h"
+#include "ar9002_phy.h"
 
 static int ath9k_hw_AR9287_get_eeprom_ver(struct ath_hw *ah)
 {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 404a034..99f16a3 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -15,6 +15,7 @@
  */
 
 #include "hw.h"
+#include "ar9002_phy.h"
 
 static void ath9k_get_txgain_index(struct ath_hw *ah,
 		struct ath9k_channel *chan,
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index ee33146..81f3d03 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -28,4 +28,117 @@ static inline void ath9k_hw_configpcipowersave(struct ath_hw *ah,
 	ath9k_hw_ops(ah)->config_pci_powersave(ah, restore, power_off);
 }
 
+/* Private hardware call ops */
+
+/* PHY ops */
+
+static inline int ath9k_hw_rf_set_freq(struct ath_hw *ah,
+				       struct ath9k_channel *chan)
+{
+	return ath9k_hw_private_ops(ah)->rf_set_freq(ah, chan);
+}
+
+static inline void ath9k_hw_spur_mitigate_freq(struct ath_hw *ah,
+					       struct ath9k_channel *chan)
+{
+	ath9k_hw_private_ops(ah)->spur_mitigate_freq(ah, chan);
+}
+
+static inline int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah)
+{
+	if (!ath9k_hw_private_ops(ah)->rf_alloc_ext_banks)
+		return 0;
+
+	return ath9k_hw_private_ops(ah)->rf_alloc_ext_banks(ah);
+}
+
+static inline void ath9k_hw_rf_free_ext_banks(struct ath_hw *ah)
+{
+	if (!ath9k_hw_private_ops(ah)->rf_free_ext_banks)
+		return;
+
+	ath9k_hw_private_ops(ah)->rf_free_ext_banks(ah);
+}
+
+static inline bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
+					struct ath9k_channel *chan,
+					u16 modesIndex)
+{
+	if (!ath9k_hw_private_ops(ah)->set_rf_regs)
+		return true;
+
+	return ath9k_hw_private_ops(ah)->set_rf_regs(ah, chan, modesIndex);
+}
+
+static inline void ath9k_hw_init_bb(struct ath_hw *ah,
+				    struct ath9k_channel *chan)
+{
+	return ath9k_hw_private_ops(ah)->init_bb(ah, chan);
+}
+
+static inline void ath9k_hw_set_channel_regs(struct ath_hw *ah,
+					     struct ath9k_channel *chan)
+{
+	return ath9k_hw_private_ops(ah)->set_channel_regs(ah, chan);
+}
+
+static inline int ath9k_hw_process_ini(struct ath_hw *ah,
+					struct ath9k_channel *chan)
+{
+	return ath9k_hw_private_ops(ah)->process_ini(ah, chan);
+}
+
+static inline void ath9k_olc_init(struct ath_hw *ah)
+{
+	if (!ath9k_hw_private_ops(ah)->olc_init)
+		return;
+
+	return ath9k_hw_private_ops(ah)->olc_init(ah);
+}
+
+static inline void ath9k_hw_set_rfmode(struct ath_hw *ah,
+				       struct ath9k_channel *chan)
+{
+	return ath9k_hw_private_ops(ah)->set_rfmode(ah, chan);
+}
+
+static inline void ath9k_hw_mark_phy_inactive(struct ath_hw *ah)
+{
+	return ath9k_hw_private_ops(ah)->mark_phy_inactive(ah);
+}
+
+static inline void ath9k_hw_set_delta_slope(struct ath_hw *ah,
+					    struct ath9k_channel *chan)
+{
+	return ath9k_hw_private_ops(ah)->set_delta_slope(ah, chan);
+}
+
+static inline bool ath9k_hw_rfbus_req(struct ath_hw *ah)
+{
+	return ath9k_hw_private_ops(ah)->rfbus_req(ah);
+}
+
+static inline void ath9k_hw_rfbus_done(struct ath_hw *ah)
+{
+	return ath9k_hw_private_ops(ah)->rfbus_done(ah);
+}
+
+static inline void ath9k_enable_rfkill(struct ath_hw *ah)
+{
+	return ath9k_hw_private_ops(ah)->enable_rfkill(ah);
+}
+
+static inline void ath9k_hw_restore_chainmask(struct ath_hw *ah)
+{
+	if (!ath9k_hw_private_ops(ah)->restore_chainmask)
+		return;
+
+	return ath9k_hw_private_ops(ah)->restore_chainmask(ah);
+}
+
+static inline void ath9k_hw_set_diversity(struct ath_hw *ah, bool value)
+{
+	return ath9k_hw_private_ops(ah)->set_diversity(ah, value);
+}
+
 #endif /* ATH9K_HW_OPS_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f81e273..060451f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -30,7 +30,6 @@
 static void ar9002_hw_attach_ops(struct ath_hw *ah);
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
-static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan);
 
 MODULE_AUTHOR("Atheros Communications");
 MODULE_DESCRIPTION("Support for Atheros 802.11n wireless LAN cards.");
@@ -536,14 +535,12 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 		  ah->eep_ops->get_eeprom_ver(ah),
 		  ah->eep_ops->get_eeprom_rev(ah));
 
-        if (!AR_SREV_9280_10_OR_LATER(ah)) {
-		ecode = ath9k_hw_rf_alloc_ext_banks(ah);
-		if (ecode) {
-			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-				  "Failed allocating banks for "
-				  "external radio\n");
-			return ecode;
-		}
+	ecode = ath9k_hw_rf_alloc_ext_banks(ah);
+	if (ecode) {
+		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+			  "Failed allocating banks for "
+			  "external radio\n");
+		return ecode;
 	}
 
 	if (!AR_SREV_9100(ah)) {
@@ -914,20 +911,12 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (AR_SREV_9271(ah))
 		ah->is_pciexpress = false;
 
-	/* XXX: move this to its own hw op */
 	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
-
 	ath9k_hw_init_cal_settings(ah);
 
 	ah->ani_function = ATH9K_ANI_ALL;
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
+	if (AR_SREV_9280_10_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
-		ah->ath9k_hw_rf_set_freq = &ath9k_hw_ar9280_set_channel;
-		ah->ath9k_hw_spur_mitigate_freq = &ath9k_hw_9280_spur_mitigate;
-	} else {
-		ah->ath9k_hw_rf_set_freq = &ath9k_hw_set_channel;
-		ah->ath9k_hw_spur_mitigate_freq = &ath9k_hw_spur_mitigate;
-	}
 
 	ath9k_hw_init_mode_regs(ah);
 
@@ -1015,22 +1004,6 @@ int ath9k_hw_init(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_init);
 
-static void ath9k_hw_init_bb(struct ath_hw *ah,
-			     struct ath9k_channel *chan)
-{
-	u32 synthDelay;
-
-	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
-	if (IS_CHAN_B(chan))
-		synthDelay = (4 * synthDelay) / 22;
-	else
-		synthDelay /= 10;
-
-	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
-
-	udelay(synthDelay + BASE_ACTIVATE_DELAY);
-}
-
 static void ath9k_hw_init_qos(struct ath_hw *ah)
 {
 	REG_WRITE(ah, AR_MIC_QOS_CONTROL, 0x100aa);
@@ -1122,43 +1095,6 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 	REG_WRITE(ah, AR_RTC_SLEEP_CLK, AR_RTC_FORCE_DERIVED_CLK);
 }
 
-static void ath9k_hw_init_chain_masks(struct ath_hw *ah)
-{
-	int rx_chainmask, tx_chainmask;
-
-	rx_chainmask = ah->rxchainmask;
-	tx_chainmask = ah->txchainmask;
-
-	switch (rx_chainmask) {
-	case 0x5:
-		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
-			    AR_PHY_SWAP_ALT_CHAIN);
-	case 0x3:
-		if (ah->hw_version.macVersion == AR_SREV_REVISION_5416_10) {
-			REG_WRITE(ah, AR_PHY_RX_CHAINMASK, 0x7);
-			REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, 0x7);
-			break;
-		}
-	case 0x1:
-	case 0x2:
-	case 0x7:
-		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx_chainmask);
-		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx_chainmask);
-		break;
-	default:
-		break;
-	}
-
-	REG_WRITE(ah, AR_SELFGEN_MASK, tx_chainmask);
-	if (tx_chainmask == 0x5) {
-		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
-			    AR_PHY_SWAP_ALT_CHAIN);
-	}
-	if (AR_SREV_9100(ah))
-		REG_WRITE(ah, AR_PHY_ANALOG_SWAP,
-			  REG_READ(ah, AR_PHY_ANALOG_SWAP) | 0x00000001);
-}
-
 static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 					  enum nl80211_iftype opmode)
 {
@@ -1278,8 +1214,7 @@ void ath9k_hw_deinit(struct ath_hw *ah)
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
 
 free_hw:
-	if (!AR_SREV_9280_10_OR_LATER(ah))
-		ath9k_hw_rf_free_ext_banks(ah);
+	ath9k_hw_rf_free_ext_banks(ah);
 }
 EXPORT_SYMBOL(ath9k_hw_deinit);
 
@@ -1287,73 +1222,7 @@ EXPORT_SYMBOL(ath9k_hw_deinit);
 /* INI */
 /*******/
 
-static void ath9k_hw_override_ini(struct ath_hw *ah,
-				  struct ath9k_channel *chan)
-{
-	u32 val;
-
-	/*
-	 * Set the RX_ABORT and RX_DIS and clear if off only after
-	 * RXE is set for MAC. This prevents frames with corrupted
-	 * descriptor status.
-	 */
-	REG_SET_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
-
-	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		val = REG_READ(ah, AR_PCU_MISC_MODE2);
-
-		if (!AR_SREV_9271(ah))
-			val &= ~AR_PCU_MISC_MODE2_HWWAR1;
-
-		if (AR_SREV_9287_10_OR_LATER(ah))
-			val = val & (~AR_PCU_MISC_MODE2_HWWAR2);
-
-		REG_WRITE(ah, AR_PCU_MISC_MODE2, val);
-	}
-
-	if (!AR_SREV_5416_20_OR_LATER(ah) ||
-	    AR_SREV_9280_10_OR_LATER(ah))
-		return;
-	/*
-	 * Disable BB clock gating
-	 * Necessary to avoid issues on AR5416 2.0
-	 */
-	REG_WRITE(ah, 0x9800 + (651 << 2), 0x11);
-
-	/*
-	 * Disable RIFS search on some chips to avoid baseband
-	 * hang issues.
-	 */
-	if (AR_SREV_9100(ah) || AR_SREV_9160(ah)) {
-		val = REG_READ(ah, AR_PHY_HEAVY_CLIP_FACTOR_RIFS);
-		val &= ~AR_PHY_RIFS_INIT_DELAY;
-		REG_WRITE(ah, AR_PHY_HEAVY_CLIP_FACTOR_RIFS, val);
-	}
-}
-
-static void ath9k_olc_init(struct ath_hw *ah)
-{
-	u32 i;
-
-	if (OLC_FOR_AR9287_10_LATER) {
-		REG_SET_BIT(ah, AR_PHY_TX_PWRCTRL9,
-				AR_PHY_TX_PWRCTRL9_RES_DC_REMOVAL);
-		ath9k_hw_analog_shift_rmw(ah, AR9287_AN_TXPC0,
-				AR9287_AN_TXPC0_TXPCMODE,
-				AR9287_AN_TXPC0_TXPCMODE_S,
-				AR9287_AN_TXPC0_TXPCMODE_TEMPSENSE);
-		udelay(100);
-	} else {
-		for (i = 0; i < AR9280_TX_GAIN_TABLE_SIZE; i++)
-			ah->originalGain[i] =
-				MS(REG_READ(ah, AR_PHY_TX_GAIN_TBL1 + i * 4),
-						AR_PHY_TX_GAIN);
-		ah->PDADCdelta = 0;
-	}
-}
-
-static u32 ath9k_regd_get_ctl(struct ath_regulatory *reg,
-			      struct ath9k_channel *chan)
+u32 ath9k_regd_get_ctl(struct ath_regulatory *reg, struct ath9k_channel *chan)
 {
 	u32 ctl = ath_regd_get_band_ctl(reg, chan->chan->band);
 
@@ -1367,184 +1236,10 @@ static u32 ath9k_regd_get_ctl(struct ath_regulatory *reg,
 	return ctl;
 }
 
-static int ath9k_hw_process_ini(struct ath_hw *ah,
-				struct ath9k_channel *chan)
-{
-	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
-	int i, regWrites = 0;
-	struct ieee80211_channel *channel = chan->chan;
-	u32 modesIndex, freqIndex;
-
-	switch (chan->chanmode) {
-	case CHANNEL_A:
-	case CHANNEL_A_HT20:
-		modesIndex = 1;
-		freqIndex = 1;
-		break;
-	case CHANNEL_A_HT40PLUS:
-	case CHANNEL_A_HT40MINUS:
-		modesIndex = 2;
-		freqIndex = 1;
-		break;
-	case CHANNEL_G:
-	case CHANNEL_G_HT20:
-	case CHANNEL_B:
-		modesIndex = 4;
-		freqIndex = 2;
-		break;
-	case CHANNEL_G_HT40PLUS:
-	case CHANNEL_G_HT40MINUS:
-		modesIndex = 3;
-		freqIndex = 2;
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	/* Set correct baseband to analog shift setting to access analog chips */
-	REG_WRITE(ah, AR_PHY(0), 0x00000007);
-
-	/* Write ADDAC shifts */
-	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_EXTERNAL_RADIO);
-	ah->eep_ops->set_addac(ah, chan);
-
-	if (AR_SREV_5416_22_OR_LATER(ah)) {
-		REG_WRITE_ARRAY(&ah->iniAddac, 1, regWrites);
-	} else {
-		struct ar5416IniArray temp;
-		u32 addacSize =
-			sizeof(u32) * ah->iniAddac.ia_rows *
-			ah->iniAddac.ia_columns;
-
-		/* For AR5416 2.0/2.1 */
-		memcpy(ah->addac5416_21,
-		       ah->iniAddac.ia_array, addacSize);
-
-		/* override CLKDRV value at [row, column] = [31, 1] */
-		(ah->addac5416_21)[31 * ah->iniAddac.ia_columns + 1] = 0;
-
-		temp.ia_array = ah->addac5416_21;
-		temp.ia_columns = ah->iniAddac.ia_columns;
-		temp.ia_rows = ah->iniAddac.ia_rows;
-		REG_WRITE_ARRAY(&temp, 1, regWrites);
-	}
-
-	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_INTERNAL_ADDAC);
-
-	for (i = 0; i < ah->iniModes.ia_rows; i++) {
-		u32 reg = INI_RA(&ah->iniModes, i, 0);
-		u32 val = INI_RA(&ah->iniModes, i, modesIndex);
-
-		if (reg == AR_AN_TOP2 && ah->need_an_top2_fixup)
-			val &= ~AR_AN_TOP2_PWDCLKIND;
-
-		REG_WRITE(ah, reg, val);
-
-		if (reg >= 0x7800 && reg < 0x78a0
-		    && ah->config.analog_shiftreg) {
-			udelay(100);
-		}
-
-		DO_DELAY(regWrites);
-	}
-
-	if (AR_SREV_9280(ah) || AR_SREV_9287_10_OR_LATER(ah))
-		REG_WRITE_ARRAY(&ah->iniModesRxGain, modesIndex, regWrites);
-
-	if (AR_SREV_9280(ah) || AR_SREV_9285_12_OR_LATER(ah) ||
-	    AR_SREV_9287_10_OR_LATER(ah))
-		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
-
-	if (AR_SREV_9271_10(ah))
-		REG_WRITE_ARRAY(&ah->iniModes_9271_1_0_only,
-				modesIndex, regWrites);
-
-	/* Write common array parameters */
-	for (i = 0; i < ah->iniCommon.ia_rows; i++) {
-		u32 reg = INI_RA(&ah->iniCommon, i, 0);
-		u32 val = INI_RA(&ah->iniCommon, i, 1);
-
-		REG_WRITE(ah, reg, val);
-
-		if (reg >= 0x7800 && reg < 0x78a0
-		    && ah->config.analog_shiftreg) {
-			udelay(100);
-		}
-
-		DO_DELAY(regWrites);
-	}
-
-	if (AR_SREV_9271(ah)) {
-		if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) == 1)
-			REG_WRITE_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
-					modesIndex, regWrites);
-		else
-			REG_WRITE_ARRAY(&ah->iniModes_normal_power_tx_gain_9271,
-					modesIndex, regWrites);
-	}
-
-	REG_WRITE_ARRAY(&ah->iniBB_RfGain, freqIndex, regWrites);
-
-	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan)) {
-		REG_WRITE_ARRAY(&ah->iniModesAdditional, modesIndex,
-				regWrites);
-	}
-
-	ath9k_hw_override_ini(ah, chan);
-	ath9k_hw_set_regs(ah, chan);
-	ath9k_hw_init_chain_masks(ah);
-
-	if (OLC_FOR_AR9280_20_LATER)
-		ath9k_olc_init(ah);
-
-	/* Set TX power */
-	ah->eep_ops->set_txpower(ah, chan,
-				 ath9k_regd_get_ctl(regulatory, chan),
-				 channel->max_antenna_gain * 2,
-				 channel->max_power * 2,
-				 min((u32) MAX_RATE_POWER,
-				 (u32) regulatory->power_limit));
-
-	/* Write analog registers */
-	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-			  "ar5416SetRfRegs failed\n");
-		return -EIO;
-	}
-
-	return 0;
-}
-
 /****************************************/
 /* Reset and Channel Switching Routines */
 /****************************************/
 
-static void ath9k_hw_set_rfmode(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	u32 rfMode = 0;
-
-	if (chan == NULL)
-		return;
-
-	rfMode |= (IS_CHAN_B(chan) || IS_CHAN_G(chan))
-		? AR_PHY_MODE_DYNAMIC : AR_PHY_MODE_OFDM;
-
-	if (!AR_SREV_9280_10_OR_LATER(ah))
-		rfMode |= (IS_CHAN_5GHZ(chan)) ?
-			AR_PHY_MODE_RF5GHZ : AR_PHY_MODE_RF2GHZ;
-
-	if (AR_SREV_9280_20(ah) && IS_CHAN_A_5MHZ_SPACED(chan))
-		rfMode |= (AR_PHY_MODE_DYNAMIC | AR_PHY_MODE_DYN_CCK_DISABLE);
-
-	REG_WRITE(ah, AR_PHY_MODE, rfMode);
-}
-
-static void ath9k_hw_mark_phy_inactive(struct ath_hw *ah)
-{
-	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_DIS);
-}
-
 static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 {
 	u32 regval;
@@ -1621,10 +1316,8 @@ static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 	}
 }
 
-static inline void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah,
-						 u32 coef_scaled,
-						 u32 *coef_mantissa,
-						 u32 *coef_exponent)
+void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
+				   u32 *coef_mantissa, u32 *coef_exponent)
 {
 	u32 coef_exp, coef_man;
 
@@ -1640,40 +1333,6 @@ static inline void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah,
 	*coef_exponent = coef_exp - 16;
 }
 
-static void ath9k_hw_set_delta_slope(struct ath_hw *ah,
-				     struct ath9k_channel *chan)
-{
-	u32 coef_scaled, ds_coef_exp, ds_coef_man;
-	u32 clockMhzScaled = 0x64000000;
-	struct chan_centers centers;
-
-	if (IS_CHAN_HALF_RATE(chan))
-		clockMhzScaled = clockMhzScaled >> 1;
-	else if (IS_CHAN_QUARTER_RATE(chan))
-		clockMhzScaled = clockMhzScaled >> 2;
-
-	ath9k_hw_get_channel_centers(ah, chan, &centers);
-	coef_scaled = clockMhzScaled / centers.synth_center;
-
-	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
-				      &ds_coef_exp);
-
-	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
-		      AR_PHY_TIMING3_DSC_MAN, ds_coef_man);
-	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
-		      AR_PHY_TIMING3_DSC_EXP, ds_coef_exp);
-
-	coef_scaled = (9 * coef_scaled) / 10;
-
-	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
-				      &ds_coef_exp);
-
-	REG_RMW_FIELD(ah, AR_PHY_HALFGI,
-		      AR_PHY_HALFGI_DSC_MAN, ds_coef_man);
-	REG_RMW_FIELD(ah, AR_PHY_HALFGI,
-		      AR_PHY_HALFGI_DSC_EXP, ds_coef_exp);
-}
-
 static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 {
 	u32 rst_flags;
@@ -1780,34 +1439,6 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 	}
 }
 
-static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	u32 phymode;
-	u32 enableDacFifo = 0;
-
-	if (AR_SREV_9285_10_OR_LATER(ah))
-		enableDacFifo = (REG_READ(ah, AR_PHY_TURBO) &
-					 AR_PHY_FC_ENABLE_DAC_FIFO);
-
-	phymode = AR_PHY_FC_HT_EN | AR_PHY_FC_SHORT_GI_40
-		| AR_PHY_FC_SINGLE_HT_LTF1 | AR_PHY_FC_WALSH | enableDacFifo;
-
-	if (IS_CHAN_HT40(chan)) {
-		phymode |= AR_PHY_FC_DYN2040_EN;
-
-		if ((chan->chanmode == CHANNEL_A_HT40PLUS) ||
-		    (chan->chanmode == CHANNEL_G_HT40PLUS))
-			phymode |= AR_PHY_FC_DYN2040_PRI_CH;
-
-	}
-	REG_WRITE(ah, AR_PHY_TURBO, phymode);
-
-	ath9k_hw_set11nmac2040(ah);
-
-	REG_WRITE(ah, AR_GTXTO, 25 << AR_GTXTO_TIMEOUT_LIMIT_S);
-	REG_WRITE(ah, AR_CST, 0xF << AR_CST_TIMEOUT_LIMIT_S);
-}
-
 static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 				struct ath9k_channel *chan)
 {
@@ -1833,7 +1464,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_channel *channel = chan->chan;
-	u32 synthDelay, qnum;
+	u32 qnum;
 	int r;
 
 	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
@@ -1845,17 +1476,15 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 		}
 	}
 
-	REG_WRITE(ah, AR_PHY_RFBUS_REQ, AR_PHY_RFBUS_REQ_EN);
-	if (!ath9k_hw_wait(ah, AR_PHY_RFBUS_GRANT, AR_PHY_RFBUS_GRANT_EN,
-			   AR_PHY_RFBUS_GRANT_EN, AH_WAIT_TIMEOUT)) {
+	if (!ath9k_hw_rfbus_req(ah)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Could not kill baseband RX\n");
 		return false;
 	}
 
-	ath9k_hw_set_regs(ah, chan);
+	ath9k_hw_set_channel_regs(ah, chan);
 
-	r = ah->ath9k_hw_rf_set_freq(ah, chan);
+	r = ath9k_hw_rf_set_freq(ah, chan);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Failed to set channel\n");
@@ -1869,20 +1498,12 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 			     min((u32) MAX_RATE_POWER,
 			     (u32) regulatory->power_limit));
 
-	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
-	if (IS_CHAN_B(chan))
-		synthDelay = (4 * synthDelay) / 22;
-	else
-		synthDelay /= 10;
-
-	udelay(synthDelay + BASE_ACTIVATE_DELAY);
-
-	REG_WRITE(ah, AR_PHY_RFBUS_REQ, 0);
+	ath9k_hw_rfbus_done(ah);
 
 	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
 		ath9k_hw_set_delta_slope(ah, chan);
 
-	ah->ath9k_hw_spur_mitigate_freq(ah, chan);
+	ath9k_hw_spur_mitigate_freq(ah, chan);
 
 	if (!chan->oneTimeCalsDone)
 		chan->oneTimeCalsDone = true;
@@ -1890,18 +1511,6 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	return true;
 }
 
-static void ath9k_enable_rfkill(struct ath_hw *ah)
-{
-	REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
-		    AR_GPIO_INPUT_EN_VAL_RFSILENT_BB);
-
-	REG_CLR_BIT(ah, AR_GPIO_INPUT_MUX2,
-		    AR_GPIO_INPUT_MUX2_RFSILENT);
-
-	ath9k_hw_cfg_gpio_input(ah, ah->rfkill_gpio);
-	REG_SET_BIT(ah, AR_PHY_TEST, RFSILENT_BB);
-}
-
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		    bool bChannelChange)
 {
@@ -1911,7 +1520,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	u32 saveDefAntenna;
 	u32 macStaId1;
 	u64 tsf = 0;
-	int i, rx_chainmask, r;
+	int i, r;
 
 	ah->txchainmask = common->tx_chainmask;
 	ah->rxchainmask = common->rx_chainmask;
@@ -1983,16 +1592,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
 
-	if (AR_SREV_9287_12_OR_LATER(ah)) {
-		/* Enable ASYNC FIFO */
-		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
-				AR_MAC_PCU_ASYNC_FIFO_REG3_DATAPATH_SEL);
-		REG_SET_BIT(ah, AR_PHY_MODE, AR_PHY_MODE_ASYNCFIFO);
-		REG_CLR_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
-				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
-		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
-				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
-	}
 	r = ath9k_hw_process_ini(ah, chan);
 	if (r)
 		return r;
@@ -2017,7 +1616,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
 		ath9k_hw_set_delta_slope(ah, chan);
 
-	ah->ath9k_hw_spur_mitigate_freq(ah, chan);
+	ath9k_hw_spur_mitigate_freq(ah, chan);
 	ah->eep_ops->set_board_values(ah, chan);
 
 	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
@@ -2039,7 +1638,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
 
-	r = ah->ath9k_hw_rf_set_freq(ah, chan);
+	r = ath9k_hw_rf_set_freq(ah, chan);
 	if (r)
 		return r;
 
@@ -2096,12 +1695,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;
 
-	rx_chainmask = ah->rxchainmask;
-	if ((rx_chainmask == 0x5) || (rx_chainmask == 0x3)) {
-		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx_chainmask);
-		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx_chainmask);
-	}
-
+	ath9k_hw_restore_chainmask(ah);
 	REG_WRITE(ah, AR_CFG_LED, saveLedState | AR_CFG_SCLK_32KHZ);
 
 	/*
@@ -3323,10 +2917,6 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 	case ATH9K_CAP_TKIP_SPLIT:
 		return (ah->misc_mode & AR_PCU_MIC_NEW_LOC_ENA) ?
 			false : true;
-	case ATH9K_CAP_DIVERSITY:
-		return (REG_READ(ah, AR_PHY_CCK_DETECT) &
-			AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV) ?
-			true : false;
 	case ATH9K_CAP_MCAST_KEYSRCH:
 		switch (capability) {
 		case 0:
@@ -3369,8 +2959,6 @@ EXPORT_SYMBOL(ath9k_hw_getcapability);
 bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 setting, int *status)
 {
-	u32 v;
-
 	switch (type) {
 	case ATH9K_CAP_TKIP_MIC:
 		if (setting)
@@ -3380,14 +2968,6 @@ bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			ah->sta_id1_defaults &=
 				~AR_STA_ID1_CRPT_MIC_ENABLE;
 		return true;
-	case ATH9K_CAP_DIVERSITY:
-		v = REG_READ(ah, AR_PHY_CCK_DETECT);
-		if (setting)
-			v |= AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
-		else
-			v &= ~AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
-		REG_WRITE(ah, AR_PHY_CCK_DETECT, v);
-		return true;
 	case ATH9K_CAP_MCAST_KEYSRCH:
 		if (setting)
 			ah->sta_id1_defaults |= AR_STA_ID1_MCAST_KSRCH;
@@ -3982,4 +3562,9 @@ static void ar9002_hw_attach_ops(struct ath_hw *ah)
 	priv_ops->macversion_supported = ar9002_hw_macversion_supported;
 
 	ops->config_pci_powersave = ar9002_hw_configpcipowersave;
+
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		ar9002_hw_attach_phy_ops(ah);
+	else
+		ar5008_hw_attach_phy_ops(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index dfe8502..d740e9c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -171,7 +171,6 @@ enum ath9k_capability_type {
 	ATH9K_CAP_CIPHER = 0,
 	ATH9K_CAP_TKIP_MIC,
 	ATH9K_CAP_TKIP_SPLIT,
-	ATH9K_CAP_DIVERSITY,
 	ATH9K_CAP_TXPOW,
 	ATH9K_CAP_MCAST_KEYSRCH,
 	ATH9K_CAP_DS
@@ -449,11 +448,41 @@ struct ath_gen_timer_table {
  * @init_cal_settings: Initializes calibration settings
  * @init_mode_regs: Initializes mode registers
  * @macversion_supported: If this specific mac revision is supported
+ *
+ * @rf_set_freq: change frequency
+ * @spur_mitigate_freq: spur mitigation
+ * @rf_alloc_ext_banks:
+ * @rf_free_ext_banks:
+ * @set_rf_regs:
  */
 struct ath_hw_private_ops {
 	void (*init_cal_settings)(struct ath_hw *ah);
 	void (*init_mode_regs)(struct ath_hw *ah);
 	bool (*macversion_supported)(u32 macversion);
+
+	/* PHY ops */
+	int (*rf_set_freq)(struct ath_hw *ah,
+			   struct ath9k_channel *chan);
+	void (*spur_mitigate_freq)(struct ath_hw *ah,
+				   struct ath9k_channel *chan);
+	int (*rf_alloc_ext_banks)(struct ath_hw *ah);
+	void (*rf_free_ext_banks)(struct ath_hw *ah);
+	bool (*set_rf_regs)(struct ath_hw *ah,
+			    struct ath9k_channel *chan,
+			    u16 modesIndex);
+	void (*set_channel_regs)(struct ath_hw *ah, struct ath9k_channel *chan);
+	void (*init_bb)(struct ath_hw *ah,
+			struct ath9k_channel *chan);
+	int (*process_ini)(struct ath_hw *ah, struct ath9k_channel *chan);
+	void (*olc_init)(struct ath_hw *ah);
+	void (*set_rfmode)(struct ath_hw *ah, struct ath9k_channel *chan);
+	void (*mark_phy_inactive)(struct ath_hw *ah);
+	void (*set_delta_slope)(struct ath_hw *ah, struct ath9k_channel *chan);
+	bool (*rfbus_req)(struct ath_hw *ah);
+	void (*rfbus_done)(struct ath_hw *ah);
+	void (*enable_rfkill)(struct ath_hw *ah);
+	void (*restore_chainmask)(struct ath_hw *ah);
+	void (*set_diversity)(struct ath_hw *ah, bool value);
 };
 
 /**
@@ -563,13 +592,6 @@ struct ath_hw {
 		DONT_USE_32KHZ,
 	} enable_32kHz_clock;
 
-	/* Callback for radio frequency change */
-	int (*ath9k_hw_rf_set_freq)(struct ath_hw *ah, struct ath9k_channel *chan);
-
-	/* Callback for baseband spur frequency */
-	void (*ath9k_hw_spur_mitigate_freq)(struct ath_hw *ah,
-					    struct ath9k_channel *chan);
-
 	/* Private to hardware code */
 	struct ath_hw_private_ops private_ops;
 	/* Accessed by the lower level driver */
@@ -675,6 +697,7 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 *result);
 bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 setting, int *status);
+u32 ath9k_regd_get_ctl(struct ath_regulatory *reg, struct ath9k_channel *chan);
 
 /* Key Cache Management */
 bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry);
@@ -752,6 +775,13 @@ void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len);
 /* HTC */
 void ath9k_hw_htc_resetinit(struct ath_hw *ah);
 
+/* PHY */
+void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
+				   u32 *coef_mantissa, u32 *coef_exponent);
+
+void ar9002_hw_attach_phy_ops(struct ath_hw *ah);
+void ar5008_hw_attach_phy_ops(struct ath_hw *ah);
+
 #define ATH_PCIE_CAP_LINK_CTRL	0x70
 #define ATH_PCIE_CAP_LINK_L0S	1
 #define ATH_PCIE_CAP_LINK_L1	2
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index d769759..9779646 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -514,7 +514,7 @@ static void ath9k_init_misc(struct ath_softc *sc)
 	common->tx_chainmask = sc->sc_ah->caps.tx_chainmask;
 	common->rx_chainmask = sc->sc_ah->caps.rx_chainmask;
 
-	ath9k_hw_setcapability(sc->sc_ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
+	ath9k_hw_set_diversity(sc->sc_ah, true);
 	sc->rx.defant = ath9k_hw_getdefantenna(sc->sc_ah);
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 4b6e494..b908152 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -17,501 +17,11 @@
 #ifndef PHY_H
 #define PHY_H
 
-/* Single chip radio settings */
-int ath9k_hw_ar9280_set_channel(struct ath_hw *ah, struct ath9k_channel *chan);
-void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
-
-/* Routines below are for non single-chip solutions */
-int ath9k_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan);
-void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
-
-int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah);
-void ath9k_hw_rf_free_ext_banks(struct ath_hw *ah);
-
-bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
-			  struct ath9k_channel *chan,
-			  u16 modesIndex);
-
 #define AR_PHY_BASE     0x9800
 #define AR_PHY(_n)      (AR_PHY_BASE + ((_n)<<2))
 
-#define AR_PHY_TEST             0x9800
-#define PHY_AGC_CLR             0x10000000
-#define RFSILENT_BB             0x00002000
-
-#define AR_PHY_TURBO                0x9804
-#define AR_PHY_FC_TURBO_MODE        0x00000001
-#define AR_PHY_FC_TURBO_SHORT       0x00000002
-#define AR_PHY_FC_DYN2040_EN        0x00000004
-#define AR_PHY_FC_DYN2040_PRI_ONLY  0x00000008
-#define AR_PHY_FC_DYN2040_PRI_CH    0x00000010
-/* For 25 MHz channel spacing -- not used but supported by hw */
-#define AR_PHY_FC_DYN2040_EXT_CH    0x00000020
-#define AR_PHY_FC_HT_EN             0x00000040
-#define AR_PHY_FC_SHORT_GI_40       0x00000080
-#define AR_PHY_FC_WALSH             0x00000100
-#define AR_PHY_FC_SINGLE_HT_LTF1    0x00000200
-#define AR_PHY_FC_ENABLE_DAC_FIFO   0x00000800
-
-#define AR_PHY_TEST2 		    0x9808
-
-#define AR_PHY_TIMING2           0x9810
-#define AR_PHY_TIMING3           0x9814
-#define AR_PHY_TIMING3_DSC_MAN   0xFFFE0000
-#define AR_PHY_TIMING3_DSC_MAN_S 17
-#define AR_PHY_TIMING3_DSC_EXP   0x0001E000
-#define AR_PHY_TIMING3_DSC_EXP_S 13
-
-#define AR_PHY_CHIP_ID            0x9818
-#define AR_PHY_CHIP_ID_REV_0      0x80
-#define AR_PHY_CHIP_ID_REV_1      0x81
-#define AR_PHY_CHIP_ID_9160_REV_0 0xb0
-
-#define AR_PHY_ACTIVE       0x981C
-#define AR_PHY_ACTIVE_EN    0x00000001
-#define AR_PHY_ACTIVE_DIS   0x00000000
-
-#define AR_PHY_RF_CTL2             0x9824
-#define AR_PHY_TX_END_DATA_START   0x000000FF
-#define AR_PHY_TX_END_DATA_START_S 0
-#define AR_PHY_TX_END_PA_ON        0x0000FF00
-#define AR_PHY_TX_END_PA_ON_S      8
-
-#define AR_PHY_RF_CTL3                  0x9828
-#define AR_PHY_TX_END_TO_A2_RX_ON       0x00FF0000
-#define AR_PHY_TX_END_TO_A2_RX_ON_S     16
-
-#define AR_PHY_ADC_CTL                  0x982C
-#define AR_PHY_ADC_CTL_OFF_INBUFGAIN    0x00000003
-#define AR_PHY_ADC_CTL_OFF_INBUFGAIN_S  0
-#define AR_PHY_ADC_CTL_OFF_PWDDAC       0x00002000
-#define AR_PHY_ADC_CTL_OFF_PWDBANDGAP   0x00004000
-#define AR_PHY_ADC_CTL_OFF_PWDADC       0x00008000
-#define AR_PHY_ADC_CTL_ON_INBUFGAIN     0x00030000
-#define AR_PHY_ADC_CTL_ON_INBUFGAIN_S   16
-
-#define AR_PHY_ADC_SERIAL_CTL       0x9830
-#define AR_PHY_SEL_INTERNAL_ADDAC   0x00000000
-#define AR_PHY_SEL_EXTERNAL_RADIO   0x00000001
-
-#define AR_PHY_RF_CTL4                    0x9834
-#define AR_PHY_RF_CTL4_TX_END_XPAB_OFF    0xFF000000
-#define AR_PHY_RF_CTL4_TX_END_XPAB_OFF_S  24
-#define AR_PHY_RF_CTL4_TX_END_XPAA_OFF    0x00FF0000
-#define AR_PHY_RF_CTL4_TX_END_XPAA_OFF_S  16
-#define AR_PHY_RF_CTL4_FRAME_XPAB_ON      0x0000FF00
-#define AR_PHY_RF_CTL4_FRAME_XPAB_ON_S    8
-#define AR_PHY_RF_CTL4_FRAME_XPAA_ON      0x000000FF
-#define AR_PHY_RF_CTL4_FRAME_XPAA_ON_S    0
-
-#define AR_PHY_TSTDAC_CONST               0x983c
-
-#define AR_PHY_SETTLING          0x9844
-#define AR_PHY_SETTLING_SWITCH   0x00003F80
-#define AR_PHY_SETTLING_SWITCH_S 7
-
-#define AR_PHY_RXGAIN                   0x9848
-#define AR_PHY_RXGAIN_TXRX_ATTEN        0x0003F000
-#define AR_PHY_RXGAIN_TXRX_ATTEN_S      12
-#define AR_PHY_RXGAIN_TXRX_RF_MAX       0x007C0000
-#define AR_PHY_RXGAIN_TXRX_RF_MAX_S     18
-#define AR9280_PHY_RXGAIN_TXRX_ATTEN    0x00003F80
-#define AR9280_PHY_RXGAIN_TXRX_ATTEN_S  7
-#define AR9280_PHY_RXGAIN_TXRX_MARGIN   0x001FC000
-#define AR9280_PHY_RXGAIN_TXRX_MARGIN_S 14
-
-#define AR_PHY_DESIRED_SZ           0x9850
-#define AR_PHY_DESIRED_SZ_ADC       0x000000FF
-#define AR_PHY_DESIRED_SZ_ADC_S     0
-#define AR_PHY_DESIRED_SZ_PGA       0x0000FF00
-#define AR_PHY_DESIRED_SZ_PGA_S     8
-#define AR_PHY_DESIRED_SZ_TOT_DES   0x0FF00000
-#define AR_PHY_DESIRED_SZ_TOT_DES_S 20
-
-#define AR_PHY_FIND_SIG           0x9858
-#define AR_PHY_FIND_SIG_FIRSTEP   0x0003F000
-#define AR_PHY_FIND_SIG_FIRSTEP_S 12
-#define AR_PHY_FIND_SIG_FIRPWR    0x03FC0000
-#define AR_PHY_FIND_SIG_FIRPWR_S  18
-
-#define AR_PHY_AGC_CTL1                  0x985C
-#define AR_PHY_AGC_CTL1_COARSE_LOW       0x00007F80
-#define AR_PHY_AGC_CTL1_COARSE_LOW_S     7
-#define AR_PHY_AGC_CTL1_COARSE_HIGH      0x003F8000
-#define AR_PHY_AGC_CTL1_COARSE_HIGH_S    15
-
-#define AR_PHY_AGC_CONTROL               0x9860
-#define AR_PHY_AGC_CONTROL_CAL           0x00000001
-#define AR_PHY_AGC_CONTROL_NF            0x00000002
-#define AR_PHY_AGC_CONTROL_ENABLE_NF     0x00008000
-#define AR_PHY_AGC_CONTROL_FLTR_CAL      0x00010000
-#define AR_PHY_AGC_CONTROL_NO_UPDATE_NF  0x00020000
-
-#define AR_PHY_CCA                  0x9864
-#define AR_PHY_MINCCA_PWR           0x0FF80000
-#define AR_PHY_MINCCA_PWR_S         19
-#define AR_PHY_CCA_THRESH62         0x0007F000
-#define AR_PHY_CCA_THRESH62_S       12
-#define AR9280_PHY_MINCCA_PWR       0x1FF00000
-#define AR9280_PHY_MINCCA_PWR_S     20
-#define AR9280_PHY_CCA_THRESH62     0x000FF000
-#define AR9280_PHY_CCA_THRESH62_S   12
-
-#define AR_PHY_SFCORR_LOW                    0x986C
-#define AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW  0x00000001
-#define AR_PHY_SFCORR_LOW_M2COUNT_THR_LOW    0x00003F00
-#define AR_PHY_SFCORR_LOW_M2COUNT_THR_LOW_S  8
-#define AR_PHY_SFCORR_LOW_M1_THRESH_LOW      0x001FC000
-#define AR_PHY_SFCORR_LOW_M1_THRESH_LOW_S    14
-#define AR_PHY_SFCORR_LOW_M2_THRESH_LOW      0x0FE00000
-#define AR_PHY_SFCORR_LOW_M2_THRESH_LOW_S    21
-
-#define AR_PHY_SFCORR                0x9868
-#define AR_PHY_SFCORR_M2COUNT_THR    0x0000001F
-#define AR_PHY_SFCORR_M2COUNT_THR_S  0
-#define AR_PHY_SFCORR_M1_THRESH      0x00FE0000
-#define AR_PHY_SFCORR_M1_THRESH_S    17
-#define AR_PHY_SFCORR_M2_THRESH      0x7F000000
-#define AR_PHY_SFCORR_M2_THRESH_S    24
-
-#define AR_PHY_SLEEP_CTR_CONTROL    0x9870
-#define AR_PHY_SLEEP_CTR_LIMIT      0x9874
-#define AR_PHY_SYNTH_CONTROL        0x9874
-#define AR_PHY_SLEEP_SCAL           0x9878
-
-#define AR_PHY_PLL_CTL          0x987c
-#define AR_PHY_PLL_CTL_40       0xaa
-#define AR_PHY_PLL_CTL_40_5413  0x04
-#define AR_PHY_PLL_CTL_44       0xab
-#define AR_PHY_PLL_CTL_44_2133  0xeb
-#define AR_PHY_PLL_CTL_40_2133  0xea
-
-#define AR_PHY_SPECTRAL_SCAN			0x9910  /* AR9280 spectral scan configuration register */
-#define	AR_PHY_SPECTRAL_SCAN_ENABLE		0x1
-#define AR_PHY_SPECTRAL_SCAN_ENA		0x00000001  /* Enable spectral scan, reg 68, bit 0 */
-#define AR_PHY_SPECTRAL_SCAN_ENA_S		0  /* Enable spectral scan, reg 68, bit 0 */
-#define AR_PHY_SPECTRAL_SCAN_ACTIVE		0x00000002  /* Activate spectral scan reg 68, bit 1*/
-#define AR_PHY_SPECTRAL_SCAN_ACTIVE_S		1  /* Activate spectral scan reg 68, bit 1*/
-#define AR_PHY_SPECTRAL_SCAN_FFT_PERIOD		0x000000F0  /* Interval for FFT reports, reg 68, bits 4-7*/
-#define AR_PHY_SPECTRAL_SCAN_FFT_PERIOD_S	4
-#define AR_PHY_SPECTRAL_SCAN_PERIOD		0x0000FF00  /* Interval for FFT reports, reg 68, bits 8-15*/
-#define AR_PHY_SPECTRAL_SCAN_PERIOD_S		8
-#define AR_PHY_SPECTRAL_SCAN_COUNT		0x00FF0000  /* Number of reports, reg 68, bits 16-23*/
-#define AR_PHY_SPECTRAL_SCAN_COUNT_S		16
-#define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT	0x01000000  /* Short repeat, reg 68, bit 24*/
-#define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT_S	24  /* Short repeat, reg 68, bit 24*/
-
-#define AR_PHY_RX_DELAY           0x9914
-#define AR_PHY_SEARCH_START_DELAY 0x9918
-#define AR_PHY_RX_DELAY_DELAY     0x00003FFF
-
-#define AR_PHY_TIMING_CTRL4(_i)     (0x9920 + ((_i) << 12))
-#define AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF 0x01F
-#define AR_PHY_TIMING_CTRL4_IQCORR_Q_Q_COFF_S   0
-#define AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF 0x7E0
-#define AR_PHY_TIMING_CTRL4_IQCORR_Q_I_COFF_S   5
-#define AR_PHY_TIMING_CTRL4_IQCORR_ENABLE   0x800
-#define AR_PHY_TIMING_CTRL4_IQCAL_LOG_COUNT_MAX 0xF000
-#define AR_PHY_TIMING_CTRL4_IQCAL_LOG_COUNT_MAX_S   12
-#define AR_PHY_TIMING_CTRL4_DO_CAL    0x10000
-
-#define AR_PHY_TIMING_CTRL4_ENABLE_SPUR_RSSI	0x80000000
-#define	AR_PHY_TIMING_CTRL4_ENABLE_SPUR_FILTER	0x40000000
-#define	AR_PHY_TIMING_CTRL4_ENABLE_CHAN_MASK	0x20000000
-#define	AR_PHY_TIMING_CTRL4_ENABLE_PILOT_MASK	0x10000000
-
-#define AR_PHY_TIMING5               0x9924
-#define AR_PHY_TIMING5_CYCPWR_THR1   0x000000FE
-#define AR_PHY_TIMING5_CYCPWR_THR1_S 1
-
-#define AR_PHY_POWER_TX_RATE1               0x9934
-#define AR_PHY_POWER_TX_RATE2               0x9938
-#define AR_PHY_POWER_TX_RATE_MAX            0x993c
-#define AR_PHY_POWER_TX_RATE_MAX_TPC_ENABLE 0x00000040
-
-#define AR_PHY_FRAME_CTL            0x9944
-#define AR_PHY_FRAME_CTL_TX_CLIP    0x00000038
-#define AR_PHY_FRAME_CTL_TX_CLIP_S  3
-
-#define AR_PHY_TXPWRADJ                   0x994C
-#define AR_PHY_TXPWRADJ_CCK_GAIN_DELTA    0x00000FC0
-#define AR_PHY_TXPWRADJ_CCK_GAIN_DELTA_S  6
-#define AR_PHY_TXPWRADJ_CCK_PCDAC_INDEX   0x00FC0000
-#define AR_PHY_TXPWRADJ_CCK_PCDAC_INDEX_S 18
-
-#define AR_PHY_RADAR_EXT      0x9940
-#define AR_PHY_RADAR_EXT_ENA  0x00004000
-
-#define AR_PHY_RADAR_0          0x9954
-#define AR_PHY_RADAR_0_ENA      0x00000001
-#define AR_PHY_RADAR_0_FFT_ENA  0x80000000
-#define AR_PHY_RADAR_0_INBAND   0x0000003e
-#define AR_PHY_RADAR_0_INBAND_S 1
-#define AR_PHY_RADAR_0_PRSSI    0x00000FC0
-#define AR_PHY_RADAR_0_PRSSI_S  6
-#define AR_PHY_RADAR_0_HEIGHT   0x0003F000
-#define AR_PHY_RADAR_0_HEIGHT_S 12
-#define AR_PHY_RADAR_0_RRSSI    0x00FC0000
-#define AR_PHY_RADAR_0_RRSSI_S  18
-#define AR_PHY_RADAR_0_FIRPWR   0x7F000000
-#define AR_PHY_RADAR_0_FIRPWR_S 24
-
-#define AR_PHY_RADAR_1                  0x9958
-#define AR_PHY_RADAR_1_RELPWR_ENA       0x00800000
-#define AR_PHY_RADAR_1_USE_FIR128       0x00400000
-#define AR_PHY_RADAR_1_RELPWR_THRESH    0x003F0000
-#define AR_PHY_RADAR_1_RELPWR_THRESH_S  16
-#define AR_PHY_RADAR_1_BLOCK_CHECK      0x00008000
-#define AR_PHY_RADAR_1_MAX_RRSSI        0x00004000
-#define AR_PHY_RADAR_1_RELSTEP_CHECK    0x00002000
-#define AR_PHY_RADAR_1_RELSTEP_THRESH   0x00001F00
-#define AR_PHY_RADAR_1_RELSTEP_THRESH_S 8
-#define AR_PHY_RADAR_1_MAXLEN           0x000000FF
-#define AR_PHY_RADAR_1_MAXLEN_S         0
-
-#define AR_PHY_SWITCH_CHAIN_0     0x9960
-#define AR_PHY_SWITCH_COM         0x9964
-
-#define AR_PHY_SIGMA_DELTA            0x996C
-#define AR_PHY_SIGMA_DELTA_ADC_SEL    0x00000003
-#define AR_PHY_SIGMA_DELTA_ADC_SEL_S  0
-#define AR_PHY_SIGMA_DELTA_FILT2      0x000000F8
-#define AR_PHY_SIGMA_DELTA_FILT2_S    3
-#define AR_PHY_SIGMA_DELTA_FILT1      0x00001F00
-#define AR_PHY_SIGMA_DELTA_FILT1_S    8
-#define AR_PHY_SIGMA_DELTA_ADC_CLIP   0x01FFE000
-#define AR_PHY_SIGMA_DELTA_ADC_CLIP_S 13
-
-#define AR_PHY_RESTART          0x9970
-#define AR_PHY_RESTART_DIV_GC   0x001C0000
-#define AR_PHY_RESTART_DIV_GC_S 18
-
-#define AR_PHY_RFBUS_REQ        0x997C
-#define AR_PHY_RFBUS_REQ_EN     0x00000001
-
-#define	AR_PHY_TIMING7		        0x9980
-#define	AR_PHY_TIMING8		        0x9984
-#define	AR_PHY_TIMING8_PILOT_MASK_2	0x000FFFFF
-#define	AR_PHY_TIMING8_PILOT_MASK_2_S	0
-
-#define	AR_PHY_BIN_MASK2_1	0x9988
-#define	AR_PHY_BIN_MASK2_2	0x998c
-#define	AR_PHY_BIN_MASK2_3	0x9990
-#define	AR_PHY_BIN_MASK2_4	0x9994
-
-#define	AR_PHY_BIN_MASK_1	0x9900
-#define	AR_PHY_BIN_MASK_2	0x9904
-#define	AR_PHY_BIN_MASK_3	0x9908
-
-#define	AR_PHY_MASK_CTL		0x990c
-
-#define	AR_PHY_BIN_MASK2_4_MASK_4	0x00003FFF
-#define	AR_PHY_BIN_MASK2_4_MASK_4_S	0
-
-#define	AR_PHY_TIMING9		        0x9998
-#define	AR_PHY_TIMING10		        0x999c
-#define	AR_PHY_TIMING10_PILOT_MASK_2	0x000FFFFF
-#define	AR_PHY_TIMING10_PILOT_MASK_2_S	0
-
-#define	AR_PHY_TIMING11			        0x99a0
-#define	AR_PHY_TIMING11_SPUR_DELTA_PHASE	0x000FFFFF
-#define	AR_PHY_TIMING11_SPUR_DELTA_PHASE_S	0
-#define	AR_PHY_TIMING11_SPUR_FREQ_SD		0x3FF00000
-#define	AR_PHY_TIMING11_SPUR_FREQ_SD_S		20
-#define AR_PHY_TIMING11_USE_SPUR_IN_AGC		0x40000000
-#define AR_PHY_TIMING11_USE_SPUR_IN_SELFCOR	0x80000000
-
-#define AR_PHY_RX_CHAINMASK     0x99a4
-#define AR_PHY_NEW_ADC_DC_GAIN_CORR(_i) (0x99b4 + ((_i) << 12))
-#define AR_PHY_NEW_ADC_GAIN_CORR_ENABLE 0x40000000
-#define AR_PHY_NEW_ADC_DC_OFFSET_CORR_ENABLE 0x80000000
-
-#define AR_PHY_MULTICHAIN_GAIN_CTL          0x99ac
-#define AR_PHY_9285_ANT_DIV_CTL_ALL         0x7f000000
-#define AR_PHY_9285_ANT_DIV_CTL             0x01000000
-#define AR_PHY_9285_ANT_DIV_CTL_S           24
-#define AR_PHY_9285_ANT_DIV_ALT_LNACONF     0x06000000
-#define AR_PHY_9285_ANT_DIV_ALT_LNACONF_S   25
-#define AR_PHY_9285_ANT_DIV_MAIN_LNACONF    0x18000000
-#define AR_PHY_9285_ANT_DIV_MAIN_LNACONF_S  27
-#define AR_PHY_9285_ANT_DIV_ALT_GAINTB      0x20000000
-#define AR_PHY_9285_ANT_DIV_ALT_GAINTB_S    29
-#define AR_PHY_9285_ANT_DIV_MAIN_GAINTB     0x40000000
-#define AR_PHY_9285_ANT_DIV_MAIN_GAINTB_S   30
-#define AR_PHY_9285_ANT_DIV_LNA1            2
-#define AR_PHY_9285_ANT_DIV_LNA2            1
-#define AR_PHY_9285_ANT_DIV_LNA1_PLUS_LNA2  3
-#define AR_PHY_9285_ANT_DIV_LNA1_MINUS_LNA2 0
-#define AR_PHY_9285_ANT_DIV_GAINTB_0        0
-#define AR_PHY_9285_ANT_DIV_GAINTB_1        1
-
-#define AR_PHY_EXT_CCA0             0x99b8
-#define AR_PHY_EXT_CCA0_THRESH62    0x000000FF
-#define AR_PHY_EXT_CCA0_THRESH62_S  0
-
-#define AR_PHY_EXT_CCA                  0x99bc
-#define AR_PHY_EXT_CCA_CYCPWR_THR1      0x0000FE00
-#define AR_PHY_EXT_CCA_CYCPWR_THR1_S    9
-#define AR_PHY_EXT_CCA_THRESH62         0x007F0000
-#define AR_PHY_EXT_CCA_THRESH62_S       16
-#define AR_PHY_EXT_MINCCA_PWR           0xFF800000
-#define AR_PHY_EXT_MINCCA_PWR_S         23
-#define AR9280_PHY_EXT_MINCCA_PWR       0x01FF0000
-#define AR9280_PHY_EXT_MINCCA_PWR_S     16
-
-#define AR_PHY_SFCORR_EXT                 0x99c0
-#define AR_PHY_SFCORR_EXT_M1_THRESH       0x0000007F
-#define AR_PHY_SFCORR_EXT_M1_THRESH_S     0
-#define AR_PHY_SFCORR_EXT_M2_THRESH       0x00003F80
-#define AR_PHY_SFCORR_EXT_M2_THRESH_S     7
-#define AR_PHY_SFCORR_EXT_M1_THRESH_LOW   0x001FC000
-#define AR_PHY_SFCORR_EXT_M1_THRESH_LOW_S 14
-#define AR_PHY_SFCORR_EXT_M2_THRESH_LOW   0x0FE00000
-#define AR_PHY_SFCORR_EXT_M2_THRESH_LOW_S 21
-#define AR_PHY_SFCORR_SPUR_SUBCHNL_SD_S   28
-
-#define AR_PHY_HALFGI           0x99D0
-#define AR_PHY_HALFGI_DSC_MAN   0x0007FFF0
-#define AR_PHY_HALFGI_DSC_MAN_S 4
-#define AR_PHY_HALFGI_DSC_EXP   0x0000000F
-#define AR_PHY_HALFGI_DSC_EXP_S 0
-
-#define AR_PHY_CHAN_INFO_MEMORY               0x99DC
-#define AR_PHY_CHAN_INFO_MEMORY_CAPTURE_MASK  0x0001
-
-#define AR_PHY_HEAVY_CLIP_ENABLE         0x99E0
-
-#define AR_PHY_HEAVY_CLIP_FACTOR_RIFS    0x99EC
-#define AR_PHY_RIFS_INIT_DELAY         0x03ff0000
-
-#define AR_PHY_M_SLEEP      0x99f0
-#define AR_PHY_REFCLKDLY    0x99f4
-#define AR_PHY_REFCLKPD     0x99f8
-
-#define AR_PHY_CALMODE      0x99f0
-
-#define AR_PHY_CALMODE_IQ           0x00000000
-#define AR_PHY_CALMODE_ADC_GAIN     0x00000001
-#define AR_PHY_CALMODE_ADC_DC_PER   0x00000002
-#define AR_PHY_CALMODE_ADC_DC_INIT  0x00000003
-
-#define AR_PHY_CAL_MEAS_0(_i)     (0x9c10 + ((_i) << 12))
-#define AR_PHY_CAL_MEAS_1(_i)     (0x9c14 + ((_i) << 12))
-#define AR_PHY_CAL_MEAS_2(_i)     (0x9c18 + ((_i) << 12))
-#define AR_PHY_CAL_MEAS_3(_i)     (0x9c1c + ((_i) << 12))
-
-#define AR_PHY_CURRENT_RSSI 0x9c1c
-#define AR9280_PHY_CURRENT_RSSI 0x9c3c
-
-#define AR_PHY_RFBUS_GRANT       0x9C20
-#define AR_PHY_RFBUS_GRANT_EN    0x00000001
-
-#define AR_PHY_CHAN_INFO_GAIN_DIFF             0x9CF4
-#define AR_PHY_CHAN_INFO_GAIN_DIFF_UPPER_LIMIT 320
-
-#define AR_PHY_CHAN_INFO_GAIN          0x9CFC
-
-#define AR_PHY_MODE         0xA200
-#define AR_PHY_MODE_ASYNCFIFO 0x80
-#define AR_PHY_MODE_AR2133  0x08
-#define AR_PHY_MODE_AR5111  0x00
-#define AR_PHY_MODE_AR5112  0x08
-#define AR_PHY_MODE_DYNAMIC 0x04
-#define AR_PHY_MODE_RF2GHZ  0x02
-#define AR_PHY_MODE_RF5GHZ  0x00
-#define AR_PHY_MODE_CCK     0x01
-#define AR_PHY_MODE_OFDM    0x00
-#define AR_PHY_MODE_DYN_CCK_DISABLE 0x100
-
-#define AR_PHY_CCK_TX_CTRL       0xA204
-#define AR_PHY_CCK_TX_CTRL_JAPAN 0x00000010
-#define AR_PHY_CCK_TX_CTRL_TX_DAC_SCALE_CCK         0x0000000C
-#define AR_PHY_CCK_TX_CTRL_TX_DAC_SCALE_CCK_S       2
-
-#define AR_PHY_CCK_DETECT                           0xA208
-#define AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK          0x0000003F
-#define AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK_S        0
-/* [12:6] settling time for antenna switch */
-#define AR_PHY_CCK_DETECT_ANT_SWITCH_TIME           0x00001FC0
-#define AR_PHY_CCK_DETECT_ANT_SWITCH_TIME_S         6
-#define AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV    0x2000
-#define AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV_S  13
-
-#define AR_PHY_GAIN_2GHZ                0xA20C
-#define AR_PHY_GAIN_2GHZ_RXTX_MARGIN    0x00FC0000
-#define AR_PHY_GAIN_2GHZ_RXTX_MARGIN_S  18
-#define AR_PHY_GAIN_2GHZ_BSW_MARGIN     0x00003C00
-#define AR_PHY_GAIN_2GHZ_BSW_MARGIN_S   10
-#define AR_PHY_GAIN_2GHZ_BSW_ATTEN      0x0000001F
-#define AR_PHY_GAIN_2GHZ_BSW_ATTEN_S    0
-
-#define AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN     0x003E0000
-#define AR_PHY_GAIN_2GHZ_XATTEN2_MARGIN_S   17
-#define AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN     0x0001F000
-#define AR_PHY_GAIN_2GHZ_XATTEN1_MARGIN_S   12
-#define AR_PHY_GAIN_2GHZ_XATTEN2_DB         0x00000FC0
-#define AR_PHY_GAIN_2GHZ_XATTEN2_DB_S       6
-#define AR_PHY_GAIN_2GHZ_XATTEN1_DB         0x0000003F
-#define AR_PHY_GAIN_2GHZ_XATTEN1_DB_S       0
-
-#define AR_PHY_CCK_RXCTRL4  0xA21C
-#define AR_PHY_CCK_RXCTRL4_FREQ_EST_SHORT   0x01F80000
-#define AR_PHY_CCK_RXCTRL4_FREQ_EST_SHORT_S 19
-
-#define AR_PHY_DAG_CTRLCCK  0xA228
-#define AR_PHY_DAG_CTRLCCK_EN_RSSI_THR  0x00000200
-#define AR_PHY_DAG_CTRLCCK_RSSI_THR     0x0001FC00
-#define AR_PHY_DAG_CTRLCCK_RSSI_THR_S   10
-
-#define AR_PHY_FORCE_CLKEN_CCK              0xA22C
-#define AR_PHY_FORCE_CLKEN_CCK_MRC_MUX      0x00000040
-
-#define AR_PHY_POWER_TX_RATE3   0xA234
-#define AR_PHY_POWER_TX_RATE4   0xA238
-
-#define AR_PHY_SCRM_SEQ_XR       0xA23C
-#define AR_PHY_HEADER_DETECT_XR  0xA240
-#define AR_PHY_CHIRP_DETECTED_XR 0xA244
-#define AR_PHY_BLUETOOTH         0xA254
-
-#define AR_PHY_TPCRG1   0xA258
-#define AR_PHY_TPCRG1_NUM_PD_GAIN   0x0000c000
-#define AR_PHY_TPCRG1_NUM_PD_GAIN_S 14
-
-#define AR_PHY_TPCRG1_PD_GAIN_1    0x00030000
-#define AR_PHY_TPCRG1_PD_GAIN_1_S  16
-#define AR_PHY_TPCRG1_PD_GAIN_2    0x000C0000
-#define AR_PHY_TPCRG1_PD_GAIN_2_S  18
-#define AR_PHY_TPCRG1_PD_GAIN_3    0x00300000
-#define AR_PHY_TPCRG1_PD_GAIN_3_S  20
-
-#define AR_PHY_TPCRG1_PD_CAL_ENABLE   0x00400000
-#define AR_PHY_TPCRG1_PD_CAL_ENABLE_S 22
-
-#define AR_PHY_TX_PWRCTRL4       0xa264
-#define AR_PHY_TX_PWRCTRL_PD_AVG_VALID     0x00000001
-#define AR_PHY_TX_PWRCTRL_PD_AVG_VALID_S   0
-#define AR_PHY_TX_PWRCTRL_PD_AVG_OUT       0x000001FE
-#define AR_PHY_TX_PWRCTRL_PD_AVG_OUT_S     1
-
-#define AR_PHY_TX_PWRCTRL6_0     0xa270
-#define AR_PHY_TX_PWRCTRL6_1     0xb270
-#define AR_PHY_TX_PWRCTRL_ERR_EST_MODE     0x03000000
-#define AR_PHY_TX_PWRCTRL_ERR_EST_MODE_S   24
-
-#define AR_PHY_TX_PWRCTRL7       0xa274
 #define AR_PHY_TX_PWRCTRL_TX_GAIN_TAB_MAX   0x0007E000
 #define AR_PHY_TX_PWRCTRL_TX_GAIN_TAB_MAX_S 13
-#define AR_PHY_TX_PWRCTRL_INIT_TX_GAIN     0x01F80000
-#define AR_PHY_TX_PWRCTRL_INIT_TX_GAIN_S   19
-
-#define AR_PHY_TX_PWRCTRL9       0xa27C
-#define AR_PHY_TX_DESIRED_SCALE_CCK        0x00007C00
-#define AR_PHY_TX_DESIRED_SCALE_CCK_S      10
-#define AR_PHY_TX_PWRCTRL9_RES_DC_REMOVAL  0x80000000
-#define AR_PHY_TX_PWRCTRL9_RES_DC_REMOVAL_S 31
-
-#define AR_PHY_TX_GAIN_TBL1      0xa300
 #define AR_PHY_TX_GAIN_CLC       0x0000001E
 #define AR_PHY_TX_GAIN_CLC_S     1
 #define AR_PHY_TX_GAIN           0x0007F000
@@ -523,91 +33,6 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
 #define AR_PHY_CLC_Q0        0x0000ffd0
 #define AR_PHY_CLC_Q0_S      5
 
-#define AR_PHY_CH0_TX_PWRCTRL11  0xa398
-#define AR_PHY_CH1_TX_PWRCTRL11  0xb398
-#define AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP   0x0000FC00
-#define AR_PHY_TX_PWRCTRL_OLPC_TEMP_COMP_S 10
-
-#define AR_PHY_VIT_MASK2_M_46_61 0xa3a0
-#define AR_PHY_MASK2_M_31_45     0xa3a4
-#define AR_PHY_MASK2_M_16_30     0xa3a8
-#define AR_PHY_MASK2_M_00_15     0xa3ac
-#define AR_PHY_MASK2_P_15_01     0xa3b8
-#define AR_PHY_MASK2_P_30_16     0xa3bc
-#define AR_PHY_MASK2_P_45_31     0xa3c0
-#define AR_PHY_MASK2_P_61_45     0xa3c4
-#define AR_PHY_SPUR_REG          0x994c
-
-#define AR_PHY_SPUR_REG_MASK_RATE_CNTL       (0xFF << 18)
-#define AR_PHY_SPUR_REG_MASK_RATE_CNTL_S     18
-
-#define AR_PHY_SPUR_REG_ENABLE_MASK_PPM      0x20000
-#define AR_PHY_SPUR_REG_MASK_RATE_SELECT     (0xFF << 9)
-#define AR_PHY_SPUR_REG_MASK_RATE_SELECT_S   9
-#define AR_PHY_SPUR_REG_ENABLE_VIT_SPUR_RSSI 0x100
-#define AR_PHY_SPUR_REG_SPUR_RSSI_THRESH     0x7F
-#define AR_PHY_SPUR_REG_SPUR_RSSI_THRESH_S   0
-
-#define AR_PHY_PILOT_MASK_01_30   0xa3b0
-#define AR_PHY_PILOT_MASK_31_60   0xa3b4
-
-#define AR_PHY_CHANNEL_MASK_01_30 0x99d4
-#define AR_PHY_CHANNEL_MASK_31_60 0x99d8
-
-#define AR_PHY_ANALOG_SWAP      0xa268
-#define AR_PHY_SWAP_ALT_CHAIN   0x00000040
-
-#define AR_PHY_TPCRG5   0xA26C
-#define AR_PHY_TPCRG5_PD_GAIN_OVERLAP       0x0000000F
-#define AR_PHY_TPCRG5_PD_GAIN_OVERLAP_S     0
-#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1    0x000003F0
-#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_1_S  4
-#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2    0x0000FC00
-#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_2_S  10
-#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3    0x003F0000
-#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_3_S  16
-#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4    0x0FC00000
-#define AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_4_S  22
-
-/* Carrier leak calibration control, do it after AGC calibration */
-#define AR_PHY_CL_CAL_CTL       0xA358
-#define AR_PHY_CL_CAL_ENABLE    0x00000002
-#define AR_PHY_PARALLEL_CAL_ENABLE    0x00000001
-
-#define AR_PHY_POWER_TX_RATE5   0xA38C
-#define AR_PHY_POWER_TX_RATE6   0xA390
-
-#define AR_PHY_CAL_CHAINMASK    0xA39C
-
-#define AR_PHY_POWER_TX_SUB     0xA3C8
-#define AR_PHY_POWER_TX_RATE7   0xA3CC
-#define AR_PHY_POWER_TX_RATE8   0xA3D0
-#define AR_PHY_POWER_TX_RATE9   0xA3D4
-
-#define AR_PHY_XPA_CFG  	0xA3D8
-#define AR_PHY_FORCE_XPA_CFG	0x000000001
-#define AR_PHY_FORCE_XPA_CFG_S	0
-
-#define AR_PHY_CH1_CCA          0xa864
-#define AR_PHY_CH1_MINCCA_PWR   0x0FF80000
-#define AR_PHY_CH1_MINCCA_PWR_S 19
-#define AR9280_PHY_CH1_MINCCA_PWR   0x1FF00000
-#define AR9280_PHY_CH1_MINCCA_PWR_S 20
-
-#define AR_PHY_CH2_CCA          0xb864
-#define AR_PHY_CH2_MINCCA_PWR   0x0FF80000
-#define AR_PHY_CH2_MINCCA_PWR_S 19
-
-#define AR_PHY_CH1_EXT_CCA          0xa9bc
-#define AR_PHY_CH1_EXT_MINCCA_PWR   0xFF800000
-#define AR_PHY_CH1_EXT_MINCCA_PWR_S 23
-#define AR9280_PHY_CH1_EXT_MINCCA_PWR   0x01FF0000
-#define AR9280_PHY_CH1_EXT_MINCCA_PWR_S 16
-
-#define AR_PHY_CH2_EXT_CCA          0xb9bc
-#define AR_PHY_CH2_EXT_MINCCA_PWR   0xFF800000
-#define AR_PHY_CH2_EXT_MINCCA_PWR_S 23
-
 #define REG_WRITE_RF_ARRAY(iniarray, regData, regWr) do {               \
 		int r;							\
 		for (r = 0; r < ((iniarray)->ia_rows); r++) {		\
@@ -622,6 +47,7 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
 #define ANTSWAP_AB 0x0001
 #define REDUCE_CHAIN_0 0x00000050
 #define REDUCE_CHAIN_1 0x00000051
+#define AR_PHY_CHIP_ID 0x9818
 
 #define RF_BANK_SETUP(_bank, _iniarray, _col) do {			\
 		int i;							\
-- 
1.6.3.3


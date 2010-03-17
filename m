Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab0CQW2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 18:28:16 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 19/20] ath9k_hw: move ar9002 ANI code to its own file
Date: Wed, 17 Mar 2010 18:28:12 -0400
Message-Id: <1268864893-11428-20-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile     |    1 +
 drivers/net/wireless/ath/ath9k/ani.c        |  341 +-------------------------
 drivers/net/wireless/ath/ath9k/ani.h        |   20 ++
 drivers/net/wireless/ath/ath9k/ar9002_ani.c |  356 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9002_hw.c  |    2 +
 drivers/net/wireless/ath/ath9k/hw-ops.h     |   69 +++++
 drivers/net/wireless/ath/ath9k/hw.h         |   35 +++
 7 files changed, 484 insertions(+), 340 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_ani.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index affbf84..681fc4f 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -18,6 +18,7 @@ ath9k_hw-y:=	hw.o \
 		ar9002_calib.o \
 		ar9002_calib_settings.o \
 		ar9002_btcoex.o \
+		ar9002_ani.o \
 		eeprom.o \
 		eeprom_def.o \
 		eeprom_4k.o \
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 024f8f6..bba9c0b 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -22,6 +22,7 @@
  */
 
 #include "hw.h"
+#include "hw-ops.h"
 
 static int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
 					struct ath9k_channel *chan)
@@ -44,232 +45,6 @@ static int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
 	return 0;
 }
 
-static bool ath9k_hw_ani_control(struct ath_hw *ah,
-				 enum ath9k_ani_cmd cmd, int param)
-{
-	struct ar5416AniState *aniState = ah->curani;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	switch (cmd & ah->ani_function) {
-	case ATH9K_ANI_NOISE_IMMUNITY_LEVEL:{
-		u32 level = param;
-
-		if (level >= ARRAY_SIZE(ah->totalSizeDesired)) {
-			ath_print(common, ATH_DBG_ANI,
-				  "level out of range (%u > %u)\n",
-				  level,
-				  (unsigned)ARRAY_SIZE(ah->totalSizeDesired));
-			return false;
-		}
-
-		REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
-			      AR_PHY_DESIRED_SZ_TOT_DES,
-			      ah->totalSizeDesired[level]);
-		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
-			      AR_PHY_AGC_CTL1_COARSE_LOW,
-			      ah->coarse_low[level]);
-		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
-			      AR_PHY_AGC_CTL1_COARSE_HIGH,
-			      ah->coarse_high[level]);
-		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
-			      AR_PHY_FIND_SIG_FIRPWR,
-			      ah->firpwr[level]);
-
-		if (level > aniState->noiseImmunityLevel)
-			ah->stats.ast_ani_niup++;
-		else if (level < aniState->noiseImmunityLevel)
-			ah->stats.ast_ani_nidown++;
-		aniState->noiseImmunityLevel = level;
-		break;
-	}
-	case ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION:{
-		const int m1ThreshLow[] = { 127, 50 };
-		const int m2ThreshLow[] = { 127, 40 };
-		const int m1Thresh[] = { 127, 0x4d };
-		const int m2Thresh[] = { 127, 0x40 };
-		const int m2CountThr[] = { 31, 16 };
-		const int m2CountThrLow[] = { 63, 48 };
-		u32 on = param ? 1 : 0;
-
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
-			      AR_PHY_SFCORR_LOW_M1_THRESH_LOW,
-			      m1ThreshLow[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
-			      AR_PHY_SFCORR_LOW_M2_THRESH_LOW,
-			      m2ThreshLow[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
-			      AR_PHY_SFCORR_M1_THRESH,
-			      m1Thresh[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
-			      AR_PHY_SFCORR_M2_THRESH,
-			      m2Thresh[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
-			      AR_PHY_SFCORR_M2COUNT_THR,
-			      m2CountThr[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
-			      AR_PHY_SFCORR_LOW_M2COUNT_THR_LOW,
-			      m2CountThrLow[on]);
-
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-			      AR_PHY_SFCORR_EXT_M1_THRESH_LOW,
-			      m1ThreshLow[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-			      AR_PHY_SFCORR_EXT_M2_THRESH_LOW,
-			      m2ThreshLow[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-			      AR_PHY_SFCORR_EXT_M1_THRESH,
-			      m1Thresh[on]);
-		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
-			      AR_PHY_SFCORR_EXT_M2_THRESH,
-			      m2Thresh[on]);
-
-		if (on)
-			REG_SET_BIT(ah, AR_PHY_SFCORR_LOW,
-				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
-		else
-			REG_CLR_BIT(ah, AR_PHY_SFCORR_LOW,
-				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
-
-		if (!on != aniState->ofdmWeakSigDetectOff) {
-			if (on)
-				ah->stats.ast_ani_ofdmon++;
-			else
-				ah->stats.ast_ani_ofdmoff++;
-			aniState->ofdmWeakSigDetectOff = !on;
-		}
-		break;
-	}
-	case ATH9K_ANI_CCK_WEAK_SIGNAL_THR:{
-		const int weakSigThrCck[] = { 8, 6 };
-		u32 high = param ? 1 : 0;
-
-		REG_RMW_FIELD(ah, AR_PHY_CCK_DETECT,
-			      AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK,
-			      weakSigThrCck[high]);
-		if (high != aniState->cckWeakSigThreshold) {
-			if (high)
-				ah->stats.ast_ani_cckhigh++;
-			else
-				ah->stats.ast_ani_ccklow++;
-			aniState->cckWeakSigThreshold = high;
-		}
-		break;
-	}
-	case ATH9K_ANI_FIRSTEP_LEVEL:{
-		const int firstep[] = { 0, 4, 8 };
-		u32 level = param;
-
-		if (level >= ARRAY_SIZE(firstep)) {
-			ath_print(common, ATH_DBG_ANI,
-				  "level out of range (%u > %u)\n",
-				  level,
-				  (unsigned) ARRAY_SIZE(firstep));
-			return false;
-		}
-		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
-			      AR_PHY_FIND_SIG_FIRSTEP,
-			      firstep[level]);
-		if (level > aniState->firstepLevel)
-			ah->stats.ast_ani_stepup++;
-		else if (level < aniState->firstepLevel)
-			ah->stats.ast_ani_stepdown++;
-		aniState->firstepLevel = level;
-		break;
-	}
-	case ATH9K_ANI_SPUR_IMMUNITY_LEVEL:{
-		const int cycpwrThr1[] =
-			{ 2, 4, 6, 8, 10, 12, 14, 16 };
-		u32 level = param;
-
-		if (level >= ARRAY_SIZE(cycpwrThr1)) {
-			ath_print(common, ATH_DBG_ANI,
-				  "level out of range (%u > %u)\n",
-				  level,
-				  (unsigned) ARRAY_SIZE(cycpwrThr1));
-			return false;
-		}
-		REG_RMW_FIELD(ah, AR_PHY_TIMING5,
-			      AR_PHY_TIMING5_CYCPWR_THR1,
-			      cycpwrThr1[level]);
-		if (level > aniState->spurImmunityLevel)
-			ah->stats.ast_ani_spurup++;
-		else if (level < aniState->spurImmunityLevel)
-			ah->stats.ast_ani_spurdown++;
-		aniState->spurImmunityLevel = level;
-		break;
-	}
-	case ATH9K_ANI_PRESENT:
-		break;
-	default:
-		ath_print(common, ATH_DBG_ANI,
-			  "invalid cmd %u\n", cmd);
-		return false;
-	}
-
-	ath_print(common, ATH_DBG_ANI, "ANI parameters:\n");
-	ath_print(common, ATH_DBG_ANI,
-		  "noiseImmunityLevel=%d, spurImmunityLevel=%d, "
-		  "ofdmWeakSigDetectOff=%d\n",
-		  aniState->noiseImmunityLevel,
-		  aniState->spurImmunityLevel,
-		  !aniState->ofdmWeakSigDetectOff);
-	ath_print(common, ATH_DBG_ANI,
-		  "cckWeakSigThreshold=%d, "
-		  "firstepLevel=%d, listenTime=%d\n",
-		  aniState->cckWeakSigThreshold,
-		  aniState->firstepLevel,
-		  aniState->listenTime);
-	ath_print(common, ATH_DBG_ANI,
-		"cycleCount=%d, ofdmPhyErrCount=%d, cckPhyErrCount=%d\n\n",
-		aniState->cycleCount,
-		aniState->ofdmPhyErrCount,
-		aniState->cckPhyErrCount);
-
-	return true;
-}
-
-static void ath9k_hw_update_mibstats(struct ath_hw *ah,
-				     struct ath9k_mib_stats *stats)
-{
-	stats->ackrcv_bad += REG_READ(ah, AR_ACK_FAIL);
-	stats->rts_bad += REG_READ(ah, AR_RTS_FAIL);
-	stats->fcs_bad += REG_READ(ah, AR_FCS_FAIL);
-	stats->rts_good += REG_READ(ah, AR_RTS_OK);
-	stats->beacons += REG_READ(ah, AR_BEACON_CNT);
-}
-
-/*
- * These masks are used by the hardware to know which
- * type of phy errors to include on their error counts.
- * We use one counter for OFDM phy timing errors and the
- * other for CCK phy timing errors only.
- */
-static void ath9k_hw_update_phy_err_masks(struct ath_hw *ah)
-{
-	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
-	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
-}
-
-static void ath9k_hw_update_phy_err1_count(struct ath_hw *ah,
-					   u32 err_count,
-					   bool reset_mask)
-{
-	REG_WRITE(ah, AR_PHY_ERR_1, err_count);
-
-	if (reset_mask)
-		REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
-}
-
-static void ath9k_hw_update_phy_err2_count(struct ath_hw *ah,
-					   u32 err_count,
-					   bool reset_mask)
-{
-	REG_WRITE(ah, AR_PHY_ERR_2, err_count);
-
-	if (reset_mask)
-		REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
-}
-
 /**
  * ath9k_hw_update_phy_err_count - update phy error counts
  *
@@ -323,26 +98,6 @@ static void ath9k_hw_update_phy_err_count(struct ath_hw *ah,
 	ath9k_hw_update_phy_err2_count(ah, phy_err_count2, reset_masks);
 }
 
-static void ath9k_hw_get_phy_err_count(struct ath_hw *ah,
-				       u32 *phy_err_count1,
-				       u32 *phy_err_count2)
-{
-	*phy_err_count1 = REG_READ(ah, AR_PHY_ERR_1);
-	*phy_err_count2 = REG_READ(ah, AR_PHY_ERR_2);
-}
-
-static void ath9k_hw_get_mib_cycle_counters(struct ath_hw *ah,
-					    u32 *rx_clear_count,
-					    u32 *rx_frame_count,
-					    u32 *tx_frame_count,
-					    u32 *cycle_count)
-{
-	*rx_clear_count = REG_READ(ah, AR_RCCNT);
-	*rx_frame_count = REG_READ(ah, AR_RFCNT);
-	*tx_frame_count = REG_READ(ah, AR_TFCNT);
-	*cycle_count = REG_READ(ah, AR_CCCNT);
-}
-
 static void ath9k_ani_restart(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
@@ -781,100 +536,6 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 }
 EXPORT_SYMBOL(ath9k_hw_ani_monitor);
 
-
-/**
- * ath9k_hw_clear_mib_counters - clears all MIB counters
- *
- * @ah: atheros hardware structure
- *
- * Used to clear all MIB counters for the OFDM and CCK filtered
- * frames and also the clock cycle counters and clock cycles we
- * have spent sleeping. Refer to ath9k_hw_update_phy_err_count()
- * for more documentation on the filtered frames, below we cover
- * the clock cycle counters and sleep cycle counters.
- *
- * 0x8250           32KHz Sleep MIB Count
- * (Int Addr: 0x94, Access, R/W, cold_reset, Clock: clk)
- *       SLPMIB1                 31:0    'h0     bit 31:0   SLPMIB_SLEEP_CNT
- *
- * 0x8254           32KHz Cycle MIB Count
- *        (Int Addr: 0x95, Access, R/W, cold_reset, Clock: clk)
- *        SLPMIB2                 31:0    'h0     bit 31:0   SLPMIB_CYCLE_CNT
- *
- * 0x8258           32KHz Mode MIB Control Status
- *        (Int Addr: 0x96, Access, R/W, cold_reset, Clock: clk)
- *        SLPMIB3                  1:0    'h0     bit 0      SLPMIB_CLR_CNT
- *                                        'h0    bit 1      SLPMIB_PEND
- *
- * The SLPMIB_SLEEP_CNT counts the number of 32KHz clock cycles that
- * the MAC has been asleep.  The SLPMIB_CYCLE_CNT is the counts the
- * absolute number of 32KHz clock cycles.  When the SLPMIB_CYCLE_CNT
- * bit 31 is 1, the sleep MIB interrupt will be asserted.  The
- * SLPMIB_SLEEP_CNT and SLPMIB_CYCLE_CNT are saturating counters when
- * the value of SLPMIB_CYCLE_CNT reaches 0xFFFF_FFFF both counters
- * will stop incrementing.  The SLPMIB_CLR_CNT will clear both the
- * SLPMIB_SLEEP_CNT and SLPMIB_CYCLE_CNT.  During the time that the
- * clearing of these register are pending the SLPMIB_CLR_PEND will
- * be asserted.  SLPMIB_SLEEP_CNT, SLPMIB_CYCLE_CNT, and
- * SLPMIB_CLR_CNT are writable for diagnostic purposes.  Before every
- * read/write, the SLPMIB_PEND bit should be polled to verify any
- * pending write has cleared.
- */
-static void ath9k_hw_clear_mib_counters(struct ath_hw *ah,
-					bool check_clock_cycles)
-{
-	REG_WRITE(ah, AR_FILT_OFDM, 0);
-	REG_WRITE(ah, AR_FILT_CCK, 0);
-
-	if (!check_clock_cycles)
-		return;
-
-	if (!(REG_READ(ah, AR_SLP_MIB_CTRL) & AR_SLP_MIB_PENDING))
-		REG_WRITE(ah, AR_SLP_MIB_CTRL, AR_SLP_MIB_CLEAR);
-}
-
-/**
- * ath9k_hw_mibc_cmd - commands for the MIB control register (MIBC)
- *
- * @ATH9K_HW_MIBC_INIT: initializes the register
- * @ATH9K_HW_MIBC_WARN_TEST: Warning test indicator
- * @ATH9K_HW_MIBC_FREEZE: freeze all counters, useful prior to collecting
- *	the MIB counters.
- * @ATH9K_HW_MIBC_CLEAR: clear all counters, can be used after collecting
- *	the MIB counters.
- * @ATH9K_HW_MIBC_STROBE: MIB counter strobe, can increment every
- *	counter by 1.
- */
-enum ath9k_hw_mibc_cmd {
-	ATH9K_HW_MIBC_INIT = 0,
-	ATH9K_HW_MIBC_WARN_TEST,
-	ATH9K_HW_MIBC_FREEZE,
-	ATH9K_HW_MIBC_CLEAR,
-	ATH9K_HW_MIBC_STROBE,
-};
-
-static void ath9k_hw_send_mibc_cmd(struct ath_hw *ah,
-				   enum ath9k_hw_mibc_cmd cmd)
-{
-	switch (cmd) {
-	case ATH9K_HW_MIBC_INIT:
-		REG_WRITE(ah, AR_MIBC, 0);
-		break;
-	case ATH9K_HW_MIBC_WARN_TEST: /* unused */
-		REG_WRITE(ah, AR_MIBC, AR_MIBC_COW);
-		break;
-	case ATH9K_HW_MIBC_FREEZE:
-		REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC);
-		break;
-	case ATH9K_HW_MIBC_CLEAR:
-		REG_WRITE(ah, AR_MIBC, AR_MIBC_CMC);
-		break;
-	case ATH9K_HW_MIBC_STROBE: /* unused */
-		REG_WRITE(ah, AR_MIBC, AR_MIBC_MCS);
-		break;
-	}
-}
-
 void ath9k_enable_mib_counters(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 01c07e2..f9879e4 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -40,6 +40,26 @@
 #define HAL_SPUR_IMMUNE_MAX               7
 #define HAL_FIRST_STEP_MAX                2
 
+/**
+ * ath9k_hw_mibc_cmd - commands for the MIB control register (MIBC)
+ *
+ * @ATH9K_HW_MIBC_INIT: initializes the register
+ * @ATH9K_HW_MIBC_WARN_TEST: Warning test indicator
+ * @ATH9K_HW_MIBC_FREEZE: freeze all counters, useful prior to collecting
+ *	the MIB counters.
+ * @ATH9K_HW_MIBC_CLEAR: clear all counters, can be used after collecting
+ *	the MIB counters.
+ * @ATH9K_HW_MIBC_STROBE: MIB counter strobe, can increment every
+ *	counter by 1.
+ */
+enum ath9k_hw_mibc_cmd {
+	ATH9K_HW_MIBC_INIT = 0,
+	ATH9K_HW_MIBC_WARN_TEST,
+	ATH9K_HW_MIBC_FREEZE,
+	ATH9K_HW_MIBC_CLEAR,
+	ATH9K_HW_MIBC_STROBE,
+};
+
 enum ath9k_ani_cmd {
 	ATH9K_ANI_PRESENT = 0x1,
 	ATH9K_ANI_NOISE_IMMUNITY_LEVEL = 0x2,
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_ani.c b/drivers/net/wireless/ath/ath9k/ar9002_ani.c
new file mode 100644
index 0000000..39ede2d
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/ar9002_ani.c
@@ -0,0 +1,356 @@
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
+/*
+ * Adaptive Noise Immunity for the AR5008, AR9001 and AR9002 family
+ */
+
+#include "hw.h"
+
+static bool ar9002_hw_ani_control(struct ath_hw *ah,
+				  enum ath9k_ani_cmd cmd,
+				  int param)
+{
+	struct ar5416AniState *aniState = ah->curani;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	switch (cmd & ah->ani_function) {
+	case ATH9K_ANI_NOISE_IMMUNITY_LEVEL:{
+		u32 level = param;
+
+		if (level >= ARRAY_SIZE(ah->totalSizeDesired)) {
+			ath_print(common, ATH_DBG_ANI,
+				  "level out of range (%u > %u)\n",
+				  level,
+				  (unsigned)ARRAY_SIZE(ah->totalSizeDesired));
+			return false;
+		}
+
+		REG_RMW_FIELD(ah, AR_PHY_DESIRED_SZ,
+			      AR_PHY_DESIRED_SZ_TOT_DES,
+			      ah->totalSizeDesired[level]);
+		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
+			      AR_PHY_AGC_CTL1_COARSE_LOW,
+			      ah->coarse_low[level]);
+		REG_RMW_FIELD(ah, AR_PHY_AGC_CTL1,
+			      AR_PHY_AGC_CTL1_COARSE_HIGH,
+			      ah->coarse_high[level]);
+		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
+			      AR_PHY_FIND_SIG_FIRPWR,
+			      ah->firpwr[level]);
+
+		if (level > aniState->noiseImmunityLevel)
+			ah->stats.ast_ani_niup++;
+		else if (level < aniState->noiseImmunityLevel)
+			ah->stats.ast_ani_nidown++;
+		aniState->noiseImmunityLevel = level;
+		break;
+	}
+	case ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION:{
+		const int m1ThreshLow[] = { 127, 50 };
+		const int m2ThreshLow[] = { 127, 40 };
+		const int m1Thresh[] = { 127, 0x4d };
+		const int m2Thresh[] = { 127, 0x40 };
+		const int m2CountThr[] = { 31, 16 };
+		const int m2CountThrLow[] = { 63, 48 };
+		u32 on = param ? 1 : 0;
+
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M1_THRESH_LOW,
+			      m1ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M2_THRESH_LOW,
+			      m2ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M1_THRESH,
+			      m1Thresh[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M2_THRESH,
+			      m2Thresh[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR,
+			      AR_PHY_SFCORR_M2COUNT_THR,
+			      m2CountThr[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_LOW,
+			      AR_PHY_SFCORR_LOW_M2COUNT_THR_LOW,
+			      m2CountThrLow[on]);
+
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M1_THRESH_LOW,
+			      m1ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M2_THRESH_LOW,
+			      m2ThreshLow[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M1_THRESH,
+			      m1Thresh[on]);
+		REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+			      AR_PHY_SFCORR_EXT_M2_THRESH,
+			      m2Thresh[on]);
+
+		if (on)
+			REG_SET_BIT(ah, AR_PHY_SFCORR_LOW,
+				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
+		else
+			REG_CLR_BIT(ah, AR_PHY_SFCORR_LOW,
+				    AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW);
+
+		if (!on != aniState->ofdmWeakSigDetectOff) {
+			if (on)
+				ah->stats.ast_ani_ofdmon++;
+			else
+				ah->stats.ast_ani_ofdmoff++;
+			aniState->ofdmWeakSigDetectOff = !on;
+		}
+		break;
+	}
+	case ATH9K_ANI_CCK_WEAK_SIGNAL_THR:{
+		const int weakSigThrCck[] = { 8, 6 };
+		u32 high = param ? 1 : 0;
+
+		REG_RMW_FIELD(ah, AR_PHY_CCK_DETECT,
+			      AR_PHY_CCK_DETECT_WEAK_SIG_THR_CCK,
+			      weakSigThrCck[high]);
+		if (high != aniState->cckWeakSigThreshold) {
+			if (high)
+				ah->stats.ast_ani_cckhigh++;
+			else
+				ah->stats.ast_ani_ccklow++;
+			aniState->cckWeakSigThreshold = high;
+		}
+		break;
+	}
+	case ATH9K_ANI_FIRSTEP_LEVEL:{
+		const int firstep[] = { 0, 4, 8 };
+		u32 level = param;
+
+		if (level >= ARRAY_SIZE(firstep)) {
+			ath_print(common, ATH_DBG_ANI,
+				  "level out of range (%u > %u)\n",
+				  level,
+				  (unsigned) ARRAY_SIZE(firstep));
+			return false;
+		}
+		REG_RMW_FIELD(ah, AR_PHY_FIND_SIG,
+			      AR_PHY_FIND_SIG_FIRSTEP,
+			      firstep[level]);
+		if (level > aniState->firstepLevel)
+			ah->stats.ast_ani_stepup++;
+		else if (level < aniState->firstepLevel)
+			ah->stats.ast_ani_stepdown++;
+		aniState->firstepLevel = level;
+		break;
+	}
+	case ATH9K_ANI_SPUR_IMMUNITY_LEVEL:{
+		const int cycpwrThr1[] =
+			{ 2, 4, 6, 8, 10, 12, 14, 16 };
+		u32 level = param;
+
+		if (level >= ARRAY_SIZE(cycpwrThr1)) {
+			ath_print(common, ATH_DBG_ANI,
+				  "level out of range (%u > %u)\n",
+				  level,
+				  (unsigned) ARRAY_SIZE(cycpwrThr1));
+			return false;
+		}
+		REG_RMW_FIELD(ah, AR_PHY_TIMING5,
+			      AR_PHY_TIMING5_CYCPWR_THR1,
+			      cycpwrThr1[level]);
+		if (level > aniState->spurImmunityLevel)
+			ah->stats.ast_ani_spurup++;
+		else if (level < aniState->spurImmunityLevel)
+			ah->stats.ast_ani_spurdown++;
+		aniState->spurImmunityLevel = level;
+		break;
+	}
+	case ATH9K_ANI_PRESENT:
+		break;
+	default:
+		ath_print(common, ATH_DBG_ANI,
+			  "invalid cmd %u\n", cmd);
+		return false;
+	}
+
+	ath_print(common, ATH_DBG_ANI, "ANI parameters:\n");
+	ath_print(common, ATH_DBG_ANI,
+		  "noiseImmunityLevel=%d, spurImmunityLevel=%d, "
+		  "ofdmWeakSigDetectOff=%d\n",
+		  aniState->noiseImmunityLevel,
+		  aniState->spurImmunityLevel,
+		  !aniState->ofdmWeakSigDetectOff);
+	ath_print(common, ATH_DBG_ANI,
+		  "cckWeakSigThreshold=%d, "
+		  "firstepLevel=%d, listenTime=%d\n",
+		  aniState->cckWeakSigThreshold,
+		  aniState->firstepLevel,
+		  aniState->listenTime);
+	ath_print(common, ATH_DBG_ANI,
+		"cycleCount=%d, ofdmPhyErrCount=%d, cckPhyErrCount=%d\n\n",
+		aniState->cycleCount,
+		aniState->ofdmPhyErrCount,
+		aniState->cckPhyErrCount);
+
+	return true;
+}
+
+static void ar9002_hw_update_mibstats(struct ath_hw *ah,
+				      struct ath9k_mib_stats *stats)
+{
+	stats->ackrcv_bad += REG_READ(ah, AR_ACK_FAIL);
+	stats->rts_bad += REG_READ(ah, AR_RTS_FAIL);
+	stats->fcs_bad += REG_READ(ah, AR_FCS_FAIL);
+	stats->rts_good += REG_READ(ah, AR_RTS_OK);
+	stats->beacons += REG_READ(ah, AR_BEACON_CNT);
+}
+
+/*
+ * These masks are used by the hardware to know which
+ * type of phy errors to include on their error counts.
+ * We use one counter for OFDM phy timing errors and the
+ * other for CCK phy timing errors only.
+ */
+static void ar9002_hw_update_phy_err_masks(struct ath_hw *ah)
+{
+	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
+	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
+}
+
+static void ar9002_hw_update_phy_err1_count(struct ath_hw *ah,
+					    u32 err_count,
+					    bool reset_mask)
+{
+	REG_WRITE(ah, AR_PHY_ERR_1, err_count);
+
+	if (reset_mask)
+		REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
+}
+
+static void ar9002_hw_update_phy_err2_count(struct ath_hw *ah,
+					    u32 err_count,
+					    bool reset_mask)
+{
+	REG_WRITE(ah, AR_PHY_ERR_2, err_count);
+
+	if (reset_mask)
+		REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
+}
+
+static void ar9002_hw_get_phy_err_count(struct ath_hw *ah,
+					u32 *phy_err_count1,
+					u32 *phy_err_count2)
+{
+	*phy_err_count1 = REG_READ(ah, AR_PHY_ERR_1);
+	*phy_err_count2 = REG_READ(ah, AR_PHY_ERR_2);
+}
+
+static void ar9002_hw_get_mib_cycle_counters(struct ath_hw *ah,
+					     u32 *rx_clear_count,
+					     u32 *rx_frame_count,
+					     u32 *tx_frame_count,
+					     u32 *cycle_count)
+{
+	*rx_clear_count = REG_READ(ah, AR_RCCNT);
+	*rx_frame_count = REG_READ(ah, AR_RFCNT);
+	*tx_frame_count = REG_READ(ah, AR_TFCNT);
+	*cycle_count = REG_READ(ah, AR_CCCNT);
+}
+
+/**
+ * ar9002_hw_clear_mib_counters - clears all MIB counters
+ *
+ * @ah: atheros hardware structure
+ *
+ * Used to clear all MIB counters for the OFDM and CCK filtered
+ * frames and also the clock cycle counters and clock cycles we
+ * have spent sleeping. Refer to ath9k_hw_update_phy_err_count()
+ * for more documentation on the filtered frames, below we cover
+ * the clock cycle counters and sleep cycle counters.
+ *
+ * 0x8250           32KHz Sleep MIB Count
+ * (Int Addr: 0x94, Access, R/W, cold_reset, Clock: clk)
+ *       SLPMIB1                 31:0    'h0     bit 31:0   SLPMIB_SLEEP_CNT
+ *
+ * 0x8254           32KHz Cycle MIB Count
+ *        (Int Addr: 0x95, Access, R/W, cold_reset, Clock: clk)
+ *        SLPMIB2                 31:0    'h0     bit 31:0   SLPMIB_CYCLE_CNT
+ *
+ * 0x8258           32KHz Mode MIB Control Status
+ *        (Int Addr: 0x96, Access, R/W, cold_reset, Clock: clk)
+ *        SLPMIB3                  1:0    'h0     bit 0      SLPMIB_CLR_CNT
+ *                                        'h0    bit 1      SLPMIB_PEND
+ *
+ * The SLPMIB_SLEEP_CNT counts the number of 32KHz clock cycles that
+ * the MAC has been asleep.  The SLPMIB_CYCLE_CNT is the counts the
+ * absolute number of 32KHz clock cycles.  When the SLPMIB_CYCLE_CNT
+ * bit 31 is 1, the sleep MIB interrupt will be asserted.  The
+ * SLPMIB_SLEEP_CNT and SLPMIB_CYCLE_CNT are saturating counters when
+ * the value of SLPMIB_CYCLE_CNT reaches 0xFFFF_FFFF both counters
+ * will stop incrementing.  The SLPMIB_CLR_CNT will clear both the
+ * SLPMIB_SLEEP_CNT and SLPMIB_CYCLE_CNT.  During the time that the
+ * clearing of these register are pending the SLPMIB_CLR_PEND will
+ * be asserted.  SLPMIB_SLEEP_CNT, SLPMIB_CYCLE_CNT, and
+ * SLPMIB_CLR_CNT are writable for diagnostic purposes.  Before every
+ * read/write, the SLPMIB_PEND bit should be polled to verify any
+ * pending write has cleared.
+ */
+static void ar9002_hw_clear_mib_counters(struct ath_hw *ah,
+					 bool check_clock_cycles)
+{
+	REG_WRITE(ah, AR_FILT_OFDM, 0);
+	REG_WRITE(ah, AR_FILT_CCK, 0);
+
+	if (!check_clock_cycles)
+		return;
+
+	if (!(REG_READ(ah, AR_SLP_MIB_CTRL) & AR_SLP_MIB_PENDING))
+		REG_WRITE(ah, AR_SLP_MIB_CTRL, AR_SLP_MIB_CLEAR);
+}
+
+static void ar9002_hw_send_mibc_cmd(struct ath_hw *ah,
+				    enum ath9k_hw_mibc_cmd cmd)
+{
+	switch (cmd) {
+	case ATH9K_HW_MIBC_INIT:
+		REG_WRITE(ah, AR_MIBC, 0);
+		break;
+	case ATH9K_HW_MIBC_WARN_TEST: /* unused */
+		REG_WRITE(ah, AR_MIBC, AR_MIBC_COW);
+		break;
+	case ATH9K_HW_MIBC_FREEZE:
+		REG_WRITE(ah, AR_MIBC, AR_MIBC_FMC);
+		break;
+	case ATH9K_HW_MIBC_CLEAR:
+		REG_WRITE(ah, AR_MIBC, AR_MIBC_CMC);
+		break;
+	case ATH9K_HW_MIBC_STROBE: /* unused */
+		REG_WRITE(ah, AR_MIBC, AR_MIBC_MCS);
+		break;
+	}
+}
+
+void ar9002_hw_attach_ani_ops(struct ath_hw *ah)
+{
+	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+
+	priv_ops->ani_control = &ar9002_hw_ani_control;
+	priv_ops->update_mibstats = &ar9002_hw_update_mibstats;
+	priv_ops->update_phy_err_masks = &ar9002_hw_update_phy_err_masks;
+	priv_ops->update_phy_err1_count = &ar9002_hw_update_phy_err1_count;
+	priv_ops->update_phy_err2_count = &ar9002_hw_update_phy_err2_count;
+	priv_ops->get_phy_err_count = &ar9002_hw_get_phy_err_count;
+	priv_ops->get_mib_cycle_counters = &ar9002_hw_get_mib_cycle_counters;
+	priv_ops->clear_mib_counters = &ar9002_hw_clear_mib_counters;
+	priv_ops->send_mibc_cmd = &ar9002_hw_send_mibc_cmd;
+}
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 8e5a07d..2356611 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -20,6 +20,7 @@
 #include "ar9002_initvals.h"
 
 extern void ar9002_hw_attach_btcoex_ops(struct ath_hw *ah);
+extern void ar9002_hw_attach_ani_ops(struct ath_hw *ah);
 
 static void ar9002_hw_disablepcie(struct ath_hw *ah)
 {
@@ -815,5 +816,6 @@ void ar9002_hw_attach_ops(struct ath_hw *ah)
 
 	ar9002_hw_attach_calib_ops(ah);
 	ar9002_hw_attach_btcoex_ops(ah);
+	ar9002_hw_attach_ani_ops(ah);
 }
 EXPORT_SYMBOL(ar9002_hw_attach_ops);
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 3e4f49f..006e260 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -163,4 +163,73 @@ static inline void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 	ath9k_hw_ops(ah)->btcoex_disable(ah);
 }
 
+/* ANI ops */
+
+static inline bool ath9k_hw_ani_control(struct ath_hw *ah,
+					enum ath9k_ani_cmd cmd,
+					int param)
+{
+	return ath9k_hw_private_ops(ah)->ani_control(ah, cmd, param);
+}
+
+static inline void ath9k_hw_update_mibstats(struct ath_hw *ah,
+					    struct ath9k_mib_stats *stats)
+{
+	ath9k_hw_private_ops(ah)->update_mibstats(ah, stats);
+}
+
+static inline void ath9k_hw_update_phy_err_masks(struct ath_hw *ah)
+{
+	ath9k_hw_private_ops(ah)->update_phy_err_masks(ah);
+}
+
+static inline void ath9k_hw_update_phy_err1_count(struct ath_hw *ah,
+						  u32 err_count,
+						  bool reset_mask)
+{
+	ath9k_hw_private_ops(ah)->update_phy_err1_count(ah, err_count,
+							reset_mask);
+}
+
+static inline void ath9k_hw_update_phy_err2_count(struct ath_hw *ah,
+						  u32 err_count,
+						  bool reset_mask)
+{
+	ath9k_hw_private_ops(ah)->update_phy_err2_count(ah, err_count,
+							reset_mask);
+}
+
+static inline void ath9k_hw_get_phy_err_count(struct ath_hw *ah,
+					      u32 *phy_err_count1,
+					      u32 *phy_err_count2)
+{
+	ath9k_hw_private_ops(ah)->get_phy_err_count(ah, phy_err_count1,
+						    phy_err_count2);
+}
+
+static inline void ath9k_hw_get_mib_cycle_counters(struct ath_hw *ah,
+						   u32 *rx_clear_count,
+						   u32 *rx_frame_count,
+						   u32 *tx_frame_count,
+						   u32 *cycle_count)
+{
+	ath9k_hw_private_ops(ah)->get_mib_cycle_counters(ah,
+							 rx_clear_count,
+							 rx_frame_count,
+							 tx_frame_count,
+							 cycle_count);
+}
+
+static inline void ath9k_hw_clear_mib_counters(struct ath_hw *ah,
+					       bool check_clock_cycles)
+{
+	ath9k_hw_private_ops(ah)->clear_mib_counters(ah, check_clock_cycles);
+}
+
+static inline void ath9k_hw_send_mibc_cmd(struct ath_hw *ah,
+					  enum ath9k_hw_mibc_cmd cmd)
+{
+	ath9k_hw_private_ops(ah)->send_mibc_cmd(ah, cmd);
+}
+
 #endif /* ATH9K_HW_OPS_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ed137a8..259761d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -469,6 +469,16 @@ struct ath_gen_timer_table {
  * @btcoex_supported: whether or not bluetooth coexistence is supported
  * @btcoex_enable_2wire:
  * @btcoex_enable_3wire:
+ *
+ * @ani_control:
+ * @update_mibstats:
+ * @update_phy_err_masks:
+ * @update_phy_err1_count:
+ * @update_phy_err2_count:
+ * @get_phy_err_count:
+ * @get_mib_cycle_counters:
+ * @clear_mib_counters:
+ * @send_mibc_cmd:
  */
 struct ath_hw_private_ops {
 	/* General hardware ops */
@@ -499,6 +509,31 @@ struct ath_hw_private_ops {
 	bool (*btcoex_supported)(struct ath_hw *ah);
 	void (*btcoex_enable_2wire)(struct ath_hw *ah);
 	void (*btcoex_enable_3wire)(struct ath_hw *ah);
+
+	/* ANI */
+	bool (*ani_control)(struct ath_hw *ah,
+			    enum ath9k_ani_cmd cmd, int param);
+	void (*update_mibstats)(struct ath_hw *ah,
+				struct ath9k_mib_stats *stats);
+	void (*update_phy_err_masks)(struct ath_hw *ah);
+	void (*update_phy_err1_count)(struct ath_hw *ah,
+				      u32 err_count,
+				      bool reset_mask);
+	void (*update_phy_err2_count)(struct ath_hw *ah,
+				      u32 err_count,
+				      bool reset_mask);
+	void (*get_phy_err_count)(struct ath_hw *ah,
+				  u32 *phy_err_count1,
+				  u32 *phy_err_count2);
+	void (*get_mib_cycle_counters)(struct ath_hw *ah,
+				       u32 *rx_clear_count,
+				       u32 *rx_frame_count,
+				       u32 *tx_frame_count,
+				       u32 *cycle_count);
+	void (*clear_mib_counters)(struct ath_hw *ah,
+				   bool check_clock_cycles);
+	void (*send_mibc_cmd)(struct ath_hw *ah,
+			      enum ath9k_hw_mibc_cmd cmd);
 };
 
 /**
-- 
1.6.3.3


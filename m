Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42430 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab0LKXvj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Dec 2010 18:51:39 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 2/8] ath9k_hw: clean up duplicate and unnused eeprom related defines
Date: Sun, 12 Dec 2010 00:51:08 +0100
Message-Id: <1292111474-70939-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292111474-70939-1-git-send-email-nbd@openwrt.org>
References: <1292111474-70939-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR*_MAX_RATE_POWER => MAX_RATE_POWER
AR*_EEPROM_MODAL_SPURS => AR_EEPROM_MODAL_SPURS
AR*_OPFLAGS_* => AR5416_OPFLAGS_*
...

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   22 +++++-----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |   37 +----------------
 drivers/net/wireless/ath/ath9k/eeprom.c        |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.h        |   45 ++++---------------
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |   36 ++++++++--------
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |   54 ++++++++++++------------
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |   18 ++++----
 drivers/net/wireless/ath/ath9k/hw.h            |    1 -
 8 files changed, 77 insertions(+), 138 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 1f5aa51..2fc3260 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -72,7 +72,7 @@ static const struct ar9300_eeprom ar9300_default = {
 		.regDmn = { LE16(0), LE16(0x1f) },
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
-			.opFlags = AR9300_OPFLAGS_11G | AR9300_OPFLAGS_11A,
+			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
 			.eepMisc = 0,
 		},
 		.rfSilent = 0,
@@ -649,7 +649,7 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		.regDmn = { LE16(0), LE16(0x1f) },
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
-			.opFlags = AR9300_OPFLAGS_11G | AR9300_OPFLAGS_11A,
+			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
 			.eepMisc = 0,
 		},
 		.rfSilent = 0,
@@ -1227,7 +1227,7 @@ static const struct ar9300_eeprom ar9300_h112 = {
 		.regDmn = { LE16(0), LE16(0x1f) },
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
-			.opFlags = AR9300_OPFLAGS_11G | AR9300_OPFLAGS_11A,
+			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
 			.eepMisc = 0,
 		},
 		.rfSilent = 0,
@@ -1805,7 +1805,7 @@ static const struct ar9300_eeprom ar9300_x112 = {
 		.regDmn = { LE16(0), LE16(0x1f) },
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
-			.opFlags = AR9300_OPFLAGS_11G | AR9300_OPFLAGS_11A,
+			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
 			.eepMisc = 0,
 		},
 		.rfSilent = 0,
@@ -2382,7 +2382,7 @@ static const struct ar9300_eeprom ar9300_h116 = {
 		.regDmn = { LE16(0), LE16(0x1f) },
 		.txrxMask =  0x33, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
-			.opFlags = AR9300_OPFLAGS_11G | AR9300_OPFLAGS_11A,
+			.opFlags = AR5416_OPFLAGS_11G | AR5416_OPFLAGS_11A,
 			.eepMisc = 0,
 		},
 		.rfSilent = 0,
@@ -2974,7 +2974,7 @@ static const struct ar9300_eeprom *ar9003_eeprom_struct_find_by_id(int id)
 
 static u16 ath9k_hw_fbin2freq(u8 fbin, bool is2GHz)
 {
-	if (fbin == AR9300_BCHAN_UNUSED)
+	if (fbin == AR5416_BCHAN_UNUSED)
 		return fbin;
 
 	return (u16) ((is2GHz) ? (2300 + fbin) : (4800 + 5 * fbin));
@@ -4485,7 +4485,7 @@ static u16 ar9003_hw_get_indirect_edge_power(struct ar9300_eeprom *eep,
 			return CTL_EDGE_TPOWER(ctl_5g[idx].ctlEdges[edge - 1]);
 	}
 
-	return AR9300_MAX_RATE_POWER;
+	return MAX_RATE_POWER;
 }
 
 /*
@@ -4494,7 +4494,7 @@ static u16 ar9003_hw_get_indirect_edge_power(struct ar9300_eeprom *eep,
 static u16 ar9003_hw_get_max_edge_power(struct ar9300_eeprom *eep,
 					u16 freq, int idx, bool is2GHz)
 {
-	u16 twiceMaxEdgePower = AR9300_MAX_RATE_POWER;
+	u16 twiceMaxEdgePower = MAX_RATE_POWER;
 	u8 *ctl_freqbin = is2GHz ?
 		&eep->ctl_freqbin_2G[idx][0] :
 		&eep->ctl_freqbin_5G[idx][0];
@@ -4504,7 +4504,7 @@ static u16 ar9003_hw_get_max_edge_power(struct ar9300_eeprom *eep,
 
 	/* Get the edge power */
 	for (edge = 0;
-	     (edge < num_edges) && (ctl_freqbin[edge] != AR9300_BCHAN_UNUSED);
+	     (edge < num_edges) && (ctl_freqbin[edge] != AR5416_BCHAN_UNUSED);
 	     edge++) {
 		/*
 		 * If there's an exact channel match or an inband flag set
@@ -4542,9 +4542,9 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ar9300_eeprom *pEepData = &ah->eeprom.ar9300_eep;
-	u16 twiceMaxEdgePower = AR9300_MAX_RATE_POWER;
+	u16 twiceMaxEdgePower = MAX_RATE_POWER;
 	static const u16 tpScaleReductionTable[5] = {
-		0, 3, 6, 9, AR9300_MAX_RATE_POWER
+		0, 3, 6, 9, MAX_RATE_POWER
 	};
 	int i;
 	int16_t  twiceLargestAntenna;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 3350321..620821e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -20,48 +20,17 @@
 /* #define AR9300_NUM_CTLS              21 */
 #define AR9300_NUM_CTLS_5G           9
 #define AR9300_NUM_CTLS_2G           12
-#define AR9300_CTL_MODE_M            0xF
 #define AR9300_NUM_BAND_EDGES_5G     8
 #define AR9300_NUM_BAND_EDGES_2G     4
-#define AR9300_NUM_PD_GAINS          4
-#define AR9300_PD_GAINS_IN_MASK      4
-#define AR9300_PD_GAIN_ICEPTS        5
-#define AR9300_EEPROM_MODAL_SPURS    5
-#define AR9300_MAX_RATE_POWER        63
-#define AR9300_NUM_PDADC_VALUES      128
-#define AR9300_NUM_RATES             16
-#define AR9300_BCHAN_UNUSED          0xFF
-#define AR9300_MAX_PWR_RANGE_IN_HALF_DB 64
-#define AR9300_OPFLAGS_11A           0x01
-#define AR9300_OPFLAGS_11G           0x02
-#define AR9300_OPFLAGS_5G_HT40       0x04
-#define AR9300_OPFLAGS_2G_HT40       0x08
-#define AR9300_OPFLAGS_5G_HT20       0x10
-#define AR9300_OPFLAGS_2G_HT20       0x20
 #define AR9300_EEPMISC_BIG_ENDIAN    0x01
 #define AR9300_EEPMISC_WOW           0x02
 #define AR9300_CUSTOMER_DATA_SIZE    20
 
-#define FREQ2FBIN(x, y) ((y) ? ((x) - 2300) : (((x) - 4800) / 5))
 #define FBIN2FREQ(x, y) ((y) ? (2300 + x) : (4800 + 5 * x))
 #define AR9300_MAX_CHAINS            3
 #define AR9300_ANT_16S               25
 #define AR9300_FUTURE_MODAL_SZ       6
 
-#define AR9300_NUM_ANT_CHAIN_FIELDS     7
-#define AR9300_NUM_ANT_COMMON_FIELDS    4
-#define AR9300_SIZE_ANT_CHAIN_FIELD     3
-#define AR9300_SIZE_ANT_COMMON_FIELD    4
-#define AR9300_ANT_CHAIN_MASK           0x7
-#define AR9300_ANT_COMMON_MASK          0xf
-#define AR9300_CHAIN_0_IDX              0
-#define AR9300_CHAIN_1_IDX              1
-#define AR9300_CHAIN_2_IDX              2
-
-#define AR928X_NUM_ANT_CHAIN_FIELDS     6
-#define AR928X_SIZE_ANT_CHAIN_FIELD     2
-#define AR928X_ANT_CHAIN_MASK           0x3
-
 /* Delta from which to start power to pdadc table */
 /* This offset is used in both open loop and closed loop power control
  * schemes. In open loop power control, it is not really needed, but for
@@ -71,12 +40,8 @@
  */
 #define AR9300_PWR_TABLE_OFFSET  0
 
-/* enable flags for voltage and temp compensation */
-#define ENABLE_TEMP_COMPENSATION 0x01
-#define ENABLE_VOLT_COMPENSATION 0x02
 /* byte addressable */
 #define AR9300_EEPROM_SIZE (16*1024)
-#define FIXED_CCA_THRESHOLD 15
 
 #define AR9300_BASE_ADDR_4K 0xfff
 #define AR9300_BASE_ADDR 0x3ff
@@ -226,7 +191,7 @@ struct ar9300_modal_eep_header {
 	int8_t tempSlope;
 	int8_t voltSlope;
 	/* spur channels in usual fbin coding format */
-	u8 spurChans[AR9300_EEPROM_MODAL_SPURS];
+	u8 spurChans[AR_EEPROM_MODAL_SPURS];
 	/* 3  Check if the register is per chain */
 	int8_t noiseFloorThreshCh[AR9300_MAX_CHAINS];
 	u8 ob[AR9300_MAX_CHAINS];
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index fda533c..3d99b6c 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -234,7 +234,7 @@ void ath9k_hw_get_target_powers(struct ath_hw *ah,
 u16 ath9k_hw_get_max_edge_power(u16 freq, struct cal_ctl_edges *pRdEdgesPower,
 				bool is2GHz, int num_band_edges)
 {
-	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+	u16 twiceMaxEdgePower = MAX_RATE_POWER;
 	int i;
 
 	for (i = 0; (i < num_band_edges) &&
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 8b9885b..833dd0c 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -17,6 +17,8 @@
 #ifndef EEPROM_H
 #define EEPROM_H
 
+#define AR_EEPROM_MODAL_SPURS   5
+
 #include "../ath.h"
 #include <net/cfg80211.h>
 #include "ar9003_eeprom.h"
@@ -149,8 +151,6 @@
 #define AR5416_NUM_PD_GAINS             4
 #define AR5416_PD_GAINS_IN_MASK         4
 #define AR5416_PD_GAIN_ICEPTS           5
-#define AR5416_EEPROM_MODAL_SPURS       5
-#define AR5416_MAX_RATE_POWER           63
 #define AR5416_NUM_PDADC_VALUES         128
 #define AR5416_BCHAN_UNUSED             0xFF
 #define AR5416_MAX_PWR_RANGE_IN_HALF_DB 64
@@ -175,8 +175,6 @@
 #define AR5416_EEP4K_NUM_CTLS                 12
 #define AR5416_EEP4K_NUM_BAND_EDGES           4
 #define AR5416_EEP4K_NUM_PD_GAINS             2
-#define AR5416_EEP4K_PD_GAINS_IN_MASK         4
-#define AR5416_EEP4K_PD_GAIN_ICEPTS           5
 #define AR5416_EEP4K_MAX_CHAINS               1
 
 #define AR9280_TX_GAIN_TABLE_SIZE 22
@@ -198,35 +196,12 @@
 #define AR9287_NUM_2G_40_TARGET_POWERS  3
 #define AR9287_NUM_CTLS              	12
 #define AR9287_NUM_BAND_EDGES        	4
-#define AR9287_NUM_PD_GAINS             4
-#define AR9287_PD_GAINS_IN_MASK         4
 #define AR9287_PD_GAIN_ICEPTS           1
-#define AR9287_EEPROM_MODAL_SPURS       5
-#define AR9287_MAX_RATE_POWER           63
-#define AR9287_NUM_PDADC_VALUES         128
-#define AR9287_NUM_RATES                16
-#define AR9287_BCHAN_UNUSED             0xFF
-#define AR9287_MAX_PWR_RANGE_IN_HALF_DB 64
-#define AR9287_OPFLAGS_11A              0x01
-#define AR9287_OPFLAGS_11G              0x02
-#define AR9287_OPFLAGS_2G_HT40          0x08
-#define AR9287_OPFLAGS_2G_HT20          0x20
-#define AR9287_OPFLAGS_5G_HT40          0x04
-#define AR9287_OPFLAGS_5G_HT20          0x10
 #define AR9287_EEPMISC_BIG_ENDIAN       0x01
 #define AR9287_EEPMISC_WOW              0x02
 #define AR9287_MAX_CHAINS               2
 #define AR9287_ANT_16S                  32
-#define AR9287_custdatasize             20
-
-#define AR9287_NUM_ANT_CHAIN_FIELDS     6
-#define AR9287_NUM_ANT_COMMON_FIELDS    4
-#define AR9287_SIZE_ANT_CHAIN_FIELD     2
-#define AR9287_SIZE_ANT_COMMON_FIELD    4
-#define AR9287_ANT_CHAIN_MASK           0x3
-#define AR9287_ANT_COMMON_MASK          0xf
-#define AR9287_CHAIN_0_IDX              0
-#define AR9287_CHAIN_1_IDX              1
+
 #define AR9287_DATA_SZ                  32
 
 #define AR9287_PWR_TABLE_OFFSET_DB  -5
@@ -396,7 +371,7 @@ struct modal_eep_header {
 	u16 xpaBiasLvlFreq[3];
 	u8 futureModal[6];
 
-	struct spur_chan spurChans[AR5416_EEPROM_MODAL_SPURS];
+	struct spur_chan spurChans[AR_EEPROM_MODAL_SPURS];
 } __packed;
 
 struct calDataPerFreqOpLoop {
@@ -464,7 +439,7 @@ struct modal_eep_4k_header {
 	u8 db2_4:4, reserved:4;
 #endif
 	u8 futureModal[4];
-	struct spur_chan spurChans[AR5416_EEPROM_MODAL_SPURS];
+	struct spur_chan spurChans[AR_EEPROM_MODAL_SPURS];
 } __packed;
 
 struct base_eep_ar9287_header {
@@ -522,7 +497,7 @@ struct modal_eep_ar9287_header {
 	u8 ob_qam;
 	u8 ob_pal_off;
 	u8 futureModal[30];
-	struct spur_chan spurChans[AR9287_EEPROM_MODAL_SPURS];
+	struct spur_chan spurChans[AR_EEPROM_MODAL_SPURS];
 } __packed;
 
 struct cal_data_per_freq {
@@ -531,8 +506,8 @@ struct cal_data_per_freq {
 } __packed;
 
 struct cal_data_per_freq_4k {
-	u8 pwrPdg[AR5416_EEP4K_NUM_PD_GAINS][AR5416_EEP4K_PD_GAIN_ICEPTS];
-	u8 vpdPdg[AR5416_EEP4K_NUM_PD_GAINS][AR5416_EEP4K_PD_GAIN_ICEPTS];
+	u8 pwrPdg[AR5416_EEP4K_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
+	u8 vpdPdg[AR5416_EEP4K_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
 } __packed;
 
 struct cal_target_power_leg {
@@ -558,8 +533,8 @@ struct cal_data_op_loop_ar9287 {
 } __packed;
 
 struct cal_data_per_freq_ar9287 {
-	u8 pwrPdg[AR9287_NUM_PD_GAINS][AR9287_PD_GAIN_ICEPTS];
-	u8 vpdPdg[AR9287_NUM_PD_GAINS][AR9287_PD_GAIN_ICEPTS];
+	u8 pwrPdg[AR5416_NUM_PD_GAINS][AR9287_PD_GAIN_ICEPTS];
+	u8 vpdPdg[AR5416_NUM_PD_GAINS][AR9287_PD_GAIN_ICEPTS];
 } __packed;
 
 union cal_data_per_freq_ar9287_u {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 939fc7a..6102309 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -153,7 +153,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 			eep->modalHeader.antCtrlChain[i] = integer;
 		}
 
-		for (i = 0; i < AR5416_EEPROM_MODAL_SPURS; i++) {
+		for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
 			word = swab16(eep->modalHeader.spurChans[i].spurChan);
 			eep->modalHeader.spurChans[i].spurChan = word;
 		}
@@ -258,7 +258,7 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 	struct chan_centers centers;
 #define PD_GAIN_BOUNDARY_DEFAULT 58;
 
-	memset(&minPwrT4, 0, AR9287_NUM_PD_GAINS);
+	memset(&minPwrT4, 0, AR5416_NUM_PD_GAINS);
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
 	for (numPiers = 0; numPiers < availPiers; numPiers++) {
@@ -278,7 +278,7 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
 					pRawDataSet[idxL].pwrPdg[i],
 					pRawDataSet[idxL].vpdPdg[i],
-					AR5416_EEP4K_PD_GAIN_ICEPTS,
+					AR5416_PD_GAIN_ICEPTS,
 					vpdTableI[i]);
 		}
 	} else {
@@ -291,17 +291,17 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 			minPwrT4[i] = max(pPwrL[0], pPwrR[0]);
 
 			maxPwrT4[i] =
-				min(pPwrL[AR5416_EEP4K_PD_GAIN_ICEPTS - 1],
-				    pPwrR[AR5416_EEP4K_PD_GAIN_ICEPTS - 1]);
+				min(pPwrL[AR5416_PD_GAIN_ICEPTS - 1],
+				    pPwrR[AR5416_PD_GAIN_ICEPTS - 1]);
 
 
 			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
 						pPwrL, pVpdL,
-						AR5416_EEP4K_PD_GAIN_ICEPTS,
+						AR5416_PD_GAIN_ICEPTS,
 						vpdTableL[i]);
 			ath9k_hw_fill_vpd_table(minPwrT4[i], maxPwrT4[i],
 						pPwrR, pVpdR,
-						AR5416_EEP4K_PD_GAIN_ICEPTS,
+						AR5416_PD_GAIN_ICEPTS,
 						vpdTableR[i]);
 
 			for (j = 0; j <= (maxPwrT4[i] - minPwrT4[i]) / 2; j++) {
@@ -328,7 +328,7 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 				(u16)((maxPwrT4[i] + minPwrT4[i + 1]) / 4);
 
 		pPdGainBoundaries[i] =
-			min((u16)AR5416_MAX_RATE_POWER, pPdGainBoundaries[i]);
+			min((u16)MAX_RATE_POWER, pPdGainBoundaries[i]);
 
 		if ((i == 0) && !AR_SREV_5416_20_OR_LATER(ah)) {
 			minDelta = pPdGainBoundaries[0] - 23;
@@ -380,7 +380,7 @@ static void ath9k_hw_get_4k_gain_boundaries_pdadcs(struct ath_hw *ah,
 		}
 	}
 
-	while (i < AR5416_EEP4K_PD_GAINS_IN_MASK) {
+	while (i < AR5416_PD_GAINS_IN_MASK) {
 		pPdGainBoundaries[i] = PD_GAIN_BOUNDARY_DEFAULT;
 		i++;
 	}
@@ -404,7 +404,7 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 	u8 *pCalBChans = NULL;
 	u16 pdGainOverlap_t2;
 	static u8 pdadcValues[AR5416_NUM_PDADC_VALUES];
-	u16 gainBoundaries[AR5416_EEP4K_PD_GAINS_IN_MASK];
+	u16 gainBoundaries[AR5416_PD_GAINS_IN_MASK];
 	u16 numPiers, i, j;
 	u16 numXpdGain, xpdMask;
 	u16 xpdGainValues[AR5416_EEP4K_NUM_PD_GAINS] = { 0, 0 };
@@ -426,12 +426,12 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 
 	numXpdGain = 0;
 
-	for (i = 1; i <= AR5416_EEP4K_PD_GAINS_IN_MASK; i++) {
-		if ((xpdMask >> (AR5416_EEP4K_PD_GAINS_IN_MASK - i)) & 1) {
+	for (i = 1; i <= AR5416_PD_GAINS_IN_MASK; i++) {
+		if ((xpdMask >> (AR5416_PD_GAINS_IN_MASK - i)) & 1) {
 			if (numXpdGain >= AR5416_EEP4K_NUM_PD_GAINS)
 				break;
 			xpdGainValues[numXpdGain] =
-				(u16)(AR5416_EEP4K_PD_GAINS_IN_MASK - i);
+				(u16)(AR5416_PD_GAINS_IN_MASK - i);
 			numXpdGain++;
 		}
 	}
@@ -528,7 +528,7 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 	int i;
 	int16_t twiceLargestAntenna;
 	u16 twiceMinEdgePower;
-	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+	u16 twiceMaxEdgePower = MAX_RATE_POWER;
 	u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
 	u16 numCtlModes;
 	const u16 *pCtlMode;
@@ -537,7 +537,7 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 	struct cal_ctl_data_4k *rep;
 	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
 	static const u16 tpScaleReductionTable[5] =
-		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
+		{ 0, 3, 6, 9, MAX_RATE_POWER };
 	struct cal_target_power_leg targetPowerOfdm, targetPowerCck = {
 		0, { 0, 0, 0, 0}
 	};
@@ -613,7 +613,7 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 
 		if (ah->eep_ops->get_eeprom_ver(ah) == 14 &&
 		    ah->eep_ops->get_eeprom_rev(ah) <= 2)
-			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+			twiceMaxEdgePower = MAX_RATE_POWER;
 
 		for (i = 0; (i < AR5416_EEP4K_NUM_CTLS) &&
 			     pEepData->ctlIndex[i]; i++) {
@@ -752,8 +752,8 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 	regulatory->max_power_level = 0;
 	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
 		ratesArray[i] =	(int16_t)(txPowerIndexOffset + ratesArray[i]);
-		if (ratesArray[i] > AR5416_MAX_RATE_POWER)
-			ratesArray[i] = AR5416_MAX_RATE_POWER;
+		if (ratesArray[i] > MAX_RATE_POWER)
+			ratesArray[i] = MAX_RATE_POWER;
 
 		if (ratesArray[i] > regulatory->max_power_level)
 			regulatory->max_power_level = ratesArray[i];
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 065402f..4ba07da 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -150,7 +150,7 @@ static int ath9k_hw_ar9287_check_eeprom(struct ath_hw *ah)
 			eep->modalHeader.antCtrlChain[i] = integer;
 		}
 
-		for (i = 0; i < AR9287_EEPROM_MODAL_SPURS; i++) {
+		for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
 			word = swab16(eep->modalHeader.spurChans[i].spurChan);
 			eep->modalHeader.spurChans[i].spurChan = word;
 		}
@@ -236,8 +236,8 @@ static void ath9k_hw_get_ar9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 	int16_t ss;
 	u16 idxL = 0, idxR = 0, numPiers;
 	u8 *pVpdL, *pVpdR, *pPwrL, *pPwrR;
-	u8 minPwrT4[AR9287_NUM_PD_GAINS];
-	u8 maxPwrT4[AR9287_NUM_PD_GAINS];
+	u8 minPwrT4[AR5416_NUM_PD_GAINS];
+	u8 maxPwrT4[AR5416_NUM_PD_GAINS];
 	int16_t vpdStep;
 	int16_t tmpVal;
 	u16 sizeCurrVpdTable, maxIndex, tgtIndex;
@@ -251,11 +251,11 @@ static void ath9k_hw_get_ar9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 	static u8 vpdTableI[AR5416_EEP4K_NUM_PD_GAINS]
 		[AR5416_MAX_PWR_RANGE_IN_HALF_DB];
 
-	memset(&minPwrT4, 0, AR9287_NUM_PD_GAINS);
+	memset(&minPwrT4, 0, AR5416_NUM_PD_GAINS);
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
 	for (numPiers = 0; numPiers < availPiers; numPiers++) {
-		if (bChans[numPiers] == AR9287_BCHAN_UNUSED)
+		if (bChans[numPiers] == AR5416_BCHAN_UNUSED)
 			break;
 	}
 
@@ -314,7 +314,7 @@ static void ath9k_hw_get_ar9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 			pPdGainBoundaries[i] =
 				(u16)((maxPwrT4[i] + minPwrT4[i+1]) / 4);
 
-		pPdGainBoundaries[i] = min((u16)AR5416_MAX_RATE_POWER,
+		pPdGainBoundaries[i] = min((u16)MAX_RATE_POWER,
 					   pPdGainBoundaries[i]);
 
 
@@ -334,7 +334,7 @@ static void ath9k_hw_get_ar9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 		vpdStep = (int16_t)(vpdTableI[i][1] - vpdTableI[i][0]);
 		vpdStep = (int16_t)((vpdStep < 1) ? 1 : vpdStep);
 
-		while ((ss < 0) && (k < (AR9287_NUM_PDADC_VALUES - 1)))	{
+		while ((ss < 0) && (k < (AR5416_NUM_PDADC_VALUES - 1)))	{
 			tmpVal = (int16_t)(vpdTableI[i][0] + ss * vpdStep);
 			pPDADCValues[k++] = (u8)((tmpVal < 0) ? 0 : tmpVal);
 			ss++;
@@ -346,7 +346,7 @@ static void ath9k_hw_get_ar9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 		maxIndex = (tgtIndex < sizeCurrVpdTable) ?
 			    tgtIndex : sizeCurrVpdTable;
 
-		while ((ss < maxIndex) && (k < (AR9287_NUM_PDADC_VALUES - 1)))
+		while ((ss < maxIndex) && (k < (AR5416_NUM_PDADC_VALUES - 1)))
 			pPDADCValues[k++] = vpdTableI[i][ss++];
 
 		vpdStep = (int16_t)(vpdTableI[i][sizeCurrVpdTable - 1] -
@@ -355,7 +355,7 @@ static void ath9k_hw_get_ar9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 
 		if (tgtIndex > maxIndex) {
 			while ((ss <= tgtIndex) &&
-				(k < (AR9287_NUM_PDADC_VALUES - 1))) {
+				(k < (AR5416_NUM_PDADC_VALUES - 1))) {
 				tmpVal = (int16_t) TMP_VAL_VPD_TABLE;
 				pPDADCValues[k++] =
 					(u8)((tmpVal > 255) ? 255 : tmpVal);
@@ -364,12 +364,12 @@ static void ath9k_hw_get_ar9287_gain_boundaries_pdadcs(struct ath_hw *ah,
 		}
 	}
 
-	while (i < AR9287_PD_GAINS_IN_MASK) {
+	while (i < AR5416_PD_GAINS_IN_MASK) {
 		pPdGainBoundaries[i] = pPdGainBoundaries[i-1];
 		i++;
 	}
 
-	while (k < AR9287_NUM_PDADC_VALUES) {
+	while (k < AR5416_NUM_PDADC_VALUES) {
 		pPDADCValues[k] = pPDADCValues[k-1];
 		k++;
 	}
@@ -389,7 +389,7 @@ static void ar9287_eeprom_get_tx_gain_index(struct ath_hw *ah,
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
 	for (numPiers = 0; numPiers < availPiers; numPiers++) {
-		if (pCalChans[numPiers] == AR9287_BCHAN_UNUSED)
+		if (pCalChans[numPiers] == AR5416_BCHAN_UNUSED)
 			break;
 	}
 
@@ -455,11 +455,11 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 	struct cal_data_op_loop_ar9287 *pRawDatasetOpenLoop;
 	u8 *pCalBChans = NULL;
 	u16 pdGainOverlap_t2;
-	u8 pdadcValues[AR9287_NUM_PDADC_VALUES];
-	u16 gainBoundaries[AR9287_PD_GAINS_IN_MASK];
+	u8 pdadcValues[AR5416_NUM_PDADC_VALUES];
+	u16 gainBoundaries[AR5416_PD_GAINS_IN_MASK];
 	u16 numPiers = 0, i, j;
 	u16 numXpdGain, xpdMask;
-	u16 xpdGainValues[AR9287_NUM_PD_GAINS] = {0, 0, 0, 0};
+	u16 xpdGainValues[AR5416_NUM_PD_GAINS] = {0, 0, 0, 0};
 	u32 reg32, regOffset, regChainOffset, regval;
 	int16_t modalIdx, diff = 0;
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
@@ -487,12 +487,12 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 	numXpdGain = 0;
 
 	/* Calculate the value of xpdgains from the xpdGain Mask */
-	for (i = 1; i <= AR9287_PD_GAINS_IN_MASK; i++) {
-		if ((xpdMask >> (AR9287_PD_GAINS_IN_MASK - i)) & 1) {
-			if (numXpdGain >= AR9287_NUM_PD_GAINS)
+	for (i = 1; i <= AR5416_PD_GAINS_IN_MASK; i++) {
+		if ((xpdMask >> (AR5416_PD_GAINS_IN_MASK - i)) & 1) {
+			if (numXpdGain >= AR5416_NUM_PD_GAINS)
 				break;
 			xpdGainValues[numXpdGain] =
-				(u16)(AR9287_PD_GAINS_IN_MASK-i);
+				(u16)(AR5416_PD_GAINS_IN_MASK-i);
 			numXpdGain++;
 		}
 	}
@@ -561,13 +561,13 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 					     (int32_t)AR9287_PWR_TABLE_OFFSET_DB);
 				diff *= 2;
 
-				for (j = 0; j < ((u16)AR9287_NUM_PDADC_VALUES-diff); j++)
+				for (j = 0; j < ((u16)AR5416_NUM_PDADC_VALUES-diff); j++)
 					pdadcValues[j] = pdadcValues[j+diff];
 
-				for (j = (u16)(AR9287_NUM_PDADC_VALUES-diff);
-				     j < AR9287_NUM_PDADC_VALUES; j++)
+				for (j = (u16)(AR5416_NUM_PDADC_VALUES-diff);
+				     j < AR5416_NUM_PDADC_VALUES; j++)
 					pdadcValues[j] =
-					  pdadcValues[AR9287_NUM_PDADC_VALUES-diff];
+					  pdadcValues[AR5416_NUM_PDADC_VALUES-diff];
 			}
 
 			if (!ath9k_hw_ar9287_get_eeprom(ah, EEP_OL_PWRCTRL)) {
@@ -610,9 +610,9 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 #define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10
 
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
-	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+	u16 twiceMaxEdgePower = MAX_RATE_POWER;
 	static const u16 tpScaleReductionTable[5] =
-		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
+		{ 0, 3, 6, 9, MAX_RATE_POWER };
 	int i;
 	int16_t twiceLargestAntenna;
 	struct cal_ctl_data_ar9287 *rep;
@@ -877,8 +877,8 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 	regulatory->max_power_level = 0;
 	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
 		ratesArray[i] = (int16_t)(txPowerIndexOffset + ratesArray[i]);
-		if (ratesArray[i] > AR9287_MAX_RATE_POWER)
-			ratesArray[i] = AR9287_MAX_RATE_POWER;
+		if (ratesArray[i] > MAX_RATE_POWER)
+			ratesArray[i] = MAX_RATE_POWER;
 
 		if (ratesArray[i] > regulatory->max_power_level)
 			regulatory->max_power_level = ratesArray[i];
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 5bfa031..da96a78 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -206,7 +206,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 				pModal->antCtrlChain[i] = integer;
 			}
 
-			for (i = 0; i < AR5416_EEPROM_MODAL_SPURS; i++) {
+			for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
 				word = swab16(pModal->spurChans[i].spurChan);
 				pModal->spurChans[i].spurChan = word;
 			}
@@ -616,7 +616,7 @@ static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
 	int16_t minDelta = 0;
 	struct chan_centers centers;
 
-	memset(&minPwrT4, 0, AR9287_NUM_PD_GAINS);
+	memset(&minPwrT4, 0, AR5416_NUM_PD_GAINS);
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 
 	for (numPiers = 0; numPiers < availPiers; numPiers++) {
@@ -685,7 +685,7 @@ static void ath9k_hw_get_def_gain_boundaries_pdadcs(struct ath_hw *ah,
 				(u16)((maxPwrT4[i] + minPwrT4[i + 1]) / 4);
 
 		pPdGainBoundaries[i] =
-			min((u16)AR5416_MAX_RATE_POWER, pPdGainBoundaries[i]);
+			min((u16)MAX_RATE_POWER, pPdGainBoundaries[i]);
 
 		if ((i == 0) && !AR_SREV_5416_20_OR_LATER(ah)) {
 			minDelta = pPdGainBoundaries[0] - 23;
@@ -782,7 +782,7 @@ static int16_t ath9k_change_gain_boundary_setting(struct ath_hw *ah,
 		/* Because of a hardware limitation, ensure the gain boundary
 		 * is not larger than (63 - overlap)
 		 */
-		gb_limit = (u16)(AR5416_MAX_RATE_POWER - pdGainOverlap_t2);
+		gb_limit = (u16)(MAX_RATE_POWER - pdGainOverlap_t2);
 
 		for (k = 0; k < numXpdGain; k++)
 			gb[k] = (u16)min(gb_limit, gb[k]);
@@ -1001,9 +1001,9 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
-	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+	u16 twiceMaxEdgePower = MAX_RATE_POWER;
 	static const u16 tpScaleReductionTable[5] =
-		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
+		{ 0, 3, 6, 9, MAX_RATE_POWER };
 
 	int i;
 	int16_t twiceLargestAntenna;
@@ -1148,7 +1148,7 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 
 		if (ah->eep_ops->get_eeprom_ver(ah) == 14 &&
 		    ah->eep_ops->get_eeprom_rev(ah) <= 2)
-			twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
+			twiceMaxEdgePower = MAX_RATE_POWER;
 
 		for (i = 0; (i < AR5416_NUM_CTLS) && pEepData->ctlIndex[i]; i++) {
 			if ((((cfgCtl & ~CTL_MODE_M) |
@@ -1293,8 +1293,8 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 	regulatory->max_power_level = 0;
 	for (i = 0; i < ARRAY_SIZE(ratesArray); i++) {
 		ratesArray[i] =	(int16_t)(txPowerIndexOffset + ratesArray[i]);
-		if (ratesArray[i] > AR5416_MAX_RATE_POWER)
-			ratesArray[i] = AR5416_MAX_RATE_POWER;
+		if (ratesArray[i] > MAX_RATE_POWER)
+			ratesArray[i] = MAX_RATE_POWER;
 		if (ratesArray[i] > regulatory->max_power_level)
 			regulatory->max_power_level = ratesArray[i];
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index d83cc3b..157e6bc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -238,7 +238,6 @@ struct ath9k_ops_config {
 #define SPUR_DISABLE        	0
 #define SPUR_ENABLE_IOCTL   	1
 #define SPUR_ENABLE_EEPROM  	2
-#define AR_EEPROM_MODAL_SPURS   5
 #define AR_SPUR_5413_1      	1640
 #define AR_SPUR_5413_2      	1200
 #define AR_NO_SPUR      	0x8000
-- 
1.7.3.2


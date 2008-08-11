Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16330 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbYHKIqD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 04:46:03 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 01:46:03 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18591.63896.775404.725233@localhost.localdomain> (sfid-20080811_104608_155491_7C56B076)
Date: Mon, 11 Aug 2008 14:04:32 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 06/10] ath9k: Unused macros, variables
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |   18 +++---
 drivers/net/wireless/ath9k/hw.h    |  116 ++++++++++++-----------------------
 2 files changed, 50 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index d1b0fba..3e7072d 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -790,19 +790,20 @@ struct ath_hal {
 	u32 ah_magic;
 	u16 ah_devid;
 	u16 ah_subvendorid;
-	struct ath_softc *ah_sc;
-	void __iomem *ah_sh;
-	u16 ah_countryCode;
 	u32 ah_macVersion;
 	u16 ah_macRev;
 	u16 ah_phyRev;
 	u16 ah_analog5GhzRev;
 	u16 ah_analog2GhzRev;
-	u8 ah_decompMask[ATH9K_DECOMP_MASK_SIZE];
-	u32 ah_flags;
+
+	void __iomem *ah_sh;
+	struct ath_softc *ah_sc;
 	enum ath9k_opmode ah_opmode;
 	struct ath9k_ops_config ah_config;
 	struct ath9k_hw_capabilities ah_caps;
+
+	u16 ah_countryCode;
+	u32 ah_flags;
 	int16_t ah_powerLimit;
 	u16 ah_maxPowerLevel;
 	u32 ah_tpScale;
@@ -812,15 +813,16 @@ struct ath_hal {
 	u16 ah_currentRD5G;
 	u16 ah_currentRD2G;
 	char ah_iso[4];
-	enum start_adhoc_option ah_adHocMode;
-	bool ah_commonMode;
+
 	struct ath9k_channel ah_channels[150];
-	u32 ah_nchan;
 	struct ath9k_channel *ah_curchan;
+	u32 ah_nchan;
+
 	u16 ah_rfsilent;
 	bool ah_rfkillEnabled;
 	bool ah_isPciExpress;
 	u16 ah_txTrigLevel;
+
 #ifndef ATH_NF_PER_CHAN
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
 #endif
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index ae680f2..5cb3912 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -314,14 +314,11 @@ struct ar5416_desc {
 #define RXSTATUS_RATE(ah, ads)  (AR_SREV_5416_V20_OR_LATER(ah) ?	\
 				 MS(ads->ds_rxstatus0, AR_RxRate) :	\
 				 (ads->ds_rxstatus3 >> 2) & 0xFF)
-#define RXSTATUS_DUPLICATE(ah, ads)  (AR_SREV_5416_V20_OR_LATER(ah) ?	\
-				      MS(ads->ds_rxstatus3, AR_Parallel40) : \
-				      (ads->ds_rxstatus3 >> 10) & 0x1)
 
-#define set11nTries(_series, _index)				\
+#define set11nTries(_series, _index) \
 	(SM((_series)[_index].Tries, AR_XmitDataTries##_index))
 
-#define set11nRate(_series, _index)				\
+#define set11nRate(_series, _index) \
 	(SM((_series)[_index].Rate, AR_XmitRate##_index))
 
 #define set11nPktDurRTSCTS(_series, _index)				\
@@ -330,11 +327,11 @@ struct ar5416_desc {
 		AR_RTSCTSQual##_index : 0))
 
 #define set11nRateFlags(_series, _index)				\
-	(((_series)[_index].RateFlags & ATH9K_RATESERIES_2040 ? \
-		AR_2040_##_index : 0) \
-	|((_series)[_index].RateFlags & ATH9K_RATESERIES_HALFGI ? \
-		AR_GI##_index : 0) \
-	|SM((_series)[_index].ChSel, AR_ChainSel##_index))
+	(((_series)[_index].RateFlags & ATH9K_RATESERIES_2040 ?		\
+	  AR_2040_##_index : 0)						\
+	 |((_series)[_index].RateFlags & ATH9K_RATESERIES_HALFGI ?	\
+	   AR_GI##_index : 0)						\
+	 |SM((_series)[_index].ChSel, AR_ChainSel##_index))
 
 #define AR_SREV_9100(ah) ((ah->ah_macVersion) == AR_SREV_VERSION_9100)
 
@@ -346,9 +343,6 @@ struct ar5416_desc {
 #define MAX_TX_FIFO_THRESHOLD   ((4096 / 64) - 1)
 #define INIT_TX_FIFO_THRESHOLD  MIN_TX_FIFO_THRESHOLD
 
-#define NUM_CORNER_FIX_BITS_2133    7
-#define CCK_OFDM_GAIN_DELTA         15
-
 struct ar5416AniState {
 	struct ath9k_channel c;
 	u8 noiseImmunityLevel;
@@ -377,11 +371,8 @@ struct ar5416AniState {
 };
 
 #define HAL_PROCESS_ANI     0x00000001
-#define HAL_RADAR_EN        0x80000000
-#define HAL_AR_EN           0x40000000
-
 #define DO_ANI(ah) \
-    ((AH5416(ah)->ah_procPhyErr & HAL_PROCESS_ANI))
+	((AH5416(ah)->ah_procPhyErr & HAL_PROCESS_ANI))
 
 struct ar5416Stats {
 	u32 ast_ani_niup;
@@ -425,7 +416,6 @@ struct ar5416Stats {
 #define AR5416_EEP_MINOR_VER_7       0x7
 #define AR5416_EEP_MINOR_VER_9       0x9
 
-#define AR5416_EEP_START_LOC            256
 #define AR5416_NUM_5G_CAL_PIERS         8
 #define AR5416_NUM_2G_CAL_PIERS         4
 #define AR5416_NUM_5G_20_TARGET_POWERS  8
@@ -441,25 +431,10 @@ struct ar5416Stats {
 #define AR5416_EEPROM_MODAL_SPURS       5
 #define AR5416_MAX_RATE_POWER           63
 #define AR5416_NUM_PDADC_VALUES         128
-#define AR5416_NUM_RATES                16
 #define AR5416_BCHAN_UNUSED             0xFF
 #define AR5416_MAX_PWR_RANGE_IN_HALF_DB 64
-#define AR5416_EEPMISC_BIG_ENDIAN       0x01
 #define AR5416_MAX_CHAINS               3
-#define AR5416_ANT_16S                  25
-
-#define AR5416_NUM_ANT_CHAIN_FIELDS     7
-#define AR5416_NUM_ANT_COMMON_FIELDS    4
-#define AR5416_SIZE_ANT_CHAIN_FIELD     3
-#define AR5416_SIZE_ANT_COMMON_FIELD    4
-#define AR5416_ANT_CHAIN_MASK           0x7
-#define AR5416_ANT_COMMON_MASK          0xf
-#define AR5416_CHAIN_0_IDX              0
-#define AR5416_CHAIN_1_IDX              1
-#define AR5416_CHAIN_2_IDX              2
-
 #define AR5416_PWR_TABLE_OFFSET         -5
-#define AR5416_LEGACY_CHAINMASK         1
 
 enum eeprom_param {
 	EEP_NFTHRESH_5,
@@ -633,7 +608,7 @@ struct ar5416IniArray {
 };
 
 #define INIT_INI_ARRAY(iniarray, array, rows, columns) do {	\
-		(iniarray)->ia_array = (u32 *)(array);    \
+		(iniarray)->ia_array = (u32 *)(array);		\
 		(iniarray)->ia_rows = (rows);			\
 		(iniarray)->ia_columns = (columns);		\
 	} while (0)
@@ -641,16 +616,16 @@ struct ar5416IniArray {
 #define INI_RA(iniarray, row, column) \
 	(((iniarray)->ia_array)[(row) *	((iniarray)->ia_columns) + (column)])
 
-#define INIT_CAL(_perCal) do { \
-		(_perCal)->calState = CAL_WAITING; \
-		(_perCal)->calNext = NULL; \
+#define INIT_CAL(_perCal) do {				\
+		(_perCal)->calState = CAL_WAITING;	\
+		(_perCal)->calNext = NULL;		\
 	} while (0)
 
 #define INSERT_CAL(_ahp, _perCal)					\
 	do {								\
 		if ((_ahp)->ah_cal_list_last == NULL) {			\
-			(_ahp)->ah_cal_list = \
-				(_ahp)->ah_cal_list_last = (_perCal); \
+			(_ahp)->ah_cal_list =				\
+				(_ahp)->ah_cal_list_last = (_perCal);	\
 			((_ahp)->ah_cal_list_last)->calNext = (_perCal); \
 		} else {						\
 			((_ahp)->ah_cal_list_last)->calNext = (_perCal); \
@@ -696,25 +671,29 @@ struct hal_cal_list {
 struct ath_hal_5416 {
 	struct ath_hal ah;
 	struct ar5416_eeprom ah_eeprom;
+	struct ar5416Stats ah_stats;
+	struct ath9k_tx_queue_info ah_txq[ATH9K_NUM_TX_QUEUES];
+	void __iomem *ah_cal_mem;
+
 	u8 ah_macaddr[ETH_ALEN];
 	u8 ah_bssid[ETH_ALEN];
 	u8 ah_bssidmask[ETH_ALEN];
 	u16 ah_assocId;
+
 	int16_t ah_curchanRadIndex;
 	u32 ah_maskReg;
-	struct ar5416Stats ah_stats;
-	u32 ah_txDescMask;
 	u32 ah_txOkInterruptMask;
 	u32 ah_txErrInterruptMask;
 	u32 ah_txDescInterruptMask;
 	u32 ah_txEolInterruptMask;
 	u32 ah_txUrnInterruptMask;
-	struct ath9k_tx_queue_info ah_txq[ATH9K_NUM_TX_QUEUES];
-	enum ath9k_power_mode ah_powerMode;
 	bool ah_chipFullSleep;
 	u32 ah_atimWindow;
-	enum ath9k_ant_setting ah_diversityControl;
 	u16 ah_antennaSwitchSwap;
+	enum ath9k_power_mode ah_powerMode;
+	enum ath9k_ant_setting ah_diversityControl;
+
+	/* Calibration */
 	enum hal_cal_types ah_suppCals;
 	struct hal_cal_list ah_iqCalData;
 	struct hal_cal_list ah_adcGainCalData;
@@ -751,16 +730,16 @@ struct ath_hal_5416 {
 		int32_t sign[AR5416_MAX_CHAINS];
 	} ah_Meas3;
 	u16 ah_CalSamples;
-	u32 ah_tx6PowerInHalfDbm;
+
 	u32 ah_staId1Defaults;
 	u32 ah_miscMode;
-	bool ah_tpcEnabled;
-	u32 ah_beaconInterval;
 	enum {
 		AUTO_32KHZ,
 		USE_32KHZ,
 		DONT_USE_32KHZ,
 	} ah_enable32kHzClock;
+
+	/* RF */
 	u32 *ah_analogBank0Data;
 	u32 *ah_analogBank1Data;
 	u32 *ah_analogBank2Data;
@@ -770,8 +749,9 @@ struct ath_hal_5416 {
 	u32 *ah_analogBank7Data;
 	u32 *ah_addac5416_21;
 	u32 *ah_bank6Temp;
-	u32 ah_ofdmTxPower;
+
 	int16_t ah_txPowerIndexOffset;
+	u32 ah_beaconInterval;
 	u32 ah_slottime;
 	u32 ah_acktimeout;
 	u32 ah_ctstimeout;
@@ -780,7 +760,8 @@ struct ath_hal_5416 {
 	u32 ah_gpioSelect;
 	u32 ah_polarity;
 	u32 ah_gpioBit;
-	bool ah_eepEnabled;
+
+	/* ANI */
 	u32 ah_procPhyErr;
 	bool ah_hasHwPhyCounters;
 	u32 ah_aniPeriod;
@@ -790,18 +771,14 @@ struct ath_hal_5416 {
 	int ah_coarseHigh[5];
 	int ah_coarseLow[5];
 	int ah_firpwr[5];
-	u16 ah_ratesArray[16];
+	enum ath9k_ani_cmd ah_ani_function;
+
 	u32 ah_intrTxqs;
 	bool ah_intrMitigation;
-	u32 ah_cycleCount;
-	u32 ah_ctlBusy;
-	u32 ah_extBusy;
 	enum ath9k_ht_extprotspacing ah_extprotspacing;
 	u8 ah_txchainmask;
 	u8 ah_rxchainmask;
-	int ah_hwp;
-	void __iomem *ah_cal_mem;
-	enum ath9k_ani_cmd ah_ani_function;
+
 	struct ar5416IniArray ah_iniModes;
 	struct ar5416IniArray ah_iniCommon;
 	struct ar5416IniArray ah_iniBank0;
@@ -820,10 +797,6 @@ struct ath_hal_5416 {
 
 #define FREQ2FBIN(x, y) ((y) ? ((x) - 2300) : (((x) - 4800) / 5))
 
-#define IS_5416_EMU(ah)					\
-	((ah->ah_devid == AR5416_DEVID_EMU) ||		\
-	 (ah->ah_devid == AR5416_DEVID_EMU_PCIE))
-
 #define ar5416RfDetach(ah) do {					\
 		if (AH5416(ah)->ah_rfHal.rfDetach != NULL)	\
 			AH5416(ah)->ah_rfHal.rfDetach(ah);	\
@@ -841,8 +814,8 @@ struct ath_hal_5416 {
 #define REG_WRITE_ARRAY(iniarray, column, regWr) do {                   \
 		int r;							\
 		for (r = 0; r < ((iniarray)->ia_rows); r++) {		\
-			REG_WRITE(ah, INI_RA((iniarray), (r), 0), \
-				INI_RA((iniarray), r, (column))); \
+			REG_WRITE(ah, INI_RA((iniarray), (r), 0),	\
+				  INI_RA((iniarray), r, (column)));	\
 			DO_DELAY(regWr);				\
 		}							\
 	} while (0)
@@ -860,22 +833,17 @@ struct ath_hal_5416 {
 
 #define AR5416_EEPROM_S             2
 #define AR5416_EEPROM_OFFSET        0x2000
-#define AR5416_EEPROM_START_ADDR			\
+#define AR5416_EEPROM_START_ADDR \
 	(AR_SREV_9100(ah)) ? 0x1fff1000 : 0x503f1200
 #define AR5416_EEPROM_MAX           0xae0
-#define ar5416_get_eep_ver(_ahp)				\
+#define ar5416_get_eep_ver(_ahp) \
 	(((_ahp)->ah_eeprom.baseEepHeader.version >> 12) & 0xF)
-#define ar5416_get_eep_rev(_ahp)				\
+#define ar5416_get_eep_rev(_ahp) \
 	(((_ahp)->ah_eeprom.baseEepHeader.version) & 0xFFF)
-#define ar5416_get_ntxchains(_txchainmask)				\
+#define ar5416_get_ntxchains(_txchainmask) \
 	(((_txchainmask >> 2) & 1) + \
 		((_txchainmask >> 1) & 1) + (_txchainmask & 1))
 
-#define IS_EEP_MINOR_V3(_ahp) \
-	(ath9k_hw_get_eeprom((_ahp), EEP_MINOR_REV)  >= AR5416_EEP_MINOR_VER_3)
-
-#define FIXED_CCA_THRESHOLD 15
-
 #ifdef __BIG_ENDIAN
 #define AR5416_EEPROM_MAGIC 0x5aa5
 #else
@@ -910,8 +878,6 @@ struct ath_hal_5416 {
 #define AR_GPIOD_MASK                   0x00001FFF
 #define AR_GPIO_BIT(_gpio)              (1 << (_gpio))
 
-#define MAX_ANALOG_START                319
-
 #define HAL_EP_RND(x, mul) \
 	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
 #define BEACON_RSSI(ahp) \
@@ -923,8 +889,6 @@ struct ath_hal_5416 {
 #define AH_TIMEOUT         100000
 #define AH_TIME_QUANTUM        10
 
-#define IS(_c, _f)       (((_c)->channelFlags & _f) || 0)
-
 #define AR_KEYTABLE_SIZE 128
 #define POWER_UP_TIME    200000
 
@@ -964,6 +928,6 @@ struct ath_hal_5416 {
 #define OFDM_SYMBOL_TIME_QUARTER    16
 
 u32 ath9k_hw_get_eeprom(struct ath_hal_5416 *ahp,
-			      enum eeprom_param param);
+			enum eeprom_param param);
 
 #endif
-- 
1.5.6.5


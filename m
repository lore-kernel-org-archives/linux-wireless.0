Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54265 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYHGFeG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 01:34:06 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 22:34:06 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18586.34462.57671.298603@localhost.localdomain> (sfid-20080807_073419_231578_33572E23)
Date: Thu, 7 Aug 2008 10:52:38 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/6] ath9k: Cleanup data structures related to HW capabilities
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |  191 +++++++++---------
 drivers/net/wireless/ath9k/beacon.c |   10 +-
 drivers/net/wireless/ath9k/core.c   |   58 +++---
 drivers/net/wireless/ath9k/hw.c     |  369 ++++++++++++++++++-----------------
 drivers/net/wireless/ath9k/main.c   |    6 +-
 drivers/net/wireless/ath9k/rc.c     |    2 +-
 drivers/net/wireless/ath9k/recv.c   |    4 +-
 drivers/net/wireless/ath9k/regd.c   |   14 +-
 drivers/net/wireless/ath9k/xmit.c   |    4 +-
 9 files changed, 334 insertions(+), 324 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index dc1da64..71027dc 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -147,94 +147,95 @@ struct ath_desc {
 
 #define ATH9K_RXDESC_INTREQ		0x0020
 
-enum hal_capability_type {
-	HAL_CAP_CIPHER = 0,
-	HAL_CAP_TKIP_MIC,
-	HAL_CAP_TKIP_SPLIT,
-	HAL_CAP_PHYCOUNTERS,
-	HAL_CAP_DIVERSITY,
-	HAL_CAP_PSPOLL,
-	HAL_CAP_TXPOW,
-	HAL_CAP_PHYDIAG,
-	HAL_CAP_MCAST_KEYSRCH,
-	HAL_CAP_TSF_ADJUST,
-	HAL_CAP_WME_TKIPMIC,
-	HAL_CAP_RFSILENT,
-	HAL_CAP_ANT_CFG_2GHZ,
-	HAL_CAP_ANT_CFG_5GHZ
+enum ath9k_hw_caps {
+	ATH9K_HW_CAP_CHAN_SPREAD		= BIT(0),
+	ATH9K_HW_CAP_MIC_AESCCM                 = BIT(1),
+	ATH9K_HW_CAP_MIC_CKIP                   = BIT(2),
+	ATH9K_HW_CAP_MIC_TKIP                   = BIT(3),
+	ATH9K_HW_CAP_CIPHER_AESCCM              = BIT(4),
+	ATH9K_HW_CAP_CIPHER_CKIP                = BIT(5),
+	ATH9K_HW_CAP_CIPHER_TKIP                = BIT(6),
+	ATH9K_HW_CAP_VEOL                       = BIT(7),
+	ATH9K_HW_CAP_BSSIDMASK                  = BIT(8),
+	ATH9K_HW_CAP_MCAST_KEYSEARCH            = BIT(9),
+	ATH9K_HW_CAP_CHAN_HALFRATE              = BIT(10),
+	ATH9K_HW_CAP_CHAN_QUARTERRATE           = BIT(11),
+	ATH9K_HW_CAP_HT                         = BIT(12),
+	ATH9K_HW_CAP_GTT                        = BIT(13),
+	ATH9K_HW_CAP_FASTCC                     = BIT(14),
+	ATH9K_HW_CAP_RFSILENT                   = BIT(15),
+	ATH9K_HW_CAP_WOW                        = BIT(16),
+	ATH9K_HW_CAP_CST                        = BIT(17),
+	ATH9K_HW_CAP_ENHANCEDPM                 = BIT(18),
+	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(19),
+	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(20),
+	ATH9K_HW_CAP_WOW_MATCHPATTERN_EXACT     = BIT(21),
 };
 
-struct hal_capabilities {
-	u32 halChanSpreadSupport:1,
-		halChapTuningSupport:1,
-		halMicAesCcmSupport:1,
-		halMicCkipSupport:1,
-		halMicTkipSupport:1,
-		halCipherAesCcmSupport:1,
-		halCipherCkipSupport:1,
-		halCipherTkipSupport:1,
-		halVEOLSupport:1,
-		halBssIdMaskSupport:1,
-		halMcastKeySrchSupport:1,
-		halTsfAddSupport:1,
-		halChanHalfRate:1,
-		halChanQuarterRate:1,
-		halHTSupport:1,
-		halGTTSupport:1,
-		halFastCCSupport:1,
-		halRfSilentSupport:1,
-		halWowSupport:1,
-		halCSTSupport:1,
-		halEnhancedPmSupport:1,
-		halAutoSleepSupport:1,
-		hal4kbSplitTransSupport:1,
-		halWowMatchPatternExact:1;
-	u32 halWirelessModes;
-	u16 halTotalQueues;
-	u16 halKeyCacheSize;
-	u16 halLow5GhzChan, halHigh5GhzChan;
-	u16 halLow2GhzChan, halHigh2GhzChan;
-	u16 halNumMRRetries;
-	u16 halRtsAggrLimit;
-	u8 halTxChainMask;
-	u8 halRxChainMask;
-	u16 halTxTrigLevelMax;
-	u16 halRegCap;
-	u8 halNumGpioPins;
-	u8 halNumAntCfg2GHz;
-	u8 halNumAntCfg5GHz;
+enum ath9k_capability_type {
+	ATH9K_CAP_CIPHER = 0,
+	ATH9K_CAP_TKIP_MIC,
+	ATH9K_CAP_TKIP_SPLIT,
+	ATH9K_CAP_PHYCOUNTERS,
+	ATH9K_CAP_DIVERSITY,
+	ATH9K_CAP_TXPOW,
+	ATH9K_CAP_PHYDIAG,
+	ATH9K_CAP_MCAST_KEYSRCH,
+	ATH9K_CAP_TSF_ADJUST,
+	ATH9K_CAP_WME_TKIPMIC,
+	ATH9K_CAP_RFSILENT,
+	ATH9K_CAP_ANT_CFG_2GHZ,
+	ATH9K_CAP_ANT_CFG_5GHZ
 };
 
-struct hal_ops_config {
-	int ath_hal_dma_beacon_response_time;
-	int ath_hal_sw_beacon_response_time;
-	int ath_hal_additional_swba_backoff;
-	int ath_hal_6mb_ack;
-	int ath_hal_cwmIgnoreExtCCA;
-	u8 ath_hal_pciePowerSaveEnable;
-	u8 ath_hal_pcieL1SKPEnable;
-	u8 ath_hal_pcieClockReq;
-	u32 ath_hal_pcieWaen;
-	int ath_hal_pciePowerReset;
-	u8 ath_hal_pcieRestore;
-	u8 ath_hal_analogShiftReg;
-	u8 ath_hal_htEnable;
-	u32 ath_hal_ofdmTrigLow;
-	u32 ath_hal_ofdmTrigHigh;
-	u32 ath_hal_cckTrigHigh;
-	u32 ath_hal_cckTrigLow;
-	u32 ath_hal_enableANI;
-	u8 ath_hal_noiseImmunityLvl;
-	u32 ath_hal_ofdmWeakSigDet;
-	u32 ath_hal_cckWeakSigThr;
-	u8 ath_hal_spurImmunityLvl;
-	u8 ath_hal_firStepLvl;
-	int8_t ath_hal_rssiThrHigh;
-	int8_t ath_hal_rssiThrLow;
-	u16 ath_hal_diversityControl;
-	u16 ath_hal_antennaSwitchSwap;
-	int ath_hal_serializeRegMode;
-	int ath_hal_intrMitigation;
+struct ath9k_hw_capabilities {
+	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */
+	u32 wireless_modes;
+	u16 total_queues;
+	u16 keycache_size;
+	u16 low_5ghz_chan, high_5ghz_chan;
+	u16 low_2ghz_chan, high_2ghz_chan;
+	u16 num_mr_retries;
+	u16 rts_aggr_limit;
+	u8 tx_chainmask;
+	u8 rx_chainmask;
+	u16 tx_triglevel_max;
+	u16 reg_cap;
+	u8 num_gpio_pins;
+	u8 num_antcfg_2ghz;
+	u8 num_antcfg_5ghz;
+};
+
+struct ath9k_ops_config {
+	int dma_beacon_response_time;
+	int sw_beacon_response_time;
+	int additional_swba_backoff;
+	int ack_6mb;
+	int cwm_ignore_extcca;
+	u8 pcie_powersave_enable;
+	u8 pcie_l1skp_enable;
+	u8 pcie_clock_req;
+	u32 pcie_waen;
+	int pcie_power_reset;
+	u8 pcie_restore;
+	u8 analog_shiftreg;
+	u8 ht_enable;
+	u32 ofdm_trig_low;
+	u32 ofdm_trig_high;
+	u32 cck_trig_high;
+	u32 cck_trig_low;
+	u32 enable_ani;
+	u8 noise_immunity_level;
+	u32 ofdm_weaksignal_det;
+	u32 cck_weaksignal_thr;
+	u8 spur_immunity_level;
+	u8 firstep_level;
+	int8_t rssi_thr_high;
+	int8_t rssi_thr_low;
+	u16 diversity_control;
+	u16 antenna_switch_swap;
+	int serialize_regmode;
+	int intr_mitigation;
 #define SPUR_DISABLE        	0
 #define SPUR_ENABLE_IOCTL   	1
 #define SPUR_ENABLE_EEPROM  	2
@@ -246,8 +247,8 @@ struct hal_ops_config {
 #define AR_BASE_FREQ_5GHZ   	4900
 #define AR_SPUR_FEEQ_BOUND_HT40 19
 #define AR_SPUR_FEEQ_BOUND_HT20 10
-	int ath_hal_spurMode;
-	u16 ath_hal_spurChans[AR_EEPROM_MODAL_SPURS][2];
+	int spurmode;
+	u16 spurchans[AR_EEPROM_MODAL_SPURS][2];
 };
 
 enum ath9k_tx_queue {
@@ -815,8 +816,8 @@ struct ath_hal {
 	u8 ah_decompMask[ATH9K_DECOMP_MASK_SIZE];
 	u32 ah_flags;
 	enum ath9k_opmode ah_opmode;
-	struct hal_ops_config ah_config;
-	struct hal_capabilities ah_caps;
+	struct ath9k_ops_config ah_config;
+	struct ath9k_hw_capabilities ah_caps;
 	int16_t ah_powerLimit;
 	u16 ah_maxPowerLevel;
 	u32 ah_tpScale;
@@ -878,7 +879,7 @@ struct chan_centers {
 };
 
 int ath_hal_getcapability(struct ath_hal *ah,
-			  enum hal_capability_type type,
+			  enum ath9k_capability_type type,
 			  u32 capability,
 			  u32 *result);
 const struct ath9k_rate_table *ath9k_hw_getratetable(struct ath_hal *ah,
@@ -947,11 +948,11 @@ void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum ath9k_ht_macmode mode);
 bool ath9k_hw_phycounters(struct ath_hal *ah);
 bool ath9k_hw_keyreset(struct ath_hal *ah, u16 entry);
 bool ath9k_hw_getcapability(struct ath_hal *ah,
-			    enum hal_capability_type type,
+			    enum ath9k_capability_type type,
 			    u32 capability,
 			    u32 *result);
 bool ath9k_hw_setcapability(struct ath_hal *ah,
-			    enum hal_capability_type type,
+			    enum ath9k_capability_type type,
 			    u32 capability,
 			    u32 setting,
 			    int *status);
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 00993f8..ba3dd25 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -85,7 +85,8 @@ static void ath_beacon_setup(struct ath_softc *sc,
 
 	flags = ATH9K_TXDESC_NOACK;
 
-	if (sc->sc_opmode == ATH9K_M_IBSS && ah->ah_caps.halVEOLSupport) {
+	if (sc->sc_opmode == ATH9K_M_IBSS &&
+	    (ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
 		ds->ds_link = bf->bf_daddr; /* self-linked */
 		flags |= ATH9K_TXDESC_VEOL;
 		/* Let hardware handle antenna switching. */
@@ -375,7 +376,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 		list_del(&avp->av_bcbuf->list);
 
 		if (sc->sc_opmode == ATH9K_M_HOSTAP ||
-			!sc->sc_ah->ah_caps.halVEOLSupport) {
+		    !(sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
 			int slot;
 			/*
 			 * Assign the vap to a beacon xmit slot. As
@@ -939,7 +940,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 			 * deal with things.
 			 */
 			intval |= ATH9K_BEACON_ENA;
-			if (!ah->ah_caps.halVEOLSupport)
+			if (!(ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL))
 				sc->sc_imask |= ATH9K_INT_SWBA;
 			ath_beaconq_config(sc);
 		} else if (sc->sc_opmode == ATH9K_M_HOSTAP) {
@@ -958,7 +959,8 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		 * When using a self-linked beacon descriptor in
 		 * ibss mode load it once here.
 		 */
-		if (sc->sc_opmode == ATH9K_M_IBSS && ah->ah_caps.halVEOLSupport)
+		if (sc->sc_opmode == ATH9K_M_IBSS &&
+		    (ah->ah_caps.hw_caps & ATH9K_HW_CAP_VEOL))
 			ath_beacon_start_adhoc(sc, 0);
 	}
 #undef TSF_TO_TU
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index e8b3f1f..f7bf078 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -536,7 +536,7 @@ int ath_chainmask_sel_logic(struct ath_softc *sc, struct ath_node *an)
 	 * sc_chainmask_auto_sel is used for internal global auto-switching
 	 * enabled/disabled setting
 	 */
-	if (sc->sc_ah->ah_caps.halTxChainMask != ATH_CHAINMASK_SEL_3X3) {
+	if (sc->sc_ah->ah_caps.tx_chainmask != ATH_CHAINMASK_SEL_3X3) {
 		cm->cur_tx_mask = sc->sc_tx_chainmask;
 		return cm->cur_tx_mask;
 	}
@@ -580,8 +580,8 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 {
 	sc->sc_update_chainmask = 1;
 	if (is_ht) {
-		sc->sc_tx_chainmask = sc->sc_ah->ah_caps.halTxChainMask;
-		sc->sc_rx_chainmask = sc->sc_ah->ah_caps.halRxChainMask;
+		sc->sc_tx_chainmask = sc->sc_ah->ah_caps.tx_chainmask;
+		sc->sc_rx_chainmask = sc->sc_ah->ah_caps.rx_chainmask;
 	} else {
 		sc->sc_tx_chainmask = 1;
 		sc->sc_rx_chainmask = 1;
@@ -780,8 +780,8 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	ath_stop(sc);
 
 	/* Initialize chanmask selection */
-	sc->sc_tx_chainmask = ah->ah_caps.halTxChainMask;
-	sc->sc_rx_chainmask = ah->ah_caps.halRxChainMask;
+	sc->sc_tx_chainmask = ah->ah_caps.tx_chainmask;
+	sc->sc_rx_chainmask = ah->ah_caps.rx_chainmask;
 
 	/* Reset SERDES registers */
 	ath9k_hw_configpcipowersave(ah, 0);
@@ -832,10 +832,10 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 		| ATH9K_INT_RXEOL | ATH9K_INT_RXORN
 		| ATH9K_INT_FATAL | ATH9K_INT_GLOBAL;
 
-	if (ah->ah_caps.halGTTSupport)
+	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_GTT)
 		sc->sc_imask |= ATH9K_INT_GTT;
 
-	if (ah->ah_caps.halHTSupport)
+	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
 		sc->sc_imask |= ATH9K_INT_CST;
 
 	/*
@@ -851,8 +851,9 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	 * that does, if not overridden by configuration,
 	 * enable the TIM interrupt when operating as station.
 	 */
-	if (ah->ah_caps.halEnhancedPmSupport && sc->sc_opmode == ATH9K_M_STA &&
-		!sc->sc_config.swBeaconProcess)
+	if ((ah->ah_caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
+	    (sc->sc_opmode == ATH9K_M_STA) &&
+	    !sc->sc_config.swBeaconProcess)
 		sc->sc_imask |= ATH9K_INT_TIM;
 	/*
 	 *  Don't enable interrupts here as we've not yet built our
@@ -1061,7 +1062,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 				ath9k_hw_set_interrupts(ah, sc->sc_imask);
 			}
 			if (status & ATH9K_INT_TIM_TIMER) {
-				if (!ah->ah_caps.halAutoSleepSupport) {
+				if (!(ah->ah_caps.hw_caps &
+				      ATH9K_HW_CAP_AUTOSLEEP)) {
 					/* Clear RxAbort bit so that we can
 					 * receive frames */
 					ath9k_hw_setrxabort(ah, 0);
@@ -1166,10 +1168,10 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	sc->sc_ah = ah;
 
 	/* Get the chipset-specific aggr limit. */
-	sc->sc_rtsaggrlimit = ah->ah_caps.halRtsAggrLimit;
+	sc->sc_rtsaggrlimit = ah->ah_caps.rts_aggr_limit;
 
 	/* Get the hardware key cache size. */
-	sc->sc_keymax = ah->ah_caps.halKeyCacheSize;
+	sc->sc_keymax = ah->ah_caps.keycache_size;
 	if (sc->sc_keymax > ATH_KEYMAX) {
 		DPRINTF(sc, ATH_DBG_KEYCACHE,
 			"%s: Warning, using only %u entries in %u key cache\n",
@@ -1284,7 +1286,7 @@ int ath_init(u16 devid, struct ath_softc *sc)
 		goto bad2;
 	}
 
-	if (ath9k_hw_getcapability(ah, HAL_CAP_CIPHER,
+	if (ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
 				   ATH9K_CIPHER_TKIP, NULL)) {
 		/*
 		 * Whether we should enable h/w TKIP MIC.
@@ -1292,7 +1294,8 @@ int ath_init(u16 devid, struct ath_softc *sc)
 		 * report WMM capable, so it's always safe to turn on
 		 * TKIP MIC in this case.
 		 */
-		ath9k_hw_setcapability(sc->sc_ah, HAL_CAP_TKIP_MIC, 0, 1, NULL);
+		ath9k_hw_setcapability(sc->sc_ah, ATH9K_CAP_TKIP_MIC,
+				       0, 1, NULL);
 	}
 
 	/*
@@ -1301,30 +1304,30 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	 * With split mic keys the number of stations is limited
 	 * to 27 otherwise 59.
 	 */
-	if (ath9k_hw_getcapability(ah, HAL_CAP_CIPHER,
+	if (ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
 				   ATH9K_CIPHER_TKIP, NULL)
-	    && ath9k_hw_getcapability(ah, HAL_CAP_CIPHER,
+	    && ath9k_hw_getcapability(ah, ATH9K_CAP_CIPHER,
 				      ATH9K_CIPHER_MIC, NULL)
-	    && ath9k_hw_getcapability(ah, HAL_CAP_TKIP_SPLIT,
+	    && ath9k_hw_getcapability(ah, ATH9K_CAP_TKIP_SPLIT,
 				      0, NULL))
 		sc->sc_splitmic = 1;
 
 	/* turn on mcast key search if possible */
-	if (!ath9k_hw_getcapability(ah, HAL_CAP_MCAST_KEYSRCH, 0, NULL))
-		(void)ath9k_hw_setcapability(ah, HAL_CAP_MCAST_KEYSRCH, 1,
+	if (!ath9k_hw_getcapability(ah, ATH9K_CAP_MCAST_KEYSRCH, 0, NULL))
+		(void)ath9k_hw_setcapability(ah, ATH9K_CAP_MCAST_KEYSRCH, 1,
 					     1, NULL);
 
 	sc->sc_config.txpowlimit = ATH_TXPOWER_MAX;
 	sc->sc_config.txpowlimit_override = 0;
 
 	/* 11n Capabilities */
-	if (ah->ah_caps.halHTSupport) {
+	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) {
 		sc->sc_txaggr = 1;
 		sc->sc_rxaggr = 1;
 	}
 
-	sc->sc_tx_chainmask = ah->ah_caps.halTxChainMask;
-	sc->sc_rx_chainmask = ah->ah_caps.halRxChainMask;
+	sc->sc_tx_chainmask = ah->ah_caps.tx_chainmask;
+	sc->sc_rx_chainmask = ah->ah_caps.rx_chainmask;
 
 	/* Configuration for rx chain detection */
 	sc->sc_rxchaindetect_ref = 0;
@@ -1333,11 +1336,11 @@ int ath_init(u16 devid, struct ath_softc *sc)
 	sc->sc_rxchaindetect_delta5GHz = 30;
 	sc->sc_rxchaindetect_delta2GHz = 30;
 
-	ath9k_hw_setcapability(ah, HAL_CAP_DIVERSITY, 1, true, NULL);
+	ath9k_hw_setcapability(ah, ATH9K_CAP_DIVERSITY, 1, true, NULL);
 	sc->sc_defant = ath9k_hw_getdefantenna(ah);
 
 	ath9k_hw_getmac(ah, sc->sc_myaddr);
-	if (ah->ah_caps.halBssIdMaskSupport) {
+	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK) {
 		ath9k_hw_getbssidmask(ah, sc->sc_bssidmask);
 		ATH_SET_VAP_BSSID_MASK(sc->sc_bssidmask);
 		ath9k_hw_setbssidmask(ah, sc->sc_bssidmask);
@@ -1555,7 +1558,7 @@ void ath_update_txpow(struct ath_softc *sc)
 	if (sc->sc_curtxpow != sc->sc_config.txpowlimit) {
 		ath9k_hw_set_txpowerlimit(ah, sc->sc_config.txpowlimit);
 		/* read back in case value is clamped */
-		ath9k_hw_getcapability(ah, HAL_CAP_TXPOW, 1, &txpow);
+		ath9k_hw_getcapability(ah, ATH9K_CAP_TXPOW, 1, &txpow);
 		sc->sc_curtxpow = txpow;
 	}
 }
@@ -1757,7 +1760,7 @@ int ath_descdma_setup(struct ath_softc *sc,
 	 * descriptors that cross the 4K page boundary. Assume
 	 * one skipped descriptor per 4K page.
 	 */
-	if (!(sc->sc_ah->ah_caps.hal4kbSplitTransSupport)) {
+	if (!(sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_4KB_SPLITTRANS)) {
 		u32 ndesc_skipped =
 			ATH_DESC_4KB_BOUND_NUM_SKIPPED(dd->dd_desc_len);
 		u32 dma_len;
@@ -1798,7 +1801,8 @@ int ath_descdma_setup(struct ath_softc *sc,
 		bf->bf_desc = ds;
 		bf->bf_daddr = DS2PHYS(dd, ds);
 
-		if (!(sc->sc_ah->ah_caps.hal4kbSplitTransSupport)) {
+		if (!(sc->sc_ah->ah_caps.hw_caps &
+		      ATH9K_HW_CAP_4KB_SPLITTRANS)) {
 			/*
 			 * Skip descriptor addresses which can cause 4KB
 			 * boundary crossing (addr + length) with a 32 dword
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 1f6f393..4ee3116 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -335,40 +335,40 @@ static void ath9k_hw_set_defaults(struct ath_hal *ah)
 {
 	int i;
 
-	ah->ah_config.ath_hal_dma_beacon_response_time = 2;
-	ah->ah_config.ath_hal_sw_beacon_response_time = 10;
-	ah->ah_config.ath_hal_additional_swba_backoff = 0;
-	ah->ah_config.ath_hal_6mb_ack = 0x0;
-	ah->ah_config.ath_hal_cwmIgnoreExtCCA = 0;
-	ah->ah_config.ath_hal_pciePowerSaveEnable = 0;
-	ah->ah_config.ath_hal_pcieL1SKPEnable = 0;
-	ah->ah_config.ath_hal_pcieClockReq = 0;
-	ah->ah_config.ath_hal_pciePowerReset = 0x100;
-	ah->ah_config.ath_hal_pcieRestore = 0;
-	ah->ah_config.ath_hal_pcieWaen = 0;
-	ah->ah_config.ath_hal_analogShiftReg = 1;
-	ah->ah_config.ath_hal_htEnable = 1;
-	ah->ah_config.ath_hal_ofdmTrigLow = 200;
-	ah->ah_config.ath_hal_ofdmTrigHigh = 500;
-	ah->ah_config.ath_hal_cckTrigHigh = 200;
-	ah->ah_config.ath_hal_cckTrigLow = 100;
-	ah->ah_config.ath_hal_enableANI = 0;
-	ah->ah_config.ath_hal_noiseImmunityLvl = 4;
-	ah->ah_config.ath_hal_ofdmWeakSigDet = 1;
-	ah->ah_config.ath_hal_cckWeakSigThr = 0;
-	ah->ah_config.ath_hal_spurImmunityLvl = 2;
-	ah->ah_config.ath_hal_firStepLvl = 0;
-	ah->ah_config.ath_hal_rssiThrHigh = 40;
-	ah->ah_config.ath_hal_rssiThrLow = 7;
-	ah->ah_config.ath_hal_diversityControl = 0;
-	ah->ah_config.ath_hal_antennaSwitchSwap = 0;
+	ah->ah_config.dma_beacon_response_time = 2;
+	ah->ah_config.sw_beacon_response_time = 10;
+	ah->ah_config.additional_swba_backoff = 0;
+	ah->ah_config.ack_6mb = 0x0;
+	ah->ah_config.cwm_ignore_extcca = 0;
+	ah->ah_config.pcie_powersave_enable = 0;
+	ah->ah_config.pcie_l1skp_enable = 0;
+	ah->ah_config.pcie_clock_req = 0;
+	ah->ah_config.pcie_power_reset = 0x100;
+	ah->ah_config.pcie_restore = 0;
+	ah->ah_config.pcie_waen = 0;
+	ah->ah_config.analog_shiftreg = 1;
+	ah->ah_config.ht_enable = 1;
+	ah->ah_config.ofdm_trig_low = 200;
+	ah->ah_config.ofdm_trig_high = 500;
+	ah->ah_config.cck_trig_high = 200;
+	ah->ah_config.cck_trig_low = 100;
+	ah->ah_config.enable_ani = 0;
+	ah->ah_config.noise_immunity_level = 4;
+	ah->ah_config.ofdm_weaksignal_det = 1;
+	ah->ah_config.cck_weaksignal_thr = 0;
+	ah->ah_config.spur_immunity_level = 2;
+	ah->ah_config.firstep_level = 0;
+	ah->ah_config.rssi_thr_high = 40;
+	ah->ah_config.rssi_thr_low = 7;
+	ah->ah_config.diversity_control = 0;
+	ah->ah_config.antenna_switch_swap = 0;
 
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
-		ah->ah_config.ath_hal_spurChans[i][0] = AR_NO_SPUR;
-		ah->ah_config.ath_hal_spurChans[i][1] = AR_NO_SPUR;
+		ah->ah_config.spurchans[i][0] = AR_NO_SPUR;
+		ah->ah_config.spurchans[i][1] = AR_NO_SPUR;
 	}
 
-	ah->ah_config.ath_hal_intrMitigation = 0;
+	ah->ah_config.intr_mitigation = 0;
 }
 
 static inline void ath9k_hw_override_ini(struct ath_hal *ah,
@@ -458,7 +458,7 @@ static void ath9k_hw_analog_shift_rmw(struct ath_hal *ah,
 
 	REG_WRITE(ah, reg, regVal);
 
-	if (ah->ah_config.ath_hal_analogShiftReg)
+	if (ah->ah_config.analog_shiftreg)
 		udelay(100);
 
 	return;
@@ -1001,7 +1001,7 @@ void ath9k_hw_setrxfilter(struct ath_hal *ah, u32 bits)
 }
 
 bool ath9k_hw_setcapability(struct ath_hal *ah,
-			    enum hal_capability_type type,
+			    enum ath9k_capability_type type,
 			    u32 capability,
 			    u32 setting,
 			    int *status)
@@ -1010,7 +1010,7 @@ bool ath9k_hw_setcapability(struct ath_hal *ah,
 	u32 v;
 
 	switch (type) {
-	case HAL_CAP_TKIP_MIC:
+	case ATH9K_CAP_TKIP_MIC:
 		if (setting)
 			ahp->ah_staId1Defaults |=
 				AR_STA_ID1_CRPT_MIC_ENABLE;
@@ -1018,7 +1018,7 @@ bool ath9k_hw_setcapability(struct ath_hal *ah,
 			ahp->ah_staId1Defaults &=
 				~AR_STA_ID1_CRPT_MIC_ENABLE;
 		return true;
-	case HAL_CAP_DIVERSITY:
+	case ATH9K_CAP_DIVERSITY:
 		v = REG_READ(ah, AR_PHY_CCK_DETECT);
 		if (setting)
 			v |= AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
@@ -1026,13 +1026,13 @@ bool ath9k_hw_setcapability(struct ath_hal *ah,
 			v &= ~AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
 		REG_WRITE(ah, AR_PHY_CCK_DETECT, v);
 		return true;
-	case HAL_CAP_MCAST_KEYSRCH:
+	case ATH9K_CAP_MCAST_KEYSRCH:
 		if (setting)
 			ahp->ah_staId1Defaults |= AR_STA_ID1_MCAST_KSRCH;
 		else
 			ahp->ah_staId1Defaults &= ~AR_STA_ID1_MCAST_KSRCH;
 		return true;
-	case HAL_CAP_TSF_ADJUST:
+	case ATH9K_CAP_TSF_ADJUST:
 		if (setting)
 			ahp->ah_miscMode |= AR_PCU_TX_ADD_TSF;
 		else
@@ -1161,7 +1161,7 @@ void ath9k_hw_set11nmac2040(struct ath_hal *ah, enum ath9k_ht_macmode mode)
 	u32 macmode;
 
 	if (mode == ATH9K_HT_MACMODE_2040 &&
-	    !ah->ah_config.ath_hal_cwmIgnoreExtCCA)
+	    !ah->ah_config.cwm_ignore_extcca)
 		macmode = AR_2040_JOINED_RX_CLEAR;
 	else
 		macmode = 0;
@@ -1214,9 +1214,9 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u16 devid,
 	ah->ah_tpScale = ATH9K_TP_SCALE_MAX;
 
 	ahp->ah_atimWindow = 0;
-	ahp->ah_diversityControl = ah->ah_config.ath_hal_diversityControl;
+	ahp->ah_diversityControl = ah->ah_config.diversity_control;
 	ahp->ah_antennaSwitchSwap =
-		ah->ah_config.ath_hal_antennaSwitchSwap;
+		ah->ah_config.antenna_switch_swap;
 
 	ahp->ah_staId1Defaults = AR_STA_ID1_CRPT_MIC_ENABLE;
 	ahp->ah_beaconInterval = 100;
@@ -1371,13 +1371,13 @@ static u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah,
 
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 		 "Getting spur idx %d is2Ghz. %d val %x\n",
-		 i, is2GHz, ah->ah_config.ath_hal_spurChans[i][is2GHz]);
+		 i, is2GHz, ah->ah_config.spurchans[i][is2GHz]);
 
-	switch (ah->ah_config.ath_hal_spurMode) {
+	switch (ah->ah_config.spurmode) {
 	case SPUR_DISABLE:
 		break;
 	case SPUR_ENABLE_IOCTL:
-		spur_val = ah->ah_config.ath_hal_spurChans[i][is2GHz];
+		spur_val = ah->ah_config.spurchans[i][is2GHz];
 		DPRINTF(ah->ah_sc, ATH_DBG_ANI,
 			 "Getting spur val from new loc. %d\n", spur_val);
 		break;
@@ -2094,7 +2094,7 @@ static void ath9k_hw_ani_attach(struct ath_hal *ah)
 		ath9k_enable_mib_counters(ah);
 	}
 	ahp->ah_aniPeriod = ATH9K_ANI_PERIOD;
-	if (ah->ah_config.ath_hal_enableANI)
+	if (ah->ah_config.enable_ani)
 		ahp->ah_procPhyErr |= HAL_PROCESS_ANI;
 }
 
@@ -2504,13 +2504,13 @@ static void ath9k_ani_reset(struct ath_hal *ah)
 				     ATH9K_RX_FILTER_PHYERR);
 		if (ah->ah_opmode == ATH9K_M_HOSTAP) {
 			ahp->ah_curani->ofdmTrigHigh =
-				ah->ah_config.ath_hal_ofdmTrigHigh;
+				ah->ah_config.ofdm_trig_high;
 			ahp->ah_curani->ofdmTrigLow =
-				ah->ah_config.ath_hal_ofdmTrigLow;
+				ah->ah_config.ofdm_trig_low;
 			ahp->ah_curani->cckTrigHigh =
-				ah->ah_config.ath_hal_cckTrigHigh;
+				ah->ah_config.cck_trig_high;
 			ahp->ah_curani->cckTrigLow =
-				ah->ah_config.ath_hal_cckTrigLow;
+				ah->ah_config.cck_trig_low;
 		}
 		ath9k_ani_restart(ah);
 		return;
@@ -2870,7 +2870,7 @@ static bool ath9k_hw_set_gpio(struct ath_hal *ah, u32 gpio,
 
 static u32 ath9k_hw_gpio_get(struct ath_hal *ah, u32 gpio)
 {
-	if (gpio >= ah->ah_caps.halNumGpioPins)
+	if (gpio >= ah->ah_caps.num_gpio_pins)
 		return 0xffffffff;
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
@@ -2947,7 +2947,7 @@ static u32 ath9k_hw_ini_fixup(struct ath_hal *ah,
 static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	u16 capField = 0, eeval;
 
 	eeval = ath9k_hw_get_eeprom(ahp, EEP_REG_0);
@@ -2970,12 +2970,12 @@ static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 			 ah->ah_currentRD);
 	}
 
-	pCap->halWirelessModes = 0;
+	pCap->wireless_modes = 0;
 	eeval = ath9k_hw_get_eeprom(ahp, EEP_OP_MODE);
 
 	if (eeval & AR5416_OPFLAGS_11A) {
-		pCap->halWirelessModes |= ATH9K_MODE_SEL_11A |
-			((!ah->ah_config.ath_hal_htEnable
+		pCap->wireless_modes |= ATH9K_MODE_SEL_11A |
+			((!ah->ah_config.ht_enable
 			  || (eeval & AR5416_OPFLAGS_N_5G_HT20)) ? 0
 			 : (ATH9K_MODE_SEL_11NA_HT20 |
 			    ((eeval & AR5416_OPFLAGS_N_5G_HT40) ? 0
@@ -2983,9 +2983,9 @@ static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 				ATH9K_MODE_SEL_11NA_HT40MINUS))));
 	}
 	if (eeval & AR5416_OPFLAGS_11G) {
-		pCap->halWirelessModes |=
+		pCap->wireless_modes |=
 			ATH9K_MODE_SEL_11B | ATH9K_MODE_SEL_11G |
-			((!ah->ah_config.ath_hal_htEnable
+			((!ah->ah_config.ht_enable
 			  || (eeval & AR5416_OPFLAGS_N_2G_HT20)) ? 0
 			 : (ATH9K_MODE_SEL_11NG_HT20 |
 			    ((eeval & AR5416_OPFLAGS_N_2G_HT40) ? 0
@@ -2993,79 +2993,82 @@ static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 				ATH9K_MODE_SEL_11NG_HT40MINUS))));
 
 	}
-	pCap->halTxChainMask = ath9k_hw_get_eeprom(ahp, EEP_TX_MASK);
+	pCap->tx_chainmask = ath9k_hw_get_eeprom(ahp, EEP_TX_MASK);
 	if ((ah->ah_isPciExpress)
 	    || (eeval & AR5416_OPFLAGS_11A)) {
-		pCap->halRxChainMask =
+		pCap->rx_chainmask =
 			ath9k_hw_get_eeprom(ahp, EEP_RX_MASK);
 	} else {
-		pCap->halRxChainMask =
+		pCap->rx_chainmask =
 			(ath9k_hw_gpio_get(ah, 0)) ? 0x5 : 0x7;
 	}
 
 	if (!(AR_SREV_9280(ah) && (ah->ah_macRev == 0)))
 		ahp->ah_miscMode |= AR_PCU_MIC_NEW_LOC_ENA;
 
-	pCap->halLow2GhzChan = 2312;
-	pCap->halHigh2GhzChan = 2732;
+	pCap->low_2ghz_chan = 2312;
+	pCap->high_2ghz_chan = 2732;
 
-	pCap->halLow5GhzChan = 4920;
-	pCap->halHigh5GhzChan = 6100;
+	pCap->low_5ghz_chan = 4920;
+	pCap->high_5ghz_chan = 6100;
 
-	pCap->halCipherCkipSupport = false;
-	pCap->halCipherTkipSupport = true;
-	pCap->halCipherAesCcmSupport = true;
+	pCap->hw_caps &= ~ATH9K_HW_CAP_CIPHER_CKIP;
+	pCap->hw_caps |= ATH9K_HW_CAP_CIPHER_TKIP;
+	pCap->hw_caps |= ATH9K_HW_CAP_CIPHER_AESCCM;
 
-	pCap->halMicCkipSupport = false;
-	pCap->halMicTkipSupport = true;
-	pCap->halMicAesCcmSupport = true;
+	pCap->hw_caps &= ~ATH9K_HW_CAP_MIC_CKIP;
+	pCap->hw_caps |= ATH9K_HW_CAP_MIC_TKIP;
+	pCap->hw_caps |= ATH9K_HW_CAP_MIC_AESCCM;
 
-	pCap->halChanSpreadSupport = true;
+	pCap->hw_caps |= ATH9K_HW_CAP_CHAN_SPREAD;
 
-	pCap->halHTSupport =
-		ah->ah_config.ath_hal_htEnable ? true : false;
-	pCap->halGTTSupport = true;
-	pCap->halVEOLSupport = true;
-	pCap->halBssIdMaskSupport = true;
-	pCap->halMcastKeySrchSupport = false;
+	if (ah->ah_config.ht_enable)
+		pCap->hw_caps |= ATH9K_HW_CAP_HT;
+	else
+		pCap->hw_caps &= ~ATH9K_HW_CAP_HT;
+
+	pCap->hw_caps |= ATH9K_HW_CAP_GTT;
+	pCap->hw_caps |= ATH9K_HW_CAP_VEOL;
+	pCap->hw_caps |= ATH9K_HW_CAP_BSSIDMASK;
+	pCap->hw_caps &= ~ATH9K_HW_CAP_MCAST_KEYSEARCH;
 
 	if (capField & AR_EEPROM_EEPCAP_MAXQCU)
-		pCap->halTotalQueues =
+		pCap->total_queues =
 			MS(capField, AR_EEPROM_EEPCAP_MAXQCU);
 	else
-		pCap->halTotalQueues = ATH9K_NUM_TX_QUEUES;
+		pCap->total_queues = ATH9K_NUM_TX_QUEUES;
 
 	if (capField & AR_EEPROM_EEPCAP_KC_ENTRIES)
-		pCap->halKeyCacheSize =
+		pCap->keycache_size =
 			1 << MS(capField, AR_EEPROM_EEPCAP_KC_ENTRIES);
 	else
-		pCap->halKeyCacheSize = AR_KEYTABLE_SIZE;
+		pCap->keycache_size = AR_KEYTABLE_SIZE;
 
-	pCap->halFastCCSupport = true;
-	pCap->halNumMRRetries = 4;
-	pCap->halTxTrigLevelMax = MAX_TX_FIFO_THRESHOLD;
+	pCap->hw_caps |= ATH9K_HW_CAP_FASTCC;
+	pCap->num_mr_retries = 4;
+	pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD;
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
-		pCap->halNumGpioPins = AR928X_NUM_GPIO;
+		pCap->num_gpio_pins = AR928X_NUM_GPIO;
 	else
-		pCap->halNumGpioPins = AR_NUM_GPIO;
+		pCap->num_gpio_pins = AR_NUM_GPIO;
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
-		pCap->halWowSupport = true;
-		pCap->halWowMatchPatternExact = true;
+		pCap->hw_caps |= ATH9K_HW_CAP_WOW;
+		pCap->hw_caps |= ATH9K_HW_CAP_WOW_MATCHPATTERN_EXACT;
 	} else {
-		pCap->halWowSupport = false;
-		pCap->halWowMatchPatternExact = false;
+		pCap->hw_caps &= ~ATH9K_HW_CAP_WOW;
+		pCap->hw_caps &= ~ATH9K_HW_CAP_WOW_MATCHPATTERN_EXACT;
 	}
 
 	if (AR_SREV_9160_10_OR_LATER(ah) || AR_SREV_9100(ah)) {
-		pCap->halCSTSupport = true;
-		pCap->halRtsAggrLimit = ATH_AMPDU_LIMIT_MAX;
+		pCap->hw_caps |= ATH9K_HW_CAP_CST;
+		pCap->rts_aggr_limit = ATH_AMPDU_LIMIT_MAX;
 	} else {
-		pCap->halRtsAggrLimit = (8 * 1024);
+		pCap->rts_aggr_limit = (8 * 1024);
 	}
 
-	pCap->halEnhancedPmSupport = true;
+	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
 
 	ah->ah_rfsilent = ath9k_hw_get_eeprom(ahp, EEP_RF_SILENT);
 	if (ah->ah_rfsilent & EEP_RFSILENT_ENABLED) {
@@ -3074,9 +3077,9 @@ static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 		ahp->ah_polarity =
 			MS(ah->ah_rfsilent, EEP_RFSILENT_POLARITY);
 
-		ath9k_hw_setcapability(ah, HAL_CAP_RFSILENT, 1, true,
+		ath9k_hw_setcapability(ah, ATH9K_CAP_RFSILENT, 1, true,
 				       NULL);
-		pCap->halRfSilentSupport = true;
+		pCap->hw_caps |= ATH9K_HW_CAP_RFSILENT;
 	}
 
 	if ((ah->ah_macVersion == AR_SREV_VERSION_5416_PCI) ||
@@ -3084,32 +3087,32 @@ static bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	    (ah->ah_macVersion == AR_SREV_VERSION_9160) ||
 	    (ah->ah_macVersion == AR_SREV_VERSION_9100) ||
 	    (ah->ah_macVersion == AR_SREV_VERSION_9280))
-		pCap->halAutoSleepSupport = false;
+		pCap->hw_caps &= ~ATH9K_HW_CAP_AUTOSLEEP;
 	else
-		pCap->halAutoSleepSupport = true;
+		pCap->hw_caps |= ATH9K_HW_CAP_AUTOSLEEP;
 
 	if (AR_SREV_9280(ah))
-		pCap->hal4kbSplitTransSupport = false;
+		pCap->hw_caps &= ~ATH9K_HW_CAP_4KB_SPLITTRANS;
 	else
-		pCap->hal4kbSplitTransSupport = true;
+		pCap->hw_caps |= ATH9K_HW_CAP_4KB_SPLITTRANS;
 
 	if (ah->ah_currentRDExt & (1 << REG_EXT_JAPAN_MIDBAND)) {
-		pCap->halRegCap =
+		pCap->reg_cap =
 			AR_EEPROM_EEREGCAP_EN_KK_NEW_11A |
 			AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN |
 			AR_EEPROM_EEREGCAP_EN_KK_U2 |
 			AR_EEPROM_EEREGCAP_EN_KK_MIDBAND;
 	} else {
-		pCap->halRegCap =
+		pCap->reg_cap =
 			AR_EEPROM_EEREGCAP_EN_KK_NEW_11A |
 			AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN;
 	}
 
-	pCap->halRegCap |= AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND;
+	pCap->reg_cap |= AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND;
 
-	pCap->halNumAntCfg5GHz =
+	pCap->num_antcfg_5ghz =
 		ath9k_hw_get_num_ant_config(ahp, HAL_FREQ_BAND_5GHZ);
-	pCap->halNumAntCfg2GHz =
+	pCap->num_antcfg_2ghz =
 		ath9k_hw_get_num_ant_config(ahp, HAL_FREQ_BAND_2GHZ);
 
 	return true;
@@ -3151,9 +3154,9 @@ static void ath9k_set_power_network_sleep(struct ath_hal *ah, int setChip)
 {
 	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 	if (setChip) {
-		struct hal_capabilities *pCap = &ah->ah_caps;
+		struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 
-		if (!pCap->halAutoSleepSupport) {
+		if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
 			REG_WRITE(ah, AR_RTC_FORCE_WAKE,
 				  AR_RTC_FORCE_WAKE_ON_INT);
 		} else {
@@ -3262,7 +3265,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid,
 
 	ath9k_hw_set_defaults(ah);
 
-	if (ah->ah_config.ath_hal_intrMitigation != 0)
+	if (ah->ah_config.intr_mitigation != 0)
 		ahp->ah_intrMitigation = true;
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
@@ -3279,18 +3282,18 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid,
 		goto bad;
 	}
 
-	if (ah->ah_config.ath_hal_serializeRegMode == SER_REG_MODE_AUTO) {
+	if (ah->ah_config.serialize_regmode == SER_REG_MODE_AUTO) {
 		if (ah->ah_macVersion == AR_SREV_VERSION_5416_PCI) {
-			ah->ah_config.ath_hal_serializeRegMode =
+			ah->ah_config.serialize_regmode =
 				SER_REG_MODE_ON;
 		} else {
-			ah->ah_config.ath_hal_serializeRegMode =
+			ah->ah_config.serialize_regmode =
 				SER_REG_MODE_OFF;
 		}
 	}
 	DPRINTF(ah->ah_sc, ATH_DBG_RESET,
-		"%s: ath_hal_serializeRegMode is %d\n",
-		__func__, ah->ah_config.ath_hal_serializeRegMode);
+		"%s: serialize_regmode is %d\n",
+		__func__, ah->ah_config.serialize_regmode);
 
 	if ((ah->ah_macVersion != AR_SREV_VERSION_5416_PCI) &&
 	    (ah->ah_macVersion != AR_SREV_VERSION_5416_PCIE) &&
@@ -3334,7 +3337,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid,
 	}
 
 	if (AR_SREV_9160(ah)) {
-		ah->ah_config.ath_hal_enableANI = 1;
+		ah->ah_config.enable_ani = 1;
 		ahp->ah_ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
 					ATH9K_ANI_FIRSTEP_LEVEL);
 	} else {
@@ -3355,7 +3358,7 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid,
 		INIT_INI_ARRAY(&ahp->ah_iniCommon, ar9280Common_9280_2,
 			       ARRAY_SIZE(ar9280Common_9280_2), 2);
 
-		if (ah->ah_config.ath_hal_pcieClockReq) {
+		if (ah->ah_config.pcie_clock_req) {
 			INIT_INI_ARRAY(&ahp->ah_iniPcieSerdes,
 				       ar9280PciePhy_clkreq_off_L1_9280,
 				       ARRAY_SIZE
@@ -3528,16 +3531,16 @@ bool ath9k_get_channel_edges(struct ath_hal *ah,
 			     u16 flags, u16 *low,
 			     u16 *high)
 {
-	struct hal_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 
 	if (flags & CHANNEL_5GHZ) {
-		*low = pCap->halLow5GhzChan;
-		*high = pCap->halHigh5GhzChan;
+		*low = pCap->low_5ghz_chan;
+		*high = pCap->high_5ghz_chan;
 		return true;
 	}
 	if ((flags & CHANNEL_2GHZ)) {
-		*low = pCap->halLow2GhzChan;
-		*high = pCap->halHigh2GhzChan;
+		*low = pCap->low_2ghz_chan;
+		*high = pCap->high_2ghz_chan;
 
 		return true;
 	}
@@ -3908,7 +3911,7 @@ void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
 	if (ah->ah_isPciExpress != true)
 		return;
 
-	if (ah->ah_config.ath_hal_pciePowerSaveEnable == 2)
+	if (ah->ah_config.pcie_powersave_enable == 2)
 		return;
 
 	if (restore)
@@ -3929,7 +3932,7 @@ void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
 		REG_WRITE(ah, AR_PCIE_SERDES, 0x13160820);
 		REG_WRITE(ah, AR_PCIE_SERDES, 0xe5980560);
 
-		if (ah->ah_config.ath_hal_pcieClockReq)
+		if (ah->ah_config.pcie_clock_req)
 			REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffc);
 		else
 			REG_WRITE(ah, AR_PCIE_SERDES, 0x401deffd);
@@ -3956,8 +3959,8 @@ void ath9k_hw_configpcipowersave(struct ath_hal *ah, int restore)
 
 	REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
 
-	if (ah->ah_config.ath_hal_pcieWaen) {
-		REG_WRITE(ah, AR_WA, ah->ah_config.ath_hal_pcieWaen);
+	if (ah->ah_config.pcie_waen) {
+		REG_WRITE(ah, AR_WA, ah->ah_config.pcie_waen);
 	} else {
 		if (AR_SREV_9280(ah))
 			REG_WRITE(ah, AR_WA, 0x0040073f);
@@ -4690,7 +4693,7 @@ static void ath9k_hw_9280_spur_mitigate(struct ath_hal *ah,
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 	freq = centers.synth_center;
 
-	ah->ah_config.ath_hal_spurMode = SPUR_ENABLE_EEPROM;
+	ah->ah_config.spurmode = SPUR_ENABLE_EEPROM;
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
 		cur_bb_spur = ath9k_hw_eeprom_get_spur_chan(ah, i, is2GHz);
 
@@ -5400,7 +5403,7 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 		REG_WRITE(ah, reg, val);
 
 		if (reg >= 0x7800 && reg < 0x78a0
-		    && ah->ah_config.ath_hal_analogShiftReg) {
+		    && ah->ah_config.analog_shiftreg) {
 			udelay(100);
 		}
 
@@ -5414,7 +5417,7 @@ ath9k_hw_process_ini(struct ath_hal *ah,
 		REG_WRITE(ah, reg, val);
 
 		if (reg >= 0x7800 && reg < 0x78a0
-		    && ah->ah_config.ath_hal_analogShiftReg) {
+		    && ah->ah_config.analog_shiftreg) {
 			udelay(100);
 		}
 
@@ -5917,7 +5920,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL,
 			    AR_GPIO_JTAG_DISABLE);
 
-		if (ah->ah_caps.halWirelessModes & ATH9K_MODE_SEL_11A) {
+		if (ah->ah_caps.wireless_modes & ATH9K_MODE_SEL_11A) {
 			if (IS_CHAN_5GHZ(chan))
 				ath9k_hw_set_gpio(ah, 9, 0);
 			else
@@ -5951,7 +5954,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 		  | macStaId1
 		  | AR_STA_ID1_RTS_USE_DEF
 		  | (ah->ah_config.
-		     ath_hal_6mb_ack ? AR_STA_ID1_ACKCTS_6MB : 0)
+		     ack_6mb ? AR_STA_ID1_ACKCTS_6MB : 0)
 		  | ahp->ah_staId1Defaults);
 	ath9k_hw_set_operating_mode(ah, opmode);
 
@@ -5980,7 +5983,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, enum ath9k_opmode opmode,
 		REG_WRITE(ah, AR_DQCUMASK(i), 1 << i);
 
 	ahp->ah_intrTxqs = 0;
-	for (i = 0; i < ah->ah_caps.halTotalQueues; i++)
+	for (i = 0; i < ah->ah_caps.total_queues; i++)
 		ath9k_hw_resettxqueue(ah, i);
 
 	ath9k_hw_init_interrupt_masks(ah, opmode);
@@ -6618,7 +6621,7 @@ ath9k_hw_setantennaswitch(struct ath_hal *ah,
 			*antenna_cfgd = true;
 			break;
 		case ATH9K_ANT_FIXED_B:
-			if (ah->ah_caps.halTxChainMask >
+			if (ah->ah_caps.tx_chainmask >
 			    ATH9K_ANTENNA1_CHAINMASK) {
 				*tx_chainmask = ATH9K_ANTENNA1_CHAINMASK;
 			}
@@ -6646,14 +6649,14 @@ void ath9k_hw_setopmode(struct ath_hal *ah)
 }
 
 bool
-ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
+ath9k_hw_getcapability(struct ath_hal *ah, enum ath9k_capability_type type,
 		       u32 capability, u32 *result)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	const struct hal_capabilities *pCap = &ah->ah_caps;
+	const struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 
 	switch (type) {
-	case HAL_CAP_CIPHER:
+	case ATH9K_CAP_CIPHER:
 		switch (capability) {
 		case ATH9K_CIPHER_AES_CCM:
 		case ATH9K_CIPHER_AES_OCB:
@@ -6665,7 +6668,7 @@ ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 		default:
 			return false;
 		}
-	case HAL_CAP_TKIP_MIC:
+	case ATH9K_CAP_TKIP_MIC:
 		switch (capability) {
 		case 0:
 			return true;
@@ -6674,20 +6677,20 @@ ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 				AR_STA_ID1_CRPT_MIC_ENABLE) ? true :
 			false;
 		}
-	case HAL_CAP_TKIP_SPLIT:
+	case ATH9K_CAP_TKIP_SPLIT:
 		return (ahp->ah_miscMode & AR_PCU_MIC_NEW_LOC_ENA) ?
 			false : true;
-	case HAL_CAP_WME_TKIPMIC:
+	case ATH9K_CAP_WME_TKIPMIC:
 		return 0;
-	case HAL_CAP_PHYCOUNTERS:
+	case ATH9K_CAP_PHYCOUNTERS:
 		return ahp->ah_hasHwPhyCounters ? 0 : -ENXIO;
-	case HAL_CAP_DIVERSITY:
+	case ATH9K_CAP_DIVERSITY:
 		return (REG_READ(ah, AR_PHY_CCK_DETECT) &
 			AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV) ?
 			true : false;
-	case HAL_CAP_PHYDIAG:
+	case ATH9K_CAP_PHYDIAG:
 		return true;
-	case HAL_CAP_MCAST_KEYSRCH:
+	case ATH9K_CAP_MCAST_KEYSRCH:
 		switch (capability) {
 		case 0:
 			return true;
@@ -6701,19 +6704,19 @@ ath9k_hw_getcapability(struct ath_hal *ah, enum hal_capability_type type,
 			}
 		}
 		return false;
-	case HAL_CAP_TSF_ADJUST:
+	case ATH9K_CAP_TSF_ADJUST:
 		return (ahp->ah_miscMode & AR_PCU_TX_ADD_TSF) ?
 			true : false;
-	case HAL_CAP_RFSILENT:
+	case ATH9K_CAP_RFSILENT:
 		if (capability == 3)
 			return false;
-	case HAL_CAP_ANT_CFG_2GHZ:
-		*result = pCap->halNumAntCfg2GHz;
+	case ATH9K_CAP_ANT_CFG_2GHZ:
+		*result = pCap->num_antcfg_2ghz;
 		return true;
-	case HAL_CAP_ANT_CFG_5GHZ:
-		*result = pCap->halNumAntCfg5GHz;
+	case ATH9K_CAP_ANT_CFG_5GHZ:
+		*result = pCap->num_antcfg_5ghz;
 		return true;
-	case HAL_CAP_TXPOW:
+	case ATH9K_CAP_TXPOW:
 		switch (capability) {
 		case 0:
 			return 0;
@@ -6738,13 +6741,13 @@ ath9k_hw_select_antconfig(struct ath_hal *ah, u32 cfg)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_channel *chan = ah->ah_curchan;
-	const struct hal_capabilities *pCap = &ah->ah_caps;
+	const struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	u16 ant_config;
 	u32 halNumAntConfig;
 
 	halNumAntConfig =
-		IS_CHAN_2GHZ(chan) ? pCap->halNumAntCfg2GHz : pCap->
-		halNumAntCfg5GHz;
+		IS_CHAN_2GHZ(chan) ? pCap->num_antcfg_2ghz : pCap->
+		num_antcfg_5ghz;
 
 	if (cfg < halNumAntConfig) {
 		if (!ath9k_hw_get_eeprom_antenna_cfg(ahp, chan,
@@ -6780,7 +6783,7 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked)
 {
 	u32 isr = 0;
 	u32 mask2 = 0;
-	struct hal_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	u32 sync_cause = 0;
 	bool fatal_int = false;
 
@@ -6864,7 +6867,7 @@ bool ath9k_hw_getisr(struct ath_hal *ah, enum ath9k_int *masked)
 		}
 
 		if (!AR_SREV_9100(ah)) {
-			if (!pCap->halAutoSleepSupport) {
+			if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
 				u32 isr5 = REG_READ(ah, AR_ISR_S5_S);
 				if (isr5 & AR_ISR_S5_TIM_TIMER)
 					*masked |= ATH9K_INT_TIM_TIMER;
@@ -6923,7 +6926,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints)
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	u32 omask = ahp->ah_maskReg;
 	u32 mask, mask2;
-	struct hal_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT, "%s: 0x%x => 0x%x\n", __func__,
 		 omask, ints);
@@ -6961,7 +6964,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints)
 			mask |= AR_IMR_RXMINTR | AR_IMR_RXINTM;
 		else
 			mask |= AR_IMR_RXOK | AR_IMR_RXDESC;
-		if (!pCap->halAutoSleepSupport)
+		if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
 			mask |= AR_IMR_GENTMR;
 	}
 
@@ -6998,7 +7001,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hal *ah, enum ath9k_int ints)
 	REG_WRITE(ah, AR_IMR_S2, mask | mask2);
 	ahp->ah_maskReg = ints;
 
-	if (!pCap->halAutoSleepSupport) {
+	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
 		if (ints & ATH9K_INT_TIM_TIMER)
 			REG_SET_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
 		else
@@ -7057,11 +7060,11 @@ ath9k_hw_beaconinit(struct ath_hal *ah,
 		REG_WRITE(ah, AR_NEXT_DMA_BEACON_ALERT,
 			  TU_TO_USEC(next_beacon -
 				     ah->ah_config.
-				     ath_hal_dma_beacon_response_time));
+				     dma_beacon_response_time));
 		REG_WRITE(ah, AR_NEXT_SWBA,
 			  TU_TO_USEC(next_beacon -
 				     ah->ah_config.
-				     ath_hal_sw_beacon_response_time));
+				     sw_beacon_response_time));
 		flags |=
 			AR_TBTT_TIMER_EN | AR_DBA_TIMER_EN | AR_SWBA_TIMER_EN;
 		break;
@@ -7086,7 +7089,7 @@ ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 			       const struct ath9k_beacon_state *bs)
 {
 	u32 nextTbtt, beaconintval, dtimperiod, beacontimeout;
-	struct hal_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 
 	REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(bs->bs_nexttbtt));
 
@@ -7129,7 +7132,7 @@ ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 		  SM((CAB_TIMEOUT_VAL << 3), AR_SLEEP1_CAB_TIMEOUT)
 		  | AR_SLEEP1_ASSUME_DTIM);
 
-	if (pCap->halAutoSleepSupport)
+	if (pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)
 		beacontimeout = (BEACON_TIMEOUT_VAL << 3);
 	else
 		beacontimeout = MIN_BEACON_TIMEOUT_VAL;
@@ -7148,7 +7151,7 @@ ath9k_hw_set_sta_beacon_timers(struct ath_hal *ah,
 
 bool ath9k_hw_keyisvalid(struct ath_hal *ah, u16 entry)
 {
-	if (entry < ah->ah_caps.halKeyCacheSize) {
+	if (entry < ah->ah_caps.keycache_size) {
 		u32 val = REG_READ(ah, AR_KEYTABLE_MAC1(entry));
 		if (val & AR_KEYTABLE_VALID)
 			return true;
@@ -7160,7 +7163,7 @@ bool ath9k_hw_keyreset(struct ath_hal *ah, u16 entry)
 {
 	u32 keyType;
 
-	if (entry >= ah->ah_caps.halKeyCacheSize) {
+	if (entry >= ah->ah_caps.keycache_size) {
 		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 			 "%s: entry %u out of range\n", __func__, entry);
 		return false;
@@ -7198,7 +7201,7 @@ ath9k_hw_keysetmac(struct ath_hal *ah, u16 entry,
 {
 	u32 macHi, macLo;
 
-	if (entry >= ah->ah_caps.halKeyCacheSize) {
+	if (entry >= ah->ah_caps.keycache_size) {
 		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 			 "%s: entry %u out of range\n", __func__, entry);
 		return false;
@@ -7225,7 +7228,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 			    const struct ath9k_keyval *k,
 			    const u8 *mac, int xorKey)
 {
-	const struct hal_capabilities *pCap = &ah->ah_caps;
+	const struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	u32 key0, key1, key2, key3, key4;
 	u32 keyType;
 	u32 xorMask = xorKey ?
@@ -7233,7 +7236,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 		 | ATH9K_KEY_XOR) : 0;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	if (entry >= pCap->halKeyCacheSize) {
+	if (entry >= pCap->keycache_size) {
 		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 			 "%s: entry %u out of range\n", __func__, entry);
 		return false;
@@ -7243,7 +7246,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 		keyType = AR_KEYTABLE_TYPE_AES;
 		break;
 	case ATH9K_CIPHER_AES_CCM:
-		if (!pCap->halCipherAesCcmSupport) {
+		if (!(pCap->hw_caps & ATH9K_HW_CAP_CIPHER_AESCCM)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 				 "%s: AES-CCM not supported by "
 				 "mac rev 0x%x\n", __func__,
@@ -7255,7 +7258,7 @@ ath9k_hw_set_keycache_entry(struct ath_hal *ah, u16 entry,
 	case ATH9K_CIPHER_TKIP:
 		keyType = AR_KEYTABLE_TYPE_TKIP;
 		if (ATH9K_IS_MIC_ENABLED(ah)
-		    && entry + 64 >= pCap->halKeyCacheSize) {
+		    && entry + 64 >= pCap->keycache_size) {
 			DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
 				 "%s: entry %u inappropriate for TKIP\n",
 				 __func__, entry);
@@ -7452,9 +7455,9 @@ bool ath9k_hw_settxqueueprops(struct ath_hal *ah, int q,
 			      const struct ath9k_txq_info *qInfo)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 
-	if (q >= pCap->halTotalQueues) {
+	if (q >= pCap->total_queues) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
 			 __func__, q);
 		return false;
@@ -7495,9 +7498,9 @@ ath9k_hw_gettxqueueprops(struct ath_hal *ah, int q,
 			 struct ath9k_txq_info *qInfo)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 
-	if (q >= pCap->halTotalQueues) {
+	if (q >= pCap->total_queues) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
 			 __func__, q);
 		return false;
@@ -7511,28 +7514,28 @@ ath9k_hw_setuptxqueue(struct ath_hal *ah, enum ath9k_tx_queue type,
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_tx_queue_info *qi;
-	struct hal_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	int q;
 
 	switch (type) {
 	case ATH9K_TX_QUEUE_BEACON:
-		q = pCap->halTotalQueues - 1;
+		q = pCap->total_queues - 1;
 		break;
 	case ATH9K_TX_QUEUE_CAB:
-		q = pCap->halTotalQueues - 2;
+		q = pCap->total_queues - 2;
 		break;
 	case ATH9K_TX_QUEUE_PSPOLL:
 		q = 1;
 		break;
 	case ATH9K_TX_QUEUE_UAPSD:
-		q = pCap->halTotalQueues - 3;
+		q = pCap->total_queues - 3;
 		break;
 	case ATH9K_TX_QUEUE_DATA:
-		for (q = 0; q < pCap->halTotalQueues; q++)
+		for (q = 0; q < pCap->total_queues; q++)
 			if (ahp->ah_txq[q].tqi_type ==
 			    ATH9K_TX_QUEUE_INACTIVE)
 				break;
-		if (q == pCap->halTotalQueues) {
+		if (q == pCap->total_queues) {
 			DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
 				 "%s: no available tx queue\n", __func__);
 			return -1;
@@ -7598,10 +7601,10 @@ ath9k_hw_set_txq_interrupts(struct ath_hal *ah,
 bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u32 q)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	struct ath9k_tx_queue_info *qi;
 
-	if (q >= pCap->halTotalQueues) {
+	if (q >= pCap->total_queues) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
 			 __func__, q);
 		return false;
@@ -7630,12 +7633,12 @@ bool ath9k_hw_releasetxqueue(struct ath_hal *ah, u32 q)
 bool ath9k_hw_resettxqueue(struct ath_hal *ah, u32 q)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct hal_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 	struct ath9k_channel *chan = ah->ah_curchan;
 	struct ath9k_tx_queue_info *qi;
 	u32 cwMin, chanCwMin, value;
 
-	if (q >= pCap->halTotalQueues) {
+	if (q >= pCap->total_queues) {
 		DPRINTF(ah->ah_sc, ATH_DBG_QUEUE, "%s: invalid queue num %u\n",
 			 __func__, q);
 		return false;
@@ -7735,10 +7738,10 @@ bool ath9k_hw_resettxqueue(struct ath_hal *ah, u32 q)
 			  | AR_Q_MISC_CBR_INCR_DIS1
 			  | AR_Q_MISC_CBR_INCR_DIS0);
 		value = (qi->tqi_readyTime
-			 - (ah->ah_config.ath_hal_sw_beacon_response_time -
-			    ah->ah_config.ath_hal_dma_beacon_response_time)
+			 - (ah->ah_config.sw_beacon_response_time -
+			    ah->ah_config.dma_beacon_response_time)
 			 -
-			 ah->ah_config.ath_hal_additional_swba_backoff) *
+			 ah->ah_config.additional_swba_backoff) *
 			1024;
 		REG_WRITE(ah, AR_QRDYTIMECFG(q),
 			  value | AR_Q_RDYTIMECFG_EN);
@@ -8127,14 +8130,14 @@ ath9k_hw_setuprxdesc(struct ath_hal *ah, struct ath_desc *ds,
 		     u32 size, u32 flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
-	struct hal_capabilities *pCap = &ah->ah_caps;
+	struct ath9k_hw_capabilities *pCap = &ah->ah_caps;
 
 	ads->ds_ctl1 = size & AR_BufLen;
 	if (flags & ATH9K_RXDESC_INTREQ)
 		ads->ds_ctl1 |= AR_RxIntrReq;
 
 	ads->ds_rxstatus8 &= ~AR_RxDone;
-	if (!pCap->halAutoSleepSupport)
+	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
 		memset(&(ads->u), 0, sizeof(ads->u));
 	return true;
 }
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 9549524..01bee5e 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1268,14 +1268,14 @@ static int ath_attach(u16 devid,
 		sc->rates[IEEE80211_BAND_2GHZ];
 	sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
 
-	if (sc->sc_ah->ah_caps.halHTSupport)
+	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
 		/* Setup HT capabilities for 2.4Ghz*/
 		setup_ht_cap(&sc->sbands[IEEE80211_BAND_2GHZ].ht_info);
 
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 		&sc->sbands[IEEE80211_BAND_2GHZ];
 
-	if (sc->sc_ah->ah_caps.halWirelessModes & ATH9K_MODE_SEL_11A) {
+	if (sc->sc_ah->ah_caps.wireless_modes & ATH9K_MODE_SEL_11A) {
 		sc->sbands[IEEE80211_BAND_5GHZ].channels =
 			sc->channels[IEEE80211_BAND_5GHZ];
 		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
@@ -1283,7 +1283,7 @@ static int ath_attach(u16 devid,
 		sc->sbands[IEEE80211_BAND_5GHZ].band =
 			IEEE80211_BAND_5GHZ;
 
-		if (sc->sc_ah->ah_caps.halHTSupport)
+		if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
 			/* Setup HT capabilities for 5Ghz*/
 			setup_ht_cap(&sc->sbands[IEEE80211_BAND_5GHZ].ht_info);
 
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index e0797af..d313200 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -780,7 +780,7 @@ struct ath_rate_softc *ath_rate_attach(struct ath_hal *ah)
 	ar5416_attach_ratetables(asc);
 
 	/* Save Maximum TX Trigger Level (used for 11n) */
-	tx_triglevel_max = ah->ah_caps.halTxTrigLevelMax;
+	tx_triglevel_max = ah->ah_caps.tx_triglevel_max;
 	/*  return alias for ath_rate_softc * */
 	return asc;
 }
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 8e14e64..2fe8061 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -478,7 +478,7 @@ static void ath_opmode_init(struct ath_softc *sc)
 	ath9k_hw_setrxfilter(ah, rfilt);
 
 	/* configure bssid mask */
-	if (ah->ah_caps.halBssIdMaskSupport)
+	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
 		ath9k_hw_setbssidmask(ah, sc->sc_bssidmask);
 
 	/* configure operational mode */
@@ -1018,7 +1018,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 				 PCI_DMA_FROMDEVICE);
 
 		/* XXX: Ah! make me more readable, use a helper */
-		if (ah->ah_caps.halHTSupport) {
+		if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) {
 			if (ds->ds_rxstat.rs_moreaggr == 0) {
 				rx_status.rssictl[0] =
 					ds->ds_rxstat.rs_rssi_ctl0;
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 7b0176e..05e10c4 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -87,7 +87,7 @@ static bool ath9k_regd_is_fcc_midband_supported(struct ath_hal *ah)
 {
 	u32 regcap;
 
-	regcap = ah->ah_caps.halRegCap;
+	regcap = ah->ah_caps.reg_cap;
 
 	if (regcap & AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND)
 		return true;
@@ -138,7 +138,7 @@ ath9k_regd_get_wmodes_nreg(struct ath_hal *ah,
 {
 	u32 modesAvail;
 
-	modesAvail = ah->ah_caps.halWirelessModes;
+	modesAvail = ah->ah_caps.wireless_modes;
 
 	if ((modesAvail & ATH9K_MODE_SEL_11G) && (!country->allow11g))
 		modesAvail &= ~ATH9K_MODE_SEL_11G;
@@ -436,7 +436,7 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 		return false;
 	}
 	if ((fband->channelBW == CHANNEL_HALF_BW) &&
-	    !ah->ah_caps.halChanHalfRate) {
+	    !(ah->ah_caps.hw_caps & ATH9K_HW_CAP_CHAN_HALFRATE)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			"%s: Skipping %u half rate channel\n",
 			__func__, c);
@@ -444,7 +444,7 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 	}
 
 	if ((fband->channelBW == CHANNEL_QUARTER_BW) &&
-	    !ah->ah_caps.halChanQuarterRate) {
+	    !(ah->ah_caps.hw_caps & ATH9K_HW_CAP_CHAN_QUARTERRATE)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 			"%s: Skipping %u quarter rate channel\n",
 			__func__, c);
@@ -529,7 +529,7 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 		if ((c < 2412) || (c > 2462)) {
 			if (rd5GHz.regDmnEnum == MKK1 ||
 			    rd5GHz.regDmnEnum == MKK2) {
-				u32 regcap = ah->ah_caps.halRegCap;
+				u32 regcap = ah->ah_caps.reg_cap;
 				if (!(regcap &
 				      (AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN |
 				       AR_EEPROM_EEREGCAP_EN_KK_U2 |
@@ -594,7 +594,7 @@ static bool ath9k_regd_japan_check(struct ath_hal *ah,
 
 	for (i = 0; i < ARRAY_SIZE(j_bandcheck); i++) {
 		if (j_bandcheck[i].freqbandbit == b) {
-			regcap = ah->ah_caps.halRegCap;
+			regcap = ah->ah_caps.reg_cap;
 			if ((j_bandcheck[i].eepromflagtocheck & regcap) == 0) {
 				skipband = true;
 			} else if ((regcap & AR_EEPROM_EEREGCAP_EN_KK_U2) ||
@@ -726,7 +726,7 @@ ath9k_regd_init_channels(struct ath_hal *ah,
 	}
 
 	if (country == NULL) {
-		modesAvail = ah->ah_caps.halWirelessModes;
+		modesAvail = ah->ah_caps.wireless_modes;
 	} else {
 		modesAvail = ath9k_regd_get_wmodes_nreg(ah, country, &rd5GHz);
 		if (!enableOutdoor)
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index f0297ee..92bb3c2 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -781,7 +781,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	 * let rate series flags determine which rates will actually
 	 * use RTS.
 	 */
-	if (ah->ah_caps.halHTSupport && bf->bf_isdata) {
+	if ((ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) && bf->bf_isdata) {
 		BUG_ON(!an);
 		/*
 		 * 802.11g protection not needed, use our default behavior
@@ -897,7 +897,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	 * For non-HT devices, calculate RTS/CTS duration in software
 	 * and disable multi-rate retry.
 	 */
-	if (flags && !ah->ah_caps.halHTSupport) {
+	if (flags && !(ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)) {
 		/*
 		 * Compute the transmit duration based on the frame
 		 * size and the size of an ACK frame.  We call into the
-- 
1.5.6.5


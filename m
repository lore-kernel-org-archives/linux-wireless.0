Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14775 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419Ab0DOFb2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 01:31:28 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 14 Apr 2010 22:31:28 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19398.42107.136328.167515@gargle.gargle.HOWL>
Date: Thu, 15 Apr 2010 11:00:35 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/6] ath9k_hw: Use buffered register writes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds macros at certain places
which could be optimized for multiple register writes.

The performance of ath9k_htc improves considerably,
especially reducing the latency involved in a scan run.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c          |   23 ++++++++
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   |   28 ++++++++++
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    5 ++
 drivers/net/wireless/ath/ath9k/ar9002_hw.c    |    7 ++-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c   |    5 ++
 drivers/net/wireless/ath/ath9k/eeprom_4k.c    |   10 ++++
 drivers/net/wireless/ath/ath9k/hw.c           |   71 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/mac.c          |   27 +++++++++
 8 files changed, 175 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 5a2d867..cec62d3 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -79,11 +79,17 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 		  "Writing ofdmbase=%u   cckbase=%u\n",
 		  aniState->ofdmPhyErrBase,
 		  aniState->cckPhyErrBase);
+
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_PHY_ERR_1, aniState->ofdmPhyErrBase);
 	REG_WRITE(ah, AR_PHY_ERR_2, aniState->cckPhyErrBase);
 	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
 
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
 	aniState->ofdmPhyErrCount = 0;
@@ -357,8 +363,14 @@ void ath9k_ani_reset(struct ath_hw *ah)
 	ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) &
 			     ~ATH9K_RX_FILTER_PHYERR);
 	ath9k_ani_restart(ah);
+
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 void ath9k_hw_ani_monitor(struct ath_hw *ah,
@@ -456,6 +468,8 @@ void ath9k_enable_mib_counters(struct ath_hw *ah)
 
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_FILT_OFDM, 0);
 	REG_WRITE(ah, AR_FILT_CCK, 0);
 	REG_WRITE(ah, AR_MIBC,
@@ -463,6 +477,9 @@ void ath9k_enable_mib_counters(struct ath_hw *ah)
 		  & 0x0f);
 	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 /* Freeze the MIB counters, get the stats and then clear them */
@@ -626,8 +643,14 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 	ath_print(common, ATH_DBG_ANI, "Setting cckErrBase = 0x%08x\n",
 		  ah->ani[0].cckPhyErrBase);
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_PHY_ERR_1, ah->ani[0].ofdmPhyErrBase);
 	REG_WRITE(ah, AR_PHY_ERR_2, ah->ani[0].cckPhyErrBase);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	ath9k_enable_mib_counters(ah);
 
 	ah->aniperiod = ATH9K_ANI_PERIOD;
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 94eb069..de8ce12 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -590,10 +590,14 @@ static void ar5008_hw_init_chain_masks(struct ath_hw *ah)
 	rx_chainmask = ah->rxchainmask;
 	tx_chainmask = ah->txchainmask;
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	switch (rx_chainmask) {
 	case 0x5:
+		DISABLE_REGWRITE_BUFFER(ah);
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
 			    AR_PHY_SWAP_ALT_CHAIN);
+		ENABLE_REGWRITE_BUFFER(ah);
 	case 0x3:
 		if (ah->hw_version.macVersion == AR_SREV_REVISION_5416_10) {
 			REG_WRITE(ah, AR_PHY_RX_CHAINMASK, 0x7);
@@ -611,6 +615,10 @@ static void ar5008_hw_init_chain_masks(struct ath_hw *ah)
 	}
 
 	REG_WRITE(ah, AR_SELFGEN_MASK, tx_chainmask);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	if (tx_chainmask == 0x5) {
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
 			    AR_PHY_SWAP_ALT_CHAIN);
@@ -689,8 +697,13 @@ static void ar5008_hw_set_channel_regs(struct ath_hw *ah,
 
 	ath9k_hw_set11nmac2040(ah);
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_GTXTO, 25 << AR_GTXTO_TIMEOUT_LIMIT_S);
 	REG_WRITE(ah, AR_CST, 0xF << AR_CST_TIMEOUT_LIMIT_S);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 
@@ -773,6 +786,8 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 
 	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_INTERNAL_ADDAC);
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	for (i = 0; i < ah->iniModes.ia_rows; i++) {
 		u32 reg = INI_RA(&ah->iniModes, i, 0);
 		u32 val = INI_RA(&ah->iniModes, i, modesIndex);
@@ -790,6 +805,9 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 		DO_DELAY(regWrites);
 	}
 
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	if (AR_SREV_9280(ah) || AR_SREV_9287_10_OR_LATER(ah))
 		REG_WRITE_ARRAY(&ah->iniModesRxGain, modesIndex, regWrites);
 
@@ -801,6 +819,8 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 		REG_WRITE_ARRAY(&ah->iniModes_9271_1_0_only,
 				modesIndex, regWrites);
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	/* Write common array parameters */
 	for (i = 0; i < ah->iniCommon.ia_rows; i++) {
 		u32 reg = INI_RA(&ah->iniCommon, i, 0);
@@ -816,6 +836,9 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 		DO_DELAY(regWrites);
 	}
 
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	if (AR_SREV_9271(ah)) {
 		if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) == 1)
 			REG_WRITE_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
@@ -1303,6 +1326,8 @@ static void ar5008_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 		udelay(50);
 	}
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		if (chainmask & (1 << i)) {
 			val = REG_READ(ah, ar5416_cca_regs[i]);
@@ -1311,6 +1336,9 @@ static void ar5008_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 			REG_WRITE(ah, ar5416_cca_regs[i], val);
 		}
 	}
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 968529b..5fdbb53 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -527,6 +527,8 @@ static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 		ah->pacal_info.prev_offset = regVal;
 	}
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	regVal = REG_READ(ah, 0x7834);
 	regVal |= 0x1;
 	REG_WRITE(ah, 0x7834, regVal);
@@ -536,6 +538,9 @@ static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 
 	for (i = 0; i < ARRAY_SIZE(regList); i++)
 		REG_WRITE(ah, regList[i][0], regList[i][1]);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 static inline void ar9285_hw_pa_cal(struct ath_hw *ah, bool is_reset)
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 17b98a3..adb33b3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -488,10 +488,15 @@ static int ar9002_hw_get_radiorev(struct ath_hw *ah)
 	u32 val;
 	int i;
 
-	REG_WRITE(ah, AR_PHY(0x36), 0x00007058);
+	ENABLE_REGWRITE_BUFFER(ah);
 
+	REG_WRITE(ah, AR_PHY(0x36), 0x00007058);
 	for (i = 0; i < 8; i++)
 		REG_WRITE(ah, AR_PHY(0x20), 0x00010000);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	val = (REG_READ(ah, AR_PHY(256)) >> 24) & 0xff;
 	val = ((val & 0xf0) >> 4) | ((val & 0x0f) << 4);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index a0a2f58..18cfe1a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -236,6 +236,8 @@ static void ar9002_hw_spur_mitigate(struct ath_hw *ah,
 
 	tmp = REG_READ(ah, AR_PHY_TIMING_CTRL4(0));
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	newVal = tmp | (AR_PHY_TIMING_CTRL4_ENABLE_SPUR_RSSI |
 			AR_PHY_TIMING_CTRL4_ENABLE_SPUR_FILTER |
 			AR_PHY_TIMING_CTRL4_ENABLE_CHAN_MASK |
@@ -411,6 +413,9 @@ static void ar9002_hw_spur_mitigate(struct ath_hw *ah,
 		| (mask_p[47] << 2) | (mask_p[46] << 0);
 	REG_WRITE(ah, AR_PHY_BIN_MASK2_4, tmp_mask);
 	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 static void ar9002_olc_init(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 2384a9f..41a77d1 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -454,6 +454,8 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 					    &tMinCalPower, gainBoundaries,
 					    pdadcValues, numXpdGain);
 
+			ENABLE_REGWRITE_BUFFER(ah);
+
 			if ((i == 0) || AR_SREV_5416_20_OR_LATER(ah)) {
 				REG_WRITE(ah, AR_PHY_TPCRG5 + regChainOffset,
 					  SM(pdGainOverlap_t2,
@@ -494,6 +496,9 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 
 				regOffset += 4;
 			}
+
+			REGWRITE_BUFFER_FLUSH(ah);
+			DISABLE_REGWRITE_BUFFER(ah);
 		}
 	}
 
@@ -759,6 +764,8 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 			ratesArray[i] -= AR5416_PWR_TABLE_OFFSET_DB * 2;
 	}
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	/* OFDM power per rate */
 	REG_WRITE(ah, AR_PHY_POWER_TX_RATE1,
 		  ATH9K_POW_SM(ratesArray[rate18mb], 24)
@@ -821,6 +828,9 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 			  | ATH9K_POW_SM(ratesArray[rateDupOfdm], 8)
 			  | ATH9K_POW_SM(ratesArray[rateDupCck], 0));
 	}
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 static void ath9k_hw_4k_set_addac(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index deb542f..b215fab 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -274,6 +274,8 @@ static void ath9k_hw_disablepcie(struct ath_hw *ah)
 	if (AR_SREV_9100(ah))
 		return;
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
 	REG_WRITE(ah, AR_PCIE_SERDES, 0x24924924);
 	REG_WRITE(ah, AR_PCIE_SERDES, 0x28000029);
@@ -285,6 +287,9 @@ static void ath9k_hw_disablepcie(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PCIE_SERDES, 0x000e1007);
 
 	REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 /* This should work for all families including legacy */
@@ -638,6 +643,8 @@ EXPORT_SYMBOL(ath9k_hw_init);
 
 static void ath9k_hw_init_qos(struct ath_hw *ah)
 {
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_MIC_QOS_CONTROL, 0x100aa);
 	REG_WRITE(ah, AR_MIC_QOS_SELECT, 0x3210);
 
@@ -651,6 +658,9 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 	REG_WRITE(ah, AR_TXOP_4_7, 0xFFFFFFFF);
 	REG_WRITE(ah, AR_TXOP_8_11, 0xFFFFFFFF);
 	REG_WRITE(ah, AR_TXOP_12_15, 0xFFFFFFFF);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 static void ath9k_hw_init_pll(struct ath_hw *ah,
@@ -702,6 +712,8 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 	if (opmode == NL80211_IFTYPE_AP)
 		imr_reg |= AR_IMR_MIB;
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_IMR, imr_reg);
 	ah->imrs2_reg |= AR_IMR_S2_GTT;
 	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
@@ -712,6 +724,9 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 		REG_WRITE(ah, AR_INTR_SYNC_MASK, 0);
 	}
 
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		REG_WRITE(ah, AR_INTR_PRIO_ASYNC_ENABLE, 0);
 		REG_WRITE(ah, AR_INTR_PRIO_ASYNC_MASK, 0);
@@ -840,6 +855,8 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 regval;
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	/*
 	 * set AHB_MODE not to do cacheline prefetches
 	*/
@@ -854,6 +871,9 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 	regval = REG_READ(ah, AR_TXCFG) & ~AR_TXCFG_DMASZ_MASK;
 	REG_WRITE(ah, AR_TXCFG, regval | AR_TXCFG_DMASZ_128B);
 
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	/*
 	 * Restore TX Trigger Level to its pre-reset value.
 	 * The initial value depends on whether aggregation is enabled, and is
@@ -862,6 +882,8 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		REG_RMW_FIELD(ah, AR_TXCFG, AR_FTRIG, ah->tx_trig_level);
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	/*
 	 * let mac dma writes be in 128 byte chunks
 	 */
@@ -897,6 +919,9 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 			  AR_PCU_TXBUF_CTRL_USABLE_SIZE);
 	}
 
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		ath9k_hw_reset_txstatus_ring(ah);
 }
@@ -956,6 +981,8 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 		(void)REG_READ(ah, AR_RTC_DERIVED_CLK);
 	}
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
 
@@ -984,6 +1011,10 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 	}
 
 	REG_WRITE(ah, AR_RTC_RC, rst_flags);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	udelay(50);
 
 	REG_WRITE(ah, AR_RTC_RC, 0);
@@ -1004,6 +1035,8 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 
 static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 {
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
 
@@ -1012,6 +1045,9 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 
 	REG_WRITE(ah, AR_RTC_RESET, 0);
 
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		udelay(2);
 
@@ -1240,6 +1276,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_set_operating_mode(ah, ah->opmode);
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
 	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(common->macaddr + 4)
 		  | macStaId1
@@ -1253,13 +1291,21 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	REG_WRITE(ah, AR_ISR, ~0);
 	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
 
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	r = ath9k_hw_rf_set_freq(ah, chan);
 	if (r)
 		return r;
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	for (i = 0; i < AR_NUM_DCU; i++)
 		REG_WRITE(ah, AR_DQCUMASK(i), 1 << i);
 
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	ah->intr_txqs = 0;
 	for (i = 0; i < ah->caps.total_queues; i++)
 		ath9k_hw_resettxqueue(ah, i);
@@ -1299,9 +1345,14 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	ath9k_hw_restore_chainmask(ah);
 	REG_WRITE(ah, AR_CFG_LED, saveLedState | AR_CFG_SCLK_32KHZ);
 
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	/*
 	 * For big endian systems turn on swapping for descriptors
 	 */
@@ -1765,6 +1816,8 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 
 	ah->beacon_interval = beacon_period;
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	switch (ah->opmode) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_MONITOR:
@@ -1808,6 +1861,9 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 	REG_WRITE(ah, AR_SWBA_PERIOD, TU_TO_USEC(beacon_period));
 	REG_WRITE(ah, AR_NDP_PERIOD, TU_TO_USEC(beacon_period));
 
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	beacon_period &= ~ATH9K_BEACON_ENA;
 	if (beacon_period & ATH9K_BEACON_RESET_TSF) {
 		ath9k_hw_reset_tsf(ah);
@@ -1824,6 +1880,8 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(bs->bs_nexttbtt));
 
 	REG_WRITE(ah, AR_BEACON_PERIOD,
@@ -1831,6 +1889,9 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	REG_WRITE(ah, AR_DMA_BEACON_PERIOD,
 		  TU_TO_USEC(bs->bs_intval & ATH9K_BEACON_PERIOD));
 
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	REG_RMW_FIELD(ah, AR_RSSI_THR,
 		      AR_RSSI_THR_BM_THR, bs->bs_bmissthreshold);
 
@@ -1853,6 +1914,8 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	ath_print(common, ATH_DBG_BEACON, "beacon period %d\n", beaconintval);
 	ath_print(common, ATH_DBG_BEACON, "DTIM period %d\n", dtimperiod);
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_NEXT_DTIM,
 		  TU_TO_USEC(bs->bs_nextdtim - SLEEP_SLOP));
 	REG_WRITE(ah, AR_NEXT_TIM, TU_TO_USEC(nextTbtt - SLEEP_SLOP));
@@ -1872,6 +1935,9 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	REG_WRITE(ah, AR_TIM_PERIOD, TU_TO_USEC(beaconintval));
 	REG_WRITE(ah, AR_DTIM_PERIOD, TU_TO_USEC(dtimperiod));
 
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	REG_SET_BIT(ah, AR_TIMER_MODE,
 		    AR_TBTT_TIMER_EN | AR_TIM_TIMER_EN |
 		    AR_DTIM_TIMER_EN);
@@ -2329,6 +2395,8 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 {
 	u32 phybits;
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_RX_FILTER, bits);
 
 	phybits = 0;
@@ -2344,6 +2412,9 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 	else
 		REG_WRITE(ah, AR_RXCFG,
 			  REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_ZLFDMA);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
 }
 EXPORT_SYMBOL(ath9k_hw_setrxfilter);
 
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 482e2b3..6c73e34 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -25,6 +25,8 @@ static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 		  ah->txdesc_interrupt_mask, ah->txeol_interrupt_mask,
 		  ah->txurn_interrupt_mask);
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_IMR_S0,
 		  SM(ah->txok_interrupt_mask, AR_IMR_S0_QCU_TXOK)
 		  | SM(ah->txdesc_interrupt_mask, AR_IMR_S0_QCU_TXDESC));
@@ -35,6 +37,9 @@ static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 	ah->imrs2_reg &= ~AR_IMR_S2_QCU_TXURN;
 	ah->imrs2_reg |= (ah->txurn_interrupt_mask & AR_IMR_S2_QCU_TXURN);
 	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q)
@@ -470,6 +475,8 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 	} else
 		cwMin = qi->tqi_cwmin;
 
+	ENABLE_REGWRITE_BUFFER(ah);
+
 	REG_WRITE(ah, AR_DLCL_IFS(q),
 		  SM(cwMin, AR_D_LCL_IFS_CWMIN) |
 		  SM(qi->tqi_cwmax, AR_D_LCL_IFS_CWMAX) |
@@ -484,6 +491,8 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 	REG_WRITE(ah, AR_DMISC(q),
 		  AR_D_MISC_CW_BKOFF_EN | AR_D_MISC_FRAG_WAIT_EN | 0x2);
 
+	REGWRITE_BUFFER_FLUSH(ah);
+
 	if (qi->tqi_cbrPeriod) {
 		REG_WRITE(ah, AR_QCBRCFG(q),
 			  SM(qi->tqi_cbrPeriod, AR_Q_CBRCFG_INTERVAL) |
@@ -499,6 +508,8 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 			  AR_Q_RDYTIMECFG_EN);
 	}
 
+	REGWRITE_BUFFER_FLUSH(ah);
+
 	REG_WRITE(ah, AR_DCHNTIME(q),
 		  SM(qi->tqi_burstTime, AR_D_CHNTIME_DUR) |
 		  (qi->tqi_burstTime ? AR_D_CHNTIME_EN : 0));
@@ -516,6 +527,10 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 			  REG_READ(ah, AR_DMISC(q)) |
 			  AR_D_MISC_POST_FR_BKOFF_DIS);
 	}
+
+	REGWRITE_BUFFER_FLUSH(ah);
+	DISABLE_REGWRITE_BUFFER(ah);
+
 	if (qi->tqi_qflags & TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE) {
 		REG_WRITE(ah, AR_DMISC(q),
 			  REG_READ(ah, AR_DMISC(q)) |
@@ -523,6 +538,8 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 	}
 	switch (qi->tqi_type) {
 	case ATH9K_TX_QUEUE_BEACON:
+		ENABLE_REGWRITE_BUFFER(ah);
+
 		REG_WRITE(ah, AR_QMISC(q), REG_READ(ah, AR_QMISC(q))
 			  | AR_Q_MISC_FSP_DBA_GATED
 			  | AR_Q_MISC_BEACON_USE
@@ -533,6 +550,10 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 			     AR_D_MISC_ARB_LOCKOUT_CNTRL_S)
 			  | AR_D_MISC_BEACON_USE
 			  | AR_D_MISC_POST_FR_BKOFF_DIS);
+
+		REGWRITE_BUFFER_FLUSH(ah);
+		DISABLE_REGWRITE_BUFFER(ah);
+
 		/* cwmin and cwmax should be 0 for beacon queue */
 		if (AR_SREV_9300_20_OR_LATER(ah)) {
 			REG_WRITE(ah, AR_DLCL_IFS(q), SM(0, AR_D_LCL_IFS_CWMIN)
@@ -541,6 +562,8 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 		}
 		break;
 	case ATH9K_TX_QUEUE_CAB:
+		ENABLE_REGWRITE_BUFFER(ah);
+
 		REG_WRITE(ah, AR_QMISC(q), REG_READ(ah, AR_QMISC(q))
 			  | AR_Q_MISC_FSP_DBA_GATED
 			  | AR_Q_MISC_CBR_INCR_DIS1
@@ -554,6 +577,10 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 		REG_WRITE(ah, AR_DMISC(q), REG_READ(ah, AR_DMISC(q))
 			  | (AR_D_MISC_ARB_LOCKOUT_CNTRL_GLOBAL <<
 			     AR_D_MISC_ARB_LOCKOUT_CNTRL_S));
+
+		REGWRITE_BUFFER_FLUSH(ah);
+		DISABLE_REGWRITE_BUFFER(ah);
+
 		break;
 	case ATH9K_TX_QUEUE_PSPOLL:
 		REG_WRITE(ah, AR_QMISC(q),
-- 
1.7.0.4


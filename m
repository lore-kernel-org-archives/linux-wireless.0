Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:56772 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab0JCRH0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Oct 2010 13:07:26 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 3/4] ath9k_hw: clean up register write buffering
Date: Sun,  3 Oct 2010 19:07:18 +0200
Message-Id: <1286125639-15137-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1286125639-15137-2-git-send-email-nbd@openwrt.org>
References: <1286125639-15137-1-git-send-email-nbd@openwrt.org>
 <1286125639-15137-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Throughout the code, DISABLE_REGWRITE_BUFFER is always called right after
REGWRITE_BUFFER_FLUSH. Since that's unlikely to change any time soon, that
makes keeping those ops separate rather pointless, as it only increases
code size and line number counts.
Merge those two ops and also ensure that the flush is only issued after
all codepaths are done buffering.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath.h                |    4 +---
 drivers/net/wireless/ath/ath9k/ani.c          |    6 ------
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   |    9 ++-------
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    1 -
 drivers/net/wireless/ath/ath9k/ar9002_hw.c    |    4 ----
 drivers/net/wireless/ath/ath9k/ar9002_phy.c   |    1 -
 drivers/net/wireless/ath/ath9k/calib.c        |    1 -
 drivers/net/wireless/ath/ath9k/eeprom_4k.c    |    2 --
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   13 +++----------
 drivers/net/wireless/ath/ath9k/hw.c           |   14 --------------
 drivers/net/wireless/ath/ath9k/hw.h           |   10 ++--------
 drivers/net/wireless/ath/ath9k/mac.c          |    4 ----
 12 files changed, 8 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 5894fcc..cee0191 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -102,14 +102,12 @@ enum ath_cipher {
  * @read: Register read
  * @write: Register write
  * @enable_write_buffer: Enable multiple register writes
- * @disable_write_buffer: Disable multiple register writes
- * @write_flush: Flush buffered register writes
+ * @write_flush: flush buffered register writes and disable buffering
  */
 struct ath_ops {
 	unsigned int (*read)(void *, u32 reg_offset);
 	void (*write)(void *, u32 val, u32 reg_offset);
 	void (*enable_write_buffer)(void *);
-	void (*disable_write_buffer)(void *);
 	void (*write_flush) (void *);
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 9936297..61e7a48 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -180,7 +180,6 @@ static void ath9k_ani_restart_old(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
@@ -215,7 +214,6 @@ static void ath9k_ani_restart_new(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
@@ -643,7 +641,6 @@ static void ath9k_ani_reset_old(struct ath_hw *ah, bool is_scanning)
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 /*
@@ -737,7 +734,6 @@ static void ath9k_ani_reset_new(struct ath_hw *ah, bool is_scanning)
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 static void ath9k_hw_ani_monitor_old(struct ath_hw *ah,
@@ -991,7 +987,6 @@ void ath9k_enable_mib_counters(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 /* Freeze the MIB counters, get the stats and then clear them */
@@ -1261,7 +1256,6 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PHY_ERR_2, ah->ani[0].cckPhyErrBase);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	ath9k_enable_mib_counters(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 74b4213..da07f8d 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -615,14 +615,11 @@ static void ar5008_hw_init_chain_masks(struct ath_hw *ah)
 	rx_chainmask = ah->rxchainmask;
 	tx_chainmask = ah->txchainmask;
 
-	ENABLE_REGWRITE_BUFFER(ah);
 
 	switch (rx_chainmask) {
 	case 0x5:
-		DISABLE_REGWRITE_BUFFER(ah);
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
 			    AR_PHY_SWAP_ALT_CHAIN);
-		ENABLE_REGWRITE_BUFFER(ah);
 	case 0x3:
 		if (ah->hw_version.macVersion == AR_SREV_REVISION_5416_10) {
 			REG_WRITE(ah, AR_PHY_RX_CHAINMASK, 0x7);
@@ -632,17 +629,18 @@ static void ar5008_hw_init_chain_masks(struct ath_hw *ah)
 	case 0x1:
 	case 0x2:
 	case 0x7:
+		ENABLE_REGWRITE_BUFFER(ah);
 		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx_chainmask);
 		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx_chainmask);
 		break;
 	default:
+		ENABLE_REGWRITE_BUFFER(ah);
 		break;
 	}
 
 	REG_WRITE(ah, AR_SELFGEN_MASK, tx_chainmask);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	if (tx_chainmask == 0x5) {
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
@@ -728,7 +726,6 @@ static void ar5008_hw_set_channel_regs(struct ath_hw *ah,
 	REG_WRITE(ah, AR_CST, 0xF << AR_CST_TIMEOUT_LIMIT_S);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 
@@ -820,7 +817,6 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 	}
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	if (AR_SREV_9280(ah) || AR_SREV_9287_11_OR_LATER(ah))
 		REG_WRITE_ARRAY(&ah->iniModesRxGain, modesIndex, regWrites);
@@ -851,7 +847,6 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 	}
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	if (AR_SREV_9271(ah)) {
 		if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) == 1)
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index f0525fb..15f62cd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -522,7 +522,6 @@ static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 		REG_WRITE(ah, regList[i][0], regList[i][1]);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 static inline void ar9285_hw_pa_cal(struct ath_hw *ah, bool is_reset)
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index fde45082..78bdf0c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -371,7 +371,6 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 			REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 
 			REGWRITE_BUFFER_FLUSH(ah);
-			DISABLE_REGWRITE_BUFFER(ah);
 		}
 
 		udelay(1000);
@@ -468,7 +467,6 @@ static int ar9002_hw_get_radiorev(struct ath_hw *ah)
 		REG_WRITE(ah, AR_PHY(0x20), 0x00010000);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	val = (REG_READ(ah, AR_PHY(256)) >> 24) & 0xff;
 	val = ((val & 0xf0) >> 4) | ((val & 0x0f) << 4);
@@ -627,6 +625,4 @@ void ar9002_hw_load_ani_reg(struct ath_hw *ah, struct ath9k_channel *chan)
 	}
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
-
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index cd56c86..c00cdc6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -415,7 +415,6 @@ static void ar9002_hw_spur_mitigate(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 static void ar9002_olc_init(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 6c38c72..6d50948 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -300,7 +300,6 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 		}
 	}
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index d6eed1f..2a4fca4 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -500,7 +500,6 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_hw *ah,
 			}
 
 			REGWRITE_BUFFER_FLUSH(ah);
-			DISABLE_REGWRITE_BUFFER(ah);
 		}
 	}
 
@@ -832,7 +831,6 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 	}
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 static void ath9k_hw_4k_set_addac(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index b100db2..6835f9b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -380,15 +380,6 @@ static void ath9k_enable_regwrite_buffer(void *hw_priv)
 	atomic_inc(&priv->wmi->mwrite_cnt);
 }
 
-static void ath9k_disable_regwrite_buffer(void *hw_priv)
-{
-	struct ath_hw *ah = (struct ath_hw *) hw_priv;
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) common->priv;
-
-	atomic_dec(&priv->wmi->mwrite_cnt);
-}
-
 static void ath9k_regwrite_flush(void *hw_priv)
 {
 	struct ath_hw *ah = (struct ath_hw *) hw_priv;
@@ -397,6 +388,9 @@ static void ath9k_regwrite_flush(void *hw_priv)
 	u32 rsp_status;
 	int r;
 
+	if (!atomic_dec_and_test(&priv->wmi->mwrite_cnt))
+		return;
+
 	mutex_lock(&priv->wmi->multi_write_mutex);
 
 	if (priv->wmi->multi_write_idx) {
@@ -420,7 +414,6 @@ static const struct ath_ops ath9k_common_ops = {
 	.read = ath9k_regread,
 	.write = ath9k_regwrite,
 	.enable_write_buffer = ath9k_enable_regwrite_buffer,
-	.disable_write_buffer = ath9k_disable_regwrite_buffer,
 	.write_flush = ath9k_regwrite_flush,
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1b06604..98c9765 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -299,7 +299,6 @@ static void ath9k_hw_disablepcie(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 /* This should work for all families including legacy */
@@ -676,7 +675,6 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 	REG_WRITE(ah, AR_TXOP_12_15, 0xFFFFFFFF);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 static void ath9k_hw_init_pll(struct ath_hw *ah,
@@ -741,7 +739,6 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 	}
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		REG_WRITE(ah, AR_INTR_PRIO_ASYNC_ENABLE, 0);
@@ -885,7 +882,6 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 	REG_WRITE(ah, AR_TXCFG, regval | AR_TXCFG_DMASZ_128B);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	/*
 	 * Restore TX Trigger Level to its pre-reset value.
@@ -933,7 +929,6 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 	}
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		ath9k_hw_reset_txstatus_ring(ah);
@@ -1031,7 +1026,6 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 	REG_WRITE(ah, AR_RTC_RC, rst_flags);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	udelay(50);
 
@@ -1070,7 +1064,6 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 	udelay(2);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		udelay(2);
@@ -1374,7 +1367,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	r = ath9k_hw_rf_set_freq(ah, chan);
 	if (r)
@@ -1386,7 +1378,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		REG_WRITE(ah, AR_DQCUMASK(i), 1 << i);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	ah->intr_txqs = 0;
 	for (i = 0; i < ah->caps.total_queues; i++)
@@ -1434,7 +1425,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	REG_WRITE(ah, AR_CFG_LED, saveLedState | AR_CFG_SCLK_32KHZ);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	/*
 	 * For big endian systems turn on swapping for descriptors
@@ -1684,7 +1674,6 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 	REG_WRITE(ah, AR_NDP_PERIOD, TU_TO_USEC(beacon_period));
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	beacon_period &= ~ATH9K_BEACON_ENA;
 	if (beacon_period & ATH9K_BEACON_RESET_TSF) {
@@ -1712,7 +1701,6 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 		  TU_TO_USEC(bs->bs_intval & ATH9K_BEACON_PERIOD));
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	REG_RMW_FIELD(ah, AR_RSSI_THR,
 		      AR_RSSI_THR_BM_THR, bs->bs_bmissthreshold);
@@ -1758,7 +1746,6 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	REG_WRITE(ah, AR_DTIM_PERIOD, TU_TO_USEC(dtimperiod));
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	REG_SET_BIT(ah, AR_TIMER_MODE,
 		    AR_TBTT_TIMER_EN | AR_TIM_TIMER_EN |
@@ -2176,7 +2163,6 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 			  REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_ZLFDMA);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 }
 EXPORT_SYMBOL(ath9k_hw_setrxfilter);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 87dbb85..d558c51 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -70,19 +70,13 @@
 
 #define ENABLE_REGWRITE_BUFFER(_ah)					\
 	do {								\
-		if (AR_SREV_9271(_ah))					\
+		if (ath9k_hw_common(_ah)->ops->enable_write_buffer)	\
 			ath9k_hw_common(_ah)->ops->enable_write_buffer((_ah)); \
 	} while (0)
 
-#define DISABLE_REGWRITE_BUFFER(_ah)					\
-	do {								\
-		if (AR_SREV_9271(_ah))					\
-			ath9k_hw_common(_ah)->ops->disable_write_buffer((_ah)); \
-	} while (0)
-
 #define REGWRITE_BUFFER_FLUSH(_ah)					\
 	do {								\
-		if (AR_SREV_9271(_ah))					\
+		if (ath9k_hw_common(_ah)->ops->write_flush)		\
 			ath9k_hw_common(_ah)->ops->write_flush((_ah));	\
 	} while (0)
 
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 3efda8a..e578459 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -40,7 +40,6 @@ static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 }
 
 u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q)
@@ -530,7 +529,6 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 	}
 
 	REGWRITE_BUFFER_FLUSH(ah);
-	DISABLE_REGWRITE_BUFFER(ah);
 
 	if (qi->tqi_qflags & TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE) {
 		REG_WRITE(ah, AR_DMISC(q),
@@ -553,7 +551,6 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 			  | AR_D_MISC_POST_FR_BKOFF_DIS);
 
 		REGWRITE_BUFFER_FLUSH(ah);
-		DISABLE_REGWRITE_BUFFER(ah);
 
 		/*
 		 * cwmin and cwmax should be 0 for beacon queue
@@ -585,7 +582,6 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 			     AR_D_MISC_ARB_LOCKOUT_CNTRL_S));
 
 		REGWRITE_BUFFER_FLUSH(ah);
-		DISABLE_REGWRITE_BUFFER(ah);
 
 		break;
 	case ATH9K_TX_QUEUE_PSPOLL:
-- 
1.7.2.2


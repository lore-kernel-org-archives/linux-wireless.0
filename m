Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:20592 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752623Ab0CYFtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 01:49:43 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0443086181
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:49:41 +0900 (JST)
Subject: [PATCH 07/10] ath5k: simplify MIB counters
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Thu, 25 Mar 2010 14:49:36 +0900
Message-ID: <20100325054936.10697.83634.stgit@tt-desk>
In-Reply-To: <20100325054603.10697.48915.stgit@tt-desk>
References: <20100325054603.10697.48915.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let's keep MIB counter statistics in our own statistics structure and only
convert it to ieee80211_low_level_stats when needed by mac80211. Also we don't
need to read profile count registers in the MIB interrupt (they don't trigger
MIB interrupts).

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    3 +-
 drivers/net/wireless/ath/ath5k/base.c  |   16 ++++++-------
 drivers/net/wireless/ath/ath5k/base.h  |   13 +++++++++--
 drivers/net/wireless/ath/ath5k/pcu.c   |   39 +++++++++++---------------------
 4 files changed, 32 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index cefd28d..ec62690 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1173,8 +1173,7 @@ int ath5k_hw_update_tx_triglevel(struct ath5k_hw *ah, bool increase);
 bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah);
 int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask);
 enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask);
-void ath5k_hw_update_mib_counters(struct ath5k_hw *ah,
-				  struct ieee80211_low_level_stats *stats);
+void ath5k_hw_update_mib_counters(struct ath5k_hw *ah);
 
 /* EEPROM access functions */
 int ath5k_eeprom_init(struct ath5k_hw *ah);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index ba2fad2..ea33b99 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2114,7 +2114,7 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		info->status.rates[ts.ts_final_idx].count++;
 
 		if (unlikely(ts.ts_status)) {
-			sc->ll_stats.dot11ACKFailureCount++;
+			sc->stats.ack_fail++;
 			if (ts.ts_status & AR5K_TXERR_FILT) {
 				info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 				sc->stats.txerr_filt++;
@@ -2708,11 +2708,7 @@ ath5k_intr(int irq, void *dev_id)
 				/* TODO */
 			}
 			if (status & AR5K_INT_MIB) {
-				/*
-				 * These stats are also used for ANI i think
-				 * so how about updating them more often ?
-				 */
-				ath5k_hw_update_mib_counters(ah, &sc->ll_stats);
+				ath5k_hw_update_mib_counters(ah);
 			}
 			if (status & AR5K_INT_GPIO)
 				tasklet_schedule(&sc->rf_kill.toggleq);
@@ -3234,12 +3230,14 @@ ath5k_get_stats(struct ieee80211_hw *hw,
 		struct ieee80211_low_level_stats *stats)
 {
 	struct ath5k_softc *sc = hw->priv;
-	struct ath5k_hw *ah = sc->ah;
 
 	/* Force update */
-	ath5k_hw_update_mib_counters(ah, &sc->ll_stats);
+	ath5k_hw_update_mib_counters(sc->ah);
 
-	memcpy(stats, &sc->ll_stats, sizeof(sc->ll_stats));
+	stats->dot11ACKFailureCount = sc->stats.ack_fail;
+	stats->dot11RTSFailureCount = sc->stats.rts_fail;
+	stats->dot11RTSSuccessCount = sc->stats.rts_ok;
+	stats->dot11FCSErrorCount = sc->stats.fcs_error;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 33f1d8b..fe5dae5 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -105,10 +105,13 @@ struct ath5k_rfkill {
 	struct tasklet_struct toggleq;
 };
 
-/* statistics (only used for debugging now) */
+/* statistics */
 struct ath5k_statistics {
+	/* antenna use */
 	unsigned int antenna_rx[5];	/* frames count per antenna RX */
 	unsigned int antenna_tx[5];	/* frames count per antenna TX */
+
+	/* frame errors */
 	unsigned int rx_all_count;	/* all RX frames, including errors */
 	unsigned int tx_all_count;	/* all TX frames, including errors */
 	unsigned int rxerr_crc;
@@ -121,6 +124,13 @@ struct ath5k_statistics {
 	unsigned int txerr_retry;
 	unsigned int txerr_fifo;
 	unsigned int txerr_filt;
+
+	/* MIB counters */
+	unsigned int ack_fail;
+	unsigned int rts_fail;
+	unsigned int rts_ok;
+	unsigned int fcs_error;
+	unsigned int beacons;
 };
 
 #if CHAN_DEBUG
@@ -135,7 +145,6 @@ struct ath5k_softc {
 	struct pci_dev		*pdev;		/* for dma mapping */
 	void __iomem		*iobase;	/* address of the device */
 	struct mutex		lock;		/* dev-level lock */
-	struct ieee80211_low_level_stats ll_stats;
 	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 	struct ieee80211_channel channels[ATH_CHAN_MAX];
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 1b9fcb8..c7c1fe0 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -113,39 +113,26 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
 }
 
 /**
- * ath5k_hw_update - Update mib counters (mac layer statistics)
+ * ath5k_hw_update - Update MIB counters (mac layer statistics)
  *
  * @ah: The &struct ath5k_hw
- * @stats: The &struct ieee80211_low_level_stats we use to track
- * statistics on the driver
  *
- * Reads MIB counters from PCU and updates sw statistics. Must be
- * called after a MIB interrupt.
+ * Reads MIB counters from PCU and updates sw statistics. Is called after a
+ * MIB interrupt, because one of these counters might have reached their maximum
+ * and triggered the MIB interrupt, to let us read and clear the counter.
+ *
+ * Is called in interrupt context!
  */
-void ath5k_hw_update_mib_counters(struct ath5k_hw *ah,
-		struct ieee80211_low_level_stats  *stats)
+void ath5k_hw_update_mib_counters(struct ath5k_hw *ah)
 {
-	ATH5K_TRACE(ah->ah_sc);
+	struct ath5k_statistics *stats = &ah->ah_sc->stats;
 
 	/* Read-And-Clear */
-	stats->dot11ACKFailureCount += ath5k_hw_reg_read(ah, AR5K_ACK_FAIL);
-	stats->dot11RTSFailureCount += ath5k_hw_reg_read(ah, AR5K_RTS_FAIL);
-	stats->dot11RTSSuccessCount += ath5k_hw_reg_read(ah, AR5K_RTS_OK);
-	stats->dot11FCSErrorCount += ath5k_hw_reg_read(ah, AR5K_FCS_FAIL);
-
-	/* XXX: Should we use this to track beacon count ?
-	 * -we read it anyway to clear the register */
-	ath5k_hw_reg_read(ah, AR5K_BEACON_CNT);
-
-	/* Reset profile count registers on 5212*/
-	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_TX);
-		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_RX);
-		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_RXCLR);
-		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_CYCLE);
-	}
-
-	/* TODO: Handle ANI stats */
+	stats->ack_fail += ath5k_hw_reg_read(ah, AR5K_ACK_FAIL);
+	stats->rts_fail += ath5k_hw_reg_read(ah, AR5K_RTS_FAIL);
+	stats->rts_ok += ath5k_hw_reg_read(ah, AR5K_RTS_OK);
+	stats->fcs_error += ath5k_hw_reg_read(ah, AR5K_FCS_FAIL);
+	stats->beacons += ath5k_hw_reg_read(ah, AR5K_BEACON_CNT);
 }
 
 /**


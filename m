Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32983 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410Ab0DOVjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v3 81/97] ath9k_hw: Define abstraction for tx desc access
Date: Thu, 15 Apr 2010 17:39:26 -0400
Message-Id: <1271367582-992-82-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   73 ++++
 drivers/net/wireless/ath/ath9k/beacon.c     |    3 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h     |   71 ++++
 drivers/net/wireless/ath/ath9k/hw.h         |   27 ++
 drivers/net/wireless/ath/ath9k/mac.c        |  508 ++++++++++++++-------------
 drivers/net/wireless/ath/ath9k/mac.h        |   27 +--
 drivers/net/wireless/ath/ath9k/xmit.c       |    3 +-
 7 files changed, 431 insertions(+), 281 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 2319456..c270bbe 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -167,6 +167,69 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	return true;
 }
 
+static void ar9003_hw_fill_txdesc(struct ath_hw *ah, void *ds, u32 seglen,
+				  bool is_firstseg, bool is_lastseg,
+				  const void *ds0, dma_addr_t buf_addr,
+				  unsigned int qcu)
+{
+}
+
+static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
+				 struct ath_tx_status *ts)
+{
+	return 0;
+}
+static void ar9003_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
+			    u32 pktLen, enum ath9k_pkt_type type, u32 txPower,
+			    u32 keyIx, enum ath9k_key_type keyType, u32 flags)
+{
+
+}
+
+static void ar9003_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
+					  void *lastds,
+					  u32 durUpdateEn, u32 rtsctsRate,
+					  u32 rtsctsDuration,
+					  struct ath9k_11n_rate_series series[],
+					  u32 nseries, u32 flags)
+{
+
+}
+
+static void ar9003_hw_set11n_aggr_first(struct ath_hw *ah, void *ds,
+					u32 aggrLen)
+{
+
+}
+
+static void ar9003_hw_set11n_aggr_middle(struct ath_hw *ah, void *ds,
+					 u32 numDelims)
+{
+
+}
+
+static void ar9003_hw_set11n_aggr_last(struct ath_hw *ah, void *ds)
+{
+
+}
+
+static void ar9003_hw_clr11n_aggr(struct ath_hw *ah, void *ds)
+{
+
+}
+
+static void ar9003_hw_set11n_burstduration(struct ath_hw *ah, void *ds,
+					   u32 burstDuration)
+{
+
+}
+
+static void ar9003_hw_set11n_virtualmorefrag(struct ath_hw *ah, void *ds,
+					    u32 vmf)
+{
+
+}
+
 void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 {
 	struct ath_hw_ops *ops = ath9k_hw_ops(hw);
@@ -175,6 +238,16 @@ void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 	ops->set_desc_link = ar9003_hw_set_desc_link;
 	ops->get_desc_link = ar9003_hw_get_desc_link;
 	ops->get_isr = ar9003_hw_get_isr;
+	ops->fill_txdesc = ar9003_hw_fill_txdesc;
+	ops->proc_txdesc = ar9003_hw_proc_txdesc;
+	ops->set11n_txdesc = ar9003_hw_set11n_txdesc;
+	ops->set11n_ratescenario = ar9003_hw_set11n_ratescenario;
+	ops->set11n_aggr_first = ar9003_hw_set11n_aggr_first;
+	ops->set11n_aggr_middle = ar9003_hw_set11n_aggr_middle;
+	ops->set11n_aggr_last = ar9003_hw_set11n_aggr_last;
+	ops->clr11n_aggr = ar9003_hw_clr11n_aggr;
+	ops->set11n_burstduration = ar9003_hw_set11n_burstduration;
+	ops->set11n_virtualmorefrag = ar9003_hw_set11n_virtualmorefrag;
 }
 
 void ath9k_hw_set_rx_bufsize(struct ath_hw *ah, u16 buf_size)
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 268b598..c8a4558 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -107,7 +107,8 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 
 	/* NB: beacon's BufLen must be a multiple of 4 bytes */
 	ath9k_hw_filltxdesc(ah, ds, roundup(skb->len, 4),
-			    true, true, ds, bf->bf_buf_addr);
+			    true, true, ds, bf->bf_buf_addr,
+			    sc->beacon.beaconq);
 
 	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 	series[0].Tries = 1;
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index b444ce5..624422a 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -57,6 +57,77 @@ static inline bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 	return ath9k_hw_ops(ah)->get_isr(ah, masked);
 }
 
+static inline void ath9k_hw_filltxdesc(struct ath_hw *ah, void *ds, u32 seglen,
+				  bool is_firstseg, bool is_lastseg,
+				  const void *ds0, dma_addr_t buf_addr,
+				  unsigned int qcu)
+{
+	ath9k_hw_ops(ah)->fill_txdesc(ah, ds, seglen, is_firstseg, is_lastseg,
+				      ds0, buf_addr, qcu);
+}
+
+static inline int ath9k_hw_txprocdesc(struct ath_hw *ah, void *ds,
+				      struct ath_tx_status *ts)
+{
+	return ath9k_hw_ops(ah)->proc_txdesc(ah, ds, ts);
+}
+
+static inline void ath9k_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
+					  u32 pktLen, enum ath9k_pkt_type type,
+					  u32 txPower, u32 keyIx,
+					  enum ath9k_key_type keyType,
+					  u32 flags)
+{
+	ath9k_hw_ops(ah)->set11n_txdesc(ah, ds, pktLen, type, txPower, keyIx,
+				      keyType, flags);
+}
+
+static inline void ath9k_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
+					void *lastds,
+					u32 durUpdateEn, u32 rtsctsRate,
+					u32 rtsctsDuration,
+					struct ath9k_11n_rate_series series[],
+					u32 nseries, u32 flags)
+{
+	ath9k_hw_ops(ah)->set11n_ratescenario(ah, ds, lastds, durUpdateEn,
+					    rtsctsRate, rtsctsDuration, series,
+					    nseries, flags);
+}
+
+static inline void ath9k_hw_set11n_aggr_first(struct ath_hw *ah, void *ds,
+					u32 aggrLen)
+{
+	ath9k_hw_ops(ah)->set11n_aggr_first(ah, ds, aggrLen);
+}
+
+static inline void ath9k_hw_set11n_aggr_middle(struct ath_hw *ah, void *ds,
+					       u32 numDelims)
+{
+	ath9k_hw_ops(ah)->set11n_aggr_middle(ah, ds, numDelims);
+}
+
+static inline void ath9k_hw_set11n_aggr_last(struct ath_hw *ah, void *ds)
+{
+	ath9k_hw_ops(ah)->set11n_aggr_last(ah, ds);
+}
+
+static inline void ath9k_hw_clr11n_aggr(struct ath_hw *ah, void *ds)
+{
+	ath9k_hw_ops(ah)->clr11n_aggr(ah, ds);
+}
+
+static inline void ath9k_hw_set11n_burstduration(struct ath_hw *ah, void *ds,
+						 u32 burstDuration)
+{
+	ath9k_hw_ops(ah)->set11n_burstduration(ah, ds, burstDuration);
+}
+
+static inline void ath9k_hw_set11n_virtualmorefrag(struct ath_hw *ah, void *ds,
+						   u32 vmf)
+{
+	ath9k_hw_ops(ah)->set11n_virtualmorefrag(ah, ds, vmf);
+}
+
 /* Private hardware call ops */
 
 /* PHY ops */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index affb848..457d8dd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -556,6 +556,33 @@ struct ath_hw_ops {
 			  u8 rxchainmask,
 			  bool longcal);
 	bool (*get_isr)(struct ath_hw *ah, enum ath9k_int *masked);
+	void (*fill_txdesc)(struct ath_hw *ah, void *ds, u32 seglen,
+			    bool is_firstseg, bool is_is_lastseg,
+			    const void *ds0, dma_addr_t buf_addr,
+			    unsigned int qcu);
+	int (*proc_txdesc)(struct ath_hw *ah, void *ds,
+			   struct ath_tx_status *ts);
+	void (*set11n_txdesc)(struct ath_hw *ah, void *ds,
+			      u32 pktLen, enum ath9k_pkt_type type,
+			      u32 txPower, u32 keyIx,
+			      enum ath9k_key_type keyType,
+			      u32 flags);
+	void (*set11n_ratescenario)(struct ath_hw *ah, void *ds,
+				void *lastds,
+				u32 durUpdateEn, u32 rtsctsRate,
+				u32 rtsctsDuration,
+				struct ath9k_11n_rate_series series[],
+				u32 nseries, u32 flags);
+	void (*set11n_aggr_first)(struct ath_hw *ah, void *ds,
+				  u32 aggrLen);
+	void (*set11n_aggr_middle)(struct ath_hw *ah, void *ds,
+				   u32 numDelims);
+	void (*set11n_aggr_last)(struct ath_hw *ah, void *ds);
+	void (*clr11n_aggr)(struct ath_hw *ah, void *ds);
+	void (*set11n_burstduration)(struct ath_hw *ah, void *ds,
+				     u32 burstDuration);
+	void (*set11n_virtualmorefrag)(struct ath_hw *ah, void *ds,
+				       u32 vmf);
 };
 
 struct ath_hw {
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 4a36ec5..22fa512 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -183,226 +183,25 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	return true;
 }
 
-void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
-{
-	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
-
-	ops->rx_enable = ar9002_hw_rx_enable;
-	ops->set_desc_link = ar9002_hw_set_desc_link;
-	ops->get_desc_link = ar9002_hw_get_desc_link;
-	ops->get_isr = ar9002_hw_get_isr;
-}
-
-static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
-					struct ath9k_tx_queue_info *qi)
-{
-	ath_print(ath9k_hw_common(ah), ATH_DBG_INTERRUPT,
-		  "tx ok 0x%x err 0x%x desc 0x%x eol 0x%x urn 0x%x\n",
-		  ah->txok_interrupt_mask, ah->txerr_interrupt_mask,
-		  ah->txdesc_interrupt_mask, ah->txeol_interrupt_mask,
-		  ah->txurn_interrupt_mask);
-
-	REG_WRITE(ah, AR_IMR_S0,
-		  SM(ah->txok_interrupt_mask, AR_IMR_S0_QCU_TXOK)
-		  | SM(ah->txdesc_interrupt_mask, AR_IMR_S0_QCU_TXDESC));
-	REG_WRITE(ah, AR_IMR_S1,
-		  SM(ah->txerr_interrupt_mask, AR_IMR_S1_QCU_TXERR)
-		  | SM(ah->txeol_interrupt_mask, AR_IMR_S1_QCU_TXEOL));
-
-	ah->imrs2_reg &= ~AR_IMR_S2_QCU_TXURN;
-	ah->imrs2_reg |= (ah->txurn_interrupt_mask & AR_IMR_S2_QCU_TXURN);
-	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
-}
-
-u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q)
-{
-	return REG_READ(ah, AR_QTXDP(q));
-}
-EXPORT_SYMBOL(ath9k_hw_gettxbuf);
-
-void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp)
-{
-	REG_WRITE(ah, AR_QTXDP(q), txdp);
-}
-EXPORT_SYMBOL(ath9k_hw_puttxbuf);
-
-void ath9k_hw_txstart(struct ath_hw *ah, u32 q)
-{
-	ath_print(ath9k_hw_common(ah), ATH_DBG_QUEUE,
-		  "Enable TXE on queue: %u\n", q);
-	REG_WRITE(ah, AR_Q_TXE, 1 << q);
-}
-EXPORT_SYMBOL(ath9k_hw_txstart);
-
-u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q)
-{
-	u32 npend;
-
-	npend = REG_READ(ah, AR_QSTS(q)) & AR_Q_STS_PEND_FR_CNT;
-	if (npend == 0) {
-
-		if (REG_READ(ah, AR_Q_TXE) & (1 << q))
-			npend = 1;
-	}
-
-	return npend;
-}
-EXPORT_SYMBOL(ath9k_hw_numtxpending);
-
-/**
- * ath9k_hw_updatetxtriglevel - adjusts the frame trigger level
- *
- * @ah: atheros hardware struct
- * @bIncTrigLevel: whether or not the frame trigger level should be updated
- *
- * The frame trigger level specifies the minimum number of bytes,
- * in units of 64 bytes, that must be DMA'ed into the PCU TX FIFO
- * before the PCU will initiate sending the frame on the air. This can
- * mean we initiate transmit before a full frame is on the PCU TX FIFO.
- * Resets to 0x1 (meaning 64 bytes or a full frame, whichever occurs
- * first)
- *
- * Caution must be taken to ensure to set the frame trigger level based
- * on the DMA request size. For example if the DMA request size is set to
- * 128 bytes the trigger level cannot exceed 6 * 64 = 384. This is because
- * there need to be enough space in the tx FIFO for the requested transfer
- * size. Hence the tx FIFO will stop with 512 - 128 = 384 bytes. If we set
- * the threshold to a value beyond 6, then the transmit will hang.
- *
- * Current dual   stream devices have a PCU TX FIFO size of 8 KB.
- * Current single stream devices have a PCU TX FIFO size of 4 KB, however,
- * there is a hardware issue which forces us to use 2 KB instead so the
- * frame trigger level must not exceed 2 KB for these chipsets.
- */
-bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
-{
-	u32 txcfg, curLevel, newLevel;
-	enum ath9k_int omask;
-
-	if (ah->tx_trig_level >= ah->config.max_txtrig_level)
-		return false;
-
-	omask = ath9k_hw_set_interrupts(ah, ah->imask & ~ATH9K_INT_GLOBAL);
-
-	txcfg = REG_READ(ah, AR_TXCFG);
-	curLevel = MS(txcfg, AR_FTRIG);
-	newLevel = curLevel;
-	if (bIncTrigLevel) {
-		if (curLevel < ah->config.max_txtrig_level)
-			newLevel++;
-	} else if (curLevel > MIN_TX_FIFO_THRESHOLD)
-		newLevel--;
-	if (newLevel != curLevel)
-		REG_WRITE(ah, AR_TXCFG,
-			  (txcfg & ~AR_FTRIG) | SM(newLevel, AR_FTRIG));
-
-	ath9k_hw_set_interrupts(ah, omask);
-
-	ah->tx_trig_level = newLevel;
-
-	return newLevel != curLevel;
-}
-EXPORT_SYMBOL(ath9k_hw_updatetxtriglevel);
-
-bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
-{
-#define ATH9K_TX_STOP_DMA_TIMEOUT	4000    /* usec */
-#define ATH9K_TIME_QUANTUM		100     /* usec */
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
-	struct ath9k_tx_queue_info *qi;
-	u32 tsfLow, j, wait;
-	u32 wait_time = ATH9K_TX_STOP_DMA_TIMEOUT / ATH9K_TIME_QUANTUM;
-
-	if (q >= pCap->total_queues) {
-		ath_print(common, ATH_DBG_QUEUE, "Stopping TX DMA, "
-			  "invalid queue: %u\n", q);
-		return false;
-	}
-
-	qi = &ah->txq[q];
-	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		ath_print(common, ATH_DBG_QUEUE, "Stopping TX DMA, "
-			  "inactive queue: %u\n", q);
-		return false;
-	}
-
-	REG_WRITE(ah, AR_Q_TXD, 1 << q);
-
-	for (wait = wait_time; wait != 0; wait--) {
-		if (ath9k_hw_numtxpending(ah, q) == 0)
-			break;
-		udelay(ATH9K_TIME_QUANTUM);
-	}
-
-	if (ath9k_hw_numtxpending(ah, q)) {
-		ath_print(common, ATH_DBG_QUEUE,
-			  "%s: Num of pending TX Frames %d on Q %d\n",
-			  __func__, ath9k_hw_numtxpending(ah, q), q);
-
-		for (j = 0; j < 2; j++) {
-			tsfLow = REG_READ(ah, AR_TSF_L32);
-			REG_WRITE(ah, AR_QUIET2,
-				  SM(10, AR_QUIET2_QUIET_DUR));
-			REG_WRITE(ah, AR_QUIET_PERIOD, 100);
-			REG_WRITE(ah, AR_NEXT_QUIET_TIMER, tsfLow >> 10);
-			REG_SET_BIT(ah, AR_TIMER_MODE,
-				       AR_QUIET_TIMER_EN);
-
-			if ((REG_READ(ah, AR_TSF_L32) >> 10) == (tsfLow >> 10))
-				break;
-
-			ath_print(common, ATH_DBG_QUEUE,
-				  "TSF has moved while trying to set "
-				  "quiet time TSF: 0x%08x\n", tsfLow);
-		}
-
-		REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
-
-		udelay(200);
-		REG_CLR_BIT(ah, AR_TIMER_MODE, AR_QUIET_TIMER_EN);
-
-		wait = wait_time;
-		while (ath9k_hw_numtxpending(ah, q)) {
-			if ((--wait) == 0) {
-				ath_print(common, ATH_DBG_FATAL,
-					  "Failed to stop TX DMA in 100 "
-					  "msec after killing last frame\n");
-				break;
-			}
-			udelay(ATH9K_TIME_QUANTUM);
-		}
-
-		REG_CLR_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
-	}
-
-	REG_WRITE(ah, AR_Q_TXD, 0);
-	return wait != 0;
-
-#undef ATH9K_TX_STOP_DMA_TIMEOUT
-#undef ATH9K_TIME_QUANTUM
-}
-EXPORT_SYMBOL(ath9k_hw_stoptxdma);
-
-void ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
-			 u32 segLen, bool firstSeg,
-			 bool lastSeg, const struct ath_desc *ds0,
-			 dma_addr_t buf_addr)
+static void ar9002_hw_fill_txdesc(struct ath_hw *ah, void *ds, u32 seglen,
+				  bool is_firstseg, bool is_lastseg,
+				  const void *ds0, dma_addr_t buf_addr,
+				  unsigned int qcu)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
 	ads->ds_data = buf_addr;
 
-	if (firstSeg) {
-		ads->ds_ctl1 |= segLen | (lastSeg ? 0 : AR_TxMore);
-	} else if (lastSeg) {
+	if (is_firstseg) {
+		ads->ds_ctl1 |= seglen | (is_lastseg ? 0 : AR_TxMore);
+	} else if (is_lastseg) {
 		ads->ds_ctl0 = 0;
-		ads->ds_ctl1 = segLen;
+		ads->ds_ctl1 = seglen;
 		ads->ds_ctl2 = AR5416DESC_CONST(ds0)->ds_ctl2;
 		ads->ds_ctl3 = AR5416DESC_CONST(ds0)->ds_ctl3;
 	} else {
 		ads->ds_ctl0 = 0;
-		ads->ds_ctl1 = segLen | AR_TxMore;
+		ads->ds_ctl1 = seglen | AR_TxMore;
 		ads->ds_ctl2 = 0;
 		ads->ds_ctl3 = 0;
 	}
@@ -412,22 +211,9 @@ void ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
 	ads->ds_txstatus6 = ads->ds_txstatus7 = 0;
 	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
 }
-EXPORT_SYMBOL(ath9k_hw_filltxdesc);
 
-void ath9k_hw_cleartxdesc(struct ath_hw *ah, struct ath_desc *ds)
-{
-	struct ar5416_desc *ads = AR5416DESC(ds);
-
-	ads->ds_txstatus0 = ads->ds_txstatus1 = 0;
-	ads->ds_txstatus2 = ads->ds_txstatus3 = 0;
-	ads->ds_txstatus4 = ads->ds_txstatus5 = 0;
-	ads->ds_txstatus6 = ads->ds_txstatus7 = 0;
-	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
-}
-EXPORT_SYMBOL(ath9k_hw_cleartxdesc);
-
-int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds,
-			struct ath_tx_status *ts)
+static int ar9002_hw_proc_txdesc(struct ath_hw *ah, void *ds,
+				 struct ath_tx_status *ts)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
@@ -503,11 +289,11 @@ int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 
 	return 0;
 }
-EXPORT_SYMBOL(ath9k_hw_txprocdesc);
 
-void ath9k_hw_set11n_txdesc(struct ath_hw *ah, struct ath_desc *ds,
-			    u32 pktLen, enum ath9k_pkt_type type, u32 txPower,
-			    u32 keyIx, enum ath9k_key_type keyType, u32 flags)
+static void ar9002_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
+				    u32 pktLen, enum ath9k_pkt_type type,
+				    u32 txPower, u32 keyIx,
+				    enum ath9k_key_type keyType, u32 flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
@@ -539,14 +325,13 @@ void ath9k_hw_set11n_txdesc(struct ath_hw *ah, struct ath_desc *ds,
 		ads->ds_ctl11 = 0;
 	}
 }
-EXPORT_SYMBOL(ath9k_hw_set11n_txdesc);
-
-void ath9k_hw_set11n_ratescenario(struct ath_hw *ah, struct ath_desc *ds,
-				  struct ath_desc *lastds,
-				  u32 durUpdateEn, u32 rtsctsRate,
-				  u32 rtsctsDuration,
-				  struct ath9k_11n_rate_series series[],
-				  u32 nseries, u32 flags)
+
+static void ar9002_hw_set11n_ratescenario(struct ath_hw *ah, void *ds,
+					  void *lastds,
+					  u32 durUpdateEn, u32 rtsctsRate,
+					  u32 rtsctsDuration,
+					  struct ath9k_11n_rate_series series[],
+					  u32 nseries, u32 flags)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 	struct ar5416_desc *last_ads = AR5416DESC(lastds);
@@ -595,10 +380,9 @@ void ath9k_hw_set11n_ratescenario(struct ath_hw *ah, struct ath_desc *ds,
 	last_ads->ds_ctl2 = ads->ds_ctl2;
 	last_ads->ds_ctl3 = ads->ds_ctl3;
 }
-EXPORT_SYMBOL(ath9k_hw_set11n_ratescenario);
 
-void ath9k_hw_set11n_aggr_first(struct ath_hw *ah, struct ath_desc *ds,
-				u32 aggrLen)
+static void ar9002_hw_set11n_aggr_first(struct ath_hw *ah, void *ds,
+					u32 aggrLen)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
@@ -606,10 +390,9 @@ void ath9k_hw_set11n_aggr_first(struct ath_hw *ah, struct ath_desc *ds,
 	ads->ds_ctl6 &= ~AR_AggrLen;
 	ads->ds_ctl6 |= SM(aggrLen, AR_AggrLen);
 }
-EXPORT_SYMBOL(ath9k_hw_set11n_aggr_first);
 
-void ath9k_hw_set11n_aggr_middle(struct ath_hw *ah, struct ath_desc *ds,
-				 u32 numDelims)
+static void ar9002_hw_set11n_aggr_middle(struct ath_hw *ah, void *ds,
+					 u32 numDelims)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 	unsigned int ctl6;
@@ -621,9 +404,8 @@ void ath9k_hw_set11n_aggr_middle(struct ath_hw *ah, struct ath_desc *ds,
 	ctl6 |= SM(numDelims, AR_PadDelim);
 	ads->ds_ctl6 = ctl6;
 }
-EXPORT_SYMBOL(ath9k_hw_set11n_aggr_middle);
 
-void ath9k_hw_set11n_aggr_last(struct ath_hw *ah, struct ath_desc *ds)
+static void ar9002_hw_set11n_aggr_last(struct ath_hw *ah, void *ds)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
@@ -631,28 +413,25 @@ void ath9k_hw_set11n_aggr_last(struct ath_hw *ah, struct ath_desc *ds)
 	ads->ds_ctl1 &= ~AR_MoreAggr;
 	ads->ds_ctl6 &= ~AR_PadDelim;
 }
-EXPORT_SYMBOL(ath9k_hw_set11n_aggr_last);
 
-void ath9k_hw_clr11n_aggr(struct ath_hw *ah, struct ath_desc *ds)
+static void ar9002_hw_clr11n_aggr(struct ath_hw *ah, void *ds)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
 	ads->ds_ctl1 &= (~AR_IsAggr & ~AR_MoreAggr);
 }
-EXPORT_SYMBOL(ath9k_hw_clr11n_aggr);
 
-void ath9k_hw_set11n_burstduration(struct ath_hw *ah, struct ath_desc *ds,
-				   u32 burstDuration)
+static void ar9002_hw_set11n_burstduration(struct ath_hw *ah, void *ds,
+					   u32 burstDuration)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
 	ads->ds_ctl2 &= ~AR_BurstDur;
 	ads->ds_ctl2 |= SM(burstDuration, AR_BurstDur);
 }
-EXPORT_SYMBOL(ath9k_hw_set11n_burstduration);
 
-void ath9k_hw_set11n_virtualmorefrag(struct ath_hw *ah, struct ath_desc *ds,
-				     u32 vmf)
+static void ar9002_hw_set11n_virtualmorefrag(struct ath_hw *ah, void *ds,
+					    u32 vmf)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
@@ -662,6 +441,229 @@ void ath9k_hw_set11n_virtualmorefrag(struct ath_hw *ah, struct ath_desc *ds,
 		ads->ds_ctl0 &= ~AR_VirtMoreFrag;
 }
 
+void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
+{
+	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
+
+	ops->rx_enable = ar9002_hw_rx_enable;
+	ops->set_desc_link = ar9002_hw_set_desc_link;
+	ops->get_desc_link = ar9002_hw_get_desc_link;
+	ops->get_isr = ar9002_hw_get_isr;
+	ops->fill_txdesc = ar9002_hw_fill_txdesc;
+	ops->proc_txdesc = ar9002_hw_proc_txdesc;
+	ops->set11n_txdesc = ar9002_hw_set11n_txdesc;
+	ops->set11n_ratescenario = ar9002_hw_set11n_ratescenario;
+	ops->set11n_aggr_first = ar9002_hw_set11n_aggr_first;
+	ops->set11n_aggr_middle = ar9002_hw_set11n_aggr_middle;
+	ops->set11n_aggr_last = ar9002_hw_set11n_aggr_last;
+	ops->clr11n_aggr = ar9002_hw_clr11n_aggr;
+	ops->set11n_burstduration = ar9002_hw_set11n_burstduration;
+	ops->set11n_virtualmorefrag = ar9002_hw_set11n_virtualmorefrag;
+}
+
+static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
+					struct ath9k_tx_queue_info *qi)
+{
+	ath_print(ath9k_hw_common(ah), ATH_DBG_INTERRUPT,
+		  "tx ok 0x%x err 0x%x desc 0x%x eol 0x%x urn 0x%x\n",
+		  ah->txok_interrupt_mask, ah->txerr_interrupt_mask,
+		  ah->txdesc_interrupt_mask, ah->txeol_interrupt_mask,
+		  ah->txurn_interrupt_mask);
+
+	REG_WRITE(ah, AR_IMR_S0,
+		  SM(ah->txok_interrupt_mask, AR_IMR_S0_QCU_TXOK)
+		  | SM(ah->txdesc_interrupt_mask, AR_IMR_S0_QCU_TXDESC));
+	REG_WRITE(ah, AR_IMR_S1,
+		  SM(ah->txerr_interrupt_mask, AR_IMR_S1_QCU_TXERR)
+		  | SM(ah->txeol_interrupt_mask, AR_IMR_S1_QCU_TXEOL));
+
+	ah->imrs2_reg &= ~AR_IMR_S2_QCU_TXURN;
+	ah->imrs2_reg |= (ah->txurn_interrupt_mask & AR_IMR_S2_QCU_TXURN);
+	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
+}
+
+u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q)
+{
+	return REG_READ(ah, AR_QTXDP(q));
+}
+EXPORT_SYMBOL(ath9k_hw_gettxbuf);
+
+void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp)
+{
+	REG_WRITE(ah, AR_QTXDP(q), txdp);
+}
+EXPORT_SYMBOL(ath9k_hw_puttxbuf);
+
+void ath9k_hw_txstart(struct ath_hw *ah, u32 q)
+{
+	ath_print(ath9k_hw_common(ah), ATH_DBG_QUEUE,
+		  "Enable TXE on queue: %u\n", q);
+	REG_WRITE(ah, AR_Q_TXE, 1 << q);
+}
+EXPORT_SYMBOL(ath9k_hw_txstart);
+
+void ath9k_hw_cleartxdesc(struct ath_hw *ah, void *ds)
+{
+	struct ar5416_desc *ads = AR5416DESC(ds);
+
+	ads->ds_txstatus0 = ads->ds_txstatus1 = 0;
+	ads->ds_txstatus2 = ads->ds_txstatus3 = 0;
+	ads->ds_txstatus4 = ads->ds_txstatus5 = 0;
+	ads->ds_txstatus6 = ads->ds_txstatus7 = 0;
+	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
+}
+EXPORT_SYMBOL(ath9k_hw_cleartxdesc);
+
+u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q)
+{
+	u32 npend;
+
+	npend = REG_READ(ah, AR_QSTS(q)) & AR_Q_STS_PEND_FR_CNT;
+	if (npend == 0) {
+
+		if (REG_READ(ah, AR_Q_TXE) & (1 << q))
+			npend = 1;
+	}
+
+	return npend;
+}
+EXPORT_SYMBOL(ath9k_hw_numtxpending);
+
+/**
+ * ath9k_hw_updatetxtriglevel - adjusts the frame trigger level
+ *
+ * @ah: atheros hardware struct
+ * @bIncTrigLevel: whether or not the frame trigger level should be updated
+ *
+ * The frame trigger level specifies the minimum number of bytes,
+ * in units of 64 bytes, that must be DMA'ed into the PCU TX FIFO
+ * before the PCU will initiate sending the frame on the air. This can
+ * mean we initiate transmit before a full frame is on the PCU TX FIFO.
+ * Resets to 0x1 (meaning 64 bytes or a full frame, whichever occurs
+ * first)
+ *
+ * Caution must be taken to ensure to set the frame trigger level based
+ * on the DMA request size. For example if the DMA request size is set to
+ * 128 bytes the trigger level cannot exceed 6 * 64 = 384. This is because
+ * there need to be enough space in the tx FIFO for the requested transfer
+ * size. Hence the tx FIFO will stop with 512 - 128 = 384 bytes. If we set
+ * the threshold to a value beyond 6, then the transmit will hang.
+ *
+ * Current dual   stream devices have a PCU TX FIFO size of 8 KB.
+ * Current single stream devices have a PCU TX FIFO size of 4 KB, however,
+ * there is a hardware issue which forces us to use 2 KB instead so the
+ * frame trigger level must not exceed 2 KB for these chipsets.
+ */
+bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
+{
+	u32 txcfg, curLevel, newLevel;
+	enum ath9k_int omask;
+
+	if (ah->tx_trig_level >= ah->config.max_txtrig_level)
+		return false;
+
+	omask = ath9k_hw_set_interrupts(ah, ah->imask & ~ATH9K_INT_GLOBAL);
+
+	txcfg = REG_READ(ah, AR_TXCFG);
+	curLevel = MS(txcfg, AR_FTRIG);
+	newLevel = curLevel;
+	if (bIncTrigLevel) {
+		if (curLevel < ah->config.max_txtrig_level)
+			newLevel++;
+	} else if (curLevel > MIN_TX_FIFO_THRESHOLD)
+		newLevel--;
+	if (newLevel != curLevel)
+		REG_WRITE(ah, AR_TXCFG,
+			  (txcfg & ~AR_FTRIG) | SM(newLevel, AR_FTRIG));
+
+	ath9k_hw_set_interrupts(ah, omask);
+
+	ah->tx_trig_level = newLevel;
+
+	return newLevel != curLevel;
+}
+EXPORT_SYMBOL(ath9k_hw_updatetxtriglevel);
+
+bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
+{
+#define ATH9K_TX_STOP_DMA_TIMEOUT	4000    /* usec */
+#define ATH9K_TIME_QUANTUM		100     /* usec */
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath9k_tx_queue_info *qi;
+	u32 tsfLow, j, wait;
+	u32 wait_time = ATH9K_TX_STOP_DMA_TIMEOUT / ATH9K_TIME_QUANTUM;
+
+	if (q >= pCap->total_queues) {
+		ath_print(common, ATH_DBG_QUEUE, "Stopping TX DMA, "
+			  "invalid queue: %u\n", q);
+		return false;
+	}
+
+	qi = &ah->txq[q];
+	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
+		ath_print(common, ATH_DBG_QUEUE, "Stopping TX DMA, "
+			  "inactive queue: %u\n", q);
+		return false;
+	}
+
+	REG_WRITE(ah, AR_Q_TXD, 1 << q);
+
+	for (wait = wait_time; wait != 0; wait--) {
+		if (ath9k_hw_numtxpending(ah, q) == 0)
+			break;
+		udelay(ATH9K_TIME_QUANTUM);
+	}
+
+	if (ath9k_hw_numtxpending(ah, q)) {
+		ath_print(common, ATH_DBG_QUEUE,
+			  "%s: Num of pending TX Frames %d on Q %d\n",
+			  __func__, ath9k_hw_numtxpending(ah, q), q);
+
+		for (j = 0; j < 2; j++) {
+			tsfLow = REG_READ(ah, AR_TSF_L32);
+			REG_WRITE(ah, AR_QUIET2,
+				  SM(10, AR_QUIET2_QUIET_DUR));
+			REG_WRITE(ah, AR_QUIET_PERIOD, 100);
+			REG_WRITE(ah, AR_NEXT_QUIET_TIMER, tsfLow >> 10);
+			REG_SET_BIT(ah, AR_TIMER_MODE,
+				       AR_QUIET_TIMER_EN);
+
+			if ((REG_READ(ah, AR_TSF_L32) >> 10) == (tsfLow >> 10))
+				break;
+
+			ath_print(common, ATH_DBG_QUEUE,
+				  "TSF has moved while trying to set "
+				  "quiet time TSF: 0x%08x\n", tsfLow);
+		}
+
+		REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
+
+		udelay(200);
+		REG_CLR_BIT(ah, AR_TIMER_MODE, AR_QUIET_TIMER_EN);
+
+		wait = wait_time;
+		while (ath9k_hw_numtxpending(ah, q)) {
+			if ((--wait) == 0) {
+				ath_print(common, ATH_DBG_FATAL,
+					  "Failed to stop TX DMA in 100 "
+					  "msec after killing last frame\n");
+				break;
+			}
+			udelay(ATH9K_TIME_QUANTUM);
+		}
+
+		REG_CLR_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
+	}
+
+	REG_WRITE(ah, AR_Q_TXD, 0);
+	return wait != 0;
+
+#undef ATH9K_TX_STOP_DMA_TIMEOUT
+#undef ATH9K_TIME_QUANTUM
+}
+EXPORT_SYMBOL(ath9k_hw_stoptxdma);
+
 void ath9k_hw_gettxintrtxqs(struct ath_hw *ah, u32 *txqs)
 {
 	*txqs &= ah->intr_txqs;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 7c0d754..0d49219 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -687,35 +687,10 @@ struct ath9k_channel;
 u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q);
 void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp);
 void ath9k_hw_txstart(struct ath_hw *ah, u32 q);
+void ath9k_hw_cleartxdesc(struct ath_hw *ah, void *ds);
 u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q);
 bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel);
 bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q);
-void ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
-			 u32 segLen, bool firstSeg,
-			 bool lastSeg, const struct ath_desc *ds0,
-			 dma_addr_t buf_addr);
-void ath9k_hw_cleartxdesc(struct ath_hw *ah, struct ath_desc *ds);
-int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds,
-			struct ath_tx_status *ts);
-void ath9k_hw_set11n_txdesc(struct ath_hw *ah, struct ath_desc *ds,
-			    u32 pktLen, enum ath9k_pkt_type type, u32 txPower,
-			    u32 keyIx, enum ath9k_key_type keyType, u32 flags);
-void ath9k_hw_set11n_ratescenario(struct ath_hw *ah, struct ath_desc *ds,
-				  struct ath_desc *lastds,
-				  u32 durUpdateEn, u32 rtsctsRate,
-				  u32 rtsctsDuration,
-				  struct ath9k_11n_rate_series series[],
-				  u32 nseries, u32 flags);
-void ath9k_hw_set11n_aggr_first(struct ath_hw *ah, struct ath_desc *ds,
-				u32 aggrLen);
-void ath9k_hw_set11n_aggr_middle(struct ath_hw *ah, struct ath_desc *ds,
-				 u32 numDelims);
-void ath9k_hw_set11n_aggr_last(struct ath_hw *ah, struct ath_desc *ds);
-void ath9k_hw_clr11n_aggr(struct ath_hw *ah, struct ath_desc *ds);
-void ath9k_hw_set11n_burstduration(struct ath_hw *ah, struct ath_desc *ds,
-				   u32 burstDuration);
-void ath9k_hw_set11n_virtualmorefrag(struct ath_hw *ah, struct ath_desc *ds,
-				     u32 vmf);
 void ath9k_hw_gettxintrtxqs(struct ath_hw *ah, u32 *txqs);
 bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 			    const struct ath9k_tx_queue_info *qinfo);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 6ab2099..550253f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1669,7 +1669,8 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			    true,	/* first segment */
 			    true,	/* last segment */
 			    ds,		/* first descriptor */
-			    bf->bf_buf_addr);
+			    bf->bf_buf_addr,
+			    txctl->txq->axq_qnum);
 
 	spin_lock_bh(&txctl->txq->axq_lock);
 
-- 
1.6.3.3


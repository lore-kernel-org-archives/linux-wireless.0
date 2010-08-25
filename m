Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [12.19.149.2] ([12.19.149.2]:29260 "EHLO mail.atheros.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab0HYORL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 10:17:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 25 Aug 2010 07:17:07 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Aeolus.Yang@Atheros.com>,
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: [PATCH 1/2] ath9k: Fix for throughput issue in Intel Pinetrail platform.
Date: Wed, 25 Aug 2010 19:41:59 +0530
Message-ID: <1282745520-21156-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trigger the generic timer interrupt frequently as a workaround
to improve the throughput in C3 state with the Intel Pinetrail
platform.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   21 ++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/debug.c |    8 ++++++--
 drivers/net/wireless/ath/ath9k/gpio.c  |    4 ++--
 drivers/net/wireless/ath/ath9k/hw.c    |    6 ++++--
 drivers/net/wireless/ath/ath9k/init.c  |   23 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/main.c  |    9 ++++++++-
 drivers/net/wireless/ath/ath9k/xmit.c  |   29 +++++++++++++++++++++++++++++
 7 files changed, 92 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f0197a6..841760c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -31,6 +31,7 @@
  */
 
 struct ath_node;
+extern unsigned int c3_war_timer;
 
 /* Macro to expand scalars to 64-bit objects */
 
@@ -241,6 +242,7 @@ struct ath_buf {
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
 	bool bf_stale;
+	bool bf_isdata;
 	bool bf_isnullfunc;
 	bool bf_tx_aborted;
 	u16 bf_flags;
@@ -597,8 +599,23 @@ struct ath_softc {
 	struct ath_btcoex btcoex;
 
 	struct ath_descdma txsdma;
+
+	atomic_t pending_tx_data_frames;
+	bool fifo_underrun;
+	bool c3_timer_active;
+	spinlock_t c3_lock;
+	struct ath_gen_timer *c3_hw_timer;
 };
 
+static inline void stop_c3_hw_timer(struct ath_softc *sc)
+{
+	if (c3_war_timer) {
+		spin_lock(&sc->c3_lock);
+		sc->c3_timer_active = false;
+		spin_unlock(&sc->c3_lock);
+	}
+}
+
 struct ath_wiphy {
 	struct ath_softc *sc; /* shared for all virtual wiphys */
 	struct ieee80211_hw *hw;
@@ -685,5 +702,7 @@ bool ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue);
 
 void ath_start_rfkill_poll(struct ath_softc *sc);
 extern void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
-
+void ath9k_gen_timer_start(struct ath_hw *ah, struct ath_gen_timer *timer,
+			   u32 timer_next, u32 timer_period);
+void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer);
 #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 54aae93..4e4c77d 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -693,10 +693,14 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_txq *txq,
 		TX_STAT_INC(txq->axq_qnum, timer_exp);
 	if (ts->ts_flags & ATH9K_TX_DESC_CFG_ERR)
 		TX_STAT_INC(txq->axq_qnum, desc_cfg_err);
-	if (ts->ts_flags & ATH9K_TX_DATA_UNDERRUN)
+	if (ts->ts_flags & ATH9K_TX_DATA_UNDERRUN) {
 		TX_STAT_INC(txq->axq_qnum, data_underrun);
-	if (ts->ts_flags & ATH9K_TX_DELIM_UNDERRUN)
+		sc->fifo_underrun = 1;
+	}
+	if (ts->ts_flags & ATH9K_TX_DELIM_UNDERRUN) {
 		TX_STAT_INC(txq->axq_qnum, delim_underrun);
+		sc->fifo_underrun = 1;
+	}
 }
 
 static const struct file_operations fops_xmit = {
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 4a9a68b..ca8311b 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -251,7 +251,7 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 	}
 }
 
-static void ath9k_gen_timer_start(struct ath_hw *ah,
+void ath9k_gen_timer_start(struct ath_hw *ah,
 				  struct ath_gen_timer *timer,
 				  u32 timer_next,
 				  u32 timer_period)
@@ -265,7 +265,7 @@ static void ath9k_gen_timer_start(struct ath_hw *ah,
 	}
 }
 
-static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
+void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 {
 	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3384ca1..c69642a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2763,7 +2763,8 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 		BUG_ON(!timer);
 		ath_print(common, ATH_DBG_HWTIMER,
 			  "TSF overflow for Gen timer %d\n", index);
-		timer->overflow(timer->arg);
+		if (timer->overflow)
+			timer->overflow(timer->arg);
 	}
 
 	while (trigger_mask) {
@@ -2772,7 +2773,8 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 		BUG_ON(!timer);
 		ath_print(common, ATH_DBG_HWTIMER,
 			  "Gen timer[%d] trigger\n", index);
-		timer->trigger(timer->arg);
+		if (timer->trigger)
+			timer->trigger(timer->arg);
 	}
 }
 EXPORT_SYMBOL(ath_gen_timer_isr);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 243c177..c3ae6f9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -18,6 +18,8 @@
 
 #include "ath9k.h"
 
+#define ATH_TIMER_INDEX(i) ((debruijn32 << i) >> 27)
+
 static char *dev_info = "ath9k";
 
 MODULE_AUTHOR("Atheros Communications");
@@ -37,6 +39,9 @@ int led_blink = 1;
 module_param_named(blink, led_blink, int, 0444);
 MODULE_PARM_DESC(blink, "Enable LED blink on activity");
 
+unsigned int c3_war_timer;
+module_param_named(c3_timer, c3_war_timer, uint, 0);
+
 /* We use the hw_value as an index into our private channel structure */
 
 #define CHAN2G(_freq, _idx)  { \
@@ -597,6 +602,21 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	ath9k_init_channels_rates(sc);
 	ath9k_init_misc(sc);
 
+	if (c3_war_timer) {
+		int i;
+		for (i = 0; i < 32; i++)
+			sc->sc_ah->hw_gen_timers.gen_timer_index
+				   [ATH_TIMER_INDEX(i)] = i;
+
+		sc->c3_hw_timer = ath_gen_timer_alloc(ah, NULL,
+						      NULL,
+						      (void *)sc,
+						      AR_FIRST_NDP_TIMER + 1);
+		sc->c3_timer_active = 0;
+		atomic_set(&sc->pending_tx_data_frames, 0);
+		sc->fifo_underrun = 0;
+		spin_lock_init(&sc->c3_lock);
+	}
 	return 0;
 
 err_btcoex:
@@ -755,6 +775,9 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 	    sc->sc_ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);
 
+	if (c3_war_timer && sc->c3_hw_timer)
+		ath_gen_timer_free(sc->sc_ah, sc->c3_hw_timer);
+
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1165f90..c9f1c86 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -244,6 +244,8 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
+	stop_c3_hw_timer(sc);
+
 	if (ath_startrecv(sc) != 0) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to restart recv logic\n");
@@ -617,7 +619,7 @@ void ath9k_tasklet(unsigned long data)
 		sc->ps_flags |= PS_WAIT_FOR_BEACON | PS_BEACON_SYNC;
 	}
 
-	if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
+	if (c3_war_timer || ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 		if (status & ATH9K_INT_GENTIMER)
 			ath_gen_timer_isr(sc->sc_ah);
 
@@ -854,6 +856,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
+	stop_c3_hw_timer(sc);
 	ath_update_txpow(sc);
 	if (ath_startrecv(sc) != 0) {
 		ath_print(common, ATH_DBG_FATAL,
@@ -914,6 +917,8 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
+	stop_c3_hw_timer(sc);
+
 	ath9k_hw_phy_disable(ah);
 	ath9k_hw_configpcipowersave(ah, 1, 1);
 	ath9k_ps_restore(sc);
@@ -944,6 +949,8 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 			  "Unable to reset hardware; reset status %d\n", r);
 	spin_unlock_bh(&sc->sc_resetlock);
 
+	stop_c3_hw_timer(sc);
+
 	if (ath_startrecv(sc) != 0)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to start recv logic\n");
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 457f076..77e787a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1169,6 +1169,8 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 				  "Unable to reset hardware; reset status %d\n",
 				  r);
 		spin_unlock_bh(&sc->sc_resetlock);
+
+		stop_c3_hw_timer(sc);
 	}
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
@@ -1272,6 +1274,18 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	ath_print(common, ATH_DBG_QUEUE,
 		  "qnum: %d, txq depth: %d\n", txq->axq_qnum, txq->axq_depth);
 
+	if (c3_war_timer && bf->bf_isdata &&
+			sc->fifo_underrun && sc->c3_hw_timer) {
+		spin_lock(&sc->c3_lock);
+		if (!sc->c3_timer_active) {
+			sc->c3_timer_active = 1;
+			ath9k_gen_timer_start(ah, sc->c3_hw_timer,
+					ath9k_hw_gettsf32(sc->sc_ah),
+					c3_war_timer);
+		}
+		spin_unlock(&sc->c3_lock);
+	}
+
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		if (txq->axq_depth >= ATH_TXFIFO_DEPTH) {
 			list_splice_tail_init(head, &txq->txq_fifo_pending);
@@ -1668,6 +1682,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 		return -ENOMEM;
 	}
 
+	bf->bf_isdata = ieee80211_is_data(fc);
 	bf->bf_buf_addr = bf->bf_dmacontext;
 
 	/* tag if this is a nullfunc frame to enable PS when AP acks it */
@@ -1717,6 +1732,9 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			    bf->bf_buf_addr,
 			    txctl->txq->axq_qnum);
 
+	if (c3_war_timer && bf->bf_isdata)
+		atomic_inc(&sc->pending_tx_data_frames);
+
 	if (bf->bf_state.bfs_paprd)
 		ar9003_hw_set_paprd_txdesc(ah, ds, bf->bf_state.bfs_paprd);
 
@@ -1942,6 +1960,17 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 
 	dma_unmap_single(sc->dev, bf->bf_dmacontext, skb->len, DMA_TO_DEVICE);
 
+	if (c3_war_timer && bf->bf_isdata) {
+		atomic_dec(&sc->pending_tx_data_frames);
+		spin_lock(&sc->c3_lock);
+		if (!atomic_read(&sc->pending_tx_data_frames) &&
+				sc->c3_timer_active) {
+			ath9k_gen_timer_stop(sc->sc_ah, sc->c3_hw_timer);
+			sc->c3_timer_active = false;
+		}
+		spin_unlock(&sc->c3_lock);
+	}
+
 	if (bf->bf_state.bfs_paprd) {
 		if (time_after(jiffies,
 			       bf->bf_state.bfs_paprd_timestamp +
-- 
1.6.3.3


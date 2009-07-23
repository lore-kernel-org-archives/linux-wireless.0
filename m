Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30282 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZGWKCe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:02:34 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 03:02:35 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19048.13623.675052.94639@localhost.localdomain>
Date: Thu, 23 Jul 2009 15:32:31 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/6] ath9k: Add debug counters for TX
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Location: ath9k/phy#/xmit

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/debug.c |   85 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.h |   54 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c  |   34 ++++++++-----
 4 files changed, 160 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 751885a..1308cac 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -240,7 +240,6 @@ struct ath_txq {
 	spinlock_t axq_lock;
 	u32 axq_depth;
 	u8 axq_aggr_depth;
-	u32 axq_totalqueued;
 	bool stopped;
 	bool axq_tx_inprogress;
 	struct ath_buf *axq_linkbuf;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 9f99f00..9e36920 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -486,6 +486,83 @@ static const struct file_operations fops_wiphy = {
 	.owner = THIS_MODULE
 };
 
+#define PR(str, elem)							\
+	do {								\
+		len += snprintf(buf + len, size - len,			\
+				"%s%13u%11u%10u%10u\n", str,		\
+		sc->debug.stats.txstats[sc->tx.hwq_map[ATH9K_WME_AC_BE]].elem, \
+		sc->debug.stats.txstats[sc->tx.hwq_map[ATH9K_WME_AC_BK]].elem, \
+		sc->debug.stats.txstats[sc->tx.hwq_map[ATH9K_WME_AC_VI]].elem, \
+		sc->debug.stats.txstats[sc->tx.hwq_map[ATH9K_WME_AC_VO]].elem); \
+} while(0)
+
+static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char *buf;
+	unsigned int len = 0, size = 2048;
+	ssize_t retval = 0;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return 0;
+
+	len += sprintf(buf, "%30s %10s%10s%10s\n\n", "BE", "BK", "VI", "VO");
+
+	PR("MPDUs Queued:    ", queued);
+	PR("MPDUs Completed: ", completed);
+	PR("Aggregates:      ", a_aggr);
+	PR("AMPDUs Queued:   ", a_queued);
+	PR("AMPDUs Completed:", a_completed);
+	PR("AMPDUs Retried:  ", a_retries);
+	PR("AMPDUs XRetried: ", a_xretries);
+	PR("FIFO Underrun:   ", fifo_underrun);
+	PR("TXOP Exceeded:   ", xtxop);
+	PR("TXTIMER Expiry:  ", timer_exp);
+	PR("DESC CFG Error:  ", desc_cfg_err);
+	PR("DATA Underrun:   ", data_underrun);
+	PR("DELIM Underrun:  ", delim_underrun);
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+void ath_debug_stat_tx(struct ath_softc *sc, struct ath_txq *txq,
+		       struct ath_buf *bf)
+{
+	struct ath_desc *ds = bf->bf_desc;
+
+	if (bf_isampdu(bf)) {
+		if (bf_isxretried(bf))
+			TX_STAT_INC(txq->axq_qnum, a_xretries);
+		else
+			TX_STAT_INC(txq->axq_qnum, a_completed);
+	} else {
+		TX_STAT_INC(txq->axq_qnum, completed);
+	}
+
+	if (ds->ds_txstat.ts_status & ATH9K_TXERR_FIFO)
+		TX_STAT_INC(txq->axq_qnum, fifo_underrun);
+	if (ds->ds_txstat.ts_status & ATH9K_TXERR_XTXOP)
+		TX_STAT_INC(txq->axq_qnum, xtxop);
+	if (ds->ds_txstat.ts_status & ATH9K_TXERR_TIMER_EXPIRED)
+		TX_STAT_INC(txq->axq_qnum, timer_exp);
+	if (ds->ds_txstat.ts_flags & ATH9K_TX_DESC_CFG_ERR)
+		TX_STAT_INC(txq->axq_qnum, desc_cfg_err);
+	if (ds->ds_txstat.ts_flags & ATH9K_TX_DATA_UNDERRUN)
+		TX_STAT_INC(txq->axq_qnum, data_underrun);
+	if (ds->ds_txstat.ts_flags & ATH9K_TX_DELIM_UNDERRUN)
+		TX_STAT_INC(txq->axq_qnum, delim_underrun);
+}
+
+static const struct file_operations fops_xmit = {
+	.read = read_file_xmit,
+	.open = ath9k_debugfs_open,
+	.owner = THIS_MODULE
+};
 
 int ath9k_init_debug(struct ath_softc *sc)
 {
@@ -529,6 +606,13 @@ int ath9k_init_debug(struct ath_softc *sc)
 	if (!sc->debug.debugfs_wiphy)
 		goto err;
 
+	sc->debug.debugfs_xmit = debugfs_create_file("xmit",
+						     S_IRUSR,
+						     sc->debug.debugfs_phy,
+						     sc, &fops_xmit);
+	if (!sc->debug.debugfs_xmit)
+		goto err;
+
 	return 0;
 err:
 	ath9k_exit_debug(sc);
@@ -537,6 +621,7 @@ err:
 
 void ath9k_exit_debug(struct ath_softc *sc)
 {
+	debugfs_remove(sc->debug.debugfs_xmit);
 	debugfs_remove(sc->debug.debugfs_wiphy);
 	debugfs_remove(sc->debug.debugfs_rcstat);
 	debugfs_remove(sc->debug.debugfs_interrupt);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index edda15b..970951e 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -36,6 +36,12 @@ enum ATH_DEBUG {
 #define DBG_DEFAULT (ATH_DBG_FATAL)
 
 #ifdef CONFIG_ATH9K_DEBUG
+#define TX_STAT_INC(q, c) sc->debug.stats.txstats[q].c++
+#else
+#define TX_STAT_INC(q, c) do { } while (0)
+#endif
+
+#ifdef CONFIG_ATH9K_DEBUG
 
 /**
  * struct ath_interrupt_stats - Contains statistics about interrupts
@@ -87,9 +93,45 @@ struct ath_rc_stats {
 	u8 per;
 };
 
+/**
+ * struct ath_tx_stats - Statistics about TX
+ * @queued: Total MPDUs (non-aggr) queued
+ * @completed: Total MPDUs (non-aggr) completed
+ * @a_aggr: Total no. of aggregates queued
+ * @a_queued: Total AMPDUs queued
+ * @a_completed: Total AMPDUs completed
+ * @a_retries: No. of AMPDUs retried (SW)
+ * @a_xretries: No. of AMPDUs dropped due to xretries
+ * @fifo_underrun: FIFO underrun occurrences
+	Valid only for:
+		- non-aggregate condition.
+		- first packet of aggregate.
+ * @xtxop: No. of frames filtered because of TXOP limit
+ * @timer_exp: Transmit timer expiry
+ * @desc_cfg_err: Descriptor configuration errors
+ * @data_urn: TX data underrun errors
+ * @delim_urn: TX delimiter underrun errors
+ */
+struct ath_tx_stats {
+	u32 queued;
+	u32 completed;
+	u32 a_aggr;
+	u32 a_queued;
+	u32 a_completed;
+	u32 a_retries;
+	u32 a_xretries;
+	u32 fifo_underrun;
+	u32 xtxop;
+	u32 timer_exp;
+	u32 desc_cfg_err;
+	u32 data_underrun;
+	u32 delim_underrun;
+};
+
 struct ath_stats {
 	struct ath_interrupt_stats istats;
 	struct ath_rc_stats rcstats[RATE_TABLE_SIZE];
+	struct ath_tx_stats txstats[ATH9K_NUM_TX_QUEUES];
 };
 
 struct ath9k_debug {
@@ -100,9 +142,13 @@ struct ath9k_debug {
 	struct dentry *debugfs_interrupt;
 	struct dentry *debugfs_rcstat;
 	struct dentry *debugfs_wiphy;
+	struct dentry *debugfs_xmit;
 	struct ath_stats stats;
 };
 
+struct ath_txq;
+struct ath_buf;
+
 void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...);
 int ath9k_init_debug(struct ath_softc *sc);
 void ath9k_exit_debug(struct ath_softc *sc);
@@ -110,6 +156,8 @@ int ath9k_debug_create_root(void);
 void ath9k_debug_remove_root(void);
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
 void ath_debug_stat_rc(struct ath_softc *sc, struct sk_buff *skb);
+void ath_debug_stat_tx(struct ath_softc *sc, struct ath_txq *txq,
+		       struct ath_buf *bf);
 void ath_debug_stat_retries(struct ath_softc *sc, int rix,
 			    int xretries, int retries, u8 per);
 
@@ -148,6 +196,12 @@ static inline void ath_debug_stat_rc(struct ath_softc *sc,
 {
 }
 
+static inline void ath_debug_stat_tx(struct ath_softc *sc,
+				     struct ath_txq *txq,
+				     struct ath_buf *bf)
+{
+}
+
 static inline void ath_debug_stat_retries(struct ath_softc *sc, int rix,
 					  int xretries, int retries, u8 per)
 {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c039d0a..8a8d7ed 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -59,6 +59,7 @@ static void ath_tx_send_ht_normal(struct ath_softc *sc, struct ath_txq *txq,
 				  struct ath_atx_tid *tid,
 				  struct list_head *bf_head);
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
+				struct ath_txq *txq,
 				struct list_head *bf_q,
 				int txok, int sendbar);
 static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
@@ -212,7 +213,7 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 			ath_tx_update_baw(sc, tid, bf->bf_seqno);
 
 		spin_unlock(&txq->axq_lock);
-		ath_tx_complete_buf(sc, bf, &bf_head, 0, 0);
+		ath_tx_complete_buf(sc, bf, txq, &bf_head, 0, 0);
 		spin_lock(&txq->axq_lock);
 	}
 
@@ -220,13 +221,15 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 	tid->baw_tail = tid->baw_head;
 }
 
-static void ath_tx_set_retry(struct ath_softc *sc, struct ath_buf *bf)
+static void ath_tx_set_retry(struct ath_softc *sc, struct ath_txq *txq,
+			     struct ath_buf *bf)
 {
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
 
 	bf->bf_state.bf_type |= BUF_RETRY;
 	bf->bf_retries++;
+	TX_STAT_INC(txq->axq_qnum, a_retries);
 
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -328,7 +331,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			if (!(tid->state & AGGR_CLEANUP) &&
 			    ds->ds_txstat.ts_flags != ATH9K_TX_SW_ABORTED) {
 				if (bf->bf_retries < ATH_MAX_SW_RETRIES) {
-					ath_tx_set_retry(sc, bf);
+					ath_tx_set_retry(sc, txq, bf);
 					txpending = 1;
 				} else {
 					bf->bf_state.bf_type |= BUF_XRETRY;
@@ -375,7 +378,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				ath_tx_rc_status(bf, ds, nbad, txok, false);
 			}
 
-			ath_tx_complete_buf(sc, bf, &bf_head, !txfail, sendbar);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, !txfail, sendbar);
 		} else {
 			/* retry the un-acked ones */
 			if (bf->bf_next == NULL && bf_last->bf_stale) {
@@ -395,8 +398,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 					bf->bf_state.bf_type |= BUF_XRETRY;
 					ath_tx_rc_status(bf, ds, nbad,
 							 0, false);
-					ath_tx_complete_buf(sc, bf, &bf_head,
-							    0, 0);
+					ath_tx_complete_buf(sc, bf, txq,
+							    &bf_head, 0, 0);
 					break;
 				}
 
@@ -573,6 +576,7 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 }
 
 static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
+					     struct ath_txq *txq,
 					     struct ath_atx_tid *tid,
 					     struct list_head *bf_q)
 {
@@ -637,6 +641,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 			bf_prev->bf_desc->ds_link = bf->bf_daddr;
 		}
 		bf_prev = bf;
+
 	} while (!list_empty(&tid->buf_q));
 
 	bf_first->bf_al = al;
@@ -659,7 +664,7 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 		INIT_LIST_HEAD(&bf_q);
 
-		status = ath_tx_form_aggr(sc, tid, &bf_q);
+		status = ath_tx_form_aggr(sc, txq, tid, &bf_q);
 
 		/*
 		 * no frames picked up to be aggregated;
@@ -690,6 +695,7 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 		txq->axq_aggr_depth++;
 		ath_tx_txqaddbuf(sc, txq, &bf_q);
+		TX_STAT_INC(txq->axq_qnum, a_aggr);
 
 	} while (txq->axq_depth < ATH_AGGR_MIN_QDEPTH &&
 		 status != ATH_AGGR_BAW_CLOSED);
@@ -746,7 +752,7 @@ int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 		}
 		list_move_tail(&bf->list, &bf_head);
 		ath_tx_update_baw(sc, txtid, bf->bf_seqno);
-		ath_tx_complete_buf(sc, bf, &bf_head, 0, 0);
+		ath_tx_complete_buf(sc, bf, txq, &bf_head, 0, 0);
 	}
 	spin_unlock_bh(&txq->axq_lock);
 
@@ -870,7 +876,6 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		spin_lock_init(&txq->axq_lock);
 		txq->axq_depth = 0;
 		txq->axq_aggr_depth = 0;
-		txq->axq_totalqueued = 0;
 		txq->axq_linkbuf = NULL;
 		txq->axq_tx_inprogress = false;
 		sc->tx.txqsetup |= 1<<qnum;
@@ -1036,7 +1041,7 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 		if (bf_isampdu(bf))
 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, 0);
 		else
-			ath_tx_complete_buf(sc, bf, &bf_head, 0, 0);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, 0, 0);
 	}
 
 	spin_lock_bh(&txq->axq_lock);
@@ -1187,7 +1192,6 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 
 	list_splice_tail_init(head, &txq->axq_q);
 	txq->axq_depth++;
-	txq->axq_totalqueued++;
 	txq->axq_linkbuf = list_entry(txq->axq_q.prev, struct ath_buf, list);
 
 	DPRINTF(sc, ATH_DBG_QUEUE,
@@ -1235,6 +1239,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 
 	bf = list_first_entry(bf_head, struct ath_buf, list);
 	bf->bf_state.bf_type |= BUF_AMPDU;
+	TX_STAT_INC(txctl->txq->axq_qnum, a_queued);
 
 	/*
 	 * Do not queue to h/w when any of the following conditions is true:
@@ -1281,6 +1286,7 @@ static void ath_tx_send_ht_normal(struct ath_softc *sc, struct ath_txq *txq,
 	bf->bf_lastbf = bf;
 	ath_buf_set_rate(sc, bf);
 	ath_tx_txqaddbuf(sc, txq, bf_head);
+	TX_STAT_INC(txq->axq_qnum, queued);
 }
 
 static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
@@ -1294,6 +1300,7 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 	bf->bf_nframes = 1;
 	ath_buf_set_rate(sc, bf);
 	ath_tx_txqaddbuf(sc, txq, bf_head);
+	TX_STAT_INC(txq->axq_qnum, queued);
 }
 
 static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
@@ -1819,6 +1826,7 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 }
 
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
+				struct ath_txq *txq,
 				struct list_head *bf_q,
 				int txok, int sendbar)
 {
@@ -1826,7 +1834,6 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	unsigned long flags;
 	int tx_flags = 0;
 
-
 	if (sendbar)
 		tx_flags = ATH_TX_BAR;
 
@@ -1839,6 +1846,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 
 	dma_unmap_single(sc->dev, bf->bf_dmacontext, skb->len, DMA_TO_DEVICE);
 	ath_tx_complete(sc, skb, tx_flags);
+	ath_debug_stat_tx(sc, txq, bf);
 
 	/*
 	 * Return the list of ath_buf of this mpdu to free queue
@@ -2026,7 +2034,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		if (bf_isampdu(bf))
 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, txok);
 		else
-			ath_tx_complete_buf(sc, bf, &bf_head, txok, 0);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, txok, 0);
 
 		ath_wake_mac80211_queue(sc, txq);
 
-- 
1.6.3.3


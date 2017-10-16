Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:42773 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754401AbdJPQJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 12:09:27 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH 2/2] mac80211: Add airtime accounting and scheduling to TXQs
Date: Mon, 16 Oct 2017 18:09:02 +0200
Message-Id: <20171016160902.8970-2-toke@toke.dk> (sfid-20171016_180933_942626_9939A5C5)
In-Reply-To: <20171016160902.8970-1-toke@toke.dk>
References: <20171016160902.8970-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds airtime accounting and scheduling to the mac80211 TXQ scheduler. A new
hardware flag, AIRTIME_ACCOUNTING, is added that drivers can set if they support
reporting airtime usage of transmissions. When this flag is set, mac80211 will
expect the actual airtime usage to be reported in the tx_time and rx_time fields
of the respective status structs.

When airtime information is present, mac80211 will schedule TXQs (through
ieee80211_next_txq()) in a way that enforces airtime fairness between active
stations. This scheduling works the same way as the ath9k in-driver airtime
fairness scheduling, which is then removed.

Only ath9k currently sets the AIRTIME_ACCOUNTING flag.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
Changes since the RFC:

- Don't try to calculate airtime usage in mac80211; instead, add a field to
  struct ieee80211_rx_status for the driver to fill in.
- Fold ath9k patch into this patch, and remove all the airtime bits from
  ath9k apart from the actual airtime accounting.
- Feature parity with the ath9k scheduler (in particular, the old/new
  station optimisation is retained).
- Add explicit hardware flag for the driver to signal that it supports
  airtime accounting and wants the scheduling.
- This has actually been tested... :)

 drivers/net/wireless/ath/ath9k/ath9k.h     |  7 +---
 drivers/net/wireless/ath/ath9k/debug.h     |  8 -----
 drivers/net/wireless/ath/ath9k/debug_sta.c | 54 ------------------------------
 drivers/net/wireless/ath/ath9k/init.c      |  4 +--
 drivers/net/wireless/ath/ath9k/recv.c      | 11 ++----
 drivers/net/wireless/ath/ath9k/xmit.c      | 21 ++++--------
 include/net/mac80211.h                     |  6 ++++
 net/mac80211/debugfs.c                     |  1 +
 net/mac80211/debugfs_sta.c                 | 29 ++++++++++++++++
 net/mac80211/ieee80211_i.h                 |  6 +++-
 net/mac80211/main.c                        |  3 +-
 net/mac80211/rx.c                          |  9 +++++
 net/mac80211/sta_info.c                    |  2 ++
 net/mac80211/sta_info.h                    |  7 ++++
 net/mac80211/status.c                      | 15 +++++++++
 net/mac80211/tx.c                          | 28 +++++++++++++---
 16 files changed, 112 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f6c53df78856..f6e8f9b1b984 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -112,8 +112,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_TXFIFO_DEPTH           8
 #define ATH_TX_ERROR               0x01
 
-#define ATH_AIRTIME_QUANTUM        300 /* usec */
-
 /* Stop tx traffic 1ms before the GO goes away */
 #define ATH_P2P_PS_STOP_TIME       1000
 
@@ -215,6 +213,7 @@ struct ath_buf_state {
 	bool stale;
 	u16 seqno;
 	unsigned long bfs_paprd_timestamp;
+	u32 airtime;
 };
 
 struct ath_buf {
@@ -262,12 +261,9 @@ struct ath_node {
 
 	bool sleeping;
 	bool no_ps_filter;
-	s64 airtime_deficit[IEEE80211_NUM_ACS];
-	u32 airtime_rx_start;
 
 #ifdef CONFIG_ATH9K_STATION_STATISTICS
 	struct ath_rx_rate_stats rx_rate_stats;
-	struct ath_airtime_stats airtime_stats;
 #endif
 	u8 key_idx[4];
 
@@ -986,7 +982,6 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
 
 #define AIRTIME_USE_TX		BIT(0)
 #define AIRTIME_USE_RX		BIT(1)
-#define AIRTIME_USE_NEW_QUEUES	BIT(2)
 #define AIRTIME_ACTIVE(flags) (!!(flags & (AIRTIME_USE_TX|AIRTIME_USE_RX)))
 
 struct ath_softc {
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 249f8141cd00..559d9628f280 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -319,20 +319,12 @@ ath9k_debug_sync_cause(struct ath_softc *sc, u32 sync_cause)
 void ath_debug_rate_stats(struct ath_softc *sc,
 			  struct ath_rx_status *rs,
 			  struct sk_buff *skb);
-void ath_debug_airtime(struct ath_softc *sc,
-		       struct ath_node *an,
-		       u32 rx, u32 tx);
 #else
 static inline void ath_debug_rate_stats(struct ath_softc *sc,
 					struct ath_rx_status *rs,
 					struct sk_buff *skb)
 {
 }
-static inline void ath_debug_airtime(struct ath_softc *sc,
-			      struct ath_node *an,
-			      u32 rx, u32 tx)
-{
-}
 #endif /* CONFIG_ATH9K_STATION_STATISTICS */
 
 #endif /* DEBUG_H */
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index efc692ee67d4..89ba95287a8b 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -242,59 +242,6 @@ static const struct file_operations fops_node_recv = {
 	.llseek = default_llseek,
 };
 
-void ath_debug_airtime(struct ath_softc *sc,
-		struct ath_node *an,
-		u32 rx,
-		u32 tx)
-{
-	struct ath_airtime_stats *astats = &an->airtime_stats;
-
-	astats->rx_airtime += rx;
-	astats->tx_airtime += tx;
-}
-
-static ssize_t read_airtime(struct file *file, char __user *user_buf,
-			size_t count, loff_t *ppos)
-{
-	struct ath_node *an = file->private_data;
-	struct ath_airtime_stats *astats;
-	static const char *qname[4] = {
-		"VO", "VI", "BE", "BK"
-	};
-	u32 len = 0, size = 256;
-	char *buf;
-	size_t retval;
-	int i;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	astats = &an->airtime_stats;
-
-	len += scnprintf(buf + len, size - len, "RX: %u us\n", astats->rx_airtime);
-	len += scnprintf(buf + len, size - len, "TX: %u us\n", astats->tx_airtime);
-	len += scnprintf(buf + len, size - len, "Deficit: ");
-	for (i = 0; i < 4; i++)
-		len += scnprintf(buf+len, size - len, "%s: %lld us ", qname[i], an->airtime_deficit[i]);
-	if (len < size)
-		buf[len++] = '\n';
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-}
-
-
-static const struct file_operations fops_airtime = {
-	.read = read_airtime,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
-
 void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 			   struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta,
@@ -304,5 +251,4 @@ void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 
 	debugfs_create_file("node_aggr", S_IRUGO, dir, an, &fops_node_aggr);
 	debugfs_create_file("node_recv", S_IRUGO, dir, an, &fops_node_recv);
-	debugfs_create_file("airtime", S_IRUGO, dir, an, &fops_airtime);
 }
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index bb7936090b91..b4c6fc49b19e 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -620,8 +620,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 
 	/* Will be cleared in ath9k_start() */
 	set_bit(ATH_OP_INVALID, &common->op_flags);
-	sc->airtime_flags = (AIRTIME_USE_TX | AIRTIME_USE_RX |
-			     AIRTIME_USE_NEW_QUEUES);
+	sc->airtime_flags = (AIRTIME_USE_TX | AIRTIME_USE_RX);
 
 	sc->sc_ah = ah;
 	sc->dfs_detector = dfs_pattern_detector_init(common, NL80211_DFS_UNSET);
@@ -873,6 +872,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
+	ieee80211_hw_set(hw, AIRTIME_ACCOUNTING);
 
 	if (ath9k_ps_enable)
 		ieee80211_hw_set(hw, SUPPORTS_PS);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 2197aee2bb72..e77e5c839abc 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1054,14 +1054,9 @@ static void ath_rx_count_airtime(struct ath_softc *sc,
 						len, rxs->rate_idx, is_sp);
 	}
 
- 	if (!!(sc->airtime_flags & AIRTIME_USE_RX)) {
-		spin_lock_bh(&acq->lock);
-		an->airtime_deficit[acno] -= airtime;
-		if (an->airtime_deficit[acno] <= 0)
-			__ath_tx_queue_tid(sc, ATH_AN_2_TID(an, tidno));
-		spin_unlock_bh(&acq->lock);
-	}
-	ath_debug_airtime(sc, an, airtime, 0);
+ 	if (sc->airtime_flags & AIRTIME_USE_RX)
+		rxs->rx_time = min_t(u32, 0xffff, airtime);
+
 exit:
 	rcu_read_unlock();
 }
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 4256701500ff..86b1d21b237e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -638,11 +638,9 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
     return bf_isampdu(bf) && !(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
 }
 
-static void ath_tx_count_airtime(struct ath_softc *sc, struct ath_node *an,
-				 struct ath_atx_tid *tid, struct ath_buf *bf,
+static void ath_tx_count_airtime(struct ath_softc *sc, struct ath_buf *bf,
 				 struct ath_tx_status *ts)
 {
-	struct ath_txq *txq = tid->txq;
 	u32 airtime = 0;
 	int i;
 
@@ -652,15 +650,9 @@ static void ath_tx_count_airtime(struct ath_softc *sc, struct ath_node *an,
 		airtime += rate_dur * bf->rates[i].count;
 	}
 
-	if (sc->airtime_flags & AIRTIME_USE_TX) {
-		int q = txq->mac80211_qnum;
-		struct ath_acq *acq = &sc->cur_chan->acq[q];
+	if (sc->airtime_flags & AIRTIME_USE_TX)
+		bf->bf_state.airtime = airtime;
 
-		spin_lock_bh(&acq->lock);
-		an->airtime_deficit[q] -= airtime;
-		spin_unlock_bh(&acq->lock);
-	}
-	ath_debug_airtime(sc, an, 0, airtime);
 }
 
 static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
@@ -690,7 +682,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	if (sta) {
 		struct ath_node *an = (struct ath_node *)sta->drv_priv;
 		tid = ath_get_skb_tid(sc, an, bf->bf_mpdu);
-		ath_tx_count_airtime(sc, an, tid, bf, ts);
+		ath_tx_count_airtime(sc, bf, ts);
 		if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 			tid->clear_ps_filter = true;
 	}
@@ -2425,6 +2417,8 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	if (ts->ts_status & ATH9K_TXERR_FILT)
 		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 
+	tx_info->status.tx_time = min_t(u32, 0xffff, bf->bf_state.airtime);
+
 	dma_unmap_single(sc->dev, bf->bf_buf_addr, skb->len, DMA_TO_DEVICE);
 	bf->bf_buf_addr = 0;
 	if (sc->tx99_state)
@@ -2751,9 +2745,6 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	struct ath_atx_tid *tid;
 	int tidno, acno;
 
-	for (acno = 0; acno < IEEE80211_NUM_ACS; acno++)
-		an->airtime_deficit[acno] = ATH_AIRTIME_QUANTUM;
-
 	for (tidno = 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
 		tid = ath_node_to_tid(an, tidno);
 		tid->an        = an;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f0373dd3d714..2bedd361511b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1202,6 +1202,7 @@ struct ieee80211_rx_status {
 	u32 device_timestamp;
 	u32 ampdu_reference;
 	u32 flag;
+	u16 rx_time;
 	u16 freq;
 	u8 enc_flags;
 	u8 encoding:2, bw:3;
@@ -2059,6 +2060,10 @@ struct ieee80211_txq {
  *	The stack will not do fragmentation.
  *	The callback for @set_frag_threshold should be set as well.
  *
+ * @IEEE80211_HW_AIRTIME_ACCOUNTING: Hardware supports accounting the airtime
+ *      usage of other stations and reports it in the @tx_time and/or @rx_time
+ *      fields of the TX/RX status structs.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2101,6 +2106,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_FRAG_LIST,
 	IEEE80211_HW_REPORTS_LOW_ACK,
 	IEEE80211_HW_SUPPORTS_TX_FRAG,
+	IEEE80211_HW_AIRTIME_ACCOUNTING,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 5fae001f286c..20e3aa0e8464 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -211,6 +211,7 @@ static const char *hw_flag_names[] = {
 	FLAG(TX_FRAG_LIST),
 	FLAG(REPORTS_LOW_ACK),
 	FLAG(SUPPORTS_TX_FRAG),
+	FLAG(AIRTIME_ACCOUNTING),
 #undef FLAG
 };
 
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index b15412c21ac9..57bc6b544f0e 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -188,6 +188,32 @@ static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
 }
 STA_OPS(aqm);
 
+static ssize_t sta_airtime_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	size_t bufsz = 200;
+	char *buf = kzalloc(bufsz, GFP_KERNEL), *p = buf;
+	ssize_t rv;
+
+	if (!buf)
+		return -ENOMEM;
+
+	spin_lock_bh(&sta->lock);
+
+	p += scnprintf(p, bufsz+buf-p,
+		"RX: %llu us\nTX: %llu us\nDeficit: %lld us\n",
+		sta->airtime_stats.rx_airtime,
+		sta->airtime_stats.tx_airtime,
+		sta->airtime_deficit);
+
+	spin_unlock_bh(&sta->lock);
+	rv = simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+	kfree(buf);
+	return rv;
+}
+STA_OPS(airtime);
+
 static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 					size_t count, loff_t *ppos)
 {
@@ -542,6 +568,9 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	if (local->ops->wake_tx_queue)
 		DEBUGFS_ADD(aqm);
 
+	if (ieee80211_hw_check(&local->hw, AIRTIME_ACCOUNTING))
+		DEBUGFS_ADD(airtime);
+
 	if (sizeof(sta->driver_buffered_tids) == sizeof(u32))
 		debugfs_create_x32("driver_buffered_tids", 0400,
 				   sta->debugfs_dir,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 48bf933435a8..7f6fe5285813 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -90,6 +90,9 @@ extern const u8 ieee80211_ac_to_qos_mask[IEEE80211_NUM_ACS];
 
 #define IEEE80211_MAX_NAN_INSTANCE_ID 255
 
+/* How much to increase airtime deficit on each scheduling round */
+#define IEEE80211_AIRTIME_QUANTUM        1000 /* usec */
+
 struct ieee80211_fragment_entry {
 	struct sk_buff_head skb_list;
 	unsigned long first_frag_time;
@@ -1122,7 +1125,8 @@ struct ieee80211_local {
 	struct codel_vars *cvars;
 	struct codel_params cparams;
 
-	struct list_head active_txqs;
+	struct list_head active_txqs_new;
+	struct list_head active_txqs_old;
 	spinlock_t active_txq_lock;
 
 	const struct ieee80211_ops *ops;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 9ad0556aa24b..acf73c398d9b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -616,7 +616,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	spin_lock_init(&local->rx_path_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
-	INIT_LIST_HEAD(&local->active_txqs);
+	INIT_LIST_HEAD(&local->active_txqs_new);
+	INIT_LIST_HEAD(&local->active_txqs_old);
 	spin_lock_init(&local->active_txq_lock);
 
 	INIT_LIST_HEAD(&local->chanctx_list);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 70e9d2ca8bbe..14cc1a5902a7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1637,6 +1637,15 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	if (ieee80211_vif_is_mesh(&rx->sdata->vif))
 		ieee80211_mps_rx_h_sta_process(sta, hdr);
 
+	/* airtime accounting */
+	if (ieee80211_hw_check(&sta->local->hw, AIRTIME_ACCOUNTING) &&
+	    status->rx_time) {
+		spin_lock_bh(&sta->lock);
+		sta->airtime_stats.rx_airtime += status->rx_time;
+		sta->airtime_deficit -= status->rx_time;
+		spin_unlock_bh(&sta->lock);
+	}
+
 	/*
 	 * Drop (qos-)data::nullfunc frames silently, since they
 	 * are used only to control station power saving mode.
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5db76db6bfc8..51fe010af20e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -433,6 +433,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->cparams.interval = MS2TIME(100);
 	sta->cparams.ecn = true;
 
+	sta->airtime_deficit = IEEE80211_AIRTIME_QUANTUM;
+
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
 
 	return sta;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5c54acd10562..5d1802f22550 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -550,6 +550,13 @@ struct sta_info {
 	} tx_stats;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
 
+	/* Airtime stats and deficit, protected by lock */
+	struct {
+		u64 rx_airtime;
+		u64 tx_airtime;
+	} airtime_stats;
+	s64 airtime_deficit;
+
 	/*
 	 * Aggregation information, locked with lock.
 	 */
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index da7427a41529..2f1111532be0 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -823,6 +823,13 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 				ieee80211_lost_packet(sta, info);
 			}
 		}
+
+		if (info->status.tx_time) {
+			spin_lock_bh(&sta->lock);
+			sta->airtime_stats.tx_airtime += info->status.tx_time;
+			sta->airtime_deficit -= info->status.tx_time;
+			spin_unlock_bh(&sta->lock);
+		}
 	}
 
 	/* SNMP counters
@@ -947,6 +954,14 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 			sta->status_stats.retry_failed++;
 		sta->status_stats.retry_count += retry_count;
 
+		if (ieee80211_hw_check(&local->hw, AIRTIME_ACCOUNTING) &&
+		    info->status.tx_time) {
+			spin_lock_bh(&sta->lock);
+			sta->airtime_stats.tx_airtime += info->status.tx_time;
+			sta->airtime_deficit -= info->status.tx_time;
+			spin_unlock_bh(&sta->lock);
+		}
+
 		if (acked) {
 			sta->status_stats.last_ack = jiffies;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0ee6ea71d1c4..937d48a1ba7a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3530,7 +3530,7 @@ bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
 	spin_lock_bh(&local->active_txq_lock);
 
 	if (list_empty(&txqi->schedule_order)) {
-		list_add_tail(&txqi->schedule_order, &local->active_txqs);
+		list_add_tail(&txqi->schedule_order, &local->active_txqs_new);
 		ret = 1;
 	}
 
@@ -3544,13 +3544,33 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct txq_info *txqi = NULL;
+	struct list_head *head;
 
 	spin_lock_bh(&local->active_txq_lock);
 
-	if (list_empty(&local->active_txqs))
-		goto out;
+begin:
+	head = &local->active_txqs_new;
+	if (list_empty(head)) {
+		head = &local->active_txqs_old;
+		if (list_empty(head))
+			goto out;
+	}
+
+	txqi = list_first_entry(head, struct txq_info, schedule_order);
+
+	if (txqi->txq.sta) {
+		struct sta_info *sta = container_of(txqi->txq.sta, struct sta_info, sta);
+
+		spin_lock_bh(&sta->lock);
+		if (sta->airtime_deficit < 0) {
+			sta->airtime_deficit += IEEE80211_AIRTIME_QUANTUM;
+			list_move_tail(&txqi->schedule_order, &local->active_txqs_old);
+			spin_unlock_bh(&sta->lock);
+			goto begin;
+		}
+		spin_unlock_bh(&sta->lock);
+	}
 
-	txqi = list_first_entry(&local->active_txqs, struct txq_info, schedule_order);
 	list_del_init(&txqi->schedule_order);
 
 out:
-- 
2.14.2

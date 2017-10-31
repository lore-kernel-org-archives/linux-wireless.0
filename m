Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:36699 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751608AbdJaL15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 07:27:57 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v3 3/3] ath9k: Switch to mac80211 airtime API
Date: Tue, 31 Oct 2017 12:27:47 +0100
Message-Id: <20171031112747.5778-3-toke@toke.dk> (sfid-20171031_122835_770520_63DC38D4)
In-Reply-To: <20171031112747.5778-1-toke@toke.dk>
References: <20171031112747.5778-1-toke@toke.dk>
In-Reply-To: <20171027141451.22768-1-toke@toke.dk>
References: <20171027141451.22768-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the in-driver airtime fairness scheduling from ath9k and
switches the driver to use the API introduced in mac80211 in the
previous commit.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath9k/ath9k.h     |  7 +---
 drivers/net/wireless/ath/ath9k/debug.h     |  8 -----
 drivers/net/wireless/ath/ath9k/debug_sta.c | 54 ------------------------------
 drivers/net/wireless/ath/ath9k/init.c      |  4 +--
 drivers/net/wireless/ath/ath9k/recv.c      |  9 ++---
 drivers/net/wireless/ath/ath9k/xmit.c      | 21 ++++--------
 6 files changed, 12 insertions(+), 91 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a5088792b769..7c7dece6cb91 100644
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
@@ -259,12 +258,9 @@ struct ath_node {
 
 	bool sleeping;
 	bool no_ps_filter;
-	s64 airtime_deficit[IEEE80211_NUM_ACS];
-	u32 airtime_rx_start;
 
 #ifdef CONFIG_ATH9K_STATION_STATISTICS
 	struct ath_rx_rate_stats rx_rate_stats;
-	struct ath_airtime_stats airtime_stats;
 #endif
 	u8 key_idx[4];
 
@@ -983,7 +979,6 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
 
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
index a768e841524d..69a4ba5d4013 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1054,12 +1054,9 @@ static void ath_rx_count_airtime(struct ath_softc *sc,
 						len, rxs->rate_idx, is_sp);
 	}
 
- 	if (!!(sc->airtime_flags & AIRTIME_USE_RX)) {
-		spin_lock_bh(&acq->lock);
-		an->airtime_deficit[acno] -= airtime;
-		spin_unlock_bh(&acq->lock);
-	}
-	ath_debug_airtime(sc, an, airtime, 0);
+	if (!!(sc->airtime_flags & AIRTIME_USE_RX))
+		rxs->airtime = airtime;
+
 exit:
 	rcu_read_unlock();
 }
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index bd438062a6db..5ffd44a4b3de 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -640,11 +640,9 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
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
 
@@ -654,15 +652,9 @@ static void ath_tx_count_airtime(struct ath_softc *sc, struct ath_node *an,
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
@@ -692,7 +684,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	if (sta) {
 		struct ath_node *an = (struct ath_node *)sta->drv_priv;
 		tid = ath_get_skb_tid(sc, an, bf->bf_mpdu);
-		ath_tx_count_airtime(sc, an, tid, bf, ts);
+		ath_tx_count_airtime(sc, bf, ts);
 		if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 			tid->clear_ps_filter = true;
 	}
@@ -2428,6 +2420,8 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	if (ts->ts_status & ATH9K_TXERR_FILT)
 		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 
+	tx_info->status.tx_time = min_t(u32, 0xffff, bf->bf_state.airtime);
+
 	dma_unmap_single(sc->dev, bf->bf_buf_addr, skb->len, DMA_TO_DEVICE);
 	bf->bf_buf_addr = 0;
 	if (sc->tx99_state)
@@ -2754,9 +2748,6 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	struct ath_atx_tid *tid;
 	int tidno, acno;
 
-	for (acno = 0; acno < IEEE80211_NUM_ACS; acno++)
-		an->airtime_deficit[acno] = ATH_AIRTIME_QUANTUM;
-
 	for (tidno = 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
 		tid = ath_node_to_tid(an, tidno);
 		tid->an        = an;
-- 
2.14.3

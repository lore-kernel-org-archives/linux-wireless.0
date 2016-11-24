Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:41117 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964862AbcKXNzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 08:55:45 -0500
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v2] ath9k: Introduce airtime fairness scheduling between stations
Date: Thu, 24 Nov 2016 14:54:55 +0100
Message-Id: <20161124135455.29327-1-toke@toke.dk> (sfid-20161124_145549_809018_E902B068)
In-Reply-To: <20160617090929.31606-1-toke@toke.dk>
References: <20160617090929.31606-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reworks the ath9k driver to schedule transmissions to connected
stations in a way that enforces airtime fairness between them. It
accomplishes this by measuring the time spent transmitting to or
receiving from a station at TX and RX completion, and accounting this to
a per-station, per-QoS level airtime deficit. Then, an FQ-CoDel based
deficit scheduler is employed at packet dequeue time, to control which
station gets the next transmission opportunity.

Airtime fairness can significantly improve the efficiency of the network
when station rates vary. The following throughput values are from a
simple three-station test scenario, where two stations operate at the
highest HT20 rate, and one station at the lowest, and the scheduler is
employed at the access point:

                  Before   /   After
Fast station 1:    19.17   /   25.09 Mbps
Fast station 2:    19.83   /   25.21 Mbps
Slow station:       2.58   /    1.77 Mbps
Total:             41.58   /   52.07 Mbps

The benefit of airtime fairness goes up the more stations are present.
In a 30-station test with one station artificially limited to 1 Mbps,
we have seen aggregate throughput go from 2.14 to 17.76 Mbps.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath9k/ath9k.h     |  28 ++++-
 drivers/net/wireless/ath/ath9k/channel.c   |  26 ++++-
 drivers/net/wireless/ath/ath9k/debug.c     |   3 +
 drivers/net/wireless/ath/ath9k/debug.h     |  13 +++
 drivers/net/wireless/ath/ath9k/debug_sta.c |  54 +++++++++
 drivers/net/wireless/ath/ath9k/init.c      |   2 +
 drivers/net/wireless/ath/ath9k/main.c      |   6 +-
 drivers/net/wireless/ath/ath9k/recv.c      |  65 +++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c      | 177 +++++++++++++++++++++--------
 9 files changed, 318 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 378d345..d16f430 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -112,6 +112,8 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_TXFIFO_DEPTH           8
 #define ATH_TX_ERROR               0x01
 
+#define ATH_AIRTIME_QUANTUM        300 /* usec */
+
 /* Stop tx traffic 1ms before the GO goes away */
 #define ATH_P2P_PS_STOP_TIME       1000
 
@@ -247,6 +249,9 @@ struct ath_atx_tid {
 	bool has_queued;
 };
 
+void __ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid);
+void ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid);
+
 struct ath_node {
 	struct ath_softc *sc;
 	struct ieee80211_sta *sta; /* station struct we're part of */
@@ -258,9 +263,12 @@ struct ath_node {
 
 	bool sleeping;
 	bool no_ps_filter;
+	s64 airtime_deficit[IEEE80211_NUM_ACS];
+	u32 airtime_rx_start;
 
 #ifdef CONFIG_ATH9K_STATION_STATISTICS
 	struct ath_rx_rate_stats rx_rate_stats;
+	struct ath_airtime_stats airtime_stats;
 #endif
 	u8 key_idx[4];
 
@@ -317,10 +325,16 @@ struct ath_rx {
 /* Channel Context */
 /*******************/
 
+struct ath_acq {
+	struct list_head acq_new;
+	struct list_head acq_old;
+	spinlock_t lock;
+};
+
 struct ath_chanctx {
 	struct cfg80211_chan_def chandef;
 	struct list_head vifs;
-	struct list_head acq[IEEE80211_NUM_ACS];
+	struct ath_acq acq[IEEE80211_NUM_ACS];
 	int hw_queue_base;
 
 	/* do not dereference, use for comparison only */
@@ -443,6 +457,9 @@ void ath_chanctx_init(struct ath_softc *sc);
 void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 			     struct cfg80211_chan_def *chandef);
 
+void ath_acq_lock(struct ath_softc *sc, struct ath_acq *acq);
+void ath_acq_unlock(struct ath_softc *sc, struct ath_acq *acq);
+
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 
 static inline struct ath_chanctx *
@@ -575,6 +592,8 @@ void ath_txq_schedule_all(struct ath_softc *sc);
 int ath_tx_init(struct ath_softc *sc, int nbufs);
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *q);
+u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, int pktlen,
+		     int width, int half_gi, bool shortPreamble);
 void ath_update_max_aggr_framelen(struct ath_softc *sc, int queue, int txop);
 void ath_assign_seq(struct ath_common *common, struct sk_buff *skb);
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
@@ -963,6 +982,11 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
 
 #define ATH9K_NUM_CHANCTX  2 /* supports 2 operating channels */
 
+#define AIRTIME_USE_TX		BIT(0)
+#define AIRTIME_USE_RX		BIT(1)
+#define AIRTIME_USE_NEW_QUEUES	BIT(2)
+#define AIRTIME_ACTIVE(flags) (!!(flags & (AIRTIME_USE_TX|AIRTIME_USE_RX)))
+
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
@@ -1005,6 +1029,8 @@ struct ath_softc {
 	short nbcnvifs;
 	unsigned long ps_usecount;
 
+	u16 airtime_flags; /* AIRTIME_* */
+
 	struct ath_rx rx;
 	struct ath_tx tx;
 	struct ath_beacon beacon;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 929dd70..5d4d682 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -118,8 +118,11 @@ void ath_chanctx_init(struct ath_softc *sc)
 		INIT_LIST_HEAD(&ctx->vifs);
 		ctx->txpower = ATH_TXPOWER_MAX;
 		ctx->flush_timeout = HZ / 5; /* 200ms */
-		for (j = 0; j < ARRAY_SIZE(ctx->acq); j++)
-			INIT_LIST_HEAD(&ctx->acq[j]);
+		for (j = 0; j < ARRAY_SIZE(ctx->acq); j++) {
+			INIT_LIST_HEAD(&ctx->acq[j].acq_new);
+			INIT_LIST_HEAD(&ctx->acq[j].acq_old);
+			spin_lock_init(&ctx->acq[j].lock);
+		}
 	}
 }
 
@@ -144,6 +147,18 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 	ath_set_channel(sc);
 }
 
+void ath_acq_lock(struct ath_softc *sc, struct ath_acq *acq)
+	__acquires(&acq->lock)
+{
+	spin_lock_bh(&acq->lock);
+}
+
+void ath_acq_unlock(struct ath_softc *sc, struct ath_acq *acq)
+	__releases(&acq->lock)
+{
+	spin_unlock_bh(&acq->lock);
+}
+
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 
 /*************/
@@ -1345,8 +1360,11 @@ void ath9k_offchannel_init(struct ath_softc *sc)
 	ctx->txpower = ATH_TXPOWER_MAX;
 	cfg80211_chandef_create(&ctx->chandef, chan, NL80211_CHAN_HT20);
 
-	for (i = 0; i < ARRAY_SIZE(ctx->acq); i++)
-		INIT_LIST_HEAD(&ctx->acq[i]);
+	for (i = 0; i < ARRAY_SIZE(ctx->acq); i++) {
+		INIT_LIST_HEAD(&ctx->acq[i].acq_new);
+		INIT_LIST_HEAD(&ctx->acq[i].acq_old);
+		spin_lock_init(&ctx->acq[i].lock);
+	}
 
 	sc->offchannel.chan.offchannel = true;
 }
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 89a94dd..43930c3 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1399,5 +1399,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_file("tpc", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc, &fops_tpc);
 
+	debugfs_create_u16("airtime_flags", S_IRUSR | S_IWUSR,
+			   sc->debug.debugfs_phy, &sc->airtime_flags);
+
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index a078cdd..249f814 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -221,6 +221,11 @@ struct ath_rx_rate_stats {
 	} cck_stats[4];
 };
 
+struct ath_airtime_stats {
+	u32 rx_airtime;
+	u32 tx_airtime;
+};
+
 #define ANT_MAIN 0
 #define ANT_ALT  1
 
@@ -314,12 +319,20 @@ ath9k_debug_sync_cause(struct ath_softc *sc, u32 sync_cause)
 void ath_debug_rate_stats(struct ath_softc *sc,
 			  struct ath_rx_status *rs,
 			  struct sk_buff *skb);
+void ath_debug_airtime(struct ath_softc *sc,
+		       struct ath_node *an,
+		       u32 rx, u32 tx);
 #else
 static inline void ath_debug_rate_stats(struct ath_softc *sc,
 					struct ath_rx_status *rs,
 					struct sk_buff *skb)
 {
 }
+static inline void ath_debug_airtime(struct ath_softc *sc,
+			      struct ath_node *an,
+			      u32 rx, u32 tx)
+{
+}
 #endif /* CONFIG_ATH9K_STATION_STATISTICS */
 
 #endif /* DEBUG_H */
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index 2a3a3c4..524cbf13 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -242,6 +242,59 @@ static const struct file_operations fops_node_recv = {
 	.llseek = default_llseek,
 };
 
+void ath_debug_airtime(struct ath_softc *sc,
+		struct ath_node *an,
+		u32 rx,
+		u32 tx)
+{
+	struct ath_airtime_stats *astats = &an->airtime_stats;
+
+	astats->rx_airtime += rx;
+	astats->tx_airtime += tx;
+}
+
+static ssize_t read_airtime(struct file *file, char __user *user_buf,
+			size_t count, loff_t *ppos)
+{
+	struct ath_node *an = file->private_data;
+	struct ath_airtime_stats *astats;
+	static const char *qname[4] = {
+		"VO", "VI", "BE", "BK"
+	};
+	u32 len = 0, size = 256;
+	char *buf;
+	size_t retval;
+	int i;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	astats = &an->airtime_stats;
+
+	len += scnprintf(buf + len, size - len, "RX: %u us\n", astats->rx_airtime);
+	len += scnprintf(buf + len, size - len, "TX: %u us\n", astats->tx_airtime);
+	len += scnprintf(buf + len, size - len, "Deficit: ");
+	for (i = 0; i < 4; i++)
+		len += scnprintf(buf+len, size - len, "%s: %lld us ", qname[i], an->airtime_deficit[i]);
+	if (len < size)
+		buf[len++] = '\n';
+
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	return retval;
+}
+
+
+static const struct file_operations fops_airtime = {
+	.read = read_airtime,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+
 void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 			   struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta,
@@ -251,4 +304,5 @@ void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 
 	debugfs_create_file("node_aggr", S_IRUGO, dir, an, &fops_node_aggr);
 	debugfs_create_file("node_recv", S_IRUGO, dir, an, &fops_node_recv);
+	debugfs_create_file("airtime", S_IRUGO, dir, an, &fops_airtime);
 }
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c0c8bf0..5aa665f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -620,6 +620,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 
 	/* Will be cleared in ath9k_start() */
 	set_bit(ATH_OP_INVALID, &common->op_flags);
+	sc->airtime_flags = (AIRTIME_USE_TX | AIRTIME_USE_RX |
+			     AIRTIME_USE_NEW_QUEUES);
 
 	sc->sc_ah = ah;
 	sc->dfs_detector = dfs_pattern_detector_init(common, NL80211_DFS_UNSET);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 59e3bd0..58f06ce 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -70,10 +70,10 @@ static bool ath9k_has_pending_frames(struct ath_softc *sc, struct ath_txq *txq,
 		goto out;
 
 	if (txq->mac80211_qnum >= 0) {
-		struct list_head *list;
+		struct ath_acq *acq;
 
-		list = &sc->cur_chan->acq[txq->mac80211_qnum];
-		if (!list_empty(list))
+		acq = &sc->cur_chan->acq[txq->mac80211_qnum];
+		if (!list_empty(&acq->acq_new) || !list_empty(&acq->acq_old))
 			pending = true;
 	}
 out:
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6697342..9f3880d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -991,6 +991,70 @@ static void ath9k_apply_ampdu_details(struct ath_softc *sc,
 	}
 }
 
+static void ath_rx_count_airtime(struct ath_softc *sc,
+				 struct ath_rx_status *rs,
+				 struct sk_buff *skb)
+{
+	struct ath_node *an;
+	struct ath_acq *acq;
+	struct ath_vif *avp;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_sta *sta;
+	struct ieee80211_rx_status *rxs;
+	const struct ieee80211_rate *rate;
+	bool is_sgi, is_40, is_sp;
+	int phy;
+	u16 len = rs->rs_datalen;
+	u32 airtime = 0;
+	u8 tidno, acno;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return;
+
+	rcu_read_lock();
+
+	sta = ieee80211_find_sta_by_ifaddr(sc->hw, hdr->addr2, NULL);
+	if (!sta)
+		goto exit;
+	an = (struct ath_node *) sta->drv_priv;
+	avp = (struct ath_vif *) an->vif->drv_priv;
+	tidno = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
+	acno = TID_TO_WME_AC(tidno);
+	acq = &avp->chanctx->acq[acno];
+
+	rxs = IEEE80211_SKB_RXCB(skb);
+
+	is_sgi = !!(rxs->flag & RX_FLAG_SHORT_GI);
+	is_40 = !!(rxs->flag & RX_FLAG_40MHZ);
+	is_sp = !!(rxs->flag & RX_FLAG_SHORTPRE);
+
+	if (!!(rxs->flag & RX_FLAG_HT)) {
+		/* MCS rates */
+
+		airtime += ath_pkt_duration(sc, rxs->rate_idx, len,
+					is_40, is_sgi, is_sp);
+	} else {
+
+		phy = IS_CCK_RATE(rs->rs_rate) ? WLAN_RC_PHY_CCK : WLAN_RC_PHY_OFDM;
+		rate = &common->sbands[rxs->band].bitrates[rxs->rate_idx];
+		airtime += ath9k_hw_computetxtime(ah, phy, rate->bitrate * 100,
+						len, rxs->rate_idx, is_sp);
+	}
+
+ 	if (!!(sc->airtime_flags & AIRTIME_USE_RX)) {
+		ath_acq_lock(sc, acq);
+		an->airtime_deficit[acno] -= airtime;
+		if (an->airtime_deficit[acno] <= 0)
+			__ath_tx_queue_tid(sc, ATH_AN_2_TID(an, tidno));
+		ath_acq_unlock(sc, acq);
+	}
+	ath_debug_airtime(sc, an, airtime, 0);
+exit:
+	rcu_read_unlock();
+}
+
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 {
 	struct ath_rxbuf *bf;
@@ -1137,6 +1201,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		ath9k_antenna_check(sc, &rs);
 		ath9k_apply_ampdu_details(sc, &rs, rxs);
 		ath_debug_rate_stats(sc, &rs, skb);
+		ath_rx_count_airtime(sc, &rs, skb);
 
 		hdr = (struct ieee80211_hdr *)skb->data;
 		if (ieee80211_is_ack(hdr->frame_control))
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 486afa9..7386e93 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -124,21 +124,44 @@ void ath_txq_unlock_complete(struct ath_softc *sc, struct ath_txq *txq)
 		ath_tx_status(hw, skb);
 }
 
-static void ath_tx_queue_tid(struct ath_softc *sc, struct ath_txq *txq,
-			     struct ath_atx_tid *tid)
+void __ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
-	struct list_head *list;
 	struct ath_vif *avp = (struct ath_vif *) tid->an->vif->drv_priv;
 	struct ath_chanctx *ctx = avp->chanctx;
+	struct ath_acq *acq;
+	struct list_head *tid_list;
+	u8 acno = TID_TO_WME_AC(tid->tidno);
 
-	if (!ctx)
+	if (!ctx || !list_empty(&tid->list))
 		return;
 
-	list = &ctx->acq[TID_TO_WME_AC(tid->tidno)];
-	if (list_empty(&tid->list))
-		list_add_tail(&tid->list, list);
+
+	acq = &ctx->acq[acno];
+	if ((sc->airtime_flags & AIRTIME_USE_NEW_QUEUES) &&
+	    tid->an->airtime_deficit[acno] > 0)
+		tid_list = &acq->acq_new;
+	else
+		tid_list = &acq->acq_old;
+
+	list_add_tail(&tid->list, tid_list);
 }
 
+void ath_tx_queue_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
+{
+	struct ath_vif *avp = (struct ath_vif *) tid->an->vif->drv_priv;
+	struct ath_chanctx *ctx = avp->chanctx;
+	struct ath_acq *acq;
+
+	if (!ctx || !list_empty(&tid->list))
+		return;
+
+	acq = &ctx->acq[TID_TO_WME_AC(tid->tidno)];
+	ath_acq_lock(sc, acq);
+	__ath_tx_queue_tid(sc, tid);
+	ath_acq_unlock(sc, acq);
+}
+
+
 void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *queue)
 {
 	struct ath_softc *sc = hw->priv;
@@ -153,7 +176,7 @@ void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *queue)
 	ath_txq_lock(sc, txq);
 
 	tid->has_queued = true;
-	ath_tx_queue_tid(sc, txq, tid);
+	ath_tx_queue_tid(sc, tid);
 	ath_txq_schedule(sc, txq);
 
 	ath_txq_unlock(sc, txq);
@@ -660,7 +683,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 		skb_queue_splice_tail(&bf_pending, &tid->retry_q);
 		if (!an->sleeping) {
-			ath_tx_queue_tid(sc, txq, tid);
+			ath_tx_queue_tid(sc, tid);
 
 			if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 				tid->clear_ps_filter = true;
@@ -688,6 +711,53 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
     return bf_isampdu(bf) && !(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
 }
 
+static void ath_tx_count_airtime(struct ath_softc *sc, struct ath_txq *txq,
+				 struct ath_buf *bf, struct ath_tx_status *ts)
+{
+	struct ath_node *an;
+	struct ath_acq *acq = &sc->cur_chan->acq[txq->mac80211_qnum];
+	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
+	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_tx_rate rates[4];
+	struct ieee80211_sta *sta;
+	int i;
+	u32 airtime = 0;
+
+	skb = bf->bf_mpdu;
+	if(!skb)
+		return;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	memcpy(rates, bf->rates, sizeof(rates));
+
+	rcu_read_lock();
+
+	sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr1, hdr->addr2);
+	if(!sta)
+		goto exit;
+
+
+	an = (struct ath_node *) sta->drv_priv;
+
+	airtime += ts->duration * (ts->ts_longretry + 1);
+
+	for(i=0; i < ts->ts_rateindex; i++)
+		airtime += ath9k_hw_get_duration(sc->sc_ah, bf->bf_desc, i) * rates[i].count;
+
+	if (!!(sc->airtime_flags & AIRTIME_USE_TX)) {
+		ath_acq_lock(sc, acq);
+		an->airtime_deficit[txq->mac80211_qnum] -= airtime;
+		if (an->airtime_deficit[txq->mac80211_qnum] <= 0)
+			__ath_tx_queue_tid(sc, ath_get_skb_tid(sc, an, skb));
+		ath_acq_unlock(sc, acq);
+	}
+	ath_debug_airtime(sc, an, 0, airtime);
+
+exit:
+	rcu_read_unlock();
+}
+
 static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 				  struct ath_tx_status *ts, struct ath_buf *bf,
 				  struct list_head *bf_head)
@@ -709,6 +779,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 
 	ts->duration = ath9k_hw_get_duration(sc->sc_ah, bf->bf_desc,
 					     ts->ts_rateindex);
+	ath_tx_count_airtime(sc, txq, bf, ts);
 
 	hdr = (struct ieee80211_hdr *) bf->bf_mpdu->data;
 	sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr1, hdr->addr2);
@@ -1068,8 +1139,8 @@ ath_tx_form_aggr(struct ath_softc *sc, struct ath_txq *txq,
  * width  - 0 for 20 MHz, 1 for 40 MHz
  * half_gi - to use 4us v/s 3.6 us for symbol time
  */
-static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, int pktlen,
-			    int width, int half_gi, bool shortPreamble)
+u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, int pktlen,
+		     int width, int half_gi, bool shortPreamble)
 {
 	u32 nbits, nsymbits, duration, nsymbols;
 	int streams;
@@ -1467,7 +1538,7 @@ ath_tx_form_burst(struct ath_softc *sc, struct ath_txq *txq,
 }
 
 static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
-			      struct ath_atx_tid *tid, bool *stop)
+			      struct ath_atx_tid *tid)
 {
 	struct ath_buf *bf;
 	struct ieee80211_tx_info *tx_info;
@@ -1489,7 +1560,6 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	if ((aggr && txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) ||
 	    (!aggr && txq->axq_depth >= ATH_NON_AGGR_MIN_QDEPTH)) {
 		__skb_queue_tail(&tid->retry_q, bf->bf_mpdu);
-		*stop = true;
 		return false;
 	}
 
@@ -1613,7 +1683,7 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 		ath_txq_lock(sc, txq);
 		tid->clear_ps_filter = true;
 		if (ath_tid_has_buffered(tid)) {
-			ath_tx_queue_tid(sc, txq, tid);
+			ath_tx_queue_tid(sc, tid);
 			ath_txq_schedule(sc, txq);
 		}
 		ath_txq_unlock_complete(sc, txq);
@@ -1912,9 +1982,10 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_atx_tid *tid, *last_tid;
+	struct ath_atx_tid *tid;
 	struct list_head *tid_list;
-	bool sent = false;
+	struct ath_acq *acq;
+	bool active = AIRTIME_ACTIVE(sc->airtime_flags);
 
 	if (txq->mac80211_qnum < 0)
 		return;
@@ -1923,48 +1994,55 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 		return;
 
 	spin_lock_bh(&sc->chan_lock);
-	tid_list = &sc->cur_chan->acq[txq->mac80211_qnum];
-
-	if (list_empty(tid_list)) {
-		spin_unlock_bh(&sc->chan_lock);
-		return;
-	}
-
 	rcu_read_lock();
+	acq = &sc->cur_chan->acq[txq->mac80211_qnum];
 
-	last_tid = list_entry(tid_list->prev, struct ath_atx_tid, list);
-	while (!list_empty(tid_list)) {
-		bool stop = false;
-
-		if (sc->cur_chan->stopped)
-			break;
-
-		tid = list_first_entry(tid_list, struct ath_atx_tid, list);
-		list_del_init(&tid->list);
+	if (sc->cur_chan->stopped)
+		goto out;
 
-		if (ath_tx_sched_aggr(sc, txq, tid, &stop))
-			sent = true;
+begin:
+	tid_list = &acq->acq_new;
+	if (list_empty(tid_list)) {
+		tid_list = &acq->acq_old;
+		if (list_empty(tid_list))
+			goto out;
+	}
+	tid = list_first_entry(tid_list, struct ath_atx_tid, list);
 
-		/*
-		 * add tid to round-robin queue if more frames
-		 * are pending for the tid
-		 */
-		if (ath_tid_has_buffered(tid))
-			ath_tx_queue_tid(sc, txq, tid);
+	if (active && tid->an->airtime_deficit[txq->mac80211_qnum] <= 0) {
+		ath_acq_lock(sc, acq);
+		tid->an->airtime_deficit[txq->mac80211_qnum] += ATH_AIRTIME_QUANTUM;
+		list_move_tail(&tid->list, &acq->acq_old);
+		ath_acq_unlock(sc, acq);
+		goto begin;
+	}
 
-		if (stop)
-			break;
+	if (!ath_tid_has_buffered(tid)) {
+		ath_acq_lock(sc, acq);
+		if ((tid_list == &acq->acq_new) && !list_empty(&acq->acq_old))
+			list_move_tail(&tid->list, &acq->acq_old);
+		else {
+			list_del_init(&tid->list);
+		}
+		ath_acq_unlock(sc, acq);
+		goto begin;
+	}
 
-		if (tid == last_tid) {
-			if (!sent)
-				break;
 
-			sent = false;
-			last_tid = list_entry(tid_list->prev,
-					      struct ath_atx_tid, list);
+	/*
+	 * If we succeed in scheduling something, immediately restart to make
+	 * sure we keep the HW busy.
+	 */
+	if(ath_tx_sched_aggr(sc, txq, tid)) {
+		if (!active) {
+			ath_acq_lock(sc, acq);
+			list_move_tail(&tid->list, &acq->acq_old);
+			ath_acq_unlock(sc, acq);
 		}
+		goto begin;
 	}
 
+out:
 	rcu_read_unlock();
 	spin_unlock_bh(&sc->chan_lock);
 }
@@ -2818,6 +2896,9 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	struct ath_atx_tid *tid;
 	int tidno, acno;
 
+	for (acno = 0; acno < IEEE80211_NUM_ACS; acno++)
+		an->airtime_deficit[acno] = ATH_AIRTIME_QUANTUM;
+
 	for (tidno = 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
 		tid = ath_node_to_tid(an, tidno);
 		tid->an        = an;

base-commit: 705d7aa062203226c8df73f18622664e30bd8a61
-- 
2.10.2

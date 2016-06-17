Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:58245 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbcFQJJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 05:09:54 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH 2/2] ath9k: Add a per-station airtime deficit scheduler
Date: Fri, 17 Jun 2016 11:09:29 +0200
Message-Id: <20160617090929.31606-3-toke@toke.dk> (sfid-20160617_111001_721434_2F395F63)
In-Reply-To: <20160617090929.31606-1-toke@toke.dk>
References: <20160617090929.31606-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This modifies the logic in ath_txq_schedule to account airtime consumed
by each station and uses a deficit-based scheduler derived from FQ-CoDel
to try to enforce airtime fairness. A debugfs entry controls whether TX
airtime, RX airtime or both is accounted to the deficit on which the
scheduler makes decisions.

Uses the ts->duration + retry-chain information to account for time
spent transmitting to a station. The RX airtime is measured as the
duration from first to last frame in an aggregate, using the rs_tstamp
fields.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath9k/ath9k.h     |  18 +++-
 drivers/net/wireless/ath/ath9k/channel.c   |  12 ++-
 drivers/net/wireless/ath/ath9k/debug.c     |   3 +
 drivers/net/wireless/ath/ath9k/debug.h     |  29 ++++++
 drivers/net/wireless/ath/ath9k/debug_sta.c |  46 ++++++++++
 drivers/net/wireless/ath/ath9k/init.c      |   1 +
 drivers/net/wireless/ath/ath9k/main.c      |   6 +-
 drivers/net/wireless/ath/ath9k/recv.c      |  60 +++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c      | 136 ++++++++++++++++++++---------
 9 files changed, 261 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index caeae10..e5a930c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -261,9 +261,12 @@ struct ath_node {
 
 	bool sleeping;
 	bool no_ps_filter;
+	s64 airtime_deficit;
+	u32 airtime_rx_start;
 
 #ifdef CONFIG_ATH9K_STATION_STATISTICS
 	struct ath_rx_rate_stats rx_rate_stats;
+	struct ath_airtime_stats airtime_stats;
 #endif
 	u8 key_idx[4];
 
@@ -331,10 +334,15 @@ struct ath_rx {
 /* Channel Context */
 /*******************/
 
+struct ath_acq {
+	struct list_head acq_new;
+	struct list_head acq_old;
+};
+
 struct ath_chanctx {
 	struct cfg80211_chan_def chandef;
 	struct list_head vifs;
-	struct list_head acq[IEEE80211_NUM_ACS];
+	struct ath_acq acq[IEEE80211_NUM_ACS];
 	int hw_queue_base;
 
 	/* do not dereference, use for comparison only */
@@ -573,6 +581,8 @@ void ath_txq_schedule_all(struct ath_softc *sc);
 int ath_tx_init(struct ath_softc *sc, int nbufs);
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *q);
+u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, int pktlen,
+		     int width, int half_gi, bool shortPreamble);
 void ath_update_max_aggr_framelen(struct ath_softc *sc, int queue, int txop);
 void ath_assign_seq(struct ath_common *common, struct sk_buff *skb);
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
@@ -959,6 +969,10 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
 
 #define ATH9K_NUM_CHANCTX  2 /* supports 2 operating channels */
 
+#define AIRTIME_USE_TX BIT(0)
+#define AIRTIME_USE_RX BIT(1)
+#define AIRTIME_ACTIVE(flags) (!!(flags & (AIRTIME_USE_TX|AIRTIME_USE_RX)))
+
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
@@ -1001,6 +1015,8 @@ struct ath_softc {
 	short nbcnvifs;
 	unsigned long ps_usecount;
 
+	u16 airtime_flags; /* AIRTIME_* */
+
 	struct ath_rx rx;
 	struct ath_tx tx;
 	struct ath_beacon beacon;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index e56bafc..2594029 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -118,8 +118,10 @@ void ath_chanctx_init(struct ath_softc *sc)
 		INIT_LIST_HEAD(&ctx->vifs);
 		ctx->txpower = ATH_TXPOWER_MAX;
 		ctx->flush_timeout = HZ / 5; /* 200ms */
-		for (j = 0; j < ARRAY_SIZE(ctx->acq); j++)
-			INIT_LIST_HEAD(&ctx->acq[j]);
+		for (j = 0; j < ARRAY_SIZE(ctx->acq); j++) {
+			INIT_LIST_HEAD(&ctx->acq[j].acq_new);
+			INIT_LIST_HEAD(&ctx->acq[j].acq_old);
+		}
 	}
 }
 
@@ -1344,8 +1346,10 @@ void ath9k_offchannel_init(struct ath_softc *sc)
 	ctx->txpower = ATH_TXPOWER_MAX;
 	cfg80211_chandef_create(&ctx->chandef, chan, NL80211_CHAN_HT20);
 
-	for (i = 0; i < ARRAY_SIZE(ctx->acq); i++)
-		INIT_LIST_HEAD(&ctx->acq[i]);
+	for (i = 0; i < ARRAY_SIZE(ctx->acq); i++) {
+		INIT_LIST_HEAD(&ctx->acq[i].acq_new);
+		INIT_LIST_HEAD(&ctx->acq[i].acq_old);
+	}
 
 	sc->offchannel.chan.offchannel = true;
 }
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index c56e40f..413de3c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1411,5 +1411,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_file("tpc", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc, &fops_tpc);
 
+	debugfs_create_u16("airtime_flags", S_IRUSR | S_IWUSR,
+			   sc->debug.debugfs_phy, &sc->airtime_flags);
+
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index cd68c5f..bf1a540 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -223,6 +223,11 @@ struct ath_rx_rate_stats {
 	} cck_stats[4];
 };
 
+struct ath_airtime_stats {
+	u32 rx_airtime;
+	u32 tx_airtime;
+};
+
 #define ANT_MAIN 0
 #define ANT_ALT  1
 
@@ -316,12 +321,36 @@ ath9k_debug_sync_cause(struct ath_softc *sc, u32 sync_cause)
 void ath_debug_rate_stats(struct ath_softc *sc,
 			  struct ath_rx_status *rs,
 			  struct sk_buff *skb);
+void ath_debug_tx_airtime(struct ath_softc *sc,
+		          struct ath_buf *bf,
+			  struct ath_tx_status *ts);
+void ath_debug_rx_airtime(struct ath_softc *sc,
+			  struct ath_rx_status *rs,
+			  struct sk_buff *skb);
+void ath_debug_airtime(struct ath_softc *sc,
+		       struct ath_node *an,
+		       u32 rx, u32 tx);
 #else
 static inline void ath_debug_rate_stats(struct ath_softc *sc,
 					struct ath_rx_status *rs,
 					struct sk_buff *skb)
 {
 }
+static inline void ath_debug_tx_airtime(struct ath_softc *sc,
+					struct ath_buf *bf,
+					struct ath_tx_status *ts)
+{
+}
+static inline void ath_debug_rx_airtime(struct ath_softc *sc,
+					struct ath_rx_status *rs,
+					struct sk_buff *skb)
+{
+}
+static void ath_debug_airtime(struct ath_softc *sc,
+			      struct ath_node *an,
+			      u32 rx, u32 tx)
+{
+}
 #endif /* CONFIG_ATH9K_STATION_STATISTICS */
 
 #endif /* DEBUG_H */
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index 0e7f6b5..e7f2ef2 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -245,6 +245,51 @@ static const struct file_operations fops_node_recv = {
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
+	u32 len = 0, size = 128;
+	char *buf;
+	size_t retval;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
+
+	astats = &an->airtime_stats;
+
+	len += scnprintf(buf + len, size - len, "RX: %u us\n", astats->rx_airtime);
+	len += scnprintf(buf + len, size - len, "TX: %u us\n", astats->tx_airtime);
+	len += scnprintf(buf + len, size - len, "Deficit: %lld us\n", an->airtime_deficit);
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
@@ -254,4 +299,5 @@ void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 
 	debugfs_create_file("node_aggr", S_IRUGO, dir, an, &fops_node_aggr);
 	debugfs_create_file("node_recv", S_IRUGO, dir, an, &fops_node_recv);
+	debugfs_create_file("airtime", S_IRUGO, dir, an, &fops_airtime);
 }
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 211736c..f4e9dd3 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -560,6 +560,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 
 	/* Will be cleared in ath9k_start() */
 	set_bit(ATH_OP_INVALID, &common->op_flags);
+	sc->airtime_flags = AIRTIME_USE_TX | AIRTIME_USE_RX;
 
 	sc->sc_ah = ah;
 	sc->dfs_detector = dfs_pattern_detector_init(common, NL80211_DFS_UNSET);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6ab56e5..e13068b 100644
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
index 32160fc..a48667f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -991,6 +991,65 @@ static void ath9k_apply_ampdu_details(struct ath_softc *sc,
 	}
 }
 
+static void ath_rx_count_airtime(struct ath_softc *sc,
+				 struct ath_rx_status *rs,
+				 struct sk_buff *skb)
+{
+	struct ath_node *an;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_sta *sta;
+	struct ieee80211_rx_status *rxs;
+	const struct ieee80211_rate *rate;
+	bool is_sgi, is_40, is_sp;
+	int phy;
+	u32 airtime = 0;
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
+
+	if (rs->rs_isaggr && rs->rs_firstaggr) {
+		an->airtime_rx_start = rs->rs_tstamp;
+	} else if (rs->rs_isaggr && !rs->rs_moreaggr && an->airtime_rx_start) {
+		airtime = rs->rs_tstamp - an->airtime_rx_start;
+	} else if (!rs->rs_isaggr) {
+		an->airtime_rx_start = 0;
+
+		rxs = IEEE80211_SKB_RXCB(skb);
+
+		is_sgi = !!(rxs->flag & RX_FLAG_SHORT_GI);
+		is_40 = !!(rxs->flag & RX_FLAG_40MHZ);
+		is_sp = !!(rxs->flag & RX_FLAG_SHORTPRE);
+
+		if (!!(rxs->flag & RX_FLAG_HT)) {
+			/* MCS rates */
+
+			airtime += ath_pkt_duration(sc, rxs->rate_idx, rs->rs_datalen,
+						is_40, is_sgi, is_sp);
+		} else {
+
+			phy = IS_CCK_RATE(rs->rs_rate) ? WLAN_RC_PHY_CCK : WLAN_RC_PHY_OFDM;
+			rate = &common->sbands[rxs->band].bitrates[rxs->rate_idx];
+			airtime += ath9k_hw_computetxtime(ah, phy, rate->bitrate * 100,
+							rs->rs_datalen, rxs->rate_idx, is_sp);
+		}
+	}
+
+ 	if (!!(sc->airtime_flags & AIRTIME_USE_RX))
+		an->airtime_deficit -= airtime;
+	ath_debug_airtime(sc, an, airtime, 0);
+exit:
+	rcu_read_unlock();
+}
+
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 {
 	struct ath_rxbuf *bf;
@@ -1137,6 +1196,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		ath9k_antenna_check(sc, &rs);
 		ath9k_apply_ampdu_details(sc, &rs, rxs);
 		ath_debug_rate_stats(sc, &rs, skb);
+		ath_rx_count_airtime(sc, &rs, skb);
 
 		hdr = (struct ieee80211_hdr *)skb->data;
 		if (ieee80211_is_ack(hdr->frame_control))
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index cdc8684..ef0a4a1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -108,16 +108,19 @@ void ath_txq_unlock_complete(struct ath_softc *sc, struct ath_txq *txq)
 static void ath_tx_queue_tid(struct ath_softc *sc, struct ath_txq *txq,
 			     struct ath_atx_tid *tid)
 {
-	struct list_head *list;
 	struct ath_vif *avp = (struct ath_vif *) tid->an->vif->drv_priv;
 	struct ath_chanctx *ctx = avp->chanctx;
+	struct ath_acq *acq;
+	struct list_head *tid_list;
 
 	if (!ctx)
 		return;
 
-	list = &ctx->acq[TID_TO_WME_AC(tid->tidno)];
+
+	acq = &ctx->acq[TID_TO_WME_AC(tid->tidno)];
+	tid_list = AIRTIME_ACTIVE(sc->airtime_flags) ? &acq->acq_new : &acq->acq_old;
 	if (list_empty(&tid->list))
-		list_add_tail(&tid->list, list);
+		list_add_tail(&tid->list, tid_list);
 }
 
 void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *swq)
@@ -722,6 +725,48 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
     return bf_isampdu(bf) && !(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
 }
 
+static void ath_tx_count_airtime(struct ath_softc *sc,
+				 struct ath_buf *bf,
+				 struct ath_tx_status *ts)
+{
+	struct ath_node *an;
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
+	if (!!(sc->airtime_flags & AIRTIME_USE_TX))
+		an->airtime_deficit -= airtime;
+	ath_debug_airtime(sc, an, 0, airtime);
+
+exit:
+	rcu_read_unlock();
+}
+
 static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 				  struct ath_tx_status *ts, struct ath_buf *bf,
 				  struct list_head *bf_head)
@@ -739,6 +784,8 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 
 	ts->duration = ath9k_hw_get_duration(sc->sc_ah, bf->bf_desc,
 					     ts->ts_rateindex);
+	ath_tx_count_airtime(sc, bf, ts);
+
 	if (!bf_isampdu(bf)) {
 		if (!flush) {
 			info = IEEE80211_SKB_CB(bf->bf_mpdu);
@@ -751,6 +798,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	} else
 		ath_tx_complete_aggr(sc, txq, bf, bf_head, ts, txok);
 
+
 	if (!flush)
 		ath_txq_schedule(sc, txq);
 }
@@ -1090,8 +1138,8 @@ ath_tx_form_aggr(struct ath_softc *sc, struct ath_txq *txq,
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
@@ -1490,7 +1538,7 @@ ath_tx_form_burst(struct ath_softc *sc, struct ath_txq *txq,
 }
 
 static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
-			      struct ath_atx_tid *tid, bool *stop)
+			      struct ath_atx_tid *tid)
 {
 	struct ath_buf *bf;
 	struct ieee80211_tx_info *tx_info;
@@ -1512,7 +1560,6 @@ static bool ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	aggr = !!(tx_info->flags & IEEE80211_TX_CTL_AMPDU);
 	if ((aggr && txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) ||
 		(!aggr && txq->axq_depth >= ATH_NON_AGGR_MIN_QDEPTH)) {
-		*stop = true;
 		return false;
 	}
 
@@ -1984,9 +2031,10 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
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
@@ -1995,48 +2043,50 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 		return;
 
 	spin_lock_bh(&sc->chan_lock);
-	tid_list = &sc->cur_chan->acq[txq->mac80211_qnum];
+	acq = &sc->cur_chan->acq[txq->mac80211_qnum];
 
-	if (list_empty(tid_list)) {
-		spin_unlock_bh(&sc->chan_lock);
-		return;
-	}
+	if (sc->cur_chan->stopped)
+		goto out;
 
 	rcu_read_lock();
+begin:
+	tid_list = &acq->acq_new;
+	if (list_empty(tid_list)) {
+		tid_list = &acq->acq_old;
+		if (list_empty(tid_list))
+			goto out;
+	}
+	tid = list_first_entry(tid_list, struct ath_atx_tid, list);
 
-	last_tid = list_entry(tid_list->prev, struct ath_atx_tid, list);
-	while (!list_empty(tid_list)) {
-		bool stop = false;
-
-		if (sc->cur_chan->stopped)
-			break;
-
-		tid = list_first_entry(tid_list, struct ath_atx_tid, list);
-		list_del_init(&tid->list);
-
-		if (ath_tx_sched_aggr(sc, txq, tid, &stop))
-			sent = true;
-
-		/*
-		 * add tid to round-robin queue if more frames
-		 * are pending for the tid
-		 */
-		if (ath_tid_has_buffered(tid))
-			ath_tx_queue_tid(sc, txq, tid);
+	if (active && tid->an->airtime_deficit <= 0) {
+		tid->an->airtime_deficit += 300;
+		list_move_tail(&tid->list, &acq->acq_old);
+		goto begin;
+	}
 
-		if (stop)
-			break;
+	if (!ath_tid_has_buffered(tid)) {
+		if ((tid_list == &acq->acq_new) && !list_empty(&acq->acq_old))
+			list_move_tail(&tid->list, &acq->acq_old);
+		else
+			list_del_init(&tid->list);
+		goto begin;
+	}
 
-		if (tid == last_tid) {
-			if (!sent)
-				break;
 
-			sent = false;
-			last_tid = list_entry(tid_list->prev,
-					      struct ath_atx_tid, list);
-		}
+	/* If a station succeeds in queueing something, immediately restart the
+	 * loop. This makes sure the queues are shuffled if the station now has
+	 * no more packets queued, and also ensures we keep the hardware queues
+	 * full.
+	 *
+	 * If we dequeued from a new queue, shuffle the queues, to prevent it
+	 * from hogging too much airtime. */
+	if(ath_tx_sched_aggr(sc, txq, tid)) {
+		if (!active || ((tid_list == &acq->acq_new) && !list_empty(&acq->acq_old)))
+			list_move_tail(&tid->list, &acq->acq_old);
+		goto begin;
 	}
 
+out:
 	rcu_read_unlock();
 	spin_unlock_bh(&sc->chan_lock);
 }
@@ -2931,6 +2981,8 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	struct ath_atx_tid *tid;
 	int tidno, acno;
 
+	an->airtime_deficit = 300;
+
 	for (tidno = 0;
 	     tidno < IEEE80211_NUM_TIDS;
 	     tidno++) {
-- 
2.8.3

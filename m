Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:37160 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbcFCQwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 12:52:38 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [RFC/RFT 4/5] ath9k: Add a per-station airtime deficit scheduler
Date: Fri,  3 Jun 2016 18:51:43 +0200
Message-Id: <20160603165144.17356-5-toke@toke.dk> (sfid-20160603_185242_098839_29438C2A)
In-Reply-To: <20160603165144.17356-1-toke@toke.dk>
References: <20160603165144.17356-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This modifies the logic in ath_txq_schedule to account airtime consumed
by each station and uses a deficit-based scheduler derived from FQ-CoDel
to try to enforce airtime fairness. The deficit is decreased on TX
completion and the scheduler simply makes scheduling decisions based on
this.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath9k/ath9k.h     |  8 ++-
 drivers/net/wireless/ath/ath9k/channel.c   | 12 ++--
 drivers/net/wireless/ath/ath9k/debug.h     |  8 +++
 drivers/net/wireless/ath/ath9k/debug_sta.c | 12 ++++
 drivers/net/wireless/ath/ath9k/main.c      |  6 +-
 drivers/net/wireless/ath/ath9k/xmit.c      | 99 ++++++++++++++++++++++++------
 6 files changed, 117 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3fbb0ad..7c0fc8b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -261,6 +261,7 @@ struct ath_node {
 
 	bool sleeping;
 	bool no_ps_filter;
+	s64 airtime_deficit;
 
 #ifdef CONFIG_ATH9K_STATION_STATISTICS
 	struct ath_rx_rate_stats rx_rate_stats;
@@ -332,10 +333,15 @@ struct ath_rx {
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
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 4f78495..bf1a540 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -327,6 +327,9 @@ void ath_debug_tx_airtime(struct ath_softc *sc,
 void ath_debug_rx_airtime(struct ath_softc *sc,
 			  struct ath_rx_status *rs,
 			  struct sk_buff *skb);
+void ath_debug_airtime(struct ath_softc *sc,
+		       struct ath_node *an,
+		       u32 rx, u32 tx);
 #else
 static inline void ath_debug_rate_stats(struct ath_softc *sc,
 					struct ath_rx_status *rs,
@@ -343,6 +346,11 @@ static inline void ath_debug_rx_airtime(struct ath_softc *sc,
 					struct sk_buff *skb)
 {
 }
+static void ath_debug_airtime(struct ath_softc *sc,
+			      struct ath_node *an,
+			      u32 rx, u32 tx)
+{
+}
 #endif /* CONFIG_ATH9K_STATION_STATISTICS */
 
 #endif /* DEBUG_H */
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index 56aba3a..2313f9e 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -245,6 +245,17 @@ static const struct file_operations fops_node_recv = {
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
 void ath_debug_tx_airtime(struct ath_softc *sc,
 		          struct ath_buf *bf,
 		          struct ath_tx_status *ts)
@@ -353,6 +364,7 @@ static ssize_t read_airtime(struct file *file, char __user *user_buf,
 
 	len += scnprintf(buf + len, size - len, "RX: %u us\n", astats->rx_airtime);
 	len += scnprintf(buf + len, size - len, "TX: %u us\n", astats->tx_airtime);
+	len += scnprintf(buf + len, size - len, "Deficit: %lld us\n", an->airtime_deficit);
 
 	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
 	kfree(buf);
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
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 07d32e7..6ce58d9 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -108,16 +108,17 @@ void ath_txq_unlock_complete(struct ath_softc *sc, struct ath_txq *txq)
 static void ath_tx_queue_tid(struct ath_softc *sc, struct ath_txq *txq,
 			     struct ath_atx_tid *tid)
 {
-	struct list_head *list;
 	struct ath_vif *avp = (struct ath_vif *) tid->an->vif->drv_priv;
 	struct ath_chanctx *ctx = avp->chanctx;
+	struct ath_acq *acq;
 
 	if (!ctx)
 		return;
 
-	list = &ctx->acq[TID_TO_WME_AC(tid->tidno)];
+
+	acq = &ctx->acq[TID_TO_WME_AC(tid->tidno)];
 	if (list_empty(&tid->list))
-		list_add_tail(&tid->list, list);
+		list_add_tail(&tid->list, &acq->acq_new);
 }
 
 void ath9k_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *swq)
@@ -722,6 +723,47 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
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
+	an->airtime_deficit -= airtime;
+	ath_debug_airtime(sc, an, 0, airtime);
+
+exit:
+	rcu_read_unlock();
+}
+
 static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 				  struct ath_tx_status *ts, struct ath_buf *bf,
 				  struct list_head *bf_head)
@@ -739,7 +781,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 
 	ts->duration = ath9k_hw_get_duration(sc->sc_ah, bf->bf_desc,
 					     ts->ts_rateindex);
-	ath_debug_tx_airtime(sc, bf, ts);
+	ath_tx_count_airtime(sc, bf, ts);
 
 	if (!bf_isampdu(bf)) {
 		if (!flush) {
@@ -1989,6 +2031,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_atx_tid *tid, *last_tid;
 	struct list_head *tid_list;
+	struct ath_acq *acq;
 	bool sent = false;
 
 	if (txq->mac80211_qnum < 0)
@@ -1998,37 +2041,51 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 		return;
 
 	spin_lock_bh(&sc->chan_lock);
-	tid_list = &sc->cur_chan->acq[txq->mac80211_qnum];
-
-	if (list_empty(tid_list)) {
-		spin_unlock_bh(&sc->chan_lock);
-		return;
-	}
+	acq = &sc->cur_chan->acq[txq->mac80211_qnum];
 
 	rcu_read_lock();
 
+	tid_list = &acq->acq_new;
+	if (list_empty(tid_list)) {
+		tid_list = &acq->acq_old;
+		if (list_empty(tid_list))
+			goto out;
+	}
 	last_tid = list_entry(tid_list->prev, struct ath_atx_tid, list);
-	while (!list_empty(tid_list)) {
+	for (;;) {
 		bool stop = false;
 
 		if (sc->cur_chan->stopped)
 			break;
 
-		tid = list_first_entry(tid_list, struct ath_atx_tid, list);
-		list_del_init(&tid->list);
+		tid = list_first_entry_or_null(tid_list, struct ath_atx_tid, list);
+		if (!tid)
+			break;
+
+		if (tid->an->airtime_deficit <= 0) {
+			tid->an->airtime_deficit += 300;
+			list_move_tail(&tid->list, &acq->acq_old);
+			continue;
+		}
+
 
 		if (ath_tx_sched_aggr(sc, txq, tid, &stop))
 			sent = true;
 
+		/* Give this tid a chance to try again when we have hw buffer space */
+		if (stop)
+			break;
+
 		/*
-		 * add tid to round-robin queue if more frames
-		 * are pending for the tid
+		 * If we still have packets or we're in the new list, we need to
+		 * pass through old list. The latter case is to prevent
+		 * starvation.
 		 */
-		if (ath_tid_has_buffered(tid))
-			ath_tx_queue_tid(sc, txq, tid);
+		if (ath_tid_has_buffered(tid) || ((tid_list == &acq->acq_new) && !list_empty(&acq->acq_old)))
+			list_move_tail(&tid->list, &acq->acq_old);
+		else
+			list_del_init(&tid->list);
 
-		if (stop)
-			break;
 
 		if (tid == last_tid) {
 			if (!sent)
@@ -2039,7 +2096,7 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 					      struct ath_atx_tid, list);
 		}
 	}
-
+out:
 	rcu_read_unlock();
 	spin_unlock_bh(&sc->chan_lock);
 }
@@ -2934,6 +2991,8 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	struct ath_atx_tid *tid;
 	int tidno, acno;
 
+	an->airtime_deficit = 300;
+
 	for (tidno = 0;
 	     tidno < IEEE80211_NUM_TIDS;
 	     tidno++) {
-- 
2.7.4

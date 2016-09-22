Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:60214 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965303AbcIVREy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 13:04:54 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v9 2/2] mac80211: Move reorder-sensitive TX handlers to after
        TXQ dequeue
Date: Thu, 22 Sep 2016 19:04:20 +0200
Message-Id: <20160922170420.5193-3-toke@toke.dk> (sfid-20160922_190458_746453_8124AE7E)
In-Reply-To: <20160922170420.5193-1-toke@toke.dk>
References: <20160922170420.5193-1-toke@toke.dk>
In-Reply-To: <20160906114426.25520-1-toke@toke.dk>
References: <20160906114426.25520-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TXQ intermediate queues can cause packet reordering when more than
one flow is active to a single station. Since some of the wifi-specific
packet handling (notably sequence number and encryption handling) is
sensitive to re-ordering, things break if they are applied before the
TXQ.

This splits up the TX handlers and fast_xmit logic into two parts: An
early part and a late part. The former is applied before TXQ enqueue,
and the latter after dequeue. The non-TXQ path just applies both parts
at once.

Because fragments shouldn't be split up or reordered, the fragmentation
handler is run after dequeue. Any fragments are then kept in the TXQ and
on subsequent dequeues they take precedence over dequeueing from the FQ
structure.

This approach avoids having to scatter special cases all over the place
for when TXQ is enabled, at the cost of making the fast_xmit and TX
handler code slightly more complex.

Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
---
 include/net/mac80211.h     |   2 +
 net/mac80211/ieee80211_i.h |   8 ++
 net/mac80211/rx.c          |   4 +-
 net/mac80211/sta_info.c    |  10 +-
 net/mac80211/tx.c          | 287 +++++++++++++++++++++++++++++++++------=
------
 net/mac80211/util.c        |  11 +-
 6 files changed, 232 insertions(+), 90 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5296100..9463039 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -715,6 +715,7 @@ enum mac80211_tx_info_flags {
  *	frame (PS-Poll or uAPSD).
  * @IEEE80211_TX_CTRL_RATE_INJECT: This frame is injected with rate info=
rmation
  * @IEEE80211_TX_CTRL_AMSDU: This frame is an A-MSDU frame
+ * @IEEE80211_TX_CTRL_FAST_XMIT: This frame is going through the fast_xm=
it path
  *
  * These flags are used in tx_info->control.flags.
  */
@@ -723,6 +724,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_PS_RESPONSE		=3D BIT(1),
 	IEEE80211_TX_CTRL_RATE_INJECT		=3D BIT(2),
 	IEEE80211_TX_CTRL_AMSDU			=3D BIT(3),
+	IEEE80211_TX_CTRL_FAST_XMIT		=3D BIT(4),
 };
=20
 /*
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c71c735..caca265 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -813,12 +813,14 @@ enum txq_info_flags {
  * @def_flow: used as a fallback flow when a packet destined to @tin has=
hes to
  *	a fq_flow which is already owned by a different tin
  * @def_cvars: codel vars for @def_flow
+ * @frags: used to keep fragments created after dequeue
  */
 struct txq_info {
 	struct fq_tin tin;
 	struct fq_flow def_flow;
 	struct codel_vars def_cvars;
 	struct codel_stats cstats;
+	struct sk_buff_head frags;
 	unsigned long flags;
=20
 	/* keep last! */
@@ -1481,6 +1483,12 @@ static inline struct txq_info *to_txq_info(struct =
ieee80211_txq *txq)
 	return container_of(txq, struct txq_info, txq);
 }
=20
+static inline bool txq_has_queue(struct ieee80211_txq *txq)
+{
+	struct txq_info *txqi =3D to_txq_info(txq);
+	return !(skb_queue_empty(&txqi->frags) && !txqi->tin.backlog_packets);
+}
+
 static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
 {
 	return ether_addr_equal(raddr, addr) ||
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e796060..ae5786b8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1323,9 +1323,7 @@ static void sta_ps_start(struct sta_info *sta)
 		return;
=20
 	for (tid =3D 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
-		struct txq_info *txqi =3D to_txq_info(sta->sta.txq[tid]);
-
-		if (txqi->tin.backlog_packets)
+		if (txq_has_queue(sta->sta.txq[tid]))
 			set_bit(tid, &sta->txq_buffered_tids);
 		else
 			clear_bit(tid, &sta->txq_buffered_tids);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 1b1b28f..167bff0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1212,12 +1212,10 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_i=
nfo *sta)
=20
 	if (sta->sta.txq[0]) {
 		for (i =3D 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
-			struct txq_info *txqi =3D to_txq_info(sta->sta.txq[i]);
-
-			if (!txqi->tin.backlog_packets)
+			if (!txq_has_queue(sta->sta.txq[i]))
 				continue;
=20
-			drv_wake_tx_queue(local, txqi);
+			drv_wake_tx_queue(local, to_txq_info(sta->sta.txq[i]));
 		}
 	}
=20
@@ -1649,9 +1647,7 @@ ieee80211_sta_ps_deliver_response(struct sta_info *=
sta,
 			return;
=20
 		for (tid =3D 0; tid < ARRAY_SIZE(sta->sta.txq); tid++) {
-			struct txq_info *txqi =3D to_txq_info(sta->sta.txq[tid]);
-
-			if (!(tids & BIT(tid)) || txqi->tin.backlog_packets)
+			if (!(tids & BIT(tid)) || txq_has_queue(sta->sta.txq[tid]))
 				continue;
=20
 			sta_info_recalc_tim(sta);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e8c9964..75e6adf 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -853,8 +853,7 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 	tid =3D *qc & IEEE80211_QOS_CTL_TID_MASK;
 	tx->sta->tx_stats.msdu[tid]++;
=20
-	if (!tx->sta->sta.txq[0])
-		hdr->seq_ctrl =3D ieee80211_tx_next_seq(tx->sta, tid);
+	hdr->seq_ctrl =3D ieee80211_tx_next_seq(tx->sta, tid);
=20
 	return TX_CONTINUE;
 }
@@ -1404,6 +1403,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_dat=
a *sdata,
 	fq_flow_init(&txqi->def_flow);
 	codel_vars_init(&txqi->def_cvars);
 	codel_stats_init(&txqi->cstats);
+	__skb_queue_head_init(&txqi->frags);
=20
 	txqi->txq.vif =3D &sdata->vif;
=20
@@ -1426,6 +1426,7 @@ void ieee80211_txq_purge(struct ieee80211_local *lo=
cal,
 	struct fq_tin *tin =3D &txqi->tin;
=20
 	fq_tin_reset(fq, tin, fq_skb_free_func);
+	ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
 }
=20
 int ieee80211_txq_setup_flows(struct ieee80211_local *local)
@@ -1476,6 +1477,47 @@ void ieee80211_txq_teardown_flows(struct ieee80211=
_local *local)
 	spin_unlock_bh(&fq->lock);
 }
=20
+static bool ieee80211_queue_skb(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
+				struct sta_info *sta,
+				struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
+	struct fq *fq =3D &local->fq;
+	struct ieee80211_vif *vif;
+	struct txq_info *txqi;
+	struct ieee80211_sta *pubsta;
+
+	if (!local->ops->wake_tx_queue ||
+	    sdata->vif.type =3D=3D NL80211_IFTYPE_MONITOR)
+		return false;
+
+	if (sta && sta->uploaded)
+		pubsta =3D &sta->sta;
+	else
+		pubsta =3D NULL;
+
+	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
+		sdata =3D container_of(sdata->bss,
+				     struct ieee80211_sub_if_data, u.ap);
+
+	vif =3D &sdata->vif;
+	txqi =3D ieee80211_get_txq(local, vif, pubsta, skb);
+
+	if (!txqi)
+		return false;
+
+	info->control.vif =3D vif;
+
+	spin_lock_bh(&fq->lock);
+	ieee80211_txq_enqueue(local, txqi, skb);
+	spin_unlock_bh(&fq->lock);
+
+	drv_wake_tx_queue(local, txqi);
+
+	return true;
+}
+
 static bool ieee80211_tx_frags(struct ieee80211_local *local,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
@@ -1483,9 +1525,7 @@ static bool ieee80211_tx_frags(struct ieee80211_loc=
al *local,
 			       bool txpending)
 {
 	struct ieee80211_tx_control control =3D {};
-	struct fq *fq =3D &local->fq;
 	struct sk_buff *skb, *tmp;
-	struct txq_info *txqi;
 	unsigned long flags;
=20
 	skb_queue_walk_safe(skbs, skb, tmp) {
@@ -1500,21 +1540,6 @@ static bool ieee80211_tx_frags(struct ieee80211_lo=
cal *local,
 		}
 #endif
=20
-		txqi =3D ieee80211_get_txq(local, vif, sta, skb);
-		if (txqi) {
-			info->control.vif =3D vif;
-
-			__skb_unlink(skb, skbs);
-
-			spin_lock_bh(&fq->lock);
-			ieee80211_txq_enqueue(local, txqi, skb);
-			spin_unlock_bh(&fq->lock);
-
-			drv_wake_tx_queue(local, txqi);
-
-			continue;
-		}
-
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		if (local->queue_stop_reasons[q] ||
 		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
@@ -1635,10 +1660,13 @@ static bool __ieee80211_tx(struct ieee80211_local=
 *local,
 /*
  * Invoke TX handlers, return 0 on success and non-zero if the
  * frame was dropped or queued.
+ *
+ * The handlers are split into an early and late part. The latter is eve=
rything
+ * that can be sensitive to reordering, and will be deferred to after pa=
ckets
+ * are dequeued from the intermediate queues (when they are enabled).
  */
-static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
+static int invoke_tx_handlers_early(struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(tx->skb);
 	ieee80211_tx_result res =3D TX_DROP;
=20
 #define CALL_TXH(txh) \
@@ -1656,6 +1684,31 @@ static int invoke_tx_handlers(struct ieee80211_tx_=
data *tx)
 	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
=20
+ txh_done:
+	if (unlikely(res =3D=3D TX_DROP)) {
+		I802_DEBUG_INC(tx->local->tx_handlers_drop);
+		if (tx->skb)
+			ieee80211_free_txskb(&tx->local->hw, tx->skb);
+		else
+			ieee80211_purge_tx_queue(&tx->local->hw, &tx->skbs);
+		return -1;
+	} else if (unlikely(res =3D=3D TX_QUEUED)) {
+		I802_DEBUG_INC(tx->local->tx_handlers_queued);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Late handlers can be called while the sta lock is held. Handlers that=
 can
+ * cause packets to be generated will cause deadlock!
+ */
+static int invoke_tx_handlers_late(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(tx->skb);
+	ieee80211_tx_result res =3D TX_CONTINUE;
+
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION)) {
 		__skb_queue_tail(&tx->skbs, tx->skb);
 		tx->skb =3D NULL;
@@ -1688,6 +1741,15 @@ static int invoke_tx_handlers(struct ieee80211_tx_=
data *tx)
 	return 0;
 }
=20
+static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
+{
+	int r =3D invoke_tx_handlers_early(tx);
+
+	if (r)
+		return r;
+	return invoke_tx_handlers_late(tx);
+}
+
 bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif, struct sk_buff *skb,
 			      int band, struct ieee80211_sta **sta)
@@ -1762,7 +1824,13 @@ static bool ieee80211_tx(struct ieee80211_sub_if_d=
ata *sdata,
 		info->hw_queue =3D
 			sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
=20
-	if (!invoke_tx_handlers(&tx))
+	if (invoke_tx_handlers_early(&tx))
+		return false;
+
+	if (ieee80211_queue_skb(local, sdata, tx.sta, tx.skb))
+		return true;
+
+	if (!invoke_tx_handlers_late(&tx))
 		result =3D __ieee80211_tx(local, &tx.skbs, led_len,
 					tx.sta, txpending);
=20
@@ -3106,8 +3174,73 @@ out:
 	return ret;
 }
=20
+/*
+ * Can be called while the sta lock is held. Anything that can cause pac=
kets to
+ * be generated will cause deadlock!
+ */
+static bool ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sda=
ta,
+				       struct sta_info *sta, u8 pn_offs,
+				       struct ieee80211_key *key,
+				       struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr =3D (void *)skb->data;
+	u8 tid =3D IEEE80211_NUM_TIDS;
+
+	if (key)
+		info->control.hw_key =3D &key->conf;
+
+	ieee80211_tx_stats(skb->dev, skb->len);
+
+	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
+		tid =3D skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
+		*ieee80211_get_qos_ctl(hdr) =3D tid;
+		hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, tid);
+	} else {
+		info->flags |=3D IEEE80211_TX_CTL_ASSIGN_SEQ;
+		hdr->seq_ctrl =3D cpu_to_le16(sdata->sequence_number);
+		sdata->sequence_number +=3D 0x10;
+	}
+
+	if (skb_shinfo(skb)->gso_size)
+		sta->tx_stats.msdu[tid] +=3D
+			DIV_ROUND_UP(skb->len, skb_shinfo(skb)->gso_size);
+	else
+		sta->tx_stats.msdu[tid]++;
+
+	info->hw_queue =3D sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
+
+	/* statistics normally done by ieee80211_tx_h_stats (but that
+	 * has to consider fragmentation, so is more complex)
+	 */
+	sta->tx_stats.bytes[skb_get_queue_mapping(skb)] +=3D skb->len;
+	sta->tx_stats.packets[skb_get_queue_mapping(skb)]++;
+
+	if (pn_offs) {
+		u64 pn;
+		u8 *crypto_hdr =3D skb->data + pn_offs;
+
+		switch (key->conf.cipher) {
+		case WLAN_CIPHER_SUITE_CCMP:
+		case WLAN_CIPHER_SUITE_CCMP_256:
+		case WLAN_CIPHER_SUITE_GCMP:
+		case WLAN_CIPHER_SUITE_GCMP_256:
+			pn =3D atomic64_inc_return(&key->conf.tx_pn);
+			crypto_hdr[0] =3D pn;
+			crypto_hdr[1] =3D pn >> 8;
+			crypto_hdr[4] =3D pn >> 16;
+			crypto_hdr[5] =3D pn >> 24;
+			crypto_hdr[6] =3D pn >> 32;
+			crypto_hdr[7] =3D pn >> 40;
+			break;
+		}
+	}
+
+	return true;
+}
+
 static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
-				struct net_device *dev, struct sta_info *sta,
+				struct sta_info *sta,
 				struct ieee80211_fast_tx *fast_tx,
 				struct sk_buff *skb)
 {
@@ -3158,8 +3291,6 @@ static bool ieee80211_xmit_fast(struct ieee80211_su=
b_if_data *sdata,
 			return true;
 	}
=20
-	ieee80211_tx_stats(dev, skb->len + extra_head);
-
 	if ((hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) &&
 	    ieee80211_amsdu_aggregate(sdata, sta, fast_tx, skb))
 		return true;
@@ -3188,24 +3319,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_s=
ub_if_data *sdata,
 	info->flags =3D IEEE80211_TX_CTL_FIRST_FRAGMENT |
 		      IEEE80211_TX_CTL_DONTFRAG |
 		      (tid_tx ? IEEE80211_TX_CTL_AMPDU : 0);
-
-	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
-		*ieee80211_get_qos_ctl(hdr) =3D tid;
-		if (!sta->sta.txq[0])
-			hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, tid);
-	} else {
-		info->flags |=3D IEEE80211_TX_CTL_ASSIGN_SEQ;
-		hdr->seq_ctrl =3D cpu_to_le16(sdata->sequence_number);
-		sdata->sequence_number +=3D 0x10;
-	}
-
-	if (skb_shinfo(skb)->gso_size)
-		sta->tx_stats.msdu[tid] +=3D
-			DIV_ROUND_UP(skb->len, skb_shinfo(skb)->gso_size);
-	else
-		sta->tx_stats.msdu[tid]++;
-
-	info->hw_queue =3D sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
+	info->control.flags =3D IEEE80211_TX_CTRL_FAST_XMIT;
=20
 	__skb_queue_head_init(&tx.skbs);
=20
@@ -3215,9 +3329,6 @@ static bool ieee80211_xmit_fast(struct ieee80211_su=
b_if_data *sdata,
 	tx.sta =3D sta;
 	tx.key =3D fast_tx->key;
=20
-	if (fast_tx->key)
-		info->control.hw_key =3D &fast_tx->key->conf;
-
 	if (!ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
 		tx.skb =3D skb;
 		r =3D ieee80211_tx_h_rate_ctrl(&tx);
@@ -3231,31 +3342,11 @@ static bool ieee80211_xmit_fast(struct ieee80211_=
sub_if_data *sdata,
 		}
 	}
=20
-	/* statistics normally done by ieee80211_tx_h_stats (but that
-	 * has to consider fragmentation, so is more complex)
-	 */
-	sta->tx_stats.bytes[skb_get_queue_mapping(skb)] +=3D skb->len;
-	sta->tx_stats.packets[skb_get_queue_mapping(skb)]++;
-
-	if (fast_tx->pn_offs) {
-		u64 pn;
-		u8 *crypto_hdr =3D skb->data + fast_tx->pn_offs;
+	if (ieee80211_queue_skb(local, sdata, sta, skb))
+		return true;
=20
-		switch (fast_tx->key->conf.cipher) {
-		case WLAN_CIPHER_SUITE_CCMP:
-		case WLAN_CIPHER_SUITE_CCMP_256:
-		case WLAN_CIPHER_SUITE_GCMP:
-		case WLAN_CIPHER_SUITE_GCMP_256:
-			pn =3D atomic64_inc_return(&fast_tx->key->conf.tx_pn);
-			crypto_hdr[0] =3D pn;
-			crypto_hdr[1] =3D pn >> 8;
-			crypto_hdr[4] =3D pn >> 16;
-			crypto_hdr[5] =3D pn >> 24;
-			crypto_hdr[6] =3D pn >> 32;
-			crypto_hdr[7] =3D pn >> 40;
-			break;
-		}
-	}
+	ieee80211_xmit_fast_finish(sdata, sta, fast_tx->pn_offs,
+				   fast_tx->key, skb);
=20
 	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
 		sdata =3D container_of(sdata->bss,
@@ -3275,12 +3366,22 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee8=
0211_hw *hw,
 	struct sk_buff *skb =3D NULL;
 	struct fq *fq =3D &local->fq;
 	struct fq_tin *tin =3D &txqi->tin;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_tx_data tx;
+	ieee80211_tx_result r;
+
=20
 	spin_lock_bh(&fq->lock);
=20
 	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags))
 		goto out;
=20
+	/* Make sure fragments stay together. */
+	skb =3D __skb_dequeue(&txqi->frags);
+	if (skb)
+		goto out;
+
+begin:
 	skb =3D fq_tin_dequeue(fq, tin, fq_tin_dequeue_func);
 	if (!skb)
 		goto out;
@@ -3288,16 +3389,46 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee8=
0211_hw *hw,
 	ieee80211_set_skb_vif(skb, txqi);
=20
 	hdr =3D (struct ieee80211_hdr *)skb->data;
-	if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
+	info =3D IEEE80211_SKB_CB(skb);
+
+	memset(&tx, 0, sizeof(tx));
+	__skb_queue_head_init(&tx.skbs);
+	tx.local =3D local;
+	tx.skb =3D skb;
+	tx.sdata =3D vif_to_sdata(info->control.vif);
+
+	if (txq->sta)
+		tx.sta =3D container_of(txq->sta, struct sta_info, sta);
+
+	/*
+	 * The key can be removed while the packet was queued, so need to call
+	 * this here to get the current key.
+	 */
+	r =3D ieee80211_tx_h_select_key(&tx);
+	if (r !=3D TX_CONTINUE) {
+		ieee80211_free_txskb(&local->hw, skb);
+		goto begin;
+	}
+
+	if (txq->sta && info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) {
 		struct sta_info *sta =3D container_of(txq->sta, struct sta_info,
 						    sta);
-		struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
+		u8 pn_offs =3D 0;
=20
-		hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, txq->tid);
-		if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
-			info->flags |=3D IEEE80211_TX_CTL_AMPDU;
-		else
-			info->flags &=3D ~IEEE80211_TX_CTL_AMPDU;
+		if (tx.key &&
+		    (tx.key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV))
+			pn_offs =3D ieee80211_hdrlen(hdr->frame_control);
+
+		ieee80211_xmit_fast_finish(sta->sdata, sta, pn_offs,
+					   tx.key, skb);
+	} else {
+		if (invoke_tx_handlers_late(&tx))
+			goto begin;
+
+		skb =3D __skb_dequeue(&tx.skbs);
+
+		if (!skb_queue_empty(&tx.skbs))
+			skb_queue_splice_tail(&tx.skbs, &txqi->frags);
 	}
=20
 out:
@@ -3335,7 +3466,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *s=
kb,
 		fast_tx =3D rcu_dereference(sta->fast_tx);
=20
 		if (fast_tx &&
-		    ieee80211_xmit_fast(sdata, dev, sta, fast_tx, skb))
+		    ieee80211_xmit_fast(sdata, sta, fast_tx, skb))
 			goto out;
 	}
=20
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index b6865d8..8006f9a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3393,11 +3393,18 @@ void ieee80211_txq_get_depth(struct ieee80211_txq=
 *txq,
 			     unsigned long *byte_cnt)
 {
 	struct txq_info *txqi =3D to_txq_info(txq);
+	u32 frag_cnt =3D 0, frag_bytes =3D 0;
+	struct sk_buff *skb;
+
+	skb_queue_walk(&txqi->frags, skb) {
+		frag_cnt++;
+		frag_bytes +=3D skb->len;
+	}
=20
 	if (frame_cnt)
-		*frame_cnt =3D txqi->tin.backlog_packets;
+		*frame_cnt =3D txqi->tin.backlog_packets + frag_cnt;
=20
 	if (byte_cnt)
-		*byte_cnt =3D txqi->tin.backlog_bytes;
+		*byte_cnt =3D txqi->tin.backlog_bytes + frag_bytes;
 }
 EXPORT_SYMBOL(ieee80211_txq_get_depth);
--=20
2.9.3

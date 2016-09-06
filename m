Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:51721 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933433AbcIFLoh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 07:44:37 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v8] mac80211: Move reorder-sensitive TX handlers to after TXQ
        dequeue.
Date: Tue,  6 Sep 2016 13:44:26 +0200
Message-Id: <20160906114426.25520-1-toke@toke.dk> (sfid-20160906_134448_323258_743B2762)
In-Reply-To: <20160905113042.22271-1-toke@toke.dk>
References: <20160905113042.22271-1-toke@toke.dk>
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

This approach avoids having to scatter special cases for when TXQ is
enabled, at the cost of making the fast_xmit and TX handler code
slightly more complex.

Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
---
Changes since v8:
- Don't rely on the fast_tx pointer on TXQ dequeue; it can go away while
  the packet was queued, and we don't actually need it, since we can get
  the key configuration and offset from the packet info.

 include/net/mac80211.h     |   2 +
 net/mac80211/ieee80211_i.h |   2 +
 net/mac80211/tx.c          | 255 +++++++++++++++++++++++++++++++++------=
------
 3 files changed, 195 insertions(+), 64 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cca510a..9a6a3e9 100644
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
index 9211cce..d36f3b1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -813,11 +813,13 @@ enum txq_info_flags {
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
+	struct sk_buff_head frags;
 	unsigned long flags;
=20
 	/* keep last! */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index efc38e7..f8eec60 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -38,6 +38,12 @@
 #include "wme.h"
 #include "rate.h"
=20
+static int invoke_tx_handlers_late(struct ieee80211_tx_data *tx);
+static bool ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sda=
ta,
+				       struct sta_info *sta, u8 pn_offs,
+				       struct ieee80211_key_conf *key_conf,
+				       struct sk_buff *skb);
+
 /* misc utils */
=20
 static inline void ieee80211_tx_stats(struct net_device *dev, u32 len)
@@ -853,8 +859,7 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 	tid =3D *qc & IEEE80211_QOS_CTL_TID_MASK;
 	tx->sta->tx_stats.msdu[tid]++;
=20
-	if (!tx->sta->sta.txq[0])
-		hdr->seq_ctrl =3D ieee80211_tx_next_seq(tx->sta, tid);
+	hdr->seq_ctrl =3D ieee80211_tx_next_seq(tx->sta, tid);
=20
 	return TX_CONTINUE;
 }
@@ -1403,6 +1408,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_dat=
a *sdata,
 	fq_tin_init(&txqi->tin);
 	fq_flow_init(&txqi->def_flow);
 	codel_vars_init(&txqi->def_cvars);
+	__skb_queue_head_init(&txqi->frags);
=20
 	txqi->txq.vif =3D &sdata->vif;
=20
@@ -1425,6 +1431,7 @@ void ieee80211_txq_purge(struct ieee80211_local *lo=
cal,
 	struct fq_tin *tin =3D &txqi->tin;
=20
 	fq_tin_reset(fq, tin, fq_skb_free_func);
+	ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
 }
=20
 int ieee80211_txq_setup_flows(struct ieee80211_local *local)
@@ -1485,12 +1492,19 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee8=
0211_hw *hw,
 	struct sk_buff *skb =3D NULL;
 	struct fq *fq =3D &local->fq;
 	struct fq_tin *tin =3D &txqi->tin;
+	struct ieee80211_tx_info *info;
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
@@ -1498,16 +1512,37 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee8=
0211_hw *hw,
 	ieee80211_set_skb_vif(skb, txqi);
=20
 	hdr =3D (struct ieee80211_hdr *)skb->data;
-	if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
+	info =3D IEEE80211_SKB_CB(skb);
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
+		if (info->control.hw_key)
+			pn_offs =3D ieee80211_hdrlen(hdr->frame_control);
+
+		ieee80211_xmit_fast_finish(sta->sdata, sta, pn_offs,
+					   info->control.hw_key, skb);
+	} else {
+		struct ieee80211_tx_data tx =3D { };
+
+		__skb_queue_head_init(&tx.skbs);
+		tx.local =3D local;
+		tx.skb =3D skb;
+		if (txq->sta) {
+			tx.sta =3D container_of(txq->sta, struct sta_info, sta);
+			tx.sdata =3D tx.sta->sdata;
+		} else {
+			tx.sdata =3D vif_to_sdata(info->control.vif);
+		}
+
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
@@ -1521,6 +1556,47 @@ out:
 }
 EXPORT_SYMBOL(ieee80211_tx_dequeue);
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
@@ -1528,9 +1604,7 @@ static bool ieee80211_tx_frags(struct ieee80211_loc=
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
@@ -1545,21 +1619,6 @@ static bool ieee80211_tx_frags(struct ieee80211_lo=
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
@@ -1680,10 +1739,13 @@ static bool __ieee80211_tx(struct ieee80211_local=
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
@@ -1697,16 +1759,42 @@ static int invoke_tx_handlers(struct ieee80211_tx=
_data *tx)
 	CALL_TXH(ieee80211_tx_h_check_assoc);
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_check_control_port_protocol);
-	CALL_TXH(ieee80211_tx_h_select_key);
+
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
 		goto txh_done;
 	}
=20
+	CALL_TXH(ieee80211_tx_h_select_key);
 	CALL_TXH(ieee80211_tx_h_michael_mic_add);
 	CALL_TXH(ieee80211_tx_h_sequence);
 	CALL_TXH(ieee80211_tx_h_fragment);
@@ -1733,6 +1821,15 @@ static int invoke_tx_handlers(struct ieee80211_tx_=
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
@@ -1807,7 +1904,13 @@ static bool ieee80211_tx(struct ieee80211_sub_if_d=
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
@@ -3159,7 +3262,7 @@ out:
 }
=20
 static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
-				struct net_device *dev, struct sta_info *sta,
+				struct sta_info *sta,
 				struct ieee80211_fast_tx *fast_tx,
 				struct sk_buff *skb)
 {
@@ -3170,9 +3273,9 @@ static bool ieee80211_xmit_fast(struct ieee80211_su=
b_if_data *sdata,
 	struct ethhdr eth;
 	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr =3D (void *)fast_tx->hdr;
-	struct ieee80211_tx_data tx;
-	ieee80211_tx_result r;
 	struct tid_ampdu_tx *tid_tx =3D NULL;
+	ieee80211_tx_result r;
+	struct ieee80211_tx_data tx;
 	u8 tid =3D IEEE80211_NUM_TIDS;
=20
 	/* control port protocol needs a lot of special handling */
@@ -3210,8 +3313,6 @@ static bool ieee80211_xmit_fast(struct ieee80211_su=
b_if_data *sdata,
 			return true;
 	}
=20
-	ieee80211_tx_stats(dev, skb->len + extra_head);
-
 	if ((hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) &&
 	    ieee80211_amsdu_aggregate(sdata, sta, fast_tx, skb))
 		return true;
@@ -3240,24 +3341,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_s=
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
@@ -3283,22 +3367,71 @@ static bool ieee80211_xmit_fast(struct ieee80211_=
sub_if_data *sdata,
 		}
 	}
=20
+	if (ieee80211_queue_skb(local, sdata, sta, skb))
+		return true;
+
+	ieee80211_xmit_fast_finish(sdata, sta, fast_tx->pn_offs,
+				   &fast_tx->key->conf, skb);
+
+	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
+		sdata =3D container_of(sdata->bss,
+				     struct ieee80211_sub_if_data, u.ap);
+
+	__skb_queue_tail(&tx.skbs, skb);
+	ieee80211_tx_frags(local, &sdata->vif, &sta->sta, &tx.skbs, false);
+
+	return true;
+}
+
+/*
+ * Can be called while the sta lock is held. Anything that can cause pac=
kets to
+ * be generated will cause deadlock!
+ */
+static bool ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sda=
ta,
+				       struct sta_info *sta, u8 pn_offs,
+				       struct ieee80211_key_conf *key_conf,
+				       struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr =3D (void *)skb->data;
+	u8 tid =3D IEEE80211_NUM_TIDS;
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
 	/* statistics normally done by ieee80211_tx_h_stats (but that
 	 * has to consider fragmentation, so is more complex)
 	 */
 	sta->tx_stats.bytes[skb_get_queue_mapping(skb)] +=3D skb->len;
 	sta->tx_stats.packets[skb_get_queue_mapping(skb)]++;
=20
-	if (fast_tx->pn_offs) {
+	if (pn_offs) {
 		u64 pn;
-		u8 *crypto_hdr =3D skb->data + fast_tx->pn_offs;
+		u8 *crypto_hdr =3D skb->data + pn_offs;
=20
-		switch (fast_tx->key->conf.cipher) {
+		switch (key_conf->cipher) {
 		case WLAN_CIPHER_SUITE_CCMP:
 		case WLAN_CIPHER_SUITE_CCMP_256:
 		case WLAN_CIPHER_SUITE_GCMP:
 		case WLAN_CIPHER_SUITE_GCMP_256:
-			pn =3D atomic64_inc_return(&fast_tx->key->conf.tx_pn);
+			pn =3D atomic64_inc_return(&key_conf->tx_pn);
 			crypto_hdr[0] =3D pn;
 			crypto_hdr[1] =3D pn >> 8;
 			crypto_hdr[4] =3D pn >> 16;
@@ -3309,12 +3442,6 @@ static bool ieee80211_xmit_fast(struct ieee80211_s=
ub_if_data *sdata,
 		}
 	}
=20
-	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
-		sdata =3D container_of(sdata->bss,
-				     struct ieee80211_sub_if_data, u.ap);
-
-	__skb_queue_tail(&tx.skbs, skb);
-	ieee80211_tx_frags(local, &sdata->vif, &sta->sta, &tx.skbs, false);
 	return true;
 }
=20
@@ -3342,7 +3469,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *s=
kb,
 		fast_tx =3D rcu_dereference(sta->fast_tx);
=20
 		if (fast_tx &&
-		    ieee80211_xmit_fast(sdata, dev, sta, fast_tx, skb))
+		    ieee80211_xmit_fast(sdata, sta, fast_tx, skb))
 			goto out;
 	}
=20
--=20
2.9.3

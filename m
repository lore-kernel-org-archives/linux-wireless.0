Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:49624 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756165AbcHXQVj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Aug 2016 12:21:39 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v3] mac80211: Move reorder-sensitive TX handlers to after TXQ
        dequeue.
Date: Wed, 24 Aug 2016 18:20:15 +0200
Message-Id: <20160824162015.29933-1-toke@toke.dk> (sfid-20160824_182146_094456_16ECF5E3)
In-Reply-To: <20160817144531.4285-1-toke@toke.dk>
References: <20160817144531.4285-1-toke@toke.dk>
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

To avoid having to deal with fragmentation on dequeue, the split is set
to be after the fragmentation handler. This means that some reordering
of TX handlers is necessary, and some handlers had to be made aware of
fragmentation due to this reordering.

This approach avoids having to scatter special cases for when TXQ is
enabled, at the cost of making the fast_xmit and TX handler code
slightly more complex.

Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
---
Changes since v2:

This is a completely different approach: Instead of adding exceptions
for TXQ handling, split up the entire TX path in an early and late part,
and apply the latter after TXQ dequeue. This should fix things that
don't hit the fast path as well.

I've tested this with both unencrypted traffic and with CCMP and TKIP
and it appears to fix the previous performance regression seen with
softq-enabled ath9k. I most likely haven't hit all code paths, though
(not sure how I would even go about ensuring that), but looks promising
so far.

 include/net/mac80211.h |   2 +
 net/mac80211/tx.c      | 276 ++++++++++++++++++++++++++++++++++++++-----=
------
 net/mac80211/wpa.c     |  18 +++-
 3 files changed, 235 insertions(+), 61 deletions(-)

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
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1d0746d..7042d2c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -38,6 +38,12 @@
 #include "wme.h"
 #include "rate.h"
=20
+static int invoke_tx_handlers_late(struct ieee80211_tx_data *tx);
+static bool ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sda=
ta,
+				       struct sta_info *sta,
+				       struct ieee80211_fast_tx *fast_tx,
+				       struct sk_buff *skb, bool xmit);
+
 /* misc utils */
=20
 static inline void ieee80211_tx_stats(struct net_device *dev, u32 len)
@@ -585,20 +591,27 @@ static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_key *key;
-	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(tx->skb);
-	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)tx->skb->data;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_hdr *hdr;
+	struct sk_buff *skb =3D tx->skb;
+
+	if (!skb)
+		skb =3D skb_peek(&tx->skbs);
+
+	info =3D IEEE80211_SKB_CB(skb);
+	hdr =3D (struct ieee80211_hdr *)skb->data;
=20
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT))
 		tx->key =3D NULL;
 	else if (tx->sta &&
 		 (key =3D rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx])))
 		tx->key =3D key;
-	else if (ieee80211_is_group_privacy_action(tx->skb) &&
+	else if (ieee80211_is_group_privacy_action(skb) &&
 		(key =3D rcu_dereference(tx->sdata->default_multicast_key)))
 		tx->key =3D key;
 	else if (ieee80211_is_mgmt(hdr->frame_control) &&
 		 is_multicast_ether_addr(hdr->addr1) &&
-		 ieee80211_is_robust_mgmt_frame(tx->skb) &&
+		 ieee80211_is_robust_mgmt_frame(skb) &&
 		 (key =3D rcu_dereference(tx->sdata->default_mgmt_key)))
 		tx->key =3D key;
 	else if (is_multicast_ether_addr(hdr->addr1) &&
@@ -628,8 +641,8 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *t=
x)
 		case WLAN_CIPHER_SUITE_GCMP_256:
 			if (!ieee80211_is_data_present(hdr->frame_control) &&
 			    !ieee80211_use_mfp(hdr->frame_control, tx->sta,
-					       tx->skb) &&
-			    !ieee80211_is_group_privacy_action(tx->skb))
+					       skb) &&
+			    !ieee80211_is_group_privacy_action(skb))
 				tx->key =3D NULL;
 			else
 				skip_hw =3D (tx->key->conf.flags &
@@ -799,10 +812,12 @@ static __le16 ieee80211_tx_next_seq(struct sta_info=
 *sta, int tid)
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(tx->skb);
-	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)tx->skb->data;
+	struct sk_buff *skb =3D skb_peek(&tx->skbs);
+	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)skb->data;
 	u8 *qc;
 	int tid;
+	u16 fragnum, seq;
=20
 	/*
 	 * Packet injection may want to control the sequence
@@ -829,10 +844,16 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *t=
x)
 	 */
 	if (!ieee80211_is_data_qos(hdr->frame_control) ||
 	    is_multicast_ether_addr(hdr->addr1)) {
-		/* driver should assign sequence number */
-		info->flags |=3D IEEE80211_TX_CTL_ASSIGN_SEQ;
-		/* for pure STA mode without beacons, we can do it */
-		hdr->seq_ctrl =3D cpu_to_le16(tx->sdata->sequence_number);
+		fragnum =3D 0;
+		seq =3D cpu_to_le16(tx->sdata->sequence_number);
+		skb_queue_walk(&tx->skbs, skb) {
+			info =3D IEEE80211_SKB_CB(skb);
+			hdr =3D (struct ieee80211_hdr *)skb->data;
+			/* driver should assign sequence number */
+			info->flags |=3D IEEE80211_TX_CTL_ASSIGN_SEQ;
+			/* for pure STA mode without beacons, we can do it */
+			hdr->seq_ctrl =3D seq | fragnum++;
+		}
 		tx->sdata->sequence_number +=3D 0x10;
 		if (tx->sta)
 			tx->sta->tx_stats.msdu[IEEE80211_NUM_TIDS]++;
@@ -853,8 +874,14 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx=
)
 	tid =3D *qc & IEEE80211_QOS_CTL_TID_MASK;
 	tx->sta->tx_stats.msdu[tid]++;
=20
-	if (!tx->sta->sta.txq[0])
-		hdr->seq_ctrl =3D ieee80211_tx_next_seq(tx->sta, tid);
+	if (!tx->sta->sta.txq[0]) {
+		seq =3D ieee80211_tx_next_seq(tx->sta, tid);
+		fragnum =3D 0;
+		skb_queue_walk(&tx->skbs, skb) {
+			hdr =3D (struct ieee80211_hdr *)skb->data;
+			hdr->seq_ctrl =3D seq | fragnum++;
+		}
+	}
=20
 	return TX_CONTINUE;
 }
@@ -927,7 +954,6 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 	struct ieee80211_hdr *hdr =3D (void *)skb->data;
 	int frag_threshold =3D tx->local->hw.wiphy->frag_threshold;
 	int hdrlen;
-	int fragnum;
=20
 	/* no matter what happens, tx->skb moves to tx->skbs */
 	__skb_queue_tail(&tx->skbs, skb);
@@ -964,9 +990,6 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 	if (ieee80211_fragment(tx, skb, hdrlen, frag_threshold))
 		return TX_DROP;
=20
-	/* update duration/seq/flags of fragments */
-	fragnum =3D 0;
-
 	skb_queue_walk(&tx->skbs, skb) {
 		const __le16 morefrags =3D cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
=20
@@ -987,8 +1010,6 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx=
)
 		} else {
 			hdr->frame_control &=3D ~morefrags;
 		}
-		hdr->seq_ctrl |=3D cpu_to_le16(fragnum & IEEE80211_SCTL_FRAG);
-		fragnum++;
 	}
=20
 	return TX_CONTINUE;
@@ -1481,33 +1502,59 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee8=
0211_hw *hw,
 {
 	struct ieee80211_local *local =3D hw_to_local(hw);
 	struct txq_info *txqi =3D container_of(txq, struct txq_info, txq);
-	struct ieee80211_hdr *hdr;
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
+begin:
 	skb =3D fq_tin_dequeue(fq, tin, fq_tin_dequeue_func);
 	if (!skb)
 		goto out;
=20
 	ieee80211_set_skb_vif(skb, txqi);
=20
-	hdr =3D (struct ieee80211_hdr *)skb->data;
-	if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
+	info =3D IEEE80211_SKB_CB(skb);
+	if (txq->sta && info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) {
 		struct sta_info *sta =3D container_of(txq->sta, struct sta_info,
 						    sta);
-		struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
+		struct ieee80211_fast_tx *fast_tx;
=20
-		hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, txq->tid);
-		if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
-			info->flags |=3D IEEE80211_TX_CTL_AMPDU;
-		else
-			info->flags &=3D ~IEEE80211_TX_CTL_AMPDU;
+		fast_tx =3D rcu_dereference(sta->fast_tx);
+		if (!fast_tx ||
+		    !ieee80211_xmit_fast_finish(sta->sdata, sta, fast_tx, skb,
+						false)) {
+			/* fast xmit was started, but fails to finish */
+			ieee80211_free_txskb(hw, skb);
+			goto begin;
+		}
+	} else {
+		struct ieee80211_tx_data tx =3D { };
+
+		__skb_queue_head_init(&tx.skbs);
+		tx.local =3D local;
+		if (txq->sta) {
+			struct sta_info *sta =3D container_of(txq->sta,
+							    struct sta_info,
+							    sta);
+			tx.sta =3D container_of(txq->sta, struct sta_info, sta);
+			tx.sdata =3D sta->sdata;
+		} else {
+			tx.sdata =3D container_of(info->control.vif,
+					struct ieee80211_sub_if_data, vif);
+		}
+
+		__skb_queue_tail(&tx.skbs, skb);
+
+		if (invoke_tx_handlers_late(&tx))
+			goto begin;
+
+		__skb_unlink(skb, &tx.skbs);
 	}
=20
 out:
@@ -1521,6 +1568,77 @@ out:
 }
 EXPORT_SYMBOL(ieee80211_tx_dequeue);
=20
+static bool ieee80211_queue_skb(struct ieee80211_local *local,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta,
+				struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
+	struct fq *fq =3D &local->fq;
+	struct txq_info *txqi =3D ieee80211_get_txq(local, vif, sta, skb);
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
+static bool ieee80211_queue_frags(struct ieee80211_local *local,
+				  struct sta_info *sta,
+				  struct sk_buff_head *skbs)
+{
+	struct txq_info *txqi;
+	struct sk_buff *skb, *tmp;
+	struct ieee80211_tx_info *info;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_vif *vif;
+	struct ieee80211_sta *pubsta;
+
+	if (WARN_ON(skb_queue_empty(skbs)))
+		return true;
+
+	skb =3D skb_peek(skbs);
+	info =3D IEEE80211_SKB_CB(skb);
+	sdata =3D vif_to_sdata(info->control.vif);
+	if (sta && !sta->uploaded)
+		sta =3D NULL;
+
+	if (sta)
+		pubsta =3D &sta->sta;
+	else
+		pubsta =3D NULL;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_MONITOR:
+		return false;
+	case NL80211_IFTYPE_AP_VLAN:
+		sdata =3D container_of(sdata->bss,
+				     struct ieee80211_sub_if_data, u.ap);
+		/* fall through */
+	default:
+		vif =3D &sdata->vif;
+		break;
+	}
+
+	skb_queue_walk_safe(skbs, skb, tmp) {
+		txqi =3D ieee80211_get_txq(local, vif, pubsta, skb);
+		if (txqi) {
+			__skb_unlink(skb, skbs);
+			ieee80211_queue_skb(local, vif, pubsta, skb);
+		}
+	}
+
+	return !!skb_queue_empty(skbs);
+}
+
 static bool ieee80211_tx_frags(struct ieee80211_local *local,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
@@ -1528,9 +1646,7 @@ static bool ieee80211_tx_frags(struct ieee80211_loc=
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
@@ -1545,21 +1661,6 @@ static bool ieee80211_tx_frags(struct ieee80211_lo=
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
@@ -1680,8 +1781,12 @@ static bool __ieee80211_tx(struct ieee80211_local =
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
 	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(tx->skb);
 	ieee80211_tx_result res =3D TX_DROP;
@@ -1697,7 +1802,6 @@ static int invoke_tx_handlers(struct ieee80211_tx_d=
ata *tx)
 	CALL_TXH(ieee80211_tx_h_check_assoc);
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_check_control_port_protocol);
-	CALL_TXH(ieee80211_tx_h_select_key);
 	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
=20
@@ -1706,11 +1810,32 @@ static int invoke_tx_handlers(struct ieee80211_tx=
_data *tx)
 		tx->skb =3D NULL;
 		goto txh_done;
 	}
+	CALL_TXH(ieee80211_tx_h_fragment);
+
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
=20
+	return 0;
+}
+
+static int invoke_tx_handlers_late(struct ieee80211_tx_data *tx)
+{
+	ieee80211_tx_result res =3D TX_DROP;
+
+	/* late tx handlers must be aware of tx info fragmentation! */
+	CALL_TXH(ieee80211_tx_h_select_key);
 	CALL_TXH(ieee80211_tx_h_michael_mic_add);
 	CALL_TXH(ieee80211_tx_h_sequence);
-	CALL_TXH(ieee80211_tx_h_fragment);
-	/* handlers after fragment must be aware of tx info fragmentation! */
 	CALL_TXH(ieee80211_tx_h_stats);
 	CALL_TXH(ieee80211_tx_h_encrypt);
 	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
@@ -1733,6 +1858,11 @@ static int invoke_tx_handlers(struct ieee80211_tx_=
data *tx)
 	return 0;
 }
=20
+static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
+{
+	return invoke_tx_handlers_early(tx) || invoke_tx_handlers_late(tx);
+}
+
 bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif, struct sk_buff *skb,
 			      int band, struct ieee80211_sta **sta)
@@ -1782,7 +1912,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_da=
ta *sdata,
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
-	bool result =3D true;
+	bool result =3D true, queue =3D !!(local->ops->wake_tx_queue);
 	int led_len;
=20
 	if (unlikely(skb->len < 10)) {
@@ -1807,7 +1937,13 @@ static bool ieee80211_tx(struct ieee80211_sub_if_d=
ata *sdata,
 		info->hw_queue =3D
 			sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
=20
-	if (!invoke_tx_handlers(&tx))
+	if (invoke_tx_handlers_early(&tx))
+		return false;
+
+	if (queue && ieee80211_queue_frags(local, tx.sta, &tx.skbs))
+		return true;
+
+	if (!invoke_tx_handlers_late(&tx))
 		result =3D __ieee80211_tx(local, &tx.skbs, led_len,
 					tx.sta, txpending);
=20
@@ -3170,10 +3306,9 @@ static bool ieee80211_xmit_fast(struct ieee80211_s=
ub_if_data *sdata,
 	struct ethhdr eth;
 	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr =3D (void *)fast_tx->hdr;
-	struct ieee80211_tx_data tx;
-	ieee80211_tx_result r;
 	struct tid_ampdu_tx *tid_tx =3D NULL;
 	u8 tid =3D IEEE80211_NUM_TIDS;
+	bool queue =3D !!(local->ops->wake_tx_queue);
=20
 	/* control port protocol needs a lot of special handling */
 	if (cpu_to_be16(ethertype) =3D=3D sdata->control_port_protocol)
@@ -3240,8 +3375,32 @@ static bool ieee80211_xmit_fast(struct ieee80211_s=
ub_if_data *sdata,
 	info->flags =3D IEEE80211_TX_CTL_FIRST_FRAGMENT |
 		      IEEE80211_TX_CTL_DONTFRAG |
 		      (tid_tx ? IEEE80211_TX_CTL_AMPDU : 0);
+	info->control.flags =3D IEEE80211_TX_CTRL_FAST_XMIT;
+
+	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
+		sdata =3D container_of(sdata->bss,
+				     struct ieee80211_sub_if_data, u.ap);
+
+	if (queue && ieee80211_queue_skb(local, &sdata->vif, &sta->sta, skb))
+		return true;
+
+	return ieee80211_xmit_fast_finish(sdata, sta, fast_tx, skb, true);
+}
+
+static bool ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sda=
ta,
+				       struct sta_info *sta,
+				       struct ieee80211_fast_tx *fast_tx,
+				       struct sk_buff *skb, bool xmit)
+{
+	struct ieee80211_local *local =3D sdata->local;
+	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr =3D (void *)fast_tx->hdr;
+	struct ieee80211_tx_data tx;
+	ieee80211_tx_result r;
+	u8 tid =3D IEEE80211_NUM_TIDS;
=20
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
+		tid =3D skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 		*ieee80211_get_qos_ctl(hdr) =3D tid;
 		if (!sta->sta.txq[0])
 			hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, tid);
@@ -3309,12 +3468,11 @@ static bool ieee80211_xmit_fast(struct ieee80211_=
sub_if_data *sdata,
 		}
 	}
=20
-	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
-		sdata =3D container_of(sdata->bss,
-				     struct ieee80211_sub_if_data, u.ap);
+	if (xmit) {
+		__skb_queue_tail(&tx.skbs, skb);
+		ieee80211_tx_frags(local, &sdata->vif, &sta->sta, &tx.skbs, false);
+	}
=20
-	__skb_queue_tail(&tx.skbs, skb);
-	ieee80211_tx_frags(local, &sdata->vif, &sta->sta, &tx.skbs, false);
 	return true;
 }
=20
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index b48c1e1..71c479a 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -28,13 +28,13 @@
 #include "wpa.h"
=20
 ieee80211_tx_result
-ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
+ieee80211_tx_h_michael_mic_add_skb(struct ieee80211_tx_data *tx,
+				   struct sk_buff *skb)
 {
 	u8 *data, *key, *mic;
 	size_t data_len;
 	unsigned int hdrlen;
 	struct ieee80211_hdr *hdr;
-	struct sk_buff *skb =3D tx->skb;
 	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
 	int tail;
=20
@@ -83,6 +83,20 @@ ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_dat=
a *tx)
 	return TX_CONTINUE;
 }
=20
+ieee80211_tx_result
+ieee80211_tx_h_michael_mic_add(struct ieee80211_tx_data *tx)
+{
+	struct sk_buff *skb;
+	ieee80211_tx_result r;
+
+	skb_queue_walk(&tx->skbs, skb) {
+		r =3D ieee80211_tx_h_michael_mic_add_skb(tx, skb);
+		if (r !=3D TX_CONTINUE)
+			return r;
+	}
+	return TX_CONTINUE;
+}
+
=20
 ieee80211_rx_result
 ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
--=20
2.9.3

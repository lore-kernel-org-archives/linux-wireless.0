Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:35041 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934058AbcIAQFE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 12:05:04 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v5] mac80211: Move reorder-sensitive TX handlers to after TXQ
        dequeue.
Date: Thu,  1 Sep 2016 18:03:12 +0200
Message-Id: <20160901160312.31540-1-toke@toke.dk> (sfid-20160901_180539_629379_96553E29)
In-Reply-To: <20160830131548.6014-1-toke@toke.dk>
References: <20160830131548.6014-1-toke@toke.dk>
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
Changes since v4:
- Keep fragnum assignment in fragmentation handler and fix endianness
  issues in seqno handler.
- Assume xmit_fast_finish can't fail in dequeue handler (and warn if
  fast_tx handle disappears).
- Move TKIP MIC and key selection handlers back before fragmentation
  handler. Turns out the MIC doesn't actually depend on a global
  sequence number, so it can be before the intermediate queueing step.
  The only cost of this is running the key selection handler twice in
  some cases.
- Improve readability of the composite invoke_tx_handlers() function.


 include/net/mac80211.h |   2 +
 net/mac80211/tx.c      | 266 +++++++++++++++++++++++++++++++++++++++----=
------
 2 files changed, 214 insertions(+), 54 deletions(-)

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
index 1d0746d..f7373c2 100644
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
+	__le16 seq;
=20
 	/*
 	 * Packet injection may want to control the sequence
@@ -829,10 +844,15 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *t=
x)
 	 */
 	if (!ieee80211_is_data_qos(hdr->frame_control) ||
 	    is_multicast_ether_addr(hdr->addr1)) {
-		/* driver should assign sequence number */
-		info->flags |=3D IEEE80211_TX_CTL_ASSIGN_SEQ;
-		/* for pure STA mode without beacons, we can do it */
-		hdr->seq_ctrl =3D cpu_to_le16(tx->sdata->sequence_number);
+		seq =3D cpu_to_le16(tx->sdata->sequence_number);
+		skb_queue_walk(&tx->skbs, skb) {
+			info =3D IEEE80211_SKB_CB(skb);
+			hdr =3D (struct ieee80211_hdr *)skb->data;
+			/* driver should assign sequence number */
+			info->flags |=3D IEEE80211_TX_CTL_ASSIGN_SEQ;
+			/* for pure STA mode without beacons, we can do it */
+			hdr->seq_ctrl |=3D seq;
+		}
 		tx->sdata->sequence_number +=3D 0x10;
 		if (tx->sta)
 			tx->sta->tx_stats.msdu[IEEE80211_NUM_TIDS]++;
@@ -853,8 +873,13 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx=
)
 	tid =3D *qc & IEEE80211_QOS_CTL_TID_MASK;
 	tx->sta->tx_stats.msdu[tid]++;
=20
-	if (!tx->sta->sta.txq[0])
-		hdr->seq_ctrl =3D ieee80211_tx_next_seq(tx->sta, tid);
+	if (!tx->sta->sta.txq[0]) {
+		seq =3D ieee80211_tx_next_seq(tx->sta, tid);
+		skb_queue_walk(&tx->skbs, skb) {
+			hdr =3D (struct ieee80211_hdr *)skb->data;
+			hdr->seq_ctrl |=3D seq;
+		}
+	}
=20
 	return TX_CONTINUE;
 }
@@ -1481,33 +1506,57 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee8=
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
+		if (WARN_ON(!fast_tx)) {
+			/* lost the fast_tx pointer while the packet was queued */
+			ieee80211_free_txskb(hw, skb);
+			goto begin;
+		}
+		ieee80211_xmit_fast_finish(sta->sdata, sta, fast_tx, skb, false);
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
+			tx.sdata =3D vif_to_sdata(info->control.vif);
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
@@ -1521,6 +1570,71 @@ out:
 }
 EXPORT_SYMBOL(ieee80211_tx_dequeue);
=20
+static bool ieee80211_queue_skb(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
+				struct ieee80211_sta *sta,
+				struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
+	struct fq *fq =3D &local->fq;
+	struct ieee80211_vif *vif;
+	struct txq_info *txqi;
+
+	if (!local->ops->wake_tx_queue)
+		return false;
+
+	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
+		sdata =3D container_of(sdata->bss,
+				struct ieee80211_sub_if_data, u.ap);
+
+	vif =3D &sdata->vif;
+	txqi =3D ieee80211_get_txq(local, vif, sta, skb);
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
+				  struct ieee80211_sub_if_data *sdata,
+				  struct sta_info *sta,
+				  struct sk_buff_head *skbs)
+{
+	struct sk_buff *skb;
+	struct ieee80211_sta *pubsta;
+
+	if (WARN_ON(skb_queue_empty(skbs)))
+		return true;
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
+	while (!skb_queue_empty(skbs)) {
+		skb =3D __skb_dequeue(skbs);
+		if (unlikely(!ieee80211_queue_skb(local, sdata, pubsta, skb))) {
+			__skb_queue_head(skbs, skb);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 static bool ieee80211_tx_frags(struct ieee80211_local *local,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
@@ -1528,9 +1642,7 @@ static bool ieee80211_tx_frags(struct ieee80211_loc=
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
@@ -1545,21 +1657,6 @@ static bool ieee80211_tx_frags(struct ieee80211_lo=
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
@@ -1680,8 +1777,12 @@ static bool __ieee80211_tx(struct ieee80211_local =
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
@@ -1708,9 +1807,32 @@ static int invoke_tx_handlers(struct ieee80211_tx_=
data *tx)
 	}

 	CALL_TXH(ieee80211_tx_h_michael_mic_add);
-	CALL_TXH(ieee80211_tx_h_sequence);
 	CALL_TXH(ieee80211_tx_h_fragment);
-	/* handlers after fragment must be aware of tx info fragmentation! */
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
+
+	return 0;
+}
+
+/* late tx handlers must be aware of tx info fragmentation! */
+static int invoke_tx_handlers_late(struct ieee80211_tx_data *tx)
+{
+	ieee80211_tx_result res =3D TX_DROP;
+
+	if (!tx->key) /* Not set unless early and late handlers where chained. =
*/
+		CALL_TXH(ieee80211_tx_h_select_key);
+	CALL_TXH(ieee80211_tx_h_sequence);
 	CALL_TXH(ieee80211_tx_h_stats);
 	CALL_TXH(ieee80211_tx_h_encrypt);
 	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
@@ -1733,6 +1856,15 @@ static int invoke_tx_handlers(struct ieee80211_tx_=
data *tx)
 	return 0;
 }
=20
+static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
+{
+	int r =3D invoke_tx_handlers_early(tx);
+	if (r)
+		return r;
+
+	return invoke_tx_handlers_late(tx);
+}
+
 bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif, struct sk_buff *skb,
 			      int band, struct ieee80211_sta **sta)
@@ -1807,7 +1939,13 @@ static bool ieee80211_tx(struct ieee80211_sub_if_d=
ata *sdata,
 		info->hw_queue =3D
 			sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
=20
-	if (!invoke_tx_handlers(&tx))
+	if (invoke_tx_handlers_early(&tx))
+		return false;
+
+	if (ieee80211_queue_frags(local, sdata, tx.sta, &tx.skbs))
+		return true;
+
+	if (!invoke_tx_handlers_late(&tx))
 		result =3D __ieee80211_tx(local, &tx.skbs, led_len,
 					tx.sta, txpending);
=20
@@ -3170,8 +3308,6 @@ static bool ieee80211_xmit_fast(struct ieee80211_su=
b_if_data *sdata,
 	struct ethhdr eth;
 	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr =3D (void *)fast_tx->hdr;
-	struct ieee80211_tx_data tx;
-	ieee80211_tx_result r;
 	struct tid_ampdu_tx *tid_tx =3D NULL;
 	u8 tid =3D IEEE80211_NUM_TIDS;
=20
@@ -3240,11 +3376,30 @@ static bool ieee80211_xmit_fast(struct ieee80211_=
sub_if_data *sdata,
 	info->flags =3D IEEE80211_TX_CTL_FIRST_FRAGMENT |
 		      IEEE80211_TX_CTL_DONTFRAG |
 		      (tid_tx ? IEEE80211_TX_CTL_AMPDU : 0);
+	info->control.flags =3D IEEE80211_TX_CTRL_FAST_XMIT;
+
+	if (ieee80211_queue_skb(local, sdata, &sta->sta, skb))
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
+	struct ieee80211_hdr *hdr =3D (void *)skb->data;
+	struct ieee80211_tx_data tx;
+	ieee80211_tx_result r;
+	u8 tid =3D IEEE80211_NUM_TIDS;
=20
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
+		tid =3D skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 		*ieee80211_get_qos_ctl(hdr) =3D tid;
-		if (!sta->sta.txq[0])
-			hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, tid);
+		hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, tid);
 	} else {
 		info->flags |=3D IEEE80211_TX_CTL_ASSIGN_SEQ;
 		hdr->seq_ctrl =3D cpu_to_le16(sdata->sequence_number);
@@ -3309,12 +3464,15 @@ static bool ieee80211_xmit_fast(struct ieee80211_=
sub_if_data *sdata,
 		}
 	}
=20
-	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
-		sdata =3D container_of(sdata->bss,
-				     struct ieee80211_sub_if_data, u.ap);
+	if (xmit) {
+		if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
+			sdata =3D container_of(sdata->bss,
+					struct ieee80211_sub_if_data, u.ap);
+
+		__skb_queue_tail(&tx.skbs, skb);
+		ieee80211_tx_frags(local, &sdata->vif, &sta->sta, &tx.skbs, false);
+	}
=20
-	__skb_queue_tail(&tx.skbs, skb);
-	ieee80211_tx_frags(local, &sdata->vif, &sta->sta, &tx.skbs, false);
 	return true;
 }
=20
--=20
2.9.3

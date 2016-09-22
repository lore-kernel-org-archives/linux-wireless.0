Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:60207 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934155AbcIVREx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 13:04:53 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v9 1/2] mac80211: Move ieee802111_tx_dequeue() to later in tx.c
Date: Thu, 22 Sep 2016 19:04:19 +0200
Message-Id: <20160922170420.5193-2-toke@toke.dk> (sfid-20160922_190456_435847_847DCAEB)
In-Reply-To: <20160922170420.5193-1-toke@toke.dk>
References: <20160922170420.5193-1-toke@toke.dk>
In-Reply-To: <20160906114426.25520-1-toke@toke.dk>
References: <20160906114426.25520-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TXQ path restructure requires ieee80211_tx_dequeue() to call TX
handlers and parts of the xmit_fast path. Move the function to later in
tx.c in preparation for this.

Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
---
 net/mac80211/tx.c | 90 +++++++++++++++++++++++++++----------------------=
------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 61d302d..e8c9964 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1476,51 +1476,6 @@ void ieee80211_txq_teardown_flows(struct ieee80211=
_local *local)
 	spin_unlock_bh(&fq->lock);
 }
=20
-struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
-				     struct ieee80211_txq *txq)
-{
-	struct ieee80211_local *local =3D hw_to_local(hw);
-	struct txq_info *txqi =3D container_of(txq, struct txq_info, txq);
-	struct ieee80211_hdr *hdr;
-	struct sk_buff *skb =3D NULL;
-	struct fq *fq =3D &local->fq;
-	struct fq_tin *tin =3D &txqi->tin;
-
-	spin_lock_bh(&fq->lock);
-
-	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags))
-		goto out;
-
-	skb =3D fq_tin_dequeue(fq, tin, fq_tin_dequeue_func);
-	if (!skb)
-		goto out;
-
-	ieee80211_set_skb_vif(skb, txqi);
-
-	hdr =3D (struct ieee80211_hdr *)skb->data;
-	if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
-		struct sta_info *sta =3D container_of(txq->sta, struct sta_info,
-						    sta);
-		struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
-
-		hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, txq->tid);
-		if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
-			info->flags |=3D IEEE80211_TX_CTL_AMPDU;
-		else
-			info->flags &=3D ~IEEE80211_TX_CTL_AMPDU;
-	}
-
-out:
-	spin_unlock_bh(&fq->lock);
-
-	if (skb && skb_has_frag_list(skb) &&
-	    !ieee80211_hw_check(&local->hw, TX_FRAG_LIST))
-		skb_linearize(skb);
-
-	return skb;
-}
-EXPORT_SYMBOL(ieee80211_tx_dequeue);
-
 static bool ieee80211_tx_frags(struct ieee80211_local *local,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
@@ -3311,6 +3266,51 @@ static bool ieee80211_xmit_fast(struct ieee80211_s=
ub_if_data *sdata,
 	return true;
 }
=20
+struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
+				     struct ieee80211_txq *txq)
+{
+	struct ieee80211_local *local =3D hw_to_local(hw);
+	struct txq_info *txqi =3D container_of(txq, struct txq_info, txq);
+	struct ieee80211_hdr *hdr;
+	struct sk_buff *skb =3D NULL;
+	struct fq *fq =3D &local->fq;
+	struct fq_tin *tin =3D &txqi->tin;
+
+	spin_lock_bh(&fq->lock);
+
+	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags))
+		goto out;
+
+	skb =3D fq_tin_dequeue(fq, tin, fq_tin_dequeue_func);
+	if (!skb)
+		goto out;
+
+	ieee80211_set_skb_vif(skb, txqi);
+
+	hdr =3D (struct ieee80211_hdr *)skb->data;
+	if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
+		struct sta_info *sta =3D container_of(txq->sta, struct sta_info,
+						    sta);
+		struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
+
+		hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, txq->tid);
+		if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
+			info->flags |=3D IEEE80211_TX_CTL_AMPDU;
+		else
+			info->flags &=3D ~IEEE80211_TX_CTL_AMPDU;
+	}
+
+out:
+	spin_unlock_bh(&fq->lock);
+
+	if (skb && skb_has_frag_list(skb) &&
+	    !ieee80211_hw_check(&local->hw, TX_FRAG_LIST))
+		skb_linearize(skb);
+
+	return skb;
+}
+EXPORT_SYMBOL(ieee80211_tx_dequeue);
+
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags)
--=20
2.9.3

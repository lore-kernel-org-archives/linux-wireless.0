Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35045 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751539AbcIDQBL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Sep 2016 12:01:11 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix sequence number assignment for PS response frames
Date: Sun,  4 Sep 2016 18:00:59 +0200
Message-Id: <20160904160059.66297-1-nbd@nbd.name> (sfid-20160904_180119_318895_5620B34B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using intermediate queues, sequence number allocation is deferred
until dequeue. This doesn't work for PS response frames, which bypass
those queues.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 65 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5023966..cc8e955 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -796,6 +796,36 @@ static __le16 ieee80211_tx_next_seq(struct sta_info *sta, int tid)
 	return ret;
 }
 
+static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
+					  struct ieee80211_vif *vif,
+					  struct ieee80211_sta *pubsta,
+					  struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_txq *txq = NULL;
+
+	if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
+	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
+		return NULL;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return NULL;
+
+	if (pubsta) {
+		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
+
+		txq = pubsta->txq[tid];
+	} else if (vif) {
+		txq = vif->txq;
+	}
+
+	if (!txq)
+		return NULL;
+
+	return to_txq_info(txq);
+}
+
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 {
@@ -853,7 +883,8 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 	tx->sta->tx_stats.msdu[tid]++;
 
-	if (!tx->sta->sta.txq[0])
+	if (!ieee80211_get_txq(tx->local, info->control.vif, &tx->sta->sta,
+			       tx->skb))
 		hdr->seq_ctrl = ieee80211_tx_next_seq(tx->sta, tid);
 
 	return TX_CONTINUE;
@@ -1243,36 +1274,6 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	return TX_CONTINUE;
 }
 
-static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
-					  struct ieee80211_vif *vif,
-					  struct ieee80211_sta *pubsta,
-					  struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_txq *txq = NULL;
-
-	if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
-	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
-		return NULL;
-
-	if (!ieee80211_is_data(hdr->frame_control))
-		return NULL;
-
-	if (pubsta) {
-		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
-
-		txq = pubsta->txq[tid];
-	} else if (vif) {
-		txq = vif->txq;
-	}
-
-	if (!txq)
-		return NULL;
-
-	return to_txq_info(txq);
-}
-
 static void ieee80211_set_skb_enqueue_time(struct sk_buff *skb)
 {
 	IEEE80211_SKB_CB(skb)->control.enqueue_time = codel_get_time();
@@ -3264,7 +3265,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
 		*ieee80211_get_qos_ctl(hdr) = tid;
-		if (!sta->sta.txq[0])
+		if (!ieee80211_get_txq(local, &sdata->vif, &sta->sta, skb))
 			hdr->seq_ctrl = ieee80211_tx_next_seq(sta, tid);
 	} else {
 		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
-- 
2.8.4

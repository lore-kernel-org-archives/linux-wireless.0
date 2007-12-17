Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31958 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152AbXLQQNe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 11:13:34 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
Date: Mon, 17 Dec 2007 17:57:46 +0200
Message-Id: <11979070782762-git-send-email-ron.rindjunsky@intel.com> (sfid-20071217_161343_937455_A163695F)
In-Reply-To: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch handles the reordering of the Rx A-MPDU.
This issue occurs when the sequence of the internal MPDUs is not in the
right order. such a case can be encountered for example when some MPDUs from
previous aggregations were recieved, while others failed, so current A-MPDU
will contain a mix of re-transmited MPDUs and new ones.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 include/net/mac80211.h       |    2 +
 net/mac80211/ieee80211_sta.c |   16 ++++
 net/mac80211/rx.c            |  172 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 189 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f50c28a..27a15f0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -376,6 +376,7 @@ enum mac80211_rx_flags {
  * @noise: PHY noise when receiving this frame
  * @antenna: antenna used
  * @rate: data rate
+ * @ordered: used in A-MPSDU reordering scheme
  * @flag: %RX_FLAG_*
  */
 struct ieee80211_rx_status {
@@ -388,6 +389,7 @@ struct ieee80211_rx_status {
 	int noise;
 	int antenna;
 	int rate;
+	int ordered;
 	int flag;
 };
 
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index ca98d06..4fa0301 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1212,6 +1212,8 @@ void ieee80211_sta_stop_rx_BA_session(struct net_device *dev, u8 *ra, u16 tid,
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 	struct sta_info *sta;
+	struct ieee80211_rx_status status;
+	int i;
 
 	sta = sta_info_get(local, ra);
 	if (!sta)
@@ -1252,6 +1254,20 @@ void ieee80211_sta_stop_rx_BA_session(struct net_device *dev, u8 *ra, u16 tid,
 		ieee80211_send_delba(dev, ra, tid, 0, reason);
 
 	/* free the reordering buffer */
+	for (i = 0; i < sta->ampdu_mlme.tid_rx[tid].buf_size; i++) {
+		if (sta->ampdu_mlme.tid_rx[tid].reorder_buf[i]) {
+			/* release the reordered frames to stack,
+			 * but drop them there */
+			memcpy(&status, sta->ampdu_mlme.tid_rx[tid].
+				reorder_buf[i]->cb, sizeof(status));
+			status.ordered = TXRX_DROP;
+			__ieee80211_rx(hw, sta->ampdu_mlme.
+				       tid_rx[tid].reorder_buf[i],
+				       &status);
+			sta->ampdu_mlme.tid_rx[tid].stored_mpdu_num--;
+			sta->ampdu_mlme.tid_rx[tid].reorder_buf[i] = NULL;
+		}
+	}
 	kfree(sta->ampdu_mlme.tid_rx[tid].reorder_buf);
 
 	sta->ampdu_mlme.tid_rx[tid].state = HT_AGG_STATE_IDLE;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5dbf5d6..7a705eb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -226,6 +226,114 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	return origskb;
 }
 
+#define SEQ_MODULO 0x1000
+#define SEQ_MASK   0xfff
+
+static inline int seq_less(u16 sq1, u16 sq2)
+{
+	return (((sq1 - sq2) & SEQ_MASK) > (SEQ_MODULO >> 1));
+}
+
+static inline u16 seq_inc(u16 sq)
+{
+	return ((sq + 1) & SEQ_MASK);
+}
+
+static inline u16 seq_sub(u16 sq1, u16 sq2)
+{
+	return ((sq1 - sq2) & SEQ_MASK);
+}
+
+ieee80211_txrx_result
+ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
+				struct ieee80211_txrx_data *rx,
+				struct tid_ampdu_rx *tid_agg_rx,
+				struct sk_buff *skb, u16 mpdu_seq_num,
+				int bar_req)
+{
+	struct ieee80211_rx_status status;
+	u16 head_seq_num, buf_size;
+	int index;
+
+	buf_size = tid_agg_rx->buf_size;
+	head_seq_num = tid_agg_rx->head_seq_num;
+
+	/* frame with out of date sequence number */
+	if (seq_less(mpdu_seq_num, head_seq_num))
+		return TXRX_DROP;
+
+	/* if frame sequence number exceeds our buffering window size or
+	 * block Ack Request arrived - release stored frames */
+	if ((!seq_less(mpdu_seq_num, head_seq_num + buf_size)) || (bar_req)) {
+		/* new head to the ordering buffer */
+		if (bar_req)
+			head_seq_num = mpdu_seq_num;
+		else
+			head_seq_num =
+				seq_inc(seq_sub(mpdu_seq_num, buf_size));
+		/* release stored frames up to new head to stack */
+		while (seq_less(tid_agg_rx->head_seq_num, head_seq_num)) {
+			index = seq_sub(tid_agg_rx->head_seq_num,
+				tid_agg_rx->ssn)
+				% tid_agg_rx->buf_size;
+
+			if (tid_agg_rx->reorder_buf[index]) {
+				/* release the reordered frames to stack */
+				memcpy(&status,
+					tid_agg_rx->reorder_buf[index]->cb,
+					sizeof(status));
+
+				status.ordered = TXRX_QUEUED;
+				__ieee80211_rx(hw,
+					tid_agg_rx->reorder_buf[index],
+					&status);
+				tid_agg_rx->stored_mpdu_num--;
+				tid_agg_rx->reorder_buf[index] = NULL;
+			}
+			tid_agg_rx->head_seq_num =
+				seq_inc(tid_agg_rx->head_seq_num);
+		}
+		if (bar_req)
+			return TXRX_DROP;
+	}
+
+	/* now the new frame is always in the range of the reordering */
+	/* buffer window */
+	index = seq_sub(mpdu_seq_num, tid_agg_rx->ssn)
+				% tid_agg_rx->buf_size;
+	/* check if we already stored this frame */
+	if (tid_agg_rx->reorder_buf[index])
+		return TXRX_DROP;
+
+	/* if arrived mpdu is in the right order and nothing else stored */
+	/* release it immediately */
+	if (mpdu_seq_num == tid_agg_rx->head_seq_num &&
+			tid_agg_rx->stored_mpdu_num == 0) {
+		tid_agg_rx->head_seq_num =
+			seq_inc(tid_agg_rx->head_seq_num);
+		return TXRX_CONTINUE;
+	}
+
+	/* put the frame in the reordering buffer */
+	tid_agg_rx->reorder_buf[index] = skb;
+	tid_agg_rx->stored_mpdu_num++;
+	/* release the buffer until next missing frame */
+	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn)
+						% tid_agg_rx->buf_size;
+	while (tid_agg_rx->reorder_buf[index]) {
+		/* release the reordered frame back to stack */
+		memcpy(&status, tid_agg_rx->reorder_buf[index]->cb,
+			sizeof(status));
+		status.ordered = TXRX_QUEUED;
+		__ieee80211_rx(hw, tid_agg_rx->reorder_buf[index], &status);
+		tid_agg_rx->stored_mpdu_num--;
+		tid_agg_rx->reorder_buf[index] = NULL;
+		tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
+		index =	seq_sub(tid_agg_rx->head_seq_num,
+			tid_agg_rx->ssn) % tid_agg_rx->buf_size;
+	}
+	return TXRX_QUEUED;
+}
 
 /* pre-rx handlers
  *
@@ -285,7 +393,7 @@ ieee80211_rx_h_load_stats(struct ieee80211_txrx_data *rx)
 
 	/* Estimate total channel use caused by this frame */
 
-	if (unlikely(mode->num_rates < 0))
+	if (unlikely(mode->num_rates < 0) || (rx->u.rx.status->ordered))
 		return TXRX_CONTINUE;
 
 	rate = &mode->rates[0];
@@ -320,10 +428,72 @@ ieee80211_rx_h_load_stats(struct ieee80211_txrx_data *rx)
 	return TXRX_CONTINUE;
 }
 
+static ieee80211_txrx_result
+ieee80211_rx_h_reorder_ampdu(struct ieee80211_txrx_data *rx)
+{
+	struct ieee80211_local *local = rx->local;
+	struct ieee80211_hw *hw = &local->hw;
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct tid_ampdu_rx *tid_agg_rx;
+	u16 sc;
+	u16 mpdu_seq_num;
+
+	if (!rx->sta)
+		return TXRX_CONTINUE;
+
+	tid_agg_rx = &(rx->sta->ampdu_mlme.tid_rx[rx->u.rx.queue]);
+
+	/* filter the QoS data rx stream according to
+	 * STA/TID and check if this STA/TID is on aggregation */
+	if ((tid_agg_rx->state != HT_AGG_STATE_OPERATIONAL) ||
+	    (!WLAN_FC_IS_QOS_DATA(rx->fc)))
+		return TXRX_CONTINUE;
+
+	/* null data frames are excluded */
+	if (rx->fc & IEEE80211_STYPE_QOS_NULLFUNC)
+		return TXRX_CONTINUE;
+
+	/* check if this frame has already been queued and ordered */
+	if (rx->u.rx.status->ordered == TXRX_QUEUED)
+		return TXRX_CONTINUE;
+
+	/* check if this frame has already been queued and ordered but
+	 * should be deleted */
+	if (rx->u.rx.status->ordered == TXRX_DROP) {
+		if (skb)
+			dev_kfree_skb(skb);
+		return TXRX_DROP;
+	}
+
+	/* new un-ordered ampdu frame - process it */
+
+	/* reset session timer */
+	if (tid_agg_rx->timeout) {
+		unsigned long expires =
+			jiffies + (tid_agg_rx->timeout / 1000) * HZ;
+		mod_timer(&tid_agg_rx->session_timer, expires);
+	}
+
+	/* if this mpdu is fragmented - terminate rx aggregation session */
+	sc = le16_to_cpu(hdr->seq_ctrl);
+	if (sc & IEEE80211_SCTL_FRAG) {
+		ieee80211_sta_stop_rx_BA_session(rx->dev, rx->sta->addr,
+			rx->u.rx.queue, 0, WLAN_REASON_QSTA_REQUIRE_SETUP);
+		return TXRX_CONTINUE;
+	}
+
+	/* according to mpdu sequence number deal with reordering buffer */
+	mpdu_seq_num = (sc & IEEE80211_SCTL_SEQ) >> 4;
+	return ieee80211_sta_manage_reorder_buf(hw, rx, tid_agg_rx, skb,
+			mpdu_seq_num, 0);
+}
+
 ieee80211_rx_handler ieee80211_rx_pre_handlers[] =
 {
 	ieee80211_rx_h_parse_qos,
 	ieee80211_rx_h_load_stats,
+	ieee80211_rx_h_reorder_ampdu,
 	NULL
 };
 
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


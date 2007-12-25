Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28918 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbXLYPAw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 10:00:52 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 5/8 v3] mac80211: A-MPDU Rx handling aggregation reordering
Date: Tue, 25 Dec 2007 17:00:35 +0200
Message-Id: <11985948452088-git-send-email-ron.rindjunsky@intel.com> (sfid-20071225_150106_448517_F15F9014)
In-Reply-To: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
References: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
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
 net/mac80211/ieee80211_sta.c |   10 ++-
 net/mac80211/rx.c            |  185 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 192 insertions(+), 3 deletions(-)

Index: wl2_6_24_rc5/net/mac80211/ieee80211_sta.c
===================================================================
--- wl2_6_24_rc5.orig/net/mac80211/ieee80211_sta.c
+++ wl2_6_24_rc5/net/mac80211/ieee80211_sta.c
@@ -1212,7 +1212,7 @@ void ieee80211_sta_stop_rx_ba_session(st
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 	struct sta_info *sta;
-	int ret;
+	int ret, i;
 
 	sta = sta_info_get(local, ra);
 	if (!sta)
@@ -1254,6 +1254,14 @@ void ieee80211_sta_stop_rx_ba_session(st
 		ieee80211_send_delba(dev, ra, tid, 0, reason);
 
 	/* free the reordering buffer */
+	for (i = 0; i < sta->ampdu_mlme.tid_rx[tid].buf_size; i++) {
+		if (sta->ampdu_mlme.tid_rx[tid].reorder_buf[i]) {
+			/* release the reordered frames */
+			dev_kfree_skb(sta->ampdu_mlme.tid_rx[tid].reorder_buf[i]);
+			sta->ampdu_mlme.tid_rx[tid].stored_mpdu_num--;
+			sta->ampdu_mlme.tid_rx[tid].reorder_buf[i] = NULL;
+		}
+	}
 	kfree(sta->ampdu_mlme.tid_rx[tid].reorder_buf);
 
 	sta->ampdu_mlme.tid_rx[tid].state = HT_AGG_STATE_IDLE;
Index: wl2_6_24_rc5/net/mac80211/rx.c
===================================================================
--- wl2_6_24_rc5.orig/net/mac80211/rx.c
+++ wl2_6_24_rc5/net/mac80211/rx.c
@@ -314,7 +314,6 @@ u32 ieee80211_rx_load_stats(struct ieee8
 
 	/* Divide channel_use by 8 to avoid wrapping around the counter */
 	load >>= CHAN_UTIL_SHIFT;
-	local->channel_use_raw += load;
 
 	return load;
 }
@@ -1715,6 +1714,186 @@ void __ieee80211_rx_handle_packet(struct
 		sta_info_put(sta);
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
+
+u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
+				struct tid_ampdu_rx *tid_agg_rx,
+				struct sk_buff *skb, u16 mpdu_seq_num,
+				int bar_req)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_rx_status status;
+	u16 head_seq_num, buf_size;
+	int index;
+	u32 pkt_load;
+
+	buf_size = tid_agg_rx->buf_size;
+	head_seq_num = tid_agg_rx->head_seq_num;
+
+	/* frame with out of date sequence number */
+	if (seq_less(mpdu_seq_num, head_seq_num)) {
+		dev_kfree_skb(skb);
+		return 1;
+	}
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
+				pkt_load = ieee80211_rx_load_stats(local,
+						tid_agg_rx->reorder_buf[index],
+						&status);
+				__ieee80211_rx_handle_packet(hw,
+					tid_agg_rx->reorder_buf[index],
+					&status, pkt_load);
+				tid_agg_rx->stored_mpdu_num--;
+				tid_agg_rx->reorder_buf[index] = NULL;
+			}
+			tid_agg_rx->head_seq_num =
+				seq_inc(tid_agg_rx->head_seq_num);
+		}
+		if (bar_req)
+			return 1;
+	}
+
+	/* now the new frame is always in the range of the reordering */
+	/* buffer window */
+	index = seq_sub(mpdu_seq_num, tid_agg_rx->ssn)
+				% tid_agg_rx->buf_size;
+	/* check if we already stored this frame */
+	if (tid_agg_rx->reorder_buf[index]) {
+		dev_kfree_skb(skb);
+		return 1;
+	}
+
+	/* if arrived mpdu is in the right order and nothing else stored */
+	/* release it immediately */
+	if (mpdu_seq_num == tid_agg_rx->head_seq_num &&
+			tid_agg_rx->stored_mpdu_num == 0) {
+		tid_agg_rx->head_seq_num =
+			seq_inc(tid_agg_rx->head_seq_num);
+		return 0;
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
+		pkt_load = ieee80211_rx_load_stats(local,
+					tid_agg_rx->reorder_buf[index],
+					&status);
+		__ieee80211_rx_handle_packet(hw, tid_agg_rx->reorder_buf[index],
+						&status, pkt_load);
+		tid_agg_rx->stored_mpdu_num--;
+		tid_agg_rx->reorder_buf[index] = NULL;
+		tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
+		index =	seq_sub(tid_agg_rx->head_seq_num,
+			tid_agg_rx->ssn) % tid_agg_rx->buf_size;
+	}
+	return 1;
+}
+
+u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
+			      struct sk_buff *skb)
+{
+	struct ieee80211_hw *hw = &local->hw;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct sta_info *sta;
+	struct tid_ampdu_rx *tid_agg_rx;
+	u16 fc, sc;
+	u16 mpdu_seq_num;
+	u8 ret = 0, *qc;
+	int tid;
+
+	sta = sta_info_get(local, hdr->addr2);
+	if (!sta)
+		return ret;
+
+	fc = le16_to_cpu(hdr->frame_control);
+
+	/* filter the QoS data rx stream according to
+	 * STA/TID and check if this STA/TID is on aggregation */
+	if (!WLAN_FC_IS_QOS_DATA(fc))
+		goto end_reorder;
+
+	qc = skb->data + ieee80211_get_hdrlen(fc) - QOS_CONTROL_LEN;
+	tid = qc[0] & QOS_CONTROL_TID_MASK;
+	tid_agg_rx = &(sta->ampdu_mlme.tid_rx[tid]);
+
+	if (tid_agg_rx->state != HT_AGG_STATE_OPERATIONAL)
+		goto end_reorder;
+
+	/* null data frames are excluded */
+	if (unlikely(fc & IEEE80211_STYPE_QOS_NULLFUNC))
+		goto end_reorder;
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
+		ieee80211_sta_stop_rx_ba_session(sta->dev, sta->addr,
+			tid, 0, WLAN_REASON_QSTA_REQUIRE_SETUP);
+		ret = 1;
+		goto end_reorder;
+	}
+
+	/* according to mpdu sequence number deal with reordering buffer */
+	mpdu_seq_num = (sc & IEEE80211_SCTL_SEQ) >> 4;
+	ret = ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb,
+						mpdu_seq_num, 0);
+end_reorder:
+	if (sta)
+		sta_info_put(sta);
+	return ret;
+}
+
 /*
  * This is the receive path handler. It is called by a low level driver when an
  * 802.11 MPDU is received from the hardware.
@@ -1745,8 +1924,10 @@ void __ieee80211_rx(struct ieee80211_hw 
 	}
 
 	pkt_load = ieee80211_rx_load_stats(local, skb, status);
+	local->channel_use_raw += pkt_load;
 
-	__ieee80211_rx_handle_packet(hw, skb, status, pkt_load);
+	if (!ieee80211_rx_reorder_ampdu(local, skb))
+		__ieee80211_rx_handle_packet(hw, skb, status, pkt_load);
 
 	rcu_read_unlock();
 }
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


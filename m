Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47128 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab0DFJWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 05:22:49 -0400
Message-Id: <20100406092142.065041905@sipsolutions.net>
Date: Tue, 06 Apr 2010 11:18:48 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/7] mac80211: fix some RX aggregation locking
References: <20100406091841.549805267@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few places in mac80211 do not currently acquire
the sta lock for RX aggregation, but they should.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-04-06 09:19:08.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-04-06 09:20:41.000000000 +0200
@@ -720,14 +720,16 @@ static void ieee80211_rx_reorder_ampdu(s
 
 	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
 
+	spin_lock(&sta->lock);
+
 	if (!sta->ampdu_mlme.tid_active_rx[tid])
-		goto dont_reorder;
+		goto dont_reorder_unlock;
 
 	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
 
 	/* qos null data frames are excluded */
 	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
-		goto dont_reorder;
+		goto dont_reorder_unlock;
 
 	/* new, potentially un-ordered, ampdu frame - process it */
 
@@ -739,15 +741,20 @@ static void ieee80211_rx_reorder_ampdu(s
 	/* if this mpdu is fragmented - terminate rx aggregation session */
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	if (sc & IEEE80211_SCTL_FRAG) {
+		spin_unlock(&sta->lock);
 		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
 					       WLAN_REASON_QSTA_REQUIRE_SETUP);
 		dev_kfree_skb(skb);
 		return;
 	}
 
-	if (ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb, frames))
+	if (ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb, frames)) {
+		spin_unlock(&sta->lock);
 		return;
+	}
 
+ dont_reorder_unlock:
+	spin_unlock(&sta->lock);
  dont_reorder:
 	__skb_queue_tail(frames, skb);
 }
@@ -1803,9 +1810,12 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 	if (ieee80211_is_back_req(bar->frame_control)) {
 		if (!rx->sta)
 			return RX_DROP_MONITOR;
+		spin_lock(&rx->sta->lock);
 		tid = le16_to_cpu(bar->control) >> 12;
-		if (!rx->sta->ampdu_mlme.tid_active_rx[tid])
+		if (!rx->sta->ampdu_mlme.tid_active_rx[tid]) {
+			spin_unlock(&rx->sta->lock);
 			return RX_DROP_MONITOR;
+		}
 		tid_agg_rx = rx->sta->ampdu_mlme.tid_rx[tid];
 
 		start_seq_num = le16_to_cpu(bar->start_seq_num) >> 4;
@@ -1819,6 +1829,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 		ieee80211_release_reorder_frames(hw, tid_agg_rx, start_seq_num,
 						 frames);
 		kfree_skb(skb);
+		spin_unlock(&rx->sta->lock);
 		return RX_QUEUED;
 	}
 



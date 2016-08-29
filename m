Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40742 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933162AbcH2NkJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 09:40:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Mon, 29 Aug 2016 16:39:57 +0300
Message-Id: <1472477998-25972-4-git-send-email-luca@coelho.fi> (sfid-20160829_154013_364129_64E5BF9B)
Subject: [PATCH 4/5] mac80211: send delBA on unexpected BlockAck data frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we receive data frames with ACK policy BlockAck, send
delBA as requested by the 802.11 spec. Since this would be
happening for every frame inside an A-MPDU if it's really
received outside a session, limit it to a single attempt.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c   | 4 +++-
 net/mac80211/rx.c       | 9 ++++++++-
 net/mac80211/sta_info.h | 3 +++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index a9aff60..4d05acc 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -406,8 +406,10 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	}
 
 end:
-	if (status == WLAN_STATUS_SUCCESS)
+	if (status == WLAN_STATUS_SUCCESS) {
 		__set_bit(tid, sta->ampdu_mlme.agg_session_valid);
+		__clear_bit(tid, sta->ampdu_mlme.unexpected_agg);
+	}
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 
 end_no_lock:
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c8ec434..7a60b59 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1123,8 +1123,15 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
 
 	tid_agg_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
-	if (!tid_agg_rx)
+	if (!tid_agg_rx) {
+		if (ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK &&
+		    !test_bit(tid, rx->sta->ampdu_mlme.agg_session_valid) &&
+		    !test_and_set_bit(tid, rx->sta->ampdu_mlme.unexpected_agg))
+			ieee80211_send_delba(rx->sdata, rx->sta->sta.addr, tid,
+					     WLAN_BACK_RECIPIENT,
+					     WLAN_REASON_QSTA_REQUIRE_SETUP);
 		goto dont_reorder;
+	}
 
 	/* qos null data frames are excluded */
 	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 0556be3..530231b 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -230,6 +230,8 @@ struct tid_ampdu_rx {
  * @tid_rx_stop_requested:  bitmap indicating which BA sessions per TID the
  *	driver requested to close until the work for it runs
  * @agg_session_valid: bitmap indicating which TID has a rx BA session open on
+ * @unexpected_agg: bitmap indicating which TID already sent a delBA due to
+ *	unexpected aggregation related frames outside a session
  * @work: work struct for starting/stopping aggregation
  * @tid_tx: aggregation info for Tx per TID
  * @tid_start_tx: sessions where start was requested
@@ -244,6 +246,7 @@ struct sta_ampdu_mlme {
 	unsigned long tid_rx_timer_expired[BITS_TO_LONGS(IEEE80211_NUM_TIDS)];
 	unsigned long tid_rx_stop_requested[BITS_TO_LONGS(IEEE80211_NUM_TIDS)];
 	unsigned long agg_session_valid[BITS_TO_LONGS(IEEE80211_NUM_TIDS)];
+	unsigned long unexpected_agg[BITS_TO_LONGS(IEEE80211_NUM_TIDS)];
 	/* tx */
 	struct work_struct work;
 	struct tid_ampdu_tx __rcu *tid_tx[IEEE80211_NUM_TIDS];
-- 
2.8.1

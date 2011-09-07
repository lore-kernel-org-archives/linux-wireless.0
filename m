Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42438 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab1IGUK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 16:10:27 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R1OS2-0007vz-8Z
	for linux-wireless@vger.kernel.org; Wed, 07 Sep 2011 22:10:26 +0200
Message-Id: <20110907200922.917667600@sipsolutions.net> (sfid-20110907_221110_565481_8E902CB3)
Date: Wed, 07 Sep 2011 22:07:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 07/11] mac80211: allow releasing driver-buffered frames
References: <20110907200744.076513799@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If there are frames for a station buffered in
the driver, mac80211 announces those in the TIM
IE but there's no way to release them. Add new
API to release such frames and use it when the
station polls for a frame.

Since the API will soon also be used for uAPSD
it is easily extensible.

Note that before this change drivers announcing
driver-buffered frames in the TIM bit actually
will respond to a PS-Poll with a potentially
lower priority frame (if there are any frames
buffered in mac80211), after this patch a driver
that hasn't been changed will no longer respond
at all. This only affects ath9k, which will need
to be fixed to implement the new API.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h      |   29 +++++++++++++
 net/mac80211/driver-ops.h   |   15 ++++++
 net/mac80211/driver-trace.h |   34 +++++++++++++++
 net/mac80211/sta_info.c     |   97 +++++++++++++++++++++++++++++++++++---------
 4 files changed, 157 insertions(+), 18 deletions(-)

--- a/net/mac80211/sta_info.c	2011-09-07 15:00:32.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-07 15:06:16.000000000 +0200
@@ -1151,8 +1151,9 @@ void ieee80211_sta_ps_deliver_poll_respo
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = NULL;
+	bool found = false;
 	bool more_data = false;
-	int ac;
+	int ac, driver_release_tid = -1;
 	u8 ignore_for_response = sta->sta.uapsd_queues;
 
 	/*
@@ -1167,27 +1168,74 @@ void ieee80211_sta_ps_deliver_poll_respo
 	 * Get response frame and more data bit for it.
 	 */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		int tid1, tid2;
+
 		if (ignore_for_response & BIT(ac))
 			continue;
 
-		if (!skb) {
-			skb = skb_dequeue(&sta->tx_filtered[ac]);
-			if (!skb) {
-				skb = skb_dequeue(&sta->ps_tx_buf[ac]);
+		ieee80211_tids_for_ac(ac, &tid1, &tid2);
+
+		if (!found) {
+			if (test_bit(tid2, sta->driver_buffered_tids)) {
+				found = true;
+				driver_release_tid = tid2;
+			} else if (test_bit(tid1, sta->driver_buffered_tids)) {
+				found = true;
+				driver_release_tid = tid1;
+			} else {
+				skb = skb_dequeue(&sta->tx_filtered[ac]);
+				if (!skb) {
+					skb = skb_dequeue(&sta->ps_tx_buf[ac]);
+					if (skb)
+						local->total_ps_buffered--;
+				}
 				if (skb)
-					local->total_ps_buffered--;
+					found = true;
 			}
 		}
 
-		/* FIXME: take into account driver-buffered frames */
-
-		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
+		/*
+		 * The last two pieces are obvious: if we have more frames
+		 * buffered (remember we already did the dequeue above) on
+		 * the queues for this AC, then there's more data.
+		 *
+		 * If the driver has some buffered on the *same* TID, we
+		 * don't know if it'll have more than 1 frame, so this one
+		 * determination it'll have to make later when it sets or
+		 * clears the more-data bit. If we know that there is more
+		 * data on the *other* TID though we can save it some of
+		 * the trouble and tell it that there's more data.
+		 *
+		 * So that's how we arrive at this condition -- we check
+		 * each TID only if it's not the one we're releasing from.
+		 */
+		if ((driver_release_tid != tid1 &&
+				test_bit(tid1, sta->driver_buffered_tids)) ||
+		    (driver_release_tid != tid2 &&
+		    		test_bit(tid2, sta->driver_buffered_tids)) ||
+		    !skb_queue_empty(&sta->tx_filtered[ac]) ||
 		    !skb_queue_empty(&sta->ps_tx_buf[ac])) {
 			more_data = true;
 			break;
 		}
 	}
 
+	if (!found) {
+#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+		/*
+		 * FIXME: This can be the result of a race condition between
+		 *	  us expiring a frame and the station polling for it.
+		 *	  Should we send it a null-func frame indicating we
+		 *	  have nothing buffered for it?
+		 */
+		printk(KERN_DEBUG "%s: STA %pM sent PS Poll even "
+		       "though there are no buffered frames for it\n",
+		       sdata->name, sta->sta.addr);
+#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+
+		return;
+	}
+
 	if (skb) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		struct ieee80211_hdr *hdr =
@@ -1214,18 +1262,31 @@ void ieee80211_sta_ps_deliver_poll_respo
 		ieee80211_add_pending_skb(local, skb);
 
 		sta_info_recalc_tim(sta);
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+	} else if (WARN_ON(driver_release_tid == -1)) {
+		/* err ... ??? */
 	} else {
 		/*
-		 * FIXME: This can be the result of a race condition between
-		 *	  us expiring a frame and the station polling for it.
-		 *	  Should we send it a null-func frame indicating we
-		 *	  have nothing buffered for it?
+		 * We need to release a frame that is buffered somewhere in the
+		 * driver ... it'll have to handle that.
+		 * Note that, as per the comment above, it'll also have to see
+		 * if there is more than just one frame on the specific TID that
+		 * we're releasing from, and it needs to set the more-data bit
+		 * accordingly if we tell it that there's no more data. If we do
+		 * tell it there's more data, then of course the more-data bit
+		 * needs to be set anyway.
+		 */
+		drv_release_buffered_frames(local, sta, driver_release_tid,
+					    1, IEEE80211_FRAME_RELEASE_PSPOLL,
+					    more_data);
+
+		/*
+		 * Note that we don't recalculate the TIM bit here as it would
+		 * most likely have no effect at all unless the driver told us
+		 * that the TID became empty before returning here from the
+		 * release function.
+		 * Either way, however, when the driver tells us that the TID
+		 * became empty we'll do the TIM recalculation.
 		 */
-		printk(KERN_DEBUG "%s: STA %pM sent PS Poll even "
-		       "though there are no buffered frames for it\n",
-		       sdata->name, sta->sta.addr);
-#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 	}
 }
 
--- a/include/net/mac80211.h	2011-09-07 14:52:48.000000000 +0200
+++ b/include/net/mac80211.h	2011-09-07 15:06:16.000000000 +0200
@@ -1602,6 +1602,14 @@ enum ieee80211_tx_sync_type {
 };
 
 /**
+ * enum ieee80211_frame_release_type - frame release reason
+ * @IEEE80211_FRAME_RELEASE_PSPOLL: frame released for PS-Poll
+ */
+enum ieee80211_frame_release_type {
+	IEEE80211_FRAME_RELEASE_PSPOLL,
+};
+
+/**
  * struct ieee80211_ops - callbacks from mac80211 to the driver
  *
  * This structure contains various callbacks that the driver may
@@ -1911,6 +1919,21 @@ enum ieee80211_tx_sync_type {
  *	The callback can sleep.
  * @rssi_callback: Notify driver when the average RSSI goes above/below
  *	thresholds that were registered previously. The callback can sleep.
+ *
+ * @release_buffered_frames: Release buffered frames according to the given
+ *	parameters. In the case where the driver buffers some frames for
+ *	sleeping stations mac80211 will use this callback to tell the driver
+ *	to release some frames, either for PS-poll or uAPSD.
+ *	Note that if the @more_data paramter is %false the driver must check
+ *	if there are more frames on the given TID, and if there are more than
+ *	the frames being released then it must still set the more-data bit in
+ *	the frame. If the @more_data parameter is %true, then of course the
+ *	more-data bit must always be set.
+ *	In the case this is used for uAPSD, the @num_frames parameter may be
+ *	bigger than one, but the driver may send fewer frames (it must send
+ *	at least one, however). In this case it is also responsible for
+ *	setting the EOSP flag in the QoS header of the frames.
+ *	This callback must be atomic.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -2024,6 +2047,12 @@ struct ieee80211_ops {
 				const struct cfg80211_bitrate_mask *mask);
 	void (*rssi_callback)(struct ieee80211_hw *hw,
 			      enum ieee80211_rssi_event rssi_event);
+
+	void (*release_buffered_frames)(struct ieee80211_hw *hw,
+					struct ieee80211_sta *sta,
+					int tid, int num_frames,
+					enum ieee80211_frame_release_type reason,
+					bool more_data);
 };
 
 /**
--- a/net/mac80211/driver-ops.h	2011-09-07 14:52:48.000000000 +0200
+++ b/net/mac80211/driver-ops.h	2011-09-07 15:06:16.000000000 +0200
@@ -665,4 +665,19 @@ static inline void drv_rssi_callback(str
 		local->ops->rssi_callback(&local->hw, event);
 	trace_drv_return_void(local);
 }
+
+static inline void
+drv_release_buffered_frames(struct ieee80211_local *local,
+			    struct sta_info *sta, int tid, int num_frames,
+			    enum ieee80211_frame_release_type reason,
+			    bool more_data)
+{
+	trace_drv_release_buffered_frames(local, &sta->sta, tid, num_frames,
+					  reason, more_data);
+	if (local->ops->release_buffered_frames)
+		local->ops->release_buffered_frames(&local->hw, &sta->sta, tid,
+						    num_frames, reason,
+						    more_data);
+	trace_drv_return_void(local);
+}
 #endif /* __MAC80211_DRIVER_OPS */
--- a/net/mac80211/driver-trace.h	2011-09-07 14:52:48.000000000 +0200
+++ b/net/mac80211/driver-trace.h	2011-09-07 15:06:16.000000000 +0200
@@ -1117,6 +1117,40 @@ TRACE_EVENT(drv_rssi_callback,
 	)
 );
 
+TRACE_EVENT(drv_release_buffered_frames,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sta *sta,
+		 int tid, int num_frames,
+		 enum ieee80211_frame_release_type reason,
+		 bool more_data),
+
+	TP_ARGS(local, sta, tid, num_frames, reason, more_data),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		STA_ENTRY
+		__field(int, tid)
+		__field(int, num_frames)
+		__field(int, reason)
+		__field(bool, more_data)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		STA_ASSIGN;
+		__entry->tid = tid;
+		__entry->num_frames = num_frames;
+		__entry->reason = reason;
+		__entry->more_data = more_data;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT STA_PR_FMT " TID:%d frames:%d reason:%d more:%d",
+		LOCAL_PR_ARG, STA_PR_ARG, __entry->tid, __entry->num_frames,
+		__entry->reason, __entry->more_data
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1IVPuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 11:50:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R6lXj-0002TC-BI
	for linux-wireless@vger.kernel.org; Thu, 22 Sep 2011 17:50:31 +0200
Message-Id: <20110922154852.131981800@sipsolutions.net> (sfid-20110922_175037_803910_FDA7C791)
Date: Thu, 22 Sep 2011 17:47:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 13/15] mac80211: explicitly notify drivers of frame release
References: <20110922154726.521122680@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

iwlwifi needs to know the number of frames that are
going to be sent to a station while it is asleep so
it can properly handle the uCode blocking of that
station.

Before uAPSD, we got by by telling the device that
a single frame was going to be released whenever we
encountered IEEE80211_TX_CTL_POLL_RESPONSE. With
uAPSD, however, that is no longer possible since
there could be more than a single frame.

To support this model, add a new callback to notify
drivers when frames are going to be released.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h      |   17 +++++++++++++++++
 net/mac80211/driver-ops.h   |   15 +++++++++++++++
 net/mac80211/driver-trace.h |   22 +++++++++++++++++++++-
 net/mac80211/sta_info.c     |   34 +++++++++++++++++++++++++---------
 4 files changed, 78 insertions(+), 10 deletions(-)

--- a/include/net/mac80211.h	2011-09-22 17:16:25.000000000 +0200
+++ b/include/net/mac80211.h	2011-09-22 17:16:55.000000000 +0200
@@ -1969,6 +1969,18 @@ enum ieee80211_frame_release_type {
  *	service period ends, the driver must set %IEEE80211_TX_STATUS_EOSP
  *	on the last frame in the SP.
  *	This callback must be atomic.
+ * @allow_buffered_frames: Prepare device to allow the given number of frames
+ *	to go out to the given station. The frames will be sent by mac80211
+ *	via the usual TX path after this call. The TX information for frames
+ *	released will also have the %IEEE80211_TX_CTL_POLL_RESPONSE flag set
+ *	and the last one will also have %IEEE80211_TX_STATUS_EOSP set. In case
+ *	frames from multiple TIDs are released and the driver might reorder
+ *	them between the TIDs, it must set the %IEEE80211_TX_STATUS_EOSP flag
+ *	on the last frame and clear it on all others and also handle the EOSP
+ *	bit in the QoS header correctly.
+ *	The @tids parameter is a bitmap and tells the driver which TIDs the
+ *	frames will be on; it will at most have two bits set.
+ *	This callback must be atomic.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -2083,6 +2095,11 @@ struct ieee80211_ops {
 	void (*rssi_callback)(struct ieee80211_hw *hw,
 			      enum ieee80211_rssi_event rssi_event);
 
+	void (*allow_buffered_frames)(struct ieee80211_hw *hw,
+				      struct ieee80211_sta *sta,
+				      u16 tids, int num_frames,
+				      enum ieee80211_frame_release_type reason,
+				      bool more_data);
 	void (*release_buffered_frames)(struct ieee80211_hw *hw,
 					struct ieee80211_sta *sta,
 					u16 tids, int num_frames,
--- a/net/mac80211/driver-ops.h	2011-09-22 17:12:55.000000000 +0200
+++ b/net/mac80211/driver-ops.h	2011-09-22 17:16:55.000000000 +0200
@@ -680,4 +680,19 @@ drv_release_buffered_frames(struct ieee8
 						    more_data);
 	trace_drv_return_void(local);
 }
+
+static inline void
+drv_allow_buffered_frames(struct ieee80211_local *local,
+			  struct sta_info *sta, u16 tids, int num_frames,
+			  enum ieee80211_frame_release_type reason,
+			  bool more_data)
+{
+	trace_drv_allow_buffered_frames(local, &sta->sta, tids, num_frames,
+					reason, more_data);
+	if (local->ops->allow_buffered_frames)
+		local->ops->allow_buffered_frames(&local->hw, &sta->sta,
+						  tids, num_frames, reason,
+						  more_data);
+	trace_drv_return_void(local);
+}
 #endif /* __MAC80211_DRIVER_OPS */
--- a/net/mac80211/driver-trace.h	2011-09-22 17:12:55.000000000 +0200
+++ b/net/mac80211/driver-trace.h	2011-09-22 17:16:55.000000000 +0200
@@ -1117,7 +1117,7 @@ TRACE_EVENT(drv_rssi_callback,
 	)
 );
 
-TRACE_EVENT(drv_release_buffered_frames,
+DECLARE_EVENT_CLASS(release_evt,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sta *sta,
 		 u16 tids, int num_frames,
@@ -1152,6 +1152,26 @@ TRACE_EVENT(drv_release_buffered_frames,
 	)
 );
 
+DEFINE_EVENT(release_evt, drv_release_buffered_frames,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sta *sta,
+		 u16 tids, int num_frames,
+		 enum ieee80211_frame_release_type reason,
+		 bool more_data),
+
+	TP_ARGS(local, sta, tids, num_frames, reason, more_data)
+);
+
+DEFINE_EVENT(release_evt, drv_allow_buffered_frames,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sta *sta,
+		 u16 tids, int num_frames,
+		 enum ieee80211_frame_release_type reason,
+		 bool more_data),
+
+	TP_ARGS(local, sta, tids, num_frames, reason, more_data)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
--- a/net/mac80211/sta_info.c	2011-09-22 17:16:51.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-22 17:19:55.000000000 +0200
@@ -1157,7 +1157,7 @@ void ieee80211_sta_ps_deliver_wakeup(str
 
 static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 					 struct sta_info *sta, int tid,
-					 bool uapsd)
+					 enum ieee80211_frame_release_type reason)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_qos_hdr *nullfunc;
@@ -1198,7 +1198,7 @@ static void ieee80211_send_null_response
 
 		nullfunc->qos_ctrl = cpu_to_le16(tid);
 
-		if (uapsd)
+		if (reason == IEEE80211_FRAME_RELEASE_UAPSD)
 			nullfunc->qos_ctrl |=
 				cpu_to_le16(IEEE80211_QOS_CTL_EOSP);
 	}
@@ -1215,6 +1215,8 @@ static void ieee80211_send_null_response
 		       IEEE80211_TX_STATUS_EOSP |
 		       IEEE80211_TX_CTL_REQ_TX_STATUS;
 
+	drv_allow_buffered_frames(local, sta, BIT(tid), 1, reason, false);
+
 	ieee80211_xmit(sdata, skb);
 }
 
@@ -1312,20 +1314,24 @@ ieee80211_sta_ps_deliver_response(struct
 		/* This will evaluate to 1, 3, 5 or 7. */
 		tid = 7 - ((ffs(~ignored_acs) - 1) << 1);
 
-		ieee80211_send_null_response(sdata, sta, tid,
-				reason == IEEE80211_FRAME_RELEASE_UAPSD);
+		ieee80211_send_null_response(sdata, sta, tid, reason);
 		return;
 	}
 
 	if (!driver_release_tids) {
 		struct sk_buff_head pending;
 		struct sk_buff *skb;
+		int num = 0;
+		u16 tids = 0;
 
 		skb_queue_head_init(&pending);
 
 		while ((skb = __skb_dequeue(&frames))) {
 			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 			struct ieee80211_hdr *hdr = (void *) skb->data;
+			u8 *qoshdr = NULL;
+
+			num++;
 
 			/*
 			 * Tell TX path to send this frame even though the
@@ -1345,19 +1351,29 @@ ieee80211_sta_ps_deliver_response(struct
 				hdr->frame_control |=
 					cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 
+			if (ieee80211_is_data_qos(hdr->frame_control) ||
+			    ieee80211_is_qos_nullfunc(hdr->frame_control))
+				qoshdr = ieee80211_get_qos_ctl(hdr);
+
+			/* set EOSP for the frame */
 			if (reason == IEEE80211_FRAME_RELEASE_UAPSD &&
-			    skb_queue_empty(&frames)) {
-				/* set EOSP for the frame */
-				u8 *p = ieee80211_get_qos_ctl(hdr);
-				*p |= IEEE80211_QOS_CTL_EOSP;
-			}
+			    qoshdr && skb_queue_empty(&frames))
+				*qoshdr |= IEEE80211_QOS_CTL_EOSP;
 
 			info->flags |= IEEE80211_TX_STATUS_EOSP |
 				       IEEE80211_TX_CTL_REQ_TX_STATUS;
 
+			if (qoshdr)
+				tids |= BIT(*qoshdr & IEEE80211_QOS_CTL_TID_MASK);
+			else
+				tids |= BIT(0);
+
 			__skb_queue_tail(&pending, skb);
 		}
 
+		drv_allow_buffered_frames(local, sta, tids, num,
+					  reason, more_data);
+
 		ieee80211_add_pending_skbs(local, &pending);
 
 		sta_info_recalc_tim(sta);



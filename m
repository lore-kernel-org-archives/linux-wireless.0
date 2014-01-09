Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55335 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaAIMv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 07:51:28 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211: handle MMPDUs at EOSP correctly
Date: Thu,  9 Jan 2014 13:51:22 +0100
Message-Id: <1389271882-15806-5-git-send-email-johannes@sipsolutions.net> (sfid-20140109_135134_403566_BE4C5D03)
In-Reply-To: <1389271882-15806-1-git-send-email-johannes@sipsolutions.net>
References: <1389271882-15806-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a uAPSD service period ends with an MMPDU, we currently just
send that MMPDU, but it obviously won't get the EOSP bit set as
it doesn't have a QoS header. This contradicts the standard, so
add a QoS-nulldata frame after the MMPDU to properly terminate
the service period with a frame that has EOSP set.

Also fix a bug wrt. the TID for the MMPDU, it shouldn't be set
to 0 unconditionally but use the actual TID that was assigned.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h  |  5 ++++
 net/mac80211/sta_info.c | 61 ++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 25b1887..f4ab2fb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2119,6 +2119,11 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * appropriately (only the last frame may have %IEEE80211_TX_STATUS_EOSP)
  * and also take care of the EOSP and MORE_DATA bits in the frame.
  * The driver may also use ieee80211_sta_eosp() in this case.
+ *
+ * Note that if the driver ever buffers frames other than QoS-data
+ * frames, it must take care to never send a non-QoS-data frame as
+ * the last frame in a service period, adding a QoS-nulldata frame
+ * after a non-QoS-data frame if needed.
  */
 
 /**
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 93e2157..a41f2cb 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1153,7 +1153,8 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 
 static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 					 struct sta_info *sta, int tid,
-					 enum ieee80211_frame_release_type reason)
+					 enum ieee80211_frame_release_type reason,
+					 bool call_driver)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_qos_hdr *nullfunc;
@@ -1211,7 +1212,9 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 		       IEEE80211_TX_STATUS_EOSP |
 		       IEEE80211_TX_CTL_REQ_TX_STATUS;
 
-	drv_allow_buffered_frames(local, sta, BIT(tid), 1, reason, false);
+	if (call_driver)
+		drv_allow_buffered_frames(local, sta, BIT(tid), 1,
+					  reason, false);
 
 	skb->dev = sdata->dev;
 
@@ -1334,12 +1337,13 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		/* This will evaluate to 1, 3, 5 or 7. */
 		tid = 7 - ((ffs(~ignored_acs) - 1) << 1);
 
-		ieee80211_send_null_response(sdata, sta, tid, reason);
+		ieee80211_send_null_response(sdata, sta, tid, reason, true);
 	} else if (!driver_release_tids) {
 		struct sk_buff_head pending;
 		struct sk_buff *skb;
 		int num = 0;
 		u16 tids = 0;
+		bool need_null = false;
 
 		skb_queue_head_init(&pending);
 
@@ -1373,22 +1377,48 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 			    ieee80211_is_qos_nullfunc(hdr->frame_control))
 				qoshdr = ieee80211_get_qos_ctl(hdr);
 
-			/* end service period after last frame */
-			if (skb_queue_empty(&frames)) {
-				if (reason == IEEE80211_FRAME_RELEASE_UAPSD &&
-				    qoshdr)
-					*qoshdr |= IEEE80211_QOS_CTL_EOSP;
+			tids |= BIT(skb->priority);
 
+			__skb_queue_tail(&pending, skb);
+
+			/* end service period after last frame or add one */
+			if (!skb_queue_empty(&frames))
+				continue;
+
+			if (reason != IEEE80211_FRAME_RELEASE_UAPSD) {
+				/* for PS-Poll, there's only one frame */
 				info->flags |= IEEE80211_TX_STATUS_EOSP |
 					       IEEE80211_TX_CTL_REQ_TX_STATUS;
+				break;
 			}
 
-			if (qoshdr)
-				tids |= BIT(*qoshdr & IEEE80211_QOS_CTL_TID_MASK);
-			else
-				tids |= BIT(0);
+			/* For uAPSD, things are a bit more complicated. If the
+			 * last frame has a QoS header (i.e. is a QoS-data or
+			 * QoS-nulldata frame) then just set the EOSP bit there
+			 * and be done.
+			 * If the frame doesn't have a QoS header (which means
+			 * it should be a bufferable MMPDU) then we can't set
+			 * the EOSP bit in the QoS header; add a QoS-nulldata
+			 * frame to the list to send it after the MMPDU.
+			 *
+			 * Note that this code is only in the mac80211-release
+			 * code path, we assume that the driver will not buffer
+			 * anything but QoS-data frames, or if it does, will
+			 * create the QoS-nulldata frame by itself if needed.
+			 *
+			 * Cf. 802.11-2012 10.2.1.10 (c).
+			 */
+			if (qoshdr) {
+				*qoshdr |= IEEE80211_QOS_CTL_EOSP;
 
-			__skb_queue_tail(&pending, skb);
+				info->flags |= IEEE80211_TX_STATUS_EOSP |
+					       IEEE80211_TX_CTL_REQ_TX_STATUS;
+			} else {
+				/* FIXME: do we need to set more-data? */
+				need_null = true;
+				num++;
+			}
+			break;
 		}
 
 		drv_allow_buffered_frames(local, sta, tids, num,
@@ -1396,6 +1426,11 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 
 		ieee80211_add_pending_skbs(local, &pending);
 
+		if (need_null)
+			ieee80211_send_null_response(
+				sdata, sta, find_highest_prio_tid(tids),
+				reason, false);
+
 		sta_info_recalc_tim(sta);
 	} else {
 		/*
-- 
1.8.5.1


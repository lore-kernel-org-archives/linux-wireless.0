Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52992 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbbKQIYt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 03:24:49 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/8] mac80211: allow the driver to send EOSP when needed
Date: Tue, 17 Nov 2015 10:24:36 +0200
Message-Id: <1447748680-23075-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151117_092515_094216_9C0478AA)
In-Reply-To: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can happen when the driver needs to send less frames
than expected and then needs to close the SP.
Mac80211 still needs to set the more_data properly based
on its buffer state (ps_tx_buffer and buffered frames on
other TIDs).
To that end, refactor the code that delivers frames upon
uAPSD trigger frames to be able to get only the more_data
bit without actually delivering those frames in case the
driver is just asking to set a NDP with EOSP and MORE_DATA
bit properly set.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h  |  22 ++++++++
 net/mac80211/sta_info.c | 144 +++++++++++++++++++++++++++++++++---------------
 net/mac80211/trace.h    |  25 +++++++++
 3 files changed, 148 insertions(+), 43 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e19da3b5..f5a9571 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4867,6 +4867,28 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
 void ieee80211_sta_eosp(struct ieee80211_sta *pubsta);
 
 /**
+ * ieee80211_send_eosp_nullfunc - ask mac80211 to send NDP with EOSP
+ * @pubsta: the station
+ * @tid: the tid of the NDP
+ *
+ * Sometimes the device understands that it needs to close
+ * the Service Period unexpectedly. This can happen when
+ * sending frames that are filling holes in the BA window.
+ * In this case, the device can ask mac80211 to send a
+ * Nullfunc frame with EOSP set. When that happens, the
+ * driver must have called ieee80211_sta_set_buffered() to
+ * let mac80211 know that there are no buffered frames any
+ * more, otherwise mac80211 will get the more_data bit wrong.
+ * The low level driver must have made sure that the frame
+ * will be sent despite the station being in power-save.
+ * Mac80211 won't call allow_buffered_frames().
+ * Note that calling this function, doesn't exempt the driver
+ * from closing the EOSP properly, it will still have to call
+ * ieee80211_sta_eosp when the NDP is sent.
+ */
+void ieee80211_send_eosp_nullfunc(struct ieee80211_sta *pubsta, int tid);
+
+/**
  * ieee80211_iter_keys - iterate keys programmed into the device
  * @hw: pointer obtained from ieee80211_alloc_hw()
  * @vif: virtual interface to iterate, may be %NULL for all
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8f630f5..723fa30 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2,6 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright (C) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1244,11 +1245,11 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	ieee80211_check_fast_xmit(sta);
 }
 
-static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
-					 struct sta_info *sta, int tid,
+static void ieee80211_send_null_response(struct sta_info *sta, int tid,
 					 enum ieee80211_frame_release_type reason,
-					 bool call_driver)
+					 bool call_driver, bool more_data)
 {
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_qos_hdr *nullfunc;
 	struct sk_buff *skb;
@@ -1288,9 +1289,13 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	if (qos) {
 		nullfunc->qos_ctrl = cpu_to_le16(tid);
 
-		if (reason == IEEE80211_FRAME_RELEASE_UAPSD)
+		if (reason == IEEE80211_FRAME_RELEASE_UAPSD) {
 			nullfunc->qos_ctrl |=
 				cpu_to_le16(IEEE80211_QOS_CTL_EOSP);
+			if (more_data)
+				nullfunc->frame_control |=
+					cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+		}
 	}
 
 	info = IEEE80211_SKB_CB(skb);
@@ -1337,22 +1342,48 @@ static int find_highest_prio_tid(unsigned long tids)
 	return fls(tids) - 1;
 }
 
+/* Indicates if the MORE_DATA bit should be set in the last
+ * frame obtained by ieee80211_sta_ps_get_frames.
+ * Note that driver_release_tids is relevant only if
+ * reason = IEEE80211_FRAME_RELEASE_PSPOLL
+ */
+static bool
+ieee80211_sta_ps_more_data(struct sta_info *sta, u8 ignored_acs,
+			   enum ieee80211_frame_release_type reason,
+			   unsigned long driver_release_tids)
+{
+	int ac;
+
+	/* If the driver has data on more than one TID then
+	 * certainly there's more data if we release just a
+	 * single frame now (from a single TID). This will
+	 * only happen for PS-Poll.
+	 */
+	if (reason == IEEE80211_FRAME_RELEASE_PSPOLL &&
+	    hweight16(driver_release_tids) > 1)
+		return true;
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		if (ignored_acs & BIT(ac))
+			continue;
+
+		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
+		    !skb_queue_empty(&sta->ps_tx_buf[ac]))
+			return true;
+	}
+
+	return false;
+}
+
 static void
-ieee80211_sta_ps_deliver_response(struct sta_info *sta,
-				  int n_frames, u8 ignored_acs,
-				  enum ieee80211_frame_release_type reason)
+ieee80211_sta_ps_get_frames(struct sta_info *sta, int n_frames, u8 ignored_acs,
+			    enum ieee80211_frame_release_type reason,
+			    struct sk_buff_head *frames,
+			    unsigned long *driver_release_tids)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
-	bool more_data = false;
 	int ac;
-	unsigned long driver_release_tids = 0;
-	struct sk_buff_head frames;
-
-	/* Service or PS-Poll period starts */
-	set_sta_flag(sta, WLAN_STA_SP);
-
-	__skb_queue_head_init(&frames);
 
 	/* Get response frame(s) and more data bit for the last one. */
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
@@ -1366,26 +1397,13 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		/* if we already have frames from software, then we can't also
 		 * release from hardware queues
 		 */
-		if (skb_queue_empty(&frames)) {
-			driver_release_tids |= sta->driver_buffered_tids & tids;
-			driver_release_tids |= sta->txq_buffered_tids & tids;
+		if (skb_queue_empty(frames)) {
+			*driver_release_tids |=
+				sta->driver_buffered_tids & tids;
+			*driver_release_tids |= sta->txq_buffered_tids & tids;
 		}
 
-		if (driver_release_tids) {
-			/* If the driver has data on more than one TID then
-			 * certainly there's more data if we release just a
-			 * single frame now (from a single TID). This will
-			 * only happen for PS-Poll.
-			 */
-			if (reason == IEEE80211_FRAME_RELEASE_PSPOLL &&
-			    hweight16(driver_release_tids) > 1) {
-				more_data = true;
-				driver_release_tids =
-					BIT(find_highest_prio_tid(
-						driver_release_tids));
-				break;
-			}
-		} else {
+		if (!*driver_release_tids) {
 			struct sk_buff *skb;
 
 			while (n_frames > 0) {
@@ -1399,20 +1417,44 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 				if (!skb)
 					break;
 				n_frames--;
-				__skb_queue_tail(&frames, skb);
+				__skb_queue_tail(frames, skb);
 			}
 		}
 
-		/* If we have more frames buffered on this AC, then set the
-		 * more-data bit and abort the loop since we can't send more
-		 * data from other ACs before the buffered frames from this.
+		/* If we have more frames buffered on this AC, then abort the
+		 * loop since we can't send more data from other ACs before
+		 * the buffered frames from this.
 		 */
 		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
-		    !skb_queue_empty(&sta->ps_tx_buf[ac])) {
-			more_data = true;
+		    !skb_queue_empty(&sta->ps_tx_buf[ac]))
 			break;
-		}
 	}
+}
+
+static void
+ieee80211_sta_ps_deliver_response(struct sta_info *sta,
+				  int n_frames, u8 ignored_acs,
+				  enum ieee80211_frame_release_type reason)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+	unsigned long driver_release_tids = 0;
+	struct sk_buff_head frames;
+	bool more_data;
+
+	/* Service or PS-Poll period starts */
+	set_sta_flag(sta, WLAN_STA_SP);
+
+	__skb_queue_head_init(&frames);
+
+	ieee80211_sta_ps_get_frames(sta, n_frames, ignored_acs, reason,
+				    &frames, &driver_release_tids);
+
+	more_data = ieee80211_sta_ps_more_data(sta, ignored_acs, reason, driver_release_tids);
+
+	if (reason == IEEE80211_FRAME_RELEASE_PSPOLL)
+		driver_release_tids =
+			BIT(find_highest_prio_tid(driver_release_tids));
 
 	if (skb_queue_empty(&frames) && !driver_release_tids) {
 		int tid;
@@ -1435,7 +1477,7 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		/* This will evaluate to 1, 3, 5 or 7. */
 		tid = 7 - ((ffs(~ignored_acs) - 1) << 1);
 
-		ieee80211_send_null_response(sdata, sta, tid, reason, true);
+		ieee80211_send_null_response(sta, tid, reason, true, false);
 	} else if (!driver_release_tids) {
 		struct sk_buff_head pending;
 		struct sk_buff *skb;
@@ -1535,8 +1577,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 
 		if (need_null)
 			ieee80211_send_null_response(
-				sdata, sta, find_highest_prio_tid(tids),
-				reason, false);
+				sta, find_highest_prio_tid(tids),
+				reason, false, false);
 
 		sta_info_recalc_tim(sta);
 	} else {
@@ -1674,6 +1716,22 @@ void ieee80211_sta_eosp(struct ieee80211_sta *pubsta)
 }
 EXPORT_SYMBOL(ieee80211_sta_eosp);
 
+void ieee80211_send_eosp_nullfunc(struct ieee80211_sta *pubsta, int tid)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	enum ieee80211_frame_release_type reason;
+	bool more_data;
+
+	trace_api_send_eosp_nullfunc(sta->local, pubsta, tid);
+
+	reason = IEEE80211_FRAME_RELEASE_UAPSD;
+	more_data = ieee80211_sta_ps_more_data(sta, ~sta->sta.uapsd_queues,
+					       reason, 0);
+
+	ieee80211_send_null_response(sta, tid, reason, false, more_data);
+}
+EXPORT_SYMBOL(ieee80211_send_eosp_nullfunc);
+
 void ieee80211_sta_set_buffered(struct ieee80211_sta *pubsta,
 				u8 tid, bool buffered)
 {
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 56c6d6c..a6b4442 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2027,6 +2027,31 @@ TRACE_EVENT(api_eosp,
 	)
 );
 
+TRACE_EVENT(api_send_eosp_nullfunc,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sta *sta,
+		 u8 tid),
+
+	TP_ARGS(local, sta, tid),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		STA_ENTRY
+		__field(u8, tid)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		STA_ASSIGN;
+		__entry->tid = tid;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT STA_PR_FMT " tid:%d",
+		LOCAL_PR_ARG, STA_PR_ARG, __entry->tid
+	)
+);
+
 TRACE_EVENT(api_sta_set_buffered,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sta *sta,
-- 
2.5.0


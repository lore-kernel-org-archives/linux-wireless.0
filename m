Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0DGOso (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 10:48:44 -0400
Subject: [PATCH] mac80211: enhance tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 16:48:40 +0200
Message-ID: <1270651720.3858.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enhance tracing by adding tracing for a variety of
callbacks that the drivers call, and also for
internal calls (currently limited to queue status).
This can aid debugging what is going on in mac80211
in interaction with drivers, since we can now see
what drivers call and not just what mac80211 calls
in the driver.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/Kconfig        |    8 -
 net/mac80211/agg-tx.c       |    8 +
 net/mac80211/driver-trace.h |  275 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/main.c         |    2 
 net/mac80211/mlme.c         |    6 
 net/mac80211/scan.c         |    2 
 net/mac80211/sta_info.c     |    2 
 net/mac80211/util.c         |    4 
 8 files changed, 303 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/Kconfig	2010-04-05 15:58:47.000000000 +0200
+++ wireless-testing/net/mac80211/Kconfig	2010-04-07 16:28:16.000000000 +0200
@@ -221,8 +221,8 @@ config MAC80211_DRIVER_API_TRACER
 	depends on EVENT_TRACING
 	help
 	  Say Y here to make mac80211 register with the ftrace
-	  framework for the driver API -- you can see which
-	  driver methods it is calling then by looking at the
-	  trace.
+	  framework for the driver API -- you can then see which
+	  driver methods it is calling and which API functions
+	  drivers are calling by looking at the trace.
 
-	  If unsure, say N.
+	  If unsure, say Y.
--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-04-06 09:09:49.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-04-07 16:30:01.000000000 +0200
@@ -214,6 +214,8 @@ int ieee80211_start_tx_ba_session(struct
 	int ret = 0;
 	u16 start_seq_num;
 
+	trace_api_start_tx_ba_session(pubsta, tid);
+
 	if (WARN_ON(!local->ops->ampdu_action))
 		return -EINVAL;
 
@@ -440,6 +442,8 @@ void ieee80211_start_tx_ba_cb(struct iee
 	struct sta_info *sta;
 	u8 *state;
 
+	trace_api_start_tx_ba_cb(sdata, ra, tid);
+
 	if (tid >= STA_TID_NUM) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Bad TID value: tid = %d (>= %d)\n",
@@ -541,6 +545,8 @@ int ieee80211_stop_tx_ba_session(struct
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 
+	trace_api_stop_tx_ba_session(pubsta, tid, initiator);
+
 	if (!local->ops->ampdu_action)
 		return -EINVAL;
 
@@ -558,6 +564,8 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	struct sta_info *sta;
 	u8 *state;
 
+	trace_api_stop_tx_ba_cb(sdata, ra, tid);
+
 	if (tid >= STA_TID_NUM) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Bad TID value: tid = %d (>= %d)\n",
--- wireless-testing.orig/net/mac80211/driver-trace.h	2010-04-05 15:58:47.000000000 +0200
+++ wireless-testing/net/mac80211/driver-trace.h	2010-04-07 16:47:46.000000000 +0200
@@ -32,6 +32,10 @@ static inline void trace_ ## name(proto)
 #define VIF_PR_FMT	" vif:%s(%d)"
 #define VIF_PR_ARG	__get_str(vif_name), __entry->vif_type
 
+/*
+ * Tracing for driver callbacks.
+ */
+
 TRACE_EVENT(drv_start,
 	TP_PROTO(struct ieee80211_local *local, int ret),
 
@@ -766,6 +770,277 @@ TRACE_EVENT(drv_flush,
 		LOCAL_PR_ARG, __entry->drop
 	)
 );
+
+/*
+ * Tracing for API calls that drivers call.
+ */
+
+TRACE_EVENT(api_start_tx_ba_session,
+	TP_PROTO(struct ieee80211_sta *sta, u16 tid),
+
+	TP_ARGS(sta, tid),
+
+	TP_STRUCT__entry(
+		STA_ENTRY
+		__field(u16, tid)
+	),
+
+	TP_fast_assign(
+		STA_ASSIGN;
+		__entry->tid = tid;
+	),
+
+	TP_printk(
+		STA_PR_FMT " tid:%d",
+		STA_PR_ARG, __entry->tid
+	)
+);
+
+TRACE_EVENT(api_start_tx_ba_cb,
+	TP_PROTO(struct ieee80211_sub_if_data *sdata, const u8 *ra, u16 tid),
+
+	TP_ARGS(sdata, ra, tid),
+
+	TP_STRUCT__entry(
+		VIF_ENTRY
+		__array(u8, ra, ETH_ALEN)
+		__field(u16, tid)
+	),
+
+	TP_fast_assign(
+		VIF_ASSIGN;
+		memcpy(__entry->ra, ra, ETH_ALEN);
+		__entry->tid = tid;
+	),
+
+	TP_printk(
+		VIF_PR_FMT " ra:%pM tid:%d",
+		VIF_PR_ARG, __entry->ra, __entry->tid
+	)
+);
+
+TRACE_EVENT(api_stop_tx_ba_session,
+	TP_PROTO(struct ieee80211_sta *sta, u16 tid, u16 initiator),
+
+	TP_ARGS(sta, tid, initiator),
+
+	TP_STRUCT__entry(
+		STA_ENTRY
+		__field(u16, tid)
+		__field(u16, initiator)
+	),
+
+	TP_fast_assign(
+		STA_ASSIGN;
+		__entry->tid = tid;
+		__entry->initiator = initiator;
+	),
+
+	TP_printk(
+		STA_PR_FMT " tid:%d initiator:%d",
+		STA_PR_ARG, __entry->tid, __entry->initiator
+	)
+);
+
+TRACE_EVENT(api_stop_tx_ba_cb,
+	TP_PROTO(struct ieee80211_sub_if_data *sdata, const u8 *ra, u16 tid),
+
+	TP_ARGS(sdata, ra, tid),
+
+	TP_STRUCT__entry(
+		VIF_ENTRY
+		__array(u8, ra, ETH_ALEN)
+		__field(u16, tid)
+	),
+
+	TP_fast_assign(
+		VIF_ASSIGN;
+		memcpy(__entry->ra, ra, ETH_ALEN);
+		__entry->tid = tid;
+	),
+
+	TP_printk(
+		VIF_PR_FMT " ra:%pM tid:%d",
+		VIF_PR_ARG, __entry->ra, __entry->tid
+	)
+);
+
+TRACE_EVENT(api_restart_hw,
+	TP_PROTO(struct ieee80211_local *local),
+
+	TP_ARGS(local),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT,
+		LOCAL_PR_ARG
+	)
+);
+
+TRACE_EVENT(api_beacon_loss,
+	TP_PROTO(struct ieee80211_sub_if_data *sdata),
+
+	TP_ARGS(sdata),
+
+	TP_STRUCT__entry(
+		VIF_ENTRY
+	),
+
+	TP_fast_assign(
+		VIF_ASSIGN;
+	),
+
+	TP_printk(
+		VIF_PR_FMT,
+		VIF_PR_ARG
+	)
+);
+
+TRACE_EVENT(api_connection_loss,
+	TP_PROTO(struct ieee80211_sub_if_data *sdata),
+
+	TP_ARGS(sdata),
+
+	TP_STRUCT__entry(
+		VIF_ENTRY
+	),
+
+	TP_fast_assign(
+		VIF_ASSIGN;
+	),
+
+	TP_printk(
+		VIF_PR_FMT,
+		VIF_PR_ARG
+	)
+);
+
+TRACE_EVENT(api_cqm_rssi_notify,
+	TP_PROTO(struct ieee80211_sub_if_data *sdata,
+		 enum nl80211_cqm_rssi_threshold_event rssi_event),
+
+	TP_ARGS(sdata, rssi_event),
+
+	TP_STRUCT__entry(
+		VIF_ENTRY
+		__field(u32, rssi_event)
+	),
+
+	TP_fast_assign(
+		VIF_ASSIGN;
+		__entry->rssi_event = rssi_event;
+	),
+
+	TP_printk(
+		VIF_PR_FMT " event:%d",
+		VIF_PR_ARG, __entry->rssi_event
+	)
+);
+
+TRACE_EVENT(api_scan_completed,
+	TP_PROTO(struct ieee80211_local *local, bool aborted),
+
+	TP_ARGS(local, aborted),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(bool, aborted)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->aborted = aborted;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " aborted:%d",
+		LOCAL_PR_ARG, __entry->aborted
+	)
+);
+
+TRACE_EVENT(api_sta_block_awake,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sta *sta, bool block),
+
+	TP_ARGS(local, sta, block),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		STA_ENTRY
+		__field(bool, block)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		STA_ASSIGN;
+		__entry->block = block;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT STA_PR_FMT " block:%d",
+		LOCAL_PR_ARG, STA_PR_FMT, __entry->block
+	)
+);
+
+/*
+ * Tracing for internal functions
+ * (which may also be called in response to driver calls)
+ */
+
+TRACE_EVENT(wake_queue,
+	TP_PROTO(struct ieee80211_local *local, u16 queue,
+		 enum queue_stop_reason reason),
+
+	TP_ARGS(local, queue, reason),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u16, queue)
+		__field(u32, reason)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->queue = queue;
+		__entry->reason = reason;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " queue:%d, reason:%d",
+		LOCAL_PR_ARG, __entry->queue, __entry->reason
+	)
+);
+
+TRACE_EVENT(stop_queue,
+	TP_PROTO(struct ieee80211_local *local, u16 queue,
+		 enum queue_stop_reason reason),
+
+	TP_ARGS(local, queue, reason),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u16, queue)
+		__field(u32, reason)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->queue = queue;
+		__entry->reason = reason;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " queue:%d, reason:%d",
+		LOCAL_PR_ARG, __entry->queue, __entry->reason
+	)
+);
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
--- wireless-testing.orig/net/mac80211/main.c	2010-04-07 16:31:52.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-04-07 16:32:02.000000000 +0200
@@ -309,6 +309,8 @@ void ieee80211_restart_hw(struct ieee802
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
+	trace_api_restart_hw(local);
+
 	/* use this reason, __ieee80211_resume will unblock it */
 	ieee80211_stop_queues_by_reason(hw,
 		IEEE80211_QUEUE_STOP_REASON_SUSPEND);
--- wireless-testing.orig/net/mac80211/mlme.c	2010-04-07 16:32:52.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-04-07 16:35:14.000000000 +0200
@@ -1003,6 +1003,8 @@ void ieee80211_beacon_loss(struct ieee80
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_hw *hw = &sdata->local->hw;
 
+	trace_api_beacon_loss(sdata);
+
 	WARN_ON(hw->flags & IEEE80211_HW_CONNECTION_MONITOR);
 	ieee80211_queue_work(hw, &sdata->u.mgd.beacon_connection_loss_work);
 }
@@ -1013,6 +1015,8 @@ void ieee80211_connection_loss(struct ie
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_hw *hw = &sdata->local->hw;
 
+	trace_api_connection_loss(sdata);
+
 	WARN_ON(!(hw->flags & IEEE80211_HW_CONNECTION_MONITOR));
 	ieee80211_queue_work(hw, &sdata->u.mgd.beacon_connection_loss_work);
 }
@@ -2254,6 +2258,8 @@ void ieee80211_cqm_rssi_notify(struct ie
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 
+	trace_api_cqm_rssi_notify(sdata, rssi_event);
+
 	cfg80211_cqm_rssi_notify(sdata->dev, rssi_event, gfp);
 }
 EXPORT_SYMBOL(ieee80211_cqm_rssi_notify);
--- wireless-testing.orig/net/mac80211/scan.c	2010-04-07 16:35:44.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2010-04-07 16:36:43.000000000 +0200
@@ -247,6 +247,8 @@ void ieee80211_scan_completed(struct iee
 	struct ieee80211_local *local = hw_to_local(hw);
 	bool was_hw_scan;
 
+	trace_api_scan_completed(local, aborted);
+
 	mutex_lock(&local->scan_mtx);
 
 	/*
--- wireless-testing.orig/net/mac80211/sta_info.c	2010-04-07 16:36:53.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2010-04-07 16:38:12.000000000 +0200
@@ -957,6 +957,8 @@ void ieee80211_sta_block_awake(struct ie
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 
+	trace_api_sta_block_awake(sta->local, pubsta, block);
+
 	if (block)
 		set_sta_flags(sta, WLAN_STA_PS_DRIVER);
 	else
--- wireless-testing.orig/net/mac80211/util.c	2010-04-07 16:39:20.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-04-07 16:41:16.000000000 +0200
@@ -270,6 +270,8 @@ static void __ieee80211_wake_queue(struc
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 
+	trace_wake_queue(local, queue, reason);
+
 	if (WARN_ON(queue >= hw->queues))
 		return;
 
@@ -312,6 +314,8 @@ static void __ieee80211_stop_queue(struc
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 
+	trace_stop_queue(local, queue, reason);
+
 	if (WARN_ON(queue >= hw->queues))
 		return;
 



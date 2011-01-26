Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60670 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1AZIWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 03:22:17 -0500
Subject: [PATCH v3] mac80211: use DECLARE_EVENT_CLASS
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110125215810.GE2927@tuxdriver.com>
References: <1295437859.4685.4.camel@jlt3.sipsolutions.net>
	 <20110121212447.GB7092@tuxdriver.com>
	 <1295777573.3639.30.camel@jlt3.sipsolutions.net>
	 <20110125215810.GE2927@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 09:22:15 +0100
Message-ID: <1296030135.3635.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For events that include only the local struct as
their parameter, we can use DECLARE_EVENT_CLASS
and save quite some binary size across segments
as well lines of code.

   text	   data	    bss	    dec	    hex	filename
 375745	  19296	    916	 395957	  60ab5	mac80211.ko.before
 367473	  17888	    916	 386277	  5e4e5	mac80211.ko.after
  -8272   -1408       0   -9680   -25d0 delta

Some more tracepoints with identical arguments
could be combined like this but for now this is
the one that benefits most.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v3: fix compile w/o mac80211 events -- I had forgotten 
    we have a "manual override" in that case

 net/mac80211/driver-trace.h |  202 +++++++-------------------------------------
 1 file changed, 33 insertions(+), 169 deletions(-)

--- wireless-testing.orig/net/mac80211/driver-trace.h	2011-01-25 11:21:05.000000000 +0100
+++ wireless-testing/net/mac80211/driver-trace.h	2011-01-26 09:20:48.000000000 +0100
@@ -9,6 +9,11 @@
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, ...) \
 static inline void trace_ ## name(proto) {}
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(...)
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(evt_class, name, proto, ...) \
+static inline void trace_ ## name(proto) {}
 #endif
 
 #undef TRACE_SYSTEM
@@ -38,7 +43,7 @@ static inline void trace_ ## name(proto)
  * Tracing for driver callbacks.
  */
 
-TRACE_EVENT(drv_return_void,
+DECLARE_EVENT_CLASS(local_only_evt,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local),
 	TP_STRUCT__entry(
@@ -50,6 +55,11 @@ TRACE_EVENT(drv_return_void,
 	TP_printk(LOCAL_PR_FMT, LOCAL_PR_ARG)
 );
 
+DEFINE_EVENT(local_only_evt, drv_return_void,
+	TP_PROTO(struct ieee80211_local *local),
+	TP_ARGS(local)
+);
+
 TRACE_EVENT(drv_return_int,
 	TP_PROTO(struct ieee80211_local *local, int ret),
 	TP_ARGS(local, ret),
@@ -78,40 +88,14 @@ TRACE_EVENT(drv_return_u64,
 	TP_printk(LOCAL_PR_FMT " - %llu", LOCAL_PR_ARG, __entry->ret)
 );
 
-TRACE_EVENT(drv_start,
+DEFINE_EVENT(local_only_evt, drv_start,
 	TP_PROTO(struct ieee80211_local *local),
-
-	TP_ARGS(local),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT, LOCAL_PR_ARG
-	)
+	TP_ARGS(local)
 );
 
-TRACE_EVENT(drv_stop,
+DEFINE_EVENT(local_only_evt, drv_stop,
 	TP_PROTO(struct ieee80211_local *local),
-
-	TP_ARGS(local),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT, LOCAL_PR_ARG
-	)
+	TP_ARGS(local)
 );
 
 TRACE_EVENT(drv_add_interface,
@@ -439,40 +423,14 @@ TRACE_EVENT(drv_hw_scan,
 	)
 );
 
-TRACE_EVENT(drv_sw_scan_start,
+DEFINE_EVENT(local_only_evt, drv_sw_scan_start,
 	TP_PROTO(struct ieee80211_local *local),
-
-	TP_ARGS(local),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT, LOCAL_PR_ARG
-	)
+	TP_ARGS(local)
 );
 
-TRACE_EVENT(drv_sw_scan_complete,
+DEFINE_EVENT(local_only_evt, drv_sw_scan_complete,
 	TP_PROTO(struct ieee80211_local *local),
-
-	TP_ARGS(local),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT, LOCAL_PR_ARG
-	)
+	TP_ARGS(local)
 );
 
 TRACE_EVENT(drv_get_stats,
@@ -702,23 +660,9 @@ TRACE_EVENT(drv_conf_tx,
 	)
 );
 
-TRACE_EVENT(drv_get_tsf,
+DEFINE_EVENT(local_only_evt, drv_get_tsf,
 	TP_PROTO(struct ieee80211_local *local),
-
-	TP_ARGS(local),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT,
-		LOCAL_PR_ARG
-	)
+	TP_ARGS(local)
 );
 
 TRACE_EVENT(drv_set_tsf,
@@ -742,41 +686,14 @@ TRACE_EVENT(drv_set_tsf,
 	)
 );
 
-TRACE_EVENT(drv_reset_tsf,
+DEFINE_EVENT(local_only_evt, drv_reset_tsf,
 	TP_PROTO(struct ieee80211_local *local),
-
-	TP_ARGS(local),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT, LOCAL_PR_ARG
-	)
+	TP_ARGS(local)
 );
 
-TRACE_EVENT(drv_tx_last_beacon,
+DEFINE_EVENT(local_only_evt, drv_tx_last_beacon,
 	TP_PROTO(struct ieee80211_local *local),
-
-	TP_ARGS(local),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT,
-		LOCAL_PR_ARG
-	)
+	TP_ARGS(local)
 );
 
 TRACE_EVENT(drv_ampdu_action,
@@ -962,22 +879,9 @@ TRACE_EVENT(drv_remain_on_channel,
 	)
 );
 
-TRACE_EVENT(drv_cancel_remain_on_channel,
+DEFINE_EVENT(local_only_evt, drv_cancel_remain_on_channel,
 	TP_PROTO(struct ieee80211_local *local),
-
-	TP_ARGS(local),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT, LOCAL_PR_ARG
-	)
+	TP_ARGS(local)
 );
 
 /*
@@ -1072,23 +976,9 @@ TRACE_EVENT(api_stop_tx_ba_cb,
 	)
 );
 
-TRACE_EVENT(api_restart_hw,
+DEFINE_EVENT(local_only_evt, api_restart_hw,
 	TP_PROTO(struct ieee80211_local *local),
-
-	TP_ARGS(local),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT,
-		LOCAL_PR_ARG
-	)
+	TP_ARGS(local)
 );
 
 TRACE_EVENT(api_beacon_loss,
@@ -1217,40 +1107,14 @@ TRACE_EVENT(api_chswitch_done,
 	)
 );
 
-TRACE_EVENT(api_ready_on_channel,
+DEFINE_EVENT(local_only_evt, api_ready_on_channel,
 	TP_PROTO(struct ieee80211_local *local),
-
-	TP_ARGS(local),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT, LOCAL_PR_ARG
-	)
+	TP_ARGS(local)
 );
 
-TRACE_EVENT(api_remain_on_channel_expired,
+DEFINE_EVENT(local_only_evt, api_remain_on_channel_expired,
 	TP_PROTO(struct ieee80211_local *local),
-
-	TP_ARGS(local),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT, LOCAL_PR_ARG
-	)
+	TP_ARGS(local)
 );
 
 /*



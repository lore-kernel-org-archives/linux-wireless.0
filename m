Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:60630 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668Ab1EILkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 07:40:17 -0400
Received: by ewy5 with SMTP id 5so1672525ewy.20
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 04:40:14 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH v2] mac80211: add a couple of trace event classes to reduce duplicated code
Date: Mon,  9 May 2011 14:40:06 +0300
Message-Id: <1304941206-11472-1-git-send-email-coelho@ti.com> (sfid-20110509_134021_729500_160AF5D3)
In-Reply-To: <1304940808.12202.0.camel@jlt3.sipsolutions.net>
References: <1304940808.12202.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions drv_add_interface() and drv_remove_interface() print out
the same values in the traces.  Combine the traces of these two
functions into one event class to remove some duplicate code.

Also add a new class for functions drv_set_frag_threshold() and
drv_set_rts_threshold().

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/mac80211/driver-trace.h |  130 +++++++++++++++++-------------------------
 1 files changed, 53 insertions(+), 77 deletions(-)

diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 11e1ea5..dd9779d 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -55,6 +55,49 @@ DECLARE_EVENT_CLASS(local_only_evt,
 	TP_printk(LOCAL_PR_FMT, LOCAL_PR_ARG)
 );
 
+DECLARE_EVENT_CLASS(local_sdata_addr_evt,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__array(char, addr, 6)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		memcpy(__entry->addr, sdata->vif.addr, 6);
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT " addr:%pM",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->addr
+	)
+);
+
+DECLARE_EVENT_CLASS(local_u32_evt,
+	TP_PROTO(struct ieee80211_local *local, u32 value),
+	TP_ARGS(local, value),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u32, value)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->value = value;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " value:%d",
+		LOCAL_PR_ARG, __entry->value
+	)
+);
+
 DEFINE_EVENT(local_only_evt, drv_return_void,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
@@ -123,28 +166,10 @@ DEFINE_EVENT(local_only_evt, drv_stop,
 	TP_ARGS(local)
 );
 
-TRACE_EVENT(drv_add_interface,
+DEFINE_EVENT(local_sdata_addr_evt, drv_add_interface,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata),
-
-	TP_ARGS(local, sdata),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-		VIF_ENTRY
-		__array(char, addr, 6)
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-		VIF_ASSIGN;
-		memcpy(__entry->addr, sdata->vif.addr, 6);
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT " addr:%pM",
-		LOCAL_PR_ARG, VIF_PR_ARG, __entry->addr
-	)
+	TP_ARGS(local, sdata)
 );
 
 TRACE_EVENT(drv_change_interface,
@@ -175,27 +200,10 @@ TRACE_EVENT(drv_change_interface,
 	)
 );
 
-TRACE_EVENT(drv_remove_interface,
-	TP_PROTO(struct ieee80211_local *local, struct ieee80211_sub_if_data *sdata),
-
-	TP_ARGS(local, sdata),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-		VIF_ENTRY
-		__array(char, addr, 6)
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-		VIF_ASSIGN;
-		memcpy(__entry->addr, sdata->vif.addr, 6);
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT " addr:%pM",
-		LOCAL_PR_ARG, VIF_PR_ARG, __entry->addr
-	)
+DEFINE_EVENT(local_sdata_addr_evt, drv_remove_interface,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
 );
 
 TRACE_EVENT(drv_config,
@@ -514,46 +522,14 @@ TRACE_EVENT(drv_get_tkip_seq,
 	)
 );
 
-TRACE_EVENT(drv_set_frag_threshold,
+DEFINE_EVENT(local_u32_evt, drv_set_frag_threshold,
 	TP_PROTO(struct ieee80211_local *local, u32 value),
-
-	TP_ARGS(local, value),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-		__field(u32, value)
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-		__entry->value = value;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT " value:%d",
-		LOCAL_PR_ARG, __entry->value
-	)
+	TP_ARGS(local, value)
 );
 
-TRACE_EVENT(drv_set_rts_threshold,
+DEFINE_EVENT(local_u32_evt, drv_set_rts_threshold,
 	TP_PROTO(struct ieee80211_local *local, u32 value),
-
-	TP_ARGS(local, value),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-		__field(u32, value)
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-		__entry->value = value;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT " value:%d",
-		LOCAL_PR_ARG, __entry->value
-	)
+	TP_ARGS(local, value)
 );
 
 TRACE_EVENT(drv_set_coverage_class,
-- 
1.7.1


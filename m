Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaAFLEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:04:39 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add tracing for ieee80211_sta_set_buffered
Date: Mon,  6 Jan 2014 12:04:30 +0100
Message-Id: <1389006270-21768-1-git-send-email-johannes@sipsolutions.net> (sfid-20140106_120442_243958_09E1FBFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is useful for debugging issues with drivers using this
function (erroneously), so add tracing for the API call.

Change-Id: Ice9d7eabb8fecbac188f0a741920d3488de700ec
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |  2 ++
 net/mac80211/trace.h    | 27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4576ba0..8da3af2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1485,6 +1485,8 @@ void ieee80211_sta_set_buffered(struct ieee80211_sta *pubsta,
 	if (WARN_ON(tid >= IEEE80211_NUM_TIDS))
 		return;
 
+	trace_api_sta_set_buffered(sta->local, pubsta, tid, buffered);
+
 	if (buffered)
 		set_bit(tid, &sta->driver_buffered_tids);
 	else
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index da93666..a0b0aea 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1835,6 +1835,33 @@ TRACE_EVENT(api_eosp,
 	)
 );
 
+TRACE_EVENT(api_sta_set_buffered,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sta *sta,
+		 u8 tid, bool buffered),
+
+	TP_ARGS(local, sta, tid, buffered),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		STA_ENTRY
+		__field(u8, tid)
+		__field(bool, buffered)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		STA_ASSIGN;
+		__entry->tid = tid;
+		__entry->buffered = buffered;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT STA_PR_FMT " tid:%d buffered:%d",
+		LOCAL_PR_ARG, STA_PR_ARG, __entry->tid, __entry->buffered
+	)
+);
+
 /*
  * Tracing for internal functions
  * (which may also be called in response to driver calls)
-- 
1.8.5.1


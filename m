Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50078 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab2KHRU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 12:20:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove unused tracepoint
Date: Thu,  8 Nov 2012 18:21:31 +0100
Message-Id: <1352395291-6845-1-git-send-email-johannes@sipsolutions.net> (sfid-20121108_182108_712329_6E57FAAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Clearly the tracepoint drv_offchannel_tx was
forgotten when that functionality was removed,
remove it now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/trace.h | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 8b91a9f..758836c 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1049,34 +1049,6 @@ DEFINE_EVENT(local_only_evt, drv_cancel_remain_on_channel,
 	TP_ARGS(local)
 );
 
-TRACE_EVENT(drv_offchannel_tx,
-	TP_PROTO(struct ieee80211_local *local, struct sk_buff *skb,
-		 struct ieee80211_channel *chan,
-		 enum nl80211_channel_type channel_type,
-		 unsigned int wait),
-
-	TP_ARGS(local, skb, chan, channel_type, wait),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-		__field(int, center_freq)
-		__field(int, channel_type)
-		__field(unsigned int, wait)
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-		__entry->center_freq = chan->center_freq;
-		__entry->channel_type = channel_type;
-		__entry->wait = wait;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT " freq:%dMHz, wait:%dms",
-		LOCAL_PR_ARG, __entry->center_freq, __entry->wait
-	)
-);
-
 TRACE_EVENT(drv_set_ringparam,
 	TP_PROTO(struct ieee80211_local *local, u32 tx, u32 rx),
 
-- 
1.8.0


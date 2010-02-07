Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:52775 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529Ab0BGIWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 03:22:09 -0500
Subject: [PATCH 10/10] mac80211: remove get_tx_stats() driver op
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 07 Feb 2010 10:22:01 +0200
Message-ID: <20100207082201.31474.98843.stgit@tikku>
In-Reply-To: <20100207082044.31474.48583.stgit@tikku>
References: <20100207082044.31474.48583.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

get_tx_stats() driver operation is not currently used anywhere in mac80211
and there are no plans to use it in the not-so-near future. So it can go
without anyone missing it.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---
 Documentation/DocBook/mac80211.tmpl |    1 -
 include/net/mac80211.h              |   22 ----------------------
 net/mac80211/driver-ops.h           |    8 --------
 net/mac80211/driver-trace.h         |   23 -----------------------
 4 files changed, 0 insertions(+), 54 deletions(-)

diff --git a/Documentation/DocBook/mac80211.tmpl b/Documentation/DocBook/mac80211.tmpl
index 971d1c0..affb15a 100644
--- a/Documentation/DocBook/mac80211.tmpl
+++ b/Documentation/DocBook/mac80211.tmpl
@@ -234,7 +234,6 @@ usage should require reading the full document.
       <title>Multiple queues and QoS support</title>
       <para>TBD</para>
 !Finclude/net/mac80211.h ieee80211_tx_queue_params
-!Finclude/net/mac80211.h ieee80211_tx_queue_stats
     </chapter>
 
     <chapter id="AP">
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 74ccf30..b50d13e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -117,19 +117,6 @@ struct ieee80211_tx_queue_params {
 	bool uapsd;
 };
 
-/**
- * struct ieee80211_tx_queue_stats - transmit queue statistics
- *
- * @len: number of packets in queue
- * @limit: queue length limit
- * @count: number of frames sent
- */
-struct ieee80211_tx_queue_stats {
-	unsigned int len;
-	unsigned int limit;
-	unsigned int count;
-};
-
 struct ieee80211_low_level_stats {
 	unsigned int dot11ACKFailureCount;
 	unsigned int dot11RTSFailureCount;
@@ -1543,13 +1530,6 @@ enum ieee80211_ampdu_mlme_action {
  *	Returns a negative error code on failure.
  *	The callback can sleep.
  *
- * @get_tx_stats: Get statistics of the current TX queue status. This is used
- *	to get number of currently queued packets (queue length), maximum queue
- *	size (limit), and total number of packets sent using each TX queue
- *	(count). The 'stats' pointer points to an array that has hw->queues
- *	items.
- *	The callback must be atomic.
- *
  * @get_tsf: Get the current TSF timer value from firmware/hardware. Currently,
  *	this is only used for IBSS mode BSSID merging and debugging. Is not a
  *	required function.
@@ -1639,8 +1619,6 @@ struct ieee80211_ops {
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
 	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
-	int (*get_tx_stats)(struct ieee80211_hw *hw,
-			    struct ieee80211_tx_queue_stats *stats);
 	u64 (*get_tsf)(struct ieee80211_hw *hw);
 	void (*set_tsf)(struct ieee80211_hw *hw, u64 tsf);
 	void (*reset_tsf)(struct ieee80211_hw *hw);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 6c31f38..c447228 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -256,14 +256,6 @@ static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
 	return ret;
 }
 
-static inline int drv_get_tx_stats(struct ieee80211_local *local,
-				   struct ieee80211_tx_queue_stats *stats)
-{
-	int ret = local->ops->get_tx_stats(&local->hw, stats);
-	trace_drv_get_tx_stats(local, stats, ret);
-	return ret;
-}
-
 static inline u64 drv_get_tsf(struct ieee80211_local *local)
 {
 	u64 ret = -1ULL;
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 502424b..70e8bc6 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -578,29 +578,6 @@ TRACE_EVENT(drv_conf_tx,
 	)
 );
 
-TRACE_EVENT(drv_get_tx_stats,
-	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_tx_queue_stats *stats,
-		 int ret),
-
-	TP_ARGS(local, stats, ret),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-		__field(int, ret)
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-		__entry->ret = ret;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT " ret:%d",
-		LOCAL_PR_ARG, __entry->ret
-	)
-);
-
 TRACE_EVENT(drv_get_tsf,
 	TP_PROTO(struct ieee80211_local *local, u64 ret),
 


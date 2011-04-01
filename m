Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30187 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab1DALpb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 07:45:31 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 04:45:06 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Subject: [RFC PATCH 1/2] mac80211: Check for queued frames before entering power save.
Date: Fri, 1 Apr 2011 17:15:23 +0530
Message-ID: <1301658324-11530-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In a highly noisy environment, since the driver could not send
the packets out in 100ms, some applications stall and eventually
fail as mac80211 stops the netdevice queues for flush when power
save is triggered. Most of the WMM testcases fail in the Wifi
testing because of this.
Increasing the dynamic ps timeout to 200-300ms helps but in noisy
channel conditions even if there is a continuous tx traffic, mac80211
tries to go into PS. The new implementation checks for any frames
queued in the driver tx queues and based on that mac80211 decides
to go for power save. This also prevents redundant stopping of
netdevice queues which helps more applications to run properly.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 include/net/mac80211.h      |    4 ++++
 net/mac80211/driver-ops.h   |   13 +++++++++++++
 net/mac80211/driver-trace.h |   20 ++++++++++++++++++++
 net/mac80211/mlme.c         |   17 +++++++++--------
 4 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cefe1b3..dca4d21 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1808,6 +1808,9 @@ enum ieee80211_ampdu_mlme_action {
  * @set_ringparam: Set tx and rx ring sizes.
  *
  * @get_ringparam: Get tx and rx ring current and maximum sizes.
+ *
+ * @tx_frames_pending: Check if there is any pending frame in the hardware
+ *	queues before entering power save.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1895,6 +1898,7 @@ struct ieee80211_ops {
 	int (*set_ringparam)(struct ieee80211_hw *hw, u32 tx, u32 rx);
 	void (*get_ringparam)(struct ieee80211_hw *hw,
 			      u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
+	bool (*tx_frames_pending)(struct ieee80211_hw *hw);
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 9c0d62b..00a0685 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -552,4 +552,17 @@ static inline void drv_get_ringparam(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline bool drv_tx_frames_pending(struct ieee80211_local *local)
+{
+	bool ret = false;
+
+	might_sleep();
+
+	trace_drv_tx_frames_pending(local);
+	if (local->ops->tx_frames_pending)
+		ret = local->ops->tx_frames_pending(&local->hw);
+	trace_drv_return_bool(local, ret);
+
+	return ret;
+}
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 45aab80..c8c934d 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -74,6 +74,21 @@ TRACE_EVENT(drv_return_int,
 	TP_printk(LOCAL_PR_FMT " - %d", LOCAL_PR_ARG, __entry->ret)
 );
 
+TRACE_EVENT(drv_return_bool,
+	TP_PROTO(struct ieee80211_local *local, bool ret),
+	TP_ARGS(local, ret),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(bool, ret)
+	),
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->ret = ret;
+	),
+	TP_printk(LOCAL_PR_FMT " - %s", LOCAL_PR_ARG, (__entry->ret) ?
+		  "true" : "false")
+);
+
 TRACE_EVENT(drv_return_u64,
 	TP_PROTO(struct ieee80211_local *local, u64 ret),
 	TP_ARGS(local, ret),
@@ -964,6 +979,11 @@ TRACE_EVENT(drv_get_ringparam,
 	)
 );
 
+DEFINE_EVENT(local_only_evt, drv_tx_frames_pending,
+	TP_PROTO(struct ieee80211_local *local),
+	TP_ARGS(local)
+);
+
 DEFINE_EVENT(local_only_evt, drv_offchannel_tx_cancel_wait,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 64d92d5..fd49280 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -770,15 +770,16 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
 	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
 		netif_tx_stop_all_queues(sdata->dev);
-		/*
-		 * Flush all the frames queued in the driver before
-		 * going to power save
-		 */
-		drv_flush(local, false);
-		ieee80211_send_nullfunc(local, sdata, 1);
 
-		/* Flush once again to get the tx status of nullfunc frame */
-		drv_flush(local, false);
+		if (drv_tx_frames_pending(local))
+			mod_timer(&local->dynamic_ps_timer, jiffies +
+				  msecs_to_jiffies(
+				  local->hw.conf.dynamic_ps_timeout));
+		else {
+			ieee80211_send_nullfunc(local, sdata, 1);
+			/* Flush to get the tx status of nullfunc frame */
+			drv_flush(local, false);
+		}
 	}
 
 	if (!((local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
-- 
1.6.3.3


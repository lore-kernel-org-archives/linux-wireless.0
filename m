Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51351 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab1DFGL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 02:11:27 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 23:11:02 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] mac80211: Check for queued frames before entering power save.
Date: Wed, 6 Apr 2011 11:41:10 +0530
Message-ID: <1302070271-8343-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In a highly noisy environment, the tx rate of the driver drops and
the application slows down since it has not yet received ACKs for
the frames already queued in the hardware. Since this ACK may take
more than 100ms, stopping the dev queues for entering PS at this
stage breaks applications, WMM test cases in my testing.
If there are frames already pending in the tx queue, postponing the
PS logic helps to avoid redundant queue stops. When power save is
enabled by default and in a noisy environment, this API certainly
helps in improving the average throughput.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 include/net/mac80211.h      |    4 ++++
 net/mac80211/driver-ops.h   |   13 +++++++++++++
 net/mac80211/driver-trace.h |   20 ++++++++++++++++++++
 net/mac80211/mlme.c         |   17 +++++++++--------
 4 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 965f1b1..361bc5d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1819,6 +1819,9 @@ enum ieee80211_ampdu_mlme_action {
  * @set_ringparam: Set tx and rx ring sizes.
  *
  * @get_ringparam: Get tx and rx ring current and maximum sizes.
+ *
+ * @tx_frames_pending: Check if there is any pending frame in the hardware
+ *	queues before entering power save.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1906,6 +1909,7 @@ struct ieee80211_ops {
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


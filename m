Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43656 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab1ATRco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 12:32:44 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 2/3] mac80211: Support scanning only current active channel.
Date: Thu, 20 Jan 2011 09:32:29 -0800
Message-Id: <1295544750-6704-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1295544750-6704-1-git-send-email-greearb@candelatech.com>
References: <1295544750-6704-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This allows user-space to request scan on only the current
channel and have that not interfere with other traffic.

Especially useful when using virtual stations that must
all run on the same channel anyway.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 78af32d... 7cd7af8... M	net/mac80211/driver-ops.h
:100644 100644 fbabbc2... 8c6d253... M	net/mac80211/driver-trace.h
:100644 100644 c47d7c0... 388db0e... M	net/mac80211/ieee80211_i.h
:100644 100644 1236710... b1767a5... M	net/mac80211/rx.c
:100644 100644 fb274db... b42e5ad... M	net/mac80211/scan.c
 net/mac80211/driver-ops.h   |   12 ++++++++
 net/mac80211/driver-trace.h |   18 ++++++++++++
 net/mac80211/ieee80211_i.h  |    3 ++
 net/mac80211/rx.c           |    1 +
 net/mac80211/scan.c         |   61 +++++++++++++++++++++++++++++++-----------
 5 files changed, 79 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 78af32d..7cd7af8 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -201,6 +201,18 @@ static inline void drv_sw_scan_start(struct ieee80211_local *local)
 	trace_drv_return_void(local);
 }
 
+static inline void drv_sw_scan_start_cur(struct ieee80211_local *local,
+					 bool cur_channel_only)
+{
+	might_sleep();
+
+	trace_drv_sw_scan_start_cur(local);
+	if (local->ops->sw_scan_start_cur)
+		local->ops->sw_scan_start_cur(&local->hw,
+					      cur_channel_only);
+	trace_drv_return_void(local);
+}
+
 static inline void drv_sw_scan_complete(struct ieee80211_local *local)
 {
 	might_sleep();
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index fbabbc2..8c6d253 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -457,6 +457,24 @@ TRACE_EVENT(drv_sw_scan_start,
 	)
 );
 
+TRACE_EVENT(drv_sw_scan_start_cur,
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
+		LOCAL_PR_FMT, LOCAL_PR_ARG
+	)
+);
+
 TRACE_EVENT(drv_sw_scan_complete,
 	TP_PROTO(struct ieee80211_local *local),
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c47d7c0..388db0e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -660,6 +660,8 @@ struct tpt_led_trigger {
  *	that the scan completed.
  * @SCAN_ABORTED: Set for our scan work function when the driver reported
  *	a scan complete for an aborted scan.
+ * @SCAN_ON_CUR_CHANNEL:  Set when we are scanning only on the current
+ *      channel.  This means no off/on-channel logic needs to be run.
  */
 enum {
 	SCAN_SW_SCANNING,
@@ -667,6 +669,7 @@ enum {
 	SCAN_OFF_CHANNEL,
 	SCAN_COMPLETED,
 	SCAN_ABORTED,
+	SCAN_ON_CUR_CHANNEL,
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1236710..b1767a5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2749,6 +2749,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		local->dot11ReceivedFragmentCount++;
 
 	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
+		     test_bit(SCAN_ON_CUR_CHANNEL, &local->scanning) ||
 		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
 		status->rx_flags |= IEEE80211_RX_IN_SCAN;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index fb274db..b42e5ad 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -293,11 +293,17 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	if (!test_bit(SCAN_ON_CUR_CHANNEL, &local->scanning))
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+
 	if (!was_hw_scan) {
 		ieee80211_configure_filter(local);
 		drv_sw_scan_complete(local);
-		ieee80211_offchannel_return(local, true);
+		if (!test_bit(SCAN_ON_CUR_CHANNEL, &local->scanning))
+			/* Don't call this if we never left the channel. */
+			ieee80211_offchannel_return(local, true);
+		else
+			__clear_bit(SCAN_ON_CUR_CHANNEL, &local->scanning);
 	}
 
 	mutex_lock(&local->mtx);
@@ -338,15 +344,28 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	 * nullfunc frames and probe requests will be dropped in
 	 * ieee80211_tx_h_check_assoc().
 	 */
-	drv_sw_scan_start(local);
 
-	ieee80211_offchannel_stop_beaconing(local);
+	if (local->ops->sw_scan_start_cur &&
+	    local->scan_req->n_channels == 1 &&
+	    local->scan_req->channels[0] == local->hw.conf.channel) {
+		__set_bit(SCAN_ON_CUR_CHANNEL, &local->scanning);
+		drv_sw_scan_start_cur(local, true);
+	} else
+		drv_sw_scan_start(local);
+
+	/* If we are scanning one channel, and only our own channel
+	 * then we don't need to call the off-channel logic.
+	 */
+	if (!test_bit(SCAN_ON_CUR_CHANNEL, &local->scanning)) {
+		ieee80211_offchannel_stop_beaconing(local);
+		local->leave_oper_channel_time = 0;
+	}
 
-	local->leave_oper_channel_time = 0;
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
-	drv_flush(local, false);
+	if (!test_bit(SCAN_ON_CUR_CHANNEL, &local->scanning))
+		drv_flush(local, false);
 
 	ieee80211_configure_filter(local);
 
@@ -522,10 +541,14 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 			local->next_scan_state = SCAN_SET_CHANNEL;
 	} else {
 		/*
-		 * we're on the operating channel currently, let's
-		 * leave that channel now to scan another one
+		 * We're on the operating channel currently, Leave that
+		 * channel only if we are probing more than the current
+		 * channel.
 		 */
-		local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
+		if (test_bit(SCAN_ON_CUR_CHANNEL, &local->scanning))
+			local->next_scan_state = SCAN_SET_CHANNEL;
+		else
+			local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
 	}
 
 	*next_delay = 0;
@@ -559,14 +582,19 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
 {
 	/* switch back to the operating channel */
 	local->scan_channel = NULL;
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
-	/*
-	 * Only re-enable station mode interface now; beaconing will be
-	 * re-enabled once the full scan has been completed.
+	/* We only return if we ever left, and should never leave if
+	 * scanning single channel that is also the operating channel.
 	 */
-	ieee80211_offchannel_return(local, false);
+	if (!test_bit(SCAN_ON_CUR_CHANNEL, &local->scanning)) {
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
+		/*
+		 * Only re-enable station mode interface now; beaconing will be
+		 * re-enabled once the full scan has been completed.
+		 */
+		ieee80211_offchannel_return(local, false);
+	}
 	__clear_bit(SCAN_OFF_CHANNEL, &local->scanning);
 
 	*next_delay = HZ / 5;
@@ -583,8 +611,9 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	chan = local->scan_req->channels[local->scan_channel_idx];
 
 	local->scan_channel = chan;
-	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
-		skip = 1;
+	if (local->hw.conf.channel != chan)
+		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
+			skip = 1;
 
 	/* advance state machine to next channel/band */
 	local->scan_channel_idx++;
-- 
1.7.2.3


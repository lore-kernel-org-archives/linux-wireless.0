Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbZK2LVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 06:21:11 -0500
Subject: [PATCH] mac80211: introduce flush operation
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Nov 2009 12:20:49 +0100
Message-ID: <1259493649.32171.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've long lacked a good confirmation that frames
have really gone out, e.g. before going off-channel
for a scan. Add a flush() operation that drivers
can implement to provide that confirmation, and use
it in a few places:
 * before scanning sends the nullfunc frames
 * after scanning sends the nullfunc frames, if any
 * when going idle, to send any pending frames

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |   11 +++++++++++
 include/net/mac80211.h                |    5 +++++
 net/mac80211/driver-ops.h             |    7 +++++++
 net/mac80211/driver-trace.h           |   21 +++++++++++++++++++++
 net/mac80211/iface.c                  |    2 ++
 net/mac80211/scan.c                   |   13 +++++++++++--
 6 files changed, 57 insertions(+), 2 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-11-29 11:33:29.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-11-29 11:33:52.000000000 +0100
@@ -1486,6 +1486,10 @@ enum ieee80211_ampdu_mlme_action {
  *	and need to call wiphy_rfkill_set_hw_state() in the callback.
  *
  * @testmode_cmd: Implement a cfg80211 test mode command.
+ *
+ * @flush: Flush all pending frames from the hardware queue, making sure
+ *	that the hardware queues are empty. If the parameter @drop is set
+ *	to %true, pending frames may be dropped.
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1542,6 +1546,7 @@ struct ieee80211_ops {
 #ifdef CONFIG_NL80211_TESTMODE
 	int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
 #endif
+	void (*flush)(struct ieee80211_hw *hw, bool drop);
 };
 
 /**
--- wireless-testing.orig/net/mac80211/driver-ops.h	2009-11-29 11:33:01.000000000 +0100
+++ wireless-testing/net/mac80211/driver-ops.h	2009-11-29 11:33:52.000000000 +0100
@@ -259,4 +259,11 @@ static inline void drv_rfkill_poll(struc
 	if (local->ops->rfkill_poll)
 		local->ops->rfkill_poll(&local->hw);
 }
+
+static inline void drv_flush(struct ieee80211_local *local, bool drop)
+{
+	trace_drv_flush(local, drop);
+	if (local->ops->flush)
+		local->ops->flush(&local->hw, drop);
+}
 #endif /* __MAC80211_DRIVER_OPS */
--- wireless-testing.orig/net/mac80211/driver-trace.h	2009-11-29 11:33:01.000000000 +0100
+++ wireless-testing/net/mac80211/driver-trace.h	2009-11-29 11:33:52.000000000 +0100
@@ -688,6 +688,27 @@ TRACE_EVENT(drv_ampdu_action,
 		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->action, __entry->tid, __entry->ret
 	)
 );
+
+TRACE_EVENT(drv_flush,
+	TP_PROTO(struct ieee80211_local *local, bool drop),
+
+	TP_ARGS(local, drop),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(bool, drop)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->drop = drop;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " drop:%d",
+		LOCAL_PR_ARG, __entry->drop
+	)
+);
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
--- wireless-testing.orig/net/mac80211/scan.c	2009-11-29 11:33:01.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-11-29 11:33:52.000000000 +0100
@@ -406,9 +406,10 @@ static int ieee80211_start_sw_scan(struc
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
+	drv_flush(local, false);
+
 	ieee80211_configure_filter(local);
 
-	/* TODO: start scan as soon as all nullfunc frames are ACKed */
 	ieee80211_queue_delayed_work(&local->hw,
 				     &local->scan_work,
 				     IEEE80211_CHANNEL_TIME);
@@ -572,8 +573,16 @@ static void ieee80211_scan_state_leave_o
 
 	__set_bit(SCAN_OFF_CHANNEL, &local->scanning);
 
+	/*
+	 * What if the nullfunc frames didn't arrive?
+	 */
+	drv_flush(local, false);
+	if (local->ops->flush)
+		*next_delay = 0;
+	else
+		*next_delay = HZ / 10;
+
 	/* advance to the next channel to be scanned */
-	*next_delay = HZ / 10;
 	local->next_scan_state = SCAN_SET_CHANNEL;
 }
 
--- wireless-testing.orig/net/mac80211/iface.c	2009-11-29 11:33:01.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-11-29 11:33:52.000000000 +0100
@@ -926,6 +926,8 @@ static u32 ieee80211_idle_on(struct ieee
 	       wiphy_name(local->hw.wiphy));
 #endif
 
+	drv_flush(local, false);
+
 	local->hw.conf.flags |= IEEE80211_CONF_IDLE;
 	return IEEE80211_CONF_CHANGE_IDLE;
 }
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-11-29 11:33:01.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-11-29 11:33:52.000000000 +0100
@@ -852,6 +852,16 @@ static int mac80211_hwsim_ampdu_action(s
 	return 0;
 }
 
+static void mac80211_hwsim_flush(struct ieee80211_hw *hw, bool drop)
+{
+	/*
+	 * In this special case, there's nothing we need to
+	 * do because hwsim does transmission synchronously.
+	 * In the future, when it does transmissions via
+	 * userspace, we may need to do something.
+	 */
+}
+
 
 static const struct ieee80211_ops mac80211_hwsim_ops =
 {
@@ -868,6 +878,7 @@ static const struct ieee80211_ops mac802
 	.conf_tx = mac80211_hwsim_conf_tx,
 	CFG80211_TESTMODE_CMD(mac80211_hwsim_testmode_cmd)
 	.ampdu_action = mac80211_hwsim_ampdu_action,
+	.flush = mac80211_hwsim_flush,
 };
 
 



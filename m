Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42683 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab1CAUgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 15:36:49 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so5089422wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 12:36:48 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 3/9] mac80211: add WoW param to .start/.stop callbacks
Date: Tue,  1 Mar 2011 22:36:38 +0200
Message-Id: <1299011804-13899-4-git-send-email-eliad@wizery.com>
In-Reply-To: <1299011804-13899-1-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a param which contains the enabled Wake-On-Wireless triggers,
so lower drivers prepare themselves to suspend/resume
(e.g. configure triggers to fw, mask irqs, etc.)

NOTE: this patch requires changing all the mac80211-based drivers.
currently, as this is a preliminary version, it contains only patch
for wl12xx (on which the developmont was done).

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    6 +++-
 include/net/mac80211.h             |   19 ++++++++++----
 net/mac80211/driver-ops.h          |   14 ++++++----
 net/mac80211/driver-trace.h        |   47 +++++++++++++++++++++++++++++++----
 net/mac80211/iface.c               |    6 ++--
 net/mac80211/util.c                |    4 +-
 6 files changed, 71 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 95aa19a..3a7d788 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1081,7 +1081,8 @@ static struct notifier_block wl1271_dev_notifier = {
 	.notifier_call = wl1271_dev_notify,
 };
 
-static int wl1271_op_start(struct ieee80211_hw *hw)
+static int wl1271_op_start(struct ieee80211_hw *hw,
+			   struct cfg80211_wow *wow)
 {
 	wl1271_debug(DEBUG_MAC80211, "mac80211 start");
 
@@ -1102,7 +1103,8 @@ static int wl1271_op_start(struct ieee80211_hw *hw)
 	return 0;
 }
 
-static void wl1271_op_stop(struct ieee80211_hw *hw)
+static void wl1271_op_stop(struct ieee80211_hw *hw,
+			   struct cfg80211_wow *wow)
 {
 	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
 }
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8fcd169..86d5781 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1588,8 +1588,12 @@ enum ieee80211_ampdu_mlme_action {
  *	Must be implemented and atomic.
  *
  * @start: Called before the first netdevice attached to the hardware
- *	is enabled. This should turn on the hardware and must turn on
- *	frame reception (for possibly enabled monitor interfaces.)
+ *	is enabled, or when waking-on-wireless.
+ *	In case of no enabled WoW triggers - this should turn on the
+ *	hardware and must turn on frame reception (for possibly
+ *	enabled monitor interfaces).
+ *	In case of enabled WoW triggers - this might remove the WoW
+ *	triggers configuration from the hardware (if needed).
  *	Returns negative error codes, these may be seen in userspace,
  *	or zero.
  *	When the device is started it should not have a MAC address
@@ -1598,8 +1602,11 @@ enum ieee80211_ampdu_mlme_action {
  *	Must be implemented and can sleep.
  *
  * @stop: Called after last netdevice attached to the hardware
- *	is disabled. This should turn off the hardware (at least
- *	it must turn off frame reception.)
+ *	is disabled, or during suspend while WoW triggers are configured.
+ *	In case of no enabled WoW triggers - this should turn off the
+ *	hardware (at least it must turn off frame reception).
+ *	In case of enabled WoW triggers - this should configure the
+ *	hardware with the WoW triggers.
  *	May be called right after add_interface if that rejects
  *	an interface. If you added any work onto the mac80211 workqueue
  *	you should ensure to cancel it on this callback.
@@ -1801,8 +1808,8 @@ enum ieee80211_ampdu_mlme_action {
  */
 struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
-	int (*start)(struct ieee80211_hw *hw);
-	void (*stop)(struct ieee80211_hw *hw);
+	int (*start)(struct ieee80211_hw *hw, struct cfg80211_wow *wow);
+	void (*stop)(struct ieee80211_hw *hw, struct cfg80211_wow *wow);
 	int (*add_interface)(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
 	int (*change_interface)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 78af32d..ca93e82 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -10,26 +10,28 @@ static inline int drv_tx(struct ieee80211_local *local, struct sk_buff *skb)
 	return local->ops->tx(&local->hw, skb);
 }
 
-static inline int drv_start(struct ieee80211_local *local)
+static inline int drv_start(struct ieee80211_local *local,
+			    struct cfg80211_wow *wow)
 {
 	int ret;
 
 	might_sleep();
 
-	trace_drv_start(local);
+	trace_drv_start(local, wow);
 	local->started = true;
 	smp_mb();
-	ret = local->ops->start(&local->hw);
+	ret = local->ops->start(&local->hw, wow);
 	trace_drv_return_int(local, ret);
 	return ret;
 }
 
-static inline void drv_stop(struct ieee80211_local *local)
+static inline void drv_stop(struct ieee80211_local *local,
+			    struct cfg80211_wow *wow)
 {
 	might_sleep();
 
-	trace_drv_stop(local);
-	local->ops->stop(&local->hw);
+	trace_drv_stop(local, wow);
+	local->ops->stop(&local->hw, wow);
 	trace_drv_return_void(local);
 
 	/* sync away all work on the tasklet before clearing started */
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index e5cce19..cbd4b45 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -88,14 +88,49 @@ TRACE_EVENT(drv_return_u64,
 	TP_printk(LOCAL_PR_FMT " - %llu", LOCAL_PR_ARG, __entry->ret)
 );
 
-DEFINE_EVENT(local_only_evt, drv_start,
-	TP_PROTO(struct ieee80211_local *local),
-	TP_ARGS(local)
+TRACE_EVENT(drv_start,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct cfg80211_wow *wow),
+
+
+	TP_ARGS(local, wow),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(bool, resume)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->resume = !!wow;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT "%s",
+		LOCAL_PR_ARG, __entry->resume ? "resume" : ""
+	)
 );
 
-DEFINE_EVENT(local_only_evt, drv_stop,
-	TP_PROTO(struct ieee80211_local *local),
-	TP_ARGS(local)
+TRACE_EVENT(drv_stop,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct cfg80211_wow *wow),
+
+	TP_ARGS(local, wow),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(bool, suspend)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->suspend = !!wow;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT "%s",
+		LOCAL_PR_ARG, __entry->suspend ? "suspend" : ""
+	)
 );
 
 TRACE_EVENT(drv_add_interface,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index a0e3779..a9b25b1 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -212,7 +212,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	}
 
 	if (local->open_count == 0) {
-		res = drv_start(local);
+		res = drv_start(local, NULL);
 		if (res)
 			goto err_del_bss;
 		if (local->ops->napi_poll)
@@ -236,7 +236,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 
 		if (!is_valid_ether_addr(dev->dev_addr)) {
 			if (!local->open_count)
-				drv_stop(local);
+				drv_stop(local, NULL);
 			return -EADDRNOTAVAIL;
 		}
 	}
@@ -348,7 +348,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	drv_remove_interface(local, &sdata->vif);
  err_stop:
 	if (!local->open_count)
-		drv_stop(local);
+		drv_stop(local, NULL);
  err_del_bss:
 	sdata->bss = NULL;
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2058965..627175a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1116,7 +1116,7 @@ void ieee80211_stop_device(struct ieee80211_local *local,
 	cancel_work_sync(&local->reconfig_filter);
 
 	flush_workqueue(local->workqueue);
-	drv_stop(local);
+	drv_stop(local, wow);
 }
 
 int ieee80211_reconfig(struct ieee80211_local *local,
@@ -1138,7 +1138,7 @@ int ieee80211_reconfig(struct ieee80211_local *local,
 		 * the device may at times not work immediately. Propagate
 		 * the error.
 		 */
-		res = drv_start(local);
+		res = drv_start(local, wow);
 		if (res) {
 			WARN(local->suspended, "Hardware became unavailable "
 			     "upon resume. This could be a software issue "
-- 
1.7.0.4


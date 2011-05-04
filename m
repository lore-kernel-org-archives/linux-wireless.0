Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51627 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1EDNjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 09:39:47 -0400
Message-Id: <20110504133842.808516400@sipsolutions.net> (sfid-20110504_153951_704143_BBB28184)
Date: Wed, 04 May 2011 15:37:29 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: add basic support for WoWLAN
References: <20110504133727.971543681@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This adds basic support for the new WoWLAN
configuration in mac80211. The behaviour is
completely offloaded to the driver though,
with two new callbacks (suspend/resume).

Options for the driver include a complete
reconfiguration after wakeup, and exposing
all the triggers it wants to support.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h      |   16 ++++++++++++++++
 net/mac80211/cfg.c          |    2 +-
 net/mac80211/debugfs.c      |    2 +-
 net/mac80211/driver-ops.h   |   27 +++++++++++++++++++++++++++
 net/mac80211/driver-trace.h |   10 ++++++++++
 net/mac80211/ieee80211_i.h  |    9 +++++++--
 net/mac80211/main.c         |    4 ++++
 net/mac80211/pm.c           |   13 ++++++++++++-
 net/mac80211/util.c         |   19 +++++++++++++++++++
 9 files changed, 97 insertions(+), 5 deletions(-)

--- a/include/net/mac80211.h	2011-05-04 15:22:38.000000000 +0200
+++ b/include/net/mac80211.h	2011-05-04 15:24:19.000000000 +0200
@@ -1606,6 +1606,18 @@ enum ieee80211_ampdu_mlme_action {
  *	you should ensure to cancel it on this callback.
  *	Must be implemented and can sleep.
  *
+ * @suspend: Suspend the device; mac80211 itself will quiesce before and
+ *	stop transmitting and doing any other configuration, and then
+ *	ask the device to suspend. This is only invoked when WoWLAN is
+ *	configured, otherwise the device is deconfigured completely and
+ *	reconfigured at resume time.
+ *
+ * @resume: If WoWLAN was configured, this indicates that mac80211 is
+ *	now resuming its operation, after this the device must be fully
+ *	functional again. If this returns an error, the only way out is
+ *	to also unregister the device. If it returns 1, then mac80211
+ *	will also go through the regular complete restart on resume.
+ *
  * @add_interface: Called when a netdevice attached to the hardware is
  *	enabled. Because it is not called for monitor mode devices, @start
  *	and @stop must be implemented.
@@ -1826,6 +1838,10 @@ struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
 	int (*start)(struct ieee80211_hw *hw);
 	void (*stop)(struct ieee80211_hw *hw);
+#ifdef CONFIG_PM
+	int (*suspend)(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan);
+	int (*resume)(struct ieee80211_hw *hw);
+#endif
 	int (*add_interface)(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
 	int (*change_interface)(struct ieee80211_hw *hw,
--- a/net/mac80211/cfg.c	2011-05-04 15:22:39.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-05-04 15:24:19.000000000 +0200
@@ -1300,7 +1300,7 @@ static int ieee80211_set_channel(struct
 static int ieee80211_suspend(struct wiphy *wiphy,
 			     struct cfg80211_wowlan *wowlan)
 {
-	return __ieee80211_suspend(wiphy_priv(wiphy));
+	return __ieee80211_suspend(wiphy_priv(wiphy), wowlan);
 }
 
 static int ieee80211_resume(struct wiphy *wiphy)
--- a/net/mac80211/ieee80211_i.h	2011-05-04 15:22:39.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-05-04 15:24:19.000000000 +0200
@@ -764,6 +764,9 @@ struct ieee80211_local {
 	/* device is started */
 	bool started;
 
+	/* wowlan is enabled -- don't reconfig on resume */
+	bool wowlan;
+
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	/* count for keys needing tailroom space allocation */
@@ -1249,7 +1252,8 @@ int ieee80211_reconfig(struct ieee80211_
 void ieee80211_stop_device(struct ieee80211_local *local);
 
 #ifdef CONFIG_PM
-int __ieee80211_suspend(struct ieee80211_hw *hw);
+int __ieee80211_suspend(struct ieee80211_hw *hw,
+			struct cfg80211_wowlan *wowlan);
 
 static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 {
@@ -1262,7 +1266,8 @@ static inline int __ieee80211_resume(str
 	return ieee80211_reconfig(hw_to_local(hw));
 }
 #else
-static inline int __ieee80211_suspend(struct ieee80211_hw *hw)
+static inline int __ieee80211_suspend(struct ieee80211_hw *hw,
+				      struct cfg80211_wowlan *wowlan)
 {
 	return 0;
 }
--- a/net/mac80211/pm.c	2011-05-04 15:22:39.000000000 +0200
+++ b/net/mac80211/pm.c	2011-05-04 15:24:19.000000000 +0200
@@ -6,7 +6,7 @@
 #include "driver-ops.h"
 #include "led.h"
 
-int __ieee80211_suspend(struct ieee80211_hw *hw)
+int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -47,6 +47,16 @@ int __ieee80211_suspend(struct ieee80211
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 	del_timer_sync(&local->dynamic_ps_timer);
 
+	local->wowlan = wowlan && local->open_count;
+	if (local->wowlan) {
+		int err = drv_suspend(local, wowlan);
+		if (err) {
+			local->quiescing = false;
+			return err;
+		}
+		goto suspend;
+	}
+
 	/* disable keys */
 	list_for_each_entry(sdata, &local->interfaces, list)
 		ieee80211_disable_keys(sdata);
@@ -104,6 +114,7 @@ int __ieee80211_suspend(struct ieee80211
 	if (local->open_count)
 		ieee80211_stop_device(local);
 
+ suspend:
 	local->suspended = true;
 	/* need suspended to be visible before quiescing is false */
 	barrier();
--- a/net/mac80211/debugfs.c	2011-05-04 15:22:39.000000000 +0200
+++ b/net/mac80211/debugfs.c	2011-05-04 15:24:19.000000000 +0200
@@ -135,7 +135,7 @@ static ssize_t reset_write(struct file *
 	struct ieee80211_local *local = file->private_data;
 
 	rtnl_lock();
-	__ieee80211_suspend(&local->hw);
+	__ieee80211_suspend(&local->hw, NULL);
 	__ieee80211_resume(&local->hw);
 	rtnl_unlock();
 
--- a/net/mac80211/main.c	2011-05-04 15:22:38.000000000 +0200
+++ b/net/mac80211/main.c	2011-05-04 15:24:19.000000000 +0200
@@ -697,6 +697,10 @@ int ieee80211_register_hw(struct ieee802
 		WLAN_CIPHER_SUITE_AES_CMAC
 	};
 
+	if ((hw->wiphy->wowlan.flags || hw->wiphy->wowlan.n_patterns) &&
+	    (!local->ops->suspend || !local->ops->resume))
+		return -EINVAL;
+
 	if (hw->max_report_rates == 0)
 		hw->max_report_rates = hw->max_rates;
 
--- a/net/mac80211/util.c	2011-05-04 15:22:39.000000000 +0200
+++ b/net/mac80211/util.c	2011-05-04 15:24:19.000000000 +0200
@@ -1125,9 +1125,27 @@ int ieee80211_reconfig(struct ieee80211_
 	struct sta_info *sta;
 	int res;
 
+#ifdef CONFIG_PM
 	if (local->suspended)
 		local->resuming = true;
 
+	if (local->wowlan) {
+		local->wowlan = false;
+		res = drv_resume(local);
+		if (res < 0) {
+			local->resuming = false;
+			return res;
+		}
+		if (res == 0)
+			goto wake_up;
+		WARN_ON(res > 1);
+		/*
+		 * res is 1, which means the driver requested
+		 * to go through a regular reset on wakeup.
+		 */
+	}
+#endif
+
 	/* restart hardware */
 	if (local->open_count) {
 		/*
@@ -1258,6 +1276,7 @@ int ieee80211_reconfig(struct ieee80211_
 		if (ieee80211_sdata_running(sdata))
 			ieee80211_enable_keys(sdata);
 
+ wake_up:
 	ieee80211_wake_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
--- a/net/mac80211/driver-ops.h	2011-05-04 15:22:39.000000000 +0200
+++ b/net/mac80211/driver-ops.h	2011-05-04 15:24:19.000000000 +0200
@@ -41,6 +41,33 @@ static inline void drv_stop(struct ieee8
 	local->started = false;
 }
 
+#ifdef CONFIG_PM
+static inline int drv_suspend(struct ieee80211_local *local,
+			      struct cfg80211_wowlan *wowlan)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_suspend(local);
+	ret = local->ops->suspend(&local->hw, wowlan);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
+static inline int drv_resume(struct ieee80211_local *local)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_resume(local);
+	ret = local->ops->resume(&local->hw);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+#endif
+
 static inline int drv_add_interface(struct ieee80211_local *local,
 				    struct ieee80211_vif *vif)
 {
--- a/net/mac80211/driver-trace.h	2011-05-04 15:22:39.000000000 +0200
+++ b/net/mac80211/driver-trace.h	2011-05-04 15:24:19.000000000 +0200
@@ -108,6 +108,16 @@ DEFINE_EVENT(local_only_evt, drv_start,
 	TP_ARGS(local)
 );
 
+DEFINE_EVENT(local_only_evt, drv_suspend,
+	TP_PROTO(struct ieee80211_local *local),
+	TP_ARGS(local)
+);
+
+DEFINE_EVENT(local_only_evt, drv_resume,
+	TP_PROTO(struct ieee80211_local *local),
+	TP_ARGS(local)
+);
+
 DEFINE_EVENT(local_only_evt, drv_stop,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)



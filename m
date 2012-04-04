Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab2DDNF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 09:05:28 -0400
Message-ID: <1333544725.18879.4.camel@jlt3.sipsolutions.net> (sfid-20120404_150531_755016_453F96CC)
Subject: [PATCH v2] cfg80211/mac80211: enable proper
 device_set_wakeup_enable handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 04 Apr 2012 15:05:25 +0200
In-Reply-To: <1333539887.18879.1.camel@jlt3.sipsolutions.net> (sfid-20120404_134457_804584_ABF48281)
References: <1333539887.18879.1.camel@jlt3.sipsolutions.net>
	 (sfid-20120404_134457_804584_ABF48281)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In WoWLAN, we only get the triggers when we actually get
to suspend. As a consequence, drivers currently don't
know that the device should enable wakeup. However, the
device_set_wakeup_enable() API is intended to be called
when the wakeup is enabled, not later when needed.

Add a new set_wakeup() call to cfg80211 and mac80211 to
allow drivers to properly call device_set_wakeup_enable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: disable wakeup on unregister, thanks Eliad

 include/net/cfg80211.h      |    4 ++++
 include/net/mac80211.h      |    1 +
 net/mac80211/cfg.c          |   10 ++++++++++
 net/mac80211/driver-ops.h   |   13 +++++++++++++
 net/mac80211/driver-trace.h |   14 ++++++++++++++
 net/wireless/core.c         |    5 ++++-
 net/wireless/nl80211.c      |    4 ++++
 7 files changed, 50 insertions(+), 1 deletion(-)

--- a/include/net/cfg80211.h	2012-04-04 09:17:42.000000000 +0200
+++ b/include/net/cfg80211.h	2012-04-04 13:33:18.000000000 +0200
@@ -1335,6 +1335,9 @@ struct cfg80211_gtk_rekey_data {
  *	be %NULL or contain the enabled Wake-on-Wireless triggers that are
  *	configured for the device.
  * @resume: wiphy device needs to be resumed
+ * @set_wakeup: Called when WoWLAN is enabled/disabled, use this callback
+ *	to call device_set_wakeup_enable() to enable/disable wakeup from
+ *	the device.
  *
  * @add_virtual_intf: create a new virtual interface with the given name,
  *	must set the struct wireless_dev's iftype. Beware: You must create
@@ -1506,6 +1509,7 @@ struct cfg80211_gtk_rekey_data {
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
 	int	(*resume)(struct wiphy *wiphy);
+	void	(*set_wakeup)(struct wiphy *wiphy, bool enabled);
 
 	struct net_device * (*add_virtual_intf)(struct wiphy *wiphy,
 						char *name,
--- a/net/wireless/nl80211.c	2012-04-04 09:17:42.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-04-04 13:33:13.000000000 +0200
@@ -6003,6 +6003,7 @@ static int nl80211_set_wowlan(struct sk_
 	struct cfg80211_wowlan new_triggers = {};
 	struct wiphy_wowlan_support *wowlan = &rdev->wiphy.wowlan;
 	int err, i;
+	bool prev_enabled = rdev->wowlan;
 
 	if (!rdev->wiphy.wowlan.flags && !rdev->wiphy.wowlan.n_patterns)
 		return -EOPNOTSUPP;
@@ -6135,6 +6136,9 @@ static int nl80211_set_wowlan(struct sk_
 		rdev->wowlan = NULL;
 	}
 
+	if (rdev->ops->set_wakeup && prev_enabled != !!rdev->wowlan)
+		rdev->ops->set_wakeup(&rdev->wiphy, rdev->wowlan);
+
 	return 0;
  error:
 	for (i = 0; i < new_triggers.n_patterns; i++)
--- a/include/net/mac80211.h	2012-04-04 09:17:44.000000000 +0200
+++ b/include/net/mac80211.h	2012-04-04 13:34:03.000000000 +0200
@@ -2231,6 +2231,7 @@ struct ieee80211_ops {
 #ifdef CONFIG_PM
 	int (*suspend)(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan);
 	int (*resume)(struct ieee80211_hw *hw);
+	void (*set_wakeup)(struct ieee80211_hw *hw, bool enabled);
 #endif
 	int (*add_interface)(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
--- a/net/mac80211/cfg.c	2012-04-04 09:17:44.000000000 +0200
+++ b/net/mac80211/cfg.c	2012-04-04 13:36:37.000000000 +0200
@@ -2687,6 +2687,13 @@ ieee80211_wiphy_get_channel(struct wiphy
 	return local->oper_channel;
 }
 
+#ifdef CONFIG_PM
+static void ieee80211_set_wakeup(struct wiphy *wiphy, bool enabled)
+{
+	drv_set_wakeup(wiphy_priv(wiphy), enabled);
+}
+#endif
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -2755,4 +2762,7 @@ struct cfg80211_ops mac80211_config_ops
 	.probe_client = ieee80211_probe_client,
 	.get_channel = ieee80211_wiphy_get_channel,
 	.set_noack_map = ieee80211_set_noack_map,
+#ifdef CONFIG_PM
+	.set_wakeup = ieee80211_set_wakeup,
+#endif
 };
--- a/net/mac80211/driver-ops.h	2012-04-04 09:17:44.000000000 +0200
+++ b/net/mac80211/driver-ops.h	2012-04-04 13:39:16.000000000 +0200
@@ -89,6 +89,19 @@ static inline int drv_resume(struct ieee
 	trace_drv_return_int(local, ret);
 	return ret;
 }
+
+static inline void drv_set_wakeup(struct ieee80211_local *local,
+				  bool enabled)
+{
+	might_sleep();
+
+	if (!local->ops->set_wakeup)
+		return;
+
+	trace_drv_set_wakeup(local, enabled);
+	local->ops->set_wakeup(&local->hw, enabled);
+	trace_drv_return_void(local);
+}
 #endif
 
 static inline int drv_add_interface(struct ieee80211_local *local,
--- a/net/mac80211/driver-trace.h	2012-04-04 09:17:42.000000000 +0200
+++ b/net/mac80211/driver-trace.h	2012-04-04 13:39:04.000000000 +0200
@@ -171,6 +171,20 @@ DEFINE_EVENT(local_only_evt, drv_resume,
 	TP_ARGS(local)
 );
 
+TRACE_EVENT(drv_set_wakeup,
+	TP_PROTO(struct ieee80211_local *local, bool enabled),
+	TP_ARGS(local, enabled),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(bool, enabled)
+	),
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->enabled = enabled;
+	),
+	TP_printk(LOCAL_PR_FMT " enabled:%d", LOCAL_PR_ARG, __entry->enabled)
+);
+
 DEFINE_EVENT(local_only_evt, drv_stop,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
--- a/net/wireless/core.c	2012-04-04 09:17:38.000000000 +0200
+++ b/net/wireless/core.c	2012-04-04 15:03:31.000000000 +0200
@@ -704,6 +704,10 @@ void wiphy_unregister(struct wiphy *wiph
 	flush_work(&rdev->scan_done_wk);
 	cancel_work_sync(&rdev->conn_work);
 	flush_work(&rdev->event_work);
+
+	if (rdev->wowlan && rdev->ops->set_wakeup)
+		rdev->ops->set_wakeup(&rdev->wiphy, false);
+	cfg80211_rdev_free_wowlan(rdev);
 }
 EXPORT_SYMBOL(wiphy_unregister);
 
@@ -716,7 +720,6 @@ void cfg80211_dev_free(struct cfg80211_r
 	mutex_destroy(&rdev->sched_scan_mtx);
 	list_for_each_entry_safe(scan, tmp, &rdev->bss_list, list)
 		cfg80211_put_bss(&scan->pub);
-	cfg80211_rdev_free_wowlan(rdev);
 	kfree(rdev);
 }
 



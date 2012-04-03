Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2DCMf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 08:35:59 -0400
Message-ID: <1333456557.3574.17.camel@jlt3.sipsolutions.net> (sfid-20120403_143604_829218_F95FFBA7)
Subject: [PATCH v2 1/2] mac80211: add explicit monitor interface if needed
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Apr 2012 14:35:57 +0200
In-Reply-To: <1333441758.3574.3.camel@jlt3.sipsolutions.net> (sfid-20120403_102925_920192_9CF5496E)
References: <20120403082416.559209159@sipsolutions.net>
	 (sfid-20120403_102724_757636_B390B8A7) <1333441758.3574.3.camel@jlt3.sipsolutions.net>
	 (sfid-20120403_102925_920192_9CF5496E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The queue mapping redesign that I'm planning to do
will break pure injection unless we handle monitor
interfaces explicitly. One possible option would
be to have the driver tell mac80211 about monitor
mode queues etc., but that would duplicate the API
since we already need to have queue assignments
handled per virtual interface.

So in order to solve this, have a virtual monitor
interface that is added whenever all active vifs
are monitors. We could also use the state of one
of the monitor interfaces, but managing that would
be complicated, so allocate separate state.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: fix error path (thanks Eliad)

 drivers/net/wireless/mac80211_hwsim.c |    3 +
 include/net/mac80211.h                |    6 ++-
 net/mac80211/driver-ops.h             |    3 +
 net/mac80211/ieee80211_i.h            |    3 +
 net/mac80211/iface.c                  |   65 ++++++++++++++++++++++++++++++++++
 net/mac80211/pm.c                     |    4 ++
 net/mac80211/tx.c                     |    7 ++-
 net/mac80211/util.c                   |   10 +++++
 8 files changed, 96 insertions(+), 5 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2012-04-02 11:16:23.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2012-04-03 10:21:49.000000000 +0200
@@ -1077,6 +1077,9 @@ struct ieee80211_local {
 	struct net_device napi_dev;
 
 	struct napi_struct napi;
+
+	/* virtual monitor interface */
+	struct ieee80211_sub_if_data __rcu *monitor_sdata;
 };
 
 static inline struct ieee80211_sub_if_data *
--- a/net/mac80211/pm.c	2012-04-02 10:39:34.000000000 +0200
+++ b/net/mac80211/pm.c	2012-04-02 11:16:23.000000000 +0200
@@ -127,6 +127,10 @@ int __ieee80211_suspend(struct ieee80211
 		drv_remove_interface(local, sdata);
 	}
 
+	sdata = rtnl_dereference(local->monitor_sdata);
+	if (sdata)
+		drv_remove_interface(local, sdata);
+
 	/* stop hardware - this must stop RX */
 	if (local->open_count)
 		ieee80211_stop_device(local);
--- a/include/net/mac80211.h	2012-04-02 11:16:23.000000000 +0200
+++ b/include/net/mac80211.h	2012-04-03 10:21:49.000000000 +0200
@@ -1173,6 +1173,10 @@ enum sta_notify_cmd {
  * @IEEE80211_HW_SCAN_WHILE_IDLE: The device can do hw scan while
  *	being idle (i.e. mac80211 doesn't have to go idle-off during the
  *	the scan).
+ *
+ * @IEEE80211_HW_WANT_MONITOR_VIF: The driver would like to be informed of
+ *	a virtual monitor interface when monitor interfaces are the only
+ *	active interfaces.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1189,7 +1193,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_PS_NULLFUNC_STACK			= 1<<11,
 	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
-	/* reuse bit 14 */
+	IEEE80211_HW_WANT_MONITOR_VIF			= 1<<14,
 	IEEE80211_HW_SUPPORTS_STATIC_SMPS		= 1<<15,
 	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
--- a/net/mac80211/iface.c	2012-04-02 11:16:23.000000000 +0200
+++ b/net/mac80211/iface.c	2012-04-03 14:34:55.000000000 +0200
@@ -169,6 +169,59 @@ void ieee80211_adjust_monitor_flags(stru
 #undef ADJUST
 }
 
+static int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+	int ret;
+
+	if (!(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF))
+		return 0;
+
+	if (local->monitor_sdata)
+		return 0;
+
+	sdata = kzalloc(sizeof(*sdata) + local->hw.vif_data_size, GFP_KERNEL);
+	if (!sdata)
+		return -ENOMEM;
+
+	/* set up data */
+	sdata->local = local;
+	sdata->vif.type = NL80211_IFTYPE_MONITOR;
+	snprintf(sdata->name, IFNAMSIZ, "%s-monitor",
+		 wiphy_name(local->hw.wiphy));
+
+	ret = drv_add_interface(local, sdata);
+	if (WARN_ON(ret)) {
+		/* ok .. stupid driver, it asked for this! */
+		kfree(sdata);
+		return ret;
+	}
+
+	rcu_assign_pointer(local->monitor_sdata, sdata);
+
+	return 0;
+}
+
+static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	if (!(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF))
+		return;
+
+	sdata = rtnl_dereference(local->monitor_sdata);
+
+	if (!sdata)
+		return;
+
+	rcu_assign_pointer(local->monitor_sdata, NULL);
+	synchronize_net();
+
+	drv_remove_interface(local, sdata);
+
+	kfree(sdata);
+}
+
 /*
  * NOTE: Be very careful when changing this function, it must NOT return
  * an error on interface type changes that have been pre-checked, so most
@@ -266,6 +319,12 @@ static int ieee80211_do_open(struct net_
 			break;
 		}
 
+		if (local->monitors == 0 && local->open_count == 0) {
+			res = ieee80211_add_virtual_monitor(local);
+			if (res)
+				goto err_stop;
+		}
+
 		/* must be before the call to ieee80211_configure_filter */
 		local->monitors++;
 		if (local->monitors == 1) {
@@ -280,6 +339,8 @@ static int ieee80211_do_open(struct net_
 		break;
 	default:
 		if (coming_up) {
+			ieee80211_del_virtual_monitor(local);
+
 			res = drv_add_interface(local, sdata);
 			if (res)
 				goto err_stop;
@@ -511,6 +572,7 @@ static void ieee80211_do_stop(struct iee
 		if (local->monitors == 0) {
 			local->hw.conf.flags &= ~IEEE80211_CONF_MONITOR;
 			hw_reconf_flags |= IEEE80211_CONF_CHANGE_MONITOR;
+			ieee80211_del_virtual_monitor(local);
 		}
 
 		ieee80211_adjust_monitor_flags(sdata, -1);
@@ -584,6 +646,9 @@ static void ieee80211_do_stop(struct iee
 		}
 	}
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+
+	if (local->monitors == local->open_count && local->monitors > 0)
+		ieee80211_add_virtual_monitor(local);
 }
 
 static int ieee80211_stop(struct net_device *dev)
--- a/net/mac80211/util.c	2012-04-02 11:16:23.000000000 +0200
+++ b/net/mac80211/util.c	2012-04-03 10:21:49.000000000 +0200
@@ -1213,6 +1213,16 @@ int ieee80211_reconfig(struct ieee80211_
 				   IEEE80211_TPT_LEDTRIG_FL_RADIO, 0);
 
 	/* add interfaces */
+	sdata = rtnl_dereference(local->monitor_sdata);
+	if (sdata) {
+		res = drv_add_interface(local, sdata);
+		if (WARN_ON(res)) {
+			rcu_assign_pointer(local->monitor_sdata, NULL);
+			synchronize_net();
+			kfree(sdata);
+		}
+	}
+
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
 		    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
--- a/net/mac80211/tx.c	2012-04-02 11:16:23.000000000 +0200
+++ b/net/mac80211/tx.c	2012-04-03 10:21:49.000000000 +0200
@@ -1284,8 +1284,11 @@ static bool __ieee80211_tx(struct ieee80
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_MONITOR:
-		sdata = NULL;
-		vif = NULL;
+		sdata = rcu_dereference(local->monitor_sdata);
+		if (sdata)
+			vif = &sdata->vif;
+		else
+			vif = NULL;
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
 		sdata = container_of(sdata->bss,
--- a/drivers/net/wireless/mac80211_hwsim.c	2012-04-02 10:39:34.000000000 +0200
+++ b/drivers/net/wireless/mac80211_hwsim.c	2012-04-02 11:16:23.000000000 +0200
@@ -1789,7 +1789,8 @@ static int __init init_mac80211_hwsim(vo
 			    IEEE80211_HW_SIGNAL_DBM |
 			    IEEE80211_HW_SUPPORTS_STATIC_SMPS |
 			    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
-			    IEEE80211_HW_AMPDU_AGGREGATION;
+			    IEEE80211_HW_AMPDU_AGGREGATION |
+			    IEEE80211_HW_WANT_MONITOR_VIF;
 
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
 				    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
--- a/net/mac80211/driver-ops.h	2012-04-02 11:16:23.000000000 +0200
+++ b/net/mac80211/driver-ops.h	2012-04-02 11:16:23.000000000 +0200
@@ -99,7 +99,8 @@ static inline int drv_add_interface(stru
 	might_sleep();
 
 	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
-		    sdata->vif.type == NL80211_IFTYPE_MONITOR))
+		    (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
+		     !(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF))))
 		return -EINVAL;
 
 	trace_drv_add_interface(local, sdata);



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab2GLIQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 04:16:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: iterate the virtual monitor interface
Date: Thu, 12 Jul 2012 10:16:46 +0200
Message-Id: <1342081006-6289-1-git-send-email-johannes@sipsolutions.net> (sfid-20120712_101659_336557_059CB35A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the virtual monitor interface is requested
by the driver, it should also be iterated over
when the driver wants to iterate all active
interfaces.

To allow that protect it with the iflist_mtx.

Change-Id: I58ac5de2f4ce93d12c5a98ecd2859f60158d5d69
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |   29 +++++++++++++++++++----------
 net/mac80211/util.c  |    9 +++++++++
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index e3c4974..334ee0f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -334,17 +334,21 @@ static void ieee80211_set_default_queues(struct ieee80211_sub_if_data *sdata)
 int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
-	int ret;
+	int ret = 0;
 
 	if (!(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF))
 		return 0;
 
+	mutex_lock(&local->iflist_mtx);
+
 	if (local->monitor_sdata)
-		return 0;
+		goto out_unlock;
 
 	sdata = kzalloc(sizeof(*sdata) + local->hw.vif_data_size, GFP_KERNEL);
-	if (!sdata)
-		return -ENOMEM;
+	if (!sdata) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
 
 	/* set up data */
 	sdata->local = local;
@@ -358,18 +362,19 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 	if (WARN_ON(ret)) {
 		/* ok .. stupid driver, it asked for this! */
 		kfree(sdata);
-		return ret;
+		goto out_unlock;
 	}
 
 	ret = ieee80211_check_queues(sdata);
 	if (ret) {
 		kfree(sdata);
-		return ret;
+		goto out_unlock;
 	}
 
 	rcu_assign_pointer(local->monitor_sdata, sdata);
-
-	return 0;
+ out_unlock:
+	mutex_unlock(&local->iflist_mtx);
+	return ret;
 }
 
 void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
@@ -379,10 +384,12 @@ void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 	if (!(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF))
 		return;
 
-	sdata = rtnl_dereference(local->monitor_sdata);
+	mutex_lock(&local->iflist_mtx);
 
+	sdata = rcu_dereference_protected(local->monitor_sdata,
+					  lockdep_is_held(&local->iflist_mtx));
 	if (!sdata)
-		return;
+		goto out_unlock;
 
 	rcu_assign_pointer(local->monitor_sdata, NULL);
 	synchronize_net();
@@ -390,6 +397,8 @@ void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 	drv_remove_interface(local, sdata);
 
 	kfree(sdata);
+ out_unlock:
+	mutex_unlock(&local->iflist_mtx);
 }
 
 /*
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 596db0c..39b82fe 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -529,6 +529,11 @@ void ieee80211_iterate_active_interfaces(
 				 &sdata->vif);
 	}
 
+	sdata = rcu_dereference_protected(local->monitor_sdata,
+					  lockdep_is_held(&local->iflist_mtx));
+	if (sdata)
+		iterator(data, sdata->vif.addr, &sdata->vif);
+
 	mutex_unlock(&local->iflist_mtx);
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
@@ -557,6 +562,10 @@ void ieee80211_iterate_active_interfaces_atomic(
 				 &sdata->vif);
 	}
 
+	sdata = rcu_dereference(local->monitor_sdata);
+	if (sdata)
+		iterator(data, sdata->vif.addr, &sdata->vif);
+
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
-- 
1.7.10.4


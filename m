Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54272 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933912AbXCVKFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2007 06:05:25 -0400
Subject: [RFC] mac80211: kill rtnl usage
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jiri Benc <jbenc@suse.cz>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 09:26:53 +0100
Message-Id: <1174552014.3944.72.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces a new mutex to lock the ieee80211_local struct and
kills off all usage of the RTNL.

When you apply it you may occasionally find a big WARN_ON in your kernel
log, that's intended and probably needs to be fixed.

The simplification of ieee80211_if_add comes with a slight userspace API
change, userspace can no longer specify an empty name to get a default.
Which is IMNSHO a good thing.

---
 net/mac80211/debugfs.c         |   21 +++----------
 net/mac80211/ieee80211.c       |   43 ++++++++++++---------------
 net/mac80211/ieee80211_cfg.c   |   46 +++++++++++------------------
 net/mac80211/ieee80211_i.h     |   11 +++++-
 net/mac80211/ieee80211_iface.c |   65 +++++++++++++----------------------------
 net/mac80211/ieee80211_ioctl.c |    8 ++---
 net/mac80211/ieee80211_sta.c   |    8 +++++
 7 files changed, 86 insertions(+), 116 deletions(-)

--- wireless-dev.orig/net/mac80211/debugfs.c	2007-03-21 20:43:28.263977547 +0100
+++ wireless-dev/net/mac80211/debugfs.c	2007-03-22 08:40:49.073480683 +0100
@@ -118,16 +118,6 @@ DEBUGFS_READONLY_FILE(rate_ctrl_alg, 100
 
 /* statistics stuff */
 
-static inline int rtnl_lock_local(struct ieee80211_local *local)
-{
-	rtnl_lock();
-	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED)) {
-		rtnl_unlock();
-		return -ENODEV;
-	}
-	return 0;
-}
-
 #define DEBUGFS_STATS_FILE(name, buflen, fmt, value...)			\
 	DEBUGFS_READONLY_FILE(stats_ ##name, buflen, fmt, ##value)
 
@@ -144,12 +134,13 @@ static ssize_t format_devstat_counter(st
 	if (!local->ops->get_stats)
 		return -EOPNOTSUPP;
 
-	res = rtnl_lock_local(local);
-	if (res)
-		return res;
+	mutex_lock(&local->mtx);
+	if (likely(local->reg_state == IEEE80211_DEV_REGISTERED)) {
+		res = local->ops->get_stats(local_to_hw(local), &stats);
+	} else
+		res = -ENODEV;
+	mutex_unlock(&local->mtx);
 
-	res = local->ops->get_stats(local_to_hw(local), &stats);
-	rtnl_unlock();
 	if (!res)
 		res = printvalue(&stats, buf, sizeof(buf));
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-21 20:43:28.373977547 +0100
+++ wireless-dev/net/mac80211/ieee80211.c	2007-03-22 09:10:53.053480683 +0100
@@ -2166,12 +2166,13 @@ static struct net_device_stats *ieee8021
 	return &(sdata->stats);
 }
 
-void ieee80211_if_shutdown(struct net_device *dev)
+static void ieee80211_if_shutdown(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	ASSERT_RTNL();
+	ASSERT_LOCAL_MTX(local);
+
 	switch (sdata->type) {
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
@@ -4441,7 +4442,8 @@ int ieee80211_init_rate_ctrl_alg(struct 
 {
 	struct rate_control_ref *ref, *old;
 
-	ASSERT_RTNL();
+	ASSERT_LOCAL_MTX(local);
+
 	if (local->open_count || netif_running(local->mdev) ||
 	    (local->apdev && netif_running(local->apdev)))
 		return -EBUSY;
@@ -4521,6 +4523,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	local->ops = ops;
 
+	mutex_init(&local->mtx);
+
 	/* for now, mdev needs sub_if_data :/ */
 	mdev = alloc_netdev(sizeof(struct ieee80211_sub_if_data),
 			    "wmaster%d", ether_setup);
@@ -4606,6 +4610,8 @@ int ieee80211_register_hw(struct ieee802
 	struct net_device *sta_dev;
 	int result;
 
+	mutex_lock(&local->mtx);
+
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		return result;
@@ -4627,26 +4633,16 @@ int ieee80211_register_hw(struct ieee802
 	if (result < 0)
 		goto fail_sta_info;
 
-	rtnl_lock();
-	result = dev_alloc_name(local->mdev, local->mdev->name);
-	if (result < 0) {
-		rtnl_unlock();
-		goto fail_dev;
-	}
-
 	memcpy(local->mdev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(local->mdev, wiphy_dev(local->hw.wiphy));
 
-	result = register_netdevice(local->mdev);
-	if (result < 0) {
-		rtnl_unlock();
+	result = register_netdev(local->mdev);
+	if (result < 0)
 		goto fail_dev;
-	}
 
 	ieee80211_debugfs_add_netdev(IEEE80211_DEV_TO_SUB_IF(local->mdev));
 
 	result = ieee80211_init_rate_ctrl_alg(local, NULL);
-	rtnl_unlock();
 	if (result < 0) {
 		printk(KERN_DEBUG "%s: Failed to initialize rate control "
 		       "algorithm\n", local->mdev->name);
@@ -4661,20 +4657,19 @@ int ieee80211_register_hw(struct ieee802
 		goto fail_wep;
 	}
 
-	/* TODO: add rtnl locking around device creation and qdisc install */
 	ieee80211_install_qdisc(local->mdev);
 
 	/* add one default STA interface */
-	rtnl_lock();
-	result = ieee80211_if_add(local->mdev, "wlan%d", 1, &sta_dev);
+	result = ieee80211_if_add(local->mdev, "wlan%d", &sta_dev);
 	if (result == 0)
 		ieee80211_if_set_type(sta_dev, IEEE80211_IF_TYPE_STA);
 
 	local->reg_state = IEEE80211_DEV_REGISTERED;
-	rtnl_unlock();
 
 	ieee80211_led_init(local);
 
+	mutex_unlock(&local->mtx);
+
 	return 0;
 
 fail_wep:
@@ -4687,6 +4682,7 @@ fail_dev:
 fail_sta_info:
 	debugfs_hw_del(local);
 	wiphy_unregister(local->hw.wiphy);
+	mutex_unlock(&local->mtx);
 	return result;
 }
 EXPORT_SYMBOL(ieee80211_register_hw);
@@ -4732,7 +4728,7 @@ void ieee80211_unregister_hw(struct ieee
 	tasklet_disable(&local->tasklet);
 	/* TODO: skb_queue should be empty here, no need to do anything? */
 
-	rtnl_lock();
+	mutex_lock(&local->mtx);
 	local->reg_state = IEEE80211_DEV_UNREGISTERED;
 	if (local->apdev)
 		ieee80211_if_del_mgmt(local);
@@ -4740,7 +4736,7 @@ void ieee80211_unregister_hw(struct ieee
 	list_for_each_entry_safe(sdata, tmp, &local->sub_if_list, list)
 		__ieee80211_if_del(local, sdata);
 
-	rtnl_unlock();
+	mutex_unlock(&local->mtx);
 
 	if (local->stat_time)
 		del_timer_sync(&local->stat_timer);
@@ -4750,8 +4746,8 @@ void ieee80211_unregister_hw(struct ieee
 		flush_scheduled_work();
 		/* The scan_work is guaranteed not to be called at this
 		 * point. It is not scheduled and not running now. It can be
-		 * scheduled again only by sta_work (stopped by now) or under
-		 * rtnl lock. */
+		 * scheduled again only by sta_work (stopped by now) or after
+		 * checking reg_state. */
 	}
 
 	ieee80211_rx_bss_list_deinit(local->mdev);
@@ -4783,6 +4779,7 @@ void ieee80211_free_hw(struct ieee80211_
 	struct ieee80211_local *local = hw_to_local(hw);
 
 	ieee80211_if_free(local->mdev);
+	mutex_destroy(&local->mtx);
 	wiphy_free(local->hw.wiphy);
 }
 EXPORT_SYMBOL(ieee80211_free_hw);
--- wireless-dev.orig/net/mac80211/ieee80211_cfg.c	2007-03-21 20:43:28.483977547 +0100
+++ wireless-dev/net/mac80211/ieee80211_cfg.c	2007-03-22 09:12:04.393480683 +0100
@@ -12,17 +12,6 @@
 #include "ieee80211_i.h"
 #include "ieee80211_cfg.h"
 
-/* copied from ieee80211_sysfs.c for now ... */
-static inline int rtnl_lock_local(struct ieee80211_local *local)
-{
-	rtnl_lock();
-	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED)) {
-		rtnl_unlock();
-		return -ENODEV;
-	}
-	return 0;
-}
-
 
 static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
 			       unsigned int type)
@@ -54,14 +43,14 @@ static int ieee80211_add_iface(struct wi
 		return -EINVAL;
 	}
 
-	res = rtnl_lock_local(local);
-	if (res)
-		return res;
-
-	res = ieee80211_if_add(local->mdev, name, 0, &new_dev);
-	if (res == 0)
-		ieee80211_if_set_type(new_dev, itype);
-	rtnl_unlock();
+	mutex_lock(&local->mtx);
+	if (likely(local->reg_state == IEEE80211_DEV_REGISTERED)) {
+		res = ieee80211_if_add(local->mdev, name, &new_dev);
+		if (res == 0)
+			ieee80211_if_set_type(new_dev, itype);
+	} else
+		res = -ENODEV;
+	mutex_unlock(&local->mtx);
 	return res;
 }
 
@@ -72,15 +61,16 @@ static int ieee80211_del_iface(struct wi
 	struct net_device *dev;
 	char *name;
 
-	res = rtnl_lock_local(local);
-	if (res)
-		return res;
-	dev = dev_get_by_index(ifindex);
-	name = dev->name;
-	dev_put(dev);
-
-	res = ieee80211_if_remove(local->mdev, name, -1);
-	rtnl_unlock();
+	mutex_lock(&local->mtx);
+	if (likely(local->reg_state == IEEE80211_DEV_REGISTERED)) {
+		dev = dev_get_by_index(ifindex);
+		name = dev->name;
+		dev_put(dev);
+
+		res = ieee80211_if_remove(local->mdev, name, -1);
+	} else
+		res = -ENODEV;
+	mutex_unlock(&local->mtx);
 	return res;
 }
 
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-03-22 08:37:54.593480683 +0100
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-03-22 09:15:41.953480683 +0100
@@ -20,6 +20,7 @@
 #include <linux/workqueue.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <net/wireless.h>
 #include "ieee80211_key.h"
 #include "sta_info.h"
@@ -407,6 +408,9 @@ struct ieee80211_local {
 
 	const struct ieee80211_ops *ops;
 
+	/* protects this structure */
+	struct mutex mtx;
+
 	/* List of registered struct ieee80211_hw_mode */
 	struct list_head modes_list;
 
@@ -660,6 +664,10 @@ struct ieee80211_local {
 #endif
 };
 
+#define ASSERT_LOCAL_MTX(local)	do {			\
+		WARN_ON(!mutex_is_locked(&local->mtx));	\
+	} while (0)
+
 static inline struct ieee80211_local *hw_to_local(
 	struct ieee80211_hw *hw)
 {
@@ -734,7 +742,6 @@ void ieee80211_tx_set_iswep(struct ieee8
 int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr);
 void ieee80211_if_setup(struct net_device *dev);
 void ieee80211_if_mgmt_setup(struct net_device *dev);
-void ieee80211_if_shutdown(struct net_device *dev);
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 				 const char *name);
 struct net_device_stats *ieee80211_dev_stats(struct net_device *dev);
@@ -806,7 +813,7 @@ int ieee80211_sta_disassociate(struct ne
 
 /* ieee80211_iface.c */
 int ieee80211_if_add(struct net_device *dev, const char *name,
-		     int format, struct net_device **new_dev);
+		     struct net_device **new_dev);
 void ieee80211_if_set_type(struct net_device *dev, int type);
 void ieee80211_if_reinit(struct net_device *dev);
 void __ieee80211_if_del(struct ieee80211_local *local,
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-03-21 20:43:28.583977547 +0100
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-03-22 09:24:41.443480683 +0100
@@ -36,33 +36,22 @@ static void ieee80211_if_sdata_deinit(st
 	}
 }
 
-/* Must be called with rtnl lock held. */
+/* Must be called with local mutex held. */
 int ieee80211_if_add(struct net_device *dev, const char *name,
-		     int format, struct net_device **new_dev)
+		     struct net_device **new_dev)
 {
 	struct net_device *ndev;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = NULL;
 	int ret;
 
-	ASSERT_RTNL();
+	ASSERT_LOCAL_MTX(local);
+
 	ndev = *new_dev = alloc_netdev(sizeof(struct ieee80211_sub_if_data),
-				       "", ieee80211_if_setup);
+				       name, ieee80211_if_setup);
 	if (!ndev)
 		return -ENOMEM;
 
-	if (*name == '\0') {
-		snprintf(ndev->name, IFNAMSIZ, "%s.%%d", dev->name);
-		format = 1;
-	}
-
-	if (format) {
-		ret = dev_alloc_name(ndev, name);
-		if (ret < 0)
-			goto fail;
-	} else
-		snprintf(ndev->name, IFNAMSIZ, "%s", name);
-
 	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	ndev->base_addr = dev->base_addr;
 	ndev->irq = dev->irq;
@@ -78,7 +67,7 @@ int ieee80211_if_add(struct net_device *
 	sdata->local = local;
 	ieee80211_if_sdata_init(sdata);
 
-	ret = register_netdevice(ndev);
+	ret = register_netdev(ndev);
 	if (ret)
 		goto fail;
 
@@ -100,15 +89,12 @@ int ieee80211_if_add_mgmt(struct ieee802
 	struct ieee80211_sub_if_data *nsdata;
 	int ret;
 
-	ASSERT_RTNL();
+	ASSERT_LOCAL_MTX(local);
 
-	ndev = alloc_netdev(sizeof(struct ieee80211_sub_if_data), "",
-			    ieee80211_if_mgmt_setup);
+	ndev = alloc_netdev(sizeof(struct ieee80211_sub_if_data),
+			    "wmgmt%d", ieee80211_if_mgmt_setup);
 	if (!ndev)
 		return -ENOMEM;
-	ret = dev_alloc_name(ndev, "wmgmt%d");
-	if (ret < 0)
-		goto fail;
 
 	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
@@ -121,7 +107,7 @@ int ieee80211_if_add_mgmt(struct ieee802
 	nsdata->local = local;
 	ieee80211_if_sdata_init(nsdata);
 
-	ret = register_netdevice(ndev);
+	ret = register_netdev(ndev);
 	if (ret)
 		goto fail;
 
@@ -141,11 +127,12 @@ void ieee80211_if_del_mgmt(struct ieee80
 {
 	struct net_device *apdev;
 
-	ASSERT_RTNL();
+	ASSERT_LOCAL_MTX(local);
+
 	apdev = local->apdev;
 	ieee80211_debugfs_remove_netdev(IEEE80211_DEV_TO_SUB_IF(apdev));
 	local->apdev = NULL;
-	unregister_netdevice(apdev);
+	unregister_netdev(apdev);
 }
 
 void ieee80211_if_set_type(struct net_device *dev, int type)
@@ -202,7 +189,6 @@ void ieee80211_if_set_type(struct net_de
 	ieee80211_update_default_wep_only(local);
 }
 
-/* Must be called with rtnl lock held. */
 void ieee80211_if_reinit(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -210,19 +196,12 @@ void ieee80211_if_reinit(struct net_devi
 	struct sta_info *sta;
 	int i;
 
-	ASSERT_RTNL();
+	ASSERT_LOCAL_MTX(local);
+
 	ieee80211_if_sdata_deinit(sdata);
 	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
 		if (!sdata->keys[i])
 			continue;
-#if 0
-		/* The interface is down at the moment, so there is not
-		 * really much point in disabling the keys at this point. */
-		memset(addr, 0xff, ETH_ALEN);
-		if (local->ops->set_key)
-			local->ops->set_key(local_to_hw(local), DISABLE_KEY, addr,
-					    local->keys[i], 0);
-#endif
 		ieee80211_key_free(sdata->keys[i]);
 		sdata->keys[i] = NULL;
 	}
@@ -295,7 +274,6 @@ void ieee80211_if_reinit(struct net_devi
 	ieee80211_if_sdata_init(sdata);
 }
 
-/* Must be called with rtnl lock held. */
 void __ieee80211_if_del(struct ieee80211_local *local,
 			struct ieee80211_sub_if_data *sdata)
 {
@@ -303,18 +281,17 @@ void __ieee80211_if_del(struct ieee80211
 
 	list_del(&sdata->list);
 	ieee80211_debugfs_remove_netdev(sdata);
-	unregister_netdevice(dev);
+	unregister_netdev(dev);
 	/* Except master interface, the net_device will be freed by
 	 * net_device->destructor (i. e. ieee80211_if_free). */
 }
 
-/* Must be called with rtnl lock held. */
 int ieee80211_if_remove(struct net_device *dev, const char *name, int id)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata, *n;
 
-	ASSERT_RTNL();
+	ASSERT_LOCAL_MTX(local);
 
 	list_for_each_entry_safe(sdata, n, &local->sub_if_list, list) {
 		if ((sdata->type == id || id == -1) &&
@@ -339,13 +316,13 @@ void ieee80211_if_free(struct net_device
 	free_netdev(dev);
 }
 
-/* Must be called with rtnl lock held. */
 void ieee80211_if_flush(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata, *n;
 
-	ASSERT_RTNL();
+	ASSERT_LOCAL_MTX(local);
+
 	list_for_each_entry_safe(sdata, n, &local->sub_if_list, list) {
 		__ieee80211_if_del(local, sdata);
 	}
@@ -356,10 +333,10 @@ void ieee80211_if_del(struct net_device 
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	rtnl_lock();
+	mutex_lock(&local->mtx);
 	if (sdata->type == IEEE80211_IF_TYPE_MGMT)
 		ieee80211_if_del_mgmt(local);
 	else
 		__ieee80211_if_del(local, sdata);
-	rtnl_unlock();
+	mutex_lock(&local->mtx);
 }
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-03-22 08:44:29.663480683 +0100
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-03-22 08:54:16.093480683 +0100
@@ -2677,6 +2677,14 @@ static int ieee80211_sta_start_scan(stru
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata;
 
+
+	mutex_lock(&local->mtx);
+	if (unlikely(local->reg_state == IEEE80211_DEV_UNREGISTERED)) {
+		mutex_unlock(&local->mtx);
+		return -ENODEV;
+	}
+	mutex_unlock(&local->mtx);
+
 	if (ssid_len > IEEE80211_MAX_SSID_LEN)
 		return -EINVAL;
 
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-03-22 09:11:07.993480683 +0100
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-03-22 09:11:25.033480683 +0100
@@ -1010,7 +1010,7 @@ static int ieee80211_ioctl_add_if(struct
 		if (left < sizeof(struct hostapd_if_wds))
 			return -EPROTO;
 
-		res = ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
+		res = ieee80211_if_add(dev, param->u.if_info.name, &new_dev);
 		if (res)
 			return res;
 		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_WDS);
@@ -1023,7 +1023,7 @@ static int ieee80211_ioctl_add_if(struct
 		if (left < sizeof(struct hostapd_if_vlan))
 			return -EPROTO;
 
-		res = ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
+		res = ieee80211_if_add(dev, param->u.if_info.name, &new_dev);
 		if (res)
 			return res;
 		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_VLAN);
@@ -1040,7 +1040,7 @@ static int ieee80211_ioctl_add_if(struct
 		if (left < sizeof(struct hostapd_if_bss))
 			return -EPROTO;
 
-		res = ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
+		res = ieee80211_if_add(dev, param->u.if_info.name, &new_dev);
 		if (res)
 			return res;
 		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_AP);
@@ -1050,7 +1050,7 @@ static int ieee80211_ioctl_add_if(struct
 		if (left < sizeof(struct hostapd_if_sta))
 			return -EPROTO;
 
-		res = ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
+		res = ieee80211_if_add(dev, param->u.if_info.name, &new_dev);
 		if (res)
 			return res;
 		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_STA);



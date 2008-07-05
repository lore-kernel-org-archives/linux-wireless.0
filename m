Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYGEKJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 06:09:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1KF4hr-0003Ei-Km
	for linux-wireless@vger.kernel.org; Sat, 05 Jul 2008 12:09:28 +0200
Message-Id: <20080705100825.768192000@sipsolutions.net> (sfid-20080705_120934_886710_1BFF88A8)
References: <20080705100655.419906000@sipsolutions.net>
Date: Sat, 05 Jul 2008 12:06:56 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH/RFT 1/2] mac80211: revamp virtual interface handling
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch revamps the virtual interface handling and makes the
code much easier to follow. Fewer functions, better names, less
spaghetti code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c            |   24 --
 net/mac80211/debugfs.c        |   15 -
 net/mac80211/debugfs_netdev.c |   14 -
 net/mac80211/debugfs_netdev.h |    5 
 net/mac80211/ieee80211_i.h    |   21 --
 net/mac80211/iface.c          |  337 +++++++++++++++++++-----------------------
 net/mac80211/main.c           |   18 --
 net/mac80211/wext.c           |    3 
 8 files changed, 172 insertions(+), 265 deletions(-)

--- everything.orig/net/mac80211/cfg.c	2008-07-05 04:16:54.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-07-05 12:04:29.000000000 +0200
@@ -50,9 +50,6 @@ static int ieee80211_add_iface(struct wi
 	struct ieee80211_sub_if_data *sdata;
 	int err;
 
-	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
-		return -ENODEV;
-
 	itype = nl80211_type_to_mac80211_type(type);
 	if (itype == IEEE80211_IF_TYPE_INVALID)
 		return -EINVAL;
@@ -68,35 +65,26 @@ static int ieee80211_add_iface(struct wi
 
 static int ieee80211_del_iface(struct wiphy *wiphy, int ifindex)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct net_device *dev;
-	char *name;
-
-	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
-		return -ENODEV;
 
 	/* we're under RTNL */
 	dev = __dev_get_by_index(&init_net, ifindex);
 	if (!dev)
-		return 0;
+		return -ENODEV;
 
-	name = dev->name;
+	ieee80211_if_remove(dev);
 
-	return ieee80211_if_remove(local->mdev, name, -1);
+	return 0;
 }
 
 static int ieee80211_change_iface(struct wiphy *wiphy, int ifindex,
 				  enum nl80211_iftype type, u32 *flags,
 				  struct vif_params *params)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct net_device *dev;
 	enum ieee80211_if_types itype;
 	struct ieee80211_sub_if_data *sdata;
 
-	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
-		return -ENODEV;
-
 	/* we're under RTNL */
 	dev = __dev_get_by_index(&init_net, ifindex);
 	if (!dev)
@@ -111,11 +99,7 @@ static int ieee80211_change_iface(struct
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
-		return -EOPNOTSUPP;
-
-	ieee80211_if_reinit(dev);
-	ieee80211_if_set_type(dev, itype);
+	ieee80211_if_change_type(sdata, itype);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) && params->mesh_id_len)
 		ieee80211_if_sta_set_mesh_id(&sdata->u.sta,
--- everything.orig/net/mac80211/ieee80211_i.h	2008-07-05 04:16:44.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-07-05 12:04:29.000000000 +0200
@@ -558,12 +558,6 @@ struct ieee80211_local {
 	bool tim_in_locked_section; /* see ieee80211_beacon_get() */
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
-	enum {
-		IEEE80211_DEV_UNINITIALIZED = 0,
-		IEEE80211_DEV_REGISTERED,
-		IEEE80211_DEV_UNREGISTERED,
-	} reg_state;
-
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
 	 * added to skb_queue will be processed, but frames in
 	 * skb_queue_unreliable may be dropped if the total length of these
@@ -863,7 +857,6 @@ int ieee80211_hw_config(struct ieee80211
 int ieee80211_if_config(struct net_device *dev);
 int ieee80211_if_config_beacon(struct net_device *dev);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
-void ieee80211_if_setup(struct net_device *dev);
 u32 ieee80211_handle_ht(struct ieee80211_local *local, int enable_ht,
 			struct ieee80211_ht_info *req_ht_cap,
 			struct ieee80211_ht_bss_info *req_bss_cap);
@@ -932,16 +925,14 @@ static inline void ieee80211_start_mesh(
 #endif
 
 /* interface handling */
+void ieee80211_if_setup(struct net_device *dev);
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
-		     struct net_device **new_dev, int type,
+		     struct net_device **new_dev, enum ieee80211_if_types type,
 		     struct vif_params *params);
-void ieee80211_if_set_type(struct net_device *dev, int type);
-void ieee80211_if_reinit(struct net_device *dev);
-void __ieee80211_if_del(struct ieee80211_local *local,
-			struct ieee80211_sub_if_data *sdata);
-int ieee80211_if_remove(struct net_device *dev, const char *name, int id);
-void ieee80211_if_free(struct net_device *dev);
-void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata);
+void ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
+			      enum ieee80211_if_types type);
+void ieee80211_if_remove(struct net_device *dev);
+void ieee80211_remove_interfaces(struct ieee80211_local *local);
 
 /* tx handling */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local);
--- everything.orig/net/mac80211/iface.c	2008-07-05 04:16:49.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-07-05 12:04:29.000000000 +0200
@@ -2,6 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright (c) 2006 Jiri Benc <jbenc@suse.cz>
+ * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -17,39 +18,149 @@
 #include "debugfs_netdev.h"
 #include "mesh.h"
 
-void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata)
+/*
+ * Called when the netdev is removed or, by the code below, before
+ * the interface type changes.
+ */
+static void ieee80211_teardown_sdata(struct net_device *dev)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct beacon_data *beacon;
+	struct sk_buff *skb;
+	int flushed;
 	int i;
 
-	/* Default values for sub-interface parameters */
-	sdata->drop_unencrypted = 0;
+	ieee80211_debugfs_remove_netdev(sdata);
+
+	/* free extra data */
+	ieee80211_free_keys(sdata);
+
 	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
-		skb_queue_head_init(&sdata->fragments[i].skb_list);
+		__skb_queue_purge(&sdata->fragments[i].skb_list);
+	sdata->fragment_next = 0;
 
-	INIT_LIST_HEAD(&sdata->key_list);
+	switch (sdata->vif.type) {
+	case IEEE80211_IF_TYPE_AP:
+		beacon = sdata->u.ap.beacon;
+		rcu_assign_pointer(sdata->u.ap.beacon, NULL);
+		synchronize_rcu();
+		kfree(beacon);
 
-	sdata->force_unicast_rateidx = -1;
-	sdata->max_ratectrl_rateidx = -1;
+		while ((skb = skb_dequeue(&sdata->u.ap.ps_bc_buf))) {
+			local->total_ps_buffered--;
+			dev_kfree_skb(skb);
+		}
+
+		break;
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		/* Allow compiler to elide mesh_rmc_free call. */
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			mesh_rmc_free(dev);
+		/* fall through */
+	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_IBSS:
+		kfree(sdata->u.sta.extra_ie);
+		kfree(sdata->u.sta.assocreq_ies);
+		kfree(sdata->u.sta.assocresp_ies);
+		kfree_skb(sdata->u.sta.probe_resp);
+		break;
+	case IEEE80211_IF_TYPE_WDS:
+	case IEEE80211_IF_TYPE_VLAN:
+	case IEEE80211_IF_TYPE_MNTR:
+		break;
+	case IEEE80211_IF_TYPE_INVALID:
+		BUG();
+		break;
+	}
+
+	flushed = sta_info_flush(local, sdata);
+	WARN_ON(flushed);
 }
 
-static void ieee80211_if_sdata_deinit(struct ieee80211_sub_if_data *sdata)
+/*
+ * Helper function to initialise an interface to a specific type.
+ */
+static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
+				  enum ieee80211_if_types type)
 {
-	int i;
+	struct ieee80211_if_sta *ifsta;
 
-	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
-		__skb_queue_purge(&sdata->fragments[i].skb_list);
+	/* clear type-dependent union */
+	memset(&sdata->u, 0, sizeof(sdata->u));
+
+	/* and set some type-dependent values */
+	sdata->vif.type = type;
+
+	/* only monitor differs */
+	sdata->dev->type = ARPHRD_ETHER;
+
+	switch (type) {
+	case IEEE80211_IF_TYPE_AP:
+		skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
+		INIT_LIST_HEAD(&sdata->u.ap.vlans);
+		break;
+	case IEEE80211_IF_TYPE_MESH_POINT:
+	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_IBSS:
+		ifsta = &sdata->u.sta;
+		INIT_WORK(&ifsta->work, ieee80211_sta_work);
+		setup_timer(&ifsta->timer, ieee80211_sta_timer,
+			    (unsigned long) sdata);
+		skb_queue_head_init(&ifsta->skb_queue);
+
+		ifsta->capab = WLAN_CAPABILITY_ESS;
+		ifsta->auth_algs = IEEE80211_AUTH_ALG_OPEN |
+			IEEE80211_AUTH_ALG_SHARED_KEY;
+		ifsta->flags |= IEEE80211_STA_CREATE_IBSS |
+			IEEE80211_STA_AUTO_BSSID_SEL |
+			IEEE80211_STA_AUTO_CHANNEL_SEL;
+		if (ieee80211_num_regular_queues(&sdata->local->hw) >= 4)
+			ifsta->flags |= IEEE80211_STA_WMM_ENABLED;
+
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			ieee80211_mesh_init_sdata(sdata);
+		break;
+	case IEEE80211_IF_TYPE_MNTR:
+		sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
+		sdata->dev->hard_start_xmit = ieee80211_monitor_start_xmit;
+		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
+				      MONITOR_FLAG_OTHER_BSS;
+		break;
+	case IEEE80211_IF_TYPE_WDS:
+	case IEEE80211_IF_TYPE_VLAN:
+		break;
+	case IEEE80211_IF_TYPE_INVALID:
+		BUG();
+		break;
+	}
+
+	ieee80211_debugfs_add_netdev(sdata);
+}
+
+void ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
+			      enum ieee80211_if_types type)
+{
+	/* Purge and reset type-dependent state. */
+	ieee80211_teardown_sdata(sdata->dev);
+	ieee80211_setup_sdata(sdata, type);
+
+	/* reset some values that shouldn't be kept across type changes */
+	sdata->basic_rates = 0;
+	sdata->drop_unencrypted = 0;
+	sdata->sequence = 0;
 }
 
-/* Must be called with rtnl lock held. */
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
-		     struct net_device **new_dev, int type,
+		     struct net_device **new_dev, enum ieee80211_if_types type,
 		     struct vif_params *params)
 {
 	struct net_device *ndev;
 	struct ieee80211_sub_if_data *sdata = NULL;
-	int ret;
+	int ret, i;
 
 	ASSERT_RTNL();
+
 	ndev = alloc_netdev(sizeof(*sdata) + local->hw.vif_data_size,
 			    name, ieee80211_if_setup);
 	if (!ndev)
@@ -74,18 +185,28 @@ int ieee80211_if_add(struct ieee80211_lo
 	/* don't use IEEE80211_DEV_TO_SUB_IF because it checks too much */
 	sdata = netdev_priv(ndev);
 	ndev->ieee80211_ptr = &sdata->wdev;
+
+	/* initialise type-independent data */
 	sdata->wdev.wiphy = local->hw.wiphy;
-	sdata->vif.type = IEEE80211_IF_TYPE_AP;
-	sdata->dev = ndev;
 	sdata->local = local;
-	ieee80211_if_sdata_init(sdata);
+	sdata->dev = ndev;
+
+	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
+		skb_queue_head_init(&sdata->fragments[i].skb_list);
+
+	INIT_LIST_HEAD(&sdata->key_list);
+
+	sdata->force_unicast_rateidx = -1;
+	sdata->max_ratectrl_rateidx = -1;
+
+	/* setup type-dependent data */
+	ieee80211_setup_sdata(sdata, type);
 
 	ret = register_netdevice(ndev);
 	if (ret)
 		goto fail;
 
-	ieee80211_debugfs_add_netdev(sdata);
-	ieee80211_if_set_type(ndev, type);
+	ndev->uninit = ieee80211_teardown_sdata;
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) &&
 	    params && params->mesh_id_len)
@@ -93,11 +214,6 @@ int ieee80211_if_add(struct ieee80211_lo
 					     params->mesh_id_len,
 					     params->mesh_id);
 
-	/* we're under RTNL so all this is fine */
-	if (unlikely(local->reg_state == IEEE80211_DEV_UNREGISTERED)) {
-		__ieee80211_if_del(local, sdata);
-		return -ENODEV;
-	}
 	list_add_tail_rcu(&sdata->list, &local->interfaces);
 
 	if (new_dev)
@@ -105,181 +221,34 @@ int ieee80211_if_add(struct ieee80211_lo
 
 	return 0;
 
-fail:
+ fail:
 	free_netdev(ndev);
 	return ret;
 }
 
-void ieee80211_if_set_type(struct net_device *dev, int type)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	int oldtype = sdata->vif.type;
-
-	/*
-	 * Called even when register_netdevice fails, it would
-	 * oops if assigned before initialising the rest.
-	 */
-	dev->uninit = ieee80211_if_reinit;
-
-	/* most have no BSS pointer */
-	sdata->bss = NULL;
-	sdata->vif.type = type;
-
-	sdata->basic_rates = 0;
-
-	switch (type) {
-	case IEEE80211_IF_TYPE_WDS:
-	case IEEE80211_IF_TYPE_VLAN:
-		/* nothing special */
-		break;
-	case IEEE80211_IF_TYPE_AP:
-		skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
-		INIT_LIST_HEAD(&sdata->u.ap.vlans);
-		break;
-	case IEEE80211_IF_TYPE_MESH_POINT:
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS: {
-		struct ieee80211_if_sta *ifsta;
-
-		ifsta = &sdata->u.sta;
-		INIT_WORK(&ifsta->work, ieee80211_sta_work);
-		setup_timer(&ifsta->timer, ieee80211_sta_timer,
-			    (unsigned long) sdata);
-		skb_queue_head_init(&ifsta->skb_queue);
-
-		ifsta->capab = WLAN_CAPABILITY_ESS;
-		ifsta->auth_algs = IEEE80211_AUTH_ALG_OPEN |
-			IEEE80211_AUTH_ALG_SHARED_KEY;
-		ifsta->flags |= IEEE80211_STA_CREATE_IBSS |
-			IEEE80211_STA_AUTO_BSSID_SEL |
-			IEEE80211_STA_AUTO_CHANNEL_SEL;
-		if (ieee80211_num_regular_queues(&sdata->local->hw) >= 4)
-			ifsta->flags |= IEEE80211_STA_WMM_ENABLED;
-
-		if (ieee80211_vif_is_mesh(&sdata->vif))
-			ieee80211_mesh_init_sdata(sdata);
-		break;
-	}
-	case IEEE80211_IF_TYPE_MNTR:
-		dev->type = ARPHRD_IEEE80211_RADIOTAP;
-		dev->hard_start_xmit = ieee80211_monitor_start_xmit;
-		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
-				      MONITOR_FLAG_OTHER_BSS;
-		break;
-	case IEEE80211_IF_TYPE_INVALID:
-		BUG();
-		break;
-	}
-	ieee80211_debugfs_change_if_type(sdata, oldtype);
-}
-
-/* Must be called with rtnl lock held. */
-void ieee80211_if_reinit(struct net_device *dev)
+void ieee80211_if_remove(struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct sk_buff *skb;
-	int flushed;
 
 	ASSERT_RTNL();
 
-	ieee80211_free_keys(sdata);
-
-	ieee80211_if_sdata_deinit(sdata);
-
-	/* Need to handle mesh specially to allow eliding the function call */
-	if (ieee80211_vif_is_mesh(&sdata->vif))
-		mesh_rmc_free(dev);
-
-	switch (sdata->vif.type) {
-	case IEEE80211_IF_TYPE_INVALID:
-		/* cannot happen */
-		WARN_ON(1);
-		break;
-	case IEEE80211_IF_TYPE_AP: {
-		struct beacon_data *beacon;
-
-		beacon = sdata->u.ap.beacon;
-		rcu_assign_pointer(sdata->u.ap.beacon, NULL);
-		synchronize_rcu();
-		kfree(beacon);
-
-		while ((skb = skb_dequeue(&sdata->u.ap.ps_bc_buf))) {
-			local->total_ps_buffered--;
-			dev_kfree_skb(skb);
-		}
-
-		break;
-	}
-	case IEEE80211_IF_TYPE_WDS:
-	case IEEE80211_IF_TYPE_VLAN:
-		/* nothing to do */
-		break;
-	case IEEE80211_IF_TYPE_MESH_POINT:
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
-		kfree(sdata->u.sta.extra_ie);
-		sdata->u.sta.extra_ie = NULL;
-		kfree(sdata->u.sta.assocreq_ies);
-		sdata->u.sta.assocreq_ies = NULL;
-		kfree(sdata->u.sta.assocresp_ies);
-		sdata->u.sta.assocresp_ies = NULL;
-		if (sdata->u.sta.probe_resp) {
-			dev_kfree_skb(sdata->u.sta.probe_resp);
-			sdata->u.sta.probe_resp = NULL;
-		}
-
-		break;
-	case IEEE80211_IF_TYPE_MNTR:
-		dev->type = ARPHRD_ETHER;
-		break;
-	}
-
-	flushed = sta_info_flush(local, sdata);
-	WARN_ON(flushed);
-
-	memset(&sdata->u, 0, sizeof(sdata->u));
-	ieee80211_if_sdata_init(sdata);
-}
-
-/* Must be called with rtnl lock held. */
-void __ieee80211_if_del(struct ieee80211_local *local,
-			struct ieee80211_sub_if_data *sdata)
-{
-	struct net_device *dev = sdata->dev;
-
-	ieee80211_debugfs_remove_netdev(sdata);
+	list_del_rcu(&sdata->list);
+	synchronize_rcu();
 	unregister_netdevice(dev);
-	/*
-	 * The net_device will be freed by its destructor,
-	 * i.e. ieee80211_if_free.
-	 */
 }
 
-/* Must be called with rtnl lock held. */
-int ieee80211_if_remove(struct net_device *dev, const char *name, int id)
+/*
+ * Remove all interfaces, may only be called at hardware unregistration
+ * time because it doesn't do RCU-safe list removals.
+ */
+void ieee80211_remove_interfaces(struct ieee80211_local *local)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata, *n;
+	struct ieee80211_sub_if_data *sdata, *tmp;
 
 	ASSERT_RTNL();
 
-	list_for_each_entry_safe(sdata, n, &local->interfaces, list) {
-		if ((sdata->vif.type == id || id == -1) &&
-		    strcmp(name, sdata->dev->name) == 0) {
-			list_del_rcu(&sdata->list);
-			synchronize_rcu();
-			__ieee80211_if_del(local, sdata);
-			return 0;
-		}
+	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
+		list_del(&sdata->list);
+		unregister_netdevice(sdata->dev);
 	}
-	return -ENODEV;
-}
-
-void ieee80211_if_free(struct net_device *dev)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	ieee80211_if_sdata_deinit(sdata);
-	free_netdev(dev);
 }
--- everything.orig/net/mac80211/debugfs.c	2008-07-05 04:27:48.000000000 +0200
+++ everything/net/mac80211/debugfs.c	2008-07-05 04:29:44.000000000 +0200
@@ -70,16 +70,6 @@ DEBUGFS_READONLY_FILE(rate_ctrl_alg, 100
 
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
 
@@ -96,10 +86,7 @@ static ssize_t format_devstat_counter(st
 	if (!local->ops->get_stats)
 		return -EOPNOTSUPP;
 
-	res = rtnl_lock_local(local);
-	if (res)
-		return res;
-
+	rtnl_lock();
 	res = local->ops->get_stats(local_to_hw(local), &stats);
 	rtnl_unlock();
 	if (!res)
--- everything.orig/net/mac80211/main.c	2008-07-05 04:28:25.000000000 +0200
+++ everything/net/mac80211/main.c	2008-07-05 05:53:40.000000000 +0200
@@ -965,7 +965,6 @@ static const struct header_ops ieee80211
 	.cache_update	= eth_header_cache_update,
 };
 
-/* Must not be called for mdev */
 void ieee80211_if_setup(struct net_device *dev)
 {
 	ether_setup(dev);
@@ -975,7 +974,7 @@ void ieee80211_if_setup(struct net_devic
 	dev->change_mtu = ieee80211_change_mtu;
 	dev->open = ieee80211_open;
 	dev->stop = ieee80211_stop;
-	dev->destructor = ieee80211_if_free;
+	dev->destructor = free_netdev;
 }
 
 /* everything else */
@@ -1772,7 +1771,6 @@ int ieee80211_register_hw(struct ieee802
 		printk(KERN_WARNING "%s: Failed to add default virtual iface\n",
 		       wiphy_name(local->hw.wiphy));
 
-	local->reg_state = IEEE80211_DEV_REGISTERED;
 	rtnl_unlock();
 
 	ieee80211_led_init(local);
@@ -1802,30 +1800,20 @@ EXPORT_SYMBOL(ieee80211_register_hw);
 void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata, *tmp;
 
 	tasklet_kill(&local->tx_pending_tasklet);
 	tasklet_kill(&local->tasklet);
 
 	rtnl_lock();
 
-	BUG_ON(local->reg_state != IEEE80211_DEV_REGISTERED);
-
-	local->reg_state = IEEE80211_DEV_UNREGISTERED;
-
 	/*
 	 * At this point, interface list manipulations are fine
 	 * because the driver cannot be handing us frames any
 	 * more and the tasklet is killed.
 	 */
 
-	/*
-	 * First, we remove all virtual interfaces.
-	 */
-	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
-		list_del(&sdata->list);
-		__ieee80211_if_del(local, sdata);
-	}
+	/* First, we remove all virtual interfaces. */
+	ieee80211_remove_interfaces(local);
 
 	/* then, finally, remove the master interface */
 	unregister_netdevice(local->mdev);
--- everything.orig/net/mac80211/wext.c	2008-07-05 04:21:13.000000000 +0200
+++ everything/net/mac80211/wext.c	2008-07-05 12:04:29.000000000 +0200
@@ -301,8 +301,7 @@ static int ieee80211_ioctl_siwmode(struc
 	if (netif_running(dev))
 		return -EBUSY;
 
-	ieee80211_if_reinit(dev);
-	ieee80211_if_set_type(dev, type);
+	ieee80211_if_change_type(sdata, type);
 
 	return 0;
 }
--- everything.orig/net/mac80211/debugfs_netdev.c	2008-07-05 04:28:10.000000000 +0200
+++ everything/net/mac80211/debugfs_netdev.c	2008-07-05 05:46:55.000000000 +0200
@@ -476,12 +476,12 @@ static void del_mesh_config(struct ieee8
 }
 #endif
 
-static void del_files(struct ieee80211_sub_if_data *sdata, int type)
+static void del_files(struct ieee80211_sub_if_data *sdata)
 {
 	if (!sdata->debugfsdir)
 		return;
 
-	switch (type) {
+	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_MESH_POINT:
 #ifdef CONFIG_MAC80211_MESH
 		del_mesh_stats(sdata);
@@ -521,22 +521,16 @@ void ieee80211_debugfs_add_netdev(struct
 	sprintf(buf, "netdev:%s", sdata->dev->name);
 	sdata->debugfsdir = debugfs_create_dir(buf,
 		sdata->local->hw.wiphy->debugfsdir);
+	add_files(sdata);
 }
 
 void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata)
 {
-	del_files(sdata, sdata->vif.type);
+	del_files(sdata);
 	debugfs_remove(sdata->debugfsdir);
 	sdata->debugfsdir = NULL;
 }
 
-void ieee80211_debugfs_change_if_type(struct ieee80211_sub_if_data *sdata,
-				      int oldtype)
-{
-	del_files(sdata, oldtype);
-	add_files(sdata);
-}
-
 static int netdev_notify(struct notifier_block *nb,
 			 unsigned long state,
 			 void *ndev)
--- everything.orig/net/mac80211/debugfs_netdev.h	2008-07-05 05:46:12.000000000 +0200
+++ everything/net/mac80211/debugfs_netdev.h	2008-07-05 05:46:26.000000000 +0200
@@ -6,8 +6,6 @@
 #ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata);
 void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata);
-void ieee80211_debugfs_change_if_type(struct ieee80211_sub_if_data *sdata,
-				     int oldtype);
 void ieee80211_debugfs_netdev_init(void);
 void ieee80211_debugfs_netdev_exit(void);
 #else
@@ -17,9 +15,6 @@ static inline void ieee80211_debugfs_add
 static inline void ieee80211_debugfs_remove_netdev(
 	struct ieee80211_sub_if_data *sdata)
 {}
-static inline void ieee80211_debugfs_change_if_type(
-	struct ieee80211_sub_if_data *sdata, int oldtype)
-{}
 static inline void ieee80211_debugfs_netdev_init(void)
 {}
 

-- 


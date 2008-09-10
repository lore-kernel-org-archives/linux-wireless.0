Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50120 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbYIJWIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:08:17 -0400
Message-Id: <20080910220424.267688000@sipsolutions.net> (sfid-20080911_000823_893438_D9CB17FE)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/18] mac80211: move regular interface handling
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the code to handle regular interfaces out of main.c and
into iface.c, keep only the master interface stuff in main.c.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    2 
 net/mac80211/iface.c       |  534 ++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/main.c        |  565 +--------------------------------------------
 3 files changed, 550 insertions(+), 551 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-10 23:58:04.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-10 23:58:08.000000000 +0200
@@ -891,6 +891,7 @@ u32 ieee80211_handle_ht(struct ieee80211
 			struct ieee80211_ht_bss_info *req_bss_cap);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				      u32 changed);
+void ieee80211_configure_filter(struct ieee80211_local *local);
 
 /* wireless extensions */
 extern const struct iw_handler_def ieee80211_iw_handler_def;
@@ -952,7 +953,6 @@ void ieee80211_rx_bss_put(struct ieee802
 			  struct ieee80211_bss *bss);
 
 /* interface handling */
-void ieee80211_if_setup(struct net_device *dev);
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct net_device **new_dev, enum nl80211_iftype type,
 		     struct vif_params *params);
--- everything.orig/net/mac80211/iface.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-09-10 23:58:08.000000000 +0200
@@ -1,4 +1,6 @@
 /*
+ * Interface handling (except master interface)
+ *
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright (c) 2006 Jiri Benc <jbenc@suse.cz>
@@ -17,7 +19,539 @@
 #include "sta_info.h"
 #include "debugfs_netdev.h"
 #include "mesh.h"
+#include "led.h"
+
+static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
+{
+	int meshhdrlen;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	meshhdrlen = (sdata->vif.type == NL80211_IFTYPE_MESH_POINT) ? 5 : 0;
+
+	/* FIX: what would be proper limits for MTU?
+	 * This interface uses 802.3 frames. */
+	if (new_mtu < 256 ||
+	    new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6 - meshhdrlen) {
+		return -EINVAL;
+	}
+
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: setting MTU %d\n", dev->name, new_mtu);
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+	dev->mtu = new_mtu;
+	return 0;
+}
+
+static inline int identical_mac_addr_allowed(int type1, int type2)
+{
+	return type1 == NL80211_IFTYPE_MONITOR ||
+		type2 == NL80211_IFTYPE_MONITOR ||
+		(type1 == NL80211_IFTYPE_AP && type2 == NL80211_IFTYPE_WDS) ||
+		(type1 == NL80211_IFTYPE_WDS &&
+			(type2 == NL80211_IFTYPE_WDS ||
+			 type2 == NL80211_IFTYPE_AP)) ||
+		(type1 == NL80211_IFTYPE_AP && type2 == NL80211_IFTYPE_AP_VLAN) ||
+		(type1 == NL80211_IFTYPE_AP_VLAN &&
+			(type2 == NL80211_IFTYPE_AP ||
+			 type2 == NL80211_IFTYPE_AP_VLAN));
+}
+
+static int ieee80211_open(struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata, *nsdata;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info *sta;
+	struct ieee80211_if_init_conf conf;
+	u32 changed = 0;
+	int res;
+	bool need_hw_reconfig = 0;
+	u8 null_addr[ETH_ALEN] = {0};
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	/* fail early if user set an invalid address */
+	if (compare_ether_addr(dev->dev_addr, null_addr) &&
+	    !is_valid_ether_addr(dev->dev_addr))
+		return -EADDRNOTAVAIL;
+
+	/* we hold the RTNL here so can safely walk the list */
+	list_for_each_entry(nsdata, &local->interfaces, list) {
+		struct net_device *ndev = nsdata->dev;
+
+		if (ndev != dev && netif_running(ndev)) {
+			/*
+			 * Allow only a single IBSS interface to be up at any
+			 * time. This is restricted because beacon distribution
+			 * cannot work properly if both are in the same IBSS.
+			 *
+			 * To remove this restriction we'd have to disallow them
+			 * from setting the same SSID on different IBSS interfaces
+			 * belonging to the same hardware. Then, however, we're
+			 * faced with having to adopt two different TSF timers...
+			 */
+			if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
+			    nsdata->vif.type == NL80211_IFTYPE_ADHOC)
+				return -EBUSY;
+
+			/*
+			 * The remaining checks are only performed for interfaces
+			 * with the same MAC address.
+			 */
+			if (compare_ether_addr(dev->dev_addr, ndev->dev_addr))
+				continue;
+
+			/*
+			 * check whether it may have the same address
+			 */
+			if (!identical_mac_addr_allowed(sdata->vif.type,
+							nsdata->vif.type))
+				return -ENOTUNIQ;
+
+			/*
+			 * can only add VLANs to enabled APs
+			 */
+			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+			    nsdata->vif.type == NL80211_IFTYPE_AP)
+				sdata->bss = &nsdata->u.ap;
+		}
+	}
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_WDS:
+		if (!is_valid_ether_addr(sdata->u.wds.remote_addr))
+			return -ENOLINK;
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		if (!sdata->bss)
+			return -ENOLINK;
+		list_add(&sdata->u.vlan.list, &sdata->bss->vlans);
+		break;
+	case NL80211_IFTYPE_AP:
+		sdata->bss = &sdata->u.ap;
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		if (!ieee80211_vif_is_mesh(&sdata->vif))
+			break;
+		/* mesh ifaces must set allmulti to forward mcast traffic */
+		atomic_inc(&local->iff_allmultis);
+		break;
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_ADHOC:
+		/* no special treatment */
+		break;
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case __NL80211_IFTYPE_AFTER_LAST:
+		/* cannot happen */
+		WARN_ON(1);
+		break;
+	}
+
+	if (local->open_count == 0) {
+		res = 0;
+		if (local->ops->start)
+			res = local->ops->start(local_to_hw(local));
+		if (res)
+			goto err_del_bss;
+		need_hw_reconfig = 1;
+		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
+	}
 
+	/*
+	 * Check all interfaces and copy the hopefully now-present
+	 * MAC address to those that have the special null one.
+	 */
+	list_for_each_entry(nsdata, &local->interfaces, list) {
+		struct net_device *ndev = nsdata->dev;
+
+		/*
+		 * No need to check netif_running since we do not allow
+		 * it to start up with this invalid address.
+		 */
+		if (compare_ether_addr(null_addr, ndev->dev_addr) == 0)
+			memcpy(ndev->dev_addr,
+			       local->hw.wiphy->perm_addr,
+			       ETH_ALEN);
+	}
+
+	if (compare_ether_addr(null_addr, local->mdev->dev_addr) == 0)
+		memcpy(local->mdev->dev_addr, local->hw.wiphy->perm_addr,
+		       ETH_ALEN);
+
+	/*
+	 * Validate the MAC address for this device.
+	 */
+	if (!is_valid_ether_addr(dev->dev_addr)) {
+		if (!local->open_count && local->ops->stop)
+			local->ops->stop(local_to_hw(local));
+		return -EADDRNOTAVAIL;
+	}
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP_VLAN:
+		/* no need to tell driver */
+		break;
+	case NL80211_IFTYPE_MONITOR:
+		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) {
+			local->cooked_mntrs++;
+			break;
+		}
+
+		/* must be before the call to ieee80211_configure_filter */
+		local->monitors++;
+		if (local->monitors == 1)
+			local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
+
+		if (sdata->u.mntr_flags & MONITOR_FLAG_FCSFAIL)
+			local->fif_fcsfail++;
+		if (sdata->u.mntr_flags & MONITOR_FLAG_PLCPFAIL)
+			local->fif_plcpfail++;
+		if (sdata->u.mntr_flags & MONITOR_FLAG_CONTROL)
+			local->fif_control++;
+		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
+			local->fif_other_bss++;
+
+		netif_addr_lock_bh(local->mdev);
+		ieee80211_configure_filter(local);
+		netif_addr_unlock_bh(local->mdev);
+		break;
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+		sdata->u.sta.flags &= ~IEEE80211_STA_PREV_BSSID_SET;
+		/* fall through */
+	default:
+		conf.vif = &sdata->vif;
+		conf.type = sdata->vif.type;
+		conf.mac_addr = dev->dev_addr;
+		res = local->ops->add_interface(local_to_hw(local), &conf);
+		if (res)
+			goto err_stop;
+
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			ieee80211_start_mesh(sdata);
+		changed |= ieee80211_reset_erp_info(sdata);
+		ieee80211_bss_info_change_notify(sdata, changed);
+		ieee80211_enable_keys(sdata);
+
+		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+		    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
+			netif_carrier_off(dev);
+		else
+			netif_carrier_on(dev);
+	}
+
+	if (sdata->vif.type == NL80211_IFTYPE_WDS) {
+		/* Create STA entry for the WDS peer */
+		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
+				     GFP_KERNEL);
+		if (!sta) {
+			res = -ENOMEM;
+			goto err_del_interface;
+		}
+
+		/* no locking required since STA is not live yet */
+		sta->flags |= WLAN_STA_AUTHORIZED;
+
+		res = sta_info_insert(sta);
+		if (res) {
+			/* STA has been freed */
+			goto err_del_interface;
+		}
+	}
+
+	if (local->open_count == 0) {
+		res = dev_open(local->mdev);
+		WARN_ON(res);
+		if (res)
+			goto err_del_interface;
+		tasklet_enable(&local->tx_pending_tasklet);
+		tasklet_enable(&local->tasklet);
+	}
+
+	/*
+	 * set_multicast_list will be invoked by the networking core
+	 * which will check whether any increments here were done in
+	 * error and sync them down to the hardware as filter flags.
+	 */
+	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
+		atomic_inc(&local->iff_allmultis);
+
+	if (sdata->flags & IEEE80211_SDATA_PROMISC)
+		atomic_inc(&local->iff_promiscs);
+
+	local->open_count++;
+	if (need_hw_reconfig) {
+		ieee80211_hw_config(local);
+		/*
+		 * set default queue parameters so drivers don't
+		 * need to initialise the hardware if the hardware
+		 * doesn't start up with sane defaults
+		 */
+		ieee80211_set_wmm_default(sdata);
+	}
+
+	/*
+	 * ieee80211_sta_work is disabled while network interface
+	 * is down. Therefore, some configuration changes may not
+	 * yet be effective. Trigger execution of ieee80211_sta_work
+	 * to fix this.
+	 */
+	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+		queue_work(local->hw.workqueue, &ifsta->work);
+	}
+
+	netif_tx_start_all_queues(dev);
+
+	return 0;
+ err_del_interface:
+	local->ops->remove_interface(local_to_hw(local), &conf);
+ err_stop:
+	if (!local->open_count && local->ops->stop)
+		local->ops->stop(local_to_hw(local));
+ err_del_bss:
+	sdata->bss = NULL;
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		list_del(&sdata->u.vlan.list);
+	return res;
+}
+
+static int ieee80211_stop(struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_init_conf conf;
+	struct sta_info *sta;
+
+	/*
+	 * Stop TX on this interface first.
+	 */
+	netif_tx_stop_all_queues(dev);
+
+	/*
+	 * Now delete all active aggregation sessions.
+	 */
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (sta->sdata == sdata)
+			ieee80211_sta_tear_down_BA_sessions(sdata, sta->addr);
+	}
+
+	rcu_read_unlock();
+
+	/*
+	 * Remove all stations associated with this interface.
+	 *
+	 * This must be done before calling ops->remove_interface()
+	 * because otherwise we can later invoke ops->sta_notify()
+	 * whenever the STAs are removed, and that invalidates driver
+	 * assumptions about always getting a vif pointer that is valid
+	 * (because if we remove a STA after ops->remove_interface()
+	 * the driver will have removed the vif info already!)
+	 *
+	 * We could relax this and only unlink the stations from the
+	 * hash table and list but keep them on a per-sdata list that
+	 * will be inserted back again when the interface is brought
+	 * up again, but I don't currently see a use case for that,
+	 * except with WDS which gets a STA entry created when it is
+	 * brought up.
+	 */
+	sta_info_flush(local, sdata);
+
+	/*
+	 * Don't count this interface for promisc/allmulti while it
+	 * is down. dev_mc_unsync() will invoke set_multicast_list
+	 * on the master interface which will sync these down to the
+	 * hardware as filter flags.
+	 */
+	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
+		atomic_dec(&local->iff_allmultis);
+
+	if (sdata->flags & IEEE80211_SDATA_PROMISC)
+		atomic_dec(&local->iff_promiscs);
+
+	dev_mc_unsync(local->mdev, dev);
+
+	/* APs need special treatment */
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		struct ieee80211_sub_if_data *vlan, *tmp;
+		struct beacon_data *old_beacon = sdata->u.ap.beacon;
+
+		/* remove beacon */
+		rcu_assign_pointer(sdata->u.ap.beacon, NULL);
+		synchronize_rcu();
+		kfree(old_beacon);
+
+		/* down all dependent devices, that is VLANs */
+		list_for_each_entry_safe(vlan, tmp, &sdata->u.ap.vlans,
+					 u.vlan.list)
+			dev_close(vlan->dev);
+		WARN_ON(!list_empty(&sdata->u.ap.vlans));
+	}
+
+	local->open_count--;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP_VLAN:
+		list_del(&sdata->u.vlan.list);
+		/* no need to tell driver */
+		break;
+	case NL80211_IFTYPE_MONITOR:
+		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) {
+			local->cooked_mntrs--;
+			break;
+		}
+
+		local->monitors--;
+		if (local->monitors == 0)
+			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
+
+		if (sdata->u.mntr_flags & MONITOR_FLAG_FCSFAIL)
+			local->fif_fcsfail--;
+		if (sdata->u.mntr_flags & MONITOR_FLAG_PLCPFAIL)
+			local->fif_plcpfail--;
+		if (sdata->u.mntr_flags & MONITOR_FLAG_CONTROL)
+			local->fif_control--;
+		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
+			local->fif_other_bss--;
+
+		netif_addr_lock_bh(local->mdev);
+		ieee80211_configure_filter(local);
+		netif_addr_unlock_bh(local->mdev);
+		break;
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+		sdata->u.sta.state = IEEE80211_STA_MLME_DISABLED;
+		memset(sdata->u.sta.bssid, 0, ETH_ALEN);
+		del_timer_sync(&sdata->u.sta.timer);
+		/*
+		 * If the timer fired while we waited for it, it will have
+		 * requeued the work. Now the work will be running again
+		 * but will not rearm the timer again because it checks
+		 * whether the interface is running, which, at this point,
+		 * it no longer is.
+		 */
+		cancel_work_sync(&sdata->u.sta.work);
+		/*
+		 * When we get here, the interface is marked down.
+		 * Call synchronize_rcu() to wait for the RX path
+		 * should it be using the interface and enqueuing
+		 * frames at this very time on another CPU.
+		 */
+		synchronize_rcu();
+		skb_queue_purge(&sdata->u.sta.skb_queue);
+
+		sdata->u.sta.flags &= ~IEEE80211_STA_PRIVACY_INVOKED;
+		kfree(sdata->u.sta.extra_ie);
+		sdata->u.sta.extra_ie = NULL;
+		sdata->u.sta.extra_ie_len = 0;
+		/* fall through */
+	case NL80211_IFTYPE_MESH_POINT:
+		if (ieee80211_vif_is_mesh(&sdata->vif)) {
+			/* allmulti is always set on mesh ifaces */
+			atomic_dec(&local->iff_allmultis);
+			ieee80211_stop_mesh(sdata);
+		}
+		/* fall through */
+	default:
+		if (local->scan_sdata == sdata) {
+			if (!local->ops->hw_scan)
+				cancel_delayed_work_sync(&local->scan_work);
+			/*
+			 * The software scan can no longer run now, so we can
+			 * clear out the scan_sdata reference. However, the
+			 * hardware scan may still be running. The complete
+			 * function must be prepared to handle a NULL value.
+			 */
+			local->scan_sdata = NULL;
+			/*
+			 * The memory barrier guarantees that another CPU
+			 * that is hardware-scanning will now see the fact
+			 * that this interface is gone.
+			 */
+			smp_mb();
+			/*
+			 * If software scanning, complete the scan but since
+			 * the scan_sdata is NULL already don't send out a
+			 * scan event to userspace -- the scan is incomplete.
+			 */
+			if (local->sw_scanning)
+				ieee80211_scan_completed(&local->hw);
+		}
+
+		conf.vif = &sdata->vif;
+		conf.type = sdata->vif.type;
+		conf.mac_addr = dev->dev_addr;
+		/* disable all keys for as long as this netdev is down */
+		ieee80211_disable_keys(sdata);
+		local->ops->remove_interface(local_to_hw(local), &conf);
+	}
+
+	sdata->bss = NULL;
+
+	if (local->open_count == 0) {
+		if (netif_running(local->mdev))
+			dev_close(local->mdev);
+
+		if (local->ops->stop)
+			local->ops->stop(local_to_hw(local));
+
+		ieee80211_led_radio(local, 0);
+
+		flush_workqueue(local->hw.workqueue);
+
+		tasklet_disable(&local->tx_pending_tasklet);
+		tasklet_disable(&local->tasklet);
+	}
+
+	return 0;
+}
+
+static void ieee80211_set_multicast_list(struct net_device *dev)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	int allmulti, promisc, sdata_allmulti, sdata_promisc;
+
+	allmulti = !!(dev->flags & IFF_ALLMULTI);
+	promisc = !!(dev->flags & IFF_PROMISC);
+	sdata_allmulti = !!(sdata->flags & IEEE80211_SDATA_ALLMULTI);
+	sdata_promisc = !!(sdata->flags & IEEE80211_SDATA_PROMISC);
+
+	if (allmulti != sdata_allmulti) {
+		if (dev->flags & IFF_ALLMULTI)
+			atomic_inc(&local->iff_allmultis);
+		else
+			atomic_dec(&local->iff_allmultis);
+		sdata->flags ^= IEEE80211_SDATA_ALLMULTI;
+	}
+
+	if (promisc != sdata_promisc) {
+		if (dev->flags & IFF_PROMISC)
+			atomic_inc(&local->iff_promiscs);
+		else
+			atomic_dec(&local->iff_promiscs);
+		sdata->flags ^= IEEE80211_SDATA_PROMISC;
+	}
+
+	dev_mc_sync(local->mdev, dev);
+}
+
+static void ieee80211_if_setup(struct net_device *dev)
+{
+	ether_setup(dev);
+	dev->hard_start_xmit = ieee80211_subif_start_xmit;
+	dev->wireless_handlers = &ieee80211_iw_handler_def;
+	dev->set_multicast_list = ieee80211_set_multicast_list;
+	dev->change_mtu = ieee80211_change_mtu;
+	dev->open = ieee80211_open;
+	dev->stop = ieee80211_stop;
+	dev->destructor = free_netdev;
+	/* we will validate the address ourselves in ->open */
+	dev->validate_addr = NULL;
+}
 /*
  * Called when the netdev is removed or, by the code below, before
  * the interface type changes.
--- everything.orig/net/mac80211/main.c	2008-09-10 23:58:04.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-10 23:58:08.000000000 +0200
@@ -45,16 +45,9 @@ struct ieee80211_tx_status_rtap_hdr {
 	u8 data_retries;
 } __attribute__ ((packed));
 
-/* common interface routines */
-
-static int header_parse_80211(const struct sk_buff *skb, unsigned char *haddr)
-{
-	memcpy(haddr, skb_mac_header(skb) + 10, ETH_ALEN); /* addr2 */
-	return ETH_ALEN;
-}
 
 /* must be called under mdev tx lock */
-static void ieee80211_configure_filter(struct ieee80211_local *local)
+void ieee80211_configure_filter(struct ieee80211_local *local)
 {
 	unsigned int changed_flags;
 	unsigned int new_flags = 0;
@@ -97,6 +90,20 @@ static void ieee80211_configure_filter(s
 
 /* master interface */
 
+static int header_parse_80211(const struct sk_buff *skb, unsigned char *haddr)
+{
+	memcpy(haddr, skb_mac_header(skb) + 10, ETH_ALEN); /* addr2 */
+	return ETH_ALEN;
+}
+
+static const struct header_ops ieee80211_header_ops = {
+	.create		= eth_header,
+	.parse		= header_parse_80211,
+	.rebuild	= eth_rebuild_header,
+	.cache		= eth_header_cache,
+	.cache_update	= eth_header_cache_update,
+};
+
 static int ieee80211_master_open(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -139,548 +146,6 @@ static void ieee80211_master_set_multica
 	ieee80211_configure_filter(local);
 }
 
-/* regular interfaces */
-
-static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
-{
-	int meshhdrlen;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	meshhdrlen = (sdata->vif.type == NL80211_IFTYPE_MESH_POINT) ? 5 : 0;
-
-	/* FIX: what would be proper limits for MTU?
-	 * This interface uses 802.3 frames. */
-	if (new_mtu < 256 ||
-	    new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6 - meshhdrlen) {
-		return -EINVAL;
-	}
-
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "%s: setting MTU %d\n", dev->name, new_mtu);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-	dev->mtu = new_mtu;
-	return 0;
-}
-
-static inline int identical_mac_addr_allowed(int type1, int type2)
-{
-	return type1 == NL80211_IFTYPE_MONITOR ||
-		type2 == NL80211_IFTYPE_MONITOR ||
-		(type1 == NL80211_IFTYPE_AP && type2 == NL80211_IFTYPE_WDS) ||
-		(type1 == NL80211_IFTYPE_WDS &&
-			(type2 == NL80211_IFTYPE_WDS ||
-			 type2 == NL80211_IFTYPE_AP)) ||
-		(type1 == NL80211_IFTYPE_AP && type2 == NL80211_IFTYPE_AP_VLAN) ||
-		(type1 == NL80211_IFTYPE_AP_VLAN &&
-			(type2 == NL80211_IFTYPE_AP ||
-			 type2 == NL80211_IFTYPE_AP_VLAN));
-}
-
-static int ieee80211_open(struct net_device *dev)
-{
-	struct ieee80211_sub_if_data *sdata, *nsdata;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct sta_info *sta;
-	struct ieee80211_if_init_conf conf;
-	u32 changed = 0;
-	int res;
-	bool need_hw_reconfig = 0;
-	u8 null_addr[ETH_ALEN] = {0};
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	/* fail early if user set an invalid address */
-	if (compare_ether_addr(dev->dev_addr, null_addr) &&
-	    !is_valid_ether_addr(dev->dev_addr))
-		return -EADDRNOTAVAIL;
-
-	/* we hold the RTNL here so can safely walk the list */
-	list_for_each_entry(nsdata, &local->interfaces, list) {
-		struct net_device *ndev = nsdata->dev;
-
-		if (ndev != dev && netif_running(ndev)) {
-			/*
-			 * Allow only a single IBSS interface to be up at any
-			 * time. This is restricted because beacon distribution
-			 * cannot work properly if both are in the same IBSS.
-			 *
-			 * To remove this restriction we'd have to disallow them
-			 * from setting the same SSID on different IBSS interfaces
-			 * belonging to the same hardware. Then, however, we're
-			 * faced with having to adopt two different TSF timers...
-			 */
-			if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
-			    nsdata->vif.type == NL80211_IFTYPE_ADHOC)
-				return -EBUSY;
-
-			/*
-			 * The remaining checks are only performed for interfaces
-			 * with the same MAC address.
-			 */
-			if (compare_ether_addr(dev->dev_addr, ndev->dev_addr))
-				continue;
-
-			/*
-			 * check whether it may have the same address
-			 */
-			if (!identical_mac_addr_allowed(sdata->vif.type,
-							nsdata->vif.type))
-				return -ENOTUNIQ;
-
-			/*
-			 * can only add VLANs to enabled APs
-			 */
-			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
-			    nsdata->vif.type == NL80211_IFTYPE_AP)
-				sdata->bss = &nsdata->u.ap;
-		}
-	}
-
-	switch (sdata->vif.type) {
-	case NL80211_IFTYPE_WDS:
-		if (!is_valid_ether_addr(sdata->u.wds.remote_addr))
-			return -ENOLINK;
-		break;
-	case NL80211_IFTYPE_AP_VLAN:
-		if (!sdata->bss)
-			return -ENOLINK;
-		list_add(&sdata->u.vlan.list, &sdata->bss->vlans);
-		break;
-	case NL80211_IFTYPE_AP:
-		sdata->bss = &sdata->u.ap;
-		break;
-	case NL80211_IFTYPE_MESH_POINT:
-		if (!ieee80211_vif_is_mesh(&sdata->vif))
-			break;
-		/* mesh ifaces must set allmulti to forward mcast traffic */
-		atomic_inc(&local->iff_allmultis);
-		break;
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_MONITOR:
-	case NL80211_IFTYPE_ADHOC:
-		/* no special treatment */
-		break;
-	case NL80211_IFTYPE_UNSPECIFIED:
-	case __NL80211_IFTYPE_AFTER_LAST:
-		/* cannot happen */
-		WARN_ON(1);
-		break;
-	}
-
-	if (local->open_count == 0) {
-		res = 0;
-		if (local->ops->start)
-			res = local->ops->start(local_to_hw(local));
-		if (res)
-			goto err_del_bss;
-		need_hw_reconfig = 1;
-		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
-	}
-
-	/*
-	 * Check all interfaces and copy the hopefully now-present
-	 * MAC address to those that have the special null one.
-	 */
-	list_for_each_entry(nsdata, &local->interfaces, list) {
-		struct net_device *ndev = nsdata->dev;
-
-		/*
-		 * No need to check netif_running since we do not allow
-		 * it to start up with this invalid address.
-		 */
-		if (compare_ether_addr(null_addr, ndev->dev_addr) == 0)
-			memcpy(ndev->dev_addr,
-			       local->hw.wiphy->perm_addr,
-			       ETH_ALEN);
-	}
-
-	if (compare_ether_addr(null_addr, local->mdev->dev_addr) == 0)
-		memcpy(local->mdev->dev_addr, local->hw.wiphy->perm_addr,
-		       ETH_ALEN);
-
-	/*
-	 * Validate the MAC address for this device.
-	 */
-	if (!is_valid_ether_addr(dev->dev_addr)) {
-		if (!local->open_count && local->ops->stop)
-			local->ops->stop(local_to_hw(local));
-		return -EADDRNOTAVAIL;
-	}
-
-	switch (sdata->vif.type) {
-	case NL80211_IFTYPE_AP_VLAN:
-		/* no need to tell driver */
-		break;
-	case NL80211_IFTYPE_MONITOR:
-		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) {
-			local->cooked_mntrs++;
-			break;
-		}
-
-		/* must be before the call to ieee80211_configure_filter */
-		local->monitors++;
-		if (local->monitors == 1)
-			local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
-
-		if (sdata->u.mntr_flags & MONITOR_FLAG_FCSFAIL)
-			local->fif_fcsfail++;
-		if (sdata->u.mntr_flags & MONITOR_FLAG_PLCPFAIL)
-			local->fif_plcpfail++;
-		if (sdata->u.mntr_flags & MONITOR_FLAG_CONTROL)
-			local->fif_control++;
-		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
-			local->fif_other_bss++;
-
-		netif_addr_lock_bh(local->mdev);
-		ieee80211_configure_filter(local);
-		netif_addr_unlock_bh(local->mdev);
-		break;
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
-		sdata->u.sta.flags &= ~IEEE80211_STA_PREV_BSSID_SET;
-		/* fall through */
-	default:
-		conf.vif = &sdata->vif;
-		conf.type = sdata->vif.type;
-		conf.mac_addr = dev->dev_addr;
-		res = local->ops->add_interface(local_to_hw(local), &conf);
-		if (res)
-			goto err_stop;
-
-		if (ieee80211_vif_is_mesh(&sdata->vif))
-			ieee80211_start_mesh(sdata);
-		changed |= ieee80211_reset_erp_info(sdata);
-		ieee80211_bss_info_change_notify(sdata, changed);
-		ieee80211_enable_keys(sdata);
-
-		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-		    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
-			netif_carrier_off(dev);
-		else
-			netif_carrier_on(dev);
-	}
-
-	if (sdata->vif.type == NL80211_IFTYPE_WDS) {
-		/* Create STA entry for the WDS peer */
-		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
-				     GFP_KERNEL);
-		if (!sta) {
-			res = -ENOMEM;
-			goto err_del_interface;
-		}
-
-		/* no locking required since STA is not live yet */
-		sta->flags |= WLAN_STA_AUTHORIZED;
-
-		res = sta_info_insert(sta);
-		if (res) {
-			/* STA has been freed */
-			goto err_del_interface;
-		}
-	}
-
-	if (local->open_count == 0) {
-		res = dev_open(local->mdev);
-		WARN_ON(res);
-		if (res)
-			goto err_del_interface;
-		tasklet_enable(&local->tx_pending_tasklet);
-		tasklet_enable(&local->tasklet);
-	}
-
-	/*
-	 * set_multicast_list will be invoked by the networking core
-	 * which will check whether any increments here were done in
-	 * error and sync them down to the hardware as filter flags.
-	 */
-	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
-		atomic_inc(&local->iff_allmultis);
-
-	if (sdata->flags & IEEE80211_SDATA_PROMISC)
-		atomic_inc(&local->iff_promiscs);
-
-	local->open_count++;
-	if (need_hw_reconfig) {
-		ieee80211_hw_config(local);
-		/*
-		 * set default queue parameters so drivers don't
-		 * need to initialise the hardware if the hardware
-		 * doesn't start up with sane defaults
-		 */
-		ieee80211_set_wmm_default(sdata);
-	}
-
-	/*
-	 * ieee80211_sta_work is disabled while network interface
-	 * is down. Therefore, some configuration changes may not
-	 * yet be effective. Trigger execution of ieee80211_sta_work
-	 * to fix this.
-	 */
-	if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-	    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-		queue_work(local->hw.workqueue, &ifsta->work);
-	}
-
-	netif_tx_start_all_queues(dev);
-
-	return 0;
- err_del_interface:
-	local->ops->remove_interface(local_to_hw(local), &conf);
- err_stop:
-	if (!local->open_count && local->ops->stop)
-		local->ops->stop(local_to_hw(local));
- err_del_bss:
-	sdata->bss = NULL;
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-		list_del(&sdata->u.vlan.list);
-	return res;
-}
-
-static int ieee80211_stop(struct net_device *dev)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_init_conf conf;
-	struct sta_info *sta;
-
-	/*
-	 * Stop TX on this interface first.
-	 */
-	netif_tx_stop_all_queues(dev);
-
-	/*
-	 * Now delete all active aggregation sessions.
-	 */
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
-		if (sta->sdata == sdata)
-			ieee80211_sta_tear_down_BA_sessions(sdata, sta->addr);
-	}
-
-	rcu_read_unlock();
-
-	/*
-	 * Remove all stations associated with this interface.
-	 *
-	 * This must be done before calling ops->remove_interface()
-	 * because otherwise we can later invoke ops->sta_notify()
-	 * whenever the STAs are removed, and that invalidates driver
-	 * assumptions about always getting a vif pointer that is valid
-	 * (because if we remove a STA after ops->remove_interface()
-	 * the driver will have removed the vif info already!)
-	 *
-	 * We could relax this and only unlink the stations from the
-	 * hash table and list but keep them on a per-sdata list that
-	 * will be inserted back again when the interface is brought
-	 * up again, but I don't currently see a use case for that,
-	 * except with WDS which gets a STA entry created when it is
-	 * brought up.
-	 */
-	sta_info_flush(local, sdata);
-
-	/*
-	 * Don't count this interface for promisc/allmulti while it
-	 * is down. dev_mc_unsync() will invoke set_multicast_list
-	 * on the master interface which will sync these down to the
-	 * hardware as filter flags.
-	 */
-	if (sdata->flags & IEEE80211_SDATA_ALLMULTI)
-		atomic_dec(&local->iff_allmultis);
-
-	if (sdata->flags & IEEE80211_SDATA_PROMISC)
-		atomic_dec(&local->iff_promiscs);
-
-	dev_mc_unsync(local->mdev, dev);
-
-	/* APs need special treatment */
-	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		struct ieee80211_sub_if_data *vlan, *tmp;
-		struct beacon_data *old_beacon = sdata->u.ap.beacon;
-
-		/* remove beacon */
-		rcu_assign_pointer(sdata->u.ap.beacon, NULL);
-		synchronize_rcu();
-		kfree(old_beacon);
-
-		/* down all dependent devices, that is VLANs */
-		list_for_each_entry_safe(vlan, tmp, &sdata->u.ap.vlans,
-					 u.vlan.list)
-			dev_close(vlan->dev);
-		WARN_ON(!list_empty(&sdata->u.ap.vlans));
-	}
-
-	local->open_count--;
-
-	switch (sdata->vif.type) {
-	case NL80211_IFTYPE_AP_VLAN:
-		list_del(&sdata->u.vlan.list);
-		/* no need to tell driver */
-		break;
-	case NL80211_IFTYPE_MONITOR:
-		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) {
-			local->cooked_mntrs--;
-			break;
-		}
-
-		local->monitors--;
-		if (local->monitors == 0)
-			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
-
-		if (sdata->u.mntr_flags & MONITOR_FLAG_FCSFAIL)
-			local->fif_fcsfail--;
-		if (sdata->u.mntr_flags & MONITOR_FLAG_PLCPFAIL)
-			local->fif_plcpfail--;
-		if (sdata->u.mntr_flags & MONITOR_FLAG_CONTROL)
-			local->fif_control--;
-		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
-			local->fif_other_bss--;
-
-		netif_addr_lock_bh(local->mdev);
-		ieee80211_configure_filter(local);
-		netif_addr_unlock_bh(local->mdev);
-		break;
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
-		sdata->u.sta.state = IEEE80211_STA_MLME_DISABLED;
-		memset(sdata->u.sta.bssid, 0, ETH_ALEN);
-		del_timer_sync(&sdata->u.sta.timer);
-		/*
-		 * If the timer fired while we waited for it, it will have
-		 * requeued the work. Now the work will be running again
-		 * but will not rearm the timer again because it checks
-		 * whether the interface is running, which, at this point,
-		 * it no longer is.
-		 */
-		cancel_work_sync(&sdata->u.sta.work);
-		/*
-		 * When we get here, the interface is marked down.
-		 * Call synchronize_rcu() to wait for the RX path
-		 * should it be using the interface and enqueuing
-		 * frames at this very time on another CPU.
-		 */
-		synchronize_rcu();
-		skb_queue_purge(&sdata->u.sta.skb_queue);
-
-		sdata->u.sta.flags &= ~IEEE80211_STA_PRIVACY_INVOKED;
-		kfree(sdata->u.sta.extra_ie);
-		sdata->u.sta.extra_ie = NULL;
-		sdata->u.sta.extra_ie_len = 0;
-		/* fall through */
-	case NL80211_IFTYPE_MESH_POINT:
-		if (ieee80211_vif_is_mesh(&sdata->vif)) {
-			/* allmulti is always set on mesh ifaces */
-			atomic_dec(&local->iff_allmultis);
-			ieee80211_stop_mesh(sdata);
-		}
-		/* fall through */
-	default:
-		if (local->scan_sdata == sdata) {
-			if (!local->ops->hw_scan)
-				cancel_delayed_work_sync(&local->scan_work);
-			/*
-			 * The software scan can no longer run now, so we can
-			 * clear out the scan_sdata reference. However, the
-			 * hardware scan may still be running. The complete
-			 * function must be prepared to handle a NULL value.
-			 */
-			local->scan_sdata = NULL;
-			/*
-			 * The memory barrier guarantees that another CPU
-			 * that is hardware-scanning will now see the fact
-			 * that this interface is gone.
-			 */
-			smp_mb();
-			/*
-			 * If software scanning, complete the scan but since
-			 * the scan_sdata is NULL already don't send out a
-			 * scan event to userspace -- the scan is incomplete.
-			 */
-			if (local->sw_scanning)
-				ieee80211_scan_completed(&local->hw);
-		}
-
-		conf.vif = &sdata->vif;
-		conf.type = sdata->vif.type;
-		conf.mac_addr = dev->dev_addr;
-		/* disable all keys for as long as this netdev is down */
-		ieee80211_disable_keys(sdata);
-		local->ops->remove_interface(local_to_hw(local), &conf);
-	}
-
-	sdata->bss = NULL;
-
-	if (local->open_count == 0) {
-		if (netif_running(local->mdev))
-			dev_close(local->mdev);
-
-		if (local->ops->stop)
-			local->ops->stop(local_to_hw(local));
-
-		ieee80211_led_radio(local, 0);
-
-		flush_workqueue(local->hw.workqueue);
-
-		tasklet_disable(&local->tx_pending_tasklet);
-		tasklet_disable(&local->tasklet);
-	}
-
-	return 0;
-}
-
-static void ieee80211_set_multicast_list(struct net_device *dev)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	int allmulti, promisc, sdata_allmulti, sdata_promisc;
-
-	allmulti = !!(dev->flags & IFF_ALLMULTI);
-	promisc = !!(dev->flags & IFF_PROMISC);
-	sdata_allmulti = !!(sdata->flags & IEEE80211_SDATA_ALLMULTI);
-	sdata_promisc = !!(sdata->flags & IEEE80211_SDATA_PROMISC);
-
-	if (allmulti != sdata_allmulti) {
-		if (dev->flags & IFF_ALLMULTI)
-			atomic_inc(&local->iff_allmultis);
-		else
-			atomic_dec(&local->iff_allmultis);
-		sdata->flags ^= IEEE80211_SDATA_ALLMULTI;
-	}
-
-	if (promisc != sdata_promisc) {
-		if (dev->flags & IFF_PROMISC)
-			atomic_inc(&local->iff_promiscs);
-		else
-			atomic_dec(&local->iff_promiscs);
-		sdata->flags ^= IEEE80211_SDATA_PROMISC;
-	}
-
-	dev_mc_sync(local->mdev, dev);
-}
-
-static const struct header_ops ieee80211_header_ops = {
-	.create		= eth_header,
-	.parse		= header_parse_80211,
-	.rebuild	= eth_rebuild_header,
-	.cache		= eth_header_cache,
-	.cache_update	= eth_header_cache_update,
-};
-
-void ieee80211_if_setup(struct net_device *dev)
-{
-	ether_setup(dev);
-	dev->hard_start_xmit = ieee80211_subif_start_xmit;
-	dev->wireless_handlers = &ieee80211_iw_handler_def;
-	dev->set_multicast_list = ieee80211_set_multicast_list;
-	dev->change_mtu = ieee80211_change_mtu;
-	dev->open = ieee80211_open;
-	dev->stop = ieee80211_stop;
-	dev->destructor = free_netdev;
-	/* we will validate the address ourselves in ->open */
-	dev->validate_addr = NULL;
-}
-
 /* everything else */
 
 int ieee80211_if_config(struct ieee80211_sub_if_data *sdata, u32 changed)

-- 


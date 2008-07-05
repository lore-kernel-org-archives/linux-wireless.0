Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52530 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbYGEXvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 19:51:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1KFHX7-0003JN-To
	for linux-wireless@vger.kernel.org; Sun, 06 Jul 2008 01:51:14 +0200
Message-Id: <20080705235012.501072000@sipsolutions.net> (sfid-20080706_015140_641922_45522129)
References: <20080705234735.210585000@sipsolutions.net>
Date: Sun, 06 Jul 2008 01:47:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFT 1/4] mac80211: make master netdev handling sane
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, almost every interface type has a 'bss' pointer
pointing to BSS information. This BSS information, however,
is for a _local_ BSS, not for the BSS we joined, so having
it on a STA mode interface makes little sense, but now they
have it pointing to the master device, which is an AP mode
virtual interface. However, except for some bitrate control
data, this pointer is only used in AP/VLAN modes (for power
saving stations.)

Overall, it is not necessary to even have the master netdev
be a valid virtual interface, and it doesn't have to be on
the list of interfaces either.

This patch changes the master netdev to be special, it now
 - no longer is on the list of virtual interfaces, which
   lets me remove a lot of tests for that
 - no longer has sub_if_data attached, since that isn't used

Additionally, this patch changes some vlan/ap mode handling
that is related to these 'bss' pointers described above (but
in the VLAN case they actually make sense because there they
point to the AP they belong to); it also adds some debugging
code to IEEE80211_DEV_TO_SUB_IF to validate it is not called
on the master netdev any more.

******
** Please test!
**
** I have not tested this patch heavily yet, especially not
** in anything other than STA mode. I believe it should work
** with the possible exception of power saving in IBSS, but
** I don't think we handle that anyway because we don't do
** anything about ATIM windows etc.
******

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c              |    2 
 net/mac80211/debugfs_netdev.c   |   34 +++++++++++---
 net/mac80211/ieee80211_i.h      |   41 ++++++++++-------
 net/mac80211/iface.c            |   64 +++++---------------------
 net/mac80211/main.c             |   96 +++++++++++-----------------------------
 net/mac80211/mlme.c             |   56 +++++++----------------
 net/mac80211/rc80211_pid_algo.c |    8 +--
 net/mac80211/rx.c               |   15 ++----
 net/mac80211/sta_info.c         |   29 ++++++++----
 net/mac80211/tx.c               |   11 ++--
 net/mac80211/wext.c             |   10 +---
 11 files changed, 153 insertions(+), 213 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-07-05 04:06:01.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-07-05 04:07:23.000000000 +0200
@@ -237,8 +237,6 @@ struct ieee80211_if_ap {
 	struct sk_buff_head ps_bc_buf;
 	atomic_t num_sta_ps; /* number of stations in PS mode */
 	int dtim_count;
-	int force_unicast_rateidx; /* forced TX rateidx for unicast frames */
-	int max_ratectrl_rateidx; /* max TX rateidx for rate control */
 	int num_beacons; /* number of TXed beacon frames for this BSS */
 };
 
@@ -248,7 +246,6 @@ struct ieee80211_if_wds {
 };
 
 struct ieee80211_if_vlan {
-	struct ieee80211_sub_if_data *ap;
 	struct list_head list;
 };
 
@@ -432,16 +429,18 @@ struct ieee80211_sub_if_data {
 	struct ieee80211_key *keys[NUM_DEFAULT_KEYS];
 	struct ieee80211_key *default_key;
 
+	/* BSS configuration for this interface. */
+	struct ieee80211_bss_conf bss_conf;
+
 	/*
-	 * BSS configuration for this interface.
-	 *
-	 * FIXME: I feel bad putting this here when we already have a
-	 *	  bss pointer, but the bss pointer is just wrong when
-	 *	  you have multiple virtual STA mode interfaces...
-	 *	  This needs to be fixed.
+	 * AP this belongs to: self in AP mode and
+	 * corresponding AP in VLAN mode, NULL for
+	 * all others (might be needed later in IBSS)
 	 */
-	struct ieee80211_bss_conf bss_conf;
-	struct ieee80211_if_ap *bss; /* BSS that this device belongs to */
+	struct ieee80211_if_ap *bss;
+
+	int force_unicast_rateidx; /* forced TX rateidx for unicast frames */
+	int max_ratectrl_rateidx; /* max TX rateidx for rate control */
 
 	union {
 		struct ieee80211_if_ap ap;
@@ -533,8 +532,6 @@ struct ieee80211_sub_if_data *vif_to_sda
 	return container_of(p, struct ieee80211_sub_if_data, vif);
 }
 
-#define IEEE80211_DEV_TO_SUB_IF(dev) netdev_priv(dev)
-
 enum {
 	IEEE80211_RX_MSG	= 1,
 	IEEE80211_TX_STATUS_MSG	= 2,
@@ -760,6 +757,16 @@ static inline int ieee80211_is_multiqueu
 #endif
 }
 
+static inline struct ieee80211_sub_if_data *
+IEEE80211_DEV_TO_SUB_IF(struct net_device *dev)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+
+	BUG_ON(!local || local->mdev == dev);
+
+	return netdev_priv(dev);
+}
+
 /* this struct represents 802.11n's RA/TID combination */
 struct ieee80211_ra_tid {
 	u8 ra[ETH_ALEN];
@@ -882,8 +889,8 @@ int ieee80211_sta_scan_results(struct ne
 ieee80211_rx_result ieee80211_sta_rx_scan(
 	struct net_device *dev, struct sk_buff *skb,
 	struct ieee80211_rx_status *rx_status);
-void ieee80211_rx_bss_list_init(struct net_device *dev);
-void ieee80211_rx_bss_list_deinit(struct net_device *dev);
+void ieee80211_rx_bss_list_init(struct ieee80211_local *local);
+void ieee80211_rx_bss_list_deinit(struct ieee80211_local *local);
 int ieee80211_sta_set_extra_ie(struct net_device *dev, char *ie, size_t len);
 struct sta_info *ieee80211_ibss_add_sta(struct net_device *dev,
 					struct sk_buff *skb, u8 *bssid,
@@ -924,8 +931,8 @@ static inline void ieee80211_start_mesh(
 {}
 #endif
 
-/* ieee80211_iface.c */
-int ieee80211_if_add(struct net_device *dev, const char *name,
+/* interface handling */
+int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct net_device **new_dev, int type,
 		     struct vif_params *params);
 void ieee80211_if_set_type(struct net_device *dev, int type);
--- everything.orig/net/mac80211/iface.c	2008-07-05 04:05:58.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-07-05 04:06:02.000000000 +0200
@@ -27,6 +27,9 @@ void ieee80211_if_sdata_init(struct ieee
 		skb_queue_head_init(&sdata->fragments[i].skb_list);
 
 	INIT_LIST_HEAD(&sdata->key_list);
+
+	sdata->force_unicast_rateidx = -1;
+	sdata->max_ratectrl_rateidx = -1;
 }
 
 static void ieee80211_if_sdata_deinit(struct ieee80211_sub_if_data *sdata)
@@ -38,12 +41,11 @@ static void ieee80211_if_sdata_deinit(st
 }
 
 /* Must be called with rtnl lock held. */
-int ieee80211_if_add(struct net_device *dev, const char *name,
+int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct net_device **new_dev, int type,
 		     struct vif_params *params)
 {
 	struct net_device *ndev;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = NULL;
 	int ret;
 
@@ -67,13 +69,10 @@ int ieee80211_if_add(struct net_device *
 		goto fail;
 
 	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
-	ndev->base_addr = dev->base_addr;
-	ndev->irq = dev->irq;
-	ndev->mem_start = dev->mem_start;
-	ndev->mem_end = dev->mem_end;
 	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
+	/* don't use IEEE80211_DEV_TO_SUB_IF because it checks too much */
+	sdata = netdev_priv(ndev);
 	ndev->ieee80211_ptr = &sdata->wdev;
 	sdata->wdev.wiphy = local->hw.wiphy;
 	sdata->vif.type = IEEE80211_IF_TYPE_AP;
@@ -117,14 +116,6 @@ void ieee80211_if_set_type(struct net_de
 	int oldtype = sdata->vif.type;
 
 	/*
-	 * We need to call this function on the master interface
-	 * which already has a hard_start_xmit routine assigned
-	 * which must not be changed.
-	 */
-	if (dev != sdata->local->mdev)
-		dev->hard_start_xmit = ieee80211_subif_start_xmit;
-
-	/*
 	 * Called even when register_netdevice fails, it would
 	 * oops if assigned before initialising the rest.
 	 */
@@ -138,22 +129,16 @@ void ieee80211_if_set_type(struct net_de
 
 	switch (type) {
 	case IEEE80211_IF_TYPE_WDS:
-		/* nothing special */
-		break;
 	case IEEE80211_IF_TYPE_VLAN:
-		sdata->u.vlan.ap = NULL;
+		/* nothing special */
 		break;
 	case IEEE80211_IF_TYPE_AP:
-		sdata->u.ap.force_unicast_rateidx = -1;
-		sdata->u.ap.max_ratectrl_rateidx = -1;
 		skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
-		sdata->bss = &sdata->u.ap;
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
 		break;
 	case IEEE80211_IF_TYPE_MESH_POINT:
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS: {
-		struct ieee80211_sub_if_data *msdata;
 		struct ieee80211_if_sta *ifsta;
 
 		ifsta = &sdata->u.sta;
@@ -171,9 +156,6 @@ void ieee80211_if_set_type(struct net_de
 		if (ieee80211_num_regular_queues(&sdata->local->hw) >= 4)
 			ifsta->flags |= IEEE80211_STA_WMM_ENABLED;
 
-		msdata = IEEE80211_DEV_TO_SUB_IF(sdata->local->mdev);
-		sdata->bss = &msdata->u.ap;
-
 		if (ieee80211_vif_is_mesh(&sdata->vif))
 			ieee80211_mesh_init_sdata(sdata);
 		break;
@@ -215,27 +197,8 @@ void ieee80211_if_reinit(struct net_devi
 		WARN_ON(1);
 		break;
 	case IEEE80211_IF_TYPE_AP: {
-		/* Remove all virtual interfaces that use this BSS
-		 * as their sdata->bss */
-		struct ieee80211_sub_if_data *tsdata, *n;
 		struct beacon_data *beacon;
 
-		list_for_each_entry_safe(tsdata, n, &local->interfaces, list) {
-			if (tsdata != sdata && tsdata->bss == &sdata->u.ap) {
-				printk(KERN_DEBUG "%s: removing virtual "
-				       "interface %s because its BSS interface"
-				       " is being removed\n",
-				       sdata->dev->name, tsdata->dev->name);
-				list_del_rcu(&tsdata->list);
-				/*
-				 * We have lots of time and can afford
-				 * to sync for each interface
-				 */
-				synchronize_rcu();
-				__ieee80211_if_del(local, tsdata);
-			}
-		}
-
 		beacon = sdata->u.ap.beacon;
 		rcu_assign_pointer(sdata->u.ap.beacon, NULL);
 		synchronize_rcu();
@@ -249,6 +212,7 @@ void ieee80211_if_reinit(struct net_devi
 		break;
 	}
 	case IEEE80211_IF_TYPE_WDS:
+	case IEEE80211_IF_TYPE_VLAN:
 		/* nothing to do */
 		break;
 	case IEEE80211_IF_TYPE_MESH_POINT:
@@ -269,9 +233,6 @@ void ieee80211_if_reinit(struct net_devi
 	case IEEE80211_IF_TYPE_MNTR:
 		dev->type = ARPHRD_ETHER;
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
-		sdata->u.vlan.ap = NULL;
-		break;
 	}
 
 	flushed = sta_info_flush(local, sdata);
@@ -289,8 +250,10 @@ void __ieee80211_if_del(struct ieee80211
 
 	ieee80211_debugfs_remove_netdev(sdata);
 	unregister_netdevice(dev);
-	/* Except master interface, the net_device will be freed by
-	 * net_device->destructor (i. e. ieee80211_if_free). */
+	/*
+	 * The net_device will be freed by its destructor,
+	 * i.e. ieee80211_if_free.
+	 */
 }
 
 /* Must be called with rtnl lock held. */
@@ -303,8 +266,7 @@ int ieee80211_if_remove(struct net_devic
 
 	list_for_each_entry_safe(sdata, n, &local->interfaces, list) {
 		if ((sdata->vif.type == id || id == -1) &&
-		    strcmp(name, sdata->dev->name) == 0 &&
-		    sdata->dev != local->mdev) {
+		    strcmp(name, sdata->dev->name) == 0) {
 			list_del_rcu(&sdata->list);
 			synchronize_rcu();
 			__ieee80211_if_del(local, sdata);
--- everything.orig/net/mac80211/main.c	2008-07-05 04:06:01.000000000 +0200
+++ everything/net/mac80211/main.c	2008-07-05 04:07:23.000000000 +0200
@@ -105,7 +105,7 @@ static int ieee80211_master_open(struct 
 
 	/* we hold the RTNL here so can safely walk the list */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (sdata->dev != dev && netif_running(sdata->dev)) {
+		if (netif_running(sdata->dev)) {
 			res = 0;
 			break;
 		}
@@ -126,7 +126,7 @@ static int ieee80211_master_stop(struct 
 
 	/* we hold the RTNL here so can safely walk the list */
 	list_for_each_entry(sdata, &local->interfaces, list)
-		if (sdata->dev != dev && netif_running(sdata->dev))
+		if (netif_running(sdata->dev))
 			dev_close(sdata->dev);
 
 	return 0;
@@ -193,7 +193,7 @@ static int ieee80211_open(struct net_dev
 	list_for_each_entry(nsdata, &local->interfaces, list) {
 		struct net_device *ndev = nsdata->dev;
 
-		if (ndev != dev && ndev != local->mdev && netif_running(ndev)) {
+		if (ndev != dev && netif_running(ndev)) {
 			/*
 			 * Allow only a single IBSS interface to be up at any
 			 * time. This is restricted because beacon distribution
@@ -209,30 +209,6 @@ static int ieee80211_open(struct net_dev
 				return -EBUSY;
 
 			/*
-			 * Disallow multiple IBSS/STA mode interfaces.
-			 *
-			 * This is a technical restriction, it is possible although
-			 * most likely not IEEE 802.11 compliant to have multiple
-			 * STAs with just a single hardware (the TSF timer will not
-			 * be adjusted properly.)
-			 *
-			 * However, because mac80211 uses the master device's BSS
-			 * information for each STA/IBSS interface, doing this will
-			 * currently corrupt that BSS information completely, unless,
-			 * a not very useful case, both STAs are associated to the
-			 * same BSS.
-			 *
-			 * To remove this restriction, the BSS information needs to
-			 * be embedded in the STA/IBSS mode sdata instead of using
-			 * the master device's BSS structure.
-			 */
-			if ((sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-			     sdata->vif.type == IEEE80211_IF_TYPE_IBSS) &&
-			    (nsdata->vif.type == IEEE80211_IF_TYPE_STA ||
-			     nsdata->vif.type == IEEE80211_IF_TYPE_IBSS))
-				return -EBUSY;
-
-			/*
 			 * The remaining checks are only performed for interfaces
 			 * with the same MAC address.
 			 */
@@ -251,7 +227,7 @@ static int ieee80211_open(struct net_dev
 			 */
 			if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN &&
 			    nsdata->vif.type == IEEE80211_IF_TYPE_AP)
-				sdata->u.vlan.ap = nsdata;
+				sdata->bss = &nsdata->u.ap;
 		}
 	}
 
@@ -261,10 +237,13 @@ static int ieee80211_open(struct net_dev
 			return -ENOLINK;
 		break;
 	case IEEE80211_IF_TYPE_VLAN:
-		if (!sdata->u.vlan.ap)
+		if (!sdata->bss)
 			return -ENOLINK;
+		list_add(&sdata->u.vlan.list, &sdata->bss->vlans);
 		break;
 	case IEEE80211_IF_TYPE_AP:
+		sdata->bss = &sdata->u.ap;
+		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_MNTR:
 	case IEEE80211_IF_TYPE_IBSS:
@@ -282,14 +261,13 @@ static int ieee80211_open(struct net_dev
 		if (local->ops->start)
 			res = local->ops->start(local_to_hw(local));
 		if (res)
-			return res;
+			goto err_del_bss;
 		need_hw_reconfig = 1;
 		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
 	}
 
 	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_VLAN:
-		list_add(&sdata->u.vlan.list, &sdata->u.vlan.ap->u.ap.vlans);
 		/* no need to tell driver */
 		break;
 	case IEEE80211_IF_TYPE_MNTR:
@@ -402,6 +380,10 @@ static int ieee80211_open(struct net_dev
  err_stop:
 	if (!local->open_count && local->ops->stop)
 		local->ops->stop(local_to_hw(local));
+ err_del_bss:
+	sdata->bss = NULL;
+	if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
+		list_del(&sdata->u.vlan.list);
 	return res;
 }
 
@@ -484,7 +466,6 @@ static int ieee80211_stop(struct net_dev
 	switch (sdata->vif.type) {
 	case IEEE80211_IF_TYPE_VLAN:
 		list_del(&sdata->u.vlan.list);
-		sdata->u.vlan.ap = NULL;
 		/* no need to tell driver */
 		break;
 	case IEEE80211_IF_TYPE_MNTR:
@@ -549,6 +530,8 @@ static int ieee80211_stop(struct net_dev
 		local->ops->remove_interface(local_to_hw(local), &conf);
 	}
 
+	sdata->bss = NULL;
+
 	if (local->open_count == 0) {
 		if (netif_running(local->mdev))
 			dev_close(local->mdev);
@@ -1655,7 +1638,7 @@ int ieee80211_register_hw(struct ieee802
 	int result;
 	enum ieee80211_band band;
 	struct net_device *mdev;
-	struct ieee80211_sub_if_data *sdata;
+	struct wireless_dev *mwdev;
 
 	/*
 	 * generic code guarantees at least one band,
@@ -1695,8 +1678,7 @@ int ieee80211_register_hw(struct ieee802
 	hw->ampdu_queues = 0;
 #endif
 
-	/* for now, mdev needs sub_if_data :/ */
-	mdev = alloc_netdev_mq(sizeof(struct ieee80211_sub_if_data),
+	mdev = alloc_netdev_mq(sizeof(struct wireless_dev),
 			       "wmaster%d", ether_setup,
 			       ieee80211_num_queues(hw));
 	if (!mdev)
@@ -1705,13 +1687,13 @@ int ieee80211_register_hw(struct ieee802
 	if (ieee80211_num_queues(hw) > 1)
 		mdev->features |= NETIF_F_MULTI_QUEUE;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(mdev);
-	mdev->ieee80211_ptr = &sdata->wdev;
-	sdata->wdev.wiphy = local->hw.wiphy;
+	mwdev = netdev_priv(mdev);
+	mdev->ieee80211_ptr = mwdev;
+	mwdev->wiphy = local->hw.wiphy;
 
 	local->mdev = mdev;
 
-	ieee80211_rx_bss_list_init(mdev);
+	ieee80211_rx_bss_list_init(local);
 
 	mdev->hard_start_xmit = ieee80211_master_start_xmit;
 	mdev->open = ieee80211_master_open;
@@ -1720,16 +1702,6 @@ int ieee80211_register_hw(struct ieee802
 	mdev->header_ops = &ieee80211_header_ops;
 	mdev->set_multicast_list = ieee80211_master_set_multicast_list;
 
-	sdata->vif.type = IEEE80211_IF_TYPE_AP;
-	sdata->dev = mdev;
-	sdata->local = local;
-	sdata->u.ap.force_unicast_rateidx = -1;
-	sdata->u.ap.max_ratectrl_rateidx = -1;
-	ieee80211_if_sdata_init(sdata);
-
-	/* no RCU needed since we're still during init phase */
-	list_add_tail(&sdata->list, &local->interfaces);
-
 	name = wiphy_dev(local->hw.wiphy)->driver->name;
 	local->hw.workqueue = create_freezeable_workqueue(name);
 	if (!local->hw.workqueue) {
@@ -1775,9 +1747,6 @@ int ieee80211_register_hw(struct ieee802
 	if (result < 0)
 		goto fail_dev;
 
-	ieee80211_debugfs_add_netdev(IEEE80211_DEV_TO_SUB_IF(local->mdev));
-	ieee80211_if_set_type(local->mdev, IEEE80211_IF_TYPE_AP);
-
 	result = ieee80211_init_rate_ctrl_alg(local,
 					      hw->rate_control_algorithm);
 	if (result < 0) {
@@ -1797,7 +1766,7 @@ int ieee80211_register_hw(struct ieee802
 	ieee80211_install_qdisc(local->mdev);
 
 	/* add one default STA interface */
-	result = ieee80211_if_add(local->mdev, "wlan%d", NULL,
+	result = ieee80211_if_add(local, "wlan%d", NULL,
 				  IEEE80211_IF_TYPE_STA, NULL);
 	if (result)
 		printk(KERN_WARNING "%s: Failed to add default virtual iface\n",
@@ -1813,7 +1782,6 @@ int ieee80211_register_hw(struct ieee802
 fail_wep:
 	rate_control_deinitialize(local);
 fail_rate:
-	ieee80211_debugfs_remove_netdev(IEEE80211_DEV_TO_SUB_IF(local->mdev));
 	unregister_netdevice(local->mdev);
 	local->mdev = NULL;
 fail_dev:
@@ -1823,10 +1791,8 @@ fail_sta_info:
 	debugfs_hw_del(local);
 	destroy_workqueue(local->hw.workqueue);
 fail_workqueue:
-	if (local->mdev != NULL) {
-		ieee80211_if_free(local->mdev);
-		local->mdev = NULL;
-	}
+	if (local->mdev)
+		free_netdev(local->mdev);
 fail_mdev_alloc:
 	wiphy_unregister(local->hw.wiphy);
 	return result;
@@ -1854,24 +1820,19 @@ void ieee80211_unregister_hw(struct ieee
 	 */
 
 	/*
-	 * First, we remove all non-master interfaces. Do this because they
-	 * may have bss pointer dependency on the master, and when we free
-	 * the master these would be freed as well, breaking our list
-	 * iteration completely.
+	 * First, we remove all virtual interfaces.
 	 */
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
-		if (sdata->dev == local->mdev)
-			continue;
 		list_del(&sdata->list);
 		__ieee80211_if_del(local, sdata);
 	}
 
 	/* then, finally, remove the master interface */
-	__ieee80211_if_del(local, IEEE80211_DEV_TO_SUB_IF(local->mdev));
+	unregister_netdevice(local->mdev);
 
 	rtnl_unlock();
 
-	ieee80211_rx_bss_list_deinit(local->mdev);
+	ieee80211_rx_bss_list_deinit(local);
 	ieee80211_clear_tx_pending(local);
 	sta_info_stop(local);
 	rate_control_deinitialize(local);
@@ -1888,8 +1849,7 @@ void ieee80211_unregister_hw(struct ieee
 	wiphy_unregister(local->hw.wiphy);
 	ieee80211_wep_free(local);
 	ieee80211_led_exit(local);
-	ieee80211_if_free(local->mdev);
-	local->mdev = NULL;
+	free_netdev(local->mdev);
 }
 EXPORT_SYMBOL(ieee80211_unregister_hw);
 
--- everything.orig/net/mac80211/rx.c	2008-07-05 04:06:00.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-07-05 04:07:23.000000000 +0200
@@ -649,8 +649,7 @@ static void ap_sta_ps_start(struct net_d
 
 	sdata = sta->sdata;
 
-	if (sdata->bss)
-		atomic_inc(&sdata->bss->num_sta_ps);
+	atomic_inc(&sdata->bss->num_sta_ps);
 	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
@@ -669,8 +668,7 @@ static int ap_sta_ps_end(struct net_devi
 
 	sdata = sta->sdata;
 
-	if (sdata->bss)
-		atomic_dec(&sdata->bss->num_sta_ps);
+	atomic_dec(&sdata->bss->num_sta_ps);
 
 	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
 
@@ -744,7 +742,9 @@ ieee80211_rx_h_sta_process(struct ieee80
 	sta->last_qual = rx->status->qual;
 	sta->last_noise = rx->status->noise;
 
-	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
+	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS) &&
+	    (rx->sdata->vif.type == IEEE80211_IF_TYPE_AP ||
+	     rx->sdata->vif.type == IEEE80211_IF_TYPE_VLAN)) {
 		/* Change STA power saving mode only in the end of a frame
 		 * exchange sequence */
 		if (test_sta_flags(sta, WLAN_STA_PS) &&
@@ -1776,11 +1776,6 @@ static int prepare_for_handlers(struct i
 				return 0;
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		}
-		if (sdata->dev == sdata->local->mdev &&
-		    !(rx->flags & IEEE80211_RX_IN_SCAN))
-			/* do not receive anything via
-			 * master device when not scanning */
-			return 0;
 		break;
 	case IEEE80211_IF_TYPE_WDS:
 		if (bssid ||
--- everything.orig/net/mac80211/sta_info.c	2008-07-05 04:05:59.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-07-05 04:06:02.000000000 +0200
@@ -319,7 +319,9 @@ int sta_info_insert(struct sta_info *sta
 	/* notify driver */
 	if (local->ops->sta_notify) {
 		if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
-			sdata = sdata->u.vlan.ap;
+			sdata = container_of(sdata->bss,
+					     struct ieee80211_sub_if_data,
+					     u.ap);
 
 		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
 				       STA_NOTIFY_ADD, sta->addr);
@@ -374,8 +376,10 @@ static inline void __bss_tim_clear(struc
 static void __sta_info_set_tim_bit(struct ieee80211_if_ap *bss,
 				   struct sta_info *sta)
 {
-	if (bss)
-		__bss_tim_set(bss, sta->aid);
+	BUG_ON(!bss);
+
+	__bss_tim_set(bss, sta->aid);
+
 	if (sta->local->ops->set_tim) {
 		sta->local->tim_in_locked_section = true;
 		sta->local->ops->set_tim(local_to_hw(sta->local), sta->aid, 1);
@@ -387,6 +391,8 @@ void sta_info_set_tim_bit(struct sta_inf
 {
 	unsigned long flags;
 
+	BUG_ON(!sta->sdata->bss);
+
 	spin_lock_irqsave(&sta->local->sta_lock, flags);
 	__sta_info_set_tim_bit(sta->sdata->bss, sta);
 	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
@@ -395,8 +401,10 @@ void sta_info_set_tim_bit(struct sta_inf
 static void __sta_info_clear_tim_bit(struct ieee80211_if_ap *bss,
 				     struct sta_info *sta)
 {
-	if (bss)
-		__bss_tim_clear(bss, sta->aid);
+	BUG_ON(!bss);
+
+	__bss_tim_clear(bss, sta->aid);
+
 	if (sta->local->ops->set_tim) {
 		sta->local->tim_in_locked_section = true;
 		sta->local->ops->set_tim(local_to_hw(sta->local), sta->aid, 0);
@@ -408,6 +416,8 @@ void sta_info_clear_tim_bit(struct sta_i
 {
 	unsigned long flags;
 
+	BUG_ON(!sta->sdata->bss);
+
 	spin_lock_irqsave(&sta->local->sta_lock, flags);
 	__sta_info_clear_tim_bit(sta->sdata->bss, sta);
 	spin_unlock_irqrestore(&sta->local->sta_lock, flags);
@@ -436,8 +446,9 @@ void __sta_info_unlink(struct sta_info *
 	list_del(&(*sta)->list);
 
 	if (test_and_clear_sta_flags(*sta, WLAN_STA_PS)) {
-		if (sdata->bss)
-			atomic_dec(&sdata->bss->num_sta_ps);
+		BUG_ON(!sdata->bss);
+
+		atomic_dec(&sdata->bss->num_sta_ps);
 		__sta_info_clear_tim_bit(sdata->bss, *sta);
 	}
 
@@ -445,7 +456,9 @@ void __sta_info_unlink(struct sta_info *
 
 	if (local->ops->sta_notify) {
 		if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
-			sdata = sdata->u.vlan.ap;
+			sdata = container_of(sdata->bss,
+					     struct ieee80211_sub_if_data,
+					     u.ap);
 
 		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
 				       STA_NOTIFY_REMOVE, (*sta)->addr);
--- everything.orig/net/mac80211/tx.c	2008-07-05 04:05:59.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-07-05 04:06:02.000000000 +0200
@@ -303,8 +303,7 @@ static void purge_old_ps_buffers(struct 
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		struct ieee80211_if_ap *ap;
-		if (sdata->dev == local->mdev ||
-		    sdata->vif.type != IEEE80211_IF_TYPE_AP)
+		if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
 			continue;
 		ap = &sdata->u.ap;
 		skb = skb_dequeue(&ap->ps_bc_buf);
@@ -346,8 +345,12 @@ ieee80211_tx_h_multicast_ps_buf(struct i
 	 * This is done either by the hardware or us.
 	 */
 
-	/* not AP/IBSS or ordered frame */
-	if (!tx->sdata->bss || (tx->fc & IEEE80211_FCTL_ORDER))
+	/* powersaving STAs only in AP/VLAN mode */
+	if (!tx->sdata->bss)
+		return TX_CONTINUE;
+
+	/* no buffering for ordered frames */
+	if (tx->fc & IEEE80211_FCTL_ORDER)
 		return TX_CONTINUE;
 
 	/* no stations in PS mode */
--- everything.orig/net/mac80211/wext.c	2008-07-05 04:05:58.000000000 +0200
+++ everything/net/mac80211/wext.c	2008-07-05 04:06:02.000000000 +0200
@@ -627,16 +627,14 @@ static int ieee80211_ioctl_siwrate(struc
 	struct ieee80211_supported_band *sband;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (!sdata->bss)
-		return -ENODEV;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	/* target_rate = -1, rate->fixed = 0 means auto only, so use all rates
 	 * target_rate = X, rate->fixed = 1 means only rate X
 	 * target_rate = X, rate->fixed = 0 means all rates <= X */
-	sdata->bss->max_ratectrl_rateidx = -1;
-	sdata->bss->force_unicast_rateidx = -1;
+	sdata->max_ratectrl_rateidx = -1;
+	sdata->force_unicast_rateidx = -1;
 	if (rate->value < 0)
 		return 0;
 
@@ -645,9 +643,9 @@ static int ieee80211_ioctl_siwrate(struc
 		int this_rate = brate->bitrate;
 
 		if (target_rate == this_rate) {
-			sdata->bss->max_ratectrl_rateidx = i;
+			sdata->max_ratectrl_rateidx = i;
 			if (rate->fixed)
-				sdata->bss->force_unicast_rateidx = i;
+				sdata->force_unicast_rateidx = i;
 			err = 0;
 			break;
 		}
--- everything.orig/net/mac80211/debugfs_netdev.c	2008-07-05 04:05:59.000000000 +0200
+++ everything/net/mac80211/debugfs_netdev.c	2008-07-05 04:06:02.000000000 +0200
@@ -156,6 +156,8 @@ static const struct file_operations name
 
 /* common attributes */
 IEEE80211_IF_FILE(drop_unencrypted, drop_unencrypted, DEC);
+IEEE80211_IF_FILE(force_unicast_rateidx, force_unicast_rateidx, DEC);
+IEEE80211_IF_FILE(max_ratectrl_rateidx, max_ratectrl_rateidx, DEC);
 
 /* STA/IBSS attributes */
 IEEE80211_IF_FILE(state, u.sta.state, DEC);
@@ -191,8 +193,6 @@ __IEEE80211_IF_FILE(flags);
 IEEE80211_IF_FILE(num_sta_ps, u.ap.num_sta_ps, ATOMIC);
 IEEE80211_IF_FILE(dtim_count, u.ap.dtim_count, DEC);
 IEEE80211_IF_FILE(num_beacons, u.ap.num_beacons, DEC);
-IEEE80211_IF_FILE(force_unicast_rateidx, u.ap.force_unicast_rateidx, DEC);
-IEEE80211_IF_FILE(max_ratectrl_rateidx, u.ap.max_ratectrl_rateidx, DEC);
 
 static ssize_t ieee80211_if_fmt_num_buffered_multicast(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
@@ -248,6 +248,9 @@ IEEE80211_IF_WFILE(min_discovery_timeout
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted, sta);
+	DEBUGFS_ADD(force_unicast_rateidx, ap);
+	DEBUGFS_ADD(max_ratectrl_rateidx, ap);
+
 	DEBUGFS_ADD(state, sta);
 	DEBUGFS_ADD(bssid, sta);
 	DEBUGFS_ADD(prev_bssid, sta);
@@ -268,23 +271,29 @@ static void add_sta_files(struct ieee802
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted, ap);
+	DEBUGFS_ADD(force_unicast_rateidx, ap);
+	DEBUGFS_ADD(max_ratectrl_rateidx, ap);
+
 	DEBUGFS_ADD(num_sta_ps, ap);
 	DEBUGFS_ADD(dtim_count, ap);
 	DEBUGFS_ADD(num_beacons, ap);
-	DEBUGFS_ADD(force_unicast_rateidx, ap);
-	DEBUGFS_ADD(max_ratectrl_rateidx, ap);
 	DEBUGFS_ADD(num_buffered_multicast, ap);
 }
 
 static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted, wds);
+	DEBUGFS_ADD(force_unicast_rateidx, ap);
+	DEBUGFS_ADD(max_ratectrl_rateidx, ap);
+
 	DEBUGFS_ADD(peer, wds);
 }
 
 static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted, vlan);
+	DEBUGFS_ADD(force_unicast_rateidx, ap);
+	DEBUGFS_ADD(max_ratectrl_rateidx, ap);
 }
 
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
@@ -372,6 +381,9 @@ static void add_files(struct ieee80211_s
 static void del_sta_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_DEL(drop_unencrypted, sta);
+	DEBUGFS_DEL(force_unicast_rateidx, ap);
+	DEBUGFS_DEL(max_ratectrl_rateidx, ap);
+
 	DEBUGFS_DEL(state, sta);
 	DEBUGFS_DEL(bssid, sta);
 	DEBUGFS_DEL(prev_bssid, sta);
@@ -392,23 +404,29 @@ static void del_sta_files(struct ieee802
 static void del_ap_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_DEL(drop_unencrypted, ap);
+	DEBUGFS_DEL(force_unicast_rateidx, ap);
+	DEBUGFS_DEL(max_ratectrl_rateidx, ap);
+
 	DEBUGFS_DEL(num_sta_ps, ap);
 	DEBUGFS_DEL(dtim_count, ap);
 	DEBUGFS_DEL(num_beacons, ap);
-	DEBUGFS_DEL(force_unicast_rateidx, ap);
-	DEBUGFS_DEL(max_ratectrl_rateidx, ap);
 	DEBUGFS_DEL(num_buffered_multicast, ap);
 }
 
 static void del_wds_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_DEL(drop_unencrypted, wds);
+	DEBUGFS_DEL(force_unicast_rateidx, ap);
+	DEBUGFS_DEL(max_ratectrl_rateidx, ap);
+
 	DEBUGFS_DEL(peer, wds);
 }
 
 static void del_vlan_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_DEL(drop_unencrypted, vlan);
+	DEBUGFS_DEL(force_unicast_rateidx, ap);
+	DEBUGFS_DEL(max_ratectrl_rateidx, ap);
 }
 
 static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
@@ -525,7 +543,7 @@ static int netdev_notify(struct notifier
 {
 	struct net_device *dev = ndev;
 	struct dentry *dir;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata;
 	char buf[10+IFNAMSIZ];
 
 	if (state != NETDEV_CHANGENAME)
@@ -537,6 +555,8 @@ static int netdev_notify(struct notifier
 	if (dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
 		return 0;
 
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	sprintf(buf, "netdev:%s", dev->name);
 	dir = sdata->debugfsdir;
 	if (!debugfs_rename(dir->d_parent, dir, dir->d_parent, buf))
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-07-05 04:05:59.000000000 +0200
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-07-05 04:06:02.000000000 +0200
@@ -259,8 +259,8 @@ static void rate_control_pid_tx_status(v
 
 	/* Don't update the state if we're not controlling the rate. */
 	sdata = sta->sdata;
-	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
-		sta->txrate_idx = sdata->bss->max_ratectrl_rateidx;
+	if (sdata->force_unicast_rateidx > -1) {
+		sta->txrate_idx = sdata->max_ratectrl_rateidx;
 		goto unlock;
 	}
 
@@ -337,8 +337,8 @@ static void rate_control_pid_get_rate(vo
 
 	/* If a forced rate is in effect, select it. */
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
-		sta->txrate_idx = sdata->bss->force_unicast_rateidx;
+	if (sdata->force_unicast_rateidx > -1)
+		sta->txrate_idx = sdata->force_unicast_rateidx;
 
 	rateidx = sta->txrate_idx;
 
--- everything.orig/net/mac80211/cfg.c	2008-07-05 04:05:59.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-07-05 04:06:02.000000000 +0200
@@ -57,7 +57,7 @@ static int ieee80211_add_iface(struct wi
 	if (itype == IEEE80211_IF_TYPE_INVALID)
 		return -EINVAL;
 
-	err = ieee80211_if_add(local->mdev, name, &dev, itype, params);
+	err = ieee80211_if_add(local, name, &dev, itype, params);
 	if (err || itype != IEEE80211_IF_TYPE_MNTR || !flags)
 		return err;
 
--- everything.orig/net/mac80211/mlme.c	2008-07-05 04:05:59.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-07-05 04:06:02.000000000 +0200
@@ -78,7 +78,7 @@ static void ieee80211_send_probe_req(str
 static struct ieee80211_sta_bss *
 ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len);
-static void ieee80211_rx_bss_put(struct net_device *dev,
+static void ieee80211_rx_bss_put(struct ieee80211_local *local,
 				 struct ieee80211_sta_bss *bss);
 static int ieee80211_sta_find_ibss(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta);
@@ -554,7 +554,7 @@ static void ieee80211_set_associated(str
 
 			changed |= ieee80211_handle_bss_capability(sdata, bss);
 
-			ieee80211_rx_bss_put(dev, bss);
+			ieee80211_rx_bss_put(local, bss);
 		}
 
 		if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
@@ -757,7 +757,7 @@ static void ieee80211_send_assoc(struct 
 		    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
 			capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
 
-		ieee80211_rx_bss_put(dev, bss);
+		ieee80211_rx_bss_put(local, bss);
 	} else {
 		rates = ~0;
 		rates_len = sband->n_bitrates;
@@ -989,7 +989,7 @@ static int ieee80211_privacy_mismatch(st
 	wep_privacy = !!ieee80211_sta_wep_configured(dev);
 	privacy_invoked = !!(ifsta->flags & IEEE80211_STA_PRIVACY_INVOKED);
 
-	ieee80211_rx_bss_put(dev, bss);
+	ieee80211_rx_bss_put(local, bss);
 
 	if ((bss_privacy == wep_privacy) || (bss_privacy == privacy_invoked))
 		return 0;
@@ -2091,7 +2091,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 			sta->last_signal = bss->signal;
 			sta->last_qual = bss->qual;
 			sta->last_noise = bss->noise;
-			ieee80211_rx_bss_put(dev, bss);
+			ieee80211_rx_bss_put(local, bss);
 		}
 
 		err = sta_info_insert(sta);
@@ -2209,10 +2209,9 @@ static void __ieee80211_rx_bss_hash_add(
 
 
 /* Caller must hold local->sta_bss_lock */
-static void __ieee80211_rx_bss_hash_del(struct net_device *dev,
+static void __ieee80211_rx_bss_hash_del(struct ieee80211_local *local,
 					struct ieee80211_sta_bss *bss)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *b, *prev = NULL;
 	b = local->sta_bss_hash[STA_HASH(bss->bssid)];
 	while (b) {
@@ -2364,39 +2363,35 @@ static void ieee80211_rx_bss_free(struct
 }
 
 
-static void ieee80211_rx_bss_put(struct net_device *dev,
+static void ieee80211_rx_bss_put(struct ieee80211_local *local,
 				 struct ieee80211_sta_bss *bss)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
 	local_bh_disable();
 	if (!atomic_dec_and_lock(&bss->users, &local->sta_bss_lock)) {
 		local_bh_enable();
 		return;
 	}
 
-	__ieee80211_rx_bss_hash_del(dev, bss);
+	__ieee80211_rx_bss_hash_del(local, bss);
 	list_del(&bss->list);
 	spin_unlock_bh(&local->sta_bss_lock);
 	ieee80211_rx_bss_free(bss);
 }
 
 
-void ieee80211_rx_bss_list_init(struct net_device *dev)
+void ieee80211_rx_bss_list_init(struct ieee80211_local *local)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	spin_lock_init(&local->sta_bss_lock);
 	INIT_LIST_HEAD(&local->sta_bss_list);
 }
 
 
-void ieee80211_rx_bss_list_deinit(struct net_device *dev)
+void ieee80211_rx_bss_list_deinit(struct ieee80211_local *local)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss, *tmp;
 
 	list_for_each_entry_safe(bss, tmp, &local->sta_bss_list, list)
-		ieee80211_rx_bss_put(dev, bss);
+		ieee80211_rx_bss_put(local, bss);
 }
 
 
@@ -2772,7 +2767,7 @@ static void ieee80211_rx_bss_info(struct
 	 */
 	if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
 	    bss->probe_resp && beacon) {
-		ieee80211_rx_bss_put(dev, bss);
+		ieee80211_rx_bss_put(local, bss);
 		return;
 	}
 
@@ -2915,7 +2910,7 @@ static void ieee80211_rx_bss_info(struct
 		}
 	}
 
-	ieee80211_rx_bss_put(dev, bss);
+	ieee80211_rx_bss_put(local, bss);
 }
 
 
@@ -3575,7 +3570,7 @@ static int ieee80211_sta_config_auth(str
 					       selected->ssid_len);
 		ieee80211_sta_set_bssid(dev, selected->bssid);
 		ieee80211_sta_def_wmm_params(dev, selected, 0);
-		ieee80211_rx_bss_put(dev, selected);
+		ieee80211_rx_bss_put(local, selected);
 		ifsta->state = IEEE80211_AUTHENTICATE;
 		ieee80211_sta_reset_auth(dev, ifsta);
 		return 0;
@@ -3652,7 +3647,7 @@ static int ieee80211_sta_create_ibss(str
 	}
 
 	ret = ieee80211_sta_join_ibss(dev, ifsta, bss);
-	ieee80211_rx_bss_put(dev, bss);
+	ieee80211_rx_bss_put(local, bss);
 	return ret;
 }
 
@@ -3706,7 +3701,7 @@ static int ieee80211_sta_find_ibss(struc
 		       " based on configured SSID\n",
 		       dev->name, print_mac(mac, bssid));
 		ret = ieee80211_sta_join_ibss(dev, ifsta, bss);
-		ieee80211_rx_bss_put(dev, bss);
+		ieee80211_rx_bss_put(local, bss);
 		return ret;
 	}
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
@@ -3902,11 +3897,6 @@ void ieee80211_scan_completed(struct iee
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-
-		/* No need to wake the master device. */
-		if (sdata->dev == local->mdev)
-			continue;
-
 		/* Tell AP we're back */
 		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
 		    sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
@@ -4072,12 +4062,6 @@ static int ieee80211_sta_start_scan(stru
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-
-		/* Don't stop the master interface, otherwise we can't transmit
-		 * probes! */
-		if (sdata->dev == local->mdev)
-			continue;
-
 		netif_stop_queue(sdata->dev);
 		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
 		    (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED))
@@ -4468,12 +4452,10 @@ void ieee80211_notify_mac(struct ieee802
 	case IEEE80211_NOTIFY_RE_ASSOC:
 		rcu_read_lock();
 		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+			if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
+				continue;
 
-			if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
-				ieee80211_sta_req_auth(sdata->dev,
-						       &sdata->u.sta);
-			}
-
+			ieee80211_sta_req_auth(sdata->dev, &sdata->u.sta);
 		}
 		rcu_read_unlock();
 		break;

-- 


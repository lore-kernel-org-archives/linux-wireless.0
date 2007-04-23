Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:23279 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161488AbXDWS6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:58:19 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 03/13] mac80211: fix virtual interface related locking
Date: Mon, 23 Apr 2007 14:48:13 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070423184812.7029.7682.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This converts sub_if_lock to a rw lock and makes all code touching
sub_if_list use it, grabs mdev's tx lock in set_multicast_list to
synchronize multicast configuration, and simplifies some related code.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c       |   52 +++++++++++++++++++---------
 net/mac80211/ieee80211_cfg.c   |   15 +++-----
 net/mac80211/ieee80211_i.h     |    7 +---
 net/mac80211/ieee80211_iface.c |   75 +++++++++++++++++-----------------------
 net/mac80211/ieee80211_ioctl.c |   62 ++++++++++++++++++---------------
 net/mac80211/ieee80211_sta.c   |   24 +++----------
 6 files changed, 113 insertions(+), 122 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 51ad624..bc89ac9 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -953,7 +953,7 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
-	spin_lock_bh(&local->sub_if_lock);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		struct ieee80211_if_ap *ap;
 		if (sdata->dev == local->mdev ||
@@ -967,7 +967,7 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 		}
 		total += skb_queue_len(&ap->ps_bc_buf);
 	}
-	spin_unlock_bh(&local->sub_if_lock);
+	read_unlock(&local->sub_if_lock);
 
 	spin_lock_bh(&local->sta_lock);
 	list_for_each_entry(sta, &local->sta_list, list) {
@@ -2148,6 +2148,7 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	unsigned short flags;
 
+	netif_tx_lock(local->mdev);
 	if (((dev->flags & IFF_ALLMULTI) != 0) ^ (sdata->allmulti != 0)) {
 		if (sdata->allmulti) {
 			sdata->allmulti = 0;
@@ -2177,9 +2178,12 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
 			flags |= IFF_ALLMULTI;
 		if (local->iff_promiscs)
 			flags |= IFF_PROMISC;
+		read_lock(&local->sub_if_lock);
 		local->ops->set_multicast_list(local_to_hw(local), flags,
 					      local->mc_count);
+		read_unlock(&local->sub_if_lock);
 	}
+	netif_tx_unlock(local->mdev);
 }
 
 struct dev_mc_list *ieee80211_get_mc_list_item(struct ieee80211_hw *hw,
@@ -2220,12 +2224,11 @@ static struct net_device_stats *ieee80211_get_stats(struct net_device *dev)
 	return &(sdata->stats);
 }
 
-void ieee80211_if_shutdown(struct net_device *dev)
+static void ieee80211_if_shutdown(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	ASSERT_RTNL();
 	switch (sdata->type) {
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
@@ -2269,6 +2272,7 @@ static int ieee80211_master_open(struct net_device *dev)
 	struct ieee80211_sub_if_data *sdata;
 	int res = -EOPNOTSUPP;
 
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		if (sdata->dev != dev && netif_running(sdata->dev)) {
 			res = 0;
@@ -2276,6 +2280,7 @@ static int ieee80211_master_open(struct net_device *dev)
 			break;
 		}
 	}
+	read_unlock(&local->sub_if_lock);
 	return res;
 }
 
@@ -2285,10 +2290,14 @@ static int ieee80211_master_stop(struct net_device *dev)
 	struct ieee80211_sub_if_data *sdata;
 
 	tasklet_disable(&local->tx_pending_tasklet);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
-		if (sdata->dev != dev && netif_running(sdata->dev))
+		if (sdata->dev != dev && netif_running(sdata->dev)) {
+			read_unlock(&local->sub_if_lock);
 			return -EOPNOTSUPP;
+		}
 	}
+	read_unlock(&local->sub_if_lock);
 	return 0;
 }
 
@@ -2346,14 +2355,18 @@ static int ieee80211_open(struct net_device *dev)
 	int res;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(nsdata, &local->sub_if_list, list) {
 		struct net_device *ndev = nsdata->dev;
 
 		if (ndev != dev && ndev != local->mdev && netif_running(ndev) &&
 		    compare_ether_addr(dev->dev_addr, ndev->dev_addr) == 0 &&
-		    !identical_mac_addr_allowed(sdata->type, nsdata->type))
+		    !identical_mac_addr_allowed(sdata->type, nsdata->type)) {
+			read_unlock(&local->sub_if_lock);
 			return -ENOTUNIQ;
+		}
 	}
+	read_unlock(&local->sub_if_lock);
 
 	if (sdata->type == IEEE80211_IF_TYPE_WDS &&
 	    is_zero_ether_addr(sdata->u.wds.remote_addr))
@@ -3871,6 +3884,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		struct sk_buff *skb_new;
 		u8 *bssid = ieee80211_get_bssid(hdr, skb->len - radiotap_len);
 
+		read_lock(&local->sub_if_lock);
 		list_for_each_entry(sdata, &local->sub_if_list, list) {
 			rx.u.rx.ra_match = 1;
 			switch (sdata->type) {
@@ -3906,10 +3920,9 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 					rx.u.rx.ra_match = 0;
 				} else if (!sta)
 					sta = rx.sta =
-						ieee80211_ibss_add_sta(local->mdev,
+						ieee80211_ibss_add_sta(sdata->dev,
 								       skb, bssid,
 								       hdr->addr2);
-						/* FIXME: call with sdata->dev */
 				break;
 			case IEEE80211_IF_TYPE_AP:
 				if (!bssid) {
@@ -3964,6 +3977,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 						     &rx, sta);
 		} else
 			dev_kfree_skb(skb);
+		read_unlock(&local->sub_if_lock);
 	}
 
   end:
@@ -4108,11 +4122,13 @@ static void ieee80211_stat_refresh(unsigned long data)
 	spin_unlock_bh(&local->sta_lock);
 
 	/* go through all subinterfaces */
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		sdata->channel_use = (sdata->channel_use_raw /
 				      local->stat_time) / CHAN_UTIL_PER_10MS;
 		sdata->channel_use_raw = 0;
 	}
+	read_unlock(&local->sub_if_lock);
 
 	/* hardware interface */
 	local->channel_use = (local->channel_use_raw /
@@ -4549,7 +4565,6 @@ int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 {
 	struct rate_control_ref *ref, *old;
 
-	ASSERT_RTNL();
 	if (local->open_count || netif_running(local->mdev) ||
 	    (local->apdev && netif_running(local->apdev)))
 		return -EBUSY;
@@ -4665,7 +4680,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	INIT_LIST_HEAD(&local->modes_list);
 
-	spin_lock_init(&local->sub_if_lock);
+	rwlock_init(&local->sub_if_lock);
 	INIT_LIST_HEAD(&local->sub_if_list);
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
@@ -4708,7 +4723,6 @@ EXPORT_SYMBOL(ieee80211_alloc_hw);
 int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct net_device *sta_dev;
 	int result;
 
 	result = wiphy_register(local->hw.wiphy);
@@ -4763,13 +4777,14 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_wep;
 	}
 
-	/* TODO: add rtnl locking around device creation and qdisc install */
 	ieee80211_install_qdisc(local->mdev);
 
 	/* add one default STA interface */
-	result = ieee80211_if_add(local->mdev, "wlan%d", 1, &sta_dev);
-	if (result == 0)
-		ieee80211_if_set_type(sta_dev, IEEE80211_IF_TYPE_STA);
+	result = ieee80211_if_add(local->mdev, "wlan%d", NULL,
+				  IEEE80211_IF_TYPE_STA);
+	if (result)
+		printk(KERN_WARNING "%s: Failed to add default virtual iface\n",
+		       local->mdev->name);
 
 	local->reg_state = IEEE80211_DEV_REGISTERED;
 	rtnl_unlock();
@@ -4829,6 +4844,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata, *tmp;
+	struct list_head tmp_list;
 	int i;
 
 	tasklet_kill(&local->tx_pending_tasklet);
@@ -4842,7 +4858,11 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	if (local->apdev)
 		ieee80211_if_del_mgmt(local);
 
-	list_for_each_entry_safe(sdata, tmp, &local->sub_if_list, list)
+	write_lock_bh(&local->sub_if_lock);
+	list_replace_init(&local->sub_if_list, &tmp_list);
+	write_unlock_bh(&local->sub_if_lock);
+
+	list_for_each_entry_safe(sdata, tmp, &tmp_list, list)
 		__ieee80211_if_del(local, sdata);
 
 	rtnl_unlock();
diff --git a/net/mac80211/ieee80211_cfg.c b/net/mac80211/ieee80211_cfg.c
index e370b4b..0069826 100644
--- a/net/mac80211/ieee80211_cfg.c
+++ b/net/mac80211/ieee80211_cfg.c
@@ -16,8 +16,7 @@ static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
 			       unsigned int type)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
-	struct net_device *new_dev;
-	int res, itype;
+	int itype;
 
 	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
 		return -ENODEV;
@@ -45,16 +44,12 @@ static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
 		return -EINVAL;
 	}
 
-	res = ieee80211_if_add(local->mdev, name, 0, &new_dev);
-	if (res == 0)
-		ieee80211_if_set_type(new_dev, itype);
-	return res;
+	return ieee80211_if_add(local->mdev, name, NULL, itype);
 }
 
 static int ieee80211_del_iface(struct wiphy *wiphy, int ifindex)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
-	int res;
 	struct net_device *dev;
 	char *name;
 
@@ -62,11 +57,13 @@ static int ieee80211_del_iface(struct wiphy *wiphy, int ifindex)
 		return -ENODEV;
 
 	dev = dev_get_by_index(ifindex);
+	if (!dev)
+		return 0;
+
 	name = dev->name;
 	dev_put(dev);
 
-	res = ieee80211_if_remove(local->mdev, name, -1);
-	return res;
+	return ieee80211_if_remove(local->mdev, name, -1);
 }
 
 struct cfg80211_ops mac80211_config_ops = {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f6d389b..6b3e1c5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -490,7 +490,7 @@ struct ieee80211_local {
 	ieee80211_rx_handler *rx_handlers;
 	ieee80211_tx_handler *tx_handlers;
 
-	spinlock_t sub_if_lock; /* mutex for STA data structures */
+	rwlock_t sub_if_lock; /* protects sub_if_list */
 	struct list_head sub_if_list;
 	int sta_scanning;
 	int scan_channel_idx;
@@ -753,7 +753,6 @@ void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx);
 int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr);
 void ieee80211_if_setup(struct net_device *dev);
 void ieee80211_if_mgmt_setup(struct net_device *dev);
-void ieee80211_if_shutdown(struct net_device *dev);
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 				 const char *name);
 struct net_device_stats *ieee80211_dev_stats(struct net_device *dev);
@@ -830,15 +829,13 @@ int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
 
 /* ieee80211_iface.c */
 int ieee80211_if_add(struct net_device *dev, const char *name,
-		     int format, struct net_device **new_dev);
+		     struct net_device **new_dev, int type);
 void ieee80211_if_set_type(struct net_device *dev, int type);
 void ieee80211_if_reinit(struct net_device *dev);
 void __ieee80211_if_del(struct ieee80211_local *local,
 			struct ieee80211_sub_if_data *sdata);
-void ieee80211_if_del(struct net_device *dev);
 int ieee80211_if_remove(struct net_device *dev, const char *name, int id);
 void ieee80211_if_free(struct net_device *dev);
-void ieee80211_if_flush(struct net_device *dev);
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata);
 int ieee80211_if_add_mgmt(struct ieee80211_local *local);
 void ieee80211_if_del_mgmt(struct ieee80211_local *local);
diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
index 495177b..719bc21 100644
--- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -38,7 +38,7 @@ static void ieee80211_if_sdata_deinit(struct ieee80211_sub_if_data *sdata)
 
 /* Must be called with rtnl lock held. */
 int ieee80211_if_add(struct net_device *dev, const char *name,
-		     int format, struct net_device **new_dev)
+		     struct net_device **new_dev, int type)
 {
 	struct net_device *ndev;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -46,22 +46,14 @@ int ieee80211_if_add(struct net_device *dev, const char *name,
 	int ret;
 
 	ASSERT_RTNL();
-	ndev = *new_dev = alloc_netdev(sizeof(struct ieee80211_sub_if_data),
-				       "", ieee80211_if_setup);
+	ndev = alloc_netdev(sizeof(struct ieee80211_sub_if_data),
+			    name, ieee80211_if_setup);
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
+	ret = dev_alloc_name(ndev, ndev->name);
+	if (ret < 0)
+		goto fail;
 
 	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	ndev->base_addr = dev->base_addr;
@@ -83,14 +75,25 @@ int ieee80211_if_add(struct net_device *dev, const char *name,
 		goto fail;
 
 	ieee80211_debugfs_add_netdev(sdata);
+	ieee80211_if_set_type(ndev, type);
+
+	write_lock_bh(&local->sub_if_lock);
+	if (unlikely(local->reg_state == IEEE80211_DEV_UNREGISTERED)) {
+		write_unlock_bh(&local->sub_if_lock);
+		__ieee80211_if_del(local, sdata);
+		return -ENODEV;
+	}
 	list_add(&sdata->list, &local->sub_if_list);
+	if (new_dev)
+		*new_dev = ndev;
+	write_unlock_bh(&local->sub_if_lock);
+
 	ieee80211_update_default_wep_only(local);
 
 	return 0;
 
 fail:
 	free_netdev(ndev);
-	*new_dev = NULL;
 	return ret;
 }
 
@@ -102,11 +105,11 @@ int ieee80211_if_add_mgmt(struct ieee80211_local *local)
 
 	ASSERT_RTNL();
 
-	ndev = alloc_netdev(sizeof(struct ieee80211_sub_if_data), "",
+	ndev = alloc_netdev(sizeof(struct ieee80211_sub_if_data), "wmgmt%d",
 			    ieee80211_if_mgmt_setup);
 	if (!ndev)
 		return -ENOMEM;
-	ret = dev_alloc_name(ndev, "wmgmt%d");
+	ret = dev_alloc_name(ndev, ndev->name);
 	if (ret < 0)
 		goto fail;
 
@@ -232,16 +235,22 @@ void ieee80211_if_reinit(struct net_device *dev)
 		/* Remove all virtual interfaces that use this BSS
 		 * as their sdata->bss */
 		struct ieee80211_sub_if_data *tsdata, *n;
+		LIST_HEAD(tmp_list);
 
+		write_lock_bh(&local->sub_if_lock);
 		list_for_each_entry_safe(tsdata, n, &local->sub_if_list, list) {
 			if (tsdata != sdata && tsdata->bss == &sdata->u.ap) {
 				printk(KERN_DEBUG "%s: removing virtual "
 				       "interface %s because its BSS interface"
 				       " is being removed\n",
 				       sdata->dev->name, tsdata->dev->name);
-				__ieee80211_if_del(local, tsdata);
+				list_move_tail(&tsdata->list, &tmp_list);
 			}
 		}
+		write_unlock_bh(&local->sub_if_lock);
+
+		list_for_each_entry_safe(tsdata, n, &tmp_list, list)
+			__ieee80211_if_del(local, tsdata);
 
 		kfree(sdata->u.ap.beacon_head);
 		kfree(sdata->u.ap.beacon_tail);
@@ -301,7 +310,6 @@ void __ieee80211_if_del(struct ieee80211_local *local,
 {
 	struct net_device *dev = sdata->dev;
 
-	list_del(&sdata->list);
 	ieee80211_debugfs_remove_netdev(sdata);
 	unregister_netdevice(dev);
 	/* Except master interface, the net_device will be freed by
@@ -316,15 +324,19 @@ int ieee80211_if_remove(struct net_device *dev, const char *name, int id)
 
 	ASSERT_RTNL();
 
+	write_lock_bh(&local->sub_if_lock);
 	list_for_each_entry_safe(sdata, n, &local->sub_if_list, list) {
 		if ((sdata->type == id || id == -1) &&
 		    strcmp(name, sdata->dev->name) == 0 &&
 		    sdata->dev != local->mdev) {
+			list_del(&sdata->list);
+			write_unlock_bh(&local->sub_if_lock);
 			__ieee80211_if_del(local, sdata);
 			ieee80211_update_default_wep_only(local);
 			return 0;
 		}
 	}
+	write_unlock_bh(&local->sub_if_lock);
 	return -ENODEV;
 }
 
@@ -338,28 +350,3 @@ void ieee80211_if_free(struct net_device *dev)
 	ieee80211_if_sdata_deinit(sdata);
 	free_netdev(dev);
 }
-
-/* Must be called with rtnl lock held. */
-void ieee80211_if_flush(struct net_device *dev)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata, *n;
-
-	ASSERT_RTNL();
-	list_for_each_entry_safe(sdata, n, &local->sub_if_list, list) {
-		__ieee80211_if_del(local, sdata);
-	}
-}
-
-void ieee80211_if_del(struct net_device *dev)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	rtnl_lock();
-	if (sdata->type == IEEE80211_IF_TYPE_MGMT)
-		ieee80211_if_del_mgmt(local);
-	else
-		__ieee80211_if_del(local, sdata);
-	rtnl_unlock();
-}
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 2ff762d..502010e 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -1003,23 +1003,30 @@ static int ieee80211_ioctl_add_if(struct net_device *dev,
 		if (left < sizeof(struct hostapd_if_wds))
 			return -EPROTO;
 
-		res = ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
+		res = ieee80211_if_add(dev, param->u.if_info.name, &new_dev,
+				       IEEE80211_IF_TYPE_WDS);
 		if (res)
 			return res;
-		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_WDS);
 		res = ieee80211_if_update_wds(new_dev, wds->remote_addr);
-		if (res)
-			__ieee80211_if_del(wdev_priv(dev->ieee80211_ptr),
-					   IEEE80211_DEV_TO_SUB_IF(new_dev));
+		if (unlikely(res)) {
+			struct ieee80211_local *local =
+				wdev_priv(dev->ieee80211_ptr);
+			struct ieee80211_sub_if_data *sdata = 
+				IEEE80211_DEV_TO_SUB_IF(new_dev);
+			write_lock_bh(&local->sub_if_lock);
+			list_del(&sdata->list);
+			write_unlock_bh(&local->sub_if_lock);
+			__ieee80211_if_del(local, sdata);
+		}
 		return res;
 	case HOSTAP_IF_VLAN:
 		if (left < sizeof(struct hostapd_if_vlan))
 			return -EPROTO;
 
-		res = ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
+		res = ieee80211_if_add(dev, param->u.if_info.name, NULL,
+				       IEEE80211_IF_TYPE_VLAN);
 		if (res)
 			return res;
-		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_VLAN);
 #if 0
 		res = ieee80211_if_update_vlan(new_dev, vlan->id);
 		if (res)
@@ -1033,21 +1040,19 @@ static int ieee80211_ioctl_add_if(struct net_device *dev,
 		if (left < sizeof(struct hostapd_if_bss))
 			return -EPROTO;
 
-		res = ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
+		res = ieee80211_if_add(dev, param->u.if_info.name, &new_dev,
+				       IEEE80211_IF_TYPE_AP);
 		if (res)
 			return res;
-		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_AP);
 		memcpy(new_dev->dev_addr, bss->bssid, ETH_ALEN);
 		return 0;
 	case HOSTAP_IF_STA:
 		if (left < sizeof(struct hostapd_if_sta))
 			return -EPROTO;
 
-		res = ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
-		if (res)
-			return res;
-		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_STA);
-		return 0;
+		res = ieee80211_if_add(dev, param->u.if_info.name, NULL,
+				       IEEE80211_IF_TYPE_STA);
+		return res;
 	default:
 		return -EINVAL;
 	}
@@ -1093,36 +1098,34 @@ static int ieee80211_ioctl_update_if(struct net_device *dev,
 		struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 		struct net_device *wds_dev = NULL;
 		struct ieee80211_sub_if_data *sdata;
+		int ret;
 
 		if (left < sizeof(struct ieee80211_if_wds))
 			return -EPROTO;
 
+		read_lock(&local->sub_if_lock);
 		list_for_each_entry(sdata, &local->sub_if_list, list) {
 			if (strcmp(param->u.if_info.name,
 				   sdata->dev->name) == 0) {
 				wds_dev = sdata->dev;
+				dev_hold(wds_dev);
 				break;
 			}
 		}
+		read_unlock(&local->sub_if_lock);
 
 		if (!wds_dev || sdata->type != IEEE80211_IF_TYPE_WDS)
 			return -ENODEV;
 
-		return ieee80211_if_update_wds(wds_dev, wds->remote_addr);
+		ret = ieee80211_if_update_wds(wds_dev, wds->remote_addr);
+		dev_put(wds_dev);
+		return ret;
 	} else {
 		return -EOPNOTSUPP;
 	}
 }
 
 
-static int ieee80211_ioctl_flush_ifs(struct net_device *dev,
-				     struct prism2_hostapd_param *param)
-{
-	ieee80211_if_flush(dev);
-	return 0;
-}
-
-
 static int ieee80211_ioctl_scan_req(struct net_device *dev,
 				    struct prism2_hostapd_param *param,
 				    int param_len)
@@ -1512,9 +1515,6 @@ static int ieee80211_ioctl_priv_hostapd(struct net_device *dev,
 	case PRISM2_HOSTAPD_MLME:
 		ret = ieee80211_ioctl_mlme(dev, param);
 		break;
-	case PRISM2_HOSTAPD_FLUSH_IFS:
-		ret = ieee80211_ioctl_flush_ifs(dev, param);
-		break;
 	case PRISM2_HOSTAPD_SET_RADAR_PARAMS:
 		ret = ieee80211_ioctl_set_radar_params(dev, param);
 		break;
@@ -2239,6 +2239,7 @@ static int ieee80211_ioctl_clear_keys(struct net_device *dev)
 	struct sta_info *sta;
 
 	memset(addr, 0xff, ETH_ALEN);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
 			keyconf = NULL;
@@ -2256,6 +2257,7 @@ static int ieee80211_ioctl_clear_keys(struct net_device *dev)
 		}
 		sdata->default_key = NULL;
 	}
+	read_unlock(&local->sub_if_lock);
 
 	spin_lock_bh(&local->sta_lock);
 	list_for_each_entry(sta, &local->sta_list, list) {
@@ -2388,6 +2390,7 @@ static int ieee80211_ioctl_default_wep_only(struct ieee80211_local *local,
 	struct ieee80211_sub_if_data *sdata;
 
 	local->default_wep_only = value;
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list)
 		for (i = 0; i < NUM_DEFAULT_KEYS; i++)
 			if (value)
@@ -2396,6 +2399,7 @@ static int ieee80211_ioctl_default_wep_only(struct ieee80211_local *local,
 			else
 				ieee80211_key_disable_hwaccel(local,
 							      sdata->keys[i]);
+	read_unlock(&local->sub_if_lock);
 
 	return 0;
 }
@@ -2406,7 +2410,7 @@ void ieee80211_update_default_wep_only(struct ieee80211_local *local)
 	int i = 0;
 	struct ieee80211_sub_if_data *sdata;
 
-	spin_lock_bh(&local->sub_if_lock);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 
 		if (sdata->dev == local->mdev)
@@ -2415,7 +2419,7 @@ void ieee80211_update_default_wep_only(struct ieee80211_local *local)
 		/* If there is an AP interface then depend on userspace to
 		   set default_wep_only correctly. */
 		if (sdata->type == IEEE80211_IF_TYPE_AP) {
-			spin_unlock_bh(&local->sub_if_lock);
+			read_unlock(&local->sub_if_lock);
 			return;
 		}
 
@@ -2427,7 +2431,7 @@ void ieee80211_update_default_wep_only(struct ieee80211_local *local)
 	else
 		ieee80211_ioctl_default_wep_only(local, 0);
 
-	spin_unlock_bh(&local->sub_if_lock);
+	read_unlock(&local->sub_if_lock);
 }
 
 
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 0b01800..3d16ed8 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2569,7 +2569,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 	memset(&wrqu, 0, sizeof(wrqu));
 	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
 
-	spin_lock_bh(&local->sub_if_lock);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		if (sdata->type == IEEE80211_IF_TYPE_STA) {
 			if (sdata->u.sta.associated)
@@ -2578,7 +2578,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 		}
 		netif_wake_queue(sdata->dev);
 	}
-	spin_unlock_bh(&local->sub_if_lock);
+	read_unlock(&local->sub_if_lock);
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type == IEEE80211_IF_TYPE_IBSS) {
@@ -2714,14 +2714,14 @@ static int ieee80211_sta_start_scan(struct net_device *dev,
 
 	local->sta_scanning = 1;
 
-	spin_lock_bh(&local->sub_if_lock);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		netif_stop_queue(sdata->dev);
 		if (sdata->type == IEEE80211_IF_TYPE_STA &&
 		    sdata->u.sta.associated)
 			ieee80211_send_nullfunc(local, sdata, 1);
 	}
-	spin_unlock_bh(&local->sub_if_lock);
+	read_unlock(&local->sub_if_lock);
 
 	if (ssid) {
 		local->scan_ssid_len = ssid_len;
@@ -2965,7 +2965,6 @@ struct sta_info * ieee80211_ibss_add_sta(struct net_device *dev,
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata = NULL;
-	struct net_device *sta_dev = NULL;
 
 	/* TODO: Could consider removing the least recently used entry and
 	 * allow new one to be added. */
@@ -2977,26 +2976,13 @@ struct sta_info * ieee80211_ibss_add_sta(struct net_device *dev,
 		return NULL;
 	}
 
-	spin_lock_bh(&local->sub_if_lock);
-	list_for_each_entry(sdata, &local->sub_if_list, list)
-		if (sdata->type == IEEE80211_IF_TYPE_IBSS &&
-		    memcmp(bssid, sdata->u.sta.bssid, ETH_ALEN) == 0) {
-			sta_dev = sdata->dev;
-			break;
-		}
-	spin_unlock_bh(&local->sub_if_lock);
-
-	if (!sta_dev)
-		return NULL;
-
 	printk(KERN_DEBUG "%s: Adding new IBSS station " MAC_FMT " (dev=%s)\n",
-	       dev->name, MAC_ARG(addr), sta_dev->name);
+	       local->mdev->name, MAC_ARG(addr), dev->name);
 
 	sta = sta_info_add(local, dev, addr, GFP_ATOMIC);
 	if (!sta)
 		return NULL;
 
-	sta->dev = sta_dev;
 	sta->supp_rates = sdata->u.sta.supp_rates_bits;
 
 	rate_control_rate_init(sta, local);


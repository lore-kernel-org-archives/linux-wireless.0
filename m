Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbYBYPdq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 10:33:46 -0500
Message-Id: <20080225153008.892022000@sipsolutions.net> (sfid-20080225_153519_884675_AC4C2C50)
References: <20080225152740.360393000@sipsolutions.net>
Date: Mon, 25 Feb 2008 16:27:49 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 09/10] mac80211: remove STA entries when taking down
	interface
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we take down an interface, we need to remove the STA info
items that belong to it because otherwise we might invoke a
sta_notify() callback in the driver when we later delete the
STA entries, but in that case the driver will already have
removed its knowledge of the interface they belonged to leading
to confusion. Also, we could invoke the set_tim() callback after
the driver removed its knowledge of the interface, which can
lead to a crash if it requests a beacon with a then-invalid vif
pointer!

A side effect of this patch is that, because it was easier, it
disallows changing the WDS peer while an interface is up. Should
that actually be necessary, it can be added back, but the WDS
peer STA entry may not be added while the interface is UP so for
now I've simplified the WDS peer's STA entry lifetime management.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Fixes a crash in ieee80211_beacon_get() when I rmmod b43 or
ip link set wlan0 down while hostapd is running on that iface
and stations are associated.

 net/mac80211/ieee80211.c       |   99 +++++++++++++++++------------------------
 net/mac80211/ieee80211_i.h     |    1 
 net/mac80211/ieee80211_iface.c |   22 +--------
 net/mac80211/ieee80211_ioctl.c |   18 +++++--
 net/mac80211/sta_info.c        |   14 ++++-
 net/mac80211/sta_info.h        |    2 
 6 files changed, 73 insertions(+), 83 deletions(-)

--- everything.orig/net/mac80211/ieee80211.c	2008-02-25 16:25:12.000000000 +0100
+++ everything/net/mac80211/ieee80211.c	2008-02-25 16:25:17.000000000 +0100
@@ -183,6 +183,7 @@ static int ieee80211_open(struct net_dev
 	struct ieee80211_if_init_conf conf;
 	int res;
 	bool need_hw_reconfig = 0;
+	struct sta_info *sta;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -256,6 +257,20 @@ static int ieee80211_open(struct net_dev
 	case IEEE80211_IF_TYPE_WDS:
 		if (is_zero_ether_addr(sdata->u.wds.remote_addr))
 			return -ENOLINK;
+
+		/* Create STA entry for the WDS peer */
+		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
+				     GFP_KERNEL);
+		if (!sta)
+			return -ENOMEM;
+
+		sta->flags |= WLAN_STA_AUTHORIZED;
+
+		res = sta_info_insert(sta);
+		if (res) {
+			sta_info_destroy(sta);
+			return res;
+		}
 		break;
 	case IEEE80211_IF_TYPE_VLAN:
 		if (!sdata->u.vlan.ap)
@@ -367,14 +382,20 @@ static int ieee80211_open(struct net_dev
 
 static int ieee80211_stop(struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_init_conf conf;
 	struct sta_info *sta;
 	int i;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	/*
+	 * Stop TX on this interface first.
+	 */
+	netif_stop_queue(dev);
 
+	/*
+	 * Now delete all active aggregation sessions.
+	 */
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
@@ -388,7 +409,24 @@ static int ieee80211_stop(struct net_dev
 
 	rcu_read_unlock();
 
-	netif_stop_queue(dev);
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
 
 	/*
 	 * Don't count this interface for promisc/allmulti while it
@@ -453,8 +491,6 @@ static int ieee80211_stop(struct net_dev
 		netif_tx_unlock_bh(local->mdev);
 		break;
 	case IEEE80211_IF_TYPE_MESH_POINT:
-		sta_info_flush(local, sdata);
-		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		sdata->u.sta.state = IEEE80211_DISABLED;
@@ -892,57 +928,6 @@ void ieee80211_if_setup(struct net_devic
 	dev->destructor = ieee80211_if_free;
 }
 
-/* WDS specialties */
-
-int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct sta_info *sta;
-	int err;
-	DECLARE_MAC_BUF(mac);
-
-	might_sleep();
-
-	if (compare_ether_addr(remote_addr, sdata->u.wds.remote_addr) == 0)
-		return 0;
-
-	/* Create STA entry for the new peer */
-	sta = sta_info_alloc(sdata, remote_addr, GFP_KERNEL);
-	if (!sta)
-		return -ENOMEM;
-
-	sta->flags |= WLAN_STA_AUTHORIZED;
-	err = sta_info_insert(sta);
-	if (err) {
-		sta_info_destroy(sta);
-		return err;
-	}
-
-	rcu_read_lock();
-
-	/* Remove STA entry for the old peer */
-	sta = sta_info_get(local, sdata->u.wds.remote_addr);
-	if (sta)
-		sta_info_unlink(&sta);
-	else
-		printk(KERN_DEBUG "%s: could not find STA entry for WDS link "
-		       "peer %s\n",
-		       dev->name, print_mac(mac, sdata->u.wds.remote_addr));
-
-	/* Update WDS link data */
-	memcpy(&sdata->u.wds.remote_addr, remote_addr, ETH_ALEN);
-
-	rcu_read_unlock();
-
-	if (sta) {
-		synchronize_rcu();
-		sta_info_destroy(sta);
-	}
-
-	return 0;
-}
-
 /* everything else */
 
 static int __ieee80211_if_config(struct net_device *dev,
--- everything.orig/net/mac80211/sta_info.c	2008-02-25 16:25:12.000000000 +0100
+++ everything/net/mac80211/sta_info.c	2008-02-25 16:25:17.000000000 +0100
@@ -254,6 +254,8 @@ int sta_info_insert(struct sta_info *sta
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
+	WARN_ON(!netif_running(sdata->dev));
+
 	spin_lock_irqsave(&local->sta_lock, flags);
 	/* check if STA exists already */
 	if (__sta_info_find(local, sta->addr)) {
@@ -604,14 +606,18 @@ void sta_info_stop(struct ieee80211_loca
 
 /**
  * sta_info_flush - flush matching STA entries from the STA table
+ *
+ * Returns the number of removed STA entries.
+ *
  * @local: local interface data
  * @sdata: matching rule for the net device (sta->dev) or %NULL to match all STAs
  */
-void sta_info_flush(struct ieee80211_local *local,
+int sta_info_flush(struct ieee80211_local *local,
 		    struct ieee80211_sub_if_data *sdata)
 {
 	struct sta_info *sta, *tmp;
 	LIST_HEAD(tmp_list);
+	int ret = 0;
 	unsigned long flags;
 
 	might_sleep();
@@ -620,8 +626,10 @@ void sta_info_flush(struct ieee80211_loc
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
 		if (!sdata || sdata == sta->sdata) {
 			__sta_info_unlink(&sta);
-			if (sta)
+			if (sta) {
 				list_add_tail(&sta->list, &tmp_list);
+				ret++;
+			}
 		}
 	}
 	spin_unlock_irqrestore(&local->sta_lock, flags);
@@ -630,4 +638,6 @@ void sta_info_flush(struct ieee80211_loc
 
 	list_for_each_entry_safe(sta, tmp, &tmp_list, list)
 		sta_info_destroy(sta);
+
+	return ret;
 }
--- everything.orig/net/mac80211/ieee80211_iface.c	2008-02-25 16:25:11.000000000 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2008-02-25 16:25:17.000000000 +0100
@@ -187,8 +187,8 @@ void ieee80211_if_reinit(struct net_devi
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct sta_info *sta;
 	struct sk_buff *skb;
+	int flushed;
 
 	ASSERT_RTNL();
 
@@ -240,21 +240,7 @@ void ieee80211_if_reinit(struct net_devi
 		break;
 	}
 	case IEEE80211_IF_TYPE_WDS:
-		rcu_read_lock();
-		sta = sta_info_get(local, sdata->u.wds.remote_addr);
-		if (sta) {
-			sta_info_unlink(&sta);
-		} else {
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-			printk(KERN_DEBUG "%s: Someone had deleted my STA "
-			       "entry for the WDS link\n", dev->name);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-		}
-		rcu_read_unlock();
-		if (sta) {
-			synchronize_rcu();
-			sta_info_destroy(sta);
-		}
+		/* nothing to do */
 		break;
 	case IEEE80211_IF_TYPE_MESH_POINT:
 	case IEEE80211_IF_TYPE_STA:
@@ -279,8 +265,8 @@ void ieee80211_if_reinit(struct net_devi
 		break;
 	}
 
-	/* remove all STAs that are bound to this virtual interface */
-	sta_info_flush(local, sdata);
+	flushed = sta_info_flush(local, sdata);
+	WARN_ON(flushed);
 
 	memset(&sdata->u, 0, sizeof(sdata->u));
 	ieee80211_if_sdata_init(sdata);
--- everything.orig/net/mac80211/ieee80211_i.h	2008-02-25 16:25:11.000000000 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-02-25 16:25:17.000000000 +0100
@@ -858,7 +858,6 @@ int ieee80211_hw_config(struct ieee80211
 int ieee80211_if_config(struct net_device *dev);
 int ieee80211_if_config_beacon(struct net_device *dev);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
-int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr);
 void ieee80211_if_setup(struct net_device *dev);
 int ieee80211_hw_config_ht(struct ieee80211_local *local, int enable_ht,
 			   struct ieee80211_ht_info *req_ht_cap,
--- everything.orig/net/mac80211/sta_info.h	2008-02-25 16:25:16.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-25 16:25:17.000000000 +0100
@@ -339,7 +339,7 @@ void sta_info_clear_tim_bit(struct sta_i
 void sta_info_init(struct ieee80211_local *local);
 int sta_info_start(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
-void sta_info_flush(struct ieee80211_local *local,
+int sta_info_flush(struct ieee80211_local *local,
 		    struct ieee80211_sub_if_data *sdata);
 
 #endif /* STA_INFO_H */
--- everything.orig/net/mac80211/ieee80211_ioctl.c	2008-02-25 16:25:11.000000000 +0100
+++ everything/net/mac80211/ieee80211_ioctl.c	2008-02-25 16:25:17.000000000 +0100
@@ -471,10 +471,20 @@ static int ieee80211_ioctl_siwap(struct 
 		ieee80211_sta_req_auth(dev, &sdata->u.sta);
 		return 0;
 	} else if (sdata->vif.type == IEEE80211_IF_TYPE_WDS) {
-		if (memcmp(sdata->u.wds.remote_addr, (u8 *) &ap_addr->sa_data,
-			   ETH_ALEN) == 0)
-			return 0;
-		return ieee80211_if_update_wds(dev, (u8 *) &ap_addr->sa_data);
+		/*
+		 * If it is necessary to update the WDS peer address
+		 * while the interface is running, then we need to do
+		 * more work here, namely if it is running we need to
+		 * add a new and remove the old STA entry, this is
+		 * normally handled by _open() and _stop().
+		 */
+		if (netif_running(dev))
+			return -EBUSY;
+
+		memcpy(&sdata->u.wds.remote_addr, (u8 *) &ap_addr->sa_data,
+		       ETH_ALEN);
+
+		return 0;
 	}
 
 	return -EOPNOTSUPP;

-- 


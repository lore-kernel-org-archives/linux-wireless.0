Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39035 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab2GaLcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:32:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 2/4] mac80211: support P2P Device abstraction
Date: Tue, 31 Jul 2012 13:32:16 +0200
Message-Id: <1343734338-14772-3-git-send-email-johannes@sipsolutions.net> (sfid-20120731_133232_066843_6C14859A)
In-Reply-To: <1343734338-14772-1-git-send-email-johannes@sipsolutions.net>
References: <1343734338-14772-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

After cfg80211 got a P2P Device abstraction, add
support to mac80211. Whether it really is supported
or not will depend on whether or not the driver has
support for it, but mac80211 needs to change to be
able to support drivers that need a P2P Device.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |   18 ++++
 net/mac80211/driver-ops.h  |    2 +-
 net/mac80211/ieee80211_i.h |    4 +
 net/mac80211/iface.c       |  231 ++++++++++++++++++++++++++++----------------
 net/mac80211/main.c        |    9 ++
 net/mac80211/offchannel.c  |    6 ++
 net/mac80211/rx.c          |   14 ++-
 net/mac80211/status.c      |   22 +++--
 net/mac80211/trace.h       |    2 +-
 net/mac80211/util.c        |   12 ++-
 10 files changed, 224 insertions(+), 96 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5583f5b..fa87964 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -102,6 +102,18 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_start_p2p_device(struct wiphy *wiphy,
+				      struct wireless_dev *wdev)
+{
+	return ieee80211_do_open(wdev, true);
+}
+
+static void ieee80211_stop_p2p_device(struct wiphy *wiphy,
+				      struct wireless_dev *wdev)
+{
+	ieee80211_sdata_stop(IEEE80211_WDEV_TO_SUB_IF(wdev));
+}
+
 static int ieee80211_set_noack_map(struct wiphy *wiphy,
 				  struct net_device *dev,
 				  u16 noack_map)
@@ -1776,6 +1788,7 @@ static int ieee80211_scan(struct wiphy *wiphy,
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
 	case NL80211_IFTYPE_P2P_GO:
 		if (sdata->local->ops->hw_scan)
@@ -2463,6 +2476,9 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		if (!sdata->u.mgd.associated)
 			need_offchan = true;
 		break;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		need_offchan = true;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -3015,6 +3031,8 @@ struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
 	.change_virtual_intf = ieee80211_change_iface,
+	.start_p2p_device = ieee80211_start_p2p_device,
+	.stop_p2p_device = ieee80211_stop_p2p_device,
 	.add_key = ieee80211_add_key,
 	.del_key = ieee80211_del_key,
 	.get_key = ieee80211_get_key,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index a81117a..f1e751f 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -9,7 +9,7 @@ static inline void check_sdata_in_driver(struct ieee80211_sub_if_data *sdata)
 {
 	WARN(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER),
 	     "%s:  Failed check-sdata-in-driver check, flags: 0x%x\n",
-	     sdata->dev->name, sdata->flags);
+	     sdata->dev ? sdata->dev->name : sdata->name, sdata->flags);
 }
 
 static inline struct ieee80211_sub_if_data *
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d1a7c58..412be9e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1074,6 +1074,8 @@ struct ieee80211_local {
 	struct idr ack_status_frames;
 	spinlock_t ack_status_lock;
 
+	struct ieee80211_sub_if_data __rcu *p2p_sdata;
+
 	/* dummy netdev for use w/ NAPI */
 	struct net_device napi_dev;
 
@@ -1291,6 +1293,8 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local);
 void ieee80211_recalc_idle(struct ieee80211_local *local);
 void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
 				    const int offset);
+int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up);
+void ieee80211_sdata_stop(struct ieee80211_sub_if_data *sdata);
 
 static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2eaa5c6..0dafd38 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -100,6 +100,10 @@ static u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
 			sdata->vif.bss_conf.idle = true;
 			continue;
 		}
+
+		if (sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE)
+			continue;
+
 		/* count everything else */
 		sdata->vif.bss_conf.idle = false;
 		count++;
@@ -121,7 +125,8 @@ static u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
-		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+		    sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE)
 			continue;
 		if (sdata->old_idle == sdata->vif.bss_conf.idle)
 			continue;
@@ -204,6 +209,8 @@ static inline int identical_mac_addr_allowed(int type1, int type2)
 {
 	return type1 == NL80211_IFTYPE_MONITOR ||
 		type2 == NL80211_IFTYPE_MONITOR ||
+		type1 == NL80211_IFTYPE_P2P_DEVICE ||
+		type2 == NL80211_IFTYPE_P2P_DEVICE ||
 		(type1 == NL80211_IFTYPE_AP && type2 == NL80211_IFTYPE_WDS) ||
 		(type1 == NL80211_IFTYPE_WDS &&
 			(type2 == NL80211_IFTYPE_WDS ||
@@ -406,9 +413,10 @@ static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
  * an error on interface type changes that have been pre-checked, so most
  * checks should be in ieee80211_check_concurrent_iface.
  */
-static int ieee80211_do_open(struct net_device *dev, bool coming_up)
+int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct net_device *dev = wdev->netdev;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	u32 changed = 0;
@@ -443,13 +451,13 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		/* no special treatment */
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
-	case NL80211_IFTYPE_P2P_DEVICE:
 		/* cannot happen */
 		WARN_ON(1);
 		break;
@@ -472,7 +480,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	 * Copy the hopefully now-present MAC address to
 	 * this interface, if it has the special null one.
 	 */
-	if (is_zero_ether_addr(dev->dev_addr)) {
+	if (dev && is_zero_ether_addr(dev->dev_addr)) {
 		memcpy(dev->dev_addr,
 		       local->hw.wiphy->perm_addr,
 		       ETH_ALEN);
@@ -537,7 +545,8 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 			local->fif_probe_req++;
 		}
 
-		changed |= ieee80211_reset_erp_info(sdata);
+		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE)
+			changed |= ieee80211_reset_erp_info(sdata);
 		ieee80211_bss_info_change_notify(sdata, changed);
 
 		switch (sdata->vif.type) {
@@ -548,6 +557,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 			netif_carrier_off(dev);
 			break;
 		case NL80211_IFTYPE_WDS:
+		case NL80211_IFTYPE_P2P_DEVICE:
 			break;
 		default:
 			netif_carrier_on(dev);
@@ -584,6 +594,8 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 
 		rate_control_rate_init(sta);
 		netif_carrier_on(dev);
+	} else if (sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE) {
+		rcu_assign_pointer(local->p2p_sdata, sdata);
 	}
 
 	/*
@@ -609,7 +621,8 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 
 	ieee80211_recalc_ps(local, -1);
 
-	netif_tx_start_all_queues(dev);
+	if (dev)
+		netif_tx_start_all_queues(dev);
 
 	return 0;
  err_del_interface:
@@ -639,7 +652,7 @@ static int ieee80211_open(struct net_device *dev)
 	if (err)
 		return err;
 
-	return ieee80211_do_open(dev, true);
+	return ieee80211_do_open(&sdata->wdev, true);
 }
 
 static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
@@ -660,7 +673,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	/*
 	 * Stop TX on this interface first.
 	 */
-	netif_tx_stop_all_queues(sdata->dev);
+	if (sdata->dev)
+		netif_tx_stop_all_queues(sdata->dev);
 
 	ieee80211_roc_purge(sdata);
 
@@ -699,14 +713,16 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		local->fif_probe_req--;
 	}
 
-	netif_addr_lock_bh(sdata->dev);
-	spin_lock_bh(&local->filter_lock);
-	__hw_addr_unsync(&local->mc_list, &sdata->dev->mc,
-			 sdata->dev->addr_len);
-	spin_unlock_bh(&local->filter_lock);
-	netif_addr_unlock_bh(sdata->dev);
+	if (sdata->dev) {
+		netif_addr_lock_bh(sdata->dev);
+		spin_lock_bh(&local->filter_lock);
+		__hw_addr_unsync(&local->mc_list, &sdata->dev->mc,
+				 sdata->dev->addr_len);
+		spin_unlock_bh(&local->filter_lock);
+		netif_addr_unlock_bh(sdata->dev);
 
-	ieee80211_configure_filter(local);
+		ieee80211_configure_filter(local);
+	}
 
 	del_timer_sync(&local->dynamic_ps_timer);
 	cancel_work_sync(&local->dynamic_ps_enable_work);
@@ -767,6 +783,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		ieee80211_adjust_monitor_flags(sdata, -1);
 		ieee80211_configure_filter(local);
 		break;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		/* relies on synchronize_rcu() below */
+		rcu_assign_pointer(local->p2p_sdata, NULL);
+		/* fall through */
 	default:
 		flush_work(&sdata->work);
 		/*
@@ -885,9 +905,8 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
  * Called when the netdev is removed or, by the code below, before
  * the interface type changes.
  */
-static void ieee80211_teardown_sdata(struct net_device *dev)
+static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	int flushed;
 	int i;
@@ -908,6 +927,11 @@ static void ieee80211_teardown_sdata(struct net_device *dev)
 	WARN_ON(flushed);
 }
 
+static void ieee80211_uninit(struct net_device *dev)
+{
+	ieee80211_teardown_sdata(IEEE80211_DEV_TO_SUB_IF(dev));
+}
+
 static u16 ieee80211_netdev_select_queue(struct net_device *dev,
 					 struct sk_buff *skb)
 {
@@ -917,7 +941,7 @@ static u16 ieee80211_netdev_select_queue(struct net_device *dev,
 static const struct net_device_ops ieee80211_dataif_ops = {
 	.ndo_open		= ieee80211_open,
 	.ndo_stop		= ieee80211_stop,
-	.ndo_uninit		= ieee80211_teardown_sdata,
+	.ndo_uninit		= ieee80211_uninit,
 	.ndo_start_xmit		= ieee80211_subif_start_xmit,
 	.ndo_set_rx_mode	= ieee80211_set_multicast_list,
 	.ndo_change_mtu 	= ieee80211_change_mtu,
@@ -948,7 +972,7 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 static const struct net_device_ops ieee80211_monitorif_ops = {
 	.ndo_open		= ieee80211_open,
 	.ndo_stop		= ieee80211_stop,
-	.ndo_uninit		= ieee80211_teardown_sdata,
+	.ndo_uninit		= ieee80211_uninit,
 	.ndo_start_xmit		= ieee80211_monitor_start_xmit,
 	.ndo_set_rx_mode	= ieee80211_set_multicast_list,
 	.ndo_change_mtu 	= ieee80211_change_mtu,
@@ -1107,7 +1131,6 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	/* and set some type-dependent values */
 	sdata->vif.type = type;
 	sdata->vif.p2p = false;
-	sdata->dev->netdev_ops = &ieee80211_dataif_ops;
 	sdata->wdev.iftype = type;
 
 	sdata->control_port_protocol = cpu_to_be16(ETH_P_PAE);
@@ -1115,8 +1138,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 
 	sdata->noack_map = 0;
 
-	/* only monitor differs */
-	sdata->dev->type = ARPHRD_ETHER;
+	/* only monitor/p2p-device differ */
+	if (sdata->dev) {
+		sdata->dev->netdev_ops = &ieee80211_dataif_ops;
+		sdata->dev->type = ARPHRD_ETHER;
+	}
 
 	skb_queue_head_init(&sdata->skb_queue);
 	INIT_WORK(&sdata->work, ieee80211_iface_work);
@@ -1154,9 +1180,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		break;
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_AP_VLAN:
-		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
-		/* not yet supported */
+		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
 		BUG();
@@ -1235,7 +1260,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_do_stop(sdata, false);
 
-	ieee80211_teardown_sdata(sdata->dev);
+	ieee80211_teardown_sdata(sdata);
 
 	ret = drv_change_interface(local, sdata, internal_type, p2p);
 	if (ret)
@@ -1250,7 +1275,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_setup_sdata(sdata, type);
 
-	err = ieee80211_do_open(sdata->dev, false);
+	err = ieee80211_do_open(&sdata->wdev, false);
 	WARN(err, "type change: do_open returned %d", err);
 
 	return ret;
@@ -1277,7 +1302,7 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 			return ret;
 	} else {
 		/* Purge and reset type-dependent state. */
-		ieee80211_teardown_sdata(sdata->dev);
+		ieee80211_teardown_sdata(sdata);
 		ieee80211_setup_sdata(sdata, type);
 	}
 
@@ -1293,8 +1318,7 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 }
 
 static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
-				       struct net_device *dev,
-				       enum nl80211_iftype type)
+				       u8 *perm_addr, enum nl80211_iftype type)
 {
 	struct ieee80211_sub_if_data *sdata;
 	u64 mask, start, addr, val, inc;
@@ -1303,7 +1327,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 	int i;
 
 	/* default ... something at least */
-	memcpy(dev->perm_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
+	memcpy(perm_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 
 	if (is_zero_ether_addr(local->hw.wiphy->addr_mask) &&
 	    local->hw.wiphy->n_addresses <= 1)
@@ -1322,7 +1346,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 		list_for_each_entry(sdata, &local->interfaces, list) {
 			if (sdata->vif.type != NL80211_IFTYPE_AP)
 				continue;
-			memcpy(dev->perm_addr, sdata->vif.addr, ETH_ALEN);
+			memcpy(perm_addr, sdata->vif.addr, ETH_ALEN);
 			break;
 		}
 		/* keep default if no AP interface present */
@@ -1341,7 +1365,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 			}
 
 			if (!used) {
-				memcpy(dev->perm_addr,
+				memcpy(perm_addr,
 				       local->hw.wiphy->addresses[i].addr,
 				       ETH_ALEN);
 				break;
@@ -1392,7 +1416,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 			}
 
 			if (!used) {
-				memcpy(dev->perm_addr, tmp_addr, ETH_ALEN);
+				memcpy(perm_addr, tmp_addr, ETH_ALEN);
 				break;
 			}
 			addr = (start & ~mask) | (val & mask);
@@ -1408,49 +1432,68 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct wireless_dev **new_wdev, enum nl80211_iftype type,
 		     struct vif_params *params)
 {
-	struct net_device *ndev;
+	struct net_device *ndev = NULL;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	int ret, i;
 	int txqs = 1;
 
 	ASSERT_RTNL();
 
-	if (local->hw.queues >= IEEE80211_NUM_ACS)
-		txqs = IEEE80211_NUM_ACS;
-
-	ndev = alloc_netdev_mqs(sizeof(*sdata) + local->hw.vif_data_size,
-				name, ieee80211_if_setup, txqs, 1);
-	if (!ndev)
-		return -ENOMEM;
-	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
-
-	ndev->needed_headroom = local->tx_headroom +
-				4*6 /* four MAC addresses */
-				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
-				+ 6 /* mesh */
-				+ 8 /* rfc1042/bridge tunnel */
-				- ETH_HLEN /* ethernet hard_header_len */
-				+ IEEE80211_ENCRYPT_HEADROOM;
-	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
-
-	ret = dev_alloc_name(ndev, ndev->name);
-	if (ret < 0)
-		goto fail;
-
-	ieee80211_assign_perm_addr(local, ndev, type);
-	memcpy(ndev->dev_addr, ndev->perm_addr, ETH_ALEN);
-	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
-
-	/* don't use IEEE80211_DEV_TO_SUB_IF because it checks too much */
-	sdata = netdev_priv(ndev);
-	ndev->ieee80211_ptr = &sdata->wdev;
-	memcpy(sdata->vif.addr, ndev->dev_addr, ETH_ALEN);
-	memcpy(sdata->name, ndev->name, IFNAMSIZ);
+	if (type == NL80211_IFTYPE_P2P_DEVICE) {
+		struct wireless_dev *wdev;
+
+		sdata = kzalloc(sizeof(*sdata) + local->hw.vif_data_size,
+				GFP_KERNEL);
+		if (!sdata)
+			return -ENOMEM;
+		wdev = &sdata->wdev;
+
+		sdata->dev = NULL;
+		strlcpy(sdata->name, name, IFNAMSIZ);
+		ieee80211_assign_perm_addr(local, wdev->address, type);
+		memcpy(sdata->vif.addr, wdev->address, ETH_ALEN);
+	} else {
+		if (local->hw.queues >= IEEE80211_NUM_ACS)
+			txqs = IEEE80211_NUM_ACS;
+
+		ndev = alloc_netdev_mqs(sizeof(*sdata) +
+					local->hw.vif_data_size,
+					name, ieee80211_if_setup, txqs, 1);
+		if (!ndev)
+			return -ENOMEM;
+		dev_net_set(ndev, wiphy_net(local->hw.wiphy));
+
+		ndev->needed_headroom = local->tx_headroom +
+					4*6 /* four MAC addresses */
+					+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
+					+ 6 /* mesh */
+					+ 8 /* rfc1042/bridge tunnel */
+					- ETH_HLEN /* ethernet hard_header_len */
+					+ IEEE80211_ENCRYPT_HEADROOM;
+		ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
+
+		ret = dev_alloc_name(ndev, ndev->name);
+		if (ret < 0) {
+			free_netdev(ndev);
+			return ret;
+		}
+
+		ieee80211_assign_perm_addr(local, ndev->perm_addr, type);
+		memcpy(ndev->dev_addr, ndev->perm_addr, ETH_ALEN);
+		SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
+
+		/* don't use IEEE80211_DEV_TO_SUB_IF -- it checks too much */
+		sdata = netdev_priv(ndev);
+		ndev->ieee80211_ptr = &sdata->wdev;
+		memcpy(sdata->vif.addr, ndev->dev_addr, ETH_ALEN);
+		memcpy(sdata->name, ndev->name, IFNAMSIZ);
+
+		sdata->dev = ndev;
+	}
 
 	/* initialise type-independent data */
 	sdata->wdev.wiphy = local->hw.wiphy;
 	sdata->local = local;
-	sdata->dev = ndev;
 #ifdef CONFIG_INET
 	sdata->arp_filter_state = true;
 #endif
@@ -1479,17 +1522,21 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	/* setup type-dependent data */
 	ieee80211_setup_sdata(sdata, type);
 
-	if (params) {
-		ndev->ieee80211_ptr->use_4addr = params->use_4addr;
-		if (type == NL80211_IFTYPE_STATION)
-			sdata->u.mgd.use_4addr = params->use_4addr;
-	}
+	if (ndev) {
+		if (params) {
+			ndev->ieee80211_ptr->use_4addr = params->use_4addr;
+			if (type == NL80211_IFTYPE_STATION)
+				sdata->u.mgd.use_4addr = params->use_4addr;
+		}
 
-	ndev->features |= local->hw.netdev_features;
+		ndev->features |= local->hw.netdev_features;
 
-	ret = register_netdevice(ndev);
-	if (ret)
-		goto fail;
+		ret = register_netdevice(ndev);
+		if (ret) {
+			free_netdev(ndev);
+			return ret;
+		}
+	}
 
 	mutex_lock(&local->iflist_mtx);
 	list_add_tail_rcu(&sdata->list, &local->interfaces);
@@ -1499,10 +1546,6 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		*new_wdev = &sdata->wdev;
 
 	return 0;
-
- fail:
-	free_netdev(ndev);
-	return ret;
 }
 
 void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
@@ -1517,7 +1560,21 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 	ieee80211_clean_sdata(sdata);
 
 	synchronize_rcu();
-	unregister_netdevice(sdata->dev);
+
+	if (sdata->dev) {
+		unregister_netdevice(sdata->dev);
+	} else {
+		cfg80211_unregister_wdev(&sdata->wdev);
+		kfree(sdata);
+	}
+}
+
+void ieee80211_sdata_stop(struct ieee80211_sub_if_data *sdata)
+{
+	if (WARN_ON_ONCE(!test_bit(SDATA_STATE_RUNNING, &sdata->state)))
+		return;
+	ieee80211_do_stop(sdata, true);
+	ieee80211_teardown_sdata(sdata);
 }
 
 /*
@@ -1528,6 +1585,7 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata, *tmp;
 	LIST_HEAD(unreg_list);
+	LIST_HEAD(wdev_list);
 
 	ASSERT_RTNL();
 
@@ -1537,11 +1595,20 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 
 		ieee80211_clean_sdata(sdata);
 
-		unregister_netdevice_queue(sdata->dev, &unreg_list);
+		if (sdata->dev)
+			unregister_netdevice_queue(sdata->dev, &unreg_list);
+		else
+			list_add(&sdata->list, &wdev_list);
 	}
 	mutex_unlock(&local->iflist_mtx);
 	unregister_netdevice_many(&unreg_list);
 	list_del(&unreg_list);
+
+	list_for_each_entry_safe(sdata, tmp, &wdev_list, list) {
+		list_del(&sdata->list);
+		cfg80211_unregister_wdev(&sdata->wdev);
+		kfree(sdata);
+	}
 }
 
 static int netdev_notify(struct notifier_block *nb,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c26e231..e706f9e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -207,6 +207,10 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.bssid = NULL;
 	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		sdata->vif.bss_conf.bssid = zero;
+	} else if (sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE) {
+		sdata->vif.bss_conf.bssid = sdata->vif.addr;
+		WARN_ONCE(changed & ~(BSS_CHANGED_IDLE),
+			  "P2P Device BSS changed %#x", changed);
 	} else {
 		WARN_ON(1);
 		return;
@@ -514,6 +518,11 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 			BIT(IEEE80211_STYPE_AUTH >> 4) |
 			BIT(IEEE80211_STYPE_DEAUTH >> 4),
 	},
+	[NL80211_IFTYPE_P2P_DEVICE] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_REQ >> 4),
+	},
 };
 
 static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 635c325..507121d 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -116,6 +116,9 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
+		if (sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE)
+			continue;
+
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
 			set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
 
@@ -144,6 +147,9 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE)
+			continue;
+
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
 			clear_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 090d417..3b74232 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2772,8 +2772,7 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 		if (!bssid) {
 			if (!ether_addr_equal(sdata->vif.addr, hdr->addr1))
 				return 0;
-		} else if (!ieee80211_bssid_match(bssid,
-					sdata->vif.addr)) {
+		} else if (!ieee80211_bssid_match(bssid, sdata->vif.addr)) {
 			/*
 			 * Accept public action frames even when the
 			 * BSSID doesn't match, this is used for P2P
@@ -2793,9 +2792,18 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 		if (!ether_addr_equal(sdata->u.wds.remote_addr, hdr->addr2))
 			return 0;
 		break;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		if (!ieee80211_is_public_action(hdr, skb->len) &&
+		    !ieee80211_is_probe_req(hdr->frame_control) &&
+		    !ieee80211_is_probe_resp(hdr->frame_control) &&
+		    !ieee80211_is_beacon(hdr->frame_control))
+			return 0;
+		if (!ether_addr_equal(sdata->vif.addr, hdr->addr1))
+			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
+		break;
 	default:
 		/* should never get here */
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
 		break;
 	}
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 8cd7291..b0801b7 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -519,19 +519,27 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		u64 cookie = (unsigned long)skb;
 		acked = info->flags & IEEE80211_TX_STAT_ACK;
 
-		/*
-		 * TODO: When we have non-netdev frame TX,
-		 * we cannot use skb->dev->ieee80211_ptr
-		 */
-
 		if (ieee80211_is_nullfunc(hdr->frame_control) ||
-		    ieee80211_is_qos_nullfunc(hdr->frame_control))
+		    ieee80211_is_qos_nullfunc(hdr->frame_control)) {
 			cfg80211_probe_status(skb->dev, hdr->addr1,
 					      cookie, acked, GFP_ATOMIC);
-		else
+		} else if (skb->dev) {
 			cfg80211_mgmt_tx_status(
 				skb->dev->ieee80211_ptr, cookie, skb->data,
 				skb->len, acked, GFP_ATOMIC);
+		} else {
+			struct ieee80211_sub_if_data *p2p_sdata;
+
+			rcu_read_lock();
+
+			p2p_sdata = rcu_dereference(local->p2p_sdata);
+			if (p2p_sdata) {
+				cfg80211_mgmt_tx_status(
+					&p2p_sdata->wdev, cookie, skb->data,
+					skb->len, acked, GFP_ATOMIC);
+			}
+			rcu_read_unlock();
+		}
 	}
 
 	if (unlikely(info->ack_frame_id)) {
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index c6d33b5..65e9a2a 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -24,7 +24,7 @@
 			__string(vif_name, sdata->dev ? sdata->dev->name : "<nodev>")
 #define VIF_ASSIGN	__entry->vif_type = sdata->vif.type; __entry->sdata = sdata;	\
 			__entry->p2p = sdata->vif.p2p;					\
-			__assign_str(vif_name, sdata->dev ? sdata->dev->name : "<nodev>")
+			__assign_str(vif_name, sdata->dev ? sdata->dev->name : sdata->name)
 #define VIF_PR_FMT	" vif:%s(%d%s)"
 #define VIF_PR_ARG	__get_str(vif_name), __entry->vif_type, __entry->p2p ? "/p2p" : ""
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index fa4637a..a77ea17 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -276,6 +276,9 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		int ac;
 
+		if (!sdata->dev)
+			continue;
+
 		if (test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))
 			continue;
 
@@ -364,6 +367,9 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		int ac;
 
+		if (!sdata->dev)
+			continue;
+
 		for (ac = 0; ac < n_acs; ac++) {
 			if (sdata->vif.hw_queue[ac] == queue ||
 			    sdata->vif.cab_queue == queue)
@@ -899,7 +905,8 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 		drv_conf_tx(local, sdata, ac, &qparam);
 	}
 
-	if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
+	if (sdata->vif.type != NL80211_IFTYPE_MONITOR &&
+	    sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE) {
 		sdata->vif.bss_conf.qos = enable_qos;
 		if (bss_notify)
 			ieee80211_bss_info_change_notify(sdata,
@@ -1388,7 +1395,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			/* ignore virtual */
 			break;
 		case NL80211_IFTYPE_P2P_DEVICE:
-			/* not yet supported */
+			changed = BSS_CHANGED_IDLE;
+			break;
 		case NL80211_IFTYPE_UNSPECIFIED:
 		case NUM_NL80211_IFTYPES:
 		case NL80211_IFTYPE_P2P_CLIENT:
-- 
1.7.10.4


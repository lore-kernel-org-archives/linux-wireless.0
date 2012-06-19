Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52388 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab2FSOva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:30 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 15/17] cfg80211: add P2P Device abstraction
Date: Tue, 19 Jun 2012 16:50:54 +0200
Message-Id: <1340117456-10154-16-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165137_981692_0DA59A56)
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to support using a different MAC address
for the P2P Device address we must first have a
P2P Device abstraction that can be assigned a MAC
address.

This abstraction will also be useful to support
offloading P2P operations to the device, e.g.
periodic listen for discoverability.

Currently, the driver is responsible for assigning
a MAC address to the P2P Device, but this could be
changed by allowing a MAC address to be given to
the NEW_INTERFACE command.

As it has no associated netdev, a P2P Device can
only be identified by its wdev identifier but the
previous patches allowed using the wdev identifier
in various APIs, e.g. remain-on-channel.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |   16 ++++++
 include/net/cfg80211.h  |   40 ++++++++++++++-
 net/mac80211/iface.c    |    3 ++
 net/mac80211/util.c     |    2 +
 net/wireless/core.c     |   52 +++++++++++++++++++-
 net/wireless/mlme.c     |   10 ++--
 net/wireless/nl80211.c  |  123 ++++++++++++++++++++++++++++++++++++++++++++---
 net/wireless/util.c     |   18 ++++++-
 8 files changed, 249 insertions(+), 15 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index fe3b6da..1e9a569 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -565,6 +565,14 @@
  *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ with
  *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE.
  *
+ * @NL80211_CMD_START_P2P_DEVICE: Start the given P2P Device, identified by
+ *	its %NL80211_ATTR_WDEV identifier. It must have been created with
+ *	%NL80211_CMD_NEW_INTERFACE previously. After it has been started, the
+ *	P2P Device can be used for P2P operations, e.g. remain-on-channel and
+ *	public action frame TX.
+ * @NL80211_CMD_STOP_P2P_DEVICE: Stop the given P2P Device, identified by
+ *	its %NL80211_ATTR_WDEV identifier.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -708,6 +716,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_CH_SWITCH_NOTIFY,
 
+	NL80211_CMD_START_P2P_DEVICE,
+	NL80211_CMD_STOP_P2P_DEVICE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1562,6 +1573,10 @@ enum nl80211_attrs {
  * @NL80211_IFTYPE_MESH_POINT: mesh point
  * @NL80211_IFTYPE_P2P_CLIENT: P2P client
  * @NL80211_IFTYPE_P2P_GO: P2P group owner
+ * @NL80211_IFTYPE_P2P_DEVICE: P2P device interface type, this is not a netdev
+ *	and therefore can't be created in the normal ways, use the
+ *	%NL80211_CMD_START_P2P_DEVICE and %NL80211_CMD_STOP_P2P_DEVICE
+ *	commands to create and destroy one
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @NUM_NL80211_IFTYPES: number of defined interface types
  *
@@ -1580,6 +1595,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_MESH_POINT,
 	NL80211_IFTYPE_P2P_CLIENT,
 	NL80211_IFTYPE_P2P_GO,
+	NL80211_IFTYPE_P2P_DEVICE,
 
 	/* keep last */
 	NUM_NL80211_IFTYPES,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f5c4b9d..3ffbc83 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1414,7 +1414,8 @@ struct cfg80211_gtk_rekey_data {
  * @add_virtual_intf: create a new virtual interface with the given name,
  *	must set the struct wireless_dev's iftype. Beware: You must create
  *	the new netdev in the wiphy's network namespace! Returns the struct
- *	wireless_dev, or an ERR_PTR.
+ *	wireless_dev, or an ERR_PTR. For P2P device wdevs, the driver must
+ *	also set the address member in the wdev.
  *
  * @del_virtual_intf: remove the virtual interface
  *
@@ -1590,6 +1591,9 @@ struct cfg80211_gtk_rekey_data {
  * @get_et_strings:  Ethtool API to get a set of strings to describe stats
  *	and perhaps other supported types of ethtool data-sets.
  *	See @ethtool_ops.get_strings
+ *
+ * @start_p2p_device: Start the given P2P device.
+ * @stop_p2p_device: Stop the given P2P device.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1800,6 +1804,11 @@ struct cfg80211_ops {
 				struct ethtool_stats *stats, u64 *data);
 	void	(*get_et_strings)(struct wiphy *wiphy, struct net_device *dev,
 				  u32 sset, u8 *data);
+
+	int	(*start_p2p_device)(struct wiphy *wiphy,
+				    struct wireless_dev *wdev);
+	void	(*stop_p2p_device)(struct wiphy *wiphy,
+				   struct wireless_dev *wdev);
 };
 
 /*
@@ -2361,6 +2370,8 @@ struct cfg80211_cached_keys;
  * @cleanup_work: work struct used for cleanup that can't be done directly
  * @beacon_interval: beacon interval used on this device for transmitting
  *	beacons, 0 when not valid
+ * @address: The address for this device, valid only if @netdev is %NULL
+ * @p2p_started: true if this is a P2P Device that has been started
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -2379,7 +2390,9 @@ struct wireless_dev {
 
 	struct work_struct cleanup_work;
 
-	bool use_4addr;
+	bool use_4addr, p2p_started;
+
+	u8 address[ETH_ALEN] __aligned(sizeof(u16));
 
 	/* currently used for IBSS and SME - might be rearranged later */
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
@@ -2422,6 +2435,13 @@ struct wireless_dev {
 #endif
 };
 
+static inline u8 *wdev_address(struct wireless_dev *wdev)
+{
+	if (wdev->netdev)
+		return wdev->netdev->dev_addr;
+	return wdev->address;
+}
+
 /**
  * wdev_priv - return wiphy priv from wireless_dev
  *
@@ -3474,6 +3494,22 @@ void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
  */
 u16 cfg80211_calculate_bitrate(struct rate_info *rate);
 
+/**
+ * cfg80211_unregister_wdev - remove the given wdev
+ * @wdev: struct wireless_dev to remove
+ *
+ * Call this function only for wdevs that have no netdev assigned,
+ * e.g. P2P Devices. It removes the device from the list so that
+ * it can no longer be used. It is necessary to call this function
+ * even when cfg80211 requests the removal of the interface by
+ * calling the del_virtual_intf() callback. The function must also
+ * be called when the driver wishes to unregister the wdev, e.g.
+ * when the device is unbound from the driver.
+ *
+ * Requires the RTNL to be held.
+ */
+void cfg80211_unregister_wdev(struct wireless_dev *wdev);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0fa224d..cf598d8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -323,6 +323,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	case NUM_NL80211_IFTYPES:
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		/* cannot happen */
 		WARN_ON(1);
 		break;
@@ -1021,6 +1022,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_AP_VLAN:
 		break;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		/* not yet supported */
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
 		BUG();
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 242ecde..864e533 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1362,6 +1362,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NL80211_IFTYPE_MONITOR:
 			/* ignore virtual */
 			break;
+		case NL80211_IFTYPE_P2P_DEVICE:
+			/* not yet supported */
 		case NL80211_IFTYPE_UNSPECIFIED:
 		case NUM_NL80211_IFTYPES:
 		case NL80211_IFTYPE_P2P_CLIENT:
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 12b905a..6d922c0 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -230,9 +230,24 @@ static int cfg80211_rfkill_set_block(void *data, bool blocked)
 	rtnl_lock();
 	mutex_lock(&rdev->devlist_mtx);
 
-	list_for_each_entry(wdev, &rdev->wdev_list, list)
-		if (wdev->netdev)
+	list_for_each_entry(wdev, &rdev->wdev_list, list) {
+		if (wdev->netdev) {
 			dev_close(wdev->netdev);
+			continue;
+		}
+		/* otherwise, check iftype */
+		switch (wdev->iftype) {
+		case NL80211_IFTYPE_P2P_DEVICE:
+			if (!wdev->p2p_started)
+				break;
+			rdev->ops->stop_p2p_device(&rdev->wiphy, wdev);
+			wdev->p2p_started = false;
+			rdev->opencount--;
+			break;
+		default:
+			break;
+		}
+	}
 
 	mutex_unlock(&rdev->devlist_mtx);
 	rtnl_unlock();
@@ -399,6 +414,11 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 			if (WARN_ON(wiphy->software_iftypes & types))
 				return -EINVAL;
 
+			/* Only a single P2P_DEVICE can be allowed */
+			if (WARN_ON(types & BIT(NL80211_IFTYPE_P2P_DEVICE) &&
+				    c->limits[j].max > 1))
+				return -EINVAL;
+
 			cnt += c->limits[j].max;
 			/*
 			 * Don't advertise an unsupported type
@@ -714,6 +734,34 @@ static void wdev_cleanup_work(struct work_struct *work)
 	dev_put(wdev->netdev);
 }
 
+void cfg80211_unregister_wdev(struct wireless_dev *wdev)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+
+	ASSERT_RTNL();
+
+	if (WARN_ON(wdev->netdev))
+		return;
+
+	mutex_lock(&rdev->devlist_mtx);
+	list_del_rcu(&wdev->list);
+	rdev->devlist_generation++;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_P2P_DEVICE:
+		if (wdev->p2p_started) {
+			wdev->p2p_started = false;
+			rdev->opencount--;
+		}
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+	mutex_unlock(&rdev->devlist_mtx);
+}
+EXPORT_SYMBOL(cfg80211_unregister_wdev);
+
 static struct device_type wiphy_type = {
 	.name	= "wlan",
 };
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 46e3c387..8b19ff4 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -720,7 +720,6 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  const u8 *buf, size_t len, bool no_cck,
 			  bool dont_wait_for_ack, u64 *cookie)
 {
-	struct net_device *dev = wdev->netdev;
 	const struct ieee80211_mgmt *mgmt;
 	u16 stype;
 
@@ -780,7 +779,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_P2P_GO:
 		case NL80211_IFTYPE_AP_VLAN:
-			if (!ether_addr_equal(mgmt->bssid, dev->dev_addr))
+			if (!ether_addr_equal(mgmt->bssid, wdev_address(wdev)))
 				err = -EINVAL;
 			break;
 		case NL80211_IFTYPE_MESH_POINT:
@@ -793,6 +792,11 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			 * cfg80211 doesn't track the stations
 			 */
 			break;
+		case NL80211_IFTYPE_P2P_DEVICE:
+			/*
+			 * fall through, P2P device only supports
+			 * public action frames
+			 */
 		default:
 			err = -EOPNOTSUPP;
 			break;
@@ -803,7 +807,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			return err;
 	}
 
-	if (!ether_addr_equal(mgmt->sa, dev->dev_addr))
+	if (!ether_addr_equal(mgmt->sa, wdev_address(wdev)))
 		return -EINVAL;
 
 	/* Transmit the Action frame as requested by user space */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e94aac9..0c31771 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1086,6 +1086,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		if (nla_put_u32(msg, i, NL80211_CMD_REGISTER_BEACONS))
 			goto nla_put_failure;
 	}
+	CMD(start_p2p_device, START_P2P_DEVICE);
 
 #ifdef CONFIG_NL80211_TESTMODE
 	CMD(testmode_cmd, TESTMODE);
@@ -1732,13 +1733,13 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 
 	if (dev &&
 	    (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
-	     nla_put_string(msg, NL80211_ATTR_IFNAME, dev->name) ||
-	     nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, dev->dev_addr)))
+	     nla_put_string(msg, NL80211_ATTR_IFNAME, dev->name)))
 		goto nla_put_failure;
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
 	    nla_put_u32(msg, NL80211_ATTR_IFTYPE, wdev->iftype) ||
 	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, wdev_address(wdev)) ||
 	    nla_put_u32(msg, NL80211_ATTR_GENERATION,
 			rdev->devlist_generation ^
 			(cfg80211_rdev_list_generation << 2)))
@@ -2004,8 +2005,10 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(wdev);
 	}
 
-	if (type == NL80211_IFTYPE_MESH_POINT &&
-	    info->attrs[NL80211_ATTR_MESH_ID]) {
+	switch (type) {
+	case NL80211_IFTYPE_MESH_POINT:
+		if (!info->attrs[NL80211_ATTR_MESH_ID])
+			break;
 		wdev_lock(wdev);
 		BUILD_BUG_ON(IEEE80211_MAX_SSID_LEN !=
 			     IEEE80211_MAX_MESH_ID_LEN);
@@ -2014,6 +2017,26 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		memcpy(wdev->ssid, nla_data(info->attrs[NL80211_ATTR_MESH_ID]),
 		       wdev->mesh_id_up_len);
 		wdev_unlock(wdev);
+		break;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		/*
+		 * P2P Device doesn't have a netdev, so doesn't go
+		 * through the netdev notifier and must be added here
+		 */
+		mutex_init(&wdev->mtx);
+		INIT_LIST_HEAD(&wdev->event_list);
+		spin_lock_init(&wdev->event_lock);
+		INIT_LIST_HEAD(&wdev->mgmt_registrations);
+		spin_lock_init(&wdev->mgmt_registrations_lock);
+
+		mutex_lock(&rdev->devlist_mtx);
+		wdev->identifier = ++rdev->wdev_id;
+		list_add_rcu(&wdev->list, &rdev->wdev_list);
+		rdev->devlist_generation++;
+		mutex_unlock(&rdev->devlist_mtx);
+		break;
+	default:
+		break;
 	}
 
 	if (nl80211_send_iface(msg, info->snd_pid, info->snd_seq, 0,
@@ -5971,6 +5994,7 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -6017,6 +6041,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -6113,6 +6138,7 @@ static int nl80211_tx_mgmt_cancel_wait(struct sk_buff *skb, struct genl_info *in
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -6695,6 +6721,69 @@ static int nl80211_register_beacons(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
+static int nl80211_start_p2p_device(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	int err;
+
+	if (!rdev->ops->start_p2p_device)
+		return -EOPNOTSUPP;
+
+	if (wdev->iftype != NL80211_IFTYPE_P2P_DEVICE)
+		return -EOPNOTSUPP;
+
+	if (!(rdev->wiphy.interface_modes & BIT(NL80211_IFTYPE_P2P_DEVICE)))
+		return -EOPNOTSUPP;
+
+	if (wdev->p2p_started)
+		return 0;
+
+	err = cfg80211_can_add_interface(rdev, wdev->iftype);
+	if (err)
+		return err;
+
+	err = rdev->ops->start_p2p_device(&rdev->wiphy, wdev);
+	if (err)
+		return err;
+
+	wdev->p2p_started = true;
+	mutex_lock(&rdev->devlist_mtx);
+	rdev->opencount++;
+	mutex_unlock(&rdev->devlist_mtx);
+
+	return 0;
+}
+
+static int nl80211_stop_p2p_device(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+
+	if (wdev->iftype != NL80211_IFTYPE_P2P_DEVICE)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->stop_p2p_device)
+		return -EOPNOTSUPP;
+
+	if (!wdev->p2p_started)
+		return 0;
+
+	rdev->ops->stop_p2p_device(&rdev->wiphy, wdev);
+	wdev->p2p_started = false;
+
+	mutex_lock(&rdev->devlist_mtx);
+	rdev->opencount--;
+	mutex_unlock(&rdev->devlist_mtx);
+
+	if (WARN_ON(rdev->scan_req && rdev->scan_req->wdev == wdev)) {
+		rdev->scan_req->aborted = true;
+		___cfg80211_scan_done(rdev, true);
+	}
+
+	return 0;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -6702,7 +6791,7 @@ static int nl80211_register_beacons(struct sk_buff *skb, struct genl_info *info)
 #define NL80211_FLAG_NEED_NETDEV_UP	(NL80211_FLAG_NEED_NETDEV |\
 					 NL80211_FLAG_CHECK_NETDEV_UP)
 #define NL80211_FLAG_NEED_WDEV		0x10
-/* If a netdev is associated, it must be UP */
+/* If a netdev is associated, it must be UP, P2P must be started */
 #define NL80211_FLAG_NEED_WDEV_UP	(NL80211_FLAG_NEED_WDEV |\
 					 NL80211_FLAG_CHECK_NETDEV_UP)
 
@@ -6763,6 +6852,13 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 			}
 
 			dev_hold(dev);
+		} else if (ops->internal_flags & NL80211_FLAG_CHECK_NETDEV_UP) {
+			if (!wdev->p2p_started) {
+				mutex_unlock(&cfg80211_mutex);
+				if (rtnl)
+					rtnl_unlock();
+				return -ENETDOWN;
+			}
 		}
 
 		cfg80211_lock_rdev(rdev);
@@ -7322,7 +7418,22 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
-
+	{
+		.cmd = NL80211_CMD_START_P2P_DEVICE,
+		.doit = nl80211_start_p2p_device,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_STOP_P2P_DEVICE,
+		.doit = nl80211_stop_p2p_device,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
diff --git a/net/wireless/util.c b/net/wireless/util.c
index ab8d9a5..676c4a3 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -793,6 +793,10 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	if (otype == NL80211_IFTYPE_AP_VLAN)
 		return -EOPNOTSUPP;
 
+	/* cannot change into P2P device type */
+	if (ntype == NL80211_IFTYPE_P2P_DEVICE)
+		return -EOPNOTSUPP;
+
 	if (!rdev->ops->change_virtual_intf ||
 	    !(rdev->wiphy.interface_modes & (1 << ntype)))
 		return -EOPNOTSUPP;
@@ -865,6 +869,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		case NUM_NL80211_IFTYPES:
 			/* not happening */
 			break;
+		case NL80211_IFTYPE_P2P_DEVICE:
+			WARN_ON(1);
+			break;
 		}
 	}
 
@@ -954,8 +961,15 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
 		if (wdev_iter == wdev)
 			continue;
-		if (!netif_running(wdev_iter->netdev))
-			continue;
+		if (wdev_iter->netdev) {
+			if (!netif_running(wdev_iter->netdev))
+				continue;
+		} else if (wdev_iter->iftype == NL80211_IFTYPE_P2P_DEVICE) {
+			if (!wdev_iter->p2p_started)
+				continue;
+		} else {
+			WARN_ON(1);
+		}
 
 		if (rdev->wiphy.software_iftypes & BIT(wdev_iter->iftype))
 			continue;
-- 
1.7.10


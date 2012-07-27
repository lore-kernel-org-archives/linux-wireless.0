Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51338 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2G0LC5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:02:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] cfg80211: add P2P Device abstraction
Date: Fri, 27 Jul 2012 13:02:49 +0200
Message-Id: <1343386972-5044-2-git-send-email-johannes@sipsolutions.net> (sfid-20120727_130303_554520_7354DC48)
In-Reply-To: <1343386972-5044-1-git-send-email-johannes@sipsolutions.net>
References: <1343386972-5044-1-git-send-email-johannes@sipsolutions.net>
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
 include/linux/nl80211.h |   30 ++++++++++--
 include/net/cfg80211.h  |   40 +++++++++++++++-
 net/mac80211/iface.c    |    3 ++
 net/mac80211/util.c     |    2 +
 net/wireless/chan.c     |    5 ++
 net/wireless/core.c     |   53 +++++++++++++++++++-
 net/wireless/mlme.c     |   10 ++--
 net/wireless/nl80211.c  |  122 ++++++++++++++++++++++++++++++++++++++++++++---
 net/wireless/util.c     |   18 ++++++-
 9 files changed, 264 insertions(+), 19 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2f38788..4584162 100644
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
@@ -1575,6 +1586,10 @@ enum nl80211_attrs {
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
@@ -1593,6 +1608,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_MESH_POINT,
 	NL80211_IFTYPE_P2P_CLIENT,
 	NL80211_IFTYPE_P2P_GO,
+	NL80211_IFTYPE_P2P_DEVICE,
 
 	/* keep last */
 	NUM_NL80211_IFTYPES,
@@ -2994,12 +3010,18 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_CELL_BASE_REG_HINTS: This driver has been tested
  *	to work properly to suppport receiving regulatory hints from
  *	cellular base stations.
+ * @NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL: If this is set, an active
+ *	P2P Device (%NL80211_IFTYPE_P2P_DEVICE) requires its own channel
+ *	in the interface combinations, even when it's only used for scan
+ *	and remain-on-channel. This could be due to, for example, the
+ *	remain-on-channel implementation requiring a channel context.
  */
 enum nl80211_feature_flags {
-	NL80211_FEATURE_SK_TX_STATUS	= 1 << 0,
-	NL80211_FEATURE_HT_IBSS		= 1 << 1,
-	NL80211_FEATURE_INACTIVITY_TIMER = 1 << 2,
-	NL80211_FEATURE_CELL_BASE_REG_HINTS = 1 << 3,
+	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
+	NL80211_FEATURE_HT_IBSS				= 1 << 1,
+	NL80211_FEATURE_INACTIVITY_TIMER		= 1 << 2,
+	NL80211_FEATURE_CELL_BASE_REG_HINTS		= 1 << 3,
+	NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL	= 1 << 4,
 };
 
 /**
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 493fa0c..4c518f1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1437,7 +1437,8 @@ struct cfg80211_gtk_rekey_data {
  * @add_virtual_intf: create a new virtual interface with the given name,
  *	must set the struct wireless_dev's iftype. Beware: You must create
  *	the new netdev in the wiphy's network namespace! Returns the struct
- *	wireless_dev, or an ERR_PTR.
+ *	wireless_dev, or an ERR_PTR. For P2P device wdevs, the driver must
+ *	also set the address member in the wdev.
  *
  * @del_virtual_intf: remove the virtual interface
  *
@@ -1616,6 +1617,9 @@ struct cfg80211_gtk_rekey_data {
  * @get_channel: Get the current operating channel for the virtual interface.
  *	For monitor interfaces, it should return %NULL unless there's a single
  *	current monitoring channel.
+ *
+ * @start_p2p_device: Start the given P2P device.
+ * @stop_p2p_device: Stop the given P2P device.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1832,6 +1836,11 @@ struct cfg80211_ops {
 		(*get_channel)(struct wiphy *wiphy,
 			       struct wireless_dev *wdev,
 			       enum nl80211_channel_type *type);
+
+	int	(*start_p2p_device)(struct wiphy *wiphy,
+				    struct wireless_dev *wdev);
+	void	(*stop_p2p_device)(struct wiphy *wiphy,
+				   struct wireless_dev *wdev);
 };
 
 /*
@@ -2395,6 +2404,8 @@ struct cfg80211_cached_keys;
  * @cleanup_work: work struct used for cleanup that can't be done directly
  * @beacon_interval: beacon interval used on this device for transmitting
  *	beacons, 0 when not valid
+ * @address: The address for this device, valid only if @netdev is %NULL
+ * @p2p_started: true if this is a P2P Device that has been started
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -2413,7 +2424,9 @@ struct wireless_dev {
 
 	struct work_struct cleanup_work;
 
-	bool use_4addr;
+	bool use_4addr, p2p_started;
+
+	u8 address[ETH_ALEN] __aligned(sizeof(u16));
 
 	/* currently used for IBSS and SME - might be rearranged later */
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
@@ -2461,6 +2474,13 @@ struct wireless_dev {
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
@@ -3528,6 +3548,22 @@ void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
  */
 u32 cfg80211_calculate_bitrate(struct rate_info *rate);
 
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
index bfb57dc..e8f116b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -449,6 +449,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	case NUM_NL80211_IFTYPES:
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		/* cannot happen */
 		WARN_ON(1);
 		break;
@@ -1147,6 +1148,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_AP_VLAN:
 		break;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		/* not yet supported */
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
 		BUG();
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 39b82fe..454ae63 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1385,6 +1385,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NL80211_IFTYPE_MONITOR:
 			/* ignore virtual */
 			break;
+		case NL80211_IFTYPE_P2P_DEVICE:
+			/* not yet supported */
 		case NL80211_IFTYPE_UNSPECIFIED:
 		case NUM_NL80211_IFTYPES:
 		case NL80211_IFTYPE_P2P_CLIENT:
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index d355f67..6ce1754 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -143,6 +143,11 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 	case NL80211_IFTYPE_WDS:
 		/* these interface types don't really have a channel */
 		return;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		if (wdev->wiphy->features &
+				NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL)
+			*chanmode = CHAN_MODE_EXCLUSIVE;
+		return;
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NUM_NL80211_IFTYPES:
 		WARN_ON(1);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 31b40cc..91b3004 100644
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
@@ -407,6 +422,11 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
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
@@ -734,6 +754,35 @@ static void wdev_cleanup_work(struct work_struct *work)
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
+		if (!wdev->p2p_started)
+			break;
+		rdev->ops->stop_p2p_device(&rdev->wiphy, wdev);
+		wdev->p2p_started = false;
+		rdev->opencount--;
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
index 1cdb1d5..8fd0242 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -736,7 +736,6 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  const u8 *buf, size_t len, bool no_cck,
 			  bool dont_wait_for_ack, u64 *cookie)
 {
-	struct net_device *dev = wdev->netdev;
 	const struct ieee80211_mgmt *mgmt;
 	u16 stype;
 
@@ -796,7 +795,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_P2P_GO:
 		case NL80211_IFTYPE_AP_VLAN:
-			if (!ether_addr_equal(mgmt->bssid, dev->dev_addr))
+			if (!ether_addr_equal(mgmt->bssid, wdev_address(wdev)))
 				err = -EINVAL;
 			break;
 		case NL80211_IFTYPE_MESH_POINT:
@@ -809,6 +808,11 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
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
@@ -819,7 +823,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			return err;
 	}
 
-	if (!ether_addr_equal(mgmt->sa, dev->dev_addr))
+	if (!ether_addr_equal(mgmt->sa, wdev_address(wdev)))
 		return -EINVAL;
 
 	/* Transmit the Action frame as requested by user space */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 50b1a0e..19b0607 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1100,6 +1100,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		if (nla_put_u32(msg, i, NL80211_CMD_REGISTER_BEACONS))
 			goto nla_put_failure;
 	}
+	CMD(start_p2p_device, START_P2P_DEVICE);
 
 #ifdef CONFIG_NL80211_TESTMODE
 	CMD(testmode_cmd, TESTMODE);
@@ -1748,13 +1749,13 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 
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
@@ -2021,8 +2022,10 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
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
@@ -2031,6 +2034,26 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
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
@@ -6053,6 +6076,7 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -6099,6 +6123,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -6195,6 +6220,7 @@ static int nl80211_tx_mgmt_cancel_wait(struct sk_buff *skb, struct genl_info *in
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -6810,6 +6836,68 @@ static int nl80211_register_beacons(struct sk_buff *skb, struct genl_info *info)
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
+	if (wdev->p2p_started)
+		return 0;
+
+	mutex_lock(&rdev->devlist_mtx);
+	err = cfg80211_can_add_interface(rdev, wdev->iftype);
+	mutex_unlock(&rdev->devlist_mtx);
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
@@ -6817,7 +6905,7 @@ static int nl80211_register_beacons(struct sk_buff *skb, struct genl_info *info)
 #define NL80211_FLAG_NEED_NETDEV_UP	(NL80211_FLAG_NEED_NETDEV |\
 					 NL80211_FLAG_CHECK_NETDEV_UP)
 #define NL80211_FLAG_NEED_WDEV		0x10
-/* If a netdev is associated, it must be UP */
+/* If a netdev is associated, it must be UP, P2P must be started */
 #define NL80211_FLAG_NEED_WDEV_UP	(NL80211_FLAG_NEED_WDEV |\
 					 NL80211_FLAG_CHECK_NETDEV_UP)
 
@@ -6878,6 +6966,13 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
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
@@ -7439,7 +7534,22 @@ static struct genl_ops nl80211_ops[] = {
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
index ce393dd..d7b6722 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -800,6 +800,10 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	if (otype == NL80211_IFTYPE_AP_VLAN)
 		return -EOPNOTSUPP;
 
+	/* cannot change into P2P device type */
+	if (ntype == NL80211_IFTYPE_P2P_DEVICE)
+		return -EOPNOTSUPP;
+
 	if (!rdev->ops->change_virtual_intf ||
 	    !(rdev->wiphy.interface_modes & (1 << ntype)))
 		return -EOPNOTSUPP;
@@ -877,6 +881,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		case NUM_NL80211_IFTYPES:
 			/* not happening */
 			break;
+		case NL80211_IFTYPE_P2P_DEVICE:
+			WARN_ON(1);
+			break;
 		}
 	}
 
@@ -1041,8 +1048,15 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
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
1.7.10.4


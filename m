Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab2GIMiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 08:38:08 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/8] nl80211: prepare for non-netdev wireless devs
Date: Mon,  9 Jul 2012 14:37:56 +0200
Message-Id: <1341837483-18001-2-git-send-email-johannes@sipsolutions.net> (sfid-20120709_143831_167905_AE29924D)
In-Reply-To: <1341837483-18001-1-git-send-email-johannes@sipsolutions.net>
References: <1341837483-18001-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to support a P2P device abstraction and
Bluetooth high-speed AMPs, we need to have a way
to identify virtual interfaces that don't have a
netdev associated.

Do this by adding a NL80211_ATTR_WDEV attribute
to identify a wdev which may or may not also be
a netdev.

To simplify things, use a 64-bit value with the
high 32 bits being the wiphy index for this new
wdev identifier in the nl80211 API.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |    5 ++
 include/net/cfg80211.h  |   22 +++++---
 net/wireless/core.c     |   13 ++---
 net/wireless/core.h     |    6 +--
 net/wireless/nl80211.c  |  135 +++++++++++++++++++++++++++++++++++++----------
 net/wireless/sme.c      |    4 +-
 net/wireless/util.c     |    6 +--
 7 files changed, 144 insertions(+), 47 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index db961a5..e791487 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -771,6 +771,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_IFNAME: network interface name
  * @NL80211_ATTR_IFTYPE: type of virtual interface, see &enum nl80211_iftype
  *
+ * @NL80211_ATTR_WDEV: wireless device identifier, used for pseudo-devices
+ *	that don't have a netdev (u64)
+ *
  * @NL80211_ATTR_MAC: MAC address (various uses)
  *
  * @NL80211_ATTR_KEY_DATA: (temporal) key data; for TKIP this consists of
@@ -1493,6 +1496,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BG_SCAN_PERIOD,
 
+	NL80211_ATTR_WDEV,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 51f67a9..a14e6a4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2341,17 +2341,25 @@ struct cfg80211_internal_bss;
 struct cfg80211_cached_keys;
 
 /**
- * struct wireless_dev - wireless per-netdev state
+ * struct wireless_dev - wireless device state
  *
- * This structure must be allocated by the driver/stack
- * that uses the ieee80211_ptr field in struct net_device
- * (this is intentional so it can be allocated along with
- * the netdev.)
+ * For netdevs, this structure must be allocated by the driver
+ * that uses the ieee80211_ptr field in struct net_device (this
+ * is intentional so it can be allocated along with the netdev.)
+ * It need not be registered then as netdev registration will
+ * be intercepted by cfg80211 to see the new wireless device.
+ *
+ * For non-netdev uses, it must also be allocated by the driver
+ * in response to the cfg80211 callbacks that require it, as
+ * there's no netdev registration in that case it may not be
+ * allocated outside of callback operations that return it.
  *
  * @wiphy: pointer to hardware description
  * @iftype: interface type
  * @list: (private) Used to collect the interfaces
- * @netdev: (private) Used to reference back to the netdev
+ * @netdev: (private) Used to reference back to the netdev, may be %NULL
+ * @identifier: (private) Identifier used in nl80211 to identify this
+ *	wireless device if it has no netdev
  * @current_bss: (private) Used by the internal configuration code
  * @channel: (private) Used by the internal configuration code to track
  *	the user-set AP, monitor and WDS channel
@@ -2383,6 +2391,8 @@ struct wireless_dev {
 	struct list_head list;
 	struct net_device *netdev;
 
+	u32 identifier;
+
 	struct list_head mgmt_registrations;
 	spinlock_t mgmt_registrations_lock;
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index e42a97b..b110a8a2 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -176,7 +176,7 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_NETNS_OK))
 		return -EOPNOTSUPP;
 
-	list_for_each_entry(wdev, &rdev->netdev_list, list) {
+	list_for_each_entry(wdev, &rdev->wdev_list, list) {
 		wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
 		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
 		if (err)
@@ -188,7 +188,7 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		/* failed -- clean up to old netns */
 		net = wiphy_net(&rdev->wiphy);
 
-		list_for_each_entry_continue_reverse(wdev, &rdev->netdev_list,
+		list_for_each_entry_continue_reverse(wdev, &rdev->wdev_list,
 						     list) {
 			wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
 			err = dev_change_net_namespace(wdev->netdev, net,
@@ -226,7 +226,7 @@ static int cfg80211_rfkill_set_block(void *data, bool blocked)
 	rtnl_lock();
 	mutex_lock(&rdev->devlist_mtx);
 
-	list_for_each_entry(wdev, &rdev->netdev_list, list)
+	list_for_each_entry(wdev, &rdev->wdev_list, list)
 		dev_close(wdev->netdev);
 
 	mutex_unlock(&rdev->devlist_mtx);
@@ -304,7 +304,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	mutex_init(&rdev->mtx);
 	mutex_init(&rdev->devlist_mtx);
 	mutex_init(&rdev->sched_scan_mtx);
-	INIT_LIST_HEAD(&rdev->netdev_list);
+	INIT_LIST_HEAD(&rdev->wdev_list);
 	spin_lock_init(&rdev->bss_lock);
 	INIT_LIST_HEAD(&rdev->bss_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
@@ -622,7 +622,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 		__count == 0; }));
 
 	mutex_lock(&rdev->devlist_mtx);
-	BUG_ON(!list_empty(&rdev->netdev_list));
+	BUG_ON(!list_empty(&rdev->wdev_list));
 	mutex_unlock(&rdev->devlist_mtx);
 
 	/*
@@ -821,7 +821,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		spin_lock_init(&wdev->mgmt_registrations_lock);
 
 		mutex_lock(&rdev->devlist_mtx);
-		list_add_rcu(&wdev->list, &rdev->netdev_list);
+		wdev->identifier = ++rdev->wdev_id;
+		list_add_rcu(&wdev->list, &rdev->wdev_list);
 		rdev->devlist_generation++;
 		/* can only change netns with wiphy */
 		dev->features |= NETIF_F_NETNS_LOCAL;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 377dc39..6b0170a 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -47,11 +47,11 @@ struct cfg80211_registered_device {
 	/* wiphy index, internal only */
 	int wiphy_idx;
 
-	/* associate netdev list */
+	/* associated wireless interfaces */
 	struct mutex devlist_mtx;
 	/* protected by devlist_mtx or RCU */
-	struct list_head netdev_list;
-	int devlist_generation;
+	struct list_head wdev_list;
+	int devlist_generation, wdev_id;
 	int opencount; /* also protected by devlist_mtx */
 	wait_queue_head_t dev_wait;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2a5cdb6..35a9b15 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -46,28 +46,60 @@ static struct genl_family nl80211_fam = {
 	.post_doit = nl80211_post_doit,
 };
 
-/* internal helper: get rdev and dev */
-static int get_rdev_dev_by_ifindex(struct net *netns, struct nlattr **attrs,
-				   struct cfg80211_registered_device **rdev,
-				   struct net_device **dev)
+/* returns ERR_PTR values */
+static struct wireless_dev *
+__cfg80211_wdev_from_attrs(struct net *netns, struct nlattr **attrs)
 {
-	int ifindex;
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *result = NULL;
+	bool have_ifidx = attrs[NL80211_ATTR_IFINDEX];
+	bool have_wdev_id = attrs[NL80211_ATTR_WDEV];
+	u64 wdev_id;
+	int wiphy_idx = -1;
+	int ifidx = -1;
 
-	if (!attrs[NL80211_ATTR_IFINDEX])
-		return -EINVAL;
+	assert_cfg80211_lock();
 
-	ifindex = nla_get_u32(attrs[NL80211_ATTR_IFINDEX]);
-	*dev = dev_get_by_index(netns, ifindex);
-	if (!*dev)
-		return -ENODEV;
+	if (!have_ifidx && !have_wdev_id)
+		return ERR_PTR(-EINVAL);
 
-	*rdev = cfg80211_get_dev_from_ifindex(netns, ifindex);
-	if (IS_ERR(*rdev)) {
-		dev_put(*dev);
-		return PTR_ERR(*rdev);
+	if (have_ifidx)
+		ifidx = nla_get_u32(attrs[NL80211_ATTR_IFINDEX]);
+	if (have_wdev_id) {
+		wdev_id = nla_get_u64(attrs[NL80211_ATTR_WDEV]);
+		wiphy_idx = wdev_id >> 32;
 	}
 
-	return 0;
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		struct wireless_dev *wdev;
+
+		if (wiphy_net(&rdev->wiphy) != netns)
+			continue;
+
+		if (have_wdev_id && rdev->wiphy_idx != wiphy_idx)
+			continue;
+
+		mutex_lock(&rdev->devlist_mtx);
+		list_for_each_entry(wdev, &rdev->wdev_list, list) {
+			if (have_ifidx && wdev->netdev &&
+			    wdev->netdev->ifindex == ifidx) {
+				result = wdev;
+				break;
+			}
+			if (have_wdev_id && wdev->identifier == (u32)wdev_id) {
+				result = wdev;
+				break;
+			}
+		}
+		mutex_unlock(&rdev->devlist_mtx);
+
+		if (result)
+			break;
+	}
+
+	if (result)
+		return result;
+	return ERR_PTR(-ENODEV);
 }
 
 static struct cfg80211_registered_device *
@@ -79,13 +111,40 @@ __cfg80211_rdev_from_attrs(struct net *netns, struct nlattr **attrs)
 	assert_cfg80211_lock();
 
 	if (!attrs[NL80211_ATTR_WIPHY] &&
-	    !attrs[NL80211_ATTR_IFINDEX])
+	    !attrs[NL80211_ATTR_IFINDEX] &&
+	    !attrs[NL80211_ATTR_WDEV])
 		return ERR_PTR(-EINVAL);
 
 	if (attrs[NL80211_ATTR_WIPHY])
 		rdev = cfg80211_rdev_by_wiphy_idx(
 				nla_get_u32(attrs[NL80211_ATTR_WIPHY]));
 
+	if (attrs[NL80211_ATTR_WDEV]) {
+		u64 wdev_id = nla_get_u64(attrs[NL80211_ATTR_WDEV]);
+		struct wireless_dev *wdev;
+		bool found = false;
+
+		tmp = cfg80211_rdev_by_wiphy_idx(wdev_id >> 32);
+		if (tmp) {
+			/* make sure wdev exists */
+			mutex_lock(&tmp->devlist_mtx);
+			list_for_each_entry(wdev, &tmp->wdev_list, list) {
+				if (wdev->identifier != (u32)wdev_id)
+					continue;
+				found = true;
+				break;
+			}
+			mutex_unlock(&tmp->devlist_mtx);
+
+			if (!found)
+				tmp = NULL;
+
+			if (rdev && tmp != rdev)
+				return ERR_PTR(-EINVAL);
+			rdev = tmp;
+		}
+	}
+
 	if (attrs[NL80211_ATTR_IFINDEX]) {
 		int ifindex = nla_get_u32(attrs[NL80211_ATTR_IFINDEX]);
 		netdev = dev_get_by_index(netns, ifindex);
@@ -294,6 +353,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
 	[NL80211_ATTR_INACTIVITY_TIMEOUT] = { .type = NLA_U16 },
 	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
+	[NL80211_ATTR_WDEV] = { .type = NLA_U64 },
 };
 
 /* policy for the key attributes */
@@ -1674,6 +1734,8 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			      struct net_device *dev)
 {
 	void *hdr;
+	u64 wdev_id = (u64)dev->ieee80211_ptr->identifier |
+		      ((u64)rdev->wiphy_idx << 32);
 
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_INTERFACE);
 	if (!hdr)
@@ -1684,6 +1746,7 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	    nla_put_string(msg, NL80211_ATTR_IFNAME, dev->name) ||
 	    nla_put_u32(msg, NL80211_ATTR_IFTYPE,
 			dev->ieee80211_ptr->iftype) ||
+	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id) ||
 	    nla_put_u32(msg, NL80211_ATTR_GENERATION,
 			rdev->devlist_generation ^
 			(cfg80211_rdev_list_generation << 2)))
@@ -1724,7 +1787,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 		if_idx = 0;
 
 		mutex_lock(&rdev->devlist_mtx);
-		list_for_each_entry(wdev, &rdev->netdev_list, list) {
+		list_for_each_entry(wdev, &rdev->wdev_list, list) {
 			if (if_idx < if_start) {
 				if_idx++;
 				continue;
@@ -2350,7 +2413,7 @@ static bool nl80211_get_ap_channel(struct cfg80211_registered_device *rdev,
 
 	mutex_lock(&rdev->devlist_mtx);
 
-	list_for_each_entry(wdev, &rdev->netdev_list, list) {
+	list_for_each_entry(wdev, &rdev->wdev_list, list) {
 		if (wdev->iftype != NL80211_IFTYPE_AP &&
 		    wdev->iftype != NL80211_IFTYPE_P2P_GO)
 			continue;
@@ -6660,8 +6723,8 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 			    struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
 	struct net_device *dev;
-	int err;
 	bool rtnl = ops->internal_flags & NL80211_FLAG_NEED_RTNL;
 
 	if (rtnl)
@@ -6676,21 +6739,39 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 		}
 		info->user_ptr[0] = rdev;
 	} else if (ops->internal_flags & NL80211_FLAG_NEED_NETDEV) {
-		err = get_rdev_dev_by_ifindex(genl_info_net(info), info->attrs,
-					      &rdev, &dev);
-		if (err) {
+		mutex_lock(&cfg80211_mutex);
+		wdev = __cfg80211_wdev_from_attrs(genl_info_net(info),
+						  info->attrs);
+		if (IS_ERR(wdev)) {
+			mutex_unlock(&cfg80211_mutex);
 			if (rtnl)
 				rtnl_unlock();
-			return err;
+			return PTR_ERR(wdev);
 		}
+
+		if (!wdev->netdev) {
+			mutex_unlock(&cfg80211_mutex);
+			if (rtnl)
+				rtnl_unlock();
+			return -EINVAL;
+		}
+
+		dev = wdev->netdev;
+		rdev = wiphy_to_dev(wdev->wiphy);
+
 		if (ops->internal_flags & NL80211_FLAG_CHECK_NETDEV_UP &&
 		    !netif_running(dev)) {
-			cfg80211_unlock_rdev(rdev);
-			dev_put(dev);
+			mutex_unlock(&cfg80211_mutex);
 			if (rtnl)
 				rtnl_unlock();
 			return -ENETDOWN;
 		}
+
+		dev_hold(dev);
+		cfg80211_lock_rdev(rdev);
+
+		mutex_unlock(&cfg80211_mutex);
+
 		info->user_ptr[0] = rdev;
 		info->user_ptr[1] = dev;
 	}
@@ -8483,7 +8564,7 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
-		list_for_each_entry_rcu(wdev, &rdev->netdev_list, list)
+		list_for_each_entry_rcu(wdev, &rdev->wdev_list, list)
 			cfg80211_mlme_unregister_socket(wdev, notify->pid);
 		if (rdev->ap_beacons_nlpid == notify->pid)
 			rdev->ap_beacons_nlpid = 0;
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index f7e937f..dec9798 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -51,7 +51,7 @@ static bool cfg80211_is_all_idle(void)
 	 */
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		cfg80211_lock_rdev(rdev);
-		list_for_each_entry(wdev, &rdev->netdev_list, list) {
+		list_for_each_entry(wdev, &rdev->wdev_list, list) {
 			wdev_lock(wdev);
 			if (wdev->sme_state != CFG80211_SME_IDLE)
 				is_all_idle = false;
@@ -221,7 +221,7 @@ void cfg80211_conn_work(struct work_struct *work)
 	cfg80211_lock_rdev(rdev);
 	mutex_lock(&rdev->devlist_mtx);
 
-	list_for_each_entry(wdev, &rdev->netdev_list, list) {
+	list_for_each_entry(wdev, &rdev->wdev_list, list) {
 		wdev_lock(wdev);
 		if (!netif_running(wdev->netdev)) {
 			wdev_unlock(wdev);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index e31f1db..f7a0647 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -793,7 +793,7 @@ void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev)
 
 	mutex_lock(&rdev->devlist_mtx);
 
-	list_for_each_entry(wdev, &rdev->netdev_list, list)
+	list_for_each_entry(wdev, &rdev->wdev_list, list)
 		cfg80211_process_wdev_events(wdev);
 
 	mutex_unlock(&rdev->devlist_mtx);
@@ -994,7 +994,7 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 
 	mutex_lock(&rdev->devlist_mtx);
 
-	list_for_each_entry(wdev, &rdev->netdev_list, list) {
+	list_for_each_entry(wdev, &rdev->wdev_list, list) {
 		if (!wdev->beacon_interval)
 			continue;
 		if (wdev->beacon_interval != beacon_int) {
@@ -1050,7 +1050,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		break;
 	}
 
-	list_for_each_entry(wdev_iter, &rdev->netdev_list, list) {
+	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
 		if (wdev_iter == wdev)
 			continue;
 		if (!netif_running(wdev_iter->netdev))
-- 
1.7.10.4


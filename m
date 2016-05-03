Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39652 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755316AbcECNwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 09:52:21 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Date: Tue,  3 May 2016 16:52:04 +0300
Message-Id: <1462283524-1653-1-git-send-email-luca@coelho.fi> (sfid-20160503_155224_444165_2D894393)
Subject: [PATCH] cfg80211: make wdev_list accessible to drivers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no harm in having drivers read the list, since they can
use RCU protection or RTNL locking; allow this to not require
each and every driver to also implement its own bookkeeping.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |  5 +++++
 net/wireless/chan.c    |  2 +-
 net/wireless/core.c    | 17 ++++++++++-------
 net/wireless/core.h    |  3 +--
 net/wireless/nl80211.c | 16 ++++++++--------
 net/wireless/reg.c     |  2 +-
 net/wireless/sme.c     |  4 ++--
 net/wireless/sysfs.c   |  2 +-
 net/wireless/util.c    |  4 ++--
 9 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5f6e98ad..6392167 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3189,6 +3189,9 @@ struct wiphy_vendor_command {
  * @vht_capa_mod_mask:  Specify what VHT capabilities can be over-ridden.
  *	If null, then none can be over-ridden.
  *
+ * @wdev_list: the list of associated (virtual) interfaces; this list must
+ *	not be modified by the driver, but can be read with RTNL/RCU protection.
+ *
  * @max_acl_mac_addrs: Maximum number of MAC addresses that the device
  *	supports for ACL.
  *
@@ -3328,6 +3331,8 @@ struct wiphy {
 	const struct ieee80211_ht_cap *ht_capa_mod_mask;
 	const struct ieee80211_vht_cap *vht_capa_mod_mask;
 
+	struct list_head wdev_list;
+
 	/* the network namespace this phy lives in currently */
 	possible_net_t _net;
 
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index a6631fb..da49c0b 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -739,7 +739,7 @@ static bool cfg80211_ir_permissive_chan(struct wiphy *wiphy,
 	 * and thus fail the GO instantiation, consider only the interfaces of
 	 * the current registered device.
 	 */
-	list_for_each_entry(wdev, &rdev->wdev_list, list) {
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		struct ieee80211_channel *other_chan = NULL;
 		int r1, r2;
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 7f7b940..d25c82b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright 2015	Intel Deutschland GmbH
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -157,7 +158,7 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_NETNS_OK))
 		return -EOPNOTSUPP;
 
-	list_for_each_entry(wdev, &rdev->wdev_list, list) {
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (!wdev->netdev)
 			continue;
 		wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
@@ -171,7 +172,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		/* failed -- clean up to old netns */
 		net = wiphy_net(&rdev->wiphy);
 
-		list_for_each_entry_continue_reverse(wdev, &rdev->wdev_list,
+		list_for_each_entry_continue_reverse(wdev,
+						     &rdev->wiphy.wdev_list,
 						     list) {
 			if (!wdev->netdev)
 				continue;
@@ -230,7 +232,7 @@ void cfg80211_shutdown_all_interfaces(struct wiphy *wiphy)
 
 	ASSERT_RTNL();
 
-	list_for_each_entry(wdev, &rdev->wdev_list, list) {
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (wdev->netdev) {
 			dev_close(wdev->netdev);
 			continue;
@@ -298,7 +300,8 @@ void cfg80211_destroy_ifaces(struct cfg80211_registered_device *rdev)
 		kfree(item);
 		spin_unlock_irq(&rdev->destroy_list_lock);
 
-		list_for_each_entry_safe(wdev, tmp, &rdev->wdev_list, list) {
+		list_for_each_entry_safe(wdev, tmp,
+					 &rdev->wiphy.wdev_list, list) {
 			if (nlportid == wdev->owner_nlportid)
 				rdev_del_virtual_intf(rdev, wdev);
 		}
@@ -410,7 +413,7 @@ use_default_name:
 		dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
 	}
 
-	INIT_LIST_HEAD(&rdev->wdev_list);
+	INIT_LIST_HEAD(&rdev->wiphy.wdev_list);
 	INIT_LIST_HEAD(&rdev->beacon_registrations);
 	spin_lock_init(&rdev->beacon_registrations_lock);
 	spin_lock_init(&rdev->bss_lock);
@@ -799,7 +802,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
 	rdev->wiphy.registered = false;
 
-	WARN_ON(!list_empty(&rdev->wdev_list));
+	WARN_ON(!list_empty(&rdev->wiphy.wdev_list));
 
 	/*
 	 * First remove the hardware from everywhere, this makes
@@ -1021,7 +1024,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		spin_lock_init(&wdev->mgmt_registrations_lock);
 
 		wdev->identifier = ++rdev->wdev_id;
-		list_add_rcu(&wdev->list, &rdev->wdev_list);
+		list_add_rcu(&wdev->list, &rdev->wiphy.wdev_list);
 		rdev->devlist_generation++;
 		/* can only change netns with wiphy */
 		dev->features |= NETIF_F_NETNS_LOCAL;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index f75d760..025b7a5 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -50,8 +50,7 @@ struct cfg80211_registered_device {
 	/* wiphy index, internal only */
 	int wiphy_idx;
 
-	/* associated wireless interfaces, protected by rtnl or RCU */
-	struct list_head wdev_list;
+	/* protected by RTNL */
 	int devlist_generation, wdev_id;
 	int opencount;
 	wait_queue_head_t dev_wait;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9bc84a2..d759901 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -103,7 +103,7 @@ __cfg80211_wdev_from_attrs(struct net *netns, struct nlattr **attrs)
 		if (have_wdev_id && rdev->wiphy_idx != wiphy_idx)
 			continue;
 
-		list_for_each_entry(wdev, &rdev->wdev_list, list) {
+		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 			if (have_ifidx && wdev->netdev &&
 			    wdev->netdev->ifindex == ifidx) {
 				result = wdev;
@@ -149,7 +149,7 @@ __cfg80211_rdev_from_attrs(struct net *netns, struct nlattr **attrs)
 		tmp = cfg80211_rdev_by_wiphy_idx(wdev_id >> 32);
 		if (tmp) {
 			/* make sure wdev exists */
-			list_for_each_entry(wdev, &tmp->wdev_list, list) {
+			list_for_each_entry(wdev, &tmp->wiphy.wdev_list, list) {
 				if (wdev->identifier != (u32)wdev_id)
 					continue;
 				found = true;
@@ -535,7 +535,7 @@ static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 		*rdev = wiphy_to_rdev(wiphy);
 		*wdev = NULL;
 
-		list_for_each_entry(tmp, &(*rdev)->wdev_list, list) {
+		list_for_each_entry(tmp, &(*rdev)->wiphy.wdev_list, list) {
 			if (tmp->identifier == cb->args[1]) {
 				*wdev = tmp;
 				break;
@@ -2490,7 +2490,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 		}
 		if_idx = 0;
 
-		list_for_each_entry(wdev, &rdev->wdev_list, list) {
+		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 			if (if_idx < if_start) {
 				if_idx++;
 				continue;
@@ -2762,7 +2762,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		spin_lock_init(&wdev->mgmt_registrations_lock);
 
 		wdev->identifier = ++rdev->wdev_id;
-		list_add_rcu(&wdev->list, &rdev->wdev_list);
+		list_add_rcu(&wdev->list, &rdev->wiphy.wdev_list);
 		rdev->devlist_generation++;
 		break;
 	default:
@@ -3298,7 +3298,7 @@ static bool nl80211_get_ap_channel(struct cfg80211_registered_device *rdev,
 	struct wireless_dev *wdev;
 	bool ret = false;
 
-	list_for_each_entry(wdev, &rdev->wdev_list, list) {
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (wdev->iftype != NL80211_IFTYPE_AP &&
 		    wdev->iftype != NL80211_IFTYPE_P2P_GO)
 			continue;
@@ -10392,7 +10392,7 @@ static int nl80211_prepare_vendor_dump(struct sk_buff *skb,
 		*wdev = NULL;
 
 		if (cb->args[1]) {
-			list_for_each_entry(tmp, &(*rdev)->wdev_list, list) {
+			list_for_each_entry(tmp, &wiphy->wdev_list, list) {
 				if (tmp->identifier == cb->args[1] - 1) {
 					*wdev = tmp;
 					break;
@@ -13413,7 +13413,7 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 		    sched_scan_req->owner_nlportid == notify->portid)
 			schedule_scan_stop = true;
 
-		list_for_each_entry_rcu(wdev, &rdev->wdev_list, list) {
+		list_for_each_entry_rcu(wdev, &rdev->wiphy.wdev_list, list) {
 			cfg80211_mlme_unregister_socket(wdev, notify->portid);
 
 			if (wdev->owner_nlportid == notify->portid)
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e271dea..5dbac37 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1639,7 +1639,7 @@ static void reg_leave_invalid_chans(struct wiphy *wiphy)
 
 	ASSERT_RTNL();
 
-	list_for_each_entry(wdev, &rdev->wdev_list, list)
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list)
 		if (!reg_wdev_chan_valid(wiphy, wdev))
 			cfg80211_leave(rdev, wdev);
 }
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index d814279..584fdc3 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -223,7 +223,7 @@ void cfg80211_conn_work(struct work_struct *work)
 
 	rtnl_lock();
 
-	list_for_each_entry(wdev, &rdev->wdev_list, list) {
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (!wdev->netdev)
 			continue;
 
@@ -617,7 +617,7 @@ static bool cfg80211_is_all_idle(void)
 	 * count as new regulatory hints.
 	 */
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
-		list_for_each_entry(wdev, &rdev->wdev_list, list) {
+		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 			wdev_lock(wdev);
 			if (wdev->conn || wdev->current_bss)
 				is_all_idle = false;
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 9cee022..e46469b 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -91,7 +91,7 @@ static void cfg80211_leave_all(struct cfg80211_registered_device *rdev)
 {
 	struct wireless_dev *wdev;
 
-	list_for_each_entry(wdev, &rdev->wdev_list, list)
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list)
 		cfg80211_leave(rdev, wdev);
 }
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 7cfabd6..219bd19 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -986,7 +986,7 @@ void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev)
 
 	ASSERT_RTNL();
 
-	list_for_each_entry(wdev, &rdev->wdev_list, list)
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list)
 		cfg80211_process_wdev_events(wdev);
 }
 
@@ -1560,7 +1560,7 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 	if (!beacon_int)
 		return -EINVAL;
 
-	list_for_each_entry(wdev, &rdev->wdev_list, list) {
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (!wdev->beacon_interval)
 			continue;
 		if (wdev->beacon_interval != beacon_int) {
-- 
2.8.0.rc3


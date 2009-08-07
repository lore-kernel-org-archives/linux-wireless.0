Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbZHGORo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 10:17:44 -0400
Subject: [PATCH] nl80211: add generation number to all dumps
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 16:17:38 +0200
Message-Id: <1249654658.7194.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order for userspace to be able to figure out whether
it obtained a consistent snapshot of data or not when
using netlink dumps, we need to have a generation number
in each dump message that indicates whether the list has
changed or not -- its value is arbitrary.

This patch adds such a number to all dumps, this needs
some mac80211 involvement to keep track of a generation
number to start with when adding/removing mesh paths or
stations.

The wiphy and netdev lists can be fully handled within
cfg80211, of course, but generation numbers need to be
stored there as well.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/nl80211.h     |   17 ++++++++++++-----
 include/net/cfg80211.h      |   12 ++++++++++++
 net/mac80211/cfg.c          |    4 ++++
 net/mac80211/ieee80211_i.h  |    1 +
 net/mac80211/mesh.h         |    2 ++
 net/mac80211/mesh_pathtbl.c |    5 +++++
 net/mac80211/sta_info.c     |    2 ++
 net/wireless/core.c         |    5 +++++
 net/wireless/core.h         |    2 ++
 net/wireless/nl80211.c      |   31 +++++++++++++++++++++----------
 net/wireless/scan.c         |    1 +
 11 files changed, 67 insertions(+), 15 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2009-08-07 16:13:57.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-08-07 16:13:58.000000000 +0200
@@ -480,10 +480,6 @@ enum nl80211_commands {
  * @NL80211_ATTR_SCAN_FREQUENCIES: nested attribute with frequencies (in MHz)
  * @NL80211_ATTR_SCAN_SSIDS: nested attribute with SSIDs, leave out for passive
  *	scanning and include a zero-length SSID (wildcard) for wildcard scan
- * @NL80211_ATTR_SCAN_GENERATION: the scan generation increases whenever the
- *	scan result list changes (BSS expired or added) so that applications
- *	can verify that they got a single, consistent snapshot (when all dump
- *	messages carried the same generation number)
  * @NL80211_ATTR_BSS: scan result BSS
  *
  * @NL80211_ATTR_REG_INITIATOR: indicates who requested the regulatory domain
@@ -580,6 +576,14 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_PID: Process ID of a network namespace.
  *
+ * @NL80211_ATTR_GENERATION: Used to indicate consistent snapshots for
+ *	dumps. This number increases whenever the object list being
+ *	dumped changes, and as such userspace can verify that it has
+ *	obtained a complete and consistent snapshot by verifying that
+ *	all dump messages contain the same generation number. If it
+ *	changed then the list changed and the dump should be repeated
+ *	completely from scratch.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -651,7 +655,7 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SCAN_FREQUENCIES,
 	NL80211_ATTR_SCAN_SSIDS,
-	NL80211_ATTR_SCAN_GENERATION,
+	NL80211_ATTR_GENERATION, /* replaces old SCAN_GENERATION */
 	NL80211_ATTR_BSS,
 
 	NL80211_ATTR_REG_INITIATOR,
@@ -716,6 +720,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
 
+/* source-level API compatibility */
+#define NL80211_ATTR_SCAN_GENERATION NL80211_ATTR_GENERATION
+
 /*
  * Allow user space programs to use #ifdef on new attributes by defining them
  * here
--- wireless-testing.orig/net/wireless/nl80211.c	2009-08-07 16:13:57.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-08-07 16:13:58.000000000 +0200
@@ -408,6 +408,9 @@ static int nl80211_send_wiphy(struct sk_
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, dev->wiphy_idx);
 	NLA_PUT_STRING(msg, NL80211_ATTR_WIPHY_NAME, wiphy_name(&dev->wiphy));
 
+	NLA_PUT_U32(msg, NL80211_ATTR_GENERATION,
+		    cfg80211_rdev_list_generation);
+
 	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_RETRY_SHORT,
 		   dev->wiphy.retry_short);
 	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_RETRY_LONG,
@@ -825,6 +828,11 @@ static int nl80211_send_iface(struct sk_
 	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
 	NLA_PUT_STRING(msg, NL80211_ATTR_IFNAME, dev->name);
 	NLA_PUT_U32(msg, NL80211_ATTR_IFTYPE, dev->ieee80211_ptr->iftype);
+
+	NLA_PUT_U32(msg, NL80211_ATTR_GENERATION,
+		    rdev->devlist_generation ^
+			(cfg80211_rdev_list_generation << 2));
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
@@ -838,12 +846,12 @@ static int nl80211_dump_interface(struct
 	int if_idx = 0;
 	int wp_start = cb->args[0];
 	int if_start = cb->args[1];
-	struct cfg80211_registered_device *dev;
+	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
 
 	mutex_lock(&cfg80211_mutex);
-	list_for_each_entry(dev, &cfg80211_rdev_list, list) {
-		if (!net_eq(wiphy_net(&dev->wiphy), sock_net(skb->sk)))
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		if (!net_eq(wiphy_net(&rdev->wiphy), sock_net(skb->sk)))
 			continue;
 		if (wp_idx < wp_start) {
 			wp_idx++;
@@ -851,21 +859,21 @@ static int nl80211_dump_interface(struct
 		}
 		if_idx = 0;
 
-		mutex_lock(&dev->devlist_mtx);
-		list_for_each_entry(wdev, &dev->netdev_list, list) {
+		mutex_lock(&rdev->devlist_mtx);
+		list_for_each_entry(wdev, &rdev->netdev_list, list) {
 			if (if_idx < if_start) {
 				if_idx++;
 				continue;
 			}
 			if (nl80211_send_iface(skb, NETLINK_CB(cb->skb).pid,
 					       cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					       dev, wdev->netdev) < 0) {
-				mutex_unlock(&dev->devlist_mtx);
+					       rdev, wdev->netdev) < 0) {
+				mutex_unlock(&rdev->devlist_mtx);
 				goto out;
 			}
 			if_idx++;
 		}
-		mutex_unlock(&dev->devlist_mtx);
+		mutex_unlock(&rdev->devlist_mtx);
 
 		wp_idx++;
 	}
@@ -1616,6 +1624,8 @@ static int nl80211_send_station(struct s
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
 	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
 
+	NLA_PUT_U32(msg, NL80211_ATTR_GENERATION, sinfo->generation);
+
 	sinfoattr = nla_nest_start(msg, NL80211_ATTR_STA_INFO);
 	if (!sinfoattr)
 		goto nla_put_failure;
@@ -2101,6 +2111,8 @@ static int nl80211_send_mpath(struct sk_
 	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, dst);
 	NLA_PUT(msg, NL80211_ATTR_MPATH_NEXT_HOP, ETH_ALEN, next_hop);
 
+	NLA_PUT_U32(msg, NL80211_ATTR_GENERATION, pinfo->generation);
+
 	pinfoattr = nla_nest_start(msg, NL80211_ATTR_MPATH_INFO);
 	if (!pinfoattr)
 		goto nla_put_failure;
@@ -3090,8 +3102,7 @@ static int nl80211_send_bss(struct sk_bu
 	if (!hdr)
 		return -1;
 
-	NLA_PUT_U32(msg, NL80211_ATTR_SCAN_GENERATION,
-		    rdev->bss_generation);
+	NLA_PUT_U32(msg, NL80211_ATTR_GENERATION, rdev->bss_generation);
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex);
 
 	bss = nla_nest_start(msg, NL80211_ATTR_BSS);
--- wireless-testing.orig/net/wireless/core.c	2009-08-07 16:13:57.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-08-07 16:13:58.000000000 +0200
@@ -32,6 +32,7 @@ MODULE_DESCRIPTION("wireless configurati
  * only read the list, and that can happen quite
  * often because we need to do it for each command */
 LIST_HEAD(cfg80211_rdev_list);
+int cfg80211_rdev_list_generation;
 
 /*
  * This is used to protect the cfg80211_rdev_list
@@ -511,6 +512,7 @@ int wiphy_register(struct wiphy *wiphy)
 	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
 
 	list_add(&rdev->list, &cfg80211_rdev_list);
+	cfg80211_rdev_list_generation++;
 
 	mutex_unlock(&cfg80211_mutex);
 
@@ -593,6 +595,7 @@ void wiphy_unregister(struct wiphy *wiph
 	reg_device_remove(wiphy);
 
 	list_del(&rdev->list);
+	cfg80211_rdev_list_generation++;
 	device_del(&rdev->wiphy.dev);
 	debugfs_remove(rdev->wiphy.debugfsdir);
 
@@ -653,6 +656,7 @@ static int cfg80211_netdev_notifier_call
 		spin_lock_init(&wdev->event_lock);
 		mutex_lock(&rdev->devlist_mtx);
 		list_add(&wdev->list, &rdev->netdev_list);
+		rdev->devlist_generation++;
 		/* can only change netns with wiphy */
 		dev->features |= NETIF_F_NETNS_LOCAL;
 
@@ -733,6 +737,7 @@ static int cfg80211_netdev_notifier_call
 		if (!list_empty(&wdev->list)) {
 			sysfs_remove_link(&dev->dev.kobj, "phy80211");
 			list_del_init(&wdev->list);
+			rdev->devlist_generation++;
 			mutex_destroy(&wdev->mtx);
 #ifdef CONFIG_WIRELESS_EXT
 			kfree(wdev->wext.keys);
--- wireless-testing.orig/net/wireless/core.h	2009-08-07 16:13:57.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-08-07 16:13:58.000000000 +0200
@@ -49,6 +49,7 @@ struct cfg80211_registered_device {
 	/* associate netdev list */
 	struct mutex devlist_mtx;
 	struct list_head netdev_list;
+	int devlist_generation;
 
 	/* BSSes/scanning */
 	spinlock_t bss_lock;
@@ -101,6 +102,7 @@ bool wiphy_idx_valid(int wiphy_idx)
 
 extern struct mutex cfg80211_mutex;
 extern struct list_head cfg80211_rdev_list;
+extern int cfg80211_rdev_list_generation;
 
 #define assert_cfg80211_lock() WARN_ON(!mutex_is_locked(&cfg80211_mutex))
 
--- wireless-testing.orig/include/net/cfg80211.h	2009-08-07 16:13:57.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-08-07 16:13:58.000000000 +0200
@@ -372,6 +372,10 @@ struct rate_info {
  * @txrate: current unicast bitrate to this station
  * @rx_packets: packets received from this station
  * @tx_packets: packets transmitted to this station
+ * @generation: generation number for nl80211 dumps.
+ *	This number should increase every time the list of stations
+ *	changes, i.e. when a station is added or removed, so that
+ *	userspace can tell whether it got a consistent snapshot.
  */
 struct station_info {
 	u32 filled;
@@ -385,6 +389,8 @@ struct station_info {
 	struct rate_info txrate;
 	u32 rx_packets;
 	u32 tx_packets;
+
+	int generation;
 };
 
 /**
@@ -444,6 +450,10 @@ enum mpath_info_flags {
  * @flags: mesh path flags
  * @discovery_timeout: total mesh path discovery timeout, in msecs
  * @discovery_retries: mesh path discovery retries
+ * @generation: generation number for nl80211 dumps.
+ *	This number should increase every time the list of mesh paths
+ *	changes, i.e. when a station is added or removed, so that
+ *	userspace can tell whether it got a consistent snapshot.
  */
 struct mpath_info {
 	u32 filled;
@@ -454,6 +464,8 @@ struct mpath_info {
 	u32 discovery_timeout;
 	u8 discovery_retries;
 	u8 flags;
+
+	int generation;
 };
 
 /**
--- wireless-testing.orig/net/mac80211/cfg.c	2009-08-07 16:13:57.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-08-07 16:13:58.000000000 +0200
@@ -323,6 +323,8 @@ static void sta_set_sinfo(struct sta_inf
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	sinfo->generation = sdata->local->sta_generation;
+
 	sinfo->filled = STATION_INFO_INACTIVE_TIME |
 			STATION_INFO_RX_BYTES |
 			STATION_INFO_TX_BYTES |
@@ -909,6 +911,8 @@ static void mpath_set_pinfo(struct mesh_
 	else
 		memset(next_hop, 0, ETH_ALEN);
 
+	pinfo->generation = mesh_paths_generation;
+
 	pinfo->filled = MPATH_INFO_FRAME_QLEN |
 			MPATH_INFO_DSN |
 			MPATH_INFO_METRIC |
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-08-07 16:13:57.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-08-07 16:13:58.000000000 +0200
@@ -678,6 +678,7 @@ struct ieee80211_local {
 	struct list_head sta_list;
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
+	int sta_generation;
 
 	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-08-07 16:13:57.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2009-08-07 16:13:58.000000000 +0200
@@ -349,6 +349,7 @@ int sta_info_insert(struct sta_info *sta
 		goto out_free;
 	}
 	list_add(&sta->list, &local->sta_list);
+	local->sta_generation++;
 	local->num_sta++;
 	sta_info_hash_add(local, sta);
 
@@ -485,6 +486,7 @@ static void __sta_info_unlink(struct sta
 	}
 
 	local->num_sta--;
+	local->sta_generation++;
 
 	if (local->ops->sta_notify) {
 		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
--- wireless-testing.orig/net/mac80211/mesh.h	2009-08-07 16:13:57.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.h	2009-08-07 16:13:58.000000000 +0200
@@ -265,6 +265,8 @@ void mesh_path_discard_frame(struct sk_b
 void mesh_path_quiesce(struct ieee80211_sub_if_data *sdata);
 void mesh_path_restart(struct ieee80211_sub_if_data *sdata);
 
+extern int mesh_paths_generation;
+
 #ifdef CONFIG_MAC80211_MESH
 extern int mesh_allocated;
 
--- wireless-testing.orig/net/mac80211/mesh_pathtbl.c	2009-08-07 16:13:57.000000000 +0200
+++ wireless-testing/net/mac80211/mesh_pathtbl.c	2009-08-07 16:14:16.000000000 +0200
@@ -38,6 +38,8 @@ struct mpath_node {
 static struct mesh_table *mesh_paths;
 static struct mesh_table *mpp_paths; /* Store paths for MPP&MAP */
 
+int mesh_paths_generation;
+
 /* This lock will have the grow table function as writer and add / delete nodes
  * as readers. When reading the table (i.e. doing lookups) we are well protected
  * by RCU
@@ -243,6 +245,8 @@ int mesh_path_add(u8 *dst, struct ieee80
 		mesh_paths->mean_chain_len * (mesh_paths->hash_mask + 1))
 		grow = 1;
 
+	mesh_paths_generation++;
+
 	spin_unlock(&mesh_paths->hashwlock[hash_idx]);
 	read_unlock(&pathtbl_resize_lock);
 	if (grow) {
@@ -484,6 +488,7 @@ int mesh_path_del(u8 *addr, struct ieee8
 
 	err = -ENXIO;
 enddel:
+	mesh_paths_generation++;
 	spin_unlock(&mesh_paths->hashwlock[hash_idx]);
 	read_unlock(&pathtbl_resize_lock);
 	return err;
--- wireless-testing.orig/net/wireless/scan.c	2009-08-07 16:13:57.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-08-07 16:13:58.000000000 +0200
@@ -562,6 +562,7 @@ void cfg80211_unlink_bss(struct wiphy *w
 	spin_lock_bh(&dev->bss_lock);
 
 	list_del(&bss->list);
+	dev->bss_generation++;
 	rb_erase(&bss->rbn, &dev->bss_tree);
 
 	spin_unlock_bh(&dev->bss_lock);



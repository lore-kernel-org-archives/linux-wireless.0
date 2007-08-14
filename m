Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760030AbXHNQTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 12:19:33 -0400
Subject: [RFC] the recently discussed flags patch
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 18:21:55 +0200
Message-Id: <1187108515.4037.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

After noticing that set_multicast_list is totally useless but now we can
get a new callback from the netdev when the RX flags change, I decided
to go ahead and try that. Below is the patch introducing the filter
flags to mac80211.

set_multicast_list is removed completely because it's of no use right
now, if it's added back it can be done right. All the hard/soft monitor
business is removed, we simply update the flags to the driver and let it
do its best. Maybe it should be able to update the flags value so we can
tell userspace that things failed...

Please do write comments. I want to update drivers too but not before
I've seen comments. Even write if you like it.

johannes
---
 include/net/mac80211.h        |   35 +++++---
 net/mac80211/debugfs_netdev.c |   16 ---
 net/mac80211/ieee80211.c      |  176 +++++++++++++++++++-----------------------
 net/mac80211/ieee80211_i.h    |    5 -
 net/mac80211/rx.c             |    4 
 5 files changed, 108 insertions(+), 128 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-14 17:29:27.180673066 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-14 18:16:12.500673066 +0200
@@ -489,9 +489,7 @@ struct ieee80211_hw {
 	 */
 #define IEEE80211_HW_DEVICE_STRIPS_MIC (1<<8)
 
-	/* Device is capable of performing full monitor mode even during
-	 * normal operation. */
-#define IEEE80211_HW_MONITOR_DURING_OPER (1<<9)
+/* hole at 9 */
 
 	/* Device does not need BSSID filter set to broadcast in order to
 	 * receive all probe responses while scanning */
@@ -542,6 +540,21 @@ static inline void SET_IEEE80211_PERM_AD
 	memcpy(hw->wiphy->perm_addr, addr, ETH_ALEN);
 }
 
+/*
+ * flags for change_filter_flags()
+ *
+ * Note that e.g. if PROMISC_IN_BSS is unset then
+ * you should still do MAC address filtering if
+ * possible even if OTHER_BSS is set to indicate
+ * no BSSID filtering should be done.
+ */
+#define FIF_PROMISC_IN_BSS	0x01
+#define FIF_ALLMULTI		0x02
+#define FIF_FCSFAIL		0x04
+#define FIF_PLCPFAIL		0x08
+#define FIF_CONTROL		0x10
+#define FIF_OTHER_BSS		0x20
+
 /* Configuration block used by the low-level driver to tell the 802.11 code
  * about supported hardware features and to pass function pointers to callback
  * functions. */
@@ -595,15 +608,13 @@ struct ieee80211_ops {
 	int (*config_interface)(struct ieee80211_hw *hw,
 				int if_id, struct ieee80211_if_conf *conf);
 
-	/* ieee80211 drivers do not have access to the &struct net_device
-	 * that is (are) connected with their device. Hence (and because
-	 * we need to combine the multicast lists and flags for multiple
-	 * virtual interfaces), they cannot assign set_multicast_list.
-	 * The parameters here replace dev->flags and dev->mc_count,
-	 * dev->mc_list is replaced by calling ieee80211_get_mc_list_item.
-	 * Must be atomic. */
-	void (*set_multicast_list)(struct ieee80211_hw *hw,
-				   unsigned short flags, int mc_count);
+	/* Change filter flags, see above for FIF_* constants.
+	 *
+	 * Must be atomic due to running under the tx lock.
+	 * This callback is required.
+	 */
+	void (*change_filter_flags)(struct ieee80211_hw *hw,
+				    int changed_flags, int total_flags);
 
 	/* Set TIM bit handler. If the hardware/firmware takes care of beacon
 	 * generation, IEEE 802.11 code uses this function to tell the
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-14 17:24:41.250673066 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-14 18:18:43.850673066 +0200
@@ -118,6 +118,24 @@ static int ieee80211_change_mtu(struct n
 	return 0;
 }
 
+static inline void set_local_flag(struct ieee80211_local *local,
+				  int flag, int *changed)
+{
+	if (!(local->filter_flags & flag)) {
+		*changed |= flag;
+		local->filter_flags |= flag;
+	}
+}
+
+static inline void clear_local_flag(struct ieee80211_local *local,
+				    int flag, int *changed)
+{
+	if (local->filter_flags & flag) {
+		*changed |= flag;
+		local->filter_flags &= ~flag;
+	}
+}
+
 static inline int identical_mac_addr_allowed(int type1, int type2)
 {
 	return (type1 == IEEE80211_IF_TYPE_MNTR ||
@@ -134,37 +152,6 @@ static inline int identical_mac_addr_all
 		  type2 == IEEE80211_IF_TYPE_VLAN)));
 }
 
-/* Check if running monitor interfaces should go to a "soft monitor" mode
- * and switch them if necessary. */
-static inline void ieee80211_start_soft_monitor(struct ieee80211_local *local)
-{
-	struct ieee80211_if_init_conf conf;
-
-	if (local->open_count && local->open_count == local->monitors &&
-	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER) &&
-	    local->ops->remove_interface) {
-		conf.if_id = -1;
-		conf.type = IEEE80211_IF_TYPE_MNTR;
-		conf.mac_addr = NULL;
-		local->ops->remove_interface(local_to_hw(local), &conf);
-	}
-}
-
-/* Check if running monitor interfaces should go to a "hard monitor" mode
- * and switch them if necessary. */
-static void ieee80211_start_hard_monitor(struct ieee80211_local *local)
-{
-	struct ieee80211_if_init_conf conf;
-
-	if (local->open_count && local->open_count == local->monitors &&
-	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER)) {
-		conf.if_id = -1;
-		conf.type = IEEE80211_IF_TYPE_MNTR;
-		conf.mac_addr = NULL;
-		local->ops->add_interface(local_to_hw(local), &conf);
-	}
-}
-
 static void ieee80211_if_open(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -202,29 +189,31 @@ static int ieee80211_open(struct net_dev
 	    is_zero_ether_addr(sdata->u.wds.remote_addr))
 		return -ENOLINK;
 
-	if (sdata->type == IEEE80211_IF_TYPE_MNTR && local->open_count &&
-	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER)) {
-		/* run the interface in a "soft monitor" mode */
+	ieee80211_if_open(dev);
+
+	if (sdata->type == IEEE80211_IF_TYPE_MNTR) {
+		int change = 0;
+
+		if (!local->monitors) {
+			set_local_flag(local, FIF_CONTROL, &change);
+			set_local_flag(local, FIF_OTHER_BSS, &change);
+			local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
+			local->ops->change_filter_flags(local_to_hw(local),
+							change,
+							local->filter_flags);
+			ieee80211_hw_config(local);
+		}
+
 		local->monitors++;
 		local->open_count++;
-		local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
 		return 0;
 	}
-	ieee80211_if_open(dev);
-	ieee80211_start_soft_monitor(local);
 
 	conf.if_id = dev->ifindex;
 	conf.type = sdata->type;
-	if (sdata->type == IEEE80211_IF_TYPE_MNTR)
-		conf.mac_addr = NULL;
-	else
-		conf.mac_addr = dev->dev_addr;
 	res = local->ops->add_interface(local_to_hw(local), &conf);
-	if (res) {
-		if (sdata->type == IEEE80211_IF_TYPE_MNTR)
-			ieee80211_start_hard_monitor(local);
+	if (res)
 		return res;
-	}
 
 	if (local->open_count == 0) {
 		res = 0;
@@ -252,13 +241,8 @@ static int ieee80211_open(struct net_dev
 	}
 	local->open_count++;
 
-	if (sdata->type == IEEE80211_IF_TYPE_MNTR) {
-		local->monitors++;
-		local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
-	} else {
-		ieee80211_if_config(dev);
-		ieee80211_reset_erp_info(dev);
-	}
+	ieee80211_if_config(dev);
+	ieee80211_reset_erp_info(dev);
 
 	if (sdata->type == IEEE80211_IF_TYPE_STA &&
 	    !local->user_space_mlme)
@@ -300,14 +284,22 @@ static int ieee80211_stop(struct net_dev
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->type == IEEE80211_IF_TYPE_MNTR &&
-	    local->open_count > 1 &&
-	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER)) {
-		/* remove "soft monitor" interface */
-		local->open_count--;
+	if (sdata->type == IEEE80211_IF_TYPE_MNTR) {
+		int change = 0;
+
 		local->monitors--;
-		if (!local->monitors)
+		local->open_count--;
+
+		if (!local->monitors) {
+			clear_local_flag(local, FIF_CONTROL, &change);
+			clear_local_flag(local, FIF_OTHER_BSS, &change);
 			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
+			local->ops->change_filter_flags(local_to_hw(local),
+							change,
+							local->filter_flags);
+			ieee80211_hw_config(local);
+		}
+
 		return 0;
 	}
 
@@ -338,8 +330,6 @@ static int ieee80211_stop(struct net_dev
 		local->ops->remove_interface(local_to_hw(local), &conf);
 	}
 
-	ieee80211_start_hard_monitor(local);
-
 	return 0;
 }
 
@@ -354,47 +344,44 @@ static inline void netif_tx_lock_nested(
 	dev->xmit_lock_owner = smp_processor_id();
 }
 
-static void ieee80211_set_multicast_list(struct net_device *dev)
+static void ieee80211_change_rx_flags(struct net_device *dev, int change)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	unsigned short flags;
+	int changed_flags = 0;
 
+	/* why? we need some lock to lock local->filter_flags, but this? */
 	netif_tx_lock_nested(local->mdev, TX_LOCK_MASTER);
-	if (((dev->flags & IFF_ALLMULTI) != 0) ^ (sdata->allmulti != 0)) {
-		if (sdata->allmulti) {
-			sdata->allmulti = 0;
-			local->iff_allmultis--;
-		} else {
-			sdata->allmulti = 1;
+
+	if (change & IFF_ALLMULTI) {
+		if (dev->flags & IFF_ALLMULTI)
 			local->iff_allmultis++;
-		}
+		else
+			local->iff_allmultis--;
 	}
-	if (((dev->flags & IFF_PROMISC) != 0) ^ (sdata->promisc != 0)) {
-		if (sdata->promisc) {
-			sdata->promisc = 0;
-			local->iff_promiscs--;
-		} else {
-			sdata->promisc = 1;
+
+	if (change & IFF_PROMISC) {
+		if (dev->flags & IFF_PROMISC)
 			local->iff_promiscs++;
-		}
-	}
-	if (dev->mc_count != sdata->mc_count) {
-		local->mc_count = local->mc_count - sdata->mc_count +
-				  dev->mc_count;
-		sdata->mc_count = dev->mc_count;
-	}
-	if (local->ops->set_multicast_list) {
-		flags = local->mdev->flags;
-		if (local->iff_allmultis)
-			flags |= IFF_ALLMULTI;
-		if (local->iff_promiscs)
-			flags |= IFF_PROMISC;
-		read_lock(&local->sub_if_lock);
-		local->ops->set_multicast_list(local_to_hw(local), flags,
-					      local->mc_count);
-		read_unlock(&local->sub_if_lock);
+		else
+			local->iff_promiscs--;
 	}
+
+	if (local->iff_promiscs)
+		set_local_flag(local, FIF_PROMISC_IN_BSS, &changed_flags);
+	else
+		clear_local_flag(local, FIF_PROMISC_IN_BSS, &changed_flags);
+
+	if (local->iff_allmultis)
+		set_local_flag(local, FIF_ALLMULTI, &changed_flags);
+	else
+		clear_local_flag(local, FIF_ALLMULTI, &changed_flags);
+
+	read_lock(&local->sub_if_lock);
+	local->ops->change_filter_flags(local_to_hw(local),
+					changed_flags,
+					local->filter_flags);
+	read_unlock(&local->sub_if_lock);
+
 	netif_tx_unlock(local->mdev);
 }
 
@@ -405,7 +392,7 @@ void ieee80211_if_setup(struct net_devic
 	dev->hard_start_xmit = ieee80211_subif_start_xmit;
 	dev->wireless_handlers = &ieee80211_iw_handler_def;
 	dev->do_ioctl = ieee80211_ioctl;
-	dev->set_multicast_list = ieee80211_set_multicast_list;
+	dev->change_rx_flags = ieee80211_change_rx_flags;
 	dev->change_mtu = ieee80211_change_mtu;
 	dev->get_stats = ieee80211_get_stats;
 	dev->open = ieee80211_open;
@@ -971,6 +958,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	BUG_ON(!ops->tx);
 	BUG_ON(!ops->config);
 	BUG_ON(!ops->add_interface);
+	BUG_ON(!ops->change_filter_flags);
 	local->ops = ops;
 
 	/* for now, mdev needs sub_if_data :/ */
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-14 17:34:28.570673066 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-14 17:53:39.940673066 +0200
@@ -312,9 +312,6 @@ struct ieee80211_sub_if_data {
 	struct net_device *dev;
 	struct ieee80211_local *local;
 
-	int mc_count;
-	unsigned int allmulti:1;
-	unsigned int promisc:1;
 	unsigned int use_protection:1; /* CTS protect ERP frames */
 
 	/* use short preamble with IEEE 802.11b: this flag is set when the AP
@@ -465,6 +462,7 @@ struct ieee80211_local {
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
 	int open_count;
 	int monitors;
+	int filter_flags; /* FIF_* */
 	struct iw_statistics wstats;
 	u8 wstats_flags;
 	int tx_headroom; /* required headroom for hardware/radiotap */
@@ -495,7 +493,6 @@ struct ieee80211_local {
 	struct ieee80211_tx_stored_packet pending_packet[NUM_TX_DATA_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
 
-	int mc_count;	/* total count of multicast entries in all interfaces */
 	int iff_allmultis, iff_promiscs;
 			/* number of interfaces with corresponding IFF_ flags */
 
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-14 17:52:32.410673066 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-14 17:54:03.090673066 +0200
@@ -1389,7 +1389,7 @@ static int prepare_for_handlers(struct i
 		} else if (!multicast &&
 			   compare_ether_addr(sdata->dev->dev_addr,
 					      hdr->addr1) != 0) {
-			if (!sdata->promisc)
+			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
 			rx->u.rx.ra_match = 0;
 		}
@@ -1404,7 +1404,7 @@ static int prepare_for_handlers(struct i
 		} else if (!multicast &&
 			   compare_ether_addr(sdata->dev->dev_addr,
 					      hdr->addr1) != 0) {
-			if (!sdata->promisc)
+			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
 			rx->u.rx.ra_match = 0;
 		} else if (!rx->sta)
--- wireless-dev.orig/net/mac80211/debugfs_netdev.c	2007-08-14 18:03:59.100673066 +0200
+++ wireless-dev/net/mac80211/debugfs_netdev.c	2007-08-14 18:04:29.050673066 +0200
@@ -425,20 +425,6 @@ IEEE80211_IF_FILE(peer, u.wds.remote_add
 /* VLAN attributes */
 IEEE80211_IF_FILE(vlan_id, u.vlan.id, DEC);
 
-/* MONITOR attributes */
-static ssize_t ieee80211_if_fmt_mode(
-	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
-{
-	struct ieee80211_local *local = sdata->local;
-
-	return scnprintf(buf, buflen, "%s\n",
-			 ((local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER) ||
-			  local->open_count == local->monitors) ?
-			 "hard" : "soft");
-}
-__IEEE80211_IF_FILE(mode);
-
-
 #define DEBUGFS_ADD(name, type)\
 	sdata->debugfs.type.name = debugfs_create_file(#name, 0444,\
 		sdata->debugfsdir, sdata, &name##_ops);
@@ -542,7 +528,6 @@ static void add_vlan_files(struct ieee80
 
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(mode, monitor);
 }
 
 static void add_files(struct ieee80211_sub_if_data *sdata)
@@ -671,7 +656,6 @@ static void del_vlan_files(struct ieee80
 
 static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_DEL(mode, monitor);
 }
 
 static void del_files(struct ieee80211_sub_if_data *sdata, int type)



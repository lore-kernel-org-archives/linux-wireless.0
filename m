Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60932 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbXHOKgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:36:51 -0400
Subject: Re: [RFC] the recently discussed flags patch
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <1187108515.4037.3.camel@johannes.berg>
References: <1187108515.4037.3.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 00:56:19 +0200
Message-Id: <1187132179.31200.18.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's one that semi-updates drivers and actually works too. I need help
with the ralink drivers, don't understand how they handle flag changes,
so it won't even compile. b43 I've tested, but all other drivers will
probably not behave optimally/work at all.

---
 drivers/net/wireless/adm8211.c                  |   29 +-
 drivers/net/wireless/b43/b43.h                  |   15 -
 drivers/net/wireless/b43/main.c                 |  222 ++++++++--------
 drivers/net/wireless/iwl-base.c                 |   24 +
 drivers/net/wireless/rtl8187_dev.c              |   19 +
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.c |   50 +--
 include/net/mac80211.h                          |  109 +++++---
 net/mac80211/debugfs_netdev.c                   |   16 -
 net/mac80211/ieee80211.c                        |  319 ++++++++++--------------
 net/mac80211/ieee80211_i.h                      |    5 
 net/mac80211/rx.c                               |   16 -
 11 files changed, 427 insertions(+), 397 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-15 00:22:42.620200043 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-15 00:43:06.230200043 +0200
@@ -336,7 +336,6 @@ enum ieee80211_if_types {
  * @mac_addr: pointer to MAC address of the interface. This pointer is valid
  *	until the interface is removed (i.e. it cannot be used after
  *	remove_interface() callback was called for this interface).
- *	This pointer will be %NULL for monitor interfaces, be careful.
  *
  * This structure is used in add_interface() and remove_interface()
  * callbacks of &struct ieee80211_hw.
@@ -489,9 +488,7 @@ struct ieee80211_hw {
 	 */
 #define IEEE80211_HW_DEVICE_STRIPS_MIC (1<<8)
 
-	/* Device is capable of performing full monitor mode even during
-	 * normal operation. */
-#define IEEE80211_HW_MONITOR_DURING_OPER (1<<9)
+/* hole at 9 */
 
 	/* Device does not need BSSID filter set to broadcast in order to
 	 * receive all probe responses while scanning */
@@ -542,6 +539,21 @@ static inline void SET_IEEE80211_PERM_AD
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
@@ -557,32 +569,55 @@ struct ieee80211_ops {
 	/* Handler for performing hardware reset. */
 	int (*reset)(struct ieee80211_hw *hw);
 
-	/* Handler that is called when any netdevice attached to the hardware
-	 * device is set UP for the first time. This can be used, e.g., to
-	 * enable interrupts and beacon sending. */
-	int (*open)(struct ieee80211_hw *hw);
-
-	/* Handler that is called when the last netdevice attached to the
-	 * hardware device is set DOWN. This can be used, e.g., to disable
-	 * interrupts and beacon sending. */
-	int (*stop)(struct ieee80211_hw *hw);
-
-	/* Handler for asking a driver if a new interface can be added (or,
-	 * more exactly, set UP). If the handler returns zero, the interface
-	 * is added. Driver should perform any initialization it needs prior
-	 * to returning zero. By returning non-zero addition of the interface
-	 * is inhibited. Unless monitor_during_oper is set, it is guaranteed
-	 * that monitor interfaces and normal interfaces are mutually
-	 * exclusive. If assigned, the open() handler is called after
-	 * add_interface() if this is the first device added. The
-	 * add_interface() callback has to be assigned because it is the only
-	 * way to obtain the requested MAC address for any interface.
+	/*
+	 * Called before the first netdevice attached to the hardware
+	 * is enabled. This should turn on the hardware and must turn on
+	 * frame reception (for possibly enabled monitor interfaces.)
+	 * Returns negative error codes, these may be seen in userspace,
+	 * or zero.
+	 * When the device is started it should not have a MAC address
+	 * to avoid acknowledging frames before a non-monitor device
+	 * is added.
+	 *
+	 * Must be implemented.
+	 */
+	int (*start)(struct ieee80211_hw *hw);
+
+	/*
+	 * Called after last netdevice attached to the hardware
+	 * is disabled. This should turn off the hardware (at least
+	 * it must turn off frame reception.)
+	 * May be called right after add_interface if that rejects
+	 * an interface.
+	 *
+	 * Must be implemented.
+	 */
+	void (*stop)(struct ieee80211_hw *hw);
+
+	/*
+	 * Called when a netdevice attached to the hardware is enabled.
+	 * Because it is not called for monitor mode devices, open()
+	 * and stop() must be implemented.
+	 * The driver should perform any initialization it needs before
+	 * the device can be enabled. The initial configuration for the
+	 * interface is given in the conf parameter.
+	 *
+	 * Must be implemented.
 	 */
 	int (*add_interface)(struct ieee80211_hw *hw,
 			     struct ieee80211_if_init_conf *conf);
 
-	/* Notify a driver that an interface is going down. The stop() handler
-	 * is called prior to this if this is a last interface. */
+	/*
+	 * Notifies a driver that an interface is going down. The stop() handler
+	 * is called after this if it is the last interface and no monitor
+	 * interfaces are present.
+	 * When all interfaces are removed, the MAC address in the hardware
+	 * must be cleared so the device no longer acknowledges packets,
+	 * the mac_addr member of the conf structure is, however, set to the
+	 * MAC address of the device going away.
+	 *
+	 * Hence, this callback must be implemented.
+	 */
 	void (*remove_interface)(struct ieee80211_hw *hw,
 				 struct ieee80211_if_init_conf *conf);
 
@@ -595,15 +630,19 @@ struct ieee80211_ops {
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
+	/*
+	 * Change filter flags, see above for FIF_* constants.
+	 *
+	 * All unsupported flags in 'total_flags' must be cleared,
+	 * clear all bits except those you honoured.
+	 *
+	 * Must be atomic due to running under the tx lock.
+	 *
+	 * This callback is must be implemented.
+	 */
+	void (*change_filter_flags)(struct ieee80211_hw *hw,
+				    unsigned int changed_flags,
+				    unsigned int *total_flags);
 
 	/* Set TIM bit handler. If the hardware/firmware takes care of beacon
 	 * generation, IEEE 802.11 code uses this function to tell the
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-15 00:22:42.540200043 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-15 00:43:05.570200043 +0200
@@ -118,6 +118,26 @@ static int ieee80211_change_mtu(struct n
 	return 0;
 }
 
+static inline void set_local_flag(struct ieee80211_local *local,
+				  unsigned int flag,
+				  unsigned int *changed)
+{
+	if (!(local->filter_flags & flag)) {
+		*changed |= flag;
+		local->filter_flags |= flag;
+	}
+}
+
+static inline void clear_local_flag(struct ieee80211_local *local,
+				    unsigned int flag,
+				    unsigned int *changed)
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
@@ -134,55 +154,13 @@ static inline int identical_mac_addr_all
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
-static void ieee80211_if_open(struct net_device *dev)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	switch (sdata->type) {
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
-		sdata->u.sta.prev_bssid_set = 0;
-		break;
-	}
-}
-
 static int ieee80211_open(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata, *nsdata;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_if_init_conf conf;
 	int res;
+	unsigned int change = 0, flags;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	read_lock(&local->sub_if_lock);
@@ -202,81 +180,103 @@ static int ieee80211_open(struct net_dev
 	    is_zero_ether_addr(sdata->u.wds.remote_addr))
 		return -ENOLINK;
 
-	if (sdata->type == IEEE80211_IF_TYPE_MNTR && local->open_count &&
-	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER)) {
-		/* run the interface in a "soft monitor" mode */
-		local->monitors++;
-		local->open_count++;
-		local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
-		return 0;
-	}
-	ieee80211_if_open(dev);
-	ieee80211_start_soft_monitor(local);
-
-	conf.if_id = dev->ifindex;
-	conf.type = sdata->type;
-	if (sdata->type == IEEE80211_IF_TYPE_MNTR)
-		conf.mac_addr = NULL;
-	else
-		conf.mac_addr = dev->dev_addr;
-	res = local->ops->add_interface(local_to_hw(local), &conf);
-	if (res) {
-		if (sdata->type == IEEE80211_IF_TYPE_MNTR)
-			ieee80211_start_hard_monitor(local);
-		return res;
-	}
-
 	if (local->open_count == 0) {
 		res = 0;
-		tasklet_enable(&local->tx_pending_tasklet);
-		tasklet_enable(&local->tasklet);
-		if (local->ops->open)
-			res = local->ops->open(local_to_hw(local));
-		if (res == 0) {
-			res = dev_open(local->mdev);
-			if (res) {
-				if (local->ops->stop)
-					local->ops->stop(local_to_hw(local));
-			} else {
-				res = ieee80211_hw_config(local);
-				if (res && local->ops->stop)
-					local->ops->stop(local_to_hw(local));
-			}
-		}
-		if (res) {
-			if (local->ops->remove_interface)
-				local->ops->remove_interface(local_to_hw(local),
-							    &conf);
+		if (local->ops->start)
+			res = local->ops->start(local_to_hw(local));
+		if (res)
 			return res;
-		}
 	}
-	local->open_count++;
 
-	if (sdata->type == IEEE80211_IF_TYPE_MNTR) {
+	switch (sdata->type) {
+	/* XXX: handle VLANs specially and not bother drivers */
+	case IEEE80211_IF_TYPE_MNTR:
+		if (!local->monitors) {
+			set_local_flag(local, FIF_CONTROL, &change);
+			set_local_flag(local, FIF_OTHER_BSS, &change);
+			local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
+			flags = local->filter_flags;
+			/* be a bit nasty */
+			flags |= (1<<31);
+			local->ops->change_filter_flags(local_to_hw(local),
+							change, &flags);
+			WARN_ON(flags & (1<<31));
+			local->filter_flags = flags;
+			ieee80211_hw_config(local);
+		}
+
 		local->monitors++;
-		local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
-	} else {
+		break;
+	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_IBSS:
+		sdata->u.sta.prev_bssid_set = 0;
+		/* fall through */
+	default:
+		conf.if_id = dev->ifindex;
+		conf.type = sdata->type;
+		conf.mac_addr = dev->dev_addr;
+		res = local->ops->add_interface(local_to_hw(local), &conf);
+		if (res && !local->open_count && local->ops->stop)
+			local->ops->stop(local_to_hw(local));
+		if (res)
+			return res;
+
 		ieee80211_if_config(dev);
 		ieee80211_reset_erp_info(dev);
+
+		if (sdata->type == IEEE80211_IF_TYPE_STA &&
+		    !local->user_space_mlme)
+			netif_carrier_off(dev);
+		else
+			netif_carrier_on(dev);
 	}
 
-	if (sdata->type == IEEE80211_IF_TYPE_STA &&
-	    !local->user_space_mlme)
-		netif_carrier_off(dev);
-	else
-		netif_carrier_on(dev);
+	if (local->open_count == 0) {
+		res = dev_open(local->mdev);
+		WARN_ON(res);
+		tasklet_enable(&local->tx_pending_tasklet);
+		tasklet_enable(&local->tasklet);
+	}
+
+	local->open_count++;
 
 	netif_start_queue(dev);
+
 	return 0;
 }
 
-static void ieee80211_if_shutdown(struct net_device *dev)
+static int ieee80211_stop(struct net_device *dev)
 {
+	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	unsigned int change = 0, flags;
+	struct ieee80211_if_init_conf conf;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	netif_stop_queue(dev);
+
+	local->open_count--;
 
-	ASSERT_RTNL();
 	switch (sdata->type) {
+	/* XXX: handle VLANs specially and not bother drivers */
+	case IEEE80211_IF_TYPE_MNTR:
+		local->monitors--;
+
+		if (!local->monitors) {
+			clear_local_flag(local, FIF_CONTROL, &change);
+			clear_local_flag(local, FIF_OTHER_BSS, &change);
+			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
+			flags = local->filter_flags;
+			/* be a bit nasty */
+			flags |= (1<<31);
+			local->ops->change_filter_flags(local_to_hw(local),
+							change, &flags);
+			WARN_ON(flags & (1<<31));
+			local->filter_flags = flags;
+			ieee80211_hw_config(local);
+		}
+		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		sdata->u.sta.state = IEEE80211_DISABLED;
@@ -289,56 +289,24 @@ static void ieee80211_if_shutdown(struct
 			cancel_delayed_work(&local->scan_work);
 		}
 		flush_workqueue(local->hw.workqueue);
-		break;
-	}
-}
-
-static int ieee80211_stop(struct net_device *dev)
-{
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (sdata->type == IEEE80211_IF_TYPE_MNTR &&
-	    local->open_count > 1 &&
-	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER)) {
-		/* remove "soft monitor" interface */
-		local->open_count--;
-		local->monitors--;
-		if (!local->monitors)
-			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
-		return 0;
-	}
-
-	netif_stop_queue(dev);
-	ieee80211_if_shutdown(dev);
-
-	if (sdata->type == IEEE80211_IF_TYPE_MNTR) {
-		local->monitors--;
-		if (!local->monitors)
-			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
+		/* fall through */
+	default:
+		conf.if_id = dev->ifindex;
+		conf.type = sdata->type;
+		conf.mac_addr = dev->dev_addr;
+		local->ops->remove_interface(local_to_hw(local), &conf);
 	}
 
-	local->open_count--;
 	if (local->open_count == 0) {
 		if (netif_running(local->mdev))
 			dev_close(local->mdev);
+
 		if (local->ops->stop)
 			local->ops->stop(local_to_hw(local));
+
 		tasklet_disable(&local->tx_pending_tasklet);
 		tasklet_disable(&local->tasklet);
 	}
-	if (local->ops->remove_interface) {
-		struct ieee80211_if_init_conf conf;
-
-		conf.if_id = dev->ifindex;
-		conf.type = sdata->type;
-		conf.mac_addr = dev->dev_addr;
-		local->ops->remove_interface(local_to_hw(local), &conf);
-	}
-
-	ieee80211_start_hard_monitor(local);
 
 	return 0;
 }
@@ -354,47 +322,48 @@ static inline void netif_tx_lock_nested(
 	dev->xmit_lock_owner = smp_processor_id();
 }
 
-static void ieee80211_set_multicast_list(struct net_device *dev)
+static void ieee80211_change_rx_flags(struct net_device *dev, int change)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	unsigned short flags;
+	unsigned int changed_flags = 0, flags;
 
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
+	flags = local->filter_flags;
+	/* be a bit nasty */
+	flags |= (1<<31);
+	local->ops->change_filter_flags(local_to_hw(local),
+					changed_flags, &flags);
+	WARN_ON(flags & (1<<31));
+	local->filter_flags = flags;
+	read_unlock(&local->sub_if_lock);
+
 	netif_tx_unlock(local->mdev);
 }
 
@@ -405,7 +374,7 @@ void ieee80211_if_setup(struct net_devic
 	dev->hard_start_xmit = ieee80211_subif_start_xmit;
 	dev->wireless_handlers = &ieee80211_iw_handler_def;
 	dev->do_ioctl = ieee80211_ioctl;
-	dev->set_multicast_list = ieee80211_set_multicast_list;
+	dev->change_rx_flags = ieee80211_change_rx_flags;
 	dev->change_mtu = ieee80211_change_mtu;
 	dev->get_stats = ieee80211_get_stats;
 	dev->open = ieee80211_open;
@@ -969,8 +938,12 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 			   NETDEV_ALIGN_CONST) & ~NETDEV_ALIGN_CONST);
 
 	BUG_ON(!ops->tx);
+	BUG_ON(!ops->start);
+	BUG_ON(!ops->stop);
 	BUG_ON(!ops->config);
 	BUG_ON(!ops->add_interface);
+	BUG_ON(!ops->remove_interface);
+	BUG_ON(!ops->change_filter_flags);
 	local->ops = ops;
 
 	/* for now, mdev needs sub_if_data :/ */
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-15 00:22:42.880200043 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-15 00:43:05.740200043 +0200
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
+	unsigned int filter_flags; /* FIF_* */
 	struct iw_statistics wstats;
 	u8 wstats_flags;
 	int tx_headroom; /* required headroom for hardware/radiotap */
@@ -495,7 +493,6 @@ struct ieee80211_local {
 	struct ieee80211_tx_stored_packet pending_packet[NUM_TX_DATA_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
 
-	int mc_count;	/* total count of multicast entries in all interfaces */
 	int iff_allmultis, iff_promiscs;
 			/* number of interfaces with corresponding IFF_ flags */
 
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-15 00:22:42.940200043 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-15 00:43:06.020200043 +0200
@@ -963,9 +963,8 @@ ieee80211_rx_h_data_agg(struct ieee80211
 		sdata->stats.rx_bytes += frame->len;
 
 		if (local->bridge_packets &&
-		    (sdata->type == IEEE80211_IF_TYPE_AP ||
-		     sdata->type == IEEE80211_IF_TYPE_VLAN) &&
-		     rx->u.rx.ra_match) {
+		    sdata->type == IEEE80211_IF_TYPE_AP &&
+		    rx->u.rx.ra_match) {
 			if (is_multicast_ether_addr(frame->data)) {
 				/* send multicast frames both to higher layers
 				* in local net stack and back to the wireless
@@ -1061,8 +1060,7 @@ ieee80211_rx_h_data(struct ieee80211_txr
 		memcpy(dst, hdr->addr3, ETH_ALEN);
 		memcpy(src, hdr->addr2, ETH_ALEN);
 
-		if (unlikely(sdata->type != IEEE80211_IF_TYPE_AP &&
-			     sdata->type != IEEE80211_IF_TYPE_VLAN)) {
+		if (unlikely(sdata->type != IEEE80211_IF_TYPE_AP)) {
 			if (net_ratelimit())
 				printk(KERN_DEBUG "%s: dropped ToDS frame "
 				       "(BSSID=" MAC_FMT
@@ -1159,8 +1157,8 @@ ieee80211_rx_h_data(struct ieee80211_txr
 	sdata->stats.rx_packets++;
 	sdata->stats.rx_bytes += skb->len;
 
-	if (local->bridge_packets && (sdata->type == IEEE80211_IF_TYPE_AP
-	    || sdata->type == IEEE80211_IF_TYPE_VLAN) && rx->u.rx.ra_match) {
+	if (local->bridge_packets && (sdata->type == IEEE80211_IF_TYPE_AP) &&
+	    rx->u.rx.ra_match) {
 		if (is_multicast_ether_addr(skb->data)) {
 			/* send multicast frames both to higher layers in
 			 * local net stack and back to the wireless media */
@@ -1389,7 +1387,7 @@ static int prepare_for_handlers(struct i
 		} else if (!multicast &&
 			   compare_ether_addr(sdata->dev->dev_addr,
 					      hdr->addr1) != 0) {
-			if (!sdata->promisc)
+			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
 			rx->u.rx.ra_match = 0;
 		}
@@ -1404,7 +1402,7 @@ static int prepare_for_handlers(struct i
 		} else if (!multicast &&
 			   compare_ether_addr(sdata->dev->dev_addr,
 					      hdr->addr1) != 0) {
-			if (!sdata->promisc)
+			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
 			rx->u.rx.ra_match = 0;
 		} else if (!rx->sta)
--- wireless-dev.orig/net/mac80211/debugfs_netdev.c	2007-08-15 00:22:39.040200043 +0200
+++ wireless-dev/net/mac80211/debugfs_netdev.c	2007-08-15 00:43:05.640200043 +0200
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
--- wireless-dev.orig/drivers/net/wireless/b43/b43.h	2007-08-15 00:22:39.000200043 +0200
+++ wireless-dev/drivers/net/wireless/b43/b43.h	2007-08-15 00:22:43.010200043 +0200
@@ -572,9 +572,8 @@ struct b43_wl {
 	 * at a time. General information about this interface follows.
 	 */
 
-	/* Opaque ID of the operating interface (!= monitor
-	 * interface) from the ieee80211 subsystem.
-	 * Do not modify.
+	/* Opaque ID of the operating interface from the ieee80211
+	 * subsystem. Do not modify.
 	 */
 	int if_id;
 	/* MAC address (can be NULL). */
@@ -583,14 +582,10 @@ struct b43_wl {
 	const u8 *bssid;
 	/* Interface type. (IEEE80211_IF_TYPE_XXX) */
 	int if_type;
-	/* Counter of active monitor interfaces. */
-	int monitor;
 	/* Is the card operating in AP, STA or IBSS mode? */
 	bool operating;
-	/* Promisc mode active?
-	 * Note that (monitor != 0) implies promisc.
-	 */
-	bool promisc;
+	/* filter flags */
+	unsigned int filter_flags;
 	/* Stats about the wireless interface */
 	struct ieee80211_low_level_stats ieee_stats;
 
@@ -747,8 +742,6 @@ static inline struct b43_wldev *dev_to_b
 /* Is the device operating in a specified mode (IEEE80211_IF_TYPE_XXX). */
 static inline int b43_is_mode(struct b43_wl *wl, int type)
 {
-	if (type == IEEE80211_IF_TYPE_MNTR)
-		return !!(wl->monitor);
 	return (wl->operating && wl->if_type == type);
 }
 
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-08-15 00:22:40.860200043 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-08-15 00:31:49.370200043 +0200
@@ -91,14 +91,6 @@ static char modparam_fwpostfix[16];
 module_param_string(fwpostfix, modparam_fwpostfix, 16, 0444);
 MODULE_PARM_DESC(fwpostfix, "Postfix for the .fw files to load.");
 
-static int modparam_mon_keep_bad;
-module_param_named(mon_keep_bad, modparam_mon_keep_bad, int, 0444);
-MODULE_PARM_DESC(mon_keep_bad, "Keep bad frames in monitor mode");
-
-static int modparam_mon_keep_badplcp;
-module_param_named(mon_keep_badplcp, modparam_mon_keep_bad, int, 0444);
-MODULE_PARM_DESC(mon_keep_badplcp, "Keep frames with bad PLCP in monitor mode");
-
 static int modparam_hwpctl;
 module_param_named(hwpctl, modparam_hwpctl, int, 0444);
 MODULE_PARM_DESC(hwpctl, "Enable hardware-side power control (default off)");
@@ -561,12 +553,10 @@ static void b43_write_mac_bssid_template
 	}
 }
 
-static void b43_upload_card_macaddress(struct b43_wldev *dev,
-				       const u8 * mac_addr)
+static void b43_upload_card_macaddress(struct b43_wldev *dev)
 {
-	dev->wl->mac_addr = mac_addr;
 	b43_write_mac_bssid_templates(dev);
-	b43_macfilter_set(dev, B43_MACFILTER_SELF, mac_addr);
+	b43_macfilter_set(dev, B43_MACFILTER_SELF, dev->wl->mac_addr);
 }
 
 static void b43_set_slot_time(struct b43_wldev *dev, u16 slot_time)
@@ -1959,31 +1949,20 @@ static void b43_adjust_opmode(struct b43
 	ctl &= ~B43_MACCTL_PROMISC;
 	ctl |= B43_MACCTL_INFRA;
 
-	if (wl->operating) {
-		switch (wl->if_type) {
-		case IEEE80211_IF_TYPE_AP:
-			ctl |= B43_MACCTL_AP;
-			break;
-		case IEEE80211_IF_TYPE_IBSS:
-			ctl &= ~B43_MACCTL_INFRA;
-			break;
-		case IEEE80211_IF_TYPE_STA:
-		case IEEE80211_IF_TYPE_MNTR:
-		case IEEE80211_IF_TYPE_WDS:
-			break;
-		default:
-			B43_WARN_ON(1);
-		}
-	}
-	if (wl->monitor) {
+	if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP))
+		ctl |= B43_MACCTL_AP;
+	else if (b43_is_mode(wl, IEEE80211_IF_TYPE_IBSS))
+		ctl &= ~B43_MACCTL_INFRA;
+
+	if (wl->filter_flags & FIF_CONTROL)
 		ctl |= B43_MACCTL_KEEP_CTL;
-		if (modparam_mon_keep_bad)
-			ctl |= B43_MACCTL_KEEP_BAD;
-		if (modparam_mon_keep_badplcp)
-			ctl |= B43_MACCTL_KEEP_BADPLCP;
-	}
-	if (wl->promisc)
+	if (wl->filter_flags & FIF_FCSFAIL)
+		ctl |= B43_MACCTL_KEEP_BAD;
+	if (wl->filter_flags & FIF_PLCPFAIL)
+		ctl |= B43_MACCTL_KEEP_BADPLCP;
+	if (wl->filter_flags & FIF_PROMISC_IN_BSS)
 		ctl |= B43_MACCTL_PROMISC;
+
 	/* Workaround: On old hardware the HW-MAC-address-filter
 	 * doesn't work properly, so always run promisc in filter
 	 * it in software. */
@@ -2908,21 +2887,37 @@ out:
 	return err;
 }
 
-static void b43_set_multicast_list(struct ieee80211_hw *hw,
-				   unsigned short netflags, int mc_count)
+static void b43_change_filter_flags(struct ieee80211_hw *hw,
+				    unsigned int changed, unsigned int *fflags)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 	unsigned long flags;
 
-	if (!dev)
+	if (!dev) {
+		*fflags = 0;
 		return;
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	if (wl->promisc != !!(netflags & IFF_PROMISC)) {
-		wl->promisc = !!(netflags & IFF_PROMISC);
-		if (b43_status(dev) >= B43_STAT_INITIALIZED)
-			b43_adjust_opmode(dev);
 	}
+
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	*fflags &= FIF_PROMISC_IN_BSS |
+		  FIF_ALLMULTI |
+		  FIF_FCSFAIL |
+		  FIF_PLCPFAIL |
+		  FIF_CONTROL |
+		  FIF_OTHER_BSS;
+
+	changed &= FIF_PROMISC_IN_BSS |
+		   FIF_ALLMULTI |
+		   FIF_FCSFAIL |
+		   FIF_PLCPFAIL |
+		   FIF_CONTROL |
+		   FIF_OTHER_BSS;
+
+	wl->filter_flags = *fflags;
+
+	if (changed && b43_status(dev) >= B43_STAT_INITIALIZED)
+		b43_adjust_opmode(dev);
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 }
 
@@ -2937,18 +2932,16 @@ static int b43_config_interface(struct i
 		return -ENODEV;
 	mutex_lock(&wl->mutex);
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	if (conf->type != IEEE80211_IF_TYPE_MNTR) {
-		B43_WARN_ON(wl->if_id != if_id);
-		wl->bssid = conf->bssid;
-		if (b43_status(dev) >= B43_STAT_INITIALIZED) {
-			if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
-				B43_WARN_ON(conf->type != IEEE80211_IF_TYPE_AP);
-				b43_set_ssid(dev, conf->ssid, conf->ssid_len);
-				if (conf->beacon)
-					b43_refresh_templates(dev, conf->beacon);
-			}
-			b43_write_mac_bssid_templates(dev);
+	B43_WARN_ON(wl->if_id != if_id);
+	wl->bssid = conf->bssid;
+	if (b43_status(dev) >= B43_STAT_INITIALIZED) {
+		if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
+			B43_WARN_ON(conf->type != IEEE80211_IF_TYPE_AP);
+			b43_set_ssid(dev, conf->ssid, conf->ssid_len);
+			if (conf->beacon)
+				b43_refresh_templates(dev, conf->beacon);
 		}
+		b43_write_mac_bssid_templates(dev);
 	}
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 	mutex_unlock(&wl->mutex);
@@ -3368,7 +3361,8 @@ static int b43_wireless_core_init(struct
 
 	ssb_bus_powerup(bus, 1);	/* Enable dynamic PCTL */
 	wl->bssid = NULL;
-	b43_upload_card_macaddress(dev, NULL);
+	wl->mac_addr = NULL;
+	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
 	b43_rng_init(wl);
 
@@ -3398,21 +3392,80 @@ static int b43_add_interface(struct ieee
 	struct b43_wldev *dev;
 	unsigned long flags;
 	int err = -EOPNOTSUPP;
-	int did_init = 0;
+
+	/* TODO: allow WDS/AP devices to coexist */
+
+	if (conf->type != IEEE80211_IF_TYPE_AP &&
+	    conf->type != IEEE80211_IF_TYPE_STA &&
+	    conf->type != IEEE80211_IF_TYPE_WDS &&
+	    conf->type != IEEE80211_IF_TYPE_IBSS)
+		return -EOPNOTSUPP;
 
 	mutex_lock(&wl->mutex);
-	if ((conf->type != IEEE80211_IF_TYPE_MNTR) && wl->operating)
+	if (wl->operating)
 		goto out_mutex_unlock;
 
 	bcmdbg(wl, "Adding Interface type %d\n", conf->type);
 
 	dev = wl->current_dev;
+	wl->operating = 1;
+	wl->if_id = conf->if_id;
+	wl->if_type = conf->type;
+	wl->mac_addr = conf->mac_addr;
+
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	b43_adjust_opmode(dev);
+	b43_upload_card_macaddress(dev);
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+
+	err = 0;
+ out_mutex_unlock:
+	mutex_unlock(&wl->mutex);
+
+	return err;
+}
+
+static void b43_remove_interface(struct ieee80211_hw *hw,
+				 struct ieee80211_if_init_conf *conf)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+	struct b43_wldev *dev = wl->current_dev;
+	unsigned long flags;
+
+	bcmdbg(wl, "Removing Interface type %d\n", conf->type);
+
+	mutex_lock(&wl->mutex);
+
+	B43_WARN_ON(!wl->operating);
+	B43_WARN_ON(wl->if_id != conf->if_id);
+
+	wl->operating = 0;
+
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	b43_adjust_opmode(dev);
+	wl->mac_addr = NULL;
+	b43_upload_card_macaddress(dev);
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+
+	mutex_unlock(&wl->mutex);
+}
+
+static int b43_start(struct ieee80211_hw *hw)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+	struct b43_wldev *dev = wl->current_dev;
+	int did_init = 0;
+	int err;
+
+	mutex_lock(&wl->mutex);
+
 	if (b43_status(dev) < B43_STAT_INITIALIZED) {
 		err = b43_wireless_core_init(dev);
 		if (err)
 			goto out_mutex_unlock;
 		did_init = 1;
 	}
+
 	if (b43_status(dev) < B43_STAT_STARTED) {
 		err = b43_wireless_core_start(dev);
 		if (err) {
@@ -3422,59 +3475,21 @@ static int b43_add_interface(struct ieee
 		}
 	}
 
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	switch (conf->type) {
-	case IEEE80211_IF_TYPE_MNTR:
-		wl->monitor++;
-		break;
-	default:
-		wl->operating = 1;
-		wl->if_id = conf->if_id;
-		wl->if_type = conf->type;
-		b43_upload_card_macaddress(dev, conf->mac_addr);
-	}
-	b43_adjust_opmode(dev);
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-
-	err = 0;
-      out_mutex_unlock:
+ out_mutex_unlock:
 	mutex_unlock(&wl->mutex);
 
 	return err;
 }
 
-static void b43_remove_interface(struct ieee80211_hw *hw,
-				 struct ieee80211_if_init_conf *conf)
+void b43_stop(struct ieee80211_hw *hw)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev;
-	unsigned long flags;
-
-	bcmdbg(wl, "Removing Interface type %d\n", conf->type);
+	struct b43_wldev *dev = wl->current_dev;
 
 	mutex_lock(&wl->mutex);
-	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
-		wl->monitor--;
-		B43_WARN_ON(wl->monitor < 0);
-	} else {
-		B43_WARN_ON(!wl->operating);
-		wl->operating = 0;
-	}
-
-	dev = wl->current_dev;
-	if (!wl->operating && wl->monitor == 0) {
-		/* No interface left. */
-		if (b43_status(dev) >= B43_STAT_STARTED)
-			b43_wireless_core_stop(dev);
-		b43_wireless_core_exit(dev);
-	} else {
-		/* Just monitor interfaces left. */
-		spin_lock_irqsave(&wl->irq_lock, flags);
-		b43_adjust_opmode(dev);
-		if (!wl->operating)
-			b43_upload_card_macaddress(dev, NULL);
-		spin_unlock_irqrestore(&wl->irq_lock, flags);
-	}
+	if (b43_status(dev) >= B43_STAT_STARTED)
+		b43_wireless_core_stop(dev);
+	b43_wireless_core_exit(dev);
 	mutex_unlock(&wl->mutex);
 }
 
@@ -3486,10 +3501,12 @@ static const struct ieee80211_ops b43_hw
 	.reset = b43_dev_reset,
 	.config = b43_dev_config,
 	.config_interface = b43_config_interface,
-	.set_multicast_list = b43_set_multicast_list,
+	.change_filter_flags = b43_change_filter_flags,
 	.set_key = b43_dev_set_key,
 	.get_stats = b43_get_stats,
 	.get_tx_stats = b43_get_tx_stats,
+	.start = b43_start,
+	.stop = b43_stop,
 };
 
 /* Hard-reset the chip. Do not call this directly.
@@ -3827,7 +3844,6 @@ static int b43_wireless_init(struct ssb_
 
 	/* fill hw info */
 	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
-	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_DEVICE_HIDES_WEP | IEEE80211_HW_WEP_INCLUDE_IV;
 	hw->max_signal = 100;
 	hw->max_rssi = -110;
--- wireless-dev.orig/drivers/net/wireless/iwl-base.c	2007-08-15 00:22:39.010200043 +0200
+++ wireless-dev/drivers/net/wireless/iwl-base.c	2007-08-15 00:22:43.030200043 +0200
@@ -2591,6 +2591,8 @@ static void iwl_set_flags_for_phymode(st
 
 /*
  * initilize rxon structure with default values fromm eeprom
+ *
+ * XXX: This function should use the filter flags instead!
  */
 static void iwl_connection_init_rx_config(struct iwl_priv *priv)
 {
@@ -7502,7 +7504,7 @@ static void iwl_bg_scan_completed(struct
  *
  *****************************************************************************/
 
-static int iwl_mac_open(struct ieee80211_hw *hw)
+static int iwl_mac_start(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -7521,7 +7523,7 @@ static int iwl_mac_open(struct ieee80211
 	return 0;
 }
 
-static int iwl_mac_stop(struct ieee80211_hw *hw)
+static void iwl_mac_stop(struct ieee80211_hw *hw)
 {
 	struct iwl_priv *priv = hw->priv;
 
@@ -7530,8 +7532,17 @@ static int iwl_mac_stop(struct ieee80211
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
 	IWL_DEBUG_MAC80211("leave\n");
+}
 
-	return 0;
+static void iwl_change_filter_flags(struct ieee80211_hw *hw,
+				    unsigned int changed_flags,
+				    unsigned int *total_flags)
+{
+	/*
+	 * XXX: dummy
+	 * see also iwl_connection_init_rx_config
+	 */
+	*total_flags = 0;
 }
 
 static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
@@ -7700,6 +7711,8 @@ static int iwl_mac_config_interface(stru
 	if (conf == NULL)
 		return -EIO;
 
+	/* TODO: use conf->mac_addr */
+
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_AP) &&
 	    (!conf->beacon || !conf->ssid_len)) {
 		IWL_DEBUG_MAC80211
@@ -7808,6 +7821,8 @@ static void iwl_mac_remove_interface(str
 	}
 	mutex_unlock(&priv->mutex);
 
+	/* TODO: clear MAC address in hardware */
+
 	IWL_DEBUG_MAC80211("leave\n");
 
 }
@@ -9056,10 +9071,11 @@ static struct attribute_group iwl_attrib
 
 static struct ieee80211_ops iwl_hw_ops = {
 	.tx = iwl_mac_tx,
-	.open = iwl_mac_open,
+	.start = iwl_mac_start,
 	.stop = iwl_mac_stop,
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
+	.change_filter_flags = iwl_change_filter_flags,
 	.config = iwl_mac_config,
 	.config_interface = iwl_mac_config_interface,
 	.set_key = iwl_mac_set_key,
--- wireless-dev.orig/drivers/net/wireless/rtl8187_dev.c	2007-08-15 00:22:42.250200043 +0200
+++ wireless-dev/drivers/net/wireless/rtl8187_dev.c	2007-08-15 00:22:43.030200043 +0200
@@ -365,7 +365,7 @@ static void rtl8187_set_channel(struct i
 	rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
 }
 
-static int rtl8187_open(struct ieee80211_hw *dev)
+static int rtl8187_start(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	u32 reg;
@@ -476,6 +476,8 @@ static void rtl8187_remove_interface(str
 {
 	struct rtl8187_priv *priv = dev->priv;
 	priv->mode = IEEE80211_IF_TYPE_NONE;
+
+	/* TODO: reset MAC address to zeroes */
 }
 
 static int rtl8187_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
@@ -523,14 +525,27 @@ static int rtl8187_config_interface(stru
 	return 0;
 }
 
+static void rtl8187_change_filter_flags(struct ieee80211_hw *dev,
+					unsigned int changed,
+					unsigned int *flags)
+{
+	/*
+	 * XXX: dummy
+	 *
+	 * TODO: change filter flags
+	 */
+	*flags = 0;
+}
+
 static const struct ieee80211_ops rtl8187_ops = {
 	.tx			= rtl8187_tx,
-	.open			= rtl8187_open,
+	.start			= rtl8187_start,
 	.stop			= rtl8187_stop,
 	.add_interface		= rtl8187_add_interface,
 	.remove_interface	= rtl8187_remove_interface,
 	.config			= rtl8187_config,
 	.config_interface	= rtl8187_config_interface,
+	.change_filter_flags	= rtl8187_change_filter_flags,
 };
 
 static void rtl8187_eeprom_register_read(struct eeprom_93cx6 *eeprom)
--- wireless-dev.orig/drivers/net/wireless/adm8211.c	2007-08-15 00:22:42.250200043 +0200
+++ wireless-dev/drivers/net/wireless/adm8211.c	2007-08-15 00:22:43.040200043 +0200
@@ -349,8 +349,9 @@ static int adm8211_get_stats(struct ieee
 	return 0;
 }
 
-static void adm8211_set_rx_mode(struct ieee80211_hw *dev,
-				unsigned short flags, int mc_count)
+static void adm8211_change_filter_flags(struct ieee80211_hw *dev,
+					unsigned int changed,
+					unsigned int *flags)
 {
 	struct adm8211_priv *priv = dev->priv;
 	unsigned int bit_nr;
@@ -358,12 +359,15 @@ static void adm8211_set_rx_mode(struct i
 	struct dev_mc_list *mclist;
 	void *tmp;
 
-		mc_filter[1] = mc_filter[0] = 0;
-	if (flags & IFF_PROMISC) {
+	/* TODO: honour more flags */
+
+	mc_filter[1] = mc_filter[0] = 0;
+
+	if (*flags & FIF_PROMISC_IN_BSS) {
 		priv->nar |= ADM8211_NAR_PR;
 		priv->nar &= ~ADM8211_NAR_MM;
 		mc_filter[1] = mc_filter[0] = cpu_to_le32(~0);
-	} else if ((flags & IFF_ALLMULTI) || (mc_count > -1)) {
+	} else if (*flags & FIF_ALLMULTI) {
 		priv->nar &= ~ADM8211_NAR_PR;
 		priv->nar |= ADM8211_NAR_MM;
 		mc_filter[1] = mc_filter[0] = cpu_to_le32(~0);
@@ -379,6 +383,8 @@ static void adm8211_set_rx_mode(struct i
 		}
 	}
 
+	*flags &= FIF_PROMISC_IN_BSS | FIF_ALLMULTI;
+
 	ADM8211_IDLE_RX();
 
 	ADM8211_CSR_WRITE(MAR0, mc_filter[0]);
@@ -1500,6 +1506,8 @@ static void adm8211_remove_interface(str
 {
 	struct adm8211_priv *priv = dev->priv;
 	priv->mode = IEEE80211_IF_TYPE_NONE;
+
+	/* TODO: clear MAC address */
 }
 
 static int adm8211_init_rings(struct ieee80211_hw *dev)
@@ -1583,7 +1591,7 @@ static void adm8211_free_rings(struct ie
 	}
 }
 
-static int adm8211_open(struct ieee80211_hw *dev)
+static int adm8211_start(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
 	int retval;
@@ -1626,7 +1634,7 @@ fail:
 	return retval;
 }
 
-static int adm8211_stop(struct ieee80211_hw *dev)
+static void adm8211_stop(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
 
@@ -1638,7 +1646,6 @@ static int adm8211_stop(struct ieee80211
 	free_irq(priv->pdev->irq, dev);
 
 	adm8211_free_rings(dev);
-	return 0;
 }
 
 static int adm8211_reset(struct ieee80211_hw *dev)
@@ -1877,13 +1884,13 @@ static int adm8211_alloc_rings(struct ie
 static const struct ieee80211_ops adm8211_ops = {
 	.tx			= adm8211_tx,
 	.reset			= adm8211_reset,
-	.open			= adm8211_open,
+	.start			= adm8211_start,
 	.stop			= adm8211_stop,
 	.add_interface		= adm8211_add_interface,
 	.remove_interface	= adm8211_remove_interface,
 	.config			= adm8211_config,
 	.config_interface	= adm8211_config_interface,
-	.set_multicast_list	= adm8211_set_rx_mode,
+	.change_filter_flags	= adm8211_change_filter_flags,
 	.get_stats		= adm8211_get_stats,
 	.get_tx_stats		= adm8211_get_tx_stats,
 	.get_tsf		= adm8211_get_tsft
@@ -2118,7 +2125,7 @@ static int adm8211_resume(struct pci_dev
 	pci_restore_state(pdev);
 
 	if (priv->mode != IEEE80211_IF_TYPE_NONE) {
-		adm8211_open(dev);
+		adm8211_start(dev);
 		ieee80211_start_queues(dev);
 	}
 
--- wireless-dev.orig/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c	2007-08-15 00:22:42.250200043 +0200
+++ wireless-dev/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c	2007-08-15 00:22:43.040200043 +0200
@@ -170,29 +170,18 @@ void zd_mac_clear(struct zd_mac *mac)
 	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));
 }
 
-/**
- * has_monitor_interfaces - have monitor interfaces been enabled?
- * @mac: the struct zd_mac pointer
- *
- * The function returns, whether the device has monitor interfaces attached.
- */
-static int has_monitor_interfaces(struct zd_mac *mac)
-{
-	return mac->type == IEEE80211_IF_TYPE_MNTR;
-}
-
 static int set_rx_filter(struct zd_mac *mac)
 {
-	u32 filter = has_monitor_interfaces(mac) ? ~0 : STA_RX_FILTER;
+	/* XXX: need to work off the filter flags! */
+	u32 filter = STA_RX_FILTER;
 
 	return zd_iowrite32(&mac->chip, CR_RX_FILTER, filter);
 }
 
 static int set_sniffer(struct zd_mac *mac)
 {
-	return zd_iowrite32(&mac->chip, CR_SNIFFER_ON,
-		has_monitor_interfaces(mac) ? 1 : 0);
-	return 0;
+	/* XXX: need to work off the filter flags! */
+	return zd_iowrite32(&mac->chip, CR_SNIFFER_ON, 0);
 }
 
 static int set_mc_hash(struct zd_mac *mac)
@@ -200,13 +189,13 @@ static int set_mc_hash(struct zd_mac *ma
 	struct zd_mc_hash hash;
 
 	zd_mc_clear(&hash);
-	if (has_monitor_interfaces(mac))
+	if (0) /* XXX: need to work off the filter flags! */
 		zd_mc_add_all(&hash);
 
 	return zd_chip_set_multicast_hash(&mac->chip, &hash);
 }
 
-static int zd_op_open(struct ieee80211_hw *hw)
+static int zd_op_start(struct ieee80211_hw *hw)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
@@ -290,7 +279,7 @@ static void kfree_tx_skb(struct sk_buff 
 	dev_kfree_skb_any(skb);
 }
 
-static int zd_op_stop(struct ieee80211_hw *hw)
+static void zd_op_stop(struct ieee80211_hw *hw)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
@@ -313,8 +302,6 @@ static int zd_op_stop(struct ieee80211_h
 
 	while ((skb = skb_dequeue(ack_wait_queue)))
 		kfree_tx_skb(skb);
-
-	return 0;
 }
 
 /**
@@ -689,7 +676,7 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 	buffer += ZD_PLCP_HEADER_SIZE;
 
 	if (filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats) &&
-	    !has_monitor_interfaces(mac))
+	    0 /* XXX: need to work off the filter flags! */)
 		return 0;
 
 	skb = dev_alloc_skb(length);
@@ -711,7 +698,6 @@ static int zd_op_add_interface(struct ie
 		return -1;
 
 	switch (conf->type) {
-	case IEEE80211_IF_TYPE_MNTR:
 	case IEEE80211_IF_TYPE_STA:
 		mac->type = conf->type;
 		break;
@@ -761,16 +747,16 @@ static void set_multicast_hash_handler(s
 	zd_chip_set_multicast_hash(&mac->chip, &hash);
 }
 
-static void zd_op_set_multicast_list(struct ieee80211_hw *hw,
-				      unsigned short dev_flags, int mc_count)
+static void zd_op_change_filter_flags(struct ieee80211_hw *hw,
+				      unsigned int change,
+				      unsigned int *filterflags)
 {
 	struct zd_mc_hash hash;
 	struct zd_mac *mac = zd_hw_mac(hw);
 	unsigned long flags;
 
-	if ((dev_flags & (IFF_PROMISC|IFF_ALLMULTI)) ||
-	     has_monitor_interfaces(mac))
-	{
+	if (*filterflags & (FIF_PROMISC_IN_BSS | FIF_ALLMULTI)) {
+		/* XXX: can we do better, with finer granularity? */
 		zd_mc_add_all(&hash);
 	} else {
 		struct dev_mc_list *mc = NULL;
@@ -783,6 +769,12 @@ static void zd_op_set_multicast_list(str
 		}
 	}
 
+	/*
+	 * XXX: probably not right, we probably see many other
+	 * frames as well...
+	 */
+	*filterflags &= FIF_PROMISC_IN_BSS | FIF_ALLMULTI;
+
 	spin_lock_irqsave(&mac->lock, flags);
 	mac->multicast_hash = hash;
 	spin_unlock_irqrestore(&mac->lock, flags);
@@ -830,13 +822,13 @@ static void zd_op_erp_ie_changed(struct 
 
 static const struct ieee80211_ops zd_ops = {
 	.tx			= zd_op_tx,
-	.open			= zd_op_open,
+	.start			= zd_op_start,
 	.stop			= zd_op_stop,
 	.add_interface		= zd_op_add_interface,
 	.remove_interface	= zd_op_remove_interface,
 	.config			= zd_op_config,
 	.config_interface	= zd_op_config_interface,
-	.set_multicast_list	= zd_op_set_multicast_list,
+	.change_filter_flags	= zd_op_change_filter_flags,
 	.erp_ie_changed		= zd_op_erp_ie_changed,
 };
 



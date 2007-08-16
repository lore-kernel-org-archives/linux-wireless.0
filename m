Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbXHPOsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 10:48:11 -0400
Subject: [RFC 2/2 v2] mac80211: revamp interface and filter configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>, Zhu Yi <yi.zhu@intel.com>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <20070815152658.587906000@sipsolutions.net>
References: <20070815152557.221351000@sipsolutions.net>
	 <20070815152658.587906000@sipsolutions.net>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 16:50:19 +0200
Message-Id: <1187275819.23489.9.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers are currently supposed to keep track of monitor
interfaces if they allow so-called "hard" monitor, and
they are also supposed to keep track of multicast etc.

This patch changes that, replaces the set_multicast_list()
callback with a new configure_filter() callback that takes
filter flags (FIF_*) instead of interface flags (IFF_*).
For a driver, this means it should open the filter as much
as necessary to get all frames according to the filter flags.

Multicast filtering is a bit special, which is why drivers
that do not require FIF_ALLMULTI for multicast address filters
(i.e. they actually have filters for multicast addresses)
need to set the new IEEE80211_HW_MULTICAST_FILTER flag and
call the ieee80211_get_mc_list_item() function.

At the same time, drivers are no longer notified about
monitor interfaces at all, this means they now need to
implement the start() and stop() callbacks and the new
change_filter_flags() callback. Also, the start()/stop()
ordering changed, start() is now called *before* any
add_interface() as it really should be, and stop() after
any remove_interface().

The patch also changes the behaviour of setting the bssid
to multicast for scanning when IEEE80211_HW_NO_PROBE_FILTERING
is set; the IEEE80211_HW_NO_PROBE_FILTERING flag is removed
and the filter flag FIF_BCN_PRBRESP_PROMISC introduced.
This is a lot more efficient for hardware like b43 that
supports it and other hardware can still set the BSSID
to multicast.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Changes since v1:
 * introduce FIF_BCN_PRBRESP_PROMISC,
   remove IEEE80211_HW_NO_PROBE_FILTERING
   b43 sees *A LOT* less frames because no beacons from other
   BSSes are shown, but I'm not sure if I haven't broken
   other drivers. Due to the semantics of the removed
   IEEE80211_HW_NO_PROBE_FILTERING flag I suspect most drivers
   should have set it but didn't.

 drivers/net/wireless/adm8211.c                  |   85 +++---
 drivers/net/wireless/b43/b43.h                  |   15 -
 drivers/net/wireless/b43/main.c                 |  232 ++++++++--------
 drivers/net/wireless/iwl-base.c                 |   31 +-
 drivers/net/wireless/rtl8187_dev.c              |   23 +
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.c |   66 ++--
 include/net/mac80211.h                          |  148 +++++++---
 net/mac80211/debugfs_netdev.c                   |   16 -
 net/mac80211/ieee80211.c                        |  340 ++++++++++--------------
 net/mac80211/ieee80211_i.h                      |    1 
 net/mac80211/ieee80211_sta.c                    |   16 -
 net/mac80211/rx.c                               |    4 
 12 files changed, 535 insertions(+), 442 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-15 16:48:51.916516958 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-16 16:49:06.563468950 +0200
@@ -335,7 +335,6 @@ enum ieee80211_if_types {
  * @mac_addr: pointer to MAC address of the interface. This pointer is valid
  *	until the interface is removed (i.e. it cannot be used after
  *	remove_interface() callback was called for this interface).
- *	This pointer will be %NULL for monitor interfaces, be careful.
  *
  * This structure is used in add_interface() and remove_interface()
  * callbacks of &struct ieee80211_hw.
@@ -487,13 +486,12 @@ struct ieee80211_hw {
 	 */
 #define IEEE80211_HW_DEVICE_STRIPS_MIC (1<<8)
 
-	/* Device is capable of performing full monitor mode even during
-	 * normal operation. */
-#define IEEE80211_HW_MONITOR_DURING_OPER (1<<9)
-
-	/* Device does not need BSSID filter set to broadcast in order to
-	 * receive all probe responses while scanning */
-#define IEEE80211_HW_NO_PROBE_FILTERING (1<<10)
+	/*
+	 * Device has multicast filters.
+	 */
+#define IEEE80211_HW_MULTICAST_FILTER (1<<9)
+
+/* hole at 10 */
 
 	/* Channels are already configured to the default regulatory domain
 	 * specified in the device's EEPROM */
@@ -540,6 +538,39 @@ static inline void SET_IEEE80211_PERM_AD
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
+/*
+ * promiscuous mode within your BSS,
+ * think of the BSS as your network segment and then this corresponds
+ * to the regular ethernet device promiscuous mode
+ */
+#define FIF_PROMISC_IN_BSS	0x01
+/* show all multicast frames */
+#define FIF_ALLMULTI		0x02
+/* show frames with failed FCS, but set RX_FLAG_FAILED_FCS_CRC for them */
+#define FIF_FCSFAIL		0x04
+/* show frames with failed PLCP CRC, but set RX_FLAG_FAILED_PLCP_CRC for them */
+#define FIF_PLCPFAIL		0x08
+/*
+ * This flag is set during scanning to indicate to the hardware
+ * that it should not filter beacons or probe responses by BSSID.
+ */
+#define FIF_BCN_PRBRESP_PROMISC	0x10
+/*
+ * show control frames, if PROMISC_IN_BSS is not set then
+ * only those addressed to this station
+ */
+#define FIF_CONTROL		0x20
+/* show frames from other BSSes */
+#define FIF_OTHER_BSS		0x40
+
 /* Configuration block used by the low-level driver to tell the 802.11 code
  * about supported hardware features and to pass function pointers to callback
  * functions. */
@@ -552,32 +583,55 @@ struct ieee80211_ops {
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
 		  struct ieee80211_tx_control *control);
 
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
 
@@ -590,15 +644,31 @@ struct ieee80211_ops {
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
+	 * Configure the device's RX filter.
+	 *
+	 * The multi_count parameter tells how many multicast addresses are
+	 * enabled. Use ieee80211_get_mc_list_item() to get the items.
+	 * It will be -1 if the IEEE80211_HW_MULTICAST_FILTER flag is not
+	 * included in the features or if the multicast list hasn't changed
+	 * since the last call, otherwise the number of multicast addresses.
+	 *
+	 * NOTE: If the count is -1 then you may not call
+	 *	 ieee80211_get_mc_list_item() from this function!
+	 *
+	 * NOTE: The count currently doesn't take into account duplicate
+	 *	 addresses from different virtual interfaces!
+	 *
+	 * All unsupported flags in 'total_flags' must be cleared,
+	 * clear all bits except those you honoured.
+	 *
+	 * Must be atomic due to running under the tx lock.
+	 *
+	 * This callback is must be implemented.
+	 */
+	void (*configure_filter)(struct ieee80211_hw *hw, int multi_count,
+				 unsigned int changed_flags,
+				 unsigned int *total_flags);
 
 	/* Set TIM bit handler. If the hardware/firmware takes care of beacon
 	 * generation, IEEE 802.11 code uses this function to tell the
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-15 16:48:51.956516958 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-16 16:49:07.323468950 +0200
@@ -44,6 +44,18 @@ struct ieee80211_tx_status_rtap_hdr {
 	u8 data_retries;
 } __attribute__ ((packed));
 
+/* locking must be nested */
+enum netif_tx_lock_class {
+	TX_LOCK_NORMAL,
+	TX_LOCK_MASTER,
+};
+
+static inline void netif_tx_lock_nested(struct net_device *dev, int subclass)
+{
+	spin_lock_nested(&dev->_xmit_lock, subclass);
+	dev->xmit_lock_owner = smp_processor_id();
+}
+
 /* common interface routines */
 
 static struct net_device_stats *ieee80211_get_stats(struct net_device *dev)
@@ -59,6 +71,51 @@ static int header_parse_80211(struct sk_
 	return ETH_ALEN;
 }
 
+/* filter configuration */
+static void ieee80211_configure_filter(struct ieee80211_local *local)
+{
+	unsigned int changed_flags;
+	unsigned int new_flags = 0;
+	int mc_count = -1;
+
+	/* why? we need some lock to protect things, but this? */
+	netif_tx_lock_nested(local->mdev, TX_LOCK_MASTER);
+
+	if (local->iff_promiscs)
+		new_flags |= FIF_PROMISC_IN_BSS;
+
+	if (local->iff_allmultis ||
+	    (local->mc_count > 0 &&
+	     !(local->hw.flags & IEEE80211_HW_MULTICAST_FILTER)))
+		new_flags |= FIF_ALLMULTI;
+
+	if (local->monitors)
+		new_flags |= FIF_CONTROL | FIF_OTHER_BSS;
+
+	changed_flags = local->filter_flags ^ new_flags;
+
+	if (local->hw.flags & IEEE80211_HW_MULTICAST_FILTER)
+		mc_count = local->mc_count;
+	else
+		mc_count = -1;
+
+	read_lock(&local->sub_if_lock);
+
+	/* be a bit nasty */
+	new_flags |= (1<<31);
+
+	local->ops->configure_filter(local_to_hw(local),
+				     mc_count,
+				     changed_flags,
+				     &new_flags);
+
+	WARN_ON(new_flags & (1<<31));
+	local->filter_flags = new_flags & ~(1<<31);
+	read_unlock(&local->sub_if_lock);
+
+	netif_tx_unlock(local->mdev);
+}
+
 /* master interface */
 
 static int ieee80211_master_open(struct net_device *dev)
@@ -311,49 +368,6 @@ static inline int identical_mac_addr_all
 		  type2 == IEEE80211_IF_TYPE_AP)));
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
@@ -379,83 +393,89 @@ static int ieee80211_open(struct net_dev
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
-				else if (!res && local->apdev)
-					dev_open(local->apdev);
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
+	case IEEE80211_IF_TYPE_MNTR:
+		/* must be before the call to ieee80211_configure_filter */
 		local->monitors++;
-		local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
-	} else {
+		if (local->monitors == 1) {
+			ieee80211_configure_filter(local);
+
+			local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
+			ieee80211_hw_config(local);
+		}
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
+		if (local->apdev) {
+			res = dev_open(local->apdev);
+			WARN_ON(res);
+		}
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
+	struct ieee80211_if_init_conf conf;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	netif_stop_queue(dev);
+
+	local->open_count--;
 
-	ASSERT_RTNL();
 	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_MNTR:
+		local->monitors--;
+		if (local->monitors == 0) {
+			ieee80211_configure_filter(local);
+
+			local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
+			ieee80211_hw_config(local);
+		}
+		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		sdata->u.sta.state = IEEE80211_DISABLED;
@@ -468,115 +488,64 @@ static void ieee80211_if_shutdown(struct
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
 		if (local->apdev)
 			dev_close(local->apdev);
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
 
-enum netif_tx_lock_class {
-	TX_LOCK_NORMAL,
-	TX_LOCK_MASTER,
-};
-
-static inline void netif_tx_lock_nested(struct net_device *dev, int subclass)
-{
-	spin_lock_nested(&dev->_xmit_lock, subclass);
-	dev->xmit_lock_owner = smp_processor_id();
-}
-
 static void ieee80211_set_multicast_list(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	unsigned short flags;
+	int allmulti, promisc;
 
-	netif_tx_lock_nested(local->mdev, TX_LOCK_MASTER);
-	if (((dev->flags & IFF_ALLMULTI) != 0) ^ (sdata->allmulti != 0)) {
-		if (sdata->allmulti) {
-			sdata->allmulti = 0;
-			local->iff_allmultis--;
-		} else {
-			sdata->allmulti = 1;
+	allmulti = !!(dev->flags & IFF_ALLMULTI);
+	promisc = !!(dev->flags & IFF_PROMISC);
+
+	if (allmulti != sdata->allmulti) {
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
+	if (promisc != sdata->promisc) {
+		if (dev->flags & IFF_PROMISC)
 			local->iff_promiscs++;
-		}
+		else
+			local->iff_promiscs--;
 	}
+
+	sdata->allmulti = allmulti;
+	sdata->promisc = promisc;
+
 	if (dev->mc_count != sdata->mc_count) {
 		local->mc_count = local->mc_count - sdata->mc_count +
 				  dev->mc_count;
 		sdata->mc_count = dev->mc_count;
 	}
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
-	}
-	netif_tx_unlock(local->mdev);
+
+	ieee80211_configure_filter(local);
 }
 
 /* Must not be called for mdev and apdev */
@@ -638,7 +607,6 @@ static int __ieee80211_if_config(struct 
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_if_conf conf;
-	static u8 scan_bssid[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 	if (!local->ops->config_interface || !netif_running(dev))
 		return 0;
@@ -647,11 +615,7 @@ static int __ieee80211_if_config(struct 
 	conf.type = sdata->type;
 	if (sdata->type == IEEE80211_IF_TYPE_STA ||
 	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
-		if (local->sta_scanning &&
-		    local->scan_dev == dev)
-			conf.bssid = scan_bssid;
-		else
-			conf.bssid = sdata->u.sta.bssid;
+		conf.bssid = sdata->u.sta.bssid;
 		conf.ssid = sdata->u.sta.ssid;
 		conf.ssid_len = sdata->u.sta.ssid_len;
 		conf.generic_elem = sdata->u.sta.extra_ie;
@@ -1173,8 +1137,12 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 			   NETDEV_ALIGN_CONST) & ~NETDEV_ALIGN_CONST);
 
 	BUG_ON(!ops->tx);
+	BUG_ON(!ops->start);
+	BUG_ON(!ops->stop);
 	BUG_ON(!ops->config);
 	BUG_ON(!ops->add_interface);
+	BUG_ON(!ops->remove_interface);
+	BUG_ON(!ops->configure_filter);
 	local->ops = ops;
 
 	/* for now, mdev needs sub_if_data :/ */
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-15 16:48:52.016516958 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-16 16:49:06.693468950 +0200
@@ -457,6 +457,7 @@ struct ieee80211_local {
 	struct net_device *apdev; /* wlan#ap - management frames (hostapd) */
 	int open_count;
 	int monitors;
+	unsigned int filter_flags; /* FIF_* */
 	struct iw_statistics wstats;
 	u8 wstats_flags;
 	int tx_headroom; /* required headroom for hardware/radiotap */
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-15 16:48:52.046516958 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-16 16:49:06.793468950 +0200
@@ -1417,7 +1417,7 @@ static int prepare_for_handlers(struct i
 		} else if (!multicast &&
 			   compare_ether_addr(sdata->dev->dev_addr,
 					      hdr->addr1) != 0) {
-			if (!sdata->promisc)
+			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
 			rx->u.rx.ra_match = 0;
 		}
@@ -1432,7 +1432,7 @@ static int prepare_for_handlers(struct i
 		} else if (!multicast &&
 			   compare_ether_addr(sdata->dev->dev_addr,
 					      hdr->addr1) != 0) {
-			if (!sdata->promisc)
+			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
 			rx->u.rx.ra_match = 0;
 		} else if (!rx->sta)
--- wireless-dev.orig/net/mac80211/debugfs_netdev.c	2007-08-15 16:48:52.106516958 +0200
+++ wireless-dev/net/mac80211/debugfs_netdev.c	2007-08-15 17:04:03.386516958 +0200
@@ -422,20 +422,6 @@ __IEEE80211_IF_FILE(beacon_tail_len);
 /* WDS attributes */
 IEEE80211_IF_FILE(peer, u.wds.remote_addr, MAC);
 
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
@@ -530,7 +516,6 @@ static void add_wds_files(struct ieee802
 
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(mode, monitor);
 }
 
 static void add_files(struct ieee80211_sub_if_data *sdata)
@@ -647,7 +632,6 @@ static void del_wds_files(struct ieee802
 
 static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_DEL(mode, monitor);
 }
 
 static void del_files(struct ieee80211_sub_if_data *sdata, int type)
--- wireless-dev.orig/drivers/net/wireless/b43/b43.h	2007-08-15 16:48:52.136516958 +0200
+++ wireless-dev/drivers/net/wireless/b43/b43.h	2007-08-16 10:48:40.963471955 +0200
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
 
--- wireless-dev.orig/drivers/net/wireless/b43/main.c	2007-08-15 16:48:52.176516958 +0200
+++ wireless-dev/drivers/net/wireless/b43/main.c	2007-08-16 16:49:06.493468950 +0200
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
@@ -1957,33 +1947,25 @@ static void b43_adjust_opmode(struct b43
 	ctl &= ~B43_MACCTL_KEEP_BADPLCP;
 	ctl &= ~B43_MACCTL_KEEP_BAD;
 	ctl &= ~B43_MACCTL_PROMISC;
+	ctl &= ~B43_MACCTL_BEACPROMISC;
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
+	if (wl->filter_flags & FIF_BCN_PRBRESP_PROMISC)
+		ctl |= B43_MACCTL_BEACPROMISC;
+
 	/* Workaround: On old hardware the HW-MAC-address-filter
 	 * doesn't work properly, so always run promisc in filter
 	 * it in software. */
@@ -2147,9 +2129,6 @@ static int b43_chip_init(struct b43_wlde
 		    & ~B43_MACCTL_INFRA);
 	b43_write32(dev, B43_MMIO_MACCTL, b43_read32(dev, B43_MMIO_MACCTL)
 		    | B43_MACCTL_INFRA);
-	/* Let beacons come through */
-	b43_write32(dev, B43_MMIO_MACCTL, b43_read32(dev, B43_MMIO_MACCTL)
-		    | B43_MACCTL_BEACPROMISC);
 
 	if (b43_using_pio(dev)) {
 		b43_write32(dev, 0x0210, 0x00000100);
@@ -2893,21 +2872,41 @@ out:
 	return err;
 }
 
-static void b43_set_multicast_list(struct ieee80211_hw *hw,
-				   unsigned short netflags, int mc_count)
+static void b43_configure_filter(struct ieee80211_hw *hw,
+				 int multi_count,
+				 unsigned int changed,
+				 unsigned int *fflags)
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
+		  FIF_OTHER_BSS |
+		  FIF_BCN_PRBRESP_PROMISC;
+
+	changed &= FIF_PROMISC_IN_BSS |
+		   FIF_ALLMULTI |
+		   FIF_FCSFAIL |
+		   FIF_PLCPFAIL |
+		   FIF_CONTROL |
+		   FIF_OTHER_BSS |
+		   FIF_BCN_PRBRESP_PROMISC;
+
+	wl->filter_flags = *fflags;
+
+	if (changed && b43_status(dev) >= B43_STAT_INITIALIZED)
+		b43_adjust_opmode(dev);
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 }
 
@@ -2922,18 +2921,16 @@ static int b43_config_interface(struct i
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
@@ -3353,7 +3350,8 @@ static int b43_wireless_core_init(struct
 
 	ssb_bus_powerup(bus, 1);	/* Enable dynamic PCTL */
 	wl->bssid = NULL;
-	b43_upload_card_macaddress(dev, NULL);
+	wl->mac_addr = NULL;
+	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
 	b43_rng_init(wl);
 
@@ -3383,21 +3381,80 @@ static int b43_add_interface(struct ieee
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
@@ -3407,59 +3464,21 @@ static int b43_add_interface(struct ieee
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
 
@@ -3470,10 +3489,12 @@ static const struct ieee80211_ops b43_hw
 	.remove_interface = b43_remove_interface,
 	.config = b43_dev_config,
 	.config_interface = b43_config_interface,
-	.set_multicast_list = b43_set_multicast_list,
+	.configure_filter = b43_configure_filter,
 	.set_key = b43_dev_set_key,
 	.get_stats = b43_get_stats,
 	.get_tx_stats = b43_get_tx_stats,
+	.start = b43_start,
+	.stop = b43_stop,
 };
 
 /* Hard-reset the chip. Do not call this directly.
@@ -3811,7 +3832,6 @@ static int b43_wireless_init(struct ssb_
 
 	/* fill hw info */
 	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
-	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_DEVICE_HIDES_WEP | IEEE80211_HW_WEP_INCLUDE_IV;
 	hw->max_signal = 100;
 	hw->max_rssi = -110;
--- wireless-dev.orig/drivers/net/wireless/iwl-base.c	2007-08-15 16:48:52.226516958 +0200
+++ wireless-dev/drivers/net/wireless/iwl-base.c	2007-08-16 16:49:06.543468950 +0200
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
 
@@ -7530,8 +7532,18 @@ static int iwl_mac_stop(struct ieee80211
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
 	IWL_DEBUG_MAC80211("leave\n");
+}
 
-	return 0;
+static void iwl_configure_filter(struct ieee80211_hw *hw,
+				 int multi_count,
+				 unsigned int changed_flags,
+				 unsigned int *total_flags)
+{
+	/*
+	 * XXX: dummy
+	 * see also iwl_connection_init_rx_config
+	 */
+	*total_flags = 0;
 }
 
 static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
@@ -7700,6 +7712,8 @@ static int iwl_mac_config_interface(stru
 	if (conf == NULL)
 		return -EIO;
 
+	/* TODO: use conf->mac_addr */
+
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_AP) &&
 	    (!conf->beacon || !conf->ssid_len)) {
 		IWL_DEBUG_MAC80211
@@ -7714,8 +7728,14 @@ static int iwl_mac_config_interface(stru
 		IWL_DEBUG_MAC80211("bssid: " MAC_FMT "\n",
 				   MAC_ARG(conf->bssid));
 
+	/*
+	 * XXX: there was a test for IEEE80211_HW_NO_PROBE_FILTERING here
+	 *	which must have been wrong since it was always true.
+	 *	the test was:
 	if (unlikely(priv->status & STATUS_SCANNING) &&
 	    !(priv->hw->flags & IEEE80211_HW_NO_PROBE_FILTERING)) {
+	 */
+	if (unlikely(priv->status & STATUS_SCANNING)) {
 		IWL_DEBUG_MAC80211("leave - scanning\n");
 		mutex_unlock(&priv->mutex);
 		return 0;
@@ -7808,6 +7828,8 @@ static void iwl_mac_remove_interface(str
 	}
 	mutex_unlock(&priv->mutex);
 
+	/* TODO: clear MAC address in hardware */
+
 	IWL_DEBUG_MAC80211("leave\n");
 
 }
@@ -9056,10 +9078,11 @@ static struct attribute_group iwl_attrib
 
 static struct ieee80211_ops iwl_hw_ops = {
 	.tx = iwl_mac_tx,
-	.open = iwl_mac_open,
+	.start = iwl_mac_start,
 	.stop = iwl_mac_stop,
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
+	.configure_filter = iwl_configure_filter,
 	.config = iwl_mac_config,
 	.config_interface = iwl_mac_config_interface,
 	.set_key = iwl_mac_set_key,
--- wireless-dev.orig/drivers/net/wireless/rtl8187_dev.c	2007-08-15 16:48:52.266516958 +0200
+++ wireless-dev/drivers/net/wireless/rtl8187_dev.c	2007-08-15 17:04:03.406516958 +0200
@@ -365,7 +365,7 @@ static void rtl8187_set_channel(struct i
 	rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
 }
 
-static int rtl8187_open(struct ieee80211_hw *dev)
+static int rtl8187_start(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	u32 reg;
@@ -419,7 +419,7 @@ static int rtl8187_open(struct ieee80211
 	return 0;
 }
 
-static int rtl8187_stop(struct ieee80211_hw *dev)
+static void rtl8187_stop(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	struct rtl8187_rx_info *info;
@@ -445,7 +445,6 @@ static int rtl8187_stop(struct ieee80211
 		usb_kill_urb(info->urb);
 		kfree_skb(skb);
 	}
-	return 0;
 }
 
 static int rtl8187_add_interface(struct ieee80211_hw *dev,
@@ -476,6 +475,8 @@ static void rtl8187_remove_interface(str
 {
 	struct rtl8187_priv *priv = dev->priv;
 	priv->mode = IEEE80211_IF_TYPE_MGMT;
+
+	/* TODO: reset MAC address to zeroes */
 }
 
 static int rtl8187_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
@@ -523,14 +524,28 @@ static int rtl8187_config_interface(stru
 	return 0;
 }
 
+static void rtl8187_configure_filter(struct ieee80211_hw *dev,
+				     int multi_count,
+				     unsigned int changed,
+				     unsigned int *flags)
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
+	.configure_filter	= rtl8187_configure_filter,
 };
 
 static void rtl8187_eeprom_register_read(struct eeprom_93cx6 *eeprom)
--- wireless-dev.orig/drivers/net/wireless/adm8211.c	2007-08-15 16:48:52.296516958 +0200
+++ wireless-dev/drivers/net/wireless/adm8211.c	2007-08-16 16:41:38.063468950 +0200
@@ -349,25 +349,47 @@ static int adm8211_get_stats(struct ieee
 	return 0;
 }
 
-static void adm8211_set_rx_mode(struct ieee80211_hw *dev,
-				unsigned short flags, int mc_count)
+static void adm8211_set_bssid(struct ieee80211_hw *dev, u8 *bssid)
+{
+	struct adm8211_priv *priv = dev->priv;
+	u32 reg;
+
+	reg = bssid[0] | (bssid[1] << 8) | (bssid[2] << 16) | (bssid[3] << 24);
+	ADM8211_CSR_WRITE(BSSID0, reg);
+	reg = ADM8211_CSR_READ(ABDA1);
+	reg &= 0x0000ffff;
+	reg |= (bssid[4] << 16) | (bssid[5] << 24);
+	ADM8211_CSR_WRITE(ABDA1, reg);
+}
+
+static void adm8211_configure_filter(struct ieee80211_hw *dev,
+				     int multi_count,
+				     unsigned int changed,
+				     unsigned int *flags)
 {
 	struct adm8211_priv *priv = dev->priv;
 	unsigned int bit_nr;
 	__le32 mc_filter[2];
 	struct dev_mc_list *mclist;
 	void *tmp;
+	int change = 0;
+	u8 bcast_addr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
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
+		change = 1;
+	} else if (*flags & FIF_ALLMULTI) {
 		priv->nar &= ~ADM8211_NAR_PR;
 		priv->nar |= ADM8211_NAR_MM;
 		mc_filter[1] = mc_filter[0] = cpu_to_le32(~0);
-	} else {
+		change = 1;
+	} else if (multi_count >= 0) {
 		priv->nar &= ~(ADM8211_NAR_MM | ADM8211_NAR_PR);
 		mc_filter[1] = mc_filter[0] = 0;
 		mclist = NULL;
@@ -377,15 +399,27 @@ static void adm8211_set_rx_mode(struct i
 			bit_nr &= 0x3F;
 			mc_filter[bit_nr >> 5] |= cpu_to_le32(1 << (bit_nr & 31));
 		}
+		change = 1;
 	}
 
-	ADM8211_IDLE_RX();
+	*flags &= FIF_PROMISC_IN_BSS | FIF_ALLMULTI | FIF_BCN_PRBRESP_PROMISC;
 
-	ADM8211_CSR_WRITE(MAR0, mc_filter[0]);
-	ADM8211_CSR_WRITE(MAR1, mc_filter[1]);
-	ADM8211_CSR_READ(NAR);
+	if (change & FIF_BCN_PRBRESP_PROMISC) {
+		if (*flags & FIF_BCN_PRBRESP_PROMISC)
+			adm8211_set_bssid(dev, bcast_addr);
+		else
+			adm8211_set_bssid(dev, priv->bssid);
+	}
 
-	ADM8211_RESTORE();
+	if (change) {
+		ADM8211_IDLE_RX();
+
+		ADM8211_CSR_WRITE(MAR0, mc_filter[0]);
+		ADM8211_CSR_WRITE(MAR1, mc_filter[1]);
+		ADM8211_CSR_READ(NAR);
+
+		ADM8211_RESTORE();
+	}
 }
 
 static int adm8211_get_tx_stats(struct ieee80211_hw *dev,
@@ -1414,19 +1448,6 @@ static void adm8211_set_interval(struct 
 	ADM8211_CSR_WRITE(BPLI, reg);
 }
 
-static void adm8211_set_bssid(struct ieee80211_hw *dev, u8 *bssid)
-{
-	struct adm8211_priv *priv = dev->priv;
-	u32 reg;
-
-	reg = bssid[0] | (bssid[1] << 8) | (bssid[2] << 16) | (bssid[3] << 24);
-	ADM8211_CSR_WRITE(BSSID0, reg);
-	reg = ADM8211_CSR_READ(ABDA1);
-	reg &= 0x0000ffff;
-	reg |= (bssid[4] << 16) | (bssid[5] << 24);
-	ADM8211_CSR_WRITE(ABDA1, reg);
-}
-
 static int adm8211_set_ssid(struct ieee80211_hw *dev, u8 *ssid, size_t ssid_len)
 {
 	struct adm8211_priv *priv = dev->priv;
@@ -1502,6 +1523,8 @@ static void adm8211_remove_interface(str
 {
 	struct adm8211_priv *priv = dev->priv;
 	priv->mode = IEEE80211_IF_TYPE_MGMT;
+
+	/* TODO: clear MAC address */
 }
 
 static int adm8211_init_rings(struct ieee80211_hw *dev)
@@ -1585,7 +1608,7 @@ static void adm8211_free_rings(struct ie
 	}
 }
 
-static int adm8211_open(struct ieee80211_hw *dev)
+static int adm8211_start(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
 	int retval;
@@ -1628,7 +1651,7 @@ fail:
 	return retval;
 }
 
-static int adm8211_stop(struct ieee80211_hw *dev)
+static void adm8211_stop(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
 
@@ -1640,7 +1663,6 @@ static int adm8211_stop(struct ieee80211
 	free_irq(priv->pdev->irq, dev);
 
 	adm8211_free_rings(dev);
-	return 0;
 }
 
 static void adm8211_calc_durations(int *dur, int *plcp, size_t payload_len, int len,
@@ -1841,13 +1863,13 @@ static int adm8211_alloc_rings(struct ie
 
 static const struct ieee80211_ops adm8211_ops = {
 	.tx			= adm8211_tx,
-	.open			= adm8211_open,
+	.start			= adm8211_start,
 	.stop			= adm8211_stop,
 	.add_interface		= adm8211_add_interface,
 	.remove_interface	= adm8211_remove_interface,
 	.config			= adm8211_config,
 	.config_interface	= adm8211_config_interface,
-	.set_multicast_list	= adm8211_set_rx_mode,
+	.configure_filter	= adm8211_configure_filter,
 	.get_stats		= adm8211_get_stats,
 	.get_tx_stats		= adm8211_get_tx_stats,
 	.get_tsf		= adm8211_get_tsft
@@ -1953,7 +1975,8 @@ static int __devinit adm8211_probe(struc
 	SET_IEEE80211_PERM_ADDR(dev, perm_addr);
 
 	dev->extra_tx_headroom = sizeof(struct adm8211_tx_hdr);
-	dev->flags = IEEE80211_HW_WEP_INCLUDE_IV | IEEE80211_HW_NO_TKIP_WMM_HWACCEL;
+	dev->flags = IEEE80211_HW_WEP_INCLUDE_IV | IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
+		     IEEE80211_HW_MULTICAST_FILTER;
 	// however, IEEE80211_HW_RX_INCLUDES_FCS in promisc mode
 
 	dev->channel_change_time = 1000;
@@ -2082,7 +2105,7 @@ static int adm8211_resume(struct pci_dev
 	pci_restore_state(pdev);
 
 	if (priv->mode != IEEE80211_IF_TYPE_MGMT) {
-		adm8211_open(dev);
+		adm8211_start(dev);
 		ieee80211_start_queues(dev);
 	}
 
--- wireless-dev.orig/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c	2007-08-15 16:48:52.366516958 +0200
+++ wireless-dev/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c	2007-08-16 16:40:06.463468950 +0200
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
@@ -693,7 +680,7 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 	buffer += ZD_PLCP_HEADER_SIZE;
 
 	if (filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats) &&
-	    !has_monitor_interfaces(mac))
+	    0 /* XXX: need to work off the filter flags! */)
 		return 0;
 
 	skb = dev_alloc_skb(length);
@@ -715,7 +702,6 @@ static int zd_op_add_interface(struct ie
 		return -1;
 
 	switch (conf->type) {
-	case IEEE80211_IF_TYPE_MNTR:
 	case IEEE80211_IF_TYPE_STA:
 		mac->type = conf->type;
 		break;
@@ -765,18 +751,19 @@ static void set_multicast_hash_handler(s
 	zd_chip_set_multicast_hash(&mac->chip, &hash);
 }
 
-static void zd_op_set_multicast_list(struct ieee80211_hw *hw,
-				      unsigned short dev_flags, int mc_count)
+static void zd_op_configure_filter(struct ieee80211_hw *hw,
+				   int multi_count,
+				   unsigned int change,
+				   unsigned int *filterflags)
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
-	} else {
+	} else if (multi_count >= 0) {
 		struct dev_mc_list *mc = NULL;
 		void *tmp = NULL;
 		zd_mc_clear(&hash);
@@ -787,10 +774,18 @@ static void zd_op_set_multicast_list(str
 		}
 	}
 
-	spin_lock_irqsave(&mac->lock, flags);
-	mac->multicast_hash = hash;
-	spin_unlock_irqrestore(&mac->lock, flags);
-	queue_work(zd_workqueue, &mac->set_multicast_hash_work);
+	/*
+	 * XXX: probably not right, we probably see many other
+	 * frames as well...
+	 */
+	*filterflags &= FIF_PROMISC_IN_BSS | FIF_ALLMULTI;
+
+	if (multi_count >= 0) {
+		spin_lock_irqsave(&mac->lock, flags);
+		mac->multicast_hash = hash;
+		spin_unlock_irqrestore(&mac->lock, flags);
+		queue_work(zd_workqueue, &mac->set_multicast_hash_work);
+	}
 }
 
 static void set_rts_cts_work(struct work_struct *work)
@@ -834,13 +829,13 @@ static void zd_op_erp_ie_changed(struct 
 
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
+	.configure_filter	= zd_op_configure_filter,
 	.erp_ie_changed		= zd_op_erp_ie_changed,
 };
 
@@ -880,7 +875,8 @@ struct ieee80211_hw *zd_mac_alloc_hw(str
 
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_WEP_INCLUDE_IV |
-		     IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED;
+		     IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED |
+		     IEEE80211_HW_MULTICAST_FILTER;
 	hw->max_rssi = 100;
 	hw->max_signal = 100;
 
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-08-16 16:12:07.503468950 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-08-16 16:49:06.753468950 +0200
@@ -3584,10 +3584,10 @@ void ieee80211_scan_completed(struct iee
 		printk(KERN_DEBUG "%s: failed to restore operational"
 		       "channel after scan\n", dev->name);
 
-	if (!(local->hw.flags & IEEE80211_HW_NO_PROBE_FILTERING) &&
-	    ieee80211_if_config(dev))
-		printk(KERN_DEBUG "%s: failed to restore operational"
-		       "BSSID after scan\n", dev->name);
+	local->filter_flags &= ~FIF_BCN_PRBRESP_PROMISC;
+	local->ops->configure_filter(local_to_hw(local), -1,
+				     FIF_BCN_PRBRESP_PROMISC,
+				     &local->filter_flags);
 
 	memset(&wrqu, 0, sizeof(wrqu));
 	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
@@ -3771,10 +3771,10 @@ static int ieee80211_sta_start_scan(stru
 	local->scan_channel_idx = 0;
 	local->scan_dev = dev;
 
-	if (!(local->hw.flags & IEEE80211_HW_NO_PROBE_FILTERING) &&
-	    ieee80211_if_config(dev))
-		printk(KERN_DEBUG "%s: failed to set BSSID for scan\n",
-		       dev->name);
+	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
+	local->ops->configure_filter(local_to_hw(local), -1,
+				     FIF_BCN_PRBRESP_PROMISC,
+				     &local->filter_flags);
 
 	/* TODO: start scan as soon as all nullfunc frames are ACKed */
 	queue_delayed_work(local->hw.workqueue, &local->scan_work,



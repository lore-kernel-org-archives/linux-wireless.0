Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:10804 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350AbXCHVPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 16:15:08 -0500
Received: by ug-out-1314.google.com with SMTP id 44so1088733uga
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2007 13:15:04 -0800 (PST)
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/4] rt2x00: Split rt2x00dev.c
Date: Thu, 8 Mar 2007 22:14:50 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200703082214.50497.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This splits the rt2x00dev file into rt2x00dev.c and rt2x00mac.c
The latter of those 2 files is intended for the mac80211 callback
functions. This makes the contents of both files clearer and
makes moving new functions into rt2x00dev.c easier.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/Makefile b/drivers/net/wireless/mac80211/rt2x00/Makefile
index f9f9810..52f8b1e 100644
--- a/drivers/net/wireless/mac80211/rt2x00/Makefile
+++ b/drivers/net/wireless/mac80211/rt2x00/Makefile
@@ -1,4 +1,4 @@
-rt2x00lib-objs := rt2x00dev.o
+rt2x00lib-objs := rt2x00dev.o rt2x00mac.o
 
 obj-$(CONFIG_RT2X00_LIB)	+= rt2x00lib.o
 obj-$(CONFIG_RT2400PCI)		+= rt2400pci.o
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
index 8dacf00..9c9c79c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
@@ -20,7 +20,7 @@
 
 /*
 	Module: rt2x00lib
-	Abstract: rt2x00 generic routines.
+	Abstract: rt2x00 generic device routines.
 	Supported chipsets: RT2460, RT2560, RT2570,
 	rt2561, rt2561s, rt2661 & rt2573.
  */
@@ -35,7 +35,7 @@
 #include <linux/version.h>
 #include <linux/init.h>
 #include <linux/delay.h>
-#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 
 #include "rt2x00.h"
 #include "rt2x00lib.h"
@@ -203,515 +203,6 @@ int rt2x00lib_detect_channel_time(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_detect_channel_time);
 
-static int rt2x00_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
-	struct data_ring *ring, struct sk_buff *frag_skb,
-	struct ieee80211_tx_control *control)
-{
-	struct sk_buff *skb;
-	int size;
-
-	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
-		size = sizeof(struct ieee80211_cts);
-	else
-		size = sizeof(struct ieee80211_rts);
-
-	skb = dev_alloc_skb(size + rt2x00dev->hw->extra_tx_headroom);
-	if (!skb) {
-		WARNING("Failed to create RTS/CTS frame.\n");
-		return NETDEV_TX_BUSY;
-	}
-
-	skb_reserve(skb, rt2x00dev->hw->extra_tx_headroom);
-	skb_put(skb, size);
-
-	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
-		ieee80211_ctstoself_get(rt2x00dev->hw,
-			frag_skb->data, frag_skb->len, control,
-			(struct ieee80211_cts*)(skb->data));
-	else
-		ieee80211_rts_get(rt2x00dev->hw,
-			frag_skb->data, frag_skb->len, control,
-			(struct ieee80211_rts*)(skb->data));
-
-	if (rt2x00dev->lib_ops->write_tx_data(rt2x00dev, ring, skb, control)) {
-		WARNING("Failed to send RTS/CTS frame.\n");
-		return NETDEV_TX_BUSY;
-	}
-
-	return NETDEV_TX_OK;
-}
-
-int rt2x00lib_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-	struct ieee80211_tx_control *control)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
-	struct data_ring *ring;
-	u16 frame_control;
-
-	/*
-	 * Determine which ring to put packet on.
-	 */
-	ring = rt2x00_get_ring(rt2x00dev, control->queue);
-	if (unlikely(!ring)) {
-		ERROR("Attempt to send packet over invalid queue %d.\n"
-			"Please file bug report to %s.\n",
-			control->queue, DRV_PROJECT);
-		dev_kfree_skb_any(skb);
-		return NETDEV_TX_OK;
-	}
-
-	/*
-	 * If CTS/RTS is required. and this frame is not CTS or RTS,
-	 * create and queue that frame first. But make sure we have
-	 * at least enough entries available to send this CTS/RTS
-	 * frame as well as the data frame.
-	 */
-	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
-	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS &&
-	    !is_cts_frame(frame_control) && !is_rts_frame(frame_control)) {
-		if (rt2x00_ring_free(ring) <= 1)
-			return NETDEV_TX_BUSY;
-
-		if (rt2x00_tx_rts_cts(rt2x00dev, ring, skb, control))
-			return NETDEV_TX_BUSY;
-	}
-
-	if (rt2x00dev->lib_ops->write_tx_data(rt2x00dev, ring, skb, control))
-		return NETDEV_TX_BUSY;
-
-	if (rt2x00dev->lib_ops->kick_tx_queue)
-		rt2x00dev->lib_ops->kick_tx_queue(rt2x00dev, control->queue);
-
-	return NETDEV_TX_OK;
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_tx);
-
-int rt2x00lib_reset(struct ieee80211_hw *hw)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-
-	rt2x00dev->lib_ops->disable_radio(rt2x00dev);
-	return rt2x00dev->lib_ops->enable_radio(rt2x00dev);
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_reset);
-
-int rt2x00lib_add_interface(struct ieee80211_hw *hw,
-	struct ieee80211_if_init_conf *conf)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct interface *intf = &rt2x00dev->interface;
-	int status;
-
-	/*
-	 * We only support 1 non-monitor interface.
-	 */
-	if (conf->type != IEEE80211_IF_TYPE_MNTR &&
-	    GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
-		return -ENOBUFS;
-
-	/*
-	 * We support muliple monitor mode interfaces.
-	 * All we need to do is increase the monitor_count.
-	 */
-	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
-		intf->monitor_count++;
-	} else {
-		intf->id = conf->if_id;
-		intf->type = conf->type;
-		if (conf->type == IEEE80211_IF_TYPE_AP)
-			memcpy(&intf->bssid, conf->mac_addr, ETH_ALEN);
-		intf->promisc = 0;
-	}
-
-	/*
-	 * Initialize interface, and enable the radio when this
-	 * is the first interface that is brought up.
-	 */
-	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
-		/*
-		 * Before doing anything else, the MAC address
-		 * of this device should be initialized correctly.
-		 */
-		rt2x00dev->lib_ops->config_mac_addr(rt2x00dev, conf->mac_addr);
-
-		/*
-		 * Initialize the device.
-		 */
-		status = rt2x00dev->lib_ops->initialize(rt2x00dev);
-		if (status)
-			return status;
-
-		/*
-		 * Enable radio.
-		 */
-		status = rt2x00dev->lib_ops->enable_radio(rt2x00dev);
-		if (status)
-			return status;
-	}
-
-	/*
-	 * Enable periodic link tuning if this is a non-monitor
-	 * interface. Also set the INTERFACE_INITIALIZED FLAG
-	 * to prevent new non-monitor interfaces to be added.
-	 */
-	if (conf->type != IEEE80211_IF_TYPE_MNTR) {
-		queue_delayed_work(rt2x00dev->workqueue,
-			&rt2x00dev->link.work, LINK_TUNE_INTERVAL);
-		SET_FLAG(rt2x00dev, INTERFACE_INITIALIZED);
-	} else
-		SET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_add_interface);
-
-void rt2x00lib_remove_interface(struct ieee80211_hw *hw,
-	struct ieee80211_if_init_conf *conf)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct interface *intf = &rt2x00dev->interface;
-
-	/*
-	 * We only support 1 non-monitor interface.
-	 */
-	if (conf->type != IEEE80211_IF_TYPE_MNTR &&
-	    !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
-		return;
-
-	/*
-	 * We support muliple monitor mode interfaces.
-	 * All we need to do is decrease the monitor_count.
-	 */
-	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
-		intf->monitor_count--;
-	} else if (intf->type == conf->type) {
-		intf->id = 0;
-		intf->type = -EINVAL;
-		memset(&intf->bssid, 0x00, ETH_ALEN);
-		intf->promisc = 0;
-	}
-
-	/*
-	 * When this is a non-monitor mode,
-	 * stop the periodic link tuning,
-	 * and clear the INTERFACE_INITIALIZED FLAG to allow
-	 * new non-monitor interfaces to be added.
-	 */
-	if (conf->type != IEEE80211_IF_TYPE_MNTR) {
-		if (work_pending(&rt2x00dev->link.work.work))
-			cancel_rearming_delayed_workqueue(
-				rt2x00dev->workqueue, &rt2x00dev->link.work);
-		CLEAR_FLAG(rt2x00dev, INTERFACE_INITIALIZED);
-	}
-
-	/*
-	 * Disable radio if this was the last interface
-	 * that was working with this device.
-	 */
-	if (!GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
-	    !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
-		rt2x00dev->lib_ops->disable_radio(rt2x00dev);
-
-	/*
-	 * Check if we still have 1 non-monitor or a monitor
-	 * interface enabled. In that case we should update the
-	 * registers.
-	 */
-	if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) ^
-	    GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED)) {
-		if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
-			rt2x00dev->lib_ops->config_type(rt2x00dev,
-				rt2x00dev->interface.type);
-		else
-			rt2x00dev->lib_ops->config_type(rt2x00dev,
-				IEEE80211_IF_TYPE_MNTR);
-	}
-
-	/*
-	 * Check which interfaces have been disabled.
-	 */
-	if (!GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
-		CLEAR_FLAG(rt2x00dev, INTERFACE_ENABLED);
-	else if (!rt2x00dev->interface.monitor_count)
-		CLEAR_FLAG(rt2x00dev, INTERFACE_ENABLED_MONITOR);
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_remove_interface);
-
-int rt2x00lib_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-
-	/*
-	 * Check if we need to disable the radio,
-	 * if this is not the case, at least the RX must be disabled.
-	 */
-	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
-		if (!conf->radio_enabled)
-			rt2x00dev->lib_ops->disable_radio(rt2x00dev);
-		else {
-			rt2x00dev->lib_ops->toggle_rx(rt2x00dev, 0);
-		}
-	}
-
-	rt2x00dev->lib_ops->config_phymode(rt2x00dev, conf->phymode);
-	rt2x00dev->lib_ops->config_channel(rt2x00dev,
-		conf->channel_val, conf->channel, conf->freq,
-		conf->power_level);
-	rt2x00dev->lib_ops->config_txpower(rt2x00dev, conf->power_level);
-	rt2x00dev->lib_ops->config_antenna(rt2x00dev,
-		conf->antenna_sel_tx, conf->antenna_sel_rx);
-	rt2x00dev->lib_ops->config_duration(rt2x00dev,
-		(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME));
-
-	/*
-	 * Reenable RX only if the radio should be on.
-	 */
-	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
-		rt2x00dev->lib_ops->toggle_rx(rt2x00dev, 1);
-	} else if (conf->radio_enabled)
-		return rt2x00dev->lib_ops->enable_radio(rt2x00dev);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_config);
-
-int rt2x00lib_config_interface(struct ieee80211_hw *hw, int if_id,
-	struct ieee80211_if_conf *conf)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct interface *intf = &rt2x00dev->interface;
-
-	/*
-	 * Monitor mode does not need configuring.
-	 * If the given type does not match the configured type,
-	 * there has been a problem.
-	 */
-	if (conf->type == IEEE80211_IF_TYPE_MNTR)
-		return 0;
-	else if (conf->type != intf->type)
-		return -EINVAL;
-
-	/*
-	 * If the interface does not work in master mode,
-	 * then the bssid value in the interface structure
-	 * should now be set.
-	 */
-	if (conf->type != IEEE80211_IF_TYPE_AP)
-		memcpy(&intf->bssid, conf->bssid, ETH_ALEN);
-
-	/*
-	 * Enable configuration.
-	 */
-	rt2x00dev->lib_ops->config_type(rt2x00dev, conf->type);
-	rt2x00dev->lib_ops->config_bssid(rt2x00dev, intf->bssid);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_config_interface);
-
-void rt2x00lib_set_multicast_list(struct ieee80211_hw *hw,
-	unsigned short flags, int mc_count)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	int update = 0;
-
-	if (GET_FLAG(rt2x00dev, INTERFACE_ENABLED_PROMISC)) {
-		if (!(flags & IFF_PROMISC)) {
-			rt2x00dev->interface.promisc = 0;
-			update = 1;
-		}
-	} else {
-		if (flags & IFF_PROMISC) {
-			rt2x00dev->interface.promisc = 1;
-			update = 1;
-		}
-	}
-
-	/*
-	 * Monitor mode works with PROMISC mode forced on,
-	 * so there is nothing to be done here in that case.
-	 */
-	if (update && !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR)) {
-		if (rt2x00dev->lib_ops->config_promisc)
-			rt2x00dev->lib_ops->config_promisc(rt2x00dev,
-				rt2x00dev->interface.promisc);
-		else
-			NOTICE("For the moment promisc mode is ignored");
-	}
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_set_multicast_list);
-
-static void rt2x00lib_scan(struct work_struct *work)
-{
-	struct scanning *scan =
-		container_of(work, struct scanning, work);
-
-	if (unlikely(!scan->rt2x00dev))
-		return;
-
-	/*
-	 * Before we can start switch the channel for scanning
-	 * we need to wait until all TX rings are empty to guarantee
-	 * that all frames are send on the correct channel.
-	 * Check if the status is set SCANNING_WAITING in order to
-	 * start waiting, or if it is set to SCANNING_CANCELLED which
-	 * means that we shouldn't proceed with the scanning.
-	 */
-	if (scan->status == SCANNING_WAITING)
-		wait_for_completion(&scan->completion);
-	if (scan->status == SCANNING_CANCELLED)
-		goto exit;
-
-	/*
-	 * Switch channel and update active info for RX.
-	 */
-	if (scan->state == IEEE80211_SCAN_START) {
-		scan->rt2x00dev->lib_ops->config_phymode(
-			scan->rt2x00dev,
-			scan->conf.scan_phymode);
-
-		scan->rt2x00dev->lib_ops->config_channel(
-			scan->rt2x00dev,
-			scan->conf.scan_channel_val,
-			scan->conf.scan_channel,
-			scan->conf.scan_freq,
-			scan->conf.scan_power_level);
-	} else {
-		scan->rt2x00dev->lib_ops->config_phymode(
-			scan->rt2x00dev,
-			scan->conf.running_phymode);
-
-		scan->rt2x00dev->lib_ops->config_channel(
-			scan->rt2x00dev,
-			scan->conf.running_channel_val,
-			scan->conf.running_channel,
-			scan->conf.running_freq,
-			scan->conf.scan_power_level);
-	}
-
-exit:
-	scan->rt2x00dev->scan = NULL;
-	kfree(scan);
-}
-
-int rt2x00lib_passive_scan(struct ieee80211_hw *hw,
-	int state, struct ieee80211_scan_conf *conf)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-
-	/*
-	 * Check if we are not busy with the previous
-	 * passive scan request.
-	 */
-	if (rt2x00dev->scan)
-		return -EBUSY;
-
-	/*
-	 * Check if the radio is enabled.
-	 */
-	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
-		return -EIO;
-
-	/*
-	 * Allocate scanning structure to store scanning info.
-	 */
-	rt2x00dev->scan = kzalloc(sizeof(struct scanning), GFP_ATOMIC);
-	if (!rt2x00dev->scan)
-		return -ENOMEM;
-
-	/*
-	 * Initialize Scanning structure.
-	 */
-	rt2x00dev->scan->rt2x00dev = rt2x00dev;
-	rt2x00dev->scan->state = state;
-	memcpy(&rt2x00dev->scan->conf, conf, sizeof(*conf));
-
-	/*
-	 * Initialize completion handler.
-	 * Set initial status to SCANNING_WAITING to prevent scanning
-	 * to begin while there are still TX packets queued.
-	 */
-	init_completion(&rt2x00dev->scan->completion);
-	rt2x00dev->scan->status = SCANNING_WAITING;
-
-	/*
-	 * Check if we have to send a packet before the
-	 * channel switch.
-	 */
-	if (conf->skb) {
-		if (rt2x00dev->hw_ops->tx(hw, conf->skb, conf->tx_control))
-			goto exit;
-	}
-
-	/*
-	 * Queue work.
-	 */
-	INIT_WORK(&rt2x00dev->scan->work, rt2x00lib_scan);
-	if (!queue_work(rt2x00dev->workqueue, &rt2x00dev->scan->work))
-		goto exit;
-
-	return 0;
-
-exit:
-	kfree(rt2x00dev->scan);
-	rt2x00dev->scan = NULL;
-
-	return -EIO;
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_passive_scan);
-
-int rt2x00lib_get_tx_stats(struct ieee80211_hw *hw,
-	struct ieee80211_tx_queue_stats *stats)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	unsigned int i;
-
-	for (i = 0; i < hw->queues; i++)
-		memcpy(&stats->data[i], &rt2x00dev->ring[i].stats,
-			sizeof(rt2x00dev->ring[i].stats));
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_get_tx_stats);
-
-int rt2x00lib_conf_tx(struct ieee80211_hw *hw, int queue,
-	const struct ieee80211_tx_queue_params *params)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct data_ring *ring;
-
-	ring = rt2x00_get_ring(rt2x00dev, queue);
-	if (unlikely(!ring))
-		return -EINVAL;
-
-	/*
-	 * The passed variables are stored as real value ((2^n)-1).
-	 * RT2500 registers require to know the bit number 'n'.
-	 */
-	if (params->cw_min)
-		ring->tx_params.cw_min = fls(params->cw_min);
-	else
-		ring->tx_params.cw_min = 5; /* cw_min: 2^5 = 32. */
-
-	if (params->cw_max)
-		ring->tx_params.cw_max = fls(params->cw_max);
-	else
-		ring->tx_params.cw_max = 10; /* cw_min: 2^10 = 1024. */
-
-	if (params->aifs)
-		ring->tx_params.aifs = params->aifs;
-	else
-		ring->tx_params.aifs = 2;
-
-	INFO("Configured TX ring %d - CWmin: %d, CWmax: %d, Aifs: %d.\n",
-		queue, ring->tx_params.cw_min, ring->tx_params.cw_max,
-		ring->tx_params.aifs);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rt2x00lib_conf_tx);
-
 /*
  * rt2x00lib module information.
  */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h
index 5ec88a6..71559cf 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00lib.h
@@ -30,10 +30,16 @@
 
 #include <linux/firmware.h>
 
+/*
+ * Firmware handlers.
+ */
 int rt2x00lib_load_firmware(struct rt2x00_dev *rt2x00dev, struct device *dev,
 	void (*cont)(const struct firmware *fw, void *context));
 int rt2x00lib_load_firmware_wait(struct rt2x00_dev *rt2x00dev);
 
+/*
+ * Interrupt context handlers.
+ */
 void rt2x00lib_update_tx_stats(struct data_entry *entry,
 	const int status, const int is_ack, const int retry);
 void rt2x00lib_update_rx_stats(struct rt2x00_dev *rt2x00dev,
@@ -41,6 +47,9 @@ void rt2x00lib_update_rx_stats(struct rt2x00_dev *rt2x00dev,
 
 int rt2x00lib_detect_channel_time(struct rt2x00_dev *rt2x00dev);
 
+/*
+ * mac80211 handlers.
+ */
 int rt2x00lib_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_tx_control *control);
 int rt2x00lib_reset(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
new file mode 100644
index 0000000..eaf267a
--- /dev/null
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
@@ -0,0 +1,540 @@
+/*
+	Copyright (C) 2004 - 2007 rt2x00 SourceForge Project
+	<http://rt2x00.serialmonkey.com>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+/*
+	Module: rt2x00lib
+	Abstract: rt2x00 generic mac80211 routines.
+	Supported chipsets: RT2460, RT2560, RT2570,
+	rt2561, rt2561s, rt2661 & rt2573.
+ */
+
+#include <linux/netdevice.h>
+
+#include "rt2x00.h"
+#include "rt2x00lib.h"
+
+static int rt2x00_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
+	struct data_ring *ring, struct sk_buff *frag_skb,
+	struct ieee80211_tx_control *control)
+{
+	struct sk_buff *skb;
+	int size;
+
+	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
+		size = sizeof(struct ieee80211_cts);
+	else
+		size = sizeof(struct ieee80211_rts);
+
+	skb = dev_alloc_skb(size + rt2x00dev->hw->extra_tx_headroom);
+	if (!skb) {
+		WARNING("Failed to create RTS/CTS frame.\n");
+		return NETDEV_TX_BUSY;
+	}
+
+	skb_reserve(skb, rt2x00dev->hw->extra_tx_headroom);
+	skb_put(skb, size);
+
+	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
+		ieee80211_ctstoself_get(rt2x00dev->hw,
+			frag_skb->data, frag_skb->len, control,
+			(struct ieee80211_cts*)(skb->data));
+	else
+		ieee80211_rts_get(rt2x00dev->hw,
+			frag_skb->data, frag_skb->len, control,
+			(struct ieee80211_rts*)(skb->data));
+
+	if (rt2x00dev->lib_ops->write_tx_data(rt2x00dev, ring, skb, control)) {
+		WARNING("Failed to send RTS/CTS frame.\n");
+		return NETDEV_TX_BUSY;
+	}
+
+	return NETDEV_TX_OK;
+}
+
+int rt2x00lib_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+	struct ieee80211_tx_control *control)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
+	struct data_ring *ring;
+	u16 frame_control;
+
+	/*
+	 * Determine which ring to put packet on.
+	 */
+	ring = rt2x00_get_ring(rt2x00dev, control->queue);
+	if (unlikely(!ring)) {
+		ERROR("Attempt to send packet over invalid queue %d.\n"
+			"Please file bug report to %s.\n",
+			control->queue, DRV_PROJECT);
+		dev_kfree_skb_any(skb);
+		return NETDEV_TX_OK;
+	}
+
+	/*
+	 * If CTS/RTS is required. and this frame is not CTS or RTS,
+	 * create and queue that frame first. But make sure we have
+	 * at least enough entries available to send this CTS/RTS
+	 * frame as well as the data frame.
+	 */
+	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
+	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS &&
+	    !is_cts_frame(frame_control) && !is_rts_frame(frame_control)) {
+		if (rt2x00_ring_free(ring) <= 1)
+			return NETDEV_TX_BUSY;
+
+		if (rt2x00_tx_rts_cts(rt2x00dev, ring, skb, control))
+			return NETDEV_TX_BUSY;
+	}
+
+	if (rt2x00dev->lib_ops->write_tx_data(rt2x00dev, ring, skb, control))
+		return NETDEV_TX_BUSY;
+
+	if (rt2x00dev->lib_ops->kick_tx_queue)
+		rt2x00dev->lib_ops->kick_tx_queue(rt2x00dev, control->queue);
+
+	return NETDEV_TX_OK;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_tx);
+
+int rt2x00lib_reset(struct ieee80211_hw *hw)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	rt2x00dev->lib_ops->disable_radio(rt2x00dev);
+	return rt2x00dev->lib_ops->enable_radio(rt2x00dev);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_reset);
+
+int rt2x00lib_add_interface(struct ieee80211_hw *hw,
+	struct ieee80211_if_init_conf *conf)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct interface *intf = &rt2x00dev->interface;
+	int status;
+
+	/*
+	 * We only support 1 non-monitor interface.
+	 */
+	if (conf->type != IEEE80211_IF_TYPE_MNTR &&
+	    GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
+		return -ENOBUFS;
+
+	/*
+	 * We support muliple monitor mode interfaces.
+	 * All we need to do is increase the monitor_count.
+	 */
+	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
+		intf->monitor_count++;
+	} else {
+		intf->id = conf->if_id;
+		intf->type = conf->type;
+		if (conf->type == IEEE80211_IF_TYPE_AP)
+			memcpy(&intf->bssid, conf->mac_addr, ETH_ALEN);
+		intf->promisc = 0;
+	}
+
+	/*
+	 * Initialize interface, and enable the radio when this
+	 * is the first interface that is brought up.
+	 */
+	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
+		/*
+		 * Before doing anything else, the MAC address
+		 * of this device should be initialized correctly.
+		 */
+		rt2x00dev->lib_ops->config_mac_addr(rt2x00dev, conf->mac_addr);
+
+		/*
+		 * Initialize the device.
+		 */
+		status = rt2x00dev->lib_ops->initialize(rt2x00dev);
+		if (status)
+			return status;
+
+		/*
+		 * Enable radio.
+		 */
+		status = rt2x00dev->lib_ops->enable_radio(rt2x00dev);
+		if (status)
+			return status;
+	}
+
+	/*
+	 * Enable periodic link tuning if this is a non-monitor
+	 * interface. Also set the INTERFACE_INITIALIZED FLAG
+	 * to prevent new non-monitor interfaces to be added.
+	 */
+	if (conf->type != IEEE80211_IF_TYPE_MNTR) {
+		queue_delayed_work(rt2x00dev->workqueue,
+			&rt2x00dev->link.work, LINK_TUNE_INTERVAL);
+		SET_FLAG(rt2x00dev, INTERFACE_INITIALIZED);
+	} else
+		SET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_add_interface);
+
+void rt2x00lib_remove_interface(struct ieee80211_hw *hw,
+	struct ieee80211_if_init_conf *conf)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct interface *intf = &rt2x00dev->interface;
+
+	/*
+	 * We only support 1 non-monitor interface.
+	 */
+	if (conf->type != IEEE80211_IF_TYPE_MNTR &&
+	    !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
+		return;
+
+	/*
+	 * We support muliple monitor mode interfaces.
+	 * All we need to do is decrease the monitor_count.
+	 */
+	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
+		intf->monitor_count--;
+	} else if (intf->type == conf->type) {
+		intf->id = 0;
+		intf->type = -EINVAL;
+		memset(&intf->bssid, 0x00, ETH_ALEN);
+		intf->promisc = 0;
+	}
+
+	/*
+	 * When this is a non-monitor mode,
+	 * stop the periodic link tuning,
+	 * and clear the INTERFACE_INITIALIZED FLAG to allow
+	 * new non-monitor interfaces to be added.
+	 */
+	if (conf->type != IEEE80211_IF_TYPE_MNTR) {
+		if (work_pending(&rt2x00dev->link.work.work))
+			cancel_rearming_delayed_workqueue(
+				rt2x00dev->workqueue, &rt2x00dev->link.work);
+		CLEAR_FLAG(rt2x00dev, INTERFACE_INITIALIZED);
+	}
+
+	/*
+	 * Disable radio if this was the last interface
+	 * that was working with this device.
+	 */
+	if (!GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) &&
+	    !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
+		rt2x00dev->lib_ops->disable_radio(rt2x00dev);
+
+	/*
+	 * Check if we still have 1 non-monitor or a monitor
+	 * interface enabled. In that case we should update the
+	 * registers.
+	 */
+	if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR) ^
+	    GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED)) {
+		if (GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
+			rt2x00dev->lib_ops->config_type(rt2x00dev,
+				rt2x00dev->interface.type);
+		else
+			rt2x00dev->lib_ops->config_type(rt2x00dev,
+				IEEE80211_IF_TYPE_MNTR);
+	}
+
+	/*
+	 * Check which interfaces have been disabled.
+	 */
+	if (!GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED))
+		CLEAR_FLAG(rt2x00dev, INTERFACE_ENABLED);
+	else if (!rt2x00dev->interface.monitor_count)
+		CLEAR_FLAG(rt2x00dev, INTERFACE_ENABLED_MONITOR);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_remove_interface);
+
+int rt2x00lib_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	/*
+	 * Check if we need to disable the radio,
+	 * if this is not the case, at least the RX must be disabled.
+	 */
+	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
+		if (!conf->radio_enabled)
+			rt2x00dev->lib_ops->disable_radio(rt2x00dev);
+		else {
+			rt2x00dev->lib_ops->toggle_rx(rt2x00dev, 0);
+		}
+	}
+
+	rt2x00dev->lib_ops->config_phymode(rt2x00dev, conf->phymode);
+	rt2x00dev->lib_ops->config_channel(rt2x00dev,
+		conf->channel_val, conf->channel, conf->freq,
+		conf->power_level);
+	rt2x00dev->lib_ops->config_txpower(rt2x00dev, conf->power_level);
+	rt2x00dev->lib_ops->config_antenna(rt2x00dev,
+		conf->antenna_sel_tx, conf->antenna_sel_rx);
+	rt2x00dev->lib_ops->config_duration(rt2x00dev,
+		(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME));
+
+	/*
+	 * Reenable RX only if the radio should be on.
+	 */
+	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
+		rt2x00dev->lib_ops->toggle_rx(rt2x00dev, 1);
+	} else if (conf->radio_enabled)
+		return rt2x00dev->lib_ops->enable_radio(rt2x00dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_config);
+
+int rt2x00lib_config_interface(struct ieee80211_hw *hw, int if_id,
+	struct ieee80211_if_conf *conf)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct interface *intf = &rt2x00dev->interface;
+
+	/*
+	 * Monitor mode does not need configuring.
+	 * If the given type does not match the configured type,
+	 * there has been a problem.
+	 */
+	if (conf->type == IEEE80211_IF_TYPE_MNTR)
+		return 0;
+	else if (conf->type != intf->type)
+		return -EINVAL;
+
+	/*
+	 * If the interface does not work in master mode,
+	 * then the bssid value in the interface structure
+	 * should now be set.
+	 */
+	if (conf->type != IEEE80211_IF_TYPE_AP)
+		memcpy(&intf->bssid, conf->bssid, ETH_ALEN);
+
+	/*
+	 * Enable configuration.
+	 */
+	rt2x00dev->lib_ops->config_type(rt2x00dev, conf->type);
+	rt2x00dev->lib_ops->config_bssid(rt2x00dev, intf->bssid);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_config_interface);
+
+void rt2x00lib_set_multicast_list(struct ieee80211_hw *hw,
+	unsigned short flags, int mc_count)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	int update = 0;
+
+	if (GET_FLAG(rt2x00dev, INTERFACE_ENABLED_PROMISC)) {
+		if (!(flags & IFF_PROMISC)) {
+			rt2x00dev->interface.promisc = 0;
+			update = 1;
+		}
+	} else {
+		if (flags & IFF_PROMISC) {
+			rt2x00dev->interface.promisc = 1;
+			update = 1;
+		}
+	}
+
+	/*
+	 * Monitor mode works with PROMISC mode forced on,
+	 * so there is nothing to be done here in that case.
+	 */
+	if (update && !GET_FLAG(rt2x00dev, INTERFACE_INITIALIZED_MONITOR)) {
+		if (rt2x00dev->lib_ops->config_promisc)
+			rt2x00dev->lib_ops->config_promisc(rt2x00dev,
+				rt2x00dev->interface.promisc);
+		else
+			NOTICE("For the moment promisc mode is ignored");
+	}
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_set_multicast_list);
+
+static void rt2x00lib_scan(struct work_struct *work)
+{
+	struct scanning *scan =
+		container_of(work, struct scanning, work);
+
+	if (unlikely(!scan->rt2x00dev))
+		return;
+
+	/*
+	 * Before we can start switch the channel for scanning
+	 * we need to wait until all TX rings are empty to guarantee
+	 * that all frames are send on the correct channel.
+	 * Check if the status is set SCANNING_WAITING in order to
+	 * start waiting, or if it is set to SCANNING_CANCELLED which
+	 * means that we shouldn't proceed with the scanning.
+	 */
+	if (scan->status == SCANNING_WAITING)
+		wait_for_completion(&scan->completion);
+	if (scan->status == SCANNING_CANCELLED)
+		goto exit;
+
+	/*
+	 * Switch channel and update active info for RX.
+	 */
+	if (scan->state == IEEE80211_SCAN_START) {
+		scan->rt2x00dev->lib_ops->config_phymode(
+			scan->rt2x00dev,
+			scan->conf.scan_phymode);
+
+		scan->rt2x00dev->lib_ops->config_channel(
+			scan->rt2x00dev,
+			scan->conf.scan_channel_val,
+			scan->conf.scan_channel,
+			scan->conf.scan_freq,
+			scan->conf.scan_power_level);
+	} else {
+		scan->rt2x00dev->lib_ops->config_phymode(
+			scan->rt2x00dev,
+			scan->conf.running_phymode);
+
+		scan->rt2x00dev->lib_ops->config_channel(
+			scan->rt2x00dev,
+			scan->conf.running_channel_val,
+			scan->conf.running_channel,
+			scan->conf.running_freq,
+			scan->conf.scan_power_level);
+	}
+
+exit:
+	scan->rt2x00dev->scan = NULL;
+	kfree(scan);
+}
+
+int rt2x00lib_passive_scan(struct ieee80211_hw *hw,
+	int state, struct ieee80211_scan_conf *conf)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	/*
+	 * Check if we are not busy with the previous
+	 * passive scan request.
+	 */
+	if (rt2x00dev->scan)
+		return -EBUSY;
+
+	/*
+	 * Check if the radio is enabled.
+	 */
+	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
+		return -EIO;
+
+	/*
+	 * Allocate scanning structure to store scanning info.
+	 */
+	rt2x00dev->scan = kzalloc(sizeof(struct scanning), GFP_ATOMIC);
+	if (!rt2x00dev->scan)
+		return -ENOMEM;
+
+	/*
+	 * Initialize Scanning structure.
+	 */
+	rt2x00dev->scan->rt2x00dev = rt2x00dev;
+	rt2x00dev->scan->state = state;
+	memcpy(&rt2x00dev->scan->conf, conf, sizeof(*conf));
+
+	/*
+	 * Initialize completion handler.
+	 * Set initial status to SCANNING_WAITING to prevent scanning
+	 * to begin while there are still TX packets queued.
+	 */
+	init_completion(&rt2x00dev->scan->completion);
+	rt2x00dev->scan->status = SCANNING_WAITING;
+
+	/*
+	 * Check if we have to send a packet before the
+	 * channel switch.
+	 */
+	if (conf->skb) {
+		if (rt2x00dev->hw_ops->tx(hw, conf->skb, conf->tx_control))
+			goto exit;
+	}
+
+	/*
+	 * Queue work.
+	 */
+	INIT_WORK(&rt2x00dev->scan->work, rt2x00lib_scan);
+	if (!queue_work(rt2x00dev->workqueue, &rt2x00dev->scan->work))
+		goto exit;
+
+	return 0;
+
+exit:
+	kfree(rt2x00dev->scan);
+	rt2x00dev->scan = NULL;
+
+	return -EIO;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_passive_scan);
+
+int rt2x00lib_get_tx_stats(struct ieee80211_hw *hw,
+	struct ieee80211_tx_queue_stats *stats)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	unsigned int i;
+
+	for (i = 0; i < hw->queues; i++)
+		memcpy(&stats->data[i], &rt2x00dev->ring[i].stats,
+			sizeof(rt2x00dev->ring[i].stats));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_get_tx_stats);
+
+int rt2x00lib_conf_tx(struct ieee80211_hw *hw, int queue,
+	const struct ieee80211_tx_queue_params *params)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct data_ring *ring;
+
+	ring = rt2x00_get_ring(rt2x00dev, queue);
+	if (unlikely(!ring))
+		return -EINVAL;
+
+	/*
+	 * The passed variables are stored as real value ((2^n)-1).
+	 * RT2500 registers require to know the bit number 'n'.
+	 */
+	if (params->cw_min)
+		ring->tx_params.cw_min = fls(params->cw_min);
+	else
+		ring->tx_params.cw_min = 5; /* cw_min: 2^5 = 32. */
+
+	if (params->cw_max)
+		ring->tx_params.cw_max = fls(params->cw_max);
+	else
+		ring->tx_params.cw_max = 10; /* cw_min: 2^10 = 1024. */
+
+	if (params->aifs)
+		ring->tx_params.aifs = params->aifs;
+	else
+		ring->tx_params.aifs = 2;
+
+	INFO("Configured TX ring %d - CWmin: %d, CWmax: %d, Aifs: %d.\n",
+		queue, ring->tx_params.cw_min, ring->tx_params.cw_max,
+		ring->tx_params.aifs);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_conf_tx);

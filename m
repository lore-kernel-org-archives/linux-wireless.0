Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:56449 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756481AbXD2N4a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 09:56:30 -0400
Received: from logostar.upir.cz (r2u241.net.upc.cz [62.245.84.241])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.suse.cz (SUSE LINUX ESMTP Mailer) with ESMTP id 01D82628143
	for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2007 15:56:27 +0200 (CEST)
Date: Sun, 29 Apr 2007 15:56:23 +0200
From: Jiri Benc <jbenc@suse.cz>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: remove hostapd scanning
Message-ID: <20070429155623.3a7f1a67@logostar.upir.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes passive_scan callback with associated code. The whole thing is
not a job for a driver and can be done in a much cleaner way using user
space MLME. Besides, nobody (not even hostapd) uses that call.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---
 include/net/mac80211.h         |   38 ----
 net/mac80211/Makefile          |    1 
 net/mac80211/debugfs.c         |    3 
 net/mac80211/hostapd_ioctl.h   |    1 
 net/mac80211/ieee80211.c       |   52 ------
 net/mac80211/ieee80211_i.h     |   35 ----
 net/mac80211/ieee80211_ioctl.c |   44 -----
 net/mac80211/ieee80211_scan.c  |  344 -----------------------------------------
 8 files changed, 4 insertions(+), 514 deletions(-)

--- dscape.orig/include/net/mac80211.h
+++ dscape/include/net/mac80211.h
@@ -420,37 +420,6 @@ struct ieee80211_key_conf {
 	u8 key[0];
 };
 
-#define IEEE80211_SCAN_START 1
-#define IEEE80211_SCAN_END   2
-
-struct ieee80211_scan_conf {
-	int scan_channel;     /* IEEE 802.11 channel number to do passive scan
-			       * on */
-	int scan_freq;	/* new freq in MHz to switch to for passive scan
-			       */
-	int scan_channel_val; /* hw specific value for the channel */
-	int scan_phymode;     /* MODE_IEEE80211A, .. */
-	unsigned char scan_power_level;
-	unsigned char scan_antenna_max;
-
-
-	int running_channel; /* IEEE 802.11 channel number we operate on
-			      * normally */
-	int running_freq;    /* freq in MHz we're operating on normally */
-	int running_channel_val; /* hw specific value for the channel */
-	int running_phymode;
-	unsigned char running_power_level;
-	unsigned char running_antenna_max;
-
-	int scan_time;       /* time a scan will take in us */
-	int tries;
-
-	struct sk_buff *skb; /* skb to transmit before changing channels, maybe
-			      * NULL for none */
-	struct ieee80211_tx_control *tx_control;
-
-};
-
 #define IEEE80211_SEQ_COUNTER_RX	0
 #define IEEE80211_SEQ_COUNTER_TX	1
 
@@ -678,13 +647,6 @@ struct ieee80211_ops {
 	int (*set_port_auth)(struct ieee80211_hw *hw, u8 *addr,
 			     int authorized);
 
-	/* Ask the hardware to do a passive scan on a new channel. The hardware
-	 * will do what ever is required to nicely leave the current channel
-	 * including transmit any CTS packets, etc.
-	 * Must be atomic. */
-	int (*passive_scan)(struct ieee80211_hw *hw, int state,
-			    struct ieee80211_scan_conf *conf);
-
 	/* Ask the hardware to service the scan request, no need to start
 	 * the scan state machine in stack. */
 	int (*hw_scan)(struct ieee80211_hw *hw, u8 *ssid, size_t len);
--- dscape.orig/net/mac80211/Makefile
+++ dscape/net/mac80211/Makefile
@@ -9,7 +9,6 @@ mac80211-objs := \
 	sta_info.o \
 	wep.o \
 	wpa.o \
-	ieee80211_scan.o \
 	ieee80211_sta.o \
 	ieee80211_iface.o \
 	ieee80211_rate.o \
--- dscape.orig/net/mac80211/debugfs.c
+++ dscape/net/mac80211/debugfs.c
@@ -205,8 +205,6 @@ DEBUGFS_STATS_FILE(transmitted_frame_cou
 		   local->dot11TransmittedFrameCount);
 DEBUGFS_STATS_FILE(wep_undecryptable_count, 20, "%u",
 		   local->dot11WEPUndecryptableCount);
-DEBUGFS_STATS_FILE(num_scans, 20, "%u",
-		   local->scan.num_scans);
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 DEBUGFS_STATS_FILE(tx_handlers_drop, 20, "%u",
 		   local->tx_handlers_drop);
@@ -339,7 +337,6 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_STATS_ADD(multicast_received_frame_count);
 	DEBUGFS_STATS_ADD(transmitted_frame_count);
 	DEBUGFS_STATS_ADD(wep_undecryptable_count);
-	DEBUGFS_STATS_ADD(num_scans);
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	DEBUGFS_STATS_ADD(tx_handlers_drop);
 	DEBUGFS_STATS_ADD(tx_handlers_queued);
--- dscape.orig/net/mac80211/hostapd_ioctl.h
+++ dscape/net/mac80211/hostapd_ioctl.h
@@ -87,7 +87,6 @@ enum {
 	/* Instant802 additions */
 	PRISM2_HOSTAPD_SET_BEACON = 1001,
 	PRISM2_HOSTAPD_GET_HW_FEATURES = 1002,
-	PRISM2_HOSTAPD_SCAN = 1003,
 	PRISM2_HOSTAPD_WPA_TRIGGER = 1004,
 	PRISM2_HOSTAPD_SET_RATE_SETS = 1005,
 	PRISM2_HOSTAPD_ADD_IF = 1006,
--- dscape.orig/net/mac80211/ieee80211.c
+++ dscape/net/mac80211/ieee80211.c
@@ -899,7 +899,6 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 			}
 		}
 	}
-	tx->local->scan.txrx_count++;
 
 	return TXRX_CONTINUE;
 }
@@ -2449,7 +2448,6 @@ static int ieee80211_open(struct net_dev
 							    &conf);
 			return res;
 		}
-		ieee80211_init_scan(local);
 	}
 	local->open_count++;
 
@@ -2497,7 +2495,6 @@ static int ieee80211_stop(struct net_dev
 
 	local->open_count--;
 	if (local->open_count == 0) {
-		ieee80211_stop_scan(local);
 		if (netif_running(local->mdev))
 			dev_close(local->mdev);
 		if (local->apdev)
@@ -3771,40 +3768,6 @@ ieee80211_rx_h_passive_scan(struct ieee8
 		return TXRX_QUEUED;
 	}
 
-	if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)
-		local->scan.txrx_count++;
-	if (unlikely(local->scan.in_scan != 0 &&
-		     rx->u.rx.status->freq == local->scan.freq)) {
-		struct ieee80211_hdr *hdr;
-		u16 fc;
-
-		local->scan.rx_packets++;
-
-		hdr = (struct ieee80211_hdr *) skb->data;
-		fc = le16_to_cpu(hdr->frame_control);
-
-		if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT &&
-		    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON &&
-		    rx->dev == local->mdev) {
-			local->scan.rx_beacon++;
-			/* Need to trim FCS here because it is normally
-			 * removed only after this passive scan handler. */
-			if ((rx->local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS) &&
-			    rx->skb->len > FCS_LEN)
-				skb_trim(rx->skb, rx->skb->len - FCS_LEN);
-
-			if (!rx->local->apdev)
-				return TXRX_DROP;
-			ieee80211_rx_mgmt(rx->local, rx->skb,
-					  rx->u.rx.status,
-					  ieee80211_msg_passive_scan);
-			return TXRX_QUEUED;
-		} else {
-			I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
-			return TXRX_DROP;
-		}
-	}
-
 	if (unlikely(rx->u.rx.in_scan)) {
 		/* scanning finished during invoking of handlers */
 		I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
@@ -3994,7 +3957,7 @@ void __ieee80211_rx(struct ieee80211_hw 
 		goto end;
 	}
 
-	if (unlikely(local->sta_scanning || local->scan.in_scan))
+	if (unlikely(local->sta_scanning))
 		rx.u.rx.in_scan = 1;
 
 	if (__ieee80211_invoke_rx_handlers(local, local->rx_pre_handlers, &rx,
@@ -4803,11 +4766,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->rate_ctrl_num_up = RATE_CONTROL_NUM_UP;
 	local->rate_ctrl_num_down = RATE_CONTROL_NUM_DOWN;
 
-	local->scan.in_scan = 0;
 	local->enabled_modes = (unsigned int) -1;
 
-	init_timer(&local->scan.timer); /* clear it out */
-
 	INIT_LIST_HEAD(&local->modes_list);
 
 	rwlock_init(&local->sub_if_lock);
@@ -5062,13 +5022,9 @@ int ieee80211_netif_oper(struct ieee8021
 	case NETIF_STOP:
 		break;
 	case NETIF_WAKE:
-		if (local->scan.in_scan == 0) {
-			netif_wake_queue(dev);
-#if 1
-			if (/* FIX: 802.11 qdisc in use */ 1)
-				__netif_schedule(dev);
-#endif
-		}
+		netif_wake_queue(dev);
+		if (/* FIX: 802.11 qdisc in use */ 1)
+			__netif_schedule(dev);
 		break;
 	case NETIF_IS_STOPPED:
 		if (netif_queue_stopped(dev))
--- dscape.orig/net/mac80211/ieee80211_i.h
+++ dscape/net/mac80211/ieee80211_i.h
@@ -178,33 +178,6 @@ struct ieee80211_tx_stored_packet {
 	unsigned int last_frag_rate_ctrl_probe:1;
 };
 
-struct ieee80211_passive_scan {
-	unsigned int in_scan:1; /* this must be cleared before calling
-				 * netif_oper(WAKEUP) */
-	unsigned int our_mode_only:1; /* only scan our physical mode a/b/g/etc
-				       */
-	int interval; /* time in seconds between scans */
-	int time; /* time in microseconds to scan for */
-	int channel; /* channel to be scanned */
-	int tries;
-
-	struct ieee80211_hw_mode *mode;
-	int chan_idx;
-
-	int freq;
-	int rx_packets;
-	int rx_beacon;
-	int txrx_count;
-
-	struct timer_list timer;
-
-	struct sk_buff *skb; /* skb to transmit before changing channels,
-			      * maybe null for none */
-	struct ieee80211_tx_control tx_control;
-
-	unsigned int num_scans;
-};
-
 typedef ieee80211_txrx_result (*ieee80211_tx_handler)
 (struct ieee80211_txrx_data *tx);
 
@@ -489,9 +462,6 @@ struct ieee80211_local {
 			     * deliver multicast frames both back to wireless
 			     * media and to the local net stack */
 
-	struct ieee80211_passive_scan scan;
-
-
 	ieee80211_rx_handler *rx_pre_handlers;
 	ieee80211_rx_handler *rx_handlers;
 	ieee80211_tx_handler *tx_handlers;
@@ -780,11 +750,6 @@ int ieee80211_set_hw_encryption(struct n
 				struct ieee80211_key *key);
 void ieee80211_update_default_wep_only(struct ieee80211_local *local);
 
-/* ieee80211_scan.c */
-void ieee80211_init_scan(struct ieee80211_local *local);
-void ieee80211_stop_scan(struct ieee80211_local *local);
-
-
 
 /* Least common multiple of the used rates (in 100 kbps). This is used to
  * calculate rate_inv values for each rate so that only integers are needed. */
--- dscape.orig/net/mac80211/ieee80211_ioctl.c
+++ dscape/net/mac80211/ieee80211_ioctl.c
@@ -165,47 +165,6 @@ static int ieee80211_ioctl_get_hw_featur
 	return 0;
 }
 
-
-static int ieee80211_ioctl_scan(struct net_device *dev,
-				struct prism2_hostapd_param *param)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	if (!local->ops->passive_scan)
-		return -EOPNOTSUPP;
-
-	if ((param->u.scan.now == 1) && (local->scan.in_scan == 1))
-		return -EBUSY;
-
-	if (param->u.scan.our_mode_only >= 0)
-		local->scan.our_mode_only = param->u.scan.our_mode_only;
-	if (param->u.scan.interval >= 0)
-		local->scan.interval = param->u.scan.interval;
-	if (param->u.scan.listen >= 0)
-		local->scan.time = param->u.scan.listen;
-		if (param->u.scan.channel > 0)
-			local->scan.channel = param->u.scan.channel;
-	if (param->u.scan.now == 1) {
-		local->scan.in_scan = 0;
-		mod_timer(&local->scan.timer, jiffies);
-	}
-
-	param->u.scan.our_mode_only = local->scan.our_mode_only;
-	param->u.scan.interval = local->scan.interval;
-	param->u.scan.listen = local->scan.time;
-	if (local->scan.in_scan == 1)
-		param->u.scan.last_rx = -1;
-	else {
-		param->u.scan.last_rx = local->scan.rx_packets;
-		local->scan.rx_packets = -1;
-	}
-	param->u.scan.channel =
-		local->scan.mode->channels[local->scan.chan_idx].chan;
-
-	return 0;
-}
-
-
 static int ieee80211_ioctl_flush(struct net_device *dev,
 				 struct prism2_hostapd_param *param)
 {
@@ -1449,9 +1408,6 @@ static int ieee80211_ioctl_priv_hostapd(
 	case PRISM2_HOSTAPD_GET_HW_FEATURES:
 		ret = ieee80211_ioctl_get_hw_features(dev, param, p->length);
 		break;
-	case PRISM2_HOSTAPD_SCAN:
-		ret = ieee80211_ioctl_scan(dev, param);
-		break;
 #ifdef CONFIG_HOSTAPD_WPA_TESTING
 	case PRISM2_HOSTAPD_WPA_TRIGGER:
 		ret = ieee80211_ioctl_wpa_trigger(dev, param);
--- dscape.orig/net/mac80211/ieee80211_scan.c
+++ /dev/null
@@ -1,344 +0,0 @@
-/*
- * Copyright 2002-2004, Instant802 Networks, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/skbuff.h>
-
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
-#include "ieee80211_rate.h"
-
-
-/* Maximum number of seconds to wait for the traffic load to get below
- * threshold before forcing a passive scan. */
-#define MAX_SCAN_WAIT 60
-/* Threshold (pkts/sec TX or RX) for delaying passive scan */
-#define SCAN_TXRX_THRESHOLD 75
-
-static void get_channel_params(struct ieee80211_local *local, int channel,
-				struct ieee80211_hw_mode **mode,
-				struct ieee80211_channel **chan)
-{
-	struct ieee80211_hw_mode *m;
-
-	list_for_each_entry(m, &local->modes_list, list) {
-		*mode = m;
-		if (m->mode == local->hw.conf.phymode)
-			break;
-	}
-	local->scan.mode = m;
-	local->scan.chan_idx = 0;
-	do {
-		*chan = &m->channels[local->scan.chan_idx];
-		if ((*chan)->chan == channel)
-			return;
-		local->scan.chan_idx++;
-	} while (local->scan.chan_idx < m->num_channels);
-	*chan = NULL;
-}
-
-
-static void next_chan_same_mode(struct ieee80211_local *local,
-				struct ieee80211_hw_mode **mode,
-				struct ieee80211_channel **chan)
-{
-	struct ieee80211_hw_mode *m;
-	int prev;
-
-	list_for_each_entry(m, &local->modes_list, list) {
-		*mode = m;
-		if (m->mode == local->hw.conf.phymode)
-			break;
-	}
-	local->scan.mode = m;
-
-	/* Select next channel - scan only channels marked with W_SCAN flag */
-	prev = local->scan.chan_idx;
-	do {
-		local->scan.chan_idx++;
-		if (local->scan.chan_idx >= m->num_channels)
-			local->scan.chan_idx = 0;
-		*chan = &m->channels[local->scan.chan_idx];
-		if ((*chan)->flag & IEEE80211_CHAN_W_SCAN)
-			break;
-	} while (local->scan.chan_idx != prev);
-}
-
-
-static void next_chan_all_modes(struct ieee80211_local *local,
-				struct ieee80211_hw_mode **mode,
-				struct ieee80211_channel **chan)
-{
-	struct ieee80211_hw_mode *prev_m;
-	int prev;
-
-	/* Select next channel - scan only channels marked with W_SCAN flag */
-	prev = local->scan.chan_idx;
-	prev_m = local->scan.mode;
-	do {
-		*mode = local->scan.mode;
-		local->scan.chan_idx++;
-		if (local->scan.chan_idx >= (*mode)->num_channels) {
-			struct list_head *next;
-
-			local->scan.chan_idx = 0;
-			next = (*mode)->list.next;
-			if (next == &local->modes_list)
-				next = next->next;
-			*mode = list_entry(next,
-					   struct ieee80211_hw_mode,
-					   list);
-			local->scan.mode = *mode;
-		}
-		*chan = &(*mode)->channels[local->scan.chan_idx];
-		if ((*chan)->flag & IEEE80211_CHAN_W_SCAN)
-			break;
-	} while (local->scan.chan_idx != prev ||
-		 local->scan.mode != prev_m);
-}
-
-
-static void ieee80211_scan_start(struct ieee80211_local *local,
-				 struct ieee80211_scan_conf *conf)
-{
-	struct ieee80211_hw_mode *old_mode = local->scan.mode;
-	int old_chan_idx = local->scan.chan_idx;
-	struct ieee80211_hw_mode *mode = NULL;
-	struct ieee80211_channel *chan = NULL;
-	int ret;
-
-	if (!local->ops->passive_scan) {
-		printk(KERN_DEBUG "%s: Scan handler called, yet the hardware "
-		       "does not support passive scanning. Disabled.\n",
-		       local->mdev->name);
-		return;
-	}
-
-	if ((local->scan.tries < MAX_SCAN_WAIT &&
-	     local->scan.txrx_count > SCAN_TXRX_THRESHOLD)) {
-		local->scan.tries++;
-		/* Count TX/RX packets during one second interval and allow
-		 * scan to start only if the number of packets is below the
-		 * threshold. */
-		local->scan.txrx_count = 0;
-		local->scan.timer.expires = jiffies + HZ;
-		add_timer(&local->scan.timer);
-		return;
-	}
-
-	if (!local->scan.skb) {
-		printk(KERN_DEBUG "%s: Scan start called even though scan.skb "
-		       "is not set\n", local->mdev->name);
-	}
-
-	if (local->scan.our_mode_only) {
-		if (local->scan.channel > 0) {
-			get_channel_params(local, local->scan.channel, &mode,
-					   &chan);
-		} else
-			next_chan_same_mode(local, &mode, &chan);
-	}
-	else
-		next_chan_all_modes(local, &mode, &chan);
-
-	conf->scan_channel = chan->chan;
-	conf->scan_freq = chan->freq;
-	conf->scan_channel_val = chan->val;
-	conf->scan_phymode = mode->mode;
-	conf->scan_power_level = chan->power_level;
-	conf->scan_antenna_max = chan->antenna_max;
-	conf->scan_time = 2 * local->hw.channel_change_time +
-		local->scan.time; /* 10ms scan time+hardware changes */
-	conf->skb = local->scan.skb ?
-		skb_clone(local->scan.skb, GFP_ATOMIC) : NULL;
-	conf->tx_control = &local->scan.tx_control;
-#if 0
-	printk(KERN_DEBUG "%s: Doing scan on mode: %d freq: %d chan: %d "
-	       "for %d ms\n",
-	       local->mdev->name, conf->scan_phymode, conf->scan_freq,
-	       conf->scan_channel, conf->scan_time);
-#endif
-	local->scan.rx_packets = 0;
-	local->scan.rx_beacon = 0;
-	local->scan.freq = chan->freq;
-	local->scan.in_scan = 1;
-
-	ieee80211_netif_oper(local_to_hw(local), NETIF_STOP);
-
-	ret = local->ops->passive_scan(local_to_hw(local),
-				      IEEE80211_SCAN_START, conf);
-
-	if (ret == 0) {
-		long usec = local->hw.channel_change_time +
-			local->scan.time;
-		usec += 1000000L / HZ - 1;
-		usec /= 1000000L / HZ;
-		local->scan.timer.expires = jiffies + usec;
-	} else {
-		local->scan.in_scan = 0;
-		if (conf->skb)
-			dev_kfree_skb(conf->skb);
-		ieee80211_netif_oper(local_to_hw(local), NETIF_WAKE);
-		if (ret == -EAGAIN) {
-			local->scan.timer.expires = jiffies +
-				(local->scan.interval * HZ / 100);
-			local->scan.mode = old_mode;
-			local->scan.chan_idx = old_chan_idx;
-		} else {
-			printk(KERN_DEBUG "%s: Got unknown error from "
-			       "passive_scan %d\n", local->mdev->name, ret);
-			local->scan.timer.expires = jiffies +
-				(local->scan.interval * HZ);
-		}
-		local->scan.in_scan = 0;
-	}
-
-	add_timer(&local->scan.timer);
-}
-
-
-static void ieee80211_scan_stop(struct ieee80211_local *local,
-				struct ieee80211_scan_conf *conf)
-{
-	struct ieee80211_hw_mode *mode;
-	struct ieee80211_channel *chan;
-	int wait;
-
-	if (!local->ops->passive_scan)
-		return;
-
-	mode = local->scan.mode;
-
-	if (local->scan.chan_idx >= mode->num_channels)
-		local->scan.chan_idx = 0;
-
-	chan = &mode->channels[local->scan.chan_idx];
-
-	local->ops->passive_scan(local_to_hw(local), IEEE80211_SCAN_END,
-				conf);
-
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "%s: Did scan on mode: %d freq: %d chan: %d "
-	       "GOT: %d Beacon: %d (%d)\n",
-	       local->mdev->name,
-	       mode->mode, chan->freq, chan->chan,
-	       local->scan.rx_packets, local->scan.rx_beacon,
-	       local->scan.tries);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-	local->scan.num_scans++;
-
-	local->scan.in_scan = 0;
-	ieee80211_netif_oper(local_to_hw(local), NETIF_WAKE);
-
-	local->scan.tries = 0;
-	/* Use random interval of scan.interval .. 2 * scan.interval */
-	wait = (local->scan.interval * HZ * ((net_random() & 127) + 128)) /
-		128;
-	local->scan.timer.expires = jiffies + wait;
-
-	add_timer(&local->scan.timer);
-}
-
-
-static void ieee80211_scan_handler(unsigned long ullocal)
-{
-	struct ieee80211_local *local = (struct ieee80211_local *) ullocal;
-	struct ieee80211_scan_conf conf;
-
-	if (local->scan.interval == 0 && !local->scan.in_scan) {
-		/* Passive scanning is disabled - keep the timer always
-		 * running to make code cleaner. */
-		local->scan.timer.expires = jiffies + 10 * HZ;
-		add_timer(&local->scan.timer);
-		return;
-	}
-
-	memset(&conf, 0, sizeof(struct ieee80211_scan_conf));
-	conf.running_freq = local->hw.conf.freq;
-	conf.running_channel = local->hw.conf.channel;
-	conf.running_phymode = local->hw.conf.phymode;
-	conf.running_channel_val = local->hw.conf.channel_val;
-	conf.running_power_level = local->hw.conf.power_level;
-	conf.running_antenna_max = local->hw.conf.antenna_max;
-
-	if (local->scan.in_scan == 0)
-		ieee80211_scan_start(local, &conf);
-	else
-		ieee80211_scan_stop(local, &conf);
-}
-
-
-void ieee80211_init_scan(struct ieee80211_local *local)
-{
-	struct ieee80211_hdr hdr;
-	u16 fc;
-	int len = 10;
-	struct rate_control_extra extra;
-
-	/* Only initialize passive scanning if the hardware supports it */
-	if (!local->ops->passive_scan) {
-		local->scan.skb = NULL;
-		memset(&local->scan.tx_control, 0,
-		       sizeof(local->scan.tx_control));
-		printk(KERN_DEBUG "%s: Does not support passive scan, "
-		       "disabled\n", local->mdev->name);
-		return;
-	}
-
-	local->scan.interval = 0;
-	local->scan.our_mode_only = 1;
-	local->scan.time = 10000;
-	local->scan.timer.function = ieee80211_scan_handler;
-	local->scan.timer.data = (unsigned long) local;
-	local->scan.timer.expires = jiffies + local->scan.interval * HZ;
-	add_timer(&local->scan.timer);
-
-	/* Create a CTS from for broadcasting before
-	 * the low level changes channels */
-	local->scan.skb = alloc_skb(len + local->hw.extra_tx_headroom,
-		GFP_KERNEL);
-	if (!local->scan.skb) {
-		printk(KERN_WARNING "%s: Failed to allocate CTS packet for "
-		       "passive scan\n", local->mdev->name);
-		return;
-	}
-	skb_reserve(local->scan.skb, local->hw.extra_tx_headroom);
-
-	fc = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS;
-	hdr.frame_control = cpu_to_le16(fc);
-	hdr.duration_id =
-		cpu_to_le16(2 * local->hw.channel_change_time +
-			    local->scan.time);
-	memcpy(hdr.addr1, local->mdev->dev_addr, ETH_ALEN); /* DA */
-	hdr.seq_ctrl = 0;
-
-	memcpy(skb_put(local->scan.skb, len), &hdr, len);
-
-	memset(&local->scan.tx_control, 0, sizeof(local->scan.tx_control));
-	local->scan.tx_control.key_idx = HW_KEY_IDX_INVALID;
-	local->scan.tx_control.flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
-	memset(&extra, 0, sizeof(extra));
-	extra.mode = local->hw.conf.mode;
-	local->scan.tx_control.tx_rate =
-		rate_control_get_rate(local, local->mdev,
-				      local->scan.skb, &extra)->val;
-	local->scan.tx_control.flags |= IEEE80211_TXCTL_NO_ACK;
-}
-
-
-void ieee80211_stop_scan(struct ieee80211_local *local)
-{
-	if (local->ops->passive_scan) {
-		del_timer_sync(&local->scan.timer);
-		dev_kfree_skb(local->scan.skb);
-		local->scan.skb = NULL;
-	}
-}


-- 
Jiri Benc
SUSE Labs

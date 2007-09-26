Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38507 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbXIZNYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 09:24:09 -0400
Message-Id: <20070926132136.676468000@sipsolutions.net>
References: <20070926131938.575572000@sipsolutions.net>
Date: Wed, 26 Sep 2007 15:19:49 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: [patch 11/12] mac80211: remove management interface
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar to the previous patch

---
 include/net/mac80211.h          |    1 
 net/mac80211/ieee80211.c        |  182 ----------------------------------------
 net/mac80211/ieee80211_common.h |   91 --------------------
 net/mac80211/ieee80211_i.h      |    9 -
 net/mac80211/ieee80211_iface.c  |   66 --------------
 net/mac80211/ieee80211_rate.c   |    3 
 net/mac80211/ieee80211_rate.h   |    2 
 net/mac80211/ieee80211_sta.c    |    2 
 net/mac80211/rx.c               |   35 +------
 net/mac80211/tx.c               |   14 ---
 net/mac80211/wme.c              |   10 --
 11 files changed, 14 insertions(+), 401 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-09-26 12:09:05.615337487 +0200
+++ wireless-dev/include/net/mac80211.h	2007-09-26 14:38:08.598936654 +0200
@@ -469,7 +469,6 @@ struct ieee80211_conf {
  */
 enum ieee80211_if_types {
 	IEEE80211_IF_TYPE_AP,
-	IEEE80211_IF_TYPE_MGMT,
 	IEEE80211_IF_TYPE_STA,
 	IEEE80211_IF_TYPE_IBSS,
 	IEEE80211_IF_TYPE_MNTR,
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-26 14:34:39.948936654 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-26 14:38:08.618936654 +0200
@@ -24,7 +24,6 @@
 #include <net/net_namespace.h>
 #include <net/cfg80211.h>
 
-#include "ieee80211_common.h"
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
 #include "wep.h"
@@ -123,152 +122,6 @@ static void ieee80211_master_set_multica
 	ieee80211_configure_filter(local);
 }
 
-/* management interface */
-
-static void
-ieee80211_fill_frame_info(struct ieee80211_local *local,
-			  struct ieee80211_frame_info *fi,
-			  struct ieee80211_rx_status *status)
-{
-	if (status) {
-		struct timespec ts;
-		struct ieee80211_rate *rate;
-
-		jiffies_to_timespec(jiffies, &ts);
-		fi->hosttime = cpu_to_be64((u64) ts.tv_sec * 1000000 +
-					   ts.tv_nsec / 1000);
-		fi->mactime = cpu_to_be64(status->mactime);
-		switch (status->phymode) {
-		case MODE_IEEE80211A:
-			fi->phytype = htonl(ieee80211_phytype_ofdm_dot11_a);
-			break;
-		case MODE_IEEE80211B:
-			fi->phytype = htonl(ieee80211_phytype_dsss_dot11_b);
-			break;
-		case MODE_IEEE80211G:
-			fi->phytype = htonl(ieee80211_phytype_pbcc_dot11_g);
-			break;
-		default:
-			fi->phytype = htonl(0xAAAAAAAA);
-			break;
-		}
-		fi->channel = htonl(status->channel);
-		rate = ieee80211_get_rate(local, status->phymode,
-					  status->rate);
-		if (rate) {
-			fi->datarate = htonl(rate->rate);
-			if (rate->flags & IEEE80211_RATE_PREAMBLE2) {
-				if (status->rate == rate->val)
-					fi->preamble = htonl(2); /* long */
-				else if (status->rate == rate->val2)
-					fi->preamble = htonl(1); /* short */
-			} else
-				fi->preamble = htonl(0);
-		} else {
-			fi->datarate = htonl(0);
-			fi->preamble = htonl(0);
-		}
-
-		fi->antenna = htonl(status->antenna);
-		fi->priority = htonl(0xffffffff); /* no clue */
-		fi->ssi_type = htonl(ieee80211_ssi_raw);
-		fi->ssi_signal = htonl(status->ssi);
-		fi->ssi_noise = 0x00000000;
-		fi->encoding = 0;
-	} else {
-		/* clear everything because we really don't know.
-		 * the msg_type field isn't present on monitor frames
-		 * so we don't know whether it will be present or not,
-		 * but it's ok to not clear it since it'll be assigned
-		 * anyway */
-		memset(fi, 0, sizeof(*fi) - sizeof(fi->msg_type));
-
-		fi->ssi_type = htonl(ieee80211_ssi_none);
-	}
-	fi->version = htonl(IEEE80211_FI_VERSION);
-	fi->length = cpu_to_be32(sizeof(*fi) - sizeof(fi->msg_type));
-}
-
-/* this routine is actually not just for this, but also
- * for pushing fake 'management' frames into userspace.
- * it shall be replaced by a netlink-based system. */
-void
-ieee80211_rx_mgmt(struct ieee80211_local *local, struct sk_buff *skb,
-		  struct ieee80211_rx_status *status, u32 msg_type)
-{
-	struct ieee80211_frame_info *fi;
-	const size_t hlen = sizeof(struct ieee80211_frame_info);
-	struct net_device *dev = local->apdev;
-
-	skb->dev = dev;
-
-	if (skb_headroom(skb) < hlen) {
-		I802_DEBUG_INC(local->rx_expand_skb_head);
-		if (pskb_expand_head(skb, hlen, 0, GFP_ATOMIC)) {
-			dev_kfree_skb(skb);
-			return;
-		}
-	}
-
-	fi = (struct ieee80211_frame_info *) skb_push(skb, hlen);
-
-	ieee80211_fill_frame_info(local, fi, status);
-	fi->msg_type = htonl(msg_type);
-
-	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += skb->len;
-
-	skb_set_mac_header(skb, 0);
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
-	skb->pkt_type = PACKET_OTHERHOST;
-	skb->protocol = htons(ETH_P_802_2);
-	memset(skb->cb, 0, sizeof(skb->cb));
-	netif_rx(skb);
-}
-
-static int ieee80211_mgmt_open(struct net_device *dev)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	if (!netif_running(local->mdev))
-		return -EOPNOTSUPP;
-	return 0;
-}
-
-static int ieee80211_mgmt_stop(struct net_device *dev)
-{
-	return 0;
-}
-
-static int ieee80211_change_mtu_apdev(struct net_device *dev, int new_mtu)
-{
-	/* FIX: what would be proper limits for MTU?
-	 * This interface uses 802.11 frames. */
-	if (new_mtu < 256 || new_mtu > IEEE80211_MAX_DATA_LEN) {
-		printk(KERN_WARNING "%s: invalid MTU %d\n",
-		       dev->name, new_mtu);
-		return -EINVAL;
-	}
-
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "%s: setting MTU %d\n", dev->name, new_mtu);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-	dev->mtu = new_mtu;
-	return 0;
-}
-
-void ieee80211_if_mgmt_setup(struct net_device *dev)
-{
-	ether_setup(dev);
-	dev->hard_start_xmit = ieee80211_mgmt_start_xmit;
-	dev->change_mtu = ieee80211_change_mtu_apdev;
-	dev->open = ieee80211_mgmt_open;
-	dev->stop = ieee80211_mgmt_stop;
-	dev->type = ARPHRD_IEEE80211_PRISM;
-	dev->hard_header_parse = header_parse_80211;
-	dev->destructor = ieee80211_if_free;
-}
-
 /* regular interfaces */
 
 static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
@@ -346,7 +199,6 @@ static int ieee80211_open(struct net_dev
 			return -ENOLINK;
 		break;
 	case IEEE80211_IF_TYPE_AP:
-	case IEEE80211_IF_TYPE_MGMT:
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_MNTR:
 	case IEEE80211_IF_TYPE_IBSS:
@@ -407,10 +259,6 @@ static int ieee80211_open(struct net_dev
 	if (local->open_count == 0) {
 		res = dev_open(local->mdev);
 		WARN_ON(res);
-		if (local->apdev) {
-			res = dev_open(local->apdev);
-			WARN_ON(res);
-		}
 		tasklet_enable(&local->tx_pending_tasklet);
 		tasklet_enable(&local->tasklet);
 	}
@@ -496,9 +344,6 @@ static int ieee80211_stop(struct net_dev
 		if (netif_running(local->mdev))
 			dev_close(local->mdev);
 
-		if (local->apdev)
-			dev_close(local->apdev);
-
 		if (local->ops->stop)
 			local->ops->stop(local_to_hw(local));
 
@@ -539,7 +384,7 @@ static void ieee80211_set_multicast_list
 	dev_mc_sync(local->mdev, dev);
 }
 
-/* Must not be called for mdev and apdev */
+/* Must not be called for mdev */
 void ieee80211_if_setup(struct net_device *dev)
 {
 	ether_setup(dev);
@@ -798,8 +643,6 @@ static void ieee80211_remove_tx_extra(st
 		pkt_data->flags |= IEEE80211_TXPD_DO_NOT_ENCRYPT;
 	if (control->flags & IEEE80211_TXCTL_REQUEUE)
 		pkt_data->flags |= IEEE80211_TXPD_REQUEUE;
-	if (control->type == IEEE80211_IF_TYPE_MGMT)
-		pkt_data->flags |= IEEE80211_TXPD_MGMT_IFACE;
 	pkt_data->queue = control->queue;
 
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
@@ -852,7 +695,6 @@ void ieee80211_tx_status(struct ieee8021
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_local *local = hw_to_local(hw);
 	u16 frag, type;
-	u32 msg_type;
 	struct ieee80211_tx_status_rtap_hdr *rthdr;
 	struct ieee80211_sub_if_data *sdata;
 	int monitors;
@@ -967,29 +809,9 @@ void ieee80211_tx_status(struct ieee8021
 			local->dot11FailedCount++;
 	}
 
-	msg_type = (status->flags & IEEE80211_TX_STATUS_ACK) ?
-		ieee80211_msg_tx_callback_ack : ieee80211_msg_tx_callback_fail;
-
 	/* this was a transmitted frame, but now we want to reuse it */
 	skb_orphan(skb);
 
-	if ((status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS) &&
-	    local->apdev) {
-		if (local->monitors) {
-			skb2 = skb_clone(skb, GFP_ATOMIC);
-		} else {
-			skb2 = skb;
-			skb = NULL;
-		}
-
-		if (skb2)
-			/* Send frame to hostapd */
-			ieee80211_rx_mgmt(local, skb2, NULL, msg_type);
-
-		if (!skb)
-			return;
-	}
-
 	if (!local->monitors) {
 		dev_kfree_skb(skb);
 		return;
@@ -1336,8 +1158,6 @@ void ieee80211_unregister_hw(struct ieee
 	BUG_ON(local->reg_state != IEEE80211_DEV_REGISTERED);
 
 	local->reg_state = IEEE80211_DEV_UNREGISTERED;
-	if (local->apdev)
-		ieee80211_if_del_mgmt(local);
 
 	/*
 	 * At this point, interface list manipulations are fine
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-09-26 12:09:05.715337487 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,91 +0,0 @@
-/*
- * IEEE 802.11 driver (80211.o) -- hostapd interface
- * Copyright 2002-2004, Instant802 Networks, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef IEEE80211_COMMON_H
-#define IEEE80211_COMMON_H
-
-#include <linux/types.h>
-
-/*
- * This is common header information with user space. It is used on all
- * frames sent to wlan#ap interface.
- */
-
-#define IEEE80211_FI_VERSION 0x80211001
-
-struct ieee80211_frame_info {
-	__be32 version;
-	__be32 length;
-	__be64 mactime;
-	__be64 hosttime;
-	__be32 phytype;
-	__be32 channel;
-	__be32 datarate;
-	__be32 antenna;
-	__be32 priority;
-	__be32 ssi_type;
-	__be32 ssi_signal;
-	__be32 ssi_noise;
-	__be32 preamble;
-	__be32 encoding;
-
-	/* Note: this structure is otherwise identical to capture format used
-	 * in linux-wlan-ng, but this additional field is used to provide meta
-	 * data about the frame to hostapd. This was the easiest method for
-	 * providing this information, but this might change in the future. */
-	__be32 msg_type;
-} __attribute__ ((packed));
-
-
-enum ieee80211_msg_type {
-	ieee80211_msg_normal = 0,
-	ieee80211_msg_tx_callback_ack = 1,
-	ieee80211_msg_tx_callback_fail = 2,
-	/* hole at 3, was ieee80211_msg_passive_scan but unused */
-	/* hole at 4, was ieee80211_msg_wep_frame_unknown_key but now unused */
-	ieee80211_msg_michael_mic_failure = 5,
-	/* hole at 6, was monitor but never sent to userspace */
-	ieee80211_msg_sta_not_assoc = 7,
-	/* 8 was ieee80211_msg_set_aid_for_sta */
-	/* 9 was ieee80211_msg_key_threshold_notification */
-	/* 11 was ieee80211_msg_radar */
-};
-
-struct ieee80211_msg_key_notification {
-	int tx_rx_count;
-	char ifname[IFNAMSIZ];
-	u8 addr[ETH_ALEN]; /* ff:ff:ff:ff:ff:ff for broadcast keys */
-};
-
-
-enum ieee80211_phytype {
-	ieee80211_phytype_fhss_dot11_97  = 1,
-	ieee80211_phytype_dsss_dot11_97  = 2,
-	ieee80211_phytype_irbaseband     = 3,
-	ieee80211_phytype_dsss_dot11_b   = 4,
-	ieee80211_phytype_pbcc_dot11_b   = 5,
-	ieee80211_phytype_ofdm_dot11_g   = 6,
-	ieee80211_phytype_pbcc_dot11_g   = 7,
-	ieee80211_phytype_ofdm_dot11_a   = 8,
-};
-
-enum ieee80211_ssi_type {
-	ieee80211_ssi_none = 0,
-	ieee80211_ssi_norm = 1, /* normalized, 0-1000 */
-	ieee80211_ssi_dbm = 2,
-	ieee80211_ssi_raw = 3, /* raw SSI */
-};
-
-struct ieee80211_radar_info {
-		int channel;
-		int radar;
-		int radar_type;
-};
-
-#endif /* IEEE80211_COMMON_H */
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-09-26 14:38:07.048936654 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-09-26 14:38:08.618936654 +0200
@@ -141,7 +141,6 @@ struct ieee80211_txrx_data {
 			 * when using CTS protection with IEEE 802.11g. */
 			struct ieee80211_rate *last_frag_rate;
 			int last_frag_hwrate;
-			int mgmt_interface;
 
 			/* Extra fragments (in addition to the first fragment
 			 * in skb) */
@@ -163,7 +162,6 @@ struct ieee80211_txrx_data {
 #define IEEE80211_TXPD_REQ_TX_STATUS	BIT(0)
 #define IEEE80211_TXPD_DO_NOT_ENCRYPT	BIT(1)
 #define IEEE80211_TXPD_REQUEUE		BIT(2)
-#define IEEE80211_TXPD_MGMT_IFACE	BIT(3)
 /* Stored in sk_buff->cb */
 struct ieee80211_tx_packet_data {
 	int ifindex;
@@ -410,7 +408,6 @@ struct ieee80211_local {
 	struct list_head modes_list;
 
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
-	struct net_device *apdev; /* wlan#ap - management frames (hostapd) */
 	int open_count;
 	int monitors;
 	unsigned int filter_flags; /* FIF_* */
@@ -706,14 +703,11 @@ static inline int ieee80211_bssid_match(
 int ieee80211_hw_config(struct ieee80211_local *local);
 int ieee80211_if_config(struct net_device *dev);
 int ieee80211_if_config_beacon(struct net_device *dev);
-void ieee80211_rx_mgmt(struct ieee80211_local *local, struct sk_buff *skb,
-		       struct ieee80211_rx_status *status, u32 msg_type);
 void ieee80211_prepare_rates(struct ieee80211_local *local,
 			     struct ieee80211_hw_mode *mode);
 void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx);
 int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr);
 void ieee80211_if_setup(struct net_device *dev);
-void ieee80211_if_mgmt_setup(struct net_device *dev);
 struct ieee80211_rate *ieee80211_get_rate(struct ieee80211_local *local,
 					  int phymode, int hwrate);
 
@@ -780,8 +774,6 @@ void __ieee80211_if_del(struct ieee80211
 int ieee80211_if_remove(struct net_device *dev, const char *name, int id);
 void ieee80211_if_free(struct net_device *dev);
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata);
-int ieee80211_if_add_mgmt(struct ieee80211_local *local);
-void ieee80211_if_del_mgmt(struct ieee80211_local *local);
 
 /* regdomain.c */
 void ieee80211_regdomain_init(void);
@@ -798,7 +790,6 @@ void ieee80211_tx_pending(unsigned long 
 int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int ieee80211_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
-int ieee80211_mgmt_start_xmit(struct sk_buff *skb, struct net_device *dev);
 
 /* utility functions/constants */
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-09-26 14:34:39.528936654 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-09-26 14:38:08.628936654 +0200
@@ -96,66 +96,6 @@ fail:
 	return ret;
 }
 
-int ieee80211_if_add_mgmt(struct ieee80211_local *local)
-{
-	struct net_device *ndev;
-	struct ieee80211_sub_if_data *nsdata;
-	int ret;
-
-	ASSERT_RTNL();
-
-	ndev = alloc_netdev(sizeof(struct ieee80211_sub_if_data), "wmgmt%d",
-			    ieee80211_if_mgmt_setup);
-	if (!ndev)
-		return -ENOMEM;
-	ret = dev_alloc_name(ndev, ndev->name);
-	if (ret < 0)
-		goto fail;
-
-	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
-	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
-
-	nsdata = IEEE80211_DEV_TO_SUB_IF(ndev);
-	ndev->ieee80211_ptr = &nsdata->wdev;
-	nsdata->wdev.wiphy = local->hw.wiphy;
-	nsdata->type = IEEE80211_IF_TYPE_MGMT;
-	nsdata->dev = ndev;
-	nsdata->local = local;
-	ieee80211_if_sdata_init(nsdata);
-
-	ret = register_netdevice(ndev);
-	if (ret)
-		goto fail;
-
-	/*
-	 * Called even when register_netdevice fails, it would
-	 * oops if assigned before initialising the rest.
-	 */
-	ndev->uninit = ieee80211_if_reinit;
-
-	ieee80211_debugfs_add_netdev(nsdata);
-
-	if (local->open_count > 0)
-		dev_open(ndev);
-	local->apdev = ndev;
-	return 0;
-
-fail:
-	free_netdev(ndev);
-	return ret;
-}
-
-void ieee80211_if_del_mgmt(struct ieee80211_local *local)
-{
-	struct net_device *apdev;
-
-	ASSERT_RTNL();
-	apdev = local->apdev;
-	ieee80211_debugfs_remove_netdev(IEEE80211_DEV_TO_SUB_IF(apdev));
-	local->apdev = NULL;
-	unregister_netdevice(apdev);
-}
-
 void ieee80211_if_set_type(struct net_device *dev, int type)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -243,9 +183,6 @@ void ieee80211_if_reinit(struct net_devi
 	ieee80211_if_sdata_deinit(sdata);
 
 	switch (sdata->type) {
-	case IEEE80211_IF_TYPE_MGMT:
-		/* nothing to do */
-		break;
 	case IEEE80211_IF_TYPE_AP: {
 		/* Remove all virtual interfaces that use this BSS
 		 * as their sdata->bss */
@@ -354,11 +291,8 @@ int ieee80211_if_remove(struct net_devic
 
 void ieee80211_if_free(struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	/* local->apdev must be NULL when freeing management interface */
-	BUG_ON(dev == local->apdev);
 	ieee80211_if_sdata_deinit(sdata);
 	free_netdev(dev);
 }
--- wireless-dev.orig/net/mac80211/tx.c	2007-09-26 14:34:39.158936654 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-09-26 14:38:08.628936654 +0200
@@ -258,7 +258,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 		return TXRX_CONTINUE;
 	}
 
-	if (unlikely(!tx->u.tx.mgmt_interface && tx->sdata->ieee802_1x &&
+	if (unlikely(/* !injected && */ tx->sdata->ieee802_1x &&
 		     !(sta_flags & WLAN_STA_AUTHORIZED))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		DECLARE_MAC_BUF(mac);
@@ -570,8 +570,6 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 
 	memset(&extra, 0, sizeof(extra));
 	extra.mode = tx->u.tx.mode;
-	extra.mgmt_data = tx->sdata &&
-		tx->sdata->type == IEEE80211_IF_TYPE_MGMT;
 	extra.ethertype = tx->ethertype;
 
 	tx->u.tx.rate = rate_control_get_rate(tx->local, tx->dev, tx->skb,
@@ -1069,7 +1067,7 @@ static int __ieee80211_tx(struct ieee802
 }
 
 static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
-			struct ieee80211_tx_control *control, int mgmt)
+			struct ieee80211_tx_control *control)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
@@ -1099,7 +1097,6 @@ static int ieee80211_tx(struct net_devic
 	rcu_read_lock();
 
 	sta = tx.sta;
-	tx.u.tx.mgmt_interface = mgmt;
 	tx.u.tx.mode = local->hw.conf.mode;
 
 	if (res_prepare == TXRX_QUEUED) { /* if it was an injected packet */
@@ -1250,8 +1247,7 @@ int ieee80211_master_start_xmit(struct s
 		control.flags |= IEEE80211_TXCTL_REQUEUE;
 	control.queue = pkt_data->queue;
 
-	ret = ieee80211_tx(odev, skb, &control,
-			   control.type == IEEE80211_IF_TYPE_MGMT);
+	ret = ieee80211_tx(odev, skb, &control);
 	dev_put(odev);
 
 	return ret;
@@ -1496,8 +1492,6 @@ int ieee80211_subif_start_xmit(struct sk
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
 	pkt_data->ifindex = dev->ifindex;
-	if (sdata->type == IEEE80211_IF_TYPE_MGMT)
-		pkt_data->flags |= IEEE80211_TXPD_MGMT_IFACE;
 
 	skb->dev = local->mdev;
 	dev->stats.tx_packets++;
@@ -1555,8 +1549,6 @@ int ieee80211_mgmt_start_xmit(struct sk_
 	pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
 	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
 	pkt_data->ifindex = sdata->dev->ifindex;
-	if (sdata->type == IEEE80211_IF_TYPE_MGMT)
-		pkt_data->flags |= IEEE80211_TXPD_MGMT_IFACE;
 
 	skb->priority = 20; /* use hardcoded priority for mgmt TX queue */
 	skb->dev = sdata->local->mdev;
--- wireless-dev.orig/net/mac80211/ieee80211_rate.c	2007-09-26 12:09:05.915337487 +0200
+++ wireless-dev/net/mac80211/ieee80211_rate.c	2007-09-26 14:38:08.648936654 +0200
@@ -145,8 +145,7 @@ int ieee80211_init_rate_ctrl_alg(struct 
 	struct rate_control_ref *ref, *old;
 
 	ASSERT_RTNL();
-	if (local->open_count || netif_running(local->mdev) ||
-	    (local->apdev && netif_running(local->apdev)))
+	if (local->open_count || netif_running(local->mdev))
 		return -EBUSY;
 
 	ref = rate_control_alloc(name, local);
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-09-26 14:38:07.048936654 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-09-26 14:38:08.648936654 +0200
@@ -473,8 +473,6 @@ static void ieee80211_sta_tx(struct net_
 	pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
 	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
 	pkt_data->ifindex = sdata->dev->ifindex;
-	if (sdata->type == IEEE80211_IF_TYPE_MGMT)
-		pkt_data->flags |= IEEE80211_TXPD_MGMT_IFACE;
 	if (!encrypt)
 		pkt_data->flags |= IEEE80211_TXPD_DO_NOT_ENCRYPT;
 
--- wireless-dev.orig/net/mac80211/rx.c	2007-09-26 14:34:39.958936654 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-26 14:38:08.688936654 +0200
@@ -19,7 +19,6 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_led.h"
-#include "ieee80211_common.h"
 #include "wep.h"
 #include "wpa.h"
 #include "tkip.h"
@@ -412,12 +411,7 @@ ieee80211_rx_h_check(struct ieee80211_tx
 			return TXRX_DROP;
 		}
 
-		if (!rx->local->apdev)
-			return TXRX_DROP;
-
-		ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-				  ieee80211_msg_sta_not_assoc);
-		return TXRX_QUEUED;
+		return TXRX_DROP;
 	}
 
 	return TXRX_CONTINUE;
@@ -983,15 +977,8 @@ ieee80211_rx_h_802_1x_pae(struct ieee802
 {
 	if (rx->sdata->eapol && ieee80211_is_eapol(rx->skb) &&
 	    rx->sdata->type != IEEE80211_IF_TYPE_STA &&
-	    (rx->flags & IEEE80211_TXRXD_RXRA_MATCH)) {
-		/* Pass both encrypted and unencrypted EAPOL frames to user
-		 * space for processing. */
-		if (!rx->local->apdev)
-			return TXRX_DROP;
-		ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-				  ieee80211_msg_normal);
-		return TXRX_QUEUED;
-	}
+	    (rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
+		return TXRX_CONTINUE;
 
 	if (unlikely(rx->sdata->ieee802_1x &&
 		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
@@ -1233,15 +1220,11 @@ ieee80211_rx_h_mgmt(struct ieee80211_txr
 	sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 	if ((sdata->type == IEEE80211_IF_TYPE_STA ||
 	     sdata->type == IEEE80211_IF_TYPE_IBSS) &&
-	    !rx->local->user_space_mlme) {
+	    !rx->local->user_space_mlme)
 		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->u.rx.status);
-	} else {
-		/* Management frames are sent to hostapd for processing */
-		if (!rx->local->apdev)
-			return TXRX_DROP;
-		ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-				  ieee80211_msg_normal);
-	}
+	else
+		return TXRX_DROP;
+
 	return TXRX_QUEUED;
 }
 
@@ -1453,10 +1436,6 @@ static int prepare_for_handlers(struct i
 	case IEEE80211_IF_TYPE_MNTR:
 		/* take everything */
 		break;
-	case IEEE80211_IF_TYPE_MGMT:
-		/* should never get here */
-		WARN_ON(1);
-		break;
 	}
 
 	return 1;
--- wireless-dev.orig/net/mac80211/ieee80211_rate.h	2007-09-26 12:09:06.005337487 +0200
+++ wireless-dev/net/mac80211/ieee80211_rate.h	2007-09-26 14:38:08.698936654 +0200
@@ -30,8 +30,6 @@ struct rate_control_extra {
 
 	/* parameters from the caller to rate_control_get_rate(): */
 	struct ieee80211_hw_mode *mode;
-	int mgmt_data; /* this is data frame that is used for management
-			* (e.g., IEEE 802.1X EAPOL) */
 	u16 ethertype;
 };
 
--- wireless-dev.orig/net/mac80211/wme.c	2007-09-26 14:34:39.648936654 +0200
+++ wireless-dev/net/mac80211/wme.c	2007-09-26 14:38:08.698936654 +0200
@@ -94,8 +94,6 @@ static inline int wme_downgrade_ac(struc
 static inline int classify80211(struct sk_buff *skb, struct Qdisc *qd)
 {
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
-	struct ieee80211_tx_packet_data *pkt_data =
-		(struct ieee80211_tx_packet_data *) skb->cb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	unsigned short fc = le16_to_cpu(hdr->frame_control);
 	int qos;
@@ -108,12 +106,8 @@ static inline int classify80211(struct s
 		return IEEE80211_TX_QUEUE_DATA0;
 	}
 
-	if (unlikely(pkt_data->flags & IEEE80211_TXPD_MGMT_IFACE)) {
-		/* Data frames from hostapd (mainly, EAPOL) use AC_VO
-		* and they will include QoS control fields if
-		* the target STA is using WME. */
-		skb->priority = 7;
-		return ieee802_1d_to_ac[skb->priority];
+	if (0 /* injected */) {
+		/* use AC from radiotap */
 	}
 
 	/* is this a QoS frame? */

-- 


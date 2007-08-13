Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42435 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970843AbXHMI7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 04:59:06 -0400
Received: from [131.234.209.34] (helo=[131.234.237.45])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IKVlQ-0007SW-MI
	for linux-wireless@vger.kernel.org; Mon, 13 Aug 2007 09:59:05 +0100
Message-Id: <20070813074644.118092000@sipsolutions.net>
References: <20070813074504.416717000@sipsolutions.net>
Date: Mon, 13 Aug 2007 09:45:07 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mac80211: remove management interface
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yay! So I got hostapd working without the management interface,
that lets me remove it. Less code than I thought though.

It works like this but there are two minor TODO items,
injection needs to be able to
 * specify QoS parameters
 * circumvent PAE/802.1X checks

Oh and somebody needs to fix zd1211rw-mac80211. It abused the
MGMT interface constant that was explicitly mentioned to be
not for drivers... I've "fixed" it for now but readers of the
code may not be happy with it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.c |   22 +-
 include/net/mac80211.h                          |    6 
 net/mac80211/hostapd_ioctl.h                    |    1 
 net/mac80211/ieee80211.c                        |  186 ------------------------
 net/mac80211/ieee80211_common.h                 |   93 ------------
 net/mac80211/ieee80211_i.h                      |   10 -
 net/mac80211/ieee80211_iface.c                  |   57 -------
 net/mac80211/ieee80211_ioctl.c                  |   16 --
 net/mac80211/ieee80211_rate.c                   |    3 
 net/mac80211/ieee80211_rate.h                   |    2 
 net/mac80211/ieee80211_sta.c                    |    1 
 net/mac80211/rx.c                               |   11 -
 net/mac80211/tx.c                               |   72 ---------
 net/mac80211/wme.c                              |    4 
 14 files changed, 19 insertions(+), 465 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-12 19:47:27.649096253 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-12 19:47:30.479096253 +0200
@@ -174,8 +174,7 @@ struct ieee80211_tx_control {
 			   * specific value for the rate (from
 			   * struct ieee80211_rate) */
 
-#define IEEE80211_TXCTL_REQ_TX_STATUS	(1<<0)/* request TX status callback for
-						* this frame */
+/* bit 0 unused */
 #define IEEE80211_TXCTL_DO_NOT_ENCRYPT	(1<<1) /* send this frame without
 						* encryption; e.g., for EAPOL
 						* frames */
@@ -321,8 +320,6 @@ struct ieee80211_conf {
  * enum ieee80211_if_types - types of 802.11 network interfaces
  *
  * @IEEE80211_IF_TYPE_AP: interface in AP mode.
- * @IEEE80211_IF_TYPE_MGMT: special interface for communication with hostap
- *	daemon. Drivers should never see this type.
  * @IEEE80211_IF_TYPE_STA: interface in STA (client) mode.
  * @IEEE80211_IF_TYPE_IBSS: interface in IBSS (ad-hoc) mode.
  * @IEEE80211_IF_TYPE_MNTR: interface in monitor (rfmon) mode.
@@ -331,7 +328,6 @@ struct ieee80211_conf {
  */
 enum ieee80211_if_types {
 	IEEE80211_IF_TYPE_AP = 0x00000000,
-	IEEE80211_IF_TYPE_MGMT = 0x00000001,
 	IEEE80211_IF_TYPE_STA = 0x00000002,
 	IEEE80211_IF_TYPE_IBSS = 0x00000003,
 	IEEE80211_IF_TYPE_MNTR = 0x00000004,
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-12 19:47:27.699096253 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-12 19:47:30.489096253 +0200
@@ -23,7 +23,6 @@
 #include <linux/bitmap.h>
 #include <net/cfg80211.h>
 
-#include "ieee80211_common.h"
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
 #include "wep.h"
@@ -92,115 +91,6 @@ static int ieee80211_master_stop(struct 
 	return 0;
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
-		case MODE_ATHEROS_TURBO:
-			fi->phytype =
-				htonl(ieee80211_phytype_dsss_dot11_turbo);
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
-	struct ieee80211_sub_if_data *sdata;
-
-	skb->dev = local->apdev;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(local->apdev);
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
-	sdata->stats.rx_packets++;
-	sdata->stats.rx_bytes += skb->len;
-
-	skb_set_mac_header(skb, 0);
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
-	skb->pkt_type = PACKET_OTHERHOST;
-	skb->protocol = htons(ETH_P_802_2);
-	memset(skb->cb, 0, sizeof(skb->cb));
-	netif_rx(skb);
-}
-
 void ieee80211_key_threshold_notify(struct net_device *dev,
 				    struct ieee80211_key *key,
 				    struct sta_info *sta)
@@ -209,51 +99,6 @@ void ieee80211_key_threshold_notify(stru
 	/* TODO: add back support via cfg80211/nl80211 */
 }
 
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
-	dev->get_stats = ieee80211_get_stats;
-	dev->open = ieee80211_mgmt_open;
-	dev->stop = ieee80211_mgmt_stop;
-	dev->type = ARPHRD_IEEE80211_PRISM;
-	dev->hard_header_parse = header_parse_80211;
-	dev->uninit = ieee80211_if_reinit;
-	dev->destructor = ieee80211_if_free;
-}
-
 /* regular interfaces */
 
 static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
@@ -396,8 +241,6 @@ static int ieee80211_open(struct net_dev
 				res = ieee80211_hw_config(local);
 				if (res && local->ops->stop)
 					local->ops->stop(local_to_hw(local));
-				else if (!res && local->apdev)
-					dev_open(local->apdev);
 			}
 		}
 		if (res) {
@@ -481,8 +324,6 @@ static int ieee80211_stop(struct net_dev
 	if (local->open_count == 0) {
 		if (netif_running(local->mdev))
 			dev_close(local->mdev);
-		if (local->apdev)
-			dev_close(local->apdev);
 		if (local->ops->stop)
 			local->ops->stop(local_to_hw(local));
 		tasklet_disable(&local->tx_pending_tasklet);
@@ -813,7 +654,7 @@ void ieee80211_tx_status_irqsafe(struct 
 	memcpy(skb->cb, &saved, sizeof(saved));
 
 	skb->pkt_type = IEEE80211_TX_STATUS_MSG;
-	skb_queue_tail(status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS ?
+	skb_queue_tail(local->monitors ?
 		       &local->skb_queue : &local->skb_queue_unreliable, skb);
 	tmp = skb_queue_len(&local->skb_queue) +
 		skb_queue_len(&local->skb_queue_unreliable);
@@ -878,8 +719,6 @@ static void ieee80211_remove_tx_extra(st
 
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	pkt_data->ifindex = control->ifindex;
-	pkt_data->mgmt_iface = (control->type == IEEE80211_IF_TYPE_MGMT);
-	pkt_data->req_tx_status = !!(control->flags & IEEE80211_TXCTL_REQ_TX_STATUS);
 	pkt_data->do_not_encrypt = !!(control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT);
 	pkt_data->requeue = !!(control->flags & IEEE80211_TXCTL_REQUEUE);
 	pkt_data->queue = control->queue;
@@ -933,7 +772,6 @@ void ieee80211_tx_status(struct ieee8021
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_local *local = hw_to_local(hw);
 	u16 frag, type;
-	u32 msg_type;
 	struct ieee80211_tx_status_rtap_hdr *rthdr;
 	struct ieee80211_sub_if_data *sdata;
 	int monitors;
@@ -1048,29 +886,9 @@ void ieee80211_tx_status(struct ieee8021
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
@@ -1416,8 +1234,6 @@ void ieee80211_unregister_hw(struct ieee
 	BUG_ON(local->reg_state != IEEE80211_DEV_REGISTERED);
 
 	local->reg_state = IEEE80211_DEV_UNREGISTERED;
-	if (local->apdev)
-		ieee80211_if_del_mgmt(local);
 
 	write_lock_bh(&local->sub_if_lock);
 	list_replace_init(&local->sub_if_list, &tmp_list);
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-08-12 19:47:27.739096253 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,93 +0,0 @@
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
-	/* hole at 7, was ieee80211_msg_sta_not_assoc but now unused */
-	/* 8 was ieee80211_msg_set_aid_for_sta */
-	/* hole at 9, was ieee80211_msg_key_threshold_notification */
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
-	ieee80211_phytype_dsss_dot11_turbog = 255,
-	ieee80211_phytype_dsss_dot11_turbo = 256,
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
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-12 19:47:27.789096253 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-12 19:47:30.489096253 +0200
@@ -141,7 +141,6 @@ struct ieee80211_txrx_data {
 			 * when using CTS protection with IEEE 802.11g. */
 			struct ieee80211_rate *last_frag_rate;
 			int last_frag_hwrate;
-			int mgmt_interface;
 
 			/* Extra fragments (in addition to the first fragment
 			 * in skb) */
@@ -170,10 +169,8 @@ struct ieee80211_txrx_data {
 struct ieee80211_tx_packet_data {
 	int ifindex;
 	unsigned long jiffies;
-	unsigned int req_tx_status:1;
 	unsigned int do_not_encrypt:1;
 	unsigned int requeue:1;
-	unsigned int mgmt_iface:1;
 	unsigned int queue:4;
 };
 
@@ -468,7 +465,6 @@ struct ieee80211_local {
 	struct list_head modes_list;
 
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
-	struct net_device *apdev; /* wlan#ap - management frames (hostapd) */
 	int open_count;
 	int monitors;
 	struct iw_statistics wstats;
@@ -808,14 +804,11 @@ static inline int ieee80211_bssid_match(
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
 struct net_device_stats *ieee80211_dev_stats(struct net_device *dev);
 struct ieee80211_rate *ieee80211_get_rate(struct ieee80211_local *local,
 					  int phymode, int hwrate);
@@ -916,8 +909,6 @@ void __ieee80211_if_del(struct ieee80211
 int ieee80211_if_remove(struct net_device *dev, const char *name, int id);
 void ieee80211_if_free(struct net_device *dev);
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata);
-int ieee80211_if_add_mgmt(struct ieee80211_local *local);
-void ieee80211_if_del_mgmt(struct ieee80211_local *local);
 
 /* regdomain.c */
 void ieee80211_regdomain_init(void);
@@ -934,7 +925,6 @@ void ieee80211_tx_pending(unsigned long 
 int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int ieee80211_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
-int ieee80211_mgmt_start_xmit(struct sk_buff *skb, struct net_device *dev);
 
 /* key handling */
 struct ieee80211_key_conf *
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-12 19:47:27.819096253 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-12 19:47:30.489096253 +0200
@@ -59,7 +59,6 @@ enum {
 	PRISM2_PARAM_RADAR_DETECT = 1043,
 	PRISM2_PARAM_SPECTRUM_MGMT = 1044,
 	PRISM2_PARAM_USER_SPACE_MLME = 1045,
-	PRISM2_PARAM_MGMT_IF = 1046,
 };
 
 /* PRISM2_IOCTL_HOSTAPD ioctl() cmd:
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-12 19:47:27.869096253 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-12 19:47:30.489096253 +0200
@@ -2328,16 +2328,6 @@ static int ieee80211_ioctl_prism2_param(
 	case PRISM2_PARAM_SPECTRUM_MGMT:
 		local->hw.conf.spect_mgmt = value;
 		break;
-	case PRISM2_PARAM_MGMT_IF:
-		if (value == 1) {
-			if (!local->apdev)
-				ret = ieee80211_if_add_mgmt(local);
-		} else if (value == 0) {
-			if (local->apdev)
-				ieee80211_if_del_mgmt(local);
-		} else
-			ret = -EINVAL;
-		break;
 	case PRISM2_PARAM_USER_SPACE_MLME:
 		local->user_space_mlme = value;
 		break;
@@ -2487,12 +2477,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		else
 			*param = !!sdata->u.sta.wmm_enabled;
 		break;
-	case PRISM2_PARAM_MGMT_IF:
-		if (local->apdev)
-			*param = local->apdev->ifindex;
-		else
-			ret = -ENOENT;
-		break;
 	case PRISM2_PARAM_USER_SPACE_MLME:
 		*param = local->user_space_mlme;
 		break;
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-08-12 19:47:27.949096253 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-08-12 19:47:30.489096253 +0200
@@ -97,60 +97,6 @@ fail:
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
@@ -364,11 +310,8 @@ int ieee80211_if_remove(struct net_devic
 
 void ieee80211_if_free(struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	/* local->apdev must be NULL when freeing management interface */
-	BUG_ON(dev == local->apdev);
 	ieee80211_if_sdata_deinit(sdata);
 	free_netdev(dev);
 }
--- wireless-dev.orig/net/mac80211/ieee80211_rate.c	2007-08-12 19:47:27.999096253 +0200
+++ wireless-dev/net/mac80211/ieee80211_rate.c	2007-08-12 19:47:30.559096253 +0200
@@ -145,8 +145,7 @@ int ieee80211_init_rate_ctrl_alg(struct 
 	struct rate_control_ref *ref, *old;
 
 	ASSERT_RTNL();
-	if (local->open_count || netif_running(local->mdev) ||
-	    (local->apdev && netif_running(local->apdev)))
+	if (local->open_count || netif_running(local->mdev))
 		return -EBUSY;
 
 	ref = rate_control_alloc(name, local);
--- wireless-dev.orig/net/mac80211/ieee80211_rate.h	2007-08-12 19:47:28.059096253 +0200
+++ wireless-dev/net/mac80211/ieee80211_rate.h	2007-08-12 19:47:30.559096253 +0200
@@ -30,8 +30,6 @@ struct rate_control_extra {
 
 	/* parameters from the caller to rate_control_get_rate(): */
 	struct ieee80211_hw_mode *mode;
-	int mgmt_data; /* this is data frame that is used for management
-			* (e.g., IEEE 802.1X EAPOL) */
 	u16 ethertype;
 };
 
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-08-12 19:47:28.109096253 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-08-12 19:47:30.559096253 +0200
@@ -506,7 +506,6 @@ static void ieee80211_sta_tx(struct net_
 	pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
 	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
 	pkt_data->ifindex = sdata->dev->ifindex;
-	pkt_data->mgmt_iface = (sdata->type == IEEE80211_IF_TYPE_MGMT);
 	pkt_data->do_not_encrypt = !encrypt;
 
 	dev_queue_xmit(skb);
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-12 19:47:28.149096253 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-12 19:47:30.559096253 +0200
@@ -18,7 +18,6 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_led.h"
-#include "ieee80211_common.h"
 #include "wep.h"
 #include "wpa.h"
 #include "tkip.h"
@@ -1199,14 +1198,10 @@ ieee80211_rx_h_mgmt(struct ieee80211_txr
 	     sdata->type == IEEE80211_IF_TYPE_IBSS) &&
 	    !rx->local->user_space_mlme) {
 		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->u.rx.status);
-	} else {
-		/* Management frames are sent to hostapd for processing */
-		if (!rx->local->apdev)
-			return TXRX_DROP;
-		ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-				  ieee80211_msg_normal);
+		return TXRX_QUEUED;
 	}
-	return TXRX_QUEUED;
+
+	return TXRX_DROP;
 }
 
 static inline ieee80211_txrx_result __ieee80211_invoke_rx_handlers(
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-12 19:47:28.189096253 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-12 19:59:43.549096253 +0200
@@ -254,7 +254,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 		return TXRX_CONTINUE;
 	}
 
-	if (unlikely(!tx->u.tx.mgmt_interface && tx->sdata->ieee802_1x &&
+	if (unlikely(/* TODO: not injected packet && */ tx->sdata->ieee802_1x &&
 		     !(sta_flags & WLAN_STA_AUTHORIZED))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		printk(KERN_DEBUG "%s: dropped frame to " MAC_FMT
@@ -597,8 +597,6 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 
 	memset(&extra, 0, sizeof(extra));
 	extra.mode = tx->u.tx.mode;
-	extra.mgmt_data = tx->sdata &&
-		tx->sdata->type == IEEE80211_IF_TYPE_MGMT;
 	extra.ethertype = tx->ethertype;
 
 	tx->u.tx.rate = rate_control_get_rate(tx->local, tx->dev, tx->skb,
@@ -1087,7 +1085,7 @@ static int __ieee80211_tx(struct ieee802
 }
 
 static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
-			struct ieee80211_tx_control *control, int mgmt)
+			struct ieee80211_tx_control *control)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
@@ -1111,7 +1109,6 @@ static int ieee80211_tx(struct net_devic
 	}
 
 	sta = tx.sta;
-	tx.u.tx.mgmt_interface = mgmt;
 	tx.u.tx.mode = local->hw.conf.mode;
 
 	/*
@@ -1255,16 +1252,13 @@ int ieee80211_master_start_xmit(struct s
 
 	control.ifindex = odev->ifindex;
 	control.type = osdata->type;
-	if (pkt_data->req_tx_status)
-		control.flags |= IEEE80211_TXCTL_REQ_TX_STATUS;
 	if (pkt_data->do_not_encrypt)
 		control.flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 	if (pkt_data->requeue)
 		control.flags |= IEEE80211_TXCTL_REQUEUE;
 	control.queue = pkt_data->queue;
 
-	ret = ieee80211_tx(odev, skb, &control,
-			   control.type == IEEE80211_IF_TYPE_MGMT);
+	ret = ieee80211_tx(odev, skb, &control);
 	dev_put(odev);
 
 	return ret;
@@ -1301,7 +1295,6 @@ int ieee80211_monitor_start_xmit(struct 
 	/* needed because we set skb device to master */
 	pkt_data->ifindex = dev->ifindex;
 
-	pkt_data->mgmt_iface = 0;
 	pkt_data->do_not_encrypt = 1;
 
 	/*
@@ -1499,7 +1492,6 @@ int ieee80211_subif_start_xmit(struct sk
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
 	pkt_data->ifindex = dev->ifindex;
-	pkt_data->mgmt_iface = (sdata->type == IEEE80211_IF_TYPE_MGMT);
 	pkt_data->do_not_encrypt = no_encrypt;
 
 	skb->dev = local->mdev;
@@ -1525,64 +1517,6 @@ int ieee80211_subif_start_xmit(struct sk
 	return ret;
 }
 
-/*
- * This is the transmit routine for the 802.11 type interfaces
- * called by upper layers of the linux networking
- * stack when it has a frame to transmit
- */
-int ieee80211_mgmt_start_xmit(struct sk_buff *skb, struct net_device *dev)
-{
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_tx_packet_data *pkt_data;
-	struct ieee80211_hdr *hdr;
-	u16 fc;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (skb->len < 10) {
-		dev_kfree_skb(skb);
-		return 0;
-	}
-
-	if (skb_headroom(skb) < sdata->local->tx_headroom) {
-		if (pskb_expand_head(skb, sdata->local->tx_headroom,
-				     0, GFP_ATOMIC)) {
-			dev_kfree_skb(skb);
-			return 0;
-		}
-	}
-
-	hdr = (struct ieee80211_hdr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_control);
-
-	pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
-	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
-	pkt_data->ifindex = sdata->dev->ifindex;
-	pkt_data->mgmt_iface = (sdata->type == IEEE80211_IF_TYPE_MGMT);
-
-	skb->priority = 20; /* use hardcoded priority for mgmt TX queue */
-	skb->dev = sdata->local->mdev;
-
-	/*
-	 * We're using the protocol field of the the frame control header
-	 * to request TX callback for hostapd. BIT(1) is checked.
-	 */
-	if ((fc & BIT(1)) == BIT(1)) {
-		pkt_data->req_tx_status = 1;
-		fc &= ~BIT(1);
-		hdr->frame_control = cpu_to_le16(fc);
-	}
-
-	pkt_data->do_not_encrypt = !(fc & IEEE80211_FCTL_PROTECTED);
-
-	sdata->stats.tx_packets++;
-	sdata->stats.tx_bytes += skb->len;
-
-	dev_queue_xmit(skb);
-
-	return 0;
-}
-
 /* helper functions for pending packets for when queues are stopped */
 
 void ieee80211_clear_tx_pending(struct ieee80211_local *local)
--- wireless-dev.orig/net/mac80211/wme.c	2007-08-12 19:47:28.209096253 +0200
+++ wireless-dev/net/mac80211/wme.c	2007-08-12 19:47:30.569096253 +0200
@@ -96,8 +96,6 @@ static inline int classify80211(struct s
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(qd->dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	struct ieee80211_tx_packet_data *pkt_data =
-		(struct ieee80211_tx_packet_data *) skb->cb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	unsigned short fc = le16_to_cpu(hdr->frame_control);
 	int qos, tsid, dir;
@@ -110,7 +108,7 @@ static inline int classify80211(struct s
 		return IEEE80211_TX_QUEUE_DATA0;
 	}
 
-	if (unlikely(pkt_data->mgmt_iface)) {
+	if (0 /* TODO, some injection parameter? */) {
 		/* Data frames from hostapd (mainly, EAPOL) use AC_VO
 		* and they will include QoS control fields if
 		* the target STA is using WME. */
--- wireless-dev.orig/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c	2007-08-12 19:47:28.399096253 +0200
+++ wireless-dev/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c	2007-08-12 19:47:30.569096253 +0200
@@ -28,6 +28,8 @@
 #include "zd_rf.h"
 #include "zd_util.h"
 
+#define ZD1211_NO_DEV_ABUSE -1
+
 /* This table contains the hardware specific values for the modulation rates. */
 static const struct ieee80211_rate zd_rates[] = {
 	{ .rate = 10,
@@ -352,8 +354,6 @@ static int init_tx_skb_control_block(str
  * This information calls ieee80211_tx_status_irqsafe() if required by the
  * control information. It copies the control information into the status
  * information.
- *
- * If no status information has been requested, the skb is freed.
  */
 static void tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
 	              struct ieee80211_tx_status *status)
@@ -362,13 +362,9 @@ static void tx_status(struct ieee80211_h
 		skb->cb;
 
 	ZD_ASSERT(cb->control != NULL);
-	if ((cb->control->flags & IEEE80211_TXCTL_REQ_TX_STATUS)) {
-		memcpy(&status->control, cb->control, sizeof(status->control));
-		clear_tx_skb_control_block(skb);
-		ieee80211_tx_status_irqsafe(hw, skb, status);
-	} else {
-		kfree_tx_skb(skb);
-	}
+	memcpy(&status->control, cb->control, sizeof(status->control));
+	clear_tx_skb_control_block(skb);
+	ieee80211_tx_status_irqsafe(hw, skb, status);
 }
 
 /**
@@ -710,8 +706,8 @@ static int zd_op_add_interface(struct ie
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 
-	/* NOTE: using IEEE80211_IF_TYPE_MGMT to indicate no mode selected */
-	if (mac->type != IEEE80211_IF_TYPE_MGMT)
+	/* NOTE: abusing the type enum to indicate no mode selected */
+	if (mac->type != ZD1211_NO_DEV_ABUSE)
 		return -1;
 
 	switch (conf->type) {
@@ -732,7 +728,7 @@ static void zd_op_remove_interface(struc
 				    struct ieee80211_if_init_conf *conf)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
-	mac->type = IEEE80211_IF_TYPE_MGMT;
+	mac->type = ZD1211_NO_DEV_ABUSE;
 }
 
 static int zd_op_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
@@ -862,7 +858,7 @@ struct ieee80211_hw *zd_mac_alloc_hw(str
 	spin_lock_init(&mac->lock);
 	mac->hw = hw;
 
-	mac->type = IEEE80211_IF_TYPE_MGMT;
+	mac->type = ZD1211_NO_DEV_ABUSE;
 	mac->hwaddr = hw->wiphy->perm_addr;
 
 	memcpy(mac->channels, zd_channels, sizeof(zd_channels));

-- 


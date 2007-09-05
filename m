Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbXIFNqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:46:35 -0400
Message-Id: <20070905234623.673976000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 05/21] mac80211: remove key threshold stuff
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the key threshold stuff from mac80211. 
I have patches for later that add it as a per-key setting 
to nl/cfg80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/debugfs.c          |    4 ----
 net/mac80211/hostapd_ioctl.h    |    1 -
 net/mac80211/ieee80211.c        |   35 -----------------------------------
 net/mac80211/ieee80211_common.h |    2 +-
 net/mac80211/ieee80211_i.h      |    7 -------
 net/mac80211/ieee80211_ioctl.c  |    8 --------
 net/mac80211/rx.c               |    7 +------
 net/mac80211/tx.c               |    7 +------
 8 files changed, 3 insertions(+), 68 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-09-06 01:34:58.084453431 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-09-06 01:35:14.614453431 +0200
@@ -38,7 +38,6 @@ enum {
 	PRISM2_PARAM_PRIVACY_INVOKED = 1014,
 	PRISM2_PARAM_BROADCAST_SSID = 1015,
 	PRISM2_PARAM_EAPOL = 1023,
-	PRISM2_PARAM_KEY_TX_RX_THRESHOLD = 1024,
 	PRISM2_PARAM_WIFI_WME_NOACK_TEST = 1033,
 	PRISM2_PARAM_SCAN_FLAGS = 1035,
 	PRISM2_PARAM_HW_MODES = 1036,
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-06 01:35:13.774453431 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-06 01:35:14.624453431 +0200
@@ -306,41 +306,6 @@ ieee80211_rx_mgmt(struct ieee80211_local
 	netif_rx(skb);
 }
 
-void ieee80211_key_threshold_notify(struct net_device *dev,
-				    struct ieee80211_key *key,
-				    struct sta_info *sta)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct sk_buff *skb;
-	struct ieee80211_msg_key_notification *msg;
-
-	/* if no one will get it anyway, don't even allocate it.
-	 * unlikely because this is only relevant for APs
-	 * where the device must be open... */
-	if (unlikely(!local->apdev))
-		return;
-
-	skb = dev_alloc_skb(sizeof(struct ieee80211_frame_info) +
-			    sizeof(struct ieee80211_msg_key_notification));
-	if (!skb)
-		return;
-
-	skb_reserve(skb, sizeof(struct ieee80211_frame_info));
-	msg = (struct ieee80211_msg_key_notification *)
-		skb_put(skb, sizeof(struct ieee80211_msg_key_notification));
-	msg->tx_rx_count = key->tx_rx_count;
-	memcpy(msg->ifname, dev->name, IFNAMSIZ);
-	if (sta)
-		memcpy(msg->addr, sta->addr, ETH_ALEN);
-	else
-		memset(msg->addr, 0xff, ETH_ALEN);
-
-	key->tx_rx_count = 0;
-
-	ieee80211_rx_mgmt(local, skb, NULL,
-			  ieee80211_msg_key_threshold_notification);
-}
-
 static int ieee80211_mgmt_open(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-09-06 01:34:58.154453431 +0200
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-09-06 01:35:14.624453431 +0200
@@ -53,7 +53,7 @@ enum ieee80211_msg_type {
 	/* hole at 6, was monitor but never sent to userspace */
 	ieee80211_msg_sta_not_assoc = 7,
 	/* 8 was ieee80211_msg_set_aid_for_sta */
-	ieee80211_msg_key_threshold_notification = 9,
+	/* 9 was ieee80211_msg_key_threshold_notification */
 	/* 11 was ieee80211_msg_radar */
 };
 
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-09-06 01:35:13.774453431 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-09-06 01:35:14.624453431 +0200
@@ -539,9 +539,6 @@ struct ieee80211_local {
 	struct crypto_blkcipher *wep_tx_tfm;
 	struct crypto_blkcipher *wep_rx_tfm;
 	u32 wep_iv;
-	int key_tx_rx_threshold; /* number of times any key can be used in TX
-				  * or RX before generating a rekey
-				  * notification; 0 = notification disabled. */
 
 	int bridge_packets; /* bridge packets between associated stations and
 			     * deliver multicast frames both back to wireless
@@ -658,7 +655,6 @@ struct ieee80211_local {
 		struct dentry *antenna_sel_tx;
 		struct dentry *antenna_sel_rx;
 		struct dentry *bridge_packets;
-		struct dentry *key_tx_rx_threshold;
 		struct dentry *rts_threshold;
 		struct dentry *fragmentation_threshold;
 		struct dentry *short_retry_limit;
@@ -816,9 +812,6 @@ void ieee80211_if_mgmt_setup(struct net_
 struct net_device_stats *ieee80211_dev_stats(struct net_device *dev);
 struct ieee80211_rate *ieee80211_get_rate(struct ieee80211_local *local,
 					  int phymode, int hwrate);
-void ieee80211_key_threshold_notify(struct net_device *dev,
-				    struct ieee80211_key *key,
-				    struct sta_info *sta);
 
 /* ieee80211_ioctl.c */
 int ieee80211_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-09-06 01:34:58.224453431 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-09-06 01:35:14.624453431 +0200
@@ -1686,10 +1686,6 @@ static int ieee80211_ioctl_prism2_param(
 		sdata->eapol = value;
 		break;
 
-	case PRISM2_PARAM_KEY_TX_RX_THRESHOLD:
-		local->key_tx_rx_threshold = value;
-		break;
-
 	case PRISM2_PARAM_WIFI_WME_NOACK_TEST:
 		local->wifi_wme_noack_test = value;
 		break;
@@ -1821,10 +1817,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = sdata->eapol;
 		break;
 
-	case PRISM2_PARAM_KEY_TX_RX_THRESHOLD:
-		*param = local->key_tx_rx_threshold;
-		break;
-
 	case PRISM2_PARAM_WIFI_WME_NOACK_TEST:
 		*param = local->wifi_wme_noack_test;
 		break;
--- wireless-dev.orig/net/mac80211/rx.c	2007-09-06 01:35:12.364453431 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-06 01:35:14.634453431 +0200
@@ -422,12 +422,7 @@ ieee80211_rx_h_load_key(struct ieee80211
 
 	if (rx->key) {
 		rx->key->tx_rx_count++;
-		if (unlikely(rx->local->key_tx_rx_threshold &&
-			     rx->key->tx_rx_count >
-			     rx->local->key_tx_rx_threshold)) {
-			ieee80211_key_threshold_notify(rx->dev, rx->key,
-						       rx->sta);
-		}
+		/* TODO: add threshold stuff again */
 	}
 
 	return TXRX_CONTINUE;
--- wireless-dev.orig/net/mac80211/debugfs.c	2007-09-06 01:34:58.274453431 +0200
+++ wireless-dev/net/mac80211/debugfs.c	2007-09-06 01:35:14.634453431 +0200
@@ -104,8 +104,6 @@ DEBUGFS_READONLY_FILE(antenna_sel_rx, 20
 		      local->hw.conf.antenna_sel_rx);
 DEBUGFS_READONLY_FILE(bridge_packets, 20, "%d",
 		      local->bridge_packets);
-DEBUGFS_READONLY_FILE(key_tx_rx_threshold, 20, "%d",
-		      local->key_tx_rx_threshold);
 DEBUGFS_READONLY_FILE(rts_threshold, 20, "%d",
 		      local->rts_threshold);
 DEBUGFS_READONLY_FILE(fragmentation_threshold, 20, "%d",
@@ -331,7 +329,6 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_ADD(antenna_sel_tx);
 	DEBUGFS_ADD(antenna_sel_rx);
 	DEBUGFS_ADD(bridge_packets);
-	DEBUGFS_ADD(key_tx_rx_threshold);
 	DEBUGFS_ADD(rts_threshold);
 	DEBUGFS_ADD(fragmentation_threshold);
 	DEBUGFS_ADD(short_retry_limit);
@@ -395,7 +392,6 @@ void debugfs_hw_del(struct ieee80211_loc
 	DEBUGFS_DEL(antenna_sel_tx);
 	DEBUGFS_DEL(antenna_sel_rx);
 	DEBUGFS_DEL(bridge_packets);
-	DEBUGFS_DEL(key_tx_rx_threshold);
 	DEBUGFS_DEL(rts_threshold);
 	DEBUGFS_DEL(fragmentation_threshold);
 	DEBUGFS_DEL(short_retry_limit);
--- wireless-dev.orig/net/mac80211/tx.c	2007-09-06 01:35:10.934453431 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-09-06 01:35:14.634453431 +0200
@@ -446,12 +446,7 @@ ieee80211_tx_h_select_key(struct ieee802
 
 	if (tx->key) {
 		tx->key->tx_rx_count++;
-		if (unlikely(tx->local->key_tx_rx_threshold &&
-			     tx->key->tx_rx_count >
-			     tx->local->key_tx_rx_threshold)) {
-			ieee80211_key_threshold_notify(tx->dev, tx->key,
-						       tx->sta);
-		}
+		/* TODO: add threshold stuff again */
 	}
 
 	return TXRX_CONTINUE;

-- 


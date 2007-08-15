Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762674AbXHOO4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 10:56:38 -0400
Message-Id: <20070815145050.223404000@sipsolutions.net>
References: <20070815144920.135826000@sipsolutions.net>
Date: Wed, 15 Aug 2007 16:49:40 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 20/20] mac80211: remove VLAN stuff
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes all VLAN stuff from mac80211.

At the moment, it cannot possibly work, mac80211 doesn't actually do
anything with those VLAN type interfaces. Also, there doesn't seem to be
any point in doing it in the wireless stack. The recently added
"macvlan" shows how you can do VLANs based on destination address, what
we will need is something like "smacvlan" that does VLANs based on
source address.

Hence, let's remove this, and when somebody needs it they get to add it
properly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h         |    2 -
 net/mac80211/debugfs_netdev.c  |   27 --------------------
 net/mac80211/debugfs_sta.c     |    1 
 net/mac80211/hostapd_ioctl.h   |    9 +-----
 net/mac80211/ieee80211.c       |    7 -----
 net/mac80211/ieee80211_i.h     |   12 ---------
 net/mac80211/ieee80211_iface.c |    2 -
 net/mac80211/ieee80211_ioctl.c |   54 -----------------------------------------
 net/mac80211/rx.c              |   12 +++------
 net/mac80211/sta_info.h        |    2 -
 net/mac80211/tx.c              |    5 +--
 11 files changed, 11 insertions(+), 122 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-15 14:27:22.436516958 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-15 14:27:31.036516958 +0200
@@ -308,12 +308,7 @@ static inline int identical_mac_addr_all
 		 type2 == IEEE80211_IF_TYPE_WDS) ||
 		(type1 == IEEE80211_IF_TYPE_WDS &&
 		 (type2 == IEEE80211_IF_TYPE_WDS ||
-		  type2 == IEEE80211_IF_TYPE_AP)) ||
-		(type1 == IEEE80211_IF_TYPE_AP &&
-		 type2 == IEEE80211_IF_TYPE_VLAN) ||
-		(type1 == IEEE80211_IF_TYPE_VLAN &&
-		 (type2 == IEEE80211_IF_TYPE_AP ||
-		  type2 == IEEE80211_IF_TYPE_VLAN)));
+		  type2 == IEEE80211_IF_TYPE_AP)));
 }
 
 /* Check if running monitor interfaces should go to a "soft monitor" mode
--- wireless-dev.orig/include/net/mac80211.h	2007-08-15 14:27:27.166516958 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-15 14:27:31.036516958 +0200
@@ -310,7 +310,6 @@ struct ieee80211_conf {
  * @IEEE80211_IF_TYPE_IBSS: interface in IBSS (ad-hoc) mode.
  * @IEEE80211_IF_TYPE_MNTR: interface in monitor (rfmon) mode.
  * @IEEE80211_IF_TYPE_WDS: interface in WDS mode.
- * @IEEE80211_IF_TYPE_VLAN: not used.
  */
 enum ieee80211_if_types {
 	IEEE80211_IF_TYPE_AP = 0x00000000,
@@ -319,7 +318,6 @@ enum ieee80211_if_types {
 	IEEE80211_IF_TYPE_IBSS = 0x00000003,
 	IEEE80211_IF_TYPE_MNTR = 0x00000004,
 	IEEE80211_IF_TYPE_WDS = 0x5A580211,
-	IEEE80211_IF_TYPE_VLAN = 0x00080211,
 };
 
 /**
--- wireless-dev.orig/net/mac80211/debugfs_netdev.c	2007-08-15 14:27:22.506516958 +0200
+++ wireless-dev/net/mac80211/debugfs_netdev.c	2007-08-15 14:27:31.036516958 +0200
@@ -422,9 +422,6 @@ __IEEE80211_IF_FILE(beacon_tail_len);
 /* WDS attributes */
 IEEE80211_IF_FILE(peer, u.wds.remote_addr, MAC);
 
-/* VLAN attributes */
-IEEE80211_IF_FILE(vlan_id, u.vlan.id, DEC);
-
 /* MONITOR attributes */
 static ssize_t ieee80211_if_fmt_mode(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
@@ -531,15 +528,6 @@ static void add_wds_files(struct ieee802
 	DEBUGFS_ADD(peer, wds);
 }
 
-static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
-{
-	DEBUGFS_ADD(channel_use, vlan);
-	DEBUGFS_ADD(drop_unencrypted, vlan);
-	DEBUGFS_ADD(eapol, vlan);
-	DEBUGFS_ADD(ieee8021_x, vlan);
-	DEBUGFS_ADD(vlan_id, vlan);
-}
-
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(mode, monitor);
@@ -564,9 +552,6 @@ static void add_files(struct ieee80211_s
 	case IEEE80211_IF_TYPE_MNTR:
 		add_monitor_files(sdata);
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
-		add_vlan_files(sdata);
-		break;
 	default:
 		break;
 	}
@@ -660,15 +645,6 @@ static void del_wds_files(struct ieee802
 	DEBUGFS_DEL(peer, wds);
 }
 
-static void del_vlan_files(struct ieee80211_sub_if_data *sdata)
-{
-	DEBUGFS_DEL(channel_use, vlan);
-	DEBUGFS_DEL(drop_unencrypted, vlan);
-	DEBUGFS_DEL(eapol, vlan);
-	DEBUGFS_DEL(ieee8021_x, vlan);
-	DEBUGFS_DEL(vlan_id, vlan);
-}
-
 static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_DEL(mode, monitor);
@@ -693,9 +669,6 @@ static void del_files(struct ieee80211_s
 	case IEEE80211_IF_TYPE_MNTR:
 		del_monitor_files(sdata);
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
-		del_vlan_files(sdata);
-		break;
 	default:
 		break;
 	}
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-15 14:27:22.596516958 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-15 14:27:31.036516958 +0200
@@ -61,7 +61,6 @@ enum {
 	PRISM2_HOSTAPD_SET_RATE_SETS = 1005,
 	PRISM2_HOSTAPD_ADD_IF = 1006,
 	PRISM2_HOSTAPD_REMOVE_IF = 1007,
-	PRISM2_HOSTAPD_SET_STA_VLAN = 1010,
 	PRISM2_HOSTAPD_SET_CHANNEL_FLAG = 1012,
 	PRISM2_HOSTAPD_SET_REGULATORY_DOMAIN = 1013,
 	PRISM2_HOSTAPD_SET_TX_QUEUE_PARAMS = 1014,
@@ -135,15 +134,11 @@ struct prism2_hostapd_param {
 					     * num_basic_rates * u16 */
 		} set_rate_sets;
 		struct {
-			u8 type; /* WDS, VLAN, etc */
+			u8 type; /* WDS, etc */
 			u8 name[IFNAMSIZ];
 			u8 data[0] ALIGNED;
 		} if_info;
 		struct {
-			char vlan_name[IFNAMSIZ];
-			int vlan_id;
-		} set_sta_vlan;
-		struct {
 			u16 mode; /* MODE_* */
 			u16 chan;
 			u32 flag;
@@ -201,7 +196,7 @@ struct ieee80211_rate_data {
 
 /* ADD_IF and REMOVE_IF 'type' argument */
 enum {
-	HOSTAP_IF_WDS = 1, HOSTAP_IF_VLAN = 2, HOSTAP_IF_BSS = 3,
+	HOSTAP_IF_WDS = 1, HOSTAP_IF_BSS = 3,
 	HOSTAP_IF_STA = 4
 };
 
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-15 14:27:22.606516958 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-15 14:27:31.036516958 +0200
@@ -233,10 +233,6 @@ struct ieee80211_if_wds {
 	struct sta_info *sta;
 };
 
-struct ieee80211_if_vlan {
-	u8 id;
-};
-
 struct ieee80211_if_sta {
 	enum {
 		IEEE80211_DISABLED, IEEE80211_AUTHENTICATE,
@@ -348,7 +344,6 @@ struct ieee80211_sub_if_data {
 	union {
 		struct ieee80211_if_ap ap;
 		struct ieee80211_if_wds wds;
-		struct ieee80211_if_vlan vlan;
 		struct ieee80211_if_sta sta;
 	} u;
 	int channel_use;
@@ -433,13 +428,6 @@ struct ieee80211_sub_if_data {
 			struct dentry *peer;
 		} wds;
 		struct {
-			struct dentry *channel_use;
-			struct dentry *drop_unencrypted;
-			struct dentry *eapol;
-			struct dentry *ieee8021_x;
-			struct dentry *vlan_id;
-		} vlan;
-		struct {
 			struct dentry *mode;
 		} monitor;
 		struct dentry *default_key;
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-08-15 14:27:22.666516958 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-08-15 14:27:31.036516958 +0200
@@ -165,8 +165,6 @@ void ieee80211_if_set_type(struct net_de
 	case IEEE80211_IF_TYPE_WDS:
 		sdata->bss = NULL;
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
-		break;
 	case IEEE80211_IF_TYPE_AP:
 		sdata->u.ap.dtim_period = 2;
 		sdata->u.ap.force_unicast_rateidx = -1;
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-15 14:27:22.706516958 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-15 14:27:31.046516958 +0200
@@ -292,8 +292,7 @@ static int ieee80211_ioctl_add_sta(struc
 
 	sta_info_put(sta);
 
-	if (sdata->type == IEEE80211_IF_TYPE_AP ||
-	    sdata->type == IEEE80211_IF_TYPE_VLAN)
+	if (sdata->type == IEEE80211_IF_TYPE_AP)
 		ieee80211_send_layer2_update(dev, param->sta_addr);
 
 	return 0;
@@ -905,13 +904,6 @@ static int ieee80211_ioctl_add_if(struct
 			__ieee80211_if_del(local, sdata);
 		}
 		return res;
-	case HOSTAP_IF_VLAN:
-		if (left < sizeof(struct hostapd_if_vlan))
-			return -EPROTO;
-
-		res = ieee80211_if_add(dev, param->u.if_info.name, NULL,
-				       IEEE80211_IF_TYPE_VLAN);
-		return res;
 	case HOSTAP_IF_BSS:
 		bss = (struct hostapd_if_bss *) param->u.if_info.data;
 
@@ -947,9 +939,6 @@ static int ieee80211_ioctl_remove_if(str
 	case HOSTAP_IF_WDS:
 		type = IEEE80211_IF_TYPE_WDS;
 		break;
-	case HOSTAP_IF_VLAN:
-		type = IEEE80211_IF_TYPE_VLAN;
-		break;
 	case HOSTAP_IF_BSS:
 		type = IEEE80211_IF_TYPE_AP;
 		break;
@@ -964,38 +953,6 @@ static int ieee80211_ioctl_remove_if(str
 }
 
 
-static int ieee80211_ioctl_set_sta_vlan(struct net_device *dev,
-					struct prism2_hostapd_param *param)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct sta_info *sta;
-
-	sta = sta_info_get(local, param->sta_addr);
-	if (sta) {
-		struct net_device *new_vlan_dev;
-		new_vlan_dev =
-			dev_get_by_name(param->u.set_sta_vlan.vlan_name);
-		if (new_vlan_dev) {
-#if 0
-			printk("%s: Station " MAC_FMT " moved to vlan: %s\n",
-			       dev->name, MAC_ARG(param->sta_addr),
-			       new_vlan_dev->name);
-#endif
-			if (sta->dev != new_vlan_dev) {
-				ieee80211_send_layer2_update(new_vlan_dev,
-							     sta->addr);
-			}
-			sta->dev = new_vlan_dev;
-			sta->vlan_id = param->u.set_sta_vlan.vlan_id;
-			dev_put(new_vlan_dev);
-		}
-		sta_info_put(sta);
-	}
-
-	return sta ? 0 : -ENOENT;
-}
-
-
 static int ieee80211_set_gen_ie(struct net_device *dev, u8 *ie, size_t len)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -1157,9 +1114,6 @@ static int ieee80211_ioctl_priv_hostapd(
 	case PRISM2_HOSTAPD_REMOVE_IF:
 		ret = ieee80211_ioctl_remove_if(dev, param);
 		break;
-	case PRISM2_HOSTAPD_SET_STA_VLAN:
-		ret = ieee80211_ioctl_set_sta_vlan(dev, param);
-		break;
 	case PRISM2_HOSTAPD_SET_CHANNEL_FLAG:
 		ret = ieee80211_ioctl_set_channel_flag(dev, param);
 		break;
@@ -1291,9 +1245,6 @@ static int ieee80211_ioctl_siwmode(struc
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int type;
 
-	if (sdata->type == IEEE80211_IF_TYPE_VLAN)
-		return -EOPNOTSUPP;
-
 	switch (*mode) {
 	case IW_MODE_MASTER:
 		type = IEEE80211_IF_TYPE_AP;
@@ -1349,9 +1300,6 @@ static int ieee80211_ioctl_giwmode(struc
 	case IEEE80211_IF_TYPE_WDS:
 		*mode = IW_MODE_REPEAT;
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
-		*mode = IW_MODE_SECOND;		/* FIXME */
-		break;
 	default:
 		*mode = IW_MODE_AUTO;
 		break;
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-15 14:27:22.776516958 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-15 14:27:31.046516958 +0200
@@ -1319,7 +1319,7 @@ fail:
 
 /**
  * ieee80211_subif_start_xmit - netif start_xmit function for Ethernet-type
- * subinterfaces (wlan#, WDS, and VLAN interfaces)
+ * subinterfaces
  * @skb: packet to be sent
  * @dev: incoming interface
  *
@@ -1363,8 +1363,7 @@ int ieee80211_subif_start_xmit(struct sk
 	/* TODO: handling for 802.1x authorized/unauthorized port */
 	fc = IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA;
 
-	if (likely(sdata->type == IEEE80211_IF_TYPE_AP ||
-		   sdata->type == IEEE80211_IF_TYPE_VLAN)) {
+	if (likely(sdata->type == IEEE80211_IF_TYPE_AP)) {
 		fc |= IEEE80211_FCTL_FROMDS;
 		/* DA BSSID SA */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
--- wireless-dev.orig/net/mac80211/debugfs_sta.c	2007-08-15 14:27:22.836516958 +0200
+++ wireless-dev/net/mac80211/debugfs_sta.c	2007-08-15 14:27:31.046516958 +0200
@@ -62,7 +62,6 @@ static const struct file_operations sta_
 STA_FILE(aid, aid, D);
 STA_FILE(key_idx_compression, key_idx_compression, D);
 STA_FILE(dev, dev->name, S);
-STA_FILE(vlan_id, vlan_id, D);
 STA_FILE(rx_packets, rx_packets, LU);
 STA_FILE(tx_packets, tx_packets, LU);
 STA_FILE(rx_bytes, rx_bytes, LU);
--- wireless-dev.orig/net/mac80211/sta_info.h	2007-08-15 14:27:22.876516958 +0200
+++ wireless-dev/net/mac80211/sta_info.h	2007-08-15 14:27:31.046516958 +0200
@@ -113,8 +113,6 @@ struct sta_info {
 	unsigned int wme_tx_queue[NUM_RX_DATA_QUEUES];
 #endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
 
-	int vlan_id;
-
 	u16 listen_interval;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-15 14:27:22.946516958 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-15 14:27:31.046516958 +0200
@@ -970,9 +970,8 @@ ieee80211_rx_h_data_agg(struct ieee80211
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
@@ -1068,8 +1067,7 @@ ieee80211_rx_h_data(struct ieee80211_txr
 		memcpy(dst, hdr->addr3, ETH_ALEN);
 		memcpy(src, hdr->addr2, ETH_ALEN);
 
-		if (unlikely(sdata->type != IEEE80211_IF_TYPE_AP &&
-			     sdata->type != IEEE80211_IF_TYPE_VLAN)) {
+		if (unlikely(sdata->type != IEEE80211_IF_TYPE_AP)) {
 			if (net_ratelimit())
 				printk(KERN_DEBUG "%s: dropped ToDS frame "
 				       "(BSSID=" MAC_FMT
@@ -1166,8 +1164,8 @@ ieee80211_rx_h_data(struct ieee80211_txr
 	sdata->stats.rx_packets++;
 	sdata->stats.rx_bytes += skb->len;
 
-	if (local->bridge_packets && (sdata->type == IEEE80211_IF_TYPE_AP
-	    || sdata->type == IEEE80211_IF_TYPE_VLAN) && rx->u.rx.ra_match) {
+	if (local->bridge_packets && sdata->type == IEEE80211_IF_TYPE_AP
+	    && rx->u.rx.ra_match) {
 		if (is_multicast_ether_addr(skb->data)) {
 			/* send multicast frames both to higher layers in
 			 * local net stack and back to the wireless media */

-- 


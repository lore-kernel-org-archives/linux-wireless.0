Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32770 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbXHOKiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:38:55 -0400
Subject: [PATCH] mac80211: remove VLAN stuff
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 00:58:50 +0200
Message-Id: <1187132330.31200.22.camel@johannes.berg>
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
Applies after the RFC filter flags patch, but it shouldn't matter too
much, haven't tested inverting the order.

 include/net/mac80211.h         |    2 -
 net/mac80211/debugfs_netdev.c  |   27 -------------------------
 net/mac80211/debugfs_sta.c     |    1 
 net/mac80211/hostapd_ioctl.h   |    7 ------
 net/mac80211/ieee80211.c       |    9 --------
 net/mac80211/ieee80211_i.h     |   12 -----------
 net/mac80211/ieee80211_iface.c |    2 -
 net/mac80211/ieee80211_ioctl.c |   44 -----------------------------------------
 net/mac80211/sta_info.h        |    2 -
 net/mac80211/tx.c              |    5 +---
 10 files changed, 5 insertions(+), 106 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-15 00:25:18.830200043 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-15 00:31:56.080200043 +0200
@@ -146,12 +146,7 @@ static inline int identical_mac_addr_all
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
 
 static int ieee80211_open(struct net_device *dev)
@@ -189,7 +184,6 @@ static int ieee80211_open(struct net_dev
 	}
 
 	switch (sdata->type) {
-	/* XXX: handle VLANs specially and not bother drivers */
 	case IEEE80211_IF_TYPE_MNTR:
 		if (!local->monitors) {
 			set_local_flag(local, FIF_CONTROL, &change);
@@ -259,7 +253,6 @@ static int ieee80211_stop(struct net_dev
 	local->open_count--;
 
 	switch (sdata->type) {
-	/* XXX: handle VLANs specially and not bother drivers */
 	case IEEE80211_IF_TYPE_MNTR:
 		local->monitors--;
 
--- wireless-dev.orig/include/net/mac80211.h	2007-08-15 00:23:09.730200043 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-15 00:31:56.080200043 +0200
@@ -311,7 +311,6 @@ struct ieee80211_conf {
  * @IEEE80211_IF_TYPE_IBSS: interface in IBSS (ad-hoc) mode.
  * @IEEE80211_IF_TYPE_MNTR: interface in monitor (rfmon) mode.
  * @IEEE80211_IF_TYPE_WDS: interface in WDS mode.
- * @IEEE80211_IF_TYPE_VLAN: not used.
  */
 enum ieee80211_if_types {
 	IEEE80211_IF_TYPE_NONE = -1,
@@ -320,7 +319,6 @@ enum ieee80211_if_types {
 	IEEE80211_IF_TYPE_IBSS = 0x00000003,
 	IEEE80211_IF_TYPE_MNTR = 0x00000004,
 	IEEE80211_IF_TYPE_WDS = 0x5A580211,
-	IEEE80211_IF_TYPE_VLAN = 0x00080211,
 };
 
 /**
--- wireless-dev.orig/net/mac80211/debugfs_netdev.c	2007-08-15 00:23:09.320200043 +0200
+++ wireless-dev/net/mac80211/debugfs_netdev.c	2007-08-15 00:31:56.080200043 +0200
@@ -422,9 +422,6 @@ __IEEE80211_IF_FILE(beacon_tail_len);
 /* WDS attributes */
 IEEE80211_IF_FILE(peer, u.wds.remote_addr, MAC);
 
-/* VLAN attributes */
-IEEE80211_IF_FILE(vlan_id, u.vlan.id, DEC);
-
 #define DEBUGFS_ADD(name, type)\
 	sdata->debugfs.type.name = debugfs_create_file(#name, 0444,\
 		sdata->debugfsdir, sdata, &name##_ops);
@@ -517,15 +514,6 @@ static void add_wds_files(struct ieee802
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
 }
@@ -549,9 +537,6 @@ static void add_files(struct ieee80211_s
 	case IEEE80211_IF_TYPE_MNTR:
 		add_monitor_files(sdata);
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
-		add_vlan_files(sdata);
-		break;
 	default:
 		break;
 	}
@@ -645,15 +630,6 @@ static void del_wds_files(struct ieee802
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
 }
@@ -677,9 +653,6 @@ static void del_files(struct ieee80211_s
 	case IEEE80211_IF_TYPE_MNTR:
 		del_monitor_files(sdata);
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
-		del_vlan_files(sdata);
-		break;
 	default:
 		break;
 	}
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-15 00:23:09.430200043 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-15 00:33:44.880200043 +0200
@@ -57,7 +57,6 @@ enum {
 	PRISM2_HOSTAPD_SET_BEACON = 1001,
 	PRISM2_HOSTAPD_GET_HW_FEATURES = 1002,
 	PRISM2_HOSTAPD_SET_RATE_SETS = 1005,
-	PRISM2_HOSTAPD_SET_STA_VLAN = 1010,
 	PRISM2_HOSTAPD_SET_CHANNEL_FLAG = 1012,
 	PRISM2_HOSTAPD_SET_REGULATORY_DOMAIN = 1013,
 	PRISM2_HOSTAPD_SET_TX_QUEUE_PARAMS = 1014,
@@ -131,15 +130,11 @@ struct prism2_hostapd_param {
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
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-15 00:23:09.450200043 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-15 00:34:56.320200043 +0200
@@ -230,10 +230,6 @@ struct ieee80211_if_wds {
 	struct sta_info *sta;
 };
 
-struct ieee80211_if_vlan {
-	u8 id;
-};
-
 struct ieee80211_if_sta {
 	enum {
 		IEEE80211_DISABLED, IEEE80211_AUTHENTICATE,
@@ -342,7 +338,6 @@ struct ieee80211_sub_if_data {
 	union {
 		struct ieee80211_if_ap ap;
 		struct ieee80211_if_wds wds;
-		struct ieee80211_if_vlan vlan;
 		struct ieee80211_if_sta sta;
 	} u;
 	int channel_use;
@@ -427,13 +422,6 @@ struct ieee80211_sub_if_data {
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
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-08-15 00:23:09.510200043 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-08-15 00:33:21.690200043 +0200
@@ -111,8 +111,6 @@ void ieee80211_if_set_type(struct net_de
 	case IEEE80211_IF_TYPE_WDS:
 		sdata->bss = NULL;
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
-		break;
 	case IEEE80211_IF_TYPE_AP:
 		sdata->u.ap.dtim_period = 2;
 		sdata->u.ap.force_unicast_rateidx = -1;
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-15 00:23:09.540200043 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-15 00:33:55.170200043 +0200
@@ -292,8 +292,7 @@ static int ieee80211_ioctl_add_sta(struc
 
 	sta_info_put(sta);
 
-	if (sdata->type == IEEE80211_IF_TYPE_AP ||
-	    sdata->type == IEEE80211_IF_TYPE_VLAN)
+	if (sdata->type == IEEE80211_IF_TYPE_AP)
 		ieee80211_send_layer2_update(dev, param->sta_addr);
 
 	return 0;
@@ -870,38 +869,6 @@ static int ieee80211_ioctl_set_rate_sets
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
@@ -1057,9 +1024,6 @@ static int ieee80211_ioctl_priv_hostapd(
 	case PRISM2_HOSTAPD_SET_RATE_SETS:
 		ret = ieee80211_ioctl_set_rate_sets(dev, param, p->length);
 		break;
-	case PRISM2_HOSTAPD_SET_STA_VLAN:
-		ret = ieee80211_ioctl_set_sta_vlan(dev, param);
-		break;
 	case PRISM2_HOSTAPD_SET_CHANNEL_FLAG:
 		ret = ieee80211_ioctl_set_channel_flag(dev, param);
 		break;
@@ -1191,9 +1155,6 @@ static int ieee80211_ioctl_siwmode(struc
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int type;
 
-	if (sdata->type == IEEE80211_IF_TYPE_VLAN)
-		return -EOPNOTSUPP;
-
 	switch (*mode) {
 	case IW_MODE_MASTER:
 		type = IEEE80211_IF_TYPE_AP;
@@ -1249,9 +1210,6 @@ static int ieee80211_ioctl_giwmode(struc
 	case IEEE80211_IF_TYPE_WDS:
 		*mode = IW_MODE_REPEAT;
 		break;
-	case IEEE80211_IF_TYPE_VLAN:
-		*mode = IW_MODE_SECOND;		/* FIXME */
-		break;
 	default:
 		*mode = IW_MODE_AUTO;
 		break;
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-15 00:23:09.600200043 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-15 00:31:56.090200043 +0200
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
--- wireless-dev.orig/net/mac80211/debugfs_sta.c	2007-08-15 00:33:59.880200043 +0200
+++ wireless-dev/net/mac80211/debugfs_sta.c	2007-08-15 00:34:02.930200043 +0200
@@ -62,7 +62,6 @@ static const struct file_operations sta_
 STA_FILE(aid, aid, D);
 STA_FILE(key_idx_compression, key_idx_compression, D);
 STA_FILE(dev, dev->name, S);
-STA_FILE(vlan_id, vlan_id, D);
 STA_FILE(rx_packets, rx_packets, LU);
 STA_FILE(tx_packets, tx_packets, LU);
 STA_FILE(rx_bytes, rx_bytes, LU);
--- wireless-dev.orig/net/mac80211/sta_info.h	2007-08-15 00:34:41.530200043 +0200
+++ wireless-dev/net/mac80211/sta_info.h	2007-08-15 00:34:44.340200043 +0200
@@ -113,8 +113,6 @@ struct sta_info {
 	unsigned int wme_tx_queue[NUM_RX_DATA_QUEUES];
 #endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
 
-	int vlan_id;
-
 	u16 listen_interval;
 
 #ifdef CONFIG_MAC80211_DEBUGFS



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42869 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbXIFNqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:46:31 -0400
Message-Id: <20070905234623.197117000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 04/21] mac80211: validate VLAN interfaces better
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes mac80211 to verify that VLAN interfaces
are valid and not bother drivers about them any more.
VLAN interfaces are now only valid when an AP interface
is up with the same MAC address, and are automatically
turned off when the AP interface is set down.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>

---
Changes since v1:
 * tested manually via nl80211
 * fixed bug: typo in the list iteration leading to oopses
 * fixed bug: open_count must be decremented after removing vlans

 include/net/mac80211.h         |   17 ++++++------
 net/mac80211/debugfs_netdev.c  |    5 ---
 net/mac80211/ieee80211.c       |   54 +++++++++++++++++++++++++++++++++++------
 net/mac80211/ieee80211_cfg.c   |    3 ++
 net/mac80211/ieee80211_i.h     |    6 +++-
 net/mac80211/ieee80211_iface.c |    5 +++
 6 files changed, 68 insertions(+), 22 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-09-06 01:35:12.344453431 +0200
+++ wireless-dev/include/net/mac80211.h	2007-09-06 01:35:13.764453431 +0200
@@ -346,16 +346,17 @@ struct ieee80211_conf {
  * @IEEE80211_IF_TYPE_IBSS: interface in IBSS (ad-hoc) mode.
  * @IEEE80211_IF_TYPE_MNTR: interface in monitor (rfmon) mode.
  * @IEEE80211_IF_TYPE_WDS: interface in WDS mode.
- * @IEEE80211_IF_TYPE_VLAN: not used.
+ * @IEEE80211_IF_TYPE_VLAN: VLAN interface bound to an AP, drivers
+ *	will never see this type.
  */
 enum ieee80211_if_types {
-	IEEE80211_IF_TYPE_AP = 0x00000000,
-	IEEE80211_IF_TYPE_MGMT = 0x00000001,
-	IEEE80211_IF_TYPE_STA = 0x00000002,
-	IEEE80211_IF_TYPE_IBSS = 0x00000003,
-	IEEE80211_IF_TYPE_MNTR = 0x00000004,
-	IEEE80211_IF_TYPE_WDS = 0x5A580211,
-	IEEE80211_IF_TYPE_VLAN = 0x00080211,
+	IEEE80211_IF_TYPE_AP,
+	IEEE80211_IF_TYPE_MGMT,
+	IEEE80211_IF_TYPE_STA,
+	IEEE80211_IF_TYPE_IBSS,
+	IEEE80211_IF_TYPE_MNTR,
+	IEEE80211_IF_TYPE_WDS,
+	IEEE80211_IF_TYPE_VLAN,
 };
 
 /**
--- wireless-dev.orig/net/mac80211/ieee80211_cfg.c	2007-09-06 01:34:58.704453431 +0200
+++ wireless-dev/net/mac80211/ieee80211_cfg.c	2007-09-06 01:35:13.764453431 +0200
@@ -34,6 +34,9 @@ static int ieee80211_add_iface(struct wi
 	case NL80211_IFTYPE_AP:
 		itype = IEEE80211_IF_TYPE_AP;
 		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		itype = IEEE80211_IF_TYPE_VLAN;
+		break;
 	case NL80211_IFTYPE_WDS:
 		itype = IEEE80211_IF_TYPE_WDS;
 		break;
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-06 01:35:12.364453431 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-06 01:35:13.774453431 +0200
@@ -429,22 +429,43 @@ static int ieee80211_open(struct net_dev
 	int res;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	read_lock(&local->sub_if_lock);
 	list_for_each_entry(nsdata, &local->sub_if_list, list) {
 		struct net_device *ndev = nsdata->dev;
 
 		if (ndev != dev && ndev != local->mdev && netif_running(ndev) &&
-		    compare_ether_addr(dev->dev_addr, ndev->dev_addr) == 0 &&
-		    !identical_mac_addr_allowed(sdata->type, nsdata->type)) {
-			read_unlock(&local->sub_if_lock);
-			return -ENOTUNIQ;
+		    compare_ether_addr(dev->dev_addr, ndev->dev_addr) == 0) {
+			/*
+			 * check whether it may have the same address
+			 */
+			if (!identical_mac_addr_allowed(sdata->type,
+							nsdata->type)) {
+				read_unlock(&local->sub_if_lock);
+				return -ENOTUNIQ;
+			}
+
+			/*
+			 * can only add VLANs to enabled APs
+			 */
+			if (sdata->type == IEEE80211_IF_TYPE_VLAN &&
+			    nsdata->type == IEEE80211_IF_TYPE_AP &&
+			    netif_running(nsdata->dev))
+				sdata->u.vlan.ap = nsdata;
 		}
 	}
 	read_unlock(&local->sub_if_lock);
 
-	if (sdata->type == IEEE80211_IF_TYPE_WDS &&
-	    is_zero_ether_addr(sdata->u.wds.remote_addr))
-		return -ENOLINK;
+	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_WDS:
+		if (is_zero_ether_addr(sdata->u.wds.remote_addr))
+			return -ENOLINK;
+		break;
+	case IEEE80211_IF_TYPE_VLAN:
+		if (!sdata->u.vlan.ap)
+			return -ENOLINK;
+		break;
+	}
 
 	if (local->open_count == 0) {
 		res = 0;
@@ -455,6 +476,10 @@ static int ieee80211_open(struct net_dev
 	}
 
 	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_VLAN:
+		list_add(&sdata->u.vlan.list, &sdata->u.vlan.ap->u.ap.vlans);
+		/* no need to tell driver */
+		break;
 	case IEEE80211_IF_TYPE_MNTR:
 		/* must be before the call to ieee80211_configure_filter */
 		local->monitors++;
@@ -518,9 +543,24 @@ static int ieee80211_stop(struct net_dev
 
 	netif_stop_queue(dev);
 
+	/* down all dependent devices, that is VLANs */
+	if (sdata->type == IEEE80211_IF_TYPE_AP) {
+		struct ieee80211_sub_if_data *vlan, *tmp;
+
+		list_for_each_entry_safe(vlan, tmp, &sdata->u.ap.vlans,
+					 u.vlan.list)
+			dev_close(vlan->dev);
+		WARN_ON(!list_empty(&sdata->u.ap.vlans));
+	}
+
 	local->open_count--;
 
 	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_VLAN:
+		list_del(&sdata->u.vlan.list);
+		sdata->u.vlan.ap = NULL;
+		/* no need to tell driver */
+		break;
 	case IEEE80211_IF_TYPE_MNTR:
 		local->monitors--;
 		if (local->monitors == 0) {
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-09-06 01:35:12.364453431 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-09-06 01:35:13.774453431 +0200
@@ -215,6 +215,8 @@ struct ieee80211_if_ap {
 	u8 *beacon_head, *beacon_tail;
 	int beacon_head_len, beacon_tail_len;
 
+	struct list_head vlans;
+
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
 	u8 *generic_elem;
@@ -238,7 +240,8 @@ struct ieee80211_if_wds {
 };
 
 struct ieee80211_if_vlan {
-	u8 id;
+	struct ieee80211_sub_if_data *ap;
+	struct list_head list;
 };
 
 /* flags used in struct ieee80211_if_sta.flags */
@@ -450,7 +453,6 @@ struct ieee80211_sub_if_data {
 			struct dentry *drop_unencrypted;
 			struct dentry *eapol;
 			struct dentry *ieee8021_x;
-			struct dentry *vlan_id;
 		} vlan;
 		struct {
 			struct dentry *mode;
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-09-06 01:34:58.794453431 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-09-06 01:35:13.774453431 +0200
@@ -164,6 +164,7 @@ void ieee80211_if_set_type(struct net_de
 		sdata->bss = NULL;
 		break;
 	case IEEE80211_IF_TYPE_VLAN:
+		sdata->u.vlan.ap = NULL;
 		break;
 	case IEEE80211_IF_TYPE_AP:
 		sdata->u.ap.dtim_period = 2;
@@ -171,6 +172,7 @@ void ieee80211_if_set_type(struct net_de
 		sdata->u.ap.max_ratectrl_rateidx = -1;
 		skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
 		sdata->bss = &sdata->u.ap;
+		INIT_LIST_HEAD(&sdata->u.ap.vlans);
 		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS: {
@@ -300,6 +302,9 @@ void ieee80211_if_reinit(struct net_devi
 	case IEEE80211_IF_TYPE_MNTR:
 		dev->type = ARPHRD_ETHER;
 		break;
+	case IEEE80211_IF_TYPE_VLAN:
+		sdata->u.vlan.ap = NULL;
+		break;
 	}
 
 	/* remove all STAs that are bound to this virtual interface */
--- wireless-dev.orig/net/mac80211/debugfs_netdev.c	2007-09-06 01:35:12.374453431 +0200
+++ wireless-dev/net/mac80211/debugfs_netdev.c	2007-09-06 01:35:13.774453431 +0200
@@ -422,9 +422,6 @@ __IEEE80211_IF_FILE(beacon_tail_len);
 /* WDS attributes */
 IEEE80211_IF_FILE(peer, u.wds.remote_addr, MAC);
 
-/* VLAN attributes */
-IEEE80211_IF_FILE(vlan_id, u.vlan.id, DEC);
-
 #define DEBUGFS_ADD(name, type)\
 	sdata->debugfs.type.name = debugfs_create_file(#name, 0444,\
 		sdata->debugfsdir, sdata, &name##_ops);
@@ -523,7 +520,6 @@ static void add_vlan_files(struct ieee80
 	DEBUGFS_ADD(drop_unencrypted, vlan);
 	DEBUGFS_ADD(eapol, vlan);
 	DEBUGFS_ADD(ieee8021_x, vlan);
-	DEBUGFS_ADD(vlan_id, vlan);
 }
 
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
@@ -651,7 +647,6 @@ static void del_vlan_files(struct ieee80
 	DEBUGFS_DEL(drop_unencrypted, vlan);
 	DEBUGFS_DEL(eapol, vlan);
 	DEBUGFS_DEL(ieee8021_x, vlan);
-	DEBUGFS_DEL(vlan_id, vlan);
 }
 
 static void del_monitor_files(struct ieee80211_sub_if_data *sdata)

-- 


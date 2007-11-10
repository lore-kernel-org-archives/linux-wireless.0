Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:46272 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbXKJC04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 21:26:56 -0500
Received: by wa-out-1112.google.com with SMTP id v27so794974wah
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2007 18:26:55 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 9 Nov 2007 17:22:39 -0800
Subject: [PATCH 3/4] o80211s: (mac80211s) basic mesh interface support
Message-ID: <473516ee.26d7720a.3f57.ffff8233@mx.google.com> (sfid-20071110_022658_985099_309C7497)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit introduces mesh interface support for the mac80211 stack. It
provides support for pre-802.11s frame format, static unicast forwarding, mesh
beaconing, mesh statistics through debugfs.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 include/net/mac80211.h         |    3 +
 net/mac80211/Makefile          |    1 +
 net/mac80211/cfg.c             |   27 +++++++
 net/mac80211/debugfs_netdev.c  |   36 +++++++++
 net/mac80211/ieee80211.c       |   17 ++++-
 net/mac80211/ieee80211_i.h     |   18 ++++-
 net/mac80211/ieee80211_iface.c |   11 +++
 net/mac80211/ieee80211_sta.c   |  120 ++++++++++++++++++++++++++++-
 net/mac80211/ieee80211s.h      |   50 ++++++++++++
 net/mac80211/mesh_pathtbl.c    |  169 ++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c              |   66 +++++++++++++++-
 net/mac80211/tx.c              |   38 +++++++++-
 net/mac80211/util.c            |   41 ++++++++++
 13 files changed, 590 insertions(+), 7 deletions(-)
 create mode 100644 net/mac80211/ieee80211s.h
 create mode 100644 net/mac80211/mesh_pathtbl.c

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 17b6039..14123df 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -474,6 +474,7 @@ enum ieee80211_if_types {
 	IEEE80211_IF_TYPE_AP,
 	IEEE80211_IF_TYPE_STA,
 	IEEE80211_IF_TYPE_IBSS,
+	IEEE80211_IF_TYPE_MESH,
 	IEEE80211_IF_TYPE_MNTR,
 	IEEE80211_IF_TYPE_WDS,
 	IEEE80211_IF_TYPE_VLAN,
@@ -521,6 +522,8 @@ struct ieee80211_if_init_conf {
  *	config_interface() call, so copy the value somewhere if you need
  *	it.
  * @ssid_len: length of the @ssid field.
+ * @mesh_id: mesh ID of the mesh network we will be part of.
+ * @mesh_id_len: length of the @mesh_id field.
  * @beacon: beacon template. Valid only if @host_gen_beacon_template in
  *	&struct ieee80211_hw is set. The driver is responsible of freeing
  *	the sk_buff.
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 1e6237b..fcf80ec 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -24,4 +24,5 @@ mac80211-objs := \
 	key.o \
 	util.o \
 	event.o \
+	mesh_pathtbl.o \
 	$(mac80211-objs-y)
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9e2bc1f..24f8086 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -25,6 +25,8 @@ nl80211_type_to_mac80211_type(enum nl80211_iftype type)
 		return IEEE80211_IF_TYPE_STA;
 	case NL80211_IFTYPE_MONITOR:
 		return IEEE80211_IF_TYPE_MNTR;
+	case NL80211_IFTYPE_MESH:
+		return IEEE80211_IF_TYPE_MESH;
 	default:
 		return IEEE80211_IF_TYPE_INVALID;
 	}
@@ -99,8 +101,33 @@ static int ieee80211_change_iface(struct wiphy *wiphy, int ifindex,
 	return 0;
 }
 
+static int ieee80211_if_set_mesh_cfg(struct wiphy *wiphy,
+		struct net_device *dev, struct mesh_params *params)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_if_sta *ifsta;
+	struct ieee80211_sub_if_data *sdata = NULL;
+	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
+		return -ENODEV;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (sdata->type != IEEE80211_IF_TYPE_MESH)
+		return -EINVAL;
+
+	ifsta = &sdata->u.sta;
+	ifsta->mesh_id_len = params->mesh_id_len;
+	if (params->mesh_id_len)
+		memcpy(ifsta->mesh_id, params->mesh_id, params->mesh_id_len);
+
+	/* If the iface is down, it will be configure when it is opened */
+	if (netif_running(dev))
+		ieee80211_if_config(dev);
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
 	.change_virtual_intf = ieee80211_change_iface,
+	.set_mesh_cfg = ieee80211_if_set_mesh_cfg,
 };
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index f0e6ab7..e93b6bd 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -162,6 +162,10 @@ __IEEE80211_IF_FILE(beacon_tail_len);
 /* WDS attributes */
 IEEE80211_IF_FILE(peer, u.wds.remote_addr, MAC);
 
+/* Mesh stats attributes */
+IEEE80211_IF_FILE(fwded_frames, u.sta.mshstats.fwded_frames, DEC);
+IEEE80211_IF_FILE(dropped_frames_ttl, u.sta.mshstats.dropped_frames_ttl, DEC);
+
 #define DEBUGFS_ADD(name, type)\
 	sdata->debugfs.type.name = debugfs_create_file(#name, 0444,\
 		sdata->debugfsdir, sdata, &name##_ops);
@@ -226,12 +230,27 @@ static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
 {
 }
 
+#define MESHSTATS_ADD(name)\
+	sdata->mesh_stats.name = debugfs_create_file(#name, 0444,\
+		sdata->mesh_stats_dir, sdata, &name##_ops);
+
+static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
+{
+	sdata->mesh_stats_dir = debugfs_create_dir("mesh_stats",
+				sdata->debugfsdir);
+	MESHSTATS_ADD(fwded_frames);
+	MESHSTATS_ADD(dropped_frames_ttl);
+}
+
 static void add_files(struct ieee80211_sub_if_data *sdata)
 {
 	if (!sdata->debugfsdir)
 		return;
 
 	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_MESH:
+		add_mesh_stats(sdata);
+		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		add_sta_files(sdata);
@@ -319,12 +338,29 @@ static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
 {
 }
 
+#define MESHSTATS_DEL(name)			\
+	do {						\
+		debugfs_remove(sdata->mesh_stats.name);	\
+		sdata->mesh_stats.name = NULL;		\
+	} while (0)
+
+static void del_mesh_stats(struct ieee80211_sub_if_data *sdata)
+{
+	MESHSTATS_DEL(fwded_frames);
+	MESHSTATS_DEL(dropped_frames_ttl);
+	debugfs_remove(sdata->mesh_stats_dir);
+	sdata->mesh_stats_dir = NULL;
+}
+
 static void del_files(struct ieee80211_sub_if_data *sdata, int type)
 {
 	if (!sdata->debugfsdir)
 		return;
 
 	switch (type) {
+	case IEEE80211_IF_TYPE_MESH:
+		del_mesh_stats(sdata);
+		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		del_sta_files(sdata);
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index e0ee65a..1c9cf22 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -26,6 +26,7 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
+#include "ieee80211s.h"
 #include "wep.h"
 #include "wme.h"
 #include "aes_ccm.h"
@@ -126,9 +127,15 @@ static void ieee80211_master_set_multicast_list(struct net_device *dev)
 
 static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 {
+	int meshhdrlen;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	meshhdrlen = (sdata->type == IEEE80211_IF_TYPE_MESH) ? 5 : 0;
+
 	/* FIX: what would be proper limits for MTU?
 	 * This interface uses 802.3 frames. */
-	if (new_mtu < 256 || new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6) {
+	if (new_mtu < 256 ||
+		new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6 - meshhdrlen) {
 		printk(KERN_WARNING "%s: invalid MTU %d\n",
 		       dev->name, new_mtu);
 		return -EINVAL;
@@ -202,6 +209,7 @@ static int ieee80211_open(struct net_device *dev)
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_MNTR:
 	case IEEE80211_IF_TYPE_IBSS:
+	case IEEE80211_IF_TYPE_MESH:
 		/* no special treatment */
 		break;
 	case IEEE80211_IF_TYPE_INVALID:
@@ -465,6 +473,11 @@ static int __ieee80211_if_config(struct net_device *dev,
 		conf.bssid = sdata->u.sta.bssid;
 		conf.ssid = sdata->u.sta.ssid;
 		conf.ssid_len = sdata->u.sta.ssid_len;
+	} else if (sdata->type == IEEE80211_IF_TYPE_MESH) {
+		/* SSID is wildcard (all 0s) */
+		ieee80211_set_mesh_beacon_template(dev, &conf);
+		local->hw.flags |= IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
+		ieee80211_start_mesh(dev);
 	} else if (sdata->type == IEEE80211_IF_TYPE_AP) {
 		conf.ssid = sdata->u.ap.ssid;
 		conf.ssid_len = sdata->u.ap.ssid_len;
@@ -1262,6 +1275,8 @@ static void __exit ieee80211_exit(void)
 	ieee80211_rate_control_unregister(&mac80211_rcsimple);
 #endif
 
+	if (mesh_allocated)
+		mesh_pathtbl_unregister();
 	ieee80211_wme_unregister();
 	ieee80211_debugfs_netdev_exit();
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b4e32ab..c25de0e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -25,6 +25,7 @@
 #include <net/wireless.h>
 #include "ieee80211_key.h"
 #include "sta_info.h"
+#include "ieee80211s.h"
 
 /* ieee80211.o internal definitions, etc. These are not included into
  * low-level drivers. */
@@ -235,13 +236,16 @@ struct ieee80211_if_sta {
 	enum {
 		IEEE80211_DISABLED, IEEE80211_AUTHENTICATE,
 		IEEE80211_ASSOCIATE, IEEE80211_ASSOCIATED,
-		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED
+		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED,
+		IEEE80211_MESH
 	} state;
 	struct timer_list timer;
 	struct work_struct work;
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
+	u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
+	size_t mesh_id_len;
 	u16 aid;
 	u16 ap_capab, capab;
 	u8 *extra_ie; /* to be added to the end of AssocReq */
@@ -274,6 +278,8 @@ struct ieee80211_if_sta {
 	u32 supp_rates_bits;
 
 	int wmm_last_param_set;
+	struct mesh_stats mshstats;
+	atomic_t mesh_seqnum;
 };
 
 
@@ -384,6 +390,12 @@ struct ieee80211_sub_if_data {
 		} monitor;
 		struct dentry *default_key;
 	} debugfs;
+
+	struct dentry *mesh_stats_dir;
+	struct {
+		struct dentry *fwded_frames;
+		struct dentry *dropped_frames_ttl;
+	} mesh_stats;
 #endif
 };
 
@@ -759,6 +771,10 @@ int ieee80211_sta_deauthenticate(struct net_device *dev, u16 reason);
 int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
 void ieee80211_erp_info_change_notify(struct net_device *dev, u8 changes);
 void ieee80211_reset_erp_info(struct net_device *dev);
+void ieee80211_start_mesh(struct net_device *dev);
+int ieee80211_set_mesh_beacon_template(struct net_device *dev,
+				       struct ieee80211_if_conf *conf);
+
 
 /* ieee80211_iface.c */
 int ieee80211_if_add(struct net_device *dev, const char *name,
diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
index 43e505d..b9f02f5 100644
--- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -15,6 +15,7 @@
 #include "ieee80211_i.h"
 #include "sta_info.h"
 #include "debugfs_netdev.h"
+#include "ieee80211s.h"
 
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata)
 {
@@ -134,6 +135,15 @@ void ieee80211_if_set_type(struct net_device *dev, int type)
 		sdata->bss = &sdata->u.ap;
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
 		break;
+	case IEEE80211_IF_TYPE_MESH:
+		if (!mesh_allocated) {
+			/* Allocate all mesh structures when creating the first
+			 * mesh interface.
+			 */
+			mesh_pathtbl_init();
+			mesh_allocated = 1;
+		}
+		/* fall thru */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS: {
 		struct ieee80211_sub_if_data *msdata;
@@ -232,6 +242,7 @@ void ieee80211_if_reinit(struct net_device *dev)
 		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
+	case IEEE80211_IF_TYPE_MESH:
 		kfree(sdata->u.sta.extra_ie);
 		sdata->u.sta.extra_ie = NULL;
 		kfree(sdata->u.sta.assocreq_ies);
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 2079e98..89fb06e 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -37,6 +37,7 @@
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
 #define IEEE80211_MONITORING_INTERVAL (2 * HZ)
+#define IEEE80211_MESH_EXPIRATION_INTERVAL (2 * HZ)
 #define IEEE80211_PROBE_INTERVAL (60 * HZ)
 #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)
 #define IEEE80211_SCAN_INTERVAL (2 * HZ)
@@ -759,6 +760,26 @@ static void ieee80211_associate(struct net_device *dev,
 }
 
 
+static void ieee80211_mesh_housekeeping(struct net_device *dev,
+			   struct ieee80211_if_sta *ifsta)
+{
+	/* TODO: check for expired neighbors, paths and frames to non resolved
+	 * hw addresses
+	 */
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_MESH_EXPIRATION_INTERVAL);
+}
+
+
+void ieee80211_start_mesh(struct net_device *dev)
+{
+	struct ieee80211_if_sta *ifsta;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	ifsta = &sdata->u.sta;
+	ifsta->state = IEEE80211_MESH;
+	ieee80211_sta_timer((unsigned long)sdata);
+}
+
+
 static void ieee80211_associated(struct net_device *dev,
 				 struct ieee80211_if_sta *ifsta)
 {
@@ -1989,7 +2010,8 @@ void ieee80211_sta_work(struct work_struct *work)
 		return;
 
 	if (sdata->type != IEEE80211_IF_TYPE_STA &&
-	    sdata->type != IEEE80211_IF_TYPE_IBSS) {
+	    sdata->type != IEEE80211_IF_TYPE_IBSS &&
+	    sdata->type != IEEE80211_IF_TYPE_MESH) {
 		printk(KERN_DEBUG "%s: ieee80211_sta_work: non-STA interface "
 		       "(type=%d)\n", dev->name, sdata->type);
 		return;
@@ -2031,6 +2053,9 @@ void ieee80211_sta_work(struct work_struct *work)
 	case IEEE80211_IBSS_JOINED:
 		ieee80211_sta_merge_ibss(dev, ifsta);
 		break;
+	case IEEE80211_MESH:
+		ieee80211_mesh_housekeeping(dev, ifsta);
+		break;
 	default:
 		printk(KERN_DEBUG "ieee80211_sta_work: Unknown state %d\n",
 		       ifsta->state);
@@ -2196,6 +2221,96 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 	return -1;
 }
 
+
+int ieee80211_set_mesh_beacon_template(struct net_device *dev,
+				       struct ieee80211_if_conf *conf)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
+	struct ieee80211_hw_mode *mode = local->oper_hw_mode;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_mgmt *mgmt;
+	u8 *pos;
+	int rates, i;
+
+	if (!skb)
+		return -1;
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *)
+		skb_put(skb, 24 + sizeof(mgmt->u.beacon));
+	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
+	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+					   IEEE80211_STYPE_BEACON);
+	memset(mgmt->da, 0xff, ETH_ALEN);
+	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	/* SSID is left zeroed, wildcard value */
+	mgmt->u.beacon.beacon_int =
+		cpu_to_le16(local->hw.conf.beacon_int);
+	mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
+
+	pos = skb_put(skb, 2);
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = 0x0;
+
+	rates = mode->num_rates;
+	if (rates > 8)
+		rates = 8;
+	pos = skb_put(skb, 2 + rates);
+	*pos++ = WLAN_EID_SUPP_RATES;
+	*pos++ = rates;
+	for (i = 0; i < rates; i++) {
+		int rate = mode->rates[i].rate;
+		*pos++ = (u8) (rate / 5);
+	}
+
+	if (mode->num_rates > 8) {
+		rates = mode->num_rates - 8;
+		pos = skb_put(skb, 2 + rates);
+		*pos++ = WLAN_EID_EXT_SUPP_RATES;
+		*pos++ = rates;
+		for (i = 0; i < rates; i++) {
+			int rate = mode->rates[i+8].rate;
+			*pos++ = (u8) (rate / 5);
+		}
+	}
+
+	pos = skb_put(skb, 17);
+	*pos++ = WLAN_EID_MESH_CONFIG;
+	*pos++ = 15;
+	/* Version */
+	*pos++ = 1;
+
+	/* Active path selection protocol ID */
+	*pos++ = 0x00; /* 3 byte OUI:        */
+	*pos++ = 0x0f; /* All other OUIs are */
+	*pos++ = 0xac; /* vendor specific.   */
+	*pos++ = 0xff; /* Null protocol.     */
+
+	/* Active path selection metric ID   */
+	*pos++ = 0x00; /* 3 byte OUI */
+	*pos++ = 0x0f;
+	*pos++ = 0xac;
+	*pos++ = 0xff; /* Null metric */
+	/* Channel precedence:
+	 * Not running simple channel unification protocol
+	 */
+	memset(pos, 0x00, 4);
+	pos += 4;
+	/* Mesh capability */
+	memset(pos, 0x00, 2);
+
+	pos = skb_put(skb, 2 + sdata->u.sta.mesh_id_len);
+	*pos++ = WLAN_EID_MESH_ID;
+	*pos++ = sdata->u.sta.mesh_id_len;
+	if (sdata->u.sta.mesh_id_len)
+		memcpy(pos, sdata->u.sta.mesh_id, sdata->u.sta.mesh_id_len);
+
+	conf->beacon = skb;
+	return 0;
+}
+
+
 static int ieee80211_sta_join_ibss(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_sta_bss *bss)
@@ -2674,6 +2789,9 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 			ieee80211_sta_timer((unsigned long)sdata);
 		}
 
+		if (sdata->type == IEEE80211_IF_TYPE_MESH)
+			ieee80211_sta_timer((unsigned long)sdata);
+
 		netif_wake_queue(sdata->dev);
 	}
 	rcu_read_unlock();
diff --git a/net/mac80211/ieee80211s.h b/net/mac80211/ieee80211s.h
new file mode 100644
index 0000000..dcb32be
--- /dev/null
+++ b/net/mac80211/ieee80211s.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright (c) 2007 open80211s Ltd.
+ * Authors :   Luis Carlos Cobo <luisca@cozybit.com>
+ *             Javier Cardona <javier@cozybit.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef IEEE80211S_H
+#define IEEE80211S_H
+
+#include <linux/types.h>
+
+extern int mesh_allocated;
+
+/* Data structures */
+struct ieee80211s_hdr {
+	u8 flags;
+	u8 ttl;
+	u8 seqnum[3];
+	u8 eaddr1[6];
+	u8 eaddr2[6];
+	u8 eaddr3[6];
+} __attribute__ ((packed));
+
+struct mesh_stats {
+	__u32 fwded_frames;		/* Mesh forwarded frames */
+	__u32 dropped_frames_ttl;	/* Not forwarded since mesh_ttl == 0 */
+};
+
+
+/* Public interfaces */
+int ieee80211s_nh_lookup(u8 *dst, u8 *next_hop);
+int ieee80211s_start(void);
+void ieee80211s_stop(void);
+void mesh_pathtbl_init(void);
+void mesh_pathtbl_unregister(void);
+int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr);
+int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
+		struct ieee80211_sub_if_data *sdata);
+
+/* Constants */
+#define DEFAULT_IEEE80211S_TTL 5
+
+/* Mesh Header Flags */
+#define IEEE80211S_FLAGS_AE 0x3
+
+#endif /* IEEE80211S_H */
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
new file mode 100644
index 0000000..1339ab4
--- /dev/null
+++ b/net/mac80211/mesh_pathtbl.c
@@ -0,0 +1,169 @@
+/*
+ * Copyright (c) 2007 open80211s Ltd.
+ * Authors :   Luis Carlos Cobo <luisca@cozybit.com>
+ * 	       Javier Cardona <javier@cozybit.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <net/rtnetlink.h>
+
+static LIST_HEAD(mesh_paths);
+static DEFINE_RWLOCK(mesh_paths_lock);
+
+struct mesh_path {
+	struct list_head list;
+
+	u8 dst[ETH_ALEN];
+	u8 next_hop[ETH_ALEN];
+	int ifa_index;
+};
+
+static const struct nla_policy mpa_policy[MPA_MAX+1] = {
+	[MPA_DST]               = { .len = ETH_ALEN },
+	[MPA_NEXT_HOP]          = { .len = ETH_ALEN },
+};
+
+int mesh_allocated;
+
+/**
+ * ieee80211s_nh_lookup - Look up next hop in mesh path table
+ * @dst: destination hardware address (input)
+ * @next_hop: next hop hardware address (output)
+ *
+ * Returns: 0 if next hop was found, nonzero otherwise
+ */
+
+int ieee80211s_nh_lookup(u8 *dst, u8 *next_hop)
+{
+	struct mesh_path *mp;
+
+	if (dst == NULL || next_hop == NULL)
+		return -1;
+
+	read_lock(&mesh_paths_lock);
+	list_for_each_entry(mp, &mesh_paths, list) {
+		if (memcmp(dst, mp->dst, ETH_ALEN) == 0) {
+			memcpy(next_hop, mp->next_hop, ETH_ALEN);
+			read_unlock(&mesh_paths_lock);
+			return 0;
+		}
+	}
+	read_unlock(&mesh_paths_lock);
+	return -1;
+}
+
+
+static int o80211s_newmeshpath(struct sk_buff *skb, struct nlmsghdr *nlh,
+		void *arg)
+{
+	struct mpmsg *mpm;
+	struct nlattr *tb[MPA_MAX+1];
+	struct mesh_path *newpath;
+	int err;
+
+	err = nlmsg_parse(nlh, sizeof(*mpm), tb, MPA_MAX, mpa_policy);
+	if (err < 0)
+		return err;
+
+	mpm = nlmsg_data(nlh);
+	if (!tb[MPA_DST] || !tb[MPA_NEXT_HOP])
+		return -EINVAL;
+
+	newpath = kmalloc(sizeof(struct mesh_path), GFP_KERNEL);
+	newpath->ifa_index = mpm->ifa_index;
+	memcpy(newpath->dst, nla_data(tb[MPA_DST]), ETH_ALEN);
+	memcpy(newpath->next_hop, nla_data(tb[MPA_NEXT_HOP]), ETH_ALEN);
+	write_lock(&mesh_paths_lock);
+	list_add(&newpath->list, &mesh_paths);
+	write_unlock(&mesh_paths_lock);
+	return err;
+}
+
+static int o80211s_delmeshpath(struct sk_buff *skb, struct nlmsghdr *nlh,
+		void *arg)
+{
+	struct list_head *p, *q;
+	struct mesh_path *path;
+	list_for_each_safe(p, q, &mesh_paths) {
+		path = list_entry(p, struct mesh_path, list);
+		list_del(p);
+		kfree(path);
+	}
+	return 0;
+}
+
+static int o80211s_getmeshpath(struct sk_buff *skb, struct nlmsghdr *nlh,
+		void *arg)
+{
+	return 0;
+}
+
+static int o80211s_dumpmeshpaths(struct sk_buff *skb,
+		struct netlink_callback *cb)
+{
+	int idx;
+	int s_idx = cb->args[0];
+	struct mesh_path *mp;
+	struct nlmsghdr *nlh;
+	struct mpmsg *hdr;
+
+	read_lock(&mesh_paths_lock);
+	idx = 0;
+	list_for_each_entry(mp, &mesh_paths, list) {
+		if (idx < s_idx)
+			goto cont;
+		nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).pid,
+				cb->nlh->nlmsg_seq, RTM_NEWMESHPATH,
+				sizeof(*hdr), NLM_F_MULTI);
+		if (nlh == NULL)
+			goto nlh_failure;
+		hdr = nlmsg_data(nlh);
+		hdr->ifa_index = mp->ifa_index;
+		hdr->mpm_flags = 0;
+		NLA_PUT(skb, MPA_DST, ETH_ALEN, mp->dst);
+		NLA_PUT(skb, MPA_NEXT_HOP, ETH_ALEN, mp->next_hop);
+		nlmsg_end(skb, nlh);
+		break;
+cont:
+		idx++;
+	}
+	read_unlock(&mesh_paths_lock);
+	cb->args[0] = idx+1;
+	return skb->len;
+
+nla_put_failure:
+	nlmsg_cancel(skb, nlh);
+nlh_failure:
+	read_unlock(&mesh_paths_lock);
+	return -EMSGSIZE;
+}
+
+void mesh_pathtbl_init(void)
+{
+	rtnl_register(PF_UNSPEC, RTM_NEWMESHPATH, o80211s_newmeshpath, NULL);
+	rtnl_register(PF_UNSPEC, RTM_GETMESHPATH, o80211s_getmeshpath,
+			o80211s_dumpmeshpaths);
+	rtnl_register(PF_UNSPEC, RTM_DELMESHPATH, o80211s_delmeshpath, NULL);
+}
+
+void mesh_pathtbl_unregister(void)
+{
+	struct list_head *p, *q;
+	struct mesh_path *path;
+
+	rtnl_unregister(PF_UNSPEC, RTM_NEWMESHPATH);
+	rtnl_unregister(PF_UNSPEC, RTM_DELMESHPATH);
+	rtnl_unregister(PF_UNSPEC, RTM_GETMESHPATH);
+	list_for_each_safe(p, q, &mesh_paths) {
+		path = list_entry(p, struct mesh_path, list);
+		list_del(p);
+		kfree(path);
+	}
+}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 428a9fc..7ca8637 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -19,6 +19,7 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_led.h"
+#include "ieee80211s.h"
 #include "wep.h"
 #include "wpa.h"
 #include "tkip.h"
@@ -397,6 +398,16 @@ ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
 	 * deauth/disassoc frames when needed. In addition, hostapd is
 	 * responsible for filtering on both auth and assoc states.
 	 */
+
+	if (rx->sdata->type == IEEE80211_IF_TYPE_MESH) {
+		if (((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
+			!((rx->fc & IEEE80211_FCTL_FROMDS) &&
+				(rx->fc & IEEE80211_FCTL_TODS)))
+			return TXRX_DROP;
+		else
+			return TXRX_CONTINUE;
+	}
+
 	if (unlikely(((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA ||
 		      ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL &&
 		       (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)) &&
@@ -1033,6 +1044,18 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 
 	hdrlen = ieee80211_get_hdrlen(fc);
 
+	if (sdata->type == IEEE80211_IF_TYPE_MESH) {
+		int meshhdrlen = ieee80211_get_mesh_hdrlen(
+				(struct ieee80211s_hdr *) skb->data);
+		/* Copy mesh header on cb to be used if forwarded.
+		 * It will be used as mesh header template at
+		 * tx.c:ieee80211_subif_start_xmit() if interface
+		 * type is mesh and skb->pkt_type == PACKET_OTHERHOST
+		 */
+		memcpy(skb->cb, skb->data + hdrlen, meshhdrlen);
+		hdrlen += meshhdrlen;
+	}
+
 	/* convert IEEE 802.11 header + possible LLC headers into Ethernet
 	 * header
 	 * IEEE 802.11 address fields:
@@ -1066,7 +1089,8 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 		memcpy(dst, hdr->addr3, ETH_ALEN);
 		memcpy(src, hdr->addr4, ETH_ALEN);
 
-		if (unlikely(sdata->type != IEEE80211_IF_TYPE_WDS)) {
+		if (unlikely(sdata->type != IEEE80211_IF_TYPE_WDS &&
+			     sdata->type != IEEE80211_IF_TYPE_MESH)) {
 			if (net_ratelimit())
 				printk(KERN_DEBUG "%s: dropped FromDS&ToDS "
 				       "frame (RA=%s TA=%s DA=%s SA=%s)\n",
@@ -1174,6 +1198,33 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 		}
 	}
 
+	/* Mesh forwarding */
+	if (sdata->type == IEEE80211_IF_TYPE_MESH) {
+		u8 *mesh_ttl = &((struct ieee80211s_hdr *)skb->cb)->ttl;
+		(*mesh_ttl)--;
+		if (is_multicast_ether_addr(dst)) {
+			/*
+			 * Disabled to avoid traffic explosion till we have
+			 * RBT and neighbor filtering
+			 *
+			if (*mesh_ttl > 0)
+				skb2 = skb_copy(skb, GFP_ATOMIC);
+				skb2->pkt_type = PACKET_OTHERHOST;
+			*/
+		} else if (skb->pkt_type != PACKET_OTHERHOST &&
+			compare_ether_addr(sdata->dev->dev_addr, dst) != 0) {
+			if (*mesh_ttl == 0) {
+				sdata->u.sta.mshstats.dropped_frames_ttl++;
+				return TXRX_DROP;
+			}
+			skb2 = skb;
+			skb2->pkt_type = PACKET_OTHERHOST;
+			if (!(sdata->dev->flags & IFF_PROMISC))
+				skb  = NULL;
+			sdata->u.sta.mshstats.fwded_frames++;
+		}
+	}
+
 	if (skb) {
 		/* deliver to local stack */
 		skb->protocol = eth_type_trans(skb, dev);
@@ -1202,7 +1253,8 @@ ieee80211_rx_h_mgmt(struct ieee80211_txrx_data *rx)
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 	if ((sdata->type == IEEE80211_IF_TYPE_STA ||
-	     sdata->type == IEEE80211_IF_TYPE_IBSS) &&
+	     sdata->type == IEEE80211_IF_TYPE_IBSS ||
+	     sdata->type == IEEE80211_IF_TYPE_MESH) &&
 	    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
 		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->u.rx.status);
 	else
@@ -1389,6 +1441,16 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
 			rx->sta = ieee80211_ibss_add_sta(sdata->dev, rx->skb,
 							 bssid, hdr->addr2);
 		break;
+
+	case IEEE80211_IF_TYPE_MESH:
+		if (!multicast &&
+		   compare_ether_addr(sdata->dev->dev_addr,
+				      hdr->addr1) != 0) {
+			if (!(sdata->dev->flags & IFF_PROMISC))
+				return 0;
+			rx->flags &= ~IEEE80211_TXRXD_RXRA_MATCH;
+		}
+		break;
 	case IEEE80211_IF_TYPE_VLAN:
 	case IEEE80211_IF_TYPE_AP:
 		if (!bssid) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1a53154..0aba117 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -26,6 +26,7 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_led.h"
+#include "ieee80211s.h"
 #include "wep.h"
 #include "wpa.h"
 #include "wme.h"
@@ -230,6 +231,9 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
 	     (tx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PROBE_REQ))
 		return TXRX_DROP;
 
+	if (tx->sdata->type == IEEE80211_IF_TYPE_MESH)
+		return TXRX_CONTINUE;
+
 	if (tx->flags & IEEE80211_TXRXD_TXPS_BUFFERED)
 		return TXRX_CONTINUE;
 
@@ -1342,8 +1346,9 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	struct ieee80211_tx_packet_data *pkt_data;
 	struct ieee80211_sub_if_data *sdata;
 	int ret = 1, head_need;
-	u16 ethertype, hdrlen, fc;
+	u16 ethertype, hdrlen,  meshhdrlen = 0, fc;
 	struct ieee80211_hdr hdr;
+	struct ieee80211s_hdr mesh_hdr;
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
@@ -1385,6 +1390,29 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 		hdrlen = 30;
 		break;
+	case IEEE80211_IF_TYPE_MESH:
+		fc |= IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS;
+		/* RA TA DA SA */
+		if (is_multicast_ether_addr(skb->data))
+			memcpy(hdr.addr1, skb->data, ETH_ALEN);
+		else if (ieee80211s_nh_lookup(skb->data, hdr.addr1)) {
+			ret = 0;
+			goto fail;
+		}
+		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
+		memcpy(hdr.addr3, skb->data, ETH_ALEN);
+		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
+		if (skb->pkt_type == PACKET_OTHERHOST) {
+			/* Forwarded frame, keep mesh ttl and seqnum */
+			struct ieee80211s_hdr *prev_meshhdr;
+			prev_meshhdr = ((struct ieee80211s_hdr *)skb->cb);
+			meshhdrlen = ieee80211_get_mesh_hdrlen(prev_meshhdr);
+			memcpy(&mesh_hdr, prev_meshhdr, meshhdrlen);
+		} else
+			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr,
+					sdata);
+		hdrlen = 30;
+		break;
 	case IEEE80211_IF_TYPE_STA:
 		fc |= IEEE80211_FCTL_TODS;
 		/* BSSID SA DA */
@@ -1450,7 +1478,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	 * build in headroom in __dev_alloc_skb() (linux/skbuff.h) and
 	 * alloc_skb() (net/core/skbuff.c)
 	 */
-	head_need = hdrlen + encaps_len + local->tx_headroom;
+	head_need = hdrlen + encaps_len + meshhdrlen + local->tx_headroom;
 	head_need -= skb_headroom(skb);
 
 	/* We are going to modify skb data, so make a copy of it if happens to
@@ -1484,6 +1512,12 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		h_pos += encaps_len;
 	}
 
+	if (meshhdrlen > 0) {
+		memcpy(skb_push(skb, meshhdrlen), &mesh_hdr, meshhdrlen);
+		nh_pos += meshhdrlen;
+		h_pos += meshhdrlen;
+	}
+
 	if (fc & IEEE80211_STYPE_QOS_DATA) {
 		__le16 *qos_control;
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 5a0564e..a850685 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -217,6 +217,25 @@ int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 
+int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
+{
+	int ae = meshhdr->flags & IEEE80211S_FLAGS_AE;
+	/* 7.1.3.5a.2 */
+	switch (ae) {
+	case 0:
+		return 5;
+	case 1:
+		return 11;
+	case 2:
+		return 17;
+	case 3:
+		return 23;
+	default:
+		return 5;
+	}
+}
+EXPORT_SYMBOL(ieee80211_get_mesh_hdrlen);
+
 int ieee80211_is_eapol(const struct sk_buff *skb)
 {
 	const struct ieee80211_hdr *hdr;
@@ -484,3 +503,25 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw)
 		ieee80211_wake_queue(hw, i);
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
+
+/**
+ * ieee80211_new_mesh_header - create a new mesh header
+ * @meshhdr:    uninitialized mesh header
+ * @sdata:	mesh interface to be used
+ *
+ * Return the header length.
+ */
+int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
+		struct ieee80211_sub_if_data *sdata)
+{
+	/* TODO: create a per mesh interface atomic sequence counter */
+	int mesh_seqnum  = atomic_inc_return(&sdata->u.sta.mesh_seqnum);
+
+	meshhdr->flags = 0;
+	meshhdr->ttl = DEFAULT_IEEE80211S_TTL;
+	meshhdr->seqnum[0] = (u8) (mesh_seqnum & 0xff);
+	meshhdr->seqnum[1] = (u8) ((mesh_seqnum >> 8) & 0xff);
+	meshhdr->seqnum[2] = (u8) ((mesh_seqnum >> 16) & 0xff);
+	return 5;
+}
+EXPORT_SYMBOL(ieee80211_new_mesh_header);
-- 
1.5.2.5




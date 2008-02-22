Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.234]:15256 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbYBVHSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 02:18:08 -0500
Received: by wx-out-0506.google.com with SMTP id h31so290544wxd.4
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2008 23:18:06 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Thu, 21 Feb 2008 20:07:20 -0800
Subject: [PATCH 03/13 v2] o11s: various definitions and support functions for mesh interfaces
Message-ID: <47be772d.17bc720a.0288.ffffcbbc@mx.google.com> (sfid-20080222_071812_193400_EB1E9FF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 include/linux/ieee80211.h |   35 +++++++++++++++++++++++++++++++++++
 include/linux/wireless.h  |    1 +
 include/net/mac80211.h    |    3 +++
 net/mac80211/Kconfig      |   15 +++++++++++++++
 net/mac80211/Makefile     |    6 ++++++
 net/mac80211/ieee80211.c  |   31 +++++++++++++++++++++++++++++--
 6 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index f577c8f..f27d11a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -97,6 +97,7 @@
 #define IEEE80211_MAX_FRAME_LEN		2352
 
 #define IEEE80211_MAX_SSID_LEN		32
+#define IEEE80211_MAX_MESH_ID_LEN	32
 
 struct ieee80211_hdr {
 	__le16 frame_control;
@@ -109,6 +110,16 @@ struct ieee80211_hdr {
 } __attribute__ ((packed));
 
 
+struct ieee80211s_hdr {
+	u8 flags;
+	u8 ttl;
+	u8 seqnum[3];
+	u8 eaddr1[6];
+	u8 eaddr2[6];
+	u8 eaddr3[6];
+} __attribute__ ((packed));
+
+
 struct ieee80211_mgmt {
 	__le16 frame_control;
 	__le16 duration;
@@ -206,6 +217,23 @@ struct ieee80211_mgmt {
 					__le16 params;
 					__le16 reason_code;
 				} __attribute__((packed)) delba;
+				struct{
+					u8 action_code;
+					/* capab_info for open and confirm,
+					 * reason for close
+					 */
+					__le16 aux;
+					/* Followed in plink_confirm by status
+					 * code, AID and supported rates,
+					 * and directly by supported rates in
+					 * plink_open and plink_close
+					 */
+					u8 variable[0];
+				} __attribute__((packed)) plink_action;
+				struct{
+					u8 action_code;
+					u8 variable[0];
+				} __attribute__((packed)) mesh_action;
 			} u;
 		} __attribute__ ((packed)) action;
 	} u;
@@ -437,6 +465,13 @@ enum ieee80211_eid {
 	WLAN_EID_TS_DELAY = 43,
 	WLAN_EID_TCLAS_PROCESSING = 44,
 	WLAN_EID_QOS_CAPA = 46,
+	/* 802.11s */
+	WLAN_EID_MESH_CONFIG = 36,      /* Pending IEEE 802.11 ANA approval */
+	WLAN_EID_MESH_ID = 37,          /* Pending IEEE 802.11 ANA approval */
+	WLAN_EID_PEER_LINK = 40,	/* Pending IEEE 802.11 ANA approval */
+	WLAN_EID_PREQ = 53,		/* Pending IEEE 802.11 ANA approval */
+	WLAN_EID_PREP = 54,		/* Pending IEEE 802.11 ANA approval */
+	WLAN_EID_PERR = 55,		/* Pending IEEE 802.11 ANA approval */
 	/* 802.11h */
 	WLAN_EID_PWR_CONSTRAINT = 32,
 	WLAN_EID_PWR_CAPABILITY = 33,
diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 74e84ca..151f48f 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -455,6 +455,7 @@
 #define IW_MODE_REPEAT	4	/* Wireless Repeater (forwarder) */
 #define IW_MODE_SECOND	5	/* Secondary master/repeater (backup) */
 #define IW_MODE_MONITOR	6	/* Passive monitor (listen only) */
+#define IW_MODE_MESH	7	/* Mesh (IEEE 802.11s) network */
 
 /* Statistics flags (bitmask in updated) */
 #define IW_QUAL_QUAL_UPDATED	0x01	/* Value was updated since last read */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 460da54..d762c26 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -436,6 +436,7 @@ enum ieee80211_if_types {
 	IEEE80211_IF_TYPE_AP,
 	IEEE80211_IF_TYPE_STA,
 	IEEE80211_IF_TYPE_IBSS,
+	IEEE80211_IF_TYPE_MESH_POINT,
 	IEEE80211_IF_TYPE_MNTR,
 	IEEE80211_IF_TYPE_WDS,
 	IEEE80211_IF_TYPE_VLAN,
@@ -497,6 +498,8 @@ struct ieee80211_if_init_conf {
  *	config_interface() call, so copy the value somewhere if you need
  *	it.
  * @ssid_len: length of the @ssid field.
+ * @mesh_id: mesh ID of the mesh network we will be part of.
+ * @mesh_id_len: length of the @mesh_id field.
  * @beacon: beacon template. Valid only if @host_gen_beacon_template in
  *	&struct ieee80211_hw is set. The driver is responsible of freeing
  *	the sk_buff.
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 45c7c0c..e91fd85 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -81,6 +81,14 @@ config MAC80211_RC_SIMPLE
 	  Say N unless you know what you are doing.
 endmenu
 
+config MAC80211_MESH
+	bool "Enable mac80211 mesh networking (pre-802.11s) support"
+	depends on MAC80211 && EXPERIMENTAL
+	---help---
+	 This options enables support of pre-802.11s mesh interfaces.
+	 For more information visit http://o11s.org
+
+
 config MAC80211_LEDS
 	bool "Enable LED triggers"
 	depends on MAC80211 && LEDS_TRIGGERS
@@ -166,3 +174,10 @@ config MAC80211_VERBOSE_PS_DEBUG
 	---help---
 	  Say Y here to print out verbose powersave
 	  mode debug messages.
+
+config MAC80211_VERBOSE_MPL_DEBUG
+	bool "Verbose mesh peer link debugging"
+	depends on MAC80211_DEBUG && MAC80211_MESH
+	---help---
+	  Say Y here to print out verbose mesh peer link
+	  debug messages.
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 9d7a195..829ce42 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -36,6 +36,12 @@ mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
 	debugfs_netdev.o \
 	debugfs_key.o
 
+mac80211-$(CONFIG_MAC80211_MESH) += \
+	mesh.o \
+	mesh_pathtbl.o \
+	mesh_plink.o \
+	mesh_hwmp.o
+
 
 # Build rate control algorithm(s)
 CFLAGS_rc80211_simple.o += -DRC80211_SIMPLE_COMPILE
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 1a0171d..6b5a1f4 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -26,6 +26,9 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
+#ifdef CONFIG_MAC80211_MESH
+#include "mesh.h"
+#endif
 #include "wep.h"
 #include "wme.h"
 #include "aes_ccm.h"
@@ -138,9 +141,15 @@ static void ieee80211_master_set_multicast_list(struct net_device *dev)
 
 static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 {
+	int meshhdrlen;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	meshhdrlen = (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) ? 5 : 0;
+
 	/* FIX: what would be proper limits for MTU?
 	 * This interface uses 802.3 frames. */
-	if (new_mtu < 256 || new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6) {
+	if (new_mtu < 256 ||
+		new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6 - meshhdrlen) {
 		printk(KERN_WARNING "%s: invalid MTU %d\n",
 		       dev->name, new_mtu);
 		return -EINVAL;
@@ -214,6 +223,7 @@ static int ieee80211_open(struct net_device *dev)
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_MNTR:
 	case IEEE80211_IF_TYPE_IBSS:
+	case IEEE80211_IF_TYPE_MESH_POINT:
 		/* no special treatment */
 		break;
 	case IEEE80211_IF_TYPE_INVALID:
@@ -394,6 +404,9 @@ static int ieee80211_stop(struct net_device *dev)
 		ieee80211_configure_filter(local);
 		netif_tx_unlock_bh(local->mdev);
 		break;
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		sta_info_flush(local, dev);
+		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		sdata->u.sta.state = IEEE80211_DISABLED;
@@ -879,6 +892,11 @@ static int __ieee80211_if_config(struct net_device *dev,
 		conf.bssid = sdata->u.sta.bssid;
 		conf.ssid = sdata->u.sta.ssid;
 		conf.ssid_len = sdata->u.sta.ssid_len;
+#ifdef CONFIG_MAC80211_MESH
+	} else if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
+		conf.beacon = beacon;
+		ieee80211_start_mesh(dev);
+#endif
 	} else if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
 		conf.ssid = sdata->u.ap.ssid;
 		conf.ssid_len = sdata->u.ap.ssid_len;
@@ -891,6 +909,11 @@ static int __ieee80211_if_config(struct net_device *dev,
 
 int ieee80211_if_config(struct net_device *dev)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT &&
+	    (local->hw.flags & IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE))
+		return ieee80211_if_config_beacon(dev);
 	return __ieee80211_if_config(dev, NULL, NULL);
 }
 
@@ -1579,7 +1602,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	/* add one default STA interface */
 	result = ieee80211_if_add(local->mdev, "wlan%d", NULL,
-				  IEEE80211_IF_TYPE_STA);
+				  IEEE80211_IF_TYPE_STA, NULL);
 	if (result)
 		printk(KERN_WARNING "%s: Failed to add default virtual iface\n",
 		       wiphy_name(local->hw.wiphy));
@@ -1714,6 +1737,10 @@ static void __exit ieee80211_exit(void)
 	rc80211_simple_exit();
 	rc80211_pid_exit();
 
+#ifdef CONFIG_MAC80211_MESH
+	if (mesh_allocated)
+		ieee80211s_stop();
+#endif
 	ieee80211_wme_unregister();
 	ieee80211_debugfs_netdev_exit();
 }
-- 
1.5.2.5




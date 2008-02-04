Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:37584 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbYBDVX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 16:23:59 -0500
Received: by an-out-0708.google.com with SMTP id d31so556800and.103
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 13:23:58 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 4 Feb 2008 10:55:24 -0800
Subject: [PATCH 04/13] o11s: various definitions and support functions for mesh interfaces
Message-ID: <47a7826d.08102c0a.1d2c.ffff96d2@mx.google.com> (sfid-20080204_212413_136777_9A62E0BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 include/linux/ieee80211.h |   25 +++++++++++++++++++++++++
 include/net/mac80211.h    |    3 +++
 net/mac80211/Kconfig      |    7 +++++++
 net/mac80211/Makefile     |    7 ++++++-
 net/mac80211/ieee80211.c  |   22 +++++++++++++++++++++-
 5 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index f577c8f..32deee6 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -97,6 +97,7 @@
 #define IEEE80211_MAX_FRAME_LEN		2352
 
 #define IEEE80211_MAX_SSID_LEN		32
+#define IEEE80211_MAX_MESH_ID_LEN	32
 
 struct ieee80211_hdr {
 	__le16 frame_control;
@@ -206,6 +207,23 @@ struct ieee80211_mgmt {
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
@@ -437,6 +455,13 @@ enum ieee80211_eid {
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
index e77592d..1145b55 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -167,3 +167,10 @@ config MAC80211_VERBOSE_PS_DEBUG
 	---help---
 	  Say Y here to print out verbose powersave
 	  mode debug messages.
+
+config MAC80211_VERBOSE_MPL_DEBUG
+	bool "Verbose mesh peer link debugging"
+	depends on MAC80211_DEBUG
+	---help---
+	  Say Y here to print out verbose mesh peer link
+	  debug messages.
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 9d7a195..8d7f6af 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -26,7 +26,12 @@ mac80211-y := \
 	tx.o \
 	key.o \
 	util.o \
-	event.o
+	event.o \
+	mesh.o \
+	mesh_pathtbl.o \
+	mesh_plinktbl.o \
+	mesh_plinkfsm.o \
+	mesh_hwmp.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
 mac80211-$(CONFIG_NET_SCHED) += wme.o
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index ecbcb77..cdeddc6 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -26,6 +26,7 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
+#include "mesh.h"
 #include "wep.h"
 #include "wme.h"
 #include "aes_ccm.h"
@@ -128,9 +129,15 @@ static void ieee80211_master_set_multicast_list(struct net_device *dev)
 
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
@@ -204,6 +211,7 @@ static int ieee80211_open(struct net_device *dev)
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_MNTR:
 	case IEEE80211_IF_TYPE_IBSS:
+	case IEEE80211_IF_TYPE_MESH_POINT:
 		/* no special treatment */
 		break;
 	case IEEE80211_IF_TYPE_INVALID:
@@ -358,6 +366,10 @@ static int ieee80211_stop(struct net_device *dev)
 			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
 		}
 		break;
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		sdata->u.sta.state = IEEE80211_DISABLED;
+		flush_mesh_interface(dev);
+		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		sdata->u.sta.state = IEEE80211_DISABLED;
@@ -843,6 +855,12 @@ static int __ieee80211_if_config(struct net_device *dev,
 		conf.bssid = sdata->u.sta.bssid;
 		conf.ssid = sdata->u.sta.ssid;
 		conf.ssid_len = sdata->u.sta.ssid_len;
+	} else if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
+		/* SSID is wildcard (all 0s) */
+		ieee80211_set_mesh_beacon_template(dev, &conf);
+		local->hw.flags |= IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
+		local->hw.conf.beacon_int = 100;
+		ieee80211_start_mesh(dev);
 	} else if (sdata->vif.type == IEEE80211_IF_TYPE_AP) {
 		conf.ssid = sdata->u.ap.ssid;
 		conf.ssid_len = sdata->u.ap.ssid_len;
@@ -1681,6 +1699,8 @@ static void __exit ieee80211_exit(void)
 	rc80211_simple_exit();
 	rc80211_pid_exit();
 
+	if (mesh_allocated)
+		ieee80211s_stop();
 	ieee80211_wme_unregister();
 	ieee80211_debugfs_netdev_exit();
 }
-- 
1.5.2.5




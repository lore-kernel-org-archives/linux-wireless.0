Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51296 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbXITP6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 11:58:04 -0400
Subject: [PATCH] mac80211: fix STA flags
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 17:58:48 +0200
Message-Id: <1190303928.18521.77.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just noticed that the STA flags are shared between hostapd
and mac80211 so since we're starting to use them for internal
flags that actually clash with other flags hostapd uses
internally, we need to translate.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/debugfs_sta.c     |    2 
 net/mac80211/hostapd_ioctl.h   |    7 +++
 net/mac80211/ieee80211_ioctl.c |   95 +++++++++++++++++++++++++++++++++--------
 net/mac80211/sta_info.h        |   48 ++++++++++++--------
 4 files changed, 116 insertions(+), 36 deletions(-)

--- wireless-dev.orig/net/mac80211/debugfs_sta.c	2007-09-20 17:31:02.391570258 +0200
+++ wireless-dev/net/mac80211/debugfs_sta.c	2007-09-20 17:34:41.711589898 +0200
@@ -90,7 +90,7 @@ static ssize_t sta_flags_read(struct fil
 		sta->flags & WLAN_STA_ASSOC ? "ASSOC\n" : "",
 		sta->flags & WLAN_STA_PS ? "PS\n" : "",
 		sta->flags & WLAN_STA_TIM ? "TIM\n" : "",
-		sta->flags & WLAN_STA_PERM ? "PERM\n" : "",
+		sta->flags & WLAN_STA_ASSOC_AP ? "ASSOC_AP\n" : "",
 		sta->flags & WLAN_STA_AUTHORIZED ? "AUTHORIZED\n" : "",
 		sta->flags & WLAN_STA_SHORT_PREAMBLE ? "SHORT PREAMBLE\n" : "",
 		sta->flags & WLAN_STA_WME ? "WME\n" : "",
--- wireless-dev.orig/net/mac80211/sta_info.h	2007-09-20 17:31:06.111570205 +0200
+++ wireless-dev/net/mac80211/sta_info.h	2007-09-20 17:35:09.011572103 +0200
@@ -15,24 +15,36 @@
 #include <linux/kref.h>
 #include "ieee80211_key.h"
 
-/* Stations flags (struct sta_info::flags) */
-#define WLAN_STA_AUTH BIT(0)
-#define WLAN_STA_ASSOC BIT(1)
-#define WLAN_STA_PS BIT(2)
-#define WLAN_STA_TIM BIT(3) /* TIM bit is on for PS stations */
-#define WLAN_STA_PERM BIT(4) /* permanent; do not remove entry on expiration */
-#define WLAN_STA_AUTHORIZED BIT(5) /* If 802.1X is used, this flag is
-				    * controlling whether STA is authorized to
-				    * send and receive non-IEEE 802.1X frames
-				    */
-#define WLAN_STA_SHORT_PREAMBLE BIT(7)
-/* whether this is an AP that we are associated with as a client */
-#define WLAN_STA_ASSOC_AP BIT(8)
-#define WLAN_STA_WME BIT(9)
-#define WLAN_STA_HT  BIT(10)
-/* whether this stations is a DLS peer of us */
-#define WLAN_STA_DLS BIT(11)
-#define WLAN_STA_WDS BIT(27)
+/**
+ * enum sta_flags - station flags
+ *
+ * These flags are used with the @flags member of &struct sta_info.
+ *
+ * @WLAN_STA_AUTH: STA is authenticated
+ * @WLAN_STA_ASSOC: STA is associated
+ * @WLAN_STA_PS: STA is in powersave mode
+ * @WLAN_STA_TIM: STA has TIM bit set (traffic pending)
+ * @WLAN_STA_AUTHORIZED: STA is authorized to send/receive non-802.1X frames
+ * @WLAN_STA_SHORT_PREAMBLE: STA can receive short preamble
+ * @WLAN_STA_ASSOC_AP: STA is an AP we are associated with as a client
+ * @WLAN_STA_WME: STA is QoS capable
+ * @WLAN_STA_HT: STA is HT capable
+ * @WLAN_STA_DLS: STA is a DLS peer
+ * @WLAN_STA_WDS: STA is a WDS peer
+ */
+enum sta_flags {
+	WLAN_STA_AUTH		= 1<<0,
+	WLAN_STA_ASSOC		= 1<<1,
+	WLAN_STA_PS		= 1<<2,
+	WLAN_STA_TIM		= 1<<3,
+	WLAN_STA_AUTHORIZED	= 1<<4,
+	WLAN_STA_SHORT_PREAMBLE	= 1<<5,
+	WLAN_STA_ASSOC_AP	= 1<<6,
+	WLAN_STA_WME		= 1<<7,
+	WLAN_STA_HT		= 1<<8,
+	WLAN_STA_DLS		= 1<<9,
+	WLAN_STA_WDS		= 1<<10,
+};
 
 
 struct sta_info {
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-09-20 17:31:04.731573296 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-09-20 17:34:41.721582791 +0200
@@ -76,6 +76,13 @@ enum {
 #define ALIGNED __attribute__ ((aligned))
 #endif
 
+/* hostapd compatible STA flags */
+#define HOSTAPD_STA_AUTH BIT(0)
+#define HOSTAPD_STA_ASSOC BIT(1)
+#define HOSTAPD_STA_AUTHORIZED BIT(5)
+#define HOSTAPD_STA_SHORT_PREAMBLE BIT(7)
+#define HOSTAPD_STA_WME BIT(9)
+
 struct prism2_hostapd_param {
 	u32 cmd;
 	u8 sta_addr[ETH_ALEN];
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-09-20 17:31:04.771571072 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-09-20 17:34:41.731572754 +0200
@@ -325,6 +325,23 @@ static int ieee80211_ioctl_remove_sta(st
 	return sta ? 0 : -ENOENT;
 }
 
+static u32 convert_to_hostapd_flag(u32 flag)
+{
+	/* this converts only those flags hostapd is allowed to see */
+	switch (flag) {
+	case WLAN_STA_AUTH:
+		return HOSTAPD_STA_AUTH;
+	case WLAN_STA_ASSOC:
+		return HOSTAPD_STA_ASSOC;
+	case WLAN_STA_AUTHORIZED:
+		return HOSTAPD_STA_AUTHORIZED;
+	case WLAN_STA_SHORT_PREAMBLE:
+		return HOSTAPD_STA_SHORT_PREAMBLE;
+	case WLAN_STA_WME:
+		return HOSTAPD_STA_WME;
+	}
+	return 0;
+}
 
 static int ieee80211_ioctl_get_info_sta(struct net_device *dev,
 					struct prism2_hostapd_param *param)
@@ -332,6 +349,7 @@ static int ieee80211_ioctl_get_info_sta(
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hw_mode *mode;
 	struct sta_info *sta;
+	int i;
 
 	if (is_broadcast_ether_addr(param->sta_addr)) {
 		struct net_device_stats *stats;
@@ -357,7 +375,11 @@ static int ieee80211_ioctl_get_info_sta(
 	param->u.get_info_sta.rx_bytes = sta->rx_bytes;
 	param->u.get_info_sta.tx_bytes = sta->tx_bytes;
 	param->u.get_info_sta.channel_use = sta->channel_use;
-	param->u.get_info_sta.flags = sta->flags;
+	param->u.get_info_sta.flags = 0;
+	for (i = 0; i < 32; i++)
+		if (sta->flags & (1<<i))
+			param->u.get_info_sta.flags |=
+				convert_to_hostapd_flag(1<<i);
 	mode = local->oper_hw_mode;
 	if (sta->txrate >= 0 && sta->txrate < mode->num_rates)
 		param->u.get_info_sta.current_tx_rate =
@@ -374,33 +396,72 @@ static int ieee80211_ioctl_get_info_sta(
 	return 0;
 }
 
+static u32 convert_from_hostapd_flag(u32 flag)
+{
+	/* this converts only those flags hostapd is allowed to change */
+	switch (flag) {
+	case HOSTAPD_STA_AUTH:
+		return WLAN_STA_AUTH;
+	case HOSTAPD_STA_ASSOC:
+		return WLAN_STA_ASSOC;
+	case HOSTAPD_STA_AUTHORIZED:
+		return WLAN_STA_AUTHORIZED;
+	case HOSTAPD_STA_SHORT_PREAMBLE:
+		return WLAN_STA_SHORT_PREAMBLE;
+	case HOSTAPD_STA_WME:
+		return WLAN_STA_WME;
+	}
+	return 0;
+}
 
 static int ieee80211_ioctl_set_flags_sta(struct net_device *dev,
 					 struct prism2_hostapd_param *param)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
+	int i, authorized;
+	u32 on, off, new_flags, changed;
 
 	sta = sta_info_get(local, param->sta_addr);
-	if (sta) {
-		sta->flags |= param->u.set_flags_sta.flags_or;
-		sta->flags &= param->u.set_flags_sta.flags_and;
-		if (local->ops->set_port_auth &&
-		    (param->u.set_flags_sta.flags_or & WLAN_STA_AUTHORIZED) &&
-		    local->ops->set_port_auth(local_to_hw(local), sta->addr, 1))
-			printk(KERN_DEBUG "%s: failed to set low-level driver "
-			       "PAE state (authorized) for " MAC_FMT "\n",
-			       dev->name, MAC_ARG(sta->addr));
-		if (local->ops->set_port_auth &&
-		    !(param->u.set_flags_sta.flags_and & WLAN_STA_AUTHORIZED) &&
-		    local->ops->set_port_auth(local_to_hw(local), sta->addr, 0))
+	if (!sta)
+		return -ENOENT;
+
+	on = off = 0;
+	/*
+	 * invert all the bits in the mask and build
+	 * the 'off' value with those.
+	 */
+	param->u.set_flags_sta.flags_and =
+		~param->u.set_flags_sta.flags_and;
+
+	for (i = 0; i < 32; i++) {
+		if (param->u.set_flags_sta.flags_or & (1<<i))
+			on |= convert_from_hostapd_flag(1<<i);
+		if (param->u.set_flags_sta.flags_and & (1<<i))
+			off |= convert_from_hostapd_flag(1<<i);
+	}
+
+	new_flags = sta->flags;
+	new_flags |= on;
+	new_flags &= ~off;
+
+	changed = sta->flags ^ new_flags;
+
+	sta->flags = new_flags;
+
+	if (local->ops->set_port_auth && (changed & WLAN_STA_AUTHORIZED)) {
+		authorized = !!(new_flags & WLAN_STA_AUTHORIZED);
+		if (local->ops->set_port_auth(local_to_hw(local),
+					      sta->addr, authorized))
 			printk(KERN_DEBUG "%s: failed to set low-level driver "
-			       "PAE state (unauthorized) for " MAC_FMT "\n",
-			       dev->name, MAC_ARG(sta->addr));
-		sta_info_put(sta);
+			       "PAE state (%sauthorized) for " MAC_FMT "\n",
+			       dev->name, authorized ? "" : "un",
+			       MAC_ARG(sta->addr));
 	}
 
-	return sta ? 0 : -ENOENT;
+	sta_info_put(sta);
+
+	return 0;
 }
 
 



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33720 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbYA2L3M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 06:29:12 -0500
Subject: [PATCH] mac80211: remove port control enable switch, clean up sta
	flags
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 17:19:37 +0100
Message-Id: <1201537178.9397.16.camel@johannes.berg> (sfid-20080129_112915_551433_815D6399)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the 802.1X port acess control enable flag
since it is not required. Instead, set the authorized flag for
each station that we normally communicate with (WDS peers, IBSS
peers and APs we're associated to) and require hostapd to set
the authorized flag for all stations when port control is not
enabled.

Also, since I was working in that area, this documents station
flags and removes the unused "permanent" one.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Tested with hostapd (plus patches including one for this feature)
in the "port control disabled" mode.

Jouni, would you see any problems with this going forward? I've
tested that currently it behaves fine.

John, I see no problems with this but would like Jouni to look
over it before it is applied.

 net/mac80211/debugfs_netdev.c |    9 --------
 net/mac80211/debugfs_sta.c    |    3 --
 net/mac80211/ieee80211.c      |    3 ++
 net/mac80211/ieee80211_i.h    |    9 --------
 net/mac80211/ieee80211_sta.c  |    5 +++-
 net/mac80211/rx.c             |    8 +++----
 net/mac80211/sta_info.h       |   44 +++++++++++++++++++++++++++---------------
 net/mac80211/tx.c             |    8 ++-----
 8 files changed, 44 insertions(+), 45 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-01-28 16:40:44.154307834 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-01-28 17:09:27.574343587 +0100
@@ -304,11 +304,6 @@ struct ieee80211_sub_if_data {
 	unsigned int flags;
 
 	int drop_unencrypted;
-	/*
-	 * IEEE 802.1X Port access control in effect,
-	 * drop packets to/from unauthorized port
-	 */
-	int ieee802_1x_pac;
 
 	/*
 	 * basic rates of this AP or the AP we're associated to
@@ -351,7 +346,6 @@ struct ieee80211_sub_if_data {
 		struct {
 			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
-			struct dentry *ieee802_1x_pac;
 			struct dentry *state;
 			struct dentry *bssid;
 			struct dentry *prev_bssid;
@@ -370,7 +364,6 @@ struct ieee80211_sub_if_data {
 		struct {
 			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
-			struct dentry *ieee802_1x_pac;
 			struct dentry *num_sta_ps;
 			struct dentry *dtim_count;
 			struct dentry *num_beacons;
@@ -381,13 +374,11 @@ struct ieee80211_sub_if_data {
 		struct {
 			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
-			struct dentry *ieee802_1x_pac;
 			struct dentry *peer;
 		} wds;
 		struct {
 			struct dentry *channel_use;
 			struct dentry *drop_unencrypted;
-			struct dentry *ieee802_1x_pac;
 		} vlan;
 		struct {
 			struct dentry *mode;
--- everything.orig/net/mac80211/debugfs_netdev.c	2008-01-28 16:40:44.174300401 +0100
+++ everything/net/mac80211/debugfs_netdev.c	2008-01-28 17:09:27.574343587 +0100
@@ -91,7 +91,6 @@ static const struct file_operations name
 /* common attributes */
 IEEE80211_IF_FILE(channel_use, channel_use, DEC);
 IEEE80211_IF_FILE(drop_unencrypted, drop_unencrypted, DEC);
-IEEE80211_IF_FILE(ieee802_1x_pac, ieee802_1x_pac, DEC);
 
 /* STA/IBSS attributes */
 IEEE80211_IF_FILE(state, u.sta.state, DEC);
@@ -148,7 +147,6 @@ static void add_sta_files(struct ieee802
 {
 	DEBUGFS_ADD(channel_use, sta);
 	DEBUGFS_ADD(drop_unencrypted, sta);
-	DEBUGFS_ADD(ieee802_1x_pac, sta);
 	DEBUGFS_ADD(state, sta);
 	DEBUGFS_ADD(bssid, sta);
 	DEBUGFS_ADD(prev_bssid, sta);
@@ -169,7 +167,6 @@ static void add_ap_files(struct ieee8021
 {
 	DEBUGFS_ADD(channel_use, ap);
 	DEBUGFS_ADD(drop_unencrypted, ap);
-	DEBUGFS_ADD(ieee802_1x_pac, ap);
 	DEBUGFS_ADD(num_sta_ps, ap);
 	DEBUGFS_ADD(dtim_count, ap);
 	DEBUGFS_ADD(num_beacons, ap);
@@ -182,7 +179,6 @@ static void add_wds_files(struct ieee802
 {
 	DEBUGFS_ADD(channel_use, wds);
 	DEBUGFS_ADD(drop_unencrypted, wds);
-	DEBUGFS_ADD(ieee802_1x_pac, wds);
 	DEBUGFS_ADD(peer, wds);
 }
 
@@ -190,7 +186,6 @@ static void add_vlan_files(struct ieee80
 {
 	DEBUGFS_ADD(channel_use, vlan);
 	DEBUGFS_ADD(drop_unencrypted, vlan);
-	DEBUGFS_ADD(ieee802_1x_pac, vlan);
 }
 
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
@@ -234,7 +229,6 @@ static void del_sta_files(struct ieee802
 {
 	DEBUGFS_DEL(channel_use, sta);
 	DEBUGFS_DEL(drop_unencrypted, sta);
-	DEBUGFS_DEL(ieee802_1x_pac, sta);
 	DEBUGFS_DEL(state, sta);
 	DEBUGFS_DEL(bssid, sta);
 	DEBUGFS_DEL(prev_bssid, sta);
@@ -255,7 +249,6 @@ static void del_ap_files(struct ieee8021
 {
 	DEBUGFS_DEL(channel_use, ap);
 	DEBUGFS_DEL(drop_unencrypted, ap);
-	DEBUGFS_DEL(ieee802_1x_pac, ap);
 	DEBUGFS_DEL(num_sta_ps, ap);
 	DEBUGFS_DEL(dtim_count, ap);
 	DEBUGFS_DEL(num_beacons, ap);
@@ -268,7 +261,6 @@ static void del_wds_files(struct ieee802
 {
 	DEBUGFS_DEL(channel_use, wds);
 	DEBUGFS_DEL(drop_unencrypted, wds);
-	DEBUGFS_DEL(ieee802_1x_pac, wds);
 	DEBUGFS_DEL(peer, wds);
 }
 
@@ -276,7 +268,6 @@ static void del_vlan_files(struct ieee80
 {
 	DEBUGFS_DEL(channel_use, vlan);
 	DEBUGFS_DEL(drop_unencrypted, vlan);
-	DEBUGFS_DEL(ieee802_1x_pac, vlan);
 }
 
 static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
--- everything.orig/net/mac80211/rx.c	2008-01-28 16:40:44.244300889 +0100
+++ everything/net/mac80211/rx.c	2008-01-28 17:09:27.584317328 +0100
@@ -1002,11 +1002,11 @@ ieee80211_rx_h_remove_qos_control(struct
 static int
 ieee80211_802_1x_port_control(struct ieee80211_txrx_data *rx)
 {
-	if (unlikely(rx->sdata->ieee802_1x_pac &&
-		     (!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED)))) {
+	if (unlikely(!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED))) {
 #ifdef CONFIG_MAC80211_DEBUG
-		printk(KERN_DEBUG "%s: dropped frame "
-		       "(unauthorized port)\n", rx->dev->name);
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: dropped frame "
+			       "(unauthorized port)\n", rx->dev->name);
 #endif /* CONFIG_MAC80211_DEBUG */
 		return -EACCES;
 	}
--- everything.orig/net/mac80211/tx.c	2008-01-28 17:09:25.564300510 +0100
+++ everything/net/mac80211/tx.c	2008-01-28 17:09:27.584317328 +0100
@@ -1469,12 +1469,10 @@ int ieee80211_subif_start_xmit(struct sk
 	}
 
 	/*
-	 * If port access control is enabled, drop unicast frames to
-	 * unauthorised stations unless they are EAPOL frames from the
-	 * local station.
+	 * Drop unicast frames to unauthorised stations unless they are
+	 * EAPOL frames from the local station.
 	 */
-	if (unlikely(sdata->ieee802_1x_pac &&
-		     !is_multicast_ether_addr(hdr.addr1) &&
+	if (unlikely(!is_multicast_ether_addr(hdr.addr1) &&
 		     !(sta_flags & WLAN_STA_AUTHORIZED) &&
 		     !(ethertype == ETH_P_PAE &&
 		       compare_ether_addr(dev->dev_addr,
--- everything.orig/net/mac80211/debugfs_sta.c	2008-01-28 16:40:44.314301269 +0100
+++ everything/net/mac80211/debugfs_sta.c	2008-01-28 17:09:27.584317328 +0100
@@ -67,12 +67,11 @@ static ssize_t sta_flags_read(struct fil
 {
 	char buf[100];
 	struct sta_info *sta = file->private_data;
-	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s%s%s",
+	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s%s",
 		sta->flags & WLAN_STA_AUTH ? "AUTH\n" : "",
 		sta->flags & WLAN_STA_ASSOC ? "ASSOC\n" : "",
 		sta->flags & WLAN_STA_PS ? "PS\n" : "",
 		sta->flags & WLAN_STA_TIM ? "TIM\n" : "",
-		sta->flags & WLAN_STA_PERM ? "PERM\n" : "",
 		sta->flags & WLAN_STA_AUTHORIZED ? "AUTHORIZED\n" : "",
 		sta->flags & WLAN_STA_SHORT_PREAMBLE ? "SHORT PREAMBLE\n" : "",
 		sta->flags & WLAN_STA_WME ? "WME\n" : "",
--- everything.orig/net/mac80211/ieee80211.c	2008-01-28 16:40:44.344299804 +0100
+++ everything/net/mac80211/ieee80211.c	2008-01-28 17:09:27.594300998 +0100
@@ -478,6 +478,9 @@ int ieee80211_if_update_wds(struct net_d
 	sta = sta_info_add(local, dev, remote_addr, GFP_KERNEL);
 	if (!sta)
 		return -ENOMEM;
+
+	sta->flags |= WLAN_STA_AUTHORIZED;
+
 	sta_info_put(sta);
 
 	/* Remove STA entry for the old peer */
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-01-28 17:04:57.654297255 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-01-28 17:09:27.604300076 +0100
@@ -1645,7 +1645,8 @@ static void ieee80211_rx_mgmt_assoc_resp
 	}
 
 	sta->dev = dev;
-	sta->flags |= WLAN_STA_AUTH | WLAN_STA_ASSOC | WLAN_STA_ASSOC_AP;
+	sta->flags |= WLAN_STA_AUTH | WLAN_STA_ASSOC | WLAN_STA_ASSOC_AP |
+		      WLAN_STA_AUTHORIZED;
 
 	rates = 0;
 	basic_rates = 0;
@@ -3602,6 +3603,8 @@ struct sta_info * ieee80211_ibss_add_sta
 	if (!sta)
 		return NULL;
 
+	sta->flags |= WLAN_STA_AUTHORIZED;
+
 	sta->supp_rates[local->hw.conf.channel->band] =
 		sdata->u.sta.supp_rates_bits[local->hw.conf.channel->band];
 
--- everything.orig/net/mac80211/sta_info.h	2008-01-28 16:40:44.424300781 +0100
+++ everything/net/mac80211/sta_info.h	2008-01-28 17:09:27.604300076 +0100
@@ -15,21 +15,35 @@
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
-#define WLAN_STA_WDS BIT(27)
+/**
+ * enum ieee80211_sta_info_flags - Stations flags
+ *
+ * These flags are used with &struct sta_info's @flags member.
+ *
+ * @WLAN_STA_AUTH: Station is authenticated.
+ * @WLAN_STA_ASSOC: Station is associated.
+ * @WLAN_STA_PS: Station is in power-save mode
+ * @WLAN_STA_TIM: TIM bit is on for this PS station (traffic buffered)
+ * @WLAN_STA_AUTHORIZED: Station is authorized to send/receive traffic.
+ *	This bit is always checked so needs to be enabled for all stations
+ *	when virtual port control is not in use.
+ * @WLAN_STA_SHORT_PREAMBLE: Station is capable of receiving short-preamble
+ *	frames.
+ * @WLAN_STA_ASSOC_AP: We're associated to that station, it is an AP.
+ * @WLAN_STA_WME: Station is a QoS-STA.
+ * @WLAN_STA_WDS: Station is one of our WDS peers.
+ */
+enum ieee80211_sta_info_flags {
+	WLAN_STA_AUTH		= 1<<0,
+	WLAN_STA_ASSOC		= 1<<1,
+	WLAN_STA_PS		= 1<<2,
+	WLAN_STA_TIM		= 1<<3,
+	WLAN_STA_AUTHORIZED	= 1<<4,
+	WLAN_STA_SHORT_PREAMBLE	= 1<<5,
+	WLAN_STA_ASSOC_AP	= 1<<6,
+	WLAN_STA_WME		= 1<<7,
+	WLAN_STA_WDS		= 1<<8,
+};
 
 #define STA_TID_NUM 16
 #define ADDBA_RESP_INTERVAL HZ



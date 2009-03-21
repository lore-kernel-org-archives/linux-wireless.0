Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbZCUQIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 12:08:46 -0400
Subject: [PATCH] mac80211: remove mixed-cell and userspace MLME code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 17:08:43 +0100
Message-Id: <1237651723.5100.274.camel@johannes.local> (sfid-20090321_170853_633687_91700A9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Neither can currently be set from userspace, so there's no
regression potential, and neither will be supported from
userspace since the new userspace APIs allow the SME, which
is in userspace, to control all we need.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    9 ++++-----
 net/mac80211/iface.c       |    3 +--
 net/mac80211/mlme.c        |    3 +--
 net/mac80211/rx.c          |   13 ++++---------
 net/mac80211/wext.c        |   17 +----------------
 5 files changed, 11 insertions(+), 34 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-03-21 17:06:18.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-03-21 17:06:34.000000000 +0100
@@ -247,8 +247,9 @@ struct mesh_preq_queue {
 #define IEEE80211_STA_ASSOCIATED	BIT(4)
 #define IEEE80211_STA_PROBEREQ_POLL	BIT(5)
 #define IEEE80211_STA_CREATE_IBSS	BIT(6)
-#define IEEE80211_STA_MIXED_CELL	BIT(7)
+/* hole at 7, please re-use */
 #define IEEE80211_STA_WMM_ENABLED	BIT(8)
+/* hole at 9, please re-use */
 #define IEEE80211_STA_AUTO_SSID_SEL	BIT(10)
 #define IEEE80211_STA_AUTO_BSSID_SEL	BIT(11)
 #define IEEE80211_STA_AUTO_CHANNEL_SEL	BIT(12)
@@ -411,7 +412,6 @@ struct ieee80211_if_mesh {
  *
  * @IEEE80211_SDATA_ALLMULTI: interface wants all multicast packets
  * @IEEE80211_SDATA_PROMISC: interface is promisc
- * @IEEE80211_SDATA_USERSPACE_MLME: userspace MLME is active
  * @IEEE80211_SDATA_OPERATING_GMODE: operating in G-only mode
  * @IEEE80211_SDATA_DONT_BRIDGE_PACKETS: bridge packets between
  *	associated stations and deliver multicast frames both
@@ -420,9 +420,8 @@ struct ieee80211_if_mesh {
 enum ieee80211_sub_if_data_flags {
 	IEEE80211_SDATA_ALLMULTI		= BIT(0),
 	IEEE80211_SDATA_PROMISC			= BIT(1),
-	IEEE80211_SDATA_USERSPACE_MLME		= BIT(2),
-	IEEE80211_SDATA_OPERATING_GMODE		= BIT(3),
-	IEEE80211_SDATA_DONT_BRIDGE_PACKETS	= BIT(4),
+	IEEE80211_SDATA_OPERATING_GMODE		= BIT(2),
+	IEEE80211_SDATA_DONT_BRIDGE_PACKETS	= BIT(3),
 };
 
 struct ieee80211_sub_if_data {
--- wireless-testing.orig/net/mac80211/iface.c	2009-03-21 17:06:11.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-03-21 17:06:34.000000000 +0100
@@ -261,8 +261,7 @@ static int ieee80211_open(struct net_dev
 		ieee80211_bss_info_change_notify(sdata, changed);
 		ieee80211_enable_keys(sdata);
 
-		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-		    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
+		if (sdata->vif.type == NL80211_IFTYPE_STATION)
 			netif_carrier_off(dev);
 		else
 			netif_carrier_on(dev);
--- wireless-testing.orig/net/mac80211/mlme.c	2009-03-21 17:06:13.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-03-21 17:06:34.000000000 +0100
@@ -849,8 +849,7 @@ static int ieee80211_privacy_mismatch(st
 	int wep_privacy;
 	int privacy_invoked;
 
-	if (!ifmgd || (ifmgd->flags & (IEEE80211_STA_MIXED_CELL |
-				       IEEE80211_STA_EXT_SME)))
+	if (!ifmgd || (ifmgd->flags & IEEE80211_STA_EXT_SME))
 		return 0;
 
 	bss = ieee80211_rx_bss_get(local, ifmgd->bssid,
--- wireless-testing.orig/net/mac80211/rx.c	2009-03-21 17:06:11.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-03-21 17:06:34.000000000 +0100
@@ -1877,18 +1877,13 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		return ieee80211_mesh_rx_mgmt(sdata, rx->skb, rx->status);
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
-		return RX_DROP_MONITOR;
+	if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
+		return ieee80211_ibss_rx_mgmt(sdata, rx->skb, rx->status);
 
-
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME)
-			return RX_DROP_MONITOR;
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		return ieee80211_sta_rx_mgmt(sdata, rx->skb, rx->status);
-	}
 
-	return ieee80211_ibss_rx_mgmt(sdata, rx->skb, rx->status);
+	return RX_DROP_MONITOR;
 }
 
 static void ieee80211_rx_michael_mic_report(struct net_device *dev,
--- wireless-testing.orig/net/mac80211/wext.c	2009-03-21 17:06:11.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-03-21 17:06:34.000000000 +0100
@@ -129,9 +129,6 @@ static int ieee80211_ioctl_siwgenie(stru
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME)
-		return -EOPNOTSUPP;
-
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		int ret = ieee80211_sta_set_extra_ie(sdata, extra, data->length);
 		if (ret)
@@ -208,14 +205,6 @@ static int ieee80211_ioctl_siwessid(stru
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME) {
-			if (len > IEEE80211_MAX_SSID_LEN)
-				return -EINVAL;
-			memcpy(sdata->u.mgd.ssid, ssid, len);
-			sdata->u.mgd.ssid_len = len;
-			return 0;
-		}
-
 		if (data->flags)
 			sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_SSID_SEL;
 		else
@@ -274,11 +263,7 @@ static int ieee80211_ioctl_siwap(struct 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		int ret;
-		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME) {
-			memcpy(sdata->u.mgd.bssid, (u8 *) &ap_addr->sa_data,
-			       ETH_ALEN);
-			return 0;
-		}
+
 		if (is_zero_ether_addr((u8 *) &ap_addr->sa_data))
 			sdata->u.mgd.flags |= IEEE80211_STA_AUTO_BSSID_SEL |
 				IEEE80211_STA_AUTO_CHANNEL_SEL;



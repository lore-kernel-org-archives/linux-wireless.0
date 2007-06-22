Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbXFVInE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:43:04 -0400
Subject: [PATCH] mac80211: kill PRISM2_HOSTAPD_UPDATE_IF sub-ioctl
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 09:51:36 +0200
Message-Id: <1182498696.21939.50.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This ioctl is (a) unused by hostapd and (b) useless since
you can just use SIOCSIWAP instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/hostapd_ioctl.h   |    3 +--
 net/mac80211/ieee80211_ioctl.c |   40 ----------------------------------------
 2 files changed, 1 insertion(+), 42 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-06-22 09:16:45.168635409 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-06-22 09:16:58.838635409 +0200
@@ -99,7 +99,6 @@ enum {
 	PRISM2_HOSTAPD_SET_REGULATORY_DOMAIN = 1013,
 	PRISM2_HOSTAPD_SET_TX_QUEUE_PARAMS = 1014,
 	PRISM2_HOSTAPD_GET_TX_STATS = 1016,
-	PRISM2_HOSTAPD_UPDATE_IF = 1017,
 	PRISM2_HOSTAPD_SCAN_REQ = 1019,
 	PRISM2_STA_GET_STATE = 1020,
 	PRISM2_HOSTAPD_FLUSH_IFS = 1021,
@@ -320,7 +319,7 @@ struct ieee80211_rate_data {
 };
 
 
-/* ADD_IF, REMOVE_IF, and UPDATE_IF 'type' argument */
+/* ADD_IF and REMOVE_IF 'type' argument */
 enum {
 	HOSTAP_IF_WDS = 1, HOSTAP_IF_VLAN = 2, HOSTAP_IF_BSS = 3,
 	HOSTAP_IF_STA = 4
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-06-22 09:16:20.988635409 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-06-22 09:16:42.208635409 +0200
@@ -1022,43 +1022,6 @@ static int ieee80211_ioctl_remove_if(str
 	return ieee80211_if_remove(dev, param->u.if_info.name, type);
 }
 
-static int ieee80211_ioctl_update_if(struct net_device *dev,
-				     struct prism2_hostapd_param *param,
-				     int param_len)
-{
-	u8 *pos = param->u.if_info.data;
-	int left = param_len - ((u8 *) pos - (u8 *) param);
-
-	if (param->u.if_info.type == HOSTAP_IF_WDS) {
-		struct hostapd_if_wds *wds =
-			(struct hostapd_if_wds *) param->u.if_info.data;
-		struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-		struct net_device *wds_dev = NULL;
-		struct ieee80211_sub_if_data *sdata;
-
-		if (left < sizeof(struct ieee80211_if_wds))
-			return -EPROTO;
-
-		read_lock(&local->sub_if_lock);
-		list_for_each_entry(sdata, &local->sub_if_list, list) {
-			if (strcmp(param->u.if_info.name,
-				   sdata->dev->name) == 0) {
-				wds_dev = sdata->dev;
-				break;
-			}
-		}
-		read_unlock(&local->sub_if_lock);
-
-		if (!wds_dev || sdata->type != IEEE80211_IF_TYPE_WDS)
-			return -ENODEV;
-
-		return ieee80211_if_update_wds(wds_dev, wds->remote_addr);
-	} else {
-		return -EOPNOTSUPP;
-	}
-}
-
-
 static int ieee80211_ioctl_scan_req(struct net_device *dev,
 				    struct prism2_hostapd_param *param,
 				    int param_len)
@@ -1433,9 +1396,6 @@ static int ieee80211_ioctl_priv_hostapd(
 	case PRISM2_HOSTAPD_GET_TX_STATS:
 		ret = ieee80211_ioctl_get_tx_stats(dev, param);
 		break;
-	case PRISM2_HOSTAPD_UPDATE_IF:
-		ret = ieee80211_ioctl_update_if(dev, param, p->length);
-		break;
 	case PRISM2_HOSTAPD_SCAN_REQ:
 		ret = ieee80211_ioctl_scan_req(dev, param, p->length);
 		break;



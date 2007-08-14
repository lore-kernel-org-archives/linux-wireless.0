Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57199 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbXHNLsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:48:55 -0400
Message-Id: <20070814092446.085258000@sipsolutions.net>
References: <20070814092008.627058000@sipsolutions.net>
Date: Tue, 14 Aug 2007 11:20:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 11/13] mac80211: remove PRISM2_HOSTAPD_{ADD,REMOVE}_IF
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is unused in hostapd/wpa_supplicant now that I made it
use nl80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/hostapd_ioctl.h   |   24 ---------
 net/mac80211/ieee80211_ioctl.c |  100 -----------------------------------------
 2 files changed, 124 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-14 00:27:33.265589257 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-14 00:27:33.885589257 +0200
@@ -58,8 +58,6 @@ enum {
 	PRISM2_HOSTAPD_SET_BEACON = 1001,
 	PRISM2_HOSTAPD_GET_HW_FEATURES = 1002,
 	PRISM2_HOSTAPD_SET_RATE_SETS = 1005,
-	PRISM2_HOSTAPD_ADD_IF = 1006,
-	PRISM2_HOSTAPD_REMOVE_IF = 1007,
 	PRISM2_HOSTAPD_SET_STA_VLAN = 1010,
 	PRISM2_HOSTAPD_SET_CHANNEL_FLAG = 1012,
 	PRISM2_HOSTAPD_SET_REGULATORY_DOMAIN = 1013,
@@ -197,26 +195,4 @@ struct ieee80211_rate_data {
 	int flags; /* IEEE80211_RATE_ flags */
 };
 
-
-/* ADD_IF and REMOVE_IF 'type' argument */
-enum {
-	HOSTAP_IF_WDS = 1, HOSTAP_IF_VLAN = 2, HOSTAP_IF_BSS = 3,
-	HOSTAP_IF_STA = 4
-};
-
-struct hostapd_if_wds {
-	u8 remote_addr[ETH_ALEN];
-};
-
-struct hostapd_if_vlan {
-	u8 id;
-};
-
-struct hostapd_if_bss {
-	u8 bssid[ETH_ALEN];
-};
-
-struct hostapd_if_sta {
-};
-
 #endif /* HOSTAPD_IOCTL_H */
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-14 00:27:33.265589257 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-14 00:27:33.885589257 +0200
@@ -870,100 +870,6 @@ static int ieee80211_ioctl_set_rate_sets
 }
 
 
-static int ieee80211_ioctl_add_if(struct net_device *dev,
-				  struct prism2_hostapd_param *param,
-				  int param_len)
-{
-	u8 *pos = param->u.if_info.data;
-	int left = param_len - ((u8 *) pos - (u8 *) param);
-	struct net_device *new_dev;
-	int res;
-	struct hostapd_if_wds *wds;
-	struct hostapd_if_bss *bss;
-
-	printk(KERN_WARNING "PRISM2_HOSTAPD_ADD_IF ioctl is deprecated!");
-	switch (param->u.if_info.type) {
-	case HOSTAP_IF_WDS:
-		wds = (struct hostapd_if_wds *) param->u.if_info.data;
-
-		if (left < sizeof(struct hostapd_if_wds))
-			return -EPROTO;
-
-		res = ieee80211_if_add(dev, param->u.if_info.name, &new_dev,
-				       IEEE80211_IF_TYPE_WDS);
-		if (res)
-			return res;
-		res = ieee80211_if_update_wds(new_dev, wds->remote_addr);
-		if (unlikely(res)) {
-			struct ieee80211_local *local =
-				wdev_priv(dev->ieee80211_ptr);
-			struct ieee80211_sub_if_data *sdata =
-				IEEE80211_DEV_TO_SUB_IF(new_dev);
-			write_lock_bh(&local->sub_if_lock);
-			list_del(&sdata->list);
-			write_unlock_bh(&local->sub_if_lock);
-			__ieee80211_if_del(local, sdata);
-		}
-		return res;
-	case HOSTAP_IF_VLAN:
-		if (left < sizeof(struct hostapd_if_vlan))
-			return -EPROTO;
-
-		res = ieee80211_if_add(dev, param->u.if_info.name, NULL,
-				       IEEE80211_IF_TYPE_VLAN);
-		return res;
-	case HOSTAP_IF_BSS:
-		bss = (struct hostapd_if_bss *) param->u.if_info.data;
-
-		if (left < sizeof(struct hostapd_if_bss))
-			return -EPROTO;
-
-		res = ieee80211_if_add(dev, param->u.if_info.name, &new_dev,
-				       IEEE80211_IF_TYPE_AP);
-		if (res)
-			return res;
-		memcpy(new_dev->dev_addr, bss->bssid, ETH_ALEN);
-		return 0;
-	case HOSTAP_IF_STA:
-		if (left < sizeof(struct hostapd_if_sta))
-			return -EPROTO;
-
-		res = ieee80211_if_add(dev, param->u.if_info.name, NULL,
-				       IEEE80211_IF_TYPE_STA);
-		return res;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int ieee80211_ioctl_remove_if(struct net_device *dev,
-				     struct prism2_hostapd_param *param)
-{
-	unsigned int type;
-
-	switch (param->u.if_info.type) {
-	case HOSTAP_IF_WDS:
-		type = IEEE80211_IF_TYPE_WDS;
-		break;
-	case HOSTAP_IF_VLAN:
-		type = IEEE80211_IF_TYPE_VLAN;
-		break;
-	case HOSTAP_IF_BSS:
-		type = IEEE80211_IF_TYPE_AP;
-		break;
-	case HOSTAP_IF_STA:
-		type = IEEE80211_IF_TYPE_STA;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return ieee80211_if_remove(dev, param->u.if_info.name, type);
-}
-
-
 static int ieee80211_ioctl_set_sta_vlan(struct net_device *dev,
 					struct prism2_hostapd_param *param)
 {
@@ -1151,12 +1057,6 @@ static int ieee80211_ioctl_priv_hostapd(
 	case PRISM2_HOSTAPD_SET_RATE_SETS:
 		ret = ieee80211_ioctl_set_rate_sets(dev, param, p->length);
 		break;
-	case PRISM2_HOSTAPD_ADD_IF:
-		ret = ieee80211_ioctl_add_if(dev, param, p->length);
-		break;
-	case PRISM2_HOSTAPD_REMOVE_IF:
-		ret = ieee80211_ioctl_remove_if(dev, param);
-		break;
 	case PRISM2_HOSTAPD_SET_STA_VLAN:
 		ret = ieee80211_ioctl_set_sta_vlan(dev, param);
 		break;

-- 


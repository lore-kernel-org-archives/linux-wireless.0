Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57490 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763144AbXHOOuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 10:50:55 -0400
Message-Id: <20070815145046.443528000@sipsolutions.net>
References: <20070815144920.135826000@sipsolutions.net>
Date: Wed, 15 Aug 2007 16:49:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 11/20] mac80211: remove PRISM2_HOSTAPD_SET_GENERIC_INFO_ELEM
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now unused in hostapd/wpa_supplicant, it uses SIOCSIWGENIE.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/hostapd_ioctl.h   |    5 -----
 net/mac80211/ieee80211_ioctl.c |   20 --------------------
 2 files changed, 25 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-15 14:11:26.306516958 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-15 14:11:39.886516958 +0200
@@ -62,7 +62,6 @@ enum {
 	PRISM2_HOSTAPD_ADD_IF = 1006,
 	PRISM2_HOSTAPD_REMOVE_IF = 1007,
 	PRISM2_HOSTAPD_SET_STA_VLAN = 1010,
-	PRISM2_HOSTAPD_SET_GENERIC_INFO_ELEM = 1011,
 	PRISM2_HOSTAPD_SET_CHANNEL_FLAG = 1012,
 	PRISM2_HOSTAPD_SET_REGULATORY_DOMAIN = 1013,
 	PRISM2_HOSTAPD_SET_TX_QUEUE_PARAMS = 1014,
@@ -153,10 +152,6 @@ struct prism2_hostapd_param {
 			int vlan_id;
 		} set_sta_vlan;
 		struct {
-			u8 len;
-			u8 data[0] ALIGNED;
-		} set_generic_info_elem;
-		struct {
 			u16 mode; /* MODE_* */
 			u16 chan;
 			u32 flag;
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-15 14:11:26.316516958 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-15 14:11:39.896516958 +0200
@@ -1028,22 +1028,6 @@ static int ieee80211_set_gen_ie(struct n
 }
 
 
-static int
-ieee80211_ioctl_set_generic_info_elem(struct net_device *dev,
-				      struct prism2_hostapd_param *param,
-				      int param_len)
-{
-	u8 *pos = param->u.set_generic_info_elem.data;
-	int left = param_len - ((u8 *) pos - (u8 *) param);
-	int len = param->u.set_generic_info_elem.len;
-
-	if (left < len)
-		return -EINVAL;
-
-	return ieee80211_set_gen_ie(dev, pos, len);
-}
-
-
 static int ieee80211_ioctl_set_regulatory_domain(struct net_device *dev,
 					    struct prism2_hostapd_param *param)
 {
@@ -1176,10 +1160,6 @@ static int ieee80211_ioctl_priv_hostapd(
 	case PRISM2_HOSTAPD_SET_STA_VLAN:
 		ret = ieee80211_ioctl_set_sta_vlan(dev, param);
 		break;
-	case PRISM2_HOSTAPD_SET_GENERIC_INFO_ELEM:
-		ret = ieee80211_ioctl_set_generic_info_elem(dev, param,
-							    p->length);
-		break;
 	case PRISM2_HOSTAPD_SET_CHANNEL_FLAG:
 		ret = ieee80211_ioctl_set_channel_flag(dev, param);
 		break;

-- 


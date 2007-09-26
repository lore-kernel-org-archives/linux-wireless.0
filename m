Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbXIZNYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 09:24:16 -0400
Message-Id: <20070926132137.144217000@sipsolutions.net>
References: <20070926131938.575572000@sipsolutions.net>
Date: Wed, 26 Sep 2007 15:19:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: [patch 12/12] mac80211: remove generic IE for AP interfaces
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not useful since we do not support probe response
offload to hardware at this time and beacons are set in
another way.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h         |    7 -------
 net/mac80211/ieee80211.c       |    4 ----
 net/mac80211/ieee80211_i.h     |    2 --
 net/mac80211/ieee80211_iface.c |    1 -
 net/mac80211/ieee80211_ioctl.c |    9 ---------
 5 files changed, 23 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-09-26 14:38:36.728936654 +0200
+++ wireless-dev/include/net/mac80211.h	2007-09-26 14:38:39.048936654 +0200
@@ -518,11 +518,6 @@ struct ieee80211_if_init_conf {
  *	config_interface() call, so copy the value somewhere if you need
  *	it.
  * @ssid_len: length of the @ssid field.
- * @generic_elem: used (together with @generic_elem_len) by drivers for
- *	hardware that generate beacons independently. The pointer is valid
- *	only during the config_interface() call, so copy the value somewhere
- *	if you need it.
- * @generic_elem_len: length of the generic element.
  * @beacon: beacon template. Valid only if @host_gen_beacon_template in
  *	&struct ieee80211_hw is set. The driver is responsible of freeing
  *	the sk_buff.
@@ -537,8 +532,6 @@ struct ieee80211_if_conf {
 	u8 *bssid;
 	u8 *ssid;
 	size_t ssid_len;
-	u8 *generic_elem;
-	size_t generic_elem_len;
 	struct sk_buff *beacon;
 	struct ieee80211_tx_control *beacon_control;
 };
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-26 14:38:36.738936654 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-26 14:39:47.048936654 +0200
@@ -452,13 +452,9 @@ static int __ieee80211_if_config(struct 
 		conf.bssid = sdata->u.sta.bssid;
 		conf.ssid = sdata->u.sta.ssid;
 		conf.ssid_len = sdata->u.sta.ssid_len;
-		conf.generic_elem = sdata->u.sta.extra_ie;
-		conf.generic_elem_len = sdata->u.sta.extra_ie_len;
 	} else if (sdata->type == IEEE80211_IF_TYPE_AP) {
 		conf.ssid = sdata->u.ap.ssid;
 		conf.ssid_len = sdata->u.ap.ssid_len;
-		conf.generic_elem = sdata->u.ap.generic_elem;
-		conf.generic_elem_len = sdata->u.ap.generic_elem_len;
 		conf.beacon = beacon;
 		conf.beacon_control = control;
 	}
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-09-26 14:38:36.748936654 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-09-26 14:43:03.908936654 +0200
@@ -195,8 +195,6 @@ struct ieee80211_if_ap {
 
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
-	u8 *generic_elem;
-	size_t generic_elem_len;
 
 	/* yes, this looks ugly, but guarantees that we can later use
 	 * bitmap_empty :)
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-09-26 14:38:16.958936654 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-09-26 14:39:41.338936654 +0200
@@ -120,15 +120,6 @@ static int ieee80211_ioctl_siwgenie(stru
 		return 0;
 	}
 
-	if (sdata->type == IEEE80211_IF_TYPE_AP) {
-		kfree(sdata->u.ap.generic_elem);
-		sdata->u.ap.generic_elem = kmalloc(data->length, GFP_KERNEL);
-		if (!sdata->u.ap.generic_elem)
-			return -ENOMEM;
-		memcpy(sdata->u.ap.generic_elem, extra, data->length);
-		sdata->u.ap.generic_elem_len = data->length;
-		return ieee80211_if_config(dev);
-	}
 	return -EOPNOTSUPP;
 }
 
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-09-26 14:38:36.748936654 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-09-26 14:43:03.958936654 +0200
@@ -206,7 +206,6 @@ void ieee80211_if_reinit(struct net_devi
 
 		kfree(sdata->u.ap.beacon_head);
 		kfree(sdata->u.ap.beacon_tail);
-		kfree(sdata->u.ap.generic_elem);
 
 		while ((skb = skb_dequeue(&sdata->u.ap.ps_bc_buf))) {
 			local->total_ps_buffered--;

-- 


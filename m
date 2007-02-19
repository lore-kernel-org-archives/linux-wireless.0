Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54733 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965116AbXBSWjX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:39:23 -0500
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070219233919.221549000.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/12] d80211: Support automatic channel/BSSID/SSID configuration
Message-Id: <20070219223953.04FF2484AD@silver.suse.cz>
Date: Mon, 19 Feb 2007 23:39:53 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This patch implements auto channel/BSSID/SSID selection for backwards
compatibility with anyone not using wpa_supplicant to associate.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/d80211/ieee80211_i.h     |    5 ++
 net/d80211/ieee80211_iface.c |    2 +
 net/d80211/ieee80211_ioctl.c |   47 +++++++++++++--
 net/d80211/ieee80211_sta.c   |  128 ++++++++++++++++++++++++++++++++++++------
 4 files changed, 156 insertions(+), 26 deletions(-)

fa1b0d85c68b852b52ab39426bec4c845a66c23a
diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
index 0ab20b3..b1ed96f 100644
--- a/net/d80211/ieee80211_i.h
+++ b/net/d80211/ieee80211_i.h
@@ -268,6 +268,9 @@ struct ieee80211_if_sta {
 	unsigned int create_ibss:1;
 	unsigned int mixed_cell:1;
 	unsigned int wmm_enabled:1;
+	unsigned int auto_ssid_sel:1;
+	unsigned int auto_bssid_sel:1;
+	unsigned int auto_channel_sel:1;
 #define IEEE80211_STA_REQ_SCAN 0
 #define IEEE80211_STA_REQ_AUTH 1
 #define IEEE80211_STA_REQ_RUN  2
@@ -671,6 +674,8 @@ int ieee80211_sta_set_ssid(struct net_de
 int ieee80211_sta_get_ssid(struct net_device *dev, char *ssid, size_t *len);
 int ieee80211_sta_set_bssid(struct net_device *dev, u8 *bssid);
 int ieee80211_sta_req_scan(struct net_device *dev, u8 *ssid, size_t ssid_len);
+void ieee80211_sta_req_auth(struct net_device *dev,
+			    struct ieee80211_if_sta *ifsta);
 int ieee80211_sta_scan_results(struct net_device *dev, char *buf, size_t len);
 void ieee80211_sta_rx_scan(struct net_device *dev, struct sk_buff *skb,
 			   struct ieee80211_rx_status *rx_status);
diff --git a/net/d80211/ieee80211_iface.c b/net/d80211/ieee80211_iface.c
index 939e289..ec9cdc2 100644
--- a/net/d80211/ieee80211_iface.c
+++ b/net/d80211/ieee80211_iface.c
@@ -195,6 +195,8 @@ void ieee80211_if_set_type(struct net_de
 			IEEE80211_AUTH_ALG_SHARED_KEY;
 		ifsta->create_ibss = 1;
 		ifsta->wmm_enabled = 1;
+		ifsta->auto_channel_sel = 1;
+		ifsta->auto_bssid_sel = 1;
 
 		msdata = IEEE80211_DEV_TO_SUB_IF(sdata->local->mdev);
 		sdata->bss = &msdata->u.ap;
diff --git a/net/d80211/ieee80211_ioctl.c b/net/d80211/ieee80211_ioctl.c
index 0a1a5eb..fa85fb0 100644
--- a/net/d80211/ieee80211_ioctl.c
+++ b/net/d80211/ieee80211_ioctl.c
@@ -1247,8 +1247,14 @@ static int ieee80211_set_gen_ie(struct n
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type == IEEE80211_IF_TYPE_STA ||
-	    sdata->type == IEEE80211_IF_TYPE_IBSS)
-		return ieee80211_sta_set_extra_ie(dev, ie, len);
+	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
+		int ret = ieee80211_sta_set_extra_ie(dev, ie, len);
+		if (ret)
+			return ret;
+		sdata->u.sta.auto_bssid_sel = 0;
+		ieee80211_sta_req_auth(dev, &sdata->u.sta);
+		return 0;
+	}
 
 	if (sdata->type == IEEE80211_IF_TYPE_AP) {
 		kfree(sdata->u.ap.generic_elem);
@@ -1833,11 +1839,20 @@ static int ieee80211_ioctl_siwfreq(struc
 				   struct iw_freq *freq, char *extra)
 {
 	struct ieee80211_local *local = dev->ieee80211_ptr;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->type == IEEE80211_IF_TYPE_STA)
+		sdata->u.sta.auto_channel_sel = 0;
 
 	/* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
-	if (freq->e == 0)
-		return ieee80211_set_channel(local, freq->m, -1);
-	else {
+	if (freq->e == 0) {
+		if (freq->m < 0) {
+			if (sdata->type == IEEE80211_IF_TYPE_STA)
+				sdata->u.sta.auto_channel_sel = 1;
+			return 0;
+		} else
+			return ieee80211_set_channel(local, freq->m, -1);
+	} else {
 		int i, div = 1000000;
 		for (i = 0; i < freq->e; i++)
 			div /= 10;
@@ -1880,6 +1895,7 @@ static int ieee80211_ioctl_siwessid(stru
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type == IEEE80211_IF_TYPE_STA ||
 	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
+		int ret;
 		if (local->user_space_mlme) {
 			if (len > IEEE80211_MAX_SSID_LEN)
 				return -EINVAL;
@@ -1887,7 +1903,12 @@ static int ieee80211_ioctl_siwessid(stru
 			sdata->u.sta.ssid_len = len;
 			return 0;
 		}
-		return ieee80211_sta_set_ssid(dev, ssid, len);
+		sdata->u.sta.auto_ssid_sel = !data->flags;
+		ret = ieee80211_sta_set_ssid(dev, ssid, len);
+		if (ret)
+			return ret;
+		ieee80211_sta_req_auth(dev, &sdata->u.sta);
+		return 0;
 	}
 
 	if (sdata->type == IEEE80211_IF_TYPE_AP) {
@@ -1943,12 +1964,24 @@ static int ieee80211_ioctl_siwap(struct 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type == IEEE80211_IF_TYPE_STA ||
 	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
+		int ret;
 		if (local->user_space_mlme) {
 			memcpy(sdata->u.sta.bssid, (u8 *) &ap_addr->sa_data,
 			       ETH_ALEN);
 			return 0;
 		}
-		return ieee80211_sta_set_bssid(dev, (u8 *) &ap_addr->sa_data);
+		if (is_zero_ether_addr((u8 *) &ap_addr->sa_data)) {
+			sdata->u.sta.auto_bssid_sel = 1;
+			sdata->u.sta.auto_channel_sel = 1;
+		} else if (is_broadcast_ether_addr((u8 *) &ap_addr->sa_data))
+			sdata->u.sta.auto_bssid_sel = 1;
+		else
+			sdata->u.sta.auto_bssid_sel = 0;
+		ret = ieee80211_sta_set_bssid(dev, (u8 *) &ap_addr->sa_data);
+		if (ret)
+			return ret;
+		ieee80211_sta_req_auth(dev, &sdata->u.sta);
+		return 0;
 	} else if (sdata->type == IEEE80211_IF_TYPE_WDS) {
 		if (memcmp(sdata->u.wds.remote_addr, (u8 *) &ap_addr->sa_data,
 			   ETH_ALEN) == 0)
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index 07aa8b0..1cb33cf 100644
--- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -3,6 +3,7 @@
  * Copyright 2003, Jouni Malinen <jkmaline@cc.hut.fi>
  * Copyright 2004, Instant802 Networks, Inc.
  * Copyright 2005, Devicescape Software, Inc.
+ * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -21,6 +22,7 @@ #include <linux/netdevice.h>
 #include <linux/if_arp.h>
 #include <linux/wireless.h>
 #include <linux/random.h>
+#include <linux/etherdevice.h>
 #include <net/iw_handler.h>
 #include <asm/types.h>
 #include <asm/delay.h>
@@ -66,7 +68,7 @@ static int ieee80211_sta_find_ibss(struc
 static int ieee80211_sta_wep_configured(struct net_device *dev);
 static int ieee80211_sta_start_scan(struct net_device *dev,
 				    u8 *ssid, size_t ssid_len);
-static void ieee80211_sta_reset_auth(struct net_device *dev,
+static int ieee80211_sta_config_auth(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta);
 
 
@@ -1924,8 +1926,9 @@ void ieee80211_sta_work(struct work_stru
 	}
 
 	if (test_and_clear_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request)) {
-		ifsta->state = IEEE80211_AUTHENTICATE;
-		ieee80211_sta_reset_auth(dev, ifsta);
+		if (ieee80211_sta_config_auth(dev, ifsta))
+			return;
+		clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
 	} else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request))
 		return;
 
@@ -1991,18 +1994,115 @@ static void ieee80211_sta_reset_auth(str
 }
 
 
-static void ieee80211_sta_new_auth(struct net_device *dev,
-				   struct ieee80211_if_sta *ifsta)
+void ieee80211_sta_req_auth(struct net_device *dev,
+			    struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->type != IEEE80211_IF_TYPE_STA)
 		return;
 
-	set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
-	schedule_work(&ifsta->work);
+	if ((ifsta->bssid_set || ifsta->auto_bssid_sel) &&
+	    (ifsta->ssid_set || ifsta->auto_ssid_sel)) {
+		set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
+		schedule_work(&ifsta->work);
+	}
 }
 
+static int ieee80211_sta_match_ssid(struct ieee80211_if_sta *ifsta,
+				    const char *ssid, int ssid_len)
+{
+	int tmp, hidden_ssid;
+
+	if (!memcmp(ifsta->ssid, ssid, ssid_len))
+		return 1;
+
+	if (ifsta->auto_bssid_sel)
+		return 0;
+
+	hidden_ssid = 1;
+	tmp = ssid_len;
+	while (tmp--) {
+		if (ssid[tmp] != '\0') {
+			hidden_ssid = 0;
+			break;
+		}
+	}
+
+	if (hidden_ssid && ifsta->ssid_len == ssid_len)
+		return 1;
+
+	if (ssid_len == 1 && ssid[0] == ' ')
+		return 1;
+
+	return 0;
+}
+
+static int ieee80211_sta_config_auth(struct net_device *dev,
+				     struct ieee80211_if_sta *ifsta)
+{
+	struct ieee80211_local *local = dev->ieee80211_ptr;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sta_bss *bss, *selected = NULL;
+	int top_rssi = 0, freq;
+
+	if (!ifsta->auto_channel_sel && !ifsta->auto_bssid_sel &&
+	    !ifsta->auto_ssid_sel) {
+		ifsta->state = IEEE80211_AUTHENTICATE;
+		ieee80211_sta_reset_auth(dev, ifsta);
+		return 0;
+	}
+
+	spin_lock_bh(&local->sta_bss_lock);
+	freq = local->oper_channel->freq;
+	list_for_each_entry(bss, &local->sta_bss_list, list) {
+		if (!(bss->capability & WLAN_CAPABILITY_ESS))
+			continue;
+
+		if (!!(bss->capability & WLAN_CAPABILITY_PRIVACY) ^
+		    !!sdata->default_key)
+			continue;
+
+		if (!ifsta->auto_channel_sel && bss->freq != freq)
+			continue;
+
+		if (!ifsta->auto_bssid_sel &&
+		    memcmp(bss->bssid, ifsta->bssid, ETH_ALEN))
+			continue;
+
+		if (!ifsta->auto_ssid_sel &&
+		    !ieee80211_sta_match_ssid(ifsta, bss->ssid, bss->ssid_len))
+			continue;
+
+		if (top_rssi < bss->rssi) {
+			selected = bss;
+			top_rssi = bss->rssi;
+		}
+	}
+	if (selected)
+		atomic_inc(&selected->users);
+	spin_unlock_bh(&local->sta_bss_lock);
+
+	if (selected) {
+		ieee80211_set_channel(local, -1, selected->freq);
+		if (!ifsta->ssid_set)
+			ieee80211_sta_set_ssid(dev, selected->ssid,
+					       selected->ssid_len);
+		ieee80211_sta_set_bssid(dev, selected->bssid);
+		ieee80211_rx_bss_put(dev, selected);
+		ifsta->state = IEEE80211_AUTHENTICATE;
+		ieee80211_sta_reset_auth(dev, ifsta);
+		return 0;
+	} else {
+		if (ifsta->state != IEEE80211_AUTHENTICATE) {
+			ieee80211_sta_start_scan(dev, NULL, 0);;
+			ifsta->state = IEEE80211_AUTHENTICATE;
+			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
+		} else
+			ifsta->state = IEEE80211_DISABLED;
+	}
+	return -1;
+}
 
 static int ieee80211_sta_join_ibss(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta,
@@ -2353,16 +2453,12 @@ int ieee80211_sta_set_ssid(struct net_de
 	memset(ifsta->ssid + len, 0, IEEE80211_MAX_SSID_LEN - len);
 	ifsta->ssid_len = len;
 
-	ifsta->ssid_set = 1;
+	ifsta->ssid_set = len ? 1 : 0;
 	if (sdata->type == IEEE80211_IF_TYPE_IBSS && !ifsta->bssid_set) {
 		ifsta->ibss_join_req = jiffies;
 		ifsta->state = IEEE80211_IBSS_SEARCH;
 		return ieee80211_sta_find_ibss(dev, ifsta);
 	}
-
-	if (ifsta->bssid_set && ifsta->state != IEEE80211_AUTHENTICATE)
-		ieee80211_sta_new_auth(dev, ifsta);
-
 	return 0;
 }
 
@@ -2396,13 +2492,10 @@ int ieee80211_sta_set_bssid(struct net_d
 		}
 	}
 
-	if (memcmp(bssid, "\x00\x00\x00\x00\x00\x00", ETH_ALEN) == 0)
+	if (!is_valid_ether_addr(bssid))
 		ifsta->bssid_set = 0;
 	else
 		ifsta->bssid_set = 1;
-	if (ifsta->ssid_set)
-		ieee80211_sta_new_auth(dev, ifsta);
-
 	return 0;
 }
 
@@ -2812,9 +2905,6 @@ int ieee80211_sta_set_extra_ie(struct ne
 	}
 	memcpy(ifsta->extra_ie, ie, len);
 	ifsta->extra_ie_len = len;
-	if (ifsta->bssid_set && ifsta->ssid_set &&
-	    ifsta->state != IEEE80211_AUTHENTICATE)
-		ieee80211_sta_new_auth(dev, ifsta);
 	return 0;
 }
 
-- 
1.3.0


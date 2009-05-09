Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35888 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZEISJE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2009 14:09:04 -0400
Subject: [PATCH] cfg80211: put wext data into substructure
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 09 May 2009 20:09:03 +0200
Message-Id: <1241892543.31262.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To make it more apparent in the code what is for wext
only (and needs to be #ifdef'ed) put all the info for
wext into a substruct in each wireless_dev.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |    6 +++-
 net/wireless/core.c    |    4 +--
 net/wireless/ibss.c    |   60 ++++++++++++++++++++++++-------------------------
 3 files changed, 36 insertions(+), 34 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-05-09 20:02:34.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-05-09 20:03:37.000000000 +0200
@@ -1145,8 +1145,10 @@ struct wireless_dev {
 
 #ifdef CONFIG_WIRELESS_EXT
 	/* wext data */
-	struct cfg80211_ibss_params wext;
-	u8 wext_bssid[ETH_ALEN];
+	struct {
+		struct cfg80211_ibss_params ibss;
+		u8 bssid[ETH_ALEN];
+	} wext;
 #endif
 };
 
--- wireless-testing.orig/net/wireless/core.c	2009-05-09 20:02:34.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-05-09 20:03:24.000000000 +0200
@@ -470,9 +470,9 @@ static int cfg80211_netdev_notifier_call
 #ifdef CONFIG_WIRELESS_EXT
 		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC)
 			break;
-		if (!dev->ieee80211_ptr->wext.ssid_len)
+		if (!dev->ieee80211_ptr->wext.ibss.ssid_len)
 			break;
-		cfg80211_join_ibss(rdev, dev, &dev->ieee80211_ptr->wext);
+		cfg80211_join_ibss(rdev, dev, &dev->ieee80211_ptr->wext.ibss);
 		break;
 #endif
 	case NETDEV_UNREGISTER:
--- wireless-testing.orig/net/wireless/ibss.c	2009-05-09 20:02:34.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-05-09 20:03:24.000000000 +0200
@@ -63,7 +63,7 @@ int cfg80211_join_ibss(struct cfg80211_r
 		return -EALREADY;
 
 #ifdef CONFIG_WIRELESS_EXT
-	wdev->wext.channel = params->channel;
+	wdev->wext.ibss.channel = params->channel;
 #endif
 	err = rdev->ops->join_ibss(&rdev->wiphy, dev, params);
 
@@ -90,7 +90,7 @@ void cfg80211_clear_ibss(struct net_devi
 	memset(wdev->bssid, 0, ETH_ALEN);
 #ifdef CONFIG_WIRELESS_EXT
 	if (!nowext)
-		wdev->wext.ssid_len = 0;
+		wdev->wext.ibss.ssid_len = 0;
 #endif
 }
 
@@ -116,11 +116,11 @@ static int cfg80211_ibss_wext_join(struc
 	enum ieee80211_band band;
 	int i;
 
-	if (!wdev->wext.beacon_interval)
-		wdev->wext.beacon_interval = 100;
+	if (!wdev->wext.ibss.beacon_interval)
+		wdev->wext.ibss.beacon_interval = 100;
 
 	/* try to find an IBSS channel if none requested ... */
-	if (!wdev->wext.channel) {
+	if (!wdev->wext.ibss.channel) {
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 			struct ieee80211_supported_band *sband;
 			struct ieee80211_channel *chan;
@@ -135,27 +135,27 @@ static int cfg80211_ibss_wext_join(struc
 					continue;
 				if (chan->flags & IEEE80211_CHAN_DISABLED)
 					continue;
-				wdev->wext.channel = chan;
+				wdev->wext.ibss.channel = chan;
 				break;
 			}
 
-			if (wdev->wext.channel)
+			if (wdev->wext.ibss.channel)
 				break;
 		}
 
-		if (!wdev->wext.channel)
+		if (!wdev->wext.ibss.channel)
 			return -EINVAL;
 	}
 
 	/* don't join -- SSID is not there */
-	if (!wdev->wext.ssid_len)
+	if (!wdev->wext.ibss.ssid_len)
 		return 0;
 
 	if (!netif_running(wdev->netdev))
 		return 0;
 
 	return cfg80211_join_ibss(wiphy_to_dev(wdev->wiphy),
-				  wdev->netdev, &wdev->wext);
+				  wdev->netdev, &wdev->wext.ibss);
 }
 
 int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
@@ -182,7 +182,7 @@ int cfg80211_ibss_wext_siwfreq(struct ne
 	     chan->flags & IEEE80211_CHAN_DISABLED))
 		return -EINVAL;
 
-	if (wdev->wext.channel == chan)
+	if (wdev->wext.ibss.channel == chan)
 		return 0;
 
 	if (wdev->ssid_len) {
@@ -193,11 +193,11 @@ int cfg80211_ibss_wext_siwfreq(struct ne
 	}
 
 	if (chan) {
-		wdev->wext.channel = chan;
-		wdev->wext.channel_fixed = true;
+		wdev->wext.ibss.channel = chan;
+		wdev->wext.ibss.channel_fixed = true;
 	} else {
 		/* cfg80211_ibss_wext_join will pick one if needed */
-		wdev->wext.channel_fixed = false;
+		wdev->wext.ibss.channel_fixed = false;
 	}
 
 	return cfg80211_ibss_wext_join(wiphy_to_dev(wdev->wiphy), wdev);
@@ -218,8 +218,8 @@ int cfg80211_ibss_wext_giwfreq(struct ne
 
 	if (wdev->current_bss)
 		chan = wdev->current_bss->channel;
-	else if (wdev->wext.channel)
-		chan = wdev->wext.channel;
+	else if (wdev->wext.ibss.channel)
+		chan = wdev->wext.ibss.channel;
 
 	if (chan) {
 		freq->m = chan->center_freq;
@@ -259,9 +259,9 @@ int cfg80211_ibss_wext_siwessid(struct n
 	if (len > 0 && ssid[len - 1] == '\0')
 		len--;
 
-	wdev->wext.ssid = wdev->ssid;
-	memcpy(wdev->wext.ssid, ssid, len);
-	wdev->wext.ssid_len = len;
+	wdev->wext.ibss.ssid = wdev->ssid;
+	memcpy(wdev->wext.ibss.ssid, ssid, len);
+	wdev->wext.ibss.ssid_len = len;
 
 	return cfg80211_ibss_wext_join(wiphy_to_dev(wdev->wiphy), wdev);
 }
@@ -284,10 +284,10 @@ int cfg80211_ibss_wext_giwessid(struct n
 		data->flags = 1;
 		data->length = wdev->ssid_len;
 		memcpy(ssid, wdev->ssid, data->length);
-	} else if (wdev->wext.ssid && wdev->wext.ssid_len) {
+	} else if (wdev->wext.ibss.ssid && wdev->wext.ibss.ssid_len) {
 		data->flags = 1;
-		data->length = wdev->wext.ssid_len;
-		memcpy(ssid, wdev->wext.ssid, data->length);
+		data->length = wdev->wext.ibss.ssid_len;
+		memcpy(ssid, wdev->wext.ibss.ssid, data->length);
 	}
 
 	return 0;
@@ -318,12 +318,12 @@ int cfg80211_ibss_wext_siwap(struct net_
 		bssid = NULL;
 
 	/* both automatic */
-	if (!bssid && !wdev->wext.bssid)
+	if (!bssid && !wdev->wext.ibss.bssid)
 		return 0;
 
 	/* fixed already - and no change */
-	if (wdev->wext.bssid && bssid &&
-	    compare_ether_addr(bssid, wdev->wext.bssid) == 0)
+	if (wdev->wext.ibss.bssid && bssid &&
+	    compare_ether_addr(bssid, wdev->wext.ibss.bssid) == 0)
 		return 0;
 
 	if (wdev->ssid_len) {
@@ -334,10 +334,10 @@ int cfg80211_ibss_wext_siwap(struct net_
 	}
 
 	if (bssid) {
-		memcpy(wdev->wext_bssid, bssid, ETH_ALEN);
-		wdev->wext.bssid = wdev->wext_bssid;
+		memcpy(wdev->wext.bssid, bssid, ETH_ALEN);
+		wdev->wext.ibss.bssid = wdev->wext.bssid;
 	} else
-		wdev->wext.bssid = NULL;
+		wdev->wext.ibss.bssid = NULL;
 
 	return cfg80211_ibss_wext_join(wiphy_to_dev(wdev->wiphy), wdev);
 }
@@ -356,8 +356,8 @@ int cfg80211_ibss_wext_giwap(struct net_
 
 	ap_addr->sa_family = ARPHRD_ETHER;
 
-	if (wdev->wext.bssid) {
-		memcpy(ap_addr->sa_data, wdev->wext.bssid, ETH_ALEN);
+	if (wdev->wext.ibss.bssid) {
+		memcpy(ap_addr->sa_data, wdev->wext.ibss.bssid, ETH_ALEN);
 		return 0;
 	}
 



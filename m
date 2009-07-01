Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbZGATfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:35:48 -0400
Message-Id: <20090701193419.629640616@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:26:48 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/20 v4] cfg80211: remove wireless_dev->bssid
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This variable isn't necessary -- the wext code keeps
track of the BSSID itself, and otherwise we have
current_bss.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |    1 -
 net/wireless/ibss.c    |   13 +++----------
 2 files changed, 3 insertions(+), 11 deletions(-)

--- wireless-testing.orig/net/wireless/ibss.c	2009-07-01 08:55:06.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-07-01 09:01:19.000000000 +0200
@@ -24,9 +24,6 @@ void cfg80211_ibss_joined(struct net_dev
 	if (WARN_ON(!wdev->ssid_len))
 		return;
 
-	if (memcmp(bssid, wdev->bssid, ETH_ALEN) == 0)
-		return;
-
 	bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
 			       wdev->ssid, wdev->ssid_len,
 			       WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
@@ -41,7 +38,6 @@ void cfg80211_ibss_joined(struct net_dev
 
 	cfg80211_hold_bss(bss);
 	wdev->current_bss = bss;
-	memcpy(wdev->bssid, bssid, ETH_ALEN);
 
 	nl80211_send_ibss_bssid(wiphy_to_dev(wdev->wiphy), dev, bssid, gfp);
 #ifdef CONFIG_WIRELESS_EXT
@@ -87,7 +83,6 @@ void cfg80211_clear_ibss(struct net_devi
 
 	wdev->current_bss = NULL;
 	wdev->ssid_len = 0;
-	memset(wdev->bssid, 0, ETH_ALEN);
 #ifdef CONFIG_WIRELESS_EXT
 	if (!nowext)
 		wdev->wext.ibss.ssid_len = 0;
@@ -356,12 +351,10 @@ int cfg80211_ibss_wext_giwap(struct net_
 
 	ap_addr->sa_family = ARPHRD_ETHER;
 
-	if (wdev->wext.ibss.bssid) {
+	if (wdev->current_bss)
+		memcpy(ap_addr->sa_data, wdev->current_bss->bssid, ETH_ALEN);
+	else
 		memcpy(ap_addr->sa_data, wdev->wext.ibss.bssid, ETH_ALEN);
-		return 0;
-	}
-
-	memcpy(ap_addr->sa_data, wdev->bssid, ETH_ALEN);
 	return 0;
 }
 /* temporary symbol - mark GPL - in the future the handler won't be */
--- wireless-testing.orig/include/net/cfg80211.h	2009-07-01 09:01:15.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-01 09:01:19.000000000 +0200
@@ -1170,7 +1170,6 @@ struct wireless_dev {
 
 	/* currently used for IBSS - might be rearranged in the future */
 	struct cfg80211_bss *current_bss;
-	u8 bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len;
 

-- 


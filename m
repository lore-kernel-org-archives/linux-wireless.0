Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38500 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZGBH6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 03:58:06 -0400
Subject: [PATCH] cfg80211: send events for userspace SME
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090701192641.072258140@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 09:58:04 +0200
Message-Id: <1246521484.16770.30.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the userspace SME is in control, we are currently not sending
events, but this means that any userspace applications using wext
or nl80211 to receive events will not know what's going on unless
they can also interpret the nl80211 assoc event. Since we have all
the required code, let the SME follow events from the userspace
SME, this even means that you will be refused to connect() while
the userspace SME is in control and connected.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/sme.c |   64 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 26 deletions(-)

--- wireless-testing.orig/net/wireless/sme.c	2009-07-02 09:56:39.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-07-02 09:56:43.000000000 +0200
@@ -287,6 +287,44 @@ static void __cfg80211_connect_result(st
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
 		return;
 
+	if (wdev->sme_state == CFG80211_SME_CONNECTED)
+		nl80211_send_roamed(wiphy_to_dev(wdev->wiphy), dev,
+				    bssid, req_ie, req_ie_len,
+				    resp_ie, resp_ie_len, gfp);
+	else
+		nl80211_send_connect_result(wiphy_to_dev(wdev->wiphy), dev,
+					    bssid, req_ie, req_ie_len,
+					    resp_ie, resp_ie_len,
+					    status, gfp);
+
+#ifdef CONFIG_WIRELESS_EXT
+	if (wextev) {
+		if (req_ie && status == WLAN_STATUS_SUCCESS) {
+			memset(&wrqu, 0, sizeof(wrqu));
+			wrqu.data.length = req_ie_len;
+			wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, req_ie);
+		}
+
+		if (resp_ie && status == WLAN_STATUS_SUCCESS) {
+			memset(&wrqu, 0, sizeof(wrqu));
+			wrqu.data.length = resp_ie_len;
+			wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, resp_ie);
+		}
+
+		memset(&wrqu, 0, sizeof(wrqu));
+		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+		if (bssid && status == WLAN_STATUS_SUCCESS)
+			memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
+		wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+	}
+#endif
+
+	if (status == WLAN_STATUS_SUCCESS &&
+	    wdev->sme_state == CFG80211_SME_IDLE) {
+		wdev->sme_state = CFG80211_SME_CONNECTED;
+		return;
+	}
+
 	if (wdev->sme_state != CFG80211_SME_CONNECTING)
 		return;
 
@@ -315,32 +353,6 @@ static void __cfg80211_connect_result(st
 
 	if (wdev->conn)
 		wdev->conn->state = CFG80211_CONN_IDLE;
-
-	nl80211_send_connect_result(wiphy_to_dev(wdev->wiphy), dev, bssid,
-				    req_ie, req_ie_len, resp_ie, resp_ie_len,
-				    status, gfp);
-
-#ifdef CONFIG_WIRELESS_EXT
-	if (wextev) {
-		if (req_ie && status == WLAN_STATUS_SUCCESS) {
-			memset(&wrqu, 0, sizeof(wrqu));
-			wrqu.data.length = req_ie_len;
-			wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, req_ie);
-		}
-
-		if (resp_ie && status == WLAN_STATUS_SUCCESS) {
-			memset(&wrqu, 0, sizeof(wrqu));
-			wrqu.data.length = resp_ie_len;
-			wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, resp_ie);
-		}
-
-		memset(&wrqu, 0, sizeof(wrqu));
-		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-		if (bssid && status == WLAN_STATUS_SUCCESS)
-			memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
-		wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
-	}
-#endif
 }
 
 void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,



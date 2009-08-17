Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55590 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZHQKWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 06:22:30 -0400
Subject: [PATCH] cfg80211: report userspace SME connected event properly
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 12:22:14 +0200
Message-Id: <1250504534.15103.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of hacking the event reporting into the
__cfg80211_connect_result() function which is also
invoked by others, set up things correctly and then
invoke that function, so that it can do more sanity
checking.

Also, it is currently not possible to get a ROAMED
event from the userspace SME anyway since we send
out a DISCONNECTED event when it disassociates and
then a new CONNECTED event on the next association.

Thanks to Zhu Yi for pointing out that the code is
somewhat convoluted and doesn't warn when it should.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/mlme.c |    9 +++++++++
 net/wireless/sme.c  |   22 ++++++----------------
 2 files changed, 15 insertions(+), 16 deletions(-)

--- wireless-testing.orig/net/wireless/mlme.c	2009-08-17 11:48:13.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-08-17 12:17:54.000000000 +0200
@@ -96,6 +96,15 @@ void cfg80211_send_rx_assoc(struct net_d
 		WARN_ON(!bss);
 	}
 
+	if (!wdev->conn && wdev->sme_state == CFG80211_SME_IDLE) {
+		/*
+		 * This is for the userspace SME, the CONNECTING
+		 * state will be changed to CONNECTED by
+		 * __cfg80211_connect_result() below.
+		 */
+		wdev->sme_state = CFG80211_SME_CONNECTING;
+	}
+
 	/* this consumes one bss reference (unless bss is NULL) */
 	__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, ie, len - ieoffs,
 				  status_code,
--- wireless-testing.orig/net/wireless/sme.c	2009-08-17 11:46:44.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-08-17 11:48:04.000000000 +0200
@@ -351,15 +351,13 @@ void __cfg80211_connect_result(struct ne
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
 		return;
 
-	if (wdev->sme_state == CFG80211_SME_CONNECTED)
-		nl80211_send_roamed(wiphy_to_dev(wdev->wiphy), dev,
+	if (WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTING))
+		return;
+
+	nl80211_send_connect_result(wiphy_to_dev(wdev->wiphy), dev,
 				    bssid, req_ie, req_ie_len,
-				    resp_ie, resp_ie_len, GFP_KERNEL);
-	else
-		nl80211_send_connect_result(wiphy_to_dev(wdev->wiphy), dev,
-					    bssid, req_ie, req_ie_len,
-					    resp_ie, resp_ie_len,
-					    status, GFP_KERNEL);
+				    resp_ie, resp_ie_len,
+				    status, GFP_KERNEL);
 
 #ifdef CONFIG_WIRELESS_EXT
 	if (wextev) {
@@ -392,13 +390,6 @@ void __cfg80211_connect_result(struct ne
 		wdev->current_bss = NULL;
 	}
 
-	if (status == WLAN_STATUS_SUCCESS &&
-	    wdev->sme_state == CFG80211_SME_IDLE)
-		goto success;
-
-	if (wdev->sme_state != CFG80211_SME_CONNECTING)
-		return;
-
 	if (wdev->conn)
 		wdev->conn->state = CFG80211_CONN_IDLE;
 
@@ -412,7 +403,6 @@ void __cfg80211_connect_result(struct ne
 		return;
 	}
 
- success:
 	if (!bss)
 		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
 				       wdev->ssid, wdev->ssid_len,



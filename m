Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47652 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbZGGVrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 17:47:23 -0400
Subject: [PATCH] cfg80211: fix two buglets
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 23:46:51 +0200
Message-Id: <1247003211.4755.54.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes two small bugs:
 1) the connect variable is already initialised, and the
    assignment to auth_type overwrites the previous setting
    with a wrong value
 2) when all authentication attempts fail, we need to report
    that we couldn't connect

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |    4 ----
 net/wireless/sme.c     |    5 ++---
 2 files changed, 2 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-07 23:39:04.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-07 23:39:05.000000000 +0200
@@ -3695,10 +3695,6 @@ static int nl80211_connect(struct sk_buf
 
 	wiphy = &rdev->wiphy;
 
-	connect.bssid = NULL;
-	connect.channel = NULL;
-	connect.auth_type = NL80211_AUTHTYPE_OPEN_SYSTEM;
-
 	if (info->attrs[NL80211_ATTR_MAC])
 		connect.bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
 	connect.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
--- wireless-testing.orig/net/wireless/sme.c	2009-07-07 23:39:01.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-07-07 23:39:05.000000000 +0200
@@ -296,9 +296,8 @@ void cfg80211_sme_rx_auth(struct net_dev
 		wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
 		schedule_work(&rdev->conn_work);
 	} else if (status_code != WLAN_STATUS_SUCCESS) {
-		wdev->sme_state = CFG80211_SME_IDLE;
-		kfree(wdev->conn);
-		wdev->conn = NULL;
+		__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, NULL, 0,
+					  status_code, false);
 	} else if (wdev->sme_state == CFG80211_SME_CONNECTING &&
 		 wdev->conn->state == CFG80211_CONN_AUTHENTICATING) {
 		wdev->conn->state = CFG80211_CONN_ASSOCIATE_NEXT;



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZDWIi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 04:38:59 -0400
Subject: [PATCH] mac80211: internally clear failed scans properly
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 10:38:26 +0200
Message-Id: <1240475906.30082.173.camel@johannes.local> (sfid-20090423_103902_328111_22848920)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the IBSS code wants to scan, but that fails, we can
get stuck in a situation where you can never scan again.
Fix this by properly notifying ourselves when the scan
request has failed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ibss.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2009-04-23 10:33:18.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-04-23 10:33:19.000000000 +0200
@@ -447,7 +447,8 @@ static void ieee80211_sta_merge_ibss(str
 	memcpy(sdata->local->int_scan_req.ssids[0].ssid,
 	       ifibss->ssid, IEEE80211_MAX_SSID_LEN);
 	sdata->local->int_scan_req.ssids[0].ssid_len = ifibss->ssid_len;
-	ieee80211_request_scan(sdata, &sdata->local->int_scan_req);
+	if (ieee80211_request_scan(sdata, &sdata->local->int_scan_req))
+		ieee80211_scan_failed(sdata->local);
 }
 
 static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
@@ -565,7 +566,8 @@ static void ieee80211_sta_find_ibss(stru
 		       ifibss->ssid, IEEE80211_MAX_SSID_LEN);
 		local->int_scan_req.ssids[0].ssid_len =
 			ifibss->ssid_len;
-		ieee80211_request_scan(sdata, &local->int_scan_req);
+		if (ieee80211_request_scan(sdata, &local->int_scan_req))
+			ieee80211_scan_failed(local);
 	} else if (ifibss->state != IEEE80211_IBSS_MLME_JOINED) {
 		int interval = IEEE80211_SCAN_INTERVAL;
 



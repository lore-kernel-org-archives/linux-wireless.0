Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39275 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYIHP62 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:58:28 -0400
Subject: [PATCH 10/8] mac80211: simplify scan start
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080908154421.216772000@sipsolutions.net> (sfid-20080908_174606_739824_DD7A31F6)
References: <20080908154421.216772000@sipsolutions.net>
	 (sfid-20080908_174606_739824_DD7A31F6)
Content-Type: text/plain
Date: Mon, 08 Sep 2008 17:58:23 +0200
Message-Id: <1220889503.31304.80.camel@johannes.berg> (sfid-20080908_175835_874836_5139DE4A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_sta_start_scan() can very well take a non-NULL
ssid pointer with a zero ssid_len.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-08 17:56:39.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 17:56:54.000000000 +0200
@@ -3053,10 +3053,7 @@ void ieee80211_sta_work(struct work_stru
 	    ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
 	    ifsta->state != IEEE80211_STA_MLME_ASSOCIATE &&
 	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
-		if (ifsta->scan_ssid_len)
-			ieee80211_sta_start_scan(sdata, ifsta->scan_ssid, ifsta->scan_ssid_len);
-		else
-			ieee80211_sta_start_scan(sdata, NULL, 0);
+		ieee80211_sta_start_scan(sdata, ifsta->scan_ssid, ifsta->scan_ssid_len);
 		return;
 	}
 



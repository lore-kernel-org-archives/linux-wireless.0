Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36921 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbZGJPZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 11:25:29 -0400
Subject: [PATCH] cfg80211: fix wext stats
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 16:54:07 +0200
Message-Id: <1247237647.29747.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using the wext BSSID which may be NULL if
you haven't explicitly set one, we should instead use
the current_bss pointer -- if that's NULL we aren't
connected anyway. Fixes missing signal quality output
reported to me internally at Intel.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext-compat.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/wireless/wext-compat.c	2009-07-10 16:24:14.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-07-10 16:32:04.000000000 +0200
@@ -1209,7 +1209,7 @@ struct iw_statistics *cfg80211_wireless_
 	/* we are under RTNL - globally locked - so can use static structs */
 	static struct iw_statistics wstats;
 	static struct station_info sinfo;
-	u8 *addr;
+	u8 bssid[ETH_ALEN];
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION)
 		return NULL;
@@ -1217,11 +1217,16 @@ struct iw_statistics *cfg80211_wireless_
 	if (!rdev->ops->get_station)
 		return NULL;
 
-	addr = wdev->wext.connect.bssid;
-	if (!addr)
+	/* Grab BSSID of current BSS, if any */
+	wdev_lock(wdev);
+	if (!wdev->current_bss) {
+		wdev_unlock(wdev);
 		return NULL;
+	}
+	memcpy(bssid, wdev->current_bss->pub.bssid, ETH_ALEN);
+	wdev_unlock(wdev);
 
-	if (rdev->ops->get_station(&rdev->wiphy, dev, addr, &sinfo))
+	if (rdev->ops->get_station(&rdev->wiphy, dev, bssid, &sinfo))
 		return NULL;
 
 	memset(&wstats, 0, sizeof(wstats));



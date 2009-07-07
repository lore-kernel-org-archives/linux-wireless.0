Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57134 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZGGVmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 17:42:03 -0400
Subject: [PATCH] cfg80211: fix race in giwrate
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 23:41:27 +0200
Message-Id: <1247002887.4755.48.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_wext_giwrate doesn't lock the wdev, so it
cannot access current_bss race-free. Also, there's
little point in trying to ask the driver for an AP
that it never told us about, so avoid that case.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext-compat.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/wireless/wext-compat.c	2009-07-07 23:39:01.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-07-07 23:39:11.000000000 +0200
@@ -1127,7 +1127,7 @@ int cfg80211_wext_giwrate(struct net_dev
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	/* we are under RTNL - globally locked - so can use a static struct */
 	static struct station_info sinfo;
-	u8 *addr;
+	u8 addr[ETH_ALEN];
 	int err;
 
 	if (wdev->iftype != NL80211_IFTYPE_STATION)
@@ -1136,12 +1136,15 @@ int cfg80211_wext_giwrate(struct net_dev
 	if (!rdev->ops->get_station)
 		return -EOPNOTSUPP;
 
+	err = 0;
+	wdev_lock(wdev);
 	if (wdev->current_bss)
-		addr = wdev->current_bss->pub.bssid;
-	else if (wdev->wext.connect.bssid)
-		addr = wdev->wext.connect.bssid;
+		memcpy(addr, wdev->current_bss->pub.bssid, ETH_ALEN);
 	else
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+	wdev_unlock(wdev);
+	if (err)
+		return err;
 
 	err = rdev->ops->get_station(&rdev->wiphy, dev, addr, &sinfo);
 	if (err)



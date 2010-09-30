Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab0I3URK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 16:17:10 -0400
Subject: [PATCH] cfg80211: fix locking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 22:17:43 +0200
Message-ID: <1285877863.5137.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add missing unlocking of the wiphy in set_channel,
and don't try to unlock a non-existing wiphy in
set_cqm.

Cc: stable@kernel.org [2.6.35+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2010-09-30 22:10:42.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-09-30 22:17:10.000000000 +0200
@@ -821,11 +821,13 @@ static int nl80211_set_channel(struct sk
 
 	result = get_rdev_dev_by_info_ifindex(info, &rdev, &netdev);
 	if (result)
-		goto unlock;
+		goto unlock_rtnl;
 
 	result = __nl80211_set_channel(rdev, netdev->ieee80211_ptr, info);
 
- unlock:
+	dev_put(netdev);
+	cfg80211_unlock_rdev(rdev);
+ unlock_rtnl:
 	rtnl_unlock();
 
 	return result;
@@ -5095,7 +5097,7 @@ static int nl80211_set_cqm_rssi(struct g
 
 	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
-		goto unlock_rdev;
+		goto unlock_rtnl;
 
 	wdev = dev->ieee80211_ptr;
 
@@ -5113,9 +5115,10 @@ static int nl80211_set_cqm_rssi(struct g
 	err = rdev->ops->set_cqm_rssi_config(wdev->wiphy, dev,
 					     threshold, hysteresis);
 
-unlock_rdev:
+ unlock_rdev:
 	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
+ unlock_rtnl:
 	rtnl_unlock();
 
 	return err;



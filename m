Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3FDUW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 16:22:59 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix potential deadlock regression
Date: Tue,  4 Jun 2013 22:22:50 +0200
Message-Id: <1370377370-23055-1-git-send-email-johannes@sipsolutions.net> (sfid-20130604_222302_547381_9A036ACD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My big locking cleanups caused a problem by registering the
rfkill instance with the RTNL held, while the callback also
acquires the RTNL. This potentially causes a deadlock since
the two locks used (rfkill mutex and RTNL) can be acquired
in two different orders. Fix this by (un)registering rfkill
without holding the RTNL. This needs to be done after the
device struct is registered, but that can also be done w/o
holding the RTNL.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 221e76b..99d86dd 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -555,14 +555,18 @@ int wiphy_register(struct wiphy *wiphy)
 	/* check and set up bitrates */
 	ieee80211_set_bitrate_flags(wiphy);
 
-	rtnl_lock();
 
 	res = device_add(&rdev->wiphy.dev);
+	if (res)
+		return res;
+
+	res = rfkill_register(rdev->rfkill);
 	if (res) {
-		rtnl_unlock();
+		device_del(&rdev->wiphy.dev);
 		return res;
 	}
 
+	rtnl_lock();
 	/* set up regulatory info */
 	wiphy_regulatory_register(wiphy);
 
@@ -589,17 +593,6 @@ int wiphy_register(struct wiphy *wiphy)
 
 	cfg80211_debugfs_rdev_add(rdev);
 
-	res = rfkill_register(rdev->rfkill);
-	if (res) {
-		device_del(&rdev->wiphy.dev);
-
-		debugfs_remove_recursive(rdev->wiphy.debugfsdir);
-		list_del_rcu(&rdev->list);
-		wiphy_regulatory_deregister(wiphy);
-		rtnl_unlock();
-		return res;
-	}
-
 	rdev->wiphy.registered = true;
 	rtnl_unlock();
 	return 0;
@@ -636,11 +629,11 @@ void wiphy_unregister(struct wiphy *wiphy)
 		rtnl_unlock();
 		__count == 0; }));
 
+	rfkill_unregister(rdev->rfkill);
+
 	rtnl_lock();
 	rdev->wiphy.registered = false;
 
-	rfkill_unregister(rdev->rfkill);
-
 	BUG_ON(!list_empty(&rdev->wdev_list));
 
 	/*
-- 
1.8.0


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42964 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759759AbZFJPcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 11:32:23 -0400
Subject: [PATCH] cfg80211: fix rfkill locking problem
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 16:50:29 +0200
Message-Id: <1244645429.26814.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rfkill currently requires a global lock within the
rfkill_register() function, and holds that lock over
calls to the set_block() methods. This means that we
cannot hold a lock around rfkill_register() that we
also require in set_block(), directly or indirectly.
Fix cfg80211 to register rfkill outside the block
locked by its global lock. Much of what cfg80211 does
in the locked block doesn't need to be locked anyway.

Reported-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-06-10 16:38:54.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-06-10 16:41:48.000000000 +0200
@@ -395,21 +395,23 @@ int wiphy_register(struct wiphy *wiphy)
 	/* check and set up bitrates */
 	ieee80211_set_bitrate_flags(wiphy);
 
-	mutex_lock(&cfg80211_mutex);
-
-	/* set up regulatory info */
-	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
-
 	res = device_add(&drv->wiphy.dev);
 	if (res)
-		goto out_unlock;
+		return res;
 
 	res = rfkill_register(drv->rfkill);
 	if (res)
 		goto out_rm_dev;
 
+	mutex_lock(&cfg80211_mutex);
+
+	/* set up regulatory info */
+	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
+
 	list_add(&drv->list, &cfg80211_drv_list);
 
+	mutex_unlock(&cfg80211_mutex);
+
 	/* add to debugfs */
 	drv->wiphy.debugfsdir =
 		debugfs_create_dir(wiphy_name(&drv->wiphy),
@@ -430,13 +432,10 @@ int wiphy_register(struct wiphy *wiphy)
 
 	cfg80211_debugfs_drv_add(drv);
 
-	res = 0;
-	goto out_unlock;
+	return 0;
 
  out_rm_dev:
 	device_del(&drv->wiphy.dev);
- out_unlock:
-	mutex_unlock(&cfg80211_mutex);
 	return res;
 }
 EXPORT_SYMBOL(wiphy_register);



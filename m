Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbZGMLYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 07:24:46 -0400
Subject: [PATCH] cfg80211: fix unregistration
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 13:24:44 +0200
Message-Id: <1247484284.4166.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The work that we cancel there requires the cfg80211_mutex,
so we can't cancel it under the mutex, which is fine, we
can just move it to after the locked section.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-07-13 13:07:44.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-13 13:08:31.000000000 +0200
@@ -586,11 +586,6 @@ void wiphy_unregister(struct wiphy *wiph
 	/* unlock again before freeing */
 	mutex_unlock(&rdev->mtx);
 
-	cancel_work_sync(&rdev->conn_work);
-	cancel_work_sync(&rdev->scan_done_wk);
-	kfree(rdev->scan_req);
-	flush_work(&rdev->event_work);
-
 	cfg80211_debugfs_rdev_del(rdev);
 
 	/* If this device got a regulatory hint tell core its
@@ -602,6 +597,11 @@ void wiphy_unregister(struct wiphy *wiph
 	debugfs_remove(rdev->wiphy.debugfsdir);
 
 	mutex_unlock(&cfg80211_mutex);
+
+	cancel_work_sync(&rdev->conn_work);
+	cancel_work_sync(&rdev->scan_done_wk);
+	kfree(rdev->scan_req);
+	flush_work(&rdev->event_work);
 }
 EXPORT_SYMBOL(wiphy_unregister);
 



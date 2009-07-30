Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39204 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZG3MEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 08:04:35 -0400
Subject: [PATCH] cfg80211: fix NETDEV_UNREGISTER notifier
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 14:04:01 +0200
Message-Id: <1248955441.29062.37.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's possible to get the NETDEV_UNREGISTER callback multiple
times (see net/core/dev.c:netdev_wait_allrefs) and this will
completely mess up our cleanup code. To avoid that, clean up
only when the interface is still on the wiphy interface list
from which it's removed on the first NETDEV_UNREGISTER call.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-07-30 13:41:26.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-30 13:52:59.000000000 +0200
@@ -725,15 +725,22 @@ static int cfg80211_netdev_notifier_call
 		break;
 	case NETDEV_UNREGISTER:
 		mutex_lock(&rdev->devlist_mtx);
+		/*
+		 * It is possible to get NETDEV_UNREGISTER
+		 * multiple times. To detect that, check
+		 * that the interface is still on the list
+		 * of registered interfaces, and only then
+		 * remove and clean it up.
+		 */
 		if (!list_empty(&wdev->list)) {
 			sysfs_remove_link(&dev->dev.kobj, "phy80211");
 			list_del_init(&wdev->list);
-		}
-		mutex_unlock(&rdev->devlist_mtx);
-		mutex_destroy(&wdev->mtx);
+			mutex_destroy(&wdev->mtx);
 #ifdef CONFIG_WIRELESS_EXT
-		kfree(wdev->wext.keys);
+			kfree(wdev->wext.keys);
 #endif
+		}
+		mutex_unlock(&rdev->devlist_mtx);
 		break;
 	case NETDEV_PRE_UP:
 		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbXCHPce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 10:32:34 -0500
Subject: [PATCH] make netdev unregister notifier idempotent
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200703061907.19929.mb@bu3sch.de>
References: <200703061907.19929.mb@bu3sch.de>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 02:19:02 +0100
Message-Id: <1173316742.3546.39.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to the fact that other things may hold a netdev open and the kernel
retries to call all notifiers again and again until the netdev's
refcount reaches 0, the notifier must be idempotent. This patch achieves
that by re-initialising the list and checking whether it is empty.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/wireless/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- wireless-dev.orig/net/wireless/core.c	2007-03-08 02:07:12.703607522 +0100
+++ wireless-dev/net/wireless/core.c	2007-03-08 02:08:59.503607522 +0100
@@ -290,8 +290,10 @@ static int cfg80211_netdev_notifier_call
 		break;
 	case NETDEV_UNREGISTER:
 		mutex_lock(&rdev->devlist_mtx);
-		sysfs_remove_link(&dev->dev.kobj, "phy80211");
-		list_del(&dev->ieee80211_ptr->list);
+		if (!list_empty(&dev->ieee80211_ptr->list)) {
+			sysfs_remove_link(&dev->dev.kobj, "phy80211");
+			list_del_init(&dev->ieee80211_ptr->list);
+		}
 		mutex_unlock(&rdev->devlist_mtx);
 		break;
 	}



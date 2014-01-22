Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12269 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbaAVJQg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:16:36 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: fix scan done race
Date: Wed, 22 Jan 2014 11:14:18 +0200
Message-Id: <1390382059-16689-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140122_101642_122709_2B93E624)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an interface/wdev is removed, any ongoing scan should be
cancelled by the driver. This will make it call cfg80211, which
only queues a work struct. If interface/wdev removal is quick
enough, this can leave the scan request pending and processed
only after the interface is gone, causing a use-after-free.

Fix this by making sure the scan request is not pending after
the interface is destroyed. We can't flush or cancel the work
item due to locking concerns, but when it'll run it shouldn't
find anything to do. This leaves a potential issue, if a new
scan gets requested before the work runs, it prematurely stops
the running scan, potentially causing another crash. I'll fix
that in the next patch.

This was particularly observed with P2P_DEVICE wdevs, likely
because freeing them is quicker than freeing netdevs.

Reported-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Fixes: 4a58e7c38443 ("cfg80211: don't "leak" uncompleted scans")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 10b30c4..98eefd3 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -209,8 +209,11 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 
 	rdev->opencount--;
 
-	WARN_ON(rdev->scan_req && rdev->scan_req->wdev == wdev &&
-		!rdev->scan_req->notified);
+	if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
+		if (WARN_ON(!rdev->scan_req->notified))
+			rdev->scan_req->aborted = true;
+		___cfg80211_scan_done(rdev);
+	}
 }
 
 static int cfg80211_rfkill_set_block(void *data, bool blocked)
@@ -899,8 +902,11 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		break;
 	case NETDEV_DOWN:
 		cfg80211_update_iface_num(rdev, wdev->iftype, -1);
-		WARN_ON(rdev->scan_req && rdev->scan_req->wdev == wdev &&
-			!rdev->scan_req->notified);
+		if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
+			if (WARN_ON(!rdev->scan_req->notified))
+				rdev->scan_req->aborted = true;
+			___cfg80211_scan_done(rdev);
+		}
 
 		if (WARN_ON(rdev->sched_scan_req &&
 			    rdev->sched_scan_req->dev == wdev->netdev)) {
-- 
1.8.3.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48478 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933153AbdAEKAY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 05:00:24 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: fix sched scan netlink socket owner destruction
Date: Thu,  5 Jan 2017 11:00:12 +0100
Message-Id: <20170105100012.6884-1-johannes@sipsolutions.net> (sfid-20170105_110133_229815_B987C0AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A single netlink socket might own multiple interfaces *and* a
scheduled scan request (which might belong to another interface),
so when it goes away both may need to be destroyed.

Remove the schedule_scan_stop indirection to fix this - it's only
needed for interface destruction because of the way this works
right now, with a single work taking care of all interfaces.

Cc: stable@vger.kernel.org
Fixes: 93a1e86ce10e4 ("nl80211: Stop scheduled scan if netlink client disappears")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3df85a751a85..ef5eff93a8b8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14502,13 +14502,17 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 
 	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
 		bool schedule_destroy_work = false;
-		bool schedule_scan_stop = false;
 		struct cfg80211_sched_scan_request *sched_scan_req =
 			rcu_dereference(rdev->sched_scan_req);
 
 		if (sched_scan_req && notify->portid &&
-		    sched_scan_req->owner_nlportid == notify->portid)
-			schedule_scan_stop = true;
+		    sched_scan_req->owner_nlportid == notify->portid) {
+			sched_scan_req->owner_nlportid = 0;
+
+			if (rdev->ops->sched_scan_stop &&
+			    rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
+				schedule_work(&rdev->sched_scan_stop_wk);
+		}
 
 		list_for_each_entry_rcu(wdev, &rdev->wiphy.wdev_list, list) {
 			cfg80211_mlme_unregister_socket(wdev, notify->portid);
@@ -14539,12 +14543,6 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 				spin_unlock(&rdev->destroy_list_lock);
 				schedule_work(&rdev->destroy_work);
 			}
-		} else if (schedule_scan_stop) {
-			sched_scan_req->owner_nlportid = 0;
-
-			if (rdev->ops->sched_scan_stop &&
-			    rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
-				schedule_work(&rdev->sched_scan_stop_wk);
 		}
 	}
 
-- 
2.9.3

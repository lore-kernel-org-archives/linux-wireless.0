Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208Ab3B0PAy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 10:00:54 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 2/8] cfg80211/mac80211: handle wowlan failure during suspend
Date: Wed, 27 Feb 2013 16:00:36 +0100
Message-Id: <1361977242-17344-2-git-send-email-sgruszka@redhat.com> (sfid-20130227_160057_562948_B23D9C9B)
In-Reply-To: <1361977242-17344-1-git-send-email-sgruszka@redhat.com>
References: <1361977242-17344-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers can refuse to configure wowlan, handle that situation in
cfg80211.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/pm.c       |  2 +-
 net/wireless/rdev-ops.h |  7 ++++---
 net/wireless/sysfs.c    | 23 ++++++++++++++++-------
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index d0275f3..4d105c7 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -93,7 +93,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 			return err;
 		} else if (err > 0) {
 			WARN_ON(err != 1);
-			local->wowlan = false;
+			return err;
 		} else {
 			list_for_each_entry(sdata, &local->interfaces, list)
 				if (ieee80211_sdata_running(sdata))
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 422d382..f800168 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -6,11 +6,12 @@
 #include "core.h"
 #include "trace.h"
 
-static inline int rdev_suspend(struct cfg80211_registered_device *rdev)
+static inline int rdev_suspend(struct cfg80211_registered_device *rdev,
+			       struct cfg80211_wowlan *wowlan)
 {
 	int ret;
-	trace_rdev_suspend(&rdev->wiphy, rdev->wowlan);
-	ret = rdev->ops->suspend(&rdev->wiphy, rdev->wowlan);
+	trace_rdev_suspend(&rdev->wiphy, wowlan);
+	ret = rdev->ops->suspend(&rdev->wiphy, wowlan);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 7de8092..99e72a7 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -83,23 +83,32 @@ static int wiphy_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
+static void cfg80211_leave_all(struct cfg80211_registered_device *rdev)
+{
+	struct wireless_dev *wdev;
+
+	list_for_each_entry_rcu(wdev, &rdev->wdev_list, list)
+		cfg80211_leave(rdev, wdev);
+}
+
 static int wiphy_suspend(struct device *dev, pm_message_t state)
 {
 	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
-	struct wireless_dev *wdev;
 	int ret = 0;
 
 	rdev->suspend_at = get_seconds();
 
 	rtnl_lock();
 	if (rdev->wiphy.registered) {
-		if (!rdev->wowlan) {
-			list_for_each_entry_rcu(wdev, &rdev->wdev_list, list)
-				cfg80211_leave(rdev, wdev);
-		}
-
+		if (!rdev->wowlan)
+			cfg80211_leave_all(rdev);
 		if (rdev->ops->suspend)
-			ret = rdev_suspend(rdev);
+			ret = rdev_suspend(rdev, rdev->wowlan);
+		if (ret == 1) {
+			/* Driver refuse to configure wowlan */
+			cfg80211_leave_all(rdev);
+			ret = rdev_suspend(rdev, NULL);
+		}
 	}
 	rtnl_unlock();
 
-- 
1.7.11.7


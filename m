Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3BAAOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 19:14:17 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: move locking into cfg80211_bss_age
Date: Fri,  1 Feb 2013 01:14:37 +0100
Message-Id: <1359677677-22891-1-git-send-email-johannes@sipsolutions.net> (sfid-20130201_011420_099121_A624F42E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no reason for it to require external
locking, move it into the function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c  | 3 ++-
 net/wireless/sysfs.c | 2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index cae380f..05dbc5b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -231,15 +231,16 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
-/* must hold dev->bss_lock! */
 void cfg80211_bss_age(struct cfg80211_registered_device *dev,
                       unsigned long age_secs)
 {
 	struct cfg80211_internal_bss *bss;
 	unsigned long age_jiffies = msecs_to_jiffies(age_secs * MSEC_PER_SEC);
 
+	spin_lock_bh(&dev->bss_lock);
 	list_for_each_entry(bss, &dev->bss_list, list)
 		bss->ts -= age_jiffies;
+	spin_unlock_bh(&dev->bss_lock);
 }
 
 void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 9bf6d5e..73bf39f 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -108,9 +108,7 @@ static int wiphy_resume(struct device *dev)
 	int ret = 0;
 
 	/* Age scan results with time spent in suspend */
-	spin_lock_bh(&rdev->bss_lock);
 	cfg80211_bss_age(rdev, get_seconds() - rdev->suspend_at);
-	spin_unlock_bh(&rdev->bss_lock);
 
 	if (rdev->ops->resume) {
 		rtnl_lock();
-- 
1.8.0


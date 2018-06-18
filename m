Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:42161 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754601AbeFRPM5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 11:12:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Denis Kenzior <denkenz@gmail.com>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] cfg80211: track time using boottime
Date: Mon, 18 Jun 2018 17:11:14 +0200
Message-Id: <20180618151142.1214422-1-arnd@arndb.de> (sfid-20180618_171440_482149_77843FD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The cfg80211 layer uses get_seconds() to read the current time
in its supend handling. This function is deprecated because of the 32-bit
time_t overflow, and it can cause unexpected behavior when the time
changes due to settimeofday() calls or leap second updates.

In many cases, we want to use monotonic time instead, however cfg80211
explicitly tracks the time spent in suspend, so this changes the
driver over to use ktime_get_boottime_seconds(), which is slightly
slower, but not used in a fastpath here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/wireless/core.h  | 2 +-
 net/wireless/sysfs.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 63eb1b5fdd04..7f52ef569320 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -76,7 +76,7 @@ struct cfg80211_registered_device {
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
 	struct sk_buff *scan_msg;
 	struct list_head sched_scan_req_list;
-	unsigned long suspend_at;
+	time64_t suspend_at;
 	struct work_struct scan_done_wk;
 
 	struct genl_info *cur_cmd_info;
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 570a2b67ca10..6ab32f6a1961 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -102,7 +102,7 @@ static int wiphy_suspend(struct device *dev)
 	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
 	int ret = 0;
 
-	rdev->suspend_at = get_seconds();
+	rdev->suspend_at = ktime_get_boottime_seconds();
 
 	rtnl_lock();
 	if (rdev->wiphy.registered) {
@@ -130,7 +130,7 @@ static int wiphy_resume(struct device *dev)
 	int ret = 0;
 
 	/* Age scan results with time spent in suspend */
-	cfg80211_bss_age(rdev, get_seconds() - rdev->suspend_at);
+	cfg80211_bss_age(rdev, ktime_get_boottime_seconds() - rdev->suspend_at);
 
 	rtnl_lock();
 	if (rdev->wiphy.registered && rdev->ops->resume)
-- 
2.9.0

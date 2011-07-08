Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:38046 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856Ab1GHIQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 04:16:25 -0400
Received: by mail-bw0-f54.google.com with SMTP id 20so3042135bwa.27
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jul 2011 01:16:23 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] cfg80211: return -ENOENT when stopping sched_scan while not running
Date: Fri,  8 Jul 2011 11:16:16 +0300
Message-Id: <1310112976-1674-1-git-send-email-coelho@ti.com> (sfid-20110708_101629_871656_B1DE9B05)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we try to stop a scheduled scan while it is not running, we should
return -ENOENT instead of simply ignoring the command and returning
success.  This is more consistent with other parts of the code.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 include/linux/nl80211.h |    3 ++-
 net/wireless/scan.c     |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3ec2f94..8cb025a 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -247,7 +247,8 @@
  *	passed, all channels allowed for the current regulatory domain
  *	are used.  Extra IEs can also be passed from the userspace by
  *	using the %NL80211_ATTR_IE attribute.
- * @NL80211_CMD_STOP_SCHED_SCAN: stop a scheduled scan
+ * @NL80211_CMD_STOP_SCHED_SCAN: stop a scheduled scan.  Returns -ENOENT
+ *	if scheduled scan is not running.
  * @NL80211_CMD_SCHED_SCAN_RESULTS: indicates that there are scheduled scan
  *	results available.
  * @NL80211_CMD_SCHED_SCAN_STOPPED: indicates that the scheduled scan has
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 2cc9d4a..1c4672e 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -137,7 +137,7 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 	lockdep_assert_held(&rdev->sched_scan_mtx);
 
 	if (!rdev->sched_scan_req)
-		return 0;
+		return -ENOENT;
 
 	dev = rdev->sched_scan_req->dev;
 
-- 
1.7.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:45850 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab3LEQaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 11:30:23 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so3245544eek.39
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 08:30:22 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 4/4] cfg80211: don't "leak" uncompleted scans
Date: Thu,  5 Dec 2013 18:30:17 +0200
Message-Id: <1386261017-5513-1-git-send-email-eliad@wizery.com> (sfid-20131205_173027_450166_777532F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

___cfg80211_scan_done() can be called in some cases
(e.g. on NETDEV_DOWN) before the low level driver
notified scan completion (which is indicated by
passing leak=true).

Clearing rdev->scan_req in this case is buggy, as
scan_done_wk might have already being queued/running
(and can't be flushed as it takes rtnl()).

If a new scan will be requested at this stage, the
scan_done_wk will try freeing it (instead of the
previous scan), and this will later result in
a use after free.

Simply remove the "leak" option, and replace it with
a standard WARN_ON.

An example backtrace after such crash:
Unable to handle kernel paging request at virtual address fffffee5
pgd = c0004000
[fffffee5] *pgd=9fdf6821, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] SMP ARM
PC is at cfg80211_scan_done+0x28/0xc4 [cfg80211]
LR is at __ieee80211_scan_completed+0xe4/0x2dc [mac80211]
[<bf0077b0>] (cfg80211_scan_done+0x28/0xc4 [cfg80211])
[<bf0973d4>] (__ieee80211_scan_completed+0xe4/0x2dc [mac80211])
[<bf0982cc>] (ieee80211_scan_work+0x94/0x4f0 [mac80211])
[<c005fd10>] (process_one_work+0x1b0/0x4a8)
[<c0060404>] (worker_thread+0x138/0x37c)
[<c0066d70>] (kthread+0xa4/0xb0)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/wireless/core.c | 20 ++++----------------
 net/wireless/core.h |  2 +-
 net/wireless/scan.c | 16 +++-------------
 3 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index a8e48c7..1f6ad1d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -203,17 +203,8 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 
 	rdev->opencount--;
 
-	if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
-		/*
-		 * If the scan request wasn't notified as done, set it
-		 * to aborted and leak it after a warning. The driver
-		 * should have notified us that it ended at the latest
-		 * during rdev_stop_p2p_device().
-		 */
-		if (WARN_ON(!rdev->scan_req->notified))
-			rdev->scan_req->aborted = true;
-		___cfg80211_scan_done(rdev, !rdev->scan_req->notified);
-	}
+	WARN_ON(rdev->scan_req && rdev->scan_req->wdev == wdev &&
+		!rdev->scan_req->notified);
 }
 
 static int cfg80211_rfkill_set_block(void *data, bool blocked)
@@ -870,11 +861,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		break;
 	case NETDEV_DOWN:
 		cfg80211_update_iface_num(rdev, wdev->iftype, -1);
-		if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
-			if (WARN_ON(!rdev->scan_req->notified))
-				rdev->scan_req->aborted = true;
-			___cfg80211_scan_done(rdev, true);
-		}
+		WARN_ON(rdev->scan_req && rdev->scan_req->wdev == wdev &&
+			!rdev->scan_req->notified);
 
 		if (WARN_ON(rdev->sched_scan_req &&
 			    rdev->sched_scan_req->dev == wdev->netdev)) {
diff --git a/net/wireless/core.h b/net/wireless/core.h
index eb0f7a3..04a2022 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -364,7 +364,7 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
 				   bool pairwise, const u8 *mac_addr);
 void __cfg80211_scan_done(struct work_struct *wk);
-void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak);
+void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev);
 void __cfg80211_sched_scan_results(struct work_struct *wk);
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d960e4a..ae21156 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -161,7 +161,7 @@ static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
 		dev->bss_generation++;
 }
 
-void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
+void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev)
 {
 	struct cfg80211_scan_request *request;
 	struct wireless_dev *wdev;
@@ -210,17 +210,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 		dev_put(wdev->netdev);
 
 	rdev->scan_req = NULL;
-
-	/*
-	 * OK. If this is invoked with "leak" then we can't
-	 * free this ... but we've cleaned it up anyway. The
-	 * driver failed to call the scan_done callback, so
-	 * all bets are off, it might still be trying to use
-	 * the scan request or not ... if it accesses the dev
-	 * in there (it shouldn't anyway) then it may crash.
-	 */
-	if (!leak)
-		kfree(request);
+	kfree(request);
 }
 
 void __cfg80211_scan_done(struct work_struct *wk)
@@ -231,7 +221,7 @@ void __cfg80211_scan_done(struct work_struct *wk)
 			    scan_done_wk);
 
 	rtnl_lock();
-	___cfg80211_scan_done(rdev, false);
+	___cfg80211_scan_done(rdev);
 	rtnl_unlock();
 }
 
-- 
1.8.5.rc1


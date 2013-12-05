Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:62784 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab3LEJVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 04:21:43 -0500
Received: by mail-ea0-f180.google.com with SMTP id f15so11281358eak.11
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 01:21:42 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] cfg80211: prevent race condition on scan request cleanup
Date: Thu,  5 Dec 2013 11:21:29 +0200
Message-Id: <1386235289-27278-4-git-send-email-eliad@wizery.com> (sfid-20131205_102151_137713_3277E5FB)
In-Reply-To: <1386235289-27278-1-git-send-email-eliad@wizery.com>
References: <1386235289-27278-1-git-send-email-eliad@wizery.com>
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

Solve it by freeing scan_req (and clearing it) only
when leak=false. Otherwise, instead of freeing it
mark the request as pending_cleanup, and free it
later on (by the work).

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
i encountered this one while adding some intentional delays in order
to reproduce a different issue. this is probably not a real-world scenario.

 include/net/cfg80211.h |  2 +-
 net/wireless/scan.c    | 13 ++++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3f4eff0..c12259e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1376,7 +1376,7 @@ struct cfg80211_scan_request {
 	/* internal */
 	struct wiphy *wiphy;
 	unsigned long scan_start;
-	bool aborted, notified;
+	bool aborted, notified, pending_cleanup;
 	bool no_cck;
 
 	u32 min_dwell;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d960e4a..1ec43a8 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -176,6 +176,9 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 	if (!request)
 		return;
 
+	if (request->pending_cleanup)
+		goto free_request;
+
 	wdev = request->wdev;
 
 	/*
@@ -209,7 +212,6 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 	if (wdev->netdev)
 		dev_put(wdev->netdev);
 
-	rdev->scan_req = NULL;
 
 	/*
 	 * OK. If this is invoked with "leak" then we can't
@@ -219,8 +221,13 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 	 * the scan request or not ... if it accesses the dev
 	 * in there (it shouldn't anyway) then it may crash.
 	 */
-	if (!leak)
-		kfree(request);
+	if (leak) {
+		request->pending_cleanup = true;
+		return;
+	}
+free_request:
+	rdev->scan_req = NULL;
+	kfree(request);
 }
 
 void __cfg80211_scan_done(struct work_struct *wk)
-- 
1.8.5.rc1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59214 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab3EPVDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 17:03:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/9] cfg80211: simplify and correct P2P-Device scan check
Date: Thu, 16 May 2013 23:03:34 +0200
Message-Id: <1368738218-7597-6-git-send-email-johannes@sipsolutions.net> (sfid-20130516_230354_155064_4FD4390E)
In-Reply-To: <1368738218-7597-1-git-send-email-johannes@sipsolutions.net>
References: <1368738218-7597-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the driver for some reason successfully finishes
scanning while in p2p_stop_device(), cfg80211 will
still set it to aborted. Simplify this code using the
new 'notified' value and only mark it aborted in case
the driver didn't notify cfg80211 at all (in which
case we also leak the request to not crash, this is
a driver bug.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5fc642d..afcb9ec 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -204,18 +204,15 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	rdev->opencount--;
 
 	if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
-		bool busy = work_busy(&rdev->scan_done_wk);
-
 		/*
-		 * If the work isn't pending or running (in which case it would
-		 * be waiting for the lock we hold) the driver didn't properly
-		 * cancel the scan when the interface was removed. In this case
-		 * warn and leak the scan request object to not crash later.
+		 * If the scan request wasn't notified as done, set it
+		 * to aborted and leak it after a warning. The driver
+		 * should have notified us that it ended at the latest
+		 * during rdev_stop_p2p_device().
 		 */
-		WARN_ON(!busy);
-
-		rdev->scan_req->aborted = true;
-		___cfg80211_scan_done(rdev, !busy);
+		if (WARN_ON(!rdev->scan_req->notified))
+			rdev->scan_req->aborted = true;
+		___cfg80211_scan_done(rdev, !rdev->scan_req->notified);
 	}
 }
 
-- 
1.8.0


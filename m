Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:60523 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaJOO41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2014 10:56:27 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: Warn once for delayed scan completion
Date: Wed, 15 Oct 2014 20:27:22 +0530
Message-Id: <1413385042-17903-1-git-send-email-sujith@msujith.org> (sfid-20141015_165634_906220_D8BC6D2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Scan completion for drivers that use HW scanning
causes a warning to be hit if the interface has been
removed. Since cfg80211 ensures that both use-after-free
and scheduling a new scan doesn't happen in this case,
WARN_ON_ONCE can be used. With ath9k this warning is seen
many times when multi-channel-concurrency is enabled.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 net/wireless/core.c | 2 +-
 net/wireless/scan.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index f52a4cd..2be08e8 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -931,7 +931,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 	case NETDEV_DOWN:
 		cfg80211_update_iface_num(rdev, wdev->iftype, -1);
 		if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
-			if (WARN_ON(!rdev->scan_req->notified))
+			if (WARN_ON_ONCE(!rdev->scan_req->notified))
 				rdev->scan_req->aborted = true;
 			___cfg80211_scan_done(rdev, false);
 		}
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index bda39f1..c0fc0b3 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -239,7 +239,7 @@ void __cfg80211_scan_done(struct work_struct *wk)
 void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 {
 	trace_cfg80211_scan_done(request, aborted);
-	WARN_ON(request != wiphy_to_rdev(request->wiphy)->scan_req);
+	WARN_ON_ONCE(request != wiphy_to_rdev(request->wiphy)->scan_req);
 
 	request->aborted = aborted;
 	request->notified = true;
-- 
2.1.2


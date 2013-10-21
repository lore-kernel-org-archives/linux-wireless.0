Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59925 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab3JUJ7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 05:59:40 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.12] cfg80211: fix scheduled scan pointer access
Date: Mon, 21 Oct 2013 11:59:32 +0200
Message-Id: <1382349572-22287-1-git-send-email-johannes@sipsolutions.net> (sfid-20131021_115943_677401_9D47C26B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since rdev->sched_scan_req is dereferenced outside the
lock protecting it, this might be done at the wrong
time, causing crashes. Move the dereference to where
it should be - inside the RTNL locked section.

Cc: stable@vger.kernel.org [3.8+]
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index eeb7148..d4397eb 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -254,10 +254,10 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
 	rdev = container_of(wk, struct cfg80211_registered_device,
 			    sched_scan_results_wk);
 
-	request = rdev->sched_scan_req;
-
 	rtnl_lock();
 
+	request = rdev->sched_scan_req;
+
 	/* we don't have sched_scan_req anymore if the scan is stopping */
 	if (request) {
 		if (request->flags & NL80211_SCAN_FLAG_FLUSH) {
-- 
1.8.4.rc3


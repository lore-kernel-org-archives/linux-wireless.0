Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316Ab0JAMEX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 08:04:23 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 5/6] mac80211: do not requeue scan work when not needed
Date: Fri,  1 Oct 2010 14:05:31 +0200
Message-Id: <1285934732-16087-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of performing hw scan and not abort it
__ieee80211_scan_completed() is currently called from scan work, so does
not need to reschedule work to call drv_hw_scan().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/scan.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 2e9a70c..cf60f20 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -270,9 +270,9 @@ static bool __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 		return false;
 
 	if (was_hw_scan && !aborted && ieee80211_prep_hw_scan(local)) {
-		ieee80211_queue_delayed_work(&local->hw,
-					     &local->scan_work, 0);
-		return false;
+		int rc = drv_hw_scan(local, local->scan_sdata, local->hw_scan_req);
+		if (rc == 0)
+			return false;
 	}
 
 	kfree(local->hw_scan_req);
@@ -660,11 +660,6 @@ void ieee80211_scan_work(struct work_struct *work)
 		return;
 	}
 
-	if (local->hw_scan_req) {
-		rc = drv_hw_scan(local, sdata, local->hw_scan_req);
-		goto out_complete;
-	}
-
 	if (local->scan_req && !local->scanning) {
 		struct cfg80211_scan_request *req = local->scan_req;
 
-- 
1.7.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab0JFJU5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 05:20:57 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/6] mac80211: do not requeue scan work when not needed
Date: Wed,  6 Oct 2010 11:22:11 +0200
Message-Id: <1286356933-4076-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1286356933-4076-1-git-send-email-sgruszka@redhat.com>
References: <1286356933-4076-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When performing hw scan and not abort it, __ieee80211_scan_completed()
is currently called from scan work, so does not need to reschedule work
to call drv_hw_scan().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/scan.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index d35003a..bce769a 100644
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
@@ -657,15 +657,6 @@ void ieee80211_scan_work(struct work_struct *work)
 	if (!sdata || !local->scan_req)
 		goto out;
 
-	if (local->hw_scan_req) {
-		int rc = drv_hw_scan(local, sdata, local->hw_scan_req);
-		if (rc) {
-			aborted = true;
-			goto out_complete;
-		} else
-			goto out;
-	}
-
 	if (local->scan_req && !local->scanning) {
 		struct cfg80211_scan_request *req = local->scan_req;
 		int rc;
-- 
1.7.1


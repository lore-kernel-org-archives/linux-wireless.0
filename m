Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:30107 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750711AbeEKQty (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 12:49:54 -0400
From: Tim Kourt <tim.a.kourt@linux.intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tim Kourt <tim.a.kourt@linux.intel.com>
Subject: [PATCH] cfg80211: Fix support for flushing old scan results
Date: Fri, 11 May 2018 09:48:35 -0700
Message-Id: <20180511164835.40161-1-tim.a.kourt@linux.intel.com> (sfid-20180511_184957_723913_31CD95FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

__cfg80211_bss_expire function was incorrectly used to flush the BSS
entries from the previous scan results, causing NL80211_SCAN_FLAG_FLUSH
flag to have no effect.

This patch is addressing the described issue by changing the semantics
of the function (__cfg80211_bss_expire) parameter from a confusing
expire_time (jiffies - IEEE80211_SCAN_RESULT_EXPIRE) to a simple
time_to_live interval and encapsulating the needed calculations inside
of the function. The rest of the function usages were changed accordingly.

Note: This patch enables flushing of the non-hidden BSSs.

Signed-off-by: Tim Kourt <tim.a.kourt@linux.intel.com>
---
 net/wireless/scan.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d36c3eb..d459457 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -71,7 +71,7 @@ module_param(bss_entries_limit, int, 0644);
 MODULE_PARM_DESC(bss_entries_limit,
                  "limit to number of scan BSS entries (per wiphy, default 1000)");
 
-#define IEEE80211_SCAN_RESULT_EXPIRE	(30 * HZ)
+#define IEEE80211_SCAN_RESULT_TIME_TO_LIVE (30 * HZ)
 
 static void bss_free(struct cfg80211_internal_bss *bss)
 {
@@ -160,7 +160,7 @@ static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *rdev,
 }
 
 static void __cfg80211_bss_expire(struct cfg80211_registered_device *rdev,
-				  unsigned long expire_time)
+				  unsigned long time_to_live)
 {
 	struct cfg80211_internal_bss *bss, *tmp;
 	bool expired = false;
@@ -170,7 +170,8 @@ static void __cfg80211_bss_expire(struct cfg80211_registered_device *rdev,
 	list_for_each_entry_safe(bss, tmp, &rdev->bss_list, list) {
 		if (atomic_read(&bss->hold))
 			continue;
-		if (!time_after(expire_time, bss->ts))
+
+		if (!time_after(jiffies, bss->ts + time_to_live))
 			continue;
 
 		if (__cfg80211_unlink_bss(rdev, bss))
@@ -181,6 +182,11 @@ static void __cfg80211_bss_expire(struct cfg80211_registered_device *rdev,
 		rdev->bss_generation++;
 }
 
+static void __cfg80211_bss_expire_all(struct cfg80211_registered_device *rdev)
+{
+	__cfg80211_bss_expire(rdev, 0);
+}
+
 static bool cfg80211_bss_expire_oldest(struct cfg80211_registered_device *rdev)
 {
 	struct cfg80211_internal_bss *bss, *oldest = NULL;
@@ -251,7 +257,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 	    request->flags & NL80211_SCAN_FLAG_FLUSH) {
 		/* flush entries from previous scans */
 		spin_lock_bh(&rdev->bss_lock);
-		__cfg80211_bss_expire(rdev, request->scan_start);
+		__cfg80211_bss_expire_all(rdev);
 		spin_unlock_bh(&rdev->bss_lock);
 	}
 
@@ -380,7 +386,7 @@ void cfg80211_sched_scan_results_wk(struct work_struct *work)
 			if (req->flags & NL80211_SCAN_FLAG_FLUSH) {
 				/* flush entries from previous scans */
 				spin_lock_bh(&rdev->bss_lock);
-				__cfg80211_bss_expire(rdev, req->scan_start);
+				__cfg80211_bss_expire_all(rdev);
 				spin_unlock_bh(&rdev->bss_lock);
 				req->scan_start = jiffies;
 			}
@@ -477,7 +483,7 @@ void cfg80211_bss_age(struct cfg80211_registered_device *rdev,
 
 void cfg80211_bss_expire(struct cfg80211_registered_device *rdev)
 {
-	__cfg80211_bss_expire(rdev, jiffies - IEEE80211_SCAN_RESULT_EXPIRE);
+	__cfg80211_bss_expire(rdev, IEEE80211_SCAN_RESULT_TIME_TO_LIVE);
 }
 
 const u8 *cfg80211_find_ie_match(u8 eid, const u8 *ies, int len,
@@ -738,7 +744,8 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 		if (!is_valid_ether_addr(bss->pub.bssid))
 			continue;
 		/* Don't get expired BSS structs */
-		if (time_after(now, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE) &&
+		if (time_after(now, bss->ts +
+					IEEE80211_SCAN_RESULT_TIME_TO_LIVE) &&
 		    !atomic_read(&bss->hold))
 			continue;
 		if (is_bss(&bss->pub, bssid, ssid, ssid_len)) {
-- 
2.9.4

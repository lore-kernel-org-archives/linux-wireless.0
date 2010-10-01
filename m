Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab0JAME1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 08:04:27 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/6] mac80211: assure we also cancel deferred scan request
Date: Fri,  1 Oct 2010 14:05:30 +0200
Message-Id: <1285934732-16087-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When cfg80211 request the scan and mac80211 perform some management work,
we defer the scan request. We do not canceling such requests when calling
ieee80211_scan_cancel(), because of SCAN_SW_SCANNING bit check just
before the call. So fix that problem. Keeping local->mtx lock assures
that the deferred scan will not become "working" HW scan.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/main.c |    3 +--
 net/mac80211/pm.c   |    3 +--
 net/mac80211/scan.c |    2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 494dba1..8ba09ff 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -304,8 +304,7 @@ static void ieee80211_restart_work(struct work_struct *work)
 	mutex_unlock(&local->mtx);
 
 	rtnl_lock();
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning)))
-		ieee80211_scan_cancel(local);
+	ieee80211_scan_cancel(local);
 	ieee80211_reconfig(local);
 	rtnl_unlock();
 }
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index ce671df..d287fde 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -12,8 +12,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning)))
-		ieee80211_scan_cancel(local);
+	ieee80211_scan_cancel(local);
 
 	ieee80211_stop_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 44deb05..2e9a70c 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -799,7 +799,7 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 	 */
 	mutex_lock(&local->mtx);
 	if (test_bit(SCAN_SW_SCANNING, &local->scanning) ||
-	    (!local->scanning && local->scan_req))
+	    (!test_bit(SCAN_HW_SCANNING, &local->scanning) && local->scan_req))
 		finish = __ieee80211_scan_completed(&local->hw, true, false);
 	mutex_unlock(&local->mtx);
 
-- 
1.7.1


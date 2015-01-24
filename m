Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:56350 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750913AbbAXIaQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 03:30:16 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Jan 2015 10:30:02 +0200
Message-Id: <1422088202-31871-1-git-send-email-luca@coelho.fi> (sfid-20150124_093023_016053_EEA7A8E6)
Subject: [PATCH] mac80211: handle potential race between suspend and scan completion
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

If suspend starts while ieee80211_scan_completed() is running, between
the point where SCAN_COMPLETED is set and the work is queued,
ieee80211_scan_cancel() will not catch the work and we may finish
suspending before the work is actually executed, leaving the scan
running while suspended.

To fix this race, queue the scan work during resume if the
SCAN_COMPLETED flag is set and flush it immediately.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ieee80211_i.h |  3 ++-
 net/mac80211/util.c        | 12 ++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bdb3e3b..3afe368 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1752,7 +1752,8 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
+	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning) &&
+	     !test_bit(SCAN_COMPLETED, &local->scanning),
 		"%s: resume with hardware scan still in progress\n",
 		wiphy_name(hw->wiphy));
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c65d03f..8428f4a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2060,6 +2060,18 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	mb();
 	local->resuming = false;
 
+	/* It's possible that we don't handle the scan completion in
+	 * time during suspend, so if it's still marked as completed
+	 * here, queue the work and flush it to clean things up.
+	 * Instead of calling the worker function directly here, we
+	 * really queue it to avoid potential races with other flows
+	 * scheduling the same work.
+	 */
+	if (test_bit(SCAN_COMPLETED, &local->scanning)) {
+		ieee80211_queue_delayed_work(&local->hw, &local->scan_work, 0);
+		flush_delayed_work(&local->scan_work);
+	}
+
 	if (local->open_count && !reconfig_due_to_wowlan)
 		drv_reconfig_complete(local, IEEE80211_RECONFIG_TYPE_SUSPEND);
 
-- 
2.1.4


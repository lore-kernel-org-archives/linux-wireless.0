Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaBLKcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 05:32:13 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: simplify roc check in idle calculation
Date: Wed, 12 Feb 2014 11:32:10 +0100
Message-Id: <1392201130-18791-1-git-send-email-johannes@sipsolutions.net> (sfid-20140212_113218_924895_B5BFF951)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to start iterating the list only to break on the
first item, just use !list_empty() and also simplify the whole
conditional into a single expression.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8880bc8..9db71cf 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -101,9 +101,8 @@ static u32 __ieee80211_idle_on(struct ieee80211_local *local)
 static u32 __ieee80211_recalc_idle(struct ieee80211_local *local,
 				   bool force_active)
 {
-	bool working = false, scanning, active;
+	bool working, scanning, active;
 	unsigned int led_trig_start = 0, led_trig_stop = 0;
-	struct ieee80211_roc_work *roc;
 
 	lockdep_assert_held(&local->mtx);
 
@@ -111,12 +110,8 @@ static u32 __ieee80211_recalc_idle(struct ieee80211_local *local,
 		 !list_empty(&local->chanctx_list) ||
 		 local->monitors;
 
-	if (!local->ops->remain_on_channel) {
-		list_for_each_entry(roc, &local->roc_list, list) {
-			working = true;
-			break;
-		}
-	}
+	working = !local->ops->remain_on_channel &&
+		  !list_empty(&local->roc_list);
 
 	scanning = test_bit(SCAN_SW_SCANNING, &local->scanning) ||
 		   test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning);
-- 
1.8.5.3


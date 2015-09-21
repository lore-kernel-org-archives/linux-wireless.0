Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45184 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752732AbbIUMuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:50:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Eliad Peller <eliadx.peller@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 15:50:26 +0300
Message-Id: <1442839826-26242-1-git-send-email-luca@coelho.fi> (sfid-20150921_145035_085100_DB2283EC)
Subject: [PATCH] mac80211: don't tear down aggregation on suspend in case of wowlan->any
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliadx.peller@intel.com>

in case of "any" wowlan trigger, there is no reason to tear down
aggregations, as we want the device to continue working normally.

Similarly, there's no reason to tear down aggregations on resume,
as they should have been torn down on suspend if needed.

However, since the reconfiguration flow is shared with HW restart,
tear down aggregations on reconfiguration only when we are not resuming.

To keep things working after non-wowlan suspend, keep clearing the
WLAN_STA_BLOCK_BA flag.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/pm.c   | 3 ++-
 net/mac80211/util.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index b676b9f..ad88ad4 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -23,7 +23,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	ieee80211_del_virtual_monitor(local);
 
-	if (ieee80211_hw_check(hw, AMPDU_AGGREGATION)) {
+	if (ieee80211_hw_check(hw, AMPDU_AGGREGATION) &&
+	    !(wowlan && wowlan->any)) {
 		mutex_lock(&local->sta_mtx);
 		list_for_each_entry(sta, &local->sta_list, list) {
 			set_sta_flag(sta, WLAN_STA_BLOCK_BA);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 005fc8e..70b5451 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2017,8 +2017,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		mutex_lock(&local->sta_mtx);
 
 		list_for_each_entry(sta, &local->sta_list, list) {
-			ieee80211_sta_tear_down_BA_sessions(
-					sta, AGG_STOP_LOCAL_REQUEST);
+			if (!local->resuming)
+				ieee80211_sta_tear_down_BA_sessions(
+						sta, AGG_STOP_LOCAL_REQUEST);
 			clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
 		}
 
-- 
2.5.1


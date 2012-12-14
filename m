Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2LNL7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 06:59:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] mac80211: clean up ieee80211_quiesce
Date: Fri, 14 Dec 2012 12:59:26 +0100
Message-Id: <1355486368-14563-2-git-send-email-johannes@sipsolutions.net> (sfid-20121214_125916_372837_03FF856E)
In-Reply-To: <1355486368-14563-1-git-send-email-johannes@sipsolutions.net>
References: <1355486368-14563-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's a bit odd that there's a return value that only
depends on the iftype, move that logic out of the
function into the only caller that needs it.

Also, since the quiescing could stop timers that
trigger the sdata work, move the sdata work cancel
into the function and after the actual quiesce.

Finally, there's no need to call it on interfaces
that are down, so don't.

Change-Id: I1632d46d21ba3558ea713d035184f1939905f2f1
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/pm.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 79a48f3..f321783 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -7,25 +7,23 @@
 #include "led.h"
 
 /* return value indicates whether the driver should be further notified */
-static bool ieee80211_quiesce(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_quiesce(struct ieee80211_sub_if_data *sdata)
 {
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_STATION:
 		ieee80211_sta_quiesce(sdata);
-		return true;
+		break;
 	case NL80211_IFTYPE_ADHOC:
 		ieee80211_ibss_quiesce(sdata);
-		return true;
+		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		ieee80211_mesh_quiesce(sdata);
-		return true;
-	case NL80211_IFTYPE_AP_VLAN:
-	case NL80211_IFTYPE_MONITOR:
-		/* don't tell driver about this */
-		return false;
+		break;
 	default:
-		return true;
+		break;
 	}
+
+	cancel_work_sync(&sdata->work);
 }
 
 int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
@@ -94,10 +92,9 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 			WARN_ON(err != 1);
 			local->wowlan = false;
 		} else {
-			list_for_each_entry(sdata, &local->interfaces, list) {
-				cancel_work_sync(&sdata->work);
-				ieee80211_quiesce(sdata);
-			}
+			list_for_each_entry(sdata, &local->interfaces, list)
+				if (ieee80211_sdata_running(sdata))
+					ieee80211_quiesce(sdata);
 			goto suspend;
 		}
 	}
@@ -124,13 +121,18 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	/* remove all interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		cancel_work_sync(&sdata->work);
-
-		if (!ieee80211_quiesce(sdata))
+		if (!ieee80211_sdata_running(sdata))
 			continue;
 
-		if (!ieee80211_sdata_running(sdata))
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_AP_VLAN:
+		case NL80211_IFTYPE_MONITOR:
+			/* skip these */
 			continue;
+		default:
+			ieee80211_quiesce(sdata);
+			break;
+		}
 
 		/* disable beaconing */
 		ieee80211_bss_info_change_notify(sdata,
-- 
1.8.0


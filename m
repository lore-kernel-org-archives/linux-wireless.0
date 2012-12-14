Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57029 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2LNNqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 08:46:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] mac80211: further simplify ieee80211_bss_info_change_notify
Date: Fri, 14 Dec 2012 14:46:45 +0100
Message-Id: <1355492806-31673-4-git-send-email-johannes@sipsolutions.net> (sfid-20121214_144630_124511_AA60ACF0)
In-Reply-To: <1355492806-31673-1-git-send-email-johannes@sipsolutions.net>
References: <1355492806-31673-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The special case in the function isn't really needed,
instead make the suspend code a bit better and also
easier to understand and move the warning into the
driver op wrapper inline.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/driver-ops.h |  6 ++++++
 net/mac80211/main.c       | 14 --------------
 net/mac80211/pm.c         | 13 ++++++++++---
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 70dcc42..7be48a9 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -207,6 +207,12 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 {
 	might_sleep();
 
+	WARN_ON_ONCE(changed & (BSS_CHANGED_BEACON |
+				BSS_CHANGED_BEACON_ENABLED) &&
+		     sdata->vif.type != NL80211_IFTYPE_AP &&
+		     sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+		     sdata->vif.type != NL80211_IFTYPE_MESH_POINT);
+
 	check_sdata_in_driver(sdata);
 
 	trace_drv_bss_info_changed(local, sdata, info, changed);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e991d30..282f583 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -231,20 +231,6 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
-	switch (sdata->vif.type) {
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_WDS:
-	case NL80211_IFTYPE_MESH_POINT:
-		break;
-	default:
-		/* do not warn to simplify caller in scan.c */
-		changed &= ~BSS_CHANGED_BEACON_ENABLED;
-		if (WARN_ON(changed & BSS_CHANGED_BEACON))
-			return;
-		break;
-	}
-
 	drv_bss_info_changed(local, sdata, &sdata->vif.bss_conf, changed);
 }
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index f3a9e5f..3d93cd3 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -121,7 +121,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	/* remove all interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		u32 changed = BSS_CHANGED_BEACON_ENABLED;
+		u32 changed = 0;
 
 		if (!ieee80211_sdata_running(sdata))
 			continue;
@@ -133,12 +133,19 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 			continue;
 		case NL80211_IFTYPE_STATION:
 			changed = BSS_CHANGED_ASSOC;
-			/* fall through */
+			break;
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_MESH_POINT:
+			if (sdata->vif.bss_conf.enable_beacon)
+				changed = BSS_CHANGED_BEACON_ENABLED;
+			break;
 		default:
-			ieee80211_quiesce(sdata);
 			break;
 		}
 
+		ieee80211_quiesce(sdata);
+
 		sdata->suspend_bss_conf = sdata->vif.bss_conf;
 		memset(&sdata->vif.bss_conf, 0, sizeof(sdata->vif.bss_conf));
 
-- 
1.8.0


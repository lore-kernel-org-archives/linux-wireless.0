Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:45792 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaDNJwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 05:52:00 -0400
Received: by mail-pb0-f42.google.com with SMTP id rr13so8075741pbb.15
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 02:51:59 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/6] mac80211: minor changes to ieee80211_reconfig()
Date: Mon, 14 Apr 2014 17:51:32 +0800
Message-Id: <14b385a08ccf4d9ca90d54acb84e7414aed761a8.1397469036.git.gamerh2o@gmail.com> (sfid-20140414_115408_353388_2395BC62)
In-Reply-To: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
References: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
In-Reply-To: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
References: <8b5c4a61ae1f49400478b030fa7ae4e3a5ca2bcb.1397469035.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Try to update chanctx only if local->use_chanctx is true.

P2P_DEVICE doesn't support ieee80211_bss_info_change_notify() for now,
so it's not needed to set changed flags for P2P_DEVICE. Besides, flag
BSS_CHANGED_IDLE is already set in the common change flags.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/util.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 275c94f..191e558 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1565,17 +1565,17 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		list_for_each_entry(ctx, &local->chanctx_list, list)
 			WARN_ON(drv_add_chanctx(local, ctx));
 		mutex_unlock(&local->chanctx_mtx);
-	}
 
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-		ieee80211_assign_chanctx(local, sdata);
-	}
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (!ieee80211_sdata_running(sdata))
+				continue;
+			ieee80211_assign_chanctx(local, sdata);
+		}
 
-	sdata = rtnl_dereference(local->monitor_sdata);
-	if (sdata && ieee80211_sdata_running(sdata))
-		ieee80211_assign_chanctx(local, sdata);
+		sdata = rtnl_dereference(local->monitor_sdata);
+		if (sdata && ieee80211_sdata_running(sdata))
+			ieee80211_assign_chanctx(local, sdata);
+	}
 
 	/* add STAs back */
 	mutex_lock(&local->sta_mtx);
@@ -1671,13 +1671,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			}
 			break;
 		case NL80211_IFTYPE_WDS:
-			break;
 		case NL80211_IFTYPE_AP_VLAN:
 		case NL80211_IFTYPE_MONITOR:
-			/* ignore virtual */
-			break;
 		case NL80211_IFTYPE_P2P_DEVICE:
-			changed = BSS_CHANGED_IDLE;
+			/* nothing to do */
 			break;
 		case NL80211_IFTYPE_UNSPECIFIED:
 		case NUM_NL80211_IFTYPES:
-- 
1.9.0


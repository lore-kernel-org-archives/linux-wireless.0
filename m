Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58190 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaDUEy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 00:54:59 -0400
Received: by mail-pa0-f43.google.com with SMTP id bj1so3353566pad.30
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 21:54:58 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 03/12] mac80211: minor changes of ieee80211_reconfig()
Date: Mon, 21 Apr 2014 12:52:58 +0800
Message-Id: <d8410804796e01fe8b4c62aeaca97b791154f585.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065501_795742_F4BBA48E)
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Try to update chanctx only if local->use_chanctx is true.

P2P_DEVICE doesn't support ieee80211_bss_info_change_notify() for now,
so it's not needed to set changed flags for P2P_DEVICE.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/util.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 5a6cc33..ae38592 100644
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


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59302 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab2FCUcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2012 16:32:02 -0400
Received: by wibhj8 with SMTP id hj8so2233097wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2012 13:32:01 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: add stations after AP start on reconfig
Date: Sun,  3 Jun 2012 23:31:56 +0300
Message-Id: <1338755516-13277-1-git-send-email-arik@wizery.com> (sfid-20120603_223208_448686_31C6BB77)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When performing a HW restart for an AP mode interface, add stations back
only after the AP is beaconing. This mimics the normal flow of STA
addition on AP.

Some devices (wlcore) do not support adding stations before beaconing,
so this has the added benefit of making recovery work for them.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
This patch depends on "mac80211: fix error in station state transitions
during reconfig", submitted recently by Johannes.

 net/mac80211/util.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ed8b11f..2975699 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1274,14 +1274,19 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	/* add STAs back */
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list) {
-		if (sta->uploaded) {
-			enum ieee80211_sta_state state;
+		enum ieee80211_sta_state state;
 
-			for (state = IEEE80211_STA_NOTEXIST;
-			     state < sta->sta_state; state++)
-				WARN_ON(drv_sta_state(local, sta->sdata, sta,
-						      state, state + 1));
-		}
+		if (!sta->uploaded)
+			continue;
+
+		/* AP-mode stations will be added later */
+		if (sta->sdata->vif.type == NL80211_IFTYPE_AP)
+			continue;
+
+		for (state = IEEE80211_STA_NOTEXIST;
+		     state < sta->sta_state; state++)
+			WARN_ON(drv_sta_state(local, sta->sdata, sta, state,
+					      state + 1));
 	}
 	mutex_unlock(&local->sta_mtx);
 
@@ -1378,6 +1383,24 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		}
 	}
 
+	/* APs are now beaconing, add back stations */
+	mutex_lock(&local->sta_mtx);
+	list_for_each_entry(sta, &local->sta_list, list) {
+		enum ieee80211_sta_state state;
+
+		if (!sta->uploaded)
+			continue;
+
+		if (sta->sdata->vif.type != NL80211_IFTYPE_AP)
+			continue;
+
+		for (state = IEEE80211_STA_NOTEXIST;
+		     state < sta->sta_state; state++)
+			WARN_ON(drv_sta_state(local, sta->sdata, sta, state,
+					      state + 1));
+	}
+	mutex_unlock(&local->sta_mtx);
+
 	/* add back keys */
 	list_for_each_entry(sdata, &local->interfaces, list)
 		if (ieee80211_sdata_running(sdata))
-- 
1.7.9.5


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36594 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3ANOU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 09:20:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix resume from WoWLAN
Date: Mon, 14 Jan 2013 15:21:24 +0100
Message-Id: <1358173284-18342-1-git-send-email-johannes@sipsolutions.net> (sfid-20130114_152102_496746_2FB56243)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My commit 529ba6e9313dbe60dab7e72c6fdf647a012e9f5b
("mac80211: clean up association better in suspend")
introduced a bug when resuming from WoWLAN when a
device reset is desired. This case must not use the
suspend_bss_conf as it hasn't been stored.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index fed2112..2ba21e3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1365,8 +1365,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	struct ieee80211_chanctx *ctx;
 	struct sta_info *sta;
 	int res, i;
-
 #ifdef CONFIG_PM
+	bool reconfig_due_to_wowlan = false;
+
 	if (local->suspended)
 		local->resuming = true;
 
@@ -1384,6 +1385,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		 * res is 1, which means the driver requested
 		 * to go through a regular reset on wakeup.
 		 */
+		reconfig_due_to_wowlan = true;
 	}
 #endif
 	/* everything else happens only if HW was up & running */
@@ -1534,7 +1536,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			  BSS_CHANGED_TXPOWER;
 
 #ifdef CONFIG_PM
-		if (local->resuming)
+		if (local->resuming && !reconfig_due_to_wowlan)
 			sdata->vif.bss_conf = sdata->suspend_bss_conf;
 #endif
 
-- 
1.8.0


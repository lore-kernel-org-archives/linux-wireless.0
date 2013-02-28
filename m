Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3B1JBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 04:01:35 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sujith@msujith.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9] mac80211: really fix monitor mode channel reporting
Date: Thu, 28 Feb 2013 10:01:24 +0100
Message-Id: <1362042084-26920-1-git-send-email-johannes@sipsolutions.net> (sfid-20130228_100138_531258_899933FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

After Felix's patch it was still broken in case you
used more than just a single monitor interface. Fix
it better now.

Reported-by: Sujith Manoharan <sujith@msujith.org>
Tested-by: Sujith Manoharan <sujith@msujith.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 808f5fc..fb30681 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3290,14 +3290,19 @@ static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
 	int ret = -ENODATA;
 
 	rcu_read_lock();
-	if (local->use_chanctx) {
-		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-		if (chanctx_conf) {
-			*chandef = chanctx_conf->def;
-			ret = 0;
-		}
-	} else if (local->open_count == local->monitors) {
-		*chandef = local->monitor_chandef;
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (chanctx_conf) {
+		*chandef = chanctx_conf->def;
+		ret = 0;
+	} else if (local->open_count > 0 &&
+		   local->open_count == local->monitors &&
+		   sdata->vif.type == NL80211_IFTYPE_MONITOR) {
+		if (local->use_chanctx)
+			*chandef = local->monitor_chandef;
+		else
+			cfg80211_chandef_create(chandef,
+						local->_oper_channel,
+						local->_oper_channel_type);
 		ret = 0;
 	}
 	rcu_read_unlock();
-- 
1.8.0


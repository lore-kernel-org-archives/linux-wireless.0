Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2KSV3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 16:29:21 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sujith@msujith.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix channel context suspend handling
Date: Mon, 19 Nov 2012 22:29:46 +0100
Message-Id: <1353360586-32157-1-git-send-email-johannes@sipsolutions.net> (sfid-20121119_222924_703970_D27B6648)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Sujith reported warnings with suspend/resume due to
channel contexts. When I looked into it, I realised
that the code was completely broken as it unassigned
the channel contexts when suspending, which actually
means they are destroyed.

Fix this by calling just the driver method (if it is
implemented) instead of trying to use the mac80211
channel context management code.

Reported-by: Sujith Manoharan <sujith@msujith.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/pm.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 0f1c434..792d5ce 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -139,8 +139,23 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		    rcu_access_pointer(sdata->u.ap.beacon))
 			drv_stop_ap(local, sdata);
 
-		/* the interface is leaving the channel and is removed */
-		ieee80211_vif_release_channel(sdata);
+		if (local->use_chanctx) {
+			struct ieee80211_chanctx_conf *conf;
+			struct ieee80211_chanctx *ctx;
+
+			mutex_lock(&local->chanctx_mtx);
+			conf = rcu_dereference_protected(
+					sdata->vif.chanctx_conf,
+					lockdep_is_held(&local->chanctx_mtx));
+			if (conf) {
+				ctx = container_of(conf,
+						   struct ieee80211_chanctx,
+						   conf);
+				drv_unassign_vif_chanctx(local, sdata, ctx);
+			}
+
+			mutex_unlock(&local->chanctx_mtx);
+		}
 		drv_remove_interface(local, sdata);
 	}
 
-- 
1.8.0


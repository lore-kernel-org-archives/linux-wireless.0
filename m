Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2KGNYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 08:24:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: reassign channel contexts before stations
Date: Wed,  7 Nov 2012 14:24:44 +0100
Message-Id: <1352294684-19266-4-git-send-email-johannes@sipsolutions.net> (sfid-20121107_142423_191004_0A2B1513)
In-Reply-To: <1352294684-19266-1-git-send-email-johannes@sipsolutions.net>
References: <1352294684-19266-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since channel contexts are usually present before
stations can be added to an interface, reassign
before stations them in reconfiguration as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 690e474..e1dbf9c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1429,6 +1429,23 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		WARN_ON(drv_add_chanctx(local, ctx));
 	mutex_unlock(&local->chanctx_mtx);
 
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		struct ieee80211_chanctx_conf *ctx_conf;
+
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		mutex_lock(&local->chanctx_mtx);
+		ctx_conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+				lockdep_is_held(&local->chanctx_mtx));
+		if (ctx_conf) {
+			ctx = container_of(ctx_conf, struct ieee80211_chanctx,
+					   conf);
+			drv_assign_vif_chanctx(local, sdata, ctx);
+		}
+		mutex_unlock(&local->chanctx_mtx);
+	}
+
 	/* add STAs back */
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry(sta, &local->sta_list, list) {
@@ -1469,22 +1486,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 
 	/* Finally also reconfigure all the BSS information */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		struct ieee80211_chanctx_conf *ctx_conf;
 		u32 changed;
 
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-
-		mutex_lock(&local->chanctx_mtx);
-		ctx_conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
-				lockdep_is_held(&local->chanctx_mtx));
-		if (ctx_conf) {
-			ctx = container_of(ctx_conf, struct ieee80211_chanctx,
-					   conf);
-			drv_assign_vif_chanctx(local, sdata, ctx);
-		}
-		mutex_unlock(&local->chanctx_mtx);
-
 		/* common change flags for all interface types */
 		changed = BSS_CHANGED_ERP_CTS_PROT |
 			  BSS_CHANGED_ERP_PREAMBLE |
-- 
1.8.0


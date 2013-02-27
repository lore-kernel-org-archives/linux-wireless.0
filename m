Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760010Ab3B0PA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 10:00:58 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 7/8] mac80211: merge suspend unassign chanctx code
Date: Wed, 27 Feb 2013 16:00:41 +0100
Message-Id: <1361977242-17344-7-git-send-email-sgruszka@redhat.com> (sfid-20130227_160102_040385_98A06C04)
In-Reply-To: <1361977242-17344-1-git-send-email-sgruszka@redhat.com>
References: <1361977242-17344-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/pm.c | 56 ++++++++++++++++++++++---------------------------------
 1 file changed, 22 insertions(+), 34 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index f69dc90..b4d7b24 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -6,6 +6,26 @@
 #include "driver-ops.h"
 #include "led.h"
 
+static void ieee80211_unassign_chanctx(struct ieee80211_local *local,
+				       struct ieee80211_sub_if_data *sdata)
+
+{
+	struct ieee80211_chanctx_conf *conf;
+	struct ieee80211_chanctx *ctx;
+
+	if (!local->use_chanctx)
+		return;
+
+	mutex_lock(&local->chanctx_mtx);
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (conf) {
+		ctx = container_of(conf, struct ieee80211_chanctx, conf);
+		drv_unassign_vif_chanctx(local, sdata, ctx);
+	}
+	mutex_unlock(&local->chanctx_mtx);
+}
+
 int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -97,45 +117,13 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
 			continue;
-
-		if (local->use_chanctx) {
-			struct ieee80211_chanctx_conf *conf;
-
-			mutex_lock(&local->chanctx_mtx);
-			conf = rcu_dereference_protected(
-					sdata->vif.chanctx_conf,
-					lockdep_is_held(&local->chanctx_mtx));
-			if (conf) {
-				ctx = container_of(conf,
-						   struct ieee80211_chanctx,
-						   conf);
-				drv_unassign_vif_chanctx(local, sdata, ctx);
-			}
-
-			mutex_unlock(&local->chanctx_mtx);
-		}
+		ieee80211_unassign_chanctx(local, sdata);
 		drv_remove_interface(local, sdata);
 	}
 
 	sdata = rtnl_dereference(local->monitor_sdata);
 	if (sdata) {
-		if (local->use_chanctx) {
-			struct ieee80211_chanctx_conf *conf;
-
-			mutex_lock(&local->chanctx_mtx);
-			conf = rcu_dereference_protected(
-					sdata->vif.chanctx_conf,
-					lockdep_is_held(&local->chanctx_mtx));
-			if (conf) {
-				ctx = container_of(conf,
-						   struct ieee80211_chanctx,
-						   conf);
-				drv_unassign_vif_chanctx(local, sdata, ctx);
-			}
-
-			mutex_unlock(&local->chanctx_mtx);
-		}
-
+		ieee80211_unassign_chanctx(local, sdata);
 		drv_remove_interface(local, sdata);
 	}
 
-- 
1.7.11.7


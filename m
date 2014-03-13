Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37123 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbaCMNd5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Mar 2014 09:33:57 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com
Subject: [PATCH v9 2/4] mac80211: refactor ieee80211_assign/unassign_vif_chanctx into one
Date: Thu, 13 Mar 2014 15:33:39 +0200
Message-Id: <1394717621-5608-3-git-send-email-luciano.coelho@intel.com> (sfid-20140313_143400_703302_F397F905)
In-Reply-To: <1394717621-5608-1-git-send-email-luciano.coelho@intel.com>
References: <1394717621-5608-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Combine the functions into one, so that we can switch from one context
to the other without having to unassign and assign separately.  This
is needed by the channel reservation functionality because otherwise
we have a small period of time when the chanctx is set to NULL, which
can cause problems if someone else is trying to dereference it.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/chan.c | 85 +++++++++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 42 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index ef77703..5fa12f1 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -294,32 +294,6 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 	ieee80211_recalc_idle(local);
 }
 
-static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
-					struct ieee80211_chanctx *ctx)
-{
-	struct ieee80211_local *local = sdata->local;
-	int ret;
-
-	lockdep_assert_held(&local->chanctx_mtx);
-
-	ret = drv_assign_vif_chanctx(local, sdata, ctx);
-	if (ret)
-		return ret;
-
-	rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
-	ctx->refcount++;
-
-	ieee80211_recalc_txpower(sdata);
-	ieee80211_recalc_chanctx_min_def(local, ctx);
-	sdata->vif.bss_conf.idle = false;
-
-	if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
-	    sdata->vif.type != NL80211_IFTYPE_MONITOR)
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IDLE);
-
-	return 0;
-}
-
 static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
 					      struct ieee80211_chanctx *ctx)
 {
@@ -378,30 +352,57 @@ static void ieee80211_recalc_radar_chanctx(struct ieee80211_local *local,
 	drv_change_chanctx(local, chanctx, IEEE80211_CHANCTX_CHANGE_RADAR);
 }
 
-static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
-					   struct ieee80211_chanctx *ctx)
+static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
+					struct ieee80211_chanctx *new_ctx)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *conf;
+	struct ieee80211_chanctx *curr_ctx = NULL;
+	int ret = 0;
 
-	lockdep_assert_held(&local->chanctx_mtx);
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
 
-	ctx->refcount--;
-	rcu_assign_pointer(sdata->vif.chanctx_conf, NULL);
+	if (conf) {
+		curr_ctx = container_of(conf, struct ieee80211_chanctx, conf);
 
-	sdata->vif.bss_conf.idle = true;
+		curr_ctx->refcount--;
+		drv_unassign_vif_chanctx(local, sdata, curr_ctx);
+		conf = NULL;
+	}
 
-	if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
-	    sdata->vif.type != NL80211_IFTYPE_MONITOR)
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IDLE);
+	if (new_ctx) {
+		ret = drv_assign_vif_chanctx(local, sdata, new_ctx);
+		if (ret)
+			goto out;
+
+		new_ctx->refcount++;
+		conf = &new_ctx->conf;
+	}
 
-	drv_unassign_vif_chanctx(local, sdata, ctx);
+out:
+	rcu_assign_pointer(sdata->vif.chanctx_conf, conf);
+
+	sdata->vif.bss_conf.idle = !conf;
 
-	if (ctx->refcount > 0) {
-		ieee80211_recalc_chanctx_chantype(sdata->local, ctx);
-		ieee80211_recalc_smps_chanctx(local, ctx);
-		ieee80211_recalc_radar_chanctx(local, ctx);
-		ieee80211_recalc_chanctx_min_def(local, ctx);
+	if (curr_ctx && curr_ctx->refcount > 0) {
+		ieee80211_recalc_chanctx_chantype(local, curr_ctx);
+		ieee80211_recalc_smps_chanctx(local, curr_ctx);
+		ieee80211_recalc_radar_chanctx(local, curr_ctx);
+		ieee80211_recalc_chanctx_min_def(local, curr_ctx);
 	}
+
+	if (new_ctx && new_ctx->refcount > 0) {
+		ieee80211_recalc_txpower(sdata);
+		ieee80211_recalc_chanctx_min_def(local, new_ctx);
+	}
+
+	if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
+	    sdata->vif.type != NL80211_IFTYPE_MONITOR)
+		ieee80211_bss_info_change_notify(sdata,
+						 BSS_CHANGED_IDLE);
+
+	return ret;
 }
 
 static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
@@ -419,7 +420,7 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 
 	ctx = container_of(conf, struct ieee80211_chanctx, conf);
 
-	ieee80211_unassign_vif_chanctx(sdata, ctx);
+	ieee80211_assign_vif_chanctx(sdata, NULL);
 	if (ctx->refcount == 0)
 		ieee80211_free_chanctx(local, ctx);
 }
-- 
1.9.0


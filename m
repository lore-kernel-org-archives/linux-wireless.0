Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760010Ab3B0PBA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 10:01:00 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 8/8] mac80211: merge reconfig assign chanctx code
Date: Wed, 27 Feb 2013 16:00:42 +0100
Message-Id: <1361977242-17344-8-git-send-email-sgruszka@redhat.com> (sfid-20130227_160105_628125_820CE8DA)
In-Reply-To: <1361977242-17344-1-git-send-email-sgruszka@redhat.com>
References: <1361977242-17344-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/util.c | 47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f5d4e32..b7a856e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1357,6 +1357,25 @@ void ieee80211_stop_device(struct ieee80211_local *local)
 	drv_stop(local);
 }
 
+static void ieee80211_assign_chanctx(struct ieee80211_local *local,
+				     struct ieee80211_sub_if_data *sdata)
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
+		drv_assign_vif_chanctx(local, sdata, ctx);
+	}
+	mutex_unlock(&local->chanctx_mtx);
+}
+
 int ieee80211_reconfig(struct ieee80211_local *local)
 {
 	struct ieee80211_hw *hw = &local->hw;
@@ -1445,36 +1464,14 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	}
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		struct ieee80211_chanctx_conf *ctx_conf;
-
 		if (!ieee80211_sdata_running(sdata))
 			continue;
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
+		ieee80211_assign_chanctx(local, sdata);
 	}
 
 	sdata = rtnl_dereference(local->monitor_sdata);
-	if (sdata && local->use_chanctx && ieee80211_sdata_running(sdata)) {
-		struct ieee80211_chanctx_conf *ctx_conf;
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
-	}
+	if (sdata && ieee80211_sdata_running(sdata))
+		ieee80211_assign_chanctx(local, sdata);
 
 	/* add STAs back */
 	mutex_lock(&local->sta_mtx);
-- 
1.7.11.7


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38112 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbaGYNCo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 09:02:44 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: make ieee80211_vif_use_reserved_switch static
Date: Fri, 25 Jul 2014 15:02:30 +0200
Message-Id: <1406293350-8023-1-git-send-email-johannes@sipsolutions.net> (sfid-20140725_150248_397086_2E3ABA9A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Reorder some code to make ieee80211_vif_use_reserved_switch()
static, no other changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c        | 187 ++++++++++++++++++++++-----------------------
 net/mac80211/ieee80211_i.h |   1 -
 2 files changed, 93 insertions(+), 95 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 6d537f03c0ba..792eac6cc7b3 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -637,41 +637,6 @@ out:
 	return ret;
 }
 
-static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_chanctx_conf *conf;
-	struct ieee80211_chanctx *ctx;
-	bool use_reserved_switch = false;
-
-	lockdep_assert_held(&local->chanctx_mtx);
-
-	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
-					 lockdep_is_held(&local->chanctx_mtx));
-	if (!conf)
-		return;
-
-	ctx = container_of(conf, struct ieee80211_chanctx, conf);
-
-	if (sdata->reserved_chanctx) {
-		if (sdata->reserved_chanctx->replace_state ==
-		    IEEE80211_CHANCTX_REPLACES_OTHER &&
-		    ieee80211_chanctx_num_reserved(local,
-						   sdata->reserved_chanctx) > 1)
-			use_reserved_switch = true;
-
-		ieee80211_vif_unreserve_chanctx(sdata);
-	}
-
-	ieee80211_assign_vif_chanctx(sdata, NULL);
-	if (ieee80211_chanctx_refcount(local, ctx) == 0)
-		ieee80211_free_chanctx(local, ctx);
-
-	/* Unreserving may ready an in-place reservation. */
-	if (use_reserved_switch)
-		ieee80211_vif_use_reserved_switch(local);
-}
-
 void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx)
 {
@@ -762,63 +727,6 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 	drv_change_chanctx(local, chanctx, IEEE80211_CHANCTX_CHANGE_RX_CHAINS);
 }
 
-int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
-			      const struct cfg80211_chan_def *chandef,
-			      enum ieee80211_chanctx_mode mode)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_chanctx *ctx;
-	u8 radar_detect_width = 0;
-	int ret;
-
-	lockdep_assert_held(&local->mtx);
-
-	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
-
-	mutex_lock(&local->chanctx_mtx);
-
-	ret = cfg80211_chandef_dfs_required(local->hw.wiphy,
-					    chandef,
-					    sdata->wdev.iftype);
-	if (ret < 0)
-		goto out;
-	if (ret > 0)
-		radar_detect_width = BIT(chandef->width);
-
-	sdata->radar_required = ret;
-
-	ret = ieee80211_check_combinations(sdata, chandef, mode,
-					   radar_detect_width);
-	if (ret < 0)
-		goto out;
-
-	__ieee80211_vif_release_channel(sdata);
-
-	ctx = ieee80211_find_chanctx(local, chandef, mode);
-	if (!ctx)
-		ctx = ieee80211_new_chanctx(local, chandef, mode);
-	if (IS_ERR(ctx)) {
-		ret = PTR_ERR(ctx);
-		goto out;
-	}
-
-	sdata->vif.bss_conf.chandef = *chandef;
-
-	ret = ieee80211_assign_vif_chanctx(sdata, ctx);
-	if (ret) {
-		/* if assign fails refcount stays the same */
-		if (ieee80211_chanctx_refcount(local, ctx) == 0)
-			ieee80211_free_chanctx(local, ctx);
-		goto out;
-	}
-
-	ieee80211_recalc_smps_chanctx(local, ctx);
-	ieee80211_recalc_radar_chanctx(local, ctx);
- out:
-	mutex_unlock(&local->chanctx_mtx);
-	return ret;
-}
-
 static void
 __ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
 				      bool clear)
@@ -1267,8 +1175,7 @@ err:
 	return err;
 }
 
-int
-ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
+static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata, *sdata_tmp;
 	struct ieee80211_chanctx *ctx, *ctx_tmp, *old_ctx;
@@ -1520,6 +1427,98 @@ err:
 	return err;
 }
 
+static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *conf;
+	struct ieee80211_chanctx *ctx;
+	bool use_reserved_switch = false;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf)
+		return;
+
+	ctx = container_of(conf, struct ieee80211_chanctx, conf);
+
+	if (sdata->reserved_chanctx) {
+		if (sdata->reserved_chanctx->replace_state ==
+		    IEEE80211_CHANCTX_REPLACES_OTHER &&
+		    ieee80211_chanctx_num_reserved(local,
+						   sdata->reserved_chanctx) > 1)
+			use_reserved_switch = true;
+
+		ieee80211_vif_unreserve_chanctx(sdata);
+	}
+
+	ieee80211_assign_vif_chanctx(sdata, NULL);
+	if (ieee80211_chanctx_refcount(local, ctx) == 0)
+		ieee80211_free_chanctx(local, ctx);
+
+	/* Unreserving may ready an in-place reservation. */
+	if (use_reserved_switch)
+		ieee80211_vif_use_reserved_switch(local);
+}
+
+int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
+			      const struct cfg80211_chan_def *chandef,
+			      enum ieee80211_chanctx_mode mode)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx *ctx;
+	u8 radar_detect_width = 0;
+	int ret;
+
+	lockdep_assert_held(&local->mtx);
+
+	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
+
+	mutex_lock(&local->chanctx_mtx);
+
+	ret = cfg80211_chandef_dfs_required(local->hw.wiphy,
+					    chandef,
+					    sdata->wdev.iftype);
+	if (ret < 0)
+		goto out;
+	if (ret > 0)
+		radar_detect_width = BIT(chandef->width);
+
+	sdata->radar_required = ret;
+
+	ret = ieee80211_check_combinations(sdata, chandef, mode,
+					   radar_detect_width);
+	if (ret < 0)
+		goto out;
+
+	__ieee80211_vif_release_channel(sdata);
+
+	ctx = ieee80211_find_chanctx(local, chandef, mode);
+	if (!ctx)
+		ctx = ieee80211_new_chanctx(local, chandef, mode);
+	if (IS_ERR(ctx)) {
+		ret = PTR_ERR(ctx);
+		goto out;
+	}
+
+	sdata->vif.bss_conf.chandef = *chandef;
+
+	ret = ieee80211_assign_vif_chanctx(sdata, ctx);
+	if (ret) {
+		/* if assign fails refcount stays the same */
+		if (ieee80211_chanctx_refcount(local, ctx) == 0)
+			ieee80211_free_chanctx(local, ctx);
+		goto out;
+	}
+
+	ieee80211_recalc_smps_chanctx(local, ctx);
+	ieee80211_recalc_radar_chanctx(local, ctx);
+ out:
+	mutex_unlock(&local->chanctx_mtx);
+	return ret;
+}
+
 int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ef7a089ac546..ffb20e5e6cf3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1869,7 +1869,6 @@ ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 int __must_check
 ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata);
 int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata);
-int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local);
 
 int __must_check
 ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
-- 
2.0.0


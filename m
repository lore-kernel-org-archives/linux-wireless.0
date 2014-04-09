Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:46887 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaDINgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:36:06 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so1886207eek.41
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:36:04 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 12/13] mac80211: compute chanctx refcount on-the-fly
Date: Wed,  9 Apr 2014 15:29:33 +0200
Message-Id: <1397050174-26121-13-git-send-email-michal.kazior@tieto.com> (sfid-20140409_153613_655099_69560C94)
In-Reply-To: <1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
References: <1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
 <1397050174-26121-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to store refcount in
the chanctx structure. One still needs to hold
chanctx_mtx to get the value safely. Besides,
refcount isn't on performance critical paths.

This will make implementing chanctx reservation
refcounting a little easier.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * use assigned/reserved lists instead of
   local->interfaces

 net/mac80211/cfg.c         |  2 +-
 net/mac80211/chan.c        | 59 +++++++++++++++++++++++++++++++++++-----------
 net/mac80211/ieee80211_i.h |  3 ++-
 net/mac80211/mlme.c        |  2 +-
 4 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3bcbf76..e7dd809 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3309,7 +3309,7 @@ int __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 
 	/* don't handle for multi-VIF cases */
 	chanctx = container_of(conf, struct ieee80211_chanctx, conf);
-	if (chanctx->refcount > 1) {
+	if (ieee80211_chanctx_refcount(local, chanctx) > 1) {
 		mutex_unlock(&local->chanctx_mtx);
 		return -EBUSY;
 	}
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index e4166b3..d8b1b86 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -9,6 +9,41 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 
+static int ieee80211_chanctx_num_assigned(struct ieee80211_local *local,
+					  struct ieee80211_chanctx *ctx)
+{
+	struct ieee80211_sub_if_data *sdata;
+	int num = 0;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	list_for_each_entry(sdata, &ctx->assigned_vifs, assigned_chanctx_list)
+		num++;
+
+	return num;
+}
+
+static int ieee80211_chanctx_num_reserved(struct ieee80211_local *local,
+					  struct ieee80211_chanctx *ctx)
+{
+	struct ieee80211_sub_if_data *sdata;
+	int num = 0;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list)
+		num++;
+
+	return num;
+}
+
+int ieee80211_chanctx_refcount(struct ieee80211_local *local,
+			       struct ieee80211_chanctx *ctx)
+{
+	return ieee80211_chanctx_num_assigned(local, ctx) +
+	       ieee80211_chanctx_num_reserved(local, ctx);
+}
+
 static int ieee80211_num_chanctx(struct ieee80211_local *local)
 {
 	struct ieee80211_chanctx *ctx;
@@ -463,7 +498,7 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 {
 	lockdep_assert_held(&local->chanctx_mtx);
 
-	WARN_ON_ONCE(ctx->refcount != 0);
+	WARN_ON_ONCE(ieee80211_chanctx_refcount(local, ctx) != 0);
 
 	list_del_rcu(&ctx->list);
 	ieee80211_del_chanctx(local, ctx);
@@ -542,7 +577,6 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	if (conf) {
 		curr_ctx = container_of(conf, struct ieee80211_chanctx, conf);
 
-		curr_ctx->refcount--;
 		drv_unassign_vif_chanctx(local, sdata, curr_ctx);
 		conf = NULL;
 		list_del(&sdata->assigned_chanctx_list);
@@ -553,7 +587,6 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 		if (ret)
 			goto out;
 
-		new_ctx->refcount++;
 		conf = &new_ctx->conf;
 		list_add(&sdata->assigned_chanctx_list,
 			 &new_ctx->assigned_vifs);
@@ -564,14 +597,14 @@ out:
 
 	sdata->vif.bss_conf.idle = !conf;
 
-	if (curr_ctx && curr_ctx->refcount > 0) {
+	if (curr_ctx && ieee80211_chanctx_num_assigned(local, curr_ctx) > 0) {
 		ieee80211_recalc_chanctx_chantype(local, curr_ctx);
 		ieee80211_recalc_smps_chanctx(local, curr_ctx);
 		ieee80211_recalc_radar_chanctx(local, curr_ctx);
 		ieee80211_recalc_chanctx_min_def(local, curr_ctx);
 	}
 
-	if (new_ctx && new_ctx->refcount > 0) {
+	if (new_ctx && ieee80211_chanctx_num_assigned(local, new_ctx) > 0) {
 		ieee80211_recalc_txpower(sdata);
 		ieee80211_recalc_chanctx_min_def(local, new_ctx);
 	}
@@ -603,7 +636,7 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 		ieee80211_vif_unreserve_chanctx(sdata);
 
 	ieee80211_assign_vif_chanctx(sdata, NULL);
-	if (ctx->refcount == 0)
+	if (ieee80211_chanctx_refcount(local, ctx) == 0)
 		ieee80211_free_chanctx(local, ctx);
 }
 
@@ -735,7 +768,7 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 	ret = ieee80211_assign_vif_chanctx(sdata, ctx);
 	if (ret) {
 		/* if assign fails refcount stays the same */
-		if (ctx->refcount == 0)
+		if (ieee80211_chanctx_refcount(local, ctx) == 0)
 			ieee80211_free_chanctx(local, ctx);
 		goto out;
 	}
@@ -759,7 +792,7 @@ static int __ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
 				     IEEE80211_CHAN_DISABLED))
 		return -EINVAL;
 
-	if (ctx->refcount != 1)
+	if (ieee80211_chanctx_refcount(local, ctx) != 1)
 		return -EINVAL;
 
 	if (sdata->vif.bss_conf.chandef.width != chandef->width) {
@@ -865,7 +898,7 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
 	list_del(&sdata->reserved_chanctx_list);
 	sdata->reserved_chanctx = NULL;
 
-	if (--ctx->refcount == 0)
+	if (ieee80211_chanctx_refcount(sdata->local, ctx) == 0)
 		ieee80211_free_chanctx(sdata->local, ctx);
 
 	return 0;
@@ -894,7 +927,7 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 
 	new_ctx = ieee80211_find_reservation_chanctx(local, chandef, mode);
 	if (!new_ctx) {
-		if (curr_ctx->refcount == 1 &&
+		if (ieee80211_chanctx_refcount(local, curr_ctx) == 1 &&
 		    (local->hw.flags & IEEE80211_HW_CHANGE_RUNNING_CHANCTX)) {
 			/* if we're the only users of the chanctx and
 			 * the driver supports changing a running
@@ -915,7 +948,6 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 	}
 
 	list_add(&sdata->reserved_chanctx_list, &new_ctx->reserved_vifs);
-	new_ctx->refcount++;
 	sdata->reserved_chanctx = new_ctx;
 	sdata->reserved_chandef = *chandef;
 	sdata->reserved_radar_required = radar_required;
@@ -961,7 +993,6 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
 
 	/* unref our reservation */
-	ctx->refcount--;
 	sdata->reserved_chanctx = NULL;
 	sdata->radar_required = sdata->reserved_radar_required;
 	list_del(&sdata->reserved_chanctx_list);
@@ -974,11 +1005,11 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
 			goto out;
 	} else {
 		ret = ieee80211_assign_vif_chanctx(sdata, ctx);
-		if (old_ctx->refcount == 0)
+		if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
 			ieee80211_free_chanctx(local, old_ctx);
 		if (ret) {
 			/* if assign fails refcount stays the same */
-			if (ctx->refcount == 0)
+			if (ieee80211_chanctx_refcount(local, ctx) == 0)
 				ieee80211_free_chanctx(local, ctx);
 			goto out;
 		}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7a60142..6426e5e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -695,7 +695,6 @@ struct ieee80211_chanctx {
 	struct list_head reserved_vifs;
 
 	enum ieee80211_chanctx_mode mode;
-	int refcount;
 	bool driver_present;
 
 	struct ieee80211_chanctx_conf conf;
@@ -1805,6 +1804,8 @@ void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
 					 bool clear);
+int ieee80211_chanctx_refcount(struct ieee80211_local *local,
+			       struct ieee80211_chanctx *ctx);
 
 void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8702bc4..0ea337d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1093,7 +1093,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 	chanctx = container_of(rcu_access_pointer(sdata->vif.chanctx_conf),
 			       struct ieee80211_chanctx, conf);
-	if (chanctx->refcount > 1) {
+	if (ieee80211_chanctx_refcount(local, chanctx) > 1) {
 		sdata_info(sdata,
 			   "channel switch with multiple interfaces on the same channel, disconnecting\n");
 		ieee80211_queue_work(&local->hw,
-- 
1.8.5.3


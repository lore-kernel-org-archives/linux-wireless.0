Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:42044 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbaCRN7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 09:59:24 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so5342668eek.37
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 06:59:23 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 13/21] mac80211: implement multi-vif in-place reservations
Date: Tue, 18 Mar 2014 14:53:16 +0100
Message-Id: <1395150804-24090-14-git-send-email-michal.kazior@tieto.com> (sfid-20140318_150215_086412_044CEE83)
In-Reply-To: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Multi-vif in-place reservations happen when
it's impossible to allocate more chanctx as per
driver combinations.

Such reservations aren't finalized until last
reservation interface calls in to use the
reservation.

This introduces a special hook
ieee80211_vif_chanctx_reservation_complete(). This
is currently an empty stub and will be filled in
by AP/STA CSA code. This is required to implement
2-step CSA finalization.

This also gets rid of driver requirement to be
able to re-program channel of a chanctx.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/mac80211.h     |   7 --
 net/mac80211/chan.c        | 270 +++++++++++++++++++++++++++++++++------------
 net/mac80211/ieee80211_i.h |   4 +-
 3 files changed, 201 insertions(+), 80 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b35c608..86faa41 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1553,12 +1553,6 @@ struct ieee80211_tx_control {
  *	for a single active channel while using channel contexts. When support
  *	is not enabled the default action is to disconnect when getting the
  *	CSA frame.
- *
- * @IEEE80211_HW_CHANGE_RUNNING_CHANCTX: The hardware can change a
- *	channel context on-the-fly.  This is needed for channel switch
- *	on single-channel hardware.  It can also be used as an
- *	optimization in certain channel switch cases with
- *	multi-channel.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1590,7 +1584,6 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TIMING_BEACON_ONLY			= 1<<26,
 	IEEE80211_HW_SUPPORTS_HT_CCK_RATES		= 1<<27,
 	IEEE80211_HW_CHANCTX_STA_CSA			= 1<<28,
-	IEEE80211_HW_CHANGE_RUNNING_CHANCTX		= 1<<29,
 };
 
 /**
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index e99362d..7cf8970 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -175,6 +175,24 @@ ieee80211_find_reservation_chanctx(struct ieee80211_local *local,
 	return NULL;
 }
 
+static bool
+ieee80211_chanctx_all_reserved_vifs_ready(struct ieee80211_local *local,
+					  struct ieee80211_chanctx *ctx)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
+		if (!sdata->reserved_chanctx)
+			continue;
+		if (!sdata->reserved_ready)
+			return false;
+	}
+
+	return true;
+}
+
 static enum nl80211_chan_width ieee80211_get_sta_bw(struct ieee80211_sta *sta)
 {
 	switch (sta->bandwidth) {
@@ -914,38 +932,24 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *new_ctx, *curr_ctx;
-	int ret = 0;
 
-	mutex_lock(&local->chanctx_mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
 
 	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
 					 lockdep_is_held(&local->chanctx_mtx));
-	if (!conf) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!conf)
+		return -EINVAL;
 
 	curr_ctx = container_of(conf, struct ieee80211_chanctx, conf);
 
 	new_ctx = ieee80211_find_reservation_chanctx(local, chandef, mode);
 	if (!new_ctx) {
-		if (ieee80211_chanctx_refcount(local, curr_ctx) == 1 &&
-		    (local->hw.flags & IEEE80211_HW_CHANGE_RUNNING_CHANCTX)) {
-			/* if we're the only users of the chanctx and
-			 * the driver supports changing a running
-			 * context, reserve our current context
-			 */
-			new_ctx = curr_ctx;
-		} else if (ieee80211_can_create_new_chanctx(local)) {
-			/* create a new context and reserve it */
+		if (ieee80211_can_create_new_chanctx(local)) {
 			new_ctx = ieee80211_new_chanctx(local, chandef, mode);
-			if (IS_ERR(new_ctx)) {
-				ret = PTR_ERR(new_ctx);
-				goto out;
-			}
+			if (IS_ERR(new_ctx))
+				return PTR_ERR(new_ctx);
 		} else {
-			ret = -EBUSY;
-			goto out;
+			new_ctx = curr_ctx;
 		}
 	}
 
@@ -953,81 +957,205 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 	sdata->reserved_chanctx = new_ctx;
 	sdata->reserved_chandef = *chandef;
 	sdata->reserved_radar_required = radar_required;
-out:
-	mutex_unlock(&local->chanctx_mtx);
-	return ret;
+	sdata->reserved_ready = false;
+
+	return 0;
 }
 
-int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
-				       u32 *changed)
+static void
+ieee80211_vif_chanctx_reservation_complete(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_chanctx *ctx;
-	struct ieee80211_chanctx *old_ctx;
-	struct ieee80211_chanctx_conf *conf;
-	int ret;
-	u32 tmp_changed = *changed;
+	/* stub */
+}
 
-	/* TODO: need to recheck if the chandef is usable etc.? */
+static int
+ieee80211_vif_use_reserved_incompat(struct ieee80211_local *local,
+				    struct ieee80211_chanctx *ctx,
+				    const struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_sub_if_data *sdata, *tmp;
+	struct ieee80211_chanctx *new_ctx;
+	u32 changed = 0;
+	int err;
 
 	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
 
-	mutex_lock(&local->chanctx_mtx);
+	if (!ieee80211_chanctx_all_reserved_vifs_ready(local, ctx))
+		return 0;
 
-	ctx = sdata->reserved_chanctx;
-	if (WARN_ON(!ctx)) {
-		ret = -EINVAL;
-		goto out;
+	if (ieee80211_chanctx_num_assigned(local, ctx) !=
+	    ieee80211_chanctx_num_reserved(local, ctx)) {
+		wiphy_info(local->hw.wiphy,
+			   "channel context reservation cannot be finalized because some interfaces aren't switching\n");
+		err = -EBUSY;
+		goto err;
 	}
 
-	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
-					 lockdep_is_held(&local->chanctx_mtx));
-	if (!conf) {
-		ret = -EINVAL;
-		goto out;
+	new_ctx = ieee80211_alloc_chanctx(local, chandef, ctx->mode);
+	if (!new_ctx) {
+		err = -ENOMEM;
+		goto err;
 	}
 
-	old_ctx = container_of(conf, struct ieee80211_chanctx, conf);
+	list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
+		drv_unassign_vif_chanctx(local, sdata, ctx);
+		rcu_assign_pointer(sdata->vif.chanctx_conf, &new_ctx->conf);
+	}
 
-	if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
-		tmp_changed |= BSS_CHANGED_BANDWIDTH;
+	list_del_rcu(&ctx->list);
+	ieee80211_del_chanctx(local, ctx);
 
-	sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
+	err = ieee80211_add_chanctx(local, new_ctx);
+	if (err)
+		goto err_revert;
 
-	/* unref our reservation */
-	sdata->reserved_chanctx = NULL;
-	sdata->radar_required = sdata->reserved_radar_required;
-	list_del(&sdata->reserved_chanctx_list);
+	/* don't simply overwrite radar_required in case of failure */
+	list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
+		bool tmp = sdata->radar_required;
+		sdata->radar_required = sdata->reserved_radar_required;
+		sdata->reserved_radar_required = tmp;
+	}
 
-	if (old_ctx == ctx) {
-		/* This is our own context, just change it */
-		ret = __ieee80211_vif_change_channel(sdata, old_ctx,
-						     &tmp_changed);
-		if (ret)
-			goto out;
-	} else {
-		ret = ieee80211_assign_vif_chanctx(sdata, ctx);
-		if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
-			ieee80211_free_chanctx(local, old_ctx);
-		if (ret) {
-			/* if assign fails refcount stays the same */
-			if (ieee80211_chanctx_refcount(local, ctx) == 0)
-				ieee80211_free_chanctx(local, ctx);
-			goto out;
-		}
+	list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
+		err = drv_assign_vif_chanctx(local, sdata, ctx);
+		if (err)
+			goto err_unassign;
+	}
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
 		__ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
-	}
 
-	*changed = tmp_changed;
+	list_add_rcu(&new_ctx->list, &local->chanctx_list);
+	kfree_rcu(ctx, rcu_head);
 
 	ieee80211_recalc_chanctx_chantype(local, ctx);
 	ieee80211_recalc_smps_chanctx(local, ctx);
 	ieee80211_recalc_radar_chanctx(local, ctx);
 	ieee80211_recalc_chanctx_min_def(local, ctx);
+
+	list_for_each_entry_safe(sdata, tmp, &ctx->reserved_vifs,
+				 reserved_chanctx_list) {
+		list_del(&sdata->reserved_chanctx_list);
+		list_move(&sdata->assigned_chanctx_list,
+			  &new_ctx->assigned_vifs);
+		sdata->reserved_chanctx = NULL;
+
+		changed = 0;
+		if (sdata->vif.bss_conf.chandef.width !=
+		    sdata->reserved_chandef.width)
+			changed = BSS_CHANGED_BANDWIDTH;
+
+		sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
+		if (changed)
+			ieee80211_bss_info_change_notify(sdata, changed);
+
+		ieee80211_recalc_txpower(sdata);
+		ieee80211_vif_chanctx_reservation_complete(sdata);
+	}
+
+	return 0;
+
+err_unassign:
+	list_for_each_entry_continue_reverse(sdata, &ctx->reserved_vifs,
+					     reserved_chanctx_list)
+		drv_unassign_vif_chanctx(local, sdata, ctx);
+	ieee80211_del_chanctx(local, new_ctx);
+err_revert:
+	kfree_rcu(new_ctx, rcu_head);
+	WARN_ON(ieee80211_add_chanctx(local, ctx));
+	list_add_rcu(&ctx->list, &local->chanctx_list);
+	list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
+		sdata->radar_required = sdata->reserved_radar_required;
+		rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
+		WARN_ON(drv_assign_vif_chanctx(local, sdata, ctx));
+	}
+err:
+	list_for_each_entry_safe(sdata, tmp, &ctx->reserved_vifs,
+				 reserved_chanctx_list) {
+		list_del(&sdata->reserved_chanctx_list);
+		sdata->reserved_chanctx = NULL;
+		ieee80211_vif_chanctx_reservation_complete(sdata);
+	}
+	return err;
+}
+
+static int
+ieee80211_vif_use_reserved_compat(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_chanctx *old_ctx,
+				  struct ieee80211_chanctx *new_ctx)
+{
+	struct ieee80211_local *local = sdata->local;
+	u32 changed = 0;
+	int err;
+
+	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	list_del(&sdata->reserved_chanctx_list);
+	sdata->reserved_chanctx = NULL;
+
+	err = ieee80211_assign_vif_chanctx(sdata, new_ctx);
+	if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
+		ieee80211_free_chanctx(local, old_ctx);
+	if (err) {
+		/* if assign fails refcount stays the same */
+		if (ieee80211_chanctx_refcount(local, new_ctx) == 0)
+			ieee80211_free_chanctx(local, new_ctx);
+		goto out;
+	}
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		__ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
+
+	if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
+		changed = BSS_CHANGED_BANDWIDTH;
+
+	sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
+
+	if (changed)
+		ieee80211_bss_info_change_notify(sdata, changed);
+
 out:
-	mutex_unlock(&local->chanctx_mtx);
-	return ret;
+	ieee80211_vif_chanctx_reservation_complete(sdata);
+	return err;
+}
+
+int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx *ctx;
+	struct ieee80211_chanctx *old_ctx;
+	struct ieee80211_chanctx_conf *conf;
+	const struct cfg80211_chan_def *chandef;
+
+	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	ctx = sdata->reserved_chanctx;
+	if (WARN_ON(!ctx))
+		return -EINVAL;
+
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf)
+		return -EINVAL;
+
+	old_ctx = container_of(conf, struct ieee80211_chanctx, conf);
+
+	if (WARN_ON(sdata->reserved_ready))
+		return -EINVAL;
+
+	chandef = ieee80211_chanctx_reserved_chandef(local, ctx, NULL);
+	if (WARN_ON(!chandef))
+		return -EINVAL;
+
+	sdata->reserved_ready = true;
+
+	if (cfg80211_chandef_compatible(&ctx->conf.def, chandef))
+		return ieee80211_vif_use_reserved_compat(sdata, old_ctx, ctx);
+	else
+		return ieee80211_vif_use_reserved_incompat(local, ctx, chandef);
 }
 
 int ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2de8121..3c1033a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -765,6 +765,7 @@ struct ieee80211_sub_if_data {
 	struct ieee80211_chanctx *reserved_chanctx;
 	struct cfg80211_chan_def reserved_chandef;
 	bool reserved_radar_required;
+	bool reserved_ready;
 
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
@@ -1785,8 +1786,7 @@ ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 			      enum ieee80211_chanctx_mode mode,
 			      bool radar_required);
 int __must_check
-ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
-				   u32 *changed);
+ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata);
 int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata);
 
 int __must_check
-- 
1.8.5.3


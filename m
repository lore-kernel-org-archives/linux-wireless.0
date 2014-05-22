Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:42667 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaEVOPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:15:09 -0400
Received: by mail-ee0-f43.google.com with SMTP id d17so2673023eek.16
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 07:15:07 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, luca@coelho.fi,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v6 2/6] mac80211: implement multi-vif in-place reservations
Date: Thu, 22 May 2014 16:07:52 +0200
Message-Id: <1400767676-15994-3-git-send-email-michal.kazior@tieto.com> (sfid-20140522_161515_394249_94392C0E)
In-Reply-To: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
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

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * use new_ctx instead of ctx [Eliad]
     * move recalcs after bss_conf is updated [Eliad]
    
    v4:
     * move recalc-radar before vif-chanctx-assign [Eliad]
     * move radar_required swapping before initial add_chanctx() [Eliad]
    
    v5:
     * move kfree_rcu() [Zhao Gang]
    
    v6:
     * use switch_vif_chanctx for incompat case with chanctx drivers [Johannes]
     * fix vlan chanctx copying

 include/net/mac80211.h     |  10 +-
 net/mac80211/chan.c        | 330 +++++++++++++++++++++++++++++++++++----------
 net/mac80211/ieee80211_i.h |   4 +-
 3 files changed, 260 insertions(+), 84 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 831607e..e3cc825 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1580,12 +1580,6 @@ struct ieee80211_tx_control {
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
@@ -1617,7 +1611,6 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TIMING_BEACON_ONLY			= 1<<26,
 	IEEE80211_HW_SUPPORTS_HT_CCK_RATES		= 1<<27,
 	IEEE80211_HW_CHANCTX_STA_CSA			= 1<<28,
-	IEEE80211_HW_CHANGE_RUNNING_CHANCTX		= 1<<29,
 };
 
 /**
@@ -2756,7 +2749,8 @@ enum ieee80211_roc_type {
  * @switch_vif_chanctx: Requests driver to perform a channel switch. It passes
  *	a list of triplets (vif, oldctx, newctx). Driver should try to restore
  *	pre-call state if it fails.
- *	The callback is optional and can sleep.
+ *	The callback is optional for channel context based drivers but is
+ *	required to support channel switching. The callback and can sleep.
  *
  * @start_ap: Start operation on the AP interface, this is called after all the
  *	information in bss_conf is set and beacon can be retrieved. A channel
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 3702d64..3965470 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -173,6 +173,24 @@ ieee80211_find_reservation_chanctx(struct ieee80211_local *local,
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
@@ -912,38 +930,27 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *conf;
 	struct ieee80211_chanctx *new_ctx, *curr_ctx;
-	int ret = 0;
 
-	mutex_lock(&local->chanctx_mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	if (local->use_chanctx && !local->ops->switch_vif_chanctx)
+		return -ENOTSUPP;
 
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
 
@@ -951,82 +958,257 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
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
+ieee80211_vif_use_reserved_incompat_nonctx(struct ieee80211_local *local,
+					   struct ieee80211_chanctx *old_ctx,
+					   struct ieee80211_chanctx *new_ctx,
+					   const struct cfg80211_chan_def *chandef)
+{
+	int err;
 
-	lockdep_assert_held(&local->mtx);
+	ieee80211_del_chanctx(local, old_ctx);
 
-	mutex_lock(&local->chanctx_mtx);
+	err = ieee80211_add_chanctx(local, new_ctx);
+	if (err) {
+		WARN_ON(ieee80211_add_chanctx(local, old_ctx));
+		return err;
+	}
 
-	ctx = sdata->reserved_chanctx;
-	if (WARN_ON(!ctx)) {
-		ret = -EINVAL;
-		goto out;
+	return 0;
+}
+
+static int
+ieee80211_vif_use_reserved_incompat_ctx(struct ieee80211_local *local,
+					struct ieee80211_chanctx *old_ctx,
+					struct ieee80211_chanctx *new_ctx,
+					const struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_sub_if_data *sdata_list[IEEE80211_MAX_NUM_SWITCH_VIFS] = {};
+	struct ieee80211_chanctx *old_ctx_list[IEEE80211_MAX_NUM_SWITCH_VIFS] = {};
+	struct ieee80211_chanctx *new_ctx_list[IEEE80211_MAX_NUM_SWITCH_VIFS] = {};
+	struct ieee80211_sub_if_data *sdata;
+	int n_vifs = 0, err;
+
+	list_for_each_entry(sdata, &old_ctx->reserved_vifs, reserved_chanctx_list) {
+		if (n_vifs > IEEE80211_MAX_NUM_SWITCH_VIFS)
+			return -EBUSY;
+
+		sdata_list[n_vifs] = sdata;
+		old_ctx_list[n_vifs] = old_ctx;
+		new_ctx_list[n_vifs] = new_ctx;
+
+		n_vifs++;
 	}
 
-	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
-					 lockdep_is_held(&local->chanctx_mtx));
-	if (!conf) {
-		ret = -EINVAL;
-		goto out;
+	err = drv_switch_vif_chanctx(local, sdata_list, old_ctx_list,
+				     new_ctx_list, n_vifs,
+				     IEEE80211_CHANCTX_SWMODE_SWAP);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int
+ieee80211_vif_use_reserved_incompat(struct ieee80211_local *local,
+				    struct ieee80211_chanctx *ctx,
+				    const struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_sub_if_data *sdata, *tmp;
+	struct ieee80211_chanctx *new_ctx;
+	u32 changed = 0;
+	int err;
+
+	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	if (!ieee80211_chanctx_all_reserved_vifs_ready(local, ctx))
+		return 0;
+
+	if (ieee80211_chanctx_num_assigned(local, ctx) !=
+	    ieee80211_chanctx_num_reserved(local, ctx)) {
+		wiphy_info(local->hw.wiphy,
+			   "channel context reservation cannot be finalized because some interfaces aren't switching\n");
+		err = -EBUSY;
+		goto err;
 	}
 
-	old_ctx = container_of(conf, struct ieee80211_chanctx, conf);
+	new_ctx = ieee80211_alloc_chanctx(local, chandef, ctx->mode);
+	if (!new_ctx) {
+		err = -ENOMEM;
+		goto err;
+	}
 
-	if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
-		tmp_changed |= BSS_CHANGED_BANDWIDTH;
+	list_del_rcu(&ctx->list);
 
-	sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
+	list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
+		bool tmp = sdata->radar_required;
+		sdata->radar_required = sdata->reserved_radar_required;
+		sdata->reserved_radar_required = tmp;
 
-	/* unref our reservation */
-	sdata->reserved_chanctx = NULL;
-	sdata->radar_required = sdata->reserved_radar_required;
-	list_del(&sdata->reserved_chanctx_list);
+		if (sdata->radar_required)
+			new_ctx->conf.radar_enabled = true;
+	}
 
-	if (old_ctx == ctx) {
-		/* This is our own context, just change it */
-		ret = __ieee80211_vif_change_channel(sdata, old_ctx,
-						     &tmp_changed);
-		if (ret)
-			goto out;
+	if (local->use_chanctx) {
+		err = ieee80211_vif_use_reserved_incompat_ctx(local, ctx,
+							      new_ctx,
+							      chandef);
+		if (err)
+			goto err_revert;
 	} else {
-		ret = ieee80211_assign_vif_chanctx(sdata, ctx);
-		if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
-			ieee80211_free_chanctx(local, old_ctx);
-		if (ret) {
-			/* if assign fails refcount stays the same */
-			if (ieee80211_chanctx_refcount(local, ctx) == 0)
-				ieee80211_free_chanctx(local, ctx);
-			goto out;
-		}
+		err = ieee80211_vif_use_reserved_incompat_nonctx(local, ctx,
+								 new_ctx,
+								 chandef);
+		if (err)
+			goto err_revert;
+	}
+
+	list_add_rcu(&new_ctx->list, &local->chanctx_list);
+
+	list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
+		rcu_assign_pointer(sdata->vif.chanctx_conf, &new_ctx->conf);
 
 		if (sdata->vif.type == NL80211_IFTYPE_AP)
 			__ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
 	}
 
-	*changed = tmp_changed;
+	list_for_each_entry(sdata, &ctx->reserved_vifs,
+			    reserved_chanctx_list) {
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
+	}
+
+	ieee80211_recalc_chanctx_chantype(local, new_ctx);
+	ieee80211_recalc_smps_chanctx(local, new_ctx);
+	ieee80211_recalc_chanctx_min_def(local, new_ctx);
+
+	list_for_each_entry_safe(sdata, tmp, &ctx->reserved_vifs,
+				 reserved_chanctx_list) {
+		list_del(&sdata->reserved_chanctx_list);
+		list_move(&sdata->assigned_chanctx_list,
+			  &new_ctx->assigned_vifs);
+		sdata->reserved_chanctx = NULL;
+
+		ieee80211_vif_chanctx_reservation_complete(sdata);
+	}
+
+	kfree_rcu(ctx, rcu_head);
+	return 0;
+
+err_revert:
+	kfree_rcu(new_ctx, rcu_head);
+	list_add_rcu(&ctx->list, &local->chanctx_list);
+	list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
+		bool tmp = sdata->radar_required;
+		sdata->radar_required = sdata->reserved_radar_required;
+		sdata->reserved_radar_required = tmp;
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
 
-	ieee80211_recalc_chanctx_chantype(local, ctx);
-	ieee80211_recalc_smps_chanctx(local, ctx);
-	ieee80211_recalc_radar_chanctx(local, ctx);
-	ieee80211_recalc_chanctx_min_def(local, ctx);
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
index 69da2d6..340b2ac 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -767,6 +767,7 @@ struct ieee80211_sub_if_data {
 	struct ieee80211_chanctx *reserved_chanctx;
 	struct cfg80211_chan_def reserved_chandef;
 	bool reserved_radar_required;
+	bool reserved_ready;
 
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
@@ -1790,8 +1791,7 @@ ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
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


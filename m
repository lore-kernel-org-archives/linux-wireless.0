Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46004 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931AbaFLNCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 09:02:32 -0400
Received: by mail-wi0-f171.google.com with SMTP id n15so6944900wiw.16
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2014 06:02:31 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi, johannes@sipsolutions.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v9 1/5] mac80211: implement multi-vif in-place reservations
Date: Thu, 12 Jun 2014 14:54:36 +0200
Message-Id: <1402577680-17888-2-git-send-email-michal.kazior@tieto.com> (sfid-20140612_150236_925739_D22792A3)
In-Reply-To: <1402577680-17888-1-git-send-email-michal.kazior@tieto.com>
References: <1401972980-21484-1-git-send-email-michal.kazior@tieto.com>
 <1402577680-17888-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Multi-vif in-place reservations happen when
it is impossible to allocate more channel contexts
as indicated by interface combinations.

Such reservations are not finalized until all
assigned interfaces are ready.

This still doesn't handle all possible cases
(i.e. degradation of number of channels) properly.

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
    
    v7:
     * major rework of the algorithm to support cross-context vif switches (e.g.
       when 2 contexts depend on each others reserved chandefs and both need
       in-place switch)
     * create dummy chanctx structure for in-place reservations instead of storing
       everything in a single chanctx (new chanctx structure needs to be allocated
       sooner or later for drv_switch_vif_chanctx)
     * remove the ieee80211_vif_chanctx_reservation_complete() stub; it is now
       simply implemented by AP CSA patch [Johannes]
     * fix lines with over 80 chars
    
    v8:
     * implement assign reservation (i.e. when old_ctx is NULL) [Luca]
     * expand the TODO description for context shuffling [Luca]
     * add missing !list_empty() when reserving in-place [Luca]
     * fix independ[ae]nt typo [Luca]
     * add comment-labels in the reserved_switch() [Luca]
     * relax in-place verification to allow racy switches to succeed [Luca]
     * refine some comments [Luca]
     * remove WARN_ON for re-assign reservations after in-place reservation [Luca]
     * simplify re-assign reservation condition [Luca]
     * do not propagate error for in-place reservation failure if it was a result
       of a depending old_ctx being ready by re-assign of another vif [Luca]
     * fix in-place reservation context/vif list clearing
     * replace replaces/replaced_by with replace_state(enum)/replace_ctx(pointer) [Johannes]
     * var declare/init cleanup [Luca/Johannes]
     * some condition fixups
    
    v9:
     * fix use-after-free (missing rcu_assign_pointer in _reassign reservation) [Eliad]

 include/net/mac80211.h     |   7 -
 net/mac80211/chan.c        | 632 +++++++++++++++++++++++++++++++++++++++------
 net/mac80211/ieee80211_i.h |  25 +-
 net/mac80211/util.c        |   9 +-
 4 files changed, 582 insertions(+), 91 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 421b6ec..66040af 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1600,12 +1600,6 @@ struct ieee80211_tx_control {
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
@@ -1637,7 +1631,6 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TIMING_BEACON_ONLY			= 1<<26,
 	IEEE80211_HW_SUPPORTS_HT_CCK_RATES		= 1<<27,
 	IEEE80211_HW_CHANCTX_STA_CSA			= 1<<28,
-	IEEE80211_HW_CHANGE_RUNNING_CHANCTX		= 1<<29,
 };
 
 /**
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 3702d64..159f4c3 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -63,6 +63,19 @@ static bool ieee80211_can_create_new_chanctx(struct ieee80211_local *local)
 	return ieee80211_num_chanctx(local) < ieee80211_max_num_channels(local);
 }
 
+static struct ieee80211_chanctx *
+ieee80211_vif_get_chanctx(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_chanctx_conf *conf;
+
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf)
+		return NULL;
+
+	return container_of(conf, struct ieee80211_chanctx, conf);
+}
+
 static const struct cfg80211_chan_def *
 ieee80211_chanctx_reserved_chandef(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *ctx,
@@ -160,6 +173,9 @@ ieee80211_find_reservation_chanctx(struct ieee80211_local *local,
 		return NULL;
 
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED)
+			continue;
+
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
 			continue;
 
@@ -347,6 +363,9 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
 		const struct cfg80211_chan_def *compat;
 
+		if (ctx->replace_state != IEEE80211_CHANCTX_REPLACE_NONE)
+			continue;
+
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
 			continue;
 
@@ -898,8 +917,25 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
 	list_del(&sdata->reserved_chanctx_list);
 	sdata->reserved_chanctx = NULL;
 
-	if (ieee80211_chanctx_refcount(sdata->local, ctx) == 0)
-		ieee80211_free_chanctx(sdata->local, ctx);
+	if (ieee80211_chanctx_refcount(sdata->local, ctx) == 0) {
+		if (ctx->replace_state == IEEE80211_CHANCTX_REPLACES_OTHER) {
+			if (WARN_ON(!ctx->replace_ctx))
+				return -EINVAL;
+
+			WARN_ON(ctx->replace_ctx->replace_state !=
+			        IEEE80211_CHANCTX_WILL_BE_REPLACED);
+			WARN_ON(ctx->replace_ctx->replace_ctx != ctx);
+
+			ctx->replace_ctx->replace_ctx = NULL;
+			ctx->replace_ctx->replace_state =
+					IEEE80211_CHANCTX_REPLACE_NONE;
+
+			list_del_rcu(&ctx->list);
+			kfree_rcu(ctx, rcu_head);
+		} else {
+			ieee80211_free_chanctx(sdata->local, ctx);
+		}
+	}
 
 	return 0;
 }
@@ -910,40 +946,82 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 				  bool radar_required)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_chanctx_conf *conf;
-	struct ieee80211_chanctx *new_ctx, *curr_ctx;
-	int ret = 0;
-
-	mutex_lock(&local->chanctx_mtx);
+	struct ieee80211_chanctx *new_ctx, *curr_ctx, *ctx;
 
-	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
-					 lockdep_is_held(&local->chanctx_mtx));
-	if (!conf) {
-		ret = -EINVAL;
-		goto out;
-	}
+	lockdep_assert_held(&local->chanctx_mtx);
 
-	curr_ctx = container_of(conf, struct ieee80211_chanctx, conf);
+	curr_ctx = ieee80211_vif_get_chanctx(sdata);
+	if (curr_ctx && local->use_chanctx && !local->ops->switch_vif_chanctx)
+		return -ENOTSUPP;
 
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
+			if ((curr_ctx->replace_state ==
+			     IEEE80211_CHANCTX_WILL_BE_REPLACED) ||
+			    !list_empty(&curr_ctx->reserved_vifs)) {
+				/*
+				 * Another vif already requested this context
+				 * for a reservation. Find another one hoping
+				 * all vifs assigned to it will also switch
+				 * soon enough.
+				 *
+				 * TODO: This needs a little more work as some
+				 * cases (more than 2 chanctx capable devices)
+				 * may fail which could otherwise succeed
+				 * provided some channel context juggling was
+				 * performed.
+				 *
+				 * Consider ctx1..3, vif1..6, each ctx has 2
+				 * vifs. vif1 and vif2 from ctx1 request new
+				 * different chandefs starting 2 in-place
+				 * reserations with ctx4 and ctx5 replacing
+				 * ctx1 and ctx2 respectively. Next vif5 and
+				 * vif6 from ctx3 reserve ctx4. If vif3 and
+				 * vif4 remain on ctx2 as they are then this
+				 * fails unless `replace_ctx` from ctx5 is
+				 * replaced with ctx3.
+				 */
+				list_for_each_entry(ctx, &local->chanctx_list,
+						    list) {
+					if (ctx->replace_state !=
+					    IEEE80211_CHANCTX_REPLACE_NONE)
+						continue;
+
+					if (!list_empty(&ctx->reserved_vifs))
+						continue;
+
+					curr_ctx = ctx;
+					break;
+				}
+			}
+
+			/*
+			 * If that's true then all available contexts already
+			 * have reservations and cannot be used.
+			 */
+			if ((curr_ctx->replace_state ==
+			     IEEE80211_CHANCTX_WILL_BE_REPLACED) ||
+			    !list_empty(&curr_ctx->reserved_vifs))
+				return -EBUSY;
+
+			new_ctx = ieee80211_alloc_chanctx(local, chandef, mode);
+			if (!new_ctx)
+				return -ENOMEM;
+
+			new_ctx->replace_ctx = curr_ctx;
+			new_ctx->replace_state =
+					IEEE80211_CHANCTX_REPLACES_OTHER;
+
+			curr_ctx->replace_ctx = new_ctx;
+			curr_ctx->replace_state =
+					IEEE80211_CHANCTX_WILL_BE_REPLACED;
+
+			list_add_rcu(&new_ctx->list, &local->chanctx_list);
 		}
 	}
 
@@ -951,82 +1029,474 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
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
+static int
+ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_chanctx *ctx;
-	struct ieee80211_chanctx *old_ctx;
-	struct ieee80211_chanctx_conf *conf;
-	int ret;
-	u32 tmp_changed = *changed;
-
-	/* TODO: need to recheck if the chandef is usable etc.? */
+	struct ieee80211_vif_chanctx_switch vif_chsw[1] = {};
+	struct ieee80211_chanctx *old_ctx, *new_ctx;
+	const struct cfg80211_chan_def *chandef;
+	u32 changed = 0;
+	int err;
 
 	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
 
-	mutex_lock(&local->chanctx_mtx);
+	new_ctx = sdata->reserved_chanctx;
+	old_ctx = ieee80211_vif_get_chanctx(sdata);
 
-	ctx = sdata->reserved_chanctx;
-	if (WARN_ON(!ctx)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (WARN_ON(!sdata->reserved_ready))
+		return -EBUSY;
 
-	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
-					 lockdep_is_held(&local->chanctx_mtx));
-	if (!conf) {
-		ret = -EINVAL;
-		goto out;
+	if (WARN_ON(!new_ctx))
+		return -EINVAL;
+
+	if (WARN_ON(!old_ctx))
+		return -EINVAL;
+
+	if (WARN_ON(new_ctx->replace_state ==
+		    IEEE80211_CHANCTX_REPLACES_OTHER))
+		return -EINVAL;
+
+	chandef = ieee80211_chanctx_non_reserved_chandef(local, new_ctx,
+				&sdata->reserved_chandef);
+	if (WARN_ON(!chandef))
+		return -EINVAL;
+
+	vif_chsw[0].vif = &sdata->vif;
+	vif_chsw[0].old_ctx = &old_ctx->conf;
+	vif_chsw[0].new_ctx = &new_ctx->conf;
+
+	list_del(&sdata->reserved_chanctx_list);
+	sdata->reserved_chanctx = NULL;
+
+	err = drv_switch_vif_chanctx(local, vif_chsw, 1,
+				     CHANCTX_SWMODE_REASSIGN_VIF);
+	if (err) {
+		if (ieee80211_chanctx_refcount(local, new_ctx) == 0)
+			ieee80211_free_chanctx(local, new_ctx);
+
+		return err;
 	}
 
-	old_ctx = container_of(conf, struct ieee80211_chanctx, conf);
+	list_move(&sdata->assigned_chanctx_list, &new_ctx->assigned_vifs);
+	rcu_assign_pointer(sdata->vif.chanctx_conf, &new_ctx->conf);
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		__ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
+
+	if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
+		ieee80211_free_chanctx(local, old_ctx);
 
 	if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
-		tmp_changed |= BSS_CHANGED_BANDWIDTH;
+		changed = BSS_CHANGED_BANDWIDTH;
 
 	sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
 
-	/* unref our reservation */
-	sdata->reserved_chanctx = NULL;
-	sdata->radar_required = sdata->reserved_radar_required;
+	if (changed)
+		ieee80211_bss_info_change_notify(sdata, changed);
+
+	return err;
+}
+
+static int
+ieee80211_vif_use_reserved_assign(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx *old_ctx, *new_ctx;
+	const struct cfg80211_chan_def *chandef;
+	int err;
+
+	old_ctx = ieee80211_vif_get_chanctx(sdata);
+	new_ctx = sdata->reserved_chanctx;
+
+	if (WARN_ON(!sdata->reserved_ready))
+		return -EINVAL;
+
+	if (WARN_ON(old_ctx))
+		return -EINVAL;
+
+	if (WARN_ON(!new_ctx))
+		return -EINVAL;
+
+	if (WARN_ON(new_ctx->replace_state ==
+		    IEEE80211_CHANCTX_REPLACES_OTHER))
+		return -EINVAL;
+
+	chandef = ieee80211_chanctx_non_reserved_chandef(local, new_ctx,
+				&sdata->reserved_chandef);
+	if (WARN_ON(!chandef))
+		return -EINVAL;
+
 	list_del(&sdata->reserved_chanctx_list);
+	sdata->reserved_chanctx = NULL;
 
-	if (old_ctx == ctx) {
-		/* This is our own context, just change it */
-		ret = __ieee80211_vif_change_channel(sdata, old_ctx,
-						     &tmp_changed);
-		if (ret)
-			goto out;
+	err = ieee80211_assign_vif_chanctx(sdata, new_ctx);
+	if (err) {
+		if (ieee80211_chanctx_refcount(local, new_ctx) == 0)
+			ieee80211_free_chanctx(local, new_ctx);
+
+		goto out;
+	}
+
+out:
+	return err;
+}
+
+static bool
+ieee80211_vif_has_in_place_reservation(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_chanctx *old_ctx, *new_ctx;
+
+	lockdep_assert_held(&sdata->local->chanctx_mtx);
+
+	new_ctx = sdata->reserved_chanctx;
+	old_ctx = ieee80211_vif_get_chanctx(sdata);
+
+	if (!old_ctx)
+		return false;
+
+	if (WARN_ON(!new_ctx))
+		return false;
+
+	if (old_ctx->replace_state != IEEE80211_CHANCTX_WILL_BE_REPLACED)
+		return false;
+
+	if (new_ctx->replace_state != IEEE80211_CHANCTX_REPLACES_OTHER)
+		return false;
+
+	return true;
+}
+
+static int
+ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata, *sdata_tmp;
+	struct ieee80211_chanctx *ctx, *ctx_tmp;
+	struct ieee80211_chanctx *new_ctx = NULL;
+	struct ieee80211_vif_chanctx_switch *vif_chsw = NULL;
+	const struct cfg80211_chan_def *chandef;
+	int i, err;
+	int n_ctx = 0, n_vifs = 0, n_assigned = 0, n_reserved = 0, n_ready = 0;
+
+	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	/*
+	 * If there are 2 independent pairs of channel contexts performing
+	 * cross-switch of their vifs this code will still wait until both are
+	 * ready even though it could be possible to switch one before the
+	 * other is ready.
+	 *
+	 * For practical reasons and code simplicity just do a single huge
+	 * switch.
+	 */
+
+	/*
+	 * Verify if the reservation is still feasible.
+	 *  - if it's not then disconnect
+	 *  - if it is but not all vifs necessary are ready then defer
+	 */
+
+	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->replace_state != IEEE80211_CHANCTX_REPLACES_OTHER)
+			continue;
+
+		if (WARN_ON(!ctx->replace_ctx))
+			return -EINVAL;
+
+		if (!local->use_chanctx)
+			new_ctx = ctx;
+
+		n_ctx++;
+
+		list_for_each_entry(sdata, &ctx->replace_ctx->assigned_vifs,
+				    assigned_chanctx_list) {
+			n_assigned++;
+			if (sdata->reserved_chanctx) {
+				n_reserved++;
+				if (sdata->reserved_ready)
+					n_ready++;
+			}
+		}
+
+		if (n_assigned != n_reserved) {
+			if (n_ready == n_reserved) {
+				wiphy_info(local->hw.wiphy,
+					   "channel context reservation cannot be finalized because some interfaces aren't switching\n");
+				err = -EBUSY;
+				goto err;
+			}
+
+			return -EAGAIN;
+		}
+
+		list_for_each_entry(sdata, &ctx->reserved_vifs,
+				    reserved_chanctx_list) {
+			if (!ieee80211_vif_has_in_place_reservation(sdata))
+				continue;
+
+			if (!sdata->reserved_ready)
+				return -EAGAIN;
+
+			n_vifs++;
+
+			if (sdata->reserved_radar_required)
+				ctx->conf.radar_enabled = true;
+		}
+	}
+
+	if (WARN_ON(n_ctx == 0) ||
+	    WARN_ON(n_vifs == 0) ||
+	    WARN_ON(n_ctx > 1 && !local->use_chanctx) ||
+	    WARN_ON(!new_ctx && !local->use_chanctx)) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	/*
+	 * All necessary vifs are ready. Perform the switch now.
+	 */
+
+	if (local->use_chanctx) {
+		vif_chsw = kzalloc(sizeof(*vif_chsw) * n_vifs, GFP_KERNEL);
+		if (vif_chsw) {
+			err = -ENOMEM;
+			goto err;
+		}
+
+		i = 0;
+		list_for_each_entry(ctx, &local->chanctx_list, list) {
+			if (ctx->replace_state != IEEE80211_CHANCTX_REPLACES_OTHER)
+				continue;
+
+			if (WARN_ON(!ctx->replace_ctx))
+				return -EINVAL;
+
+			list_for_each_entry(sdata, &ctx->reserved_vifs,
+					    reserved_chanctx_list) {
+				if (!ieee80211_vif_has_in_place_reservation(
+						sdata))
+					continue;
+
+				vif_chsw[i].vif = &sdata->vif;
+				vif_chsw[i].old_ctx = &ctx->replace_ctx->conf;
+				vif_chsw[i].new_ctx = &ctx->conf;
+
+				i++;
+			}
+		}
+
+		err = drv_switch_vif_chanctx(local, vif_chsw, n_vifs,
+					     CHANCTX_SWMODE_SWAP_CONTEXTS);
+		kfree(vif_chsw);
+
+		if (err)
+			goto err;
 	} else {
-		ret = ieee80211_assign_vif_chanctx(sdata, ctx);
-		if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
-			ieee80211_free_chanctx(local, old_ctx);
-		if (ret) {
-			/* if assign fails refcount stays the same */
-			if (ieee80211_chanctx_refcount(local, ctx) == 0)
-				ieee80211_free_chanctx(local, ctx);
-			goto out;
+		chandef = ieee80211_chanctx_reserved_chandef(local, new_ctx,
+							     NULL);
+		if (WARN_ON(!chandef)) {
+			err = -EINVAL;
+			goto err;
 		}
 
-		if (sdata->vif.type == NL80211_IFTYPE_AP)
-			__ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
+		local->hw.conf.radar_enabled = new_ctx->conf.radar_enabled;
+		local->_oper_chandef = *chandef;
+		ieee80211_hw_config(local, 0);
 	}
 
-	*changed = tmp_changed;
+	/*
+	 * Update all structures, values and pointers to point to new channel
+	 * context(s).
+	 */
 
-	ieee80211_recalc_chanctx_chantype(local, ctx);
-	ieee80211_recalc_smps_chanctx(local, ctx);
-	ieee80211_recalc_radar_chanctx(local, ctx);
-	ieee80211_recalc_chanctx_min_def(local, ctx);
-out:
-	mutex_unlock(&local->chanctx_mtx);
-	return ret;
+	i = 0;
+	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->replace_state != IEEE80211_CHANCTX_REPLACES_OTHER)
+			continue;
+
+		if (WARN_ON(!ctx->replace_ctx))
+			return -EINVAL;
+
+		list_for_each_entry(sdata, &ctx->reserved_vifs,
+				    reserved_chanctx_list) {
+			u32 changed = 0;
+
+			if (!ieee80211_vif_has_in_place_reservation(sdata))
+				continue;
+
+			rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
+
+			if (sdata->vif.type == NL80211_IFTYPE_AP)
+				__ieee80211_vif_copy_chanctx_to_vlans(sdata,
+								      false);
+
+			sdata->radar_required = sdata->reserved_radar_required;
+
+			if (sdata->vif.bss_conf.chandef.width !=
+			    sdata->reserved_chandef.width)
+				changed = BSS_CHANGED_BANDWIDTH;
+
+			sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
+			if (changed)
+				ieee80211_bss_info_change_notify(sdata,
+								 changed);
+
+			ieee80211_recalc_txpower(sdata);
+		}
+
+		ieee80211_recalc_chanctx_chantype(local, ctx);
+		ieee80211_recalc_smps_chanctx(local, ctx);
+		ieee80211_recalc_radar_chanctx(local, ctx);
+		ieee80211_recalc_chanctx_min_def(local, ctx);
+
+		list_for_each_entry_safe(sdata, sdata_tmp, &ctx->reserved_vifs,
+					 reserved_chanctx_list) {
+			if (ieee80211_vif_get_chanctx(sdata) != ctx)
+				continue;
+
+			list_del(&sdata->reserved_chanctx_list);
+			list_move(&sdata->assigned_chanctx_list,
+				  &new_ctx->assigned_vifs);
+			sdata->reserved_chanctx = NULL;
+		}
+
+		/*
+		 * This context might have been a dependency for an already
+		 * ready re-assign reservation interface that was deferred. Do
+		 * not propagate error to the caller though. The in-place
+		 * reservation for originally requested interface has already
+		 * succeeded at this point.
+		 */
+		list_for_each_entry(sdata, &ctx->reserved_vifs,
+				    reserved_chanctx_list) {
+			if (WARN_ON(ieee80211_vif_has_in_place_reservation(
+					sdata)))
+				continue;
+
+			if (WARN_ON(sdata->reserved_chanctx != ctx))
+				continue;
+
+			if (!sdata->reserved_ready)
+				continue;
+
+			if (ieee80211_vif_get_chanctx(sdata))
+				err = ieee80211_vif_use_reserved_reassign(
+						sdata);
+			else
+				err = ieee80211_vif_use_reserved_assign(sdata);
+
+			if (err) {
+				sdata_info(sdata,
+					   "failed to finalize (re-)assign reservation (err=%d)\n",
+					   err);
+				ieee80211_vif_unreserve_chanctx(sdata);
+				cfg80211_stop_iface(local->hw.wiphy,
+						    &sdata->wdev,
+						    GFP_KERNEL);
+			}
+		}
+	}
+
+	/*
+	 * Finally free old contexts
+	 */
+
+	list_for_each_entry_safe(ctx, ctx_tmp, &local->chanctx_list, list) {
+		if (ctx->replace_state != IEEE80211_CHANCTX_WILL_BE_REPLACED)
+			continue;
+
+		ctx->replace_ctx->replace_ctx = NULL;
+		ctx->replace_ctx->replace_state =
+				IEEE80211_CHANCTX_REPLACE_NONE;
+
+		list_del_rcu(&ctx->list);
+		kfree_rcu(ctx, rcu_head);
+	}
+
+	return 0;
+
+err:
+	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->replace_state != IEEE80211_CHANCTX_REPLACES_OTHER)
+			continue;
+
+		list_for_each_entry_safe(sdata, sdata_tmp, &ctx->reserved_vifs,
+					 reserved_chanctx_list)
+			ieee80211_vif_unreserve_chanctx(sdata);
+	}
+
+	return err;
+}
+
+int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx *new_ctx;
+	struct ieee80211_chanctx *old_ctx;
+	int err;
+
+	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	new_ctx = sdata->reserved_chanctx;
+	old_ctx = ieee80211_vif_get_chanctx(sdata);
+
+	if (WARN_ON(!new_ctx))
+		return -EINVAL;
+
+	if (WARN_ON(new_ctx->replace_state ==
+		    IEEE80211_CHANCTX_WILL_BE_REPLACED))
+		return -EINVAL;
+
+	if (WARN_ON(sdata->reserved_ready))
+		return -EINVAL;
+
+	sdata->reserved_ready = true;
+
+	if (new_ctx->replace_state == IEEE80211_CHANCTX_REPLACE_NONE) {
+		if (old_ctx)
+			err = ieee80211_vif_use_reserved_reassign(sdata);
+		else
+			err = ieee80211_vif_use_reserved_assign(sdata);
+
+		if (err)
+			return err;
+	}
+
+	/*
+	 * In-place reservation may need to be finalized now either if:
+	 *  a) sdata is taking part in the swapping itself and is the last one
+	 *  b) sdata has switched with a re-assign reservation to an existing
+	 *     context readying in-place switching of old_ctx
+	 *
+	 * In case of (b) do not propagate the error up because the requested
+	 * sdata already switched successfully. Just spill an extra warning.
+	 * The ieee80211_vif_use_reserved_switch() already stops all necessary
+	 * interfaces upon failure.
+	 */
+	if ((old_ctx &&
+	     old_ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED) ||
+	    new_ctx->replace_state == IEEE80211_CHANCTX_REPLACES_OTHER) {
+		err = ieee80211_vif_use_reserved_switch(local);
+		if (err && err != -EAGAIN) {
+			if (new_ctx->replace_state ==
+			    IEEE80211_CHANCTX_REPLACES_OTHER)
+				return err;
+
+			wiphy_info(local->hw.wiphy,
+				   "depending in-place reservation failed (err=%d)\n",
+				   err);
+		}
+	}
+
+	return 0;
 }
 
 int ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 677e9c8..4c6dd32 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -700,6 +700,24 @@ enum ieee80211_chanctx_mode {
 	IEEE80211_CHANCTX_EXCLUSIVE
 };
 
+/**
+ * enum ieee80211_chanctx_replace_state - channel context replacement state
+ *
+ * This is used for channel context in-place reservations that require channel
+ * context switch/swap.
+ *
+ * @IEEE80211_CHANCTX_REPLACE_NONE: no replacement is taking place
+ * @IEEE80211_CHANCTX_WILL_BE_REPLACED: this channel context will be replaced
+ *	by a (not yet registered) channel context pointed by %replace_ctx.
+ * @IEEE80211_CHANCTX_REPLACES_OTHER: this (not yet registered) channel context
+ *	replaces an existing channel context pointed to by %replace_ctx.
+ */
+enum ieee80211_chanctx_replace_state {
+	IEEE80211_CHANCTX_REPLACE_NONE,
+	IEEE80211_CHANCTX_WILL_BE_REPLACED,
+	IEEE80211_CHANCTX_REPLACES_OTHER,
+};
+
 struct ieee80211_chanctx {
 	struct list_head list;
 	struct rcu_head rcu_head;
@@ -707,6 +725,9 @@ struct ieee80211_chanctx {
 	struct list_head assigned_vifs;
 	struct list_head reserved_vifs;
 
+	enum ieee80211_chanctx_replace_state replace_state;
+	struct ieee80211_chanctx *replace_ctx;
+
 	enum ieee80211_chanctx_mode mode;
 	bool driver_present;
 
@@ -777,6 +798,7 @@ struct ieee80211_sub_if_data {
 	struct ieee80211_chanctx *reserved_chanctx;
 	struct cfg80211_chan_def reserved_chandef;
 	bool reserved_radar_required;
+	bool reserved_ready;
 
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
@@ -1800,8 +1822,7 @@ ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 			      enum ieee80211_chanctx_mode mode,
 			      bool radar_required);
 int __must_check
-ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
-				   u32 *changed);
+ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata);
 int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata);
 
 int __must_check
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7e0dd4b..8e661ea 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1603,7 +1603,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	if (local->use_chanctx) {
 		mutex_lock(&local->chanctx_mtx);
 		list_for_each_entry(ctx, &local->chanctx_list, list)
-			WARN_ON(drv_add_chanctx(local, ctx));
+			if (ctx->replace_state !=
+			    IEEE80211_CHANCTX_REPLACES_OTHER)
+				WARN_ON(drv_add_chanctx(local, ctx));
 		mutex_unlock(&local->chanctx_mtx);
 
 		list_for_each_entry(sdata, &local->interfaces, list) {
@@ -2876,6 +2878,8 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 		num[iftype] = 1;
 
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED)
+			continue;
 		if (ctx->conf.radar_enabled)
 			radar_detect |= BIT(ctx->conf.def.width);
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) {
@@ -2934,6 +2938,9 @@ int ieee80211_max_num_channels(struct ieee80211_local *local)
 	lockdep_assert_held(&local->chanctx_mtx);
 
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED)
+			continue;
+
 		num_different_channels++;
 
 		if (ctx->conf.radar_enabled)
-- 
1.8.5.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37024 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbaE2Hlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 03:41:45 -0400
Received: by mail-wg0-f44.google.com with SMTP id a1so12363466wgh.27
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2014 00:41:43 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: luca@coelho.fi, johannes@sipsolutions.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v7 1/5] mac80211: implement multi-vif in-place reservations
Date: Thu, 29 May 2014 09:34:07 +0200
Message-Id: <1401348851-26732-2-git-send-email-michal.kazior@tieto.com> (sfid-20140529_094149_234901_CAFD8EE6)
In-Reply-To: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
References: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
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

 include/net/mac80211.h     |   7 -
 net/mac80211/chan.c        | 498 ++++++++++++++++++++++++++++++++++++++-------
 net/mac80211/ieee80211_i.h |   7 +-
 net/mac80211/util.c        |   8 +-
 4 files changed, 433 insertions(+), 87 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 236c5c3..6568cd4 100644
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
index 3702d64..01379a17 100644
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
+		if (ctx->replaced_by)
+			continue;
+
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
 			continue;
 
@@ -347,6 +363,12 @@ ieee80211_find_chanctx(struct ieee80211_local *local,
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
 		const struct cfg80211_chan_def *compat;
 
+		if (ctx->replaces)
+			continue;
+
+		if (ctx->replaced_by)
+			continue;
+
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE)
 			continue;
 
@@ -898,8 +920,16 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
 	list_del(&sdata->reserved_chanctx_list);
 	sdata->reserved_chanctx = NULL;
 
-	if (ieee80211_chanctx_refcount(sdata->local, ctx) == 0)
-		ieee80211_free_chanctx(sdata->local, ctx);
+	if (ieee80211_chanctx_refcount(sdata->local, ctx) == 0) {
+		if (ctx->replaces) {
+			WARN_ON(ctx->replaces->replaced_by != ctx);
+			ctx->replaces->replaced_by = NULL;
+			list_del_rcu(&ctx->list);
+			kfree_rcu(ctx, rcu_head);
+		} else {
+			ieee80211_free_chanctx(sdata->local, ctx);
+		}
+	}
 
 	return 0;
 }
@@ -911,39 +941,71 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *conf;
-	struct ieee80211_chanctx *new_ctx, *curr_ctx;
-	int ret = 0;
+	struct ieee80211_chanctx *new_ctx, *curr_ctx, *ctx;
 
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
+			if (curr_ctx->replaced_by ||
+			    !list_empty(&curr_ctx->reserved_vifs)) {
+				/*
+				 * Another vif already requested this context
+				 * for an in-place reservation. Find another
+				 * one hoping all vifs assigned to it will also
+				 * switch soon enough.
+				 *
+				 * TODO: This needs a little more work as some
+				 * cases may fail which could otherwise succeed
+				 * provided some channel context juggling was
+				 * performed.
+				 */
+				list_for_each_entry(ctx, &local->chanctx_list,
+						    list) {
+					if (ctx->replaced_by)
+						continue;
+
+					if (ctx->replaces)
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
+			 * If that's true then all available contexts are all
+			 * in-place reserved already.
+			 */
+			if (curr_ctx->replaced_by)
+				return -EBUSY;
+
+			new_ctx = ieee80211_alloc_chanctx(local, chandef, mode);
+			if (!new_ctx)
+				return -ENOMEM;
+
+			new_ctx->replaces = curr_ctx;
+			curr_ctx->replaced_by = new_ctx;
+
+			list_add_rcu(&new_ctx->list, &local->chanctx_list);
 		}
 	}
 
@@ -951,82 +1013,364 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
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
+ieee80211_vif_use_reserved_assign(struct ieee80211_sub_if_data *sdata)
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
+	if (WARN_ON(new_ctx->replaced_by))
+		return -EINVAL;
+
+	if (WARN_ON(old_ctx->replaced_by && new_ctx->replaces))
+		return -EINVAL;
+
+	/*
+	 * If target context is in progress of an in-place switching then defer
+	 * the work. This function will be called later again when the target
+	 * context is ready.
+	 */
+	if (new_ctx->replaces)
+		return -EAGAIN;
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
-	list_del(&sdata->reserved_chanctx_list);
+	if (changed)
+		ieee80211_bss_info_change_notify(sdata, changed);
 
-	if (old_ctx == ctx) {
-		/* This is our own context, just change it */
-		ret = __ieee80211_vif_change_channel(sdata, old_ctx,
-						     &tmp_changed);
-		if (ret)
-			goto out;
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
+	if (WARN_ON(!old_ctx))
+		return false;
+
+	if (WARN_ON(!new_ctx))
+		return false;
+
+	if (!old_ctx->replaced_by)
+		return false;
+
+	if (!new_ctx->replaces)
+		return false;
+
+	return true;
+}
+
+static int
+ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata, *sdata_tmp;
+	struct ieee80211_chanctx *new_ctx = NULL, *ctx, *ctx_tmp;
+	struct ieee80211_vif_chanctx_switch *vif_chsw = NULL;
+	const struct cfg80211_chan_def *chandef;
+	int i, err, n_ctx = 0, n_vifs = 0;
+
+	lockdep_assert_held(&local->mtx);
+	lockdep_assert_held(&local->chanctx_mtx);
+
+	/*
+	 * If there are 2 independant pairs of channel contexts performing
+	 * cross-switch of their vifs this code will still wait until both are
+	 * ready even though it could be possible to switch one before the
+	 * other is ready.
+	 *
+	 * For practical reasons and code simplicity just do a single huge
+	 * switch.
+	 */
+
+	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (!(ctx->replaces && !ctx->replaced_by))
+			continue;
+
+		if (!local->use_chanctx)
+			new_ctx = ctx;
+
+		n_ctx++;
+
+		list_for_each_entry(sdata, &ctx->replaces->assigned_vifs,
+				    assigned_chanctx_list) {
+			if (!sdata->reserved_chanctx) {
+				wiphy_info(local->hw.wiphy,
+					   "channel context reservation cannot be finalized because some interfaces aren't switching\n");
+				err = -EBUSY;
+				goto err;
+			}
+
+			if (!sdata->reserved_ready)
+				return -EAGAIN;
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
+	if (local->use_chanctx) {
+		vif_chsw = kzalloc(sizeof(*vif_chsw) * n_vifs, GFP_KERNEL);
+		if (vif_chsw) {
+			err = -ENOMEM;
+			goto err;
+		}
+
+		i = 0;
+		list_for_each_entry(ctx, &local->chanctx_list, list) {
+			if (!(ctx->replaces && !ctx->replaced_by))
+				continue;
+
+			list_for_each_entry(sdata, &ctx->reserved_vifs,
+					    reserved_chanctx_list) {
+				if (!ieee80211_vif_has_in_place_reservation(
+						sdata))
+					continue;
+
+				vif_chsw[i].vif = &sdata->vif;
+				vif_chsw[i].old_ctx = &ctx->replaces->conf;
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
+	i = 0;
+	list_for_each_entry_safe(ctx, ctx_tmp, &local->chanctx_list, list) {
+		if (!(ctx->replaces && !ctx->replaced_by))
+			continue;
 
-	ieee80211_recalc_chanctx_chantype(local, ctx);
-	ieee80211_recalc_smps_chanctx(local, ctx);
-	ieee80211_recalc_radar_chanctx(local, ctx);
-	ieee80211_recalc_chanctx_min_def(local, ctx);
-out:
-	mutex_unlock(&local->chanctx_mtx);
-	return ret;
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
+			list_del(&sdata->reserved_chanctx_list);
+			list_move(&sdata->assigned_chanctx_list,
+				  &new_ctx->assigned_vifs);
+			sdata->reserved_chanctx = NULL;
+		}
+
+		list_del_rcu(&ctx->replaces->list);
+		kfree_rcu(ctx->replaces, rcu_head);
+		ctx->replaces = NULL;
+
+		/*
+		 * Some simple reservations depending on the in-place switch
+		 * might've been ready before and were deferred. Retry them now
+		 * but don't propagate the error up the call stack as the
+		 * directly requested reservation has been already handled
+		 * successfully at this point.
+		 */
+		list_for_each_entry(sdata, &ctx->reserved_vifs,
+				    reserved_chanctx_list) {
+			if (WARN_ON(ieee80211_vif_has_in_place_reservation(
+					sdata)))
+				continue;
+
+			if (!sdata->reserved_ready)
+				continue;
+
+			err = ieee80211_vif_use_reserved_assign(sdata);
+			if (WARN_ON(err && err != -EAGAIN)) {
+				sdata_info(sdata,
+					   "failed to finalize reservation (err=%d)\n",
+					   err);
+				ieee80211_vif_unreserve_chanctx(sdata);
+				cfg80211_stop_iface(local->hw.wiphy,
+						    &sdata->wdev,
+						    GFP_KERNEL);
+			}
+		}
+	}
+
+	return 0;
+
+err:
+	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (!(ctx->replaces && !ctx->replaced_by))
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
+	if (WARN_ON(!old_ctx))
+		return -EINVAL;
+
+	if (WARN_ON(sdata->reserved_ready))
+		return -EINVAL;
+
+	sdata->reserved_ready = true;
+
+	if (!(old_ctx->replaced_by && new_ctx->replaces)) {
+		err = ieee80211_vif_use_reserved_assign(sdata);
+		if (err && err != -EAGAIN)
+			return err;
+	}
+
+	/*
+	 * In-place reservation may need to be finalized now either if:
+	 *  - sdata is taking part in the swapping itself and is the last one
+	 *  - sdata has switched with a simple reservation to an existing
+	 *    context readying the in-place switching old_ctx
+	 */
+
+	if (old_ctx->replaced_by || new_ctx->replaces) {
+		err = ieee80211_vif_use_reserved_switch(local);
+		if (err && err != -EAGAIN)
+			return err;
+	}
+
+	return 0;
 }
 
 int ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 998c18c..1acb879 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -707,6 +707,9 @@ struct ieee80211_chanctx {
 	struct list_head assigned_vifs;
 	struct list_head reserved_vifs;
 
+	struct ieee80211_chanctx *replaces;
+	struct ieee80211_chanctx *replaced_by;
+
 	enum ieee80211_chanctx_mode mode;
 	bool driver_present;
 
@@ -777,6 +780,7 @@ struct ieee80211_sub_if_data {
 	struct ieee80211_chanctx *reserved_chanctx;
 	struct cfg80211_chan_def reserved_chandef;
 	bool reserved_radar_required;
+	bool reserved_ready;
 
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
@@ -1800,8 +1804,7 @@ ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
 			      enum ieee80211_chanctx_mode mode,
 			      bool radar_required);
 int __must_check
-ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
-				   u32 *changed);
+ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata);
 int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata);
 
 int __must_check
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7e0dd4b..6615044 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1603,7 +1603,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	if (local->use_chanctx) {
 		mutex_lock(&local->chanctx_mtx);
 		list_for_each_entry(ctx, &local->chanctx_list, list)
-			WARN_ON(drv_add_chanctx(local, ctx));
+			if (!ctx->replaces)
+				WARN_ON(drv_add_chanctx(local, ctx));
 		mutex_unlock(&local->chanctx_mtx);
 
 		list_for_each_entry(sdata, &local->interfaces, list) {
@@ -2876,6 +2877,8 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 		num[iftype] = 1;
 
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->replaced_by)
+			continue;
 		if (ctx->conf.radar_enabled)
 			radar_detect |= BIT(ctx->conf.def.width);
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) {
@@ -2934,6 +2937,9 @@ int ieee80211_max_num_channels(struct ieee80211_local *local)
 	lockdep_assert_held(&local->chanctx_mtx);
 
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
+		if (ctx->replaced_by)
+			continue;
+
 		num_different_channels++;
 
 		if (ctx->conf.radar_enabled)
-- 
1.8.5.3


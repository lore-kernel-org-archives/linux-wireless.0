Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:50857 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752784AbaFBLda (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 07:33:30 -0400
Message-ID: <1401708800.5528.62.camel@dubbel> (sfid-20140602_133336_191254_1AC9A3CF)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Mon, 02 Jun 2014 14:33:20 +0300
In-Reply-To: <1401348851-26732-2-git-send-email-michal.kazior@tieto.com>
References: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
	 <1401348851-26732-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v7 1/5] mac80211: implement multi-vif in-place
 reservations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-29 at 09:34 +0200, Michal Kazior wrote:
> Multi-vif in-place reservations happen when
> it is impossible to allocate more channel contexts
> as indicated by interface combinations.
> 
> Such reservations are not finalized until all
> assigned interfaces are ready.
> 
> This still doesn't handle all possible cases
> (i.e. degradation of number of channels) properly.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---


> diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
> index 3702d64..01379a17 100644
> --- a/net/mac80211/chan.c
> +++ b/net/mac80211/chan.c
[...]
> @@ -898,8 +920,16 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
>  	list_del(&sdata->reserved_chanctx_list);
>  	sdata->reserved_chanctx = NULL;
>  
> -	if (ieee80211_chanctx_refcount(sdata->local, ctx) == 0)
> -		ieee80211_free_chanctx(sdata->local, ctx);
> +	if (ieee80211_chanctx_refcount(sdata->local, ctx) == 0) {
> +		if (ctx->replaces) {
> +			WARN_ON(ctx->replaces->replaced_by != ctx);
> +			ctx->replaces->replaced_by = NULL;
> +			list_del_rcu(&ctx->list);
> +			kfree_rcu(ctx, rcu_head);

Couldn't this go into the ieee80211_free_chanctx()?

[...]
> @@ -911,39 +941,71 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
>  {
>  	struct ieee80211_local *local = sdata->local;
>  	struct ieee80211_chanctx_conf *conf;
> -	struct ieee80211_chanctx *new_ctx, *curr_ctx;
> -	int ret = 0;
> +	struct ieee80211_chanctx *new_ctx, *curr_ctx, *ctx;
>  
> -	mutex_lock(&local->chanctx_mtx);
> +	lockdep_assert_held(&local->chanctx_mtx);
> +
> +	if (local->use_chanctx && !local->ops->switch_vif_chanctx)
> +		return -ENOTSUPP;

Do we really need to fail here for all reservations (ie. even when it's
not an in-place reservation)?

[...]
>  		} else {
> -			ret = -EBUSY;
> -			goto out;

> +			if (curr_ctx->replaced_by ||
> +			    !list_empty(&curr_ctx->reserved_vifs)) {
> +				/*
> +				 * Another vif already requested this context
> +				 * for an in-place reservation. Find another

If !curr_ctx->replaced_by, then this is not an in-place reservation,
right? the ->reserved_vifs will switch from another context to this one.
The comment is a bit misleading.


> +				 * one hoping all vifs assigned to it will also
> +				 * switch soon enough.
> +				 *
> +				 * TODO: This needs a little more work as some
> +				 * cases may fail which could otherwise succeed
> +				 * provided some channel context juggling was
> +				 * performed.
> +				 */

This TODO seems fair enough, but could you provide at least one example
of such case?


> +				list_for_each_entry(ctx, &local->chanctx_list,
> +						    list) {
> +					if (ctx->replaced_by)
> +						continue;
> +
> +					if (ctx->replaces)
> +						continue;
> +
> +					if (!list_empty(&ctx->reserved_vifs))
> +						continue;
> +
> +					curr_ctx = ctx;
> +					break;
> +				}

I'm probably missing something, because I don't get this.  Do you just
try to find *any* other existing context and "steal" it? Even if the
other context you find has a completely unrelated chandef?


> +			}
> +
> +			/*
> +			 * If that's true then all available contexts are all
> +			 * in-place reserved already.
> +			 */
> +			if (curr_ctx->replaced_by)
> +				return -EBUSY;

What about the reserved_vifs case? You may also get here if
curr_ctx->replaced_by is not true, but curr_ctx->reserved_vifs is not
empty.

[...]
> -int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
> -				       u32 *changed)
> +static int
> +ieee80211_vif_use_reserved_assign(struct ieee80211_sub_if_data *sdata)
>  {
>  	struct ieee80211_local *local = sdata->local;
> -	struct ieee80211_chanctx *ctx;
> -	struct ieee80211_chanctx *old_ctx;
> -	struct ieee80211_chanctx_conf *conf;
> -	int ret;
> -	u32 tmp_changed = *changed;
> -
> -	/* TODO: need to recheck if the chandef is usable etc.? */
> +	struct ieee80211_vif_chanctx_switch vif_chsw[1] = {};
> +	struct ieee80211_chanctx *old_ctx, *new_ctx;
> +	const struct cfg80211_chan_def *chandef;
> +	u32 changed = 0;
> +	int err;
>  
>  	lockdep_assert_held(&local->mtx);
> +	lockdep_assert_held(&local->chanctx_mtx);
>  
> -	mutex_lock(&local->chanctx_mtx);
> +	new_ctx = sdata->reserved_chanctx;
> +	old_ctx = ieee80211_vif_get_chanctx(sdata);
>  
> -	ctx = sdata->reserved_chanctx;
> -	if (WARN_ON(!ctx)) {
> -		ret = -EINVAL;
> -		goto out;
> -	}
> +	if (WARN_ON(!sdata->reserved_ready))
> +		return -EBUSY;
>  
> -	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
> -					 lockdep_is_held(&local->chanctx_mtx));
> -	if (!conf) {
> -		ret = -EINVAL;
> -		goto out;
> +	if (WARN_ON(!new_ctx))
> +		return -EINVAL;
> +
> +	if (WARN_ON(!old_ctx))
> +		return -EINVAL;

You already WARN_ON !new_ctx and !old_ctx in
ieee80211_vif_use_reserved_context().  I know it doesn't hurt, but do
you have to double-check here?


> +
> +	if (WARN_ON(new_ctx->replaced_by))
> +		return -EINVAL;
> +
> +	if (WARN_ON(old_ctx->replaced_by && new_ctx->replaces))
> +		return -EINVAL;

What if new_ctx is going to replace something else?

[...]
> +static int
> +ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
> +{
> +	struct ieee80211_sub_if_data *sdata, *sdata_tmp;
> +	struct ieee80211_chanctx *new_ctx = NULL, *ctx, *ctx_tmp;

I prefer if declarations with assignments are in lines of their own, but
maybe it's just me.


> +	struct ieee80211_vif_chanctx_switch *vif_chsw = NULL;
> +	const struct cfg80211_chan_def *chandef;
> +	int i, err, n_ctx = 0, n_vifs = 0;
> +
> +	lockdep_assert_held(&local->mtx);
> +	lockdep_assert_held(&local->chanctx_mtx);
> +
> +	/*
> +	 * If there are 2 independant pairs of channel contexts performing

Typo, independent.

> +	 * cross-switch of their vifs this code will still wait until both are
> +	 * ready even though it could be possible to switch one before the
> +	 * other is ready.
> +	 *
> +	 * For practical reasons and code simplicity just do a single huge
> +	 * switch.
> +	 */
> +
> +	list_for_each_entry(ctx, &local->chanctx_list, list) {
> +		if (!(ctx->replaces && !ctx->replaced_by))
> +			continue;

if (!ctx->replaces || ctx->replaced_by) looks more natural to me. (Same
thing for some other cases in this patch).


> +
> +		if (!local->use_chanctx)
> +			new_ctx = ctx;
> +
> +		n_ctx++;
> +
> +		list_for_each_entry(sdata, &ctx->replaces->assigned_vifs,
> +				    assigned_chanctx_list) {
> +			if (!sdata->reserved_chanctx) {
> +				wiphy_info(local->hw.wiphy,
> +					   "channel context reservation cannot be finalized because some interfaces aren't switching\n");
> +				err = -EBUSY;
> +				goto err;
> +			}

Hadn't we decided to disconnect the vifs that didn't follow? Can't
remember anymore. :) But now you're just canceling the whole switch?


> +
> +			if (!sdata->reserved_ready)
> +				return -EAGAIN;
> +		}

Shouldn't this be above the previous if? If not everyone switched yet,
can't we give more time for others to join the switch?


> +
> +		list_for_each_entry(sdata, &ctx->reserved_vifs,
> +				    reserved_chanctx_list) {
> +			if (!ieee80211_vif_has_in_place_reservation(sdata))
> +				continue;
> +
> +			if (!sdata->reserved_ready)
> +				return -EAGAIN;
> +
> +			n_vifs++;
> +
> +			if (sdata->reserved_radar_required)
> +				ctx->conf.radar_enabled = true;
> +		}
> +	}
> +
> +	if (WARN_ON(n_ctx == 0) ||
> +	    WARN_ON(n_vifs == 0) ||
> +	    WARN_ON(n_ctx > 1 && !local->use_chanctx) ||
> +	    WARN_ON(!new_ctx && !local->use_chanctx)) {

Can this last WARN ever happen? Only if there's no chanctx at all in the
chanctx_list (which should never happen)?


> +		err = -EINVAL;
> +		goto err;
> +	}
> +
> +	if (local->use_chanctx) {
> +		vif_chsw = kzalloc(sizeof(*vif_chsw) * n_vifs, GFP_KERNEL);
> +		if (vif_chsw) {
> +			err = -ENOMEM;
> +			goto err;
> +		}
> +
> +		i = 0;
> +		list_for_each_entry(ctx, &local->chanctx_list, list) {
> +			if (!(ctx->replaces && !ctx->replaced_by))
> +				continue;
> +
> +			list_for_each_entry(sdata, &ctx->reserved_vifs,
> +					    reserved_chanctx_list) {
> +				if (!ieee80211_vif_has_in_place_reservation(
> +						sdata))
> +					continue;
> +
> +				vif_chsw[i].vif = &sdata->vif;
> +				vif_chsw[i].old_ctx = &ctx->replaces->conf;
> +				vif_chsw[i].new_ctx = &ctx->conf;
> +
> +				i++;
> +			}
> +		}
> +
> +		err = drv_switch_vif_chanctx(local, vif_chsw, n_vifs,
> +					     CHANCTX_SWMODE_SWAP_CONTEXTS);
> +		kfree(vif_chsw);
> +
> +		if (err)
> +			goto err;
>  	} else {
> -		ret = ieee80211_assign_vif_chanctx(sdata, ctx);
> -		if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
> -			ieee80211_free_chanctx(local, old_ctx);
> -		if (ret) {
> -			/* if assign fails refcount stays the same */
> -			if (ieee80211_chanctx_refcount(local, ctx) == 0)
> -				ieee80211_free_chanctx(local, ctx);
> -			goto out;
> +		chandef = ieee80211_chanctx_reserved_chandef(local, new_ctx,
> +							     NULL);
> +		if (WARN_ON(!chandef)) {
> +			err = -EINVAL;
> +			goto err;
>  		}
>  
> -		if (sdata->vif.type == NL80211_IFTYPE_AP)
> -			__ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
> +		local->hw.conf.radar_enabled = new_ctx->conf.radar_enabled;
> +		local->_oper_chandef = *chandef;
> +		ieee80211_hw_config(local, 0);
>  	}
>  
> -	*changed = tmp_changed;
> +	i = 0;
> +	list_for_each_entry_safe(ctx, ctx_tmp, &local->chanctx_list, list) {
> +		if (!(ctx->replaces && !ctx->replaced_by))
> +			continue;
>  
> -	ieee80211_recalc_chanctx_chantype(local, ctx);
> -	ieee80211_recalc_smps_chanctx(local, ctx);
> -	ieee80211_recalc_radar_chanctx(local, ctx);
> -	ieee80211_recalc_chanctx_min_def(local, ctx);
> -out:
> -	mutex_unlock(&local->chanctx_mtx);
> -	return ret;
> +		list_for_each_entry(sdata, &ctx->reserved_vifs,
> +				    reserved_chanctx_list) {
> +			u32 changed = 0;
> +
> +			if (!ieee80211_vif_has_in_place_reservation(sdata))
> +				continue;
> +
> +			rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
> +
> +			if (sdata->vif.type == NL80211_IFTYPE_AP)
> +				__ieee80211_vif_copy_chanctx_to_vlans(sdata,
> +								      false);
> +
> +			sdata->radar_required = sdata->reserved_radar_required;
> +
> +			if (sdata->vif.bss_conf.chandef.width !=
> +			    sdata->reserved_chandef.width)
> +				changed = BSS_CHANGED_BANDWIDTH;
> +
> +			sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
> +			if (changed)
> +				ieee80211_bss_info_change_notify(sdata,
> +								 changed);
> +
> +			ieee80211_recalc_txpower(sdata);
> +		}
> +
> +		ieee80211_recalc_chanctx_chantype(local, ctx);
> +		ieee80211_recalc_smps_chanctx(local, ctx);
> +		ieee80211_recalc_radar_chanctx(local, ctx);
> +		ieee80211_recalc_chanctx_min_def(local, ctx);
> +
> +		list_for_each_entry_safe(sdata, sdata_tmp, &ctx->reserved_vifs,
> +					 reserved_chanctx_list) {
> +			list_del(&sdata->reserved_chanctx_list);
> +			list_move(&sdata->assigned_chanctx_list,
> +				  &new_ctx->assigned_vifs);
> +			sdata->reserved_chanctx = NULL;
> +		}
> +
> +		list_del_rcu(&ctx->replaces->list);
> +		kfree_rcu(ctx->replaces, rcu_head);
> +		ctx->replaces = NULL;
> +
> +		/*
> +		 * Some simple reservations depending on the in-place switch
> +		 * might've been ready before and were deferred. Retry them now
> +		 * but don't propagate the error up the call stack as the
> +		 * directly requested reservation has been already handled
> +		 * successfully at this point.
> +		 */
> +		list_for_each_entry(sdata, &ctx->reserved_vifs,
> +				    reserved_chanctx_list) {
> +			if (WARN_ON(ieee80211_vif_has_in_place_reservation(
> +					sdata)))
> +				continue;
> +
> +			if (!sdata->reserved_ready)
> +				continue;
> +
> +			err = ieee80211_vif_use_reserved_assign(sdata);
> +			if (WARN_ON(err && err != -EAGAIN)) {
 
Do we really want to WARN on other error cases here? It could be some
kind of -EBUSY or so and just disconnecting would be okay?


> +				sdata_info(sdata,
> +					   "failed to finalize reservation (err=%d)\n",
> +					   err);
> +				ieee80211_vif_unreserve_chanctx(sdata);
> +				cfg80211_stop_iface(local->hw.wiphy,
> +						    &sdata->wdev,
> +						    GFP_KERNEL);
> +			}
> +		}
> +	}
> +
> +	return 0;
> +
> +err:
> +	list_for_each_entry(ctx, &local->chanctx_list, list) {
> +		if (!(ctx->replaces && !ctx->replaced_by))
> +			continue;
> +
> +		list_for_each_entry_safe(sdata, sdata_tmp, &ctx->reserved_vifs,
> +					 reserved_chanctx_list)
> +			ieee80211_vif_unreserve_chanctx(sdata);
> +	}
> +
> +	return err;
> +}

This function is huge, any way to break it down? Or at least add
comments before each block explaining what they do...


> +int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_chanctx *new_ctx;
> +	struct ieee80211_chanctx *old_ctx;
> +	int err;
> +
> +	lockdep_assert_held(&local->mtx);
> +	lockdep_assert_held(&local->chanctx_mtx);
> +
> +	new_ctx = sdata->reserved_chanctx;
> +	old_ctx = ieee80211_vif_get_chanctx(sdata);
> +
> +	if (WARN_ON(!new_ctx))
> +		return -EINVAL;
> +
> +	if (WARN_ON(!old_ctx))
> +		return -EINVAL;
> +
> +	if (WARN_ON(sdata->reserved_ready))
> +		return -EINVAL;
> +
> +	sdata->reserved_ready = true;
> +	if (!(old_ctx->replaced_by && new_ctx->replaces)) {

Isn't !old->ctx->replaced_by enough here? Do you really care if the
new_ctx will replace something else at this point?


> +		err = ieee80211_vif_use_reserved_assign(sdata);
> +		if (err && err != -EAGAIN)
> +			return err;
> +	}
> +
> +	/*
> +	 * In-place reservation may need to be finalized now either if:
> +	 *  - sdata is taking part in the swapping itself and is the last one
> +	 *  - sdata has switched with a simple reservation to an existing
> +	 *    context readying the in-place switching old_ctx
> +	 */
> +
> +	if (old_ctx->replaced_by || new_ctx->replaces) {

Same thing here... if new_ctx replaces something *else* shouldn't we use
_assign() instead?


> +		err = ieee80211_vif_use_reserved_switch(local);
> +		if (err && err != -EAGAIN)
> +			return err;
> +	}
> +
> +	return 0;
>  }
[...]

--
Luca.


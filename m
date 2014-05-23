Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39079 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaEWIBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 04:01:17 -0400
Received: by mail-wi0-f171.google.com with SMTP id cc10so409881wib.10
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 01:01:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400812703-15685-1-git-send-email-luca@coelho.fi>
References: <1400769938.4174.29.camel@jlt4.sipsolutions.net>
	<1400812703-15685-1-git-send-email-luca@coelho.fi>
Date: Fri, 23 May 2014 10:01:16 +0200
Message-ID: <CA+BoTQkof_e_T=xegftVHdKK_XFeb2HegOQWmV5+PkCdLkzEyg@mail.gmail.com> (sfid-20140523_100148_859588_0F91565D)
Subject: Re: [PATCH] mac80211: add a single-transaction driver op to switch contexts
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 May 2014 04:38, Luca Coelho <luca@coelho.fi> wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
>
> In some cases, when the driver is already using all the channel
> contexts it can handle at once, we have to do an in-place switch
> (ie. we cannot afford using an extra context temporarily for the
> transaction).  But some drivers may not support switching the channel
> context assigned to a vif on the fly (ie. without unassigning and
> assigning it) while others may only work if the context is changed on
> the fly, without unassigning it first.
>
> To allow these different scenarios, add a new driver operation that
> let's the driver decide how to handle an in-place switch.
>
> Additionally, remove the IEEE80211_HW_CHANGE_RUNNING_CHANCTX flag,
> since we never change a running context directly anymore.
>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---

[...]

> +static int
> +ieee80211_vif_change_reserved_context(struct ieee80211_sub_if_data *sdata,
> +                                     struct ieee80211_chanctx *old_ctx)
> +{
> +       struct ieee80211_local *local = sdata->local;
> +       const struct cfg80211_chan_def *chandef = &sdata->reserved_chandef;
> +       struct ieee80211_chanctx *new_ctx;
> +       struct ieee80211_vif_chanctx_switch vifs[1];
> +       int err, changed;
> +
> +       lockdep_assert_held(&local->mtx);
> +       lockdep_assert_held(&local->chanctx_mtx);
> +
> +       new_ctx = ieee80211_alloc_chanctx(local, chandef, old_ctx->mode);
> +       if (!new_ctx) {
> +               err = -ENOMEM;
> +               goto err;
> +       }
> +
> +       vifs[0].vif = &sdata->vif;
> +       vifs[0].old_ctx = &old_ctx->conf;
> +       vifs[0].new_ctx = &new_ctx->conf;
> +
> +       /* turn idle off *before* setting channel -- some drivers need that */
> +       changed = ieee80211_idle_off(local);

Oh. My code doesn't have that.


> +       ieee80211_hw_config(local, changed);
> +
> +       err = drv_switch_vif_chanctx(local, vifs, 1,
> +                                    CHANCTX_SWMODE_SWAP_CONTEXTS);
> +       if (err)
> +               goto err_idle;
> +
> +       rcu_assign_pointer(sdata->vif.chanctx_conf, &new_ctx->conf);
> +
> +       list_del_rcu(&old_ctx->list);
> +
> +       if (sdata->vif.type == NL80211_IFTYPE_AP)
> +               __ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
> +
> +       list_add_rcu(&new_ctx->list, &local->chanctx_list);
> +       kfree_rcu(old_ctx, rcu_head);
> +
> +       ieee80211_recalc_txpower(sdata);
> +       ieee80211_recalc_chanctx_chantype(local, new_ctx);
> +       ieee80211_recalc_smps_chanctx(local, new_ctx);
> +       ieee80211_recalc_radar_chanctx(local, new_ctx);
> +       ieee80211_recalc_chanctx_min_def(local, new_ctx);
> +       ieee80211_recalc_idle(local);
> +
> +       return 0;
> +
> +err_idle:
> +       ieee80211_recalc_idle(local);
> +       kfree_rcu(new_ctx, rcu_head);
> +err:
> +       return err;
> +

Spurious empty line?

> +}
> +

[...]

> +static inline int
> +drv_switch_vif_chanctx(struct ieee80211_local *local,
> +                      struct ieee80211_vif_chanctx_switch *vifs,
> +                      int n_vifs,
> +                      enum ieee80211_chanctx_switch_mode mode)
> +{
> +       int ret = 0;
> +       int i;
> +
> +       if (!local->ops->switch_vif_chanctx)
> +               return -EOPNOTSUPP;
> +
> +       for (i = 0; i < n_vifs; i++) {
> +               struct ieee80211_chanctx *old_ctx =
> +                       container_of(vifs[i].old_ctx,
> +                                    struct ieee80211_chanctx,
> +                                    conf);
> +
> +               WARN_ON_ONCE(!old_ctx->driver_present);

I guess it's good to do this too:

 WARN_ON_ONCE(mode == SWAP && new_ctx->driver_present);

If you swap then new_ctx must not be in driver yet. It wouldn't make
much sense, would it?


> +       }
> +
> +       trace_drv_switch_vif_chanctx(local, vifs, n_vifs, mode);
> +       ret = local->ops->switch_vif_chanctx(&local->hw,
> +                                            vifs, n_vifs, mode);
> +       trace_drv_return_int(local, ret);
> +
> +       if (!ret && mode == CHANCTX_SWMODE_SWAP_CONTEXTS) {
> +               for (i = 0; i < n_vifs; i++) {
> +                       struct ieee80211_chanctx *new_ctx =
> +                               container_of(vifs[i].new_ctx,
> +                                            struct ieee80211_chanctx,
> +                                            conf);
> +
> +                       new_ctx->driver_present = true;

Oh! I totally forgot about driver_present in my patch :-)

But while at it I'd also do `old_ctx->driver_present = false` even if
it isn't strictly necessary. It just makes it more obvious what
switch_vif_chanctx expects driver to think of new_ctx/old_ctx.


So.. which patch are we going forward with? Luca's or mine? Either way
is fine with me as long as we reach a conclusion :-)


Michał

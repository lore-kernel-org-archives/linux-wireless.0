Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37783 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbaCaQPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2014 12:15:22 -0400
Received: by mail-ig0-f170.google.com with SMTP id uq10so3506464igb.5
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 09:15:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396262371-6466-14-git-send-email-michal.kazior@tieto.com>
References: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	<1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
	<1396262371-6466-14-git-send-email-michal.kazior@tieto.com>
Date: Mon, 31 Mar 2014 19:15:21 +0300
Message-ID: <CAB3XZEcYPPruXSxndMcbaek0ozLZV9GGpqKOAO0WPC6CcT-j7Q@mail.gmail.com> (sfid-20140331_181527_664053_612DCE9C)
Subject: Re: [PATCH v3 13/13] mac80211: implement multi-vif in-place reservations
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Michal,

On Mon, Mar 31, 2014 at 1:39 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> Multi-vif in-place reservations happen when
> it's impossible to allocate more chanctx as per
> driver combinations.
>
> Such reservations aren't finalized until last
> reservation interface calls in to use the
> reservation.
>
> This introduces a special hook
> ieee80211_vif_chanctx_reservation_complete(). This
> is currently an empty stub and will be filled in
> by AP/STA CSA code. This is required to implement
> 2-step CSA finalization.
>
> This also gets rid of driver requirement to be
> able to re-program channel of a chanctx.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>
[...]

> -       /* TODO: need to recheck if the chandef is usable etc.? */
> +static int
> +ieee80211_vif_use_reserved_incompat(struct ieee80211_local *local,
> +                                   struct ieee80211_chanctx *ctx,
> +                                   const struct cfg80211_chan_def *chandef)
> +{
[...]

> +       new_ctx = ieee80211_alloc_chanctx(local, chandef, ctx->mode);
> +       if (!new_ctx) {
> +               err = -ENOMEM;
> +               goto err;
> +       }
> +
> +       list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
> +               drv_unassign_vif_chanctx(local, sdata, ctx);
> +               rcu_assign_pointer(sdata->vif.chanctx_conf, &new_ctx->conf);
> +       }
> +
> +       list_del_rcu(&ctx->list);
> +       ieee80211_del_chanctx(local, ctx);
> +
> +       err = ieee80211_add_chanctx(local, new_ctx);
> +       if (err)
> +               goto err_revert;
> +
> +       /* don't simply overwrite radar_required in case of failure */
> +       list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
> +               bool tmp = sdata->radar_required;
> +               sdata->radar_required = sdata->reserved_radar_required;
> +               sdata->reserved_radar_required = tmp;
> +       }
> +
> +       list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
> +               err = drv_assign_vif_chanctx(local, sdata, new_ctx);
> +               if (err)
> +                       goto err_unassign;
> +       }
> +
better recalc radar before assigning the chanctx. otherwise, you end
up with radar_enabled configuration for non-radar channels -
ieee80211_alloc_chanctx sets radar_enabled if any
sdata->radar_required is true (which is true before the channel
switch).

[...]

> +
> +err_unassign:
> +       list_for_each_entry_continue_reverse(sdata, &ctx->reserved_vifs,
> +                                            reserved_chanctx_list)
> +               drv_unassign_vif_chanctx(local, sdata, ctx);
> +       ieee80211_del_chanctx(local, new_ctx);
> +err_revert:
> +       kfree_rcu(new_ctx, rcu_head);
> +       WARN_ON(ieee80211_add_chanctx(local, ctx));
> +       list_add_rcu(&ctx->list, &local->chanctx_list);
> +       list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
> +               sdata->radar_required = sdata->reserved_radar_required;
> +               rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
> +               WARN_ON(drv_assign_vif_chanctx(local, sdata, ctx));
> +       }
seems like the list_for_each_entry should actually be under err_unassign?

Eliad.

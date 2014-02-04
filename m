Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:41812 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbaBDP0A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 10:26:00 -0500
Received: by mail-bk0-f53.google.com with SMTP id my13so3387749bkb.12
        for <linux-wireless@vger.kernel.org>; Tue, 04 Feb 2014 07:25:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391518767-25847-3-git-send-email-luca@coelho.fi>
References: <1391518767-25847-1-git-send-email-luca@coelho.fi>
	<1391518767-25847-3-git-send-email-luca@coelho.fi>
Date: Tue, 4 Feb 2014 16:25:56 +0100
Message-ID: <CA+BoTQ=mvDJiLOqOCxLQXqYky0c2XNoVBMyAVn2OeO_oymCd-Q@mail.gmail.com> (sfid-20140204_162637_066252_350869B0)
Subject: Re: [RCF/WIP 2/3] mac80211: implement channel switch for multiple
 vifs and multiple channels
From: Michal Kazior <michal.kazior@tieto.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, kvalo@adurom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 February 2014 13:59, Luciano Coelho <luca@coelho.fi> wrote:
> [...]
> +       /* try to find another context with the chandef we want */
> +       new_ctx = ieee80211_find_chanctx(local, chandef,
> +                                        IEEE80211_CHANCTX_SHARED);
> +       if (new_ctx) {
> +               /* reserve the existing compatible context */
> +               sdata->csa_reserved_chanctx = new_ctx;
> +               new_ctx->refcount++;
> +       } else if (curr_ctx->refcount == 1) {
> +               /* We're the only user of the current context, mark it
> +                * as exclusive, so nobody tries to use it until we
> +                * finish the channel switch.  This is an optimization
> +                * to prevent waste of contexts when the number is
> +                * limited.
> +                */
> +
> +               sdata->csa_reserved_chanctx = curr_ctx;
> +               sdata->csa_chandef = *chandef;
> +
> +               sdata->csa_chanctx_old_mode = curr_ctx->mode;
> +
> +               curr_ctx->mode = IEEE80211_CHANCTX_EXCLUSIVE;

The only reason to do this would seem drv_add_chanctx() can fail if
you have too many chanctx in driver.

Perhaps we could defer drv_add_chanctx() for reserved chanctx?


> [...]
> +       if (old_ctx == ctx) {
> +               /* This is our own context, just change it */
> +               ret = __ieee80211_vif_change_channel(sdata, old_ctx,
> +                                                    &local_changed);
> +               if (ret)
> +                       goto out;
> +
> +               /* TODO: what happens if another vif created a context
> +                * that is compatible with our future chandef while
> +                * this one has been marked as exclusive? Merge?
> +                */
> +
> +               ctx->mode = sdata->csa_chanctx_old_mode;
> +
> +               *changed = local_changed;
> +               goto out;
> +       }
> +
> +       ieee80211_stop_queues_by_reason(&local->hw,
> +                                       IEEE80211_MAX_QUEUE_MAP,
> +                                       IEEE80211_QUEUE_STOP_REASON_CSA);
> +

Shouldn't queues be stopped depending on block_tx in CSA IE?


> +       ieee80211_unassign_vif_chanctx(sdata, old_ctx);
> +       if (old_ctx->refcount == 0)
> +               ieee80211_free_chanctx(local, old_ctx);
> +
> +       if (sdata->vif.bss_conf.chandef.width != ctx->conf.def.width)
> +               local_changed |= BSS_CHANGED_BANDWIDTH;

I wonder if this check makes any sense. With multi-interface you can
have varied bss_conf.width and not match the shared width of a channel
context, can't you?


> +
> +       sdata->vif.bss_conf.chandef = ctx->conf.def;
> +
> +       /* unref our reservation before assigning */
> +       ctx->refcount--;
> +       ret = ieee80211_assign_vif_chanctx(sdata, ctx);

This looks wrong. You don't seem to care about old_ctx->refcount here
at all. If you perform CSA for 2 interfaces on a single-channel hw
you'll have 2 interfaces on 2 different channels at one point.

The way I see it should be more like this:

  old_ctx->csa_completions++;
  if (old_ctx->csa_completions != old_ctx->csa_requests)
    goto wait_for_more;

  disconnect_non_csa_interfaces(old_ctx); // *
  // get list of csa vifs from old_ctx
  for_each_csa_vif_in_ctx(sdata)
    unassign_vif_chanctx(sdata, old_ctx)
  free_chanctx(old_ctx) // **
  drv_add_chanctx(new_ctx)
  for_each_csa_vif_in_ctx(sdata)
    assign_vif_chanctx(sdata, new_ctx)

old_ctx->csa_requests would be increased when you reserve a channel.

* "switch or die" policy; ideally this should go through cfg80211
somehow so that everything is teared down properly and userspace is
notified (AP stopped)

** this might remove the need for the exclusive reserved chanctx?


> +       if (ret) {
> +               /* if assign fails refcount stays the same */
> +               if (ctx->refcount == 0)
> +                       ieee80211_free_chanctx(local, ctx);
> +               goto out;
> +       }
> +
> +       /* TODO: should we wake the queues here? */

Hmm.. you probably should wake queues if this was the last channel
switch for the hw.


Michał

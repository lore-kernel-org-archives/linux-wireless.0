Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:44922 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaBEOcT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 09:32:19 -0500
Message-ID: <1391610736.16723.92.camel@porter.coelho.fi> (sfid-20140205_153229_576534_CEFF5FD0)
Subject: Re: [RCF/WIP 2/3] mac80211: implement channel switch for multiple
 vifs and multiple channels
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, kvalo@adurom.com
Date: Wed, 05 Feb 2014 16:32:16 +0200
In-Reply-To: <CA+BoTQ=mvDJiLOqOCxLQXqYky0c2XNoVBMyAVn2OeO_oymCd-Q@mail.gmail.com>
References: <1391518767-25847-1-git-send-email-luca@coelho.fi>
	 <1391518767-25847-3-git-send-email-luca@coelho.fi>
	 <CA+BoTQ=mvDJiLOqOCxLQXqYky0c2XNoVBMyAVn2OeO_oymCd-Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-04 at 16:25 +0100, Michal Kazior wrote:
> On 4 February 2014 13:59, Luciano Coelho <luca@coelho.fi> wrote:
> > [...]
> > +       /* try to find another context with the chandef we want */
> > +       new_ctx = ieee80211_find_chanctx(local, chandef,
> > +                                        IEEE80211_CHANCTX_SHARED);
> > +       if (new_ctx) {
> > +               /* reserve the existing compatible context */
> > +               sdata->csa_reserved_chanctx = new_ctx;
> > +               new_ctx->refcount++;
> > +       } else if (curr_ctx->refcount == 1) {
> > +               /* We're the only user of the current context, mark it
> > +                * as exclusive, so nobody tries to use it until we
> > +                * finish the channel switch.  This is an optimization
> > +                * to prevent waste of contexts when the number is
> > +                * limited.
> > +                */
> > +
> > +               sdata->csa_reserved_chanctx = curr_ctx;
> > +               sdata->csa_chandef = *chandef;
> > +
> > +               sdata->csa_chanctx_old_mode = curr_ctx->mode;
> > +
> > +               curr_ctx->mode = IEEE80211_CHANCTX_EXCLUSIVE;
> 
> The only reason to do this would seem drv_add_chanctx() can fail if
> you have too many chanctx in driver.

This is just an optimization case.  I'm not even sure every driver will
be able to change the chanctx on the fly so we probably would need to
add a HWCONF flag for that.

And the idea here is to prevent others from joining out chanctx since we
are going to change it in the near future.  Whoever joins now probably
wants the current configuration not our future one.

Maybe we could add a new mode, IEEE80211_CHANCTX_CHANNEL_SWITCH, so
other vifs would only be able to reserve it if their future config
matches our future config?

This starts complicating things too much for a small optimization that
may not even work with every driver.  Perhaps is better to just remove
the old context and add a new for this case as well...


> Perhaps we could defer drv_add_chanctx() for reserved chanctx?

I'm not sure I understand.  For this situation (ie. we're alone in the
chanctx) we don't do a drv_add_chanctx().


> > [...]
> > +       if (old_ctx == ctx) {
> > +               /* This is our own context, just change it */
> > +               ret = __ieee80211_vif_change_channel(sdata, old_ctx,
> > +                                                    &local_changed);
> > +               if (ret)
> > +                       goto out;
> > +
> > +               /* TODO: what happens if another vif created a context
> > +                * that is compatible with our future chandef while
> > +                * this one has been marked as exclusive? Merge?
> > +                */
> > +
> > +               ctx->mode = sdata->csa_chanctx_old_mode;
> > +
> > +               *changed = local_changed;
> > +               goto out;
> > +       }
> > +
> > +       ieee80211_stop_queues_by_reason(&local->hw,
> > +                                       IEEE80211_MAX_QUEUE_MAP,
> > +                                       IEEE80211_QUEUE_STOP_REASON_CSA);
> > +
> 
> Shouldn't queues be stopped depending on block_tx in CSA IE?

That is the case when we *receive* the CSA.  At this point, we're
already making the actual channel switch.  The queues are stopped here
because we're going to unassign the current chanctx and assign a new one
and we don't want to send frames meanwhile.  It doesn't hurt if they
were already stopped before, it will be a NOP.


> > +       ieee80211_unassign_vif_chanctx(sdata, old_ctx);
> > +       if (old_ctx->refcount == 0)
> > +               ieee80211_free_chanctx(local, old_ctx);
> > +
> > +       if (sdata->vif.bss_conf.chandef.width != ctx->conf.def.width)
> > +               local_changed |= BSS_CHANGED_BANDWIDTH;
> 
> I wonder if this check makes any sense. With multi-interface you can
> have varied bss_conf.width and not match the shared width of a channel
> context, can't you?

You're right.  I guess I should set this flag according to what happens
when I call ieee80211_recalc_chanctx_chantype().  Maybe the nicest thing
to do would be to change that function so that it returns changed flags
(which will be either 0 or BSS_CHANGED_BANDWIDTH).

I'll look into that.


> > +
> > +       sdata->vif.bss_conf.chandef = ctx->conf.def;
> > +
> > +       /* unref our reservation before assigning */
> > +       ctx->refcount--;
> > +       ret = ieee80211_assign_vif_chanctx(sdata, ctx);
> 
> This looks wrong. You don't seem to care about old_ctx->refcount here
> at all. If you perform CSA for 2 interfaces on a single-channel hw
> you'll have 2 interfaces on 2 different channels at one point.

I'm unassigning the vif from old_ctx (a few lines above).  And now, I'm
reassigning the vif to ctx (the new one).

I think instead of caring about the single-channel stuff here, it should
be handled in the ieee80211_reserve_chanctx() function.  It's one of the
reasons for having the reservation in the first place.


> The way I see it should be more like this:
> 
>   old_ctx->csa_completions++;
>   if (old_ctx->csa_completions != old_ctx->csa_requests)
>     goto wait_for_more;
> 
>   disconnect_non_csa_interfaces(old_ctx); // *
>   // get list of csa vifs from old_ctx
>   for_each_csa_vif_in_ctx(sdata)
>     unassign_vif_chanctx(sdata, old_ctx)
>   free_chanctx(old_ctx) // **
>   drv_add_chanctx(new_ctx)
>   for_each_csa_vif_in_ctx(sdata)
>     assign_vif_chanctx(sdata, new_ctx)
> 
> old_ctx->csa_requests would be increased when you reserve a channel.
> 
> * "switch or die" policy; ideally this should go through cfg80211
> somehow so that everything is teared down properly and userspace is
> notified (AP stopped)
> 
> ** this might remove the need for the exclusive reserved chanctx?

One of the problems here is that you're checking if the switch can
succeed only at the end of the process.  The idea is to fail channel
switch requests as soon as they come in.

I agree that, during the reservation, we need a bit more logic to take
care of the interface combinations and the single-channel cases.  But
not here.  When I implemented this patch, I was not considering !chanctx
nor single-radio device. ;)

The idea with reservation is more or less like this, as an example:

We have a STA and a P2P-GO (which follows the STA).

1. STA gets CSA from the AP
2. STA makes a reservation for the new context (here the possibility of
creating a new context is checked)
3. the GO controller (ie. wpa_s) gets a notification that there is a
switch going on for the STA
4. the GO wants to follow, so it also reserves the same new context (the
new context is not really used yet, but reserved twice)
5. the STA completes the CS countdown and uses its reservation
6. the GO completes the CS countdown and uses its reservation
7. now the original context doesn't have any user anymore (ie.
refcount=0) and can be freed

5 and 6 can happen in a different order too, it doesn't matter.

Of course this assumes multi-radio.  The assumption in this patch is
that if you don't have multi-radio and have 2 interfaces on the same
channel, the channel switch will fail (and we disconnect).  Fixing that
comes on top with your patches. ;)

I like your idea of synchronizing things before the switch to help the
single-channel case.  But I think we should still have the reservation.
When using the reservation we could check whether the  and trying to
free old_ctx) we could check whether the contexts are valid together, if
not, delay the usage of the reserved context until the new combinations
is fine.


> 
> > +       if (ret) {
> > +               /* if assign fails refcount stays the same */
> > +               if (ctx->refcount == 0)
> > +                       ieee80211_free_chanctx(local, ctx);
> > +               goto out;
> > +       }
> > +
> > +       /* TODO: should we wake the queues here? */
> 
> Hmm.. you probably should wake queues if this was the last channel
> switch for the hw.

Yes, the queues should be woken here, when the new chanctx is fully
available.

--
Luca.


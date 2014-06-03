Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:45656 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaFCGPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 02:15:23 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so6208334wes.18
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2014 23:15:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401708800.5528.62.camel@dubbel>
References: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
	<1401348851-26732-2-git-send-email-michal.kazior@tieto.com>
	<1401708800.5528.62.camel@dubbel>
Date: Tue, 3 Jun 2014 08:15:20 +0200
Message-ID: <CA+BoTQnhOePTuDrzv_YNU6dmroRydqWfNjSj_e0UT6=SWu5r9w@mail.gmail.com> (sfid-20140603_081527_043206_16EE21C4)
Subject: Re: [PATCH v7 1/5] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 June 2014 13:33, Luca Coelho <luca@coelho.fi> wrote:
> On Thu, 2014-05-29 at 09:34 +0200, Michal Kazior wrote:
>> Multi-vif in-place reservations happen when
>> it is impossible to allocate more channel contexts
>> as indicated by interface combinations.
>>
>> Such reservations are not finalized until all
>> assigned interfaces are ready.
>>
>> This still doesn't handle all possible cases
>> (i.e. degradation of number of channels) properly.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>
>
>> diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
>> index 3702d64..01379a17 100644
>> --- a/net/mac80211/chan.c
>> +++ b/net/mac80211/chan.c
> [...]
>> @@ -898,8 +920,16 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
>>       list_del(&sdata->reserved_chanctx_list);
>>       sdata->reserved_chanctx = NULL;
>>
>> -     if (ieee80211_chanctx_refcount(sdata->local, ctx) == 0)
>> -             ieee80211_free_chanctx(sdata->local, ctx);
>> +     if (ieee80211_chanctx_refcount(sdata->local, ctx) == 0) {
>> +             if (ctx->replaces) {
>> +                     WARN_ON(ctx->replaces->replaced_by != ctx);
>> +                     ctx->replaces->replaced_by = NULL;
>> +                     list_del_rcu(&ctx->list);
>> +                     kfree_rcu(ctx, rcu_head);
>
> Couldn't this go into the ieee80211_free_chanctx()?

I'm afraid not. At least not as it is now. ieee80211_free_chanctx()
calls ieee80211_del_chanctx() (and thus drv_remove_chanctx) which must
not be called when doing drv_switch_vif_chanctx(..., SWAP).


> [...]
>> @@ -911,39 +941,71 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
>>  {
>>       struct ieee80211_local *local = sdata->local;
>>       struct ieee80211_chanctx_conf *conf;
>> -     struct ieee80211_chanctx *new_ctx, *curr_ctx;
>> -     int ret = 0;
>> +     struct ieee80211_chanctx *new_ctx, *curr_ctx, *ctx;
>>
>> -     mutex_lock(&local->chanctx_mtx);
>> +     lockdep_assert_held(&local->chanctx_mtx);
>> +
>> +     if (local->use_chanctx && !local->ops->switch_vif_chanctx)
>> +             return -ENOTSUPP;
>
> Do we really need to fail here for all reservations (ie. even when it's
> not an in-place reservation)?

Good point. I guess this should be enforced only if given sdata has a
chanctx already bound. If there's no chanctx bound at all then it
should be a simple matter of assign_vif_chanctx. This isn't covered
yet.

I should either add:

 if (!ieee80211_vif_chanctx(sdata))
   return -ENOTSUPP;

.. or handle the vif_assign case (and update the condition you pointed
out to consider current chanctx).


> [...]
>>               } else {
>> -                     ret = -EBUSY;
>> -                     goto out;
>
>> +                     if (curr_ctx->replaced_by ||
>> +                         !list_empty(&curr_ctx->reserved_vifs)) {
>> +                             /*
>> +                              * Another vif already requested this context
>> +                              * for an in-place reservation. Find another
>
> If !curr_ctx->replaced_by, then this is not an in-place reservation,
> right? the ->reserved_vifs will switch from another context to this one.
> The comment is a bit misleading.

Ah, you're right. It should just state "another vif already requested
this context for a reservation".


>> +                              * one hoping all vifs assigned to it will also
>> +                              * switch soon enough.
>> +                              *
>> +                              * TODO: This needs a little more work as some
>> +                              * cases may fail which could otherwise succeed
>> +                              * provided some channel context juggling was
>> +                              * performed.
>> +                              */
>
> This TODO seems fair enough, but could you provide at least one example
> of such case?

Hmm... (my brain..)

Consider the following: 3 ctx, 6 vifs. cannot create more ctx.
ctx1=vif1+vif2, ctx2=vif3+vif4, ctx3=vif5+vif6. ctx1..3 have
chandef1..3.

vif5 wants chandef4 so it allocates ctx4 and sets `replaces` to ctx3.
vif6 wants chandef5 so it allocates ctx5 and sets `replaces` to ctx1.
[ note ctx1 with its assigned vif1 and vif2 ]
vif3 wants chandef5 so it reserves ctx5.
vif4 wants chandef5 so it reserves ctx5.
[ ctx2 could be considered now as "free" and could be set as
`replaces` for ctx5 instead of ctx1 ]

It's pretty far fetched for now I'd say - are there any devices that
support more than 2 channels now?

For max_chans=2 devices this turns into a single in-place and doesn't
require extra the trick. With the optimization present it would split
the single in-place switch into in-place + re-assign + in-place.


>> +                             list_for_each_entry(ctx, &local->chanctx_list,
>> +                                                 list) {
>> +                                     if (ctx->replaced_by)
>> +                                             continue;
>> +
>> +                                     if (ctx->replaces)
>> +                                             continue;
>> +
>> +                                     if (!list_empty(&ctx->reserved_vifs))
>> +                                             continue;
>> +
>> +                                     curr_ctx = ctx;
>> +                                     break;
>> +                             }
>
> I'm probably missing something, because I don't get this.  Do you just
> try to find *any* other existing context and "steal" it? Even if the
> other context you find has a completely unrelated chandef?

Correct. There's a chance it will align with other switches and
there's a chance to swap the replaces/replaced_by between in-place
future chanctx. I guess it's better to give it a chance.


>> +                     }
>> +
>> +                     /*
>> +                      * If that's true then all available contexts are all
>> +                      * in-place reserved already.
>> +                      */
>> +                     if (curr_ctx->replaced_by)
>> +                             return -EBUSY;
>
> What about the reserved_vifs case? You may also get here if
> curr_ctx->replaced_by is not true, but curr_ctx->reserved_vifs is not
> empty.

Good catch! I didn't update this condition properly.


> [...]
>> -int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
>> -                                    u32 *changed)
>> +static int
>> +ieee80211_vif_use_reserved_assign(struct ieee80211_sub_if_data *sdata)
>>  {
>>       struct ieee80211_local *local = sdata->local;
>> -     struct ieee80211_chanctx *ctx;
>> -     struct ieee80211_chanctx *old_ctx;
>> -     struct ieee80211_chanctx_conf *conf;
>> -     int ret;
>> -     u32 tmp_changed = *changed;
>> -
>> -     /* TODO: need to recheck if the chandef is usable etc.? */
>> +     struct ieee80211_vif_chanctx_switch vif_chsw[1] = {};
>> +     struct ieee80211_chanctx *old_ctx, *new_ctx;
>> +     const struct cfg80211_chan_def *chandef;
>> +     u32 changed = 0;
>> +     int err;
>>
>>       lockdep_assert_held(&local->mtx);
>> +     lockdep_assert_held(&local->chanctx_mtx);
>>
>> -     mutex_lock(&local->chanctx_mtx);
>> +     new_ctx = sdata->reserved_chanctx;
>> +     old_ctx = ieee80211_vif_get_chanctx(sdata);
>>
>> -     ctx = sdata->reserved_chanctx;
>> -     if (WARN_ON(!ctx)) {
>> -             ret = -EINVAL;
>> -             goto out;
>> -     }
>> +     if (WARN_ON(!sdata->reserved_ready))
>> +             return -EBUSY;
>>
>> -     conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
>> -                                      lockdep_is_held(&local->chanctx_mtx));
>> -     if (!conf) {
>> -             ret = -EINVAL;
>> -             goto out;
>> +     if (WARN_ON(!new_ctx))
>> +             return -EINVAL;
>> +
>> +     if (WARN_ON(!old_ctx))
>> +             return -EINVAL;
>
> You already WARN_ON !new_ctx and !old_ctx in
> ieee80211_vif_use_reserved_context().  I know it doesn't hurt, but do
> you have to double-check here?

Just staying on the safe side of "better print twice than nothing" (in
case this ends up being called by other functions in the future). I
actually think it's a good idea to state function requirements like
this.


>> +
>> +     if (WARN_ON(new_ctx->replaced_by))
>> +             return -EINVAL;
>> +
>> +     if (WARN_ON(old_ctx->replaced_by && new_ctx->replaces))
>> +             return -EINVAL;
>
> What if new_ctx is going to replace something else?

Shouldn't happen - that's why WARN_ON.


> [...]
>> +static int
>> +ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
>> +{
>> +     struct ieee80211_sub_if_data *sdata, *sdata_tmp;
>> +     struct ieee80211_chanctx *new_ctx = NULL, *ctx, *ctx_tmp;
>
> I prefer if declarations with assignments are in lines of their own, but
> maybe it's just me.

Actually fair point. I'm declaring multiple vars here..


>> +     struct ieee80211_vif_chanctx_switch *vif_chsw = NULL;
>> +     const struct cfg80211_chan_def *chandef;
>> +     int i, err, n_ctx = 0, n_vifs = 0;
>> +
>> +     lockdep_assert_held(&local->mtx);
>> +     lockdep_assert_held(&local->chanctx_mtx);
>> +
>> +     /*
>> +      * If there are 2 independant pairs of channel contexts performing
>
> Typo, independent.

Roger.


>> +      * cross-switch of their vifs this code will still wait until both are
>> +      * ready even though it could be possible to switch one before the
>> +      * other is ready.
>> +      *
>> +      * For practical reasons and code simplicity just do a single huge
>> +      * switch.
>> +      */
>> +
>> +     list_for_each_entry(ctx, &local->chanctx_list, list) {
>> +             if (!(ctx->replaces && !ctx->replaced_by))
>> +                     continue;
>
> if (!ctx->replaces || ctx->replaced_by) looks more natural to me. (Same
> thing for some other cases in this patch).

I find it easier to reason with my condition. But yeah. Popular vote? :-)


>> +
>> +             if (!local->use_chanctx)
>> +                     new_ctx = ctx;
>> +
>> +             n_ctx++;
>> +
>> +             list_for_each_entry(sdata, &ctx->replaces->assigned_vifs,
>> +                                 assigned_chanctx_list) {
>> +                     if (!sdata->reserved_chanctx) {
>> +                             wiphy_info(local->hw.wiphy,
>> +                                        "channel context reservation cannot be finalized because some interfaces aren't switching\n");
>> +                             err = -EBUSY;
>> +                             goto err;
>> +                     }
>
> Hadn't we decided to disconnect the vifs that didn't follow? Can't
> remember anymore. :) But now you're just canceling the whole switch?

I'm not sure myself anymore either. This keeps the current behaviour
(i.e. disconnect interfaces that are switching on failure). Johannes?


>> +
>> +                     if (!sdata->reserved_ready)
>> +                             return -EAGAIN;
>> +             }
>
> Shouldn't this be above the previous if? If not everyone switched yet,
> can't we give more time for others to join the switch?

This is okay as it is. reserved_chanctx means there is a reservation
ongoing. reserved_ready means it is ready for the switch itself.

If you reach this place you already have at least one vif ready for
the switch but it needs in-place to be done. If there are still any
assigned interfaces not complying then this fails the whole switch.

I guess you could relax this to fail after assigned interfaces that
have reservations are all ready and there are still some assigned
interfaces left without reservation at all. I guess it might increase
a chance of a racy channel switch to succeed. Just a little tiny bit.


>> +
>> +             list_for_each_entry(sdata, &ctx->reserved_vifs,
>> +                                 reserved_chanctx_list) {
>> +                     if (!ieee80211_vif_has_in_place_reservation(sdata))
>> +                             continue;
>> +
>> +                     if (!sdata->reserved_ready)
>> +                             return -EAGAIN;
>> +
>> +                     n_vifs++;
>> +
>> +                     if (sdata->reserved_radar_required)
>> +                             ctx->conf.radar_enabled = true;
>> +             }
>> +     }
>> +
>> +     if (WARN_ON(n_ctx == 0) ||
>> +         WARN_ON(n_vifs == 0) ||
>> +         WARN_ON(n_ctx > 1 && !local->use_chanctx) ||
>> +         WARN_ON(!new_ctx && !local->use_chanctx)) {
>
> Can this last WARN ever happen? Only if there's no chanctx at all in the
> chanctx_list (which should never happen)?

True, but this explicitly tells you "new_ctx cannot be NULL beyond
this point without use_chanctx". I'd like to keep it.


>> +             err = -EINVAL;
>> +             goto err;
>> +     }
>> +
>> +     if (local->use_chanctx) {
>> +             vif_chsw = kzalloc(sizeof(*vif_chsw) * n_vifs, GFP_KERNEL);
>> +             if (vif_chsw) {
>> +                     err = -ENOMEM;
>> +                     goto err;
>> +             }
>> +
>> +             i = 0;
>> +             list_for_each_entry(ctx, &local->chanctx_list, list) {
>> +                     if (!(ctx->replaces && !ctx->replaced_by))
>> +                             continue;
>> +
>> +                     list_for_each_entry(sdata, &ctx->reserved_vifs,
>> +                                         reserved_chanctx_list) {
>> +                             if (!ieee80211_vif_has_in_place_reservation(
>> +                                             sdata))
>> +                                     continue;
>> +
>> +                             vif_chsw[i].vif = &sdata->vif;
>> +                             vif_chsw[i].old_ctx = &ctx->replaces->conf;
>> +                             vif_chsw[i].new_ctx = &ctx->conf;
>> +
>> +                             i++;
>> +                     }
>> +             }
>> +
>> +             err = drv_switch_vif_chanctx(local, vif_chsw, n_vifs,
>> +                                          CHANCTX_SWMODE_SWAP_CONTEXTS);
>> +             kfree(vif_chsw);
>> +
>> +             if (err)
>> +                     goto err;
>>       } else {
>> -             ret = ieee80211_assign_vif_chanctx(sdata, ctx);
>> -             if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
>> -                     ieee80211_free_chanctx(local, old_ctx);
>> -             if (ret) {
>> -                     /* if assign fails refcount stays the same */
>> -                     if (ieee80211_chanctx_refcount(local, ctx) == 0)
>> -                             ieee80211_free_chanctx(local, ctx);
>> -                     goto out;
>> +             chandef = ieee80211_chanctx_reserved_chandef(local, new_ctx,
>> +                                                          NULL);
>> +             if (WARN_ON(!chandef)) {
>> +                     err = -EINVAL;
>> +                     goto err;
>>               }
>>
>> -             if (sdata->vif.type == NL80211_IFTYPE_AP)
>> -                     __ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
>> +             local->hw.conf.radar_enabled = new_ctx->conf.radar_enabled;
>> +             local->_oper_chandef = *chandef;
>> +             ieee80211_hw_config(local, 0);
>>       }
>>
>> -     *changed = tmp_changed;
>> +     i = 0;
>> +     list_for_each_entry_safe(ctx, ctx_tmp, &local->chanctx_list, list) {
>> +             if (!(ctx->replaces && !ctx->replaced_by))
>> +                     continue;
>>
>> -     ieee80211_recalc_chanctx_chantype(local, ctx);
>> -     ieee80211_recalc_smps_chanctx(local, ctx);
>> -     ieee80211_recalc_radar_chanctx(local, ctx);
>> -     ieee80211_recalc_chanctx_min_def(local, ctx);
>> -out:
>> -     mutex_unlock(&local->chanctx_mtx);
>> -     return ret;
>> +             list_for_each_entry(sdata, &ctx->reserved_vifs,
>> +                                 reserved_chanctx_list) {
>> +                     u32 changed = 0;
>> +
>> +                     if (!ieee80211_vif_has_in_place_reservation(sdata))
>> +                             continue;
>> +
>> +                     rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
>> +
>> +                     if (sdata->vif.type == NL80211_IFTYPE_AP)
>> +                             __ieee80211_vif_copy_chanctx_to_vlans(sdata,
>> +                                                                   false);
>> +
>> +                     sdata->radar_required = sdata->reserved_radar_required;
>> +
>> +                     if (sdata->vif.bss_conf.chandef.width !=
>> +                         sdata->reserved_chandef.width)
>> +                             changed = BSS_CHANGED_BANDWIDTH;
>> +
>> +                     sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
>> +                     if (changed)
>> +                             ieee80211_bss_info_change_notify(sdata,
>> +                                                              changed);
>> +
>> +                     ieee80211_recalc_txpower(sdata);
>> +             }
>> +
>> +             ieee80211_recalc_chanctx_chantype(local, ctx);
>> +             ieee80211_recalc_smps_chanctx(local, ctx);
>> +             ieee80211_recalc_radar_chanctx(local, ctx);
>> +             ieee80211_recalc_chanctx_min_def(local, ctx);
>> +
>> +             list_for_each_entry_safe(sdata, sdata_tmp, &ctx->reserved_vifs,
>> +                                      reserved_chanctx_list) {
>> +                     list_del(&sdata->reserved_chanctx_list);
>> +                     list_move(&sdata->assigned_chanctx_list,
>> +                               &new_ctx->assigned_vifs);
>> +                     sdata->reserved_chanctx = NULL;
>> +             }
>> +
>> +             list_del_rcu(&ctx->replaces->list);
>> +             kfree_rcu(ctx->replaces, rcu_head);
>> +             ctx->replaces = NULL;
>> +
>> +             /*
>> +              * Some simple reservations depending on the in-place switch
>> +              * might've been ready before and were deferred. Retry them now
>> +              * but don't propagate the error up the call stack as the
>> +              * directly requested reservation has been already handled
>> +              * successfully at this point.
>> +              */
>> +             list_for_each_entry(sdata, &ctx->reserved_vifs,
>> +                                 reserved_chanctx_list) {
>> +                     if (WARN_ON(ieee80211_vif_has_in_place_reservation(
>> +                                     sdata)))
>> +                             continue;
>> +
>> +                     if (!sdata->reserved_ready)
>> +                             continue;
>> +
>> +                     err = ieee80211_vif_use_reserved_assign(sdata);
>> +                     if (WARN_ON(err && err != -EAGAIN)) {
>
> Do we really want to WARN on other error cases here? It could be some
> kind of -EBUSY or so and just disconnecting would be okay?

See the comment above.

This takes care of related reservations. These reservations aren't
strictly the main subject for this function call so I don't really
agree to propagate the error up. The in-place reservation that was the
purpose of this call was a success at this point.

This failure shouldn't happen in most cases unless thing go really bad
so I guess it's fine like this.

Actually the caller should also be aware of this, because in-place may
happen as a side-effect to re-assign (due to dependencies).


>> +                             sdata_info(sdata,
>> +                                        "failed to finalize reservation (err=%d)\n",
>> +                                        err);
>> +                             ieee80211_vif_unreserve_chanctx(sdata);
>> +                             cfg80211_stop_iface(local->hw.wiphy,
>> +                                                 &sdata->wdev,
>> +                                                 GFP_KERNEL);
>> +                     }
>> +             }
>> +     }
>> +
>> +     return 0;
>> +
>> +err:
>> +     list_for_each_entry(ctx, &local->chanctx_list, list) {
>> +             if (!(ctx->replaces && !ctx->replaced_by))
>> +                     continue;
>> +
>> +             list_for_each_entry_safe(sdata, sdata_tmp, &ctx->reserved_vifs,
>> +                                      reserved_chanctx_list)
>> +                     ieee80211_vif_unreserve_chanctx(sdata);
>> +     }
>> +
>> +     return err;
>> +}
>
> This function is huge, any way to break it down? Or at least add
> comments before each block explaining what they do...

I'm aware of this. I've thought about splitting it but I'm afraid
it'll end up with a very artificial break up and code duplication (or
silly function arguments). Comment blocks might be the way to go here.


>> +int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata)
>> +{
>> +     struct ieee80211_local *local = sdata->local;
>> +     struct ieee80211_chanctx *new_ctx;
>> +     struct ieee80211_chanctx *old_ctx;
>> +     int err;
>> +
>> +     lockdep_assert_held(&local->mtx);
>> +     lockdep_assert_held(&local->chanctx_mtx);
>> +
>> +     new_ctx = sdata->reserved_chanctx;
>> +     old_ctx = ieee80211_vif_get_chanctx(sdata);
>> +
>> +     if (WARN_ON(!new_ctx))
>> +             return -EINVAL;
>> +
>> +     if (WARN_ON(!old_ctx))
>> +             return -EINVAL;
>> +
>> +     if (WARN_ON(sdata->reserved_ready))
>> +             return -EINVAL;
>> +
>> +     sdata->reserved_ready = true;
>> +     if (!(old_ctx->replaced_by && new_ctx->replaces)) {
>
> Isn't !old->ctx->replaced_by enough here? Do you really care if the
> new_ctx will replace something else at this point?

Hmm..

Now that I think this should actually be just:

 if (!new_ctx->replaces) { ... }

You can only perform the re-assign here if the destination chanctx is
already operational.

If new_ctx->replaces is not NULL then the chanctx isn't there yet
(drv_switch_vif_chanctx wasn't called yet).

To better understand this you have to consider 3 cases of reservations:
 a) reassign vif from a chanctx that is going away to a chanctx that
already exists
 b) reassign vif from a chanctx that isn't going away to a chanctx
that doesn't exist yet
 c) reassign vif from a chanctx that is going away to a chanctx that
doesn't exist yet

The above code handles (a). The code below that handles (c). The
reservation with WARN_ON you pointed out earlier handles (b).

IOW you can have reservations depend on each other: (b) depends on (c)
which depends on (a).

(ad. b. The old chanctx might go away if it's the last vif switching)


>> +             err = ieee80211_vif_use_reserved_assign(sdata);
>> +             if (err && err != -EAGAIN)
>> +                     return err;
>> +     }
>> +
>> +     /*
>> +      * In-place reservation may need to be finalized now either if:
>> +      *  - sdata is taking part in the swapping itself and is the last one
>> +      *  - sdata has switched with a simple reservation to an existing
>> +      *    context readying the in-place switching old_ctx
>> +      */
>> +
>> +     if (old_ctx->replaced_by || new_ctx->replaces) {
>
> Same thing here... if new_ctx replaces something *else* shouldn't we use
> _assign() instead?

It doesn't matter what it replaces. If it replaces anything you can't
(re)assign to it just yet because it's a part of an incomplete
in-place reservation. Think about a circular in-place reservations
between chanctxs and vifs.

The condition should be this way because there are 2 cases you want to
call this (as stated in the comment):
 1) the _assign() above was the last dependency on old_ctx that is
taking part in an in-place reservation
 2) the _assign() wasn't even called because the sdata is taking part
in an in-place reservation itself


If you think my logic is flawed at any point or still have any doubts
do not hesitate to point it out. I'm not guaranteed to be correct :-)


Michał

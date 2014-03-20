Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:60601 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaCTHZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 03:25:46 -0400
Received: by mail-ob0-f171.google.com with SMTP id wn1so470813obc.30
        for <linux-wireless@vger.kernel.org>; Thu, 20 Mar 2014 00:25:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEc3wqpEVg=qSDeuGAKCTh_dRV2HyQJBSHvfq5p0EEuAmg@mail.gmail.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395150804-24090-14-git-send-email-michal.kazior@tieto.com>
	<CAB3XZEc3wqpEVg=qSDeuGAKCTh_dRV2HyQJBSHvfq5p0EEuAmg@mail.gmail.com>
Date: Thu, 20 Mar 2014 08:25:46 +0100
Message-ID: <CA+BoTQ=wz1Yiv9Wu2XsuxGnFo+mt8F+dYrd69odx_veOJnTEDA@mail.gmail.com> (sfid-20140320_082550_609841_0CA87B8F)
Subject: Re: [RFC 13/21] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 March 2014 19:35, Eliad Peller <eliad@wizery.com> wrote:
> On Tue, Mar 18, 2014 at 3:53 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> Multi-vif in-place reservations happen when
>> it's impossible to allocate more chanctx as per
>> driver combinations.
>>
>> Such reservations aren't finalized until last
>> reservation interface calls in to use the
>> reservation.
>>
>> This introduces a special hook
>> ieee80211_vif_chanctx_reservation_complete(). This
>> is currently an empty stub and will be filled in
>> by AP/STA CSA code. This is required to implement
>> 2-step CSA finalization.
>>
>> This also gets rid of driver requirement to be
>> able to re-program channel of a chanctx.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
> [...]
>
> i started playing with the patches and got some warnings.
> they seem to come from:
>
>> +static int
>> +ieee80211_vif_use_reserved_incompat(struct ieee80211_local *local,
>> +                                   struct ieee80211_chanctx *ctx,
>> +                                   const struct cfg80211_chan_def *chandef)
>> +{
> [...]
>
>> +       new_ctx = ieee80211_alloc_chanctx(local, chandef, ctx->mode);
>> +       if (!new_ctx) {
>> +               err = -ENOMEM;
>> +               goto err;
>>         }
>>
>> -       old_ctx = container_of(conf, struct ieee80211_chanctx, conf);
>> +       list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
>> +               drv_unassign_vif_chanctx(local, sdata, ctx);
>> +               rcu_assign_pointer(sdata->vif.chanctx_conf, &new_ctx->conf);
>> +       }
>>
>> -       if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
>> -               tmp_changed |= BSS_CHANGED_BANDWIDTH;
>> +       list_del_rcu(&ctx->list);
>> +       ieee80211_del_chanctx(local, ctx);
>>
>> -       sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
>> +       err = ieee80211_add_chanctx(local, new_ctx);
>> +       if (err)
>> +               goto err_revert;
>>
>> -       /* unref our reservation */
>> -       sdata->reserved_chanctx = NULL;
>> -       sdata->radar_required = sdata->reserved_radar_required;
>> -       list_del(&sdata->reserved_chanctx_list);
>> +       /* don't simply overwrite radar_required in case of failure */
>> +       list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
>> +               bool tmp = sdata->radar_required;
>> +               sdata->radar_required = sdata->reserved_radar_required;
>> +               sdata->reserved_radar_required = tmp;
>> +       }
>>
>> -       if (old_ctx == ctx) {
>> -               /* This is our own context, just change it */
>> -               ret = __ieee80211_vif_change_channel(sdata, old_ctx,
>> -                                                    &tmp_changed);
>> -               if (ret)
>> -                       goto out;
>> -       } else {
>> -               ret = ieee80211_assign_vif_chanctx(sdata, ctx);
>> -               if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
>> -                       ieee80211_free_chanctx(local, old_ctx);
>> -               if (ret) {
>> -                       /* if assign fails refcount stays the same */
>> -                       if (ieee80211_chanctx_refcount(local, ctx) == 0)
>> -                               ieee80211_free_chanctx(local, ctx);
>> -                       goto out;
>> -               }
>> +       list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
>> +               err = drv_assign_vif_chanctx(local, sdata, ctx);
>
> this should be new_ctx (ctx was already removed from the driver, etc.)

Good catch, thanks!


>> +               if (err)
>> +                       goto err_unassign;
>> +       }
>>
>> +       if (sdata->vif.type == NL80211_IFTYPE_AP)
>>                 __ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
>> -       }
>>
>> -       *changed = tmp_changed;
>> +       list_add_rcu(&new_ctx->list, &local->chanctx_list);
>> +       kfree_rcu(ctx, rcu_head);
>>
>>         ieee80211_recalc_chanctx_chantype(local, ctx);
>>         ieee80211_recalc_smps_chanctx(local, ctx);
>>         ieee80211_recalc_radar_chanctx(local, ctx);
>>         ieee80211_recalc_chanctx_min_def(local, ctx);
>
> and same here i guess.

Yep. You're right.


> all the recalcs have to be moved after setting bss_conf.chandef in the
> following loop, as otherwise you it recalcs according to the old
> configuration (which is incompatible with the new one).

Thanks for pointing that out. I'll fix that too.


Michał

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:55756 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaDAFKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 01:10:02 -0400
Received: by mail-we0-f171.google.com with SMTP id t61so5594418wes.2
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2014 22:10:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEcYPPruXSxndMcbaek0ozLZV9GGpqKOAO0WPC6CcT-j7Q@mail.gmail.com>
References: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	<1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
	<1396262371-6466-14-git-send-email-michal.kazior@tieto.com>
	<CAB3XZEcYPPruXSxndMcbaek0ozLZV9GGpqKOAO0WPC6CcT-j7Q@mail.gmail.com>
Date: Tue, 1 Apr 2014 07:10:00 +0200
Message-ID: <CA+BoTQkXWscUL-XLL1sBNb=eXahafoCUazsNKVFU08X9bPdBPQ@mail.gmail.com> (sfid-20140401_071009_396598_4A3FCFE2)
Subject: Re: [PATCH v3 13/13] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 March 2014 18:15, Eliad Peller <eliad@wizery.com> wrote:
> hi Michal,
>
> On Mon, Mar 31, 2014 at 1:39 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
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
>>
> [...]
>
>> -       /* TODO: need to recheck if the chandef is usable etc.? */
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
>> +       }
>> +
>> +       list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
>> +               drv_unassign_vif_chanctx(local, sdata, ctx);
>> +               rcu_assign_pointer(sdata->vif.chanctx_conf, &new_ctx->conf);
>> +       }
>> +
>> +       list_del_rcu(&ctx->list);
>> +       ieee80211_del_chanctx(local, ctx);
>> +
>> +       err = ieee80211_add_chanctx(local, new_ctx);
>> +       if (err)
>> +               goto err_revert;
>> +
>> +       /* don't simply overwrite radar_required in case of failure */
>> +       list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
>> +               bool tmp = sdata->radar_required;
>> +               sdata->radar_required = sdata->reserved_radar_required;
>> +               sdata->reserved_radar_required = tmp;
>> +       }
>> +
>> +       list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
>> +               err = drv_assign_vif_chanctx(local, sdata, new_ctx);
>> +               if (err)
>> +                       goto err_unassign;
>> +       }
>> +
> better recalc radar before assigning the chanctx. otherwise, you end
> up with radar_enabled configuration for non-radar channels -
> ieee80211_alloc_chanctx sets radar_enabled if any
> sdata->radar_required is true (which is true before the channel
> switch).

Good point, thanks!


>
> [...]
>
>> +
>> +err_unassign:
>> +       list_for_each_entry_continue_reverse(sdata, &ctx->reserved_vifs,
>> +                                            reserved_chanctx_list)
>> +               drv_unassign_vif_chanctx(local, sdata, ctx);
>> +       ieee80211_del_chanctx(local, new_ctx);
>> +err_revert:
>> +       kfree_rcu(new_ctx, rcu_head);
>> +       WARN_ON(ieee80211_add_chanctx(local, ctx));
>> +       list_add_rcu(&ctx->list, &local->chanctx_list);
>> +       list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
>> +               sdata->radar_required = sdata->reserved_radar_required;
>> +               rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
>> +               WARN_ON(drv_assign_vif_chanctx(local, sdata, ctx));
>> +       }
> seems like the list_for_each_entry should actually be under err_unassign?

No. This is correct. The err_unassign is used to bail out if any
drv_assign_vif_chanctx fails mid-way. We want to unassign only those
vif-chanctx we only managed to assign.


Michał

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44224 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbaEFMrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 08:47:18 -0400
Received: by mail-wi0-f178.google.com with SMTP id hm4so844378wib.5
        for <linux-wireless@vger.kernel.org>; Tue, 06 May 2014 05:47:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399372915.4218.17.camel@jlt4.sipsolutions.net>
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	<1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	<1399372915.4218.17.camel@jlt4.sipsolutions.net>
Date: Tue, 6 May 2014 14:47:15 +0200
Message-ID: <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com> (sfid-20140506_144722_883054_7C933AF9)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>,
	Simon Wunderlich <sw@simonwunderlich.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 May 2014 12:41, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi Michal, all,
>
> So I finally got around to discussing this with Luca and getting a
> better understanding of what we have right now and where we're going to
> this. Unfortunately (for you :) ) I don't think we're quite on the right
> track between what we have and what you (and others) are doing here and
> what we'll want.

Yay! :-)


>
>>       IEEE80211_HW_CHANCTX_STA_CSA                    = 1<<28,
>> -     IEEE80211_HW_CHANGE_RUNNING_CHANCTX             = 1<<29,
>
> Right now we have this, along with WIPHY_FLAG_HAS_CHANNEL_SWITCH (which
> we still turn off upstream though)
>
>> +     list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
>> +             drv_unassign_vif_chanctx(local, sdata, ctx);
>> +             rcu_assign_pointer(sdata->vif.chanctx_conf, &new_ctx->conf);
>> +     }
>> +
>> +     list_del_rcu(&ctx->list);
>> +     ieee80211_del_chanctx(local, ctx);
>> +
>> +     /* don't simply overwrite radar_required in case of failure */
>> +     list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
>> +             bool tmp = sdata->radar_required;
>> +             sdata->radar_required = sdata->reserved_radar_required;
>> +             sdata->reserved_radar_required = tmp;
>> +     }
>> +
>> +     ieee80211_recalc_radar_chanctx(local, new_ctx);
>> +
>> +     err = ieee80211_add_chanctx(local, new_ctx);
>> +     if (err)
>> +             goto err_revert;
>> +
>> +     list_for_each_entry(sdata, &ctx->reserved_vifs, reserved_chanctx_list) {
>> +             err = drv_assign_vif_chanctx(local, sdata, new_ctx);
>> +             if (err)
>> +                     goto err_unassign;
>> +     }
>
> I think this is problematic in terms of the channel context API, as is
> the "unassign while in use" case of ieee80211_vif_use_reserved_context()
> through the call of ieee80211_assign_vif_chanctx() (unassign is inside
> of that.)
>
> Without those APIs, we have perfect ordering between using the channel
> context and having the interface active (interfaces have to be idle
> while no channel context is assigned). The logic here breaks this, which
> could cause issues.
>
> In fact, drivers now will have to rely on out-of-band information (e.g.
> vif->csa_active) to detect that this is not a "real" unassign, but
> rather a temporary one, and then rely on getting the new assignment
> immediately.
>
> Going back to this out-of-band information is not only ugly in the
> driver, but also makes the API less predictable IMHO. It also doesn't
> allow for drivers that have the ability to change a channel context on
> the fly - in which case none of this add/remove stuff would really be
> needed.
>
> Luca and I discussed this and came up with this suggested new API:
>
> /**
>  * enum ieee80211_chanctx_switch_mode - channel context switch mode
>  * @CHANCTX_SWMODE_REASSIGN_VIF: Both old and new contexts already exist
>  *      (and may continue to exist), but the virtual interface needs to
>  *      be switched from one to the other
>  * @CHANCTX_SWMODE_SWAP_CONTEXTS: The old context exists but will stop
> to
>  *      exist with this call, the new context doesn't exist but will be
>  *      active after this call, the virtual interface switches from the
>  *      old to the new (note that the driver may of course implement this
>  *      as an on-the-fly chandef switch of the existing hardware context,
>  *      but the mac80211 pointer for the old context will cease to exist
>  *      and only the new one will later be used for changes/removal.)
>  */
> enum ieee80211_chanctx_switch_mode {
>         CHANCTX_SWMODE_REASSIGN_VIF,
>         CHANCTX_SWMODE_SWAP_CONTEXTS,
> };
>
>         (*switch_vif_chanctx)(struct ieee80211_hw *hw,
>                             struct ieee80211_vif *vif,
>                             struct ieee80211_chanctx_conf *old_ctx,
>                             struct ieee80211_chanctx_conf *new_ctx,
>                             enum ieee80211_chanctx_switch_mode mode);

So.. is my understanding correct that my patch itself stands with the
exception of the hunk you cited that would need to be reworked to use
the new suggested API instead of the unassign/assign trickery?

If I consider non-chanctx drivers we would need to do:
  if (!local->chanctx) { del_chanctx(); add_chanctx(); } else {
switch_vif_chanctx(); }

Btw. Do you intend the new switch_vif_chanctx() to take over
unassign_vif_chanctx() too?


> Separately, I think due to the complexities involved in the driver
> implementation we'll probably need a bitmap indicating which interface
> types are supported (this is not something we do today, and this would
> be broken in iwlwifi for sure.)

Care to elaborate?


> As a result, I'm going to drop this patch, which likely also means your
> other 5-patch series won't apply?

Yeah (although it's probably possible to transplant part of the patch
so the other 5 can apply).


Michał

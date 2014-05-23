Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62289 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaEWGQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 02:16:12 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so125256wgh.7
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 23:16:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400770304.4174.34.camel@jlt4.sipsolutions.net>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	<1400767676-15994-3-git-send-email-michal.kazior@tieto.com>
	<1400770304.4174.34.camel@jlt4.sipsolutions.net>
Date: Fri, 23 May 2014 08:16:10 +0200
Message-ID: <CA+BoTQk3stQoK34q6VcXhHm8+9Rh67UF4TTfgy5P1JY1o1dTFA@mail.gmail.com> (sfid-20140523_081617_078189_A7F4F138)
Subject: Re: [PATCH v6 2/6] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2014 16:51, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-05-22 at 16:07 +0200, Michal Kazior wrote:
>
>> This introduces a special hook
>> ieee80211_vif_chanctx_reservation_complete(). This
>> is currently an empty stub and will be filled in
>> by AP/STA CSA code. This is required to implement
>> 2-step CSA finalization.
>
> I really don't see any value in this - just put it into the patch
> implementing it?

Okay, I'll move it to the AP CSA patch then.


>> + *   The callback is optional for channel context based drivers but is
>> + *   required to support channel switching. The callback and can sleep.
>
> That probably belongs to the previous patch, but isn't even true there
> or here afaict.

Ah, rebasing..


>> +static int
>> +ieee80211_vif_use_reserved_incompat(struct ieee80211_local *local,
>> +                                 struct ieee80211_chanctx *ctx,
>> +                                 const struct cfg80211_chan_def *chandef)
>> +{
>> +     struct ieee80211_sub_if_data *sdata, *tmp;
>> +     struct ieee80211_chanctx *new_ctx;
>> +     u32 changed = 0;
>> +     int err;
>> +
>> +     lockdep_assert_held(&local->mtx);
>> +     lockdep_assert_held(&local->chanctx_mtx);
>> +
>> +     if (!ieee80211_chanctx_all_reserved_vifs_ready(local, ctx))
>> +             return 0;
>> +
>> +     if (ieee80211_chanctx_num_assigned(local, ctx) !=
>> +         ieee80211_chanctx_num_reserved(local, ctx)) {
>> +             wiphy_info(local->hw.wiphy,
>> +                        "channel context reservation cannot be finalized because some interfaces aren't switching\n");
>> +             err = -EBUSY;
>> +             goto err;
>>       }
>
> I don't think I understand that condition, it's it possible to switch
> from two vifs using two channels to both using a single third one?

I assume you have a case where max number of different channels is
degraded (e.g. non-radar -> more restrictive radar combination) in
mind, right? In that case this won't work with this code. Now that I
think about it it also won't work with cross-swapping (2 chanctx are
being swapped and some vifs try to interchange between).

I'll have to re-think this a bit more.


>> +     ieee80211_recalc_chanctx_chantype(local, new_ctx);
>> +     ieee80211_recalc_smps_chanctx(local, new_ctx);
>> +     ieee80211_recalc_chanctx_min_def(local, new_ctx);
>
> vs.
>
>> -     ieee80211_recalc_chanctx_chantype(local, ctx);
>> -     ieee80211_recalc_smps_chanctx(local, ctx);
>> -     ieee80211_recalc_radar_chanctx(local, ctx);
>> -     ieee80211_recalc_chanctx_min_def(local, ctx);
>
> Did I miss something? Maybe it would be good to squeeze in that patch
> that made a recalc_all() function to call all of these.

The radar is now calculated in the _incompat manually because it
should be saying "radar" before you call into
switch_vif_chanctx/create new chanctx. I mean, you could initially
bind a chanctx with ch52 without radar flag and then update it right
away but it didn't sit right with me.


Michał

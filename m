Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33585 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaEWGJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 02:09:06 -0400
Received: by mail-wg0-f44.google.com with SMTP id a1so4270055wgh.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 23:09:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400769938.4174.29.camel@jlt4.sipsolutions.net>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	<1400767676-15994-2-git-send-email-michal.kazior@tieto.com>
	<1400769938.4174.29.camel@jlt4.sipsolutions.net>
Date: Fri, 23 May 2014 08:09:04 +0200
Message-ID: <CA+BoTQmVHFCMcx02RN2+J7zcGZbWyypDcNQgGiBSXxyuc_iDYQ@mail.gmail.com> (sfid-20140523_080920_965363_DF19779D)
Subject: Re: [PATCH v6 1/6] mac80211: introduce switch_vif_chanctx op
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2014 16:45, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-05-22 at 16:07 +0200, Michal Kazior wrote:
>> This new device driver operation will be used for
>> channel context reservation and switching.
>
> Heh. Luca just had some very similar code. But that's not necessarily a
> bad thing - we can compare :)
>
>> +     int (*switch_vif_chanctx)(struct ieee80211_hw *hw,
>> +                               struct ieee80211_vif **vifs,
>> +                               struct ieee80211_chanctx_conf **old_ctx,
>> +                               struct ieee80211_chanctx_conf **new_ctx,
>> +                               int n_vifs,
>> +                               enum ieee80211_chanctx_swmode swmode);
>
> Luca had a struct here with (vif, old, new), I think that makes sense.
>
>> +#define IEEE80211_MAX_NUM_SWITCH_VIFS 8
>
> :-)
>
> That seems artificial though - why not dynamically allocate?

I tend to avoid dynamic allocations whenever I can. I can make it
dynamic if you want.


>> +static inline int drv_switch_vif_chanctx(struct ieee80211_local *local,
>> +                                      struct ieee80211_sub_if_data **sdata,
>> +                                      struct ieee80211_chanctx **old_ctx,
>> +                                      struct ieee80211_chanctx **new_ctx,
>> +                                      int n_vifs,
>> +                                      enum ieee80211_chanctx_swmode swmode)
>> +{
>> +     struct ieee80211_vif *vifs[IEEE80211_MAX_NUM_SWITCH_VIFS] = {};
>> +     struct ieee80211_chanctx_conf *old_conf[IEEE80211_MAX_NUM_SWITCH_VIFS] = {};
>> +     struct ieee80211_chanctx_conf *new_conf[IEEE80211_MAX_NUM_SWITCH_VIFS] = {};
>> +     int i, ret = 0;
>
> That's a little big for an inline?

Maybe just a bit..


>> +     if (local->ops->switch_vif_chanctx)
>> +             return -EOPNOTSUPP;
>> +
>> +     for (i = 0; i < n_vifs; i++)
>> +             if (!check_sdata_in_driver(sdata[i]))
>> +                     return -EIO;
>> +
>> +     for (i = 0; i < n_vifs; i++) {
>> +             trace_drv_switch_vif_chanctx(local, sdata[i], old_ctx[i],
>> +                                          new_ctx[i], n_vifs, swmode, i);
>
> Hmm. This is somewhat ugly since the loop always runs. In theory it's
> possible to do this all with dynamic_array() and code in the assign path
> of the tracepoint, I think that'd be better. Or even for now just leave
> the tracing to have just a subset or something (e.g. at most 2
> interfaces)

I think I've had the same problem when I was trying to make a
single-call multi-vif csa tracing. Is using dynamic_array for this
really doable? I haven't found any code in the kernel using
__dynamic_array for anything but simple scalars and buffers.


>> +++ b/net/mac80211/main.c
>> @@ -502,6 +502,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
>>       if (WARN_ON(i != 0 && i != 5))
>>               return NULL;
>>       use_chanctx = i == 5;
>> +     if (WARN_ON(!use_chanctx && ops->switch_vif_chanctx))
>> +             return NULL;
>
> I don't think this makes sense - we perfectly handle the case right now
> by disconnecting (and not advertising switch to userspace, I guess? if
> not we should)
>
> Requiring drivers to implement this just makes things more difficult,
> and the channel switch isn't really mandatory spec-wise.

This is supposed to prevent non-chanctx drivers from accidentally
implementing switch_vif_chanctx. It doesn't require chanctx drivers to
implement switch_vif_chanctx.


>
>> +             __field(u32, old_control_freq)
>
> I believe there's a macro for a chandef?

Yes there is, but it assumes you have a `control_freq`. Since there
are old_ and new_ prefixes in my tracing I can't really use that
define, can I? I'd have to modify the define (and all callsites) to
take an argument with a prefix and concatenate symbols with ##.


Michał

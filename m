Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:49613 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932703Ab2F1JU3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 05:20:29 -0400
Message-ID: <4FEC21DA.9040901@tieto.com> (sfid-20120628_112150_968112_02D0A6DF)
Date: Thu, 28 Jun 2012 11:20:26 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3] initial channel context implementation
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>      <1340718188.14634.47.camel@jlt3.sipsolutions.net>      <4FEAB698.5070309@tieto.com>     <1340784614.8305.8.camel@jlt3.sipsolutions.net>     <4FEADCAE.5080508@tieto.com>    <1340795424.11012.11.camel@jlt3.sipsolutions.net>    <4FEAFFF1.7080706@tieto.com>   <1340805730.11012.33.camel@jlt3.sipsolutions.net>   <4FEBF3D4.3030705@tieto.com>  <1340868682.4491.1.camel@jlt3.sipsolutions.net>  <4FEC0D9F.9030000@tieto.com> <1340871180.4491.16.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340871180.4491.16.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2012-06-28 at 09:54 +0200, Michal Kazior wrote:
>
>>>> Yes, this is more or less what I also had in mind. I was just thinking
>>>> about solving the issue of channel context and hw.conf.channel
>>>> consistency. If we switch a channel we either modify channel in channel
>>>> context directly (violating the immutability of channel contexts) or we
>>>> iterate and re-set the new channel on each interface (because
>>>> single-channel drivers may still have multiple interfaces and we
>>>> probably want to use sdata->vif.chanctx_conf->channel instead of
>>>> hw.conf.channel inside mac80211).
>>>>
>>>> Now that I think about it I guess violating the immutability for the
>>>> single-channel case is okay. It would greatly simplify the code and we'd
>>>> just put a comment down in hw_config where the only violation would occur.
>>>
>>> I'm not sure why we would violate it? The way I see it, you'd never
>>> change the channel context channel since internally in mac80211 you'd
>>> never want to see a different channel, just like today we use
>>> local->oper_channel everywhere we'd then use sdata->vif.chanctx->channel
>>> throughout, right?
>>>
>>> I think the only thing we need to do is put something like this into
>>> hw_config:
>>>
>>>    if (local->tmp_channel) {
>>>       local->hw.conf.channel = local->tmp_channel;
>>>       ...
>>>    } else {
>>>       local->hw.conf.channel = chanctx->channel;
>>>    }
>>>
>>> No?
>>
>> Using sdata->vif.chanctx_conf->channel instead of local->oper_channel
>> doesn't make any sense to me.
>>
>> Take ieee80211_tx() for example. It does:
>>
>> 	tx.channel = local->hw.conf.channel;
>>
>> We don't use oper_channel here, but hw.conf.channel. TX can happen on
>> different interfaces so for multi-channel operation it should be saying:
>>
>> 	tx.channel = sdata->vif.chanctx_conf->channel;
>>
>> In this case if we want to support the swscan/tmpchan through
>> hw_config() we need update the channel context's channel somehow.
>>
>> I'm more thinking of hw.conf.channel becoming more of a backup value for
>> single-channel drivers while we internally focus on channel contexts.
>
> Yes, makes sense. I forgot all about the TX code. I'm a little wary of
> making the contexts mutable, even in this case, because a lot of code
> uses local->oper_channel as well, and that is expected to really be the
> operating channel all of the time, even if we're scanning at some point
> in time.

Yeah. The other option (maintaining the immutability) is to iterate 
through all interfaces and call ieee80211_vif_use_channel when switching 
channel for single-channel operation. Or do you have something else in 
mind maybe?


> Luckily, tx.channel isn't actually used much, only for the band. So if
> we tag the SKBs with the band earlier (info->band), maybe we don't need
> to use hw.conf.channel as much there for tx.channel?
>
> Other uses where we do need the current channel are
>   * ieee80211_build_probe_req
>   * ieee80211_add_srates_ie/ieee80211_add_ext_srates_ie
>   * __ieee80211_start_scan uses it but need not, could use oper_channel
>     instead and the code never executes for multi-channel
>   * ieee80211_set_tx_power() is interesting, may need to make it all
>     per-sdata now through nl80211 etc.

What will drivers that don't support per-sdata tx_power do? Do all 
multi-vif (not multi-channel) drivers support per-interface tx power?

I guess we'd have to manage:
  a) common tx power value in ieee80211_local
  b) provide a function that calculates the common value
     so drivers may use it (and avoid code duplication)
  c) ..or else drivers would need to implement the calculation on
     their own


>   * rate_idx_to_bitrate can use the sta's sdata's channel
>   * ieee80211_change_bss can use the sdata's channel
>   * debugfs stuff probably just moves to per-sdata files
>   * ibss code all uses sdata channel
>   * ieee80211_if_change_type ... probably just set basic_rates = 0
>   * mesh can use sdata channel
>   * mlme.c should use sdata channel, but there's the channel switch stuff
>   * rate.h should use sta->sdata channel
>
> Much of this is actually means we have bugs today! Whenever we use
> hw.conf.channel and should be using sdata channel soon, we should be
> using local->oper_channel today!

Oh! Now I understand why you wanted to use channel contexts in place of 
oper_channel. This makes sense.


> Maybe it's worth fixing that first, and getting rid of *most* instances
> of hw.conf.channel, so we have a clearer idea of which changes in what
> ways?

Sounds like a good idea.


-- 
Pozdrawiam / Best regards, Michal Kazior.


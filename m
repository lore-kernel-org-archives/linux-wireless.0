Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:62407 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab2F1HyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 03:54:10 -0400
Message-ID: <4FEC0D9F.9030000@tieto.com> (sfid-20120628_095414_452539_6829CBD7)
Date: Thu, 28 Jun 2012 09:54:07 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3] initial channel context implementation
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>     <1340718188.14634.47.camel@jlt3.sipsolutions.net>     <4FEAB698.5070309@tieto.com>    <1340784614.8305.8.camel@jlt3.sipsolutions.net>    <4FEADCAE.5080508@tieto.com>   <1340795424.11012.11.camel@jlt3.sipsolutions.net>   <4FEAFFF1.7080706@tieto.com>  <1340805730.11012.33.camel@jlt3.sipsolutions.net>  <4FEBF3D4.3030705@tieto.com> <1340868682.4491.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340868682.4491.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2012-06-28 at 08:04 +0200, Michal Kazior wrote:
>
>>> In any case, I think you're turning it upside down. I think we should
>>> get rid of local->oper_channel(_type) completely, and instead use the
>>> channel contexts in mac80211 everywhere. If the driver doesn't implement
>>> channel contexts it can only support a single channel. Thus, we can have
>>> at most one channel context, so whenever a new context is added (there
>>> could be zero) or any context is modified (the only one) we can set
>>> hw.conf.channel and call hw_config() with the CHANNEL_CHANGE flag.
>>>
>>> IOW, nothing in mac80211 would ever call hw_config() for the channel or
>>> channel type change, it would all do channel contexts, but the channel
>>> context code would see that if the driver doesn't support channel
>>> contexts
>>>    1) there will be at most one context in mac80211
>>>    2) this context is programmed into the device by using hw_config()
>>>       instead of the context callbacks
>>
>> Yes, this is more or less what I also had in mind. I was just thinking
>> about solving the issue of channel context and hw.conf.channel
>> consistency. If we switch a channel we either modify channel in channel
>> context directly (violating the immutability of channel contexts) or we
>> iterate and re-set the new channel on each interface (because
>> single-channel drivers may still have multiple interfaces and we
>> probably want to use sdata->vif.chanctx_conf->channel instead of
>> hw.conf.channel inside mac80211).
>>
>> Now that I think about it I guess violating the immutability for the
>> single-channel case is okay. It would greatly simplify the code and we'd
>> just put a comment down in hw_config where the only violation would occur.
>
> I'm not sure why we would violate it? The way I see it, you'd never
> change the channel context channel since internally in mac80211 you'd
> never want to see a different channel, just like today we use
> local->oper_channel everywhere we'd then use sdata->vif.chanctx->channel
> throughout, right?
>
> I think the only thing we need to do is put something like this into
> hw_config:
>
>   if (local->tmp_channel) {
>      local->hw.conf.channel = local->tmp_channel;
>      ...
>   } else {
>      local->hw.conf.channel = chanctx->channel;
>   }
>
> No?

Using sdata->vif.chanctx_conf->channel instead of local->oper_channel 
doesn't make any sense to me.

Take ieee80211_tx() for example. It does:

	tx.channel = local->hw.conf.channel;

We don't use oper_channel here, but hw.conf.channel. TX can happen on 
different interfaces so for multi-channel operation it should be saying:

	tx.channel = sdata->vif.chanctx_conf->channel;

In this case if we want to support the swscan/tmpchan through 
hw_config() we need update the channel context's channel somehow.

I'm more thinking of hw.conf.channel becoming more of a backup value for 
single-channel drivers while we internally focus on channel contexts.


-- 
Pozdrawiam / Best regards, Michal Kazior.


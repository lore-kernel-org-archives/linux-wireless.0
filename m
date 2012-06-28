Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42860 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab2F1GEH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 02:04:07 -0400
Message-ID: <4FEBF3D4.3030705@tieto.com> (sfid-20120628_080412_686110_172DBD84)
Date: Thu, 28 Jun 2012 08:04:04 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3] initial channel context implementation
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>    <1340718188.14634.47.camel@jlt3.sipsolutions.net>    <4FEAB698.5070309@tieto.com>   <1340784614.8305.8.camel@jlt3.sipsolutions.net>   <4FEADCAE.5080508@tieto.com>  <1340795424.11012.11.camel@jlt3.sipsolutions.net>  <4FEAFFF1.7080706@tieto.com> <1340805730.11012.33.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340805730.11012.33.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2012-06-27 at 14:43 +0200, Michal Kazior wrote:
> I think we should do
>    c) if the driver advertises support for multiple channels in its
>       interface combinations or implements the channel context callbacks,
>       it must have hw_scan/roc, otherwise we fail hw registration; if it
>       advertises support for multiple channels obviously it must have all
>       the channel context callbacks
>
> This would leave all existing drivers operating as-is, the next step
> would be adding channel context support to a driver (must have hw
> scan/roc in that case), and the next step after that would be actually
> advertising support for multiple channels -- in practice it's probably
> just a single patch doing both but that's the logical order then.

Right.


>> For legacy operation we'd need to iterate through active interface in
>> hw_config() and call ieee80211_vif_use_channel() for each. This would
>> allow us to have the same channel context across all interfaces (so we
>> can virtually use channel context everywhere instead of
>> hw.conf.channel). This means the .assign_vif_chanctx cannot sleep if my
>> understanding is correct (we'd need to use RCU locking for iteration
>> since devlist lock may be held while hw_config() is caled).
>>
>> What do you think?
>
> What 'legacy operation' are you referring to?

The case when we support swscan and tmpchan.


> In any case, I think you're turning it upside down. I think we should
> get rid of local->oper_channel(_type) completely, and instead use the
> channel contexts in mac80211 everywhere. If the driver doesn't implement
> channel contexts it can only support a single channel. Thus, we can have
> at most one channel context, so whenever a new context is added (there
> could be zero) or any context is modified (the only one) we can set
> hw.conf.channel and call hw_config() with the CHANNEL_CHANGE flag.
>
> IOW, nothing in mac80211 would ever call hw_config() for the channel or
> channel type change, it would all do channel contexts, but the channel
> context code would see that if the driver doesn't support channel
> contexts
>   1) there will be at most one context in mac80211
>   2) this context is programmed into the device by using hw_config()
>      instead of the context callbacks

Yes, this is more or less what I also had in mind. I was just thinking 
about solving the issue of channel context and hw.conf.channel 
consistency. If we switch a channel we either modify channel in channel 
context directly (violating the immutability of channel contexts) or we 
iterate and re-set the new channel on each interface (because 
single-channel drivers may still have multiple interfaces and we 
probably want to use sdata->vif.chanctx_conf->channel instead of 
hw.conf.channel inside mac80211).

Now that I think about it I guess violating the immutability for the 
single-channel case is okay. It would greatly simplify the code and we'd 
just put a comment down in hw_config where the only violation would occur.


-- 
Pozdrawiam / Best regards, Michal Kazior.


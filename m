Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:60805 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab2F0Mnb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 08:43:31 -0400
Message-ID: <4FEAFFF1.7080706@tieto.com> (sfid-20120627_144335_546676_D072A85F)
Date: Wed, 27 Jun 2012 14:43:29 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3] initial channel context implementation
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>   <1340718188.14634.47.camel@jlt3.sipsolutions.net>   <4FEAB698.5070309@tieto.com>  <1340784614.8305.8.camel@jlt3.sipsolutions.net>  <4FEADCAE.5080508@tieto.com> <1340795424.11012.11.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340795424.11012.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2012-06-27 at 12:13 +0200, Michal Kazior wrote:
>
>>> Ok. Thinking about this a bit I get a feeling that we should internally
>>> fully convert mac80211 over to channel contexts and not make things
>>> conditional. Then, whenever a new channel context is allocated it will
>>> be the only one and we can set hw.conf.channel/type to its channel(type)
>>> and call hw_config() instead of ... add/change chanctx?
>>>
>>> That way, we really only need to make a distinction in the low-level
>>> code that actually calls into the driver, and on a higher level we can
>>> just use the channel contexts everywhere.
>>
>> But wouldn't that make hw.conf.channel have a different value then the
>> channel context after running hw_config() (in case of sw scan for
>> example)? You want to copy the value back from hw.conf.channel back to
>> (an immutable) context channel in such a case? Could you elaborate more
>> on this, please?
>
> Good questions :-)
>
> I was thinking that today we have tmp_channel & oper_channel (in local),
> and oper_channel would follow the (single) channel context (if there
> even is one, otherwise any random channel is fine), and hw.conf.channel
> would still be tmp_channel when that is in used for scanning/roc?

I'm still confused.

Okay here's what I think:

Our main concern right now is swscan and tmpchan for legacy operation. 
We need to know whether a driver requires us to support swscan/tmpchan 
or not. We could possibly:

  a) if .hw_scan and .remain_on_channel are implemented use we
     channel contexts only.
     We then automatically require driver to handle all chanctx related
     ieee80211_ops'. If it's missing we fail with -EINVAL in the
     ieee80211_hw_register.

  b) we could add a new flag a driver may report, e.g.
     IEEE80211_HW_SUPPORTS_CHANCTX
     (along with appropriate checks mentioned above)


For legacy operation we'd need to iterate through active interface in 
hw_config() and call ieee80211_vif_use_channel() for each. This would 
allow us to have the same channel context across all interfaces (so we 
can virtually use channel context everywhere instead of 
hw.conf.channel). This means the .assign_vif_chanctx cannot sleep if my 
understanding is correct (we'd need to use RCU locking for iteration 
since devlist lock may be held while hw_config() is caled).

What do you think?


>>> The biggest issue here will be CSA handling. I have no idea yet how this
>>> will work in multi-channel, maybe we need to disconnect all other
>>> interfaces on the same channel, or so?
>>
>> We don't care about CSA in cfg80211 right now, do we? We probably should
>> as it can break interface combinations right now too.
>
> Good point.
>
>> We could maybe use the cfg80211_ch_switch_notify.
>
> That was intended for AP mode, I'm not sure it's good for station mode,
> in station mode we need to have current_bss->channel updated as well in
> that case.
>
>> This would probably require some more
>> additional changes too (maybe with regard to channel tracking too).
>>
>> Worst-case we disconnect other interfaces. We might be able to create a
>> new channel context (provided num_different_channels hasn't been reached
>> yet) or reuse an existing channel context (provided CSA happens to
>> target a channel we have a channel context for already).
>
> Yeah ... we need to think about it more. I thought we could put it off a
> bit longer, but I guess with the channel tracking we already need it?

Hmm.. Yeah we need to now, sort of. FullMAC drivers could suffer, but we 
could drop connections upon CSA in mac80211 for the time being.

cfg80211 could provide:
  * cfg80211_sta_can_switch_chan
  * cfg80211_sta_ch_switch_notify

mac80211 could then be able to know whether num_different_channels has 
been reached (cfg80211_sta_can_switch_chan) and eventually notify upon 
channel switch (cfg80211_sta_ch_switch_notify).

Channel switch would happen if either:
  * cfg80211_sta_can_switch_chan is true
  * channel context for target CSA channel already exists

I'm just unsure about the current_bss thing - whether we should e.g. 
initiate a scan to update it, or can we shamelessly update the channel 
in the structure directly?


-- 
Pozdrawiam / Best regards, Michal Kazior.


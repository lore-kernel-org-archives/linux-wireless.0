Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:64140 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601Ab2F0KNG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 06:13:06 -0400
Message-ID: <4FEADCAE.5080508@tieto.com> (sfid-20120627_121310_359326_B5DAE1BD)
Date: Wed, 27 Jun 2012 12:13:02 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3] initial channel context implementation
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>  <1340718188.14634.47.camel@jlt3.sipsolutions.net>  <4FEAB698.5070309@tieto.com> <1340784614.8305.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340784614.8305.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2012-06-27 at 09:30 +0200, Michal Kazior wrote:
>
>>> How are you planning to proceed from here? I'm happy to pick these up
>>> even if you're not going to work on using it right away since I think in
>>> that case I would probably be working on using it pretty soon, but if
>>> you are planning to work on it that's even better :-)
>>
>> The next step is to start using channel contexts in mac80211. I was
>> thinking of using chanctx->channel instead of hw.conf.channel if
>> .assign_vif_chanctx is defined. I expect some issues like using channel
>> before it is set.
>
> Ok. Thinking about this a bit I get a feeling that we should internally
> fully convert mac80211 over to channel contexts and not make things
> conditional. Then, whenever a new channel context is allocated it will
> be the only one and we can set hw.conf.channel/type to its channel(type)
> and call hw_config() instead of ... add/change chanctx?
>
> That way, we really only need to make a distinction in the low-level
> code that actually calls into the driver, and on a higher level we can
> just use the channel contexts everywhere.

But wouldn't that make hw.conf.channel have a different value then the 
channel context after running hw_config() (in case of sw scan for 
example)? You want to copy the value back from hw.conf.channel back to 
(an immutable) context channel in such a case? Could you elaborate more 
on this, please?


> The biggest issue here will be CSA handling. I have no idea yet how this
> will work in multi-channel, maybe we need to disconnect all other
> interfaces on the same channel, or so?

We don't care about CSA in cfg80211 right now, do we? We probably should 
as it can break interface combinations right now too. We could maybe use 
the cfg80211_ch_switch_notify. This would probably require some more 
additional changes too (maybe with regard to channel tracking too).

Worst-case we disconnect other interfaces. We might be able to create a 
new channel context (provided num_different_channels hasn't been reached 
yet) or reuse an existing channel context (provided CSA happens to 
target a channel we have a channel context for already).


-- 
Pozdrawiam / Best regards, Michal Kazior.


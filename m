Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2F0OCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 10:02:14 -0400
Message-ID: <1340805730.11012.33.camel@jlt3.sipsolutions.net> (sfid-20120627_160219_592302_360D0886)
Subject: Re: [RFC v3] initial channel context implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 27 Jun 2012 16:02:10 +0200
In-Reply-To: <4FEAFFF1.7080706@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
	   <1340718188.14634.47.camel@jlt3.sipsolutions.net>
	   <4FEAB698.5070309@tieto.com>
	  <1340784614.8305.8.camel@jlt3.sipsolutions.net>
	  <4FEADCAE.5080508@tieto.com>
	 <1340795424.11012.11.camel@jlt3.sipsolutions.net>
	 <4FEAFFF1.7080706@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-27 at 14:43 +0200, Michal Kazior wrote:

> > Good questions :-)
> >
> > I was thinking that today we have tmp_channel & oper_channel (in local),
> > and oper_channel would follow the (single) channel context (if there
> > even is one, otherwise any random channel is fine), and hw.conf.channel
> > would still be tmp_channel when that is in used for scanning/roc?
> 
> I'm still confused.
> 
> Okay here's what I think:
> 
> Our main concern right now is swscan and tmpchan for legacy operation. 
> We need to know whether a driver requires us to support swscan/tmpchan 
> or not. We could possibly:
> 
>   a) if .hw_scan and .remain_on_channel are implemented use we
>      channel contexts only.
>      We then automatically require driver to handle all chanctx related
>      ieee80211_ops'. If it's missing we fail with -EINVAL in the
>      ieee80211_hw_register.

No, I don't think we can do that, since some drivers today have
hw_scan/roc but don't want multi-channel.

>   b) we could add a new flag a driver may report, e.g.
>      IEEE80211_HW_SUPPORTS_CHANCTX
>      (along with appropriate checks mentioned above)

I don't think that's needed?

I think we should do
  c) if the driver advertises support for multiple channels in its
     interface combinations or implements the channel context callbacks,
     it must have hw_scan/roc, otherwise we fail hw registration; if it
     advertises support for multiple channels obviously it must have all
     the channel context callbacks

This would leave all existing drivers operating as-is, the next step
would be adding channel context support to a driver (must have hw
scan/roc in that case), and the next step after that would be actually
advertising support for multiple channels -- in practice it's probably
just a single patch doing both but that's the logical order then.


> For legacy operation we'd need to iterate through active interface in 
> hw_config() and call ieee80211_vif_use_channel() for each. This would 
> allow us to have the same channel context across all interfaces (so we 
> can virtually use channel context everywhere instead of 
> hw.conf.channel). This means the .assign_vif_chanctx cannot sleep if my 
> understanding is correct (we'd need to use RCU locking for iteration 
> since devlist lock may be held while hw_config() is caled).
> 
> What do you think?

What 'legacy operation' are you referring to?

In any case, I think you're turning it upside down. I think we should
get rid of local->oper_channel(_type) completely, and instead use the
channel contexts in mac80211 everywhere. If the driver doesn't implement
channel contexts it can only support a single channel. Thus, we can have
at most one channel context, so whenever a new context is added (there
could be zero) or any context is modified (the only one) we can set
hw.conf.channel and call hw_config() with the CHANNEL_CHANGE flag.

IOW, nothing in mac80211 would ever call hw_config() for the channel or
channel type change, it would all do channel contexts, but the channel
context code would see that if the driver doesn't support channel
contexts
 1) there will be at most one context in mac80211
 2) this context is programmed into the device by using hw_config()
    instead of the context callbacks


> > That was intended for AP mode, I'm not sure it's good for station mode,
> > in station mode we need to have current_bss->channel updated as well in
> > that case.
> >
> >> This would probably require some more
> >> additional changes too (maybe with regard to channel tracking too).
> >>
> >> Worst-case we disconnect other interfaces. We might be able to create a
> >> new channel context (provided num_different_channels hasn't been reached
> >> yet) or reuse an existing channel context (provided CSA happens to
> >> target a channel we have a channel context for already).
> >
> > Yeah ... we need to think about it more. I thought we could put it off a
> > bit longer, but I guess with the channel tracking we already need it?
> 
> Hmm.. Yeah we need to now, sort of. FullMAC drivers could suffer, but we 
> could drop connections upon CSA in mac80211 for the time being.
> 
> cfg80211 could provide:
>   * cfg80211_sta_can_switch_chan
>   * cfg80211_sta_ch_switch_notify
> 
> mac80211 could then be able to know whether num_different_channels has 
> been reached (cfg80211_sta_can_switch_chan) and eventually notify upon 
> channel switch (cfg80211_sta_ch_switch_notify).
> 
> Channel switch would happen if either:
>   * cfg80211_sta_can_switch_chan is true
>   * channel context for target CSA channel already exists
> 
> I'm just unsure about the current_bss thing - whether we should e.g. 
> initiate a scan to update it, or can we shamelessly update the channel 
> in the structure directly?

Today mac80211 just updates it, yeah.

johannes


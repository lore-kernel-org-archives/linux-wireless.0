Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab2F0LK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 07:10:28 -0400
Message-ID: <1340795424.11012.11.camel@jlt3.sipsolutions.net> (sfid-20120627_131041_907305_617C8E05)
Subject: Re: [RFC v3] initial channel context implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 27 Jun 2012 13:10:24 +0200
In-Reply-To: <4FEADCAE.5080508@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
	  <1340718188.14634.47.camel@jlt3.sipsolutions.net>
	  <4FEAB698.5070309@tieto.com>
	 <1340784614.8305.8.camel@jlt3.sipsolutions.net>
	 <4FEADCAE.5080508@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-27 at 12:13 +0200, Michal Kazior wrote:

> > Ok. Thinking about this a bit I get a feeling that we should internally
> > fully convert mac80211 over to channel contexts and not make things
> > conditional. Then, whenever a new channel context is allocated it will
> > be the only one and we can set hw.conf.channel/type to its channel(type)
> > and call hw_config() instead of ... add/change chanctx?
> >
> > That way, we really only need to make a distinction in the low-level
> > code that actually calls into the driver, and on a higher level we can
> > just use the channel contexts everywhere.
> 
> But wouldn't that make hw.conf.channel have a different value then the 
> channel context after running hw_config() (in case of sw scan for 
> example)? You want to copy the value back from hw.conf.channel back to 
> (an immutable) context channel in such a case? Could you elaborate more 
> on this, please?

Good questions :-)

I was thinking that today we have tmp_channel & oper_channel (in local),
and oper_channel would follow the (single) channel context (if there
even is one, otherwise any random channel is fine), and hw.conf.channel
would still be tmp_channel when that is in used for scanning/roc?


> > The biggest issue here will be CSA handling. I have no idea yet how this
> > will work in multi-channel, maybe we need to disconnect all other
> > interfaces on the same channel, or so?
> 
> We don't care about CSA in cfg80211 right now, do we? We probably should 
> as it can break interface combinations right now too. 

Good point.

> We could maybe use the cfg80211_ch_switch_notify. 

That was intended for AP mode, I'm not sure it's good for station mode,
in station mode we need to have current_bss->channel updated as well in
that case.

> This would probably require some more 
> additional changes too (maybe with regard to channel tracking too).
> 
> Worst-case we disconnect other interfaces. We might be able to create a 
> new channel context (provided num_different_channels hasn't been reached 
> yet) or reuse an existing channel context (provided CSA happens to 
> target a channel we have a channel context for already).

Yeah ... we need to think about it more. I thought we could put it off a
bit longer, but I guess with the channel tracking we already need it?

johannes


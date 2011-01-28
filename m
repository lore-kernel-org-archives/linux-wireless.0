Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58454 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab1A1NY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 08:24:29 -0500
Subject: Re: [RFC v3] mac80211:  Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D41A895.4060304@candelatech.com>
References: <1296074238-4012-1-git-send-email-greearb@candelatech.com>
	 <1296136347.3622.55.camel@jlt3.sipsolutions.net>
	 <4D41A895.4060304@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 14:24:27 +0100
Message-ID: <1296221067.5118.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-27 at 09:17 -0800, Ben Greear wrote:

> >> +	if (local->scan_channel) {
> >> +		chan = local->scan_channel;
> >> +		channel_type = NL80211_CHAN_NO_HT;
> >> +	} else if (local->tmp_channel) {
> >> +		chan = scan_chan = local->tmp_channel;
> >> +		channel_type = local->tmp_channel_type;
> >> +	} else {
> >> +		chan = local->oper_channel;
> >> +		channel_type = local->_oper_channel_type;
> >> +	}
> >
> > Don't understand -- why not return true in the else branch?
> 
> Because the hardware might not actually be set to the oper_channel.
> The idea is that you configure the mac80211 state as you want it, and then
> use this method to figure out if you really need to make hardware
> changes.

Oh. Wouldn't it make more sense to stick that into the _config()
function then and return something there? Hmm. I kinda start to
understand I guess.

> >> +	if (chan != local->oper_channel ||
> >> +	    channel_type != local->_oper_channel_type)
> >> +		return false;
> >> +
> >> +	/* Check current hardware-config against oper_channel. */
> >> +	if ((local->oper_channel != local->hw.conf.channel) ||
> >> +	    (local->_oper_channel_type != local->hw.conf.channel_type))
> >> +		return false;
> >
> > That's confusing, and kinda racy IIRC?
> 
> This method should be locked such that the hardware conf
> cannot be changed while it is being called.  I can double
> check that this is true.

Not all of this is always properly locked unfortunately. Not sure about
this case though.

> >> -	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
> >> -		skip = 1;
> >> +
> >> +	if (chan != local->hw.conf.channel)
> >> +		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
> >> +			skip = 1;
> >
> > Why doesn't that test the bit? Or does this only cause setting it?
> 
> Which bit?

Err. Not sure, maybe I got confused.

> > Also, won't this do some weird things like not stop, but try to start
> > stations again?
> 
> I was thinking that should be harmless.  As far as I can tell, current
> code would never actually stop beaconing in this method but might try
> to start it later, so it must not cause too much trouble.

Yeah, maybe you're right and it doesn't matter, but I think it'd be
nicer to always nest the calls. I see you've done that already.

> Thanks for the review...I'll go over everything and try to repost
> something that incorporates your ideas.

Thanks for your patience with this! It's quite tricky I guess...

johannes


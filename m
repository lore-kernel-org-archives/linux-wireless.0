Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45861 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab1KHSiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 13:38:55 -0500
Subject: Re: [RFT/FYI] mac80211: revert on-channel work optimisations
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4EB9703B.6030006@candelatech.com>
References: <1320772222.24797.22.camel@jlt3.sipsolutions.net>
	 <4EB96416.5040700@candelatech.com>
	 <1320772727.24797.23.camel@jlt3.sipsolutions.net>
	 <4EB9661F.9040901@candelatech.com>
	 <1320775001.24797.26.camel@jlt3.sipsolutions.net>
	 <4EB9703B.6030006@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 19:38:51 +0100
Message-ID: <1320777531.24797.35.camel@jlt3.sipsolutions.net> (sfid-20111108_193858_560370_CE2BD170)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 10:08 -0800, Ben Greear wrote:

> >> But if
> >> you want multiple vifs to work well, then you really need to be able
> >> to continue to function on-channel when some other vif is scanning
> >> on that channel.  My use of the wifi stack requires this to work,
> >> so if it takes any significant time to get the new code in I'm going
> >> to have to stick with my complex crap.
> >
> > And I'm not saying you shouldn't, but I think for upstream right now
> > it's not really a good thing. I wish I could say otherwise but given the
> > bugs we have here etc. I don't really feel very confident.
> 
> Are there any open bugs right now that seem to be because of the
> scanning and work optimizations, or are you just paranoid that
> there are more that are not found or well understood yet?
> 
> If there is something reported, I'll make a try at fixing it.

I was looking at RH bug 731365 but I think Eliad's patches should have
fixed that. But generally, that code just makes me nervous, in
particular ieee80211_cfg_on_oper_channel(). I think all of this should
be a lot simpler, and if it isn't that's probably due to *other* bugs
this is working around.

> > Now with multi-channel stuff it's all going to change anyway, each vif
> > will have its own channel and the device will have to mostly sort out
> > the scheduling by itself, ath9k will have to do some tricks in the
> > driver, maybe with some help in mac80211, and off-channel stuff will be
> > interesting too ...
> 
> Is someone already working on this, or planning to do so soon?  

I am planning to.

> At least
> to me, the multi-channel stuff appears fundamentally broken since I'm
> not aware of any NIC that can listen in two channels at once.  Flipping
> from channel to channel seems like at best it is going to give bad latency,
> and probably lots of packet loss as well.  What is the use-case for this
> feature, anyway?

Oh, well, for example P2P printing to a printer that's already on
channel 5 while connected to an AP that's already on channel 11. That'd
be temporary, but any quality of service degradation is still better
than not being able to print.

johannes


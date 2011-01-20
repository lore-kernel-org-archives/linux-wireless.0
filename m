Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab1ATSZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 13:25:50 -0500
Subject: Re: [RFC 2/3] mac80211: Support scanning only current active
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D387D25.7080902@candelatech.com>
References: <1295544750-6704-1-git-send-email-greearb@candelatech.com>
	 <1295544750-6704-2-git-send-email-greearb@candelatech.com>
	 <1295545143.3693.44.camel@jlt3.sipsolutions.net>
	 <4D3879A6.2060909@candelatech.com>
	 <1295547439.3693.46.camel@jlt3.sipsolutions.net>
	 <4D387D25.7080902@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 19:25:49 +0100
Message-ID: <1295547949.3693.49.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-20 at 10:21 -0800, Ben Greear wrote:

> > No, it can't actually determine the order -- we sort them in cfg80211
> > anyway to de-duplicate them.
> 
> Ok, so assuming we re-work scanning across the board, maybe the first
> thing is to sort them such that the current channel is always first
> (if it's in the list at all)?

Yeah I guess mac80211 could do that -- I wouldn't necessarily do it in
cfg80211. However, I'm not convinced it's necessary.

> >> It seems to me that it would take quite a bit of re-work of the
> >> mac80211 scanning logic to deal with scanning on the current
> >> channel w/out affecting other tx/rx packets (as my patch attempts
> >> to do), without setting some explicit flag before you enter
> >> the scan state machine.
> >
> > Yeah, so maybe it needs some re-work, but I think what you're doing is a
> > pretty strange hack.
> 
> If you have time to write some patches, I'll be happy to test them on
> our ath9k and ath5k systems.

I don't, unfortunately, at least not now.

> If you don't, then I can make an attempt.  Suggestions for an acceptable
> way to go about doing this would be welcome.

Well I'd start by looking at the offchannel code and seeing if it has
the flushing in all the right places. I don't think it does, so drivers
attempt to work around it by flushing on channel changes. That could be
improved first.

Then I'd again look at the offchannel code and see how it can behave
better when it's not actually going offchannel -- not stop beaconing
etc., just reprogram the filters or so. That way, I'm not even sure if
modifying much of the scan code will even be necessary, and I think you
wouldn't even have to sort the channel list differently.

johannes


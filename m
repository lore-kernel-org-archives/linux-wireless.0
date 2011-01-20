Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39892 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab1ATJtM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 04:49:12 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Pfr8f-0008DO-MC
	for linux-wireless@vger.kernel.org; Thu, 20 Jan 2011 10:49:09 +0100
Received: from dslb-084-059-120-020.pools.arcor-ip.net ([84.59.120.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 10:49:09 +0100
Received: from alexander.simon by dslb-084-059-120-020.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 10:49:09 +0100
To: linux-wireless@vger.kernel.org
From: Alexander Simon <alexander.simon@saxnet.de>
Subject: Re: [RFC 1/4] mac80211: support for IEEE80211N in IBSS
Date: Thu, 20 Jan 2011 09:48:56 +0000 (UTC)
Message-ID: <loom.20110120T103741-140@post.gmane.org>
References: <201101191438.01161.alexander.simon@saxnet.de>  <1295447708.4685.5.camel@jlt3.sipsolutions.net>  <loom.20110120T093834-982@post.gmane.org> <1295515469.3693.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@...> writes:

> 
> On Thu, 2011-01-20 at 09:10 +0000, Alexander Simon wrote:
> 
> > What do you mean with a "not so refactoring version"? I am adding a new IE.
> > These are only insertions, no other changes. Or do you mean that
dev_alloc_skb?
> > However, i took the last "try" from Benoit.
> 
> Well, then maybe I just discussed this with him -- there's similar code
> building the HT IEs for stations, that code should be shared.
So you mean my patch 2/4? It could work but you would have to change util.c of
course. I was pretty sure you wouldn't have accepted that.

> Yes all of that might be necessary, but can you post patches that do one
> thing at a time? Like at least one cfg80211/nl80211 patch that adds the
> configurability, and then a mac80211 patch that will use it.
> 
> Also, I think cfg80211 should support advertising to userspace that it's
> supported.
> 
> Yes, I sometimes accept combined cfg80211/mac80211 patches, but I think
> this feature is bigger than that.

Ok, separating cfg from mac. No big deal. I'll have to look how to advertise
something...

But i would appreciate if you could comment on the design of the patch itself.
Basically i just took Benoits approach and made it running. A separate option
for setting channel_type isn't necessary. You could also tell by iw whether to
use HT or not. Or no option at all, a module option ibss_ht etc. Or even setting
full options as hostapd does via iw.

Thanks, Alex


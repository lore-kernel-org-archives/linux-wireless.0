Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57884 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933450AbXLQU7i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 15:59:38 -0500
Subject: Re: [patch 0/9] Rate control rework
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197900351.4885.41.camel@johannes.berg>
References: <20071217001956.640555983@gmx.de>
	 (sfid-20071217_003027_842318_90F1A18D)  <1197900351.4885.41.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 21:59:34 +0100
Message-Id: <1197925174.7505.3.camel@localhost> (sfid-20071217_205949_212548_BC499352)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-17 at 15:05 +0100, Johannes Berg wrote:
> > * It seems mac80211 fails to clean up the rate control algorithm. This
> >   results in the debugfs entries created by patch 9 not being removed.
> 
> Probably a bug then, though I can't find it right now, the references
> all look balanced and if they weren't then we'd not have been able to
> rmmod rc80211_simple when it was still around. Not sure, can you try to
> see what the problem is and maybe even fix it?

Will do, after I've addressed the other issues.

> 
> It does, however, look like the whole rate control code needs a revamp.
> Looks like Jiri got busy there with krefs too without giving it too much
> thought... It looks like all that can be converted to RCU just as well
> as all the other stuff I already converted, I don't see a reason to keep
> a reference count of the rate control algorithm for each sta.

What bothers me most is the fact that we have several ways to refer to a
rate: Either we use struct ieee80211_rate pointers or indices into
local->oper_hw_mode->rates[]. This is not very consistent. Furthermore,
there is oper_hw_mode vs scan_hw_mode. So potentially even to rates[].
That sucks.

> 
> If you fix the free problem I'll take a look at fixing the locking/refs
> stuff there later.

I'll happily leave that to you, I don't have much spare time.

Mattias


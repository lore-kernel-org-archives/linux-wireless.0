Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:49364 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbYFJMsG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 08:48:06 -0400
Date: Tue, 10 Jun 2008 15:47:24 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211_hwsim - simulator of 802.11 radios for mac80211
Message-ID: <20080610124724.GB6961@jm.kir.nu> (sfid-20080610_144812_728947_6C02C437)
References: <20080610105058.GA6961@jm.kir.nu> <1213096575.3668.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213096575.3668.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2008 at 01:16:15PM +0200, Johannes Berg wrote:
> On Tue, 2008-06-10 at 13:50 +0300, Jouni Malinen wrote:
> > If there is interest in moving mac80211_hwsim module into the Linux
> > kernel tree, I'm open to doing that, too.
> 
> I think that would make sense, yes, especially since one look at the
> code already tells me that it needs to follow large API changes to work
> with the current mac80211.

I'm currently running Linux 2.6.25 on my laptop and as such, this is
indeed not based on the latest changes. I'll fix couple of issues in the
current code with 2.6.25-based version and then look into making a
submission against wireless-testing (or if there are large, pending
patches that are not yet there, against something including those
changes).

> One thing caught my eye: you use GFP_KERNEL in the tx routine, that's
> not good, it is running under a spinlock.

Thanks, I'll fix that. I was trying to follow the documentation in
net/mac80211.h to verify that it is correct, but clearly I missed the
comment on tx() about the handler having to be atomic.

> One thing that I'd like to add is a having a "global" monitor interface
> that is registered by the hwsim module and not mac80211 and shows all
> frames, regardless of channel etc.

Yes, I've been thinking of something similar, too. I'll add a netdev
that gets all frames with radiotap header.

-- 
Jouni Malinen                                            PGP id EFC895FA 

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45819 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444AbYAYUbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 15:31:05 -0500
Date: Fri, 25 Jan 2008 12:28:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
cc: Michael Buesch <mb@bu3sch.de>, Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <20080125194807.GD14687@tuxdriver.com>
Message-ID: <alpine.LFD.1.00.0801251223590.2979@hp.linux-foundation.org> (sfid-20080125_203114_555056_21F4B9D6)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org> <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org> <200801251930.27022.mb@bu3sch.de>
 <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org> <20080125194807.GD14687@tuxdriver.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 25 Jan 2008, John W. Linville wrote:
> 
> Quoth Herbert Xu:
> 
> "OK.  Let me clarify this a bit more.  We require at least one
> of the following rules to be met:
> 
> * the IPv4/IPv6 header is aligned by 8 bytes on reception;
> * or the platform provides unaligned exception handlers.

Ok, so the wireless stack currently does neither. It warns about 
lack of 4-byte alignment (not 8), and it does so for everything.

> That puts mac80211 in an awkward position.  It is not architecture
> code, so it can't make any assumptions about what is or isn't OK.
> So, we need to present aligned data to the network stack.

We can *easily* just have a "CONFIG_EXPENSIVE_UNALIGNED" thing, and force 
architectures to set that, and then just have the mac80211 code re-align 
the packet as required if it is set.

Or you guys could ask the network people to do that at an even higher 
level.

> We could put the alignment onus on mac80211, but this has proven to be
> very solvable at (near?) zero cost by all the other drivers.

>From personal experience, I would not be in the least surprised if there 
are DMA engines that simply cannot even do non-aligned DMA's.

And from a performance standpoint, it's also very possible that unaligned 
DMA accesses (if they end up being done as such by a stupid DMA engine) 
are more expensive than unaligned CPU data.

			Linus

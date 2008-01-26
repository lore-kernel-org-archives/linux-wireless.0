Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42236
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbYAZNhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 08:37:23 -0500
Date: Sat, 26 Jan 2008 05:37:36 -0800 (PST)
Message-Id: <20080126.053736.130683952.davem@davemloft.net> (sfid-20080126_133727_034414_9323EC6B)
To: torvalds@linux-foundation.org
Cc: linville@tuxdriver.com, mb@bu3sch.de, dcbw@redhat.com,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0801251223590.2979@hp.linux-foundation.org>
References: <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org>
	<20080125194807.GD14687@tuxdriver.com>
	<alpine.LFD.1.00.0801251223590.2979@hp.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Jan 2008 12:28:22 -0800 (PST)

[ Why do you guys have to have a thread like this when
  I'm on a plane for 18 hours :-) ]

> > That puts mac80211 in an awkward position.  It is not architecture
> > code, so it can't make any assumptions about what is or isn't OK.
> > So, we need to present aligned data to the network stack.
> 
> We can *easily* just have a "CONFIG_EXPENSIVE_UNALIGNED" thing, and force 
> architectures to set that, and then just have the mac80211 code re-align 
> the packet as required if it is set.
> 
> Or you guys could ask the network people to do that at an even higher 
> level.

This is pseudo-encoded into many drivers which have trouble
receiving into "aligned for IP stack" RX buffers.  They
copy in such cases, but the existing test is a pile or
arch ifdefs.

Those should definitely be transformed into something centralized
like the EXPENSIVE_UNAIGNED setting you suggest.

> And from a performance standpoint, it's also very possible that unaligned 
> DMA accesses (if they end up being done as such by a stupid DMA engine) 
> are more expensive than unaligned CPU data.

Not if it traps.

For powerpc it does win, because they don't trap on
unaligned accesses and the DMA cost is for non-cacheline
transfers is exhorbitant (not just large).

Now, practically speaking, sparc64 emits warnings when any
unaligned trap is taken.  I test the networking a lot and I
know of only one obscure case in the IPSEC interface with
userspace over netlink where I see it ever occur.

It is so much easier to make the 4-byte alignment thing an
invariant at one place, top-most packet input, then pepper
the whole stack with all kinds of packed markings and
get_unaligned() and whatnot.  And from my experience in sparc64
it's totally unnecessary and it will only add tons of overhead.

We could even move the check and the copy out of the drivers
and into the top-level packet input.

That would be a double win, things would always work and not
trap, but also drivers could still optimize cases where aspects
of hardware behavior would allow avoiding the unaligned cases
better on a driver-local level.

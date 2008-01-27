Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbYA0G2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 01:28:20 -0500
Date: Sat, 26 Jan 2008 22:25:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: mb@bu3sch.de, dcbw@redhat.com, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <20080126.052739.66441064.davem@davemloft.net>
Message-ID: <alpine.LFD.1.00.0801262208070.3222@www.l.google.com> (sfid-20080127_062824_833169_E0EF1683)
References: <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org> <200801251930.27022.mb@bu3sch.de> <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org> <20080126.052739.66441064.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Sat, 26 Jan 2008, David Miller wrote:
> 
> PowerPC handles unaligned accesses transparently, so it is safe
> for them to make this setting.

.. as does x86. Better than PowerPC, btw.

> It would not work out on sparc64 for example.

Right. Which is why different architectures should do different things, 
and which is why this should absolutely NOT be a driver issue. The driver 
should do what is natural to it.

If giving aligned data is reasonable, then obviously the driver should be 
striving for that, since regardless of architecture, alignment will never 
HURT the CPU.

But you seem to be totally ignoring people when they tell you that the 
hardware cannot necessarily do unaligned DMA well, or at all.

We've had that with disk controllers that simply *cannot* do DMA at less 
than 4-byte alignment, and where anything else has to be either done in 
software with PIO, or by memcpy.

You've also had Intel engineers tell you that the actual wireless stuff 
isn't just "firmware" - everybody who claims that this is an easy fix from 
Intel apparently has just been outright *lying*.

> So you'll see drivers for chips that have to 64-byte align the
> ethernet header in the RX packet for whatever reason, simply
> copy into a fresh buffer on receive.
> 
> Some drivers do this only platforms where unalign accesses trap or
> simply do not work.

.. and can't you see that this is STUPID?

Honestly, now, David - take a step back, and allow yourself to think about 
the issue. You have the following undeniable FACTS:

 - some hardware only does certain DMA alignment. This is a FACT. Treat it 
   as such, instead of whining about how Intel alledgely could easily fix 
   it.

   Quite frankly, I've been disgusted by people who say that it's "easy to 
   fix firmware". It's not. It then turns out that Intel people actually 
   step up and tell you that it's not even a firmware issue, are you now 
   going to say "It's easy to fix hardware - just a few lines of RTL"?

   So instead of this idiotic whining about "easy to fix firmware" that 
   turned out to be just total ignorance, how about the people who made 
   that claim step up and admit that (a) apparently not true, but also (b) 
   even if it had been "just" firmware, that was a totally idiotic claim 
   to begin with, since it's never been a valid excuse anyway!

And once you admit that first part ("some hardware will have different 
aligment requirements than the network stack has"), go on to the OBVIOUS 
secont step, which is to realize two other undeniable truths:

 - requiring individual drivers to do something in every driver is stupid 
   if it all boils down to something that could be done in *one* place 
   (the network stack entry).

   This is so obviously true that I really cannot see why you don't seem 
   to accept this. Drivers are hard enough to write as-is, and we want to 
   make driver writers have to worry as little as possible about things 
   like this.

 - The above is *doubly* true when it's simply not the case that "drivers 
   should always align packets to X bytes".

   Many CPU's handle unaligned accesses with little or no cost at all. 
   Most x86 chips have absolutely *zero* cost for an unaigned access that 
   doesn't cross a cache access boundary (often 8 bytes, these days I 
   think it's 16), and even when it requires crossing the natural internal 
   cache access bus width, it's usually not that high.

In other words, what you ask drivers to do is to not just create extra 
work for them, but create extra work for them in ways that aren't even 
obvious or relevant to most driver writers. Because on many architectures, 
they are better off *not* aligining things.

End result? When Intel writes a driver, they do it for the CPU 
architecture they care about. Which does *not* have the idiotic unaligned 
access problems that sparc has. So they do what makes sense to them, and I 
reall ycannot blame them for it.

So there's a very simple solution to this all: just make the entry to the 
networking layer re-align thing if required. In *one* single well-tested 
place. One that can do some smart things, like decide that re-aligning 
small packets may make sense even on architectures that don't have 
problems with unaligned accesses, just because the packet fits in one 
cacheline anyway.

That way al drivers can do what is best for *them*, and not have to worry. 
Yes, they'd like to align things naturally (in order to avoid the cost of 
the memcp()), but you don't create unnecessary and *stupid* work for them.

			Linus

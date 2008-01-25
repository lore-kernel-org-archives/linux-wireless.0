Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbYAYQKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 11:10:47 -0500
Date: Fri, 25 Jan 2008 08:08:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <1201264166.12870.16.camel@johannes.berg>
Message-ID: <alpine.LFD.1.00.0801250753240.14161@hp.linux-foundation.org> (sfid-20080125_161053_175579_22873C98)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>  <200801071830.51895.mb@bu3sch.de> <20080107212344.1372cc47@Varda>  <200801081630.31110.mb@bu3sch.de>  <alpine.LFD.1.00.0801241224050.2803@woody.linux-foundation.org>
 <20080124210728.GD3200@tuxdriver.com>  <alpine.LFD.1.00.0801241334010.7482@hp.linux-foundation.org>  (sfid-20080124_213551_947160_3434D67B) <1201264166.12870.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 25 Jan 2008, Johannes Berg wrote:
> 
> Since the only problematic driver is Intel's, they really should be able
> to get their act together for .25 and fix their firmware, if not then
> we'll have to think of something else like making their drivers
> memmove() the packets to the right place.

Well, there *is* a really simple solution:

 - realize that x86 (along with some few other architectures) is sane, and 
   not a crapola architecture that cannot do unaligneds well.

The thing is, not handling unaligned data well (and by "well", I don't 
mean just "without a trap", but "fast") is a problem for _other_ 
architectures, not x86. And quite frankly, x86 is not only the bulk of the 
machines out there, in this area it's also the one that did the right 
thing.

[ Lots of people think that x86 is ugly. The fact is, x86 is a paragon of 
  cleanliness when it comes to all the details that matter. When it comes 
  to ugly, the *really* ugly things is not in some complex ISA decoding, 
  but in all the horrible crap other architectures forces software to do 
  unnecessarily, when hardware can do it so much better! ]

So I would actually suggest that the wireless people realize that 
unaligned accesses aren't necessarily bad, and if there is code that needs 
alignment, maybe it's the *crap* architectures that should pay the price, 
not the good ones?

So I would suggest replacing that WARN_ON_ONCE() (which is gone now, but 
never mind, it marks the spot) with one of:

 - mark the header data structure unaligned, so that gcc will 
   automatically generate the extra instructions to do the accesses 
   automatically.

 - .. or, if there are just a few ones that actually matter, use 
   "get_unaligned()" in those places

 - .. or just make the WARN_ON_ONCE() be dependent on the broken 
   architecture in the first place.

 - .. or, finally, do something that penalizes crap and does

	#ifdef CONFIG_ARCH_NEEDS_ALIGNED
	  #define STRICT_ARCH_MINIMUM_ALIGNMENT alignof(..)
	#else
	  #define STRICT_ARCH_MINIMUM_ALIGNMENT 1
	#endif

	...
	unsigned long unalign;
	..
	unaligned = (unsigned long) ptr & (STRICT_ARCH_MINIMUM_ALIGNMENT-1);
	if (unaligned) {
		void *newptr = ptr;
		WARN_ON_ONCE(1);
		/* This assumes we have padding */
		newptr += STRICT_ARCH_MINIMUM_ALIGNMENT - unaligned;
		memmove(newptr, ptr, size);
	}
	..

because the thing is, we should give Intel credit for doing the right 
thing (in the CPU), rather than complain about the fact that they don't 
care about insane architectures that do the wrong thing and can't even 
work with the wireless driver in the first place!

			Linus

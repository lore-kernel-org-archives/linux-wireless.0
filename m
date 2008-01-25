Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:44762 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024AbYAYTgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 14:36:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.24-rc7
Date: Fri, 25 Jan 2008 20:34:23 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>,
	Jeff Garzik <jeff@garzik.org>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801251930.27022.mb@bu3sch.de> <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org>
MIME-Version: 1.0
Message-Id: <200801252034.23706.mb@bu3sch.de> (sfid-20080125_193629_912837_4DDA08F2)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008 20:07:47 Linus Torvalds wrote:
> 
> On Fri, 25 Jan 2008, Michael Buesch wrote:
> > 
> > The problem is _not_ the wireless header access, but the alignment of the embedded
> > protocol stack, if the header does not have a size aligned to 4.
> > Do we want to clutter the whole networking stack below wireless with
> > get_unaligned() or attribute(packed) or something like that?
> 
> That's what all the other protocols do, isn't it?
> 
> For example, on PowerPC, NET_IP_ALIGN is 0 - explicitly so that the *dma* 
> from the card should be aligned, even if that in turn means that the IP 
> payload itself is then just two-byte aligned rather than word-aligned 
> (14-byte ethernet headers and all that).
> 
> [ Side note - I _used_ to know the networking code. That was about eight 
>   to ten years ago. I'm really happy having a maintainer for it and not 
>   having to know all the details any more, so maybe things have changed. ]
> 
> I do think that we generally should try to make the drivers do as little 
> complex stuff as humanly possible, and expect as little from hardware (and 
> firmware counts in that group) as we can. If some higher-level thing 
> really needs things aligned in order to not have to have lots of ugly 
> code, it should generally extract that alignment itself.

So we should forward any bugreport about alignment issues to the
netdev people. That's perfectly fine with me. If netdev people are OK with that,
I'm also OK with removing the warning. :)

-- 
Greetings Michael.

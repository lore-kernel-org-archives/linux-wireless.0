Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58728 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbYA0HQj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 02:16:39 -0500
Message-ID: <479C2FB0.7080700@garzik.org> (sfid-20080127_071643_684896_D55846C5)
Date: Sun, 27 Jan 2008 02:16:00 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	mb@bu3sch.de, dcbw@redhat.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
References: <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org> <20080125194807.GD14687@tuxdriver.com> <alpine.LFD.1.00.0801251223590.2979@hp.linux-foundation.org> <20080126.053736.130683952.davem@davemloft.net> <alpine.LFD.1.00.0801262229300.3222@www.l.google.com>
In-Reply-To: <alpine.LFD.1.00.0801262229300.3222@www.l.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linus Torvalds wrote:
> But we shouldn't make up stupid rules like "network drivers *have* to 
> align packets correctly", simply because such rules may not make sense to 
> the driver writer. If the hardware simply cannot do it, or has some 
> horrible performance behaviour when it does so, it's stupid to tell a 
> driver that it has to do it.


<shrug>  seems like it should be possible to have an arch 
copy-and-align-if-necessary hook at the point of packet reception 
(netif_rx or netif_receive_skb).

And it would certainly be a nice cleanup to move all those driver 
implementations of rx_copybreak into common code.

But ultimately the driver knows the hardware (alignment requirements, RX 
skb allocation details) best, so by definition the low-level driver must 
communicate that information /somehow/.

That data may be communicated implicitly, sure:  maybe the 
aforementioned arch hook could simply look at the alignment of the skb's 
data, and make decision based on that (the driver still, by definition, 
ultimately controls RX skb allocation, alignment, and DMA boundaries and 
mappings)

It would be nice to stop maintaining code like the following in 
drivers/net/tulip/tulip_core.c:

> /* Set the copy breakpoint for the copy-only-tiny-buffer Rx structure. */
> #if defined(__alpha__) || defined(__arm__) || defined(__hppa__) \
>         || defined(CONFIG_SPARC) || defined(__ia64__) \
>         || defined(__sh__) || defined(__mips__)
> static int rx_copybreak = 1518;
> #else
> static int rx_copybreak = 100;
> #endif

The driver passes a lot of information implicitly to the net stack 
simply via its "style" of allocation and mapping.

Its really a question of where you want to pay the cost of unaligned 
accesses, and how much is too much.  If the data is going to be memcpy'd 
to userspace or another buffer almost immediately, maybe we don't even 
care, even on non-x86.

Never know until you bench, I guess...

	Jeff



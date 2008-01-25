Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55230 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759967AbYAYXWj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 18:22:39 -0500
Message-ID: <479A6F24.9030306@garzik.org> (sfid-20080125_232244_355296_40F13065)
Date: Fri, 25 Jan 2008 18:22:12 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Michael Buesch <mb@bu3sch.de>
CC: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org> <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org> <200801251930.27022.mb@bu3sch.de> <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linus Torvalds wrote:
> 
> On Fri, 25 Jan 2008, Michael Buesch wrote:
>> The problem is _not_ the wireless header access, but the alignment of the embedded
>> protocol stack, if the header does not have a size aligned to 4.
>> Do we want to clutter the whole networking stack below wireless with
>> get_unaligned() or attribute(packed) or something like that?
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

Actually...  grep for rx_copybreak in networking drivers.

For certain ethernet NIC hardware, given standard packet headers, your 
data will always be unaligned, which -does- have a cost, even on Intel. 
  On such hardware, this is required because the RX packet must start on 
a 32-bit (sometimes 64-bit) DMA boundary.

Since RX SKBs are pre-allocated, we use the driver-wide 'rx_copybreak' 
variable to determine the point at which an unaligned packet is painful 
enough that we should copy into a newly allocated, properly aligned skb 
(NET_IP_ALIGN, etc.)

Sane architectures can set rx_copybreak to MTU size.  Other 
architectures (at compile time) set the rx_copybreak default to 
something smaller.

	Jeff




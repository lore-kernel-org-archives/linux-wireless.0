Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53820
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbYAZN10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 08:27:26 -0500
Date: Sat, 26 Jan 2008 05:27:39 -0800 (PST)
Message-Id: <20080126.052739.66441064.davem@davemloft.net> (sfid-20080126_132730_544533_6020489D)
To: torvalds@linux-foundation.org
Cc: mb@bu3sch.de, dcbw@redhat.com, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org>
References: <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org>
	<200801251930.27022.mb@bu3sch.de>
	<alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Jan 2008 11:07:47 -0800 (PST)

> 
> 
> On Fri, 25 Jan 2008, Michael Buesch wrote:
> > 
> > The problem is _not_ the wireless header access, but the alignment of the embedded
> > protocol stack, if the header does not have a size aligned to 4.
> > Do we want to clutter the whole networking stack below wireless with
> > get_unaligned() or attribute(packed) or something like that?
> 
> That's what all the other protocols do, isn't it?

No.

> For example, on PowerPC, NET_IP_ALIGN is 0 - explicitly so that the *dma* 
> from the card should be aligned, even if that in turn means that the IP 
> payload itself is then just two-byte aligned rather than word-aligned 
> (14-byte ethernet headers and all that).

PowerPC handles unaligned accesses transparently, so it is safe
for them to make this setting.

It would not work out on sparc64 for example.

What happens in practice is that the drivers provide something
reasonably aligned for IPV4 headers.  That's why we don't mark the
IPV4 header structure as packed and that's why we don't have to use
get_unaligned() to dereference the 32-bit addresses in there.

So you'll see drivers for chips that have to 64-byte align the
ethernet header in the RX packet for whatever reason, simply
copy into a fresh buffer on receive.

Some drivers do this only platforms where unalign accesses trap or
simply do not work.

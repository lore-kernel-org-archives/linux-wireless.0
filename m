Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57759 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755806AbYAYTKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 14:10:09 -0500
Date: Fri, 25 Jan 2008 11:07:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <200801251930.27022.mb@bu3sch.de>
Message-ID: <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org> (sfid-20080125_191015_885675_07394D43)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org> <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org> <200801251930.27022.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 25 Jan 2008, Michael Buesch wrote:
> 
> The problem is _not_ the wireless header access, but the alignment of the embedded
> protocol stack, if the header does not have a size aligned to 4.
> Do we want to clutter the whole networking stack below wireless with
> get_unaligned() or attribute(packed) or something like that?

That's what all the other protocols do, isn't it?

For example, on PowerPC, NET_IP_ALIGN is 0 - explicitly so that the *dma* 
from the card should be aligned, even if that in turn means that the IP 
payload itself is then just two-byte aligned rather than word-aligned 
(14-byte ethernet headers and all that).

[ Side note - I _used_ to know the networking code. That was about eight 
  to ten years ago. I'm really happy having a maintainer for it and not 
  having to know all the details any more, so maybe things have changed. ]

I do think that we generally should try to make the drivers do as little 
complex stuff as humanly possible, and expect as little from hardware (and 
firmware counts in that group) as we can. If some higher-level thing 
really needs things aligned in order to not have to have lots of ugly 
code, it should generally extract that alignment itself.

			Linus

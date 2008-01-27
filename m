Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41998 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115AbYA0GfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 01:35:16 -0500
Date: Sat, 26 Jan 2008 22:32:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: linville@tuxdriver.com, mb@bu3sch.de, dcbw@redhat.com,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <20080126.053736.130683952.davem@davemloft.net>
Message-ID: <alpine.LFD.1.00.0801262229300.3222@www.l.google.com> (sfid-20080127_063520_213138_FFC8BEC5)
References: <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org> <20080125194807.GD14687@tuxdriver.com> <alpine.LFD.1.00.0801251223590.2979@hp.linux-foundation.org> <20080126.053736.130683952.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Sat, 26 Jan 2008, David Miller wrote:
> 
> We could even move the check and the copy out of the drivers
> and into the top-level packet input.

Hallelujah! Exactly.

> That would be a double win, things would always work and not
> trap, but also drivers could still optimize cases where aspects
> of hardware behavior would allow avoiding the unaligned cases
> better on a driver-local level.

Absolutely. Even on x86 and PowerPC, even if the actual "memmove()" 
doesn't take place, a driver that *can* make the packet data naturally 
aligned will want to do so just for simple performance reasons.

But we shouldn't make up stupid rules like "network drivers *have* to 
align packets correctly", simply because such rules may not make sense to 
the driver writer. If the hardware simply cannot do it, or has some 
horrible performance behaviour when it does so, it's stupid to tell a 
driver that it has to do it.

			Linus

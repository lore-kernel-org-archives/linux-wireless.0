Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56583
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbYA0HYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 02:24:17 -0500
Date: Sat, 26 Jan 2008 23:24:31 -0800 (PST)
Message-Id: <20080126.232431.193736209.davem@davemloft.net> (sfid-20080127_072420_825761_14BA02B6)
To: jeff@garzik.org
Cc: torvalds@linux-foundation.org, linville@tuxdriver.com,
	mb@bu3sch.de, dcbw@redhat.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
From: David Miller <davem@davemloft.net>
In-Reply-To: <479C2FB0.7080700@garzik.org>
References: <20080126.053736.130683952.davem@davemloft.net>
	<alpine.LFD.1.00.0801262229300.3222@www.l.google.com>
	<479C2FB0.7080700@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jeff Garzik <jeff@garzik.org>
Date: Sun, 27 Jan 2008 02:16:00 -0500

> It would be nice to stop maintaining code like the following in 
> drivers/net/tulip/tulip_core.c:
> 
> > /* Set the copy breakpoint for the copy-only-tiny-buffer Rx structure. */
> > #if defined(__alpha__) || defined(__arm__) || defined(__hppa__) \
> >         || defined(CONFIG_SPARC) || defined(__ia64__) \
> >         || defined(__sh__) || defined(__mips__)
> > static int rx_copybreak = 1518;
> > #else
> > static int rx_copybreak = 100;
> > #endif
> 
> The driver passes a lot of information implicitly to the net stack 
> simply via its "style" of allocation and mapping.

I just want to note in passing that we should remember that
there is a secoondary reason this copy-break logic exists
in the drivers.

When a reeived packet is attached to, and charged to, a socket,
we account the real amount of memory the SKB has allocated to it.

This means if the driver allocates full MTU sized frames for the
device to DMA into, we can cause unintended problems for passing
that packet directly in if there is only say 100 bytes of data.

The socket gets charged for a full MTU's amount of memory instead
of something more on the order of 100 bytes :-)

In fact that is the original reason all of these things exists,
it was just simple to extend it to handle alignment cases too.

Anyways, once we put the logic for unaligned handling into a
centralized location the above can now evaluate to a constant,
or default to the lower value of 100.

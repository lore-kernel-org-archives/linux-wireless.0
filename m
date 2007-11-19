Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:54367 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbXKSSGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 13:06:03 -0500
Date: Mon, 19 Nov 2007 10:04:23 -0800
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071119180423.GA19250@bougret.hpl.hp.com> (sfid-20071119_180611_283244_09314ECD)
Reply-To: jt@hpl.hp.com
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1195484582.8642.18.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2007 at 04:03:02PM +0100, Johannes Berg wrote:
> 
> > > The first noticeable problem is when using iwconfig on the device. I 
> > > cannot set a key for the device, and a query of the configuration always 
> > > claims that the "<encryption key is too long>".
> > 
> > Likely some wireless ioctl compat layer bug in the kernel.
> 
> Is this 32/64 interop? The kernel has never been fixed and never will
> be. New wireless tools should "support" this, but imnsho you're *much*
> better off compiling 64-bit wireless tools.

	There was a patch for this kind of issue from Masakazu Mokuno
that went in 2.6.22 or 2.6.23 that was touching that part. I don't
think he went in the stable series, but probably should have. There
are other potential cause of problem here, and I suspect he might get
the same error with 64 bits userspace.
	Can you give me the exact error text as reported by iwconfig ?
I'll probably have to send you a test version to see what's happening
under the cover.

> > > If I try to scan for APs using iwlist, I get one AP listed, before a bus 
> > > error occurs. This of course, does not suggest that the problem is with 
> > > the driver, but I mention it for the record.
> > 
> > This is an unaligned data access in the userland tools.
> > Try to catch it with GDB and give us ths backtrace.
> 
> For Jean.

	Definitely, it sounds familiar.
	This is that I need :
		o version of the kernel
		o version of the driver if not stock driver
		o version of Wireless Tools (iwconfig --version).
	Most likely, you need to upgrade your Wireless Tools to
version 29 which fixes this 32/64 interop problem.
	With the latest kernel and the latest wireless tools, the only
known bugs are the two ESSID bugs.

	Regards,

	Jean

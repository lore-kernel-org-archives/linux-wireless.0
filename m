Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33613
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751750AbXKSWUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 17:20:47 -0500
Date: Mon, 19 Nov 2007 14:20:46 -0800 (PST)
Message-Id: <20071119.142046.188284555.davem@davemloft.net> (sfid-20071119_222049_481618_AAC88077)
To: johannes@sipsolutions.net
Cc: shaddy_baddah@hotmail.com, linux-wireless@vger.kernel.org,
	jt@hpl.hp.com, dsd@gentoo.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1195484582.8642.18.camel@johannes.berg>
References: <4740DF47.4040206@hotmail.com>
	<20071119.002755.77617097.davem@davemloft.net>
	<1195484582.8642.18.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 19 Nov 2007 16:03:02 +0100

> 
> > > The first noticeable problem is when using iwconfig on the device. I 
> > > cannot set a key for the device, and a query of the configuration always 
> > > claims that the "<encryption key is too long>".
> > 
> > Likely some wireless ioctl compat layer bug in the kernel.
> 
> Is this 32/64 interop?

It has to be, %99 of sparc64 userland is 32-bit.

> The kernel has never been fixed and never will be. New wireless
> tools should "support" this, but imnsho you're *much* better off
> compiling 64-bit wireless tools.

This is an unreasonable requirement, all kernel ABIs should work in
32-bit compat tasks.  And when it's very difficult or impossible to
make it work, there should be a new ABI to transition to that does
work in compat mode and in particular would work now for the user.

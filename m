Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34068
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753356AbXKTWic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 17:38:32 -0500
Date: Tue, 20 Nov 2007 14:38:31 -0800 (PST)
Message-Id: <20071120.143831.134792608.davem@davemloft.net> (sfid-20071120_223834_893032_96C59ECA)
To: linville@tuxdriver.com
Cc: jt@hpl.hp.com, johannes@sipsolutions.net,
	shaddy_baddah@hotmail.com, linux-wireless@vger.kernel.org,
	dsd@gentoo.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071120220850.GG16090@tuxdriver.com>
References: <20071120180016.GC1480@bougret.hpl.hp.com>
	<20071120.135842.122514400.davem@davemloft.net>
	<20071120220850.GG16090@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 20 Nov 2007 17:08:50 -0500

> On Tue, Nov 20, 2007 at 01:58:42PM -0800, David Miller wrote:
> > From: Jean Tourrilhes <jt@hpl.hp.com>
> > Date: Tue, 20 Nov 2007 10:00:16 -0800
> > 
> > > 	This is a special version of Wireless Tools with some debug
> > > code. It will help me understand what's happening with the bus error
> > > while scanning and see what fix I can come up with.
> > > 	What you need to do is :
> > > 		o untar, make
> > > 		o ./iwlist scan > scan.log
> > > 	And send me the result.
> > 
> > I already know what's happening.  Your "fixup" code is deferencing
> > the wrong part of the iw_point pointer, it only works on little
> > endian.
> > 
> > The fix is to remove the userland fixup code entirely and fixup
> > the stream in the kernel.
> 
> What a mess...are there going to be userland ABI implications of this?
> Hopefully the fact that 64-bit kernels were just broken is enough
> justifcation to fix this?

I think we'll be OK, to my knowledge only the wireless tools
tried to "correct" this in userspace and it only triggers
when a specific length check fails.

So if we fix the kernel, the length check won't trigger any more
and things will just work.

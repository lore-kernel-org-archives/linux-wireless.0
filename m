Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4930 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206AbXKTWQA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 17:16:00 -0500
Date: Tue, 20 Nov 2007 17:08:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: jt@hpl.hp.com, johannes@sipsolutions.net,
	shaddy_baddah@hotmail.com, linux-wireless@vger.kernel.org,
	dsd@gentoo.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071120220850.GG16090@tuxdriver.com> (sfid-20071120_221604_545047_162BF9F4)
References: <1195562454.10920.6.camel@johannes.berg> <20071120.044600.47940350.davem@davemloft.net> <20071120180016.GC1480@bougret.hpl.hp.com> <20071120.135842.122514400.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071120.135842.122514400.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 20, 2007 at 01:58:42PM -0800, David Miller wrote:
> From: Jean Tourrilhes <jt@hpl.hp.com>
> Date: Tue, 20 Nov 2007 10:00:16 -0800
> 
> > 	This is a special version of Wireless Tools with some debug
> > code. It will help me understand what's happening with the bus error
> > while scanning and see what fix I can come up with.
> > 	What you need to do is :
> > 		o untar, make
> > 		o ./iwlist scan > scan.log
> > 	And send me the result.
> 
> I already know what's happening.  Your "fixup" code is deferencing
> the wrong part of the iw_point pointer, it only works on little
> endian.
> 
> The fix is to remove the userland fixup code entirely and fixup
> the stream in the kernel.

What a mess...are there going to be userland ABI implications of this?
Hopefully the fact that 64-bit kernels were just broken is enough
justifcation to fix this?

John
-- 
John W. Linville
linville@tuxdriver.com

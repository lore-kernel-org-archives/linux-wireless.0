Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:50129 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761298AbXKTWQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 17:16:48 -0500
Date: Tue, 20 Nov 2007 14:16:36 -0800
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071120221636.GA4711@bougret.hpl.hp.com> (sfid-20071120_221715_454157_BAAC2927)
Reply-To: jt@hpl.hp.com
References: <1195562454.10920.6.camel@johannes.berg> <20071120.044600.47940350.davem@davemloft.net> <20071120180016.GC1480@bougret.hpl.hp.com> <20071120.135842.122514400.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071120.135842.122514400.davem@davemloft.net>
From: Jean Tourrilhes <jt@hpl.hp.com>
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

	I personally want to see the hard data, to make sure I fully
understand it. I'm sorry, but I'm not as experienced as you guys
dealing with endianess and alignement.
	I'll try to look at it when I can find cycles for it.

> The fix is to remove the userland fixup code entirely and fixup
> the stream in the kernel.

	If you look at the overall picture, that would introduce a lot
of complex and tricky code in the kernel, you would need pretty much
the full parser (the metadata, you can get from the wext code). I'm
not sure it's practical where the userspace fix is way simpler.
	Also, it was my long term goal to fix the event code in the
kernel to always make it 32 bit aligned. That would be the simpler
solutions, but we can't get there immediately.

	Regards,

	Jean


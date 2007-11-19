Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59874
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbXKSMTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 07:19:51 -0500
Date: Mon, 19 Nov 2007 04:19:50 -0800 (PST)
Message-Id: <20071119.041950.26533240.davem@davemloft.net> (sfid-20071119_121957_723589_15EE56B2)
To: linux-wireless@vger.kernel.org, shaddy_baddah@hotmail.com
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <47417D7F.3060704@hotmail.com>
References: <4740DF47.4040206@hotmail.com>
	<20071119.002755.77617097.davem@davemloft.net>
	<47417D7F.3060704@hotmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Date: Mon, 19 Nov 2007 23:11:43 +1100

> David Miller wrote:
> >> Whilst the device is up, I continually get console messages like those I 
> >> have inlined below:
> >>
> >> Kernel unaligned access at TPC[100ee4d4] do_rx+0x244/0x614 [zd1211rw]
> >> Kernel unaligned access at TPC[100ee4e8] do_rx+0x258/0x614 [zd1211rw]
> >> Kernel unaligned access at TPC[100ee4cc] do_rx+0x23c/0x614 [zd1211rw]
> > 
> > These are unaligned data accesses in the kernel driver.
> 
> Sure. Just to make sure I understand, does TPC stand for something like 
> Trap Program Code?

It's simply the program counter of the CPU at the time of the trap.
It maps to the symbol and offset printed right afterwards, which
would be somewhere in do_rx() in the zd1211rw driver.

Probably it's parsing some data structure in the incoming packet
buffer which is misaligned.

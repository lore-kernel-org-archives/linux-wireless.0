Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34337
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbXKTV6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 16:58:42 -0500
Date: Tue, 20 Nov 2007 13:58:42 -0800 (PST)
Message-Id: <20071120.135842.122514400.davem@davemloft.net> (sfid-20071120_215845_627995_3153CA5C)
To: jt@hpl.hp.com
Cc: johannes@sipsolutions.net, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071120180016.GC1480@bougret.hpl.hp.com>
References: <1195562454.10920.6.camel@johannes.berg>
	<20071120.044600.47940350.davem@davemloft.net>
	<20071120180016.GC1480@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jean Tourrilhes <jt@hpl.hp.com>
Date: Tue, 20 Nov 2007 10:00:16 -0800

> 	This is a special version of Wireless Tools with some debug
> code. It will help me understand what's happening with the bus error
> while scanning and see what fix I can come up with.
> 	What you need to do is :
> 		o untar, make
> 		o ./iwlist scan > scan.log
> 	And send me the result.

I already know what's happening.  Your "fixup" code is deferencing
the wrong part of the iw_point pointer, it only works on little
endian.

The fix is to remove the userland fixup code entirely and fixup
the stream in the kernel.

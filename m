Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37443
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752295AbXKSI14 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 03:27:56 -0500
Date: Mon, 19 Nov 2007 00:27:55 -0800 (PST)
Message-Id: <20071119.002755.77617097.davem@davemloft.net> (sfid-20071119_082758_146579_574C7820)
To: shaddy_baddah@hotmail.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <4740DF47.4040206@hotmail.com>
References: <4740DF47.4040206@hotmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Date: Mon, 19 Nov 2007 11:56:39 +1100

> The first noticeable problem is when using iwconfig on the device. I 
> cannot set a key for the device, and a query of the configuration always 
> claims that the "<encryption key is too long>".

Likely some wireless ioctl compat layer bug in the kernel.

> If I try to scan for APs using iwlist, I get one AP listed, before a bus 
> error occurs. This of course, does not suggest that the problem is with 
> the driver, but I mention it for the record.

This is an unaligned data access in the userland tools.
Try to catch it with GDB and give us ths backtrace.

> Whilst the device is up, I continually get console messages like those I 
> have inlined below:
> 
> Kernel unaligned access at TPC[100ee4d4] do_rx+0x244/0x614 [zd1211rw]
> Kernel unaligned access at TPC[100ee4e8] do_rx+0x258/0x614 [zd1211rw]
> Kernel unaligned access at TPC[100ee4cc] do_rx+0x23c/0x614 [zd1211rw]

These are unaligned data accesses in the kernel driver.

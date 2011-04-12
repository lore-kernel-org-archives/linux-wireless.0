Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:45638 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932593Ab1DLVWm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 17:22:42 -0400
Date: Tue, 12 Apr 2011 23:22:36 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Igor Plyatov <plyatov@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: rt2800usb: page allocation failure
Message-ID: <20110412212236.GA8877@sig21.net>
References: <4DA471DC.7080308@gmail.com>
 <4DA49332.8000403@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DA49332.8000403@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 12, 2011 at 01:00:18PM -0500, Larry Finger wrote:
> On 04/12/2011 10:38 AM, Igor Plyatov wrote:
> 
> >kworker/u:1: page allocation failure. order:1, mode:0x20

mode:0x20 corresponds with GFP_ATOMIC

> >[<c0279450>] (dev_alloc_skb+0x0/0x44) from [<c0226698>]
> >(rt2x00queue_alloc_rxskb+0x4c/0xc4)
> >[<c022664c>] (rt2x00queue_alloc_rxskb+0x0/0xc4) from [<c0223480>]
> >(rt2x00lib_rxdone+0x44/0x298)
> 
> --snip--
> 
> >Normal: 403*4kB 2*8kB 2*16kB 2*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB
> >0*2048kB 0*4096kB = 1724kB
> 
> Your system is failing to get a receive buffer of size 8kB
> (order:1). If we look at the last line above, you have quite a bit
> of memory free, but it is highly fragmented - almost all of it is in
> 4kB pieces. This condition is not fatal, but it can be avoided by
> changing the NIC parameters so that each RX buffer fits in 4k.
> 
> If you look at the ifconfig output for this device, the MTU is
> likely 1500. By reducing this, you should be able to get all buffers
> to be of order 0. I would start with 1400 to see if it makes the
> problem go away. Reducing this quantity has the potential to slow
> the network transfers, but you won't see it as the default block
> size for dd is 512. Any such slowdown will be much less severe than
> the delay causes by missing a buffer allocation.

I don't think the allocation uses the MTU, rather rt2x00queue_alloc_rxskb()
uses some hw specific constants.  No idea if these can be reduced,
but multi-page GFP_ATOMIC allocations can easily fail.

However, I'm not sure why an 8kB allocation fails if the oom dump
says 2*8kB are available.  I guess it has something to do with
the GFP_ATOMIC.


Johannes

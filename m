Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34328
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753273AbXKTV4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 16:56:43 -0500
Date: Tue, 20 Nov 2007 13:56:42 -0800 (PST)
Message-Id: <20071120.135642.267507461.davem@davemloft.net> (sfid-20071120_215647_381038_30348E91)
To: jt@hpl.hp.com
Cc: johannes@sipsolutions.net, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071120174330.GB1480@bougret.hpl.hp.com>
References: <20071119223554.GA21844@bougret.hpl.hp.com>
	<20071119.234201.19874188.davem@davemloft.net>
	<20071120174330.GB1480@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jean Tourrilhes <jt@hpl.hp.com>
Date: Tue, 20 Nov 2007 09:43:30 -0800

> On Mon, Nov 19, 2007 at 11:42:01PM -0800, David Miller wrote:
> > From: Jean Tourrilhes <jt@hpl.hp.com>
> > Date: Mon, 19 Nov 2007 14:35:54 -0800
> > 
> > > I don't have a 64 bit box.
> > 
> > Let me know when you have joined us in the 21st century.
> 
> 	Well, if you are so rich, please send me a new computer. I'm
> not paid to do any of this stuff.

The irony is that you don't even need a 64-bit system to work on this
kind of bug, consider qemu or similar.

But on my side I did all of my analysis with code inspection.

> 	As I was saying, we made a lot of progress in the last few
> months. And it works.

If you look at my bug fix, wext does anything but work, it writes over
random data in userspace on all 64-bit platforms.

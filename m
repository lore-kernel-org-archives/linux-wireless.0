Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57489
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760654AbXKTWlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 17:41:18 -0500
Date: Tue, 20 Nov 2007 14:41:18 -0800 (PST)
Message-Id: <20071120.144118.193941085.davem@davemloft.net> (sfid-20071120_224131_393113_124F338F)
To: jt@hpl.hp.com
Cc: johannes@sipsolutions.net, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071120221636.GA4711@bougret.hpl.hp.com>
References: <20071120180016.GC1480@bougret.hpl.hp.com>
	<20071120.135842.122514400.davem@davemloft.net>
	<20071120221636.GA4711@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jean Tourrilhes <jt@hpl.hp.com>
Date: Tue, 20 Nov 2007 14:16:36 -0800

> > The fix is to remove the userland fixup code entirely and fixup
> > the stream in the kernel.
> 
> 	If you look at the overall picture, that would introduce a lot
> of complex and tricky code in the kernel, you would need pretty much
> the full parser (the metadata, you can get from the wext code). I'm
> not sure it's practical where the userspace fix is way simpler.

Please, just drop this, I'm going to fix it up since you seem
persistent on just passing the buck around and not realizing what the
core issue is.

You can't fix these problems in userspace, it's not elegant, and
it buys nothing but pain for users.

Everyone who writes some user code that uses wext ioctls has to do
this conversion crap, that's totally bogus and absolutely beyond
unreasonable.

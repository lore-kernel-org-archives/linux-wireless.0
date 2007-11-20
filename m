Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56096
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756863AbXKTMqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 07:46:00 -0500
Date: Tue, 20 Nov 2007 04:46:00 -0800 (PST)
Message-Id: <20071120.044600.47940350.davem@davemloft.net> (sfid-20071120_124604_593674_771B9F0D)
To: johannes@sipsolutions.net
Cc: shaddy_baddah@hotmail.com, linux-wireless@vger.kernel.org,
	jt@hpl.hp.com, dsd@gentoo.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1195562454.10920.6.camel@johannes.berg>
References: <1195484582.8642.18.camel@johannes.berg>
	<20071119.142046.188284555.davem@davemloft.net>
	<1195562454.10920.6.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 20 Nov 2007 13:40:54 +0100

> > > The kernel has never been fixed and never will be. New wireless
> > > tools should "support" this, but imnsho you're *much* better off
> > > compiling 64-bit wireless tools.
> > 
> > This is an unreasonable requirement, all kernel ABIs should work in
> > 32-bit compat tasks.  And when it's very difficult or impossible to
> > make it work, there should be a new ABI to transition to that does
> > work in compat mode and in particular would work now for the user.
> 
> Well, I complained too but it's unfixable without breaking one thing or
> the other, consider netlink messages with iw_point in them that are
> broadcast. Ugh.

That's fine, I understand how difficult it is to translate things
embedded in netlink messages but:

1) even the netlink case can be fixed, we need some infrastructure
   to set some state at the top of the syscall path, and then when
   we call into the netlink protocol handler it will know what
   format the netlink payload needs to be in

and

2) the ioctls are broken too and that definitely can be fixed

We cannot have tools and interfaces that only work on native
binaries.

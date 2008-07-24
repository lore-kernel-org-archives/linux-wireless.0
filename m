Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57755 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYGXJ1C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 05:27:02 -0400
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: jarkao2@gmail.com, Larry.Finger@lwfinger.net, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, mingo@redhat.com,
	nickpiggin@yahoo.com.au, paulmck@linux.vnet.ibm.com
In-Reply-To: <20080724.022040.23129457.davem@davemloft.net>
References: <20080723114914.GF4561@ff.dom.local>
	 <20080723.131607.79681752.davem@davemloft.net>
	 <1216890648.7257.258.camel@twins>
	 <20080724.022040.23129457.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 11:27:05 +0200
Message-Id: <1216891625.7257.261.camel@twins> (sfid-20080724_112707_469104_4E474408)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-07-24 at 02:20 -0700, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Thu, 24 Jul 2008 11:10:48 +0200
> 
> > Ok, then how about something like this, the idea is to wrap the per tx
> > lock with a read lock of the device and let the netif_tx_lock() be the
> > write side, therefore excluding all device locks, but not incure the
> > cacheline bouncing on the read side by using per-cpu counters like rcu
> > does.
> > 
> > This of course requires that netif_tx_lock() is rare, otherwise stuff
> > will go bounce anyway...
> > 
> > Probably missed a few details,.. but I think the below ought to show the
> > idea...
> 
> Thanks for the effort, but I don't think we can seriously consider
> this.
> 
> This lock is taken for every packet transmitted by the system, adding
> another memory reference (the RCU deref) and a counter bump is just
> not something we can just add to placate lockdep.  We going through
> all of this effort to seperate the TX locking into individual
> queues, it would be silly to go back and make it more expensive.

Well, not only lockdep, taking a very large number of locks is expensive
as well.

> I have other ideas which I've expanded upon in other emails.  They
> involve creating a netif_tx_freeze() interface and getting the drivers
> to start using it.

OK, as long as we get there :-)


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59062
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbYGXJUk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 05:20:40 -0400
Date: Thu, 24 Jul 2008 02:20:40 -0700 (PDT)
Message-Id: <20080724.022040.23129457.davem@davemloft.net> (sfid-20080724_112046_293068_0BCF8445)
To: peterz@infradead.org
Cc: jarkao2@gmail.com, Larry.Finger@lwfinger.net, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, mingo@redhat.com,
	nickpiggin@yahoo.com.au, paulmck@linux.vnet.ibm.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
 __netif_schedule+0x2c/0x98()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216890648.7257.258.camel@twins>
References: <20080723114914.GF4561@ff.dom.local>
	<20080723.131607.79681752.davem@davemloft.net>
	<1216890648.7257.258.camel@twins>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peter Zijlstra <peterz@infradead.org>
Date: Thu, 24 Jul 2008 11:10:48 +0200

> Ok, then how about something like this, the idea is to wrap the per tx
> lock with a read lock of the device and let the netif_tx_lock() be the
> write side, therefore excluding all device locks, but not incure the
> cacheline bouncing on the read side by using per-cpu counters like rcu
> does.
> 
> This of course requires that netif_tx_lock() is rare, otherwise stuff
> will go bounce anyway...
> 
> Probably missed a few details,.. but I think the below ought to show the
> idea...

Thanks for the effort, but I don't think we can seriously consider
this.

This lock is taken for every packet transmitted by the system, adding
another memory reference (the RCU deref) and a counter bump is just
not something we can just add to placate lockdep.  We going through
all of this effort to seperate the TX locking into individual
queues, it would be silly to go back and make it more expensive.

I have other ideas which I've expanded upon in other emails.  They
involve creating a netif_tx_freeze() interface and getting the drivers
to start using it.

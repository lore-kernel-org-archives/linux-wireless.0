Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46375 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbYGXKJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 06:09:19 -0400
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: jarkao2@gmail.com, Larry.Finger@lwfinger.net, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, mingo@redhat.com,
	nickpiggin@yahoo.com.au, paulmck@linux.vnet.ibm.com
In-Reply-To: <20080724.023210.229338550.davem@davemloft.net>
References: <1216890648.7257.258.camel@twins>
	 <20080724.022040.23129457.davem@davemloft.net>
	 <1216891625.7257.261.camel@twins>
	 <20080724.023210.229338550.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 12:08:56 +0200
Message-Id: <1216894136.7257.266.camel@twins> (sfid-20080724_120924_331819_7CC39857)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-07-24 at 02:32 -0700, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Thu, 24 Jul 2008 11:27:05 +0200
> 
> > Well, not only lockdep, taking a very large number of locks is expensive
> > as well.
> 
> Right now it would be on the order of 16 or 32 for
> real hardware.
> 
> Much less than the scheduler currently takes on some
> of my systems, so currently you are the pot calling the
> kettle black. :-)

One nit, and then I'll let this issue rest :-)

The scheduler has a long lock dependancy chain (nr_cpu_ids rq locks),
but it never takes all of them at the same time. Any one code path will
at most hold two rq locks.




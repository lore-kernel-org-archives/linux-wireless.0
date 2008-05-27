Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778AbYE0Nxt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 09:53:49 -0400
Subject: Re: [PATCH] net: wireless: airo semaphore to mutex
From: Dan Williams <dcbw@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Daniel Walker <dwalker@mvista.com>, linville@tuxdriver.com,
	rusty@rustcorp.com.au, mingo@elte.hu, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, arjan@infradead.org
In-Reply-To: <20080527131325.GJ30894@parisc-linux.org>
References: <20080522232103.120033152@mvista.com>
	 <20080527131325.GJ30894@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 27 May 2008 09:48:28 -0400
Message-Id: <1211896108.1746.3.camel@localhost.localdomain> (sfid-20080527_155354_421295_384D74F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-27 at 07:13 -0600, Matthew Wilcox wrote:
> On Thu, May 22, 2008 at 04:21:03PM -0700, Daniel Walker wrote:
> > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> Reviewing the driver, this really doesn't feel like a classical lock.
> It feels very much ad-hoc, with most references to ->sem being
> unbalanced.

It should be a classical lock actually.  There shouldn't be any case
where semaphore behavior is used or needed.

> The driver has a thread (airo_thread) and it seems to be trying to
> synchronise against both the interrupt handler, and other threads
> (calling eg ->get_stats).

Right, though it's important to note that anything coming from WEXT will
already be under the rtnl lock and should already be serialized, so we
don't need to protect any of the WEXT handlers _from themselves_, just
from the main thread and the interrupt handler.

> I think it really wants to be using spin_lock_irqsave() instead of a
> mutex.  I'd want to study the driver in a lot more detail before making
> that kind of change though.

Yeah, that might be the right way to go.  If you want to jump into the
driver, feel quite free, but I don't think you need to go into too much
detail with it.  Your overall behavior analysis is right on the mark
already.

Dan


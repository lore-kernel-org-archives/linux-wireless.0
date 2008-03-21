Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024AbYCUDTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 23:19:47 -0400
Date: Thu, 20 Mar 2008 20:17:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Michael Buesch <mb@bu3sch.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	David Brownell <david-b@pacbell.net>,
	Richard Purdie <rpurdie@rpsys.net>,
	<linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	<netdev@vger.kernel.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	<linux-usb@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<video4linux-list@redhat.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	<lm-sensors@lm-sensors.org>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-Id: <20080320201723.b87b3732.akpm@linux-foundation.org> (sfid-20080321_032025_834351_0CE21F83)
In-Reply-To: <Pine.LNX.4.44L0.0803202301140.16520-100000@netrider.rowland.org>
References: <20080320192719.6a32386e.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0803202301140.16520-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 20 Mar 2008 23:07:16 -0400 (EDT) Alan Stern <stern@rowland.harvard.edu> wrote:

> On Thu, 20 Mar 2008, Andrew Morton wrote:
> 
> > > > > Now, it happens that in_atomic() returns true on non-preemtible kernels
> > > > > when running in interrupt or softirq context.  But if the above code really
> > > > > is using in_atomic() to detect am-i-called-from-interrupt and NOT
> > > > > am-i-called-from-inside-spinlock, they should be using in_irq(),
> > > > > in_softirq() or in_interrupt().
> > > > 
> > > > Presumably most of these places are actually trying to detect 
> > > > am-i-allowed-to-sleep.  Isn't that what in_atomic() is supposed to do?  
> > > 
> > > No, I think there is no such check in the kernel. Most likely for performance
> > > reasons, as it would require a global flag that is set on each spinlock.
> > 
> > Yup.  non-preemptible kernels avoid the inc/dec of
> > current_thread_info->preempt_count on spin_lock/spin_unlock
> 
> So then what's the point of having in_atomic() at all?  Is it nothing 
> more than a shorthand form of (in_irq() | in_softirq() | 
> in_interrupt())?

in_atomic() is for core kernel use only.  Because in special circumstances
(ie: kmap_atomic()) we run inc_preempt_count() even on non-preemptible
kernels to tell the per-arch fault handler that it was invoked by
copy_*_user() inside kmap_atomic(), and it must fail.

> In short, you are saying that there is _no_ reliable way to determine
> am-i-called-from-inside-spinlock.

That's correct.

>  Well, why isn't there?

The reasons I identified: it adds additional overhead and it encourages
poorly-thought-out design.

Now we _could_ change kernel design principles from
caller-knows-whats-going-on over to callee-works-out-whats-going-on.  But
that would affect more than this particular thing.

>  Would it be 
> so terrible if non-preemptible kernels did adjust preempt_count on 
> spin_lock/unlock?

The vast, vast majority of kernel code has managed to get through life
without needing this hidden-argument-passing.  The handful of errant
callsites should be able to do so as well...


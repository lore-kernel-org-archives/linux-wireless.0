Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:46477 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755947AbYGXKp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 06:45:27 -0400
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Kernel WARNING: at net/core/dev.c:1330 __netif_schedule+0x2c/0x98()
Date: Thu, 24 Jul 2008 20:38:35 +1000
Cc: David Miller <davem@davemloft.net>, jarkao2@gmail.com,
	Larry.Finger@lwfinger.net, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, mingo@redhat.com,
	paulmck@linux.vnet.ibm.com
References: <1216890648.7257.258.camel@twins> <20080724.023210.229338550.davem@davemloft.net> <1216894136.7257.266.camel@twins>
In-Reply-To: <1216894136.7257.266.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807242038.36693.nickpiggin@yahoo.com.au> (sfid-20080724_124532_493499_A9D01290)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 July 2008 20:08, Peter Zijlstra wrote:
> On Thu, 2008-07-24 at 02:32 -0700, David Miller wrote:
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Thu, 24 Jul 2008 11:27:05 +0200
> >
> > > Well, not only lockdep, taking a very large number of locks is
> > > expensive as well.
> >
> > Right now it would be on the order of 16 or 32 for
> > real hardware.
> >
> > Much less than the scheduler currently takes on some
> > of my systems, so currently you are the pot calling the
> > kettle black. :-)
>
> One nit, and then I'll let this issue rest :-)
>
> The scheduler has a long lock dependancy chain (nr_cpu_ids rq locks),
> but it never takes all of them at the same time. Any one code path will
> at most hold two rq locks.

Aside from lockdep, is there a particular problem with taking 64k locks
at once? (in a very slow path, of course) I don't think it causes a
problem with preempt_count, does it cause issues with -rt kernel?

Hey, something kind of cool (and OT) I've just thought of that we can
do with ticket locks is to take tickets for 2 (or 64K) nested locks,
and then wait for them both (all), so the cost is N*lock + longest spin,
rather than N*lock + N*avg spin.

That would mean even at the worst case of a huge amount of contention
on all 64K locks, it should only take a couple of ms to take all of
them (assuming max spin time isn't ridiculous).

Probably not the kind of feature we want to expose widely, but for
really special things like the scheduler, it might be a neat hack to
save a few cycles ;) Traditional implementations would just have
#define spin_lock_async	      spin_lock
#define spin_lock_async_wait  do {} while (0)

Sorry it's offtopic, but if I didn't post it, I'd forget to. Might be
a fun quick hack for someone.

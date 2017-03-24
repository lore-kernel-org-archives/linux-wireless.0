Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56156 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965834AbdCXSwE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 14:52:04 -0400
Message-ID: <1490381507.9586.1.camel@sipsolutions.net> (sfid-20170324_195255_193872_3E6F362B)
Subject: Re: deadlock in synchronize_srcu() in debugfs?
From: Johannes Berg <johannes@sipsolutions.net>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nicolai Stange <nicstange@gmail.com>,
        gregkh <gregkh@linuxfoundation.org>, sharon.dvir@intel.com,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 24 Mar 2017 19:51:47 +0100
In-Reply-To: <20170324174542.GH3637@linux.vnet.ibm.com>
References: <1490280886.2766.4.camel@sipsolutions.net>
         <1490282991.2766.7.camel@sipsolutions.net>
         <1490345799.2766.15.camel@sipsolutions.net>
         <1490347486.2766.17.camel@sipsolutions.net>
         <20170324174542.GH3637@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Yes.  CPU2 has a pre-existing reader that CPU1's synchronize_srcu()
> must wait for.  But CPU2's reader cannot end until CPU1 releases
> its lock, which it cannot do until after CPU2's reader ends.  Thus,
> as you say, deadlock.
> 
> The rule is that if you are within any kind of RCU read-side critical
> section, you cannot directly or indirectly wait for a grace period
> from that same RCU flavor.

Right. This is indirect then, in a way.

> There are some challenges, though.  This is OK:
> 
>	CPU1				CPU2
>	i = srcu_read_lock(&mysrcu);	mutex_lock(&my_lock);
>	mutex_lock(&my_lock);		i = srcu_read_lock(&mysrcu);
>	srcu_read_unlock(&mysrcu, i);	mutex_unlock(&my_lock);
>	mutex_unlock(&my_lock);		srcu_read_unlock(&mysrcu, i);
> 
> 	CPU3
> 	synchronize_srcu(&mylock);
> 
> This could be a deadlock for reader-writer locking, but not for SRCU.

Hmm, yes, that's a good point. If srcu_read_lock() was read_lock, and
synchronize_srcu() was write_lock(), then the write_lock() could stop
CPU2's read_lock() from acquiring the lock, and thus cause a deadlock.

However, I'm not convinced that lockdep handles reader/writer locks
correctly to start with, right now, since it *didn't* actually trigger
any warnings when I annotated SRCU as a reader/writer lock.

> This is also OK:
>	CPU1				CPU2
>	i = srcu_read_lock(&mysrcu);	mutex_lock(&my_lock);
>	mutex_lock(&my_lock);		synchronize_srcu(&yoursrc
u);
>	srcu_read_unlock(&mysrcu, i);	mutex_unlock(&my_lock);
>	mutex_unlock(&my_lock);
> 
> Here CPU1's read-side critical sections are for mysrcu, which is
> independent of CPU2's grace period for yoursrcu.

Right, but that's already covered by having separate a lockdep_map for
each SRCU subsystem (mysrcu, yoursrcu).

> So you could flag any lockdep cycle that contained a reader and a
> synchronous grace period for the same flavor of RCU, where for SRCU
> the identity of the srcu_struct structure is part of the flavor.

Right. Basically, I think SRCU should be like a reader/writer lock
(perhaps fixed to work right). The only difference seems to be the
scenario you outlined above (first of the two)?

Actually, given the scenario above, for lockdep purposes the
reader/writer lock is actually the same as a recursive lock, I guess?

You outlined a scenario in which the reader gets blocked due to a
writer (CPU3 doing a write_lock()) so the reader can still participate
in a deadlock cycle since it can - without any other locks being held
by CPU3 that participate - cause a deadlock between CPU1 and CPU2 here.
For lockdep then, even seeing the CPU1 and CPU2 scenarios should be
sufficient to flag a deadlock (*).

This part then isn't true for SRCU, because there forward progress will
still be made. So for SRCU, the "reader" side really needs to be
connected with a "writer" side to form a deadlock cycle, unlike for a
reader/writer lock.

johannes

(*) technically only after checking that write_lock() is ever used, but
... seems reasonable enough to assume that it will be used, since why
would anyone ever use a reader/writer lock if there are only readers?
That's a no-op.

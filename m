Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966553AbdCXUUj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 16:20:39 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2OKERW7096277
        for <linux-wireless@vger.kernel.org>; Fri, 24 Mar 2017 16:20:38 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29cpevp9k4-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 24 Mar 2017 16:20:37 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Fri, 24 Mar 2017 16:20:36 -0400
Date: Fri, 24 Mar 2017 13:20:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nicolai Stange <nicstange@gmail.com>,
        gregkh <gregkh@linuxfoundation.org>, sharon.dvir@intel.com,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: deadlock in synchronize_srcu() in debugfs?
Reply-To: paulmck@linux.vnet.ibm.com
References: <1490280886.2766.4.camel@sipsolutions.net>
 <1490282991.2766.7.camel@sipsolutions.net>
 <1490345799.2766.15.camel@sipsolutions.net>
 <1490347486.2766.17.camel@sipsolutions.net>
 <20170324174542.GH3637@linux.vnet.ibm.com>
 <1490381507.9586.1.camel@sipsolutions.net>
 <20170324193322.GL3637@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20170324193322.GL3637@linux.vnet.ibm.com>
Message-Id: <20170324202033.GA24098@linux.vnet.ibm.com> (sfid-20170324_212215_531200_705E6CD6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 24, 2017 at 12:33:22PM -0700, Paul E. McKenney wrote:
> On Fri, Mar 24, 2017 at 07:51:47PM +0100, Johannes Berg wrote:
> > 
> > > Yes.  CPU2 has a pre-existing reader that CPU1's synchronize_srcu()
> > > must wait for.  But CPU2's reader cannot end until CPU1 releases
> > > its lock, which it cannot do until after CPU2's reader ends.  Thus,
> > > as you say, deadlock.
> > > 
> > > The rule is that if you are within any kind of RCU read-side critical
> > > section, you cannot directly or indirectly wait for a grace period
> > > from that same RCU flavor.
> > 
> > Right. This is indirect then, in a way.
> 
> Agreed, in a way.  ;-)
> 
> > > There are some challenges, though.  This is OK:
> > > 
> > >	CPU1				CPU2
> > >	i = srcu_read_lock(&mysrcu);	mutex_lock(&my_lock);
> > >	mutex_lock(&my_lock);		i = srcu_read_lock(&mysrcu);
> > >	srcu_read_unlock(&mysrcu, i);	mutex_unlock(&my_lock);
> > >	mutex_unlock(&my_lock);		srcu_read_unlock(&mysrcu, i);
> > > 
> > > 	CPU3
> > > 	synchronize_srcu(&mylock);
> > > 
> > > This could be a deadlock for reader-writer locking, but not for SRCU.
> > 
> > Hmm, yes, that's a good point. If srcu_read_lock() was read_lock, and
> > synchronize_srcu() was write_lock(), then the write_lock() could stop
> > CPU2's read_lock() from acquiring the lock, and thus cause a deadlock.
> 
> Yes.
> 
> > However, I'm not convinced that lockdep handles reader/writer locks
> > correctly to start with, right now, since it *didn't* actually trigger
> > any warnings when I annotated SRCU as a reader/writer lock.
> 
> I haven't looked into lockdep enough to know either way.
> 
> > > This is also OK:
> > >	CPU1				CPU2
> > >	i = srcu_read_lock(&mysrcu);	mutex_lock(&my_lock);
> > >	mutex_lock(&my_lock);		synchronize_srcu(&yoursrc
> > u);
> > >	srcu_read_unlock(&mysrcu, i);	mutex_unlock(&my_lock);
> > >	mutex_unlock(&my_lock);
> > > 
> > > Here CPU1's read-side critical sections are for mysrcu, which is
> > > independent of CPU2's grace period for yoursrcu.
> > 
> > Right, but that's already covered by having separate a lockdep_map for
> > each SRCU subsystem (mysrcu, yoursrcu).
> 
> I hope so, but haven't proved that this would work in all possible cases.
> 
> > > So you could flag any lockdep cycle that contained a reader and a
> > > synchronous grace period for the same flavor of RCU, where for SRCU
> > > the identity of the srcu_struct structure is part of the flavor.
> > 
> > Right. Basically, I think SRCU should be like a reader/writer lock
> > (perhaps fixed to work right). The only difference seems to be the
> > scenario you outlined above (first of the two)?
> > 
> > Actually, given the scenario above, for lockdep purposes the
> > reader/writer lock is actually the same as a recursive lock, I guess?
> 
> Except that a recursive reader/writer lock can still have deadlocks
> involving the outermost reader that would not be deadlocks for the
> equivalent SRCU scenarios.
> 
> > You outlined a scenario in which the reader gets blocked due to a
> > writer (CPU3 doing a write_lock()) so the reader can still participate
> > in a deadlock cycle since it can - without any other locks being held
> > by CPU3 that participate - cause a deadlock between CPU1 and CPU2 here.
> > For lockdep then, even seeing the CPU1 and CPU2 scenarios should be
> > sufficient to flag a deadlock (*).
> 
> Might this be one of the reasons why lockdep has problems with
> reader-writer locks?
> 
> > This part then isn't true for SRCU, because there forward progress will
> > still be made. So for SRCU, the "reader" side really needs to be
> > connected with a "writer" side to form a deadlock cycle, unlike for a
> > reader/writer lock.
> 
> Yes, for SRCU, srcu_read_lock() itself never blocks, so it never
> participates directly in a deadlock cycle.  It has to be the case
> that something within the SRCU read-side critical section blocks
> and takes its place in the deadlock cycle.
> 
> Then again, if you didn't have something blocking within your SRCU
> read-side critical section, why would you be using SRCU instead of
> just plain RCU?  ;-)
> 
> > johannes
> > 
> > (*) technically only after checking that write_lock() is ever used, but
> > ... seems reasonable enough to assume that it will be used, since why
> > would anyone ever use a reader/writer lock if there are only readers?
> > That's a no-op.
> 
> Makes sense to me!  The only reasons I can come up with are things like
> shutting lockdep up when it wants a given lock read-held or some such.

And I cannot resist adding this one:

	CPU 1				CPU 2
	i = srcu_read_lock(&s1);	mutex_lock(&l1);
	mutex_lock(&l1);		synchronize_srcu(&s2);
	mutex_unlock(&l1);		mutex_unlock(&l1);
	srcu_read_unlock(&s1, i);

	CPU 3				CPU 4
	i = srcu_read_lock(&s2);	mutex_lock(&l2);
	mutex_lock(&l2);		synchronize_srcu(&s1);
	mutex_unlock(&l2);		mutex_unlock(&l2);
	srcu_read_unlock(&s2, i);

Removing the SRCU statements from any of these CPU would break the
deadlock.  This can be easily extended to a deadlock cycle involving
any number of srcu_struct structures.

But this would still be a cycle involving an srcu_read_lock() and a
synchronize_srcu() on the same srcu_struct, which is reassuring.

							Thanx, Paul

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50923 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932510AbdCXRqD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 13:46:03 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2OHiLS0104243
        for <linux-wireless@vger.kernel.org>; Fri, 24 Mar 2017 13:45:47 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29cwbueur0-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 24 Mar 2017 13:45:47 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Fri, 24 Mar 2017 13:45:46 -0400
Date: Fri, 24 Mar 2017 10:45:42 -0700
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1490347486.2766.17.camel@sipsolutions.net>
Message-Id: <20170324174542.GH3637@linux.vnet.ibm.com> (sfid-20170324_184705_952899_80B4BB2B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 24, 2017 at 10:24:46AM +0100, Johannes Berg wrote:
> Hi,
> 
> On Fri, 2017-03-24 at 09:56 +0100, Johannes Berg wrote:
> > On Thu, 2017-03-23 at 16:29 +0100, Johannes Berg wrote:
> > > Isn't it possible for the following to happen?
> > > 
> > > CPU1					CPU2
> > > 
> > > mutex_lock(&M); // acquires mutex
> > > 					full_proxy_xyz();
> > > 					srcu_read_lock(&debugfs_srcu);
> > > 					real_fops->xyz();
> > > 					mutex_lock(&M); // waiting for mutex
> > > debugfs_remove(F);
> > > synchronize_srcu(&debugfs_srcu);
> 
> > So I'm pretty sure that this can happen. I'm not convinced that it's
> > happening here, but still.
> 
> I'm a bit confused, in that SRCU, of course, doesn't wait until all the
> readers are done - that'd be a regular reader/writer lock or something.

Agreed, synchronize_srcu()  does not have to wait for new readers
(as a reader/writer lock would), but it -does- have have to wait for
pre-existing readers, like the one shown in your example above.

> However, it does (have to) wait until all the currently active read-
> side sections have terminated, which still leads to a deadlock in the
> example above, I think?

Yes.  CPU2 has a pre-existing reader that CPU1's synchronize_srcu()
must wait for.  But CPU2's reader cannot end until CPU1 releases
its lock, which it cannot do until after CPU2's reader ends.  Thus,
as you say, deadlock.

The rule is that if you are within any kind of RCU read-side critical
section, you cannot directly or indirectly wait for a grace period from
that same RCU flavor.

> In his 2006 LWN article Paul wrote:
> 
>     The designer of a given subsystem is responsible for: (1) ensuring
>     that SRCU read-side sleeping is bounded and (2) limiting the amount
>     of memory waiting for synchronize_srcu(). [1]
> 
> In the case of debugfs files acquiring locks, (1) can't really be
> guaranteed, especially if those locks can be held while doing
> synchronize_srcu() [via debugfs_remove], so I still think the lockdep
> annotation needs to be changed to at least have some annotation at
> synchronize_srcu() time so we can detect this.

That would be very nice!

There are some challenges, though.  This is OK:

	CPU1				CPU2
	i = srcu_read_lock(&mysrcu);	mutex_lock(&my_lock);
	mutex_lock(&my_lock);		i = srcu_read_lock(&mysrcu);
	srcu_read_unlock(&mysrcu, i);	mutex_unlock(&my_lock);
	mutex_unlock(&my_lock);		srcu_read_unlock(&mysrcu, i);

	CPU3
	synchronize_srcu(&mylock);

This could be a deadlock for reader-writer locking, but not for SRCU.

This is also OK:

	CPU1				CPU2
	i = srcu_read_lock(&mysrcu);	mutex_lock(&my_lock);
	mutex_lock(&my_lock);		synchronize_srcu(&yoursrcu);
	srcu_read_unlock(&mysrcu, i);	mutex_unlock(&my_lock);
	mutex_unlock(&my_lock);

Here CPU1's read-side critical sections are for mysrcu, which is
independent of CPU2's grace period for yoursrcu.

So you could flag any lockdep cycle that contained a reader and a
synchronous grace period for the same flavor of RCU, where for SRCU the
identity of the srcu_struct structure is part of the flavor.

> Now, I still suspect there's some other bug here in the case that I'm
> seeing, because I don't actually see the "mutex_lock(&M); // waiting"
> piece in the traces. I'll need to run this with some tracing on Monday
> when the test guys are back from the weekend.
> 
> I'm also not sure how I can possibly fix this in debugfs in mac80211
> and friends, but that's perhaps a different story. Clearly, this
> debugfs patch is a good thing - the code will likely have had use-
> after-free problems in this situation without it. But flagging the
> potential deadlocks would make it a lot easier to find them.

No argument here!

							Thanx, Paul

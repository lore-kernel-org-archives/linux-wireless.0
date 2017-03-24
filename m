Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51180 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933871AbdCXI4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 04:56:53 -0400
Message-ID: <1490345799.2766.15.camel@sipsolutions.net> (sfid-20170324_095735_250772_5410B86A)
Subject: Re: deadlock in synchronize_srcu() in debugfs?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Nicolai Stange <nicstange@gmail.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        gregkh <gregkh@linuxfoundation.org>, sharon.dvir@intel.com,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 24 Mar 2017 09:56:39 +0100
In-Reply-To: <1490282991.2766.7.camel@sipsolutions.net>
References: <1490280886.2766.4.camel@sipsolutions.net>
         <1490282991.2766.7.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-03-23 at 16:29 +0100, Johannes Berg wrote:
> Isn't it possible for the following to happen?
> 
> CPU1					CPU2
> 
> mutex_lock(&M);
> 					full_proxy_xyz();
> 					srcu_read_lock(&debugfs_srcu);
> 					real_fops->xyz();
> 					mutex_lock(&M);
> debugfs_remove(F);
> synchronize_srcu(&debugfs_srcu);


So I'm pretty sure that this can happen. I'm not convinced that it's
happening here, but still.

I tried to make lockdep flag it, but the only way I could get it to
flag it was to do this:

--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -235,7 +235,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 	preempt_disable();
 	retval = __srcu_read_lock(sp);
 	preempt_enable();
-	rcu_lock_acquire(&(sp)->dep_map);
+	lock_map_acquire(&(sp)->dep_map);
 	return retval;
 }
 
@@ -249,7 +249,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__releases(sp)
 {
-	rcu_lock_release(&(sp)->dep_map);
+	lock_map_release(&(sp)->dep_map);
 	__srcu_read_unlock(sp, idx);
 }
 
diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index ef3bcfb15b39..0f9e542ca3f2 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -395,6 +395,9 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
 			 lock_is_held(&rcu_sched_lock_map),
 			 "Illegal synchronize_srcu() in same-type SRCU (or in RCU) read-side critical section");
 
+	lock_map_acquire(&sp->dep_map);
+	lock_map_release(&sp->dep_map);
+
 	might_sleep();
 	init_completion(&rcu.completion);
 

The lock_map_acquire() in srcu_read_lock() is really not desired
though, since it will make recursion get flagged as bad. If I change
that to lock_map_acquire_read() though, the problem doesn't get flagged
for some reason. I thought it should.


Regardless though, I don't see a way to solve this problem for debugfs.
We have a ton of debugfs files in net/mac80211/debugfs.c that need to
acquire e.g. the RTNL (or other locks), and I'm not sure we can easily
avoid removing the debugfs files under the RTNL, since we get all our
configuration callbacks with the RTNL already held...

Need to think about that, but perhaps there's some other solution?

johannes

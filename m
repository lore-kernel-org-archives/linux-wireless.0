Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51420 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965271AbdCXJZC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 05:25:02 -0400
Message-ID: <1490347486.2766.17.camel@sipsolutions.net> (sfid-20170324_102601_255673_5A8211D2)
Subject: Re: deadlock in synchronize_srcu() in debugfs?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Nicolai Stange <nicstange@gmail.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        gregkh <gregkh@linuxfoundation.org>, sharon.dvir@intel.com,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 24 Mar 2017 10:24:46 +0100
In-Reply-To: <1490345799.2766.15.camel@sipsolutions.net>
References: <1490280886.2766.4.camel@sipsolutions.net>
         <1490282991.2766.7.camel@sipsolutions.net>
         <1490345799.2766.15.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, 2017-03-24 at 09:56 +0100, Johannes Berg wrote:
> On Thu, 2017-03-23 at 16:29 +0100, Johannes Berg wrote:
> > Isn't it possible for the following to happen?
> > 
> > CPU1					CPU2
> > 
> > mutex_lock(&M); // acquires mutex
> > 					full_proxy_xyz();
> > 					srcu_read_lock(&debugfs_srcu);
> > 					real_fops->xyz();
> > 					mutex_lock(&M); // waiting for mutex
> > debugfs_remove(F);
> > synchronize_srcu(&debugfs_srcu);

> So I'm pretty sure that this can happen. I'm not convinced that it's
> happening here, but still.

I'm a bit confused, in that SRCU, of course, doesn't wait until all the
readers are done - that'd be a regular reader/writer lock or something.

However, it does (have to) wait until all the currently active read-
side sections have terminated, which still leads to a deadlock in the
example above, I think?

In his 2006 LWN article Paul wrote:

    The designer of a given subsystem is responsible for: (1) ensuring
    that SRCU read-side sleeping is bounded and (2) limiting the amount
    of memory waiting for synchronize_srcu(). [1]

In the case of debugfs files acquiring locks, (1) can't really be
guaranteed, especially if those locks can be held while doing
synchronize_srcu() [via debugfs_remove], so I still think the lockdep
annotation needs to be changed to at least have some annotation at
synchronize_srcu() time so we can detect this.

Now, I still suspect there's some other bug here in the case that I'm
seeing, because I don't actually see the "mutex_lock(&M); // waiting"
piece in the traces. I'll need to run this with some tracing on Monday
when the test guys are back from the weekend.

I'm also not sure how I can possibly fix this in debugfs in mac80211
and friends, but that's perhaps a different story. Clearly, this
debugfs patch is a good thing - the code will likely have had use-
after-free problems in this situation without it. But flagging the
potential deadlocks would make it a lot easier to find them.

johannes

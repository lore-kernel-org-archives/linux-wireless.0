Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46440 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751821AbdC0LSf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Mar 2017 07:18:35 -0400
Message-ID: <1490613502.3393.2.camel@sipsolutions.net> (sfid-20170327_131930_605582_01B720C7)
Subject: Re: deadlock in synchronize_srcu() in debugfs?
From: Johannes Berg <johannes@sipsolutions.net>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nicolai Stange <nicstange@gmail.com>,
        gregkh <gregkh@linuxfoundation.org>, sharon.dvir@intel.com,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 27 Mar 2017 13:18:22 +0200
In-Reply-To: <20170324202033.GA24098@linux.vnet.ibm.com>
References: <1490280886.2766.4.camel@sipsolutions.net>
         <1490282991.2766.7.camel@sipsolutions.net>
         <1490345799.2766.15.camel@sipsolutions.net>
         <1490347486.2766.17.camel@sipsolutions.net>
         <20170324174542.GH3637@linux.vnet.ibm.com>
         <1490381507.9586.1.camel@sipsolutions.net>
         <20170324193322.GL3637@linux.vnet.ibm.com>
         <20170324202033.GA24098@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-24 at 13:20 -0700, Paul E. McKenney wrote:
> 
> And I cannot resist adding this one:
> 
> 	CPU 1				CPU 2
> 	i = srcu_read_lock(&s1);	mutex_lock(&l1);
> 	mutex_lock(&l1);		synchronize_srcu(&s2);
> 	mutex_unlock(&l1);		mutex_unlock(&l1);
> 	srcu_read_unlock(&s1, i);
> 
> 	CPU 3				CPU 4
> 	i = srcu_read_lock(&s2);	mutex_lock(&l2);
> 	mutex_lock(&l2);		synchronize_srcu(&s1);
> 	mutex_unlock(&l2);		mutex_unlock(&l2);
> 	srcu_read_unlock(&s2, i);
> 
> Removing the SRCU statements from any of these CPU would break the
> deadlock.  This can be easily extended to a deadlock cycle involving
> any number of srcu_struct structures.
> 
> But this would still be a cycle involving an srcu_read_lock() and a
> synchronize_srcu() on the same srcu_struct, which is reassuring.

Right, you can cycle this indefinitely. lockdep has some kind of
maximum chain length I think. :)

johannes

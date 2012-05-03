Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:33955 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab2ECSXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 14:23:52 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
	Thu, 3 May 2012 12:23:47 -0600
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id D905CC90050
	for <linux-wireless@vger.kernel.org>; Thu,  3 May 2012 14:22:47 -0400 (EDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q43IMmxa19005662
	for <linux-wireless@vger.kernel.org>; Thu, 3 May 2012 14:22:48 -0400
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q43IMVaI002575
	for <linux-wireless@vger.kernel.org>; Thu, 3 May 2012 12:22:38 -0600
Date: Thu, 3 May 2012 11:22:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Suspicious RCU usage in mac80211
Message-ID: <20120503182231.GL2592@linux.vnet.ibm.com> (sfid-20120503_202356_227111_AB7BB832)
Reply-To: paulmck@linux.vnet.ibm.com
References: <1334246145.4062.0.camel@jlt3.sipsolutions.net>
 <CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com>
 <4FA0371E.9040704@lwfinger.net>
 <20120502100012.GA8492@arm.com>
 <1335978471.4295.3.camel@jlt3.sipsolutions.net>
 <4FA1F534.8040601@lwfinger.net>
 <20120503084701.GA27872@arm.com>
 <4FA2B845.2000502@lwfinger.net>
 <20120503171209.GH2592@linux.vnet.ibm.com>
 <4FA2C45A.3010001@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FA2C45A.3010001@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 03, 2012 at 12:46:02PM -0500, Larry Finger wrote:
> On 05/03/2012 12:12 PM, Paul E. McKenney wrote:
> >On Thu, May 03, 2012 at 11:54:29AM -0500, Larry Finger wrote:
> >>On 05/03/2012 03:47 AM, Catalin Marinas wrote:
> >>>
> >>>IIUC, Paul suggested that you should use rcu_dereference_check() here
> >>>instead as the protected one is not safe in this context.
> >>
> >>This patch also fails to fix the problem. Did I do what Paul suggested?
> >
> >That is indeed what I suggested!
> >
> >What locks does lockdep say are held?
> 
> It varies from instance to instance. I have seen 1, 2, or 3. Those
> are the following:
> 
> #0:  (scan_mutex){+.+...}, at: [<ffffffff8113b0d6>] kmemleak_scan_thread+0x56/0xd0
> #1:  (&tid_tx->session_timer){+.-...}, at: [<ffffffff8104853a>]
> run_timer_softirq+0xfa/0x6e0
> #2:  (rcu_read_lock){.+.+..}, at: [<ffffffffa03c1ff0>]
> sta_tx_agg_session_timer_expired+0x0/0x2a0 [mac80211]
> 
> 
> When only 1 lock is held, it is "&tid_tx->session_timer", and that
> one is held in every case. I think that means we need to OR it with
> the other lockdep_is_held() arguments in the rcu_dereference_xxxxx()
> call, but I did not seem to get the syntax right.

If any one of several locks (call them a, b, and c) is sufficient to
protect the data, and if an rcu_read_lock() also suffices, then something
like the following would work:

	return rcu_dereference_check(sta->ampdu_mlme.tid_tx[tid],
				     lockdep_is_held(&a) ||
				     lockdep_is_held(&b) ||
				     lockdep_is_held(&c));

But I must defer to the developers and maintainers of that code
as to exactly which combinations of locks and RCU are required.
The rcu_read_lock_held() is supplied by rcu_dereference_check(), so I
am surprised that you got a splat that included rcu_read_lock.

							Thanx, Paul


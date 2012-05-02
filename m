Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:44469 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378Ab2EBUL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 16:11:27 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
	Wed, 2 May 2012 14:11:25 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id AA1B43E4006F
	for <linux-wireless@vger.kernel.org>; Wed,  2 May 2012 14:10:14 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q42KA1h7124324
	for <linux-wireless@vger.kernel.org>; Wed, 2 May 2012 14:10:02 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q42K9vO0023779
	for <linux-wireless@vger.kernel.org>; Wed, 2 May 2012 14:10:00 -0600
Date: Wed, 2 May 2012 13:09:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Suspicious RCU usage in mac80211
Message-ID: <20120502200955.GI2450@linux.vnet.ibm.com> (sfid-20120502_221134_129913_2C84C133)
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F83A6DE.7070109@lwfinger.net>
 <1334201497.3788.1.camel@jlt3.sipsolutions.net>
 <4F865155.2000202@lwfinger.net>
 <1334202842.3788.10.camel@jlt3.sipsolutions.net>
 <4F86FA05.5080404@lwfinger.net>
 <1334246145.4062.0.camel@jlt3.sipsolutions.net>
 <CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com>
 <4FA0371E.9040704@lwfinger.net>
 <20120502100012.GA8492@arm.com>
 <1335978471.4295.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1335978471.4295.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 02, 2012 at 07:07:51PM +0200, Johannes Berg wrote:
> On Wed, 2012-05-02 at 11:00 +0100, Catalin Marinas wrote:
> 
> > > Your patch does not help. I still get the following dump in the log:
> 
> The patch is also wrong, we hold the mutex there and can't hold RCU read
> lock.
> 
> > > #0:  (scan_mutex){+.+...}, at: [<ffffffff8113b0d6>] kmemleak_scan_thread+0x56/0xd0
> > > #1:  (&tid_tx->session_timer){+.-...}, at: [<ffffffff8104853a>] 
> > > run_timer_softirq+0xfa/0x6e0
> > > #2:  (rcu_read_lock){.+.+..}, at: [<ffffffffa0449ff0>] 
> > > sta_tx_agg_session_timer_expired+0x0/0x2a0 [mac80211]
> > > 
> > > stack backtrace:
> > > Pid: 622, comm: kmemleak Not tainted 3.4.0-rc5-wl+ #287
> > > Call Trace:
> > >   <IRQ>  [<ffffffff8109309d>] lockdep_rcu_suspicious+0xfd/0x130
> > >   [<ffffffffa044a1cf>] sta_tx_agg_session_timer_expired+0x1df/0x2a0 [mac80211]
> > >   [<ffffffffa0449ff0>] ? ieee80211_start_tx_ba_session+0x450/0x450 [mac80211]
> > >   [<ffffffff810485c5>] run_timer_softirq+0x185/0x6e0
> > > 
> > > As kmemleak seems to be involved, I have added Catalin Marinas to the Cc list.
> 
> > Looking at the code and the logs, ieee80211_start_tx_ba_session() calls
> 
> I'm almost certain that ieee80211_start_tx_ba_session() is a bogus
> calltrace entry, since we're in a timer and that's not called from a
> timer.
> 
> > rcu_dereference_protected_tid_tx() which calls
> > rcu_dereference_protected() with the (lockdep_is_held(&sta->lock) ||
> > lockdep_is_held(&sta->ampdu_mlme.mtx)) condition which is false. As the
> > kernel log says, none of these locks are held, hence the warning.
> 
> So does that just mean we need to add rcu_read_lock_held() to the
> conditions? I thought that wasn't necessary? +Paul.

If you are using rcu_dereference_protected(), you really would need
to add rcu_read_lock_held().  Except that it is not legal to use
rcu_dereference_protected() within an RCU read-side critical section
because rcu_dereference_protected() does nothing to protect against
misordering mischief from the compiler and the CPU.  Actually, that
sounds like a useful coccinelle check, now that you mention it.

So you should instead use rcu_dereference_check().  This may be used
in an RCU read-side critical section, but may also be passed things like
(lockdep_is_held(&sta->lock) || lockdep_is_held(&sta->ampdu_mlme.mtx)).

							Thanx, Paul


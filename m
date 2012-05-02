Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2EBRH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 13:07:57 -0400
Message-ID: <1335978471.4295.3.camel@jlt3.sipsolutions.net> (sfid-20120502_190800_721376_97566DBA)
Subject: Re: Suspicious RCU usage in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 02 May 2012 19:07:51 +0200
In-Reply-To: <20120502100012.GA8492@arm.com>
References: <4F83A6DE.7070109@lwfinger.net>
	 <1334201497.3788.1.camel@jlt3.sipsolutions.net>
	 <4F865155.2000202@lwfinger.net>
	 <1334202842.3788.10.camel@jlt3.sipsolutions.net>
	 <4F86FA05.5080404@lwfinger.net>
	 <1334246145.4062.0.camel@jlt3.sipsolutions.net>
	 <CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com>
	 <4FA0371E.9040704@lwfinger.net> <20120502100012.GA8492@arm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-02 at 11:00 +0100, Catalin Marinas wrote:

> > Your patch does not help. I still get the following dump in the log:

The patch is also wrong, we hold the mutex there and can't hold RCU read
lock.

> > #0:  (scan_mutex){+.+...}, at: [<ffffffff8113b0d6>] kmemleak_scan_thread+0x56/0xd0
> > #1:  (&tid_tx->session_timer){+.-...}, at: [<ffffffff8104853a>] 
> > run_timer_softirq+0xfa/0x6e0
> > #2:  (rcu_read_lock){.+.+..}, at: [<ffffffffa0449ff0>] 
> > sta_tx_agg_session_timer_expired+0x0/0x2a0 [mac80211]
> > 
> > stack backtrace:
> > Pid: 622, comm: kmemleak Not tainted 3.4.0-rc5-wl+ #287
> > Call Trace:
> >   <IRQ>  [<ffffffff8109309d>] lockdep_rcu_suspicious+0xfd/0x130
> >   [<ffffffffa044a1cf>] sta_tx_agg_session_timer_expired+0x1df/0x2a0 [mac80211]
> >   [<ffffffffa0449ff0>] ? ieee80211_start_tx_ba_session+0x450/0x450 [mac80211]
> >   [<ffffffff810485c5>] run_timer_softirq+0x185/0x6e0
> > 
> > As kmemleak seems to be involved, I have added Catalin Marinas to the Cc list.

> Looking at the code and the logs, ieee80211_start_tx_ba_session() calls

I'm almost certain that ieee80211_start_tx_ba_session() is a bogus
calltrace entry, since we're in a timer and that's not called from a
timer.

> rcu_dereference_protected_tid_tx() which calls
> rcu_dereference_protected() with the (lockdep_is_held(&sta->lock) ||
> lockdep_is_held(&sta->ampdu_mlme.mtx)) condition which is false. As the
> kernel log says, none of these locks are held, hence the warning.

So does that just mean we need to add rcu_read_lock_held() to the
conditions? I thought that wasn't necessary? +Paul.

johannes


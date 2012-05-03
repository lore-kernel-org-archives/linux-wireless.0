Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40843 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753726Ab2ECIr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 04:47:26 -0400
Date: Thu, 3 May 2012 09:47:02 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Suspicious RCU usage in mac80211
Message-ID: <20120503084701.GA27872@arm.com> (sfid-20120503_104732_049935_8E551D9C)
References: <1334201497.3788.1.camel@jlt3.sipsolutions.net>
 <4F865155.2000202@lwfinger.net>
 <1334202842.3788.10.camel@jlt3.sipsolutions.net>
 <4F86FA05.5080404@lwfinger.net>
 <1334246145.4062.0.camel@jlt3.sipsolutions.net>
 <CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com>
 <4FA0371E.9040704@lwfinger.net>
 <20120502100012.GA8492@arm.com>
 <1335978471.4295.3.camel@jlt3.sipsolutions.net>
 <4FA1F534.8040601@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FA1F534.8040601@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 03, 2012 at 04:02:12AM +0100, Larry Finger wrote:
> On 05/02/2012 12:07 PM, Johannes Berg wrote:
> > On Wed, 2012-05-02 at 11:00 +0100, Catalin Marinas wrote:
> >
> >>> Your patch does not help. I still get the following dump in the log:
> >
> > The patch is also wrong, we hold the mutex there and can't hold RCU read
> > lock.
> >
> >>> #0:  (scan_mutex){+.+...}, at: [<ffffffff8113b0d6>] kmemleak_scan_thread+0x56/0xd0
> >>> #1:  (&tid_tx->session_timer){+.-...}, at: [<ffffffff8104853a>]
> >>> run_timer_softirq+0xfa/0x6e0
> >>> #2:  (rcu_read_lock){.+.+..}, at: [<ffffffffa0449ff0>]
> >>> sta_tx_agg_session_timer_expired+0x0/0x2a0 [mac80211]
> >>>
> >>> stack backtrace:
> >>> Pid: 622, comm: kmemleak Not tainted 3.4.0-rc5-wl+ #287
> >>> Call Trace:
> >>>    <IRQ>   [<ffffffff8109309d>] lockdep_rcu_suspicious+0xfd/0x130
> >>>    [<ffffffffa044a1cf>] sta_tx_agg_session_timer_expired+0x1df/0x2a0 [mac80211]
> >>>    [<ffffffffa0449ff0>] ? ieee80211_start_tx_ba_session+0x450/0x450 [mac80211]
> >>>    [<ffffffff810485c5>] run_timer_softirq+0x185/0x6e0
> >>>
> >>> As kmemleak seems to be involved, I have added Catalin Marinas to the Cc list.
> >
> >> Looking at the code and the logs, ieee80211_start_tx_ba_session() calls
> >
> > I'm almost certain that ieee80211_start_tx_ba_session() is a bogus
> > calltrace entry, since we're in a timer and that's not called from a
> > timer.
> >
> >> rcu_dereference_protected_tid_tx() which calls
> >> rcu_dereference_protected() with the (lockdep_is_held(&sta->lock) ||
> >> lockdep_is_held(&sta->ampdu_mlme.mtx)) condition which is false. As the
> >> kernel log says, none of these locks are held, hence the warning.
> >
> > So does that just mean we need to add rcu_read_lock_held() to the
> > conditions? I thought that wasn't necessary? +Paul.
> 
> If you meant the following
> 
> Index: wireless-testing-new/net/mac80211/sta_info.h
> ===================================================================
> --- wireless-testing-new.orig/net/mac80211/sta_info.h
> +++ wireless-testing-new/net/mac80211/sta_info.h
> @@ -453,7 +453,8 @@ rcu_dereference_protected_tid_tx(struct
>   {
>          return rcu_dereference_protected(sta->ampdu_mlme.tid_tx[tid],

IIUC, Paul suggested that you should use rcu_dereference_check() here
instead as the protected one is not safe in this context.

-- 
Catalin

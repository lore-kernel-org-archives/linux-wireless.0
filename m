Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46448 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308Ab2EBKAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 06:00:31 -0400
Date: Wed, 2 May 2012 11:00:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Suspicious RCU usage in mac80211
Message-ID: <20120502100012.GA8492@arm.com> (sfid-20120502_120034_941435_EA7D29B4)
References: <4F83A6DE.7070109@lwfinger.net>
 <1334201497.3788.1.camel@jlt3.sipsolutions.net>
 <4F865155.2000202@lwfinger.net>
 <1334202842.3788.10.camel@jlt3.sipsolutions.net>
 <4F86FA05.5080404@lwfinger.net>
 <1334246145.4062.0.camel@jlt3.sipsolutions.net>
 <CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com>
 <4FA0371E.9040704@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FA0371E.9040704@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 01, 2012 at 08:18:54PM +0100, Larry Finger wrote:
> On 05/01/2012 09:25 AM, Mohammed Shafi wrote:
> > i just looked into the code and compared it with
> > sta_addba_resp_timer_expired and thought whether we should do
> > this..
> 
> Your patch does not help. I still get the following dump in the log:
> 
> ===============================
> [ INFO: suspicious RCU usage. ]
> 3.4.0-rc5-wl+ #287 Not tainted
> -------------------------------
> net/mac80211/sta_info.h:456 suspicious rcu_dereference_protected() usage!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 1, debug_locks = 0
> 3 locks held by kmemleak/622:
> #0:  (scan_mutex){+.+...}, at: [<ffffffff8113b0d6>] kmemleak_scan_thread+0x56/0xd0
> #1:  (&tid_tx->session_timer){+.-...}, at: [<ffffffff8104853a>] 
> run_timer_softirq+0xfa/0x6e0
> #2:  (rcu_read_lock){.+.+..}, at: [<ffffffffa0449ff0>] 
> sta_tx_agg_session_timer_expired+0x0/0x2a0 [mac80211]
> 
> stack backtrace:
> Pid: 622, comm: kmemleak Not tainted 3.4.0-rc5-wl+ #287
> Call Trace:
>   <IRQ>  [<ffffffff8109309d>] lockdep_rcu_suspicious+0xfd/0x130
>   [<ffffffffa044a1cf>] sta_tx_agg_session_timer_expired+0x1df/0x2a0 [mac80211]
>   [<ffffffffa0449ff0>] ? ieee80211_start_tx_ba_session+0x450/0x450 [mac80211]
>   [<ffffffff810485c5>] run_timer_softirq+0x185/0x6e0
> 
> As kmemleak seems to be involved, I have added Catalin Marinas to the Cc list.

It doesn't look related to kmemleak. It just happens that
sta_tx_agg_session_timer_expired() was called from a timer when the
kmemleak scanning thread was running (pretty likely as this thread can
take minutes to complete).

Looking at the code and the logs, ieee80211_start_tx_ba_session() calls
rcu_dereference_protected_tid_tx() which calls
rcu_dereference_protected() with the (lockdep_is_held(&sta->lock) ||
lockdep_is_held(&sta->ampdu_mlme.mtx)) condition which is false. As the
kernel log says, none of these locks are held, hence the warning.

Either the rcu_dereference annotation is wrong (introduced by commit
40b275 "mac80211: sparse RCU annotations") or there is something wrong
in the code and the RCU pointer is dereferenced without any of those
locks held.

-- 
Catalin

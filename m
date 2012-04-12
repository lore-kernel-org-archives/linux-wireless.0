Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56512 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab2DLDvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 23:51:53 -0400
Received: by obbtb18 with SMTP id tb18so2159163obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 20:51:52 -0700 (PDT)
Message-ID: <4F865155.2000202@lwfinger.net> (sfid-20120412_055157_030003_DB4393AB)
Date: Wed, 11 Apr 2012 22:51:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Suspicious RCU usage in mac80211
References: <4F83A6DE.7070109@lwfinger.net>  (sfid-20120410_052034_062782_82AB2FD8) <1334201497.3788.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1334201497.3788.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2012 10:31 PM, Johannes Berg wrote:
> On Mon, 2012-04-09 at 22:19 -0500, Larry Finger wrote:
>> When running kernel 3.4-rc2 from wireless testing, I got the following logged:
>>
>> [ 2299.344437] ===============================
>> [ 2299.344443] [ INFO: suspicious RCU usage. ]
>> [ 2299.344452] 3.4.0-rc2-wl+ #222 Not tainted
>> [ 2299.344458] -------------------------------
>> [ 2299.344466] net/mac80211/sta_info.h:449 suspicious rcu_dereference_protected() usage!
>> [ 2299.344472]
>> [ 2299.344474] other info that might help us debug this:
>> [ 2299.344477]
>> [ 2299.344484]
>> [ 2299.344486] rcu_scheduler_active = 1, debug_locks = 0
>> [ 2299.344493] 1 lock held by swapper/1/0:
>> [ 2299.344499]  #0:  (&tid_tx->session_timer){+.-...}, at: [<ffffffff8104850a>]
>> run_timer_softirq+0xfa/0x6e0
>> [ 2299.344533]
>> [ 2299.344535] stack backtrace:
>> [ 2299.344544] Pid: 0, comm: swapper/1 Not tainted 3.4.0-rc2-wl+ #222
>> [ 2299.344551] Call Trace:
>> [ 2299.344557]<IRQ>   [<ffffffff81092fdd>] lockdep_rcu_suspicious+0xfd/0x130
>> [ 2299.344651]  [<ffffffffa05db673>] sta_tx_agg_session_timer_expired+0xe3/0x100
>> [mac80211]
>
> That's odd:
>
> static inline struct tid_ampdu_tx *
> rcu_dereference_protected_tid_tx(struct sta_info *sta, int tid)
> {
>          return rcu_dereference_protected(sta->ampdu_mlme.tid_tx[tid],
>                                           lockdep_is_held(&sta->lock) ||
>                                           lockdep_is_held(&sta->ampdu_mlme.mtx));
> }
>
> sta_tx_agg_session_timer_expired calls ieee80211_stop_tx_ba_session
> which does:
>
>          spin_lock_bh(&sta->lock);
>          tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
>
>
> So why would the message happen? Strange.

When I first saw the thread at 
http://lkml.indiana.edu/hypermail/linux/kernel/1204.1/01446.html, I thought it 
might be about the same problem, but that appears to be restricted to sparc64.

The problem does not happen every time - even more strangeness.

Larry



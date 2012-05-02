Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51277 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2EBFCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 01:02:07 -0400
Received: by bkcji2 with SMTP id ji2so121371bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 22:02:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA0371E.9040704@lwfinger.net>
References: <4F83A6DE.7070109@lwfinger.net>
	<1334201497.3788.1.camel@jlt3.sipsolutions.net>
	<4F865155.2000202@lwfinger.net>
	<1334202842.3788.10.camel@jlt3.sipsolutions.net>
	<4F86FA05.5080404@lwfinger.net>
	<1334246145.4062.0.camel@jlt3.sipsolutions.net>
	<CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com>
	<4FA0371E.9040704@lwfinger.net>
Date: Wed, 2 May 2012 10:32:05 +0530
Message-ID: <CAD2nsn14nu_N-3zZ5NdOMAJg6m6uPVD_ai0fAORvQqC2JVdPMw@mail.gmail.com> (sfid-20120502_070212_729593_3B4C552A)
Subject: Re: Suspicious RCU usage in mac80211
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 2, 2012 at 12:48 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/01/2012 09:25 AM, Mohammed Shafi wrote:
>>
>>
>> i just looked into the code and compared it with
>> sta_addba_resp_timer_expired and thought whether we should do
>> this..
>
>
> Your patch does not help. I still get the following dump in the log:

Larry, thanks for trying it out. then there seems to be something else, which
requires further debugging/understanding.

>
> ===============================
> [ INFO: suspicious RCU usage. ]
> 3.4.0-rc5-wl+ #287 Not tainted
> -------------------------------
>
> net/mac80211/sta_info.h:456 suspicious rcu_dereference_protected() usage!
>
> other info that might help us debug this:
>
> rcu_scheduler_active = 1, debug_locks = 0
> 3 locks held by kmemleak/622:
> #0:  (scan_mutex){+.+...}, at: [<ffffffff8113b0d6>]
> kmemleak_scan_thread+0x56/0xd0
> #1:  (&tid_tx->session_timer){+.-...}, at: [<ffffffff8104853a>]
> run_timer_softirq+0xfa/0x6e0
> #2:  (rcu_read_lock){.+.+..}, at: [<ffffffffa0449ff0>]
> sta_tx_agg_session_timer_expired+0x0/0x2a0 [mac80211]
>
> stack backtrace:
> Pid: 622, comm: kmemleak Not tainted 3.4.0-rc5-wl+ #287
> Call Trace:
>  <IRQ>  [<ffffffff8109309d>] lockdep_rcu_suspicious+0xfd/0x130
>  [<ffffffffa044a1cf>] sta_tx_agg_session_timer_expired+0x1df/0x2a0
> [mac80211]
>  [<ffffffffa0449ff0>] ? ieee80211_start_tx_ba_session+0x450/0x450 [mac80211]
>  [<ffffffff810485c5>] run_timer_softirq+0x185/0x6e0
>
> As kmemleak seems to be involved, I have added Catalin Marinas to the Cc
> list.
>
> Larry
>
>

-- 
thanks,
shafi

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60310 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab2EATS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 15:18:59 -0400
Received: by ghrr11 with SMTP id r11so2281155ghr.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 12:18:58 -0700 (PDT)
Message-ID: <4FA0371E.9040704@lwfinger.net> (sfid-20120501_211902_675736_B3CDEF17)
Date: Tue, 01 May 2012 14:18:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: Suspicious RCU usage in mac80211
References: <4F83A6DE.7070109@lwfinger.net> <1334201497.3788.1.camel@jlt3.sipsolutions.net> <4F865155.2000202@lwfinger.net> <1334202842.3788.10.camel@jlt3.sipsolutions.net> <4F86FA05.5080404@lwfinger.net> <1334246145.4062.0.camel@jlt3.sipsolutions.net> <CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com>
In-Reply-To: <CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/01/2012 09:25 AM, Mohammed Shafi wrote:
>
> i just looked into the code and compared it with
> sta_addba_resp_timer_expired and thought whether we should do
> this..

Your patch does not help. I still get the following dump in the log:

===============================
[ INFO: suspicious RCU usage. ]
3.4.0-rc5-wl+ #287 Not tainted
-------------------------------
net/mac80211/sta_info.h:456 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 0
3 locks held by kmemleak/622:
#0:  (scan_mutex){+.+...}, at: [<ffffffff8113b0d6>] kmemleak_scan_thread+0x56/0xd0
#1:  (&tid_tx->session_timer){+.-...}, at: [<ffffffff8104853a>] 
run_timer_softirq+0xfa/0x6e0
#2:  (rcu_read_lock){.+.+..}, at: [<ffffffffa0449ff0>] 
sta_tx_agg_session_timer_expired+0x0/0x2a0 [mac80211]

stack backtrace:
Pid: 622, comm: kmemleak Not tainted 3.4.0-rc5-wl+ #287
Call Trace:
  <IRQ>  [<ffffffff8109309d>] lockdep_rcu_suspicious+0xfd/0x130
  [<ffffffffa044a1cf>] sta_tx_agg_session_timer_expired+0x1df/0x2a0 [mac80211]
  [<ffffffffa0449ff0>] ? ieee80211_start_tx_ba_session+0x450/0x450 [mac80211]
  [<ffffffff810485c5>] run_timer_softirq+0x185/0x6e0

As kmemleak seems to be involved, I have added Catalin Marinas to the Cc list.

Larry



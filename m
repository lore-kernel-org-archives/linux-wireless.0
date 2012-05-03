Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61358 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754423Ab2ECScm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 14:32:42 -0400
Received: by ghrr11 with SMTP id r11so2069679ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 11:32:42 -0700 (PDT)
Message-ID: <4FA2CF43.9090803@lwfinger.net> (sfid-20120503_203246_135374_F318C8FF)
Date: Thu, 03 May 2012 13:32:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Catalin Marinas <catalin.marinas@arm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Suspicious RCU usage in mac80211
References: <1334246145.4062.0.camel@jlt3.sipsolutions.net> <CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com> <4FA0371E.9040704@lwfinger.net> <20120502100012.GA8492@arm.com> <1335978471.4295.3.camel@jlt3.sipsolutions.net> <4FA1F534.8040601@lwfinger.net> <20120503084701.GA27872@arm.com> <4FA2B845.2000502@lwfinger.net> <20120503171209.GH2592@linux.vnet.ibm.com> <4FA2C45A.3010001@lwfinger.net> <20120503182231.GL2592@linux.vnet.ibm.com>
In-Reply-To: <20120503182231.GL2592@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2012 01:22 PM, Paul E. McKenney wrote:
> On Thu, May 03, 2012 at 12:46:02PM -0500, Larry Finger wrote:
>> On 05/03/2012 12:12 PM, Paul E. McKenney wrote:
>>> On Thu, May 03, 2012 at 11:54:29AM -0500, Larry Finger wrote:
>>>> On 05/03/2012 03:47 AM, Catalin Marinas wrote:
>>>>>
>>>>> IIUC, Paul suggested that you should use rcu_dereference_check() here
>>>>> instead as the protected one is not safe in this context.
>>>>
>>>> This patch also fails to fix the problem. Did I do what Paul suggested?
>>>
>>> That is indeed what I suggested!
>>>
>>> What locks does lockdep say are held?
>>
>> It varies from instance to instance. I have seen 1, 2, or 3. Those
>> are the following:
>>
>> #0:  (scan_mutex){+.+...}, at: [<ffffffff8113b0d6>] kmemleak_scan_thread+0x56/0xd0
>> #1:  (&tid_tx->session_timer){+.-...}, at: [<ffffffff8104853a>]
>> run_timer_softirq+0xfa/0x6e0
>> #2:  (rcu_read_lock){.+.+..}, at: [<ffffffffa03c1ff0>]
>> sta_tx_agg_session_timer_expired+0x0/0x2a0 [mac80211]
>>
>>
>> When only 1 lock is held, it is "&tid_tx->session_timer", and that
>> one is held in every case. I think that means we need to OR it with
>> the other lockdep_is_held() arguments in the rcu_dereference_xxxxx()
>> call, but I did not seem to get the syntax right.
>
> If any one of several locks (call them a, b, and c) is sufficient to
> protect the data, and if an rcu_read_lock() also suffices, then something
> like the following would work:
>
> 	return rcu_dereference_check(sta->ampdu_mlme.tid_tx[tid],
> 				     lockdep_is_held(&a) ||
> 				     lockdep_is_held(&b) ||
> 				     lockdep_is_held(&c));
>
> But I must defer to the developers and maintainers of that code
> as to exactly which combinations of locks and RCU are required.
> The rcu_read_lock_held() is supplied by rcu_dereference_check(), so I
> am surprised that you got a splat that included rcu_read_lock.

That was before I switched to rcu_dereference_check(). Sorry if that misled you.

Larry


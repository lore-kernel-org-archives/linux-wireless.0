Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35638 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbcDIQ6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Apr 2016 12:58:52 -0400
Subject: Re: Kernel crash on startup - bisected to commit 3b24d854cb35
To: Eric Dumazet <edumazet@google.com>
References: <570892F9.9030700@lwfinger.net>
 <CANn89iJ6sfeNgB4BBmAw5SewqSHe_50+6POLJn=fhTDnNcY6kQ@mail.gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-next <linux-next@vger.kernel.org>,
	linux-netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <570934C9.5020008@lwfinger.net> (sfid-20160409_185912_876339_1F00DC55)
Date: Sat, 9 Apr 2016 11:58:49 -0500
MIME-Version: 1.0
In-Reply-To: <CANn89iJ6sfeNgB4BBmAw5SewqSHe_50+6POLJn=fhTDnNcY6kQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2016 12:33 AM, Eric Dumazet wrote:
> On Fri, Apr 8, 2016 at 10:28 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> Following a recent pull of the wireless-drivers-next repo. my system got a
>> kernel panic on startup at native_apic_msr_write+0x27. The problem was
>> bisected to commit 3b24d854cb35 ("tcp/dccp: do not touch listener sk_refcnt
>> under synflood"). I am confident of the bisection as a kernel built with the
>> previous commit (3a5d1c0) boots OK.
>>
>> I have not yet captured the entire traceback for the crash, but I do have a
>> crappy photo of the screen that I have attached. The RIP is at
>> native_apic_msr_write+0x27. As this crash is likely configuration dependent,
>> a copy of my .config is also attached. Note that IPv6 is turned off on my
>> machine.
>>
>> Please let me know if any other info is needed.
>
> Can you double check you have this fix ?
>
> commit 8501786929de4616b10b8059ad97abd304a7dddf
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Wed Apr 6 22:07:34 2016 -0700
>
>      tcp/dccp: fix inet_reuseport_add_sock()
>
>      David Ahern reported panics in __inet_hash() caused by my recent commit.
>
>      The reason is inet_reuseport_add_sock() was still using
>      sk_nulls_for_each_rcu() instead of sk_for_each_rcu().
>      SO_REUSEPORT enabled listeners were causing an instant crash.
>
>      While chasing this bug, I found that I forgot to clear SOCK_RCU_FREE
>      flag, as it is inherited from the parent at clone time.
>
>      Fixes: 3b24d854cb35 ("tcp/dccp: do not touch listener sk_refcnt
> under synflood")
>      Signed-off-by: Eric Dumazet <edumazet@google.com>
>      Reported-by: David Ahern <dsa@cumulusnetworks.com>
>      Tested-by: David Ahern <dsa@cumulusnetworks.com>
>      Signed-off-by: David S. Miller <davem@davemloft.net>

No, I did not have that patch. After pulling from net-next to get it, my system 
no longer panics.

Note to linux-wireless readers. At the moment, a system built from 
wireless-drivers-next will have this problem.

Thanks,

Larry



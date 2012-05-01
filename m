Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41615 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2EAOZy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 10:25:54 -0400
Received: by vbbff1 with SMTP id ff1so2778623vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 07:25:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334246145.4062.0.camel@jlt3.sipsolutions.net>
References: <4F83A6DE.7070109@lwfinger.net>
	<1334201497.3788.1.camel@jlt3.sipsolutions.net>
	<4F865155.2000202@lwfinger.net>
	<1334202842.3788.10.camel@jlt3.sipsolutions.net>
	<4F86FA05.5080404@lwfinger.net>
	<1334246145.4062.0.camel@jlt3.sipsolutions.net>
Date: Tue, 1 May 2012 19:55:53 +0530
Message-ID: <CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com> (sfid-20120501_162558_710187_A6E2554D)
Subject: Re: Suspicious RCU usage in mac80211
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Johannes and Larry,

On Thu, Apr 12, 2012 at 9:25 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-04-12 at 10:51 -0500, Larry Finger wrote:
>> On 04/11/2012 10:54 PM, Johannes Berg wrote:
>> >
>> > What do you mean by "every time"? I wouldn't expect the timer to fire
>> > every time you set up aggregation etc., the timer firing is a special
>> > case to start with.
>>
>> I meant it is intermittent, or it required some special setup that I have not
>> duplicated, as I have seen the condition only once.
>
> Ok. I suspect that's explained by the fact that the timer is an error
> case anyway, so you've probably never seen that error case again. It's
> still puzzling though since the code looks fine to me.
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


May  1 14:34:51 shafi-laptop kernel: [   83.216284]
===============================
May  1 14:34:51 shafi-laptop kernel: [   83.216286] [ INFO: suspicious
RCU usage. ]
May  1 14:34:51 shafi-laptop kernel: [   83.216289] 3.4.0-rc3-wl #16 Not tainted
May  1 14:34:51 shafi-laptop kernel: [   83.216291]
-------------------------------
May  1 14:34:51 shafi-laptop kernel: [   83.216293]
net/mac80211/sta_info.h:456 suspicious rcu_dereference_protected()
usage!
May  1 14:34:51 shafi-laptop kernel: [   83.216295]
May  1 14:34:51 shafi-laptop kernel: [   83.216296] other info that
might help us debug this:
May  1 14:34:51 shafi-laptop kernel: [   83.216297]
May  1 14:34:51 shafi-laptop kernel: [   83.216299]
May  1 14:34:51 shafi-laptop kernel: [   83.216299]
rcu_scheduler_active = 1, debug_locks = 1
May  1 14:34:51 shafi-laptop kernel: [   83.216302] 2 locks held by kmemleak/52:
May  1 14:34:51 shafi-laptop kernel: [   83.216303]  #0:
(scan_mutex){+.+...}, at: [<c024d343>] kmemleak_scan_thread+0x53/0xc0
May  1 14:34:51 shafi-laptop kernel: [   83.216313]  #1:
(&tid_tx->session_timer){+.-...}, at: [<c0144fdf>]
run_timer_softirq+0xcf/0x400
May  1 14:34:51 shafi-laptop kernel: [   83.216321]
May  1 14:34:51 shafi-laptop kernel: [   83.216322] stack backtrace:
May  1 14:34:51 shafi-laptop kernel: [   83.216325] Pid: 52, comm:
kmemleak Not tainted 3.4.0-rc3-wl #16
May  1 14:34:51 shafi-laptop kernel: [   83.216327] Call Trace:
May  1 14:34:51 shafi-laptop kernel: [   83.216332]  [<c0191726>]
lockdep_rcu_suspicious+0xc6/0x100
May  1 14:34:51 shafi-laptop kernel: [   83.216351]  [<f835b14d>]
sta_tx_agg_session_timer_expired+0xcd/0x100 [mac80211]
May  1 14:34:51 shafi-laptop kernel: [   83.216355]  [<c014506d>]
run_timer_softirq+0x15d/0x400
May  1 14:34:51 shafi-laptop kernel: [   83.216358]  [<c0144fdf>] ?
run_timer_softirq+0xcf/0x400
May  1 14:34:51 shafi-laptop kernel: [   83.216373]  [<f835b080>] ?
sta_addba_resp_timer_expired+0x240/0x240 [mac80211]
May  1 14:34:51 shafi-laptop kernel: [   83.216380]  [<c013d56f>]
__do_softirq+0xaf/0x310
May  1 14:34:51 shafi-laptop kernel: [   83.216384]  [<c013d4c0>] ?
__hrtimer_tasklet_trampoline+0x20/0x20
May  1 14:34:51 shafi-laptop kernel: [   83.216386]  <IRQ>
[<c013cc65>] ? irq_exit+0xb5/0xd0
May  1 14:34:51 shafi-laptop kernel: [   83.216393]  [<c06b74a9>] ?
smp_apic_timer_interrupt+0x59/0x88
May  1 14:34:51 shafi-laptop kernel: [   83.216398]  [<c03d8edc>] ?
trace_hardirqs_off_thunk+0xc/0x10
May  1 14:34:51 shafi-laptop kernel: [   83.216402]  [<c06afc36>] ?
apic_timer_interrupt+0x36/0x40
May  1 14:34:51 shafi-laptop kernel: [   83.216405]  [<c019007b>] ?
rcu_read_lock_sched_held+0x1b/0x70
May  1 14:34:51 shafi-laptop kernel: [   83.216409]  [<c06af58e>] ?
_raw_spin_unlock_irqrestore+0x3e/0x70
May  1 14:34:51 shafi-laptop kernel: [   83.216412]  [<c024bf4b>] ?
scan_gray_list+0x12b/0x180
May  1 14:34:51 shafi-laptop kernel: [   83.216415]  [<c024c815>] ?
kmemleak_scan+0x235/0x8c0
May  1 14:34:51 shafi-laptop kernel: [   83.216418]  [<c024c5e0>] ?
kmemleak_seq_next+0x130/0x130
May  1 14:34:51 shafi-laptop kernel: [   83.216422]  [<c024d2f0>] ?
kmemleak_write+0x450/0x450
May  1 14:34:51 shafi-laptop kernel: [   83.216425]  [<c024d2f0>] ?
kmemleak_write+0x450/0x450
May  1 14:34:51 shafi-laptop kernel: [   83.216428]  [<c024d348>] ?
kmemleak_scan_thread+0x58/0xc0
May  1 14:34:51 shafi-laptop kernel: [   83.216431]  [<c01590a4>] ?
kthread+0x84/0x90
May  1 14:34:51 shafi-laptop kernel: [   83.216435]  [<c0159020>] ?
__init_kthread_worker+0x60/0x60
May  1 14:34:51 shafi-laptop kernel: [   83.216438]  [<c06b7306>] ?
kernel_thread_helper+0x6/0x10
May  1 14:34:54 shafi-laptop kernel: [   86.692061] wlan0: no IPv6
routers present
May  1 14:34:58 shafi-laptop kernel: [   90.691571] cfg80211: Found
new beacon on frequency: 2467 MHz (Ch 12) on phy0

i just looked into the code and compared it with
sta_addba_resp_timer_expired and thought whether we should do
this..

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 5b7053c..e4da258 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -421,21 +421,25 @@ static void
sta_tx_agg_session_timer_expired(unsigned long data)
        struct tid_ampdu_tx *tid_tx;
        unsigned long timeout;

+       rcu_read_lock();
        tid_tx = rcu_dereference_protected_tid_tx(sta, *ptid);
-       if (!tid_tx)
+       if (!tid_tx) {
+               rcu_read_unlock();
                return;
+       }

        timeout = tid_tx->last_tx + TU_TO_JIFFIES(tid_tx->timeout);
        if (time_is_after_jiffies(timeout)) {
                mod_timer(&tid_tx->session_timer, timeout);
+               rcu_read_unlock();
                return;
        }

 #ifdef CONFIG_MAC80211_HT_DEBUG
        printk(KERN_DEBUG "tx session timer expired on tid %d\n", (u16)*ptid);
 #endif
-
        ieee80211_stop_tx_ba_session(&sta->sta, *ptid);
+       rcu_read_unlock();
 }

 int i



-- 
thanks,
shafi

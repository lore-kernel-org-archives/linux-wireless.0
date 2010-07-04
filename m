Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63543 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab0GDJfm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jul 2010 05:35:42 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 04 Jul 2010 02:35:42 -0700
Date: Sun, 4 Jul 2010 15:05:35 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k doesn't clean up virtual wifis on rmmod, and crashes.
Message-ID: <20100704093535.GE5053@vasanth-laptop>
References: <4C2ED806.9000105@candelatech.com> <20100703070259.GA15479@vasanth-laptop> <4C2F6681.7070202@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C2F6681.7070202@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 03, 2010 at 10:04:09PM +0530, Ben Greear wrote:
> On 07/03/2010 12:02 AM, Vasanthakumar Thiagarajan wrote:
> > On Sat, Jul 03, 2010 at 11:56:14AM +0530, Ben Greear wrote:
> >> It seems to me that in 2.6.34, there is no code to clean up
> >> virtual wiphys in ath9k on rmmod.  Also, ath9k mailing list
> >> is returning error about mis-configured DNS server.
> >>
> >> This is with un-modified ath9k driver and is repeatable
> >> every time on my system (crash is often different, but
> >> it always crashes very quickly).
> >>
> >> [root@atom ~]# echo add=5>  /debug/ath9k/phy1/wiphy
> >> -bash: /debug/ath9k/phy1/wiphy: No such file or directory
> >> [root@atom ~]# echo add=5>  /debug/ath9k/phy0/wiphy
> >> Jul  2 23:22:19 atom kernel: phy1: Selected rate control algorithm 'ath9k_rate_control'
> >> [root@atom ~]# Jul  2 23:22:19 atom kernel: ADDRCONF(NETDEV_UP): wlan1: link is not ready
> >> rmmod ath9k
> >> Jul  2 23:22:24 atom kernel: ath9k 0000:05:00.0: PCI INT A disabled
> >> Jul  2 23:22:24 atom kernel: ath9k: Driver unloaded
> >> [root@atom ~]# BUG: spinlock bad magic on CPU#1, iw/2877
> >>    lock: f8a476c0, .magic: 00000000, .owner:<none>/-1, .owner_cpu: 0
> >> Pid: 2877, comm: iw Not tainted 2.6.34 #7
> >> Call Trace:
> >>    [<c0730e34>] ? printk+0xf/0x13
> >>    [<c05710d6>] spin_bug+0x7b/0x86
> >>    [<c0440b76>] ? delayed_work_timer_fn+0x0/0x30
> >>    [<c0571171>] do_raw_spin_lock+0x1e/0x125
> >>    [<c042f91e>] ? scheduler_tick+0xd6/0x1c9
> >>    [<c0440b76>] ? delayed_work_timer_fn+0x0/0x30
> >>    [<c0732a6d>] _raw_spin_lock_irqsave+0x1b/0x20
> >>    [<c0440b59>] __queue_work+0x12/0x2f
> >>    [<c0440b76>] ? delayed_work_timer_fn+0x0/0x30
> >>    [<c0440ba4>] delayed_work_timer_fn+0x2e/0x30
> >>
> >> I'm new to hacking on this driver..but would love to test
> >> patches, and if someone wants to suggest a good point in
> >> the code to remove the virtual phys, I'll make the attempt.
> >
> > Can you please try this patch?
> 
> It still crashes for me, and backtraces look similar.
> 
> Were you able to reproduce the crash?

with my patch, no. Can you please give the steps to trigger
this crash?

Vasanth 

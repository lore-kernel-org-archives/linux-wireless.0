Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.228]:31173 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYHGXek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 19:34:40 -0400
Received: by wx-out-0506.google.com with SMTP id h29so325578wxd.4
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2008 16:34:39 -0700 (PDT)
Message-ID: <ecb4efd10808071634m2c3fac0fye89030665c76de58@mail.gmail.com> (sfid-20080808_013444_791789_25F8669B)
Date: Thu, 7 Aug 2008 19:34:39 -0400
From: "Clem Taylor" <clem.taylor@gmail.com>
To: madwifi-devel@lists.sourceforge.net
Subject: corrupt wait_queue_t->func causing oops from __wake_up_common() [2.6.24 on Au1550]
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been trying to track down an oops due to what seems to be
something corrupting a wait queue. The kernel dies in
__wake_up_common(), which is called from an interrupt handler. The
wait_queue_t->func gets corrupted with either 1, 0x002c4108 or
0x002c4188. This results in either a paging error or an unaligned
instruction access error.

The panic seems to be related to or triggered by the madwifi 0.9.4
driver. I've been testing on 5 different systems with 3 different APs
and all of them seem to show the panic, typically after running for
14-18 hours. The curious thing is that the panic does *not* show up if
I keep the wireless interface busy with a 1.5-3.6MB/s TCP transmit
flow. However, when I only send about 1.5-3mbps of output traffic
(unicast RTP video) the system panics in 14-18 hours. In the low
bitrate case the traffic bursts every 30ms and in the TCP flow case
the traffic continuous. I'd imagine that the bursty traffic is
exercising a different path then the continuous traffic.

I haven't had much luck figuring out who is corrupting the function
pointer. The corruption is very specific, it is mostly 0x002C4108 (one
time it was 0x002C4188) and the rest of the time it is 1. The value
doesn't seem to change across kernel compiles, even with fairly large
configuration changes.

I tried out the madwifi trunk but ran into some transmit performance
problems, so I didn't bother with much testing. I haven't tried the
ath5k driver due to lack of hardware crypto support and I plan on
trying out the ath9k driver as soon as the hardware arrives.

I was wondering if anyone has any ideas?

I'm using 2.6.24 on an Au1550 (MIPS LE) processor, here are two of the panics:
CPU 0 Unable to handle kernel paging request at virtual address
002c4108, epc == 002c4108, ra == 80122408
Oops[#1]:
Cpu 0
$ 0   : 00000000 1000fc00 002c4108 83a51b58
$ 4   : 83a51b4c 00000001 00000000 00000000
$ 8   : 83a51b4c 00000000 1e88e5be 00000000
$12   : 489b1558 8038e2c0 803d2f90 803d2f70
$16   : 00000000 838afb08 00000001 838afb14
$20   : 00000000 00000000 00000001 00000000
$24   : 803d2f90 00006e0d
$28   : 8038a000 8038be00 83ff8000 80122408
Hi    : 0674cdca
Lo    : 0674cdca
epc   : 002c4108 0x2c4108     Not tainted
ra    : 80122408 __wake_up_common+0x68/0xc0
Status: 1000fc02    KERNEL EXL
Cause : 00800008
BadVA : 002c4108
PrId  : 03030200 (Au1550)
Process swapper (pid: 0, threadinfo=8038a000, task=8038c000)
Stack : 83aa1ea0 8038f7f8 8038f800 80390000 1000fc00 00000000 00000000 00000001
        0000000a 00000000 83ff8000 8012249c 00000001 00000000 83ff8000 00000000
        00000000 80133440 838afb00 802231a0 b76558b4 25f386da 003d0900 00000000
        838afc80 80153678 803c0000 80144dc0 1000fc00 8014dae4 80392940 838afc80
        0000000a 803d0000 803c0000 801537cc 803c0000 8014d640 24f47300 00006e0d
        ...
Call Trace:
[<8012249c>] __wake_up+0x3c/0x74
[<80133440>] do_timer+0x44/0x138
[<802231a0>] dm642_interrupt+0x60/0x98
[<80153678>] handle_IRQ_event+0x7c/0x130
[<80144dc0>] ktime_get+0x18/0x3c
[<8014dae4>] tick_nohz_stop_sched_tick+0x44c/0x4c8
[<801537cc>] __do_IRQ+0xa0/0x134
[<8014d640>] tick_nohz_update_jiffies+0xc4/0x11c
[<8010154c>] plat_irq_dispatch+0x254/0x268
[<80101428>] plat_irq_dispatch+0x130/0x268
[<801030a4>] ret_from_irq+0x0/0x4
[<8010acd0>] mips_next_event+0x0/0x24
[<80104e40>] cpu_idle+0x60/0x68
[<80104df8>] cpu_idle+0x18/0x68
[<80104e04>] cpu_idle+0x24/0x68
[<803a3948>] start_kernel+0x34c/0x55c
[<803a3088>] unknown_bootoption+0x0/0x31c
Code: (Bad address in epc)
Kernel panic - not syncing: Fatal exception in interrupt

or

Kernel unaligned instruction access[#1]:
Cpu 0
$ 0   : 00000000 1000fc00 00000001 83a5bb58
$ 4   : 83a5bb4c 00000001 00000000 00000000
$ 8   : 83a5bb4c 00000000 0ab18e51 00000000
$12   : 489b49cf 8038e2c0 803d2f90 803d2f70
$16   : 00000000 838afb08 00000001 838afb14
$20   : 00000000 00000000 00000001 00000000
$24   : 803d2f90 0000345e
$28   : 8038a000 8038be00 83ff8000 80122408
Hi    : 05d50262
Lo    : 05d50262
epc   : 00000001 _stext+0x7feffc00/0x18     Not tainted
ra    : 80122408 __wake_up_common+0x68/0xc0
Status: 1000fc02    KERNEL EXL
Cause : 00800010
BadVA : 00000001
PrId  : 03030200 (Au1550)
Process swapper (pid: 0, threadinfo=8038a000, task=8038c000)
Stack : 05f5e100 0000345e 0031feed 803d3058 1000fc00 00000000 00000000 00000001
        0000000a 00000000 83ff8000 8012249c 00000008 00000000 83ff8000 00000000
        00000000 80133440 838afb00 802231a0 b764ea8e 21b1f78f 003d0900 00000000
        838afc80 80153678 803c0000 80144dc0 803c2840 801030a4 80392940 838afc80
        0000000a 803d0000 803c0000 801537cc 803c0000 8014d640 08583b00 0000345e
        ...
Call Trace:
[<8012249c>] __wake_up+0x3c/0x74
[<80133440>] do_timer+0x44/0x138
[<802231a0>] dm642_interrupt+0x60/0x98
[<80153678>] handle_IRQ_event+0x7c/0x130
[<80144dc0>] ktime_get+0x18/0x3c
[<801030a4>] ret_from_irq+0x0/0x4
[<801537cc>] __do_IRQ+0xa0/0x134
[<8014d640>] tick_nohz_update_jiffies+0xc4/0x11c
[<8010154c>] plat_irq_dispatch+0x254/0x268
[<80101428>] plat_irq_dispatch+0x130/0x268
[<801030a4>] ret_from_irq+0x0/0x4
[<8010acd0>] mips_next_event+0x0/0x24
[<80104e40>] cpu_idle+0x60/0x68
[<80104df8>] cpu_idle+0x18/0x68
[<80104e04>] cpu_idle+0x24/0x68
[<803a3948>] start_kernel+0x34c/0x55c
[<803a3088>] unknown_bootoption+0x0/0x31c
Code: (Bad address in epc)
Kernel panic - not syncing: Fatal exception in interrupt

                    Thanks,
                    Clem

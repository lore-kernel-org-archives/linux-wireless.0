Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:48562 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYERGPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2008 02:15:32 -0400
Received: by wf-out-1314.google.com with SMTP id 27so859869wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2008 23:15:31 -0700 (PDT)
Message-ID: <c785bba30805172315q42066fct39e20b35629faa51@mail.gmail.com> (sfid-20080518_081559_223640_8169275B)
Date: Sat, 17 May 2008 23:15:31 -0700
From: "Paul Thomas" <pthomas8589@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: newbie rtl8187 question
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1210740748.2721.62.camel@rd>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c785bba30805132014y56aafa7bi8788503f67a7c809@mail.gmail.com>
	 <1210736718.2721.4.camel@rd>
	 <c785bba30805132050y51cc3031uae718bc74ade96@mail.gmail.com>
	 <1210737929.2721.19.camel@rd>
	 <c785bba30805132141l62bef2d7n4d78a95510ed6a3d@mail.gmail.com>
	 <1210740748.2721.62.camel@rd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel,

I was finally able to test the driver with an ARM9 (AT91RM9200)
processor, but I wasn't able to make it work. Here is the error I get:

kernel BUG at net/core/skbuff.c:149!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.26-rc2-wl-dirty #2)
PC is at __bug+0x20/0x2c
LR is at vprintk+0x304/0x344
pc : [<c00255a8>]    lr : [<c0038ab8>]    psr: 20000013
sp : c1d7dd28  ip : c1d7dc8c  fp : c1d7dd34
r10: c1d40460  r9 : 00000000  r8 : c1d7de38
r7 : c1c57120  r6 : c1c57046  r5 : c1c56ffc  r4 : c1c57000
r3 : 00000000  r2 : 00000102  r1 : 00000001  r0 : 00000028
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: c000717f  Table: 21df0000  DAC: 00000017
Process rtl8187 (pid: 899, stack limit = 0xc1d7c260)
Stack: (0xc1d7dd28 to 0xc1d7e000)
dd20:                   c1d7dd68 c1d7dd38 c020ee54 c0025598 c1c57000 c1c56ffc
dd40: c1c57046 c1c57120 c1d3d800 00000020 c1d4be40 023a0000 c1d4be40 c1d7dd80
dd60: c1d7dd6c c020fce4 c020ee08 00000001 00000001 c1d7dddc c1d7dd84 c01ae2b8
dd80: c020fcb8 00000000 00000000 00000000 00000080 0000002a 00000001 c1d91300
dda0: c1d90160 00000006 00000007 00000005 00000004 c1d7de00 c1d7de38 c1d90160
ddc0: c1d4be40 c1d90160 c1d7de38 c1d3d000 c1d7ddfc c1d7dde0 c02a9d74 c01ae0c8
dde0: c0374894 c1d7c000 00000000 c1d4be40 c1d7de84 c1d7de00 c02aa170 c02a9d24
de00: c1d4be40 c1d3d000 c1d90160 c1d3d360 00000000 00000000 c1d7de38 c1d91310
de20: c1d914d0 c1d914d0 00000000 00000000 0b160040 00000000 c1d3d5dc c1d914d0
de40: 00000000 00000000 00000000 00000152 00000001 00000000 00000002 c1d7c000
de60: c1d4be40 c1d3d800 c1d4be40 c1d3d800 c1d91554 c038f298 c1d7deac c1d7de88
de80: c021627c c02a9e8c c1d7c000 c1d3d800 c1d3d800 c1d4be40 ffffeb45 c035ea94
dea0: c1d7ded4 c1d7deb0 c0225564 c02160b8 c1d7c000 c1d3d800 c1d4be40 00000000
dec0: c1d91560 00000090 c1d7def4 c1d7ded8 c02164b4 c0225490 c1d4be40 00000000
dee0: c1d3d360 c1d4be60 c1d7df14 c1d7def8 c029c570 c0216324 0000000c c1c57045
df00: c1d4be40 c1c57036 c1d7df4c c1d7df18 c029ca84 c029c518 c1c57040 c1d90e8c
df20: c1d3d000 c1d90160 c1d7c000 c1d2a240 c1d3d000 c02a2320 00000000 00000019
df40: c1d7df74 c1d7df50 c02a2490 c029c848 c1d90e5c c1d7c000 c1d2a240 c1d90e58
df60: c02a2320 00000000 c1d7df98 c1d7df78 c0048d38 c02a2330 c1d2a248 c1d7dfb0
df80: c1d2a240 00000000 00000000 c1d7dfdc c1d7df9c c0048ec0 c0048c60 00000000
dfa0: c1c26900 c004cf20 c1d7dfbc c1d7dfbc 00000000 c1c26900 c004cf20 c1d7dfbc
dfc0: c1d7dfbc fffffffc c0048e08 00000000 c1d7dff4 c1d7dfe0 c004c848 c0048e18
dfe0: 00000000 00000000 00000000 c1d7dff8 c003a398 c004c804 00000000 00000000
Backtrace:
[<c0025588>] (__bug+0x0/0x2c) from [<c020ee54>] (skb_under_panic+0x5c/0x68)
[<c020edf8>] (skb_under_panic+0x0/0x68) from [<c020fce4>] (skb_push+0x3c/0x44)
 r7:c1d4be40 r6:023a0000 r5:c1d4be40 r4:00000020
[<c020fca8>] (skb_push+0x0/0x44) from [<c01ae2b8>] (rtl8187_tx+0x200/0x324)
 r5:00000001 r4:00000001
[<c01ae0b8>] (rtl8187_tx+0x0/0x324) from [<c02a9d74>]
(__ieee80211_tx+0x60/0x168)
[<c02a9d14>] (__ieee80211_tx+0x0/0x168) from [<c02aa170>]
(ieee80211_master_start_xmit+0x2f4/0x468)
 r7:c1d4be40 r6:00000000 r5:c1d7c000 r4:c0374894
[<c02a9e7c>] (ieee80211_master_start_xmit+0x0/0x468) from [<c021627c>]
(dev_hard_start_xmit+0x1d4/0x26c)
[<c02160a8>] (dev_hard_start_xmit+0x0/0x26c) from [<c0225564>]
(__qdisc_run+0xe4/0x248)
[<c0225480>] (__qdisc_run+0x0/0x248) from [<c02164b4>]
(dev_queue_xmit+0x1a0/0x308)
[<c0216314>] (dev_queue_xmit+0x0/0x308) from [<c029c570>]
(ieee80211_sta_tx+0x68/0x6c)
 r7:c1d4be60 r6:c1d3d360 r5:00000000 r4:c1d4be40
[<c029c508>] (ieee80211_sta_tx+0x0/0x6c) from [<c029ca84>]
(ieee80211_send_probe_req+0x24c/0x260)
 r7:c1c57036 r6:c1d4be40 r5:c1c57045 r4:0000000c
[<c029c838>] (ieee80211_send_probe_req+0x0/0x260) from [<c02a2490>]
(ieee80211_sta_scan_work+0x170/0x1a4)
[<c02a2320>] (ieee80211_sta_scan_work+0x0/0x1a4) from [<c0048d38>]
(run_workqueue+0xe8/0x1b8)
[<c0048c50>] (run_workqueue+0x0/0x1b8) from [<c0048ec0>]
(worker_thread+0xb8/0xcc)
 r8:00000000 r7:00000000 r6:c1d2a240 r5:c1d7dfb0 r4:c1d2a248
[<c0048e08>] (worker_thread+0x0/0xcc) from [<c004c848>] (kthread+0x54/0x7c)
 r6:00000000 r5:c0048e08 r4:fffffffc
[<c004c7f4>] (kthread+0x0/0x7c) from [<c003a398>] (do_exit+0x0/0x65c)
 r5:00000000 r4:00000000
Code: e1a01000 e59f000c eb004d54 e3a03000 (e5833000)
Kernel panic - not syncing: Fatal exception in interrupt

thanks,
Paul

On Tue, May 13, 2008 at 9:52 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Tue, 2008-05-13 at 21:41 -0700, Paul Thomas wrote:
>> Thanks,
>>
>> That worked! I unplugged my ethernet cable, and I'm sending this via
>> the wireless adapter.
>
> Nice to hear that!!!
>
>> If I can get some other patches on this same tree I can test the
>> driver on an arm9 processor (Atmel AT91RM9200). I'll let you know.
>>
>> Any idea when those patches will find there way to the main line kernel?
>
> Since the code is working, it's likely to be in linux-wireless within
> days, which means in will be scheduled for Linux 2.6.27.  2.6.26 is in
> the RC phase now, but I've seen a similar patch for Broadcom going into
> 2.6.25 quite late in the game, so we can hope that 2.6.26 may have the
> rtl8187b fix too.
>
> --
> Regards,
> Pavel Roskin
>

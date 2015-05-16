Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:33747 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbbEPMR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 08:17:29 -0400
Received: by lagr1 with SMTP id r1so77063922lag.0
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2015 05:17:28 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 16 May 2015 15:17:28 +0300
Message-ID: <CAJ=9Czbh2cT-qvkEmvVWPCwWdAJ5H_kAcRXirW4MQDhrMb4XRg@mail.gmail.com> (sfid-20150516_141734_611297_EC3D047E)
Subject: kernel page fault in r8712u
From: Haggai Eran <haggai.eran@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've encountered the oops below running the r8712u driver. It occurred
on Raspberry Pi (OpenELEC 5.95 beta, running kernel version 4.0.3),
with the following device:
> 0bda:8172 Realtek Semiconductor Corp. RTL8191SU 802.11n WLAN Adapter

I'd be happy to dig in and see what the problem is, but I wanted to
make sure this is the right driver to look at. linuxwireless.org says
that this driver is going to be replaced by rtl8192su [1].

Have you seen this issue?

Thanks,
Haggai

[1] http://linuxwireless.org/en/users/Drivers/rtl819x/

[  834.537661] Unable to handle kernel paging request at virtual
address a9d797d7
[  834.544900] pgd = 96b14000
[  834.547604] [a9d797d7] *pgd=00000000
[  834.551186] Internal error: Oops: 5 [#1] ARM
[  834.555449] Modules linked in: cfg80211 bluetooth r8712u(C)
bcm2708_rng [last unloaded: btusb]
[  834.564092] CPU: 0 PID: 3 Comm: ksoftirqd/0 Tainted: G         C
  4.0.1 #1
[  834.571303] Hardware name: BCM2708
[  834.574702] task: 9703a700 ti: 97056000 task.ti: 97056000
[  834.580125] PC is at put_compound_page+0x64/0x1d0
[  834.584833] LR is at put_page+0x48/0x4c
[  834.588670] pc : [<80076354>]    lr : [<80076508>]    psr: 00000113
[  834.588670] sp : 97057d70  ip : 97057d88  fp : 97057d84
[  834.600129] r10: 97335c00  r9 : 0000003c  r8 : 00000c21
[  834.605345] r7 : 9723cf00  r6 : 972a6900  r5 : 972a6900  r4 : 5d270b9a
[  834.611862] r3 : d7a0d795  r2 : d7a0d795  r1 : 00000001  r0 : a9d797d7
[  834.618390] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[  834.625690] Control: 00c5387d  Table: 16b14008  DAC: 00000015
[  834.631429] Process ksoftirqd/0 (pid: 3, stack limit = 0x97056188)
[  834.637601] Stack: (0x97057d70 to 0x97058000)
[  834.641957] 7d60:                                     00000000
972a6900 97057d94 97057d88
[  834.650132] 7d80: 80076508 800762fc 97057db4 97057d98 803d86c0
800764cc 9723cf00 89868bd0
[  834.658308] 7da0: 89868420 89868bd0 97057dcc 97057db8 803d8748
803d8660 00000001 9723cf00
[  834.666483] 7dc0: 97057de4 97057dd0 803d8844 803d872c 40000113
898c2d18 97057df4 97057de8
[  834.674657] 7de0: 803e4b94 803d8828 97057e14 97057df8 7f01a714
803e4b5c 00000009 89868420
[  834.682831] 7e00: 898c2d18 00000000 97057e4c 97057e18 7f01b094
7f01a6f4 8986a420 00000760
[  834.691003] 7e20: 972a6260 89868420 898c2d18 8986a420 00000c80
00000c21 0000003c 97335c00
[  834.699179] 7e40: 97057e6c 97057e50 7f01c6fc 7f01b014 000000ec
898c2d18 972a6906 00000018
[  834.707353] 7e60: 97057ebc 97057e70 7f01a354 7f01c6d4 9703a730
89868c34 97322480 8986a420
[  834.715529] 7e80: 89868bd0 9723cf00 fffff580 00000002 9703a730
00000000 00000000 8082cbec
[  834.723702] 7ea0: 80864760 00000000 80864780 80864780 97057edc
97057ec0 8001e12c 7f01a1b8
[  834.731874] 7ec0: 00000001 40000000 00000100 97056000 97057f2c
97057ee0 8001e4d8 8001e0c0
[  834.740048] 7ee0: 80033bc0 80033a88 973db180 04208040 00027227
0000000a 80864780 97056020
[  834.748223] 7f00: 97057f28 97002560 97056000 00000000 00000001
8082cbb8 00000002 00000000
[  834.756397] 7f20: 97057f3c 97057f30 8001e630 8001e3fc 97057f64
97057f40 80036430 8001e610
[  834.764568] 7f40: 00000000 97002580 97002560 80036320 00000000
00000000 97057fac 97057f68
[  834.772741] 7f60: 80032ff0 8003632c c4c0d0c4 00000001 00000000
97002560 00000000 97057f7c
[  834.780913] 7f80: 97057f7c 00000000 97057f88 97057f88 97002580
80032f1c 00000000 00000000
[  834.789088] 7fa0: 00000000 97057fb0 8000e740 80032f28 00000000
00000000 00000000 00000000
[  834.797261] 7fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  834.805432] 7fe0: 00000000 00000000 00000000 00000000 00000013
00000000 c4c0ceca d0c0c040
[  834.813594] Backtrace:
[  834.816072] [<800762f0>] (put_compound_page) from [<80076508>]
(put_page+0x48/0x4c)
[  834.823722]  r5:972a6900 r4:00000000
[  834.827331] [<800764c0>] (put_page) from [<803d86c0>]
(skb_release_data+0x6c/0xcc)
[  834.834904] [<803d8654>] (skb_release_data) from [<803d8748>]
(skb_release_all+0x28/0x2c)
[  834.843071]  r7:89868bd0 r6:89868420 r5:89868bd0 r4:9723cf00
[  834.848759] [<803d8720>] (skb_release_all) from [<803d8844>]
(consume_skb+0x28/0x5c)
[  834.856490]  r4:9723cf00 r3:00000001
[  834.860088] [<803d881c>] (consume_skb) from [<803e4b94>]
(__dev_kfree_skb_any+0x44/0x48)
[  834.868167]  r4:898c2d18 r3:40000113
[  834.871974] [<803e4b50>] (__dev_kfree_skb_any) from [<7f01a714>]
(r8712_free_recvframe+0x2c/0x9c [r8712u])
[  834.881891] [<7f01a6e8>] (r8712_free_recvframe [r8712u]) from
[<7f01b094>] (recv_func+0x8c/0x6e8 [r8712u])
[  834.891533]  r6:00000000 r5:898c2d18 r4:89868420 r3:00000009
[  834.897456] [<7f01b008>] (recv_func [r8712u]) from [<7f01c6fc>]
(r8712_recv_entry+0x34/0x78 [r8712u])
[  834.906667]  r10:97335c00 r9:0000003c r8:00000c21 r7:00000c80
r6:8986a420 r5:898c2d18
[  834.914518]  r4:89868420
[  834.917398] [<7f01c6c8>] (r8712_recv_entry [r8712u]) from
[<7f01a354>] (recv_tasklet+0x1a8/0x31c [r8712u])
[  834.927047]  r6:00000018 r5:972a6906 r4:898c2d18 r3:000000ec
[  834.932903] [<7f01a1ac>] (recv_tasklet [r8712u]) from [<8001e12c>]
(tasklet_hi_action+0x78/0xcc)
[  834.941680]  r10:80864780 r9:80864780 r8:00000000 r7:80864760
r6:8082cbec r5:00000000
[  834.949529]  r4:00000000
[  834.952086] [<8001e0b4>] (tasklet_hi_action) from [<8001e4d8>]
(__do_softirq+0xe8/0x214)
[  834.960166]  r7:97056000 r6:00000100 r5:40000000 r4:00000001
[  834.965849] [<8001e3f0>] (__do_softirq) from [<8001e630>]
(run_ksoftirqd+0x2c/0x3c)
[  834.973492]  r10:00000000 r9:00000002 r8:8082cbb8 r7:00000001
r6:00000000 r5:97056000
[  834.981339]  r4:97002560
[  834.983901] [<8001e604>] (run_ksoftirqd) from [<80036430>]
(smpboot_thread_fn+0x110/0x15c)
[  834.992173] [<80036320>] (smpboot_thread_fn) from [<80032ff0>]
(kthread+0xd4/0xf0)
[  834.999731]  r9:00000000 r8:00000000 r7:80036320 r6:97002560
r5:97002580 r4:00000000
[  835.007519] [<80032f1c>] (kthread) from [<8000e740>]
(ret_from_fork+0x14/0x34)
[  835.014738]  r7:00000000 r6:00000000 r5:80032f1c r4:97002580
[  835.020420] Code: e590001c e5943000 e3130902 0a00001d (e5903000)
[  835.026527] ---[ end trace 633783c74480b173 ]---
[  835.031145] Kernel panic - not syncing: Fatal exception in interrupt
[  835.037494] ---[ end Kernel panic - not syncing: Fatal exception in interrupt

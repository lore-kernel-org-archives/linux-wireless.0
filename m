Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:40926 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761618AbYBZRyI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 12:54:08 -0500
To: linux-wireless@vger.kernel.org
Subject: ath5k: kernel BUG at kernel/workqueue.c:272
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 26 Feb 2008 18:54:07 +0100
Message-ID: <m34pbvsiww.fsf@maximus.localdomain> (sfid-20080226_175414_355165_B88AFB5E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another one (a different card, current git, ARM big-endian). Just after
iwconfig wlan0 essid XXX mode ad-hoc channel YY

phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR5413 chip found (MAC: 0xa4, PHY: 0x61)

kernel BUG at kernel/workqueue.c:272!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 817 [#1]
Modules linked in: ixp4xx_hss ixp4xx_eth ixp4xx_npe ixp4xx_qmgr ath5k
CPU: 0    Not tainted  (2.6.25-rc3 #14)
PC is at __bug+0x20/0x2c
LR is at check_preempt_wakeup+0xb0/0xbc
pc : [<c00c15e8>]    lr : [<c00d229c>]    psr: 60000013
sp : c68b7f84  ip : c03e0ff8  fp : c68b7f90
r10: 00000000  r9 : 00000000  r8 : 00000000
r7 : 00000000  r6 : c68b7fb0  r5 : c031e9e8  r4 : c687f480
r3 : 00000000  r2 : c03e1004  r1 : a0000013  r0 : 00000044
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 000039ff  Table: 06f78000  DAC: 00000017
Process ath5k_pci (pid: 351, stack limit = 0xc68b6268)
Stack: (0xc68b7f84 to 0xc68b8000)
7f80:          c68b7fac c68b7f94 c00e4acc c00c15d4 c687f480 c687f488 c68b7fb0 
7fa0: c68b7fdc c68b7fb0 c00e5524 c00e4988 00000000 c7c8c700 c00e89dc c68b7fbc 
7fc0: c68b7fbc c687f480 c00e54ac 00000000 c68b7ff4 c68b7fe0 c00e84e0 c00e54b8 
7fe0: 00000000 00000000 00000000 c68b7ff8 c00d7e0c c00e849c 00001021 00001421 
Backtrace: 
[<c00c15c8>] (__bug+0x0/0x2c) from [<c00e4acc>] (run_workqueue+0x150/0x198)
[<c00e497c>] (run_workqueue+0x0/0x198) from [<c00e5524>] (worker_thread+0x78/0xd
0)
 r6:c68b7fb0 r5:c687f488 r4:c687f480
[<c00e54ac>] (worker_thread+0x0/0xd0) from [<c00e84e0>] (kthread+0x50/0x7c)
 r6:00000000 r5:c00e54ac r4:c687f480
[<c00e8490>] (kthread+0x0/0x7c) from [<c00d7e0c>] (do_exit+0x0/0x740)
 r5:00000000 r4:00000000
Code: e1a01000 e59f000c eb005095 e3a03000 (e5833000) 
---[ end trace 64f98d870025a13e ]---
-- 
Krzysztof Halasa

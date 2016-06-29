Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0132.outbound.protection.outlook.com ([157.55.234.132]:9837
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753227AbcF2P1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 11:27:14 -0400
From: "Baumann, Christoph (C.)" <cbaumann@visteon.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Issue with mwifiex
Date: Wed, 29 Jun 2016 15:27:04 +0000
Message-ID: <DB5PR06MB12852C853C2D4164C005822DD0230@DB5PR06MB1285.eurprd06.prod.outlook.com> (sfid-20160629_172718_789484_1E80BE00)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

testing mwifiex with iperf I ran into an issue with the bandwidth in RX and TX direction.
If I run iperf as UDP server on the target I can get a throughput of up to 90 MBits/s.
With changed directions I have to limit the bandwidth to 10 MBits/s to keep things stable.
Above that limit I get this:
"
[  778.872505] NETDEV WATCHDOG: mlan0 (mwifiex_pcie): transmit queue 1 timed out
[  778.879734] ------------[ cut here ]------------
[  778.884376] WARNING: CPU: 4 PID: 0 at net/sched/sch_generic.c:306 dev_watchdog+0x2b0/0x2b8
[  778.892653] Modules linked in: mwifiex_pcie mwifiex cfg80211
[  778.898346] 
[  778.899840] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 4.6.0 #17
[  778.905766] Hardware name: ........ board based on r8a7795 (DT)
[  778.912650] task: ffffffc6fb0eb200 ti: ffffffc6fb100000 task.ti: ffffffc6fb100000
[  778.920143] PC is at dev_watchdog+0x2b0/0x2b8
[  778.924504] LR is at dev_watchdog+0x2b0/0x2b8
[  778.928864] pc : [<ffffff800860d3dc>] lr : [<ffffff800860d3dc>] pstate: 20000145
[  778.936268] sp : ffffffc6fff3fe50
[  778.939583] x29: ffffffc6fff3fe50 x28: 0000000000000001 
[  778.944912] x27: 0000000000000008 x26: ffffff800860d12c 
[  778.950241] x25: 00000000ffffffff x24: 0000000000000004 
[  778.955569] x23: ffffffc6fb337800 x22: ffffffc6fb3363a0 
[  778.960899] x21: 0000000000000004 x20: ffffffc6fb336000 
[  778.966228] x19: ffffff8008a25000 x18: 000000000000000e 
[  778.971556] x17: 0000000000000001 x16: 0000000000000007 
[  778.976885] x15: 000000000000000e x14: 756f2064656d6974 
[  778.982214] x13: 2031206575657571 x12: 2074696d736e6172 
[  778.987543] x11: 74203a2965696370 x10: 5f7865696669776d 
[  778.992872] x9 : 2820306e616c6d20 x8 : 3a474f4448435441 
[  778.998200] x7 : 572056454454454e x6 : 0000000000000000 
[  779.003529] x5 : ffffffffffffffe0 x4 : 0000000000000000 
[  779.008858] x3 : ffffff8008a294d0 x2 : 00000000000034c6 
[  779.014186] x1 : ffffffc6fb100000 x0 : 0000000000000041 
[  779.019515] 
[  779.021003] ---[ end trace d756986f0e6354bf ]---
[  779.025624] Call trace:
[  779.028073] Exception stack(0xffffffc6fff3fc90 to 0xffffffc6fff3fdb0)
[  779.034523] fc80:                                   ffffff8008a25000 ffffffc6fb336000
[  779.042365] fca0: ffffffc6fff3fe50 ffffff800860d3dc ffffff8008a26bd8 ffffffc6fb100000
[  779.050207] fcc0: 0000000100000000 ffffff8008ab4a98 ffffffc6fff3fd70 ffffff80080e09b4
[  779.058049] fce0: ffffff80080e097c ffffffc6fb336000 0000000000000004 ffffffc6fb3363a0
[  779.065891] fd00: ffffffc6fb337800 0000000000000004 00000000ffffffff ffffff800860d12c
[  779.073732] fd20: 0000000000000008 0000000000000001 0000000000000041 ffffffc6fb100000
[  779.081574] fd40: 00000000000034c6 ffffff8008a294d0 0000000000000000 ffffffffffffffe0
[  779.089416] fd60: 0000000000000000 572056454454454e 3a474f4448435441 2820306e616c6d20
[  779.097257] fd80: 5f7865696669776d 74203a2965696370 2074696d736e6172 2031206575657571
[  779.105098] fda0: 756f2064656d6974 000000000000000e
[  779.109981] [<ffffff800860d3dc>] dev_watchdog+0x2b0/0x2b8
[  779.115398] [<ffffff80080f2ef4>] call_timer_fn.isra.27+0x24/0x78
[  779.121413] [<ffffff80080f30d4>] run_timer_softirq+0x18c/0x1f8
[  779.127259] [<ffffff80080a5f70>] __do_softirq+0x104/0x208
[  779.132665] [<ffffff80080a62d0>] irq_exit+0x88/0xc8
[  779.137551] [<ffffff80080e176c>] __handle_domain_irq+0x64/0xac
[  779.143393] [<ffffff80080824c0>] gic_handle_irq+0x50/0x9c
[  779.148797] Exception stack(0xffffffc6fff40050 to 0xffffffc6fff40170)
[  779.155246] 0040:                                   ffffffc6fb103e20 ffffff8008a26bd8
[  779.163088] 0060: ffffffc6fb103f40 ffffff8008086780 0000000060000145 0000000000000000
[  779.170929] 0080: ffffffc6fb103f40 ffffffc6fb103e20 0000000000000000 0000000000000000
[  779.178771] 00a0: ffffffc6fa72bb40 0000000000000000 0000000000000000 0000000000000000
[  779.186612] 00c0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  779.194453] 00e0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  779.202295] 0100: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  779.210136] 0120: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  779.217976] 0140: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  779.225816] 0160: 0000000000000000 0000000000000000
[  779.230702] [<ffffff8008085720>] el1_irq+0xa0/0x10c
[  779.235586] [<ffffff8008086780>] arch_cpu_idle+0x10/0x18
[  779.240907] [<ffffff80080d7f2c>] default_idle_call+0x18/0x2c
[  779.246574] [<ffffff80080d80d8>] cpu_startup_entry+0x198/0x1ec
[  779.252416] [<ffffff800808edec>] secondary_start_kernel+0x17c/0x1c8
[  779.258693] [<000000004808281c>] 0x4808281c
[  779.262898] mwifiex_pcie 0000:01:00.0: 4295082589 : Tx timeout(#1), bss_type-num = 0-0
[  784.872503] mwifiex_pcie 0000:01:00.0: 4295083992 : Tx timeout(#2), bss_type-num = 0-0
[  794.872499] mwifiex_pcie 0000:01:00.0: 4295086492 : Tx timeout(#3), bss_type-num = 0-0
"

Any ideas what the cause might be?
I also tried the alternative driver. It had no crashes, but also showed a significant asymmetrical behaviour regarding RX/TX.




Regards,
Christoph

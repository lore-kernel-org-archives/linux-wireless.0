Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr40049.outbound.protection.outlook.com ([40.107.4.49]:63952
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752182AbdK2WEM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Nov 2017 17:04:12 -0500
Subject: Re: [PATCH] ath10k: unify rx processing in napi_poll
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        ath10k@lists.infradead.org
References: <1511991212-4837-1-git-send-email-rmanohar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <01899b3e-15c5-4f23-5c3c-86b23a0a9451@bowerswilkins.com> (sfid-20171129_230422_943430_7AB6B933)
Date: Wed, 29 Nov 2017 14:03:57 -0800
MIME-Version: 1.0
In-Reply-To: <1511991212-4837-1-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rajkumar,

I'm wondering if this patch is related to kernel crash due to ath10k napi.

Do you think this patch helps the crash below?

This crash happened ath10k v4.14 (10/04/2017, commit id c09dbd7) + 
3.14.43 kernel backports.


[ 6866.655419] ------------[ cut here ]------------
[ 6866.659029] kernel BUG at /net/core/dev.c:4301!
[ 6866.666404] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
[ 6866.672206] Modules linked in: asix essedma qca_ssdk ath9k 
ath9k_common ath9k_hw ath10k_pci ath10k_core mac80211 qca_nss_drv 
qca_nss_gmac ath cfg80211 skcipher compat nvram
[ 6866.687576] CPU: 0 PID: 1228 Comm: kworker/0:0 Tainted: G        W    
3.14.43 #1
[ 6866.694962] Workqueue: events_power_efficient phy_state_machine
[ 6866.700853] task: d88252c0 ti: d8cd2000 task.ti: d8cd2000
[ 6866.706239] PC is at __napi_complete+0x10/0x50
[ 6866.710663] LR is at napi_complete+0x2c/0x34
[ 6866.714919] pc : [<c0635a6c>]    lr : [<c0636710>]    psr: 60050093
[ 6866.714919] sp : d8cd3d88  ip : dfbc5d10  fp : c09dd6e4
[ 6866.726374] r10: dfbc5e88  r9 : 000a04de  r8 : 00000001
[ 6866.731582] r7 : 00000040  r6 : 00000001  r5 : 60050013  r4 : de7a5d60
[ 6866.738092] r3 : 00000000  r2 : 00000100  r1 : de7a5d60  r0 : de7a5d60
[ 6866.744606] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  
Segment kernel
[ 6866.751982] Control: 10c5387d  Table: 9b4f406a  DAC: 00000015
[ 6866.757708]
[ 6866.757708] PC: 0xc06359ec:
[ 6866.761960] 59ec  e8bd8010 e3a00001 e8bd8010 e1a00003 e8bd8010 
e3a00000 e8bd8010 c08b1fb9
[ 6866.770119] 5a0c  c089e498 c0888b00 e5903120 e3130001 012fff1e 
e92d4037 e1a04000 e3a05000
[ 6866.778280] 5a2c  e1a0200d e1a01000 e3a00004 e58d5004 ebfff5f2 
e3a030d0 e1a02005 e1a01004
[ 6866.786439] 5a4c  e3a00010 eb003b52 e28dd00c e8bd8030 e5903008 
e1a01000 e3130001 1a000000
[ 6866.794599] 5a6c  e7f001f2 e590001c e3500000 0a000000 e7f001f2 
e891000c e5823004 e5832000
[ 6866.802759] 5a8c  e59f2010 e59f3010 e881000c f57ff05b e2811008 
eaef51ef 00100100 00200200
[ 6866.810919] 5aac  e92d4070 e1a04000 e5903110 e5932020 e3520000 
0a000013 e2803f4d e1d1c0b0
[ 6866.819078] 5acc  e1d330b0 e15c0003 1a000010 e590302c e3130002 
0a00000f e12fff32 e2505000
[ 6866.827239]
[ 6866.827239] LR: 0xc0636690:
[ 6866.831490] 6690  e59f7048 e1a04003 e3500000 0a00000d e3560000 
e5804000 0a000003 e5973000
[ 6866.839651] 66b0  e590202c e1520003 08bd81f0 e5908004 ebffffb4 
e5953010 e1a00008 e2433001
[ 6866.847810] 66d0  e5853010 eaffffef e585001c e8bd81f0 c09ce0c0 
e5901008 e7e01151 e3510000
[ 6866.855970] 66f0  112fff1e e92d4070 e1a04000 ebffffd9 e10f5000 
f10c0080 e1a00004 ebfffcd2
[ 6866.864130] 6710  e121f005 e8bd8070 e92d4ff0 e1a04001 e1d1b6b6 
e3a09000 e5911014 e24dd014
[ 6866.872289] 6730  e1c127d0 e2028901 e1983009 1a000001 e3a05003 
ea0000a4 e59430a8 e1d320b2
[ 6866.880450] 6750  e3520000 1afffff9 e5937008 e3570000 1afffff6 
e3003136 e590501c e19180b3
[ 6866.888609] 6770  e1a06000 e5949078 e3550000 0a000037 e5953078 
e1c572b4 e1590003 15c5702a
[ 6866.896771]
[ 6866.896771] SP: 0xd8cd3d08:
[ 6866.901023] 3d08  d8cd3d34 c024ed60 00000001 de7fcb00 de7fc300 
de7a41a4 00000000 00000004
[ 6866.909182] 3d28  d8cd2000 c0635a70 00000000 c0209858 00000000 
c02095ec de7a5d60 de7a5d60
[ 6866.917342] 3d48  00000100 00000000 de7a5d60 60050013 00000001 
00000040 00000001 000a04de
[ 6866.925501] 3d68  dfbc5e88 c09dd6e4 dfbc5d10 d8cd3d88 c0636710 
c0635a6c 60050093 ffffffff
[ 6866.933661] 3d88  de7a15e0 de7a5d60 00000001 bf1a38f8 de7a5d60 
dfbc5e80 00000001 00000040
[ 6866.941821] 3da8  0000012c c0637328 c09ce08c c09ce0c0 c0637280 
40000003 d8cd2020 00000008
[ 6866.949981] 3dc8  c0a34c80 0000000a c09ce08c d8cd2000 00000100 
c022fcac 00000080 00000001
[ 6866.958141] 3de8  c09dd5f0 04208060 000a04dd 00000000 00000004 
c09ce0c0 c09ce080 00000003
[ 6866.966304]
[ 6866.966304] IP: 0xdfbc5c90:
[ 6866.970554] 5c90  c09ddbd0 df49a1c0 000a04e3 00000000 c50baadf 
0000063e acc26c21 000005c9
[ 6866.978713] 5cb0  00000000 df40dc00 df484b80 000003d3 00000000 
00000000 00000000 00000003
[ 6866.986872] 5cd0  dfbc5cd0 dfbc5cd0 c0254544 dfbc5840 00000000 
00000000 00000001 d882531c
[ 6866.995033] 5cf0  d882405c 00000000 01b8e867 00000000 bb4b1900 
0000063e 00000000 00000000
[ 6867.003192] 5d10  000dbc97 00000000 0007a120 00000000 18493ebe 
00000075 000a05e7 fffffef9
[ 6867.011353] 5d30  00000000 00000000 00000000 c024aef0 dfbc5840 
00000000 dfbc5d48 00000000
[ 6867.019512] 5d50  00000000 00000000 00000000 00000000 00000000 
00000000 c024bee8 dfbc41f0
[ 6867.027672] 5d70  00000000 00000000 db651a54 00000000 00002846 
0000b728 acc26c21 000005c9
[ 6867.035833]
[ 6867.035833] FP: 0xc09dd664:
[ 6867.040084] d664  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.048245] d684  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.056404] d6a4  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.064564] d6c4  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.072723] d6e4  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 c08443a7
[ 6867.080884] d704  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.089043] d724  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.097203] d744  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.105365]
[ 6867.105365] R0: 0xde7a5ce0:
[ 6867.109617] 5ce0  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.117776] 5d00  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.125936] 5d20  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.134095] 5d40  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.142255] 5d60  00100100 00200200 00000000 00000040 00000000 
bf1a38bc de7a58a0 00000000
[ 6867.150415] 5d80  00000000 de7a58d8 de7a58d8 00000000 00000000 
00000000 ffffffe0 de7a5d9c
[ 6867.158574] 5da0  de7a5d9c bf135954 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.166734] 5dc0  000f9032 de7a5fd8 00000100 de7a5dcc de7a5dcc 
bf154244 de7a5dd8 de7a5dd8
[ 6867.174895]
[ 6867.174895] R1: 0xde7a5ce0:
[ 6867.179147] 5ce0  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.187306] 5d00  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.195466] 5d20  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.203627] 5d40  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.211787] 5d60  00100100 00200200 00000000 00000040 00000000 
bf1a38bc de7a58a0 00000000
[ 6867.219945] 5d80  00000000 de7a58d8 de7a58d8 00000000 00000000 
00000000 ffffffe0 de7a5d9c
[ 6867.228106] 5da0  de7a5d9c bf135954 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.236265] 5dc0  000f9032 de7a5fd8 00000100 de7a5dcc de7a5dcc 
bf154244 de7a5dd8 de7a5dd8
[ 6867.244427]
[ 6867.244427] R4: 0xde7a5ce0:
[ 6867.248679] 5ce0  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.256839] 5d00  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.264998] 5d20  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.273158] 5d40  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.281317] 5d60  00100100 00200200 00000000 00000040 00000000 
bf1a38bc de7a58a0 00000000
[ 6867.289477] 5d80  00000000 de7a58d8 de7a58d8 00000000 00000000 
00000000 ffffffe0 de7a5d9c
[ 6867.297636] 5da0  de7a5d9c bf135954 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.305797] 5dc0  000f9032 de7a5fd8 00000100 de7a5dcc de7a5dcc 
bf154244 de7a5dd8 de7a5dd8
[ 6867.313960]
[ 6867.313960] R10: 0xdfbc5e08:
[ 6867.318295] 5e08  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.326456] 5e28  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.334617] 5e48  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.342776] 5e68  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 dfbc5e80
[ 6867.350936] 5e88  dfbc5e88 dfbc5e88 00000000 dfbc5e94 dfbc5e94 
00000000 00000000 00368e2a
[ 6867.359096] 5ea8  00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.367254] 5ec8  c0633af4 dfbc5e80 00000000 00000000 00000000 
0000483c 0000483c 00000000
[ 6867.375415] 5ee8  dfbc5ee8 dfbc5ee8 00000000 81048104 00100100 
00200200 00000000 00000040
[ 6867.383579] Process kworker/0:0 (pid: 1228, stack limit = 0xd8cd2238)
[ 6867.390002] Stack: (0xd8cd3d88 to 0xd8cd4000)
[ 6867.394348] 3d80:                   de7a15e0 de7a5d60 00000001 
bf1a38f8 de7a5d60 dfbc5e80
[ 6867.402511] 3da0: 00000001 00000040 0000012c c0637328 c09ce08c 
c09ce0c0 c0637280 40000003
[ 6867.410671] 3dc0: d8cd2020 00000008 c0a34c80 0000000a c09ce08c 
d8cd2000 00000100 c022fcac
[ 6867.418831] 3de0: 00000080 00000001 c09dd5f0 04208060 000a04dd 
00000000 00000004 c09ce0c0
[ 6867.426990] 3e00: c09ce080 00000003 d8cd2000 d8cd2030 d8cd2000 
00000000 d8cd3e94 c04fd548
[ 6867.435151] 3e20: d8979398 d8cd2000 00000000 c0230068 c09c9c38 
000000c8 00000000 c02190f0
[ 6867.443309] 3e40: e0802000 c09d4818 d8cd3e60 c02084c4 c04fd504 
20050013 ffffffff c0209540
[ 6867.451468] 3e60: 00010000 0000004c fff95200 e0a60000 000003da 
dedaf9d0 c09e6b20 00000000
[ 6867.459628] 3e80: c04fd548 d8979398 d8cd2000 00000000 00000000 
d8cd3ea8 c021e288 c04fd504
[ 6867.467787] 3ea0: 20050013 ffffffff dedaf9d0 00000400 00000004 
c04fd604 dedcf000 dedc9800
[ 6867.475947] 3ec0: dedcdc00 c04f8978 dedcf1e0 dedcf1e0 dfbc5440 
dedcf000 dedcf218 c04f55ec
[ 6867.484108] 3ee0: d8979380 dedcf1e0 dfbc5440 00000000 dfbc8b00 
d8979398 d8cd2000 c023ef40
[ 6867.492268] 3f00: d8cd3f34 c020ff1c dfbc5440 d8cd2038 d8cd2000 
d8979380 dfbc5440 dfbc5440
[ 6867.500427] 3f20: d8cd2038 d8cd2000 d8979398 dfbc5454 00000009 
c023feac d8979380 d8cd3f6c
[ 6867.508584] 3f40: 00000000 dc2e5600 00000000 d8979380 c023fc88 
00000000 00000000 00000000
[ 6867.516746] 3f60: 00000000 c0244b6c 00000000 00000000 00000000 
d8979380 00000000 00000000
[ 6867.524905] 3f80: d8cd3f80 d8cd3f80 00000000 00000000 d8cd3f90 
d8cd3f90 d8cd3fac dc2e5600
[ 6867.533063] 3fa0: c0244aa4 00000000 00000000 c0208cd8 00000000 
00000000 00000000 00000000
[ 6867.541222] 3fc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[ 6867.549385] 3fe0: 00000000 00000000 00000000 00000000 00000013 
00000000 00000000 00000000
[ 6867.557554] [<c0635a6c>] (__napi_complete) from [<c0636710>] 
(napi_complete+0x2c/0x34)
[ 6867.565457] [<c0636710>] (napi_complete) from [<bf1a38f8>] 
(ath10k_pci_napi_poll+0x3c/0xec [ath10k_pci])
[ 6867.574917] [<bf1a38f8>] (ath10k_pci_napi_poll [ath10k_pci]) from 
[<c0637328>] (net_rx_action+0xa8/0x158)
[ 6867.584458] [<c0637328>] (net_rx_action) from [<c022fcac>] 
(__do_softirq+0xec/0x218)
[ 6867.592182] [<c022fcac>] (__do_softirq) from [<c0230068>] 
(irq_exit+0x8c/0xe8)
[ 6867.599386] [<c0230068>] (irq_exit) from [<c02190f0>] 
(handle_IRQ+0x6c/0x90)
[ 6867.606419] [<c02190f0>] (handle_IRQ) from [<c02084c4>] 
(gic_handle_irq+0x3c/0x5c)
[ 6867.613968] [<c02084c4>] (gic_handle_irq) from [<c0209540>] 
(__irq_svc+0x40/0x70)
[ 6867.621427] Exception stack(0xd8cd3e60 to 0xd8cd3ea8)
[ 6867.626469] 3e60: 00010000 0000004c fff95200 e0a60000 000003da 
dedaf9d0 c09e6b20 00000000
[ 6867.634628] 3e80: c04fd548 d8979398 d8cd2000 00000000 00000000 
d8cd3ea8 c021e288 c04fd504
[ 6867.642781] 3ea0: 20050013 ffffffff
[ 6867.646263] [<c0209540>] (__irq_svc) from [<c04fd504>] 
(ipq40xx_mdio_wait_busy+0x24/0x68)
[ 6867.654424] [<c04fd504>] (ipq40xx_mdio_wait_busy) from [<c04fd604>] 
(ipq40xx_mdio_read+0x50/0x68)
[ 6867.663276] [<c04fd604>] (ipq40xx_mdio_read) from [<c04f8978>] 
(rtl8306_read_status+0x7c/0x1c0)
[ 6867.671958] [<c04f8978>] (rtl8306_read_status) from [<c04f55ec>] 
(phy_state_machine+0x118/0x3b0)
[ 6867.680727] [<c04f55ec>] (phy_state_machine) from [<c023ef40>] 
(process_one_work+0x208/0x328)
[ 6867.689234] [<c023ef40>] (process_one_work) from [<c023feac>] 
(worker_thread+0x224/0x348)
[ 6867.697393] [<c023feac>] (worker_thread) from [<c0244b6c>] 
(kthread+0xc8/0xdc)
[ 6867.704594] [<c0244b6c>] (kthread) from [<c0208cd8>] 
(ret_from_fork+0x14/0x3c)
[ 6867.711797] Code: e5903008 e1a01000 e3130001 1a000000 (e7f001f2)
[ 6867.717871] ---[ end trace 5bbbaa9d0273b80c ]---
[ 6867.722470] Kernel panic - not syncing: Fatal exception in interrupt
[ 6867.728812] CPU1: stopping
[ 6867.731501] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D W    
3.14.43 #1
[ 6867.738460] [<c021e7d8>] (unwind_backtrace) from [<c021b930>] 
(show_stack+0x10/0x14)
[ 6867.746178] [<c021b930>] (show_stack) from [<c03de238>] 
(dump_stack+0x78/0xbc)
[ 6867.753383] [<c03de238>] (dump_stack) from [<c021dc58>] 
(handle_IPI+0xb8/0x140)
[ 6867.760671] [<c021dc58>] (handle_IPI) from [<c02084dc>] 
(gic_handle_irq+0x54/0x5c)
[ 6867.768221] [<c02084dc>] (gic_handle_irq) from [<c0209540>] 
(__irq_svc+0x40/0x70)
[ 6867.775680] Exception stack(0xdf4c1fa0 to 0xdf4c1fe8)
[ 6867.780723] 1fa0: ffffffed 00000000 1f203000 00000000 df4c0030 
df4c0000 10c0387d c0a322c8
[ 6867.788881] 1fc0: 8020406a 410fc075 00000000 00000000 00000001 
df4c1fe8 c02194b8 c02194bc
[ 6867.797035] 1fe0: 600e0013 ffffffff
[ 6867.800515] [<c0209540>] (__irq_svc) from [<c02194bc>] 
(arch_cpu_idle+0x30/0x50)
[ 6867.807897] [<c02194bc>] (arch_cpu_idle) from [<c0261538>] 
(cpu_startup_entry+0xa4/0x108)
[ 6867.816058] [<c0261538>] (cpu_startup_entry) from [<80208584>] 
(0x80208584)
[ 6867.822990] CPU3: stopping
[ 6867.825685] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D W    
3.14.43 #1
[ 6867.832639] [<c021e7d8>] (unwind_backtrace) from [<c021b930>] 
(show_stack+0x10/0x14)
[ 6867.840358] [<c021b930>] (show_stack) from [<c03de238>] 
(dump_stack+0x78/0xbc)
[ 6867.847567] [<c03de238>] (dump_stack) from [<c021dc58>] 
(handle_IPI+0xb8/0x140)
[ 6867.854854] [<c021dc58>] (handle_IPI) from [<c02084dc>] 
(gic_handle_irq+0x54/0x5c)
[ 6867.862405] [<c02084dc>] (gic_handle_irq) from [<c0209540>] 
(__irq_svc+0x40/0x70)
[ 6867.869862] Exception stack(0xdf4c5fa0 to 0xdf4c5fe8)
[ 6867.874907] 5fa0: ffffffed 00000000 1f213000 00000000 df4c4030 
df4c4000 10c0387d c0a322c8
[ 6867.883066] 5fc0: 8020406a 410fc075 00000000 00000000 00000001 
df4c5fe8 c02194b8 c02194bc
[ 6867.891219] 5fe0: 60070013 ffffffff
[ 6867.894699] [<c0209540>] (__irq_svc) from [<c02194bc>] 
(arch_cpu_idle+0x30/0x50)
[ 6867.902077] [<c02194bc>] (arch_cpu_idle) from [<c0261538>] 
(cpu_startup_entry+0xa4/0x108)
[ 6867.910238] [<c0261538>] (cpu_startup_entry) from [<80208584>] 
(0x80208584)
[ 6867.917175] CPU2: stopping
[ 6867.919869] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D W    
3.14.43 #1
[ 6867.926823] [<c021e7d8>] (unwind_backtrace) from [<c021b930>] 
(show_stack+0x10/0x14)
[ 6867.934542] [<c021b930>] (show_stack) from [<c03de238>] 
(dump_stack+0x78/0xbc)
[ 6867.941748] [<c03de238>] (dump_stack) from [<c021dc58>] 
(handle_IPI+0xb8/0x140)
[ 6867.949037] [<c021dc58>] (handle_IPI) from [<c02084dc>] 
(gic_handle_irq+0x54/0x5c)
[ 6867.956587] [<c02084dc>] (gic_handle_irq) from [<c0209540>] 
(__irq_svc+0x40/0x70)
[ 6867.964048] Exception stack(0xdf4c3fa0 to 0xdf4c3fe8)
[ 6867.969090] 3fa0: ffffffed 00000000 1f20b000 00000000 df4c2030 
df4c2000 10c0387d c0a322c8
[ 6867.977251] 3fc0: 8020406a 410fc075 00000000 00000000 00000001 
df4c3fe8 c02194b8 c02194bc
[ 6867.985401] 3fe0: 60000013 ffffffff
[ 6867.988882] [<c0209540>] (__irq_svc) from [<c02194bc>] 
(arch_cpu_idle+0x30/0x50)
[ 6867.996262] [<c02194bc>] (arch_cpu_idle) from [<c0261538>] 
(cpu_startup_entry+0xa4/0x108)
[ 6868.004421] [<c0261538>] (cpu_startup_entry) from [<80208584>] 
(0x80208584)
[ 6868.011402] Rebooting in 3 seconds..



On 11/29/2017 01:33 PM, Rajkumar Manoharan wrote:
> With current NAPI implementation, NAPI poll can deliver more frames
> to net core than allotted budget. This may cause warning in napi_poll.
> Remaining quota is not accounted, while processing amsdus in
> rx_in_ord_ind and rx_ind queue. Adding num_msdus at last can not
> prevent delivering more frames to net core. With this change,
> all amdus from both in_ord_ind and rx_ind queues are processed and
> enqueued into common skb list instead of delivering into mac80211.
> Later msdus from common queue are dequeued and delivered depends on
> quota availability. This change also simplifies the rx processing in
> napi poll routine.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath10k/core.h   |   1 -
>   drivers/net/wireless/ath/ath10k/htt.h    |   2 +-
>   drivers/net/wireless/ath/ath10k/htt_rx.c | 121 ++++++++++++++++---------------
>   3 files changed, 63 insertions(+), 61 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 643041ef3271..6ecc58811656 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -67,7 +67,6 @@
>   
>   /* NAPI poll budget */
>   #define ATH10K_NAPI_BUDGET      64
> -#define ATH10K_NAPI_QUOTA_LIMIT 60
>   
>   /* SMBIOS type containing Board Data File Name Extension */
>   #define ATH10K_SMBIOS_BDF_EXT_TYPE 0xF8
> diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
> index 6305308422c4..7d6143523634 100644
> --- a/drivers/net/wireless/ath/ath10k/htt.h
> +++ b/drivers/net/wireless/ath/ath10k/htt.h
> @@ -1695,7 +1695,7 @@ struct ath10k_htt {
>   	/* This is used to group tx/rx completions separately and process them
>   	 * in batches to reduce cache stalls
>   	 */
> -	struct sk_buff_head rx_compl_q;
> +	struct sk_buff_head rx_msdus_q;
>   	struct sk_buff_head rx_in_ord_compl_q;
>   	struct sk_buff_head tx_fetch_ind_q;
>   
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index e31438541ee1..d82f26dbba44 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -227,7 +227,7 @@ void ath10k_htt_rx_free(struct ath10k_htt *htt)
>   {
>   	del_timer_sync(&htt->rx_ring.refill_retry_timer);
>   
> -	skb_queue_purge(&htt->rx_compl_q);
> +	skb_queue_purge(&htt->rx_msdus_q);
>   	skb_queue_purge(&htt->rx_in_ord_compl_q);
>   	skb_queue_purge(&htt->tx_fetch_ind_q);
>   
> @@ -515,7 +515,7 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
>   	htt->rx_ring.sw_rd_idx.msdu_payld = 0;
>   	hash_init(htt->rx_ring.skb_table);
>   
> -	skb_queue_head_init(&htt->rx_compl_q);
> +	skb_queue_head_init(&htt->rx_msdus_q);
>   	skb_queue_head_init(&htt->rx_in_ord_compl_q);
>   	skb_queue_head_init(&htt->tx_fetch_ind_q);
>   	atomic_set(&htt->num_mpdus_ready, 0);
> @@ -951,16 +951,25 @@ static char *ath10k_get_tid(struct ieee80211_hdr *hdr, char *out, size_t size)
>   	return out;
>   }
>   
> -static void ath10k_process_rx(struct ath10k *ar,
> -			      struct ieee80211_rx_status *rx_status,
> -			      struct sk_buff *skb)
> +static void ath10k_htt_rx_h_queue_msdu(struct ath10k *ar,
> +				       struct ieee80211_rx_status *rx_status,
> +				       struct sk_buff *skb)
> +{
> +	struct ieee80211_rx_status *status;
> +
> +	status = IEEE80211_SKB_RXCB(skb);
> +	*status = *rx_status;
> +
> +	__skb_queue_tail(&ar->htt.rx_msdus_q, skb);
> +}
> +
> +static void ath10k_process_rx(struct ath10k *ar, struct sk_buff *skb)
>   {
>   	struct ieee80211_rx_status *status;
>   	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>   	char tid[32];
>   
>   	status = IEEE80211_SKB_RXCB(skb);
> -	*status = *rx_status;
>   
>   	ath10k_dbg(ar, ATH10K_DBG_DATA,
>   		   "rx skb %pK len %u peer %pM %s %s sn %u %s%s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
> @@ -1492,7 +1501,7 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
>   	}
>   }
>   
> -static void ath10k_htt_rx_h_deliver(struct ath10k *ar,
> +static void ath10k_htt_rx_h_enqueue(struct ath10k *ar,
>   				    struct sk_buff_head *amsdu,
>   				    struct ieee80211_rx_status *status)
>   {
> @@ -1515,7 +1524,7 @@ static void ath10k_htt_rx_h_deliver(struct ath10k *ar,
>   			status->flag |= RX_FLAG_ALLOW_SAME_PN;
>   		}
>   
> -		ath10k_process_rx(ar, status, msdu);
> +		ath10k_htt_rx_h_queue_msdu(ar, status, msdu);
>   	}
>   }
>   
> @@ -1627,7 +1636,7 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
>   	struct ath10k *ar = htt->ar;
>   	struct ieee80211_rx_status *rx_status = &htt->rx_status;
>   	struct sk_buff_head amsdu;
> -	int ret, num_msdus;
> +	int ret;
>   
>   	__skb_queue_head_init(&amsdu);
>   
> @@ -1649,7 +1658,6 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
>   		return ret;
>   	}
>   
> -	num_msdus = skb_queue_len(&amsdu);
>   	ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status, 0xffff);
>   
>   	/* only for ret = 1 indicates chained msdus */
> @@ -1658,9 +1666,9 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
>   
>   	ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
>   	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status, true);
> -	ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);
> +	ath10k_htt_rx_h_enqueue(ar, &amsdu, rx_status);
>   
> -	return num_msdus;
> +	return 0;
>   }
>   
>   static void ath10k_htt_rx_proc_rx_ind(struct ath10k_htt *htt,
> @@ -1868,15 +1876,14 @@ static void ath10k_htt_rx_h_rx_offload_prot(struct ieee80211_rx_status *status,
>   			RX_FLAG_MMIC_STRIPPED;
>   }
>   
> -static int ath10k_htt_rx_h_rx_offload(struct ath10k *ar,
> -				      struct sk_buff_head *list)
> +static void ath10k_htt_rx_h_rx_offload(struct ath10k *ar,
> +				       struct sk_buff_head *list)
>   {
>   	struct ath10k_htt *htt = &ar->htt;
>   	struct ieee80211_rx_status *status = &htt->rx_status;
>   	struct htt_rx_offload_msdu *rx;
>   	struct sk_buff *msdu;
>   	size_t offset;
> -	int num_msdu = 0;
>   
>   	while ((msdu = __skb_dequeue(list))) {
>   		/* Offloaded frames don't have Rx descriptor. Instead they have
> @@ -1915,10 +1922,8 @@ static int ath10k_htt_rx_h_rx_offload(struct ath10k *ar,
>   
>   		ath10k_htt_rx_h_rx_offload_prot(status, msdu);
>   		ath10k_htt_rx_h_channel(ar, status, NULL, rx->vdev_id);
> -		ath10k_process_rx(ar, status, msdu);
> -		num_msdu++;
> +		ath10k_htt_rx_h_queue_msdu(ar, status, msdu);
>   	}
> -	return num_msdu;
>   }
>   
>   static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
> @@ -1934,7 +1939,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
>   	u8 tid;
>   	bool offload;
>   	bool frag;
> -	int ret, num_msdus = 0;
> +	int ret;
>   
>   	lockdep_assert_held(&htt->rx_ring.lock);
>   
> @@ -1976,7 +1981,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
>   	 * separately.
>   	 */
>   	if (offload)
> -		num_msdus = ath10k_htt_rx_h_rx_offload(ar, &list);
> +		ath10k_htt_rx_h_rx_offload(ar, &list);
>   
>   	while (!skb_queue_empty(&list)) {
>   		__skb_queue_head_init(&amsdu);
> @@ -1989,11 +1994,10 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
>   			 * better to report something than nothing though. This
>   			 * should still give an idea about rx rate to the user.
>   			 */
> -			num_msdus += skb_queue_len(&amsdu);
>   			ath10k_htt_rx_h_ppdu(ar, &amsdu, status, vdev_id);
>   			ath10k_htt_rx_h_filter(ar, &amsdu, status);
>   			ath10k_htt_rx_h_mpdu(ar, &amsdu, status, false);
> -			ath10k_htt_rx_h_deliver(ar, &amsdu, status);
> +			ath10k_htt_rx_h_enqueue(ar, &amsdu, status);
>   			break;
>   		case -EAGAIN:
>   			/* fall through */
> @@ -2005,7 +2009,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
>   			return -EIO;
>   		}
>   	}
> -	return num_msdus;
> +	return ret;
>   }
>   
>   static void ath10k_htt_rx_tx_fetch_resp_id_confirm(struct ath10k *ar,
> @@ -2606,6 +2610,24 @@ void ath10k_htt_rx_pktlog_completion_handler(struct ath10k *ar,
>   }
>   EXPORT_SYMBOL(ath10k_htt_rx_pktlog_completion_handler);
>   
> +static int ath10k_htt_rx_deliver_msdu(struct ath10k *ar, int quota, int budget)
> +{
> +	struct sk_buff *skb;
> +
> +	while (quota < budget) {
> +		if (skb_queue_empty(&ar->htt.rx_msdus_q))
> +			break;
> +
> +		skb = __skb_dequeue(&ar->htt.rx_msdus_q);
> +		if (!skb)
> +			break;
> +		ath10k_process_rx(ar, skb);
> +		quota++;
> +	}
> +
> +	return quota;
> +}
> +
>   int ath10k_htt_txrx_compl_task(struct ath10k *ar, int budget)
>   {
>   	struct ath10k_htt *htt = &ar->htt;
> @@ -2613,63 +2635,44 @@ int ath10k_htt_txrx_compl_task(struct ath10k *ar, int budget)
>   	struct sk_buff_head tx_ind_q;
>   	struct sk_buff *skb;
>   	unsigned long flags;
> -	int quota = 0, done, num_rx_msdus;
> +	int quota = 0, done, ret;
>   	bool resched_napi = false;
>   
>   	__skb_queue_head_init(&tx_ind_q);
>   
> -	/* Since in-ord-ind can deliver more than 1 A-MSDU in single event,
> -	 * process it first to utilize full available quota.
> +	/* Process pending frames before dequeuing more data
> +	 * from hardware.
>   	 */
> -	while (quota < budget) {
> -		if (skb_queue_empty(&htt->rx_in_ord_compl_q))
> -			break;
> -
> -		skb = __skb_dequeue(&htt->rx_in_ord_compl_q);
> -		if (!skb) {
> -			resched_napi = true;
> -			goto exit;
> -		}
> +	quota = ath10k_htt_rx_deliver_msdu(ar, quota, budget);
> +	if (quota == budget) {
> +		resched_napi = true;
> +		goto exit;
> +	}
>   
> +	while ((skb = __skb_dequeue(&htt->rx_in_ord_compl_q))) {
>   		spin_lock_bh(&htt->rx_ring.lock);
> -		num_rx_msdus = ath10k_htt_rx_in_ord_ind(ar, skb);
> +		ret = ath10k_htt_rx_in_ord_ind(ar, skb);
>   		spin_unlock_bh(&htt->rx_ring.lock);
> -		if (num_rx_msdus < 0) {
> -			resched_napi = true;
> -			goto exit;
> -		}
>   
>   		dev_kfree_skb_any(skb);
> -		if (num_rx_msdus > 0)
> -			quota += num_rx_msdus;
> -
> -		if ((quota > ATH10K_NAPI_QUOTA_LIMIT) &&
> -		    !skb_queue_empty(&htt->rx_in_ord_compl_q)) {
> +		if (ret == -EIO) {
>   			resched_napi = true;
>   			goto exit;
>   		}
>   	}
>   
> -	while (quota < budget) {
> -		/* no more data to receive */
> -		if (!atomic_read(&htt->num_mpdus_ready))
> -			break;
> -
> -		num_rx_msdus = ath10k_htt_rx_handle_amsdu(htt);
> -		if (num_rx_msdus < 0) {
> +	while (atomic_read(&htt->num_mpdus_ready)) {
> +		ret = ath10k_htt_rx_handle_amsdu(htt);
> +		if (ret == -EIO) {
>   			resched_napi = true;
>   			goto exit;
>   		}
> -
> -		quota += num_rx_msdus;
>   		atomic_dec(&htt->num_mpdus_ready);
> -		if ((quota > ATH10K_NAPI_QUOTA_LIMIT) &&
> -		    atomic_read(&htt->num_mpdus_ready)) {
> -			resched_napi = true;
> -			goto exit;
> -		}
>   	}
>   
> +	/* Deliver received data after processing data from hardware */
> +	quota = ath10k_htt_rx_deliver_msdu(ar, quota, budget);
> +
>   	/* From NAPI documentation:
>   	 *  The napi poll() function may also process TX completions, in which
>   	 *  case if it processes the entire TX ring then it should count that

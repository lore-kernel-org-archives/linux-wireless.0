Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx01.mykolab.com ([95.128.36.1]:25148 "EHLO mx04.mykolab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbaJILNJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 07:13:09 -0400
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 09 Oct 2014 13:06:35 +0200
From: "Schroer, Jens Peter" <jens.schroer@scypho.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Kernel Oops with =?UTF-8?Q?ath=39k=5Fhtc=20during=20AES=20decrypt?=
 =?UTF-8?Q?=20on=20ARM=20/=20BeagleBone=20Black?=
Message-ID: <51054a8c690db75aa1efacb98e4379c9@scypho.com> (sfid-20141009_131316_839338_5F7D82F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

While running a iperf test, I experienced a kernel Oops in the Wifi / 
crypto module. I tried to reproduce it, but only managed to do it once 
so far.

The system is:
BeagleBone Black, Rev C
Kernel 3.17.0-bone4 from BeagleBone
Using debian Jessie for Arm
Wifi: Netgear WNA1100

lsusb:
Bus 002 Device 003: ID 0846:9030 NetGear, Inc. WNA1100 Wireless-N 150 
[Atheros AR9271]
Bus 002 Device 002: ID 1a40:0201 Terminus Technology Inc. FE 2.1 7-port 
Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Scenario:

I am running
iperf -c 192.168.1.32 -i1 -t300 -w1000k
to test network performance

During this test I got the following kernel Oops (see below).
Is this a known issue (I couldn't find anything related on Google so 
far)?

Kind regards,
Jens


[   72.919376] kernel BUG at crypto/scatterwalk.c:37!
[   72.924396] Internal error: Oops - BUG: 0 [#1] THUMB2
[   72.929691] Modules linked in: ctr ccm omap_aes omap_sham evdev arc4 
ath9k_htc ath9k_common ath9k_hw ath mac80211 cfg80211
[   72.941329] CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-bone4 #1
[   72.947902] task: c09baf68 ti: c09ae000 task.ti: c09ae000
[   72.953577] PC is at scatterwalk_start+0x12/0x14
[   72.958417] LR is at scatterwalk_map_and_copy+0x23/0x84
[   72.963894] pc : [<c02eda8a>]    lr : [<c02edbd7>]    psr: 20010133
[   72.963894] sp : c09afac8  ip : 00000000  fp : c09afcf4
[   72.975930] r10: 00000000  r9 : 00000000  r8 : 00000008
[   72.981405] r7 : c09afb98  r6 : 00000008  r5 : c09afccc  r4 : 
00000000
[   72.988245] r3 : 00000000  r2 : 00000000  r1 : c09afccc  r0 : 
c09afac8
[   72.995089] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  
Segment kernel
[   73.002933] Control: 50c5387d  Table: 9bf9c019  DAC: 00000015
[   73.008954] Process swapper (pid: 0, stack limit = 0xc09ae240)
[   73.015066] Stack: (0xc09afac8 to 0xc09b0000)
[   73.019633] fac0:                   c09afccc bf98f2c7 00000006 
c09afb78 c09afb38 de356580
[   73.028210] fae0: c09afd7c 00000008 c09afb98 bf9bb933 00000000 
dbfa1b80 de458fa0 bf990e67
[   73.036786] fb00: dbfa1b80 de458fa0 00000000 c09afbb0 00000006 
de356580 c09afb38 00000a34
[   73.045360] fb20: c09afcc0 c09afd08 dbfd7a34 00000000 c09afcf4 
bf891a51 00000000 00000000
[   73.053935] fb40: 00000000 00000000 de356580 00000000 00000018 
00000008 c09afd7c c09afcf4
[   73.062510] fb60: c09afccc c09afd08 00000000 00000000 00000000 
00000000 00000000 00000000
[   73.071085] fb80: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[   73.079659] fba0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[   73.088233] fbc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[   73.096807] fbe0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[   73.105382] fc00: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[   73.113956] fc20: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[   73.122531] fc40: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[   73.131106] fc60: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[   73.139681] fc80: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[   73.148256] fca0: 00000000 00000000 00000000 00000000 00000000 
00000000 0000007f bf886a79
[   73.156831] fcc0: de546700 c09afd7c 00000040 dfe70ae0 00000a34 
00000000 00000000 00000000
[   73.165406] fce0: dfe70ae2 00000a34 00000008 00000000 00000000 
dfb045e2 00000d5e 00000018
[   73.173980] fd00: 00000000 00000000 dfe70ae2 00000a34 00000000 
00000000 00000000 dc8cb300
[   73.182557] fd20: 00000000 dd54f100 c09b7008 0000001a dd4af000 
dbfd7a34 dbfd7a12 00000000
[   73.191132] fd40: 00000000 bf886a79 00000000 dbfd7a34 00000006 
00000000 f0800000 42881800
[   73.199708] fd60: 7a1504c4 eebc1b89 5e9c557b e76e6008 00004996 
00000000 00000000 eebc0001
[   73.208282] fd80: 5e9c557b 00000000 dd56f080 dc8cb300 c09afe54 
dd54f100 c09afe2c c09afe54
[   73.216858] fda0: 00004a88 dbfd7a12 c09ae000 00004000 00000000 
bf897719 00000000 c006a6c5
[   73.225434] fdc0: 0003a980 00000000 00989680 00000000 684e00f5 
00000000 c09dc848 c09baf68
[   73.234009] fde0: 00000000 bf896ed9 0000002c 00000040 00000000 
bf896ed9 00000001 0000002d
[   73.242583] fe00: 00989680 c09afe54 de4583a0 de530c84 c09ddf68 
00000000 00200200 dbf87b2c
[   73.251158] fe20: bf88a83d bf899925 264a8a64 dd54f100 de4583a0 
dd562500 dbf87800 dd4af000
[   73.259733] fe40: 00000000 00000000 00000000 00000000 00000000 
de532580 dd54f4c0 00000036
[   73.268309] fe60: f764151b c09ae000 00000100 bf88a855 c0a447c0 
c005fe3f 00000001 c006a53b
[   73.276883] fe80: 00000000 de530c84 c0a9aa00 c09afec0 c09ddf68 
00000000 00200200 c0a30d30
[   73.285458] fea0: 00000004 c00603ad f76400ec 00000010 bf88a83d 
dbf87b2c 00000000 00200200
[   73.294033] fec0: c09afec0 c09afec0 c0a187d8 c0a57b44 00000002 
c09ae000 00000054 00000001
[   73.302607] fee0: c0a44ab8 c0a30d30 00000004 c00331fd 00000010 
c09df0e0 00000002 00000100
[   73.311182] ff00: c0a57b40 0000000a ffffa748 00200000 00000054 
c09ae000 00000000 00000054
[   73.319756] ff20: 00000054 c09aff68 c0a44ab8 c0a30d30 ffffffed 
c003352b c0a091a8 c000dda3
[   73.328331] ff40: fa200098 fa2000b8 fa2000d8 c000847b c000deb6 
40010033 ffffffff c09aff9c
[   73.336908] ff60: 00000000 c05b6e1b ffffffed 00000000 00000000 
c00197e1 c09ae000 00000000
[   73.345483] ff80: c09b70e4 00000000 00000000 c0a44ab8 c0a30d30 
ffffffed 00000000 c09affb0
[   73.354057] ffa0: c000deb5 c000deb6 40010033 ffffffff 00000000 
c004b2a9 00000000 c097b660
[   73.362632] ffc0: 00000000 c09418c5 ffffffff ffffffff c09414d5 
00000000 c097b660 dc8cb300
[   73.371208] ffe0: c0a566d4 c09b7074 c097b65c c09bc3d0 80004059 
80008079 00000000 00000000
[   73.379796] [<c02eda8a>] (scatterwalk_start) from [<c02edbd7>] 
(scatterwalk_map_and_copy+0x23/0x84)
[   73.389297] [<c02edbd7>] (scatterwalk_map_and_copy) from [<bf9bb933>] 
(crypto_ccm_decrypt+0x62/0x190 [ccm])
[   73.399802] [<bf9bb933>] (crypto_ccm_decrypt [ccm]) from [<bf891a51>] 
(ieee80211_aes_ccm_decrypt+0xdc/0x120 [mac80211])
[   73.411258] [<bf891a51>] (ieee80211_aes_ccm_decrypt [mac80211]) from 
[<bf886a79>] (ieee80211_crypto_ccmp_decrypt+0x1b0/0x1e4 [mac80211])
[   73.424265] [<bf886a79>] (ieee80211_crypto_ccmp_decrypt [mac80211]) 
from [<bf897719>] (ieee80211_rx_handlers+0x714/0x1b34 [mac80211])
[   73.437018] [<bf897719>] (ieee80211_rx_handlers [mac80211]) from 
[<bf899925>] (ieee80211_release_reorder_timeout+0x48/0x4c [mac80211])
[   73.449838] [<bf899925>] (ieee80211_release_reorder_timeout 
[mac80211]) from [<bf88a855>] 
(sta_rx_agg_reorder_timer_expired+0x18/0x1c [mac80211])
[   73.463586] [<bf88a855>] (sta_rx_agg_reorder_timer_expired 
[mac80211]) from [<c005fe3f>] (call_timer_fn+0x2b/0xcc)
[   73.474445] [<c005fe3f>] (call_timer_fn) from [<c00603ad>] 
(run_timer_softirq+0x145/0x198)
[   73.483117] [<c00603ad>] (run_timer_softirq) from [<c00331fd>] 
(__do_softirq+0x65/0x1ec)
[   73.491604] [<c00331fd>] (__do_softirq) from [<c003352b>] 
(irq_exit+0x63/0x98)
[   73.499185] [<c003352b>] (irq_exit) from [<c000dda3>] 
(handle_IRQ+0x27/0x5c)
[   73.506580] [<c000dda3>] (handle_IRQ) from [<c000847b>] 
(omap3_intc_handle_irq+0x63/0x74)
[   73.515167] [<c000847b>] (omap3_intc_handle_irq) from [<c05b6e1b>] 
(__irq_svc+0x3b/0x5c)
[   73.523648] Exception stack(0xc09aff68 to 0xc09affb0)
[   73.528943] ff60:                   ffffffed 00000000 00000000 
c00197e1 c09ae000 00000000
[   73.537518] ff80: c09b70e4 00000000 00000000 c0a44ab8 c0a30d30 
ffffffed 00000000 c09affb0
[   73.546092] ffa0: c000deb5 c000deb6 40010033 ffffffff
[   73.551392] [<c05b6e1b>] (__irq_svc) from [<c000deb6>] 
(arch_cpu_idle+0x1e/0x28)
[   73.559153] [<c000deb6>] (arch_cpu_idle) from [<c004b2a9>] 
(cpu_startup_entry+0x111/0x1a8)
[   73.567829] [<c004b2a9>] (cpu_startup_entry) from [<c09418c5>] 
(start_kernel+0x279/0x2e4)
[   73.576406] Code: b113 684b 6043 4770 (de02) b510
[   73.581430] ---[ end trace fad732941e738de9 ]---
[   73.586268] Kernel panic - not syncing: Fatal exception in interrupt
[   73.592929] drm_kms_helper: panic occurred, switching back to text 
console
[   73.600148] ---[ end Kernel panic - not syncing: Fatal exception in 
interrupt


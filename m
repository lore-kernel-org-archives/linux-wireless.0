Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx01.mykolab.com ([95.128.36.1]:44343 "EHLO mx05.mykolab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612AbaJIM3Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 08:29:16 -0400
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 09 Oct 2014 14:28:58 +0200
From: "Schroer, Jens Peter" <jens.schroer@scypho.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: =?UTF-8?Q?Ath=39k=5Fhtc=2C=20ARM=20/=20BeagleBone=20Black=2C=20ke?=
 =?UTF-8?Q?rnel=20=33=2E=31=37=20-=20iperf=20freezes=20with=20kernel=20war?=
 =?UTF-8?Q?ning?=
Message-ID: <43caa56f267b0f10faf2cff20260d30e@scypho.com> (sfid-20141009_142920_884016_26F848F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I continued my iperf experiments, but experienced a freeze in iperf 
during the test. Upon further investigation I saw a lot of spew from the 
kernel in the log files.

The system is:
BeagleBone Black, Rev C
Kernel 3.17.0-bone4 from BeagleBone
Using debian Jessie for Arm
Wifi: Netgear WNA1100 on a powered USB hub

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

Kernel output:

[ 1079.434044] ------------[ cut here ]------------
[ 1079.434440] WARNING: CPU: 0 PID: 0 at net/mac80211/rx.c:3399 
ieee80211_rx+0x566/0x59c [mac80211]()
[ 1079.434660] Rate marked as an HT rate but passed status->rate_idx is 
not an MCS index [0-76]: 125 (0x7d)
[ 1079.434710] Modules linked in: ctr ccm omap_aes omap_sham evdev arc4 
ath9k_htc ath9k_common ath9k_hw ath mac80211 cfg80211
[ 1079.434748] CPU: 0 PID: 0 Comm: swapper Tainted: G W 3.17.0-bone4 #1
[ 1079.434856] [<c0011bbd>] (unwind_backtrace) from [<c000fa41>] 
(show_stack+0x11/0x14)
[ 1079.434933] [<c000fa41>] (show_stack) from [<c00311c1>] 
(warn_slowpath_common+0x51/0x6c)
[ 1079.434948] [<c00311c1>] (warn_slowpath_common) from [<c0031247>] 
(warn_slowpath_fmt+0x23/0x2c)
[ 1079.435091] [<c0031247>] (warn_slowpath_fmt) from [<bf8998a7>] 
(ieee80211_rx+0x566/0x59c [mac80211])
[ 1079.435342] [<bf8998a7>] (ieee80211_rx [mac80211]) from [<bf991f1d>] 
(ath9k_rx_tasklet+0x250/0x284 [ath9k_htc])
[ 1079.435474] [<bf991f1d>] (ath9k_rx_tasklet [ath9k_htc]) from 
[<c003377b>] (tasklet_action+0x3f/0x68)
[ 1079.435488] [<c003377b>] (tasklet_action) from [<c00331fd>] 
(__do_softirq+0x65/0x1ec)
[ 1079.435499] [<c00331fd>] (__do_softirq) from [<c003352b>] 
(irq_exit+0x63/0x98)
[ 1079.435567] [<c003352b>] (irq_exit) from [<c000dda3>] 
(handle_IRQ+0x27/0x5c)
[ 1079.435627] [<c000dda3>] (handle_IRQ) from [<c000847b>] 
(omap3_intc_handle_irq+0x63/0x74)
[ 1079.435650] [<c000847b>] (omap3_intc_handle_irq) from [<c05b6e1b>] 
(__irq_svc+0x3b/0x5c)
[ 1079.435657] Exception stack(0xc09aff68 to 0xc09affb0)
[ 1079.435667] ff60: ffffffed 00000000 00000000 c00197e1 c09ae000 
00000000
[ 1079.435677] ff80: c09b70e4 00000000 00000000 c0a44ab8 c0a30d30 
ffffffed c09affa0 c09affb0
[ 1079.435685] ffa0: c000deb5 c000deb6 40010033 ffffffff
[ 1079.435700] [<c05b6e1b>] (__irq_svc) from [<c000deb6>] 
(arch_cpu_idle+0x1e/0x28)
[ 1079.435715] [<c000deb6>] (arch_cpu_idle) from [<c004b2a9>] 
(cpu_startup_entry+0x111/0x1a8)
[ 1079.435734] [<c004b2a9>] (cpu_startup_entry) from [<c09418c5>] 
(start_kernel+0x279/0x2e4)
[ 1079.435741] ---[ end trace ecfa63025e0ecf98 ]---
[ 1091.044433] ------------[ cut here ]------------
[ 1091.044785] WARNING: CPU: 0 PID: 0 at net/mac80211/rx.c:3399 
ieee80211_rx+0x566/0x59c [mac80211]()
[ 1091.044865] Rate marked as an HT rate but passed status->rate_idx is 
not an MCS index [0-76]: 127 (0x7f)
[ 1091.044915] Modules linked in: ctr ccm omap_aes omap_sham evdev arc4 
ath9k_htc ath9k_common ath9k_hw ath mac80211 cfg80211
[ 1091.045050] CPU: 0 PID: 0 Comm: swapper Tainted: G W 3.17.0-bone4 #1
[ 1091.045096] [<c0011bbd>] (unwind_backtrace) from [<c000fa41>] 
(show_stack+0x11/0x14)
[ 1091.045204] [<c000fa41>] (show_stack) from [<c00311c1>] 
(warn_slowpath_common+0x51/0x6c)
[ 1091.045265] [<c00311c1>] (warn_slowpath_common) from [<c0031247>] 
(warn_slowpath_fmt+0x23/0x2c)
[ 1091.045411] [<c0031247>] (warn_slowpath_fmt) from [<bf8998a7>] 
(ieee80211_rx+0x566/0x59c [mac80211])
[ 1091.045658] [<bf8998a7>] (ieee80211_rx [mac80211]) from [<bf991f1d>] 
(ath9k_rx_tasklet+0x250/0x284 [ath9k_htc])
[ 1091.045796] [<bf991f1d>] (ath9k_rx_tasklet [ath9k_htc]) from 
[<c003377b>] (tasklet_action+0x3f/0x68)
[ 1091.045810] [<c003377b>] (tasklet_action) from [<c00331fd>] 
(__do_softirq+0x65/0x1ec)
[ 1091.045821] [<c00331fd>] (__do_softirq) from [<c003352b>] 
(irq_exit+0x63/0x98)
[ 1091.045894] [<c003352b>] (irq_exit) from [<c000dda3>] 
(handle_IRQ+0x27/0x5c)
[ 1091.045951] [<c000dda3>] (handle_IRQ) from [<c000847b>] 
(omap3_intc_handle_irq+0x63/0x74)
[ 1091.045974] [<c000847b>] (omap3_intc_handle_irq) from [<c05b6e1b>] 
(__irq_svc+0x3b/0x5c)
[ 1091.045981] Exception stack(0xc09aff68 to 0xc09affb0)
[ 1091.045991] ff60: ffffffed 00000000 00000000 c00197e1 c09ae000 
00000000
[ 1091.046002] ff80: c09b70e4 00000000 00000000 c0a44ab8 c0a30d30 
ffffffed c09affa0 c09affb0
[ 1091.046010] ffa0: c000deb5 c000deb6 40010033 ffffffff
[ 1091.046024] [<c05b6e1b>] (__irq_svc) from [<c000deb6>] 
(arch_cpu_idle+0x1e/0x28)
[ 1091.046039] [<c000deb6>] (arch_cpu_idle) from [<c004b2a9>] 
(cpu_startup_entry+0x111/0x1a8)
[ 1091.046058] [<c004b2a9>] (cpu_startup_entry) from [<c09418c5>] 
(start_kernel+0x279/0x2e4)
[ 1091.046065] ---[ end trace ecfa63025e0ecf99 ]---

I found several posts with similiar errors on google, but all of them 
were related to older kernel versions (pre 3.16 I think) and were 
supposed to be fixed.

I have not done kernel development before, and am not experienced with 
the technical details of Wifi.
However, I am happy to try to dig into this issue if I could get some 
guidance.

Kind regards,
Jens

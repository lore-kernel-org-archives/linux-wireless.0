Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ls405.t-com.hr ([195.29.150.135]:55919 "EHLO ls405.t-com.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759286AbZJNUf2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 16:35:28 -0400
Received: from ls266.t-com.hr (ls266.t-com.hr [195.29.150.94])
	by ls405.t-com.hr (Postfix) with ESMTP id 9E28A41C94
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 22:24:13 +0200 (CEST)
Received: from ls266.t-com.hr (localhost.localdomain [127.0.0.1])
	by ls266.t-com.hr (Qmlai) with ESMTP id 92CAFC58240
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 22:24:13 +0200 (CEST)
Received: from ls266.t-com.hr (localhost.localdomain [127.0.0.1])
	by ls266.t-com.hr (Qmlai) with ESMTP id 7B926C5823D
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 22:24:13 +0200 (CEST)
Received: from [10.21.41.3] (93-143-30-180.adsl.net.t-com.hr [93.143.30.180])
	by ls266.t-com.hr (Qmali) with ESMTP id 1E9BF12027A
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 22:24:12 +0200 (CEST)
Message-ID: <4AD63365.4040403@gmail.com>
Date: Wed, 14 Oct 2009 22:24:05 +0200
From: Marin Glibic <zhilla2@gmail.com>
Reply-To: zhilla2@gmail.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: AP: ath5k + hostapd occasionally sulks
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've also been hit by this bug, mentioned last month - but he guy had no 
additional info. This is with compat-wireless 2009-10-09 and linux 
2.6.31.3, all in master mode, using recent hostapd from git.
Might also be two bugs... first one being module warning and "ath5k 
phy0: no further txbuf available, dropping packet" the other.


Oct 14 18:18:28 machinename kernel: ------------[ cut here ]------------
Oct 14 18:18:28 machinename kernel: WARNING: at 
/source/compat/compat-wireless-2009-10-09/net/mac80211/rc80211_minstrel.c:69 
minstrel_tx_status+0xdf/0x100 [mac80211]()
Oct 14 18:18:28 machinename kernel: Hardware name: KT600-8237
Oct 14 18:18:28 machinename kernel: Modules linked in: lp fuse ppdev 
parport_pc rtc_cmos parport rtc_core rtc_lib fan ath5k mac80211 ath 
processor uhci_hcd thermal thermal_sys cfg80211 hwmon button i2c_viapro rfk
ill i2c_core 3c59x led_class ehci_hcd shpchp via_agp evdev mii agpgart sg
Oct 14 18:18:28 machinename kernel: Pid: 0, comm: swapper Not tainted 
2.6.31.3-smp #2
Oct 14 18:18:28 machinename kernel: Call Trace:
Oct 14 18:18:28 machinename kernel:  [<c13cd9c0>] ? printk+0x18/0x20
Oct 14 18:18:28 machinename kernel:  [<e0a8ce2f>] ? 
minstrel_tx_status+0xdf/0x100 [mac80211]
Oct 14 18:18:28 machinename kernel:  [<c1032afc>] 
warn_slowpath_common+0x6c/0xc0
Oct 14 18:18:28 machinename kernel:  [<e0a8ce2f>] ? 
minstrel_tx_status+0xdf/0x100 [mac80211]
Oct 14 18:18:28 machinename kernel:  [<c1032b65>] 
warn_slowpath_null+0x15/0x20
Oct 14 18:18:28 machinename kernel:  [<e0a8ce2f>] 
minstrel_tx_status+0xdf/0x100 [mac80211]
Oct 14 18:18:28 machinename kernel:  [<e0a6fc8c>] 
ieee80211_tx_status+0x47c/0x4d0 [mac80211]
Oct 14 18:18:28 machinename kernel:  [<e0ad1293>] 
ath5k_tasklet_tx+0x203/0x3b0 [ath5k]
Oct 14 18:18:28 machinename kernel:  [<e0ac5883>] ? 
ath5k_hw_get_isr+0x223/0x3a0 [ath5k]
Oct 14 18:18:28 machinename kernel:  [<c1037430>] tasklet_action+0x50/0xb0
Oct 14 18:18:28 machinename kernel:  [<c10382aa>] __do_softirq+0xba/0x180
Oct 14 18:18:28 machinename kernel:  [<c10660c8>] ? 
handle_IRQ_event+0x58/0x140
Oct 14 18:18:28 machinename kernel:  [<c1018dce>] ? 
ack_apic_level+0x7e/0x270
Oct 14 18:18:28 machinename kernel:  [<c103839d>] do_softirq+0x2d/0x40
Oct 14 18:18:28 machinename kernel:  [<c10384f5>] irq_exit+0x65/0x90
Oct 14 18:18:28 machinename kernel:  [<c1004d3f>] do_IRQ+0x4f/0xc0
Oct 14 18:18:28 machinename kernel:  [<c104c7a9>] ? ktime_get+0x19/0x40
Oct 14 18:18:28 machinename kernel:  [<c10034e9>] common_interrupt+0x29/0x30
Oct 14 18:18:28 machinename kernel:  [<e0a1f381>] ? 
acpi_idle_enter_simple+0x132/0x15d [processor]
Oct 14 18:18:28 machinename kernel:  [<c1324c7f>] 
cpuidle_idle_call+0x6f/0xc0
Oct 14 18:18:28 machinename kernel:  [<c1001efd>] cpu_idle+0x4d/0x80
Oct 14 18:18:28 machinename kernel:  [<c13bd835>] rest_init+0x55/0x60
Oct 14 18:18:28 machinename kernel:  [<c15498a5>] start_kernel+0x2d5/0x338
Oct 14 18:18:28 machinename kernel:  [<c1549386>] ? 
unknown_bootoption+0x0/0x1f9
Oct 14 18:18:28 machinename kernel:  [<c1549079>] 
i386_start_kernel+0x79/0x81
Oct 14 18:18:28 machinename kernel: ---[ end trace 86949b8386bc65bb ]---

and then bit later:

Oct 14 20:22:02 machinename kernel: ath5k phy0: no further txbuf 
available, dropping packet
Oct 14 20:22:32 machinename last message repeated 4 times
Oct 14 20:23:33 machinename last message repeated 8 times
Oct 14 20:24:35 machinename last message repeated 8 times
Oct 14 20:25:33 machinename last message repeated 7 times
Oct 14 20:26:33 machinename last message repeated 8 times
Oct 14 20:27:33 machinename last message repeated 8 times
Oct 14 20:28:33 machinename last message repeated 8 times
and lot of these. Network traffic goes down. And even when it works, 
network traffic is very slow (<50kB/s)



some hw info:

2.6.31.3-smp #2 SMP Sat Oct 10 22:25:14 CEST 2009 i686 AMD Athlon(tm) XP 
2000+ AuthenticAMD GNU/Linux

00:0a.0 Ethernet controller [0200]: Atheros Communications Inc. Atheros 
AR5001X+ Wireless Network Adapter [168c:0013] (rev 01)
         Subsystem: Wistron NeWeb Corp. CM9 Wireless a/b/g MiniPCI 
Adapter [185f:1012]
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 168 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 17
         Region 0: Memory at dd000000 (32-bit, non-prefetchable) [size=64K]
         Capabilities: [44] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
         Kernel driver in use: ath5k
         Kernel modules: ath5k

Hopefully somebody will catch this. Thanks.

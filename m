Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39639 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab1DETZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 15:25:51 -0400
Received: by qwk3 with SMTP id 3so438313qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 12:25:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
Date: Tue, 5 Apr 2011 21:25:50 +0200
Message-ID: <BANLkTinqec-S2WbanoDHvhu4bz4M-vhB-g@mail.gmail.com>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	Arend van Spriel <arend@broadcom.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/5 Rafał Miłecki <zajec5@gmail.com>:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> I believe this driver implements AI support in the proper way. This introduces
> support for the *bus* and lets drivers register for specific cores. It was
> tested with b43 and BCM4313, reading PHY info works fine.
>
> Current issues:
> 1) On second (un)load: kernel BUG at mm/slab.c:500!
>
> TODO:
> 1) DMA
> 2) IRQ

If you wish, I can split this into smaller pieces. I didn't do
"release early, release often" because it didn't work until I
implemented some final workarounds (I took me a lot of time to MMIO
track bcmai+b43 vs. wl). And we already got a lot of half-working
solutions.

Do you have idea why I get BUG_ON on second try of using bcmai/b43?


1) unload
[  107.384571] ------------[ cut here ]------------
[  107.384579] kernel BUG at mm/slab.c:500!
[  107.384585] invalid opcode: 0000 [#1] PREEMPT SMP
[  107.384592] last sysfs file: /sys/bus/bcmai/drivers/b43/uevent
[  107.384599] Modules linked in: bcmai(-) ssb mmc_core pcmcia
pcmcia_core mac80211 cfg80211 rfkill ip6t_LOG xt_tcpudp xt_pkttype
ipt_LOG xt_limit af_packet snd_pcm_oss snd_mixer_oss snd_seq
snd_seq_device edd ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_raw xt_NOTRACK ipt_REJECT iptable_raw iptable_filter
ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack
ip6table_filter ip6_tables x_tables ext3 jbd dm_mod snd_intel8x0
snd_ac97_codec ac97_bus snd_pcm ppdev parport_pc snd_timer ns558
button parport gameport snd forcedeth sg pata_amd pcspkr serio_raw
k8temp i2c_nforce2 soundcore floppy snd_page_alloc ext4 mbcache jbd2
crc16 sd_mod fan processor ata_generic pata_via pata_jmicron sata_nv
sata_via thermal thermal_sys [last unloaded: b43]
[  107.384709]
[  107.384714] Pid: 1730, comm: rmmod Not tainted 2.6.39-rc1-wl-b43+
#19          K8NF4G-SATA2/K8NF4G-SATA2
[  107.384727] EIP: 0060:[<c03126e5>] EFLAGS: 00010046 CPU: 0
[  107.384741] EIP is at kfree+0x145/0x200
[  107.384747] EAX: dab75500 EBX: da108800 ECX: 00000000 EDX: dab75500
[  107.384754] ESI: 00000286 EDI: db9a8000 EBP: d9111e94 ESP: d9111e78
[  107.384761]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  107.384768] Process rmmod (pid: 1730, ti=d9110000 task=d78d2230
task.ti=d9110000)
[  107.384775] Stack:
[  107.384779]  c03f8b9d 00000102 dd7a2a52 da108800 da108800 db9a8000
da108860 d9111ea8
[  107.384792]  dd7a2a52 da108860 da108800 da108930 d9111ec0 c03fae8f
dd7a34e0 da108860
[  107.384804]  dd7a3510 da108894 d9111ed0 c048d8ac da108860 dd7a3510
d9111ee4 c048e00f
[  107.384817] Call Trace:
[  107.384827]  [<c03f8b9d>] ? do_pci_disable_device+0x4d/0x60
[  107.384839]  [<dd7a2a52>] ? bcmai_host_pci_remove+0x42/0x60 [bcmai]
[  107.384849]  [<dd7a2a52>] bcmai_host_pci_remove+0x42/0x60 [bcmai]
[  107.384857]  [<c03fae8f>] pci_device_remove+0x3f/0xf0
[  107.384868]  [<c048d8ac>] __device_release_driver+0x4c/0xa0
[  107.384876]  [<c048e00f>] driver_detach+0x8f/0xa0
[  107.384884]  [<c048d75c>] bus_remove_driver+0x6c/0xe0
[  107.384893]  [<c048e371>] driver_unregister+0x41/0x70
[  107.384901]  [<c037774f>] ? sysfs_remove_file+0xf/0x20
[  107.384909]  [<c03fab9d>] pci_unregister_driver+0x2d/0x80
[  107.384918]  [<dd7a2c31>] b43_pci_ai_bridge_exit+0xd/0xf [bcmai]
[  107.384926]  [<dd7a2c18>] bcmai_modexit+0x8/0x14 [bcmai]
[  107.384936]  [<c02819f9>] sys_delete_module+0x129/0x200
[  107.384945]  [<c02fa276>] ? do_munmap+0x1f6/0x270
[  107.384952]  [<c02f9ff0>] ? arch_get_unmapped_area_topdown+0x170/0x170
[  107.384963]  [<c063d798>] sysenter_do_call+0x12/0x28
[  107.384969] Code: ed 89 e0 25 00 e0 ff ff 83 68 14 01 8b 40 08 a8
08 0f 84 e5 fe ff ff e8 8a 2d 32 00 e9 db fe ff ff 8b 50 0c 66 90 e9
20 ff ff ff <0f> 0b 8b 52 0c e9 21 ff ff ff 8b 45 ec 89 da e8 d7 fd ff
ff 8b
[  107.385020] EIP: [<c03126e5>] kfree+0x145/0x200 SS:ESP 0068:d9111e78
[  107.385020] ---[ end trace 29913fd146dc41d3 ]---


2) load
Apr  5 21:36:27 linux-pglt kernel: [   59.920145] ------------[ cut
here ]------------
Apr  5 21:36:27 linux-pglt kernel: [   59.920154] kernel BUG at mm/slab.c:3058!
Apr  5 21:36:27 linux-pglt kernel: [   59.920160] invalid opcode: 0000
[#1] PREEMPT SMP
Apr  5 21:36:27 linux-pglt kernel: [   59.920168] last sysfs file:
/sys/bus/bcmai/drivers/b43/uevent
Apr  5 21:36:27 linux-pglt kernel: [   59.920174] Modules linked in:
bcmai(+) ssb mmc_core pcmcia pcmcia_core mac80211 cfg80211 rfkill
ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit af_packet snd_pcm_oss
snd_mixer_oss snd_seq snd_seq_device edd ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT iptable_raw
iptable_filter ip6table_mangle nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables ext3 jbd
dm_mod snd_intel8x0 ppdev snd_ac97_codec parport_pc ac97_bus snd_pcm
parport ns558 k8temp forcedeth sg serio_raw pcspkr floppy snd_timer
gameport pata_amd snd button soundcore i2c_nforce2 snd_page_alloc ext4
mbcache jbd2 crc16 sd_mod fan processor ata_generic pata_via
pata_jmicron sata_nv sata_via thermal thermal_sys [last unloaded:
bcmai]
Apr  5 21:36:27 linux-pglt kernel: [   59.920285]
Apr  5 21:36:27 linux-pglt kernel: [   59.920290] Pid: 1832, comm:
work_for_cpu Not tainted 2.6.39-rc1-wl-b43+ #19
K8NF4G-SATA2/K8NF4G-SATA2
Apr  5 21:36:27 linux-pglt kernel: [   59.920304] EIP:
0060:[<c03112d3>] EFLAGS: 00010082 CPU: 0
Apr  5 21:36:27 linux-pglt kernel: [   59.920318] EIP is at
cache_alloc_refill+0x263/0x280
Apr  5 21:36:27 linux-pglt kernel: [   59.920325] EAX: db9ae620 EBX:
ffffffff ECX: da002540 EDX: da002548
Apr  5 21:36:27 linux-pglt kernel: [   59.920332] ESI: da005040 EDI:
00000004 EBP: d7d2df48 ESP: d7d2df10
Apr  5 21:36:27 linux-pglt kernel: [   59.920340]  DS: 007b ES: 007b
FS: 00d8 GS: 0000 SS: 0068
Apr  5 21:36:27 linux-pglt kernel: [   59.920348] Process work_for_cpu
(pid: 1832, ti=d7d2c000 task=d91e9310 task.ti=d7d2c000)
Apr  5 21:36:27 linux-pglt kernel: [   59.920355] Stack:
Apr  5 21:36:27 linux-pglt kernel: [   59.920359]  c0919623 0000000f
00000000 da002564 000492d0 da002550 da002548 da002540
Apr  5 21:36:27 linux-pglt kernel: [   59.920372]  d91e0020 da005040
da002e80 da005040 00000202 da108800 d7d2df78 c0311d4a
Apr  5 21:36:27 linux-pglt kernel: [   59.920384]  0000000d 00000007
00000246 da108800 00001740 000080d0 000080d0 da108800
Apr  5 21:36:27 linux-pglt kernel: [   59.920397] Call Trace:
Apr  5 21:36:27 linux-pglt kernel: [   59.920405]  [<c0311d4a>]
kmem_cache_alloc_trace+0x11a/0x160
Apr  5 21:36:27 linux-pglt kernel: [   59.920420]  [<dd844a72>]
bcmai_host_pci_probe+0x32/0x194 [bcmai]
Apr  5 21:36:27 linux-pglt kernel: [   59.920432]  [<c03f9bd2>]
local_pci_probe+0x42/0xb0
Apr  5 21:36:27 linux-pglt kernel: [   59.920441]  [<c0261b80>] ?
wake_up_worker+0x20/0x20
Apr  5 21:36:27 linux-pglt kernel: [   59.920448]  [<c0261b8c>]
do_work_for_cpu+0xc/0x20
Apr  5 21:36:27 linux-pglt kernel: [   59.920457]  [<c0268424>]
kthread+0x74/0x80
Apr  5 21:36:27 linux-pglt kernel: [   59.920465]  [<c02683b0>] ?
kthread_worker_fn+0x160/0x160
Apr  5 21:36:27 linux-pglt kernel: [   59.920475]  [<c063dd36>]
kernel_thread_helper+0x6/0xd
Apr  5 21:36:27 linux-pglt kernel: [   59.920481] Code: 00 e8 12 fb ff
ff 8b 75 ec 64 8b 15 24 e1 8b c0 8b 14 96 85 c0 89 55 f0 74 13 8b 45
f0 83 38 00 0f 84 b7 fd ff ff e9 63 ff ff ff <0f> 0b 83 3a 00 0f 85 58
ff ff ff 66 90 e9 69 ff ff ff 8d 74 26
Apr  5 21:36:27 linux-pglt kernel: [   59.920532] EIP: [<c03112d3>]
cache_alloc_refill+0x263/0x280 SS:ESP 0068:d7d2df10
Apr  5 21:36:27 linux-pglt kernel: [   59.920545] ---[ end trace
16e2bc5201afa686 ]---


-- 
Rafał

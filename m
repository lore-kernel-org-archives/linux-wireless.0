Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr12.hinet.net ([168.95.4.112]:42789 "EHLO msr12.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab1HNGAY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 02:00:24 -0400
Date: Sun, 14 Aug 2011 14:00:15 +0800
From: Ali Bahar <ali@internetdog.org>
To: Stefan Assmann <sassmann@kpanic.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Oops in rtl8192ce when unloading the module
Message-ID: <20110814060015.GA13600@internetdog.org> (sfid-20110814_080033_948795_88CF7972)
Reply-To: ali@internetdog.org
References: <4E465F79.5060205@kpanic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E465F79.5060205@kpanic.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stefan,

it is _Larry_ who knows this code, of course. But, having browsed thru
this for the first time,


On Sat, Aug 13, 2011 at 01:26:49PM +0200, Stefan Assmann wrote:
> 01:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. Device [10ec:8176] (rev 01)
> 
> This happens with 3.1.0-rc1
> 
> modprobe -r rtl8192ce
> [  450.710489] BUG: unable to handle kernel NULL pointer dereference at 0000000000000620
> [  450.710505] IP: [<ffffffffa0224972>] rtl92ce_get_desc+0x53/0x96 [rtl8192ce]
> [  450.710521] PGD 1e4aa6067 PUD 1e4906067 PMD 0
> [  450.710529] Oops: 0000 [#1] SMP
> [  450.710537] CPU 1
> [  450.710540] Modules linked in: zd1211rw fuse ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat xt_CHECKSUM iptable_mangle bridge stp llc cpufreq_ondemand sunrpc powernow_k8 freq_table mperf
> ip6t_REJECT nf_conntrack_i
> pv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 ip6table_filter xt_state ip6_tables nf_conntrack rfcomm bnep arc4 rtl8192ce(-) rtl8192c_common snd_hda_codec_conexant snd_hda_codec_hdmi rtlwifi
> uvcvideo snd_hda_intel snd_
> hda_codec snd_hwdep videodev snd_seq btusb bluetooth media v4l2_compat_ioctl32 snd_seq_device microcode snd_pcm pcspkr joydev serio_raw sp5100_tco mac80211 k10temp i2c_piix4 i2c_core thinkpad_acpi
> video snd_timer wmi cfg8021
> 1 snd soundcore atl1c snd_page_alloc rfkill virtio_net kvm_amd kvm btrfs zlib_deflate libcrc32c xts gf128mul dm_crypt [last unloaded: cpufreq_ondemand]
> [  450.710630]
> [  450.710636] Pid: 3949, comm: modprobe Not tainted 3.1.0-rc1.sassmann+ #8 LENOVO 30515QG/30515QG
> [  450.710644] RIP: 0010:[<ffffffffa0224972>]  [<ffffffffa0224972>] rtl92ce_get_desc+0x53/0x96 [rtl8192ce]
> [  450.710655] RSP: 0000:ffff8801e490bb78  EFLAGS: 00010046
> [  450.710659] RAX: ffffffffa02266a0 RBX: ffff88020a939d00 RCX: 0000000000000000
> [  450.710664] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000620
> [  450.710668] RBP: ffff8801e490bb88 R08: ffff88021189c200 R09: 0000000000000013
> [  450.710673] R10: 0000000000000000 R11: ffff88020a938540 R12: ffff8801f452eb00
> [  450.710677] R13: ffff88020a939d64 R14: 0000000000000086 R15: ffff88020a938540
> [  450.710683] FS:  00007f2c64ba8720(0000) GS:ffff88021ed00000(0000) knlGS:0000000000000000
> [  450.710688] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  450.710692] CR2: 0000000000000620 CR3: 00000001e7f62000 CR4: 00000000000006e0
> [  450.710697] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  450.710702] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  450.710707] Process modprobe (pid: 3949, threadinfo ffff8801e490a000, task ffff8801e7e94560)
> [  450.710711] Stack:
> [  450.710714]  0000000000000000 ffff88020a939d40 ffff8801e490bca8 ffffffffa0248102
> [  450.710722]  ffff8801e490bfd8 0000004000000282 00000031e490bbb8 0000000000000620
> [  450.710730]  ffff8801e490bc48 ffff8801e490bc20 0000000000000000 00000000009e0000
> [  450.710737] Call Trace:
> [  450.710754]  [<ffffffffa0248102>] _rtl_pci_rx_interrupt+0xcf/0x4bf [rtlwifi]
> [  450.710769]  [<ffffffffa0248c16>] _rtl_pci_interrupt+0x724/0x7ce [rtlwifi]
> [  450.710778]  [<ffffffff810aefaa>] __free_irq+0x145/0x18f
> [  450.710784]  [<ffffffff810af097>] free_irq+0x5b/0x73

this seems like a concurrency issue. Right when it is deregistering
the IRQ handler, a packet is received. If so, then 

1. it should not be reproducible on a quiet network eg when there is no
data traffic && there are no APs around. (Or if you've wrapped the
adapter in layers of foil! :-)

2. it should be only intermittently reproducible otherwise.

My $0.02!
ali




> [  450.710797]  [<ffffffffa0247c9b>] rtl_pci_disconnect+0x125/0x17a [rtlwifi]
> [  450.710807]  [<ffffffff8125f196>] pci_device_remove+0x3d/0x8f
> [  450.710816]  [<ffffffff812fc0c7>] __device_release_driver+0x86/0xcf
> [  450.710823]  [<ffffffff812fc7a0>] driver_detach+0x82/0xaa
> [  450.710830]  [<ffffffff812fbf8c>] bus_remove_driver+0xb7/0xdb
> [  450.710838]  [<ffffffff81181198>] ? release_sysfs_dirent+0x92/0xb0
> [  450.710845]  [<ffffffff812fce38>] driver_unregister+0x6a/0x72
> [  450.710853]  [<ffffffff8125f364>] pci_unregister_driver+0x44/0x89
> [  450.710862]  [<ffffffffa0224a20>] cleanup_module+0x10/0x12 [rtl8192ce]
> [  450.710868]  [<ffffffff81088ccc>] sys_delete_module+0x1ba/0x22c
> [  450.710875]  [<ffffffff810fde39>] ? do_munmap+0x2f2/0x30b
> [  450.710883]  [<ffffffff814cb182>] system_call_fastpath+0x16/0x1b
> [  450.710887] Code: c7 c7 98 60 22 a0 48 c7 c2 90 4f 22 a0 31 c0 e8 53 70 29 e1 0f b6 f3 48 c7 c7 a5 60 22 a0 eb 41 84 d2 74 07 80 fa 05 75 12 eb 07 <8b> 07 c1 e8 1f eb 38 8b 07 25 ff 3f 00 00 eb 2f
> 48 c7 c6 1a 60
> [  450.710942] RIP  [<ffffffffa0224972>] rtl92ce_get_desc+0x53/0x96 [rtl8192ce]
> [  450.710950]  RSP <ffff8801e490bb78>
> [  450.710954] CR2: 0000000000000620
> [  450.710959] ---[ end trace e7de012f8b8d42f4 ]---
> 
> Help is appreciated. :)
> 
>   Stefan

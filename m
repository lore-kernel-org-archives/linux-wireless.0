Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34628 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbeIKHOy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 03:14:54 -0400
To: LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi@intel.com
From: Randy Dunlap <rdunlap@infradead.org>
Subject: 4.19-rc[23] iwlwifi: BUG in swiotlb
Message-ID: <0c5e53e5-2afa-8d38-0b48-272c670c4bc5@infradead.org> (sfid-20180911_041837_063528_262C06DC)
Date: Mon, 10 Sep 2018 19:17:58 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Any ideas?

This is on a common (older) Toshiba Portege laptop.



2018-09-10T18:47:54.532836-07:00 dragon kernel: [   31.471708] ------------[ cut here ]------------
2018-09-10T18:47:54.532837-07:00 dragon kernel: [   31.472371] kernel BUG at ../kernel/dma/swiotlb.c:521!
2018-09-10T18:47:54.532838-07:00 dragon kernel: [   31.473057] invalid opcode: 0000 [#1] PREEMPT SMP PTI
2018-09-10T18:47:54.613627-07:00 dragon kernel: [   31.473734] CPU: 2 PID: 893 Comm: NetworkManager Not tainted 4.19.0-rc3rdd #1
2018-09-10T18:47:54.613640-07:00 dragon kernel: [   31.473735] Hardware name: TOSHIBA PORTEGE R835/Portable PC, BIOS Version 4.10   01/08/2013
2018-09-10T18:47:54.613641-07:00 dragon kernel: [   31.473740] RIP: 0010:swiotlb_tbl_map_single+0x296/0x2c0
2018-09-10T18:47:54.613643-07:00 dragon kernel: [   31.473743] Code: fe ff ff 83 7d a0 01 0f 87 e2 fe ff ff 48 8b 35 e0 e0 df 00 48 8b 55 d0 49 8d 3c 36 48 03 75 b0 e8 df 5f 65 00 e9 c5 fe ff ff <0f> 0b 48 8b 55 d0 48 8b 7d c8 48 c7 c6 c8 74 e4 ab e8 f4 37 40 00
2018-09-10T18:47:54.613645-07:00 dragon kernel: [   31.473744] RSP: 0018:ffffb42480cab0f0 EFLAGS: 00010246
2018-09-10T18:47:54.613646-07:00 dragon kernel: [   31.473747] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
2018-09-10T18:47:54.613647-07:00 dragon kernel: [   31.473749] RDX: 0000000000000000 RSI: 00000000a65d0000 RDI: ffff97e38a5a6890
2018-09-10T18:47:54.613648-07:00 dragon kernel: [   31.473750] RBP: ffffb42480cab150 R08: 0000000000000000 R09: 0000000000000000
2018-09-10T18:47:54.613649-07:00 dragon kernel: [   31.473752] R10: 0000000000000002 R11: 0000000000000000 R12: ffff97e38a5a6890
2018-09-10T18:47:54.613650-07:00 dragon kernel: [   31.473753] R13: 000000000014cba0 R14: 0000000000000001 R15: 0000000000200000
2018-09-10T18:47:54.613651-07:00 dragon kernel: [   31.473756] FS:  00007f9eaafe2980(0000) GS:ffff97e38ae00000(0000) knlGS:0000000000000000
2018-09-10T18:47:54.613652-07:00 dragon kernel: [   31.473759] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
2018-09-10T18:47:54.613653-07:00 dragon kernel: [   31.488350] CR2: 00005648e6cb5138 CR3: 0000000136ec6005 CR4: 00000000000606e0
2018-09-10T18:47:54.613654-07:00 dragon kernel: [   31.488353] Call Trace:
2018-09-10T18:47:54.613655-07:00 dragon kernel: [   31.490325]  swiotlb_alloc+0x88/0x170
2018-09-10T18:47:54.613656-07:00 dragon kernel: [   31.490329]  ? __kmalloc+0x1cc/0x200
2018-09-10T18:47:54.613657-07:00 dragon kernel: [   31.491652]  iwl_pcie_txq_alloc+0x1d4/0x3b0 [iwlwifi]
2018-09-10T18:47:54.613658-07:00 dragon kernel: [   31.491656]  ? __kmalloc+0x1ae/0x200
2018-09-10T18:47:54.613659-07:00 dragon kernel: [   31.491663]  iwl_pcie_tx_init+0x338/0x3a0 [iwlwifi]
2018-09-10T18:47:54.613660-07:00 dragon kernel: [   31.491671]  iwl_trans_pcie_start_fw+0x252/0x580 [iwlwifi]
2018-09-10T18:47:54.613660-07:00 dragon kernel: [   31.491681]  iwl_load_ucode_wait_alive+0xd6/0x1c0 [iwldvm]
2018-09-10T18:47:54.613661-07:00 dragon kernel: [   31.494968]  ? iwl_alloc_all+0x30/0x30 [iwldvm]
2018-09-10T18:47:54.613662-07:00 dragon kernel: [   31.494975]  iwl_run_init_ucode+0x85/0x120 [iwldvm]
2018-09-10T18:47:54.613663-07:00 dragon kernel: [   31.496293]  ? iwl_run_init_ucode+0x85/0x120 [iwldvm]
2018-09-10T18:47:54.613664-07:00 dragon kernel: [   31.496298]  ? iwl_send_calib_cfg+0xb0/0xb0 [iwldvm]
2018-09-10T18:47:54.613664-07:00 dragon kernel: [   31.497620]  iwlagn_mac_start+0x11e/0x220 [iwldvm]
2018-09-10T18:47:54.613665-07:00 dragon kernel: [   31.497625]  ? iwlagn_mac_start+0x11e/0x220 [iwldvm]
2018-09-10T18:47:54.613666-07:00 dragon kernel: [   31.498957]  drv_start+0x44/0x60 [mac80211]
2018-09-10T18:47:54.613667-07:00 dragon kernel: [   31.498970]  ieee80211_do_open+0x31b/0x850 [mac80211]
2018-09-10T18:47:54.613668-07:00 dragon kernel: [   31.498974]  ? mutex_unlock+0xd/0x10
2018-09-10T18:47:54.613668-07:00 dragon kernel: [   31.500960]  ieee80211_open+0x4d/0x50 [mac80211]
2018-09-10T18:47:54.613669-07:00 dragon kernel: [   31.500964]  __dev_open+0xb7/0x150
2018-09-10T18:47:54.613670-07:00 dragon kernel: [   31.502280]  __dev_change_flags+0x15b/0x1a0
2018-09-10T18:47:54.613670-07:00 dragon kernel: [   31.502284]  dev_change_flags+0x24/0x60
2018-09-10T18:47:54.613671-07:00 dragon kernel: [   31.503602]  do_setlink+0x30e/0xed0
2018-09-10T18:47:54.613672-07:00 dragon kernel: [   31.503607]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613673-07:00 dragon kernel: [   31.504923]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613674-07:00 dragon kernel: [   31.504927]  ? sched_clock_cpu+0x11/0xd0
2018-09-10T18:47:54.613674-07:00 dragon kernel: [   31.506253]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613675-07:00 dragon kernel: [   31.506913]  ? nla_parse+0x35/0x110
2018-09-10T18:47:54.613676-07:00 dragon kernel: [   31.507572]  rtnl_newlink+0x51b/0x8d0
2018-09-10T18:47:54.613677-07:00 dragon kernel: [   31.508231]  ? unwind_get_return_address+0x1a/0x30
2018-09-10T18:47:54.613678-07:00 dragon kernel: [   31.508891]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613678-07:00 dragon kernel: [   31.509547]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613679-07:00 dragon kernel: [   31.510203]  ? sched_clock_cpu+0x11/0xd0
2018-09-10T18:47:54.613680-07:00 dragon kernel: [   31.510861]  ? __lock_acquire.isra.32+0x16e/0x870
2018-09-10T18:47:54.613680-07:00 dragon kernel: [   31.511521]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613681-07:00 dragon kernel: [   31.512179]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613682-07:00 dragon kernel: [   31.512834]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613683-07:00 dragon kernel: [   31.513491]  ? sched_clock_cpu+0x11/0xd0
2018-09-10T18:47:54.613684-07:00 dragon kernel: [   31.514149]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613684-07:00 dragon kernel: [   31.514806]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613685-07:00 dragon kernel: [   31.515463]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613686-07:00 dragon kernel: [   31.516120]  ? sched_clock_cpu+0x11/0xd0
2018-09-10T18:47:54.613687-07:00 dragon kernel: [   31.516778]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613687-07:00 dragon kernel: [   31.517434]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613688-07:00 dragon kernel: [   31.518091]  ? sched_clock_cpu+0x11/0xd0
2018-09-10T18:47:54.613689-07:00 dragon kernel: [   31.518751]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613690-07:00 dragon kernel: [   31.519408]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613690-07:00 dragon kernel: [   31.520064]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613691-07:00 dragon kernel: [   31.520721]  ? sched_clock_cpu+0x11/0xd0
2018-09-10T18:47:54.613692-07:00 dragon kernel: [   31.521390]  rtnetlink_rcv_msg+0x170/0x3e0
2018-09-10T18:47:54.613692-07:00 dragon kernel: [   31.522049]  ? rtnl_dellink+0x2a0/0x2a0
2018-09-10T18:47:54.613693-07:00 dragon kernel: [   31.522709]  netlink_rcv_skb+0x4c/0x120
2018-09-10T18:47:54.613694-07:00 dragon kernel: [   31.523367]  rtnetlink_rcv+0x10/0x20
2018-09-10T18:47:54.613695-07:00 dragon kernel: [   31.524023]  netlink_unicast+0x169/0x1f0
2018-09-10T18:47:54.613695-07:00 dragon kernel: [   31.524755]  netlink_sendmsg+0x287/0x380
2018-09-10T18:47:54.613696-07:00 dragon kernel: [   31.525415]  ? netlink_unicast+0x1f0/0x1f0
2018-09-10T18:47:54.613697-07:00 dragon kernel: [   31.526075]  ___sys_sendmsg+0x29b/0x300
2018-09-10T18:47:54.613697-07:00 dragon kernel: [   31.526732]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613698-07:00 dragon kernel: [   31.527389]  ? sched_clock_cpu+0x11/0xd0
2018-09-10T18:47:54.613699-07:00 dragon kernel: [   31.528045]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613700-07:00 dragon kernel: [   31.528701]  ? sched_clock_cpu+0x11/0xd0
2018-09-10T18:47:54.613700-07:00 dragon kernel: [   31.529360]  ? sched_clock+0x9/0x10
2018-09-10T18:47:54.613701-07:00 dragon kernel: [   31.530018]  ? __fget+0xb7/0xf0
2018-09-10T18:47:54.613702-07:00 dragon kernel: [   31.530675]  __sys_sendmsg+0x4f/0x90
2018-09-10T18:47:54.613703-07:00 dragon kernel: [   31.531331]  ? __sys_sendmsg+0x4f/0x90
2018-09-10T18:47:54.613703-07:00 dragon kernel: [   31.531990]  __x64_sys_sendmsg+0x1a/0x20
2018-09-10T18:47:54.613704-07:00 dragon kernel: [   31.532649]  do_syscall_64+0x65/0x1a0
2018-09-10T18:47:54.613705-07:00 dragon kernel: [   31.533308]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
2018-09-10T18:47:54.613706-07:00 dragon kernel: [   31.533968] RIP: 0033:0x7f9ea87c9014
2018-09-10T18:47:54.613706-07:00 dragon kernel: [   31.534626] Code: 89 f3 48 83 ec 10 48 89 7c 24 08 48 89 14 24 e8 42 eb ff ff 48 8b 14 24 41 89 c0 48 89 de 48 8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 30 44 89 c7 48 89 04 24 e8 78 eb ff ff 48 8b
2018-09-10T18:47:54.613707-07:00 dragon kernel: [   31.536605] RSP: 002b:00007ffcb0ca3130 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
2018-09-10T18:47:54.613708-07:00 dragon kernel: [   31.537916] RAX: ffffffffffffffda RBX: 00007ffcb0ca3180 RCX: 00007f9ea87c9014
2018-09-10T18:47:54.613709-07:00 dragon kernel: [   31.539223] RDX: 0000000000000000 RSI: 00007ffcb0ca3180 RDI: 0000000000000007
2018-09-10T18:47:54.613710-07:00 dragon kernel: [   31.540531] RBP: 00005648e6cb26f0 R08: 0000000000000000 R09: 00005648e6cb3120
2018-09-10T18:47:54.613710-07:00 dragon kernel: [   31.541840] R10: fffffffffffffe88 R11: 0000000000000293 R12: 00005648e6beb410
2018-09-10T18:47:54.613711-07:00 dragon kernel: [   31.543147] R13: 00007ffcb0ca3180 R14: 00007ffcb0ca3304 R15: 0000000000000000
2018-09-10T18:47:54.613712-07:00 dragon kernel: [   31.544456] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek nls_iso8859_1 nls_cp437 snd_hda_codec_generic i915 btrfs uvcvideo xor zstd_compress videobuf2_vmalloc videobuf2_memops raid6_pq hid_generic usbmouse videobuf2_v4l2 videobuf2_common arc4 usbhid coretemp iwldvm videodev libcrc32c hwmon hid media intel_rapl zstd_decompress mac80211 xxhash x86_pkg_temp_thermal msr intel_powerclamp snd_hda_intel snd_hda_codec kvm_intel crct10dif_pclmul snd_hwdep crc32_pclmul snd_hda_core crc32c_intel iwlwifi ghash_clmulni_intel snd_pcm pcbc kvmgt vfio_mdev snd_timer mdev aesni_intel vfio_iommu_type1 iTCO_wdt aes_x86_64 crypto_simd gpio_ich cfg80211 snd vfio iTCO_vendor_support kvm rfkill soundcore cryptd sdhci_pci cqhci sdhci sr_mod glue_helper irqbypass evdev input_leds joydev mousedev intel_cstate
2018-09-10T18:47:54.613713-07:00 dragon kernel: [   31.551785]  thermal intel_uncore mei_me mmc_core pcc_cpufreq intel_rapl_perf lpc_ich mei ac video led_class cdrom e1000e serio_raw pcspkr toshiba_haps battery button sg scsi_dh_rdac scsi_dh_emc scsi_dh_alua autofs4
2018-09-10T18:47:54.613714-07:00 dragon kernel: [   31.553809] ---[ end trace d3ae93ce8608d128 ]---
2018-09-10T18:47:54.614851-07:00 dragon kernel: [   31.554512] RIP: 0010:swiotlb_tbl_map_single+0x296/0x2c0
2018-09-10T18:47:54.614856-07:00 dragon kernel: [   31.554514] Code: fe ff ff 83 7d a0 01 0f 87 e2 fe ff ff 48 8b 35 e0 e0 df 00 48 8b 55 d0 49 8d 3c 36 48 03 75 b0 e8 df 5f 65 00 e9 c5 fe ff ff <0f> 0b 48 8b 55 d0 48 8b 7d c8 48 c7 c6 c8 74 e4 ab e8 f4 37 40 00
2018-09-10T18:47:54.614858-07:00 dragon kernel: [   31.554516] RSP: 0018:ffffb42480cab0f0 EFLAGS: 00010246
2018-09-10T18:47:54.614859-07:00 dragon kernel: [   31.554519] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
2018-09-10T18:47:54.614861-07:00 dragon kernel: [   31.554520] RDX: 0000000000000000 RSI: 00000000a65d0000 RDI: ffff97e38a5a6890
2018-09-10T18:47:54.614862-07:00 dragon kernel: [   31.554522] RBP: ffffb42480cab150 R08: 0000000000000000 R09: 0000000000000000
2018-09-10T18:47:54.614863-07:00 dragon kernel: [   31.554523] R10: 0000000000000002 R11: 0000000000000000 R12: ffff97e38a5a6890
2018-09-10T18:47:54.614864-07:00 dragon kernel: [   31.554525] R13: 000000000014cba0 R14: 0000000000000001 R15: 0000000000200000
2018-09-10T18:47:54.614864-07:00 dragon kernel: [   31.554527] FS:  00007f9eaafe2980(0000) GS:ffff97e38ae00000(0000) knlGS:0000000000000000
2018-09-10T18:47:54.614865-07:00 dragon kernel: [   31.554529] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
2018-09-10T18:47:54.614866-07:00 dragon kernel: [   31.554530] CR2: 00005648e6cb5138 CR3: 0000000136ec6005 CR4: 00000000000606e0


thanks,
-- 
~Randy

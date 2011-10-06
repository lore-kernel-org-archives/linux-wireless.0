Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from straum.hexapodia.org ([207.7.131.186]:38741 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab1JFV30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 17:29:26 -0400
Date: Thu, 6 Oct 2011 14:19:24 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-wireless@vger.kernel.org
Subject: rtl8192se, 3.1-rc9: intermittent soft lockups
Message-ID: <20111006211924.GS21806@hexapodia.org> (sfid-20111006_232930_653361_5023458B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My Thinkpad X100e has a

03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8191SEvB
Wireless LAN Controller (rev 10)

which works pretty well with rtl8192se.ko in mainline (I'm running
976d167 plus some local patches), except that the machine hangs fairly
frequently while associated to the AP.  I set up netconsole on eth0 and
got the following soft lockup:


[  520.164047] BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:2:34]
[  520.164053] Modules linked in: netconsole configfs ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_stat
e nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc fuse dm_crypt mperf kvm_amd kvm snd_h
da_codec_conexant snd_hda_intel snd_hda_codec thinkpad_acpi snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm radeon snd_seq_midi snd_rawmidi uvcvideo arc4
 snd_seq_midi_event snd_seq videodev snd_timer ttm v4l2_compat_ioctl32 joydev drm_kms_helper drm snd_seq_device i2c_algo_bit i2c_core snd rtl8192se r
tlwifi evdev mac80211 cfg80211 rfkill pcspkr nvram soundcore psmouse video shpchp serio_raw processor battery button ac snd_page_alloc ext3 jbd mbcac
he btrfs zlib_deflate crc32c libcrc32c dm_mod raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mult
ipath linear md_mod sg sd_mod crc_t10dif usb_storage uas ahci libahci libata thermal thermal_sys ehci_hcd scsi_mod usbcore r8169 mii [last unloaded: 
scsi_wait_scan]
[  520.164607] CPU 1 
[  520.164610] Modules linked in: netconsole configfs ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_stat
e nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc fuse dm_crypt mperf kvm_amd kvm snd_h
da_codec_conexant snd_hda_intel snd_hda_codec thinkpad_acpi snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm radeon snd_seq_midi snd_rawmidi uvcvideo arc4
 snd_seq_midi_event snd_seq videodev snd_timer ttm v4l2_compat_ioctl32 joydev drm_kms_helper drm snd_seq_device i2c_algo_bit i2c_core snd rtl8192se r
tlwifi evdev mac80211 cfg80211 rfkill pcspkr nvram soundcore psmouse video shpchp serio_raw processor battery button ac snd_page_alloc ext3 jbd mbcac
he btrfs zlib_deflate crc32c libcrc32c dm_mod raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mult
ipath linear md_mod sg sd_mod crc_t10dif usb_storage uas ahci libahci libata thermal thermal_sys ehci_hcd scsi_mod usbcore r8169 mii [last unloaded: 
scsi_wait_scan]
[  520.165347] 
[  520.165352] Pid: 34, comm: kworker/1:2 Not tainted 3.1.0-rc8-00075-g56dc244 #180 LENOVO 3508CTO/3508CTO
[  520.165365] RIP: 0010:[<ffffffff81076ee0>]  [<ffffffff81076ee0>] do_raw_spin_lock+0x21/0x25
[  520.165379] RSP: 0018:ffff8800afd03e60  EFLAGS: 00000297
[  520.165384] RAX: 00000000000018e8 RBX: ffff8800afd03e10 RCX: 000000000000295c
[  520.165390] RDX: 00000000000018e7 RSI: ffff8800ab3a1f98 RDI: ffff8800ab3a1d14
[  520.165395] RBP: ffff8800afd03e60 R08: ffffffff8125e2ca R09: ffffffff8125e247
[  520.165458] R10: ffff8800ab306000 R11: 0000000000000000 R12: ffff8800afd03dd8
[  520.165463] R13: ffffffff812fcb1e R14: ffff8800afd03e60 R15: ffff8800ab3a0520
[  520.165469] FS:  00002b445e5a6700(0000) GS:ffff8800afd00000(0000) knlGS:0000000000000000
[  520.165474] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  520.165479] CR2: 00002b445e8d8000 CR3: 0000000037750000 CR4: 00000000000006e0
[  520.165485] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  520.165490] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  520.165496] Process kworker/1:2 (pid: 34, threadinfo ffff8800aa6f2000, task ffff8800aa6e14d0)
[  520.165500] Stack:
[  520.165504]  ffff8800afd03e70 ffffffff812fb386 ffff8800afd03e90 ffffffffa043f89a
[  520.165517]  ffff8800ab3a1f90 ffff8800ab3a1f98 ffff8800afd03ea0 ffffffffa0440ef8
[  520.165589]  ffff8800afd03ed0 ffffffff8104ddfb ffffffff816040b0 ffffffff816040b0
[  520.165601] Call Trace:
[  520.165606]  <IRQ> 
[  520.165616]  [<ffffffff812fb386>] _raw_spin_lock+0xe/0x10
[  520.165631]  [<ffffffffa043f89a>] rtl_lps_leave+0x1c/0xea [rtlwifi]
[  520.165642]  [<ffffffffa0440ef8>] _rtl_pci_ips_leave_tasklet+0xe/0x10 [rtlwifi]
[  520.165651]  [<ffffffff8104ddfb>] tasklet_action+0x7f/0xd2
[  520.165659]  [<ffffffff8104e6a2>] __do_softirq+0xbb/0x199
[  520.165668]  [<ffffffff81026552>] ? apic_write+0x16/0x18
[  520.165676]  [<ffffffff81027efa>] ? ack_apic_level+0x5a/0xe5
[  520.165684]  [<ffffffff812fe2ac>] call_softirq+0x1c/0x30
[  520.165692]  [<ffffffff81010188>] do_softirq+0x46/0x82
[  520.165759]  [<ffffffff8104e93b>] irq_exit+0x44/0xa1
[  520.165766]  [<ffffffff812feb8e>] do_IRQ+0x8e/0xa5
[  520.165773]  [<ffffffff812fb7ae>] common_interrupt+0x6e/0x6e
[  520.165777]  <EOI> 
[  520.165786]  [<ffffffff8119a83e>] ? delay_tsc+0x2d/0x74
[  520.165792]  [<ffffffff8119a7b9>] __delay+0xf/0x11
[  520.165799]  [<ffffffff8119a7e4>] __const_udelay+0x29/0x2b
[  520.165811]  [<ffffffffa045ba9c>] rtl92s_phy_set_rf_power_state+0x50f/0x601 [rtl8192se]
[  520.165822]  [<ffffffffa043fd89>] ? rtl_swlps_rf_sleep+0x177/0x177 [rtlwifi]
[  520.165833]  [<ffffffffa043f11d>] rtl_ps_set_rf_state+0xdd/0xe3 [rtlwifi]
[  520.165843]  [<ffffffffa043fc92>] rtl_swlps_rf_sleep+0x80/0x177 [rtlwifi]
[  520.165854]  [<ffffffffa043fdb6>] rtl_swlps_wq_callback+0x2d/0x83 [rtlwifi]
[  520.165862]  [<ffffffff8105f460>] process_one_work+0x15c/0x28f
[  520.165870]  [<ffffffff81060569>] worker_thread+0xd3/0x157
[  520.165878]  [<ffffffff81060496>] ? manage_workers.isra.24+0x16f/0x16f
[  520.165885]  [<ffffffff81063a21>] kthread+0x84/0x8c
[  520.165892]  [<ffffffff812fe1b4>] kernel_thread_helper+0x4/0x10
[  520.165899]  [<ffffffff8106399d>] ? kthread_worker_fn+0x146/0x146
[  520.165968]  [<ffffffff812fe1b0>] ? gs_change+0x13/0x13
[  520.165972] Code: 00 74 05 e8 a3 45 12 00 5d c3 55 48 89 e5 66 66 66 66 90 b8 00 00 01 00 f0 0f c1 07 0f b7 d0 c1 e8 10 39 c2 74 07 f3 90 0f b7 17 <eb> f5 5d c3 55 

complete dmesg (from a fresh boot) is at
http://web.hexapodia.org/~adi/x100e/dmesg-3.1-rc9.txt

Thanks,
-andy

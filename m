Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728096AbeIXUJ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 16:09:29 -0400
Date: Mon, 24 Sep 2018 16:07:01 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Sid Hayn <sidhayn@gmail.com>, linux-wireless@vger.kernel.org
Subject: mt76x0 random crashes after c12128ce44b0
Message-ID: <20180924140701.GA2089@redhat.com> (sfid-20180924_160714_103759_1C66773C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, after -next commit: 

commit c12128ce44b04a987c4eb0f733cc99c4dd50d45a
Author: Felix Fietkau <nbd@nbd.name>
Date:   Fri Jul 13 16:26:15 2018 +0200

    mt76: use a per rx queue page fragment cache

I have random crashes when load or unlod mt76x0u module.

When loading, it looks like this:

[   40.238936] usb 1-1.1: new high-speed USB device number 3 using ehci-pci
[   40.333174] usb 1-1.1: New USB device found, idVendor=2357, idProduct=0105, bcdDevice= 1.00
[   40.333178] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   40.333181] usb 1-1.1: Product: WiFi
[   40.333183] usb 1-1.1: Manufacturer: MediaTek
[   40.333185] usb 1-1.1: SerialNumber: 1.0
[   40.566944] usb 1-1.1: reset high-speed USB device number 3 using ehci-pci
[   40.651457] mt76x0u 1-1.1:1.0: ASIC revision: 76100002 MAC revision: 76502000
[   40.982520] BUG: unable to handle kernel paging request at ffff9f8322e19000
[   40.982540] PGD 27ba01067 P4D 27ba01067 PUD 27ddba063 PMD 263b35063 PTE 8000000262e19061
[   40.982555] Oops: 0003 [#1] SMP PTI
[   40.982563] CPU: 2 PID: 1766 Comm: systemd-udevd Not tainted 4.19.0-rc5+ #6
[   40.982570] Hardware name: ASUSTeK COMPUTER INC. ESC2000 G2/Z9PE-D8 WS, BIOS 0405 03/19/2012
[   40.982587] RIP: 0010:__memcpy+0x12/0x20
[   40.982593] Code: 48 c1 e2 20 48 09 c2 48 31 d3 e9 68 ff ff ff 90 90 90 90 90 90 90 90 90 66 66 90 66 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 <f3> 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 f3 a4
[   40.982608] RSP: 0018:ffffba13849b3ad8 EFLAGS: 00010246
[   40.982616] RAX: ffff9f8322e17004 RBX: 00000000000038f0 RCX: 000000000000031f
[   40.982626] RDX: 0000000000000000 RSI: ffffba13844cf058 RDI: ffff9f8322e18ffc
[   40.982633] RBP: 0000000000010c6c R08: 0000000000000000 R09: 0000607ec0000000
[   40.982640] R10: 0000000000000003 R11: 0000000000003e2e R12: ffff9f8324cd9540
[   40.982648] R13: 0000000000000000 R14: ffffba13849b3b30 R15: ffff9f8322e17000
[   40.982656] FS:  00007fadec85b880(0000) GS:ffff9f833fa80000(0000) knlGS:0000000000000000
[   40.982664] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.982670] CR2: ffff9f8322e19000 CR3: 0000000263428001 CR4: 00000000000606e0
[   40.982677] Call Trace:
[   40.982690]  mt76x02u_mcu_fw_send_data+0x16c/0x270 [mt76x02_usb]
[   40.982702]  mt76x0u_probe+0x35a/0x598 [mt76x0u]
[   40.982711]  ? __pm_runtime_set_status+0x149/0x210
[   40.982721]  usb_probe_interface+0x113/0x310
[   40.982730]  really_probe+0x1c8/0x400
[   40.982738]  driver_probe_device+0x5c/0x130
[   40.982745]  __driver_attach+0xec/0x110
[   40.982751]  ? driver_probe_device+0x130/0x130
[   40.982758]  bus_for_each_dev+0x50/0x90
[   40.982766]  bus_add_driver+0x1c0/0x280
[   40.982773]  driver_register+0x5b/0xe0
[   40.982780]  usb_register_driver+0x7c/0x140
[   40.982787]  ? 0xffffffffc0ad9000
[   40.982794]  do_one_initcall+0x44/0x19b
[   40.982802]  ? free_unref_page_commit+0x80/0xf0
[   40.982810]  ? _cond_resched+0x15/0x30
[   40.982818]  do_init_module+0x5a/0x210
[   40.982825]  load_module+0x175c/0x1bc0
[   40.982831]  ? m_show+0x190/0x190
[   40.982839]  ? kernel_read_file+0x161/0x1b0
[   40.982846]  ? kernel_read_file_from_fd+0x44/0x70
[   40.982855]  ? security_capable+0x39/0x50
[   40.982861]  __do_sys_finit_module+0x97/0xc0
[   40.982870]  do_syscall_64+0x3f/0xf0
[   40.982876]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   40.982883] RIP: 0033:0x7fadeb6f1809
[   40.982888] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1f 86 2c 00 f7 d8 64 89 01 48
[   40.982904] RSP: 002b:00007ffe548f9f38 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   40.982913] RAX: ffffffffffffffda RBX: 00007fadebdf0d89 RCX: 00007fadeb6f1809
[   40.982920] RDX: 0000000000000000 RSI: 00007fadebdf0d89 RDI: 0000000000000006
[   40.982927] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[   40.982934] R10: 0000000000000006 R11: 0000000000000246 R12: 0000560b9ef58ab0
[   40.982941] R13: 0000560b9ef29800 R14: 0000560b9ef59040 R15: 0000000000020000

However somethings module load correctly and crash happen when I unload it:

[  522.218992] BUG: Bad page state in process polkitd  pfn:264d20
[  522.218997] page:ffffdae40860df00 count:-1 mapcount:0 mapping:0000000000000000 index:0x0
[  522.219000] flags: 0x20000000000000()
[  522.219004] raw: 0020000000000000 dead000000000100 dead000000000200 0000000000000000
[  522.219006] raw: 0000000000000000 0000000000000000 ffffffffffffffff
[  522.219007] page dumped because: nonzero _refcount
[  522.219008] Modules linked in: mt76x0u mt76x0_common mt76x02_usb mt76_usb mt76x02_lib mt76 mac80211 cfg80211 ctr ccm arc4 bnep bluetooth ecdh_generic ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables rfkill snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec irqbypass snd_hwdep crc32c_intel iTCO_wdt snd_hda_core ghash_clmulni_intel iTCO_vendor_support aesni_intel snd_seq aes_x86_64 crypto_simd snd_seq_device cryptd snd_pcm ipmi_si glue_helper lpc_ich ipmi_msghandler i2c_i801 pcspkr snd_timer e1000e mfd_core snd soundcore nfsd auth_rpcgss nfs_acl lockd grace sunrpc ipv6 crc_ccitt ext4 mbcache jbd2 sr_mod cdrom sd_mod nouveau video mxm_wmi i2c_algo_bit drm_kms_helper syscopyarea
[  522.219073]  sysfillrect sysimgblt fb_sys_fops ttm ahci isci libahci libsas drm scsi_transport_sas i2c_core wmi [last unloaded: cfg80211]
[  522.219086] CPU: 2 PID: 11438 Comm: polkitd Not tainted 4.19.0-rc1+ #3
[  522.219088] Hardware name: ASUSTeK COMPUTER INC. ESC2000 G2/Z9PE-D8 WS, BIOS 0405 03/19/2012
[  522.219089] Call Trace:
[  522.219102]  dump_stack+0x46/0x5b
[  522.219109]  bad_page+0x103/0x11d
[  522.219113]  free_pcppages_bulk+0x56b/0x610
[  522.219117]  free_unref_page_list+0x10c/0x180
[  522.219121]  release_pages+0x292/0x360
[  522.219126]  tlb_flush_mmu_free+0x31/0x50
[  522.219129]  arch_tlb_finish_mmu+0x71/0x130
[  522.219132]  tlb_finish_mmu+0x1f/0x30
[  522.219137]  exit_mmap+0xc0/0x170
[  522.219143]  mmput+0x5b/0x120
[  522.219148]  flush_old_exec+0x345/0x6d0
[  522.219153]  load_elf_binary+0x331/0x10c1
[  522.219158]  ? _copy_from_user+0x2e/0x60
[  522.219161]  ? get_acl+0x17/0xe0
[  522.219164]  ? load_misc_binary+0x41/0x490
[  522.219168]  search_binary_handler+0x97/0x1c0
[  522.219171]  __do_execve_file.isra.38+0x593/0x820
[  522.219175]  __x64_sys_execve+0x44/0x50
[  522.219179]  do_syscall_64+0x3f/0xf0
[  522.219183]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  522.219186] RIP: 0033:0x7ff43ddd6dc7
[  522.219193] Code: Bad RIP value.
[  522.219194] RSP: 002b:00007ffef9a6b288 EFLAGS: 00000206 ORIG_RAX: 000000000000003b
[  522.219197] RAX: ffffffffffffffda RBX: 000055c6f3eaa380 RCX: 00007ff43ddd6dc7
[  522.219198] RDX: 00007ffef9a6c3f0 RSI: 000055c6f3eaa380 RDI: 000055c6f3ea51c0
[  522.219200] RBP: 000055c6f3ea51c0 R08: 0000000000000001 R09: 000055c6f3ebdb9d
[  522.219201] R10: 00007ffef9a6b050 R11: 0000000000000206 R12: 000000000000000d
[  522.219203] R13: 00000000ffffffff R14: 00007ff43fa0c7a0 R15: 0000000000000000
[  522.219206] Disabling lock debugging due to kernel taint
[  524.420889] nouveau 0000:03:00.0: DRM: DDC responded, but no EDID for VGA-1
[  525.816879] wlan0: authenticate with 00:23:69:35:d1:3e
[  525.846523] wlan0: send auth to 00:23:69:35:d1:3e (try 1/3)
[  525.848541] wlan0: authenticated
[  530.850700] wlan0: aborting authentication with 00:23:69:35:d1:3e by local choice (Reason: 3=DEAUTH_LEAVING)
[  534.660451] nouveau 0000:03:00.0: DRM: DDC responded, but no EDID for VGA-1
[  543.227128] rcu: INFO: rcu_sched self-detected stall on CPU
[  543.228980] rcu: 	0-....: (20999 ticks this GP) idle=f8a/1/0x4000000000000002 softirq=21719/21719 fqs=5249 
[  543.230854] rcu: 	 (t=21000 jiffies g=99429 q=5766)
[  543.232733] NMI backtrace for cpu 0
[  543.232735] CPU: 0 PID: 583 Comm: rs:main Q:Reg Tainted: G    B             4.19.0-rc1+ #3
[  543.232736] Hardware name: ASUSTeK COMPUTER INC. ESC2000 G2/Z9PE-D8 WS, BIOS 0405 03/19/2012
[  543.232737] Call Trace:
[  543.232740]  <IRQ>
[  543.232747]  dump_stack+0x46/0x5b
[  543.232750]  nmi_cpu_backtrace+0x94/0xa0
[  543.232754]  ? lapic_can_unplug_cpu+0xa0/0xa0
[  543.232757]  nmi_trigger_cpumask_backtrace+0xd5/0x110
[  543.232761]  rcu_dump_cpu_stacks+0x89/0xb9
[  543.232764]  rcu_check_callbacks+0x599/0x710
[  543.232767]  ? timekeeping_advance+0x1ea/0x560
[  543.232769]  ? tick_sched_do_timer+0x60/0x60
[  543.232772]  update_process_times+0x28/0x50
[  543.232774]  tick_sched_handle+0x25/0x60
[  543.232775]  tick_sched_timer+0x37/0x70
[  543.232778]  __hrtimer_run_queues+0xfb/0x260
[  543.232781]  hrtimer_interrupt+0x122/0x270
[  543.232784]  smp_apic_timer_interrupt+0x63/0x130
[  543.232786]  apic_timer_interrupt+0xf/0x20
[  543.232787]  </IRQ>
[  543.232792] RIP: 0010:__process_echoes+0xb5/0x250
[  543.232793] Code: 00 41 80 bc 07 60 12 00 00 82 48 0f 44 da 49 8b 47 20 48 39 c3 73 2b 48 29 d8 48 3d df 0e 00 00 76 20 48 89 d8 25 ff 0f 00 00 <41> 80 bc 07 60 12 00 00 ff 74 bb 49 8b 47 20 48 83 c3 01 48 39 c3
[  543.232794] RSP: 0018:ffffb324c1e9fd28 EFLAGS: 00000206 ORIG_RAX: ffffffffffffff13
[  543.232796] RAX: 00000000000003c3 RBX: 0000000340e033c3 RCX: ffff8ebcf304c400
[  543.232797] RDX: 29dd008035100000 RSI: 0000000000000202 RDI: ffff8ebcf31c6ea8
[  543.232798] RBP: 000000000000177c R08: 0000000000000001 R09: ffff8ebcf6c2e540
[  543.232799] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8ebcf4d14000
[  543.232800] R13: 0000000000000092 R14: 0000000000001f00 R15: ffffb324c4ad5000
[  543.232803]  ? __process_echoes+0x155/0x250
[  543.232806]  process_echoes+0x3f/0x70
[  543.232808]  n_tty_write+0x93/0x450
[  543.232811]  ? prepare_to_wait+0xb0/0xb0
[  543.232813]  tty_write+0x147/0x290
[  543.232816]  ? process_echoes+0x70/0x70
[  543.232819]  __vfs_write+0x23/0x150
[  543.232822]  ? __do_sys_newfstat+0x29/0x40
[  543.232824]  vfs_write+0xad/0x1a0
[  543.232826]  ksys_write+0x42/0x90
[  543.232829]  do_syscall_64+0x3f/0xf0
[  543.232831]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  543.232833] RIP: 0033:0x7f6625d9681d
[  543.232835] Code: dc 20 00 00 75 10 b8 01 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 7e fc ff ff 48 89 04 24 b8 01 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 c7 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
[  543.232836] RSP: 002b:00007f661b7fd410 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
[  543.232837] RAX: ffffffffffffffda RBX: 00007f661b7fd4d0 RCX: 00007f6625d9681d
[  543.232838] RDX: 0000000000000092 RSI: 00007f660c000920 RDI: 0000000000000009
[  543.232839] RBP: 0000000000000009 R08: 0000000000000000 R09: 00007f661b7fd658
[  543.232840] R10: 0000000000000001 R11: 0000000000000293 R12: 00007f661b7fd4fc
[  543.232841] R13: 00007f661b7fd650 R14: 0000556b7ad0d4d0 R15: 00007f660c000920
[  544.900019] nouveau 0000:03:00.0: DRM: DDC responded, but no EDID for VGA-1
[  552.065774] rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: { 0-... } 21216 jiffies s: 113 root: 0x1/.
[  552.066075] rcu: blocking rcu_node structures:
[  552.066604] Task dump for CPU 0:
[  552.066606] rs:main Q:Reg   R  running task        0   583      1 0x80000008
[  552.066609] Call Trace:
[  552.066615]  ? __update_load_avg_se+0x1f1/0x200
[  552.066619]  ? account_entity_enqueue+0x8d/0xb0
[  552.066622]  ? enqueue_entity+0x61f/0xb20
[  552.066624]  ? enqueue_task_fair+0xac/0x6b0
[  552.066626]  ? check_preempt_curr+0x6b/0x90
[  552.066627]  ? ttwu_do_wakeup+0x19/0x150
[  552.066629]  ? try_to_wake_up+0x44/0x450
[  552.066633]  ? __tty_buffer_request_room+0x10f/0x130
[  552.066636]  ? apic_timer_interrupt+0xa/0x20
[  552.066639]  ? __process_echoes+0xc0/0x250
[  552.066641]  ? __process_echoes+0x155/0x250
[  552.066643]  ? process_echoes+0x3f/0x70
[  552.066645]  ? n_tty_write+0x93/0x450
[  552.066647]  ? prepare_to_wait+0xb0/0xb0
[  552.066649]  ? tty_write+0x147/0x290
[  552.066651]  ? process_echoes+0x70/0x70
[  552.066655]  ? __vfs_write+0x23/0x150
[  552.066657]  ? __do_sys_newfstat+0x29/0x40
[  552.066659]  ? vfs_write+0xad/0x1a0
[  552.066661]  ? ksys_write+0x42/0x90
[  552.066664]  ? do_syscall_64+0x3f/0xf0
[  552.066665]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  555.139587] nouveau 0000:03:00.0: DRM: DDC responded, but no EDID for VGA-1
[  565.379150] nouveau 0000:03:00.0: DRM: DDC responded, but no EDID for VGA-1
[  565.784636] mt76x0u 1-1.1:1.0: rx urb failed: -71
[  565.790634] mt76x0u 1-1.1:1.0: rx urb failed: -71
[  565.796634] mt76x0u 1-1.1:1.0: rx urb failed: -71
[  565.802633] mt76x0u 1-1.1:1.0: rx urb failed: -71
[  565.808634] mt76x0u 1-1.1:1.0: rx urb failed: -71
[  565.814508] mt76x0u 1-1.1:1.0: rx urb failed: -71
[  565.820396] mt76x0u 1-1.1:1.0: rx urb failed: -71
[  565.826270] mt76x0u 1-1.1:1.0: rx urb failed: -71
[  565.832133] mt76x0u 1-1.1:1.0: rx urb failed: -71
[  565.838009] mt76x0u 1-1.1:1.0: rx urb failed: -71
[

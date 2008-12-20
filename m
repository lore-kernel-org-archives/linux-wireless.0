Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:36644 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYLTPCJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 10:02:09 -0500
Received: by bwz14 with SMTP id 14so5401343bwz.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 07:02:07 -0800 (PST)
To: linux-wireless@vger.kernel.org
Subject: regression: iwl3945 crashing after ifup
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 20 Dec 2008 17:02:00 +0200
Message-ID: <87ljuahouv.fsf@litku.valot.fi> (sfid-20081220_160306_777616_6CF62108)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I updated my wireless-testing tree and iwl3945 is crashing right after
ifup eth0 and it happens every time. So a major regression.

I'm using commit 30b5741a68 from wireless-testing on a Lenovo x60s
running debian unstable (32 bit).

Here's the backtrace:

[  114.929742] console [netcon0] enabled
[  114.929756] netconsole: network logging started
[  144.810611] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  144.811099] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
[  144.967946] iwl3945 0000:03:00.0: iwlwifi-3945-2.ucode firmware file req failed: -2
[  144.967962] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-1.ucode
[  145.014113] iwl3945 0000:03:00.0: Loaded firmware iwlwifi-3945-1.ucode, which is deprecated.  Please use API v2 instead.
[  145.014131] iwl3945 0000:03:00.0: Firmware has old API version. Expected 2, got 1. New firmware can be obtained from http://www.intellinuxwireless.org.
[  145.014141] iwl3945 0000:03:00.0: loaded firmware version 15.28.1.6
[  145.031116] BUG: unable to handle kernel NULL pointer dereference at 00000000
[  145.031135] IP: [<f94f435f>] iwl3945_irq_tasklet+0x691/0x1063 [iwl3945]
[  145.031165] *pde = 00000000 
[  145.031178] Oops: 0000 [#1] SMP 
[  145.031191] last sysfs file: /sys/class/firmware/0000:03:00.0/loading
[  145.031198] Modules linked in: netconsole configfs i915 drm rfcomm l2cap cpufreq_ondemand binfmt_misc ipv6 fuse acpi_cpufreq freq_table loop snd_hda_intel arc4 ecb snd_pcm iwl3945 snd_seq iwlcore snd_timer snd_seq_device mac80211 thinkpad_acpi hci_usb pcmcia snd rfkill bluetooth lib80211 video backlight soundcore pcspkr battery psmouse cfg80211 yenta_socket rsrc_nonstatic pcmcia_core i2c_i801 rng_core led_class output ac snd_page_alloc button evdev nvram ext3 jbd mbcache sha256_generic aes_i586 aes_generic cbc dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sd_mod ata_generic ata_piix libata scsi_mod ide_core ehci_hcd processor fan[  145.031480] Pid: 0, comm: swapper Not tainted (2.6.28-rc9-wl #105) 1703Y1F
[  145.031488] EIP: 0060:[<f94f435f>] EFLAGS: 00010082 CPU: 0
[  145.031510] EIP is at iwl3945_irq_tasklet+0x691/0x1063 [iwl3945]
[  145.031517] EAX: 00000000 EBX: 00000000 ECX: 00010000 EDX: 80000008
[  145.031524] ESI: f65dc2d4 EDI: f65d0f40 EBP: c03b1eb0 ESP: c03b1e20
[  145.031539] Process swapper (pid: 0, ti=c03b0000 task=c037732c task.ti=c03b0000)
[  145.031545] Stack:
 00000000 00000000
 ffffffff 00000000 0061891a 00000004 0200e000 c01c5ad7[  145.031653] Call Trace:
[  145.031674]  [<c01c5ad7>] ? __next_cpu+0x15/0x25
 [<c011a134>] ? nr_active+0x32/0x4b
[  145.031710]  [<c0125b22>] ? __do_softirq+0x84/0x121
[  145.031720]  [<c0125cf9>] ? irq_exit+0x38/0x6d
[  145.031754]  [<c01039f3>] ? common_interrupt+0x23/0x28
[  145.031777]  [<f806c3a8>] ? acpi_idle_enter_simple+0x198/0x205 [processor]
 [<c01e7918>] ? acpi_os_release_lock+0x8/0xa
[  145.031816]  [<c0135a45>] ? sched_clock_idle_wakeup_event+0xd/0xf
 [<c0240839>] ? cpuidle_idle_call+0x60/0x93
[  145.031873]  [<c0101f60>] ? cpu_idle+0x6b/0x87
 [<c02935ca>] ? rest_init+0x4e/0x50
00 89 e8 54 83 ff ff 02 45 08 80 0f 00 8b 04 28 8b e4 00 89 5d 94 00 0f 00 89 89 2b [  145.032049] EIP: [<f94f435f>] [  145.032049] Kernel panic - not syncing: Fatal exception in interrupt
[  145.032049] ------------[ cut here ]------------
[  145.032049] WARNING: at kernel/smp.c:333 smp_call_function_mask+0x28/0x17d()
[  145.032049] Modules linked in: netconsole i915 rfcomm binfmt_misc acpi_cpufreq freq_table ecb iwl3945 snd_timer thinkpad_acpi hci_usb bluetooth video pcspkr battery yenta_socket pcmcia_core led_class snd_page_alloc button jbd sha256_generic dm_crypt dm_mirror dm_snapshot sd_mod ata_piix sdhci_pci ide_core mmc_core e1000e processor[  145.032049] Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc9-wl #105
[  145.032049] Call Trace:
[  145.032049]  [<c029f7fb>] ? printk+0xf/0x14
[  145.032049]  [<c01219a3>] warn_on_slowpath+0x41/0x63
[  145.032049]  [<c02a1abf>] ? _spin_unlock+0x8/0xa
[  145.032049]  [<c025a4f2>] ? netpoll_send_udp+0x1e8/0x1f2
[  145.032049]  [<f85c5178>] ? write_msg+0xb1/0xb9 [netconsole]
[  145.032049]  [<f85c50c7>] ? write_msg+0x0/0xb9 [netconsole]
[  145.032049]  [<c013dd9c>] smp_call_function_mask+0x28/0x17d
[  145.032049]  [<f94f0020>] ? iwl3945_commit_rxon+0x714/0x824 [iwl3945]
[  145.032049]  [<c013df03>] smp_call_function+0x12/0x14
[  145.032049]  [<c01100ba>] native_smp_send_stop+0x1b/0x28
[  145.032049]  [<c029f759>] panic+0x41/0xd4
[  145.032049]  [<c0115e45>] do_page_fault+0x549/0x63c
[  145.032049]  [<c011d49f>] ? default_wake_function+0xb/0xd
[  145.032049]  [<c01317fe>] ? autoremove_wake_function+0xf/0x33
[  145.032049]  [<c01196e4>] ? __wake_up_common+0x35/0x5b
[  145.032049]  [<f8387737>] ? usb_hcd_submit_urb+0x850/0x93e [usbcore]
[  145.032049]  [<c01292d5>] ? lock_timer_base+0x1f/0x3e
[  145.032049]  [<c0138246>] ? clocksource_get_next+0x3c/0x43
[  145.032049]  [<c01373aa>] ? update_wall_time+0x5e1/0x712
[  145.032049]  [<c01158fc>] ? do_page_fault+0x0/0x63c
[  145.032049]  [<f94f435f>] ? iwl3945_irq_tasklet+0x691/0x1063 [iwl3945]
[  145.032049]  [<c01373aa>] ? update_wall_time+0x5e1/0x712
[  145.032049]  [<c01c5ad7>] ? __next_cpu+0x15/0x25
[  145.032049]  [<c011a134>] ? nr_active+0x32/0x4b
[  145.032049]  [<c0125b22>] __do_softirq+0x84/0x121
[  145.032049]  [<c0125cf9>] irq_exit+0x38/0x6d
[  145.032049]  [<c01039f3>] common_interrupt+0x23/0x28
[  145.032049]  [<f806c3a8>] ? acpi_idle_enter_simple+0x198/0x205 [processor]
[  145.032049]  [<c01e7918>] ? acpi_os_release_lock+0x8/0xa
[  145.032049]  [<c0135a45>] ? sched_clock_idle_wakeup_event+0xd/0xf
[  145.032049]  [<c024125e>] ? menu_select+0x38/0x86
[  145.032049]  [<c0240839>] cpuidle_idle_call+0x60/0x93
[  145.032049]  [<c02935ca>] rest_init+0x4e/0x50
[  145.032049] ------------[ cut here ]------------
[  145.032049] WARNING: at kernel/smp.c:220 smp_call_function_single+0x2d/0x9c()
 configfs drm cpufreq_ondemand binfmt_misc ipv6 loop ecb iwl3945 iwlcore thinkpad_acpi snd lib80211 video backlight psmouse rsrc_nonstatic i2c_i801 rng_core ac button jbd aes_i586 cbc dm_mod ata_generic ata_piix libata ide_pci_generic mmc_core usbcore processor fan[  145.032049] Pid: 0, comm: swapper Tainted: G      D W  2.6.28-rc9-wl #105
[  145.032049] Call Trace:
[  145.032049]  [<c029f7fb>] ? printk+0xf/0x14
[  145.032049]  [<c01219a3>] warn_on_slowpath+0x41/0x63
[  145.032049]  [<c02a1abf>] ? _spin_unlock+0x8/0xa
[  145.032049]  [<c025a4f2>] ? netpoll_send_udp+0x1e8/0x1f2
[  145.032049]  [<c013dd05>] smp_call_function_single+0x2d/0x9c
[  145.032049]  [<c01100c7>] ? stop_this_cpu+0x0/0x36
[  145.032049]  [<c01100c7>] ? stop_this_cpu+0x0/0x36
[  145.032049]  [<c013df03>] smp_call_function+0x12/0x14
[  145.032049]  [<c01100ba>] native_smp_send_stop+0x1b/0x28
[  145.032049]  [<c0105158>] oops_end+0x5d/0x71
[  145.032049]  [<c0115e45>] do_page_fault+0x549/0x63c
[  145.032049]  [<c011d49f>] ? default_wake_function+0xb/0xd
[  145.032049]  [<c01196e4>] ? __wake_up_common+0x35/0x5b
[  145.032049]  [<f8387737>] ? usb_hcd_submit_urb+0x850/0x93e [usbcore]
[  145.032049]  [<c02a1b32>] ? _spin_lock_irqsave+0xc/0x11
[  145.032049]  [<c01c5ad7>] ? __next_cpu+0x15/0x25
[  145.032049]  [<c0138246>] ? clocksource_get_next+0x3c/0x43
[  145.032049]  [<c0136a8b>] ? getnstimeofday+0x37/0xb9
[  145.032049]  [<c02a1ca2>] error_code+0x72/0x78
[  145.032049]  [<f94f435f>] ? iwl3945_irq_tasklet+0x691/0x1063 [iwl3945]
[  145.032049]  [<c01373aa>] ? update_wall_time+0x5e1/0x712
[  145.032049]  [<c01c5ad7>] ? __next_cpu+0x15/0x25
[  145.032049]  [<c012555d>] tasklet_action+0x61/0xac
[  145.032049]  [<c0125bf4>] do_softirq+0x35/0x3a
[  145.032049]  [<c0125cf9>] irq_exit+0x38/0x6d
[  145.032049]  [<c01039f3>] common_interrupt+0x23/0x28
[  145.032049]  [<f806c3a8>] ? acpi_idle_enter_simple+0x198/0x205 [processor]
[  145.032049]  [<f806bf80>] acpi_idle_enter_bm+0xca/0x35a [processor]
[  145.032049]  [<c0135a45>] ? sched_clock_idle_wakeup_event+0xd/0xf
[  145.032049]  [<c024125e>] ? menu_select+0x38/0x86
[  145.032049]  [<c0240839>] cpuidle_idle_call+0x60/0x93
[  145.032049]  [<c02935ca>] rest_init+0x4e/0x50

And the code around the part where, to my understanding, the crash
happened:

        u32 count = 8;

        /* uCode's read index (stored in shared DRAM) indicates the last Rx
         * buffer that the driver may process (last buffer filled by ucode). */
        r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
    c353:       8b 87 04 28 00 00       mov    0x2804(%edi),%eax
        i = rxq->read;
    c359:       8b 9f e4 27 00 00       mov    0x27e4(%edi),%ebx
        u8 fill_rx = 0;
        u32 count = 8;

        /* uCode's read index (stored in shared DRAM) indicates the last Rx
         * buffer that the driver may process (last buffer filled by ucode). */
        r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
    c35f:       0f b7 00                movzwl (%eax),%eax
        i = rxq->read;
    c362:       89 5d 94                mov    %ebx,-0x6c(%ebp)
        int s = q->read - q->write;
        if (s <= 0)
                s += RX_QUEUE_SIZE;
        /* keep some buffer to not confuse full and empty queue */
        s -= 2;
        if (s < 0)

Please fix this, wireless-testing is currently unusable for me.

-- 
Kalle Valo

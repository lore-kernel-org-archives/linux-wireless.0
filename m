Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web57603.mail.re1.yahoo.com ([66.196.100.85]:38817 "HELO
	web57603.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752133AbZAMEhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 23:37:07 -0500
References: <326502.74480.qm@web57615.mail.re1.yahoo.com> <1231528324.30298.14.camel@rc-desk> <960943.33934.qm@web57604.mail.re1.yahoo.com> <20090112183808.GA8485@sortiz.org> <614533.26753.qm@web57611.mail.re1.yahoo.com>
Date: Mon, 12 Jan 2009 20:37:05 -0800 (PST)
From: Deuce <the_deuce@yahoo.com>
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
To: Samuel Ortiz <samuel@sortiz.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <72177.92613.qm@web57603.mail.re1.yahoo.com> (sfid-20090113_053715_729034_037375AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> First off, cbd8b90ffd8a321ffb2a705733729f0d5ebb20f9 worked fine.

> 
> I ran through the git bisect as you can see below.  However, the original BUG_ON 
> was not triggered.  Instead, I encountered authentication time outs with my 
> unencrypted AP.  This made the nominally straightforward good/bad bisect 
> question a little more interesting.  When the BUG_ON was triggered, 
> authentication did not complete either, so take for what it's worth.
> 
> Was the restriction of git bisect to drivers/net/wireless/iwlwifi a bad idea?
> 
> I'll look into actually triggering the BUG_ON proper.

These three 'bad' results are from a NULL pointer.  Again, not the BUG_ON from earlier.

That's all for now.  I can try further tracking down the BUG_ON later.

My hardware isn't exotic... it's a Thinkpad T61.

Jason

$ git bisect log 
# bad: [10bc72100559eae0e27f111be96b5e4afd07a1dc] p54: power save management
# good: [a0dedce20b4db9e6a7200eacb4d10fc3ee4c1b6b] iwlwifi: replace IWL_ERROR with IWL_ERR
git-bisect start 'master-2009-01-06' 'a0dedce20b4db9e6a7200eacb4d10fc3ee4c1b6b' '--' 'drivers/net/wireless/iwlwifi/'
# good: [9bfb965e2826a3cc2f6abbefe59b9c3e8f0a8294] iwl3945: use iwl_get_hw_mode
git-bisect good 9bfb965e2826a3cc2f6abbefe59b9c3e8f0a8294
# bad: [ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f] iwl3945: sync tx queue data structure with iwlagn
git-bisect bad ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f
# bad: [1152ae0b199af7d712088e47189d8d75ca54051b] iwl3945: rearrange 3945 tfd
git-bisect bad 1152ae0b199af7d712088e47189d8d75ca54051b
# bad: [c2a0aa3cb733452e749727680e380dca6cc10a68] iwl3945: use iwl_rb_status
git-bisect bad c2a0aa3cb733452e749727680e380dca6cc10a68

$ git bisect bad
c2a0aa3cb733452e749727680e380dca6cc10a68 is first bad commit
commit c2a0aa3cb733452e749727680e380dca6cc10a68
Author: Winkler, Tomas <tomas.winkler@intel.com>
Date:   Fri Dec 19 10:37:43 2008 +0800

    iwl3945: use iwl_rb_status
    
    This patch makes use of iwl_rb_status also in 3945. The structure
    for 3945 is not the same but since only closed_rb_num filed is used
    in both cases there is no reason to duplicate it.
    
    Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
    Signed-off-by: Zhu Yi <yi.zhu@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

:040000 040000 276f324ba97b0d7f21e7e3c4c8c56642437ed128 b808ec3f0b7ccd48f6a05af1e5ced8eb01d06d67 M    drivers


(gdb) list *(iwl3945_irq_tasklet+0x5e6)
0x14a06 is in iwl3945_irq_tasklet (drivers/net/wireless/iwlwifi/iwl3945-base.c:3597).
3592        u8 fill_rx = 0;
3593        u32 count = 8;
3594    
3595        /* uCode's read index (stored in shared DRAM) indicates the last Rx
3596         * buffer that the driver may process (last buffer filled by ucode). */
3597        r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
3598        i = rxq->read;
3599    
3600        if (iwl3945_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
3601            fill_rx = 1;


[   28.310363] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[   28.310399] IP: [<ffffffffa037da06>] iwl3945_irq_tasklet+0x5e6/0x1400 [iwl3945]
[   28.310432] PGD 0 
[   28.310441] Oops: 0000 [#1] SMP 
[   28.310454] last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/firmware/0000:03:00.0/loading
[   28.310464] Dumping ftrace buffer:
[   28.310471]    (ftrace buffer empty)
[   28.310477] CPU 1 
[   28.310485] Modules linked in: i915 drm binfmt_misc acpi_cpufreq cpufreq_ondemand cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative freq_table pci_slot sbs sbshc container iptable_filter ip_tables x_tables sbp2 snd_hda_intel arc4 ecb snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss iwl3945 snd_seq_midi snd_rawmidi iwlcore snd_seq_midi_event thinkpad_acpi joydev snd_seq snd_timer mac80211 snd_seq_device pcmcia lib80211 rfkill cfg80211 snd led_class evdev battery yenta_socket intel_agp soundcore serio_raw psmouse pcspkr nvram video output ac wmi button rsrc_nonstatic pcmcia_core iTCO_wdt iTCO_vendor_support snd_page_alloc shpchp pci_hotplug ext3 jbd mbcache sd_mod crc_t10dif sr_mod cdrom sg ahci ata_piix ata_generic pata_acpi libata ohci1394 scsi_mod ieee1394 ehci_hcd uhci_hcd usbcore thermal processor fan fuse
[   28.310875] Pid: 0, comm: swapper Not tainted 2.6.28 #19
[   28.310882] RIP: 0010:[<ffffffffa037da06>]  [<ffffffffa037da06>] iwl3945_irq_tasklet+0x5e6/0x1400 [iwl3945]
[   28.310909] RSP: 0018:ffff88013b193e00  EFLAGS: 00010082
[   28.310916] RAX: 0000000000000000 RBX: ffff880137d54c90 RCX: 0000000000000000
[   28.310923] RDX: 0000000080000008 RSI: ffffc200050ba010 RDI: 0000000000010000
[   28.310930] RBP: ffff88013b193ec0 R08: 00000000000008f7 R09: 00000000000003bb
[   28.310939] R10: 0000000000000001 R11: ffff88013b18de68 R12: ffff880137d54c88
[   28.310946] R13: ffff880137d41ae0 R14: 0000000000000000 R15: ffffffff807f35a0
[   28.310954] FS:  0000000000000000(0000) GS:ffff88013bc03e00(0000) knlGS:0000000000000000
[   28.310962] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   28.310968] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
[   28.310975] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   28.310982] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   28.310989] Process swapper (pid: 0, threadinfo ffff88013b18c000, task ffff88013b184350)
[   28.310995] Stack:
[   28.311001]  ffff88013b193e7c 0000000697961840 0000000000000024 0000000000000000
[   28.311018]  0000000100000000 ffff880137d42504 0001000000000000 0000000000000282
[   28.311042]  ffff88013b193e58 0000000000000086 ffffffff807f32e0 ffff88013b193e98
[   28.311067] Call Trace:
[   28.311073]  <IRQ> <0> [<ffffffff8026744b>] ? hrtimer_get_next_event+0xcb/0xe0
[   28.311095]  [<ffffffff8026b1e9>] ? getnstimeofday+0x49/0xc0
[   28.311110]  [<ffffffff80267699>] ? ktime_get_ts+0x59/0x60
[   28.311122]  [<ffffffff80251e56>] tasklet_action+0x86/0x110
[   28.311136]  [<ffffffff8025256c>] __do_softirq+0x9c/0x170
[   28.311148]  [<ffffffff80214d8c>] call_softirq+0x1c/0x30
[   28.311161]  [<ffffffff802160bd>] do_softirq+0x5d/0xa0
[   28.311171]  [<ffffffff802522ed>] irq_exit+0x8d/0xa0
[   28.311182]  [<ffffffff80216389>] do_IRQ+0xc9/0x110
[   28.311193]  [<ffffffff80213b23>] ret_from_intr+0x0/0x29
[   28.311207]  <EOI> <0> [<ffffffffa001f678>] ? acpi_idle_enter_bm+0x28a/0x2da [processor]
[   28.311239]  [<ffffffffa001f670>] ? acpi_idle_enter_bm+0x282/0x2da [processor]
[   28.311258]  [<ffffffff805104af>] ? notifier_call_chain+0x3f/0x80
[   28.311272]  [<ffffffff80458d85>] ? cpuidle_idle_call+0xa5/0x100
[   28.311284]  [<ffffffff80211e75>] ? cpu_idle+0x65/0xc0
[   28.311297]  [<ffffffff80506e95>] ? start_secondary+0x168/0x1c3
[   28.311310] Code: a0 89 d9 48 c7 c7 58 04 39 a0 31 c0 e8 bd c5 18 e0 e9 e8 fd ff ff 0f 1f 80 00 00 00 00 41 8b 8d 28 4e 00 00 49 8b 85 60 4e 00 00 <0f> b7 00 89 4d d0 25 ff 0f 00 00 c6 45 87 00 89 45 8c 89 c8 41 
[   28.311529] RIP  [<ffffffffa037da06>] iwl3945_irq_tasklet+0x5e6/0x1400 [iwl3945]
[   28.311559]  RSP <ffff88013b193e00>
[   28.311566] CR2: 0000000000000000
[   28.311573] Kernel panic - not syncing: Fatal exception in interrupt
[   28.311584] ------------[ cut here ]------------
[   28.311590] WARNING: at kernel/smp.c:333 smp_call_function_mask+0x21a/0x220()
[   28.311596] Modules linked in: i915 drm binfmt_misc acpi_cpufreq cpufreq_ondemand cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative freq_table pci_slot sbs sbshc container iptable_filter ip_tables x_tables sbp2 snd_hda_intel arc4 ecb snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss iwl3945 snd_seq_midi snd_rawmidi iwlcore snd_seq_midi_event thinkpad_acpi joydev snd_seq snd_timer mac80211 snd_seq_device pcmcia lib80211 rfkill cfg80211 snd led_class evdev battery yenta_socket intel_agp soundcore serio_raw psmouse pcspkr nvram video output ac wmi button rsrc_nonstatic pcmcia_core iTCO_wdt iTCO_vendor_support snd_page_alloc shpchp pci_hotplug ext3 jbd mbcache sd_mod crc_t10dif sr_mod cdrom sg ahci ata_piix ata_generic pata_acpi libata ohci1394 scsi_mod ieee1394 ehci_hcd uhci_hcd usbcore thermal processor fan fuse
[   28.312022] Pid: 0, comm: swapper Tainted: G      D    2.6.28 #19
[   28.312028] Call Trace:
[   28.312034]  <IRQ>  [<ffffffff8024c5ef>] warn_on_slowpath+0x5f/0x90
[   28.312052]  [<ffffffff8024ce6d>] ? release_console_sem+0x1cd/0x220
[   28.312063]  [<ffffffff80274b6a>] smp_call_function_mask+0x21a/0x220
[   28.312074]  [<ffffffff80225570>] ? stop_this_cpu+0x0/0x30
[   28.312084]  [<ffffffff8050a010>] ? printk+0x67/0x6f
[   28.312094]  [<ffffffff802807b4>] ? crash_kexec+0x74/0x100
[   28.312103]  [<ffffffff80274b8b>] smp_call_function+0x1b/0x20
[   28.312112]  [<ffffffff80225543>] native_smp_send_stop+0x23/0x50
[   28.312122]  [<ffffffff80509eee>] panic+0xaf/0x16a
[   28.312237]  [<ffffffff80410dad>] ? do_unblank_screen+0x1d/0x150
[   28.312247]  [<ffffffff80410eeb>] ? unblank_screen+0xb/0x10
[   28.312255]  [<ffffffff8050e041>] oops_end+0xb1/0xc0
[   28.312264]  [<ffffffff8050fa48>] do_page_fault+0x278/0xca0
[   28.312273]  [<ffffffff8023a230>] ? enqueue_task+0x50/0x60
[   28.312282]  [<ffffffff8024347d>] ? resched_task+0x2d/0x90
[   28.312292]  [<ffffffff8024532c>] ? try_to_wake_up+0x12c/0x2e0
[   28.312304]  [<ffffffff802454ed>] ? default_wake_function+0xd/0x10
[   28.312314]  [<ffffffff802aca12>] ? mempool_free_slab+0x12/0x20
[   28.312323]  [<ffffffff802aca12>] ? mempool_free_slab+0x12/0x20
[   28.312331]  [<ffffffff802aca12>] ? mempool_free_slab+0x12/0x20
[   28.312340]  [<ffffffff802acaaa>] ? mempool_free+0x8a/0xa0
[   28.312351]  [<ffffffff8031204d>] ? bio_free+0x4d/0x60
[   28.312359]  [<ffffffff802aca12>] ? mempool_free_slab+0x12/0x20
[   28.312368]  [<ffffffff802aca12>] ? mempool_free_slab+0x12/0x20
[   28.312378]  [<ffffffff8039f6d9>] ? __next_cpu+0x19/0x30
[   28.312387]  [<ffffffff80242c9c>] ? find_busiest_group+0x1dc/0x990
[   28.312395]  [<ffffffff8050d1ba>] error_exit+0x0/0x70
[   28.312417]  [<ffffffffa037da06>] ? iwl3945_irq_tasklet+0x5e6/0x1400 [iwl3945]
[   28.312427]  [<ffffffff8026744b>] ? hrtimer_get_next_event+0xcb/0xe0
[   28.312435]  [<ffffffff8026b1e9>] ? getnstimeofday+0x49/0xc0
[   28.312444]  [<ffffffff80267699>] ? ktime_get_ts+0x59/0x60
[   28.312453]  [<ffffffff80251e56>] tasklet_action+0x86/0x110
[   28.312464]  [<ffffffff8025256c>] __do_softirq+0x9c/0x170
[   28.312473]  [<ffffffff80214d8c>] call_softirq+0x1c/0x30
[   28.312481]  [<ffffffff802160bd>] do_softirq+0x5d/0xa0
[   28.312490]  [<ffffffff802522ed>] irq_exit+0x8d/0xa0
[   28.312498]  [<ffffffff80216389>] do_IRQ+0xc9/0x110
[   28.312506]  [<ffffffff80213b23>] ret_from_intr+0x0/0x29
[   28.312511]  <EOI>  [<ffffffffa001f678>] ? acpi_idle_enter_bm+0x28a/0x2da [processor]
[   28.312547]  [<ffffffffa001f670>] ? acpi_idle_enter_bm+0x282/0x2da [processor]
[   28.312556]  [<ffffffff805104af>] ? notifier_call_chain+0x3f/0x80
[   28.312565]  [<ffffffff80458d85>] ? cpuidle_idle_call+0xa5/0x100
[   28.312575]  [<ffffffff80211e75>] ? cpu_idle+0x65/0xc0
[   28.312583]  [<ffffffff80506e95>] ? start_secondary+0x168/0x1c3
[   28.312590] ---[ end trace cae0f83424612347 ]---
[   28.312599] ------------[ cut here ]------------
[   28.312605] WARNING: at kernel/smp.c:220 smp_call_function_single+0xda/0x100()
[   28.312612] Modules linked in: i915 drm binfmt_misc acpi_cpufreq cpufreq_ondemand cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative freq_table pci_slot sbs sbshc container iptable_filter ip_tables x_tables sbp2 snd_hda_intel arc4 ecb snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss iwl3945 snd_seq_midi snd_rawmidi iwlcore snd_seq_midi_event thinkpad_acpi joydev snd_seq snd_timer mac80211 snd_seq_device pcmcia lib80211 rfkill cfg80211 snd led_class evdev battery yenta_socket intel_agp soundcore serio_raw psmouse pcspkr nvram video output ac wmi button rsrc_nonstatic pcmcia_core iTCO_wdt iTCO_vendor_support snd_page_alloc shpchp pci_hotplug ext3 jbd mbcache sd_mod crc_t10dif sr_mod cdrom sg ahci ata_piix ata_generic pata_acpi libata ohci1394 scsi_mod ieee1394 ehci_hcd uhci_hcd usbcore thermal processor fan fuse
[   28.313022] Pid: 0, comm: swapper Tainted: G      D W  2.6.28 #19
[   28.313028] Call Trace:
[   28.313136]  <IRQ>  [<ffffffff8024c5ef>] warn_on_slowpath+0x5f/0x90
[   28.313153]  [<ffffffff80509e36>] ? dump_stack+0x72/0x7b
[   28.313163]  [<ffffffff802758e7>] ? print_modules+0x57/0xb0
[   28.313172]  [<ffffffff8024c49e>] ? print_oops_end_marker+0x1e/0x20
[   28.313180]  [<ffffffff8024c5f5>] ? warn_on_slowpath+0x65/0x90
[   28.313189]  [<ffffffff8024ce6d>] ? release_console_sem+0x1cd/0x220
[   28.313200]  [<ffffffff8027492a>] smp_call_function_single+0xda/0x100
[   28.313210]  [<ffffffff80274ae0>] smp_call_function_mask+0x190/0x220
[   28.313219]  [<ffffffff80225570>] ? stop_this_cpu+0x0/0x30
[   28.313228]  [<ffffffff8050a010>] ? printk+0x67/0x6f
[   28.313237]  [<ffffffff802807b4>] ? crash_kexec+0x74/0x100
[   28.313247]  [<ffffffff80274b8b>] smp_call_function+0x1b/0x20
[   28.313256]  [<ffffffff80225543>] native_smp_send_stop+0x23/0x50
[   28.313264]  [<ffffffff80509eee>] panic+0xaf/0x16a
[   28.313275]  [<ffffffff80410dad>] ? do_unblank_screen+0x1d/0x150
[   28.313284]  [<ffffffff80410eeb>] ? unblank_screen+0xb/0x10
[   28.313292]  [<ffffffff8050e041>] oops_end+0xb1/0xc0
[   28.313301]  [<ffffffff8050fa48>] do_page_fault+0x278/0xca0
[   28.313309]  [<ffffffff8023a230>] ? enqueue_task+0x50/0x60
[   28.313318]  [<ffffffff8024347d>] ? resched_task+0x2d/0x90
[   28.313328]  [<ffffffff8024532c>] ? try_to_wake_up+0x12c/0x2e0
[   28.313337]  [<ffffffff802454ed>] ? default_wake_function+0xd/0x10
[   28.313346]  [<ffffffff802aca12>] ? mempool_free_slab+0x12/0x20
[   28.313357]  [<ffffffff802aca12>] ? mempool_free_slab+0x12/0x20
[   28.313366]  [<ffffffff802aca12>] ? mempool_free_slab+0x12/0x20
[   28.313374]  [<ffffffff802acaaa>] ? mempool_free+0x8a/0xa0
[   28.313384]  [<ffffffff8031204d>] ? bio_free+0x4d/0x60
[   28.313392]  [<ffffffff802aca12>] ? mempool_free_slab+0x12/0x20
[   28.313400]  [<ffffffff802aca12>] ? mempool_free_slab+0x12/0x20
[   28.313409]  [<ffffffff8039f6d9>] ? __next_cpu+0x19/0x30
[   28.313418]  [<ffffffff80242c9c>] ? find_busiest_group+0x1dc/0x990
[   28.313427]  [<ffffffff8050d1ba>] error_exit+0x0/0x70
[   28.313448]  [<ffffffffa037da06>] ? iwl3945_irq_tasklet+0x5e6/0x1400 [iwl3945]
[   28.313458]  [<ffffffff8026744b>] ? hrtimer_get_next_event+0xcb/0xe0
[   28.313466]  [<ffffffff8026b1e9>] ? getnstimeofday+0x49/0xc0
[   28.313475]  [<ffffffff80267699>] ? ktime_get_ts+0x59/0x60



      

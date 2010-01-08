Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58618 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab0AHRPg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:15:36 -0500
Subject: Scheduling while atomic: ieee80211_rx
From: reinette chatre <reinette.chatre@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Content-Type: text/plain
Date: Fri, 08 Jan 2010 09:15:31 -0800
Message-Id: <1262970931.11849.4518.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I saw some fixes recently but I do not recall seeing a similar trace to
what I am currently seeing. Apologies if this has already been
addressed.

Leaving my system with recent wireless-testing idle for a while triggers the following:

[76909.316114] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[78293.316117] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[80431.320044] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[83614.316126] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[85147.316106] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[85757.304600] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[85788.304121] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[85788.804107] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 2
[88000.304099] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[89869.304122] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[93154.304105] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[93309.304129] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[94359.804728] wlan0: detected beacon loss from AP - sending probe request
[97430.806319] BUG: scheduling while atomic: swapper/0/0x10000100
[97430.806331] 1 lock held by swapper/0:
[97430.806336]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffffa02b3f46>] ieee80211_rx+0xa6/0x9f0 [mac80211]
[97430.806378] Modules linked in: iwlagn iwlcore mac80211 cfg80211 aes_generic i915 drm_kms_helper drm i2c_algo_bit i2c_core ipv6 acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative cpufreq_stats freq_table container sbs sbshc arc4 ecb tpm_infineon joydev af_packet pcmcia tpm_tis yenta_socket rsrc_nonstatic tpm psmouse sony_laptop iTCO_wdt serio_raw pcspkr evdev pcmcia_core tpm_bios video output iTCO_vendor_support rfkill processor ac button intel_agp battery ext3 jbd mbcache sg sr_mod cdrom sd_mod ahci libata scsi_mod ehci_hcd uhci_hcd usbcore thermal fan thermal_sys [last unloaded: cfg80211]
[97430.806513] CPU 1 
[97430.806523] Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc2-wl-63539-g2b16786 #103 VAIO/VGN-Z540N
[97430.806531] RIP: 0010:[<ffffffff81359482>]  [<ffffffff81359482>] _raw_spin_unlock_irqrestore+0x42/0x60
[97430.806548] RSP: 0018:ffff8800bb541e48  EFLAGS: 00000282
[97430.806555] RAX: 00000000101c49df RBX: ffff8800bb541e58 RCX: 0000000000000000
[97430.806561] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8800bad50000
[97430.806568] RBP: ffffffff8135980e R08: 0000000000000000 R09: 0000000000000001
[97430.806574] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff8106b155
[97430.806581] R13: ffff8800bb541df8 R14: 0000000000000000 R15: ffffffff8154a660
[97430.806588] FS:  0000000000000000(0000) GS:ffff880002080000(0000) knlGS:0000000000000000
[97430.806595] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[97430.806602] CR2: 00007fe361485090 CR3: 00000000b72ab000 CR4: 00000000000006e0
[97430.806608] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[97430.806614] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[97430.806622] Process swapper (pid: 0, threadinfo ffff8800bb540000, task ffff8800bad50000)
[97430.806627] Stack:
[97430.806632]  0000000000000005 ffff8800b938800c ffff8800bb541e88 ffffffff8106a94c
[97430.806643] <0> ffff8800b9388548 ffff8800b9388000 000000000000009b 000000000000022a
[97430.806656] <0> ffff8800bb541e98 ffffffffa005403a ffff8800bb541ee8 ffffffffa00547ff
[97430.806670] Call Trace:
[97430.806682]  [<ffffffff8106a94c>] ? clockevents_notify+0x4c/0x150
[97430.806697]  [<ffffffffa005403a>] ? lapic_timer_state_broadcast+0x46/0x48 [processor]
[97430.806712]  [<ffffffffa00547ff>] ? acpi_idle_enter_simple+0x144/0x158 [processor]
[97430.806724]  [<ffffffff8129c8c7>] ? cpuidle_idle_call+0xa7/0x140
[97430.806735]  [<ffffffff81001f72>] ? cpu_idle+0x62/0xb0
[97430.806746]  [<ffffffff81352b07>] ? start_secondary+0x20c/0x24f
[97430.806752] Code: 8b 55 08 49 89 fc 48 8d 7f 18 48 89 f3 be 01 00 00 00 e8 92 a5 d1 ff 4c 89 e7 e8 5a 75 e7 ff f6 c7 02 74 15 e8 f0 77 d1 ff 53 9d <48> 8b 1c 24 4c 8b 64 24 08 c9 c3 0f 1f 00 53 9d e8 a9 64 d1 ff 
[97430.806877] Call Trace:
[97430.806885]  [<ffffffff8106a94c>] ? clockevents_notify+0x4c/0x150
[97430.806899]  [<ffffffffa005403a>] ? lapic_timer_state_broadcast+0x46/0x48 [processor]
[97430.806913]  [<ffffffffa00547ff>] ? acpi_idle_enter_simple+0x144/0x158 [processor]
[97430.806923]  [<ffffffff8129c8c7>] ? cpuidle_idle_call+0xa7/0x140
[97430.806932]  [<ffffffff81001f72>] ? cpu_idle+0x62/0xb0
[97430.806941]  [<ffffffff81352b07>] ? start_secondary+0x20c/0x24f
[98202.711836] BUG: scheduling while atomic: swapper/0/0x10000100
[98202.711848] 1 lock held by swapper/0:
[98202.711853]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffffa02b3f46>] ieee80211_rx+0xa6/0x9f0 [mac80211]
[98202.711895] Modules linked in: iwlagn iwlcore mac80211 cfg80211 aes_generic i915 drm_kms_helper drm i2c_algo_bit i2c_core ipv6 acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative cpufreq_stats freq_table container sbs sbshc arc4 ecb tpm_infineon joydev af_packet pcmcia tpm_tis yenta_socket rsrc_nonstatic tpm psmouse sony_laptop iTCO_wdt serio_raw pcspkr evdev pcmcia_core tpm_bios video output iTCO_vendor_support rfkill processor ac button intel_agp battery ext3 jbd mbcache sg sr_mod cdrom sd_mod ahci libata scsi_mod ehci_hcd uhci_hcd usbcore thermal fan thermal_sys [last unloaded: cfg80211]
[98202.712028] CPU 1 
[98202.712038] Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc2-wl-63539-g2b16786 #103 VAIO/VGN-Z540N
[98202.712046] RIP: 0010:[<ffffffffa00547e8>]  [<ffffffffa00547e8>] acpi_idle_enter_simple+0x12d/0x158 [processor]
[98202.712065] RSP: 0018:ffff8800bb541ea8  EFLAGS: 00000206
[98202.712071] RAX: ffff8800bb541fd8 RBX: ffff8800bb541ee8 RCX: 0000000000000000
[98202.712078] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8800bad50000
[98202.712084] RBP: ffffffff8135980e R08: 0000000000000000 R09: 0000000000000001
[98202.712090] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000082
[98202.712097] R13: ffff8800b938800c R14: 0000000000000046 R15: ffff8800bb541e48
[98202.712105] FS:  0000000000000000(0000) GS:ffff880002080000(0000) knlGS:0000000000000000
[98202.712112] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[98202.712118] CR2: 00007f76859e8000 CR3: 00000000b7cf7000 CR4: 00000000000006e0
[98202.712124] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[98202.712131] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[98202.712138] Process swapper (pid: 0, threadinfo ffff8800bb540000, task ffff8800bad50000)
[98202.712144] Stack:
[98202.712148]  0000000000000000 0000000000003a89 0000000000000000 0000000000003a89
[98202.712159] <0> ffff8800b9388020 ffff8800b93880f0 0000000000000000 0000000000000000
[98202.712172] <0> ffff8800bb541f08 ffffffff8129c8c7 ffff8800bb541fd8 ffffffff81592808
[98202.712186] Call Trace:
[98202.712200]  [<ffffffff8129c8c7>] ? cpuidle_idle_call+0xa7/0x140
[98202.712211]  [<ffffffff81001f72>] ? cpu_idle+0x62/0xb0
[98202.712223]  [<ffffffff81352b07>] ? start_secondary+0x20c/0x24f
[98202.712229] Code: c5 99 9e 36 00 48 89 d1 31 d2 48 f7 f1 48 69 f8 17 01 00 00 49 89 c6 e8 87 f3 00 e1 e8 92 c4 01 e1 fb 65 48 8b 04 25 48 b5 00 00 <83> 88 3c e0 ff ff 04 31 d2 48 89 de ff 43 18 4c 89 e7 e8 f5 f7 
[98202.712354] Call Trace:
[98202.712367]  [<ffffffffa00547de>] ? acpi_idle_enter_simple+0x123/0x158 [processor]
[98202.712378]  [<ffffffff8129c8c7>] ? cpuidle_idle_call+0xa7/0x140
[98202.712387]  [<ffffffff81001f72>] ? cpu_idle+0x62/0xb0
[98202.712396]  [<ffffffff81352b07>] ? start_secondary+0x20c/0x24f
[99187.304115] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[108167.304110] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[116671.090635] BUG: scheduling while atomic: swapper/0/0x10000100
[116671.090648] 1 lock held by swapper/0:
[116671.090653]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffffa02b3f46>] ieee80211_rx+0xa6/0x9f0 [mac80211]
[116671.090694] Modules linked in: iwlagn iwlcore mac80211 cfg80211 aes_generic i915 drm_kms_helper drm i2c_algo_bit i2c_core ipv6 acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative cpufreq_stats freq_table container sbs sbshc arc4 ecb tpm_infineon joydev af_packet pcmcia tpm_tis yenta_socket rsrc_nonstatic tpm psmouse sony_laptop iTCO_wdt serio_raw pcspkr evdev pcmcia_core tpm_bios video output iTCO_vendor_support rfkill processor ac button intel_agp battery ext3 jbd mbcache sg sr_mod cdrom sd_mod ahci libata scsi_mod ehci_hcd uhci_hcd usbcore thermal fan thermal_sys [last unloaded: cfg80211]
[116671.090827] CPU 1 
[116671.090838] Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc2-wl-63539-g2b16786 #103 VAIO/VGN-Z540N
[116671.090845] RIP: 0010:[<ffffffff8106ca90>]  [<ffffffff8106ca90>] tick_nohz_restart_sched_tick+0x1a0/0x1c0
[116671.090863] RSP: 0018:ffff8800bb541ee0  EFLAGS: 00000292
[116671.090870] RAX: 0000000013153291 RBX: ffff8800bb541f08 RCX: 0000000000000000
[116671.090877] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8800bad50000
[116671.090883] RBP: ffffffff8135980e R08: 0000000000000000 R09: 0000000000000001
[116671.090890] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000181359497
[116671.090896] R13: ffff8800bb541e68 R14: ffffffff8106f94d R15: ffff8800bb541e48
[116671.090904] FS:  0000000000000000(0000) GS:ffff880002080000(0000) knlGS:0000000000000000
[116671.090911] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[116671.090917] CR2: 00007fe361decc50 CR3: 00000000b72ab000 CR4: 00000000000006e0
[116671.090923] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[116671.090930] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[116671.090937] Process swapper (pid: 0, threadinfo ffff8800bb540000, task ffff8800bad50000)
[116671.090943] Stack:
[116671.090947]  ffff8800bb541fd8 ffffffff81592808 0000000000000000 0000000000000000
[116671.090959] <0> 0000000000000000 ffff8800bb541f28 ffffffff81001fa5 0000000000000000
[116671.090971] <0> 0000000000000000 ffff8800bb541f48 ffffffff81352b07 727574616e676973
[116671.090985] Call Trace:
[116671.090998]  [<ffffffff81001fa5>] ? cpu_idle+0x95/0xb0
[116671.091009]  [<ffffffff81352b07>] ? start_secondary+0x20c/0x24f
[116671.091016] Code: 75 c9 48 8b 73 20 48 8b 53 18 b9 02 00 00 00 48 89 df 48 29 f2 e8 31 50 ff ff 48 83 7b 38 00 74 b9 e8 e5 41 00 00 fb 48 83 c4 08 <5b> 41 5c 41 5d 41 5e 41 5f c9 c3 0f 1f 44 00 00 e8 9b b9 fb ff 
[116671.091141] Call Trace:
[116671.091149]  [<ffffffff81001fa5>] ? cpu_idle+0x95/0xb0
[116671.091158]  [<ffffffff81352b07>] ? start_secondary+0x20c/0x24f
[117899.316107] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[117899.816142] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 2
[117967.316112] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[126533.804139] wlan0: detected beacon loss from AP - sending probe request
[133702.667632] kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[135294.607505] BUG: scheduling while atomic: swapper/0/0x10000100
[135294.607519] 1 lock held by swapper/0:
[135294.607525]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffffa02b3f46>] ieee80211_rx+0xa6/0x9f0 [mac80211]
[135294.607568] Modules linked in: iwlagn iwlcore mac80211 cfg80211 aes_generic i915 drm_kms_helper drm i2c_algo_bit i2c_core ipv6 acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative cpufreq_stats freq_table container sbs sbshc arc4 ecb tpm_infineon joydev af_packet pcmcia tpm_tis yenta_socket rsrc_nonstatic tpm psmouse sony_laptop iTCO_wdt serio_raw pcspkr evdev pcmcia_core tpm_bios video output iTCO_vendor_support rfkill processor ac button intel_agp battery ext3 jbd mbcache sg sr_mod cdrom sd_mod ahci libata scsi_mod ehci_hcd uhci_hcd usbcore thermal fan thermal_sys [last unloaded: cfg80211]
[135294.607726] CPU 0 
[135294.607737] Pid: 0, comm: swapper Tainted: G        W  2.6.33-rc2-wl-63539-g2b16786 #103 VAIO/VGN-Z540N
[135294.607746] RIP: 0010:[<ffffffff8106ca90>]  [<ffffffff8106ca90>] tick_nohz_restart_sched_tick+0x1a0/0x1c0
[135294.607766] RSP: 0018:ffffffff81507f00  EFLAGS: 00000296
[135294.607773] RAX: 0000000019d7361b RBX: ffffffff81507f28 RCX: 0000000000000000
[135294.607781] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff8153a020
[135294.607789] RBP: ffffffff8135980e R08: 0000000000000000 R09: 0000000000000001
[135294.607797] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000181359497
[135294.607805] R13: ffffffff81507e88 R14: ffffffff8106f94d R15: ffffffff81507e68
[135294.607814] FS:  0000000000000000(0000) GS:ffff880002000000(0000) knlGS:0000000000000000
[135294.607822] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[135294.607830] CR2: 00007fe361dd72a0 CR3: 00000000b7cf7000 CR4: 00000000000006f0
[135294.607837] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[135294.607845] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[135294.607854] Process swapper (pid: 0, threadinfo ffffffff81506000, task ffffffff8153a020)
[135294.607861] Stack:
[135294.607865]  ffffffff81507fd8 ffffffff81592808 0000000000000000 ffffffffffffffff
[135294.607878] <0> fffffffff000bd3c ffffffff81507f48 ffffffff81001fa5 0000000000000000
[135294.607892] <0> 6db6db6db6db6db7 ffffffff81507f58 ffffffff81343659 ffffffff81507f98
[135294.607907] Call Trace:
[135294.607920]  [<ffffffff81001fa5>] ? cpu_idle+0x95/0xb0
[135294.607932]  [<ffffffff81343659>] ? rest_init+0x79/0x80
[135294.607943]  [<ffffffff815add01>] ? start_kernel+0x398/0x3a4
[135294.607955]  [<ffffffff815ad310>] ? x86_64_start_reservations+0x120/0x124
[135294.607966]  [<ffffffff815ad3f8>] ? x86_64_start_kernel+0xe4/0xeb
[135294.607972] Code: 75 c9 48 8b 73 20 48 8b 53 18 b9 02 00 00 00 48 89 df 48 29 f2 e8 31 50 ff ff 48 83 7b 38 00 74 b9 e8 e5 41 00 00 fb 48 83 c4 08 <5b> 41 5c 41 5d 41 5e 41 5f c9 c3 0f 1f 44 00 00 e8 9b b9 fb ff 
[135294.608139] Call Trace:
[135294.608150]  [<ffffffff81001fa5>] ? cpu_idle+0x95/0xb0
[135294.608159]  [<ffffffff81343659>] ? rest_init+0x79/0x80
[135294.608168]  [<ffffffff815add01>] ? start_kernel+0x398/0x3a4
[135294.608179]  [<ffffffff815ad310>] ? x86_64_start_reservations+0x120/0x124
[135294.608189]  [<ffffffff815ad3f8>] ? x86_64_start_kernel+0xe4/0xeb
[137098.804124] wlan0: detected beacon loss from AP - sending probe request
[140131.304621] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1
[143919.316593] No probe response from AP 00:14:a8:a0:a9:54 after 500ms, try 1



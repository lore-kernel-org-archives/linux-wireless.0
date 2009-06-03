Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51690 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbZFCVFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 17:05:54 -0400
Subject: Re: [RFT 1/3] iwlwifi: port to cfg80211 rfkill
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090602111111.956543636@sipsolutions.net>
References: <20090602111027.460530075@sipsolutions.net>
	 <20090602111111.956543636@sipsolutions.net>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 14:12:50 -0700
Message-Id: <1244063570.17790.203.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Tue, 2009-06-02 at 04:10 -0700, Johannes Berg wrote:
> This ports the iwlwifi rfkill code to the new API offered by
> cfg80211 and thus removes a lot of useless stuff. The soft-
> rfkill is completely removed since that is now handled by
> setting the interfaces down.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> ---

* I tried this patch on top of latest wireless-testing (rc8 based) on a
Sony laptop. After I bring the interface up I enabled rfkill and saw a
gpf in the sony-laptop module (log is below). I tried this test many
times after this and did not see this gpf again.

* I tried to load the modules with rfkill enabled and then disabled
rfkill after interface up - that worked fine.

* In another test I had rfkill disabled and successfully associated with
AP. I then enabled rfkill and was disassociated as expected. I then
disabled rfkill again and used "iwconfig" to reassociate successfully. 

* In another test rfkill was disabled and I associated with AP. I then
enabled and disabled rfkill rapidly and did not loose association.

In summary the testing went very well. There was that one gpf that
clouded the testing a bit. I have no idea how it can be connected to the
rfkill work though because the error appear to be contained in the
sony-laptop module.

Reinette


[  680.856249] PM: Adding info for platform:regulatory.0
[  680.856351] cfg80211: Using static regulatory domain info
[  680.856358] cfg80211: Regulatory domain: US
[  680.856362] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  680.856371] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[  680.856378] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  680.856386] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  680.856393] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  680.856400] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  680.856407] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[  680.856897] cfg80211: Calling CRDA for country: US
[  680.946854] cfg80211: Regulatory domain changed to country: US
[  680.946862] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  680.946871] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  680.946878] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[  680.946886] 	(5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  680.946893] 	(5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  680.946901] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[  681.002106] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
[  681.002109] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[  681.002262] iwlagn 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  681.002301] iwlagn 0000:06:00.0: setting latency timer to 64
[  681.002356] iwlagn 0000:06:00.0: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
[  681.042422] iwlagn 0000:06:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[  681.042514] iwlagn 0000:06:00.0: irq 30 for MSI/MSI-X
[  681.042840] PM: Adding info for No Bus:phy0
[  681.043112] PM: Adding info for No Bus:rfkill4
[  681.046709] PM: Adding info for No Bus:wmaster0
[  681.047776] phy0: Selected rate control algorithm 'iwl-agn-rs'
[  681.049477] PM: Adding info for No Bus:wlan0
[  681.050843] PM: Adding info for No Bus:rfkill5
[  688.674007] iwlagn 0000:06:00.0: firmware: requesting iwlwifi-5000-2.ucode
[  688.674495] PM: Adding info for No Bus:0000:06:00.0
[  688.706155] PM: Removing info for No Bus:0000:06:00.0
[  688.706893] iwlagn 0000:06:00.0: loaded firmware version 8.24.2.12
[  688.966303] PM: Adding info for No Bus:iwl-phy0::radio
[  688.967144] Registered led device: iwl-phy0::radio
[  688.967231] PM: Adding info for No Bus:iwl-phy0::assoc
[  688.967341] Registered led device: iwl-phy0::assoc
[  688.967453] PM: Adding info for No Bus:iwl-phy0::RX
[  688.967561] Registered led device: iwl-phy0::RX
[  688.967642] PM: Adding info for No Bus:iwl-phy0::TX
[  688.967749] Registered led device: iwl-phy0::TX
[  689.180640] phy0: device now idle
[  689.182350] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  692.451576] phy0: device no longer idle - scanning
[  692.997766] cfg80211: Found new beacon on frequency: 5180 MHz (Ch 36) on phy0
[  693.031112] cfg80211: Found new beacon on frequency: 5200 MHz (Ch 40) on phy0
[  693.077197] cfg80211: Found new beacon on frequency: 5220 MHz (Ch 44) on phy0
[  693.142511] cfg80211: Found new beacon on frequency: 5240 MHz (Ch 48) on phy0
[  694.820445] cfg80211: Found new beacon on frequency: 5745 MHz (Ch 149) on phy0
[  694.851276] cfg80211: Found new beacon on frequency: 5765 MHz (Ch 153) on phy0
[  694.887420] cfg80211: Found new beacon on frequency: 5785 MHz (Ch 157) on phy0
[  694.911855] cfg80211: Found new beacon on frequency: 5805 MHz (Ch 161) on phy0
[  695.050393] phy0: device now idle
[  709.268874] iwlagn 0000:06:00.0: Radio Frequency Kill Switch is On:
[  709.268879] Kill switch must be turned off for wireless networking to work.
[  709.366404] general protection fault: 0000 [#1] SMP 
[  709.366551] last sysfs file: /sys/class/rfkill/rfkill5/state
[  709.366616] CPU 1 
[  709.366707] Modules linked in: iwlagn iwlcore led_class mac80211 cfg80211 i915 drm i2c_algo_bit i2c_core ppdev ipv6 acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_conservative cpufreq_stats freq_table container sbs sbshc lp parport arc4 ecb pcmcia joydev yenta_socket rsrc_nonstatic af_packet tpm_infineon sony_laptop psmouse iTCO_wdt iTCO_vendor_support pcmcia_core intel_agp video output tpm tpm_bios rfkill pcspkr serio_raw processor battery button ac evdev ext3 jbd mbcache sg sr_mod sd_mod cdrom ahci libata scsi_mod ehci_hcd uhci_hcd usbcore thermal fan thermal_sys fuse [last unloaded: cfg80211]
[  709.369182] Pid: 66, comm: kacpi_notify Not tainted 2.6.30-rc8-wl #40 VGN-Z540N
[  709.369182] RIP: 0010:[<ffffffffa0200dda>]  [<ffffffffa0200dda>] sony_nc_rfkill_set+0xa/0x40 [sony_laptop]
[  709.369182] RSP: 0018:ffff8800bb663dc0  EFLAGS: 00010286
[  709.369182] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000001
[  709.369182] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff880036f74480
[  709.369182] RBP: ffff8800bb663dd0 R08: 0000000000000000 R09: 0000000000000000
[  709.369182] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[  709.369182] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8800bb663df0
[  709.369182] FS:  0000000000000000(0000) GS:ffff88000105e000(0000) knlGS:0000000000000000
[  709.369182] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  709.369182] CR2: 00007ffff2051000 CR3: 00000000ba6b6000 CR4: 00000000000006e0
[  709.369182] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  709.369182] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  709.369182] Process kacpi_notify (pid: 66, threadinfo ffff8800bb662000, task ffff8800bb658f40)
[  709.369182] Stack:
[  709.369182]  0000000000000000 0000000000000000 ffff8800bb663e20 ffffffffa0203292
[  709.369182]  ffff8800bb659548 0000000000000246 0000000000000202 ffff8800b729e2f8
[  709.369182]  ffff8800b5371898 ffff8800bb658f40 ffff880001058ec0 ffffffff803b5596
[  709.369182] Call Trace:
[  709.369182]  [<ffffffffa0203292>] sony_nc_notify+0x222/0x260 [sony_laptop]
[  709.369182]  [<ffffffff803b5596>] ? acpi_os_execute_deferred+0x0/0x39
[  709.369182]  [<ffffffff803b8192>] acpi_device_notify+0x14/0x16
[  709.369182]  [<ffffffff803c5690>] acpi_ev_notify_dispatch+0x5f/0x6b
[  709.369182]  [<ffffffff803b55c2>] acpi_os_execute_deferred+0x2c/0x39
[  709.369182]  [<ffffffff8024d720>] worker_thread+0x1f0/0x340
[  709.369182]  [<ffffffff8024d6cd>] ? worker_thread+0x19d/0x340
[  709.369182]  [<ffffffff802525a0>] ? autoremove_wake_function+0x0/0x40
[  709.369182]  [<ffffffff80263a8d>] ? trace_hardirqs_on+0xd/0x10
[  709.369182]  [<ffffffff8024d530>] ? worker_thread+0x0/0x340
[  709.369182]  [<ffffffff8024d530>] ? worker_thread+0x0/0x340
[  709.369182]  [<ffffffff80252156>] kthread+0x56/0x90
[  709.369182]  [<ffffffff8020ce7a>] child_rip+0xa/0x20
[  709.369182]  [<ffffffff8020c87c>] ? restore_args+0x0/0x30
[  709.369182]  [<ffffffff80252100>] ? kthread+0x0/0x90
[  709.369182]  [<ffffffff8020ce70>] ? child_rip+0x0/0x20
[  709.369182] Code: e1 89 c2 48 c7 c6 36 4e 20 a0 e8 b2 fe ff ff 89 c2 89 d0 48 8b 1c 24 4c 8b 64 24 08 c9 c3 0f 1f 00 55 89 f2 48 89 e5 48 83 ec 10 <8b> 34 bd 80 3e 20 a0 bf 24 01 00 00 81 c6 00 01 00 00 89 f0 0d 
[  709.369182] RIP  [<ffffffffa0200dda>] sony_nc_rfkill_set+0xa/0x40 [sony_laptop]
[  709.369182]  RSP <ffff8800bb663dc0>
[  709.375883] ---[ end trace 6c116875da7d6347 ]---
[  709.432645] usb 6-2: USB disconnect, address 2
[  709.432753] PM: Removing info for No Bus:usbdev6.2_ep81
[  709.433263] PM: Removing info for No Bus:usbdev6.2_ep82
[  709.433600] PM: Removing info for No Bus:usbdev6.2_ep02
[  709.433922] PM: Removing info for usb:6-2:1.0
[  709.434237] PM: Removing info for No Bus:usbdev6.2_ep83
[  709.434548] PM: Removing info for No Bus:usbdev6.2_ep03
[  709.435449] PM: Removing info for usb:6-2:1.1
[  709.435886] PM: Removing info for No Bus:usbdev6.2_ep84
[  709.436237] PM: Removing info for No Bus:usbdev6.2_ep04
[  709.436596] PM: Removing info for usb:6-2:1.2
[  709.436932] PM: Removing info for usb:6-2:1.3
[  709.437280] PM: Removing info for No Bus:usbdev6.2_ep00
[  709.437654] PM: Removing info for usb:6-2



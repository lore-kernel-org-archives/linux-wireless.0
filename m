Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:45064 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYFDNHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 09:07:21 -0400
Date: Wed, 4 Jun 2008 15:04:52 +0200
From: maximilian attems <max@stro.at>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-mm@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Page allocation failure in 2.6.26-rc2 (iwl4965 driver)
Message-ID: <20080604130452.GD9258@baikonur.stro.at> (sfid-20080604_150727_588795_F8A22857)
References: <20080604130307.GN5012@ics.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080604130307.GN5012@ics.muni.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 04, 2008 at 03:03:07PM +0200, Lukas Hejtmanek wrote:
> in the recent kernels I sometimes got the following allocation failure. It is
> provoked by ifconfig wlan0 up. I have machine with 2GB RAM and 1.5GB of swap
> (99% free). It happens if I start netbeans (which takes fair amount of memory)
> and keep running netbeans whole night (so that updatedb and slocate are woken
> up). 

similar with 2.6.25-rc3-git7 not a regression. happens for me since
early merge of iwlwifi after several resume and suspend cycles + mem
pressure.
 
 PCI interrupt for device 0000:00:1a.1 disabled
[17329950.341109] ACPI: PCI interrupt for device 0000:00:1a.0 disabled
[17329950.520323] ACPI: PCI interrupt for device 0000:00:19.0 disabled
[17329950.538683] ACPI: Preparing to enter system sleep state S3
[17329950.553844] Disabling non-boot CPUs ...
[17329950.553866] CPU0 attaching NULL sched-domain.
[17329950.553872] CPU1 attaching NULL sched-domain.
[17329950.668418] CPU 1 is now offline
[17329950.668422] SMP alternatives: switching to UP code
[17329950.677089] CPU0 attaching sched-domain:
[17329950.677092]  domain 0: span 0
[17329950.677094]   groups: 0
[17329950.677347] CPU1 is down
[17329950.677447] Extended CMOS year: 2000
[17329950.677447] Back to C!
[17329950.677822] Extended CMOS year: 2000
[17329950.677995] Enabling non-boot CPUs ...
[17329950.678319] CPU0 attaching NULL sched-domain.
[17329950.689065] SMP alternatives: switching to SMP code
[17329950.706717] Booting processor 1/1 ip 6000
[17329950.716658] Initializing CPU#1
[17329950.716658] Calibrating delay using timer specific routine.. 3191.85 BogoMIPS (lpj=6383716)
[17329950.716658] CPU: L1 I cache: 32K, L1 D cache: 32K
[17329950.716658] CPU: L2 cache: 4096K
[17329950.716658] CPU 1/1 -> Node 0
[17329950.716658] CPU: Physical Processor ID: 0
[17329950.716658] CPU: Processor Core ID: 1
[17329950.797619] CPU1: Intel(R) Core(TM)2 Duo CPU     L7500  @ 1.60GHz stepping 0a
[17329950.797770] CPU0 attaching sched-domain:
[17329950.797777]  domain 0: span 0-1
[17329950.797781]   groups: 0 1
[17329950.797787]   domain 1: span 0-1
[17329950.797791]    groups: 0-1
[17329950.797798] CPU1 attaching sched-domain:
[17329950.797802]  domain 0: span 0-1
[17329950.797805]   groups: 1 0
[17329950.797811]   domain 1: span 0-1
[17329950.797814]    groups: 0-1
[17329950.716658] CPU1 is up
[17329950.844666] Switched to high resolution mode on CPU 1
[17329950.973970] ACPI: EC: non-query interrupt received, switching to interrupt mode
[17329951.034056] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 900007, writing 900003)
[17329951.074061] PM: Writing back config space on device 0000:00:02.1 at offset 1 (was 900000, writing 900007)
[17329951.090208] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[17329951.090226] PCI: Setting latency timer of device 0000:00:19.0 to 64
[17329951.391805] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
[17329951.391822] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[17329951.391957] usb usb2: root hub lost power or was reset
[17329951.391995] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[17329951.392055] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[17329951.392188] usb usb3: root hub lost power or was reset
[17329951.407620] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
[17329951.407620] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[17329951.421723] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100106, writing 100102)
[17329951.421798] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
[17329951.421819] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[17329951.421960] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
[17329951.422085] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[17329951.422200] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
[17329951.422472] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[17329951.422496] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
[17329951.422511] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[17329951.422647] usb usb5: root hub lost power or was reset
[17329951.422682] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
[17329951.422697] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[17329951.422829] usb usb6: root hub lost power or was reset
[17329951.438605] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
[17329951.438624] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[17329951.438858] PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100007)
[17329951.438924] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[17329951.439150] ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
[17329951.453382] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00007, writing 2b00407)
[17329951.453524] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[17329952.631908] PM: Writing back config space on device 0000:05:00.1 at offset 4 (was 0, writing d7efe800)
[17329952.631926] PM: Writing back config space on device 0000:05:00.1 at offset 3 (was 800000, writing 804000)
[17329952.631947] PM: Writing back config space on device 0000:05:00.1 at offset 1 (was 2100000, writing 2100006)
[17329952.728052] PM: Writing back config space on device 0000:05:00.2 at offset 4 (was 0, writing d7efe400)
[17329952.728069] PM: Writing back config space on device 0000:05:00.2 at offset 3 (was 800000, writing 804000)
[17329952.728088] PM: Writing back config space on device 0000:05:00.2 at offset 1 (was 2100000, writing 2100006)
[17329952.728144] ACPI: PCI Interrupt 0000:05:00.2[C] -> GSI 18 (level, low) -> IRQ 18
[17329952.785917] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[17329952.787515] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[17329952.787523] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[17329952.787619] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[17329952.788057] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[17329952.793528] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[17329952.793528] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[17329952.793596] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[17329952.794209] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[17329952.795019] ata1.00: configured for UDMA/100
[17329952.797417] ata1.00: configured for UDMA/100
[17329952.797421] ata1: EH complete
[17329952.797490] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[17329952.797511] sd 0:0:0:0: [sda] Write Protect is off
[17329952.797513] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[17329952.797550] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17329952.797586] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[17329952.797605] sd 0:0:0:0: [sda] Write Protect is off
[17329952.797608] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[17329952.797625] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17329953.856328] usb 2-2: reset full speed USB device using uhci_hcd and address 2
[17329954.007231] sd 0:0:0:0: [sda] Starting disk
[17329954.051701] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[17329954.220470] Restarting tasks ... done.
[17329954.327346] CPU0 attaching NULL sched-domain.
[17329954.327359] CPU1 attaching NULL sched-domain.
[17329954.335532] CPU0 attaching sched-domain:
[17329954.335541]  domain 0: span 0-1
[17329954.335543]   groups: 0 1
[17329954.335548]   domain 1: span 0-1
[17329954.335551]    groups: 0-1
[17329954.335554]    domain 2: span 0-1
[17329954.335557]     groups: 0-1
[17329954.335561] CPU1 attaching sched-domain:
[17329954.335563]  domain 0: span 0-1
[17329954.335565]   groups: 1 0
[17329954.335569]   domain 1: span 0-1
[17329954.335572]    groups: 0-1
[17329954.335575]    domain 2: span 0-1
[17329954.335577]     groups: 0-1
[17335350.999125] PM: Syncing filesystems ... done.
[17335351.042907] Freezing user space processes ... (elapsed 0.02 seconds) done.
[17335351.071110] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[17335351.071110] Suspending console(s)
[17335351.071694] drm_sysfs_suspend
[17335351.075680] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[17335351.090734] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[17335351.115334] sd 0:0:0:0: [sda] Stopping disk
[17335354.097562] ACPI handle has no context!
[17335354.097588] ACPI: PCI interrupt for device 0000:05:00.2 disabled
[17335354.097596] ACPI handle has no context!
[17335354.120154] ACPI handle has no context!
[17335354.184285] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[17335354.203112] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[17335354.203150] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[17335354.216475] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[17335354.232291] ACPI: PCI interrupt for device 0000:00:1a.7 disabled
[17335354.250104] ACPI: PCI interrupt for device 0000:00:1a.1 disabled
[17335354.250187] ACPI: PCI interrupt for device 0000:00:1a.0 disabled
[17335354.431388] ACPI: PCI interrupt for device 0000:00:19.0 disabled
[17335354.449621] ACPI: Preparing to enter system sleep state S3
[17335354.461503] Disabling non-boot CPUs ...
[17335354.461519] CPU0 attaching NULL sched-domain.
[17335354.461522] CPU1 attaching NULL sched-domain.
[17335354.575707] CPU 1 is now offline
[17335354.575711] SMP alternatives: switching to UP code
[17335354.584400] CPU0 attaching sched-domain:
[17335354.584403]  domain 0: span 0
[17335354.584405]   groups: 0
[17335354.584660] CPU1 is down
[17335354.584763] Extended CMOS year: 2000
[17335354.584763] Back to C!
[17335354.585133] Extended CMOS year: 2000
[17335354.585300] Enabling non-boot CPUs ...
[17335354.585633] CPU0 attaching NULL sched-domain.
[17335354.596241] SMP alternatives: switching to SMP code
[17335354.604199] Booting processor 1/1 ip 6000
[17335354.612030] Initializing CPU#1
[17335354.612030] Calibrating delay using timer specific routine.. 3192.14 BogoMIPS (lpj=6384286)
[17335354.612030] CPU: L1 I cache: 32K, L1 D cache: 32K
[17335354.612030] CPU: L2 cache: 4096K
[17335354.612030] CPU 1/1 -> Node 0
[17335354.612030] CPU: Physical Processor ID: 0
[17335354.612030] CPU: Processor Core ID: 1
[17335354.692422] CPU1: Intel(R) Core(TM)2 Duo CPU     L7500  @ 1.60GHz stepping 0a
[17335354.692501] CPU0 attaching sched-domain:
[17335354.692505]  domain 0: span 0-1
[17335354.692506]   groups: 0 1
[17335354.692510]   domain 1: span 0-1
[17335354.692512]    groups: 0-1
[17335354.692514]    domain 2: span 0-1
[17335354.692516]     groups: 0-1
[17335354.692519] CPU1 attaching sched-domain:
[17335354.692521]  domain 0: span 0-1
[17335354.692523]   groups: 1 0
[17335354.692526]   domain 1: span 0-1
[17335354.692528]    groups: 0-1
[17335354.692530]    domain 2: span 0-1
[17335354.692532]     groups: 0-1
[17335354.724038] Switched to high resolution mode on CPU 1
[17335354.728024] CPU1 is up
[17335354.849404] ACPI: EC: non-query interrupt received, switching to interrupt mode
[17335354.905596] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 900007, writing 900003)
[17335354.930401] PM: Writing back config space on device 0000:00:02.1 at offset 1 (was 900000, writing 900007)
[17335354.944255] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[17335354.944267] PCI: Setting latency timer of device 0000:00:19.0 to 64
[17335355.239622] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
[17335355.239633] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[17335355.239734] usb usb2: root hub lost power or was reset
[17335355.239763] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[17335355.239771] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[17335355.239855] usb usb3: root hub lost power or was reset
[17335355.255665] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
[17335355.255665] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[17335355.271212] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100106, writing 100102)
[17335355.271276] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
[17335355.271288] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[17335355.703455] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
[17335355.703519] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[17335355.703582] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
[17335355.703643] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[17335355.703662] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
[17335355.703669] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[17335355.703736] usb usb5: root hub lost power or was reset
[17335355.703765] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
[17335355.703771] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[17335355.703841] usb usb6: root hub lost power or was reset
[17335355.720096] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
[17335355.720106] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[17335355.720281] PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100007)
[17335355.720327] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[17335355.720483] ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
[17335355.735407] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00007, writing 2b00407)
[17335355.735515] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[17335356.912897] PM: Writing back config space on device 0000:05:00.1 at offset 4 (was 0, writing d7efe800)
[17335356.912908] PM: Writing back config space on device 0000:05:00.1 at offset 3 (was 800000, writing 804000)
[17335356.912921] PM: Writing back config space on device 0000:05:00.1 at offset 1 (was 2100000, writing 2100006)
[17335357.008886] PM: Writing back config space on device 0000:05:00.2 at offset 4 (was 0, writing d7efe400)
[17335357.008897] PM: Writing back config space on device 0000:05:00.2 at offset 3 (was 800000, writing 804000)
[17335357.008911] PM: Writing back config space on device 0000:05:00.2 at offset 1 (was 2100000, writing 2100006)
[17335357.008952] ACPI: PCI Interrupt 0000:05:00.2[C] -> GSI 18 (level, low) -> IRQ 18
[17335357.068798] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[17335357.070203] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[17335357.070207] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[17335357.070559] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[17335357.070993] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[17335357.075914] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[17335357.075914] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[17335357.075966] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[17335357.076358] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[17335357.077132] ata1.00: configured for UDMA/100
[17335357.078894] ata1.00: configured for UDMA/100
[17335357.078894] ata1: EH complete
[17335357.079113] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[17335357.079134] sd 0:0:0:0: [sda] Write Protect is off
[17335357.079136] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[17335357.079172] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17335357.079207] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[17335357.079226] sd 0:0:0:0: [sda] Write Protect is off
[17335357.079228] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[17335357.079263] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17335358.122326] usb 2-2: reset full speed USB device using uhci_hcd and address 2
[17335359.427724] sd 0:0:0:0: [sda] Starting disk
[17335359.469527] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[17335359.600591] Restarting tasks ... done.
[17335955.127107] PM: Syncing filesystems ... done.
[17335956.331738] Freezing user space processes ... (elapsed 0.00 seconds) done.
[17335956.333664] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[17335956.339137] Suspending console(s)
[17335956.339137] drm_sysfs_suspend
[17335956.340852] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[17335956.357841] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[17335956.358837] sd 0:0:0:0: [sda] Stopping disk
[17335959.362335] ACPI handle has no context!
[17335959.362397] ACPI: PCI interrupt for device 0000:05:00.2 disabled
[17335959.362416] ACPI handle has no context!
[17335959.386932] ACPI handle has no context!
[17335959.451193] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[17335959.470777] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[17335959.470777] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[17335959.487114] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[17335959.502933] ACPI: PCI interrupt for device 0000:00:1a.7 disabled
[17335959.522033] ACPI: PCI interrupt for device 0000:00:1a.1 disabled
[17335959.522142] ACPI: PCI interrupt for device 0000:00:1a.0 disabled
[17335959.702106] ACPI: PCI interrupt for device 0000:00:19.0 disabled
[17335959.721138] ACPI: Preparing to enter system sleep state S3
[17335959.736653] Disabling non-boot CPUs ...
[17335959.736679] CPU0 attaching NULL sched-domain.
[17335959.736685] CPU1 attaching NULL sched-domain.
[17335959.854084] CPU 1 is now offline
[17335959.854089] SMP alternatives: switching to UP code
[17335959.871155] CPU0 attaching sched-domain:
[17335959.871161]  domain 0: span 0
[17335959.871165]   groups: 0
[17335959.871587] CPU1 is down
[17335959.871739] Extended CMOS year: 2000
[17335959.871739] Back to C!
[17335959.872111] Extended CMOS year: 2000
[17335959.872282] Enabling non-boot CPUs ...
[17335959.872518] CPU0 attaching NULL sched-domain.
[17335959.882600] SMP alternatives: switching to SMP code
[17335959.900292] Booting processor 1/1 ip 6000
[17335959.910266] Initializing CPU#1
[17335959.910266] Calibrating delay using timer specific routine.. 3192.00 BogoMIPS (lpj=6384012)
[17335959.910266] CPU: L1 I cache: 32K, L1 D cache: 32K
[17335959.910266] CPU: L2 cache: 4096K
[17335959.910266] CPU 1/1 -> Node 0
[17335959.910266] CPU: Physical Processor ID: 0
[17335959.910266] CPU: Processor Core ID: 1
[17335959.991465] CPU1: Intel(R) Core(TM)2 Duo CPU     L7500  @ 1.60GHz stepping 0a
[17335959.991607] CPU0 attaching sched-domain:
[17335959.991613]  domain 0: span 0-1
[17335959.991617]   groups: 0 1
[17335959.991624]   domain 1: span 0-1
[17335959.991628]    groups: 0-1
[17335959.991633]    domain 2: span 0-1
[17335959.991636]     groups: 0-1
[17335959.991643] CPU1 attaching sched-domain:
[17335959.991647]  domain 0: span 0-1
[17335959.991651]   groups: 1 0
[17335959.991656]   domain 1: span 0-1
[17335959.991659]    groups: 0-1
[17335959.991664]    domain 2: span 0-1
[17335959.991668]     groups: 0-1
[17335959.910266] CPU1 is up
[17335960.038272] Switched to high resolution mode on CPU 1
[17335960.166261] ACPI: EC: non-query interrupt received, switching to interrupt mode
[17335960.245305] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 900007, writing 900003)
[17335960.268486] PM: Writing back config space on device 0000:00:02.1 at offset 1 (was 900000, writing 900007)
[17335960.281907] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[17335960.281925] PCI: Setting latency timer of device 0000:00:19.0 to 64
[17335960.579315] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
[17335960.579333] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[17335960.579468] usb usb2: root hub lost power or was reset
[17335960.579524] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[17335960.579545] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[17335960.579793] usb usb3: root hub lost power or was reset
[17335960.596611] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
[17335960.596629] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[17335960.611551] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100106, writing 100102)
[17335960.611625] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
[17335960.611646] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[17335960.611787] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
[17335960.611912] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[17335960.612028] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
[17335960.612324] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[17335960.612348] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
[17335960.612363] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[17335960.612498] usb usb5: root hub lost power or was reset
[17335960.612538] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
[17335960.612553] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[17335960.612684] usb usb6: root hub lost power or was reset
[17335960.628849] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
[17335960.628867] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[17335960.629103] PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100007)
[17335960.629168] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[17335960.629394] ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
[17335960.643937] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00007, writing 2b00407)
[17335960.644079] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[17335961.822559] PM: Writing back config space on device 0000:05:00.1 at offset 4 (was 0, writing d7efe800)
[17335961.822576] PM: Writing back config space on device 0000:05:00.1 at offset 3 (was 800000, writing 804000)
[17335961.822598] PM: Writing back config space on device 0000:05:00.1 at offset 1 (was 2100000, writing 2100006)
[17335961.918925] PM: Writing back config space on device 0000:05:00.2 at offset 4 (was 0, writing d7efe400)
[17335961.918941] PM: Writing back config space on device 0000:05:00.2 at offset 3 (was 800000, writing 804000)
[17335961.918961] PM: Writing back config space on device 0000:05:00.2 at offset 1 (was 2100000, writing 2100006)
[17335961.919016] ACPI: PCI Interrupt 0000:05:00.2[C] -> GSI 18 (level, low) -> IRQ 18
[17335961.977012] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[17335961.979074] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[17335961.979081] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[17335961.979309] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[17335961.979748] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[17335961.983750] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[17335961.983757] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[17335961.983931] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[17335961.984375] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[17335961.985635] ata1.00: configured for UDMA/100
[17335961.988567] ata1.00: configured for UDMA/100
[17335961.988576] ata1: EH complete
[17335961.988697] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[17335961.988738] sd 0:0:0:0: [sda] Write Protect is off
[17335961.988743] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[17335961.988809] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17335961.988876] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[17335961.988911] sd 0:0:0:0: [sda] Write Protect is off
[17335961.988916] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[17335961.988979] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17335962.087440] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: None
[17335962.087446] eth0: 10/100 speed: disabling TSO
[17335963.056862] usb 2-2: reset full speed USB device using uhci_hcd and address 2
[17335963.207500] sd 0:0:0:0: [sda] Starting disk
[17335963.246536] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[17335963.416762] Restarting tasks ... done.
[17336206.246642] CPU0 attaching NULL sched-domain.
[17336206.246661] CPU1 attaching NULL sched-domain.
[17336206.265203] CPU0 attaching sched-domain:
[17336206.265218]  domain 0: span 0-1
[17336206.265223]   groups: 0 1
[17336206.265233]   domain 1: span 0-1
[17336206.265238]    groups: 0-1
[17336206.265246] CPU1 attaching sched-domain:
[17336206.265251]  domain 0: span 0-1
[17336206.265256]   groups: 1 0
[17336206.265264]   domain 1: span 0-1
[17336206.265268]    groups: 0-1
[17337535.664185] ACPI: WMI: Mapper loaded
[17356000.969537] eth0: Link is Down
[17356001.155868] CPU0 attaching NULL sched-domain.
[17356001.155868] CPU1 attaching NULL sched-domain.
[17356001.175684] CPU0 attaching sched-domain:
[17356001.175697]  domain 0: span 0-1
[17356001.175703]   groups: 0 1
[17356001.175713]   domain 1: span 0-1
[17356001.175717]    groups: 0-1
[17356001.175724]    domain 2: span 0-1
[17356001.175729]     groups: 0-1
[17356001.175738] CPU1 attaching sched-domain:
[17356001.175743]  domain 0: span 0-1
[17356001.175750]   groups: 1 0
[17356001.175761]   domain 1: span 0-1
[17356001.175768]    groups: 0-1
[17356001.175778]    domain 2: span 0-1
[17356001.175785]     groups: 0-1
[17356057.851185] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[17356058.304117] Registered led device: iwl-phy3:radio
[17356058.304117] Registered led device: iwl-phy3:assoc
[17356058.304117] Registered led device: iwl-phy3:RX
[17356058.304117] Registered led device: iwl-phy3:TX
[17356058.313482] wlan0: Initial auth_alg=0
[17356058.313482] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[17356058.338634] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[17356058.520189] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[17356058.723532] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[17356058.925802] wlan0: authentication with AP 00:1e:8c:c2:69:11 timed out
[17356106.329843] wlan0: Initial auth_alg=0
[17356106.329857] wlan0: authenticate with AP 00:1c:0e:24:73:21
[17356106.331738] wlan0: RX authentication from 00:1c:0e:24:73:21 (alg=0 transaction=2 status=0)
[17356106.331751] wlan0: authenticated
[17356106.331757] wlan0: associate with AP 00:1c:0e:24:73:21
[17356106.335089] wlan0: RX AssocResp from 00:1c:0e:24:73:21 (capab=0x421 status=0 aid=2)
[17356106.335103] wlan0: associated
[17356106.336577] wlan0: switched to short barker preamble (BSSID=00:1c:0e:24:73:21)
[17356106.337287] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[17356117.386442] wlan0: no IPv6 routers present
[17359077.967090] PM: Syncing filesystems ... done.
[17359078.005660] Freezing user space processes ... (elapsed 0.00 seconds) done.
[17359078.005660] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[17359078.009434] Suspending console(s)
[17359078.009506] drm_sysfs_suspend
[17359078.009906] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[17359078.024364] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[17359078.055024] sd 0:0:0:0: [sda] Stopping disk
[17359081.086350] ACPI handle has no context!
[17359081.086376] ACPI: PCI interrupt for device 0000:05:00.2 disabled
[17359081.086383] ACPI handle has no context!
[17359081.108949] ACPI handle has no context!
[17359083.193440] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[17359083.211127] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[17359083.211127] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[17359083.224881] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[17359083.240819] ACPI: PCI interrupt for device 0000:00:1a.7 disabled
[17359083.259595] ACPI: PCI interrupt for device 0000:00:1a.1 disabled
[17359083.259676] ACPI: PCI interrupt for device 0000:00:1a.0 disabled
[17359083.437471] ACPI: PCI interrupt for device 0000:00:19.0 disabled
[17359083.455684] ACPI: Preparing to enter system sleep state S3
[17359083.469827] Disabling non-boot CPUs ...
[17359083.469842] CPU0 attaching NULL sched-domain.
[17359083.469846] CPU1 attaching NULL sched-domain.
[17359083.585310] CPU 1 is now offline
[17359083.585313] SMP alternatives: switching to UP code
[17359083.594160] CPU0 attaching sched-domain:
[17359083.594163]  domain 0: span 0
[17359083.594165]   groups: 0
[17359083.594409] CPU1 is down
[17359083.594511] Extended CMOS year: 2000
[17359083.594511] Back to C!
[17359083.594890] Extended CMOS year: 2000
[17359083.595064] Enabling non-boot CPUs ...
[17359083.595396] CPU0 attaching NULL sched-domain.
[17359083.605857] SMP alternatives: switching to SMP code
[17359083.613898] Booting processor 1/1 ip 6000
[17359083.621645] Initializing CPU#1
[17359083.621645] Calibrating delay using timer specific routine.. 3192.00 BogoMIPS (lpj=6384004)
[17359083.621645] CPU: L1 I cache: 32K, L1 D cache: 32K
[17359083.621645] CPU: L2 cache: 4096K
[17359083.621645] CPU 1/1 -> Node 0
[17359083.621645] CPU: Physical Processor ID: 0
[17359083.621645] CPU: Processor Core ID: 1
[17359083.701987] CPU1: Intel(R) Core(TM)2 Duo CPU     L7500  @ 1.60GHz stepping 0a
[17359083.702066] CPU0 attaching sched-domain:
[17359083.702069]  domain 0: span 0-1
[17359083.702071]   groups: 0 1
[17359083.702075]   domain 1: span 0-1
[17359083.702077]    groups: 0-1
[17359083.702079]    domain 2: span 0-1
[17359083.702081]     groups: 0-1
[17359083.702085] CPU1 attaching sched-domain:
[17359083.702087]  domain 0: span 0-1
[17359083.702088]   groups: 1 0
[17359083.702091]   domain 1: span 0-1
[17359083.702093]    groups: 0-1
[17359083.702095]    domain 2: span 0-1
[17359083.702097]     groups: 0-1
[17359083.733653] Switched to high resolution mode on CPU 1
[17359083.737639] CPU1 is up
[17359083.859957] ACPI: EC: non-query interrupt received, switching to interrupt mode
[17359083.960012] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 900007, writing 900003)
[17359083.973071] PM: Writing back config space on device 0000:00:02.1 at offset 1 (was 900000, writing 900007)
[17359083.986833] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[17359083.986851] PCI: Setting latency timer of device 0000:00:19.0 to 64
[17359084.282866] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
[17359084.282877] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[17359084.282978] usb usb2: root hub lost power or was reset
[17359084.283015] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[17359084.283021] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[17359084.283342] usb usb3: root hub lost power or was reset
[17359084.299683] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
[17359084.299695] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[17359084.314995] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100106, writing 100102)
[17359084.315052] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
[17359084.315071] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[17359084.315162] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
[17359084.315256] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[17359084.315342] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
[17359084.315430] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[17359084.315445] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
[17359084.315455] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[17359084.315544] usb usb5: root hub lost power or was reset
[17359084.315570] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
[17359084.315580] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[17359084.315679] usb usb6: root hub lost power or was reset
[17359084.331893] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
[17359084.331905] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[17359084.332102] PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100007)
[17359084.332150] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[17359084.332313] ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
[17359084.346988] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00007, writing 2b00407)
[17359084.347104] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[17359085.367042] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[17359085.536099] PM: Writing back config space on device 0000:05:00.1 at offset 4 (was 0, writing d7efe800)
[17359085.536108] PM: Writing back config space on device 0000:05:00.1 at offset 3 (was 800000, writing 804000)
[17359085.536119] PM: Writing back config space on device 0000:05:00.1 at offset 1 (was 2100000, writing 2100006)
[17359085.581303] Registered led device: iwl-phy3:radio
[17359085.581303] Registered led device: iwl-phy3:assoc
[17359085.581303] Registered led device: iwl-phy3:RX
[17359085.581303] Registered led device: iwl-phy3:TX
[17359085.589228] wlan0: Initial auth_alg=0
[17359085.589228] wlan0: authenticate with AP 00:1c:0e:24:73:21
[17359085.636538] PM: Writing back config space on device 0000:05:00.2 at offset 4 (was 0, writing d7efe400)
[17359085.636546] PM: Writing back config space on device 0000:05:00.2 at offset 3 (was 800000, writing 804000)
[17359085.636560] PM: Writing back config space on device 0000:05:00.2 at offset 1 (was 2100000, writing 2100006)
[17359085.636582] ACPI: PCI Interrupt 0000:05:00.2[C] -> GSI 18 (level, low) -> IRQ 18
[17359085.679563] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[17359085.681107] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[17359085.681112] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[17359085.681476] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[17359085.681878] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[17359085.684101] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[17359085.684106] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[17359085.684234] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[17359085.684644] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[17359085.685514] ata1.00: configured for UDMA/100
[17359085.687502] ata1.00: configured for UDMA/100
[17359085.687502] ata1: EH complete
[17359085.687502] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[17359085.687502] sd 0:0:0:0: [sda] Write Protect is off
[17359085.687502] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[17359085.687502] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17359085.687502] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[17359085.687502] sd 0:0:0:0: [sda] Write Protect is off
[17359085.687502] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[17359085.687502] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17359085.789240] wlan0: authenticate with AP 00:1c:0e:24:73:21
[17359085.793013] wlan0: RX authentication from 00:1c:0e:24:73:21 (alg=0 transaction=2 status=0)
[17359085.793017] wlan0: authenticated
[17359085.793021] wlan0: associate with AP 00:1c:0e:24:73:21
[17359086.000550] wlan0: associate with AP 00:1c:0e:24:73:21
[17359086.199650] wlan0: associate with AP 00:1c:0e:24:73:21
[17359086.399667] wlan0: association with AP 00:1c:0e:24:73:21 timed out
[17359086.780029] usb 2-2: reset full speed USB device using uhci_hcd and address 2
[17359086.930435] sd 0:0:0:0: [sda] Starting disk
[17359086.973060] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[17359086.983149] Restarting tasks ... done.
[17359094.508500] CPU0 attaching NULL sched-domain.
[17359094.508517] CPU1 attaching NULL sched-domain.
[17359094.536743] CPU0 attaching sched-domain:
[17359094.536757]  domain 0: span 0-1
[17359094.536762]   groups: 0 1
[17359094.536772]   domain 1: span 0-1
[17359094.536776]    groups: 0-1
[17359094.536785] CPU1 attaching sched-domain:
[17359094.536790]  domain 0: span 0-1
[17359094.536794]   groups: 1 0
[17359094.536802]   domain 1: span 0-1
[17359094.536807]    groups: 0-1
[17359103.347727] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: None
[17359103.347740] eth0: 10/100 speed: disabling TSO
[17360424.616412] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[17360424.822450] Registered led device: iwl-phy3:radio
[17360424.822518] Registered led device: iwl-phy3:assoc
[17360424.822564] Registered led device: iwl-phy3:RX
[17360424.822606] Registered led device: iwl-phy3:TX
[17360424.824903] wlan0: Initial auth_alg=0
[17360424.824903] wlan0: authenticate with AP 00:1c:0e:24:73:21
[17360424.893605] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[17360425.036690] wlan0: authenticate with AP 00:1c:0e:24:73:21
[17360425.239118] wlan0: authenticate with AP 00:1c:0e:24:73:21
[17360425.448865] wlan0: authentication with AP 00:1c:0e:24:73:21 timed out
[17361615.035477] iwl4965: Can not allocate SKB buffers
[17361615.397372] iwl4965: Can not allocate SKB buffers
[17363595.850207] iwl4965: Can not allocate SKB buffers
[17363716.174885] iwl4965: Can not allocate SKB buffers
[17363727.883539] iwl4965: Can not allocate SKB buffers
[17363728.748225] iwl4965: Can not allocate SKB buffers
[17363729.595360] iwl4965: Can not allocate SKB buffers
[17363758.021500] iwl4965: Can not allocate SKB buffers
[17363759.746355] iwl4965: Can not allocate SKB buffers
[17363760.043600] iwl4965: Can not allocate SKB buffers
[17363760.488283] iwl4965: Can not allocate SKB buffers
[17363760.760720] iwl4965: Can not allocate SKB buffers
[17363761.029996] iwl4965: Can not allocate SKB buffers
[17363761.272983] iwl4965: Can not allocate SKB buffers
[17363761.516049] iwl4965: Can not allocate SKB buffers
[17363761.729233] iwl4965: Can not allocate SKB buffers
[17363762.064529] iwl4965: Can not allocate SKB buffers
[17363763.674436] __ratelimit: 1 messages suppressed
[17363763.674450] iwl4965: Can not allocate SKB buffers
[17364069.874772] iwl4965: Can not allocate SKB buffers
[17364070.259716] iwl4965: Can not allocate SKB buffers
[17364070.861026] iwl4965: Can not allocate SKB buffers
[17364071.520232] iwl4965: Can not allocate SKB buffers
[17364071.820385] iwl4965: Can not allocate SKB buffers
[17364194.476174] iwl4965: Can not allocate SKB buffers
[17364815.221946] iwl4965: Can not allocate SKB buffers
[17364823.966168] PM: Syncing filesystems ... done.
[17364826.352119] Freezing user space processes ... (elapsed 0.15 seconds) done.
[17364826.511339] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[17364826.511339] Suspending console(s)
[17364826.511339] drm_sysfs_suspend
[17364826.511339] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[17364826.526803] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[17364826.546354] sd 0:0:0:0: [sda] Stopping disk
[17364829.452050] ACPI handle has no context!
[17364829.452089] ACPI: PCI interrupt for device 0000:05:00.2 disabled
[17364829.452102] ACPI handle has no context!
[17364829.474790] ACPI handle has no context!
[17364831.655371] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[17364831.674542] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[17364831.674650] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[17364831.690609] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[17364831.706364] ACPI: PCI interrupt for device 0000:00:1a.7 disabled
[17364831.725338] ACPI: PCI interrupt for device 0000:00:1a.1 disabled
[17364831.725338] ACPI: PCI interrupt for device 0000:00:1a.0 disabled
[17364831.902898] ACPI: PCI interrupt for device 0000:00:19.0 disabled
[17364831.921746] ACPI: Preparing to enter system sleep state S3
[17364831.937121] Disabling non-boot CPUs ...
[17364831.937144] CPU0 attaching NULL sched-domain.
[17364831.937150] CPU1 attaching NULL sched-domain.
[17364832.050848] CPU 1 is now offline
[17364832.050854] SMP alternatives: switching to UP code
[17364832.068121] CPU0 attaching sched-domain:
[17364832.068127]  domain 0: span 0
[17364832.068130]   groups: 0
[17364832.068531] CPU1 is down
[17364832.068680] Extended CMOS year: 2000
[17364832.068680] Back to C!
[17364832.069055] Extended CMOS year: 2000
[17364832.069223] Enabling non-boot CPUs ...
[17364832.069274] CPU0 attaching NULL sched-domain.
[17364832.079171] SMP alternatives: switching to SMP code
[17364832.096881] Booting processor 1/1 ip 6000
[17364832.106842] Initializing CPU#1
[17364832.106842] Calibrating delay using timer specific routine.. 3191.86 BogoMIPS (lpj=6383723)
[17364832.106842] CPU: L1 I cache: 32K, L1 D cache: 32K
[17364832.106842] CPU: L2 cache: 4096K
[17364832.106842] CPU 1/1 -> Node 0
[17364832.106842] CPU: Physical Processor ID: 0
[17364832.106842] CPU: Processor Core ID: 1
[17364832.188153] CPU1: Intel(R) Core(TM)2 Duo CPU     L7500  @ 1.60GHz stepping 0a
[17364832.188296] CPU0 attaching sched-domain:
[17364832.188302]  domain 0: span 0-1
[17364832.188306]   groups: 0 1
[17364832.188313]   domain 1: span 0-1
[17364832.188316]    groups: 0-1
[17364832.188324] CPU1 attaching sched-domain:
[17364832.188328]  domain 0: span 0-1
[17364832.188331]   groups: 1 0
[17364832.188337]   domain 1: span 0-1
[17364832.188340]    groups: 0-1
[17364832.106842] CPU1 is up
[17364832.234848] Switched to high resolution mode on CPU 1
[17364832.361877] ACPI: EC: non-query interrupt received, switching to interrupt mode
[17364832.447425] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 900007, writing 900003)
[17364832.467271] PM: Writing back config space on device 0000:00:02.1 at offset 1 (was 900000, writing 900007)
[17364832.483315] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[17364832.483332] PCI: Setting latency timer of device 0000:00:19.0 to 64
[17364832.779424] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
[17364832.779441] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[17364832.779574] usb usb2: root hub lost power or was reset
[17364832.779627] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[17364832.779643] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[17364832.779946] usb usb3: root hub lost power or was reset
[17364832.796486] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
[17364832.796504] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[17364832.811180] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100106, writing 100102)
[17364832.811250] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
[17364832.811270] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[17364832.811408] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
[17364832.811533] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[17364832.811648] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
[17364832.811773] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[17364832.811796] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
[17364832.811811] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[17364832.811946] usb usb5: root hub lost power or was reset
[17364832.811982] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
[17364832.811997] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[17364832.812131] usb usb6: root hub lost power or was reset
[17364832.827848] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
[17364832.827864] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[17364832.828098] PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100007)
[17364832.828163] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[17364832.828389] ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
[17364832.842975] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00007, writing 2b00407)
[17364832.843112] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[17364833.862751] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[17364834.031229] PM: Writing back config space on device 0000:05:00.1 at offset 4 (was 0, writing d7efe800)
[17364834.034149] PM: Writing back config space on device 0000:05:00.1 at offset 3 (was 800000, writing 804000)
[17364834.034164] PM: Writing back config space on device 0000:05:00.1 at offset 1 (was 2100000, writing 2100006)
[17364834.080463] Registered led device: iwl-phy3:radio
[17364834.080463] Registered led device: iwl-phy3:assoc
[17364834.080463] Registered led device: iwl-phy3:RX
[17364834.080463] Registered led device: iwl-phy3:TX
[17364834.086218] wlan0: Initial auth_alg=0
[17364834.086218] wlan0: authenticate with AP 00:1c:0e:24:73:21
[17364834.132736] PM: Writing back config space on device 0000:05:00.2 at offset 4 (was 0, writing d7efe400)
[17364834.132749] PM: Writing back config space on device 0000:05:00.2 at offset 3 (was 800000, writing 804000)
[17364834.132762] PM: Writing back config space on device 0000:05:00.2 at offset 1 (was 2100000, writing 2100006)
[17364834.132796] ACPI: PCI Interrupt 0000:05:00.2[C] -> GSI 18 (level, low) -> IRQ 18
[17364834.177937] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[17364834.180529] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[17364834.180536] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[17364834.180641] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[17364834.181075] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[17364834.183714] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[17364834.183722] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[17364834.183825] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[17364834.184485] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[17364834.185878] ata1.00: configured for UDMA/100
[17364834.187986] ata1.00: configured for UDMA/100
[17364834.187995] ata1: EH complete
[17364834.188106] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[17364834.188143] sd 0:0:0:0: [sda] Write Protect is off
[17364834.188149] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[17364834.188207] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17364834.188266] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[17364834.188298] sd 0:0:0:0: [sda] Write Protect is off
[17364834.188303] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[17364834.188360] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17364834.289499] wlan0: authenticate with AP 00:1c:0e:24:73:21
[17364834.497999] wlan0: authenticate with AP 00:1c:0e:24:73:21
[17364834.697928] wlan0: authentication with AP 00:1c:0e:24:73:21 timed out
[17364835.274605] usb 2-2: reset full speed USB device using uhci_hcd and address 2
[17364837.100211] sd 0:0:0:0: [sda] Starting disk
[17364837.128330] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[17364837.311936] Restarting tasks ... done.
[17364840.392133] CPU0 attaching NULL sched-domain.
[17364840.392150] CPU1 attaching NULL sched-domain.
[17364840.407509] CPU0 attaching sched-domain:
[17364840.407522]  domain 0: span 0-1
[17364840.407528]   groups: 0 1
[17364840.407538]   domain 1: span 0-1
[17364840.407543]    groups: 0-1
[17364840.407550]    domain 2: span 0-1
[17364840.407555]     groups: 0-1
[17364840.407563] CPU1 attaching sched-domain:
[17364840.407568]  domain 0: span 0-1
[17364840.407573]   groups: 1 0
[17364840.407580]   domain 1: span 0-1
[17364840.407585]    groups: 0-1
[17364840.407592]    domain 2: span 0-1
[17364840.407597]     groups: 0-1
[17364871.049755] wlan0: Initial auth_alg=0
[17364871.049755] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[17364871.051831] wlan0: RX authentication from 00:1e:8c:c2:69:11 (alg=0 transaction=2 status=0)
[17364871.051840] wlan0: authenticated
[17364871.051847] wlan0: associate with AP 00:1e:8c:c2:69:11
[17364871.054017] wlan0: RX AssocResp from 00:1e:8c:c2:69:11 (capab=0x401 status=0 aid=2)
[17364871.054017] wlan0: associated
[17364871.054017] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[17364871.054017] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[17364871.071789] wlan0: No ProbeResp from current AP 00:1e:8c:c2:69:11 - assume out of range
[17364882.149885] wlan0: no IPv6 routers present
[17365257.784168] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[17365257.994931] Registered led device: iwl-phy3:radio
[17365257.994931] Registered led device: iwl-phy3:assoc
[17365257.994931] Registered led device: iwl-phy3:RX
[17365257.994931] Registered led device: iwl-phy3:TX
[17365259.308588] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[17365265.737068] wlan0: Initial auth_alg=0
[17365265.737082] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[17365265.741339] wlan0: RX authentication from 00:1e:8c:c2:69:11 (alg=0 transaction=2 status=0)
[17365265.741339] wlan0: authenticated
[17365265.741339] wlan0: associate with AP 00:1e:8c:c2:69:11
[17365265.743594] wlan0: RX AssocResp from 00:1e:8c:c2:69:11 (capab=0x401 status=0 aid=2)
[17365265.743603] wlan0: associated
[17365265.743627] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[17365265.744425] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[17365276.749016] wlan0: no IPv6 routers present
[17365693.343305] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[17365817.549922] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[17365867.803962] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[17365961.876092] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[17365984.471710] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[17366139.192811] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[17366140.874092] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[17366242.829109] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[17366244.467034] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[17366369.774961] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[17366386.030548] wlan0: No ProbeResp from current AP 00:1e:8c:c2:69:11 - assume out of range
[17366745.440555] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[17366745.650770] Registered led device: iwl-phy3:radio
[17366745.650770] Registered led device: iwl-phy3:assoc
[17366745.650770] Registered led device: iwl-phy3:RX
[17366745.650770] Registered led device: iwl-phy3:TX
[17366745.673917] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[17366749.283363] wlan0: Initial auth_alg=0
[17366749.283363] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[17366749.286153] wlan0: RX authentication from 00:1e:8c:c2:69:11 (alg=0 transaction=2 status=0)
[17366749.286164] wlan0: authenticated
[17366749.286170] wlan0: associate with AP 00:1e:8c:c2:69:11
[17366749.287914] wlan0: authentication frame received from 00:1e:8c:c2:69:11, but not in authenticate state - ignored
[17366749.290817] wlan0: RX AssocResp from 00:1e:8c:c2:69:11 (capab=0x401 status=0 aid=2)
[17366749.290817] wlan0: associated
[17366749.290817] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[17366749.290817] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[17366760.148828] wlan0: no IPv6 routers present
[17367222.626397] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[17367258.090522] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[17367676.127852] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[17367912.151468] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[17368085.634943] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[17368094.615284] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[17368120.439247] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[17368866.703489] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[17369264.083663] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[17369447.347584] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[17375273.729538] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[17375456.101925] wlan0: No ProbeResp from current AP 00:1e:8c:c2:69:11 - assume out of range
[17376459.174425] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[17376463.281056] ip: page allocation failure. order:4, mode:0xd0
[17376463.281056] Pid: 21736, comm: ip Not tainted 2.6.26-rc3-amd64 #1
[17376463.281056] 
[17376463.281056] Call Trace:
[17376463.281056]  [<ffffffff80276c61>] __alloc_pages_internal+0x3ab/0x3c4
[17376463.281056]  [<ffffffff80295568>] kmem_getpages+0x96/0x15f
[17376463.281056]  [<ffffffff80295b8f>] fallback_alloc+0x142/0x1dd
[17376463.281056]  [<ffffffff802961f4>] kmem_cache_alloc+0xc4/0xf6
[17376463.281056]  [<ffffffffa024b24b>] :iwl4965:iwl4965_tx_queue_init+0x95/0x1cc
[17376463.281056]  [<ffffffffa0251492>] :iwl4965:iwl4965_hw_nic_init+0x79e/0xa88
[17376463.281056]  [<ffffffffa02450be>] :iwl4965:__iwl4965_up+0xd2/0x1e5
[17376463.281056]  [<ffffffffa0245636>] :iwl4965:iwl4965_mac_start+0x465/0x5cb
[17376463.281056]  [<ffffffff803bde27>] rtnl_newlink+0x0/0x3da
[17376463.281056]  [<ffffffffa01c20e2>] :mac80211:ieee80211_open+0x1ef/0x4d9
[17376463.281056]  [<ffffffff803b6384>] dev_open+0x6c/0xa0
[17376463.281056]  [<ffffffff803b4f8f>] dev_change_flags+0xa6/0x15d
[17376463.281056]  [<ffffffff803bccd3>] do_setlink+0x23c/0x317
[17376463.281056]  [<ffffffffa012c196>] :jbd:__journal_file_buffer+0xb5/0x154
[17376463.281056]  [<ffffffff803be09a>] rtnl_newlink+0x273/0x3da
[17376463.281056]  [<ffffffff803bd8ac>] rtnetlink_rcv_msg+0x0/0x1dd
[17376463.281056]  [<ffffffff803cb72d>] netlink_rcv_skb+0x34/0x7c
[17376463.281056]  [<ffffffff803bd8a6>] rtnetlink_rcv+0x18/0x1e
[17376463.281056]  [<ffffffff803cb509>] netlink_unicast+0x1d7/0x25e
[17376463.281056]  [<ffffffff803afeec>] __alloc_skb+0x7f/0x12d
[17376463.281056]  [<ffffffff803cbce5>] netlink_sendmsg+0x274/0x287
[17376463.281056]  [<ffffffff803bd8ac>] rtnetlink_rcv_msg+0x0/0x1dd
[17376463.281056]  [<ffffffff803cb526>] netlink_unicast+0x1f4/0x25e
[17376463.281056]  [<ffffffff803a9ec1>] sock_sendmsg+0xe2/0xff
[17376463.281056]  [<ffffffff802465d1>] autoremove_wake_function+0x0/0x2e
[17376463.281056]  [<ffffffff8027cbc5>] zone_statistics+0x3a/0x8e
[17376463.281056]  [<ffffffff80276566>] get_page_from_freelist+0x446/0x5ea
[17376463.281056]  [<ffffffff803aa0f5>] sys_sendmsg+0x217/0x28a
[17376463.281056]  [<ffffffff8028189b>] handle_mm_fault+0x374/0x867
[17376463.281056]  [<ffffffff80283f1d>] __vma_link+0x42/0x4b
[17376463.281056]  [<ffffffff8022215c>] do_page_fault+0x5d8/0x9c8
[17376463.281056]  [<ffffffff8020be8a>] system_call_after_swapgs+0x8a/0x8f
[17376463.281056] 
[17376463.281056] Mem-info:
[17376463.281056] Node 0 DMA per-cpu:
[17376463.281056] CPU    0: hi:    0, btch:   1 usd:   0
[17376463.281056] CPU    1: hi:    0, btch:   1 usd:   0
[17376463.281056] Node 0 DMA32 per-cpu:
[17376463.281056] CPU    0: hi:  186, btch:  31 usd:  24
[17376463.281056] CPU    1: hi:  186, btch:  31 usd:   0
[17376463.281056] Active:160310 inactive:51971 dirty:3 writeback:13501 unstable:0
[17376463.281056]  free:2720 slab:10552 mapped:10136 pagetables:3990 bounce:0
[17376463.281056] Node 0 DMA free:3924kB min:40kB low:48kB high:60kB active:4716kB inactive:1244kB present:10868kB pages_scanned:0 all_unreclaimable? no
[17376463.281056] lowmem_reserve[]: 0 969 969 969
[17376463.281056] Node 0 DMA32 free:6956kB min:3960kB low:4948kB high:5940kB active:636524kB inactive:206640kB present:992516kB pages_scanned:0 all_unreclaimable? no
[17376463.281056] lowmem_reserve[]: 0 0 0 0
[17376463.281056] Node 0 DMA: 33*4kB 22*8kB 48*16kB 23*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 3924kB
[17376463.281056] Node 0 DMA32: 1609*4kB 10*8kB 1*16kB 1*32kB 0*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 6948kB
[17376463.281056] 58942 total pagecache pages
[17376463.281056] Swap cache: add 1402944, delete 1365704, find 743172/906413
[17376463.281056] Free swap  = 917512kB
[17376463.281056] Total swap = 1466632kB
[17376463.294832] 255664 pages of RAM
[17376463.294838] 4768 reserved pages
[17376463.294841] 61968 pages shared
[17376463.294845] 37240 pages swap cached
[17376463.294852] iwl4965: kmalloc for auxiliary BD structures failed
[17376463.294862] iwl4965: Tx 15 queue init failed
[17376463.294915] iwl4965: Unable to init nic
[17376495.503590] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[17376496.214221] iwl4965: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
[17376497.654217] iwl4965: Wait for START_ALIVE timeout after 2000ms.
[17376497.654541] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[17376499.803265] iwl4965: Wait for START_ALIVE timeout after 2000ms.
[17376546.790029] iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.26ks
[17376546.790029] iwl4965: Copyright(c) 2003-2008 Intel Corporation
[17376546.790029] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[17376546.790029] PCI: Setting latency timer of device 0000:03:00.0 to 64
[17376546.790029] iwl4965: Detected Intel Wireless WiFi Link 4965AGN
[17376546.823278] iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
[17376546.826354] phy4: Selected rate control algorithm 'iwl-4965-rs'
[17376546.826993] input: 4965AGN as /class/input/input15
[17376558.504953] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[17376558.504953] firmware: requesting iwlwifi-4965-1.ucode
[17376558.572804] iwl4965: Can not allocate SKB buffers
[17376558.572804] ip: page allocation failure. order:5, mode:0x1024
[17376558.572804] Pid: 21828, comm: ip Not tainted 2.6.26-rc3-amd64 #1
[17376558.572804] 
[17376558.572804] Call Trace:
[17376558.572804]  [<ffffffff80276c61>] __alloc_pages_internal+0x3ab/0x3c4
[17376558.572804]  [<ffffffff802112fb>] dma_alloc_coherent+0x97/0x218
[17376558.572804]  [<ffffffffa024b216>] :iwl4965:iwl4965_tx_queue_init+0x60/0x1cc
[17376558.572804]  [<ffffffffa0251492>] :iwl4965:iwl4965_hw_nic_init+0x79e/0xa88
[17376558.572804]  [<ffffffffa02450be>] :iwl4965:__iwl4965_up+0xd2/0x1e5
[17376558.572804]  [<ffffffffa0245636>] :iwl4965:iwl4965_mac_start+0x465/0x5cb
[17376558.572804]  [<ffffffffa01c20e2>] :mac80211:ieee80211_open+0x1ef/0x4d9
[17376558.572804]  [<ffffffff803b6384>] dev_open+0x6c/0xa0
[17376558.572804]  [<ffffffff803b4f8f>] dev_change_flags+0xa6/0x15d
[17376558.572804]  [<ffffffff803bccd3>] do_setlink+0x23c/0x317
[17376558.572804]  [<ffffffff8031610a>] cfq_set_request+0x26e/0x2e0
[17376558.572804]  [<ffffffff803be09a>] rtnl_newlink+0x273/0x3da
[17376558.572804]  [<ffffffff802f1fb5>] dummy_socket_recvmsg+0x0/0x3
[17376558.572804]  [<ffffffff803bd8ac>] rtnetlink_rcv_msg+0x0/0x1dd
[17376558.572804]  [<ffffffff803cb72d>] netlink_rcv_skb+0x34/0x7c
[17376558.572804]  [<ffffffff803bd8a6>] rtnetlink_rcv+0x18/0x1e
[17376558.572804]  [<ffffffff803cb509>] netlink_unicast+0x1d7/0x25e
[17376558.572804]  [<ffffffff803afeec>] __alloc_skb+0x7f/0x12d
[17376558.572804]  [<ffffffff803cbce5>] netlink_sendmsg+0x274/0x287
[17376558.572804]  [<ffffffff803bd8ac>] rtnetlink_rcv_msg+0x0/0x1dd
[17376558.572804]  [<ffffffff803cb526>] netlink_unicast+0x1f4/0x25e
[17376558.572804]  [<ffffffff803a9ec1>] sock_sendmsg+0xe2/0xff
[17376558.572804]  [<ffffffff802465d1>] autoremove_wake_function+0x0/0x2e
[17376558.572804]  [<ffffffff8027cbc5>] zone_statistics+0x3a/0x8e
[17376558.572804]  [<ffffffff80276566>] get_page_from_freelist+0x446/0x5ea
[17376558.572804]  [<ffffffff803aa0f5>] sys_sendmsg+0x217/0x28a
[17376558.572804]  [<ffffffff8028189b>] handle_mm_fault+0x374/0x867
[17376558.572804]  [<ffffffff80283f1d>] __vma_link+0x42/0x4b
[17376558.572844]  [<ffffffff8022215c>] do_page_fault+0x5d8/0x9c8
[17376558.572890]  [<ffffffff8020be8a>] system_call_after_swapgs+0x8a/0x8f
[17376558.576668] 
[17376558.576671] Mem-info:
[17376558.576675] Node 0 DMA per-cpu:
[17376558.576682] CPU    0: hi:    0, btch:   1 usd:   0
[17376558.576687] CPU    1: hi:    0, btch:   1 usd:   0
[17376558.576692] Node 0 DMA32 per-cpu:
[17376558.576699] CPU    0: hi:  186, btch:  31 usd: 161
[17376558.576704] CPU    1: hi:  186, btch:  31 usd:  49
[17376558.576713] Active:164623 inactive:55515 dirty:85 writeback:0 unstable:0
[17376558.576717]  free:1540 slab:8112 mapped:10349 pagetables:4014 bounce:0
[17376558.576722] Node 0 DMA free:3892kB min:40kB low:48kB high:60kB active:5328kB inactive:1660kB present:10868kB pages_scanned:0 all_unreclaimable? no
[17376558.576734] lowmem_reserve[]: 0 969 969 969
[17376558.576743] Node 0 DMA32 free:2268kB min:3960kB low:4948kB high:5940kB active:653164kB inactive:220400kB present:992516kB pages_scanned:0 all_unreclaimable? no
[17376558.576756] lowmem_reserve[]: 0 0 0 0
[17376558.576764] Node 0 DMA: 45*4kB 32*8kB 28*16kB 22*32kB 4*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 3892kB
[17376558.576788] Node 0 DMA32: 365*4kB 53*8kB 0*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2268kB
[17376558.576811] 66246 total pagecache pages
[17376558.576817] Swap cache: add 1407258, delete 1367765, find 757113/920849
[17376558.576823] Free swap  = 908048kB
[17376558.576828] Total swap = 1466632kB
[17376558.588552] 255664 pages of RAM
[17376558.588552] 4768 reserved pages
[17376558.588552] 62037 pages shared
[17376558.588552] 39415 pages swap cached
[17376558.588552] iwl4965: Tx 0 queue init failed
[17376558.588552] iwl4965: Unable to init nic
[17376558.588552] iwl4965: Can not allocate SKB buffers
[17376558.588552] iwl4965: Can not allocate SKB buffers
[17376558.588552] iwl4965: Can not allocate SKB buffers
[17376558.588552] iwl4965: Can not allocate SKB buffers
[17376558.588552] iwl4965: Can not allocate SKB buffers
[17376558.588552] iwl4965: Can not allocate SKB buffers
[17376558.588552] iwl4965: Can not allocate SKB buffers
[17376558.588552] iwl4965: Can not allocate SKB buffers

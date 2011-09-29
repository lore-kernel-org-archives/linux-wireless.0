Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47414 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab1I2ISD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 04:18:03 -0400
Received: by wyg34 with SMTP id 34so4514wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2011 01:18:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110927214245.GA1416@ecki>
References: <CAD2nsn2Bbxxy9ZYpBe_QEqCkGYYROHE+j7qASRq3OkKmWD5PMg@mail.gmail.com>
	<CAD2nsn1+5QWtzeG-3RHEJi8+oDthAfXYunHnDTLie84oJPOQuw@mail.gmail.com>
	<CAD2nsn1roVNB5+H1CYHVnerLN3pjGB5KmEX1mJZ4yJhHqFGOVA@mail.gmail.com>
	<20110830064137.GA4719@ecki>
	<CAD2nsn2Reu+T=g6HwdQT5cdkD0C-06y7GJ_B2q-UzpRnshxAWw@mail.gmail.com>
	<14be9f3b-4c91-481d-9e52-f3119659fd59@email.android.com>
	<CAD2nsn1+WVaLR_TR37Z6YRCFnQH1hJkSOri=nxc8Ff3pa9N8dw@mail.gmail.com>
	<20110927214245.GA1416@ecki>
Date: Thu, 29 Sep 2011 13:48:02 +0530
Message-ID: <CAD2nsn3ZwUJsFRLyjKenO6Pm3+jr9gfmAMRDQPStEcC1hN_mkw@mail.gmail.com> (sfid-20110929_101816_615406_3404D483)
Subject: Re: ath9k: irq storm after suspend/resume
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Clemens Buchacher <drizzd@aon.at>
Cc: linux-wireless@vger.kernel.org, beta992@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 28, 2011 at 3:12 AM, Clemens Buchacher <drizzd@aon.at> wrote:
> Hello Mohammed,
>
> On Mon, Sep 26, 2011 at 02:54:18PM +0530, Mohammed Shafi wrote:
>>
>> is the issue still seen? any improvement with the attached patch..
>
> I still have the issue. No change with current wl-testing plus your
> patch.

Clemens thanks for taking time  and test it, I wll see if i can find
something else.

>
> Below dmesg output of:
>
>  modprobe ath9k debug=0x0000fffb
>  echo mem >/sys/power/state
>  # resume
>
> Clemens
>
> ---
> [   27.575562] ath9k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   27.577970] ath9k 0000:02:00.0: setting latency timer to 64
> [   27.581405] ath: UNDEFINED -> AWAKE
> [   27.581469] ath: serialize_regmode is 0
> [   27.626195] ath: Eeprom VER: 14, REV: 13
> [   27.626199] ath: Initialize ANI
> [   27.626203] ath: Enable MIB counters
> [   27.626240] ath: Setup TX queue: 9
> [   27.626243] ath: Set queue properties for: 9
> [   27.626248] ath: Setup TX queue: 8
> [   27.626251] ath: Set queue properties for: 8
> [   27.626255] ath: Set queue properties for: 8
> [   27.626259] ath: Reset TX queue: 8
> [   27.626286] ath: tx ok 0x0 err 0x0 desc 0x100 eol 0x100 urn 0x0
> [   27.626290] ath: Setup TX queue: 0
> [   27.626293] ath: Set queue properties for: 0
> [   27.626297] ath: Setup TX queue: 1
> [   27.626300] ath: Set queue properties for: 1
> [   27.626304] ath: Setup TX queue: 2
> [   27.626307] ath: Set queue properties for: 2
> [   27.626310] ath: Setup TX queue: 3
> [   27.626313] ath: Set queue properties for: 3
> [   27.627816] ath: TX streams 1, RX streams: 1
> [   27.627819] ath: EEPROM regdomain: 0x60
> [   27.627822] ath: EEPROM indicates we should expect a direct regpair map
> [   27.627828] ath: Country alpha2 being used: 00
> [   27.627830] ath: Regpair used: 0x60
> [   27.627838] ath: tx DMA: 512 buffers 1 desc/buf
> [   27.627857] ath: tx DMA map: ffff88006f250000 (54600) -> 6f250000 (54600)
> [   27.627891] ath: beacon DMA: 4 buffers 1 desc/buf
> [   27.627897] ath: beacon DMA map: ffff88007198d000 (416) -> 7198d000 (416)
> [   27.627902] ath: cachelsz 64 rxbufsize 1926
> [   27.627906] ath: rx DMA: 512 buffers 1 desc/buf
> [   27.627924] ath: rx DMA map: ffff88006f2b0000 (54600) -> 6f2b0000 (54600)
> [   27.629650] ieee80211 phy1: Selected rate control algorithm 'ath9k_rate_control'
> [   27.630460] Registered led device: ath9k-phy1
> [   27.630475] ieee80211 phy1: Atheros AR9285 Rev:2 mem=0xffffc90021ba0000, irq=17
> [   43.855411] PM: Syncing filesystems ... done.
> [   43.948410] PM: Preparing system for mem sleep
> [   43.949937] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [   43.963254] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [   43.976527] PM: Entering mem sleep
> [   43.976595] Suspending console(s) (use no_console_suspend to debug)
> [   43.977193] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [   43.989161] jmb38x_ms 0000:06:00.3: PCI INT B disabled
> [   43.989194] sdhci-pci 0000:06:00.0: PCI INT B disabled
> [   43.989232] ath: AWAKE -> FULL-SLEEP
> [   43.998370] sd 0:0:0:0: [sda] Stopping disk
> [   44.196369] snd_hda_intel 0000:00:1b.0: PCI INT A disabled
> [   44.608701] PM: suspend of devices complete after 633.019 msecs
> [   44.609142] jme 0000:06:00.5: PME# enabled
> [   44.609152] jme 0000:06:00.5: wake-up capability enabled by ACPI
> [   44.648588] PM: late suspend of devices complete after 39.960 msecs
> [   44.648748] ACPI: Preparing to enter system sleep state S3
> [   44.951903] PM: Saving platform NVS memory
> [   44.952780] Disabling non-boot CPUs ...
> [   44.955081] CPU 1 is now offline
> [   45.057696] CPU 2 is now offline
> [   45.160822] CPU 3 is now offline
> [   45.161227] Extended CMOS year: 2000
> [   45.161461] ACPI: Low-level resume complete
> [   45.161521] PM: Restoring platform NVS memory
> [   45.161951] Extended CMOS year: 2000
> [   45.161974] Enabling non-boot CPUs ...
> [   45.162070] Booting Node 0 Processor 1 APIC 0x4
> [   45.162071] smpboot cpu 1: start_ip = 96000
> [   45.173166] Calibrating delay loop (skipped) already calibrated this CPU
> [   45.193433] NMI watchdog enabled, takes one hw-pmu counter.
> [   45.193554] CPU1 is up
> [   45.193622] Booting Node 0 Processor 2 APIC 0x1
> [   45.193623] smpboot cpu 2: start_ip = 96000
> [   45.194742] Switched to NOHz mode on CPU #1
> [   45.204719] Calibrating delay loop (skipped) already calibrated this CPU
> [   45.225042] NMI watchdog enabled, takes one hw-pmu counter.
> [   45.225176] CPU2 is up
> [   45.225257] Booting Node 0 Processor 3 APIC 0x5
> [   45.225259] smpboot cpu 3: start_ip = 96000
> [   45.228010] Switched to NOHz mode on CPU #2
> [   45.236352] Calibrating delay loop (skipped) already calibrated this CPU
> [   45.256763] NMI watchdog enabled, takes one hw-pmu counter.
> [   45.256925] CPU3 is up
> [   45.258831] Switched to NOHz mode on CPU #3
> [   45.259072] ACPI: Waking up from system sleep state S3
> [   45.580717] intel ips 0000:00:1f.6: MCP limit exceeded: Avg temp 20253, limit 9000
> [   45.658244] i915 0000:00:02.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
> [   45.658253] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
> [   45.658277] mei 0000:00:16.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
> [   45.658296] mei 0000:00:16.0: restoring config space at offset 0x4 (was 0x4, writing 0xd540a004)
> [   45.658304] mei 0000:00:16.0: restoring config space at offset 0x1 (was 0x180000, writing 0x180006)
> [   45.658332] pci 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
> [   45.658350] pci 0000:00:1a.0: restoring config space at offset 0x4 (was 0x0, writing 0xd5408000)
> [   45.658358] pci 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900006)
> [   45.658391] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
> [   45.658410] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0xd5400004)
> [   45.658415] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
> [   45.658421] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100002)
> [   45.658455] pcieport 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x10010b)
> [   45.658467] pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x7c717c61)
> [   45.658479] pcieport 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
> [   45.658485] pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
> [   45.658538] pcieport 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x100203)
> [   45.658550] pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x7c517c41)
> [   45.658561] pcieport 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
> [   45.658568] pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
> [   45.658620] pcieport 0000:00:1c.2: restoring config space at offset 0xf (was 0x300, writing 0x100304)
> [   45.658632] pcieport 0000:00:1c.2: restoring config space at offset 0x9 (was 0x1fff1, writing 0x7c317c21)
> [   45.658643] pcieport 0000:00:1c.2: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
> [   45.658650] pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
> [   45.658703] pcieport 0000:00:1c.5: restoring config space at offset 0xf (was 0x200, writing 0x100203)
> [   45.658714] pcieport 0000:00:1c.5: restoring config space at offset 0x9 (was 0x1fff1, writing 0x7c117c01)
> [   45.658726] pcieport 0000:00:1c.5: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
> [   45.658732] pcieport 0000:00:1c.5: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
> [   45.658780] pci 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
> [   45.658799] pci 0000:00:1d.0: restoring config space at offset 0x4 (was 0x0, writing 0xd5407000)
> [   45.658807] pci 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900006)
> [   45.658831] pci 0000:00:1e.0: restoring config space at offset 0xf (was 0x0, writing 0x100000)
> [   45.658930] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
> [   45.659017] intel ips 0000:00:1f.6: restoring config space at offset 0x1 (was 0x100400, writing 0x100406)
> [   45.659057] ath9k 0000:02:00.0: restoring config space at offset 0xf (was 0x1ff, writing 0x103)
> [   45.659077] ath9k 0000:02:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xd2c00004)
> [   45.659082] ath9k 0000:02:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
> [   45.659088] ath9k 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
> [   45.659129] sdhci-pci 0000:06:00.0: restoring config space at offset 0xf (was 0x2ff, writing 0x204)
> [   45.659157] sdhci-pci 0000:06:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xd0407000)
> [   45.659163] sdhci-pci 0000:06:00.0: restoring config space at offset 0x3 (was 0x800000, writing 0x800010)
> [   45.659172] sdhci-pci 0000:06:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
> [   45.659218] pci 0000:06:00.2: restoring config space at offset 0xf (was 0x2ff, writing 0x204)
> [   45.659246] pci 0000:06:00.2: restoring config space at offset 0x4 (was 0x0, writing 0xd0406000)
> [   45.659253] pci 0000:06:00.2: restoring config space at offset 0x3 (was 0x800000, writing 0x800010)
> [   45.659262] pci 0000:06:00.2: restoring config space at offset 0x1 (was 0x100000, writing 0x100003)
> [   45.659308] jmb38x_ms 0000:06:00.3: restoring config space at offset 0xf (was 0x2ff, writing 0x204)
> [   45.659336] jmb38x_ms 0000:06:00.3: restoring config space at offset 0x4 (was 0x0, writing 0xd0405000)
> [   45.659342] jmb38x_ms 0000:06:00.3: restoring config space at offset 0x3 (was 0x800000, writing 0x800010)
> [   45.659351] jmb38x_ms 0000:06:00.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
> [   45.659397] pci 0000:06:00.4: restoring config space at offset 0xf (was 0x2ff, writing 0x204)
> [   45.659425] pci 0000:06:00.4: restoring config space at offset 0x4 (was 0x0, writing 0xd0404000)
> [   45.659431] pci 0000:06:00.4: restoring config space at offset 0x3 (was 0x800000, writing 0x800010)
> [   45.659441] pci 0000:06:00.4: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
> [   45.659487] jme 0000:06:00.5: restoring config space at offset 0xf (was 0x100, writing 0x103)
> [   45.659508] jme 0000:06:00.5: restoring config space at offset 0x7 (was 0x1, writing 0xa001)
> [   45.659520] jme 0000:06:00.5: restoring config space at offset 0x4 (was 0x0, writing 0xd0400000)
> [   45.659526] jme 0000:06:00.5: restoring config space at offset 0x3 (was 0x800000, writing 0x800010)
> [   45.659535] jme 0000:06:00.5: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
> [   45.659759] PM: early resume of devices complete after 1.603 msecs
> [   45.659979] i915 0000:00:02.0: setting latency timer to 64
> [   45.659996] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> [   45.660003] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
> [   45.660050] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
> [   45.660126] pci 0000:00:1e.0: setting latency timer to 64
> [   45.660144] ahci 0000:00:1f.2: setting latency timer to 64
> [   45.660211] ath: FULL-SLEEP -> AWAKE
> [   45.663932] sdhci-pci 0000:06:00.0: PCI INT B -> GSI 18 (level, low) -> IRQ 18
> [   45.663974] sdhci-pci 0000:06:00.0: setting latency timer to 64
> [   45.664037] jmb38x_ms 0000:06:00.3: PCI INT B -> GSI 18 (level, low) -> IRQ 18
> [   45.664051] jmb38x_ms 0000:06:00.3: setting latency timer to 64
> [   45.664113] jme 0000:06:00.5: wake-up capability disabled by ACPI
> [   45.664124] jme 0000:06:00.5: PME# disabled
> [   45.664503] ath: disable IER
> [   45.664521] ath: Disable MIB counters
> [   45.664560] ath: disable IER
> [   45.664575] ath: 0x30 => 0x30
> [   45.664576] ath: new IMR 0x30
> [   45.664672] sd 0:0:0:0: [sda] Starting disk
> [   45.667161] ath: Getting spur idx:0 is2Ghz:1 val:8000
> [   45.668810] ath: Reset TX queue: 0
> [   45.668813] ath: tx ok 0x0 err 0x0 desc 0x101 eol 0x101 urn 0x0
> [   45.668815] ath: Reset TX queue: 1
> [   45.668817] ath: tx ok 0x0 err 0x0 desc 0x103 eol 0x103 urn 0x0
> [   45.668819] ath: Reset TX queue: 2
> [   45.668821] ath: tx ok 0x0 err 0x0 desc 0x107 eol 0x107 urn 0x0
> [   45.668823] ath: Reset TX queue: 3
> [   45.668825] ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> [   45.668827] ath: Reset TXQ, inactive queue: 4
> [   45.668828] ath: Reset TXQ, inactive queue: 5
> [   45.668830] ath: Reset TXQ, inactive queue: 6
> [   45.668831] ath: Reset TXQ, inactive queue: 7
> [   45.668832] ath: Reset TX queue: 8
> [   45.668842] ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> [   45.668844] ath: Reset TX queue: 9
> [   45.668854] ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
> [   45.668861] ath: ah->misc_mode 0x4
> [   45.670264] ath: Running PA Calibration
> [   45.670963] ath: enabling ADC Gain Calibration.
> [   45.670964] ath: enabling ADC DC Calibration.
> [   45.670965] ath: enabling IQ Calibration.
> [   45.670969] ath: starting ADC Gain Calibration
> [   45.671139] ath: AWAKE -> FULL-SLEEP
> [   45.679552] Extended CMOS year: 2000
> [   45.983193] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [   45.985133] ata2.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
> [   45.985136] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [   45.988885] ata2.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
> [   45.988889] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [   45.989852] ata6: SATA link down (SStatus 0 SControl 300)
> [   45.990375] ata2.00: configured for UDMA/100
> [   46.120272] irq 17: nobody cared (try booting with the "irqpoll" option)
> [   46.120275] Pid: 0, comm: swapper Tainted: G         C  3.1.0-rc7-wl-ARCH3.1.0-rc7-ath9k-debug #2
> [   46.120277] Call Trace:
> [   46.120280]  <IRQ>  [<ffffffff810c68bd>] __report_bad_irq+0x3d/0xe0
> [   46.120290]  [<ffffffff810c6cfd>] note_interrupt+0x14d/0x210
> [   46.120293]  [<ffffffff810c4c39>] handle_irq_event_percpu+0xc9/0x2a0
> [   46.120296]  [<ffffffff810c4e58>] handle_irq_event+0x48/0x70
> [   46.120299]  [<ffffffff810c763a>] handle_fasteoi_irq+0x5a/0xe0
> [   46.120303]  [<ffffffff81016982>] handle_irq+0x22/0x40
> [   46.120308]  [<ffffffff813ec09a>] do_IRQ+0x5a/0xe0
> [   46.120312]  [<ffffffff813e8cee>] common_interrupt+0x6e/0x6e
> [   46.120313]  <EOI>  [<ffffffff8131234a>] ? poll_idle+0x3a/0x80
> [   46.120319]  [<ffffffff81312323>] ? poll_idle+0x13/0x80
> [   46.120321]  [<ffffffff813126f6>] cpuidle_idle_call+0xc6/0x350
> [   46.120324]  [<ffffffff81013229>] cpu_idle+0xc9/0x120
> [   46.120328]  [<ffffffff813c64e7>] rest_init+0x9b/0xa4
> [   46.120330]  [<ffffffff8174dc15>] start_kernel+0x3bf/0x3cc
> [   46.120333]  [<ffffffff8174d347>] x86_64_start_reservations+0x132/0x136
> [   46.120336]  [<ffffffff8174d140>] ? early_idt_handlers+0x140/0x140
> [   46.120338]  [<ffffffff8174d44d>] x86_64_start_kernel+0x102/0x111
> [   46.120340] handlers:
> [   46.120344] [<ffffffffa053c020>] ath_isr
> [   46.120345] Disabling IRQ #17
> [   48.371839] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   48.479286] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [   48.479457] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
> [   48.479463] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [   48.516626] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [   48.516804] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
> [   48.516809] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [   48.518731] ata1.00: configured for UDMA/133
> [   48.526624] ath: FULL-SLEEP -> AWAKE
> [   48.530116] ath: ah->misc_mode 0x4
> [   48.530142] ath: AWAKE -> FULL-SLEEP
> [   48.530172] PM: resume of devices complete after 2875.994 msecs
> [   48.530607] PM: Finishing wakeup.
> [   48.530608] Restarting tasks ... done.
> [   48.533504] video LNXVIDEO:02: Restoring backlight state
>



-- 
shafi

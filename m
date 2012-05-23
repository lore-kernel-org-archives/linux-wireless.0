Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58787 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933367Ab2EWNzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 09:55:09 -0400
Date: Wed, 23 May 2012 08:55:06 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: BCM4331 tx failures after S3
Message-ID: <20120523135506.GB30165@thinkpad-t410> (sfid-20120523_155524_671860_C966C0E1)
References: <20120522165251.GA31347@thinkpad-t410>
 <4FBCAE3E.6050206@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
In-Reply-To: <4FBCAE3E.6050206@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2012 at 11:30:38AM +0200, Arend van Spriel wrote:
> On 05/22/2012 06:52 PM, Seth Forshee wrote:
> > Hi Arend,
> > 
> > I've inquired about this issue on the list once before, but I thought
> > I'd try once again to see if Broadcom can offer any suggestions.
> > 
> > Recent MacBook Pros with BCM4331 wireless have a strange problem. Tx
> > doesn't work after S3, but only if no external power is applied during
> > the resume. mac80211 reports mostly timeouts for responses to probe
> > requests, but analysis with wireshark shows no frames from the BCM4331
> > on the air. The only way I've found to recover is to reload both b43 and
> > bcma; reloading b43 alone is not enough.
> 
> Yikes. I recently did suspend/resume and hibernate testing with BCM43224
> (so brcmsmac and bcma), but my system was on AC. I will execute them
> again on battery. I want to make sure it is not a BCM4331 specific issue.

I'm also testing a Macbook Air with BCM43224 using brcmsmac, and it does
not suffer from the same issue.

> > I've checked the values of MACCTL and the DMA TXCTL registers, since
> > these are the ones used by brcmsmac to mute tx, but those look okay. Any
> > suggestions of other things to check? My next step would be to start
> > looking at the state of the phy and radio, but since we don't have much
> > information about what the registers there actually do some suggestions
> > would be helpful.
> 
> When going to S3 the driver is told by mac80211 .stop callback to abort
> driver operation so I do not expect b43 has a problem. Instead we
> probably have to look at the host PCI code in bcma, but before going
> there let me execute my tests.
> 
> Can you tell me on what kernel version you see this issue. I would also
> like to have a look at your kernel log.

I'm still seeing it in both 3.4 and wireless-testing. Attached is dmesg
from wireless-testing.

Thanks,
Seth


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.4.0-030400v201205231424-generic (sforshee@tangerine) (gcc version 4.7.0 (Ubuntu/Linaro 4.7.0-7ubuntu3) ) #030400v201205231424 SMP Wed May 23 13:28:41 UTC 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.4.0-030400v201205231424-generic root=UUID=3b5f80a7-de95-4588-af4f-eedc09cfb366 ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008e000 (usable)
[    0.000000]  BIOS-e820: 000000000008e000 - 0000000000090000 (reserved)
[    0.000000]  BIOS-e820: 0000000000090000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000c0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 0000000020000000 - 0000000020200000 (reserved)
[    0.000000]  BIOS-e820: 0000000020200000 - 0000000040000000 (usable)
[    0.000000]  BIOS-e820: 0000000040000000 - 0000000040200000 (reserved)
[    0.000000]  BIOS-e820: 0000000040200000 - 000000008ad34000 (usable)
[    0.000000]  BIOS-e820: 000000008ad34000 - 000000008ad5f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000008ad5f000 - 000000008afa3000 (ACPI data)
[    0.000000]  BIOS-e820: 000000008afa3000 - 000000008afff000 (reserved)
[    0.000000]  BIOS-e820: 000000008afff000 - 000000008b000000 (ACPI data)
[    0.000000]  BIOS-e820: 000000008b000000 - 000000008ba00000 (reserved)
[    0.000000]  BIOS-e820: 000000008ba00000 - 000000008fa00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed04000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000016fe00000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Apple Inc. MacBookPro8,2/Mac-94245A3940C91C80, BIOS    MBP81.88Z.0047.B27.1201241646 01/24/12
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x16fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 0A0000000 mask FE0000000 uncachable
[    0.000000]   2 base 090000000 mask FF0000000 uncachable
[    0.000000]   3 base 08C000000 mask FFC000000 uncachable
[    0.000000]   4 base 08B800000 mask FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0x8ad34 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000008ad34000
[    0.000000]  0000000000 - 008ac00000 page 2M
[    0.000000]  008ac00000 - 008ad34000 page 4k
[    0.000000] kernel direct mapping tables up to 8ad34000 @ 1fffb000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000016fe00000
[    0.000000]  0100000000 - 016fe00000 page 2M
[    0.000000] kernel direct mapping tables up to 16fe00000 @ 8ad2d000-8ad34000
[    0.000000] RAMDISK: 365be000 - 372d7000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 000000008ad8e1c0 000A4 (v01 APPLE   Apple00 00000047      01000013)
[    0.000000] ACPI: FACP 000000008ad8c000 000F4 (v04 APPLE   Apple00 00000047 Loki 0000005F)
[    0.000000] ACPI: DSDT 000000008ad80000 06F12 (v01 APPLE  MacBookP 00080001 INTL 20061109)
[    0.000000] ACPI: FACS 000000008ad3e000 00040
[    0.000000] ACPI: HPET 000000008ad8b000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 000000008ad8a000 000BC (v02 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 000000008ad88000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 000000008ad87000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000008ad7b000 00024 (v01 APPLE   SmcDppt 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000008ad79000 0061A (v01 APPLE  UsbNoRmh 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000008ad75000 000A0 (v02 APPLE   IGNoHda 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000008ad73000 0062F (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000008ad72000 009B1 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000008ad71000 00315 (v01  PmRef  Cpu0Tst 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000008ad70000 0037A (v01  PmRef    ApTst 00003000 INTL 20061109)
[    0.000000] ACPI: MCFG 000000008ad89000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000008ad7f000 00124 (v01 SataRe  SataPri 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000008ad7e000 000FA (v01 SataRe  SataSec 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000008ad7d000 00032 (v01  Apple   SsdtS3 00001000 INTL 20061109)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000016fe00000
[    0.000000] Initmem setup node 0 0000000000000000-000000016fe00000
[    0.000000]   NODE_DATA [000000016fdfc000 - 000000016fdfffff]
[    0.000000]  [ffffea0000000000-ffffea0005bfffff] PMD -> [ffff88016b400000-ffff88016f3fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0016fe00
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000008e
[    0.000000]     0: 0x00000090 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000]     0: 0x00020200 -> 0x00040000
[    0.000000]     0: 0x00040200 -> 0x0008ad34
[    0.000000]     0: 0x00100000 -> 0x0016fe00
[    0.000000] On node 0 totalpages: 1025729
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 547188 pages, LIFO batch:31
[    0.000000]   Normal zone: 7160 pages used for memmap
[    0.000000]   Normal zone: 451080 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000008e000 - 0000000000090000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000c0000
[    0.000000] PM: Registered nosave memory: 00000000000c0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 000000008ad34000 - 000000008ad5f000
[    0.000000] PM: Registered nosave memory: 000000008ad5f000 - 000000008afa3000
[    0.000000] PM: Registered nosave memory: 000000008afa3000 - 000000008afff000
[    0.000000] PM: Registered nosave memory: 000000008afff000 - 000000008b000000
[    0.000000] PM: Registered nosave memory: 000000008b000000 - 000000008ba00000
[    0.000000] PM: Registered nosave memory: 000000008ba00000 - 000000008fa00000
[    0.000000] PM: Registered nosave memory: 000000008fa00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed04000
[    0.000000] PM: Registered nosave memory: 00000000fed04000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at 8fa00000 (gap: 8fa00000:50600000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88016fa00000 s83392 r8192 d23104 u262144
[    0.000000] pcpu-alloc: s83392 r8192 d23104 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1002180
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.4.0-030400v201205231424-generic root=UUID=3b5f80a7-de95-4588-af4f-eedc09cfb366 ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3941156k/6027264k available (6683k kernel code, 1924348k absent, 161760k reserved, 6497k data, 912k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:16640 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 2199.915 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4399.83 BogoMIPS (lpj=8799660)
[    0.000006] pid_max: default: 32768 minimum: 301
[    0.000029] Security Framework initialized
[    0.000041] AppArmor: AppArmor initialized
[    0.000341] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001226] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001608] Mount-cache hash table entries: 256
[    0.001773] Initializing cgroup subsys cpuacct
[    0.001775] Initializing cgroup subsys memory
[    0.001782] Initializing cgroup subsys devices
[    0.001784] Initializing cgroup subsys freezer
[    0.001786] Initializing cgroup subsys blkio
[    0.001791] Initializing cgroup subsys perf_event
[    0.001816] CPU: Physical Processor ID: 0
[    0.001817] CPU: Processor Core ID: 0
[    0.001823] mce: CPU supports 9 MCE banks
[    0.001837] CPU0: Thermal monitoring enabled (TM1)
[    0.001844] using mwait in idle threads.
[    0.004505] ACPI: Core revision 20120320
[    0.011643] ftrace: allocating 25032 entries in 98 pages
[    0.027252] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066897] CPU0: Intel(R) Core(TM) i7-2675QM CPU @ 2.20GHz stepping 07
[    0.172412] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.172418] PEBS disabled due to CPU errata.
[    0.172420] ... version:                3
[    0.172422] ... bit width:              48
[    0.172423] ... generic registers:      4
[    0.172424] ... value mask:             0000ffffffffffff
[    0.172426] ... max period:             000000007fffffff
[    0.172427] ... fixed-purpose events:   3
[    0.172428] ... event mask:             000000070000000f
[    0.172577] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.172646] Booting Node   0, Processors  #1
[    0.185791] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.185870]  #2
[    0.199000] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.199076]  #3
[    0.212206] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.212281]  #4
[    0.225418] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.225504]  #5
[    0.238634] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.238711]  #6
[    0.251842] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.251915]  #7 Ok.
[    0.265051] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.265079] Brought up 8 CPUs
[    0.265082] Total of 8 processors activated (35198.64 BogoMIPS).
[    0.272665] devtmpfs: initialized
[    0.273524] EVM: security.selinux
[    0.273526] EVM: security.SMACK64
[    0.273527] EVM: security.capability
[    0.273567] PM: Registering ACPI NVS region [mem 0x8ad34000-0x8ad5efff] (176128 bytes)
[    0.274226] dummy: 
[    0.274255] RTC time: 13:45:21, date: 05/23/12
[    0.274288] NET: Registered protocol family 16
[    0.274412] ACPI: bus type pci registered
[    0.274472] PCI: MMCONFIG for domain 0000 [bus 00-9b] at [mem 0xe0000000-0xe9bfffff] (base 0xe0000000)
[    0.274475] PCI: MMCONFIG at [mem 0xe0000000-0xe9bfffff] reserved in E820
[    0.311429] PCI: Using configuration type 1 for base access
[    0.312330] bio: create slab <bio-0> at 0
[    0.312391] ACPI: Added _OSI(Module Device)
[    0.312393] ACPI: Added _OSI(Processor Device)
[    0.312394] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.312396] ACPI: Added _OSI(Processor Aggregator Device)
[    0.313808] ACPI: EC: EC description table is found, configuring boot EC
[    0.320134] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    2.314658] ACPI: SSDT 000000008ad39818 00781 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    2.315022] ACPI: Dynamic OEM Table Load:
[    2.315025] ACPI: SSDT           (null) 00781 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    2.315302] ACPI: SSDT 000000008ad3ac18 003A4 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    2.315713] ACPI: Dynamic OEM Table Load:
[    2.315715] ACPI: SSDT           (null) 003A4 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    2.315860] ACPI: SSDT 000000008ad38d98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    2.316224] ACPI: Dynamic OEM Table Load:
[    2.316227] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    2.317298] ACPI: Interpreter enabled
[    2.317302] ACPI: (supports S0 S3 S4 S5)
[    2.317322] ACPI: Using IOAPIC for interrupt routing
[    2.328890] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    2.329063] ACPI: No dock devices found.
[    2.329066] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.329344] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.329766] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    2.329769] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    2.329771] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    2.329774] pci_root PNP0A08:00: host bridge window [mem 0x8fa00000-0xfeafffff]
[    2.329776] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    2.329802] PCI host bridge to bus 0000:00
[    2.329804] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.329806] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.329808] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.329810] pci_bus 0000:00: root bus resource [mem 0x8fa00000-0xfeafffff]
[    2.329812] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    2.329821] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    2.329859] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    2.329893] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    2.329907] pci 0000:00:01.1: [8086:0105] type 01 class 0x060400
[    2.329939] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
[    2.329984] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    2.330010] pci 0000:00:16.0: reg 10: [mem 0xb0907100-0xb090710f 64bit]
[    2.330090] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    2.330121] pci 0000:00:1a.0: [8086:1c2c] type 00 class 0x0c0300
[    2.330167] pci 0000:00:1a.0: reg 20: [io  0x3120-0x313f]
[    2.330237] pci 0000:00:1a.7: [8086:1c2d] type 00 class 0x0c0320
[    2.330260] pci 0000:00:1a.7: reg 10: [mem 0xb0906c00-0xb0906fff]
[    2.330354] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    2.330383] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    2.330399] pci 0000:00:1b.0: reg 10: [mem 0xb0900000-0xb0903fff 64bit]
[    2.330470] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    2.330496] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    2.330579] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.330605] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    2.330688] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    2.330716] pci 0000:00:1c.2: [8086:1c14] type 01 class 0x060400
[    2.330798] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    2.330834] pci 0000:00:1d.0: [8086:1c27] type 00 class 0x0c0300
[    2.330879] pci 0000:00:1d.0: reg 20: [io  0x30c0-0x30df]
[    2.330951] pci 0000:00:1d.7: [8086:1c26] type 00 class 0x0c0320
[    2.330973] pci 0000:00:1d.7: reg 10: [mem 0xb0906800-0xb0906bff]
[    2.331068] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    2.331096] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
[    2.331224] pci 0000:00:1f.2: [8086:1c01] type 00 class 0x01018f
[    2.331241] pci 0000:00:1f.2: reg 10: [io  0x3148-0x314f]
[    2.331250] pci 0000:00:1f.2: reg 14: [io  0x315c-0x315f]
[    2.331259] pci 0000:00:1f.2: reg 18: [io  0x3140-0x3147]
[    2.331270] pci 0000:00:1f.2: reg 1c: [io  0x3158-0x315b]
[    2.331278] pci 0000:00:1f.2: reg 20: [io  0x3060-0x306f]
[    2.331287] pci 0000:00:1f.2: reg 24: [io  0xffe0-0xffef]
[    2.331338] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    2.331354] pci 0000:00:1f.3: reg 10: [mem 0xb0907000-0xb09070ff 64bit]
[    2.331377] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    2.331442] pci 0000:01:00.0: [1002:6741] type 00 class 0x030000
[    2.331458] pci 0000:01:00.0: reg 10: [mem 0x90000000-0x9fffffff 64bit pref]
[    2.331472] pci 0000:01:00.0: reg 18: [mem 0xb0800000-0xb081ffff 64bit]
[    2.331481] pci 0000:01:00.0: reg 20: [io  0x2000-0x20ff]
[    2.331497] pci 0000:01:00.0: reg 30: [mem 0xb0820000-0xb083ffff pref]
[    2.331538] pci 0000:01:00.0: supports D1 D2
[    2.331562] pci 0000:01:00.1: [1002:aa90] type 00 class 0x040300
[    2.331578] pci 0000:01:00.1: reg 10: [mem 0xb0840000-0xb0843fff 64bit]
[    2.331655] pci 0000:01:00.1: supports D1 D2
[    2.338235] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.338242] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    2.338250] pci 0000:00:01.0:   bridge window [mem 0xb0800000-0xb08fffff]
[    2.338259] pci 0000:00:01.0:   bridge window [mem 0x90000000-0x9fffffff 64bit pref]
[    2.338304] pci 0000:00:01.1: PCI bridge to [bus 05-9b]
[    2.338306] pci 0000:00:01.1:   bridge window [io  0x4000-0x4fff]
[    2.338309] pci 0000:00:01.1:   bridge window [mem 0xb0a00000-0xb4efffff]
[    2.338313] pci 0000:00:01.1:   bridge window [mem 0xb4f00000-0xb8efffff 64bit pref]
[    2.338420] pci 0000:02:00.0: [14e4:16b4] type 00 class 0x020000
[    2.338456] pci 0000:02:00.0: reg 10: [mem 0xb0400000-0xb040ffff 64bit pref]
[    2.338486] pci 0000:02:00.0: reg 18: [mem 0xb0410000-0xb041ffff 64bit pref]
[    2.338645] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    2.338725] pci 0000:02:00.1: [14e4:16bc] type 00 class 0x080501
[    2.338762] pci 0000:02:00.1: reg 10: [mem 0xb0420000-0xb042ffff 64bit pref]
[    2.338940] pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
[    2.346281] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.346288] pci 0000:00:1c.0:   bridge window [mem 0xb0700000-0xb07fffff]
[    2.346295] pci 0000:00:1c.0:   bridge window [mem 0xb0400000-0xb04fffff 64bit pref]
[    2.346406] pci 0000:03:00.0: [14e4:4331] type 00 class 0x028000
[    2.346453] pci 0000:03:00.0: reg 10: [mem 0xb0600000-0xb0603fff 64bit]
[    2.346714] pci 0000:03:00.0: supports D1 D2
[    2.346716] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    2.354250] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.354273] pci 0000:00:1c.1:   bridge window [mem 0xb0600000-0xb06fffff]
[    2.354356] pci 0000:04:00.0: [11c1:5901] type 00 class 0x0c0010
[    2.354393] pci 0000:04:00.0: reg 10: [mem 0xb0500000-0xb0500fff 64bit]
[    2.354574] pci 0000:04:00.0: supports D1 D2
[    2.354576] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.362215] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    2.362230] pci 0000:00:1c.2:   bridge window [mem 0xb0500000-0xb05fffff]
[    2.362279] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.362365] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    2.362398] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
[    2.362438] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    2.362470] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    2.362499] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    2.362585]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    2.362656]  pci0000:00: ACPI _OSC control (0x1d) granted
[    2.365817] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    2.365858] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    2.365899] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    2.365938] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    2.365976] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    2.366016] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    2.366054] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    2.366092] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    2.366176] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    2.366182] vgaarb: loaded
[    2.366184] vgaarb: bridge control possible 0000:01:00.0
[    2.366254] i2c-core: driver [tps65090] using legacy suspend method
[    2.366256] i2c-core: driver [tps65090] using legacy resume method
[    2.366313] SCSI subsystem initialized
[    2.366340] libata version 3.00 loaded.
[    2.366370] usbcore: registered new interface driver usbfs
[    2.366379] usbcore: registered new interface driver hub
[    2.366395] usbcore: registered new device driver usb
[    2.366447] PCI: Using ACPI for IRQ routing
[    2.368003] PCI: pci_cache_line_size set to 64 bytes
[    2.368191] reserve RAM buffer: 000000000008e000 - 000000000008ffff 
[    2.368193] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    2.368195] reserve RAM buffer: 000000008ad34000 - 000000008bffffff 
[    2.368198] reserve RAM buffer: 000000016fe00000 - 000000016fffffff 
[    2.368270] NetLabel: Initializing
[    2.368271] NetLabel:  domain hash size = 128
[    2.368272] NetLabel:  protocols = UNLABELED CIPSOv4
[    2.368282] NetLabel:  unlabeled traffic allowed by default
[    2.368343] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    2.368349] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    2.370365] Switching to clocksource hpet
[    2.375653] AppArmor: AppArmor Filesystem Enabled
[    2.375671] pnp: PnP ACPI init
[    2.375684] ACPI: bus type pnp registered
[    2.375937] pnp 00:00: [bus 00-ff]
[    2.375939] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.375941] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.375943] pnp 00:00: [io  0x0d00-0xffff window]
[    2.375945] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.375947] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    2.375950] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    2.375952] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    2.375954] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    2.375956] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    2.375958] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    2.375960] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    2.375961] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    2.375963] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    2.375965] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    2.375967] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    2.375969] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    2.375971] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    2.375972] pnp 00:00: [mem 0x8fa00000-0xfeafffff window]
[    2.375974] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    2.376028] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    2.376108] pnp 00:01: [io  0x0000-0x001f]
[    2.376110] pnp 00:01: [io  0x0081-0x0091]
[    2.376112] pnp 00:01: [io  0x0093-0x009f]
[    2.376113] pnp 00:01: [io  0x00c0-0x00df]
[    2.376115] pnp 00:01: [dma 4]
[    2.376140] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    2.376147] pnp 00:02: [mem 0xff000000-0xffffffff]
[    2.376169] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    2.376233] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    2.376274] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    2.376277] system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    2.376286] pnp 00:04: [io  0x00f0]
[    2.376295] pnp 00:04: [irq 13]
[    2.376318] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    2.376327] pnp 00:05: [io  0x002e-0x002f]
[    2.376329] pnp 00:05: [io  0x004e-0x004f]
[    2.376330] pnp 00:05: [io  0x0061]
[    2.376332] pnp 00:05: [io  0x0063]
[    2.376333] pnp 00:05: [io  0x0065]
[    2.376335] pnp 00:05: [io  0x0067]
[    2.376336] pnp 00:05: [io  0x0070]
[    2.376337] pnp 00:05: [io  0x0080]
[    2.376339] pnp 00:05: [io  0x0092]
[    2.376340] pnp 00:05: [io  0x00b2-0x00b3]
[    2.376342] pnp 00:05: [io  0x0680-0x069f]
[    2.376344] pnp 00:05: [io  0x1000-0x100f]
[    2.376345] pnp 00:05: [io  0xffff]
[    2.376347] pnp 00:05: [io  0xffff]
[    2.376348] pnp 00:05: [io  0x0400-0x047f]
[    2.376350] pnp 00:05: [io  0x0500-0x057f]
[    2.376351] pnp 00:05: [io  0x164e-0x164f]
[    2.376392] system 00:05: [io  0x0680-0x069f] has been reserved
[    2.376394] system 00:05: [io  0x1000-0x100f] has been reserved
[    2.376396] system 00:05: [io  0xffff] has been reserved
[    2.376398] system 00:05: [io  0xffff] has been reserved
[    2.376400] system 00:05: [io  0x0400-0x047f] has been reserved
[    2.376402] system 00:05: [io  0x0500-0x057f] has been reserved
[    2.376404] system 00:05: [io  0x164e-0x164f] has been reserved
[    2.376407] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.376414] pnp 00:06: [io  0x0070-0x0077]
[    2.376420] pnp 00:06: [irq 8]
[    2.376446] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.376457] pnp 00:07: [io  0x0300-0x031f]
[    2.376462] pnp 00:07: [irq 6]
[    2.376485] pnp 00:07: Plug and Play ACPI device, IDs APP0001 (active)
[    2.376527] pnp 00:08: [io  0x0700-0x07fe]
[    2.376556] pnp 00:08: Plug and Play ACPI device, IDs APP000b (active)
[    2.376683] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    2.376684] pnp 00:09: [mem 0xfed10000-0xfed17fff]
[    2.376686] pnp 00:09: [mem 0xfed18000-0xfed18fff]
[    2.376688] pnp 00:09: [mem 0xfed19000-0xfed19fff]
[    2.376689] pnp 00:09: [mem 0xe0000000-0xefffffff]
[    2.376691] pnp 00:09: [mem 0xfed20000-0xfed3ffff]
[    2.376693] pnp 00:09: [mem 0xfed90000-0xfed93fff]
[    2.376695] pnp 00:09: [mem 0xfed45000-0xfed8ffff]
[    2.376696] pnp 00:09: [mem 0xff000000-0xffffffff]
[    2.376698] pnp 00:09: [mem 0xfee00000-0xfeefffff]
[    2.376700] pnp 00:09: [mem 0x00000000-0xffffffffffffffff disabled]
[    2.376742] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    2.376745] system 00:09: [mem 0xfed10000-0xfed17fff] could not be reserved
[    2.376747] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    2.376749] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    2.376752] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    2.376754] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    2.376756] system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
[    2.376758] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    2.376761] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
[    2.376763] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
[    2.376766] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    2.376817] pnp 00:0a: [mem 0x20000000-0x201fffff]
[    2.376818] pnp 00:0a: [mem 0x40000000-0x401fffff]
[    2.376862] system 00:0a: [mem 0x20000000-0x201fffff] has been reserved
[    2.376864] system 00:0a: [mem 0x40000000-0x401fffff] has been reserved
[    2.376867] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    2.382858] pnp: PnP ACPI: found 11 devices
[    2.382860] ACPI: ACPI bus type pnp unregistered
[    2.388981] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    2.388985] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    2.388988] pci 0000:00:01.0:   bridge window [mem 0xb0800000-0xb08fffff]
[    2.388991] pci 0000:00:01.0:   bridge window [mem 0x90000000-0x9fffffff 64bit pref]
[    2.388995] pci 0000:00:01.1: PCI bridge to [bus 05-9b]
[    2.388997] pci 0000:00:01.1:   bridge window [io  0x4000-0x4fff]
[    2.389000] pci 0000:00:01.1:   bridge window [mem 0xb0a00000-0xb4efffff]
[    2.389003] pci 0000:00:01.1:   bridge window [mem 0xb4f00000-0xb8efffff 64bit pref]
[    2.389007] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.389013] pci 0000:00:1c.0:   bridge window [mem 0xb0700000-0xb07fffff]
[    2.389018] pci 0000:00:1c.0:   bridge window [mem 0xb0400000-0xb04fffff 64bit pref]
[    2.389024] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.389030] pci 0000:00:1c.1:   bridge window [mem 0xb0600000-0xb06fffff]
[    2.389039] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    2.389044] pci 0000:00:1c.2:   bridge window [mem 0xb0500000-0xb05fffff]
[    2.389091] pci 0000:00:1c.1: power state changed by ACPI to D0
[    2.389096] pci 0000:00:1c.1: power state changed by ACPI to D0
[    2.389114] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.389116] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.389118] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.389120] pci_bus 0000:00: resource 7 [mem 0x8fa00000-0xfeafffff]
[    2.389121] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    2.389124] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    2.389125] pci_bus 0000:01: resource 1 [mem 0xb0800000-0xb08fffff]
[    2.389128] pci_bus 0000:01: resource 2 [mem 0x90000000-0x9fffffff 64bit pref]
[    2.389130] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    2.389132] pci_bus 0000:05: resource 1 [mem 0xb0a00000-0xb4efffff]
[    2.389134] pci_bus 0000:05: resource 2 [mem 0xb4f00000-0xb8efffff 64bit pref]
[    2.389136] pci_bus 0000:02: resource 1 [mem 0xb0700000-0xb07fffff]
[    2.389138] pci_bus 0000:02: resource 2 [mem 0xb0400000-0xb04fffff 64bit pref]
[    2.389140] pci_bus 0000:03: resource 1 [mem 0xb0600000-0xb06fffff]
[    2.389142] pci_bus 0000:04: resource 1 [mem 0xb0500000-0xb05fffff]
[    2.389169] NET: Registered protocol family 2
[    2.389278] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.389899] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.391172] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.391306] TCP: Hash tables configured (established 524288 bind 65536)
[    2.391309] TCP: reno registered
[    2.391318] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    2.391338] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    2.391406] NET: Registered protocol family 1
[    2.391788] pci 0000:01:00.0: Boot video device
[    2.391857] PCI: CLS 256 bytes, default 64
[    2.391897] Trying to unpack rootfs image as initramfs...
[    2.635795] Freeing initrd memory: 13412k freed
[    2.637407] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.637412] Placing 64MB software IO TLB between ffff880086d2d000 - ffff88008ad2d000
[    2.637414] software IO TLB at phys 0x86d2d000 - 0x8ad2d000
[    2.638069] audit: initializing netlink socket (disabled)
[    2.638085] type=2000 audit(1337780723.528:1): initialized
[    2.658999] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.660341] VFS: Disk quotas dquot_6.5.2
[    2.660380] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.660742] fuse init (API version 7.18)
[    2.660806] msgmni has been set to 7723
[    2.661085] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.661109] io scheduler noop registered
[    2.661110] io scheduler deadline registered
[    2.661147] io scheduler cfq registered (default)
[    2.661248] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    2.661312] pcieport 0000:00:01.1: irq 41 for MSI/MSI-X
[    2.661399] pcieport 0000:00:1c.0: irq 42 for MSI/MSI-X
[    2.661502] pcieport 0000:00:1c.1: irq 43 for MSI/MSI-X
[    2.661606] pcieport 0000:00:1c.2: irq 44 for MSI/MSI-X
[    2.661681] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    2.661683] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    2.661685] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    2.661688] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    2.661699] pcieport 0000:00:01.1: Signaling PME through PCIe PME interrupt
[    2.661702] pcie_pme 0000:00:01.1:pcie01: service driver pcie_pme loaded
[    2.661719] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    2.661721] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    2.661722] pci 0000:02:00.1: Signaling PME through PCIe PME interrupt
[    2.661727] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    2.661745] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    2.661746] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    2.661751] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    2.661768] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    2.661770] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    2.661775] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    2.661786] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.661801] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.661840] efifb: dmi detected MacBookPro8,2 - framebuffer at 0x90000000 (1152x864, stride 4608)
[    2.661842] intel_idle: MWAIT substates: 0x21120
[    2.661844] intel_idle: v0.4 model 0x2A
[    2.661845] intel_idle: lapic_timer_reliable_states 0xffffffff
[    2.661905] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.661937] ACPI: AC Adapter [ADP1] (off-line)
[    2.662033] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    2.662047] ACPI: Lid Switch [LID0]
[    2.662079] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    2.662083] ACPI: Power Button [PWRB]
[    2.662110] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    2.662113] ACPI: Sleep Button [SLPB]
[    2.662140] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    2.662142] ACPI: Power Button [PWRF]
[    2.662179] ACPI: Requesting acpi_cpufreq
[    2.675443] GHES: HEST is not enabled!
[    2.675517] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    2.678707] Linux agpgart interface v0.103
[    2.679823] brd: module loaded
[    2.680374] loop: module loaded
[    2.680479] ata_piix 0000:00:1f.2: version 2.13
[    2.680493] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    2.788005] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.788011] ACPI: Battery Slot [BAT0] (battery present)
[    2.833836] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.834054] scsi0 : ata_piix
[    2.834108] scsi1 : ata_piix
[    2.834267] ata1: SATA max UDMA/133 cmd 0x3148 ctl 0x315c bmdma 0x3060 irq 19
[    2.834272] ata2: SATA max UDMA/133 cmd 0x3140 ctl 0x3158 bmdma 0x3068 irq 19
[    2.834474] Fixed MDIO Bus: probed
[    2.834485] tun: Universal TUN/TAP device driver, 1.6
[    2.834487] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.834522] PPP generic driver version 2.4.2
[    2.834585] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.834628] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.834633] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.834681] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    2.834709] ehci_hcd 0000:00:1a.7: debug port 2
[    2.838583] ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
[    2.838598] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xb0906c00
[    2.849800] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.849925] hub 1-0:1.0: USB hub found
[    2.849929] hub 1-0:1.0: 6 ports detected
[    2.850006] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.850009] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.850048] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.850069] ehci_hcd 0000:00:1d.7: debug port 2
[    2.853945] ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
[    2.853959] ehci_hcd 0000:00:1d.7: irq 22, io mem 0xb0906800
[    2.865782] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.865890] hub 2-0:1.0: USB hub found
[    2.865893] hub 2-0:1.0: 8 ports detected
[    2.865953] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.865966] uhci_hcd: USB Universal Host Controller Interface driver
[    2.865982] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.865986] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    2.866018] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.866052] uhci_hcd 0000:00:1a.0: irq 21, io base 0x00003120
[    2.866133] hub 3-0:1.0: USB hub found
[    2.866136] hub 3-0:1.0: 2 ports detected
[    2.866183] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.866187] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.866219] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    2.866242] uhci_hcd 0000:00:1d.0: irq 19, io base 0x000030c0
[    2.866321] hub 4-0:1.0: USB hub found
[    2.866323] hub 4-0:1.0: 2 ports detected
[    2.866397] usbcore: registered new interface driver libusual
[    2.866423] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    2.867297] i8042: No controller found
[    2.867349] mousedev: PS/2 mouse device common for all mice
[    2.867492] rtc_cmos 00:06: RTC can wake from S4
[    2.867603] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    2.867632] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    2.867694] device-mapper: uevent: version 1.0.3
[    2.867743] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    2.867871] cpuidle: using governor ladder
[    2.868049] cpuidle: using governor menu
[    2.868051] EFI Variables Facility v0.08 2004-May-17
[    2.868173] ashmem: initialized
[    2.868196] using rtc device, rtc_cmos, for alarms
[    2.868295] TCP: cubic registered
[    2.868375] NET: Registered protocol family 10
[    2.868533] NET: Registered protocol family 17
[    2.868542] Registering the dns_resolver key type
[    2.868648] PM: Hibernation image not present or could not be loaded.
[    2.868657] registered taskstats version 1
[    2.875505]   Magic number: 12:336:787
[    2.875613] rtc_cmos 00:06: setting system clock to 2012-05-23 13:45:24 UTC (1337780724)
[    2.876729] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.876730] EDD information not available.
[    3.161579] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    3.294343] hub 1-1:1.0: USB hub found
[    3.294510] hub 1-1:1.0: 3 ports detected
[    3.405362] usb 1-2: new high-speed USB device number 3 using ehci_hcd
[    3.633105] Refined TSC clocksource calibration: 2200.015 MHz.
[    3.633117] Switching to clocksource tsc
[    3.665080] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    3.797847] hub 2-1:1.0: USB hub found
[    3.798013] hub 2-1:1.0: 2 ports detected
[    3.885068] usb 1-1.1: new full-speed USB device number 4 using ehci_hcd
[    3.979701] hub 1-1.1:1.0: USB hub found
[    3.979974] hub 1-1.1:1.0: 3 ports detected
[    4.052908] usb 1-1.2: new full-speed USB device number 5 using ehci_hcd
[    4.180575] ata1.01: failed to resume link (SControl 0)
[    4.180673] ata2.01: failed to resume link (SControl 0)
[    4.240724] usb 2-1.1: new low-speed USB device number 3 using ehci_hcd
[    4.336482] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.336495] ata1.01: SATA link down (SStatus 0 SControl 0)
[    4.336624] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.336639] ata2.01: SATA link down (SStatus 0 SControl 0)
[    4.336658] ata2.01: link offline, clearing class 3 to NONE
[    4.344827] ata2.00: ATAPI: MATSHITADVD-R   UJ-8A8, HB14, max UDMA/100
[    4.344985] ata1.00: ATA-8: Hitachi HTS545050B9A302, PB4AC60Y, max UDMA/133
[    4.344987] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    4.360756] ata2.00: configured for UDMA/100
[    4.361075] ata1.00: configured for UDMA/133
[    4.361292] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54505 PB4A PQ: 0 ANSI: 5
[    4.361404] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    4.361433] sd 0:0:0:0: [sda] Write Protect is off
[    4.361437] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.361439] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.361454] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.364683] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-8A8   HB14 PQ: 0 ANSI: 5
[    4.368357] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    4.368366] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.368519] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    4.368632] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.410476]  sda: sda1 sda2 sda3 sda4 sda5 sda99
[    4.411154] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.412250] Freeing unused kernel memory: 912k freed
[    4.412339] Write protecting the kernel read-only data: 12288k
[    4.415586] Freeing unused kernel memory: 1488k freed
[    4.418104] Freeing unused kernel memory: 1132k freed
[    4.428346] usb 1-1.1.1: new full-speed USB device number 6 using ehci_hcd
[    4.431277] udevd[124]: starting version 175
[    4.465096] sdhci: Secure Digital Host Controller Interface driver
[    4.465100] sdhci: Copyright(c) Pierre Ossman
[    4.465693] tg3.c:v3.123 (March 21, 2012)
[    4.465720] usbcore: registered new interface driver usbhid
[    4.465722] usbhid: USB HID core driver
[    4.481907] tg3 0000:02:00.0: eth0: Tigon3 [partno(BCM957765) rev 57785100] (PCI Express) MAC address 3c:07:54:42:d4:d9
[    4.481912] tg3 0000:02:00.0: eth0: attached PHY is 57765 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[    4.481916] tg3 0000:02:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    4.481918] tg3 0000:02:00.0: eth0: dma_rwctrl[00000001] dma_mask[64-bit]
[    4.482049] sdhci-pci 0000:02:00.1: SDHCI controller found [14e4:16bc] (rev 10)
[    4.482101] sdhci-pci 0000:02:00.1: Invalid iomem size. You may experience problems.
[    4.482202] mmc0: no vmmc regulator found
[    4.482264] Registered led device: mmc0::
[    4.483347] mmc0: SDHCI controller on PCI [0000:02:00.1] using ADMA
[    4.487777] input: Apple Inc. Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.0/input/input4
[    4.487877] apple 0003:05AC:0252.0001: input,hidraw0: USB HID v1.11 Keyboard [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input0
[    4.492090] apple 0003:05AC:0252.0002: hidraw1: USB HID v1.11 Device [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input1
[    4.495892] apple 0003:05AC:8242.0003: hiddev0,hidraw2: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.7-1.1/input0
[    4.520295] firewire_ohci 0000:04:00.0: irq 45 for MSI/MSI-X
[    4.520344] firewire_ohci 0000:04:00.0: added OHCI v1.10 device as card 0, 8 IR + 8 IT contexts, quirks 0x0
[    4.524876] input: HID 05ac:820a as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/input/input5
[    4.525024] generic-usb 0003:05AC:820A.0004: input,hidraw3: USB HID v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:1a.7-1.1.1/input0
[    4.596302] usb 1-1.1.2: new full-speed USB device number 7 using ehci_hcd
[    4.694172] input: HID 05ac:820b as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.2/1-1.1.2:1.0/input/input6
[    4.694331] generic-usb 0003:05AC:820B.0005: input,hidraw4: USB HID v1.11 Mouse [HID 05ac:820b] on usb-0000:00:1a.7-1.1.2/input0
[    4.764005] usb 1-1.1.3: new full-speed USB device number 8 using ehci_hcd
[    5.019847] firewire_core 0000:04:00.0: created device fw0: GUID a4b197fffea72698, S800
[    5.019854] firewire_core 0000:04:00.0: phy config: new root=ffc0, gap_count=63
[    5.212470] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
[   16.901280] Adding 3999996k swap on /dev/sda5.  Priority:-1 extents:1 across:3999996k 
[   16.937715] udevd[472]: starting version 175
[   17.292450] type=1400 audit(1337780738.929:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=534 comm="apparmor_parser"
[   17.292471] type=1400 audit(1337780738.929:3): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=646 comm="apparmor_parser"
[   17.292706] type=1400 audit(1337780738.929:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=534 comm="apparmor_parser"
[   17.292728] type=1400 audit(1337780738.929:5): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=646 comm="apparmor_parser"
[   17.292852] type=1400 audit(1337780738.929:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=534 comm="apparmor_parser"
[   17.292876] type=1400 audit(1337780738.929:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=646 comm="apparmor_parser"
[   17.344603] lp: driver loaded but no devices found
[   17.352641] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input7
[   17.352714] usbcore: registered new interface driver bcm5974
[   17.353406] [Firmware Bug]: ACPI(GFX0) defines _DOD but not _DOS
[   17.354111] acpi device:03: registered as cooling_device8
[   17.354129] ACPI Error: Evaluating _BCM failed (20120320/video-364)
[   17.354166] video: probe of LNXVIDEO:00 failed with error -5
[   18.094662] mei: module is from the staging directory, the quality is unknown, you have been warned.
[   18.095003] mei 0000:00:16.0: setting latency timer to 64
[   18.095063] mei 0000:00:16.0: irq 46 for MSI/MSI-X
[   18.205068] applesmc: key=441 fan=2 temp=29 acc=1 lux=2 kbd=1
[   18.218164] input: applesmc as /devices/platform/applesmc.768/input/input8
[   18.218314] Registered led device: smc::kbd_backlight
[   18.493180] bcma: Found chip with id 0x4331, rev 0x02 and package 0x09
[   18.493211] bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x25, class 0x0)
[   18.493237] bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x1D, class 0x0)
[   18.493294] bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x13, class 0x0)
[   18.551979] apple_gmux: Found gmux version 1.9.35
[   18.595168] bcma: Bus registered
[   18.690478] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x1a
[   18.751218] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x1a
[   18.752034] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x1a
[   18.752849] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x1a
[   18.753654] microcode: CPU4 sig=0x206a7, pf=0x10, revision=0x1a
[   18.754469] microcode: CPU5 sig=0x206a7, pf=0x10, revision=0x1a
[   18.755325] microcode: CPU6 sig=0x206a7, pf=0x10, revision=0x1a
[   18.756092] microcode: CPU7 sig=0x206a7, pf=0x10, revision=0x1a
[   18.756885] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   18.818655] [drm] Initialized drm 1.1.0 20060810
[   18.932611] Bluetooth: Core ver 2.16
[   18.932625] NET: Registered protocol family 31
[   18.932627] Bluetooth: HCI device and connection manager initialized
[   18.932629] Bluetooth: HCI socket layer initialized
[   18.932631] Bluetooth: L2CAP socket layer initialized
[   18.932635] Bluetooth: SCO socket layer initialized
[   19.008530] usbcore: registered new interface driver btusb
[   19.081274] usb 1-1.1.1: USB disconnect, device number 6
[   19.229956] cfg80211: Calling CRDA to update world regulatory domain
[   19.238243] usb 1-1.1.2: USB disconnect, device number 7
[   19.385346] Linux video capture interface: v2.00
[   19.500826] uvcvideo: Found UVC 1.00 device FaceTime HD Camera (Built-in) (05ac:8509)
[   19.507782] input: FaceTime HD Camera (Built-in) as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2:1.0/input/input9
[   19.507887] usbcore: registered new interface driver uvcvideo
[   19.507888] USB Video Class driver (1.1.1)
[   19.699275] [drm] radeon defaulting to kernel modesetting.
[   19.699277] [drm] radeon kernel modesetting enabled.
[   19.699508] [drm] initializing kernel modesetting (TURKS 0x1002:0x6741 0x106B:0x00E2).
[   19.699609] [drm] register mmio base: 0xB0800000
[   19.699611] [drm] register mmio size: 131072
[   19.699739] ATOM BIOS: Apple
[   19.699766] radeon 0000:01:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
[   19.699768] radeon 0000:01:00.0: GTT: 512M 0x0000000020000000 - 0x000000003FFFFFFF
[   19.704335] [drm] Detected VRAM RAM=512M, BAR=256M
[   19.704337] [drm] RAM width 128bits DDR
[   19.704437] [TTM] Zone  kernel: Available graphics memory: 1979050 kiB
[   19.704438] [TTM] Initializing pool allocator
[   19.704441] [TTM] Initializing DMA pool allocator
[   19.704461] [drm] radeon: 512M of VRAM memory ready
[   19.704462] [drm] radeon: 512M of GTT memory ready.
[   19.704475] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   19.704476] [drm] Driver supports precise vblank timestamp query.
[   19.704528] radeon 0000:01:00.0: irq 47 for MSI/MSI-X
[   19.704537] radeon 0000:01:00.0: radeon: using MSI.
[   19.704579] [drm] radeon: irq initialized.
[   19.704582] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   19.704859] [drm] radeon: ib pool ready.
[   19.704923] [drm] Loading TURKS Microcode
[   19.885799] cfg80211: World regulatory domain updated:
[   19.885801] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   19.885803] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   19.885805] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   19.885807] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   19.885808] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   19.885810] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.025620] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[   20.025739] radeon 0000:01:00.0: WB enabled
[   20.025742] [drm] fence driver on ring 0 use gpu addr 0x20000c00 and cpu addr 0xffff88015a800c00
[   20.042084] [drm] ring test on 0 succeeded in 2 usecs
[   20.042309] [drm] ib test on ring 0 succeeded in 0 usecs
[   20.043376] [drm] Radeon Display Connectors
[   20.043378] [drm] Connector 0:
[   20.043379] [drm]   LVDS
[   20.043380] [drm]   DDC: 0x6470 0x6470 0x6474 0x6474 0x6478 0x6478 0x647c 0x647c
[   20.043381] [drm]   Encoders:
[   20.043382] [drm]     LCD1: INTERNAL_UNIPHY
[   20.043383] [drm] Connector 1:
[   20.043384] [drm]   DisplayPort
[   20.043385] [drm]   HPD1
[   20.043386] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[   20.043388] [drm]   Encoders:
[   20.043389] [drm]     DFP1: INTERNAL_UNIPHY1
[   20.043389] [drm] Connector 2:
[   20.043390] [drm]   DisplayPort
[   20.043391] [drm]   HPD2
[   20.043392] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 0x644c
[   20.043393] [drm]   Encoders:
[   20.043394] [drm]     DFP2: INTERNAL_UNIPHY1
[   20.043395] [drm] Connector 3:
[   20.043396] [drm]   DisplayPort
[   20.043397] [drm]   HPD3
[   20.043398] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458 0x645c 0x645c
[   20.043399] [drm]   Encoders:
[   20.043400] [drm]     DFP3: INTERNAL_UNIPHY2
[   20.043496] [drm] Special thermal controller config
[   20.044599] [drm] radeon: power management initialized
[   20.089358] EXT4-fs (sda4): re-mounted. Opts: errors=remount-ro
[   20.372571] b43-phy0: Broadcom 4331 WLAN found (core revision 29)
[   20.373240] Broadcom 43xx driver loaded [ Features: PNL ]
[   20.495696] [drm] fb mappable at 0x90142000
[   20.495698] [drm] vram apper at 0x90000000
[   20.495699] [drm] size 5324800
[   20.495700] [drm] fb depth is 24
[   20.495701] [drm]    pitch is 5888
[   20.495831] fbcon: radeondrmfb (fb0) is primary device
[   20.585660] snd_hda_intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[   20.609915] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[   20.609917] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.609918] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[   20.609920] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.609921] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[   20.609923] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.609924] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[   20.609926] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.609927] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[   20.609929] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.609930] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[   20.609931] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.609933] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[   20.609934] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.609935] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[   20.609937] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.609938] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[   20.609940] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.609941] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[   20.609943] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.609944] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[   20.609945] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   20.609947] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
[   20.609948] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   20.609950] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
[   20.609951] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   20.609952] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
[   20.609954] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   20.666875] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   20.667064] Registered led device: b43-phy0::tx
[   20.667076] Registered led device: b43-phy0::rx
[   20.667094] Registered led device: b43-phy0::radio
[   20.689977] input: HDA Intel PCH SPDIF In as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   20.690050] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   20.690110] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   21.228237] Console: switching to colour frame buffer device 180x56
[   21.230876] fb0: radeondrmfb frame buffer device
[   21.230877] drm: registered panic notifier
[   21.230890] [drm] Initialized radeon 2.15.0 20080528 for 0000:01:00.0 on minor 0
[   21.231061] snd_hda_intel 0000:01:00.1: irq 49 for MSI/MSI-X
[   21.297431] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input13
[   21.309570] init: failsafe main process (899) killed by TERM signal
[   21.427188] type=1400 audit(1337780743.065:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=986 comm="apparmor_parser"
[   21.428055] type=1400 audit(1337780743.069:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=986 comm="apparmor_parser"
[   21.428215] type=1400 audit(1337780743.069:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=986 comm="apparmor_parser"
[   21.477635] tg3 0000:02:00.0: irq 50 for MSI/MSI-X
[   21.477640] tg3 0000:02:00.0: irq 51 for MSI/MSI-X
[   21.477643] tg3 0000:02:00.0: irq 52 for MSI/MSI-X
[   21.477646] tg3 0000:02:00.0: irq 53 for MSI/MSI-X
[   21.477650] tg3 0000:02:00.0: irq 54 for MSI/MSI-X
[   21.507556] type=1400 audit(1337780743.145:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=985 comm="apparmor_parser"
[   21.556132] ppdev: user-space parallel port driver
[   21.623303] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   21.623306] Bluetooth: BNEP filters: protocol multicast
[   21.664705] Bluetooth: RFCOMM TTY layer initialized
[   21.664709] Bluetooth: RFCOMM socket layer initialized
[   21.664710] Bluetooth: RFCOMM ver 1.11
[   21.772703] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   21.931358] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
[   21.991977] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   22.418923] init: plymouth-stop pre-start process (1306) terminated with status 1
[   25.156682] tg3 0000:02:00.0: eth0: Link is up at 1000 Mbps, full duplex
[   25.156684] tg3 0000:02:00.0: eth0: Flow control is on for TX and on for RX
[   25.156686] tg3 0000:02:00.0: eth0: EEE is disabled
[   25.156897] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   25.212860] wlan0: authenticate with c0:c1:c0:45:40:dd
[   25.244286] wlan0: send auth to c0:c1:c0:45:40:dd (try 1/3)
[   25.246117] wlan0: authenticated
[   25.248157] wlan0: associate with c0:c1:c0:45:40:dd (try 1/3)
[   25.252328] wlan0: RX AssocResp from c0:c1:c0:45:40:dd (capab=0x411 status=0 aid=1)
[   25.252330] wlan0: associated
[   25.252895] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   35.546004] eth0: no IPv6 routers present
[   35.785725] wlan0: no IPv6 routers present
[  112.009220] wlan0: deauthenticating from c0:c1:c0:45:40:dd by local choice (reason=3)
[  112.017476] cfg80211: All devices are disconnected, going to restore regulatory settings
[  112.017481] cfg80211: Restoring regulatory settings
[  112.017487] cfg80211: Calling CRDA to update world regulatory domain
[  112.025379] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[  112.025391] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.025397] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[  112.025404] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.025409] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[  112.025453] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.025463] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[  112.025474] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.025481] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[  112.025490] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.025498] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[  112.025507] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.025514] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[  112.025529] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.025543] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[  112.025568] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.025572] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[  112.025577] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.025580] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[  112.025584] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.025587] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[  112.025590] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.025593] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
[  112.025597] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  112.025599] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
[  112.025603] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  112.025606] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
[  112.025610] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  112.025613] cfg80211: World regulatory domain updated:
[  112.025616] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  112.025619] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.025622] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  112.025625] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  112.025628] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  112.025631] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  113.893281] PM: Syncing filesystems ... done.
[  113.893761] PM: Preparing system for mem sleep
[  113.994897] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  114.010618] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  114.026676] PM: Entering mem sleep
[  114.026695] Suspending console(s) (use no_console_suspend to debug)
[  114.027122] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  114.027269] apple-gmux 00:08: wake-up capability disabled by ACPI
[  114.046151] sd 0:0:0:0: [sda] Stopping disk
[  114.821399] PM: suspend of devices complete after 795.772 msecs
[  114.821406] PM: suspend devices took 0.796 seconds
[  114.821498] PM: late suspend of devices complete after 0.078 msecs
[  114.837471] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[  114.853388] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[  114.885284] PM: noirq suspend of devices complete after 63.874 msecs
[  114.886252] ACPI: Preparing to enter system sleep state S3
[  114.925283] PM: Saving platform NVS memory
[  114.925562] Disabling non-boot CPUs ...
[  115.029119] CPU 1 is now offline
[  115.133001] CPU 2 is now offline
[  115.236725] CPU 3 is now offline
[  115.340690] CPU 4 is now offline
[  115.341396] Broke affinity for irq 23
[  115.444457] CPU 5 is now offline
[  115.548332] CPU 6 is now offline
[  115.548849] Broke affinity for irq 47
[  115.549853] CPU 7 is now offline
[  115.550131] Extended CMOS year: 2000
[  115.551309] ACPI: Low-level resume complete
[  115.551350] PM: Restoring platform NVS memory
[  115.551663] Extended CMOS year: 2000
[  115.551699] Enabling non-boot CPUs ...
[  115.551773] Booting Node 0 Processor 1 APIC 0x2
[  115.566831] NMI watchdog: enabled, takes one hw-pmu counter.
[  115.567225] CPU1 is up
[  115.567910] Booting Node 0 Processor 2 APIC 0x4
[  115.583503] NMI watchdog: enabled, takes one hw-pmu counter.
[  115.596011] CPU2 is up
[  115.598061] Booting Node 0 Processor 3 APIC 0x6
[  115.617290] NMI watchdog: enabled, takes one hw-pmu counter.
[  115.630641] CPU3 is up
[  115.632131] Booting Node 0 Processor 4 APIC 0x1
[  115.651174] NMI watchdog: enabled, takes one hw-pmu counter.
[  115.664115] CPU4 is up
[  115.665925] Booting Node 0 Processor 5 APIC 0x3
[  115.687598] NMI watchdog: enabled, takes one hw-pmu counter.
[  115.688485] CPU5 is up
[  115.690953] Booting Node 0 Processor 6 APIC 0x5
[  115.706944] NMI watchdog: enabled, takes one hw-pmu counter.
[  115.722254] CPU6 is up
[  115.725494] Booting Node 0 Processor 7 APIC 0x7
[  115.750523] NMI watchdog: enabled, takes one hw-pmu counter.
[  115.751760] CPU7 is up
[  115.759373] ACPI: Waking up from system sleep state S3
[  116.676491] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[  116.676757] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[  116.677485] PM: noirq resume of devices complete after 1.173 msecs
[  116.677557] PM: early resume of devices complete after 0.043 msecs
[  116.677632] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  116.677664] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[  116.677667] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  116.677671] usb usb3: root hub lost power or was reset
[  116.677702] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  116.677753] usb usb4: root hub lost power or was reset
[  116.677762] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[  116.677789] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  116.677815] ata_piix 0000:00:1f.2: setting latency timer to 64
[  116.678100] snd_hda_intel 0000:01:00.1: irq 48 for MSI/MSI-X
[  116.693562] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[  116.693768] radeon 0000:01:00.0: WB enabled
[  116.693771] [drm] fence driver on ring 0 use gpu addr 0x20000c00 and cpu addr 0xffff88015a800c00
[  116.709958] [drm] ring test on 0 succeeded in 2 usecs
[  116.710002] [drm] ib test on ring 0 succeeded in 0 usecs
[  116.732263] firewire_ohci 0000:04:00.0: irq 49 for MSI/MSI-X
[  117.231438] firewire_core 0000:04:00.0: rediscovered device fw0
[  118.022220] ata1.01: failed to resume link (SControl 0)
[  118.022313] ata2.01: failed to resume link (SControl 0)
[  118.178110] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  118.178121] ata1.01: SATA link down (SStatus 0 SControl 0)
[  118.178245] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  118.178258] ata2.01: SATA link down (SStatus 0 SControl 0)
[  118.178277] ata2.01: link offline, clearing class 3 to NONE
[  118.186335] ata2.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[  118.186411] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[  118.202362] ata2.00: configured for UDMA/100
[  118.202599] ata1.00: configured for UDMA/133
[  118.203153] sd 0:0:0:0: [sda] Starting disk
[  118.205958] Extended CMOS year: 2000
[  118.230421] PM: resume of devices complete after 1555.145 msecs
[  118.230484] PM: resume devices took 1.556 seconds
[  118.230500] PM: Finishing wakeup.
[  118.230501] Restarting tasks ... done.
[  118.873702] tg3 0000:02:00.0: irq 50 for MSI/MSI-X
[  118.873718] tg3 0000:02:00.0: irq 51 for MSI/MSI-X
[  118.873729] tg3 0000:02:00.0: irq 52 for MSI/MSI-X
[  118.873741] tg3 0000:02:00.0: irq 53 for MSI/MSI-X
[  118.873751] tg3 0000:02:00.0: irq 54 for MSI/MSI-X
[  119.167111] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  119.324422] b43-phy0: Loading firmware version 666.2 (2011-02-23 01:15:07)
[  119.374503] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  122.496708] wlan0: authenticate with c0:c1:c0:45:40:dd
[  122.507911] wlan0: send auth to c0:c1:c0:45:40:dd (try 1/3)
[  122.563193] tg3 0000:02:00.0: eth0: Link is up at 1000 Mbps, full duplex
[  122.563202] tg3 0000:02:00.0: eth0: Flow control is on for TX and on for RX
[  122.563208] tg3 0000:02:00.0: eth0: EEE is disabled
[  122.563986] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  122.711291] wlan0: send auth to c0:c1:c0:45:40:dd (try 2/3)
[  122.914989] wlan0: send auth to c0:c1:c0:45:40:dd (try 3/3)
[  123.118674] wlan0: authentication with c0:c1:c0:45:40:dd timed out
[  129.363968] wlan0: authenticate with c0:c1:c0:45:40:dd
[  129.373734] wlan0: direct probe to c0:c1:c0:45:40:dd (try 1/3)
[  129.577211] wlan0: direct probe to c0:c1:c0:45:40:dd (try 2/3)
[  129.780908] wlan0: direct probe to c0:c1:c0:45:40:dd (try 3/3)
[  129.984577] wlan0: authentication with c0:c1:c0:45:40:dd timed out
[  132.740880] eth0: no IPv6 routers present
[  136.138612] wlan0: authenticate with c0:c1:c0:45:40:dd
[  136.150024] wlan0: direct probe to c0:c1:c0:45:40:dd (try 1/3)
[  136.353442] wlan0: direct probe to c0:c1:c0:45:40:dd (try 2/3)
[  136.557242] wlan0: direct probe to c0:c1:c0:45:40:dd (try 3/3)
[  136.761037] wlan0: authentication with c0:c1:c0:45:40:dd timed out
[  142.903974] wlan0: authenticate with c0:c1:c0:45:40:dd
[  142.915214] wlan0: direct probe to c0:c1:c0:45:40:dd (try 1/3)
[  143.118831] wlan0: direct probe to c0:c1:c0:45:40:dd (try 2/3)
[  143.322632] wlan0: direct probe to c0:c1:c0:45:40:dd (try 3/3)
[  143.526413] wlan0: authentication with c0:c1:c0:45:40:dd timed out
[  149.697180] wlan0: authenticate with c0:c1:c0:45:40:dd
[  149.708847] wlan0: direct probe to c0:c1:c0:45:40:dd (try 1/3)
[  149.912275] wlan0: direct probe to c0:c1:c0:45:40:dd (try 2/3)
[  150.116078] wlan0: direct probe to c0:c1:c0:45:40:dd (try 3/3)
[  150.319891] wlan0: authentication with c0:c1:c0:45:40:dd timed out
[  156.462878] wlan0: authenticate with c0:c1:c0:45:40:dd
[  156.474364] wlan0: direct probe to c0:c1:c0:45:40:dd (try 1/3)
[  156.677656] wlan0: direct probe to c0:c1:c0:45:40:dd (try 2/3)
[  156.881508] wlan0: direct probe to c0:c1:c0:45:40:dd (try 3/3)
[  157.085313] wlan0: authentication with c0:c1:c0:45:40:dd timed out
[  163.236250] wlan0: authenticate with c0:c1:c0:45:40:dd
[  163.247714] wlan0: direct probe to c0:c1:c0:45:40:dd (try 1/3)
[  163.451113] wlan0: direct probe to c0:c1:c0:45:40:dd (try 2/3)
[  163.654934] wlan0: direct probe to c0:c1:c0:45:40:dd (try 3/3)
[  163.858682] wlan0: authentication with c0:c1:c0:45:40:dd timed out

--ReaqsoxgOBHFXBhH--

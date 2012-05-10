Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slush.shore.mbari.org ([134.89.12.31]:48393 "EHLO
	slush.shore.mbari.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab2EJSKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 14:10:42 -0400
Message-ID: <4FAC0496.4090804@mbari.org> (sfid-20120510_201050_173516_318EE8F7)
Date: Thu, 10 May 2012 11:10:30 -0700
From: Brent Roman <brent@mbari.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: After Kernel 3.3, brcmsmac won't work on mid-2010 Mac Mini
References: <4FA9A8FE.5000102@mbari.org> <4FAA1BEF.10704@broadcom.com> <4FAB0E12.7020006@mbari.org> <4FABA007.2080203@broadcom.com>
In-Reply-To: <4FABA007.2080203@broadcom.com>
Content-Type: multipart/mixed;
 boundary="------------060700080404050808050506"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060700080404050808050506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Arend,

Strangely, when I rebooted the box under 3.3.5 this time, the WiFi worked!
I will post again if it drops out.

For reference, here are the files you requested.

- brent


Arend van Spriel wrote:
> On 05/10/2012 02:38 AM, Brent Roman wrote:
>> Thanks for the quick response.
>>
>> I've not blacklisted bcma for either 3.2 or 3.3 kernels.
>> Yes, I built the kernels myself.  The mac mini runs a Debian Mint 11.
>> The brcmsmac driver in 3.3 seems to have dependencies on bcma, It won't
>> load without it.
>> When I reverte to 3.2.16, I just unconfigured the bcma driver, so it
>> never built.
>> the kernel .config for 3.2 and 3.3 are attached.
>> Let me know if you need me to reboot the box with the 3.3 kernel and
>> post dmesg or other logs.
>>
>> - brent
>>
>>
> The kernel configurations you sent me look fine. I noticed you have
> debugging enabled for bcma and brcmsmac so can you sent me a dmesg for
> the 3.3 kernel. lspci should show bcma as the driver for the device.
> Unfortunately, there is no lsbcma.
>
> Gr. AvS
>



--------------060700080404050808050506
Content-Type: text/plain;
 name="linux-3.3.5-mpc89mac4gb.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linux-3.3.5-mpc89mac4gb.dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.5-mpc89mac4gb-gcc4.6 (brent@pippin) (gcc version 4.6.1 (Debian 4.6.1-4) ) #5 SMP Mon May 7 18:12:50 PDT 2012
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 0000000000090000 (reserved)
[    0.000000]  BIOS-e820: 0000000000090000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000af000000 (usable)
[    0.000000]  BIOS-e820: 00000000af000000 - 00000000bf000000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf000000 - 00000000bf70f000 (usable)
[    0.000000]  BIOS-e820: 00000000bf70f000 - 00000000bf930000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf930000 - 00000000bf931000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf931000 - 00000000bf939000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf939000 - 00000000bfef9000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfef9000 - 00000000bfeff000 (reserved)
[    0.000000]  BIOS-e820: 00000000bfeff000 - 00000000bff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000d3500000 - 00000000d3501000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Apple Inc. Macmini4,1/Mac-F2208EC8, BIOS     MM41.88Z.0042.B00.1004221740 04/22/10
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0xbf70f max_arch_pfn = 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 0BFF00000 mask FFFF00000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 17fb000-1800000
[    0.000000] ACPI: RSDP 000fe020 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT bf96a1c0 00084 (v01 APPLE   Apple00 00000042      01000013)
[    0.000000] ACPI: FACP bf968000 000F4 (v04 APPLE   Apple00 00000042 Loki 0000005F)
[    0.000000] ACPI: DSDT bf95b000 054A1 (v01 APPLE   Macmini 00040001 INTL 20061109)
[    0.000000] ACPI: FACS bf71e000 00040
[    0.000000] ACPI: HPET bf967000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC bf966000 00068 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC bf965000 00068 (v02 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ASF! bf963000 000A5 (v32 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SBST bf962000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT bf961000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT bf957000 00024 (v01 APPLE     Apple 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT bf956000 004DC (v01  APPLE    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: MCFG bf964000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT bf95a000 000A5 (v01 SataRe  SataPri 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT bf959000 0009F (v01 SataRe  SataSec 00001000 INTL 20061109)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2175MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x000bf70f
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000008f
[    0.000000]     0: 0x00000090 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000af000
[    0.000000]     0: 0x000bf000 -> 0x000bf70f
[    0.000000] On node 0 totalpages: 718493
[    0.000000] free_area_init_node: node 0, pgdat c13f4940, node_mem_map f600d200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3950 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4351 pages used for memmap
[    0.000000]   HighMem zone: 486930 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000008f000 - 0000000000090000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at d3501000 (gap: d3501000:1caff000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @f5800000 s24384 r0 d20672 u2097152
[    0.000000] pcpu-alloc: s24384 r0 d20672 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 712366
[    0.000000] Kernel command line: BOOT_IMAGE=debMintTxt4gNew ro root=804 reboot=pci resume=/dev/sda5 single
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Initializing HighMem for node 0 (000377fe:000bf70f)
[    0.000000] Memory: 2843788k/3136572k available (2845k kernel code, 30184k reserved, 1223k data, 308k init, 1965124k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff67000 - 0xfffff000   ( 608 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc13fa000 - 0xc1447000   ( 308 kB)
[    0.000000]       .data : 0xc12c779b - 0xc13f94c0   (1223 kB)
[    0.000000]       .text : 0xc1000000 - 0xc12c779b   (2845 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=f5408000 soft=f540a000
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2389.177 MHz processor.
[    0.004001] Calibrating delay loop (skipped), value calculated using timer frequency.. 4778.35 BogoMIPS (lpj=9556708)
[    0.004137] pid_max: default: 32768 minimum: 301
[    0.004230] Mount-cache hash table entries: 512
[    0.008014] Initializing cgroup subsys cpuacct
[    0.008080] Initializing cgroup subsys devices
[    0.008145] Initializing cgroup subsys freezer
[    0.008211] Initializing cgroup subsys net_cls
[    0.008292] CPU: Physical Processor ID: 0
[    0.008355] CPU: Processor Core ID: 0
[    0.008420] mce: CPU supports 6 MCE banks
[    0.008489] CPU0: Thermal monitoring enabled (TM2)
[    0.008556] using mwait in idle threads.
[    0.008678] ACPI: Core revision 20120111
[    0.012566] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.013089] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.052849] CPU0: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz stepping 0a
[    0.056003] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.056003] ... version:                2
[    0.056003] ... bit width:              40
[    0.056003] ... generic registers:      2
[    0.056003] ... value mask:             000000ffffffffff
[    0.056003] ... max period:             000000007fffffff
[    0.056003] ... fixed-purpose events:   3
[    0.056003] ... event mask:             0000000700000003
[    0.056003] NMI watchdog enabled, takes one hw-pmu counter.
[    0.056003] CPU 1 irqstacks, hard=f54a0000 soft=f54a2000
[    0.056003] Booting Node   0, Processors  #1 Ok.
[    0.056003] smpboot cpu 1: start_ip = 9b000
[    0.008000] Initializing CPU#1
[    0.068026] NMI watchdog enabled, takes one hw-pmu counter.
[    0.068179] Brought up 2 CPUs
[    0.068242] Total of 2 processors activated (9556.70 BogoMIPS).
[    0.070013] devtmpfs: initialized
[    0.070013] PM: Registering ACPI NVS region at bf70f000 (2232320 bytes)
[    0.070013] PM: Registering ACPI NVS region at bf931000 (32768 bytes)
[    0.070013] NET: Registered protocol family 16
[    0.070013] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.070013] ACPI: bus type pci registered
[    0.070013] PCI: MMCONFIG for domain 0000 [bus 00-05] at [mem 0xf0000000-0xf05fffff] (base 0xf0000000)
[    0.070013] PCI: MMCONFIG at [mem 0xf0000000-0xf05fffff] reserved in E820
[    0.070013] PCI: Using MMCONFIG for extended config space
[    0.070013] PCI: Using configuration type 1 for base access
[    0.072040] bio: create slab <bio-0> at 0
[    0.072103] ACPI: Added _OSI(Module Device)
[    0.072103] ACPI: Added _OSI(Processor Device)
[    0.072164] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.072230] ACPI: Added _OSI(Processor Aggregator Device)
[    0.073380] ACPI: EC: EC description table is found, configuring boot EC
[    0.080664] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.081025] ACPI: SSDT bf71dc98 00238 (v01  APPLE  Cpu0Ist 00003000 INTL 20061109)
[    0.081426] ACPI: Dynamic OEM Table Load:
[    0.081565] ACPI: SSDT   (null) 00238 (v01  APPLE  Cpu0Ist 00003000 INTL 20061109)
[    0.081845] ACPI: SSDT bf71c618 005A6 (v01  APPLE  Cpu0Cst 00003001 INTL 20061109)
[    0.082233] ACPI: Dynamic OEM Table Load:
[    0.082371] ACPI: SSDT   (null) 005A6 (v01  APPLE  Cpu0Cst 00003001 INTL 20061109)
[    0.082545] ACPI: SSDT bf71df18 000C8 (v01  APPLE  Cpu1Ist 00003000 INTL 20061109)
[    0.082545] ACPI: Dynamic OEM Table Load:
[    0.082545] ACPI: SSDT   (null) 000C8 (v01  APPLE  Cpu1Ist 00003000 INTL 20061109)
[    0.082545] ACPI: SSDT bf71bf18 00085 (v01  APPLE  Cpu1Cst 00003000 INTL 20061109)
[    0.082545] ACPI: Dynamic OEM Table Load:
[    0.084060] ACPI: SSDT   (null) 00085 (v01  APPLE  Cpu1Cst 00003000 INTL 20061109)
[    0.084233] ACPI: Interpreter enabled
[    0.084233] ACPI: (supports S0 S3 S4 S5)
[    0.084460] ACPI: Using IOAPIC for interrupt routing
[    0.089130] ACPI: EC: GPE = 0x57, I/O: command/status = 0x66, data = 0x62
[    0.089220] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.089438] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.089583] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.089654] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.089725] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.089814] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000c3fff]
[    0.089904] pci_root PNP0A08:00: host bridge window [mem 0x000c4000-0x000c7fff]
[    0.089993] pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x000cbfff]
[    0.090082] pci_root PNP0A08:00: host bridge window [mem 0x000cc000-0x000cffff]
[    0.090172] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    0.090261] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.090350] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.090439] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
[    0.090529] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
[    0.090618] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff]
[    0.090707] pci_root PNP0A08:00: host bridge window [mem 0x000e8000-0x000ebfff]
[    0.090797] pci_root PNP0A08:00: host bridge window [mem 0x000ec000-0x000effff]
[    0.090886] pci_root PNP0A08:00: host bridge window [mem 0x000f0000-0x000fffff]
[    0.090975] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfebfffff]
[    0.091094] PCI host bridge to bus 0000:00
[    0.091159] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.091228] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.091298] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.091369] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    0.091440] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    0.091511] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    0.091582] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    0.091653] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.091724] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.091795] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.091867] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.091938] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.092007] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.092078] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    0.092149] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    0.092220] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    0.092291] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
[    0.092377] pci 0000:00:00.0: [10de:0d60] type 0 class 0x000600
[    0.092491] pci 0000:00:00.1: [10de:0d68] type 0 class 0x000500
[    0.092661] pci 0000:00:01.0: [10de:0d6d] type 0 class 0x000500
[    0.092824] pci 0000:00:01.1: [10de:0d6e] type 0 class 0x000500
[    0.092987] pci 0000:00:01.2: [10de:0d6f] type 0 class 0x000500
[    0.093150] pci 0000:00:01.3: [10de:0d70] type 0 class 0x000500
[    0.093318] pci 0000:00:02.0: [10de:0d71] type 0 class 0x000500
[    0.093481] pci 0000:00:02.1: [10de:0d72] type 0 class 0x000500
[    0.093643] pci 0000:00:03.0: [10de:0d80] type 0 class 0x000601
[    0.093652] pci 0000:00:03.0: reg 10: [io  0x2100-0x21ff]
[    0.093697] pci 0000:00:03.1: [10de:0d7b] type 0 class 0x000500
[    0.093779] pci 0000:00:03.2: [10de:0d79] type 0 class 0x000c05
[    0.093793] pci 0000:00:03.2: reg 10: [io  0x0000-0x00ff]
[    0.093815] pci 0000:00:03.2: reg 20: [io  0x2240-0x227f]
[    0.093821] pci 0000:00:03.2: reg 24: [io  0x2200-0x223f]
[    0.093856] pci 0000:00:03.2: PME# supported from D3hot D3cold
[    0.093883] pci 0000:00:03.3: [10de:0d69] type 0 class 0x000500
[    0.094087] pci 0000:00:03.4: [10de:0d7a] type 0 class 0x000b40
[    0.094107] pci 0000:00:03.4: reg 10: [mem 0xd3500000-0xd357ffff]
[    0.094249] pci 0000:00:04.0: [10de:0d9c] type 0 class 0x000c03
[    0.094261] pci 0000:00:04.0: reg 10: [mem 0xd358a000-0xd358afff]
[    0.094309] pci 0000:00:04.0: supports D1 D2
[    0.094311] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.094326] pci 0000:00:04.1: [10de:0d9d] type 0 class 0x000c03
[    0.094340] pci 0000:00:04.1: reg 10: [mem 0xd358b100-0xd358b1ff]
[    0.094397] pci 0000:00:04.1: supports D1 D2
[    0.094399] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.094422] pci 0000:00:06.0: [10de:0d9c] type 0 class 0x000c03
[    0.094433] pci 0000:00:06.0: reg 10: [mem 0xd3589000-0xd3589fff]
[    0.094481] pci 0000:00:06.0: supports D1 D2
[    0.094483] pci 0000:00:06.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.094499] pci 0000:00:06.1: [10de:0d9d] type 0 class 0x000c03
[    0.094512] pci 0000:00:06.1: reg 10: [mem 0xd358b000-0xd358b0ff]
[    0.094569] pci 0000:00:06.1: supports D1 D2
[    0.094571] pci 0000:00:06.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.094600] pci 0000:00:08.0: [10de:0d94] type 0 class 0x000403
[    0.094614] pci 0000:00:08.0: reg 10: [mem 0xd3580000-0xd3583fff]
[    0.094673] pci 0000:00:08.0: PME# supported from D3hot D3cold
[    0.094692] pci 0000:00:0a.0: [10de:0d85] type 0 class 0x000101
[    0.094704] pci 0000:00:0a.0: reg 10: [io  0x2298-0x229f]
[    0.094710] pci 0000:00:0a.0: reg 14: [io  0x22a4-0x22a7]
[    0.094715] pci 0000:00:0a.0: reg 18: [io  0x2290-0x2297]
[    0.094721] pci 0000:00:0a.0: reg 1c: [io  0x22a0-0x22a3]
[    0.094727] pci 0000:00:0a.0: reg 20: [io  0x2280-0x228f]
[    0.094733] pci 0000:00:0a.0: reg 24: [mem 0xd3584000-0xd3585fff]
[    0.094776] pci 0000:00:0b.0: [10de:0d75] type 0 class 0x000500
[    0.094789] pci 0000:00:0b.0: reg 10: [mem 0xd3588000-0xd3588fff]
[    0.094905] pci 0000:00:0e.0: [10de:0d9a] type 1 class 0x000604
[    0.095172] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.095285] pci 0000:00:15.0: [10de:0d9b] type 1 class 0x000604
[    0.095552] pci 0000:00:15.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.095658] pci 0000:00:16.0: [10de:0d9b] type 1 class 0x000604
[    0.095924] pci 0000:00:16.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.095983] pci 0000:00:17.0: [10de:0d76] type 1 class 0x000604
[    0.096043] pci 0000:00:17.0: PME# supported from D0 D3hot D3cold
[    0.096255] pci 0000:01:00.0: [104c:823e] type 1 class 0x000604
[    0.096362] pci 0000:01:00.0: supports D1 D2
[    0.104025] pci 0000:00:0e.0: PCI bridge to [bus 01-02]
[    0.104113] pci 0000:00:0e.0:   bridge window [mem 0xd3400000-0xd34fffff]
[    0.104205] pci 0000:02:00.0: [104c:823f] type 0 class 0x000c00
[    0.104228] pci 0000:02:00.0: reg 10: [mem 0xd3404000-0xd34047ff]
[    0.104242] pci 0000:02:00.0: reg 14: [mem 0xd3400000-0xd3403fff]
[    0.104336] pci 0000:02:00.0: supports D1 D2
[    0.104338] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot
[    0.104399] pci 0000:01:00.0: PCI bridge to [bus 02-02]
[    0.104475] pci 0000:01:00.0:   bridge window [mem 0xd3400000-0xd34fffff]
[    0.104715] pci 0000:03:00.0: [14e4:4353] type 0 class 0x000280
[    0.104735] pci 0000:03:00.0: reg 10: [mem 0xd3300000-0xd3303fff 64bit]
[    0.104836] pci 0000:03:00.0: supports D1 D2
[    0.104837] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.104896] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.104983] pci 0000:00:15.0:   bridge window [mem 0xd3300000-0xd33fffff]
[    0.105194] pci 0000:04:00.0: [14e4:16b4] type 0 class 0x000200
[    0.105214] pci 0000:04:00.0: reg 10: [mem 0xd3100000-0xd310ffff 64bit pref]
[    0.105231] pci 0000:04:00.0: reg 18: [mem 0xd3110000-0xd311ffff 64bit pref]
[    0.105315] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.105358] pci 0000:04:00.1: [14e4:16bc] type 0 class 0x000805
[    0.105379] pci 0000:04:00.1: reg 10: [mem 0xd3120000-0xd312ffff 64bit pref]
[    0.105474] pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
[    0.112029] pci 0000:00:16.0: PCI bridge to [bus 04-04]
[    0.112117] pci 0000:00:16.0:   bridge window [mem 0xd3200000-0xd32fffff]
[    0.112132] pci 0000:00:16.0:   bridge window [mem 0xd3100000-0xd31fffff 64bit pref]
[    0.112166] pci 0000:05:00.0: [10de:08a4] type 0 class 0x000300
[    0.112178] pci 0000:05:00.0: reg 10: [mem 0xd2000000-0xd2ffffff]
[    0.112186] pci 0000:05:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.112195] pci 0000:05:00.0: reg 1c: [mem 0xd0000000-0xd1ffffff 64bit pref]
[    0.112201] pci 0000:05:00.0: reg 24: [io  0x1000-0x107f]
[    0.112207] pci 0000:05:00.0: reg 30: [mem 0xd3000000-0xd301ffff pref]
[    0.112253] pci 0000:00:17.0: PCI bridge to [bus 05-05]
[    0.112322] pci 0000:00:17.0:   bridge window [io  0x1000-0x1fff]
[    0.112325] pci 0000:00:17.0:   bridge window [mem 0xd2000000-0xd30fffff]
[    0.112330] pci 0000:00:17.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
[    0.112373] pci_bus 0000:00: on NUMA node 0
[    0.112377] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.112602] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IXVE._PRT]
[    0.112710]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.112917]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.131446] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.132066] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.132676] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.133282] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.133888] ACPI: PCI Interrupt Link [Z00B] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.134494] ACPI: PCI Interrupt Link [Z00C] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.135101] ACPI: PCI Interrupt Link [Z00D] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.135707] ACPI: PCI Interrupt Link [Z00E] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.136303] ACPI: PCI Interrupt Link [Z00J] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.136909] ACPI: PCI Interrupt Link [Z00K] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.137516] ACPI: PCI Interrupt Link [Z00L] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.138122] ACPI: PCI Interrupt Link [Z00M] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.138729] ACPI: PCI Interrupt Link [Z00N] (IRQs 16 17 18 19 20 21 22 23) *11
[    0.139297] ACPI: PCI Interrupt Link [Z00O] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.139903] ACPI: PCI Interrupt Link [Z00P] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.140530] ACPI: PCI Interrupt Link [Z00Q] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.141136] ACPI: PCI Interrupt Link [LSMB] (IRQs 16 17 18 19 20 21 22 23) *15
[    0.141703] ACPI: PCI Interrupt Link [LUS0] (IRQs 16 17 18 19 20 21 22 23) *11
[    0.142270] ACPI: PCI Interrupt Link [LUS2] (IRQs 16 17 18 19 20 21 22 23) *10
[    0.142842] ACPI: PCI Interrupt Link [LMAC] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.143448] ACPI: PCI Interrupt Link [LAZA] (IRQs 16 17 18 19 20 21 22 23) *15
[    0.144038] ACPI: PCI Interrupt Link [LGPU] (IRQs 16 17 18 19 20 21 22 23) *5
[    0.144588] ACPI: PCI Interrupt Link [LPID] (IRQs 16 17 18 19 20 21 22 23) *0, disabled.
[    0.145194] ACPI: PCI Interrupt Link [LSI0] (IRQs 16 17 18 19 20 21 22 23) *11
[    0.145765] ACPI: PCI Interrupt Link [Z000] (IRQs 16 17 18 19 20 21 22 23) *7
[    0.146318] ACPI: PCI Interrupt Link [Z001] (IRQs 16 17 18 19 20 21 22 23) *5
[    0.146872] ACPI: PCI Interrupt Link [LPMU] (IRQs 16 17 18 19 20 21 22 23) *14
[    0.147413] vgaarb: device added: PCI:0000:05:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.147413] vgaarb: loaded
[    0.147413] vgaarb: bridge control possible 0000:05:00.0
[    0.147413] SCSI subsystem initialized
[    0.147413] libata version 3.00 loaded.
[    0.147413] usbcore: registered new interface driver usbfs
[    0.147413] usbcore: registered new interface driver hub
[    0.148017] usbcore: registered new device driver usb
[    0.148113] PCI: Using ACPI for IRQ routing
[    0.148179] PCI: pci_cache_line_size set to 64 bytes
[    0.148325] reserve RAM buffer: 000000000008f000 - 000000000008ffff 
[    0.148327] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.148329] reserve RAM buffer: 00000000af000000 - 00000000afffffff 
[    0.148331] reserve RAM buffer: 00000000bf70f000 - 00000000bfffffff 
[    0.148420] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.148497] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31, 31
[    0.148751] hpet0: 4 comparators, 64-bit 25.000000 MHz counter
[    0.152024] Switching to clocksource hpet
[    0.152123] pnp: PnP ACPI init
[    0.152191] ACPI: bus type pnp registered
[    0.152314] pnp 00:00: [bus 00-ff]
[    0.152316] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.152318] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.152321] pnp 00:00: [io  0x0d00-0xffff window]
[    0.152323] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.152325] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.152327] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.152329] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.152331] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.152333] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.152335] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.152337] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.152339] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.152341] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.152343] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.152345] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.152347] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.152349] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.152351] pnp 00:00: [mem 0xc0000000-0xfebfffff window]
[    0.152392] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.152410] pnp 00:01: [mem 0x00000000-0xffffffff disabled]
[    0.152412] pnp 00:01: [mem 0xf0000000-0xf3ffffff]
[    0.152450] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.152522] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.152533] pnp 00:02: [io  0x0300-0x031f]
[    0.152540] pnp 00:02: [irq 6]
[    0.152559] pnp 00:02: Plug and Play ACPI device, IDs APP0001 (active)
[    0.152570] pnp 00:03: [io  0x0000-0x0008]
[    0.152572] pnp 00:03: [io  0x000a-0x000f]
[    0.152574] pnp 00:03: [io  0x0081-0x0083]
[    0.152576] pnp 00:03: [io  0x0087]
[    0.152577] pnp 00:03: [io  0x0089-0x008b]
[    0.152583] pnp 00:03: [io  0x008f]
[    0.152584] pnp 00:03: [io  0x00c0-0x00d1]
[    0.152586] pnp 00:03: [io  0x00d4-0x00df]
[    0.152588] pnp 00:03: [dma 4]
[    0.152606] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.152673] pnp 00:04: [irq 0 disabled]
[    0.152678] pnp 00:04: [irq 8]
[    0.152680] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.152718] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.152790] system 00:04: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.152802] pnp 00:05: [io  0x00f0-0x00f1]
[    0.152807] pnp 00:05: [irq 13]
[    0.152829] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.152928] pnp 00:06: [io  0x0400-0x047f]
[    0.152930] pnp 00:06: [io  0x0480-0x04ff]
[    0.152932] pnp 00:06: [io  0x0500-0x057f]
[    0.152934] pnp 00:06: [io  0x0580-0x05ff]
[    0.152935] pnp 00:06: [io  0x0800-0x087f]
[    0.152937] pnp 00:06: [io  0x0880-0x08ff]
[    0.152939] pnp 00:06: [io  0x0010-0x001f]
[    0.152940] pnp 00:06: [io  0x0022-0x003f]
[    0.152942] pnp 00:06: [io  0x0044-0x005f]
[    0.152944] pnp 00:06: [io  0x0063]
[    0.152945] pnp 00:06: [io  0x0065]
[    0.152947] pnp 00:06: [io  0x0067-0x006f]
[    0.152948] pnp 00:06: [io  0x0072-0x0073]
[    0.152950] pnp 00:06: [io  0x0074-0x007f]
[    0.152952] pnp 00:06: [io  0x0091-0x0093]
[    0.152953] pnp 00:06: [io  0x0097-0x009f]
[    0.152955] pnp 00:06: [io  0x00a2-0x00bf]
[    0.152957] pnp 00:06: [io  0x00e0-0x00ef]
[    0.152958] pnp 00:06: [io  0x04d0-0x04d1]
[    0.152960] pnp 00:06: [io  0x0080]
[    0.152962] pnp 00:06: [io  0x0295-0x0296]
[    0.152972] pnp 00:06: disabling [io  0x0010-0x001f] because it overlaps 0000:00:03.2 BAR 0 [io  0x0000-0x00ff]
[    0.153068] pnp 00:06: disabling [io  0x0022-0x003f] because it overlaps 0000:00:03.2 BAR 0 [io  0x0000-0x00ff]
[    0.153165] pnp 00:06: disabling [io  0x0044-0x005f] because it overlaps 0000:00:03.2 BAR 0 [io  0x0000-0x00ff]
[    0.153261] pnp 00:06: disabling [io  0x0063] because it overlaps 0000:00:03.2 BAR 0 [io  0x0000-0x00ff]
[    0.153356] pnp 00:06: disabling [io  0x0065] because it overlaps 0000:00:03.2 BAR 0 [io  0x0000-0x00ff]
[    0.153451] pnp 00:06: disabling [io  0x0067-0x006f] because it overlaps 0000:00:03.2 BAR 0 [io  0x0000-0x00ff]
[    0.153547] pnp 00:06: disabling [io  0x0072-0x0073] because it overlaps 0000:00:03.2 BAR 0 [io  0x0000-0x00ff]
[    0.153644] pnp 00:06: disabling [io  0x0074-0x007f] because it overlaps 0000:00:03.2 BAR 0 [io  0x0000-0x00ff]
[    0.153740] pnp 00:06: disabling [io  0x0091-0x0093] because it overlaps 0000:00:03.2 BAR 0 [io  0x0000-0x00ff]
[    0.153836] pnp 00:06: disabling [io  0x0097-0x009f] because it overlaps 0000:00:03.2 BAR 0 [io  0x0000-0x00ff]
[    0.153933] pnp 00:06: disabling [io  0x00a2-0x00bf] because it overlaps 0000:00:03.2 BAR 0 [io  0x0000-0x00ff]
[    0.154029] pnp 00:06: disabling [io  0x00e0-0x00ef] because it overlaps 0000:00:03.2 BAR 0 [io  0x0000-0x00ff]
[    0.154126] pnp 00:06: disabling [io  0x0080] because it overlaps 0000:00:03.2 BAR 0 [io  0x0000-0x00ff]
[    0.154257] system 00:06: [io  0x0400-0x047f] has been reserved
[    0.159064] system 00:06: [io  0x0480-0x04ff] has been reserved
[    0.159134] system 00:06: [io  0x0500-0x057f] has been reserved
[    0.159203] system 00:06: [io  0x0580-0x05ff] has been reserved
[    0.159272] system 00:06: [io  0x0800-0x087f] has been reserved
[    0.159341] system 00:06: [io  0x0880-0x08ff] has been reserved
[    0.159411] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.159480] system 00:06: [io  0x0295-0x0296] has been reserved
[    0.159550] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.159558] pnp 00:07: [io  0x0070-0x0077]
[    0.159579] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.160043] pnp: PnP ACPI: found 8 devices
[    0.160108] ACPI: ACPI bus type pnp unregistered
[    0.196647] PCI: max bus depth: 2 pci_try_num: 3
[    0.196727] pci 0000:00:03.2: BAR 0: assigned [io  0x2000-0x20ff]
[    0.196799] pci 0000:01:00.0: PCI bridge to [bus 02-02]
[    0.196871] pci 0000:01:00.0:   bridge window [mem 0xd3400000-0xd34fffff]
[    0.196950] pci 0000:00:0e.0: PCI bridge to [bus 01-02]
[    0.197027] pci 0000:00:0e.0:   bridge window [mem 0xd3400000-0xd34fffff]
[    0.197116] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.197192] pci 0000:00:15.0:   bridge window [mem 0xd3300000-0xd33fffff]
[    0.197282] pci 0000:00:16.0: PCI bridge to [bus 04-04]
[    0.197358] pci 0000:00:16.0:   bridge window [mem 0xd3200000-0xd32fffff]
[    0.197435] pci 0000:00:16.0:   bridge window [mem 0xd3100000-0xd31fffff 64bit pref]
[    0.197538] pci 0000:00:17.0: PCI bridge to [bus 05-05]
[    0.197606] pci 0000:00:17.0:   bridge window [io  0x1000-0x1fff]
[    0.197677] pci 0000:00:17.0:   bridge window [mem 0xd2000000-0xd30fffff]
[    0.197749] pci 0000:00:17.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
[    0.197972] ACPI: PCI Interrupt Link [Z00B] enabled at IRQ 23
[    0.198075] pci 0000:00:15.0: power state changed by ACPI to D0
[    0.198149] pci 0000:00:15.0: power state changed by ACPI to D0
[    0.198338] ACPI: PCI Interrupt Link [Z00J] enabled at IRQ 22
[    0.198533] ACPI: PCI Interrupt Link [Z00N] enabled at IRQ 21
[    0.198613] pci 0000:00:17.0: setting latency timer to 64
[    0.198616] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.198618] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.198620] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.198623] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.198625] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.198627] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.198629] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    0.198631] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    0.198633] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    0.198635] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    0.198637] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    0.198639] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
[    0.198641] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
[    0.198643] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
[    0.198645] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
[    0.198648] pci_bus 0000:00: resource 19 [mem 0x000f0000-0x000fffff]
[    0.198650] pci_bus 0000:00: resource 20 [mem 0xc0000000-0xfebfffff]
[    0.198652] pci_bus 0000:01: resource 1 [mem 0xd3400000-0xd34fffff]
[    0.198654] pci_bus 0000:02: resource 1 [mem 0xd3400000-0xd34fffff]
[    0.198656] pci_bus 0000:03: resource 1 [mem 0xd3300000-0xd33fffff]
[    0.198658] pci_bus 0000:04: resource 1 [mem 0xd3200000-0xd32fffff]
[    0.198661] pci_bus 0000:04: resource 2 [mem 0xd3100000-0xd31fffff 64bit pref]
[    0.198663] pci_bus 0000:05: resource 0 [io  0x1000-0x1fff]
[    0.198665] pci_bus 0000:05: resource 1 [mem 0xd2000000-0xd30fffff]
[    0.198667] pci_bus 0000:05: resource 2 [mem 0xc0000000-0xd1ffffff 64bit pref]
[    0.198691] NET: Registered protocol family 2
[    0.198801] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.199032] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.199417] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.199629] TCP: Hash tables configured (established 131072 bind 65536)
[    0.199700] TCP reno registered
[    0.199763] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.199837] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.199950] NET: Registered protocol family 1
[    0.200158] pci 0000:00:04.0: power state changed by ACPI to D0
[    0.200230] pci 0000:00:04.0: power state changed by ACPI to D0
[    0.200422] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 20
[    0.272043] pci 0000:00:04.1: power state changed by ACPI to D0
[    0.272115] pci 0000:00:04.1: power state changed by ACPI to D0
[    0.272299] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 19
[    0.272407] pci 0000:00:06.0: power state changed by ACPI to D0
[    0.272478] pci 0000:00:06.0: power state changed by ACPI to D0
[    0.272662] ACPI: PCI Interrupt Link [Z000] enabled at IRQ 18
[    0.328042] pci 0000:00:06.1: power state changed by ACPI to D0
[    0.328114] pci 0000:00:06.1: power state changed by ACPI to D0
[    0.328297] ACPI: PCI Interrupt Link [Z001] enabled at IRQ 17
[    0.328575] PCI: CLS mismatch (256 != 64), using 64 bytes
[    0.328586] pci 0000:05:00.0: Boot video device
[    0.329129] highmem bounce pool size: 64 pages
[    0.331021] VFS: Disk quotas dquot_6.5.2
[    0.331130] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.331544] msgmni has been set to 1716
[    0.331793] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.331883] io scheduler noop registered
[    0.331947] io scheduler deadline registered
[    0.332034] io scheduler cfq registered (default)
[    0.332365] pcieport 0000:00:0e.0: irq 40 for MSI/MSI-X
[    0.332675] pcieport 0000:00:15.0: irq 41 for MSI/MSI-X
[    0.332981] pcieport 0000:00:16.0: irq 42 for MSI/MSI-X
[    0.333181] pcieport 0000:00:0e.0: Signaling PME through PCIe PME interrupt
[    0.333253] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.333323] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    0.333400] pcie_pme 0000:00:0e.0:pcie01: service driver pcie_pme loaded
[    0.333437] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
[    0.333508] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.333585] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    0.333622] pcieport 0000:00:16.0: Signaling PME through PCIe PME interrupt
[    0.333693] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    0.333763] pci 0000:04:00.1: Signaling PME through PCIe PME interrupt
[    0.333840] pcie_pme 0000:00:16.0:pcie01: service driver pcie_pme loaded
[    0.333896] intel_idle: MWAIT substates: 0x3122220
[    0.333898] intel_idle: does not run on family 6 model 23
[    0.333968] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.334062] ACPI: Power Button [PWRB]
[    0.334166] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.334258] ACPI: Sleep Button [SLPB]
[    0.334367] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.334457] ACPI: Power Button [PWRF]
[    0.334677] Monitor-Mwait will be used to enter C-1 state
[    0.334706] Monitor-Mwait will be used to enter C-2 state
[    0.334730] Monitor-Mwait will be used to enter C-3 state
[    0.334738] Marking TSC unstable due to TSC halts in idle
[    0.334817] ACPI: acpi_idle registered with cpuidle
[    0.336466] Linux agpgart interface v0.103
[    0.336618] ahci 0000:00:0a.0: version 3.0
[    0.336683] ata_generic 0000:00:0a.0: power state changed by ACPI to D0
[    0.336755] ata_generic 0000:00:0a.0: power state changed by ACPI to D0
[    0.336946] ACPI: PCI Interrupt Link [LSI0] enabled at IRQ 16
[    0.337043] ata_generic 0000:00:0a.0: setting latency timer to 64
[    0.337260] scsi0 : ata_generic
[    0.337389] scsi1 : ata_generic
[    0.337558] ata1: PATA max UDMA/100 cmd 0x2298 ctl 0x22a4 bmdma 0x2280 irq 16
[    0.337631] ata2: PATA max UDMA/100 cmd 0x2290 ctl 0x22a0 bmdma 0x2288 irq 16
[    0.337738] tg3.c:v3.122 (December 7, 2011)
[    0.348157] tg3 0000:04:00.0: eth0: Tigon3 [partno(BCM957765) rev 57785000] (PCI Express) MAC address c4:2c:03:1d:1e:1e
[    0.348257] tg3 0000:04:00.0: eth0: attached PHY is 57765 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    0.348353] tg3 0000:04:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    0.348444] tg3 0000:04:00.0: eth0: dma_rwctrl[00000001] dma_mask[64-bit]
[    0.348578] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.348660] ehci_hcd 0000:00:04.1: power state changed by ACPI to D0
[    0.348731] ehci_hcd 0000:00:04.1: power state changed by ACPI to D0
[    0.348812] ehci_hcd 0000:00:04.1: setting latency timer to 64
[    0.348815] ehci_hcd 0000:00:04.1: EHCI Host Controller
[    0.348887] ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 1
[    0.348989] ehci_hcd 0000:00:04.1: disable lpm/ppcd for nvidia mcp89
[    0.349046] ehci_hcd 0000:00:04.1: debug port 1
[    0.372017] ehci_hcd 0000:00:04.1: cache line size of 64 is not supported
[    0.372031] ehci_hcd 0000:00:04.1: irq 19, io mem 0xd358b100
[    0.384014] ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.10
[    0.384109] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.384180] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.384270] usb usb1: Product: EHCI Host Controller
[    0.384336] usb usb1: Manufacturer: Linux 3.3.5-mpc89mac4gb-gcc4.6 ehci_hcd
[    0.384407] usb usb1: SerialNumber: 0000:00:04.1
[    0.384566] hub 1-0:1.0: USB hub found
[    0.384632] hub 1-0:1.0: 6 ports detected
[    0.384756] ehci_hcd 0000:00:06.1: power state changed by ACPI to D0
[    0.384828] ehci_hcd 0000:00:06.1: power state changed by ACPI to D0
[    0.384907] ehci_hcd 0000:00:06.1: setting latency timer to 64
[    0.384910] ehci_hcd 0000:00:06.1: EHCI Host Controller
[    0.384980] ehci_hcd 0000:00:06.1: new USB bus registered, assigned bus number 2
[    0.385080] ehci_hcd 0000:00:06.1: disable lpm/ppcd for nvidia mcp89
[    0.385136] ehci_hcd 0000:00:06.1: debug port 1
[    0.408015] ehci_hcd 0000:00:06.1: cache line size of 64 is not supported
[    0.408028] ehci_hcd 0000:00:06.1: irq 17, io mem 0xd358b000
[    0.420014] ehci_hcd 0000:00:06.1: USB 2.0 started, EHCI 1.10
[    0.420101] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.420173] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.420262] usb usb2: Product: EHCI Host Controller
[    0.420328] usb usb2: Manufacturer: Linux 3.3.5-mpc89mac4gb-gcc4.6 ehci_hcd
[    0.420399] usb usb2: SerialNumber: 0000:00:06.1
[    0.420549] hub 2-0:1.0: USB hub found
[    0.420614] hub 2-0:1.0: 6 ports detected
[    0.420738] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.420817] ohci_hcd 0000:00:04.0: power state changed by ACPI to D0
[    0.420888] ohci_hcd 0000:00:04.0: power state changed by ACPI to D0
[    0.420968] ohci_hcd 0000:00:04.0: setting latency timer to 64
[    0.420970] ohci_hcd 0000:00:04.0: OHCI Host Controller
[    0.421041] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 3
[    0.421147] ohci_hcd 0000:00:04.0: irq 20, io mem 0xd358a000
[    0.478008] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.478080] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.478169] usb usb3: Product: OHCI Host Controller
[    0.478235] usb usb3: Manufacturer: Linux 3.3.5-mpc89mac4gb-gcc4.6 ohci_hcd
[    0.478306] usb usb3: SerialNumber: 0000:00:04.0
[    0.478458] hub 3-0:1.0: USB hub found
[    0.478525] hub 3-0:1.0: 6 ports detected
[    0.478645] ohci_hcd 0000:00:06.0: power state changed by ACPI to D0
[    0.478717] ohci_hcd 0000:00:06.0: power state changed by ACPI to D0
[    0.478797] ohci_hcd 0000:00:06.0: setting latency timer to 64
[    0.478799] ohci_hcd 0000:00:06.0: OHCI Host Controller
[    0.478869] ohci_hcd 0000:00:06.0: new USB bus registered, assigned bus number 4
[    0.478977] ohci_hcd 0000:00:06.0: irq 18, io mem 0xd3589000
[    0.500207] ata1.00: ATA-8: TOSHIBA MK3255GSXF, FH415B, max UDMA/100
[    0.500278] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.500350] ata1.00: configured for UDMA/100
[    0.500510] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK3255GS FH41 PQ: 0 ANSI: 5
[    0.500703] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    0.500829] sd 0:0:0:0: [sda] Write Protect is off
[    0.500906] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.500937] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.534008] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.534080] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.534169] usb usb4: Product: OHCI Host Controller
[    0.534236] usb usb4: Manufacturer: Linux 3.3.5-mpc89mac4gb-gcc4.6 ohci_hcd
[    0.534307] usb usb4: SerialNumber: 0000:00:06.0
[    0.534462] hub 4-0:1.0: USB hub found
[    0.534528] hub 4-0:1.0: 6 ports detected
[    0.534667] usbcore: registered new interface driver libusual
[    0.534771] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.535712] i8042: No controller found
[    0.535840] mousedev: PS/2 mouse device common for all mice
[    0.536043] rtc_cmos 00:07: RTC can wake from S4
[    0.536298] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.536415] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    0.536590] cpuidle: using governor ladder
[    0.536702] cpuidle: using governor menu
[    0.536865] usbcore: registered new interface driver usbhid
[    0.536933] usbhid: USB HID core driver
[    0.542014] TCP cubic registered
[    0.542229] NET: Registered protocol family 10
[    0.542874] Mobile IPv6
[    0.542936] NET: Registered protocol family 17
[    0.543003] Registering the dns_resolver key type
[    0.543081] Using IPI No-Shortcut mode
[    0.577009]  sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7
[    0.577711] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.605362] rtc_cmos 00:07: setting system clock to 2012-05-10 17:51:22 UTC (1336672282)
[    0.656245] ata2.01: NODEV after polling detection
[    0.664222] ata2.00: ATAPI: HL-DT-STDVDRW  GA32N, KC12, max UDMA/100
[    0.664294] ata2.00: configured for UDMA/100
[    0.668017] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRW  GA32N     KC12 PQ: 0 ANSI: 5
[    0.672295] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    0.672369] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.672564] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    0.683375] EXT2-fs (sda4): error: couldn't mount because of unsupported optional features (240)
[    0.683770] EXT4-fs (sda4): couldn't mount as ext3 due to feature incompatibilities
[    0.719188] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
[    0.719283] VFS: Mounted root (ext4 filesystem) readonly on device 8:4.
[    0.719412] Freeing unused kernel memory: 308k freed
[    0.719619] Write protecting the kernel text: 2848k
[    0.719718] Write protecting the kernel read-only data: 1048k
[    0.944124] usb 3-4: new low-speed USB device number 2 using ohci_hcd
[    1.178110] usb 3-4: New USB device found, idVendor=047b, idProduct=0002
[    1.178191] usb 3-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.178263] usb 3-4: Product: USB Keyboard and Mouse
[    1.178329] usb 3-4: Manufacturer: SILITEK
[    1.195358] input: SILITEK USB Keyboard and Mouse as /devices/pci0000:00/0000:00:04.0/usb3/3-4/3-4:1.0/input/input3
[    1.195587] generic-usb 0003:047B:0002.0001: input,hidraw0: USB HID v1.00 Keyboard [SILITEK USB Keyboard and Mouse] on usb-0000:00:04.0-4/input0
[    1.217171] input: SILITEK USB Keyboard and Mouse as /devices/pci0000:00/0000:00:04.0/usb3/3-4/3-4:1.1/input/input4
[    1.217460] generic-usb 0003:047B:0002.0002: input,hidraw1: USB HID v1.00 Mouse [SILITEK USB Keyboard and Mouse] on usb-0000:00:04.0-4/input1
[    1.328106] usb 2-4: new high-speed USB device number 2 using ehci_hcd
[    1.460405] usb 2-4: New USB device found, idVendor=0424, idProduct=2514
[    1.460480] usb 2-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.460698] hub 2-4:1.0: USB hub found
[    1.460817] hub 2-4:1.0: 3 ports detected
[    1.932100] usb 4-5: new low-speed USB device number 2 using ohci_hcd
[    2.148114] usb 4-5: New USB device found, idVendor=05ac, idProduct=8242
[    2.148195] usb 4-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.148315] usb 4-5: Product: IR Receiver
[    2.148379] usb 4-5: Manufacturer: Apple Computer, Inc.
[    2.167257] apple 0003:05AC:8242.0003: hiddev0,hidraw2: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:06.0-5/input0
[    2.468108] usb 4-6: new full-speed USB device number 3 using ohci_hcd
[    2.690049] usb 4-6: New USB device found, idVendor=0a5c, idProduct=4500
[    2.690141] usb 4-6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.690219] usb 4-6: Product: BRCM2070 Hub
[    2.690293] usb 4-6: Manufacturer: Apple Inc.
[    2.693088] hub 4-6:1.0: USB hub found
[    2.696040] hub 4-6:1.0: 3 ports detected
[    2.796143] usb 2-4.1: new high-speed USB device number 5 using ehci_hcd
[    2.904391] usb 2-4.1: New USB device found, idVendor=0424, idProduct=2640
[    2.904467] usb 2-4.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.904753] hub 2-4.1:1.0: USB hub found
[    2.904870] hub 2-4.1:1.0: 3 ports detected
[    2.992143] usb 2-4.3: new high-speed USB device number 6 using ehci_hcd
[    3.377089] usb 2-4.3: New USB device found, idVendor=046d, idProduct=0821
[    3.377185] usb 2-4.3: New USB device strings: Mfr=0, Product=0, SerialNumber=1
[    3.377279] usb 2-4.3: SerialNumber: 44AC0E90
[    3.454043] usb 4-6.1: new full-speed USB device number 4 using ohci_hcd
[    3.565088] usb 4-6.1: New USB device found, idVendor=05ac, idProduct=820a
[    3.565169] usb 4-6.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.575345] input: HID 05ac:820a as /devices/pci0000:00/0000:00:06.0/usb4/4-6/4-6.1/4-6.1:1.0/input/input5
[    3.575554] generic-usb 0003:05AC:820A.0004: input,hidraw3: USB HID v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:06.0-6.1/input0
[    3.650033] usb 4-6.2: new full-speed USB device number 5 using ohci_hcd
[    3.705353] bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
[    3.705463] bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
[    3.705601] bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
[    3.705772] bcma: Found rev 6 PMU (capabilities 0x108C2606)
[    3.776024] bcma: Failed to get SPROM: -71
[    3.776058] usb 4-6.2: New USB device found, idVendor=05ac, idProduct=820b
[    3.776061] usb 4-6.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.776288] bcma: Bus registered
[    3.785250] input: HID 05ac:820b as /devices/pci0000:00/0000:00:06.0/usb4/4-6/4-6.2/4-6.2:1.0/input/input6
[    3.785463] generic-usb 0003:05AC:820B.0005: input,hidraw4: USB HID v1.11 Mouse [HID 05ac:820b] on usb-0000:00:06.0-6.2/input0
[    3.862112] usb 4-6.3: new full-speed USB device number 6 using ohci_hcd
[    3.983040] usb 4-6.3: New USB device found, idVendor=05ac, idProduct=8218
[    3.983117] usb 4-6.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.983214] usb 4-6.3: Product: Bluetooth USB Host Controller
[    3.983282] usb 4-6.3: Manufacturer: Apple Inc.
[    4.072133] usb 2-4.1.1: new high-speed USB device number 7 using ehci_hcd
[    4.145655] input: PC Speaker as /devices/platform/pcspkr/input/input7
[    4.198601] cfg80211: Calling CRDA to update world regulatory domain
[    4.202436] usb 2-4.1.1: New USB device found, idVendor=0424, idProduct=4063
[    4.202510] usb 2-4.1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.202600] usb 2-4.1.1: Product: Ultra Fast Media Reader
[    4.202670] usb 2-4.1.1: Manufacturer: Generic
[    4.202738] usb 2-4.1.1: SerialNumber: 000000264001
[    4.212149] Initializing USB Mass Storage driver...
[    4.212499] scsi2 : usb-storage 2-4.1.1:1.0
[    4.212621] usbcore: registered new interface driver usb-storage
[    4.212692] USB Mass Storage support registered.
[    4.281434] applesmc: key=215 fan=1 temp=29 acc=0 lux=0 kbd=0
[    4.292135] usb 2-4.1.2: new full-speed USB device number 8 using ehci_hcd
[    4.343541] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 22
[    4.392118] firewire_ohci: Added fw-ohci device 0000:02:00.0, OHCI v1.10, 8 IR + 8 IT contexts, quirks 0x2
[    4.400876] usb 2-4.1.2: New USB device found, idVendor=067b, idProduct=2303
[    4.400954] usb 2-4.1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.401047] usb 2-4.1.2: Product: USB-Serial Controller D
[    4.401116] usb 2-4.1.2: Manufacturer: Prolific Technology Inc. 
[    4.638392] sdhci: Secure Digital Host Controller Interface driver
[    4.638520] sdhci: Copyright(c) Pierre Ossman
[    4.714515] sdhci-pci 0000:04:00.1: SDHCI controller found [14e4:16bc] (rev 0)
[    4.718354] ACPI: PCI Interrupt Link [Z00O] enabled at IRQ 23
[    4.718426] sdhci-pci 0000:04:00.1: Invalid iomem size. You may experience problems.
[    4.718614] Registered led device: mmc0::
[    4.719671] mmc0: SDHCI controller on PCI [0000:04:00.1] using ADMA
[    4.724052] bcma: Switched to core: 0x812
[    4.853291] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    4.853774] brcms_module_init: register returned 0
[    4.893222] firewire_core: created device fw0: GUID e80688fffeeab6ae, S800
[    4.922022] snd_hda_intel 0000:00:08.0: power state changed by ACPI to D0
[    4.922099] snd_hda_intel 0000:00:08.0: power state changed by ACPI to D0
[    4.922311] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 22
[    4.922382] hda_intel: Disabling MSI
[    4.922445] hda_intel: position_fix set to 1 for device 10de:cb89
[    4.922537] snd_hda_intel 0000:00:08.0: setting latency timer to 64
[    5.217352] scsi 2:0:0:0: Direct-Access     Generic  Ultra HS-SD/MMC  1.91 PQ: 0 ANSI: 0
[    5.225479] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[    5.473519] usbcore: registered new interface driver uas
[    5.482133] Linux video capture interface: v2.00
[    5.634632] uvcvideo: Found UVC 1.00 device <unnamed> (046d:0821)
[    5.684277] usbcore: registered new interface driver usbserial
[    5.684358] USB Serial support registered for generic
[    5.694255] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.694359] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.694460] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    5.754630] nvidia: module license 'NVIDIA' taints kernel.
[    5.754702] Disabling lock debugging due to kernel taint
[    5.773079] ACPI: PCI Interrupt Link [LGPU] enabled at IRQ 21
[    5.773157] nvidia 0000:05:00.0: setting latency timer to 64
[    5.773162] vgaarb: device changed decodes: PCI:0000:05:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    5.773459] NVRM: loading NVIDIA UNIX x86 Kernel Module  295.49  Mon Apr 30 23:30:07 PDT 2012
[    5.847417] input: UVC Camera (046d:0821) as /devices/pci0000:00/0000:00:06.1/usb2/2-4/2-4.3/2-4.3:1.2/input/input8
[    5.847643] usbcore: registered new interface driver uvcvideo
[    5.847713] USB Video Class driver (1.1.1)
[    5.900882] Bluetooth: Core ver 2.16
[    5.900967] NET: Registered protocol family 31
[    5.901033] Bluetooth: HCI device and connection manager initialized
[    5.901104] Bluetooth: HCI socket layer initialized
[    5.901170] Bluetooth: L2CAP socket layer initialized
[    5.901240] Bluetooth: SCO socket layer initialized
[    5.902891] usbcore: registered new interface driver snd-usb-audio
[    5.902908] usbcore: registered new interface driver usbserial_generic
[    5.902910] usbserial: USB Serial Driver core
[    5.919817] usbcore: registered new interface driver btusb
[    5.924675] USB Serial support registered for pl2303
[    5.924766] pl2303 2-4.1.2:1.0: pl2303 converter detected
[    5.926467] usb 2-4.1.2: pl2303 converter now attached to ttyUSB0
[    5.926558] usbcore: registered new interface driver pl2303
[    5.931469] pl2303: Prolific PL2303 USB to serial adaptor driver
[    5.945044] usb 4-6.1: USB disconnect, device number 4
[    6.084047] usb 4-6.2: USB disconnect, device number 5
[    6.400078] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
[    6.424075] HDMI status: Codec=4 Pin=5 Presence_Detect=0 ELD_Valid=0
[    6.448039] HDMI status: Codec=5 Pin=5 Presence_Detect=0 ELD_Valid=0
[    6.448184] input: HDA NVidia HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:08.0/sound/card0/input9
[    6.448378] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:08.0/sound/card0/input10
[    6.448562] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:08.0/sound/card0/input11
[    6.448723] input: HDA NVidia Headphone as /devices/pci0000:00/0000:00:08.0/sound/card0/input12
[    9.994432] Adding 12287996k swap on /dev/sda5.  Priority:-1 extents:1 across:12287996k 
[    9.997188] EXT4-fs (sda4): warning: maximal mount count reached, running e2fsck is recommended
[    9.997701] EXT4-fs (sda4): re-mounted. Opts: errors=remount-ro
[   10.109998] loop: module loaded
[   11.209493] FAT-fs (sda1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[   11.389673] EXT4-fs (sda6): warning: maximal mount count reached, running e2fsck is recommended
[   11.396456] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: errors=remount-ro
[   11.518625] EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
[   12.458711] RPC: Registered named UNIX socket transport module.
[   12.458802] RPC: Registered udp transport module.
[   12.458870] RPC: Registered tcp transport module.
[   12.458937] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   12.499368] FS-Cache: Loaded
[   12.515648] FS-Cache: Netfs 'nfs' registered for caching
[   12.520460] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   13.312403] fuse init (API version 7.18)
[   30.100370] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   30.100467] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[   30.102286] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   30.156302] tg3 0000:04:00.0: irq 43 for MSI/MSI-X
[   30.156309] tg3 0000:04:00.0: irq 44 for MSI/MSI-X
[   30.156314] tg3 0000:04:00.0: irq 45 for MSI/MSI-X
[   30.444072] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   32.221706] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   32.221800] Bluetooth: BNEP filters: protocol multicast
[   32.426799] Bluetooth: RFCOMM TTY layer initialized
[   32.426873] Bluetooth: RFCOMM socket layer initialized
[   32.426943] Bluetooth: RFCOMM ver 1.11
[   32.861901] tg3 0000:04:00.0: eth0: Link is up at 1000 Mbps, full duplex
[   32.861976] tg3 0000:04:00.0: eth0: Flow control is on for TX and on for RX
[   32.862215] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   37.800326] HDMI hot plug event: Codec=4 Pin=5 Presence_Detect=1 ELD_Valid=0
[   37.808026] HDMI status: Codec=4 Pin=5 Presence_Detect=1 ELD_Valid=0
[   37.819985] HDMI hot plug event: Codec=4 Pin=5 Presence_Detect=0 ELD_Valid=1
[   37.824042] HDMI status: Codec=4 Pin=5 Presence_Detect=1 ELD_Valid=1
[   38.592071] HDMI: detected monitor DELL U2711
[   38.592073]    at connection type DisplayPort
[   38.592078] HDMI: available speakers: FL/FR LFE FC RL/RR
[   38.592084] HDMI: supports coding type LPCM: channels = 6, rates = 32000 44100 48000 88200 96000 176400 192000, bits = 16 20 24
[   50.512169] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   50.529533] NFSD: starting 90-second grace period
[   55.570547] EXT4-fs (sda4): re-mounted. Opts: errors=remount-ro,commit=0
[   55.648653] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro,commit=0
[   55.793113] EXT4-fs (sda7): re-mounted. Opts: commit=0
[   60.747850] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   60.748771] apple 0005:05AC:0239.0006: unknown main item tag 0x0
[   60.788722] power_supply hid-E8:06:88:4B:BA:19-battery: driver failed to report `capacity' property: 4294967291
[   60.788862] input: Brent Roman's Keyboard as /devices/pci0000:00/0000:00:06.0/usb4/4-6/4-6.3/4-6.3:1.0/bluetooth/hci0/hci0:11/input13
[   60.789009] apple 0005:05AC:0239.0006: input,hidraw3: BLUETOOTH HID v0.50 Keyboard [Brent Roman's Keyboard] on 60:33:4B:0C:4E:0C
[   60.794596] power_supply hid-E8:06:88:4B:BA:19-battery: driver failed to report `capacity' property: 4294967291
[  112.034805] magicmouse 0005:05AC:030E.0007: unknown main item tag 0x0
[  112.198372] power_supply hid-C8:BC:C8:F8:BE:7B-battery: driver failed to report `capacity' property: 4294967291
[  112.198468] input: Brent Roman's Trackpad as /devices/pci0000:00/0000:00:06.0/usb4/4-6/4-6.3/4-6.3:1.0/bluetooth/hci0/hci0:12/input14
[  112.198560] magicmouse 0005:05AC:030E.0007: input,hidraw4: BLUETOOTH HID v1.60 Mouse [Brent Roman's Trackpad] on 60:33:4B:0C:4E:0C
[  112.199753] power_supply hid-C8:BC:C8:F8:BE:7B-battery: driver failed to report `capacity' property: 4294967291
[  137.264152] power_supply hid-C8:BC:C8:F8:BE:7B-battery: driver failed to report `capacity' property: 4294967291
[  137.266005] magicmouse 0005:05AC:030E.0008: unknown main item tag 0x0
[  137.290764] power_supply hid-C8:BC:C8:F8:BE:7B-battery: driver failed to report `capacity' property: 4294967291
[  137.290875] input: Brent Roman's Trackpad as /devices/pci0000:00/0000:00:06.0/usb4/4-6/4-6.3/4-6.3:1.0/bluetooth/hci0/hci0:13/input15
[  137.291003] magicmouse 0005:05AC:030E.0008: input,hidraw4: BLUETOOTH HID v1.60 Mouse [Brent Roman's Trackpad] on 60:33:4B:0C:4E:0C
[  137.299721] power_supply hid-C8:BC:C8:F8:BE:7B-battery: driver failed to report `capacity' property: 4294967291
[  149.340584] usb 2-4.1.3: new low-speed USB device number 9 using ehci_hcd
[  149.453780] usb 2-4.1.3: New USB device found, idVendor=046d, idProduct=c00e
[  149.453787] usb 2-4.1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  149.453790] usb 2-4.1.3: Product: USB-PS/2 Optical Mouse
[  149.453793] usb 2-4.1.3: Manufacturer: Logitech
[  149.457427] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:06.1/usb2/2-4/2-4.1/2-4.1.3/2-4.1.3:1.0/input/input16
[  149.457608] generic-usb 0003:046D:C00E.0009: input,hidraw5: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:06.1-4.1.3/input0
[  162.344148] power_supply hid-C8:BC:C8:F8:BE:7B-battery: driver failed to report `capacity' property: 4294967291
[  272.605014] magicmouse 0005:05AC:030E.000A: unknown main item tag 0x0
[  272.612407] power_supply hid-C8:BC:C8:F8:BE:7B-battery: driver failed to report `capacity' property: 4294967291
[  272.612483] input: Brent Roman's Trackpad as /devices/pci0000:00/0000:00:06.0/usb4/4-6/4-6.3/4-6.3:1.0/bluetooth/hci0/hci0:12/input17
[  272.613032] magicmouse 0005:05AC:030E.000A: input,hidraw4: BLUETOOTH HID v1.60 Mouse [Brent Roman's Trackpad] on 60:33:4B:0C:4E:0C
[  272.613710] power_supply hid-C8:BC:C8:F8:BE:7B-battery: driver failed to report `capacity' property: 4294967291
[  302.484091] usb 2-4.1.3: USB disconnect, device number 9

--------------060700080404050808050506
Content-Type: text/plain;
 name="linux-3.3.5-mpc89mac4gb.lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linux-3.3.5-mpc89mac4gb.lspci"

00:00.0 0600: 10de:0d60 (rev a1)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:00.1 0500: 10de:0d68 (rev a1)
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:01.0 0500: 10de:0d6d (rev a1)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:01.1 0500: 10de:0d6e (rev a1)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:01.2 0500: 10de:0d6f (rev a1)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:01.3 0500: 10de:0d70 (rev a1)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:02.0 0500: 10de:0d71 (rev a1)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:02.1 0500: 10de:0d72 (rev a1)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:03.0 0601: 10de:0d80 (rev a2)
	Subsystem: 106b:cb89
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: I/O ports at 2100 [size=256]

00:03.1 0500: 10de:0d7b (rev a1)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:03.2 0c05: 10de:0d79 (rev a1)
	Subsystem: 10de:cb89
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 15
	Region 0: I/O ports at 2000 [size=256]
	Region 4: I/O ports at 2240 [size=64]
	Region 5: I/O ports at 2200 [size=64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:03.3 0500: 10de:0d69 (rev a1)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:03.4 0b40: 10de:0d7a (rev a1)
	Subsystem: 10de:cb89
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 14
	Region 0: Memory at d3500000 (32-bit, non-prefetchable) [size=512K]

00:04.0 0c03: 10de:0d9c (rev a1) (prog-if 10 [OHCI])
	Subsystem: 10de:cb89
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at d358a000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ohci_hcd

00:04.1 0c03: 10de:0d9d (rev a2) (prog-if 20 [EHCI])
	Subsystem: 10de:cb89
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at d358b100 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=00a0
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd

00:06.0 0c03: 10de:0d9c (rev a1) (prog-if 10 [OHCI])
	Subsystem: 10de:cb89
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at d3589000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ohci_hcd

00:06.1 0c03: 10de:0d9d (rev a2) (prog-if 20 [EHCI])
	Subsystem: 10de:cb89
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at d358b000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=00a0
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd

00:08.0 0403: 10de:0d94 (rev a2)
	Subsystem: 10de:cb89
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at d3580000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel driver in use: snd_hda_intel

00:0a.0 0101: 10de:0d85 (rev a2) (prog-if 85 [Master SecO PriO])
	Subsystem: 106b:cb89
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 2298 [size=8]
	Region 1: I/O ports at 22a4 [size=4]
	Region 2: I/O ports at 2290 [size=8]
	Region 3: I/O ports at 22a0 [size=4]
	Region 4: I/O ports at 2280 [size=16]
	Region 5: Memory at d3584000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] SATA HBA v1.0 InCfgSpace
	Capabilities: [b0] MSI: Enable- Count=1/8 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: ata_generic

00:0b.0 0500: 10de:0d75 (rev a1)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 0
	Region 0: Memory at d3588000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000

00:0e.0 0604: 10de:0d9a (rev a1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=01, subordinate=02, sec-latency=0
	Memory behind bridge: d3400000-d34fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: 10de:0000
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4171
	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg+
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Kernel driver in use: pcieport

00:15.0 0604: 10de:0d9b (rev a1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Memory behind bridge: d3300000-d33fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: 10de:0000
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4179
	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg+
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Kernel driver in use: pcieport

00:16.0 0604: 10de:0d9b (rev a1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	Memory behind bridge: d3200000-d32fffff
	Prefetchable memory behind bridge: 00000000d3100000-00000000d31fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: 10de:0000
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 4181
	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg+
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Kernel driver in use: pcieport

00:17.0 0604: 10de:0d76 (rev a1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: d2000000-d30fffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000d1ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: 10de:0000
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000

01:00.0 0604: 104c:823e (rev 01) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=01, secondary=02, subordinate=02, sec-latency=0
	Memory behind bridge: d3400000-d34fffff
	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [60] MSI: Enable- Count=1/16 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [80] Subsystem: 0000:0000
	Capabilities: [90] Express (v1) PCI/PCI-X Bridge, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ BrConfRtry-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <16us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-

02:00.0 0c00: 104c:823f (rev 01) (prog-if 10 [OHCI])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 248 (500ns min, 1000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at d3404000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at d3400000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: firewire_ohci

03:00.0 0280: 14e4:4353 (rev 01)
	Subsystem: 106b:0093
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at d3300000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
	Capabilities: [58] Vendor Specific Information: Len=78 <?>
	Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
			ClockPM+ Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 54-70-4b-ff-ff-0c-60-33
	Capabilities: [16c v1] Power Budgeting <?>
	Kernel driver in use: bcma-pci-bridge

04:00.0 0200: 14e4:16b4
	Subsystem: 14e4:16b4
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at d3100000 (64-bit, prefetchable) [size=64K]
	Region 2: Memory at d3110000 (64-bit, prefetchable) [size=64K]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [58] MSI: Enable- Count=1/8 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [a0] MSI-X: Enable+ Count=7 Masked-
		Vector table: BAR=2 offset=00000000
		PBA: BAR=2 offset=00000120
	Capabilities: [ac] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <2us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [13c v1] Device Serial Number 00-00-c4-2c-03-1d-1e-1e
	Capabilities: [150 v1] Power Budgeting <?>
	Capabilities: [160 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: tg3

04:00.1 0805: 14e4:16bc (prog-if 01)
	Subsystem: 14e4:0000
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin B routed to IRQ 23
	Region 0: Memory at d3120000 (64-bit, prefetchable) [size=64K]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [58] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [ac] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <2us, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [150 v1] Power Budgeting <?>
	Capabilities: [160 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Kernel driver in use: sdhci-pci

05:00.0 0300: 10de:08a4 (rev a2) (prog-if 00 [VGA controller])
	Subsystem: 106b:00c0
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at d2000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at d0000000 (64-bit, prefetchable) [size=32M]
	Region 5: I/O ports at 1000 [size=128]
	[virtual] Expansion ROM at d3000000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Vendor Specific Information: Len=14 <?>
	Kernel driver in use: nvidia


--------------060700080404050808050506--

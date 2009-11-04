Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53710 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbZKDTAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 14:00:08 -0500
Date: Wed, 4 Nov 2009 13:52:12 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: rt61pci bug
Message-ID: <20091104185212.GL12965@tuxdriver.com>
References: <4AE43028.30703@klingt.org> <hcsfgm$bft$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <hcsfgm$bft$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ 1591.626628] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
[ 1591.626636] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
[ 1591.626644] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
[ 1591.626652] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
[ 1656.653960] phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
[ 1656.653963] Please file bug report to http://rt2x00.serialmonkey.com

Near the bottom...

Is that message correct?  The bug reports link at the wiki seems a bit unclear...

John

On Wed, Nov 04, 2009 at 07:00:54PM +0100, Tim Blechmann wrote:
> > running the rt61pci module on 2.6.31.5 works fine, but using the recent 
> > linus/master (2.6.32-rc5) results in this:
> 
> same issue with 2.6.32-rc5 ... new bootlog with more debugging info
> attached ...
> 
> tim
> 
> -- 
> tim@klingt.org
> http://tim.klingt.org
> 
> Life is really simple, but we insist on making it complicated.
>   Confucius

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.32-rc6 (tim@moka) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu8) ) #36 SMP PREEMPT Wed Nov 4 01:03:33 CET 2009
> [    0.000000] Command line: root=UUID=f4e801b1-b54a-4002-a3e3-328308ad48fb ro splash vga=769 
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e4c00 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf680000 (usable)
> [    0.000000]  BIOS-e820: 00000000bf680000 - 00000000bf698000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bf698000 - 00000000bf6dc000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bf6dc000 - 00000000c0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000340000000 (usable)
> [    0.000000] DMI 2.5 present.
> [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] last_pfn = 0x340000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-E3FFF write-protect
> [    0.000000]   E4000-EBFFF write-through
> [    0.000000]   EC000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask E00000000 write-back
> [    0.000000]   1 base 200000000 mask F00000000 write-back
> [    0.000000]   2 base 300000000 mask FC0000000 write-back
> [    0.000000]   3 base 0C0000000 mask FC0000000 uncachable
> [    0.000000]   4 base 0BF700000 mask FFFF00000 uncachable
> [    0.000000]   5 base 0BF800000 mask FFF800000 uncachable
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] e820 update range: 00000000bf700000 - 0000000100000000 (usable) ==> (reserved)
> [    0.000000] last_pfn = 0xbf680 max_arch_pfn = 0x400000000
> [    0.000000] Scanning 0 areas for low memory corruption
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
> [    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
> [    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  modified: 00000000000e4c00 - 0000000000100000 (reserved)
> [    0.000000]  modified: 0000000000100000 - 00000000bf680000 (usable)
> [    0.000000]  modified: 00000000bf680000 - 00000000bf698000 (ACPI data)
> [    0.000000]  modified: 00000000bf698000 - 00000000bf6dc000 (ACPI NVS)
> [    0.000000]  modified: 00000000bf6dc000 - 00000000c0000000 (reserved)
> [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
> [    0.000000]  modified: 0000000100000000 - 0000000340000000 (usable)
> [    0.000000] initial memory mapped : 0 - 20000000
> [    0.000000] init_memory_mapping: 0000000000000000-00000000bf680000
> [    0.000000]  0000000000 - 00bf600000 page 2M
> [    0.000000]  00bf600000 - 00bf680000 page 4k
> [    0.000000] kernel direct mapping tables up to bf680000 @ 10000-15000
> [    0.000000] init_memory_mapping: 0000000100000000-0000000340000000
> [    0.000000]  0100000000 - 0340000000 page 2M
> [    0.000000] kernel direct mapping tables up to 340000000 @ 13000-21000
> [    0.000000] RAMDISK: 37868000 - 37fef45a
> [    0.000000] ACPI: RSDP 00000000000fabd0 00024 (v02 ACPIAM)
> [    0.000000] ACPI: XSDT 00000000bf680100 0005C (v01 022609 XSDT1156 20090226 MSFT 00000097)
> [    0.000000] ACPI: FACP 00000000bf680290 000F4 (v03 022609 FACP1156 20090226 MSFT 00000097)
> [    0.000000] ACPI: DSDT 00000000bf6804b0 0C3DD (v01  A1146 A1146001 00000001 INTL 20060113)
> [    0.000000] ACPI: FACS 00000000bf698000 00040
> [    0.000000] ACPI: APIC 00000000bf680390 000D8 (v01 022609 APIC1156 20090226 MSFT 00000097)
> [    0.000000] ACPI: MCFG 00000000bf680470 0003C (v01 022609 OEMMCFG  20090226 MSFT 00000097)
> [    0.000000] ACPI: OEMB 00000000bf698040 00072 (v01 022609 OEMB1156 20090226 MSFT 00000097)
> [    0.000000] ACPI: HPET 00000000bf68f4b0 00038 (v01 022609 OEMHPET  20090226 MSFT 00000097)
> [    0.000000] ACPI: OSFR 00000000bf68f4f0 000B0 (v01 022609 OEMOSFR  20090226 MSFT 00000097)
> [    0.000000] ACPI: SSDT 00000000bf69a8f0 0249F (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0340000000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
> [    0.000000]   #2 [0001000000 - 00019a6d44]    TEXT DATA BSS ==> [0001000000 - 00019a6d44]
> [    0.000000]   #3 [0037868000 - 0037fef45a]          RAMDISK ==> [0037868000 - 0037fef45a]
> [    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
> [    0.000000]   #5 [00019a7000 - 00019a7288]              BRK ==> [00019a7000 - 00019a7288]
> [    0.000000]   #6 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
> [    0.000000]   #7 [0000013000 - 000001c000]          PGTABLE ==> [0000013000 - 000001c000]
> [    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
> [    0.000000]  [ffffea0000000000-ffffea000b5fffff] PMD -> [ffff880028600000-ffff880032dfffff] on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x00340000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x000bf680
> [    0.000000]     0: 0x00100000 -> 0x00340000
> [    0.000000] On node 0 totalpages: 3143183
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 111 pages reserved
> [    0.000000]   DMA zone: 3816 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 14280 pages used for memmap
> [    0.000000]   DMA32 zone: 765624 pages, LIFO batch:31
> [    0.000000]   Normal zone: 32256 pages used for memmap
> [    0.000000]   Normal zone: 2327040 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
> [    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
> [    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
> [    0.000000] 16 Processors exceeds NR_CPUS limit of 8
> [    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 48
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e5000
> [    0.000000] PM: Registered nosave memory: 00000000000e5000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 00000000bf680000 - 00000000bf698000
> [    0.000000] PM: Registered nosave memory: 00000000bf698000 - 00000000bf6dc000
> [    0.000000] PM: Registered nosave memory: 00000000bf6dc000 - 00000000c0000000
> [    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
> [    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
> [    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880028200000 s90200 r8192 d24488 u262144
> [    0.000000] pcpu-alloc: s90200 r8192 d24488 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3096480
> [    0.000000] Kernel command line: root=UUID=f4e801b1-b54a-4002-a3e3-328308ad48fb ro splash vga=769 
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> [    0.000000] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
> [    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
> [    0.000000] Memory: 12290392k/13631488k available (5351k kernel code, 1058756k absent, 281452k reserved, 2986k data, 540k init)
> [    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] NR_IRQS:512
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] allocated 125829120 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] hpet clockevent registered
> [    0.000000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
> [    0.000000] Fast TSC calibration using PIT
> [    0.010000] Detected 2672.606 MHz processor.
> [    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5345.21 BogoMIPS (lpj=26726060)
> [    0.000121] Security Framework initialized
> [    0.000174] SELinux:  Disabled at boot.
> [    0.000229] Mount-cache hash table entries: 256
> [    0.000356] Initializing cgroup subsys ns
> [    0.000408] Initializing cgroup subsys cpuacct
> [    0.000462] Initializing cgroup subsys memory
> [    0.000515] Initializing cgroup subsys freezer
> [    0.000578] CPU: Physical Processor ID: 0
> [    0.000630] CPU: Processor Core ID: 0
> [    0.000682] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.000765] CPU: L2 cache: 256K
> [    0.000814] CPU: L3 cache: 8192K
> [    0.000865] using mwait in idle threads.
> [    0.000916] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
> [    0.001035] ... version:                3
> [    0.001086] ... bit width:              48
> [    0.001136] ... generic registers:      4
> [    0.001187] ... value mask:             0000ffffffffffff
> [    0.001240] ... max period:             000000007fffffff
> [    0.001293] ... fixed-purpose events:   3
> [    0.001344] ... event mask:             000000070000000f
> [    0.002090] ACPI: Core revision 20090903
> [    0.038176] Setting APIC routing to flat
> [    0.038676] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.138701] CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
> [    0.308525] Booting processor 1 APIC 0x2 ip 0x6000
> [    0.318842] Initializing CPU#1
> [    0.467616] Calibrating delay using timer specific routine.. 5317.40 BogoMIPS (lpj=26587025)
> [    0.467624] CPU: Physical Processor ID: 0
> [    0.467625] CPU: Processor Core ID: 1
> [    0.467627] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.467628] CPU: L2 cache: 256K
> [    0.467629] CPU: L3 cache: 8192K
> [    0.467663] CPU1: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
> [    0.468895] Skipping synchronization checks as TSC is reliable.
> [    0.497467] Booting processor 2 APIC 0x4 ip 0x6000
> [    0.507879] Initializing CPU#2
> [    0.656557] Calibrating delay using timer specific routine.. 5317.41 BogoMIPS (lpj=26587054)
> [    0.656563] CPU: Physical Processor ID: 0
> [    0.656564] CPU: Processor Core ID: 2
> [    0.656566] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.656567] CPU: L2 cache: 256K
> [    0.656568] CPU: L3 cache: 8192K
> [    0.656578] CPU2: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
> [    0.686417] Booting processor 3 APIC 0x6 ip 0x6000
> [    0.696730] Initializing CPU#3
> [    0.845503] Calibrating delay using timer specific routine.. 5317.40 BogoMIPS (lpj=26587036)
> [    0.845509] CPU: Physical Processor ID: 0
> [    0.845510] CPU: Processor Core ID: 3
> [    0.845512] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.845514] CPU: L2 cache: 256K
> [    0.845514] CPU: L3 cache: 8192K
> [    0.845530] CPU3: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
> [    0.875358] Booting processor 4 APIC 0x1 ip 0x6000
> [    0.885771] Initializing CPU#4
> [    1.034447] Calibrating delay using timer specific routine.. 5317.41 BogoMIPS (lpj=26587077)
> [    1.034456] CPU: Physical Processor ID: 0
> [    1.034457] CPU: Processor Core ID: 0
> [    1.034460] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    1.034462] CPU: L2 cache: 256K
> [    1.034463] CPU: L3 cache: 8192K
> [    1.034550] CPU4: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
> [    1.064298] Booting processor 5 APIC 0x3 ip 0x6000
> [    1.074612] Initializing CPU#5
> [    1.223389] Calibrating delay using timer specific routine.. 5317.27 BogoMIPS (lpj=26586378)
> [    1.223396] CPU: Physical Processor ID: 0
> [    1.223397] CPU: Processor Core ID: 1
> [    1.223399] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    1.223400] CPU: L2 cache: 256K
> [    1.223401] CPU: L3 cache: 8192K
> [    1.223404] CPU5: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
> [    1.253242] Booting processor 6 APIC 0x5 ip 0x6000
> [    1.263656] Initializing CPU#6
> [    1.412330] Calibrating delay using timer specific routine.. 5317.41 BogoMIPS (lpj=26587050)
> [    1.412336] CPU: Physical Processor ID: 0
> [    1.412337] CPU: Processor Core ID: 2
> [    1.412339] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    1.412341] CPU: L2 cache: 256K
> [    1.412341] CPU: L3 cache: 8192K
> [    1.412355] CPU6: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
> [    1.442215] Booting processor 7 APIC 0x7 ip 0x6000
> [    1.452531] Initializing CPU#7
> [    1.601277] Calibrating delay using timer specific routine.. 5317.40 BogoMIPS (lpj=26587018)
> [    1.601283] CPU: Physical Processor ID: 0
> [    1.601284] CPU: Processor Core ID: 3
> [    1.601286] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    1.601287] CPU: L2 cache: 256K
> [    1.601288] CPU: L3 cache: 8192K
> [    1.601346] CPU7: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 05
> [    1.601848] Brought up 8 CPUs
> [    1.601898] Total of 8 processors activated (42566.93 BogoMIPS).
> [    1.605179] CPU0 attaching sched-domain:
> [    1.605182]  domain 0: span 0,4 level SIBLING
> [    1.605184]   groups: 0 (cpu_power = 589) 4 (cpu_power = 589)
> [    1.605187]   domain 1: span 0-7 level MC
> [    1.605189]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
> [    1.605196] CPU1 attaching sched-domain:
> [    1.605198]  domain 0: span 1,5 level SIBLING
> [    1.605199]   groups: 1 (cpu_power = 589) 5 (cpu_power = 589)
> [    1.605202]   domain 1: span 0-7 level MC
> [    1.605204]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
> [    1.605210] CPU2 attaching sched-domain:
> [    1.605211]  domain 0: span 2,6 level SIBLING
> [    1.605212]   groups: 2 (cpu_power = 589) 6 (cpu_power = 589)
> [    1.605216]   domain 1: span 0-7 level MC
> [    1.605217]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
> [    1.605223] CPU3 attaching sched-domain:
> [    1.605224]  domain 0: span 3,7 level SIBLING
> [    1.605226]   groups: 3 (cpu_power = 589) 7 (cpu_power = 589)
> [    1.605229]   domain 1: span 0-7 level MC
> [    1.605231]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
> [    1.605236] CPU4 attaching sched-domain:
> [    1.605238]  domain 0: span 0,4 level SIBLING
> [    1.605239]   groups: 4 (cpu_power = 589) 0 (cpu_power = 589)
> [    1.605242]   domain 1: span 0-7 level MC
> [    1.605244]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
> [    1.605250] CPU5 attaching sched-domain:
> [    1.605251]  domain 0: span 1,5 level SIBLING
> [    1.605252]   groups: 5 (cpu_power = 589) 1 (cpu_power = 589)
> [    1.605256]   domain 1: span 0-7 level MC
> [    1.605257]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
> [    1.605263] CPU6 attaching sched-domain:
> [    1.605264]  domain 0: span 2,6 level SIBLING
> [    1.605266]   groups: 6 (cpu_power = 589) 2 (cpu_power = 589)
> [    1.605269]   domain 1: span 0-7 level MC
> [    1.605270]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
> [    1.605276] CPU7 attaching sched-domain:
> [    1.605278]  domain 0: span 3,7 level SIBLING
> [    1.605279]   groups: 7 (cpu_power = 589) 3 (cpu_power = 589)
> [    1.605282]   domain 1: span 0-7 level MC
> [    1.605284]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
> [    1.605756] regulator: core version 0.5
> [    1.605829] Time: 17:10:51  Date: 11/04/09
> [    1.605908] NET: Registered protocol family 16
> [    1.606032] ACPI: bus type pci registered
> [    1.606129] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    1.606186] PCI: Not using MMCONFIG.
> [    1.606236] PCI: Using configuration type 1 for base access
> [    1.606874] bio: create slab <bio-0> at 0
> [    1.607794] ACPI: EC: Look up EC in DSDT
> [    1.610167] ACPI: Executed 1 blocks of module-level executable AML code
> [    1.640134] ACPI: Interpreter enabled
> [    1.640189] ACPI: (supports S0 S1 S3 S4 S5)
> [    1.640412] ACPI: Using IOAPIC for interrupt routing
> [    1.640514] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    1.642726] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
> [    1.646706] PCI: Using MMCONFIG at e0000000 - efffffff
> [    1.654909] ACPI Warning: Incorrect checksum in table [OEMB] - 8B, should be 83 (20090903/tbutils-314)
> [    1.655173] ACPI: No dock devices found.
> [    1.655351] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    1.655467] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
> [    1.655524] pci 0000:00:00.0: PME# disabled
> [    1.655630] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    1.655686] pci 0000:00:01.0: PME# disabled
> [    1.655793] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
> [    1.655849] pci 0000:00:03.0: PME# disabled
> [    1.655957] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
> [    1.656013] pci 0000:00:07.0: PME# disabled
> [    1.656348] pci 0000:00:1a.0: reg 20 io port: [0xb800-0xb81f]
> [    1.656409] pci 0000:00:1a.1: reg 20 io port: [0xb880-0xb89f]
> [    1.656469] pci 0000:00:1a.2: reg 20 io port: [0xbc00-0xbc1f]
> [    1.656533] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf7fff000-0xf7fff3ff]
> [    1.656582] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    1.656639] pci 0000:00:1a.7: PME# disabled
> [    1.656725] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7ff8000-0xf7ffbfff]
> [    1.656761] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    1.656817] pci 0000:00:1b.0: PME# disabled
> [    1.656921] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    1.656977] pci 0000:00:1c.0: PME# disabled
> [    1.657083] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    1.657139] pci 0000:00:1c.2: PME# disabled
> [    1.657238] pci 0000:00:1d.0: reg 20 io port: [0xb080-0xb09f]
> [    1.657299] pci 0000:00:1d.1: reg 20 io port: [0xb400-0xb41f]
> [    1.657360] pci 0000:00:1d.2: reg 20 io port: [0xb480-0xb49f]
> [    1.657426] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7ffe000-0xf7ffe3ff]
> [    1.657475] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    1.657532] pci 0000:00:1d.7: PME# disabled
> [    1.657691] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
> [    1.657763] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
> [    1.657821] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
> [    1.657894] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 001f)
> [    1.658009] pci 0000:00:1f.2: reg 10 io port: [0xa000-0xa007]
> [    1.658013] pci 0000:00:1f.2: reg 14 io port: [0x9c00-0x9c03]
> [    1.658018] pci 0000:00:1f.2: reg 18 io port: [0x9880-0x9887]
> [    1.658022] pci 0000:00:1f.2: reg 1c io port: [0x9800-0x9803]
> [    1.658027] pci 0000:00:1f.2: reg 20 io port: [0x9480-0x948f]
> [    1.658032] pci 0000:00:1f.2: reg 24 io port: [0x9400-0x940f]
> [    1.658072] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf7ffd000-0xf7ffd0ff]
> [    1.658083] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
> [    1.658121] pci 0000:00:1f.5: reg 10 io port: [0xb000-0xb007]
> [    1.658125] pci 0000:00:1f.5: reg 14 io port: [0xac00-0xac03]
> [    1.658130] pci 0000:00:1f.5: reg 18 io port: [0xa880-0xa887]
> [    1.658135] pci 0000:00:1f.5: reg 1c io port: [0xa800-0xa803]
> [    1.658139] pci 0000:00:1f.5: reg 20 io port: [0xa480-0xa48f]
> [    1.658144] pci 0000:00:1f.5: reg 24 io port: [0xa400-0xa40f]
> [    1.658220] pci 0000:02:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
> [    1.658227] pci 0000:02:00.0: reg 14 64bit mmio pref: [0xd0000000-0xdfffffff]
> [    1.658235] pci 0000:02:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
> [    1.658239] pci 0000:02:00.0: reg 24 io port: [0xcc00-0xcc7f]
> [    1.658244] pci 0000:02:00.0: reg 30 32bit mmio pref: [0xfb480000-0xfb4fffff]
> [    1.658290] pci 0000:00:03.0: bridge io port: [0xc000-0xcfff]
> [    1.658292] pci 0000:00:03.0: bridge 32bit mmio: [0xf8000000-0xfb4fffff]
> [    1.658297] pci 0000:00:03.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
> [    1.658361] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf4f00000-0xf4ffffff]
> [    1.658403] pci 0000:04:00.0: reg 10 io port: [0xd800-0xd8ff]
> [    1.658421] pci 0000:04:00.0: reg 18 64bit mmio: [0xfb5ff000-0xfb5fffff]
> [    1.658434] pci 0000:04:00.0: reg 20 64bit mmio pref: [0xf4ef0000-0xf4efffff]
> [    1.658441] pci 0000:04:00.0: reg 30 32bit mmio pref: [0xfb5c0000-0xfb5dffff]
> [    1.658477] pci 0000:04:00.0: supports D1 D2
> [    1.658479] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.658537] pci 0000:04:00.0: PME# disabled
> [    1.658636] pci 0000:00:1c.2: bridge io port: [0xd000-0xdfff]
> [    1.658639] pci 0000:00:1c.2: bridge 32bit mmio: [0xfb500000-0xfb5fffff]
> [    1.658644] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xf4e00000-0xf4efffff]
> [    1.658674] pci 0000:06:00.0: reg 10 32bit mmio: [0xfb6f8000-0xfb6fffff]
> [    1.658745] pci 0000:06:01.0: reg 10 32bit mmio: [0x000000-0x000fff]
> [    1.658763] pci 0000:06:01.0: supports D1 D2
> [    1.658764] pci 0000:06:01.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.658822] pci 0000:06:01.0: PME# disabled
> [    1.658913] pci 0000:00:1e.0: transparent bridge
> [    1.658967] pci 0000:00:1e.0: bridge io port: [0xe000-0xefff]
> [    1.658970] pci 0000:00:1e.0: bridge 32bit mmio: [0xfb600000-0xfbefffff]
> [    1.658975] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf5000000-0xf6ffffff]
> [    1.659009] pci_bus 0000:00: on NUMA node 0
> [    1.659013] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    1.659257] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> [    1.659352] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> [    1.659405] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
> [    1.659463] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
> [    1.659512] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
> [    1.659560] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
> [    1.684264] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 14 15)
> [    1.684761] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
> [    1.685008] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12 14 15)
> [    1.685504] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 *14 15)
> [    1.685999] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 *15)
> [    1.686496] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 6 7 10 11 12 14 15)
> [    1.686991] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 *7 10 11 12 14 15)
> [    1.687487] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 6 7 10 11 12 14 15)
> [    1.687956] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
> [    1.688028] vgaarb: loaded
> [    1.688137] SCSI subsystem initialized
> [    1.688296] libata version 3.00 loaded.
> [    1.688342] usbcore: registered new interface driver usbfs
> [    1.688405] usbcore: registered new interface driver hub
> [    1.688474] usbcore: registered new device driver usb
> [    1.688618] ACPI: WMI: Mapper loaded
> [    1.688668] PCI: Using ACPI for IRQ routing
> [    1.688846] Bluetooth: Core ver 2.15
> [    1.688916] NET: Registered protocol family 31
> [    1.688968] Bluetooth: HCI device and connection manager initialized
> [    1.689024] Bluetooth: HCI socket layer initialized
> [    1.689076] NET: Registered protocol family 8
> [    1.689128] NET: Registered protocol family 20
> [    1.689185] NetLabel: Initializing
> [    1.689235] NetLabel:  domain hash size = 128
> [    1.689286] NetLabel:  protocols = UNLABELED CIPSOv4
> [    1.689347] NetLabel:  unlabeled traffic allowed by default
> [    1.689424] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [    1.689631] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
> [    1.750486] Switching to clocksource tsc
> [    1.751759] pnp: PnP ACPI init
> [    1.751822] ACPI: bus type pnp registered
> [    1.754433] pnp: PnP ACPI: found 15 devices
> [    1.754486] ACPI: ACPI bus type pnp unregistered
> [    1.754544] system 00:01: iomem range 0xfbf00000-0xfbffffff has been reserved
> [    1.754602] system 00:01: iomem range 0xfc000000-0xfcffffff has been reserved
> [    1.754659] system 00:01: iomem range 0xfd000000-0xfdffffff has been reserved
> [    1.754716] system 00:01: iomem range 0xfe000000-0xfebfffff has been reserved
> [    1.754773] system 00:01: iomem range 0xfec8a000-0xfec8afff could not be reserved
> [    1.754843] system 00:01: iomem range 0xfed10000-0xfed10fff has been reserved
> [    1.754903] system 00:07: ioport range 0x290-0x29f has been reserved
> [    1.754961] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
> [    1.755016] system 00:08: ioport range 0x800-0x87f has been reserved
> [    1.755073] system 00:08: ioport range 0x500-0x57f could not be reserved
> [    1.755129] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
> [    1.755186] system 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
> [    1.755243] system 00:08: iomem range 0xfed40000-0xfed8ffff has been reserved
> [    1.755302] system 00:0b: iomem range 0xffc00000-0xffdfffff has been reserved
> [    1.755360] system 00:0c: iomem range 0xfec00000-0xfec00fff could not be reserved
> [    1.755431] system 00:0c: iomem range 0xfee00000-0xfee00fff has been reserved
> [    1.755489] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
> [    1.755548] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
> [    1.755604] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
> [    1.755660] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
> [    1.755716] system 00:0e: iomem range 0x100000-0xbfefffff could not be reserved
> [    1.755787] system 00:0e: iomem range 0xfed90000-0xffffffff could not be reserved
> [    1.760488] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
> [    1.760543] pci 0000:00:01.0:   IO window: disabled
> [    1.760597] pci 0000:00:01.0:   MEM window: disabled
> [    1.760652] pci 0000:00:01.0:   PREFETCH window: disabled
> [    1.760707] pci 0000:00:03.0: PCI bridge, secondary bus 0000:02
> [    1.760762] pci 0000:00:03.0:   IO window: 0xc000-0xcfff
> [    1.760818] pci 0000:00:03.0:   MEM window: 0xf8000000-0xfb4fffff
> [    1.761617] pci 0000:00:03.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
> [    1.761691] pci 0000:00:07.0: PCI bridge, secondary bus 0000:03
> [    1.761745] pci 0000:00:07.0:   IO window: disabled
> [    1.761800] pci 0000:00:07.0:   MEM window: disabled
> [    1.761854] pci 0000:00:07.0:   PREFETCH window: disabled
> [    1.761909] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:05
> [    1.761965] pci 0000:00:1c.0:   IO window: 0x1000-0x1fff
> [    1.762021] pci 0000:00:1c.0:   MEM window: 0xc0000000-0xc03fffff
> [    1.762078] pci 0000:00:1c.0:   PREFETCH window: 0x000000f4f00000-0x000000f4ffffff
> [    1.762152] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
> [    1.762207] pci 0000:00:1c.2:   IO window: 0xd000-0xdfff
> [    1.762263] pci 0000:00:1c.2:   MEM window: 0xfb500000-0xfb5fffff
> [    1.762320] pci 0000:00:1c.2:   PREFETCH window: 0x000000f4e00000-0x000000f4efffff
> [    1.762399] pci 0000:06:01.0: CardBus bridge, secondary bus 0000:07
> [    1.762454] pci 0000:06:01.0:   IO window: 0x00e000-0x00e0ff
> [    1.762510] pci 0000:06:01.0:   IO window: 0x00e400-0x00e4ff
> [    1.762568] pci 0000:06:01.0:   PREFETCH window: 0xc4000000-0xc7ffffff
> [    1.762625] pci 0000:06:01.0:   MEM window: 0xc8000000-0xcbffffff
> [    1.762682] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
> [    1.762738] pci 0000:00:1e.0:   IO window: 0xe000-0xefff
> [    1.762794] pci 0000:00:1e.0:   MEM window: 0xfb600000-0xfbefffff
> [    1.762851] pci 0000:00:1e.0:   PREFETCH window: 0x000000f5000000-0x000000f6ffffff
> [    1.762931] pci 0000:00:01.0: setting latency timer to 64
> [    1.762937] pci 0000:00:03.0: setting latency timer to 64
> [    1.762944] pci 0000:00:07.0: setting latency timer to 64
> [    1.762950] pci 0000:00:1c.0: enabling device (0106 -> 0107)
> [    1.763009] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    1.763066] pci 0000:00:1c.0: setting latency timer to 64
> [    1.763074] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    1.763131] pci 0000:00:1c.2: setting latency timer to 64
> [    1.763136] pci 0000:00:1e.0: setting latency timer to 64
> [    1.763143] pci 0000:06:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    1.763203] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> [    1.763204] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
> [    1.763206] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
> [    1.763208] pci_bus 0000:02: resource 1 mem: [0xf8000000-0xfb4fffff]
> [    1.763209] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdfffffff]
> [    1.763211] pci_bus 0000:05: resource 0 io:  [0x1000-0x1fff]
> [    1.763213] pci_bus 0000:05: resource 1 mem: [0xc0000000-0xc03fffff]
> [    1.763214] pci_bus 0000:05: resource 2 pref mem [0xf4f00000-0xf4ffffff]
> [    1.763216] pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]
> [    1.763218] pci_bus 0000:04: resource 1 mem: [0xfb500000-0xfb5fffff]
> [    1.763219] pci_bus 0000:04: resource 2 pref mem [0xf4e00000-0xf4efffff]
> [    1.763221] pci_bus 0000:06: resource 0 io:  [0xe000-0xefff]
> [    1.763222] pci_bus 0000:06: resource 1 mem: [0xfb600000-0xfbefffff]
> [    1.763224] pci_bus 0000:06: resource 2 pref mem [0xf5000000-0xf6ffffff]
> [    1.763225] pci_bus 0000:06: resource 3 io:  [0x00-0xffff]
> [    1.763227] pci_bus 0000:06: resource 4 mem: [0x000000-0xffffffffffffffff]
> [    1.763229] pci_bus 0000:07: resource 0 io:  [0xe000-0xe0ff]
> [    1.763230] pci_bus 0000:07: resource 1 io:  [0xe400-0xe4ff]
> [    1.763232] pci_bus 0000:07: resource 2 pref mem [0xc4000000-0xc7ffffff]
> [    1.763233] pci_bus 0000:07: resource 3 mem: [0xc8000000-0xcbffffff]
> [    1.763258] NET: Registered protocol family 2
> [    1.763380] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    1.763962] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> [    1.764625] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    1.764814] TCP: Hash tables configured (established 262144 bind 65536)
> [    1.764870] TCP reno registered
> [    1.764987] NET: Registered protocol family 1
> [    1.765187] pci 0000:02:00.0: Boot video device
> [    1.765224] Trying to unpack rootfs image as initramfs...
> [    1.891482] Freeing initrd memory: 7709k freed
> [    1.892896] Scanning for low memory corruption every 60 seconds
> [    1.893034] audit: initializing netlink socket (disabled)
> [    1.893096] type=2000 audit(1257354651.780:1): initialized
> [    1.896800] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    1.897814] VFS: Disk quotas dquot_6.5.2
> [    1.897912] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    1.898380] fuse init (API version 7.13)
> [    1.898484] msgmni has been set to 24021
> [    1.898725] alg: No test for stdrng (krng)
> [    1.898783] io scheduler noop registered
> [    1.898834] io scheduler anticipatory registered
> [    1.898887] io scheduler deadline registered
> [    1.898948] io scheduler cfq registered (default)
> [    1.899099] pcieport 0000:00:01.0: irq 48 for MSI/MSI-X
> [    1.899106] pcieport 0000:00:01.0: setting latency timer to 64
> [    1.899198] pcieport 0000:00:03.0: irq 49 for MSI/MSI-X
> [    1.899203] pcieport 0000:00:03.0: setting latency timer to 64
> [    1.899291] pcieport 0000:00:07.0: irq 50 for MSI/MSI-X
> [    1.899296] pcieport 0000:00:07.0: setting latency timer to 64
> [    1.899382] pcieport 0000:00:1c.0: irq 51 for MSI/MSI-X
> [    1.899389] pcieport 0000:00:1c.0: setting latency timer to 64
> [    1.899481] pcieport 0000:00:1c.2: irq 52 for MSI/MSI-X
> [    1.899488] pcieport 0000:00:1c.2: setting latency timer to 64
> [    1.899550] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
> [    1.899556] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
> [    1.899560] aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
> [    1.899565] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    1.899677] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    1.899821] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
> [    1.899894] ACPI: Power Button [PWRB]
> [    1.899971] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    1.900041] ACPI: Power Button [PWRF]
> [    1.900779] ACPI: SSDT 00000000bf6980c0 00403 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
> [    1.901312] ACPI: SSDT 00000000bf69a140 003B2 (v01  PmRef  P001Cst 00003001 INTL 20060113)
> [    1.903931] Monitor-Mwait will be used to enter C-1 state
> [    1.903950] Monitor-Mwait will be used to enter C-2 state
> [    1.903966] Monitor-Mwait will be used to enter C-3 state
> [    1.904005] processor LNXCPU:00: registered as cooling_device0
> [    1.904450] ACPI: SSDT 00000000bf6984d0 00403 (v01 DpgPmm  P002Ist 00000012 INTL 20060113)
> [    1.904915] ACPI: SSDT 00000000bf69a500 00085 (v01  PmRef  P002Cst 00003000 INTL 20060113)
> [    1.907543] processor LNXCPU:01: registered as cooling_device1
> [    1.907995] ACPI: SSDT 00000000bf6988e0 00403 (v01 DpgPmm  P003Ist 00000012 INTL 20060113)
> [    1.908469] ACPI: SSDT 00000000bf69a590 00085 (v01  PmRef  P003Cst 00003000 INTL 20060113)
> [    1.911096] processor LNXCPU:02: registered as cooling_device2
> [    1.911552] ACPI: SSDT 00000000bf698cf0 00403 (v01 DpgPmm  P004Ist 00000012 INTL 20060113)
> [    1.912027] ACPI: SSDT 00000000bf69a620 00085 (v01  PmRef  P004Cst 00003000 INTL 20060113)
> [    1.914645] processor LNXCPU:03: registered as cooling_device3
> [    1.915099] ACPI: SSDT 00000000bf699100 00403 (v01 DpgPmm  P005Ist 00000012 INTL 20060113)
> [    1.915568] ACPI: SSDT 00000000bf69a6b0 00085 (v01  PmRef  P005Cst 00003000 INTL 20060113)
> [    1.918189] processor LNXCPU:04: registered as cooling_device4
> [    1.918648] ACPI: SSDT 00000000bf699510 00403 (v01 DpgPmm  P006Ist 00000012 INTL 20060113)
> [    1.919126] ACPI: SSDT 00000000bf69a740 00085 (v01  PmRef  P006Cst 00003000 INTL 20060113)
> [    1.921743] processor LNXCPU:05: registered as cooling_device5
> [    1.922204] ACPI: SSDT 00000000bf699920 00403 (v01 DpgPmm  P007Ist 00000012 INTL 20060113)
> [    1.922689] ACPI: SSDT 00000000bf69a7d0 00085 (v01  PmRef  P007Cst 00003000 INTL 20060113)
> [    1.925315] processor LNXCPU:06: registered as cooling_device6
> [    1.925763] ACPI: SSDT 00000000bf699d30 00403 (v01 DpgPmm  P008Ist 00000012 INTL 20060113)
> [    1.926237] ACPI: SSDT 00000000bf69a860 00085 (v01  PmRef  P008Cst 00003000 INTL 20060113)
> [    1.928864] processor LNXCPU:07: registered as cooling_device7
> [    1.931249] XENFS: not registering filesystem on non-xen platform
> [    1.932027] Linux agpgart interface v0.103
> [    1.932080] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    1.932934] brd: module loaded
> [    1.933258] loop: module loaded
> [    1.933351] input: Macintosh mouse button emulation as /devices/virtual/input/input2
> [    1.933507] ata_piix 0000:00:1f.2: version 2.13
> [    1.933522] ata_piix 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
> [    1.933581] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> [    1.933811] ata_piix 0000:00:1f.2: setting latency timer to 64
> [    1.933848] scsi0 : ata_piix
> [    1.933941] scsi1 : ata_piix
> [    1.935195] ata1: SATA max UDMA/133 cmd 0xa000 ctl 0x9c00 bmdma 0x9480 irq 20
> [    1.935256] ata2: SATA max UDMA/133 cmd 0x9880 ctl 0x9800 bmdma 0x9488 irq 20
> [    1.935327] ata_piix 0000:00:1f.5: PCI INT B -> GSI 20 (level, low) -> IRQ 20
> [    1.935386] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
> [    1.935612] ata_piix 0000:00:1f.5: setting latency timer to 64
> [    1.935636] scsi2 : ata_piix
> [    1.935715] scsi3 : ata_piix
> [    1.936749] ata3: SATA max UDMA/133 cmd 0xb000 ctl 0xac00 bmdma 0xa480 irq 20
> [    1.936808] ata4: SATA max UDMA/133 cmd 0xa880 ctl 0xa800 bmdma 0xa488 irq 20
> [    1.937235] Fixed MDIO Bus: probed
> [    1.937287] PPP generic driver version 2.4.2
> [    1.937389] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    1.937458] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    1.937524] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [    1.937527] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    1.937606] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
> [    1.937693] ehci_hcd 0000:00:1a.7: debug port 1
> [    1.941631] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
> [    1.941641] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf7fff000
> [    1.964967] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    1.965077] usb usb1: configuration #1 chosen from 1 choice
> [    1.965148] hub 1-0:1.0: USB hub found
> [    1.965201] hub 1-0:1.0: 6 ports detected
> [    1.965296] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    1.965360] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    1.965362] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    1.965433] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
> [    1.965519] ehci_hcd 0000:00:1d.7: debug port 1
> [    1.969454] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> [    1.969463] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7ffe000
> [    1.994950] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    1.995047] usb usb2: configuration #1 chosen from 1 choice
> [    1.995115] hub 2-0:1.0: USB hub found
> [    1.995168] hub 2-0:1.0: 6 ports detected
> [    1.995257] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    1.995321] uhci_hcd: USB Universal Host Controller Interface driver
> [    1.995411] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    1.995471] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    1.995473] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    1.995547] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
> [    1.995642] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b800
> [    1.995744] usb usb3: configuration #1 chosen from 1 choice
> [    1.995812] hub 3-0:1.0: USB hub found
> [    1.995865] hub 3-0:1.0: 2 ports detected
> [    1.995947] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    1.996007] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [    1.996009] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    1.996079] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
> [    1.996174] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b880
> [    1.996272] usb usb4: configuration #1 chosen from 1 choice
> [    1.996341] hub 4-0:1.0: USB hub found
> [    1.996393] hub 4-0:1.0: 2 ports detected
> [    1.996474] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
> [    1.996533] uhci_hcd 0000:00:1a.2: setting latency timer to 64
> [    1.996536] uhci_hcd 0000:00:1a.2: UHCI Host Controller
> [    1.996605] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
> [    1.996698] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000bc00
> [    1.996798] usb usb5: configuration #1 chosen from 1 choice
> [    1.996867] hub 5-0:1.0: USB hub found
> [    1.996919] hub 5-0:1.0: 2 ports detected
> [    1.997002] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    1.997062] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    1.997064] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    1.997134] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
> [    1.997222] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b080
> [    1.997321] usb usb6: configuration #1 chosen from 1 choice
> [    1.997388] hub 6-0:1.0: USB hub found
> [    1.997441] hub 6-0:1.0: 2 ports detected
> [    1.997521] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    1.997580] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    1.997582] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    1.998395] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
> [    1.998484] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b400
> [    1.998584] usb usb7: configuration #1 chosen from 1 choice
> [    1.998652] hub 7-0:1.0: USB hub found
> [    1.998706] hub 7-0:1.0: 2 ports detected
> [    1.998786] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    1.998845] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    1.998848] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    1.998921] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
> [    1.999009] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b480
> [    1.999112] usb usb8: configuration #1 chosen from 1 choice
> [    1.999180] hub 8-0:1.0: USB hub found
> [    1.999233] hub 8-0:1.0: 2 ports detected
> [    1.999344] PNP: No PS/2 controller found. Probing ports directly.
> [    2.001923] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    2.001983] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    2.002077] mice: PS/2 mouse device common for all mice
> [    2.002173] Driver 'rtc_cmos' needs updating - please use bus_type methods
> [    2.002244] rtc_cmos 00:03: RTC can wake from S4
> [    2.002315] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [    2.002391] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    2.002531] device-mapper: uevent: version 1.0.3
> [    2.002632] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
> [    2.002793] device-mapper: multipath: version 1.1.0 loaded
> [    2.002857] device-mapper: multipath round-robin: version 1.0.0 loaded
> [    2.003256] cpuidle: using governor ladder
> [    2.003551] cpuidle: using governor menu
> [    2.003897] TCP cubic registered
> [    2.004033] NET: Registered protocol family 10
> [    2.004429] lo: Disabled Privacy Extensions
> [    2.004705] NET: Registered protocol family 17
> [    2.004767] Bluetooth: L2CAP ver 2.14
> [    2.004817] Bluetooth: L2CAP socket layer initialized
> [    2.004871] Bluetooth: SCO (Voice Link) ver 0.6
> [    2.004923] Bluetooth: SCO socket layer initialized
> [    2.005015] Bluetooth: RFCOMM TTY layer initialized
> [    2.005070] Bluetooth: RFCOMM socket layer initialized
> [    2.005123] Bluetooth: RFCOMM ver 1.11
> [    2.009780] PM: Resume from disk failed.
> [    2.009787] registered taskstats version 1
> [    2.010229]   Magic number: 1:749:187
> [    2.010394] rtc_cmos 00:03: setting system clock to 2009-11-04 17:10:52 UTC (1257354652)
> [    2.010469] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    2.010523] EDD information not available.
> [    2.291460] ata3: SATA link down (SStatus 0 SControl 300)
> [    2.440581] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.460932] ata4.00: ATA-7: SAMSUNG HD103UJ, 1AA01118, max UDMA7
> [    2.460995] ata4.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    2.480924] ata4.00: configured for UDMA/133
> [    2.624790] usb 3-2: new low speed USB device using uhci_hcd and address 2
> [    2.790398] ata1.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    2.790473] ata1.01: SATA link down (SStatus 0 SControl 300)
> [    2.790539] ata1.01: link offline, clearing class 3 to NONE
> [    2.790702] ata2.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.790766] ata2.01: SATA link down (SStatus 0 SControl 300)
> [    2.810800] ata1.00: ATAPI: TSSTcorp CDDVDW SH-S223B, SB01, max UDMA/100
> [    2.810907] ata2.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
> [    2.810963] ata2.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    2.813565] usb 3-2: configuration #1 chosen from 1 choice
> [    2.830794] ata2.00: configured for UDMA/133
> [    2.850545] ata1.00: configured for UDMA/100
> [    2.851842] scsi 0:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S223B  SB01 PQ: 0 ANSI: 5
> [    2.855851] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
> [    2.855930] Uniform CD-ROM driver Revision: 3.20
> [    2.856045] sr 0:0:0:0: Attached scsi CD-ROM sr0
> [    2.856072] sr 0:0:0:0: Attached scsi generic sg0 type 5
> [    2.856276] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD154UI  1AG0 PQ: 0 ANSI: 5
> [    2.856443] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    2.856600] sd 1:0:0:0: [sda] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
> [    2.856643] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
> [    2.856705] sd 3:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
> [    2.856732] sd 3:0:0:0: [sdb] Write Protect is off
> [    2.856733] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    2.856748] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    2.856819]  sdb:
> [    2.856918] sd 3:0:0:0: Attached scsi generic sg2 type 0
> [    2.857085] sd 1:0:0:0: [sda] Write Protect is off
> [    2.857141] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.857155] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    2.857297]  sda: unknown partition table
> [    2.867728] sd 1:0:0:0: [sda] Attached SCSI disk
> [    2.867991]  sdb1 sdb2 < sdb5 >
> [    2.890655] sd 3:0:0:0: [sdb] Attached SCSI disk
> [    2.890764] Freeing unused kernel memory: 540k freed
> [    2.890902] Write protecting the kernel read-only data: 7552k
> [    2.960902] Floppy drive(s): fd0 is 1.44M
> [    2.966532] usbcore: registered new interface driver hiddev
> [    2.969771] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [    2.969849] r8169 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [    2.969997] r8169 0000:04:00.0: setting latency timer to 64
> [    2.970049] r8169 0000:04:00.0: irq 53 for MSI/MSI-X
> [    2.970576] eth0: RTL8168c/8111c at 0xffffc9000007e000, 00:24:8c:a7:6e:2d, XID 1c4000c0 IRQ 53
> [    2.976467] FDC 0 is a post-1991 82077
> [    2.985611] input: Cherry GmbH Cherry TouchBoard as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.0/input/input3
> [    2.985723] generic-usb 0003:046A:002F.0001: input,hidraw0: USB HID v1.11 Keyboard [Cherry GmbH Cherry TouchBoard] on usb-0000:00:1a.0-2/input0
> [    3.010571] input: Cherry GmbH Cherry TouchBoard as /devices/pci0000:00/0000:00:1a.0/usb3/3-2/3-2:1.1/input/input4
> [    3.010689] generic-usb 0003:046A:002F.0002: input,hidraw1: USB HID v1.11 Mouse [Cherry GmbH Cherry TouchBoard] on usb-0000:00:1a.0-2/input1
> [    3.010780] usbcore: registered new interface driver usbhid
> [    3.010880] usbhid: v2.6:USB HID core driver
> [    3.140904] usb 6-2: new full speed USB device using uhci_hcd and address 2
> [    3.324942] usb 6-2: configuration #1 chosen from 1 choice
> [    4.079158] PM: Starting manual resume from disk
> [    4.079161] PM: Resume from partition 8:21
> [    4.079162] PM: Checking hibernation image.
> [    4.079367] PM: Error -22 checking image file
> [    4.079370] PM: Resume from disk failed.
> [    4.142309] EXT4-fs (sdb1): mounted filesystem with ordered data mode
> [    6.625698] Adding 2000052k swap on /dev/sdb5.  Priority:-1 extents:1 across:2000052k 
> [    7.849284] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
> [    7.855346] SGI XFS Quota Management subsystem
> [    7.886584] XFS mounting filesystem sda
> [    8.020792] Ending clean XFS mount for filesystem: sda
> [    8.823748] udev: starting version 147
> [    9.710498] nvidia: module license 'NVIDIA' taints kernel.
> [    9.710501] Disabling lock debugging due to kernel taint
> [   10.156989] cfg80211: Calling CRDA to update world regulatory domain
> [   10.171979] yenta_cardbus 0000:06:01.0: CardBus bridge found [1524:1410]
> [   10.171997] yenta_cardbus 0000:06:01.0: Using CSCINT to route CSC interrupts to PCI
> [   10.171999] yenta_cardbus 0000:06:01.0: Routing CardBus interrupts to PCI
> [   10.172004] yenta_cardbus 0000:06:01.0: TI: mfunc 0x00001002, devctl 0x44
> [   10.173900] nvidia 0000:02:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
> [   10.173905] nvidia 0000:02:00.0: setting latency timer to 64
> [   10.174023] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  185.18.36  Fri Aug 14 17:35:21 PDT 2009
> [   10.418185] yenta_cardbus 0000:06:01.0: ISA IRQ mask 0x0000, PCI irq 17
> [   10.418188] yenta_cardbus 0000:06:01.0: Socket status: 30000020
> [   10.418191] pci_bus 0000:06: Raising subordinate bus# of parent bus (#06) from #07 to #0a
> [   10.418196] yenta_cardbus 0000:06:01.0: pcmcia: parent PCI bridge I/O window: 0xe000 - 0xefff
> [   10.418198] yenta_cardbus 0000:06:01.0: pcmcia: parent PCI bridge Memory window: 0xfb600000 - 0xfbefffff
> [   10.418200] yenta_cardbus 0000:06:01.0: pcmcia: parent PCI bridge Memory window: 0xf5000000 - 0xf6ffffff
> [   10.540799] lp: driver loaded but no devices found
> [   10.942281] rt61pci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   10.949231] phy0 -> rt61pci_validate_eeprom: EEPROM recovery - NIC: 0xff80
> [   10.949233] phy0 -> rt61pci_validate_eeprom: EEPROM recovery - Led: 0xe0ff
> [   10.949235] phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 0302, rf: 0003, rev: 0002561c.
> [   10.961990] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   11.048748] cfg80211: World regulatory domain updated:
> [   11.048750] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [   11.048751] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   11.048753] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [   11.048755] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [   11.048756] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   11.048758] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   11.081556] pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
> [   11.081584] pci 0000:07:00.0: reg 10 32bit mmio: [0x000000-0x00ffff]
> [   11.081645] yenta_cardbus 0000:06:01.0: EnE: chaning testregister 0xC9, 0e -> 0c
> [   11.210391] phy0: Selected rate control algorithm 'minstrel'
> [   11.210928] Registered led device: rt61pci-phy0::radio
> [   11.210966] Registered led device: rt61pci-phy0::assoc
> [   11.426723] usbcore: registered new interface driver snd-usb-audio
> [   11.427862] coretemp coretemp.0: Unable to access MSR 0xEE, for Tjmax, left at default
> [   11.427898] coretemp coretemp.1: Unable to access MSR 0xEE, for Tjmax, left at default
> [   11.427991] coretemp coretemp.2: Unable to access MSR 0xEE, for Tjmax, left at default
> [   11.428087] coretemp coretemp.3: Unable to access MSR 0xEE, for Tjmax, left at default
> [   11.428125] coretemp coretemp.4: Unable to access MSR 0xEE, for Tjmax, left at default
> [   11.428157] coretemp coretemp.5: Unable to access MSR 0xEE, for Tjmax, left at default
> [   11.428184] coretemp coretemp.6: Unable to access MSR 0xEE, for Tjmax, left at default
> [   11.428271] coretemp coretemp.7: Unable to access MSR 0xEE, for Tjmax, left at default
> [   11.441678] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> [   11.441852] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [   11.484954] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [   11.485278] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
> [   11.485280] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
> [   11.485281] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
> [   11.513347] RME Hammerfall DSP 0000:07:00.0: enabling device (0000 -> 0002)
> [   11.513353] RME Hammerfall DSP 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   11.603683] hda_codec: ALC1200: BIOS auto-probing.
> [   13.389405] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [   13.986143] Hammerfall-DSP: Firmware already present, initializing card.
> [   15.184533] r8169: eth0: link down
> [   15.185650] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   15.387562] phy0 -> rt2x00lib_request_firmware: Info - Loading firmware file 'rt2561.bin'.
> [   15.387565] rt61pci 0000:06:00.0: firmware: requesting rt2561.bin
> [   15.544241] phy0 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 0.8.
> [   15.676621] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
> [   15.676628] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
> [   15.676634] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
> [   15.676640] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
> [   15.677679] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   25.297686] ppdev: user-space parallel port driver
> [   28.107305] CPU0 attaching NULL sched-domain.
> [   28.107309] CPU1 attaching NULL sched-domain.
> [   28.107310] CPU2 attaching NULL sched-domain.
> [   28.107312] CPU3 attaching NULL sched-domain.
> [   28.107313] CPU4 attaching NULL sched-domain.
> [   28.107314] CPU5 attaching NULL sched-domain.
> [   28.107316] CPU6 attaching NULL sched-domain.
> [   28.107317] CPU7 attaching NULL sched-domain.
> [   28.190785] CPU0 attaching sched-domain:
> [   28.190787]  domain 0: span 0,4 level SIBLING
> [   28.190789]   groups: 0 (cpu_power = 589) 4 (cpu_power = 589)
> [   28.190792]   domain 1: span 0-7 level MC
> [   28.190794]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
> [   28.190800] CPU1 attaching sched-domain:
> [   28.190801]  domain 0: span 1,5 level SIBLING
> [   28.190802]   groups: 1 (cpu_power = 589) 5 (cpu_power = 589)
> [   28.190805]   domain 1: span 0-7 level MC
> [   28.190806]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
> [   28.190812] CPU2 attaching sched-domain:
> [   28.190813]  domain 0: span 2,6 level SIBLING
> [   28.190814]   groups: 2 (cpu_power = 589) 6 (cpu_power = 589)
> [   28.190817]   domain 1: span 0-7 level MC
> [   28.190818]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
> [   28.190823] CPU3 attaching sched-domain:
> [   28.190824]  domain 0: span 3,7 level SIBLING
> [   28.190826]   groups: 3 (cpu_power = 589) 7 (cpu_power = 589)
> [   28.190829]   domain 1: span 0-7 level MC
> [   28.190830]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
> [   28.190835] CPU4 attaching sched-domain:
> [   28.190836]  domain 0: span 0,4 level SIBLING
> [   28.190837]   groups: 4 (cpu_power = 589) 0 (cpu_power = 589)
> [   28.190840]   domain 1: span 0-7 level MC
> [   28.190842]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
> [   28.190847] CPU5 attaching sched-domain:
> [   28.190848]  domain 0: span 1,5 level SIBLING
> [   28.190849]   groups: 5 (cpu_power = 589) 1 (cpu_power = 589)
> [   28.190852]   domain 1: span 0-7 level MC
> [   28.190853]    groups: 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178)
> [   28.190859] CPU6 attaching sched-domain:
> [   28.190860]  domain 0: span 2,6 level SIBLING
> [   28.190861]   groups: 6 (cpu_power = 589) 2 (cpu_power = 589)
> [   28.190864]   domain 1: span 0-7 level MC
> [   28.190865]    groups: 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178)
> [   28.190870] CPU7 attaching sched-domain:
> [   28.190871]  domain 0: span 3,7 level SIBLING
> [   28.190873]   groups: 7 (cpu_power = 589) 3 (cpu_power = 589)
> [   28.190876]   domain 1: span 0-7 level MC
> [   28.190877]    groups: 3,7 (cpu_power = 1178) 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178)
> [   86.409045] wlan0: deauthenticating from 00:24:fe:09:94:18 by local choice (reason=3)
> [   86.409209] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 1)
> [   86.412957] wlan0: direct probe responded
> [   86.412962] wlan0: authenticate with AP 00:24:fe:09:94:18 (try 1)
> [   86.416343] wlan0: authenticated
> [   86.416361] wlan0: associate with AP 00:24:fe:09:94:18 (try 1)
> [   86.419280] wlan0: RX AssocResp from 00:24:fe:09:94:18 (capab=0x401 status=0 aid=2)
> [   86.419282] wlan0: associated
> [   86.420465] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   88.872600] phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
> [   88.872604] Please file bug report to http://rt2x00.serialmonkey.com.
> [   97.096637] wlan0: no IPv6 routers present
> [  631.853445] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [  631.853456] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [  631.853466] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [  631.853475] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [  631.929711] wlan0: deauthenticating from 00:24:fe:09:94:18 by local choice (reason=3)
> [  631.929750] wlan0: deauthenticating from 00:24:fe:09:94:18 by local choice (reason=3)
> [  631.948559] wlan0: direct probe to AP 00:14:6c:5a:96:60 (try 1)
> [  631.950289] wlan0: direct probe responded
> [  631.950293] wlan0: authenticate with AP 00:14:6c:5a:96:60 (try 1)
> [  631.954044] wlan0: authenticated
> [  631.991386] wlan0: associate with AP 00:14:6c:5a:96:60 (try 1)
> [  631.993618] wlan0: RX ReassocResp from 00:14:6c:5a:96:60 (capab=0x401 status=0 aid=1)
> [  631.993622] wlan0: associated
> [  631.993934] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [  631.993942] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [  631.993950] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [  631.993958] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [  677.910672] wlan0: deauthenticated from 00:14:6c:5a:96:60 (Reason: 7)
> [  677.910685] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [  677.910693] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [  677.910701] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [  677.910709] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [  679.458583] wlan0: deauthenticating from 00:14:6c:5a:96:60 by local choice (reason=3)
> [  679.478323] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 1)
> [  679.480351] wlan0: direct probe responded
> [  679.480355] wlan0: authenticate with AP 00:24:fe:09:94:18 (try 1)
> [  679.482828] wlan0: authenticated
> [  679.482848] wlan0: associate with AP 00:24:fe:09:94:18 (try 1)
> [  679.485996] wlan0: RX ReassocResp from 00:24:fe:09:94:18 (capab=0x401 status=0 aid=2)
> [  679.486000] wlan0: associated
> [  871.756709] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [  871.756719] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [  871.756726] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [  871.756734] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [  871.834625] wlan0: deauthenticating from 00:24:fe:09:94:18 by local choice (reason=3)
> [  871.834666] wlan0: deauthenticating from 00:24:fe:09:94:18 by local choice (reason=3)
> [  871.854802] wlan0: direct probe to AP 00:14:6c:5a:96:60 (try 1)
> [  871.856453] wlan0: direct probe responded
> [  871.856457] wlan0: authenticate with AP 00:14:6c:5a:96:60 (try 1)
> [  871.858184] wlan0: authenticated
> [  871.896378] wlan0: associate with AP 00:14:6c:5a:96:60 (try 1)
> [  871.898260] wlan0: RX ReassocResp from 00:14:6c:5a:96:60 (capab=0x401 status=0 aid=1)
> [  871.898264] wlan0: associated
> [  871.898875] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [  871.898909] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [  871.898919] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [  871.898929] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [  917.819830] wlan0: deauthenticated from 00:14:6c:5a:96:60 (Reason: 7)
> [  917.819843] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [  917.819851] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [  917.819859] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [  917.819866] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [  919.366662] wlan0: deauthenticating from 00:14:6c:5a:96:60 by local choice (reason=3)
> [  919.389718] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 1)
> [  919.586979] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 2)
> [  919.786869] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 3)
> [  919.986197] wlan0: direct probe to AP 00:24:fe:09:94:18 timed out
> [  925.773981] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 1)
> [  925.775992] wlan0: direct probe responded
> [  925.775996] wlan0: authenticate with AP 00:24:fe:09:94:18 (try 1)
> [  925.778936] wlan0: authenticated
> [  925.778955] wlan0: associate with AP 00:24:fe:09:94:18 (try 1)
> [  925.781540] wlan0: RX ReassocResp from 00:24:fe:09:94:18 (capab=0x401 status=0 aid=2)
> [  925.781543] wlan0: associated
> [  991.710855] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [  991.710864] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [  991.710873] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [  991.710880] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [  991.833019] wlan0: deauthenticating from 00:24:fe:09:94:18 by local choice (reason=3)
> [  991.833059] wlan0: deauthenticating from 00:24:fe:09:94:18 by local choice (reason=3)
> [  991.853052] wlan0: direct probe to AP 00:14:6c:5a:96:60 (try 1)
> [  991.854656] wlan0: direct probe responded
> [  991.854661] wlan0: authenticate with AP 00:14:6c:5a:96:60 (try 1)
> [  991.856415] wlan0: authenticated
> [  991.894763] wlan0: associate with AP 00:14:6c:5a:96:60 (try 1)
> [  991.902095] wlan0: RX ReassocResp from 00:14:6c:5a:96:60 (capab=0x401 status=0 aid=1)
> [  991.902100] wlan0: associated
> [  991.902605] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [  991.902613] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [  991.902621] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [  991.902629] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1037.776170] wlan0: deauthenticated from 00:14:6c:5a:96:60 (Reason: 7)
> [ 1037.776183] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1037.776192] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1037.776199] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1037.776207] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1039.320831] wlan0: deauthenticating from 00:14:6c:5a:96:60 by local choice (reason=3)
> [ 1039.340475] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 1)
> [ 1039.342469] wlan0: direct probe responded
> [ 1039.342473] wlan0: authenticate with AP 00:24:fe:09:94:18 (try 1)
> [ 1039.345279] wlan0: authenticated
> [ 1039.345299] wlan0: associate with AP 00:24:fe:09:94:18 (try 1)
> [ 1039.347910] wlan0: RX ReassocResp from 00:24:fe:09:94:18 (capab=0x401 status=0 aid=2)
> [ 1039.347914] wlan0: associated
> [ 1111.666903] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1111.666912] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1111.666921] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1111.666928] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1111.743367] wlan0: deauthenticating from 00:24:fe:09:94:18 by local choice (reason=3)
> [ 1111.743408] wlan0: deauthenticating from 00:24:fe:09:94:18 by local choice (reason=3)
> [ 1111.763503] wlan0: direct probe to AP 00:14:6c:5a:96:60 (try 1)
> [ 1111.963267] wlan0: direct probe to AP 00:14:6c:5a:96:60 (try 2)
> [ 1111.964988] wlan0: direct probe responded
> [ 1111.964992] wlan0: authenticate with AP 00:14:6c:5a:96:60 (try 1)
> [ 1111.966753] wlan0: authenticated
> [ 1111.966771] wlan0: associate with AP 00:14:6c:5a:96:60 (try 1)
> [ 1111.969096] wlan0: RX ReassocResp from 00:14:6c:5a:96:60 (capab=0x401 status=0 aid=1)
> [ 1111.969099] wlan0: associated
> [ 1111.969454] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1111.969461] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1111.969469] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1111.969477] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1155.736323] wlan0: deauthenticated from 00:14:6c:5a:96:60 (Reason: 7)
> [ 1155.736335] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1155.736344] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1155.736415] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1155.736424] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1157.285521] wlan0: deauthenticating from 00:14:6c:5a:96:60 by local choice (reason=3)
> [ 1157.305987] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 1)
> [ 1157.505130] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 2)
> [ 1157.705131] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 3)
> [ 1157.905642] wlan0: direct probe to AP 00:24:fe:09:94:18 timed out
> [ 1163.902756] wlan0: direct probe to AP 00:14:6c:5a:96:60 (try 1)
> [ 1163.904411] wlan0: direct probe responded
> [ 1163.904415] wlan0: authenticate with AP 00:14:6c:5a:96:60 (try 1)
> [ 1163.958044] wlan0: authenticated
> [ 1163.958063] wlan0: associate with AP 00:14:6c:5a:96:60 (try 1)
> [ 1163.962692] wlan0: RX ReassocResp from 00:14:6c:5a:96:60 (capab=0x401 status=0 aid=1)
> [ 1163.962695] wlan0: associated
> [ 1163.963009] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1163.963017] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1163.963025] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1163.963033] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1217.702957] wlan0: deauthenticated from 00:14:6c:5a:96:60 (Reason: 7)
> [ 1217.702969] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1217.702977] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1217.702985] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1217.702993] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1219.271545] wlan0: direct probe to AP 00:14:6c:5a:96:60 (try 1)
> [ 1219.273152] wlan0: direct probe responded
> [ 1219.273157] wlan0: authenticate with AP 00:14:6c:5a:96:60 (try 1)
> [ 1219.274939] wlan0: authenticated
> [ 1219.274960] wlan0: associate with AP 00:14:6c:5a:96:60 (try 1)
> [ 1219.277147] wlan0: RX ReassocResp from 00:14:6c:5a:96:60 (capab=0x401 status=0 aid=1)
> [ 1219.277150] wlan0: associated
> [ 1219.277480] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1219.277488] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1219.277496] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1219.277503] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1457.614602] wlan0: deauthenticated from 00:14:6c:5a:96:60 (Reason: 7)
> [ 1457.614615] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1457.614623] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1457.614631] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1457.614639] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1459.209592] wlan0: direct probe to AP 00:14:6c:5a:96:60 (try 1)
> [ 1459.211254] wlan0: direct probe responded
> [ 1459.211259] wlan0: authenticate with AP 00:14:6c:5a:96:60 (try 1)
> [ 1459.212978] wlan0: authenticated
> [ 1459.212996] wlan0: associate with AP 00:14:6c:5a:96:60 (try 1)
> [ 1459.215260] wlan0: RX ReassocResp from 00:14:6c:5a:96:60 (capab=0x401 status=0 aid=1)
> [ 1459.215263] wlan0: associated
> [ 1459.215769] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1459.215777] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1459.215785] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1459.215792] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1471.529821] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1471.529828] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1471.529835] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1471.529841] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1471.585463] wlan0: deauthenticating from 00:14:6c:5a:96:60 by local choice (reason=3)
> [ 1471.585501] wlan0: deauthenticating from 00:14:6c:5a:96:60 by local choice (reason=3)
> [ 1471.605499] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 1)
> [ 1471.607487] wlan0: direct probe responded
> [ 1471.607490] wlan0: authenticate with AP 00:24:fe:09:94:18 (try 1)
> [ 1471.610845] wlan0: authenticated
> [ 1471.666559] wlan0: associate with AP 00:24:fe:09:94:18 (try 1)
> [ 1471.669919] wlan0: RX ReassocResp from 00:24:fe:09:94:18 (capab=0x401 status=0 aid=2)
> [ 1471.669922] wlan0: associated
> [ 1591.481020] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1591.481029] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1591.481037] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1591.481045] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1591.562677] wlan0: deauthenticating from 00:24:fe:09:94:18 by local choice (reason=3)
> [ 1591.562722] wlan0: deauthenticating from 00:24:fe:09:94:18 by local choice (reason=3)
> [ 1591.582741] wlan0: direct probe to AP 00:14:6c:5a:96:60 (try 1)
> [ 1591.592157] wlan0: direct probe responded
> [ 1591.592161] wlan0: authenticate with AP 00:14:6c:5a:96:60 (try 1)
> [ 1591.594157] wlan0: authenticated
> [ 1591.624398] wlan0: associate with AP 00:14:6c:5a:96:60 (try 1)
> [ 1591.626246] wlan0: RX ReassocResp from 00:14:6c:5a:96:60 (capab=0x401 status=0 aid=1)
> [ 1591.626249] wlan0: associated
> [ 1591.626628] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1591.626636] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1591.626644] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1591.626652] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1656.653960] phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
> [ 1656.653963] Please file bug report to http://rt2x00.serialmonkey.com.
> [ 1755.419796] wlan0: deauthenticated from 00:14:6c:5a:96:60 (Reason: 7)
> [ 1755.419809] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1755.419817] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1755.419825] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1755.419833] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1756.967256] wlan0: deauthenticating from 00:14:6c:5a:96:60 by local choice (reason=3)
> [ 1756.985669] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 1)
> [ 1756.987739] wlan0: direct probe responded
> [ 1756.987744] wlan0: authenticate with AP 00:24:fe:09:94:18 (try 1)
> [ 1756.990263] wlan0: authenticated
> [ 1756.990282] wlan0: associate with AP 00:24:fe:09:94:18 (try 1)
> [ 1756.993557] wlan0: RX ReassocResp from 00:24:fe:09:94:18 (capab=0x401 status=0 aid=2)
> [ 1756.993561] wlan0: associated
> [ 1759.427571] phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
> [ 1759.427574] Please file bug report to http://rt2x00.serialmonkey.com.
> [ 1822.420522] phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
> [ 1822.420524] Please file bug report to http://rt2x00.serialmonkey.com.
> [ 1951.374836] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1951.374845] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1951.374873] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1951.374881] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [ 1951.451087] wlan0: deauthenticating from 00:24:fe:09:94:18 by local choice (reason=3)
> [ 1951.451126] wlan0: deauthenticating from 00:24:fe:09:94:18 by local choice (reason=3)
> [ 1951.471202] wlan0: direct probe to AP 00:14:6c:5a:96:60 (try 1)
> [ 1951.670923] wlan0: direct probe to AP 00:14:6c:5a:96:60 (try 2)
> [ 1951.672651] wlan0: direct probe responded
> [ 1951.672655] wlan0: authenticate with AP 00:14:6c:5a:96:60 (try 1)
> [ 1951.674408] wlan0: authenticated
> [ 1951.674427] wlan0: associate with AP 00:14:6c:5a:96:60 (try 1)
> [ 1951.676580] wlan0: RX ReassocResp from 00:14:6c:5a:96:60 (capab=0x401 status=0 aid=1)
> [ 1951.676583] wlan0: associated
> [ 1951.677126] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [ 1951.677134] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [ 1951.677142] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [ 1951.677150] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.




-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

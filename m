Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:36764 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757192Ab0EXOAW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 10:00:22 -0400
Date: Mon, 24 May 2010 16:59:41 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Silence debug prints when using adhoc mode
Message-ID: <20100524135940.GD19669@nalle>
References: <20100523162240.GZ19669@nalle> <1274688345.3743.2.camel@jlt3.sipsolutions.net> <20100524081455.GB19669@nalle> <1274689457.3743.15.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1274689457.3743.15.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 24, 2010 at 10:24:17AM +0200, Johannes Berg wrote:
> Do I even want to comment on that? In any case -- it's not supposed to
> be spamming you so we want to find the root cause. Can you enable
> verbose IBSS debug to hopefully see why it's happening?

With debug logging the problem seems to go away, I will try the timer
patch next:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.34 (root@totoro) (gcc version 4.4.4 (Debian 4.4.4-2) ) #3 SMP Mon May 24 16:43:52 EEST 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
[    0.000000]  BIOS-e820: 000000007f6d0000 - 000000007f6df000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f6df000 - 000000007f700000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
[    0.000000] DMI present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x7f6d0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DBFFF uncachable
[    0.000000]   DC000-DFFFF write-back
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F700000 mask FFFF00000 uncachable
[    0.000000]   2 base 07F800000 mask FFF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] initial memory mapped : 0 - 01800000
[    0.000000] found SMP MP-table at [c00f6810] f6810
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 3764f000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 00100000 - 00aa0ee3
[    0.000000] Move RAMDISK from 000000003764f000 - 0000000037fefee2 to 00100000 - 00aa0ee2
[    0.000000] ACPI: RSDP 000f67e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 7f6d14a0 00084 (v01 LENOVO TP-79    00002260  LTP 00000000)
[    0.000000] ACPI: FACP 7f6d1600 000F4 (v03 LENOVO TP-79    00002260 LNVO 00000001)
[    0.000000] ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 (20100121/tbfadt-526)
[    0.000000] ACPI Warning: Optional field Gpe1Block has zero address or length: 000000000000102C/0 (20100121/tbfadt-557)
[    0.000000] ACPI: DSDT 7f6d195e 0D467 (v01 LENOVO TP-79    00002260 MSFT 0100000E)
[    0.000000] ACPI: FACS 7f6f4000 00040
[    0.000000] ACPI: SSDT 7f6d17b4 001AA (v01 LENOVO TP-79    00002260 MSFT 0100000E)
[    0.000000] ACPI: ECDT 7f6dedc5 00052 (v01 LENOVO TP-79    00002260 LNVO 00000001)
[    0.000000] ACPI: TCPA 7f6dee17 00032 (v02 LENOVO TP-79    00002260 LNVO 00000001)
[    0.000000] ACPI: APIC 7f6dee49 00068 (v01 LENOVO TP-79    00002260 LNVO 00000001)
[    0.000000] ACPI: MCFG 7f6deeb1 0003C (v01 LENOVO TP-79    00002260 LNVO 00000001)
[    0.000000] ACPI: HPET 7f6deeed 00038 (v01 LENOVO TP-79    00002260 LNVO 00000001)
[    0.000000] ACPI: BOOT 7f6defd8 00028 (v01 LENOVO TP-79    00002260  LTP 00000001)
[    0.000000] ACPI: SSDT 7f6f2655 0025F (v01 LENOVO TP-79    00002260 INTL 20050513)
[    0.000000] ACPI: SSDT 7f6f28b4 000A6 (v01 LENOVO TP-79    00002260 INTL 20050513)
[    0.000000] ACPI: SSDT 7f6f295a 004F7 (v01 LENOVO TP-79    00002260 INTL 20050513)
[    0.000000] ACPI: SSDT 7f6f2e51 001D8 (v01 LENOVO TP-79    00002260 INTL 20050513)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1150MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007f6d0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f6d0
[    0.000000] On node 0 totalpages: 521838
[    0.000000] free_area_init_node: node 0, pgdat c137e500, node_mem_map c14a0020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3966 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2302 pages used for memmap
[    0.000000]   HighMem zone: 292308 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] early_res array is doubled to 64 at [8000 - 87ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:70000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @c2800000 s33876 r0 d23468 u2097152
[    0.000000] pcpu-alloc: s33876 r0 d23468 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517760
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.34 root=UUID=08c11915-82f3-463a-9e61-b66b56205bdf ro quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Subtract (52 early reservations)
[    0.000000]   #1 [0000001000 - 0000002000]   EX TRAMPOLINE
[    0.000000]   #2 [0001000000 - 0001497bc4]   TEXT DATA BSS
[    0.000000]   #3 [0001498000 - 000149e138]             BRK
[    0.000000]   #4 [00000f6820 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f6810 - 00000f6820]    MP-table mpf
[    0.000000]   #6 [000009f000 - 000009f5a1]   BIOS reserved
[    0.000000]   #7 [000009f6b5 - 00000f6810]   BIOS reserved
[    0.000000]   #8 [000009f5a1 - 000009f6b5]    MP-table mpc
[    0.000000]   #9 [0000002000 - 0000003000]      TRAMPOLINE
[    0.000000]   #10 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #11 [0000007000 - 0000008000]         PGTABLE
[    0.000000]   #12 [0000100000 - 0000aa1000]     NEW RAMDISK
[    0.000000]   #13 [000149f000 - 00014a0000]         BOOTMEM
[    0.000000]   #14 [00014a0000 - 0002490000]         BOOTMEM
[    0.000000]   #15 [0001497c00 - 0001497c04]         BOOTMEM
[    0.000000]   #16 [0001497c40 - 0001497d00]         BOOTMEM
[    0.000000]   #17 [0001497d00 - 0001497d54]         BOOTMEM
[    0.000000]   #18 [0002490000 - 0002493000]         BOOTMEM
[    0.000000]   #19 [0001497d80 - 0001497dec]         BOOTMEM
[    0.000000]   #20 [0002493000 - 0002499000]         BOOTMEM
[    0.000000]   #21 [0001497e00 - 0001497e25]         BOOTMEM
[    0.000000]   #22 [0001497e40 - 0001497e67]         BOOTMEM
[    0.000000]   #23 [000149e140 - 000149e2e4]         BOOTMEM
[    0.000000]   #24 [0001497e80 - 0001497ec0]         BOOTMEM
[    0.000000]   #25 [0001497ec0 - 0001497f00]         BOOTMEM
[    0.000000]   #26 [0001497f00 - 0001497f40]         BOOTMEM
[    0.000000]   #27 [0001497f40 - 0001497f80]         BOOTMEM
[    0.000000]   #28 [0001497f80 - 0001497fc0]         BOOTMEM
[    0.000000]   #29 [0001497fc0 - 0001498000]         BOOTMEM
[    0.000000]   #30 [000149e300 - 000149e340]         BOOTMEM
[    0.000000]   #31 [000149e340 - 000149e380]         BOOTMEM
[    0.000000]   #32 [000149e380 - 000149e3c0]         BOOTMEM
[    0.000000]   #33 [000149e3c0 - 000149e400]         BOOTMEM
[    0.000000]   #34 [000149e400 - 000149e440]         BOOTMEM
[    0.000000]   #35 [000149e440 - 000149e480]         BOOTMEM
[    0.000000]   #36 [000149e480 - 000149e4c0]         BOOTMEM
[    0.000000]   #37 [000149e4c0 - 000149e500]         BOOTMEM
[    0.000000]   #38 [000149e500 - 000149e510]         BOOTMEM
[    0.000000]   #39 [000149e540 - 000149e598]         BOOTMEM
[    0.000000]   #40 [000149e5c0 - 000149e618]         BOOTMEM
[    0.000000]   #41 [0002800000 - 000280e000]         BOOTMEM
[    0.000000]   #42 [0002a00000 - 0002a0e000]         BOOTMEM
[    0.000000]   #43 [000149e640 - 000149e644]         BOOTMEM
[    0.000000]   #44 [000149e680 - 000149e684]         BOOTMEM
[    0.000000]   #45 [000149e6c0 - 000149e6c8]         BOOTMEM
[    0.000000]   #46 [000149e700 - 000149e708]         BOOTMEM
[    0.000000]   #47 [000149e740 - 000149e7e8]         BOOTMEM
[    0.000000]   #48 [000149e800 - 000149e868]         BOOTMEM
[    0.000000]   #49 [0002499000 - 000249d000]         BOOTMEM
[    0.000000]   #50 [000249d000 - 000251d000]         BOOTMEM
[    0.000000]   #51 [000251d000 - 000255d000]         BOOTMEM
[    0.000000] Initializing HighMem for node 0 (000377fe:0007f6d0)
[    0.000000] Memory: 2055476k/2087744k available (2386k kernel code, 31876k reserved, 1222k data, 376k init, 1178440k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd56000 - 0xfffff000   (2724 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1387000 - 0xc13e5000   ( 376 kB)
[    0.000000]       .data : 0xc1254a7b - 0xc1386558   (1222 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1254a7b   (2386 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:1280
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: PIT calibration matches HPET. 1 loops
[    0.000000] Detected 1828.737 MHz processor.
[    0.008005] Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.47 BogoMIPS (lpj=7314948)
[    0.008030] Security Framework initialized
[    0.008037] SELinux:  Disabled at boot.
[    0.008046] Mount-cache hash table entries: 512
[    0.008187] Initializing cgroup subsys ns
[    0.008191] Initializing cgroup subsys cpuacct
[    0.008196] Initializing cgroup subsys devices
[    0.008199] Initializing cgroup subsys freezer
[    0.008201] Initializing cgroup subsys net_cls
[    0.008229] CPU: Physical Processor ID: 0
[    0.008230] CPU: Processor Core ID: 0
[    0.008234] mce: CPU supports 6 MCE banks
[    0.008245] CPU0: Thermal monitoring enabled (TM2)
[    0.008249] using mwait in idle threads.
[    0.008257] Performance Events: Core events, core PMU driver.
[    0.008264] ... version:                1
[    0.008266] ... bit width:              40
[    0.008268] ... generic registers:      2
[    0.008270] ... value mask:             000000ffffffffff
[    0.008273] ... max period:             000000007fffffff
[    0.008275] ... fixed-purpose events:   0
[    0.008277] ... event mask:             0000000000000003
[    0.008281] Checking 'hlt' instruction... OK.
[    0.025101] ACPI: Core revision 20100121
[    0.052057] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.052464] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.093711] CPU0: Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.096000] Booting Node   0, Processors  #1 Ok.
[    0.012000] Initializing CPU#1
[    0.184000] TSC synchronization [CPU#0 -> CPU#1]:
[    0.184000] Measured 521642 cycles TSC warp between CPUs, turning off TSC clock.
[    0.184000] Marking TSC unstable due to check_tsc_sync_source failed
[    0.184017] Brought up 2 CPUs
[    0.184020] Total of 2 processors activated (7315.07 BogoMIPS).
[    0.184623] regulator: core version 0.5
[    0.184623] NET: Registered protocol family 16
[    0.184623] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.184623] ACPI: bus type pci registered
[    0.184623] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.184623] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.184623] PCI: Using MMCONFIG for extended config space
[    0.184623] PCI: Using configuration type 1 for base access
[    0.184623] bio: create slab <bio-0> at 0
[    0.188019] ACPI: EC: EC description table is found, configuring boot EC
[    0.201464] ACPI: SSDT 7f6f1d36 00240 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[    0.202360] ACPI: SSDT 7f6f1ffb 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[    0.203372] ACPI: SSDT 7f6f1c6e 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[    0.204069] ACPI: SSDT 7f6f1f76 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[    0.204693] ACPI: Interpreter enabled
[    0.204704] ACPI: (supports S0 S3 S4 S5)
[    0.204729] ACPI: Using IOAPIC for interrupt routing
[    0.213492] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.213541] ACPI: Power Resource [PUBS] (on)
[    0.217416] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.217420] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.217883] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.217934] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.217938] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.217941] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.217945] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    0.217948] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.217951] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.217955] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff]
[    0.218019] pci 0000:00:02.0: reg 10: [mem 0xee100000-0xee17ffff]
[    0.218025] pci 0000:00:02.0: reg 14: [io  0x1800-0x1807]
[    0.218030] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
[    0.218035] pci 0000:00:02.0: reg 1c: [mem 0xee200000-0xee23ffff]
[    0.218072] pci 0000:00:02.1: reg 10: [mem 0xee180000-0xee1fffff]
[    0.218177] pci 0000:00:1b.0: reg 10: [mem 0xee240000-0xee243fff 64bit]
[    0.218237] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.218243] pci 0000:00:1b.0: PME# disabled
[    0.218338] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.218344] pci 0000:00:1c.0: PME# disabled
[    0.218442] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.218447] pci 0000:00:1c.1: PME# disabled
[    0.218546] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.218551] pci 0000:00:1c.2: PME# disabled
[    0.218649] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.218655] pci 0000:00:1c.3: PME# disabled
[    0.218718] pci 0000:00:1d.0: reg 20: [io  0x1820-0x183f]
[    0.218780] pci 0000:00:1d.1: reg 20: [io  0x1840-0x185f]
[    0.218842] pci 0000:00:1d.2: reg 20: [io  0x1860-0x187f]
[    0.218904] pci 0000:00:1d.3: reg 20: [io  0x1880-0x189f]
[    0.218963] pci 0000:00:1d.7: reg 10: [mem 0xee444000-0xee4443ff]
[    0.219025] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.219031] pci 0000:00:1d.7: PME# disabled
[    0.219193] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.219198] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.219203] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
[    0.219208] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
[    0.219213] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
[    0.219266] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.219274] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.219282] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.219290] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.219298] pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
[    0.219355] pci 0000:00:1f.2: reg 10: [io  0x18d0-0x18d7]
[    0.219363] pci 0000:00:1f.2: reg 14: [io  0x18c4-0x18c7]
[    0.219371] pci 0000:00:1f.2: reg 18: [io  0x18c8-0x18cf]
[    0.219379] pci 0000:00:1f.2: reg 1c: [io  0x18c0-0x18c3]
[    0.219387] pci 0000:00:1f.2: reg 20: [io  0x18b0-0x18bf]
[    0.219395] pci 0000:00:1f.2: reg 24: [mem 0xee444400-0xee4447ff]
[    0.219432] pci 0000:00:1f.2: PME# supported from D3hot
[    0.219437] pci 0000:00:1f.2: PME# disabled
[    0.219500] pci 0000:00:1f.3: reg 20: [io  0x18e0-0x18ff]
[    0.219704] pci 0000:02:00.0: reg 10: [mem 0xee000000-0xee01ffff]
[    0.219729] pci 0000:02:00.0: reg 18: [io  0x2000-0x201f]
[    0.219836] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.219844] pci 0000:02:00.0: PME# disabled
[    0.219879] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.219885] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.220003] pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
[    0.220012] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.220209] pci 0000:03:00.0: reg 10: [mem 0xedf00000-0xedf00fff]
[    0.220451] pci 0000:03:00.0: PME# supported from D0 D3hot
[    0.220464] pci 0000:03:00.0: PME# disabled
[    0.220529] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.220534] pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
[    0.220540] pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
[    0.220549] pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
[    0.220609] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.220614] pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
[    0.220620] pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
[    0.220628] pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
[    0.220688] pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
[    0.220694] pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
[    0.220699] pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
[    0.220708] pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
[    0.220776] pci 0000:15:00.0: reg 10: [mem 0xe4300000-0xe4300fff]
[    0.220806] pci 0000:15:00.0: supports D1 D2
[    0.220808] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.220815] pci 0000:15:00.0: PME# disabled
[    0.220885] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
[    0.220890] pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
[    0.220896] pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
[    0.220905] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
[    0.220908] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.220911] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.220914] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.220918] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.220921] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.220924] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.220928] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfebfffff] (subtractive decode)
[    0.221014] pci_bus 0000:00: on NUMA node 0
[    0.221019] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.221173] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.221253] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.221332] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.221418] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.221504] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.227018] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.227230] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.227439] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.227649] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.227857] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.228078] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.228286] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.228497] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.228618] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.228631] vgaarb: loaded
[    0.228659] PCI: Using ACPI for IRQ routing
[    0.228659] PCI: pci_cache_line_size set to 64 bytes
[    0.228659] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
[    0.228659] reserve RAM buffer: 000000007f6d0000 - 000000007fffffff 
[    0.228659] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.228659] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.228659] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.232017] Switching to clocksource hpet
[    0.233496] pnp: PnP ACPI init
[    0.233505] ACPI: bus type pnp registered
[    0.237785] pnp: PnP ACPI: found 11 devices
[    0.237787] ACPI: ACPI bus type pnp unregistered
[    0.237791] PnPBIOS: Disabled by ACPI PNP
[    0.237803] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.237807] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.237811] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.237814] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.237817] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.237821] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.237825] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.237828] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.237832] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.237835] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.237839] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.237843] system 00:00: [mem 0x00100000-0x7fffffff] could not be reserved
[    0.237846] system 00:00: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.237854] system 00:02: [io  0x164e-0x164f] has been reserved
[    0.237857] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.237861] system 00:02: [io  0x1180-0x11bf] has been reserved
[    0.237864] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.237868] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.237871] system 00:02: [io  0x1600-0x165f] could not be reserved
[    0.237875] system 00:02: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.237879] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.237882] system 00:02: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.237886] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.237889] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.237893] system 00:02: [mem 0xfed40000-0xfed40fff] has been reserved
[    0.272658] pci 0000:00:1c.0: BAR 15: assigned [mem 0x80000000-0x801fffff 64bit pref]
[    0.272662] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.272667] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.272674] pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
[    0.272679] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff 64bit pref]
[    0.272688] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.272692] pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
[    0.272699] pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
[    0.272705] pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
[    0.272713] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.272717] pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
[    0.272724] pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
[    0.272730] pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
[    0.272738] pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
[    0.272742] pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
[    0.272749] pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
[    0.272755] pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
[    0.272764] pci 0000:15:00.0: BAR 15: assigned [mem 0xe0000000-0xe3ffffff pref]
[    0.272769] pci 0000:15:00.0: BAR 16: assigned [mem 0x84000000-0x87ffffff]
[    0.272772] pci 0000:15:00.0: BAR 13: assigned [io  0x9000-0x90ff]
[    0.272775] pci 0000:15:00.0: BAR 14: assigned [io  0x9400-0x94ff]
[    0.272778] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
[    0.272781] pci 0000:15:00.0:   bridge window [io  0x9000-0x90ff]
[    0.272787] pci 0000:15:00.0:   bridge window [io  0x9400-0x94ff]
[    0.272794] pci 0000:15:00.0:   bridge window [mem 0xe0000000-0xe3ffffff pref]
[    0.272800] pci 0000:15:00.0:   bridge window [mem 0x84000000-0x87ffffff]
[    0.272807] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
[    0.272811] pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
[    0.272818] pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
[    0.272823] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
[    0.272844] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.272850] pci 0000:00:1c.0: setting latency timer to 64
[    0.272862] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.272867] pci 0000:00:1c.1: setting latency timer to 64
[    0.272878] pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    0.272884] pci 0000:00:1c.2: setting latency timer to 64
[    0.272897] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.272902] pci 0000:00:1c.3: setting latency timer to 64
[    0.272908] pci 0000:00:1e.0: enabling device (0005 -> 0007)
[    0.272915] pci 0000:00:1e.0: setting latency timer to 64
[    0.272928] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.272936] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.272939] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.272941] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.272944] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.272947] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.272950] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.272953] pci_bus 0000:00: resource 10 [mem 0x80000000-0xfebfffff]
[    0.272956] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.272959] pci_bus 0000:02: resource 1 [mem 0xee000000-0xee0fffff]
[    0.272962] pci_bus 0000:02: resource 2 [mem 0x80000000-0x801fffff 64bit pref]
[    0.272965] pci_bus 0000:03: resource 0 [io  0x3000-0x4fff]
[    0.272968] pci_bus 0000:03: resource 1 [mem 0xec000000-0xedffffff]
[    0.272971] pci_bus 0000:03: resource 2 [mem 0xe4000000-0xe40fffff 64bit pref]
[    0.272975] pci_bus 0000:04: resource 0 [io  0x5000-0x6fff]
[    0.272978] pci_bus 0000:04: resource 1 [mem 0xe8000000-0xe9ffffff]
[    0.272981] pci_bus 0000:04: resource 2 [mem 0xe4100000-0xe41fffff 64bit pref]
[    0.272984] pci_bus 0000:0c: resource 0 [io  0x7000-0x8fff]
[    0.272987] pci_bus 0000:0c: resource 1 [mem 0xea000000-0xebffffff]
[    0.272990] pci_bus 0000:0c: resource 2 [mem 0xe4200000-0xe42fffff 64bit pref]
[    0.272993] pci_bus 0000:15: resource 0 [io  0x9000-0xcfff]
[    0.272996] pci_bus 0000:15: resource 1 [mem 0xe4300000-0xe7ffffff]
[    0.272999] pci_bus 0000:15: resource 2 [mem 0xe0000000-0xe3ffffff 64bit pref]
[    0.273002] pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
[    0.273005] pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
[    0.273008] pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
[    0.273011] pci_bus 0000:15: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.273014] pci_bus 0000:15: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.273016] pci_bus 0000:15: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.273019] pci_bus 0000:15: resource 10 [mem 0x80000000-0xfebfffff]
[    0.273022] pci_bus 0000:16: resource 0 [io  0x9000-0x90ff]
[    0.273025] pci_bus 0000:16: resource 1 [io  0x9400-0x94ff]
[    0.273028] pci_bus 0000:16: resource 2 [mem 0xe0000000-0xe3ffffff pref]
[    0.273031] pci_bus 0000:16: resource 3 [mem 0x84000000-0x87ffffff]
[    0.273058] NET: Registered protocol family 2
[    0.273111] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.273346] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.274044] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.274392] TCP: Hash tables configured (established 131072 bind 65536)
[    0.274395] TCP reno registered
[    0.274398] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.274413] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.274514] NET: Registered protocol family 1
[    0.274533] pci 0000:00:02.0: Boot video device
[    0.274776] PCI: CLS mismatch (64 != 32), using 64 bytes
[    0.274834] Unpacking initramfs...
[    0.616253] Freeing initrd memory: 9860k freed
[    0.622042] Simple Boot Flag at 0x35 set to 0x1
[    0.622370] audit: initializing netlink socket (disabled)
[    0.622387] type=2000 audit(1274709152.620:1): initialized
[    0.622646] highmem bounce pool size: 64 pages
[    0.622651] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.624271] VFS: Disk quotas dquot_6.5.2
[    0.624326] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.624425] msgmni has been set to 1732
[    0.624667] alg: No test for stdrng (krng)
[    0.624729] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.624733] io scheduler noop registered
[    0.624735] io scheduler deadline registered
[    0.624778] io scheduler cfq registered (default)
[    0.624879] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.624936] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.625041] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.625092] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.625189] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.625239] pcieport 0000:00:1c.2: irq 26 for MSI/MSI-X
[    0.625339] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.625389] pcieport 0000:00:1c.3: irq 27 for MSI/MSI-X
[    0.625586] isapnp: Scanning for PnP cards...
[    0.980147] isapnp: No Plug & Play device found
[    0.981366] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.981515] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    0.981853] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.990262] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.990269] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.990321] mice: PS/2 mouse device common for all mice
[    0.990374] rtc_cmos 00:07: RTC can wake from S4
[    0.990405] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.990438] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.990449] cpuidle: using governor ladder
[    0.990452] cpuidle: using governor menu
[    0.990456] No iBFT detected.
[    0.990714] TCP cubic registered
[    0.990887] NET: Registered protocol family 10
[    0.991270] lo: Disabled Privacy Extensions
[    0.991534] Mobile IPv6
[    0.991537] NET: Registered protocol family 17
[    0.991550] Using IPI No-Shortcut mode
[    0.991608] registered taskstats version 1
[    0.992131] rtc_cmos 00:07: setting system clock to 2010-05-24 13:52:33 UTC (1274709153)
[    0.992235] Freeing unused kernel memory: 376k freed
[    0.992465] Write protecting the kernel text: 2388k
[    0.992489] Write protecting the kernel read-only data: 848k
[    0.995689] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.217359] usbcore: registered new interface driver usbfs
[    1.217510] usbcore: registered new interface driver hub
[    1.217559] usbcore: registered new device driver usb
[    1.239876] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    1.239879] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    1.239984] e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.240012] e1000e 0000:02:00.0: setting latency timer to 64
[    1.240201] e1000e 0000:02:00.0: irq 28 for MSI/MSI-X
[    1.240693] e1000e 0000:02:00.0: Disabling ASPM L0s 
[    1.242020] SCSI subsystem initialized
[    1.242920] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.243182] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    1.243376] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    1.243387] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.243400] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.243404] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.243425] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.243446] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    1.243458] ehci_hcd 0000:00:1d.7: debug port 1
[    1.247329] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.247498] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee444000
[    1.276016] Uniform Multi-Platform E-IDE driver
[    1.280082] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.280109] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.280112] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.280115] usb usb1: Product: EHCI Host Controller
[    1.280117] usb usb1: Manufacturer: Linux 2.6.34 ehci_hcd
[    1.280120] usb usb1: SerialNumber: 0000:00:1d.7
[    1.280220] hub 1-0:1.0: USB hub found
[    1.280225] hub 1-0:1.0: 8 ports detected
[    1.283706] libata version 3.00 loaded.
[    1.285983] piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x02)
[    1.285995] PIIX_IDE 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[    1.286008] piix 0000:00:1f.1: IDE port disabled
[    1.286017] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    1.286023]     ide0: BM-DMA at 0x1810-0x1817
[    1.286032] Probing IDE interface ide0...
[    1.293485] uhci_hcd: USB Universal Host Controller Interface driver
[    1.294968] thermal LNXTHERM:01: registered as thermal_zone0
[    1.294978] ACPI: Thermal Zone [THM0] (50 C)
[    1.296465] thermal LNXTHERM:02: registered as thermal_zone1
[    1.296474] ACPI: Thermal Zone [THM1] (53 C)
[    1.377411] 0000:02:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:f0:02:0f:1d:00
[    1.377414] 0000:02:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.377553] 0000:02:00.0: eth0: MAC: 2, PHY: 2, PBA No: 005301-003
[    2.020361] hda: HL-DT-STCD-RW/DVD DRIVE GCC-4247N, ATAPI CD/DVD-ROM drive
[    2.356053] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    2.357041] hda: UDMA/33 mode selected
[    2.358054] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.360101] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    2.360286] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    2.360294] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.360304] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.360308] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.360322] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.360360] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
[    2.360403] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.360406] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.360409] usb usb2: Product: UHCI Host Controller
[    2.360411] usb usb2: Manufacturer: Linux 2.6.34 uhci_hcd
[    2.360414] usb usb2: SerialNumber: 0000:00:1d.0
[    2.360510] hub 2-0:1.0: USB hub found
[    2.360515] hub 2-0:1.0: 2 ports detected
[    2.360593] ahci 0000:00:1f.2: version 3.0
[    2.360607] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.360657] ahci 0000:00:1f.2: irq 29 for MSI/MSI-X
[    2.360727] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
[    2.360732] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[    2.360738] ahci 0000:00:1f.2: setting latency timer to 64
[    2.360863] scsi0 : ahci
[    2.361028] scsi1 : ahci
[    2.361138] scsi2 : ahci
[    2.361280] scsi3 : ahci
[    2.361387] ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 29
[    2.361390] ata2: DUMMY
[    2.361392] ata3: DUMMY
[    2.361394] ata4: DUMMY
[    2.361507] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.361517] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.361521] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.361532] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.361571] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
[    2.361612] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.361616] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.361619] usb usb3: Product: UHCI Host Controller
[    2.361621] usb usb3: Manufacturer: Linux 2.6.34 uhci_hcd
[    2.361624] usb usb3: SerialNumber: 0000:00:1d.1
[    2.361716] hub 3-0:1.0: USB hub found
[    2.361721] hub 3-0:1.0: 2 ports detected
[    2.362035] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[    2.362207] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[    2.362215] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.362223] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.362227] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.362236] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.362272] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
[    2.362309] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.362312] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.362315] usb usb4: Product: UHCI Host Controller
[    2.362317] usb usb4: Manufacturer: Linux 2.6.34 uhci_hcd
[    2.362320] usb usb4: SerialNumber: 0000:00:1d.2
[    2.362397] hub 4-0:1.0: USB hub found
[    2.362401] hub 4-0:1.0: 2 ports detected
[    2.362463] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.362469] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.362473] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.362481] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.362509] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
[    2.362543] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.362546] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.362549] usb usb5: Product: UHCI Host Controller
[    2.362551] usb usb5: Manufacturer: Linux 2.6.34 uhci_hcd
[    2.362554] usb usb5: SerialNumber: 0000:00:1d.3
[    2.362629] hub 5-0:1.0: USB hub found
[    2.362633] hub 5-0:1.0: 2 ports detected
[    2.680034] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.681072] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.681077] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.681082] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.682214] ata1.00: ATA-7: SAMSUNG MMCRE64G5MXP-0VB, VBM1801Q, max UDMA/100
[    2.682218] ata1.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.682620] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.682624] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.682629] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.683753] ata1.00: configured for UDMA/100
[    2.700630] ata1.00: configured for UDMA/100
[    2.700634] ata1: EH complete
[    2.700746] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG MMCRE64G VBM1 PQ: 0 ANSI: 5
[    2.714878] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
[    2.714940] sd 0:0:0:0: [sda] Write Protect is off
[    2.714944] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.714971] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.715118]  sda: sda1 sda2
[    2.716190] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.719538] ide-cd driver 5.00
[    2.721663] ide-cd: hda: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
[    2.721669] Uniform CD-ROM driver Revision: 3.20
[    2.845391] device-mapper: uevent: version 1.0.3
[    2.845529] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    3.157765] udev: starting version 154
[    3.357084] Linux agpgart interface v0.103
[    3.360641] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    3.362495] ACPI: Lid Switch [LID]
[    3.362563] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    3.362570] ACPI: Sleep Button [SLPB]
[    3.363499] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    3.365418] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    3.365426] ACPI: Power Button [PWRF]
[    3.389762] intel_rng: FWH not detected
[    3.391725] ACPI: AC Adapter [AC] (on-line)
[    3.411929] acpi device:01: registered as cooling_device2
[    3.412672] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    3.412838] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    3.413394] cfg80211: Calling CRDA to update world regulatory domain
[    3.425714] Non-volatile memory driver v1.3
[    3.426338] agpgart-intel 0000:00:00.0: Intel 945GM Chipset
[    3.427456] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    3.432072] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    3.432366] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:2012]
[    3.432409] yenta_cardbus 0000:15:00.0: Using INTVAL to route CSC interrupts to PCI
[    3.432412] yenta_cardbus 0000:15:00.0: Routing CardBus interrupts to PCI
[    3.432420] yenta_cardbus 0000:15:00.0: TI: mfunc 0x01d01002, devctl 0x64
[    3.432819] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.443382] ACPI: Battery Slot [BAT0] (battery present)
[    3.445671] udev: renamed network interface eth0 to eth2
[    3.496913] NET: Registered protocol family 23
[    3.532450] nsc-ircc, chip->init
[    3.532464] nsc-ircc, Found chip at base=0x164e
[    3.532502] nsc-ircc, driver loaded (Dag Brattli)
[    3.532509] nsc_ircc_open(), can't get iobase of 0x2f8
[    3.532558] nsc-ircc, Found chip at base=0x164e
[    3.532599] nsc-ircc, driver loaded (Dag Brattli)
[    3.532602] nsc_ircc_open(), can't get iobase of 0x2f8
[    3.533123] nsc-ircc 00:0a: disabled
[    3.550795] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
[    3.550799] iwl3945: Copyright(c) 2003-2010 Intel Corporation
[    3.550910] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.550926] iwl3945 0000:03:00.0: setting latency timer to 64
[    3.587988] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    3.587992] thinkpad_acpi: http://ibm-acpi.sf.net/
[    3.588012] thinkpad_acpi: ThinkPad BIOS 79ETE6WW (2.26 ), EC 79HT50WW-1.07
[    3.588015] thinkpad_acpi: Lenovo ThinkPad T60, model 1952WUV
[    3.588334] thinkpad_acpi: radio switch found; radios are enabled
[    3.588436] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    3.588440] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    3.593630] Registered led device: tpacpi::thinklight
[    3.593686] Registered led device: tpacpi::power
[    3.593731] Registered led device: tpacpi::standby
[    3.593773] Registered led device: tpacpi::thinkvantage
[    3.596379] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[    3.596512] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    3.601276] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[    3.605769] iwl3945 0000:03:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[    3.605774] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
[    3.606881] iwl3945 0000:03:00.0: irq 30 for MSI/MSI-X
[    3.621314] phy0: Selected rate control algorithm 'iwl-3945-rs'
[    3.691344] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.691349] hda_intel: probe_mask set to 0x1 for device 17aa:2010
[    3.691409] HDA Intel 0000:00:1b.0: irq 31 for MSI/MSI-X
[    3.691443] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    3.710108] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cf8, PCI irq 16
[    3.710112] yenta_cardbus 0000:15:00.0: Socket status: 30000007
[    3.710120] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x9000-0xcfff]
[    3.710124] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x9000-0xcfff: excluding 0x9000-0x90ff 0x9400-0x94ff
[    3.737390] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
[    3.739574] 
[    3.739580] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe4300000-0xe7ffffff]
[    3.739585] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe4300000-0xe7ffffff: excluding 0xe4300000-0xe46cffff
[    3.739740] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe0000000-0xe3ffffff 64bit pref]
[    3.739744] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0xe3ffffff: excluding 0xe0000000-0xe3ffffff
[    3.739766] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x0000-0x0cf7]
[    3.739769] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0xcf7: excluding 0x170-0x177 0x1f0-0x1f7 0x2f8-0x2ff 0x370-0x377 0x3c0-0x3df 0x3f0-0x3f7 0x4d0-0x4d7 0x800-0x80f
[    3.748616] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x0d00-0xffff]
[    3.748621] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xd00-0xffff: excluding 0x1000-0x107f 0x1180-0x11bf 0x15e0-0x15ef 0x1600-0x1607 0x1610-0x161f 0x1648-0x165f 0x1680-0x169f 0x1800-0x1807 0x1810-0x189f 0x18b0-0x18d7 0x18e0-0x18ff 0x2000-0x90ff 0x9400-0x94ff
[    3.803881] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0x000a0000-0x000bffff]
[    3.803886] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0a0000-0x0bffff: excluding 0xa0000-0xbffff
[    3.803901] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0x000d0000-0x000d3fff]
[    3.803904] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0d0000-0x0d3fff: clean.
[    3.803910] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0x000d4000-0x000d7fff]
[    3.803913] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0d4000-0x0d7fff: clean.
[    3.803918] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0x000d8000-0x000dbfff]
[    3.803922] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0d8000-0x0dbfff: clean.
[    3.803927] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0x80000000-0xfebfffff]
[    3.803931] pcmcia_socket pcmcia_socket0: cs: memory probe 0x80000000-0xfebfffff: excluding 0x80000000-0x807fffff 0x84000000-0x87ffffff 0xd0000000-0xe47fffff 0xe8000000-0xee7fffff 0xf0000000-0xf3ffffff 0xfe800000-0xfeffffff
[    3.817155] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: excluding 0x170-0x177 0x1f0-0x1f7 0x2f8-0x2ff 0x370-0x377
[    3.819367] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding 0x3f0-0x3f7 0x4d0-0x4d7
[    3.820315] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
[    3.821121] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
[    3.821969] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcffff 0xdc000-0xfffff
[    3.822037] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: clean.
[    3.822104] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
[    3.822174] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
[    3.925699] Adding 2104476k swap on /dev/sda1.  Priority:-1 extents:1 across:2104476k SS
[    4.039615] loop: module loaded
[    4.166504] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000/0x0
[    4.166513] serio: Synaptics pass-through port at isa0060/serio1/input0
[    4.217734] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8
[    4.333985] fuse init (API version 7.13)
[    4.369640] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input9
[    4.413562] apm: BIOS not found.
[    4.854708] e1000e 0000:02:00.0: irq 28 for MSI/MSI-X
[    4.858919] Bluetooth: Core ver 2.15
[    4.865044] NET: Registered protocol family 31
[    4.865047] Bluetooth: HCI device and connection manager initialized
[    4.865051] Bluetooth: HCI socket layer initialized
[    4.882277] lp: driver loaded but no devices found
[    4.886060] Bluetooth: L2CAP ver 2.14
[    4.886063] Bluetooth: L2CAP socket layer initialized
[    4.900469] Bluetooth: RFCOMM TTY layer initialized
[    4.900474] Bluetooth: RFCOMM socket layer initialized
[    4.900476] Bluetooth: RFCOMM ver 1.11
[    4.903063] ppdev: user-space parallel port driver
[    4.908205] e1000e 0000:02:00.0: irq 28 for MSI/MSI-X
[    4.908779] ADDRCONF(NETDEV_UP): eth2: link is not ready
[    4.911529] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
[    4.936306] iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
[    5.019375] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.019378] Bluetooth: BNEP filters: protocol multicast
[    5.032040] phy0: device now idle
[    5.036721] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    5.049859] Bridge firewalling registered
[    5.074532] Bluetooth: SCO (Voice Link) ver 0.6
[    5.074535] Bluetooth: SCO socket layer initialized
[    5.115612] phy0: device no longer idle - scanning
[    5.222062] ttyS1: LSR safety check engaged!
[    5.550908] input: /usr/sbin/thinkpad-keys as /devices/virtual/input/input10
[    5.712537] [drm] Initialized drm 1.1.0 20060810
[    5.742545] i915 0000:00:02.0: power state changed by ACPI to D0
[    5.742591] i915 0000:00:02.0: power state changed by ACPI to D0
[    5.742599] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.742606] i915 0000:00:02.0: setting latency timer to 64
[    5.746159] [drm] set up 7M of stolen space
[    6.178976] [drm] initialized overlay support
[    6.649625] Console: switching to colour frame buffer device 128x48
[    6.649633] fb0: inteldrmfb frame buffer device
[    6.649636] registered panic notifier
[    6.649645] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    7.820183] phy0: device now idle
[    9.800094] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   10.036720] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input11
[   12.522112] phy0: device no longer idle - in use
[   12.524868] wlan0: sta_find_ibss (active_ibss=0)
[   12.524877]    sta_find_ibss: selected 06:be:a1:c9:16:c0 current 00:00:00:00:00:00
[   12.524879] wlan0: Selected IBSS BSSID 06:be:a1:c9:16:c0 based on configured SSID
[   12.604735] phy0: Adding new IBSS station 00:08:a1:8a:d8:bf (dev=wlan0)
[   12.604743] phy0: Allocated STA 00:08:a1:8a:d8:bf
[   12.604747] phy0: Added IBSS STA 00:08:a1:8a:d8:bf
[   12.604758] phy0: Finished adding IBSS STA 00:08:a1:8a:d8:bf
[   23.044068] wlan0: no IPv6 routers present
[   29.108889] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   29.108899] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   29.108921] wlan0: RX ProbeReq SA=00:11:09:9a:bd:3a DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   29.108928] wlan0: Sending ProbeResp to 00:11:09:9a:bd:3a
[   30.985706] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   30.985715] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[   31.090023] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   31.090031] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[   31.195035] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   31.195043] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[   31.406864] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   31.406873] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[   41.662474] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   41.662484] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   45.671412] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   45.671422] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   47.674368] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   47.674378] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   49.678332] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   49.678342] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   59.698165] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   59.698175] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   63.707071] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   63.707081] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   68.852134] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   68.852144] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   69.706594] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   69.706604] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[   69.718985] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   69.718992] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   69.726177] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   69.726184] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[   69.747119] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   69.747126] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[   69.766758] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   69.766765] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[   69.787578] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   69.787585] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[   69.806776] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   69.806783] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[   69.827599] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   69.827606] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[   69.846801] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   69.846808] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[   71.721950] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   71.721960] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   77.733841] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   77.733851] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   79.737786] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   79.737795] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   81.742754] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   81.742763] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   87.642155] wlan0: RX ProbeReq SA=00:11:09:9a:bd:3a DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   87.642165] wlan0: Sending ProbeResp to 00:11:09:9a:bd:3a
[   87.706128] wlan0: RX ProbeReq SA=00:11:09:9a:bd:3a DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   87.706135] wlan0: Sending ProbeResp to 00:11:09:9a:bd:3a
[   87.754653] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   87.754662] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[   87.770124] wlan0: RX ProbeReq SA=00:11:09:9a:bd:3a DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   87.770132] wlan0: Sending ProbeResp to 00:11:09:9a:bd:3a
[   87.834147] wlan0: RX ProbeReq SA=00:11:09:9a:bd:3a DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   87.834154] wlan0: Sending ProbeResp to 00:11:09:9a:bd:3a
[   91.089016] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   91.089022] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[   91.194146] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   91.194155] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[   91.300366] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   91.300377] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[   91.405092] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   91.405101] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[   95.761530] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[   95.761540] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[  109.181057] CE: hpet increased min_delta_ns to 7500 nsec
[  110.933060] CE: hpet increased min_delta_ns to 11250 nsec
[  111.794253] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  111.794262] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[  129.709086] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  129.709096] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  129.728228] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  129.728236] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  129.749103] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  129.749110] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  129.768203] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  129.768211] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  129.789139] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  129.789146] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  129.808304] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  129.808311] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  129.829058] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  129.829065] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  129.829906] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  129.829913] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[  133.836815] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  133.836822] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[  135.841819] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  135.841829] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[  147.635869] wlan0: RX ProbeReq SA=00:11:09:9a:bd:3a DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  147.635879] wlan0: Sending ProbeResp to 00:11:09:9a:bd:3a
[  147.699839] wlan0: RX ProbeReq SA=00:11:09:9a:bd:3a DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  147.699847] wlan0: Sending ProbeResp to 00:11:09:9a:bd:3a
[  147.763843] wlan0: RX ProbeReq SA=00:11:09:9a:bd:3a DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  147.763851] wlan0: Sending ProbeResp to 00:11:09:9a:bd:3a
[  147.827844] wlan0: RX ProbeReq SA=00:11:09:9a:bd:3a DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  147.827851] wlan0: Sending ProbeResp to 00:11:09:9a:bd:3a
[  150.983640] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  150.983650] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[  151.088054] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  151.088062] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[  151.300117] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  151.300127] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[  151.405105] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  151.405114] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[  171.085576] wlan0: RX ProbeReq SA=00:19:99:1d:cf:38 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  171.085586] wlan0: Sending ProbeResp to 00:19:99:1d:cf:38
[  189.707544] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  189.707554] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  189.727003] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  189.727011] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  189.747523] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  189.747531] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  189.766690] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  189.766698] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  189.787509] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  189.787517] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  189.806709] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  189.806716] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  189.829977] wlan0: RX ProbeReq SA=00:25:56:97:9d:d2 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  189.829985] wlan0: Sending ProbeResp to 00:25:56:97:9d:d2
[  199.959708] wlan0: RX ProbeReq SA=00:22:43:42:3b:35 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  199.959717] wlan0: Sending ProbeResp to 00:22:43:42:3b:35
[  209.125418] wlan0: RX ProbeReq SA=00:11:09:9a:bd:3a DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  209.125428] wlan0: Sending ProbeResp to 00:11:09:9a:bd:3a
[  209.125450] wlan0: RX ProbeReq SA=00:11:09:9a:bd:3a DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  209.125457] wlan0: Sending ProbeResp to 00:11:09:9a:bd:3a
[  210.982887] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  210.982896] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[  211.087134] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  211.087142] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3
[  211.403394] wlan0: RX ProbeReq SA=00:25:56:b3:06:f3 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[  211.403404] wlan0: Sending ProbeResp to 00:25:56:b3:06:f3

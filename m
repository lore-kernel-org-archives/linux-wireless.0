Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:35048 "EHLO kirsi2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab0EWQbv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 May 2010 12:31:51 -0400
Date: Sun, 23 May 2010 19:31:34 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Silence debug prints when using adhoc mode
Message-ID: <20100523163133.GA19669@nalle>
References: <20100523162240.GZ19669@nalle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100523162240.GZ19669@nalle>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 23, 2010 at 07:22:40PM +0300, Mikko Rapeli wrote:
> Tested on a Thinkpad T60 with Intel Corporation PRO/Wireless 3945ABG [Golan]
> Network Connection (rev 02) running vanilla 2.6.34 kernel.

I tried this first on top of linux-2.6 at commit
f4b87dee923342505e1ddba8d34ce9de33e75050 but there I just got this oops from
iwl3945:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.34 (root@totoro) (gcc version 4.4.4 (Debian 4.4.4-2) ) #1 SMP Sun May 23 13:16:39 EEST 2010
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
[    0.000000] RAMDISK: 37638000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 00100000 - 00ab71f3
[    0.000000] Move RAMDISK from 0000000037638000 - 0000000037fef1f2 to 00100000 - 00ab71f2
[    0.000000] ACPI: RSDP 000f67e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 7f6d14a0 00084 (v01 LENOVO TP-79    00002260  LTP 00000000)
[    0.000000] ACPI: FACP 7f6d1600 000F4 (v03 LENOVO TP-79    00002260 LNVO 00000001)
[    0.000000] ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 (20100428/tbfadt-526)
[    0.000000] ACPI Warning: Optional field Gpe1Block has zero address or length: 0x000000000000102C/0x0 (20100428/tbfadt-557)
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
[    0.000000] free_area_init_node: node 0, pgdat c138b2c0, node_mem_map c14af020
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
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [8000 - 87ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:70000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @c2800000 s34432 r0 d22912 u2097152
[    0.000000] pcpu-alloc: s34432 r0 d22912 u2097152 alloc=1*4194304
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
[    0.000000]   #2 [0001000000 - 00014a6968]   TEXT DATA BSS
[    0.000000]   #3 [00014a7000 - 00014ad138]             BRK
[    0.000000]   #4 [00000f6820 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f6810 - 00000f6820]    MP-table mpf
[    0.000000]   #6 [000009f000 - 000009f5a1]   BIOS reserved
[    0.000000]   #7 [000009f6b5 - 00000f6810]   BIOS reserved
[    0.000000]   #8 [000009f5a1 - 000009f6b5]    MP-table mpc
[    0.000000]   #9 [0000002000 - 0000003000]      TRAMPOLINE
[    0.000000]   #10 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #11 [0000007000 - 0000008000]         PGTABLE
[    0.000000]   #12 [0000100000 - 0000ab8000]     NEW RAMDISK
[    0.000000]   #13 [00014ae000 - 00014af000]         BOOTMEM
[    0.000000]   #14 [00014af000 - 000249f000]         BOOTMEM
[    0.000000]   #15 [00014a6980 - 00014a6984]         BOOTMEM
[    0.000000]   #16 [00014a69c0 - 00014a6a80]         BOOTMEM
[    0.000000]   #17 [00014a6a80 - 00014a6ad4]         BOOTMEM
[    0.000000]   #18 [000249f000 - 00024a2000]         BOOTMEM
[    0.000000]   #19 [00014a6b00 - 00014a6b6c]         BOOTMEM
[    0.000000]   #20 [00024a2000 - 00024a8000]         BOOTMEM
[    0.000000]   #21 [00014a6b80 - 00014a6ba5]         BOOTMEM
[    0.000000]   #22 [00014a6bc0 - 00014a6be7]         BOOTMEM
[    0.000000]   #23 [00014a6c00 - 00014a6da4]         BOOTMEM
[    0.000000]   #24 [00014a6dc0 - 00014a6e00]         BOOTMEM
[    0.000000]   #25 [00014a6e00 - 00014a6e40]         BOOTMEM
[    0.000000]   #26 [00014a6e40 - 00014a6e80]         BOOTMEM
[    0.000000]   #27 [00014a6e80 - 00014a6ec0]         BOOTMEM
[    0.000000]   #28 [00014a6ec0 - 00014a6f00]         BOOTMEM
[    0.000000]   #29 [00014a6f00 - 00014a6f40]         BOOTMEM
[    0.000000]   #30 [00014a6f40 - 00014a6f80]         BOOTMEM
[    0.000000]   #31 [00014a6f80 - 00014a6fc0]         BOOTMEM
[    0.000000]   #32 [00014a6fc0 - 00014a7000]         BOOTMEM
[    0.000000]   #33 [00014ad140 - 00014ad180]         BOOTMEM
[    0.000000]   #34 [00014ad180 - 00014ad1c0]         BOOTMEM
[    0.000000]   #35 [00014ad1c0 - 00014ad200]         BOOTMEM
[    0.000000]   #36 [00014ad200 - 00014ad240]         BOOTMEM
[    0.000000]   #37 [00014ad240 - 00014ad280]         BOOTMEM
[    0.000000]   #38 [00014ad280 - 00014ad290]         BOOTMEM
[    0.000000]   #39 [00014ad2c0 - 00014ad318]         BOOTMEM
[    0.000000]   #40 [00014ad340 - 00014ad398]         BOOTMEM
[    0.000000]   #41 [0002800000 - 000280e000]         BOOTMEM
[    0.000000]   #42 [0002a00000 - 0002a0e000]         BOOTMEM
[    0.000000]   #43 [00014ad3c0 - 00014ad3c4]         BOOTMEM
[    0.000000]   #44 [00014ad400 - 00014ad404]         BOOTMEM
[    0.000000]   #45 [00014ad440 - 00014ad448]         BOOTMEM
[    0.000000]   #46 [00014ad480 - 00014ad488]         BOOTMEM
[    0.000000]   #47 [00014ad4c0 - 00014ad568]         BOOTMEM
[    0.000000]   #48 [00014ad580 - 00014ad5e8]         BOOTMEM
[    0.000000]   #49 [00024a8000 - 00024ac000]         BOOTMEM
[    0.000000]   #50 [00024ac000 - 000252c000]         BOOTMEM
[    0.000000]   #51 [000252c000 - 000256c000]         BOOTMEM
[    0.000000] Initializing HighMem for node 0 (000377fe:0007f6d0)
[    0.000000] Memory: 2055324k/2087744k available (2415k kernel code, 32028k reserved, 1245k data, 380k init, 1178440k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1394000 - 0xc13f3000   ( 380 kB)
[    0.000000]       .data : 0xc125bcef - 0xc1393358   (1245 kB)
[    0.000000]       .text : 0xc1000000 - 0xc125bcef   (2415 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:1280
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1828.617 MHz processor.
[    0.004006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.23 BogoMIPS (lpj=7314468)
[    0.004030] Security Framework initialized
[    0.004038] SELinux:  Disabled at boot.
[    0.004046] Mount-cache hash table entries: 512
[    0.004188] Initializing cgroup subsys ns
[    0.004193] Initializing cgroup subsys cpuacct
[    0.004198] Initializing cgroup subsys devices
[    0.004201] Initializing cgroup subsys freezer
[    0.004204] Initializing cgroup subsys net_cls
[    0.004231] CPU: Physical Processor ID: 0
[    0.004233] CPU: Processor Core ID: 0
[    0.004236] mce: CPU supports 6 MCE banks
[    0.004247] CPU0: Thermal monitoring enabled (TM2)
[    0.004251] using mwait in idle threads.
[    0.004259] Performance Events: Core events, core PMU driver.
[    0.004267] ... version:                1
[    0.004269] ... bit width:              40
[    0.004271] ... generic registers:      2
[    0.004273] ... value mask:             000000ffffffffff
[    0.004275] ... max period:             000000007fffffff
[    0.004277] ... fixed-purpose events:   0
[    0.004279] ... event mask:             0000000000000003
[    0.005424] ACPI: Core revision 20100428
[    0.028055] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.028459] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.071405] CPU0: Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.072000] Booting Node   0, Processors  #1 Ok.
[    0.008000] Initializing CPU#1
[    0.160000] TSC synchronization [CPU#0 -> CPU#1]:
[    0.160000] Measured 521301 cycles TSC warp between CPUs, turning off TSC clock.
[    0.160000] Marking TSC unstable due to check_tsc_sync_source failed
[    0.160016] Brought up 2 CPUs
[    0.160019] Total of 2 processors activated (7314.79 BogoMIPS).
[    0.160580] regulator: core version 0.5
[    0.160580] NET: Registered protocol family 16
[    0.160580] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.160580] ACPI: bus type pci registered
[    0.160580] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.160580] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.160580] PCI: Using MMCONFIG for extended config space
[    0.160580] PCI: Using configuration type 1 for base access
[    0.160580] bio: create slab <bio-0> at 0
[    0.164153] ACPI: EC: EC description table is found, configuring boot EC
[    0.177369] ACPI: SSDT 7f6f1d36 00240 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[    0.177969] ACPI: Dynamic OEM Table Load:
[    0.177973] ACPI: SSDT (null) 00240 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[    0.178354] ACPI: SSDT 7f6f1ffb 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[    0.178983] ACPI: Dynamic OEM Table Load:
[    0.178986] ACPI: SSDT (null) 0065A (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[    0.179459] ACPI: SSDT 7f6f1c6e 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[    0.180220] ACPI: Dynamic OEM Table Load:
[    0.180223] ACPI: SSDT (null) 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[    0.180386] ACPI: SSDT 7f6f1f76 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[    0.180970] ACPI: Dynamic OEM Table Load:
[    0.180973] ACPI: SSDT (null) 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[    0.181098] ACPI: Interpreter enabled
[    0.181108] ACPI: (supports S0 S3 S4 S5)
[    0.181133] ACPI: Using IOAPIC for interrupt routing
[    0.189503] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.189551] ACPI: Power Resource [PUBS] (on)
[    0.193424] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.193428] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.193894] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.193945] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.193949] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.193952] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.193956] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    0.193959] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.193962] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.193966] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff]
[    0.194030] pci 0000:00:02.0: reg 10: [mem 0xee100000-0xee17ffff]
[    0.194035] pci 0000:00:02.0: reg 14: [io  0x1800-0x1807]
[    0.194041] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
[    0.194046] pci 0000:00:02.0: reg 1c: [mem 0xee200000-0xee23ffff]
[    0.194083] pci 0000:00:02.1: reg 10: [mem 0xee180000-0xee1fffff]
[    0.194187] pci 0000:00:1b.0: reg 10: [mem 0xee240000-0xee243fff 64bit]
[    0.194247] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.194253] pci 0000:00:1b.0: PME# disabled
[    0.194349] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.194354] pci 0000:00:1c.0: PME# disabled
[    0.194452] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.194458] pci 0000:00:1c.1: PME# disabled
[    0.194556] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.194561] pci 0000:00:1c.2: PME# disabled
[    0.194660] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.194665] pci 0000:00:1c.3: PME# disabled
[    0.194728] pci 0000:00:1d.0: reg 20: [io  0x1820-0x183f]
[    0.194790] pci 0000:00:1d.1: reg 20: [io  0x1840-0x185f]
[    0.194852] pci 0000:00:1d.2: reg 20: [io  0x1860-0x187f]
[    0.194914] pci 0000:00:1d.3: reg 20: [io  0x1880-0x189f]
[    0.194973] pci 0000:00:1d.7: reg 10: [mem 0xee444000-0xee4443ff]
[    0.195035] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.195041] pci 0000:00:1d.7: PME# disabled
[    0.195203] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.195208] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
[    0.195213] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
[    0.195218] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
[    0.195223] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
[    0.195275] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.195284] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.195291] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.195300] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.195308] pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
[    0.195363] pci 0000:00:1f.2: reg 10: [io  0x18d0-0x18d7]
[    0.195371] pci 0000:00:1f.2: reg 14: [io  0x18c4-0x18c7]
[    0.195380] pci 0000:00:1f.2: reg 18: [io  0x18c8-0x18cf]
[    0.195388] pci 0000:00:1f.2: reg 1c: [io  0x18c0-0x18c3]
[    0.195396] pci 0000:00:1f.2: reg 20: [io  0x18b0-0x18bf]
[    0.195404] pci 0000:00:1f.2: reg 24: [mem 0xee444400-0xee4447ff]
[    0.195441] pci 0000:00:1f.2: PME# supported from D3hot
[    0.195446] pci 0000:00:1f.2: PME# disabled
[    0.196043] pci 0000:00:1f.3: reg 20: [io  0x18e0-0x18ff]
[    0.196248] pci 0000:02:00.0: reg 10: [mem 0xee000000-0xee01ffff]
[    0.196273] pci 0000:02:00.0: reg 18: [io  0x2000-0x201f]
[    0.196380] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.196388] pci 0000:02:00.0: PME# disabled
[    0.196424] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.196429] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.196435] pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
[    0.196444] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.196640] pci 0000:03:00.0: reg 10: [mem 0xedf00000-0xedf00fff]
[    0.196882] pci 0000:03:00.0: PME# supported from D0 D3hot
[    0.196895] pci 0000:03:00.0: PME# disabled
[    0.196960] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.196965] pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
[    0.196971] pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
[    0.196980] pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
[    0.197039] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.197045] pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
[    0.197050] pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
[    0.197059] pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
[    0.197119] pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
[    0.197124] pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
[    0.197130] pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
[    0.197139] pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
[    0.197208] pci 0000:15:00.0: reg 10: [mem 0xe4300000-0xe4300fff]
[    0.197239] pci 0000:15:00.0: supports D1 D2
[    0.197241] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.197247] pci 0000:15:00.0: PME# disabled
[    0.197317] pci 0000:00:1e.0: PCI bridge to [bus 15-18] (subtractive decode)
[    0.197323] pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
[    0.197329] pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
[    0.197337] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
[    0.197341] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.197344] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.197347] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.197350] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    0.197354] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.197357] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.197360] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfebfffff] (subtractive decode)
[    0.197447] pci_bus 0000:00: on NUMA node 0
[    0.197452] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.197607] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.197687] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.197767] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.197853] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.197940] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.203481] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.203693] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.203904] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.204126] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.204336] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.204545] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.204754] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.204965] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.205086] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.205100] vgaarb: loaded
[    0.205115] PCI: Using ACPI for IRQ routing
[    0.205115] PCI: pci_cache_line_size set to 64 bytes
[    0.205115] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
[    0.205115] reserve RAM buffer: 000000007f6d0000 - 000000007fffffff 
[    0.205115] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.205115] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.205115] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.208018] Switching to clocksource hpet
[    0.209499] pnp: PnP ACPI init
[    0.209510] ACPI: bus type pnp registered
[    0.213740] pnp: PnP ACPI: found 11 devices
[    0.213742] ACPI: ACPI bus type pnp unregistered
[    0.213746] PnPBIOS: Disabled by ACPI PNP
[    0.213758] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.213762] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.213766] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.213769] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.213773] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.213776] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
[    0.213780] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.213783] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.213787] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.213790] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.213794] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.213798] system 00:00: [mem 0x00100000-0x7fffffff] could not be reserved
[    0.213802] system 00:00: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.213809] system 00:02: [io  0x164e-0x164f] has been reserved
[    0.213812] system 00:02: [io  0x1000-0x107f] has been reserved
[    0.213816] system 00:02: [io  0x1180-0x11bf] has been reserved
[    0.213819] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.213822] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.213826] system 00:02: [io  0x1600-0x165f] could not be reserved
[    0.213830] system 00:02: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.213833] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.213837] system 00:02: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.213840] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.213844] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.213848] system 00:02: [mem 0xfed40000-0xfed40fff] has been reserved
[    0.248630] pci 0000:00:1c.0: BAR 15: assigned [mem 0x80000000-0x801fffff 64bit pref]
[    0.248634] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.248638] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.248645] pci 0000:00:1c.0:   bridge window [mem 0xee000000-0xee0fffff]
[    0.248651] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff 64bit pref]
[    0.248660] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.248664] pci 0000:00:1c.1:   bridge window [io  0x3000-0x4fff]
[    0.248671] pci 0000:00:1c.1:   bridge window [mem 0xec000000-0xedffffff]
[    0.248677] pci 0000:00:1c.1:   bridge window [mem 0xe4000000-0xe40fffff 64bit pref]
[    0.248685] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.248689] pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
[    0.248696] pci 0000:00:1c.2:   bridge window [mem 0xe8000000-0xe9ffffff]
[    0.248702] pci 0000:00:1c.2:   bridge window [mem 0xe4100000-0xe41fffff 64bit pref]
[    0.248710] pci 0000:00:1c.3: PCI bridge to [bus 0c-13]
[    0.248714] pci 0000:00:1c.3:   bridge window [io  0x7000-0x8fff]
[    0.248721] pci 0000:00:1c.3:   bridge window [mem 0xea000000-0xebffffff]
[    0.248727] pci 0000:00:1c.3:   bridge window [mem 0xe4200000-0xe42fffff 64bit pref]
[    0.248736] pci 0000:15:00.0: BAR 15: assigned [mem 0xe0000000-0xe3ffffff pref]
[    0.248740] pci 0000:15:00.0: BAR 16: assigned [mem 0x84000000-0x87ffffff]
[    0.248744] pci 0000:15:00.0: BAR 13: assigned [io  0x9000-0x90ff]
[    0.248747] pci 0000:15:00.0: BAR 14: assigned [io  0x9400-0x94ff]
[    0.248750] pci 0000:15:00.0: CardBus bridge to [bus 16-17]
[    0.248752] pci 0000:15:00.0:   bridge window [io  0x9000-0x90ff]
[    0.248759] pci 0000:15:00.0:   bridge window [io  0x9400-0x94ff]
[    0.248765] pci 0000:15:00.0:   bridge window [mem 0xe0000000-0xe3ffffff pref]
[    0.248772] pci 0000:15:00.0:   bridge window [mem 0x84000000-0x87ffffff]
[    0.248779] pci 0000:00:1e.0: PCI bridge to [bus 15-18]
[    0.248782] pci 0000:00:1e.0:   bridge window [io  0x9000-0xcfff]
[    0.248789] pci 0000:00:1e.0:   bridge window [mem 0xe4300000-0xe7ffffff]
[    0.248795] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe3ffffff 64bit pref]
[    0.248815] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.248822] pci 0000:00:1c.0: setting latency timer to 64
[    0.248834] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.248840] pci 0000:00:1c.1: setting latency timer to 64
[    0.248851] pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    0.248856] pci 0000:00:1c.2: setting latency timer to 64
[    0.248868] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.248873] pci 0000:00:1c.3: setting latency timer to 64
[    0.248879] pci 0000:00:1e.0: enabling device (0005 -> 0007)
[    0.248886] pci 0000:00:1e.0: setting latency timer to 64
[    0.248900] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.248907] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.248910] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.248913] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.248916] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.248919] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.248922] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.248925] pci_bus 0000:00: resource 10 [mem 0x80000000-0xfebfffff]
[    0.248928] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.248930] pci_bus 0000:02: resource 1 [mem 0xee000000-0xee0fffff]
[    0.248934] pci_bus 0000:02: resource 2 [mem 0x80000000-0x801fffff 64bit pref]
[    0.248937] pci_bus 0000:03: resource 0 [io  0x3000-0x4fff]
[    0.248940] pci_bus 0000:03: resource 1 [mem 0xec000000-0xedffffff]
[    0.248943] pci_bus 0000:03: resource 2 [mem 0xe4000000-0xe40fffff 64bit pref]
[    0.248946] pci_bus 0000:04: resource 0 [io  0x5000-0x6fff]
[    0.248949] pci_bus 0000:04: resource 1 [mem 0xe8000000-0xe9ffffff]
[    0.248952] pci_bus 0000:04: resource 2 [mem 0xe4100000-0xe41fffff 64bit pref]
[    0.248955] pci_bus 0000:0c: resource 0 [io  0x7000-0x8fff]
[    0.248958] pci_bus 0000:0c: resource 1 [mem 0xea000000-0xebffffff]
[    0.248961] pci_bus 0000:0c: resource 2 [mem 0xe4200000-0xe42fffff 64bit pref]
[    0.248964] pci_bus 0000:15: resource 0 [io  0x9000-0xcfff]
[    0.248967] pci_bus 0000:15: resource 1 [mem 0xe4300000-0xe7ffffff]
[    0.248970] pci_bus 0000:15: resource 2 [mem 0xe0000000-0xe3ffffff 64bit pref]
[    0.248973] pci_bus 0000:15: resource 4 [io  0x0000-0x0cf7]
[    0.248976] pci_bus 0000:15: resource 5 [io  0x0d00-0xffff]
[    0.248979] pci_bus 0000:15: resource 6 [mem 0x000a0000-0x000bffff]
[    0.248982] pci_bus 0000:15: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.248984] pci_bus 0000:15: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.248987] pci_bus 0000:15: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.248990] pci_bus 0000:15: resource 10 [mem 0x80000000-0xfebfffff]
[    0.248993] pci_bus 0000:16: resource 0 [io  0x9000-0x90ff]
[    0.248996] pci_bus 0000:16: resource 1 [io  0x9400-0x94ff]
[    0.248999] pci_bus 0000:16: resource 2 [mem 0xe0000000-0xe3ffffff pref]
[    0.249002] pci_bus 0000:16: resource 3 [mem 0x84000000-0x87ffffff]
[    0.249030] NET: Registered protocol family 2
[    0.249089] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.249317] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.250014] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.250363] TCP: Hash tables configured (established 131072 bind 65536)
[    0.250366] TCP reno registered
[    0.250371] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.250385] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.250480] NET: Registered protocol family 1
[    0.250499] pci 0000:00:02.0: Boot video device
[    0.250745] PCI: CLS mismatch (64 != 32), using 64 bytes
[    0.250805] Unpacking initramfs...
[    0.595921] Freeing initrd memory: 9952k freed
[    0.601771] Simple Boot Flag at 0x35 set to 0x1
[    0.602099] audit: initializing netlink socket (disabled)
[    0.602116] type=2000 audit(1274612550.600:1): initialized
[    0.602380] highmem bounce pool size: 64 pages
[    0.602386] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.603993] VFS: Disk quotas dquot_6.5.2
[    0.604053] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.604160] msgmni has been set to 1732
[    0.604413] alg: No test for stdrng (krng)
[    0.604480] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.604484] io scheduler noop registered
[    0.604486] io scheduler deadline registered
[    0.604527] io scheduler cfq registered (default)
[    0.604625] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.604682] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.604784] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.604834] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.604933] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.604983] pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
[    0.605079] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.605129] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    0.605332] isapnp: Scanning for PnP cards...
[    0.959580] isapnp: No Plug & Play device found
[    0.960813] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.960964] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    0.961313] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.968844] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.968851] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.968905] mice: PS/2 mouse device common for all mice
[    0.968958] rtc_cmos 00:07: RTC can wake from S4
[    0.968991] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.969029] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.969040] cpuidle: using governor ladder
[    0.969042] cpuidle: using governor menu
[    0.969047] No iBFT detected.
[    0.969314] TCP cubic registered
[    0.969451] NET: Registered protocol family 10
[    0.969832] lo: Disabled Privacy Extensions
[    0.970083] Mobile IPv6
[    0.970086] NET: Registered protocol family 17
[    0.970101] Using IPI No-Shortcut mode
[    0.970160] registered taskstats version 1
[    0.970675] rtc_cmos 00:07: setting system clock to 2010-05-23 11:02:31 UTC (1274612551)
[    0.970770] Freeing unused kernel memory: 380k freed
[    0.971004] Write protecting the kernel text: 2416k
[    0.971029] Write protecting the kernel read-only data: 868k
[    0.973464] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.192096] usbcore: registered new interface driver usbfs
[    1.192244] usbcore: registered new interface driver hub
[    1.192285] usbcore: registered new device driver usb
[    1.217016] Uniform Multi-Platform E-IDE driver
[    1.226312] SCSI subsystem initialized
[    1.231992] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
[    1.231995] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    1.232093] e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.232120] e1000e 0000:02:00.0: setting latency timer to 64
[    1.232308] e1000e 0000:02:00.0: irq 44 for MSI/MSI-X
[    1.232801] e1000e 0000:02:00.0: Disabling ASPM L0s 
[    1.234327] thermal LNXTHERM:01: registered as thermal_zone0
[    1.234337] ACPI: Thermal Zone [THM0] (55 C)
[    1.236322] thermal LNXTHERM:02: registered as thermal_zone1
[    1.236332] ACPI: Thermal Zone [THM1] (57 C)
[    1.238286] uhci_hcd: USB Universal Host Controller Interface driver
[    1.238352] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.238355] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    1.238518] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.238747] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    1.238756] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.238767] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.238772] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.238801] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    1.238848] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
[    1.238894] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    1.238897] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.238900] usb usb1: Product: UHCI Host Controller
[    1.238903] usb usb1: Manufacturer: Linux 2.6.34 uhci_hcd
[    1.238906] usb usb1: SerialNumber: 0000:00:1d.0
[    1.239104] hub 1-0:1.0: USB hub found
[    1.239109] hub 1-0:1.0: 2 ports detected
[    1.239189] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.239196] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.239200] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.239208] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[    1.239246] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
[    1.239281] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.239284] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.239287] usb usb2: Product: UHCI Host Controller
[    1.239290] usb usb2: Manufacturer: Linux 2.6.34 uhci_hcd
[    1.239293] usb usb2: SerialNumber: 0000:00:1d.1
[    1.239442] hub 2-0:1.0: USB hub found
[    1.239447] hub 2-0:1.0: 2 ports detected
[    1.239732] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[    1.239913] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[    1.239921] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.239928] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.239932] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.239941] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[    1.239981] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
[    1.240031] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.240034] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.240037] usb usb3: Product: UHCI Host Controller
[    1.240039] usb usb3: Manufacturer: Linux 2.6.34 uhci_hcd
[    1.240042] usb usb3: SerialNumber: 0000:00:1d.2
[    1.240190] hub 3-0:1.0: USB hub found
[    1.240195] hub 3-0:1.0: 2 ports detected
[    1.240263] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.240270] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    1.240274] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.240281] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[    1.240319] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
[    1.240354] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.240357] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.240360] usb usb4: Product: UHCI Host Controller
[    1.240363] usb usb4: Manufacturer: Linux 2.6.34 uhci_hcd
[    1.240366] usb usb4: SerialNumber: 0000:00:1d.3
[    1.240511] hub 4-0:1.0: USB hub found
[    1.240516] hub 4-0:1.0: 2 ports detected
[    1.248257] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    1.248443] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    1.248452] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.248466] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.248470] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.248482] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[    1.248501] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    1.248514] ehci_hcd 0000:00:1d.7: debug port 1
[    1.252411] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.252417] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee444000
[    1.262096] libata version 3.00 loaded.
[    1.268082] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.268110] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    1.268113] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.268116] usb usb5: Product: EHCI Host Controller
[    1.268119] usb usb5: Manufacturer: Linux 2.6.34 ehci_hcd
[    1.268122] usb usb5: SerialNumber: 0000:00:1d.7
[    1.268223] hub 5-0:1.0: USB hub found
[    1.268229] hub 5-0:1.0: 8 ports detected
[    1.271572] piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x02)
[    1.271586] PIIX_IDE 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[    1.271600] piix 0000:00:1f.1: IDE port disabled
[    1.271610] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    1.271617]     ide0: BM-DMA at 0x1810-0x1817
[    1.271624] Probing IDE interface ide0...
[    1.365394] e1000e 0000:02:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:00:00:f0:1d:00
[    1.365399] e1000e 0000:02:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.365537] e1000e 0000:02:00.0: eth0: MAC: 2, PHY: 2, PBA No: 005301-003
[    2.004357] hda: HL-DT-STCD-RW/DVD DRIVE GCC-4247N, ATAPI CD/DVD-ROM drive
[    2.340058] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    2.341033] hda: UDMA/33 mode selected
[    2.342048] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.343876] ahci 0000:00:1f.2: version 3.0
[    2.343894] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.343947] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    2.344033] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
[    2.344038] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[    2.344045] ahci 0000:00:1f.2: setting latency timer to 64
[    2.344166] scsi0 : ahci
[    2.344289] scsi1 : ahci
[    2.344350] scsi2 : ahci
[    2.344409] scsi3 : ahci
[    2.344513] ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 45
[    2.344516] ata2: DUMMY
[    2.344517] ata3: DUMMY
[    2.344519] ata4: DUMMY
[    2.720030] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.213894] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.213900] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.213904] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.215040] ata1.00: ATA-7: SAMSUNG MMCRE64G5MXP-0VB, VBM1801Q, max UDMA/100
[    3.215044] ata1.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.215421] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    3.215426] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    3.215430] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.216522] ata1.00: configured for UDMA/100
[    3.234256] ata1.00: configured for UDMA/100
[    3.234260] ata1: EH complete
[    3.234378] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG MMCRE64G VBM1 PQ: 0 ANSI: 5
[    3.245536] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
[    3.245602] sd 0:0:0:0: [sda] Write Protect is off
[    3.245605] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.245633] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.245792]  sda: sda1 sda2
[    3.246672] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.256161] ide-cd driver 5.00
[    3.258307] ide-cd: hda: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
[    3.258313] Uniform CD-ROM driver Revision: 3.20
[    3.329452] device-mapper: uevent: version 1.0.3
[    3.329605] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    3.616643] udev: starting version 154
[    3.781568] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    3.782300] intel_rng: FWH not detected
[    3.782917] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    3.783192] Linux agpgart interface v0.103
[    3.790168] ACPI: Lid Switch [LID]
[    3.790249] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input3
[    3.790291] ACPI: Sleep Button [SLPB]
[    3.790480] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    3.790504] ACPI: Power Button [PWRF]
[    3.794675] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.875423] Non-volatile memory driver v1.3
[    3.890709] agpgart-intel 0000:00:00.0: Intel 945GM Chipset
[    3.891734] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    3.896073] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    3.897064] cfg80211: Calling CRDA to update world regulatory domain
[    3.899578] acpi device:01: registered as cooling_device2
[    3.900098] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    3.900137] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    3.908737] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:2012]
[    3.908763] yenta_cardbus 0000:15:00.0: Using INTVAL to route CSC interrupts to PCI
[    3.908766] yenta_cardbus 0000:15:00.0: Routing CardBus interrupts to PCI
[    3.908773] yenta_cardbus 0000:15:00.0: TI: mfunc 0x01d01002, devctl 0x64
[    3.930093] NET: Registered protocol family 23
[    3.936785] ACPI: Battery Slot [BAT0] (battery present)
[    3.941520] udev: renamed network interface eth0 to eth1
[    3.942569] ACPI: AC Adapter [AC] (on-line)
[    3.975274] nsc-ircc, chip->init
[    3.975290] nsc-ircc, Found chip at base=0x164e
[    3.975349] nsc-ircc, driver loaded (Dag Brattli)
[    3.975372] nsc_ircc_open(), can't get iobase of 0x2f8
[    3.975418] nsc-ircc, Found chip at base=0x164e
[    3.975458] nsc-ircc, driver loaded (Dag Brattli)
[    3.975462] nsc_ircc_open(), can't get iobase of 0x2f8
[    3.975827] nsc-ircc 00:0a: disabled
[    3.976376] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    3.976378] thinkpad_acpi: http://ibm-acpi.sf.net/
[    3.976381] thinkpad_acpi: ThinkPad BIOS 79ETE6WW (2.26 ), EC 79HT50WW-1.07
[    3.976383] thinkpad_acpi: Lenovo ThinkPad T60, model 1952WUV
[    3.976726] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    3.977032] thinkpad_acpi: radio switch found; radios are enabled
[    3.977049] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    3.977052] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    3.983553] Registered led device: tpacpi::thinklight
[    3.983580] Registered led device: tpacpi::power
[    3.983607] Registered led device: tpacpi::standby
[    3.983624] Registered led device: tpacpi::thinkvantage
[    4.004880] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[    4.004964] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    4.011589] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input6
[    4.055206] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
[    4.055209] iwl3945: Copyright(c) 2003-2010 Intel Corporation
[    4.055321] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.055336] iwl3945 0000:03:00.0: setting latency timer to 64
[    4.109371] iwl3945 0000:03:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[    4.109375] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
[    4.114222] iwl3945 0000:03:00.0: irq 46 for MSI/MSI-X
[    4.142673] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cf8, PCI irq 16
[    4.142678] yenta_cardbus 0000:15:00.0: Socket status: 30000007
[    4.142686] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [io  0x9000-0xcfff]
[    4.142690] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x9000-0xcfff: excluding 0x9000-0x90ff 0x9400-0x94ff
[    4.190459] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe4300000-0xe7ffffff]
[    4.190464] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe4300000-0xe7ffffff: excluding 0xe4300000-0xe46cffff
[    4.190479] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge window: [mem 0xe0000000-0xe3ffffff 64bit pref]
[    4.190483] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0xe3ffffff: excluding 0xe0000000-0xe3ffffff
[    4.193698] phy0: Selected rate control algorithm 'iwl-3945-rs'
[    4.247864] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.247869] hda_intel: probe_mask set to 0x1 for device 17aa:2010
[    4.247929] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[    4.247969] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    4.252453] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: excluding 0x170-0x177 0x1f0-0x1f7 0x2f8-0x2ff 0x370-0x377
[    4.254618] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding 0x3f0-0x3f7 0x4d0-0x4d7
[    4.255542] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
[    4.256337] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
[    4.258050] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcffff 0xdc000-0xfffff
[    4.258116] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: clean.
[    4.258181] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
[    4.258248] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
[    4.292245] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
[    4.438385] Adding 2104476k swap on /dev/sda1.  Priority:-1 extents:1 across:2104476k SS
[    4.559922] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000/0x0
[    4.559928] serio: Synaptics pass-through port at isa0060/serio1/input0
[    4.603227] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8
[    4.646998] loop: module loaded
[    5.130591] fuse init (API version 7.13)
[    5.170148] input: ACPI Virtual Keyboard Device as /devices/virtual/input/input9
[    5.233931] apm: BIOS not found.
[    5.641414] e1000e 0000:02:00.0: irq 44 for MSI/MSI-X
[    5.697218] e1000e 0000:02:00.0: irq 44 for MSI/MSI-X
[    5.697817] ADDRCONF(NETDEV_UP): eth1: link is not ready
[    5.727288] iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
[    5.869395] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    5.885795] Bluetooth: Core ver 2.15
[    5.885824] NET: Registered protocol family 31
[    5.885826] Bluetooth: HCI device and connection manager initialized
[    5.885830] Bluetooth: HCI socket layer initialized
[    5.921031] Bluetooth: L2CAP ver 2.14
[    5.921035] Bluetooth: L2CAP socket layer initialized
[    5.925674] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.925677] Bluetooth: BNEP filters: protocol multicast
[    5.989578] Bridge firewalling registered
[    6.030989] Bluetooth: SCO (Voice Link) ver 0.6
[    6.030992] Bluetooth: SCO socket layer initialized
[    6.053164] Bluetooth: RFCOMM TTY layer initialized
[    6.053170] Bluetooth: RFCOMM socket layer initialized
[    6.053172] Bluetooth: RFCOMM ver 1.11
[    6.370959] ttyS1: LSR safety check engaged!
[    6.522441] lp: driver loaded but no devices found
[    6.553105] ppdev: user-space parallel port driver
[    6.821371] input: /usr/sbin/thinkpad-keys as /devices/virtual/input/input10
[    7.131594] [drm] Initialized drm 1.1.0 20060810
[    7.164311] i915 0000:00:02.0: power state changed by ACPI to D0
[    7.164358] i915 0000:00:02.0: power state changed by ACPI to D0
[    7.164368] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.164377] i915 0000:00:02.0: setting latency timer to 64
[    7.169168] [drm] set up 7M of stolen space
[    7.626500] [drm] initialized overlay support
[    8.103765] Console: switching to colour frame buffer device 128x48
[    8.103773] fb0: inteldrmfb frame buffer device
[    8.103776] drm: registered panic notifier
[    8.103779] Slow work thread pool: Starting up
[    8.103838] Slow work thread pool: Ready
[    8.103846] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   10.881762] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   11.113297] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input11
[   14.901816] wlan0: Selected IBSS BSSID 06:be:a1:c9:16:c0 based on configured SSID
[   16.231904] BUG: unable to handle kernel NULL pointer dereference at (null)
[   16.231914] IP: [<f8309788>] iwl3945_request_scan+0x39a/0x50b [iwl3945]
[   16.231927] *pde = 00000000 
[   16.231930] Oops: 0000 [#1] SMP 
[   16.231934] last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq
[   16.231938] Modules linked in: i915 drm_kms_helper drm i2c_algo_bit ppdev lp parport sco rfcomm bridge stp bnep l2cap crc16 bluetooth acpi_cpufreq mperf cpufreq_conservative cpufreq_userspace cpufreq_stats cpufreq_powersave uinput fuse loop joydev dm_crypt snd_hda_codec_analog snd_hda_intel pcmcia snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss arc4 snd_pcm ecb snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq iwl3945 snd_timer iwlcore snd_seq_device thinkpad_acpi mac80211 led_class irda tpm_tis yenta_socket crc_ccitt snd tpm nvram ac battery video tpm_bios intel_agp output pcmcia_rsrc cfg80211 i2c_i801 psmouse pcmcia_core serio_raw evdev pcspkr button rng_core agpgart soundcore processor i2c_core rfkill snd_page_alloc ext2 mbcache dm_mod ide_cd_mod cdrom ata_generic sd_mod crc_t10dif ata_piix ide_pci_generic ahci libahci piix libata uhci_hcd ehci_hcd e1000e thermal thermal_sys scsi_mod ide_core usbcore nls_base [last unloaded: scsi_wait_scan]
[   16.232007] 
[   16.232007] Pid: 672, comm: iwl3945 Not tainted 2.6.34 #1 1952WUV/1952WUV
[   16.232007] EIP: 0060:[<f8309788>] EFLAGS: 00010283 CPU: 0
[   16.232007] EIP is at iwl3945_request_scan+0x39a/0x50b [iwl3945]
[   16.232007] EAX: f6852000 EBX: f6b90ae0 ECX: 00000000 EDX: 00000000
[   16.232007] ESI: f65270f2 EDI: 00000000 EBP: 00000000 ESP: f6aa7f10
[   16.232007]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   16.232007] Process iwl3945 (pid: 672, ti=f6aa6000 task=f6911450 task.ti=f6aa6000)
[   16.232007] Stack:
[   16.232007]  00000058 f6252000 c102a78d 00000001 00000000 00000000 00807fc0 f6250001
[   16.232007] <0> c1259683 76d34243 00000003 00214198 005700ff f6527000 00000000 00000000
[   16.232007] <0> 00000000 00000001 008000d8 f6b90ae0 f6b91058 f6b96718 f6b96718 f82a4889
[   16.232007] Call Trace:
[   16.232007]  [<c102a78d>] ? finish_task_switch+0x2e/0x91
[   16.232007]  [<c1259683>] ? schedule+0x48c/0x4dc
[   16.232007]  [<f82a4889>] ? iwl_bg_start_internal_scan+0x78/0x93 [iwlcore]
[   16.232007]  [<c1040b5e>] ? worker_thread+0x142/0x1c2
[   16.232007]  [<f82a4811>] ? iwl_bg_start_internal_scan+0x0/0x93 [iwlcore]
[   16.232007]  [<c104396e>] ? autoremove_wake_function+0x0/0x29
[   16.232007]  [<c1040a1c>] ? worker_thread+0x0/0x1c2
[   16.232007]  [<c1043633>] ? kthread+0x5f/0x64
[   16.232007]  [<c10435d4>] ? kthread+0x0/0x64
[   16.232007]  [<c10034be>] ? kernel_thread_helper+0x6/0x10
[   16.232007] Code: 00 00 00 b8 01 00 00 00 d3 e0 88 44 24 1c 83 e8 02 88 44 24 30 8b 04 24 48 66 89 44 24 32 e9 c9 00 00 00 8b 54 24 14 8b 6c 90 20 <39> 7d 00 0f 85 b4 00 00 00 66 8b 4d 06 89 fa 89 d8 88 4e 01 0f 
[   16.232007] EIP: [<f8309788>] iwl3945_request_scan+0x39a/0x50b [iwl3945] SS:ESP 0068:f6aa7f10
[   16.232007] CR2: 0000000000000000
[   16.232203] ---[ end trace ec53fd3c9aa994a4 ]---
[   25.356030] wlan0: no IPv6 routers present

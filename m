Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out4.starman.ee ([85.253.0.6]:35797 "EHLO mx2.starman.ee"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754601Ab2BJBxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 20:53:52 -0500
To: IvDoorn@gmail.com
Subject: phy1 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
Cc: linux-wireless@vger.kernel.org
Message-Id: <20120210012321.CA97C17F947@vari.ath.cx> (sfid-20120210_025359_554387_6375E3CB)
Date: Fri, 10 Feb 2012 03:23:21 +0200 (EET)
From: madis@cyber.ee (Mj)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

phy1 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.

I get this error fairly regularly (about once per day or two) and
the wireless stops working after that. Work-around is suspending
the laptop (EeePC 1000) and waking it again - after that
the rt2800pci driver seems to get into working state again.

dmesg output:
-----------------------------
Linux version 3.2.2-dirty (mzz@predator) (gcc version 4.6.1 20110604 (prerelease) (Debian 4.6.0-11) ) #10 SMP Sun Jan 29 19:51:18 EET 2012
KERNEL supported cpus:
  Intel GenuineIntel
Atom PSE erratum detected, BIOS microcode update recommended
Disabled fast string operations
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003f7a0000 (usable)
 BIOS-e820: 000000003f7a0000 - 000000003f7ae000 (ACPI data)
 BIOS-e820: 000000003f7ae000 - 000000003f7f0000 (ACPI NVS)
 BIOS-e820: 000000003f7f0000 - 000000003f800000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI present.
DMI: ASUSTeK Computer INC. 1000/1000, BIOS 0803    08/01/2008
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x3f7a0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-DFFFF uncachable
  E0000-E3FFF write-protect
  E4000-EFFFF write-through
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask 0C0000000 write-back
  1 base 03F800000 mask 0FF800000 uncachable
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
original variable MTRRs
reg 0, base: 0GB, range: 1GB, type WB
reg 1, base: 1016MB, range: 8MB, type UC
total RAM covered: 1016M
Found optimal setting for mtrr clean up
 gran_size: 64K 	chunk_size: 16M 	num_reg: 2  	lose cover RAM: 0G
New variable MTRRs
reg 0, base: 0GB, range: 1GB, type WB
reg 1, base: 1016MB, range: 8MB, type UC
initial memory mapped : 0 - 00c00000
Base memory trampoline at [b009b000] 9b000 size 16384
init_memory_mapping: 0000000000000000-000000003f7a0000
 0000000000 - 003f7a0000 page 4k
kernel direct mapping tables up to 3f7a0000 @ aff000-c00000
ACPI: RSDP 000fbcd0 00014 (v00 ACPIAM)
ACPI: RSDT 3f7a0000 0003C (v01 A_M_I_ OEMRSDT  08000801 MSFT 00000097)
ACPI: FACP 3f7a0200 00084 (v02 A_M_I_ OEMFACP  08000801 MSFT 00000097)
ACPI: DSDT 3f7a05b0 053AF (v01  P0018 P0018000 00000000 INTL 20051117)
ACPI: FACS 3f7ae000 00040
ACPI: APIC 3f7a0390 0005C (v01 A_M_I_ OEMAPIC  08000801 MSFT 00000097)
ACPI: MCFG 3f7a03f0 0003C (v01 A_M_I_ OEMMCFG  08000801 MSFT 00000097)
ACPI: OEMB 3f7ae040 00061 (v01 A_M_I_ AMI_OEM  08000801 MSFT 00000097)
ACPI: HPET 3f7a5960 00038 (v01 A_M_I_ OEMHPET  08000801 MSFT 00000097)
ACPI: SSDT 3f7aeb80 004F0 (v01  PmRef    CpuPm 00003000 INTL 20051117)
ACPI: Local APIC address 0xfee00000
1015MB LOWMEM available.
  mapped low ram: 0 - 3f7a0000
  low ram: 0 - 3f7a0000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x0003f7a0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003f7a0
On node 0 totalpages: 259887
free_area_init_node: node 0, pgdat b05dcdc0, node_mem_map eefb0200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 2000 pages used for memmap
  Normal zone: 253904 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0xffffffff base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
Allocating PCI resources starting at 3f800000 (gap: 3f800000:bf600000)
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 11 pages/cpu @eef94000 s23360 r0 d21696 u45056
pcpu-alloc: s23360 r0 d21696 u45056 alloc=11*4096
pcpu-alloc: [0] 0 [0] 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257855
Kernel command line: auto BOOT_IMAGE=Linux ro root=802 quiet usbcore.autosuspend=1 enable_mtrr_cleanup rootfstype=ext4
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Memory: 1024960k/1040000k available (2855k kernel code, 14588k reserved, 1119k data, 304k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff8f000 - 0xfffff000   ( 448 kB)
    vmalloc : 0xeffa0000 - 0xfff8d000   ( 255 MB)
    lowmem  : 0xb0000000 - 0xef7a0000   (1015 MB)
      .init : 0xb05e2000 - 0xb062e000   ( 304 kB)
      .data : 0xb04c9f42 - 0xb05e1d00   (1119 kB)
      .text : 0xb0200000 - 0xb04c9f42   (2855 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Hierarchical RCU implementation.
	CONFIG_RCU_FANOUT set to non-default value of 4
	RCU dyntick-idle grace-period acceleration is enabled.
NR_IRQS:2304 nr_irqs:512 16
CPU 0 irqstacks, hard=ee802000 soft=ee804000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 1600.220 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3200.44 BogoMIPS (lpj=6400880)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
Atom PSE erratum detected, BIOS microcode update recommended
Disabled fast string operations
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
ACPI: Core revision 20110623
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
Performance Events: PEBS fmt0+, Atom events, Intel PMU driver.
... version:                3
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
CPU 1 irqstacks, hard=ee85e000 soft=ee860000
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Atom PSE erratum detected, BIOS microcode update recommended
Disabled fast string operations
Brought up 2 CPUs
Total of 2 processors activated (6400.35 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=6
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: SSDT 3f7ae180 0023C (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 0023C (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
ACPI: SSDT 3f7ae450 00724 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00724 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
ACPI: SSDT 3f7ae0b0 000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 000CC (v01  PmRef  Cpu1Ist 00003000 INTL 20051117)
ACPI: SSDT 3f7ae3c0 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT   (null) 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20051117)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
pci_root PNP0A08:00: host bridge window [mem 0x3f800000-0xffffffff]
pci 0000:00:00.0: [8086:27ac] type 0 class 0x000600
pci 0000:00:02.0: [8086:27ae] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xf7f00000-0xf7f7ffff]
pci 0000:00:02.0: reg 14: [io  0xdc80-0xdc87]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
pci 0000:00:02.0: reg 1c: [mem 0xf7ec0000-0xf7efffff]
pci 0000:00:02.1: [8086:27a6] type 0 class 0x000380
pci 0000:00:02.1: reg 10: [mem 0xf7f80000-0xf7ffffff]
pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xf7eb8000-0xf7ebbfff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: [8086:27d4] type 1 class 0x000604
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: [8086:27d6] type 1 class 0x000604
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0xd480-0xd49f]
pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0xd800-0xd81f]
pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0xd880-0xd89f]
pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
pci 0000:00:1d.3: reg 20: [io  0xdc00-0xdc1f]
pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xf7eb7c00-0xf7eb7fff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0380 (mask 0003)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 0007)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0068 (mask 0003)
pci 0000:00:1f.2: [8086:27c4] type 0 class 0x000101
pci 0000:00:1f.2: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.2: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.2: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.2: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.2: reg 20: [io  0xffa0-0xffaf]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
pci 0000:00:1c.0: PCI bridge to [bus 05-05]
pci 0000:04:00.0: [1969:1026] type 0 class 0x000200
pci 0000:04:00.0: reg 10: [mem 0xfbfc0000-0xfbffffff 64bit]
pci 0000:04:00.0: reg 18: [io  0xec80-0xecff]
pci 0000:04:00.0: PME# supported from D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:1c.1: PCI bridge to [bus 04-04]
pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
pci 0000:00:1c.1:   bridge window [mem 0xfbf00000-0xfbffffff]
pci 0000:00:1c.2: PCI bridge to [bus 03-03]
pci 0000:01:00.0: [1814:0781] type 0 class 0x000280
pci 0000:01:00.0: reg 10: [mem 0xfbef0000-0xfbefffff]
pci 0000:01:00.0: PME# supported from D0 D3hot
pci 0000:01:00.0: PME# disabled
pci 0000:00:1c.3: PCI bridge to [bus 01-02]
pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xfbefffff]
pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf6ffffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 06-06] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x3f800000-0xffffffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
 pci0000:00: Unable to request _OSC control (_OSC support mask: 0x19)
ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Version 1.0.24.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
reserve RAM buffer: 000000003f7a0000 - 000000003fffffff 
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
cfg80211: Calling CRDA to update world regulatory domain
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000d0000-0x000dffff window]
pnp 00:00: [mem 0x3f800000-0xffffffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [mem 0xfed13000-0xfed19fff]
system 00:01: [mem 0xfed13000-0xfed19fff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:02: [dma 4]
pnp 00:02: [io  0x0000-0x000f]
pnp 00:02: [io  0x0081-0x0083]
pnp 00:02: [io  0x0087]
pnp 00:02: [io  0x0089-0x008b]
pnp 00:02: [io  0x008f]
pnp 00:02: [io  0x00c0-0x00df]
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: [io  0x0070-0x0071]
pnp 00:03: [irq 8]
pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:04: [io  0x0060]
pnp 00:04: [io  0x0064]
pnp 00:04: [irq 1]
pnp 00:04: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
pnp 00:05: [irq 12]
pnp 00:05: Plug and Play ACPI device, IDs SYN0a04 SYN0a00 SYN0002 PNP0f13 (active)
pnp 00:06: [io  0x0061]
pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:07: [io  0x00f0-0x00ff]
pnp 00:07: [irq 13]
pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:08: [io  0x0010-0x001f]
pnp 00:08: [io  0x0022-0x003f]
pnp 00:08: [io  0x0044-0x004d]
pnp 00:08: [io  0x0050-0x005e]
pnp 00:08: [io  0x0063]
pnp 00:08: [io  0x0065]
pnp 00:08: [io  0x0067-0x006f]
pnp 00:08: [io  0x0072-0x007f]
pnp 00:08: [io  0x0080]
pnp 00:08: [io  0x0084-0x0086]
pnp 00:08: [io  0x0088]
pnp 00:08: [io  0x008c-0x008e]
pnp 00:08: [io  0x0090-0x009f]
pnp 00:08: [io  0x00a2-0x00bf]
pnp 00:08: [io  0x00e0-0x00ef]
pnp 00:08: [io  0x025c-0x025f]
pnp 00:08: [io  0x0380-0x0383]
pnp 00:08: [io  0x0400-0x041f]
pnp 00:08: [io  0x04d0-0x04d1]
pnp 00:08: [io  0x0800-0x087f]
pnp 00:08: [io  0x0400-0x03ff disabled]
pnp 00:08: [io  0x0480-0x04bf]
pnp 00:08: [mem 0x8c000000-0x8c01ffff]
pnp 00:08: [mem 0xfed1c000-0xfed1ffff]
pnp 00:08: [mem 0xfed20000-0xfed3ffff]
pnp 00:08: [mem 0xfed50000-0xfed8ffff]
pnp 00:08: [mem 0xffb00000-0xffbfffff]
pnp 00:08: [mem 0xfff00000-0xffffffff]
system 00:08: [io  0x025c-0x025f] has been reserved
system 00:08: [io  0x0380-0x0383] has been reserved
system 00:08: [io  0x0400-0x041f] has been reserved
system 00:08: [io  0x04d0-0x04d1] has been reserved
system 00:08: [io  0x0800-0x087f] has been reserved
system 00:08: [io  0x0480-0x04bf] has been reserved
system 00:08: [mem 0x8c000000-0x8c01ffff] has been reserved
system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:08: [mem 0xfed50000-0xfed8ffff] has been reserved
system 00:08: [mem 0xffb00000-0xffbfffff] has been reserved
system 00:08: [mem 0xfff00000-0xffffffff] could not be reserved
system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:09: [mem 0xfed00000-0xfed003ff]
pnp 00:09: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:0a: [mem 0xfec00000-0xfec00fff]
pnp 00:0a: [mem 0xfee00000-0xfee00fff]
system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0a: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0b: [mem 0xe0000000-0xe3ffffff]
system 00:0b: [mem 0xe0000000-0xe3ffffff] has been reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: [mem 0x00000000-0x0009ffff]
pnp 00:0c: [mem 0x000c0000-0x000cffff]
pnp 00:0c: [mem 0x000e0000-0x000fffff]
pnp 00:0c: [mem 0x00100000-0x3f7fffff]
pnp 00:0c: [mem 0x00000000-0xffffffff disabled]
system 00:0c: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0c: [mem 0x000c0000-0x000cffff] could not be reserved
system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0c: [mem 0x00100000-0x3f7fffff] could not be reserved
system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PCI: max bus depth: 1 pci_try_num: 2
pci 0000:00:1c.3: BAR 7: assigned [io  0x1000-0x1fff]
pci 0000:00:1c.2: BAR 8: assigned [mem 0x3f800000-0x3f9fffff]
pci 0000:00:1c.2: BAR 9: assigned [mem 0x3fa00000-0x3fbfffff 64bit pref]
pci 0000:00:1c.2: BAR 7: assigned [io  0x2000-0x2fff]
pci 0000:00:1c.1: BAR 9: assigned [mem 0x3fc00000-0x3fdfffff 64bit pref]
pci 0000:00:1c.0: BAR 8: assigned [mem 0x3fe00000-0x3fffffff]
pci 0000:00:1c.0: BAR 9: assigned [mem 0x40000000-0x401fffff 64bit pref]
pci 0000:00:1c.0: BAR 7: assigned [io  0x3000-0x3fff]
pci 0000:00:1c.0: PCI bridge to [bus 05-05]
pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.0:   bridge window [mem 0x3fe00000-0x3fffffff]
pci 0000:00:1c.0:   bridge window [mem 0x40000000-0x401fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 04-04]
pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
pci 0000:00:1c.1:   bridge window [mem 0xfbf00000-0xfbffffff]
pci 0000:00:1c.1:   bridge window [mem 0x3fc00000-0x3fdfffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 03-03]
pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.2:   bridge window [mem 0x3f800000-0x3f9fffff]
pci 0000:00:1c.2:   bridge window [mem 0x3fa00000-0x3fbfffff 64bit pref]
pci 0000:00:1c.3: PCI bridge to [bus 01-02]
pci 0000:00:1c.3:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.3:   bridge window [mem 0xf8000000-0xfbefffff]
pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf6ffffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 06-06]
pci 0000:00:1c.0: enabling device (0104 -> 0107)
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: enabling device (0104 -> 0107)
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: enabling device (0106 -> 0107)
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:00: resource 8 [mem 0x3f800000-0xffffffff]
pci_bus 0000:05: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:05: resource 1 [mem 0x3fe00000-0x3fffffff]
pci_bus 0000:05: resource 2 [mem 0x40000000-0x401fffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
pci_bus 0000:04: resource 1 [mem 0xfbf00000-0xfbffffff]
pci_bus 0000:04: resource 2 [mem 0x3fc00000-0x3fdfffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:03: resource 1 [mem 0x3f800000-0x3f9fffff]
pci_bus 0000:03: resource 2 [mem 0x3fa00000-0x3fbfffff 64bit pref]
pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfbefffff]
pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf6ffffff 64bit pref]
pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:06: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:06: resource 8 [mem 0x3f800000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 32 bytes, default 64
fuse init (API version 7.17)
msgmni has been set to 2001
io scheduler noop registered
io scheduler deadline registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.2: setting latency timer to 64
pcieport 0000:00:1c.2: irq 42 for MSI/MSI-X
pcieport 0000:00:1c.3: setting latency timer to 64
pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
ACPI: AC Adapter [AC0] (on-line)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
ACPI: Power Button [PWRF]
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Marking TSC unstable due to TSC halts in idle
ACPI: acpi_idle registered with cpuidle
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (58 C)
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GME Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 262144K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
composite sync not supported
ACPI: Battery Slot [BAT0] (battery present)
[drm] initialized overlay support
composite sync not supported
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 128x37
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
loop: module loaded
ata_piix 0000:00:1f.2: version 2.13
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ATL1E 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ATL1E 0000:04:00.0: setting latency timer to 64
rt2800pci 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
rt2800pci 0000:01:00.0: setting latency timer to 64
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt2800pci-phy0::radio
Registered led device: rt2800pci-phy0::assoc
Registered led device: rt2800pci-phy0::quality
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: using broken periodic workaround
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.2.2-dirty ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d480
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 3.2.2-dirty uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d800
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.2.2-dirty uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d880
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.2.2-dirty uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000dc00
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.2.2-dirty uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usbcore: registered new interface driver uas
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input5
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ACPI: resource 0000:00:1f.3 [io  0x0400-0x041f] conflicts with ACPI region SMRG [io 0x400-0x40f]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Linux video capture interface: v2.00
cpuidle: using governor ladder
cpuidle: using governor menu
ALSA device list:
  No soundcards found.
nf_conntrack version 0.5.0 (16015 buckets, 64060 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP westwood registered
NET: Registered protocol family 17
Using IPI No-Shortcut mode
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input6
ata2.00: CFA: ASUS-PHISON SSD, TST2.04U, max UDMA/66
ata2.00: 15761088 sectors, multi 0: LBA 
ata2.01: CFA: ASUS-PHISON SSD, TST2.04P, max UDMA/66
ata2.01: 63045360 sectors, multi 0: LBA 
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/66
scsi 1:0:0:0: Direct-Access     ATA      ASUS-PHISON SSD  TST2 PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 15761088 512-byte logical blocks: (8.06 GB/7.51 GiB)
scsi 1:0:1:0: Direct-Access     ATA      ASUS-PHISON SSD  TST2 PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:1:0: [sdb] 63045360 512-byte logical blocks: (32.2 GB/30.0 GiB)
sd 1:0:1:0: [sdb] Write Protect is off
sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
 sda: sda1 sda2 sda3 sda4
sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sda] Attached SCSI disk
sd 1:0:1:0: [sdb] Attached SCSI disk
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
Freeing unused kernel memory: 304k freed
Write protecting the kernel text: 2856k
Write protecting the kernel read-only data: 968k
psmouse serio1: elantech: assuming hardware version 2 (with firmware version 0x020030)
psmouse serio1: elantech: Synaptics capabilities query result 0x00, 0x02, 0x64.
input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input7
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
EXT4-fs (sda2): re-mounted. Opts: (null)
EXT4-fs (sda2): re-mounted. Opts: commit=60,discard,errors=remount-ro
EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem
EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: discard,commit=60
WARNING! power/level is deprecated; use power/control instead
eeepc_laptop: Eee PC Hotkey Driver
eeepc_laptop: Hotkey init flags 0x41
composite sync not supported
composite sync not supported
eeepc_laptop: TYPE (2000000) not reported by BIOS, enabling anyway
eeepc_laptop: PANELPOWER (4000000) not reported by BIOS, enabling anyway
eeepc_laptop: Get control methods supported: 0x6101713
usb 1-8: new high-speed USB device number 2 using ehci_hcd
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
usb 1-8: New USB device found, idVendor=04f2, idProduct=b071
usb 1-8: New USB device strings: Mfr=2, Product=1, SerialNumber=3
usb 1-8: Product: CNF7129
usb 1-8: Manufacturer: Chicony Electronics Co., Ltd.
usb 1-8: SerialNumber: SN0001
uvcvideo: Found UVC 1.00 device CNF7129 (04f2:b071)
input: CNF7129 as /devices/pci0000:00/0000:00:1d.7/usb1/1-8/1-8:1.0/input/input9
usbcore: registered new interface driver uvcvideo
USB Video Class driver (1.1.1)
input: Asus EeePC extra buttons as /devices/platform/eeepc/input/input10
eeepc_laptop: BIOS says wireless lan is unblocked, but the pci device is absent
eeepc_laptop: skipped wireless hotplug as probably inappropriate for this model
usb 1-8: USB disconnect, device number 2
usbcore: deregistering interface driver uvcvideo
composite sync not supported
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.03 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
sd 1:0:1:0: [sdb] Stopping disk
rt2800pci 0000:01:00.0: PCI INT A disabled
ACPI handle has no context!
ACPI handle has no context!
ATL1E 0000:04:00.0: PCI INT A disabled
ACPI handle has no context!
pci 0000:00:1f.3: PCI INT B disabled
i915 0000:00:02.0: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
uhci_hcd 0000:00:1d.3: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ACPI handle has no context!
sd 1:0:0:0: [sda] Stopping disk
ata_piix 0000:00:1f.2: PCI INT B disabled
PM: suspend of devices complete after 219.775 msecs
ehci_hcd 0000:00:1d.7: PME# enabled
PM: late suspend of devices complete after 16.165 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Atom PSE erratum detected, BIOS microcode update recommended
Disabled fast string operations
CPU1 is up
ACPI: Waking up from system sleep state S3
power_supply BAT0: parent PNP0C0A:00 should not be sleeping
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x40114001)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x3ff03fe0)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x3030)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fd13fc1)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pcieport 0000:00:1c.2: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fb13fa1)
pcieport 0000:00:1c.2: restoring config space at offset 0x8 (was 0xfff0, writing 0x3f903f80)
pcieport 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x2020)
pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100106, writing 0x100507)
uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
ehci_hcd 0000:00:1d.7: PME# disabled
rt2800pci 0000:01:00.0: restoring config space at offset 0xf (was 0x1ff, writing 0x10b)
rt2800pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xfbef0000)
rt2800pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
rt2800pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
PM: early resume of devices complete after 1.259 msecs
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ATL1E 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ATL1E 0000:04:00.0: setting latency timer to 64
rt2800pci 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sd 1:0:0:0: [sda] Starting disk
sd 1:0:1:0: [sdb] Starting disk
ata2.01: ACPI cmd ef/03:44:00:00:00:b0 (unknown) filtered out
ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:44:00:00:00:a0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (unknown) filtered out
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/66
phy0 -> rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
PM: resume of devices complete after 267.659 msecs
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
composite sync not supported
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
Monitor-Mwait will be used to enter C-3 state
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
sd 1:0:1:0: [sdb] Stopping disk
sd 1:0:0:0: [sda] Stopping disk
rt2800pci 0000:01:00.0: PCI INT A disabled
ACPI handle has no context!
ACPI handle has no context!
ATL1E 0000:04:00.0: PCI INT A disabled
ACPI handle has no context!
pci 0000:00:1f.3: PCI INT B disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
i915 0000:00:02.0: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
uhci_hcd 0000:00:1d.3: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ACPI handle has no context!
PM: suspend of devices complete after 147.781 msecs
ehci_hcd 0000:00:1d.7: PME# enabled
PM: late suspend of devices complete after 16.379 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Atom PSE erratum detected, BIOS microcode update recommended
Disabled fast string operations
CPU1 is up
ACPI: Waking up from system sleep state S3
power_supply BAT0: parent PNP0C0A:00 should not be sleeping
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x40114001)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x3ff03fe0)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x3030)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fd13fc1)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pcieport 0000:00:1c.2: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fb13fa1)
pcieport 0000:00:1c.2: restoring config space at offset 0x8 (was 0xfff0, writing 0x3f903f80)
pcieport 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x2020)
pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100106, writing 0x100507)
uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
ehci_hcd 0000:00:1d.7: PME# disabled
rt2800pci 0000:01:00.0: restoring config space at offset 0xf (was 0x1ff, writing 0x10b)
rt2800pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xfbef0000)
rt2800pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
rt2800pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
PM: early resume of devices complete after 1.239 msecs
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ATL1E 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ATL1E 0000:04:00.0: setting latency timer to 64
rt2800pci 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sd 1:0:0:0: [sda] Starting disk
sd 1:0:1:0: [sdb] Starting disk
ata2.01: ACPI cmd ef/03:44:00:00:00:b0 (unknown) filtered out
ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:44:00:00:00:a0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (unknown) filtered out
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/66
phy0 -> rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
PM: resume of devices complete after 284.444 msecs
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
composite sync not supported
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
rt2800pci 0000:01:00.0: PCI INT A disabled
pci 0000:01:00.0: [1814:0781] type 0 class 0x000280
pci 0000:01:00.0: reg 10: [mem 0x00000000-0x0000ffff]
pci 0000:01:00.0: PME# supported from D0 D3hot
pci 0000:01:00.0: PME# disabled
pci 0000:01:00.0: BAR 0: assigned [mem 0xf8000000-0xf800ffff]
pci 0000:01:00.0: BAR 0: set to [mem 0xf8000000-0xf800ffff] (PCI address [0xf8000000-0xf800ffff])
rt2800pci 0000:01:00.0: enabling device (0000 -> 0002)
rt2800pci 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
rt2800pci 0000:01:00.0: setting latency timer to 64
ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
Registered led device: rt2800pci-phy1::radio
Registered led device: rt2800pci-phy1::assoc
Registered led device: rt2800pci-phy1::quality
phy1 -> rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
rt2800pci 0000:01:00.0: PCI INT A disabled
ACPI handle has no context!
sd 1:0:1:0: [sdb] Stopping disk
sd 1:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ATL1E 0000:04:00.0: PCI INT A disabled
ACPI handle has no context!
pci 0000:00:1f.3: PCI INT B disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
i915 0000:00:02.0: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
uhci_hcd 0000:00:1d.3: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ACPI handle has no context!
PM: suspend of devices complete after 147.781 msecs
ehci_hcd 0000:00:1d.7: PME# enabled
PM: late suspend of devices complete after 16.364 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Atom PSE erratum detected, BIOS microcode update recommended
Disabled fast string operations
CPU1 is up
ACPI: Waking up from system sleep state S3
power_supply BAT0: parent PNP0C0A:00 should not be sleeping
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x40114001)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x3ff03fe0)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x3030)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fd13fc1)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pcieport 0000:00:1c.2: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fb13fa1)
pcieport 0000:00:1c.2: restoring config space at offset 0x8 (was 0xfff0, writing 0x3f903f80)
pcieport 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x2020)
pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0xf0, writing 0x20001010)
pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100106, writing 0x100507)
uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
ehci_hcd 0000:00:1d.7: PME# disabled
rt2800pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xf8000000)
rt2800pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
rt2800pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
PM: early resume of devices complete after 1.237 msecs
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ATL1E 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ATL1E 0000:04:00.0: setting latency timer to 64
sd 1:0:0:0: [sda] Starting disk
sd 1:0:1:0: [sdb] Starting disk
rt2800pci 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata2.01: ACPI cmd ef/03:44:00:00:00:b0 (unknown) filtered out
ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:44:00:00:00:a0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (unknown) filtered out
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/66
phy1 -> rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
PM: resume of devices complete after 276.344 msecs
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
composite sync not supported
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
rt2800pci 0000:01:00.0: PCI INT A disabled
ACPI handle has no context!
sd 1:0:1:0: [sdb] Stopping disk
sd 1:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ATL1E 0000:04:00.0: PCI INT A disabled
ACPI handle has no context!
pci 0000:00:1f.3: PCI INT B disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
i915 0000:00:02.0: PCI INT A disabled
uhci_hcd 0000:00:1d.3: PCI INT D disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ACPI handle has no context!
PM: suspend of devices complete after 146.486 msecs
ehci_hcd 0000:00:1d.7: PME# enabled
PM: late suspend of devices complete after 16.352 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Atom PSE erratum detected, BIOS microcode update recommended
Disabled fast string operations
CPU1 is up
ACPI: Waking up from system sleep state S3
power_supply BAT0: parent PNP0C0A:00 should not be sleeping
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x40114001)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x3ff03fe0)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x3030)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fd13fc1)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pcieport 0000:00:1c.2: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fb13fa1)
pcieport 0000:00:1c.2: restoring config space at offset 0x8 (was 0xfff0, writing 0x3f903f80)
pcieport 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x2020)
pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100106, writing 0x100507)
uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
ehci_hcd 0000:00:1d.7: PME# disabled
rt2800pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xf8000000)
rt2800pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
rt2800pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
PM: early resume of devices complete after 1.249 msecs
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ATL1E 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ATL1E 0000:04:00.0: setting latency timer to 64
sd 1:0:0:0: [sda] Starting disk
sd 1:0:1:0: [sdb] Starting disk
rt2800pci 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata2.01: ACPI cmd ef/03:44:00:00:00:b0 (unknown) filtered out
ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:44:00:00:00:a0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (unknown) filtered out
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/66
phy1 -> rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
PM: resume of devices complete after 282.772 msecs
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
composite sync not supported
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
phy1 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
Please file bug report to http://rt2x00.serialmonkey.com.
---------------------
lspci -v output:
---------------------
00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Flags: bus master, fast devsel, latency 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at f7f00000 (32-bit, non-prefetchable) [size=512K]
	I/O ports at dc80 [size=8]
	Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Memory at f7ec0000 (32-bit, non-prefetchable) [size=256K]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Flags: bus master, fast devsel, latency 0
	Memory at f7f80000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: <access denied>

00:1b.0 Audio device: Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 02)
	Subsystem: ASUSTeK Computer Inc. Device 834a
	Flags: bus master, fast devsel, latency 0, IRQ 44
	Memory at f7eb8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 1 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: 3fe00000-3fffffff
	Prefetchable memory behind bridge: 0000000040000000-00000000401fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 2 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbf00000-fbffffff
	Prefetchable memory behind bridge: 000000003fc00000-000000003fdfffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 3 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: 3f800000-3f9fffff
	Prefetchable memory behind bridge: 000000003fa00000-000000003fbfffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation N10/ICH 7 Family PCI Express Port 4 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=02, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: f8000000-fbefffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f6ffffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at d480 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at d800 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at d880 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at dc00 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at f7eb7c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=32
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Flags: bus master, medium devsel, latency 0
	Capabilities: <access denied>

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02) (prog-if 80 [Master])
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 19
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at ffa0 [size=16]
	Capabilities: <access denied>
	Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation N10/ICH 7 Family SMBus Controller (rev 02)
	Subsystem: ASUSTeK Computer Inc. Device 830f
	Flags: medium devsel, IRQ 19
	I/O ports at 0400 [size=32]

01:00.0 Network controller: RaLink RT2860
	Subsystem: RaLink Device 2790
	Physical Slot: eeepc-wifi
	Flags: bus master, fast devsel, latency 0, IRQ 19
	Memory at f8000000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: rt2800pci

04:00.0 Ethernet controller: Atheros Communications AR8121/AR8113/AR8114 Gigabit or Fast Ethernet (rev b0)
	Subsystem: ASUSTeK Computer Inc. Device 8324
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at fbfc0000 (64-bit, non-prefetchable) [size=256K]
	I/O ports at ec80 [size=128]
	Capabilities: <access denied>
	Kernel driver in use: ATL1E
-----------------
More errors from dmesg (lot of noise, but for any case):
-----------------
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
phy1 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
Please file bug report to http://rt2x00.serialmonkey.com.
phy1 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
Please file bug report to http://rt2x00.serialmonkey.com.
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
rt2800pci 0000:01:00.0: PCI INT A disabled
ACPI handle has no context!
sd 1:0:1:0: [sdb] Stopping disk
sd 1:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ATL1E 0000:04:00.0: PCI INT A disabled
ACPI handle has no context!
pci 0000:00:1f.3: PCI INT B disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
i915 0000:00:02.0: PCI INT A disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.3: PCI INT D disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ACPI handle has no context!
PM: suspend of devices complete after 147.684 msecs
ehci_hcd 0000:00:1d.7: PME# enabled
PM: late suspend of devices complete after 16.444 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Atom PSE erratum detected, BIOS microcode update recommended
Disabled fast string operations
CPU1 is up
ACPI: Waking up from system sleep state S3
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x40114001)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x3ff03fe0)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x3030)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fd13fc1)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pcieport 0000:00:1c.2: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fb13fa1)
pcieport 0000:00:1c.2: restoring config space at offset 0x8 (was 0xfff0, writing 0x3f903f80)
pcieport 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x2020)
pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100106, writing 0x100507)
uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
ehci_hcd 0000:00:1d.7: PME# disabled
rt2800pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xf8000000)
rt2800pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
rt2800pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
PM: early resume of devices complete after 1.468 msecs
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ATL1E 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ATL1E 0000:04:00.0: setting latency timer to 64
sd 1:0:0:0: [sda] Starting disk
sd 1:0:1:0: [sdb] Starting disk
rt2800pci 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata2.01: ACPI cmd ef/03:44:00:00:00:b0 (unknown) filtered out
ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:44:00:00:00:a0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (unknown) filtered out
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/66
PM: resume of devices complete after 347.028 msecs
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
composite sync not supported
phy1 -> rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
rt2800pci 0000:01:00.0: PCI INT A disabled
ACPI handle has no context!
sd 1:0:1:0: [sdb] Stopping disk
sd 1:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ATL1E 0000:04:00.0: PCI INT A disabled
ACPI handle has no context!
pci 0000:00:1f.3: PCI INT B disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
i915 0000:00:02.0: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
uhci_hcd 0000:00:1d.3: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ACPI handle has no context!
PM: suspend of devices complete after 147.040 msecs
ehci_hcd 0000:00:1d.7: PME# enabled
PM: late suspend of devices complete after 16.404 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Atom PSE erratum detected, BIOS microcode update recommended
Disabled fast string operations
CPU1 is up
ACPI: Waking up from system sleep state S3
power_supply BAT0: parent PNP0C0A:00 should not be sleeping
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x40114001)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x3ff03fe0)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x3030)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fd13fc1)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pcieport 0000:00:1c.2: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fb13fa1)
pcieport 0000:00:1c.2: restoring config space at offset 0x8 (was 0xfff0, writing 0x3f903f80)
pcieport 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x2020)
pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100106, writing 0x100507)
uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
ehci_hcd 0000:00:1d.7: PME# disabled
rt2800pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xf8000000)
rt2800pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
rt2800pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
PM: early resume of devices complete after 1.235 msecs
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ATL1E 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ATL1E 0000:04:00.0: setting latency timer to 64
sd 1:0:0:0: [sda] Starting disk
sd 1:0:1:0: [sdb] Starting disk
rt2800pci 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata2.01: ACPI cmd ef/03:44:00:00:00:b0 (unknown) filtered out
ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:44:00:00:00:a0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (unknown) filtered out
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/66
phy1 -> rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
PM: resume of devices complete after 276.155 msecs
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
composite sync not supported
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticate with 00:21:91:d5:1e:57 (try 2)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
rt2800pci 0000:01:00.0: PCI INT A disabled
ACPI handle has no context!
sd 1:0:1:0: [sdb] Stopping disk
sd 1:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ATL1E 0000:04:00.0: PCI INT A disabled
ACPI handle has no context!
pci 0000:00:1f.3: PCI INT B disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
i915 0000:00:02.0: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
uhci_hcd 0000:00:1d.3: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ACPI handle has no context!
PM: suspend of devices complete after 143.772 msecs
ehci_hcd 0000:00:1d.7: PME# enabled
PM: late suspend of devices complete after 16.369 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Atom PSE erratum detected, BIOS microcode update recommended
Disabled fast string operations
CPU1 is up
ACPI: Waking up from system sleep state S3
power_supply BAT0: parent PNP0C0A:00 should not be sleeping
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x40114001)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x3ff03fe0)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x3030)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fd13fc1)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pcieport 0000:00:1c.2: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fb13fa1)
pcieport 0000:00:1c.2: restoring config space at offset 0x8 (was 0xfff0, writing 0x3f903f80)
pcieport 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x2020)
pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100106, writing 0x100507)
uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
ehci_hcd 0000:00:1d.7: PME# disabled
rt2800pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xf8000000)
rt2800pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
rt2800pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
PM: early resume of devices complete after 1.255 msecs
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ATL1E 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ATL1E 0000:04:00.0: setting latency timer to 64
sd 1:0:0:0: [sda] Starting disk
sd 1:0:1:0: [sdb] Starting disk
rt2800pci 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata2.01: ACPI cmd ef/03:44:00:00:00:b0 (unknown) filtered out
ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:44:00:00:00:a0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (unknown) filtered out
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/66
phy1 -> rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
PM: resume of devices complete after 275.926 msecs
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
composite sync not supported
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
keyboard: can't emulate rawmode for keycode 240
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
rt2800pci 0000:01:00.0: PCI INT A disabled
ACPI handle has no context!
sd 1:0:1:0: [sdb] Stopping disk
sd 1:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ATL1E 0000:04:00.0: PCI INT A disabled
ACPI handle has no context!
pci 0000:00:1f.3: PCI INT B disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
i915 0000:00:02.0: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
uhci_hcd 0000:00:1d.3: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ACPI handle has no context!
PM: suspend of devices complete after 143.781 msecs
ehci_hcd 0000:00:1d.7: PME# enabled
PM: late suspend of devices complete after 16.362 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Atom PSE erratum detected, BIOS microcode update recommended
Disabled fast string operations
CPU1 is up
ACPI: Waking up from system sleep state S3
power_supply BAT0: parent PNP0C0A:00 should not be sleeping
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x40114001)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x3ff03fe0)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x3030)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fd13fc1)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pcieport 0000:00:1c.2: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fb13fa1)
pcieport 0000:00:1c.2: restoring config space at offset 0x8 (was 0xfff0, writing 0x3f903f80)
pcieport 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x2020)
pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100106, writing 0x100507)
uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
ehci_hcd 0000:00:1d.7: PME# disabled
rt2800pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xf8000000)
rt2800pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
rt2800pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
PM: early resume of devices complete after 1.234 msecs
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ATL1E 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ATL1E 0000:04:00.0: setting latency timer to 64
sd 1:0:0:0: [sda] Starting disk
sd 1:0:1:0: [sdb] Starting disk
rt2800pci 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata2.01: ACPI cmd ef/03:44:00:00:00:b0 (unknown) filtered out
ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:44:00:00:00:a0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (unknown) filtered out
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/66
phy1 -> rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
PM: resume of devices complete after 274.997 msecs
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
composite sync not supported
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: disassociated from 00:21:91:d5:1e:57 (Reason: 4)
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
phy1 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
Please file bug report to http://rt2x00.serialmonkey.com.
wlan0: deauthenticated from 00:21:91:d5:1e:57 (Reason: 2)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
phy1 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
Please file bug report to http://rt2x00.serialmonkey.com.
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated
phy1 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
Please file bug report to http://rt2x00.serialmonkey.com.
phy1 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
Please file bug report to http://rt2x00.serialmonkey.com.
wlan0: deauthenticating from 00:21:91:d5:1e:57 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
rt2800pci 0000:01:00.0: PCI INT A disabled
ACPI handle has no context!
sd 1:0:1:0: [sdb] Stopping disk
sd 1:0:0:0: [sda] Stopping disk
ACPI handle has no context!
ATL1E 0000:04:00.0: PCI INT A disabled
ACPI handle has no context!
pci 0000:00:1f.3: PCI INT B disabled
ata_piix 0000:00:1f.2: PCI INT B disabled
i915 0000:00:02.0: PCI INT A disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT C disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.3: PCI INT D disabled
ehci_hcd 0000:00:1d.7: PCI INT A disabled
snd_hda_intel 0000:00:1b.0: PCI INT A disabled
ACPI handle has no context!
PM: suspend of devices complete after 147.765 msecs
ehci_hcd 0000:00:1d.7: PME# enabled
PM: late suspend of devices complete after 16.371 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
Calibrating delay loop (skipped) already calibrated this CPU
Atom PSE erratum detected, BIOS microcode update recommended
Disabled fast string operations
CPU1 is up
ACPI: Waking up from system sleep state S3
power_supply BAT0: parent PNP0C0A:00 should not be sleeping
snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
pcieport 0000:00:1c.0: restoring config space at offset 0x9 (was 0x1fff1, writing 0x40114001)
pcieport 0000:00:1c.0: restoring config space at offset 0x8 (was 0xfff0, writing 0x3ff03fe0)
pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x3030)
pcieport 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.1: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fd13fc1)
pcieport 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100107, writing 0x100507)
pcieport 0000:00:1c.2: restoring config space at offset 0x9 (was 0x1fff1, writing 0x3fb13fa1)
pcieport 0000:00:1c.2: restoring config space at offset 0x8 (was 0xfff0, writing 0x3f903f80)
pcieport 0000:00:1c.2: restoring config space at offset 0x7 (was 0xf0, writing 0x2020)
pcieport 0000:00:1c.2: restoring config space at offset 0x1 (was 0x100104, writing 0x100507)
pcieport 0000:00:1c.3: restoring config space at offset 0x7 (was 0xf0, writing 0x1010)
pcieport 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100106, writing 0x100507)
uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
uhci_hcd 0000:00:1d.3: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900106, writing 0x2900102)
ehci_hcd 0000:00:1d.7: PME# disabled
rt2800pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xf8000000)
rt2800pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
rt2800pci 0000:01:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
PM: early resume of devices complete after 1.233 msecs
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
snd_hda_intel 0000:00:1b.0: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb2: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb4: root hub lost power or was reset
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
usb usb5: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: setting latency timer to 64
pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ATL1E 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ATL1E 0000:04:00.0: setting latency timer to 64
sd 1:0:0:0: [sda] Starting disk
sd 1:0:1:0: [sdb] Starting disk
rt2800pci 0000:01:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ata2.01: ACPI cmd ef/03:44:00:00:00:b0 (unknown) filtered out
ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:44:00:00:00:a0 (unknown) filtered out
ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 (unknown) filtered out
ata2.00: configured for UDMA/66
ata2.01: configured for UDMA/66
phy1 -> rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
PM: resume of devices complete after 338.915 msecs
Restarting tasks ... done.
video LNXVIDEO:00: Restoring backlight state
composite sync not supported
wlan0: authenticate with 00:21:91:d5:1e:57 (try 1)
wlan0: authenticated
wlan0: associate with 00:21:91:d5:1e:57 (try 1)
wlan0: RX AssocResp from 00:21:91:d5:1e:57 (capab=0x411 status=0 aid=1)
wlan0: associated

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46516 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYKCANs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 19:13:48 -0500
Received: from [192.168.1.188] (S0106001cf062885c.vc.shawcable.net [24.82.150.230])
	by mail.holtmann.org (Postfix) with ESMTP id 9C6B78B31F
	for <linux-wireless@vger.kernel.org>; Mon,  3 Nov 2008 01:13:43 +0100 (CET)
Message-Id: <DFAA4A8C-F8D5-4D08-9C6E-8BB65E3BCFC2@holtmann.org> (sfid-20081103_011401_708646_769D4445)
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=Apple-Mail-4-403401503
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Alignment issue with 4965 and 2.6.28-rc3
Date: Mon, 3 Nov 2008 01:13:40 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Apple-Mail-4-403401503
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Hi guys,

so I switched to a 2.6.28-rc3 kernel and after less then 10 minutes  
uptime my dmesg is full of warnings. I enabled a bunch of debugging  
options and the first warning that I see is the alignment warning from  
mac80211. I have kerneloops enabled and all warnings are posted there.  
For reference I attach my full dmesg and config.

Regards

Marcel

--Apple-Mail-4-403401503
Content-Disposition: attachment;
	filename=dmesg-2.6.28-rc3.txt
Content-Type: text/plain;
	x-unix-mode=0644;
	name="dmesg-2.6.28-rc3.txt"
Content-Transfer-Encoding: 7bit

BIOS EBDA/lowmem at: 0009d800/0009d800
Linux version 2.6.28-rc3 (holtmann@californication) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) #52 SMP Mon Nov 3 00:53:59 CET 2008
Command line: root=/dev/sda1 ro selinux=1 video=intelfb
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007d6b0000 (usable)
 BIOS-e820: 000000007d6b0000 - 000000007d6cc000 (ACPI data)
 BIOS-e820: 000000007d6cc000 - 000000007d700000 (ACPI NVS)
 BIOS-e820: 000000007d700000 - 000000007e000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
DMI present.
last_pfn = 0x7d6b0 max_arch_pfn = 0x3ffffffff
init_memory_mapping: 0000000000000000-000000007d6b0000
 0000000000 - 007d600000 page 2M
 007d600000 - 007d6b0000 page 4k
kernel direct mapping tables up to 7d6b0000 @ 8000-c000
last_map_addr: 7d6b0000 end: 7d6b0000
ACPI: RSDP 000F6950, 0024 (r2 LENOVO)
ACPI: XSDT 7D6BD48C, 0094 (r1 LENOVO TP-7N        1110  LTP        0)
ACPI: FACP 7D6BD600, 00F4 (r3 LENOVO TP-7N        1110 LNVO        1)
ACPI Warning (tbfadt-0460): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20080926]
ACPI: DSDT 7D6BD9DB, E206 (r1 LENOVO TP-7N        1110 MSFT  3000000)
ACPI: FACS 7D6E4000, 0040
ACPI: SSDT 7D6BD7B4, 0227 (r1 LENOVO TP-7N        1110 MSFT  3000000)
ACPI: ECDT 7D6CBBE1, 0052 (r1 LENOVO TP-7N        1110 LNVO        1)
ACPI: TCPA 7D6CBC33, 0032 (r2 LENOVO TP-7N        1110 LNVO        1)
ACPI: APIC 7D6CBC65, 0068 (r1 LENOVO TP-7N        1110 LNVO        1)
ACPI: MCFG 7D6CBCCD, 003C (r1 LENOVO TP-7N        1110 LNVO        1)
ACPI: HPET 7D6CBD09, 0038 (r1 LENOVO TP-7N        1110 LNVO        1)
ACPI: SLIC 7D6CBDF0, 0176 (r1 LENOVO TP-7N        1110  LTP        0)
ACPI: BOOT 7D6CBF66, 0028 (r1 LENOVO TP-7N        1110  LTP        1)
ACPI: ASF! 7D6CBF8E, 0072 (r16 LENOVO TP-7N        1110 PTL         1)
ACPI: SSDT 7D6E26D9, 025F (r1 LENOVO TP-7N        1110 INTL 20050513)
ACPI: SSDT 7D6E2938, 00A6 (r1 LENOVO TP-7N        1110 INTL 20050513)
ACPI: SSDT 7D6E29DE, 04F7 (r1 LENOVO TP-7N        1110 INTL 20050513)
ACPI: SSDT 7D6E2ED5, 01D8 (r1 LENOVO TP-7N        1110 INTL 20050513)
ACPI: DMI detected: Lenovo ThinkPad X61
ACPI: Added _OSI(Linux)
ACPI: Local APIC address 0xfee00000
(5 early reservations) ==> bootmem [0000000000 - 007d6b0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00006ae85c]    TEXT DATA BSS ==> [0000200000 - 00006ae85c]
  #3 [000009d800 - 0000100000]    BIOS reserved ==> [000009d800 - 0000100000]
  #4 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
found SMP MP-table at [ffff8800000f6980] 000f6980
 [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009d
    0: 0x00000100 -> 0x0007d6b0
On node 0 totalpages: 513613
  DMA zone: 56 pages used for memmap
  DMA zone: 1303 pages reserved
  DMA zone: 2638 pages, LIFO batch:0
  DMA32 zone: 6968 pages used for memmap
  DMA32 zone: 502648 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at 80000000 (gap: 7e000000:72000000)
PERCPU: Allocating 49152 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 505286
Kernel command line: root=/dev/sda1 ro selinux=1 video=intelfb
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC: PIT calibration matches PMTIMER. 1 loops
Detected 2194.482 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
No AGP bridge found
Memory: 2016916k/2054848k available (2421k kernel code, 396k absent, 36852k reserved, 1377k data, 312k init)
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 4388.96 BogoMIPS (lpj=8777928)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
ACPI: Core revision 20080926
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4389.09 BogoMIPS (lpj=8778184)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 359117 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to check_tsc_sync_source failed
Brought up 2 CPUs
Total of 2 processors activated (8778.05 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
khelper used greatest stack depth: 5928 bytes left
net_namespace: 1256 bytes
regulator: core version 0.5
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: MCFG area at f0000000 reserved in E820
PCI: Using MMCONFIG at f0000000 - f3ffffff
PCI: Using configuration type 1 for base access
ACPI: EC: EC description table is found, configuring boot EC
ACPI: BIOS _OSI(Linux) query honored via DMI
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: ACPI Dock Station Driver: 3 docks/bays found
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: reg 10 64bit mmio: [0xf8000000-0xf80fffff]
pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]
pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
pci 0000:00:02.1: reg 10 64bit mmio: [0xf8100000-0xf81fffff]
pci 0000:00:19.0: reg 10 32bit mmio: [0xf8200000-0xf821ffff]
pci 0000:00:19.0: reg 14 32bit mmio: [0xf8225000-0xf8225fff]
pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xf8426c00-0xf8426fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xf8220000-0xf8223fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x18a0-0x18bf]
pci 0000:00:1d.1: reg 20 io port: [0x18c0-0x18df]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xf8427000-0xf84273ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x18e0-0x18ef]
pci 0000:00:1f.2: reg 10 io port: [0x1c30-0x1c37]
pci 0000:00:1f.2: reg 14 io port: [0x1c24-0x1c27]
pci 0000:00:1f.2: reg 18 io port: [0x1c28-0x1c2f]
pci 0000:00:1f.2: reg 1c io port: [0x1c20-0x1c23]
pci 0000:00:1f.2: reg 20 io port: [0x1c00-0x1c1f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xf8426000-0xf84267ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10 32bit mmio: [0xf8427400-0xf84274ff]
pci 0000:00:1f.3: reg 20 io port: [0x1c40-0x1c5f]
pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
pci 0000:00:1c.0: bridge 32bit mmio: [0xf4000000-0xf5ffffff]
pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf8500000-0xf85fffff]
pci 0000:03:00.0: reg 10 64bit mmio: [0xf7f00000-0xf7f01fff]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:1c.1: bridge io port: [0x3000-0x3fff]
pci 0000:00:1c.1: bridge 32bit mmio: [0xf6000000-0xf7ffffff]
pci 0000:00:1c.1: bridge 64bit mmio pref: [0xf8600000-0xf86fffff]
pci 0000:05:00.0: reg 10 32bit mmio: [0xd7eff000-0xd7efffff]
pci 0000:05:00.0: supports D1 D2
pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:05:00.1: reg 10 32bit mmio: [0xd7efe800-0xd7efefff]
pci 0000:05:00.1: supports D1 D2
pci 0000:05:00.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:05:00.1: PME# disabled
pci 0000:05:00.2: reg 10 32bit mmio: [0xd7efe400-0xd7efe4ff]
pci 0000:05:00.2: supports D1 D2
pci 0000:05:00.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:05:00.2: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x4000-0x7fff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xd4000000-0xd7efffff]
pci 0000:00:1e.0: bridge 64bit mmio pref: [0xd8000000-0xdbffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: Power Resource [PUBS] (on)
ACPI: WMI: Mapper loaded
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD GART found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xc3fff has been reserved
system 00:00: iomem range 0xc4000-0xc7fff has been reserved
system 00:00: iomem range 0xc8000-0xcbfff has been reserved
system 00:00: iomem range 0xcc000-0xcffff has been reserved
system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
system 00:00: iomem range 0xe8000-0xebfff could not be reserved
system 00:00: iomem range 0xec000-0xeffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x7dffffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
system 00:02: ioport range 0x164e-0x164f has been reserved
system 00:02: ioport range 0x1000-0x107f has been reserved
system 00:02: ioport range 0x1180-0x11bf has been reserved
system 00:02: ioport range 0x800-0x80f has been reserved
system 00:02: ioport range 0x15e0-0x15ef has been reserved
system 00:02: ioport range 0x1600-0x165f could not be reserved
system 00:02: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
pci 0000:00:1c.0:   MEM window: 0xf4000000-0xf5ffffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000f8500000-0x000000f85fffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
pci 0000:00:1c.1:   MEM window: 0xf6000000-0xf7ffffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000f8600000-0x000000f86fffff
pci 0000:05:00.0: CardBus bridge, secondary bus 0000:06
pci 0000:05:00.0:   IO window: 0x004000-0x0040ff
pci 0000:05:00.0:   IO window: 0x004400-0x0044ff
pci 0000:05:00.0:   PREFETCH window: 0xd8000000-0xdbffffff
pci 0000:05:00.0:   MEM window: 0x80000000-0x83ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
pci 0000:00:1e.0:   IO window: 0x4000-0x7fff
pci 0000:00:1e.0:   MEM window: 0xd4000000-0xd7efffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000d8000000-0x000000dbffffff
pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: enabling device (0005 -> 0007)
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:05:00.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
bus: 02 index 0 io port: [0x2000-0x2fff]
bus: 02 index 1 mmio: [0xf4000000-0xf5ffffff]
bus: 02 index 2 mmio: [0xf8500000-0xf85fffff]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 03 index 0 io port: [0x3000-0x3fff]
bus: 03 index 1 mmio: [0xf6000000-0xf7ffffff]
bus: 03 index 2 mmio: [0xf8600000-0xf86fffff]
bus: 03 index 3 mmio: [0x0-0x0]
bus: 05 index 0 io port: [0x4000-0x7fff]
bus: 05 index 1 mmio: [0xd4000000-0xd7efffff]
bus: 05 index 2 mmio: [0xd8000000-0xdbffffff]
bus: 05 index 3 io port: [0x00-0xffff]
bus: 05 index 4 mmio: [0x000000-0xffffffffffffffff]
bus: 06 index 0 io port: [0x4000-0x40ff]
bus: 06 index 1 io port: [0x4400-0x44ff]
bus: 06 index 2 mmio: [0xd8000000-0xdbffffff]
bus: 06 index 3 mmio: [0x80000000-0x83ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Simple Boot Flag at 0x35 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1225673781.745:1): initialized
msgmni has been set to 3940
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
ACPI: AC Adapter [AC] (off-line)
ACPI Warning (nspredef-0858): \_SB_.PCI0.LPC_.EC__.BAT0._BIF: Return Package type mismatch at index 9 - found Buffer, expected String [20080926]
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
ACPI: Sleep Button (CM) [SLPB]
ACPI: SSDT 7D6E1D72, 02C4 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
ACPI: SSDT 7D6E20BB, 061E (r1  PmRef  Cpu0Cst      100 INTL 20050513)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7D6E1CAA, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
ACPI: SSDT 7D6E2036, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (61 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Thermal Zone [THM1] (59 C)
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 965GM Chipset
agpgart-intel 0000:00:00.0: detected 7676K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
intelfb: Version 0.9.6
intelfb 0000:00:02.0: power state changed by ACPI to D0
intelfb 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
intelfb: 00:02.0: Intel(R) 965GM, aperture size 256MB, stolen memory 7932kB
intelfb: MTRR is disabled in the kernel
intelfb: Non-CRT device is enabled ( LVDS port ).  Disabling mode switching.
intelfb: Video mode must be programmed at boot time.
Driver 'sd' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
ata1: SATA max UDMA/133 abar m2048@0xf8426000 port 0xf8426100 irq 16
ata2: DUMMY
ata3: DUMMY
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ATA-7: HITACHI HTS541612J9SA00, SBDIC7UP, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1.00: configured for UDMA/100
ata1: EH complete
scsi 0:0:0:0: Direct-Access     ATA      HITACHI HTS54161 SBDI PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi3 : ata_piix
scsi4 : ata_piix
ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x18e0 irq 14
ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x18e8 irq 15
ata5: port disabled. ignoring.
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
cpuidle: using governor menu
TCP cubic registered
Clocksource tsc unstable (delta = -412083960 ns)
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 312k freed
Write protecting the kernel read-only data: 3528k
khelper used greatest stack depth: 5296 bytes left
NET: Registered protocol family 1
modprobe used greatest stack depth: 4824 bytes left
runlevel used greatest stack depth: 3992 bytes left
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
0000:00:19.0: 0000:00:19.0: Failed to initialize MSI interrupts.  Falling back to legacy interrupts.
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Uniform Multi-Platform E-IDE driver
yenta_cardbus 0000:05:00.0: CardBus bridge found [17aa:20c6]
sd 0:0:0:0: Attached scsi generic sg0 type 0
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1d:72:82:26:77
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28-rc3 uhci_hcd
usb usb1: SerialNumber: 0000:00:1a.0
uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.28-rc3 uhci_hcd
usb usb2: SerialNumber: 0000:00:1a.1
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.28-rc3 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.28-rc3 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 22, io mem 0xf8426c00
yenta_cardbus 0000:05:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
yenta_cardbus 0000:05:00.0: Socket status: 30000006
yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bridge I/O window: 0x4000 - 0x7fff
yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bridge Memory window: 0xd4000000 - 0xd7efffff
yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bridge Memory window: 0xd8000000 - 0xdbffffff
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 4 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: EHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.28-rc3 ehci_hcd
usb usb5: SerialNumber: 0000:00:1a.7
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf8427000
firewire_ohci 0000:05:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
firewire_ohci 0000:05:00.1: setting latency timer to 64
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
Non-volatile memory driver v1.2
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: EHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.28-rc3 ehci_hcd
usb usb6: SerialNumber: 0000:00:1d.7
firewire_ohci: Added fw-ohci device 0000:05:00.1, OHCI version 1.10
sdhci-pci 0000:05:00.2: SDHCI controller found [1180:0822] (rev 21)
sdhci-pci 0000:05:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
sdhci-pci 0000:05:00.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:05:00.2: setting latency timer to 64
mmc0: SDHCI controller on PCI [0000:05:00.2] using DMA
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kd
iwlagn: Copyright(c) 2003-2008 Intel Corporation
iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:03:00.0: setting latency timer to 64
iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
iwlagn: Tunable channels: 11 802.11bg, 13 802.11a channels
iwlagn 0000:03:00.0: PCI INT A disabled
phy0: Selected rate control algorithm 'iwl-agn-rs'
thinkpad_acpi: ThinkPad ACPI Extras v0.21
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 7NET30WW (1.11 ), EC 7MHT24WW-1.02
thinkpad_acpi: Lenovo ThinkPad X61, model 7675CTO
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi:orange:batt
Registered led device: tpacpi:green:batt
Registered led device: tpacpi::dock_active
Registered led device: tpacpi::bay_active
Registered led device: tpacpi::dock_batt
Registered led device: tpacpi::unknown_led
Registered led device: tpacpi::standby
thinkpad_acpi: Lenovo BIOS switched to ACPI backlight control mode
thinkpad_acpi: standard ACPI backlight interface available, not loading native one...
input: ThinkPad Extra Buttons as /devices/virtual/input/input5
firewire_core: created device fw0: GUID 001d72ffff822677, S400
usb 1-1: new full speed USB device using uhci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: New USB device found, idVendor=0a5c, idProduct=2110
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: BCM2045B
usb 1-1: Manufacturer: Broadcom Corp
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: Generic Bluetooth USB driver ver 0.3
usbcore: registered new interface driver btusb
loop: module loaded
fuse init (API version 7.10)
tpm_tis 00:0a: 1.2 TPM (device-id 0x3203, rev-id 9)
Adding 3903784k swap on /dev/sda2.  Priority:-1 extents:1 across:3903784k
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ip_tables: (C) 2000-2006 Netfilter Core Team
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
NET: Registered protocol family 10
vnet0: starting userspace STP failed, starting kernel STP
hald used greatest stack depth: 3800 bytes left
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20080730 on minor 0
ADDRCONF(NETDEV_UP): eth0: link is not ready
iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:03:00.0: restoring config space at offset 0x1 (was 0x40100102, writing 0x40100106)
iwlagn 0000:03:00.0: firmware: requesting iwlwifi-4965-2.ucode
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
NET: Registered protocol family 17
ecryptfs_parse_options: eCryptfs: unrecognized option 'rw'
ecryptfs_parse_options: eCryptfs: unrecognized option 'user=holtmann'
wlan0: authenticate with AP 00:1c:f0:62:88:5b
wlan0: authenticated
wlan0: associate with AP 00:1c:f0:62:88:5b
wlan0: RX AssocResp from 00:1c:f0:62:88:5b (capab=0x431 status=0 aid=4)
wlan0: associated
------------[ cut here ]------------
WARNING: at net/mac80211/rx.c:393 __ieee80211_rx_handle_packet+0x1e4/0x5b9 [mac80211]()
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi thinkpad_acpi hwmon iwlagn iwlcore backlight rfkill led_class nvram sdhci_pci sdhci firewire_ohci firewire_core ehci_hcd uhci_hcd mac80211 piix sg evdev mmc_core yenta_socket rsrc_nonstatic pcmcia_core crc_itu_t ide_core usbcore cfg80211 e1000e unix
Pid: 0, comm: swapper Not tainted 2.6.28-rc3 #52
Call Trace:
 <IRQ>  [<ffffffff80231e93>] warn_on_slowpath+0x58/0x7d
 [<ffffffffa0157d01>] ? iwl_rx_reply_rx+0x8d0/0x8e2 [iwlcore]
 [<ffffffff8022b5c3>] ? default_wake_function+0xd/0xf
 [<ffffffff802445bb>] ? autoremove_wake_function+0x11/0x38
 [<ffffffffa00e185b>] __ieee80211_rx_handle_packet+0x1e4/0x5b9 [mac80211]
 [<ffffffff8022710d>] ? __wake_up+0x43/0x50
 [<ffffffffa00e240b>] __ieee80211_rx+0x4c9/0x52a [mac80211]
 [<ffffffffa00d2ff3>] ieee80211_tasklet_handler+0x74/0xfe [mac80211]
 [<ffffffff80236295>] tasklet_action+0x70/0xbb
 [<ffffffff80236b8d>] __do_softirq+0x83/0x142
 [<ffffffff8020c55c>] call_softirq+0x1c/0x28
 [<ffffffff8020da04>] do_softirq+0x34/0x72
 [<ffffffff802368ba>] irq_exit+0x3f/0x82
 [<ffffffff8020dcce>] do_IRQ+0x150/0x172
 [<ffffffff8020b8a6>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8036b27d>] ? acpi_idle_enter_bm+0x300/0x385
 [<ffffffff8036b273>] ? acpi_idle_enter_bm+0x2f6/0x385
 [<ffffffff803da394>] ? cpuidle_idle_call+0x94/0xcc
 [<ffffffff8020a575>] ? cpu_idle+0x4a/0x8b
 [<ffffffff804493c8>] ? rest_init+0x5c/0x5e
---[ end trace e0ae56f3882dee14 ]---
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level CPU
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level CPU
   groups: 0-1
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204 iwl_tx_cmd_complete+0x50/0x248 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi thinkpad_acpi hwmon iwlagn iwlcore backlight rfkill led_class nvram sdhci_pci sdhci firewire_ohci firewire_core ehci_hcd uhci_hcd mac80211 piix sg evdev mmc_core yenta_socket rsrc_nonstatic pcmcia_core crc_itu_t ide_core usbcore cfg80211 e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc3 #52
Call Trace:
 <IRQ>  [<ffffffff80231e14>] warn_slowpath+0xae/0xd5
 [<ffffffff8022510c>] ? enqueue_task+0x50/0x5b
 [<ffffffff802271de>] ? task_rq_lock+0x40/0x79
 [<ffffffff8022b5a4>] ? try_to_wake_up+0x236/0x248
 [<ffffffff80248a5d>] ? sched_clock_cpu+0x134/0x140
 [<ffffffffa015881b>] ? iwl_rx_queue_update_write_ptr+0x41d/0x443 [iwlcore]
 [<ffffffff80249048>] ? getnstimeofday+0x3a/0x96
 [<ffffffffa0159b2a>] iwl_tx_cmd_complete+0x50/0x248 [iwlcore]
 [<ffffffffa015902b>] ? iwl_rx_queue_restock+0xbb/0x140 [iwlcore]
 [<ffffffffa017f805>] iwl_rx_handle+0x2bf/0x3d5 [iwlagn]
 [<ffffffff80288f54>] ? check_object+0x159/0x208
 [<ffffffffa0180214>] iwl4965_irq_tasklet+0x8f9/0xc12 [iwlagn]
 [<ffffffff803247fd>] ? rb_insert_color+0x69/0xe6
 [<ffffffff80236295>] tasklet_action+0x70/0xbb
 [<ffffffff80247248>] ? hrtimer_start_range_ns+0x13e/0x160
 [<ffffffff80236b8d>] __do_softirq+0x83/0x142
 [<ffffffff8020c55c>] call_softirq+0x1c/0x28
 [<ffffffff8020da04>] do_softirq+0x34/0x72
 [<ffffffff802368ba>] irq_exit+0x3f/0x82
 [<ffffffff8020dcce>] do_IRQ+0x150/0x172
 [<ffffffff8020b8a6>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8036b4ca>] ? acpi_idle_enter_simple+0x1c8/0x23a
 [<ffffffff8036b4c0>] ? acpi_idle_enter_simple+0x1be/0x23a
 [<ffffffff8036b04e>] ? acpi_idle_enter_bm+0xd1/0x385
 [<ffffffff803da394>] ? cpuidle_idle_call+0x94/0xcc
 [<ffffffff8020a575>] ? cpu_idle+0x4a/0x8b
 [<ffffffff804493c8>] ? rest_init+0x5c/0x5e
---[ end trace e0ae56f3882dee14 ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204 iwl_tx_cmd_complete+0x50/0x248 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi thinkpad_acpi hwmon iwlagn iwlcore backlight rfkill led_class nvram sdhci_pci sdhci firewire_ohci firewire_core ehci_hcd uhci_hcd mac80211 piix sg evdev mmc_core yenta_socket rsrc_nonstatic pcmcia_core crc_itu_t ide_core usbcore cfg80211 e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc3 #52
Call Trace:
 <IRQ>  [<ffffffff80231e14>] warn_slowpath+0xae/0xd5
 [<ffffffff8022710d>] ? __wake_up+0x43/0x50
 [<ffffffff802410a6>] ? insert_work+0x4d/0x52
 [<ffffffff802417bc>] ? __queue_work+0x35/0x3d
 [<ffffffff80241842>] ? queue_work_on+0x42/0x4b
 [<ffffffffa00dcc3c>] ? ieee80211_sta_rx_mgmt+0x8e/0xa2 [mac80211]
 [<ffffffffa00e14b8>] ? ieee80211_invoke_rx_handlers+0xc3/0x282 [mac80211]
 [<ffffffffa015881b>] ? iwl_rx_queue_update_write_ptr+0x41d/0x443 [iwlcore]
 [<ffffffffa0159b2a>] iwl_tx_cmd_complete+0x50/0x248 [iwlcore]
 [<ffffffffa015902b>] ? iwl_rx_queue_restock+0xbb/0x140 [iwlcore]
 [<ffffffffa017f805>] iwl_rx_handle+0x2bf/0x3d5 [iwlagn]
 [<ffffffff80247452>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0180214>] iwl4965_irq_tasklet+0x8f9/0xc12 [iwlagn]
 [<ffffffff802467ed>] ? hrtimer_reprogram+0x80/0x9f
 [<ffffffff80236295>] tasklet_action+0x70/0xbb
 [<ffffffff80247248>] ? hrtimer_start_range_ns+0x13e/0x160
 [<ffffffff80236b8d>] __do_softirq+0x83/0x142
 [<ffffffff8020c55c>] call_softirq+0x1c/0x28
 [<ffffffff8020da04>] do_softirq+0x34/0x72
 [<ffffffff802368ba>] irq_exit+0x3f/0x82
 [<ffffffff8020dcce>] do_IRQ+0x150/0x172
 [<ffffffff8020b8a6>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8036b4ca>] ? acpi_idle_enter_simple+0x1c8/0x23a
 [<ffffffff8036b4c0>] ? acpi_idle_enter_simple+0x1be/0x23a
 [<ffffffff8036b04e>] ? acpi_idle_enter_bm+0xd1/0x385
 [<ffffffff803da394>] ? cpuidle_idle_call+0x94/0xcc
 [<ffffffff8020a575>] ? cpu_idle+0x4a/0x8b
 [<ffffffff804493c8>] ? rest_init+0x5c/0x5e
---[ end trace e0ae56f3882dee14 ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204 iwl_tx_cmd_complete+0x50/0x248 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi thinkpad_acpi hwmon iwlagn iwlcore backlight rfkill led_class nvram sdhci_pci sdhci firewire_ohci firewire_core ehci_hcd uhci_hcd mac80211 piix sg evdev mmc_core yenta_socket rsrc_nonstatic pcmcia_core crc_itu_t ide_core usbcore cfg80211 e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc3 #52
Call Trace:
 <IRQ>  [<ffffffff80231e14>] warn_slowpath+0xae/0xd5
 [<ffffffff8022510c>] ? enqueue_task+0x50/0x5b
 [<ffffffff80225203>] ? activate_task+0x22/0x2a
 [<ffffffff8022b5a4>] ? try_to_wake_up+0x236/0x248
 [<ffffffff8022b5c3>] ? default_wake_function+0xd/0xf
 [<ffffffff802445bb>] ? autoremove_wake_function+0x11/0x38
 [<ffffffff802256f6>] ? __wake_up_common+0x46/0x76
 [<ffffffff8022710d>] ? __wake_up+0x43/0x50
 [<ffffffff802410a6>] ? insert_work+0x4d/0x52
 [<ffffffff802417bc>] ? __queue_work+0x35/0x3d
 [<ffffffffa0159b2a>] iwl_tx_cmd_complete+0x50/0x248 [iwlcore]
 [<ffffffffa015902b>] ? iwl_rx_queue_restock+0xbb/0x140 [iwlcore]
 [<ffffffffa017f805>] iwl_rx_handle+0x2bf/0x3d5 [iwlagn]
 [<ffffffff80247452>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0180214>] iwl4965_irq_tasklet+0x8f9/0xc12 [iwlagn]
 [<ffffffff802467ed>] ? hrtimer_reprogram+0x80/0x9f
 [<ffffffff80236295>] tasklet_action+0x70/0xbb
 [<ffffffff80247248>] ? hrtimer_start_range_ns+0x13e/0x160
 [<ffffffff80236b8d>] __do_softirq+0x83/0x142
 [<ffffffff8020c55c>] call_softirq+0x1c/0x28
 [<ffffffff8020da04>] do_softirq+0x34/0x72
 [<ffffffff802368ba>] irq_exit+0x3f/0x82
 [<ffffffff8020dcce>] do_IRQ+0x150/0x172
 [<ffffffff8020b8a6>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8036b27d>] ? acpi_idle_enter_bm+0x300/0x385
 [<ffffffff8036b273>] ? acpi_idle_enter_bm+0x2f6/0x385
 [<ffffffff803da394>] ? cpuidle_idle_call+0x94/0xcc
 [<ffffffff8020a575>] ? cpu_idle+0x4a/0x8b
 [<ffffffff804493c8>] ? rest_init+0x5c/0x5e
---[ end trace e0ae56f3882dee14 ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204 iwl_tx_cmd_complete+0x50/0x248 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi thinkpad_acpi hwmon iwlagn iwlcore backlight rfkill led_class nvram sdhci_pci sdhci firewire_ohci firewire_core ehci_hcd uhci_hcd mac80211 piix sg evdev mmc_core yenta_socket rsrc_nonstatic pcmcia_core crc_itu_t ide_core usbcore cfg80211 e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc3 #52
Call Trace:
 <IRQ>  [<ffffffff80231e14>] warn_slowpath+0xae/0xd5
 [<ffffffff8022510c>] ? enqueue_task+0x50/0x5b
 [<ffffffff80225203>] ? activate_task+0x22/0x2a
 [<ffffffff8022b5a4>] ? try_to_wake_up+0x236/0x248
 [<ffffffff8022b5c3>] ? default_wake_function+0xd/0xf
 [<ffffffff802445bb>] ? autoremove_wake_function+0x11/0x38
 [<ffffffff802256f6>] ? __wake_up_common+0x46/0x76
 [<ffffffff8022710d>] ? __wake_up+0x43/0x50
 [<ffffffffa015881b>] ? iwl_rx_queue_update_write_ptr+0x41d/0x443 [iwlcore]
 [<ffffffff802417bc>] ? __queue_work+0x35/0x3d
 [<ffffffffa0159b2a>] iwl_tx_cmd_complete+0x50/0x248 [iwlcore]
 [<ffffffffa015902b>] ? iwl_rx_queue_restock+0xbb/0x140 [iwlcore]
 [<ffffffffa017f805>] iwl_rx_handle+0x2bf/0x3d5 [iwlagn]
 [<ffffffff80247452>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0180214>] iwl4965_irq_tasklet+0x8f9/0xc12 [iwlagn]
 [<ffffffff802467ed>] ? hrtimer_reprogram+0x80/0x9f
 [<ffffffff80236295>] tasklet_action+0x70/0xbb
 [<ffffffff80247248>] ? hrtimer_start_range_ns+0x13e/0x160
 [<ffffffff80236b8d>] __do_softirq+0x83/0x142
 [<ffffffff8020c55c>] call_softirq+0x1c/0x28
 [<ffffffff8020da04>] do_softirq+0x34/0x72
 [<ffffffff802368ba>] irq_exit+0x3f/0x82
 [<ffffffff8020dcce>] do_IRQ+0x150/0x172
 [<ffffffff8020b8a6>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8036b4ca>] ? acpi_idle_enter_simple+0x1c8/0x23a
 [<ffffffff8036b4c0>] ? acpi_idle_enter_simple+0x1be/0x23a
 [<ffffffff8036b04e>] ? acpi_idle_enter_bm+0xd1/0x385
 [<ffffffff803da394>] ? cpuidle_idle_call+0x94/0xcc
 [<ffffffff8020a575>] ? cpu_idle+0x4a/0x8b
 [<ffffffff804493c8>] ? rest_init+0x5c/0x5e
---[ end trace e0ae56f3882dee14 ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204 iwl_tx_cmd_complete+0x50/0x248 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi thinkpad_acpi hwmon iwlagn iwlcore backlight rfkill led_class nvram sdhci_pci sdhci firewire_ohci firewire_core ehci_hcd uhci_hcd mac80211 piix sg evdev mmc_core yenta_socket rsrc_nonstatic pcmcia_core crc_itu_t ide_core usbcore cfg80211 e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc3 #52
Call Trace:
 <IRQ>  [<ffffffff80231e14>] warn_slowpath+0xae/0xd5
 [<ffffffff80248a5d>] ? sched_clock_cpu+0x134/0x140
 [<ffffffff8022943b>] ? enqueue_task_fair+0x22a/0x282
 [<ffffffff80249048>] ? getnstimeofday+0x3a/0x96
 [<ffffffff80247452>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa015881b>] ? iwl_rx_queue_update_write_ptr+0x41d/0x443 [iwlcore]
 [<ffffffff8024b9d9>] ? clockevents_program_event+0x73/0x7c
 [<ffffffffa0159b2a>] iwl_tx_cmd_complete+0x50/0x248 [iwlcore]
 [<ffffffffa015902b>] ? iwl_rx_queue_restock+0xbb/0x140 [iwlcore]
 [<ffffffffa017f805>] iwl_rx_handle+0x2bf/0x3d5 [iwlagn]
 [<ffffffff80247452>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0180214>] iwl4965_irq_tasklet+0x8f9/0xc12 [iwlagn]
 [<ffffffff802467ed>] ? hrtimer_reprogram+0x80/0x9f
 [<ffffffff80236295>] tasklet_action+0x70/0xbb
 [<ffffffff80247248>] ? hrtimer_start_range_ns+0x13e/0x160
 [<ffffffff80236b8d>] __do_softirq+0x83/0x142
 [<ffffffff8020c55c>] call_softirq+0x1c/0x28
 [<ffffffff8020da04>] do_softirq+0x34/0x72
 [<ffffffff802368ba>] irq_exit+0x3f/0x82
 [<ffffffff8020dcce>] do_IRQ+0x150/0x172
 [<ffffffff8020b8a6>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8036b27d>] ? acpi_idle_enter_bm+0x300/0x385
 [<ffffffff8036b273>] ? acpi_idle_enter_bm+0x2f6/0x385
 [<ffffffff803da394>] ? cpuidle_idle_call+0x94/0xcc
 [<ffffffff8020a575>] ? cpu_idle+0x4a/0x8b
 [<ffffffff804493c8>] ? rest_init+0x5c/0x5e
---[ end trace e0ae56f3882dee14 ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204 iwl_tx_cmd_complete+0x50/0x248 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi thinkpad_acpi hwmon iwlagn iwlcore backlight rfkill led_class nvram sdhci_pci sdhci firewire_ohci firewire_core ehci_hcd uhci_hcd mac80211 piix sg evdev mmc_core yenta_socket rsrc_nonstatic pcmcia_core crc_itu_t ide_core usbcore cfg80211 e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc3 #52
Call Trace:
 <IRQ>  [<ffffffff80231e14>] warn_slowpath+0xae/0xd5
 [<ffffffff8022510c>] ? enqueue_task+0x50/0x5b
 [<ffffffff802271de>] ? task_rq_lock+0x40/0x79
 [<ffffffff8022b5a4>] ? try_to_wake_up+0x236/0x248
 [<ffffffff802256f6>] ? __wake_up_common+0x46/0x76
 [<ffffffff8022710d>] ? __wake_up+0x43/0x50
 [<ffffffffa015881b>] ? iwl_rx_queue_update_write_ptr+0x41d/0x443 [iwlcore]
 [<ffffffffa0159b2a>] iwl_tx_cmd_complete+0x50/0x248 [iwlcore]
 [<ffffffff80249048>] ? getnstimeofday+0x3a/0x96
 [<ffffffffa017f805>] iwl_rx_handle+0x2bf/0x3d5 [iwlagn]
 [<ffffffff80218793>] ? lapic_next_event+0x15/0x19
 [<ffffffff8024b9d9>] ? clockevents_program_event+0x73/0x7c
 [<ffffffffa0180214>] iwl4965_irq_tasklet+0x8f9/0xc12 [iwlagn]
 [<ffffffff80236295>] tasklet_action+0x70/0xbb
 [<ffffffff80236b8d>] __do_softirq+0x83/0x142
 [<ffffffff8020c55c>] call_softirq+0x1c/0x28
 [<ffffffff8020da04>] do_softirq+0x34/0x72
 [<ffffffff802368ba>] irq_exit+0x3f/0x82
 [<ffffffff8020dcce>] do_IRQ+0x150/0x172
 [<ffffffff8020b8a6>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8036b4ca>] ? acpi_idle_enter_simple+0x1c8/0x23a
 [<ffffffff8036b4c0>] ? acpi_idle_enter_simple+0x1be/0x23a
 [<ffffffff8036b04e>] ? acpi_idle_enter_bm+0xd1/0x385
 [<ffffffff803da394>] ? cpuidle_idle_call+0x94/0xcc
 [<ffffffff8020a575>] ? cpu_idle+0x4a/0x8b
 [<ffffffff80454e40>] ? start_secondary+0x23b/0x242
---[ end trace e0ae56f3882dee14 ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204 iwl_tx_cmd_complete+0x50/0x248 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi thinkpad_acpi hwmon iwlagn iwlcore backlight rfkill led_class nvram sdhci_pci sdhci firewire_ohci firewire_core ehci_hcd uhci_hcd mac80211 piix sg evdev mmc_core yenta_socket rsrc_nonstatic pcmcia_core crc_itu_t ide_core usbcore cfg80211 e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc3 #52
Call Trace:
 <IRQ>  [<ffffffff80231e14>] warn_slowpath+0xae/0xd5
 [<ffffffff8022510c>] ? enqueue_task+0x50/0x5b
 [<ffffffff80225203>] ? activate_task+0x22/0x2a
 [<ffffffff8022b5a4>] ? try_to_wake_up+0x236/0x248
 [<ffffffff8022b5c3>] ? default_wake_function+0xd/0xf
 [<ffffffff802445bb>] ? autoremove_wake_function+0x11/0x38
 [<ffffffff802256f6>] ? __wake_up_common+0x46/0x76
 [<ffffffff8022710d>] ? __wake_up+0x43/0x50
 [<ffffffffa015881b>] ? iwl_rx_queue_update_write_ptr+0x41d/0x443 [iwlcore]
 [<ffffffff802417bc>] ? __queue_work+0x35/0x3d
 [<ffffffffa0159b2a>] iwl_tx_cmd_complete+0x50/0x248 [iwlcore]
 [<ffffffffa015902b>] ? iwl_rx_queue_restock+0xbb/0x140 [iwlcore]
 [<ffffffffa017f805>] iwl_rx_handle+0x2bf/0x3d5 [iwlagn]
 [<ffffffff80247452>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0180214>] iwl4965_irq_tasklet+0x8f9/0xc12 [iwlagn]
 [<ffffffff802467ed>] ? hrtimer_reprogram+0x80/0x9f
 [<ffffffff80236295>] tasklet_action+0x70/0xbb
 [<ffffffff80247248>] ? hrtimer_start_range_ns+0x13e/0x160
 [<ffffffff80236b8d>] __do_softirq+0x83/0x142
 [<ffffffff8020c55c>] call_softirq+0x1c/0x28
 [<ffffffff8020da04>] do_softirq+0x34/0x72
 [<ffffffff802368ba>] irq_exit+0x3f/0x82
 [<ffffffff8020dcce>] do_IRQ+0x150/0x172
 [<ffffffff8020b8a6>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8036b4ca>] ? acpi_idle_enter_simple+0x1c8/0x23a
 [<ffffffff8036b4c0>] ? acpi_idle_enter_simple+0x1be/0x23a
 [<ffffffff8036b04e>] ? acpi_idle_enter_bm+0xd1/0x385
 [<ffffffff803da394>] ? cpuidle_idle_call+0x94/0xcc
 [<ffffffff8020a575>] ? cpu_idle+0x4a/0x8b
 [<ffffffff804493c8>] ? rest_init+0x5c/0x5e
---[ end trace e0ae56f3882dee14 ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1204 iwl_tx_cmd_complete+0x50/0x248 [iwlcore]()
wrong command queue 31, command id 0x0
Modules linked in: aes_x86_64 aes_generic ecryptfs af_packet i915 drm binfmt_misc rfcomm bnep sco l2cap bridge stp llc kvm_intel kvm ipv6 ip_tables x_tables tpm_tis tpm tpm_bios fuse loop btusb bluetooth pcmcia arc4 ecb cryptomgr aead crypto_blkcipher crypto_algapi thinkpad_acpi hwmon iwlagn iwlcore backlight rfkill led_class nvram sdhci_pci sdhci firewire_ohci firewire_core ehci_hcd uhci_hcd mac80211 piix sg evdev mmc_core yenta_socket rsrc_nonstatic pcmcia_core crc_itu_t ide_core usbcore cfg80211 e1000e unix
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc3 #52
Call Trace:
 <IRQ>  [<ffffffff80231e14>] warn_slowpath+0xae/0xd5
 [<ffffffff80269ab0>] ? mempool_free_slab+0x12/0x14
 [<ffffffff80288f54>] ? check_object+0x159/0x208
 [<ffffffff80229e64>] ? find_busiest_group+0x327/0x7d4
 [<ffffffff80217e90>] ? native_smp_send_reschedule+0x4d/0x4f
 [<ffffffffa0159b2a>] iwl_tx_cmd_complete+0x50/0x248 [iwlcore]
 [<ffffffffa015902b>] ? iwl_rx_queue_restock+0xbb/0x140 [iwlcore]
 [<ffffffffa017f805>] iwl_rx_handle+0x2bf/0x3d5 [iwlagn]
 [<ffffffff80247452>] ? ktime_get_ts+0x49/0x4e
 [<ffffffffa0180214>] iwl4965_irq_tasklet+0x8f9/0xc12 [iwlagn]
 [<ffffffff802467ed>] ? hrtimer_reprogram+0x80/0x9f
 [<ffffffff80236295>] tasklet_action+0x70/0xbb
 [<ffffffff80247248>] ? hrtimer_start_range_ns+0x13e/0x160
 [<ffffffff80236b8d>] __do_softirq+0x83/0x142
 [<ffffffff8020c55c>] call_softirq+0x1c/0x28
 [<ffffffff8020da04>] do_softirq+0x34/0x72
 [<ffffffff802368ba>] irq_exit+0x3f/0x82
 [<ffffffff8020dcce>] do_IRQ+0x150/0x172
 [<ffffffff8020b8a6>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8036b4ca>] ? acpi_idle_enter_simple+0x1c8/0x23a
 [<ffffffff8036b4c0>] ? acpi_idle_enter_simple+0x1be/0x23a
 [<ffffffff8036b04e>] ? acpi_idle_enter_bm+0xd1/0x385
 [<ffffffff803da394>] ? cpuidle_idle_call+0x94/0xcc
 [<ffffffff8020a575>] ? cpu_idle+0x4a/0x8b
 [<ffffffff80454e40>] ? start_secondary+0x23b/0x242
---[ end trace e0ae56f3882dee14 ]---

--Apple-Mail-4-403401503
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit




--Apple-Mail-4-403401503
Content-Disposition: attachment;
	filename=config-2.6.28-rc3.txt
Content-Type: text/plain;
	x-unix-mode=0644;
	name="config-2.6.28-rc3.txt"
Content-Transfer-Encoding: 7bit

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28-rc3
# Mon Nov  3 00:41:50 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_MARKERS=y
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=128
CONFIG_X86_INTERNODE_CACHE_BYTES=128
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_64=y
# CONFIG_X86_DS is not set
# CONFIG_X86_PTRACE_BTS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_UNEVICTABLE_LRU is not set
CONFIG_MMU_NOTIFIER=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MTRR is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_WMI=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_PCMCIA_IOCTL is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=m
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=m
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_LOG=m
# CONFIG_NF_CONNTRACK is not set
CONFIG_NETFILTER_XTABLES=m
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
CONFIG_IP_NF_IPTABLES=m
# CONFIG_IP_NF_FILTER is not set
# CONFIG_IP_NF_TARGET_LOG is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
# CONFIG_IP_NF_MANGLE is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_IP6_NF_IPTABLES=m
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
# CONFIG_IP6_NF_TARGET_LOG is not set
# CONFIG_IP6_NF_FILTER is not set
# CONFIG_IP6_NF_MANGLE is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set
CONFIG_PHONET=m
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT=y
CONFIG_MAC80211_NOINLINE=y
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_TKIP_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
# CONFIG_MAC80211_VERBOSE_PS_DEBUG is not set
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
# CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG is not set
# CONFIG_IEEE80211 is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_BAY=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_SGI_XP is not set
# CONFIG_HP_ILO is not set
# CONFIG_SGI_GRU is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDESCSI is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=m
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
# CONFIG_FIREWIRE_SBP2 is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=m
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=m
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
CONFIG_USB_NET_RNDIS_WLAN=m
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH9K is not set
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUGFS=y
CONFIG_IWLAGN=m
# CONFIG_IWLAGN_SPECTRUM_MEASUREMENT is not set
CONFIG_IWLAGN_LEDS=y
CONFIG_IWL4965=y
# CONFIG_IWL5000 is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=m
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=m
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_HSO=m
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOL2TP=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
CONFIG_ISDN=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
# CONFIG_MISDN_HFCMULTI is not set
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
# CONFIG_ISDN_CAPI_CAPIFS_BOOL is not set

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
# CONFIG_CAPI_EICON is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=m
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=m
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_AT24 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=m
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set

#
# Voltage and Current regulators
#
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
# CONFIG_REGULATOR_BQ24022 is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=m
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=y
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=m
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=m
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
# CONFIG_SND_DRIVERS is not set
# CONFIG_SND_PCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# Special HID drivers
#
# CONFIG_HID_COMPAT is not set
CONFIG_HID_A4TECH=m
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_BRIGHT=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DELL=m
CONFIG_HID_EZKEY=m
CONFIG_HID_GYRATION=m
CONFIG_HID_LOGITECH=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_HID_SUNPLUS=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m
# CONFIG_USB_GADGET_MUSB_HDRC is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP2101 is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=m
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_OPTION=m
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_AT91 is not set
# CONFIG_USB_GADGET_ATMEL_USBA is not set
# CONFIG_USB_GADGET_FSL_USB2 is not set
# CONFIG_USB_GADGET_LH7A40X is not set
# CONFIG_USB_GADGET_OMAP is not set
# CONFIG_USB_GADGET_PXA25X is not set
# CONFIG_USB_GADGET_PXA27X is not set
# CONFIG_USB_GADGET_S3C2410 is not set
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_FSL_QE is not set
# CONFIG_USB_GADGET_NET2280 is not set
# CONFIG_USB_GADGET_GOKU is not set
CONFIG_USB_GADGET_DUMMY_HCD=y
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_GADGET_DUALSPEED=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_WLP=m
CONFIG_UWB_I1480U=m
CONFIG_UWB_I1480U_WLP=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
# CONFIG_MMC_RICOH_MMC is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_HP_DISK is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_IDE_DISK=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_ME4000 is not set
CONFIG_USB_IP_COMMON=m
CONFIG_USB_IP_VHCI_HCD=m
CONFIG_USB_IP_HOST=m
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
CONFIG_ECHO=m
# CONFIG_USB_ATMEL is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=m
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
# CONFIG_NFS_V4 is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
# CONFIG_SUNRPC_REGISTER_V4 is not set
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_BOOT_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_DYNAMIC_PRINTK_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT=y
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_TRACE is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Apple-Mail-4-403401503
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit





--Apple-Mail-4-403401503--

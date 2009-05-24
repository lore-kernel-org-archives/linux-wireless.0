Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:7295 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZEXKWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 06:22:49 -0400
Received: by ey-out-2122.google.com with SMTP id 9so678553eyd.37
        for <linux-wireless@vger.kernel.org>; Sun, 24 May 2009 03:22:48 -0700 (PDT)
Message-ID: <4A192017.3060508@tuffmail.co.uk>
Date: Sun, 24 May 2009 11:23:19 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org
Subject: deadlock triggered by buggy hardware (EEE PC) in wireless-testing+rfkill-rewrite
 v11
Content-Type: multipart/mixed;
 boundary="------------070505030603010005070904"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070505030603010005070904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi, today I tested wireless-testing +rfkill rewrite v11, +2.6.30-rc7 for 
some recent eeepc-laptop updates.  See attached dmesg.

The EC firmware for my eeepc doesn't like it if the battery is removed 
during hibernation, and screws up rfkill transitions - one of the 
updates I was testing was the workaround which hides this problem.  Be 
aware that the eeepc rfkill is unusual: it hotplugs the ath5k PCI device.

When I tested battery-removal-during-hibernation, I was a bit 
enthusiastic pressing the wireless-toggle key on resume, and managed to 
kill the EC.  It stopped responding to the wireless toggle key, and 
stopped updating the battery state (claiming the battery was present 
even after removing it).  That's when I noticed the deadlock messages.

I've missed at least one detail - I forgot to check what state 
eeepc-laptop thinks the rfkill is in (and I've since rebooted).  I want 
to look closely at the kernel messages and understand the deadlock 
before trying anything else.  I'm slightly concerned that the buggy EC 
might inflict permanent damage, so I don't want to reproduce the bug 
more times than is necessary.

Thanks
Alan

--------------070505030603010005070904
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

[    0.000000] Linux version 2.6.30-rc7-wleeepc (alan@alan-desktop) (gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu3)) #50 Sun May 24 09:38:00 BST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001f780000 (usable)
[    0.000000]  BIOS-e820: 000000001f780000 - 000000001f790000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001f790000 - 000000001f7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001f7d0000 - 000000001f7de000 (reserved)
[    0.000000]  BIOS-e820: 000000001f7e0000 - 000000001f800000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x1f780 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FE0000000 write-back
[    0.000000]   1 base 01F800000 mask FFF800000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] init_memory_mapping: 0000000000000000-000000001f780000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 001f600000 page 2M
[    0.000000]  001f600000 - 001f780000 page 4k
[    0.000000] kernel direct mapping tables up to 1f780000 @ 10000-16000
[    0.000000] RAMDISK: 17625000 - 179df9d1
[    0.000000] ACPI: RSDP 000fbe50 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 1f780000 00034 (v01 A M I  OEMRSDT  03000911 MSFT 00000097)
[    0.000000] ACPI: FACP 1f780200 00081 (v01 A M I  OEMFACP  03000911 MSFT 00000097)
[    0.000000] ACPI: DSDT 1f780400 06069 (v01  A0797 A0797000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 1f790000 00040
[    0.000000] ACPI: APIC 1f780390 00068 (v01 A M I  OEMAPIC  03000911 MSFT 00000097)
[    0.000000] ACPI: OEMB 1f790040 00046 (v01 A M I  AMI_OEM  03000911 MSFT 00000097)
[    0.000000] ACPI: MCFG 1f786470 0003C (v01 A M I  OEMMCFG  03000911 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 503MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1f780000
[    0.000000]   low ram: 0 - 1f780000
[    0.000000]   node 0 low ram: 00000000 - 1f780000
[    0.000000]   node 0 bootmap 00012000 - 00015ef0
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 001f780000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 00009b8134]    TEXT DATA BSS ==> [0000100000 - 00009b8134]
[    0.000000]   #2 [0017625000 - 00179df9d1]          RAMDISK ==> [0017625000 - 00179df9d1]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #4 [00009b9000 - 00009c01f4]              BRK ==> [00009b9000 - 00009c01f4]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #6 [0000012000 - 0000016000]          BOOTMAP ==> [0000012000 - 0000016000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001f780
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001f780
[    0.000000] On node 0 totalpages: 128783
[    0.000000] free_area_init_node: node 0, pgdat c043c854, node_mem_map c1000200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 975 pages used for memmap
[    0.000000]   Normal zone: 123825 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 1f800000:df600000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 127776
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.30-rc7-wleeepc root=/dev/sda2 ro rootfstype=ext4 resume=/dev/sda2
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:288
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 630.023 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:          4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.003333] ... MAX_LOCKDEP_CHAINS:      32768
[    0.003333] ... CHAINHASH_SIZE:          16384
[    0.003333]  memory used by lock dependency info: 3487 kB
[    0.003333]  per task-struct memory footprint: 1152 bytes
[    0.003333] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.003333] Memory: 497696k/515584k available (2057k kernel code, 17260k reserved, 1294k data, 248k init, 0k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
[    0.003333]     vmalloc : 0xdff80000 - 0xfffa8000   ( 512 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xdf780000   ( 503 MB)
[    0.003333]       .init : 0xc044a000 - 0xc0488000   ( 248 kB)
[    0.003333]       .data : 0xc03026fb - 0xc04460a0   (1294 kB)
[    0.003333]       .text : 0xc0100000 - 0xc03026fb   (2057 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.003381] Calibrating delay loop (skipped), value calculated using timer frequency.. 1260.54 BogoMIPS (lpj=2100076)
[    0.003666] Mount-cache hash table entries: 512
[    0.006244] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.006391] CPU: L2 cache: 512K
[    0.006488] Intel machine check architecture supported.
[    0.006685] Intel machine check reporting enabled on CPU#0.
[    0.006796] CPU: Intel(R) Celeron(R) M processor          900MHz stepping 08
[    0.007003] Checking 'hlt' instruction... OK.
[    0.020647] ACPI: Core revision 20090320
[    0.053807] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.089999] net_namespace: 1136 bytes
[    0.091345] NET: Registered protocol family 16
[    0.093737] ACPI: bus type pci registered
[    0.094537] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.094650] PCI: Not using MMCONFIG.
[    0.095043] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.095147] PCI: Using configuration type 1 for base access
[    0.108705] bio: create slab <bio-0> at 0
[    0.116888] ACPI: EC: Look up EC in DSDT
[    0.152898] ACPI: Interpreter enabled
[    0.153021] ACPI: (supports S0 S1 S3 S4 S5)
[    0.153500] ACPI: Using IOAPIC for interrupt routing
[    0.153820] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.163867] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.163977] PCI: Using MMCONFIG for extended config space
[    0.200199] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.200316] ACPI: EC: driver started in poll mode
[    0.201961] ACPI: No dock devices found.
[    0.202363] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.203464] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7f00000-0xf7f7ffff]
[    0.203486] pci 0000:00:02.0: reg 14 io port: [0xec00-0xec07]
[    0.203507] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
[    0.203529] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf7ec0000-0xf7efffff]
[    0.203676] pci 0000:00:02.1: reg 10 32bit mmio: [0xf7f80000-0xf7ffffff]
[    0.203988] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7eb8000-0xf7ebbfff]
[    0.204120] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.204232] pci 0000:00:1b.0: PME# disabled
[    0.204504] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.204613] pci 0000:00:1c.0: PME# disabled
[    0.204886] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.204995] pci 0000:00:1c.1: PME# disabled
[    0.205269] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.205379] pci 0000:00:1c.2: PME# disabled
[    0.205612] pci 0000:00:1d.0: reg 20 io port: [0xe400-0xe41f]
[    0.205764] pci 0000:00:1d.1: reg 20 io port: [0xe480-0xe49f]
[    0.205908] pci 0000:00:1d.2: reg 20 io port: [0xe800-0xe81f]
[    0.206053] pci 0000:00:1d.3: reg 20 io port: [0xe880-0xe89f]
[    0.206208] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7eb7c00-0xf7eb7fff]
[    0.206348] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.206459] pci 0000:00:1d.7: PME# disabled
[    0.207020] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.207041] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.207189] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.207300] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 0380-03ff
[    0.207497] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.207519] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.207540] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.207561] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.207582] pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
[    0.207660] pci 0000:00:1f.2: PME# supported from D3hot
[    0.207766] pci 0000:00:1f.2: PME# disabled
[    0.207974] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.208335] pci 0000:03:00.0: reg 10 64bit mmio: [0xfbfc0000-0xfbffffff]
[    0.208415] pci 0000:03:00.0: reg 30 32bit mmio: [0xfbfa0000-0xfbfbffff]
[    0.208506] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.208616] pci 0000:03:00.0: PME# disabled
[    0.208831] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.209438] pci 0000:00:1c.1: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
[    0.209602] pci 0000:00:1c.2: bridge 32bit mmio: [0xf8000000-0xfbefffff]
[    0.209624] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xf0000000-0xf6ffffff]
[    0.209772] pci 0000:00:1e.0: transparent bridge
[    0.209942] pci_bus 0000:00: on NUMA node 0
[    0.209978] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.210776] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.211006] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.211217] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.242769] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.244014] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.245189] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.246365] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.247597] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.248896] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.250220] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.251524] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.253969] SCSI subsystem initialized
[    0.254228] libata version 3.00 loaded.
[    0.255677] PCI: Using ACPI for IRQ routing
[    0.258363] hpet clockevent registered
[    0.258375] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.258499] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.258783] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.265055] pnp: PnP ACPI init
[    0.265233] ACPI: bus type pnp registered
[    0.277667] pnp: PnP ACPI: found 13 devices
[    0.277773] ACPI: ACPI bus type pnp unregistered
[    0.277929] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.278081] system 00:08: ioport range 0x380-0x383 has been reserved
[    0.278193] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.278305] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.278415] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.278532] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.280411] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.280526] system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.280693] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.280806] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.280939] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.281073] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.281208] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.281319] system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
[    0.281432] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.281545] system 00:0c: iomem range 0x100000-0x1f7fffff could not be reserved
[    0.319395] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.319504] pci 0000:00:1c.0:   IO window: disabled
[    0.319612] pci 0000:00:1c.0:   MEM window: disabled
[    0.319716] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.319829] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.319931] pci 0000:00:1c.1:   IO window: disabled
[    0.320055] pci 0000:00:1c.1:   MEM window: 0xfbf00000-0xfbffffff
[    0.320164] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.320276] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:01
[    0.320378] pci 0000:00:1c.2:   IO window: disabled
[    0.320486] pci 0000:00:1c.2:   MEM window: 0xf8000000-0xfbefffff
[    0.320597] pci 0000:00:1c.2:   PREFETCH window: 0x000000f0000000-0x000000f6ffffff
[    0.320750] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.320852] pci 0000:00:1e.0:   IO window: disabled
[    0.320958] pci 0000:00:1e.0:   MEM window: disabled
[    0.321062] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.321218] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.321333] pci 0000:00:1c.0: setting latency timer to 64
[    0.321365] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.321477] pci 0000:00:1c.1: setting latency timer to 64
[    0.321511] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.321625] pci 0000:00:1c.2: setting latency timer to 64
[    0.321648] pci 0000:00:1e.0: setting latency timer to 64
[    0.321663] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.321675] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.321687] pci_bus 0000:03: resource 1 mem: [0xfbf00000-0xfbffffff]
[    0.321698] pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbefffff]
[    0.321709] pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf6ffffff]
[    0.321720] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.321731] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.321941] NET: Registered protocol family 2
[    0.322762] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.325224] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.325792] TCP bind hash table entries: 16384 (order: 7, 524288 bytes)
[    0.331317] TCP: Hash tables configured (established 16384 bind 16384)
[    0.331556] TCP reno registered
[    0.332100] NET: Registered protocol family 1
[    0.332967] Trying to unpack rootfs image as initramfs...
[    0.719344] Freeing initrd memory: 3818k freed
[    0.730548] audit: initializing netlink socket (disabled)
[    0.730771] type=2000 audit(1243155396.729:1): initialized
[    0.760031] Switched to NOHz mode on CPU #0
[    0.773423] msgmni has been set to 979
[    0.775339] alg: No test for stdrng (krng)
[    0.775557] io scheduler noop registered
[    0.775655] io scheduler anticipatory registered
[    0.775753] io scheduler deadline registered
[    0.776288] io scheduler cfq registered (default)
[    0.776428] pci 0000:00:02.0: Boot video device
[    0.777502] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.777549] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.778635] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.778677] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.779713] pcieport-driver 0000:00:1c.2: irq 26 for MSI/MSI-X
[    0.779755] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.784648] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.839185] brd: module loaded
[    0.839551] Driver 'sd' needs updating - please use bus_type methods
[    0.839976] ahci 0000:00:1f.2: version 3.0
[    0.840338] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.840504] ahci 0000:00:1f.2: PCI INT B disabled
[    0.840626] ahci: probe of 0000:00:1f.2 failed with error -22
[    0.841602] ata_piix 0000:00:1f.2: version 2.13
[    0.841630] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.841811] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    0.842296] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.842630] scsi0 : ata_piix
[    0.867153] scsi1 : ata_piix
[    0.867646] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.867799] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    0.868742] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    0.868845] Copyright (c) 2007 Atheros Corporation.
[    0.869048] atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.869172] atl2 0000:03:00.0: setting latency timer to 64
[    1.356435] ACPI: Battery Slot [BAT0] (battery present)
[    1.372870] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.406645] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.406858] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.408576] mice: PS/2 mouse device common for all mice
[    1.409194] rtc_cmos 00:03: RTC can wake from S4
[    1.410456] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.410613] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    1.410968] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    1.411689] iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x0860)
[    1.412182] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.412296] iTCO_vendor_support: vendor-support=0
[    1.412450] cpuidle: using governor ladder
[    1.412547] cpuidle: using governor menu
[    1.413151] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    1.413258] ALSA device list:
[    1.413404]   No soundcards found.
[    1.416359] TCP cubic registered
[    1.416465] Using IPI Shortcut mode
[    1.417604] PM: Checking image partition /dev/sda2
[    1.434718] input: AT Translated Set 2 keyboard as /class/input/input0
[    1.517117] ata2.00: CFA: SILICONMOTION SM223AC, , max UDMA/66
[    1.517225] ata2.00: 7815024 sectors, multi 0: LBA 
[    1.530335] ata2.00: configured for UDMA/66
[    1.531914] scsi 1:0:0:0: Direct-Access     ATA      SILICONMOTION SM n/a  PQ: 0 ANSI: 5
[    1.534628] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors: (4.00 GB/3.72 GiB)
[    1.534850] sd 1:0:0:0: [sda] Write Protect is off
[    1.534952] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.535093] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.536300]  sda: sda1 sda2
[    1.539877] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.540104] PM: Resume from partition 8:2
[    1.540110] PM: Checking hibernation image.
[    1.544082] PM: Resume from disk failed.
[    1.544855] rtc_cmos 00:03: setting system clock to 2009-05-24 08:56:38 UTC (1243155398)
[    1.545006] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[    1.546210] Freeing unused kernel memory: 248k freed
[    1.812129] thermal LNXTHERM:01: registered as thermal_zone0
[    1.812318] ACPI: Thermal Zone [TZ00] (41 C)
[    2.879771] usbcore: registered new interface driver usbfs
[    2.880238] usbcore: registered new interface driver hub
[    2.883542] usbcore: registered new device driver usb
[    2.890530] uhci_hcd: USB Universal Host Controller Interface driver
[    2.890824] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.890956] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.890970] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.894074] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    2.894301] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e400
[    2.895722] usb usb1: configuration #1 chosen from 1 choice
[    2.896653] hub 1-0:1.0: USB hub found
[    2.897072] hub 1-0:1.0: 2 ports detected
[    2.899354] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.899484] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.899497] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.899749] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[    2.899959] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e480
[    2.900591] usb usb2: configuration #1 chosen from 1 choice
[    2.900874] hub 2-0:1.0: USB hub found
[    2.901003] hub 2-0:1.0: 2 ports detected
[    2.901594] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.901719] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.901732] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.902050] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[    2.902259] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[    2.902867] usb usb3: configuration #1 chosen from 1 choice
[    2.903145] hub 3-0:1.0: USB hub found
[    2.903271] hub 3-0:1.0: 2 ports detected
[    2.904051] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    2.904182] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.904194] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.904457] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[    2.904662] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e880
[    2.905255] usb usb4: configuration #1 chosen from 1 choice
[    2.905534] hub 4-0:1.0: USB hub found
[    2.907435] hub 4-0:1.0: 2 ports detected
[    2.916628] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.916761] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    2.917014] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.917173] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.917185] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.917468] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[    2.921569] ehci_hcd 0000:00:1d.7: debug port 1
[    2.921678] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.921714] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
[    2.933411] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.934244] usb usb5: configuration #1 chosen from 1 choice
[    2.934562] hub 5-0:1.0: USB hub found
[    2.934801] hub 5-0:1.0: 8 ports detected
[    3.130860] PM: Starting manual resume from disk
[    3.131027] PM: Resume from partition 8:2
[    3.131034] PM: Checking hibernation image.
[    3.131703] PM: Resume from disk failed.
[    3.163180] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    3.163196] PM: Basic memory bitmaps created
[    3.176234] PM: Basic memory bitmaps freed
[    3.199006] EXT4-fs: delayed allocation enabled
[    3.199114] EXT4-fs: file extents enabled
[    3.199447] EXT4-fs: mballoc enabled
[    3.199823] EXT4-fs: mounted filesystem sda2 without journal
[    3.240167] usb 5-5: new high speed USB device using ehci_hcd and address 2
[    3.364968] usb 5-5: configuration #1 chosen from 1 choice
[    3.908034] udev: starting version 140
[    3.908241] udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
[    4.940367] input: Power Button as /class/input/input1
[    4.940781] ACPI: Power Button [PWRF]
[    4.941263] input: Lid Switch as /class/input/input2
[    5.013795] Marking TSC unstable due to TSC halts in idle
[    5.014628] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    5.015233] processor ACPI_CPU:00: registered as cooling_device0
[    5.015356] ACPI: Processor [CPU1] (supports 8 throttling states)
[    5.015800] ACPI: Lid Switch [LID]
[    5.016215] input: Sleep Button as /class/input/input3
[    5.016500] ACPI: Sleep Button [SLPB]
[    5.016947] input: Power Button as /class/input/input4
[    5.017206] ACPI: Power Button [PWRB]
[    5.020488] ACPI: AC Adapter [AC0] (off-line)
[    5.122805] eeepc: Eee PC Hotkey Driver
[    5.160227] eeepc: Hotkey init flags 0x41
[    5.161801] eeepc: Get control methods supported: 0x101711
[    5.162195] input: Asus EeePC extra buttons as /class/input/input5
[    5.233606] input: Video Bus as /class/input/input6
[    5.233918] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    5.280814] Linux agpgart interface v0.103
[    5.340634] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    5.341187] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    5.346427] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    5.511117] intel_rng: FWH not detected
[    5.620461] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.772604] usbcore: registered new interface driver libusual
[    5.880358] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.880594] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.907617] Initializing USB Mass Storage driver...
[    6.023675] scsi2 : SCSI emulation for USB Mass Storage devices
[    6.024289] usbcore: registered new interface driver usb-storage
[    6.024406] USB Mass Storage support registered.
[    6.033666] usb-storage: device found at 2
[    6.033675] usb-storage: waiting for device to settle before scanning
[    6.618961] Synaptics Touchpad, model: 1, fw: 6.5, id: 0x1c0b1, caps: 0xa04751/0xa00000
[    6.714583] input: SynPS/2 Synaptics TouchPad as /class/input/input7
[    6.756725] Clocksource tsc unstable (delta = -149355661 ns)
[    6.783484] EXT4 FS on sda2, no journal
[    7.870924] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    7.891145] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    8.227327] Adding 393208k swap on /swapfile.  Priority:-1 extents:19 across:858644k 
[   11.034151] usb-storage: device scan complete
[   11.036439] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
[   11.260609] NET: Registered protocol family 10
[   11.264302] lo: Disabled Privacy Extensions
[   11.430959] sd 2:0:0:0: [sdb] 15660032 512-byte hardware sectors: (8.01 GB/7.46 GiB)
[   11.431682] sd 2:0:0:0: [sdb] Write Protect is off
[   11.431789] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
[   11.431799] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   11.436753] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   11.436875]  sdb: sdb1
[   11.439171] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   11.627500] pciehp: PCI Express Hot Plug Controller Driver version: 0.4 unloaded
[   13.423332] atl2 0000:03:00.0: irq 27 for MSI/MSI-X
[   13.424665] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.628898] atl2: eth0 NIC Link is Up<100 Mbps Full Duplex>
[   13.629499] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   15.956399] [drm] Initialized drm 1.1.0 20060810
[   16.001128] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   16.001150] pci 0000:00:02.0: setting latency timer to 64
[   16.009252] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read from MCHBAR.  Disabling tiling.
[   16.009325] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   16.882721] NET: Registered protocol family 17
[   34.086720] eth0: no IPv6 routers present
[  303.813392] atl2 0000:03:00.0: irq 27 for MSI/MSI-X
[  303.813993] atl2: eth0 NIC Link is Up<100 Mbps Full Duplex>
[  303.814300] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  303.814430] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  306.923407] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[  306.923422] PM: Basic memory bitmaps created
[  306.998971] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 0
[  309.413254] Syncing filesystems ... done.
[  309.523021] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  309.526236] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  309.526991] PM: Shrinking memory...  -\|done (9583 pages freed)
[  312.054688] PM: Freed 38332 kbytes in 2.52 seconds (15.21 MB/s)
[  312.054700] Suspending console(s) (use no_console_suspend to debug)
[  312.070896] ACPI handle has no context!
[  312.070915] atl2 0000:03:00.0: PME# disabled
[  312.071232] atl2 0000:03:00.0: PCI INT A disabled
[  312.071249] ACPI handle has no context!
[  312.084161] ata_piix 0000:00:1f.2: PCI INT B disabled
[  312.084262] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  312.084370] ehci_hcd 0000:00:1d.7: PME# disabled
[  312.084520] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[  312.084603] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  312.084684] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  312.084766] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  312.085027] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  312.096850] pci 0000:00:02.0: PCI INT A disabled
[  312.098564] ACPI: Preparing to enter system sleep state S4
[  312.101173] PM: Saving platform NVS memory
[  312.116447] PM: Creating hibernation image: 
[  312.116643] PM: Need to copy 56383 pages
[  312.116643] PM: Normal pages needed: 56383 + 1024 + 14, available pages: 72399
[  312.116643] Intel machine check architecture supported.
[  312.116643] Intel machine check reporting enabled on CPU#0.
[  312.116643] PM: Restoring platform NVS memory
[  312.116643] Force enabled HPET at resume
[  312.116643] ACPI: Waking up from system sleep state S4
[  312.120529] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900003)
[  312.120705] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
[  312.121742] ata_piix 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00001, writing 0x2b00005)
[  312.133553] atl2 0000:03:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100406)
[  312.729236] pci 0000:00:02.0: PME# disabled
[  312.729263] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  312.729280] pci 0000:00:02.0: setting latency timer to 64
[  312.729301] pci 0000:00:02.1: PME# disabled
[  312.729423] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  312.729442] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  312.729687] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  312.729706] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  312.729806] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  312.729824] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  312.729920] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[  312.729937] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  312.730068] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[  312.730085] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[  312.730217] ehci_hcd 0000:00:1d.7: PME# disabled
[  312.730231] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  312.730249] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  312.730269] ehci_hcd 0000:00:1d.7: PME# disabled
[  312.730295] pci 0000:00:1e.0: setting latency timer to 64
[  312.730401] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  312.730415] ata_piix 0000:00:1f.2: setting latency timer to 64
[  312.730764] atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  312.730780] atl2 0000:03:00.0: setting latency timer to 64
[  312.730800] atl2 0000:03:00.0: PME# disabled
[  312.730814] atl2 0000:03:00.0: PME# disabled
[  312.730945] atl2 0000:03:00.0: irq 27 for MSI/MSI-X
[  312.757585] sd 1:0:0:0: [sda] Starting disk
[  312.907139] ata2.00: configured for UDMA/66
[  313.708415] pci 0000:01:00.0: reg 10 64bit mmio: [0x000000-0x00ffff]
[  314.070147] eth0: no IPv6 routers present
[  314.911419] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900003)
[  314.911459] pci 0000:00:02.0: setting latency timer to 64
[  314.998525] Restarting tasks ... done.
[  315.092710] PM: Basic memory bitmaps freed
[  315.267146] cfg80211: Using static regulatory domain info
[  315.267159] cfg80211: Regulatory domain: US
[  315.267166] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  315.267179] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[  315.267190] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  315.267201] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  315.267213] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  315.267224] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  315.267235] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[  315.280693] cfg80211: Calling CRDA for country: US
[  315.726458] ath5k 0000:01:00.0: enabling device (0000 -> 0002)
[  315.726492] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  315.726529] ath5k 0000:01:00.0: setting latency timer to 64
[  315.726715] ath5k 0000:01:00.0: registered as 'phy0'
[  315.800226] ath: Country alpha2 being used: 00
[  315.800234] ath: Regpair detected: 0x60
[  315.897918] phy0: Selected rate control algorithm 'minstrel'
[  315.904391] Registered led device: ath5k-phy0::rx
[  315.904527] Registered led device: ath5k-phy0::tx
[  315.904540] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[  316.157255] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  316.804419] ath5k 0000:01:00.0: PCI INT A disabled
[  316.920306] atl2 0000:03:00.0: irq 27 for MSI/MSI-X
[  316.920726] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  318.701062] pci 0000:01:00.0: reg 10 64bit mmio: [0x000000-0x00ffff]
[  318.701672] ath5k 0000:01:00.0: enabling device (0000 -> 0002)
[  318.701700] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  318.701735] ath5k 0000:01:00.0: setting latency timer to 64
[  318.701896] ath5k 0000:01:00.0: registered as 'phy1'
[  318.775135] ath: Country alpha2 being used: 00
[  318.775143] ath: Regpair detected: 0x60
[  318.787314] phy1: Selected rate control algorithm 'minstrel'
[  318.792051] Registered led device: ath5k-phy1::rx
[  318.792188] Registered led device: ath5k-phy1::tx
[  318.792200] ath5k phy1: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[  319.177256] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  320.281228] ath5k 0000:01:00.0: PCI INT A disabled
[  320.282382] pci 0000:01:00.0: reg 10 64bit mmio: [0x000000-0x00ffff]
[  320.282943] ath5k 0000:01:00.0: enabling device (0000 -> 0002)
[  320.282968] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  320.283003] ath5k 0000:01:00.0: setting latency timer to 64
[  320.283151] ath5k 0000:01:00.0: registered as 'phy2'
[  320.356333] ath: Country alpha2 being used: 00
[  320.356341] ath: Regpair detected: 0x60
[  320.382348] phy2: Selected rate control algorithm 'minstrel'
[  320.386991] Registered led device: ath5k-phy2::rx
[  320.387124] Registered led device: ath5k-phy2::tx
[  320.387136] ath5k phy2: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[  320.740201] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  321.597936] ath5k 0000:01:00.0: PCI INT A disabled
[  321.599197] pci 0000:01:00.0: reg 10 64bit mmio: [0x000000-0x00ffff]
[  321.599766] ath5k 0000:01:00.0: enabling device (0000 -> 0002)
[  321.599791] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  321.599826] ath5k 0000:01:00.0: setting latency timer to 64
[  321.600023] ath5k 0000:01:00.0: registered as 'phy3'
[  321.673525] ath: Country alpha2 being used: 00
[  321.673534] ath: Regpair detected: 0x60
[  321.716407] phy3: Selected rate control algorithm 'minstrel'
[  321.721094] Registered led device: ath5k-phy3::rx
[  321.721232] Registered led device: ath5k-phy3::tx
[  321.721244] ath5k phy3: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[  324.047684] ath5k 0000:01:00.0: PCI INT A disabled
[  325.091125] pci 0000:01:00.0: reg 10 64bit mmio: [0x000000-0x00ffff]
[  325.091730] ath5k 0000:01:00.0: enabling device (0000 -> 0002)
[  325.091758] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  325.091794] ath5k 0000:01:00.0: setting latency timer to 64
[  325.091956] ath5k 0000:01:00.0: registered as 'phy4'
[  325.165244] ath: Country alpha2 being used: 00
[  325.165252] ath: Regpair detected: 0x60
[  325.177300] phy4: Selected rate control algorithm 'minstrel'
[  325.181926] Registered led device: ath5k-phy4::rx
[  325.182062] Registered led device: ath5k-phy4::tx
[  325.182074] ath5k phy4: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[  325.500992] ath5k 0000:01:00.0: PCI INT A disabled
[  327.767729] pci 0000:01:00.0: reg 10 64bit mmio: [0x000000-0x00ffff]
[  327.768341] ath5k 0000:01:00.0: enabling device (0000 -> 0002)
[  327.768368] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  327.768404] ath5k 0000:01:00.0: setting latency timer to 64
[  327.768566] ath5k 0000:01:00.0: registered as 'phy5'
[  327.841866] ath: Country alpha2 being used: 00
[  327.841874] ath: Regpair detected: 0x60
[  327.854883] phy5: Selected rate control algorithm 'minstrel'
[  327.859626] Registered led device: ath5k-phy5::rx
[  327.859765] Registered led device: ath5k-phy5::tx
[  327.859777] ath5k phy5: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[  328.208630] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  329.144320] ath5k phy5: failed to wakeup the MAC Chip
[  329.144339] ath5k phy5: can't reset hardware (-5)
[  329.144619] BUG: workqueue leaked lock or atomic: phy5/0x00000000/3467
[  329.144628]     last function: ieee80211_scan_work+0x0/0x186 [mac80211]
[  329.144688] 1 lock held by phy5/3467:
[  329.144694]  #0:  (&sc->lock){+.+.+.}, at: [<e06f04bd>] ath5k_config+0x24/0x92 [ath5k]
[  329.144745] Pid: 3467, comm: phy5 Not tainted 2.6.30-rc7-wleeepc #50
[  329.144753] Call Trace:
[  329.144774]  [<c013917c>] ? __debug_show_held_locks+0x1e/0x20
[  329.144791]  [<c012bc94>] worker_thread+0x201/0x234
[  329.144837]  [<e042e1b3>] ? ieee80211_scan_work+0x0/0x186 [mac80211]
[  329.144853]  [<c012e369>] ? autoremove_wake_function+0x0/0x30
[  329.144867]  [<c012ba93>] ? worker_thread+0x0/0x234
[  329.144880]  [<c012e2a8>] kthread+0x42/0x6a
[  329.144893]  [<c012e266>] ? kthread+0x0/0x6a
[  329.144909]  [<c01030f7>] kernel_thread_helper+0x7/0x10
[  329.144936] 
[  329.144939] =======================================================
[  329.144947] [ INFO: possible circular locking dependency detected ]
[  329.144956] 2.6.30-rc7-wleeepc #50
[  329.144962] -------------------------------------------------------
[  329.144971] phy5/3467 is trying to acquire lock:
[  329.144979]  ((wiphy_name(local->hw.wiphy))){+.+...}, at: [<c012bbc2>] worker_thread+0x12f/0x234
[  329.144999] 
[  329.145001] but task is already holding lock:
[  329.145009]  (&sc->lock){+.+.+.}, at: [<e06f04bd>] ath5k_config+0x24/0x92 [ath5k]
[  329.145044] 
[  329.145047] which lock already depends on the new lock.
[  329.145051] 
[  329.145057] 
[  329.145060] the existing dependency chain (in reverse order) is:
[  329.145068] 
[  329.145071] -> #3 (&sc->lock){+.+.+.}:
[  329.145085]        [<c013b1a4>] validate_chain+0x7f3/0xa5b
[  329.145100]        [<c013ba8f>] __lock_acquire+0x683/0x6ee
[  329.145114]        [<c013c594>] lock_acquire+0x87/0xa3
[  329.145127]        [<c02fd80a>] mutex_lock_nested+0x26/0x20a
[  329.145146]        [<e06f04bd>] ath5k_config+0x24/0x92 [ath5k]
[  329.145175]        [<e042a07b>] ieee80211_hw_config+0x7b/0x83 [mac80211]
[  329.145221]        [<e0434249>] ieee80211_recalc_idle+0x34/0x39 [mac80211]
[  329.145269]        [<e042dba1>] __ieee80211_start_scan+0xec/0x2f6 [mac80211]
[  329.145314]        [<e042de3c>] ieee80211_request_scan+0x21/0x36 [mac80211]
[  329.145359]        [<e0437056>] ieee80211_scan+0x5a/0x64 [mac80211]
[  329.145406]        [<e038f345>] cfg80211_wext_siwscan+0x183/0x1b1 [cfg80211]
[  329.145449]        [<c02f5968>] ioctl_standard_call+0x1cd/0x261
[  329.145464]        [<c02f552d>] wext_handle_ioctl+0xe2/0x179
[  329.145477]        [<c02aa4d5>] dev_ioctl+0x5b5/0x5ce
[  329.145494]        [<c029d395>] sock_ioctl+0x1eb/0x1f7
[  329.145509]        [<c01889f9>] vfs_ioctl+0x19/0x4f
[  329.145523]        [<c0188f61>] do_vfs_ioctl+0x450/0x482
[  329.145536]        [<c0188fbf>] sys_ioctl+0x2c/0x45
[  329.145549]        [<c0102894>] sysenter_do_call+0x12/0x32
[  329.145562]        [<ffffffff>] 0xffffffff
[  329.145590] 
[  329.145593] -> #2 (&local->scan_mtx){+.+.+.}:
[  329.145607]        [<c013b1a4>] validate_chain+0x7f3/0xa5b
[  329.145621]        [<c013ba8f>] __lock_acquire+0x683/0x6ee
[  329.145635]        [<c013c594>] lock_acquire+0x87/0xa3
[  329.145648]        [<c02fd80a>] mutex_lock_nested+0x26/0x20a
[  329.145664]        [<e042e1da>] ieee80211_scan_work+0x27/0x186 [mac80211]
[  329.145711]        [<c012bbfe>] worker_thread+0x16b/0x234
[  329.145724]        [<c012e2a8>] kthread+0x42/0x6a
[  329.145738]        [<c01030f7>] kernel_thread_helper+0x7/0x10
[  329.145752]        [<ffffffff>] 0xffffffff
[  329.145771] 
[  329.145774] -> #1 (&(&local->scan_work)->work){+.+...}:
[  329.145788]        [<c013b1a4>] validate_chain+0x7f3/0xa5b
[  329.145802]        [<c013ba8f>] __lock_acquire+0x683/0x6ee
[  329.145815]        [<c013c594>] lock_acquire+0x87/0xa3
[  329.145829]        [<c012bbf9>] worker_thread+0x166/0x234
[  329.145842]        [<c012e2a8>] kthread+0x42/0x6a
[  329.145855]        [<c01030f7>] kernel_thread_helper+0x7/0x10
[  329.145869]        [<ffffffff>] 0xffffffff
[  329.145893] 
[  329.145896] -> #0 ((wiphy_name(local->hw.wiphy))){+.+...}:
[  329.145910]        [<c013af41>] validate_chain+0x590/0xa5b
[  329.145924]        [<c013ba8f>] __lock_acquire+0x683/0x6ee
[  329.145937]        [<c013c594>] lock_acquire+0x87/0xa3
[  329.145951]        [<c012bbdf>] worker_thread+0x14c/0x234
[  329.145964]        [<c012e2a8>] kthread+0x42/0x6a
[  329.145977]        [<c01030f7>] kernel_thread_helper+0x7/0x10
[  329.145991]        [<ffffffff>] 0xffffffff
[  329.146005] 
[  329.146007] other info that might help us debug this:
[  329.146012] 
[  329.146020] 1 lock held by phy5/3467:
[  329.146027]  #0:  (&sc->lock){+.+.+.}, at: [<e06f04bd>] ath5k_config+0x24/0x92 [ath5k]
[  329.146065] 
[  329.146067] stack backtrace:
[  329.146077] Pid: 3467, comm: phy5 Not tainted 2.6.30-rc7-wleeepc #50
[  329.146085] Call Trace:
[  329.146097]  [<c013a8cc>] print_circular_bug_tail+0xa0/0xab
[  329.146112]  [<c013af41>] validate_chain+0x590/0xa5b
[  329.146126]  [<c013ba8f>] __lock_acquire+0x683/0x6ee
[  329.146141]  [<c013c594>] lock_acquire+0x87/0xa3
[  329.146154]  [<c012bbc2>] ? worker_thread+0x12f/0x234
[  329.146167]  [<c012bbdf>] worker_thread+0x14c/0x234
[  329.146181]  [<c012bbc2>] ? worker_thread+0x12f/0x234
[  329.146226]  [<e042e1b3>] ? ieee80211_scan_work+0x0/0x186 [mac80211]
[  329.146241]  [<c012e369>] ? autoremove_wake_function+0x0/0x30
[  329.146255]  [<c012ba93>] ? worker_thread+0x0/0x234
[  329.146268]  [<c012e2a8>] kthread+0x42/0x6a
[  329.146281]  [<c012e266>] ? kthread+0x0/0x6a
[  329.146294]  [<c01030f7>] kernel_thread_helper+0x7/0x10
[  338.316580] ath5k phy5: noise floor calibration timeout (2427MHz)
[  346.106823] usb 5-5: reset high speed USB device using ehci_hcd and address 2
[  349.315427] ath5k phy5: noise floor calibration timeout (2427MHz)
[  360.315118] ath5k phy5: noise floor calibration timeout (2427MHz)
[  371.315112] ath5k phy5: noise floor calibration timeout (2427MHz)
[  382.315112] ath5k phy5: noise floor calibration timeout (2427MHz)
[  393.315111] ath5k phy5: noise floor calibration timeout (2427MHz)
[  404.315107] ath5k phy5: noise floor calibration timeout (2427MHz)
[  415.315107] ath5k phy5: noise floor calibration timeout (2427MHz)
[  426.315104] ath5k phy5: noise floor calibration timeout (2427MHz)
[  437.315102] ath5k phy5: noise floor calibration timeout (2427MHz)
[  448.315101] ath5k phy5: noise floor calibration timeout (2427MHz)
[  459.315099] ath5k phy5: noise floor calibration timeout (2427MHz)
[  470.315090] ath5k phy5: noise floor calibration timeout (2427MHz)
[  480.746809] INFO: task kacpi_notify:82 blocked for more than 120 seconds.
[  480.746823] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.746833] kacpi_notify  D df01d140     0    82      2
[  480.746849]  df163d14 00000046 df159140 df01d140 a3112f1b 0000004c a32286df 0000004c
[  480.746878]  df1593c4 df351d40 d9995634 001157c4 00000000 a32286df 0000004c 00000000
[  480.746906]  00000000 df163de8 7fffffff 00000000 df163d1c c02fcfdc df163d78 c02fd0b1
[  480.746933] Call Trace:
[  480.746960]  [<c02fcfdc>] schedule+0x8/0x17
[  480.746975]  [<c02fd0b1>] schedule_timeout+0x17/0x115
[  480.746990]  [<c02fca53>] ? wait_for_common+0x1b/0xf9
[  480.747008]  [<c0139b5f>] ? trace_hardirqs_on+0xb/0xd
[  480.747022]  [<c02fcae2>] wait_for_common+0xaa/0xf9
[  480.747037]  [<c0117fe0>] ? default_wake_function+0x0/0xd
[  480.747052]  [<c02fcbb3>] wait_for_completion+0x12/0x14
[  480.747067]  [<c012b86a>] __cancel_work_timer+0xf6/0x129
[  480.747081]  [<c012b50c>] ? wq_barrier_func+0x0/0xd
[  480.747095]  [<c012b8a8>] cancel_delayed_work_sync+0xb/0xd
[  480.747152]  [<e0435377>] ieee80211_stop+0x3ba/0x48f [mac80211]
[  480.747166]  [<c02febb8>] ? _spin_unlock_bh+0x25/0x28
[  480.747183]  [<c02b5f34>] ? dev_deactivate+0x11f/0x141
[  480.747200]  [<c02a94b3>] dev_close+0x5d/0x79
[  480.747213]  [<c02a953f>] rollback_registered+0x70/0xe0
[  480.747226]  [<c02a95e1>] unregister_netdevice+0x32/0x5a
[  480.747273]  [<e04342c8>] ieee80211_remove_interfaces+0x7a/0x89 [mac80211]
[  480.747318]  [<e042aa77>] ieee80211_unregister_hw+0x38/0xd0 [mac80211]
[  480.747351]  [<e06f1da8>] ath5k_pci_remove+0x18/0x7e [ath5k]
[  480.747366]  [<c021330c>] pci_device_remove+0x19/0x39
[  480.747381]  [<c025d517>] __device_release_driver+0x47/0x64
[  480.747395]  [<c025d5d1>] device_release_driver+0x18/0x23
[  480.747409]  [<c025caca>] bus_remove_device+0x67/0x73
[  480.747422]  [<c025b6a6>] device_del+0xf0/0x127
[  480.747434]  [<c025b6e8>] device_unregister+0xb/0x15
[  480.747449]  [<c020f387>] pci_stop_dev+0x23/0x3d
[  480.747462]  [<c020f3ce>] pci_stop_bus_device+0x2d/0x32
[  480.747476]  [<c020f446>] pci_remove_bus_device+0xc/0x94
[  480.747511]  [<e00f2542>] eeepc_rfkill_notify+0x95/0xb7 [eeepc_laptop]
[  480.747530]  [<c022e5ce>] acpi_ev_notify_dispatch+0x4c/0x57
[  480.747546]  [<c0220e9a>] acpi_os_execute_deferred+0x20/0x2c
[  480.747560]  [<c012bbfe>] worker_thread+0x16b/0x234
[  480.747573]  [<c012bbc2>] ? worker_thread+0x12f/0x234
[  480.747587]  [<c0220e7a>] ? acpi_os_execute_deferred+0x0/0x2c
[  480.747602]  [<c012e369>] ? autoremove_wake_function+0x0/0x30
[  480.747616]  [<c012ba93>] ? worker_thread+0x0/0x234
[  480.747629]  [<c012e2a8>] kthread+0x42/0x6a
[  480.747642]  [<c012e266>] ? kthread+0x0/0x6a
[  480.747657]  [<c01030f7>] kernel_thread_helper+0x7/0x10
[  480.747666] INFO: lockdep is turned off.
[  480.747693] INFO: task NetworkManager:3502 blocked for more than 120 seconds.
[  480.747702] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.747711] NetworkManage D 00000000     0  3502      1
[  480.747725]  d249de34 00000046 d9b64500 00000000 00000000 d249de24 e471a912 0000004e
[  480.747753]  d9b64784 df2ab8c0 00000000 c02b1798 c04387f4 00008b19 c04387c0 d249ded8
[  480.747780]  d249de44 d249de44 c04387c0 00000202 d249de60 c02fd904 c04387c4 d9b64500
[  480.747807] Call Trace:
[  480.747821]  [<c02b1798>] ? rtnl_lock+0xf/0x11
[  480.747837]  [<c02fd904>] mutex_lock_nested+0x120/0x20a
[  480.747850]  [<c02b1798>] rtnl_lock+0xf/0x11
[  480.747863]  [<c02f55a4>] wext_handle_ioctl+0x159/0x179
[  480.747878]  [<c02aa4d5>] dev_ioctl+0x5b5/0x5ce
[  480.747896]  [<c01a0557>] ? inotify_d_instantiate+0x15/0x3c
[  480.747914]  [<c017d08b>] ? fd_install+0x23/0x50
[  480.747928]  [<c029d1aa>] ? sock_ioctl+0x0/0x1f7
[  480.747940]  [<c029d395>] sock_ioctl+0x1eb/0x1f7
[  480.747953]  [<c029d1aa>] ? sock_ioctl+0x0/0x1f7
[  480.747967]  [<c01889f9>] vfs_ioctl+0x19/0x4f
[  480.747979]  [<c0188f61>] do_vfs_ioctl+0x450/0x482
[  480.747993]  [<c017f829>] ? fget_light+0x37/0xb0
[  480.748006]  [<c0188fbf>] sys_ioctl+0x2c/0x45
[  480.748019]  [<c0102894>] sysenter_do_call+0x12/0x32
[  480.748028] INFO: lockdep is turned off.
[  480.748071] INFO: task phy5:3467 blocked for more than 120 seconds.
[  480.748079] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  480.748088] phy5          D 00000000     0  3467      2
[  480.748102]  d2531f0c 00000046 d245d640 00000000 00000000 d2531efc a2a60e73 0000004c
[  480.748129]  d245d8c4 df0c3680 00000000 e06f04bd d25f0bbc d25f0b80 d25f0b88 d98da000
[  480.748156]  d2531f1c d2531f1c d25f0b88 00000202 d2531f38 c02fd904 d25f0b8c d245d640
[  480.748183] Call Trace:
[  480.748213]  [<e06f04bd>] ? ath5k_config+0x24/0x92 [ath5k]
[  480.748230]  [<c02fd904>] mutex_lock_nested+0x120/0x20a
[  480.748259]  [<e06f04bd>] ath5k_config+0x24/0x92 [ath5k]
[  480.748305]  [<e042a07b>] ieee80211_hw_config+0x7b/0x83 [mac80211]
[  480.748351]  [<e042e2ad>] ieee80211_scan_work+0xfa/0x186 [mac80211]
[  480.748365]  [<c012bbfe>] worker_thread+0x16b/0x234
[  480.748378]  [<c012bbc2>] ? worker_thread+0x12f/0x234
[  480.748423]  [<e042e1b3>] ? ieee80211_scan_work+0x0/0x186 [mac80211]
[  480.748438]  [<c012e369>] ? autoremove_wake_function+0x0/0x30
[  480.748452]  [<c012ba93>] ? worker_thread+0x0/0x234
[  480.748465]  [<c012e2a8>] kthread+0x42/0x6a
[  480.748478]  [<c012e266>] ? kthread+0x0/0x6a
[  480.748491]  [<c01030f7>] kernel_thread_helper+0x7/0x10
[  480.748499] INFO: lockdep is turned off.
[  481.315101] ath5k phy5: noise floor calibration timeout (2427MHz)
[  492.315097] ath5k phy5: noise floor calibration timeout (2427MHz)
[  503.315100] ath5k phy5: noise floor calibration timeout (2427MHz)
[  514.315095] ath5k phy5: noise floor calibration timeout (2427MHz)
[  525.315094] ath5k phy5: noise floor calibration timeout (2427MHz)
[  536.315092] ath5k phy5: noise floor calibration timeout (2427MHz)
[  547.315091] ath5k phy5: noise floor calibration timeout (2427MHz)
[  558.315091] ath5k phy5: noise floor calibration timeout (2427MHz)
[  569.315104] ath5k phy5: noise floor calibration timeout (2427MHz)
[  580.315092] ath5k phy5: noise floor calibration timeout (2427MHz)
[  591.315095] ath5k phy5: noise floor calibration timeout (2427MHz)
[  600.746796] INFO: task kacpi_notify:82 blocked for more than 120 seconds.
[  600.746809] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.746819] kacpi_notify  D df01d140     0    82      2
[  600.746836]  df163d14 00000046 df159140 df01d140 a3112f1b 0000004c a32286df 0000004c
[  600.746865]  df1593c4 df351d40 d9995634 001157c4 00000000 a32286df 0000004c 00000000
[  600.746892]  00000000 df163de8 7fffffff 00000000 df163d1c c02fcfdc df163d78 c02fd0b1
[  600.746920] Call Trace:
[  600.746947]  [<c02fcfdc>] schedule+0x8/0x17
[  600.746962]  [<c02fd0b1>] schedule_timeout+0x17/0x115
[  600.746977]  [<c02fca53>] ? wait_for_common+0x1b/0xf9
[  600.746994]  [<c0139b5f>] ? trace_hardirqs_on+0xb/0xd
[  600.747008]  [<c02fcae2>] wait_for_common+0xaa/0xf9
[  600.747024]  [<c0117fe0>] ? default_wake_function+0x0/0xd
[  600.747038]  [<c02fcbb3>] wait_for_completion+0x12/0x14
[  600.747053]  [<c012b86a>] __cancel_work_timer+0xf6/0x129
[  600.747067]  [<c012b50c>] ? wq_barrier_func+0x0/0xd
[  600.747081]  [<c012b8a8>] cancel_delayed_work_sync+0xb/0xd
[  600.747138]  [<e0435377>] ieee80211_stop+0x3ba/0x48f [mac80211]
[  600.747152]  [<c02febb8>] ? _spin_unlock_bh+0x25/0x28
[  600.747170]  [<c02b5f34>] ? dev_deactivate+0x11f/0x141
[  600.747186]  [<c02a94b3>] dev_close+0x5d/0x79
[  600.747199]  [<c02a953f>] rollback_registered+0x70/0xe0
[  600.747212]  [<c02a95e1>] unregister_netdevice+0x32/0x5a
[  600.747259]  [<e04342c8>] ieee80211_remove_interfaces+0x7a/0x89 [mac80211]
[  600.747304]  [<e042aa77>] ieee80211_unregister_hw+0x38/0xd0 [mac80211]
[  600.747337]  [<e06f1da8>] ath5k_pci_remove+0x18/0x7e [ath5k]
[  600.747352]  [<c021330c>] pci_device_remove+0x19/0x39
[  600.747367]  [<c025d517>] __device_release_driver+0x47/0x64
[  600.747381]  [<c025d5d1>] device_release_driver+0x18/0x23
[  600.747395]  [<c025caca>] bus_remove_device+0x67/0x73
[  600.747408]  [<c025b6a6>] device_del+0xf0/0x127
[  600.747420]  [<c025b6e8>] device_unregister+0xb/0x15
[  600.747436]  [<c020f387>] pci_stop_dev+0x23/0x3d
[  600.747449]  [<c020f3ce>] pci_stop_bus_device+0x2d/0x32
[  600.747462]  [<c020f446>] pci_remove_bus_device+0xc/0x94
[  600.747497]  [<e00f2542>] eeepc_rfkill_notify+0x95/0xb7 [eeepc_laptop]
[  600.747516]  [<c022e5ce>] acpi_ev_notify_dispatch+0x4c/0x57
[  600.747532]  [<c0220e9a>] acpi_os_execute_deferred+0x20/0x2c
[  600.747546]  [<c012bbfe>] worker_thread+0x16b/0x234
[  600.747559]  [<c012bbc2>] ? worker_thread+0x12f/0x234
[  600.747573]  [<c0220e7a>] ? acpi_os_execute_deferred+0x0/0x2c
[  600.747589]  [<c012e369>] ? autoremove_wake_function+0x0/0x30
[  600.747602]  [<c012ba93>] ? worker_thread+0x0/0x234
[  600.747615]  [<c012e2a8>] kthread+0x42/0x6a
[  600.747628]  [<c012e266>] ? kthread+0x0/0x6a
[  600.747643]  [<c01030f7>] kernel_thread_helper+0x7/0x10
[  600.747652] INFO: lockdep is turned off.
[  600.747678] INFO: task NetworkManager:3502 blocked for more than 120 seconds.
[  600.747687] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.747696] NetworkManage D 00000000     0  3502      1
[  600.747710]  d249de34 00000046 d9b64500 00000000 00000000 d249de24 e471a912 0000004e
[  600.747738]  d9b64784 df2ab8c0 00000000 c02b1798 c04387f4 00008b19 c04387c0 d249ded8
[  600.747765]  d249de44 d249de44 c04387c0 00000202 d249de60 c02fd904 c04387c4 d9b64500
[  600.747792] Call Trace:
[  600.747806]  [<c02b1798>] ? rtnl_lock+0xf/0x11
[  600.747822]  [<c02fd904>] mutex_lock_nested+0x120/0x20a
[  600.747835]  [<c02b1798>] rtnl_lock+0xf/0x11
[  600.747848]  [<c02f55a4>] wext_handle_ioctl+0x159/0x179
[  600.747863]  [<c02aa4d5>] dev_ioctl+0x5b5/0x5ce
[  600.747881]  [<c01a0557>] ? inotify_d_instantiate+0x15/0x3c
[  600.747898]  [<c017d08b>] ? fd_install+0x23/0x50
[  600.747912]  [<c029d1aa>] ? sock_ioctl+0x0/0x1f7
[  600.747925]  [<c029d395>] sock_ioctl+0x1eb/0x1f7
[  600.747937]  [<c029d1aa>] ? sock_ioctl+0x0/0x1f7
[  600.747951]  [<c01889f9>] vfs_ioctl+0x19/0x4f
[  600.747964]  [<c0188f61>] do_vfs_ioctl+0x450/0x482
[  600.747977]  [<c017f829>] ? fget_light+0x37/0xb0
[  600.747991]  [<c0188fbf>] sys_ioctl+0x2c/0x45
[  600.748004]  [<c0102894>] sysenter_do_call+0x12/0x32
[  600.748012] INFO: lockdep is turned off.
[  600.748055] INFO: task phy5:3467 blocked for more than 120 seconds.
[  600.748063] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  600.748072] phy5          D 00000000     0  3467      2
[  600.748087]  d2531f0c 00000046 d245d640 00000000 00000000 d2531efc a2a60e73 0000004c
[  600.748114]  d245d8c4 df0c3680 00000000 e06f04bd d25f0bbc d25f0b80 d25f0b88 d98da000
[  600.748141]  d2531f1c d2531f1c d25f0b88 00000202 d2531f38 c02fd904 d25f0b8c d245d640
[  600.748168] Call Trace:
[  600.748198]  [<e06f04bd>] ? ath5k_config+0x24/0x92 [ath5k]
[  600.748214]  [<c02fd904>] mutex_lock_nested+0x120/0x20a
[  600.748244]  [<e06f04bd>] ath5k_config+0x24/0x92 [ath5k]
[  600.748289]  [<e042a07b>] ieee80211_hw_config+0x7b/0x83 [mac80211]
[  600.748336]  [<e042e2ad>] ieee80211_scan_work+0xfa/0x186 [mac80211]
[  600.748350]  [<c012bbfe>] worker_thread+0x16b/0x234
[  600.748363]  [<c012bbc2>] ? worker_thread+0x12f/0x234
[  600.748408]  [<e042e1b3>] ? ieee80211_scan_work+0x0/0x186 [mac80211]
[  600.748423]  [<c012e369>] ? autoremove_wake_function+0x0/0x30
[  600.748437]  [<c012ba93>] ? worker_thread+0x0/0x234
[  600.748450]  [<c012e2a8>] kthread+0x42/0x6a
[  600.748463]  [<c012e266>] ? kthread+0x0/0x6a
[  600.748476]  [<c01030f7>] kernel_thread_helper+0x7/0x10
[  600.748484] INFO: lockdep is turned off.
[  602.315090] ath5k phy5: noise floor calibration timeout (2427MHz)
[  613.315088] ath5k phy5: noise floor calibration timeout (2427MHz)
[  624.315084] ath5k phy5: noise floor calibration timeout (2427MHz)
[  635.315082] ath5k phy5: noise floor calibration timeout (2427MHz)
[  646.315145] ath5k phy5: noise floor calibration timeout (2427MHz)
[  657.315131] ath5k phy5: noise floor calibration timeout (2427MHz)
[  668.315175] ath5k phy5: noise floor calibration timeout (2427MHz)
[  679.315066] ath5k phy5: noise floor calibration timeout (2427MHz)
[  690.315190] ath5k phy5: noise floor calibration timeout (2427MHz)
[  701.315282] ath5k phy5: noise floor calibration timeout (2427MHz)
[  712.315068] ath5k phy5: noise floor calibration timeout (2427MHz)
[  720.746642] INFO: task kacpi_notify:82 blocked for more than 120 seconds.
[  720.746655] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.746666] kacpi_notify  D df01d140     0    82      2
[  720.746682]  df163d14 00000046 df159140 df01d140 a3112f1b 0000004c a32286df 0000004c
[  720.746711]  df1593c4 df351d40 d9995634 001157c4 00000000 a32286df 0000004c 00000000
[  720.746739]  00000000 df163de8 7fffffff 00000000 df163d1c c02fcfdc df163d78 c02fd0b1
[  720.746766] Call Trace:
[  720.746793]  [<c02fcfdc>] schedule+0x8/0x17
[  720.746808]  [<c02fd0b1>] schedule_timeout+0x17/0x115
[  720.746823]  [<c02fca53>] ? wait_for_common+0x1b/0xf9
[  720.746840]  [<c0139b5f>] ? trace_hardirqs_on+0xb/0xd
[  720.746854]  [<c02fcae2>] wait_for_common+0xaa/0xf9
[  720.746869]  [<c0117fe0>] ? default_wake_function+0x0/0xd
[  720.746884]  [<c02fcbb3>] wait_for_completion+0x12/0x14
[  720.746898]  [<c012b86a>] __cancel_work_timer+0xf6/0x129
[  720.746912]  [<c012b50c>] ? wq_barrier_func+0x0/0xd
[  720.746926]  [<c012b8a8>] cancel_delayed_work_sync+0xb/0xd
[  720.746983]  [<e0435377>] ieee80211_stop+0x3ba/0x48f [mac80211]
[  720.746997]  [<c02febb8>] ? _spin_unlock_bh+0x25/0x28
[  720.747015]  [<c02b5f34>] ? dev_deactivate+0x11f/0x141
[  720.747031]  [<c02a94b3>] dev_close+0x5d/0x79
[  720.747045]  [<c02a953f>] rollback_registered+0x70/0xe0
[  720.747058]  [<c02a95e1>] unregister_netdevice+0x32/0x5a
[  720.747105]  [<e04342c8>] ieee80211_remove_interfaces+0x7a/0x89 [mac80211]
[  720.747149]  [<e042aa77>] ieee80211_unregister_hw+0x38/0xd0 [mac80211]
[  720.747182]  [<e06f1da8>] ath5k_pci_remove+0x18/0x7e [ath5k]
[  720.747197]  [<c021330c>] pci_device_remove+0x19/0x39
[  720.747212]  [<c025d517>] __device_release_driver+0x47/0x64
[  720.747226]  [<c025d5d1>] device_release_driver+0x18/0x23
[  720.747240]  [<c025caca>] bus_remove_device+0x67/0x73
[  720.747253]  [<c025b6a6>] device_del+0xf0/0x127
[  720.747265]  [<c025b6e8>] device_unregister+0xb/0x15
[  720.747280]  [<c020f387>] pci_stop_dev+0x23/0x3d
[  720.747293]  [<c020f3ce>] pci_stop_bus_device+0x2d/0x32
[  720.747307]  [<c020f446>] pci_remove_bus_device+0xc/0x94
[  720.747342]  [<e00f2542>] eeepc_rfkill_notify+0x95/0xb7 [eeepc_laptop]
[  720.747360]  [<c022e5ce>] acpi_ev_notify_dispatch+0x4c/0x57
[  720.747376]  [<c0220e9a>] acpi_os_execute_deferred+0x20/0x2c
[  720.747390]  [<c012bbfe>] worker_thread+0x16b/0x234
[  720.747403]  [<c012bbc2>] ? worker_thread+0x12f/0x234
[  720.747417]  [<c0220e7a>] ? acpi_os_execute_deferred+0x0/0x2c
[  720.747432]  [<c012e369>] ? autoremove_wake_function+0x0/0x30
[  720.747446]  [<c012ba93>] ? worker_thread+0x0/0x234
[  720.747459]  [<c012e2a8>] kthread+0x42/0x6a
[  720.747472]  [<c012e266>] ? kthread+0x0/0x6a
[  720.747486]  [<c01030f7>] kernel_thread_helper+0x7/0x10
[  720.747495] INFO: lockdep is turned off.
[  720.747522] INFO: task NetworkManager:3502 blocked for more than 120 seconds.
[  720.747531] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.747540] NetworkManage D 00000000     0  3502      1
[  720.747554]  d249de34 00000046 d9b64500 00000000 00000000 d249de24 e471a912 0000004e
[  720.747582]  d9b64784 df2ab8c0 00000000 c02b1798 c04387f4 00008b19 c04387c0 d249ded8
[  720.747609]  d249de44 d249de44 c04387c0 00000202 d249de60 c02fd904 c04387c4 d9b64500
[  720.747636] Call Trace:
[  720.747650]  [<c02b1798>] ? rtnl_lock+0xf/0x11
[  720.747666]  [<c02fd904>] mutex_lock_nested+0x120/0x20a
[  720.747679]  [<c02b1798>] rtnl_lock+0xf/0x11
[  720.747692]  [<c02f55a4>] wext_handle_ioctl+0x159/0x179
[  720.747707]  [<c02aa4d5>] dev_ioctl+0x5b5/0x5ce
[  720.747724]  [<c01a0557>] ? inotify_d_instantiate+0x15/0x3c
[  720.747742]  [<c017d08b>] ? fd_install+0x23/0x50
[  720.747756]  [<c029d1aa>] ? sock_ioctl+0x0/0x1f7
[  720.747778]  [<c029d395>] sock_ioctl+0x1eb/0x1f7
[  720.747790]  [<c029d1aa>] ? sock_ioctl+0x0/0x1f7
[  720.747804]  [<c01889f9>] vfs_ioctl+0x19/0x4f
[  720.747817]  [<c0188f61>] do_vfs_ioctl+0x450/0x482
[  720.747831]  [<c017f829>] ? fget_light+0x37/0xb0
[  720.747844]  [<c0188fbf>] sys_ioctl+0x2c/0x45
[  720.747857]  [<c0102894>] sysenter_do_call+0x12/0x32
[  720.747866] INFO: lockdep is turned off.
[  720.747909] INFO: task phy5:3467 blocked for more than 120 seconds.
[  720.747917] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.747927] phy5          D 00000000     0  3467      2
[  720.747941]  d2531f0c 00000046 d245d640 00000000 00000000 d2531efc a2a60e73 0000004c
[  720.747968]  d245d8c4 df0c3680 00000000 e06f04bd d25f0bbc d25f0b80 d25f0b88 d98da000
[  720.747995]  d2531f1c d2531f1c d25f0b88 00000202 d2531f38 c02fd904 d25f0b8c d245d640
[  720.748022] Call Trace:
[  720.748052]  [<e06f04bd>] ? ath5k_config+0x24/0x92 [ath5k]
[  720.748068]  [<c02fd904>] mutex_lock_nested+0x120/0x20a
[  720.748098]  [<e06f04bd>] ath5k_config+0x24/0x92 [ath5k]
[  720.748143]  [<e042a07b>] ieee80211_hw_config+0x7b/0x83 [mac80211]
[  720.748189]  [<e042e2ad>] ieee80211_scan_work+0xfa/0x186 [mac80211]
[  720.748204]  [<c012bbfe>] worker_thread+0x16b/0x234
[  720.748217]  [<c012bbc2>] ? worker_thread+0x12f/0x234
[  720.748262]  [<e042e1b3>] ? ieee80211_scan_work+0x0/0x186 [mac80211]
[  720.748277]  [<c012e369>] ? autoremove_wake_function+0x0/0x30
[  720.748291]  [<c012ba93>] ? worker_thread+0x0/0x234
[  720.748304]  [<c012e2a8>] kthread+0x42/0x6a
[  720.748317]  [<c012e266>] ? kthread+0x0/0x6a
[  720.748330]  [<c01030f7>] kernel_thread_helper+0x7/0x10
[  720.748338] INFO: lockdep is turned off.
[  723.315732] ath5k phy5: noise floor calibration timeout (2427MHz)

--------------070505030603010005070904--

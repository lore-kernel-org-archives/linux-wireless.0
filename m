Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:40447 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbZIQRZ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:25:56 -0400
Received: by fxm17 with SMTP id 17so192737fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2009 10:25:58 -0700 (PDT)
Subject: regression?  No connection with master-2009-09-16 was fine until
 master-2009-09-14
From: ASIC Felix <ic.felix@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 10:25:48 -0700
Message-Id: <1253208348.6601.17.camel@darkslate>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

with master-2009-09-16 my laptop can no longer connect to the network.
I can see all the APs, but can't connect.
The issue is new, w-t kernel master-2009-09-14 was fine.

Sorry for pasting the whole /var/log/messages from boot to boot,
but I see anything obvious by myself.

Best regards,
Felix

H/W: IBM Thinkpad T43, Atheros MB92

# uname -a
Linux darkslate 2.6.31-wl-mnbStrip-38258-g389ce02 #81 SMP Thu Sep 17 09:01:37 PDT 2009 i686 Intel(R) Pentium(R) M processor 1.73GHz GNU/Linux

]# dmesg -c ; date
ath9k: Two wiphys trying to scan at the same time
ath9k: Two wiphys trying to scan at the same time
ath9k: Two wiphys trying to scan at the same time
ath9k: Two wiphys trying to scan at the same time
Thu Sep 17 09:45:27 PDT 2009

from initial dmesg:

[...]
ath9k 0000:04:02.0: enabling device (0000 -> 0002)
ath9k 0000:04:02.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
phy0: Selected rate control algorithm 'ath9k_rate_control'
cfg80211: Calling CRDA for country: US
Registered led device: ath9k-phy0::radio
Registered led device: ath9k-phy0::assoc
Registered led device: ath9k-phy0::tx
Registered led device: ath9k-phy0::rx
phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: mem=0xf85a0000, irq=21
cfg80211: Regulatory domain changed to country: US
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
	(5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
	(5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[...]
tg3 0000:02:00.0: PME# disabled
NET: Registered protocol family 17
Clocksource tsc unstable (delta = -160797349 ns)
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16238 buckets, 64952 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ath9k: Two wiphys trying to scan at the same time
ctnetlink v0.93: registering with nfnetlink.
xt_time: kernel timezone is -0700
ath9k: Two wiphys trying to scan at the same time
ath9k: Two wiphys trying to scan at the same time
ath9k: Two wiphys trying to scan at the same time
ath9k: Two wiphys trying to scan at the same time
ath9k: Two wiphys trying to scan at the same time
ath9k: Two wiphys trying to scan at the same time
ath9k: Two wiphys trying to scan at the same time
ath9k: Two wiphys trying to scan at the same time
ath9k: Two wiphys trying to scan at the same time

from var/log/messages:

Sep 17 09:39:14 darkslate syslogd 1.5.0: restart.
Sep 17 09:39:14 darkslate klogd: klogd 1.5.0, log source = /proc/kmsg started.
Sep 17 09:39:14 darkslate klogd: Linux version 2.6.31-wl-mnbStrip-38258-g389ce02 (me@darkslate) (gcc version 4.3.2 (GCC) ) #81 SMP Thu Sep 17 09:01:37 PDT 2009
Sep 17 09:39:14 darkslate klogd: KERNEL supported cpus:
Sep 17 09:39:14 darkslate klogd:   Intel GenuineIntel
Sep 17 09:39:14 darkslate klogd:   AMD AuthenticAMD
Sep 17 09:39:14 darkslate klogd:   NSC Geode by NSC
Sep 17 09:39:14 darkslate klogd:   Cyrix CyrixInstead
Sep 17 09:39:14 darkslate klogd:   Centaur CentaurHauls
Sep 17 09:39:14 darkslate klogd:   Transmeta GenuineTMx86
Sep 17 09:39:14 darkslate klogd:   Transmeta TransmetaCPU
Sep 17 09:39:14 darkslate klogd:   UMC UMC UMC UMC
Sep 17 09:39:14 darkslate klogd: BIOS-provided physical RAM map:
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 00000000000d0000 - 00000000000d4000 (reserved)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 0000000000100000 - 000000003f6e0000 (usable)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 000000003f6e0000 - 000000003f6f5000 (ACPI data)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 000000003f6f5000 - 000000003f700000 (ACPI NVS)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 000000003f700000 - 0000000040000000 (reserved)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 00000000f0008000 - 00000000f000c000 (reserved)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Sep 17 09:39:14 darkslate klogd:  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
Sep 17 09:39:14 darkslate klogd: DMI present.
Sep 17 09:39:14 darkslate klogd: last_pfn = 0x3f6e0 max_arch_pfn = 0x100000
Sep 17 09:39:14 darkslate klogd: PAT not supported by CPU.
Sep 17 09:39:14 darkslate klogd: init_memory_mapping: 0000000000000000-00000000377fe000
Sep 17 09:39:14 darkslate klogd: RAMDISK: 37c71000 - 37fef5c0
Sep 17 09:39:14 darkslate klogd: Allocated new RAMDISK: 005e2000 - 009605c0
Sep 17 09:39:14 darkslate klogd: Move RAMDISK from 0000000037c71000 - 0000000037fef5bf to 005e2000 - 009605bf
Sep 17 09:39:14 darkslate klogd: ACPI: RSDP 000f6b90 00024 (v02 IBM   )
Sep 17 09:39:14 darkslate klogd: ACPI: XSDT 3f6e7352 0005C (v01 IBM    TP-70    00001290  LTP 00000000)
Sep 17 09:39:14 darkslate klogd: ACPI: FACP 3f6e7400 000F4 (v03 IBM    TP-70    00001290 IBM  00000001)
Sep 17 09:39:14 darkslate klogd: ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 20090521 tbfadt-527
Sep 17 09:39:14 darkslate klogd: ACPI Warning: Optional field Gpe1Block has zero address or length: 000000000000102C/0 20090521 tbfadt-558
Sep 17 09:39:14 darkslate klogd: ACPI: DSDT 3f6e75e7 0D7A8 (v01 IBM    TP-70    00001290 MSFT 0100000E)
Sep 17 09:39:14 darkslate klogd: ACPI: FACS 3f6f6000 00040
Sep 17 09:39:14 darkslate klogd: ACPI: SSDT 3f6e75b4 00033 (v01 IBM    TP-70    00001290 MSFT 0100000E)
Sep 17 09:39:14 darkslate klogd: ACPI: ECDT 3f6f4d8f 00052 (v01 IBM    TP-70    00001290 IBM  00000001)
Sep 17 09:39:14 darkslate klogd: ACPI: TCPA 3f6f4de1 00032 (v01 IBM    TP-70    00001290 PTL  00000001)
Sep 17 09:39:14 darkslate klogd: ACPI: APIC 3f6f4e13 0005A (v01 IBM    TP-70    00001290 IBM  00000001)
Sep 17 09:39:14 darkslate klogd: ACPI: MCFG 3f6f4e6d 0003E (v01 IBM    TP-70    00001290 IBM  00000001)
Sep 17 09:39:14 darkslate klogd: ACPI: BOOT 3f6f4fd8 00028 (v01 IBM    TP-70    00001290  LTP 00000001)
Sep 17 09:39:14 darkslate klogd: 126MB HIGHMEM available.
Sep 17 09:39:14 darkslate klogd: 887MB LOWMEM available.
Sep 17 09:39:14 darkslate klogd:   mapped low ram: 0 - 377fe000
Sep 17 09:39:14 darkslate klogd:   low ram: 0 - 377fe000
Sep 17 09:39:14 darkslate klogd:   node 0 low ram: 00000000 - 377fe000
Sep 17 09:39:14 darkslate klogd:   node 0 bootmap 00008000 - 0000ef00
Sep 17 09:39:14 darkslate klogd: (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
Sep 17 09:39:14 darkslate klogd:   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Sep 17 09:39:14 darkslate klogd:   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
Sep 17 09:39:14 darkslate klogd:   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
Sep 17 09:39:14 darkslate klogd:   #3 [0000100000 - 00005deac4]    TEXT DATA BSS ==> [0000100000 - 00005deac4]
Sep 17 09:39:14 darkslate klogd:   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
Sep 17 09:39:14 darkslate klogd:   #5 [00005df000 - 00005e1128]              BRK ==> [00005df000 - 00005e1128]
Sep 17 09:39:14 darkslate klogd:   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
Sep 17 09:39:14 darkslate klogd:   #7 [00005e2000 - 00009605c0]      NEW RAMDISK ==> [00005e2000 - 00009605c0]
Sep 17 09:39:14 darkslate klogd:   #8 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
Sep 17 09:39:14 darkslate klogd: Zone PFN ranges:
Sep 17 09:39:14 darkslate klogd:   DMA      0x00000000 -> 0x00001000
Sep 17 09:39:14 darkslate klogd:   Normal   0x00001000 -> 0x000377fe
Sep 17 09:39:14 darkslate klogd:   HighMem  0x000377fe -> 0x0003f6e0
Sep 17 09:39:14 darkslate klogd: Movable zone start PFN for each node
Sep 17 09:39:14 darkslate klogd: early_node_map[2] active PFN ranges
Sep 17 09:39:14 darkslate klogd:     0: 0x00000000 -> 0x0000009f
Sep 17 09:39:14 darkslate klogd:     0: 0x00000100 -> 0x0003f6e0
Sep 17 09:39:14 darkslate klogd: Using APIC driver default
Sep 17 09:39:14 darkslate klogd: ACPI: PM-Timer IO Port: 0x1008
Sep 17 09:39:14 darkslate klogd: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Sep 17 09:39:14 darkslate klogd: ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Sep 17 09:39:14 darkslate klogd: ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
Sep 17 09:39:14 darkslate klogd: IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
Sep 17 09:39:14 darkslate klogd: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Sep 17 09:39:14 darkslate klogd: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Sep 17 09:39:14 darkslate klogd: Enabling APIC mode:  Flat.  Using 1 I/O APICs
Sep 17 09:39:14 darkslate klogd: Using ACPI (MADT) for SMP configuration information
Sep 17 09:39:14 darkslate klogd: SMP: Allowing 1 CPUs, 0 hotplug CPUs
Sep 17 09:39:14 darkslate klogd: PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Sep 17 09:39:14 darkslate klogd: PM: Registered nosave memory: 00000000000a0000 - 00000000000d0000
Sep 17 09:39:14 darkslate klogd: PM: Registered nosave memory: 00000000000d0000 - 00000000000d4000
Sep 17 09:39:14 darkslate klogd: PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
Sep 17 09:39:14 darkslate klogd: PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Sep 17 09:39:14 darkslate klogd: Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
Sep 17 09:39:14 darkslate klogd: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:1 nr_node_ids:1
Sep 17 09:39:14 darkslate klogd: PERCPU: Embedded 13 pages at c17f4000, static data 29788 bytes
Sep 17 09:39:14 darkslate klogd: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257681
Sep 17 09:39:14 darkslate klogd: Kernel command line: BOOT_IMAGE=2631-wl-mnbStrip-38258-g389ce02 root=UUID=18331b66-d09d-11dc-a304-bb98f15116b3 resume=UUID=1f2438ba-d09d-11dc-bd70-b338f060d6b7 splash=silent vga=788
Sep 17 09:39:14 darkslate klogd: PID hash table entries: 4096 (order: 12, 16384 bytes)
Sep 17 09:39:14 darkslate klogd: Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Sep 17 09:39:14 darkslate klogd: Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Sep 17 09:39:14 darkslate klogd: Enabling fast FPU save and restore... done.
Sep 17 09:39:14 darkslate klogd: Enabling unmasked SIMD FPU exception support... done.
Sep 17 09:39:14 darkslate klogd: Initializing CPU#0
Sep 17 09:39:14 darkslate klogd: Initializing HighMem for node 0 (000377fe:0003f6e0)
Sep 17 09:39:14 darkslate klogd: Memory: 1020872k/1039232k available (2724k kernel code, 17596k reserved, 1330k data, 372k init, 129928k highmem)
Sep 17 09:39:14 darkslate klogd: virtual kernel memory layout:
Sep 17 09:39:14 darkslate klogd:     fixmap  : 0xfff90000 - 0xfffff000   ( 444 kB)
Sep 17 09:39:14 darkslate klogd:     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Sep 17 09:39:14 darkslate klogd:     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
Sep 17 09:39:14 darkslate klogd:     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
Sep 17 09:39:14 darkslate klogd:       .init : 0xc04f6000 - 0xc0553000   ( 372 kB)
Sep 17 09:39:14 darkslate klogd:       .data : 0xc03a9031 - 0xc04f5ad8   (1330 kB)
Sep 17 09:39:14 darkslate klogd:       .text : 0xc0100000 - 0xc03a9031   (2724 kB)
Sep 17 09:39:14 darkslate klogd: Checking if this processor honours the WP bit even in supervisor mode...Ok.
Sep 17 09:39:14 darkslate klogd: SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Sep 17 09:39:14 darkslate klogd: NR_IRQS:320
Sep 17 09:39:14 darkslate klogd: Extended CMOS year: 2000
Sep 17 09:39:14 darkslate klogd: Fast TSC calibration using PIT
Sep 17 09:39:14 darkslate klogd: Detected 1729.128 MHz processor.
Sep 17 09:39:14 darkslate klogd: Console: colour dummy device 80x25
Sep 17 09:39:14 darkslate klogd: console [tty0] enabled
Sep 17 09:39:14 darkslate klogd: Calibrating delay loop (skipped), value calculated using timer frequency.. 3458.25 BogoMIPS (lpj=1729128)
Sep 17 09:39:14 darkslate klogd: Security Framework initialized
Sep 17 09:39:14 darkslate klogd: Mount-cache hash table entries: 512
Sep 17 09:39:14 darkslate klogd: CPU: L1 I cache: 32K, L1 D cache: 32K
Sep 17 09:39:14 darkslate klogd: CPU: L2 cache: 2048K
Sep 17 09:39:14 darkslate klogd: mce: CPU supports 5 MCE banks
Sep 17 09:39:14 darkslate klogd: CPU0: Thermal monitoring enabled (TM1)
Sep 17 09:39:14 darkslate klogd: Checking 'hlt' instruction... OK.
Sep 17 09:39:14 darkslate klogd: SMP alternatives: switching to UP code
Sep 17 09:39:14 darkslate klogd: Freeing SMP alternatives: 11k freed
Sep 17 09:39:14 darkslate klogd: ACPI: Core revision 20090521
Sep 17 09:39:14 darkslate klogd: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Sep 17 09:39:14 darkslate klogd: CPU0: Intel(R) Pentium(R) M processor 1.73GHz stepping 08
Sep 17 09:39:14 darkslate klogd: Brought up 1 CPUs
Sep 17 09:39:14 darkslate klogd: Total of 1 processors activated (3458.25 BogoMIPS).
Sep 17 09:39:14 darkslate klogd: Booting paravirtualized kernel on bare hardware
Sep 17 09:39:14 darkslate klogd: NET: Registered protocol family 16
Sep 17 09:39:14 darkslate klogd: ACPI: bus type pci registered
Sep 17 09:39:14 darkslate klogd: PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Sep 17 09:39:14 darkslate klogd: PCI: MCFG area at e0000000 reserved in E820
Sep 17 09:39:14 darkslate klogd: PCI: Using MMCONFIG for extended config space
Sep 17 09:39:14 darkslate klogd: PCI: Using configuration type 1 for base access
Sep 17 09:39:14 darkslate klogd: bio: create slab <bio-0> at 0
Sep 17 09:39:14 darkslate klogd: ACPI: EC: EC description table is found, configuring boot EC
Sep 17 09:39:14 darkslate klogd: ACPI: EC: non-query interrupt received, switching to interrupt mode
Sep 17 09:39:14 darkslate klogd: ACPI: Interpreter enabled
Sep 17 09:39:14 darkslate klogd: ACPI: (supports S0 S3 S4 S5)
Sep 17 09:39:14 darkslate klogd: ACPI: Using IOAPIC for interrupt routing
Sep 17 09:39:14 darkslate klogd: ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
Sep 17 09:39:14 darkslate klogd: ACPI: EC: driver started in interrupt mode
Sep 17 09:39:14 darkslate klogd: ACPI: Power Resource [PUBS] (on)
Sep 17 09:39:14 darkslate klogd: ACPI: ACPI Dock Station Driver: 3 docks/bays found
Sep 17 09:39:14 darkslate klogd: ACPI: PCI Root Bridge [PCI0] (0000:00)
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.0: PME# disabled
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.2: PME# disabled
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1d.7: PME# disabled
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1e.2: PME# supported from D0 D3hot D3cold
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1e.2: PME# disabled
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 1600-167f
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 15e0-15ef
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1f.2: PME# supported from D3hot
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1f.2: PME# disabled
Sep 17 09:39:14 darkslate klogd: pci 0000:02:00.0: PME# supported from D3hot D3cold
Sep 17 09:39:14 darkslate klogd: pci 0000:02:00.0: PME# disabled
Sep 17 09:39:14 darkslate klogd: pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Sep 17 09:39:14 darkslate klogd: pci 0000:04:00.0: PME# disabled
Sep 17 09:39:14 darkslate klogd: pci 0000:04:02.0: PME# supported from D0 D3hot
Sep 17 09:39:14 darkslate klogd: pci 0000:04:02.0: PME# disabled
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1e.0: transparent bridge
Sep 17 09:39:14 darkslate klogd: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
Sep 17 09:39:14 darkslate klogd: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
Sep 17 09:39:14 darkslate klogd: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
Sep 17 09:39:14 darkslate klogd: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
Sep 17 09:39:14 darkslate klogd: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
Sep 17 09:39:14 darkslate klogd: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
Sep 17 09:39:14 darkslate klogd: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
Sep 17 09:39:14 darkslate klogd: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
Sep 17 09:39:14 darkslate klogd: PCI: Using ACPI for IRQ routing
Sep 17 09:39:14 darkslate klogd: Expanded resource reserved due to conflict with Adapter ROM
Sep 17 09:39:14 darkslate klogd: NetLabel: Initializing
Sep 17 09:39:14 darkslate klogd: NetLabel:  domain hash size = 128
Sep 17 09:39:14 darkslate klogd: NetLabel:  protocols = UNLABELED CIPSOv4
Sep 17 09:39:14 darkslate klogd: NetLabel:  unlabeled traffic allowed by default
Sep 17 09:39:14 darkslate klogd: HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Sep 17 09:39:14 darkslate klogd: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Sep 17 09:39:14 darkslate klogd: hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Sep 17 09:39:14 darkslate klogd: pnp: PnP ACPI init
Sep 17 09:39:14 darkslate klogd: ACPI: bus type pnp registered
Sep 17 09:39:14 darkslate klogd: pnp: PnP ACPI: found 13 devices
Sep 17 09:39:14 darkslate klogd: ACPI: ACPI bus type pnp unregistered
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0x0-0x9ffff could not be reserved
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0xc8000-0xcbfff has been reserved
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0xcc000-0xcffff could not be reserved
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0xdc000-0xdffff could not be reserved
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0xe8000-0xebfff could not be reserved
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0xec000-0xeffff could not be reserved
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0xf0000-0xfffff could not be reserved
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0x100000-0x3fffffff could not be reserved
Sep 17 09:39:14 darkslate klogd: system 00:00: iomem range 0xfec00000-0xffffffff could not be reserved
Sep 17 09:39:14 darkslate klogd: system 00:02: ioport range 0x1000-0x107f has been reserved
Sep 17 09:39:14 darkslate klogd: system 00:02: ioport range 0x1180-0x11bf has been reserved
Sep 17 09:39:14 darkslate klogd: system 00:02: ioport range 0x15e0-0x15ef has been reserved
Sep 17 09:39:14 darkslate klogd: system 00:02: ioport range 0x1600-0x1641 has been reserved
Sep 17 09:39:14 darkslate klogd: system 00:02: ioport range 0x1644-0x167f has been reserved
Sep 17 09:39:14 darkslate klogd: system 00:02: iomem range 0xe0000000-0xefffffff has been reserved
Sep 17 09:39:14 darkslate klogd: system 00:02: iomem range 0xf0008000-0xf000bfff has been reserved
Sep 17 09:39:14 darkslate klogd: system 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
Sep 17 09:39:14 darkslate klogd: system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
Sep 17 09:39:14 darkslate klogd: system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.0:   IO window: disabled
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.0:   MEM window: 0x90100000-0x901fffff
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.0:   PREFETCH window: disabled
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.2: PCI bridge, secondary bus 0000:03
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.2:   IO window: 0x2000-0x2fff
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.2:   MEM window: 0x90200000-0x902fffff
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.2:   PREFETCH window: 0x000000c0000000-0x000000c00fffff
Sep 17 09:39:14 darkslate klogd: pci 0000:04:00.0: CardBus bridge, secondary bus 0000:05
Sep 17 09:39:14 darkslate klogd: pci 0000:04:00.0:   IO window: 0x003000-0x0030ff
Sep 17 09:39:14 darkslate klogd: pci 0000:04:00.0:   IO window: 0x003400-0x0034ff
Sep 17 09:39:14 darkslate klogd: pci 0000:04:00.0:   PREFETCH window: 0xc8000000-0xcbffffff
Sep 17 09:39:14 darkslate klogd: pci 0000:04:00.0:   MEM window: 0x94000000-0x97ffffff
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1e.0:   IO window: 0x3000-0x6fff
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1e.0:   MEM window: 0x90300000-0x9fffffff
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1e.0:   PREFETCH window: 0x000000c8000000-0x000000cfffffff
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Sep 17 09:39:14 darkslate klogd: pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
Sep 17 09:39:14 darkslate klogd: pci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Sep 17 09:39:14 darkslate klogd: NET: Registered protocol family 2
Sep 17 09:39:14 darkslate klogd: IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Sep 17 09:39:14 darkslate klogd: TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Sep 17 09:39:14 darkslate klogd: TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Sep 17 09:39:14 darkslate klogd: TCP: Hash tables configured (established 131072 bind 65536)
Sep 17 09:39:14 darkslate klogd: TCP reno registered
Sep 17 09:39:14 darkslate klogd: NET: Registered protocol family 1
Sep 17 09:39:14 darkslate klogd: Trying to unpack rootfs image as initramfs...
Sep 17 09:39:14 darkslate klogd: Freeing initrd memory: 3577k freed
Sep 17 09:39:14 darkslate klogd: Simple Boot Flag at 0x35 set to 0x1
Sep 17 09:39:14 darkslate klogd: audit: initializing netlink socket (disabled)
Sep 17 09:39:14 darkslate klogd: type=2000 audit(1253180323.259:1): initialized
Sep 17 09:39:14 darkslate klogd: highmem bounce pool size: 64 pages
Sep 17 09:39:14 darkslate klogd: HugeTLB registered 4 MB page size, pre-allocated 0 pages
Sep 17 09:39:14 darkslate klogd: VFS: Disk quotas dquot_6.5.2
Sep 17 09:39:14 darkslate klogd: Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Sep 17 09:39:14 darkslate klogd: msgmni has been set to 1747
Sep 17 09:39:14 darkslate klogd: alg: No test for stdrng (krng)
Sep 17 09:39:14 darkslate klogd: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Sep 17 09:39:14 darkslate klogd: io scheduler noop registered
Sep 17 09:39:14 darkslate klogd: io scheduler anticipatory registered
Sep 17 09:39:14 darkslate klogd: io scheduler deadline registered
Sep 17 09:39:14 darkslate klogd: io scheduler cfq registered (default)
Sep 17 09:39:14 darkslate klogd: vesafb: framebuffer at 0xb0000000, mapped to 0xf8080000, using 1875k, total 7872k
Sep 17 09:39:14 darkslate klogd: vesafb: mode is 800x600x16, linelength=1600, pages=7
Sep 17 09:39:14 darkslate klogd: vesafb: scrolling: redraw
Sep 17 09:39:14 darkslate klogd: vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Sep 17 09:39:14 darkslate klogd: Console: switching to colour frame buffer device 100x37
Sep 17 09:39:14 darkslate klogd: fb0: VESA VGA frame buffer device
Sep 17 09:39:14 darkslate klogd: Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Sep 17 09:39:14 darkslate klogd: serial 00:09: activated
Sep 17 09:39:14 darkslate klogd: 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
Sep 17 09:39:14 darkslate klogd: brd: module loaded
Sep 17 09:39:14 darkslate klogd: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
Sep 17 09:39:14 darkslate klogd: serio: i8042 KBD port at 0x60,0x64 irq 1
Sep 17 09:39:14 darkslate klogd: serio: i8042 AUX port at 0x60,0x64 irq 12
Sep 17 09:39:14 darkslate klogd: mice: PS/2 mouse device common for all mice
Sep 17 09:39:14 darkslate klogd: cpuidle: using governor ladder
Sep 17 09:39:14 darkslate klogd: cpuidle: using governor menu
Sep 17 09:39:14 darkslate klogd: TCP cubic registered
Sep 17 09:39:14 darkslate klogd: Using IPI No-Shortcut mode
Sep 17 09:39:14 darkslate klogd: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
Sep 17 09:39:14 darkslate klogd: Synaptics Touchpad, model: 1, fw: 5.9, id: 0x2c6ab1, caps: 0x884793/0x0
Sep 17 09:39:14 darkslate klogd: serio: Synaptics pass-through port at isa0060/serio1/input0
Sep 17 09:39:14 darkslate klogd: input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input1
Sep 17 09:39:14 darkslate klogd: registered taskstats version 1
Sep 17 09:39:14 darkslate klogd: BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Sep 17 09:39:14 darkslate klogd: Freeing unused kernel memory: 372k freed
Sep 17 09:39:14 darkslate klogd: SCSI subsystem initialized
Sep 17 09:39:14 darkslate klogd: ahci: probe of 0000:00:1f.2 failed with error -22
Sep 17 09:39:14 darkslate klogd: ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
Sep 17 09:39:14 darkslate klogd: scsi0 : ata_piix
Sep 17 09:39:14 darkslate klogd: scsi1 : ata_piix
Sep 17 09:39:14 darkslate klogd: ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
Sep 17 09:39:14 darkslate klogd: ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
Sep 17 09:39:14 darkslate klogd: ata2.00: ATAPI: UJDA765 DVD/CDRW, 1.70, max UDMA/33
Sep 17 09:39:14 darkslate klogd: ata1.00: ATA-6: HTS541060G9AT00, MB3IA60A, max UDMA/100
Sep 17 09:39:14 darkslate klogd: ata1.00: 117210240 sectors, multi 16: LBA 
Sep 17 09:39:14 darkslate klogd: ata1.00: applying bridge limits
Sep 17 09:39:14 darkslate klogd: ata2.00: configured for UDMA/33
Sep 17 09:39:14 darkslate klogd: ata1.00: configured for UDMA/100
Sep 17 09:39:14 darkslate klogd: scsi 0:0:0:0: Direct-Access     ATA      HTS541060G9AT00  MB3I PQ: 0 ANSI: 5
Sep 17 09:39:14 darkslate klogd: sd 0:0:0:0: [sda] 117210240 512-byte logical blocks: (60.0 GB/55.8 GiB)
Sep 17 09:39:14 darkslate klogd: sd 0:0:0:0: [sda] Write Protect is off
Sep 17 09:39:14 darkslate klogd: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep 17 09:39:14 darkslate klogd:  sda:
Sep 17 09:39:14 darkslate klogd: scsi 1:0:0:0: CD-ROM            MATSHITA UJDA765 DVD/CDRW 1.70 PQ: 0 ANSI: 5
Sep 17 09:39:14 darkslate klogd:  sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
Sep 17 09:39:14 darkslate klogd: sd 0:0:0:0: [sda] Attached SCSI disk
Sep 17 09:39:14 darkslate klogd: Uniform Multi-Platform E-IDE driver
Sep 17 09:39:14 darkslate klogd: ide-gd driver 1.18
Sep 17 09:39:14 darkslate klogd: IBM TrackPoint firmware: 0x0e, buttons: 3/3
Sep 17 09:39:14 darkslate klogd: input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input2
Sep 17 09:39:14 darkslate klogd: kjournald starting.  Commit interval 5 seconds
Sep 17 09:39:14 darkslate klogd: EXT3-fs: mounted filesystem with writeback data mode.
Sep 17 09:39:14 darkslate klogd: usbcore: registered new interface driver usbfs
Sep 17 09:39:14 darkslate klogd: usbcore: registered new interface driver hub
Sep 17 09:39:14 darkslate klogd: usbcore: registered new device driver usb
Sep 17 09:39:14 darkslate klogd: input: PC Speaker as /devices/platform/pcspkr/input/input3
Sep 17 09:39:14 darkslate klogd: Non-volatile memory driver v1.3
Sep 17 09:39:14 darkslate klogd: ACPI: Battery Slot [BAT0] (battery present)
Sep 17 09:39:14 darkslate klogd: yenta_cardbus 0000:04:00.0: CardBus bridge found [1014:0528]
Sep 17 09:39:14 darkslate klogd: yenta_cardbus 0000:04:00.0: Using INTVAL to route CSC interrupts to PCI
Sep 17 09:39:14 darkslate klogd: yenta_cardbus 0000:04:00.0: Routing CardBus interrupts to PCI
Sep 17 09:39:14 darkslate klogd: yenta_cardbus 0000:04:00.0: TI: mfunc 0x01d21002, devctl 0x64
Sep 17 09:39:14 darkslate klogd: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
Sep 17 09:39:14 darkslate klogd: ACPI: Power Button [PWRF]
Sep 17 09:39:14 darkslate klogd: input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input5
Sep 17 09:39:14 darkslate klogd: ACPI: Lid Switch [LID]
Sep 17 09:39:14 darkslate klogd: input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input6
Sep 17 09:39:14 darkslate klogd: ACPI: Sleep Button [SLPB]
Sep 17 09:39:14 darkslate klogd: thermal LNXTHERM:01: registered as thermal_zone0
Sep 17 09:39:14 darkslate klogd: ACPI: Thermal Zone [THM0] (53 C)
Sep 17 09:39:14 darkslate klogd: ACPI: AC Adapter [AC] (on-line)
Sep 17 09:39:14 darkslate klogd: rtc_cmos 00:06: RTC can wake from S4
Sep 17 09:39:14 darkslate klogd: rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
Sep 17 09:39:14 darkslate klogd: rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Sep 17 09:39:14 darkslate klogd: Marking TSC unstable due to TSC halts in idle
Sep 17 09:39:14 darkslate klogd: ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
Sep 17 09:39:14 darkslate klogd: processor LNXCPU:00: registered as cooling_device0
Sep 17 09:39:14 darkslate klogd: ACPI: Processor [CPU0] (supports 8 throttling states)
Sep 17 09:39:14 darkslate klogd: thinkpad_acpi: ThinkPad ACPI Extras v0.23
Sep 17 09:39:14 darkslate klogd: thinkpad_acpi: http://ibm-acpi.sf.net/
Sep 17 09:39:14 darkslate klogd: thinkpad_acpi: ThinkPad BIOS 70ET69WW (1.29 ), EC 70HT28WW-1.05
Sep 17 09:39:14 darkslate klogd: thinkpad_acpi: IBM ThinkPad T43, model 1875DLU
Sep 17 09:39:14 darkslate klogd: Registered led device: tpacpi::thinklight
Sep 17 09:39:14 darkslate klogd: Registered led device: tpacpi::power
Sep 17 09:39:14 darkslate klogd: Registered led device: tpacpi::standby
Sep 17 09:39:14 darkslate klogd: thinkpad_acpi: fan_init: initial fan status is unknown, assuming it is in auto mode
Sep 17 09:39:14 darkslate klogd: input: ThinkPad Extra Buttons as /devices/virtual/input/input7
Sep 17 09:39:14 darkslate klogd: yenta_cardbus 0000:04:00.0: ISA IRQ mask 0x0cf8, PCI irq 16
Sep 17 09:39:14 darkslate klogd: yenta_cardbus 0000:04:00.0: Socket status: 30000007
Sep 17 09:39:14 darkslate klogd: yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge I/O window: 0x3000 - 0x6fff
Sep 17 09:39:14 darkslate klogd: yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge Memory window: 0x90300000 - 0x9fffffff
Sep 17 09:39:14 darkslate klogd: yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge Memory window: 0xc8000000 - 0xcfffffff
Sep 17 09:39:14 darkslate klogd: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Sep 17 09:39:14 darkslate klogd: ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
Sep 17 09:39:14 darkslate klogd: ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
Sep 17 09:39:14 darkslate klogd: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Sep 17 09:39:14 darkslate klogd: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
Sep 17 09:39:14 darkslate klogd: ehci_hcd 0000:00:1d.7: debug port 1
Sep 17 09:39:14 darkslate klogd: ehci_hcd 0000:00:1d.7: irq 19, io mem 0x90040000
Sep 17 09:39:14 darkslate klogd: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Sep 17 09:39:14 darkslate klogd: usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Sep 17 09:39:14 darkslate klogd: usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Sep 17 09:39:14 darkslate klogd: usb usb1: Product: EHCI Host Controller
Sep 17 09:39:14 darkslate klogd: usb usb1: Manufacturer: Linux 2.6.31-wl-mnbStrip-38258-g389ce02 ehci_hcd
Sep 17 09:39:14 darkslate klogd: usb usb1: SerialNumber: 0000:00:1d.7
Sep 17 09:39:14 darkslate klogd: usb usb1: configuration #1 chosen from 1 choice
Sep 17 09:39:14 darkslate klogd: hub 1-0:1.0: USB hub found
Sep 17 09:39:14 darkslate klogd: hub 1-0:1.0: 8 ports detected
Sep 17 09:39:14 darkslate klogd: iTCO_vendor_support: vendor-support=0
Sep 17 09:39:14 darkslate klogd: iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
Sep 17 09:39:14 darkslate klogd: iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x1060)
Sep 17 09:39:14 darkslate klogd: iTCO_wdt: initialized. heartbeat=30 sec (nowayout=1)
Sep 17 09:39:14 darkslate klogd: Linux agpgart interface v0.103
Sep 17 09:39:14 darkslate klogd: agpgart-intel 0000:00:00.0: Intel 915GM Chipset
Sep 17 09:39:14 darkslate klogd: agpgart-intel 0000:00:00.0: detected 7932K stolen memory
Sep 17 09:39:14 darkslate klogd: agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xb0000000
Sep 17 09:39:14 darkslate klogd: i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Sep 17 09:39:14 darkslate klogd: sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Sep 17 09:39:14 darkslate klogd: Uniform CD-ROM driver Revision: 3.20
Sep 17 09:39:14 darkslate klogd: uhci_hcd: USB Universal Host Controller Interface driver
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
Sep 17 09:39:14 darkslate klogd: usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
Sep 17 09:39:14 darkslate klogd: usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Sep 17 09:39:14 darkslate klogd: usb usb2: Product: UHCI Host Controller
Sep 17 09:39:14 darkslate klogd: usb usb2: Manufacturer: Linux 2.6.31-wl-mnbStrip-38258-g389ce02 uhci_hcd
Sep 17 09:39:14 darkslate klogd: usb usb2: SerialNumber: 0000:00:1d.0
Sep 17 09:39:14 darkslate klogd: usb usb2: configuration #1 chosen from 1 choice
Sep 17 09:39:14 darkslate klogd: hub 2-0:1.0: USB hub found
Sep 17 09:39:14 darkslate klogd: hub 2-0:1.0: 2 ports detected
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
Sep 17 09:39:14 darkslate klogd: usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Sep 17 09:39:14 darkslate klogd: usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Sep 17 09:39:14 darkslate klogd: usb usb3: Product: UHCI Host Controller
Sep 17 09:39:14 darkslate klogd: usb usb3: Manufacturer: Linux 2.6.31-wl-mnbStrip-38258-g389ce02 uhci_hcd
Sep 17 09:39:14 darkslate klogd: usb usb3: SerialNumber: 0000:00:1d.1
Sep 17 09:39:14 darkslate klogd: usb usb3: configuration #1 chosen from 1 choice
Sep 17 09:39:14 darkslate klogd: hub 3-0:1.0: USB hub found
Sep 17 09:39:14 darkslate klogd: hub 3-0:1.0: 2 ports detected
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.2: UHCI Host Controller
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
Sep 17 09:39:14 darkslate klogd: usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
Sep 17 09:39:14 darkslate klogd: usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Sep 17 09:39:14 darkslate klogd: usb usb4: Product: UHCI Host Controller
Sep 17 09:39:14 darkslate klogd: usb usb4: Manufacturer: Linux 2.6.31-wl-mnbStrip-38258-g389ce02 uhci_hcd
Sep 17 09:39:14 darkslate klogd: usb usb4: SerialNumber: 0000:00:1d.2
Sep 17 09:39:14 darkslate klogd: usb usb4: configuration #1 chosen from 1 choice
Sep 17 09:39:14 darkslate klogd: hub 4-0:1.0: USB hub found
Sep 17 09:39:14 darkslate klogd: hub 4-0:1.0: 2 ports detected
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.3: UHCI Host Controller
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
Sep 17 09:39:14 darkslate klogd: uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
Sep 17 09:39:14 darkslate klogd: usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
Sep 17 09:39:14 darkslate klogd: usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Sep 17 09:39:14 darkslate klogd: usb usb5: Product: UHCI Host Controller
Sep 17 09:39:14 darkslate klogd: usb usb5: Manufacturer: Linux 2.6.31-wl-mnbStrip-38258-g389ce02 uhci_hcd
Sep 17 09:39:14 darkslate klogd: usb usb5: SerialNumber: 0000:00:1d.3
Sep 17 09:39:14 darkslate klogd: usb usb5: configuration #1 chosen from 1 choice
Sep 17 09:39:14 darkslate klogd: hub 5-0:1.0: USB hub found
Sep 17 09:39:14 darkslate klogd: hub 5-0:1.0: 2 ports detected
Sep 17 09:39:14 darkslate klogd: sd 0:0:0:0: Attached scsi generic sg0 type 0
Sep 17 09:39:14 darkslate klogd: sr 1:0:0:0: Attached scsi generic sg1 type 5
Sep 17 09:39:14 darkslate klogd: input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/input/input8
Sep 17 09:39:14 darkslate klogd: ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
Sep 17 09:39:14 darkslate klogd: tg3.c:v3.99 (April 20, 2009)
Sep 17 09:39:14 darkslate klogd: tg3 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Sep 17 09:39:14 darkslate klogd: tg3 0000:02:00.0: PME# disabled
Sep 17 09:39:14 darkslate klogd: eth0: Tigon3 [partno(BCM95751M) rev 4101] (PCI Express) MAC address 00:16:41:57:ab:3a
Sep 17 09:39:14 darkslate klogd: eth0: attached PHY is 5750 (10/100/1000Base-T Ethernet) (WireSpeed[1])
Sep 17 09:39:14 darkslate klogd: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
Sep 17 09:39:14 darkslate klogd: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
Sep 17 09:39:14 darkslate klogd: cfg80211: Calling CRDA to update world regulatory domain
Sep 17 09:39:14 darkslate klogd: cfg80211: World regulatory domain updated:
Sep 17 09:39:14 darkslate klogd: ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep 17 09:39:14 darkslate klogd: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:39:14 darkslate klogd: ^I(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:39:14 darkslate klogd: ^I(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:39:14 darkslate klogd: ^I(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:39:14 darkslate klogd: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:39:14 darkslate klogd: usb 4-2: new full speed USB device using uhci_hcd and address 2
Sep 17 09:39:14 darkslate klogd: usb 4-2: New USB device found, idVendor=0483, idProduct=2016
Sep 17 09:39:14 darkslate klogd: usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Sep 17 09:39:14 darkslate klogd: usb 4-2: Product: Biometric Coprocessor
Sep 17 09:39:14 darkslate klogd: usb 4-2: Manufacturer: STMicroelectronics
Sep 17 09:39:14 darkslate klogd: usb 4-2: configuration #1 chosen from 1 choice
Sep 17 09:39:14 darkslate klogd: NET: Registered protocol family 23
Sep 17 09:39:14 darkslate klogd: nsc-ircc 00:0b: activated
Sep 17 09:39:14 darkslate klogd: nsc-ircc, chip->init
Sep 17 09:39:14 darkslate klogd: nsc-ircc, Found chip at base=0x02e
Sep 17 09:39:14 darkslate klogd: nsc-ircc, driver loaded (Dag Brattli)
Sep 17 09:39:14 darkslate klogd: IrDA: Registered device irda0
Sep 17 09:39:14 darkslate klogd: nsc-ircc, Using dongle: IBM31T1100 or Temic TFDS6000/TFDS6500
Sep 17 09:39:14 darkslate klogd: ath9k 0000:04:02.0: enabling device (0000 -> 0002)
Sep 17 09:39:14 darkslate klogd: ath9k 0000:04:02.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
Sep 17 09:39:14 darkslate klogd: cfg80211: Calling CRDA for country: US
Sep 17 09:39:14 darkslate klogd: Registered led device: ath9k-phy0::radio
Sep 17 09:39:14 darkslate klogd: Registered led device: ath9k-phy0::assoc
Sep 17 09:39:14 darkslate klogd: Registered led device: ath9k-phy0::tx
Sep 17 09:39:14 darkslate klogd: Registered led device: ath9k-phy0::rx
Sep 17 09:39:14 darkslate klogd: phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: mem=0xf8820000, irq=21
Sep 17 09:39:14 darkslate klogd: cfg80211: Regulatory domain changed to country: US
Sep 17 09:39:14 darkslate klogd: ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep 17 09:39:14 darkslate klogd: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Sep 17 09:39:14 darkslate klogd: ^I(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Sep 17 09:39:14 darkslate klogd: ^I(5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:39:14 darkslate klogd: ^I(5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:39:14 darkslate klogd: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Sep 17 09:39:14 darkslate klogd: P-state transition latency capped at 20 uS
Sep 17 09:39:14 darkslate klogd: EXT3 FS on sda5, internal journal
Sep 17 09:39:14 darkslate klogd: kjournald starting.  Commit interval 5 seconds
Sep 17 09:39:14 darkslate klogd: EXT3 FS on sda8, internal journal
Sep 17 09:39:14 darkslate klogd: EXT3-fs: mounted filesystem with writeback data mode.
Sep 17 09:39:14 darkslate klogd: fuse init (API version 7.12)
Sep 17 09:39:14 darkslate klogd: loop: module loaded
Sep 17 09:39:14 darkslate klogd: Adding 4089920k swap on /dev/sda6.  Priority:-1 extents:1 across:4089920k 
Sep 17 09:39:14 darkslate crond[1818]: (CRON) STARTUP (1.2)
Sep 17 09:39:14 darkslate crond[1818]: (CRON) INFO (running with inotify support)
Sep 17 09:39:14 darkslate bluetoothd[1928]: Bluetooth daemon
Sep 17 09:39:15 darkslate klogd: Bluetooth: Core ver 2.15
Sep 17 09:39:15 darkslate klogd: NET: Registered protocol family 31
Sep 17 09:39:15 darkslate klogd: Bluetooth: HCI device and connection manager initialized
Sep 17 09:39:15 darkslate klogd: Bluetooth: HCI socket layer initialized
Sep 17 09:39:15 darkslate bluetoothd[1928]: Starting SDP server
Sep 17 09:39:15 darkslate klogd: Bluetooth: L2CAP ver 2.13
Sep 17 09:39:15 darkslate klogd: Bluetooth: L2CAP socket layer initialized
Sep 17 09:39:15 darkslate klogd: Bluetooth: SCO (Voice Link) ver 0.6
Sep 17 09:39:15 darkslate klogd: Bluetooth: SCO socket layer initialized
Sep 17 09:39:15 darkslate klogd: Bluetooth: RFCOMM TTY layer initialized
Sep 17 09:39:15 darkslate klogd: Bluetooth: RFCOMM socket layer initialized
Sep 17 09:39:15 darkslate klogd: Bluetooth: RFCOMM ver 1.11
Sep 17 09:39:15 darkslate klogd: Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Sep 17 09:39:15 darkslate klogd: Bluetooth: BNEP filters: protocol multicast
Sep 17 09:39:15 darkslate ifplugd(eth0)[2332]: ifplugd 0.28 initializing.
Sep 17 09:39:16 darkslate klogd: Clocksource tsc unstable (delta = -69473164 ns)
Sep 17 09:39:16 darkslate klogd: tg3 0000:02:00.0: PME# disabled
Sep 17 09:39:16 darkslate klogd: Bridge firewalling registered
Sep 17 09:39:16 darkslate acpid: client connected from 2413[70:70] 
Sep 17 09:39:16 darkslate acpid: 1 client rule loaded 
Sep 17 09:39:16 darkslate anacron[2434]: Anacron 2.3 started on 2009-09-17
Sep 17 09:39:16 darkslate anacron[2434]: Will run job `cron.daily' in 65 min.
Sep 17 09:39:16 darkslate bluetoothd[1928]: bridge pan0 created
Sep 17 09:39:16 darkslate bluetoothd[1928]: Registered interface org.bluez.Service on path /org/bluez/1928/any
Sep 17 09:39:16 darkslate acpid: client connected from 2464[0:0] 
Sep 17 09:39:16 darkslate acpid: 1 client rule loaded 
Sep 17 09:39:16 darkslate ifplugd(eth0)[2332]: Using interface eth0/00:16:41:57:AB:3A with driver <tg3> (version: 3.99)
Sep 17 09:39:16 darkslate ifplugd(eth0)[2332]: Using detection mode: SIOCETHTOOL
Sep 17 09:39:16 darkslate ifplugd(eth0)[2332]: Initialization complete, link beat not detected.
Sep 17 09:39:16 darkslate klogd: NET: Registered protocol family 17
Sep 17 09:39:16 darkslate ifplugd(wlan0)[2506]: ifplugd 0.28 initializing.
Sep 17 09:39:16 darkslate ifplugd(wlan0)[2506]: Using interface wlan0/00:03:7F:10:A1:C1
Sep 17 09:39:16 darkslate ifplugd(wlan0)[2506]: Using detection mode: wireless extension
Sep 17 09:39:16 darkslate ifplugd(wlan0)[2506]: Initialization complete, link beat not detected.
Sep 17 09:39:18 darkslate klogd: [drm] Initialized drm 1.1.0 20060810
Sep 17 09:39:18 darkslate avahi-daemon[2696]: Found user 'avahi' (UID 71) and group 'avahi' (GID 71).
Sep 17 09:39:18 darkslate avahi-daemon[2696]: Successfully dropped root privileges.
Sep 17 09:39:18 darkslate avahi-daemon[2696]: avahi-daemon 0.6.24 starting up.
Sep 17 09:39:18 darkslate avahi-daemon[2696]: WARNING: No NSS support for mDNS detected, consider installing nss-mdns!
Sep 17 09:39:18 darkslate avahi-daemon[2696]: Loading service file /etc/avahi/services/openssh.service.
Sep 17 09:39:18 darkslate avahi-daemon[2696]: Loading service file /etc/avahi/services/sftp-ssh.service.
Sep 17 09:39:18 darkslate avahi-daemon[2696]: Network interface enumeration completed.
Sep 17 09:39:18 darkslate avahi-daemon[2696]: Registering HINFO record with values 'I686'/'LINUX'.
Sep 17 09:39:18 darkslate avahi-daemon[2696]: Server startup complete. Host name is darkslate.local. Local service cookie is 505413112.
Sep 17 09:39:18 darkslate avahi-daemon[2696]: Service "SFTP File Transfer on darkslate" (/etc/avahi/services/sftp-ssh.service) successfully established.
Sep 17 09:39:18 darkslate avahi-daemon[2696]: Service "Remote Access on darkslate" (/etc/avahi/services/openssh.service) successfully established.
Sep 17 09:39:18 darkslate klogd: pci 0000:00:02.0: power state changed by ACPI to D0
Sep 17 09:39:18 darkslate klogd: pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Sep 17 09:39:18 darkslate klogd: [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
Sep 17 09:39:18 darkslate ntpdate[2707]: name server cannot be used, reason: Temporary failure in name resolution 
Sep 17 09:39:19 darkslate rpc.statd[2791]: Version 1.1.5 Starting
Sep 17 09:39:19 darkslate sshd[2800]: Server listening on 0.0.0.0 port 22.
Sep 17 09:39:19 darkslate sm-notify[2792]: Failed to open /var/lib/nfs/sm.bak: No such file or directory
Sep 17 09:39:19 darkslate klogd: ip_tables: (C) 2000-2006 Netfilter Core Team
Sep 17 09:39:19 darkslate ntpdate[2923]: name server cannot be used, reason: Temporary failure in name resolution 
Sep 17 09:39:19 darkslate klogd: Netfilter messages via NETLINK v0.30.
Sep 17 09:39:20 darkslate klogd: nf_conntrack version 0.5.0 (16238 buckets, 64952 max)
Sep 17 09:39:20 darkslate klogd: CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
Sep 17 09:39:20 darkslate klogd: nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
Sep 17 09:39:20 darkslate klogd: sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Sep 17 09:39:20 darkslate ntpdate[2943]: name server cannot be used, reason: Temporary failure in name resolution 
Sep 17 09:39:21 darkslate ntpdate[2989]: name server cannot be used, reason: Temporary failure in name resolution 
Sep 17 09:39:22 darkslate ntpdate[3021]: name server cannot be used, reason: Temporary failure in name resolution 
Sep 17 09:39:23 darkslate ntpdate[3052]: name server cannot be used, reason: Temporary failure in name resolution 
Sep 17 09:39:24 darkslate klogd: ctnetlink v0.93: registering with nfnetlink.
Sep 17 09:39:25 darkslate ntpdate[3076]: name server cannot be used, reason: Temporary failure in name resolution 
Sep 17 09:39:26 darkslate ntpd[3115]: ntpd 4.2.4p6@1.1549 Wed Jun 10 17:42:32 UTC 2009 (1)
Sep 17 09:39:26 darkslate ntpd[3116]: precision = 1.000 usec
Sep 17 09:39:26 darkslate ntpd[3116]: Listening on interface #0 wildcard, 0.0.0.0#123 Disabled
Sep 17 09:39:26 darkslate ntpd[3116]: Listening on interface #1 lo, 127.0.0.1#123 Enabled
Sep 17 09:39:26 darkslate ntpd[3116]: kernel time sync status 0040
Sep 17 09:39:26 darkslate ntpd[3116]: frequency initialized -6.403 PPM from /var/lib/ntp/drift
Sep 17 09:39:28 darkslate klogd: xt_time: kernel timezone is -0700
Sep 17 09:39:31 darkslate logger: Shorewall started
Sep 17 09:40:00 darkslate gnome-session[3880]: WARNING: Could not launch application 'gnome-autostart-draksnapshot.desktop': Unable to start application: Failed to execute child process "/usr/bin/draksnapshot-applet" (No such file or directory) 
Sep 17 09:40:01 darkslate mdkapplet[4041]: ### Program is starting ###
Sep 17 09:40:01 darkslate net_applet[4044]: ### Program is starting ###
Sep 17 09:40:01 darkslate CROND[4060]: (root) CMD (   /usr/share/msec/promisc_check.sh)
Sep 17 09:40:10 darkslate dbus-daemon: Would reject message, 1 matched rules; type="method_call", sender=":1.39" (uid=0 pid=4331 comm="/usr/bin/python /usr/lib/blueman-mechanism ") interface="org.freedesktop.DBus.Introspectable" member="Introspect" error name="(unset)" requested_reply=0 destination=":1.40" (uid=15 pid=4338 comm="/usr/lib/polkitd "))
Sep 17 09:40:12 darkslate mdkapplet[4041]: running: ionice -p 4041 -n7
Sep 17 09:41:01 darkslate CROND[4866]: (root) CMD (   /usr/share/msec/promisc_check.sh)
Sep 17 09:41:46 darkslate ifplugd(eth0)[2332]: Exiting.
Sep 17 09:41:46 darkslate klogd: tg3 0000:02:00.0: PME# enabled
Sep 17 09:41:46 darkslate ifplugd(wlan0)[2506]: Exiting.
Sep 17 09:41:49 darkslate klogd: ath9k 0000:04:02.0: PCI INT A disabled
Sep 17 09:41:49 darkslate klogd: ath9k: Driver unloaded
Sep 17 09:42:01 darkslate CROND[5895]: (root) CMD (   /usr/share/msec/promisc_check.sh)
Sep 17 09:42:06 darkslate klogd: cfg80211: Calling CRDA to update world regulatory domain
Sep 17 09:42:06 darkslate klogd: cfg80211: World regulatory domain updated:
Sep 17 09:42:06 darkslate klogd: ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep 17 09:42:06 darkslate klogd: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:42:06 darkslate klogd: ^I(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:42:06 darkslate klogd: ^I(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:42:06 darkslate klogd: ^I(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:42:06 darkslate klogd: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:42:08 darkslate klogd: ath9k 0000:04:02.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
Sep 17 09:42:08 darkslate klogd: cfg80211: Calling CRDA for country: US
Sep 17 09:42:08 darkslate klogd: Registered led device: ath9k-phy0::radio
Sep 17 09:42:08 darkslate klogd: Registered led device: ath9k-phy0::assoc
Sep 17 09:42:08 darkslate klogd: Registered led device: ath9k-phy0::tx
Sep 17 09:42:08 darkslate klogd: Registered led device: ath9k-phy0::rx
Sep 17 09:42:08 darkslate klogd: phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: mem=0xfa7a0000, irq=21
Sep 17 09:42:08 darkslate klogd: cfg80211: Regulatory domain changed to country: US
Sep 17 09:42:08 darkslate klogd: ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep 17 09:42:08 darkslate klogd: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Sep 17 09:42:08 darkslate klogd: ^I(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Sep 17 09:42:08 darkslate klogd: ^I(5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:42:08 darkslate klogd: ^I(5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep 17 09:42:08 darkslate klogd: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Sep 17 09:42:40 darkslate ifplugd(eth0)[6494]: ifplugd 0.28 initializing.
Sep 17 09:42:40 darkslate klogd: tg3 0000:02:00.0: PME# disabled
Sep 17 09:42:40 darkslate ifplugd(eth0)[6494]: Using interface eth0/00:16:41:57:AB:3A with driver <tg3> (version: 3.99)
Sep 17 09:42:40 darkslate ifplugd(eth0)[6494]: Using detection mode: SIOCETHTOOL
Sep 17 09:42:40 darkslate ifplugd(eth0)[6494]: Initialization complete, link beat not detected.
Sep 17 09:42:40 darkslate ifplugd(wlan0)[6553]: ifplugd 0.28 initializing.
Sep 17 09:42:40 darkslate ifplugd(wlan0)[6553]: Using interface wlan0/00:03:7F:10:A1:C1
Sep 17 09:42:40 darkslate ifplugd(wlan0)[6553]: Using detection mode: wireless extension
Sep 17 09:42:40 darkslate ifplugd(wlan0)[6553]: Initialization complete, link beat not detected.
Sep 17 09:42:45 darkslate ntpd[3116]: synchronized to LOCAL(0), stratum 10
Sep 17 09:42:45 darkslate ntpd[3116]: kernel time sync status change 0001
Sep 17 09:43:01 darkslate CROND[6844]: (root) CMD (   /usr/share/msec/promisc_check.sh)
Sep 17 09:44:01 darkslate CROND[7624]: (root) CMD (   /usr/share/msec/promisc_check.sh)
Sep 17 09:44:08 darkslate net_applet[4044]: ### Program is exiting ###
Sep 17 09:45:01 darkslate CROND[8346]: (root) CMD (   /usr/share/msec/promisc_check.sh)
Sep 17 09:45:12 darkslate mdkapplet[4041]: Checking Network: seems disabled 
Sep 17 09:46:01 darkslate CROND[9160]: (root) CMD (   /usr/share/msec/promisc_check.sh)
Sep 17 09:46:13 darkslate console-kit-daemon[1921]: GLib-GObject-WARNING: IA__g_object_get_valist: value location for `gchararray' passed as NULL 
Sep 17 09:46:13 darkslate last message repeated 2 times
Sep 17 09:46:13 darkslate shutdown[9182]: shutting down for system halt
Sep 17 09:46:13 darkslate shutdown[9191]: shutting down for system halt
Sep 17 09:46:13 darkslate console-kit-daemon[1921]: GLib-GObject-WARNING: IA__g_object_get_valist: value location for `gchararray' passed as NULL 
Sep 17 09:46:13 darkslate shutdown[9196]: shutting down for system halt
Sep 17 09:46:13 darkslate console-kit-daemon[1921]: GLib-GObject-WARNING: IA__g_object_get_valist: value location for `gchararray' passed as NULL 
Sep 17 09:46:13 darkslate shutdown[9201]: shutting down for system halt
Sep 17 09:46:13 darkslate init: Switching to runlevel: 0
Sep 17 09:46:15 darkslate ntpd[3116]: ntpd exiting on signal 15
Sep 17 09:46:15 darkslate ntpd_initres[3119]: parent died before we finished, exiting
Sep 17 09:46:16 darkslate avahi-daemon[2696]: Got SIGTERM, quitting.
Sep 17 09:46:16 darkslate sshd[2800]: Received signal 15; terminating.
Sep 17 09:46:16 darkslate acpid: exiting 
Sep 17 09:46:16 darkslate rpc.statd[2791]: Caught signal 15, un-registering and exiting.
Sep 17 09:46:16 darkslate bluetoothd[1928]: bridge pan0 removed
Sep 17 09:46:16 darkslate bluetoothd[1928]: Stopping SDP server
Sep 17 09:46:16 darkslate bluetoothd[1928]: Exit
Sep 17 09:46:17 darkslate klogd: Kernel logging (proc) stopped.
Sep 17 09:46:17 darkslate klogd: Kernel log daemon terminating.
Sep 17 09:46:18 darkslate logger: Shorewall Stopped
Sep 17 09:46:18 darkslate exiting on signal 15
Sep 17 09:49:32 darkslate syslogd 1.5.0: restart.
Sep 17 09:49:32 darkslate klogd: klogd 1.5.0, log source = /proc/kmsg started.



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:59092 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab0C2R0w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 13:26:52 -0400
Received: by qw-out-2122.google.com with SMTP id 8so3284637qwh.37
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 10:26:51 -0700 (PDT)
Message-ID: <4bb0e2da.04c2f10a.32b2.11ae@mx.google.com>
Date: Mon, 29 Mar 2010 10:26:50 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Another AR5008 hang
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New (2.6.33 and greater) kernels seem to result in a selective hang on my
machine directly only seconds after association with an 802.11N access point
(hosted with hostapd and another ar5008). I've included dmesg output for a
failure event, including back traces of hung processes. What ath9k.debug flags
would be most helpful for tracing this further?

Thanks,

- Ben


0c:00.0 Network controller: Atheros Communications Inc. AR5008 Wireless Network Adapter (rev 01)


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.34-rc2-ben (ben@ben-laptop) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu9) ) #134 SMP Sat Mar 27 14:38:26 EDT 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc2-ben root=/dev/sda6 ro debug ath9k.debug=0x2000 console=ttyS0,115200 pciehp.pciehp_force=1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df65a800 (usable)
[    0.000000]  BIOS-e820: 00000000df65a800 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 100000000 mask FE0000000 write-back
[    0.000000]   4 base 0DF800000 mask FFF800000 uncachable
[    0.000000]   5 base 0DF700000 mask FFFF00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000df700000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdf65a max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000df65a800 (usable)
[    0.000000]  modified: 00000000df65a800 - 00000000e0000000 (reserved)
[    0.000000]  modified: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000df65a000
[    0.000000]  0000000000 - 00df600000 page 2M
[    0.000000]  00df600000 - 00df65a000 page 4k
[    0.000000] kernel direct mapping tables up to df65a000 @ 16000-1c000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 1a000-20000
[    0.000000] RAMDISK: 3530b000 - 37fefaee
[    0.000000] ACPI: RSDP 00000000000fbb10 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000df65d200 00064 (v01 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: FACP 00000000df65d09c 000F4 (v04 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: DSDT 00000000df65d800 063B2 (v02 INT430 SYSFexxx 00001001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000df66c000 00040
[    0.000000] ACPI: HPET 00000000df65d300 00038 (v01 DELL    M08     00000001 ASL  00000061)
[    0.000000] ACPI: APIC 00000000df65d400 00068 (v01 DELL    M08     27D80C0B ASL  00000047)
[    0.000000] ACPI: ASF! 00000000df65d000 0007E (v32 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: MCFG 00000000df65d3c0 0003E (v16 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: TCPA 00000000df65d700 00032 (v01                 00000000 ASL  00000000)
[    0.000000] ACPI: SLIC 00000000df65d49c 00176 (v01 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: SSDT 00000000df65b9c0 004CC (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880100200000-ffff880103bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000df65a
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1045993
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 896658 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] early_res array is doubled to 64 at [1b000 - 1b7ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df65a000 - 00000000df65b000
[    0.000000] PM: Registered nosave memory: 00000000df65b000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000feda6000
[    0.000000] PM: Registered nosave memory: 00000000feda6000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s90856 r8192 d23832 u1048576
[    0.000000] pcpu-alloc: s90856 r8192 d23832 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1029865
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc2-ben root=/dev/sda6 ro debug ath9k.debug=0x2000 console=ttyS0,115200 pciehp.pciehp_force=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (52 early reservations)
[    0.000000]   #1 [0001000000 - 0001cb64a4]   TEXT DATA BSS
[    0.000000]   #2 [003530b000 - 0037fefaee]         RAMDISK
[    0.000000]   #3 [000009f000 - 0000100000]   BIOS reserved
[    0.000000]   #4 [0001cb7000 - 0001cb71ec]             BRK
[    0.000000]   #5 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #6 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #7 [0000016000 - 000001a000]         PGTABLE
[    0.000000]   #8 [000001a000 - 000001b000]         PGTABLE
[    0.000000]   #9 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #10 [0001cb7200 - 0001cb8200]         BOOTMEM
[    0.000000]   #11 [0001cb64c0 - 0001cb67c0]         BOOTMEM
[    0.000000]   #12 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #13 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #14 [0100200000 - 0103c00000]        MEMMAP 0
[    0.000000]   #15 [0001cb67c0 - 0001cb6940]         BOOTMEM
[    0.000000]   #16 [0001cb8200 - 0001cd0200]         BOOTMEM
[    0.000000]   #17 [0001cd0200 - 0001cd3200]         BOOTMEM
[    0.000000]   #18 [0001cd4000 - 0001cd5000]         BOOTMEM
[    0.000000]   #19 [0001cb6940 - 0001cb6981]         BOOTMEM
[    0.000000]   #20 [0001cb69c0 - 0001cb6a03]         BOOTMEM
[    0.000000]   #21 [0001cb6a40 - 0001cb6d18]         BOOTMEM
[    0.000000]   #22 [0001cb6d40 - 0001cb6da8]         BOOTMEM
[    0.000000]   #23 [0001cb6dc0 - 0001cb6e28]         BOOTMEM
[    0.000000]   #24 [0001cb6e40 - 0001cb6ea8]         BOOTMEM
[    0.000000]   #25 [0001cb6ec0 - 0001cb6f28]         BOOTMEM
[    0.000000]   #26 [0001cb6f40 - 0001cb6fa8]         BOOTMEM
[    0.000000]   #27 [0001cd3200 - 0001cd3268]         BOOTMEM
[    0.000000]   #28 [0001cd3280 - 0001cd32e8]         BOOTMEM
[    0.000000]   #29 [0001cd3300 - 0001cd3368]         BOOTMEM
[    0.000000]   #30 [0001cd3380 - 0001cd33e8]         BOOTMEM
[    0.000000]   #31 [0001cd3400 - 0001cd3468]         BOOTMEM
[    0.000000]   #32 [0001cd3480 - 0001cd34e8]         BOOTMEM
[    0.000000]   #33 [0001cd3500 - 0001cd3568]         BOOTMEM
[    0.000000]   #34 [0001cb6fc0 - 0001cb6fe0]         BOOTMEM
[    0.000000]   #35 [0001cd3580 - 0001cd35a0]         BOOTMEM
[    0.000000]   #36 [0001cd35c0 - 0001cd3639]         BOOTMEM
[    0.000000]   #37 [0001cd3640 - 0001cd36b9]         BOOTMEM
[    0.000000]   #38 [0001e00000 - 0001e1e000]         BOOTMEM
[    0.000000]   #39 [0001f00000 - 0001f1e000]         BOOTMEM
[    0.000000]   #40 [0001cd36c0 - 0001cd36c8]         BOOTMEM
[    0.000000]   #41 [0001cd3700 - 0001cd3708]         BOOTMEM
[    0.000000]   #42 [0001cd3740 - 0001cd3748]         BOOTMEM
[    0.000000]   #43 [0001cd3780 - 0001cd3790]         BOOTMEM
[    0.000000]   #44 [0001cd37c0 - 0001cd3900]         BOOTMEM
[    0.000000]   #45 [0001cd3900 - 0001cd3960]         BOOTMEM
[    0.000000]   #46 [0001cd3980 - 0001cd39e0]         BOOTMEM
[    0.000000]   #47 [0001cd5000 - 0001cdd000]         BOOTMEM
[    0.000000]   #48 [0001f1e000 - 0005f1e000]         BOOTMEM
[    0.000000]   #49 [0001cdd000 - 0001cfd000]         BOOTMEM
[    0.000000]   #50 [0001cfd000 - 0001d3d000]         BOOTMEM
[    0.000000]   #51 [000001b800 - 0000023800]         BOOTMEM
[    0.000000] Memory: 3999168k/4718592k available (5762k kernel code, 534620k absent, 184804k reserved, 5364k data, 820k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2194.340 MHz processor.
[    0.008007] Calibrating delay loop (skipped), value calculated using timer frequency.. 4388.68 BogoMIPS (lpj=8777360)
[    0.016027] Security Framework initialized
[    0.020009] SELinux:  Disabled at boot.
[    0.024391] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.034270] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.037192] Mount-cache hash table entries: 256
[    0.040166] Initializing cgroup subsys ns
[    0.044009] Initializing cgroup subsys cpuacct
[    0.048005] Initializing cgroup subsys memory
[    0.056011] Initializing cgroup subsys freezer
[    0.060004] Initializing cgroup subsys net_cls
[    0.064027] CPU: Physical Processor ID: 0
[    0.068003] CPU: Processor Core ID: 0
[    0.072004] mce: CPU supports 6 MCE banks
[    0.076009] CPU0: Thermal monitoring enabled (TM2)
[    0.080006] using mwait in idle threads.
[    0.084003] Performance Events: Core2 events, Intel PMU driver.
[    0.090882] ... version:                2
[    0.092003] ... bit width:              40
[    0.096003] ... generic registers:      2
[    0.100003] ... value mask:             000000ffffffffff
[    0.104003] ... max period:             000000007fffffff
[    0.108003] ... fixed-purpose events:   3
[    0.112003] ... event mask:             0000000700000003
[    0.120453] ACPI: Core revision 20100121
[    0.135482] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.136007] ftrace: allocating 21367 entries in 84 pages
[    0.144056] Setting APIC routing to flat
[    0.148379] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.193656] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
[    0.204000] Booting Node   0, Processors  #1 Ok.
[    0.296017] Brought up 2 CPUs
[    0.298973] Total of 2 processors activated (8777.64 BogoMIPS).
[    0.300779] Time: 15:32:51  Date: 03/29/10
[    0.304033] NET: Registered protocol family 16
[    0.308031] ACPI: bus type pci registered
[    0.312043] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0x000000)
[    0.316012] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.331777] PCI: Using configuration type 1 for base access
[    0.336039] bio: create slab <bio-0> at 0
[    0.341048] ACPI: EC: Look up EC in DSDT
[    0.356250] ACPI: BIOS _OSI(Linux) query ignored
[    0.366592] ACPI: SSDT 00000000df66c080 00043 (v01  LMPWR  DELLLOM 00001001 INTL 20050624)
[    0.392251] ACPI: SSDT 00000000df65c4f6 00286 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.396707] ACPI: SSDT 00000000df65be8c 005E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.400780] ACPI: SSDT 00000000df65c77c 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.404555] ACPI: SSDT 00000000df65c471 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.412494] ACPI: Interpreter enabled
[    0.416003] ACPI: (supports S0 S3 S4 S5)
[    0.421117] ACPI: Using IOAPIC for interrupt routing
[    0.505262] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.508034] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.526954] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.561387] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.564004] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.568006] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.572002] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.576002] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xf7ffffff]
[    0.580002] pci_root PNP0A03:00: host bridge window [mem 0xfc000000-0xfebfffff]
[    0.584002] pci_root PNP0A03:00: host bridge window [mem 0xfec10000-0xfecfffff]
[    0.588002] pci_root PNP0A03:00: host bridge window [mem 0xfed1c000-0xfed1ffff]
[    0.592002] pci_root PNP0A03:00: host bridge window [mem 0xfed90000-0xfed9ffff]
[    0.596002] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.600003] pci_root PNP0A03:00: host bridge window [mem 0xfeda7000-0xfedfffff]
[    0.604002] pci_root PNP0A03:00: host bridge window [mem 0xfee10000-0xff9fffff]
[    0.608004] pci_root PNP0A03:00: host bridge window [mem 0xffc00000-0xffdfffff]
[    0.612060] pci 0000:00:02.0: reg 10: [mem 0xf6e00000-0xf6efffff 64bit]
[    0.616006] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.620004] pci 0000:00:02.0: reg 20: [io  0xeff8-0xefff]
[    0.624035] pci 0000:00:02.1: reg 10: [mem 0xf6f00000-0xf6ffffff 64bit]
[    0.628110] pci 0000:00:1a.0: reg 20: [io  0x6f20-0x6f3f]
[    0.632064] pci 0000:00:1a.1: reg 20: [io  0x6f00-0x6f1f]
[    0.636065] pci 0000:00:1a.7: reg 10: [mem 0xfed1c400-0xfed1c7ff]
[    0.640065] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.644005] pci 0000:00:1a.7: PME# disabled
[    0.648045] pci 0000:00:1b.0: reg 10: [mem 0xf6dfc000-0xf6dfffff 64bit]
[    0.652063] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.656005] pci 0000:00:1b.0: PME# disabled
[    0.660099] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.664004] pci 0000:00:1c.0: PME# disabled
[    0.668101] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.672005] pci 0000:00:1c.1: PME# disabled
[    0.676103] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.680004] pci 0000:00:1c.3: PME# disabled
[    0.684102] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.688004] pci 0000:00:1c.5: PME# disabled
[    0.692061] pci 0000:00:1d.0: reg 20: [io  0x6f80-0x6f9f]
[    0.696065] pci 0000:00:1d.1: reg 20: [io  0x6f60-0x6f7f]
[    0.700066] pci 0000:00:1d.2: reg 20: [io  0x6f40-0x6f5f]
[    0.704062] pci 0000:00:1d.7: reg 10: [mem 0xfed1c000-0xfed1c3ff]
[    0.708064] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.712005] pci 0000:00:1d.7: PME# disabled
[    0.716165] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.720004] pci 0000:00:1f.0: quirk: [io  0x1080-0x10bf] claimed by ICH6 GPIO
[    0.724004] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0900 (mask 007f)
[    0.728005] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0c80 (mask 003f)
[    0.732053] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    0.736008] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    0.740007] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    0.744007] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    0.748007] pci 0000:00:1f.1: reg 20: [io  0x6fa0-0x6faf]
[    0.752063] pci 0000:00:1f.2: reg 10: [io  0x6eb0-0x6eb7]
[    0.756007] pci 0000:00:1f.2: reg 14: [io  0x6eb8-0x6ebb]
[    0.760007] pci 0000:00:1f.2: reg 18: [io  0x6ec0-0x6ec7]
[    0.764007] pci 0000:00:1f.2: reg 1c: [io  0x6ec8-0x6ecb]
[    0.768007] pci 0000:00:1f.2: reg 20: [io  0x6ee0-0x6eff]
[    0.772007] pci 0000:00:1f.2: reg 24: [mem 0xf6dfb800-0xf6dfbfff]
[    0.776043] pci 0000:00:1f.2: PME# supported from D3hot
[    0.780004] pci 0000:00:1f.2: PME# disabled
[    0.784032] pci 0000:00:1f.3: reg 10: [mem 0xf6dfb700-0xf6dfb7ff]
[    0.788025] pci 0000:00:1f.3: reg 20: [io  0x10c0-0x10df]
[    0.792089] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    0.796005] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.800005] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.804007] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.808107] pci 0000:0c:00.0: reg 10: [mem 0xf6cf0000-0xf6cfffff 64bit]
[    0.812094] pci 0000:0c:00.0: supports D1
[    0.816002] pci 0000:0c:00.0: PME# supported from D0 D1 D3hot
[    0.820005] pci 0000:0c:00.0: PME# disabled
[    0.824027] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    0.828004] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.832004] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    0.836007] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.840062] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    0.844004] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.848004] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff]
[    0.852007] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.856117] pci 0000:09:00.0: reg 10: [mem 0xf69f0000-0xf69fffff 64bit]
[    0.860108] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    0.864006] pci 0000:09:00.0: PME# disabled
[    0.868020] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.872004] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.876004] pci 0000:00:1c.5:   bridge window [mem 0xf6900000-0xf69fffff]
[    0.880007] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.884068] pci 0000:03:01.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.888028] pci 0000:03:01.0: supports D1 D2
[    0.892001] pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.896005] pci 0000:03:01.0: PME# disabled
[    0.900042] pci 0000:03:01.4: reg 10: [mem 0xf68ff000-0xf68fffff]
[    0.904007] pci 0000:03:01.4: reg 14: [mem 0xf68fe800-0xf68fefff]
[    0.908051] pci 0000:03:01.4: supports D1 D2
[    0.912001] pci 0000:03:01.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.916004] pci 0000:03:01.4: PME# disabled
[    0.920071] pci 0000:00:1e.0: PCI bridge to [bus 03-04] (subtractive decode)
[    0.924004] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.928004] pci 0000:00:1e.0:   bridge window [mem 0xf6800000-0xf68fffff]
[    0.932007] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.936002] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.940001] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.944002] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.948001] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.952002] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xf7ffffff] (subtractive decode)
[    0.956001] pci 0000:00:1e.0:   bridge window [mem 0xfc000000-0xfebfffff] (subtractive decode)
[    0.960001] pci 0000:00:1e.0:   bridge window [mem 0xfec10000-0xfecfffff] (subtractive decode)
[    0.964001] pci 0000:00:1e.0:   bridge window [mem 0xfed1c000-0xfed1ffff] (subtractive decode)
[    0.968001] pci 0000:00:1e.0:   bridge window [mem 0xfed90000-0xfed9ffff] (subtractive decode)
[    0.972001] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.976001] pci 0000:00:1e.0:   bridge window [mem 0xfeda7000-0xfedfffff] (subtractive decode)
[    0.980001] pci 0000:00:1e.0:   bridge window [mem 0xfee10000-0xff9fffff] (subtractive decode)
[    0.984002] pci 0000:00:1e.0:   bridge window [mem 0xffc00000-0xffdfffff] (subtractive decode)
[    0.988053] pci_bus 0000:04: [bus 04-07] partially hidden behind transparent bridge 0000:03 [bus 03-04]
[    0.992037] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.996243] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    1.000144] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.004070] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    1.008073] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    1.012071] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    1.039123] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
[    1.041259] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *3
[    1.045055] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 *10 11)
[    1.052679] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 *11)
[    1.057607] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    1.066429] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    1.073781] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    1.081489] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    1.090122] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.092020] vgaarb: loaded
[    1.096063] SCSI subsystem initialized
[    1.100025] libata version 3.00 loaded.
[    1.104028] usbcore: registered new interface driver usbfs
[    1.108023] usbcore: registered new interface driver hub
[    1.112013] usbcore: registered new device driver usb
[    1.116057] ACPI: WMI: Mapper loaded
[    1.120002] PCI: Using ACPI for IRQ routing
[    1.124009] PCI: pci_cache_line_size set to 64 bytes
[    1.128107] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
[    1.132002] reserve RAM buffer: 00000000df65a800 - 00000000dfffffff 
[    1.136053] Bluetooth: Core ver 2.15
[    1.140047] NET: Registered protocol family 31
[    1.144001] Bluetooth: HCI device and connection manager initialized
[    1.148007] Bluetooth: HCI socket layer initialized
[    1.152002] NetLabel: Initializing
[    1.156001] NetLabel:  domain hash size = 128
[    1.160001] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.164013] NetLabel:  unlabeled traffic allowed by default
[    1.168028] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.172016] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.180466] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.192016] Switching to clocksource tsc
[    1.204858] pnp: PnP ACPI init
[    1.207917] ACPI: bus type pnp registered
[    1.256021] pnp 00:0b: disabling [io  0x1000-0x1005] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    1.266080] pnp 00:0b: disabling [io  0x1008-0x100f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    1.276254] pnp 00:0c: disabling [io  0x1006-0x1007] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    1.286322] pnp 00:0c: disabling [io  0x100a-0x1059] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    1.296382] pnp 00:0c: disabling [io  0x1060-0x107f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    1.306442] pnp 00:0c: disabling [io  0x1010-0x102f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    1.336310] pnp: PnP ACPI: found 14 devices
[    1.340488] ACPI: ACPI bus type pnp unregistered
[    1.345103] system 00:05: [io  0x0c80-0x0caf] has been reserved
[    1.351007] system 00:05: [io  0x0cc0-0x0cff] could not be reserved
[    1.357261] system 00:08: [mem 0xfed00000-0xfed003ff] has been reserved
[    1.363859] system 00:0a: [io  0x0cb0-0x0cbb] has been reserved
[    1.369762] system 00:0a: [mem 0xfed40000-0xfed44fff] has been reserved
[    1.376361] system 00:0b: [io  0x0900-0x097f] has been reserved
[    1.382270] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    1.388176] system 00:0c: [io  0xf400-0xf4fe] has been reserved
[    1.394079] system 00:0c: [io  0x1080-0x10bf] has been reserved
[    1.399982] system 00:0c: [io  0x10c0-0x10df] has been reserved
[    1.405887] system 00:0c: [io  0x0809] has been reserved
[    1.411189] system 00:0d: [mem 0x00000000-0x0009efff] could not be reserved
[    1.418133] system 00:0d: [mem 0x0009f000-0x0009ffff] could not be reserved
[    1.425075] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
[    1.431671] system 00:0d: [mem 0x000e0000-0x000fffff] has been reserved
[    1.438268] system 00:0d: [mem 0x00100000-0xdf65a7ff] could not be reserved
[    1.445210] system 00:0d: [mem 0xdf65a800-0xdf6fffff] has been reserved
[    1.451805] system 00:0d: [mem 0xdf700000-0xdf7fffff] has been reserved
[    1.458401] system 00:0d: [mem 0xdf700000-0xdfefffff] could not be reserved
[    1.465364] system 00:0d: [mem 0xffe00000-0xffffffff] has been reserved
[    1.471961] system 00:0d: [mem 0xffa00000-0xffbfffff] has been reserved
[    1.478557] system 00:0d: [mem 0xfec00000-0xfec0ffff] could not be reserved
[    1.485499] system 00:0d: [mem 0xfee00000-0xfee0ffff] has been reserved
[    1.492094] system 00:0d: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.498690] system 00:0d: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.505288] system 00:0d: [mem 0xfeda0000-0xfeda3fff] has been reserved
[    1.511886] system 00:0d: [mem 0xfeda4000-0xfeda4fff] has been reserved
[    1.518482] system 00:0d: [mem 0xfeda5000-0xfeda5fff] has been reserved
[    1.525077] system 00:0d: [mem 0xfeda6000-0xfeda6fff] has been reserved
[    1.531672] system 00:0d: [mem 0xfed18000-0xfed1bfff] has been reserved
[    1.538267] system 00:0d: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.549763] PCI: max bus depth: 2 pci_try_num: 3
[    1.554435] pci 0000:00:1e.0: BAR 9: can't assign mem pref (size 0x4000000)
[    1.561378] pci 0000:00:1c.0: BAR 8: assigned [mem 0xf0200000-0xf03fffff]
[    1.568148] pci 0000:00:1c.0: BAR 9: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    1.575870] pci 0000:00:1c.1: BAR 9: assigned [mem 0xf0600000-0xf07fffff 64bit pref]
[    1.583593] pci 0000:00:1c.5: BAR 9: assigned [mem 0xf0800000-0xf09fffff 64bit pref]
[    1.591316] pci 0000:00:1c.0: BAR 7: assigned [io  0x2000-0x2fff]
[    1.597392] pci 0000:00:1c.1: BAR 7: assigned [io  0x3000-0x3fff]
[    1.603468] pci 0000:00:1c.5: BAR 7: assigned [io  0x4000-0x4fff]
[    1.609544] pci 0000:00:1e.0: BAR 7: assigned [io  0x5000-0x5fff]
[    1.615622] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    1.620836] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    1.626916] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff]
[    1.633687] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    1.641413] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    1.646624] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    1.652704] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    1.659475] pci 0000:00:1c.1:   bridge window [mem 0xf0600000-0xf07fffff 64bit pref]
[    1.667201] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    1.672415] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    1.678495] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff]
[    1.685266] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    1.692993] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    1.698207] pci 0000:00:1c.5:   bridge window [io  0x4000-0x4fff]
[    1.704287] pci 0000:00:1c.5:   bridge window [mem 0xf6900000-0xf69fffff]
[    1.711059] pci 0000:00:1c.5:   bridge window [mem 0xf0800000-0xf09fffff 64bit pref]
[    1.718790] pci 0000:03:01.0: BAR 9: can't assign mem pref (size 0x4000000)
[    1.725756] pci 0000:03:01.0: BAR 10: can't assign mem (size 0x4000000)
[    1.732355] pci 0000:03:01.0: BAR 0: assigned [mem 0xf6800000-0xf6800fff]
[    1.739128] pci 0000:03:01.0: BAR 0: set to [mem 0xf6800000-0xf6800fff] (PCI address [0xf6800000-0xf6800fff]
[    1.748927] pci 0000:03:01.0: BAR 7: assigned [io  0x5000-0x50ff]
[    1.755003] pci 0000:03:01.0: BAR 8: assigned [io  0x5400-0x54ff]
[    1.761078] pci 0000:03:01.0: CardBus bridge to [bus 04-07]
[    1.766636] pci 0000:03:01.0:   bridge window [io  0x5000-0x50ff]
[    1.772718] pci 0000:03:01.0:   bridge window [io  0x5400-0x54ff]
[    1.778797] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
[    1.784011] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    1.790091] pci 0000:00:1e.0:   bridge window [mem 0xf6800000-0xf68fffff]
[    1.796862] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.802942] PCI: No. 2 try to assign unassigned res
[    1.807862] pci 0000:00:1e.0: BAR 9: can't assign mem pref (size 0x4000000)
[    1.814811] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    1.820024] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    1.826104] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff]
[    1.832876] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    1.840604] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    1.845817] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    1.851897] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    1.858669] pci 0000:00:1c.1:   bridge window [mem 0xf0600000-0xf07fffff 64bit pref]
[    1.866396] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    1.871609] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    1.877691] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff]
[    1.884465] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    1.892191] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    1.897405] pci 0000:00:1c.5:   bridge window [io  0x4000-0x4fff]
[    1.903485] pci 0000:00:1c.5:   bridge window [mem 0xf6900000-0xf69fffff]
[    1.910255] pci 0000:00:1c.5:   bridge window [mem 0xf0800000-0xf09fffff 64bit pref]
[    1.917987] pci 0000:03:01.0: BAR 9: can't assign mem pref (size 0x4000000)
[    1.924932] pci 0000:03:01.0: BAR 10: can't assign mem (size 0x4000000)
[    1.931526] pci 0000:03:01.0: CardBus bridge to [bus 04-07]
[    1.937085] pci 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[    1.943163] pci 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[    1.949242] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
[    1.954456] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    1.960538] pci 0000:00:1e.0:   bridge window [mem 0xf6800000-0xf68fffff]
[    1.967308] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.973389] PCI: No. 3 try to assign unassigned res
[    1.978252] release child resource [mem 0xf6800000-0xf6800fff]
[    1.984070] release child resource [mem 0xf68fe800-0xf68fefff]
[    1.989885] release child resource [mem 0xf68ff000-0xf68fffff]
[    1.995701] pci 0000:00:1e.0: resource 8 [mem 0xf6800000-0xf68fffff] released
[    2.002817] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
[    2.008029] pci 0000:00:1e.0:   bridge window [mem disabled]
[    2.013730] pci 0000:00:1e.0: BAR 9: can't assign mem pref (size 0x4000000)
[    2.020675] pci 0000:00:1e.0: BAR 8: can't assign mem (size 0x6000000)
[    2.027185] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    2.032398] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    2.038478] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff]
[    2.045250] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    2.052977] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    2.058190] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    2.064270] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    2.071043] pci 0000:00:1c.1:   bridge window [mem 0xf0600000-0xf07fffff 64bit pref]
[    2.078769] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    2.083982] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    2.090061] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff]
[    2.096833] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    2.104559] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    2.109772] pci 0000:00:1c.5:   bridge window [io  0x4000-0x4fff]
[    2.115852] pci 0000:00:1c.5:   bridge window [mem 0xf6900000-0xf69fffff]
[    2.122624] pci 0000:00:1c.5:   bridge window [mem 0xf0800000-0xf09fffff 64bit pref]
[    2.130355] pci 0000:03:01.0: BAR 9: can't assign mem pref (size 0x4000000)
[    2.137301] pci 0000:03:01.0: BAR 10: can't assign mem (size 0x4000000)
[    2.143896] pci 0000:03:01.0: BAR 0: assigned [mem 0x000a0000-0x000a0fff]
[    2.150669] pci 0000:03:01.0: BAR 0: set to [mem 0x000a0000-0x000a0fff] (PCI address [0xa0000-0xa0fff]
[    2.159949] pci 0000:03:01.4: BAR 0: assigned [mem 0x000a1000-0x000a1fff]
[    2.166720] pci 0000:03:01.4: BAR 0: set to [mem 0x000a1000-0x000a1fff] (PCI address [0xa1000-0xa1fff]
[    2.176000] pci 0000:03:01.4: BAR 1: assigned [mem 0x000a2000-0x000a27ff]
[    2.182772] pci 0000:03:01.4: BAR 1: set to [mem 0x000a2000-0x000a27ff] (PCI address [0xa2000-0xa27ff]
[    2.192052] pci 0000:03:01.0: CardBus bridge to [bus 04-07]
[    2.197610] pci 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[    2.203688] pci 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[    2.209770] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
[    2.214983] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    2.221065] pci 0000:00:1e.0:   bridge window [mem disabled]
[    2.226710] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    2.232803]   alloc irq_desc for 16 on node -1
[    2.236783]   alloc kstat_irqs on node -1
[    2.241236] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.247923] pci 0000:00:1c.0: setting latency timer to 64
[    2.253316]   alloc irq_desc for 17 on node -1
[    2.257306]   alloc kstat_irqs on node -1
[    2.261747] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.268431] pci 0000:00:1c.1: setting latency timer to 64
[    2.273824]   alloc irq_desc for 19 on node -1
[    2.277815]   alloc kstat_irqs on node -1
[    2.282255] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.288940] pci 0000:00:1c.3: setting latency timer to 64
[    2.294331] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.301015] pci 0000:00:1c.5: setting latency timer to 64
[    2.306404] pci 0000:00:1e.0: setting latency timer to 64
[    2.311796] pci 0000:03:01.0: enabling device (0000 -> 0003)
[    2.317443] pci 0000:03:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.324131] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.329690] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.335249] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.341498] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    2.347746] pci_bus 0000:00: resource 8 [mem 0xe0000000-0xf7ffffff]
[    2.353996] pci_bus 0000:00: resource 9 [mem 0xfc000000-0xfebfffff]
[    2.360245] pci_bus 0000:00: resource 10 [mem 0xfec10000-0xfecfffff]
[    2.366580] pci_bus 0000:00: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    2.372915] pci_bus 0000:00: resource 12 [mem 0xfed90000-0xfed9ffff]
[    2.379250] pci_bus 0000:00: resource 13 [mem 0xfed40000-0xfed44fff]
[    2.385586] pci_bus 0000:00: resource 14 [mem 0xfeda7000-0xfedfffff]
[    2.391921] pci_bus 0000:00: resource 15 [mem 0xfee10000-0xff9fffff]
[    2.398256] pci_bus 0000:00: resource 16 [mem 0xffc00000-0xffdfffff]
[    2.404592] pci_bus 0000:0b: resource 0 [io  0x2000-0x2fff]
[    2.410148] pci_bus 0000:0b: resource 1 [mem 0xf0200000-0xf03fffff]
[    2.416396] pci_bus 0000:0b: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    2.423597] pci_bus 0000:0c: resource 0 [io  0x3000-0x3fff]
[    2.429152] pci_bus 0000:0c: resource 1 [mem 0xf6c00000-0xf6cfffff]
[    2.435401] pci_bus 0000:0c: resource 2 [mem 0xf0600000-0xf07fffff 64bit pref]
[    2.442602] pci_bus 0000:0d: resource 0 [io  0xd000-0xdfff]
[    2.448158] pci_bus 0000:0d: resource 1 [mem 0xf6a00000-0xf6bfffff]
[    2.454409] pci_bus 0000:0d: resource 2 [mem 0xf0000000-0xf01fffff 64bit pref]
[    2.461610] pci_bus 0000:09: resource 0 [io  0x4000-0x4fff]
[    2.467169] pci_bus 0000:09: resource 1 [mem 0xf6900000-0xf69fffff]
[    2.473417] pci_bus 0000:09: resource 2 [mem 0xf0800000-0xf09fffff 64bit pref]
[    2.480663] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    2.486219] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    2.491775] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    2.497333] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    2.503584] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    2.509834] pci_bus 0000:03: resource 8 [mem 0xe0000000-0xf7ffffff]
[    2.516083] pci_bus 0000:03: resource 9 [mem 0xfc000000-0xfebfffff]
[    2.522332] pci_bus 0000:03: resource 10 [mem 0xfec10000-0xfecfffff]
[    2.528666] pci_bus 0000:03: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    2.535001] pci_bus 0000:03: resource 12 [mem 0xfed90000-0xfed9ffff]
[    2.541336] pci_bus 0000:03: resource 13 [mem 0xfed40000-0xfed44fff]
[    2.547671] pci_bus 0000:03: resource 14 [mem 0xfeda7000-0xfedfffff]
[    2.554007] pci_bus 0000:03: resource 15 [mem 0xfee10000-0xff9fffff]
[    2.560344] pci_bus 0000:03: resource 16 [mem 0xffc00000-0xffdfffff]
[    2.566680] pci_bus 0000:04: resource 0 [io  0x0000-0x00ff]
[    2.572238] pci_bus 0000:04: resource 1 [io  0x0000-0x00ff]
[    2.577822] NET: Registered protocol family 2
[    2.582307] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.590777] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.602627] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    2.609928] TCP: Hash tables configured (established 524288 bind 65536)
[    2.616525] TCP reno registered
[    2.619662] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    2.625700] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    2.632265] NET: Registered protocol family 1
[    2.636638] pci 0000:00:02.0: Boot video device
[    2.641359] PCI: CLS 64 bytes, default 64
[    2.645414] Trying to unpack rootfs image as initramfs...
[    3.750315] Freeing initrd memory: 45970k freed
[    3.780258] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    3.786691] Placing 64MB software IO TLB between ffff880001f1e000 - ffff880005f1e000
[    3.794413] software IO TLB at phys 0x1f1e000 - 0x5f1e000
[    3.800661] Scanning for low memory corruption every 60 seconds
[    3.806849] audit: initializing netlink socket (disabled)
[    3.812248] type=2000 audit(1269876772.812:1): initialized
[    3.831744] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.840364] VFS: Disk quotas dquot_6.5.2
[    3.844348] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.851671] fuse init (API version 7.13)
[    3.856032] Btrfs loaded
[    3.858558] msgmni has been set to 7900
[    3.862717] alg: No test for stdrng (krng)
[    3.866812] io scheduler noop registered
[    3.870753] io scheduler deadline registered
[    3.875137] io scheduler cfq registered (default)
[    3.879944] pcieport 0000:00:1c.0: setting latency timer to 64
[    3.885853]   alloc irq_desc for 24 on node -1
[    3.889761]   alloc kstat_irqs on node -1
[    3.894300] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    3.899670] pcieport 0000:00:1c.1: setting latency timer to 64
[    3.905536]   alloc irq_desc for 25 on node -1
[    3.909485]   alloc kstat_irqs on node -1
[    3.913973] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
[    3.919343] pcieport 0000:00:1c.3: setting latency timer to 64
[    3.925219]   alloc irq_desc for 26 on node -1
[    3.929161]   alloc kstat_irqs on node -1
[    3.933656] pcieport 0000:00:1c.3: irq 26 for MSI/MSI-X
[    3.939024] pcieport 0000:00:1c.5: setting latency timer to 64
[    3.944893]   alloc irq_desc for 27 on node -1
[    3.948841]   alloc kstat_irqs on node -1
[    3.953331] pcieport 0000:00:1c.5: irq 27 for MSI/MSI-X
[    3.958751] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    3.966144] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    3.974993] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    3.981678] pcieport 0000:00:1c.1: Requesting control of PCIe PME from ACPI BIOS
[    3.989053] pcieport 0000:00:1c.1: Failed to receive control of PCIe PME service: no _OSC support
[    3.997901] pcie_pme: probe of 0000:00:1c.1:pcie01 failed with error -13
[    4.004594] pcieport 0000:00:1c.3: Requesting control of PCIe PME from ACPI BIOS
[    4.011971] pcieport 0000:00:1c.3: Failed to receive control of PCIe PME service: no _OSC support
[    4.020819] pcie_pme: probe of 0000:00:1c.3:pcie01 failed with error -13
[    4.027502] pcieport 0000:00:1c.5: Requesting control of PCIe PME from ACPI BIOS
[    4.034877] pcieport 0000:00:1c.5: Failed to receive control of PCIe PME service: no _OSC support
[    4.043725] pcie_pme: probe of 0000:00:1c.5:pcie01 failed with error -13
[    4.050466] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.056128] pciehp 0000:00:1c.0:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.0
[    4.064486] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 283f ss_vid 1028 ss_did 1fe
[    4.073312] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    4.079651] pciehp 0000:00:1c.1:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.1
[    4.087988] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2841 ss_vid 1028 ss_did 1fe
[    4.200010] pciehp 0000:00:1c.1:pcie04: Device 0000:0c:00.0 already exists at 0000:0c:00, cannot hot-add
[    4.209466] pciehp 0000:00:1c.1:pcie04: Cannot add device at 0000:0c:00
[    4.216062] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
[    4.222400] pciehp 0000:00:1c.3:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.3
[    4.230736] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2845 ss_vid 1028 ss_did 1fe
[    4.239548] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
[    4.245888] pciehp 0000:00:1c.5:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.5
[    4.254225] pciehp 0000:00:1c.5:pcie04: HPC vendor_id 8086 device_id 2849 ss_vid 1028 ss_did 1fe
[    4.364009] pciehp 0000:00:1c.5:pcie04: Device 0000:09:00.0 already exists at 0000:09:00, cannot hot-add
[    4.373463] pciehp 0000:00:1c.5:pcie04: Cannot add device at 0000:09:00
[    4.380059] pciehp 0000:00:1c.5:pcie04: service driver pciehp loaded
[    4.386424] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.393282] ACPI: AC Adapter [AC] (on-line)
[    4.397579] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    4.406195] ACPI: Lid Switch [LID]
[    4.409650] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    4.417987] ACPI: Power Button [PBTN]
[    4.421701] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    4.430033] ACPI: Sleep Button [SBTN]
[    4.434104] Monitor-Mwait will be used to enter C-1 state
[    4.439516] Monitor-Mwait will be used to enter C-2 state
[    4.444919] Monitor-Mwait will be used to enter C-3 state
[    4.450315] Marking TSC unstable due to TSC halts in idle
[    4.455730] Switching to clocksource hpet
[    4.492113] thermal LNXTHERM:01: registered as thermal_zone0
[    4.497812] ACPI: Thermal Zone [THM] (73 C)
[    4.536667] ACPI: Battery Slot [BAT0] (battery present)
[    4.536691] Linux agpgart interface v0.103
[    4.536772] ipmi message handler version 39.2
[    4.536781] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.541999] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.562713] ACPI: Battery Slot [BAT1] (battery absent)
[    4.567980] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.575668] brd: module loaded
[    4.579648] loop: module loaded
[    4.583100] ahci 0000:00:1f.2: version 3.0
[    4.587215]   alloc irq_desc for 18 on node -1
[    4.591189]   alloc kstat_irqs on node -1
[    4.595652] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.602469]   alloc irq_desc for 28 on node -1
[    4.606422]   alloc kstat_irqs on node -1
[    4.610910] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    4.615839] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
[    4.623913] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    4.631816] ahci 0000:00:1f.2: setting latency timer to 64
[    4.644062] scsi0 : ahci
[    4.646716] scsi1 : ahci
[    4.649364] scsi2 : ahci
[    4.652193] ata1: SATA max UDMA/133 abar m2048@0xf6dfb800 port 0xf6dfb900 irq 28
[    4.659594] ata2: DUMMY
[    4.662058] ata3: SATA max UDMA/133 abar m2048@0xf6dfb800 port 0xf6dfba00 irq 28
[    4.669516] ata_piix 0000:00:1f.1: version 2.13
[    4.674046] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.681199] ata_piix 0000:00:1f.1: setting latency timer to 64
[    4.687093] scsi3 : ata_piix
[    4.690071] scsi4 : ata_piix
[    4.695146] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
[    4.702097] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
[    4.709144] ata5: port disabled. ignoring.
[    4.713341] Fixed MDIO Bus: probed
[    4.716730] PPP generic driver version 2.4.2
[    4.721182] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.727714]   alloc irq_desc for 22 on node -1
[    4.731694]   alloc kstat_irqs on node -1
[    4.736150] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.743280] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.749101] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.754362] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    4.761773] ehci_hcd 0000:00:1a.7: debug port 1
[    4.770179] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.776963] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    4.797013] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.802880] hub 1-0:1.0: USB hub found
[    4.806633] hub 1-0:1.0: 4 ports detected
[    4.810699]   alloc irq_desc for 20 on node -1
[    4.814633]   alloc kstat_irqs on node -1
[    4.819133] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.826260] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.832082] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.837343] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    4.844750] ehci_hcd 0000:00:1d.7: debug port 1
[    4.853155] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.859938] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    4.876390] ata4.00: ATAPI: Optiarc DVD+/-RW AD-5560A, DD11, max UDMA/33
[    4.885017] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.890871] hub 2-0:1.0: USB hub found
[    4.894619] hub 2-0:1.0: 6 ports detected
[    4.896553] ata4.00: configured for UDMA/33
[    4.902914] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.909166] uhci_hcd: USB Universal Host Controller Interface driver
[    4.915589] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    4.922717] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.928539] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.933804] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    4.941210] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    4.947090] hub 3-0:1.0: USB hub found
[    4.950838] hub 3-0:1.0: 2 ports detected
[    4.954892]   alloc irq_desc for 21 on node -1
[    4.958837]   alloc kstat_irqs on node -1
[    4.963329] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.970454] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.976277] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.981545] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    4.988049] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.988085] ata3: SATA link down (SStatus 0 SControl 300)
[    5.000531] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    5.000827] ata1.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[    5.000829] ata1.00: 976773168 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    5.018983] hub 4-0:1.0: USB hub found
[    5.022735] hub 4-0:1.0: 2 ports detected
[    5.022746] ata1.00: configured for UDMA/133
[    5.031046] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.036115] scsi 0:0:0:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[    5.036353] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.036389] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    5.036439] sd 0:0:0:0: [sda] Write Protect is off
[    5.036441] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.036463] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.077839] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.083675] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.084130] scsi 3:0:0:0: CD-ROM            Optiarc  DVD+-RW AD-5560A DD11 PQ: 0 ANSI: 5
[    5.097030] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    5.104458] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    5.110377]  sda:
[    5.112298] hub 5-0:1.0: USB hub found
[    5.116301] hub 5-0:1.0: 2 ports detected
[    5.120384] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    5.127535] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.133382] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    5.133386] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.133453] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    5.133497] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    5.133642] hub 6-0:1.0: USB hub found
[    5.133645] hub 6-0:1.0: 2 ports detected
[    5.133706] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    5.133714] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.133717] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.133767] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    5.133811] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    5.133955] hub 7-0:1.0: USB hub found
[    5.133959] hub 7-0:1.0: 2 ports detected
[    5.134118] usbcore: registered new interface driver usbserial
[    5.134151] USB Serial support registered for generic
[    5.134171]  sda1 sda2 < sda5
[    5.218360] Uniform CD-ROM driver Revision: 3.20
[    5.218479] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    5.218568] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    5.233517]  sda6 >
[    5.236326] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.400072] usbcore: registered new interface driver usbserial_generic
[    5.406589] usbserial: USB Serial Driver core
[    5.411038] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    5.421585] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.426548] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.431723] mice: PS/2 mouse device common for all mice
[    5.437162] rtc_cmos 00:03: RTC can wake from S4
[    5.441840] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    5.447966] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    5.454983] device-mapper: uevent: version 1.0.3
[    5.459680] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    5.468364] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    5.476867] device-mapper: multipath: version 1.1.1 loaded
[    5.482343] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.489291] cpuidle: using governor ladder
[    5.493878] cpuidle: using governor menu
[    5.498165] TCP cubic registered
[    5.501801] NET: Registered protocol family 10
[    5.506587] lo: Disabled Privacy Extensions
[    5.511082] NET: Registered protocol family 17
[    5.515562] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    5.522518] Bluetooth: L2CAP ver 2.14
[    5.526175] Bluetooth: L2CAP socket layer initialized
[    5.531226] Bluetooth: SCO (Voice Link) ver 0.6
[    5.535765] Bluetooth: SCO socket layer initialized
[    5.540687] Bluetooth: RFCOMM TTY layer initialized
[    5.545560] Bluetooth: RFCOMM socket layer initialized
[    5.550689] Bluetooth: RFCOMM ver 1.11
[    5.555934] PM: Resume from disk failed.
[    5.559863] registered taskstats version 1
[    5.564314]   Magic number: 2:230:539
[    5.568100] rtc_cmos 00:03: setting system clock to 2010-03-29 15:32:56 UTC (1269876776)
[    5.576179] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    5.582171] EDD information not available.
[    5.586431] Freeing unused kernel memory: 820k freed
[    5.591694] Write protecting the kernel read-only data: 10240k
[    5.597755] Freeing unused kernel memory: 364k freed
[    5.603043] Freeing unused kernel memory: 1740k freed
Loading, please wait...
[    5.798025] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    5.818045] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[    5.832673] tg3.c:v3.108 (February 17, 2010)
[    5.832877] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    5.843755] tg3 0000:09:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    5.851245] tg3 0000:09:00.0: setting latency timer to 64
[    5.859506] [drm] Initialized drm 1.1.0 20060810
[    5.861576] ohci1394 0000:03:01.4: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    5.882477] tg3 0000:09:00.0: eth0: Tigon3 [partno(BCM95755m) rev a002] (PCI Express) MAC address 00:22:19:e5:83:a2
[    5.892941] tg3 0000:09:00.0: eth0: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    5.897450] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.897457] i915 0000:00:02.0: setting latency timer to 64
[    5.914304] tg3 0000:09:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    5.922205] tg3 0000:09:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    5.930102] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[a1000-a17ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    5.965362]   alloc irq_desc for 29 on node -1
[    5.969315]   alloc kstat_irqs on node -1
[    5.973859] i915 0000:00:02.0: irq 29 for MSI/MSI-X
[    5.978747] [drm] set up 7M of stolen space
[    5.997070] usb 7-1: new full speed USB device using uhci_hcd and address 2
[    6.165892] hub 7-1:1.0: USB hub found
[    6.170869] hub 7-1:1.0: 4 ports detected
[    6.436256] [drm] initialized overlay support
[    6.458871] usb 7-1.2: new full speed USB device using uhci_hcd and address 3
[    7.139833] fb0: inteldrmfb frame buffer device
[    7.144366] registered panic notifier
[    7.148831] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:01/input/input4
[    7.157991] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[    7.164867] [Firmware Bug]: Duplicate ACPI video bus devices for the same VGA controller, please try module parameter "video.allow_duplicates=1"if the current driver doesn't work.
[    7.180845] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    7.194116] Console: switching to colour frame buffer device 240x75
[    7.217366] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[384fc0001a532da1]
[    7.677326] PM: Starting manual resume from disk
[    7.681947] PM: Resume from partition 8:5
[    7.685957] PM: Checking hibernation image.
[    7.690425] PM: Error -22 checking image file
[    7.694784] PM: Resume from disk failed.
[    7.701556] device fsid aa42dc58a86076ac-da4384233df9d5b0 devid 1 transid 60430 /dev/sda6
init: ureadahead main process (1284) terminated with status 5
fsck from util-linux-ng 2.16
[   15.618479] Adding 4883756k swap on /dev/sda5.  Priority:-1 extents:1 across:4883756k 
/dev/sda1: clean, 195/122880 files, 285597/489948 blocks
fsck from util-linux-ng 2.16
Could not open -a
mountall: fsck / [1305] terminated with status 1
 * Setting preliminary keymap...           ...done.
 * Setting up resolvconf...           ...done.
 * Setting up console font and keymap...           ...done.
 * Debugfs is already mounted on /sys/kernel/debug; nothing to do
 * Starting virtual private network daemon(s)...         * Starting OpenBSD Secure Shell server sshd           ...done.
 * 
 * STARTDISTCC is set to false in /etc/default/distcc
 * /usr/bin/distccd not starting
 * Starting MTA           ...done.
 * ALERT: exim paniclog /var/log/exim4/paniclog has non-zero size, mail system possibly broken
 * Speech-dispatcher configured for user sessions
 * Starting Common Unix Printing System: cupsd           ...done.
 * PulseAudio configured for per-user sessions
 * Enabling additional executable binary formats binfmt-support           ...done.
 * Checking battery state...           ...done.
init: ureadahead main process (1288) terminated with status 5
fsck from util-linux-ng 2.16
[   15.943307] Adding 4883756k swap on /dev/sda5.  Priority:-1 extents:1 across:4883756k 
/dev/sda1: clean, 195/122880 files, 285584/489948 blocks
fsck from util-linux-ng 2.16
Could not open -a
mountall: fsck / [1309] terminated with status 1
 * Setting preliminary keymap...           ...done.
 * Setting up resolvconf...           ...done.
 * Setting up console font and keymap...           ...done.
 * Debugfs is already mounted on /sys/kernel/debug; nothing to do
 * Starting virtual private network daemon(s)...         * Starting OpenBSD Secure Shell server sshd           ...done.
 * 
 * STARTDISTCC is set to false in /etc/default/distcc
 * /usr/bin/distccd not starting
 * Starting MTA           ...done.
 * ALERT: exim paniclog /var/log/exim4/paniclog has non-zero size, mail system possibly broken
 * Speech-dispatcher configured for user sessions
 * Starting Common Unix Printing System: cupsd           ...done.
 * PulseAudio configured for per-user sessions
 * Enabling additional executable binary formats binfmt-support           ...done.
 * Checking battery state...           ...done.
[  260.676154] SysRq : Emergency Remount R/O
[  262.414538] SysRq : Emergency Sync
[  264.055553] SysRq : Show Blocked State
[  265.822089] SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) 
[  269.709956] SysRq : Changing Loglevel
[  269.713637] Loglevel set to 9
[  272.374756] SysRq : Show Blocked State
[  272.378524]   task                        PC stack   pid father
[  272.378713] events/1      D ffff88011b6e7fd8     0    10      2 0x00000000
[  272.378713]  ffff88011b6e7d80 0000000000000046 ffff88011b6e7d10 0000000000015840
[  272.378713]  ffff88011b6e7fd8 0000000000015840 ffff88011b6e7fd8 ffff88011b6e8000
[  272.378713]  0000000000015840 0000000000015840 ffff88011b6e7fd8 0000000000015840
[  272.378713] Call Trace:
[  272.378713]  [<ffffffff81046842>] ? finish_task_switch+0x42/0xc0
[  272.378713]  [<ffffffff81595536>] __mutex_lock_slowpath+0xf6/0x190
[  272.378713]  [<ffffffff814b1020>] ? linkwatch_event+0x0/0x30
[  272.378713]  [<ffffffff8159541b>] mutex_lock+0x2b/0x50
[  272.378713]  [<ffffffff814ae6f5>] rtnl_lock+0x15/0x20
[  272.378713]  [<ffffffff814b102e>] linkwatch_event+0xe/0x30
[  272.378713]  [<ffffffff8107431c>] worker_thread+0x16c/0x2b0
[  272.378713]  [<ffffffff81078860>] ? autoremove_wake_function+0x0/0x40
[  272.378713]  [<ffffffff810741b0>] ? worker_thread+0x0/0x2b0
[  272.378713]  [<ffffffff81078356>] kthread+0x96/0xa0
[  272.469775]  [<ffffffff8100aea4>] kernel_thread_helper+0x4/0x10
[  272.469775]  [<ffffffff810782c0>] ? kthread+0x0/0xa0
[  272.469775]  [<ffffffff8100aea0>] ? kernel_thread_helper+0x0/0x10
[  272.469775] phy0          D ffff880117531fd8     0  1690      2 0x00000000
[  272.469775]  ffff880117531d00 0000000000000046 ffff88010f9d5c00 0000000000015840
[  272.469775]  ffff880117531fd8 0000000000015840 ffff880117531fd8 ffff880111352e20
[  272.469775]  0000000000015840 0000000000015840 ffff880117531fd8 0000000000015840
[  272.469775] Call Trace:
[  272.469775]  [<ffffffff81595536>] __mutex_lock_slowpath+0xf6/0x190
[  272.469775]  [<ffffffff8159541b>] mutex_lock+0x2b/0x50
[  272.469775]  [<ffffffffa01b701c>] cfg80211_send_deauth+0x3c/0x70 [cfg80211]
[  272.469775]  [<ffffffffa028a32c>] ieee80211_sta_work+0x2ec/0x510 [mac80211]
[  272.469775]  [<ffffffff81078b70>] ? prepare_to_wait+0x60/0x90
[  272.469775]  [<ffffffffa028a040>] ? ieee80211_sta_work+0x0/0x510 [mac80211]
[  272.469775]  [<ffffffff8107431c>] worker_thread+0x16c/0x2b0
[  272.469775]  [<ffffffff81078860>] ? autoremove_wake_function+0x0/0x40
[  272.469775]  [<ffffffff810741b0>] ? worker_thread+0x0/0x2b0
[  272.469775]  [<ffffffff81078356>] kthread+0x96/0xa0
[  272.469775]  [<ffffffff8100aea4>] kernel_thread_helper+0x4/0x10
[  272.469775]  [<ffffffff810782c0>] ? kthread+0x0/0xa0
[  272.469775]  [<ffffffff8100aea0>] ? kernel_thread_helper+0x0/0x10
[  272.469775] NetworkManage D ffff88011a56dfd8     0  1923      1 0x00000000
[  272.469775]  ffff88011a56da78 0000000000000086 ffff88011a56da08 0000000000015840
[  272.469775]  ffff88011a56dfd8 0000000000015840 ffff88011a56dfd8 ffff88011a724530
[  272.469775]  0000000000015840 0000000000015840 ffff88011a56dfd8 0000000000015840
[  272.469775] Call Trace:
[  272.469775]  [<ffffffff81595536>] __mutex_lock_slowpath+0xf6/0x190
[  272.469775]  [<ffffffff8104bd12>] ? default_wake_function+0x12/0x20
[  272.469775]  [<ffffffff814980cf>] ? __alloc_skb+0x4f/0x190
[  272.469775]  [<ffffffff81145fd6>] ? pollwake+0x56/0x60
[  272.469775]  [<ffffffff8159541b>] mutex_lock+0x2b/0x50
[  272.469775]  [<ffffffff814ae6f5>] rtnl_lock+0x15/0x20
[  272.469775]  [<ffffffff814ae716>] rtnetlink_rcv+0x16/0x40
[  272.469775]  [<ffffffff814c40c2>] netlink_unicast+0x282/0x2d0
[  272.469775]  [<ffffffff8149b4a5>] ? memcpy_fromiovec+0x75/0x90
[  272.469775]  [<ffffffff814c528e>] netlink_sendmsg+0x1fe/0x2e0
[  272.685338]  [<ffffffff8148f170>] sock_sendmsg+0xe0/0x110
[  272.685338]  [<ffffffff8148f375>] ? move_addr_to_kernel+0x65/0x70
[  272.685338]  [<ffffffff8149b0c8>] ? verify_iovec+0x88/0xe0
[  272.685338]  [<ffffffff81491320>] sys_sendmsg+0x230/0x380
[  272.685338]  [<ffffffff811358b2>] ? do_readv_writev+0x162/0x1f0
[  272.685338]  [<ffffffff81135988>] ? vfs_writev+0x48/0x60
[  272.685338]  [<ffffffff81135ab1>] ? sys_writev+0x51/0xb0
[  272.685338]  [<ffffffff8100a0b2>] system_call_fastpath+0x16/0x1b
[  272.685338] wpa_supplican D ffff88011a4c4530     0  2016      1 0x00000000
[  272.685338]  ffff880110daf738 0000000000000082 ffff880001e16200 0000000000015840
[  272.685338]  ffff880110daffd8 0000000000015840 ffff880110daffd8 ffff88011a4c4530
[  272.685338]  0000000000015840 0000000000015840 ffff880110daffd8 0000000000015840
[  272.685338] Call Trace:
[  272.685338]  [<ffffffff81594d95>] schedule_timeout+0x225/0x300
[  272.685338]  [<ffffffff81078876>] ? autoremove_wake_function+0x16/0x40
[  272.685338]  [<ffffffff810413b9>] ? __wake_up_common+0x59/0x90
[  272.685338]  [<ffffffff81594992>] wait_for_common+0xd2/0x180
[  272.685338]  [<ffffffff8104bd00>] ? default_wake_function+0x0/0x20
[  272.685338]  [<ffffffff81073ba1>] ? __queue_work+0x41/0x50
[  272.685338]  [<ffffffff81594afd>] wait_for_completion+0x1d/0x20
[  272.685338]  [<ffffffff81072b38>] call_usermodehelper_exec+0xe8/0x100
[  272.685338]  [<ffffffff812c35c3>] ? crypto_larval_lookup+0x93/0x180
[  272.685338]  [<ffffffff81072eff>] __request_module+0x16f/0x1f0
[  272.685338]  [<ffffffffa029729f>] ? ieee80211_tx+0xdf/0x230 [mac80211]
[  272.685338]  [<ffffffff812c31d0>] ? __crypto_alg_lookup+0xa0/0x120
[  272.685338]  [<ffffffff812c35c3>] crypto_larval_lookup+0x93/0x180
[  272.685338]  [<ffffffff812c36d3>] crypto_alg_mod_lookup+0x23/0x90
[  272.685338]  [<ffffffff812c37b1>] crypto_alloc_base+0x41/0xb0
[  272.685338]  [<ffffffffa0297e17>] ? ieee80211_subif_start_xmit+0x5c7/0x710 [mac80211]
[  272.685338]  [<ffffffffa028f95f>] ieee80211_aes_key_setup_encrypt+0x2f/0x60 [mac80211]
[  272.685338]  [<ffffffffa0298edd>] ieee80211_key_alloc+0x22d/0x260 [mac80211]
[  272.685338]  [<ffffffffa029118d>] ieee80211_add_key+0x7d/0x110 [mac80211]
[  272.685338]  [<ffffffffa01bc405>] cfg80211_set_encryption+0x395/0x540 [cfg80211]
[  272.685338]  [<ffffffff814b9763>] ? sch_direct_xmit+0x73/0x1a0
[  272.685338]  [<ffffffffa01bc6db>] cfg80211_wext_siwencodeext+0x12b/0x1d0 [cfg80211]
[  272.685338]  [<ffffffff81574da7>] ? ioctl_standard_iw_point+0x177/0x3b0
[  272.685338]  [<ffffffff81574df4>] ioctl_standard_iw_point+0x1c4/0x3b0
[  272.685338]  [<ffffffffa01bc5b0>] ? cfg80211_wext_siwencodeext+0x0/0x1d0 [cfg80211]
[  272.685338]  [<ffffffff815750a1>] ioctl_standard_call+0xc1/0xd0
[  272.685338]  [<ffffffff8149f8c3>] ? __dev_get_by_name+0xa3/0xc0
[  272.685338]  [<ffffffff81574fe0>] ? ioctl_standard_call+0x0/0xd0
[  272.685338]  [<ffffffff815752c3>] T.701+0x163/0x170
[  272.685338]  [<ffffffff8157530f>] wext_handle_ioctl+0x3f/0x90
[  272.685338]  [<ffffffff8112dc95>] ? mem_cgroup_update_file_mapped+0x15/0x60
[  272.685338]  [<ffffffff814a5b26>] dev_ioctl+0x666/0x7d0
[  272.685338]  [<ffffffff81106cd9>] ? __do_fault+0x429/0x510
[  272.685338]  [<ffffffff8148f9d9>] sock_ioctl+0xe9/0x270
[  272.685338]  [<ffffffff8114413d>] vfs_ioctl+0x3d/0xd0
[  272.685338]  [<ffffffff811446ba>] do_vfs_ioctl+0x8a/0x5a0
[  272.685338]  [<ffffffff81144c51>] sys_ioctl+0x81/0xa0
[  272.685338]  [<ffffffff8100a0b2>] system_call_fastpath+0x16/0x1b
[  272.685338] Xorg          D ffff880110ff5c40     0  2036   2018 0x00400004
[  272.685338]  ffff88010f4b9768 0000000000000082 ffff88010f4b96e8 0000000000015840
[  272.685338]  ffff88010f4b9fd8 0000000000015840 ffff88010f4b9fd8 ffff880110ff5c40
[  272.685338]  0000000000015840 0000000000015840 ffff88010f4b9fd8 0000000000015840
[  272.685338] Call Trace:
[  272.685338]  [<ffffffff81594d95>] schedule_timeout+0x225/0x300
[  272.685338]  [<ffffffff81012c3e>] ? __switch_to_xtra+0xae/0x1a0
[  272.685338]  [<ffffffff81594992>] wait_for_common+0xd2/0x180
[  272.685338]  [<ffffffff8104bd00>] ? default_wake_function+0x0/0x20
[  272.685338]  [<ffffffff81594afd>] wait_for_completion+0x1d/0x20
[  272.685338]  [<ffffffff810745e2>] flush_work+0x72/0xb0
[  272.685338]  [<ffffffff81073b10>] ? wq_barrier_func+0x0/0x20
[  272.685338]  [<ffffffff81074672>] flush_delayed_work+0x52/0x70
[  272.685338]  [<ffffffff81375c85>] tty_flush_to_ldisc+0x15/0x20
[  272.685338]  [<ffffffff8137086a>] n_tty_poll+0x7a/0x190
[  272.685338]  [<ffffffff8136bd4a>] tty_poll+0x8a/0xa0
[  272.685338]  [<ffffffff81145b5f>] do_select+0x3af/0x6e0
[  272.685338]  [<ffffffff8107ef25>] ? sched_clock_local+0x25/0x90
[  272.685338]  [<ffffffff81145e90>] ? __pollwait+0x0/0xf0
[  272.685338]  [<ffffffff81145f80>] ? pollwake+0x0/0x60
[  272.685338]  [<ffffffff81145f80>] ? pollwake+0x0/0x60
[  272.685338]  [<ffffffff81145f80>] ? pollwake+0x0/0x60
[  272.685338]  [<ffffffff81145f80>] ? pollwake+0x0/0x60
[  272.685338]  [<ffffffff81145f80>] ? pollwake+0x0/0x60
[  272.685338]  [<ffffffff81145f80>] ? pollwake+0x0/0x60
[  272.685338]  [<ffffffff81145f80>] ? pollwake+0x0/0x60
[  272.685338]  [<ffffffff81145f80>] ? pollwake+0x0/0x60
[  272.685338]  [<ffffffff81145f80>] ? pollwake+0x0/0x60
[  272.685338]  [<ffffffff81146a53>] core_sys_select+0x1c3/0x2f0
[  272.685338]  [<ffffffff811349da>] ? do_sync_read+0xda/0x120
[  272.685338]  [<ffffffff8114413d>] ? vfs_ioctl+0x3d/0xd0
[  272.685338]  [<ffffffff810830a9>] ? ktime_get_ts+0xa9/0xe0
[  272.685338]  [<ffffffff81146dd7>] sys_select+0x47/0x110
[  272.685338]  [<ffffffff8100a0b2>] system_call_fastpath+0x16/0x1b
[  272.685338] gnome-panel   D ffff8800d1995fd8     0  3632   2948 0x00000000
[  272.685338]  ffff8800d1995b18 0000000000000086 0000000000000000 0000000000015840
[  272.685338]  ffff8800d1995fd8 0000000000015840 ffff8800d1995fd8 ffff8801046a2e20
[  272.685338]  0000000000015840 0000000000015840 ffff8800d1995fd8 0000000000015840
[  272.685338] Call Trace:
[  272.685338]  [<ffffffff81595536>] __mutex_lock_slowpath+0xf6/0x190
[  272.685338]  [<ffffffff814980cf>] ? __alloc_skb+0x4f/0x190
[  272.685338]  [<ffffffff8159541b>] mutex_lock+0x2b/0x50
[  272.685338]  [<ffffffff814ae6f5>] rtnl_lock+0x15/0x20
[  272.685338]  [<ffffffff814ae716>] rtnetlink_rcv+0x16/0x40
[  272.685338]  [<ffffffff814c40c2>] netlink_unicast+0x282/0x2d0
[  272.685338]  [<ffffffff8149b4a5>] ? memcpy_fromiovec+0x75/0x90
[  272.685338]  [<ffffffff814c528e>] netlink_sendmsg+0x1fe/0x2e0
[  272.685338]  [<ffffffff8148f170>] sock_sendmsg+0xe0/0x110
[  272.685338]  [<ffffffff8136ae83>] ? extract_entropy+0xe3/0x140
[  272.685338]  [<ffffffff811316d7>] ? __mem_cgroup_commit_charge+0x57/0xa0
[  272.685338]  [<ffffffff8148f2f5>] ? copy_from_user+0x35/0x50
[  272.685338]  [<ffffffff8148fe95>] sys_sendto+0x125/0x180
[  272.685338]  [<ffffffff8159a6e3>] ? do_page_fault+0x193/0x370
[  272.685338]  [<ffffffff8100a0b2>] system_call_fastpath+0x16/0x1b
[  272.685338] gnome-panel   D ffff8800c9819fd8     0  3633   2948 0x00000000
[  272.685338]  ffff8800c9819b18 0000000000000086 0000000000000000 0000000000015840
[  272.685338]  ffff8800c9819fd8 0000000000015840 ffff8800c9819fd8 ffff8801046a1710
[  272.685338]  0000000000015840 0000000000015840 ffff8800c9819fd8 0000000000015840
[  272.685338] Call Trace:
[  272.685338]  [<ffffffff81595536>] __mutex_lock_slowpath+0xf6/0x190
[  272.685338]  [<ffffffff8159541b>] mutex_lock+0x2b/0x50
[  272.685338]  [<ffffffff814ae6f5>] rtnl_lock+0x15/0x20
[  272.685338]  [<ffffffff814ae716>] rtnetlink_rcv+0x16/0x40
[  272.685338]  [<ffffffff814c40c2>] netlink_unicast+0x282/0x2d0
[  272.685338]  [<ffffffff8149b4a5>] ? memcpy_fromiovec+0x75/0x90
[  272.685338]  [<ffffffff814c528e>] netlink_sendmsg+0x1fe/0x2e0
[  272.685338]  [<ffffffff8148f170>] sock_sendmsg+0xe0/0x110
[  272.685338]  [<ffffffff811316d7>] ? __mem_cgroup_commit_charge+0x57/0xa0
[  272.685338]  [<ffffffff8148f2f5>] ? copy_from_user+0x35/0x50
[  272.685338]  [<ffffffff8148fe95>] sys_sendto+0x125/0x180
[  272.685338]  [<ffffffff8159a6e3>] ? do_page_fault+0x193/0x370
[  272.685338]  [<ffffffff8100a0b2>] system_call_fastpath+0x16/0x1b
[  272.685338] gnome-panel   D ffff8800c981bfd8     0  3634   2948 0x00000000
[  272.685338]  ffff8800c981bb18 0000000000000086 0000000000000000 0000000000015840
[  272.685338]  ffff8800c981bfd8 0000000000015840 ffff8800c981bfd8 ffff8801046a4530
[  272.685338]  0000000000015840 0000000000015840 ffff8800c981bfd8 0000000000015840
[  272.685338] Call Trace:
[  272.685338]  [<ffffffff81595536>] __mutex_lock_slowpath+0xf6/0x190
[  272.685338]  [<ffffffff8159541b>] mutex_lock+0x2b/0x50
[  272.685338]  [<ffffffff814ae6f5>] rtnl_lock+0x15/0x20
[  272.685338]  [<ffffffff814ae716>] rtnetlink_rcv+0x16/0x40
[  272.685338]  [<ffffffff814c40c2>] netlink_unicast+0x282/0x2d0
[  272.685338]  [<ffffffff8149b4a5>] ? memcpy_fromiovec+0x75/0x90
[  272.685338]  [<ffffffff814c528e>] netlink_sendmsg+0x1fe/0x2e0
[  272.685338]  [<ffffffff8148f170>] sock_sendmsg+0xe0/0x110
[  272.685338]  [<ffffffff811316d7>] ? __mem_cgroup_commit_charge+0x57/0xa0
[  272.685338]  [<ffffffff8148f2f5>] ? copy_from_user+0x35/0x50
[  272.685338]  [<ffffffff8148fe95>] sys_sendto+0x125/0x180
[  272.685338]  [<ffffffff8159a6e3>] ? do_page_fault+0x193/0x370
[  272.685338]  [<ffffffff8100a0b2>] system_call_fastpath+0x16/0x1b
[  272.685338] gnome-panel   D ffff8800c981dfd8     0  3635   2948 0x00000000
[  272.685338]  ffff8800c981db18 0000000000000086 0000000000000000 0000000000015840
[  272.685338]  ffff8800c981dfd8 0000000000015840 ffff8800c981dfd8 ffff8801046a5c40
[  272.685338]  0000000000015840 0000000000015840 ffff8800c981dfd8 0000000000015840
[  272.685338] Call Trace:
[  272.685338]  [<ffffffff81595536>] __mutex_lock_slowpath+0xf6/0x190
[  272.685338]  [<ffffffff814980cf>] ? __alloc_skb+0x4f/0x190
[  272.685338]  [<ffffffff8159541b>] mutex_lock+0x2b/0x50
[  272.685338]  [<ffffffff814ae6f5>] rtnl_lock+0x15/0x20
[  272.685338]  [<ffffffff814ae716>] rtnetlink_rcv+0x16/0x40
[  272.685338]  [<ffffffff814c40c2>] netlink_unicast+0x282/0x2d0
[  272.685338]  [<ffffffff8149b4a5>] ? memcpy_fromiovec+0x75/0x90
[  272.685338]  [<ffffffff814c528e>] netlink_sendmsg+0x1fe/0x2e0
[  272.685338]  [<ffffffff8148f170>] sock_sendmsg+0xe0/0x110
[  272.685338]  [<ffffffff8113608a>] ? get_empty_filp+0x7a/0x170
[  272.685338]  [<ffffffff8148f2f5>] ? copy_from_user+0x35/0x50
[  272.685338]  [<ffffffff8148fe95>] sys_sendto+0x125/0x180
[  272.685338]  [<ffffffff8113285d>] ? fd_install+0x3d/0x70
[  272.685338]  [<ffffffff8148e4ea>] ? sock_map_fd+0x2a/0x40
[  272.685338]  [<ffffffff8100a0b2>] system_call_fastpath+0x16/0x1b
[  272.685338] modprobe      D ffff8800d9f19710     0  3624   3623 0x00000000
[  272.685338]  ffff8800deebbcd8 0000000000000082 0000000000000001 0000000000015840
[  272.685338]  ffff8800deebbfd8 0000000000015840 ffff8800deebbfd8 ffff8800d9f19710
[  272.685338]  0000000000015840 0000000000015840 ffff8800deebbfd8 0000000000015840
[  272.685338] Call Trace:
[  272.685338]  [<ffffffff81594d95>] schedule_timeout+0x225/0x300
[  272.685338]  [<ffffffff8104bba6>] ? try_to_wake_up+0x2c6/0x420
[  272.685338]  [<ffffffff81044860>] ? __dequeue_entity+0x30/0x50
[  272.685338]  [<ffffffff81594992>] wait_for_common+0xd2/0x180
[  272.685338]  [<ffffffff8104bd00>] ? default_wake_function+0x0/0x20
[  272.685338]  [<ffffffff81594afd>] wait_for_completion+0x1d/0x20
[  272.685338]  [<ffffffff810744bd>] flush_cpu_workqueue+0x5d/0x90
[  272.685338]  [<ffffffff81073b10>] ? wq_barrier_func+0x0/0x20
[  272.685338]  [<ffffffff810746e4>] flush_workqueue+0x54/0x80
[  272.685338]  [<ffffffff810a93b3>] __stop_machine+0xf3/0x110
[  272.685338]  [<ffffffff8108eec0>] ? __unlink_module+0x0/0x40
[  272.685338]  [<ffffffff810a95fe>] stop_machine+0x3e/0x60
[  272.685338]  [<ffffffff81090d7e>] free_module+0x2e/0x140
[  272.685338]  [<ffffffff81094905>] sys_init_module+0x225/0x260
[  272.685338]  [<ffffffff8100a0b2>] system_call_fastpath+0x16/0x1b
[  272.685338] Sched Debug Version: v0.09, 2.6.34-rc2-ben #135
[  272.685338] now at 273745.851174 msecs
[  272.685338]   .jiffies                                 : 4294960730
[  272.685338]   .sysctl_sched_latency                    : 10.000000
[  272.685338]   .sysctl_sched_min_granularity            : 2.000000
[  272.685338]   .sysctl_sched_wakeup_granularity         : 2.000000
[  272.685338]   .sysctl_sched_child_runs_first           : 0.000000
[  272.685338]   .sysctl_sched_features                   : 7917179
[  272.685338]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[  272.685338] 
[  272.685338] cpu#0, 2194.455 MHz
[  272.685338]   .nr_running                    : 2
[  272.685338]   .load                          : 1024
[  272.685338]   .nr_switches                   : 242596
[  272.685338]   .nr_load_updates               : 27736
[  272.685338]   .nr_uninterruptible            : 7
[  272.685338]   .next_balance                  : 4294.960486
[  272.685338]   .curr->pid                     : 0
[  272.685338]   .clock                         : 272685.338953
[  272.685338]   .cpu_load[0]                   : 0
[  272.685338]   .cpu_load[1]                   : 4
[  272.685338]   .cpu_load[2]                   : 22
[  272.685338]   .cpu_load[3]                   : 29
[  272.685338]   .cpu_load[4]                   : 30
[  272.685338]   .yld_count                     : 55752
[  272.685338]   .sched_switch                  : 0
[  272.685338]   .sched_count                   : 319149
[  272.685338]   .sched_goidle                  : 97140
[  272.685338]   .avg_idle                      : 693279
[  272.685338]   .ttwu_count                    : 129489
[  272.685338]   .ttwu_local                    : 65544
[  272.685338]   .bkl_count                     : 1671
[  272.685338] 
[  272.685338] cfs_rq[0]:/sysdefault
[  272.685338]   .exec_clock                    : 17891.742994
[  272.685338]   .MIN_vruntime                  : 22951.990308
[  272.685338]   .min_vruntime                  : 22956.990308
[  272.685338]   .max_vruntime                  : 22951.990308
[  272.685338]   .spread                        : 0.000000
[  272.685338]   .spread0                       : -8392.628262
[  272.685338]   .nr_running                    : 1
[  272.685338]   .load                          : 1024
[  272.685338]   .nr_spread_over                : 13
[  272.685338]   .shares                        : 1024
[  272.685338]   .se->exec_start                : 272276.155858
[  272.685338]   .se->vruntime                  : 31349.618570
[  272.685338]   .se->sum_exec_runtime          : 17891.753453
[  272.685338]   .se->wait_start                : 272685.338953
[  272.685338]   .se->sleep_start               : 0.000000
[  272.685338]   .se->block_start               : 0.000000
[  272.685338]   .se->sleep_max                 : 0.000000
[  272.685338]   .se->block_max                 : 0.000000
[  272.685338]   .se->exec_max                  : 4.090979
[  272.685338]   .se->slice_max                 : 0.281660
[  272.685338]   .se->wait_max                  : 215.563172
[  272.685338]   .se->wait_sum                  : 2214.432223
[  272.685338]   .se->wait_count                : 201424
[  272.685338]   .se->load.weight               : 1024
[  272.685338] 
[  272.685338] cfs_rq[0]:/
[  272.685338]   .exec_clock                    : 21606.096981
[  272.685338]   .MIN_vruntime                  : 31349.618570
[  272.685338]   .min_vruntime                  : 31349.618570
[  272.685338]   .max_vruntime                  : 31349.618570
[  272.685338]   .spread                        : 0.000000
[  272.685338]   .spread0                       : 0.000000
[  272.685338]   .nr_running                    : 1
[  272.685338]   .load                          : 1024
[  272.685338]   .nr_spread_over                : 8
[  272.685338]   .shares                        : 0
[  272.685338] 
[  272.685338] rt_rq[0]:/sysdefault
[  272.685338]   .rt_nr_running                 : 1
[  272.685338]   .rt_throttled                  : 1
[  272.685338]   .rt_time                       : 0.006518
[  272.685338]   .rt_runtime                    : 0.000000
[  272.685338] 
[  272.685338] rt_rq[0]:/
[  272.685338]   .rt_nr_running                 : 0
[  272.685338]   .rt_throttled                  : 0
[  272.685338]   .rt_time                       : 0.000000
[  272.685338]   .rt_runtime                    : 950.000000
[  272.685338] 
[  272.685338] runnable tasks:
[  272.685338]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  272.685338] ----------------------------------------------------------------------------------------------------------
[  272.685338]    flush-btrfs-1  1621     22951.990308       283   120     22951.990308        20.823680    252058.624310 /sysdefault
[  272.685338]          kstop/0  3627     18110.153184         2     0     18110.153184         0.012726         0.000000 /sysdefault
[  272.685338] 
[  272.685338] cpu#1, 2194.455 MHz
[  272.685338]   .nr_running                    : 1
[  272.685338]   .load                          : 0
[  272.685338]   .nr_switches                   : 233270
[  272.685338]   .nr_load_updates               : 27568
[  272.685338]   .nr_uninterruptible            : 3
[  272.685338]   .next_balance                  : 4294.960531
[  272.685338]   .curr->pid                     : 0
[  272.685338]   .clock                         : 273737.702979
[  272.685338]   .cpu_load[0]                   : 1024
[  272.685338]   .cpu_load[1]                   : 897
[  272.685338]   .cpu_load[2]                   : 598
[  272.685338]   .cpu_load[3]                   : 352
[  272.685338]   .cpu_load[4]                   : 195
[  272.685338]   .yld_count                     : 57880
[  272.685338]   .sched_switch                  : 0
[  272.685338]   .sched_count                   : 314008
[  272.685338]   .sched_goidle                  : 94112
[  272.685338]   .avg_idle                      : 666475
[  272.685338]   .ttwu_count                    : 125153
[  272.685338]   .ttwu_local                    : 58181
[  272.685338]   .bkl_count                     : 1607
[  272.685338] 
[  272.685338] cfs_rq[1]:/sysdefault
[  272.685338]   .exec_clock                    : 19220.483167
[  272.685338]   .MIN_vruntime                  : 0.000001
[  272.685338]   .min_vruntime                  : 76954.436651
[  272.685338]   .max_vruntime                  : 0.000001
[  272.685338]   .spread                        : 0.000000
[  272.685338]   .spread0                       : 45604.818081
[  272.685338]   .nr_running                    : 0
[  272.685338]   .load                          : 0
[  272.685338]   .nr_spread_over                : 10
[  272.685338]   .shares                        : 0
[  272.685338]   .se->exec_start                : 273737.702979
[  272.685338]   .se->vruntime                  : 42894.567964
[  272.685338]   .se->sum_exec_runtime          : 19220.488444
[  272.685338]   .se->wait_start                : 0.000000
[  272.685338]   .se->sleep_start               : 0.000000
[  272.685338]   .se->block_start               : 0.000000
[  272.685338]   .se->sleep_max                 : 0.000000
[  272.685338]   .se->block_max                 : 0.000000
[  272.685338]   .se->exec_max                  : 4.132459
[  272.685338]   .se->slice_max                 : 0.035702
[  272.685338]   .se->wait_max                  : 3.976462
[  272.685338]   .se->wait_sum                  : 2032.954442
[  272.685338]   .se->wait_count                : 199954
[  272.685338]   .se->load.weight               : 1024
[  272.685338] 
[  272.685338] cfs_rq[1]:/
[  272.685338]   .exec_clock                    : 28617.059945
[  272.685338]   .MIN_vruntime                  : 0.000001
[  272.685338]   .min_vruntime                  : 42894.567964
[  272.685338]   .max_vruntime                  : 0.000001
[  272.685338]   .spread                        : 0.000000
[  272.685338]   .spread0                       : 11544.949394
[  272.685338]   .nr_running                    : 0
[  272.685338]   .load                          : 0
[  272.685338]   .nr_spread_over                : 5
[  272.685338]   .shares                        : 0
[  272.685338] 
[  272.685338] rt_rq[1]:/sysdefault
[  272.685338]   .rt_nr_running                 : 1
[  272.685338]   .rt_throttled                  : 1
[  272.685338]   .rt_time                       : 0.002282
[  272.685338]   .rt_runtime                    : 0.000000
[  272.685338] 
[  272.685338] rt_rq[1]:/
[  272.685338]   .rt_nr_running                 : 0
[  272.685338]   .rt_throttled                  : 0
[  272.685338]   .rt_time                       : 0.000000
[  272.685338]   .rt_runtime                    : 950.000000
[  272.685338] 
[  272.685338] runnable tasks:
[  272.685338]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  272.685338] ----------------------------------------------------------------------------------------------------------
[  272.685338]          kstop/1  3628     18115.144937         2     0     18115.144937         0.007658         0.000000 /sysdefault
[  272.685338] 
[  277.250133] CE: hpet increased min_delta_ns to 7500 nsec

<#/mml>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:41937 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab0GKW55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 18:57:57 -0400
Received: by pxi14 with SMTP id 14so1546401pxi.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 15:57:56 -0700 (PDT)
Message-ID: <4C3A4C6E.6060801@lwfinger.net>
Date: Sun, 11 Jul 2010 17:57:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, Simon Richter <sjr@debian.org>,
	588196@bugs.debian.org
Subject: Re: Bug#588196: b43: does not join multicast groups
References: <20100706021937.11147.78230.reportbug@debian.hogyros.de> <1278887148.6139.91.camel@localhost>
In-Reply-To: <1278887148.6139.91.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2010 05:25 PM, Ben Hutchings wrote:
> On Tue, 2010-07-06 at 04:19 +0200, Simon Richter wrote:
>> Package: linux-2.6
>> Version: 2.6.34-1~experimental.1
>> Severity: normal
>>
>> Hi,
>>
>> I'm using a B43 based SSB card with LP-PHY, and find myself unable to
>> join an IPv6 network as router advertisements are never seen on my
>> system. ping6 using link-local addresses works fine.
>>
>> The issue persists even if I enable promiscuous mode.
>
> I don't see any changes after 2.6.34 that might address this; therefore
> I'm forwarding this upstream.
>
> Ben.
>
>>     Simon
>>
>> -- Package-specific info:
>> ** Version:
>> Linux version 2.6.34-1-686 (Debian 2.6.34-1~experimental.1) (maks@debian.org) (gcc version 4.3.4 (Debian 4.3.4-10) ) #1 SMP Thu May 20 12:14:21 UTC 2010
>>
>> ** Command line:
>> root=UUID=67d4bec9-8770-46d3-b483-a53af24245f9 ro quiet
>>
>> ** Not tainted
>>
>> ** Kernel log:
>> [    0.000000] Initializing cgroup subsys cpuset
>> [    0.000000] Initializing cgroup subsys cpu
>> [    0.000000] Linux version 2.6.34-1-686 (Debian 2.6.34-1~experimental.1) (maks@debian.org) (gcc version 4.3.4 (Debian 4.3.4-10) ) #1 SMP Thu May 20 12:14:21 UTC 2010
>> [    0.000000] Atom PSE erratum detected, BIOS microcode update recommended
>> [    0.000000] BIOS-provided physical RAM map:
>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>> [    0.000000]  BIOS-e820: 0000000000100000 - 000000003f6d0000 (usable)
>> [    0.000000]  BIOS-e820: 000000003f6d0000 - 000000003f6e2000 (ACPI data)
>> [    0.000000]  BIOS-e820: 000000003f6e2000 - 000000003f6e3000 (ACPI NVS)
>> [    0.000000]  BIOS-e820: 000000003f6e3000 - 0000000040000000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
>> [    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
>> [    0.000000] DMI present.
>> [    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==>  (reserved)
>> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
>> [    0.000000] last_pfn = 0x3f6d0 max_arch_pfn = 0x100000
>> [    0.000000] MTRR default type: uncachable
>> [    0.000000] MTRR fixed ranges enabled:
>> [    0.000000]   00000-9FFFF write-back
>> [    0.000000]   A0000-BFFFF uncachable
>> [    0.000000]   C0000-CFFFF write-protect
>> [    0.000000]   D0000-DFFFF uncachable
>> [    0.000000]   E0000-FFFFF write-protect
>> [    0.000000] MTRR variable ranges enabled:
>> [    0.000000]   0 base 000000000 mask 0C0000000 write-back
>> [    0.000000]   1 base 03F700000 mask 0FFF00000 uncachable
>> [    0.000000]   2 base 03F800000 mask 0FF800000 uncachable
>> [    0.000000]   3 disabled
>> [    0.000000]   4 disabled
>> [    0.000000]   5 disabled
>> [    0.000000]   6 disabled
>> [    0.000000]   7 disabled
>> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>> [    0.000000] initial memory mapped : 0 - 01800000
>> [    0.000000] found SMP MP-table at [c00f7fa0] f7fa0
>> [    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
>> [    0.000000]  0000000000 - 00377fe000 page 4k
>> [    0.000000] kernel direct mapping tables up to 377fe000 @ 100000-1e1000
>> [    0.000000] RAMDISK: 37903000 - 37ff0000
>> [    0.000000] Allocated new RAMDISK: 001d8000 - 008c4269
>> [    0.000000] Move RAMDISK from 0000000037903000 - 0000000037fef268 to 001d8000 - 008c4268
>> [    0.000000] ACPI: RSDP 000f7f70 00024 (v02 PTLTD )
>> [    0.000000] ACPI: XSDT 3f6dc066 0006C (v01 PTLTD  ? XSDT   06040000  LTP 00000000)
>> [    0.000000] ACPI: FACP 3f6e1d48 000F4 (v03 INTEL  CALISTGA 06040000 ALAN 00000001)
>> [    0.000000] ACPI: DSDT 3f6dcf4b 04D89 (v01 INTEL  CALISTGA 06040000 INTL 20050624)
>> [    0.000000] ACPI: FACS 3f6e2fc0 00040
>> [    0.000000] ACPI: APIC 3f6e1e3c 00068 (v01 INTEL  CALISTGA 06040000 LOHR 0000005A)
>> [    0.000000] ACPI: HPET 3f6e1ea4 00038 (v01 INTEL  CALISTGA 06040000 LOHR 0000005A)
>> [    0.000000] ACPI: MCFG 3f6e1edc 0003C (v01 INTEL  CALISTGA 06040000 LOHR 0000005A)
>> [    0.000000] ACPI: TCPA 3f6e1f18 00032 (v01 PTLTD  CALISTGA 06040000  PTL 00000001)
>> [    0.000000] ACPI: TMOR 3f6e1f4a 00026 (v01 PTLTD           06040000 PTL  00000003)
>> [    0.000000] ACPI: APIC 3f6e1f70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
>> [    0.000000] ACPI: BOOT 3f6e1fd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
>> [    0.000000] ACPI: SSDT 3f6dc0d2 004F6 (v02  PmRef    CpuPm 00003000 INTL 20050624)
>> [    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
>> [    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] 126MB HIGHMEM available.
>> [    0.000000] 887MB LOWMEM available.
>> [    0.000000]   mapped low ram: 0 - 377fe000
>> [    0.000000]   low ram: 0 - 377fe000
>> [    0.000000]   node 0 low ram: 00000000 - 377fe000
>> [    0.000000]   node 0 bootmap 00007000 - 0000df00
>> [    0.000000] (13/32 early reservations) ==>  bootmem [0000000000 - 00377fe000]
>> [    0.000000]   #0 [0000001000 - 0000002000]    EX TRAMPOLINE ==>  [0000001000 - 0000002000]
>> [    0.000000]   #1 [0001000000 - 00014cf9c4]    TEXT DATA BSS ==>  [0001000000 - 00014cf9c4]
>> [    0.000000]   #2 [00014d0000 - 00014d6124]              BRK ==>  [00014d0000 - 00014d6124]
>> [    0.000000]   #3 [00000f7fb0 - 0000100000]    BIOS reserved ==>  [00000f7fb0 - 0000100000]
>> [    0.000000]   #4 [00000f7fa0 - 00000f7fb0]     MP-table mpf ==>  [00000f7fa0 - 00000f7fb0]
>> [    0.000000]   #5 [000009f800 - 000009fc71]    BIOS reserved ==>  [000009f800 - 000009fc71]
>> [    0.000000]   #6 [000009fdd1 - 00000f7fa0]    BIOS reserved ==>  [000009fdd1 - 00000f7fa0]
>> [    0.000000]   #7 [000009fc71 - 000009fdd1]     MP-table mpc ==>  [000009fc71 - 000009fdd1]
>> [    0.000000]   #8 [0000002000 - 0000003000]       TRAMPOLINE ==>  [0000002000 - 0000003000]
>> [    0.000000]   #9 [0000003000 - 0000007000]      ACPI WAKEUP ==>  [0000003000 - 0000007000]
>> [    0.000000]   #10 [0000100000 - 00001d8000]          PGTABLE ==>  [0000100000 - 00001d8000]
>> [    0.000000]   #11 [00001d8000 - 00008c5000]      NEW RAMDISK ==>  [00001d8000 - 00008c5000]
>> [    0.000000]   #12 [0000007000 - 000000e000]          BOOTMAP ==>  [0000007000 - 000000e000]
>> [    0.000000] Zone PFN ranges:
>> [    0.000000]   DMA      0x00000001 ->  0x00001000
>> [    0.000000]   Normal   0x00001000 ->  0x000377fe
>> [    0.000000]   HighMem  0x000377fe ->  0x0003f6d0
>> [    0.000000] Movable zone start PFN for each node
>> [    0.000000] early_node_map[2] active PFN ranges
>> [    0.000000]     0: 0x00000001 ->  0x0000009f
>> [    0.000000]     0: 0x00000100 ->  0x0003f6d0
>> [    0.000000] On node 0 totalpages: 259694
>> [    0.000000] free_area_init_node: node 0, pgdat c13b3fc0, node_mem_map c14d8020
>> [    0.000000]   DMA zone: 32 pages used for memmap
>> [    0.000000]   DMA zone: 0 pages reserved
>> [    0.000000]   DMA zone: 3966 pages, LIFO batch:0
>> [    0.000000]   Normal zone: 1744 pages used for memmap
>> [    0.000000]   Normal zone: 221486 pages, LIFO batch:31
>> [    0.000000]   HighMem zone: 254 pages used for memmap
>> [    0.000000]   HighMem zone: 32212 pages, LIFO batch:7
>> [    0.000000] Using APIC driver default
>> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
>> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
>> [    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>> [    0.000000] ACPI: IRQ0 used by override.
>> [    0.000000] ACPI: IRQ2 used by override.
>> [    0.000000] ACPI: IRQ9 used by override.
>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
>> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
>> [    0.000000] nr_irqs_gsi: 24
>> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
>> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
>> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
>> [    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
>> [    0.000000] Booting paravirtualized kernel on bare hardware
>> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
>> [    0.000000] PERCPU: Embedded 14 pages/cpu @c1cce000 s33940 r0 d23404 u65536
>> [    0.000000] pcpu-alloc: s33940 r0 d23404 u65536 alloc=16*4096
>> [    0.000000] pcpu-alloc: [0] 0 [0] 1
>> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257664
>> [    0.000000] Kernel command line: root=UUID=67d4bec9-8770-46d3-b483-a53af24245f9 ro quiet
>> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
>> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
>> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
>> [    0.000000] Enabling fast FPU save and restore... done.
>> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
>> [    0.000000] Initializing CPU#0
>> [    0.000000] Initializing HighMem for node 0 (000377fe:0003f6d0)
>> [    0.000000] Memory: 1016784k/1039168k available (2523k kernel code, 21992k reserved, 1301k data, 380k init, 129864k highmem)
>> [    0.000000] virtual kernel memory layout:
>> [    0.000000]     fixmap  : 0xffd56000 - 0xfffff000   (2724 kB)
>> [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>> [    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
>> [    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
>> [    0.000000]       .init : 0xc13bd000 - 0xc141c000   ( 380 kB)
>> [    0.000000]       .data : 0xc1276d83 - 0xc13bc400   (1301 kB)
>> [    0.000000]       .text : 0xc1000000 - 0xc1276d83   (2523 kB)
>> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
>> [    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
>> [    0.000000] Hierarchical RCU implementation.
>> [    0.000000] NR_IRQS:1280
>> [    0.000000] Extended CMOS year: 2000
>> [    0.000000] Console: colour VGA+ 80x25
>> [    0.000000] console [tty0] enabled
>> [    0.000000] hpet clockevent registered
>> [    0.000000] Fast TSC calibration using PIT
>> [    0.000000] Detected 1596.130 MHz processor.
>> [    0.004009] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.26 BogoMIPS (lpj=6384520)
>> [    0.004059] Security Framework initialized
>> [    0.004067] SELinux:  Disabled at boot.
>> [    0.004083] Mount-cache hash table entries: 512
>> [    0.004318] Initializing cgroup subsys ns
>> [    0.004327] Initializing cgroup subsys cpuacct
>> [    0.004336] Initializing cgroup subsys devices
>> [    0.004342] Initializing cgroup subsys freezer
>> [    0.004347] Initializing cgroup subsys net_cls
>> [    0.004383] Atom PSE erratum detected, BIOS microcode update recommended
>> [    0.004392] CPU: Physical Processor ID: 0
>> [    0.004396] CPU: Processor Core ID: 0
>> [    0.004402] mce: CPU supports 5 MCE banks
>> [    0.004415] CPU0: Thermal monitoring enabled (TM1)
>> [    0.004422] using mwait in idle threads.
>> [    0.004435] Performance Events: Atom events, Intel PMU driver.
>> [    0.004448] ... version:                3
>> [    0.004452] ... bit width:              40
>> [    0.004455] ... generic registers:      2
>> [    0.004460] ... value mask:             000000ffffffffff
>> [    0.004464] ... max period:             000000007fffffff
>> [    0.004468] ... fixed-purpose events:   3
>> [    0.004472] ... event mask:             0000000700000003
>> [    0.008014] Checking 'hlt' instruction... OK.
>> [    0.025383] ACPI: Core revision 20100121
>> [    0.040096] Enabling APIC mode:  Flat.  Using 1 I/O APICs
>> [    0.040574] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> [    0.082098] CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
>> [    0.084000] Booting Node   0, Processors  #1 Ok.
>> [    0.008000] Initializing CPU#1
>> [    0.008000] Atom PSE erratum detected, BIOS microcode update recommended
>> [    0.172028] Brought up 2 CPUs
>> [    0.172037] Total of 2 processors activated (6384.20 BogoMIPS).
>> [    0.172587] devtmpfs: initialized
>> [    0.173213] regulator: core version 0.5
>> [    0.173297] NET: Registered protocol family 16
>> [    0.173506] ACPI: bus type pci registered
>> [    0.173647] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
>> [    0.173656] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
>> [    0.173661] PCI: Using MMCONFIG for extended config space
>> [    0.173665] PCI: Using configuration type 1 for base access
>> [    0.174457] bio: create slab<bio-0>  at 0
>> [    0.176878] ACPI: EC: Look up EC in DSDT
>> [    0.181062] ACPI: BIOS _OSI(Linux) query ignored
>> [    0.183250] ACPI: SSDT 3f6dcc32 00245 (v02  PmRef  Cpu0Ist 00003000 INTL 20050624)
>> [    0.184303] ACPI: SSDT 3f6dc5c8 005E5 (v02  PmRef  Cpu0Cst 00003001 INTL 20050624)
>> [    0.185530] ACPI: SSDT 3f6dce77 000D4 (v02  PmRef  Cpu1Ist 00003000 INTL 20050624)
>> [    0.186276] ACPI: SSDT 3f6dcbad 00085 (v02  PmRef  Cpu1Cst 00003000 INTL 20050624)
>> [    0.240069] ACPI: Interpreter enabled
>> [    0.240085] ACPI: (supports S0 S3 S4 S5)
>> [    0.240136] ACPI: Using IOAPIC for interrupt routing
>> [    0.289266] ACPI: EC: GPE = 0x19, I/O: command/status = 0x66, data = 0x62
>> [    0.289714] ACPI: No dock devices found.
>> [    0.289722] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
>> [    0.290670] ACPI: PCI Root Bridge [PCI0] (0000:00)
>> [    0.292534] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
>> [    0.292542] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
>> [    0.292549] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
>> [    0.292556] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
>> [    0.292562] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
>> [    0.292569] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
>> [    0.292575] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
>> [    0.292582] pci_root PNP0A08:00: host bridge window [mem 0x40000000-0xfebfffff]
>> [    0.292672] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf007ffff]
>> [    0.292681] pci 0000:00:02.0: reg 14: [io  0x1800-0x1807]
>> [    0.292690] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
>> [    0.292699] pci 0000:00:02.0: reg 1c: [mem 0xf0300000-0xf033ffff]
>> [    0.292749] pci 0000:00:02.1: reg 10: [mem 0xf0080000-0xf00fffff]
>> [    0.292879] pci 0000:00:1b.0: reg 10: [mem 0xf0540000-0xf0543fff 64bit]
>> [    0.292956] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
>> [    0.292965] pci 0000:00:1b.0: PME# disabled
>> [    0.293090] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
>> [    0.293098] pci 0000:00:1c.0: PME# disabled
>> [    0.293223] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
>> [    0.293231] pci 0000:00:1c.1: PME# disabled
>> [    0.293356] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
>> [    0.293364] pci 0000:00:1c.2: PME# disabled
>> [    0.293450] pci 0000:00:1d.0: reg 20: [io  0x1820-0x183f]
>> [    0.293533] pci 0000:00:1d.1: reg 20: [io  0x1840-0x185f]
>> [    0.293617] pci 0000:00:1d.2: reg 20: [io  0x1860-0x187f]
>> [    0.293700] pci 0000:00:1d.3: reg 20: [io  0x1880-0x189f]
>> [    0.293779] pci 0000:00:1d.7: reg 10: [mem 0xf0544000-0xf05443ff]
>> [    0.293858] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
>> [    0.293866] pci 0000:00:1d.7: PME# disabled
>> [    0.294058] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
>> [    0.294067] pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
>> [    0.294076] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
>> [    0.294084] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at ff2c (mask 007f)
>> [    0.294094] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0068 (mask 0007)
>> [    0.294157] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
>> [    0.294170] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
>> [    0.294182] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
>> [    0.294195] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
>> [    0.294207] pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
>> [    0.294306] pci 0000:00:1f.3: reg 20: [io  0x18a0-0x18bf]
>> [    0.294477] pci 0000:02:00.0: reg 10: [mem 0xf0100000-0xf01000ff]
>> [    0.294562] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
>> [    0.294727] pci 0000:02:00.2: reg 10: [mem 0xf0100400-0xf01004ff]
>> [    0.294963] pci 0000:02:00.3: reg 10: [mem 0xf0100800-0xf01008ff]
>> [    0.300066] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
>> [    0.300076] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
>> [    0.300085] pci 0000:00:1c.0:   bridge window [mem 0xf0100000-0xf01fffff]
>> [    0.300098] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
>> [    0.300488] pci 0000:03:00.0: reg 10: [mem 0xf0200000-0xf0203fff 64bit]
>> [    0.300715] pci 0000:03:00.0: supports D1 D2
>> [    0.300720] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
>> [    0.300734] pci 0000:03:00.0: PME# disabled
>> [    0.300928] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
>> [    0.300937] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
>> [    0.300946] pci 0000:00:1c.1:   bridge window [mem 0xf0200000-0xf02fffff]
>> [    0.300958] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
>> [    0.301152] pci 0000:04:00.0: reg 10: [io  0x2000-0x20ff]
>> [    0.301248] pci 0000:04:00.0: reg 18: [mem 0xf0610000-0xf0610fff 64bit pref]
>> [    0.301318] pci 0000:04:00.0: reg 20: [mem 0xf0600000-0xf060ffff 64bit pref]
>> [    0.301379] pci 0000:04:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
>> [    0.301555] pci 0000:04:00.0: supports D1 D2
>> [    0.301560] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
>> [    0.301605] pci 0000:04:00.0: PME# disabled
>> [    0.301804] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
>> [    0.301813] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
>> [    0.301822] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
>> [    0.301835] pci 0000:00:1c.2:   bridge window [mem 0xf0600000-0xf06fffff 64bit pref]
>> [    0.301934] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
>> [    0.301943] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
>> [    0.301953] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
>> [    0.301965] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
>> [    0.301972] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
>> [    0.301978] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
>> [    0.301984] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
>> [    0.301999] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
>> [    0.302005] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
>> [    0.302012] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
>> [    0.302018] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
>> [    0.302025] pci 0000:00:1e.0:   bridge window [mem 0x40000000-0xfebfffff] (subtractive decode)
>> [    0.302061] pci_bus 0000:00: on NUMA node 0
>> [    0.302071] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>> [    0.302443] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
>> [    0.302670] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
>> [    0.302823] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
>> [    0.303044] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
>> [    0.316808] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 *7 10 12 14 15)
>> [    0.317001] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
>> [    0.317190] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
>> [    0.317380] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
>> [    0.317571] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
>> [    0.317763] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
>> [    0.317956] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
>> [    0.318146] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 *5 6 7 11 12 14 15)
>> [    0.318380] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
>> [    0.318403] vgaarb: loaded
>> [    0.318447] PCI: Using ACPI for IRQ routing
>> [    0.318447] PCI: pci_cache_line_size set to 64 bytes
>> [    0.318447] reserve RAM buffer: 000000000009f800 - 000000000009ffff
>> [    0.318447] reserve RAM buffer: 000000003f6d0000 - 000000003fffffff
>> [    0.318447] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
>> [    0.318447] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
>> [    0.318447] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
>> [    0.324041] Switching to clocksource tsc
>> [    0.326350] pnp: PnP ACPI init
>> [    0.326386] ACPI: bus type pnp registered
>> [    0.348153] pnp: PnP ACPI: found 11 devices
>> [    0.348159] ACPI: ACPI bus type pnp unregistered
>> [    0.348167] PnPBIOS: Disabled by ACPI PNP
>> [    0.348197] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
>> [    0.348205] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
>> [    0.348212] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
>> [    0.348219] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
>> [    0.348226] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
>> [    0.348233] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
>> [    0.348240] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
>> [    0.348247] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
>> [    0.348262] system 00:04: [mem 0xfed00000-0xfed003ff] has been reserved
>> [    0.348277] system 00:06: [io  0x0680-0x069f] has been reserved
>> [    0.348284] system 00:06: [io  0x0800-0x080f] has been reserved
>> [    0.348291] system 00:06: [io  0x1000-0x107f] has been reserved
>> [    0.348297] system 00:06: [io  0x1180-0x11bf] has been reserved
>> [    0.348304] system 00:06: [io  0x1640-0x164f] has been reserved
>> [    0.348311] system 00:06: [io  0xfe00-0xfe7f] has been reserved
>> [    0.348318] system 00:06: [io  0xff00-0xff7f] has been reserved
>> [    0.348330] system 00:07: [io  0x06a0-0x06af] has been reserved
>> [    0.348336] system 00:07: [io  0x06b0-0x06ff] has been reserved
>> [    0.383471] pci 0000:00:1c.0: BAR 15: assigned [mem 0x40000000-0x401fffff pref]
>> [    0.383483] pci 0000:00:1c.1: BAR 15: assigned [mem 0x40200000-0x403fffff 64bit pref]
>> [    0.383491] pci 0000:00:1c.2: BAR 14: assigned [mem 0x40400000-0x407fffff]
>> [    0.383500] pci 0000:00:1c.0: BAR 13: assigned [io  0x3000-0x3fff]
>> [    0.383507] pci 0000:00:1c.1: BAR 13: assigned [io  0x4000-0x4fff]
>> [    0.383515] pci 0000:02:00.0: BAR 6: assigned [mem 0x40000000-0x4000ffff pref]
>> [    0.383522] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
>> [    0.383529] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
>> [    0.383540] pci 0000:00:1c.0:   bridge window [mem 0xf0100000-0xf01fffff]
>> [    0.383549] pci 0000:00:1c.0:   bridge window [mem 0x40000000-0x401fffff pref]
>> [    0.383561] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
>> [    0.383568] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
>> [    0.383578] pci 0000:00:1c.1:   bridge window [mem 0xf0200000-0xf02fffff]
>> [    0.383587] pci 0000:00:1c.1:   bridge window [mem 0x40200000-0x403fffff 64bit pref]
>> [    0.383602] pci 0000:04:00.0: BAR 6: assigned [mem 0xf0620000-0xf063ffff pref]
>> [    0.383607] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
>> [    0.383614] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
>> [    0.383624] pci 0000:00:1c.2:   bridge window [mem 0x40400000-0x407fffff]
>> [    0.383634] pci 0000:00:1c.2:   bridge window [mem 0xf0600000-0xf06fffff 64bit pref]
>> [    0.383646] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
>> [    0.383650] pci 0000:00:1e.0:   bridge window [io  disabled]
>> [    0.383659] pci 0000:00:1e.0:   bridge window [mem disabled]
>> [    0.383666] pci 0000:00:1e.0:   bridge window [mem pref disabled]
>> [    0.383711] pci 0000:00:1c.0: PCI INT A ->  GSI 17 (level, low) ->  IRQ 17
>> [    0.383720] pci 0000:00:1c.0: setting latency timer to 64
>> [    0.383739] pci 0000:00:1c.1: PCI INT B ->  GSI 16 (level, low) ->  IRQ 16
>> [    0.383749] pci 0000:00:1c.1: setting latency timer to 64
>> [    0.383768] pci 0000:00:1c.2: PCI INT C ->  GSI 18 (level, low) ->  IRQ 18
>> [    0.383776] pci 0000:00:1c.2: setting latency timer to 64
>> [    0.383790] pci 0000:00:1e.0: setting latency timer to 64
>> [    0.383798] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
>> [    0.383804] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
>> [    0.383810] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
>> [    0.383816] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
>> [    0.383821] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
>> [    0.383827] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
>> [    0.383833] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
>> [    0.383839] pci_bus 0000:00: resource 11 [mem 0x40000000-0xfebfffff]
>> [    0.383847] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
>> [    0.383855] pci_bus 0000:02: resource 1 [mem 0xf0100000-0xf01fffff]
>> [    0.383862] pci_bus 0000:02: resource 2 [mem 0x40000000-0x401fffff pref]
>> [    0.383868] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
>> [    0.383874] pci_bus 0000:03: resource 1 [mem 0xf0200000-0xf02fffff]
>> [    0.383880] pci_bus 0000:03: resource 2 [mem 0x40200000-0x403fffff 64bit pref]
>> [    0.383886] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
>> [    0.383892] pci_bus 0000:04: resource 1 [mem 0x40400000-0x407fffff]
>> [    0.383898] pci_bus 0000:04: resource 2 [mem 0xf0600000-0xf06fffff 64bit pref]
>> [    0.383905] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
>> [    0.383910] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
>> [    0.383916] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
>> [    0.383922] pci_bus 0000:05: resource 7 [mem 0x000d0000-0x000d3fff]
>> [    0.383928] pci_bus 0000:05: resource 8 [mem 0x000d4000-0x000d7fff]
>> [    0.383934] pci_bus 0000:05: resource 9 [mem 0x000d8000-0x000dbfff]
>> [    0.383940] pci_bus 0000:05: resource 10 [mem 0x000dc000-0x000dffff]
>> [    0.383946] pci_bus 0000:05: resource 11 [mem 0x40000000-0xfebfffff]
>> [    0.384001] NET: Registered protocol family 2
>> [    0.384127] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
>> [    0.384679] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
>> [    0.385644] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
>> [    0.386100] TCP: Hash tables configured (established 131072 bind 65536)
>> [    0.386107] TCP reno registered
>> [    0.386116] UDP hash table entries: 512 (order: 2, 16384 bytes)
>> [    0.386137] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
>> [    0.386346] NET: Registered protocol family 1
>> [    0.386389] pci 0000:00:02.0: Boot video device
>> [    0.386784] PCI: CLS 64 bytes, default 64
>> [    0.386896] Unpacking initramfs...
>> [    0.763249] Freeing initrd memory: 7092k freed
>> [    0.770033] Simple Boot Flag at 0x36 set to 0x1
>> [    0.770720] audit: initializing netlink socket (disabled)
>> [    0.770746] type=2000 audit(1278020463.767:1): initialized
>> [    0.771065] highmem bounce pool size: 64 pages
>> [    0.771075] HugeTLB registered 4 MB page size, pre-allocated 0 pages
>> [    0.774308] VFS: Disk quotas dquot_6.5.2
>> [    0.774418] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
>> [    0.774596] msgmni has been set to 1746
>> [    0.774982] alg: No test for stdrng (krng)
>> [    0.775113] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
>> [    0.775120] io scheduler noop registered
>> [    0.775124] io scheduler deadline registered
>> [    0.775213] io scheduler cfq registered (default)
>> [    0.775393] pcieport 0000:00:1c.0: setting latency timer to 64
>> [    0.775465] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
>> [    0.775656] pcieport 0000:00:1c.1: setting latency timer to 64
>> [    0.775721] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
>> [    0.775895] pcieport 0000:00:1c.2: setting latency timer to 64
>> [    0.775959] pcieport 0000:00:1c.2: irq 26 for MSI/MSI-X
>> [    0.776164] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
>> [    0.776181] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
>> [    0.776192] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
>> [    0.776202] pcieport 0000:00:1c.1: Requesting control of PCIe PME from ACPI BIOS
>> [    0.776210] pcieport 0000:00:1c.1: Failed to receive control of PCIe PME service: no _OSC support
>> [    0.776218] pcie_pme: probe of 0000:00:1c.1:pcie01 failed with error -13
>> [    0.776227] pcieport 0000:00:1c.2: Requesting control of PCIe PME from ACPI BIOS
>> [    0.776234] pcieport 0000:00:1c.2: Failed to receive control of PCIe PME service: no _OSC support
>> [    0.776242] pcie_pme: probe of 0000:00:1c.2:pcie01 failed with error -13
>> [    0.776480] isapnp: Scanning for PnP cards...
>> [    1.130188] isapnp: No Plug&  Play device found
>> [    1.133880] Linux agpgart interface v0.103
>> [    1.134041] agpgart-intel 0000:00:00.0: Intel 945GME Chipset
>> [    1.134408] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
>> [    1.137095] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
>> [    1.137257] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>> [    1.138035] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
>> [    1.177108] serio: i8042 KBD port at 0x60,0x64 irq 1
>> [    1.177124] serio: i8042 AUX port at 0x60,0x64 irq 12
>> [    1.177379] mice: PS/2 mouse device common for all mice
>> [    1.179147] rtc_cmos 00:08: RTC can wake from S4
>> [    1.179231] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
>> [    1.179277] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
>> [    1.179302] cpuidle: using governor ladder
>> [    1.179307] cpuidle: using governor menu
>> [    1.179316] No iBFT detected.
>> [    1.179896] TCP cubic registered
>> [    1.180273] NET: Registered protocol family 10
>> [    1.181060] lo: Disabled Privacy Extensions
>> [    1.181578] Mobile IPv6
>> [    1.181584] NET: Registered protocol family 17
>> [    1.181614] Using IPI No-Shortcut mode
>> [    1.181804] PM: Resume from disk failed.
>> [    1.181818] registered taskstats version 1
>> [    1.182663] rtc_cmos 00:08: setting system clock to 2010-07-01 21:41:04 UTC (1278020464)
>> [    1.182753] Initalizing network drop monitor service
>> [    1.182857] Freeing unused kernel memory: 380k freed
>> [    1.183141] Write protecting the kernel text: 2524k
>> [    1.183183] Write protecting the kernel read-only data: 924k
>> [    1.213820] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
>> [    1.402848] thermal LNXTHERM:01: registered as thermal_zone0
>> [    1.402868] ACPI: Thermal Zone [TZ01] (40 C)
>> [    2.054768] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
>> [    2.054867] r8169 0000:04:00.0: PCI INT A ->  GSI 18 (level, low) ->  IRQ 18
>> [    2.055022] r8169 0000:04:00.0: setting latency timer to 64
>> [    2.055280] r8169 0000:04:00.0: irq 27 for MSI/MSI-X
>> [    2.056894] r8169 0000:04:00.0: eth0: RTL8102e at 0xf80f8000, 00:21:70:ce:d2:2a, XID 04a00000 IRQ 27
>> [    2.101785] usbcore: registered new interface driver usbfs
>> [    2.101852] usbcore: registered new interface driver hub
>> [    2.101965] usbcore: registered new device driver usb
>> [    2.189005] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>> [    2.189087] ehci_hcd 0000:00:1d.7: PCI INT A ->  GSI 23 (level, low) ->  IRQ 23
>> [    2.189134] ehci_hcd 0000:00:1d.7: setting latency timer to 64
>> [    2.189144] ehci_hcd 0000:00:1d.7: EHCI Host Controller
>> [    2.189201] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
>> [    2.189254] ehci_hcd 0000:00:1d.7: using broken periodic workaround
>> [    2.189275] ehci_hcd 0000:00:1d.7: debug port 1
>> [    2.193166] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
>> [    2.265080] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf0544000
>> [    2.277032] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
>> [    2.277103] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
>> [    2.277113] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.277121] usb usb1: Product: EHCI Host Controller
>> [    2.277128] usb usb1: Manufacturer: Linux 2.6.34-1-686 ehci_hcd
>> [    2.277135] usb usb1: SerialNumber: 0000:00:1d.7
>> [    2.277476] hub 1-0:1.0: USB hub found
>> [    2.277493] hub 1-0:1.0: 8 ports detected
>> [    2.589050] usb 1-2: new high speed USB device using ehci_hcd and address 2
>> [    2.683218] uhci_hcd: USB Universal Host Controller Interface driver
>> [    2.683392] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
>> [    2.683455] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
>> [    2.683475] uhci_hcd 0000:00:1d.0: PCI INT A ->  GSI 23 (level, low) ->  IRQ 23
>> [    2.683497] uhci_hcd 0000:00:1d.0: setting latency timer to 64
>> [    2.683507] uhci_hcd 0000:00:1d.0: UHCI Host Controller
>> [    2.683543] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
>> [    2.683598] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001820
>> [    2.683721] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
>> [    2.683730] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.683738] usb usb2: Product: UHCI Host Controller
>> [    2.683744] usb usb2: Manufacturer: Linux 2.6.34-1-686 uhci_hcd
>> [    2.683751] usb usb2: SerialNumber: 0000:00:1d.0
>> [    2.684152] hub 2-0:1.0: USB hub found
>> [    2.684173] hub 2-0:1.0: 2 ports detected
>> [    2.684406] uhci_hcd 0000:00:1d.1: PCI INT B ->  GSI 19 (level, low) ->  IRQ 19
>> [    2.684429] uhci_hcd 0000:00:1d.1: setting latency timer to 64
>> [    2.684438] uhci_hcd 0000:00:1d.1: UHCI Host Controller
>> [    2.684467] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
>> [    2.684534] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001840
>> [    2.684650] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
>> [    2.684660] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.684667] usb usb3: Product: UHCI Host Controller
>> [    2.684673] usb usb3: Manufacturer: Linux 2.6.34-1-686 uhci_hcd
>> [    2.684680] usb usb3: SerialNumber: 0000:00:1d.1
>> [    2.685026] hub 3-0:1.0: USB hub found
>> [    2.685043] hub 3-0:1.0: 2 ports detected
>> [    2.685227] uhci_hcd 0000:00:1d.2: PCI INT C ->  GSI 18 (level, low) ->  IRQ 18
>> [    2.685247] uhci_hcd 0000:00:1d.2: setting latency timer to 64
>> [    2.685256] uhci_hcd 0000:00:1d.2: UHCI Host Controller
>> [    2.685281] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
>> [    2.685351] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
>> [    2.685471] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
>> [    2.685480] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.685488] usb usb4: Product: UHCI Host Controller
>> [    2.685495] usb usb4: Manufacturer: Linux 2.6.34-1-686 uhci_hcd
>> [    2.685502] usb usb4: SerialNumber: 0000:00:1d.2
>> [    2.685880] hub 4-0:1.0: USB hub found
>> [    2.685895] hub 4-0:1.0: 2 ports detected
>> [    2.686126] uhci_hcd 0000:00:1d.3: power state changed by ACPI to D0
>> [    2.686189] uhci_hcd 0000:00:1d.3: power state changed by ACPI to D0
>> [    2.686207] uhci_hcd 0000:00:1d.3: PCI INT D ->  GSI 16 (level, low) ->  IRQ 16
>> [    2.686227] uhci_hcd 0000:00:1d.3: setting latency timer to 64
>> [    2.686236] uhci_hcd 0000:00:1d.3: UHCI Host Controller
>> [    2.686263] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
>> [    2.686330] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001880
>> [    2.686445] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
>> [    2.686454] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [    2.686462] usb usb5: Product: UHCI Host Controller
>> [    2.686469] usb usb5: Manufacturer: Linux 2.6.34-1-686 uhci_hcd
>> [    2.686476] usb usb5: SerialNumber: 0000:00:1d.3
>> [    2.686781] hub 5-0:1.0: USB hub found
>> [    2.686795] hub 5-0:1.0: 2 ports detected
>> [    2.799854] usb 1-2: New USB device found, idVendor=064e, idProduct=a102
>> [    2.799865] usb 1-2: New USB device strings: Mfr=2, Product=1, SerialNumber=0
>> [    2.799874] usb 1-2: Product: Laptop_Integrated_Webcam_0.3M
>> [    2.799881] usb 1-2: Manufacturer: SuYin
>> [    3.156047] usb 5-1: new full speed USB device using uhci_hcd and address 2
>> [    3.335401] usb 5-1: New USB device found, idVendor=413c, idProduct=02b0
>> [    3.335412] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> [    3.335421] usb 5-1: Product: BCM2046 Bluetooth Device
>> [    3.335427] usb 5-1: Manufacturer: Broadcom Corp
>> [    3.335433] usb 5-1: SerialNumber: 002269EA00DE
>> [    3.898258] SCSI subsystem initialized
>> [    4.280501] sdhci: Secure Digital Host Controller Interface driver
>> [    4.280510] sdhci: Copyright(c) Pierre Ossman
>> [    4.300926] sdhci-pci 0000:02:00.0: SDHCI controller found [197b:2382] (rev 0)
>> [    4.300969] sdhci-pci 0000:02:00.0: PCI INT A ->  GSI 16 (level, low) ->  IRQ 16
>> [    4.301093] sdhci-pci 0000:02:00.0: setting latency timer to 64
>> [    4.301844] Registered led device: mmc0::
>> [    4.302114] mmc0: SDHCI controller on PCI [0000:02:00.0] using ADMA
>> [    4.302156] sdhci-pci 0000:02:00.2: SDHCI controller found [197b:2381] (rev 0)
>> [    4.302198] sdhci-pci 0000:02:00.2: PCI INT A ->  GSI 16 (level, low) ->  IRQ 16
>> [    4.302217] sdhci-pci 0000:02:00.2: Refusing to bind to secondary interface.
>> [    4.302233] sdhci-pci 0000:02:00.2: PCI INT A disabled
>> [    4.310143] libata version 3.00 loaded.
>> [    4.321763] ata_piix 0000:00:1f.1: version 2.13
>> [    4.321799] ata_piix 0000:00:1f.1: PCI INT B ->  GSI 19 (level, low) ->  IRQ 19
>> [    4.321887] ata_piix 0000:00:1f.1: setting latency timer to 64
>> [    4.322063] scsi0 : ata_piix
>> [    4.322904] scsi1 : ata_piix
>> [    4.324786] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
>> [    4.324796] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
>> [    4.328145] ata2: port disabled. ignoring.
>> [    4.419058] mmc0: new MMC card at address 0001
>> [    4.457070] mmcblk0: mmc0:0001 AF MC  122 MiB
>> [    4.457199]  mmcblk0: p1
>> [    4.489521] ata1.00: CFA: STEC PATA 8GB, D5221-10, max UDMA/133
>> [    4.489530] ata1.00: 15005088 sectors, multi 0: LBA
>> [    4.497434] ata1.00: configured for UDMA/100
>> [    4.497657] scsi 0:0:0:0: Direct-Access     ATA      STEC PATA 8GB    D522 PQ: 0 ANSI: 5
>> [    4.568362] sd 0:0:0:0: [sda] 15005088 512-byte logical blocks: (7.68 GB/7.15 GiB)
>> [    4.568608] sd 0:0:0:0: [sda] Write Protect is off
>> [    4.568620] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [    4.568719] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> [    4.569333]  sda: sda1
>> [    4.570591] sd 0:0:0:0: [sda] Attached SCSI disk
>> [    5.175260] kjournald starting.  Commit interval 5 seconds
>> [    5.175280] EXT3-fs (sda1): mounted filesystem with ordered data mode
>> [    5.811653] udev: starting version 141
>> [    8.117342] input: PC Speaker as /devices/platform/pcspkr/input/input1
>> [    8.153161] i801_smbus 0000:00:1f.3: PCI INT B ->  GSI 19 (level, low) ->  IRQ 19
>> [    8.153177] ACPI: resource 0000:00:1f.3 [io  0x18a0-0x18bf] conflicts with ACPI region SMBI [??? 0x000018a0-0x000018af flags 0x49]
>> [    8.153187] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>> [    8.517463] Bluetooth: Core ver 2.15
>> [    8.522884] NET: Registered protocol family 31
>> [    8.522892] Bluetooth: HCI device and connection manager initialized
>> [    8.522900] Bluetooth: HCI socket layer initialized
>> [    8.837401] Linux video capture interface: v2.00
>> [    8.844608] jmb38x_ms 0000:02:00.3: PCI INT A ->  GSI 16 (level, low) ->  IRQ 16
>> [    8.844625] jmb38x_ms 0000:02:00.3: setting latency timer to 64
>> [    8.863808] Bluetooth: Generic Bluetooth USB driver ver 0.6
>> [    8.865577] usbcore: registered new interface driver btusb
>> [    9.073009] uvcvideo: Found UVC 1.00 device Laptop_Integrated_Webcam_0.3M (064e:a102)
>> [    9.095152] input: Laptop_Integrated_Webcam_0.3M as /devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.0/input/input2
>> [    9.095240] usbcore: registered new interface driver uvcvideo
>> [    9.095246] USB Video Class driver (v0.1.0)
>> [    9.311319] leds_ss4200: no LED devices found
>> [    9.824092] intel_rng: FWH not detected
>> [    9.904095] compal-laptop: Identified laptop model 'Dell Mini 9'.
>> [    9.918041] compal-laptop: driver 0.2.6 successfully loaded.
>> [   10.000761] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
>> [   10.031878] dell-laptop: Blacklisted hardware detected - not enabling rfkill
>> [   10.748521] b43-pci-bridge 0000:03:00.0: PCI INT A ->  GSI 17 (level, low) ->  IRQ 17
>> [   10.748549] b43-pci-bridge 0000:03:00.0: setting latency timer to 64
>> [   10.772520] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor 0x4243)
>> [   10.772549] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F, vendor 0x4243)
>> [   10.772573] ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
>> [   10.772597] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
>> [   10.872370] ssb: Sonics Silicon Backplane found on PCI device 0000:03:00.0
>> [   11.009241] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input3
>> [   11.009721] ACPI: Lid Switch [LID0]
>> [   11.010191] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input4
>> [   11.010522] ACPI: Power Button [PWRB]
>> [   11.010957] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input5
>> [   11.011274] ACPI: Sleep Button [SLPB]
>> [   11.024053] Monitor-Mwait will be used to enter C-1 state
>> [   11.041306] Monitor-Mwait will be used to enter C-2 state
>> [   11.048032] Monitor-Mwait will be used to enter C-3 state
>> [   11.048057] Marking TSC unstable due to TSC halts in idle
>> [   11.050585] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
>> [   11.050733] ACPI: Power Button [PWRF]
>> [   11.067788] Switching to clocksource hpet
>> [   12.524036] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd04711/0xa00000/0x20000
>> [   12.872262] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
>> [   14.343456] cfg80211: Calling CRDA to update world regulatory domain
>> [   16.225360] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
>> [   16.322859] acpi device:00: registered as cooling_device2
>> [   16.323284] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input8
>> [   16.323421] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
>> [   20.377806] ACPI: AC Adapter [ACAD] (on-line)
>> [   20.536445] ACPI: EC: GPE storm detected, transactions will use polling mode
>> [   20.661328] ACPI: Battery Slot [BAT1] (battery present)
>> [   20.859305] HDA Intel 0000:00:1b.0: PCI INT A ->  GSI 22 (level, low) ->  IRQ 22
>> [   20.859456] HDA Intel 0000:00:1b.0: irq 28 for MSI/MSI-X
>> [   20.859521] HDA Intel 0000:00:1b.0: setting latency timer to 64
>> [   21.080215] phy0: Selected rate control algorithm 'minstrel'
>> [   21.082001] Registered led device: b43-phy0::tx
>> [   21.082070] Registered led device: b43-phy0::rx
>> [   21.082134] Registered led device: b43-phy0::radio
>> [   21.082324] Broadcom 43xx driver loaded [ Features: PMLS, Firmware-ID: FW13 ]
>> [   21.280993] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input9
>> [   22.541029] EXT3-fs (sda1): using internal journal
>> [   23.638269] loop: module loaded
>> [   24.343487] NET: Registered protocol family 15
>> [   24.541323] alg: No test for cipher_null (cipher_null-generic)
>> [   24.541427] alg: No test for ecb(cipher_null) (ecb-cipher_null)
>> [   24.541517] alg: No test for digest_null (digest_null-generic)
>> [   24.541605] alg: No test for compress_null (compress_null-generic)
>> [   25.700500] padlock: VIA PadLock Hash Engine not detected.
>> [   26.372455] padlock: VIA PadLock Hash Engine not detected.
>> [   28.349988] padlock: VIA PadLock not detected.
>> [   34.820268] b43 ssb0:0: firmware: requesting b43/ucode15.fw
>> [   34.840703] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
>> [   34.861071] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
>> [   35.016266] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
>> [   40.562226] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [   40.562777] r8169 0000:04:00.0: eth0: link down
>> [   40.563220] ADDRCONF(NETDEV_UP): eth0: link is not ready
>> [   43.209460] wlan0: deauthenticating from 06:18:4d:49:80:07 by local choice (reason=3)
>> [   43.209812] wlan0: authenticate with 06:18:4d:49:80:07 (try 1)
>> [   43.212491] wlan0: authenticated
>> [   43.213172] wlan0: associate with 06:18:4d:49:80:07 (try 1)
>> [   43.215732] wlan0: RX AssocResp from 06:18:4d:49:80:07 (capab=0x431 status=0 aid=1)
>> [   43.215742] wlan0: associated
>> [   43.218281] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> [   43.218439] cfg80211: Calling CRDA for country: DE
>> [   45.065099] Bluetooth: L2CAP ver 2.14
>> [   45.065106] Bluetooth: L2CAP socket layer initialized
>> [   45.191342] Bluetooth: RFCOMM TTY layer initialized
>> [   45.191356] Bluetooth: RFCOMM socket layer initialized
>> [   45.191362] Bluetooth: RFCOMM ver 1.11
>> [   46.686696] b43-phy0 ERROR: Fatal DMA error: 0x00000800, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
>> [   46.686878] b43-phy0 ERROR: This device does not support DMA on your system. Please use PIO instead.
>> [   46.687041] b43-phy0: Controller RESET (DMA error) ...
>> [   46.900338] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
>> [   52.421312] b43-phy0: Controller restarted
>> [   54.024144] wlan0: no IPv6 routers present
>> [   54.920178] No probe response from AP 06:18:4d:49:80:07 after 500ms, disconnecting.
>> [   54.964212] cfg80211: Calling CRDA to update world regulatory domain
>> [   56.360816] wlan0: authenticate with 06:18:4d:49:80:07 (try 1)
>> [   56.363612] wlan0: authenticated
>> [   56.363672] wlan0: associate with 06:18:4d:49:80:07 (try 1)
>> [   56.366338] wlan0: RX AssocResp from 06:18:4d:49:80:07 (capab=0x431 status=0 aid=1)
>> [   56.366351] wlan0: associated
>> [   67.820276] ACPI Warning: _BQC returned an invalid level (20100121/video-644)
>> [   70.530545] [drm] Initialized drm 1.1.0 20060810
>> [   70.600147] pci 0000:00:02.0: PCI INT A ->  GSI 16 (level, low) ->  IRQ 16
>> [   70.600162] pci 0000:00:02.0: setting latency timer to 64
>> [   70.643287] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
>> [  161.121253] device wlan0 entered promiscuous mode
>> [  179.304185] No probe response from AP 06:18:4d:49:80:07 after 500ms, disconnecting.
>> [  179.624164] b43-phy0 ERROR: MAC suspend failed
>> [  180.064154] b43-phy0 ERROR: MAC suspend failed
>> [  180.081243] cfg80211: Calling CRDA to update world regulatory domain
>> [  182.157138] wlan0: authenticate with 06:18:4d:49:80:07 (try 1)
>> [  182.356188] wlan0: authenticate with 06:18:4d:49:80:07 (try 2)
>> [  182.556200] wlan0: authenticate with 06:18:4d:49:80:07 (try 3)
>> [  182.756182] wlan0: authentication with 06:18:4d:49:80:07 timed out
>> [  199.256153] b43-phy0 ERROR: MAC suspend failed
>> [  212.176142] b43-phy0 ERROR: MAC suspend failed
>> [  212.776164] b43-phy0 ERROR: MAC suspend failed
>> [  239.640171] b43-phy0 ERROR: MAC suspend failed
>> [  240.028146] b43-phy0 ERROR: MAC suspend failed
>> [  240.416165] b43-phy0 ERROR: MAC suspend failed
>> [  240.804181] b43-phy0 ERROR: MAC suspend failed
>> [  241.192161] b43-phy0 ERROR: MAC suspend failed
>> [  241.580183] b43-phy0 ERROR: MAC suspend failed
>> [  241.968183] b43-phy0 ERROR: MAC suspend failed
>> [  252.669784] b43-phy1: Broadcom 4312 WLAN found (core revision 15)
>> [  252.738905] phy1: Selected rate control algorithm 'minstrel'
>> [  252.744804] Registered led device: b43-phy1::tx
>> [  252.746101] Registered led device: b43-phy1::rx
>> [  252.747464] Registered led device: b43-phy1::radio
>> [  252.751118] Broadcom 43xx driver loaded [ Features: PMLS, Firmware-ID: FW13 ]
>> [  252.784267] b43 ssb0:0: firmware: requesting b43/ucode15.fw
>> [  252.803020] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
>> [  252.823455] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
>> [  252.980256] b43-phy1: Loading firmware version 410.2160 (2007-05-26 15:32:10)
>> [  258.513407] b43-phy1 ERROR: Fatal DMA error: 0x00000400, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
>> [  258.513437] b43-phy1 ERROR: This device does not support DMA on your system. Please use PIO instead.
>> [  258.513456] b43-phy1: Controller RESET (DMA error) ...
>> [  258.740369] b43-phy1: Loading firmware version 410.2160 (2007-05-26 15:32:10)
>> [  264.281323] b43-phy1: Controller restarted
>> [  264.282886] ADDRCONF(NETDEV_UP): wlan0: link is not ready

When you get the FATAL DMA error, the controller is reset; however, that is just 
a simple work around that does not work on all systems. To get your system to 
work, you need to load b43 with the following options: pio=1 qos=0 nohwcrypy=1

Larry

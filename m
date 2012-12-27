Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:60497 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2L0XoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 18:44:04 -0500
Received: by mail-ea0-f169.google.com with SMTP id a12so4194876eaa.28
        for <linux-wireless@vger.kernel.org>; Thu, 27 Dec 2012 15:43:59 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 27 Dec 2012 18:43:58 -0500
Message-ID: <CABLZTyB12FX3e_yAoH7XOfhhA-pcv4GqzpfkBDNi64jdh5eCXA@mail.gmail.com> (sfid-20121228_004413_255608_2BA98E79)
Subject: Re: bugreport Connectivity problems with rtl8192cu
From: Alden Page <pagea@allegheny.edu>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ah, I see. Sorry for the mixup.

The output I attached last time was recorded during a hang, rather than
a disconnect. dmesg with an actual disconnect taking place is at the end
of this message.

I think it's worth mentioning that I did a packet capture in Wireshark
and am observing some strange behavior when the connection hangs/drops.
These ARP exchanges happen a few dozen times:
>From router to adapter: Who has 192.168.0.126? Tell 192.168.0.1
>From adapter to router: 192.168.0.126  is at 00:e0:4c:9f:6f:61

After that, the router begins sending the same message to broadcast
instead of directly to the adapter, as though it has not received
the response from the adapter. The adapter continues to reply to these
broadcast messages dozens and dozens of times. After this takes place
for a few minutes, the adapter begins to spam this:

>From adapter to broadcast: Who has 192.168.0.1? Tell 192.168.0.126

This is sent hundreds of times. Sometimes, the router will respond
after a few minutes, and everything will work just fine. More often,
the router doesn't respond, and so the connection is dropped.

Once again, I think it is worth mentioning that this error does
not occur in Windows, so it would be hard for me to believe this
is a problem with the router. I live in a remote area so it isn't
 easy for me to test my adapter on other networks, but I will try
to do so next chance I get in order to confirm that this is indeed
 not some strange incompatibility with my router.

With my limited knowledge of the network stack, I don't even know
if this is"your problem" - is ARP handled by the driver? Also, I would
be happy to upload a packet capture somewhere if it would be of any
assistance.

Anyway, here is the dmesg output with a disconnect included:
alden@pagea-desktop:~$ dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.1 (root@pagea-desktop) (gcc version 4.7.1
(Debian 4.7.1-7) ) #1 SMP Wed Dec 19 22:46:17 EST 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.7.1
root=UUID=6b1da5f8-13bf-4ccc-aeac-a18fdd2239a6 ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e6000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cffaffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cffb0000-0x00000000cffbdfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cffbe000-0x00000000cffdffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cffe0000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000012fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: BIOSTAR Group TA785GE 128M/TA785GE 128M, BIOS
080015  08/19/2009
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcffb0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at
[ffff8800000ff780]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0xcffaffff]
[    0.000000]  [mem 0x00000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcffaffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xcffaffff @ [mem
0x1fffd000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x12fffffff]
[    0.000000]  [mem 0x100000000-0x12fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x12fffffff @ [mem
0xcffae000-0xcffaffff]
[    0.000000] RAMDISK: [mem 0x36aca000-0x3755cfff]
[    0.000000] ACPI: RSDP 00000000000fab40 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000cffb0000 0003C (v01 081909 RSDT1038 20090819
MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cffb0200 00084 (v01 081909 FACP1038 20090819
MSFT 00000097)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has
zero address or length: 0x0000000000000000/0x1 (20120913/tbfadt-598)
[    0.000000] ACPI: DSDT 00000000cffb0450 09C51 (v01  88GCO 88GCO819 00000001
INTL 20051117)
[    0.000000] ACPI: FACS 00000000cffbe000 00040
[    0.000000] ACPI: APIC 00000000cffb0390 0007C (v01 081909 APIC1038 20090819
MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cffb0410 0003C (v01 081909 OEMMCFG  20090819
MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cffbe040 00072 (v01 081909 OEMB1038 20090819
MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cffba0b0 00038 (v01 081909 OEMHPET  20090819
MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000cffba0f0 0088C (v01 A M I  POWERNOW 00000001
AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000012fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x12fffffff]
[    0.000000]   NODE_DATA [mem 0x12fffc000-0x12fffffff]
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD ->
[ffff88012b600000-ffff88012effffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x12fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xcffaffff]
[    0.000000]   node   0: [mem 0x100000000-0x12fffffff]
[    0.000000] On node 0 totalpages: 1048383
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] smpboot: Allowing 6 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cffb0000 - 00000000cffbe000
[    0.000000] PM: Registered nosave memory: 00000000cffbe000 - 00000000cffe0000
[    0.000000] PM: Registered nosave memory: 00000000cffe0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] e820: [mem 0xd0000000-0xffefffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:6
nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88012fc00000 s83776 r8192
d22720 u262144
[    0.000000] pcpu-alloc: s83776 r8192 d22720 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - -
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total
pages: 1031353
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.7.1
root=UUID=6b1da5f8-13bf-4ccc-aeac-a18fdd2239a6 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ c4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ c4000000
[    0.000000] PM: Registered nosave memory: 00000000c4000000 - 00000000c8000000
[    0.000000] Memory: 3982500k/4980736k available (3547k kernel code, 787204k
absent, 211032k reserved, 3171k data, 616k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=6.
[    0.000000] NR_IRQS:33024 nr_irqs:728 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2599.952 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer
frequency.. 5199.90 BogoMIPS (lpj=10399808)
[    0.000007] pid_max: default: 32768 minimum: 301
[    0.000041] Security Framework initialized
[    0.000046] AppArmor: AppArmor disabled by boot time parameter
[    0.000307] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.001621] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002205] Mount-cache hash table entries: 256
[    0.002386] Initializing cgroup subsys cpuacct
[    0.002389] Initializing cgroup subsys devices
[    0.002390] Initializing cgroup subsys freezer
[    0.002392] Initializing cgroup subsys net_cls
[    0.002394] Initializing cgroup subsys blkio
[    0.002395] Initializing cgroup subsys perf_event
[    0.002419] tseg: 0000000000
[    0.002432] CPU: Physical Processor ID: 0
[    0.002432] CPU: Processor Core ID: 0
[    0.002434] mce: CPU supports 6 MCE banks
[    0.002440] LVT offset 0 assigned for vector 0xf9
[    0.002445] process: using AMD E400 aware idle routine
[    0.002448] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.002448] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
[    0.002448] tlb_flushall_shift: 4
[    0.002518] Freeing SMP alternatives: 8k freed
[    0.002814] ACPI: Core revision 20120913
[    0.012992] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.052591] smpboot: CPU0: AMD Phenom(tm) II X4 810 Processor (fam: 10,
model: 04, stepping: 02)
[    0.158407] Performance Events: AMD PMU driver.
[    0.158410] ... version:                0
[    0.158411] ... bit width:              48
[    0.158412] ... generic registers:      4
[    0.158413] ... value mask:             0000ffffffffffff
[    0.158414] ... max period:             00007fffffffffff
[    0.158415] ... fixed-purpose events:   0
[    0.158416] ... event mask:             000000000000000f
[    0.158644] NMI watchdog: enabled on all CPUs, permanently consumes one
hw-PMU counter.
[    0.158744] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.197958] Brought up 4 CPUs
[    0.197960] smpboot: Total of 4 processors activated (20799.61 BogoMIPS)
[    0.201488] devtmpfs: initialized
[    0.204738] PM: Registering ACPI NVS region [mem 0xcffbe000-0xcffdffff]
(139264 bytes)
[    0.204863] regulator-dummy: no parameters
[    0.204924] NET: Registered protocol family 16
[    0.205017] node 0 link 0: io port [1000, ffffff]
[    0.205020] TOM: 00000000d0000000 aka 3328M
[    0.205022] Fam 10h mmconf [mem 0xe0000000-0xefffffff]
[    0.205024] node 0 link 0: mmio [a0000, bffff]
[    0.205027] node 0 link 0: mmio [d0000000, dfffffff]
[    0.205029] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.205030] node 0 link 0: mmio [f0000000, ffefffff]
[    0.205032] TOM2: 0000000130000000 aka 4864M
[    0.205034] bus: [bus 00-07] on node 0 link 0
[    0.205035] bus: 00 [io  0x0000-0xffff]
[    0.205037] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.205038] bus: 00 [mem 0xd0000000-0xdfffffff]
[    0.205039] bus: 00 [mem 0xf0000000-0xffffffff]
[    0.205040] bus: 00 [mem 0x130000000-0xfcffffffff]
[    0.205084] ACPI: bus type pci registered
[    0.205140] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.205142] PCI: not using MMCONFIG
[    0.205143] PCI: Using configuration type 1 for base access
[    0.205144] PCI: Using configuration type 1 for extended access
[    0.205876] bio: create slab <bio-0> at 0
[    0.205959] ACPI: Added _OSI(Module Device)
[    0.205961] ACPI: Added _OSI(Processor Device)
[    0.205962] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.205963] ACPI: Added _OSI(Processor Aggregator Device)
[    0.206580] ACPI: EC: Look up EC in DSDT
[    0.207884] ACPI: Executed 4 blocks of module-level executable AML code
[    0.212325] ACPI: Interpreter enabled
[    0.212331] ACPI: (supports S0 S1 S4 S5)
[    0.212350] ACPI: Using IOAPIC for interrupt routing
[    0.212374] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.213624] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI
motherboard resources
[    0.278722] ACPI: No dock devices found.
[    0.278727] PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
[    0.278814] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.278989] PCI host bridge to bus 0000:00
[    0.278993] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.278995] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.278997] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.278999] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.279001] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.279003] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xdfffffff]
[    0.279005] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
[    0.279016] pci 0000:00:00.0: [1022:9601] type 00 class 0x060000
[    0.279064] pci 0000:00:02.0: [1022:9603] type 01 class 0x060400
[    0.279095] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.279115] pci 0000:00:07.0: [1022:9607] type 01 class 0x060400
[    0.279145] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.279184] pci 0000:00:11.0: [1002:4390] type 00 class 0x01018f
[    0.279203] pci 0000:00:11.0: reg 10: [io  0xc000-0xc007]
[    0.279212] pci 0000:00:11.0: reg 14: [io  0xb000-0xb003]
[    0.279221] pci 0000:00:11.0: reg 18: [io  0xa000-0xa007]
[    0.279231] pci 0000:00:11.0: reg 1c: [io  0x9000-0x9003]
[    0.279240] pci 0000:00:11.0: reg 20: [io  0x8000-0x800f]
[    0.279249] pci 0000:00:11.0: reg 24: [mem 0xfe9ffc00-0xfe9fffff]
[    0.279269] pci 0000:00:11.0: set SATA to AHCI mode
[    0.279315] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.279328] pci 0000:00:12.0: reg 10: [mem 0xfe9fe000-0xfe9fefff]
[    0.279392] pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
[    0.279405] pci 0000:00:12.1: reg 10: [mem 0xfe9fd000-0xfe9fdfff]
[    0.279473] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.279491] pci 0000:00:12.2: reg 10: [mem 0xfe9ff800-0xfe9ff8ff]
[    0.279571] pci 0000:00:12.2: supports D1 D2
[    0.279573] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.279596] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.279609] pci 0000:00:13.0: reg 10: [mem 0xfe9fc000-0xfe9fcfff]
[    0.279672] pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
[    0.279685] pci 0000:00:13.1: reg 10: [mem 0xfe9fb000-0xfe9fbfff]
[    0.279753] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.279772] pci 0000:00:13.2: reg 10: [mem 0xfe9ff400-0xfe9ff4ff]
[    0.279851] pci 0000:00:13.2: supports D1 D2
[    0.279853] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.279879] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.279976] pci 0000:00:14.1: [1002:439c] type 00 class 0x01018a
[    0.279992] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.280001] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.280010] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.280019] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.280028] pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
[    0.280085] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.280106] pci 0000:00:14.2: reg 10: [mem 0xfe9f4000-0xfe9f7fff 64bit]
[    0.280170] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.280185] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.280259] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.280301] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.280314] pci 0000:00:14.5: reg 10: [mem 0xfe9fa000-0xfe9fafff]
[    0.280380] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    0.280395] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    0.280408] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    0.280421] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    0.280436] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    0.280481] pci 0000:01:00.0: [1002:68b8] type 00 class 0x030000
[    0.280493] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.280502] pci 0000:01:00.0: reg 18: [mem 0xfeae0000-0xfeafffff 64bit]
[    0.280508] pci 0000:01:00.0: reg 20: [io  0xd000-0xd0ff]
[    0.280519] pci 0000:01:00.0: reg 30: [mem 0xfeac0000-0xfeadffff pref]
[    0.280545] pci 0000:01:00.0: supports D1 D2
[    0.280563] pci 0000:01:00.1: [1002:aa58] type 00 class 0x040300
[    0.280575] pci 0000:01:00.1: reg 10: [mem 0xfeabc000-0xfeabffff 64bit]
[    0.280623] pci 0000:01:00.1: supports D1 D2
[    0.289794] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.289800] pci 0000:00:02.0:   bridge window [io  0xd000-0xdfff]
[    0.289803] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.289806] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.289847] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.289859] pci 0000:02:00.0: reg 10: [io  0xe800-0xe8ff]
[    0.289879] pci 0000:02:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit pref]
[    0.289891] pci 0000:02:00.0: reg 20: [mem 0xfdff8000-0xfdffbfff 64bit pref]
[    0.289900] pci 0000:02:00.0: reg 30: [mem 0xfebe0000-0xfebfffff pref]
[    0.289947] pci 0000:02:00.0: supports D1 D2
[    0.289948] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.297778] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.297783] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.297786] pci 0000:00:07.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.297789] pci 0000:00:07.0:   bridge window [mem 0xfdf00000-0xfdffffff
64bit pref]
[    0.297853] pci 0000:00:14.4: PCI bridge to [bus 03] (subtractive decode)
[    0.297862] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.297864] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.297866] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff]
(subtractive decode)
[    0.297868] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff]
(subtractive decode)
[    0.297870] pci 0000:00:14.4:   bridge window [mem 0xd0000000-0xdfffffff]
(subtractive decode)
[    0.297872] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff]
(subtractive decode)
[    0.297885] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.298120] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.298157] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.298204] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.298266]  pci0000:00: ACPI _OSC support notification failed, disabling
PCIe ASPM
[    0.298267]  pci0000:00: Unable to request _OSC control (_OSC
support mask: 0x08)
[    0.302685] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)
[    0.302723] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    0.302758] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
[    0.302792] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 *11 12 14 15)
[    0.302826] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0,
disabled.
[    0.302861] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0,
disabled.
[    0.302895] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 *9 10 11 12 14 15)
[    0.302930] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0,
disabled.
[    0.303027] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.303028] vgaarb: loaded
[    0.303029] vgaarb: bridge control possible 0000:01:00.0
[    0.303063] PCI: Using ACPI for IRQ routing
[    0.311500] PCI: pci_cache_line_size set to 64 bytes
[    0.311556] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.311557] e820: reserve RAM buffer [mem 0xcffb0000-0xcfffffff]
[    0.311671] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.311675] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.313693] Switching to clocksource hpet
[    0.315386] pnp: PnP ACPI init
[    0.315398] ACPI: bus type pnp registered
[    0.315494] pnp 00:00: [bus 00-ff]
[    0.315497] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.315499] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.315501] pnp 00:00: [io  0x0d00-0xffff window]
[    0.315503] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.315505] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.315507] pnp 00:00: [mem 0xd0000000-0xdfffffff window]
[    0.315509] pnp 00:00: [mem 0xf0000000-0xfebfffff window]
[    0.315535] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.315616] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.315618] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.315649] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.315689] pnp 00:02: [dma 4]
[    0.315691] pnp 00:02: [io  0x0000-0x000f]
[    0.315693] pnp 00:02: [io  0x0081-0x0083]
[    0.315695] pnp 00:02: [io  0x0087]
[    0.315697] pnp 00:02: [io  0x0089-0x008b]
[    0.315698] pnp 00:02: [io  0x008f]
[    0.315700] pnp 00:02: [io  0x00c0-0x00df]
[    0.315720] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.315729] pnp 00:03: [io  0x0070-0x0071]
[    0.315737] pnp 00:03: [irq 8]
[    0.315758] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.315765] pnp 00:04: [io  0x0061]
[    0.315784] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.315791] pnp 00:05: [io  0x00f0-0x00ff]
[    0.315799] pnp 00:05: [irq 13]
[    0.315819] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.316435] pnp 00:06: [io  0x03f0-0x03f5]
[    0.316437] pnp 00:06: [io  0x03f7]
[    0.316452] pnp 00:06: [irq 6]
[    0.316454] pnp 00:06: [dma 2]
[    0.316498] pnp 00:06: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.316523] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.316543] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.316616] pnp 00:08: [mem 0xfec00000-0xfec00fff]
[    0.316618] pnp 00:08: [mem 0xfee00000-0xfee00fff]
[    0.316647] system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.316650] system 00:08: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.316652] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.316781] pnp 00:09: [io  0x0010-0x001f]
[    0.316783] pnp 00:09: [io  0x0022-0x003f]
[    0.316785] pnp 00:09: [io  0x0062-0x0063]
[    0.316787] pnp 00:09: [io  0x0065-0x006f]
[    0.316789] pnp 00:09: [io  0x0072-0x007f]
[    0.316790] pnp 00:09: [io  0x0080]
[    0.316792] pnp 00:09: [io  0x0084-0x0086]
[    0.316794] pnp 00:09: [io  0x0088]
[    0.316795] pnp 00:09: [io  0x008c-0x008e]
[    0.316797] pnp 00:09: [io  0x0090-0x009f]
[    0.316799] pnp 00:09: [io  0x00a2-0x00bf]
[    0.316800] pnp 00:09: [io  0x00b1]
[    0.316802] pnp 00:09: [io  0x00e0-0x00ef]
[    0.316804] pnp 00:09: [io  0x04d0-0x04d1]
[    0.316806] pnp 00:09: [io  0x040b]
[    0.316807] pnp 00:09: [io  0x04d6]
[    0.316809] pnp 00:09: [io  0x0c00-0x0c01]
[    0.316811] pnp 00:09: [io  0x0c14]
[    0.316812] pnp 00:09: [io  0x0c50-0x0c51]
[    0.316814] pnp 00:09: [io  0x0c52]
[    0.316816] pnp 00:09: [io  0x0c6c]
[    0.316817] pnp 00:09: [io  0x0c6f]
[    0.316819] pnp 00:09: [io  0x0cd0-0x0cd1]
[    0.316821] pnp 00:09: [io  0x0cd2-0x0cd3]
[    0.316823] pnp 00:09: [io  0x0cd4-0x0cd5]
[    0.316824] pnp 00:09: [io  0x0cd6-0x0cd7]
[    0.316826] pnp 00:09: [io  0x0cd8-0x0cdf]
[    0.316829] pnp 00:09: [io  0x0800-0x089f]
[    0.316831] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.316833] pnp 00:09: [io  0x0b00-0x0b0f]
[    0.316834] pnp 00:09: [io  0x0b20-0x0b3f]
[    0.316836] pnp 00:09: [io  0x0900-0x090f]
[    0.316838] pnp 00:09: [io  0x0910-0x091f]
[    0.316840] pnp 00:09: [io  0xfe00-0xfefe]
[    0.316842] pnp 00:09: [io  0x0060-0x005f disabled]
[    0.316843] pnp 00:09: [io  0x0064-0x0063 disabled]
[    0.316845] pnp 00:09: [mem 0xffb80000-0xffbfffff]
[    0.316847] pnp 00:09: [mem 0xfec10000-0xfec1001f]
[    0.316906] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.316909] system 00:09: [io  0x040b] has been reserved
[    0.316911] system 00:09: [io  0x04d6] has been reserved
[    0.316913] system 00:09: [io  0x0c00-0x0c01] has been reserved
[    0.316915] system 00:09: [io  0x0c14] has been reserved
[    0.316918] system 00:09: [io  0x0c50-0x0c51] has been reserved
[    0.316920] system 00:09: [io  0x0c52] has been reserved
[    0.316922] system 00:09: [io  0x0c6c] has been reserved
[    0.316924] system 00:09: [io  0x0c6f] has been reserved
[    0.316926] system 00:09: [io  0x0cd0-0x0cd1] has been reserved
[    0.316929] system 00:09: [io  0x0cd2-0x0cd3] has been reserved
[    0.316931] system 00:09: [io  0x0cd4-0x0cd5] has been reserved
[    0.316933] system 00:09: [io  0x0cd6-0x0cd7] has been reserved
[    0.316936] system 00:09: [io  0x0cd8-0x0cdf] has been reserved
[    0.316939] system 00:09: [io  0x0800-0x089f] has been reserved
[    0.316942] system 00:09: [io  0x0b00-0x0b0f] has been reserved
[    0.316944] system 00:09: [io  0x0b20-0x0b3f] has been reserved
[    0.316946] system 00:09: [io  0x0900-0x090f] has been reserved
[    0.316949] system 00:09: [io  0x0910-0x091f] has been reserved
[    0.316951] system 00:09: [io  0xfe00-0xfefe] has been reserved
[    0.316954] system 00:09: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.316956] system 00:09: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.316959] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.316982] pnp 00:0a: [io  0x0060]
[    0.316984] pnp 00:0a: [io  0x0064]
[    0.316988] pnp 00:0a: [irq 1]
[    0.317018] pnp 00:0a: Plug and Play ACPI device, IDs PNP0303
PNP030b (active)
[    0.317173] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
[    0.317175] pnp 00:0b: [io  0x0a00-0x0a0f]
[    0.317176] pnp 00:0b: [io  0x0a10-0x0a1f]
[    0.317178] pnp 00:0b: [io  0x0a20-0x0a2f]
[    0.317180] pnp 00:0b: [io  0x0a30-0x0a3f]
[    0.317209] system 00:0b: [io  0x0a00-0x0a0f] has been reserved
[    0.317212] system 00:0b: [io  0x0a10-0x0a1f] has been reserved
[    0.317214] system 00:0b: [io  0x0a20-0x0a2f] has been reserved
[    0.317216] system 00:0b: [io  0x0a30-0x0a3f] has been reserved
[    0.317219] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.317804] pnp 00:0c: [io  0x03f8-0x03ff]
[    0.317808] pnp 00:0c: [irq 4]
[    0.317810] pnp 00:0c: [dma 0 disabled]
[    0.317892] pnp 00:0c: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.317922] pnp 00:0d: [mem 0xe0000000-0xefffffff]
[    0.317952] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    0.317954] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.318573] pnp 00:0e: [mem 0x00000000-0x0009ffff]
[    0.318575] pnp 00:0e: [mem 0x000c0000-0x000cffff]
[    0.318577] pnp 00:0e: [mem 0x000e0000-0x000fffff]
[    0.318579] pnp 00:0e: [mem 0x00100000-0xcfffffff]
[    0.318581] pnp 00:0e: [mem 0xfec00000-0xffffffff]
[    0.318613] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.318615] system 00:0e: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.318618] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.318620] system 00:0e: [mem 0x00100000-0xcfffffff] could not be reserved
[    0.318622] system 00:0e: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.318625] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.318723] pnp: PnP ACPI: found 15 devices
[    0.318724] ACPI: ACPI bus type pnp unregistered
[    0.325353] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.325356] pci 0000:00:02.0:   bridge window [io  0xd000-0xdfff]
[    0.325358] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.325361] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.325365] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.325367] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.325369] pci 0000:00:07.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.325372] pci 0000:00:07.0:   bridge window [mem 0xfdf00000-0xfdffffff
64bit pref]
[    0.325375] pci 0000:00:14.4: PCI bridge to [bus 03]
[    0.325406] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.325408] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.325410] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.325412] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.325414] pci_bus 0000:00: resource 8 [mem 0xd0000000-0xdfffffff]
[    0.325416] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.325418] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.325420] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.325422] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.325424] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.325426] pci_bus 0000:02: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.325428] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff
64bit pref]
[    0.325430] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.325432] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.325434] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.325436] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.325438] pci_bus 0000:03: resource 8 [mem 0xd0000000-0xdfffffff]
[    0.325440] pci_bus 0000:03: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.325513] NET: Registered protocol family 2
[    0.326203] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    0.328772] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.329072] TCP: Hash tables configured (established 524288 bind 65536)
[    0.329119] TCP: reno registered
[    0.329129] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.329158] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.329294] NET: Registered protocol family 1
[    0.728908] pci 0000:01:00.0: Boot video device
[    0.728916] PCI: CLS 64 bytes, default 64
[    0.728960] Unpacking initramfs...
[    0.930187] Freeing initrd memory: 10828k freed
[    0.933889] PCI-DMA: Disabling AGP.
[    0.933980] PCI-DMA: aperture base @ c4000000 size 65536 KB
[    0.933981] PCI-DMA: using GART IOMMU.
[    0.933983] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.937424] LVT offset 1 assigned for vector 0x400
[    0.937432] IBS: LVT offset 1 assigned
[    0.937461] perf: AMD IBS detected (0x0000001f)
[    0.937722] audit: initializing netlink socket (disabled)
[    0.937738] type=2000 audit(1356128912.828:1): initialized
[    0.951207] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.951652] VFS: Disk quotas dquot_6.5.2
[    0.951678] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.951757] msgmni has been set to 7928
[    0.952016] alg: No test for stdrng (krng)
[    0.952041] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[    0.952043] io scheduler noop registered
[    0.952044] io scheduler deadline registered
[    0.952062] io scheduler cfq registered (default)
[    0.952156] pcieport 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.952215] pcieport 0000:00:07.0: irq 41 for MSI/MSI-X
[    0.952275] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.952293] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.952294] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.952556] GHES: HEST is not enabled!
[    0.952620] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.973068] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.973442] Linux agpgart interface v0.103
[    0.973534] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.973536] i8042: PNP: PS/2 appears to have AUX port disabled, if this is
incorrect please boot with i8042.nopnp
[    0.973663] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.973751] mousedev: PS/2 mouse device common for all mice
[    0.973787] rtc_cmos 00:03: RTC can wake from S4
[    0.973895] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.973919] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.973927] cpuidle: using governor ladder
[    0.973928] cpuidle: using governor menu
[    0.973966] drop_monitor: Initializing network drop monitor service
[    0.974028] TCP: cubic registered
[    0.974072] NET: Registered protocol family 10
[    0.974255] mip6: Mobile IPv6
[    0.974257] NET: Registered protocol family 17
[    0.974270] Key type dns_resolver registered
[    0.974537] PM: Hibernation image not present or could not be loaded.
[    0.974546] registered taskstats version 1
[    0.975062] rtc_cmos 00:03: setting system clock to 2012-12-21 22:28:33 UTC
(1356128913)
[    0.976175] Freeing unused kernel memory: 616k freed
[    0.976297] Write protecting the kernel read-only data: 6144k
[    0.978225] Freeing unused kernel memory: 540k freed
[    0.980343] Freeing unused kernel memory: 608k freed
[    0.990884] udevd[67]: starting version 175
[    0.996612] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
[    1.002325] SCSI subsystem initialized
[    1.003355] ACPI: bus type scsi registered
[    1.005017] thermal LNXTHERM:00: registered as thermal_zone0
[    1.005021] ACPI: Thermal Zone [THRM] (56 C)
[    1.006424] ACPI: bus type usb registered
[    1.006453] usbcore: registered new interface driver usbfs
[    1.006466] usbcore: registered new interface driver hub
[    1.014045] usbcore: registered new device driver usb
[    1.014438] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.014509] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.014522] ehci_hcd 0000:00:12.2: new USB bus registered, assigned
bus number 1
[    1.014533] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI
dummy qh workaround
[    1.014570] ehci_hcd 0000:00:12.2: debug port 1
[    1.014596] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe9ff800
[    1.017809] libata version 3.00 loaded.
[    1.018399] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.018583] r8169 0000:02:00.0: irq 42 for MSI/MSI-X
[    1.018759] r8169 0000:02:00.0 eth0: RTL8168d/8111d at 0xffffc9000060e000,
00:30:67:1f:7c:6a, XID 081000c0 IRQ 42
[    1.018761] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes, tx
checksumming: ko]
[    1.024279] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.024309] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.024311] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.024314] usb usb1: Product: EHCI Host Controller
[    1.024315] usb usb1: Manufacturer: Linux 3.7.1 ehci_hcd
[    1.024317] usb usb1: SerialNumber: 0000:00:12.2
[    1.024448] hub 1-0:1.0: USB hub found
[    1.024452] hub 1-0:1.0: 6 ports detected
[    1.024954] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    1.024962] ehci_hcd 0000:00:13.2: new USB bus registered, assigned
bus number 2
[    1.024968] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI
dummy qh workaround
[    1.025000] ehci_hcd 0000:00:13.2: debug port 1
[    1.025025] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe9ff400
[    1.029112] Floppy drive(s): fd0 is 1.44M
[    1.036274] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.036299] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.036302] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.036304] usb usb2: Product: EHCI Host Controller
[    1.036306] usb usb2: Manufacturer: Linux 3.7.1 ehci_hcd
[    1.036307] usb usb2: SerialNumber: 0000:00:13.2
[    1.036464] hub 2-0:1.0: USB hub found
[    1.036468] hub 2-0:1.0: 6 ports detected
[    1.036654] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    1.036917] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.036953] scsi0 : pata_atiixp
[    1.037338] scsi1 : pata_atiixp
[    1.037608] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    1.037610] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    1.037661] ahci 0000:00:11.0: version 3.0
[    1.037801] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf
impl SATA mode
[    1.037805] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio
slum part ccc
[    1.038355] scsi2 : ahci
[    1.038429] scsi3 : ahci
[    1.038488] scsi4 : ahci
[    1.038545] scsi5 : ahci
[    1.038585] ata3: SATA max UDMA/133 abar m1024@0xfe9ffc00 port
0xfe9ffd00 irq 22
[    1.038588] ata4: SATA max UDMA/133 abar m1024@0xfe9ffc00 port
0xfe9ffd80 irq 22
[    1.038591] ata5: SATA max UDMA/133 abar m1024@0xfe9ffc00 port
0xfe9ffe00 irq 22
[    1.038593] ata6: SATA max UDMA/133 abar m1024@0xfe9ffc00 port
0xfe9ffe80 irq 22
[    1.038690] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.038698] ohci_hcd 0000:00:12.0: new USB bus registered, assigned
bus number 3
[    1.038727] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe9fe000
[    1.047995] FDC 0 is a post-1991 82077
[    1.096115] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.096118] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.096120] usb usb3: Product: OHCI Host Controller
[    1.096122] usb usb3: Manufacturer: Linux 3.7.1 ohci_hcd
[    1.096123] usb usb3: SerialNumber: 0000:00:12.0
[    1.096253] hub 3-0:1.0: USB hub found
[    1.096261] hub 3-0:1.0: 3 ports detected
[    1.096379] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    1.096385] ohci_hcd 0000:00:12.1: new USB bus registered, assigned
bus number 4
[    1.096401] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe9fd000
[    1.155978] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.155981] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.155983] usb usb4: Product: OHCI Host Controller
[    1.155985] usb usb4: Manufacturer: Linux 3.7.1 ohci_hcd
[    1.155986] usb usb4: SerialNumber: 0000:00:12.1
[    1.156104] hub 4-0:1.0: USB hub found
[    1.156110] hub 4-0:1.0: 3 ports detected
[    1.156213] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.156218] ohci_hcd 0000:00:13.0: new USB bus registered, assigned
bus number 5
[    1.156244] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe9fc000
[    1.208353] ata2.00: ATAPI: ATAPI   iHDP118   4, GL05, max UDMA/33
[    1.215857] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.215860] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.215862] usb usb5: Product: OHCI Host Controller
[    1.215863] usb usb5: Manufacturer: Linux 3.7.1 ohci_hcd
[    1.215865] usb usb5: SerialNumber: 0000:00:13.0
[    1.216041] hub 5-0:1.0: USB hub found
[    1.216047] hub 5-0:1.0: 3 ports detected
[    1.216192] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    1.216197] ohci_hcd 0000:00:13.1: new USB bus registered, assigned
bus number 6
[    1.216212] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe9fb000
[    1.224264] ata2.00: configured for UDMA/33
[    1.226346] scsi 1:0:0:0: CD-ROM            ATAPI    iHDP118   4      GL05
PQ: 0 ANSI: 5
[    1.275752] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.275755] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.275756] usb usb6: Product: OHCI Host Controller
[    1.275758] usb usb6: Manufacturer: Linux 3.7.1 ohci_hcd
[    1.275760] usb usb6: SerialNumber: 0000:00:13.1
[    1.275880] hub 6-0:1.0: USB hub found
[    1.275886] hub 6-0:1.0: 3 ports detected
[    1.275993] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.275999] ohci_hcd 0000:00:14.5: new USB bus registered, assigned
bus number 7
[    1.276014] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe9fa000
[    1.335628] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.335631] usb usb7: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.335633] usb usb7: Product: OHCI Host Controller
[    1.335634] usb usb7: Manufacturer: Linux 3.7.1 ohci_hcd
[    1.335636] usb usb7: SerialNumber: 0000:00:14.5
[    1.335755] hub 7-0:1.0: USB hub found
[    1.335763] hub 7-0:1.0: 2 ports detected
[    1.355599] ata6: SATA link down (SStatus 0 SControl 300)
[    1.355652] ata4: SATA link down (SStatus 0 SControl 300)
[    1.527220] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.527245] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.528125] ata3.00: ATA-8: WDC WD6401AALS-00L3B2, 01.03B01, max UDMA/133
[    1.528128] ata3.00: 1250263728 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.528281] ata3.00: failed to get Identify Device Data, Emask 0x1
[    1.529388] ata3.00: failed to get Identify Device Data, Emask 0x1
[    1.529392] ata3.00: configured for UDMA/133
[    1.529524] scsi 2:0:0:0: Direct-Access     ATA      WDC WD6401AALS-0 01.0
PQ: 0 ANSI: 5
[    1.533247] ata5.00: ATA-8: SAMSUNG HD155UI, 1AQ10001, max UDMA/133
[    1.533250] ata5.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.534842] ata5.00: failed to get Identify Device Data, Emask 0x1
[    1.542516] ata5.00: failed to get Identify Device Data, Emask 0x1
[    1.542521] ata5.00: configured for UDMA/133
[    1.542665] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD155UI  1AQ1
PQ: 0 ANSI: 5
[    1.546801] sd 2:0:0:0: [sda] 1250263728 512-byte logical blocks: (640 GB/596
GiB)
[    1.546844] sd 4:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50
TB/1.36 TiB)
[    1.546871] sd 2:0:0:0: [sda] Write Protect is off
[    1.546874] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.546905] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    1.546917] sd 4:0:0:0: [sdb] Write Protect is off
[    1.546919] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.546942] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    1.548631] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    1.548634] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.548854] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.552709] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    1.552749] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    1.552787] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    1.559768]  sdb: sdb1
[    1.560076] sd 4:0:0:0: [sdb] Attached SCSI disk
[    1.590635]  sda: sda1 sda2 sda3 < sda5 sda6 >
[    1.591144] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.670929] usb 3-3: new low-speed USB device number 2 using ohci_hcd
[    1.837565] usb 3-3: New USB device found, idVendor=093a, idProduct=2510
[    1.837569] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.837571] usb 3-3: Product: USB OPTICAL MOUSE
[    1.837573] usb 3-3: Manufacturer: PIXART
[    1.848589] usbcore: registered new interface driver usbhid
[    1.848591] usbhid: USB HID core driver
[    1.850097] input: PIXART USB OPTICAL MOUSE as
/devices/pci0000:00/0000:00:12.0/usb3/3-3/3-3:1.0/input/input1
[    1.850173] hid-generic 0003:093A:2510.0001: input,hidraw0: USB HID v1.11
Mouse [PIXART USB OPTICAL MOUSE] on usb-0000:00:12.0-3/input0
[    1.934358] tsc: Refined TSC clocksource calibration: 2600.146 MHz
[    1.934363] Switching to clocksource tsc
[    1.954318] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.979297] PM: Starting manual resume from disk
[    1.979301] PM: Hibernation image partition 8:6 present
[    1.979302] PM: Looking for hibernation image.
[    1.979473] PM: Image not found (code -22)
[    1.979476] PM: Hibernation image not present or could not be loaded.
[    2.038231] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts:
(null)
[    2.087861] usb 2-1: New USB device found, idVendor=058f, idProduct=6362
[    2.087865] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.087867] usb 2-1: Product: Mass Storage Device
[    2.087869] usb 2-1: Manufacturer: Generic
[    2.087870] usb 2-1: SerialNumber: 058F63626376
[    2.197794] usb 2-2: new high-speed USB device number 3 using ehci_hcd
[    2.331053] usb 2-2: New USB device found, idVendor=0bda, idProduct=8176
[    2.331056] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.331059] usb 2-2: Product: 802.11n WLAN Adapter
[    2.331060] usb 2-2: Manufacturer: Realtek
[    2.331062] usb 2-2: SerialNumber: 00e04c000001
[    3.174844] udevd[368]: starting version 175
[    3.394924] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    3.394931] ACPI: Power Button [PWRB]
[    3.394989] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    3.394991] ACPI: Power Button [PWRF]
[    3.478934] wmi: Mapper loaded
[    3.518821] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    3.529421] microcode: CPU0: patch_level=0x01000086
[    1.226567] ACPI: Invalid Power Resource to register!
[    3.660683] ACPI Warning: 0x0000000000000b00-0x0000000000000b07 SystemIO
conflicts with Region \SOR1 1 (20120913/utaddress-251)
[    3.660691] ACPI: If an ACPI driver is available for this device, you should
use it instead of the native driver
[    3.667593] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[    3.667653] sp5100_tco: mmio address 0xfec000f0 already in use
[    3.708249] k10temp 0000:00:18.3: unreliable CPU thermal sensor; monitoring
disabled
[    3.736798] EDAC MC: Ver: 3.0.0
[    3.744554] [drm] Initialized drm 1.1.0 20060810
[    3.891425] microcode: failed to load file amd-ucode/microcode_amd.bin
[    3.891477] microcode: CPU1: patch_level=0x01000086
[    3.891487] microcode: CPU2: patch_level=0x01000086
[    3.891497] microcode: CPU3: patch_level=0x01000086
[    3.891545] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.962531] [drm] radeon kernel modesetting enabled.
[    3.962781] [drm] initializing kernel modesetting (JUNIPER 0x1002:0x68B8
0x1682:0x2990).
[    3.962805] [drm] register mmio base: 0xFEAE0000
[    3.962806] [drm] register mmio size: 131072
[    3.967685] ATOM BIOS: JUNIPER
[    3.967707] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 -
0x000000003FFFFFFF (1024M used)
[    3.967709] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 -
0x000000005FFFFFFF
[    3.970812] [drm] Detected VRAM RAM=1024M, BAR=256M
[    3.970816] [drm] RAM width 128bits DDR
[    3.970884] [TTM] Zone  kernel: Available graphics memory: 2030526 kiB
[    3.970886] [TTM] Initializing pool allocator
[    3.970890] [TTM] Initializing DMA pool allocator
[    3.970919] [drm] radeon: 1024M of VRAM memory ready
[    3.970920] [drm] radeon: 512M of GTT memory ready.
[    3.970939] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    3.970940] [drm] Driver supports precise vblank timestamp query.
[    3.970978] radeon 0000:01:00.0: irq 43 for MSI/MSI-X
[    3.970987] radeon 0000:01:00.0: radeon: using MSI.
[    3.971012] [drm] radeon: irq initialized.
[    3.971016] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    3.971776] [drm] probing gen 2 caps for device 1022:9603 = 2/0
[    3.971779] [drm] enabling PCIE gen 2 link speeds, disable with
radeon.pcie_gen2=0
[    3.971844] [drm] Loading JUNIPER Microcode
[    4.023544] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[    4.023640] radeon 0000:01:00.0: WB enabled
[    4.023644] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr
0x0000000040000c00 and cpu addr 0xffff880129bcfc00
[    4.039699] [drm] ring test on 0 succeeded in 1 usecs
[    4.039814] [drm] ib test on ring 0 succeeded in 0 usecs
[    4.040340] [drm] Radeon Display Connectors
[    4.040341] [drm] Connector 0:
[    4.040342] [drm]   DP-1
[    4.040343] [drm]   HPD4
[    4.040345] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448
0x644c 0x644c
[    4.040346] [drm]   Encoders:
[    4.040347] [drm]     DFP1: INTERNAL_UNIPHY2
[    4.040348] [drm] Connector 1:
[    4.040349] [drm]   HDMI-A-1
[    4.040350] [drm]   HPD5
[    4.040351] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438
0x643c 0x643c
[    4.040352] [drm]   Encoders:
[    4.040353] [drm]     DFP2: INTERNAL_UNIPHY2
[    4.040354] [drm] Connector 2:
[    4.040355] [drm]   DVI-I-1
[    4.040356] [drm]   HPD1
[    4.040357] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468
0x646c 0x646c
[    4.040358] [drm]   Encoders:
[    4.040359] [drm]     DFP3: INTERNAL_UNIPHY1
[    4.040360] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    4.040361] [drm] Connector 3:
[    4.040362] [drm]   DVI-I-2
[    4.040363] [drm]   HPD6
[    4.040364] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458
0x645c 0x645c
[    4.040365] [drm]   Encoders:
[    4.040366] [drm]     DFP4: INTERNAL_UNIPHY
[    4.040367] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    4.040405] [drm] Internal thermal controller with fan control
[    4.040438] [drm] radeon: power management initialized
[    4.050697] hda_intel: position_fix set to 1 for device 1565:8218
[    4.081332] MCE: In-kernel MCE decoding enabled.
[    4.081878] AMD64 EDAC driver v3.4.0
[    4.099577] [drm] fb mappable at 0xD0142000
[    4.099579] [drm] vram apper at 0xD0000000
[    4.099580] [drm] size 7299072
[    4.099581] [drm] fb depth is 24
[    4.099582] [drm]    pitch is 6912
[    4.099667] fbcon: radeondrmfb (fb0) is primary device
[    4.176299] kvm: Nested Virtualization enabled
[    4.176302] kvm: Nested Paging enabled
[    4.259156] input: HDA ATI SB Line as
/devices/pci0000:00/0000:00:14.2/sound/card0/input5
[    4.259248] input: HDA ATI SB Front Mic as
/devices/pci0000:00/0000:00:14.2/sound/card0/input6
[    4.259319] input: HDA ATI SB Rear Mic as
/devices/pci0000:00/0000:00:14.2/sound/card0/input7
[    4.259386] input: HDA ATI SB Front Headphone as
/devices/pci0000:00/0000:00:14.2/sound/card0/input8
[    4.259449] input: HDA ATI SB Line Out as
/devices/pci0000:00/0000:00:14.2/sound/card0/input9
[    4.259679] EDAC amd64: DRAM ECC disabled.
[    4.259684] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module
will not load.
[    4.259684]  Either enable ECC checking or force module loading by setting
'ecc_enable_override'.
[    4.259684]  (Note that use of the override may cause unknown side effects.)
[    4.318015] Console: switching to colour frame buffer device 210x65
[    4.325930] fb0: radeondrmfb frame buffer device
[    4.325932] drm: registered panic notifier
[    4.325938] [drm] Initialized radeon 2.24.0 20080528 for
0000:01:00.0 on minor 0
[    4.325998] hda-intel: 0000:01:00.1: Handle VGA-switcheroo audio client
[    4.326058] snd_hda_intel 0000:01:00.1: irq 44 for MSI/MSI-X
[    4.402231] input: HD-Audio Generic HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input10
[    4.590077] Initializing USB Mass Storage driver...
[    4.590174] scsi6 : usb-storage 2-1:1.0
[    4.590249] usbcore: registered new interface driver usb-storage
[    4.590251] USB Mass Storage support registered.
[    4.953190] cfg80211: Calling CRDA to update world regulatory domain
[    5.057447] rtl8192cu: Chip version 0x10
[    5.133770] rtl8192cu: MAC address: 00:e0:4c:9f:6d:61
[    5.133774] rtl8192cu: Board Type 0
[    5.134017] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[    5.134039] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
[    5.134106] usbcore: registered new interface driver rtl8192cu
[    5.167259] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[    5.167691] rtlwifi: wireless switch is on
[    5.284628] cfg80211: World regulatory domain updated:
[    5.284631] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    5.284633] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[    5.284635] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[    5.284637] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[    5.284639] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[    5.284640] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[    5.284648] cfg80211: Calling CRDA for country: US
[    5.288355] cfg80211: Regulatory domain changed to country: US
[    5.288358] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    5.288360] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2700 mBm)
[    5.288362] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
1700 mBm)
[    5.288364] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[    5.288365] cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[    5.288367] cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[    5.288368] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
3000 mBm)
[    5.448046] rtw driver version=v3.4.4_4749.20121105
[    5.448049] Build at: Dec 20 2012 21:30:41
[    5.448052] Error: Driver 'rtl8192cu' is already registered, aborting...
[    5.587383] scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.00
PQ: 0 ANSI: 0
[    5.587874] scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader    1.01
PQ: 0 ANSI: 0
[    5.588371] scsi 6:0:0:2: Direct-Access     Generic  USB xD/SM Reader 1.02
PQ: 0 ANSI: 0
[    5.588869] scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader    1.03
PQ: 0 ANSI: 0
[    5.589403] sd 6:0:0:0: Attached scsi generic sg3 type 0
[    5.589553] sd 6:0:0:1: Attached scsi generic sg4 type 0
[    5.589710] sd 6:0:0:2: Attached scsi generic sg5 type 0
[    5.589958] sd 6:0:0:3: Attached scsi generic sg6 type 0
[    5.596226] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[    5.596850] sd 6:0:0:1: [sdd] Attached SCSI removable disk
[    5.597472] sd 6:0:0:2: [sde] Attached SCSI removable disk
[    5.598095] sd 6:0:0:3: [sdf] Attached SCSI removable disk
[    5.946322] EXT4-fs (sda5): re-mounted. Opts: (null)
[    6.116727] loop: module loaded
[    6.364889] fuse init (API version 7.20)
[    9.278038] powernow-k8: this CPU is not supported anymore, using
acpi-cpufreq instead.
[    9.291893] acpi-cpufreq: overriding BIOS provided _PSD data
[   12.075949] Bluetooth: Core ver 2.16
[   12.075991] NET: Registered protocol family 31
[   12.075996] Bluetooth: HCI device and connection manager initialized
[   12.076012] Bluetooth: HCI socket layer initialized
[   12.076018] Bluetooth: L2CAP socket layer initialized
[   12.076030] Bluetooth: SCO socket layer initialized
[   12.118890] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   12.118897] Bluetooth: BNEP filters: protocol multicast
[   12.118909] Bluetooth: BNEP socket layer initialized
[   12.223961] Bluetooth: RFCOMM TTY layer initialized
[   12.223985] Bluetooth: RFCOMM socket layer initialized
[   12.223990] Bluetooth: RFCOMM ver 1.11
[   12.910677] lp: driver loaded but no devices found
[   12.980196] ppdev: user-space parallel port driver
[   13.838925] r8169 0000:02:00.0 eth0: link down
[   13.839005] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.845982] rtl8192cu: MAC auto ON okay!
[   13.878681] rtl8192cu: Tx queue select: 0x05
[   14.241381] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   14.524288] ip_tables: (C) 2000-2006 Netfilter Core Team
[   16.197830] wlan0: authenticate with 98:fc:11:53:75:00
[   16.221337] wlan0: send auth to 98:fc:11:53:75:00 (try 1/3)
[   16.223862] wlan0: authenticated
[   16.224732] wlan0: associate with 98:fc:11:53:75:00 (try 1/3)
[   16.261905] wlan0: RX AssocResp from 98:fc:11:53:75:00 (capab=0x411 status=0
aid=2)
[   16.262025] wlan0: associated
[   16.262094] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  193.819993] Netfilter messages via NETLINK v0.30.
[  205.129021] device wlan0 entered promiscuous mode
[ 1144.460437] device wlan0 left promiscuous mode
[ 1311.394492] wlan0: deauthenticating from 98:fc:11:53:75:00 by local choice
(reason=3)
[ 1311.407497] cfg80211: Calling CRDA to update world regulatory domain
[ 1311.415105] cfg80211: World regulatory domain updated:
[ 1311.415109] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 1311.415111] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[ 1311.415113] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[ 1311.415115] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[ 1311.415116] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[ 1311.415118] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
alden@pagea-desktop:~$ clear

alden@pagea-desktop:~$ dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.1 (root@pagea-desktop) (gcc version 4.7.1
(Debian 4.7.1-7) ) #1 SMP Wed Dec 19 22:46:17 EST 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.7.1
root=UUID=6b1da5f8-13bf-4ccc-aeac-a18fdd2239a6 ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e6000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cffaffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cffb0000-0x00000000cffbdfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cffbe000-0x00000000cffdffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cffe0000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000012fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: BIOSTAR Group TA785GE 128M/TA785GE 128M, BIOS
080015  08/19/2009
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcffb0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at
[ffff8800000ff780]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0xcffaffff]
[    0.000000]  [mem 0x00000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcffaffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xcffaffff @ [mem
0x1fffd000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x12fffffff]
[    0.000000]  [mem 0x100000000-0x12fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x12fffffff @ [mem
0xcffae000-0xcffaffff]
[    0.000000] RAMDISK: [mem 0x36aca000-0x3755cfff]
[    0.000000] ACPI: RSDP 00000000000fab40 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000cffb0000 0003C (v01 081909 RSDT1038 20090819
MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cffb0200 00084 (v01 081909 FACP1038 20090819
MSFT 00000097)
[    0.000000] ACPI BIOS Bug: Warning: Optional FADT field Pm2ControlBlock has
zero address or length: 0x0000000000000000/0x1 (20120913/tbfadt-598)
[    0.000000] ACPI: DSDT 00000000cffb0450 09C51 (v01  88GCO 88GCO819 00000001
INTL 20051117)
[    0.000000] ACPI: FACS 00000000cffbe000 00040
[    0.000000] ACPI: APIC 00000000cffb0390 0007C (v01 081909 APIC1038 20090819
MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cffb0410 0003C (v01 081909 OEMMCFG  20090819
MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cffbe040 00072 (v01 081909 OEMB1038 20090819
MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cffba0b0 00038 (v01 081909 OEMHPET  20090819
MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000cffba0f0 0088C (v01 A M I  POWERNOW 00000001
AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000012fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x12fffffff]
[    0.000000]   NODE_DATA [mem 0x12fffc000-0x12fffffff]
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD ->
[ffff88012b600000-ffff88012effffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x12fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xcffaffff]
[    0.000000]   node   0: [mem 0x100000000-0x12fffffff]
[    0.000000] On node 0 totalpages: 1048383
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] smpboot: Allowing 6 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cffb0000 - 00000000cffbe000
[    0.000000] PM: Registered nosave memory: 00000000cffbe000 - 00000000cffe0000
[    0.000000] PM: Registered nosave memory: 00000000cffe0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] e820: [mem 0xd0000000-0xffefffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:6
nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88012fc00000 s83776 r8192
d22720 u262144
[    0.000000] pcpu-alloc: s83776 r8192 d22720 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - -
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total
pages: 1031353
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.7.1
root=UUID=6b1da5f8-13bf-4ccc-aeac-a18fdd2239a6 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ c4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ c4000000
[    0.000000] PM: Registered nosave memory: 00000000c4000000 - 00000000c8000000
[    0.000000] Memory: 3982500k/4980736k available (3547k kernel code, 787204k
absent, 211032k reserved, 3171k data, 616k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=6.
[    0.000000] NR_IRQS:33024 nr_irqs:728 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2599.952 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer
frequency.. 5199.90 BogoMIPS (lpj=10399808)
[    0.000007] pid_max: default: 32768 minimum: 301
[    0.000041] Security Framework initialized
[    0.000046] AppArmor: AppArmor disabled by boot time parameter
[    0.000307] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.001621] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002205] Mount-cache hash table entries: 256
[    0.002386] Initializing cgroup subsys cpuacct
[    0.002389] Initializing cgroup subsys devices
[    0.002390] Initializing cgroup subsys freezer
[    0.002392] Initializing cgroup subsys net_cls
[    0.002394] Initializing cgroup subsys blkio
[    0.002395] Initializing cgroup subsys perf_event
[    0.002419] tseg: 0000000000
[    0.002432] CPU: Physical Processor ID: 0
[    0.002432] CPU: Processor Core ID: 0
[    0.002434] mce: CPU supports 6 MCE banks
[    0.002440] LVT offset 0 assigned for vector 0xf9
[    0.002445] process: using AMD E400 aware idle routine
[    0.002448] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.002448] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
[    0.002448] tlb_flushall_shift: 4
[    0.002518] Freeing SMP alternatives: 8k freed
[    0.002814] ACPI: Core revision 20120913
[    0.012992] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.052591] smpboot: CPU0: AMD Phenom(tm) II X4 810 Processor (fam: 10,
model: 04, stepping: 02)
[    0.158407] Performance Events: AMD PMU driver.
[    0.158410] ... version:                0
[    0.158411] ... bit width:              48
[    0.158412] ... generic registers:      4
[    0.158413] ... value mask:             0000ffffffffffff
[    0.158414] ... max period:             00007fffffffffff
[    0.158415] ... fixed-purpose events:   0
[    0.158416] ... event mask:             000000000000000f
[    0.158644] NMI watchdog: enabled on all CPUs, permanently consumes one
hw-PMU counter.
[    0.158744] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.197958] Brought up 4 CPUs
[    0.197960] smpboot: Total of 4 processors activated (20799.61 BogoMIPS)
[    0.201488] devtmpfs: initialized
[    0.204738] PM: Registering ACPI NVS region [mem 0xcffbe000-0xcffdffff]
(139264 bytes)
[    0.204863] regulator-dummy: no parameters
[    0.204924] NET: Registered protocol family 16
[    0.205017] node 0 link 0: io port [1000, ffffff]
[    0.205020] TOM: 00000000d0000000 aka 3328M
[    0.205022] Fam 10h mmconf [mem 0xe0000000-0xefffffff]
[    0.205024] node 0 link 0: mmio [a0000, bffff]
[    0.205027] node 0 link 0: mmio [d0000000, dfffffff]
[    0.205029] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.205030] node 0 link 0: mmio [f0000000, ffefffff]
[    0.205032] TOM2: 0000000130000000 aka 4864M
[    0.205034] bus: [bus 00-07] on node 0 link 0
[    0.205035] bus: 00 [io  0x0000-0xffff]
[    0.205037] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.205038] bus: 00 [mem 0xd0000000-0xdfffffff]
[    0.205039] bus: 00 [mem 0xf0000000-0xffffffff]
[    0.205040] bus: 00 [mem 0x130000000-0xfcffffffff]
[    0.205084] ACPI: bus type pci registered
[    0.205140] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.205142] PCI: not using MMCONFIG
[    0.205143] PCI: Using configuration type 1 for base access
[    0.205144] PCI: Using configuration type 1 for extended access
[    0.205876] bio: create slab <bio-0> at 0
[    0.205959] ACPI: Added _OSI(Module Device)
[    0.205961] ACPI: Added _OSI(Processor Device)
[    0.205962] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.205963] ACPI: Added _OSI(Processor Aggregator Device)
[    0.206580] ACPI: EC: Look up EC in DSDT
[    0.207884] ACPI: Executed 4 blocks of module-level executable AML code
[    0.212325] ACPI: Interpreter enabled
[    0.212331] ACPI: (supports S0 S1 S4 S5)
[    0.212350] ACPI: Using IOAPIC for interrupt routing
[    0.212374] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.213624] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI
motherboard resources
[    0.278722] ACPI: No dock devices found.
[    0.278727] PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
[    0.278814] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.278989] PCI host bridge to bus 0000:00
[    0.278993] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.278995] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.278997] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.278999] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.279001] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.279003] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xdfffffff]
[    0.279005] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
[    0.279016] pci 0000:00:00.0: [1022:9601] type 00 class 0x060000
[    0.279064] pci 0000:00:02.0: [1022:9603] type 01 class 0x060400
[    0.279095] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.279115] pci 0000:00:07.0: [1022:9607] type 01 class 0x060400
[    0.279145] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.279184] pci 0000:00:11.0: [1002:4390] type 00 class 0x01018f
[    0.279203] pci 0000:00:11.0: reg 10: [io  0xc000-0xc007]
[    0.279212] pci 0000:00:11.0: reg 14: [io  0xb000-0xb003]
[    0.279221] pci 0000:00:11.0: reg 18: [io  0xa000-0xa007]
[    0.279231] pci 0000:00:11.0: reg 1c: [io  0x9000-0x9003]
[    0.279240] pci 0000:00:11.0: reg 20: [io  0x8000-0x800f]
[    0.279249] pci 0000:00:11.0: reg 24: [mem 0xfe9ffc00-0xfe9fffff]
[    0.279269] pci 0000:00:11.0: set SATA to AHCI mode
[    0.279315] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.279328] pci 0000:00:12.0: reg 10: [mem 0xfe9fe000-0xfe9fefff]
[    0.279392] pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
[    0.279405] pci 0000:00:12.1: reg 10: [mem 0xfe9fd000-0xfe9fdfff]
[    0.279473] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.279491] pci 0000:00:12.2: reg 10: [mem 0xfe9ff800-0xfe9ff8ff]
[    0.279571] pci 0000:00:12.2: supports D1 D2
[    0.279573] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.279596] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.279609] pci 0000:00:13.0: reg 10: [mem 0xfe9fc000-0xfe9fcfff]
[    0.279672] pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
[    0.279685] pci 0000:00:13.1: reg 10: [mem 0xfe9fb000-0xfe9fbfff]
[    0.279753] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.279772] pci 0000:00:13.2: reg 10: [mem 0xfe9ff400-0xfe9ff4ff]
[    0.279851] pci 0000:00:13.2: supports D1 D2
[    0.279853] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.279879] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.279976] pci 0000:00:14.1: [1002:439c] type 00 class 0x01018a
[    0.279992] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.280001] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.280010] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.280019] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.280028] pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
[    0.280085] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.280106] pci 0000:00:14.2: reg 10: [mem 0xfe9f4000-0xfe9f7fff 64bit]
[    0.280170] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.280185] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.280259] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.280301] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.280314] pci 0000:00:14.5: reg 10: [mem 0xfe9fa000-0xfe9fafff]
[    0.280380] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    0.280395] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    0.280408] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    0.280421] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    0.280436] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    0.280481] pci 0000:01:00.0: [1002:68b8] type 00 class 0x030000
[    0.280493] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.280502] pci 0000:01:00.0: reg 18: [mem 0xfeae0000-0xfeafffff 64bit]
[    0.280508] pci 0000:01:00.0: reg 20: [io  0xd000-0xd0ff]
[    0.280519] pci 0000:01:00.0: reg 30: [mem 0xfeac0000-0xfeadffff pref]
[    0.280545] pci 0000:01:00.0: supports D1 D2
[    0.280563] pci 0000:01:00.1: [1002:aa58] type 00 class 0x040300
[    0.280575] pci 0000:01:00.1: reg 10: [mem 0xfeabc000-0xfeabffff 64bit]
[    0.280623] pci 0000:01:00.1: supports D1 D2
[    0.289794] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.289800] pci 0000:00:02.0:   bridge window [io  0xd000-0xdfff]
[    0.289803] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.289806] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.289847] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.289859] pci 0000:02:00.0: reg 10: [io  0xe800-0xe8ff]
[    0.289879] pci 0000:02:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit pref]
[    0.289891] pci 0000:02:00.0: reg 20: [mem 0xfdff8000-0xfdffbfff 64bit pref]
[    0.289900] pci 0000:02:00.0: reg 30: [mem 0xfebe0000-0xfebfffff pref]
[    0.289947] pci 0000:02:00.0: supports D1 D2
[    0.289948] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.297778] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.297783] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.297786] pci 0000:00:07.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.297789] pci 0000:00:07.0:   bridge window [mem 0xfdf00000-0xfdffffff
64bit pref]
[    0.297853] pci 0000:00:14.4: PCI bridge to [bus 03] (subtractive decode)
[    0.297862] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.297864] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.297866] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff]
(subtractive decode)
[    0.297868] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff]
(subtractive decode)
[    0.297870] pci 0000:00:14.4:   bridge window [mem 0xd0000000-0xdfffffff]
(subtractive decode)
[    0.297872] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff]
(subtractive decode)
[    0.297885] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.298120] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.298157] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.298204] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.298266]  pci0000:00: ACPI _OSC support notification failed, disabling
PCIe ASPM
[    0.298267]  pci0000:00: Unable to request _OSC control (_OSC
support mask: 0x08)
[    0.302685] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)
[    0.302723] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    0.302758] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
[    0.302792] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 *11 12 14 15)
[    0.302826] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0,
disabled.
[    0.302861] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0,
disabled.
[    0.302895] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 *9 10 11 12 14 15)
[    0.302930] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0,
disabled.
[    0.303027] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.303028] vgaarb: loaded
[    0.303029] vgaarb: bridge control possible 0000:01:00.0
[    0.303063] PCI: Using ACPI for IRQ routing
[    0.311500] PCI: pci_cache_line_size set to 64 bytes
[    0.311556] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.311557] e820: reserve RAM buffer [mem 0xcffb0000-0xcfffffff]
[    0.311671] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.311675] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.313693] Switching to clocksource hpet
[    0.315386] pnp: PnP ACPI init
[    0.315398] ACPI: bus type pnp registered
[    0.315494] pnp 00:00: [bus 00-ff]
[    0.315497] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.315499] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.315501] pnp 00:00: [io  0x0d00-0xffff window]
[    0.315503] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.315505] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.315507] pnp 00:00: [mem 0xd0000000-0xdfffffff window]
[    0.315509] pnp 00:00: [mem 0xf0000000-0xfebfffff window]
[    0.315535] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.315616] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.315618] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.315649] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.315689] pnp 00:02: [dma 4]
[    0.315691] pnp 00:02: [io  0x0000-0x000f]
[    0.315693] pnp 00:02: [io  0x0081-0x0083]
[    0.315695] pnp 00:02: [io  0x0087]
[    0.315697] pnp 00:02: [io  0x0089-0x008b]
[    0.315698] pnp 00:02: [io  0x008f]
[    0.315700] pnp 00:02: [io  0x00c0-0x00df]
[    0.315720] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.315729] pnp 00:03: [io  0x0070-0x0071]
[    0.315737] pnp 00:03: [irq 8]
[    0.315758] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.315765] pnp 00:04: [io  0x0061]
[    0.315784] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.315791] pnp 00:05: [io  0x00f0-0x00ff]
[    0.315799] pnp 00:05: [irq 13]
[    0.315819] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.316435] pnp 00:06: [io  0x03f0-0x03f5]
[    0.316437] pnp 00:06: [io  0x03f7]
[    0.316452] pnp 00:06: [irq 6]
[    0.316454] pnp 00:06: [dma 2]
[    0.316498] pnp 00:06: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.316523] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.316543] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.316616] pnp 00:08: [mem 0xfec00000-0xfec00fff]
[    0.316618] pnp 00:08: [mem 0xfee00000-0xfee00fff]
[    0.316647] system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.316650] system 00:08: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.316652] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.316781] pnp 00:09: [io  0x0010-0x001f]
[    0.316783] pnp 00:09: [io  0x0022-0x003f]
[    0.316785] pnp 00:09: [io  0x0062-0x0063]
[    0.316787] pnp 00:09: [io  0x0065-0x006f]
[    0.316789] pnp 00:09: [io  0x0072-0x007f]
[    0.316790] pnp 00:09: [io  0x0080]
[    0.316792] pnp 00:09: [io  0x0084-0x0086]
[    0.316794] pnp 00:09: [io  0x0088]
[    0.316795] pnp 00:09: [io  0x008c-0x008e]
[    0.316797] pnp 00:09: [io  0x0090-0x009f]
[    0.316799] pnp 00:09: [io  0x00a2-0x00bf]
[    0.316800] pnp 00:09: [io  0x00b1]
[    0.316802] pnp 00:09: [io  0x00e0-0x00ef]
[    0.316804] pnp 00:09: [io  0x04d0-0x04d1]
[    0.316806] pnp 00:09: [io  0x040b]
[    0.316807] pnp 00:09: [io  0x04d6]
[    0.316809] pnp 00:09: [io  0x0c00-0x0c01]
[    0.316811] pnp 00:09: [io  0x0c14]
[    0.316812] pnp 00:09: [io  0x0c50-0x0c51]
[    0.316814] pnp 00:09: [io  0x0c52]
[    0.316816] pnp 00:09: [io  0x0c6c]
[    0.316817] pnp 00:09: [io  0x0c6f]
[    0.316819] pnp 00:09: [io  0x0cd0-0x0cd1]
[    0.316821] pnp 00:09: [io  0x0cd2-0x0cd3]
[    0.316823] pnp 00:09: [io  0x0cd4-0x0cd5]
[    0.316824] pnp 00:09: [io  0x0cd6-0x0cd7]
[    0.316826] pnp 00:09: [io  0x0cd8-0x0cdf]
[    0.316829] pnp 00:09: [io  0x0800-0x089f]
[    0.316831] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.316833] pnp 00:09: [io  0x0b00-0x0b0f]
[    0.316834] pnp 00:09: [io  0x0b20-0x0b3f]
[    0.316836] pnp 00:09: [io  0x0900-0x090f]
[    0.316838] pnp 00:09: [io  0x0910-0x091f]
[    0.316840] pnp 00:09: [io  0xfe00-0xfefe]
[    0.316842] pnp 00:09: [io  0x0060-0x005f disabled]
[    0.316843] pnp 00:09: [io  0x0064-0x0063 disabled]
[    0.316845] pnp 00:09: [mem 0xffb80000-0xffbfffff]
[    0.316847] pnp 00:09: [mem 0xfec10000-0xfec1001f]
[    0.316906] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.316909] system 00:09: [io  0x040b] has been reserved
[    0.316911] system 00:09: [io  0x04d6] has been reserved
[    0.316913] system 00:09: [io  0x0c00-0x0c01] has been reserved
[    0.316915] system 00:09: [io  0x0c14] has been reserved
[    0.316918] system 00:09: [io  0x0c50-0x0c51] has been reserved
[    0.316920] system 00:09: [io  0x0c52] has been reserved
[    0.316922] system 00:09: [io  0x0c6c] has been reserved
[    0.316924] system 00:09: [io  0x0c6f] has been reserved
[    0.316926] system 00:09: [io  0x0cd0-0x0cd1] has been reserved
[    0.316929] system 00:09: [io  0x0cd2-0x0cd3] has been reserved
[    0.316931] system 00:09: [io  0x0cd4-0x0cd5] has been reserved
[    0.316933] system 00:09: [io  0x0cd6-0x0cd7] has been reserved
[    0.316936] system 00:09: [io  0x0cd8-0x0cdf] has been reserved
[    0.316939] system 00:09: [io  0x0800-0x089f] has been reserved
[    0.316942] system 00:09: [io  0x0b00-0x0b0f] has been reserved
[    0.316944] system 00:09: [io  0x0b20-0x0b3f] has been reserved
[    0.316946] system 00:09: [io  0x0900-0x090f] has been reserved
[    0.316949] system 00:09: [io  0x0910-0x091f] has been reserved
[    0.316951] system 00:09: [io  0xfe00-0xfefe] has been reserved
[    0.316954] system 00:09: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.316956] system 00:09: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.316959] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.316982] pnp 00:0a: [io  0x0060]
[    0.316984] pnp 00:0a: [io  0x0064]
[    0.316988] pnp 00:0a: [irq 1]
[    0.317018] pnp 00:0a: Plug and Play ACPI device, IDs PNP0303
PNP030b (active)
[    0.317173] pnp 00:0b: [io  0x0000-0xffffffffffffffff disabled]
[    0.317175] pnp 00:0b: [io  0x0a00-0x0a0f]
[    0.317176] pnp 00:0b: [io  0x0a10-0x0a1f]
[    0.317178] pnp 00:0b: [io  0x0a20-0x0a2f]
[    0.317180] pnp 00:0b: [io  0x0a30-0x0a3f]
[    0.317209] system 00:0b: [io  0x0a00-0x0a0f] has been reserved
[    0.317212] system 00:0b: [io  0x0a10-0x0a1f] has been reserved
[    0.317214] system 00:0b: [io  0x0a20-0x0a2f] has been reserved
[    0.317216] system 00:0b: [io  0x0a30-0x0a3f] has been reserved
[    0.317219] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.317804] pnp 00:0c: [io  0x03f8-0x03ff]
[    0.317808] pnp 00:0c: [irq 4]
[    0.317810] pnp 00:0c: [dma 0 disabled]
[    0.317892] pnp 00:0c: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.317922] pnp 00:0d: [mem 0xe0000000-0xefffffff]
[    0.317952] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    0.317954] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.318573] pnp 00:0e: [mem 0x00000000-0x0009ffff]
[    0.318575] pnp 00:0e: [mem 0x000c0000-0x000cffff]
[    0.318577] pnp 00:0e: [mem 0x000e0000-0x000fffff]
[    0.318579] pnp 00:0e: [mem 0x00100000-0xcfffffff]
[    0.318581] pnp 00:0e: [mem 0xfec00000-0xffffffff]
[    0.318613] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.318615] system 00:0e: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.318618] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.318620] system 00:0e: [mem 0x00100000-0xcfffffff] could not be reserved
[    0.318622] system 00:0e: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.318625] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.318723] pnp: PnP ACPI: found 15 devices
[    0.318724] ACPI: ACPI bus type pnp unregistered
[    0.325353] pci 0000:00:02.0: PCI bridge to [bus 01]
[    0.325356] pci 0000:00:02.0:   bridge window [io  0xd000-0xdfff]
[    0.325358] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.325361] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.325365] pci 0000:00:07.0: PCI bridge to [bus 02]
[    0.325367] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.325369] pci 0000:00:07.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.325372] pci 0000:00:07.0:   bridge window [mem 0xfdf00000-0xfdffffff
64bit pref]
[    0.325375] pci 0000:00:14.4: PCI bridge to [bus 03]
[    0.325406] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.325408] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.325410] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.325412] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.325414] pci_bus 0000:00: resource 8 [mem 0xd0000000-0xdfffffff]
[    0.325416] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.325418] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.325420] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.325422] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.325424] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.325426] pci_bus 0000:02: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.325428] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff
64bit pref]
[    0.325430] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.325432] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.325434] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.325436] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.325438] pci_bus 0000:03: resource 8 [mem 0xd0000000-0xdfffffff]
[    0.325440] pci_bus 0000:03: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.325513] NET: Registered protocol family 2
[    0.326203] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    0.328772] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.329072] TCP: Hash tables configured (established 524288 bind 65536)
[    0.329119] TCP: reno registered
[    0.329129] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.329158] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.329294] NET: Registered protocol family 1
[    0.728908] pci 0000:01:00.0: Boot video device
[    0.728916] PCI: CLS 64 bytes, default 64
[    0.728960] Unpacking initramfs...
[    0.930187] Freeing initrd memory: 10828k freed
[    0.933889] PCI-DMA: Disabling AGP.
[    0.933980] PCI-DMA: aperture base @ c4000000 size 65536 KB
[    0.933981] PCI-DMA: using GART IOMMU.
[    0.933983] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.937424] LVT offset 1 assigned for vector 0x400
[    0.937432] IBS: LVT offset 1 assigned
[    0.937461] perf: AMD IBS detected (0x0000001f)
[    0.937722] audit: initializing netlink socket (disabled)
[    0.937738] type=2000 audit(1356128912.828:1): initialized
[    0.951207] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.951652] VFS: Disk quotas dquot_6.5.2
[    0.951678] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.951757] msgmni has been set to 7928
[    0.952016] alg: No test for stdrng (krng)
[    0.952041] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[    0.952043] io scheduler noop registered
[    0.952044] io scheduler deadline registered
[    0.952062] io scheduler cfq registered (default)
[    0.952156] pcieport 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.952215] pcieport 0000:00:07.0: irq 41 for MSI/MSI-X
[    0.952275] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.952293] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.952294] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.952556] GHES: HEST is not enabled!
[    0.952620] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.973068] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.973442] Linux agpgart interface v0.103
[    0.973534] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.973536] i8042: PNP: PS/2 appears to have AUX port disabled, if this is
incorrect please boot with i8042.nopnp
[    0.973663] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.973751] mousedev: PS/2 mouse device common for all mice
[    0.973787] rtc_cmos 00:03: RTC can wake from S4
[    0.973895] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.973919] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.973927] cpuidle: using governor ladder
[    0.973928] cpuidle: using governor menu
[    0.973966] drop_monitor: Initializing network drop monitor service
[    0.974028] TCP: cubic registered
[    0.974072] NET: Registered protocol family 10
[    0.974255] mip6: Mobile IPv6
[    0.974257] NET: Registered protocol family 17
[    0.974270] Key type dns_resolver registered
[    0.974537] PM: Hibernation image not present or could not be loaded.
[    0.974546] registered taskstats version 1
[    0.975062] rtc_cmos 00:03: setting system clock to 2012-12-21 22:28:33 UTC
(1356128913)
[    0.976175] Freeing unused kernel memory: 616k freed
[    0.976297] Write protecting the kernel read-only data: 6144k
[    0.978225] Freeing unused kernel memory: 540k freed
[    0.980343] Freeing unused kernel memory: 608k freed
[    0.990884] udevd[67]: starting version 175
[    0.996612] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
[    1.002325] SCSI subsystem initialized
[    1.003355] ACPI: bus type scsi registered
[    1.005017] thermal LNXTHERM:00: registered as thermal_zone0
[    1.005021] ACPI: Thermal Zone [THRM] (56 C)
[    1.006424] ACPI: bus type usb registered
[    1.006453] usbcore: registered new interface driver usbfs
[    1.006466] usbcore: registered new interface driver hub
[    1.014045] usbcore: registered new device driver usb
[    1.014438] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.014509] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.014522] ehci_hcd 0000:00:12.2: new USB bus registered, assigned
bus number 1
[    1.014533] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI
dummy qh workaround
[    1.014570] ehci_hcd 0000:00:12.2: debug port 1
[    1.014596] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe9ff800
[    1.017809] libata version 3.00 loaded.
[    1.018399] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.018583] r8169 0000:02:00.0: irq 42 for MSI/MSI-X
[    1.018759] r8169 0000:02:00.0 eth0: RTL8168d/8111d at 0xffffc9000060e000,
00:30:67:1f:7c:6a, XID 081000c0 IRQ 42
[    1.018761] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes, tx
checksumming: ko]
[    1.024279] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.024309] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.024311] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.024314] usb usb1: Product: EHCI Host Controller
[    1.024315] usb usb1: Manufacturer: Linux 3.7.1 ehci_hcd
[    1.024317] usb usb1: SerialNumber: 0000:00:12.2
[    1.024448] hub 1-0:1.0: USB hub found
[    1.024452] hub 1-0:1.0: 6 ports detected
[    1.024954] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    1.024962] ehci_hcd 0000:00:13.2: new USB bus registered, assigned
bus number 2
[    1.024968] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI
dummy qh workaround
[    1.025000] ehci_hcd 0000:00:13.2: debug port 1
[    1.025025] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe9ff400
[    1.029112] Floppy drive(s): fd0 is 1.44M
[    1.036274] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.036299] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.036302] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.036304] usb usb2: Product: EHCI Host Controller
[    1.036306] usb usb2: Manufacturer: Linux 3.7.1 ehci_hcd
[    1.036307] usb usb2: SerialNumber: 0000:00:13.2
[    1.036464] hub 2-0:1.0: USB hub found
[    1.036468] hub 2-0:1.0: 6 ports detected
[    1.036654] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    1.036917] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.036953] scsi0 : pata_atiixp
[    1.037338] scsi1 : pata_atiixp
[    1.037608] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    1.037610] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    1.037661] ahci 0000:00:11.0: version 3.0
[    1.037801] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf
impl SATA mode
[    1.037805] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio
slum part ccc
[    1.038355] scsi2 : ahci
[    1.038429] scsi3 : ahci
[    1.038488] scsi4 : ahci
[    1.038545] scsi5 : ahci
[    1.038585] ata3: SATA max UDMA/133 abar m1024@0xfe9ffc00 port
0xfe9ffd00 irq 22
[    1.038588] ata4: SATA max UDMA/133 abar m1024@0xfe9ffc00 port
0xfe9ffd80 irq 22
[    1.038591] ata5: SATA max UDMA/133 abar m1024@0xfe9ffc00 port
0xfe9ffe00 irq 22
[    1.038593] ata6: SATA max UDMA/133 abar m1024@0xfe9ffc00 port
0xfe9ffe80 irq 22
[    1.038690] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.038698] ohci_hcd 0000:00:12.0: new USB bus registered, assigned
bus number 3
[    1.038727] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe9fe000
[    1.047995] FDC 0 is a post-1991 82077
[    1.096115] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.096118] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.096120] usb usb3: Product: OHCI Host Controller
[    1.096122] usb usb3: Manufacturer: Linux 3.7.1 ohci_hcd
[    1.096123] usb usb3: SerialNumber: 0000:00:12.0
[    1.096253] hub 3-0:1.0: USB hub found
[    1.096261] hub 3-0:1.0: 3 ports detected
[    1.096379] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    1.096385] ohci_hcd 0000:00:12.1: new USB bus registered, assigned
bus number 4
[    1.096401] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe9fd000
[    1.155978] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.155981] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.155983] usb usb4: Product: OHCI Host Controller
[    1.155985] usb usb4: Manufacturer: Linux 3.7.1 ohci_hcd
[    1.155986] usb usb4: SerialNumber: 0000:00:12.1
[    1.156104] hub 4-0:1.0: USB hub found
[    1.156110] hub 4-0:1.0: 3 ports detected
[    1.156213] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.156218] ohci_hcd 0000:00:13.0: new USB bus registered, assigned
bus number 5
[    1.156244] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe9fc000
[    1.208353] ata2.00: ATAPI: ATAPI   iHDP118   4, GL05, max UDMA/33
[    1.215857] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.215860] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.215862] usb usb5: Product: OHCI Host Controller
[    1.215863] usb usb5: Manufacturer: Linux 3.7.1 ohci_hcd
[    1.215865] usb usb5: SerialNumber: 0000:00:13.0
[    1.216041] hub 5-0:1.0: USB hub found
[    1.216047] hub 5-0:1.0: 3 ports detected
[    1.216192] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    1.216197] ohci_hcd 0000:00:13.1: new USB bus registered, assigned
bus number 6
[    1.216212] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe9fb000
[    1.224264] ata2.00: configured for UDMA/33
[    1.226346] scsi 1:0:0:0: CD-ROM            ATAPI    iHDP118   4      GL05
PQ: 0 ANSI: 5
[    1.275752] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.275755] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.275756] usb usb6: Product: OHCI Host Controller
[    1.275758] usb usb6: Manufacturer: Linux 3.7.1 ohci_hcd
[    1.275760] usb usb6: SerialNumber: 0000:00:13.1
[    1.275880] hub 6-0:1.0: USB hub found
[    1.275886] hub 6-0:1.0: 3 ports detected
[    1.275993] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.275999] ohci_hcd 0000:00:14.5: new USB bus registered, assigned
bus number 7
[    1.276014] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe9fa000
[    1.335628] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.335631] usb usb7: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.335633] usb usb7: Product: OHCI Host Controller
[    1.335634] usb usb7: Manufacturer: Linux 3.7.1 ohci_hcd
[    1.335636] usb usb7: SerialNumber: 0000:00:14.5
[    1.335755] hub 7-0:1.0: USB hub found
[    1.335763] hub 7-0:1.0: 2 ports detected
[    1.355599] ata6: SATA link down (SStatus 0 SControl 300)
[    1.355652] ata4: SATA link down (SStatus 0 SControl 300)
[    1.527220] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.527245] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.528125] ata3.00: ATA-8: WDC WD6401AALS-00L3B2, 01.03B01, max UDMA/133
[    1.528128] ata3.00: 1250263728 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.528281] ata3.00: failed to get Identify Device Data, Emask 0x1
[    1.529388] ata3.00: failed to get Identify Device Data, Emask 0x1
[    1.529392] ata3.00: configured for UDMA/133
[    1.529524] scsi 2:0:0:0: Direct-Access     ATA      WDC WD6401AALS-0 01.0
PQ: 0 ANSI: 5
[    1.533247] ata5.00: ATA-8: SAMSUNG HD155UI, 1AQ10001, max UDMA/133
[    1.533250] ata5.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.534842] ata5.00: failed to get Identify Device Data, Emask 0x1
[    1.542516] ata5.00: failed to get Identify Device Data, Emask 0x1
[    1.542521] ata5.00: configured for UDMA/133
[    1.542665] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD155UI  1AQ1
PQ: 0 ANSI: 5
[    1.546801] sd 2:0:0:0: [sda] 1250263728 512-byte logical blocks: (640 GB/596
GiB)
[    1.546844] sd 4:0:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50
TB/1.36 TiB)
[    1.546871] sd 2:0:0:0: [sda] Write Protect is off
[    1.546874] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.546905] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    1.546917] sd 4:0:0:0: [sdb] Write Protect is off
[    1.546919] sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.546942] sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    1.548631] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    1.548634] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.548854] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.552709] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    1.552749] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    1.552787] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    1.559768]  sdb: sdb1
[    1.560076] sd 4:0:0:0: [sdb] Attached SCSI disk
[    1.590635]  sda: sda1 sda2 sda3 < sda5 sda6 >
[    1.591144] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.670929] usb 3-3: new low-speed USB device number 2 using ohci_hcd
[    1.837565] usb 3-3: New USB device found, idVendor=093a, idProduct=2510
[    1.837569] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.837571] usb 3-3: Product: USB OPTICAL MOUSE
[    1.837573] usb 3-3: Manufacturer: PIXART
[    1.848589] usbcore: registered new interface driver usbhid
[    1.848591] usbhid: USB HID core driver
[    1.850097] input: PIXART USB OPTICAL MOUSE as
/devices/pci0000:00/0000:00:12.0/usb3/3-3/3-3:1.0/input/input1
[    1.850173] hid-generic 0003:093A:2510.0001: input,hidraw0: USB HID v1.11
Mouse [PIXART USB OPTICAL MOUSE] on usb-0000:00:12.0-3/input0
[    1.934358] tsc: Refined TSC clocksource calibration: 2600.146 MHz
[    1.934363] Switching to clocksource tsc
[    1.954318] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.979297] PM: Starting manual resume from disk
[    1.979301] PM: Hibernation image partition 8:6 present
[    1.979302] PM: Looking for hibernation image.
[    1.979473] PM: Image not found (code -22)
[    1.979476] PM: Hibernation image not present or could not be loaded.
[    2.038231] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts:
(null)
[    2.087861] usb 2-1: New USB device found, idVendor=058f, idProduct=6362
[    2.087865] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.087867] usb 2-1: Product: Mass Storage Device
[    2.087869] usb 2-1: Manufacturer: Generic
[    2.087870] usb 2-1: SerialNumber: 058F63626376
[    2.197794] usb 2-2: new high-speed USB device number 3 using ehci_hcd
[    2.331053] usb 2-2: New USB device found, idVendor=0bda, idProduct=8176
[    2.331056] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.331059] usb 2-2: Product: 802.11n WLAN Adapter
[    2.331060] usb 2-2: Manufacturer: Realtek
[    2.331062] usb 2-2: SerialNumber: 00e04c000001
[    3.174844] udevd[368]: starting version 175
[    3.394924] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    3.394931] ACPI: Power Button [PWRB]
[    3.394989] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    3.394991] ACPI: Power Button [PWRF]
[    3.478934] wmi: Mapper loaded
[    3.518821] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    3.529421] microcode: CPU0: patch_level=0x01000086
[    1.226567] ACPI: Invalid Power Resource to register!
[    3.660683] ACPI Warning: 0x0000000000000b00-0x0000000000000b07 SystemIO
conflicts with Region \SOR1 1 (20120913/utaddress-251)
[    3.660691] ACPI: If an ACPI driver is available for this device, you should
use it instead of the native driver
[    3.667593] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[    3.667653] sp5100_tco: mmio address 0xfec000f0 already in use
[    3.708249] k10temp 0000:00:18.3: unreliable CPU thermal sensor; monitoring
disabled
[    3.736798] EDAC MC: Ver: 3.0.0
[    3.744554] [drm] Initialized drm 1.1.0 20060810
[    3.891425] microcode: failed to load file amd-ucode/microcode_amd.bin
[    3.891477] microcode: CPU1: patch_level=0x01000086
[    3.891487] microcode: CPU2: patch_level=0x01000086
[    3.891497] microcode: CPU3: patch_level=0x01000086
[    3.891545] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.962531] [drm] radeon kernel modesetting enabled.
[    3.962781] [drm] initializing kernel modesetting (JUNIPER 0x1002:0x68B8
0x1682:0x2990).
[    3.962805] [drm] register mmio base: 0xFEAE0000
[    3.962806] [drm] register mmio size: 131072
[    3.967685] ATOM BIOS: JUNIPER
[    3.967707] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 -
0x000000003FFFFFFF (1024M used)
[    3.967709] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 -
0x000000005FFFFFFF
[    3.970812] [drm] Detected VRAM RAM=1024M, BAR=256M
[    3.970816] [drm] RAM width 128bits DDR
[    3.970884] [TTM] Zone  kernel: Available graphics memory: 2030526 kiB
[    3.970886] [TTM] Initializing pool allocator
[    3.970890] [TTM] Initializing DMA pool allocator
[    3.970919] [drm] radeon: 1024M of VRAM memory ready
[    3.970920] [drm] radeon: 512M of GTT memory ready.
[    3.970939] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    3.970940] [drm] Driver supports precise vblank timestamp query.
[    3.970978] radeon 0000:01:00.0: irq 43 for MSI/MSI-X
[    3.970987] radeon 0000:01:00.0: radeon: using MSI.
[    3.971012] [drm] radeon: irq initialized.
[    3.971016] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    3.971776] [drm] probing gen 2 caps for device 1022:9603 = 2/0
[    3.971779] [drm] enabling PCIE gen 2 link speeds, disable with
radeon.pcie_gen2=0
[    3.971844] [drm] Loading JUNIPER Microcode
[    4.023544] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[    4.023640] radeon 0000:01:00.0: WB enabled
[    4.023644] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr
0x0000000040000c00 and cpu addr 0xffff880129bcfc00
[    4.039699] [drm] ring test on 0 succeeded in 1 usecs
[    4.039814] [drm] ib test on ring 0 succeeded in 0 usecs
[    4.040340] [drm] Radeon Display Connectors
[    4.040341] [drm] Connector 0:
[    4.040342] [drm]   DP-1
[    4.040343] [drm]   HPD4
[    4.040345] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448
0x644c 0x644c
[    4.040346] [drm]   Encoders:
[    4.040347] [drm]     DFP1: INTERNAL_UNIPHY2
[    4.040348] [drm] Connector 1:
[    4.040349] [drm]   HDMI-A-1
[    4.040350] [drm]   HPD5
[    4.040351] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438
0x643c 0x643c
[    4.040352] [drm]   Encoders:
[    4.040353] [drm]     DFP2: INTERNAL_UNIPHY2
[    4.040354] [drm] Connector 2:
[    4.040355] [drm]   DVI-I-1
[    4.040356] [drm]   HPD1
[    4.040357] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468
0x646c 0x646c
[    4.040358] [drm]   Encoders:
[    4.040359] [drm]     DFP3: INTERNAL_UNIPHY1
[    4.040360] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    4.040361] [drm] Connector 3:
[    4.040362] [drm]   DVI-I-2
[    4.040363] [drm]   HPD6
[    4.040364] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458
0x645c 0x645c
[    4.040365] [drm]   Encoders:
[    4.040366] [drm]     DFP4: INTERNAL_UNIPHY
[    4.040367] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    4.040405] [drm] Internal thermal controller with fan control
[    4.040438] [drm] radeon: power management initialized
[    4.050697] hda_intel: position_fix set to 1 for device 1565:8218
[    4.081332] MCE: In-kernel MCE decoding enabled.
[    4.081878] AMD64 EDAC driver v3.4.0
[    4.099577] [drm] fb mappable at 0xD0142000
[    4.099579] [drm] vram apper at 0xD0000000
[    4.099580] [drm] size 7299072
[    4.099581] [drm] fb depth is 24
[    4.099582] [drm]    pitch is 6912
[    4.099667] fbcon: radeondrmfb (fb0) is primary device
[    4.176299] kvm: Nested Virtualization enabled
[    4.176302] kvm: Nested Paging enabled
[    4.259156] input: HDA ATI SB Line as
/devices/pci0000:00/0000:00:14.2/sound/card0/input5
[    4.259248] input: HDA ATI SB Front Mic as
/devices/pci0000:00/0000:00:14.2/sound/card0/input6
[    4.259319] input: HDA ATI SB Rear Mic as
/devices/pci0000:00/0000:00:14.2/sound/card0/input7
[    4.259386] input: HDA ATI SB Front Headphone as
/devices/pci0000:00/0000:00:14.2/sound/card0/input8
[    4.259449] input: HDA ATI SB Line Out as
/devices/pci0000:00/0000:00:14.2/sound/card0/input9
[    4.259679] EDAC amd64: DRAM ECC disabled.
[    4.259684] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module
will not load.
[    4.259684]  Either enable ECC checking or force module loading by setting
'ecc_enable_override'.
[    4.259684]  (Note that use of the override may cause unknown side effects.)
[    4.318015] Console: switching to colour frame buffer device 210x65
[    4.325930] fb0: radeondrmfb frame buffer device
[    4.325932] drm: registered panic notifier
[    4.325938] [drm] Initialized radeon 2.24.0 20080528 for
0000:01:00.0 on minor 0
[    4.325998] hda-intel: 0000:01:00.1: Handle VGA-switcheroo audio client
[    4.326058] snd_hda_intel 0000:01:00.1: irq 44 for MSI/MSI-X
[    4.402231] input: HD-Audio Generic HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:02.0/0000:01:00.1/sound/card1/input10
[    4.590077] Initializing USB Mass Storage driver...
[    4.590174] scsi6 : usb-storage 2-1:1.0
[    4.590249] usbcore: registered new interface driver usb-storage
[    4.590251] USB Mass Storage support registered.
[    4.953190] cfg80211: Calling CRDA to update world regulatory domain
[    5.057447] rtl8192cu: Chip version 0x10
[    5.133770] rtl8192cu: MAC address: 00:e0:4c:9f:6d:61
[    5.133774] rtl8192cu: Board Type 0
[    5.134017] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[    5.134039] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
[    5.134106] usbcore: registered new interface driver rtl8192cu
[    5.167259] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[    5.167691] rtlwifi: wireless switch is on
[    5.284628] cfg80211: World regulatory domain updated:
[    5.284631] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    5.284633] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[    5.284635] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[    5.284637] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[    5.284639] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[    5.284640] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[    5.284648] cfg80211: Calling CRDA for country: US
[    5.288355] cfg80211: Regulatory domain changed to country: US
[    5.288358] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    5.288360] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2700 mBm)
[    5.288362] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
1700 mBm)
[    5.288364] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[    5.288365] cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[    5.288367] cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[    5.288368] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
3000 mBm)
[    5.448046] rtw driver version=v3.4.4_4749.20121105
[    5.448049] Build at: Dec 20 2012 21:30:41
[    5.448052] Error: Driver 'rtl8192cu' is already registered, aborting...
[    5.587383] scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.00
PQ: 0 ANSI: 0
[    5.587874] scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader    1.01
PQ: 0 ANSI: 0
[    5.588371] scsi 6:0:0:2: Direct-Access     Generic  USB xD/SM Reader 1.02
PQ: 0 ANSI: 0
[    5.588869] scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader    1.03
PQ: 0 ANSI: 0
[    5.589403] sd 6:0:0:0: Attached scsi generic sg3 type 0
[    5.589553] sd 6:0:0:1: Attached scsi generic sg4 type 0
[    5.589710] sd 6:0:0:2: Attached scsi generic sg5 type 0
[    5.589958] sd 6:0:0:3: Attached scsi generic sg6 type 0
[    5.596226] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[    5.596850] sd 6:0:0:1: [sdd] Attached SCSI removable disk
[    5.597472] sd 6:0:0:2: [sde] Attached SCSI removable disk
[    5.598095] sd 6:0:0:3: [sdf] Attached SCSI removable disk
[    5.946322] EXT4-fs (sda5): re-mounted. Opts: (null)
[    6.116727] loop: module loaded
[    6.364889] fuse init (API version 7.20)
[    9.278038] powernow-k8: this CPU is not supported anymore, using
acpi-cpufreq instead.
[    9.291893] acpi-cpufreq: overriding BIOS provided _PSD data
[   12.075949] Bluetooth: Core ver 2.16
[   12.075991] NET: Registered protocol family 31
[   12.075996] Bluetooth: HCI device and connection manager initialized
[   12.076012] Bluetooth: HCI socket layer initialized
[   12.076018] Bluetooth: L2CAP socket layer initialized
[   12.076030] Bluetooth: SCO socket layer initialized
[   12.118890] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   12.118897] Bluetooth: BNEP filters: protocol multicast
[   12.118909] Bluetooth: BNEP socket layer initialized
[   12.223961] Bluetooth: RFCOMM TTY layer initialized
[   12.223985] Bluetooth: RFCOMM socket layer initialized
[   12.223990] Bluetooth: RFCOMM ver 1.11
[   12.910677] lp: driver loaded but no devices found
[   12.980196] ppdev: user-space parallel port driver
[   13.838925] r8169 0000:02:00.0 eth0: link down
[   13.839005] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.845982] rtl8192cu: MAC auto ON okay!
[   13.878681] rtl8192cu: Tx queue select: 0x05
[   14.241381] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   14.524288] ip_tables: (C) 2000-2006 Netfilter Core Team
[   16.197830] wlan0: authenticate with 98:fc:11:53:75:00
[   16.221337] wlan0: send auth to 98:fc:11:53:75:00 (try 1/3)
[   16.223862] wlan0: authenticated
[   16.224732] wlan0: associate with 98:fc:11:53:75:00 (try 1/3)
[   16.261905] wlan0: RX AssocResp from 98:fc:11:53:75:00 (capab=0x411 status=0
aid=2)
[   16.262025] wlan0: associated
[   16.262094] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  193.819993] Netfilter messages via NETLINK v0.30.
[  205.129021] device wlan0 entered promiscuous mode
[ 1144.460437] device wlan0 left promiscuous mode
[ 1311.394492] wlan0: deauthenticating from 98:fc:11:53:75:00 by local choice
(reason=3)
[ 1311.407497] cfg80211: Calling CRDA to update world regulatory domain
[ 1311.415105] cfg80211: World regulatory domain updated:
[ 1311.415109] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 1311.415111] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[ 1311.415113] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[ 1311.415115] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[ 1311.415116] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[ 1311.415118] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)




Larry Finger <Larry.Finger@...> writes:

>
> On 12/21/2012 03:01 PM, Alden Page wrote:
> > I apologize for sending this to both maintainers listed on the rtl819x
> > privately. I've never had to file a bug before and did not mean to
> > give the impression of malice or selfishness, I'm simply unfamiliar
> > with the way open source developers go about things.
> >
> > In any case, I am having some problems with the rtl8192cu driver.
> > After a period of five minutes to an hour, I will lose connectivity to
> > my wireless router. In the 3.2 kernel, I would be unable to connect
> > until I restarted my computer. My wireless SSID would be visible
> > through nm-applet, but connecting would just result in network-manager
> > prompting me for the password again, attempting to connect for a
> > while, and then timing out before repeating the cycle. I compiled and
> > installed the 3.7.1 kernel to see if it would solve this problem but
> > had no such luck. The only difference is that unplugging the wireless
> > adapter and plugging it back in restores connectivity for a period of
> > time before the problem occurs again. I also get stuck at "Waiting for
> > headers" a lot while waiting for package upgrades. The device is an
> > Encore N150, which uses this particular Realtek chipset. The
> > proprietary driver does not support my architecture. While I
> > appreciate the invitation to "look for the problem myself", I have no
> > experience working with the kernel or writing drivers. I'll do my best
> > anyway, of course.
> >
> > Some information about my system:
> > Crunchbang 11 on kernel 3.7.1 amd64
> > Encore N150 Wireless USB adapter, using network-manager and nm-applet
> > Connecting to a Linksys E3000. Works fine with all other devices in the house
> >
> > The adapter does not lose its connection in Windows, so I think
> > hardware failure is unlikely.
> >
> > Relevant modules:
> > rtl8192cu              75225  0
> > rtlwifi                81359  1 rtl8192cu
> > rtl8192c_common        48515  1 rtl8192cu
>
> One point. GregKH is the maintainer of drivers/staging/*. Some of the Realtek
> drivers are in that tree because they do not meet all the requirements for
> inclusion in the main drivers/net/wireless tree. The driver in question,
> rtl8192cu, is found in drivers/net/wireless.
>
> > The output of dmesg is attached in plaintext.
> >
> > Thanks for your time (and the warm welcome)
>
> Your attached dmesg output did not even show a disconnection. Why was that?
>
> Larry
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

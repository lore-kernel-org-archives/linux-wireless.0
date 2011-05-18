Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56339 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688Ab1ERQWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 12:22:00 -0400
Received: by eyx24 with SMTP id 24so493600eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 09:21:57 -0700 (PDT)
From: Stevie Trujillo <stevie.trujillo@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: iwlagn: 2.6.38.6 memory corruption when unloading module?
Date: Wed, 18 May 2011 18:21:49 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_dI/0NlIKhSVqAJm"
Message-Id: <201105181821.49508.stevie.trujillo@gmail.com> (sfid-20110518_182209_631877_308A45E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_dI/0NlIKhSVqAJm
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

I have a Dell-XPS 15 with a Intel(R) Centrino(R) Wireless-N 1030 BGN card.
Doing modprobe -r iwlagn; modprobe iwlagn makes my kernel crash (sometimes I 
have to repeat it).
I managed to get a backtrace (the file "dmesg-kexec.txt" attached) with the 
advice of Milton Miller.
I also tried to boot with slub_debug=FZ (not exactly sure what that does) - 
dmesg attached in "dmesg-slub_debug.txt".

--
Stevie Trujillo

--Boundary-00=_dI/0NlIKhSVqAJm
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg-slub_debug.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg-slub_debug.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38.6-dbg (root@cnulaptop) (gcc version 4.4=
=2E5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #1 SMP Wed May 18 17:39:58 CEST 2011
[    0.000000] Command line: root=3D/dev/sda6 crashkernel=3D160M mem=3D512M=
 slub_debug=3DFZ
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bac8f000 (usable)
[    0.000000]  BIOS-e820: 00000000bac8f000 - 00000000bacac000 (reserved)
[    0.000000]  BIOS-e820: 00000000bacac000 - 00000000bacba000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bacba000 - 00000000badfa000 (reserved)
[    0.000000]  BIOS-e820: 00000000badfa000 - 00000000badfc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000badfc000 - 00000000badfe000 (reserved)
[    0.000000]  BIOS-e820: 00000000badfe000 - 00000000bae01000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bae01000 - 00000000bae04000 (reserved)
[    0.000000]  BIOS-e820: 00000000bae04000 - 00000000bae05000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bae05000 - 00000000bae0a000 (reserved)
[    0.000000]  BIOS-e820: 00000000bae0a000 - 00000000bae1b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bae1b000 - 00000000baf18000 (reserved)
[    0.000000]  BIOS-e820: 00000000baf18000 - 00000000baf1c000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000baf1c000 - 00000000baf1f000 (reserved)
[    0.000000]  BIOS-e820: 00000000baf1f000 - 00000000baf9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000baf9f000 - 00000000bafff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bafff000 - 00000000bb000000 (usable)
[    0.000000]  BIOS-e820: 00000000bb000000 - 00000000bfa00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed08000 - 00000000fed09000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffd80000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000023fe00000 (usable)
[    0.000000] e820 remove range: 0000000020000000 - ffffffffffffffff (usab=
le)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] user-defined physical RAM map:
[    0.000000]  user: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  user: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  user: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  user: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  user: 00000000bac8f000 - 00000000bacac000 (reserved)
[    0.000000]  user: 00000000bacac000 - 00000000bacba000 (ACPI NVS)
[    0.000000]  user: 00000000bacba000 - 00000000badfa000 (reserved)
[    0.000000]  user: 00000000badfa000 - 00000000badfc000 (ACPI NVS)
[    0.000000]  user: 00000000badfc000 - 00000000badfe000 (reserved)
[    0.000000]  user: 00000000badfe000 - 00000000bae01000 (ACPI NVS)
[    0.000000]  user: 00000000bae01000 - 00000000bae04000 (reserved)
[    0.000000]  user: 00000000bae04000 - 00000000bae05000 (ACPI NVS)
[    0.000000]  user: 00000000bae05000 - 00000000bae0a000 (reserved)
[    0.000000]  user: 00000000bae0a000 - 00000000bae1b000 (ACPI NVS)
[    0.000000]  user: 00000000bae1b000 - 00000000baf18000 (reserved)
[    0.000000]  user: 00000000baf18000 - 00000000baf1c000 (ACPI NVS)
[    0.000000]  user: 00000000baf1c000 - 00000000baf1f000 (reserved)
[    0.000000]  user: 00000000baf1f000 - 00000000baf9f000 (ACPI NVS)
[    0.000000]  user: 00000000baf9f000 - 00000000bafff000 (ACPI data)
[    0.000000]  user: 00000000bb000000 - 00000000bfa00000 (reserved)
[    0.000000]  user: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  user: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  user: 00000000fed08000 - 00000000fed09000 (reserved)
[    0.000000]  user: 00000000fed10000 - 00000000fed1a000 (reserved)
[    0.000000]  user: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  user: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  user: 00000000ffd80000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Dell Inc.          Dell System XPS L502X/0YR8NN, BIOS A=
04 03/25/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x20000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0BB000000 mask FFF000000 uncachable
[    0.000000]   5 base 100000000 mask F00000000 write-back
[    0.000000]   6 base 200000000 mask FC0000000 write-back
[    0.000000]   7 base 23FE00000 mask FFFE00000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-0000000020000000
[    0.000000]  0000000000 - 0020000000 page 2M
[    0.000000] kernel direct mapping tables up to 20000000 @ 1fffe000-20000=
000
[    0.000000] Reserving 160MB of memory at 352MB for crashkernel (System R=
AM: 512MB)
[    0.000000] ACPI: RSDP 00000000000f00e0 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000baffe120 00094 (v01 DELL    QA09    00000=
002 LOHR 00000002)
[    0.000000] ACPI: FACP 00000000bafef000 000F4 (v03 DELL    QA09    00000=
002 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000baff2000 08C85 (v02 DELL    SNB-CPT 00000=
000 INTL 20061109)
[    0.000000] ACPI: FACS 00000000baf3f000 00040
[    0.000000] ACPI: SLIC 00000000baffd000 00176 (v01 DELL    QA09    00000=
002 LOHR 00000001)
[    0.000000] ACPI: SSDT 00000000baffb000 01068 (v01 DELL   PtidDevc 00001=
000 INTL 20061109)
[    0.000000] ACPI: ASF! 00000000baff1000 000A5 (v32 DELL    QA09    00000=
002 PTL  00000002)
[    0.000000] ACPI: HPET 00000000bafee000 00038 (v01 DELL    QA09    00000=
002 PTL  00000002)
[    0.000000] ACPI: APIC 00000000bafed000 00098 (v01 DELL    QA09    00000=
002 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000bafec000 0003C (v01 DELL    QA09    00000=
002 PTL  00000002)
[    0.000000] ACPI: SSDT 00000000bafea000 01217 (v01 NvORef NvOptTbl 00001=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000bafe9000 00804 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000bafe8000 00996 (v01  PmRef    CpuPm 00003=
000 INTL 20061109)
[    0.000000] ACPI: UEFI 00000000bafe7000 0003E (v01 DELL    QA09    00000=
002 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000bafe6000 00042 (v01 PTL      COMBUF 00000=
001 PTL  00000001)
[    0.000000] ACPI: DMAR 00000000bafe5000 000E8 (v01 INTEL      SNB  00000=
001 INTL 00000001)
[    0.000000] ACPI: UEFI 00000000bafe4000 0026A (v01 DELL    QA09    00000=
002 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff880014e0000=
0-ffff8800155fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000] On node 0 totalpages: 130957
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3919 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1736 pages used for memmap
[    0.000000]   DMA32 zone: 125240 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000=
9e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 00000000001=
00000
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 20000000=
:9ac8f000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880015c00000 s74880 r8192=
 d23424 u262144
[    0.000000] pcpu-alloc: s74880 r8192 d23424 u262144 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 129159
[    0.000000] Kernel command line: root=3D/dev/sda6 crashkernel=3D160M mem=
=3D512M slub_debug=3DFZ
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Queued invalidation will be enabled to support x2apic and In=
tr-remapping.
[    0.000000] Memory: 342504k/524288k available (3495k kernel code, 460k a=
bsent, 181324k reserved, 2945k data, 428k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D8, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2593.548 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5187.09 BogoMIPS (lpj=3D2593548)
[    0.000191] pid_max: default: 32768 minimum: 301
[    0.000334] Mount-cache hash table entries: 256
[    0.000561] Initializing cgroup subsys ns
[    0.000654] ns_cgroup deprecated: consider using the 'clone_children' fl=
ag without the ns_cgroup.
[    0.000814] Initializing cgroup subsys cpuacct
[    0.000910] Initializing cgroup subsys freezer
[    0.001032] CPU: Physical Processor ID: 0
[    0.001125] CPU: Processor Core ID: 0
[    0.001219] mce: CPU supports 7 MCE banks
[    0.001317] CPU0: Thermal monitoring handled by SMI
[    0.001322] using mwait in idle threads.
[    0.001461] ACPI: Core revision 20110112
[    0.071378] DMAR: Host address width 36
[    0.071472] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.071572] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 e=
cap f0101a
[    0.071728] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.071826] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 e=
cap f0105a
[    0.071972] DMAR: RMRR base: 0x000000bae1d000 end: 0x000000bae33fff
[    0.072070] DMAR: RMRR base: 0x000000bb800000 end: 0x000000bf9fffff
[    0.072168] DMAR: No ATSR found
[    0.072329] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.072425] HPET id 0 under DRHD base 0xfed91000
[    0.072519] HPET id 0 under DRHD base 0xfed91000
[    0.073947] HPET id 0 under DRHD base 0xfed91000
[    0.074041] HPET id 0 under DRHD base 0xfed91000
[    0.074134] HPET id 0 under DRHD base 0xfed91000
[    0.074228] HPET id 0 under DRHD base 0xfed91000
[    0.074322] HPET id 0 under DRHD base 0xfed91000
[    0.074415] HPET id 0 under DRHD base 0xfed91000
[    0.074750] Enabled Interrupt-remapping
[    0.074864] Setting APIC routing to flat
[    0.075333] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
=2D1
[    0.085409] CPU0: Intel(R) Core(TM) i5-2540M CPU @ 2.60GHz stepping 07
[    0.186422] Performance Events: PEBS fmt1+, generic architected perfmon,=
 Intel PMU driver.
[    0.186690] ... version:                3
[    0.186782] ... bit width:              48
[    0.186875] ... generic registers:      4
[    0.186969] ... value mask:             0000ffffffffffff
[    0.187064] ... max period:             000000007fffffff
[    0.187160] ... fixed-purpose events:   3
[    0.187253] ... event mask:             000000070000000f
[    0.187484] Booting Node   0, Processors  #1
[    0.258297] CPU1: Thermal monitoring handled by SMI
[    0.278406]  #2
[    0.349113] CPU2: Thermal monitoring handled by SMI
[    0.369221]  #3
[    0.439929] CPU3: Thermal monitoring handled by SMI
[    0.459974] Brought up 4 CPUs
[    0.460154] Total of 4 processors activated (20749.74 BogoMIPS).
[    0.461937] PM: Adding info for No Bus:platform
[    0.462353] Time: 18:03:11  Date: 05/18/11
[    0.462493] NET: Registered protocol family 16
[    0.462751] PM: Adding info for No Bus:vtcon0
[    0.462785] ACPI: bus type pci registered
[    0.462934] PM: Adding info for No Bus:id
[    0.463001] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
=2D0xfbffffff] (base 0xf8000000)
[    0.463151] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.466850] PCI: Using configuration type 1 for base access
[    0.470351] PM: Adding info for No Bus:default
[    0.470404] bio: create slab <bio-0> at 0
[    0.471995] ACPI: EC: Look up EC in DSDT
[    0.473553] ACPI: Executed 1 blocks of module-level executable AML code
[    0.493945] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.496001] ACPI: SSDT 00000000bae06718 0067C (v01  PmRef  Cpu0Cst 00003=
001 INTL 20061109)
[    0.496785] ACPI: Dynamic OEM Table Load:
[    0.496960] ACPI: SSDT           (null) 0067C (v01  PmRef  Cpu0Cst 00003=
001 INTL 20061109)
[    0.500986] ACPI: SSDT 00000000bae07a98 00303 (v01  PmRef    ApIst 00003=
000 INTL 20061109)
[    0.501945] ACPI: Dynamic OEM Table Load:
[    0.502117] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003=
000 INTL 20061109)
[    0.505245] ACPI: SSDT 00000000bae05d98 00119 (v01  PmRef    ApCst 00003=
000 INTL 20061109)
[    0.505950] ACPI: Dynamic OEM Table Load:
[    0.506122] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003=
000 INTL 20061109)
[    0.514338] ACPI: Interpreter enabled
[    0.514432] ACPI: (supports S0 S3 S4 S5)
[    0.514755] ACPI: Using IOAPIC for interrupt routing
[    0.515026] PM: Adding info for acpi:LNXSYSTM:00
[    0.515101] PM: Adding info for acpi:LNXCPU:00
[    0.515178] PM: Adding info for acpi:LNXCPU:01
[    0.515247] PM: Adding info for acpi:LNXCPU:02
[    0.515315] PM: Adding info for acpi:LNXCPU:03
[    0.515387] PM: Adding info for acpi:LNXCPU:04
[    0.515456] PM: Adding info for acpi:LNXCPU:05
[    0.515523] PM: Adding info for acpi:LNXCPU:06
[    0.515591] PM: Adding info for acpi:LNXCPU:07
[    0.515717] PM: Adding info for acpi:device:00
[    0.515863] PM: Adding info for acpi:PNP0C14:00
[    0.516039] PM: Adding info for acpi:PNP0A08:00
[    0.516520] PM: Adding info for acpi:device:01
[    0.516643] PM: Adding info for acpi:device:02
[    0.516771] PM: Adding info for acpi:PNP0200:00
[    0.517040] PM: Adding info for acpi:PNP0103:00
[    0.517163] PM: Adding info for acpi:PNP0000:00
[    0.517279] PM: Adding info for acpi:PNP0C04:00
[    0.517402] PM: Adding info for acpi:PNP0C02:00
[    0.517514] PM: Adding info for acpi:PNP0B00:00
[    0.517631] PM: Adding info for acpi:PNP0100:00
[    0.517833] PM: Adding info for acpi:INT3F0D:00
[    0.518005] PM: Adding info for acpi:PNP0C09:00
[    0.518323] PM: Adding info for acpi:PNP0303:00
[    0.518613] PM: Adding info for acpi:DLL04B6:00
[    0.518724] PM: Adding info for acpi:PNP0C02:01
[    0.519261] PM: Adding info for acpi:device:03
[    0.519360] PM: Adding info for acpi:device:04
[    0.519458] PM: Adding info for acpi:device:05
[    0.519552] PM: Adding info for acpi:device:06
[    0.519647] PM: Adding info for acpi:device:07
[    0.519740] PM: Adding info for acpi:device:08
[    0.519836] PM: Adding info for acpi:device:09
[    0.519972] PM: Adding info for acpi:device:0a
[    0.520063] PM: Adding info for acpi:device:0b
[    0.520156] PM: Adding info for acpi:device:0c
[    0.520246] PM: Adding info for acpi:device:0d
[    0.520338] PM: Adding info for acpi:device:0e
[    0.520860] PM: Adding info for acpi:device:0f
[    0.520954] PM: Adding info for acpi:device:10
[    0.521042] PM: Adding info for acpi:device:11
[    0.521130] PM: Adding info for acpi:device:12
[    0.521223] PM: Adding info for acpi:device:13
[    0.521312] PM: Adding info for acpi:device:14
[    0.521400] PM: Adding info for acpi:device:15
[    0.521483] PM: Adding info for acpi:device:16
[    0.521569] PM: Adding info for acpi:device:17
[    0.521651] PM: Adding info for acpi:device:18
[    0.522044] PM: Adding info for acpi:device:19
[    0.522429] PM: Adding info for acpi:device:1a
[    0.522543] PM: Adding info for acpi:device:1b
[    0.522930] PM: Adding info for acpi:device:1c
[    0.523043] PM: Adding info for acpi:device:1d
[    0.523422] PM: Adding info for acpi:device:1e
[    0.523533] PM: Adding info for acpi:device:1f
[    0.523957] PM: Adding info for acpi:device:20
[    0.524189] PM: Adding info for acpi:device:21
[    0.524706] PM: Adding info for acpi:device:22
[    0.524931] PM: Adding info for acpi:device:23
[    0.525119] PM: Adding info for acpi:device:24
[    0.525302] PM: Adding info for acpi:device:25
[    0.525484] PM: Adding info for acpi:device:26
[    0.525663] PM: Adding info for acpi:device:27
[    0.525848] PM: Adding info for acpi:device:28
[    0.526378] PM: Adding info for acpi:device:29
[    0.526593] PM: Adding info for acpi:device:2a
[    0.527142] PM: Adding info for acpi:device:2b
[    0.527359] PM: Adding info for acpi:device:2c
[    0.527906] PM: Adding info for acpi:device:2d
[    0.528123] PM: Adding info for acpi:device:2e
[    0.528302] PM: Adding info for acpi:device:2f
[    0.528475] PM: Adding info for acpi:device:30
[    0.528652] PM: Adding info for acpi:device:31
[    0.528827] PM: Adding info for acpi:device:32
[    0.529066] PM: Adding info for acpi:device:33
[    0.529362] PM: Adding info for acpi:LNXVIDEO:00
[    0.529618] PM: Adding info for acpi:LNXVIDEO:01
[    0.529867] PM: Adding info for acpi:device:34
[    0.530106] PM: Adding info for acpi:device:35
[    0.530344] PM: Adding info for acpi:device:36
[    0.530579] PM: Adding info for acpi:device:37
[    0.530818] PM: Adding info for acpi:device:38
[    0.531054] PM: Adding info for acpi:device:39
[    0.531290] PM: Adding info for acpi:device:3a
[    0.531524] PM: Adding info for acpi:device:3b
[    0.531772] PM: Adding info for acpi:SMO8800:00
[    0.532104] PM: Adding info for acpi:PNP0C0F:00
[    0.532374] PM: Adding info for acpi:PNP0C0F:01
[    0.532638] PM: Adding info for acpi:PNP0C0F:02
[    0.532905] PM: Adding info for acpi:PNP0C0F:03
[    0.533161] PM: Adding info for acpi:PNP0C0F:04
[    0.533416] PM: Adding info for acpi:PNP0C0F:05
[    0.533670] PM: Adding info for acpi:PNP0C0F:06
[    0.533929] PM: Adding info for acpi:PNP0C0F:07
[    0.534086] PM: Adding info for acpi:PNP0C0C:00
[    0.534241] PM: Adding info for acpi:PNP0C0E:00
[    0.535360] PM: Adding info for acpi:PNP0C0D:00
[    0.535516] PM: Adding info for acpi:ACPI0003:00
[    0.535784] PM: Adding info for acpi:PNP0C0A:00
[    0.535980] PM: Adding info for acpi:INT340E:00
[    0.536127] PM: Adding info for acpi:device:3c
[    0.536200] PM: Adding info for acpi:LNXTHERM:00
[    0.536272] PM: Adding info for acpi:LNXTHERM:01
[    0.536435] PM: Adding info for acpi:LNXPWRBN:00
[    0.536633] ACPI: EC: GPE =3D 0x17, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.540374] ACPI: No dock devices found.
[    0.540468] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.542440] \_SB_.PCI0:_OSC invalid UUID
[    0.542444] _OSC request data:1 8 1f=20
[    0.542447] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.542561] PM: Adding info for No Bus:pci0000:00
[    0.542578] PM: Adding info for No Bus:0000:00
[    0.545713] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.545812] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.545910] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.546056] pci_root PNP0A08:00: host bridge window [mem 0xbfa00000-0xfe=
afffff]
[    0.546203] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfe=
d44fff]
[    0.546358] pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
[    0.546379] pci 0000:00:00.0: rpm_resume flags 0x0
[    0.546380] pci 0000:00:00.0: rpm_resume returns -11
[    0.546392] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    0.546411] pci 0000:00:01.0: rpm_resume flags 0x0
[    0.546413] pci 0000:00:01.0: rpm_resume returns -11
[    0.546416] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.546419] pci 0000:00:01.0: PME# disabled
[    0.546436] pci 0000:00:02.0: [8086:0126] type 0 class 0x000300
[    0.546445] pci 0000:00:02.0: reg 10: [mem 0xf1400000-0xf17fffff 64bit]
[    0.546451] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit p=
ref]
[    0.546455] pci 0000:00:02.0: reg 20: [io  0x4000-0x403f]
[    0.546468] pci 0000:00:02.0: rpm_resume flags 0x0
[    0.546469] pci 0000:00:02.0: rpm_resume returns -11
[    0.546505] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    0.546528] pci 0000:00:16.0: reg 10: [mem 0xf1c05000-0xf1c0500f 64bit]
[    0.546584] pci 0000:00:16.0: rpm_resume flags 0x0
[    0.546586] pci 0000:00:16.0: rpm_resume returns -11
[    0.546592] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.546596] pci 0000:00:16.0: PME# disabled
[    0.546628] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    0.546649] pci 0000:00:1a.0: reg 10: [mem 0xf1c0a000-0xf1c0a3ff]
[    0.546718] pci 0000:00:1a.0: rpm_resume flags 0x0
[    0.546720] pci 0000:00:1a.0: rpm_resume returns -11
[    0.546726] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.546730] pci 0000:00:1a.0: PME# disabled
[    0.546754] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    0.546769] pci 0000:00:1b.0: reg 10: [mem 0xf1c00000-0xf1c03fff 64bit]
[    0.546820] pci 0000:00:1b.0: rpm_resume flags 0x0
[    0.546821] pci 0000:00:1b.0: rpm_resume returns -11
[    0.546827] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.546831] pci 0000:00:1b.0: PME# disabled
[    0.546855] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    0.546939] pci 0000:00:1c.0: rpm_resume flags 0x0
[    0.546941] pci 0000:00:1c.0: rpm_resume returns -11
[    0.546959] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.546964] pci 0000:00:1c.0: PME# disabled
[    0.546998] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    0.547085] pci 0000:00:1c.1: rpm_resume flags 0x0
[    0.547087] pci 0000:00:1c.1: rpm_resume returns -11
[    0.547105] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.547110] pci 0000:00:1c.1: PME# disabled
[    0.547144] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
[    0.547226] pci 0000:00:1c.3: rpm_resume flags 0x0
[    0.547228] pci 0000:00:1c.3: rpm_resume returns -11
[    0.547246] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.547251] pci 0000:00:1c.3: PME# disabled
[    0.547281] pci 0000:00:1c.4: [8086:1c18] type 1 class 0x000604
[    0.547332] pci 0000:00:1c.4: rpm_resume flags 0x0
[    0.547334] pci 0000:00:1c.4: rpm_resume returns -11
[    0.547346] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.547350] pci 0000:00:1c.4: PME# disabled
[    0.547374] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
[    0.547425] pci 0000:00:1c.5: rpm_resume flags 0x0
[    0.547427] pci 0000:00:1c.5: rpm_resume returns -11
[    0.547438] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.547442] pci 0000:00:1c.5: PME# disabled
[    0.547472] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    0.547492] pci 0000:00:1d.0: reg 10: [mem 0xf1c09000-0xf1c093ff]
[    0.547559] pci 0000:00:1d.0: rpm_resume flags 0x0
[    0.547561] pci 0000:00:1d.0: rpm_resume returns -11
[    0.547567] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.547571] pci 0000:00:1d.0: PME# disabled
[    0.547596] pci 0000:00:1f.0: [8086:1c4b] type 0 class 0x000601
[    0.547683] pci 0000:00:1f.0: rpm_resume flags 0x0
[    0.547684] pci 0000:00:1f.0: rpm_resume returns -11
[    0.547714] pci 0000:00:1f.2: [8086:1c03] type 0 class 0x000106
[    0.547732] pci 0000:00:1f.2: reg 10: [io  0x4088-0x408f]
[    0.547739] pci 0000:00:1f.2: reg 14: [io  0x4094-0x4097]
[    0.547747] pci 0000:00:1f.2: reg 18: [io  0x4080-0x4087]
[    0.547755] pci 0000:00:1f.2: reg 1c: [io  0x4090-0x4093]
[    0.547763] pci 0000:00:1f.2: reg 20: [io  0x4060-0x407f]
[    0.547770] pci 0000:00:1f.2: reg 24: [mem 0xf1c08000-0xf1c087ff]
[    0.547797] pci 0000:00:1f.2: rpm_resume flags 0x0
[    0.547798] pci 0000:00:1f.2: rpm_resume returns -11
[    0.547807] pci 0000:00:1f.2: PME# supported from D3hot
[    0.547810] pci 0000:00:1f.2: PME# disabled
[    0.547829] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    0.547845] pci 0000:00:1f.3: reg 10: [mem 0xf1c04000-0xf1c040ff 64bit]
[    0.547865] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.547884] pci 0000:00:1f.3: rpm_resume flags 0x0
[    0.547886] pci 0000:00:1f.3: rpm_resume returns -11
[    0.547919] pci 0000:01:00.0: [10de:0df5] type 0 class 0x000300
[    0.547927] pci 0000:01:00.0: reg 10: [mem 0xf0000000-0xf0ffffff]
[    0.547935] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit p=
ref]
[    0.547943] pci 0000:01:00.0: reg 1c: [mem 0xd0000000-0xd1ffffff 64bit p=
ref]
[    0.547949] pci 0000:01:00.0: reg 24: [io  0x3000-0x307f]
[    0.547955] pci 0000:01:00.0: reg 30: [mem 0xfff80000-0xffffffff pref]
[    0.547968] pci 0000:01:00.0: rpm_resume flags 0x0
[    0.547970] pci 0000:01:00.0: rpm_resume returns -11
[    0.549713] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.549855] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.549857] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf10fffff]
[    0.549860] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff=
 64bit pref]
[    0.549932] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.550031] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.550036] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.550044] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.550268] pci 0000:03:00.0: [8086:008a] type 0 class 0x000280
[    0.550414] pci 0000:03:00.0: reg 10: [mem 0xf1b00000-0xf1b01fff 64bit]
[    0.550963] pci 0000:03:00.0: rpm_resume flags 0x0
[    0.550964] pci 0000:03:00.0: rpm_resume returns -11
[    0.551019] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.551053] pci 0000:03:00.0: PME# disabled
[    0.552836] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.552935] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.552940] pci 0000:00:1c.1:   bridge window [mem 0xf1b00000-0xf1bfffff]
[    0.552949] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.553093] pci 0000:04:00.0: [1033:0194] type 0 class 0x000c03
[    0.553119] pci 0000:04:00.0: reg 10: [mem 0xf1a00000-0xf1a01fff 64bit]
[    0.553218] pci 0000:04:00.0: rpm_resume flags 0x0
[    0.553219] pci 0000:04:00.0: rpm_resume returns -11
[    0.553228] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.553233] pci 0000:04:00.0: PME# disabled
[    0.554759] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.554880] pci 0000:00:1c.3:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.554884] pci 0000:00:1c.3:   bridge window [mem 0xf1a00000-0xf1afffff]
[    0.554891] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.554935] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
[    0.555032] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disab=
led)
[    0.555037] pci 0000:00:1c.4:   bridge window [mem 0xf1900000-0xf19fffff]
[    0.555043] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff=
 pref] (disabled)
[    0.555108] pci 0000:06:00.0: [10ec:8168] type 0 class 0x000200
[    0.555128] pci 0000:06:00.0: reg 10: [io  0x2000-0x20ff]
[    0.555162] pci 0000:06:00.0: reg 18: [mem 0xf1804000-0xf1804fff 64bit p=
ref]
[    0.555184] pci 0000:06:00.0: reg 20: [mem 0xf1800000-0xf1803fff 64bit p=
ref]
[    0.555237] pci 0000:06:00.0: rpm_resume flags 0x0
[    0.555239] pci 0000:06:00.0: rpm_resume returns -11
[    0.555248] pci 0000:06:00.0: supports D1 D2
[    0.555249] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.555254] pci 0000:06:00.0: PME# disabled
[    0.556706] pci 0000:00:1c.5: PCI bridge to [bus 06-06]
[    0.556845] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.556849] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff=
] (disabled)
[    0.556855] pci 0000:00:1c.5:   bridge window [mem 0xf1800000-0xf18fffff=
 64bit pref]
[    0.556889] pci_bus 0000:00: on NUMA node 0
[    0.556894] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.557608] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.557777] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.557953] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.558126] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.558360] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.558571] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    0.558909] \_SB_.PCI0:_OSC invalid UUID
[    0.558912] _OSC request data:1 1f 1f=20
[    0.558916]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.559180] \_SB_.PCI0:_OSC invalid UUID
[    0.559183] _OSC request data:1 0 1d=20
[    0.560372] PM: Adding info for pci:0000:00:00.0
[    0.561585] PM: Adding info for pci:0000:00:01.0
[    0.562791] PM: Adding info for pci:0000:00:02.0
[    0.563985] PM: Adding info for pci:0000:00:16.0
[    0.565176] PM: Adding info for pci:0000:00:1a.0
[    0.566361] PM: Adding info for pci:0000:00:1b.0
[    0.567539] PM: Adding info for pci:0000:00:1c.0
[    0.568713] PM: Adding info for pci:0000:00:1c.1
[    0.569890] PM: Adding info for pci:0000:00:1c.3
[    0.571049] PM: Adding info for pci:0000:00:1c.4
[    0.572203] PM: Adding info for pci:0000:00:1c.5
[    0.573350] PM: Adding info for pci:0000:00:1d.0
[    0.574492] PM: Adding info for pci:0000:00:1f.0
[    0.575630] PM: Adding info for pci:0000:00:1f.2
[    0.576763] PM: Adding info for pci:0000:00:1f.3
[    0.576886] PM: Adding info for pci:0000:01:00.0
[    0.576928] PM: Adding info for No Bus:0000:01
[    0.576970] PM: Adding info for No Bus:0000:02
[    0.577065] PM: Adding info for pci:0000:03:00.0
[    0.577105] PM: Adding info for No Bus:0000:03
[    0.577198] PM: Adding info for pci:0000:04:00.0
[    0.577240] PM: Adding info for No Bus:0000:04
[    0.577279] PM: Adding info for No Bus:0000:05
[    0.577370] PM: Adding info for pci:0000:06:00.0
[    0.577411] PM: Adding info for No Bus:0000:06
[    0.577617] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14=
 15)
[    0.578351] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 *11 12 14=
 15)
[    0.579082] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14=
 15)
[    0.579811] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14=
 15)
[    0.580533] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 =
15) *0, disabled.
[    0.581385] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 =
15) *0, disabled.
[    0.582246] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 *11 12 14=
 15)
[    0.582974] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *10 11 12 14=
 15)
[    0.583690] PM: Adding info for No Bus:vga_arbiter
[    0.583727] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.583906] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=
=3Dnone,locks=3Dnone
[    0.584062] vgaarb: loaded
[    0.584336] SCSI subsystem initialized
[    0.584509] libata version 3.00 loaded.
[    0.584586] usbcore: registered new interface driver usbfs
[    0.584730] usbcore: registered new interface driver hub
[    0.584865] usbcore: registered new device driver usb
[    0.585077] PCI: Using ACPI for IRQ routing
[    0.585171] PCI: pci_cache_line_size set to 64 bytes
[    0.585423] reserve RAM buffer: 000000000009d800 - 000000000009ffff=20
[    0.585509] PM: Adding info for No Bus:lo
[    0.585674] PM: Adding info for platform:regulatory.0
[    0.585706] cfg80211: Calling CRDA to update world regulatory domain
[    0.586003] PM: Adding info for No Bus:rfkill
[    0.586039] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.586487] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.588634] Switching to clocksource hpet
[    0.588804] pnp: PnP ACPI init
[    0.588907] PM: Adding info for No Bus:pnp0
[    0.588908] ACPI: bus type pnp registered
[    0.589618] Switched to NOHz mode on CPU #0
[    0.589714] Switched to NOHz mode on CPU #3
[    0.589717] Switched to NOHz mode on CPU #2
[    0.589726] Switched to NOHz mode on CPU #1
[    0.590765] pnp 00:00: [bus 00-3e]
[    0.590767] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.590769] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.590770] pnp 00:00: [io  0x0d00-0xffff window]
[    0.590772] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.590774] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.590776] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.590777] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.590785] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.590787] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.590789] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.590790] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.590794] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.590796] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.590797] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.590799] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.590801] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.590802] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.590804] pnp 00:00: [mem 0xbfa00000-0xfeafffff window]
[    0.590806] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.590846] PM: Adding info for pnp:00:00
[    0.590888] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (a=
ctive)
[    0.590929] pnp 00:01: [io  0x0000-0x001f]
[    0.590931] pnp 00:01: [io  0x0081-0x0091]
[    0.590932] pnp 00:01: [io  0x0093-0x009f]
[    0.590933] pnp 00:01: [io  0x00c0-0x00df]
[    0.590935] pnp 00:01: [dma 4]
[    0.590958] PM: Adding info for pnp:00:01
[    0.590995] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.591238] pnp 00:02: [mem 0xfed00000-0xfed003ff]
[    0.591261] PM: Adding info for pnp:00:02
[    0.591297] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.591329] pnp 00:03: [io  0x00f0]
[    0.591337] pnp 00:03: [irq 13]
[    0.591360] PM: Adding info for pnp:00:03
[    0.591396] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.591422] pnp 00:04: [io  0x002e-0x002f]
[    0.591424] pnp 00:04: [io  0x004e-0x004f]
[    0.591425] pnp 00:04: [io  0x0061]
[    0.591427] pnp 00:04: [io  0x0063]
[    0.591428] pnp 00:04: [io  0x0065]
[    0.591429] pnp 00:04: [io  0x0067]
[    0.591431] pnp 00:04: [io  0x0068]
[    0.591432] pnp 00:04: [io  0x006c]
[    0.591433] pnp 00:04: [io  0x0070]
[    0.591435] pnp 00:04: [io  0x0080]
[    0.591436] pnp 00:04: [io  0x0092]
[    0.591437] pnp 00:04: [io  0x00b2-0x00b3]
[    0.591439] pnp 00:04: [io  0x0680-0x069f]
[    0.591440] pnp 00:04: [io  0x1000-0x1003]
[    0.591442] pnp 00:04: [io  0x1004-0x1013]
[    0.591443] pnp 00:04: [io  0xffff]
[    0.591444] pnp 00:04: [io  0x0400-0x0453]
[    0.591446] pnp 00:04: [io  0x0458-0x047f]
[    0.591447] pnp 00:04: [io  0x0500-0x057f]
[    0.591449] pnp 00:04: [io  0x164e-0x164f]
[    0.591524] PM: Adding info for pnp:00:04
[    0.591565] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.591663] system 00:04: [io  0x1000-0x1003] has been reserved
[    0.591763] system 00:04: [io  0x1004-0x1013] has been reserved
[    0.591871] system 00:04: [io  0xffff] has been reserved
[    0.591967] system 00:04: [io  0x0400-0x0453] has been reserved
[    0.592064] system 00:04: [io  0x0458-0x047f] has been reserved
[    0.592162] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.592259] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.592356] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.592382] pnp 00:05: [io  0x0070-0x0077]
[    0.592388] pnp 00:05: [irq 8]
[    0.592410] PM: Adding info for pnp:00:05
[    0.592447] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.592544] pnp 00:06: [io  0x0454-0x0457]
[    0.592613] PM: Adding info for pnp:00:06
[    0.592652] system 00:06: [io  0x0454-0x0457] has been reserved
[    0.592750] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02=
 (active)
[    0.592871] pnp 00:07: [io  0x0060]
[    0.592872] pnp 00:07: [io  0x0064]
[    0.592878] pnp 00:07: [irq 1]
[    0.592901] PM: Adding info for pnp:00:07
[    0.592939] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.593042] pnp 00:08: [irq 12]
[    0.593076] PM: Adding info for pnp:00:08
[    0.593116] pnp 00:08: Plug and Play ACPI device, IDs DLL04b6 PNP0f13 (a=
ctive)
[    0.593543] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    0.593545] pnp 00:09: [mem 0xfed10000-0xfed17fff]
[    0.593546] pnp 00:09: [mem 0xfed18000-0xfed18fff]
[    0.593548] pnp 00:09: [mem 0xfed19000-0xfed19fff]
[    0.593549] pnp 00:09: [mem 0xf8000000-0xfbffffff]
[    0.593551] pnp 00:09: [mem 0xfed20000-0xfed3ffff]
[    0.593552] pnp 00:09: [mem 0xfed90000-0xfed93fff]
[    0.593554] pnp 00:09: [mem 0xfed45000-0xfed8ffff]
[    0.593555] pnp 00:09: [mem 0xff000000-0xffffffff]
[    0.593557] pnp 00:09: [mem 0xfee00000-0xfeefffff]
[    0.593559] pnp 00:09: [mem 0xfffff000-0xffffffff]
[    0.593602] pnp 00:09: disabling [mem 0xfffff000-0xffffffff] because it =
overlaps 0000:01:00.0 BAR 6 [mem 0xfff80000-0xffffffff pref]
[    0.593799] PM: Adding info for pnp:00:09
[    0.593843] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.593942] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.594040] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.594139] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.594237] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.594335] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.594434] system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.594532] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.594632] system 00:09: [mem 0xff000000-0xffffffff] could not be reser=
ved
[    0.594732] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    0.594842] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.595278] pnp 00:0a: [irq 20]
[    0.595316] PM: Adding info for pnp:00:0a
[    0.595353] pnp 00:0a: Plug and Play ACPI device, IDs SMO8800 (active)
[    0.595880] pnp: PnP ACPI: found 11 devices
[    0.595975] ACPI: ACPI bus type pnp unregistered
[    0.596129] PM: Adding info for No Bus:mem
[    0.596176] PM: Adding info for No Bus:kmem
[    0.596226] PM: Adding info for No Bus:null
[    0.596273] PM: Adding info for No Bus:port
[    0.596322] PM: Adding info for No Bus:zero
[    0.596370] PM: Adding info for No Bus:full
[    0.596420] PM: Adding info for No Bus:random
[    0.596469] PM: Adding info for No Bus:urandom
[    0.596517] PM: Adding info for No Bus:kmsg
[    0.596566] PM: Adding info for No Bus:oldmem
[    0.596616] PM: Adding info for No Bus:tty
[    0.596668] PM: Adding info for No Bus:console
[    0.596728] PM: Adding info for No Bus:tty0
[    0.596828] PM: Adding info for No Bus:vcs
[    0.596876] PM: Adding info for No Bus:vcsa
[    0.596925] PM: Adding info for No Bus:vcs1
[    0.596975] PM: Adding info for No Bus:vcsa1
[    0.597033] PM: Adding info for No Bus:tty1
[    0.597081] PM: Adding info for No Bus:tty2
[    0.597130] PM: Adding info for No Bus:tty3
[    0.597178] PM: Adding info for No Bus:tty4
[    0.597228] PM: Adding info for No Bus:tty5
[    0.597276] PM: Adding info for No Bus:tty6
[    0.597328] PM: Adding info for No Bus:tty7
[    0.597375] PM: Adding info for No Bus:tty8
[    0.597427] PM: Adding info for No Bus:tty9
[    0.597477] PM: Adding info for No Bus:tty10
[    0.597528] PM: Adding info for No Bus:tty11
[    0.597576] PM: Adding info for No Bus:tty12
[    0.597626] PM: Adding info for No Bus:tty13
[    0.597676] PM: Adding info for No Bus:tty14
[    0.597724] PM: Adding info for No Bus:tty15
[    0.597785] PM: Adding info for No Bus:tty16
[    0.597833] PM: Adding info for No Bus:tty17
[    0.597883] PM: Adding info for No Bus:tty18
[    0.597932] PM: Adding info for No Bus:tty19
[    0.597982] PM: Adding info for No Bus:tty20
[    0.598029] PM: Adding info for No Bus:tty21
[    0.598080] PM: Adding info for No Bus:tty22
[    0.598128] PM: Adding info for No Bus:tty23
[    0.598178] PM: Adding info for No Bus:tty24
[    0.598229] PM: Adding info for No Bus:tty25
[    0.598287] PM: Adding info for No Bus:tty26
[    0.598336] PM: Adding info for No Bus:tty27
[    0.598386] PM: Adding info for No Bus:tty28
[    0.598452] PM: Adding info for No Bus:tty29
[    0.598504] PM: Adding info for No Bus:tty30
[    0.598554] PM: Adding info for No Bus:tty31
[    0.598605] PM: Adding info for No Bus:tty32
[    0.598653] PM: Adding info for No Bus:tty33
[    0.598703] PM: Adding info for No Bus:tty34
[    0.598753] PM: Adding info for No Bus:tty35
[    0.598814] PM: Adding info for No Bus:tty36
[    0.598868] PM: Adding info for No Bus:tty37
[    0.598916] PM: Adding info for No Bus:tty38
[    0.598967] PM: Adding info for No Bus:tty39
[    0.599015] PM: Adding info for No Bus:tty40
[    0.599068] PM: Adding info for No Bus:tty41
[    0.599116] PM: Adding info for No Bus:tty42
[    0.599167] PM: Adding info for No Bus:tty43
[    0.599216] PM: Adding info for No Bus:tty44
[    0.599266] PM: Adding info for No Bus:tty45
[    0.599318] PM: Adding info for No Bus:tty46
[    0.599371] PM: Adding info for No Bus:tty47
[    0.599420] PM: Adding info for No Bus:tty48
[    0.599472] PM: Adding info for No Bus:tty49
[    0.599523] PM: Adding info for No Bus:tty50
[    0.599573] PM: Adding info for No Bus:tty51
[    0.599624] PM: Adding info for No Bus:tty52
[    0.599678] PM: Adding info for No Bus:tty53
[    0.599728] PM: Adding info for No Bus:tty54
[    0.599791] PM: Adding info for No Bus:tty55
[    0.599844] PM: Adding info for No Bus:tty56
[    0.599894] PM: Adding info for No Bus:tty57
[    0.599951] PM: Adding info for No Bus:tty58
[    0.600002] PM: Adding info for No Bus:tty59
[    0.600054] PM: Adding info for No Bus:tty60
[    0.600104] PM: Adding info for No Bus:tty61
[    0.600155] PM: Adding info for No Bus:tty62
[    0.600213] PM: Adding info for No Bus:tty63
[    0.604905] pci 0000:01:00.0: no compatible bridge window for [mem 0xfff=
80000-0xffffffff pref]
[    0.605115] pci 0000:01:00.0: BAR 6: assigned [mem 0xf1000000-0xf107ffff=
 pref]
[    0.605263] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.605359] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.605458] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf10fffff]
[    0.605557] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff=
 64bit pref]
[    0.605705] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.605810] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.605912] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.606011] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.606115] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.606209] pci 0000:00:1c.1:   bridge window [io  disabled]
[    0.606309] pci 0000:00:1c.1:   bridge window [mem 0xf1b00000-0xf1bfffff]
[    0.606410] pci 0000:00:1c.1:   bridge window [mem pref disabled]
[    0.606514] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
[    0.606609] pci 0000:00:1c.3:   bridge window [io  disabled]
[    0.606710] pci 0000:00:1c.3:   bridge window [mem 0xf1a00000-0xf1afffff]
[    0.606819] pci 0000:00:1c.3:   bridge window [mem pref disabled]
[    0.606923] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
[    0.607017] pci 0000:00:1c.4:   bridge window [io  disabled]
[    0.607116] pci 0000:00:1c.4:   bridge window [mem 0xf1900000-0xf19fffff]
[    0.607217] pci 0000:00:1c.4:   bridge window [mem pref disabled]
[    0.607317] pci 0000:00:1c.5: PCI bridge to [bus 06-06]
[    0.607413] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.607513] pci 0000:00:1c.5:   bridge window [mem disabled]
[    0.607611] pci 0000:00:1c.5:   bridge window [mem 0xf1800000-0xf18fffff=
 64bit pref]
[    0.607776] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.607876] pci 0000:00:01.0: setting latency timer to 64
[    0.607882] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.607985] pci 0000:00:1c.0: setting latency timer to 64
[    0.607996] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.608098] pci 0000:00:1c.1: setting latency timer to 64
[    0.608109] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.608210] pci 0000:00:1c.3: setting latency timer to 64
[    0.608217] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.608316] pci 0000:00:1c.4: setting latency timer to 64
[    0.608323] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.608422] pci 0000:00:1c.5: setting latency timer to 64
[    0.608426] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.608427] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.608429] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.608430] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xfeafffff]
[    0.608432] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.608434] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.608435] pci_bus 0000:01: resource 1 [mem 0xf0000000-0xf10fffff]
[    0.608437] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xd1ffffff 64bit=
 pref]
[    0.608439] pci_bus 0000:03: resource 1 [mem 0xf1b00000-0xf1bfffff]
[    0.608440] pci_bus 0000:04: resource 1 [mem 0xf1a00000-0xf1afffff]
[    0.608442] pci_bus 0000:05: resource 1 [mem 0xf1900000-0xf19fffff]
[    0.608444] pci_bus 0000:06: resource 0 [io  0x2000-0x2fff]
[    0.608445] pci_bus 0000:06: resource 2 [mem 0xf1800000-0xf18fffff 64bit=
 pref]
[    0.608476] NET: Registered protocol family 2
[    0.608605] IP route cache hash table entries: 4096 (order: 3, 32768 byt=
es)
[    0.608843] TCP established hash table entries: 16384 (order: 6, 262144 =
bytes)
[    0.609024] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.609150] TCP: Hash tables configured (established 16384 bind 16384)
[    0.609248] TCP reno registered
[    0.609341] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    0.609439] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    0.609639] NET: Registered protocol family 1
[    0.609756] pci 0000:00:02.0: Boot video device
[    0.610594] PCI: CLS 64 bytes, default 64
[    0.610715] IOMMU 0 0xfed90000: using Queued invalidation
[    0.610820] IOMMU 1 0xfed91000: using Queued invalidation
[    0.610918] IOMMU: Setting RMRR:
[    0.611024] IOMMU: Setting identity map for device 0000:00:02.0 [0xbb800=
000 - 0xbfa00000]
[    0.611514] IOMMU: Setting identity map for device 0000:00:1d.0 [0xbae1d=
000 - 0xbae34000]
[    0.611683] IOMMU: Setting identity map for device 0000:00:1a.0 [0xbae1d=
000 - 0xbae34000]
[    0.613189] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.613296] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0=
x1000000]
[    0.613718] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    0.615028] PM: Adding info for No Bus:mcelog
[    0.615130] PM: Adding info for No Bus:msr0
[    0.615180] PM: Adding info for No Bus:msr1
[    0.615230] PM: Adding info for No Bus:msr2
[    0.615279] PM: Adding info for No Bus:msr3
[    0.615366] PM: Adding info for No Bus:cpu0
[    0.615416] PM: Adding info for No Bus:cpu1
[    0.615469] PM: Adding info for No Bus:cpu2
[    0.615517] PM: Adding info for No Bus:cpu3
[    0.615636] PM: Adding info for platform:pcspkr
[    0.615682] PM: Adding info for platform:microcode
[    0.615723] microcode: CPU0 sig=3D0x206a7, pf=3D0x10, revision=3D0x14
[    0.615838] microcode: CPU1 sig=3D0x206a7, pf=3D0x10, revision=3D0x14
[    0.615944] microcode: CPU2 sig=3D0x206a7, pf=3D0x10, revision=3D0x14
[    0.616047] microcode: CPU3 sig=3D0x206a7, pf=3D0x10, revision=3D0x14
[    0.616159] PM: Adding info for No Bus:microcode
[    0.616196] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.616533] PM: Adding info for No Bus:snapshot
[    0.623907] PM: Adding info for event_source:cpu
[    0.623960] PM: Adding info for event_source:breakpoint
[    0.624008] PM: Adding info for event_source:software
[    0.630354] VFS: Disk quotas dquot_6.5.2
[    0.630525] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.630667] SGI XFS with ACLs, security attributes, large block/inode nu=
mbers, no debug enabled
[    0.631897] SGI XFS Quota Management subsystem
[    0.631997] msgmni has been set to 668
[    0.632457] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.632604] io scheduler noop registered
[    0.632697] io scheduler deadline registered
[    0.632922] io scheduler cfq registered (default)
[    0.633128] pcieport 0000:00:01.0: setting latency timer to 64
[    0.633153] pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
[    0.633170] PM: Adding info for pci_express:0000:00:01.0:pcie08
[    0.633562] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.633658] intel_idle: MWAIT substates: 0x21120
[    0.633659] intel_idle: v0.4 model 0x2A
[    0.633660] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.641050] PM: Adding info for No Bus:ptmx
[    0.641125] PM: Adding info for No Bus:hpet
[    0.641397] PM: Adding info for No Bus:nvram
[    0.641433] Non-volatile memory driver v1.3
[    0.641631] PM: Adding info for No Bus:7:0
[    0.641700] PM: Adding info for No Bus:loop0
[    0.641768] PM: Adding info for No Bus:7:1
[    0.641819] PM: Adding info for No Bus:loop1
[    0.641886] PM: Adding info for No Bus:7:2
[    0.641935] PM: Adding info for No Bus:loop2
[    0.641998] PM: Adding info for No Bus:7:3
[    0.642050] PM: Adding info for No Bus:loop3
[    0.642113] PM: Adding info for No Bus:7:4
[    0.642164] PM: Adding info for No Bus:loop4
[    0.642228] PM: Adding info for No Bus:7:5
[    0.642279] PM: Adding info for No Bus:loop5
[    0.642358] PM: Adding info for No Bus:7:6
[    0.642412] PM: Adding info for No Bus:loop6
[    0.642474] PM: Adding info for No Bus:7:7
[    0.642522] PM: Adding info for No Bus:loop7
[    0.642573] loop: module loaded
[    0.642837] ahci 0000:00:1f.2: version 3.0
[    0.642847] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.642977] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    0.643002] ahci: SSS flag set, parallel bus scan disabled
[    0.654710] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
13 impl SATA mode
[    0.654891] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio=
 slum part ems sxs apst=20
[    0.655044] ahci 0000:00:1f.2: setting latency timer to 64
[    0.659754] PM: Adding info for No Bus:ata1
[    0.659795] PM: Adding info for No Bus:ata1
[    0.659847] PM: Adding info for No Bus:link1
[    0.659863] PM: Adding info for No Bus:link1
[    0.659909] PM: Adding info for No Bus:dev1.0
[    0.659925] PM: Adding info for No Bus:dev1.0
[    0.659973] PM: Adding info for No Bus:ata2
[    0.659990] PM: Adding info for No Bus:ata2
[    0.660036] PM: Adding info for No Bus:link2
[    0.660052] PM: Adding info for No Bus:link2
[    0.660100] PM: Adding info for No Bus:dev2.0
[    0.660115] PM: Adding info for No Bus:dev2.0
[    0.660163] PM: Adding info for No Bus:ata3
[    0.660179] PM: Adding info for No Bus:ata3
[    0.660223] PM: Adding info for No Bus:link3
[    0.660237] PM: Adding info for No Bus:link3
[    0.660283] PM: Adding info for No Bus:dev3.0
[    0.660296] PM: Adding info for No Bus:dev3.0
[    0.660347] PM: Adding info for No Bus:ata4
[    0.660360] PM: Adding info for No Bus:ata4
[    0.660406] PM: Adding info for No Bus:link4
[    0.660420] PM: Adding info for No Bus:link4
[    0.660467] PM: Adding info for No Bus:dev4.0
[    0.660481] PM: Adding info for No Bus:dev4.0
[    0.660531] PM: Adding info for No Bus:ata5
[    0.660544] PM: Adding info for No Bus:ata5
[    0.660591] PM: Adding info for No Bus:link5
[    0.660604] PM: Adding info for No Bus:link5
[    0.660662] PM: Adding info for No Bus:dev5.0
[    0.660676] PM: Adding info for No Bus:dev5.0
[    0.660731] PM: Adding info for No Bus:ata6
[    0.660744] PM: Adding info for No Bus:ata6
[    0.660792] PM: Adding info for No Bus:link6
[    0.660813] PM: Adding info for No Bus:link6
[    0.660861] PM: Adding info for No Bus:dev6.0
[    0.660875] PM: Adding info for No Bus:dev6.0
[    0.660933] scsi0 : ahci
[    0.661172] PM: Adding info for scsi:host0
[    0.661231] PM: Adding info for No Bus:host0
[    0.661289] scsi1 : ahci
[    0.661392] PM: Adding info for scsi:host1
[    0.661447] PM: Adding info for No Bus:host1
[    0.661503] scsi2 : ahci
[    0.661607] PM: Adding info for scsi:host2
[    0.661671] PM: Adding info for No Bus:host2
[    0.661728] scsi3 : ahci
[    0.661831] PM: Adding info for scsi:host3
[    0.661886] PM: Adding info for No Bus:host3
[    0.661941] scsi4 : ahci
[    0.662046] PM: Adding info for scsi:host4
[    0.662104] PM: Adding info for No Bus:host4
[    0.662159] scsi5 : ahci
[    0.662262] PM: Adding info for scsi:host5
[    0.662316] PM: Adding info for No Bus:host5
[    0.662674] ata1: SATA max UDMA/133 abar m2048@0xf1c08000 port 0xf1c0810=
0 irq 43
[    0.662821] ata2: SATA max UDMA/133 abar m2048@0xf1c08000 port 0xf1c0818=
0 irq 43
[    0.662966] ata3: DUMMY
[    0.663056] ata4: DUMMY
[    0.663148] ata5: SATA max UDMA/133 abar m2048@0xf1c08000 port 0xf1c0830=
0 irq 43
[    0.663294] ata6: DUMMY
[    0.663400] scsi host0: rpm_resume flags 0x4
[    0.663401] scsi host0: rpm_resume returns 1
[    0.663564] usbmon: debugfs is not available
[    0.663670] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.663767] ohci_hcd: block sizes: ed 80 td 96
[    0.663858] usbcore: registered new interface driver libusual
[    0.664051] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0=
x60,0x64 irq 1,12
[    0.664222] PM: Adding info for platform:i8042
[    0.668820] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.668918] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.669033] PM: Adding info for serio:serio0
[    0.669097] PM: Adding info for serio:serio1
[    0.669160] PM: Adding info for No Bus:mice
[    0.669209] mousedev: PS/2 mouse device common for all mice
[    0.669363] rtc_cmos 00:05: RTC can wake from S4
[    0.672764] PM: Adding info for No Bus:rtc0
[    0.672806] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.672928] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.673785] cpuidle: using governor ladder
[    0.675414] cpuidle: using governor menu
[    0.675659] PM: Adding info for No Bus:input0
[    0.675715] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    0.676363] usbcore: registered new interface driver usbhid
[    0.676459] usbhid: USB HID core driver
[    0.676650] Netfilter messages via NETLINK v0.30.
[    0.676757] nf_conntrack version 0.5.0 (2675 buckets, 10700 max)
[    0.677022] ctnetlink v0.93: registering with nfnetlink.
[    0.677336] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.677478] TCP cubic registered
[    0.677571] Initializing XFRM netlink socket
[    0.678129] NET: Registered protocol family 10
[    0.678912] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.679055] IPv6 over IPv4 tunneling driver
[    0.679217] PM: Adding info for No Bus:sit0
[    0.679606] NET: Registered protocol family 17
[    0.679720] Registering the dns_resolver key type
[    0.679848] PM: Adding info for No Bus:cpu_dma_latency
[    0.679955] PM: Adding info for No Bus:network_latency
[    0.680007] PM: Adding info for No Bus:network_throughput
[    0.680046] PM: Hibernation image not present or could not be loaded.
[    0.680052] registered taskstats version 1
[    0.680497]   Magic number: 11:767:89
[    0.967169] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.969466] ata1.00: ACPI cmd ef/5a:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    0.971395] ata1.00: ATA-8: ST9500420AS, D005SDM1, max UDMA/133
[    0.971525] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    0.974466] ata1.00: ACPI cmd ef/5a:00:00:00:00:a0 (SET FEATURES) succee=
ded
[    0.984530] ata1.00: configured for UDMA/133
[    0.984662] scsi host0: rpm_suspend flags 0x0
[    0.984665] scsi host0: rpm_suspend returns 0
[    0.984677] scsi target0:0:0: rpm_resume flags 0x4
[    0.984679] scsi target0:0:0: rpm_resume returns -11
[    0.984681] scsi host0: rpm_resume flags 0x4
[    0.984683] ahci 0000:00:1f.2: rpm_resume flags 0x0
[    0.984684] ahci 0000:00:1f.2: rpm_resume returns 1
[    0.984686] scsi host0: rpm_resume returns 0
[    0.984807] scsi 0:0:0:0: Direct-Access     ATA      ST9500420AS      D0=
05 PQ: 0 ANSI: 5
[    0.984977] PM: Adding info for scsi:target0:0:0
[    0.985099] scsi target0:0:0: rpm_resume flags 0x4
[    0.985101] scsi target0:0:0: rpm_resume returns 1
[    0.985102] scsi 0:0:0:0: rpm_resume flags 0x0
[    0.985104] scsi 0:0:0:0: rpm_resume returns -11
[    0.985105] scsi 0:0:0:0: rpm_resume flags 0x4
[    0.985106] scsi 0:0:0:0: rpm_resume returns 1
[    0.985132] PM: Adding info for scsi:0:0:0:0
[    0.985219] PM: Adding info for No Bus:0:0:0:0
[    0.985279] PM: Adding info for No Bus:0:0:0:0
[    0.985363] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB=
/465 GiB)
[    0.985392] PM: Adding info for No Bus:0:0:0:0
[    0.985468] scsi host1: rpm_resume flags 0x4
[    0.985470] scsi host1: rpm_resume returns 1
[    0.985668] sd 0:0:0:0: [sda] Write Protect is off
[    0.985765] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.985812] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    0.985998] PM: Adding info for No Bus:8:0
[    0.986091] PM: Adding info for No Bus:sda
[    0.986110] sd 0:0:0:0: rpm_resume flags 0x4
[    0.986111] sd 0:0:0:0: rpm_resume returns 1
[    1.031786]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    1.031932] PM: Adding info for No Bus:sda1
[    1.031964] PM: Adding info for No Bus:sda2
[    1.031989] PM: Adding info for No Bus:sda3
[    1.032014] PM: Adding info for No Bus:sda4
[    1.032038] PM: Adding info for No Bus:sda5
[    1.032060] PM: Adding info for No Bus:sda6
[    1.032686] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.289567] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.291565] ata2.00: ATAPI: Optiarc DVD+/-RW AD-7717H, 102A, max UDMA/100
[    1.293908] ata2.00: configured for UDMA/100
[    1.294599] scsi host1: rpm_suspend flags 0x0
[    1.294608] scsi host1: rpm_suspend returns 0
[    1.294690] scsi target1:0:0: rpm_resume flags 0x4
[    1.294692] scsi target1:0:0: rpm_resume returns -11
[    1.294694] scsi host1: rpm_resume flags 0x4
[    1.294696] ahci 0000:00:1f.2: rpm_resume flags 0x0
[    1.294698] ahci 0000:00:1f.2: rpm_resume returns 1
[    1.294699] scsi host1: rpm_resume returns 0
[    1.296358] scsi 1:0:0:0: CD-ROM            Optiarc  DVD+-RW AD-7717H 10=
2A PQ: 0 ANSI: 5
[    1.296566] PM: Adding info for scsi:target1:0:0
[    1.296674] scsi target1:0:0: rpm_resume flags 0x4
[    1.296676] scsi target1:0:0: rpm_resume returns 1
[    1.296678] scsi 1:0:0:0: rpm_resume flags 0x0
[    1.296679] scsi 1:0:0:0: rpm_resume returns -11
[    1.296681] scsi 1:0:0:0: rpm_resume flags 0x4
[    1.296682] scsi 1:0:0:0: rpm_resume returns 1
[    1.296704] PM: Adding info for scsi:1:0:0:0
[    1.296805] PM: Adding info for No Bus:1:0:0:0
[    1.296917] PM: Adding info for No Bus:1:0:0:0
[    1.297036] scsi host2: rpm_resume flags 0x4
[    1.297052] scsi host2: rpm_resume returns 1
[    1.297059] scsi host2: rpm_suspend flags 0x0
[    1.297061] scsi host2: rpm_suspend returns 0
[    1.297094] scsi host3: rpm_resume flags 0x4
[    1.297095] scsi host3: rpm_resume returns 1
[    1.297099] scsi host3: rpm_suspend flags 0x0
[    1.297100] scsi host3: rpm_suspend returns 0
[    1.297112] scsi host4: rpm_resume flags 0x4
[    1.297114] scsi host4: rpm_resume returns 1
[    1.600974] ata5: SATA link down (SStatus 0 SControl 300)
[    1.601109] scsi host4: rpm_suspend flags 0x0
[    1.601112] scsi host4: rpm_suspend returns 0
[    1.601186] scsi host5: rpm_resume flags 0x4
[    1.601188] scsi host5: rpm_resume returns 1
[    1.601194] scsi host5: rpm_suspend flags 0x0
[    1.601196] scsi host5: rpm_suspend returns 0
[    1.601265] sd 0:0:0:0: rpm_resume flags 0x4
[    1.601268] sd 0:0:0:0: rpm_resume returns 1
[    1.613884] Refined TSC clocksource calibration: 2594.106 MHz.
[    1.614021] Switching to clocksource tsc
[    1.623863] XFS mounting filesystem sda6
[    1.901114] Ending clean XFS mount for filesystem: sda6
[    1.901224] VFS: Mounted root (xfs filesystem) readonly on device 8:6.
[    1.902191] Freeing unused kernel memory: 428k freed
[    1.902355] Write protecting the kernel read-only data: 6144k
[    1.904230] Freeing unused kernel memory: 580k freed
[    1.906912] Freeing unused kernel memory: 864k freed
[    4.214761] <30>udevd[4003]: starting version 168
[    4.609381] ACPI: Deprecated procfs I/F for AC is loaded, please retry w=
ith CONFIG_ACPI_PROCFS_POWER cleared
[    4.609417] PM: Adding info for No Bus:ADP0
[    4.690382] ACPI: acpi_idle yielding to intel_idle
[    4.690584] PM: Adding info for No Bus:cooling_device0
[    4.693119] PM: Adding info for No Bus:cooling_device1
[    4.693242] PM: Adding info for No Bus:cooling_device2
[    4.694699] PM: Adding info for No Bus:cooling_device3
[    4.709211] ACPI: AC Adapter [ADP0] (on-line)
[    4.718708] PM: Adding info for No Bus:BAT0
[    4.725733] ACPI: Deprecated procfs I/F for battery is loaded, please re=
try with CONFIG_ACPI_PROCFS_POWER cleared
[    4.725745] ACPI: Battery Slot [BAT0] (battery present)
[    4.725797] PM: Adding info for No Bus:input1
[    4.725818] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input1
[    4.725824] ACPI: Power Button [PWRB]
[    4.725882] PM: Adding info for No Bus:input2
[    4.725907] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input2
[    4.725911] ACPI: Sleep Button [SLPB]
[    4.725970] PM: Adding info for No Bus:input3
[    4.725996] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input3
[    4.736035] ACPI: Lid Switch [LID0]
[    4.736146] PM: Adding info for No Bus:input4
[    4.736169] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input4
[    4.736174] ACPI: Power Button [PWRF]
[    4.764668] PM: Adding info for No Bus:event0
[    4.764701] PM: Adding info for No Bus:event1
[    4.764728] PM: Adding info for No Bus:event2
[    4.764756] PM: Adding info for No Bus:event3
[    4.764781] PM: Adding info for No Bus:event4
[    4.796896] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) ->=
 IRQ 18
[    4.796901] ACPI: resource 0000:00:1f.3 [io  0xefa0-0xefbf] conflicts wi=
th ACPI region SMBI [io 0xefa0-0xefaf]
[    4.796903] ACPI: If an ACPI driver is available for this device, you sh=
ould use it instead of the native driver
[    4.900781] PM: Adding info for No Bus:8D9DDCBC-A997-11DA-B012-B622A1EF5=
492
[    4.900823] PM: Adding info for No Bus:A80593CE-A997-11DA-B012-B622A1EF5=
492
[    4.900859] PM: Adding info for No Bus:DD8C7670-1CB5-11DB-A98B-669A0C200=
008
[    4.900897] PM: Adding info for No Bus:9DBB5994-A997-11DA-B012-B622A1EF5=
492
[    4.900933] PM: Adding info for No Bus:A3776CE0-1E88-11DB-A98B-0800200C9=
A66
[    4.900971] PM: Adding info for No Bus:05901221-D566-11D1-B2F0-00A0C9062=
910
[    4.901019] wmi: Mapper loaded
[    5.060060] PM: Adding info for No Bus:thermal_zone0
[    5.060204] thermal LNXTHERM:00: registered as thermal_zone0
[    5.060205] ACPI: Thermal Zone [TZ00] (54 C)
[    5.060622] PM: Adding info for No Bus:thermal_zone1
[    5.060785] thermal LNXTHERM:01: registered as thermal_zone1
[    5.060786] ACPI: Thermal Zone [TZ01] (54 C)
[    5.108195] xhci_hcd 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> I=
RQ 19
[    5.108216] xhci_hcd 0000:04:00.0: setting latency timer to 64
[    5.108221] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    5.108242] drivers/usb/core/inode.c: creating file 'devices'
[    5.108246] drivers/usb/core/inode.c: creating file '001'
[    5.108248] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus =
number 1
[    5.115492] xhci_hcd 0000:04:00.0: supports USB remote wakeup
[    5.115510] xhci_hcd 0000:04:00.0: irq 19, io mem 0xf1a00000
[    5.115579] xhci_hcd 0000:04:00.0: irq 44 for MSI/MSI-X
[    5.115585] xhci_hcd 0000:04:00.0: irq 45 for MSI/MSI-X
[    5.115591] xhci_hcd 0000:04:00.0: irq 46 for MSI/MSI-X
[    5.115596] xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
[    5.115602] xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
[    5.118867] usb usb1: No SuperSpeed endpoint companion for config 1  int=
erface 0 altsetting 0 ep 129: using minimum values
[    5.118875] usb usb1: default language 0x0409
[    5.118889] usb usb1: udev 1, busnum 1, minor =3D 0
[    5.118896] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[    5.118898] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.118900] usb usb1: Product: xHCI Host Controller
[    5.118901] usb usb1: Manufacturer: Linux 2.6.38.6-dbg xhci_hcd
[    5.118903] usb usb1: SerialNumber: 0000:04:00.0
[    5.118946] PM: Adding info for usb:usb1
[    5.118967] usb usb1: usb_probe_device
[    5.118969] usb usb1: configuration #1 chosen from 1 choice
[    5.118972] xHCI xhci_add_endpoint called for root hub
[    5.118973] xHCI xhci_check_bandwidth called for root hub
[    5.118980] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    5.119027] PM: Adding info for usb:1-0:1.0
[    5.119048] hub 1-0:1.0: usb_probe_interface
[    5.119050] hub 1-0:1.0: usb_probe_interface - got id
[    5.119052] hub 1-0:1.0: USB hub found
[    5.119057] hub 1-0:1.0: 4 ports detected
[    5.119059] hub 1-0:1.0: standalone hub
[    5.119060] hub 1-0:1.0: individual port power switching
[    5.119061] hub 1-0:1.0: individual port over-current protection
[    5.119063] hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
[    5.119064] hub 1-0:1.0: power on to power good time: 20ms
[    5.119070] hub 1-0:1.0: local power source is good
[    5.119072] hub 1-0:1.0: enabling power on all ports
[    5.119107] hub 1-0:1.0: rpm_suspend flags 0x4
[    5.119108] hub 1-0:1.0: rpm_suspend returns 0
[    5.119125] PM: Adding info for No Bus:ep_81
[    5.119128] drivers/usb/core/inode.c: creating file '001'
[    5.119155] PM: Adding info for No Bus:ep_00
[    5.119157] usb usb1: rpm_suspend flags 0xc
[    5.119159] usb usb1: rpm_suspend returns -38
[    5.132327] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.132354] r8169 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ =
17
[    5.132400] r8169 0000:06:00.0: setting latency timer to 64
[    5.132407] r8169 0000:06:00.0: (unregistered net_device): unknown MAC, =
using family default
[    5.132480] r8169 0000:06:00.0: irq 49 for MSI/MSI-X
[    5.132551] PM: Adding info for No Bus:eth0
[    5.132902] r8169 0000:06:00.0: eth0: RTL8168b/8111b at 0xffffc9000003c0=
00, 14:fe:b5:ac:11:58, XID 0c200000 IRQ 49
[    5.153637] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.153640] Warning! ehci_hcd should always be loaded before uhci_hcd an=
d ohci_hcd, not after
[    5.153643] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    5.153671] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    5.153695] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.153700] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    5.153707] drivers/usb/core/inode.c: creating file '002'
[    5.153713] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 2
[    5.163208] ehci_hcd 0000:00:1a.0: reset hcs_params 0x200002 dbg=3D2 cc=
=3D0 pcc=3D0 ordered !ppc ports=3D2
[    5.163218] ehci_hcd 0000:00:1a.0: reset hcc_params 36881 caching frame =
1024 64 bit addr
[    5.163321] ehci_hcd 0000:00:1a.0: support lpm
[    5.163331] ehci_hcd 0000:00:1a.0: debug port 2
[    5.163336] ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=3D0 ithr=
esh=3D8 period=3D1024 Reset HALT
[    5.167204] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    5.167207] ehci_hcd 0000:00:1a.0: supports USB remote wakeup
[    5.167238] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf1c0a000
[    5.167244] ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=3D0 ithr=
esh=3D8 period=3D1024 Reset HALT
[    5.171129] ehci_hcd 0000:00:1a.0: init command 0010001 (park)=3D0 ithre=
sh=3D1 period=3D1024 RUN
[    5.176164] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    5.176202] usb usb2: default language 0x0409
[    5.176225] usb usb2: udev 1, busnum 2, minor =3D 128
[    5.176227] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    5.176229] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.176230] usb usb2: Product: EHCI Host Controller
[    5.176232] usb usb2: Manufacturer: Linux 2.6.38.6-dbg ehci_hcd
[    5.176233] usb usb2: SerialNumber: 0000:00:1a.0
[    5.176279] PM: Adding info for usb:usb2
[    5.176305] usb usb2: usb_probe_device
[    5.176307] usb usb2: configuration #1 chosen from 1 choice
[    5.176319] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    5.176333] PM: Adding info for usb:2-0:1.0
[    5.176347] hub 2-0:1.0: usb_probe_interface
[    5.176349] hub 2-0:1.0: usb_probe_interface - got id
[    5.176350] hub 2-0:1.0: USB hub found
[    5.176357] hub 2-0:1.0: 2 ports detected
[    5.176359] hub 2-0:1.0: standalone hub
[    5.176360] hub 2-0:1.0: no power switching (usb 1.0)
[    5.176361] hub 2-0:1.0: individual port over-current protection
[    5.176363] hub 2-0:1.0: power on to power good time: 20ms
[    5.176375] hub 2-0:1.0: local power source is good
[    5.176377] hub 2-0:1.0: trying to enable port power on non-switchable h=
ub
[    5.176393] hub 2-0:1.0: rpm_suspend flags 0x4
[    5.176395] hub 2-0:1.0: rpm_suspend returns 0
[    5.176415] PM: Adding info for No Bus:ep_81
[    5.176417] drivers/usb/core/inode.c: creating file '001'
[    5.176436] PM: Adding info for No Bus:ep_00
[    5.176437] usb usb2: rpm_suspend flags 0xc
[    5.176439] usb usb2: rpm_suspend returns -38
[    5.176514] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[    5.176532] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.176535] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    5.176540] drivers/usb/core/inode.c: creating file '003'
[    5.176543] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 3
[    5.182171] ehci_hcd 0000:00:1d.0: reset hcs_params 0x200002 dbg=3D2 cc=
=3D0 pcc=3D0 ordered !ppc ports=3D2
[    5.182180] ehci_hcd 0000:00:1d.0: reset hcc_params 36881 caching frame =
1024 64 bit addr
[    5.182287] ehci_hcd 0000:00:1d.0: support lpm
[    5.182297] ehci_hcd 0000:00:1d.0: debug port 2
[    5.182302] ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=3D0 ithr=
esh=3D8 period=3D1024 Reset HALT
[    5.185333] PM: Adding info for No Bus:input5
[    5.185358] input: Dell WMI hotkeys as /devices/virtual/input/input5
[    5.185399] PM: Adding info for No Bus:event5
[    5.186182] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    5.186184] ehci_hcd 0000:00:1d.0: supports USB remote wakeup
[    5.186206] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf1c09000
[    5.186210] ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=3D0 ithr=
esh=3D8 period=3D1024 Reset HALT
[    5.190075] ehci_hcd 0000:00:1d.0: init command 0010001 (park)=3D0 ithre=
sh=3D1 period=3D1024 RUN
[    5.195144] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    5.195241] usb usb3: default language 0x0409
[    5.195276] usb usb3: udev 1, busnum 3, minor =3D 256
[    5.195278] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    5.195280] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.195281] usb usb3: Product: EHCI Host Controller
[    5.195283] usb usb3: Manufacturer: Linux 2.6.38.6-dbg ehci_hcd
[    5.195284] usb usb3: SerialNumber: 0000:00:1d.0
[    5.195329] PM: Adding info for usb:usb3
[    5.195353] usb usb3: usb_probe_device
[    5.195356] usb usb3: configuration #1 chosen from 1 choice
[    5.195366] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    5.195380] PM: Adding info for usb:3-0:1.0
[    5.195395] hub 3-0:1.0: usb_probe_interface
[    5.195396] hub 3-0:1.0: usb_probe_interface - got id
[    5.195398] hub 3-0:1.0: USB hub found
[    5.195404] hub 3-0:1.0: 2 ports detected
[    5.195406] hub 3-0:1.0: standalone hub
[    5.195407] hub 3-0:1.0: no power switching (usb 1.0)
[    5.195408] hub 3-0:1.0: individual port over-current protection
[    5.195410] hub 3-0:1.0: power on to power good time: 20ms
[    5.195420] hub 3-0:1.0: local power source is good
[    5.195422] hub 3-0:1.0: trying to enable port power on non-switchable h=
ub
[    5.195436] hub 3-0:1.0: rpm_suspend flags 0x4
[    5.195438] hub 3-0:1.0: rpm_suspend returns 0
[    5.195457] PM: Adding info for No Bus:ep_81
[    5.195459] drivers/usb/core/inode.c: creating file '001'
[    5.195478] PM: Adding info for No Bus:ep_00
[    5.195480] usb usb3: rpm_suspend flags 0xc
[    5.195481] usb usb3: rpm_suspend returns -38
[    5.218168] hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0000
[    5.243106] PM: Adding info for No Bus:sg0
[    5.243127] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.243172] PM: Adding info for No Bus:sg1
[    5.243188] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    5.275996] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001803 0  ACK=
 POWER sig=3Dj CSC CONNECT
[    5.276004] hub 2-0:1.0: port 1: status 0501 change 0001
[    5.295004] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001803 0  ACK=
 POWER sig=3Dj CSC CONNECT
[    5.295026] hub 3-0:1.0: port 1: status 0501 change 0001
[    5.363633] sd 0:0:0:0: rpm_resume flags 0x4
[    5.363635] sd 0:0:0:0: rpm_resume returns 1
[    5.375839] hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    5.375886] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    5.426924] ehci_hcd 0000:00:1a.0: port 1 high speed
[    5.426931] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK=
 POWER sig=3Dse0 PE CONNECT
[    5.435133] sd 0:0:0:0: rpm_resume flags 0x4
[    5.435136] sd 0:0:0:0: rpm_resume returns 1
[    5.435214] sd 0:0:0:0: rpm_resume flags 0x4
[    5.435216] sd 0:0:0:0: rpm_resume returns 1
[    5.436900] sd 0:0:0:0: rpm_resume flags 0x4
[    5.436902] sd 0:0:0:0: rpm_resume returns 1
[    5.477619] usb 2-1: new high speed USB device using ehci_hcd and addres=
s 2
[    5.528733] ehci_hcd 0000:00:1a.0: port 1 high speed
[    5.528740] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK=
 POWER sig=3Dse0 PE CONNECT
[    5.530762] scsi host1: rpm_resume flags 0x4
[    5.530765] scsi host1: rpm_resume returns 1
[    5.532749] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    5.532759] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.532829] PM: Adding info for No Bus:11:0
[    5.532880] PM: Adding info for No Bus:sr0
[    5.532927] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.550147] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0x=
d04773/0xa40000/0x8a0400
[    5.591577] ehci_hcd 0000:00:1a.0: set dev address 2 for port 1
[    5.591582] ehci_hcd 0000:00:1a.0: LPM: no device attached
[    5.591894] usb 2-1: udev 2, busnum 2, minor =3D 129
[    5.591901] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    5.591907] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    5.592015] PM: Adding info for usb:2-1
[    5.592042] usb 2-1: usb_probe_device
[    5.592046] usb 2-1: configuration #1 chosen from 1 choice
[    5.592157] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    5.592172] PM: Adding info for usb:2-1:1.0
[    5.592190] hub 2-1:1.0: usb_probe_interface
[    5.592192] hub 2-1:1.0: usb_probe_interface - got id
[    5.592195] hub 2-1:1.0: USB hub found
[    5.592270] hub 2-1:1.0: 6 ports detected
[    5.592281] hub 2-1:1.0: standalone hub
[    5.592283] hub 2-1:1.0: individual port power switching
[    5.592284] hub 2-1:1.0: individual port over-current protection
[    5.592285] hub 2-1:1.0: Single TT
[    5.592287] hub 2-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    5.592288] hub 2-1:1.0: power on to power good time: 100ms
[    5.592514] hub 2-1:1.0: local power source is good
[    5.592520] hub 2-1:1.0: enabling power on all ports
[    5.593265] hub 2-1:1.0: rpm_suspend flags 0x4
[    5.593270] hub 2-1:1.0: rpm_suspend returns 0
[    5.593334] PM: Adding info for No Bus:ep_81
[    5.593341] drivers/usb/core/inode.c: creating file '002'
[    5.593384] PM: Adding info for No Bus:ep_00
[    5.593386] usb 2-1: rpm_suspend flags 0xc
[    5.593387] usb 2-1: rpm_suspend returns -38
[    5.593391] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    5.593403] hub 3-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    5.595421] PM: Adding info for No Bus:input6
[    5.595449] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input6
[    5.595490] PM: Adding info for No Bus:mouse0
[    5.595531] PM: Adding info for No Bus:event6
[    5.644514] ehci_hcd 0000:00:1d.0: port 1 high speed
[    5.644519] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK=
 POWER sig=3Dse0 PE CONNECT
[    5.692698] hub 2-1:1.0: port 4: status 0101 change 0001
[    5.695212] usb 3-1: new high speed USB device using ehci_hcd and addres=
s 2
[    5.716170] scsi host1: rpm_resume flags 0x4
[    5.716176] scsi host1: rpm_resume returns 1
[    5.717715] scsi host1: rpm_resume flags 0x4
[    5.717720] scsi host1: rpm_resume returns 1
[    5.719269] scsi host1: rpm_resume flags 0x4
[    5.719274] scsi host1: rpm_resume returns 1
[    5.732300] scsi host1: rpm_resume flags 0x4
[    5.732307] scsi host1: rpm_resume returns 1
[    5.746320] ehci_hcd 0000:00:1d.0: port 1 high speed
[    5.746325] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK=
 POWER sig=3Dse0 PE CONNECT
[    5.792046] usb 2-1: link qh256-0001/ffff880013734e10 start 1 [1/0 us]
[    5.809094] ehci_hcd 0000:00:1d.0: set dev address 2 for port 1
[    5.809100] ehci_hcd 0000:00:1d.0: LPM: no device attached
[    5.809341] usb 3-1: udev 2, busnum 3, minor =3D 257
[    5.809344] usb 3-1: New USB device found, idVendor=3D8087, idProduct=3D=
0024
[    5.809346] usb 3-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    5.809413] PM: Adding info for usb:3-1
[    5.809447] usb 3-1: usb_probe_device
[    5.809450] usb 3-1: configuration #1 chosen from 1 choice
[    5.809589] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[    5.809618] PM: Adding info for usb:3-1:1.0
[    5.809641] hub 3-1:1.0: usb_probe_interface
[    5.809643] hub 3-1:1.0: usb_probe_interface - got id
[    5.809646] hub 3-1:1.0: USB hub found
[    5.809709] hub 3-1:1.0: 8 ports detected
[    5.809712] hub 3-1:1.0: standalone hub
[    5.809714] hub 3-1:1.0: individual port power switching
[    5.809716] hub 3-1:1.0: individual port over-current protection
[    5.809718] hub 3-1:1.0: Single TT
[    5.809720] hub 3-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    5.809722] hub 3-1:1.0: power on to power good time: 100ms
[    5.809958] hub 3-1:1.0: local power source is good
[    5.809961] hub 3-1:1.0: enabling power on all ports
[    5.810957] hub 3-1:1.0: rpm_suspend flags 0x4
[    5.810960] hub 3-1:1.0: rpm_suspend returns 0
[    5.810991] PM: Adding info for No Bus:ep_81
[    5.810995] drivers/usb/core/inode.c: creating file '002'
[    5.811027] PM: Adding info for No Bus:ep_00
[    5.811029] usb 3-1: rpm_suspend flags 0xc
[    5.811032] usb 3-1: rpm_suspend returns -38
[    5.811036] hub 2-1:1.0: state 7 ports 6 chg 0010 evt 0000
[    5.811081] hub 2-1:1.0: port 4, status 0101, change 0000, 12 Mb/s
[    5.821048] PM: Adding info for No Bus:timer
[    5.822091] hub 2-1:1.0: port 4 not reset yet, waiting 10ms
[    5.883983] usb 2-1.4: new high speed USB device using ehci_hcd and addr=
ess 3
[    5.894947] hub 2-1:1.0: port 4 not reset yet, waiting 10ms
[    5.910533] hub 3-1:1.0: port 6: status 0101 change 0001
[    5.917952] scsi host1: rpm_resume flags 0x4
[    5.917959] scsi host1: rpm_resume returns 1
[    5.919498] scsi host1: rpm_resume flags 0x4
[    5.919503] scsi host1: rpm_resume returns 1
[    5.932497] scsi host1: rpm_resume flags 0x4
[    5.932505] scsi host1: rpm_resume returns 1
[    5.969787] usb 2-1.4: skipped 2 descriptors after configuration
[    5.969791] usb 2-1.4: skipped 7 descriptors after interface
[    5.969795] usb 2-1.4: skipped 1 descriptor after endpoint
[    5.969798] usb 2-1.4: skipped 28 descriptors after interface
[    5.969803] usb 2-1.4: skipped 2 descriptors after interface
[    5.970030] usb 2-1.4: default language 0x0409
[    5.970281] usb 2-1.4: udev 3, busnum 2, minor =3D 130
[    5.970284] usb 2-1.4: New USB device found, idVendor=3D0408, idProduct=
=3D2fb1
[    5.970287] usb 2-1.4: New USB device strings: Mfr=3D3, Product=3D2, Ser=
ialNumber=3D0
[    5.970290] usb 2-1.4: Product: Laptop_Integrated_Webcam_2HDM
[    5.970292] usb 2-1.4: Manufacturer: CN07CN2C7866414I0D37A00
[    5.970362] PM: Adding info for usb:2-1.4
[    5.970403] usb 2-1.4: usb_probe_device
[    5.970406] usb 2-1.4: configuration #1 chosen from 1 choice
[    5.970656] usb 2-1.4: adding 2-1.4:1.0 (config #1, interface 0)
[    5.970693] PM: Adding info for usb:2-1.4:1.0
[    5.970954] PM: Adding info for No Bus:ep_81
[    5.970958] usb 2-1.4: adding 2-1.4:1.1 (config #1, interface 1)
[    5.970987] PM: Adding info for usb:2-1.4:1.1
[    5.971010] usb 2-1.4: adding 2-1.4:1.2 (config #1, interface 2)
[    5.971046] PM: Adding info for usb:2-1.4:1.2
[    5.971069] drivers/usb/core/inode.c: creating file '003'
[    5.971102] PM: Adding info for No Bus:ep_00
[    5.971105] usb 2-1.4: rpm_suspend flags 0xc
[    5.971108] usb 2-1.4: rpm_suspend returns -38
[    5.971112] hub 2-1:1.0: state 7 ports 6 chg 0000 evt 0010
[    5.972674] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in=
=2Dtree:
[    5.972677] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[    5.972774] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[    5.972815] iwlagn 0000:03:00.0: setting latency timer to 64
[    5.972892] iwlagn 0000:03:00.0: Detected Intel(R) Centrino(R) Wireless-=
N 1030 BGN, REV=3D0xB0
[    5.989716] iwlagn 0000:03:00.0: device EEPROM VER=3D0x716, CALIB=3D0x6
[    5.989719] iwlagn 0000:03:00.0: Device SKU: 0X9
[    5.989721] iwlagn 0000:03:00.0: Valid Tx ant: 0X1, Valid Rx ant: 0X3
[    5.990144] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 0 802.11=
a channels
[    5.990397] iwlagn 0000:03:00.0: irq 50 for MSI/MSI-X
[    5.990969] PM: Adding info for No Bus:0000:03:00.0
[    6.010610] usb 3-1: link qh256-0001/ffff8800134b3cf0 start 1 [1/0 us]
[    6.010623] hub 3-1:1.0: state 7 ports 8 chg 0040 evt 0000
[    6.010713] hub 3-1:1.0: port 6, status 0101, change 0000, 12 Mb/s
[    6.021740] hub 3-1:1.0: port 6 not reset yet, waiting 10ms
[    6.046738] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> =
IRQ 22
[    6.046788] HDA Intel 0000:00:1b.0: irq 51 for MSI/MSI-X
[    6.046813] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    6.064540] sd 0:0:0:0: rpm_resume flags 0x4
[    6.064544] sd 0:0:0:0: rpm_resume returns 1
[    6.083602] usb 3-1.6: new high speed USB device using ehci_hcd and addr=
ess 3
[    6.093968] PM: Removing info for No Bus:0000:03:00.0
[    6.094028] iwlagn 0000:03:00.0: loaded firmware version 17.168.5.2 buil=
d 35905
[    6.094614] PM: Adding info for No Bus:phy0
[    6.094652] PM: Adding info for No Bus:rfkill0
[    6.095550] hub 3-1:1.0: port 6 not reset yet, waiting 10ms
[    6.096132] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    6.096204] PM: Adding info for No Bus:wlan0
[    6.134526] sd 0:0:0:0: rpm_resume flags 0x4
[    6.134529] sd 0:0:0:0: rpm_resume returns 1
[    6.139650] sd 0:0:0:0: rpm_resume flags 0x4
[    6.139653] sd 0:0:0:0: rpm_resume returns 1
[    6.139774] sd 0:0:0:0: rpm_resume flags 0x4
[    6.139777] sd 0:0:0:0: rpm_resume returns 1
[    6.139994] sd 0:0:0:0: rpm_resume flags 0x4
[    6.139997] sd 0:0:0:0: rpm_resume returns 1
[    6.140114] sd 0:0:0:0: rpm_resume flags 0x4
[    6.140117] sd 0:0:0:0: rpm_resume returns 1
[    6.140416] sd 0:0:0:0: rpm_resume flags 0x4
[    6.140418] sd 0:0:0:0: rpm_resume returns 1
[    6.170683] usb 3-1.6: skipped 3 descriptors after interface
[    6.170691] usb 3-1.6: skipped 4 descriptors after interface
[    6.170699] usb 3-1.6: skipped 4 descriptors after interface
[    6.170707] usb 3-1.6: skipped 2 descriptors after interface
[    6.170713] usb 3-1.6: skipped 5 descriptors after interface
[    6.170723] usb 3-1.6: skipped 2 descriptors after interface
[    6.170729] usb 3-1.6: skipped 4 descriptors after interface
[    6.171676] usb 3-1.6: skipped 3 descriptors after interface
[    6.171681] usb 3-1.6: skipped 4 descriptors after interface
[    6.171689] usb 3-1.6: skipped 4 descriptors after interface
[    6.171697] usb 3-1.6: skipped 2 descriptors after interface
[    6.171703] usb 3-1.6: skipped 5 descriptors after interface
[    6.171717] usb 3-1.6: skipped 2 descriptors after interface
[    6.171940] usb 3-1.6: default language 0x0409
[    6.172668] usb 3-1.6: udev 3, busnum 3, minor =3D 258
[    6.172674] usb 3-1.6: New USB device found, idVendor=3D413c, idProduct=
=3D8184
[    6.172680] usb 3-1.6: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    6.172686] usb 3-1.6: Product: Dell Wireless 5540
[    6.172690] usb 3-1.6: Manufacturer: <ADell Wireless 5540
[    6.172694] usb 3-1.6: SerialNumber: 3563970328033220
[    6.172794] PM: Adding info for usb:3-1.6
[    6.172822] usb 3-1.6: usb_probe_device
[    6.172825] usb 3-1.6: configuration #1 chosen from 2 choices
[    6.176037] usb 3-1.6: adding 3-1.6:1.0 (config #1, interface 0)
[    6.176088] PM: Adding info for usb:3-1.6:1.0
[    6.176355] usb 3-1.6: adding 3-1.6:1.1 (config #1, interface 1)
[    6.176409] PM: Adding info for usb:3-1.6:1.1
[    6.176900] PM: Adding info for No Bus:ep_8a
[    6.176903] usb 3-1.6: adding 3-1.6:1.2 (config #1, interface 2)
[    6.176919] PM: Adding info for usb:3-1.6:1.2
[    6.177272] PM: Adding info for No Bus:ep_01
[    6.177305] PM: Adding info for No Bus:ep_81
[    6.177308] usb 3-1.6: adding 3-1.6:1.3 (config #1, interface 3)
[    6.177331] PM: Adding info for usb:3-1.6:1.3
[    6.177685] PM: Adding info for No Bus:ep_89
[    6.177687] usb 3-1.6: adding 3-1.6:1.4 (config #1, interface 4)
[    6.177703] PM: Adding info for usb:3-1.6:1.4
[    6.178148] PM: Adding info for No Bus:ep_02
[    6.178165] PM: Adding info for No Bus:ep_82
[    6.178167] usb 3-1.6: adding 3-1.6:1.5 (config #1, interface 5)
[    6.178180] PM: Adding info for usb:3-1.6:1.5
[    6.178650] PM: Adding info for No Bus:ep_88
[    6.178652] usb 3-1.6: adding 3-1.6:1.6 (config #1, interface 6)
[    6.178665] PM: Adding info for usb:3-1.6:1.6
[    6.179021] PM: Adding info for No Bus:ep_86
[    6.179023] usb 3-1.6: adding 3-1.6:1.7 (config #1, interface 7)
[    6.179037] PM: Adding info for usb:3-1.6:1.7
[    6.179445] usb 3-1.6: adding 3-1.6:1.8 (config #1, interface 8)
[    6.179469] PM: Adding info for usb:3-1.6:1.8
[    6.179894] PM: Adding info for No Bus:ep_87
[    6.179896] usb 3-1.6: adding 3-1.6:1.9 (config #1, interface 9)
[    6.179910] PM: Adding info for usb:3-1.6:1.9
[    6.180266] PM: Adding info for No Bus:ep_84
[    6.180273] usb 3-1.6: adding 3-1.6:1.10 (config #1, interface 10)
[    6.180288] PM: Adding info for usb:3-1.6:1.10
[    6.180906] PM: Adding info for No Bus:ep_03
[    6.180921] PM: Adding info for No Bus:ep_83
[    6.180923] drivers/usb/core/inode.c: creating file '003'
[    6.180956] PM: Adding info for No Bus:ep_00
[    6.180959] usb 3-1.6: rpm_suspend flags 0xc
[    6.180962] usb 3-1.6: rpm_suspend returns -38
[    6.214396] sd 0:0:0:0: rpm_resume flags 0x4
[    6.214399] sd 0:0:0:0: rpm_resume returns 1
[    6.215982] sd 0:0:0:0: rpm_resume flags 0x4
[    6.215985] sd 0:0:0:0: rpm_resume returns 1
[    6.300504] cdc_acm 3-1.6:1.1: usb_probe_interface
[    6.300508] cdc_acm 3-1.6:1.1: usb_probe_interface - got id
[    6.300819] cdc_acm 3-1.6:1.1: ttyACM0: USB ACM device
[    6.309163] PM: Adding info for No Bus:ttyACM0
[    6.309184] cdc_acm 3-1.6:1.1: rpm_suspend flags 0x4
[    6.309189] cdc_acm 3-1.6:1.1: rpm_suspend returns 0
[    6.309204] cdc_acm 3-1.6:1.3: usb_probe_interface
[    6.309208] cdc_acm 3-1.6:1.3: usb_probe_interface - got id
[    6.309427] cdc_acm 3-1.6:1.3: ttyACM1: USB ACM device
[    6.324831] PM: Adding info for No Bus:ttyACM1
[    6.324868] cdc_acm 3-1.6:1.3: rpm_suspend flags 0x4
[    6.324872] cdc_acm 3-1.6:1.3: rpm_suspend returns 0
[    6.324888] cdc_acm 3-1.6:1.9: usb_probe_interface
[    6.324891] cdc_acm 3-1.6:1.9: usb_probe_interface - got id
[    6.325164] cdc_acm 3-1.6:1.9: ttyACM2: USB ACM device
[    6.340981] PM: Adding info for No Bus:ttyACM2
[    6.340998] cdc_acm 3-1.6:1.9: rpm_suspend flags 0x4
[    6.341002] cdc_acm 3-1.6:1.9: rpm_suspend returns 0
[    6.341026] cdc_wdm 3-1.6:1.5: usb_probe_interface
[    6.341029] cdc_wdm 3-1.6:1.5: usb_probe_interface - got id
[    6.341035] usbcore: registered new interface driver cdc_acm
[    6.341037] cdc_acm: v0.26:USB Abstract Control Model driver for USB mod=
ems and ISDN adapters
[    6.341055] cdc_wdm 3-1.6:1.5: looking for a minor, starting at 176
[    6.341078] PM: Adding info for No Bus:cdc-wdm0
[    6.341089] cdc_wdm 3-1.6:1.5: cdc-wdm0: USB WDM device
[    6.341091] cdc_wdm 3-1.6:1.5: rpm_suspend flags 0x4
[    6.341094] cdc_wdm 3-1.6:1.5: rpm_suspend returns 0
[    6.341104] cdc_wdm 3-1.6:1.8: usb_probe_interface
[    6.341106] cdc_wdm 3-1.6:1.8: usb_probe_interface - got id
[    6.341112] cdc_wdm 3-1.6:1.8: looking for a minor, starting at 176
[    6.341151] PM: Adding info for No Bus:cdc-wdm1
[    6.341165] cdc_wdm 3-1.6:1.8: cdc-wdm1: USB WDM device
[    6.341168] cdc_wdm 3-1.6:1.8: rpm_suspend flags 0x4
[    6.341171] cdc_wdm 3-1.6:1.8: rpm_suspend returns 0
[    6.341199] usbcore: registered new interface driver cdc_wdm
[    6.428026] cdc_ether 3-1.6:1.6: usb_probe_interface
[    6.428029] cdc_ether 3-1.6:1.6: usb_probe_interface - got id
[    6.429752] PM: Adding info for No Bus:ep_05
[    6.429803] PM: Adding info for No Bus:ep_85
[    6.430690] PM: Adding info for No Bus:wwan0
[    6.431060] cdc_ether 3-1.6:1.6: wwan0: register 'cdc_ether' at usb-0000=
:00:1d.0-1.6, Mobile Broadband Network Device, 02:80:37:ec:02:00
[    6.431064] cdc_ether 3-1.6:1.6: rpm_suspend flags 0x4
[    6.431067] cdc_ether 3-1.6:1.6: rpm_suspend returns 0
[    6.431096] usbcore: registered new interface driver cdc_ether
[    6.491666] sd 0:0:0:0: rpm_resume flags 0x4
[    6.491669] sd 0:0:0:0: rpm_resume returns 1
[    6.493432] sd 0:0:0:0: rpm_resume flags 0x4
[    6.493434] sd 0:0:0:0: rpm_resume returns 1
[    6.737212] sd 0:0:0:0: rpm_resume flags 0x4
[    6.737215] sd 0:0:0:0: rpm_resume returns 1
[    6.738994] sd 0:0:0:0: rpm_resume flags 0x4
[    6.738997] sd 0:0:0:0: rpm_resume returns 1
[    6.762444] hda_codec: ALC665: SKU not ready 0x598301f0
[    6.762614] hda_codec: ALC665: BIOS auto-probing.
[    6.909693] sd 0:0:0:0: rpm_resume flags 0x4
[    6.909696] sd 0:0:0:0: rpm_resume returns 1
[    6.911419] sd 0:0:0:0: rpm_resume flags 0x4
[    6.911422] sd 0:0:0:0: rpm_resume returns 1
[    6.957363] sd 0:0:0:0: rpm_resume flags 0x4
[    6.957366] sd 0:0:0:0: rpm_resume returns 1
[    6.959233] sd 0:0:0:0: rpm_resume flags 0x4
[    6.959236] sd 0:0:0:0: rpm_resume returns 1
[    6.991330] PM: Adding info for No Bus:card0
[    6.991373] PM: Adding info for No Bus:pcmC0D3p
[    6.991416] PM: Adding info for No Bus:pcmC0D1p
[    6.991452] PM: Adding info for No Bus:pcmC0D0p
[    6.991490] PM: Adding info for No Bus:pcmC0D0c
[    6.991539] PM: Adding info for No Bus:input7
[    6.991559] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0=
/sound/card0/input7
[    6.991593] PM: Adding info for No Bus:event7
[    6.991636] PM: Adding info for No Bus:input8
[    6.991654] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:0=
0:1b.0/sound/card0/input8
[    6.991682] PM: Adding info for No Bus:event8
[    6.991720] PM: Adding info for No Bus:controlC0
[    7.011499] sd 0:0:0:0: rpm_resume flags 0x4
[    7.011502] sd 0:0:0:0: rpm_resume returns 1
[    7.013379] sd 0:0:0:0: rpm_resume flags 0x4
[    7.013381] sd 0:0:0:0: rpm_resume returns 1
[    7.679830] PM: Adding info for platform:coretemp.0
[    7.679851] coretemp coretemp.0: TjMax is 100 C.
[    7.679891] PM: Adding info for No Bus:hwmon0
[    7.679929] PM: Adding info for platform:coretemp.2
[    7.679951] coretemp coretemp.2: TjMax is 100 C.
[    7.679982] PM: Adding info for No Bus:hwmon1
[    7.851388] sd 0:0:0:0: rpm_resume flags 0x4
[    7.851391] sd 0:0:0:0: rpm_resume returns 1
[    7.851408] sd 0:0:0:0: rpm_resume flags 0x4
[    7.851410] sd 0:0:0:0: rpm_resume returns 1
[    7.970483] sd 0:0:0:0: rpm_resume flags 0x4
[    7.970487] sd 0:0:0:0: rpm_resume returns 1
[    8.021861] sd 0:0:0:0: rpm_resume flags 0x4
[    8.021865] sd 0:0:0:0: rpm_resume returns 1
[    8.024712] sd 0:0:0:0: rpm_resume flags 0x4
[    8.024715] sd 0:0:0:0: rpm_resume returns 1
[    8.630396] PM: Adding info for No Bus:vcs2
[    8.630433] PM: Adding info for No Bus:vcsa2
[    8.630591] PM: Adding info for No Bus:vcs3
[    8.630629] PM: Adding info for No Bus:vcsa3
[    8.630789] PM: Adding info for No Bus:vcs4
[    8.630824] PM: Adding info for No Bus:vcsa4
[    8.631171] PM: Adding info for No Bus:vcs5
[    8.631206] PM: Adding info for No Bus:vcsa5
[    8.631364] PM: Adding info for No Bus:vcs6
[    8.631402] PM: Adding info for No Bus:vcsa6
[    8.631953] PM: Adding info for No Bus:vcs7
[    8.632000] PM: Adding info for No Bus:vcsa7
[    8.632251] PM: Adding info for No Bus:vcs8
[    8.632277] PM: Adding info for No Bus:vcsa8
[    8.632492] PM: Adding info for No Bus:vcs9
[    8.632528] PM: Adding info for No Bus:vcsa9
[    8.632932] PM: Adding info for No Bus:vcs10
[    8.632973] PM: Adding info for No Bus:vcsa10
[    8.633344] PM: Adding info for No Bus:vcs11
[    8.633372] PM: Adding info for No Bus:vcsa11
[    8.633736] PM: Adding info for No Bus:vcs12
[    8.633763] PM: Adding info for No Bus:vcsa12
[    9.004118] r8169 0000:06:00.0: rpm_resume flags 0x4
[    9.004121] r8169 0000:06:00.0: rpm_resume returns 1
[    9.008093] r8169 0000:06:00.0: eth0: link down
[    9.008100] r8169 0000:06:00.0: eth0: link down
[    9.008146] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    9.345301] PM: Adding info for No Bus:mixer
[    9.519198] PM: Adding info for No Bus:dsp
[    9.519242] PM: Adding info for No Bus:audio
[    9.519296] PM: Adding info for No Bus:adsp
[    9.593611] PM: Adding info for No Bus:seq
[    9.750462] PM: Adding info for No Bus:sequencer
[    9.750532] PM: Adding info for No Bus:sequencer2
[   10.701149] r8169 0000:06:00.0: rpm_resume flags 0x1
[   10.701158] r8169 0000:06:00.0: rpm_resume returns 1
[   10.701171] r8169 0000:06:00.0: eth0: link up
[   10.701224] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   23.232466] sd 0:0:0:0: rpm_resume flags 0x4
[   23.232469] sd 0:0:0:0: rpm_resume returns 1
[   27.841553] SysRq : Emergency Remount R/O
[   28.441581] Emergency Remount complete
[   28.856709] SysRq : Emergency Sync
[   28.856898] Emergency Sync complete
[   29.066947] SysRq : Emergency Remount R/O
[   29.067137] Emergency Remount complete
[   29.359093] SysRq : Emergency Sync
[   29.359280] Emergency Sync complete
[   32.983980] iwlagn 0000:03:00.0: rpm_resume flags 0x4
[   32.983993] iwlagn 0000:03:00.0: rpm_resume returns 1
[   33.008075] PM: Removing info for No Bus:wlan0
[   33.012983] PM: Removing info for No Bus:rfkill0
[   33.019874] PM: Removing info for No Bus:phy0
[   33.020303] iwlagn 0000:03:00.0: PCI INT A disabled
[   33.029817] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[   33.029825] BUG iommu_iova: Wrong object count. Counter is 1 but counted=
 were 2
[   33.029830] ------------------------------------------------------------=
=2D----------------
[   33.029833]=20
[   33.029840] INFO: Slab 0xffffea0000465b00 objects=3D64 used=3D1 fp=3D0xf=
fff8800141a04c0 flags=3D0x40000000000000c1
[   33.029849] Pid: 0, comm: swapper Not tainted 2.6.38.6-dbg #1
[   33.029853] Call Trace:
[   33.029857]  <IRQ>  [<ffffffff810a4c7d>] ? slab_err+0x8a/0x98
[   33.029877]  [<ffffffff810a4f68>] ? on_freelist+0x169/0x19d
[   33.029886]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.029894]  [<ffffffff810a584b>] ? free_debug_processing+0x5c/0x1a3
[   33.029909]  [<ffffffff810a65a6>] ? __slab_free+0xe4/0xf9
[   33.029911]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.029914]  [<ffffffff810a6c2b>] ? kmem_cache_free+0x5a/0x66
[   33.029916]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.029918]  [<ffffffff8119cc5b>] ? __free_iova+0x5a/0x62
[   33.029920]  [<ffffffff811a01ae>] ? flush_unmaps+0xee/0x12f
[   33.029924]  [<ffffffff8104db99>] ? sched_clock_cpu+0x46/0xd1
[   33.029926]  [<ffffffff811a01ef>] ? flush_unmaps_timeout+0x0/0x30
[   33.029928]  [<ffffffff811a020c>] ? flush_unmaps_timeout+0x1d/0x30
[   33.029932]  [<ffffffff8103cc46>] ? run_timer_softirq+0x18f/0x21f
[   33.029935]  [<ffffffff81017681>] ? lapic_next_event+0x18/0x1c
[   33.029938]  [<ffffffff81037c9a>] ? __do_softirq+0x83/0x12a
[   33.029940]  [<ffffffff81054924>] ? tick_program_event+0x1a/0x1c
[   33.029943]  [<ffffffff8100378c>] ? call_softirq+0x1c/0x28
[   33.029946]  [<ffffffff81004c03>] ? do_softirq+0x33/0x68
[   33.029948]  [<ffffffff81037b3e>] ? irq_exit+0x36/0x78
[   33.029950]  [<ffffffff810181ba>] ? smp_apic_timer_interrupt+0x88/0x96
[   33.029953]  [<ffffffff81003253>] ? apic_timer_interrupt+0x13/0x20
[   33.029954]  <EOI>  [<ffffffff811a44e1>] ? intel_idle+0xc3/0xe9
[   33.029959]  [<ffffffff811a44c4>] ? intel_idle+0xa6/0xe9
[   33.029963]  [<ffffffff81248ff3>] ? cpuidle_idle_call+0x94/0xcd
[   33.029965]  [<ffffffff81001c93>] ? cpu_idle+0x5a/0x91
[   33.029968]  [<ffffffff81353824>] ? rest_init+0x68/0x6a
[   33.029971]  [<ffffffff8165fcc2>] ? start_kernel+0x35e/0x369
[   33.029974]  [<ffffffff8165f2a8>] ? x86_64_start_reservations+0xb8/0xbc
[   33.029976]  [<ffffffff8165f39e>] ? x86_64_start_kernel+0xf2/0xf9
[   33.029978] FIX iommu_iova: Object count adjusted.
[   33.029979] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[   33.029981] BUG iommu_iova: Redzone overwritten
[   33.029982] ------------------------------------------------------------=
=2D----------------
[   33.029983]=20
[   33.029984] INFO: 0xffff8800141a00e8-0xffff8800141a00ef. First byte 0xbb=
 instead of 0xcc
[   33.029987] INFO: Slab 0xffffea0000465b00 objects=3D64 used=3D2 fp=3D0xf=
fff8800141a04c0 flags=3D0x40000000000000c1
[   33.029989] INFO: Object 0xffff8800141a00c0 @offset=3D192 fp=3D0xffff880=
0141a0040
[   33.029990]=20
[   33.029991] Bytes b4 0xffff8800141a00b0:  01 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 ................
[   33.029998]   Object 0xffff8800141a00c0:  40 00 1a 14 00 88 ff ff c0 04 =
1a 14 00 88 ff ff @.....=FF=FF=C0.....=FF=FF
[   33.030004]   Object 0xffff8800141a00d0:  00 00 00 00 00 00 00 00 bf ff =
0f 00 00 00 00 00 ........=BF=FF......
[   33.030011]   Object 0xffff8800141a00e0:  80 ff 0f 00 00 00 00 00       =
                  .=FF......       =20
[   33.030017]  Redzone 0xffff8800141a00e8:  bb bb bb bb bb bb bb bb       =
                  =BB=BB=BB=BB=BB=BB=BB=BB       =20
[   33.030023]  Padding 0xffff8800141a00f0:  ff ff ff ff ff ff ff ff ff fe =
ff ff ff ff ff ff =FF=FF=FF=FF=FF=FF=FF=FF=FF=FE=FF=FF=FF=FF=FF=FF
[   33.030030] Pid: 0, comm: swapper Not tainted 2.6.38.6-dbg #1
[   33.030031] Call Trace:
[   33.030032]  <IRQ>  [<ffffffff810a4db9>] ? print_trailer+0x12e/0x137
[   33.030036]  [<ffffffff810a5272>] ? check_bytes_and_report+0xb9/0xfd
[   33.030038]  [<ffffffff8119d1cc>] ? domain_get_iommu+0x18/0x46
[   33.030041]  [<ffffffff810a52ff>] ? check_object+0x49/0x194
[   33.030043]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030045]  [<ffffffff810a5869>] ? free_debug_processing+0x7a/0x1a3
[   33.030048]  [<ffffffff810a65a6>] ? __slab_free+0xe4/0xf9
[   33.030050]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030052]  [<ffffffff810a6c2b>] ? kmem_cache_free+0x5a/0x66
[   33.030054]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030056]  [<ffffffff8119cc5b>] ? __free_iova+0x5a/0x62
[   33.030058]  [<ffffffff811a01ae>] ? flush_unmaps+0xee/0x12f
[   33.030061]  [<ffffffff8104db99>] ? sched_clock_cpu+0x46/0xd1
[   33.030063]  [<ffffffff811a01ef>] ? flush_unmaps_timeout+0x0/0x30
[   33.030065]  [<ffffffff811a020c>] ? flush_unmaps_timeout+0x1d/0x30
[   33.030068]  [<ffffffff8103cc46>] ? run_timer_softirq+0x18f/0x21f
[   33.030070]  [<ffffffff81017681>] ? lapic_next_event+0x18/0x1c
[   33.030073]  [<ffffffff81037c9a>] ? __do_softirq+0x83/0x12a
[   33.030075]  [<ffffffff81054924>] ? tick_program_event+0x1a/0x1c
[   33.030077]  [<ffffffff8100378c>] ? call_softirq+0x1c/0x28
[   33.030079]  [<ffffffff81004c03>] ? do_softirq+0x33/0x68
[   33.030081]  [<ffffffff81037b3e>] ? irq_exit+0x36/0x78
[   33.030084]  [<ffffffff810181ba>] ? smp_apic_timer_interrupt+0x88/0x96
[   33.030086]  [<ffffffff81003253>] ? apic_timer_interrupt+0x13/0x20
[   33.030087]  <EOI>  [<ffffffff811a44e1>] ? intel_idle+0xc3/0xe9
[   33.030092]  [<ffffffff811a44c4>] ? intel_idle+0xa6/0xe9
[   33.030094]  [<ffffffff81248ff3>] ? cpuidle_idle_call+0x94/0xcd
[   33.030096]  [<ffffffff81001c93>] ? cpu_idle+0x5a/0x91
[   33.030098]  [<ffffffff81353824>] ? rest_init+0x68/0x6a
[   33.030100]  [<ffffffff8165fcc2>] ? start_kernel+0x35e/0x369
[   33.030102]  [<ffffffff8165f2a8>] ? x86_64_start_reservations+0xb8/0xbc
[   33.030104]  [<ffffffff8165f39e>] ? x86_64_start_kernel+0xf2/0xf9
[   33.030106] FIX iommu_iova: Restoring 0xffff8800141a00e8-0xffff8800141a0=
0ef=3D0xcc
[   33.030107]=20
[   33.030111] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[   33.030112] BUG iommu_iova: Wrong object count. Counter is 2 but counted=
 were 3
[   33.030114] ------------------------------------------------------------=
=2D----------------
[   33.030114]=20
[   33.030116] INFO: Slab 0xffffea0000465b00 objects=3D64 used=3D2 fp=3D0xf=
fff8800141a04c0 flags=3D0x40000000000000c1
[   33.030118] Pid: 0, comm: swapper Not tainted 2.6.38.6-dbg #1
[   33.030119] Call Trace:
[   33.030120]  <IRQ>  [<ffffffff810a4c7d>] ? slab_err+0x8a/0x98
[   33.030124]  [<ffffffff8136101f>] ? dump_stack+0x6a/0x71
[   33.030127]  [<ffffffff810a4f68>] ? on_freelist+0x169/0x19d
[   33.030129]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030131]  [<ffffffff810a584b>] ? free_debug_processing+0x5c/0x1a3
[   33.030134]  [<ffffffff810a65a6>] ? __slab_free+0xe4/0xf9
[   33.030135]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030138]  [<ffffffff810a6c2b>] ? kmem_cache_free+0x5a/0x66
[   33.030140]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030142]  [<ffffffff8119cc5b>] ? __free_iova+0x5a/0x62
[   33.030144]  [<ffffffff811a01ae>] ? flush_unmaps+0xee/0x12f
[   33.030147]  [<ffffffff8104db99>] ? sched_clock_cpu+0x46/0xd1
[   33.030149]  [<ffffffff811a01ef>] ? flush_unmaps_timeout+0x0/0x30
[   33.030151]  [<ffffffff811a020c>] ? flush_unmaps_timeout+0x1d/0x30
[   33.030154]  [<ffffffff8103cc46>] ? run_timer_softirq+0x18f/0x21f
[   33.030156]  [<ffffffff81017681>] ? lapic_next_event+0x18/0x1c
[   33.030158]  [<ffffffff81037c9a>] ? __do_softirq+0x83/0x12a
[   33.030161]  [<ffffffff81054924>] ? tick_program_event+0x1a/0x1c
[   33.030163]  [<ffffffff8100378c>] ? call_softirq+0x1c/0x28
[   33.030165]  [<ffffffff81004c03>] ? do_softirq+0x33/0x68
[   33.030167]  [<ffffffff81037b3e>] ? irq_exit+0x36/0x78
[   33.030169]  [<ffffffff810181ba>] ? smp_apic_timer_interrupt+0x88/0x96
[   33.030171]  [<ffffffff81003253>] ? apic_timer_interrupt+0x13/0x20
[   33.030172]  <EOI>  [<ffffffff811a44e1>] ? intel_idle+0xc3/0xe9
[   33.030177]  [<ffffffff811a44c4>] ? intel_idle+0xa6/0xe9
[   33.030179]  [<ffffffff81248ff3>] ? cpuidle_idle_call+0x94/0xcd
[   33.030181]  [<ffffffff81001c93>] ? cpu_idle+0x5a/0x91
[   33.030183]  [<ffffffff81353824>] ? rest_init+0x68/0x6a
[   33.030185]  [<ffffffff8165fcc2>] ? start_kernel+0x35e/0x369
[   33.030187]  [<ffffffff8165f2a8>] ? x86_64_start_reservations+0xb8/0xbc
[   33.030190]  [<ffffffff8165f39e>] ? x86_64_start_kernel+0xf2/0xf9
[   33.030191] FIX iommu_iova: Object count adjusted.
[   33.030192] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[   33.030194] BUG iommu_iova: Redzone overwritten
[   33.030195] ------------------------------------------------------------=
=2D----------------
[   33.030196]=20
[   33.030197] INFO: 0xffff8800141a0068-0xffff8800141a006f. First byte 0xbb=
 instead of 0xcc
[   33.030199] INFO: Slab 0xffffea0000465b00 objects=3D64 used=3D3 fp=3D0xf=
fff8800141a04c0 flags=3D0x40000000000000c1
[   33.030201] INFO: Object 0xffff8800141a0040 @offset=3D64 fp=3D0xffff8800=
141a0000
[   33.030202]=20
[   33.030203] Bytes b4 0xffff8800141a0030:  ff ff ff ff ff ff ff ff ff fe =
ff ff ff ff ff ff =FF=FF=FF=FF=FF=FF=FF=FF=FF=FE=FF=FF=FF=FF=FF=FF
[   33.030209]   Object 0xffff8800141a0040:  00 00 1a 14 00 88 ff ff c0 04 =
1a 14 00 88 ff ff ......=FF=FF=C0.....=FF=FF
[   33.030216]   Object 0xffff8800141a0050:  00 00 00 00 00 00 00 00 7f ff =
0f 00 00 00 00 00 .........=FF......
[   33.030222]   Object 0xffff8800141a0060:  60 ff 0f 00 00 00 00 00       =
                  `=FF......       =20
[   33.030228]  Redzone 0xffff8800141a0068:  bb bb bb bb bb bb bb bb       =
                  =BB=BB=BB=BB=BB=BB=BB=BB       =20
[   33.030234]  Padding 0xffff8800141a0070:  e0 4f 61 81 ff ff ff ff 90 5d =
b2 14 00 88 ff ff =E0Oa.=FF=FF=FF=FF.]=B2...=FF=FF
[   33.030241] Pid: 0, comm: swapper Not tainted 2.6.38.6-dbg #1
[   33.030242] Call Trace:
[   33.030242]  <IRQ>  [<ffffffff810a4db9>] ? print_trailer+0x12e/0x137
[   33.030247]  [<ffffffff810a5272>] ? check_bytes_and_report+0xb9/0xfd
[   33.030249]  [<ffffffff8119d1cc>] ? domain_get_iommu+0x18/0x46
[   33.030251]  [<ffffffff810a52ff>] ? check_object+0x49/0x194
[   33.030253]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030255]  [<ffffffff810a5869>] ? free_debug_processing+0x7a/0x1a3
[   33.030258]  [<ffffffff810a65a6>] ? __slab_free+0xe4/0xf9
[   33.030260]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030262]  [<ffffffff810a6c2b>] ? kmem_cache_free+0x5a/0x66
[   33.030264]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030266]  [<ffffffff8119cc5b>] ? __free_iova+0x5a/0x62
[   33.030268]  [<ffffffff811a01ae>] ? flush_unmaps+0xee/0x12f
[   33.030271]  [<ffffffff8104db99>] ? sched_clock_cpu+0x46/0xd1
[   33.030273]  [<ffffffff811a01ef>] ? flush_unmaps_timeout+0x0/0x30
[   33.030275]  [<ffffffff811a020c>] ? flush_unmaps_timeout+0x1d/0x30
[   33.030278]  [<ffffffff8103cc46>] ? run_timer_softirq+0x18f/0x21f
[   33.030280]  [<ffffffff81017681>] ? lapic_next_event+0x18/0x1c
[   33.030282]  [<ffffffff81037c9a>] ? __do_softirq+0x83/0x12a
[   33.030285]  [<ffffffff81054924>] ? tick_program_event+0x1a/0x1c
[   33.030287]  [<ffffffff8100378c>] ? call_softirq+0x1c/0x28
[   33.030289]  [<ffffffff81004c03>] ? do_softirq+0x33/0x68
[   33.030291]  [<ffffffff81037b3e>] ? irq_exit+0x36/0x78
[   33.030293]  [<ffffffff810181ba>] ? smp_apic_timer_interrupt+0x88/0x96
[   33.030296]  [<ffffffff81003253>] ? apic_timer_interrupt+0x13/0x20
[   33.030297]  <EOI>  [<ffffffff811a44e1>] ? intel_idle+0xc3/0xe9
[   33.030301]  [<ffffffff811a44c4>] ? intel_idle+0xa6/0xe9
[   33.030303]  [<ffffffff81248ff3>] ? cpuidle_idle_call+0x94/0xcd
[   33.030305]  [<ffffffff81001c93>] ? cpu_idle+0x5a/0x91
[   33.030307]  [<ffffffff81353824>] ? rest_init+0x68/0x6a
[   33.030309]  [<ffffffff8165fcc2>] ? start_kernel+0x35e/0x369
[   33.030312]  [<ffffffff8165f2a8>] ? x86_64_start_reservations+0xb8/0xbc
[   33.030314]  [<ffffffff8165f39e>] ? x86_64_start_kernel+0xf2/0xf9
[   33.030316] FIX iommu_iova: Restoring 0xffff8800141a0068-0xffff8800141a0=
06f=3D0xcc
[   33.030316]=20
[   33.030320] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[   33.030321] BUG iommu_iova: Wrong object count. Counter is 3 but counted=
 were 4
[   33.030322] ------------------------------------------------------------=
=2D----------------
[   33.030323]=20
[   33.030325] INFO: Slab 0xffffea0000465b00 objects=3D64 used=3D3 fp=3D0xf=
fff8800141a04c0 flags=3D0x40000000000000c1
[   33.030327] Pid: 0, comm: swapper Not tainted 2.6.38.6-dbg #1
[   33.030328] Call Trace:
[   33.030328]  <IRQ>  [<ffffffff810a4c7d>] ? slab_err+0x8a/0x98
[   33.030332]  [<ffffffff8136101f>] ? dump_stack+0x6a/0x71
[   33.030335]  [<ffffffff810a4f68>] ? on_freelist+0x169/0x19d
[   33.030337]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030339]  [<ffffffff810a584b>] ? free_debug_processing+0x5c/0x1a3
[   33.030342]  [<ffffffff810a65a6>] ? __slab_free+0xe4/0xf9
[   33.030344]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030346]  [<ffffffff810a6c2b>] ? kmem_cache_free+0x5a/0x66
[   33.030348]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030350]  [<ffffffff8119cc5b>] ? __free_iova+0x5a/0x62
[   33.030352]  [<ffffffff811a01ae>] ? flush_unmaps+0xee/0x12f
[   33.030355]  [<ffffffff8104db99>] ? sched_clock_cpu+0x46/0xd1
[   33.030357]  [<ffffffff811a01ef>] ? flush_unmaps_timeout+0x0/0x30
[   33.030359]  [<ffffffff811a020c>] ? flush_unmaps_timeout+0x1d/0x30
[   33.030362]  [<ffffffff8103cc46>] ? run_timer_softirq+0x18f/0x21f
[   33.030364]  [<ffffffff81017681>] ? lapic_next_event+0x18/0x1c
[   33.030366]  [<ffffffff81037c9a>] ? __do_softirq+0x83/0x12a
[   33.030369]  [<ffffffff81054924>] ? tick_program_event+0x1a/0x1c
[   33.030371]  [<ffffffff8100378c>] ? call_softirq+0x1c/0x28
[   33.030373]  [<ffffffff81004c03>] ? do_softirq+0x33/0x68
[   33.030375]  [<ffffffff81037b3e>] ? irq_exit+0x36/0x78
[   33.030377]  [<ffffffff810181ba>] ? smp_apic_timer_interrupt+0x88/0x96
[   33.030380]  [<ffffffff81003253>] ? apic_timer_interrupt+0x13/0x20
[   33.030381]  <EOI>  [<ffffffff811a44e1>] ? intel_idle+0xc3/0xe9
[   33.030385]  [<ffffffff811a44c4>] ? intel_idle+0xa6/0xe9
[   33.030387]  [<ffffffff81248ff3>] ? cpuidle_idle_call+0x94/0xcd
[   33.030389]  [<ffffffff81001c93>] ? cpu_idle+0x5a/0x91
[   33.030391]  [<ffffffff81353824>] ? rest_init+0x68/0x6a
[   33.030393]  [<ffffffff8165fcc2>] ? start_kernel+0x35e/0x369
[   33.030395]  [<ffffffff8165f2a8>] ? x86_64_start_reservations+0xb8/0xbc
[   33.030398]  [<ffffffff8165f39e>] ? x86_64_start_kernel+0xf2/0xf9
[   33.030399] FIX iommu_iova: Object count adjusted.
[   33.030400] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[   33.030402] BUG iommu_iova: Redzone overwritten
[   33.030403] ------------------------------------------------------------=
=2D----------------
[   33.030404]=20
[   33.030405] INFO: 0xffff8800141a0028-0xffff8800141a002f. First byte 0xbb=
 instead of 0xcc
[   33.030407] INFO: Slab 0xffffea0000465b00 objects=3D64 used=3D4 fp=3D0xf=
fff8800141a04c0 flags=3D0x40000000000000c1
[   33.030409] INFO: Object 0xffff8800141a0000 @offset=3D0 fp=3D0xffff88001=
41a0080
[   33.030410]=20
[   33.030411]   Object 0xffff8800141a0000:  80 00 1a 14 00 88 ff ff c0 04 =
1a 14 00 88 ff ff ......=FF=FF=C0.....=FF=FF
[   33.030417]   Object 0xffff8800141a0010:  00 00 00 00 00 00 00 00 5f ff =
0f 00 00 00 00 00 ........_=FF......
[   33.030423]   Object 0xffff8800141a0020:  40 ff 0f 00 00 00 00 00       =
                  @=FF......       =20
[   33.030429]  Redzone 0xffff8800141a0028:  bb bb bb bb bb bb bb bb       =
                  =BB=BB=BB=BB=BB=BB=BB=BB       =20
[   33.030435]  Padding 0xffff8800141a0030:  ff ff ff ff ff ff ff ff ff fe =
ff ff ff ff ff ff =FF=FF=FF=FF=FF=FF=FF=FF=FF=FE=FF=FF=FF=FF=FF=FF
[   33.030442] Pid: 0, comm: swapper Not tainted 2.6.38.6-dbg #1
[   33.030443] Call Trace:
[   33.030444]  <IRQ>  [<ffffffff810a4db9>] ? print_trailer+0x12e/0x137
[   33.030448]  [<ffffffff810a5272>] ? check_bytes_and_report+0xb9/0xfd
[   33.030450]  [<ffffffff8119d1cc>] ? domain_get_iommu+0x18/0x46
[   33.030452]  [<ffffffff810a52ff>] ? check_object+0x49/0x194
[   33.030454]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030457]  [<ffffffff810a5869>] ? free_debug_processing+0x7a/0x1a3
[   33.030459]  [<ffffffff810a65a6>] ? __slab_free+0xe4/0xf9
[   33.030461]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030464]  [<ffffffff810a6c2b>] ? kmem_cache_free+0x5a/0x66
[   33.030466]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030468]  [<ffffffff8119cc5b>] ? __free_iova+0x5a/0x62
[   33.030470]  [<ffffffff811a01ae>] ? flush_unmaps+0xee/0x12f
[   33.030472]  [<ffffffff8104db99>] ? sched_clock_cpu+0x46/0xd1
[   33.030474]  [<ffffffff811a01ef>] ? flush_unmaps_timeout+0x0/0x30
[   33.030477]  [<ffffffff811a020c>] ? flush_unmaps_timeout+0x1d/0x30
[   33.030479]  [<ffffffff8103cc46>] ? run_timer_softirq+0x18f/0x21f
[   33.030482]  [<ffffffff81017681>] ? lapic_next_event+0x18/0x1c
[   33.030484]  [<ffffffff81037c9a>] ? __do_softirq+0x83/0x12a
[   33.030486]  [<ffffffff81054924>] ? tick_program_event+0x1a/0x1c
[   33.030488]  [<ffffffff8100378c>] ? call_softirq+0x1c/0x28
[   33.030490]  [<ffffffff81004c03>] ? do_softirq+0x33/0x68
[   33.030492]  [<ffffffff81037b3e>] ? irq_exit+0x36/0x78
[   33.030495]  [<ffffffff810181ba>] ? smp_apic_timer_interrupt+0x88/0x96
[   33.030497]  [<ffffffff81003253>] ? apic_timer_interrupt+0x13/0x20
[   33.030498]  <EOI>  [<ffffffff811a44e1>] ? intel_idle+0xc3/0xe9
[   33.030502]  [<ffffffff811a44c4>] ? intel_idle+0xa6/0xe9
[   33.030505]  [<ffffffff81248ff3>] ? cpuidle_idle_call+0x94/0xcd
[   33.030506]  [<ffffffff81001c93>] ? cpu_idle+0x5a/0x91
[   33.030508]  [<ffffffff81353824>] ? rest_init+0x68/0x6a
[   33.030511]  [<ffffffff8165fcc2>] ? start_kernel+0x35e/0x369
[   33.030513]  [<ffffffff8165f2a8>] ? x86_64_start_reservations+0xb8/0xbc
[   33.030515]  [<ffffffff8165f39e>] ? x86_64_start_kernel+0xf2/0xf9
[   33.030517] FIX iommu_iova: Restoring 0xffff8800141a0028-0xffff8800141a0=
02f=3D0xcc
[   33.030518]=20
[   33.030521] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[   33.030522] BUG iommu_iova: Wrong object count. Counter is 4 but counted=
 were 5
[   33.030524] ------------------------------------------------------------=
=2D----------------
[   33.030525]=20
[   33.030526] INFO: Slab 0xffffea0000465b00 objects=3D64 used=3D4 fp=3D0xf=
fff8800141a04c0 flags=3D0x40000000000000c1
[   33.030528] Pid: 0, comm: swapper Not tainted 2.6.38.6-dbg #1
[   33.030529] Call Trace:
[   33.030530]  <IRQ>  [<ffffffff810a4c7d>] ? slab_err+0x8a/0x98
[   33.030534]  [<ffffffff8136101f>] ? dump_stack+0x6a/0x71
[   33.030536]  [<ffffffff810a4f68>] ? on_freelist+0x169/0x19d
[   33.030538]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030541]  [<ffffffff810a584b>] ? free_debug_processing+0x5c/0x1a3
[   33.030543]  [<ffffffff810a65a6>] ? __slab_free+0xe4/0xf9
[   33.030545]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030547]  [<ffffffff810a6c2b>] ? kmem_cache_free+0x5a/0x66
[   33.030549]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030551]  [<ffffffff8119cc5b>] ? __free_iova+0x5a/0x62
[   33.030553]  [<ffffffff811a01ae>] ? flush_unmaps+0xee/0x12f
[   33.030556]  [<ffffffff8104db99>] ? sched_clock_cpu+0x46/0xd1
[   33.030558]  [<ffffffff811a01ef>] ? flush_unmaps_timeout+0x0/0x30
[   33.030560]  [<ffffffff811a020c>] ? flush_unmaps_timeout+0x1d/0x30
[   33.030563]  [<ffffffff8103cc46>] ? run_timer_softirq+0x18f/0x21f
[   33.030565]  [<ffffffff81017681>] ? lapic_next_event+0x18/0x1c
[   33.030567]  [<ffffffff81037c9a>] ? __do_softirq+0x83/0x12a
[   33.030570]  [<ffffffff81054924>] ? tick_program_event+0x1a/0x1c
[   33.030572]  [<ffffffff8100378c>] ? call_softirq+0x1c/0x28
[   33.030574]  [<ffffffff81004c03>] ? do_softirq+0x33/0x68
[   33.030576]  [<ffffffff81037b3e>] ? irq_exit+0x36/0x78
[   33.030578]  [<ffffffff810181ba>] ? smp_apic_timer_interrupt+0x88/0x96
[   33.030581]  [<ffffffff81003253>] ? apic_timer_interrupt+0x13/0x20
[   33.030582]  <EOI>  [<ffffffff811a44e1>] ? intel_idle+0xc3/0xe9
[   33.030586]  [<ffffffff811a44c4>] ? intel_idle+0xa6/0xe9
[   33.030588]  [<ffffffff81248ff3>] ? cpuidle_idle_call+0x94/0xcd
[   33.030590]  [<ffffffff81001c93>] ? cpu_idle+0x5a/0x91
[   33.030592]  [<ffffffff81353824>] ? rest_init+0x68/0x6a
[   33.030594]  [<ffffffff8165fcc2>] ? start_kernel+0x35e/0x369
[   33.030596]  [<ffffffff8165f2a8>] ? x86_64_start_reservations+0xb8/0xbc
[   33.030599]  [<ffffffff8165f39e>] ? x86_64_start_kernel+0xf2/0xf9
[   33.030600] FIX iommu_iova: Object count adjusted.
[   33.030601] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[   33.030603] BUG iommu_iova: Redzone overwritten
[   33.030604] ------------------------------------------------------------=
=2D----------------
[   33.030605]=20
[   33.030606] INFO: 0xffff8800141a00a8-0xffff8800141a00af. First byte 0xbb=
 instead of 0xcc
[   33.030608] INFO: Slab 0xffffea0000465b00 objects=3D64 used=3D5 fp=3D0xf=
fff8800141a04c0 flags=3D0x40000000000000c1
[   33.030610] INFO: Object 0xffff8800141a0080 @offset=3D128 fp=3D0xffff880=
0141a0500
[   33.030611]=20
[   33.030612] Bytes b4 0xffff8800141a0070:  e0 4f 61 81 ff ff ff ff 90 5d =
b2 14 00 88 ff ff =E0Oa.=FF=FF=FF=FF.]=B2...=FF=FF
[   33.030618]   Object 0xffff8800141a0080:  00 05 1a 14 00 88 ff ff c0 04 =
1a 14 00 88 ff ff ......=FF=FF=C0.....=FF=FF
[   33.030625]   Object 0xffff8800141a0090:  00 00 00 00 00 00 00 00 3f ff =
0f 00 00 00 00 00 ........?=FF......
[   33.030631]   Object 0xffff8800141a00a0:  00 ff 0f 00 00 00 00 00       =
                  .=FF......       =20
[   33.030637]  Redzone 0xffff8800141a00a8:  bb bb bb bb bb bb bb bb       =
                  =BB=BB=BB=BB=BB=BB=BB=BB       =20
[   33.030643]  Padding 0xffff8800141a00b0:  01 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 ................
[   33.030649] Pid: 0, comm: swapper Not tainted 2.6.38.6-dbg #1
[   33.030651] Call Trace:
[   33.030651]  <IRQ>  [<ffffffff810a4db9>] ? print_trailer+0x12e/0x137
[   33.030655]  [<ffffffff810a5272>] ? check_bytes_and_report+0xb9/0xfd
[   33.030658]  [<ffffffff8119d1cc>] ? domain_get_iommu+0x18/0x46
[   33.030660]  [<ffffffff810a52ff>] ? check_object+0x49/0x194
[   33.030662]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030664]  [<ffffffff810a5869>] ? free_debug_processing+0x7a/0x1a3
[   33.030667]  [<ffffffff810a65a6>] ? __slab_free+0xe4/0xf9
[   33.030669]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030671]  [<ffffffff810a6c2b>] ? kmem_cache_free+0x5a/0x66
[   33.030673]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030675]  [<ffffffff8119cc5b>] ? __free_iova+0x5a/0x62
[   33.030677]  [<ffffffff811a01ae>] ? flush_unmaps+0xee/0x12f
[   33.030680]  [<ffffffff8104db99>] ? sched_clock_cpu+0x46/0xd1
[   33.030682]  [<ffffffff811a01ef>] ? flush_unmaps_timeout+0x0/0x30
[   33.030684]  [<ffffffff811a020c>] ? flush_unmaps_timeout+0x1d/0x30
[   33.030687]  [<ffffffff8103cc46>] ? run_timer_softirq+0x18f/0x21f
[   33.030689]  [<ffffffff81017681>] ? lapic_next_event+0x18/0x1c
[   33.030691]  [<ffffffff81037c9a>] ? __do_softirq+0x83/0x12a
[   33.030694]  [<ffffffff81054924>] ? tick_program_event+0x1a/0x1c
[   33.030696]  [<ffffffff8100378c>] ? call_softirq+0x1c/0x28
[   33.030698]  [<ffffffff81004c03>] ? do_softirq+0x33/0x68
[   33.030700]  [<ffffffff81037b3e>] ? irq_exit+0x36/0x78
[   33.030702]  [<ffffffff810181ba>] ? smp_apic_timer_interrupt+0x88/0x96
[   33.030704]  [<ffffffff81003253>] ? apic_timer_interrupt+0x13/0x20
[   33.030705]  <EOI>  [<ffffffff811a44e1>] ? intel_idle+0xc3/0xe9
[   33.030710]  [<ffffffff811a44c4>] ? intel_idle+0xa6/0xe9
[   33.030712]  [<ffffffff81248ff3>] ? cpuidle_idle_call+0x94/0xcd
[   33.030714]  [<ffffffff81001c93>] ? cpu_idle+0x5a/0x91
[   33.030716]  [<ffffffff81353824>] ? rest_init+0x68/0x6a
[   33.030718]  [<ffffffff8165fcc2>] ? start_kernel+0x35e/0x369
[   33.030720]  [<ffffffff8165f2a8>] ? x86_64_start_reservations+0xb8/0xbc
[   33.030722]  [<ffffffff8165f39e>] ? x86_64_start_kernel+0xf2/0xf9
[   33.030724] FIX iommu_iova: Restoring 0xffff8800141a00a8-0xffff8800141a0=
0af=3D0xcc
[   33.030725]=20
[   33.030728] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[   33.030729] BUG iommu_iova: Wrong object count. Counter is 5 but counted=
 were 6
[   33.030731] ------------------------------------------------------------=
=2D----------------
[   33.030732]=20
[   33.030733] INFO: Slab 0xffffea0000465b00 objects=3D64 used=3D5 fp=3D0xf=
fff8800141a04c0 flags=3D0x40000000000000c1
[   33.030735] Pid: 0, comm: swapper Not tainted 2.6.38.6-dbg #1
[   33.030736] Call Trace:
[   33.030737]  <IRQ>  [<ffffffff810a4c7d>] ? slab_err+0x8a/0x98
[   33.030741]  [<ffffffff8136101f>] ? dump_stack+0x6a/0x71
[   33.030743]  [<ffffffff810a4f68>] ? on_freelist+0x169/0x19d
[   33.030745]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030748]  [<ffffffff810a584b>] ? free_debug_processing+0x5c/0x1a3
[   33.030750]  [<ffffffff810a65a6>] ? __slab_free+0xe4/0xf9
[   33.030752]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030754]  [<ffffffff810a6c2b>] ? kmem_cache_free+0x5a/0x66
[   33.030756]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030758]  [<ffffffff8119cc5b>] ? __free_iova+0x5a/0x62
[   33.030761]  [<ffffffff811a01ae>] ? flush_unmaps+0xee/0x12f
[   33.030763]  [<ffffffff8104db99>] ? sched_clock_cpu+0x46/0xd1
[   33.030766]  [<ffffffff811a01ef>] ? flush_unmaps_timeout+0x0/0x30
[   33.030769]  [<ffffffff811a020c>] ? flush_unmaps_timeout+0x1d/0x30
[   33.030772]  [<ffffffff8103cc46>] ? run_timer_softirq+0x18f/0x21f
[   33.030775]  [<ffffffff81017681>] ? lapic_next_event+0x18/0x1c
[   33.030777]  [<ffffffff81037c9a>] ? __do_softirq+0x83/0x12a
[   33.030779]  [<ffffffff81054924>] ? tick_program_event+0x1a/0x1c
[   33.030782]  [<ffffffff8100378c>] ? call_softirq+0x1c/0x28
[   33.030784]  [<ffffffff81004c03>] ? do_softirq+0x33/0x68
[   33.030786]  [<ffffffff81037b3e>] ? irq_exit+0x36/0x78
[   33.030788]  [<ffffffff810181ba>] ? smp_apic_timer_interrupt+0x88/0x96
[   33.030791]  [<ffffffff81003253>] ? apic_timer_interrupt+0x13/0x20
[   33.030792]  <EOI>  [<ffffffff811a44e1>] ? intel_idle+0xc3/0xe9
[   33.030797]  [<ffffffff811a44c4>] ? intel_idle+0xa6/0xe9
[   33.030799]  [<ffffffff81248ff3>] ? cpuidle_idle_call+0x94/0xcd
[   33.030801]  [<ffffffff81001c93>] ? cpu_idle+0x5a/0x91
[   33.030803]  [<ffffffff81353824>] ? rest_init+0x68/0x6a
[   33.030805]  [<ffffffff8165fcc2>] ? start_kernel+0x35e/0x369
[   33.030807]  [<ffffffff8165f2a8>] ? x86_64_start_reservations+0xb8/0xbc
[   33.030809]  [<ffffffff8165f39e>] ? x86_64_start_kernel+0xf2/0xf9
[   33.030811] FIX iommu_iova: Object count adjusted.
[   33.030812] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[   33.030814] BUG iommu_iova: Redzone overwritten
[   33.030815] ------------------------------------------------------------=
=2D----------------
[   33.030816]=20
[   33.030817] INFO: 0xffff8800141a0528-0xffff8800141a052f. First byte 0xbb=
 instead of 0xcc
[   33.030819] INFO: Slab 0xffffea0000465b00 objects=3D64 used=3D6 fp=3D0xf=
fff8800141a04c0 flags=3D0x40000000000000c1
[   33.030821] INFO: Object 0xffff8800141a0500 @offset=3D1280 fp=3D0xffff88=
00141a0480
[   33.030822]=20
[   33.030823] Bytes b4 0xffff8800141a04f0:  e0 4f 61 81 ff ff ff ff 70 5f =
b2 14 00 88 ff ff =E0Oa.=FF=FF=FF=FFp_=B2...=FF=FF
[   33.030829]   Object 0xffff8800141a0500:  80 04 1a 14 00 88 ff ff c0 04 =
1a 14 00 88 ff ff ......=FF=FF=C0.....=FF=FF
[   33.030835]   Object 0xffff8800141a0510:  00 00 00 00 00 00 00 00 ff fe =
0f 00 00 00 00 00 ........=FF=FE......
[   33.030842]   Object 0xffff8800141a0520:  e0 fe 0f 00 00 00 00 00       =
                  =E0=FE......       =20
[   33.030848]  Redzone 0xffff8800141a0528:  bb bb bb bb bb bb bb bb       =
                  =BB=BB=BB=BB=BB=BB=BB=BB       =20
[   33.030854]  Padding 0xffff8800141a0530:  00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 ................
[   33.030860] Pid: 0, comm: swapper Not tainted 2.6.38.6-dbg #1
[   33.030861] Call Trace:
[   33.030862]  <IRQ>  [<ffffffff810a4db9>] ? print_trailer+0x12e/0x137
[   33.030866]  [<ffffffff810a5272>] ? check_bytes_and_report+0xb9/0xfd
[   33.030868]  [<ffffffff8119d1cc>] ? domain_get_iommu+0x18/0x46
[   33.030871]  [<ffffffff810a52ff>] ? check_object+0x49/0x194
[   33.030873]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030875]  [<ffffffff810a5869>] ? free_debug_processing+0x7a/0x1a3
[   33.030877]  [<ffffffff810a65a6>] ? __slab_free+0xe4/0xf9
[   33.030879]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030882]  [<ffffffff810a6c2b>] ? kmem_cache_free+0x5a/0x66
[   33.030884]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030886]  [<ffffffff8119cc5b>] ? __free_iova+0x5a/0x62
[   33.030888]  [<ffffffff811a01ae>] ? flush_unmaps+0xee/0x12f
[   33.030890]  [<ffffffff8104db99>] ? sched_clock_cpu+0x46/0xd1
[   33.030893]  [<ffffffff811a01ef>] ? flush_unmaps_timeout+0x0/0x30
[   33.030895]  [<ffffffff811a020c>] ? flush_unmaps_timeout+0x1d/0x30
[   33.030897]  [<ffffffff8103cc46>] ? run_timer_softirq+0x18f/0x21f
[   33.030900]  [<ffffffff81017681>] ? lapic_next_event+0x18/0x1c
[   33.030902]  [<ffffffff81037c9a>] ? __do_softirq+0x83/0x12a
[   33.030904]  [<ffffffff81054924>] ? tick_program_event+0x1a/0x1c
[   33.030907]  [<ffffffff8100378c>] ? call_softirq+0x1c/0x28
[   33.030909]  [<ffffffff81004c03>] ? do_softirq+0x33/0x68
[   33.030911]  [<ffffffff81037b3e>] ? irq_exit+0x36/0x78
[   33.030913]  [<ffffffff810181ba>] ? smp_apic_timer_interrupt+0x88/0x96
[   33.030915]  [<ffffffff81003253>] ? apic_timer_interrupt+0x13/0x20
[   33.030916]  <EOI>  [<ffffffff811a44e1>] ? intel_idle+0xc3/0xe9
[   33.030921]  [<ffffffff811a44c4>] ? intel_idle+0xa6/0xe9
[   33.030923]  [<ffffffff81248ff3>] ? cpuidle_idle_call+0x94/0xcd
[   33.030925]  [<ffffffff81001c93>] ? cpu_idle+0x5a/0x91
[   33.030927]  [<ffffffff81353824>] ? rest_init+0x68/0x6a
[   33.030929]  [<ffffffff8165fcc2>] ? start_kernel+0x35e/0x369
[   33.030931]  [<ffffffff8165f2a8>] ? x86_64_start_reservations+0xb8/0xbc
[   33.030933]  [<ffffffff8165f39e>] ? x86_64_start_kernel+0xf2/0xf9
[   33.030935] FIX iommu_iova: Restoring 0xffff8800141a0528-0xffff8800141a0=
52f=3D0xcc
[   33.030936]=20
[   33.030938] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[   33.030939] BUG iommu_iova: Object already free
[   33.030940] ------------------------------------------------------------=
=2D----------------
[   33.030941]=20
[   33.030942] INFO: Slab 0xffffea0000465b00 objects=3D64 used=3D6 fp=3D0xf=
fff8800141a04c0 flags=3D0x40000000000000c1
[   33.030944] INFO: Object 0xffff8800141a04c0 @offset=3D1216 fp=3D0xffff88=
00141a0480
[   33.030945]=20
[   33.030946] Bytes b4 0xffff8800141a04b0:  ff ff ff ff ff ff ff ff ff fe =
ff ff ff ff ff ff =FF=FF=FF=FF=FF=FF=FF=FF=FF=FE=FF=FF=FF=FF=FF=FF
[   33.030952]   Object 0xffff8800141a04c0:  80 04 1a 14 00 88 ff ff 00 00 =
00 00 00 00 00 00 ......=FF=FF........
[   33.030959]   Object 0xffff8800141a04d0:  00 00 00 00 00 00 00 00 ff ff =
0f 00 00 00 00 00 ........=FF=FF......
[   33.030965]   Object 0xffff8800141a04e0:  fe ff 0f 00 00 00 00 00       =
                  =FE=FF......       =20
[   33.030971]  Redzone 0xffff8800141a04e8:  bb bb bb bb bb bb bb bb       =
                  =BB=BB=BB=BB=BB=BB=BB=BB       =20
[   33.030977]  Padding 0xffff8800141a04f0:  e0 4f 61 81 ff ff ff ff 70 5f =
b2 14 00 88 ff ff =E0Oa.=FF=FF=FF=FFp_=B2...=FF=FF
[   33.030984] Pid: 0, comm: swapper Not tainted 2.6.38.6-dbg #1
[   33.030985] Call Trace:
[   33.030985]  <IRQ>  [<ffffffff810a4db9>] ? print_trailer+0x12e/0x137
[   33.030989]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.030991]  [<ffffffff810a4df7>] ? object_err+0x35/0x3d
[   33.030994]  [<ffffffff810a58d4>] ? free_debug_processing+0xe5/0x1a3
[   33.030996]  [<ffffffff810a65a6>] ? __slab_free+0xe4/0xf9
[   33.030998]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.031001]  [<ffffffff810a6c2b>] ? kmem_cache_free+0x5a/0x66
[   33.031003]  [<ffffffff8119d1b2>] ? free_iova_mem+0x13/0x15
[   33.031005]  [<ffffffff8119cc5b>] ? __free_iova+0x5a/0x62
[   33.031007]  [<ffffffff811a01ae>] ? flush_unmaps+0xee/0x12f
[   33.031009]  [<ffffffff8104db99>] ? sched_clock_cpu+0x46/0xd1
[   33.031011]  [<ffffffff811a01ef>] ? flush_unmaps_timeout+0x0/0x30
[   33.031014]  [<ffffffff811a020c>] ? flush_unmaps_timeout+0x1d/0x30
[   33.031016]  [<ffffffff8103cc46>] ? run_timer_softirq+0x18f/0x21f
[   33.031019]  [<ffffffff81017681>] ? lapic_next_event+0x18/0x1c
[   33.031021]  [<ffffffff81037c9a>] ? __do_softirq+0x83/0x12a
[   33.031023]  [<ffffffff81054924>] ? tick_program_event+0x1a/0x1c
[   33.031025]  [<ffffffff8100378c>] ? call_softirq+0x1c/0x28
[   33.031027]  [<ffffffff81004c03>] ? do_softirq+0x33/0x68
[   33.031029]  [<ffffffff81037b3e>] ? irq_exit+0x36/0x78
[   33.031032]  [<ffffffff810181ba>] ? smp_apic_timer_interrupt+0x88/0x96
[   33.031034]  [<ffffffff81003253>] ? apic_timer_interrupt+0x13/0x20
[   33.031035]  <EOI>  [<ffffffff811a44e1>] ? intel_idle+0xc3/0xe9
[   33.031039]  [<ffffffff811a44c4>] ? intel_idle+0xa6/0xe9
[   33.031041]  [<ffffffff81248ff3>] ? cpuidle_idle_call+0x94/0xcd
[   33.031043]  [<ffffffff81001c93>] ? cpu_idle+0x5a/0x91
[   33.031045]  [<ffffffff81353824>] ? rest_init+0x68/0x6a
[   33.031047]  [<ffffffff8165fcc2>] ? start_kernel+0x35e/0x369
[   33.031050]  [<ffffffff8165f2a8>] ? x86_64_start_reservations+0xb8/0xbc
[   33.031052]  [<ffffffff8165f39e>] ? x86_64_start_kernel+0xf2/0xf9
[   33.031054] FIX iommu_iova: Object at 0xffff8800141a04c0 not freed
[   34.937801] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in=
=2Dtree:
[   34.937804] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   34.937893] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[   34.937942] iwlagn 0000:03:00.0: setting latency timer to 64
[   34.938028] iwlagn 0000:03:00.0: Detected Intel(R) Centrino(R) Wireless-=
N 1030 BGN, REV=3D0xB0
[   34.955091] iwlagn 0000:03:00.0: device EEPROM VER=3D0x716, CALIB=3D0x6
[   34.955092] iwlagn 0000:03:00.0: Device SKU: 0X9
[   34.955094] iwlagn 0000:03:00.0: Valid Tx ant: 0X1, Valid Rx ant: 0X3
[   34.955108] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 0 802.11=
a channels
[   34.955510] iwlagn 0000:03:00.0: irq 50 for MSI/MSI-X
[   34.955931] PM: Adding info for No Bus:0000:03:00.0
[   34.957953] PM: Removing info for No Bus:0000:03:00.0
[   34.958019] iwlagn 0000:03:00.0: loaded firmware version 17.168.5.2 buil=
d 35905
[   34.958558] PM: Adding info for No Bus:phy1
[   34.958596] PM: Adding info for No Bus:rfkill1
[   34.958630] ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'
[   34.958702] PM: Adding info for No Bus:wlan0

--Boundary-00=_dI/0NlIKhSVqAJm
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg-kexec.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-kexec.txt"

<6>[    0.000000] Initializing cgroup subsys cpuset
<6>[    0.000000] Initializing cgroup subsys cpu
<5>[    0.000000] Linux version 2.6.38.6-dbg (root@cnulaptop) (gcc version 4.4.5 (Gentoo 4.4.5 p1.2, pie-0.4.5) ) #1 SMP Wed May 18 17:39:58 CEST 2011
<6>[    0.000000] Command line: root=/dev/sda6 crashkernel=160M mem=512M
<6>[    0.000000] BIOS-provided physical RAM map:
<6>[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
<6>[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
<6>[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bac8f000 (usable)
<6>[    0.000000]  BIOS-e820: 00000000bac8f000 - 00000000bacac000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000bacac000 - 00000000bacba000 (ACPI NVS)
<6>[    0.000000]  BIOS-e820: 00000000bacba000 - 00000000badfa000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000badfa000 - 00000000badfc000 (ACPI NVS)
<6>[    0.000000]  BIOS-e820: 00000000badfc000 - 00000000badfe000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000badfe000 - 00000000bae01000 (ACPI NVS)
<6>[    0.000000]  BIOS-e820: 00000000bae01000 - 00000000bae04000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000bae04000 - 00000000bae05000 (ACPI NVS)
<6>[    0.000000]  BIOS-e820: 00000000bae05000 - 00000000bae0a000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000bae0a000 - 00000000bae1b000 (ACPI NVS)
<6>[    0.000000]  BIOS-e820: 00000000bae1b000 - 00000000baf18000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000baf18000 - 00000000baf1c000 (ACPI NVS)
<6>[    0.000000]  BIOS-e820: 00000000baf1c000 - 00000000baf1f000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000baf1f000 - 00000000baf9f000 (ACPI NVS)
<6>[    0.000000]  BIOS-e820: 00000000baf9f000 - 00000000bafff000 (ACPI data)
<6>[    0.000000]  BIOS-e820: 00000000bafff000 - 00000000bb000000 (usable)
<6>[    0.000000]  BIOS-e820: 00000000bb000000 - 00000000bfa00000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fed08000 - 00000000fed09000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed1a000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
<6>[    0.000000]  BIOS-e820: 00000000ffd80000 - 0000000100000000 (reserved)
<6>[    0.000000]  BIOS-e820: 0000000100000000 - 000000023fe00000 (usable)
<7>[    0.000000] e820 remove range: 0000000020000000 - ffffffffffffffff (usable)
<6>[    0.000000] NX (Execute Disable) protection: active
<6>[    0.000000] user-defined physical RAM map:
<6>[    0.000000]  user: 0000000000000000 - 000000000009d800 (usable)
<6>[    0.000000]  user: 000000000009d800 - 00000000000a0000 (reserved)
<6>[    0.000000]  user: 00000000000e0000 - 0000000000100000 (reserved)
<6>[    0.000000]  user: 0000000000100000 - 0000000020000000 (usable)
<6>[    0.000000]  user: 00000000bac8f000 - 00000000bacac000 (reserved)
<6>[    0.000000]  user: 00000000bacac000 - 00000000bacba000 (ACPI NVS)
<6>[    0.000000]  user: 00000000bacba000 - 00000000badfa000 (reserved)
<6>[    0.000000]  user: 00000000badfa000 - 00000000badfc000 (ACPI NVS)
<6>[    0.000000]  user: 00000000badfc000 - 00000000badfe000 (reserved)
<6>[    0.000000]  user: 00000000badfe000 - 00000000bae01000 (ACPI NVS)
<6>[    0.000000]  user: 00000000bae01000 - 00000000bae04000 (reserved)
<6>[    0.000000]  user: 00000000bae04000 - 00000000bae05000 (ACPI NVS)
<6>[    0.000000]  user: 00000000bae05000 - 00000000bae0a000 (reserved)
<6>[    0.000000]  user: 00000000bae0a000 - 00000000bae1b000 (ACPI NVS)
<6>[    0.000000]  user: 00000000bae1b000 - 00000000baf18000 (reserved)
<6>[    0.000000]  user: 00000000baf18000 - 00000000baf1c000 (ACPI NVS)
<6>[    0.000000]  user: 00000000baf1c000 - 00000000baf1f000 (reserved)
<6>[    0.000000]  user: 00000000baf1f000 - 00000000baf9f000 (ACPI NVS)
<6>[    0.000000]  user: 00000000baf9f000 - 00000000bafff000 (ACPI data)
<6>[    0.000000]  user: 00000000bb000000 - 00000000bfa00000 (reserved)
<6>[    0.000000]  user: 00000000f8000000 - 00000000fc000000 (reserved)
<6>[    0.000000]  user: 00000000fec00000 - 00000000fec01000 (reserved)
<6>[    0.000000]  user: 00000000fed08000 - 00000000fed09000 (reserved)
<6>[    0.000000]  user: 00000000fed10000 - 00000000fed1a000 (reserved)
<6>[    0.000000]  user: 00000000fed1c000 - 00000000fed20000 (reserved)
<6>[    0.000000]  user: 00000000fee00000 - 00000000fee01000 (reserved)
<6>[    0.000000]  user: 00000000ffd80000 - 0000000100000000 (reserved)
<6>[    0.000000] DMI 2.6 present.
<7>[    0.000000] DMI: Dell Inc.          Dell System XPS L502X/0YR8NN, BIOS A04 03/25/2011
<7>[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
<7>[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
<6>[    0.000000] No AGP bridge found
<6>[    0.000000] last_pfn = 0x20000 max_arch_pfn = 0x400000000
<7>[    0.000000] MTRR default type: uncachable
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-BFFFF uncachable
<7>[    0.000000]   C0000-FFFFF write-protect
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
<7>[    0.000000]   1 base 000000000 mask F80000000 write-back
<7>[    0.000000]   2 base 080000000 mask FC0000000 write-back
<7>[    0.000000]   3 base 0BC000000 mask FFC000000 uncachable
<7>[    0.000000]   4 base 0BB000000 mask FFF000000 uncachable
<7>[    0.000000]   5 base 100000000 mask F00000000 write-back
<7>[    0.000000]   6 base 200000000 mask FC0000000 write-back
<7>[    0.000000]   7 base 23FE00000 mask FFFE00000 uncachable
<7>[    0.000000]   8 disabled
<7>[    0.000000]   9 disabled
<6>[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
<7>[    0.000000] initial memory mapped : 0 - 20000000
<6>[    0.000000] init_memory_mapping: 0000000000000000-0000000020000000
<7>[    0.000000]  0000000000 - 0020000000 page 2M
<7>[    0.000000] kernel direct mapping tables up to 20000000 @ 1fffe000-20000000
<6>[    0.000000] Reserving 160MB of memory at 352MB for crashkernel (System RAM: 512MB)
<4>[    0.000000] ACPI: RSDP 00000000000f00e0 00024 (v02 DELL  )
<4>[    0.000000] ACPI: XSDT 00000000baffe120 00094 (v01 DELL    QA09    00000002 LOHR 00000002)
<4>[    0.000000] ACPI: FACP 00000000bafef000 000F4 (v03 DELL    QA09    00000002 PTL  00000002)
<4>[    0.000000] ACPI: DSDT 00000000baff2000 08C85 (v02 DELL    SNB-CPT 00000000 INTL 20061109)
<4>[    0.000000] ACPI: FACS 00000000baf3f000 00040
<4>[    0.000000] ACPI: SLIC 00000000baffd000 00176 (v01 DELL    QA09    00000002 LOHR 00000001)
<4>[    0.000000] ACPI: SSDT 00000000baffb000 01068 (v01 DELL   PtidDevc 00001000 INTL 20061109)
<4>[    0.000000] ACPI: ASF! 00000000baff1000 000A5 (v32 DELL    QA09    00000002 PTL  00000002)
<4>[    0.000000] ACPI: HPET 00000000bafee000 00038 (v01 DELL    QA09    00000002 PTL  00000002)
<4>[    0.000000] ACPI: APIC 00000000bafed000 00098 (v01 DELL    QA09    00000002 PTL  00000002)
<4>[    0.000000] ACPI: MCFG 00000000bafec000 0003C (v01 DELL    QA09    00000002 PTL  00000002)
<4>[    0.000000] ACPI: SSDT 00000000bafea000 01217 (v01 NvORef NvOptTbl 00001000 INTL 20061109)
<4>[    0.000000] ACPI: SSDT 00000000bafe9000 00804 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
<4>[    0.000000] ACPI: SSDT 00000000bafe8000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
<4>[    0.000000] ACPI: UEFI 00000000bafe7000 0003E (v01 DELL    QA09    00000002 PTL  00000002)
<4>[    0.000000] ACPI: UEFI 00000000bafe6000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
<4>[    0.000000] ACPI: DMAR 00000000bafe5000 000E8 (v01 INTEL      SNB  00000001 INTL 00000001)
<4>[    0.000000] ACPI: UEFI 00000000bafe4000 0026A (v01 DELL    QA09    00000002 PTL  00000002)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<7>[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff880014e00000-ffff8800155fffff] on node 0
<4>[    0.000000] Zone PFN ranges:
<4>[    0.000000]   DMA      0x00000010 -> 0x00001000
<4>[    0.000000]   DMA32    0x00001000 -> 0x00100000
<4>[    0.000000]   Normal   empty
<4>[    0.000000] Movable zone start PFN for each node
<4>[    0.000000] early_node_map[2] active PFN ranges
<4>[    0.000000]     0: 0x00000010 -> 0x0000009d
<4>[    0.000000]     0: 0x00000100 -> 0x00020000
<7>[    0.000000] On node 0 totalpages: 130957
<7>[    0.000000]   DMA zone: 56 pages used for memmap
<7>[    0.000000]   DMA zone: 6 pages reserved
<7>[    0.000000]   DMA zone: 3919 pages, LIFO batch:0
<7>[    0.000000]   DMA32 zone: 1736 pages used for memmap
<7>[    0.000000]   DMA32 zone: 125240 pages, LIFO batch:31
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x408
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
<6>[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
<6>[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
<6>[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<7>[    0.000000] ACPI: IRQ0 used by override.
<7>[    0.000000] ACPI: IRQ2 used by override.
<7>[    0.000000] ACPI: IRQ9 used by override.
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
<6>[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
<7>[    0.000000] nr_irqs_gsi: 40
<6>[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
<6>[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
<6>[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
<6>[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
<6>[    0.000000] Allocating PCI resources starting at 20000000 (gap: 20000000:9ac8f000)
<6>[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
<6>[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880015c00000 s74880 r8192 d23424 u262144
<7>[    0.000000] pcpu-alloc: s74880 r8192 d23424 u262144 alloc=1*2097152
<7>[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
<4>[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129159
<5>[    0.000000] Kernel command line: root=/dev/sda6 crashkernel=160M mem=512M
<6>[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
<6>[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
<6>[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
<6>[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
<6>[    0.000000] Checking aperture...
<6>[    0.000000] No AGP bridge found
<6>[    0.000000] Queued invalidation will be enabled to support x2apic and Intr-remapping.
<6>[    0.000000] Memory: 342504k/524288k available (3495k kernel code, 460k absent, 181324k reserved, 2945k data, 428k init)
<6>[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
<6>[    0.000000] Hierarchical RCU implementation.
<6>[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
<6>[    0.000000] NR_IRQS:4352 nr_irqs:744 16
<6>[    0.000000] Extended CMOS year: 2000
<4>[    0.000000] Console: colour VGA+ 80x25
<6>[    0.000000] console [tty0] enabled
<7>[    0.000000] hpet clockevent registered
<4>[    0.000000] Fast TSC calibration using PIT
<4>[    0.001000] Detected 2594.241 MHz processor.
<6>[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5188.48 BogoMIPS (lpj=2594241)
<6>[    0.000191] pid_max: default: 32768 minimum: 301
<4>[    0.000313] Mount-cache hash table entries: 256
<6>[    0.000499] Initializing cgroup subsys ns
<4>[    0.000592] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
<6>[    0.000740] Initializing cgroup subsys cpuacct
<6>[    0.000836] Initializing cgroup subsys freezer
<6>[    0.000950] CPU: Physical Processor ID: 0
<6>[    0.001052] CPU: Processor Core ID: 0
<6>[    0.001146] mce: CPU supports 7 MCE banks
<7>[    0.001245] CPU0: Thermal monitoring handled by SMI
<6>[    0.001250] using mwait in idle threads.
<6>[    0.001388] ACPI: Core revision 20110112
<6>[    0.056813] DMAR: Host address width 36
<6>[    0.056916] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
<6>[    0.057015] IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
<6>[    0.057161] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
<6>[    0.057259] IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
<6>[    0.057406] DMAR: RMRR base: 0x000000bae1d000 end: 0x000000bae33fff
<6>[    0.057503] DMAR: RMRR base: 0x000000bb800000 end: 0x000000bf9fffff
<6>[    0.057600] DMAR: No ATSR found
<6>[    0.057760] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
<6>[    0.057857] HPET id 0 under DRHD base 0xfed91000
<6>[    0.057951] HPET id 0 under DRHD base 0xfed91000
<6>[    0.058044] HPET id 0 under DRHD base 0xfed91000
<6>[    0.058138] HPET id 0 under DRHD base 0xfed91000
<6>[    0.058232] HPET id 0 under DRHD base 0xfed91000
<6>[    0.059659] HPET id 0 under DRHD base 0xfed91000
<6>[    0.059753] HPET id 0 under DRHD base 0xfed91000
<6>[    0.059847] HPET id 0 under DRHD base 0xfed91000
<6>[    0.060183] Enabled Interrupt-remapping
<6>[    0.060291] Setting APIC routing to flat
<6>[    0.060758] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<6>[    0.070837] CPU0: Intel(R) Core(TM) i5-2540M CPU @ 2.60GHz stepping 07
<6>[    0.172654] Performance Events: PEBS fmt1+, generic architected perfmon, Intel PMU driver.
<6>[    0.172921] ... version:                3
<6>[    0.173014] ... bit width:              48
<6>[    0.173107] ... generic registers:      4
<6>[    0.173201] ... value mask:             0000ffffffffffff
<6>[    0.173296] ... max period:             000000007fffffff
<6>[    0.173391] ... fixed-purpose events:   3
<6>[    0.173484] ... event mask:             000000070000000f
<6>[    0.173692] Booting Node   0, Processors  #1
<7>[    0.244530] CPU1: Thermal monitoring handled by SMI
<4>[    0.264630]  #2
<7>[    0.335345] CPU2: Thermal monitoring handled by SMI
<4>[    0.355467]  #3
<7>[    0.426162] CPU3: Thermal monitoring handled by SMI
<6>[    0.446152] Brought up 4 CPUs
<6>[    0.446334] Total of 4 processors activated (20751.12 BogoMIPS).
<7>[    0.448084] PM: Adding info for No Bus:platform
<4>[    0.448371] Time: 15:43:25  Date: 05/18/11
<6>[    0.448496] NET: Registered protocol family 16
<7>[    0.448702] PM: Adding info for No Bus:vtcon0
<6>[    0.448728] ACPI: bus type pci registered
<7>[    0.448857] PM: Adding info for No Bus:id
<6>[    0.448896] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
<6>[    0.449047] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
<6>[    0.452753] PCI: Using configuration type 1 for base access
<7>[    0.454912] PM: Adding info for No Bus:default
<4>[    0.454946] bio: create slab <bio-0> at 0
<7>[    0.456473] ACPI: EC: Look up EC in DSDT
<4>[    0.457777] ACPI: Executed 1 blocks of module-level executable AML code
<5>[    0.467117] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
<4>[    0.470039] ACPI: SSDT 00000000bae06718 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
<4>[    0.470620] ACPI: Dynamic OEM Table Load:
<4>[    0.470791] ACPI: SSDT           (null) 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
<4>[    0.473365] ACPI: SSDT 00000000bae07a98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
<4>[    0.473976] ACPI: Dynamic OEM Table Load:
<4>[    0.474149] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
<4>[    0.477220] ACPI: SSDT 00000000bae05d98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
<4>[    0.477787] ACPI: Dynamic OEM Table Load:
<4>[    0.477959] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
<6>[    0.484244] ACPI: Interpreter enabled
<6>[    0.484339] ACPI: (supports S0 S3 S4 S5)
<6>[    0.484604] ACPI: Using IOAPIC for interrupt routing
<7>[    0.484787] PM: Adding info for acpi:LNXSYSTM:00
<7>[    0.484827] PM: Adding info for acpi:LNXCPU:00
<7>[    0.484869] PM: Adding info for acpi:LNXCPU:01
<7>[    0.484905] PM: Adding info for acpi:LNXCPU:02
<7>[    0.484941] PM: Adding info for acpi:LNXCPU:03
<7>[    0.484975] PM: Adding info for acpi:LNXCPU:04
<7>[    0.485010] PM: Adding info for acpi:LNXCPU:05
<7>[    0.485046] PM: Adding info for acpi:LNXCPU:06
<7>[    0.485081] PM: Adding info for acpi:LNXCPU:07
<7>[    0.485128] PM: Adding info for acpi:device:00
<7>[    0.485175] PM: Adding info for acpi:PNP0C14:00
<7>[    0.485246] PM: Adding info for acpi:PNP0A08:00
<7>[    0.485371] PM: Adding info for acpi:device:01
<7>[    0.485415] PM: Adding info for acpi:device:02
<7>[    0.485460] PM: Adding info for acpi:PNP0200:00
<7>[    0.485548] PM: Adding info for acpi:PNP0103:00
<7>[    0.485592] PM: Adding info for acpi:PNP0000:00
<7>[    0.485634] PM: Adding info for acpi:PNP0C04:00
<7>[    0.485678] PM: Adding info for acpi:PNP0C02:00
<7>[    0.485721] PM: Adding info for acpi:PNP0B00:00
<7>[    0.485763] PM: Adding info for acpi:PNP0100:00
<7>[    0.485827] PM: Adding info for acpi:INT3F0D:00
<7>[    0.485884] PM: Adding info for acpi:PNP0C09:00
<7>[    0.486040] PM: Adding info for acpi:PNP0303:00
<7>[    0.486136] PM: Adding info for acpi:DLL04B6:00
<7>[    0.486184] PM: Adding info for acpi:PNP0C02:01
<7>[    0.486324] PM: Adding info for acpi:device:03
<7>[    0.486369] PM: Adding info for acpi:device:04
<7>[    0.486410] PM: Adding info for acpi:device:05
<7>[    0.486452] PM: Adding info for acpi:device:06
<7>[    0.486493] PM: Adding info for acpi:device:07
<7>[    0.486535] PM: Adding info for acpi:device:08
<7>[    0.486576] PM: Adding info for acpi:device:09
<7>[    0.486618] PM: Adding info for acpi:device:0a
<7>[    0.486660] PM: Adding info for acpi:device:0b
<7>[    0.486702] PM: Adding info for acpi:device:0c
<7>[    0.486744] PM: Adding info for acpi:device:0d
<7>[    0.486786] PM: Adding info for acpi:device:0e
<7>[    0.486919] PM: Adding info for acpi:device:0f
<7>[    0.486963] PM: Adding info for acpi:device:10
<7>[    0.487005] PM: Adding info for acpi:device:11
<7>[    0.487049] PM: Adding info for acpi:device:12
<7>[    0.487105] PM: Adding info for acpi:device:13
<7>[    0.487149] PM: Adding info for acpi:device:14
<7>[    0.487191] PM: Adding info for acpi:device:15
<7>[    0.487233] PM: Adding info for acpi:device:16
<7>[    0.487274] PM: Adding info for acpi:device:17
<7>[    0.487316] PM: Adding info for acpi:device:18
<7>[    0.487422] PM: Adding info for acpi:device:19
<7>[    0.487528] PM: Adding info for acpi:device:1a
<7>[    0.487580] PM: Adding info for acpi:device:1b
<7>[    0.487686] PM: Adding info for acpi:device:1c
<7>[    0.487738] PM: Adding info for acpi:device:1d
<7>[    0.487843] PM: Adding info for acpi:device:1e
<7>[    0.487896] PM: Adding info for acpi:device:1f
<7>[    0.488014] PM: Adding info for acpi:device:20
<7>[    0.488071] PM: Adding info for acpi:device:21
<7>[    0.488180] PM: Adding info for acpi:device:22
<7>[    0.488234] PM: Adding info for acpi:device:23
<7>[    0.488278] PM: Adding info for acpi:device:24
<7>[    0.488323] PM: Adding info for acpi:device:25
<7>[    0.488366] PM: Adding info for acpi:device:26
<7>[    0.488408] PM: Adding info for acpi:device:27
<7>[    0.488449] PM: Adding info for acpi:device:28
<7>[    0.488555] PM: Adding info for acpi:device:29
<7>[    0.488608] PM: Adding info for acpi:device:2a
<7>[    0.488712] PM: Adding info for acpi:device:2b
<7>[    0.488766] PM: Adding info for acpi:device:2c
<7>[    0.488872] PM: Adding info for acpi:device:2d
<7>[    0.488925] PM: Adding info for acpi:device:2e
<7>[    0.488970] PM: Adding info for acpi:device:2f
<7>[    0.489011] PM: Adding info for acpi:device:30
<7>[    0.489060] PM: Adding info for acpi:device:31
<7>[    0.489130] PM: Adding info for acpi:device:32
<7>[    0.489193] PM: Adding info for acpi:device:33
<7>[    0.489266] PM: Adding info for acpi:LNXVIDEO:00
<7>[    0.489359] PM: Adding info for acpi:LNXVIDEO:01
<7>[    0.489425] PM: Adding info for acpi:device:34
<7>[    0.489486] PM: Adding info for acpi:device:35
<7>[    0.489547] PM: Adding info for acpi:device:36
<7>[    0.489608] PM: Adding info for acpi:device:37
<7>[    0.489670] PM: Adding info for acpi:device:38
<7>[    0.489730] PM: Adding info for acpi:device:39
<7>[    0.489792] PM: Adding info for acpi:device:3a
<7>[    0.489853] PM: Adding info for acpi:device:3b
<7>[    0.489939] PM: Adding info for acpi:SMO8800:00
<7>[    0.490028] PM: Adding info for acpi:PNP0C0F:00
<7>[    0.490099] PM: Adding info for acpi:PNP0C0F:01
<7>[    0.490171] PM: Adding info for acpi:PNP0C0F:02
<7>[    0.490241] PM: Adding info for acpi:PNP0C0F:03
<7>[    0.490312] PM: Adding info for acpi:PNP0C0F:04
<7>[    0.490382] PM: Adding info for acpi:PNP0C0F:05
<7>[    0.490452] PM: Adding info for acpi:PNP0C0F:06
<7>[    0.490523] PM: Adding info for acpi:PNP0C0F:07
<7>[    0.490569] PM: Adding info for acpi:PNP0C0C:00
<7>[    0.490614] PM: Adding info for acpi:PNP0C0E:00
<7>[    0.491444] PM: Adding info for acpi:PNP0C0D:00
<7>[    0.491511] PM: Adding info for acpi:ACPI0003:00
<7>[    0.491584] PM: Adding info for acpi:PNP0C0A:00
<7>[    0.491644] PM: Adding info for acpi:INT340E:00
<7>[    0.491694] PM: Adding info for acpi:device:3c
<7>[    0.491727] PM: Adding info for acpi:LNXTHERM:00
<7>[    0.491764] PM: Adding info for acpi:LNXTHERM:01
<7>[    0.491909] PM: Adding info for acpi:LNXPWRBN:00
<6>[    0.492034] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
<6>[    0.495224] ACPI: No dock devices found.
<6>[    0.495319] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<7>[    0.495783] \_SB_.PCI0:_OSC invalid UUID
<7>[    0.495784] _OSC request data:1 8 1f 
<6>[    0.495787] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
<7>[    0.495899] PM: Adding info for No Bus:pci0000:00
<7>[    0.495909] PM: Adding info for No Bus:0000:00
<6>[    0.496455] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
<6>[    0.496554] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
<6>[    0.496652] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
<6>[    0.496799] pci_root PNP0A08:00: host bridge window [mem 0xbfa00000-0xfeafffff]
<6>[    0.496945] pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
<7>[    0.497103] pci 0000:00:00.0: [8086:0104] type 0 class 0x000600
<7>[    0.497124] pci 0000:00:00.0: rpm_resume flags 0x0
<7>[    0.497126] pci 0000:00:00.0: rpm_resume returns -11
<7>[    0.497137] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
<7>[    0.497157] pci 0000:00:01.0: rpm_resume flags 0x0
<7>[    0.497158] pci 0000:00:01.0: rpm_resume returns -11
<7>[    0.497162] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
<7>[    0.497164] pci 0000:00:01.0: PME# disabled
<7>[    0.497183] pci 0000:00:02.0: [8086:0126] type 0 class 0x000300
<7>[    0.497192] pci 0000:00:02.0: reg 10: [mem 0xf1400000-0xf17fffff 64bit]
<7>[    0.497197] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
<7>[    0.497202] pci 0000:00:02.0: reg 20: [io  0x4000-0x403f]
<7>[    0.497214] pci 0000:00:02.0: rpm_resume flags 0x0
<7>[    0.497215] pci 0000:00:02.0: rpm_resume returns -11
<7>[    0.497251] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
<7>[    0.497274] pci 0000:00:16.0: reg 10: [mem 0xf1c05000-0xf1c0500f 64bit]
<7>[    0.497330] pci 0000:00:16.0: rpm_resume flags 0x0
<7>[    0.497331] pci 0000:00:16.0: rpm_resume returns -11
<7>[    0.497338] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
<7>[    0.497342] pci 0000:00:16.0: PME# disabled
<7>[    0.497373] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
<7>[    0.497394] pci 0000:00:1a.0: reg 10: [mem 0xf1c0a000-0xf1c0a3ff]
<7>[    0.497461] pci 0000:00:1a.0: rpm_resume flags 0x0
<7>[    0.497462] pci 0000:00:1a.0: rpm_resume returns -11
<7>[    0.497468] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
<7>[    0.497473] pci 0000:00:1a.0: PME# disabled
<7>[    0.497496] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
<7>[    0.497511] pci 0000:00:1b.0: reg 10: [mem 0xf1c00000-0xf1c03fff 64bit]
<7>[    0.497560] pci 0000:00:1b.0: rpm_resume flags 0x0
<7>[    0.497562] pci 0000:00:1b.0: rpm_resume returns -11
<7>[    0.497567] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
<7>[    0.497571] pci 0000:00:1b.0: PME# disabled
<7>[    0.497596] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
<7>[    0.497680] pci 0000:00:1c.0: rpm_resume flags 0x0
<7>[    0.497681] pci 0000:00:1c.0: rpm_resume returns -11
<7>[    0.497700] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
<7>[    0.497704] pci 0000:00:1c.0: PME# disabled
<7>[    0.497738] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
<7>[    0.497822] pci 0000:00:1c.1: rpm_resume flags 0x0
<7>[    0.497823] pci 0000:00:1c.1: rpm_resume returns -11
<7>[    0.497842] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
<7>[    0.497847] pci 0000:00:1c.1: PME# disabled
<7>[    0.497882] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
<7>[    0.497966] pci 0000:00:1c.3: rpm_resume flags 0x0
<7>[    0.497967] pci 0000:00:1c.3: rpm_resume returns -11
<7>[    0.497986] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
<7>[    0.497992] pci 0000:00:1c.3: PME# disabled
<7>[    0.498025] pci 0000:00:1c.4: [8086:1c18] type 1 class 0x000604
<7>[    0.498075] pci 0000:00:1c.4: rpm_resume flags 0x0
<7>[    0.498077] pci 0000:00:1c.4: rpm_resume returns -11
<7>[    0.498089] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
<7>[    0.498093] pci 0000:00:1c.4: PME# disabled
<7>[    0.498116] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
<7>[    0.498166] pci 0000:00:1c.5: rpm_resume flags 0x0
<7>[    0.498167] pci 0000:00:1c.5: rpm_resume returns -11
<7>[    0.498179] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
<7>[    0.498183] pci 0000:00:1c.5: PME# disabled
<7>[    0.498213] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
<7>[    0.498233] pci 0000:00:1d.0: reg 10: [mem 0xf1c09000-0xf1c093ff]
<7>[    0.498301] pci 0000:00:1d.0: rpm_resume flags 0x0
<7>[    0.498302] pci 0000:00:1d.0: rpm_resume returns -11
<7>[    0.498308] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
<7>[    0.498312] pci 0000:00:1d.0: PME# disabled
<7>[    0.498337] pci 0000:00:1f.0: [8086:1c4b] type 0 class 0x000601
<7>[    0.498424] pci 0000:00:1f.0: rpm_resume flags 0x0
<7>[    0.498425] pci 0000:00:1f.0: rpm_resume returns -11
<7>[    0.498452] pci 0000:00:1f.2: [8086:1c03] type 0 class 0x000106
<7>[    0.498470] pci 0000:00:1f.2: reg 10: [io  0x4088-0x408f]
<7>[    0.498478] pci 0000:00:1f.2: reg 14: [io  0x4094-0x4097]
<7>[    0.498486] pci 0000:00:1f.2: reg 18: [io  0x4080-0x4087]
<7>[    0.498494] pci 0000:00:1f.2: reg 1c: [io  0x4090-0x4093]
<7>[    0.498502] pci 0000:00:1f.2: reg 20: [io  0x4060-0x407f]
<7>[    0.498510] pci 0000:00:1f.2: reg 24: [mem 0xf1c08000-0xf1c087ff]
<7>[    0.498537] pci 0000:00:1f.2: rpm_resume flags 0x0
<7>[    0.498538] pci 0000:00:1f.2: rpm_resume returns -11
<7>[    0.498545] pci 0000:00:1f.2: PME# supported from D3hot
<7>[    0.498549] pci 0000:00:1f.2: PME# disabled
<7>[    0.498567] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
<7>[    0.498582] pci 0000:00:1f.3: reg 10: [mem 0xf1c04000-0xf1c040ff 64bit]
<7>[    0.498603] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
<7>[    0.498622] pci 0000:00:1f.3: rpm_resume flags 0x0
<7>[    0.498623] pci 0000:00:1f.3: rpm_resume returns -11
<7>[    0.498656] pci 0000:01:00.0: [10de:0df5] type 0 class 0x000300
<7>[    0.498664] pci 0000:01:00.0: reg 10: [mem 0xf0000000-0xf0ffffff]
<7>[    0.498672] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
<7>[    0.498680] pci 0000:01:00.0: reg 1c: [mem 0xd0000000-0xd1ffffff 64bit pref]
<7>[    0.498686] pci 0000:01:00.0: reg 24: [io  0x3000-0x307f]
<7>[    0.498691] pci 0000:01:00.0: reg 30: [mem 0xfff80000-0xffffffff pref]
<7>[    0.498705] pci 0000:01:00.0: rpm_resume flags 0x0
<7>[    0.498706] pci 0000:01:00.0: rpm_resume returns -11
<6>[    0.500018] pci 0000:00:01.0: PCI bridge to [bus 01-01]
<7>[    0.500158] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
<7>[    0.500161] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf10fffff]
<7>[    0.500164] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
<6>[    0.500236] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
<7>[    0.500335] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
<7>[    0.500340] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
<7>[    0.500348] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<7>[    0.500570] pci 0000:03:00.0: [8086:008a] type 0 class 0x000280
<7>[    0.500717] pci 0000:03:00.0: reg 10: [mem 0xf1b00000-0xf1b01fff 64bit]
<7>[    0.501266] pci 0000:03:00.0: rpm_resume flags 0x0
<7>[    0.501267] pci 0000:03:00.0: rpm_resume returns -11
<7>[    0.501321] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
<7>[    0.501356] pci 0000:03:00.0: PME# disabled
<6>[    0.503140] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
<7>[    0.503238] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
<7>[    0.503244] pci 0000:00:1c.1:   bridge window [mem 0xf1b00000-0xf1bfffff]
<7>[    0.503252] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<7>[    0.503396] pci 0000:04:00.0: [1033:0194] type 0 class 0x000c03
<7>[    0.503422] pci 0000:04:00.0: reg 10: [mem 0xf1a00000-0xf1a01fff 64bit]
<7>[    0.503520] pci 0000:04:00.0: rpm_resume flags 0x0
<7>[    0.503521] pci 0000:04:00.0: rpm_resume returns -11
<7>[    0.503530] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
<7>[    0.503535] pci 0000:04:00.0: PME# disabled
<6>[    0.505063] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
<7>[    0.505185] pci 0000:00:1c.3:   bridge window [io  0xf000-0x0000] (disabled)
<7>[    0.505189] pci 0000:00:1c.3:   bridge window [mem 0xf1a00000-0xf1afffff]
<7>[    0.505196] pci 0000:00:1c.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<6>[    0.505240] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
<7>[    0.505337] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
<7>[    0.505342] pci 0000:00:1c.4:   bridge window [mem 0xf1900000-0xf19fffff]
<7>[    0.505348] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
<7>[    0.505413] pci 0000:06:00.0: [10ec:8168] type 0 class 0x000200
<7>[    0.505433] pci 0000:06:00.0: reg 10: [io  0x2000-0x20ff]
<7>[    0.505467] pci 0000:06:00.0: reg 18: [mem 0xf1804000-0xf1804fff 64bit pref]
<7>[    0.505488] pci 0000:06:00.0: reg 20: [mem 0xf1800000-0xf1803fff 64bit pref]
<7>[    0.505541] pci 0000:06:00.0: rpm_resume flags 0x0
<7>[    0.505542] pci 0000:06:00.0: rpm_resume returns -11
<7>[    0.505551] pci 0000:06:00.0: supports D1 D2
<7>[    0.505553] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
<7>[    0.505558] pci 0000:06:00.0: PME# disabled
<6>[    0.507011] pci 0000:00:1c.5: PCI bridge to [bus 06-06]
<7>[    0.507150] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
<7>[    0.507154] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
<7>[    0.507160] pci 0000:00:1c.5:   bridge window [mem 0xf1800000-0xf18fffff 64bit pref]
<7>[    0.507195] pci_bus 0000:00: on NUMA node 0
<7>[    0.507197] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<7>[    0.507328] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
<7>[    0.507362] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
<7>[    0.507396] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
<7>[    0.507428] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
<7>[    0.507473] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
<7>[    0.507515] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
<7>[    0.507580] \_SB_.PCI0:_OSC invalid UUID
<7>[    0.507581] _OSC request data:1 1f 1f 
<6>[    0.507584]  pci0000:00: Requesting ACPI _OSC control (0x1d)
<7>[    0.507710] \_SB_.PCI0:_OSC invalid UUID
<7>[    0.507711] _OSC request data:1 0 1d 
<7>[    0.507886] PM: Adding info for pci:0000:00:00.0
<7>[    0.508089] PM: Adding info for pci:0000:00:01.0
<7>[    0.508284] PM: Adding info for pci:0000:00:02.0
<7>[    0.508477] PM: Adding info for pci:0000:00:16.0
<7>[    0.508669] PM: Adding info for pci:0000:00:1a.0
<7>[    0.508862] PM: Adding info for pci:0000:00:1b.0
<7>[    0.509059] PM: Adding info for pci:0000:00:1c.0
<7>[    0.509254] PM: Adding info for pci:0000:00:1c.1
<7>[    0.509452] PM: Adding info for pci:0000:00:1c.3
<7>[    0.509645] PM: Adding info for pci:0000:00:1c.4
<7>[    0.509838] PM: Adding info for pci:0000:00:1c.5
<7>[    0.510034] PM: Adding info for pci:0000:00:1d.0
<7>[    0.510228] PM: Adding info for pci:0000:00:1f.0
<7>[    0.510421] PM: Adding info for pci:0000:00:1f.2
<7>[    0.510614] PM: Adding info for pci:0000:00:1f.3
<7>[    0.510664] PM: Adding info for pci:0000:01:00.0
<7>[    0.510695] PM: Adding info for No Bus:0000:01
<7>[    0.510723] PM: Adding info for No Bus:0000:02
<7>[    0.510765] PM: Adding info for pci:0000:03:00.0
<7>[    0.510793] PM: Adding info for No Bus:0000:03
<7>[    0.510835] PM: Adding info for pci:0000:04:00.0
<7>[    0.510863] PM: Adding info for No Bus:0000:04
<7>[    0.510892] PM: Adding info for No Bus:0000:05
<7>[    0.510933] PM: Adding info for pci:0000:06:00.0
<7>[    0.510963] PM: Adding info for No Bus:0000:06
<6>[    0.511050] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
<6>[    0.511659] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 *11 12 14 15)
<6>[    0.512267] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
<6>[    0.512871] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
<6>[    0.513478] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    0.514214] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    0.514947] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 *11 12 14 15)
<6>[    0.515557] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *10 11 12 14 15)
<7>[    0.516213] PM: Adding info for No Bus:vga_arbiter
<6>[    0.516236] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
<6>[    0.516388] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
<6>[    0.516537] vgaarb: loaded
<5>[    0.516725] SCSI subsystem initialized
<7>[    0.516871] libata version 3.00 loaded.
<6>[    0.516920] usbcore: registered new interface driver usbfs
<6>[    0.517042] usbcore: registered new interface driver hub
<6>[    0.517166] usbcore: registered new device driver usb
<6>[    0.517341] PCI: Using ACPI for IRQ routing
<7>[    0.517435] PCI: pci_cache_line_size set to 64 bytes
<7>[    0.517609] reserve RAM buffer: 000000000009d800 - 000000000009ffff 
<7>[    0.517672] PM: Adding info for No Bus:lo
<7>[    0.517784] PM: Adding info for platform:regulatory.0
<6>[    0.517806] cfg80211: Calling CRDA to update world regulatory domain
<7>[    0.518102] PM: Adding info for No Bus:rfkill
<6>[    0.518130] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
<6>[    0.518580] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
<6>[    0.520688] Switching to clocksource hpet
<6>[    0.520842] pnp: PnP ACPI init
<7>[    0.520942] PM: Adding info for No Bus:pnp0
<6>[    0.520944] ACPI: bus type pnp registered
<6>[    0.520966] Switched to NOHz mode on CPU #0
<6>[    0.521001] Switched to NOHz mode on CPU #3
<6>[    0.521082] Switched to NOHz mode on CPU #2
<6>[    0.521335] Switched to NOHz mode on CPU #1
<7>[    0.521719] pnp 00:00: [bus 00-3e]
<7>[    0.521721] pnp 00:00: [io  0x0000-0x0cf7 window]
<7>[    0.521722] pnp 00:00: [io  0x0cf8-0x0cff]
<7>[    0.521724] pnp 00:00: [io  0x0d00-0xffff window]
<7>[    0.521726] pnp 00:00: [mem 0x000a0000-0x000bffff window]
<7>[    0.521727] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
<7>[    0.521729] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
<7>[    0.521730] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
<7>[    0.521732] pnp 00:00: [mem 0x000cc000-0x000cffff window]
<7>[    0.521733] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
<7>[    0.521735] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
<7>[    0.521736] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
<7>[    0.521738] pnp 00:00: [mem 0x000dc000-0x000dffff window]
<7>[    0.521739] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
<7>[    0.521741] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
<7>[    0.521742] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
<7>[    0.521744] pnp 00:00: [mem 0x000ec000-0x000effff window]
<7>[    0.521746] pnp 00:00: [mem 0x000f0000-0x000fffff window]
<7>[    0.521747] pnp 00:00: [mem 0xbfa00000-0xfeafffff window]
<7>[    0.521749] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
<7>[    0.521784] PM: Adding info for pnp:00:00
<7>[    0.521816] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
<7>[    0.521838] pnp 00:01: [io  0x0000-0x001f]
<7>[    0.521839] pnp 00:01: [io  0x0081-0x0091]
<7>[    0.521840] pnp 00:01: [io  0x0093-0x009f]
<7>[    0.521841] pnp 00:01: [io  0x00c0-0x00df]
<7>[    0.521843] pnp 00:01: [dma 4]
<7>[    0.521859] PM: Adding info for pnp:00:01
<7>[    0.521888] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
<7>[    0.521954] pnp 00:02: [mem 0xfed00000-0xfed003ff]
<7>[    0.521970] PM: Adding info for pnp:00:02
<7>[    0.522000] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
<7>[    0.522009] pnp 00:03: [io  0x00f0]
<7>[    0.522017] pnp 00:03: [irq 13]
<7>[    0.522033] PM: Adding info for pnp:00:03
<7>[    0.522060] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
<7>[    0.522069] pnp 00:04: [io  0x002e-0x002f]
<7>[    0.522070] pnp 00:04: [io  0x004e-0x004f]
<7>[    0.522071] pnp 00:04: [io  0x0061]
<7>[    0.522073] pnp 00:04: [io  0x0063]
<7>[    0.522074] pnp 00:04: [io  0x0065]
<7>[    0.522075] pnp 00:04: [io  0x0067]
<7>[    0.522076] pnp 00:04: [io  0x0068]
<7>[    0.522077] pnp 00:04: [io  0x006c]
<7>[    0.522078] pnp 00:04: [io  0x0070]
<7>[    0.522080] pnp 00:04: [io  0x0080]
<7>[    0.522081] pnp 00:04: [io  0x0092]
<7>[    0.522082] pnp 00:04: [io  0x00b2-0x00b3]
<7>[    0.522083] pnp 00:04: [io  0x0680-0x069f]
<7>[    0.522085] pnp 00:04: [io  0x1000-0x1003]
<7>[    0.522087] pnp 00:04: [io  0x1004-0x1013]
<7>[    0.522088] pnp 00:04: [io  0xffff]
<7>[    0.522089] pnp 00:04: [io  0x0400-0x0453]
<7>[    0.522091] pnp 00:04: [io  0x0458-0x047f]
<7>[    0.522092] pnp 00:04: [io  0x0500-0x057f]
<7>[    0.522093] pnp 00:04: [io  0x164e-0x164f]
<7>[    0.522126] PM: Adding info for pnp:00:04
<6>[    0.522156] system 00:04: [io  0x0680-0x069f] has been reserved
<6>[    0.522254] system 00:04: [io  0x1000-0x1003] has been reserved
<6>[    0.522351] system 00:04: [io  0x1004-0x1013] has been reserved
<6>[    0.522448] system 00:04: [io  0xffff] has been reserved
<6>[    0.522544] system 00:04: [io  0x0400-0x0453] has been reserved
<6>[    0.522641] system 00:04: [io  0x0458-0x047f] has been reserved
<6>[    0.522739] system 00:04: [io  0x0500-0x057f] has been reserved
<6>[    0.522846] system 00:04: [io  0x164e-0x164f] has been reserved
<7>[    0.522943] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    0.522951] pnp 00:05: [io  0x0070-0x0077]
<7>[    0.522957] pnp 00:05: [irq 8]
<7>[    0.522972] PM: Adding info for pnp:00:05
<7>[    0.523001] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
<7>[    0.523025] pnp 00:06: [io  0x0454-0x0457]
<7>[    0.523050] PM: Adding info for pnp:00:06
<6>[    0.523080] system 00:06: [io  0x0454-0x0457] has been reserved
<7>[    0.523178] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
<7>[    0.523212] pnp 00:07: [io  0x0060]
<7>[    0.523213] pnp 00:07: [io  0x0064]
<7>[    0.523218] pnp 00:07: [irq 1]
<7>[    0.523235] PM: Adding info for pnp:00:07
<7>[    0.523263] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
<7>[    0.523293] pnp 00:08: [irq 12]
<7>[    0.523316] PM: Adding info for pnp:00:08
<7>[    0.523344] pnp 00:08: Plug and Play ACPI device, IDs DLL04b6 PNP0f13 (active)
<7>[    0.523436] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
<7>[    0.523438] pnp 00:09: [mem 0xfed10000-0xfed17fff]
<7>[    0.523439] pnp 00:09: [mem 0xfed18000-0xfed18fff]
<7>[    0.523441] pnp 00:09: [mem 0xfed19000-0xfed19fff]
<7>[    0.523442] pnp 00:09: [mem 0xf8000000-0xfbffffff]
<7>[    0.523444] pnp 00:09: [mem 0xfed20000-0xfed3ffff]
<7>[    0.523445] pnp 00:09: [mem 0xfed90000-0xfed93fff]
<7>[    0.523446] pnp 00:09: [mem 0xfed45000-0xfed8ffff]
<7>[    0.523448] pnp 00:09: [mem 0xff000000-0xffffffff]
<7>[    0.523449] pnp 00:09: [mem 0xfee00000-0xfeefffff]
<7>[    0.523451] pnp 00:09: [mem 0xfffff000-0xffffffff]
<4>[    0.523465] pnp 00:09: disabling [mem 0xfffff000-0xffffffff] because it overlaps 0000:01:00.0 BAR 6 [mem 0xfff80000-0xffffffff pref]
<7>[    0.523637] PM: Adding info for pnp:00:09
<6>[    0.523668] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>[    0.523765] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
<6>[    0.523877] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
<6>[    0.523976] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
<6>[    0.524073] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
<6>[    0.524171] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
<6>[    0.524270] system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
<6>[    0.524368] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
<6>[    0.524466] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
<6>[    0.524565] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
<7>[    0.524665] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    0.524763] pnp 00:0a: [irq 20]
<7>[    0.524792] PM: Adding info for pnp:00:0a
<7>[    0.524829] pnp 00:0a: Plug and Play ACPI device, IDs SMO8800 (active)
<6>[    0.524952] pnp: PnP ACPI: found 11 devices
<6>[    0.525046] ACPI: ACPI bus type pnp unregistered
<7>[    0.525186] PM: Adding info for No Bus:mem
<7>[    0.525222] PM: Adding info for No Bus:kmem
<7>[    0.525258] PM: Adding info for No Bus:null
<7>[    0.525294] PM: Adding info for No Bus:port
<7>[    0.525328] PM: Adding info for No Bus:zero
<7>[    0.525365] PM: Adding info for No Bus:full
<7>[    0.525400] PM: Adding info for No Bus:random
<7>[    0.525438] PM: Adding info for No Bus:urandom
<7>[    0.525474] PM: Adding info for No Bus:kmsg
<7>[    0.525510] PM: Adding info for No Bus:oldmem
<7>[    0.525547] PM: Adding info for No Bus:tty
<7>[    0.525583] PM: Adding info for No Bus:console
<7>[    0.525620] PM: Adding info for No Bus:tty0
<7>[    0.525683] PM: Adding info for No Bus:vcs
<7>[    0.525718] PM: Adding info for No Bus:vcsa
<7>[    0.525755] PM: Adding info for No Bus:vcs1
<7>[    0.525790] PM: Adding info for No Bus:vcsa1
<7>[    0.525838] PM: Adding info for No Bus:tty1
<7>[    0.525875] PM: Adding info for No Bus:tty2
<7>[    0.525910] PM: Adding info for No Bus:tty3
<7>[    0.525946] PM: Adding info for No Bus:tty4
<7>[    0.525984] PM: Adding info for No Bus:tty5
<7>[    0.526019] PM: Adding info for No Bus:tty6
<7>[    0.526055] PM: Adding info for No Bus:tty7
<7>[    0.526090] PM: Adding info for No Bus:tty8
<7>[    0.526126] PM: Adding info for No Bus:tty9
<7>[    0.526162] PM: Adding info for No Bus:tty10
<7>[    0.526198] PM: Adding info for No Bus:tty11
<7>[    0.526236] PM: Adding info for No Bus:tty12
<7>[    0.526273] PM: Adding info for No Bus:tty13
<7>[    0.526312] PM: Adding info for No Bus:tty14
<7>[    0.526348] PM: Adding info for No Bus:tty15
<7>[    0.526383] PM: Adding info for No Bus:tty16
<7>[    0.526420] PM: Adding info for No Bus:tty17
<7>[    0.526455] PM: Adding info for No Bus:tty18
<7>[    0.526493] PM: Adding info for No Bus:tty19
<7>[    0.526528] PM: Adding info for No Bus:tty20
<7>[    0.526564] PM: Adding info for No Bus:tty21
<7>[    0.526601] PM: Adding info for No Bus:tty22
<7>[    0.526637] PM: Adding info for No Bus:tty23
<7>[    0.526674] PM: Adding info for No Bus:tty24
<7>[    0.526713] PM: Adding info for No Bus:tty25
<7>[    0.526750] PM: Adding info for No Bus:tty26
<7>[    0.526787] PM: Adding info for No Bus:tty27
<7>[    0.526834] PM: Adding info for No Bus:tty28
<7>[    0.526877] PM: Adding info for No Bus:tty29
<7>[    0.526914] PM: Adding info for No Bus:tty30
<7>[    0.526950] PM: Adding info for No Bus:tty31
<7>[    0.526987] PM: Adding info for No Bus:tty32
<7>[    0.527024] PM: Adding info for No Bus:tty33
<7>[    0.527061] PM: Adding info for No Bus:tty34
<7>[    0.527100] PM: Adding info for No Bus:tty35
<7>[    0.527137] PM: Adding info for No Bus:tty36
<7>[    0.527176] PM: Adding info for No Bus:tty37
<7>[    0.527213] PM: Adding info for No Bus:tty38
<7>[    0.527248] PM: Adding info for No Bus:tty39
<7>[    0.527286] PM: Adding info for No Bus:tty40
<7>[    0.527323] PM: Adding info for No Bus:tty41
<7>[    0.527360] PM: Adding info for No Bus:tty42
<7>[    0.527397] PM: Adding info for No Bus:tty43
<7>[    0.527433] PM: Adding info for No Bus:tty44
<7>[    0.527470] PM: Adding info for No Bus:tty45
<7>[    0.527508] PM: Adding info for No Bus:tty46
<7>[    0.527547] PM: Adding info for No Bus:tty47
<7>[    0.527584] PM: Adding info for No Bus:tty48
<7>[    0.527621] PM: Adding info for No Bus:tty49
<7>[    0.527659] PM: Adding info for No Bus:tty50
<7>[    0.527695] PM: Adding info for No Bus:tty51
<7>[    0.527733] PM: Adding info for No Bus:tty52
<7>[    0.527770] PM: Adding info for No Bus:tty53
<7>[    0.527807] PM: Adding info for No Bus:tty54
<7>[    0.527858] PM: Adding info for No Bus:tty55
<7>[    0.527896] PM: Adding info for No Bus:tty56
<7>[    0.527935] PM: Adding info for No Bus:tty57
<7>[    0.527973] PM: Adding info for No Bus:tty58
<7>[    0.528012] PM: Adding info for No Bus:tty59
<7>[    0.528050] PM: Adding info for No Bus:tty60
<7>[    0.528088] PM: Adding info for No Bus:tty61
<7>[    0.528125] PM: Adding info for No Bus:tty62
<7>[    0.528163] PM: Adding info for No Bus:tty63
<6>[    0.532793] pci 0000:01:00.0: no compatible bridge window for [mem 0xfff80000-0xffffffff pref]
<6>[    0.533001] pci 0000:01:00.0: BAR 6: assigned [mem 0xf1000000-0xf107ffff pref]
<6>[    0.533147] pci 0000:00:01.0: PCI bridge to [bus 01-01]
<6>[    0.533243] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
<6>[    0.533341] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf10fffff]
<6>[    0.533440] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
<6>[    0.533590] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
<6>[    0.533684] pci 0000:00:1c.0:   bridge window [io  disabled]
<6>[    0.533785] pci 0000:00:1c.0:   bridge window [mem disabled]
<6>[    0.533892] pci 0000:00:1c.0:   bridge window [mem pref disabled]
<6>[    0.533996] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
<6>[    0.534091] pci 0000:00:1c.1:   bridge window [io  disabled]
<6>[    0.534192] pci 0000:00:1c.1:   bridge window [mem 0xf1b00000-0xf1bfffff]
<6>[    0.534293] pci 0000:00:1c.1:   bridge window [mem pref disabled]
<6>[    0.534397] pci 0000:00:1c.3: PCI bridge to [bus 04-04]
<6>[    0.534492] pci 0000:00:1c.3:   bridge window [io  disabled]
<6>[    0.534592] pci 0000:00:1c.3:   bridge window [mem 0xf1a00000-0xf1afffff]
<6>[    0.534694] pci 0000:00:1c.3:   bridge window [mem pref disabled]
<6>[    0.534798] pci 0000:00:1c.4: PCI bridge to [bus 05-05]
<6>[    0.534898] pci 0000:00:1c.4:   bridge window [io  disabled]
<6>[    0.534998] pci 0000:00:1c.4:   bridge window [mem 0xf1900000-0xf19fffff]
<6>[    0.535097] pci 0000:00:1c.4:   bridge window [mem pref disabled]
<6>[    0.535197] pci 0000:00:1c.5: PCI bridge to [bus 06-06]
<6>[    0.535292] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
<6>[    0.535392] pci 0000:00:1c.5:   bridge window [mem disabled]
<6>[    0.535491] pci 0000:00:1c.5:   bridge window [mem 0xf1800000-0xf18fffff 64bit pref]
<6>[    0.535651] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<7>[    0.535750] pci 0000:00:01.0: setting latency timer to 64
<6>[    0.535757] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<7>[    0.535870] pci 0000:00:1c.0: setting latency timer to 64
<6>[    0.535881] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
<7>[    0.535983] pci 0000:00:1c.1: setting latency timer to 64
<6>[    0.535994] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
<7>[    0.536095] pci 0000:00:1c.3: setting latency timer to 64
<6>[    0.536102] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<7>[    0.536202] pci 0000:00:1c.4: setting latency timer to 64
<6>[    0.536208] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
<7>[    0.536308] pci 0000:00:1c.5: setting latency timer to 64
<7>[    0.536311] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
<7>[    0.536313] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
<7>[    0.536315] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
<7>[    0.536316] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xfeafffff]
<7>[    0.536318] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
<7>[    0.536320] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
<7>[    0.536321] pci_bus 0000:01: resource 1 [mem 0xf0000000-0xf10fffff]
<7>[    0.536323] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xd1ffffff 64bit pref]
<7>[    0.536325] pci_bus 0000:03: resource 1 [mem 0xf1b00000-0xf1bfffff]
<7>[    0.536326] pci_bus 0000:04: resource 1 [mem 0xf1a00000-0xf1afffff]
<7>[    0.536328] pci_bus 0000:05: resource 1 [mem 0xf1900000-0xf19fffff]
<7>[    0.536330] pci_bus 0000:06: resource 0 [io  0x2000-0x2fff]
<7>[    0.536331] pci_bus 0000:06: resource 2 [mem 0xf1800000-0xf18fffff 64bit pref]
<6>[    0.536357] NET: Registered protocol family 2
<6>[    0.536482] IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
<6>[    0.536693] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
<6>[    0.536884] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
<6>[    0.537011] TCP: Hash tables configured (established 16384 bind 16384)
<6>[    0.537110] TCP reno registered
<6>[    0.537202] UDP hash table entries: 256 (order: 1, 8192 bytes)
<6>[    0.537301] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
<6>[    0.537484] NET: Registered protocol family 1
<7>[    0.537586] pci 0000:00:02.0: Boot video device
<7>[    0.538393] PCI: CLS 64 bytes, default 64
<6>[    0.538449] IOMMU 0 0xfed90000: using Queued invalidation
<6>[    0.538545] IOMMU 1 0xfed91000: using Queued invalidation
<6>[    0.538642] IOMMU: Setting RMRR:
<6>[    0.538743] IOMMU: Setting identity map for device 0000:00:02.0 [0xbb800000 - 0xbfa00000]
<6>[    0.539241] IOMMU: Setting identity map for device 0000:00:1d.0 [0xbae1d000 - 0xbae34000]
<6>[    0.539407] IOMMU: Setting identity map for device 0000:00:1a.0 [0xbae1d000 - 0xbae34000]
<6>[    0.539564] IOMMU: Prepare 0-16MiB unity mapping for LPC
<6>[    0.539667] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0x1000000]
<6>[    0.541433] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
<7>[    0.542458] PM: Adding info for No Bus:mcelog
<7>[    0.542531] PM: Adding info for No Bus:msr0
<7>[    0.542569] PM: Adding info for No Bus:msr1
<7>[    0.542605] PM: Adding info for No Bus:msr2
<7>[    0.542641] PM: Adding info for No Bus:msr3
<7>[    0.542705] PM: Adding info for No Bus:cpu0
<7>[    0.542741] PM: Adding info for No Bus:cpu1
<7>[    0.542778] PM: Adding info for No Bus:cpu2
<7>[    0.542826] PM: Adding info for No Bus:cpu3
<7>[    0.542914] PM: Adding info for platform:pcspkr
<7>[    0.542950] PM: Adding info for platform:microcode
<6>[    0.542982] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x14
<6>[    0.543084] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x14
<6>[    0.543185] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x14
<6>[    0.543289] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x14
<7>[    0.543397] PM: Adding info for No Bus:microcode
<6>[    0.543426] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
<7>[    0.543701] PM: Adding info for No Bus:snapshot
<7>[    0.551046] PM: Adding info for event_source:cpu
<7>[    0.551081] PM: Adding info for event_source:breakpoint
<7>[    0.551116] PM: Adding info for event_source:software
<5>[    0.554002] VFS: Disk quotas dquot_6.5.2
<4>[    0.554157] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>[    0.554283] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
<6>[    0.554889] SGI XFS Quota Management subsystem
<6>[    0.554988] msgmni has been set to 668
<6>[    0.555375] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
<6>[    0.555522] io scheduler noop registered
<6>[    0.555615] io scheduler deadline registered
<6>[    0.555756] io scheduler cfq registered (default)
<7>[    0.555934] pcieport 0000:00:01.0: setting latency timer to 64
<7>[    0.555958] pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
<7>[    0.555972] PM: Adding info for pci_express:0000:00:01.0:pcie08
<6>[    0.556314] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<7>[    0.556411] intel_idle: MWAIT substates: 0x21120
<7>[    0.556412] intel_idle: v0.4 model 0x2A
<7>[    0.556413] intel_idle: lapic_timer_reliable_states 0xffffffff
<7>[    0.557610] PM: Adding info for No Bus:ptmx
<7>[    0.557668] PM: Adding info for No Bus:hpet
<7>[    0.557817] PM: Adding info for No Bus:nvram
<6>[    0.557847] Non-volatile memory driver v1.3
<7>[    0.558027] PM: Adding info for No Bus:7:0
<7>[    0.558073] PM: Adding info for No Bus:loop0
<7>[    0.558121] PM: Adding info for No Bus:7:1
<7>[    0.558158] PM: Adding info for No Bus:loop1
<7>[    0.558204] PM: Adding info for No Bus:7:2
<7>[    0.558239] PM: Adding info for No Bus:loop2
<7>[    0.558284] PM: Adding info for No Bus:7:3
<7>[    0.558320] PM: Adding info for No Bus:loop3
<7>[    0.558366] PM: Adding info for No Bus:7:4
<7>[    0.558402] PM: Adding info for No Bus:loop4
<7>[    0.558447] PM: Adding info for No Bus:7:5
<7>[    0.558485] PM: Adding info for No Bus:loop5
<7>[    0.558530] PM: Adding info for No Bus:7:6
<7>[    0.558566] PM: Adding info for No Bus:loop6
<7>[    0.558612] PM: Adding info for No Bus:7:7
<7>[    0.558648] PM: Adding info for No Bus:loop7
<6>[    0.558685] loop: module loaded
<7>[    0.558861] ahci 0000:00:1f.2: version 3.0
<6>[    0.558870] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
<7>[    0.558998] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
<6>[    0.559022] ahci: SSS flag set, parallel bus scan disabled
<6>[    0.569785] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x13 impl SATA mode
<6>[    0.569967] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
<7>[    0.570118] ahci 0000:00:1f.2: setting latency timer to 64
<7>[    0.573819] PM: Adding info for No Bus:ata1
<7>[    0.573851] PM: Adding info for No Bus:ata1
<7>[    0.573901] PM: Adding info for No Bus:link1
<7>[    0.573911] PM: Adding info for No Bus:link1
<7>[    0.573947] PM: Adding info for No Bus:dev1.0
<7>[    0.573957] PM: Adding info for No Bus:dev1.0
<7>[    0.573994] PM: Adding info for No Bus:ata2
<7>[    0.574004] PM: Adding info for No Bus:ata2
<7>[    0.574038] PM: Adding info for No Bus:link2
<7>[    0.574047] PM: Adding info for No Bus:link2
<7>[    0.574084] PM: Adding info for No Bus:dev2.0
<7>[    0.574093] PM: Adding info for No Bus:dev2.0
<7>[    0.574130] PM: Adding info for No Bus:ata3
<7>[    0.574139] PM: Adding info for No Bus:ata3
<7>[    0.574173] PM: Adding info for No Bus:link3
<7>[    0.574183] PM: Adding info for No Bus:link3
<7>[    0.574218] PM: Adding info for No Bus:dev3.0
<7>[    0.574227] PM: Adding info for No Bus:dev3.0
<7>[    0.574269] PM: Adding info for No Bus:ata4
<7>[    0.574278] PM: Adding info for No Bus:ata4
<7>[    0.574313] PM: Adding info for No Bus:link4
<7>[    0.574322] PM: Adding info for No Bus:link4
<7>[    0.574357] PM: Adding info for No Bus:dev4.0
<7>[    0.574366] PM: Adding info for No Bus:dev4.0
<7>[    0.574402] PM: Adding info for No Bus:ata5
<7>[    0.574412] PM: Adding info for No Bus:ata5
<7>[    0.574446] PM: Adding info for No Bus:link5
<7>[    0.574455] PM: Adding info for No Bus:link5
<7>[    0.574490] PM: Adding info for No Bus:dev5.0
<7>[    0.574499] PM: Adding info for No Bus:dev5.0
<7>[    0.574536] PM: Adding info for No Bus:ata6
<7>[    0.574545] PM: Adding info for No Bus:ata6
<7>[    0.574579] PM: Adding info for No Bus:link6
<7>[    0.574589] PM: Adding info for No Bus:link6
<7>[    0.574624] PM: Adding info for No Bus:dev6.0
<7>[    0.574634] PM: Adding info for No Bus:dev6.0
<6>[    0.574679] scsi0 : ahci
<7>[    0.574803] PM: Adding info for scsi:host0
<7>[    0.574845] PM: Adding info for No Bus:host0
<6>[    0.574891] scsi1 : ahci
<7>[    0.574990] PM: Adding info for scsi:host1
<7>[    0.575030] PM: Adding info for No Bus:host1
<6>[    0.575076] scsi2 : ahci
<7>[    0.575174] PM: Adding info for scsi:host2
<7>[    0.575214] PM: Adding info for No Bus:host2
<6>[    0.575259] scsi3 : ahci
<7>[    0.575358] PM: Adding info for scsi:host3
<7>[    0.575397] PM: Adding info for No Bus:host3
<6>[    0.575442] scsi4 : ahci
<7>[    0.575542] PM: Adding info for scsi:host4
<7>[    0.575582] PM: Adding info for No Bus:host4
<6>[    0.575626] scsi5 : ahci
<7>[    0.575737] PM: Adding info for scsi:host5
<7>[    0.575778] PM: Adding info for No Bus:host5
<6>[    0.575849] ata1: SATA max UDMA/133 abar m2048@0xf1c08000 port 0xf1c08100 irq 43
<6>[    0.575996] ata2: SATA max UDMA/133 abar m2048@0xf1c08000 port 0xf1c08180 irq 43
<6>[    0.576143] ata3: DUMMY
<6>[    0.576233] ata4: DUMMY
<6>[    0.576325] ata5: SATA max UDMA/133 abar m2048@0xf1c08000 port 0xf1c08300 irq 43
<6>[    0.576471] ata6: DUMMY
<7>[    0.576572] scsi host0: rpm_resume flags 0x4
<7>[    0.576574] scsi host0: rpm_resume returns 1
<5>[    0.576707] usbmon: debugfs is not available
<6>[    0.576815] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<7>[    0.576913] ohci_hcd: block sizes: ed 80 td 96
<6>[    0.576978] usbcore: registered new interface driver libusual
<6>[    0.577155] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
<7>[    0.577322] PM: Adding info for platform:i8042
<6>[    0.581696] serio: i8042 KBD port at 0x60,0x64 irq 1
<6>[    0.581805] serio: i8042 AUX port at 0x60,0x64 irq 12
<7>[    0.581912] PM: Adding info for serio:serio0
<7>[    0.581956] PM: Adding info for serio:serio1
<7>[    0.581984] PM: Adding info for No Bus:mice
<6>[    0.582018] mousedev: PS/2 mouse device common for all mice
<6>[    0.582161] rtc_cmos 00:05: RTC can wake from S4
<7>[    0.588626] PM: Adding info for No Bus:input0
<6>[    0.588715] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
<7>[    0.589796] PM: Adding info for No Bus:rtc0
<6>[    0.589856] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
<6>[    0.589977] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
<6>[    0.590658] cpuidle: using governor ladder
<6>[    0.591857] cpuidle: using governor menu
<6>[    0.592492] usbcore: registered new interface driver usbhid
<6>[    0.592587] usbhid: USB HID core driver
<6>[    0.592723] Netfilter messages via NETLINK v0.30.
<6>[    0.592827] nf_conntrack version 0.5.0 (2675 buckets, 10700 max)
<6>[    0.593055] ctnetlink v0.93: registering with nfnetlink.
<6>[    0.593367] ip_tables: (C) 2000-2006 Netfilter Core Team
<6>[    0.593495] TCP cubic registered
<6>[    0.593597] Initializing XFRM netlink socket
<6>[    0.594028] NET: Registered protocol family 10
<6>[    0.594608] ip6_tables: (C) 2000-2006 Netfilter Core Team
<6>[    0.594756] IPv6 over IPv4 tunneling driver
<7>[    0.594891] PM: Adding info for No Bus:sit0
<6>[    0.595286] NET: Registered protocol family 17
<5>[    0.595383] Registering the dns_resolver key type
<7>[    0.595504] PM: Adding info for No Bus:cpu_dma_latency
<7>[    0.595547] PM: Adding info for No Bus:network_latency
<7>[    0.595590] PM: Adding info for No Bus:network_throughput
<7>[    0.595623] PM: Hibernation image not present or could not be loaded.
<4>[    0.595627] registered taskstats version 1
<4>[    0.596038]   Magic number: 11:620:740
<6>[    0.880245] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
<6>[    0.882300] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
<6>[    0.882868] ata1.00: ATA-8: ST9500420AS, D005SDM1, max UDMA/133
<6>[    0.883001] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
<6>[    0.885439] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
<6>[    0.886005] ata1.00: configured for UDMA/133
<7>[    0.887209] scsi host0: rpm_suspend flags 0x0
<7>[    0.887221] scsi host0: rpm_suspend returns 0
<7>[    0.887231] scsi target0:0:0: rpm_resume flags 0x4
<7>[    0.887240] scsi target0:0:0: rpm_resume returns -11
<7>[    0.887247] scsi host0: rpm_resume flags 0x4
<7>[    0.887254] ahci 0000:00:1f.2: rpm_resume flags 0x0
<7>[    0.887258] ahci 0000:00:1f.2: rpm_resume returns 1
<7>[    0.887264] scsi host0: rpm_resume returns 0
<5>[    0.887364] scsi 0:0:0:0: Direct-Access     ATA      ST9500420AS      D005 PQ: 0 ANSI: 5
<7>[    0.887528] PM: Adding info for scsi:target0:0:0
<7>[    0.887651] scsi target0:0:0: rpm_resume flags 0x4
<7>[    0.887653] scsi target0:0:0: rpm_resume returns 1
<7>[    0.887655] scsi 0:0:0:0: rpm_resume flags 0x0
<7>[    0.887657] scsi 0:0:0:0: rpm_resume returns -11
<7>[    0.887658] scsi 0:0:0:0: rpm_resume flags 0x4
<7>[    0.887659] scsi 0:0:0:0: rpm_resume returns 1
<7>[    0.887677] PM: Adding info for scsi:0:0:0:0
<7>[    0.887747] PM: Adding info for No Bus:0:0:0:0
<7>[    0.887794] PM: Adding info for No Bus:0:0:0:0
<5>[    0.887822] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
<7>[    0.887886] PM: Adding info for No Bus:0:0:0:0
<7>[    0.887943] scsi host1: rpm_resume flags 0x4
<7>[    0.887944] scsi host1: rpm_resume returns 1
<5>[    0.888034] sd 0:0:0:0: [sda] Write Protect is off
<7>[    0.888130] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>[    0.888161] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<7>[    0.888328] PM: Adding info for No Bus:8:0
<7>[    0.888422] PM: Adding info for No Bus:sda
<7>[    0.888437] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    0.888438] sd 0:0:0:0: rpm_resume returns 1
<6>[    0.934041]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
<7>[    0.934192] PM: Adding info for No Bus:sda1
<7>[    0.934210] PM: Adding info for No Bus:sda2
<7>[    0.934232] PM: Adding info for No Bus:sda3
<7>[    0.934248] PM: Adding info for No Bus:sda4
<7>[    0.934263] PM: Adding info for No Bus:sda5
<7>[    0.934278] PM: Adding info for No Bus:sda6
<5>[    0.934810] sd 0:0:0:0: [sda] Attached SCSI disk
<6>[    1.191661] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
<6>[    1.193652] ata2.00: ATAPI: Optiarc DVD+/-RW AD-7717H, 102A, max UDMA/100
<6>[    1.195999] ata2.00: configured for UDMA/100
<7>[    1.196690] scsi host1: rpm_suspend flags 0x0
<7>[    1.196699] scsi host1: rpm_suspend returns 0
<7>[    1.196783] scsi target1:0:0: rpm_resume flags 0x4
<7>[    1.196786] scsi target1:0:0: rpm_resume returns -11
<7>[    1.196788] scsi host1: rpm_resume flags 0x4
<7>[    1.196789] ahci 0000:00:1f.2: rpm_resume flags 0x0
<7>[    1.196791] ahci 0000:00:1f.2: rpm_resume returns 1
<7>[    1.196793] scsi host1: rpm_resume returns 0
<5>[    1.198434] scsi 1:0:0:0: CD-ROM            Optiarc  DVD+-RW AD-7717H 102A PQ: 0 ANSI: 5
<7>[    1.198634] PM: Adding info for scsi:target1:0:0
<7>[    1.198729] scsi target1:0:0: rpm_resume flags 0x4
<7>[    1.198730] scsi target1:0:0: rpm_resume returns 1
<7>[    1.198732] scsi 1:0:0:0: rpm_resume flags 0x0
<7>[    1.198733] scsi 1:0:0:0: rpm_resume returns -11
<7>[    1.198735] scsi 1:0:0:0: rpm_resume flags 0x4
<7>[    1.198736] scsi 1:0:0:0: rpm_resume returns 1
<7>[    1.198751] PM: Adding info for scsi:1:0:0:0
<7>[    1.198830] PM: Adding info for No Bus:1:0:0:0
<7>[    1.198913] PM: Adding info for No Bus:1:0:0:0
<7>[    1.198995] scsi host2: rpm_resume flags 0x4
<7>[    1.198997] scsi host2: rpm_resume returns 1
<7>[    1.199001] scsi host2: rpm_suspend flags 0x0
<7>[    1.199003] scsi host2: rpm_suspend returns 0
<7>[    1.199029] scsi host3: rpm_resume flags 0x4
<7>[    1.199031] scsi host3: rpm_resume returns 1
<7>[    1.199037] scsi host3: rpm_suspend flags 0x0
<7>[    1.199039] scsi host3: rpm_suspend returns 0
<7>[    1.199053] scsi host4: rpm_resume flags 0x4
<7>[    1.199055] scsi host4: rpm_resume returns 1
<6>[    1.503072] ata5: SATA link down (SStatus 0 SControl 300)
<7>[    1.503208] scsi host4: rpm_suspend flags 0x0
<7>[    1.503210] scsi host4: rpm_suspend returns 0
<7>[    1.503288] scsi host5: rpm_resume flags 0x4
<7>[    1.503291] scsi host5: rpm_resume returns 1
<7>[    1.503297] scsi host5: rpm_suspend flags 0x0
<7>[    1.503299] scsi host5: rpm_suspend returns 0
<7>[    1.503354] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    1.503357] sd 0:0:0:0: rpm_resume returns 1
<6>[    1.540998] Refined TSC clocksource calibration: 2594.106 MHz.
<6>[    1.541124] Switching to clocksource tsc
<5>[    1.558966] XFS mounting filesystem sda6
<7>[    1.655034] Ending clean XFS mount for filesystem: sda6
<4>[    1.655148] VFS: Mounted root (xfs filesystem) readonly on device 8:6.
<6>[    1.656115] Freeing unused kernel memory: 428k freed
<6>[    1.656277] Write protecting the kernel read-only data: 6144k
<6>[    1.658176] Freeing unused kernel memory: 580k freed
<6>[    1.660869] Freeing unused kernel memory: 864k freed
<4>[    3.911032] <30>udevd[3937]: starting version 168
<7>[    4.233458] PM: Adding info for No Bus:BAT0
<4>[    4.240605] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
<6>[    4.240613] ACPI: Battery Slot [BAT0] (battery present)
<7>[    4.240666] PM: Adding info for No Bus:input1
<6>[    4.240691] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
<6>[    4.240696] ACPI: Power Button [PWRB]
<7>[    4.240732] PM: Adding info for No Bus:input2
<6>[    4.240753] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
<6>[    4.240757] ACPI: Sleep Button [SLPB]
<7>[    4.240793] PM: Adding info for No Bus:input3
<6>[    4.240813] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input3
<6>[    4.251863] ACPI: Lid Switch [LID0]
<7>[    4.251967] PM: Adding info for No Bus:input4
<6>[    4.251989] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
<6>[    4.251994] ACPI: Power Button [PWRF]
<4>[    4.351713] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
<7>[    4.351769] PM: Adding info for No Bus:ADP0
<6>[    4.451560] ACPI: AC Adapter [ADP0] (on-line)
<6>[    4.536700] xhci_hcd 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
<7>[    4.536720] xhci_hcd 0000:04:00.0: setting latency timer to 64
<6>[    4.536724] xhci_hcd 0000:04:00.0: xHCI Host Controller
<7>[    4.536739] drivers/usb/core/inode.c: creating file 'devices'
<7>[    4.536743] drivers/usb/core/inode.c: creating file '001'
<6>[    4.536746] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 1
<7>[    4.541484] xhci_hcd 0000:04:00.0: supports USB remote wakeup
<6>[    4.541500] xhci_hcd 0000:04:00.0: irq 19, io mem 0xf1a00000
<7>[    4.541562] xhci_hcd 0000:04:00.0: irq 44 for MSI/MSI-X
<7>[    4.541567] xhci_hcd 0000:04:00.0: irq 45 for MSI/MSI-X
<7>[    4.541571] xhci_hcd 0000:04:00.0: irq 46 for MSI/MSI-X
<7>[    4.541576] xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
<7>[    4.541580] xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
<4>[    4.544869] usb usb1: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
<7>[    4.544873] usb usb1: default language 0x0409
<7>[    4.544878] usb usb1: udev 1, busnum 1, minor = 0
<6>[    4.544880] usb usb1: New USB device found, idVendor=1d6b, idProduct=0003
<6>[    4.544882] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    4.544883] usb usb1: Product: xHCI Host Controller
<6>[    4.544885] usb usb1: Manufacturer: Linux 2.6.38.6-dbg xhci_hcd
<6>[    4.544893] usb usb1: SerialNumber: 0000:04:00.0
<7>[    4.544927] PM: Adding info for usb:usb1
<7>[    4.544943] usb usb1: usb_probe_device
<7>[    4.544945] usb usb1: configuration #1 chosen from 1 choice
<7>[    4.544948] xHCI xhci_add_endpoint called for root hub
<7>[    4.544949] xHCI xhci_check_bandwidth called for root hub
<7>[    4.544953] usb usb1: adding 1-0:1.0 (config #1, interface 0)
<7>[    4.544964] PM: Adding info for usb:1-0:1.0
<7>[    4.544976] hub 1-0:1.0: usb_probe_interface
<7>[    4.544977] hub 1-0:1.0: usb_probe_interface - got id
<6>[    4.544979] hub 1-0:1.0: USB hub found
<6>[    4.544982] hub 1-0:1.0: 4 ports detected
<7>[    4.544983] hub 1-0:1.0: standalone hub
<7>[    4.544984] hub 1-0:1.0: individual port power switching
<7>[    4.544985] hub 1-0:1.0: individual port over-current protection
<7>[    4.544987] hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
<7>[    4.544989] hub 1-0:1.0: power on to power good time: 20ms
<7>[    4.544992] hub 1-0:1.0: local power source is good
<7>[    4.544993] hub 1-0:1.0: enabling power on all ports
<7>[    4.545023] hub 1-0:1.0: rpm_suspend flags 0x4
<7>[    4.545025] hub 1-0:1.0: rpm_suspend returns 0
<7>[    4.545038] PM: Adding info for No Bus:ep_81
<7>[    4.545040] drivers/usb/core/inode.c: creating file '001'
<7>[    4.545053] PM: Adding info for No Bus:ep_00
<7>[    4.545055] usb usb1: rpm_suspend flags 0xc
<7>[    4.545057] usb usb1: rpm_suspend returns -38
<6>[    4.575527] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
<4>[    4.575532] ACPI: resource 0000:00:1f.3 [io  0xefa0-0xefbf] conflicts with ACPI region SMBI [io 0xefa0-0xefaf]
<6>[    4.575534] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<7>[    4.581055] PM: Adding info for No Bus:event0
<7>[    4.581090] PM: Adding info for No Bus:event1
<7>[    4.581204] PM: Adding info for No Bus:event2
<7>[    4.581236] PM: Adding info for No Bus:event3
<7>[    4.581263] PM: Adding info for No Bus:event4
<7>[    4.644224] hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0000
<7>[    4.685419] PM: Adding info for No Bus:thermal_zone0
<6>[    4.685482] thermal LNXTHERM:00: registered as thermal_zone0
<6>[    4.685485] ACPI: Thermal Zone [TZ00] (65 C)
<7>[    4.685639] PM: Adding info for No Bus:thermal_zone1
<6>[    4.685701] thermal LNXTHERM:01: registered as thermal_zone1
<6>[    4.685703] ACPI: Thermal Zone [TZ01] (65 C)
<7>[    4.687407] ACPI: acpi_idle yielding to intel_idle
<7>[    4.687755] PM: Adding info for No Bus:cooling_device0
<7>[    4.691165] PM: Adding info for No Bus:cooling_device1
<7>[    4.693210] PM: Adding info for No Bus:cooling_device2
<7>[    4.693673] PM: Adding info for No Bus:cooling_device3
<6>[    4.803073] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
<6>[    4.803095] r8169 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
<7>[    4.803135] r8169 0000:06:00.0: setting latency timer to 64
<5>[    4.803141] r8169 0000:06:00.0: (unregistered net_device): unknown MAC, using family default
<7>[    4.803204] r8169 0000:06:00.0: irq 49 for MSI/MSI-X
<7>[    4.803261] PM: Adding info for No Bus:eth0
<6>[    4.803579] r8169 0000:06:00.0: eth0: RTL8168b/8111b at 0xffffc9000003c000, 14:fe:b5:ac:11:58, XID 0c200000 IRQ 49
<7>[    4.870333] PM: Adding info for No Bus:8D9DDCBC-A997-11DA-B012-B622A1EF5492
<7>[    4.870365] PM: Adding info for No Bus:A80593CE-A997-11DA-B012-B622A1EF5492
<7>[    4.870395] PM: Adding info for No Bus:DD8C7670-1CB5-11DB-A98B-669A0C200008
<7>[    4.870421] PM: Adding info for No Bus:9DBB5994-A997-11DA-B012-B622A1EF5492
<7>[    4.870439] PM: Adding info for No Bus:A3776CE0-1E88-11DB-A98B-0800200C9A66
<7>[    4.870459] PM: Adding info for No Bus:05901221-D566-11D1-B2F0-00A0C9062910
<6>[    4.870497] wmi: Mapper loaded
<7>[    5.038063] PM: Adding info for No Bus:input5
<6>[    5.038088] input: Dell WMI hotkeys as /devices/virtual/input/input5
<7>[    5.038110] PM: Adding info for No Bus:event5
<7>[    5.113716] PM: Adding info for No Bus:timer
<6>[    5.200001] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<4>[    5.200004] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
<7>[    5.200006] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
<6>[    5.200032] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
<7>[    5.200049] ehci_hcd 0000:00:1a.0: setting latency timer to 64
<6>[    5.200053] ehci_hcd 0000:00:1a.0: EHCI Host Controller
<7>[    5.200059] drivers/usb/core/inode.c: creating file '002'
<6>[    5.200065] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
<7>[    5.204044] ehci_hcd 0000:00:1a.0: reset hcs_params 0x200002 dbg=2 cc=0 pcc=0 ordered !ppc ports=2
<7>[    5.204056] ehci_hcd 0000:00:1a.0: reset hcc_params 36881 caching frame 1024 64 bit addr
<7>[    5.204161] ehci_hcd 0000:00:1a.0: support lpm
<6>[    5.204171] ehci_hcd 0000:00:1a.0: debug port 2
<7>[    5.204176] ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
<7>[    5.208054] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
<7>[    5.208056] ehci_hcd 0000:00:1a.0: supports USB remote wakeup
<6>[    5.208072] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf1c0a000
<7>[    5.208077] ehci_hcd 0000:00:1a.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
<7>[    5.211069] PM: Adding info for No Bus:sg0
<5>[    5.211082] sd 0:0:0:0: Attached scsi generic sg0 type 0
<7>[    5.211104] PM: Adding info for No Bus:sg1
<5>[    5.211116] scsi 1:0:0:0: Attached scsi generic sg1 type 5
<7>[    5.211951] ehci_hcd 0000:00:1a.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
<6>[    5.217019] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
<7>[    5.217069] usb usb2: default language 0x0409
<7>[    5.217085] usb usb2: udev 1, busnum 2, minor = 128
<6>[    5.217090] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    5.217096] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    5.217101] usb usb2: Product: EHCI Host Controller
<6>[    5.217106] usb usb2: Manufacturer: Linux 2.6.38.6-dbg ehci_hcd
<6>[    5.217110] usb usb2: SerialNumber: 0000:00:1a.0
<7>[    5.217161] PM: Adding info for usb:usb2
<7>[    5.217179] usb usb2: usb_probe_device
<7>[    5.217183] usb usb2: configuration #1 chosen from 1 choice
<7>[    5.217191] usb usb2: adding 2-0:1.0 (config #1, interface 0)
<7>[    5.217206] PM: Adding info for usb:2-0:1.0
<7>[    5.217224] hub 2-0:1.0: usb_probe_interface
<7>[    5.217226] hub 2-0:1.0: usb_probe_interface - got id
<6>[    5.217229] hub 2-0:1.0: USB hub found
<6>[    5.217234] hub 2-0:1.0: 2 ports detected
<7>[    5.217236] hub 2-0:1.0: standalone hub
<7>[    5.217237] hub 2-0:1.0: no power switching (usb 1.0)
<7>[    5.217239] hub 2-0:1.0: individual port over-current protection
<7>[    5.217242] hub 2-0:1.0: power on to power good time: 20ms
<7>[    5.217246] hub 2-0:1.0: local power source is good
<7>[    5.217248] hub 2-0:1.0: trying to enable port power on non-switchable hub
<7>[    5.217257] hub 2-0:1.0: rpm_suspend flags 0x4
<7>[    5.217259] hub 2-0:1.0: rpm_suspend returns 0
<7>[    5.217272] PM: Adding info for No Bus:ep_81
<7>[    5.217274] drivers/usb/core/inode.c: creating file '001'
<7>[    5.217293] PM: Adding info for No Bus:ep_00
<7>[    5.217295] usb usb2: rpm_suspend flags 0xc
<7>[    5.217297] usb usb2: rpm_suspend returns -38
<6>[    5.217335] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
<7>[    5.217355] ehci_hcd 0000:00:1d.0: setting latency timer to 64
<6>[    5.217358] ehci_hcd 0000:00:1d.0: EHCI Host Controller
<7>[    5.217363] drivers/usb/core/inode.c: creating file '003'
<6>[    5.217366] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
<7>[    5.223995] ehci_hcd 0000:00:1d.0: reset hcs_params 0x200002 dbg=2 cc=0 pcc=0 ordered !ppc ports=2
<7>[    5.223999] ehci_hcd 0000:00:1d.0: reset hcc_params 36881 caching frame 1024 64 bit addr
<7>[    5.224032] ehci_hcd 0000:00:1d.0: support lpm
<6>[    5.224043] ehci_hcd 0000:00:1d.0: debug port 2
<7>[    5.224047] ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
<7>[    5.227914] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
<7>[    5.227916] ehci_hcd 0000:00:1d.0: supports USB remote wakeup
<6>[    5.227936] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf1c09000
<7>[    5.227941] ehci_hcd 0000:00:1d.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
<7>[    5.231810] ehci_hcd 0000:00:1d.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
<6>[    5.236980] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
<7>[    5.237017] usb usb3: default language 0x0409
<7>[    5.237032] usb usb3: udev 1, busnum 3, minor = 256
<6>[    5.237037] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    5.237043] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    5.237049] usb usb3: Product: EHCI Host Controller
<6>[    5.237053] usb usb3: Manufacturer: Linux 2.6.38.6-dbg ehci_hcd
<6>[    5.237057] usb usb3: SerialNumber: 0000:00:1d.0
<7>[    5.237114] PM: Adding info for usb:usb3
<7>[    5.237133] usb usb3: usb_probe_device
<7>[    5.237136] usb usb3: configuration #1 chosen from 1 choice
<7>[    5.237144] usb usb3: adding 3-0:1.0 (config #1, interface 0)
<7>[    5.237157] PM: Adding info for usb:3-0:1.0
<7>[    5.237175] hub 3-0:1.0: usb_probe_interface
<7>[    5.237177] hub 3-0:1.0: usb_probe_interface - got id
<6>[    5.237179] hub 3-0:1.0: USB hub found
<6>[    5.237184] hub 3-0:1.0: 2 ports detected
<7>[    5.237186] hub 3-0:1.0: standalone hub
<7>[    5.237188] hub 3-0:1.0: no power switching (usb 1.0)
<7>[    5.237190] hub 3-0:1.0: individual port over-current protection
<7>[    5.237192] hub 3-0:1.0: power on to power good time: 20ms
<7>[    5.237196] hub 3-0:1.0: local power source is good
<7>[    5.237198] hub 3-0:1.0: trying to enable port power on non-switchable hub
<7>[    5.237207] hub 3-0:1.0: rpm_suspend flags 0x4
<7>[    5.237209] hub 3-0:1.0: rpm_suspend returns 0
<7>[    5.237223] PM: Adding info for No Bus:ep_81
<7>[    5.237225] drivers/usb/core/inode.c: creating file '001'
<7>[    5.237239] PM: Adding info for No Bus:ep_00
<7>[    5.237241] usb usb3: rpm_suspend flags 0xc
<7>[    5.237242] usb usb3: rpm_suspend returns -38
<7>[    5.282160] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    5.282163] sd 0:0:0:0: rpm_resume returns 1
<7>[    5.312074] scsi host1: rpm_resume flags 0x4
<7>[    5.312082] scsi host1: rpm_resume returns 1
<4>[    5.314069] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
<6>[    5.314076] cdrom: Uniform CD-ROM driver Revision: 3.20
<7>[    5.314129] PM: Adding info for No Bus:11:0
<7>[    5.314194] PM: Adding info for No Bus:sr0
<7>[    5.314242] sr 1:0:0:0: Attached scsi CD-ROM sr0
<7>[    5.316827] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
<7>[    5.316832] hub 2-0:1.0: port 1: status 0501 change 0001
<7>[    5.336813] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
<7>[    5.336826] hub 3-0:1.0: port 1: status 0501 change 0001
<7>[    5.378724] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    5.378727] sd 0:0:0:0: rpm_resume returns 1
<7>[    5.378791] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    5.378793] sd 0:0:0:0: rpm_resume returns 1
<7>[    5.380133] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    5.380136] sd 0:0:0:0: rpm_resume returns 1
<6>[    5.383951] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
<7>[    5.384007] HDA Intel 0000:00:1b.0: irq 50 for MSI/MSI-X
<7>[    5.384033] HDA Intel 0000:00:1b.0: setting latency timer to 64
<7>[    5.417656] hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
<7>[    5.417678] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
<7>[    5.468743] ehci_hcd 0000:00:1a.0: port 1 high speed
<7>[    5.468748] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
<6>[    5.519484] usb 2-1: new high speed USB device using ehci_hcd and address 2
<7>[    5.529202] scsi host1: rpm_resume flags 0x4
<7>[    5.529210] scsi host1: rpm_resume returns 1
<7>[    5.530747] scsi host1: rpm_resume flags 0x4
<7>[    5.530752] scsi host1: rpm_resume returns 1
<7>[    5.532297] scsi host1: rpm_resume flags 0x4
<7>[    5.532302] scsi host1: rpm_resume returns 1
<7>[    5.545118] scsi host1: rpm_resume flags 0x4
<7>[    5.545125] scsi host1: rpm_resume returns 1
<7>[    5.554042] scsi host1: rpm_resume flags 0x4
<7>[    5.554044] scsi host1: rpm_resume returns 1
<7>[    5.555445] scsi host1: rpm_resume flags 0x4
<7>[    5.555450] scsi host1: rpm_resume returns 1
<7>[    5.569032] scsi host1: rpm_resume flags 0x4
<7>[    5.569039] scsi host1: rpm_resume returns 1
<7>[    5.570551] ehci_hcd 0000:00:1a.0: port 1 high speed
<7>[    5.570555] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
<7>[    5.633329] ehci_hcd 0000:00:1a.0: set dev address 2 for port 1
<7>[    5.633340] ehci_hcd 0000:00:1a.0: LPM: no device attached
<7>[    5.633574] usb 2-1: udev 2, busnum 2, minor = 129
<6>[    5.633581] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
<6>[    5.633587] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<7>[    5.633671] PM: Adding info for usb:2-1
<7>[    5.633691] usb 2-1: usb_probe_device
<7>[    5.633695] usb 2-1: configuration #1 chosen from 1 choice
<7>[    5.633817] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
<7>[    5.633836] PM: Adding info for usb:2-1:1.0
<7>[    5.633856] hub 2-1:1.0: usb_probe_interface
<7>[    5.633859] hub 2-1:1.0: usb_probe_interface - got id
<6>[    5.633861] hub 2-1:1.0: USB hub found
<6>[    5.633939] hub 2-1:1.0: 6 ports detected
<7>[    5.633941] hub 2-1:1.0: standalone hub
<7>[    5.633943] hub 2-1:1.0: individual port power switching
<7>[    5.633944] hub 2-1:1.0: individual port over-current protection
<7>[    5.633946] hub 2-1:1.0: Single TT
<7>[    5.633948] hub 2-1:1.0: TT requires at most 8 FS bit times (666 ns)
<7>[    5.633950] hub 2-1:1.0: power on to power good time: 100ms
<7>[    5.634190] hub 2-1:1.0: local power source is good
<7>[    5.634193] hub 2-1:1.0: enabling power on all ports
<7>[    5.634938] hub 2-1:1.0: rpm_suspend flags 0x4
<7>[    5.634942] hub 2-1:1.0: rpm_suspend returns 0
<7>[    5.634965] PM: Adding info for No Bus:ep_81
<7>[    5.634968] drivers/usb/core/inode.c: creating file '002'
<7>[    5.634992] PM: Adding info for No Bus:ep_00
<7>[    5.634995] usb 2-1: rpm_suspend flags 0xc
<7>[    5.634998] usb 2-1: rpm_suspend returns -38
<7>[    5.635001] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
<7>[    5.635009] hub 3-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
<7>[    5.685339] ehci_hcd 0000:00:1d.0: port 1 high speed
<7>[    5.685347] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
<6>[    5.693339] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
<6>[    5.693342] iwlagn: Copyright(c) 2003-2010 Intel Corporation
<6>[    5.693429] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
<7>[    5.693468] iwlagn 0000:03:00.0: setting latency timer to 64
<6>[    5.693543] iwlagn 0000:03:00.0: Detected Intel(R) Centrino(R) Wireless-N 1030 BGN, REV=0xB0
<6>[    5.710898] iwlagn 0000:03:00.0: device EEPROM VER=0x716, CALIB=0x6
<6>[    5.710899] iwlagn 0000:03:00.0: Device SKU: 0X9
<6>[    5.710901] iwlagn 0000:03:00.0: Valid Tx ant: 0X1, Valid Rx ant: 0X3
<6>[    5.710919] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 0 802.11a channels
<7>[    5.711220] iwlagn 0000:03:00.0: irq 51 for MSI/MSI-X
<7>[    5.711549] PM: Adding info for No Bus:0000:03:00.0
<6>[    5.725337] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04773/0xa40000/0x8a0400
<7>[    5.734509] hub 2-1:1.0: port 4: status 0101 change 0001
<6>[    5.736046] usb 3-1: new high speed USB device using ehci_hcd and address 2
<7>[    5.765425] PM: Removing info for No Bus:0000:03:00.0
<6>[    5.765456] iwlagn 0000:03:00.0: loaded firmware version 17.168.5.2 build 35905
<7>[    5.766002] PM: Adding info for No Bus:phy0
<7>[    5.766033] PM: Adding info for No Bus:rfkill0
<7>[    5.767410] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
<7>[    5.767465] PM: Adding info for No Bus:wlan0
<7>[    5.771509] PM: Adding info for No Bus:input6
<6>[    5.771534] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input6
<7>[    5.771563] PM: Adding info for No Bus:mouse0
<7>[    5.771596] PM: Adding info for No Bus:event6
<7>[    5.782199] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    5.782202] sd 0:0:0:0: rpm_resume returns 1
<7>[    5.787266] ehci_hcd 0000:00:1d.0: port 1 high speed
<7>[    5.787271] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
<7>[    5.822633] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    5.822636] sd 0:0:0:0: rpm_resume returns 1
<7>[    5.827635] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    5.827638] sd 0:0:0:0: rpm_resume returns 1
<7>[    5.827925] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    5.827928] sd 0:0:0:0: rpm_resume returns 1
<7>[    5.827946] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    5.827949] sd 0:0:0:0: rpm_resume returns 1
<7>[    5.828168] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    5.828170] sd 0:0:0:0: rpm_resume returns 1
<7>[    5.828174] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    5.828176] sd 0:0:0:0: rpm_resume returns 1
<7>[    5.833873] usb 2-1: link qh256-0001/ffff880013679e00 start 1 [1/0 us]
<7>[    5.849922] ehci_hcd 0000:00:1d.0: set dev address 2 for port 1
<7>[    5.849931] ehci_hcd 0000:00:1d.0: LPM: no device attached
<7>[    5.850167] usb 3-1: udev 2, busnum 3, minor = 257
<6>[    5.850173] usb 3-1: New USB device found, idVendor=8087, idProduct=0024
<6>[    5.850179] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<7>[    5.850281] PM: Adding info for usb:3-1
<7>[    5.850301] usb 3-1: usb_probe_device
<7>[    5.850305] usb 3-1: configuration #1 chosen from 1 choice
<7>[    5.850409] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
<7>[    5.850428] PM: Adding info for usb:3-1:1.0
<7>[    5.850450] hub 3-1:1.0: usb_probe_interface
<7>[    5.850453] hub 3-1:1.0: usb_probe_interface - got id
<6>[    5.850455] hub 3-1:1.0: USB hub found
<6>[    5.850531] hub 3-1:1.0: 8 ports detected
<7>[    5.850533] hub 3-1:1.0: standalone hub
<7>[    5.850535] hub 3-1:1.0: individual port power switching
<7>[    5.850537] hub 3-1:1.0: individual port over-current protection
<7>[    5.850539] hub 3-1:1.0: Single TT
<7>[    5.850541] hub 3-1:1.0: TT requires at most 8 FS bit times (666 ns)
<7>[    5.850543] hub 3-1:1.0: power on to power good time: 100ms
<7>[    5.850781] hub 3-1:1.0: local power source is good
<7>[    5.850784] hub 3-1:1.0: enabling power on all ports
<7>[    5.851788] hub 3-1:1.0: rpm_suspend flags 0x4
<7>[    5.851796] hub 3-1:1.0: rpm_suspend returns 0
<7>[    5.851872] PM: Adding info for No Bus:ep_81
<7>[    5.851879] drivers/usb/core/inode.c: creating file '002'
<7>[    5.851912] PM: Adding info for No Bus:ep_00
<7>[    5.851914] usb 3-1: rpm_suspend flags 0xc
<7>[    5.851916] usb 3-1: rpm_suspend returns -38
<7>[    5.851918] hub 2-1:1.0: state 7 ports 6 chg 0010 evt 0000
<7>[    5.852046] hub 2-1:1.0: port 4, status 0101, change 0000, 12 Mb/s
<7>[    5.861527] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    5.861529] sd 0:0:0:0: rpm_resume returns 1
<7>[    5.862845] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    5.862848] sd 0:0:0:0: rpm_resume returns 1
<7>[    5.862884] hub 2-1:1.0: port 4 not reset yet, waiting 10ms
<6>[    5.924790] usb 2-1.4: new high speed USB device using ehci_hcd and address 3
<7>[    5.935755] hub 2-1:1.0: port 4 not reset yet, waiting 10ms
<7>[    5.951349] hub 3-1:1.0: port 6: status 0101 change 0001
<6>[    5.964624] hda_codec: ALC665: SKU not ready 0x598301f0
<6>[    5.964796] hda_codec: ALC665: BIOS auto-probing.
<7>[    6.010747] usb 2-1.4: skipped 2 descriptors after configuration
<7>[    6.010755] usb 2-1.4: skipped 7 descriptors after interface
<7>[    6.010762] usb 2-1.4: skipped 1 descriptor after endpoint
<7>[    6.010768] usb 2-1.4: skipped 28 descriptors after interface
<7>[    6.010776] usb 2-1.4: skipped 2 descriptors after interface
<7>[    6.010986] usb 2-1.4: default language 0x0409
<7>[    6.011237] usb 2-1.4: udev 3, busnum 2, minor = 130
<6>[    6.011243] usb 2-1.4: New USB device found, idVendor=0408, idProduct=2fb1
<6>[    6.011249] usb 2-1.4: New USB device strings: Mfr=3, Product=2, SerialNumber=0
<6>[    6.011254] usb 2-1.4: Product: Laptop_Integrated_Webcam_2HDM
<6>[    6.011259] usb 2-1.4: Manufacturer: CN07CN2C7866414I0D37A00
<7>[    6.011354] PM: Adding info for usb:2-1.4
<7>[    6.011374] usb 2-1.4: usb_probe_device
<7>[    6.011377] usb 2-1.4: configuration #1 chosen from 1 choice
<7>[    6.011614] usb 2-1.4: adding 2-1.4:1.0 (config #1, interface 0)
<7>[    6.011647] PM: Adding info for usb:2-1.4:1.0
<7>[    6.011962] PM: Adding info for No Bus:ep_81
<7>[    6.011977] usb 2-1.4: adding 2-1.4:1.1 (config #1, interface 1)
<7>[    6.011992] PM: Adding info for usb:2-1.4:1.1
<7>[    6.012008] usb 2-1.4: adding 2-1.4:1.2 (config #1, interface 2)
<7>[    6.012026] PM: Adding info for usb:2-1.4:1.2
<7>[    6.012042] drivers/usb/core/inode.c: creating file '003'
<7>[    6.012065] PM: Adding info for No Bus:ep_00
<7>[    6.012067] usb 2-1.4: rpm_suspend flags 0xc
<7>[    6.012069] usb 2-1.4: rpm_suspend returns -38
<7>[    6.012071] hub 2-1:1.0: state 7 ports 6 chg 0000 evt 0010
<7>[    6.051459] usb 3-1: link qh256-0001/ffff880013e2bd80 start 1 [1/0 us]
<7>[    6.051489] hub 3-1:1.0: state 7 ports 8 chg 0040 evt 0000
<7>[    6.051696] hub 3-1:1.0: port 6, status 0101, change 0000, 12 Mb/s
<7>[    6.062519] hub 3-1:1.0: port 6 not reset yet, waiting 10ms
<6>[    6.124419] usb 3-1.6: new high speed USB device using ehci_hcd and address 3
<7>[    6.136366] hub 3-1:1.0: port 6 not reset yet, waiting 10ms
<7>[    6.200531] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    6.200533] sd 0:0:0:0: rpm_resume returns 1
<7>[    6.202007] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    6.202009] sd 0:0:0:0: rpm_resume returns 1
<7>[    6.211496] usb 3-1.6: skipped 3 descriptors after interface
<7>[    6.211504] usb 3-1.6: skipped 4 descriptors after interface
<7>[    6.211512] usb 3-1.6: skipped 4 descriptors after interface
<7>[    6.211518] usb 3-1.6: skipped 2 descriptors after interface
<7>[    6.211524] usb 3-1.6: skipped 5 descriptors after interface
<7>[    6.211533] usb 3-1.6: skipped 2 descriptors after interface
<7>[    6.211539] usb 3-1.6: skipped 4 descriptors after interface
<7>[    6.212362] usb 3-1.6: skipped 3 descriptors after interface
<7>[    6.212368] usb 3-1.6: skipped 4 descriptors after interface
<7>[    6.212374] usb 3-1.6: skipped 4 descriptors after interface
<7>[    6.212381] usb 3-1.6: skipped 2 descriptors after interface
<7>[    6.212386] usb 3-1.6: skipped 5 descriptors after interface
<7>[    6.212394] usb 3-1.6: skipped 2 descriptors after interface
<7>[    6.212605] usb 3-1.6: default language 0x0409
<7>[    6.213104] usb 3-1.6: udev 3, busnum 3, minor = 258
<6>[    6.213110] usb 3-1.6: New USB device found, idVendor=413c, idProduct=8184
<6>[    6.213116] usb 3-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
<6>[    6.213122] usb 3-1.6: Product: Dell Wireless 5540
<6>[    6.213137] usb 3-1.6: Manufacturer: <ADell Wireless 5540
<6>[    6.213143] usb 3-1.6: SerialNumber: 3563970328033220
<7>[    6.213229] PM: Adding info for usb:3-1.6
<7>[    6.213249] usb 3-1.6: usb_probe_device
<7>[    6.213252] usb 3-1.6: configuration #1 chosen from 2 choices
<7>[    6.216476] usb 3-1.6: adding 3-1.6:1.0 (config #1, interface 0)
<7>[    6.216514] PM: Adding info for usb:3-1.6:1.0
<7>[    6.216768] usb 3-1.6: adding 3-1.6:1.1 (config #1, interface 1)
<7>[    6.216800] PM: Adding info for usb:3-1.6:1.1
<7>[    6.217188] PM: Adding info for No Bus:ep_8a
<7>[    6.217195] usb 3-1.6: adding 3-1.6:1.2 (config #1, interface 2)
<7>[    6.217221] PM: Adding info for usb:3-1.6:1.2
<7>[    6.217544] PM: Adding info for No Bus:ep_01
<7>[    6.217578] PM: Adding info for No Bus:ep_81
<7>[    6.217590] usb 3-1.6: adding 3-1.6:1.3 (config #1, interface 3)
<7>[    6.217600] PM: Adding info for usb:3-1.6:1.3
<7>[    6.217912] PM: Adding info for No Bus:ep_89
<7>[    6.217918] usb 3-1.6: adding 3-1.6:1.4 (config #1, interface 4)
<7>[    6.217951] PM: Adding info for usb:3-1.6:1.4
<7>[    6.218289] PM: Adding info for No Bus:ep_02
<7>[    6.218325] PM: Adding info for No Bus:ep_82
<7>[    6.218338] usb 3-1.6: adding 3-1.6:1.5 (config #1, interface 5)
<7>[    6.218347] PM: Adding info for usb:3-1.6:1.5
<7>[    6.218910] PM: Adding info for No Bus:ep_88
<7>[    6.218915] usb 3-1.6: adding 3-1.6:1.6 (config #1, interface 6)
<7>[    6.218949] PM: Adding info for usb:3-1.6:1.6
<7>[    6.219286] PM: Adding info for No Bus:ep_86
<7>[    6.219291] usb 3-1.6: adding 3-1.6:1.7 (config #1, interface 7)
<7>[    6.219335] PM: Adding info for usb:3-1.6:1.7
<7>[    6.219628] usb 3-1.6: adding 3-1.6:1.8 (config #1, interface 8)
<7>[    6.219660] PM: Adding info for usb:3-1.6:1.8
<7>[    6.220034] PM: Adding info for No Bus:ep_87
<7>[    6.220040] usb 3-1.6: adding 3-1.6:1.9 (config #1, interface 9)
<7>[    6.220071] PM: Adding info for usb:3-1.6:1.9
<7>[    6.220413] PM: Adding info for No Bus:ep_84
<7>[    6.220419] usb 3-1.6: adding 3-1.6:1.10 (config #1, interface 10)
<7>[    6.220458] PM: Adding info for usb:3-1.6:1.10
<7>[    6.220780] PM: Adding info for No Bus:ep_03
<7>[    6.220816] PM: Adding info for No Bus:ep_83
<7>[    6.220822] drivers/usb/core/inode.c: creating file '003'
<7>[    6.220853] PM: Adding info for No Bus:ep_00
<7>[    6.220856] usb 3-1.6: rpm_suspend flags 0xc
<7>[    6.220858] usb 3-1.6: rpm_suspend returns -38
<7>[    6.234453] PM: Adding info for No Bus:card0
<7>[    6.234483] PM: Adding info for No Bus:pcmC0D3p
<7>[    6.234505] PM: Adding info for No Bus:pcmC0D1p
<7>[    6.234525] PM: Adding info for No Bus:pcmC0D0p
<7>[    6.234549] PM: Adding info for No Bus:pcmC0D0c
<7>[    6.234577] PM: Adding info for No Bus:input7
<6>[    6.234595] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
<7>[    6.234610] PM: Adding info for No Bus:event7
<7>[    6.234632] PM: Adding info for No Bus:input8
<6>[    6.234647] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
<7>[    6.234660] PM: Adding info for No Bus:event8
<7>[    6.234680] PM: Adding info for No Bus:controlC0
<7>[    6.301047] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    6.301059] sd 0:0:0:0: rpm_resume returns 1
<7>[    6.302364] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    6.302366] sd 0:0:0:0: rpm_resume returns 1
<7>[    6.333547] cdc_acm 3-1.6:1.1: usb_probe_interface
<7>[    6.333551] cdc_acm 3-1.6:1.1: usb_probe_interface - got id
<6>[    6.333705] cdc_acm 3-1.6:1.1: ttyACM0: USB ACM device
<7>[    6.341069] PM: Adding info for No Bus:ttyACM0
<7>[    6.341105] cdc_acm 3-1.6:1.1: rpm_suspend flags 0x4
<7>[    6.341110] cdc_acm 3-1.6:1.1: rpm_suspend returns 0
<7>[    6.341121] cdc_acm 3-1.6:1.3: usb_probe_interface
<7>[    6.341124] cdc_acm 3-1.6:1.3: usb_probe_interface - got id
<6>[    6.341370] cdc_acm 3-1.6:1.3: ttyACM1: USB ACM device
<7>[    6.356869] PM: Adding info for No Bus:ttyACM1
<7>[    6.356985] cdc_acm 3-1.6:1.3: rpm_suspend flags 0x4
<7>[    6.356990] cdc_acm 3-1.6:1.3: rpm_suspend returns 0
<7>[    6.357008] cdc_acm 3-1.6:1.9: usb_probe_interface
<7>[    6.357011] cdc_acm 3-1.6:1.9: usb_probe_interface - got id
<6>[    6.357266] cdc_acm 3-1.6:1.9: ttyACM2: USB ACM device
<7>[    6.372904] PM: Adding info for No Bus:ttyACM2
<7>[    6.372956] cdc_acm 3-1.6:1.9: rpm_suspend flags 0x4
<7>[    6.372960] cdc_acm 3-1.6:1.9: rpm_suspend returns 0
<6>[    6.372985] usbcore: registered new interface driver cdc_acm
<6>[    6.372988] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
<7>[    6.372998] cdc_wdm 3-1.6:1.5: usb_probe_interface
<7>[    6.373001] cdc_wdm 3-1.6:1.5: usb_probe_interface - got id
<7>[    6.373024] cdc_wdm 3-1.6:1.5: looking for a minor, starting at 176
<7>[    6.373052] PM: Adding info for No Bus:cdc-wdm0
<6>[    6.373069] cdc_wdm 3-1.6:1.5: cdc-wdm0: USB WDM device
<7>[    6.373072] cdc_wdm 3-1.6:1.5: rpm_suspend flags 0x4
<7>[    6.373077] cdc_wdm 3-1.6:1.5: rpm_suspend returns 0
<7>[    6.373085] cdc_wdm 3-1.6:1.8: usb_probe_interface
<7>[    6.373088] cdc_wdm 3-1.6:1.8: usb_probe_interface - got id
<7>[    6.373092] cdc_wdm 3-1.6:1.8: looking for a minor, starting at 176
<7>[    6.373116] PM: Adding info for No Bus:cdc-wdm1
<6>[    6.373126] cdc_wdm 3-1.6:1.8: cdc-wdm1: USB WDM device
<7>[    6.373128] cdc_wdm 3-1.6:1.8: rpm_suspend flags 0x4
<7>[    6.373130] cdc_wdm 3-1.6:1.8: rpm_suspend returns 0
<6>[    6.373141] usbcore: registered new interface driver cdc_wdm
<7>[    6.373168] cdc_ether 3-1.6:1.6: usb_probe_interface
<7>[    6.373171] cdc_ether 3-1.6:1.6: usb_probe_interface - got id
<7>[    6.382086] PM: Adding info for No Bus:ep_05
<7>[    6.382128] PM: Adding info for No Bus:ep_85
<7>[    6.383028] PM: Adding info for No Bus:wwan0
<6>[    6.383407] cdc_ether 3-1.6:1.6: wwan0: register 'cdc_ether' at usb-0000:00:1d.0-1.6, Mobile Broadband Network Device, 02:80:37:ec:02:00
<7>[    6.383411] cdc_ether 3-1.6:1.6: rpm_suspend flags 0x4
<7>[    6.383415] cdc_ether 3-1.6:1.6: rpm_suspend returns 0
<6>[    6.383432] usbcore: registered new interface driver cdc_ether
<7>[    6.425215] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    6.425218] sd 0:0:0:0: rpm_resume returns 1
<7>[    6.426753] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    6.426755] sd 0:0:0:0: rpm_resume returns 1
<7>[    6.577196] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    6.577198] sd 0:0:0:0: rpm_resume returns 1
<7>[    6.578732] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    6.578734] sd 0:0:0:0: rpm_resume returns 1
<7>[    6.609225] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    6.609227] sd 0:0:0:0: rpm_resume returns 1
<7>[    6.610645] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    6.610647] sd 0:0:0:0: rpm_resume returns 1
<7>[    8.295240] PM: Adding info for platform:coretemp.0
<6>[    8.295257] coretemp coretemp.0: TjMax is 100 C.
<7>[    8.295287] PM: Adding info for No Bus:hwmon0
<7>[    8.295313] PM: Adding info for platform:coretemp.2
<6>[    8.295331] coretemp coretemp.2: TjMax is 100 C.
<7>[    8.295354] PM: Adding info for No Bus:hwmon1
<7>[    8.459554] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    8.459556] sd 0:0:0:0: rpm_resume returns 1
<7>[    8.459573] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    8.459574] sd 0:0:0:0: rpm_resume returns 1
<7>[    8.571989] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    8.571991] sd 0:0:0:0: rpm_resume returns 1
<7>[    8.624112] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    8.624115] sd 0:0:0:0: rpm_resume returns 1
<7>[    8.625600] sd 0:0:0:0: rpm_resume flags 0x4
<7>[    8.625603] sd 0:0:0:0: rpm_resume returns 1
<7>[    9.181197] PM: Adding info for No Bus:vcs2
<7>[    9.181222] PM: Adding info for No Bus:vcsa2
<7>[    9.181316] PM: Adding info for No Bus:vcs3
<7>[    9.181334] PM: Adding info for No Bus:vcsa3
<7>[    9.181437] PM: Adding info for No Bus:vcs4
<7>[    9.181465] PM: Adding info for No Bus:vcsa4
<7>[    9.181615] PM: Adding info for No Bus:vcs5
<7>[    9.181642] PM: Adding info for No Bus:vcsa5
<7>[    9.181775] PM: Adding info for No Bus:vcs6
<7>[    9.181801] PM: Adding info for No Bus:vcsa6
<7>[    9.182066] PM: Adding info for No Bus:vcs7
<7>[    9.182092] PM: Adding info for No Bus:vcsa7
<7>[    9.182411] PM: Adding info for No Bus:vcs8
<7>[    9.182440] PM: Adding info for No Bus:vcsa8
<7>[    9.182745] PM: Adding info for No Bus:vcs9
<7>[    9.182778] PM: Adding info for No Bus:vcsa9
<7>[    9.183001] PM: Adding info for No Bus:vcs10
<7>[    9.183031] PM: Adding info for No Bus:vcsa10
<7>[    9.183249] PM: Adding info for No Bus:vcs11
<7>[    9.183281] PM: Adding info for No Bus:vcsa11
<7>[    9.183501] PM: Adding info for No Bus:vcs12
<7>[    9.183530] PM: Adding info for No Bus:vcsa12
<7>[    9.511303] r8169 0000:06:00.0: rpm_resume flags 0x4
<7>[    9.511306] r8169 0000:06:00.0: rpm_resume returns 1
<6>[    9.517060] r8169 0000:06:00.0: eth0: link down
<6>[    9.517066] r8169 0000:06:00.0: eth0: link down
<6>[    9.517107] ADDRCONF(NETDEV_UP): eth0: link is not ready
<7>[   10.400426] PM: Adding info for No Bus:mixer
<7>[   10.533168] PM: Adding info for No Bus:dsp
<7>[   10.533190] PM: Adding info for No Bus:audio
<7>[   10.533219] PM: Adding info for No Bus:adsp
<7>[   10.698175] PM: Adding info for No Bus:seq
<7>[   10.731469] PM: Adding info for No Bus:sequencer
<7>[   10.731490] PM: Adding info for No Bus:sequencer2
<7>[   11.061929] r8169 0000:06:00.0: rpm_resume flags 0x1
<7>[   11.061938] r8169 0000:06:00.0: rpm_resume returns 1
<6>[   11.061952] r8169 0000:06:00.0: eth0: link up
<6>[   11.062026] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<6>[   11.562490] CPU 1 is now offline
<7>[   11.562896] PM: Removing info for No Bus:msr1
<7>[   11.562964] PM: Removing info for No Bus:cpu1
<7>[   11.565835] PM: Removing info for platform:coretemp.2
<7>[   11.565871] PM: Removing info for No Bus:hwmon1
<7>[   11.566018] PM: Adding info for platform:coretemp.3
<6>[   11.566226] coretemp coretemp.3: TjMax is 100 C.
<7>[   11.566692] PM: Adding info for No Bus:hwmon1
<6>[   11.577915] CPU 2 is now offline
<7>[   11.578288] PM: Removing info for No Bus:msr2
<7>[   11.578350] PM: Removing info for No Bus:cpu2
<6>[   11.579304] CPU 3 MCA banks CMCI:0 CMCI:1 CMCI:3
<7>[   11.579670] PM: Removing info for platform:coretemp.3
<7>[   11.579703] PM: Removing info for No Bus:hwmon1
<6>[   11.588408] CPU 3 is now offline
<6>[   11.588415] SMP alternatives: switching to UP code
<7>[   11.599629] PM: Removing info for No Bus:msr3
<7>[   11.599954] PM: Removing info for No Bus:cpu3
<7>[   11.701511] usb 3-1.6: link qh16-0001/ffff880014170a80 start 2 [1/0 us]
<7>[   11.722975] usb 3-1.6: link qh16-0001/ffff880014303980 start 3 [1/0 us]
<7>[   11.746977] usb 3-1.6: link qh16-0001/ffff880014303f00 start 4 [1/0 us]
<7>[   11.953285] usb 3-1.6: link qh8-0001/ffff880014303680 start 5 [1/0 us]
<7>[   14.334087] usb 3-1.6: unlink qh16-0001/ffff880014170a80 start 2 [1/0 us]
<7>[   14.342007] usb 3-1.6: unlink qh16-0001/ffff880014303980 start 3 [1/0 us]
<7>[   14.349973] usb 3-1.6: unlink qh16-0001/ffff880014303f00 start 4 [1/0 us]
<7>[   14.352618] ehci_hcd 0000:00:1d.0: reused qh ffff880014170a80 schedule
<7>[   14.352630] usb 3-1.6: link qh16-0001/ffff880014170a80 start 2 [1/0 us]
<7>[   20.195104] usb 3-1.6: unlink qh16-0001/ffff880014170a80 start 2 [1/0 us]
<7>[   20.202757] usb 3-1.6: unlink qh8-0001/ffff880014303680 start 5 [1/0 us]
<7>[   24.939320] sd 0:0:0:0: rpm_resume flags 0x4
<7>[   24.939328] sd 0:0:0:0: rpm_resume returns 1
<6>[   36.421727] SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) 
<6>[   38.659564] SysRq : Emergency Sync
<4>[   38.661308] Emergency Sync complete
<6>[   40.357371] SysRq : Emergency Remount R/O
<6>[   40.699316] SysRq : Emergency Sync
<4>[   40.730146] Emergency Sync complete
<4>[   40.730158] Emergency Remount complete
<7>[   50.048499] iwlagn 0000:03:00.0: rpm_resume flags 0x4
<7>[   50.048508] iwlagn 0000:03:00.0: rpm_resume returns 1
<7>[   50.050502] PM: Removing info for No Bus:wlan0
<7>[   50.055704] PM: Removing info for No Bus:rfkill0
<7>[   50.055768] PM: Removing info for No Bus:phy0
<6>[   50.056726] iwlagn 0000:03:00.0: PCI INT A disabled
<6>[   52.233183] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
<6>[   52.233190] iwlagn: Copyright(c) 2003-2010 Intel Corporation
<6>[   52.233341] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
<7>[   52.233427] iwlagn 0000:03:00.0: setting latency timer to 64
<6>[   52.233550] iwlagn 0000:03:00.0: Detected Intel(R) Centrino(R) Wireless-N 1030 BGN, REV=0xB0
<6>[   52.251291] iwlagn 0000:03:00.0: device EEPROM VER=0x716, CALIB=0x6
<6>[   52.251296] iwlagn 0000:03:00.0: Device SKU: 0X9
<6>[   52.251301] iwlagn 0000:03:00.0: Valid Tx ant: 0X1, Valid Rx ant: 0X3
<6>[   52.251341] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 0 802.11a channels
<7>[   52.252109] iwlagn 0000:03:00.0: irq 51 for MSI/MSI-X
<7>[   52.254955] PM: Adding info for No Bus:0000:03:00.0
<7>[   52.259434] PM: Removing info for No Bus:0000:03:00.0
<6>[   52.259503] iwlagn 0000:03:00.0: loaded firmware version 17.168.5.2 build 35905
<7>[   52.261166] PM: Adding info for No Bus:phy1
<7>[   52.261236] PM: Adding info for No Bus:rfkill1
<7>[   52.261290] ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'
<7>[   52.261437] PM: Adding info for No Bus:wlan0
<7>[   54.307283] iwlagn 0000:03:00.0: rpm_resume flags 0x4
<7>[   54.307293] iwlagn 0000:03:00.0: rpm_resume returns 1
<7>[   54.309359] PM: Removing info for No Bus:wlan0
<7>[   54.312709] PM: Removing info for No Bus:rfkill1
<7>[   54.312771] PM: Removing info for No Bus:phy1
<6>[   54.314310] iwlagn 0000:03:00.0: PCI INT A disabled
<0>[   56.379474] general protection fault: 0000 [#1] SMP 
<0>[   56.379714] last sysfs file: /sys/module/iwlcore/refcnt
<4>[   56.379850] CPU 0 
<4>[   56.379906] Modules linked in: iwlcore(+) ext2 mbcache snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss acpi_cpufreq freq_table mperf coretemp hwmon kvm cdc_ether usbnet cdc_wdm cdc_acm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm sr_mod sg ehci_hcd snd_timer snd dell_wmi sparse_keymap psmouse wmi soundcore snd_page_alloc r8169 mii tpm_tis tpm cdrom tpm_bios processor thermal video evdev i2c_i801 i2c_core xhci_hcd backlight ac button battery [last unloaded: iwlcore]
<4>[   56.383409] 
<4>[   56.383535] Pid: 5077, comm: modprobe Not tainted 2.6.38.6-dbg #1 Dell Inc.          Dell System XPS L502X/0YR8NN
<4>[   56.383998] RIP: 0010:[<ffffffff810a70be>]  [<ffffffff810a70be>] __kmalloc+0xd8/0x104
<4>[   56.384270] RSP: 0018:ffff880013467de8  EFLAGS: 00010006
<4>[   56.384407] RAX: 0000000000000000 RBX: ffff880014802540 RCX: ffff880015c14528
<4>[   56.384549] RDX: 0000000100000000 RSI: 4000000000000000 RDI: 0000000000000007
<4>[   56.384690] RBP: ffff880013467e08 R08: 0000000000000340 R09: ffff880014b135f0
<4>[   56.384832] R10: 0000000000000c75 R11: ffff880013467e08 R12: 00000000000080d0
<4>[   56.384973] R13: 0000000000000246 R14: ffffffff81179e6e R15: ffff880014beed80
<4>[   56.385116] FS:  00007f518f243700(0000) GS:ffff880015c00000(0000) knlGS:0000000000000000
<4>[   56.385328] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[   56.385465] CR2: 00007f518e6ae00f CR3: 0000000013968000 CR4: 00000000000406f0
<4>[   56.385607] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>[   56.385749] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>[   56.385893] Process modprobe (pid: 5077, threadinfo ffff880013466000, task ffff880012beab20)
<0>[   56.386104] Stack:
<4>[   56.386229]  ffffffffa0082830 ffffffff814d3e51 ffffffffa0082880 0000000000000000
<4>[   56.386635]  ffff880013467e18 ffffffff81179e6e ffff880013467e38 ffffffff81179e87
<4>[   56.387042]  ffff880013467e58 0000000000000246 ffff880013467e68 ffffffff81179ebc
<0>[   56.387446] Call Trace:
<4>[   56.387581]  [<ffffffff81179e6e>] kzalloc+0xf/0x11
<4>[   56.387717]  [<ffffffff81179e87>] kobject_create+0x17/0x35
<4>[   56.387857]  [<ffffffff81179ebc>] kobject_create_and_add+0x17/0x66
<4>[   56.387999]  [<ffffffff8105d5db>] load_module+0x140a/0x164f
<4>[   56.388140]  [<ffffffff8105d865>] sys_init_module+0x45/0x1dc
<4>[   56.388281]  [<ffffffff8100293b>] system_call_fastpath+0x16/0x1b
<0>[   56.388419] Code: 48 8b 0b 65 48 03 0c 25 58 c4 00 00 48 8b 31 48 85 f6 75 13 44 89 e6 4c 89 f2 48 89 df e8 92 f5 ff ff 48 89 c6 eb 0b 48 63 43 18 <48> 8b 04 06 48 89 01 41 55 9d 48 85 f6 74 11 66 45 85 e4 79 0b 
<1>[   56.391914] RIP  [<ffffffff810a70be>] __kmalloc+0xd8/0x104
<4>[   56.392103]  RSP <ffff880013467de8>
<4>[   56.392234] ---[ end trace a27a59cbbd08e454 ]---
<0>[   65.859650] general protection fault: 0000 [#2] SMP 
<0>[   65.859887] last sysfs file: /sys/module/iwlcore/refcnt
<4>[   65.860023] CPU 0 
<4>[   65.860080] Modules linked in: iwlcore(+) ext2 mbcache snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss acpi_cpufreq freq_table mperf coretemp hwmon kvm cdc_ether usbnet cdc_wdm cdc_acm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm sr_mod sg ehci_hcd snd_timer snd dell_wmi sparse_keymap psmouse wmi soundcore snd_page_alloc r8169 mii tpm_tis tpm cdrom tpm_bios processor thermal video evdev i2c_i801 i2c_core xhci_hcd backlight ac button battery [last unloaded: iwlcore]
<4>[   65.863585] 
<4>[   65.863711] Pid: 5032, comm: bash Tainted: G      D     2.6.38.6-dbg #1 Dell Inc.          Dell System XPS L502X/0YR8NN
<4>[   65.864179] RIP: 0010:[<ffffffff810a68e7>]  [<ffffffff810a68e7>] kmem_cache_alloc+0x55/0x81
<4>[   65.864454] RSP: 0018:ffff8800137eddb0  EFLAGS: 00010006
<4>[   65.864591] RAX: 0000000000000000 RBX: ffff880014802540 RCX: ffff880015c14528
<4>[   65.864733] RDX: 0000000000000000 RSI: 4000000000000000 RDI: ffff880014802540
<4>[   65.864874] RBP: ffff8800137eddd0 R08: 0000000000014950 R09: 0000000000000001
<4>[   65.865016] R10: 0000000000014900 R11: 0000000000000000 R12: 00000000000000d0
<4>[   65.865158] R13: 0000000000000246 R14: ffffffff8104e258 R15: ffff8800136fb250
<4>[   65.865301] FS:  00007f27ee498700(0000) GS:ffff880015c00000(0000) knlGS:0000000000000000
<4>[   65.865514] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<4>[   65.865652] CR2: 0000000000c3a280 CR3: 0000000011a89000 CR4: 00000000000406f0
<4>[   65.865793] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>[   65.865935] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>[   65.866078] Process bash (pid: 5032, threadinfo ffff8800137ec000, task ffff8800136fb250)
<0>[   65.866289] Stack:
<4>[   65.866413]  ffff880014b1a0c0 ffff880012beab20 0000000000000010 ffff880012942000
<4>[   65.866819]  ffff8800137ede10 ffffffff8104e258 0000000000000000 ffff880012942000
<4>[   65.867223]  ffff8800137ede10 0000000001200011 ffff880012beab20 0000000000000000
<0>[   65.867631] Call Trace:
<4>[   65.867764]  [<ffffffff8104e258>] copy_creds+0xce/0x161
<4>[   65.867904]  [<ffffffff81031715>] copy_process+0x23a/0xfea
<4>[   65.868043]  [<ffffffff810aad3d>] ? get_empty_filp+0x99/0x124
<4>[   65.868182]  [<ffffffff810325be>] do_fork+0xf9/0x248
<4>[   65.868321]  [<ffffffff810a807a>] ? fd_install+0x31/0x5d
<4>[   65.868461]  [<ffffffff810b0edb>] ? do_pipe_flags+0x8a/0xc7
<4>[   65.868600]  [<ffffffff810096b7>] sys_clone+0x23/0x25
<4>[   65.868736]  [<ffffffff81002ba3>] stub_clone+0x13/0x20
<4>[   65.868874]  [<ffffffff8100293b>] ? system_call_fastpath+0x16/0x1b
<0>[   65.869012] Code: 48 8b 0b 65 48 03 0c 25 58 c4 00 00 48 8b 31 48 85 f6 75 13 44 89 e6 4c 89 f2 48 89 df e8 69 fd ff ff 48 89 c6 eb 0b 48 63 43 18 <48> 8b 04 06 48 89 01 41 55 9d 48 85 f6 74 11 66 45 85 e4 79 0b 
<1>[   65.872506] RIP  [<ffffffff810a68e7>] kmem_cache_alloc+0x55/0x81
<4>[   65.872696]  RSP <ffff8800137eddb0>
<4>[   65.872829] ---[ end trace a27a59cbbd08e455 ]---
<0>[   65.875748] general protection fault: 0000 [#3] SMP 
<0>[   65.875984] last sysfs file: /sys/module/iwlcore/refcnt
<4>[   65.876119] CPU 0 
<4>[   65.876175] Modules linked in: iwlcore(+) ext2 mbcache snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss acpi_cpufreq freq_table mperf coretemp hwmon kvm cdc_ether usbnet cdc_wdm cdc_acm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm sr_mod sg ehci_hcd snd_timer snd dell_wmi sparse_keymap psmouse wmi soundcore snd_page_alloc r8169 mii tpm_tis tpm cdrom tpm_bios processor thermal video evdev i2c_i801 i2c_core xhci_hcd backlight ac button battery [last unloaded: iwlcore]
<4>[   65.879674] 
<4>[   65.879800] Pid: 1, comm: init Tainted: G      D     2.6.38.6-dbg #1 Dell Inc.          Dell System XPS L502X/0YR8NN
<4>[   65.880267] RIP: 0010:[<ffffffff810a68e7>]  [<ffffffff810a68e7>] kmem_cache_alloc+0x55/0x81
<4>[   65.880536] RSP: 0018:ffff88001487ddb0  EFLAGS: 00010006
<4>[   65.880672] RAX: 0000000000000000 RBX: ffff880014802540 RCX: ffff880015c14528
<4>[   65.882794] RDX: 0000000000000000 RSI: 4000000000000000 RDI: ffff880014802540
<4>[   65.882936] RBP: ffff88001487ddd0 R08: 0000000000014950 R09: dead000000200200
<4>[   65.883077] R10: dead000000100100 R11: 0000000000000001 R12: 00000000000000d0
<4>[   65.883219] R13: 0000000000000246 R14: ffffffff8104e258 R15: ffff880014880000
<4>[   65.883361] FS:  00007f1ed127c700(0000) GS:ffff880015c00000(0000) knlGS:0000000000000000
<4>[   65.883575] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
<4>[   65.883712] CR2: 0000000000609900 CR3: 0000000014b54000 CR4: 00000000000406f0
<4>[   65.883853] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>[   65.883994] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>[   65.884137] Process init (pid: 1, threadinfo ffff88001487c000, task ffff880014880000)
<0>[   65.884347] Stack:
<4>[   65.884471]  ffff880012be4f00 ffff880012bedd70 0000000000000010 ffff880013ed2000
<4>[   65.884876]  ffff88001487de10 ffffffff8104e258 0000000000000000 ffff880013ed2000
<4>[   65.885283]  ffff88001487de10 0000000001200011 ffff880012bedd70 0000000000000000
<0>[   65.885691] Call Trace:
<4>[   65.885822]  [<ffffffff8104e258>] copy_creds+0xce/0x161
<4>[   65.885961]  [<ffffffff81031715>] copy_process+0x23a/0xfea
<4>[   65.886100]  [<ffffffff810b4f04>] ? user_path_at+0x66/0x95
<4>[   65.886241]  [<ffffffff81035e13>] ? do_wait+0x1ba/0x1fd
<4>[   65.886379]  [<ffffffff810325be>] do_fork+0xf9/0x248
<4>[   65.886516]  [<ffffffff8104e13d>] ? prepare_creds+0x23/0x70
<4>[   65.886657]  [<ffffffff8103ddb8>] ? sigprocmask+0xa0/0xc3
<4>[   65.886796]  [<ffffffff810096b7>] sys_clone+0x23/0x25
<4>[   65.886932]  [<ffffffff81002ba3>] stub_clone+0x13/0x20
<4>[   65.887069]  [<ffffffff8100293b>] ? system_call_fastpath+0x16/0x1b
<0>[   65.887208] Code: 48 8b 0b 65 48 03 0c 25 58 c4 00 00 48 8b 31 48 85 f6 75 13 44 89 e6 4c 89 f2 48 89 df e8 69 fd ff ff 48 89 c6 eb 0b 48 63 43 18 <48> 8b 04 06 48 89 01 41 55 9d 48 85 f6 74 11 66 45 85 e4 79 0b 
<1>[   65.890710] RIP  [<ffffffff810a68e7>] kmem_cache_alloc+0x55/0x81
<4>[   65.890902]  RSP <ffff88001487ddb0>

--Boundary-00=_dI/0NlIKhSVqAJm--

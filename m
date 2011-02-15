Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab1BONEu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 08:04:50 -0500
Date: Tue, 15 Feb 2011 14:04:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] iwlwifi: fix dma mappings and skbs leak
Message-ID: <20110215130428.GA2515@redhat.com>
References: <1297693947-15310-1-git-send-email-sgruszka@redhat.com>
 <1297698696.4723.16.camel@wwguy-ubuntu>
 <20110215113444.GC2162@redhat.com>
 <1297770602.3935.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297770602.3935.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 12:50:02PM +0100, Johannes Berg wrote:
> On Tue, 2011-02-15 at 12:34 +0100, Stanislaw Gruszka wrote:
> 
> > Today I tried to reproduce problem a few times with
> > patch applied and does not see dma warning. Also
> > iptables modules still unload fine.
> > 
> > However during testing, I triggered different warning:
> > 
> > WARNING: at lib/debugobjects.c:259 debug_print_object+0x5c/0x70()
> > Hardware name: HP xw8600 Workstation
> > ODEBUG: free active (active state 0) object type: timer_list
> > Pid: 9139, comm: rmmod Not tainted 2.6.38-rc4-wl+ #21
> > Call Trace:
> >  [<ffffffff810649cf>] ? warn_slowpath_common+0x7f/0xc0
> >  [<ffffffff81064ac6>] ? warn_slowpath_fmt+0x46/0x50
> >  [<ffffffff81226eec>] ? debug_print_object+0x5c/0x70
> >  [<ffffffff81227585>] ? debug_check_no_obj_freed+0x125/0x210
> >  [<ffffffff8109ebd7>] ? debug_check_no_locks_freed+0xf7/0x170
> >  [<ffffffff81156092>] ? kfree+0xc2/0x2f0
> 
> >  [<ffffffffa02a5188>] ? ieee80211_unregister_hw+0x58/0x120 [mac80211]
> 
> > It looks more like mac80211 issue for me.
> 
> Agree, but I wish the timer objects had a name so we'd know what it
> was ... hmm, how can we figure out which timer this is?

By patching kernel :-)
http://people.redhat.com/sgruszka/debugobj-add-timer-name.patch

It's ifmgd->conn_mon_timer, seems we only deauthenticate but not
dissassociate when down interface, full dmesg below.

Stanislaw

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.38-rc4-wl+ (stasiu@dhcp-31-100.brq.redhat.com) (gcc version 4.4.5 20110116 (Red Hat 4.4.5-5) (GCC) ) #22 SMP Tue Feb 15 10:44:03 CET 2011
Command line: ro root=UUID=b40ec0c6-d616-4407-8be6-d3c381cc575e rhgb KEYTABLE=us selinux=0 pcie_aspm=off LANG=C crashkernel=256M
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000096400 (usable)
 BIOS-e820: 0000000000096400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cffc2840 (usable)
 BIOS-e820: 00000000cffc2840 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
NX (Execute Disable) protection: active
DMI 2.5 present.
DMI: 0A98h/HP xw8600 Workstation, BIOS 786F5 v01.32 10/15/2008
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x130000 max_arch_pfn = 0x400000000
MTRR default type: write-back
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-E7FFF write-protect
  E8000-EFFFF write-back
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0130000000 mask 3FF0000000 uncachable
  1 base 00D0000000 mask 3FF0000000 uncachable
  2 base 00E0000000 mask 3FE0000000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xcffc2 max_arch_pfn = 0x400000000
found SMP MP-table at [ffff8800000fe700] fe700
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000cffc2000
 0000000000 - 00cfe00000 page 2M
 00cfe00000 - 00cffc2000 page 4k
kernel direct mapping tables up to cffc2000 @ 1fffa000-20000000
init_memory_mapping: 0000000100000000-0000000130000000
 0100000000 - 0130000000 page 2M
kernel direct mapping tables up to 130000000 @ cffbc000-cffc2000
RAMDISK: 36b08000 - 37ff0000
Reserving 256MB of memory at 608MB for crashkernel (System RAM: 4864MB)
ACPI: RSDP 00000000000e9810 00024 (v02 HPQOEM)
ACPI: XSDT 00000000cffc52ec 0005C (v01 HPQOEM SLIC-WKS 20081015      00000000)
ACPI: FACP 00000000cffc5494 000F4 (v03 HPQOEM SEABURG  00000001      00000000)
ACPI Error: 32/64X address mismatch in Gpe0Block: 0x0000F828/0x000000000001F030, using 32 (20110112/tbfadt-427)
ACPI: DSDT 00000000cffc5a7a 026A4 (v01 HPQOEM     DSDT 00000001 MSFT 0100000E)
ACPI: FACS 00000000cffc5200 00040
ACPI: SSDT 00000000cffc811e 06DC0 (v01 HPQOEM  PROJECT 00000001 MSFT 0100000E)
ACPI: APIC 00000000cffc5588 000D4 (v01 HPQOEM SEABURG  00000001      00000000)
ACPI: ASF! 00000000cffc565c 0006A (v32 HPQOEM SEABURG  00000001      00000000)
ACPI: MCFG 00000000cffc585e 0003C (v01 HPQOEM SEABURG  00000001      00000000)
ACPI: HPET 00000000cffc5a10 00038 (v01 HPQOEM SEABURG  00000001      00000000)
ACPI: TCPA 00000000cffc5a48 00032 (v01 HPQOEM SEABURG  00000001      00000000)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-0000000130000000
Initmem setup node 0 0000000000000000-0000000130000000
  NODE_DATA [000000012ffd9000 - 000000012fffffff]
 [ffffea0000000000-ffffea00043fffff] PMD -> [ffff88012be00000-ffff88012f7fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00130000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x00000096
    0: 0x00000100 -> 0x000cffc2
    0: 0x00100000 -> 0x00130000
On node 0 totalpages: 1048392
  DMA zone: 56 pages used for memmap
  DMA zone: 6 pages reserved
  DMA zone: 3912 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 833530 pages, LIFO batch:31
  Normal zone: 2688 pages used for memmap
  Normal zone: 193920 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0xf808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x08] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x09] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0a] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x0b] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x02] address[0xfec89000] gsi_base[24])
IOAPIC[1]: apic_id 2, version 32, address 0xfec89000, GSI 24-47
ACPI: IOAPIC (id[0x03] address[0xfec88000] gsi_base[48])
IOAPIC[2]: apic_id 3, version 32, address 0xfec88000, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 8 CPUs, 4 hotplug CPUs
nr_irqs_gsi: 88
PM: Registered nosave memory: 0000000000096000 - 0000000000097000
PM: Registered nosave memory: 0000000000097000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
PM: Registered nosave memory: 00000000cffc2000 - 00000000cffc3000
PM: Registered nosave memory: 00000000cffc3000 - 00000000d0000000
PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 478 pages/cpu @ffff8800cee00000 s1925760 r8192 d23936 u2097152
pcpu-alloc: s1925760 r8192 d23936 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031362
Policy zone: Normal
Kernel command line: ro root=UUID=b40ec0c6-d616-4407-8be6-d3c381cc575e rhgb KEYTABLE=us selinux=0 pcie_aspm=off LANG=C crashkernel=256M
PCIe ASPM is disabled
PID hash table entries: 4096 (order: 3, 32768 bytes)
xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
Checking aperture...
No AGP bridge found
Memory: 3743100k/4980736k available (4750k kernel code, 787168k absent, 450468k reserved, 4417k data, 3472k init)
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:262400 nr_irqs:1560 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 6367 kB
 per task-struct memory footprint: 2688 bytes
allocated 41943040 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
ODEBUG: 16 of 16 active objects replaced
hpet clockevent registered
Fast TSC calibration using PIT
Detected 3166.815 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 6333.63 BogoMIPS (lpj=3166815)
pid_max: default: 32768 minimum: 301
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20110112
ftrace: allocating 17594 entries in 69 pages
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X5460  @ 3.16GHz stepping 0a
Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
lockdep: fixing up alternatives.
Booting Node   0, Processors  #1lockdep: fixing up alternatives.
 #2lockdep: fixing up alternatives.
 #3
Brought up 4 CPUs
Total of 4 processors activated (25333.61 BogoMIPS).
devtmpfs: initialized
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 00000000cffd0d0a 008C4 (v01 HPQOEM  CPU_TM2 00000001 MSFT 0100000E)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 008C4 (v01 HPQOEM  CPU_TM2 00000001 MSFT 0100000E)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20110112/dsfield-143)
ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880127332168), AE_ALREADY_EXISTS (20110112/psparse-536)
ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xdfffffff]
pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff]
pci_root PNP0A08:00: host bridge window [mem 0xfed00000-0xfed003ff]
pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci 0000:00:00.0: [8086:4003] type 0 class 0x000600
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: [8086:4021] type 1 class 0x000604
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: [8086:4023] type 1 class 0x000604
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:05.0: [8086:4025] type 1 class 0x000604
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:09.0: [8086:4029] type 1 class 0x000604
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:10.0: [8086:4030] type 0 class 0x000600
pci 0000:00:10.1: [8086:4030] type 0 class 0x000600
pci 0000:00:10.2: [8086:4030] type 0 class 0x000600
pci 0000:00:10.3: [8086:4030] type 0 class 0x000600
pci 0000:00:10.4: [8086:4030] type 0 class 0x000600
pci 0000:00:11.0: [8086:4031] type 0 class 0x000600
pci 0000:00:15.0: [8086:4035] type 0 class 0x000600
pci 0000:00:15.1: [8086:4035] type 0 class 0x000600
pci 0000:00:16.0: [8086:4036] type 0 class 0x000600
pci 0000:00:16.1: [8086:4036] type 0 class 0x000600
pci 0000:00:1b.0: [8086:269a] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xf3700000-0xf3703fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:2690] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:2692] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: [8086:2688] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x3000-0x301f]
pci 0000:00:1d.1: [8086:2689] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x3020-0x303f]
pci 0000:00:1d.2: [8086:268a] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x3040-0x305f]
pci 0000:00:1d.3: [8086:268b] type 0 class 0x000c03
pci 0000:00:1d.3: reg 20: [io  0x3060-0x307f]
pci 0000:00:1d.7: [8086:268c] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xf3704000-0xf37043ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
pci 0000:00:1f.0: [8086:2670] type 0 class 0x000601
pci 0000:00:1f.1: [8086:269e] type 0 class 0x000101
pci 0000:00:1f.1: reg 10: [io  0x30d0-0x30d7]
pci 0000:00:1f.1: reg 14: [io  0x30f0-0x30f3]
pci 0000:00:1f.1: reg 18: [io  0x30d8-0x30df]
pci 0000:00:1f.1: reg 1c: [io  0x30f4-0x30f7]
pci 0000:00:1f.1: reg 20: [io  0x30c0-0x30cf]
pci 0000:00:1f.2: [8086:2682] type 0 class 0x000104
pci 0000:00:1f.2: reg 10: [io  0x30e0-0x30e7]
pci 0000:00:1f.2: reg 14: [io  0x30f8-0x30fb]
pci 0000:00:1f.2: reg 18: [io  0x30e8-0x30ef]
pci 0000:00:1f.2: reg 1c: [io  0x30fc-0x30ff]
pci 0000:00:1f.2: reg 20: [io  0x3080-0x309f]
pci 0000:00:1f.2: reg 24: [mem 0xf3704400-0xf37047ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:80:00.0: [8086:4235] type 0 class 0x000280
pci 0000:80:00.0: reg 10: [mem 0xf3900000-0xf3901fff 64bit]
pci 0000:80:00.0: PME# supported from D0 D3hot D3cold
pci 0000:80:00.0: PME# disabled
pci 0000:00:01.0: PCI bridge to [bus 80-80]
pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:01.0:   bridge window [mem 0xf3900000-0xf39fffff]
pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:a0:00.0: [8086:422b] type 0 class 0x000280
pci 0000:a0:00.0: reg 10: [mem 0xf3800000-0xf3801fff 64bit]
pci 0000:a0:00.0: PME# supported from D0 D3hot D3cold
pci 0000:a0:00.0: PME# disabled
pci 0000:00:03.0: PCI bridge to [bus a0-a0]
pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:03.0:   bridge window [mem 0xf3800000-0xf38fffff]
pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:60:00.0: [10de:042f] type 0 class 0x000300
pci 0000:60:00.0: reg 10: [mem 0xf2000000-0xf2ffffff]
pci 0000:60:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:60:00.0: reg 1c: [mem 0xf0000000-0xf1ffffff 64bit]
pci 0000:60:00.0: reg 24: [io  0x1000-0x107f]
pci 0000:60:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:00:05.0: PCI bridge to [bus 60-60]
pci 0000:00:05.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:05.0:   bridge window [mem 0xf0000000-0xf2ffffff]
pci 0000:00:05.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:10:00.0: [8086:3500] type 1 class 0x000604
pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
pci 0000:10:00.0: PME# disabled
pci 0000:10:00.3: [8086:350c] type 1 class 0x000604
pci 0000:10:00.3: PME# supported from D0 D3hot D3cold
pci 0000:10:00.3: PME# disabled
pci 0000:10:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:09.0: PCI bridge to [bus 10-40]
pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:09.0:   bridge window [mem 0xf3000000-0xf33fffff]
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:1e:00.0: [8086:3510] type 1 class 0x000604
pci 0000:1e:00.0: PME# supported from D0 D3hot D3cold
pci 0000:1e:00.0: PME# disabled
pci 0000:1e:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:1e:01.0: [8086:3514] type 1 class 0x000604
pci 0000:1e:01.0: PME# supported from D0 D3hot D3cold
pci 0000:1e:01.0: PME# disabled
pci 0000:1e:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:10:00.0: PCI bridge to [bus 1e-40]
pci 0000:10:00.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:10:00.0:   bridge window [mem 0xf3000000-0xf31fffff]
pci 0000:10:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:20:00.0: [8086:4229] type 0 class 0x000280
pci 0000:20:00.0: reg 10: [mem 0xf3100000-0xf3101fff 64bit]
pci 0000:20:00.0: PME# supported from D0 D3hot D3cold
pci 0000:20:00.0: PME# disabled
pci 0000:1e:00.0: PCI bridge to [bus 20-20]
pci 0000:1e:00.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:1e:00.0:   bridge window [mem 0xf3100000-0xf31fffff]
pci 0000:1e:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:40:00.0: [168c:002a] type 0 class 0x000280
pci 0000:40:00.0: reg 10: [mem 0xf3000000-0xf300ffff 64bit]
pci 0000:40:00.0: supports D1
pci 0000:40:00.0: PME# supported from D0 D1 D3hot
pci 0000:40:00.0: PME# disabled
pci 0000:40:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:1e:01.0: PCI bridge to [bus 40-40]
pci 0000:1e:01.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:1e:01.0:   bridge window [mem 0xf3000000-0xf30fffff]
pci 0000:1e:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:11:06.0: [1000:0054] type 0 class 0x000100
pci 0000:11:06.0: reg 10: [io  0x2000-0x20ff]
pci 0000:11:06.0: reg 14: [mem 0xf3210000-0xf3213fff 64bit]
pci 0000:11:06.0: reg 1c: [mem 0xf3200000-0xf320ffff 64bit]
pci 0000:11:06.0: reg 30: [mem 0x00000000-0x001fffff pref]
pci 0000:11:06.0: supports D1 D2
pci 0000:10:00.3: PCI bridge to [bus 11-11]
pci 0000:10:00.3:   bridge window [io  0x2000-0x2fff]
pci 0000:10:00.3:   bridge window [mem 0xf3200000-0xf32fffff]
pci 0000:10:00.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:0e:00.0: [14e4:167b] type 0 class 0x000200
pci 0000:0e:00.0: reg 10: [mem 0xf3500000-0xf350ffff 64bit]
pci 0000:0e:00.0: PME# supported from D3hot D3cold
pci 0000:0e:00.0: PME# disabled
pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xf3500000-0xf35fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:0f:00.0: [14e4:167b] type 0 class 0x000200
pci 0000:0f:00.0: reg 10: [mem 0xf3400000-0xf340ffff 64bit]
pci 0000:0f:00.0: PME# supported from D3hot D3cold
pci 0000:0f:00.0: PME# disabled
pci 0000:00:1c.1: PCI bridge to [bus 0f-0f]
pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.1:   bridge window [mem 0xf3400000-0xf34fffff]
pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:01:05.0: [104c:8023] type 0 class 0x000c00
pci 0000:01:05.0: reg 10: [mem 0xf3604000-0xf36047ff]
pci 0000:01:05.0: reg 14: [mem 0xf3600000-0xf3603fff]
pci 0000:01:05.0: supports D1 D2
pci 0000:01:05.0: PME# supported from D0 D1 D2 D3hot
pci 0000:01:05.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xf3600000-0xf36fffff]
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xdfffffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xfed00000-0xfed003ff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH9.MUPP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH9.MUPP.PTE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH9.MUPP.PTE2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.MCH9.PCIX._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
ACPI Error: [CAPD] Namespace lookup failure, AE_ALREADY_EXISTS (20110112/dsfield-143)
ACPI Error: Method parse/execution failed [\_SB_.PCI0._OSC] (Node ffff880127332168), AE_ALREADY_EXISTS (20110112/psparse-536)
ACPI: PCI Interrupt Link [LNKA] (IRQs *3 4 5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabled.
vgaarb: device added: PCI:0000:60:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 0000000000096400 - 000000000009ffff 
reserve RAM buffer: 00000000cffc2840 - 00000000cfffffff 
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #2
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #3
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0xd0000000-0xdfffffff window]
pnp 00:00: [mem 0xf0000000-0xfebfffff window]
pnp 00:00: [mem 0xfed00000-0xfed003ff window]
pnp 00:00: [mem 0xfed40000-0xfed44fff window]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [bus 00-ff]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [mem 0xfec88000-0xfec880ff]
pnp 00:01: Plug and Play ACPI device, IDs PNP0003 (active)
pnp 00:02: [mem 0xfec89000-0xfec890ff]
pnp 00:02: Plug and Play ACPI device, IDs PNP0003 (active)
pnp 00:03: [io  0x00f0-0x00ff]
pnp 00:03: [irq 13]
pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:04: [io  0x0000-0x000f]
pnp 00:04: [io  0x0080-0x008f]
pnp 00:04: [io  0x00c0-0x00df]
pnp 00:04: [dma 4]
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: [io  0x0070-0x0071]
pnp 00:05: [irq 8]
pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:06: [io  0x0061]
pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:07: [irq 12]
pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 PNP0f0e (active)
pnp 00:08: [io  0x0060]
pnp 00:08: [io  0x0064]
pnp 00:08: [irq 1]
pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:09: [irq 4]
pnp 00:09: [io  0x03f8-0x03ff]
pnp 00:09: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
pnp 00:0a: [irq 6]
pnp 00:0a: [dma 2]
pnp 00:0a: [io  0x03f0-0x03f5]
pnp 00:0a: [io  0x03f7]
pnp 00:0a: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:0b: [mem 0xfec00000-0xfec00fff]
pnp 00:0b: Plug and Play ACPI device, IDs PNP0003 (active)
pnp 00:0c: [mem 0xfed00000-0xfed003ff]
pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:0d: [io  0x0010-0x001f]
pnp 00:0d: [io  0x0050-0x0053]
pnp 00:0d: [io  0x0072-0x0077]
pnp 00:0d: [io  0x0090-0x009f]
pnp 00:0d: [io  0x04d0-0x04d1]
system 00:0d: [io  0x04d0-0x04d1] has been reserved
system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0e: [io  0x0400-0x041f]
pnp 00:0e: [io  0x0420-0x043f]
pnp 00:0e: [io  0x0440-0x045f]
pnp 00:0e: [io  0x0460-0x047f]
pnp 00:0e: [io  0x0480-0x048f]
pnp 00:0e: [io  0x0490-0x049f]
pnp 00:0e: [io  0xf800-0xf81f]
pnp 00:0e: [io  0xf820-0xf83f]
pnp 00:0e: [io  0xf840-0xf85f]
pnp 00:0e: [io  0xf860-0xf87f]
pnp 00:0e: [io  0xfa00-0xfa3f]
pnp 00:0e: [io  0xfc00-0xfc7f]
pnp 00:0e: [io  0xfc80-0xfcff]
pnp 00:0e: [io  0xfe00-0xfe7f]
pnp 00:0e: [io  0xfe80-0xfeff]
system 00:0e: [io  0x0400-0x041f] has been reserved
system 00:0e: [io  0x0420-0x043f] has been reserved
system 00:0e: [io  0x0440-0x045f] has been reserved
system 00:0e: [io  0x0460-0x047f] has been reserved
system 00:0e: [io  0x0480-0x048f] has been reserved
system 00:0e: [io  0x0490-0x049f] has been reserved
system 00:0e: [io  0xf800-0xf81f] has been reserved
system 00:0e: [io  0xf820-0xf83f] has been reserved
system 00:0e: [io  0xf840-0xf85f] has been reserved
system 00:0e: [io  0xf860-0xf87f] has been reserved
system 00:0e: [io  0xfa00-0xfa3f] has been reserved
system 00:0e: [io  0xfc00-0xfc7f] has been reserved
system 00:0e: [io  0xfc80-0xfcff] has been reserved
system 00:0e: [io  0xfe00-0xfe7f] has been reserved
system 00:0e: [io  0xfe80-0xfeff] has been reserved
system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0f: [mem 0xfed1c000-0xfed1ffff]
pnp 00:0f: [mem 0xffe00000-0xffffffff]
pnp 00:0f: [mem 0xfee00000-0xfeefffff]
pnp 00:0f: [mem 0xfe700000-0xfe7003ff]
pnp 00:0f: [mem 0xfe600000-0xfe6fffff]
pnp 00:0f: [mem 0xfe000000-0xfe01ffff]
system 00:0f: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:0f: [mem 0xffe00000-0xffffffff] has been reserved
system 00:0f: [mem 0xfee00000-0xfeefffff] has been reserved
system 00:0f: [mem 0xfe700000-0xfe7003ff] has been reserved
system 00:0f: [mem 0xfe600000-0xfe6fffff] has been reserved
system 00:0f: [mem 0xfe000000-0xfe01ffff] has been reserved
system 00:0f: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:10: [mem 0x00000000-0x0009ffff]
pnp 00:10: [mem 0x000c0000-0x000e7fff]
pnp 00:10: [mem 0x000e8000-0x000effff]
pnp 00:10: [mem 0x000f0000-0x000fffff]
pnp 00:10: [mem 0x00100000-0xcfffffff]
pnp 00:10: [mem 0xfeda0000-0xfedbffff]
pnp 00:10: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:11:06.0 BAR 6 [mem 0x00000000-0x001fffff pref]
pnp 00:10: disabling [mem 0x000c0000-0x000e7fff] because it overlaps 0000:11:06.0 BAR 6 [mem 0x00000000-0x001fffff pref]
pnp 00:10: disabling [mem 0x000e8000-0x000effff] because it overlaps 0000:11:06.0 BAR 6 [mem 0x00000000-0x001fffff pref]
pnp 00:10: disabling [mem 0x000f0000-0x000fffff] because it overlaps 0000:11:06.0 BAR 6 [mem 0x00000000-0x001fffff pref]
pnp 00:10: disabling [mem 0x00100000-0xcfffffff] because it overlaps 0000:11:06.0 BAR 6 [mem 0x00000000-0x001fffff pref]
system 00:10: [mem 0xfeda0000-0xfedbffff] has been reserved
system 00:10: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:11: [mem 0xe0000000-0xefffffff]
system 00:11: [mem 0xe0000000-0xefffffff] has been reserved
system 00:11: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp: PnP ACPI: found 18 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:09.0: BAR 15: assigned [mem 0xf3a00000-0xf3bfffff pref]
pci 0000:00:01.0: PCI bridge to [bus 80-80]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem 0xf3900000-0xf39fffff]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge to [bus a0-a0]
pci 0000:00:03.0:   bridge window [io  disabled]
pci 0000:00:03.0:   bridge window [mem 0xf3800000-0xf38fffff]
pci 0000:00:03.0:   bridge window [mem pref disabled]
pci 0000:60:00.0: BAR 6: can't assign mem pref (size 0x20000)
pci 0000:00:05.0: PCI bridge to [bus 60-60]
pci 0000:00:05.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:05.0:   bridge window [mem 0xf0000000-0xf2ffffff]
pci 0000:00:05.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:10:00.3: BAR 15: assigned [mem 0xf3a00000-0xf3bfffff pref]
pci 0000:1e:00.0: PCI bridge to [bus 20-20]
pci 0000:1e:00.0:   bridge window [io  disabled]
pci 0000:1e:00.0:   bridge window [mem 0xf3100000-0xf31fffff]
pci 0000:1e:00.0:   bridge window [mem pref disabled]
pci 0000:1e:01.0: PCI bridge to [bus 40-40]
pci 0000:1e:01.0:   bridge window [io  disabled]
pci 0000:1e:01.0:   bridge window [mem 0xf3000000-0xf30fffff]
pci 0000:1e:01.0:   bridge window [mem pref disabled]
pci 0000:10:00.0: PCI bridge to [bus 1e-40]
pci 0000:10:00.0:   bridge window [io  disabled]
pci 0000:10:00.0:   bridge window [mem 0xf3000000-0xf31fffff]
pci 0000:10:00.0:   bridge window [mem pref disabled]
pci 0000:11:06.0: BAR 6: assigned [mem 0xf3a00000-0xf3bfffff pref]
pci 0000:10:00.3: PCI bridge to [bus 11-11]
pci 0000:10:00.3:   bridge window [io  0x2000-0x2fff]
pci 0000:10:00.3:   bridge window [mem 0xf3200000-0xf32fffff]
pci 0000:10:00.3:   bridge window [mem 0xf3a00000-0xf3bfffff pref]
pci 0000:00:09.0: PCI bridge to [bus 10-40]
pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:09.0:   bridge window [mem 0xf3000000-0xf33fffff]
pci 0000:00:09.0:   bridge window [mem 0xf3a00000-0xf3bfffff pref]
pci 0000:00:1c.0: PCI bridge to [bus 0e-0e]
pci 0000:00:1c.0:   bridge window [io  disabled]
pci 0000:00:1c.0:   bridge window [mem 0xf3500000-0xf35fffff]
pci 0000:00:1c.0:   bridge window [mem pref disabled]
pci 0000:00:1c.1: PCI bridge to [bus 0f-0f]
pci 0000:00:1c.1:   bridge window [io  disabled]
pci 0000:00:1c.1:   bridge window [mem 0xf3400000-0xf34fffff]
pci 0000:00:1c.1:   bridge window [mem pref disabled]
pci 0000:00:1e.0: PCI bridge to [bus 01-01]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem 0xf3600000-0xf36fffff]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:03.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:05.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:09.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
pci 0000:00:09.0: setting latency timer to 64
pci 0000:10:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
pci 0000:10:00.0: setting latency timer to 64
pci 0000:1e:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
pci 0000:1e:00.0: setting latency timer to 64
pci 0000:1e:01.0: PCI INT A -> GSI 46 (level, low) -> IRQ 46
pci 0000:1e:01.0: setting latency timer to 64
pci 0000:10:00.3: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 5 [mem 0xd0000000-0xdfffffff]
pci_bus 0000:00: resource 6 [mem 0xf0000000-0xfebfffff]
pci_bus 0000:00: resource 7 [mem 0xfed00000-0xfed003ff]
pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
pci_bus 0000:00: resource 9 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 10 [io  0x0d00-0xffff]
pci_bus 0000:80: resource 1 [mem 0xf3900000-0xf39fffff]
pci_bus 0000:a0: resource 1 [mem 0xf3800000-0xf38fffff]
pci_bus 0000:60: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:60: resource 1 [mem 0xf0000000-0xf2ffffff]
pci_bus 0000:60: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
pci_bus 0000:10: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:10: resource 1 [mem 0xf3000000-0xf33fffff]
pci_bus 0000:10: resource 2 [mem 0xf3a00000-0xf3bfffff pref]
pci_bus 0000:1e: resource 1 [mem 0xf3000000-0xf31fffff]
pci_bus 0000:20: resource 1 [mem 0xf3100000-0xf31fffff]
pci_bus 0000:40: resource 1 [mem 0xf3000000-0xf30fffff]
pci_bus 0000:11: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:11: resource 1 [mem 0xf3200000-0xf32fffff]
pci_bus 0000:11: resource 2 [mem 0xf3a00000-0xf3bfffff pref]
pci_bus 0000:0e: resource 1 [mem 0xf3500000-0xf35fffff]
pci_bus 0000:0f: resource 1 [mem 0xf3400000-0xf34fffff]
pci_bus 0000:01: resource 1 [mem 0xf3600000-0xf36fffff]
pci_bus 0000:01: resource 4 [mem 0x000a0000-0x000bffff]
pci_bus 0000:01: resource 5 [mem 0xd0000000-0xdfffffff]
pci_bus 0000:01: resource 6 [mem 0xf0000000-0xfebfffff]
pci_bus 0000:01: resource 7 [mem 0xfed00000-0xfed003ff]
pci_bus 0000:01: resource 8 [mem 0xfed40000-0xfed44fff]
pci_bus 0000:01: resource 9 [io  0x0000-0x0cf7]
pci_bus 0000:01: resource 10 [io  0x0d00-0xffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 6, 393216 bytes)
UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)
NET: Registered protocol family 1
pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
pci 0000:60:00.0: Boot video device
PCI: CLS 64 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 21408k freed
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff8800cae00000 - ffff8800cee00000
software IO TLB at phys 0xcae00000 - 0xcee00000
audit: initializing netlink socket (disabled)
type=2000 audit(1297767133.022:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7352
cryptomgr_test used greatest stack depth: 6600 bytes left
cryptomgr_test used greatest stack depth: 6424 bytes left
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 88 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 89 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
intel_idle: MWAIT substates: 0x2220
intel_idle: does not run on family 6 model 23
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button [PBTN]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: acpi_idle registered with cpuidle
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 16, io mem 0xf3704000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.38-rc4-wl+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00003000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.38-rc4-wl+ uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003020
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.38-rc4-wl+ uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.38-rc4-wl+ uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 22, io base 0x00003060
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.38-rc4-wl+ uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
rtc_cmos 00:05: setting system clock to 2011-02-15 10:52:14 UTC (1297767134)
Initalizing network drop monitor service
Freeing unused kernel memory: 3472k freed
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
mknod used greatest stack depth: 5392 bytes left
mkdir used greatest stack depth: 5040 bytes left
dracut: dracut-004-36.el6
udev: starting version 147
udevd (72): /proc/72/oom_adj is deprecated, please use /proc/72/oom_score_adj instead.
[drm] Initialized drm 1.1.0 20060810
nouveau 0000:60:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
nouveau 0000:60:00.0: setting latency timer to 64
[drm] nouveau 0000:60:00.0: Detected an NV50 generation card (0x086f00a2)
[drm] nouveau 0000:60:00.0: Attempting to load BIOS image from PRAMIN
[drm] nouveau 0000:60:00.0: ... appears to be valid
[drm] nouveau 0000:60:00.0: BIT BIOS found
[drm] nouveau 0000:60:00.0: Bios version 60.86.63.00
[drm] nouveau 0000:60:00.0: TMDS table version 2.0
[drm] nouveau 0000:60:00.0: Found Display Configuration Block version 4.0
[drm] nouveau 0000:60:00.0: Raw DCB entry 0: 02011300 00000028
[drm] nouveau 0000:60:00.0: Raw DCB entry 1: 01011302 00000010
[drm] nouveau 0000:60:00.0: Raw DCB entry 2: 01000310 00000028
[drm] nouveau 0000:60:00.0: Raw DCB entry 3: 02000312 00000010
[drm] nouveau 0000:60:00.0: Raw DCB entry 4: 0000000e 00000000
[drm] nouveau 0000:60:00.0: DCB connector table: VHER 0x40 5 14 2
[drm] nouveau 0000:60:00.0:   0: 0x00002030: type 0x30 idx 0 tag 0x08
[drm] nouveau 0000:60:00.0:   1: 0x00001130: type 0x30 idx 1 tag 0x07
[drm] nouveau 0000:60:00.0: Parsing VBIOS init table 0 at offset 0xBD9C
usb 4-1: new low speed USB device using uhci_hcd and address 2
[drm] nouveau 0000:60:00.0: Parsing VBIOS init table 1 at offset 0xC106
[drm] nouveau 0000:60:00.0: Parsing VBIOS init table 2 at offset 0xCD47
[drm] nouveau 0000:60:00.0: Parsing VBIOS init table 3 at offset 0xCE39
[drm] nouveau 0000:60:00.0: Parsing VBIOS init table 4 at offset 0xD033
[drm] nouveau 0000:60:00.0: Parsing VBIOS init table at offset 0xD098
[drm] nouveau 0000:60:00.0: 0xD098: Condition still not met after 20ms, skipping following opcodes
Refined TSC clocksource calibration: 3166.778 MHz.
Switching to clocksource tsc
usb 4-1: New USB device found, idVendor=03f0, idProduct=2c24
usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-1: Product: HP USB Laser Mouse
usb 4-1: Manufacturer: HP
input: HP HP USB Laser Mouse as /devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/input3
generic-usb 0003:03F0:2C24.0001: input,hidraw0: USB HID v1.10 Mouse [HP HP USB Laser Mouse] on usb-0000:00:1d.2-1/input0
[drm] nouveau 0000:60:00.0: 2 available performance level(s)
[drm] nouveau 0000:60:00.0: 0: memory 100MHz core 208MHz shader 416MHz fanspeed 100%
[drm] nouveau 0000:60:00.0: 1: memory 400MHz core 459MHz shader 918MHz fanspeed 100%
[drm] nouveau 0000:60:00.0: c: memory 399MHz core 459MHz shader 918MHz
[TTM] Zone  kernel: Available graphics memory: 1883990 kiB.
[TTM] Initializing pool allocator.
[drm] nouveau 0000:60:00.0: Detected 256MiB VRAM
[drm] nouveau 0000:60:00.0: 512 MiB GART (aperture)
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
[drm] nouveau 0000:60:00.0: allocated 1680x1050 fb: 0x60000000, bo ffff88011bdf1710
fbcon: nouveaufb (fb0) is primary device
Console: switching to colour frame buffer device 210x65
fb0: nouveaufb frame buffer device
drm: registered panic notifier
[drm] Initialized nouveau 0.0.16 20090420 for 0000:60:00.0 on minor 0
modprobe used greatest stack depth: 3680 bytes left
dracut: Starting plymouth daemon
FDC 0 is a post-1991 82077
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x30c0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x30c8 irq 15
ata2: port disabled. ignoring.
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl RAID mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
scsi6 : ahci
scsi7 : ahci
ata3: SATA max UDMA/133 abar m1024@0xf3704400 port 0xf3704500 irq 19
ata4: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 19
ata5: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 19
ata6: SATA max UDMA/133 abar m1024@0xf3704400 port 0xf3704680 irq 19
ata7: SATA max UDMA/133 abar m1024@0xf3704400 port 0xf3704700 irq 19
ata8: SATA max UDMA/133 abar m1024@0xf3704400 port 0xf3704780 irq 19
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: ST3250410AS, 3.AHC, max UDMA/100
ata3.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata8: SATA link down (SStatus 0 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata3.00: configured for UDMA/100
scsi 2:0:0:0: Direct-Access     ATA      ST3250410AS      3.AH PQ: 0 ANSI: 5
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATAPI: ATAPI   DVD A  DH16A6L, ZH37, max UDMA/100
ata4.00: ATA-7: ST3250410AS, 3.AHC, max UDMA/100
ata4.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata5.00: configured for UDMA/100
ata4.00: configured for UDMA/100
scsi 3:0:0:0: Direct-Access     ATA      ST3250410AS      3.AH PQ: 0 ANSI: 5
scsi 4:0:0:0: CD-ROM            ATAPI    DVD A  DH16A6L   ZH37 PQ: 0 ANSI: 5
Fusion MPT base driver 3.04.17
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SAS Host driver 3.04.17
mptsas 0000:11:06.0: PCI INT A -> GSI 62 (level, low) -> IRQ 62
mptbase: ioc0: Initiating bringup
ioc0: LSISAS1068 B1: Capabilities={Initiator}
scsi8 : ioc0: LSISAS1068 B1, FwRev=01160100h, Ports=1, MaxQ=286, IRQ=62
firewire_ohci 0000:01:05.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
firewire_ohci: Added fw-ohci device 0000:01:05.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x2
sd 2:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 3:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 2:0:0:0: [sda] Attached SCSI disk
 sdb: sdb1 sdb2 sdb3 sdb4
sd 3:0:0:0: [sdb] Attached SCSI disk
sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
firewire_core: created device fw0: GUID 0060b000002a1d25, S400
EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
dracut: Mounted root filesystem /dev/sdb1
dracut: Switching root
readahead: starting
udev: starting version 147
WARNING! power/level is deprecated; use power/control instead
usb_id used greatest stack depth: 3664 bytes left
cfg80211: Calling CRDA to update world regulatory domain
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:80:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
iwlagn 0000:80:00.0: setting latency timer to 64
iwlagn 0000:80:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
ip used greatest stack depth: 3360 bytes left
iwlagn 0000:80:00.0: device EEPROM VER=0x11f, CALIB=0x4
iwlagn 0000:80:00.0: Device SKU: 0Xb
iwlagn 0000:80:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:80:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:80:00.0: irq 90 for MSI/MSI-X
iwlagn 0000:a0:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
iwlagn 0000:a0:00.0: setting latency timer to 64
iwlagn 0000:a0:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
iwlagn 0000:a0:00.0: device EEPROM VER=0x436, CALIB=0x6
iwlagn 0000:a0:00.0: Device SKU: 0Xb
iwlagn 0000:a0:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:a0:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:a0:00.0: irq 91 for MSI/MSI-X
iwlagn 0000:20:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
iwlagn 0000:20:00.0: setting latency timer to 64
iwlagn 0000:20:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
iwlagn 0000:20:00.0: device EEPROM VER=0x36, CALIB=0x5
iwlagn 0000:20:00.0: Device SKU: 0Xb
iwlagn 0000:20:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
iwlagn 0000:20:00.0: irq 92 for MSI/MSI-X
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
iwlagn 0000:20:00.0: loaded firmware version 228.61.2.24
Registered led device: phy2-led
iwlagn 0000:a0:00.0: loaded firmware version 9.176.4.1 build 15835
Registered led device: phy1-led
tg3.c:v3.116 (December 3, 2010)
tg3 0000:0e:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
tg3 0000:0e:00.0: setting latency timer to 64
iwlagn 0000:80:00.0: loaded firmware version 8.24.2.12
Registered led device: phy0-led
tg3 0000:0e:00.0: eth0: Tigon3 [partno(BCM95755) rev a002] (PCI Express) MAC address 00:23:7d:53:64:71
tg3 0000:0e:00.0: eth0: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1])
tg3 0000:0e:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 0000:0e:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
tg3 0000:0f:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
tg3 0000:0f:00.0: setting latency timer to 64
tg3 0000:0f:00.0: eth1: Tigon3 [partno(BCM95755) rev a002] (PCI Express) MAC address 00:23:7d:53:64:70
tg3 0000:0f:00.0: eth1: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1])
tg3 0000:0f:00.0: eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
tg3 0000:0f:00.0: eth1: dma_rwctrl[76180000] dma_mask[64-bit]
udev: renamed network interface eth0 to eth0-eth1
udev: renamed network interface eth1 to eth2
udev: renamed network interface eth0-eth1 to eth1
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
microcode: CPU0 sig=0x1067a, pf=0x40, revision=0xa07
microcode: CPU1 sig=0x1067a, pf=0x40, revision=0xa07
ieee80211 phy2: Selected rate control algorithm 'iwl-agn-rs'
ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'
microcode: CPU2 sig=0x1067a, pf=0x40, revision=0xa07
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
microcode: CPU3 sig=0x1067a, pf=0x40, revision=0xa07
udev: renamed network interface wlan0 to wlan0-wlan2
udev: renamed network interface wlan1 to wlan3
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
udev: renamed network interface wlan2 to wlan1
microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28
microcode: CPU2 updated to revision 0xa0b, date = 2010-09-28
microcode: CPU3 updated to revision 0xa0b, date = 2010-09-28
udev: renamed network interface wlan0-wlan2 to wlan2
wmi: Mapper loaded
sd 2:0:0:0: Attached scsi generic sg0 type 0
sd 3:0:0:0: Attached scsi generic sg1 type 0
sr 4:0:0:0: Attached scsi generic sg2 type 5
input: HP WMI hotkeys as /devices/virtual/input/input4
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
EXT4-fs (sdb1): re-mounted. Opts: (null)
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda1): using internal journal
EXT3-fs (sda1): mounted filesystem with ordered data mode
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-0): using internal journal
EXT3-fs (dm-0): mounted filesystem with ordered data mode
Adding 6094844k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 extents:1 across:6094844k 
Adding 16008768k swap on /dev/sdb3.  Priority:-2 extents:1 across:16008768k 
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
ADDRCONF(NETDEV_UP): wlan1: link is not ready
ADDRCONF(NETDEV_UP): wlan3: link is not ready
ADDRCONF(NETDEV_UP): wlan2: link is not ready
tg3 0000:0e:00.0: irq 93 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth1: link is not ready
tg3 0000:0f:00.0: irq 94 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth2: link is not ready
fuse init (API version 7.16)
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan2: authenticate with 00:23:69:35:d1:3e (try 1)
wlan2: authenticated
wlan2: associate with 00:23:69:35:d1:3e (try 1)
wlan2: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=2)
wlan2: associated
ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
padlock_aes: VIA PadLock not detected.
wlan2: no IPv6 routers present
wlan3: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan3: authenticate with 00:23:69:35:d1:3e (try 1)
wlan3: authenticated
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan3: waiting for beacon from 00:23:69:35:d1:3e
wlan3: beacon received
wlan3: associate with 00:23:69:35:d1:3e (try 1)
wlan3: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=2)
wlan3: associated
ADDRCONF(NETDEV_CHANGE): wlan3: link becomes ready
wlan3: no IPv6 routers present
wlan1: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan1: authenticate with 00:23:69:35:d1:3e (try 1)
wlan1: authenticated
wlan1: waiting for beacon from 00:23:69:35:d1:3e
wlan1: beacon received
wlan1: associate with 00:23:69:35:d1:3e (try 1)
wlan1: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=3)
wlan1: associated
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
wlan1: no IPv6 routers present
iwlagn 0000:80:00.0: Aggregation not enabled for tid 0 because load = 1
iwlagn 0000:80:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:80:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:80:00.0: queue number out of range: 0, must be 10 to 19
iwlagn 0000:80:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:80:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:80:00.0: queue number out of range: 0, must be 10 to 19
wlan3: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
iwlagn 0000:80:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:80:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:80:00.0: queue number out of range: 0, must be 10 to 19
iwlagn 0000:80:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
wlan1: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
iwlagn 0000:80:00.0: Stopping AGG while state not ON or starting
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
wlan1: direct probe to 00:23:69:35:d1:3f (try 1/3)
wlan1: direct probe to 00:23:69:35:d1:3f (try 2/3)
wlan1: direct probe to 00:23:69:35:d1:3f (try 3/3)
wlan1: direct probe responded
wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
wlan1: authenticated
wlan1: associate with 00:23:69:35:d1:3f (try 1)
wlan1: associate with 00:23:69:35:d1:3f (try 2)
wlan1: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=1)
wlan1: associated
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
wlan1: authenticated
wlan1: associate with 00:23:69:35:d1:3f (try 1)
wlan1: associate with 00:23:69:35:d1:3f (try 2)
wlan1: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=1)
wlan1: associated
iwlagn 0000:80:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:80:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:80:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:80:00.0: queue number out of range: 0, must be 10 to 19
iwlagn 0000:80:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:80:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:80:00.0: queue number out of range: 0, must be 10 to 19
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
tg3 0000:0e:00.0: PME# enabled
tg3 0000:0e:00.0: wake-up capability enabled by ACPI
tg3 0000:0f:00.0: PME# enabled
tg3 0000:0f:00.0: wake-up capability enabled by ACPI
ADDRCONF(NETDEV_UP): wlan1: link is not ready
ADDRCONF(NETDEV_UP): wlan3: link is not ready
ADDRCONF(NETDEV_UP): wlan2: link is not ready
tg3 0000:0e:00.0: irq 93 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth1: link is not ready
tg3 0000:0f:00.0: irq 94 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth2: link is not ready
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan3: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan2: authenticate with 00:23:69:35:d1:3e (try 1)
wlan2: authenticated
wlan2: associate with 00:23:69:35:d1:3e (try 1)
wlan2: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=2)
wlan2: associated
ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
wlan1: authenticated
wlan1: associate with 00:23:69:35:d1:3f (try 1)
wlan1: associate with 00:23:69:35:d1:3f (try 2)
wlan1: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=1)
wlan1: associated
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
wlan3: authenticate with 00:23:69:35:d1:3f (try 1)
wlan3: authenticate with 00:23:69:35:d1:3f (try 2)
wlan3: authenticated
wlan3: associate with 00:23:69:35:d1:3f (try 1)
wlan3: associate with 00:23:69:35:d1:3f (try 2)
wlan3: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=2)
wlan3: associated
ADDRCONF(NETDEV_CHANGE): wlan3: link becomes ready
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan2: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan2: authenticate with 00:23:69:35:d1:3f (try 1)
wlan2: authenticated
wlan2: waiting for beacon from 00:23:69:35:d1:3f
wlan2: beacon received
wlan2: associate with 00:23:69:35:d1:3f (try 1)
wlan2: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=3)
wlan2: associated
wlan2: no IPv6 routers present
wlan1: no IPv6 routers present
wlan3: no IPv6 routers present
wlan3: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
iwlagn 0000:20:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:20:00.0: Received BA when not expected
iwlagn 0000:20:00.0: Received BA when not expected
iwlagn 0000:20:00.0: Received BA when not expected
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:20:00.0: Failing on timeout while stopping DMA channel 1 [0x07fd0003]
iwlagn 0000:20:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:20:00.0: queue number out of range: 0, must be 7 to 14
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:20:00.0: Failing on timeout while stopping DMA channel 1 [0x07fd0002]
iwlagn 0000:20:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:20:00.0: Failing on timeout while stopping DMA channel 1 [0x07fd0003]
iwlagn 0000:20:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:20:00.0: queue number out of range: 0, must be 7 to 14
iwlagn 0000:20:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:20:00.0: Received BA when not expected
wlan2: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan2: authenticate with 00:23:69:35:d1:3e (try 1)
wlan2: authenticated
wlan2: associate with 00:23:69:35:d1:3e (try 1)
wlan2: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=2)
wlan2: associated
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:20:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:20:00.0: Failing on timeout while stopping DMA channel 1 [0x07fd0003]
iwlagn 0000:20:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:20:00.0: queue number out of range: 0, must be 7 to 14
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:20:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
iwlagn 0000:20:00.0: Error sending TX power (-5)
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
iwlagn 0000:20:00.0: Attempting to modify non-existing station 31
ieee80211 phy2: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-5)
iwlagn 0000:20:00.0: Attempting to modify non-existing station 0
ieee80211 phy2: failed to remove key (0, 00:23:69:35:d1:3e) from hardware (-5)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
iwlagn 0000:20:00.0: Error sending TX power (-5)
iwlagn 0000:20:00.0: PCI INT A disabled
iwlagn 0000:a0:00.0: PCI INT A disabled
iwlagn 0000:80:00.0: PCI INT A disabled
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:80:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
iwlagn 0000:80:00.0: setting latency timer to 64
iwlagn 0000:80:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
iwlagn 0000:80:00.0: device EEPROM VER=0x11f, CALIB=0x4
iwlagn 0000:80:00.0: Device SKU: 0Xb
iwlagn 0000:80:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:80:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:80:00.0: irq 90 for MSI/MSI-X
iwlagn 0000:a0:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
iwlagn 0000:a0:00.0: setting latency timer to 64
iwlagn 0000:a0:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
iwlagn 0000:a0:00.0: device EEPROM VER=0x436, CALIB=0x6
iwlagn 0000:a0:00.0: Device SKU: 0Xb
iwlagn 0000:a0:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:a0:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:a0:00.0: irq 91 for MSI/MSI-X
iwlagn 0000:20:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
iwlagn 0000:20:00.0: setting latency timer to 64
iwlagn 0000:20:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
iwlagn 0000:80:00.0: loaded firmware version 8.24.2.12
Registered led device: phy0-led
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
iwlagn 0000:a0:00.0: loaded firmware version 9.176.4.1 build 15835
Registered led device: phy1-led
ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
iwlagn 0000:20:00.0: device EEPROM VER=0x36, CALIB=0x5
iwlagn 0000:20:00.0: Device SKU: 0Xb
iwlagn 0000:20:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
iwlagn 0000:20:00.0: irq 92 for MSI/MSI-X
udev: renamed network interface wlan1 to wlan3
iwlagn 0000:20:00.0: loaded firmware version 228.61.2.24
Registered led device: phy2-led
udev: renamed network interface wlan0 to wlan1
ieee80211 phy2: Selected rate control algorithm 'iwl-agn-rs'
udev: renamed network interface wlan0 to wlan2
ADDRCONF(NETDEV_UP): wlan3: link is not ready
ADDRCONF(NETDEV_UP): wlan1: link is not ready
ADDRCONF(NETDEV_UP): wlan2: link is not ready
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan2: authenticate with 00:23:69:35:d1:3e (try 1)
wlan2: authenticated
wlan2: associate with 00:23:69:35:d1:3e (try 1)
wlan2: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=2)
wlan2: associated
ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
wlan3: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan3: authenticate with 00:23:69:35:d1:3e (try 1)
wlan3: authenticated
wlan3: associate with 00:23:69:35:d1:3e (try 1)
wlan3: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=3)
wlan3: associated
ADDRCONF(NETDEV_CHANGE): wlan3: link becomes ready
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
wlan1: authenticate with 00:23:69:35:d1:3f (try 2)
wlan1: authenticated
wlan1: associate with 00:23:69:35:d1:3f (try 1)
wlan1: associate with 00:23:69:35:d1:3f (try 2)
wlan1: associate with 00:23:69:35:d1:3f (try 3)
wlan1: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=1)
wlan1: associated
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
wlan2: no IPv6 routers present
wlan3: no IPv6 routers present
iwlagn 0000:a0:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
wlan1: no IPv6 routers present
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:a0:00.0: queue number out of range: 0, must be 10 to 19
iwlagn 0000:a0:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
wlan3: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
iwlagn 0000:a0:00.0: Stopping AGG while state not ON or starting
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
wlan3: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan3: authenticate with 00:23:69:35:d1:3f (try 1)
wlan3: authenticate with 00:23:69:35:d1:3f (try 2)
wlan3: authenticated
wlan3: associate with 00:23:69:35:d1:3f (try 1)
wlan3: associate with 00:23:69:35:d1:3f (try 2)
wlan3: associate with 00:23:69:35:d1:3f (try 3)
wlan3: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=2)
wlan3: associated
iwlagn 0000:a0:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:a0:00.0: Queue 11 stuck for 2000 ms.
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:a0:00.0: queue number out of range: 0, must be 10 to 19
wlan3: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
wlan3: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan3: authenticate with 00:23:69:35:d1:3f (try 1)
wlan3: authenticated
wlan3: associate with 00:23:69:35:d1:3f (try 1)
wlan3: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=1)
wlan3: associated
iwlagn 0000:a0:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:a0:00.0: queue number out of range: 0, must be 10 to 19
wlan2: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan2: authenticate with 00:23:69:35:d1:3f (try 1)
wlan2: authenticated
wlan2: associate with 00:23:69:35:d1:3f (try 1)
wlan2: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=2)
wlan2: associated
wlan3: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
iwlagn 0000:20:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:20:00.0: Received BA when not expected
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:20:00.0: Failing on timeout while stopping DMA channel 1 [0x07fd0003]
iwlagn 0000:20:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:20:00.0: queue number out of range: 0, must be 7 to 14
iwlagn 0000:20:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:20:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:20:00.0: queue number out of range: 0, must be 7 to 14
iwlagn 0000:20:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:20:00.0: Received BA when not expected
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:20:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:20:00.0: queue number out of range: 0, must be 7 to 14
iwlagn 0000:20:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:20:00.0: Received BA when not expected
wlan2: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan2: authenticate with 00:23:69:35:d1:3e (try 1)
wlan2: authenticated
wlan2: associate with 00:23:69:35:d1:3e (try 1)
wlan2: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=2)
wlan2: associated
iwlagn 0000:20:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
iwlagn 0000:20:00.0: Received BA when not expected
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
wlan1: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan1: authenticate with 00:23:69:35:d1:3e (try 1)
wlan1: authenticated
wlan1: associate with 00:23:69:35:d1:3e (try 1)
wlan1: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=2)
wlan1: associated
iwlagn 0000:80:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:80:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:80:00.0: queue number out of range: 0, must be 10 to 19
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:80:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
wlan1: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
wlan1: authenticate with 00:23:69:35:d1:3f (try 2)
wlan1: authenticate with 00:23:69:35:d1:3f (try 3)
wlan1: authenticated
wlan1: associate with 00:23:69:35:d1:3f (try 1)
wlan1: associate with 00:23:69:35:d1:3f (try 2)
wlan1: associate with 00:23:69:35:d1:3f (try 3)
wlan1: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=1)
wlan1: associated
iwlagn 0000:80:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:80:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:80:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:80:00.0: queue number out of range: 0, must be 10 to 19
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
wlan1: authenticate with 00:23:69:35:d1:3f (try 2)
wlan1: authenticated
wlan1: associate with 00:23:69:35:d1:3f (try 1)
wlan1: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=1)
wlan1: associated
iwlagn 0000:20:00.0: Error sending TX power (-5)
iwlagn 0000:20:00.0: PCI INT A disabled
iwlagn 0000:a0:00.0: PCI INT A disabled
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
iwlagn 0000:80:00.0: PCI INT A disabled
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:80:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
iwlagn 0000:80:00.0: setting latency timer to 64
iwlagn 0000:80:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
iwlagn 0000:80:00.0: device EEPROM VER=0x11f, CALIB=0x4
iwlagn 0000:80:00.0: Device SKU: 0Xb
iwlagn 0000:80:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:80:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:80:00.0: irq 90 for MSI/MSI-X
iwlagn 0000:a0:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
iwlagn 0000:a0:00.0: setting latency timer to 64
iwlagn 0000:a0:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
iwlagn 0000:80:00.0: loaded firmware version 8.24.2.12
Registered led device: phy0-led
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
iwlagn 0000:a0:00.0: device EEPROM VER=0x436, CALIB=0x6
iwlagn 0000:a0:00.0: Device SKU: 0Xb
iwlagn 0000:a0:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:a0:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:a0:00.0: irq 91 for MSI/MSI-X
iwlagn 0000:20:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
iwlagn 0000:20:00.0: setting latency timer to 64
iwlagn 0000:20:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
iwlagn 0000:a0:00.0: loaded firmware version 9.176.4.1 build 15835
Registered led device: phy1-led
iwlagn 0000:20:00.0: device EEPROM VER=0x36, CALIB=0x5
iwlagn 0000:20:00.0: Device SKU: 0Xb
iwlagn 0000:20:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
iwlagn 0000:20:00.0: irq 92 for MSI/MSI-X
ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'
udev: renamed network interface wlan0 to wlan1
iwlagn 0000:20:00.0: loaded firmware version 228.61.2.24
Registered led device: phy2-led
ieee80211 phy2: Selected rate control algorithm 'iwl-agn-rs'
udev: renamed network interface wlan0 to wlan3
ADDRCONF(NETDEV_UP): wlan1: link is not ready
ADDRCONF(NETDEV_UP): wlan3: link is not ready
ADDRCONF(NETDEV_UP): wlan2: link is not ready
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan2: authenticate with 00:23:69:35:d1:3e (try 1)
wlan2: authenticated
wlan2: associate with 00:23:69:35:d1:3e (try 1)
wlan2: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=2)
wlan2: associated
ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
wlan1: authenticate with 00:23:69:35:d1:3f (try 2)
wlan1: authenticated
wlan1: associate with 00:23:69:35:d1:3f (try 1)
wlan1: associate with 00:23:69:35:d1:3f (try 2)
iwlagn 0000:20:00.0: Error sending TX power (-5)
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
iwlagn 0000:20:00.0: Error sending TX power (-5)
iwlagn 0000:20:00.0: PCI INT A disabled
wlan1: associate with 00:23:69:35:d1:3f (try 3)
wlan1: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=1)
wlan1: associated
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
iwlagn 0000:a0:00.0: PCI INT A disabled
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
iwlagn 0000:80:00.0: PCI INT A disabled
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:80:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
iwlagn 0000:80:00.0: setting latency timer to 64
iwlagn 0000:80:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
iwlagn 0000:80:00.0: device EEPROM VER=0x11f, CALIB=0x4
iwlagn 0000:80:00.0: Device SKU: 0Xb
iwlagn 0000:80:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:80:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:80:00.0: irq 90 for MSI/MSI-X
iwlagn 0000:a0:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
iwlagn 0000:a0:00.0: setting latency timer to 64
iwlagn 0000:a0:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
iwlagn 0000:a0:00.0: device EEPROM VER=0x436, CALIB=0x6
iwlagn 0000:a0:00.0: Device SKU: 0Xb
iwlagn 0000:a0:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:a0:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:a0:00.0: irq 91 for MSI/MSI-X
iwlagn 0000:20:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
iwlagn 0000:20:00.0: setting latency timer to 64
iwlagn 0000:20:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
iwlagn 0000:80:00.0: loaded firmware version 8.24.2.12
Registered led device: phy0-led
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
iwlagn 0000:a0:00.0: loaded firmware version 9.176.4.1 build 15835
Registered led device: phy1-led
ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
iwlagn 0000:20:00.0: device EEPROM VER=0x36, CALIB=0x5
iwlagn 0000:20:00.0: Device SKU: 0Xb
iwlagn 0000:20:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
iwlagn 0000:20:00.0: irq 92 for MSI/MSI-X
udev: renamed network interface wlan1 to wlan3
udev: renamed network interface wlan0 to wlan1
iwlagn 0000:20:00.0: loaded firmware version 228.61.2.24
Registered led device: phy2-led
ieee80211 phy2: Selected rate control algorithm 'iwl-agn-rs'
udev: renamed network interface wlan0 to wlan2
ADDRCONF(NETDEV_UP): wlan3: link is not ready
ADDRCONF(NETDEV_UP): wlan1: link is not ready
ADDRCONF(NETDEV_UP): wlan2: link is not ready
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan2: authenticate with 00:23:69:35:d1:3e (try 1)
wlan2: authenticated
wlan2: waiting for beacon from 00:23:69:35:d1:3e
wlan2: beacon received
wlan2: associate with 00:23:69:35:d1:3e (try 1)
wlan2: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=2)
wlan2: associated
ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
wlan3: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan3: authenticate with 00:23:69:35:d1:3f (try 1)
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan3: authenticate with 00:23:69:35:d1:3f (try 2)
wlan3: authenticated
wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
wlan3: associate with 00:23:69:35:d1:3f (try 1)
wlan1: authenticate with 00:23:69:35:d1:3f (try 2)
wlan1: authenticated
wlan1: associate with 00:23:69:35:d1:3f (try 1)
wlan3: associate with 00:23:69:35:d1:3f (try 2)
wlan3: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=1)
wlan3: associated
ADDRCONF(NETDEV_CHANGE): wlan3: link becomes ready
wlan1: associate with 00:23:69:35:d1:3f (try 2)
wlan1: associate with 00:23:69:35:d1:3f (try 3)
wlan1: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=2)
wlan1: associated
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
wlan2: no IPv6 routers present
wlan1: no IPv6 routers present
wlan3: no IPv6 routers present
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan3: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
wlan3: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan3: authenticate with 00:23:69:35:d1:3e (try 1)
wlan3: authenticated
wlan3: associate with 00:23:69:35:d1:3e (try 1)
wlan3: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=2)
wlan3: associated
iwlagn 0000:a0:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
iwlagn 0000:80:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: On demand firmware reload
iwlagn 0000:20:00.0: On demand firmware reload
iwlagn 0000:a0:00.0: Stopping AGG while state not ON or starting
iwlagn 0000:a0:00.0: queue number out of range: 0, must be 10 to 19
iwlagn 0000:a0:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
iwlagn 0000:20:00.0: Error sending TX power (-5)
iwlagn 0000:20:00.0: PCI INT A disabled
wlan3: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:259 debug_print_object+0x65/0x70()
Hardware name: HP xw8600 Workstation
ODEBUG: free active (active state 0) object type: timer_list name &ifmgd->conn_mon_timer
Modules linked in: iwlagn(-) iwlcore mac80211 cfg80211 aes_x86_64 aes_generic fuse cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod uinput hp_wmi sparse_keymap sg wmi arc4 microcode serio_raw ecb tg3 shpchp rfkill ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif firewire_ohci firewire_core crc_itu_t mptsas mptscsih mptbase scsi_transport_sas ahci libahci pata_acpi ata_generic ata_piix floppy nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: cfg80211]
Pid: 11328, comm: rmmod Not tainted 2.6.38-rc4-wl+ #22
Call Trace:
 [<ffffffff810649cf>] ? warn_slowpath_common+0x7f/0xc0
 [<ffffffff81064ac6>] ? warn_slowpath_fmt+0x46/0x50
 [<ffffffff81226fc5>] ? debug_print_object+0x65/0x70
 [<ffffffff81227625>] ? debug_check_no_obj_freed+0x125/0x210
 [<ffffffff8109ebd7>] ? debug_check_no_locks_freed+0xf7/0x170
 [<ffffffff81156092>] ? kfree+0xc2/0x2f0
 [<ffffffff813ec5c5>] ? netdev_release+0x45/0x60
 [<ffffffff812f1067>] ? device_release+0x27/0xa0
 [<ffffffff81216ddd>] ? kobject_release+0x8d/0x1a0
 [<ffffffff81216d50>] ? kobject_release+0x0/0x1a0
 [<ffffffff812183b7>] ? kref_put+0x37/0x70
 [<ffffffff81216c57>] ? kobject_put+0x27/0x60
 [<ffffffff813d5d1b>] ? netdev_run_todo+0x1ab/0x270
 [<ffffffff813e771e>] ? rtnl_unlock+0xe/0x10
 [<ffffffffa0529188>] ? ieee80211_unregister_hw+0x58/0x120 [mac80211]
 [<ffffffffa05e2ed7>] ? iwl_pci_remove+0xdb/0x22a [iwlagn]
 [<ffffffff8123cde2>] ? pci_device_remove+0x52/0x120
 [<ffffffff812f5205>] ? __device_release_driver+0x75/0xe0
 [<ffffffff812f5348>] ? driver_detach+0xd8/0xe0
 [<ffffffff812f4111>] ? bus_remove_driver+0x91/0x100
 [<ffffffff812f5b62>] ? driver_unregister+0x62/0xa0
 [<ffffffff8123d194>] ? pci_unregister_driver+0x44/0xa0
 [<ffffffffa05e2df5>] ? iwl_exit+0x15/0x1c [iwlagn]
 [<ffffffff810ab492>] ? sys_delete_module+0x1a2/0x270
 [<ffffffff81498889>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100bf42>] ? system_call_fastpath+0x16/0x1b
---[ end trace 4a63debfcb76796d ]---
iwlagn 0000:a0:00.0: PCI INT A disabled
iwlagn 0000:80:00.0: PCI INT A disabled
tar used greatest stack depth: 3312 bytes left
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:80:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
iwlagn 0000:80:00.0: setting latency timer to 64
iwlagn 0000:80:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
iwlagn 0000:80:00.0: device EEPROM VER=0x11f, CALIB=0x4
iwlagn 0000:80:00.0: Device SKU: 0Xb
iwlagn 0000:80:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:80:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:80:00.0: irq 90 for MSI/MSI-X
iwlagn 0000:a0:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
iwlagn 0000:a0:00.0: setting latency timer to 64
iwlagn 0000:a0:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
iwlagn 0000:a0:00.0: device EEPROM VER=0x436, CALIB=0x6
iwlagn 0000:a0:00.0: Device SKU: 0Xb
iwlagn 0000:a0:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:a0:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:a0:00.0: irq 91 for MSI/MSI-X
iwlagn 0000:20:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
iwlagn 0000:20:00.0: setting latency timer to 64
iwlagn 0000:20:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
iwlagn 0000:80:00.0: loaded firmware version 8.24.2.12
Registered led device: phy0-led
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
iwlagn 0000:a0:00.0: loaded firmware version 9.176.4.1 build 15835
Registered led device: phy1-led
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
iwlagn 0000:20:00.0: device EEPROM VER=0x36, CALIB=0x5
iwlagn 0000:20:00.0: Device SKU: 0Xb
iwlagn 0000:20:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
iwlagn 0000:20:00.0: irq 92 for MSI/MSI-X
ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'
udev: renamed network interface wlan0 to wlan1
iwlagn 0000:20:00.0: loaded firmware version 228.61.2.24
Registered led device: phy2-led
ieee80211 phy2: Selected rate control algorithm 'iwl-agn-rs'
udev: renamed network interface wlan0 to wlan3
udev: renamed network interface wlan0 to wlan2
ADDRCONF(NETDEV_UP): wlan1: link is not ready
ADDRCONF(NETDEV_UP): wlan3: link is not ready
ADDRCONF(NETDEV_UP): wlan2: link is not ready
wlan2: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan2: authenticate with 00:23:69:35:d1:3f (try 1)
wlan2: authenticated
wlan2: associate with 00:23:69:35:d1:3f (try 1)
wlan2: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=1)
wlan2: associated
ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
wlan1: authenticate with 00:23:69:35:d1:3f (try 2)
wlan1: authenticated
wlan1: associate with 00:23:69:35:d1:3f (try 1)
wlan3: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan1: associate with 00:23:69:35:d1:3f (try 2)
wlan3: authenticate with 00:23:69:35:d1:3f (try 1)
wlan1: associate with 00:23:69:35:d1:3f (try 3)
wlan1: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=2)
wlan1: associated
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
wlan3: authenticate with 00:23:69:35:d1:3f (try 2)
wlan3: authenticated
wlan3: associate with 00:23:69:35:d1:3f (try 1)
wlan3: associate with 00:23:69:35:d1:3f (try 2)
wlan3: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=3)
wlan3: associated
ADDRCONF(NETDEV_CHANGE): wlan3: link becomes ready
wlan2: no IPv6 routers present
wlan1: no IPv6 routers present
wlan3: no IPv6 routers present
iwlagn 0000:80:00.0: Aggregation not enabled for tid 0 because load = 3
iwlagn 0000:80:00.0: Aggregation not enabled for tid 0 because load = 10
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan2: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
iwlagn 0000:a0:00.0: Aggregation not enabled for tid 0 because load = 5
iwlagn 0000:a0:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
wlan1: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan1: authenticate with 00:23:69:35:d1:3e (try 1)
wlan1: authenticated
wlan1: associate with 00:23:69:35:d1:3e (try 1)
wlan1: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=1)
wlan1: associated
iwlagn 0000:80:00.0: Aggregation not enabled for tid 0 because load = 0
iwlagn 0000:80:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
iwlagn 0000:20:00.0: Error sending TX power (-5)
iwlagn 0000:20:00.0: PCI INT A disabled
wlan3: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
iwlagn 0000:a0:00.0: PCI INT A disabled
wlan1: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
iwlagn 0000:80:00.0: Stopping AGG while state not ON or starting
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
iwlagn 0000:80:00.0: PCI INT A disabled
Slab corruption: size-8192 start=ffff8800379f2000, len=8192
1cd0: d0 3c 9f 37 00 88 ff ff d0 3c 9f 37 00 88 ff ff
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:80:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
iwlagn 0000:80:00.0: setting latency timer to 64
iwlagn 0000:80:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
iwlagn 0000:80:00.0: device EEPROM VER=0x11f, CALIB=0x4
iwlagn 0000:80:00.0: Device SKU: 0Xb
iwlagn 0000:80:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:80:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:80:00.0: irq 90 for MSI/MSI-X
iwlagn 0000:a0:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
iwlagn 0000:a0:00.0: setting latency timer to 64
iwlagn 0000:a0:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
iwlagn 0000:a0:00.0: device EEPROM VER=0x436, CALIB=0x6
iwlagn 0000:a0:00.0: Device SKU: 0Xb
iwlagn 0000:a0:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:a0:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:a0:00.0: irq 91 for MSI/MSI-X
iwlagn 0000:20:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
iwlagn 0000:20:00.0: setting latency timer to 64
iwlagn 0000:20:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
iwlagn 0000:80:00.0: loaded firmware version 8.24.2.12
Registered led device: phy0-led
ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
iwlagn 0000:a0:00.0: loaded firmware version 9.176.4.1 build 15835
Registered led device: phy1-led
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
iwlagn 0000:20:00.0: device EEPROM VER=0x36, CALIB=0x5
iwlagn 0000:20:00.0: Device SKU: 0Xb
iwlagn 0000:20:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
iwlagn 0000:20:00.0: irq 92 for MSI/MSI-X
ieee80211 phy1: Selected rate control algorithm 'iwl-agn-rs'
udev: renamed network interface wlan0 to wlan1
iwlagn 0000:20:00.0: loaded firmware version 228.61.2.24
Registered led device: phy2-led
ieee80211 phy2: Selected rate control algorithm 'iwl-agn-rs'
udev: renamed network interface wlan0 to wlan3
ADDRCONF(NETDEV_UP): wlan1: link is not ready
ADDRCONF(NETDEV_UP): wlan2: link is not ready
ADDRCONF(NETDEV_UP): wlan3: link is not ready
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan2: authenticate with 00:23:69:35:d1:3e (try 1)
wlan2: authenticated
wlan2: associate with 00:23:69:35:d1:3e (try 1)
wlan2: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=1)
wlan2: associated
ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
wlan1: authenticate with 00:23:69:35:d1:3f (try 2)
wlan1: authenticated
wlan1: associate with 00:23:69:35:d1:3f (try 1)
wlan1: associate with 00:23:69:35:d1:3f (try 2)
wlan3: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan1: associate with 00:23:69:35:d1:3f (try 3)
wlan1: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=1)
wlan1: associated
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
wlan3: authenticate with 00:23:69:35:d1:3e (try 1)
wlan3: authenticated
wlan3: associate with 00:23:69:35:d1:3e (try 1)
wlan3: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=2)
wlan3: associated
ADDRCONF(NETDEV_CHANGE): wlan3: link becomes ready
wlan2: no IPv6 routers present
wlan1: no IPv6 routers present
wlan3: no IPv6 routers present
iwlagn 0000:80:00.0: Aggregation not enabled for tid 0 because load = 1
iwlagn 0000:80:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
iwlagn 0000:a0:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3e tid = 0
iwlagn 0000:20:00.0: Error sending TX power (-5)
iwlagn 0000:20:00.0: PCI INT A disabled
wlan3: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
iwlagn 0000:a0:00.0: Stopping AGG while state not ON or starting
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: CZ
cfg80211: Regulatory domain changed to country: CZ
cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:259 debug_print_object+0x65/0x70()
Hardware name: HP xw8600 Workstation
ODEBUG: free active (active state 0) object type: timer_list name &ifmgd->conn_mon_timer
Modules linked in: iwlagn(-) iwlcore mac80211 cfg80211 aes_x86_64 aes_generic fuse cpufreq_ondemand acpi_cpufreq freq_table mperf xt_physdev ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 ext3 jbd dm_mirror dm_region_hash dm_log dm_mod uinput hp_wmi sparse_keymap sg wmi arc4 microcode serio_raw ecb tg3 shpchp rfkill ext4 mbcache jbd2 sr_mod cdrom sd_mod crc_t10dif firewire_ohci firewire_core crc_itu_t mptsas mptscsih mptbase scsi_transport_sas ahci libahci pata_acpi ata_generic ata_piix floppy nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: cfg80211]
Pid: 13827, comm: rmmod Tainted: G        W   2.6.38-rc4-wl+ #22
Call Trace:
 [<ffffffff810649cf>] ? warn_slowpath_common+0x7f/0xc0
 [<ffffffff81064ac6>] ? warn_slowpath_fmt+0x46/0x50
 [<ffffffff81226fc5>] ? debug_print_object+0x65/0x70
 [<ffffffff81227625>] ? debug_check_no_obj_freed+0x125/0x210
 [<ffffffff8109ebd7>] ? debug_check_no_locks_freed+0xf7/0x170
 [<ffffffff81156092>] ? kfree+0xc2/0x2f0
 [<ffffffff813ec5c5>] ? netdev_release+0x45/0x60
 [<ffffffff812f1067>] ? device_release+0x27/0xa0
 [<ffffffff81216ddd>] ? kobject_release+0x8d/0x1a0
 [<ffffffff81216d50>] ? kobject_release+0x0/0x1a0
 [<ffffffff812183b7>] ? kref_put+0x37/0x70
 [<ffffffff81216c57>] ? kobject_put+0x27/0x60
 [<ffffffff813d5d1b>] ? netdev_run_todo+0x1ab/0x270
 [<ffffffff813e771e>] ? rtnl_unlock+0xe/0x10
 [<ffffffffa0581188>] ? ieee80211_unregister_hw+0x58/0x120 [mac80211]
 [<ffffffffa0377ed7>] ? iwl_pci_remove+0xdb/0x22a [iwlagn]
 [<ffffffff8123cde2>] ? pci_device_remove+0x52/0x120
 [<ffffffff812f5205>] ? __device_release_driver+0x75/0xe0
 [<ffffffff812f5348>] ? driver_detach+0xd8/0xe0
 [<ffffffff812f4111>] ? bus_remove_driver+0x91/0x100
 [<ffffffff812f5b62>] ? driver_unregister+0x62/0xa0
 [<ffffffff8123d194>] ? pci_unregister_driver+0x44/0xa0
 [<ffffffffa0377df5>] ? iwl_exit+0x15/0x1c [iwlagn]
 [<ffffffff810ab492>] ? sys_delete_module+0x1a2/0x270
 [<ffffffff81498889>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100bf42>] ? system_call_fastpath+0x16/0x1b
---[ end trace 4a63debfcb76796e ]---
iwlagn 0000:a0:00.0: PCI INT A disabled
iwlagn 0000:80:00.0: PCI INT A disabled
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:80:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
iwlagn 0000:80:00.0: setting latency timer to 64
iwlagn 0000:80:00.0: Detected Intel(R) Ultimate N WiFi Link 5300 AGN, REV=0x24
iwlagn 0000:80:00.0: device EEPROM VER=0x11f, CALIB=0x4
iwlagn 0000:80:00.0: Device SKU: 0Xb
iwlagn 0000:80:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:80:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:80:00.0: irq 90 for MSI/MSI-X
iwlagn 0000:a0:00.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
iwlagn 0000:a0:00.0: setting latency timer to 64
iwlagn 0000:a0:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
iwlagn 0000:a0:00.0: device EEPROM VER=0x436, CALIB=0x6
iwlagn 0000:a0:00.0: Device SKU: 0Xb
iwlagn 0000:a0:00.0: Valid Tx ant: 0X7, Valid Rx ant: 0X7
iwlagn 0000:a0:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:a0:00.0: irq 91 for MSI/MSI-X
iwlagn 0000:20:00.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
iwlagn 0000:20:00.0: setting latency timer to 64
iwlagn 0000:20:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=0x4
iwlagn 0000:80:00.0: loaded firmware version 8.24.2.12
Registered led device: phy3-led
ieee80211 phy3: Selected rate control algorithm 'iwl-agn-rs'
iwlagn 0000:a0:00.0: loaded firmware version 9.176.4.1 build 15835
Registered led device: phy4-led
ieee80211 phy4: Selected rate control algorithm 'iwl-agn-rs'
iwlagn 0000:20:00.0: device EEPROM VER=0x36, CALIB=0x5
iwlagn 0000:20:00.0: Device SKU: 0Xb
iwlagn 0000:20:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
iwlagn 0000:20:00.0: irq 92 for MSI/MSI-X
udev: renamed network interface wlan0 to wlan0-wlan1
udev: renamed network interface wlan1 to wlan3
iwlagn 0000:20:00.0: loaded firmware version 228.61.2.24
Registered led device: phy5-led
udev: renamed network interface wlan0-wlan1 to wlan1
ieee80211 phy5: Selected rate control algorithm 'iwl-agn-rs'
udev: renamed network interface wlan0 to wlan2
ADDRCONF(NETDEV_UP): wlan3: link is not ready
ADDRCONF(NETDEV_UP): wlan1: link is not ready
ADDRCONF(NETDEV_UP): wlan2: link is not ready
wlan2: deauthenticating from 00:23:69:35:d1:3e by local choice (reason=3)
wlan2: authenticate with 00:23:69:35:d1:3e (try 1)
wlan2: authenticated
wlan2: associate with 00:23:69:35:d1:3e (try 1)
wlan2: RX AssocResp from 00:23:69:35:d1:3e (capab=0x411 status=0 aid=1)
wlan2: associated
ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
wlan3: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan3: authenticate with 00:23:69:35:d1:3f (try 1)
wlan1: deauthenticating from 00:23:69:35:d1:3f by local choice (reason=3)
wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
wlan3: authenticate with 00:23:69:35:d1:3f (try 2)
wlan3: authenticated
wlan3: associate with 00:23:69:35:d1:3f (try 1)
wlan1: authenticate with 00:23:69:35:d1:3f (try 2)
wlan1: authenticated
wlan1: associate with 00:23:69:35:d1:3f (try 1)
wlan3: associate with 00:23:69:35:d1:3f (try 2)
wlan3: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=1)
wlan3: associated
ADDRCONF(NETDEV_CHANGE): wlan3: link becomes ready
wlan1: associate with 00:23:69:35:d1:3f (try 2)
wlan1: associate with 00:23:69:35:d1:3f (try 3)
wlan1: RX AssocResp from 00:23:69:35:d1:3f (capab=0x11 status=0 aid=2)
wlan1: associated
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
wlan2: no IPv6 routers present
wlan3: no IPv6 routers present
wlan1: no IPv6 routers present



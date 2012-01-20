Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp21.services.sfr.fr ([93.17.128.4]:1853 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2ATOHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 09:07:15 -0500
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2114.sfr.fr (SMTP Server) with ESMTP id AC6E67000055
	for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2012 14:54:55 +0100 (CET)
Received: from [192.168.0.10] (85-168-238-59.rev.numericable.fr [85.168.238.59])
	by msfrf2114.sfr.fr (SMTP Server) with ESMTP id D3A0C7000088
	for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2012 14:54:54 +0100 (CET)
Message-ID: <1327067694.2590.6.camel@milan> (sfid-20120120_150724_732681_C2515F6E)
Subject: BCM4313 doesn't work after suspend (brcmsmac on
 compat-wireless-next)
From: Milan Bouchet-Valat <nalimilan@club.fr>
To: linux-wireless@vger.kernel.org
Date: Fri, 20 Jan 2012 14:54:54 +0100
Content-Type: multipart/mixed; boundary="=-2HpOzPoUAaf+rqqHxVvK"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2HpOzPoUAaf+rqqHxVvK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi!

With kernels 3.2 and 3.2.1, my Broadcom 4313 wireless card doesn't work
after suspend: I need to reload the brcmsmac module by hand on resume.
It worked fine with 3.1 kernels.

So I tried compat-wireless-next today (on Fedora 16), and it still
doesn't work, though instead of oopses I get warnings. ;-)

The error messages are:
[  165.612939] ieee80211 phy0: wl0: wlc_coreinit: ucode did not self-suspend!
[  165.751978] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS
and MI_MACSSPNDD is still not on.
[  165.751989] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000031,
psm_brc 0x0000

(the two latter repeated many times, see attached dmesg.log)

Please ask for any details you may need (output of lspci -vnn is
attached too, just in case).


PS: Please keep me in CC, as I'm not subscribed to the list

--=-2HpOzPoUAaf+rqqHxVvK
Content-Disposition: attachment; filename="dmesg.log"
Content-Type: text/x-log; name="dmesg.log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.9-1.fc16.x86_64 (mockbuild@x86-15.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Fri Jan 13 16:37:42 UTC 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.1.9-1.fc16.x86_64 root=UUID=2949b379-bd76-4ed6-a2be-12a1bc4634c5 ro acpi_osi=Linux acpi_backlight=vendor rd.md=0 rd.lvm=0 rd.dm=0 quiet LANG=fr_FR.UTF-8 SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 KEYTABLE=fr
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
[    0.000000]  BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000009b63f000 (usable)
[    0.000000]  BIOS-e820: 000000009b63f000 - 000000009b6bf000 (reserved)
[    0.000000]  BIOS-e820: 000000009b6bf000 - 000000009b7bf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000009b7bf000 - 000000009b7ff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000009b7ff000 - 000000009b800000 (usable)
[    0.000000]  BIOS-e820: 000000009b800000 - 00000000a0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000feb00000 - 00000000feb04000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1b000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000158000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Hewlett-Packard HP Pavilion dm4 Notebook PC     /146A, BIOS F.11 07/08/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x158000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-combining
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   2 base 080000000 mask FE0000000 write-back
[    0.000000]   3 base 09C000000 mask FFC000000 uncachable
[    0.000000]   4 base 09B800000 mask FFF800000 uncachable
[    0.000000]   5 base 100000000 mask F80000000 write-back
[    0.000000]   6 base 158000000 mask FF8000000 uncachable
[    0.000000]   7 base 160000000 mask FE0000000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0x9b800 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-000000009b800000
[    0.000000]  0000000000 - 009b800000 page 2M
[    0.000000] kernel direct mapping tables up to 9b800000 @ 1fffc000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000158000000
[    0.000000]  0100000000 - 0158000000 page 2M
[    0.000000] kernel direct mapping tables up to 158000000 @ 9b638000-9b63f000
[    0.000000] RAMDISK: 35e40000 - 36f18000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 HP    )
[    0.000000] ACPI: XSDT 000000009b7fe120 0008C (v01 HPQOEM SLIC-MPC 00000001      01000013)
[    0.000000] ACPI: FACP 000000009b7fc000 000F4 (v04 HP     SLIC-MPC 00000001 MSFT 01000013)
[    0.000000] ACPI: DSDT 000000009b7e9000 0F812 (v02 HP     SLIC-MPC 00000001 MSFT 01000013)
[    0.000000] ACPI: FACS 000000009b75f000 00040
[    0.000000] ACPI: ASF! 000000009b7fd000 000A5 (v32 HP     SLIC-MPC 00000001 MSFT 01000013)
[    0.000000] ACPI: HPET 000000009b7fb000 00038 (v01 HP     SLIC-MPC 00000001 MSFT 01000013)
[    0.000000] ACPI: APIC 000000009b7fa000 0008C (v02 HP     SLIC-MPC 00000001 MSFT 01000013)
[    0.000000] ACPI: MCFG 000000009b7f9000 0003C (v01 HP     SLIC-MPC 00000001 MSFT 01000013)
[    0.000000] ACPI: SLIC 000000009b7e8000 00176 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000009b7e6000 01152 (v01 TrmRef PtidDevc 00001000 INTL 20051117)
[    0.000000] ACPI: SSDT 000000009b7e5000 00172 (v01  VaRef  Va_Acpi 00003000 INTL 20051117)
[    0.000000] ACPI: BOOT 000000009b7e4000 00028 (v01 HP     SLIC-MPC 00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000009b7e3000 00C39 (v01 INTEL   SataPri 00001000 INTL 20051117)
[    0.000000] ACPI: SSDT 000000009b7e2000 006C5 (v01 INTEL   SataSec 00001000 INTL 20051117)
[    0.000000] ACPI: ASPT 000000009b7e1000 00034 (v04 HP     SLIC-MPC 00000001 MSFT 01000013)
[    0.000000] ACPI: SSDT 000000009b7e0000 009F1 (v01  PmRef    CpuPm 00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000158000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000158000000
[    0.000000]   NODE_DATA [0000000157fec000 - 0000000157ffffff]
[    0.000000]  [ffffea0000000000-ffffea00055fffff] PMD -> [ffff880153800000-ffff8801575fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00158000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0009b63f
[    0.000000]     0: 0x0009b7ff -> 0x0009b800
[    0.000000]     0: 0x00100000 -> 0x00158000
[    0.000000] On node 0 totalpages: 996813
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 616064 pages, LIFO batch:31
[    0.000000]   Normal zone: 5632 pages used for memmap
[    0.000000]   Normal zone: 354816 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000009b63f000 - 000000009b6bf000
[    0.000000] PM: Registered nosave memory: 000000009b6bf000 - 000000009b7bf000
[    0.000000] PM: Registered nosave memory: 000000009b7bf000 - 000000009b7ff000
[    0.000000] PM: Registered nosave memory: 000000009b800000 - 00000000a0000000
[    0.000000] PM: Registered nosave memory: 00000000a0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000feb00000
[    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000feb04000
[    0.000000] PM: Registered nosave memory: 00000000feb04000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1b000
[    0.000000] PM: Registered nosave memory: 00000000fed1b000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at a0000000 (gap: a0000000:40000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880157c00000 s81536 r8192 d20864 u262144
[    0.000000] pcpu-alloc: s81536 r8192 d20864 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 974792
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.1.9-1.fc16.x86_64 root=UUID=2949b379-bd76-4ed6-a2be-12a1bc4634c5 ro acpi_osi=Linux acpi_backlight=vendor rd.md=0 rd.lvm=0 rd.dm=0 quiet LANG=fr_FR.UTF-8 SYSFONT=latarcyrheb-sun16 rhgb rd.luks=0 KEYTABLE=fr
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3825132k/5636096k available (6024k kernel code, 1648844k absent, 162120k reserved, 5657k data, 964k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:16640 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 32505856 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2394.472 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.94 BogoMIPS (lpj=2394472)
[    0.000007] pid_max: default: 32768 minimum: 301
[    0.000028] Security Framework initialized
[    0.000039] SELinux:  Initializing.
[    0.000046] SELinux:  Starting in permissive mode
[    0.000447] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.001540] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.001987] Mount-cache hash table entries: 256
[    0.002117] Initializing cgroup subsys cpuacct
[    0.002122] Initializing cgroup subsys memory
[    0.002131] Initializing cgroup subsys devices
[    0.002134] Initializing cgroup subsys freezer
[    0.002136] Initializing cgroup subsys net_cls
[    0.002137] Initializing cgroup subsys blkio
[    0.002142] Initializing cgroup subsys perf_event
[    0.002189] CPU: Physical Processor ID: 0
[    0.002190] CPU: Processor Core ID: 0
[    0.002197] mce: CPU supports 9 MCE banks
[    0.002206] CPU0: Thermal monitoring handled by SMI
[    0.002213] using mwait in idle threads.
[    0.003326] ACPI: Core revision 20110623
[    0.029584] ftrace: allocating 22701 entries in 90 pages
[    0.036391] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.046379] CPU0: Intel(R) Core(TM) i5 CPU       M 450  @ 2.40GHz stepping 05
[    0.147905] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.147912] ... version:                3
[    0.147913] ... bit width:              48
[    0.147914] ... generic registers:      4
[    0.147915] ... value mask:             0000ffffffffffff
[    0.147916] ... max period:             000000007fffffff
[    0.147917] ... fixed-purpose events:   3
[    0.147918] ... event mask:             000000070000000f
[    0.148413] NMI watchdog enabled, takes one hw-pmu counter.
[    0.148494] Booting Node   0, Processors  #1
[    0.148496] smpboot cpu 1: start_ip = 98000
[    0.218803] CPU1: Thermal monitoring handled by SMI
[    0.238890] NMI watchdog enabled, takes one hw-pmu counter.
[    0.239002]  #2
[    0.239004] smpboot cpu 2: start_ip = 98000
[    0.309638] CPU2: Thermal monitoring handled by SMI
[    0.329740] NMI watchdog enabled, takes one hw-pmu counter.
[    0.329839]  #3
[    0.329840] smpboot cpu 3: start_ip = 98000
[    0.400477] CPU3: Thermal monitoring handled by SMI
[    0.420569] NMI watchdog enabled, takes one hw-pmu counter.
[    0.420609] Brought up 4 CPUs
[    0.420611] Total of 4 processors activated (19152.18 BogoMIPS).
[    0.422771] devtmpfs: initialized
[    0.423601] PM: Registering ACPI NVS region at 9b6bf000 (1048576 bytes)
[    0.424273] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.424304] RTC time: 14:42:50, date: 01/20/12
[    0.424334] NET: Registered protocol family 16
[    0.424474] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.424476] ACPI: bus type pci registered
[    0.424547] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.424551] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.455649] PCI: Using configuration type 1 for base access
[    0.456376] bio: create slab <bio-0> at 0
[    0.456442] ACPI: Added _OSI(Module Device)
[    0.456444] ACPI: Added _OSI(Processor Device)
[    0.456446] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.456447] ACPI: Added _OSI(Processor Aggregator Device)
[    0.456448] ACPI: Added _OSI(Linux)
[    0.458174] ACPI: EC: Look up EC in DSDT
[    0.459854] ACPI: Executed 1 blocks of module-level executable AML code
[    0.468394] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via cmdline
[    0.473595] ACPI: SSDT 000000009b691a18 00484 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.474008] ACPI: Dynamic OEM Table Load:
[    0.474010] ACPI: SSDT           (null) 00484 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.474172] ACPI: SSDT 000000009b68f018 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.474575] ACPI: Dynamic OEM Table Load:
[    0.474577] ACPI: SSDT           (null) 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.480622] ACPI: SSDT 000000009b690a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.481076] ACPI: Dynamic OEM Table Load:
[    0.481078] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.483495] ACPI: SSDT 000000009b68ed98 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.483916] ACPI: Dynamic OEM Table Load:
[    0.483918] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.489958] ACPI: EC: GPE storm detected, transactions will use polling mode
[    0.946743] ACPI: Interpreter enabled
[    0.946747] ACPI: (supports S0 S3 S4 S5)
[    0.946782] ACPI: Using IOAPIC for interrupt routing
[    0.947447] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.962263] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.963684] ACPI: Power Resource [FN00] (on)
[    0.964064] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.964263] ACPI: No dock devices found.
[    0.964264] HEST: Table not found.
[    0.964267] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.964569] \_SB_.PCI0:_OSC invalid UUID
[    0.964570] _OSC request data:1 8 1f 
[    0.964574] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.965080] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.965082] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.965084] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.965086] pci_root PNP0A08:00: host bridge window [mem 0xa0000000-0xfeafffff]
[    0.965097] pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
[    0.965114] DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics
[    0.965131] pci 0000:00:02.0: [8086:0046] type 0 class 0x000300
[    0.965140] pci 0000:00:02.0: reg 10: [mem 0xb0000000-0xb03fffff 64bit]
[    0.965146] pci 0000:00:02.0: reg 18: [mem 0xa0000000-0xafffffff 64bit pref]
[    0.965150] pci 0000:00:02.0: reg 20: [io  0x3050-0x3057]
[    0.965203] pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
[    0.965230] pci 0000:00:16.0: reg 10: [mem 0xb4406100-0xb440610f 64bit]
[    0.965303] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.965307] pci 0000:00:16.0: PME# disabled
[    0.965340] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    0.965613] pci 0000:00:1a.0: reg 10: [mem 0xb4405c00-0xb4405fff]
[    0.967143] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.967147] pci 0000:00:1a.0: PME# disabled
[    0.967170] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    0.967183] pci 0000:00:1b.0: reg 10: [mem 0xb4400000-0xb4403fff 64bit]
[    0.967231] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.967235] pci 0000:00:1b.0: PME# disabled
[    0.967253] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    0.967302] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.967305] pci 0000:00:1c.0: PME# disabled
[    0.967324] pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
[    0.967375] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.967378] pci 0000:00:1c.1: PME# disabled
[    0.967408] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    0.967674] pci 0000:00:1d.0: reg 10: [mem 0xb4405800-0xb4405bff]
[    0.969208] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.969212] pci 0000:00:1d.0: PME# disabled
[    0.969231] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.969283] pci 0000:00:1f.0: [8086:3b09] type 0 class 0x000601
[    0.969390] pci 0000:00:1f.2: [8086:3b29] type 0 class 0x000106
[    0.969413] pci 0000:00:1f.2: reg 10: [io  0x3048-0x304f]
[    0.969422] pci 0000:00:1f.2: reg 14: [io  0x305c-0x305f]
[    0.969430] pci 0000:00:1f.2: reg 18: [io  0x3040-0x3047]
[    0.969439] pci 0000:00:1f.2: reg 1c: [io  0x3058-0x305b]
[    0.969449] pci 0000:00:1f.2: reg 20: [io  0x3020-0x303f]
[    0.969458] pci 0000:00:1f.2: reg 24: [mem 0xb4405000-0xb44057ff]
[    0.969498] pci 0000:00:1f.2: PME# supported from D3hot
[    0.969502] pci 0000:00:1f.2: PME# disabled
[    0.969520] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    0.969534] pci 0000:00:1f.3: reg 10: [mem 0xb4406000-0xb44060ff 64bit]
[    0.969553] pci 0000:00:1f.3: reg 20: [io  0x3000-0x301f]
[    0.969588] pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
[    0.969608] pci 0000:00:1f.6: reg 10: [mem 0xb4404000-0xb4404fff 64bit]
[    0.969721] pci 0000:01:00.0: [10ec:8168] type 0 class 0x000200
[    0.969737] pci 0000:01:00.0: reg 10: [io  0x2000-0x20ff]
[    0.969763] pci 0000:01:00.0: reg 18: [mem 0xb0404000-0xb0404fff 64bit pref]
[    0.969780] pci 0000:01:00.0: reg 20: [mem 0xb0400000-0xb0403fff 64bit pref]
[    0.969825] pci 0000:01:00.0: supports D1 D2
[    0.969827] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.969831] pci 0000:01:00.0: PME# disabled
[    0.971605] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.971612] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.971617] pci 0000:00:1c.0:   bridge window [mem 0xb3400000-0xb43fffff]
[    0.971626] pci 0000:00:1c.0:   bridge window [mem 0xb0400000-0xb13fffff 64bit pref]
[    0.971728] pci 0000:02:00.0: [14e4:4727] type 0 class 0x000280
[    0.971750] pci 0000:02:00.0: reg 10: [mem 0xb2400000-0xb2403fff 64bit]
[    0.971840] pci 0000:02:00.0: supports D1 D2
[    0.973628] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.973634] pci 0000:00:1c.1:   bridge window [io  0x1000-0x1fff]
[    0.973640] pci 0000:00:1c.1:   bridge window [mem 0xb2400000-0xb33fffff]
[    0.973649] pci 0000:00:1c.1:   bridge window [mem 0xb1400000-0xb23fffff 64bit pref]
[    0.973708] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
[    0.973717] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.973719] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.973721] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.973722] pci 0000:00:1e.0:   bridge window [mem 0xa0000000-0xfeafffff] (subtractive decode)
[    0.973738] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.973864] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.973926] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.973960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.974043] \_SB_.PCI0:_OSC invalid UUID
[    0.974045] _OSC request data:1 1f 1f 
[    0.974048]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.974076] \_SB_.PCI0:_OSC invalid UUID
[    0.974077] _OSC request data:1 0 1d 
[    0.974080]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d
[    0.974081] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.978182] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
[    0.978239] pci 0000:ff:00.0: [8086:2c62] type 0 class 0x000600
[    0.978256] pci 0000:ff:00.1: [8086:2d01] type 0 class 0x000600
[    0.978273] pci 0000:ff:02.0: [8086:2d10] type 0 class 0x000600
[    0.978288] pci 0000:ff:02.1: [8086:2d11] type 0 class 0x000600
[    0.978302] pci 0000:ff:02.2: [8086:2d12] type 0 class 0x000600
[    0.978316] pci 0000:ff:02.3: [8086:2d13] type 0 class 0x000600
[    0.978343]  pci0000:ff: Requesting ACPI _OSC control (0x1d)
[    0.978345]  pci0000:ff: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.978347] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.978513] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.978553] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.978595] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.978631] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[    0.978667] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.978703] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.978741] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.978777] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.978863] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.978869] vgaarb: loaded
[    0.978870] vgaarb: bridge control possible 0000:00:02.0
[    0.978936] SCSI subsystem initialized
[    0.978987] libata version 3.00 loaded.
[    0.979021] usbcore: registered new interface driver usbfs
[    0.979032] usbcore: registered new interface driver hub
[    0.979052] usbcore: registered new device driver usb
[    0.979101] PCI: Using ACPI for IRQ routing
[    0.987261] PCI: pci_cache_line_size set to 64 bytes
[    0.987344] reserve RAM buffer: 000000000009d000 - 000000000009ffff 
[    0.987347] reserve RAM buffer: 000000009b63f000 - 000000009bffffff 
[    0.987349] reserve RAM buffer: 000000009b800000 - 000000009bffffff 
[    0.987426] NetLabel: Initializing
[    0.987428] NetLabel:  domain hash size = 128
[    0.987429] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.987442] NetLabel:  unlabeled traffic allowed by default
[    0.987450] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.987454] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.989469] Switching to clocksource hpet
[    0.989548] Switched to NOHz mode on CPU #1
[    0.989550] Switched to NOHz mode on CPU #3
[    0.989556] Switched to NOHz mode on CPU #2
[    0.990411] Switched to NOHz mode on CPU #0
[    0.995012] pnp: PnP ACPI init
[    0.995028] ACPI: bus type pnp registered
[    0.995332] pnp 00:00: [bus 00-fe]
[    0.995335] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.995336] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.995338] pnp 00:00: [io  0x0d00-0xffff window]
[    0.995340] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.995341] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.995343] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.995344] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.995346] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.995347] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.995349] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.995350] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.995352] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.995353] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.995355] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.995356] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.995358] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.995359] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.995361] pnp 00:00: [mem 0xa0000000-0xfeafffff window]
[    0.995362] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.995459] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.995496] pnp 00:01: [io  0x0000-0x001f]
[    0.995497] pnp 00:01: [io  0x0081-0x0091]
[    0.995498] pnp 00:01: [io  0x0093-0x009f]
[    0.995500] pnp 00:01: [io  0x00c0-0x00df]
[    0.995502] pnp 00:01: [dma 4]
[    0.995520] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.995526] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.995542] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.995645] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.995667] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.995675] pnp 00:04: [io  0x00f0]
[    0.995686] pnp 00:04: [irq 13]
[    0.995704] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.995712] pnp 00:05: [io  0x002e-0x002f]
[    0.995713] pnp 00:05: [io  0x004e-0x004f]
[    0.995715] pnp 00:05: [io  0x0061]
[    0.995716] pnp 00:05: [io  0x0063]
[    0.995717] pnp 00:05: [io  0x0065]
[    0.995718] pnp 00:05: [io  0x0067]
[    0.995719] pnp 00:05: [io  0x0070]
[    0.995720] pnp 00:05: [io  0x0080]
[    0.995723] pnp 00:05: [io  0x0092]
[    0.995724] pnp 00:05: [io  0x00b2-0x00b3]
[    0.995726] pnp 00:05: [io  0x0680-0x069f]
[    0.995727] pnp 00:05: [io  0x0800-0x080f]
[    0.995728] pnp 00:05: [io  0x0810-0x0813]
[    0.995729] pnp 00:05: [io  0xffff]
[    0.995731] pnp 00:05: [io  0x0400-0x047f]
[    0.995732] pnp 00:05: [io  0x0500-0x0501]
[    0.995733] pnp 00:05: [io  0x0700-0x077f]
[    0.995735] pnp 00:05: [io  0x164e-0x164f]
[    0.995747] pnp 00:05: disabling [io  0x164e-0x164f] because it overlaps 0000:00:1c.1 BAR 13 [io  0x1000-0x1fff]
[    0.995784] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.995786] system 00:05: [io  0x0800-0x080f] has been reserved
[    0.995788] system 00:05: [io  0x0810-0x0813] has been reserved
[    0.995789] system 00:05: [io  0xffff] has been reserved
[    0.995791] system 00:05: [io  0x0400-0x047f] has been reserved
[    0.995793] system 00:05: [io  0x0500-0x0501] has been reserved
[    0.995795] system 00:05: [io  0x0700-0x077f] has been reserved
[    0.995797] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.995804] pnp 00:06: [io  0x0070-0x0077]
[    0.995809] pnp 00:06: [irq 8]
[    0.995829] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.995837] pnp 00:07: [io  0x0060]
[    0.995838] pnp 00:07: [io  0x0064]
[    0.995842] pnp 00:07: [irq 1]
[    0.995860] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.995869] pnp 00:08: [irq 12]
[    0.995890] pnp 00:08: Plug and Play ACPI device, IDs SYN1e21 SYN1e00 SYN0002 PNP0f13 (active)
[    0.995984] pnp 00:09: [irq 23]
[    0.996015] pnp 00:09: Plug and Play ACPI device, IDs HPQ0004 (active)
[    0.996171] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    0.996173] pnp 00:0a: [mem 0xfed10000-0xfed13fff]
[    0.996174] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    0.996176] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    0.996177] pnp 00:0a: [mem 0xe0000000-0xefffffff]
[    0.996178] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    0.996180] pnp 00:0a: [mem 0xfed90000-0xfed8ffff disabled]
[    0.996181] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    0.996183] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    0.996184] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    0.996186] pnp 00:0a: [mem 0xb4500000-0xb4500fff]
[    0.996232] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.996234] system 00:0a: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.996236] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.996238] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.996240] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.996242] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.996244] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.996246] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    0.996248] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.996250] system 00:0a: [mem 0xb4500000-0xb4500fff] has been reserved
[    0.996253] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.996436] pnp 00:0b: [bus ff]
[    0.996473] pnp 00:0b: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.996496] pnp: PnP ACPI: found 12 devices
[    0.996497] ACPI: ACPI bus type pnp unregistered
[    1.003385] PCI: max bus depth: 1 pci_try_num: 2
[    1.003409] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    1.003412] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    1.003417] pci 0000:00:1c.0:   bridge window [mem 0xb3400000-0xb43fffff]
[    1.003421] pci 0000:00:1c.0:   bridge window [mem 0xb0400000-0xb13fffff 64bit pref]
[    1.003426] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    1.003428] pci 0000:00:1c.1:   bridge window [io  0x1000-0x1fff]
[    1.003433] pci 0000:00:1c.1:   bridge window [mem 0xb2400000-0xb33fffff]
[    1.003436] pci 0000:00:1c.1:   bridge window [mem 0xb1400000-0xb23fffff 64bit pref]
[    1.003442] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    1.003463] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.003467] pci 0000:00:1c.0: setting latency timer to 64
[    1.003477] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    1.003481] pci 0000:00:1c.1: setting latency timer to 64
[    1.003486] pci 0000:00:1e.0: setting latency timer to 64
[    1.003489] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.003491] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.003493] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.003494] pci_bus 0000:00: resource 7 [mem 0xa0000000-0xfeafffff]
[    1.003496] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    1.003498] pci_bus 0000:01: resource 1 [mem 0xb3400000-0xb43fffff]
[    1.003500] pci_bus 0000:01: resource 2 [mem 0xb0400000-0xb13fffff 64bit pref]
[    1.003502] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    1.003503] pci_bus 0000:02: resource 1 [mem 0xb2400000-0xb33fffff]
[    1.003505] pci_bus 0000:02: resource 2 [mem 0xb1400000-0xb23fffff 64bit pref]
[    1.003507] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    1.003508] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    1.003510] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    1.003511] pci_bus 0000:03: resource 7 [mem 0xa0000000-0xfeafffff]
[    1.003539] NET: Registered protocol family 2
[    1.003661] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.004474] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.006272] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.006488] TCP: Hash tables configured (established 524288 bind 65536)
[    1.006490] TCP reno registered
[    1.006500] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.006525] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.006642] NET: Registered protocol family 1
[    1.006659] pci 0000:00:02.0: Boot video device
[    1.028626] PCI: CLS 64 bytes, default 64
[    1.028685] Unpacking initramfs...
[    1.322491] Freeing initrd memory: 17248k freed
[    1.326366] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.326371] Placing 64MB software IO TLB between ffff880097638000 - ffff88009b638000
[    1.326373] software IO TLB at phys 0x97638000 - 0x9b638000
[    1.326393] Simple Boot Flag at 0x44 set to 0x1
[    1.326976] Intel AES-NI instructions are not detected.
[    1.327108] audit: initializing netlink socket (disabled)
[    1.327121] type=2000 audit(1327070570.151:1): initialized
[    1.352453] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.370748] VFS: Disk quotas dquot_6.5.2
[    1.370801] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.371241] msgmni has been set to 7504
[    1.371288] SELinux:  Registering netfilter hooks
[    1.371628] alg: No test for stdrng (krng)
[    1.371639] NET: Registered protocol family 38
[    1.371683] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.371710] io scheduler noop registered
[    1.371712] io scheduler deadline registered
[    1.371745] io scheduler cfq registered (default)
[    1.371923] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.371952] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.371953] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.372296] intel_idle: MWAIT substates: 0x1120
[    1.372298] intel_idle: v0.4 model 0x25
[    1.372299] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.382052] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    1.382136] ACPI: AC Adapter [AC] (on-line)
[    1.382303] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    1.382322] ACPI: Lid Switch [LID0]
[    1.382351] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.382355] ACPI: Power Button [PWRB]
[    1.382382] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.382385] ACPI: Power Button [PWRF]
[    1.382427] ACPI: Fan [FAN0] (on)
[    1.382551] ACPI: acpi_idle yielding to intel_idle
[    1.421914] thermal LNXTHERM:00: registered as thermal_zone0
[    1.421918] ACPI: Thermal Zone [TZ00] (61 C)
[    1.429890] thermal LNXTHERM:01: registered as thermal_zone1
[    1.429894] ACPI: Thermal Zone [TZ01] (41 C)
[    1.437875] thermal LNXTHERM:02: registered as thermal_zone2
[    1.437878] ACPI: Thermal Zone [TZ02] (0 C)
[    1.437922] ERST: Table is not found!
[    1.437925] GHES: HEST is not enabled!
[    1.438021] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.480070] Non-volatile memory driver v1.3
[    1.480072] Linux agpgart interface v0.103
[    1.480130] agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
[    1.480220] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.480987] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[    1.481159] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xa0000000
[    1.481859] loop: module loaded
[    1.481945] ahci 0000:00:1f.2: version 3.0
[    1.481967] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.482015] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
[    1.482075] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x13 impl SATA mode
[    1.482078] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck pm led clo pio slum part ems sxs apst 
[    1.482082] ahci 0000:00:1f.2: setting latency timer to 64
[    1.486095] scsi0 : ahci
[    1.486174] scsi1 : ahci
[    1.486229] scsi2 : ahci
[    1.486282] scsi3 : ahci
[    1.486337] scsi4 : ahci
[    1.486435] ata1: SATA max UDMA/133 abar m2048@0xb4405000 port 0xb4405100 irq 40
[    1.486438] ata2: SATA max UDMA/133 abar m2048@0xb4405000 port 0xb4405180 irq 40
[    1.486440] ata3: DUMMY
[    1.486440] ata4: DUMMY
[    1.486443] ata5: SATA max UDMA/133 abar m2048@0xb4405000 port 0xb4405300 irq 40
[    1.486503] Fixed MDIO Bus: probed
[    1.486571] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.486585] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.486600] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.486604] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.486682] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.486712] ehci_hcd 0000:00:1a.0: debug port 2
[    1.490646] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    1.490662] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xb4405c00
[    1.499738] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.499781] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.499785] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.499789] usb usb1: Product: EHCI Host Controller
[    1.499792] usb usb1: Manufacturer: Linux 3.1.9-1.fc16.x86_64 ehci_hcd
[    1.499796] usb usb1: SerialNumber: 0000:00:1a.0
[    1.499915] hub 1-0:1.0: USB hub found
[    1.499919] hub 1-0:1.0: 3 ports detected
[    1.499981] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.499993] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.499996] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    1.500042] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.500065] ehci_hcd 0000:00:1d.0: debug port 2
[    1.503990] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    1.504001] ehci_hcd 0000:00:1d.0: irq 20, io mem 0xb4405800
[    1.513716] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.513744] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.513748] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.513752] usb usb2: Product: EHCI Host Controller
[    1.513755] usb usb2: Manufacturer: Linux 3.1.9-1.fc16.x86_64 ehci_hcd
[    1.513758] usb usb2: SerialNumber: 0000:00:1d.0
[    1.513870] hub 2-0:1.0: USB hub found
[    1.513872] hub 2-0:1.0: 3 ports detected
[    1.513918] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.513926] uhci_hcd: USB Universal Host Controller Interface driver
[    1.513972] usbcore: registered new interface driver usbserial
[    1.513978] USB Serial support registered for generic
[    1.513985] usbcore: registered new interface driver usbserial_generic
[    1.513986] usbserial: USB Serial Driver core
[    1.514014] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.518989] i8042: Detected active multiplexing controller, rev 1.1
[    1.524723] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.524729] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.524752] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.524766] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.524782] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.524854] mousedev: PS/2 mouse device common for all mice
[    1.525031] rtc_cmos 00:06: RTC can wake from S4
[    1.525146] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.525173] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    1.525251] device-mapper: uevent: version 1.0.3
[    1.525328] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    1.525465] cpuidle: using governor ladder
[    1.525568] cpuidle: using governor menu
[    1.525651] EFI Variables Facility v0.08 2004-May-17
[    1.525759] usbcore: registered new interface driver usbhid
[    1.525760] usbhid: USB HID core driver
[    1.525814] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.525827] TCP cubic registered
[    1.525828] Initializing XFRM netlink socket
[    1.525929] NET: Registered protocol family 10
[    1.526103] Mobile IPv6
[    1.526105] NET: Registered protocol family 17
[    1.526116] Registering the dns_resolver key type
[    1.526253] PM: Hibernation image not present or could not be loaded.
[    1.526265] registered taskstats version 1
[    1.534766] IMA: No TPM chip found, activating TPM-bypass!
[    1.535134]   Magic number: 12:639:738
[    1.535292] rtc_cmos 00:06: setting system clock to 2012-01-20 14:42:51 UTC (1327070571)
[    1.540868] ACPI Error: [NPSS] Namespace lookup failure, AE_NOT_FOUND (20110623/psargs-359)
[    1.540878] ACPI Error: Method parse/execution failed [\_PR_.CPU0.PPC_] (Node ffff880150d998e8), AE_NOT_FOUND (20110623/psparse-536)
[    1.540890] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff880150d997d0), AE_NOT_FOUND (20110623/psparse-536)
[    1.554913] ACPI Error: [NPSS] Namespace lookup failure, AE_NOT_FOUND (20110623/psargs-359)
[    1.554921] ACPI Error: Method parse/execution failed [\_PR_.CPU0.PPC_] (Node ffff880150d998e8), AE_NOT_FOUND (20110623/psparse-536)
[    1.554927] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff880150d997d0), AE_NOT_FOUND (20110623/psparse-536)
[    1.554932] ACPI Error: Method parse/execution failed [\_PR_.CPU1._PPC] (Node ffff880150d998c0), AE_NOT_FOUND (20110623/psparse-536)
[    1.561771] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.630729] ACPI Error: [NPSS] Namespace lookup failure, AE_NOT_FOUND (20110623/psargs-359)
[    1.630743] ACPI Error: Method parse/execution failed [\_PR_.CPU0.PPC_] (Node ffff880150d998e8), AE_NOT_FOUND (20110623/psparse-536)
[    1.630756] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff880150d997d0), AE_NOT_FOUND (20110623/psparse-536)
[    1.630767] ACPI Error: Method parse/execution failed [\_PR_.CPU2._PPC] (Node ffff880150d99b18), AE_NOT_FOUND (20110623/psparse-536)
[    1.697724] ACPI Error: [NPSS] Namespace lookup failure, AE_NOT_FOUND (20110623/psargs-359)
[    1.697735] ACPI Error: Method parse/execution failed [\_PR_.CPU0.PPC_] (Node ffff880150d998e8), AE_NOT_FOUND (20110623/psparse-536)
[    1.697747] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff880150d997d0), AE_NOT_FOUND (20110623/psparse-536)
[    1.697758] ACPI Error: Method parse/execution failed [\_PR_.CPU3._PPC] (Node ffff880150d99a78), AE_NOT_FOUND (20110623/psparse-536)
[    1.697923] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    1.697942] ACPI: Battery Slot [BAT0] (battery present)
[    1.698041] Initializing network drop monitor service
[    1.792310] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.792335] ata5: SATA link down (SStatus 0 SControl 300)
[    1.792369] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.793294] ata1.00: ATA-8: TOSHIBA MK5056GSY, LH003C, max UDMA/100
[    1.793301] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.794506] ata1.00: configured for UDMA/100
[    1.794689] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK5056GS LH00 PQ: 0 ANSI: 5
[    1.794814] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.794835] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.794887] sd 0:0:0:0: [sda] Write Protect is off
[    1.794890] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.794947] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.801277] usb 1-1: new high speed USB device number 2 using ehci_hcd
[    1.809145] ata2.00: ATAPI: hp       CDDVDW TS-U633F, HH05, max UDMA/100
[    1.825100] ata2.00: configured for UDMA/100
[    1.828957] scsi 1:0:0:0: CD-ROM            hp       CDDVDW TS-U633F  HH05 PQ: 0 ANSI: 5
[    1.835854] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.835861] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.836114] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.836313] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.910865]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
[    1.912401] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.915467] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    1.915474] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.915715] Freeing unused kernel memory: 964k freed
[    1.915892] hub 1-1:1.0: USB hub found
[    1.915972] Write protecting the kernel read-only data: 10240k
[    1.916093] hub 1-1:1.0: 6 ports detected
[    1.916937] Freeing unused kernel memory: 100k freed
[    1.926160] Freeing unused kernel memory: 1552k freed
[    2.018878] usb 2-1: new high speed USB device number 2 using ehci_hcd
[    2.041910] dracut: dracut-013-20.fc16
[    2.053133] dracut: rd.luks=0: removing cryptoluks activation
[    2.056577] dracut: rd.lvm=0: removing LVM activation
[    2.062357] udevd[114]: starting version 173
[    2.091428] [drm] Initialized drm 1.1.0 20060810
[    2.099894] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.099900] i915 0000:00:02.0: setting latency timer to 64
[    2.135041] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    2.135044] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.135311] hub 2-1:1.0: USB hub found
[    2.135401] hub 2-1:1.0: 8 ports detected
[    2.140231] mtrr: no more MTRRs available
[    2.140233] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    2.140456] i915 0000:00:02.0: irq 41 for MSI/MSI-X
[    2.140463] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    2.140464] [drm] Driver supports precise vblank timestamp query.
[    2.140495] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.209727] usb 1-1.4: new full speed USB device number 3 using ehci_hcd
[    2.296301] usb 1-1.4: New USB device found, idVendor=138a, idProduct=0005
[    2.296307] usb 1-1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=1
[    2.296312] usb 1-1.4: SerialNumber: 00b08095ca85
[    2.325349] Refined TSC clocksource calibration: 2393.999 MHz.
[    2.325357] Switching to clocksource tsc
[    2.410362] usb 2-1.3: new full speed USB device number 3 using ehci_hcd
[    2.463430] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04773/0xe40000/0x5a0400
[    2.498606] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input4
[    2.499673] usb 2-1.3: New USB device found, idVendor=0a5c, idProduct=21b4
[    2.499678] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.499682] usb 2-1.3: Product: Broadcom 2070 Bluetooth
[    2.499684] usb 2-1.3: Manufacturer: Broadcom Corp
[    2.499687] usb 2-1.3: SerialNumber: 002713DDD4FC
[    2.573072] usb 2-1.6: new full speed USB device number 4 using ehci_hcd
[    2.685027] fbcon: inteldrmfb (fb0) is primary device
[    2.719995] usb 2-1.6: new high speed USB device number 5 using ehci_hcd
[    2.827163] usb 2-1.6: New USB device found, idVendor=10f1, idProduct=1a28
[    2.827168] usb 2-1.6: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[    2.827172] usb 2-1.6: Product: HP Webcam
[    2.827174] usb 2-1.6: Manufacturer: Importek
[    2.965527] Console: switching to colour frame buffer device 170x48
[    2.970797] fb0: inteldrmfb frame buffer device
[    2.970799] drm: registered panic notifier
[    2.972965] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    2.973081] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.973690] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.006304] dracut: Starting plymouth daemon
[    3.201167] dracut: rd.dm=0: removing DM RAID activation
[    3.207403] dracut: rd.md=0: removing MD RAID activation
[    3.264630] wmi: Mapper loaded
[    3.947827] Btrfs loaded
[    3.966454] device fsid be8d8291-3821-4584-a9a7-776b91d4d5a5 devid 1 transid 59719 /dev/sda5
[    3.977151] device label home devid 1 transid 13857 /dev/sda6
[    4.107672] EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
[    4.194885] dracut: Checking ext4: /dev/disk/by-uuid/2949b379-bd76-4ed6-a2be-12a1bc4634c5
[    4.194959] dracut: issuing e2fsck -a  /dev/disk/by-uuid/2949b379-bd76-4ed6-a2be-12a1bc4634c5
[    4.222133] dracut: Fedora: clean, 270419/2506752 files, 3221096/10010624 blocks
[    4.222344] dracut: Remounting /dev/disk/by-uuid/2949b379-bd76-4ed6-a2be-12a1bc4634c5 with -o ro
[    4.282439] EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
[    4.294159] dracut: Mounted root filesystem /dev/sda7
[    4.505310] dracut: Switching root
[    4.945256] type=1404 audit(1327070574.915:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    5.042756] SELinux: 2048 avtab hash slots, 98655 rules.
[    5.059500] SELinux: 2048 avtab hash slots, 98655 rules.
[    5.159536] SELinux:  9 users, 13 roles, 3923 types, 209 bools, 1 sens, 1024 cats
[    5.159541] SELinux:  82 classes, 98655 rules
[    5.163073] SELinux:  Completing initialization.
[    5.163075] SELinux:  Setting up existing superblocks.
[    5.163083] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    5.163088] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    5.163306] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    5.163312] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    5.163319] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    5.163345] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    5.163843] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    5.163847] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    5.164471] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    5.164478] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    5.164482] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    5.164501] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    5.164508] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    5.164517] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    5.164529] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[    5.164535] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    5.164539] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    5.164919] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    5.164926] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    5.166702] SELinux: initialized (dev sda7, type ext4), uses xattr
[    5.170316] type=1403 audit(1327070575.139:3): policy loaded auid=4294967295 ses=4294967295
[    5.176497] systemd[1]: Successfully loaded SELinux policy in 264ms 411us.
[    5.242930] systemd[1]: Successfully loaded SELinux database in 66ms 212us, size on heap is 479K.
[    5.290023] systemd[1]: RTC configured in localtime, applying delta of 60 minutes to system time.
[    5.301931] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    5.302582] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.349054] systemd[1]: Relabelled /dev and /run in 46ms 402us.
[    5.434830] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.450017] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.466017] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.475033] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.491940] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.492430] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.507929] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.516942] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    5.517030] systemd[1]: systemd 37 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +SYSVINIT +LIBCRYPTSETUP; fedora)
[    5.543233] systemd[1]: Set hostname to <milan>.
[    7.055452] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[    7.625373] udevd[453]: starting version 173
[    9.232762] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[    9.233179] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    9.233817] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    9.489660] EXT4-fs (sda7): re-mounted. Opts: (null)
[   14.046727] mtp-probe[594]: checking bus 2, device 5: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6"
[   14.046738] mtp-probe[590]: checking bus 1, device 3: "/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4"
[   14.048154] mtp-probe[594]: bus: 2, device: 5 was not an MTP device
[   14.048437] mtp-probe[590]: bus: 1, device: 3 was not an MTP device
[   14.207279] microcode: CPU0 sig=0x20655, pf=0x10, revision=0x2
[   14.209178] microcode: CPU0 updated to revision 0x3, date = 2011-09-01
[   14.209190] microcode: CPU1 sig=0x20655, pf=0x10, revision=0x3
[   14.210356] microcode: CPU2 sig=0x20655, pf=0x10, revision=0x2
[   14.211799] microcode: CPU2 updated to revision 0x3, date = 2011-09-01
[   14.211820] microcode: CPU3 sig=0x20655, pf=0x10, revision=0x3
[   14.213459] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   14.239835] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   14.272073] intel ips 0000:00:1f.6: CPU TDP doesn't match expected value (found 25, expected 29)
[   14.272098] intel ips 0000:00:1f.6: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   14.272318] intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 90
[   14.709393] iTCO_vendor_support: vendor-support=0
[   17.040404] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   17.040430] r8169 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   17.040485] r8169 0000:01:00.0: setting latency timer to 64
[   17.040544] r8169 0000:01:00.0: irq 42 for MSI/MSI-X
[   17.040707] r8169 0000:01:00.0: eth0: RTL8168d/8111d at 0xffffc9000061c000, 1c:c1:de:a6:00:2d, XID 083000c0 IRQ 42
[   17.092840] Linux media interface: v0.10
[   19.030708] hp_accel: laptop model unknown, using default axes configuration
[   19.031318] lis3lv02d: 8 bits sensor found
[   19.066579] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input6
[   19.067359] Registered led device: hp::hddprotect
[   19.067390] hp_accel: driver loaded
[   19.754973] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[   19.878209] udevd[491]: renamed network interface eth0 to em1
[   19.901952] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[   19.902066] iTCO_wdt: Found a HM55 TCO device (Version=2, TCOBASE=0x0460)
[   19.902292] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   20.119953] input: HP WMI hotkeys as /devices/virtual/input/input7
[   20.711329] Linux video capture interface: v2.00
[   21.109490] uvcvideo: Found UVC 1.00 device HP Webcam (10f1:1a28)
[   21.117602] input: HP Webcam as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/input/input8
[   21.117796] usbcore: registered new interface driver uvcvideo
[   21.117801] USB Video Class driver (1.1.1)
[   21.729556] vboxdrv: Found 4 processor cores.
[   21.729740] VBoxDrv: dbg - g_abExecMemory=ffffffffa02b1ca0
[   21.729822] vboxdrv: fAsync=0 offMin=0x381 offMax=0xb4a8
[   21.729897] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   21.729899] vboxdrv: Successfully loaded version 4.1.8_OSE (interface 0x00190000).
[   22.225414] bcma-pci-bridge 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   22.225452] bcma-pci-bridge 0000:02:00.0: setting latency timer to 64
[   22.225565] Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
[   22.225587] Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
[   22.225635] Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x11, class 0x0)
[   22.235115] Bus registered
[   22.723708] cfg80211: Calling CRDA to update world regulatory domain
[   22.729397] cfg80211: World regulatory domain updated:
[   22.729400] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   22.729402] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   22.729404] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   22.729406] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   22.729408] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   22.729410] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   22.826153] Adding 4610616k swap on /dev/sda8.  Priority:0 extents:1 across:4610616k 
[   23.295835] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   23.295917] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[   23.295952] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[   23.374210] fuse init (API version 7.17)
[   23.380974] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   23.394607] mount[847]: mount\xffffffc2\xffffffa0\xffffffa0: fusectl est d\xffffffc3\xffffffa9\xffffffa9j\xffffffc3\xffffffa0\xffffffa0 mont\xffffffc3\xffffffa9\xffffffa9 ou /sys/fs/fuse/connections est occup\xffffffc3\xffffffa9\xffffffa9
[   23.394672] mount[847]: mount\xffffffc2\xffffffa0\xffffffa0: selon mtab, fusectl est d\xffffffc3\xffffffa9\xffffffa9j\xffffffc3\xffffffa0\xffffffa0 mont\xffffffc3\xffffffa9\xffffffa9 sur /sys/fs/fuse/connections
[   23.395225] systemd[1]: sys-fs-fuse-connections.mount mount process exited, code=exited status=32
[   23.429261] ALSA sound/pci/hda/patch_sigmatel.c:5636 mute LED gpio 1 polarity 1
[   23.429269] ALSA sound/pci/hda/hda_codec.c:4895 autoconfig: line_outs=1 (0xd/0x0/0x0/0x0/0x0) type:speaker
[   23.429271] ALSA sound/pci/hda/hda_codec.c:4899    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   23.429274] ALSA sound/pci/hda/hda_codec.c:4903    hp_outs=1 (0xb/0x0/0x0/0x0/0x0)
[   23.429275] ALSA sound/pci/hda/hda_codec.c:4904    mono: mono_out=0x0
[   23.429277] ALSA sound/pci/hda/hda_codec.c:4908    inputs:
[   23.429278] ALSA sound/pci/hda/hda_codec.c:4912  Mic=0xc
[   23.429280] ALSA sound/pci/hda/hda_codec.c:4914 
[   23.429522] ALSA sound/pci/hda/patch_sigmatel.c:3116 stac92xx: dac_nids=1 (0x13/0x0/0x0/0x0/0x0)
[   23.467624] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
[   23.475128] input: HDA Intel Mic at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   23.475306] input: HDA Intel HP Out at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   23.475610] input: HDA Intel HDMI/DP as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   23.797765] SELinux: initialized (dev sda1, type fuseblk), uses genfs_contexts
[   23.798565] ntfs-3g[878]: Version 2011.4.12 integrated FUSE 27
[   23.798581] ntfs-3g[878]: Mounted /dev/sda1 (Read-Write, label "SYSTEM", NTFS 3.1)
[   23.798592] ntfs-3g[878]: Cmdline options: rw
[   23.798601] ntfs-3g[878]: Mount options: rw,allow_other,nonempty,atime,fsname=/dev/sda1,blkdev,blksize=4096
[   23.798612] ntfs-3g[878]: Ownership and permissions disabled, configuration type 1
[   23.860499] brcmsmac bcma0:0: mfg 4bf core 812 rev 24 class 0 irq 17
[   23.929559] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   23.929749] brcms_module_init: register returned 0
[   23.929911] cfg80211: Calling CRDA for country: US
[   23.932556] cfg80211: Regulatory domain changed to country: US
[   23.932559] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   23.932561] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[   23.932563] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[   23.932565] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.932567] cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.932569] cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.932570] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[   24.260833] SELinux: initialized (dev sda2, type fuseblk), uses genfs_contexts
[   24.261587] ntfs-3g[891]: Version 2011.4.12 integrated FUSE 27
[   24.261601] ntfs-3g[891]: Mounted /dev/sda2 (Read-Write, label "", NTFS 3.1)
[   24.261606] ntfs-3g[891]: Cmdline options: rw
[   24.261674] ntfs-3g[891]: Mount options: rw,allow_other,nonempty,atime,fsname=/dev/sda2,blkdev,blksize=4096
[   24.261687] ntfs-3g[891]: Ownership and permissions disabled, configuration type 1
[   24.273885] Broadcom 43xx driver loaded [ Features: PMNLS ]
[   24.285004] cfg80211: Calling CRDA for country: FR
[   24.287582] cfg80211: Regulatory domain changed to country: FR
[   24.287585] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   24.287587] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   24.287589] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   24.287591] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   24.287593] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[   24.325692] Bluetooth: Core ver 2.16
[   24.325721] NET: Registered protocol family 31
[   24.325723] Bluetooth: HCI device and connection manager initialized
[   24.325726] Bluetooth: HCI socket layer initialized
[   24.325728] Bluetooth: L2CAP socket layer initialized
[   24.325737] Bluetooth: SCO socket layer initialized
[   24.359251] usbcore: registered new interface driver btusb
[   24.451398] systemd-fsck[832]: fsck: fsck.btrfs: not found
[   24.451538] systemd-fsck[832]: fsck: error 2 while executing fsck.btrfs for /dev/sda6
[   24.451651] systemd-fsck[832]: fsck failed with error code 8.
[   24.451664] systemd-fsck[832]: Ignoring error.
[   24.460413] rmmod[912]: ERROR: Module scsi_wait_scan does not exist in /proc/modules
[   24.621140] device label home devid 1 transid 13857 /dev/sda6
[   25.257481] fedora-storage-init[921]: Configuration du gestionnaire de volume logique\xffffffc2\xffffffa0\xffffffa0:    No volume groups found
[   25.267285] fedora-storage-init[921]: [  OK  ]
[   25.555467] fedora-storage-init[939]: Configuration du gestionnaire de volume logique\xffffffc2\xffffffa0\xffffffa0:    No volume groups found
[   25.563048] fedora-storage-init[939]: [  OK  ]
[   25.997785] lvm[945]: No volume groups found
[   27.799170] SELinux: initialized (dev sda6, type btrfs), uses xattr
[   27.850900] systemd-tmpfiles[950]: Successfully loaded SELinux database in 13ms 224us, size on heap is 481K.
[   28.142368] alsactl[956]: Found hardware: "HDA-Intel" "Intel IbexPeak HDMI" "HDA:111d7605,103c146a,00100402 HDA:80862804,80860101,00100000" "0x103c" "0x146a"
[   28.142398] alsactl[956]: Hardware is initialized using a generic method
[   28.164069] alsactl[956]: /sbin/alsactl: set_control:1267: failed to obtain info for control #18 (No such file or directory)
[   28.241710] bluetoothd[960]: Bluetooth daemon 4.96
[   28.241727] bluetoothd[960]: bluetoothd[960]: Bluetooth daemon 4.96
[   28.376134] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   28.383382] abrtd[990]: Init complete, entering main loop
[   28.402969] mcelog[991]: mcelog read: No such device
[   28.405173] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   28.434526] iptables.init[965]: iptables\xffffffc2\xffffffa0\xffffffa0: Application des r\xffffffc3\xffffffa8\xffffffa8gles du pare-feu\xffffffc2\xffffffa0\xffffffa0: [  OK  ]
[   28.450894] ip6tables.init[962]: ip6tables\xffffffc2\xffffffa0\xffffffa0: Application des r\xffffffc3\xffffffa8\xffffffa8gles du pare-feu\xffffffc2\xffffffa0\xffffffa0: [  OK  ]
[   28.491789] NetworkManager[1012]: NetworkManager[1012]: <info> NetworkManager (version 0.9.2-1.fc16) is starting...
[   28.491856] NetworkManager[1012]: <info> NetworkManager (version 0.9.2-1.fc16) is starting...
[   28.491865] NetworkManager[1012]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
[   28.491896] NetworkManager[1012]: NetworkManager[1012]: <info> Read config file /etc/NetworkManager/NetworkManager.conf
[   28.520726] avahi-daemon[1014]: Found user 'avahi' (UID 70) and group 'avahi' (GID 70).
[   28.520893] avahi-daemon[1014]: Successfully dropped root privileges.
[   28.521223] avahi-daemon[1014]: avahi-daemon 0.6.30 starting up.
[   28.595530] /usr/sbin/crond[984]: (CRON) INFO (running with inotify support)
[   28.722382] mcelog[1018]: mcelog: Unsupported new Family 6 Model 25 CPU: only decoding architectural errors
[   28.992793] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   28.992796] Bluetooth: BNEP filters: protocol multicast
[   29.064245] r8169 0000:01:00.0: em1: link down
[   29.064630] ADDRCONF(NETDEV_UP): em1: link is not ready
[   29.069083] Bluetooth: RFCOMM TTY layer initialized
[   29.069090] Bluetooth: RFCOMM socket layer initialized
[   29.069092] Bluetooth: RFCOMM ver 1.11
[   29.114364] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   29.114376] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[   29.114988] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   31.668406] wlan0: authenticate with 0c:60:76:12:b4:e0 (try 1)
[   31.670580] wlan0: authenticated
[   31.674276] wlan0: associate with 0c:60:76:12:b4:e0 (try 1)
[   31.683201] wlan0: RX AssocResp from 0c:60:76:12:b4:e0 (capab=0x411 status=0 aid=2)
[   31.683206] wlan0: associated
[   31.683210] wlan0: moving STA 0c:60:76:12:b4:e0 to state 1
[   31.683212] wlan0: moving STA 0c:60:76:12:b4:e0 to state 2
[   31.683874] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   31.683880] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[   31.683885] ieee80211 phy0: changing basic rates failed: -22
[   31.683889] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   31.684500] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   31.701291] wlan0: moving STA 0c:60:76:12:b4:e0 to state 3
[   32.769826] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[   42.218586] wlan0: no IPv6 routers present
[   44.444581] type=1404 audit(1327067014.071:4): enforcing=0 old_enforcing=1 auid=0 ses=2
[   52.963304] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[   55.574765] lp: driver loaded but no devices found
[   55.588848] ppdev: user-space parallel port driver
[   57.331147] type=1400 audit(1327067026.982:5): avc:  denied  { read } for  pid=1022 comm="dbus-daemon" path="/home/milan/.local/share/icc/edid-36693e61e02fbf7897987dd4cfca9a4d.icc" dev=sda6 ino=305523 scontext=system_u:system_r:system_dbusd_t:s0-s0:c0.c1023 tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file
[   57.331471] type=1400 audit(1327067026.983:6): avc:  denied  { read } for  pid=1644 comm="colord" path="/home/milan/.local/share/icc/edid-36693e61e02fbf7897987dd4cfca9a4d.icc" dev=sda6 ino=305523 scontext=system_u:system_r:colord_t:s0-s0:c0.c1023 tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file
[   57.349741] type=1400 audit(1327067027.001:7): avc:  denied  { getattr } for  pid=1642 comm="colord" path="/home/milan/.local/share/icc/edid-36693e61e02fbf7897987dd4cfca9a4d.icc" dev=sda6 ino=305523 scontext=system_u:system_r:colord_t:s0-s0:c0.c1023 tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file
[  158.962846] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  158.962860] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[  158.962907] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[  158.962915] wlan0: deauthenticating from 0c:60:76:12:b4:e0 by local choice (reason=3)
[  159.001870] wlan0: moving STA 0c:60:76:12:b4:e0 to state 2
[  159.001875] wlan0: moving STA 0c:60:76:12:b4:e0 to state 1
[  159.001879] wlan0: moving STA 0c:60:76:12:b4:e0 to state 0
[  159.001988] cfg80211: Calling CRDA to update world regulatory domain
[  159.021111] cfg80211: World regulatory domain updated:
[  159.021115] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  159.021117] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  159.021120] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  159.021123] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  159.021125] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  159.021128] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  159.021148] cfg80211: Calling CRDA for country: FR
[  159.032917] cfg80211: Regulatory domain changed to country: FR
[  159.032921] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  159.032923] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  159.032926] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  159.032929] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  159.032932] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[  160.606861] PM: Syncing filesystems ... done.
[  160.681330] PM: Preparing system for mem sleep
[  160.777908] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  160.788567] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  160.799515] PM: Entering mem sleep
[  160.799658] Suspending console(s) (use no_console_suspend to debug)
[  160.800077] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  160.800237] sd 0:0:0:0: [sda] Stopping disk
[  160.846013] bcma-pci-bridge 0000:02:00.0: PCI INT A disabled
[  160.856412] ehci_hcd 0000:00:1a.0: PCI INT A disabled
[  160.856418] ehci_hcd 0000:00:1d.0: PCI INT A disabled
[  161.048332] snd_hda_intel 0000:00:1b.0: PCI INT A disabled
[  161.409399] PM: suspend of devices complete after 610.742 msecs
[  161.409565] r8169 0000:01:00.0: PME# enabled
[  161.418358] r8169 0000:01:00.0: wake-up capability enabled by ACPI
[  161.451323] PM: late suspend of devices complete after 41.990 msecs
[  161.451483] ACPI: Preparing to enter system sleep state S3
[  161.497542] PM: Saving platform NVS memory
[  161.501304] Disabling non-boot CPUs ...
[  161.503283] CPU 1 is now offline
[  161.505440] CPU 2 is now offline
[  161.507204] CPU 3 is now offline
[  161.507649] Extended CMOS year: 2000
[  161.507857] ACPI: Low-level resume complete
[  161.507913] PM: Restoring platform NVS memory
[  161.508419] CPU0: Thermal monitoring handled by SMI
[  161.508477] Extended CMOS year: 2000
[  161.508703] microcode: CPU0 updated to revision 0x3, date = 2011-09-01
[  161.508710] Enabling non-boot CPUs ...
[  161.508837] Booting Node 0 Processor 1 APIC 0x1
[  161.508838] smpboot cpu 1: start_ip = 98000
[  161.519842] Calibrating delay loop (skipped) already calibrated this CPU
[  161.519867] CPU1: Thermal monitoring handled by SMI
[  161.540207] NMI watchdog enabled, takes one hw-pmu counter.
[  161.540472] ACPI Error: [NPSS] Namespace lookup failure, AE_NOT_FOUND (20110623/psargs-359)
[  161.540478] ACPI Error: Method parse/execution failed [\_PR_.CPU0.PPC_] (Node ffff880150d998e8), AE_NOT_FOUND (20110623/psparse-536)
[  161.540483] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff880150d997d0), AE_NOT_FOUND (20110623/psparse-536)
[  161.540487] ACPI Error: Method parse/execution failed [\_PR_.CPU1._PPC] (Node ffff880150d998c0), AE_NOT_FOUND (20110623/psparse-536)
[  161.540520] CPU1 is up
[  161.540594] Booting Node 0 Processor 2 APIC 0x4
[  161.540595] smpboot cpu 2: start_ip = 98000
[  161.540850] Switched to NOHz mode on CPU #1
[  161.551597] Calibrating delay loop (skipped) already calibrated this CPU
[  161.551621] CPU2: Thermal monitoring handled by SMI
[  161.571792] Switched to NOHz mode on CPU #2
[  161.571952] NMI watchdog enabled, takes one hw-pmu counter.
[  161.572201] ACPI Error: [NPSS] Namespace lookup failure, AE_NOT_FOUND (20110623/psargs-359)
[  161.572206] ACPI Error: Method parse/execution failed [\_PR_.CPU0.PPC_] (Node ffff880150d998e8), AE_NOT_FOUND (20110623/psparse-536)
[  161.572211] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff880150d997d0), AE_NOT_FOUND (20110623/psparse-536)
[  161.572215] ACPI Error: Method parse/execution failed [\_PR_.CPU2._PPC] (Node ffff880150d99b18), AE_NOT_FOUND (20110623/psparse-536)
[  161.572410] microcode: CPU2 updated to revision 0x3, date = 2011-09-01
[  161.572419] CPU2 is up
[  161.572486] Booting Node 0 Processor 3 APIC 0x5
[  161.572487] smpboot cpu 3: start_ip = 98000
[  161.583494] Calibrating delay loop (skipped) already calibrated this CPU
[  161.583517] CPU3: Thermal monitoring handled by SMI
[  161.603732] Switched to NOHz mode on CPU #3
[  161.603870] NMI watchdog enabled, takes one hw-pmu counter.
[  161.604134] ACPI Error: [NPSS] Namespace lookup failure, AE_NOT_FOUND (20110623/psargs-359)
[  161.604139] ACPI Error: Method parse/execution failed [\_PR_.CPU0.PPC_] (Node ffff880150d998e8), AE_NOT_FOUND (20110623/psparse-536)
[  161.604144] ACPI Error: Method parse/execution failed [\_PR_.CPU0._PPC] (Node ffff880150d997d0), AE_NOT_FOUND (20110623/psparse-536)
[  161.604148] ACPI Error: Method parse/execution failed [\_PR_.CPU3._PPC] (Node ffff880150d99a78), AE_NOT_FOUND (20110623/psparse-536)
[  161.604202] CPU3 is up
[  161.606406] ACPI: Waking up from system sleep state S3
[  161.714259] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900407)
[  161.714295] pci 0000:00:16.0: restoring config space at offset 0x1 (was 0x180006, writing 0x100006)
[  161.714332] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  161.714372] snd_hda_intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
[  161.714405] pcieport 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20002020, writing 0x2020)
[  161.714491] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  161.714537] pci 0000:00:1e.0: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
[  161.714621] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  161.714749] r8169 0000:01:00.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
[  161.714843] bcma-pci-bridge 0000:02:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[  161.714865] bcma-pci-bridge 0000:02:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xb2400004)
[  161.714872] bcma-pci-bridge 0000:02:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  161.714880] bcma-pci-bridge 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
[  161.715082] PM: early resume of devices complete after 0.911 msecs
[  161.715191] i915 0000:00:02.0: setting latency timer to 64
[  161.715195] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  161.715201] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[  161.715236] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[  161.715240] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[  161.715277] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[  161.715356] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[  161.715359] pci 0000:00:1e.0: setting latency timer to 64
[  161.715361] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[  161.715369] ahci 0000:00:1f.2: setting latency timer to 64
[  161.715397] bcma-pci-bridge 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  161.716594] sd 0:0:0:0: [sda] Starting disk
[  161.729086] r8169 0000:01:00.0: wake-up capability disabled by ACPI
[  161.729092] r8169 0000:01:00.0: PME# disabled
[  161.782090] Extended CMOS year: 2000
[  161.945243] usb 1-1.4: reset full speed USB device number 3 using ehci_hcd
[  162.018966] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  162.020973] ata5: SATA link down (SStatus 0 SControl 300)
[  162.082018] ata2.00: configured for UDMA/100
[  162.102968] usb 2-1.3: reset full speed USB device number 3 using ehci_hcd
[  162.189560] btusb 2-1.3:1.0: no reset_resume for driver btusb?
[  162.189563] btusb 2-1.3:1.1: no reset_resume for driver btusb?
[  162.260693] usb 2-1.6: reset high speed USB device number 5 using ehci_hcd
[  163.499222] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  163.501303] ata1.00: configured for UDMA/100
[  164.162473] PM: resume of devices complete after 2451.936 msecs
[  164.162973] PM: Finishing wakeup.
[  164.162975] Restarting tasks ... done.
[  164.169572] video LNXVIDEO:00: Restoring backlight state
[  164.424694] r8169 0000:01:00.0: em1: link down
[  164.425154] ADDRCONF(NETDEV_UP): em1: link is not ready
[  165.173032] Bluetooth: hci0 command tx timeout
[  165.612939] ieee80211 phy0: wl0: wlc_coreinit: ucode did not self-suspend!
[  165.751978] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  165.751989] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000031, psm_brc 0x0000
[  165.850036] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  165.850047] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  165.948180] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  165.948192] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  166.046242] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  166.046253] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  166.151323] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  166.151337] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  166.255523] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  166.255534] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  166.359557] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  166.359569] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  166.463660] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  166.463671] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000001, psm_brc 0x0000
[  166.463699] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[  166.463708] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[  166.567657] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  166.567669] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  166.671458] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  166.671469] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  166.673517] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  166.804843] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  166.804855] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000031, psm_brc 0x0000
[  167.035500] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  167.035516] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  167.266949] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  167.266964] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  167.497696] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  167.497711] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  167.728667] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  167.728682] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  167.960307] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  167.960322] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000031, psm_brc 0x0000
[  168.191683] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  168.191699] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000001, psm_brc 0x0000
[  168.422758] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  168.422775] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  168.653394] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  168.653409] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  168.885632] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  168.885647] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  169.119270] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  169.119285] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000001, psm_brc 0x0000
[  169.351609] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  169.351624] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000001, psm_brc 0x0000
[  169.583904] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  169.583919] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000001, psm_brc 0x0000
[  169.816948] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  169.816963] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000031, psm_brc 0x0000
[  186.938830] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  186.938846] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000001, psm_brc 0x0000
[  187.169656] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  187.169671] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000001, psm_brc 0x0000
[  187.401081] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  187.401097] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  187.631617] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  187.631632] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  187.862375] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  187.862389] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000001, psm_brc 0x0000
[  188.092877] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  188.092892] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000031, psm_brc 0x0000
[  188.323513] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  188.323528] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000000, psm_brc 0x0000
[  188.554151] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  188.554166] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000031, psm_brc 0x0000
[  188.784620] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  188.784635] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000031, psm_brc 0x0000
[  189.015434] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  189.015449] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000001, psm_brc 0x0000
[  189.245992] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  189.246007] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000001, psm_brc 0x0000
[  189.476369] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  189.476384] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000001, psm_brc 0x0000
[  189.706959] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  189.706973] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000001, psm_brc 0x0000
[  189.937538] ieee80211 phy0: wl0: wlc_suspend_mac_and_wait: waited 83000 uS and MI_MACSSPNDD is still not on.
[  189.937552] ieee80211 phy0: wl0: psmdebug 0x00ff8181, phydebug 0x00000031, psm_brc 0x0000

--=-2HpOzPoUAaf+rqqHxVvK
Content-Disposition: attachment; filename="lspci.log"
Content-Type: text/x-log; name="lspci.log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

00:00.0 Host bridge [0600]: Intel Corporation Core Processor DRAM Controller [8086:0044] (rev 02)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller [0300]: Intel Corporation Core Processor Integrated Graphics Controller [8086:0046] (rev 02) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0, IRQ 41
	Memory at b0000000 (64-bit, non-prefetchable) [size=4M]
	Memory at a0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 3050 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915
	Kernel modules: i915

00:16.0 Communication controller [0780]: Intel Corporation 5 Series/3400 Series Chipset HECI Controller [8086:3b64] (rev 06)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0, IRQ 5
	Memory at b4406100 (64-bit, non-prefetchable) [size=16]
	Capabilities: <access denied>

00:1a.0 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b3c] (rev 05) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, medium devsel, latency 0, IRQ 16
	Memory at b4405c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device [0403]: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio [8086:3b56] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0, IRQ 43
	Memory at b4400000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 [8086:3b42] (rev 05) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: b3400000-b43fffff
	Prefetchable memory behind bridge: 00000000b0400000-00000000b13fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.1 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 [8086:3b44] (rev 05) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: b2400000-b33fffff
	Prefetchable memory behind bridge: 00000000b1400000-00000000b23fffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1d.0 USB Controller [0c03]: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller [8086:3b34] (rev 05) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, medium devsel, latency 0, IRQ 20
	Memory at b4405800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev a5) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
	Capabilities: <access denied>

00:1f.0 ISA bridge [0601]: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller [8086:3b09] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, medium devsel, latency 0
	Capabilities: <access denied>
	Kernel modules: iTCO_wdt

00:1f.2 SATA controller [0106]: Intel Corporation 5 Series/3400 Series Chipset 4 port SATA AHCI Controller [8086:3b29] (rev 05) (prog-if 01 [AHCI 1.0])
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 40
	I/O ports at 3048 [size=8]
	I/O ports at 305c [size=4]
	I/O ports at 3040 [size=8]
	I/O ports at 3058 [size=4]
	I/O ports at 3020 [size=32]
	Memory at b4405000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:1f.3 SMBus [0c05]: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller [8086:3b30] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: medium devsel, IRQ 19
	Memory at b4406000 (64-bit, non-prefetchable) [size=256]
	I/O ports at 3000 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

00:1f.6 Signal processing controller [1180]: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem [8086:3b32] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0, IRQ 21
	Memory at b4404000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
	Kernel driver in use: intel ips
	Kernel modules: intel_ips

01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 03)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0, IRQ 42
	I/O ports at 2000 [size=256]
	Memory at b0404000 (64-bit, prefetchable) [size=4K]
	Memory at b0400000 (64-bit, prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: r8169
	Kernel modules: r8169

02:00.0 Network controller [0280]: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
	Subsystem: Hewlett-Packard Company Device [103c:1483]
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at b2400000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: brcmsmac
	Kernel modules: brcmsmac

ff:00.0 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers [8086:2c62] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0

ff:00.1 Host bridge [0600]: Intel Corporation Core Processor QuickPath Architecture System Address Decoder [8086:2d01] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0

ff:02.0 Host bridge [0600]: Intel Corporation Core Processor QPI Link 0 [8086:2d10] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0

ff:02.1 Host bridge [0600]: Intel Corporation Core Processor QPI Physical 0 [8086:2d11] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0

ff:02.2 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d12] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0

ff:02.3 Host bridge [0600]: Intel Corporation Core Processor Reserved [8086:2d13] (rev 05)
	Subsystem: Hewlett-Packard Company Device [103c:146a]
	Flags: bus master, fast devsel, latency 0


--=-2HpOzPoUAaf+rqqHxVvK--

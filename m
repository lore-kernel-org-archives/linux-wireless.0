Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:54103 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965088AbaDJKMn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 06:12:43 -0400
Date: Thu, 10 Apr 2014 12:12:41 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: ilw@linux.intel.com
cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
	emmanuel.grumbach@intel.com
Subject: iwlwifi resets and causes a panic
Message-ID: <alpine.LSU.2.11.1404101208050.20275@nerf08.vanv.qr> (sfid-20140410_121314_301610_6D626039)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


iwlwifi flakes out (trace below) and seems to be taking out the
entire machine sometimes towards a panic (no trace available).

	iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.

lspci:
03:00.0 Network controller: Intel Corporation Wireless 7260 (rev 83)
03:00.0 0280: 8086:08b2 (rev 83)
The system is a Lenovo X240.

config parts:
CONFIG_IWLWIFI=m
CONFIG_IWLDVM=m
CONFIG_IWLMVM=m
CONFIG_IWLWIFI_OPMODE_MODULAR=y
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUGFS=y
# CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE is not set
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
CONFIG_IWLEGACY=m
CONFIG_IWL4965=m
CONFIG_IWL3945=m
# CONFIG_IWLEGACY_DEBUG is not set
# CONFIG_IWLEGACY_DEBUGFS is not set

dmesg:
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Initializing cgroup subsys cpuacct
Linux version 3.13.4-desktop (geeko@buildhost) (gcc version 4.8.1 20130909 [gcc-4_8-branch revision 202388] (SUSE Linux) ) #1 SMP PREEMPT Sun Feb 23 05:47:32 UTC 2014 (c374aa2)
Command line: BOOT_IMAGE=/vmlinuz-3.13.4-desktop root=UUID=f63e9dea-e8c1-4a26-90de-a79d4bd0ff0b showopts
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reserved
BIOS-e820: [mem 0x0000000000059000-0x000000000008bfff] usable
BIOS-e820: [mem 0x000000000008c000-0x00000000000bffff] reserved
BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x00000000cfdebfff] usable
BIOS-e820: [mem 0x00000000cfdec000-0x00000000cffedfff] reserved
BIOS-e820: [mem 0x00000000cffee000-0x00000000da462fff] usable
BIOS-e820: [mem 0x00000000da463000-0x00000000dcd3efff] reserved
BIOS-e820: [mem 0x00000000dcd3f000-0x00000000dce7efff] ACPI NVS
BIOS-e820: [mem 0x00000000dce7f000-0x00000000dcefefff] ACPI data
BIOS-e820: [mem 0x00000000dceff000-0x00000000dcefffff] usable
BIOS-e820: [mem 0x00000000dcf00000-0x00000000df9fffff] reserved
BIOS-e820: [mem 0x00000000f80f8000-0x00000000f80f8fff] reserved
BIOS-e820: [mem 0x00000000fe101000-0x00000000fe112fff] reserved
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000021e5fffff] usable
NX (Execute Disable) protection: active
efi: EFI v2.31 by Lenovo
efi:  ACPI=0xdcefe000  ACPI 2.0=0xdcefe014  SMBIOS=0xdcd3e000 
efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
efi: mem01: type=4, attr=0xf, range=[0x0000000000001000-0x0000000000002000) (0MB)
efi: mem02: type=3, attr=0xf, range=[0x0000000000002000-0x000000000000c000) (0MB)
efi: mem03: type=7, attr=0xf, range=[0x000000000000c000-0x0000000000058000) (0MB)
efi: mem04: type=0, attr=0xf, range=[0x0000000000058000-0x0000000000059000) (0MB)
efi: mem05: type=7, attr=0xf, range=[0x0000000000059000-0x0000000000069000) (0MB)
efi: mem06: type=4, attr=0xf, range=[0x0000000000069000-0x000000000006b000) (0MB)
efi: mem07: type=3, attr=0xf, range=[0x000000000006b000-0x000000000008c000) (0MB)
efi: mem08: type=0, attr=0xf, range=[0x000000000008c000-0x00000000000a0000) (0MB)
efi: mem09: type=0, attr=0x0, range=[0x00000000000e0000-0x0000000000100000) (0MB)
efi: mem10: type=3, attr=0xf, range=[0x0000000000100000-0x0000000000110000) (0MB)
efi: mem11: type=2, attr=0xf, range=[0x0000000000110000-0x000000000111d000) (16MB)
efi: mem12: type=7, attr=0xf, range=[0x000000000111d000-0x0000000002000000) (14MB)
efi: mem13: type=2, attr=0xf, range=[0x0000000002000000-0x000000000300d000) (16MB)
efi: mem14: type=7, attr=0xf, range=[0x000000000300d000-0x0000000036dc0000) (829MB)
efi: mem15: type=2, attr=0xf, range=[0x0000000036dc0000-0x00000000376d8000) (9MB)
efi: mem16: type=7, attr=0xf, range=[0x00000000376d8000-0x0000000098b77000) (1556MB)
efi: mem17: type=2, attr=0xf, range=[0x0000000098b77000-0x00000000ce234000) (854MB)
efi: mem18: type=4, attr=0xf, range=[0x00000000ce234000-0x00000000ce254000) (0MB)
efi: mem19: type=7, attr=0xf, range=[0x00000000ce254000-0x00000000cfdd5000) (27MB)
efi: mem20: type=4, attr=0xf, range=[0x00000000cfdd5000-0x00000000cfdec000) (0MB)
efi: mem21: type=0, attr=0xf, range=[0x00000000cfdec000-0x00000000cffee000) (2MB)
efi: mem22: type=4, attr=0xf, range=[0x00000000cffee000-0x00000000d1224000) (18MB)
efi: mem23: type=7, attr=0xf, range=[0x00000000d1224000-0x00000000d1445000) (2MB)
efi: mem24: type=1, attr=0xf, range=[0x00000000d1445000-0x00000000d1463000) (0MB)
efi: mem25: type=7, attr=0xf, range=[0x00000000d1463000-0x00000000d3a90000) (38MB)
efi: mem26: type=4, attr=0xf, range=[0x00000000d3a90000-0x00000000d4e31000) (19MB)
efi: mem27: type=7, attr=0xf, range=[0x00000000d4e31000-0x00000000d4e45000) (0MB)
efi: mem28: type=4, attr=0xf, range=[0x00000000d4e45000-0x00000000d6463000) (22MB)
efi: mem29: type=7, attr=0xf, range=[0x00000000d6463000-0x00000000d9a4d000) (53MB)
efi: mem30: type=2, attr=0xf, range=[0x00000000d9a4d000-0x00000000d9a57000) (0MB)
efi: mem31: type=3, attr=0xf, range=[0x00000000d9a57000-0x00000000da463000) (10MB)
efi: mem32: type=5, attr=0x800000000000000f, range=[0x00000000da463000-0x00000000da663000) (2MB)
efi: mem33: type=6, attr=0x800000000000000f, range=[0x00000000da663000-0x00000000db439000) (13MB)
efi: mem34: type=0, attr=0xf, range=[0x00000000db439000-0x00000000dcd3f000) (25MB)
efi: mem35: type=10, attr=0xf, range=[0x00000000dcd3f000-0x00000000dce7f000) (1MB)
efi: mem36: type=9, attr=0xf, range=[0x00000000dce7f000-0x00000000dceff000) (0MB)
efi: mem37: type=4, attr=0xf, range=[0x00000000dceff000-0x00000000dcf00000) (0MB)
efi: mem38: type=7, attr=0xf, range=[0x0000000100000000-0x000000021e600000) (4582MB)
efi: mem39: type=0, attr=0x0, range=[0x00000000000a0000-0x00000000000c0000) (0MB)
efi: mem40: type=0, attr=0x0, range=[0x00000000dcf00000-0x00000000dfa00000) (43MB)
efi: mem41: type=11, attr=0x8000000000000001, range=[0x00000000f80f8000-0x00000000f80f9000) (0MB)
efi: mem42: type=0, attr=0x0, range=[0x00000000fe101000-0x00000000fe113000) (0MB)
efi: mem43: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
efi: mem44: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
efi: mem45: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
efi: mem46: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
efi: mem47: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
efi: mem48: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
efi: mem49: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
efi: mem50: type=0, attr=0x0, range=[0x0000000000000000-0x0000000000000000) (0MB)
SMBIOS 2.7 present.
DMI: LENOVO 20AL00C6GE/20AL00C6GE, BIOS GIET67WW (2.17 ) 01/08/2014
e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
No AGP bridge found
e820: last_pfn = 0x21e600 max_arch_pfn = 0x400000000
MTRR default type: write-back
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 00E0000000 mask 7FE0000000 uncachable
  1 base 00DE000000 mask 7FFE000000 uncachable
  2 base 00DD000000 mask 7FFF000000 uncachable
  3 base 00DCF00000 mask 7FFFF00000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
  8 disabled
  9 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820: last_pfn = 0xdcf00 max_arch_pfn = 0x400000000
Scanning 1 areas for low memory corruption
Base memory trampoline at [ffff88000005f000] 5f000 size 24576
Using GB pages for direct mapping
init_memory_mapping: [mem 0x00000000-0x000fffff]
 [mem 0x00000000-0x000fffff] page 4k
BRK [0x02d58000, 0x02d58fff] PGTABLE
BRK [0x02d59000, 0x02d59fff] PGTABLE
BRK [0x02d5a000, 0x02d5afff] PGTABLE
init_memory_mapping: [mem 0x21e400000-0x21e5fffff]
 [mem 0x21e400000-0x21e5fffff] page 2M
BRK [0x02d5b000, 0x02d5bfff] PGTABLE
init_memory_mapping: [mem 0x21c000000-0x21e3fffff]
 [mem 0x21c000000-0x21e3fffff] page 2M
init_memory_mapping: [mem 0x200000000-0x21bffffff]
 [mem 0x200000000-0x21bffffff] page 2M
init_memory_mapping: [mem 0x00100000-0xcfdebfff]
 [mem 0x00100000-0x001fffff] page 4k
 [mem 0x00200000-0x3fffffff] page 2M
 [mem 0x40000000-0xbfffffff] page 1G
 [mem 0xc0000000-0xcfbfffff] page 2M
 [mem 0xcfc00000-0xcfdebfff] page 4k
init_memory_mapping: [mem 0xcffee000-0xda462fff]
 [mem 0xcffee000-0xcfffffff] page 4k
 [mem 0xd0000000-0xda3fffff] page 2M
 [mem 0xda400000-0xda462fff] page 4k
BRK [0x02d5c000, 0x02d5cfff] PGTABLE
BRK [0x02d5d000, 0x02d5dfff] PGTABLE
init_memory_mapping: [mem 0xdceff000-0xdcefffff]
 [mem 0xdceff000-0xdcefffff] page 4k
init_memory_mapping: [mem 0x100000000-0x1ffffffff]
 [mem 0x100000000-0x1ffffffff] page 1G
RAMDISK: [mem 0x36dc0000-0x376d7fff]
ACPI: RSDP 00000000dcefe014 000024 (v02 LENOVO)
ACPI: XSDT 00000000dcefe170 0000EC (v01 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI: FACP 00000000dcef8000 00010C (v05 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI Error: Gpe0Block - 32-bit FADT register is too long (32 bytes, 256 bits) to convert to GAS struct - 255 bits max, truncating (20131115/tbfadt-202)
ACPI: DSDT 00000000dcee2000 010A75 (v01 LENOVO TP-GI    00002170 INTL 20120711)
ACPI: FACS 00000000dce4a000 000040
ACPI: SLIC 00000000dcefd000 000176 (v01 LENOVO TP-GI    00002170 PTEC 00000001)
ACPI: DBGP 00000000dcefb000 000034 (v01 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI: ECDT 00000000dcefa000 000052 (v01 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI: HPET 00000000dcef7000 000038 (v01 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI: APIC 00000000dcef6000 000098 (v01 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI: MCFG 00000000dcef5000 00003C (v01 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI: SSDT 00000000dcef4000 000033 (v01 LENOVO TP-SSDT1 00000100 INTL 20120711)
ACPI: SSDT 00000000dcef3000 00044F (v01 LENOVO TP-SSDT2 00000200 INTL 20120711)
ACPI: SSDT 00000000dcee1000 0009CB (v01 LENOVO SataAhci 00001000 INTL 20120711)
ACPI: SSDT 00000000dcee0000 000152 (v01 LENOVO Rmv_Batt 00001000 INTL 20120711)
ACPI: SSDT 00000000dcedf000 0007F5 (v01 LENOVO  Cpu0Ist 00003000 INTL 20120711)
ACPI: SSDT 00000000dcede000 000AD8 (v01 LENOVO    CpuPm 00003000 INTL 20120711)
ACPI: SSDT 00000000dcedc000 001215 (v01 LENOVO  SaSsdt  00003000 INTL 20120711)
ACPI: SSDT 00000000dcedb000 000379 (v01 LENOVO CppcTabl 00001000 INTL 20120711)
ACPI: PCCT 00000000dceda000 00006E (v05 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI: SSDT 00000000dced9000 000AC4 (v01 LENOVO Cpc_Tabl 00001000 INTL 20120711)
ACPI: TCPA 00000000dced8000 000032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
ACPI: UEFI 00000000dced7000 000042 (v01 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI: MSDM 00000000dcdb2000 000055 (v03 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI: ASF! 00000000dcefc000 0000A5 (v32 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI: BATB 00000000dced6000 000046 (v01 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI: FPDT 00000000dced5000 000064 (v01 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI: UEFI 00000000dced4000 0002E2 (v01 LENOVO TP-GI    00002170 PTEC 00000002)
ACPI: SSDT 00000000dced3000 00047F (v01 LENOVO IsctTabl 00001000 INTL 20120711)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at [mem 0x0000000000000000-0x000000021e5fffff]
Initmem setup node 0 [mem 0x00000000-0x21e5fffff]
  NODE_DATA [mem 0x21e5e9000-0x21e5fcfff]
 [ffffea0000000000-ffffea00077fffff] PMD -> [ffff880215c00000-ffff88021cdfffff] on node 0
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   [mem 0x100000000-0x21e5fffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x00057fff]
  node   0: [mem 0x00059000-0x0008bfff]
  node   0: [mem 0x00100000-0xcfdebfff]
  node   0: [mem 0xcffee000-0xda462fff]
  node   0: [mem 0xdceff000-0xdcefffff]
  node   0: [mem 0x100000000-0x21e5fffff]
On node 0 totalpages: 2066412
  DMA zone: 56 pages used for memmap
  DMA zone: 73 pages reserved
  DMA zone: 3978 pages, LIFO batch:0
  DMA32 zone: 12161 pages used for memmap
  DMA32 zone: 889442 pages, LIFO batch:31
  Normal zone: 16037 pages used for memmap
  Normal zone: 1172992 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-39
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
smpboot: Allowing 8 CPUs, 4 hotplug CPUs
nr_irqs_gsi: 56
PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
PM: Registered nosave memory: [mem 0x0008c000-0x000bffff]
PM: Registered nosave memory: [mem 0x000c0000-0x000dffff]
PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
PM: Registered nosave memory: [mem 0xcfdec000-0xcffedfff]
PM: Registered nosave memory: [mem 0xda463000-0xdcd3efff]
PM: Registered nosave memory: [mem 0xdcd3f000-0xdce7efff]
PM: Registered nosave memory: [mem 0xdce7f000-0xdcefefff]
PM: Registered nosave memory: [mem 0xdcf00000-0xdf9fffff]
PM: Registered nosave memory: [mem 0xdfa00000-0xf80f7fff]
PM: Registered nosave memory: [mem 0xf80f8000-0xf80f8fff]
PM: Registered nosave memory: [mem 0xf80f9000-0xfe100fff]
PM: Registered nosave memory: [mem 0xfe101000-0xfe112fff]
PM: Registered nosave memory: [mem 0xfe113000-0xfed1bfff]
PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
PM: Registered nosave memory: [mem 0xfed20000-0xffffffff]
e820: [mem 0xdfa00000-0xf80f7fff] available for PCI devices
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 27 pages/cpu @ffff88021e200000 s81536 r8192 d20864 u262144
pcpu-alloc: s81536 r8192 d20864 u262144 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2038085
Policy zone: Normal
Kernel command line: BOOT_IMAGE=/vmlinuz-3.13.4-desktop root=UUID=f63e9dea-e8c1-4a26-90de-a79d4bd0ff0b showopts
PID hash table entries: 4096 (order: 3, 32768 bytes)
xsave: enabled xstate_bv 0x7, cntxt size 0x340
Checking aperture...
No AGP bridge found
Memory: 7986452K/8265648K available (4332K kernel code, 691K rwdata, 4036K rodata, 1212K init, 1496K bss, 279196K reserved)
Preemptible hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=8.
	Offload RCU callbacks from all CPUs
	Offload RCU callbacks from CPUs: 0-7.
NR_IRQS:33024 nr_irqs:1016 16
Console: colour dummy device 80x25
console [tty0] enabled
allocated 33554432 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 2693.746 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 5387.49 BogoMIPS (lpj=2693746)
pid_max: default: 32768 minimum: 301
init_memory_mapping: [mem 0xda463000-0xda662fff]
 [mem 0xda463000-0xda662fff] page 4k
init_memory_mapping: [mem 0xda663000-0xdb438fff]
 [mem 0xda663000-0xda7fffff] page 4k
 [mem 0xda800000-0xdb3fffff] page 2M
 [mem 0xdb400000-0xdb438fff] page 4k
Security Framework initialized
AppArmor: AppArmor initialized
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Initializing cgroup subsys perf_event
Initializing cgroup subsys hugetlb
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
S: View and update with x86_energy_perf_policy(8)
mce: CPU supports 7 MCE banks
CPU0: Thermal monitoring enabled (TM1)
Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
 entries: 4KB 64, 2MB 0, 4MB 0
ift: 6
Freeing SMP alternatives memory: 12K (ffffffff81bdd000 - ffffffff81be0000)
ACPI: Core revision 20131115
ACPI: All ACPI Tables successfully acquired
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: Intel(R) Core(TM) i7-4600U CPU @ 2.10GHz (fam: 06, model: 45, stepping: 01)
TSC deadline timer enabled
Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             0000ffffffffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
x86: Booting SMP configuration:
NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
.... node  #0, CPUs:      #1 #2 #3
x86: Booted up 1 node, 4 CPUs
smpboot: Total of 4 processors activated (21549.96 BogoMIPS)
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0xdcd3f000-0xdce7efff] (1310720 bytes)
pinctrl core: initialized pinctrl subsystem
RTC time: 10:02:01, date: 04/10/14
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type PCI registered
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI : EC: EC description table is found, configuring boot EC
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 00000000dccd7918 000436 (v01  PmRef  Cpu0Cst 00003001 INTL 20120711)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 000436 (v01  PmRef  Cpu0Cst 00003001 INTL 20120711)
ACPI: SSDT 00000000dcd2e618 0005AA (v01  PmRef    ApIst 00003000 INTL 20120711)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 0005AA (v01  PmRef    ApIst 00003000 INTL 20120711)
ACPI: SSDT 00000000dcd2fc18 000119 (v01  PmRef    ApCst 00003000 INTL 20120711)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 000119 (v01  PmRef    ApCst 00003000 INTL 20120711)
ACPI: Interpreter enabled
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: ACPI Dock Station Driver: 1 docks/bays found
ACPI: Power Resource [PUBS] (on)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-3f]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff]
pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
pci 0000:00:00.0: [8086:0a04] type 00 class 0x060000
pci 0000:00:02.0: [8086:0a16] type 00 class 0x030000
pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
pci 0000:00:03.0: [8086:0a0c] type 00 class 0x040300
pci 0000:00:03.0: reg 0x10: [mem 0xf0630000-0xf0633fff 64bit]
pci 0000:00:14.0: [8086:9c31] type 00 class 0x0c0330
pci 0000:00:14.0: reg 0x10: [mem 0xf0620000-0xf062ffff 64bit]
pci 0000:00:14.0: PME# supported from D3hot D3cold
pci 0000:00:14.0: System wakeup disabled by ACPI
pci 0000:00:16.0: [8086:9c3a] type 00 class 0x078000
pci 0000:00:16.0: reg 0x10: [mem 0xf0639000-0xf063901f 64bit]
pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
pci 0000:00:16.3: [8086:9c3d] type 00 class 0x070002
pci 0000:00:16.3: reg 0x10: [io  0x30b0-0x30b7]
pci 0000:00:16.3: reg 0x14: [mem 0xf063f000-0xf063ffff]
pci 0000:00:19.0: [8086:155a] type 00 class 0x020000
pci 0000:00:19.0: reg 0x10: [mem 0xf0600000-0xf061ffff]
pci 0000:00:19.0: reg 0x14: [mem 0xf063e000-0xf063efff]
pci 0000:00:19.0: reg 0x18: [io  0x3080-0x309f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: System wakeup disabled by ACPI
pci 0000:00:1b.0: [8086:9c20] type 00 class 0x040300
pci 0000:00:1b.0: reg 0x10: [mem 0xf0634000-0xf0637fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:9c1a] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: [8086:9c14] type 01 class 0x060400
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: System wakeup disabled by ACPI
pci 0000:00:1d.0: [8086:9c26] type 00 class 0x0c0320
pci 0000:00:1d.0: reg 0x10: [mem 0xf063d000-0xf063d3ff]
pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: System wakeup disabled by ACPI
pci 0000:00:1f.0: [8086:9c43] type 00 class 0x060100
pci 0000:00:1f.2: [8086:9c03] type 00 class 0x010601
pci 0000:00:1f.2: reg 0x10: [io  0x30a8-0x30af]
pci 0000:00:1f.2: reg 0x14: [io  0x30bc-0x30bf]
pci 0000:00:1f.2: reg 0x18: [io  0x30a0-0x30a7]
pci 0000:00:1f.2: reg 0x1c: [io  0x30b8-0x30bb]
pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
pci 0000:00:1f.2: reg 0x24: [mem 0xf063c000-0xf063c7ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.3: [8086:9c22] type 00 class 0x0c0500
pci 0000:00:1f.3: reg 0x10: [mem 0xf0638000-0xf06380ff 64bit]
pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
pci 0000:02:00.0: [10ec:5227] type 00 class 0xff0000
pci 0000:02:00.0: reg 0x10: [mem 0xf0500000-0xf0500fff]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:00:1c.0:   bridge window [mem 0xf0500000-0xf05fffff]
pci 0000:03:00.0: [8086:08b2] type 00 class 0x028000
pci 0000:03:00.0: reg 0x10: [mem 0xf0400000-0xf0401fff 64bit]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [mem 0xf0400000-0xf04fffff]
ACPI: Enabled 4 GPEs in block 00 to 7F
ACPI: \_SB_.PCI0: notify handler is installed
Found 1 acpi root devices
ACPI : EC: GPE = 0x25, I/O: command/status = 0x66, data = 0x62
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
e820: reserve RAM buffer [mem 0x0008c000-0x0008ffff]
e820: reserve RAM buffer [mem 0xcfdec000-0xcfffffff]
e820: reserve RAM buffer [mem 0xda463000-0xdbffffff]
e820: reserve RAM buffer [mem 0xdcf00000-0xdfffffff]
e820: reserve RAM buffer [mem 0x21e600000-0x21fffffff]
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Switched to clocksource hpet
AppArmor: AppArmor Filesystem Enabled
pnp: PnP ACPI init
ACPI: bus type PNP registered
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
system 00:00: [mem 0x000c8000-0x000cbfff] could not be reserved
system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
system 00:00: [mem 0xfed4c000-0xffffffff] has been reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
system 00:01: [io  0x1800-0x189f] could not be reserved
system 00:01: [io  0x0800-0x087f] has been reserved
system 00:01: [io  0x0880-0x08ff] has been reserved
system 00:01: [io  0x0900-0x097f] has been reserved
system 00:01: [io  0x0980-0x09ff] has been reserved
system 00:01: [io  0x0a00-0x0a7f] has been reserved
system 00:01: [io  0x0a80-0x0aff] has been reserved
system 00:01: [io  0x0b00-0x0b7f] has been reserved
system 00:01: [io  0x0b80-0x0bff] has been reserved
system 00:01: [io  0x15e0-0x15ef] has been reserved
system 00:01: [io  0x1600-0x167f] has been reserved
system 00:01: [io  0x1640-0x165f] has been reserved
system 00:01: [mem 0xf8000000-0xfbffffff] could not be reserved
system 00:01: [mem 0x00000000-0x00000fff] could not be reserved
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:03: [dma 4]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: Plug and Play ACPI device, IDs LEN0071 PNP0303 (active)
pnp 00:08: Plug and Play ACPI device, IDs LEN0035 PNP0f13 (active)
pnp 00:09: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
pnp: PnP ACPI: found 10 devices
ACPI: bus type PNP unregistered
rpldhk 2.40, by Jan Engelhardt, 2004-2012
pci 0000:00:1c.0: PCI bridge to [bus 02]
pci 0000:00:1c.0:   bridge window [mem 0xf0500000-0xf05fffff]
pci 0000:00:1c.1: PCI bridge to [bus 03]
pci 0000:00:1c.1:   bridge window [mem 0xf0400000-0xf04fffff]
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfebfffff]
pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
pci_bus 0000:02: resource 1 [mem 0xf0500000-0xf05fffff]
pci_bus 0000:03: resource 1 [mem 0xf0400000-0xf04fffff]
NET: Registered protocol family 2
TCP established hash table entries: 65536 (order: 7, 524288 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP: reno registered
UDP hash table entries: 4096 (order: 5, 131072 bytes)
UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
Unpacking initramfs...
Freeing initrd memory: 9312K (ffff880036dc0000 - ffff8800376d8000)
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
software IO TLB [mem 0xca234000-0xce234000] (64MB) mapped at [ffff8800ca234000-ffff8800ce233fff]
microcode: CPU0 sig=0x40651, pf=0x40, revision=0x17
microcode: CPU1 sig=0x40651, pf=0x40, revision=0x17
microcode: CPU2 sig=0x40651, pf=0x40, revision=0x17
microcode: CPU3 sig=0x40651, pf=0x40, revision=0x17
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Scanning for low memory corruption every 60 seconds
Initialise system trusted keyring
audit: initializing netlink socket (disabled)
type=2000 audit(1397124121.361:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
zbud: loaded
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 15757
Key type big_key registered
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
efifb: probing for efifb
efifb: framebuffer at 0xe0000000, mapped to 0xffffc90004e80000, using 1216k, total 1216k
efifb: mode is 640x480x32, linelength=2560, pages=1
efifb: scrolling: redraw
efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
Console: switching to colour frame buffer device 80x30
fb0: EFI VGA frame buffer device
intel_idle: MWAIT substates: 0x11142120
intel_idle: v0.4 model 0x45
intel_idle: lapic_timer_reliable_states 0xffffffff
GHES: HEST is not enabled!
Serial: 8250/16550 driver, 16 ports, IRQ sharing disabled
0000:00:16.3: ttyS4 at I/O 0x30b0 (irq = 17, base_baud = 115200) is a 16550A
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: irq 56 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 3 ports 6 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo only pio slum part deso sadm sds apst 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
ata1: SATA max UDMA/133 abar m2048@0xf063c000 port 0xf063c100 irq 56
ata2: DUMMY
ata3: DUMMY
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:06: RTC can wake from S4
rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
rtc_cmos 00:06: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Intel P-state driver initializing.
Intel pstate controlling: cpu 0
Intel pstate controlling: cpu 1
Intel pstate controlling: cpu 2
Intel pstate controlling: cpu 3
ledtrig-cpu: registered to indicate activity on CPUs
EFI Variables Facility v0.08 2004-May-17
TCP: hybla registered
NET: Registered protocol family 10
Key type dns_resolver registered
Loading compiled-in X.509 certificates
registered taskstats version 1
AppArmor: AppArmor sha1 policy hashing enabled
  Magic number: 10:757:21
memory memory61: hash matches
rtc_cmos 00:06: setting system clock to 2014-04-10 10:02:01 UTC (1397124121)
PM: Hibernation image not present or could not be loaded.
ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:09:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: supports DRM functions and may not be fully accessible
ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
ata1.00: ATA-9: SAMSUNG MZ7TD256HAFV-000L9, DXT02L5Q, max UDMA/133
ata1.00: 500118192 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd ef/10:09:00:00:00:a0 (SET FEATURES) succeeded
ata1.00: supports DRM functions and may not be fully accessible
ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG MZ7TD256 DXT0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
Freeing unused kernel memory: 1212K (ffffffff81aae000 - ffffffff81bdd000)
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 1800K (ffff88000243e000 - ffff880002600000)
Freeing unused kernel memory: 60K (ffff8800029f1000 - ffff880002a00000)
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
alua: device handler registered
emc: device handler registered
hp_sw: device handler registered
rdac: device handler registered
systemd-udevd[138]: starting version 208
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (59 C)
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
xhci_hcd 0000:00:14.0: xHCI Host Controller
ehci-pci: EHCI PCI platform driver
xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
xhci_hcd 0000:00:14.0: irq 57 for MSI/MSI-X
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: xHCI Host Controller
usb usb1: Manufacturer: Linux 3.13.4-desktop xhci_hcd
usb usb1: SerialNumber: 0000:00:14.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 9 ports detected
xhci_hcd 0000:00:14.0: xHCI Host Controller
xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: xHCI Host Controller
usb usb2: Manufacturer: Linux 3.13.4-desktop xhci_hcd
usb usb2: SerialNumber: 0000:00:14.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ehci-pci 0000:00:1d.0: EHCI Host Controller
ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 3
ehci-pci 0000:00:1d.0: debug port 2
ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
ehci-pci 0000:00:1d.0: irq 23, io mem 0xf063d000
ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: EHCI Host Controller
usb usb3: Manufacturer: Linux 3.13.4-desktop ehci_hcd
usb usb3: SerialNumber: 0000:00:1d.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
psmouse serio1: synaptics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x127c00, board id: 2749, fw id: 1486693
psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input2
usb 1-2: new low-speed USB device number 2 using xhci_hcd
usb 1-2: New USB device found, idVendor=04f3, idProduct=0210
usb 1-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
usb 1-2: Product: PS/2+USB Mouse
usb 1-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
hidraw: raw HID events driver (C) Jiri Kosina
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
input: PS/2+USB Mouse as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/input/input4
hid-generic 0003:04F3:0210.0001: input,hidraw0: USB HID v1.11 Mouse [PS/2+USB Mouse] on usb-0000:00:14.0-2/input0
usb 1-4: new high-speed USB device number 3 using xhci_hcd
tsc: Refined TSC clocksource calibration: 2693.763 MHz
usb 1-4: New USB device found, idVendor=1199, idProduct=a001
usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-4: Product: Sierra Wireless EM7345 4G LTE
usb 1-4: Manufacturer: Sierra Wireless Inc.
usb 1-4: SerialNumber: 013937000191039
usb 1-6: new full-speed USB device number 4 using xhci_hcd
usb 1-6: New USB device found, idVendor=138a, idProduct=0017
usb 1-6: New USB device strings: Mfr=0, Product=0, SerialNumber=1
usb 1-6: SerialNumber: bc6bdd516c3c
usb 1-7: new full-speed USB device number 5 using xhci_hcd
usb 1-7: New USB device found, idVendor=8087, idProduct=07dc
usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-8: new high-speed USB device number 6 using xhci_hcd
usb 1-8: New USB device found, idVendor=04ca, idProduct=7035
usb 1-8: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-8: Product: Integrated Camera
usb 1-8: Manufacturer: J31DBS0FB
usb 3-1: new high-speed USB device number 2 using ehci-pci
usb 3-1: New USB device found, idVendor=8087, idProduct=8000
usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 3-1:1.0: USB hub found
hub 3-1:1.0: 8 ports detected
Switched to clocksource tsc
usb 3-1.5: new full-speed USB device number 3 using ehci-pci
usb 3-1.5: No LPM exit latency info found.  Power management will be impacted.
usb 3-1.5: New USB device found, idVendor=058f, idProduct=9540
usb 3-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1.5: Product: EMV Smartcard Reader
usb 3-1.5: Manufacturer: Generic
random: nonblocking pool is initialized
psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input3
bio: create slab <bio-1> at 1
bio: create slab <bio-1> at 1
xor: automatically using best checksumming function:
   avx       : 33052.000 MB/sec
raid6: sse2x1   10097 MB/s
raid6: sse2x2   13164 MB/s
raid6: sse2x4   15371 MB/s
raid6: avx2x1   19792 MB/s
raid6: avx2x2   23277 MB/s
raid6: avx2x4   27230 MB/s
raid6: using algorithm avx2x4 (27230 MB/s)
raid6: using avx2x2 recovery algorithm
bio: create slab <bio-2> at 2
Btrfs loaded, assert=on
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
XFS (dm-0): Mounting Filesystem
XFS (dm-0): Starting recovery (logdev: internal)
XFS (dm-0): Ending recovery (logdev: internal)
systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX -IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
systemd[1]: Inserted module 'autofs4'
systemd[1]: Set hostname to <fumidasu>.
LVM: Logical Volume autoactivation enabled.
LVM: Activation generator successfully completed.
systemd[1]: Cannot add dependency job for unit hwclock-load.service, ignoring: Unit hwclock-load.service failed to load: No such file or directory.
systemd[1]: Starting Replay Read-Ahead Data...
systemd[1]: Starting Collect Read-Ahead Data...
systemd[1]: Starting Syslog Socket.
systemd[1]: Listening on Syslog Socket.
systemd[1]: Starting Remote File Systems (Pre).
systemd[1]: Reached target Remote File Systems (Pre).
systemd[1]: Starting Remote File Systems.
systemd[1]: Reached target Remote File Systems.
systemd[1]: Expecting device dev-sda.device...
systemd[1]: Starting Delayed Shutdown Socket.
systemd[1]: Listening on Delayed Shutdown Socket.
systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
systemd[1]: Starting LVM2 metadata daemon socket.
systemd[1]: Listening on LVM2 metadata daemon socket.
systemd[1]: Starting udev Kernel Socket.
systemd[1]: Listening on udev Kernel Socket.
systemd[1]: Starting udev Control Socket.
systemd[1]: Listening on udev Control Socket.
systemd[1]: Starting Journal Socket.
systemd[1]: Listening on Journal Socket.
systemd[1]: Starting Create dynamic rule for /dev/root link...
systemd[1]: Starting Journal Service...
systemd[1]: Started Journal Service.
systemd-journald[320]: Vacuuming done, freed 0 bytes
TCP: veno registered
sd 0:0:0:0: Attached scsi generic sg0 type 0
systemd-udevd[348]: starting version 208
systemd-journald[320]: Received request to flush runtime journal from PID 1
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input5
ACPI: Lid Switch [LID]
systemd-journald[320]: File /var/log/journal/455140e65d6e15bd126fa51e000010ab/system.journal corrupted or uncleanly shut down, renaming and replacing.
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input6
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input7
ACPI: Power Button [PWRF]
ACPI: AC Adapter [AC] (on-line)
wmi: Mapper loaded
Non-volatile memory driver v1.3
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
tpm_tis 00:09: 1.2 TPM (device-id 0x0, rev-id 78)
PTP clock support registered
ACPI: Battery Slot [BAT0] (battery present)
Linux agpgart interface v0.103
Bluetooth: Core ver 2.17
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
ACPI: Battery Slot [BAT1] (battery present)
[drm] Initialized drm 1.1.0 20060810
usbcore: registered new interface driver btusb
e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
ACPI Warning: 0x0000000000001828-0x000000000000182f SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1 (20131115/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
usbcore: registered new interface driver cdc_ncm
ACPI Warning: 0x0000000000000830-0x000000000000083f SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20131115/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
ACPI Warning: 0x0000000000000800-0x000000000000082f SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20131115/utaddress-251)
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
lpc_ich: Resource conflict(s) found affecting gpio_ich
usbcore: registered new interface driver cdc_wdm
e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
e1000e 0000:00:19.0: irq 58 for MSI/MSI-X
Bluetooth: hci0: read Intel version: 370710018002030d00
cfg80211: Calling CRDA to update world regulatory domain
rtsx_pci 0000:02:00.0: irq 59 for MSI/MSI-X
rtsx_pci 0000:02:00.0: rtsx_pci_acquire_irq: pcr->msi_en = 1, pci->irq = 59
Linux video capture interface: v2.00
tpm_tis 00:09: TPM is disabled/deactivated (0x6)
Intel(R) Wireless WiFi driver for Linux, in-tree:d
Copyright(c) 2003-2013 Intel Corporation
uvcvideo: Found UVC 1.00 device Integrated Camera (04ca:7035)
iwlwifi 0000:03:00.0: irq 60 for MSI/MSI-X
cdc_acm 1-4:1.2: This device cannot do calls on its own. It is not a modem.
cdc_acm 1-4:1.2: ttyACM0: USB ACM device
usbcore: registered new interface driver cdc_acm
cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
input: Integrated Camera as /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/input/input8
iwlwifi 0000:03:00.0: Direct firmware load failed with error -2
Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
iwlwifi 0000:03:00.0: Falling back to user helper
input: PC Speaker as /devices/platform/pcspkr/input/input9
usbcore: registered new interface driver uvcvideo
USB Video Class driver (1.1.1)
cdc_mbim 1-4:1.0: cdc-wdm0: USB WDM device
cdc_mbim 1-4:1.0 wwan0: register 'cdc_mbim' at usb-0000:00:14.0-4, CDC MBIM, 2e:3d:f3:80:4f:86
usbcore: registered new interface driver cdc_mbim
kvm: disabled by bios
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
iTCO_wdt: Found a Lynx Point_LP TCO device (Version=2, TCOBASE=0x1860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
e1000e 0000:00:19.0: PHY reset is blocked due to SOL/IDER session.
iwlwifi 0000:03:00.0: loaded firmware version 22.0.7.0 op_mode iwlmvm
systemd-udevd[356]: renamed network interface wwan0 to ww0
Bluetooth: hci0: Intel Bluetooth firmware patch completed and activated
iwlwifi 0000:03:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
EXT4-fs (sda2): mounting ext2 file system using the ext4 subsystem
EXT4-fs (sda2): warning: mounting unchecked fs, running e2fsck is recommended
EXT4-fs (sda2): mounted filesystem without journal. Opts: acl,user_xattr
Adding 265212k swap on /dev/sda3.  Priority:-1 extents:1 across:265212k SSFS
FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
thinkpad_acpi: ThinkPad ACPI Extras v0.25
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS GIET67WW (2.17 ), EC unknown
thinkpad_acpi: Lenovo ThinkPad X240, model 20AL00C6GE
thinkpad_acpi: Unsupported brightness interface, please contact ibm-acpi-devel@lists.sourceforge.net
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input10
e1000e 0000:00:19.0 eth0: registered PHC clock
e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 28:d2:44:60:6d:b0
e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: 1000FF-0FF
mei_me 0000:00:16.0: irq 61 for MSI/MSI-X
i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[drm] Memory usable by graphics device = 2048M
checking generic (e0000000 130000) vs hw (e0000000 10000000)
fb: conflicting fb hw usage inteldrmfb vs EFI VGA - removing generic driver
Console: switching to colour dummy device 80x25
systemd-udevd[356]: renamed network interface eth0 to ge0
i915 0000:00:02.0: irq 62 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
systemd-udevd[356]: renamed network interface wlan0 to wl0
[drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
fbcon: inteldrmfb (fb0) is primary device
e1000e 0000:00:19.0: irq 58 for MSI/MSI-X
e1000e 0000:00:19.0: irq 58 for MSI/MSI-X
IPv6: ADDRCONF(NETDEV_UP): ge0: link is not ready
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
IPv6: ADDRCONF(NETDEV_UP): wl0: link is not ready
NET: Registered protocol family 17
[drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
Console: switching to colour frame buffer device 240x67
i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
i915 0000:00:02.0: registered panic notifier
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
acpi device:01: registered as cooling_device5
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input11
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
snd_hda_intel 0000:00:1b.0: irq 63 for MSI/MSI-X
ALSA hda_i915.c:58 HDA driver get symbol successfully from i915 module
snd_hda_intel 0000:00:03.0: irq 64 for MSI/MSI-X
ALSA patch_realtek.c:419 SKU: Nid=0x1d sku_cfg=0x40738105
ALSA patch_realtek.c:421 SKU: port_connectivity=0x1
ALSA patch_realtek.c:422 SKU: enable_pcbeep=0x1
ALSA patch_realtek.c:423 SKU: check_sum=0x00000003
ALSA patch_realtek.c:424 SKU: customization=0x00000081
ALSA patch_realtek.c:425 SKU: external_amp=0x0
ALSA patch_realtek.c:426 SKU: platform_type=0x1
ALSA patch_realtek.c:427 SKU: swap=0x0
ALSA patch_realtek.c:428 SKU: override=0x1
ALSA hda_auto_parser.c:393 autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
ALSA hda_auto_parser.c:397    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA hda_auto_parser.c:401    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
ALSA hda_auto_parser.c:402    mono: mono_out=0x0
ALSA hda_auto_parser.c:406    inputs:
ALSA hda_auto_parser.c:410      Mic=0x1a
ALSA hda_auto_parser.c:410      Internal Mic=0x12
ALSA patch_realtek.c:491 realtek: No valid SSID, checking pincfg 0x40738105 for NID 0x1d
ALSA patch_realtek.c:507 realtek: Enabling init ASM_ID=0x8105 CODEC_ID=10ec0292
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input12
ip6_tables: (C) 2000-2006 Netfilter Core Team
input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input15
input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input14
input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input13
input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input17
input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input16
type=1006 audit(1397124129.478:2): pid=801 uid=0 old auid=4294967295 new auid=25121 old ses=4294967295 new ses=1 res=1
[   14.437387] wl0: authenticate with c0:25:06:65:72:9f
[   14.439945] wl0: send auth to c0:25:06:65:72:9f (try 1/3)
[   14.443322] wl0: authenticated
[   14.444295] wl0: associate with c0:25:06:65:72:9f (try 1/3)
[   14.448426] wl0: RX AssocResp from c0:25:06:65:72:9f (capab=0x431 status=0 aid=3)
[   14.450901] wl0: associated
[   14.450935] IPv6: ADDRCONF(NETDEV_CHANGE): wl0: link becomes ready
[  283.206345] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[  283.206350] iwlwifi 0000:03:00.0: CSR values:
[  283.206352] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  283.206439] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[  283.206494] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X8000ff40
[  283.206546] iwlwifi 0000:03:00.0:                     CSR_INT: 0X00000000
[  283.206620] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[  283.206769] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  283.206824] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[  283.206879] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[  283.206934] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[  283.206989] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X00000144
[  283.207044] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0X00000000
[  283.207107] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X80000000
[  283.207253] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X803a0000
[  283.207308] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080042
[  283.207363] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  283.207418] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  283.207473] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  283.207528] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  283.207590] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000060
[  283.207737] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X880d9e71
[  283.207791] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  283.207847] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[  283.207902] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  283.207957] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[  283.207959] iwlwifi 0000:03:00.0: FH register values:
[  283.208023] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0d65aa00
[  283.208036] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00d65ab0
[  283.208049] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000e0
[  283.208061] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  283.208074] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  283.208087] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03230000
[  283.208402] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  283.208414] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  283.208426] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  283.208532] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[  283.208534] iwlwifi 0000:03:00.0: Status: 0x00000000, count: 6
[  283.208536] iwlwifi 0000:03:00.0: 0x0000003C | NMI_INTERRUPT_DATA_ACTION_PT
[  283.208538] iwlwifi 0000:03:00.0: 0x000002B0 | uPc
[  283.208539] iwlwifi 0000:03:00.0: 0x00000000 | branchlink1
[  283.208541] iwlwifi 0000:03:00.0: 0x00000C8A | branchlink2
[  283.208543] iwlwifi 0000:03:00.0: 0x00014078 | interruptlink1
[  283.208544] iwlwifi 0000:03:00.0: 0x00000676 | interruptlink2
[  283.208546] iwlwifi 0000:03:00.0: 0x00000D40 | data1
[  283.208548] iwlwifi 0000:03:00.0: 0x00000008 | data2
[  283.208549] iwlwifi 0000:03:00.0: 0x03230000 | data3
[  283.208551] iwlwifi 0000:03:00.0: 0x93017CF2 | beacon time
[  283.208552] iwlwifi 0000:03:00.0: 0x0FEFB2DF | tsf low
[  283.208554] iwlwifi 0000:03:00.0: 0x00000001 | tsf hi
[  283.208556] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[  283.208557] iwlwifi 0000:03:00.0: 0x107D26D8 | time gp2
[  283.208559] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[  283.208561] iwlwifi 0000:03:00.0: 0x00321600 | uCode version
[  283.208562] iwlwifi 0000:03:00.0: 0x00000144 | hw version
[  283.208564] iwlwifi 0000:03:00.0: 0x00489204 | board version
[  283.208566] iwlwifi 0000:03:00.0: 0x1080001C | hcmd
[  283.208567] iwlwifi 0000:03:00.0: 0xA6F62000 | isr0
[  283.208569] iwlwifi 0000:03:00.0: 0x01004000 | isr1
[  283.208571] iwlwifi 0000:03:00.0: 0x0000000A | isr2
[  283.208572] iwlwifi 0000:03:00.0: 0x40400085 | isr3
[  283.208574] iwlwifi 0000:03:00.0: 0x00000001 | isr4
[  283.208575] iwlwifi 0000:03:00.0: 0x10800112 | isr_pref
[  283.208577] iwlwifi 0000:03:00.0: 0x00000D40 | wait_event
[  283.208578] iwlwifi 0000:03:00.0: 0x000000D0 | l2p_control
[  283.208580] iwlwifi 0000:03:00.0: 0x00010020 | l2p_duration
[  283.208596] iwlwifi 0000:03:00.0: 0x0000003F | l2p_mhvalid
[  283.208598] iwlwifi 0000:03:00.0: 0x000000CE | l2p_addr_match
[  283.208600] iwlwifi 0000:03:00.0: 0x00000007 | lmpm_pmg_sel
[  283.208606] iwlwifi 0000:03:00.0: 0xF35045B3 | timestamp
[  283.208611] iwlwifi 0000:03:00.0: 0x0034E0E8 | flow_handler
[  283.208617] ieee80211 phy0: Hardware restart was requested
[  283.209675] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  283.210277] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  283.615488] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[  283.615491] iwlwifi 0000:03:00.0: CSR values:
[  283.615492] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  283.615544] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[  283.615688] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X8000ff40
[  283.615740] iwlwifi 0000:03:00.0:                     CSR_INT: 0X00000000
[  283.615791] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[  283.615843] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  283.615894] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[  283.615945] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[  283.615997] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[  283.616048] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X00000144
[  283.616099] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0X00000000
[  283.616150] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X80000000
[  283.616201] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X803a0000
[  283.616252] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080042
[  283.616303] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  283.616354] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  283.616405] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  283.616475] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  283.616627] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000060
[  283.616776] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X880d9e71
[  283.616828] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  283.616879] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[  283.616931] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  283.616982] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[  283.616984] iwlwifi 0000:03:00.0: FH register values:
[  283.617047] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0d65aa00
[  283.617059] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00d65ab0
[  283.617071] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000038
[  283.617083] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  283.617094] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  283.617106] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03230000
[  283.617118] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  283.617131] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  283.617143] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  283.617247] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[  283.617249] iwlwifi 0000:03:00.0: Status: 0x00000000, count: 6
[  283.617253] iwlwifi 0000:03:00.0: 0x0000003C | NMI_INTERRUPT_DATA_ACTION_PT
[  283.617255] iwlwifi 0000:03:00.0: 0x00000230 | uPc
[  283.617256] iwlwifi 0000:03:00.0: 0x00000000 | branchlink1
[  283.617258] iwlwifi 0000:03:00.0: 0x00000C8A | branchlink2
[  283.617260] iwlwifi 0000:03:00.0: 0x00014078 | interruptlink1
[  283.617262] iwlwifi 0000:03:00.0: 0x00000676 | interruptlink2
[  283.617264] iwlwifi 0000:03:00.0: 0x00000D40 | data1
[  283.617266] iwlwifi 0000:03:00.0: 0x00000008 | data2
[  283.617267] iwlwifi 0000:03:00.0: 0x03230000 | data3
[  283.617269] iwlwifi 0000:03:00.0: 0x01017DE4 | beacon time
[  283.617271] iwlwifi 0000:03:00.0: 0x0FF5F21C | tsf low
[  283.617273] iwlwifi 0000:03:00.0: 0x00000001 | tsf hi
[  283.617274] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[  283.617276] iwlwifi 0000:03:00.0: 0x000616CD | time gp2
[  283.617278] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[  283.617280] iwlwifi 0000:03:00.0: 0x00321600 | uCode version
[  283.617282] iwlwifi 0000:03:00.0: 0x00000144 | hw version
[  283.617283] iwlwifi 0000:03:00.0: 0x00489204 | board version
[  283.617285] iwlwifi 0000:03:00.0: 0x0255001C | hcmd
[  283.617287] iwlwifi 0000:03:00.0: 0xA6F62000 | isr0
[  283.617289] iwlwifi 0000:03:00.0: 0x01004000 | isr1
[  283.617290] iwlwifi 0000:03:00.0: 0x00000002 | isr2
[  283.617292] iwlwifi 0000:03:00.0: 0x4041FC85 | isr3
[  283.617294] iwlwifi 0000:03:00.0: 0x00000001 | isr4
[  283.617296] iwlwifi 0000:03:00.0: 0x10800112 | isr_pref
[  283.617297] iwlwifi 0000:03:00.0: 0x00000D40 | wait_event
[  283.617299] iwlwifi 0000:03:00.0: 0x000000D0 | l2p_control
[  283.617301] iwlwifi 0000:03:00.0: 0x00010030 | l2p_duration
[  283.617303] iwlwifi 0000:03:00.0: 0x0000003F | l2p_mhvalid
[  283.617305] iwlwifi 0000:03:00.0: 0x000000CE | l2p_addr_match
[  283.617306] iwlwifi 0000:03:00.0: 0x00000007 | lmpm_pmg_sel
[  283.617308] iwlwifi 0000:03:00.0: 0x0079D83F | timestamp
[  283.617310] iwlwifi 0000:03:00.0: 0x00343848 | flow_handler
[  283.617314] ieee80211 phy0: Hardware restart was requested
[  283.618370] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  283.618875] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S

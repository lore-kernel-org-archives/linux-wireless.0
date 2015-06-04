Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.203]:47387 "EHLO
	johanna4.rokki.sonera.fi" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752791AbbFDRh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 13:37:27 -0400
Date: Thu, 4 Jun 2015 20:37:10 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG 4.1.0-rc6] iwlwifi: "Error sending REPLY_TXFIFO_FLUSH: time out
 after 2000ms"
Message-ID: <20150604173710.GA1188@node.dhcp.inet.fi> (sfid-20150604_193752_886297_C8CBF611)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've trigered the bug few times after several suspend/resume cycles.
Hardware is Thinkpad X1 2013 with Intel Corporation Centrino Advanced-N
6205 (8086:0085) (rev 96).

Full dmesg:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.1.0-rc6-00049-g8a7deb362b76 (kas@kshutemo-mobl1) (gcc version 4.9.2 (Gentoo 4.9.2 p1.5, pie-0.6.2) ) #57 SMP PREEMPT Thu Jun 4 19:09:13 EEST 2015
[    0.000000] Command line: BOOT_IMAGE=../vmlinuz crypt_root=UUID=ea23e6a0-21c8-4340-8f9e-60b285990429 root=/dev/mapper/x1-gentoo dolvm rw rootfstype=ext4 initrd=../initramfs
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c000-0x000000000009cfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x00000000000bffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000cfdc8fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfdc9000-0x00000000cffcafff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cffcb000-0x00000000d694efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d694f000-0x00000000dae9efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f80f8000-0x00000000f80f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011e5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0xce696018-0xce6a1857] usable ==> usable
[    0.000000] e820: update [mem 0xce685018-0xce695057] usable ==> usable
[    0.000000] e820: update [mem 0xce67a018-0xce684857] usable ==> usable
[    0.000000] e820: update [mem 0xce66f018-0xce679857] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000009bfff] usable
[    0.000000] reserve setup_data: [mem 0x000000000009c000-0x000000000009cfff] reserved
[    0.000000] reserve setup_data: [mem 0x000000000009d000-0x000000000009dfff] usable
[    0.000000] reserve setup_data: [mem 0x000000000009e000-0x00000000000bffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] reserve setup_data: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000040005000-0x00000000ce66f017] usable
[    0.000000] reserve setup_data: [mem 0x00000000ce66f018-0x00000000ce679857] usable
[    0.000000] reserve setup_data: [mem 0x00000000ce679858-0x00000000ce67a017] usable
[    0.000000] reserve setup_data: [mem 0x00000000ce67a018-0x00000000ce684857] usable
[    0.000000] reserve setup_data: [mem 0x00000000ce684858-0x00000000ce685017] usable
[    0.000000] reserve setup_data: [mem 0x00000000ce685018-0x00000000ce695057] usable
[    0.000000] reserve setup_data: [mem 0x00000000ce695058-0x00000000ce696017] usable
[    0.000000] reserve setup_data: [mem 0x00000000ce696018-0x00000000ce6a1857] usable
[    0.000000] reserve setup_data: [mem 0x00000000ce6a1858-0x00000000cfdc8fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000cfdc9000-0x00000000cffcafff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000cffcb000-0x00000000d694efff] usable
[    0.000000] reserve setup_data: [mem 0x00000000d694f000-0x00000000dae9efff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] reserve setup_data: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000db000000-0x00000000df9fffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000f80f8000-0x00000000f80f8fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000011e5fffff] usable
[    0.000000] efi: EFI v2.31 by Lenovo
[    0.000000] efi:  ACPI 2.0=0xdaffe014  ACPI=0xdaffe000  SMBIOS=0xdae9e000 
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: LENOVO 3460CC6/3460CC6, BIOS G6ETB0WW (2.70 ) 02/05/2015
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x11e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask FE0000000 write-back
[    0.000000]   7 base 11F000000 mask FFF000000 uncachable
[    0.000000]   8 base 11E800000 mask FFF800000 uncachable
[    0.000000]   9 base 11E600000 mask FFFE00000 uncachable
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC  
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03330000, 0x03330fff] PGTABLE
[    0.000000] BRK [0x03331000, 0x03331fff] PGTABLE
[    0.000000] BRK [0x03332000, 0x03332fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11e400000-0x11e5fffff]
[    0.000000]  [mem 0x11e400000-0x11e5fffff] page 2M
[    0.000000] BRK [0x03333000, 0x03333fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11e3fffff]
[    0.000000]  [mem 0x100000000-0x11e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0xc0000000-0xcfdc8fff]
[    0.000000]  [mem 0xc0000000-0xcfbfffff] page 2M
[    0.000000]  [mem 0xcfc00000-0xcfdc8fff] page 4k
[    0.000000] BRK [0x03334000, 0x03334fff] PGTABLE
[    0.000000] BRK [0x03335000, 0x03335fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xcffcb000-0xd694efff]
[    0.000000]  [mem 0xcffcb000-0xcfffffff] page 4k
[    0.000000]  [mem 0xd0000000-0xd67fffff] page 2M
[    0.000000]  [mem 0xd6800000-0xd694efff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdafff000-0xdaffffff]
[    0.000000]  [mem 0xdafff000-0xdaffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x40005000-0xbfffffff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0xbfffffff] page 2M
[    0.000000] RAMDISK: [mem 0x7fda4000-0x7fffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000DAFFE014 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000DAFFE170 0000D4 (v01 LENOVO TP-G6    00002700 PTL  00000002)
[    0.000000] ACPI: FACP 0x00000000DAFE6000 00010C (v05 LENOVO TP-G6    00002700 PTL  00000002)
[    0.000000] ACPI: DSDT 0x00000000DAFE8000 010174 (v01 LENOVO TP-G6    00002700 INTL 20061109)
[    0.000000] ACPI: FACS 0x00000000DAF5A000 000040
[    0.000000] ACPI: SLIC 0x00000000DAFFD000 000176 (v01 LENOVO TP-G6    00002700 PTL  00000001)
[    0.000000] ACPI: TCPA 0x00000000DAFFC000 000032 (v02 PTL    LENOVO   06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 0x00000000DAFFB000 000408 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000DAFFA000 000033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000DAFF9000 000797 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 0x00000000DAFE4000 000038 (v01 LENOVO TP-G6    00002700 PTL  00000002)
[    0.000000] ACPI: APIC 0x00000000DAFE3000 000098 (v01 LENOVO TP-G6    00002700 PTL  00000002)
[    0.000000] ACPI: MCFG 0x00000000DAFE2000 00003C (v01 LENOVO TP-G6    00002700 PTL  00000002)
[    0.000000] ACPI: ECDT 0x00000000DAFE1000 000052 (v01 LENOVO TP-G6    00002700 PTL  00000002)
[    0.000000] ACPI: FPDT 0x00000000DAFE0000 000064 (v01 LENOVO TP-G6    00002700 PTL  00000002)
[    0.000000] ACPI: ASF! 0x00000000DAFE7000 0000A5 (v32 LENOVO TP-G6    00002700 PTL  00000002)
[    0.000000] ACPI: UEFI 0x00000000DAFDF000 00003E (v01 LENOVO TP-G6    00002700 PTL  00000002)
[    0.000000] ACPI: UEFI 0x00000000DAFDE000 000042 (v01 PTL    COMBUF   00000001 PTL  00000001)
[    0.000000] ACPI: MSDM 0x00000000DAFDD000 000055 (v03 LENOVO TP-G6    00002700 PTL  00000002)
[    0.000000] ACPI: SSDT 0x00000000DAFDC000 000C9E (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000DAFDB000 000A83 (v01 PmRef  CpuPm    00003000 INTL 20061109)
[    0.000000] ACPI: DMAR 0x00000000DAFDA000 0000B8 (v01 INTEL  SNB      00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 0x00000000DAFD9000 0002A6 (v01 LENOVO TP-G6    00002700 PTL  00000002)
[    0.000000] ACPI: SSDT 0x00000000DAFD8000 000379 (v01 LENOVO AoacTabl 00001000 INTL 20061109)
[    0.000000] ACPI: DBG2 0x00000000DAFD7000 0000B4 (v00 LENOVO TP-G6    00002700 PTL  00000002)
[    0.000000] ACPI: BGRT 0x00000000DAFD6000 000038 (v00 LENOVO TP-G6    00002700 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011e5fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x11e5f5000-0x11e5f9fff]
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff880119c00000-ffff88011dbfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000011e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009bfff]
[    0.000000]   node   0: [mem 0x000000000009d000-0x000000000009dfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001fffffff]
[    0.000000]   node   0: [mem 0x0000000020200000-0x0000000040003fff]
[    0.000000]   node   0: [mem 0x0000000040005000-0x00000000cfdc8fff]
[    0.000000]   node   0: [mem 0x00000000cffcb000-0x00000000d694efff]
[    0.000000]   node   0: [mem 0x00000000dafff000-0x00000000daffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000011e5fffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000011e5fffff]
[    0.000000] On node 0 totalpages: 1002217
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13654 pages used for memmap
[    0.000000]   DMA32 zone: 873805 pages, LIFO batch:31
[    0.000000]   Normal zone: 1944 pages used for memmap
[    0.000000]   Normal zone: 124416 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xdba00000-0xdf9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x000bffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000c0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0xce66f000-0xce66ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xce679000-0xce679fff]
[    0.000000] PM: Registered nosave memory: [mem 0xce67a000-0xce67afff]
[    0.000000] PM: Registered nosave memory: [mem 0xce684000-0xce684fff]
[    0.000000] PM: Registered nosave memory: [mem 0xce685000-0xce685fff]
[    0.000000] PM: Registered nosave memory: [mem 0xce695000-0xce695fff]
[    0.000000] PM: Registered nosave memory: [mem 0xce696000-0xce696fff]
[    0.000000] PM: Registered nosave memory: [mem 0xce6a1000-0xce6a1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfdc9000-0xcffcafff]
[    0.000000] PM: Registered nosave memory: [mem 0xd694f000-0xdae9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdae9f000-0xdaf9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdaf9f000-0xdaffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb000000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf80f7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xf80f8000-0xf80f8fff]
[    0.000000] PM: Registered nosave memory: [mem 0xf80f9000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xf80f7fff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370452778343963 ns
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 35 pages/cpu @ffff88011e200000 s104392 r8192 d30776 u262144
[    0.000000] pcpu-alloc: s104392 r8192 d30776 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 986532
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=../vmlinuz crypt_root=UUID=ea23e6a0-21c8-4340-8f9e-60b285990429 root=/dev/mapper/x1-gentoo dolvm rw rootfstype=ext4 initrd=../initramfs
[    0.000000] log_buf_len individual max cpu contribution: 131072 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 917504 bytes
[    0.000000] log_buf_len min size: 524288 bytes
[    0.000000] log_buf_len: 2097152 bytes
[    0.000000] early log buf free: 508020(96%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3763400K/4008868K available (11863K kernel code, 1671K rwdata, 4804K rodata, 1620K init, 14264K bss, 245468K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Running RCU self tests
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:8448 nr_irqs:488 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] clocksource hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2294.637 MHz processor
[    0.000102] Calibrating delay loop (skipped), value calculated using timer frequency.. 4591.49 BogoMIPS (lpj=7648790)
[    0.000120] pid_max: default: 32768 minimum: 301
[    0.000144] ACPI: Core revision 20150410
[    0.039454] ACPI: All ACPI Tables successfully acquired
[    0.073006] Security Framework initialized
[    0.073025] AppArmor: AppArmor disabled by boot time parameter
[    0.073034] Yama: becoming mindful.
[    0.074650] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.076744] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.077432] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.077463] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.078783] Initializing cgroup subsys blkio
[    0.078798] Initializing cgroup subsys devices
[    0.078838] Initializing cgroup subsys freezer
[    0.078902] Initializing cgroup subsys net_cls
[    0.078976] CPU: Physical Processor ID: 0
[    0.078983] CPU: Processor Core ID: 0
[    0.078995] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.079003] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.079536] mce: CPU supports 7 MCE banks
[    0.079556] CPU0: Thermal monitoring enabled (TM1)
[    0.079581] process: using mwait in idle threads
[    0.079592] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.079600] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.079913] Freeing SMP alternatives memory: 32K (ffffffff82538000 - ffffffff82540000)
[    0.083093] Ignoring BGRT: invalid version 0 (expected 1)
[    0.093697] ftrace: allocating 37024 entries in 145 pages
[    0.117990] dmar: Host address width 36
[    0.118002] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.118055] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.118067] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.118087] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.118099] dmar: RMRR base: 0x000000da3ba000 end: 0x000000da3d0fff
[    0.118108] dmar: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.118117] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.118125] HPET id 0 under DRHD base 0xfed91000
[    0.118413] Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.118445] Enabled IRQ remapping in x2apic mode
[    0.118453] x2apic enabled
[    0.118468] Switched APIC routing to cluster x2apic.
[    0.119291] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.152295] TSC deadline timer enabled
[    0.152304] smpboot: CPU0: Intel(R) Core(TM) i5-3427U CPU @ 1.80GHz (fam: 06, model: 3a, stepping: 09)
[    0.152366] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.152416] ... version:                3
[    0.152422] ... bit width:              48
[    0.152429] ... generic registers:      4
[    0.152435] ... value mask:             0000ffffffffffff
[    0.152442] ... max period:             0000ffffffffffff
[    0.152449] ... fixed-purpose events:   3
[    0.152455] ... event mask:             000000070000000f
[    0.172855] x86: Booting SMP configuration:
[    0.172865] .... node  #0, CPUs:      #1
[    0.187111] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.193655]  #2 #3
[    0.228062] x86: Booted up 1 node, 4 CPUs
[    0.228076] smpboot: Total of 4 processors activated (18364.97 BogoMIPS)
[    0.233740] devtmpfs: initialized
[    0.240071] PM: Registering ACPI NVS region [mem 0xdae9f000-0xdaf9efff] (1048576 bytes)
[    0.240496] clocksource jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370867519511994 ns
[    0.240842] RTC time: 17:13:47, date: 06/04/15
[    0.241369] NET: Registered protocol family 16
[    0.255864] cpuidle: using governor ladder
[    0.269198] cpuidle: using governor menu
[    0.269458] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.269489] ACPI: bus type PCI registered
[    0.269497] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.269918] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.269933] PCI: not using MMCONFIG
[    0.269940] PCI: Using configuration type 1 for base access
[    0.270743] perf_event_intel: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
[    0.297166] ACPI: Added _OSI(Module Device)
[    0.297176] ACPI: Added _OSI(Processor Device)
[    0.297184] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.297192] ACPI: Added _OSI(Processor Aggregator Device)
[    0.307073] ACPI : EC: EC description table is found, configuring boot EC
[    0.307118] ACPI : EC: EC started
[    0.328856] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.336422] ACPI: Dynamic OEM Table Load:
[    0.336472] ACPI: SSDT 0xFFFF880118F38000 000A01 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.339669] ACPI: Dynamic OEM Table Load:
[    0.339714] ACPI: SSDT 0xFFFF880118988C00 000303 (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.342715] ACPI: Dynamic OEM Table Load:
[    0.342758] ACPI: SSDT 0xFFFF880118F60000 000119 (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.347312] ACPI: Interpreter enabled
[    0.347328] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20150410/hwxface-580)
[    0.347347] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20150410/hwxface-580)
[    0.347416] ACPI: (supports S0 S3 S4 S5)
[    0.347424] ACPI: Using IOAPIC for interrupt routing
[    0.347471] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.348797] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    0.349016] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.360410] ACPI: Power Resource [PUBS] (on)
[    0.362047] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
[    0.366333] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
[    0.376906] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.377143] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.377372] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.377602] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.377830] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.378058] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.378287] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.378515] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.379149] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.379165] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.379711] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
[    0.379928] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.379943] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.379955] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    0.379966] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.380904] PCI host bridge to bus 0000:00
[    0.380915] pci_bus 0000:00: root bus resource [bus 00-3f]
[    0.380925] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.380934] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.380943] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.380955] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff window]
[    0.380967] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff window]
[    0.380979] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff window]
[    0.380991] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
[    0.381003] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
[    0.381014] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
[    0.381026] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
[    0.381038] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
[    0.381050] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff window]
[    0.381062] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff window]
[    0.381073] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff window]
[    0.381085] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff window]
[    0.381097] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff window]
[    0.381109] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff window]
[    0.381150] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    0.381606] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    0.381630] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.381644] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.381653] pci 0000:00:02.0: reg 0x20: [io  0x4000-0x403f]
[    0.382120] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.382166] pci 0000:00:14.0: reg 0x10: [mem 0xf1500000-0xf150ffff 64bit]
[    0.382324] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.382559] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.382768] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.382817] pci 0000:00:16.0: reg 0x10: [mem 0xf1515000-0xf151500f 64bit]
[    0.382972] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.383278] pci 0000:00:16.3: [8086:1e3d] type 00 class 0x070002
[    0.383313] pci 0000:00:16.3: reg 0x10: [io  0x4090-0x4097]
[    0.383332] pci 0000:00:16.3: reg 0x14: [mem 0xf151b000-0xf151bfff]
[    0.383759] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.383796] pci 0000:00:1a.0: reg 0x10: [mem 0xf151a000-0xf151a3ff]
[    0.383972] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.384119] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.384321] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.384363] pci 0000:00:1b.0: reg 0x10: [mem 0xf1510000-0xf1513fff 64bit]
[    0.384545] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.384713] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.384915] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.385090] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.385423] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
[    0.385594] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.385747] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.385956] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.386005] pci 0000:00:1d.0: reg 0x10: [mem 0xf1519000-0xf15193ff]
[    0.386188] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.386337] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.386532] pci 0000:00:1f.0: [8086:1e56] type 00 class 0x060100
[    0.386992] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    0.387032] pci 0000:00:1f.2: reg 0x10: [io  0x4088-0x408f]
[    0.387051] pci 0000:00:1f.2: reg 0x14: [io  0x409c-0x409f]
[    0.387070] pci 0000:00:1f.2: reg 0x18: [io  0x4080-0x4087]
[    0.387089] pci 0000:00:1f.2: reg 0x1c: [io  0x4098-0x409b]
[    0.387108] pci 0000:00:1f.2: reg 0x20: [io  0x4060-0x407f]
[    0.387127] pci 0000:00:1f.2: reg 0x24: [mem 0xf1518000-0xf15187ff]
[    0.387231] pci 0000:00:1f.2: PME# supported from D3hot
[    0.387545] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.387581] pci 0000:00:1f.3: reg 0x10: [mem 0xf1514000-0xf15140ff 64bit]
[    0.387633] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    0.388322] pci 0000:02:00.0: [1180:e823] type 00 class 0x088001
[    0.388352] pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[    0.388435] pci 0000:02:00.0: reg 0x10: [mem 0xf0d00000-0xf0d000ff]
[    0.388726] pci 0000:02:00.0: supports D1 D2
[    0.388728] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.399726] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.399741] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.399749] pci 0000:00:1c.0:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.399761] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.400185] pci 0000:03:00.0: [8086:0085] type 00 class 0x028000
[    0.400593] pci 0000:03:00.0: reg 0x10: [mem 0xf0c00000-0xf0c01fff 64bit]
[    0.402321] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.409678] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.409701] pci 0000:00:1c.1:   bridge window [mem 0xf0c00000-0xf0cfffff]
[    0.412569] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.412888] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.413757] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=mem,locks=none
[    0.413779] vgaarb: loaded
[    0.413785] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.413793] vgaarb: bridge control possible 0000:00:02.0
[    0.414032] SCSI subsystem initialized
[    0.414220] libata version 3.00 loaded.
[    0.414240] ACPI: bus type USB registered
[    0.414319] usbcore: registered new interface driver usbfs
[    0.414366] usbcore: registered new interface driver hub
[    0.414466] usbcore: registered new device driver usb
[    0.414545] media: Linux media interface: v0.10
[    0.414584] Linux video capture interface: v2.00
[    0.416261] wmi: Mapper loaded
[    0.416408] Advanced Linux Sound Architecture Driver Initialized.
[    0.416487] PCI: Using ACPI for IRQ routing
[    0.420440] PCI: pci_cache_line_size set to 64 bytes
[    0.420873] e820: reserve RAM buffer [mem 0x0009c000-0x0009ffff]
[    0.420884] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    0.420887] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.420889] e820: reserve RAM buffer [mem 0xce66f018-0xcfffffff]
[    0.420893] e820: reserve RAM buffer [mem 0xce67a018-0xcfffffff]
[    0.420896] e820: reserve RAM buffer [mem 0xce685018-0xcfffffff]
[    0.420899] e820: reserve RAM buffer [mem 0xce696018-0xcfffffff]
[    0.420902] e820: reserve RAM buffer [mem 0xcfdc9000-0xcfffffff]
[    0.420905] e820: reserve RAM buffer [mem 0xd694f000-0xd7ffffff]
[    0.420908] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.420910] e820: reserve RAM buffer [mem 0x11e600000-0x11fffffff]
[    0.421755] Bluetooth: Core ver 2.20
[    0.421783] NET: Registered protocol family 31
[    0.421790] Bluetooth: HCI device and connection manager initialized
[    0.421822] Bluetooth: HCI socket layer initialized
[    0.421833] Bluetooth: L2CAP socket layer initialized
[    0.421882] Bluetooth: SCO socket layer initialized
[    0.422387] cfg80211: Calling CRDA to update world regulatory domain
[    0.422556] NetLabel: Initializing
[    0.422564] NetLabel:  domain hash size = 128
[    0.422570] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.422636] NetLabel:  unlabeled traffic allowed by default
[    0.422923] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.422940] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.425047] Switched to clocksource hpet
[    0.485294] pnp: PnP ACPI init
[    0.486413] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.486427] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.486438] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    0.486449] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.486460] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.486510] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.486776] pnp 00:01: [Firmware Bug]: PNP resource [mem 0xfed10000-0xfed13fff] covers only part of 0000:00:00.0 Intel MCH; extending to [mem 0xfed10000-0xfed17fff]
[    0.486888] system 00:01: [io  0x0400-0x047f] could not be reserved
[    0.486898] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.486908] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.486918] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.486927] system 00:01: [io  0x1600-0x167f] has been reserved
[    0.486939] system 00:01: [mem 0xf8000000-0xfbffffff] could not be reserved
[    0.486949] system 00:01: [mem 0xfffff000-0xffffffff] has been reserved
[    0.486959] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.486969] system 00:01: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.486979] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.486989] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.486999] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.487014] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.487212] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.487328] pnp 00:03: Plug and Play ACPI device, IDs LEN0071 PNP0303 (active)
[    0.487440] pnp 00:04: Plug and Play ACPI device, IDs LEN0030 PNP0f13 (active)
[    0.487600] pnp 00:05: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.488802] pnp: PnP ACPI: found 6 devices
[    0.503114] clocksource acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.503184] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.503196] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.503217] pci 0000:00:1c.0:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.503234] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.503258] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.503277] pci 0000:00:1c.1:   bridge window [mem 0xf0c00000-0xf0cfffff]
[    0.503304] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.503307] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.503310] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.503312] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff window]
[    0.503315] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff window]
[    0.503317] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff window]
[    0.503320] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff window]
[    0.503322] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff window]
[    0.503324] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff window]
[    0.503327] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff window]
[    0.503329] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff window]
[    0.503331] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff window]
[    0.503334] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff window]
[    0.503336] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff window]
[    0.503339] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff window]
[    0.503341] pci_bus 0000:00: resource 19 [mem 0xdfa00000-0xfebfffff window]
[    0.503344] pci_bus 0000:00: resource 20 [mem 0xfed40000-0xfed4bfff window]
[    0.503346] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.503349] pci_bus 0000:02: resource 1 [mem 0xf0d00000-0xf14fffff]
[    0.503351] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.503354] pci_bus 0000:03: resource 1 [mem 0xf0c00000-0xf0cfffff]
[    0.503483] NET: Registered protocol family 2
[    0.504330] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.505223] TCP bind hash table entries: 32768 (order: 9, 2097152 bytes)
[    0.507960] TCP: Hash tables configured (established 32768 bind 32768)
[    0.508169] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    0.508671] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    0.509282] NET: Registered protocol family 1
[    0.509322] pci 0000:00:02.0: Video device with shadowed ROM
[    0.511176] PCI: CLS 64 bytes, default 64
[    0.511563] Unpacking initramfs...
[    0.927936] Freeing initrd memory: 2416K (ffff88007fda4000 - ffff880080000000)
[    0.928042] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.928053] software IO TLB [mem 0xc999a000-0xcd99a000] (64MB) mapped at [ffff8800c999a000-ffff8800cd999fff]
[    0.929004] RAPL PMU detected, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.929018] hw unit of domain pp0-core 2^-16 Joules
[    0.929025] hw unit of domain package 2^-16 Joules
[    0.929032] hw unit of domain pp1-gpu 2^-16 Joules
[    0.929597] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x1b
[    0.929627] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x1b
[    0.929649] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x1b
[    0.929678] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x1b
[    0.929894] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.931283] Scanning for low memory corruption every 60 seconds
[    0.931673] AVX version of gcm_enc/dec engaged.
[    0.931687] AES CTR mode by8 optimization enabled
[    0.934717] futex hash table entries: 2048 (order: 6, 262144 bytes)
[    0.934993] audit: initializing netlink subsys (disabled)
[    0.935085] audit: type=2000 audit(1433438026.893:1): initialized
[    0.936921] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.947212] zpool: loaded
[    0.947221] zbud: loaded
[    0.948037] VFS: Disk quotas dquot_6.6.0
[    0.948241] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.951059] fuse init (API version 7.23)
[    0.953592] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    0.953793] io scheduler noop registered
[    0.953804] io scheduler deadline registered
[    0.953980] io scheduler cfq registered (default)
[    0.953990] start plist test
[    0.957632] end plist test
[    0.958647] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.958836] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.958899] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    0.959104] efifb: probing for efifb
[    0.959141] efifb: framebuffer at 0xe0000000, mapped to 0xffffc90001000000, using 5628k, total 5625k
[    0.959154] efifb: mode is 1600x900x32, linelength=6400, pages=1
[    0.959161] efifb: scrolling: redraw
[    0.959168] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.964697] Console: switching to colour frame buffer device 200x56
[    0.969213] fb0: EFI VGA frame buffer device
[    0.969270] intel_idle: MWAIT substates: 0x21120
[    0.969272] intel_idle: v0.4 model 0x3A
[    0.969274] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.971250] ACPI: AC Adapter [AC] (on-line)
[    0.972030] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.972298] ACPI: Lid Switch [LID]
[    0.972492] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.972594] ACPI: Sleep Button [SLPB]
[    0.972822] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.972870] ACPI: Power Button [PWRF]
[    0.976384] thermal LNXTHERM:00: registered as thermal_zone0
[    0.976425] ACPI: Thermal Zone [THM0] (37 C)
[    0.976598] GHES: HEST is not enabled!
[    0.976841] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.988588] ACPI: Battery Slot [BAT0] (battery present)
[    1.002142] 0000:00:16.3: ttyS0 at I/O 0x4090 (irq = 19, base_baud = 115200) is a 16550A
[    1.003072] Non-volatile memory driver v1.3
[    1.003294] Linux agpgart interface v0.103
[    1.021501] tpm_tis 00:05: 1.2 TPM (device-id 0x0, rev-id 78)
[    1.104547] [drm] Initialized drm 1.1.0 20060810
[    1.104930] i915 0000:00:02.0: enabling device (0006 -> 0007)
[    1.108657] [drm] Memory usable by graphics device = 2048M
[    1.108718] checking generic (e0000000 57f000) vs hw (e0000000 10000000)
[    1.108720] fb: switching to inteldrmfb from EFI VGA
[    1.108902] Console: switching to colour dummy device 80x25
[    1.110650] [drm] Replacing VGA console driver
[    1.120101] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.120115] [drm] Driver supports precise vblank timestamp query.
[    1.120871] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=mem
[    1.160294] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    1.161115] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.161384] [drm] Initialized i915 1.6.0 20150327 for 0000:00:02.0 on minor 0
[    1.176019] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042F conflicts with OpRegion 0x0000000000000400-0x000000000000047F (\_SB_.PCI0.LPC_.PMIO) (20150410/utaddress-254)
[    1.176051] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.176071] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054F conflicts with OpRegion 0x0000000000000500-0x000000000000057F (\_SB_.PCI0.LPC_.LPIO) (20150410/utaddress-254)
[    1.176094] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.176108] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053F conflicts with OpRegion 0x0000000000000500-0x000000000000057F (\_SB_.PCI0.LPC_.LPIO) (20150410/utaddress-254)
[    1.176131] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.176144] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052F conflicts with OpRegion 0x0000000000000500-0x000000000000057F (\_SB_.PCI0.LPC_.LPIO) (20150410/utaddress-254)
[    1.176166] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.176178] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    1.176371] ahci 0000:00:1f.2: version 3.0
[    1.176851] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1 impl SATA mode
[    1.176867] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    1.180783] scsi host0: ahci
[    1.181712] scsi host1: ahci
[    1.182215] scsi host2: ahci
[    1.182691] scsi host3: ahci
[    1.183168] scsi host4: ahci
[    1.183608] scsi host5: ahci
[    1.183838] ata1: SATA max UDMA/133 abar m2048@0xf1518000 port 0xf1518100 irq 28
[    1.183850] ata2: DUMMY
[    1.183855] ata3: DUMMY
[    1.183861] ata4: DUMMY
[    1.183866] ata5: DUMMY
[    1.183871] ata6: DUMMY
[    1.184132] tun: Universal TUN/TAP device driver, 1.6
[    1.184146] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.184893] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.185152] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    1.185418] xhci_hcd 0000:00:14.0: hcc params 0x20007181 hci version 0x100 quirks 0x0000b930
[    1.185452] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.187243] hub 1-0:1.0: USB hub found
[    1.187336] hub 1-0:1.0: 4 ports detected
[    1.190252] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.190274] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    1.191229] hub 2-0:1.0: USB hub found
[    1.191289] hub 2-0:1.0: 4 ports detected
[    1.193556] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.193582] ehci-pci: EHCI PCI platform driver
[    1.193913] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.193947] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.193983] ehci-pci 0000:00:1a.0: debug port 2
[    1.197938] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.198021] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf151a000
[    1.208022] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.208825] hub 3-0:1.0: USB hub found
[    1.208859] hub 3-0:1.0: 3 ports detected
[    1.209914] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.209941] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    1.209994] ehci-pci 0000:00:1d.0: debug port 2
[    1.213919] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.213958] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf1519000
[    1.221365] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[    1.221366] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.222176] hub 4-0:1.0: USB hub found
[    1.222211] hub 4-0:1.0: 3 ports detected
[    1.223011] ehci-platform: EHCI generic platform driver
[    1.223121] usbcore: registered new interface driver usb-storage
[    1.223563] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.225258] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.225751] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.226491] mousedev: PS/2 mouse device common for all mice
[    1.228462] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    1.228764] rtc_cmos 00:02: RTC can wake from S4
[    1.229393] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.229469] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.229881] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.230154] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[    1.230647] IR XMP protocol handler initialized
[    1.230717] usbcore: registered new interface driver uvcvideo
[    1.230725] USB Video Class driver (1.1.1)
[    1.231820] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    1.231882] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
[    1.232151] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.232193] iTCO_vendor_support: vendor-support=0
[    1.232401] device-mapper: uevent: version 1.0.3
[    1.232781] device-mapper: ioctl: 4.31.0-ioctl (2015-3-12) initialised: dm-devel@redhat.com
[    1.232848] usbcore: registered new interface driver btusb
[    1.232862] Intel P-state driver initializing.
[    1.233677] sdhci: Secure Digital Host Controller Interface driver
[    1.233696] sdhci: Copyright(c) Pierre Ossman
[    1.233824] sdhci-pci 0000:02:00.0: SDHCI controller found [1180:e823] (rev 4)
[    1.234549] sdhci-pci 0000:02:00.0: No vmmc regulator found
[    1.234577] sdhci-pci 0000:02:00.0: No vqmmc regulator found
[    1.237434] mmc0: SDHCI controller on PCI [0000:02:00.0] using DMA
[    1.237796] hidraw: raw HID events driver (C) Jiri Kosina
[    1.238427] usbcore: registered new interface driver usbhid
[    1.238445] usbhid: USB HID core driver
[    1.239549] thinkpad_acpi: ThinkPad ACPI Extras v0.25
[    1.239566] thinkpad_acpi: http://ibm-acpi.sf.net/
[    1.239581] thinkpad_acpi: ThinkPad BIOS G6ETB0WW (2.70 ), EC unknown
[    1.239598] thinkpad_acpi: Lenovo ThinkPad X1 Carbon, model 3460CC6
[    1.242551] thinkpad_acpi: Unsupported brightness interface, please contact ibm-acpi-devel@lists.sourceforge.net
[    1.242893] thinkpad_acpi: radio switch found; radios are enabled
[    1.242940] thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
[    1.243531] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    1.243557] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    1.251213] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    1.258955] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
[    1.261939] drop_monitor: Initializing network drop monitor service
[    1.262496] NET: Registered protocol family 10
[    1.263584] NET: Registered protocol family 17
[    1.263647] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[    1.264027] Bridge firewalling registered
[    1.264052] Ebtables v2.0 registered
[    1.264246] 8021q: 802.1Q VLAN Support v1.8
[    1.264378] Key type dns_resolver registered
[    1.265567] registered taskstats version 1
[    1.266568]   Magic number: 3:271:238
[    1.266689] rtc_cmos 00:02: setting system clock to 2015-06-04 17:13:48 UTC (1433438028)
[    1.266966] PM: Hibernation image not present or could not be loaded.
[    1.266970] ALSA device list:
[    1.266975]   No soundcards found.
[    1.273912] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC269VC: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[    1.273923] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    1.273931] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[    1.273939] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[    1.273944] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[    1.273951] snd_hda_codec_realtek hdaudioC0D0:      Mic=0x18
[    1.273957] snd_hda_codec_realtek hdaudioC0D0:      Internal Mic=0x12
[    1.287968] [drm] GMBUS [i915 gmbus dpb] timed out, falling back to bit banging on pin 5
[    1.290641] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    1.293672] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    1.293983] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[    1.294309] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[    1.302347] fbcon: inteldrmfb (fb0) is primary device
[    1.501354] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.512869] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.512874] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.514726] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    1.522848] ata1.00: ATA-9: INTEL SSDSCMMW240A3L, LE9i, max UDMA/133
[    1.522851] ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.528016] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    1.532901] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.532903] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.542962] ata1.00: configured for UDMA/133
[    1.548002] usb 1-2: new full-speed USB device number 2 using xhci_hcd
[    1.640583] hub 3-1:1.0: USB hub found
[    1.640921] hub 3-1:1.0: 6 ports detected
[    1.653258] hub 4-1:1.0: USB hub found
[    1.653407] hub 4-1:1.0: 8 ports detected
[    1.739206] logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:14.0-2/input2
[    1.855709] input: Logitech Performance MX as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.2/0003:046D:C52B.0003/0003:046D:101A.0004/input/input13
[    1.858357] logitech-hidpp-device 0003:046D:101A.0004: input,hidraw1: USB HID v1.11 Mouse [Logitech Performance MX] on usb-0000:00:14.0-2:1
[    1.914931] usb 3-1.3: new full-speed USB device number 3 using ehci-pci
[    1.931386] tsc: Refined TSC clocksource calibration: 2294.798 MHz
[    1.931393] clocksource tsc: mask: 0xffffffffffffffff max_cycles: 0x2114031c75d, max_idle_ns: 440795259495 ns
[    2.004414] usb 1-3: new full-speed USB device number 3 using xhci_hcd
[    2.026556] psmouse serio1: synaptics: queried max coordinates: x [..5678], y [..4732]
[    2.058826] psmouse serio1: synaptics: queried min coordinates: x [1264..], y [1124..]
[    2.067935] usb 3-1.4: new full-speed USB device number 4 using ehci-pci
[    2.096912] Console: switching to colour frame buffer device 200x56
[    2.106719] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    2.106772] i915 0000:00:02.0: registered panic notifier
[    2.121893] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x127c00, board id: 2182, fw id: 1164733
[    2.122090] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    2.164611] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[    2.170278] Bluetooth: hci0: BCM: chip id 63
[    2.172349] Bluetooth: hci0: BCM20702A1 (001.002.014) build 0000
[    2.176816] bluetooth hci0: Direct firmware load for brcm/BCM20702A1-0a5c-21e6.hcd failed with error -2
[    2.181404] Bluetooth: hci0: BCM: Patch brcm/BCM20702A1-0a5c-21e6.hcd not found
[    2.189681] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSCMMW24 LE9i PQ: 0 ANSI: 5
[    2.195215] sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/223 GiB)
[    2.197650] sd 0:0:0:0: [sda] Write Protect is off
[    2.199200] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.199243] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.205340]  sda: sda1 sda3
[    2.209252] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.211402] Freeing unused kernel memory: 1620K (ffffffff823a3000 - ffffffff82538000)
[    2.212662] Write protecting the kernel read-only data: 18432k
[    2.214982] Freeing unused kernel memory: 412K (ffff880001b99000 - ffff880001c00000)
[    2.216950] Freeing unused kernel memory: 1340K (ffff8800020b1000 - ffff880002200000)
[    2.231166] usb 3-1.6: new high-speed USB device number 5 using ehci-pci
[    2.454262] uvcvideo: Found UVC 1.00 device Integrated Camera (5986:0266)
[    2.464545] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.6/3-1.6:1.0/input/input15
[    2.569969] random: lvm urandom read with 28 bits of entropy available
[    2.931988] Switched to clocksource tsc
[    3.571113] cfg80211: Calling CRDA to update world regulatory domain
[    6.375847] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    6.580274] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input14
[    6.715397] cfg80211: Calling CRDA to update world regulatory domain
[    8.513060] random: nonblocking pool is initialized
[    9.860273] cfg80211: Calling CRDA to update world regulatory domain
[   10.390560] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: (null)
[   11.405981] udevd[1257]: starting version 1.10
[   11.591937] Intel(R) Wireless WiFi driver for Linux
[   11.591941] Copyright(c) 2003- 2015 Intel Corporation
[   11.592718] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[   11.604779] iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1 op_mode iwldvm
[   11.614379] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   11.614383] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   11.614385] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[   11.614388] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205S AGN, REV=0xB0
[   11.614617] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[   11.635453] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   12.388472] EXT4-fs (dm-4): re-mounted. Opts: data=ordered
[   12.486683] Adding 7864316k swap on /dev/mapper/x1-swap.  Priority:-1 extents:1 across:7864316k SSFS
[   12.538816] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: data=ordered
[   12.542288] FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[   13.005351] cfg80211: Calling CRDA to update world regulatory domain
[   13.025867] cfg80211: World regulatory domain updated:
[   13.025871] cfg80211:  DFS Master region: unset
[   13.025873] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[   13.025876] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   13.025877] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   13.025878] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[   13.025880] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[   13.025882] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[   13.025884] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[   13.025885] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[   13.025887] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[   13.403387] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[   13.409944] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   13.681487] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[   13.688077] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   13.778795] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   17.065550] wlan0: authenticate with e0:91:f5:05:17:fb
[   17.071855] wlan0: send auth to e0:91:f5:05:17:fb (try 1/3)
[   17.086085] wlan0: authenticated
[   17.090618] wlan0: associate with e0:91:f5:05:17:fb (try 1/3)
[   17.092080] wlan0: RX AssocResp from e0:91:f5:05:17:fb (capab=0x11 status=0 aid=1)
[   17.113115] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   17.113680] wlan0: associated
[   41.693896] PM: Syncing filesystems ... done.
[   41.712792] PM: Preparing system for mem sleep
[   41.716211] Freezing user space processes ... (elapsed 0.002 seconds) done.
[   41.719025] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[   41.720966] PM: Entering mem sleep
[   41.721099] Suspending console(s) (use no_console_suspend to debug)
[   41.723984] wlan0: deauthenticating from e0:91:f5:05:17:fb by local choice (Reason: 3=DEAUTH_LEAVING)
[   41.758866] cfg80211: Calling CRDA to update world regulatory domain
[   41.759160] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   41.760528] sd 0:0:0:0: [sda] Stopping disk
[   42.402401] PM: suspend of devices complete after 678.975 msecs
[   42.420700] PM: late suspend of devices complete after 18.292 msecs
[   42.426778] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[   42.428508] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[   42.428637] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[   42.440839] PM: noirq suspend of devices complete after 20.140 msecs
[   42.441218] ACPI: Preparing to enter system sleep state S3
[   42.740321] ACPI : EC: EC stopped
[   42.740323] PM: Saving platform NVS memory
[   42.740355] Disabling non-boot CPUs ...
[   42.740810] intel_pstate CPU 1 exiting
[   42.743264] kvm: disabling virtualization on CPU1
[   42.743620] smpboot: CPU 1 is now offline
[   42.747246] intel_pstate CPU 2 exiting
[   42.748556] kvm: disabling virtualization on CPU2
[   42.748569] smpboot: CPU 2 is now offline
[   42.749866] intel_pstate CPU 3 exiting
[   42.751120] kvm: disabling virtualization on CPU3
[   42.751167] smpboot: CPU 3 is now offline
[   42.753740] ACPI: Low-level resume complete
[   42.753819] ACPI : EC: EC started
[   42.753820] PM: Restoring platform NVS memory
[   42.754947] Enabling non-boot CPUs ...
[   42.755148] x86: Booting SMP configuration:
[   42.755150] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   42.767297] kvm: enabling virtualization on CPU1
[   42.875712]  cache: parent cpu1 should not be sleeping
[   42.876475] CPU1 is up
[   42.876571] smpboot: Booting Node 0 Processor 2 APIC 0x2
[   42.888140] kvm: enabling virtualization on CPU2
[   42.996252]  cache: parent cpu2 should not be sleeping
[   42.996940] CPU2 is up
[   42.997040] smpboot: Booting Node 0 Processor 3 APIC 0x3
[   43.008634] kvm: enabling virtualization on CPU3
[   43.115716]  cache: parent cpu3 should not be sleeping
[   43.116405] CPU3 is up
[   43.120383] ACPI: Waking up from system sleep state S3
[   43.692763] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[   43.692967] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[   43.693137] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[   43.707510] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[   43.708413] PM: noirq resume of devices complete after 16.634 msecs
[   43.712470] PM: early resume of devices complete after 3.943 msecs
[   43.716816] rtc_cmos 00:02: System wakeup disabled by ACPI
[   43.725633] sd 0:0:0:0: [sda] Starting disk
[   43.941831] usb 3-1.4: reset full-speed USB device number 4 using ehci-pci
[   44.031356] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   44.035469] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   44.035473] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   44.055455] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[   44.055459] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[   44.065453] ata1.00: configured for UDMA/133
[   44.078520] usb 1-3: reset full-speed USB device number 3 using xhci_hcd
[   44.091443] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[   44.254110] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[   44.260691] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   44.433756] psmouse serio1: synaptics: queried max coordinates: x [..5678], y [..4732]
[   44.465511] psmouse serio1: synaptics: queried min coordinates: x [1264..], y [1124..]
[   44.538828] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[   44.545454] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[   44.635568] PM: resume of devices complete after 923.556 msecs
[   44.646767] PM: Finishing wakeup.
[   44.646775] Restarting tasks ... 
[   44.648119] Bluetooth: hci0: BCM: chip id 63
[   44.651067] Bluetooth: hci0: BCM20702A1 (001.002.014) build 0000
[   44.658235] done.
[   44.660557] bluetooth hci0: Direct firmware load for brcm/BCM20702A1-0a5c-21e6.hcd failed with error -2
[   44.660569] Bluetooth: hci0: BCM: Patch brcm/BCM20702A1-0a5c-21e6.hcd not found
[   44.667345] cfg80211: World regulatory domain updated:
[   44.667349] cfg80211:  DFS Master region: unset
[   44.667349] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[   44.667353] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   44.667356] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   44.667358] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[   44.667362] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[   44.667365] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[   44.667368] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[   44.667370] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[   44.667373] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[   47.966608] wlan0: authenticate with e0:91:f5:05:17:fb
[   47.971243] wlan0: send auth to e0:91:f5:05:17:fb (try 1/3)
[   47.972353] wlan0: authenticated
[   47.976019] wlan0: associate with e0:91:f5:05:17:fb (try 1/3)
[   47.977344] wlan0: RX AssocResp from e0:91:f5:05:17:fb (capab=0x11 status=0 aid=1)
[   47.997804] wlan0: associated
[  313.398661] PM: Syncing filesystems ... done.
[  313.511378] PM: Preparing system for mem sleep
[  313.512454] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  313.514402] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  313.515899] PM: Entering mem sleep
[  313.515919] Suspending console(s) (use no_console_suspend to debug)
[  313.517168] wlan0: deauthenticating from e0:91:f5:05:17:fb by local choice (Reason: 3=DEAUTH_LEAVING)
[  313.546114] cfg80211: Calling CRDA to update world regulatory domain
[  313.546323] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  313.547351] sd 0:0:0:0: [sda] Stopping disk
[  314.159981] PM: suspend of devices complete after 643.260 msecs
[  314.177629] PM: late suspend of devices complete after 17.643 msecs
[  314.183962] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[  314.184414] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[  314.184636] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[  314.197653] PM: noirq suspend of devices complete after 20.025 msecs
[  314.198111] ACPI: Preparing to enter system sleep state S3
[  314.497300] ACPI : EC: EC stopped
[  314.497303] PM: Saving platform NVS memory
[  314.497315] Disabling non-boot CPUs ...
[  314.497513] intel_pstate CPU 1 exiting
[  314.499480] kvm: disabling virtualization on CPU1
[  314.499518] smpboot: CPU 1 is now offline
[  314.503225] intel_pstate CPU 2 exiting
[  314.505326] kvm: disabling virtualization on CPU2
[  314.505366] smpboot: CPU 2 is now offline
[  314.508842] intel_pstate CPU 3 exiting
[  314.510922] kvm: disabling virtualization on CPU3
[  314.511035] smpboot: CPU 3 is now offline
[  314.516036] ACPI: Low-level resume complete
[  314.516103] ACPI : EC: EC started
[  314.516104] PM: Restoring platform NVS memory
[  314.516517] Enabling non-boot CPUs ...
[  314.516640] x86: Booting SMP configuration:
[  314.516642] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  314.528347] kvm: enabling virtualization on CPU1
[  314.636205]  cache: parent cpu1 should not be sleeping
[  314.636887] CPU1 is up
[  314.636986] smpboot: Booting Node 0 Processor 2 APIC 0x2
[  314.648557] kvm: enabling virtualization on CPU2
[  314.756436]  cache: parent cpu2 should not be sleeping
[  314.757138] CPU2 is up
[  314.757238] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  314.768833] kvm: enabling virtualization on CPU3
[  314.876409]  cache: parent cpu3 should not be sleeping
[  314.877099] CPU3 is up
[  314.881297] ACPI: Waking up from system sleep state S3
[  315.452827] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[  315.452924] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[  315.453247] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[  315.469531] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[  315.470191] PM: noirq resume of devices complete after 17.896 msecs
[  315.474091] PM: early resume of devices complete after 3.811 msecs
[  315.478598] rtc_cmos 00:02: System wakeup disabled by ACPI
[  315.478808] sd 0:0:0:0: [sda] Starting disk
[  315.699010] usb 3-1.4: reset full-speed USB device number 4 using ehci-pci
[  315.795319] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  315.842437] usb 1-3: reset full-speed USB device number 3 using xhci_hcd
[  315.848885] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[  315.890983] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  315.890989] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  315.910992] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  315.910996] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  315.920972] ata1.00: configured for UDMA/133
[  316.018355] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[  316.025007] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  316.222951] psmouse serio1: synaptics: queried max coordinates: x [..5678], y [..4732]
[  316.254359] psmouse serio1: synaptics: queried min coordinates: x [1264..], y [1124..]
[  316.302991] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[  316.309646] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  316.399387] PM: resume of devices complete after 925.756 msecs
[  316.406528] PM: Finishing wakeup.
[  316.406536] Restarting tasks ... 
[  316.407388] Bluetooth: hci0: BCM: chip id 63
[  316.410403] Bluetooth: hci0: BCM20702A1 (001.002.014) build 0000
[  316.422407] done.
[  316.422590] bluetooth hci0: Direct firmware load for brcm/BCM20702A1-0a5c-21e6.hcd failed with error -2
[  316.422600] Bluetooth: hci0: BCM: Patch brcm/BCM20702A1-0a5c-21e6.hcd not found
[  316.435618] cfg80211: World regulatory domain updated:
[  316.435623] cfg80211:  DFS Master region: unset
[  316.435623] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[  316.435627] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[  316.435630] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[  316.435633] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[  316.435637] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[  316.435641] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[  316.435644] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[  316.435647] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[  316.435649] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[  319.677968] wlan0: authenticate with e0:91:f5:05:17:fb
[  319.682885] wlan0: send auth to e0:91:f5:05:17:fb (try 1/3)
[  319.684117] wlan0: authenticated
[  319.686748] wlan0: associate with e0:91:f5:05:17:fb (try 1/3)
[  319.688099] wlan0: RX AssocResp from e0:91:f5:05:17:fb (capab=0x11 status=0 aid=1)
[  319.707434] wlan0: associated
[  320.143384] PM: Syncing filesystems ... done.
[  320.242232] PM: Preparing system for mem sleep
[  320.242632] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  320.244328] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  320.245826] PM: Entering mem sleep
[  320.245846] Suspending console(s) (use no_console_suspend to debug)
[  320.247145] wlan0: deauthenticating from e0:91:f5:05:17:fb by local choice (Reason: 3=DEAUTH_LEAVING)
[  320.273069] cfg80211: Calling CRDA to update world regulatory domain
[  320.273313] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  320.275663] sd 0:0:0:0: [sda] Stopping disk
[  320.891446] PM: suspend of devices complete after 644.751 msecs
[  320.909651] PM: late suspend of devices complete after 18.198 msecs
[  320.916338] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[  320.916378] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[  320.916569] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[  320.929651] PM: noirq suspend of devices complete after 19.999 msecs
[  320.930182] ACPI: Preparing to enter system sleep state S3
[  321.229339] ACPI : EC: EC stopped
[  321.229342] PM: Saving platform NVS memory
[  321.229353] Disabling non-boot CPUs ...
[  321.229534] intel_pstate CPU 1 exiting
[  321.232801] kvm: disabling virtualization on CPU1
[  321.233457] smpboot: CPU 1 is now offline
[  321.236127] intel_pstate CPU 2 exiting
[  321.238002] kvm: disabling virtualization on CPU2
[  321.238032] smpboot: CPU 2 is now offline
[  321.240487] intel_pstate CPU 3 exiting
[  321.242083] kvm: disabling virtualization on CPU3
[  321.242104] smpboot: CPU 3 is now offline
[  321.246380] ACPI: Low-level resume complete
[  321.246446] ACPI : EC: EC started
[  321.246446] PM: Restoring platform NVS memory
[  321.246850] Enabling non-boot CPUs ...
[  321.246971] x86: Booting SMP configuration:
[  321.246973] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  321.259103] kvm: enabling virtualization on CPU1
[  321.368315]  cache: parent cpu1 should not be sleeping
[  321.369000] CPU1 is up
[  321.369097] smpboot: Booting Node 0 Processor 2 APIC 0x2
[  321.380667] kvm: enabling virtualization on CPU2
[  321.488196]  cache: parent cpu2 should not be sleeping
[  321.488881] CPU2 is up
[  321.488979] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  321.500574] kvm: enabling virtualization on CPU3
[  321.608201]  cache: parent cpu3 should not be sleeping
[  321.608896] CPU3 is up
[  321.613106] ACPI: Waking up from system sleep state S3
[  322.184480] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[  322.184767] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[  322.185065] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[  322.199700] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[  322.200648] PM: noirq resume of devices complete after 16.543 msecs
[  322.204750] PM: early resume of devices complete after 4.020 msecs
[  322.208262] sd 0:0:0:0: [sda] Starting disk
[  322.209233] rtc_cmos 00:02: System wakeup disabled by ACPI
[  322.427400] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[  322.523828] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  322.532931] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  322.532936] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  322.552923] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  322.552928] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  322.562919] ata1.00: configured for UDMA/133
[  322.570879] usb 1-3: reset full-speed USB device number 3 using xhci_hcd
[  322.577519] usb 3-1.4: reset full-speed USB device number 4 using ehci-pci
[  322.746440] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[  322.753164] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  322.956142] psmouse serio1: synaptics: queried max coordinates: x [..5678], y [..4732]
[  322.987630] psmouse serio1: synaptics: queried min coordinates: x [1264..], y [1124..]
[  323.031394] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[  323.038021] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  323.128214] PM: resume of devices complete after 923.922 msecs
[  323.134956] PM: Finishing wakeup.
[  323.134964] Restarting tasks ... 
[  323.136258] Bluetooth: hci0: BCM: chip id 63
[  323.142424] done.
[  323.143673] Bluetooth: hci0: BCM20702A1 (001.002.014) build 0000
[  323.143932] bluetooth hci0: Direct firmware load for brcm/BCM20702A1-0a5c-21e6.hcd failed with error -2
[  323.143943] Bluetooth: hci0: BCM: Patch brcm/BCM20702A1-0a5c-21e6.hcd not found
[  323.165810] cfg80211: World regulatory domain updated:
[  323.165816] cfg80211:  DFS Master region: unset
[  323.165816] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[  323.165822] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[  323.165826] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[  323.165829] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[  323.165834] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[  323.165839] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[  323.165842] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[  323.165846] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[  323.165850] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[  326.504242] wlan0: authenticate with e0:91:f5:05:17:fb
[  326.509180] wlan0: send auth to e0:91:f5:05:17:fb (try 1/3)
[  326.510682] wlan0: authenticated
[  326.511846] wlan0: associate with e0:91:f5:05:17:fb (try 1/3)
[  326.513274] wlan0: RX AssocResp from e0:91:f5:05:17:fb (capab=0x11 status=0 aid=1)
[  326.533181] wlan0: associated
[  329.222487] PM: Syncing filesystems ... done.
[  329.326024] PM: Preparing system for mem sleep
[  329.326602] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  329.328274] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  329.329696] PM: Entering mem sleep
[  329.329716] Suspending console(s) (use no_console_suspend to debug)
[  329.330990] wlan0: deauthenticating from e0:91:f5:05:17:fb by local choice (Reason: 3=DEAUTH_LEAVING)
[  329.357963] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  329.358093] cfg80211: Calling CRDA to update world regulatory domain
[  329.359255] sd 0:0:0:0: [sda] Stopping disk
[  329.983467] PM: suspend of devices complete after 652.923 msecs
[  330.000203] PM: late suspend of devices complete after 16.722 msecs
[  330.005103] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[  330.005142] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[  330.005187] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[  330.017152] PM: noirq suspend of devices complete after 16.949 msecs
[  330.017596] ACPI: Preparing to enter system sleep state S3
[  330.316599] ACPI : EC: EC stopped
[  330.316602] PM: Saving platform NVS memory
[  330.316614] Disabling non-boot CPUs ...
[  330.316811] intel_pstate CPU 1 exiting
[  330.318776] kvm: disabling virtualization on CPU1
[  330.318813] smpboot: CPU 1 is now offline
[  330.321665] intel_pstate CPU 2 exiting
[  330.323580] kvm: disabling virtualization on CPU2
[  330.324320] smpboot: CPU 2 is now offline
[  330.327678] intel_pstate CPU 3 exiting
[  330.329426] kvm: disabling virtualization on CPU3
[  330.329453] smpboot: CPU 3 is now offline
[  330.334272] ACPI: Low-level resume complete
[  330.334337] ACPI : EC: EC started
[  330.334338] PM: Restoring platform NVS memory
[  330.334759] Enabling non-boot CPUs ...
[  330.334882] x86: Booting SMP configuration:
[  330.334884] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  330.346652] kvm: enabling virtualization on CPU1
[  330.455506]  cache: parent cpu1 should not be sleeping
[  330.456191] CPU1 is up
[  330.456289] smpboot: Booting Node 0 Processor 2 APIC 0x2
[  330.467855] kvm: enabling virtualization on CPU2
[  330.575684]  cache: parent cpu2 should not be sleeping
[  330.576366] CPU2 is up
[  330.576464] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  330.588056] kvm: enabling virtualization on CPU3
[  330.695696]  cache: parent cpu3 should not be sleeping
[  330.696379] CPU3 is up
[  330.700117] ACPI: Waking up from system sleep state S3
[  331.271990] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[  331.272216] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[  331.272823] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[  331.286850] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[  331.288091] PM: noirq resume of devices complete after 16.484 msecs
[  331.291165] PM: early resume of devices complete after 2.992 msecs
[  331.295024] sd 0:0:0:0: [sda] Starting disk
[  331.296528] rtc_cmos 00:02: System wakeup disabled by ACPI
[  331.518367] usb 3-1.4: reset full-speed USB device number 4 using ehci-pci
[  331.611315] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  331.614288] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  331.614294] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  331.634265] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  331.634269] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  331.644358] ata1.00: configured for UDMA/133
[  331.658433] usb 1-3: reset full-speed USB device number 3 using xhci_hcd
[  331.668219] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[  331.833932] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[  331.840718] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  332.034495] psmouse serio1: synaptics: queried max coordinates: x [..5678], y [..4732]
[  332.065518] psmouse serio1: synaptics: queried min coordinates: x [1264..], y [1124..]
[  332.119053] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[  332.125688] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  332.215753] PM: resume of devices complete after 925.047 msecs
[  332.221433] PM: Finishing wakeup.
[  332.221441] Restarting tasks ... done.
[  332.227877] Bluetooth: hci0: BCM: chip id 63
[  332.229306] Bluetooth: hci0: BCM20702A1 (001.002.014) build 0000
[  332.229477] bluetooth hci0: Direct firmware load for brcm/BCM20702A1-0a5c-21e6.hcd failed with error -2
[  332.229486] Bluetooth: hci0: BCM: Patch brcm/BCM20702A1-0a5c-21e6.hcd not found
[  332.240745] cfg80211: World regulatory domain updated:
[  332.240750] cfg80211:  DFS Master region: unset
[  332.240751] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[  332.240755] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[  332.240758] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[  332.240761] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[  332.240765] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[  332.240769] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[  332.240773] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[  332.240776] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[  332.240779] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[  335.580830] wlan0: authenticate with e0:91:f5:05:17:fb
[  335.584469] wlan0: send auth to e0:91:f5:05:17:fb (try 1/3)
[  335.585561] wlan0: authenticated
[  335.585929] wlan0: associate with e0:91:f5:05:17:fb (try 1/3)
[  335.587257] wlan0: RX AssocResp from e0:91:f5:05:17:fb (capab=0x11 status=0 aid=1)
[  335.606663] wlan0: associated
[  335.669631] PM: Syncing filesystems ... done.
[  335.765603] PM: Preparing system for mem sleep
[  335.766662] Freezing user space processes ... (elapsed 0.002 seconds) done.
[  335.768806] Freezing remaining freezable tasks ... (elapsed 0.002 seconds) done.
[  335.770951] PM: Entering mem sleep
[  335.771007] Suspending console(s) (use no_console_suspend to debug)
[  335.775011] wlan0: deauthenticating from e0:91:f5:05:17:fb by local choice (Reason: 3=DEAUTH_LEAVING)
[  335.801336] cfg80211: Calling CRDA to update world regulatory domain
[  335.801588] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  335.804020] sd 0:0:0:0: [sda] Stopping disk
[  336.423588] PM: suspend of devices complete after 649.307 msecs
[  336.438975] PM: late suspend of devices complete after 15.386 msecs
[  336.443645] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[  336.444039] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[  336.444646] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[  336.455921] PM: noirq suspend of devices complete after 16.948 msecs
[  336.456253] ACPI: Preparing to enter system sleep state S3
[  336.755436] ACPI : EC: EC stopped
[  336.755439] PM: Saving platform NVS memory
[  336.755451] Disabling non-boot CPUs ...
[  336.755613] intel_pstate CPU 1 exiting
[  336.757611] kvm: disabling virtualization on CPU1
[  336.757640] smpboot: CPU 1 is now offline
[  336.761436] intel_pstate CPU 2 exiting
[  336.763413] kvm: disabling virtualization on CPU2
[  336.763441] smpboot: CPU 2 is now offline
[  336.767142] intel_pstate CPU 3 exiting
[  336.768870] kvm: disabling virtualization on CPU3
[  336.769651] smpboot: CPU 3 is now offline
[  336.773715] ACPI: Low-level resume complete
[  336.773783] ACPI : EC: EC started
[  336.773784] PM: Restoring platform NVS memory
[  336.774194] Enabling non-boot CPUs ...
[  336.774319] x86: Booting SMP configuration:
[  336.774320] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  336.786434] kvm: enabling virtualization on CPU1
[  336.894186]  cache: parent cpu1 should not be sleeping
[  336.894864] CPU1 is up
[  336.894978] smpboot: Booting Node 0 Processor 2 APIC 0x2
[  336.906547] kvm: enabling virtualization on CPU2
[  337.014167]  cache: parent cpu2 should not be sleeping
[  337.014851] CPU2 is up
[  337.014950] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  337.026540] kvm: enabling virtualization on CPU3
[  337.134390]  cache: parent cpu3 should not be sleeping
[  337.135084] CPU3 is up
[  337.138821] ACPI: Waking up from system sleep state S3
[  337.710733] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[  337.711289] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[  337.711335] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[  337.724251] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[  337.726275] PM: noirq resume of devices complete after 16.000 msecs
[  337.728975] PM: early resume of devices complete after 2.608 msecs
[  337.733456] rtc_cmos 00:02: System wakeup disabled by ACPI
[  337.733843] sd 0:0:0:0: [sda] Starting disk
[  337.956878] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[  338.049968] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  338.051403] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  338.051408] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  338.071370] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  338.071375] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  338.081380] ata1.00: configured for UDMA/133
[  338.097070] usb 1-3: reset full-speed USB device number 3 using xhci_hcd
[  338.106960] usb 3-1.4: reset full-speed USB device number 4 using ehci-pci
[  338.272775] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[  338.279359] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  338.465561] psmouse serio1: synaptics: queried max coordinates: x [..5678], y [..4732]
[  338.497463] psmouse serio1: synaptics: queried min coordinates: x [1264..], y [1124..]
[  338.558033] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[  338.564719] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  338.655725] PM: resume of devices complete after 927.211 msecs
[  338.662254] PM: Finishing wakeup.
[  338.662263] Restarting tasks ... 
[  338.663670] Bluetooth: hci0: BCM: chip id 63
[  338.665356] done.
[  338.665540] Bluetooth: hci0: BCM20702A1 (001.002.014) build 0000
[  338.665736] bluetooth hci0: Direct firmware load for brcm/BCM20702A1-0a5c-21e6.hcd failed with error -2
[  338.665749] Bluetooth: hci0: BCM: Patch brcm/BCM20702A1-0a5c-21e6.hcd not found
[  338.686074] cfg80211: World regulatory domain updated:
[  338.686079] cfg80211:  DFS Master region: unset
[  338.686080] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[  338.686083] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[  338.686084] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[  338.686086] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[  338.686088] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[  338.686090] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[  338.686091] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[  338.686093] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[  338.686094] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[  341.937861] wlan0: authenticate with e0:91:f5:05:17:fb
[  341.942735] wlan0: send auth to e0:91:f5:05:17:fb (try 1/3)
[  341.943876] wlan0: authenticated
[  341.944693] wlan0: associate with e0:91:f5:05:17:fb (try 1/3)
[  341.945963] wlan0: RX AssocResp from e0:91:f5:05:17:fb (capab=0x11 status=0 aid=1)
[  341.965298] wlan0: associated
[  349.389043] PM: Syncing filesystems ... done.
[  349.497919] PM: Preparing system for mem sleep
[  349.498928] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  349.500582] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  349.502087] PM: Entering mem sleep
[  349.502108] Suspending console(s) (use no_console_suspend to debug)
[  349.503434] wlan0: deauthenticating from e0:91:f5:05:17:fb by local choice (Reason: 3=DEAUTH_LEAVING)
[  349.529141] cfg80211: Calling CRDA to update world regulatory domain
[  349.529374] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  349.530354] sd 0:0:0:0: [sda] Stopping disk
[  350.149997] PM: suspend of devices complete after 647.015 msecs
[  350.167446] PM: late suspend of devices complete after 17.428 msecs
[  350.173814] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[  350.174510] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[  350.174899] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[  350.187357] PM: noirq suspend of devices complete after 19.911 msecs
[  350.187778] ACPI: Preparing to enter system sleep state S3
[  350.487073] ACPI : EC: EC stopped
[  350.487076] PM: Saving platform NVS memory
[  350.487088] Disabling non-boot CPUs ...
[  350.487293] intel_pstate CPU 1 exiting
[  350.489224] kvm: disabling virtualization on CPU1
[  350.489260] smpboot: CPU 1 is now offline
[  350.492595] intel_pstate CPU 2 exiting
[  350.494493] kvm: disabling virtualization on CPU2
[  350.495165] smpboot: CPU 2 is now offline
[  350.498476] intel_pstate CPU 3 exiting
[  350.500223] kvm: disabling virtualization on CPU3
[  350.500274] smpboot: CPU 3 is now offline
[  350.505143] ACPI: Low-level resume complete
[  350.505209] ACPI : EC: EC started
[  350.505210] PM: Restoring platform NVS memory
[  350.505716] Enabling non-boot CPUs ...
[  350.505836] x86: Booting SMP configuration:
[  350.505838] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  350.517494] kvm: enabling virtualization on CPU1
[  350.625976]  cache: parent cpu1 should not be sleeping
[  350.626656] CPU1 is up
[  350.626752] smpboot: Booting Node 0 Processor 2 APIC 0x2
[  350.638322] kvm: enabling virtualization on CPU2
[  350.746205]  cache: parent cpu2 should not be sleeping
[  350.746884] CPU2 is up
[  350.746979] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  350.758568] kvm: enabling virtualization on CPU3
[  350.866160]  cache: parent cpu3 should not be sleeping
[  350.866846] CPU3 is up
[  350.870583] ACPI: Waking up from system sleep state S3
[  351.442457] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[  351.442738] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[  351.443128] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[  351.458409] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[  351.459174] PM: noirq resume of devices complete after 17.102 msecs
[  351.463615] PM: early resume of devices complete after 4.326 msecs
[  351.468273] sd 0:0:0:0: [sda] Starting disk
[  351.468302] rtc_cmos 00:02: System wakeup disabled by ACPI
[  351.688732] usb 3-1.4: reset full-speed USB device number 4 using ehci-pci
[  351.781786] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  351.788400] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  351.788404] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  351.808377] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  351.808382] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  351.818420] ata1.00: configured for UDMA/133
[  351.828869] usb 1-3: reset full-speed USB device number 3 using xhci_hcd
[  351.838587] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[  352.004441] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[  352.011149] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  352.205824] psmouse serio1: synaptics: queried max coordinates: x [..5678], y [..4732]
[  352.237230] psmouse serio1: synaptics: queried min coordinates: x [1264..], y [1124..]
[  352.289640] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[  352.296290] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  352.386684] PM: resume of devices complete after 923.527 msecs
[  352.392741] PM: Finishing wakeup.
[  352.392749] Restarting tasks ... done.
[  352.399292] Bluetooth: hci0: BCM: chip id 63
[  352.400893] Bluetooth: hci0: BCM20702A1 (001.002.014) build 0000
[  352.401104] bluetooth hci0: Direct firmware load for brcm/BCM20702A1-0a5c-21e6.hcd failed with error -2
[  352.401113] Bluetooth: hci0: BCM: Patch brcm/BCM20702A1-0a5c-21e6.hcd not found
[  352.428494] cfg80211: World regulatory domain updated:
[  352.428502] cfg80211:  DFS Master region: unset
[  352.428505] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[  352.428510] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[  352.428514] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[  352.428517] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[  352.428521] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[  352.428525] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[  352.428528] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[  352.428531] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[  352.428535] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[  353.270216] PM: Syncing filesystems ... done.
[  353.380943] PM: Preparing system for mem sleep
[  353.381988] Freezing user space processes ... (elapsed 0.002 seconds) done.
[  353.384358] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  353.386203] PM: Entering mem sleep
[  353.386238] Suspending console(s) (use no_console_suspend to debug)
[  355.386723] iwlwifi 0000:03:00.0: Error sending REPLY_TXFIFO_FLUSH: time out after 2000ms.
[  355.386731] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 27 write_ptr 28
[  355.386940] iwlwifi 0000:03:00.0: Loaded firmware version: 18.168.6.1
[  355.387416] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x2000000.
[  355.387420] iwlwifi 0000:03:00.0: CSR values:
[  355.387422] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  355.387442] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00488700
[  355.387476] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[  355.387505] iwlwifi 0000:03:00.0:                     CSR_INT: 0X00000000
[  355.387536] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[  355.387564] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  355.387592] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000030
[  355.387620] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[  355.387648] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[  355.387676] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X000000b0
[  355.387704] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xd4c40ffd
[  355.387732] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[  355.387760] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00030001
[  355.387788] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080042
[  355.387815] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X000002f6
[  355.387844] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  355.387872] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  355.387900] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  355.387928] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000060
[  355.387956] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X88118188
[  355.387988] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  355.388016] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[  355.388044] iwlwifi 0000:03:00.0:      CSR_MONITOR_STATUS_REG: 0X6bf7f7d7
[  355.388072] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  355.388100] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  355.388103] iwlwifi 0000:03:00.0: FH register values:
[  355.388210] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0d239400
[  355.388264] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00d25f10
[  355.388315] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000b0
[  355.388373] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  355.388431] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  355.388488] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  355.388546] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  355.388603] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  355.388660] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  355.388707] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[  355.388712] iwlwifi 0000:03:00.0: Status: 0x000002CC, count: 6
[  355.388717] iwlwifi 0000:03:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       
[  355.388721] iwlwifi 0000:03:00.0: 0x00010050 | uPc
[  355.388724] iwlwifi 0000:03:00.0: 0x0001001E | branchlink1
[  355.388727] iwlwifi 0000:03:00.0: 0x00010090 | branchlink2
[  355.388730] iwlwifi 0000:03:00.0: 0x0000D6BE | interruptlink1
[  355.388734] iwlwifi 0000:03:00.0: 0x0000D6BE | interruptlink2
[  355.388737] iwlwifi 0000:03:00.0: 0x00000081 | data1
[  355.388740] iwlwifi 0000:03:00.0: 0x07030000 | data2
[  355.388743] iwlwifi 0000:03:00.0: 0x00024B96 | line
[  355.388747] iwlwifi 0000:03:00.0: 0x05C15263 | beacon time
[  355.388750] iwlwifi 0000:03:00.0: 0x00242D9D | tsf low
[  355.388754] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[  355.388757] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[  355.388760] iwlwifi 0000:03:00.0: 0x002EFE23 | time gp2
[  355.388763] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[  355.388767] iwlwifi 0000:03:00.0: 0x754312A8 | uCode version
[  355.388770] iwlwifi 0000:03:00.0: 0x000000B0 | hw version
[  355.388773] iwlwifi 0000:03:00.0: 0x00488700 | board version
[  355.388776] iwlwifi 0000:03:00.0: 0x0000001C | hcmd
[  355.388780] iwlwifi 0000:03:00.0: 0x27863040 | isr0
[  355.388783] iwlwifi 0000:03:00.0: 0x0101E000 | isr1
[  355.388786] iwlwifi 0000:03:00.0: 0x00000E02 | isr2
[  355.388789] iwlwifi 0000:03:00.0: 0x0147FCC3 | isr3
[  355.388792] iwlwifi 0000:03:00.0: 0x00000000 | isr4
[  355.388796] iwlwifi 0000:03:00.0: 0x00000110 | isr_pref
[  355.388799] iwlwifi 0000:03:00.0: 0x00024B96 | wait_event
[  355.388802] iwlwifi 0000:03:00.0: 0x00000050 | l2p_control
[  355.388806] iwlwifi 0000:03:00.0: 0x0000003C | l2p_duration
[  355.388809] iwlwifi 0000:03:00.0: 0x0000003F | l2p_mhvalid
[  355.388812] iwlwifi 0000:03:00.0: 0x00101040 | l2p_addr_match
[  355.388815] iwlwifi 0000:03:00.0: 0x00000005 | lmpm_pmg_sel
[  355.388819] iwlwifi 0000:03:00.0: 0x06061222 | timestamp
[  355.388822] iwlwifi 0000:03:00.0: 0x0000B0C0 | flow_handler
[  355.389207] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 1 entries
[  355.389322] iwlwifi 0000:03:00.0: EVT_LOGT:0003079711:0x0000010c:0123
[  355.390114] iwlwifi 0000:03:00.0: flush request fail
[  355.390166] queueing ieee80211 work while going to suspend
[  355.390175] iwlwifi 0000:03:00.0: Command REPLY_RXON failed: FW Error
[  355.390180] iwlwifi 0000:03:00.0: Error clearing ASSOC_MSK on BSS (-5)
[  355.391689] ieee80211 phy0: Hardware restart was requested
[  355.392415] ------------[ cut here ]------------
[  355.392428] WARNING: CPU: 2 PID: 110 at /home/kas/git/public/linux/net/mac80211/main.c:257 ieee80211_restart_work+0x71/0x80()
[  355.392430] ieee80211_restart_work called with hardware scan in progress
[  355.392437] Modules linked in: iwldvm iwlwifi
[  355.392443] CPU: 2 PID: 110 Comm: kworker/2:5 Not tainted 4.1.0-rc6-00049-g8a7deb362b76 #57
[  355.392445] Hardware name: LENOVO 3460CC6/3460CC6, BIOS G6ETB0WW (2.70 ) 02/05/2015
[  355.392452] Workqueue: events ieee80211_restart_work
[  355.392460]  ffffffff820349b0 ffff8800d1eabca8 ffffffff81b81928 0000000000000000
[  355.392466]  ffff8800d1eabcf8 ffff8800d1eabce8 ffffffff8110718a ffff88000000000e
[  355.392471]  ffff8800d2b21e00 ffff8800d2b209c0 ffff88011e297640 ffff88011e29c800
[  355.392473] Call Trace:
[  355.392483]  [<ffffffff81b81928>] dump_stack+0x4c/0x6e
[  355.392492]  [<ffffffff8110718a>] warn_slowpath_common+0x8a/0xc0
[  355.392498]  [<ffffffff81107206>] warn_slowpath_fmt+0x46/0x50
[  355.392503]  [<ffffffff81ad23f1>] ieee80211_restart_work+0x71/0x80
[  355.392512]  [<ffffffff811252b8>] process_one_work+0x1d8/0x830
[  355.392517]  [<ffffffff8112521c>] ? process_one_work+0x13c/0x830
[  355.392524]  [<ffffffff8112597b>] worker_thread+0x6b/0x4b0
[  355.392530]  [<ffffffff81125910>] ? process_one_work+0x830/0x830
[  355.392535]  [<ffffffff81125910>] ? process_one_work+0x830/0x830
[  355.392541]  [<ffffffff8112c1d9>] kthread+0x119/0x130
[  355.392547]  [<ffffffff8112c0c0>] ? kthread_create_on_node+0x240/0x240
[  355.392555]  [<ffffffff81b8eee2>] ret_from_fork+0x42/0x70
[  355.392559]  [<ffffffff8112c0c0>] ? kthread_create_on_node+0x240/0x240
[  355.392563] ---[ end trace 7e67801b54732276 ]---
[  355.393431] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  355.393581] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[  355.395408] sd 0:0:0:0: [sda] Stopping disk
[  355.400214] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  355.675637] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[  355.682264] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  356.034465] PM: suspend of devices complete after 2647.316 msecs
[  356.049798] PM: late suspend of devices complete after 15.326 msecs
[  356.055440] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[  356.055629] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[  356.055953] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[  356.069739] PM: noirq suspend of devices complete after 19.941 msecs
[  356.070271] ACPI: Preparing to enter system sleep state S3
[  356.369519] ACPI : EC: EC stopped
[  356.369522] PM: Saving platform NVS memory
[  356.369534] Disabling non-boot CPUs ...
[  356.369728] intel_pstate CPU 1 exiting
[  356.371675] kvm: disabling virtualization on CPU1
[  356.371714] smpboot: CPU 1 is now offline
[  356.374555] intel_pstate CPU 2 exiting
[  356.376480] kvm: disabling virtualization on CPU2
[  356.377288] smpboot: CPU 2 is now offline
[  356.380442] intel_pstate CPU 3 exiting
[  356.382195] kvm: disabling virtualization on CPU3
[  356.382221] smpboot: CPU 3 is now offline
[  356.387047] ACPI: Low-level resume complete
[  356.387113] ACPI : EC: EC started
[  356.387114] PM: Restoring platform NVS memory
[  356.387533] Enabling non-boot CPUs ...
[  356.387654] x86: Booting SMP configuration:
[  356.387656] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  356.399315] kvm: enabling virtualization on CPU1
[  356.508678]  cache: parent cpu1 should not be sleeping
[  356.509363] CPU1 is up
[  356.509460] smpboot: Booting Node 0 Processor 2 APIC 0x2
[  356.521028] kvm: enabling virtualization on CPU2
[  356.628660]  cache: parent cpu2 should not be sleeping
[  356.629359] CPU2 is up
[  356.629459] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  356.641049] kvm: enabling virtualization on CPU3
[  356.748618]  cache: parent cpu3 should not be sleeping
[  356.749307] CPU3 is up
[  356.753507] ACPI: Waking up from system sleep state S3
[  357.324904] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[  357.325132] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[  357.325665] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[  357.340457] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[  357.341486] PM: noirq resume of devices complete after 16.968 msecs
[  357.345576] PM: early resume of devices complete after 4.007 msecs
[  357.349986] rtc_cmos 00:02: System wakeup disabled by ACPI
[  357.351612] sd 0:0:0:0: [sda] Starting disk
[  357.574500] usb 3-1.4: reset full-speed USB device number 4 using ehci-pci
[  357.664210] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  357.671037] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  357.671056] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  357.690966] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  357.690971] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  357.700952] ata1.00: configured for UDMA/133
[  357.711289] usb 1-3: reset full-speed USB device number 3 using xhci_hcd
[  357.724382] usb 3-1.6: reset high-speed USB device number 5 using ehci-pci
[  357.887242] iwlwifi 0000:03:00.0: L1 Enabled - LTR Disabled
[  357.893866] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
[  358.086594] psmouse serio1: synaptics: queried max coordinates: x [..5678], y [..4732]
[  358.116867] psmouse serio1: synaptics: queried min coordinates: x [1264..], y [1124..]
[  359.601155] irq 31: nobody cared (try booting with the "irqpoll" option)
[  359.601157] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W       4.1.0-rc6-00049-g8a7deb362b76 #57
[  359.601158] Hardware name: LENOVO 3460CC6/3460CC6, BIOS G6ETB0WW (2.70 ) 02/05/2015
[  359.601160]  ffff8800d21e5c98 ffff88011e203e38 ffffffff81b81928 000000000000003c
[  359.601162]  ffff8800d21e5c00 ffff88011e203e68 ffffffff8117fd96 0000000000000046
[  359.601163]  ffff8800d21e5c00 0000000000000000 000000000000001f ffff88011e203ea8
[  359.601164] Call Trace:
[  359.601169]  <IRQ>  [<ffffffff81b81928>] dump_stack+0x4c/0x6e
[  359.601171]  [<ffffffff8117fd96>] __report_bad_irq+0x36/0xd0
[  359.601173]  [<ffffffff81180147>] note_interrupt+0x257/0x2a0
[  359.601175]  [<ffffffff8117d334>] handle_irq_event_percpu+0x114/0x540
[  359.601177]  [<ffffffff8117d7a1>] handle_irq_event+0x41/0x70
[  359.601178]  [<ffffffff8118089e>] handle_edge_irq+0x9e/0x110
[  359.601182]  [<ffffffff81079bf2>] handle_irq+0x22/0x40
[  359.601184]  [<ffffffff81b9181f>] do_IRQ+0x4f/0xf0
[  359.601186]  [<ffffffff81b8f633>] common_interrupt+0x73/0x73
[  359.601189]  <EOI>  [<ffffffff811a3ca0>] ? __tick_nohz_idle_enter+0x4a0/0x680
[  359.601192]  [<ffffffff811a409d>] ? tick_nohz_idle_enter+0x4d/0x80
[  359.601194]  [<ffffffff811a4096>] ? tick_nohz_idle_enter+0x46/0x80
[  359.601196]  [<ffffffff81158160>] cpu_startup_entry+0xa0/0x5f0
[  359.601197]  [<ffffffff81b772f9>] rest_init+0x139/0x140
[  359.601200]  [<ffffffff823bdfda>] start_kernel+0x4a0/0x4ad
[  359.601202]  [<ffffffff823bd120>] ? early_idt_handlers+0x120/0x120
[  359.601203]  [<ffffffff823bd4d7>] x86_64_start_reservations+0x2a/0x2c
[  359.601205]  [<ffffffff823bd614>] x86_64_start_kernel+0x13b/0x14a
[  359.601206] handlers:
[  359.601215] [<ffffffffa000e6a0>] iwl_pcie_isr [iwlwifi] threaded [<ffffffffa000a350>] iwl_pcie_irq_handler [iwlwifi]
[  359.601215] Disabling IRQ #31
[  362.891657] iwlwifi 0000:03:00.0: Failed to load firmware chunk!
[  362.891665] iwlwifi 0000:03:00.0: Could not load the [0] uCode section
[  362.892012] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -110
[  362.892320] iwlwifi 0000:03:00.0: Unable to initialize device.
[  362.892326] ------------[ cut here ]------------
[  362.892340] WARNING: CPU: 1 PID: 2182 at /home/kas/git/public/linux/net/mac80211/util.c:1800 ieee80211_reconfig+0xb82/0x52a0()
[  362.892341] Hardware became unavailable during restart.
[  362.892351] Modules linked in: iwldvm iwlwifi
[  362.892358] CPU: 1 PID: 2182 Comm: zsh Tainted: G        W       4.1.0-rc6-00049-g8a7deb362b76 #57
[  362.892360] Hardware name: LENOVO 3460CC6/3460CC6, BIOS G6ETB0WW (2.70 ) 02/05/2015
[  362.892370]  ffffffff82035bb0 ffff8800d3737a68 ffffffff81b81928 0000000000000000
[  362.892377]  ffff8800d3737ab8 ffff8800d3737aa8 ffffffff8110718a ffff8800d3737aa8
[  362.892385]  ffff8800d2b209c0 00000000ffffff92 0000000000000000 0000000000000010
[  362.892386] Call Trace:
[  362.892399]  [<ffffffff81b81928>] dump_stack+0x4c/0x6e
[  362.892410]  [<ffffffff8110718a>] warn_slowpath_common+0x8a/0xc0
[  362.892416]  [<ffffffff81107206>] warn_slowpath_fmt+0x46/0x50
[  362.892422]  [<ffffffff81b25ee2>] ieee80211_reconfig+0xb82/0x52a0
[  362.892431]  [<ffffffff81912e17>] ? rtnl_lock+0x17/0x20
[  362.892439]  [<ffffffff811643bd>] ? trace_hardirqs_on+0xd/0x10
[  362.892447]  [<ffffffff81b09bf8>] ieee80211_resume+0x68/0x90
[  362.892454]  [<ffffffff81a779cb>] wiphy_resume+0xcb/0x480
[  362.892459]  [<ffffffff81a77900>] ? wiphy_namespace+0x20/0x20
[  362.892466]  [<ffffffff816a8183>] dpm_run_callback+0x83/0x480
[  362.892471]  [<ffffffff816a8a68>] device_resume+0xd8/0x200
[  362.892477]  [<ffffffff816aa809>] dpm_resume+0x1b9/0x650
[  362.892482]  [<ffffffff816ab725>] dpm_resume_end+0x15/0x30
[  362.892488]  [<ffffffff8116ef7c>] suspend_devices_and_enter+0x14c/0x10f0
[  362.892494]  [<ffffffff811652f4>] ? __lock_is_held+0x54/0x80
[  362.892499]  [<ffffffff81170512>] pm_suspend+0x5f2/0xd40
[  362.892503]  [<ffffffff8116de87>] state_store+0xa7/0xb0
[  362.892513]  [<ffffffff8146de0f>] kobj_attr_store+0xf/0x20
[  362.892522]  [<ffffffff81329b29>] sysfs_kf_write+0x49/0x60
[  362.892528]  [<ffffffff81328df0>] kernfs_fop_write+0x140/0x1a0
[  362.892536]  [<ffffffff812a03e8>] __vfs_write+0x28/0xf0
[  362.892542]  [<ffffffff812a0db3>] ? vfs_write+0x163/0x1b0
[  362.892551]  [<ffffffff813f8193>] ? security_file_permission+0x23/0xa0
[  362.892556]  [<ffffffff812a0cf9>] vfs_write+0xa9/0x1b0
[  362.892565]  [<ffffffff81b8f6a1>] ? retint_swapgs+0x16/0x1e
[  362.892570]  [<ffffffff812a1a5d>] SyS_write+0x4d/0xc0
[  362.892576]  [<ffffffff81b8ea72>] system_call_fastpath+0x16/0x7a
[  362.892581] ---[ end trace 7e67801b54732277 ]---
[  362.894769] ------------[ cut here ]------------
[  362.894779] WARNING: CPU: 1 PID: 2182 at /home/kas/git/public/linux/net/mac80211/driver-ops.h:12 ieee80211_do_stop+0xb48/0xc60()
[  362.894870] wlan0:  Failed check-sdata-in-driver check, flags: 0x0
[  362.894877] Modules linked in: iwldvm iwlwifi
[  362.894881] CPU: 1 PID: 2182 Comm: zsh Tainted: G        W       4.1.0-rc6-00049-g8a7deb362b76 #57
[  362.894884] Hardware name: LENOVO 3460CC6/3460CC6, BIOS G6ETB0WW (2.70 ) 02/05/2015
[  362.894891]  ffffffff82034b78 ffff8800d37378b8 ffffffff81b81928 0000000000000000
[  362.894898]  ffff8800d3737908 ffff8800d37378f8 ffffffff8110718a 0000000000000246
[  362.894905]  ffff8800d2b289c0 ffff8800d2b209c0 0000000000000000 ffff8800d2b21768
[  362.894906] Call Trace:
[  362.894915]  [<ffffffff81b81928>] dump_stack+0x4c/0x6e
[  362.894923]  [<ffffffff8110718a>] warn_slowpath_common+0x8a/0xc0
[  362.894929]  [<ffffffff81107206>] warn_slowpath_fmt+0x46/0x50
[  362.894936]  [<ffffffff81134ed6>] ? __might_sleep+0x56/0xc0
[  362.894940]  [<ffffffff81afb008>] ieee80211_do_stop+0xb48/0xc60
[  362.894948]  [<ffffffff8192b4b9>] ? dev_deactivate_many+0x259/0x310
[  362.894952]  [<ffffffff81afb13a>] ieee80211_stop+0x1a/0x20
[  362.894959]  [<ffffffff818f9485>] __dev_close_many+0x95/0xe0
[  362.894964]  [<ffffffff818f9558>] dev_close_many+0x88/0x120
[  362.894971]  [<ffffffff818ff896>] dev_close.part.75+0x36/0x50
[  362.894976]  [<ffffffff818ff8d1>] dev_close+0x21/0x30
[  362.894983]  [<ffffffff81a764d5>] cfg80211_shutdown_all_interfaces+0x55/0xd0
[  362.894988]  [<ffffffff81b21625>] ieee80211_handle_reconfig_failure+0x95/0xa0
[  362.894993]  [<ffffffff81b25487>] ieee80211_reconfig+0x127/0x52a0
[  362.894999]  [<ffffffff81912e17>] ? rtnl_lock+0x17/0x20
[  362.895005]  [<ffffffff811643bd>] ? trace_hardirqs_on+0xd/0x10
[  362.895011]  [<ffffffff81b09bf8>] ieee80211_resume+0x68/0x90
[  362.895016]  [<ffffffff81a779cb>] wiphy_resume+0xcb/0x480
[  362.895021]  [<ffffffff81a77900>] ? wiphy_namespace+0x20/0x20
[  362.895027]  [<ffffffff816a8183>] dpm_run_callback+0x83/0x480
[  362.895032]  [<ffffffff816a8a68>] device_resume+0xd8/0x200
[  362.895037]  [<ffffffff816aa809>] dpm_resume+0x1b9/0x650
[  362.895042]  [<ffffffff816ab725>] dpm_resume_end+0x15/0x30
[  362.895047]  [<ffffffff8116ef7c>] suspend_devices_and_enter+0x14c/0x10f0
[  362.895052]  [<ffffffff811652f4>] ? __lock_is_held+0x54/0x80
[  362.895057]  [<ffffffff81170512>] pm_suspend+0x5f2/0xd40
[  362.895061]  [<ffffffff8116de87>] state_store+0xa7/0xb0
[  362.895070]  [<ffffffff8146de0f>] kobj_attr_store+0xf/0x20
[  362.895078]  [<ffffffff81329b29>] sysfs_kf_write+0x49/0x60
[  362.895085]  [<ffffffff81328df0>] kernfs_fop_write+0x140/0x1a0
[  362.895092]  [<ffffffff812a03e8>] __vfs_write+0x28/0xf0
[  362.895097]  [<ffffffff812a0db3>] ? vfs_write+0x163/0x1b0
[  362.895105]  [<ffffffff813f8193>] ? security_file_permission+0x23/0xa0
[  362.895110]  [<ffffffff812a0cf9>] vfs_write+0xa9/0x1b0
[  362.895117]  [<ffffffff81b8f6a1>] ? retint_swapgs+0x16/0x1e
[  362.895122]  [<ffffffff812a1a5d>] SyS_write+0x4d/0xc0
[  362.895128]  [<ffffffff81b8ea72>] system_call_fastpath+0x16/0x7a
[  362.895132] ---[ end trace 7e67801b54732278 ]---
[  362.896900] dpm_run_callback(): wiphy_resume+0x0/0x480 returns -110
[  362.896910] PM: Device phy0 failed to resume: error -110
[  362.897083] PM: resume of devices complete after 5554.322 msecs
[  362.905201] PM: Finishing wakeup.
[  362.905208] Restarting tasks ... 
[  362.905700] Bluetooth: hci0: BCM: chip id 63
[  362.906653] Bluetooth: hci0: BCM20702A1 (001.002.014) build 0000
[  362.908635] done.
[  362.908802] bluetooth hci0: Direct firmware load for brcm/BCM20702A1-0a5c-21e6.hcd failed with error -2
[  362.908818] Bluetooth: hci0: BCM: Patch brcm/BCM20702A1-0a5c-21e6.hcd not found

-- 
 Kirill A. Shutemov

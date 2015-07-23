Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35749 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbbGWNuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 09:50:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ZIGsu-0006R3-Qf
	for linux-wireless@vger.kernel.org; Thu, 23 Jul 2015 15:50:05 +0200
Received: from 37.162.130.112 ([37.162.130.112])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2015 15:50:04 +0200
Received: from j.cubizolles by 37.162.130.112 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2015 15:50:04 +0200
To: linux-wireless@vger.kernel.org
From: Julien Cubizolles <j.cubizolles@free.fr>
Subject: wifi freezing (module mwifiex)
Date: Thu, 23 Jul 2015 15:48:22 +0200
Message-ID: <871tfzast5.fsf@free.fr> (sfid-20150723_155016_575299_CEEF2487)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm running vanilla kernel 4.2.0-rc3 on a Microsoft Surface Pro. The
wifi (module mwifiex) freezes the whole system after a few seconds of
use. The problem appeared around kernel 3.19.

I've tried to get some debug info with the dynamic debugging method,
using the following:

--8<---------------cut here---------------start------------->8---
echo "module mwifiex +p" > /sys/kernel/debug/dynamic_debug/control
echo "module mwifiex_sdio +p" > /sys/kernel/debug/dynamic_debug/control
echo "module mwifiex_pcie +p" > /sys/kernel/debug/dynamic_debug/control
echo "module mwifiex_usb +p" > /sys/kernel/debug/dynamic_debug/control
--8<---------------cut here---------------end--------------->8---

and getting the messages with

--8<---------------cut here---------------start------------->8---
while true; do dmesg -c >> mwifiex_logs.txt; sleep 1; done &
--8<---------------cut here---------------end--------------->8---

until the system freezes.

Surprisingly, there are very few messages related to mwifiex (see the
following logs). Is there something wrong with the dynamic debugging ?
What other information could I provide ?

Julien.

--8<---------------cut here---------------start------------->8---
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.2.0-040200rc3-generic (kernel@tangerine) (gcc version 4.8.4 (Ubuntu 4.8.4-2ubuntu1~14.04) ) #201507192329 SMP Sun Jul 19 22:32:13 UTC 2015
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.2.0-040200rc3-generic root=UUID=919f00b8-5010-46e1-b2f9-c129e17d5312 ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] x86/fpu: xstate_offset[2]: 0240, xstate_sizes[2]: 0100
[    0.000000] x86/fpu: Supporting XSAVE feature 0x01: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x02: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x04: 'AVX registers'
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 0x340 bytes, using 'standard' format.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000d9202fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d9203000-0x00000000d9671fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d9672000-0x00000000d9681fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000d9682000-0x00000000da24ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da250000-0x00000000da66cfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000da66d000-0x00000000da6fefff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000da6ff000-0x00000000da6fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da700000-0x00000000da742fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da743000-0x00000000dad54fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dad55000-0x00000000daff1fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000daff2000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db800000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ESRT=0xda5f1618  ACPI=0xd9677000  ACPI 2.0=0xd9677000  SMBIOS=0xda66b198 
[    0.000000] esrt: Reserving ESRT space from 0x00000000da5f1618 to 0x00000000da5f16c8.
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Microsoft Corporation Surface with Windows 8 Pro/Surface with Windows 8 Pro, BIOS 1.00.0250 01/08/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x11f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0DB800000 mask FFF800000 uncachable
[    0.000000]   5 base 11F800000 mask FFF800000 uncachable
[    0.000000]   6 base 11F600000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 4GB, type WB
[    0.000000] reg 1, base: 4GB, range: 512MB, type WB
[    0.000000] reg 2, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 3, base: 3520MB, range: 64MB, type UC
[    0.000000] reg 4, base: 3512MB, range: 8MB, type UC
[    0.000000] reg 5, base: 4600MB, range: 8MB, type UC
[    0.000000] reg 6, base: 4598MB, range: 2MB, type UC
[    0.000000] total RAM covered: 4014M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 512MB, type WB
[    0.000000] reg 3, base: 3512MB, range: 8MB, type UC
[    0.000000] reg 4, base: 3520MB, range: 64MB, type UC
[    0.000000] reg 5, base: 4GB, range: 512MB, type WB
[    0.000000] reg 6, base: 4598MB, range: 2MB, type UC
[    0.000000] reg 7, base: 4600MB, range: 8MB, type UC
[    0.000000] e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fee000, 0x01feefff] PGTABLE
[    0.000000] BRK [0x01fef000, 0x01feffff] PGTABLE
[    0.000000] BRK [0x01ff0000, 0x01ff0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11f400000-0x11f5fffff]
[    0.000000]  [mem 0x11f400000-0x11f5fffff] page 2M
[    0.000000] BRK [0x01ff1000, 0x01ff1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11f3fffff]
[    0.000000]  [mem 0x100000000-0x11f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0xc0000000-0xd9202fff]
[    0.000000]  [mem 0xc0000000-0xd91fffff] page 2M
[    0.000000]  [mem 0xd9200000-0xd9202fff] page 4k
[    0.000000] BRK [0x01ff2000, 0x01ff2fff] PGTABLE
[    0.000000] BRK [0x01ff3000, 0x01ff3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xda6ff000-0xda6fffff]
[    0.000000]  [mem 0xda6ff000-0xda6fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0xda743000-0xdad54fff]
[    0.000000]  [mem 0xda743000-0xda7fffff] page 4k
[    0.000000]  [mem 0xda800000-0xdabfffff] page 2M
[    0.000000]  [mem 0xdac00000-0xdad54fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdaff2000-0xdaffffff]
[    0.000000]  [mem 0xdaff2000-0xdaffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x40005000-0xbfffffff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0xbfffffff] page 2M
[    0.000000] RAMDISK: [mem 0x358a2000-0x36c48fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000D9677000 000024 (v02 OEMR  )
[    0.000000] ACPI: XSDT 0x00000000D9677080 00007C (v01 OEMR   O E M R  00000000 OEMR 00010013)
[    0.000000] ACPI: FACP 0x00000000D967FD58 00010C (v05 OEMR   O E M R  00000000 OEMR 00010013)
[    0.000000] ACPI: DSDT 0x00000000D9677188 008BCC (v02 OEMR   O E M R  00000250 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000DA24E080 000040
[    0.000000] ACPI: APIC 0x00000000D967FE68 000072 (v03 OEMR   O E M R  00000000 OEMR 00010013)
[    0.000000] ACPI: FPDT 0x00000000D967FEE0 000044 (v01 OEMR   O E M R  00000000 OEMR 00010013)
[    0.000000] ACPI: MCFG 0x00000000D967FF28 00003C (v01 OEMR   O E M R  00000000 MSFT 00000097)
[    0.000000] ACPI: MSDM 0x00000000D967FF68 000055 (v03 OEMR   O E M R  00000000 OEMR 00010013)
[    0.000000] ACPI: HPET 0x00000000D967FFC0 000038 (v01 OEMR   O E M R  00000000 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000D967FFF8 000315 (v01 SataRe SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000D9680310 0008A2 (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000D9680BB8 000B22 (v01 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: DMAR 0x00000000D96816E0 0000B8 (v01 INTEL  SNB      00000001 INTL 00000001)
[    0.000000] ACPI: BGRT 0x00000000D9681798 000038 (v00 OEMR   O E M R  00000000 OEMR 00010013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011f5fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x11f5f5000-0x11f5f9fff]
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011ac00000-ffff88011ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000011f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009dfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001fffffff]
[    0.000000]   node   0: [mem 0x0000000020200000-0x0000000040003fff]
[    0.000000]   node   0: [mem 0x0000000040005000-0x00000000d9202fff]
[    0.000000]   node   0: [mem 0x00000000da6ff000-0x00000000da6fffff]
[    0.000000]   node   0: [mem 0x00000000da743000-0x00000000dad54fff]
[    0.000000]   node   0: [mem 0x00000000daff2000-0x00000000daffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000011f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000011f5fffff]
[    0.000000] On node 0 totalpages: 1018816
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 23 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13849 pages used for memmap
[    0.000000]   DMA32 zone: 886307 pages, LIFO batch:31
[    0.000000]   Normal zone: 2008 pages used for memmap
[    0.000000]   Normal zone: 128512 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xdba00000-0xdf9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd9203000-0xd9671fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd9672000-0xd9681fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd9682000-0xda24ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xda250000-0xda66cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xda66d000-0xda6fefff]
[    0.000000] PM: Registered nosave memory: [mem 0xda700000-0xda742fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdad55000-0xdaff1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb000000-0xdb7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb800000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 33 pages/cpu @ffff88011f200000 s96344 r8192 d30632 u524288
[    0.000000] pcpu-alloc: s96344 r8192 d30632 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1002872
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.2.0-040200rc3-generic root=UUID=919f00b8-5010-46e1-b2f9-c129e17d5312 ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3880232K/4075264K available (7859K kernel code, 1233K rwdata, 3840K rodata, 1456K init, 1292K bss, 195032K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=4
[    0.000000] NR_IRQS:16640 nr_irqs:456 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1696.104 MHz processor
[    0.000050] Calibrating delay loop (skipped), value calculated using timer frequency.. 3392.20 BogoMIPS (lpj=6784416)
[    0.000054] pid_max: default: 32768 minimum: 301
[    0.000062] ACPI: Core revision 20150619
[    0.009571] ACPI: All ACPI Tables successfully acquired
[    0.010598] Security Framework initialized
[    0.010605] AppArmor: AppArmor initialized
[    0.010607] Yama: becoming mindful.
[    0.011166] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.012702] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.013383] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.013391] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.013639] Initializing cgroup subsys blkio
[    0.013643] Initializing cgroup subsys memory
[    0.013652] Initializing cgroup subsys devices
[    0.013656] Initializing cgroup subsys freezer
[    0.013658] Initializing cgroup subsys net_cls
[    0.013661] Initializing cgroup subsys perf_event
[    0.013663] Initializing cgroup subsys net_prio
[    0.013666] Initializing cgroup subsys hugetlb
[    0.013696] CPU: Physical Processor ID: 0
[    0.013698] CPU: Processor Core ID: 0
[    0.013704] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.013705] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.014260] mce: CPU supports 7 MCE banks
[    0.014275] CPU0: Thermal monitoring enabled (TM1)
[    0.014285] process: using mwait in idle threads
[    0.014289] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.014291] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.014493] Freeing SMP alternatives memory: 28K (ffffffff81ea2000 - ffffffff81ea9000)
[    0.019391] ftrace: allocating 30748 entries in 121 pages
[    0.041001] DMAR: Host address width 36
[    0.041005] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.041018] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.041020] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.041025] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.041027] DMAR: RMRR base: 0x000000d9609000 end: 0x000000d9615fff
[    0.041029] DMAR: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.041032] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.041034] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.041036] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.041424] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.041427] x2apic enabled
[    0.041436] Switched APIC routing to cluster x2apic.
[    0.041919] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.082025] TSC deadline timer enabled
[    0.082029] smpboot: CPU0: Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz (fam: 06, model: 3a, stepping: 09)
[    0.082060] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.082089] ... version:                3
[    0.082090] ... bit width:              48
[    0.082092] ... generic registers:      4
[    0.082093] ... value mask:             0000ffffffffffff
[    0.082094] ... max period:             0000ffffffffffff
[    0.082095] ... fixed-purpose events:   3
[    0.082097] ... event mask:             000000070000000f
[    0.083364] x86: Booting SMP configuration:
[    0.083367] .... node  #0, CPUs:      #1
[    0.087199] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.087321]  #2 #3
[    0.095003] x86: Booted up 1 node, 4 CPUs
[    0.095007] smpboot: Total of 4 processors activated (13568.83 BogoMIPS)
[    0.099895] devtmpfs: initialized
[    0.103578] evm: security.selinux
[    0.103580] evm: security.SMACK64
[    0.103581] evm: security.SMACK64EXEC
[    0.103583] evm: security.SMACK64TRANSMUTE
[    0.103584] evm: security.SMACK64MMAP
[    0.103585] evm: security.ima
[    0.103586] evm: security.capability
[    0.103671] PM: Registering ACPI NVS region [mem 0xd9682000-0xda24ffff] (12378112 bytes)
[    0.103867] PM: Registering ACPI NVS region [mem 0xda700000-0xda742fff] (274432 bytes)
[    0.103976] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.104089] pinctrl core: initialized pinctrl subsystem
[    0.104229] RTC time:  7:44:08, date: 07/23/15
[    0.104375] NET: Registered protocol family 16
[    0.107686] cpuidle: using governor ladder
[    0.111691] cpuidle: using governor menu
[    0.111789] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.111792] ACPI: bus type PCI registered
[    0.111794] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.111884] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.111888] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.111901] PCI: Using configuration type 1 for base access
[    0.112170] perf_event_intel: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
[    0.116162] ACPI: Added _OSI(Module Device)
[    0.116165] ACPI: Added _OSI(Processor Device)
[    0.116167] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.116168] ACPI: Added _OSI(Processor Aggregator Device)
[    0.119599] ACPI: Executed 1 blocks of module-level executable AML code
[    0.123163] ACPI: Dynamic OEM Table Load:
[    0.123174] ACPI: SSDT 0xFFFF880119A39000 00083B (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.123888] ACPI: Dynamic OEM Table Load:
[    0.123894] ACPI: SSDT 0xFFFF880119A0E800 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.124494] ACPI: Dynamic OEM Table Load:
[    0.124499] ACPI: SSDT 0xFFFF880119A09E00 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.125606] ACPI : EC: EC started
[    1.521817] ACPI: Interpreter enabled
[    1.521827] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20150619/hwxface-580)
[    1.521833] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20150619/hwxface-580)
[    1.521851] ACPI: (supports S0 S3 S4 S5)
[    1.521853] ACPI: Using IOAPIC for interrupt routing
[    1.521890] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.543442] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.543450] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.543741] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    1.543908] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    1.543911] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    1.544381] PCI host bridge to bus 0000:00
[    1.544385] pci_bus 0000:00: root bus resource [bus 00-3e]
[    1.544388] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    1.544391] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    1.544393] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    1.544396] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff window]
[    1.544398] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff window]
[    1.544401] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff window]
[    1.544403] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
[    1.544405] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
[    1.544408] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
[    1.544410] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
[    1.544412] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
[    1.544415] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff window]
[    1.544417] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff window]
[    1.544419] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff window]
[    1.544422] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff window]
[    1.544424] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff window]
[    1.544427] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff window]
[    1.544436] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    1.544563] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    1.544582] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
[    1.544592] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    1.544598] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    1.544770] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    1.544808] pci 0000:00:14.0: reg 0x10: [mem 0xf7c00000-0xf7c0ffff 64bit]
[    1.544869] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    1.544929] pci 0000:00:14.0: System wakeup disabled by ACPI
[    1.544986] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    1.545026] pci 0000:00:16.0: reg 0x10: [mem 0xf7c1b000-0xf7c1b00f 64bit]
[    1.545100] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.545220] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    1.545252] pci 0000:00:1a.0: reg 0x10: [mem 0xf7c18000-0xf7c183ff]
[    1.545323] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.545399] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    1.545454] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    1.545485] pci 0000:00:1b.0: reg 0x10: [mem 0xf7c10000-0xf7c13fff 64bit]
[    1.545552] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.545612] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    1.545672] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    1.545710] pci 0000:00:1d.0: reg 0x10: [mem 0xf7c17000-0xf7c173ff]
[    1.545802] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.545879] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    1.545935] pci 0000:00:1f.0: [8086:1e57] type 00 class 0x060100
[    1.546150] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    1.546183] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    1.546192] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    1.546202] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
[    1.546213] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
[    1.546223] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    1.546234] pci 0000:00:1f.2: reg 0x24: [mem 0xf7c16000-0xf7c167ff]
[    1.546272] pci 0000:00:1f.2: PME# supported from D3hot
[    1.546374] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    1.546397] pci 0000:00:1f.3: reg 0x10: [mem 0xf7c15000-0xf7c150ff 64bit]
[    1.546423] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    1.553924] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.553998] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.554066] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.554133] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.554202] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.554269] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.554341] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.554409] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    1.554595] ACPI: Enabled 4 GPEs in block 00 to 3F
[    1.554650] ACPI : EC: GPE = 0x1e, I/O: command/status = 0x66, data = 0x62
[    1.554779] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.554782] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    1.554784] vgaarb: loaded
[    1.554786] vgaarb: bridge control possible 0000:00:02.0
[    1.555143] SCSI subsystem initialized
[    1.555203] libata version 3.00 loaded.
[    1.555235] ACPI: bus type USB registered
[    1.555258] usbcore: registered new interface driver usbfs
[    1.555270] usbcore: registered new interface driver hub
[    1.555295] usbcore: registered new device driver usb
[    1.555569] PCI: Using ACPI for IRQ routing
[    1.557690] PCI: pci_cache_line_size set to 64 bytes
[    1.557740] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    1.557742] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    1.557744] e820: reserve RAM buffer [mem 0xd9203000-0xdbffffff]
[    1.557747] e820: reserve RAM buffer [mem 0xda700000-0xdbffffff]
[    1.557750] e820: reserve RAM buffer [mem 0xdad55000-0xdbffffff]
[    1.557752] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    1.557754] e820: reserve RAM buffer [mem 0x11f600000-0x11fffffff]
[    1.557905] NetLabel: Initializing
[    1.557907] NetLabel:  domain hash size = 128
[    1.557908] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.557926] NetLabel:  unlabeled traffic allowed by default
[    1.558021] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.558028] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.560062] clocksource: Switched to clocksource hpet
[    1.568401] AppArmor: AppArmor Filesystem Enabled
[    1.568489] pnp: PnP ACPI init
[    1.568609] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    1.568614] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.568717] system 00:01: [io  0x0680-0x069f] has been reserved
[    1.568720] system 00:01: [io  0x1000-0x100f] has been reserved
[    1.568723] system 00:01: [io  0xffff] has been reserved
[    1.568725] system 00:01: [io  0xffff] has been reserved
[    1.568728] system 00:01: [io  0x0400-0x0453] could not be reserved
[    1.568730] system 00:01: [io  0x0458-0x047f] has been reserved
[    1.568733] system 00:01: [io  0x0500-0x057f] has been reserved
[    1.568735] system 00:01: [io  0x164e-0x164f] has been reserved
[    1.568739] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.568774] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.568835] system 00:03: [io  0x0454-0x0457] has been reserved
[    1.568840] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    1.568901] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    1.568905] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.569189] system 00:05: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.569192] system 00:05: [mem 0xfed10000-0xfed17fff] has been reserved
[    1.569194] system 00:05: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.569197] system 00:05: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.569199] system 00:05: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.569202] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.569205] system 00:05: [mem 0xfed90000-0xfed93fff] could not be reserved
[    1.569207] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.569210] system 00:05: [mem 0xff000000-0xffffffff] has been reserved
[    1.569216] system 00:05: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.569219] system 00:05: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    1.569223] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.576317] system 00:06: [mem 0x20000000-0x201fffff] has been reserved
[    1.576321] system 00:06: [mem 0x40004000-0x40004fff] has been reserved
[    1.576324] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.576379] pnp: PnP ACPI: found 7 devices
[    1.583658] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    1.583673] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    1.583676] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    1.583679] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    1.583681] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff window]
[    1.583684] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff window]
[    1.583686] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff window]
[    1.583688] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff window]
[    1.583691] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff window]
[    1.583693] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff window]
[    1.583696] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff window]
[    1.583698] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff window]
[    1.583700] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff window]
[    1.583703] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff window]
[    1.583705] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff window]
[    1.583708] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff window]
[    1.583710] pci_bus 0000:00: resource 19 [mem 0x000f0000-0x000fffff window]
[    1.583712] pci_bus 0000:00: resource 20 [mem 0xdfa00000-0xfeafffff window]
[    1.583753] NET: Registered protocol family 2
[    1.583953] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    1.584060] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    1.584145] TCP: Hash tables configured (established 32768 bind 32768)
[    1.584176] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    1.584198] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    1.584260] NET: Registered protocol family 1
[    1.584279] pci 0000:00:02.0: Video device with shadowed ROM
[    1.584291] pci 0000:00:14.0: enabling device (0000 -> 0002)
[    1.584558] pci 0000:00:1a.0: enabling device (0000 -> 0002)
[    1.604242] PCI: CLS 64 bytes, default 64
[    1.604309] Trying to unpack rootfs image as initramfs...
[    2.078916] Freeing initrd memory: 20124K (ffff8800358a2000 - ffff880036c49000)
[    2.078961] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.078965] software IO TLB [mem 0xd3842000-0xd7842000] (64MB) mapped at [ffff8800d3842000-ffff8800d7841fff]
[    2.079059] RAPL PMU detected, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    2.079061] hw unit of domain pp0-core 2^-16 Joules
[    2.079063] hw unit of domain package 2^-16 Joules
[    2.079064] hw unit of domain pp1-gpu 2^-16 Joules
[    2.079216] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x13
[    2.079229] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x13
[    2.079240] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x13
[    2.079256] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x13
[    2.079328] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.079449] Scanning for low memory corruption every 60 seconds
[    2.079866] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    2.079885] Initialise system trusted keyring
[    2.079916] audit: initializing netlink subsys (disabled)
[    2.079934] audit: type=2000 audit(1437637448.936:1): initialized
[    2.080474] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.082477] zpool: loaded
[    2.082482] zbud: loaded
[    2.082746] VFS: Disk quotas dquot_6.6.0
[    2.082791] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.083447] fuse init (API version 7.23)
[    2.083640] Key type big_key registered
[    2.084099] Key type asymmetric registered
[    2.084102] Asymmetric key parser 'x509' registered
[    2.084120] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
[    2.084168] io scheduler noop registered
[    2.084172] io scheduler deadline registered (default)
[    2.084212] io scheduler cfq registered
[    2.084340] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.084349] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.084396] efifb: probing for efifb
[    2.084414] efifb: framebuffer at 0xe0000000, mapped to 0xffffc90000800000, using 8128k, total 8128k
[    2.084416] efifb: mode is 1920x1080x32, linelength=7680, pages=1
[    2.084417] efifb: scrolling: redraw
[    2.084420] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    2.092600] Console: switching to colour frame buffer device 240x67
[    2.100626] fb0: EFI VGA frame buffer device
[    2.100640] intel_idle: MWAIT substates: 0x21120
[    2.100642] intel_idle: v0.4 model 0x3A
[    2.100643] intel_idle: lapic_timer_reliable_states 0xffffffff
[    2.108386] ACPI: AC Adapter [AC0] (off-line)
[    2.108465] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C0D:00/input/input0
[    2.108487] ACPI: Lid Switch [LID0]
[    2.108549] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.108553] ACPI: Power Button [PWRF]
[    2.156423] [Firmware Bug]: Invalid critical threshold (86)
[    2.180444] thermal LNXTHERM:00: registered as thermal_zone0
[    2.180447] ACPI: Thermal Zone [TZ0] (-268 C)
[    2.180507] GHES: HEST is not enabled!
[    2.180648] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    2.183307] Linux agpgart interface v0.103
[    2.186482] brd: module loaded
[    2.187598] loop: module loaded
[    2.187876] libphy: Fixed MDIO Bus: probed
[    2.187880] tun: Universal TUN/TAP device driver, 1.6
[    2.187881] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.187943] PPP generic driver version 2.4.2
[    2.188187] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.188195] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    2.188304] xhci_hcd 0000:00:14.0: hcc params 0x20007181 hci version 0x100 quirks 0x0000b930
[    2.188314] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    2.188447] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.188449] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.188452] usb usb1: Product: xHCI Host Controller
[    2.188454] usb usb1: Manufacturer: Linux 4.2.0-040200rc3-generic xhci-hcd
[    2.188456] usb usb1: SerialNumber: 0000:00:14.0
[    2.188621] hub 1-0:1.0: USB hub found
[    2.188637] hub 1-0:1.0: 4 ports detected
[    2.189084] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.189088] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    2.189136] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    2.189138] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.189140] usb usb2: Product: xHCI Host Controller
[    2.189143] usb usb2: Manufacturer: Linux 4.2.0-040200rc3-generic xhci-hcd
[    2.189145] usb usb2: SerialNumber: 0000:00:14.0
[    2.189292] hub 2-0:1.0: USB hub found
[    2.189305] hub 2-0:1.0: 4 ports detected
[    2.189745] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.189752] ehci-pci: EHCI PCI platform driver
[    2.189896] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    2.189902] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    2.189919] ehci-pci 0000:00:1a.0: debug port 2
[    2.193840] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    2.193860] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7c18000
[    2.204380] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.204441] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.204444] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.204446] usb usb3: Product: EHCI Host Controller
[    2.204448] usb usb3: Manufacturer: Linux 4.2.0-040200rc3-generic ehci_hcd
[    2.204450] usb usb3: SerialNumber: 0000:00:1a.0
[    2.204639] hub 3-0:1.0: USB hub found
[    2.204646] hub 3-0:1.0: 2 ports detected
[    2.204943] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    2.204950] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    2.204967] ehci-pci 0000:00:1d.0: debug port 2
[    2.205104] ACPI Error: [\SB__.IADP] Namespace lookup failure, AE_NOT_FOUND (20150619/psargs-359)
[    2.205114] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_._Q41] (Node ffff88011a8b5ca8), AE_NOT_FOUND (20150619/psparse-536)
[    2.208892] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    2.208916] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7c17000
[    2.220426] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.220492] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    2.220495] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.220497] usb usb4: Product: EHCI Host Controller
[    2.220499] usb usb4: Manufacturer: Linux 4.2.0-040200rc3-generic ehci_hcd
[    2.220501] usb usb4: SerialNumber: 0000:00:1d.0
[    2.220761] hub 4-0:1.0: USB hub found
[    2.220775] hub 4-0:1.0: 2 ports detected
[    2.221015] ehci-platform: EHCI generic platform driver
[    2.221033] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.221043] ohci-pci: OHCI PCI platform driver
[    2.221084] ohci-platform: OHCI generic platform driver
[    2.221103] uhci_hcd: USB Universal Host Controller Interface driver
[    2.221179] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    2.775563] i8042: Can't read CTR while initializing i8042
[    2.775609] i8042: probe of i8042 failed with error -5
[    2.775853] mousedev: PS/2 mouse device common for all mice
[    2.776175] rtc_cmos 00:02: RTC can wake from S4
[    2.776356] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    2.776394] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    2.776407] i2c /dev entries driver
[    2.776509] device-mapper: uevent: version 1.0.3
[    2.776569] ACPI: Battery Slot [BAT0] (battery present)
[    2.776640] device-mapper: ioctl: 4.32.0-ioctl (2015-6-26) initialised: dm-devel@redhat.com
[    2.776659] usb 1-2: new high-speed USB device number 2 using xhci_hcd
[    2.776666] Intel P-state driver initializing.
[    2.777026] ledtrig-cpu: registered to indicate activity on CPUs
[    2.777045] EFI Variables Facility v0.08 2004-May-17
[    2.806538] PCCT header not found.
[    2.806750] NET: Registered protocol family 10
[    2.806942] NET: Registered protocol family 17
[    2.806954] Key type dns_resolver registered
[    2.807294] Loading compiled-in X.509 certificates
[    2.808130] Loaded X.509 cert 'Build time autogenerated kernel key: a0803efc5ffaaf6f3aa6be1346cdc58484753f31'
[    2.808145] registered taskstats version 1
[    2.808164] zswap: loading zswap
[    2.808166] zswap: using zbud pool
[    2.808170] zswap: using lzo compressor
[    2.810538] Key type trusted registered
[    2.815128] Key type encrypted registered
[    2.815137] AppArmor: AppArmor sha1 policy hashing enabled
[    2.815142] ima: No TPM chip found, activating TPM-bypass!
[    2.815162] evm: HMAC attrs: 0x1
[    2.815387]   Magic number: 7:160:724
[    2.815398] block loop4: hash matches
[    2.815486] rtc_cmos 00:02: setting system clock to 2015-07-23 07:44:10 UTC (1437637450)
[    2.815550] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.815551] EDD information not available.
[    2.815638] PM: Hibernation image not present or could not be loaded.
[    2.815934] Freeing unused kernel memory: 1456K (ffffffff81d36000 - ffffffff81ea2000)
[    2.815936] Write protecting the kernel read-only data: 12288k
[    2.816161] Freeing unused kernel memory: 320K (ffff8800017b0000 - ffff880001800000)
[    2.816246] Freeing unused kernel memory: 256K (ffff880001bc0000 - ffff880001c00000)
[    2.825653] random: systemd-udevd urandom read with 5 bits of entropy available
[    2.836688] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    2.849223] ahci 0000:00:1f.2: version 3.0
[    2.849445] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1 impl SATA mode
[    2.849450] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    2.850090] scsi host0: ahci
[    2.850219] scsi host1: ahci
[    2.850334] scsi host2: ahci
[    2.850445] scsi host3: ahci
[    2.850555] scsi host4: ahci
[    2.850664] scsi host5: ahci
[    2.850710] ata1: SATA max UDMA/133 abar m2048@0xf7c16000 port 0xf7c16100 irq 27
[    2.850712] ata2: DUMMY
[    2.850713] ata3: DUMMY
[    2.850714] ata4: DUMMY
[    2.850715] ata5: DUMMY
[    2.850715] ata6: DUMMY
[    2.910020] usb 1-2: New USB device found, idVendor=04e8, idProduct=6864
[    2.910023] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.910025] usb 1-2: Product: SAMSUNG_Android
[    2.910026] usb 1-2: Manufacturer: SAMSUNG
[    2.910027] usb 1-2: SerialNumber: 1ba3459d
[    2.969212] usb 3-1: New USB device found, idVendor=8087, idProduct=0024
[    2.969215] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.969627] hub 3-1:1.0: USB hub found
[    2.969828] hub 3-1:1.0: 6 ports detected
[    2.984789] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    3.076793] tsc: Refined TSC clocksource calibration: 1696.151 MHz
[    3.076798] usb 1-3: new high-speed USB device number 3 using xhci_hcd
[    3.076813] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1872f32b332, max_idle_ns: 440795207539 ns
[    3.117409] usb 4-1: New USB device found, idVendor=8087, idProduct=0024
[    3.117411] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.117749] hub 4-1:1.0: USB hub found
[    3.117866] hub 4-1:1.0: 8 ports detected
[    3.168897] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    3.169213] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20150619/psargs-359)
[    3.169218] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff88011a8b64b0), AE_NOT_FOUND (20150619/psparse-536)
[    3.169363] ata1.00: ATA-9: C400-MTFDDAT064MAM, 07MH, max UDMA/100
[    3.169365] ata1.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.169812] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20150619/psargs-359)
[    3.169817] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff88011a8b64b0), AE_NOT_FOUND (20150619/psparse-536)
[    3.169967] ata1.00: configured for UDMA/100
[    3.170188] scsi 0:0:0:0: Direct-Access     ATA      C400-MTFDDAT064M 07MH PQ: 0 ANSI: 5
[    3.170563] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
[    3.170620] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.170702] sd 0:0:0:0: [sda] Write Protect is off
[    3.170706] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.170740] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.172119]  sda: sda1 sda2 sda3
[    3.172486] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.199700] EXT4-fs (sda2): INFO: recovery required on readonly filesystem
[    3.199704] EXT4-fs (sda2): write access will be enabled during recovery
[    3.207087] usb 1-3: New USB device found, idVendor=1286, idProduct=2043
[    3.207090] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.207092] usb 1-3: Product: Marvell Wireless Device
[    3.207093] usb 1-3: Manufacturer: Marvell
[    3.207094] usb 1-3: SerialNumber: 0000000000000000
[    3.240855] usb 3-1.1: new high-speed USB device number 3 using ehci-pci
[    3.349461] usb 3-1.1: New USB device found, idVendor=045e, idProduct=0795
[    3.349472] usb 3-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.349492] usb 3-1.1: Product: Rear LifeCam
[    3.349494] usb 3-1.1: Manufacturer: Microsoft
[    3.388931] usb 4-1.5: new full-speed USB device number 3 using ehci-pci
[    3.389884] EXT4-fs (sda2): orphan cleanup on readonly fs
[    3.390191] EXT4-fs (sda2): 26 orphan inodes deleted
[    3.390193] EXT4-fs (sda2): recovery complete
[    3.414914] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    3.483646] usb 4-1.5: New USB device found, idVendor=045e, idProduct=07a9
[    3.483650] usb 4-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.483651] usb 4-1.5: Product: SAM
[    3.483653] usb 4-1.5: Manufacturer: MICROSOFT
[    3.483654] usb 4-1.5: SerialNumber: 0.1.0000
[    3.500699] systemd[1]: Inserted module 'autofs4'
[    3.557001] usb 4-1.6: new full-speed USB device number 4 using ehci-pci
[    3.557803] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT -GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID -ELFUTILS +KMOD -IDN)
[    3.557939] systemd[1]: Detected architecture x86-64.
[    3.558799] systemd[1]: Set hostname to <touco>.
[    3.625108] random: nonblocking pool is initialized
[    3.642087] systemd[1]: [/lib/systemd/system/mpd.service:17] Unknown lvalue 'ControlGroup' in section 'Service'
[    3.642096] systemd[1]: [/lib/systemd/system/mpd.service:20] Unknown lvalue 'ControlGroupAttribute' in section 'Service'
[    3.657755] usb 4-1.6: New USB device found, idVendor=03eb, idProduct=8209
[    3.657758] usb 4-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.657760] usb 4-1.6: Product: Atmel maXTouch Digitizer
[    3.657761] usb 4-1.6: Manufacturer: Atmel
[    3.660183] systemd[1]: Cannot add dependency job for unit gssproxy.service, ignoring: Unit gssproxy.service failed to load: No such file or directory.
[    3.660189] systemd[1]: Cannot add dependency job for unit nfs-blkmap.service, ignoring: Unit nfs-blkmap.service failed to load: No such file or directory.
[    3.660891] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    3.660907] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    3.660958] systemd[1]: Created slice Root Slice.
[    3.660966] systemd[1]: Starting Root Slice.
[    3.660994] systemd[1]: Listening on fsck to fsckd communication Socket.
[    3.661002] systemd[1]: Starting fsck to fsckd communication Socket.
[    3.661042] systemd[1]: Listening on udev Control Socket.
[    3.661050] systemd[1]: Starting udev Control Socket.
[    3.661083] systemd[1]: Listening on Delayed Shutdown Socket.
[    3.661091] systemd[1]: Starting Delayed Shutdown Socket.
[    3.661144] systemd[1]: Listening on Journal Socket.
[    3.661156] systemd[1]: Starting Journal Socket.
[    3.661190] systemd[1]: Listening on Journal Socket (/dev/log).
[    3.661214] systemd[1]: Starting Journal Socket (/dev/log).
[    3.661320] systemd[1]: Created slice System Slice.
[    3.661334] systemd[1]: Starting System Slice.
[    3.661780] systemd[1]: Starting Nameserver information manager...
[    3.661825] systemd[1]: Started Kernel Module supporting RPCSEC_GSS.
[    3.662370] systemd[1]: Mounting POSIX Message Queue File System...
[    3.663327] systemd[1]: Starting Setup Virtual Console...
[    3.664010] systemd[1]: Mounting Huge Pages File System...
[    3.667577] systemd[1]: Starting Load Kernel Modules...
[    3.668295] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    3.668462] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[    3.668487] systemd[1]: Starting system-systemd\x2dfsck.slice.
[    3.668696] systemd[1]: Created slice system-getty.slice.
[    3.668717] systemd[1]: Starting system-getty.slice.
[    3.669598] systemd[1]: Started Read required files in advance.
[    3.669806] systemd[1]: Starting Read required files in advance...
[    3.670157] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    3.670176] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    3.672905] systemd[1]: Started Set Up Additional Binary Formats.
[    3.672938] systemd[1]: Reached target Encrypted Volumes.
[    3.672947] systemd[1]: Starting Encrypted Volumes.
[    3.673498] systemd[1]: Mounting RPC Pipe File System...
[    3.673628] systemd[1]: Created slice User and Session Slice.
[    3.673649] systemd[1]: Starting User and Session Slice.
[    3.673715] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    3.673730] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    3.674617] systemd[1]: Starting Uncomplicated firewall...
[    3.674658] systemd[1]: Reached target Slices.
[    3.674679] systemd[1]: Starting Slices.
[    3.675763] systemd[1]: Starting Increase datagram queue length...
[    3.677087] systemd[1]: Started Braille Device Support.
[    3.677173] systemd[1]: Starting Braille Device Support...
[    3.677304] systemd[1]: Listening on Journal Audit Socket.
[    3.677325] systemd[1]: Starting Journal Audit Socket.
[    3.677380] systemd[1]: Listening on udev Kernel Socket.
[    3.677391] systemd[1]: Starting udev Kernel Socket.
[    3.680760] systemd[1]: Starting udev Coldplug all Devices...
[    3.681691] systemd[1]: Mounting Debug File System...
[    3.682855] systemd[1]: Mounted POSIX Message Queue File System.
[    3.682899] systemd[1]: Mounted Huge Pages File System.
[    3.684241] systemd[1]: Started Setup Virtual Console.
[    3.684702] systemd[1]: Started Create list of required static device nodes for the current kernel.
[    3.684908] systemd[1]: Started Uncomplicated firewall.
[    3.685126] systemd[1]: Started Increase datagram queue length.
[    3.686693] systemd[1]: Mounted Debug File System.
[    3.686927] lp: driver loaded but no devices found
[    3.688020] systemd[1]: Started Nameserver information manager.
[    3.691223] ppdev: user-space parallel port driver
[    3.697152] systemd[1]: Started Load Kernel Modules.
[    3.701755] RPC: Registered named UNIX socket transport module.
[    3.701759] RPC: Registered udp transport module.
[    3.701760] RPC: Registered tcp transport module.
[    3.701762] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.703018] systemd[1]: Mounted RPC Pipe File System.
[    3.712729] systemd[1]: Started udev Coldplug all Devices.
[    3.719466] systemd[1]: Starting udev Wait for Complete Device Initialization...
[    3.719536] systemd[1]: Mounted Configuration File System.
[    3.720523] systemd[1]: Mounting FUSE Control File System...
[    3.721482] systemd[1]: Starting Apply Kernel Variables...
[    3.721577] systemd[1]: Listening on Syslog Socket.
[    3.721613] systemd[1]: Starting Syslog Socket.
[    3.723215] systemd[1]: Starting Journal Service...
[    3.724737] systemd[1]: Starting Create Static Device Nodes in /dev...
[    3.725725] systemd[1]: Mounted FUSE Control File System.
[    3.727067] systemd[1]: Started Apply Kernel Variables.
[    3.733047] systemd[1]: Started Create Static Device Nodes in /dev.
[    3.733085] usb 4-1.7: new high-speed USB device number 5 using ehci-pci
[    3.733862] systemd[1]: Starting udev Kernel Device Manager...
[    3.756469] systemd[1]: Started Journal Service.
[    3.841785] usb 4-1.7: New USB device found, idVendor=045e, idProduct=0794
[    3.841791] usb 4-1.7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.841793] usb 4-1.7: Product: Front LifeCam
[    3.841796] usb 4-1.7: Manufacturer: Microsoft
[    3.870074] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042F conflicts with OpRegion 0x0000000000000400-0x000000000000047F (\PMIO) (20150619/utaddress-254)
[    3.870084] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.870088] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054F conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20150619/utaddress-254)
[    3.870094] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.870095] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053F conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20150619/utaddress-254)
[    3.870101] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.870102] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052F conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20150619/utaddress-254)
[    3.870107] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.870109] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    3.872194] hidraw: raw HID events driver (C) Jiri Kosina
[    3.897766] usbcore: registered new interface driver usbhid
[    3.897769] usbhid: USB HID core driver
[    3.905136] [drm] Initialized drm 1.1.0 20060810
[    3.924438] media: Linux media interface: v0.10
[    3.938971] usbcore: registered new interface driver cdc_ether
[    3.942353] AVX version of gcm_enc/dec engaged.
[    3.942357] AES CTR mode by8 optimization enabled
[    3.947452] rndis_host 1-2:1.0 usb0: register 'rndis_host' at usb-0000:00:14.0-2, RNDIS device, c6:fe:2c:2c:43:34
[    3.947499] usbcore: registered new interface driver rndis_host
[    3.953326] Linux video capture interface: v2.00
[    3.993573] [drm] Memory usable by graphics device = 2048M
[    3.993577] checking generic (e0000000 7f0000) vs hw (e0000000 10000000)
[    3.993579] fb: switching to inteldrmfb from EFI VGA
[    3.993598] Console: switching to colour dummy device 80x25
[    3.993684] [drm] Replacing VGA console driver
[    3.999617] uvcvideo: Found UVC 1.00 device Rear LifeCam (045e:0795)
[    4.008453] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.008457] [drm] Driver supports precise vblank timestamp query.
[    4.008577] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.037895] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    4.038104] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    4.038171] input: MICROSOFT SAM as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.5/4-1.5:1.1/0003:045E:07A9.0002/input/input3
[    4.038194] [drm] Initialized i915 1.6.0 20150522 for 0000:00:02.0 on minor 0
[    4.041050] input: Atmel Atmel maXTouch Digitizer as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.6/4-1.6:1.0/0003:03EB:8209.0004/input/input4
[    4.048524] fbcon: inteldrmfb (fb0) is primary device
[    4.048533] intel_rapl: Found RAPL domain package
[    4.048534] intel_rapl: Found RAPL domain core
[    4.048535] intel_rapl: Found RAPL domain uncore
[    4.054336] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    4.069477] input: Rear LifeCam as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.1/3-1.1:1.0/input/input5
[    4.079805] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC280: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[    4.079807] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    4.079809] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[    4.079810] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[    4.079811] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[    4.079814] snd_hda_codec_realtek hdaudioC0D0:      Mic=0x1a
[    4.079816] snd_hda_codec_realtek hdaudioC0D0:      Internal Mic=0x12
[    4.086207] clocksource: Switched to clocksource tsc
[    4.093619] hid-generic 0003:045E:07A9.0002: input,hidraw0: USB HID v1.11 Keyboard [MICROSOFT SAM] on usb-0000:00:1d.0-1.5/input1
[    4.093899] uvcvideo: Found UVC 1.00 device Front LifeCam (045e:0794)
[    4.094167] hid-multitouch 0003:03EB:8209.0004: input,hidraw1: USB HID v1.11 Device [Atmel Atmel maXTouch Digitizer] on usb-0000:00:1d.0-1.6/input0
[    4.096111] input: MICROSOFT SAM as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.5/4-1.5:1.2/0003:045E:07A9.0003/input/input8
[    4.099575] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    4.153707] hid-generic 0003:045E:07A9.0003: input,hiddev0,hidraw2: USB HID v1.11 Keyboard [MICROSOFT SAM] on usb-0000:00:1d.0-1.5/input2
[    4.153708] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    4.154019] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    4.156156] hid-generic 0003:03EB:8209.0005: hiddev0,hidraw3: USB HID v1.11 Device [Atmel Atmel maXTouch Digitizer] on usb-0000:00:1d.0-1.6/input1
[    4.159644] input: Front LifeCam as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.7/4-1.7:1.0/input/input10
[    4.159704] usbcore: registered new interface driver uvcvideo
[    4.159704] USB Video Class driver (1.1.1)
[    4.697463] Console: switching to colour frame buffer device 240x67
[    4.703201] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    4.703204] i915 0000:00:02.0: registered panic notifier
[    4.729181] Adding 4075516k swap on /dev/sda3.  Priority:-1 extents:1 across:4075516k SSFS
[    4.939906] cfg80211: Calling CRDA to update world regulatory domain
[    4.945582] cfg80211: World regulatory domain updated:
[    4.945586] cfg80211:  DFS Master region: unset
[    4.945587] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    4.945590] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    4.945592] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    4.945594] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    4.945597] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[    4.945600] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[    4.945602] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    4.945604] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    4.945606] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    4.947889] mwifiex: rx work enabled, cpus 4
[    4.948045] usbcore: registered new interface driver mwifiex_usb
[    4.952893] usb 1-3: start to download FW...
[    4.976638] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
[    4.991117] systemd-journald[263]: Received request to flush runtime journal from PID 1
[    5.059122] audit: type=1400 audit(1437637452.738:2): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm-guest-session" pid=488 comm="apparmor_parser"
[    5.059138] audit: type=1400 audit(1437637452.738:3): apparmor="STATUS" operation="profile_load" name="chromium" pid=488 comm="apparmor_parser"
[    5.061143] audit: type=1400 audit(1437637452.738:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-freerdp/freerdp-session-wrapper" pid=488 comm="apparmor_parser"
[    5.061149] audit: type=1400 audit(1437637452.738:5): apparmor="STATUS" operation="profile_load" name="chromium" pid=488 comm="apparmor_parser"
[    5.063179] audit: type=1400 audit(1437637452.742:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-uccsconfigure/uccsconfigure-session-wrapper" pid=488 comm="apparmor_parser"
[    5.063185] audit: type=1400 audit(1437637452.742:7): apparmor="STATUS" operation="profile_load" name="chromium" pid=488 comm="apparmor_parser"
[    5.064930] audit: type=1400 audit(1437637452.742:8): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=488 comm="apparmor_parser"
[    5.064936] audit: type=1400 audit(1437637452.742:9): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=488 comm="apparmor_parser"
[    5.064940] audit: type=1400 audit(1437637452.742:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=488 comm="apparmor_parser"
[    6.019719] usb 1-3: info: FW download over, size 551720 bytes
[    6.019732] usb 1-3: info: mwifiex_fw_dpc: unregister device
[    6.217013] usb 1-3: USB disconnect, device number 3
[    6.217063] mwifiex_usb: mwifiex_usb_disconnect: card or card->adapter is NULL
[    6.902642] usb 1-3: new high-speed USB device number 4 using xhci_hcd
[    7.031844] usb 1-3: New USB device found, idVendor=1286, idProduct=2044
[    7.031847] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.031849] usb 1-3: Product: Bluetooth and Wireless LAN Composite Device
[    7.031851] usb 1-3: Manufacturer: Marvell
[    7.031852] usb 1-3: SerialNumber: 6045BDF646B4
[    7.032068] usb 1-3: ep 0x4 - rounding interval to 128 microframes, ep desc says 255 microframes
[    7.034866] mwifiex: rx work enabled, cpus 4
[    7.035555] usb 1-3: WLAN FW is active
[    7.048006] Bluetooth: Core ver 2.20
[    7.048053] NET: Registered protocol family 31
[    7.048055] Bluetooth: HCI device and connection manager initialized
[    7.048060] Bluetooth: HCI socket layer initialized
[    7.048063] Bluetooth: L2CAP socket layer initialized
[    7.048071] Bluetooth: SCO socket layer initialized
[    7.054530] usbcore: registered new interface driver btusb
[    7.069923] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    7.069927] Bluetooth: BNEP filters: protocol multicast
[    7.069932] Bluetooth: BNEP socket layer initialized
[    7.277276] usb 1-3: info: MWIFIEX VERSION: mwifiex 1.0 (14.68.29.p38) 
[    7.277280] usb 1-3: driver_version = mwifiex 1.0 (14.68.29.p38) 
[    7.396041] Bluetooth: RFCOMM TTY layer initialized
[    7.396050] Bluetooth: RFCOMM socket layer initialized
[    7.396055] Bluetooth: RFCOMM ver 1.11
[   33.220379] do_trap: 66 callbacks suppressed
[   33.220384] traps: pngparse0:sink[2047] trap int3 ip:7f2e20eb4d00 sp:7f2de3ffe1d0 error:0
[  186.460767] usb 1-2: USB disconnect, device number 2
[  186.460975] rndis_host 1-2:1.0 usb0: unregister 'rndis_host' usb-0000:00:14.0-2, RNDIS device
[  210.067501] usb 1-3: info: trying to associate to 'AndroidAP' bssid b4:3a:28:26:e5:21
[  210.090548] usb 1-3: info: associated to bssid b4:3a:28:26:e5:21 successfully
[  210.091554] mwifiex: info: WMM AC_BE: ACI=0, ACM=0, Aifsn=3, EcwMin=4, EcwMax=10, TxopLimit=0
[  210.091560] mwifiex: info: WMM AC_BK: ACI=1, ACM=0, Aifsn=7, EcwMin=4, EcwMax=10, TxopLimit=0
[  210.091563] mwifiex: info: WMM AC_VI: ACI=2, ACM=0, Aifsn=2, EcwMin=3, EcwMax=4, TxopLimit=94
[  210.091566] mwifiex: info: WMM AC_VO: ACI=3, ACM=0, Aifsn=2, EcwMin=2, EcwMax=3, TxopLimit=47
[  210.425760] usb 1-3: Rx of mgmt packet failed
[  210.553558] usb 1-3: Rx of mgmt packet failed
--8<---------------cut here---------------end--------------->8---


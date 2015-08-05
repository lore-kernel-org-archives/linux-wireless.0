Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:40652 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbbHEGcN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 02:32:13 -0400
From: Julien Cubizolles <j.cubizolles@free.fr>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: firmware in a bad state (module mwifiex)
In-Reply-To: <0e2dc4e2bd9f4486979cedb4c47e60f2@SC-EXCH04.marvell.com>
	(Amitkumar Karwar's message of "Mon, 27 Jul 2015 07:13:00 +0000")
Date: Wed, 05 Aug 2015 08:30:54 +0200
Message-ID: <87zj26z1pd.fsf_-_@free.fr> (sfid-20150805_083222_378138_1A740355)
References: <871tfzast5.fsf@free.fr>
	<0e2dc4e2bd9f4486979cedb4c47e60f2@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain


I'm running kernel 4.2.0-rc3 with the following patches to the mwifiex
driver, thanks to your advice.

> Do you have following USB chipset specific fixes included?
> http://www.spinics.net/lists/linux-wireless/msg129129.html
> http://www.spinics.net/lists/netdev/msg334367.html

I've recently noticed that the connection is lost (and the driver too
only rebooting makes the card usable again) when I connect to certain
websites (github for instance)

I've set debugging up with the following command, and attached the output
from dmesg.

> "echo 0xffffffff > /sys/kernel/debug/mwifiex/mlan0/debug_mask"

Thanks for your help.

Regards,

Julien.


--=-=-=
Content-Type: text/plain
Content-Disposition: attachment; filename=dmesg
Content-Description: output from dmesg

<6>[    0.000000] Initializing cgroup subsys cpuset
<6>[    0.000000] Initializing cgroup subsys cpu
<6>[    0.000000] Initializing cgroup subsys cpuacct
<5>[    0.000000] Linux version 4.2.0-rc3 (root@touco) (gcc version 4.9.2 (Ubuntu 4.9.2-10ubuntu13) ) #3 SMP Mon Jul 27 15:27:49 CEST 2015
<6>[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.2.0-rc3 root=UUID=919f00b8-5010-46e1-b2f9-c129e17d5312 ro quiet splash vt.handoff=7
<6>[    0.000000] KERNEL supported cpus:
<6>[    0.000000]   Intel GenuineIntel
<6>[    0.000000]   AMD AuthenticAMD
<6>[    0.000000]   Centaur CentaurHauls
<6>[    0.000000] x86/fpu: xstate_offset[2]: 0240, xstate_sizes[2]: 0100
<6>[    0.000000] x86/fpu: Supporting XSAVE feature 0x01: 'x87 floating point registers'
<6>[    0.000000] x86/fpu: Supporting XSAVE feature 0x02: 'SSE registers'
<6>[    0.000000] x86/fpu: Supporting XSAVE feature 0x04: 'AVX registers'
<6>[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 0x340 bytes, using 'standard' format.
<6>[    0.000000] x86/fpu: Using 'eager' FPU context switches.
<6>[    0.000000] e820: BIOS-provided physical RAM map:
<6>[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dfff] usable
<6>[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
<6>[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000d9202fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000d9203000-0x00000000d9671fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000d9672000-0x00000000d9681fff] ACPI data
<6>[    0.000000] BIOS-e820: [mem 0x00000000d9682000-0x00000000da24ffff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000da250000-0x00000000da66cfff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000da66d000-0x00000000da6fefff] type 20
<6>[    0.000000] BIOS-e820: [mem 0x00000000da6ff000-0x00000000da6fffff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000da700000-0x00000000da742fff] ACPI NVS
<6>[    0.000000] BIOS-e820: [mem 0x00000000da743000-0x00000000dad54fff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000dad55000-0x00000000daff1fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000daff2000-0x00000000daffffff] usable
<6>[    0.000000] BIOS-e820: [mem 0x00000000db800000-0x00000000df9fffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
<6>[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011f5fffff] usable
<6>[    0.000000] NX (Execute Disable) protection: active
<6>[    0.000000] efi: EFI v2.31 by American Megatrends
<6>[    0.000000] efi:  ESRT=0xda5f1618  ACPI=0xd9677000  ACPI 2.0=0xd9677000  SMBIOS=0xda66b198 
<6>[    0.000000] esrt: Reserving ESRT space from 0x00000000da5f1618 to 0x00000000da5f16c8.
<6>[    0.000000] SMBIOS 2.7 present.
<7>[    0.000000] DMI: Microsoft Corporation Surface with Windows 8 Pro/Surface with Windows 8 Pro, BIOS 1.00.0250 01/08/2013
<7>[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
<7>[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
<6>[    0.000000] e820: last_pfn = 0x11f600 max_arch_pfn = 0x400000000
<7>[    0.000000] MTRR default type: uncachable
<7>[    0.000000] MTRR fixed ranges enabled:
<7>[    0.000000]   00000-9FFFF write-back
<7>[    0.000000]   A0000-FFFFF uncachable
<7>[    0.000000] MTRR variable ranges enabled:
<7>[    0.000000]   0 base 000000000 mask F00000000 write-back
<7>[    0.000000]   1 base 100000000 mask FE0000000 write-back
<7>[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
<7>[    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
<7>[    0.000000]   4 base 0DB800000 mask FFF800000 uncachable
<7>[    0.000000]   5 base 11F800000 mask FFF800000 uncachable
<7>[    0.000000]   6 base 11F600000 mask FFFE00000 uncachable
<7>[    0.000000]   7 disabled
<7>[    0.000000]   8 disabled
<7>[    0.000000]   9 disabled
<6>[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
<7>[    0.000000] original variable MTRRs
<7>[    0.000000] reg 0, base: 0GB, range: 4GB, type WB
<7>[    0.000000] reg 1, base: 4GB, range: 512MB, type WB
<7>[    0.000000] reg 2, base: 3584MB, range: 512MB, type UC
<7>[    0.000000] reg 3, base: 3520MB, range: 64MB, type UC
<7>[    0.000000] reg 4, base: 3512MB, range: 8MB, type UC
<7>[    0.000000] reg 5, base: 4600MB, range: 8MB, type UC
<7>[    0.000000] reg 6, base: 4598MB, range: 2MB, type UC
<6>[    0.000000] total RAM covered: 4014M
<6>[    0.000000] Found optimal setting for mtrr clean up
<6>[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 8  	lose cover RAM: 0G
<7>[    0.000000] New variable MTRRs
<7>[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
<7>[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
<7>[    0.000000] reg 2, base: 3GB, range: 512MB, type WB
<7>[    0.000000] reg 3, base: 3512MB, range: 8MB, type UC
<7>[    0.000000] reg 4, base: 3520MB, range: 64MB, type UC
<7>[    0.000000] reg 5, base: 4GB, range: 512MB, type WB
<7>[    0.000000] reg 6, base: 4598MB, range: 2MB, type UC
<7>[    0.000000] reg 7, base: 4600MB, range: 8MB, type UC
<7>[    0.000000] e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
<6>[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
<6>[    0.000000] Scanning 1 areas for low memory corruption
<7>[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
<6>[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
<7>[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
<7>[    0.000000] BRK [0x02002000, 0x02002fff] PGTABLE
<7>[    0.000000] BRK [0x02003000, 0x02003fff] PGTABLE
<7>[    0.000000] BRK [0x02004000, 0x02004fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x11f400000-0x11f5fffff]
<7>[    0.000000]  [mem 0x11f400000-0x11f5fffff] page 2M
<7>[    0.000000] BRK [0x02005000, 0x02005fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0x100000000-0x11f3fffff]
<7>[    0.000000]  [mem 0x100000000-0x11f3fffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0xc0000000-0xd9202fff]
<7>[    0.000000]  [mem 0xc0000000-0xd91fffff] page 2M
<7>[    0.000000]  [mem 0xd9200000-0xd9202fff] page 4k
<7>[    0.000000] BRK [0x02006000, 0x02006fff] PGTABLE
<7>[    0.000000] BRK [0x02007000, 0x02007fff] PGTABLE
<6>[    0.000000] init_memory_mapping: [mem 0xda6ff000-0xda6fffff]
<7>[    0.000000]  [mem 0xda6ff000-0xda6fffff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0xda743000-0xdad54fff]
<7>[    0.000000]  [mem 0xda743000-0xda7fffff] page 4k
<7>[    0.000000]  [mem 0xda800000-0xdabfffff] page 2M
<7>[    0.000000]  [mem 0xdac00000-0xdad54fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0xdaff2000-0xdaffffff]
<7>[    0.000000]  [mem 0xdaff2000-0xdaffffff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
<7>[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
<7>[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
<6>[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
<7>[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
<7>[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
<6>[    0.000000] init_memory_mapping: [mem 0x40005000-0xbfffffff]
<7>[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
<7>[    0.000000]  [mem 0x40200000-0xbfffffff] page 2M
<6>[    0.000000] RAMDISK: [mem 0x35946000-0x36c9afff]
<6>[    0.000000] ACPI: Early table checksum verification disabled
<4>[    0.000000] ACPI: RSDP 0x00000000D9677000 000024 (v02 OEMR  )
<4>[    0.000000] ACPI: XSDT 0x00000000D9677080 00007C (v01 OEMR   O E M R  00000000 OEMR 00010013)
<4>[    0.000000] ACPI: FACP 0x00000000D967FD58 00010C (v05 OEMR   O E M R  00000000 OEMR 00010013)
<4>[    0.000000] ACPI: DSDT 0x00000000D9677188 008BCC (v02 OEMR   O E M R  00000250 INTL 20051117)
<4>[    0.000000] ACPI: FACS 0x00000000DA24E080 000040
<4>[    0.000000] ACPI: APIC 0x00000000D967FE68 000072 (v03 OEMR   O E M R  00000000 OEMR 00010013)
<4>[    0.000000] ACPI: FPDT 0x00000000D967FEE0 000044 (v01 OEMR   O E M R  00000000 OEMR 00010013)
<4>[    0.000000] ACPI: MCFG 0x00000000D967FF28 00003C (v01 OEMR   O E M R  00000000 MSFT 00000097)
<4>[    0.000000] ACPI: MSDM 0x00000000D967FF68 000055 (v03 OEMR   O E M R  00000000 OEMR 00010013)
<4>[    0.000000] ACPI: HPET 0x00000000D967FFC0 000038 (v01 OEMR   O E M R  00000000 AMI. 00000005)
<4>[    0.000000] ACPI: SSDT 0x00000000D967FFF8 000315 (v01 SataRe SataTabl 00001000 INTL 20091112)
<4>[    0.000000] ACPI: SSDT 0x00000000D9680310 0008A2 (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
<4>[    0.000000] ACPI: SSDT 0x00000000D9680BB8 000B22 (v01 PmRef  CpuPm    00003000 INTL 20051117)
<4>[    0.000000] ACPI: DMAR 0x00000000D96816E0 0000B8 (v01 INTEL  SNB      00000001 INTL 00000001)
<4>[    0.000000] ACPI: BGRT 0x00000000D9681798 000038 (v00 OEMR   O E M R  00000000 OEMR 00010013)
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] No NUMA configuration found
<6>[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011f5fffff]
<6>[    0.000000] NODE_DATA(0) allocated [mem 0x11f5f5000-0x11f5f9fff]
<7>[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011ac00000-ffff88011ebfffff] on node 0
<6>[    0.000000] Zone ranges:
<6>[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
<6>[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
<6>[    0.000000]   Normal   [mem 0x0000000100000000-0x000000011f5fffff]
<6>[    0.000000] Movable zone start for each node
<6>[    0.000000] Early memory node ranges
<6>[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009dfff]
<6>[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001fffffff]
<6>[    0.000000]   node   0: [mem 0x0000000020200000-0x0000000040003fff]
<6>[    0.000000]   node   0: [mem 0x0000000040005000-0x00000000d9202fff]
<6>[    0.000000]   node   0: [mem 0x00000000da6ff000-0x00000000da6fffff]
<6>[    0.000000]   node   0: [mem 0x00000000da743000-0x00000000dad54fff]
<6>[    0.000000]   node   0: [mem 0x00000000daff2000-0x00000000daffffff]
<6>[    0.000000]   node   0: [mem 0x0000000100000000-0x000000011f5fffff]
<6>[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000011f5fffff]
<7>[    0.000000] On node 0 totalpages: 1018816
<7>[    0.000000]   DMA zone: 64 pages used for memmap
<7>[    0.000000]   DMA zone: 23 pages reserved
<7>[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
<7>[    0.000000]   DMA32 zone: 13849 pages used for memmap
<7>[    0.000000]   DMA32 zone: 886307 pages, LIFO batch:31
<7>[    0.000000]   Normal zone: 2008 pages used for memmap
<7>[    0.000000]   Normal zone: 128512 pages, LIFO batch:31
<6>[    0.000000] Reserving Intel graphics stolen memory at 0xdba00000-0xdf9fffff
<6>[    0.000000] ACPI: PM-Timer IO Port: 0x408
<7>[    0.000000] ACPI: Local APIC address 0xfee00000
<6>[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
<6>[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
<6>[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
<7>[    0.000000] ACPI: IRQ0 used by override.
<7>[    0.000000] ACPI: IRQ9 used by override.
<6>[    0.000000] Using ACPI (MADT) for SMP configuration information
<6>[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
<6>[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
<6>[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xd9203000-0xd9671fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xd9672000-0xd9681fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xd9682000-0xda24ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xda250000-0xda66cfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xda66d000-0xda6fefff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xda700000-0xda742fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xdad55000-0xdaff1fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xdb000000-0xdb7fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xdb800000-0xdf9fffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
<6>[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
<6>[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
<6>[    0.000000] Booting paravirtualized kernel on bare hardware
<6>[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
<6>[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
<6>[    0.000000] PERCPU: Embedded 33 pages/cpu @ffff88011f200000 s97432 r8192 d29544 u524288
<7>[    0.000000] pcpu-alloc: s97432 r8192 d29544 u524288 alloc=1*2097152
<7>[    0.000000] pcpu-alloc: [0] 0 1 2 3 
<6>[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1002872
<6>[    0.000000] Policy zone: Normal
<5>[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-4.2.0-rc3 root=UUID=919f00b8-5010-46e1-b2f9-c129e17d5312 ro quiet splash vt.handoff=7
<6>[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
<7>[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
<7>[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
<6>[    0.000000] Memory: 3880484K/4075264K available (7779K kernel code, 1309K rwdata, 3800K rodata, 1452K init, 1300K bss, 194780K reserved, 0K cma-reserved)
<6>[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
<6>[    0.000000] Hierarchical RCU implementation.
<6>[    0.000000] 	Build-time adjustment of leaf fanout to 64.
<6>[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
<6>[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=4
<6>[    0.000000] NR_IRQS:16640 nr_irqs:456 16
<6>[    0.000000] 	Offload RCU callbacks from all CPUs
<6>[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
<6>[    0.000000] Console: colour dummy device 80x25
<6>[    0.000000] console [tty0] enabled
<6>[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
<7>[    0.000000] hpet clockevent registered
<4>[    0.000000] tsc: Unable to calibrate against PIT
<6>[    0.000000] tsc: using HPET reference calibration
<6>[    0.000000] tsc: Detected 1695.972 MHz processor
<6>[    0.000050] Calibrating delay loop (skipped), value calculated using timer frequency.. 3391.94 BogoMIPS (lpj=6783888)
<6>[    0.000054] pid_max: default: 32768 minimum: 301
<6>[    0.000062] ACPI: Core revision 20150619
<4>[    0.009825] ACPI: All ACPI Tables successfully acquired
<6>[    0.010869] Security Framework initialized
<6>[    0.010876] AppArmor: AppArmor initialized
<6>[    0.010878] Yama: becoming mindful.
<6>[    0.011273] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
<6>[    0.012806] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
<6>[    0.013514] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
<6>[    0.013522] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
<6>[    0.013784] Initializing cgroup subsys blkio
<6>[    0.013788] Initializing cgroup subsys memory
<6>[    0.013798] Initializing cgroup subsys devices
<6>[    0.013801] Initializing cgroup subsys freezer
<6>[    0.013804] Initializing cgroup subsys net_cls
<6>[    0.013807] Initializing cgroup subsys perf_event
<6>[    0.013810] Initializing cgroup subsys net_prio
<6>[    0.013812] Initializing cgroup subsys hugetlb
<6>[    0.013842] CPU: Physical Processor ID: 0
<6>[    0.013843] CPU: Processor Core ID: 0
<4>[    0.013849] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
<4>[    0.013851] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
<6>[    0.014405] mce: CPU supports 7 MCE banks
<6>[    0.014420] CPU0: Thermal monitoring enabled (TM1)
<6>[    0.014427] process: using mwait in idle threads
<6>[    0.014432] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
<6>[    0.014433] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
<6>[    0.014608] Freeing SMP alternatives memory: 28K (ffffffff81eb4000 - ffffffff81ebb000)
<6>[    0.018817] ftrace: allocating 30368 entries in 119 pages
<6>[    0.039107] DMAR: Host address width 36
<6>[    0.039112] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
<6>[    0.039125] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
<6>[    0.039126] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
<6>[    0.039132] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
<6>[    0.039133] DMAR: RMRR base: 0x000000d9609000 end: 0x000000d9615fff
<6>[    0.039135] DMAR: RMRR base: 0x000000db800000 end: 0x000000df9fffff
<6>[    0.039139] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
<6>[    0.039140] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
<6>[    0.039142] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
<6>[    0.039545] DMAR-IR: Enabled IRQ remapping in x2apic mode
<6>[    0.039548] x2apic enabled
<6>[    0.039558] Switched APIC routing to cluster x2apic.
<6>[    0.040050] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
<7>[    0.079791] TSC deadline timer enabled
<6>[    0.079796] smpboot: CPU0: Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz (fam: 06, model: 3a, stepping: 09)
<6>[    0.079830] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
<6>[    0.079858] ... version:                3
<6>[    0.079860] ... bit width:              48
<6>[    0.079861] ... generic registers:      4
<6>[    0.079862] ... value mask:             0000ffffffffffff
<6>[    0.079863] ... max period:             0000ffffffffffff
<6>[    0.079865] ... fixed-purpose events:   3
<6>[    0.079866] ... event mask:             000000070000000f
<6>[    0.080885] x86: Booting SMP configuration:
<6>[    0.080888] .... node  #0, CPUs:      #1
<6>[    0.084872] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
<4>[    0.084994]  #2 #3
<6>[    0.092787] x86: Booted up 1 node, 4 CPUs
<6>[    0.092791] smpboot: Total of 4 processors activated (13567.77 BogoMIPS)
<6>[    0.097599] devtmpfs: initialized
<6>[    0.101118] evm: security.selinux
<6>[    0.101120] evm: security.SMACK64
<6>[    0.101121] evm: security.SMACK64EXEC
<6>[    0.101122] evm: security.SMACK64TRANSMUTE
<6>[    0.101123] evm: security.SMACK64MMAP
<6>[    0.101124] evm: security.ima
<6>[    0.101126] evm: security.capability
<6>[    0.101213] PM: Registering ACPI NVS region [mem 0xd9682000-0xda24ffff] (12378112 bytes)
<6>[    0.101418] PM: Registering ACPI NVS region [mem 0xda700000-0xda742fff] (274432 bytes)
<6>[    0.101529] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
<6>[    0.101636] pinctrl core: initialized pinctrl subsystem
<6>[    0.101779] RTC time:  6:14:19, date: 08/05/15
<6>[    0.101926] NET: Registered protocol family 16
<6>[    0.105396] cpuidle: using governor ladder
<6>[    0.109402] cpuidle: using governor menu
<6>[    0.109513] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
<6>[    0.109516] ACPI: bus type PCI registered
<6>[    0.109518] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
<6>[    0.109612] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
<6>[    0.109615] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
<6>[    0.109627] PCI: Using configuration type 1 for base access
<6>[    0.109910] perf_event_intel: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
<6>[    0.114016] ACPI: Added _OSI(Module Device)
<6>[    0.114018] ACPI: Added _OSI(Processor Device)
<6>[    0.114020] ACPI: Added _OSI(3.0 _SCP Extensions)
<6>[    0.114022] ACPI: Added _OSI(Processor Aggregator Device)
<4>[    0.117431] ACPI: Executed 1 blocks of module-level executable AML code
<4>[    0.120827] ACPI: Dynamic OEM Table Load:
<4>[    0.120837] ACPI: SSDT 0xFFFF880119A31000 00083B (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
<4>[    0.121542] ACPI: Dynamic OEM Table Load:
<4>[    0.121548] ACPI: SSDT 0xFFFF880119A0A800 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
<4>[    0.122296] ACPI: Dynamic OEM Table Load:
<4>[    0.122302] ACPI: SSDT 0xFFFF8801199FFE00 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
<6>[    0.123412] ACPI : EC: EC started
<6>[    1.391050] ACPI: Interpreter enabled
<4>[    1.391061] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20150619/hwxface-580)
<4>[    1.391068] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20150619/hwxface-580)
<6>[    1.391087] ACPI: (supports S0 S3 S4 S5)
<6>[    1.391088] ACPI: Using IOAPIC for interrupt routing
<6>[    1.391131] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
<6>[    1.400887] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
<6>[    1.400894] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
<6>[    1.401195] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
<6>[    1.401365] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
<6>[    1.401368] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
<6>[    1.401835] PCI host bridge to bus 0000:00
<6>[    1.401839] pci_bus 0000:00: root bus resource [bus 00-3e]
<6>[    1.401842] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
<6>[    1.401845] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
<6>[    1.401847] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
<6>[    1.401849] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff window]
<6>[    1.401852] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff window]
<6>[    1.401854] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff window]
<6>[    1.401856] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
<6>[    1.401858] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
<6>[    1.401861] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
<6>[    1.401863] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
<6>[    1.401865] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
<6>[    1.401867] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff window]
<6>[    1.401870] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff window]
<6>[    1.401872] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff window]
<6>[    1.401874] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff window]
<6>[    1.401877] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff window]
<6>[    1.401879] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff window]
<7>[    1.401889] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
<7>[    1.402015] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
<7>[    1.402035] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
<7>[    1.402044] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
<7>[    1.402051] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
<7>[    1.402222] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
<7>[    1.402259] pci 0000:00:14.0: reg 0x10: [mem 0xf7c00000-0xf7c0ffff 64bit]
<7>[    1.402472] pci 0000:00:14.0: PME# supported from D3hot D3cold
<6>[    1.402534] pci 0000:00:14.0: System wakeup disabled by ACPI
<7>[    1.402591] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
<7>[    1.402632] pci 0000:00:16.0: reg 0x10: [mem 0xf7c1b000-0xf7c1b00f 64bit]
<7>[    1.402706] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
<7>[    1.402820] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
<7>[    1.402853] pci 0000:00:1a.0: reg 0x10: [mem 0xf7c18000-0xf7c183ff]
<7>[    1.402923] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
<6>[    1.403006] pci 0000:00:1a.0: System wakeup disabled by ACPI
<7>[    1.403065] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
<7>[    1.403096] pci 0000:00:1b.0: reg 0x10: [mem 0xf7c10000-0xf7c13fff 64bit]
<7>[    1.403161] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
<6>[    1.403225] pci 0000:00:1b.0: System wakeup disabled by ACPI
<7>[    1.403284] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
<7>[    1.403319] pci 0000:00:1d.0: reg 0x10: [mem 0xf7c17000-0xf7c173ff]
<7>[    1.403408] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
<6>[    1.403482] pci 0000:00:1d.0: System wakeup disabled by ACPI
<7>[    1.403535] pci 0000:00:1f.0: [8086:1e57] type 00 class 0x060100
<7>[    1.403745] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
<7>[    1.403777] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
<7>[    1.403786] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
<7>[    1.403796] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
<7>[    1.403807] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
<7>[    1.403816] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
<7>[    1.403827] pci 0000:00:1f.2: reg 0x24: [mem 0xf7c16000-0xf7c167ff]
<7>[    1.403863] pci 0000:00:1f.2: PME# supported from D3hot
<7>[    1.403963] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
<7>[    1.403988] pci 0000:00:1f.3: reg 0x10: [mem 0xf7c15000-0xf7c150ff 64bit]
<7>[    1.404016] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
<6>[    1.405529] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    1.405603] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    1.405670] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    1.405741] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    1.405812] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    1.405880] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    1.405947] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<6>[    1.406017] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
<4>[    1.406202] ACPI: Enabled 4 GPEs in block 00 to 3F
<6>[    1.406255] ACPI : EC: GPE = 0x1e, I/O: command/status = 0x66, data = 0x62
<6>[    1.406394] vgaarb: setting as boot device: PCI:0000:00:02.0
<6>[    1.406397] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
<6>[    1.406400] vgaarb: loaded
<6>[    1.406401] vgaarb: bridge control possible 0000:00:02.0
<5>[    1.406681] SCSI subsystem initialized
<7>[    1.406737] libata version 3.00 loaded.
<6>[    1.406770] ACPI: bus type USB registered
<6>[    1.406794] usbcore: registered new interface driver usbfs
<6>[    1.406807] usbcore: registered new interface driver hub
<6>[    1.406831] usbcore: registered new device driver usb
<6>[    1.407100] PCI: Using ACPI for IRQ routing
<7>[    1.409074] PCI: pci_cache_line_size set to 64 bytes
<7>[    1.409125] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
<7>[    1.409127] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
<7>[    1.409129] e820: reserve RAM buffer [mem 0xd9203000-0xdbffffff]
<7>[    1.409132] e820: reserve RAM buffer [mem 0xda700000-0xdbffffff]
<7>[    1.409134] e820: reserve RAM buffer [mem 0xdad55000-0xdbffffff]
<7>[    1.409136] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
<7>[    1.409138] e820: reserve RAM buffer [mem 0x11f600000-0x11fffffff]
<6>[    1.409287] NetLabel: Initializing
<6>[    1.409288] NetLabel:  domain hash size = 128
<6>[    1.409289] NetLabel:  protocols = UNLABELED CIPSOv4
<6>[    1.409306] NetLabel:  unlabeled traffic allowed by default
<6>[    1.409411] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
<6>[    1.409418] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
<6>[    1.412478] clocksource: Switched to clocksource hpet
<6>[    1.420214] AppArmor: AppArmor Filesystem Enabled
<6>[    1.420303] pnp: PnP ACPI init
<6>[    1.420422] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
<7>[    1.420427] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    1.420548] system 00:01: [io  0x0680-0x069f] has been reserved
<6>[    1.420551] system 00:01: [io  0x1000-0x100f] has been reserved
<6>[    1.420553] system 00:01: [io  0xffff] has been reserved
<6>[    1.420556] system 00:01: [io  0xffff] has been reserved
<6>[    1.420558] system 00:01: [io  0x0400-0x0453] could not be reserved
<6>[    1.420561] system 00:01: [io  0x0458-0x047f] has been reserved
<6>[    1.420563] system 00:01: [io  0x0500-0x057f] has been reserved
<6>[    1.420566] system 00:01: [io  0x164e-0x164f] has been reserved
<7>[    1.420570] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
<7>[    1.420605] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
<6>[    1.420665] system 00:03: [io  0x0454-0x0457] has been reserved
<7>[    1.420669] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
<6>[    1.420729] system 00:04: [io  0x04d0-0x04d1] has been reserved
<7>[    1.420732] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
<6>[    1.421020] system 00:05: [mem 0xfed1c000-0xfed1ffff] has been reserved
<6>[    1.421023] system 00:05: [mem 0xfed10000-0xfed17fff] has been reserved
<6>[    1.421025] system 00:05: [mem 0xfed18000-0xfed18fff] has been reserved
<6>[    1.421028] system 00:05: [mem 0xfed19000-0xfed19fff] has been reserved
<6>[    1.421031] system 00:05: [mem 0xf8000000-0xfbffffff] has been reserved
<6>[    1.421033] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
<6>[    1.421036] system 00:05: [mem 0xfed90000-0xfed93fff] could not be reserved
<6>[    1.421039] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
<6>[    1.421041] system 00:05: [mem 0xff000000-0xffffffff] has been reserved
<6>[    1.421044] system 00:05: [mem 0xfee00000-0xfeefffff] could not be reserved
<6>[    1.421047] system 00:05: [mem 0xdfa00000-0xdfa00fff] has been reserved
<7>[    1.421050] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
<6>[    1.421894] system 00:06: [mem 0x20000000-0x201fffff] has been reserved
<6>[    1.421897] system 00:06: [mem 0x40004000-0x40004fff] has been reserved
<7>[    1.421901] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
<6>[    1.421955] pnp: PnP ACPI: found 7 devices
<6>[    1.429125] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
<7>[    1.429141] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
<7>[    1.429144] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
<7>[    1.429146] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
<7>[    1.429149] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff window]
<7>[    1.429151] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff window]
<7>[    1.429153] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff window]
<7>[    1.429156] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff window]
<7>[    1.429158] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff window]
<7>[    1.429160] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff window]
<7>[    1.429163] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff window]
<7>[    1.429165] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff window]
<7>[    1.429167] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff window]
<7>[    1.429170] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff window]
<7>[    1.429172] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff window]
<7>[    1.429174] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff window]
<7>[    1.429177] pci_bus 0000:00: resource 19 [mem 0x000f0000-0x000fffff window]
<7>[    1.429179] pci_bus 0000:00: resource 20 [mem 0xdfa00000-0xfeafffff window]
<6>[    1.429220] NET: Registered protocol family 2
<6>[    1.429422] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
<6>[    1.429527] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
<6>[    1.429604] TCP: Hash tables configured (established 32768 bind 32768)
<6>[    1.429633] UDP hash table entries: 2048 (order: 4, 65536 bytes)
<6>[    1.429653] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
<6>[    1.429714] NET: Registered protocol family 1
<7>[    1.429734] pci 0000:00:02.0: Video device with shadowed ROM
<6>[    1.429746] pci 0000:00:14.0: enabling device (0000 -> 0002)
<6>[    1.430024] pci 0000:00:1a.0: enabling device (0000 -> 0002)
<7>[    1.448656] PCI: CLS 64 bytes, default 64
<6>[    1.448726] Trying to unpack rootfs image as initramfs...
<6>[    1.916766] Freeing initrd memory: 19796K (ffff880035946000 - ffff880036c9b000)
<6>[    1.916814] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
<6>[    1.916818] software IO TLB [mem 0xd383f000-0xd783f000] (64MB) mapped at [ffff8800d383f000-ffff8800d783efff]
<6>[    1.916923] RAPL PMU detected, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
<6>[    1.916925] hw unit of domain pp0-core 2^-16 Joules
<6>[    1.916927] hw unit of domain package 2^-16 Joules
<6>[    1.916928] hw unit of domain pp1-gpu 2^-16 Joules
<6>[    1.917082] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x13
<6>[    1.917094] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x13
<6>[    1.917104] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x13
<6>[    1.917115] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x13
<6>[    1.917186] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
<6>[    1.917223] Scanning for low memory corruption every 60 seconds
<6>[    1.917636] futex hash table entries: 1024 (order: 4, 65536 bytes)
<5>[    1.917658] Initialise system trusted keyring
<6>[    1.917691] audit: initializing netlink subsys (disabled)
<5>[    1.917706] audit: type=2000 audit(1438755260.916:1): initialized
<6>[    1.918230] HugeTLB registered 2 MB page size, pre-allocated 0 pages
<6>[    1.920311] zpool: loaded
<6>[    1.920314] zbud: loaded
<5>[    1.920558] VFS: Disk quotas dquot_6.6.0
<6>[    1.920605] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>[    1.921290] fuse init (API version 7.23)
<5>[    1.921485] Key type big_key registered
<5>[    1.921966] Key type asymmetric registered
<5>[    1.921971] Asymmetric key parser 'x509' registered
<6>[    1.921989] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
<6>[    1.922040] io scheduler noop registered
<6>[    1.922045] io scheduler deadline registered (default)
<6>[    1.922102] io scheduler cfq registered
<6>[    1.922207] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
<6>[    1.922217] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
<6>[    1.922268] efifb: probing for efifb
<6>[    1.922286] efifb: framebuffer at 0xe0000000, mapped to 0xffffc90000800000, using 8128k, total 8128k
<6>[    1.922288] efifb: mode is 1920x1080x32, linelength=7680, pages=1
<6>[    1.922289] efifb: scrolling: redraw
<6>[    1.922292] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
<6>[    1.930486] Console: switching to colour frame buffer device 240x67
<6>[    1.938513] fb0: EFI VGA frame buffer device
<7>[    1.938528] intel_idle: MWAIT substates: 0x21120
<7>[    1.938530] intel_idle: v0.4 model 0x3A
<7>[    1.938532] intel_idle: lapic_timer_reliable_states 0xffffffff
<6>[    1.939343] ACPI: AC Adapter [AC0] (off-line)
<6>[    1.939422] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C0D:00/input/input0
<6>[    1.939448] ACPI: Lid Switch [LID0]
<6>[    1.939507] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
<6>[    1.939512] ACPI: Power Button [PWRF]
<4>[    1.942221] [Firmware Bug]: Invalid critical threshold (86)
<6>[    1.945006] thermal LNXTHERM:00: registered as thermal_zone0
<6>[    1.945010] ACPI: Thermal Zone [TZ0] (-267 C)
<6>[    1.945061] GHES: HEST is not enabled!
<6>[    1.945210] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
<6>[    1.954650] Linux agpgart interface v0.103
<6>[    1.958586] brd: module loaded
<6>[    1.959854] loop: module loaded
<6>[    1.960152] libphy: Fixed MDIO Bus: probed
<6>[    1.960157] tun: Universal TUN/TAP device driver, 1.6
<6>[    1.960159] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
<6>[    1.960265] PPP generic driver version 2.4.2
<6>[    1.960549] xhci_hcd 0000:00:14.0: xHCI Host Controller
<6>[    1.960558] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
<6>[    1.960664] xhci_hcd 0000:00:14.0: hcc params 0x20007181 hci version 0x100 quirks 0x0000b930
<7>[    1.960674] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
<6>[    1.960844] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    1.960847] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    1.960849] usb usb1: Product: xHCI Host Controller
<6>[    1.960851] usb usb1: Manufacturer: Linux 4.2.0-rc3 xhci-hcd
<6>[    1.960853] usb usb1: SerialNumber: 0000:00:14.0
<6>[    1.961026] hub 1-0:1.0: USB hub found
<6>[    1.961040] hub 1-0:1.0: 4 ports detected
<6>[    1.961649] xhci_hcd 0000:00:14.0: xHCI Host Controller
<6>[    1.961654] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
<6>[    1.961758] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
<6>[    1.961760] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    1.961762] usb usb2: Product: xHCI Host Controller
<6>[    1.961764] usb usb2: Manufacturer: Linux 4.2.0-rc3 xhci-hcd
<6>[    1.961766] usb usb2: SerialNumber: 0000:00:14.0
<6>[    1.961928] hub 2-0:1.0: USB hub found
<6>[    1.961942] hub 2-0:1.0: 4 ports detected
<6>[    1.962537] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
<6>[    1.962548] ehci-pci: EHCI PCI platform driver
<6>[    1.962718] ehci-pci 0000:00:1a.0: EHCI Host Controller
<6>[    1.962724] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 3
<6>[    1.962743] ehci-pci 0000:00:1a.0: debug port 2
<6>[    1.965118] ACPI: Battery Slot [BAT0] (battery present)
<7>[    1.966667] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
<6>[    1.966689] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7c18000
<6>[    1.976761] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
<6>[    1.976813] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    1.976815] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    1.976818] usb usb3: Product: EHCI Host Controller
<6>[    1.976820] usb usb3: Manufacturer: Linux 4.2.0-rc3 ehci_hcd
<6>[    1.976822] usb usb3: SerialNumber: 0000:00:1a.0
<6>[    1.977003] hub 3-0:1.0: USB hub found
<6>[    1.977010] hub 3-0:1.0: 2 ports detected
<6>[    1.977287] ehci-pci 0000:00:1d.0: EHCI Host Controller
<6>[    1.977293] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
<6>[    1.977313] ehci-pci 0000:00:1d.0: debug port 2
<7>[    1.981228] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
<6>[    1.981246] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7c17000
<6>[    1.992805] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
<6>[    1.992861] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
<6>[    1.992864] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
<6>[    1.992866] usb usb4: Product: EHCI Host Controller
<6>[    1.992869] usb usb4: Manufacturer: Linux 4.2.0-rc3 ehci_hcd
<6>[    1.992871] usb usb4: SerialNumber: 0000:00:1d.0
<6>[    1.993102] hub 4-0:1.0: USB hub found
<6>[    1.993113] hub 4-0:1.0: 2 ports detected
<6>[    1.993288] ehci-platform: EHCI generic platform driver
<6>[    1.993302] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
<6>[    1.993309] ohci-pci: OHCI PCI platform driver
<6>[    1.993322] ohci-platform: OHCI generic platform driver
<6>[    1.993333] uhci_hcd: USB Universal Host Controller Interface driver
<6>[    1.993400] i8042: PNP: No PS/2 controller found. Probing ports directly.
<6>[    2.272890] usb 1-3: new high-speed USB device number 2 using xhci_hcd
<6>[    2.292917] usb 3-1: new high-speed USB device number 2 using ehci-pci
<6>[    2.407212] usb 1-3: New USB device found, idVendor=1286, idProduct=2043
<6>[    2.407216] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
<6>[    2.407219] usb 1-3: Product: Marvell Wireless Device
<6>[    2.407223] usb 1-3: Manufacturer: Marvell
<6>[    2.407226] usb 1-3: SerialNumber: 0000000000000000
<6>[    2.425351] usb 3-1: New USB device found, idVendor=8087, idProduct=0024
<6>[    2.425356] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>[    2.425648] hub 3-1:1.0: USB hub found
<6>[    2.425699] hub 3-1:1.0: 6 ports detected
<3>[    2.536149] i8042: Can't read CTR while initializing i8042
<4>[    2.536208] i8042: probe of i8042 failed with error -5
<6>[    2.536537] mousedev: PS/2 mouse device common for all mice
<6>[    2.536856] rtc_cmos 00:02: RTC can wake from S4
<6>[    2.537011] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
<6>[    2.537056] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
<6>[    2.537153] device-mapper: uevent: version 1.0.3
<6>[    2.537322] device-mapper: ioctl: 4.32.0-ioctl (2015-6-26) initialised: dm-devel@redhat.com
<6>[    2.537350] Intel P-state driver initializing.
<6>[    2.537602] ledtrig-cpu: registered to indicate activity on CPUs
<6>[    2.537617] EFI Variables Facility v0.08 2004-May-17
<6>[    2.567282] NET: Registered protocol family 10
<6>[    2.567757] NET: Registered protocol family 17
<5>[    2.567790] Key type dns_resolver registered
<5>[    2.568735] Loading compiled-in X.509 certificates
<5>[    2.569865] Loaded X.509 cert 'Build time autogenerated kernel key: 256b82d244e08151b975440d13fe5231319da4aa'
<6>[    2.569881] registered taskstats version 1
<6>[    2.569902] zswap: loading zswap
<6>[    2.569904] zswap: using zbud pool
<6>[    2.569908] zswap: using lzo compressor
<5>[    2.571950] Key type trusted registered
<5>[    2.575321] Key type encrypted registered
<6>[    2.575329] AppArmor: AppArmor sha1 policy hashing enabled
<6>[    2.575332] ima: No TPM chip found, activating TPM-bypass!
<6>[    2.575357] evm: HMAC attrs: 0x1
<6>[    2.575579]   Magic number: 11:189:215
<6>[    2.575599] event_source software: hash matches
<6>[    2.575677] rtc_cmos 00:02: setting system clock to 2015-08-05 06:14:21 UTC (1438755261)
<6>[    2.575744] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
<6>[    2.575745] EDD information not available.
<7>[    2.575832] PM: Hibernation image not present or could not be loaded.
<6>[    2.576131] Freeing unused kernel memory: 1452K (ffffffff81d49000 - ffffffff81eb4000)
<6>[    2.576133] Write protecting the kernel read-only data: 12288k
<6>[    2.576370] Freeing unused kernel memory: 400K (ffff88000179c000 - ffff880001800000)
<6>[    2.576457] Freeing unused kernel memory: 296K (ffff880001bb6000 - ffff880001c00000)
<5>[    2.586256] random: systemd-udevd urandom read with 10 bits of entropy available
<7>[    2.611600] ahci 0000:00:1f.2: version 3.0
<6>[    2.611788] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1 impl SATA mode
<6>[    2.611791] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
<6>[    2.612384] scsi host0: ahci
<6>[    2.612504] scsi host1: ahci
<6>[    2.612617] scsi host2: ahci
<6>[    2.612729] scsi host3: ahci
<6>[    2.612836] scsi host4: ahci
<6>[    2.612940] scsi host5: ahci
<6>[    2.612992] ata1: SATA max UDMA/133 abar m2048@0xf7c16000 port 0xf7c16100 irq 27
<6>[    2.612993] ata2: DUMMY
<6>[    2.612994] ata3: DUMMY
<6>[    2.612995] ata4: DUMMY
<6>[    2.612996] ata5: DUMMY
<6>[    2.612997] ata6: DUMMY
<6>[    2.697148] usb 3-1.1: new high-speed USB device number 3 using ehci-pci
<6>[    2.745164] usb 4-1: new high-speed USB device number 2 using ehci-pci
<6>[    2.806321] usb 3-1.1: New USB device found, idVendor=045e, idProduct=0795
<6>[    2.806338] usb 3-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>[    2.806340] usb 3-1.1: Product: Rear LifeCam
<6>[    2.806341] usb 3-1.1: Manufacturer: Microsoft
<6>[    2.877741] usb 4-1: New USB device found, idVendor=8087, idProduct=0024
<6>[    2.877743] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
<6>[    2.878105] hub 4-1:1.0: USB hub found
<6>[    2.878161] hub 4-1:1.0: 8 ports detected
<6>[    2.917252] tsc: Refined TSC clocksource calibration: 1696.147 MHz
<6>[    2.917255] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1872ef8535c, max_idle_ns: 440795255355 ns
<6>[    2.933268] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
<4>[    2.933635] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20150619/psargs-359)
<4>[    2.933640] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff88011a8b64b0), AE_NOT_FOUND (20150619/psparse-536)
<6>[    2.933884] ata1.00: ATA-9: C400-MTFDDAT064MAM, 07MH, max UDMA/100
<6>[    2.933887] ata1.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
<4>[    2.934348] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20150619/psargs-359)
<4>[    2.934353] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff88011a8b64b0), AE_NOT_FOUND (20150619/psparse-536)
<6>[    2.934600] ata1.00: configured for UDMA/100
<5>[    2.934826] scsi 0:0:0:0: Direct-Access     ATA      C400-MTFDDAT064M 07MH PQ: 0 ANSI: 5
<5>[    2.935293] sd 0:0:0:0: Attached scsi generic sg0 type 0
<5>[    2.935296] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
<5>[    2.935414] sd 0:0:0:0: [sda] Write Protect is off
<7>[    2.935418] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
<5>[    2.935516] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
<6>[    2.937270]  sda: sda1 sda2 sda3
<5>[    2.937926] sd 0:0:0:0: [sda] Attached SCSI disk
<6>[    2.969284] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
<7>[    3.057923] systemd[1]: Inserted module 'autofs4'
<7>[    3.115974] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT -GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID -ELFUTILS +KMOD -IDN)
<7>[    3.116104] systemd[1]: Detected architecture x86-64.
<7>[    3.117364] systemd[1]: Set hostname to <touco>.
<6>[    3.149302] usb 4-1.5: new full-speed USB device number 3 using ehci-pci
<7>[    3.212497] systemd[1]: [/lib/systemd/system/mpd.service:17] Unknown lvalue 'ControlGroup' in section 'Service'
<7>[    3.212507] systemd[1]: [/lib/systemd/system/mpd.service:20] Unknown lvalue 'ControlGroupAttribute' in section 'Service'
<7>[    3.232004] systemd[1]: Cannot add dependency job for unit gssproxy.service, ignoring: Unit gssproxy.service failed to load: No such file or directory.
<7>[    3.232014] systemd[1]: Cannot add dependency job for unit nfs-blkmap.service, ignoring: Unit nfs-blkmap.service failed to load: No such file or directory.
<7>[    3.232838] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
<7>[    3.232850] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
<7>[    3.232870] systemd[1]: Reached target Encrypted Volumes.
<7>[    3.232877] systemd[1]: Starting Encrypted Volumes.
<7>[    3.232915] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
<7>[    3.232922] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
<7>[    3.232965] systemd[1]: Created slice Root Slice.
<7>[    3.232972] systemd[1]: Starting Root Slice.
<7>[    3.233053] systemd[1]: Created slice System Slice.
<7>[    3.233066] systemd[1]: Starting System Slice.
<7>[    3.233625] systemd[1]: Starting Increase datagram queue length...
<7>[    3.233770] systemd[1]: Created slice system-systemd\x2dfsck.slice.
<7>[    3.233783] systemd[1]: Starting system-systemd\x2dfsck.slice.
<7>[    3.233844] systemd[1]: Listening on udev Control Socket.
<7>[    3.233853] systemd[1]: Starting udev Control Socket.
<7>[    3.233890] systemd[1]: Listening on Delayed Shutdown Socket.
<7>[    3.233899] systemd[1]: Starting Delayed Shutdown Socket.
<7>[    3.233940] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
<7>[    3.233950] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
<7>[    3.234046] systemd[1]: Listening on Journal Audit Socket.
<7>[    3.234055] systemd[1]: Starting Journal Audit Socket.
<7>[    3.234088] systemd[1]: Listening on fsck to fsckd communication Socket.
<7>[    3.234096] systemd[1]: Starting fsck to fsckd communication Socket.
<7>[    3.234139] systemd[1]: Listening on Journal Socket (/dev/log).
<7>[    3.234151] systemd[1]: Starting Journal Socket (/dev/log).
<7>[    3.234247] systemd[1]: Created slice User and Session Slice.
<7>[    3.234256] systemd[1]: Starting User and Session Slice.
<7>[    3.234354] systemd[1]: Created slice system-getty.slice.
<7>[    3.234362] systemd[1]: Starting system-getty.slice.
<7>[    3.234406] systemd[1]: Listening on Journal Socket.
<7>[    3.234423] systemd[1]: Starting Journal Socket.
<7>[    3.234441] systemd[1]: Started Kernel Module supporting RPCSEC_GSS.
<7>[    3.235030] systemd[1]: Starting Nameserver information manager...
<7>[    3.238380] systemd[1]: Started Set Up Additional Binary Formats.
<7>[    3.241074] systemd[1]: Starting Load Kernel Modules...
<7>[    3.241880] systemd[1]: Starting Setup Virtual Console...
<7>[    3.242807] systemd[1]: Started Read required files in advance.
<7>[    3.243091] systemd[1]: Starting Read required files in advance...
<6>[    3.243702] usb 4-1.5: New USB device found, idVendor=045e, idProduct=07a9
<6>[    3.243705] usb 4-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
<6>[    3.243707] usb 4-1.5: Product: SAM
<6>[    3.243709] usb 4-1.5: Manufacturer: MICROSOFT
<6>[    3.243710] usb 4-1.5: SerialNumber: 0.1.0000
<7>[    3.244168] systemd[1]: Mounting POSIX Message Queue File System...
<7>[    3.245154] systemd[1]: Mounting Debug File System...
<7>[    3.245906] systemd[1]: Started Braille Device Support.
<7>[    3.245988] systemd[1]: Starting Braille Device Support...
<7>[    3.246932] systemd[1]: Starting Create list of required static device nodes for the current kernel...
<7>[    3.248327] systemd[1]: Mounting Huge Pages File System...
<7>[    3.250144] systemd[1]: Starting Uncomplicated firewall...
<7>[    3.252647] systemd[1]: Mounting RPC Pipe File System...
<7>[    3.252771] systemd[1]: Listening on udev Kernel Socket.
<7>[    3.252798] systemd[1]: Starting udev Kernel Socket.
<7>[    3.253998] systemd[1]: Starting udev Coldplug all Devices...
<7>[    3.254060] systemd[1]: Reached target Slices.
<7>[    3.254087] systemd[1]: Starting Slices.
<7>[    3.255230] systemd[1]: Mounted POSIX Message Queue File System.
<7>[    3.255276] systemd[1]: Mounted Huge Pages File System.
<7>[    3.255310] systemd[1]: Mounted Debug File System.
<7>[    3.255630] systemd[1]: Started Increase datagram queue length.
<7>[    3.257593] systemd[1]: Started Setup Virtual Console.
<7>[    3.258421] systemd[1]: Started Create list of required static device nodes for the current kernel.
<7>[    3.258882] systemd[1]: Started Uncomplicated firewall.
<6>[    3.263060] lp: driver loaded but no devices found
<7>[    3.264133] systemd[1]: Started Nameserver information manager.
<6>[    3.269941] ppdev: user-space parallel port driver
<6>[    3.275220] RPC: Registered named UNIX socket transport module.
<6>[    3.275224] RPC: Registered udp transport module.
<6>[    3.275226] RPC: Registered tcp transport module.
<6>[    3.275228] RPC: Registered tcp NFSv4.1 backchannel transport module.
<7>[    3.276344] systemd[1]: Started Load Kernel Modules.
<7>[    3.276565] systemd[1]: Mounted RPC Pipe File System.
<7>[    3.279853] systemd[1]: ureadahead.service: main process exited, code=exited, status=5/NOTINSSTALLED
<7>[    3.280301] systemd[1]: Unit ureadahead.service entered failed state.
<7>[    3.280333] systemd[1]: ureadahead.service failed.
<7>[    3.296960] systemd[1]: Started udev Coldplug all Devices.
<7>[    3.301759] systemd[1]: Starting udev Wait for Complete Device Initialization...
<7>[    3.302409] systemd[1]: Mounting FUSE Control File System...
<7>[    3.302533] systemd[1]: Mounted Configuration File System.
<7>[    3.303440] systemd[1]: Starting Apply Kernel Variables...
<7>[    3.304462] systemd[1]: Starting Create Static Device Nodes in /dev...
<7>[    3.304546] systemd[1]: Listening on Syslog Socket.
<7>[    3.304590] systemd[1]: Starting Syslog Socket.
<7>[    3.305514] systemd[1]: Starting Journal Service...
<7>[    3.308054] systemd[1]: Mounted FUSE Control File System.
<7>[    3.312798] systemd[1]: Started Apply Kernel Variables.
<6>[    3.313375] usb 4-1.6: new full-speed USB device number 4 using ehci-pci
<7>[    3.318960] systemd[1]: Started Create Static Device Nodes in /dev.
<7>[    3.319651] systemd[1]: Starting udev Kernel Device Manager...
<7>[    3.340968] systemd[1]: Started Journal Service.
<6>[    3.414526] usb 4-1.6: New USB device found, idVendor=03eb, idProduct=8209
<6>[    3.414531] usb 4-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>[    3.414534] usb 4-1.6: Product: Atmel maXTouch Digitizer
<6>[    3.414537] usb 4-1.6: Manufacturer: Atmel
<4>[    3.438667] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042F conflicts with OpRegion 0x0000000000000400-0x000000000000047F (\PMIO) (20150619/utaddress-254)
<6>[    3.438676] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    3.438680] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054F conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20150619/utaddress-254)
<6>[    3.438685] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    3.438687] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053F conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20150619/utaddress-254)
<6>[    3.438692] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    3.438693] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052F conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20150619/utaddress-254)
<6>[    3.438698] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
<4>[    3.438700] lpc_ich: Resource conflict(s) found affecting gpio_ich
<6>[    3.441017] [drm] Initialized drm 1.1.0 20060810
<6>[    3.459463] media: Linux media interface: v0.10
<6>[    3.468155] Linux video capture interface: v2.00
<6>[    3.483668] AVX version of gcm_enc/dec engaged.
<6>[    3.483671] AES CTR mode by8 optimization enabled
<6>[    3.489476] usb 4-1.7: new high-speed USB device number 5 using ehci-pci
<6>[    3.490724] uvcvideo: Found UVC 1.00 device Rear LifeCam (045e:0795)
<6>[    3.495084] [drm] Memory usable by graphics device = 2048M
<7>[    3.495090] checking generic (e0000000 7f0000) vs hw (e0000000 10000000)
<6>[    3.495092] fb: switching to inteldrmfb from EFI VGA
<6>[    3.495117] Console: switching to colour dummy device 80x25
<6>[    3.508661] [drm] Replacing VGA console driver
<6>[    3.527432] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
<6>[    3.527436] [drm] Driver supports precise vblank timestamp query.
<6>[    3.527556] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
<6>[    3.556997] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
<6>[    3.557337] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
<6>[    3.557744] [drm] Initialized i915 1.6.0 20150522 for 0000:00:02.0 on minor 0
<6>[    3.558085] input: Rear LifeCam as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.1/3-1.1:1.0/input/input3
<6>[    3.558173] usbcore: registered new interface driver uvcvideo
<6>[    3.558175] USB Video Class driver (1.1.1)
<6>[    3.569384] fbcon: inteldrmfb (fb0) is primary device
<6>[    3.578083] intel_rapl: Found RAPL domain package
<6>[    3.578085] intel_rapl: Found RAPL domain core
<6>[    3.578087] intel_rapl: Found RAPL domain uncore
<6>[    3.585320] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
<6>[    3.598231] usb 4-1.7: New USB device found, idVendor=045e, idProduct=0794
<6>[    3.598232] usb 4-1.7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
<6>[    3.598233] usb 4-1.7: Product: Front LifeCam
<6>[    3.598234] usb 4-1.7: Manufacturer: Microsoft
<6>[    3.599379] uvcvideo: Found UVC 1.00 device Front LifeCam (045e:0794)
<6>[    3.600901] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC280: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
<6>[    3.600902] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
<6>[    3.600903] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
<6>[    3.600904] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
<6>[    3.600905] snd_hda_codec_realtek hdaudioC0D0:    inputs:
<6>[    3.600906] snd_hda_codec_realtek hdaudioC0D0:      Mic=0x1a
<6>[    3.600907] snd_hda_codec_realtek hdaudioC0D0:      Internal Mic=0x12
<6>[    3.613122] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input4
<6>[    3.613216] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input5
<6>[    3.613304] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
<6>[    3.665308] input: Front LifeCam as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.7/4-1.7:1.0/input/input7
<6>[    3.675923] hidraw: raw HID events driver (C) Jiri Kosina
<6>[    3.694007] usbcore: registered new interface driver usbhid
<6>[    3.694008] usbhid: USB HID core driver
<6>[    3.699963] input: Atmel Atmel maXTouch Digitizer as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.6/4-1.6:1.0/0003:03EB:8209.0004/input/input8
<6>[    3.700084] hid-multitouch 0003:03EB:8209.0004: input,hidraw0: USB HID v1.11 Device [Atmel Atmel maXTouch Digitizer] on usb-0000:00:1d.0-1.6/input0
<6>[    3.700974] input: MICROSOFT SAM as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.5/4-1.5:1.1/0003:045E:07A9.0002/input/input9
<6>[    3.754027] hid-generic 0003:045E:07A9.0002: input,hidraw1: USB HID v1.11 Keyboard [MICROSOFT SAM] on usb-0000:00:1d.0-1.5/input1
<6>[    3.756652] input: MICROSOFT SAM as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.5/4-1.5:1.2/0003:045E:07A9.0003/input/input10
<6>[    3.866220] hid-generic 0003:045E:07A9.0003: input,hiddev0,hidraw2: USB HID v1.11 Keyboard [MICROSOFT SAM] on usb-0000:00:1d.0-1.5/input2
<6>[    3.867990] hid-generic 0003:03EB:8209.0005: hiddev0,hidraw3: USB HID v1.11 Device [Atmel Atmel maXTouch Digitizer] on usb-0000:00:1d.0-1.6/input1
<6>[    3.917818] clocksource: Switched to clocksource tsc
<6>[    4.278797] Console: switching to colour frame buffer device 240x67
<6>[    4.283980] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
<6>[    4.283981] i915 0000:00:02.0: registered panic notifier
<6>[    4.290463] Adding 4075516k swap on /dev/sda3.  Priority:-1 extents:1 across:4075516k SSFS
<5>[    4.420404] random: nonblocking pool is initialized
<6>[    4.518090] cfg80211: Calling CRDA to update world regulatory domain
<5>[    4.525897] mwifiex: rx work enabled, cpus 4
<6>[    4.526170] usbcore: registered new interface driver mwifiex_usb
<6>[    4.532598] usb 1-3: start to download FW...
<6>[    4.539793] cfg80211: World regulatory domain updated:
<6>[    4.539798] cfg80211:  DFS Master region: unset
<6>[    4.539799] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
<6>[    4.539803] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
<6>[    4.539805] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
<6>[    4.539807] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
<6>[    4.539810] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
<6>[    4.539813] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
<6>[    4.539815] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
<6>[    4.539818] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
<6>[    4.539820] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
<6>[    4.570420] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
<7>[    4.584645] systemd-journald[265]: Received request to flush runtime journal from PID 1
<5>[    4.683134] audit: type=1400 audit(1438755263.601:2): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm-guest-session" pid=478 comm="apparmor_parser"
<5>[    4.683150] audit: type=1400 audit(1438755263.601:3): apparmor="STATUS" operation="profile_load" name="chromium" pid=478 comm="apparmor_parser"
<5>[    4.685816] audit: type=1400 audit(1438755263.601:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-freerdp/freerdp-session-wrapper" pid=478 comm="apparmor_parser"
<5>[    4.685831] audit: type=1400 audit(1438755263.601:5): apparmor="STATUS" operation="profile_load" name="chromium" pid=478 comm="apparmor_parser"
<5>[    4.688562] audit: type=1400 audit(1438755263.605:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-uccsconfigure/uccsconfigure-session-wrapper" pid=478 comm="apparmor_parser"
<5>[    4.688569] audit: type=1400 audit(1438755263.605:7): apparmor="STATUS" operation="profile_load" name="chromium" pid=478 comm="apparmor_parser"
<5>[    4.691592] audit: type=1400 audit(1438755263.609:8): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=478 comm="apparmor_parser"
<5>[    4.691601] audit: type=1400 audit(1438755263.609:9): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=478 comm="apparmor_parser"
<5>[    4.691607] audit: type=1400 audit(1438755263.609:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=478 comm="apparmor_parser"
<6>[    5.580813] usb 1-3: info: FW download over, size 551720 bytes
<6>[    5.580826] usb 1-3: info: mwifiex_fw_dpc: unregister device
<6>[    5.778157] usb 1-3: USB disconnect, device number 2
<3>[    5.778210] mwifiex_usb: mwifiex_usb_disconnect: card or card->adapter is NULL
<6>[    6.442861] usb 1-3: new high-speed USB device number 3 using xhci_hcd
<6>[    6.572054] usb 1-3: New USB device found, idVendor=1286, idProduct=2044
<6>[    6.572065] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
<6>[    6.572080] usb 1-3: Product: Bluetooth and Wireless LAN Composite Device
<6>[    6.572081] usb 1-3: Manufacturer: Marvell
<6>[    6.572083] usb 1-3: SerialNumber: 6045BDF646B4
<4>[    6.572265] usb 1-3: ep 0x4 - rounding interval to 128 microframes, ep desc says 255 microframes
<5>[    6.575195] mwifiex: rx work enabled, cpus 4
<6>[    6.575652] usb 1-3: WLAN FW is active
<6>[    6.588919] Bluetooth: Core ver 2.20
<6>[    6.588967] NET: Registered protocol family 31
<6>[    6.588970] Bluetooth: HCI device and connection manager initialized
<6>[    6.588975] Bluetooth: HCI socket layer initialized
<6>[    6.588978] Bluetooth: L2CAP socket layer initialized
<6>[    6.588985] Bluetooth: SCO socket layer initialized
<6>[    6.595451] usbcore: registered new interface driver btusb
<6>[    6.613309] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
<6>[    6.613312] Bluetooth: BNEP filters: protocol multicast
<6>[    6.613317] Bluetooth: BNEP socket layer initialized
<6>[    6.815732] usb 1-3: info: MWIFIEX VERSION: mwifiex 1.0 (14.68.29.p38) 
<6>[    6.815738] usb 1-3: driver_version = mwifiex 1.0 (14.68.29.p38) 
<6>[    6.932664] Bluetooth: RFCOMM TTY layer initialized
<6>[    6.932671] Bluetooth: RFCOMM socket layer initialized
<6>[    6.932675] Bluetooth: RFCOMM ver 1.11
<6>[   10.832650] usb 1-3: info: trying to associate to 'southcentral' bssid f4:ca:e5:ef:be:18
<6>[   10.849649] usb 1-3: info: associated to bssid f4:ca:e5:ef:be:18 successfully
<6>[   11.060160] usb 1-3: data: -ENOSR is returned
<6>[   11.251020] usb 1-3: Rx of mgmt packet failed
<6>[   32.971255] usb 1-3: Rx of mgmt packet failed
<6>[  165.954809] usb 1-3: data: -ENOSR is returned
<6>[  237.022120] usb 1-3: mwifiex_cmd_timeout_func: Timeout cmd id = 0xa4, act = 0x0
<6>[  237.022152] usb 1-3: num_data_h2c_failure = 0
<6>[  237.022163] usb 1-3: num_cmd_h2c_failure = 0
<6>[  237.022171] usb 1-3: is_cmd_timedout = 1
<6>[  237.022180] usb 1-3: num_tx_timeout = 0
<6>[  237.022188] usb 1-3: last_cmd_index = 2
<6>[  237.022197] usb 1-3: last_cmd_id: 7f 00 16 00 a4 00 16 00 a4 00
<6>[  237.022205] usb 1-3: last_cmd_act: 00 00 00 00 00 00 00 00 00 00
<6>[  237.022213] usb 1-3: last_cmd_resp_index = 1
<6>[  237.022222] usb 1-3: last_cmd_resp_id: 7f 80 16 80 7f 80 16 80 a4 80
<6>[  237.022231] usb 1-3: last_event_index = 3
<6>[  237.022239] usb 1-3: last_event: 00 00 17 00 2b 00 33 00 00 00
<6>[  237.022248] usb 1-3: data_sent=0 cmd_sent=0
<6>[  237.022257] usb 1-3: ps_mode=1 ps_state=0
<6>[  237.022275] usb 1-3: cmd timeout
<6>[  237.022437] usb 1-3: failed to get signal information
<6>[  237.022674] usb 1-3: PREP_CMD: FW is in bad state
<6>[  237.022683] usb 1-3: failed to get signal information
<6>[  237.023090] usb 1-3: PREP_CMD: FW is in bad state
<6>[  237.023099] usb 1-3: failed to get signal information
<6>[  237.023173] usb 1-3: PREP_CMD: FW is in bad state
<6>[  237.023180] usb 1-3: failed to get signal information
<6>[  243.011258] usb 1-3: PREP_CMD: FW is in bad state
<6>[  243.011262] usb 1-3: failed to get signal information
<6>[  243.011275] usb 1-3: PREP_CMD: FW is in bad state
<6>[  243.011277] usb 1-3: failed to get signal information
<6>[  249.009934] usb 1-3: PREP_CMD: FW is in bad state
<6>[  249.009943] usb 1-3: failed to get signal information
<6>[  249.009983] usb 1-3: PREP_CMD: FW is in bad state
<6>[  249.009986] usb 1-3: failed to get signal information
<6>[  255.011171] usb 1-3: PREP_CMD: FW is in bad state
<6>[  255.011181] usb 1-3: failed to get signal information
<6>[  255.011220] usb 1-3: PREP_CMD: FW is in bad state
<6>[  255.011224] usb 1-3: failed to get signal information
<6>[  261.016714] usb 1-3: PREP_CMD: FW is in bad state
<6>[  261.016727] usb 1-3: failed to get signal information
<6>[  261.016808] usb 1-3: PREP_CMD: FW is in bad state
<6>[  261.016816] usb 1-3: failed to get signal information
<6>[  267.021748] usb 1-3: PREP_CMD: FW is in bad state
<6>[  267.021758] usb 1-3: failed to get signal information
<6>[  267.021803] usb 1-3: PREP_CMD: FW is in bad state
<6>[  267.021807] usb 1-3: failed to get signal information
<6>[  272.405198] usb 1-3: data: -ENOSR is returned
<6>[  273.023705] usb 1-3: PREP_CMD: FW is in bad state
<6>[  273.023715] usb 1-3: failed to get signal information
<6>[  273.023759] usb 1-3: PREP_CMD: FW is in bad state
<6>[  273.023764] usb 1-3: failed to get signal information
<6>[  279.026665] usb 1-3: PREP_CMD: FW is in bad state
<6>[  279.026675] usb 1-3: failed to get signal information
<6>[  279.026719] usb 1-3: PREP_CMD: FW is in bad state
<6>[  279.026724] usb 1-3: failed to get signal information
<6>[  285.029612] usb 1-3: PREP_CMD: FW is in bad state
<6>[  285.029622] usb 1-3: failed to get signal information
<6>[  285.029666] usb 1-3: PREP_CMD: FW is in bad state
<6>[  285.029670] usb 1-3: failed to get signal information
<6>[  291.031554] usb 1-3: PREP_CMD: FW is in bad state
<6>[  291.031564] usb 1-3: failed to get signal information
<6>[  291.031603] usb 1-3: PREP_CMD: FW is in bad state
<6>[  291.031607] usb 1-3: failed to get signal information
<6>[  297.034504] usb 1-3: PREP_CMD: FW is in bad state
<6>[  297.034514] usb 1-3: failed to get signal information
<6>[  297.034558] usb 1-3: PREP_CMD: FW is in bad state
<6>[  297.034562] usb 1-3: failed to get signal information
<6>[  303.036469] usb 1-3: PREP_CMD: FW is in bad state
<6>[  303.036479] usb 1-3: failed to get signal information
<6>[  303.036523] usb 1-3: PREP_CMD: FW is in bad state
<6>[  303.036527] usb 1-3: failed to get signal information
<6>[  309.036519] usb 1-3: PREP_CMD: FW is in bad state
<6>[  309.036530] usb 1-3: failed to get signal information
<6>[  309.036574] usb 1-3: PREP_CMD: FW is in bad state
<6>[  309.036579] usb 1-3: failed to get signal information
<6>[  315.042354] usb 1-3: PREP_CMD: FW is in bad state
<6>[  315.042358] usb 1-3: failed to get signal information
<6>[  315.042374] usb 1-3: PREP_CMD: FW is in bad state
<6>[  315.042375] usb 1-3: failed to get signal information
<6>[  321.042562] usb 1-3: PREP_CMD: FW is in bad state
<6>[  321.042572] usb 1-3: failed to get signal information
<6>[  321.042616] usb 1-3: PREP_CMD: FW is in bad state
<6>[  321.042621] usb 1-3: failed to get signal information
<6>[  327.047530] usb 1-3: PREP_CMD: FW is in bad state
<6>[  327.047540] usb 1-3: failed to get signal information
<6>[  327.047584] usb 1-3: PREP_CMD: FW is in bad state
<6>[  327.047588] usb 1-3: failed to get signal information
<6>[  333.047795] usb 1-3: PREP_CMD: FW is in bad state
<6>[  333.047805] usb 1-3: failed to get signal information
<6>[  333.047849] usb 1-3: PREP_CMD: FW is in bad state
<6>[  333.047853] usb 1-3: failed to get signal information
<6>[  339.051755] usb 1-3: PREP_CMD: FW is in bad state
<6>[  339.051765] usb 1-3: failed to get signal information
<6>[  339.051808] usb 1-3: PREP_CMD: FW is in bad state
<6>[  339.051812] usb 1-3: failed to get signal information
<6>[  345.054688] usb 1-3: PREP_CMD: FW is in bad state
<6>[  345.054696] usb 1-3: failed to get signal information
<6>[  345.054733] usb 1-3: PREP_CMD: FW is in bad state
<6>[  345.054736] usb 1-3: failed to get signal information
<6>[  351.057432] usb 1-3: PREP_CMD: FW is in bad state
<6>[  351.057436] usb 1-3: failed to get signal information
<6>[  351.057449] usb 1-3: PREP_CMD: FW is in bad state
<6>[  351.057451] usb 1-3: failed to get signal information
<6>[  357.059336] usb 1-3: PREP_CMD: FW is in bad state
<6>[  357.059346] usb 1-3: failed to get signal information
<6>[  357.059390] usb 1-3: PREP_CMD: FW is in bad state
<6>[  357.059394] usb 1-3: failed to get signal information
<4>[  360.882604] ------------[ cut here ]------------
<4>[  360.882662] WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:303 dev_watchdog+0x228/0x240()
<6>[  360.882671] NETDEV WATCHDOG: mlan0 (usb): transmit queue 1 timed out
<4>[  360.882676] Modules linked in: rfcomm bnep btusb btrtl btbcm btintel bluetooth binfmt_misc nls_iso8859_1 mwifiex_usb mwifiex cfg80211 hid_sensor_accel_3d hid_sensor_magn_3d hid_sensor_als hid_sensor_gyro_3d hid_sensor_incl_3d hid_sensor_rotation hid_sensor_trigger industrialio_triggered_buffer kfifo_buf industrialio hid_sensor_iio_common joydev hid_sensor_hub hid_multitouch hid_generic usbhid hid snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec intel_rapl iosf_mbi x86_pkg_temp_thermal snd_hda_core intel_powerclamp snd_hwdep coretemp snd_pcm kvm_intel kvm snd_seq_midi snd_seq_midi_event snd_rawmidi crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_seq uvcvideo i915 aesni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core aes_x86_64 v4l2_common lrw
<4>[  360.882772]  videodev gf128mul glue_helper ablk_helper snd_seq_device media cryptd snd_timer snd drm_kms_helper drm lpc_ich mei_me mei soundcore i2c_algo_bit tpm_infineon mac_hid video sunrpc parport_pc ppdev lp parport autofs4 ahci libahci
<4>[  360.882825] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.2.0-rc3 #3
<4>[  360.882833] Hardware name: Microsoft Corporation Surface with Windows 8 Pro/Surface with Windows 8 Pro, BIOS 1.00.0250 01/08/2013
<4>[  360.882841]  ffffffff81b44c89 ffff88011f203d58 ffffffff8178d2f0 0000000000000000
<4>[  360.882852]  ffff88011f203da8 ffff88011f203d98 ffffffff81074faa ffff88011f203db8
<4>[  360.882862]  0000000000000001 ffff8800d213c500 0000000000000000 ffff8801194b0000
<4>[  360.882872] Call Trace:
<4>[  360.882878]  <IRQ>  [<ffffffff8178d2f0>] dump_stack+0x45/0x57
<4>[  360.882904]  [<ffffffff81074faa>] warn_slowpath_common+0x8a/0xc0
<4>[  360.882918]  [<ffffffff81075026>] warn_slowpath_fmt+0x46/0x50
<4>[  360.882929]  [<ffffffff816b3898>] dev_watchdog+0x228/0x240
<4>[  360.882940]  [<ffffffff816b3670>] ? dev_deactivate_queue.constprop.34+0x70/0x70
<4>[  360.882954]  [<ffffffff810dbb39>] call_timer_fn+0x39/0xf0
<4>[  360.882965]  [<ffffffff816b3670>] ? dev_deactivate_queue.constprop.34+0x70/0x70
<4>[  360.882978]  [<ffffffff810dd123>] run_timer_softirq+0x173/0x290
<4>[  360.882991]  [<ffffffff810790ad>] __do_softirq+0xfd/0x280
<4>[  360.883004]  [<ffffffff81079402>] irq_exit+0xe2/0xf0
<4>[  360.883014]  [<ffffffff81796a46>] smp_apic_timer_interrupt+0x46/0x60
<4>[  360.883026]  [<ffffffff81794bdb>] apic_timer_interrupt+0x6b/0x70
<4>[  360.883036]  <EOI>  [<ffffffff810de40c>] ? hrtimer_start_range_ns+0x1ac/0x3a0
<4>[  360.883058]  [<ffffffff81635864>] ? cpuidle_enter_state+0xf4/0x220
<4>[  360.883069]  [<ffffffff81635840>] ? cpuidle_enter_state+0xd0/0x220
<4>[  360.883081]  [<ffffffff816359c7>] cpuidle_enter+0x17/0x20
<4>[  360.883094]  [<ffffffff810b5412>] call_cpuidle+0x32/0x60
<4>[  360.883105]  [<ffffffff816359a3>] ? cpuidle_select+0x13/0x20
<4>[  360.883115]  [<ffffffff810b5699>] cpu_startup_entry+0x259/0x320
<4>[  360.883128]  [<ffffffff81782fdc>] rest_init+0x7c/0x80
<4>[  360.883141]  [<ffffffff81d61fdb>] start_kernel+0x492/0x49f
<4>[  360.883152]  [<ffffffff81d61120>] ? early_idt_handler_array+0x120/0x120
<4>[  360.883162]  [<ffffffff81d614d7>] x86_64_start_reservations+0x2a/0x2c
<4>[  360.883173]  [<ffffffff81d61614>] x86_64_start_kernel+0x13b/0x14a
<4>[  360.883181] ---[ end trace 5b06bd27ef60de8c ]---
<6>[  360.883195] usb 1-3: 4294982504 : Tx timeout(#1), bss_type-num = 0-0
<6>[  363.062297] usb 1-3: PREP_CMD: FW is in bad state
<6>[  363.062307] usb 1-3: failed to get signal information
<6>[  363.062352] usb 1-3: PREP_CMD: FW is in bad state
<6>[  363.062356] usb 1-3: failed to get signal information
<6>[  369.063002] usb 1-3: PREP_CMD: FW is in bad state
<6>[  369.063010] usb 1-3: failed to get signal information
<6>[  369.063045] usb 1-3: PREP_CMD: FW is in bad state
<6>[  369.063049] usb 1-3: failed to get signal information
<6>[  370.886854] usb 1-3: 4294985004 : Tx timeout(#2), bss_type-num = 0-0
<6>[  375.066955] usb 1-3: PREP_CMD: FW is in bad state
<6>[  375.066965] usb 1-3: failed to get signal information
<6>[  375.067009] usb 1-3: PREP_CMD: FW is in bad state
<6>[  375.067013] usb 1-3: failed to get signal information
<6>[  380.891109] usb 1-3: 4294987504 : Tx timeout(#3), bss_type-num = 0-0
<6>[  381.069916] usb 1-3: PREP_CMD: FW is in bad state
<6>[  381.069926] usb 1-3: failed to get signal information
<6>[  381.069970] usb 1-3: PREP_CMD: FW is in bad state
<6>[  381.069974] usb 1-3: failed to get signal information
<6>[  387.072885] usb 1-3: PREP_CMD: FW is in bad state
<6>[  387.072894] usb 1-3: failed to get signal information
<6>[  387.072938] usb 1-3: PREP_CMD: FW is in bad state
<6>[  387.072943] usb 1-3: failed to get signal information
<6>[  390.895346] usb 1-3: 4294990004 : Tx timeout(#4), bss_type-num = 0-0
<6>[  393.070238] usb 1-3: PREP_CMD: FW is in bad state
<6>[  393.070245] usb 1-3: failed to get signal information
<6>[  393.070277] usb 1-3: PREP_CMD: FW is in bad state
<6>[  393.070280] usb 1-3: failed to get signal information
<6>[  399.077176] usb 1-3: PREP_CMD: FW is in bad state
<6>[  399.077186] usb 1-3: failed to get signal information
<6>[  399.077230] usb 1-3: PREP_CMD: FW is in bad state
<6>[  399.077235] usb 1-3: failed to get signal information
<6>[  400.899581] usb 1-3: 4294992504 : Tx timeout(#5), bss_type-num = 0-0
<6>[  405.080123] usb 1-3: PREP_CMD: FW is in bad state
<6>[  405.080132] usb 1-3: failed to get signal information
<6>[  405.080172] usb 1-3: PREP_CMD: FW is in bad state
<6>[  405.080175] usb 1-3: failed to get signal information
<6>[  410.903836] usb 1-3: 4294995004 : Tx timeout(#6), bss_type-num = 0-0
<6>[  411.083056] usb 1-3: PREP_CMD: FW is in bad state
<6>[  411.083065] usb 1-3: failed to get signal information
<6>[  411.083104] usb 1-3: PREP_CMD: FW is in bad state
<6>[  411.083108] usb 1-3: failed to get signal information
<6>[  417.083250] usb 1-3: PREP_CMD: FW is in bad state
<6>[  417.083255] usb 1-3: failed to get signal information
<6>[  417.083277] usb 1-3: PREP_CMD: FW is in bad state
<6>[  417.083279] usb 1-3: failed to get signal information
<6>[  420.908067] usb 1-3: 4294997504 : Tx timeout(#7), bss_type-num = 0-0
<6>[  423.088158] usb 1-3: PREP_CMD: FW is in bad state
<6>[  423.088167] usb 1-3: failed to get signal information
<6>[  423.088206] usb 1-3: PREP_CMD: FW is in bad state
<6>[  423.088210] usb 1-3: failed to get signal information
<6>[  429.088417] usb 1-3: PREP_CMD: FW is in bad state
<6>[  429.088427] usb 1-3: failed to get signal information
<6>[  429.088471] usb 1-3: PREP_CMD: FW is in bad state
<6>[  429.088476] usb 1-3: failed to get signal information
<6>[  430.912295] usb 1-3: 4295000004 : Tx timeout(#8), bss_type-num = 0-0
<6>[  435.092366] usb 1-3: PREP_CMD: FW is in bad state
<6>[  435.092375] usb 1-3: failed to get signal information
<6>[  435.092414] usb 1-3: PREP_CMD: FW is in bad state
<6>[  435.092418] usb 1-3: failed to get signal information
<6>[  440.916557] usb 1-3: 4295002504 : Tx timeout(#9), bss_type-num = 0-0
<6>[  441.092959] usb 1-3: PREP_CMD: FW is in bad state
<6>[  441.092966] usb 1-3: failed to get signal information
<6>[  441.092996] usb 1-3: PREP_CMD: FW is in bad state
<6>[  441.092999] usb 1-3: failed to get signal information
<6>[  447.097925] usb 1-3: PREP_CMD: FW is in bad state
<6>[  447.097934] usb 1-3: failed to get signal information
<6>[  447.097974] usb 1-3: PREP_CMD: FW is in bad state
<6>[  447.097978] usb 1-3: failed to get signal information
<6>[  450.920787] usb 1-3: 4295005004 : Tx timeout(#10), bss_type-num = 0-0
<6>[  453.100865] usb 1-3: PREP_CMD: FW is in bad state
<6>[  453.100874] usb 1-3: failed to get signal information
<6>[  453.100914] usb 1-3: PREP_CMD: FW is in bad state
<6>[  453.100918] usb 1-3: failed to get signal information
<6>[  459.102825] usb 1-3: PREP_CMD: FW is in bad state
<6>[  459.102835] usb 1-3: failed to get signal information
<6>[  459.102879] usb 1-3: PREP_CMD: FW is in bad state
<6>[  459.102884] usb 1-3: failed to get signal information
<6>[  460.925009] usb 1-3: 4295007504 : Tx timeout(#11), bss_type-num = 0-0
<6>[  465.102699] usb 1-3: PREP_CMD: FW is in bad state
<6>[  465.102709] usb 1-3: failed to get signal information
<6>[  465.102822] usb 1-3: PREP_CMD: FW is in bad state
<6>[  465.102835] usb 1-3: failed to get signal information
<6>[  470.929266] usb 1-3: 4295010004 : Tx timeout(#12), bss_type-num = 0-0
<6>[  471.107749] usb 1-3: PREP_CMD: FW is in bad state
<6>[  471.107759] usb 1-3: failed to get signal information
<6>[  471.107803] usb 1-3: PREP_CMD: FW is in bad state
<6>[  471.107807] usb 1-3: failed to get signal information
<6>[  477.108166] usb 1-3: PREP_CMD: FW is in bad state
<6>[  477.108174] usb 1-3: failed to get signal information
<6>[  477.108210] usb 1-3: PREP_CMD: FW is in bad state
<6>[  477.108213] usb 1-3: failed to get signal information
<6>[  480.933506] usb 1-3: 4295012504 : Tx timeout(#13), bss_type-num = 0-0
<6>[  483.113029] usb 1-3: PREP_CMD: FW is in bad state
<6>[  483.113036] usb 1-3: failed to get signal information
<6>[  483.113065] usb 1-3: PREP_CMD: FW is in bad state
<6>[  483.113067] usb 1-3: failed to get signal information
<6>[  489.113838] usb 1-3: PREP_CMD: FW is in bad state
<6>[  489.113848] usb 1-3: failed to get signal information
<6>[  489.113893] usb 1-3: PREP_CMD: FW is in bad state
<6>[  489.113897] usb 1-3: failed to get signal information
<6>[  490.937730] usb 1-3: 4295015004 : Tx timeout(#14), bss_type-num = 0-0
<6>[  495.117807] usb 1-3: PREP_CMD: FW is in bad state
<6>[  495.117817] usb 1-3: failed to get signal information
<6>[  495.117861] usb 1-3: PREP_CMD: FW is in bad state
<6>[  495.117865] usb 1-3: failed to get signal information
<6>[  500.941981] usb 1-3: 4295017504 : Tx timeout(#15), bss_type-num = 0-0
<6>[  501.120761] usb 1-3: PREP_CMD: FW is in bad state
<6>[  501.120771] usb 1-3: failed to get signal information
<6>[  501.120814] usb 1-3: PREP_CMD: FW is in bad state
<6>[  501.120818] usb 1-3: failed to get signal information
<6>[  507.123686] usb 1-3: PREP_CMD: FW is in bad state
<6>[  507.123694] usb 1-3: failed to get signal information
<6>[  507.123730] usb 1-3: PREP_CMD: FW is in bad state
<6>[  507.123733] usb 1-3: failed to get signal information
<6>[  510.946225] usb 1-3: 4295020004 : Tx timeout(#16), bss_type-num = 0-0
<6>[  513.125492] usb 1-3: PREP_CMD: FW is in bad state
<6>[  513.125497] usb 1-3: failed to get signal information
<6>[  513.125532] usb 1-3: PREP_CMD: FW is in bad state
<6>[  513.125535] usb 1-3: failed to get signal information
<6>[  519.128429] usb 1-3: PREP_CMD: FW is in bad state
<6>[  519.128440] usb 1-3: failed to get signal information
<6>[  519.128484] usb 1-3: PREP_CMD: FW is in bad state
<6>[  519.128488] usb 1-3: failed to get signal information
<6>[  520.950439] usb 1-3: 4295022504 : Tx timeout(#17), bss_type-num = 0-0
<6>[  525.125664] usb 1-3: PREP_CMD: FW is in bad state
<6>[  525.125673] usb 1-3: failed to get signal information
<6>[  525.125717] usb 1-3: PREP_CMD: FW is in bad state
<6>[  525.125722] usb 1-3: failed to get signal information

--=-=-=--

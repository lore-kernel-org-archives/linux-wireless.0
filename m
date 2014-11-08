Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:33839 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbaKHRoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2014 12:44:39 -0500
Received: by mail-la0-f45.google.com with SMTP id pn19so5953723lab.18
        for <linux-wireless@vger.kernel.org>; Sat, 08 Nov 2014 09:44:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87d28zdplq.fsf@mat.ucm.es>
References: <87d28zdplq.fsf@mat.ucm.es>
Date: Sat, 8 Nov 2014 19:44:36 +0200
Message-ID: <CANUX_P0f0WAHoq3CsC3V-jp4m3_Q7qLz7X+Mvn1hk9_JPrPTGg@mail.gmail.com> (sfid-20141108_184539_474418_9717A35A)
Subject: Re: Thinkpad X60s/200s: Intel 3945/5100 works with kernel
 2.6.32-67/3.0.0-32 but not 3.7 vanilla.
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Uwe Brauer <oub@mat.ucm.es>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 7, 2014 at 4:58 PM, Uwe Brauer <oub@mat.ucm.es> wrote:
> Hello
>
> I am running Kubuntu 10.04 with either the 2.6.32 or the 3.0.0 kernels
> on both laptops and wireless works fine. Firmware is installed.
>
> I just compiled a vanilla 3.7.0 kernel and booted it and wireless does
> not work:
>
> ifconfig:
> pan0      Link encap:Ethernet  HWaddr ee:54:d8:73:82:0e
>           inet6 addr: fe80::ec54:d8ff:fe73:820e/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:38 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:0
>           RX bytes:0 (0.0 B)  TX bytes:6117 (6.1 KB)
>
>
> wlan0     Link encap:Ethernet  HWaddr 00:1e:65:dc:90:e0
>           UP BROADCAST MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>
> The wlan0 result is the same  for the 2.6.X kernels, I don't now what
> the pand0 device is supposed to be.
>
> Iwconfig:
> pan0      no wireless extensions.
>
> wlan0     no wireless extensions.
> iwlist scan
> pan0      Interface doesn't support scanning.
>
> wlan0     Interface doesn't support scanning.
>
> I attach the result of dmesg.

you problem is that you didn't compile the kernel with wireless
extensions. This interface is deprecated, but I don't remember if it
was the case for 3.7.
In any case, this is a problem in your config, not a driver issue.

>
>
> Since trace-cmd is not part of 10.04 I compiled it myself and run
>
> sudo ./trace-cmd record -e iwlwifi
> /sys/kernel/debug/tracing/events/iwlwifi/filter
> /sys/kernel/debug/tracing/events/*/iwlwifi/filter
> trace-cmd: No such file or directory
>   No events enabled with iwlwifi
>
> Not sure whether this is really helpful.
>
> I presume I have to set
>
> CONFIG_IWLWIFI_TRACING to y and compile the kernel again
>
> (What is the fastest way to find this option, make menuconfig does seem
> where intuitive) I presume I should set also CONFIG_IWLWIFI_DEBUGFS to
> true as well.
>
> I presume in make xconfig these options are in iwl3945
> and in the CONFIG_IWLWIFI_DEBUGFS
>
> BTW I have heard from other users that these cards are difficult to get
> to work with > kernel-3.2.
>
> regards
>
> Uwe Brauer
>
>
>
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.7.0 (root@Gilgamesch) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1) ) #1 SMP Tue Nov 4 13:53:34 CET 2014
> [    0.000000] Disabled fast string operations
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000dc000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000bd6a0fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bd6a1000-0x00000000bd6a6fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000bd6a7000-0x00000000bd7b6fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bd7b7000-0x00000000bd80efff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000bd80f000-0x00000000bd8c8fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bd8c9000-0x00000000bd8d3fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bd8d4000-0x00000000bd8d7fff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bd8d8000-0x00000000bd8d8fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000bd8d9000-0x00000000bd8dcfff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bd8dd000-0x00000000bd8dffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000bd8e0000-0x00000000bd906fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bd907000-0x00000000bd907fff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bd908000-0x00000000bdb0efff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000bdb0f000-0x00000000bdb9efff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000bdb9f000-0x00000000bdbfefff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000bdbff000-0x00000000bdbfffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000bdc00000-0x00000000bfffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed003ff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed8ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013bffffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI present.
> [    0.000000] DMI: LENOVO 74665GG/74665GG, BIOS 6DET58WW (3.08 ) 08/20/2009
> [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13c000 max_arch_pfn = 0x1000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-D3FFF write-protect
> [    0.000000]   D4000-DBFFF uncachable
> [    0.000000]   DC000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 13C000000 mask FFC000000 uncachable
> [    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
> [    0.000000]   2 base 000000000 mask F80000000 write-back
> [    0.000000]   3 base 080000000 mask FC0000000 write-back
> [    0.000000]   4 base 100000000 mask FC0000000 write-back
> [    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
> [    0.000000]   6 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820: update [mem 0xbde00000-0xffffffff] usable ==> reserved
> [    0.000000] found SMP MP-table at [mem 0x000f72e0-0x000f72ef] mapped at [c00f72e0]
> [    0.000000] initial memory mapped: [mem 0x00000000-0x00ffffff]
> [    0.000000] Base memory trampoline at [c009a000] 9a000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x37bfdfff]
> [    0.000000]  [mem 0x00000000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x379fffff] page 2M
> [    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
> [    0.000000] kernel direct mapping tables up to 0x37bfdfff @ [mem 0x00ffa000-0x00ffffff]
> [    0.000000] RAMDISK: [mem 0x372a8000-0x37feffff]
> [    0.000000] Allocated new RAMDISK: [mem 0x36560000-0x372a7d96]
> [    0.000000] Move RAMDISK from [mem 0x372a8000-0x37fefd96] to [mem 0x36560000-0x372a7d96]
> [    0.000000] ACPI: RSDP 000f72a0 00024 (v02 LENOVO)
> [    0.000000] ACPI: XSDT bdb5b771 0009C (v01 LENOVO TP-6D    00003080  LTP 00000000)
> [    0.000000] ACPI: FACP bdb5b900 000F4 (v03 LENOVO TP-6D    00003080 LNVO 00000001)
> [    0.000000] ACPI: DSDT bdb5bcf4 0DEE4 (v01 LENOVO TP-6D    00003080 MSFT 03000000)
> [    0.000000] ACPI: FACS bdb8e000 00040
> [    0.000000] ACPI: SSDT bdb5bab4 00240 (v01 LENOVO TP-6D    00003080 MSFT 03000000)
> [    0.000000] ACPI: ECDT bdb69bd8 00052 (v01 LENOVO TP-6D    00003080 LNVO 00000001)
> [    0.000000] ACPI: APIC bdb69c2a 00078 (v01 LENOVO TP-6D    00003080 LNVO 00000001)
> [    0.000000] ACPI: MCFG bdb69ca2 0003C (v01 LENOVO TP-6D    00003080 LNVO 00000001)
> [    0.000000] ACPI: HPET bdb69cde 00038 (v01 LENOVO TP-6D    00003080 LNVO 00000001)
> [    0.000000] ACPI: SLIC bdb69dc2 00176 (v01 LENOVO TP-6D    00003080  LTP 00000000)
> [    0.000000] ACPI: BOOT bdb69f38 00028 (v01 LENOVO TP-6D    00003080  LTP 00000001)
> [    0.000000] ACPI: ASF! bdb69f60 000A0 (v16 LENOVO TP-6D    00003080 PTL  00000001)
> [    0.000000] ACPI: SSDT bdb8d1ea 00578 (v01 LENOVO TP-6D    00003080 INTL 20050513)
> [    0.000000] ACPI: TCPA bd907000 00032 (v00                 00000000      00000000)
> [    0.000000] ACPI: SSDT bd8d7000 00286 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
> [    0.000000] ACPI: SSDT bd8d6000 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
> [    0.000000] ACPI: SSDT bd8d5000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
> [    0.000000] ACPI: SSDT bd8d4000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 4164MB HIGHMEM available.
> [    0.000000] 891MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 37bfe000
> [    0.000000]   low ram: 0 - 37bfe000
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
> [    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
> [    0.000000]   HighMem  [mem 0x37bfe000-0x3bffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00010000-0x0009dfff]
> [    0.000000]   node   0: [mem 0x00100000-0xbd6a0fff]
> [    0.000000]   node   0: [mem 0xbd6a7000-0xbd7b6fff]
> [    0.000000]   node   0: [mem 0xbd80f000-0xbd8c8fff]
> [    0.000000]   node   0: [mem 0xbdbff000-0xbdbfffff]
> [    0.000000]   node   0: [mem 0x00000000-0x3bffffff]
> [    0.000000] On node 0 totalpages: 1021946
> [    0.000000] free_area_init_node: node 0, pgdat c08e99c0, node_mem_map f3de0200
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3950 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1752 pages used for memmap
> [    0.000000]   Normal zone: 222502 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 8329 pages used for memmap
> [    0.000000]   HighMem zone: 785381 pages, LIFO batch:31
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 4 CPUs, 3 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
> [    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
> [    0.000000] e820: [mem 0xc0000000-0xdfffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 14 pages/cpu @f7bb2000 s34560 r0 d22784 u57344
> [    0.000000] pcpu-alloc: s34560 r0 d22784 u57344 alloc=14*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1011833
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.7.0 root=UUID=ebd02cc8-1468-40ef-81b4-f5cc18cbde39 ro quiet splash
> [    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] __ex_table already sorted, skipping sort
> [    0.000000] Initializing CPU#0
> [    0.000000] xsave: enabled xstate_bv 0x3, cntxt size 0x240
> [    0.000000] Initializing HighMem for node 0 (00037bfe:0013c000)
> [    0.000000] Memory: 4023120k/5177344k available (5613k kernel code, 64664k reserved, 2527k data, 736k init, 3174840k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
> [    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
> [    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
> [    0.000000]       .init : 0xc08f4000 - 0xc09ac000   ( 736 kB)
> [    0.000000]       .data : 0xc067b555 - 0xc08f34c0   (2527 kB)
> [    0.000000]       .text : 0xc0100000 - 0xc067b555   (5613 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
> [    0.000000] NR_IRQS:2304 nr_irqs:712 16
> [    0.000000] CPU 0 irqstacks, hard=f7408000 soft=f740a000
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.000000] tsc: Detected 1396.558 MHz processor
> [    0.004002] Calibrating delay loop (skipped), value calculated using timer frequency.. 2793.11 BogoMIPS (lpj=5586232)
> [    0.004007] pid_max: default: 32768 minimum: 301
> [    0.004055] Security Framework initialized
> [    0.004065] AppArmor: AppArmor initialized
> [    0.004079] Mount-cache hash table entries: 512
> [    0.004440] Initializing cgroup subsys cpuacct
> [    0.004444] Initializing cgroup subsys devices
> [    0.004447] Initializing cgroup subsys freezer
> [    0.004449] Initializing cgroup subsys net_cls
> [    0.004486] Disabled fast string operations
> [    0.004494] mce: CPU supports 6 MCE banks
> [    0.004504] CPU0: Thermal monitoring enabled (TM2)
> [    0.004508] process: using mwait in idle threads
> [    0.004520] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
> [    0.004520] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
> [    0.004520] tlb_flushall_shift: -1
> [    0.021956] ACPI: Core revision 20120913
> [    0.036016] ftrace: allocating 22755 entries in 45 pages
> [    0.048067] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.048524] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.091064] smpboot: CPU0: Intel(R) Core(TM)2 Solo CPU    U3500  @ 1.40GHz (fam: 06, model: 17, stepping: 0a)
> [    0.092000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
> [    0.092000] ... version:                2
> [    0.092000] ... bit width:              40
> [    0.092000] ... generic registers:      2
> [    0.092000] ... value mask:             000000ffffffffff
> [    0.092000] ... max period:             000000007fffffff
> [    0.092000] ... fixed-purpose events:   3
> [    0.092000] ... event mask:             0000000700000003
> [    0.092000] Brought up 1 CPUs
> [    0.092000] smpboot: Total of 1 processors activated (2793.11 BogoMIPS)
> [    0.092000] devtmpfs: initialized
> [    0.092000] PM: Registering ACPI NVS region [mem 0xbd8c9000-0xbd8d3fff] (45056 bytes)
> [    0.092000] PM: Registering ACPI NVS region [mem 0xbd8d9000-0xbd8dcfff] (16384 bytes)
> [    0.092000] PM: Registering ACPI NVS region [mem 0xbd8e0000-0xbd906fff] (159744 bytes)
> [    0.092000] PM: Registering ACPI NVS region [mem 0xbdb0f000-0xbdb9efff] (589824 bytes)
> [    0.092000] regulator-dummy: no parameters
> [    0.092000] RTC time: 14:56:04, date: 11/06/14
> [    0.092000] NET: Registered protocol family 16
> [    0.092000] EISA bus registered
> [    0.092000] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    0.092000] ACPI: bus type pci registered
> [    0.092000] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
> [    0.092000] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
> [    0.092000] PCI: Using MMCONFIG for extended config space
> [    0.092000] PCI: Using configuration type 1 for base access
> [    0.093244] bio: create slab <bio-0> at 0
> [    0.093336] ACPI: Added _OSI(Module Device)
> [    0.093339] ACPI: Added _OSI(Processor Device)
> [    0.093342] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.093345] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.095710] ACPI: EC: EC description table is found, configuring boot EC
> [    0.105459] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.116253] ACPI: Interpreter enabled
> [    0.116265] ACPI: (supports S0 S3 S4 S5)
> [    0.116294] ACPI: Using IOAPIC for interrupt routing
> [    0.132276] ACPI: Power Resource [PUBS] (on)
> [    0.137128] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
> [    0.140227] ACPI: ACPI Dock Station Driver: 3 docks/bays found
> [    0.140235] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.140548] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.140595] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
> [    0.140643] PCI host bridge to bus 0000:00
> [    0.140648] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.140652] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.140655] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.140659] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.140662] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
> [    0.140665] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
> [    0.140669] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff]
> [    0.140684] pci 0000:00:00.0: [8086:2a40] type 00 class 0x060000
> [    0.140748] pci 0000:00:02.0: [8086:2a42] type 00 class 0x030000
> [    0.140767] pci 0000:00:02.0: reg 10: [mem 0xf2000000-0xf23fffff 64bit]
> [    0.140779] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
> [    0.140788] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
> [    0.140840] pci 0000:00:02.1: [8086:2a43] type 00 class 0x038000
> [    0.140856] pci 0000:00:02.1: reg 10: [mem 0xf2400000-0xf24fffff 64bit]
> [    0.140928] pci 0000:00:03.0: [8086:2a44] type 00 class 0x078000
> [    0.140950] pci 0000:00:03.0: reg 10: [mem 0xf2826800-0xf282680f 64bit]
> [    0.141020] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
> [    0.141047] pci 0000:00:03.3: [8086:2a47] type 00 class 0x070002
> [    0.141066] pci 0000:00:03.3: reg 10: [io  0x1830-0x1837]
> [    0.141077] pci 0000:00:03.3: reg 14: [mem 0xf2624000-0xf2624fff]
> [    0.141216] pci 0000:00:19.0: [8086:10f5] type 00 class 0x020000
> [    0.141247] pci 0000:00:19.0: reg 10: [mem 0xf2600000-0xf261ffff]
> [    0.141261] pci 0000:00:19.0: reg 14: [mem 0xf2625000-0xf2625fff]
> [    0.141276] pci 0000:00:19.0: reg 18: [io  0x1840-0x185f]
> [    0.141383] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
> [    0.141418] pci 0000:00:1a.0: [8086:2937] type 00 class 0x0c0300
> [    0.141485] pci 0000:00:1a.0: reg 20: [io  0x1860-0x187f]
> [    0.141569] pci 0000:00:1a.1: [8086:2938] type 00 class 0x0c0300
> [    0.141638] pci 0000:00:1a.1: reg 20: [io  0x1880-0x189f]
> [    0.141722] pci 0000:00:1a.2: [8086:2939] type 00 class 0x0c0300
> [    0.141789] pci 0000:00:1a.2: reg 20: [io  0x18a0-0x18bf]
> [    0.141887] pci 0000:00:1a.7: [8086:293c] type 00 class 0x0c0320
> [    0.141918] pci 0000:00:1a.7: reg 10: [mem 0xf2826c00-0xf2826fff]
> [    0.142050] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    0.142094] pci 0000:00:1b.0: [8086:293e] type 00 class 0x040300
> [    0.142120] pci 0000:00:1b.0: reg 10: [mem 0xf2620000-0xf2623fff 64bit]
> [    0.142237] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.142277] pci 0000:00:1c.0: [8086:2940] type 01 class 0x060400
> [    0.142401] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.142446] pci 0000:00:1c.1: [8086:2942] type 01 class 0x060400
> [    0.142569] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.142613] pci 0000:00:1c.3: [8086:2946] type 01 class 0x060400
> [    0.142736] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.142783] pci 0000:00:1d.0: [8086:2934] type 00 class 0x0c0300
> [    0.142851] pci 0000:00:1d.0: reg 20: [io  0x18c0-0x18df]
> [    0.142935] pci 0000:00:1d.1: [8086:2935] type 00 class 0x0c0300
> [    0.143002] pci 0000:00:1d.1: reg 20: [io  0x18e0-0x18ff]
> [    0.143086] pci 0000:00:1d.2: [8086:2936] type 00 class 0x0c0300
> [    0.143154] pci 0000:00:1d.2: reg 20: [io  0x1c00-0x1c1f]
> [    0.143251] pci 0000:00:1d.7: [8086:293a] type 00 class 0x0c0320
> [    0.143283] pci 0000:00:1d.7: reg 10: [mem 0xf2827000-0xf28273ff]
> [    0.143415] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.143451] pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
> [    0.143562] pci 0000:00:1f.0: [8086:2917] type 00 class 0x060100
> [    0.143757] pci 0000:00:1f.2: [8086:2929] type 00 class 0x010601
> [    0.143791] pci 0000:00:1f.2: reg 10: [io  0x1c48-0x1c4f]
> [    0.143805] pci 0000:00:1f.2: reg 14: [io  0x183c-0x183f]
> [    0.143820] pci 0000:00:1f.2: reg 18: [io  0x1c40-0x1c47]
> [    0.143833] pci 0000:00:1f.2: reg 1c: [io  0x1838-0x183b]
> [    0.143848] pci 0000:00:1f.2: reg 20: [io  0x1c20-0x1c3f]
> [    0.143862] pci 0000:00:1f.2: reg 24: [mem 0xf2826000-0xf28267ff]
> [    0.143947] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.143980] pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500
> [    0.144012] pci 0000:00:1f.3: reg 10: [mem 0xf2827400-0xf28274ff 64bit]
> [    0.144049] pci 0000:00:1f.3: reg 20: [io  0x1c60-0x1c7f]
> [    0.144165] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.144315] pci 0000:03:00.0: [8086:4237] type 00 class 0x028000
> [    0.144386] pci 0000:03:00.0: reg 10: [mem 0xf2500000-0xf2501fff 64bit]
> [    0.144630] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> [    0.144770] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.144780] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
> [    0.144857] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
> [    0.144864] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> [    0.144870] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
> [    0.144881] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
> [    0.144988] pci 0000:00:1e.0: PCI bridge to [bus 0d] (subtractive decode)
> [    0.145004] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
> [    0.145008] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
> [    0.145012] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
> [    0.145015] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
> [    0.145019] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
> [    0.145022] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xfebfffff] (subtractive decode)
> [    0.145053] pci_bus 0000:00: on NUMA node 0
> [    0.145058] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.145270] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
> [    0.145325] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
> [    0.145381] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
> [    0.145754]  pci0000:00: Requesting ACPI _OSC control (0x1d)
> [    0.146249]  pci0000:00: ACPI _OSC control (0x1d) granted
> [    0.153226] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.153338] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.153448] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.153557] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.153665] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.153774] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.153883] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.153992] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
> [    0.154147] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.154154] vgaarb: loaded
> [    0.154156] vgaarb: bridge control possible 0000:00:02.0
> [    0.154293] SCSI subsystem initialized
> [    0.154297] ACPI: bus type scsi registered
> [    0.154347] libata version 3.00 loaded.
> [    0.154384] ACPI: bus type usb registered
> [    0.154417] usbcore: registered new interface driver usbfs
> [    0.154436] usbcore: registered new interface driver hub
> [    0.154468] usbcore: registered new device driver usb
> [    0.154850] wmi: Mapper loaded
> [    0.154852] PCI: Using ACPI for IRQ routing
> [    0.157637] PCI: pci_cache_line_size set to 64 bytes
> [    0.157736] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
> [    0.157739] e820: reserve RAM buffer [mem 0xbd6a1000-0xbfffffff]
> [    0.157744] e820: reserve RAM buffer [mem 0xbd7b7000-0xbfffffff]
> [    0.157748] e820: reserve RAM buffer [mem 0xbd8c9000-0xbfffffff]
> [    0.157753] e820: reserve RAM buffer [mem 0xbdc00000-0xbfffffff]
> [    0.157893] NetLabel: Initializing
> [    0.157895] NetLabel:  domain hash size = 128
> [    0.157897] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.157911] NetLabel:  unlabeled traffic allowed by default
> [    0.158049] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
> [    0.158057] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [    0.158064] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
> [    0.160016] Switching to clocksource hpet
> [    0.163570] AppArmor: AppArmor Filesystem Enabled
> [    0.163594] pnp: PnP ACPI init
> [    0.163608] ACPI: bus type pnp registered
> [    0.184625] pnp 00:00: [mem 0x00000000-0x0009ffff]
> [    0.184630] pnp 00:00: [mem 0x000c0000-0x000c3fff]
> [    0.184633] pnp 00:00: [mem 0x000c4000-0x000c7fff]
> [    0.184637] pnp 00:00: [mem 0x000c8000-0x000cbfff]
> [    0.184640] pnp 00:00: [mem 0x000cc000-0x000cffff]
> [    0.184643] pnp 00:00: [mem 0x000d0000-0x000d3fff]
> [    0.184647] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
> [    0.184650] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
> [    0.184653] pnp 00:00: [mem 0x000dc000-0x000dffff]
> [    0.184657] pnp 00:00: [mem 0x000e0000-0x000e3fff]
> [    0.184660] pnp 00:00: [mem 0x000e4000-0x000e7fff]
> [    0.184663] pnp 00:00: [mem 0x000e8000-0x000ebfff]
> [    0.184666] pnp 00:00: [mem 0x000ec000-0x000effff]
> [    0.184669] pnp 00:00: [mem 0x000f0000-0x000fffff]
> [    0.184673] pnp 00:00: [mem 0x00100000-0xbfffffff]
> [    0.184676] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
> [    0.184679] pnp 00:00: [mem 0xfed4c000-0xffffffff]
> [    0.184748] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
> [    0.184753] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
> [    0.184757] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
> [    0.184762] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
> [    0.184766] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
> [    0.184770] system 00:00: [mem 0x000d0000-0x000d3fff] could not be reserved
> [    0.184774] system 00:00: [mem 0x000dc000-0x000dffff] could not be reserved
> [    0.184778] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
> [    0.184782] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
> [    0.184787] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
> [    0.184791] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
> [    0.184795] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
> [    0.184799] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
> [    0.184804] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
> [    0.184808] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
> [    0.184813] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.184847] pnp 00:01: [bus 00-ff]
> [    0.184851] pnp 00:01: [io  0x0cf8-0x0cff]
> [    0.184854] pnp 00:01: [io  0x0000-0x0cf7 window]
> [    0.184858] pnp 00:01: [io  0x0d00-0xffff window]
> [    0.184862] pnp 00:01: [mem 0x000a0000-0x000bffff window]
> [    0.184865] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
> [    0.184869] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
> [    0.184872] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
> [    0.184879] pnp 00:01: [mem 0x000cc000-0x000cffff window]
> [    0.184882] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
> [    0.184885] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
> [    0.184889] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
> [    0.184892] pnp 00:01: [mem 0x000dc000-0x000dffff window]
> [    0.184896] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
> [    0.184899] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
> [    0.184903] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
> [    0.184907] pnp 00:01: [mem 0x000ec000-0x000effff window]
> [    0.184910] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
> [    0.184914] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
> [    0.184960] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
> [    0.205380] pnp 00:02: [io  0x0010-0x001f]
> [    0.205385] pnp 00:02: [io  0x0090-0x009f]
> [    0.205388] pnp 00:02: [io  0x0024-0x0025]
> [    0.205391] pnp 00:02: [io  0x0028-0x0029]
> [    0.205394] pnp 00:02: [io  0x002c-0x002d]
> [    0.205398] pnp 00:02: [io  0x0030-0x0031]
> [    0.205401] pnp 00:02: [io  0x0034-0x0035]
> [    0.205404] pnp 00:02: [io  0x0038-0x0039]
> [    0.205407] pnp 00:02: [io  0x003c-0x003d]
> [    0.205410] pnp 00:02: [io  0x00a4-0x00a5]
> [    0.205413] pnp 00:02: [io  0x00a8-0x00a9]
> [    0.205417] pnp 00:02: [io  0x00ac-0x00ad]
> [    0.205420] pnp 00:02: [io  0x00b0-0x00b5]
> [    0.205423] pnp 00:02: [io  0x00b8-0x00b9]
> [    0.205426] pnp 00:02: [io  0x00bc-0x00bd]
> [    0.205429] pnp 00:02: [io  0x0050-0x0053]
> [    0.205432] pnp 00:02: [io  0x0072-0x0077]
> [    0.205436] pnp 00:02: [io  0x002e-0x002f]
> [    0.205439] pnp 00:02: [io  0x1000-0x107f]
> [    0.205442] pnp 00:02: [io  0x1180-0x11ff]
> [    0.205445] pnp 00:02: [io  0x0800-0x080f]
> [    0.205449] pnp 00:02: [io  0x15e0-0x15ef]
> [    0.205452] pnp 00:02: [io  0x1600-0x167f]
> [    0.205455] pnp 00:02: [io  0x1680-0x169f]
> [    0.205459] pnp 00:02: [mem 0xe0000000-0xefffffff]
> [    0.205462] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
> [    0.205465] pnp 00:02: [mem 0xfed10000-0xfed13fff]
> [    0.205469] pnp 00:02: [mem 0xfed18000-0xfed18fff]
> [    0.205472] pnp 00:02: [mem 0xfed19000-0xfed19fff]
> [    0.205475] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
> [    0.205566] system 00:02: [io  0x1000-0x107f] has been reserved
> [    0.205570] system 00:02: [io  0x1180-0x11ff] has been reserved
> [    0.205575] system 00:02: [io  0x0800-0x080f] has been reserved
> [    0.205579] system 00:02: [io  0x15e0-0x15ef] has been reserved
> [    0.205583] system 00:02: [io  0x1600-0x167f] has been reserved
> [    0.205587] system 00:02: [io  0x1680-0x169f] has been reserved
> [    0.205592] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
> [    0.205596] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.205601] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
> [    0.205605] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.205609] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.205613] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
> [    0.205619] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.205677] pnp 00:03: [mem 0xfed00000-0xfed003ff]
> [    0.205711] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.205726] pnp 00:04: [io  0x0000-0x000f]
> [    0.205730] pnp 00:04: [io  0x0080-0x008f]
> [    0.205733] pnp 00:04: [io  0x00c0-0x00df]
> [    0.205736] pnp 00:04: [dma 4]
> [    0.205768] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.205782] pnp 00:05: [io  0x0061]
> [    0.205816] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
> [    0.205830] pnp 00:06: [io  0x00f0]
> [    0.205843] pnp 00:06: [irq 13]
> [    0.205875] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.205889] pnp 00:07: [io  0x0070-0x0071]
> [    0.205896] pnp 00:07: [irq 8]
> [    0.205929] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.205943] pnp 00:08: [io  0x0060]
> [    0.205946] pnp 00:08: [io  0x0064]
> [    0.205953] pnp 00:08: [irq 1]
> [    0.205985] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.206003] pnp 00:09: [irq 12]
> [    0.206040] pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
> [    0.226449] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
> [    0.226491] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
> [    0.227079] pnp: PnP ACPI: found 11 devices
> [    0.227082] ACPI: ACPI bus type pnp unregistered
> [    0.227085] PnPBIOS: Disabled by ACPI PNP
> [    0.263986] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
> [    0.263994] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
> [    0.263998] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
> [    0.264022] pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
> [    0.264028] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
> [    0.264058] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
> [    0.264062] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
> [    0.264067] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
> [    0.264071] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    0.264074] pci 0000:00:1c.1: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
> [    0.264082] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
> [    0.264088] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
> [    0.264094] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
> [    0.264100] pci 0000:00:1c.0: BAR 13: assigned [io  0x3000-0x3fff]
> [    0.264106] pci 0000:00:1c.1: BAR 13: assigned [io  0x4000-0x4fff]
> [    0.264111] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.264117] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
> [    0.264125] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
> [    0.264132] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
> [    0.264141] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.264146] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
> [    0.264154] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
> [    0.264161] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
> [    0.264171] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
> [    0.264176] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> [    0.264184] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
> [    0.264191] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
> [    0.264200] pci 0000:00:1e.0: PCI bridge to [bus 0d]
> [    0.264259] pci 0000:00:1e.0: setting latency timer to 64
> [    0.264264] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.264268] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.264272] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.264275] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
> [    0.264278] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
> [    0.264282] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
> [    0.264286] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
> [    0.264289] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
> [    0.264293] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
> [    0.264296] pci_bus 0000:03: resource 0 [io  0x4000-0x4fff]
> [    0.264300] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
> [    0.264303] pci_bus 0000:03: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
> [    0.264307] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
> [    0.264310] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
> [    0.264314] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
> [    0.264318] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
> [    0.264321] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
> [    0.264325] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.264328] pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
> [    0.264331] pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
> [    0.264335] pci_bus 0000:0d: resource 9 [mem 0xc0000000-0xfebfffff]
> [    0.264381] NET: Registered protocol family 2
> [    0.264619] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.265109] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.265342] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.265376] TCP: reno registered
> [    0.265380] UDP hash table entries: 512 (order: 2, 16384 bytes)
> [    0.265391] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> [    0.265476] NET: Registered protocol family 1
> [    0.265495] pci 0000:00:02.0: Boot video device
> [    0.265517] pci 0000:00:1a.0: power state changed by ACPI to D0
> [    0.265575] pci 0000:00:1a.2: power state changed by ACPI to D0
> [    0.265662] pci 0000:00:1d.0: power state changed by ACPI to D0
> [    0.265807] PCI: CLS 64 bytes, default 64
> [    0.265858] Trying to unpack rootfs image as initramfs...
> [    0.761882] Freeing initrd memory: 13600k freed
> [    0.769715] Simple Boot Flag at 0x35 set to 0x1
> [    0.770075] audit: initializing netlink socket (disabled)
> [    0.770096] type=2000 audit(1415285764.768:1): initialized
> [    0.808663] bounce pool size: 64 pages
> [    0.808670] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.810896] VFS: Disk quotas dquot_6.5.2
> [    0.810970] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    0.811766] fuse init (API version 7.20)
> [    0.811888] msgmni has been set to 1683
> [    0.812208] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    0.812212] io scheduler noop registered
> [    0.812215] io scheduler deadline registered
> [    0.812222] io scheduler cfq registered (default)
> [    0.812445] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
> [    0.812647] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
> [    0.812841] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
> [    0.813013] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
> [    0.813021] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
> [    0.813049] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
> [    0.813053] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
> [    0.813059] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
> [    0.813090] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
> [    0.813097] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
> [    0.813108] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.813207] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 2940 ss_vid 17aa ss_did 20f3
> [    0.813237] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
> [    0.813254] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2942 ss_vid 17aa ss_did 20f3
> [    0.813284] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
> [    0.813302] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2946 ss_vid 17aa ss_did 20f3
> [    0.813329] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
> [    0.813339] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.813625] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
> [    0.813808] ACPI: AC Adapter [AC] (on-line)
> [    0.814037] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
> [    0.814275] ACPI: Lid Switch [LID]
> [    0.814336] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
> [    0.814342] ACPI: Sleep Button [SLPB]
> [    0.814406] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [    0.814411] ACPI: Power Button [PWRF]
> [    0.814658] ACPI: Requesting acpi_cpufreq
> [    0.818470] Monitor-Mwait will be used to enter C-1 state
> [    0.820032] Monitor-Mwait will be used to enter C-2 state
> [    0.820039] Monitor-Mwait will be used to enter C-3 state
> [    0.820043] tsc: Marking TSC unstable due to TSC halts in idle
> [    0.820055] ACPI: acpi_idle registered with cpuidle
> [    0.908351] thermal LNXTHERM:00: registered as thermal_zone0
> [    0.908355] ACPI: Thermal Zone [THM0] (48 C)
> [    0.909512] thermal LNXTHERM:01: registered as thermal_zone1
> [    0.909516] ACPI: Thermal Zone [THM1] (50 C)
> [    0.909693] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
> [    0.909705] ACPI: Battery Slot [BAT0] (battery absent)
> [    0.909741] isapnp: Scanning for PnP cards...
> [    1.264204] isapnp: No Plug & Play device found
> [    1.264229] XENFS: not registering filesystem on non-xen platform
> [    1.264298] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    1.285138] 0000:00:03.3: ttyS0 at I/O 0x1830 (irq = 17) is a 16550A
> [    1.287153] brd: module loaded
> [    1.288154] loop: module loaded
> [    1.288914] libphy: Fixed MDIO Bus: probed
> [    1.288957] tun: Universal TUN/TAP device driver, 1.6
> [    1.288959] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    1.289007] PPP generic driver version 2.4.2
> [    1.289109] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    1.289141] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [    1.289147] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    1.289195] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
> [    1.293122] ehci_hcd 0000:00:1a.7: debug port 1
> [    1.293134] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
> [    1.293163] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
> [    1.304017] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    1.304205] hub 1-0:1.0: USB hub found
> [    1.304212] hub 1-0:1.0: 6 ports detected
> [    1.304896] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    1.304901] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    1.304952] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
> [    1.308869] ehci_hcd 0000:00:1d.7: debug port 1
> [    1.308880] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
> [    1.308905] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
> [    1.309827] Monitor-Mwait will be used to enter C-3 state
> [    1.320018] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    1.320203] hub 2-0:1.0: USB hub found
> [    1.320209] hub 2-0:1.0: 6 ports detected
> [    1.320877] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    1.320894] uhci_hcd: USB Universal Host Controller Interface driver
> [    1.320919] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    1.320924] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    1.320980] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
> [    1.321027] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
> [    1.321214] hub 3-0:1.0: USB hub found
> [    1.321220] hub 3-0:1.0: 2 ports detected
> [    1.321402] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [    1.321408] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    1.321459] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
> [    1.321505] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
> [    1.321682] hub 4-0:1.0: USB hub found
> [    1.321688] hub 4-0:1.0: 2 ports detected
> [    1.321867] uhci_hcd 0000:00:1a.2: setting latency timer to 64
> [    1.321872] uhci_hcd 0000:00:1a.2: UHCI Host Controller
> [    1.321920] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
> [    1.321966] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
> [    1.322149] hub 5-0:1.0: USB hub found
> [    1.322155] hub 5-0:1.0: 2 ports detected
> [    1.322338] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    1.322343] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    1.322392] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
> [    1.322437] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
> [    1.322626] hub 6-0:1.0: USB hub found
> [    1.322632] hub 6-0:1.0: 2 ports detected
> [    1.322814] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    1.322819] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    1.322866] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
> [    1.322911] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
> [    1.323087] hub 7-0:1.0: USB hub found
> [    1.323093] hub 7-0:1.0: 2 ports detected
> [    1.323271] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    1.323276] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    1.323325] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
> [    1.323369] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
> [    1.323545] hub 8-0:1.0: USB hub found
> [    1.323551] hub 8-0:1.0: 2 ports detected
> [    1.323809] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    1.334460] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.334468] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    1.334615] mousedev: PS/2 mouse device common for all mice
> [    1.334791] rtc_cmos 00:07: RTC can wake from S4
> [    1.334953] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
> [    1.334988] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    1.335090] device-mapper: uevent: version 1.0.3
> [    1.335177] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
> [    1.335233] device-mapper: multipath: version 1.5.0 loaded
> [    1.335236] device-mapper: multipath round-robin: version 1.0.0 loaded
> [    1.335331] EISA: Probing bus 0 at eisa.0
> [    1.335334] EISA: Cannot allocate resource for mainboard
> [    1.335337] Cannot allocate resource for EISA slot 1
> [    1.335340] Cannot allocate resource for EISA slot 2
> [    1.335343] Cannot allocate resource for EISA slot 3
> [    1.335346] Cannot allocate resource for EISA slot 4
> [    1.335348] Cannot allocate resource for EISA slot 5
> [    1.335351] Cannot allocate resource for EISA slot 6
> [    1.335354] Cannot allocate resource for EISA slot 7
> [    1.335356] Cannot allocate resource for EISA slot 8
> [    1.335358] EISA: Detected 0 cards.
> [    1.335373] cpufreq-nforce2: No nForce2 chipset.
> [    1.335403] cpuidle: using governor ladder
> [    1.335440] cpuidle: using governor menu
> [    1.335442] EFI Variables Facility v0.08 2004-May-17
> [    1.335602] TCP: cubic registered
> [    1.335759] NET: Registered protocol family 10
> [    1.336063] NET: Registered protocol family 17
> [    1.336288] Using IPI No-Shortcut mode
> [    1.336390] PM: Hibernation image not present or could not be loaded.
> [    1.336408] registered taskstats version 1
> [    1.336855]   Magic number: 6:855:939
> [    1.336942] rtc_cmos 00:07: setting system clock to 2014-11-06 14:56:06 UTC (1415285766)
> [    1.338165] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    1.338169] EDD information not available.
> [    1.338433] Freeing unused kernel memory: 736k freed
> [    1.338859] Write protecting the kernel text: 5616k
> [    1.338931] Write protecting the kernel read-only data: 2168k
> [    1.338933] NX-protecting the kernel data: 3600k
> [    1.341212] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
> [    1.369674] udev: starting version 151
> [    1.369734] udevd (60): /proc/60/oom_adj is deprecated, please use /proc/60/oom_score_adj instead.
> [    1.548231] Linux agpgart interface v0.103
> [    1.567484] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
> [    1.567631] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
> [    1.568428] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
> [    1.568431] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
> [    1.572254] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
> [    1.577517] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> [    1.577723] e1000e 0000:00:19.0: setting latency timer to 64
> [    1.577832] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [    1.577892] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> [    1.653728] [drm] Initialized drm 1.1.0 20060810
> [    1.728051] usb 1-6: new high-speed USB device number 3 using ehci_hcd
> [    1.760610] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:1f:16:28:68:fc
> [    1.760616] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
> [    1.760650] e1000e 0000:00:19.0 eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
> [    1.760682] ahci 0000:00:1f.2: version 3.0
> [    1.760770] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
> [    1.760837] ahci: SSS flag set, parallel bus scan disabled
> [    1.760875] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
> [    1.760881] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs
> [    1.760889] ahci 0000:00:1f.2: setting latency timer to 64
> [    1.762670] scsi0 : ahci
> [    1.762862] scsi1 : ahci
> [    1.763034] scsi2 : ahci
> [    1.763202] scsi3 : ahci
> [    1.763286] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 44
> [    1.763291] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 44
> [    1.763294] ata3: DUMMY
> [    1.763296] ata4: DUMMY
> [    1.763942] i915 0000:00:02.0: setting latency timer to 64
> [    1.764316] i915 0000:00:02.0: irq 45 for MSI/MSI-X
> [    1.764331] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    1.764333] [drm] Driver supports precise vblank timestamp query.
> [    1.764388] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    2.019324] usb 2-2: new high-speed USB device number 2 using ehci_hcd
> [    2.108062] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.111399] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    2.111405] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    2.111410] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [    2.111592] ata1.00: supports DRM functions and may not be fully accessible
> [    2.111639] ata1.00: ATA-9: Samsung SSD 840 EVO 250GB, EXT0BB6Q, max UDMA/133
> [    2.111644] ata1.00: 488397168 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
> [    2.113394] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    2.113400] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    2.113405] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> [    2.113573] ata1.00: supports DRM functions and may not be fully accessible
> [    2.113664] ata1.00: configured for UDMA/133
> [    2.113835] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD 840  EXT0 PQ: 0 ANSI: 5
> [    2.114339] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
> [    2.114447] sd 0:0:0:0: [sda] Write Protect is off
> [    2.114453] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.114488] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    2.115001] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    2.115711]  sda: sda1 sda2 sda3 < sda5 sda6 >
> [    2.119045] sd 0:0:0:0: [sda] Attached SCSI disk
> [    2.175049] fbcon: inteldrmfb (fb0) is primary device
> [    2.400041] usb 4-2: new full-speed USB device number 2 using uhci_hcd
> [    2.432050] ata2: SATA link down (SStatus 0 SControl 300)
> [    2.115465] ACPI: Invalid Power Resource to register!
> [    2.682620] Console: switching to colour frame buffer device 160x50
> [    2.689103] fb0: inteldrmfb frame buffer device
> [    2.689105] drm: registered panic notifier
> [    2.695165] acpi device:02: registered as cooling_device1
> [    2.695277] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> [    2.695609] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
> [    2.695920] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [    3.295775] JFS: nTxBlock = 8192, nTxLock = 65536
> [    3.606210] Adding 16600060k swap on /dev/sda6.  Priority:-1 extents:1 across:16600060k SS
> [    3.739493] udev: starting version 151
> [    3.854067] lp: driver loaded but no devices found
> [    4.078947] Non-volatile memory driver v1.3
> [    4.108517] tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
> [    4.108524] tpm_tis 00:0a: Intel iTPM workaround enabled
> [    4.252044] tpm_tis 00:0a: TPM is disabled/deactivated (0x6)
> [    4.335413] ACPI Warning: 0x00001028-0x0000102f SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1 (20120913/utaddress-251)
> [    4.335425] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    4.335431] ACPI Warning: 0x000011b0-0x000011bf SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20120913/utaddress-251)
> [    4.335438] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    4.335441] ACPI Warning: 0x00001180-0x000011af SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20120913/utaddress-251)
> [    4.335447] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    4.335450] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [    4.432751] cfg80211: Calling CRDA to update world regulatory domain
> [    4.437745] microcode: CPU0 sig=0x1067a, pf=0x80, revision=0xa07
> [    4.470806] Intel(R) Wireless WiFi driver for Linux, in-tree:
> [    4.470812] Copyright(c) 2003-2012 Intel Corporation
> [    4.470908] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
> [    4.470913] iwlwifi 0000:03:00.0: pci_resource_base = f84f4000
> [    4.470916] iwlwifi 0000:03:00.0: HW Revision ID = 0x0
> [    4.471011] iwlwifi 0000:03:00.0: irq 46 for MSI/MSI-X
> [    4.471408] iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1 build 33692
> [    4.635441] cfg80211: World regulatory domain updated:
> [    4.635447] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [    4.635450] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [    4.635454] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [    4.635458] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [    4.635461] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [    4.635464] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [    4.714721] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    4.771064] Bluetooth: Core ver 2.16
> [    4.771098] NET: Registered protocol family 31
> [    4.771101] Bluetooth: HCI device and connection manager initialized
> [    4.771111] Bluetooth: HCI socket layer initialized
> [    4.771115] Bluetooth: L2CAP socket layer initialized
> [    4.771124] Bluetooth: SCO socket layer initialized
> [    4.800477] usbcore: registered new interface driver btusb
> [    4.807025] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
> [    4.809406] kvm: disabled by bios
> [    4.902443] iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
> [    4.902450] iwldvm: Copyright(c) 2003-2012 Intel Corporation
> [    4.902484] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
> [    4.902488] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
> [    4.902491] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> [    4.902495] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
> [    4.902498] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P enabled
> [    4.902502] iwlwifi 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
> [    4.902588] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [    4.934003] iwlwifi 0000:03:00.0: device EEPROM VER=0x11f, CALIB=0x4
> [    4.934010] iwlwifi 0000:03:00.0: Device SKU: 0xF0
> [    4.934015] iwlwifi 0000:03:00.0: Valid Tx ant: 0x2, Valid Rx ant: 0x3
> [    4.937634] hda_codec: CX20561 (Hermosa): BIOS auto-probing.
> [    4.939404] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
> [    4.945634] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
> [    4.945856] input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
> [    4.946068] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
> [    4.950566] input: HDA Intel Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
> [    4.952854] Registered led device: phy0-led
> [    4.953149] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
> [    5.145058] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> [    5.368675] thinkpad_acpi: ThinkPad ACPI Extras v0.24
> [    5.368681] thinkpad_acpi: http://ibm-acpi.sf.net/
> [    5.368684] thinkpad_acpi: ThinkPad BIOS 6DET58WW (3.08 ), EC 7XHT22WW-1.04
> [    5.368687] thinkpad_acpi: Lenovo ThinkPad X200s, model 74665GG
> [    5.466695] psmouse serio1: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
> [    5.468374] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
> [    5.472475] thinkpad_acpi: radio switch found; radios are enabled
> [    5.472498] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
> [    5.472501] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
> [    5.485806] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input10
> [    5.486833] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
> [    5.487697] Registered led device: tpacpi::thinklight
> [    5.488070] Registered led device: tpacpi::power
> [    5.488398] Registered led device: tpacpi::standby
> [    5.488740] Registered led device: tpacpi::thinkvantage
> [    5.493673] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
> [    5.494775] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
> [    5.507574] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input11
> [    7.636951] type=1400 audit(1415282172.796:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient3" pid=695 comm="apparmor_parser"
> [    7.637045] type=1400 audit(1415282172.796:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=695 comm="apparmor_parser"
> [    7.637126] type=1400 audit(1415282172.796:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=695 comm="apparmor_parser"
> [    7.640734] type=1400 audit(1415282172.800:5): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=694 comm="apparmor_parser"
> [    7.640830] type=1400 audit(1415282172.800:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=694 comm="apparmor_parser"
> [    7.640913] type=1400 audit(1415282172.800:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=694 comm="apparmor_parser"
> [    7.856301] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> [    7.943116] type=1400 audit(1415282173.100:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=734 comm="apparmor_parser"
> [    7.943213] type=1400 audit(1415282173.100:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=734 comm="apparmor_parser"
> [    7.943296] type=1400 audit(1415282173.100:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=734 comm="apparmor_parser"
> [    7.994762] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
> [    7.994974] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [    8.576155] type=1400 audit(1415282173.736:11): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=805 comm="apparmor_parser"
> [    9.600899] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
> [    9.600909] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
> [    9.600949] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   17.738381] audit_printk_skb: 24 callbacks suppressed
> [   17.738387] type=1400 audit(1415282182.680:20): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince" pid=1079 comm="apparmor_parser"
> [   17.739267] type=1400 audit(1415282182.680:21): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer" pid=1079 comm="apparmor_parser"
> [   17.740060] type=1400 audit(1415282182.684:22): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-thumbnailer" pid=1079 comm="apparmor_parser"
> [   18.174887] type=1400 audit(1415282183.116:23): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=1127 comm="apparmor_parser"
> [   18.175109] type=1400 audit(1415282183.116:24): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=1127 comm="apparmor_parser"
> [   18.316669] type=1400 audit(1415282183.260:25): apparmor="STATUS" operation="profile_load" name="/usr/sbin/mysqld" pid=1128 comm="apparmor_parser"
> [   18.452472] type=1400 audit(1415282183.396:26): apparmor="STATUS" operation="profile_load" name="/usr/sbin/mysqld-akonadi" pid=1129 comm="apparmor_parser"
> [   18.590944] type=1400 audit(1415282183.532:27): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=1130 comm="apparmor_parser"
> [   18.615306] NET: Registered protocol family 15
> [   21.317182] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [   21.317573] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [   21.520429] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [   21.520820] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [   21.662974] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   21.727762] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   21.727768] Bluetooth: BNEP filters: protocol multicast
> [   21.727778] Bluetooth: BNEP socket layer initialized
> [   21.740384] Bridge firewalling registered
> [   21.780676] ppdev: user-space parallel port driver
> [   21.897288] Bluetooth: RFCOMM TTY layer initialized
> [   21.897304] Bluetooth: RFCOMM socket layer initialized
> [   21.897307] Bluetooth: RFCOMM ver 1.11
> [   29.383978] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [   29.388037] iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
> [   29.553392] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   32.021790] type=1400 audit(1415282196.964:28): apparmor="DENIED" operation="open" parent=2164 profile="/sbin/dhclient3" name="/var/lib/wicd/dhclient.conf" pid=2189 comm="dhclient" requested_mask="r" denied_mask="r" fsuid=0 ouid=0
>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbcFPLzb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 07:55:31 -0400
Date: Thu, 16 Jun 2016 13:53:16 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Problems with mwifiex_pcie firmware activation
Message-ID: <20160616115315.GB21199@redhat.com> (sfid-20160616_135538_039096_7E1FFF88)
References: <20160614135015.GB4962@redhat.com>
 <b881b09bf5384169ba1038af71fd435a@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
In-Reply-To: <b881b09bf5384169ba1038af71fd435a@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi

On Wed, Jun 15, 2016 at 01:47:53PM +0000, Amitkumar Karwar wrote:
> Could you please share complete dmesg log for failure and successful cases?

Dmesg from failure case is in attachment. I loose access to system
where device initalize, I'll provide missed dmesg when I get back
the access.

> Probably mwifiex is trying to download the firmware through USB. We had fixed this problem with below patch. Check if it's part of your codebase.
> https://patchwork.kernel.org/patch/7154601/

This patch is applied already on 4.7-rc3 as:

commit 60a188a2715f5cf9f495bd125600453b9e9b1a55
Author: Amitkumar Karwar <akarwar@marvell.com>
Date:   Thu Sep 10 07:27:33 2015 -0700

    mwifiex: remove USB8897 chipset support

Thanks
Stanislaw


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.fail.txt"

[    0.000000] Linux version 4.7.0-rc3+ (root@iot-r5s2-01.wlan.rhts.eng.bos.redhat.com) (gcc version 6.0.0 20160406 (Red Hat 6.0.0-0.20) (GCC) ) #3 SMP Thu Jun 16 06:24:15 EDT 2016
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.7.0-rc3+ root=/dev/mapper/fedora_iot--r5s2--01-root ro rd.lvm.lv=fedora_iot-r5s2-01/root rd.lvm.lv=fedora_iot-r5s2-01/swap console=ttyS6,115200n81 LANG=en_US.UTF-8
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001effffff] usable
[    0.000000] BIOS-e820: [mem 0x000000001f000000-0x000000001f0fffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000001f100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000200fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020100000-0x0000000076e4efff] usable
[    0.000000] BIOS-e820: [mem 0x0000000076e4f000-0x0000000076e7efff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000076e7f000-0x0000000076ea4fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000076ea5000-0x000000007742efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007742f000-0x000000007772bfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007772c000-0x000000007772cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007772d000-0x000000007776efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007776f000-0x00000000789e4fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000789e5000-0x0000000078ff9fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000078ffa000-0x0000000078ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed03000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed0c000-0x00000000fed0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1cfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff900000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: Dell Inc. Edge Gateway 5000/0N13CD, BIOS 01.02.00 01/28/2016
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x79000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 079000000 mask FFF000000 uncachable
[    0.000000]   2 base 07A000000 mask FFE000000 uncachable
[    0.000000]   3 base 07C000000 mask FFC000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] found SMP MP-table at [mem 0x000fd800-0x000fd80f] mapped at [ffff8800000fd800]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] BRK [0x02063000, 0x02063fff] PGTABLE
[    0.000000] BRK [0x02064000, 0x02064fff] PGTABLE
[    0.000000] BRK [0x02065000, 0x02065fff] PGTABLE
[    0.000000] BRK [0x02066000, 0x02066fff] PGTABLE
[    0.000000] BRK [0x02067000, 0x02067fff] PGTABLE
[    0.000000] BRK [0x02068000, 0x02068fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x33607000-0x35afbfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0580 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x0000000076E97088 00008C (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x0000000076EA3CA8 00010C (v05 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe0Block: 128/32 (20160422/tbfadt-624)
[    0.000000] ACPI: DSDT 0x0000000076E971A0 00CB03 (v02 DELL   AS09     01072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x000000007742EE80 000040
[    0.000000] ACPI: APIC 0x0000000076EA3DB8 000068 (v03 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x0000000076EA3E20 000044 (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x0000000076EA3E68 00009C (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x0000000076EA3F08 00003C (v01 DELL   AS09     01072009 MSFT 00000097)
[    0.000000] ACPI: LPIT 0x0000000076EA3F48 000104 (v01 DELL   AS09     00000003 VLV2 0100000D)
[    0.000000] ACPI: HPET 0x0000000076EA4050 000038 (v01 DELL   AS09     01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x0000000076EA4088 000763 (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076EA47F0 000290 (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076EA4A80 00017A (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: UEFI 0x0000000076EA4C00 000042 (v01 DELL   AS09     00000000      00000000)
[    0.000000] ACPI: SLIC 0x0000000076EA4C48 000176 (v03 DELL   AS09     01072009 MSFT 00010013)
[    0.000000] ACPI: CSRT 0x0000000076EA4DC0 00014C (v00 DELL   AS09     00000005 INTL 20120624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000078ffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x789d2000-0x789e3fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x0000000078ffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009bfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001effffff]
[    0.000000]   node   0: [mem 0x000000001f100000-0x000000001fffffff]
[    0.000000]   node   0: [mem 0x0000000020100000-0x0000000076e4efff]
[    0.000000]   node   0: [mem 0x000000007772c000-0x000000007772cfff]
[    0.000000]   node   0: [mem 0x000000007776f000-0x00000000789e4fff]
[    0.000000]   node   0: [mem 0x0000000078ffa000-0x0000000078ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x0000000078ffffff]
[    0.000000] On node 0 totalpages: 491111
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7680 pages used for memmap
[    0.000000]   DMA32 zone: 487116 pages, LIFO batch:31
[    0.000000] x86/hpet: Will disable the HPET for this platform because it's not reliable
[    0.000000] Reserving Intel graphics stolen memory at 0x7b000000-0x7effffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-86
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x1f000000-0x1f0fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x200fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e4f000-0x76e7efff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e7f000-0x76ea4fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76ea5000-0x7742efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7742f000-0x7772bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7772d000-0x7776efff]
[    0.000000] PM: Registered nosave memory: [mem 0x789e5000-0x78ff9fff]
[    0.000000] e820: [mem 0x7f000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] percpu: Embedded 35 pages/cpu @ffff880078400000 s103320 r8192 d31848 u1048576
[    0.000000] pcpu-alloc: s103320 r8192 d31848 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 483346
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.7.0-rc3+ root=/dev/mapper/fedora_iot--r5s2--01-root ro rd.lvm.lv=fedora_iot-r5s2-01/root rd.lvm.lv=fedora_iot-r5s2-01/swap console=ttyS6,115200n81 LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 1876328K/1964444K available (8043K kernel code, 1302K rwdata, 3244K rodata, 1572K init, 1572K bss, 88116K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-1.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] Maximum core-clock to bus-clock ratio: 0xa
[    0.000000] Resolved frequency ID: 2, frequency: 133200 KHz
[    0.000000] TSC runs at 1332000 KHz
[    0.000000] lapic_timer_frequency = 133200
[    0.000000] tsc: Detected 1332.000 MHz processor
[    0.000046] Calibrating delay loop (skipped), value calculated using timer frequency.. 2664.00 BogoMIPS (lpj=1332000)
[    0.000055] pid_max: default: 32768 minimum: 301
[    0.000087] ACPI: Core revision 20160422
[    0.000219] Security Framework initialized
[    0.000225] Yama: becoming mindful.
[    0.000236] SELinux:  Initializing.
[    0.000268] SELinux:  Starting in permissive mode
[    0.000770] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002274] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.003413] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.003429] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.004059] CPU: Physical Processor ID: 0
[    0.004066] CPU: Processor Core ID: 0
[    0.004075] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.004079] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.004091] mce: CPU supports 6 MCE banks
[    0.004105] CPU0: Thermal monitoring enabled (TM1)
[    0.004115] process: using mwait in idle threads
[    0.004123] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
[    0.004128] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
[    0.004734] Freeing SMP alternatives memory: 32K (ffffffff81ed0000 - ffffffff81ed8000)
[    0.007121] ftrace: allocating 30193 entries in 118 pages
[    0.032719] smpboot: Max logical packages: 1
[    0.032728] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.033463] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.043490] TSC deadline timer enabled
[    0.043498] smpboot: CPU0: Intel(R) Atom(TM) CPU  E3825  @ 1.33GHz (family: 0x6, model: 0x37, stepping: 0x9)
[    0.043510] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, full-width counters, Intel PMU driver.
[    0.043532] ... version:                3
[    0.043536] ... bit width:              40
[    0.043539] ... generic registers:      2
[    0.043542] ... value mask:             000000ffffffffff
[    0.043545] ... max period:             000000ffffffffff
[    0.043548] ... fixed-purpose events:   3
[    0.043551] ... event mask:             0000000700000003
[    0.045477] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.045988] x86: Booting SMP configuration:
[    0.045996] .... node  #0, CPUs:      #1
[    0.107968] x86: Booted up 1 node, 2 CPUs
[    0.107975] smpboot: Total of 2 processors activated (5336.46 BogoMIPS)
[    0.109037] devtmpfs: initialized
[    0.109232] x86/mm: Memory block size: 128MB
[    0.119587] PM: Registering ACPI NVS region [mem 0x76ea5000-0x7742efff] (5808128 bytes)
[    0.120009] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.120122] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.120128] pinctrl core: initialized pinctrl subsystem
[    0.120231] RTC time:  6:38:53, date: 06/16/16
[    0.120623] NET: Registered protocol family 16
[    0.122886] cpuidle: using governor menu
[    0.123028] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.123034] ACPI: bus type PCI registered
[    0.123039] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.123203] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.123211] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.123246] PCI: Using configuration type 1 for base access
[    0.123264] dmi type 0xB1 record - unknown flag
[    0.129280] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.130021] ACPI: Added _OSI(Module Device)
[    0.130028] ACPI: Added _OSI(Processor Device)
[    0.130032] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.130036] ACPI: Added _OSI(Processor Aggregator Device)
[    0.158639] ACPI: 4 ACPI AML tables successfully acquired and loaded

[    0.175960] ACPI: Dynamic OEM Table Load:
[    0.175980] ACPI: SSDT 0xFFFF880077A4BC00 0002B4 (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.177852] ACPI: Dynamic OEM Table Load:
[    0.177868] ACPI: SSDT 0xFFFF880077A13800 000433 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.180447] ACPI: Dynamic OEM Table Load:
[    0.180462] ACPI: SSDT 0xFFFF880077A47600 00015F (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.182245] ACPI: Dynamic OEM Table Load:
[    0.182259] ACPI: SSDT 0xFFFF880077AE23C0 00008D (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.186857] ACPI: Interpreter enabled
[    0.186915] ACPI: (supports S0 S4 S5)
[    0.186921] ACPI: Using IOAPIC for interrupt routing
[    0.187019] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.210357] ACPI: Power Resource [USBC] (on)
[    0.213238] ACPI: Power Resource [PLPE] (on)
[    0.213929] ACPI: Power Resource [PLPE] (on)
[    0.227759] ACPI: Power Resource [CLK0] (on)
[    0.227905] ACPI: Power Resource [CLK1] (on)
[    0.300717] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.300735] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.301225] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.301671] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.301678] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.303046] PCI host bridge to bus 0000:00
[    0.303056] pci_bus 0000:00: root bus resource [io  0x0070-0x0077]
[    0.303063] pci_bus 0000:00: root bus resource [io  0x0000-0x006f window]
[    0.303081] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7 window]
[    0.303088] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.303094] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.303100] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
[    0.303106] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff window]
[    0.303112] pci_bus 0000:00: root bus resource [mem 0x80000000-0x90915ffe window]
[    0.303118] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.303138] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
[    0.303514] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
[    0.303536] pci 0000:00:02.0: reg 0x10: [mem 0x90000000-0x903fffff]
[    0.303554] pci 0000:00:02.0: reg 0x18: [mem 0x80000000-0x8fffffff pref]
[    0.303571] pci 0000:00:02.0: reg 0x20: [io  0xe080-0xe087]
[    0.303950] pci 0000:00:13.0: [8086:0f23] type 00 class 0x010601
[    0.303976] pci 0000:00:13.0: reg 0x10: [io  0xe070-0xe077]
[    0.303991] pci 0000:00:13.0: reg 0x14: [io  0xe060-0xe063]
[    0.304005] pci 0000:00:13.0: reg 0x18: [io  0xe050-0xe057]
[    0.304020] pci 0000:00:13.0: reg 0x1c: [io  0xe040-0xe043]
[    0.304034] pci 0000:00:13.0: reg 0x20: [io  0xe020-0xe03f]
[    0.304048] pci 0000:00:13.0: reg 0x24: [mem 0x90915000-0x909157ff]
[    0.304126] pci 0000:00:13.0: PME# supported from D3hot
[    0.304456] pci 0000:00:14.0: [8086:0f35] type 00 class 0x0c0330
[    0.304485] pci 0000:00:14.0: reg 0x10: [mem 0x90900000-0x9090ffff 64bit]
[    0.304571] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.304843] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.304973] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
[    0.305006] pci 0000:00:1a.0: reg 0x10: [mem 0x90500000-0x905fffff]
[    0.305025] pci 0000:00:1a.0: reg 0x14: [mem 0x90400000-0x904fffff]
[    0.305167] pci 0000:00:1a.0: PME# supported from D0 D3hot
[    0.305558] pci 0000:00:1b.0: [8086:0f04] type 00 class 0x040300
[    0.305590] pci 0000:00:1b.0: reg 0x10: [mem 0x90910000-0x90913fff 64bit]
[    0.305688] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.306016] pci 0000:00:1c.0: [8086:0f48] type 01 class 0x060400
[    0.306121] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.306351] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.306467] pci 0000:00:1c.2: [8086:0f4c] type 01 class 0x060400
[    0.306557] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.306785] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.306905] pci 0000:00:1c.3: [8086:0f4e] type 01 class 0x060400
[    0.306995] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.307242] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.307366] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
[    0.307771] pci 0000:00:1f.3: [8086:0f12] type 00 class 0x0c0500
[    0.307813] pci 0000:00:1f.3: reg 0x10: [mem 0x90914000-0x9091401f]
[    0.307894] pci 0000:00:1f.3: reg 0x20: [io  0xe000-0xe01f]
[    0.308449] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    0.308478] pci 0000:01:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.308514] pci 0000:01:00.0: reg 0x18: [mem 0x90804000-0x90804fff 64bit]
[    0.308538] pci 0000:01:00.0: reg 0x20: [mem 0x90800000-0x90803fff 64bit pref]
[    0.308653] pci 0000:01:00.0: supports D1 D2
[    0.308659] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.308742] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.310170] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.310180] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.310188] pci 0000:00:1c.0:   bridge window [mem 0x90800000-0x908fffff]
[    0.310356] pci 0000:02:00.0: [11ab:2b38] type 00 class 0x020000
[    0.310396] pci 0000:02:00.0: reg 0x10: [mem 0x90700000-0x907fffff 64bit pref]
[    0.310423] pci 0000:02:00.0: reg 0x18: [mem 0x90600000-0x906fffff 64bit pref]
[    0.310584] pci 0000:02:00.0: supports D1 D2
[    0.310591] pci 0000:02:00.0: PME# supported from D0 D1 D3hot D3cold
[    0.310690] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.312189] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.312201] pci 0000:00:1c.2:   bridge window [mem 0x90600000-0x907fffff]
[    0.312328] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.315843] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 12 14 15)
[    0.316050] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 12 14 15) *0, disabled.
[    0.316269] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 12 14 15)
[    0.316473] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 12 14 15)
[    0.316675] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 5 6 12 14 15)
[    0.316877] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 12 14 15)
[    0.317079] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 12 14 15)
[    0.317293] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 12 14 15) *0, disabled.
[    0.324023] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.324364] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.324372] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.324381] vgaarb: loaded
[    0.324385] vgaarb: bridge control possible 0000:00:02.0
[    0.324628] SCSI subsystem initialized
[    0.324774] libata version 3.00 loaded.
[    0.324857] ACPI: bus type USB registered
[    0.324925] usbcore: registered new interface driver usbfs
[    0.324961] usbcore: registered new interface driver hub
[    0.325005] usbcore: registered new device driver usb
[    0.325290] PCI: Using ACPI for IRQ routing
[    0.332588] PCI: pci_cache_line_size set to 64 bytes
[    0.332675] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    0.332682] e820: reserve RAM buffer [mem 0x1f000000-0x1fffffff]
[    0.332687] e820: reserve RAM buffer [mem 0x76e4f000-0x77ffffff]
[    0.332691] e820: reserve RAM buffer [mem 0x7772d000-0x77ffffff]
[    0.332696] e820: reserve RAM buffer [mem 0x789e5000-0x7bffffff]
[    0.332700] e820: reserve RAM buffer [mem 0x79000000-0x7bffffff]
[    0.332997] NetLabel: Initializing
[    0.333003] NetLabel:  domain hash size = 128
[    0.333006] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.333036] NetLabel:  unlabeled traffic allowed by default
[    0.333291] clocksource: Switched to clocksource refined-jiffies
[    0.357823] VFS: Disk quotas dquot_6.6.0
[    0.357876] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.358124] pnp: PnP ACPI init
[    0.358284] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.358647] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.358656] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.358662] system 00:01: [io  0x0500-0x05fe] has been reserved
[    0.358669] system 00:01: [io  0x0600-0x061f] has been reserved
[    0.358680] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.359255] system 00:02: [io  0x0a00-0x0a0f] has been reserved
[    0.359264] system 00:02: [io  0x0a10-0x0a1f] has been reserved
[    0.359270] system 00:02: [io  0x0a20-0x0a2f] has been reserved
[    0.359281] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.360052] ACPI: IRQ 10 override to edge, high
[    0.360067] pnp 00:03: [dma 0 disabled]
[    0.360164] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.360871] ACPI: IRQ 11 override to edge, high
[    0.360884] pnp 00:04: [dma 0 disabled]
[    0.360991] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.361672] ACPI: IRQ 10 override to edge, high
[    0.361685] pnp 00:05: [dma 0 disabled]
[    0.361775] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.363181] ACPI: IRQ 7 override to edge, high
[    0.363200] pnp 00:06: [dma 0 disabled]
[    0.363299] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.364175] system 00:07: [mem 0xe0000000-0xefffffff] could not be reserved
[    0.364185] system 00:07: [mem 0xfed01000-0xfed01fff] has been reserved
[    0.364191] system 00:07: [mem 0xfed03000-0xfed03fff] has been reserved
[    0.364198] system 00:07: [mem 0xfed04000-0xfed04fff] has been reserved
[    0.364205] system 00:07: [mem 0xfed0c000-0xfed0ffff] could not be reserved
[    0.364211] system 00:07: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.364217] system 00:07: [mem 0xfed1c000-0xfed1cfff] has been reserved
[    0.364224] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.364231] system 00:07: [mem 0xfef00000-0xfeffffff] has been reserved
[    0.364242] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.367709] pnp: PnP ACPI: found 8 devices
[    0.378480] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.378512] clocksource: Switched to clocksource acpi_pm
[    0.378542] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000 add_align 100000
[    0.378558] pci 0000:00:1c.2: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.378566] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000 add_align 100000
[    0.378580] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.378588] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000 add_align 100000
[    0.378595] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff] to [bus 03] add_size 200000 add_align 100000
[    0.378612] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.378619] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.378626] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.378633] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.378640] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x000fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.378646] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x002fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.378653] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.378660] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.378666] pci 0000:00:1c.2: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.378673] pci 0000:00:1c.2: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.378679] pci 0000:00:1c.3: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.378685] pci 0000:00:1c.3: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.378705] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.378712] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.378733] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.378739] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.378749] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
[    0.378755] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
[    0.378769] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.378775] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.378785] pci 0000:00:1c.2: BAR 13: assigned [io  0x1000-0x1fff]
[    0.378794] pci 0000:00:1c.3: BAR 13: assigned [io  0x2000-0x2fff]
[    0.378808] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
[    0.378814] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
[    0.378827] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.378834] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.378847] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.378854] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.378867] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.378873] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.378882] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.378889] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.378899] pci 0000:00:1c.0:   bridge window [mem 0x90800000-0x908fffff]
[    0.378912] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.378918] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.378927] pci 0000:00:1c.2:   bridge window [mem 0x90600000-0x907fffff]
[    0.378939] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.378945] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.378961] pci_bus 0000:00: resource 4 [io  0x0070-0x0077]
[    0.378967] pci_bus 0000:00: resource 5 [io  0x0000-0x006f window]
[    0.378973] pci_bus 0000:00: resource 6 [io  0x0078-0x0cf7 window]
[    0.378978] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.378984] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff window]
[    0.378989] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff window]
[    0.378995] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000fffff window]
[    0.379001] pci_bus 0000:00: resource 11 [mem 0x80000000-0x90915ffe window]
[    0.379007] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.379012] pci_bus 0000:01: resource 1 [mem 0x90800000-0x908fffff]
[    0.379018] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.379024] pci_bus 0000:02: resource 1 [mem 0x90600000-0x907fffff]
[    0.379030] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    0.379171] NET: Registered protocol family 2
[    0.379750] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.379874] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.379993] TCP: Hash tables configured (established 16384 bind 16384)
[    0.380080] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.380117] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.380303] NET: Registered protocol family 1
[    0.380344] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.380943] PCI: CLS 64 bytes, default 64
[    0.381104] Unpacking initramfs...
[    2.125539] Freeing initrd memory: 37844K (ffff880033607000 - ffff880035afc000)
[    2.127449] futex hash table entries: 512 (order: 3, 32768 bytes)
[    2.127497] audit: initializing netlink subsys (disabled)
[    2.127534] audit: type=2000 audit(1466059135.112:1): initialized
[    2.128523] Initialise system trusted keyrings
[    2.128796] workingset: timestamp_bits=35 max_order=19 bucket_order=0
[    2.134219] zbud: loaded
[    2.135791] Key type big_key registered
[    2.135798] SELinux:  Registering netfilter hooks
[    2.302643] NET: Registered protocol family 38
[    2.302656] Key type asymmetric registered
[    2.302660] Asymmetric key parser 'x509' registered
[    2.302815] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 249)
[    2.302902] io scheduler noop registered
[    2.302908] io scheduler deadline registered
[    2.303020] io scheduler cfq registered (default)
[    2.304148] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.304168] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.304241] intel_idle: MWAIT substates: 0x3000020
[    2.304246] intel_idle: v0.4.1 model 0x37
[    2.304420] intel_idle: lapic_timer_reliable_states 0xffffffff
[    2.304708] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    2.304718] ACPI: Sleep Button [SLPB]
[    2.304863] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.304872] ACPI: Power Button [PWRF]
[    2.309236] GHES: HEST is not enabled!
[    2.309436] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    2.330597] 00:03: ttyS4 at I/O 0x3e0 (irq = 10, base_baud = 115200) is a 16550A
[    2.351803] 00:04: ttyS5 at I/O 0x2e0 (irq = 11, base_baud = 115200) is a 16550A
[    2.373034] 00:05: ttyS2 at I/O 0x3e8 (irq = 10, base_baud = 115200) is a 16550A
[    2.394242] 00:06: ttyS6 at I/O 0x2d0 (irq = 7, base_baud = 115200) is a 16550A
[    3.128355] tsc: Refined TSC clocksource calibration: 1333.334 MHz
[    3.128360] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x13381f692ed, max_idle_ns: 440795248934 ns
[    4.151667] clocksource: Switched to clocksource tsc
[    4.515732] console [ttyS6] enabled
[    4.523551] hpet: number irqs doesn't agree with number of timers
[    4.529903] Non-volatile memory driver v1.3
[    4.534230] Linux agpgart interface v0.103
[    4.539428] ahci 0000:00:13.0: version 3.0
[    4.539716] ahci 0000:00:13.0: controller can't do DEVSLP, turning off
[    4.556919] ahci 0000:00:13.0: AHCI 0001.0300 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    4.565124] ahci 0000:00:13.0: flags: 64bit ncq pm led clo pio slum part deso 
[    4.574784] scsi host0: ahci
[    4.579560] scsi host1: ahci
[    4.582686] ata1: SATA max UDMA/133 abar m2048@0x90915000 port 0x90915100 irq 261
[    4.590260] ata2: SATA max UDMA/133 abar m2048@0x90915000 port 0x90915180 irq 261
[    4.598053] libphy: Fixed MDIO Bus: probed
[    4.602390] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.609038] ehci-pci: EHCI PCI platform driver
[    4.613572] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.619829] ohci-pci: OHCI PCI platform driver
[    4.624355] uhci_hcd: USB Universal Host Controller Interface driver
[    4.631166] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    4.636608] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    4.645207] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
[    4.653753] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    4.653967] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.660837] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.668141] usb usb1: Product: xHCI Host Controller
[    4.673077] usb usb1: Manufacturer: Linux 4.7.0-rc3+ xhci-hcd
[    4.678889] usb usb1: SerialNumber: 0000:00:14.0
[    4.683968] hub 1-0:1.0: USB hub found
[    4.687793] hub 1-0:1.0: 6 ports detected
[    4.693210] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    4.698629] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    4.706539] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    4.713409] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.720716] usb usb2: Product: xHCI Host Controller
[    4.725650] usb usb2: Manufacturer: Linux 4.7.0-rc3+ xhci-hcd
[    4.731462] usb usb2: SerialNumber: 0000:00:14.0
[    4.736504] hub 2-0:1.0: USB hub found
[    4.740327] hub 2-0:1.0: 1 port detected
[    4.744767] usbcore: registered new interface driver usbserial
[    4.750701] usbcore: registered new interface driver usbserial_generic
[    4.757327] usbserial: USB Serial support registered for generic
[    4.763487] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    4.771361] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.776396] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.781857] mousedev: PS/2 mouse device common for all mice
[    4.789203] rtc_cmos 00:00: RTC can wake from S4
[    4.794551] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    4.800746] rtc_cmos 00:00: alarms up to one month, y3k, 242 bytes nvram
[    4.807696] device-mapper: uevent: version 1.0.3
[    4.812599] device-mapper: ioctl: 4.34.0-ioctl (2015-10-28) initialised: dm-devel@redhat.com
[    4.821349] intel_pstate: Intel P-state driver initializing
[    4.830097] hidraw: raw HID events driver (C) Jiri Kosina
[    4.835864] usbcore: registered new interface driver usbhid
[    4.841524] usbhid: USB HID core driver
[    4.845767] drop_monitor: Initializing network drop monitor service
[    4.852384] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.858169] Initializing XFRM netlink socket
[    4.863023] NET: Registered protocol family 10
[    4.869337] mip6: Mobile IPv6
[    4.872354] NET: Registered protocol family 17
[    4.877555] microcode: CPU0 sig=0x30679, pf=0x1, revision=0x905
[    4.883561] microcode: CPU1 sig=0x30679, pf=0x1, revision=0x905
[    4.889667] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.898612] SSE version of gcm_enc/dec engaged.
[    4.905416] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.914281] ata1.00: ATA-8: LITEON J8-L1032-11 M.2 2260 32GB, 0J51105, max UDMA/133
[    4.922476] ata1.00: 62533296 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.930236] ata2: SATA link down (SStatus 0 SControl 300)
[    4.936054] ata1.00: configured for UDMA/133
[    4.940801] scsi 0:0:0:0: Direct-Access     ATA      LITEON J8-L1032- 105  PQ: 0 ANSI: 5
[    4.965551] sd 0:0:0:0: [sda] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    4.973332] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.974818] sd 0:0:0:0: [sda] Write Protect is off
[    4.974828] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.974933] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.978809]  sda: sda1 sda2
[    4.980147] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.067709] usb 1-4: new high-speed USB device number 2 using xhci_hcd
[    5.080758] registered taskstats version 1
[    5.084932] Loading compiled-in X.509 certificates
[    5.103114] alg: No test for pkcs1pad(rsa,sha256) (pkcs1pad(rsa-generic,sha256))
[    5.118682] Loaded X.509 cert 'Build time autogenerated kernel key: 6d83a4dad8f37cc4c8145860c5e8da3ad8212da3'
[    5.128948] zswap: loaded using pool lzo/zbud
[    5.182125]   Magic number: 4:417:620
[    5.186399] rtc_cmos 00:00: setting system clock to 2016-06-16 06:38:58 UTC (1466059138)
[    5.194884] PM: Hibernation image not present or could not be loaded.
[    5.199937] Freeing unused kernel memory: 1572K (ffffffff81d47000 - ffffffff81ed0000)
[    5.207869] Write protecting the kernel read-only data: 12288k
[    5.214653] Freeing unused kernel memory: 132K (ffff8800017df000 - ffff880001800000)
[    5.229555] Freeing unused kernel memory: 852K (ffff880001b2b000 - ffff880001c00000)
[    5.249102] usb 1-4: New USB device found, idVendor=0424, idProduct=2514
[    5.255921] usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.266683] hub 1-4:1.0: USB hub found
[    5.270603] hub 1-4:1.0: 4 ports detected
[    5.283019] random: systemd urandom read with 2 bits of entropy available
[    5.302811] systemd[1]: systemd 229 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    5.321488] systemd[1]: Detected architecture x86-64.
[    5.326606] systemd[1]: Running in initial RAM disk.
[    5.343267] systemd[1]: Set hostname to <iot-r5s2-01.wlan.rhts.eng.bos.redhat.com>.
[    5.549776] usb 1-4.2: new high-speed USB device number 3 using xhci_hcd
[    5.595928] systemd[1]: Created slice System Slice.
[    5.608430] systemd[1]: Reached target Local File Systems.
[    5.621575] systemd[1]: Listening on udev Control Socket.
[    5.634463] systemd[1]: Reached target Slices.
[    5.645884] systemd[1]: Listening on Journal Socket (/dev/log).
[    5.660076] systemd[1]: Listening on Journal Audit Socket.
[    5.673579] systemd[1]: Reached target Timers.
[    5.684915] systemd[1]: Listening on Journal Socket.
[    5.711539] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    5.735074] systemd[1]: Starting dracut cmdline hook...
[    5.761082] systemd[1]: Starting Journal Service...
[    5.771085] systemd[1]: Reached target Swap.
[    5.784347] systemd[1]: Starting Setup Virtual Console...
[    5.803230] systemd[1]: Listening on udev Kernel Socket.
[    5.822156] systemd[1]: Reached target Sockets.
[    5.838383] systemd[1]: Starting Apply Kernel Variables...
[    5.854462] systemd[1]: Started Create list of required static device nodes for the current kernel.
[    5.882391] audit: type=1130 audit(1466059139.195:2): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=kmod-static-nodes comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    5.905686] systemd[1]: Started Apply Kernel Variables.
[    5.929318] audit: type=1130 audit(1466059139.242:3): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    5.950499] systemd[1]: Started Journal Service.
[    5.963936] audit: type=1130 audit(1466059139.276:4): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    6.057193] audit: type=1130 audit(1466059139.369:5): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-tmpfiles-setup-dev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    6.225738] audit: type=1130 audit(1466059139.538:6): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-vconsole-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    6.298249] audit: type=1130 audit(1466059139.610:7): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-cmdline comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    6.534600] audit: type=1130 audit(1466059139.846:8): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-udev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    6.607461] audit: type=1130 audit(1466059139.919:9): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-udevd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    6.905298] audit: type=1130 audit(1466059140.217:10): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-udev-trigger comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[    7.117183] sdhci: Secure Digital Host Controller Interface driver
[    7.123446] sdhci: Copyright(c) Pierre Ossman
[    7.263465] FUJITSU Extended Socket Network Device Driver - version 1.1 - Copyright (c) 2015 FUJITSU LIMITED
[    7.685726] [drm] Initialized drm 1.1.0 20060810
[    7.742483] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    7.782674] r8169 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM control
[    7.832474] r8169 0000:01:00.0 eth0: RTL8168f/8111f at 0xffffc90000338000, f4:8e:38:d0:7c:bd, XID 08100880 IRQ 263
[    7.842938] r8169 0000:01:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    7.913678] r8169 0000:01:00.0 enp1s0: renamed from eth0
[    8.956538] [drm] Memory usable by graphics device = 2048M
[    8.962117] [drm] Replacing VGA console driver
[    8.967659] Console: switching to colour dummy device 80x25
[    8.973711] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    8.980411] [drm] Driver supports precise vblank timestamp query.
[    9.046468] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    9.392012] i915 0000:00:02.0: No connectors reported connected with modes
[    9.406122] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    9.413124] [drm] Cannot find any crtc or sizes - going 1024x768
[    9.422353] acpi device:09: registered as cooling_device2
[    9.430027] fbcon: inteldrmfb (fb0) is primary device
[    9.434948] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    9.437466] [drm] Initialized i915 1.6.0 20160425 for 0000:00:02.0 on minor 0
[   10.088539] Console: switching to colour frame buffer device 128x48
[   10.131162] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   10.143071] audit: type=1130 audit(1466059143.451:11): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=plymouth-start comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   10.637078] usb 1-4.2: device descriptor read/64, error -110
[   10.974593] audit: type=1130 audit(1466059144.282:12): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-initqueue comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   11.251925] audit: type=1130 audit(1466059144.559:13): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-fsck-root comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   11.313437] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[   11.716983] audit: type=1130 audit(1466059145.024:14): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-parse-etc comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   11.737205] audit: type=1131 audit(1466059145.044:15): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-parse-etc comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   12.076121] audit: type=1130 audit(1466059145.382:16): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-pivot comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   12.151746] audit: type=1130 audit(1466059145.458:17): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-cleanup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   12.173534] audit: type=1131 audit(1466059145.480:18): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-cleanup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   12.203279] audit: type=1131 audit(1466059145.509:19): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-pivot comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   12.231667] audit: type=1130 audit(1466059145.538:20): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   12.444342] systemd-journald[171]: Received SIGTERM from PID 1 (systemd).
[   12.685852] SELinux: 32768 avtab hash slots, 104702 rules.
[   12.738280] SELinux: 32768 avtab hash slots, 104702 rules.
[   12.859826] SELinux:  8 users, 14 roles, 4993 types, 306 bools, 1 sens, 1024 cats
[   12.859836] SELinux:  92 classes, 104702 rules
[   12.870741] SELinux:  Permission validate_trans in class security not defined in policy.
[   12.878952] SELinux:  Permission module_load in class system not defined in policy.
[   12.886951] SELinux:  Class cap_userns not defined in policy.
[   12.892759] SELinux:  Class cap2_userns not defined in policy.
[   12.898652] SELinux: the above unknown classes and permissions will be allowed
[   12.905959] SELinux:  Completing initialization.
[   12.905963] SELinux:  Setting up existing superblocks.
[   12.937472] systemd[1]: Successfully loaded SELinux policy in 303.295ms.
[   12.975624] systemd[1]: RTC configured in localtime, applying delta of -240 minutes to system time.
[   13.126443] systemd[1]: Relabelled /dev and /run in 133.881ms.
[   13.812906] EXT4-fs (dm-0): re-mounted. Opts: (null)
[   14.061791] systemd-journald[534]: Received request to flush runtime journal from PID 1
[   15.643206] Bluetooth: Core ver 2.21
[   15.647507] NET: Registered protocol family 31
[   15.653113] Bluetooth: HCI device and connection manager initialized
[   15.661836] Bluetooth: HCI socket layer initialized
[   15.671299] Bluetooth: L2CAP socket layer initialized
[   15.676710] Bluetooth: SCO socket layer initialized
[   15.683883] audit_printk_skb: 120 callbacks suppressed
[   15.690447] audit: type=1130 audit(1466073548.986:61): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-backlight@backlight:acpi_video0 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   15.945146] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   15.962472] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   16.016289] Bluetooth: HCI UART driver ver 2.3
[   16.020821] Bluetooth: HCI UART protocol H4 registered
[   16.026083] Bluetooth: HCI UART protocol BCSP registered
[   16.031464] Bluetooth: HCI UART protocol LL registered
[   16.036679] Bluetooth: HCI UART protocol ATH3K registered
[   16.042166] Bluetooth: HCI UART protocol Three-wire (H5) registered
[   16.075271] Bluetooth: HCI UART protocol Intel registered
[   16.145576] Bluetooth: HCI UART protocol BCM registered
[   16.150902] Bluetooth: HCI UART protocol QCA registered
[   16.464427] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   16.855980] iTCO_vendor_support: vendor-support=0
[   16.922226] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   16.941739] iTCO_wdt: Found a Bay Trail SoC TCO device (Version=3, TCOBASE=0x0460)
[   16.980405] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   17.004064] audit: type=1130 audit(1466073550.304:62): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=lvm2-pvscan@8:2 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   17.139460] mwifiex_pcie: try set_consistent_dma_mask(32)
[   17.148193] mwifiex_pcie: PCI memory map Virt0: ffffc90000e00000 PCI memory map Virt2: ffffc90001000000
[   17.163604] mwifiex: rx work enabled, cpus 2
[   17.300005] audit: type=1130 audit(1466073550.600:63): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-fsck@dev-disk-by\x2duuid-ed81621b\x2d2d04\x2d4567\x2d8497\x2df9d82731b7d3 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   17.338209] Adding 3129340k swap on /dev/mapper/fedora_iot--r5s2--01-swap.  Priority:-1 extents:1 across:3129340k SSFS
[   17.450318] mwifiex_pcie 0000:02:00.0: PCI-E is not the winner <0x0,0>, exit dnld
[   17.457923] mwifiex_pcie 0000:02:00.0: WLAN is not the winner! Skip FW dnld
[   17.516138] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   17.575517] intel_soc_dts_thermal: request_threaded_irq ret -22
[   17.620053] intel_soc_dts_thermal: request_threaded_irq ret -22
[   17.629639] audit: type=1130 audit(1466073550.929:64): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=dracut-shutdown comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   17.660167] audit: type=1130 audit(1466073550.960:65): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nfs-config comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   17.685370] audit: type=1131 audit(1466073550.985:66): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nfs-config comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   17.709673] audit: type=1130 audit(1466073551.009:67): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=plymouth-read-write comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   17.731990] audit: type=1131 audit(1466073551.032:68): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=plymouth-read-write comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   17.817291] audit: type=1130 audit(1466073551.117:69): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=fedora-import-state comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   17.858354] audit: type=1130 audit(1466073551.158:70): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=plymouth-read-write comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[   18.472148] random: nonblocking pool is initialized
[   19.703648] IPv6: ADDRCONF(NETDEV_UP): enp1s0: link is not ready
[   19.928490] r8169 0000:01:00.0 enp1s0: link down
[   19.933195] r8169 0000:01:00.0 enp1s0: link down
[   19.938922] IPv6: ADDRCONF(NETDEV_UP): enp1s0: link is not ready
[   22.990278] r8169 0000:01:00.0 enp1s0: link up
[   22.994836] IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0: link becomes ready
[   25.836036] usb 1-4.2: device descriptor read/64, error -110
[   26.019772] usb 1-4.2: new high-speed USB device number 4 using xhci_hcd
[   31.105976] usb 1-4.2: device descriptor read/64, error -110
[   32.661490] mwifiex_pcie 0000:02:00.0: FW failed to be active in time
[   32.668061] mwifiex_pcie 0000:02:00.0: info: mwifiex_fw_dpc: unregister device
[   46.310316] usb 1-4.2: device descriptor read/64, error -110
[   46.490430] usb 1-4.2: new high-speed USB device number 5 using xhci_hcd
[   51.512240] xhci_hcd 0000:00:14.0: Command completion event does not match command
[   51.519990] xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
[   56.749888] xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
[   56.959115] usb 1-4.2: device not accepting address 5, error -62
[   57.038156] usb 1-4.2: new high-speed USB device number 6 using xhci_hcd
[   62.067222] xhci_hcd 0000:00:14.0: Command completion event does not match command
[   62.076711] xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
[   67.304564] xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
[   67.513856] usb 1-4.2: device not accepting address 6, error -62
[   67.520115] usb 1-4-port2: unable to enumerate USB device

--2fHTh5uZTiUOsy+g--

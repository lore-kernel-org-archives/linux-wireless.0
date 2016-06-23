Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbcFWMMQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 08:12:16 -0400
Date: Thu, 23 Jun 2016 14:09:53 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Problems with mwifiex_pcie firmware activation
Message-ID: <20160623120952.GA11157@redhat.com> (sfid-20160623_141233_471990_ED6A16A1)
References: <20160614135015.GB4962@redhat.com>
 <b881b09bf5384169ba1038af71fd435a@SC-EXCH04.marvell.com>
 <20160616115315.GB21199@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
In-Reply-To: <20160616115315.GB21199@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 16, 2016 at 01:53:15PM +0200, Stanislaw Gruszka wrote:
> On Wed, Jun 15, 2016 at 01:47:53PM +0000, Amitkumar Karwar wrote:
> > Could you please share complete dmesg log for failure and successful cases?
> 
> Dmesg from failure case is in attachment. I loose access to system
> where device initalize, I'll provide missed dmesg when I get back
> the access.

Have the access now, dmesg is in attachment.

Stanislaw

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.good.txt"

[    0.000000] Linux version 4.7.0-rc3+ (root@iot-r5s1-01.wlan.rhts.eng.bos.redhat.com) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-4) (GCC) ) #3 SMP Fri Jun 17 05:16:00 EDT 2016
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.7.0-rc3+ root=/dev/mapper/rhel_iot--r5s1--01-root ro crashkernel=auto rd.lvm.lv=rhel_iot-r5s1-01/root rd.lvm.lv=rhel_iot-r5s1-01/swap console=ttyS3,115200n81 LANG=en_US.UTF-8
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
[    0.000000] BIOS-e820: [mem 0x0000000020100000-0x0000000076e40fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000076e41000-0x0000000076e70fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000076e71000-0x0000000076e96fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000076e97000-0x0000000077420fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000077421000-0x000000007771efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007771f000-0x000000007771ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000077720000-0x0000000077761fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000077762000-0x00000000789e4fff] usable
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
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000027fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: Dell Inc. Edge Gateway 5000/      , BIOS 00.03.08 11/09/2015
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x280000 max_arch_pfn = 0x400000000
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
[    0.000000]   4 base 100000000 mask F00000000 write-back
[    0.000000]   5 base 200000000 mask F80000000 write-back
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] total RAM covered: 8080M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 0G
[    0.000000] e820: update [mem 0x79000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x79000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd840-0x000fd84f] mapped at [ffff8800000fd840]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] BRK [0x0224e000, 0x0224efff] PGTABLE
[    0.000000] BRK [0x0224f000, 0x0224ffff] PGTABLE
[    0.000000] BRK [0x02250000, 0x02250fff] PGTABLE
[    0.000000] BRK [0x02251000, 0x02251fff] PGTABLE
[    0.000000] BRK [0x02252000, 0x02252fff] PGTABLE
[    0.000000] BRK [0x02253000, 0x02253fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x30e6a000-0x3472cfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0580 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x0000000076E89088 000094 (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x0000000076E95CB8 00010C (v05 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe0Block: 128/32 (20160422/tbfadt-624)
[    0.000000] ACPI: DSDT 0x0000000076E891B0 00CB03 (v02 DELL   AS09     01072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x0000000077420E80 000040
[    0.000000] ACPI: APIC 0x0000000076E95DC8 000068 (v03 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x0000000076E95E30 000044 (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x0000000076E95E78 00009C (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x0000000076E95F18 00003C (v01 DELL   AS09     01072009 MSFT 00000097)
[    0.000000] ACPI: LPIT 0x0000000076E95F58 000104 (v01 DELL   AS09     00000003 VLV2 0100000D)
[    0.000000] ACPI: HPET 0x0000000076E96060 000038 (v01 DELL   AS09     01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x0000000076E96098 000763 (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076E96800 000290 (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076E96A90 00017A (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: UEFI 0x0000000076E96C10 000042 (v01 DELL   AS09     00000000      00000000)
[    0.000000] ACPI: SLIC 0x0000000076E96C58 000176 (v03 DELL   AS09     01072009 MSFT 00010013)
[    0.000000] ACPI: TCPA 0x0000000076E96DD0 000032 (v02 DELL   AS09     00000001 MSFT 01000013)
[    0.000000] ACPI: CSRT 0x0000000076E96E08 00014C (v00 DELL   AS09     00000005 INTL 20120624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000027fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x27ffd4000-0x27fff5fff]
[    0.000000] kexec_core: crashkernel: memory value expected
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000027fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009bfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001effffff]
[    0.000000]   node   0: [mem 0x000000001f100000-0x000000001fffffff]
[    0.000000]   node   0: [mem 0x0000000020100000-0x0000000076e40fff]
[    0.000000]   node   0: [mem 0x000000007771f000-0x000000007771ffff]
[    0.000000]   node   0: [mem 0x0000000077762000-0x00000000789e4fff]
[    0.000000]   node   0: [mem 0x0000000078ffa000-0x0000000078ffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000027fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000027fffffff]
[    0.000000] On node 0 totalpages: 2063974
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7612 pages used for memmap
[    0.000000]   DMA32 zone: 487115 pages, LIFO batch:31
[    0.000000]   Normal zone: 24576 pages used for memmap
[    0.000000]   Normal zone: 1572864 pages, LIFO batch:31
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
[    0.000000] PM: Registered nosave memory: [mem 0x76e41000-0x76e70fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e71000-0x76e96fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e97000-0x77420fff]
[    0.000000] PM: Registered nosave memory: [mem 0x77421000-0x7771efff]
[    0.000000] PM: Registered nosave memory: [mem 0x77720000-0x77761fff]
[    0.000000] PM: Registered nosave memory: [mem 0x789e5000-0x78ff9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79000000-0x7affffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b000000-0x7effffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7f000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed01fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed02000-0xfed02fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed03000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed07fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed08fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed09000-0xfed0bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed0c000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1d000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xff8fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff900000-0xffffffff]
[    0.000000] e820: [mem 0x7f000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] percpu: Embedded 35 pages/cpu @ffff88027fc00000 s102936 r8192 d32232 u1048576
[    0.000000] pcpu-alloc: s102936 r8192 d32232 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 2031701
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.7.0-rc3+ root=/dev/mapper/rhel_iot--r5s1--01-root ro crashkernel=auto rd.lvm.lv=rhel_iot-r5s1-01/root rd.lvm.lv=rhel_iot-r5s1-01/swap console=ttyS3,115200n81 LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 3919048K/8255896K available (6907K kernel code, 1421K rwdata, 3076K rodata, 1812K init, 3180K bss, 274808K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-1.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS3] enabled
[    0.000000] Maximum core-clock to bus-clock ratio: 0x15
[    0.000000] Resolved frequency ID: 0, frequency: 83200 KHz
[    0.000000] TSC runs at 1747200 KHz
[    0.000000] lapic_timer_frequency = 83200
[    0.000000] tsc: Detected 1747.200 MHz processor
[    0.000035] Calibrating delay loop (skipped), value calculated using timer frequency.. 3494.40 BogoMIPS (lpj=1747200)
[    0.000477] pid_max: default: 32768 minimum: 301
[    0.000684] ACPI: Core revision 20160422
[    0.000924] Security Framework initialized
[    0.001107] SELinux:  Initializing.
[    0.001263] SELinux:  Starting in permissive mode
[    0.002516] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.007162] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.009367] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.009670] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.010518] CPU: Physical Processor ID: 0
[    0.010688] CPU: Processor Core ID: 0
[    0.010844] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.011108] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.011399] mce: CPU supports 6 MCE banks
[    0.011573] CPU0: Thermal monitoring enabled (TM1)
[    0.011773] process: using mwait in idle threads
[    0.011966] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
[    0.012196] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
[    0.012863] Freeing SMP alternatives memory: 28K (ffffffff81f2a000 - ffffffff81f31000)
[    0.016619] ftrace: allocating 27061 entries in 106 pages
[    0.034056] smpboot: Max logical packages: 1
[    0.034256] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.035200] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.045456] TSC deadline timer enabled
[    0.045463] smpboot: CPU0: Intel(R) Atom(TM) CPU  E3827  @ 1.74GHz (family: 0x6, model: 0x37, stepping: 0x9)
[    0.045881] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, full-width counters, Intel PMU driver.
[    0.046337] ... version:                3
[    0.046509] ... bit width:              40
[    0.046677] ... generic registers:      2
[    0.046841] ... value mask:             000000ffffffffff
[    0.047056] ... max period:             000000ffffffffff
[    0.047271] ... fixed-purpose events:   3
[    0.047435] ... event mask:             0000000700000003
[    0.049054] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.049777] x86: Booting SMP configuration:
[    0.049953] .... node  #0, CPUs:      #1
[    0.112024] x86: Booted up 1 node, 2 CPUs
[    0.112205] smpboot: Total of 2 processors activated (6997.07 BogoMIPS)
[    0.162654] node 0 initialised, 1015510 pages in 49ms
[    0.164095] devtmpfs: initialized
[    0.164371] x86/mm: Memory block size: 128MB
[    0.173653] evm: security.selinux
[    0.173794] evm: security.ima
[    0.173918] evm: security.capability
[    0.174241] PM: Registering ACPI NVS region [mem 0x76e97000-0x77420fff] (5808128 bytes)
[    0.174874] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.175358] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.175639] pinctrl core: initialized pinctrl subsystem
[    0.176189] NET: Registered protocol family 16
[    0.179364] cpuidle: using governor menu
[    0.179640] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.179946] ACPI: bus type PCI registered
[    0.180112] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.180488] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.180871] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.181171] PCI: Using configuration type 1 for base access
[    0.181408] dmi type 0xB1 record - unknown flag
[    0.186708] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.187463] ACPI: Added _OSI(Module Device)
[    0.187639] ACPI: Added _OSI(Processor Device)
[    0.187821] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.188024] ACPI: Added _OSI(Processor Aggregator Device)
[    0.210091] ACPI: 4 ACPI AML tables successfully acquired and loaded

[    0.223578] ACPI: Dynamic OEM Table Load:
[    0.223771] ACPI: SSDT 0xFFFF88027FE63400 000338 (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.225535] ACPI: Dynamic OEM Table Load:
[    0.225723] ACPI: SSDT 0xFFFF88027FBC3000 000433 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.228013] ACPI: Dynamic OEM Table Load:
[    0.228202] ACPI: SSDT 0xFFFF88027F7F8600 00015F (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.229918] ACPI: Dynamic OEM Table Load:
[    0.230105] ACPI: SSDT 0xFFFF88017EECB540 00008D (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.233939] ACPI: Interpreter enabled
[    0.234133] ACPI: (supports S0 S4 S5)
[    0.234286] ACPI: Using IOAPIC for interrupt routing
[    0.234570] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.251939] ACPI: Power Resource [USBC] (on)
[    0.254208] ACPI: Power Resource [PLPE] (on)
[    0.254903] ACPI: Power Resource [PLPE] (on)
[    0.265280] ACPI: Power Resource [CLK0] (on)
[    0.265555] ACPI: Power Resource [CLK1] (on)
[    0.336984] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.337259] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.337935] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.338562] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.338831] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.340191] PCI host bridge to bus 0000:00
[    0.340377] pci_bus 0000:00: root bus resource [io  0x0070-0x0077]
[    0.340629] pci_bus 0000:00: root bus resource [io  0x0000-0x006f window]
[    0.340903] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7 window]
[    0.341177] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.341457] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.341759] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
[    0.342060] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff window]
[    0.342361] pci_bus 0000:00: root bus resource [mem 0x80000000-0x90a15ffe window]
[    0.342667] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.342901] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
[    0.343191] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
[    0.343209] pci 0000:00:02.0: reg 0x10: [mem 0x90000000-0x903fffff]
[    0.343223] pci 0000:00:02.0: reg 0x18: [mem 0x80000000-0x8fffffff pref]
[    0.343237] pci 0000:00:02.0: reg 0x20: [io  0xe080-0xe087]
[    0.343526] pci 0000:00:13.0: [8086:0f23] type 00 class 0x010601
[    0.343548] pci 0000:00:13.0: reg 0x10: [io  0xe070-0xe077]
[    0.343560] pci 0000:00:13.0: reg 0x14: [io  0xe060-0xe063]
[    0.343572] pci 0000:00:13.0: reg 0x18: [io  0xe050-0xe057]
[    0.343584] pci 0000:00:13.0: reg 0x1c: [io  0xe040-0xe043]
[    0.343595] pci 0000:00:13.0: reg 0x20: [io  0xe020-0xe03f]
[    0.343608] pci 0000:00:13.0: reg 0x24: [mem 0x90a15000-0x90a157ff]
[    0.343663] pci 0000:00:13.0: PME# supported from D3hot
[    0.343921] pci 0000:00:14.0: [8086:0f35] type 00 class 0x0c0330
[    0.343944] pci 0000:00:14.0: reg 0x10: [mem 0x90a00000-0x90a0ffff 64bit]
[    0.344015] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.344225] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.344553] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
[    0.344581] pci 0000:00:1a.0: reg 0x10: [mem 0x90500000-0x905fffff]
[    0.344597] pci 0000:00:1a.0: reg 0x14: [mem 0x90400000-0x904fffff]
[    0.344718] pci 0000:00:1a.0: PME# supported from D0 D3hot
[    0.345022] pci 0000:00:1b.0: [8086:0f04] type 00 class 0x040300
[    0.345049] pci 0000:00:1b.0: reg 0x10: [mem 0x90a10000-0x90a13fff 64bit]
[    0.345132] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.345384] pci 0000:00:1c.0: [8086:0f48] type 01 class 0x060400
[    0.345458] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.345634] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.345957] pci 0000:00:1c.1: [8086:0f4a] type 01 class 0x060400
[    0.346030] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.346209] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.346519] pci 0000:00:1c.2: [8086:0f4c] type 01 class 0x060400
[    0.346592] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.346768] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.347087] pci 0000:00:1c.3: [8086:0f4e] type 01 class 0x060400
[    0.347160] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.347339] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.347656] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
[    0.347972] pci 0000:00:1f.3: [8086:0f12] type 00 class 0x0c0500
[    0.348019] pci 0000:00:1f.3: reg 0x10: [mem 0x90a14000-0x90a1401f]
[    0.348094] pci 0000:00:1f.3: reg 0x20: [io  0xe000-0xe01f]
[    0.348534] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    0.348558] pci 0000:01:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.348590] pci 0000:01:00.0: reg 0x18: [mem 0x90904000-0x90904fff 64bit]
[    0.348611] pci 0000:01:00.0: reg 0x20: [mem 0x90900000-0x90903fff 64bit pref]
[    0.348710] pci 0000:01:00.0: supports D1 D2
[    0.348715] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.348778] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.351057] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.351264] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.351270] pci 0000:00:1c.0:   bridge window [mem 0x90900000-0x909fffff]
[    0.351387] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.351412] pci 0000:02:00.0: reg 0x10: [io  0xc000-0xc0ff]
[    0.351444] pci 0000:02:00.0: reg 0x18: [mem 0x90804000-0x90804fff 64bit]
[    0.351465] pci 0000:02:00.0: reg 0x20: [mem 0x90800000-0x90803fff 64bit pref]
[    0.351565] pci 0000:02:00.0: supports D1 D2
[    0.351570] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.351632] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.353061] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.353268] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.353274] pci 0000:00:1c.1:   bridge window [mem 0x90800000-0x908fffff]
[    0.353402] pci 0000:03:00.0: [11ab:2b38] type 00 class 0x020000
[    0.353439] pci 0000:03:00.0: reg 0x10: [mem 0x90700000-0x907fffff 64bit pref]
[    0.353465] pci 0000:03:00.0: reg 0x18: [mem 0x90600000-0x906fffff 64bit pref]
[    0.353607] pci 0000:03:00.0: supports D1 D2
[    0.353612] pci 0000:03:00.0: PME# supported from D0 D1 D3hot D3cold
[    0.353687] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.355082] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.355291] pci 0000:00:1c.2:   bridge window [mem 0x90600000-0x907fffff]
[    0.355390] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.358261] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 12 14 15)
[    0.358734] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 *4 5 6 12 14 15)
[    0.359214] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 12 14 15)
[    0.359682] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 12 14 15)
[    0.360160] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 5 6 12 14 15)
[    0.360629] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 12 14 15)
[    0.361105] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 12 14 15)
[    0.361573] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 12 14 15) *0, disabled.
[    0.365006] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.365472] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.365705] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.366033] vgaarb: loaded
[    0.366147] vgaarb: bridge control possible 0000:00:02.0
[    0.366508] SCSI subsystem initialized
[    0.366728] ACPI: bus type USB registered
[    0.366934] usbcore: registered new interface driver usbfs
[    0.367176] usbcore: registered new interface driver hub
[    0.367443] usbcore: registered new device driver usb
[    0.367835] PCI: Using ACPI for IRQ routing
[    0.374274] PCI: pci_cache_line_size set to 64 bytes
[    0.374358] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    0.374363] e820: reserve RAM buffer [mem 0x1f000000-0x1fffffff]
[    0.374366] e820: reserve RAM buffer [mem 0x76e41000-0x77ffffff]
[    0.374370] e820: reserve RAM buffer [mem 0x77720000-0x77ffffff]
[    0.374373] e820: reserve RAM buffer [mem 0x789e5000-0x7bffffff]
[    0.374377] e820: reserve RAM buffer [mem 0x79000000-0x7bffffff]
[    0.374611] NetLabel: Initializing
[    0.374755] NetLabel:  domain hash size = 128
[    0.374932] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.375156] NetLabel:  unlabeled traffic allowed by default
[    0.375595] clocksource: Switched to clocksource refined-jiffies
[    0.392962] VFS: Disk quotas dquot_6.6.0
[    0.393158] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.393618] pnp: PnP ACPI init
[    0.393870] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.394148] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.394392] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.394633] system 00:01: [io  0x0500-0x05fe] has been reserved
[    0.394888] system 00:01: [io  0x0600-0x061f] has been reserved
[    0.395134] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.395539] system 00:02: [io  0x0a00-0x0a0f] has been reserved
[    0.395782] system 00:02: [io  0x0a10-0x0a1f] has been reserved
[    0.396034] system 00:02: [io  0x0a20-0x0a2f] has been reserved
[    0.396280] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.396856] ACPI: IRQ 10 override to edge, high
[    0.397061] pnp 00:03: [dma 0 disabled]
[    0.397133] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.397675] ACPI: IRQ 11 override to edge, high
[    0.397868] pnp 00:04: [dma 0 disabled]
[    0.397939] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.398469] ACPI: IRQ 10 override to edge, high
[    0.398661] pnp 00:05: [dma 0 disabled]
[    0.398728] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.399785] ACPI: IRQ 7 override to edge, high
[    0.399974] pnp 00:06: [dma 0 disabled]
[    0.400040] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.400708] system 00:07: [mem 0xe0000000-0xefffffff] could not be reserved
[    0.400993] system 00:07: [mem 0xfed01000-0xfed01fff] has been reserved
[    0.401273] system 00:07: [mem 0xfed03000-0xfed03fff] has been reserved
[    0.401542] system 00:07: [mem 0xfed04000-0xfed04fff] has been reserved
[    0.401810] system 00:07: [mem 0xfed0c000-0xfed0ffff] could not be reserved
[    0.402091] system 00:07: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.402365] system 00:07: [mem 0xfed1c000-0xfed1cfff] has been reserved
[    0.402634] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.402915] system 00:07: [mem 0xfef00000-0xfeffffff] has been reserved
[    0.403187] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.405929] pnp 00:08: Plug and Play ACPI device, IDs PNP0c31 (active)
[    0.405950] pnp: PnP ACPI: found 9 devices
[    0.415070] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.415450] clocksource: Switched to clocksource acpi_pm
[    0.415711] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000 add_align 100000
[    0.415725] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000 add_align 100000
[    0.415737] pci 0000:00:1c.2: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.415743] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000 add_align 100000
[    0.415754] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[    0.415761] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000 add_align 100000
[    0.415770] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff] to [bus 04] add_size 200000 add_align 100000
[    0.415785] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.415790] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.415795] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.415800] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.415806] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.415811] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.415816] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x000fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.415821] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x002fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.415826] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.415831] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.415836] pci 0000:00:1c.2: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.415841] pci 0000:00:1c.2: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.415846] pci 0000:00:1c.3: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.415851] pci 0000:00:1c.3: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.415867] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.416195] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.416538] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.416847] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.417175] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.417503] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.417828] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
[    0.418099] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
[    0.418390] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.418716] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.419043] pci 0000:00:1c.2: BAR 13: assigned [io  0x1000-0x1fff]
[    0.419295] pci 0000:00:1c.3: BAR 13: assigned [io  0x2000-0x2fff]
[    0.419572] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
[    0.419843] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
[    0.420134] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.420442] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.420789] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.421098] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.421425] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.421752] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.422081] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.422389] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.422731] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.422937] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.423187] pci 0000:00:1c.0:   bridge window [mem 0x90900000-0x909fffff]
[    0.423485] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.423690] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.423940] pci 0000:00:1c.1:   bridge window [mem 0x90800000-0x908fffff]
[    0.424219] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.424423] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.424691] pci 0000:00:1c.2:   bridge window [mem 0x90600000-0x907fffff]
[    0.424971] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.425175] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.425430] pci_bus 0000:00: resource 4 [io  0x0070-0x0077]
[    0.425435] pci_bus 0000:00: resource 5 [io  0x0000-0x006f window]
[    0.425439] pci_bus 0000:00: resource 6 [io  0x0078-0x0cf7 window]
[    0.425444] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.425448] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff window]
[    0.425452] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff window]
[    0.425457] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000fffff window]
[    0.425461] pci_bus 0000:00: resource 11 [mem 0x80000000-0x90a15ffe window]
[    0.425483] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.425488] pci_bus 0000:01: resource 1 [mem 0x90900000-0x909fffff]
[    0.425493] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    0.425497] pci_bus 0000:02: resource 1 [mem 0x90800000-0x908fffff]
[    0.425501] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    0.425505] pci_bus 0000:03: resource 1 [mem 0x90600000-0x907fffff]
[    0.425510] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.425570] NET: Registered protocol family 2
[    0.426195] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.426862] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.427531] TCP: Hash tables configured (established 65536 bind 65536)
[    0.427887] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.428219] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.428682] NET: Registered protocol family 1
[    0.428891] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.429698] PCI: CLS 64 bytes, default 64
[    0.429841] Unpacking initramfs...
[    2.267200] Freeing initrd memory: 58124K (ffff880030e6a000 - ffff88003472d000)
[    2.267557] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.267819] software IO TLB [mem 0x72e41000-0x76e41000] (64MB) mapped at [ffff880072e41000-ffff880076e40fff]
[    2.270208] futex hash table entries: 512 (order: 3, 32768 bytes)
[    2.270511] audit: initializing netlink subsys (disabled)
[    2.270766] audit: type=2000 audit(1466669200.256:1): initialized
[    2.271729] Initialise system trusted keyrings
[    2.272114] workingset: timestamp_bits=34 max_order=21 bucket_order=0
[    2.276631] zbud: loaded
[    2.277276] Key type big_key registered
[    2.277480] SELinux:  Registering netfilter hooks
[    2.401334] NET: Registered protocol family 38
[    2.401526] Key type asymmetric registered
[    2.401725] Asymmetric key parser 'x509' registered
[    2.402035] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    2.402415] io scheduler noop registered
[    2.402583] io scheduler deadline registered (default)
[    2.402894] io scheduler cfq registered
[    2.404050] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.404290] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.404613] intel_idle: MWAIT substates: 0x3000020
[    2.404617] intel_idle: v0.4.1 model 0x37
[    2.404839] intel_idle: lapic_timer_reliable_states 0xffffffff
[    2.405034] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    2.405374] ACPI: Sleep Button [SLPB]
[    2.405626] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.405957] ACPI: Power Button [PWRF]
[    2.409591] GHES: HEST is not enabled!
[    2.409934] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.431226] 00:03: ttyS0 at I/O 0x3e0 (irq = 10, base_baud = 115200) is a 16550A
[    2.452662] 00:04: ttyS1 at I/O 0x2e0 (irq = 11, base_baud = 115200) is a 16550A
[    2.474134] 00:05: ttyS2 at I/O 0x3e8 (irq = 10, base_baud = 115200) is a 16550A
[    2.495538] 00:06: ttyS3 at I/O 0x2d0 (irq = 7, base_baud = 115200) is a 16550A
[    2.503533] hpet: number irqs doesn't agree with number of timers
[    2.509881] Non-volatile memory driver v1.3
[    2.514190] Linux agpgart interface v0.103
[    2.530307] tpm_tis 00:08: 1.2 TPM (device-id 0xFE, rev-id 2)
[    2.585388] rdac: device handler registered
[    2.590633] hp_sw: device handler registered
[    2.594966] emc: device handler registered
[    2.601175] alua: device handler registered
[    2.605522] libphy: Fixed MDIO Bus: probed
[    2.609785] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.616386] ehci-pci: EHCI PCI platform driver
[    2.620907] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.627149] ohci-pci: OHCI PCI platform driver
[    2.631660] uhci_hcd: USB Universal Host Controller Interface driver
[    2.638354] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.643753] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    2.652321] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
[    2.660837] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    2.661009] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.667863] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.675147] usb usb1: Product: xHCI Host Controller
[    2.680090] usb usb1: Manufacturer: Linux 4.7.0-rc3+ xhci-hcd
[    2.685887] usb usb1: SerialNumber: 0000:00:14.0
[    2.690845] hub 1-0:1.0: USB hub found
[    2.694678] hub 1-0:1.0: 6 ports detected
[    2.699765] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.705170] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    2.712980] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    2.719844] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.727132] usb usb2: Product: xHCI Host Controller
[    2.732061] usb usb2: Manufacturer: Linux 4.7.0-rc3+ xhci-hcd
[    2.737863] usb usb2: SerialNumber: 0000:00:14.0
[    2.742815] hub 2-0:1.0: USB hub found
[    2.746643] hub 2-0:1.0: 1 port detected
[    2.750980] usbcore: registered new interface driver usbserial
[    2.756897] usbcore: registered new interface driver usbserial_generic
[    2.763501] usbserial: USB Serial support registered for generic
[    2.769631] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    2.777416] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.782450] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.787813] mousedev: PS/2 mouse device common for all mice
[    2.794006] rtc_cmos 00:00: RTC can wake from S4
[    2.798896] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.805184] rtc_cmos 00:00: alarms up to one month, y3k, 242 bytes nvram
[    2.811978] intel_pstate: Intel P-state driver initializing
[    2.820922] hidraw: raw HID events driver (C) Jiri Kosina
[    2.827178] usbcore: registered new interface driver usbhid
[    2.832850] usbhid: USB HID core driver
[    2.837031] drop_monitor: Initializing network drop monitor service
[    2.843526] Initializing XFRM netlink socket
[    2.848546] NET: Registered protocol family 10
[    2.854691] NET: Registered protocol family 17
[    2.859841] microcode: CPU0 sig=0x30679, pf=0x1, revision=0x905
[    2.865829] microcode: CPU1 sig=0x30679, pf=0x1, revision=0x905
[    2.871880] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.881220] registered taskstats version 1
[    2.885372] Loading compiled-in X.509 certificates
[    2.901332] alg: No test for pkcs1pad(rsa,sha256) (pkcs1pad(rsa-generic,sha256))
[    2.911611] Loaded X.509 cert 'Build time autogenerated kernel key: c4696c2f1d5dfe6c4d4a1a994f6b5d46cb552de3'
[    2.921675] zswap: loaded using pool lzo/zbud
[    2.983866] Key type trusted registered
[    2.999205] Key type encrypted registered
[    3.062075] usb 1-4: new high-speed USB device number 2 using xhci_hcd
[    3.123364] evm: HMAC attrs: 0x1
[    3.128871] rtc_cmos 00:00: setting system clock to 2016-06-23 08:06:41 UTC (1466669201)
[    3.144152] Freeing unused kernel memory: 1812K (ffffffff81d65000 - ffffffff81f2a000)
[    3.152091] Write protecting the kernel read-only data: 12288k
[    3.159733] Freeing unused kernel memory: 1268K (ffff8800016c3000 - ffff880001800000)
[    3.174231] Freeing unused kernel memory: 1020K (ffff880001b01000 - ffff880001c00000)
[    3.197091] random: systemd urandom read with 2 bits of entropy available
[    3.214835] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    3.233722] systemd[1]: Detected architecture x86-64.
[    3.238838] systemd[1]: Running in initial RAM disk.
[    3.244581] usb 1-4: New USB device found, idVendor=0424, idProduct=2514
[    3.252936] usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.261072] hub 1-4:1.0: USB hub found
[    3.265904] hub 1-4:1.0: 4 ports detected
[    3.271421] tsc: Refined TSC clocksource calibration: 1750.000 MHz
[    3.279062] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1939a86d860, max_idle_ns: 440795286832 ns
[    3.294704] systemd[1]: Set hostname to <iot-r5s1-01.wlan.rhts.eng.bos.redhat.com>.
[    3.493112] systemd[1]: Reached target Local File Systems.
[    3.498720] systemd[1]: Starting Local File Systems.
[    3.508945] systemd[1]: Reached target Swap.
[    3.513302] systemd[1]: Starting Swap.
[    3.522958] systemd[1]: Reached target Timers.
[    3.527505] systemd[1]: Starting Timers.
[    3.538001] systemd[1]: Created slice -.slice.
[    3.542562] systemd[1]: Starting -.slice.
[    3.553024] systemd[1]: Listening on udev Kernel Socket.
[    3.558458] systemd[1]: Starting udev Kernel Socket.
[    3.569032] systemd[1]: Listening on Journal Socket.
[    3.574118] systemd[1]: Starting Journal Socket.
[    3.583132] usb 1-4.2: new high-speed USB device number 3 using xhci_hcd
[    3.590828] systemd[1]: Created slice System Slice.
[    3.595840] systemd[1]: Starting System Slice.
[    3.612524] systemd[1]: Starting Journal Service...
[    3.624576] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    3.652451] systemd[1]: Starting Setup Virtual Console...
[    3.672377] systemd[1]: Listening on udev Control Socket.
[    3.677964] systemd[1]: Starting udev Control Socket.
[    3.690841] systemd[1]: Reached target Sockets.
[    3.698543] usb 1-4.2: New USB device found, idVendor=1286, idProduct=2045
[    3.705492] usb 1-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.712865] usb 1-4.2: Product: Marvell Wireless Device
[    3.718145] usb 1-4.2: Manufacturer: Marvell
[    3.722461] usb 1-4.2: SerialNumber: 0000000000000000
[    3.731845] systemd[1]: Starting Sockets.
[    3.741196] systemd[1]: Started Load Kernel Modules.
[    3.756142] systemd[1]: Starting Apply Kernel Variables...
[    3.767065] systemd[1]: Started dracut ask for additional cmdline parameters.
[    3.776684] systemd[1]: Starting dracut cmdline hook...
[    3.793700] systemd[1]: Reached target Slices.
[    3.798288] systemd[1]: Starting Slices.
[    3.811003] systemd[1]: Started Journal Service.
[    4.291181] clocksource: Switched to clocksource tsc
[    4.621074] device-mapper: uevent: version 1.0.3
[    4.625914] device-mapper: ioctl: 4.34.0-ioctl (2015-10-28) initialised: dm-devel@redhat.com
[    5.077504] sdhci: Secure Digital Host Controller Interface driver
[    5.084580] sdhci: Copyright(c) Pierre Ossman
[    5.239496] FUJITSU Extended Socket Network Device Driver - version 1.1 - Copyright (c) 2015 FUJITSU LIMITED
[    5.355109] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.423311] r8169 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM control
[    5.469368] r8169 0000:01:00.0 eth0: RTL8168f/8111f at 0xffffc90000c70000, 74:e6:e2:e5:03:66, XID 08100880 IRQ 88
[    5.479712] r8169 0000:01:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    5.498091] [drm] Initialized drm 1.1.0 20060810
[    5.518031] libata version 3.00 loaded.
[    5.576572] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.590325] ahci 0000:00:13.0: version 3.0
[    5.590559] ahci 0000:00:13.0: controller can't do DEVSLP, turning off
[    5.597789] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[    5.611475] r8169 0000:02:00.0 eth1: RTL8168f/8111f at 0xffffc90000e7c000, 74:e6:e2:e5:03:67, XID 08100800 IRQ 90
[    5.621830] r8169 0000:02:00.0 eth1: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    5.631017] ahci 0000:00:13.0: AHCI 0001.0300 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    5.639179] ahci 0000:00:13.0: flags: 64bit ncq pm led clo pio slum part deso 
[    5.681926] scsi host0: ahci
[    5.695942] scsi host1: ahci
[    5.699555] ata1: SATA max UDMA/133 abar m2048@0x90a15000 port 0x90a15100 irq 89
[    5.707021] ata2: SATA max UDMA/133 abar m2048@0x90a15000 port 0x90a15180 irq 89
[    5.727980] r8169 0000:01:00.0: invalid large VPD tag 7f at offset 0
[    5.734735] r8169 0000:02:00.0: invalid large VPD tag 7f at offset 0
[    5.750090] r8169 0000:02:00.0 p4p2: renamed from eth1
[    6.026174] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.035546] ata1.00: ATA-8: LITEON J8-L1064-11 M.2 2260 64GB, 0J61104, max UDMA/133
[    6.043328] ata1.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    6.051362] ata1.00: configured for UDMA/133
[    6.056214] scsi 0:0:0:0: Direct-Access     ATA      LITEON J8-L1064- 104  PQ: 0 ANSI: 5
[    6.081847] r8169 0000:01:00.0 p4p1: renamed from eth0
[    6.096859] [drm] Memory usable by graphics device = 2048M
[    6.097280] ata2: SATA link down (SStatus 0 SControl 300)
[    6.107842] [drm] Replacing VGA console driver
[    6.113169] Console: switching to colour dummy device 80x25
[    6.119155] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    6.125836] [drm] Driver supports precise vblank timestamp query.
[    6.139415] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    6.174057] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
[    6.182772] sd 0:0:0:0: [sda] Write Protect is off
[    6.187624] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.187971] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.198440]  sda: sda1 sda2
[    6.201975] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.487659] i915 0000:00:02.0: No connectors reported connected with modes
[    6.496539] [drm] Cannot find any crtc or sizes - going 1024x768
[    6.504929] fbcon: inteldrmfb (fb0) is primary device
[    6.506654] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    6.933885] Console: switching to colour frame buffer device 128x48
[    6.958713] acpi device:09: registered as cooling_device2
[    6.959813] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    6.960447] [drm] Initialized i915 1.6.0 20160425 for 0000:00:02.0 on minor 0
[    6.996670] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    8.147817] SGI XFS with ACLs, security attributes, no debug enabled
[    8.168661] XFS (dm-0): Mounting V4 Filesystem
[    8.232098] XFS (dm-0): Ending clean mount
[    9.016025] systemd-journald[135]: Received SIGTERM from PID 1 (systemd).
[    9.167791] audit: type=1404 audit(1466669207.528:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    9.212281] SELinux: 32768 avtab hash slots, 112391 rules.
[    9.267562] SELinux: 32768 avtab hash slots, 112391 rules.
[    9.362942] SELinux:  8 users, 105 roles, 4954 types, 302 bools, 1 sens, 1024 cats
[    9.362951] SELinux:  83 classes, 112391 rules
[    9.373543] SELinux:  Permission validate_trans in class security not defined in policy.
[    9.381723] SELinux:  Permission module_load in class system not defined in policy.
[    9.389573] SELinux:  Class netlink_iscsi_socket not defined in policy.
[    9.396239] SELinux:  Class netlink_fib_lookup_socket not defined in policy.
[    9.403335] SELinux:  Class netlink_connector_socket not defined in policy.
[    9.410341] SELinux:  Class netlink_netfilter_socket not defined in policy.
[    9.417358] SELinux:  Class netlink_generic_socket not defined in policy.
[    9.424194] SELinux:  Class netlink_scsitransport_socket not defined in policy.
[    9.431548] SELinux:  Class netlink_rdma_socket not defined in policy.
[    9.438117] SELinux:  Class netlink_crypto_socket not defined in policy.
[    9.444880] SELinux:  Permission audit_read in class capability2 not defined in policy.
[    9.452951] SELinux:  Class binder not defined in policy.
[    9.458390] SELinux:  Class cap_userns not defined in policy.
[    9.464175] SELinux:  Class cap2_userns not defined in policy.
[    9.470048] SELinux: the above unknown classes and permissions will be allowed
[    9.477333] SELinux:  Completing initialization.
[    9.477336] SELinux:  Setting up existing superblocks.
[    9.491966] audit: type=1403 audit(1466669207.851:3): policy loaded auid=4294967295 ses=4294967295
[    9.516970] systemd[1]: Successfully loaded SELinux policy in 347.667ms.
[    9.555847] systemd[1]: RTC configured in localtime, applying delta of -240 minutes to system time.
[    9.595507] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.601298] systemd[1]: Inserted module 'ip_tables'
[    9.724985] systemd[1]: Relabelled /dev and /run in 108.555ms.
[   10.402910] RPC: Registered named UNIX socket transport module.
[   10.409174] RPC: Registered udp transport module.
[   10.415306] RPC: Registered tcp transport module.
[   10.415307] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   10.653381] systemd-journald[524]: Received request to flush runtime journal from PID 1
[   10.807279] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   11.375140] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   11.640588] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   11.738935] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   11.804936] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   11.910386] SSE version of gcm_enc/dec engaged.
[   12.189184] Adding 6254588k swap on /dev/mapper/rhel_iot--r5s1--01-swap.  Priority:-1 extents:1 across:6254588k SSFS
[   12.354555] XFS (sda1): Mounting V4 Filesystem
[   12.373947] mwifiex_pcie: try set_consistent_dma_mask(32)
[   12.381815] mwifiex_pcie: PCI memory map Virt0: ffffc90001e00000 PCI memory map Virt2: ffffc90002000000
[   12.391702] mwifiex: rx work enabled, cpus 2
[   12.528557] XFS (sda1): Ending clean mount
[   13.780407] mwifiex_pcie 0000:03:00.0: info: FW download over, size 820212 bytes
[   13.822111] XFS (dm-2): Mounting V4 Filesystem
[   13.856950] XFS (dm-2): Ending clean mount
[   13.994787] usb 1-4.2: USB disconnect, device number 3
[   14.186922] usb 1-4.2: new high-speed USB device number 4 using xhci_hcd
[   14.279008] usb 1-4.2: New USB device found, idVendor=1286, idProduct=2046
[   14.286540] usb 1-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   14.293937] usb 1-4.2: Product: Bluetooth and Wireless LAN Composite Device
[   14.300982] usb 1-4.2: Manufacturer: Marvell
[   14.305304] usb 1-4.2: SerialNumber: 0000000000000000
[   14.343795] audit: type=1305 audit(1466683612.696:4): audit_pid=712 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[   14.520735] mwifiex_pcie 0000:03:00.0: WLAN FW is active
[   14.539299] Bluetooth: Core ver 2.21
[   14.543293] NET: Registered protocol family 31
[   14.547797] Bluetooth: HCI device and connection manager initialized
[   14.554368] Bluetooth: HCI socket layer initialized
[   14.559379] Bluetooth: L2CAP socket layer initialized
[   14.565296] Bluetooth: SCO socket layer initialized
[   14.626723] usbcore: registered new interface driver btusb
[   14.663968] mwifiex_pcie 0000:03:00.0: info: MWIFIEX VERSION: mwifiex 1.0 (15.68.7.p77) 
[   14.671250] mwifiex_pcie 0000:03:00.0 wlp3s0: renamed from mlan0
[   14.680664] mwifiex_pcie 0000:03:00.0: driver_version = mwifiex 1.0 (15.68.7.p77) 
[   15.215724] random: nonblocking pool is initialized
[   15.889807] IPv6: ADDRCONF(NETDEV_UP): p4p2: link is not ready
[   15.940831] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   15.946213] Bluetooth: BNEP filters: protocol multicast
[   15.951512] Bluetooth: BNEP socket layer initialized
[   15.959613] r8169 0000:02:00.0 p4p2: link down
[   15.965082] IPv6: ADDRCONF(NETDEV_UP): p4p2: link is not ready
[   15.981886] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[   16.016620] r8169 0000:01:00.0 p4p1: link down
[   16.021195] r8169 0000:01:00.0 p4p1: link down
[   16.021667] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[   16.044664] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[   16.051479] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[   16.391762] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
[   19.035492] r8169 0000:01:00.0 p4p1: link up
[   19.039881] IPv6: ADDRCONF(NETDEV_CHANGE): p4p1: link becomes ready
[   28.192128] FS-Cache: Loaded
[   28.379186] FS-Cache: Netfs 'nfs' registered for caching
[   28.419215] Key type dns_resolver registered
[   28.652901] NFS: Registering the id_resolver key type
[   28.658070] Key type id_resolver registered
[   28.662312] Key type id_legacy registered
[   30.523551] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   30.587031] Ebtables v2.0 registered
[   30.873237] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[   30.921444] tun: Universal TUN/TAP device driver, 1.6
[   30.926546] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   30.963571] virbr0: port 1(virbr0-nic) entered blocking state
[   30.969403] virbr0: port 1(virbr0-nic) entered disabled state
[   30.976052] device virbr0-nic entered promiscuous mode
[   31.239725] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[   31.483422] virbr0: port 1(virbr0-nic) entered blocking state
[   31.489247] virbr0: port 1(virbr0-nic) entered listening state
[   31.604664] virbr0: port 1(virbr0-nic) entered disabled state
[   45.020646] ieee80211 phy0: mwifiex_cfg80211_sched_scan_start : Invalid Sched_scan parameters
[   78.087926] ieee80211 phy0: mwifiex_cfg80211_sched_scan_start : Invalid Sched_scan parameters

--TB36FDmn/VVEgNH/--

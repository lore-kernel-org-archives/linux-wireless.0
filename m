Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:53661 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932329AbdJ0VDU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 17:03:20 -0400
Received: by mail-wm0-f65.google.com with SMTP id r196so5985982wmf.2
        for <linux-wireless@vger.kernel.org>; Fri, 27 Oct 2017 14:03:19 -0700 (PDT)
Subject: Re: rtlwifi oops
To: James Cameron <quozl@laptop.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
References: <cf61cfda-1e32-3ec3-d558-b508c3b923b6@gmail.com>
 <20171018223320.GB641@us.netrek.org>
 <c13aa975-6339-2f5a-20bb-0a82656a2271@gmail.com>
 <fcf4b761-d7bd-7956-fa98-07fd8b2f8c3b@lwfinger.net>
 <b86480bd-49b9-f7ac-5dc5-6f6f83942727@gmail.com>
 <d65baa01-c842-0d14-5760-bbc1c754b1e6@lwfinger.net>
 <d9e6052f-cc92-813b-6cd6-9907f5bd82be@gmail.com>
 <a1ca0a52-c033-205a-8b3e-e6879016728c@gmail.com>
 <20171027045716.GH9888@us.netrek.org>
From: nirinA raseliarison <nirina.raseliarison@gmail.com>
Message-ID: <7532bb89-9f58-f2e2-e9c3-baa4be24da81@gmail.com> (sfid-20171027_230327_877169_1937551A)
Date: Sat, 28 Oct 2017 00:02:30 +0300
MIME-Version: 1.0
In-Reply-To: <20171027045716.GH9888@us.netrek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/2017 07:57 AM, James Cameron wrote:
> On Fri, Oct 27, 2017 at 04:08:48AM +0300, nirinA raseliarison wrote:
>> hi all,
>> i applied the patch against 4.13.8. i still got some trouble, dmesg
>> is below.
>
> As this new event does not have "disabled by hub (EMI?)", it is a
> different problem to your 19th October post, so I don't think the
> patch is relevant.
>
>> after i plugged the device, it seems to be detected and all modules
>> loaded, but when i tried to connect to an access point, by using
>> wicd, it halted after a while. at this point, all usb ports are
>> broken, there was no more log in dmesg,
>
> If the other USB ports are not responding, then your problem is
> probably wider than the wireless device, and the wireless device
> is acting as the "canary in the mine"; failing first because it is
> the most active.
>
> Can you test to exclude possibility of damaged USB host controller or
> hub?

yes, dmesg below with an usb audio adapter and a usb mouse plugged at
boot time. then the rtl8192cu plugged, and i'm using it to retrieve
and send this mail.

my first guess was also about a damaged device or usb port
as those random crashes are recent.
note that the device i'm using here is not the same as the one
that triggered the previous errors.

>> lsusb still showed the device even after being unplugged. it got
>> even worse as reboot failed.
>
> Yes, once a USB host controller is failed, organised reboot can be
> difficult.  lsusb not updated confirms host controller not responding.
>
>> i cannot really trace the error as right now all thing works fine.
>
> Your dmesg looks like you removed and reinserted the wireless device
> several times.  Did you do that, or did the system do it without any
> physical action?

no, the device was always connected. i've only removed it long after
i noticed something went wrong and just before i tried reboot.

> A full dmesg from boot may be interesting, at least to better
> understand the USB host controller.
>

here it is.
thanks,

##
[    0.000000] random: get_random_bytes called from 
start_kernel+0x2a/0x413 with crng_init=0
[    0.000000] Linux version 4.13.8.20171019 (root@supernova) (gcc 
version 7.2.0 (GCC)) #1 SMP Thu Oct 19 03:53:05 EAT 2017
[    0.000000] Command line: BOOT_IMAGE=nirinA ro root=802 
vt.default_utf8=0 console=tty0 raid=noautodetect
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating 
point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Enabled xstate features 0x3, context size is 576 
bytes, using 'standard' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000cdf30fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cdf31000-0x00000000ce25afff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ce25b000-0x00000000ce25bfff] 
ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000ce25c000-0x00000000ce373fff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ce374000-0x00000000ce6d8fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ce6d9000-0x00000000ce6d9fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ce6da000-0x00000000ce71cfff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ce71d000-0x00000000cee19fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cee1a000-0x00000000ceff1fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ceff2000-0x00000000ceffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf800000-0x00000000df9fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] random: fast init done
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: To be filled by O.E.M. To be filled by O.E.M./ONDA 
H61V Ver:4.01, BIOS 4.6.5 01/07/2013
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x21f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   4 base 0CF800000 mask FFF800000 uncachable
[    0.000000]   5 base 21F800000 mask FFF800000 uncachable
[    0.000000]   6 base 21F600000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- 
WT
[    0.000000] e820: update [mem 0xcf800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcf000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd6f0-0x000fd6ff] mapped 
at [ffff8800000fd6f0]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] BRK [0x02145000, 0x02145fff] PGTABLE
[    0.000000] BRK [0x02146000, 0x02146fff] PGTABLE
[    0.000000] BRK [0x02147000, 0x02147fff] PGTABLE
[    0.000000] BRK [0x02148000, 0x02148fff] PGTABLE
[    0.000000] BRK [0x02149000, 0x02149fff] PGTABLE
[    0.000000] BRK [0x0214a000, 0x0214afff] PGTABLE
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000CE362070 000064 (v01 ALASKA A M I 
01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000CE36B698 0000F4 (v04 ALASKA A M I 
01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000CE362170 009526 (v02 ALASKA A M I 
00000660 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000CE372F80 000040
[    0.000000] ACPI: APIC 0x00000000CE36B790 000062 (v03 ALASKA A M I 
01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000CE36B7F8 000044 (v01 ALASKA A M I 
01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000CE36B840 00003C (v01 ALASKA A M I 
01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000CE36B880 000038 (v01 ALASKA A M I 
01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000CE36B8B8 00036D (v01 SataRe SataTabl 
00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000CE36BC28 000860 (v01 PmRef  Cpu0Ist 
00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000CE36C488 000A92 (v01 PmRef  CpuPm 
00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000021f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001fffffff]
[    0.000000]   node   0: [mem 0x0000000020200000-0x0000000040003fff]
[    0.000000]   node   0: [mem 0x0000000040005000-0x00000000cdf30fff]
[    0.000000]   node   0: [mem 0x00000000ce6d9000-0x00000000ce6d9fff]
[    0.000000]   node   0: [mem 0x00000000ce71d000-0x00000000cee19fff]
[    0.000000]   node   0: [mem 0x00000000ceff2000-0x00000000ceffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000021f5fffff]
[    0.000000] Initmem setup node 0 [mem 
0x0000000000001000-0x000000021f5fffff]
[    0.000000] On node 0 totalpages: 2021848
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13137 pages used for memmap
[    0.000000]   DMA32 zone: 840764 pages, LIFO batch:31
[    0.000000]   Normal zone: 18392 pages used for memmap
[    0.000000]   Normal zone: 1177088 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics memory at 
0x00000000cfa00000-0x00000000df9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0xcdf31000-0xce25afff]
[    0.000000] PM: Registered nosave memory: [mem 0xce25b000-0xce25bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xce25c000-0xce373fff]
[    0.000000] PM: Registered nosave memory: [mem 0xce374000-0xce6d8fff]
[    0.000000] PM: Registered nosave memory: [mem 0xce6da000-0xce71cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcee1a000-0xceff1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf000000-0xcf7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf800000-0xdf9fffff]
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
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff 
max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 
nr_node_ids:1
[    0.000000] percpu: Embedded 37 pages/cpu @ffff88021f200000 s111192 
r8192 d32168 u1048576
[    0.000000] pcpu-alloc: s111192 r8192 d32168 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 1990234
[    0.000000] Kernel command line: BOOT_IMAGE=nirinA ro root=802 
vt.default_utf8=0 console=tty0 raid=noautodetect
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 
8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 
4194304 bytes)
[    0.000000] Memory: 7863988K/8087392K available (9617K kernel code, 
1116K rwdata, 3012K rodata, 1440K init, 660K bss, 223404K reserved, 0K 
cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] ftrace: allocating 36813 entries in 144 pages
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] NR_IRQS: 4352, nr_irqs: 440, preallocated irqs: 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 
0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 2594.066 MHz processor
[    0.001000] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 5188.13 BogoMIPS (lpj=2594066)
[    0.001000] pid_max: default: 32768 minimum: 301
[    0.001000] ACPI: Core revision 20170531
[    0.005766] ACPI: 4 ACPI AML tables successfully acquired and loaded
[    0.005787] Security Framework initialized
[    0.005817] Mount-cache hash table entries: 16384 (order: 5, 131072 
bytes)
[    0.005843] Mountpoint-cache hash table entries: 16384 (order: 5, 
131072 bytes)
[    0.005982] CPU: Physical Processor ID: 0
[    0.005986] CPU: Processor Core ID: 0
[    0.005991] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.006003] ENERGY_PERF_BIAS: View and update with 
x86_energy_perf_policy(8)
[    0.006009] mce: CPU supports 7 MCE banks
[    0.006018] CPU0: Thermal monitoring enabled (TM1)
[    0.006028] process: using mwait in idle threads
[    0.006032] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.006035] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.006111] Freeing SMP alternatives memory: 36K
[    0.007054] smpboot: Max logical packages: 1
[    0.007467] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.017646] TSC deadline timer enabled
[    0.017648] smpboot: CPU0: Intel(R) Celeron(R) CPU G1610 @ 2.60GHz 
(family: 0x6, model: 0x3a, stepping: 0x9)
[    0.017701] Performance Events: PEBS fmt1+, IvyBridge events, 16-deep 
LBR, full-width counters, Intel PMU driver.
[    0.017726] ... version:                3
[    0.017728] ... bit width:              48
[    0.017731] ... generic registers:      8
[    0.017734] ... value mask:             0000ffffffffffff
[    0.017737] ... max period:             00007fffffffffff
[    0.017740] ... fixed-purpose events:   3
[    0.017743] ... event mask:             00000007000000ff
[    0.017772] Hierarchical SRCU implementation.
[    0.017840] smp: Bringing up secondary CPUs ...
[    0.017888] x86: Booting SMP configuration:
[    0.017892] .... node  #0, CPUs:      #1
[    0.078018] smp: Brought up 1 node, 2 CPUs
[    0.078018] smpboot: Total of 2 processors activated (10379.97 BogoMIPS)
[    0.079123] devtmpfs: initialized
[    0.079123] x86/mm: Memory block size: 128MB
[    0.079489] PM: Registering ACPI NVS region [mem 
0xce25c000-0xce373fff] (1146880 bytes)
[    0.079489] PM: Registering ACPI NVS region [mem 
0xce6da000-0xce71cfff] (274432 bytes)
[    0.079489] clocksource: jiffies: mask: 0xffffffff max_cycles: 
0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.079489] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.079489] pinctrl core: initialized pinctrl subsystem
[    0.079489] NET: Registered protocol family 16
[    0.080026] cpuidle: using governor ladder
[    0.080026] cpuidle: using governor menu
[    0.080026] PCCT header not found.
[    0.080048] ACPI: bus type PCI registered
[    0.080052] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.080082] PCI: Using configuration type 1 for base access
[    0.080122] core: PMU erratum BJ122, BV98, HSD29 workaround disabled, 
HT off
[    0.083368] ACPI: Added _OSI(Module Device)
[    0.083368] ACPI: Added _OSI(Processor Device)
[    0.083368] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.083368] ACPI: Added _OSI(Processor Aggregator Device)
[    0.083368] ACPI: Executed 1 blocks of module-level executable AML code
[    0.086305] ACPI: Dynamic OEM Table Load:
[    0.086314] ACPI: SSDT 0xFFFF880216669000 00083B (v01 PmRef  Cpu0Cst 
00003001 INTL 20051117)
[    0.086395] ACPI: Dynamic OEM Table Load:
[    0.086395] ACPI: SSDT 0xFFFF88021642DC00 000303 (v01 PmRef  ApIst 
00003000 INTL 20051117)
[    0.087030] ACPI: Dynamic OEM Table Load:
[    0.087035] ACPI: SSDT 0xFFFF880216708200 000119 (v01 PmRef  ApCst 
00003000 INTL 20051117)
[    0.087379] ACPI: Interpreter enabled
[    0.087401] ACPI: (supports S0 S1 S3 S4 S5)
[    0.087404] ACPI: Using IOAPIC for interrupt routing
[    0.087428] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.092821] ACPI: Power Resource [FN00] (off)
[    0.092884] ACPI: Power Resource [FN01] (off)
[    0.092945] ACPI: Power Resource [FN02] (off)
[    0.093005] ACPI: Power Resource [FN03] (off)
[    0.093066] ACPI: Power Resource [FN04] (off)
[    0.093467] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.093474] acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments 
MSI]
[    0.093596] acpi PNP0A08:00: _OSC: not requesting OS control; OS 
requires [ExtendedConfig ASPM ClockPM MSI]
[    0.093955] PCI host bridge to bus 0000:00
[    0.093960] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.093963] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.093967] pci_bus 0000:00: root bus resource [mem 
0x000a0000-0x000bffff window]
[    0.093972] pci_bus 0000:00: root bus resource [mem 
0x000d4000-0x000d7fff window]
[    0.093978] pci_bus 0000:00: root bus resource [mem 
0x000d8000-0x000dbfff window]
[    0.093983] pci_bus 0000:00: root bus resource [mem 
0x000dc000-0x000dffff window]
[    0.093988] pci_bus 0000:00: root bus resource [mem 
0x000e0000-0x000e3fff window]
[    0.093993] pci_bus 0000:00: root bus resource [mem 
0x000e4000-0x000e7fff window]
[    0.093998] pci_bus 0000:00: root bus resource [mem 
0xdfa00000-0xfeafffff window]
[    0.094002] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.094012] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.094090] pci 0000:00:02.0: [8086:0152] type 00 class 0x030000
[    0.094100] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.094105] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 
64bit pref]
[    0.094109] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.094202] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.094227] pci 0000:00:16.0: reg 0x10: [mem 0xf7c0a000-0xf7c0a00f 64bit]
[    0.094298] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.094370] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.094391] pci 0000:00:1a.0: reg 0x10: [mem 0xf7c08000-0xf7c083ff]
[    0.094474] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.094540] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.094558] pci 0000:00:1b.0: reg 0x10: [mem 0xf7c00000-0xf7c03fff 64bit]
[    0.094623] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.094688] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.094764] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.094834] pci 0000:00:1c.2: [8086:1c14] type 01 class 0x060400
[    0.094909] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.094983] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.095004] pci 0000:00:1d.0: reg 0x10: [mem 0xf7c07000-0xf7c073ff]
[    0.095086] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.095153] pci 0000:00:1f.0: [8086:1c5c] type 00 class 0x060100
[    0.095317] pci 0000:00:1f.2: [8086:1c02] type 00 class 0x010601
[    0.095335] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    0.095342] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    0.095350] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
[    0.095357] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
[    0.095364] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.095371] pci 0000:00:1f.2: reg 0x24: [mem 0xf7c06000-0xf7c067ff]
[    0.095411] pci 0000:00:1f.2: PME# supported from D3hot
[    0.095471] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.095489] pci 0000:00:1f.3: reg 0x10: [mem 0xf7c05000-0xf7c050ff 64bit]
[    0.095509] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.095626] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.095700] pci 0000:02:00.0: [10ec:8136] type 00 class 0x020000
[    0.095725] pci 0000:02:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    0.095758] pci 0000:02:00.0: reg 0x18: [mem 0xf0004000-0xf0004fff 
64bit pref]
[    0.095778] pci 0000:02:00.0: reg 0x20: [mem 0xf0000000-0xf0003fff 
64bit pref]
[    0.095870] pci 0000:02:00.0: supports D1 D2
[    0.095871] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.098023] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.098032] pci 0000:00:1c.2:   bridge window [io  0xe000-0xefff]
[    0.098042] pci 0000:00:1c.2:   bridge window [mem 
0xf0000000-0xf00fffff 64bit pref]
[    0.098071] pci_bus 0000:00: on NUMA node 0
[    0.098356] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 
14 15)
[    0.098402] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 
15) *0, disabled.
[    0.098448] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 
14 15)
[    0.098490] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 
14 15)
[    0.098533] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 
15) *0, disabled.
[    0.098578] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 
15) *0, disabled.
[    0.098623] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 
14 15)
[    0.098666] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 
14 15)
[    0.098825] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.098882] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.098882] pci 0000:00:02.0: vgaarb: VGA device added: 
decodes=io+mem,owns=io+mem,locks=none
[    0.098882] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.098882] vgaarb: loaded
[    0.098882] SCSI subsystem initialized
[    0.099002] libata version 3.00 loaded.
[    0.099005] ACPI: bus type USB registered
[    0.099023] usbcore: registered new interface driver usbfs
[    0.099033] usbcore: registered new interface driver hub
[    0.099043] usbcore: registered new device driver usb
[    0.099057] EDAC MC: Ver: 3.0.0
[    0.099114] PCI: Using ACPI for IRQ routing
[    0.099114] PCI: pci_cache_line_size set to 64 bytes
[    0.099114] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.099114] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.099114] e820: reserve RAM buffer [mem 0xcdf31000-0xcfffffff]
[    0.099114] e820: reserve RAM buffer [mem 0xce6da000-0xcfffffff]
[    0.099114] e820: reserve RAM buffer [mem 0xcee1a000-0xcfffffff]
[    0.099114] e820: reserve RAM buffer [mem 0xcf000000-0xcfffffff]
[    0.099114] e820: reserve RAM buffer [mem 0x21f600000-0x21fffffff]
[    0.099133] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.099133] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.101009] clocksource: Switched to clocksource hpet
[    0.106961] VFS: Disk quotas dquot_6.6.0
[    0.106981] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 
bytes)
[    0.107043] pnp: PnP ACPI init
[    0.107133] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.107139] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.107197] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.107201] system 00:01: [io  0x0200-0x020f] has been reserved
[    0.107205] system 00:01: [io  0xffff] has been reserved
[    0.107209] system 00:01: [io  0xffff] has been reserved
[    0.107212] system 00:01: [io  0x0400-0x0453] has been reserved
[    0.107216] system 00:01: [io  0x0458-0x047f] has been reserved
[    0.107219] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.107223] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.107227] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.107245] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.107278] system 00:03: [io  0x0454-0x0457] has been reserved
[    0.107282] system 00:03: Plug and Play ACPI device, IDs INT3f0d 
PNP0c02 (active)
[    0.107342] system 00:04: [io  0x0a30-0x0a3f] has been reserved
[    0.107346] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.107376] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 PNP030b 
(active)
[    0.107487] pnp 00:06: [dma 0 disabled]
[    0.107520] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.107553] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.107558] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.107712] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.107716] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.107720] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.107724] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.107727] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.107731] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.107735] system 00:08: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.107739] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.107742] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.107746] system 00:08: [mem 0xfee00000-0xfeefffff] could not be 
reserved
[    0.107750] system 00:08: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.107754] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.107866] system 00:09: [mem 0x20000000-0x201fffff] has been reserved
[    0.107870] system 00:09: [mem 0x40004000-0x40004fff] has been reserved
[    0.107874] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.107891] pnp: PnP ACPI: found 10 devices
[    0.113798] clocksource: acpi_pm: mask: 0xffffff max_cycles: 
0xffffff, max_idle_ns: 2085701024 ns
[    0.113825] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.113839] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.113845] pci 0000:00:1c.2:   bridge window [io  0xe000-0xefff]
[    0.113854] pci 0000:00:1c.2:   bridge window [mem 
0xf0000000-0xf00fffff 64bit pref]
[    0.113865] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.113866] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.113867] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff 
window]
[    0.113868] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff 
window]
[    0.113869] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff 
window]
[    0.113870] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff 
window]
[    0.113871] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000e3fff 
window]
[    0.113872] pci_bus 0000:00: resource 11 [mem 0x000e4000-0x000e7fff 
window]
[    0.113873] pci_bus 0000:00: resource 12 [mem 0xdfa00000-0xfeafffff 
window]
[    0.113874] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.113875] pci_bus 0000:02: resource 2 [mem 0xf0000000-0xf00fffff 
64bit pref]
[    0.113947] NET: Registered protocol family 2
[    0.114057] TCP established hash table entries: 65536 (order: 7, 
524288 bytes)
[    0.114158] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.114341] TCP: Hash tables configured (established 65536 bind 65536)
[    0.114371] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.114399] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.114458] NET: Registered protocol family 1
[    0.114555] RPC: Registered named UNIX socket transport module.
[    0.114559] RPC: Registered udp transport module.
[    0.114562] RPC: Registered tcp transport module.
[    0.114564] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.114579] pmd_set_huge: Cannot satisfy [mem 0xf7800000-0xf7a00000] 
with a huge-page mapping due to MTRR override.
[    0.114592] pci 0000:00:02.0: BIOS left Intel GPU interrupts enabled; 
disabling
[    0.114611] pci 0000:00:02.0: Video device with shadowed ROM at [mem 
0x000c0000-0x000dffff]
[    0.147118] PCI: CLS 64 bytes, default 64
[    0.147154] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.147158] software IO TLB [mem 0xc9f31000-0xcdf31000] (64MB) mapped 
at [ffff8800c9f31000-ffff8800cdf30fff]
[    0.147223] RAPL PMU: API unit is 2^-32 Joules, 3 fixed counters, 
163840 ms ovfl timer
[    0.147228] RAPL PMU: hw unit of domain pp0-core 2^-16 Joules
[    0.147231] RAPL PMU: hw unit of domain package 2^-16 Joules
[    0.147234] RAPL PMU: hw unit of domain pp1-gpu 2^-16 Joules
[    0.147496] audit: initializing netlink subsys (disabled)
[    0.147530] audit: type=2000 audit(1509135453.147:1): 
state=initialized audit_enabled=0 res=1
[    0.147671] workingset: timestamp_bits=46 max_order=21 bucket_order=0
[    0.148709] NFS: Registering the id_resolver key type
[    0.148718] Key type id_resolver registered
[    0.148721] Key type id_legacy registered
[    0.148725] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.148801] ntfs: driver 2.1.32 [Flags: R/W].
[    0.148830] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.150274] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 252)
[    0.150303] io scheduler noop registered
[    0.150306] io scheduler deadline registered
[    0.150327] io scheduler cfq registered (default)
[    0.150330] io scheduler mq-deadline registered
[    0.150333] io scheduler kyber registered
[    0.150618] vesafb: mode is 1024x768x16, linelength=2048, pages=169
[    0.150622] vesafb: scrolling: redraw
[    0.150625] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.150638] vesafb: framebuffer at 0xe0000000, mapped to 
0xffffc90000c00000, using 3072k, total 262080k
[    0.175394] Console: switching to colour frame buffer device 128x48
[    0.198189] fb0: VESA VGA frame buffer device
[    0.198401] intel_idle: MWAIT substates: 0x1120
[    0.198402] intel_idle: v0.4.1 model 0x3A
[    0.198455] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.198512] GHES: HEST is not enabled!
[    0.201091] brd: module loaded
[    0.201390] fnic: Cisco FCoE HBA Driver, ver 1.6.0.34
[    0.201638] fnic: Successfully Initialized Trace Buffer
[    0.201906] fnic: Successfully Initialized FC_CTLR Trace Buffer
[    0.202354] Adaptec aacraid driver 1.2.1[50834]-custom
[    0.202601] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    0.203042] scsi: <fdomain> Detection failed (no card)
[    0.203293] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA 
Driver: 10.00.00.00-k.
[    0.203682] Emulex LightPulse Fibre Channel SCSI driver 11.4.0.1
[    0.203960] Copyright (C) 2017 Broadcom. All Rights Reserved. The 
term "Broadcom" refers to Broadcom Limited and/or its subsidiaries.
[    0.204583] QLogic BR-series BFA FC/FCOE SCSI driver - version: 3.2.25.1
[    0.204927] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 
EST 2006)
[    0.205288] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 
2006)
[    0.205618] megasas: 07.701.17.00-rc1
[    0.205797] mpt3sas version 15.100.00.00 loaded
[    0.215058] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    0.224498] 3ware Storage Controller device driver for Linux 
v1.26.02.003.
[    0.233996] 3ware 9000 Storage Controller device driver for Linux 
v2.26.02.014.
[    0.243526] LSI 3ware SAS/SATA-RAID Controller device driver for 
Linux v3.26.02.000.
[    0.253071] ipr: IBM Power RAID SCSI Device Driver version: 2.6.4 
(March 14, 2017)
[    0.262627] RocketRAID 3xxx/4xxx Controller driver v1.10.0
[    0.272099] stex: Promise SuperTrak EX Driver version: 6.02.0000.01
[    0.281704] st: Version 20160209, fixed bufsize 32768, s/g segs 256
[    0.291470] ahci 0000:00:1f.2: version 3.0
[    0.291637] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 
0x3 impl SATA mode
[    0.301535] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum 
part ems apst
[    0.314344] scsi host0: ahci
[    0.324214] scsi host1: ahci
[    0.333812] scsi host2: ahci
[    0.343146] scsi host3: ahci
[    0.352316] ata1: SATA max UDMA/133 abar m2048@0xf7c06000 port 
0xf7c06100 irq 24
[    0.361837] ata2: SATA max UDMA/133 abar m2048@0xf7c06000 port 
0xf7c06180 irq 24
[    0.371288] ata3: DUMMY
[    0.380649] ata4: DUMMY
[    0.390440] scsi host4: pata_legacy
[    0.399689] ata5: PATA max PIO4 cmd 0x1f0 ctl 0x3f6 irq 14
[    0.708585] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.718014] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.727274] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND 
(20170531/psargs-364)
[    0.736604] ACPI Error: Method parse/execution failed 
\_SB.PCI0.SAT0.SPT0._GTF, AE_NOT_FOUND (20170531/psparse-550)
[    0.746153] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND 
(20170531/psargs-364)
[    0.755718] ACPI Error: Method parse/execution failed 
\_SB.PCI0.SAT0.SPT1._GTF, AE_NOT_FOUND (20170531/psparse-550)
[    0.765606] ata2.00: ATAPI: TSSTcorp CDDVDW SH-224BB, SB00, max UDMA/100
[    0.775609] ata1.00: ATA-8: ST500DM002-1BD142, KC45, max UDMA/133
[    0.785624] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    0.797067] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND 
(20170531/psargs-364)
[    0.807493] ACPI Error: Method parse/execution failed 
\_SB.PCI0.SAT0.SPT0._GTF, AE_NOT_FOUND (20170531/psparse-550)
[    0.818177] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND 
(20170531/psargs-364)
[    0.828867] ACPI Error: Method parse/execution failed 
\_SB.PCI0.SAT0.SPT1._GTF, AE_NOT_FOUND (20170531/psparse-550)
[    0.839762] ata2.00: configured for UDMA/100
[    0.850477] ata1.00: configured for UDMA/133
[    1.183036] tsc: Refined TSC clocksource calibration: 2594.107 MHz
[    1.193411] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 
0x25647d583cf, max_idle_ns: 440795304232 ns
[    2.207229] clocksource: Switched to clocksource tsc
[    3.231153] floppy0: no floppy controllers found
[    3.241619] scsi 0:0:0:0: Direct-Access     ATA      ST500DM002-1BD14 
KC45 PQ: 0 ANSI: 5
[    3.252177] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 
GB/466 GiB)
[    3.262613] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    3.273018] sd 0:0:0:0: [sda] Write Protect is off
[    3.273021] scsi 1:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-224BB 
SB00 PQ: 0 ANSI: 5
[    3.293731] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.293742] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    3.319639] sr 1:0:0:0: [sr0] scsi3-mmc drive: 48x/48x writer dvd-ram 
cd/rw xa/form2 cdda tray
[    3.330204] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.340791] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.343079]  sda: sda1 sda2 sda3 sda5 sda6
[    3.353800] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.364320] scsi host4: pata_legacy
[    3.374453] ata6: PATA max PIO4 cmd 0x170 ctl 0x376 irq 15
[    3.543439] Fusion MPT base driver 3.04.20
[    3.553407] Copyright (c) 1999-2008 LSI Corporation
[    3.563330] Fusion MPT SPI Host driver 3.04.20
[    3.573403] Fusion MPT FC Host driver 3.04.20
[    3.583554] Fusion MPT SAS Host driver 3.04.20
[    3.593795] Fusion MPT misc device (ioctl) driver 3.04.20
[    3.604011] mptctl: Registered with Fusion MPT base driver
[    3.614354] mptctl: /dev/mptctl @ (major,minor=10,220)
[    3.624610] Fusion MPT LAN driver 3.04.20
[    3.635049] usbcore: registered new interface driver usbserial
[    3.645608] usbcore: registered new interface driver usbserial_generic
[    3.656060] usbserial: USB Serial support registered for generic
[    3.666540] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    3.677252] i8042: PNP: PS/2 appears to have AUX port disabled, if 
this is incorrect please boot with i8042.nopnp
[    3.688678] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.699471] mousedev: PS/2 mouse device common for all mice
[    3.710012] rtc_cmos 00:02: RTC can wake from S4
[    3.720448] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    3.730561] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes 
nvram, hpet irqs
[    3.740760] intel_pstate: Intel P-state driver initializing
[    3.751077] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.766645] Initializing XFRM netlink socket
[    3.776445] NET: Registered protocol family 17
[    3.786018] Key type dns_resolver registered
[    3.795546] microcode: sig=0x306a9, pf=0x2, revision=0x10
[    3.804839] microcode: Microcode Update Driver: v2.2.
[    3.804849] sched_clock: Marking stable (3804833789, 0)->(3805320172, 
-486383)
[    3.823571] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input0
[    3.823649] registered taskstats version 1
[    3.865260] EXT4-fs (sda2): couldn't mount as ext3 due to feature 
incompatibilities
[    3.917720] EXT4-fs (sda2): mounted filesystem with ordered data 
mode. Opts: (null)
[    3.932431] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    3.954965] devtmpfs: mounted
[    3.965977] Freeing unused kernel memory: 1440K
[    3.977257] Write protecting the kernel read-only data: 14336k
[    3.986825] Freeing unused kernel memory: 616K
[    3.998082] Freeing unused kernel memory: 1084K
[    4.006960] rodata_test: all tests were successful
[    4.673130] random: crng init done
[    5.435976] udevd[153]: bind failed: Read-only file system
[    5.449739] udevd[153]: error binding udev control socket
[    5.593569] Adding 16787920k swap on /dev/sda3.  Priority:-1 
extents:1 across:16787920k
[    5.936881] fuse init (API version 7.26)
[    7.231377] EXT4-fs (sda2): re-mounted. Opts: (null)
[    7.270874] EXT4-fs (sda2): re-mounted. Opts: (null)
[   10.841139] EXT4-fs (sda5): mounted filesystem with ordered data 
mode. Opts: (null)
[   10.987833] EXT4-fs (sda6): mounted filesystem with ordered data 
mode. Opts: (null)
[   11.116467] EXT4-fs (sda1): mounted filesystem with ordered data 
mode. Opts: (null)
[   16.455793] udevd[528]: starting eudev-3.2.4
[   17.002954] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[   17.002973] ACPI: Power Button [PWRB]
[   17.003147] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   17.003158] ACPI: Power Button [PWRF]
[   17.233207] ACPI Warning: SystemIO range 
0x0000000000000428-0x000000000000042F conflicts with OpRegion 
0x0000000000000400-0x000000000000047F (\PMIO) (20170531/utaddress-247)
[   17.233212] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   17.233214] ACPI Warning: SystemIO range 
0x0000000000000540-0x000000000000054F conflicts with OpRegion 
0x0000000000000500-0x0000000000000563 (\GPIO) (20170531/utaddress-247)
[   17.233217] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   17.233217] ACPI Warning: SystemIO range 
0x0000000000000530-0x000000000000053F conflicts with OpRegion 
0x0000000000000500-0x0000000000000563 (\GPIO) (20170531/utaddress-247)
[   17.233220] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   17.233220] ACPI Warning: SystemIO range 
0x0000000000000500-0x000000000000052F conflicts with OpRegion 
0x0000000000000500-0x0000000000000563 (\GPIO) (20170531/utaddress-247)
[   17.233222] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   17.233223] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   17.282124] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   17.288596] ehci-pci: EHCI PCI platform driver
[   17.288760] ehci-pci 0000:00:1a.0: EHCI Host Controller
[   17.288813] ehci-pci 0000:00:1a.0: new USB bus registered, assigned 
bus number 1
[   17.288827] ehci-pci 0000:00:1a.0: debug port 2
[   17.292722] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[   17.292738] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7c08000
[   17.293717] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   17.314322] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) 
is a 16550A
[   17.314343] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   17.314391] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   17.314392] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   17.314393] usb usb1: Product: EHCI Host Controller
[   17.314394] usb usb1: Manufacturer: Linux 4.13.8.20171019 ehci_hcd
[   17.314395] usb usb1: SerialNumber: 0000:00:1a.0
[   17.314493] hub 1-0:1.0: USB hub found
[   17.314498] hub 1-0:1.0: 2 ports detected
[   17.314705] ehci-pci 0000:00:1d.0: EHCI Host Controller
[   17.314742] ehci-pci 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[   17.314753] ehci-pci 0000:00:1d.0: debug port 2
[   17.318659] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[   17.318671] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7c07000
[   17.325011] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   17.325038] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   17.325039] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   17.325041] usb usb2: Product: EHCI Host Controller
[   17.325042] usb usb2: Manufacturer: Linux 4.13.8.20171019 ehci_hcd
[   17.325042] usb usb2: SerialNumber: 0000:00:1d.0
[   17.325136] hub 2-0:1.0: USB hub found
[   17.325140] hub 2-0:1.0: 2 ports detected
[   17.340999] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   17.355509] Linux agpgart interface v0.103
[   17.423770] thermal LNXTHERM:00: registered as thermal_zone0
[   17.423772] ACPI: Thermal Zone [TZ00] (28 C)
[   17.424000] thermal LNXTHERM:01: registered as thermal_zone1
[   17.424014] ACPI: Thermal Zone [TZ01] (30 C)
[   17.580716] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   17.623013] usb 1-1: new high-speed USB device number 2 using ehci-pci
[   17.640030] usb 2-1: new high-speed USB device number 2 using ehci-pci
[   17.741402] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[   17.741404] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[   17.741545] hub 1-1:1.0: USB hub found
[   17.741646] hub 1-1:1.0: 4 ports detected
[   17.760429] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[   17.760432] usb 2-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[   17.760682] hub 2-1:1.0: USB hub found
[   17.760773] hub 2-1:1.0: 6 ports detected
[   17.805182] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   17.805541] r8169 0000:02:00.0 eth0: RTL8105e at 0xffffc90000031000, 
00:e0:66:84:16:a7, XID 00a00000 IRQ 26
[   18.015031] usb 1-1.2: new full-speed USB device number 3 using ehci-pci
[   18.031011] usb 2-1.3: new low-speed USB device number 3 using ehci-pci
[   18.116428] usb 2-1.3: New USB device found, idVendor=1c4f, 
idProduct=0034
[   18.116431] usb 2-1.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[   18.116432] usb 2-1.3: Product: Usb Mouse
[   18.116434] usb 2-1.3: Manufacturer: SIGMACHIP
[   18.141508] i2c /dev entries driver
[   18.594623] [drm] Memory usable by graphics device = 2048M
[   18.594626] checking generic (e0000000 fff0000) vs hw (e0000000 10000000)
[   18.594627] fb: switching to inteldrmfb from VESA VGA
[   18.594651] Console: switching to colour dummy device 80x25
[   18.594736] [drm] Replacing VGA console driver
[   18.601079] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   18.601080] [drm] Driver supports precise vblank timestamp query.
[   18.604169] i915 0000:00:02.0: vgaarb: changed VGA decodes: 
olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   18.608058] [drm] Initialized i915 1.6.0 20170619 for 0000:00:02.0 on 
minor 0
[   18.608403] ACPI: Video Device [GFX0] (multi-head: yes  rom: no 
post: no)
[   18.608591] acpi device:49: registered as cooling_device7
[   18.608642] input: Video Bus as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[   18.625111] snd_hda_intel 0000:00:1b.0: bound 0000:00:02.0 (ops 
i915_audio_component_bind_ops [i915])
[   18.655772] usb 1-1.2: New USB device found, idVendor=1b3f, 
idProduct=2007
[   18.655775] usb 1-1.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[   18.655776] usb 1-1.2: Product: USB Audio Device
[   18.655778] usb 1-1.2: Manufacturer: GeneralPlus
[   18.671440] fbcon: inteldrmfb (fb0) is primary device
[   18.733098] Console: switching to colour frame buffer device 170x48
[   18.751719] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   19.250076] snd_hda_codec_realtek hdaudioC1D2: autoconfig for ALC662 
rev3: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[   19.250078] snd_hda_codec_realtek hdaudioC1D2:    speaker_outs=0 
(0x0/0x0/0x0/0x0/0x0)
[   19.250080] snd_hda_codec_realtek hdaudioC1D2:    hp_outs=1 
(0x1b/0x0/0x0/0x0/0x0)
[   19.250081] snd_hda_codec_realtek hdaudioC1D2:    mono: mono_out=0x0
[   19.250082] snd_hda_codec_realtek hdaudioC1D2:    dig-out=0x1e/0x0
[   19.250083] snd_hda_codec_realtek hdaudioC1D2:    inputs:
[   19.250085] snd_hda_codec_realtek hdaudioC1D2:      Front Mic=0x19
[   19.250086] snd_hda_codec_realtek hdaudioC1D2:      Rear Mic=0x18
[   19.250087] snd_hda_codec_realtek hdaudioC1D2:      Line=0x1a
[   19.617638] input: HDA Intel PCH Front Mic as 
/devices/pci0000:00/0000:00:1b.0/sound/card1/input5
[   19.617690] input: HDA Intel PCH Rear Mic as 
/devices/pci0000:00/0000:00:1b.0/sound/card1/input6
[   19.617720] input: HDA Intel PCH Line as 
/devices/pci0000:00/0000:00:1b.0/sound/card1/input7
[   19.617752] input: HDA Intel PCH Line Out as 
/devices/pci0000:00/0000:00:1b.0/sound/card1/input8
[   19.617782] input: HDA Intel PCH Front Headphone as 
/devices/pci0000:00/0000:00:1b.0/sound/card1/input9
[   19.617813] input: HDA Intel PCH HDMI/DP,pcm=3 as 
/devices/pci0000:00/0000:00:1b.0/sound/card1/input10
[   19.617843] input: HDA Intel PCH HDMI/DP,pcm=7 as 
/devices/pci0000:00/0000:00:1b.0/sound/card1/input11
[   19.617873] input: HDA Intel PCH HDMI/DP,pcm=8 as 
/devices/pci0000:00/0000:00:1b.0/sound/card1/input12
[   20.392010] usb 2-1.3: USB disconnect, device number 3
[   20.657288] hidraw: raw HID events driver (C) Jiri Kosina
[   20.703225] usbcore: registered new interface driver usbhid
[   20.703226] usbhid: USB HID core driver
[   20.734521] usb 1-1.2: 1:1: cannot get freq at ep 0x5
[   20.735257] usb 1-1.2: 2:1: cannot get freq at ep 0x86
[   20.751131] usbcore: registered new interface driver snd-usb-audio
[   20.907898] input: GeneralPlus USB Audio Device as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.3/0003:1B3F:2007.0001/input/input13
[   20.959334] hid-generic 0003:1B3F:2007.0001: input,hidraw0: USB HID 
v2.01 Device [GeneralPlus USB Audio Device] on usb-0000:00:1a.0-1.2/input3
[   21.815028] usb 2-1.3: new low-speed USB device number 4 using ehci-pci
[   21.898249] usb 2-1.3: New USB device found, idVendor=1c4f, 
idProduct=0034
[   21.898252] usb 2-1.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[   21.898254] usb 2-1.3: Product: Usb Mouse
[   21.898255] usb 2-1.3: Manufacturer: SIGMACHIP
[   21.900987] input: SIGMACHIP Usb Mouse as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/0003:1C4F:0034.0002/input/input14
[   21.901152] hid-generic 0003:1C4F:0034.0002: input,hidraw1: USB HID 
v1.10 Mouse [SIGMACHIP Usb Mouse] on usb-0000:00:1d.0-1.3/input0
[   23.193054] r8169 0000:02:00.0 eth0: link down
[   23.193070] r8169 0000:02:00.0 eth0: link down
[   23.589795] NET: Registered protocol family 10
[   23.590227] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   23.590274] Segment Routing with IPv6
[   24.516778] NFSD: the nfsdcld client tracking upcall will be removed 
in 3.10. Please transition to using nfsdcltrack.
[   24.516780] NFSD: starting 90-second grace period (net ffffffff81ee6400)
[   24.773386] r8169 0000:02:00.0 eth0: link up
[   24.773400] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   35.748078] nct6775: Found NCT6779D or compatible chip at 0x2e:0xa30
[   36.252940] NET: Registered protocol family 4
[   36.266545] NET: Registered protocol family 5
[  145.887086] NFSD: Unable to end grace period: -110
[  309.194881] usb 1-1.2: 1:1: cannot get freq at ep 0x5
[  813.692026] usb 2-1.4: new high-speed USB device number 5 using ehci-pci
[  813.771752] usb 2-1.4: New USB device found, idVendor=0bda, 
idProduct=8178
[  813.771754] usb 2-1.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  813.771756] usb 2-1.4: Product: 802.11n WLAN Adapter
[  813.771757] usb 2-1.4: Manufacturer: Realtek
[  813.771757] usb 2-1.4: SerialNumber: 00e04c000001
[  813.954745] rtl8192cu: Chip version 0x11
[  814.031127] rtl8192cu: Board Type 0
[  814.031368] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
[  814.031398] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[  814.031534] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[  814.031712] usbcore: registered new interface driver rtl8192cu
[  814.034508] usbcore: registered new interface driver rtl8xxxu
[  814.114407] rtl8192cu 2-1.4:1.0 wlan125: renamed from wlan0
[  814.119131] rtl8192cu 2-1.4:1.0 wlan1: renamed from wlan125
[  872.272098] rtl8192cu: MAC auto ON okay!
[  872.304968] rtl8192cu: Tx queue select: 0x05
[  872.906879] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  881.042276] rtl8192cu: MAC auto ON okay!
[  881.075282] rtl8192cu: Tx queue select: 0x05
[  881.677711] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  881.840898] rtl8192cu: MAC auto ON okay!
[  881.874650] rtl8192cu: Tx queue select: 0x05
[  882.478431] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  885.721281] wlan1: authenticate with 16:6b:72:6d:9d:fc
[  885.747759] wlan1: send auth to 16:6b:72:6d:9d:fc (try 1/3)
[  885.751276] wlan1: authenticated
[  885.752070] wlan1: associate with 16:6b:72:6d:9d:fc (try 1/3)
[  885.768967] wlan1: RX AssocResp from 16:6b:72:6d:9d:fc (capab=0x431 
status=0 aid=1)
[  885.872798] wlan1: associated
[  885.873506] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready

##

--
nirinA

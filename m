Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:49048 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbdJ1WIq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Oct 2017 18:08:46 -0400
Received: by mail-wm0-f68.google.com with SMTP id p75so9067462wmg.3
        for <linux-wireless@vger.kernel.org>; Sat, 28 Oct 2017 15:08:45 -0700 (PDT)
From: nirinA raseliarison <nirina.raseliarison@gmail.com>
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
 <7532bb89-9f58-f2e2-e9c3-baa4be24da81@gmail.com>
 <20171027225701.GB8920@us.netrek.org>
Message-ID: <bd5a4917-96e7-c9ef-909a-e8e4f34b0ef1@gmail.com> (sfid-20171029_000928_718252_35CF1C97)
Date: Sun, 29 Oct 2017 01:08:24 +0300
MIME-Version: 1.0
In-Reply-To: <20171027225701.GB8920@us.netrek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/2017 01:57 AM, James Cameron wrote:
> [snip]
> Your dmesg shows the mouse is discovered, then disconnects, then
> reconnects.  I can't tell if your mouse normally does this.  Can you
> also test for the wireless problem without the USB mouse, or with a
> different mouse?

a new dmesg below with another usb mouse.

> Your dmesg also shows "cannot get freq" for USB audio device
> endpoints, but I'm not sure what this means.

it seems that this device does not support reading the sample rate.
i added its usb id in sound/usb/quirks.c:snd_usb_get_sample_rate_quirk
so that this "cannot get freq"  is not logged anymore.

> [snip]

thanks,

[    0.000000] random: get_random_bytes called from 
start_kernel+0x2a/0x413 with crng_init=0
[    0.000000] Linux version 4.13.8.20171019 (root@supernova) (gcc 
version 7.2.0 (GCC)) #2 SMP Sat Oct 28 16:27:44 EAT 2017
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
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT
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
[    0.001000] tsc: Detected 2594.092 MHz processor
[    0.001000] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 5188.18 BogoMIPS (lpj=2594092)
[    0.001000] pid_max: default: 32768 minimum: 301
[    0.001000] ACPI: Core revision 20170531
[    0.005768] ACPI: 4 ACPI AML tables successfully acquired and loaded
[    0.005790] Security Framework initialized
[    0.005820] Mount-cache hash table entries: 16384 (order: 5, 131072 
bytes)
[    0.005846] Mountpoint-cache hash table entries: 16384 (order: 5, 
131072 bytes)
[    0.005986] CPU: Physical Processor ID: 0
[    0.005989] CPU: Processor Core ID: 0
[    0.006003] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.006006] ENERGY_PERF_BIAS: View and update with 
x86_energy_perf_policy(8)
[    0.006011] mce: CPU supports 7 MCE banks
[    0.006020] CPU0: Thermal monitoring enabled (TM1)
[    0.006030] process: using mwait in idle threads
[    0.006035] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.006038] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.006113] Freeing SMP alternatives memory: 36K
[    0.007221] smpboot: Max logical packages: 1
[    0.007634] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.017648] TSC deadline timer enabled
[    0.017650] smpboot: CPU0: Intel(R) Celeron(R) CPU G1610 @ 2.60GHz 
(family: 0x6, model: 0x3a, stepping: 0x9)
[    0.017703] Performance Events: PEBS fmt1+, IvyBridge events, 16-deep 
LBR, full-width counters, Intel PMU driver.
[    0.017727] ... version:                3
[    0.017730] ... bit width:              48
[    0.017733] ... generic registers:      8
[    0.017736] ... value mask:             0000ffffffffffff
[    0.017739] ... max period:             00007fffffffffff
[    0.017741] ... fixed-purpose events:   3
[    0.017744] ... event mask:             00000007000000ff
[    0.017774] Hierarchical SRCU implementation.
[    0.017842] smp: Bringing up secondary CPUs ...
[    0.017890] x86: Booting SMP configuration:
[    0.017893] .... node  #0, CPUs:      #1
[    0.078018] smp: Brought up 1 node, 2 CPUs
[    0.078018] smpboot: Total of 2 processors activated (10380.04 BogoMIPS)
[    0.079123] devtmpfs: initialized
[    0.079123] x86/mm: Memory block size: 128MB
[    0.079492] PM: Registering ACPI NVS region [mem 
0xce25c000-0xce373fff] (1146880 bytes)
[    0.079492] PM: Registering ACPI NVS region [mem 
0xce6da000-0xce71cfff] (274432 bytes)
[    0.079492] clocksource: jiffies: mask: 0xffffffff max_cycles: 
0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.079492] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.079492] pinctrl core: initialized pinctrl subsystem
[    0.079492] NET: Registered protocol family 16
[    0.080029] cpuidle: using governor ladder
[    0.080029] cpuidle: using governor menu
[    0.080029] PCCT header not found.
[    0.080048] ACPI: bus type PCI registered
[    0.080052] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.080083] PCI: Using configuration type 1 for base access
[    0.080122] core: PMU erratum BJ122, BV98, HSD29 workaround disabled, 
HT off
[    0.083373] ACPI: Added _OSI(Module Device)
[    0.083373] ACPI: Added _OSI(Processor Device)
[    0.083373] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.083373] ACPI: Added _OSI(Processor Aggregator Device)
[    0.083373] ACPI: Executed 1 blocks of module-level executable AML code
[    0.086305] ACPI: Dynamic OEM Table Load:
[    0.086315] ACPI: SSDT 0xFFFF880216669000 00083B (v01 PmRef  Cpu0Cst 
00003001 INTL 20051117)
[    0.086395] ACPI: Dynamic OEM Table Load:
[    0.086395] ACPI: SSDT 0xFFFF88021642DC00 000303 (v01 PmRef  ApIst 
00003000 INTL 20051117)
[    0.087037] ACPI: Dynamic OEM Table Load:
[    0.087042] ACPI: SSDT 0xFFFF880216708200 000119 (v01 PmRef  ApCst 
00003000 INTL 20051117)
[    0.087380] ACPI: Interpreter enabled
[    0.087401] ACPI: (supports S0 S1 S3 S4 S5)
[    0.087405] ACPI: Using IOAPIC for interrupt routing
[    0.087428] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.092834] ACPI: Power Resource [FN00] (off)
[    0.092897] ACPI: Power Resource [FN01] (off)
[    0.092958] ACPI: Power Resource [FN02] (off)
[    0.093018] ACPI: Power Resource [FN03] (off)
[    0.093078] ACPI: Power Resource [FN04] (off)
[    0.093479] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.093486] acpi PNP0A08:00: _OSC: OS supports [ASPM ClockPM Segments 
MSI]
[    0.093607] acpi PNP0A08:00: _OSC: not requesting OS control; OS 
requires [ExtendedConfig ASPM ClockPM MSI]
[    0.093968] PCI host bridge to bus 0000:00
[    0.093973] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.093976] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.093980] pci_bus 0000:00: root bus resource [mem 
0x000a0000-0x000bffff window]
[    0.093985] pci_bus 0000:00: root bus resource [mem 
0x000d4000-0x000d7fff window]
[    0.093990] pci_bus 0000:00: root bus resource [mem 
0x000d8000-0x000dbfff window]
[    0.093996] pci_bus 0000:00: root bus resource [mem 
0x000dc000-0x000dffff window]
[    0.094000] pci_bus 0000:00: root bus resource [mem 
0x000e0000-0x000e3fff window]
[    0.094006] pci_bus 0000:00: root bus resource [mem 
0x000e4000-0x000e7fff window]
[    0.094012] pci_bus 0000:00: root bus resource [mem 
0xdfa00000-0xfeafffff window]
[    0.094017] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.094026] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.094104] pci 0000:00:02.0: [8086:0152] type 00 class 0x030000
[    0.094114] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.094119] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 
64bit pref]
[    0.094123] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.094216] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.094241] pci 0000:00:16.0: reg 0x10: [mem 0xf7c0a000-0xf7c0a00f 64bit]
[    0.094312] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.094384] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.094406] pci 0000:00:1a.0: reg 0x10: [mem 0xf7c08000-0xf7c083ff]
[    0.094488] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.094554] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.094571] pci 0000:00:1b.0: reg 0x10: [mem 0xf7c00000-0xf7c03fff 64bit]
[    0.094637] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.094704] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.094780] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.094850] pci 0000:00:1c.2: [8086:1c14] type 01 class 0x060400
[    0.094925] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.094999] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.095020] pci 0000:00:1d.0: reg 0x10: [mem 0xf7c07000-0xf7c073ff]
[    0.095102] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.095170] pci 0000:00:1f.0: [8086:1c5c] type 00 class 0x060100
[    0.095334] pci 0000:00:1f.2: [8086:1c02] type 00 class 0x010601
[    0.095352] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    0.095359] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    0.095367] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
[    0.095374] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
[    0.095381] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.095388] pci 0000:00:1f.2: reg 0x24: [mem 0xf7c06000-0xf7c067ff]
[    0.095427] pci 0000:00:1f.2: PME# supported from D3hot
[    0.095488] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.095507] pci 0000:00:1f.3: reg 0x10: [mem 0xf7c05000-0xf7c050ff 64bit]
[    0.095526] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.095642] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.095717] pci 0000:02:00.0: [10ec:8136] type 00 class 0x020000
[    0.095741] pci 0000:02:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    0.095775] pci 0000:02:00.0: reg 0x18: [mem 0xf0004000-0xf0004fff 
64bit pref]
[    0.095796] pci 0000:02:00.0: reg 0x20: [mem 0xf0000000-0xf0003fff 
64bit pref]
[    0.095888] pci 0000:02:00.0: supports D1 D2
[    0.095889] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.098023] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.098033] pci 0000:00:1c.2:   bridge window [io  0xe000-0xefff]
[    0.098042] pci 0000:00:1c.2:   bridge window [mem 
0xf0000000-0xf00fffff 64bit pref]
[    0.098071] pci_bus 0000:00: on NUMA node 0
[    0.098356] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 
14 15)
[    0.098402] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 
15) *0, disabled.
[    0.098449] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 
14 15)
[    0.098492] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 
14 15)
[    0.098535] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 
15) *0, disabled.
[    0.098579] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 
15) *0, disabled.
[    0.098624] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 
14 15)
[    0.098667] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 
14 15)
[    0.098826] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.098882] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.098882] pci 0000:00:02.0: vgaarb: VGA device added: 
decodes=io+mem,owns=io+mem,locks=none
[    0.098882] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.098882] vgaarb: loaded
[    0.098882] SCSI subsystem initialized
[    0.098882] libata version 3.00 loaded.
[    0.099003] ACPI: bus type USB registered
[    0.099021] usbcore: registered new interface driver usbfs
[    0.099031] usbcore: registered new interface driver hub
[    0.099041] usbcore: registered new device driver usb
[    0.099055] EDAC MC: Ver: 3.0.0
[    0.099111] PCI: Using ACPI for IRQ routing
[    0.099111] PCI: pci_cache_line_size set to 64 bytes
[    0.099111] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.099111] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.099111] e820: reserve RAM buffer [mem 0xcdf31000-0xcfffffff]
[    0.099111] e820: reserve RAM buffer [mem 0xce6da000-0xcfffffff]
[    0.099111] e820: reserve RAM buffer [mem 0xcee1a000-0xcfffffff]
[    0.099111] e820: reserve RAM buffer [mem 0xcf000000-0xcfffffff]
[    0.099111] e820: reserve RAM buffer [mem 0x21f600000-0x21fffffff]
[    0.099133] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.099133] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.101009] clocksource: Switched to clocksource hpet
[    0.106960] VFS: Disk quotas dquot_6.6.0
[    0.106979] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 
bytes)
[    0.107043] pnp: PnP ACPI init
[    0.107135] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.107141] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.107200] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.107204] system 00:01: [io  0x0200-0x020f] has been reserved
[    0.107208] system 00:01: [io  0xffff] has been reserved
[    0.107211] system 00:01: [io  0xffff] has been reserved
[    0.107215] system 00:01: [io  0x0400-0x0453] has been reserved
[    0.107218] system 00:01: [io  0x0458-0x047f] has been reserved
[    0.107222] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.107225] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.107230] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.107247] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.107280] system 00:03: [io  0x0454-0x0457] has been reserved
[    0.107285] system 00:03: Plug and Play ACPI device, IDs INT3f0d 
PNP0c02 (active)
[    0.107344] system 00:04: [io  0x0a30-0x0a3f] has been reserved
[    0.107349] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.107379] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 PNP030b 
(active)
[    0.107490] pnp 00:06: [dma 0 disabled]
[    0.107523] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.107556] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.107561] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.107713] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.107718] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.107721] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.107725] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.107729] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.107733] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.107736] system 00:08: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.107740] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.107744] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.107748] system 00:08: [mem 0xfee00000-0xfeefffff] could not be 
reserved
[    0.107751] system 00:08: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.107756] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.107868] system 00:09: [mem 0x20000000-0x201fffff] has been reserved
[    0.107872] system 00:09: [mem 0x40004000-0x40004fff] has been reserved
[    0.107876] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.107893] pnp: PnP ACPI: found 10 devices
[    0.113812] clocksource: acpi_pm: mask: 0xffffff max_cycles: 
0xffffff, max_idle_ns: 2085701024 ns
[    0.113839] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.113854] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.113859] pci 0000:00:1c.2:   bridge window [io  0xe000-0xefff]
[    0.113869] pci 0000:00:1c.2:   bridge window [mem 
0xf0000000-0xf00fffff 64bit pref]
[    0.113880] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.113881] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.113882] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff 
window]
[    0.113883] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff 
window]
[    0.113884] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff 
window]
[    0.113885] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff 
window]
[    0.113886] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000e3fff 
window]
[    0.113887] pci_bus 0000:00: resource 11 [mem 0x000e4000-0x000e7fff 
window]
[    0.113888] pci_bus 0000:00: resource 12 [mem 0xdfa00000-0xfeafffff 
window]
[    0.113889] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.113890] pci_bus 0000:02: resource 2 [mem 0xf0000000-0xf00fffff 
64bit pref]
[    0.113961] NET: Registered protocol family 2
[    0.114072] TCP established hash table entries: 65536 (order: 7, 
524288 bytes)
[    0.114174] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.114358] TCP: Hash tables configured (established 65536 bind 65536)
[    0.114387] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.114415] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.114472] NET: Registered protocol family 1
[    0.114567] RPC: Registered named UNIX socket transport module.
[    0.114571] RPC: Registered udp transport module.
[    0.114574] RPC: Registered tcp transport module.
[    0.114577] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.114591] pmd_set_huge: Cannot satisfy [mem 0xf7800000-0xf7a00000] 
with a huge-page mapping due to MTRR override.
[    0.114604] pci 0000:00:02.0: BIOS left Intel GPU interrupts enabled; 
disabling
[    0.114623] pci 0000:00:02.0: Video device with shadowed ROM at [mem 
0x000c0000-0x000dffff]
[    0.147118] PCI: CLS 64 bytes, default 64
[    0.147154] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.147159] software IO TLB [mem 0xc9f31000-0xcdf31000] (64MB) mapped 
at [ffff8800c9f31000-ffff8800cdf30fff]
[    0.147224] RAPL PMU: API unit is 2^-32 Joules, 3 fixed counters, 
163840 ms ovfl timer
[    0.147229] RAPL PMU: hw unit of domain pp0-core 2^-16 Joules
[    0.147232] RAPL PMU: hw unit of domain package 2^-16 Joules
[    0.147235] RAPL PMU: hw unit of domain pp1-gpu 2^-16 Joules
[    0.147498] audit: initializing netlink subsys (disabled)
[    0.147531] audit: type=2000 audit(1509198077.147:1): 
state=initialized audit_enabled=0 res=1
[    0.147672] workingset: timestamp_bits=46 max_order=21 bucket_order=0
[    0.148714] NFS: Registering the id_resolver key type
[    0.148722] Key type id_resolver registered
[    0.148725] Key type id_legacy registered
[    0.148729] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.148805] ntfs: driver 2.1.32 [Flags: R/W].
[    0.148833] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.150277] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 252)
[    0.150308] io scheduler noop registered
[    0.150312] io scheduler deadline registered
[    0.150332] io scheduler cfq registered (default)
[    0.150336] io scheduler mq-deadline registered
[    0.150338] io scheduler kyber registered
[    0.150628] vesafb: mode is 1024x768x16, linelength=2048, pages=169
[    0.150632] vesafb: scrolling: redraw
[    0.150635] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.150648] vesafb: framebuffer at 0xe0000000, mapped to 
0xffffc90000c00000, using 3072k, total 262080k
[    0.175404] Console: switching to colour frame buffer device 128x48
[    0.198195] fb0: VESA VGA frame buffer device
[    0.198406] intel_idle: MWAIT substates: 0x1120
[    0.198407] intel_idle: v0.4.1 model 0x3A
[    0.198458] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.198516] GHES: HEST is not enabled!
[    0.201105] brd: module loaded
[    0.201400] fnic: Cisco FCoE HBA Driver, ver 1.6.0.34
[    0.201649] fnic: Successfully Initialized Trace Buffer
[    0.201917] fnic: Successfully Initialized FC_CTLR Trace Buffer
[    0.202370] Adaptec aacraid driver 1.2.1[50834]-custom
[    0.202617] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    0.203058] scsi: <fdomain> Detection failed (no card)
[    0.203308] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA 
Driver: 10.00.00.00-k.
[    0.203696] Emulex LightPulse Fibre Channel SCSI driver 11.4.0.1
[    0.203974] Copyright (C) 2017 Broadcom. All Rights Reserved. The 
term "Broadcom" refers to Broadcom Limited and/or its subsidiaries.
[    0.204602] QLogic BR-series BFA FC/FCOE SCSI driver - version: 3.2.25.1
[    0.204946] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 
EST 2006)
[    0.205308] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 
2006)
[    0.205637] megasas: 07.701.17.00-rc1
[    0.205817] mpt3sas version 15.100.00.00 loaded
[    0.215061] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    0.224486] 3ware Storage Controller device driver for Linux 
v1.26.02.003.
[    0.233970] 3ware 9000 Storage Controller device driver for Linux 
v2.26.02.014.
[    0.243497] LSI 3ware SAS/SATA-RAID Controller device driver for 
Linux v3.26.02.000.
[    0.253038] ipr: IBM Power RAID SCSI Device Driver version: 2.6.4 
(March 14, 2017)
[    0.262591] RocketRAID 3xxx/4xxx Controller driver v1.10.0
[    0.272060] stex: Promise SuperTrak EX Driver version: 6.02.0000.01
[    0.281660] st: Version 20160209, fixed bufsize 32768, s/g segs 256
[    0.291417] ahci 0000:00:1f.2: version 3.0
[    0.291586] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 
0x3 impl SATA mode
[    0.301477] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum 
part ems apst
[    0.314341] scsi host0: ahci
[    0.324210] scsi host1: ahci
[    0.333807] scsi host2: ahci
[    0.343147] scsi host3: ahci
[    0.352314] ata1: SATA max UDMA/133 abar m2048@0xf7c06000 port 
0xf7c06100 irq 24
[    0.361835] ata2: SATA max UDMA/133 abar m2048@0xf7c06000 port 
0xf7c06180 irq 24
[    0.371289] ata3: DUMMY
[    0.380658] ata4: DUMMY
[    0.390447] scsi host4: pata_legacy
[    0.399711] ata5: PATA max PIO4 cmd 0x1f0 ctl 0x3f6 irq 14
[    0.708584] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.718028] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.727308] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND 
(20170531/psargs-364)
[    0.736659] ACPI Error: Method parse/execution failed 
\_SB.PCI0.SAT0.SPT1._GTF, AE_NOT_FOUND (20170531/psparse-550)
[    0.746208] ata2.00: ATAPI: TSSTcorp CDDVDW SH-224BB, SB00, max UDMA/100
[    0.755793] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND 
(20170531/psargs-364)
[    0.765646] ACPI Error: Method parse/execution failed 
\_SB.PCI0.SAT0.SPT0._GTF, AE_NOT_FOUND (20170531/psparse-550)
[    0.776076] ata1.00: ATA-8: ST500DM002-1BD142, KC45, max UDMA/133
[    0.786335] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    0.796688] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND 
(20170531/psargs-364)
[    0.807332] ACPI Error: Method parse/execution failed 
\_SB.PCI0.SAT0.SPT1._GTF, AE_NOT_FOUND (20170531/psparse-550)
[    0.818223] ata2.00: configured for UDMA/100
[    0.830011] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND 
(20170531/psargs-364)
[    0.841063] ACPI Error: Method parse/execution failed 
\_SB.PCI0.SAT0.SPT0._GTF, AE_NOT_FOUND (20170531/psparse-550)
[    0.852511] ata1.00: configured for UDMA/133
[    1.183051] tsc: Refined TSC clocksource calibration: 2594.107 MHz
[    1.194009] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 
0x25647d583cf, max_idle_ns: 440795304232 ns
[    2.207211] clocksource: Switched to clocksource tsc
[    3.231176] floppy0: no floppy controllers found
[    3.242200] scsi 0:0:0:0: Direct-Access     ATA      ST500DM002-1BD14 
KC45 PQ: 0 ANSI: 5
[    3.253340] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 
GB/466 GiB)
[    3.264349] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    3.275325] sd 0:0:0:0: [sda] Write Protect is off
[    3.275344] scsi 1:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-224BB 
SB00 PQ: 0 ANSI: 5
[    3.297181] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.297192] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    3.311966] sr 1:0:0:0: [sr0] scsi3-mmc drive: 48x/48x writer dvd-ram 
cd/rw xa/form2 cdda tray
[    3.323070] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.334137] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.359230]  sda: sda1 sda2 sda3 sda5 sda6
[    3.370454] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.381610] scsi host4: pata_legacy
[    3.392321] ata6: PATA max PIO4 cmd 0x170 ctl 0x376 irq 15
[    3.559205] Fusion MPT base driver 3.04.20
[    3.569748] Copyright (c) 1999-2008 LSI Corporation
[    3.580254] Fusion MPT SPI Host driver 3.04.20
[    3.590910] Fusion MPT FC Host driver 3.04.20
[    3.601639] Fusion MPT SAS Host driver 3.04.20
[    3.612472] Fusion MPT misc device (ioctl) driver 3.04.20
[    3.623273] mptctl: Registered with Fusion MPT base driver
[    3.634203] mptctl: /dev/mptctl @ (major,minor=10,220)
[    3.645038] Fusion MPT LAN driver 3.04.20
[    3.656033] usbcore: registered new interface driver usbserial
[    3.667160] usbcore: registered new interface driver usbserial_generic
[    3.678186] usbserial: USB Serial support registered for generic
[    3.689233] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    3.700518] i8042: PNP: PS/2 appears to have AUX port disabled, if 
this is incorrect please boot with i8042.nopnp
[    3.712525] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.723830] mousedev: PS/2 mouse device common for all mice
[    3.734880] rtc_cmos 00:02: RTC can wake from S4
[    3.745867] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    3.756576] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes 
nvram, hpet irqs
[    3.767145] intel_pstate: Intel P-state driver initializing
[    3.777828] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.794020] Initializing XFRM netlink socket
[    3.809826] NET: Registered protocol family 17
[    3.819749] Key type dns_resolver registered
[    3.829606] microcode: sig=0x306a9, pf=0x2, revision=0x10
[    3.839209] microcode: Microcode Update Driver: v2.2.
[    3.839217] sched_clock: Marking stable (3839205490, 0)->(3839677294, 
-471804)
[    3.857943] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input0
[    3.858084] registered taskstats version 1
[    3.898324] EXT4-fs (sda2): couldn't mount as ext3 due to feature 
incompatibilities
[    3.942183] EXT4-fs (sda2): mounted filesystem with ordered data 
mode. Opts: (null)
[    3.951626] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    3.979748] devtmpfs: mounted
[    3.990553] Freeing unused kernel memory: 1440K
[    4.000585] Write protecting the kernel read-only data: 14336k
[    4.010209] Freeing unused kernel memory: 616K
[    4.021513] Freeing unused kernel memory: 1084K
[    4.030416] rodata_test: all tests were successful
[    4.678967] random: crng init done
[    5.435789] udevd[153]: bind failed: Read-only file system
[    5.444612] udevd[153]: error binding udev control socket
[    5.585045] Adding 16787920k swap on /dev/sda3.  Priority:-1 
extents:1 across:16787920k
[    5.948565] fuse init (API version 7.26)
[    6.354334] EXT4-fs (sda2): re-mounted. Opts: (null)
[    6.396835] EXT4-fs (sda2): re-mounted. Opts: (null)
[   10.022320] EXT4-fs (sda5): mounted filesystem with ordered data 
mode. Opts: (null)
[   10.177325] EXT4-fs (sda6): mounted filesystem with ordered data 
mode. Opts: (null)
[   10.272131] EXT4-fs (sda1): mounted filesystem with ordered data 
mode. Opts: (null)
[   16.658346] udevd[528]: starting eudev-3.2.4
[   17.426432] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   17.451676] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[   17.451692] ACPI: Power Button [PWRB]
[   17.451724] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   17.451731] ACPI: Power Button [PWRF]
[   17.490100] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   17.497283] ACPI Warning: SystemIO range 
0x0000000000000428-0x000000000000042F conflicts with OpRegion 
0x0000000000000400-0x000000000000047F (\PMIO) (20170531/utaddress-247)
[   17.497288] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   17.497290] ACPI Warning: SystemIO range 
0x0000000000000540-0x000000000000054F conflicts with OpRegion 
0x0000000000000500-0x0000000000000563 (\GPIO) (20170531/utaddress-247)
[   17.497293] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   17.497293] ACPI Warning: SystemIO range 
0x0000000000000530-0x000000000000053F conflicts with OpRegion 
0x0000000000000500-0x0000000000000563 (\GPIO) (20170531/utaddress-247)
[   17.497295] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   17.497296] ACPI Warning: SystemIO range 
0x0000000000000500-0x000000000000052F conflicts with OpRegion 
0x0000000000000500-0x0000000000000563 (\GPIO) (20170531/utaddress-247)
[   17.497298] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   17.497298] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   17.521285] ehci-pci: EHCI PCI platform driver
[   17.521436] ehci-pci 0000:00:1a.0: EHCI Host Controller
[   17.521495] ehci-pci 0000:00:1a.0: new USB bus registered, assigned 
bus number 1
[   17.521508] ehci-pci 0000:00:1a.0: debug port 2
[   17.525423] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[   17.525649] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7c08000
[   17.532017] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[   17.532076] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   17.532077] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   17.532079] usb usb1: Product: EHCI Host Controller
[   17.532081] usb usb1: Manufacturer: Linux 4.13.8.20171019 ehci_hcd
[   17.532082] usb usb1: SerialNumber: 0000:00:1a.0
[   17.532272] hub 1-0:1.0: USB hub found
[   17.532277] hub 1-0:1.0: 2 ports detected
[   17.532480] ehci-pci 0000:00:1d.0: EHCI Host Controller
[   17.532513] ehci-pci 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[   17.532524] ehci-pci 0000:00:1d.0: debug port 2
[   17.536411] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[   17.536717] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7c07000
[   17.543013] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[   17.543066] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   17.543068] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   17.543069] usb usb2: Product: EHCI Host Controller
[   17.543071] usb usb2: Manufacturer: Linux 4.13.8.20171019 ehci_hcd
[   17.543072] usb usb2: SerialNumber: 0000:00:1d.0
[   17.543195] hub 2-0:1.0: USB hub found
[   17.543200] hub 2-0:1.0: 2 ports detected
[   17.566079] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   17.586680] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) 
is a 16550A
[   17.622449] Linux agpgart interface v0.103
[   17.634429] thermal LNXTHERM:00: registered as thermal_zone0
[   17.634430] ACPI: Thermal Zone [TZ00] (28 C)
[   17.634597] thermal LNXTHERM:01: registered as thermal_zone1
[   17.634597] ACPI: Thermal Zone [TZ01] (30 C)
[   17.772416] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   17.772763] r8169 0000:02:00.0 eth0: RTL8105e at 0xffffc90000049000, 
00:e0:66:84:16:a7, XID 00a00000 IRQ 26
[   17.847016] usb 1-1: new high-speed USB device number 2 using ehci-pci
[   17.855013] usb 2-1: new high-speed USB device number 2 using ehci-pci
[   17.965317] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[   17.965320] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[   17.965592] hub 1-1:1.0: USB hub found
[   17.965685] hub 1-1:1.0: 4 ports detected
[   17.973314] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[   17.973316] usb 2-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=0
[   17.973464] hub 2-1:1.0: USB hub found
[   17.973560] hub 2-1:1.0: 6 ports detected
[   18.239015] usb 1-1.2: new full-speed USB device number 3 using ehci-pci
[   18.248021] usb 2-1.3: new low-speed USB device number 3 using ehci-pci
[   18.260473] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   18.330184] usb 2-1.3: New USB device found, idVendor=093a, 
idProduct=2510
[   18.330185] usb 2-1.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[   18.330187] usb 2-1.3: Product: USB OPTICAL MOUSE
[   18.330188] usb 2-1.3: Manufacturer: PIXART
[   18.347995] i2c /dev entries driver
[   18.880809] usb 1-1.2: New USB device found, idVendor=1b3f, 
idProduct=2007
[   18.880812] usb 1-1.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[   18.880813] usb 1-1.2: Product: USB Audio Device
[   18.880815] usb 1-1.2: Manufacturer: GeneralPlus
[   19.322316] [drm] Memory usable by graphics device = 2048M
[   19.322319] checking generic (e0000000 fff0000) vs hw (e0000000 10000000)
[   19.322319] fb: switching to inteldrmfb from VESA VGA
[   19.322355] Console: switching to colour dummy device 80x25
[   19.322424] [drm] Replacing VGA console driver
[   19.328065] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   19.328066] [drm] Driver supports precise vblank timestamp query.
[   19.330582] i915 0000:00:02.0: vgaarb: changed VGA decodes: 
olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   19.334551] [drm] Initialized i915 1.6.0 20170619 for 0000:00:02.0 on 
minor 0
[   19.335036] ACPI: Video Device [GFX0] (multi-head: yes  rom: no post: no)
[   19.335297] acpi device:49: registered as cooling_device8
[   19.335554] input: Video Bus as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[   19.352187] snd_hda_intel 0000:00:1b.0: bound 0000:00:02.0 (ops 
i915_audio_component_bind_ops [i915])
[   19.398703] fbcon: inteldrmfb (fb0) is primary device
[   19.458096] Console: switching to colour frame buffer device 170x48
[   19.476705] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   19.899223] snd_hda_codec_realtek hdaudioC0D2: autoconfig for ALC662 
rev3: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[   19.899224] snd_hda_codec_realtek hdaudioC0D2:    speaker_outs=0 
(0x0/0x0/0x0/0x0/0x0)
[   19.899225] snd_hda_codec_realtek hdaudioC0D2:    hp_outs=1 
(0x1b/0x0/0x0/0x0/0x0)
[   19.899226] snd_hda_codec_realtek hdaudioC0D2:    mono: mono_out=0x0
[   19.899227] snd_hda_codec_realtek hdaudioC0D2:    dig-out=0x1e/0x0
[   19.899228] snd_hda_codec_realtek hdaudioC0D2:    inputs:
[   19.899229] snd_hda_codec_realtek hdaudioC0D2:      Front Mic=0x19
[   19.899230] snd_hda_codec_realtek hdaudioC0D2:      Rear Mic=0x18
[   19.899231] snd_hda_codec_realtek hdaudioC0D2:      Line=0x1a
[   20.285745] input: HDA Intel PCH Front Mic as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[   20.285799] input: HDA Intel PCH Rear Mic as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[   20.285846] input: HDA Intel PCH Line as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   20.285892] input: HDA Intel PCH Line Out as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   20.285936] input: HDA Intel PCH Front Headphone as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   20.285982] input: HDA Intel PCH HDMI/DP,pcm=3 as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   20.286036] input: HDA Intel PCH HDMI/DP,pcm=7 as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   20.286184] input: HDA Intel PCH HDMI/DP,pcm=8 as 
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   21.608466] hidraw: raw HID events driver (C) Jiri Kosina
[   21.635340] usbcore: registered new interface driver usbhid
[   21.635341] usbhid: USB HID core driver
[   21.739682] usbcore: registered new interface driver snd-usb-audio
[   23.159597] input: PIXART USB OPTICAL MOUSE as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/0003:093A:2510.0001/input/input13
[   23.159690] hid-generic 0003:093A:2510.0001: input,hidraw0: USB HID 
v1.11 Mouse [PIXART USB OPTICAL MOUSE] on usb-0000:00:1d.0-1.3/input0
[   23.159786] input: GeneralPlus USB Audio Device as 
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.3/0003:1B3F:2007.0002/input/input14
[   23.211240] hid-generic 0003:1B3F:2007.0002: input,hidraw1: USB HID 
v2.01 Device [GeneralPlus USB Audio Device] on usb-0000:00:1a.0-1.2/input3
[   24.217048] r8169 0000:02:00.0 eth0: link down
[   24.217062] r8169 0000:02:00.0 eth0: link down
[   24.502121] NET: Registered protocol family 10
[   24.502362] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   24.502403] Segment Routing with IPv6
[   25.615236] NFSD: the nfsdcld client tracking upcall will be removed 
in 3.10. Please transition to using nfsdcltrack.
[   25.615239] NFSD: starting 90-second grace period (net ffffffff81ee6400)
[   25.818487] r8169 0000:02:00.0 eth0: link up
[   25.818500] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   37.455802] nct6775: Found NCT6779D or compatible chip at 0x2e:0xa30
[   37.737820] NET: Registered protocol family 4
[   37.749316] NET: Registered protocol family 5
[  145.887027] NFSD: Unable to end grace period: -110
[  145.966016] usb 2-1.4: new high-speed USB device number 4 using ehci-pci
[  146.045808] usb 2-1.4: New USB device found, idVendor=0bda, 
idProduct=8178
[  146.045811] usb 2-1.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[  146.045812] usb 2-1.4: Product: 802.11n WLAN Adapter
[  146.045813] usb 2-1.4: Manufacturer: Realtek
[  146.045814] usb 2-1.4: SerialNumber: 00e04c000001
[  146.202043] rtl8192cu: Chip version 0x11
[  146.278549] rtl8192cu: Board Type 0
[  146.278790] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
[  146.278823] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[  146.278938] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[  146.279113] usbcore: registered new interface driver rtl8192cu
[  146.281706] usbcore: registered new interface driver rtl8xxxu
[  146.344941] rtl8192cu 2-1.4:1.0 wlan125: renamed from wlan0
[  146.348126] rtl8192cu 2-1.4:1.0 wlan1: renamed from wlan125
[  187.045383] rtl8192cu: MAC auto ON okay!
[  187.079138] rtl8192cu: Tx queue select: 0x05
[  187.678428] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  190.424743] rtl8192cu: MAC auto ON okay!
[  190.457904] rtl8192cu: Tx queue select: 0x05
[  191.067336] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  191.192858] rtl8192cu: MAC auto ON okay!
[  191.225864] rtl8192cu: Tx queue select: 0x05
[  191.834651] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  193.861920] wlan1: authenticate with 34:e0:cf:f2:e2:18
[  193.873285] wlan1: send auth to 34:e0:cf:f2:e2:18 (try 1/3)
[  193.877329] wlan1: aborting authentication with 34:e0:cf:f2:e2:18 by 
local choice (Reason: 3=DEAUTH_LEAVING)
[  193.889626] wlan1: authenticate with 34:e0:cf:f2:e2:18
[  193.905124] wlan1: send auth to 34:e0:cf:f2:e2:18 (try 1/3)
[  193.908920] wlan1: aborting authentication with 34:e0:cf:f2:e2:18 by 
local choice (Reason: 3=DEAUTH_LEAVING)
[  193.921612] wlan1: authenticate with 34:e0:cf:f2:e2:18
[  193.934649] wlan1: send auth to 34:e0:cf:f2:e2:18 (try 1/3)
[  193.934694] wlan1: authenticated
[  193.935963] wlan1: associate with 34:e0:cf:f2:e2:18 (try 1/3)
[  193.991609] wlan1: RX AssocResp from 34:e0:cf:f2:e2:18 (capab=0x421 
status=0 aid=2)
[  194.093600] wlan1: associated
[  194.095031] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready

--
nirinA

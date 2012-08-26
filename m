Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42158 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab2HZHsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 03:48:18 -0400
Received: by yenl14 with SMTP id l14so710297yen.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Aug 2012 00:48:17 -0700 (PDT)
Message-ID: <5039D4BF.8070602@wybc.com> (sfid-20120826_094832_641415_D3DD1E9E)
Date: Sun, 26 Aug 2012 03:48:15 -0400
From: Sherwin Soltani <sherwin@wybc.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k: AR9462 btcoex doesn't appear to work
References: <50394BE4.3000508@wybc.com> <20537.33465.256314.716102@gargle.gargle.HOWL> <5039B192.3000206@wybc.com> <20120826060550.GA6979@vmraj-lnx.qca.qualcomm.com> <20120826060932.GB6979@vmraj-lnx.qca.qualcomm.com>
In-Reply-To: <20120826060932.GB6979@vmraj-lnx.qca.qualcomm.com>
Content-Type: multipart/mixed;
 boundary="------------080401080402080303070304"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080401080402080303070304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 08/26/2012 02:09 AM, Rajkumar Manoharan wrote:
> On Sun, Aug 26, 2012 at 11:35:52AM +0530, Rajkumar Manoharan wrote:
>> On Sun, Aug 26, 2012 at 01:18:10AM -0400, Sherwin Soltani wrote:
>>> On 08/25/2012 09:58 PM, Sujith Manoharan wrote:
>>>> What does lsusb -v show ?
>> I hope it is lspci's output not lsusb?

Yes, that was the output of lspci, I misread, sorry. lsusb -v attached 
(after I did 'modprobe ath3k').

> I mean the below message.
>> No. ath3k is BT firmware downloader that loads BT firmware into the target.
>> Can you please confirm whether you have ath3k driver or not? BT device will be
>> enumerated as usb device. Can you you share lsusb list and complete kernel log?

Kernel log is attached as dmesg.txt (also after modprobe ath3k). Nothing 
seemed to happen after inserting the ath3k module. No Bluetooth adapters 
registered.

--------------080401080402080303070304
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-999-generic (apw@gomeisa) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201208240408 SMP Fri Aug 24 08:09:13 UTC 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.6.0-999-generic root=UUID=7e08a896-ad51-43f4-bf94-412d19ce0d01 ro splash quiet vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000c4ee9fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c4eea000-0x00000000c50ebfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000c50ec000-0x00000000d41fefff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d41ff000-0x00000000d6eeefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d6eef000-0x00000000d6f9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000d6f9f000-0x00000000d6ffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000d6fff000-0x00000000d6ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d7000000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff980000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000019f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: Acer Aspire V5-571/Aspire V5-571, BIOS V1.10. 06/08/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x19f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FF800000 mask FFF800000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0D8000000 mask FF8000000 uncachable
[    0.000000]   5 base 0D7000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask F80000000 write-back
[    0.000000]   7 base 180000000 mask FE0000000 write-back
[    0.000000]   8 base 19F800000 mask FFF800000 uncachable
[    0.000000]   9 base 19F600000 mask FFFE00000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xd7000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f0100-0x000f010f] mapped at [ffff8800000f0100]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xd6ffffff]
[    0.000000]  [mem 0x00000000-0xd6ffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0xd6ffffff @ [mem 0x1f943000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x19f5fffff]
[    0.000000]  [mem 0x100000000-0x19f5fffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x19f5fffff @ [mem 0xd41f7000-0xd41fefff]
[    0.000000] RAMDISK: [mem 0x357d4000-0x36be1fff]
[    0.000000] ACPI: RSDP 00000000000f0120 00024 (v02 ACRSYS)
[    0.000000] ACPI: XSDT 00000000d6ffe170 0009C (v01 ACRSYS ACRPRDCT 00000001 ANNI 00000001)
[    0.000000] ACPI: FACP 00000000d6fed000 000F4 (v03 ACRSYS ACRPRDCT 00000001 ANNI 00000001)
[    0.000000] ACPI: DSDT 00000000d6ff0000 0BCA9 (v02 ACRSYS  IVB-CPT 00000000 INTL 20061109)
[    0.000000] ACPI: FACS 00000000d6f7c000 00040
[    0.000000] ACPI: SLIC 00000000d6ffd000 00176 (v01 ACRSYS ACRPRDCT 00000001 ANNI 00000001)
[    0.000000] ACPI: SSDT 00000000d6ffc000 001F9 (v01 ACRSYS PtidDevc 00001000 INTL 20061109)
[    0.000000] ACPI: ASF! 00000000d6fef000 000A5 (v32 ACRSYS ACRPRDCT 00000001 ANNI 00000001)
[    0.000000] ACPI: HPET 00000000d6fec000 00038 (v01 ACRSYS ACRPRDCT 00000001 ANNI 00000001)
[    0.000000] ACPI: APIC 00000000d6feb000 00098 (v01 ACRSYS ACRPRDCT 00000001 ANNI 00000001)
[    0.000000] ACPI: MCFG 00000000d6fea000 0003C (v01 ACRSYS ACRPRDCT 00000001 ANNI 00000001)
[    0.000000] ACPI: FPDT 00000000d6fe9000 00054 (v01 ACRSYS ACRPRDCT 00000001 ANNI 00000001)
[    0.000000] ACPI: SSDT 00000000d6fe8000 008A2 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000d6fe7000 00A92 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: UEFI 00000000d6fe6000 0003E (v01 ACRSYS ACRPRDCT 00000001 ANNI 00000001)
[    0.000000] ACPI: UEFI 00000000d6fe5000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: POAT 00000000d6fe4000 00055 (v03 ACRSYS ACRPRDCT 00000001 ANNI 00000001)
[    0.000000] ACPI: DMAR 00000000d6fe3000 000B8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 00000000d6fe2000 0026A (v01 ACRSYS ACRPRDCT 00000001 ANNI 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000019f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x19f5fffff]
[    0.000000]   NODE_DATA [mem 0x19f5fc000-0x19f5fffff]
[    0.000000]  [ffffea0000000000-ffffea00067fffff] PMD -> [ffff880198e00000-ffff88019ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x19f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xc4ee9fff]
[    0.000000]   node   0: [mem 0xc50ec000-0xd41fefff]
[    0.000000]   node   0: [mem 0xd6fff000-0xd6ffffff]
[    0.000000]   node   0: [mem 0x100000000-0x19f5fffff]
[    0.000000] On node 0 totalpages: 1520522
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 847421 pages, LIFO batch:31
[    0.000000]   Normal zone: 10200 pages used for memmap
[    0.000000]   Normal zone: 642600 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040004000 - 0000000040005000
[    0.000000] PM: Registered nosave memory: 00000000c4eea000 - 00000000c50ec000
[    0.000000] PM: Registered nosave memory: 00000000d41ff000 - 00000000d6eef000
[    0.000000] PM: Registered nosave memory: 00000000d6eef000 - 00000000d6f9f000
[    0.000000] PM: Registered nosave memory: 00000000d6f9f000 - 00000000d6fff000
[    0.000000] PM: Registered nosave memory: 00000000d7000000 - 00000000dfa00000
[    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed08000
[    0.000000] PM: Registered nosave memory: 00000000fed08000 - 00000000fed09000
[    0.000000] PM: Registered nosave memory: 00000000fed09000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff980000
[    0.000000] PM: Registered nosave memory: 00000000ff980000 - 0000000100000000
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88019f200000 s84608 r8192 d21888 u262144
[    0.000000] pcpu-alloc: s84608 r8192 d21888 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1493932
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.6.0-999-generic root=UUID=7e08a896-ad51-43f4-bf94-412d19ce0d01 ro splash quiet vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 5882472k/6805504k available (6825k kernel code, 723416k absent, 199616k reserved, 6361k data, 948k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:16640 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 1696.185 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3392.37 BogoMIPS (lpj=6784740)
[    0.000006] pid_max: default: 32768 minimum: 301
[    0.000032] Security Framework initialized
[    0.000047] AppArmor: AppArmor initialized
[    0.000751] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.003786] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.005123] Mount-cache hash table entries: 256
[    0.005353] Initializing cgroup subsys cpuacct
[    0.005356] Initializing cgroup subsys devices
[    0.005358] Initializing cgroup subsys freezer
[    0.005359] Initializing cgroup subsys blkio
[    0.005361] Initializing cgroup subsys perf_event
[    0.005392] CPU: Physical Processor ID: 0
[    0.005393] CPU: Processor Core ID: 0
[    0.005399] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.005399] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.005956] mce: CPU supports 7 MCE banks
[    0.005972] CPU0: Thermal monitoring enabled (TM1)
[    0.005980] process: using mwait in idle threads
[    0.005984] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.005984] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.005984] tlb_flushall_shift is 0x1
[    0.008954] ACPI: Core revision 20120711
[    0.017091] ftrace: allocating 27786 entries in 109 pages
[    0.036177] dmar: Host address width 36
[    0.036181] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.036192] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.036193] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.036200] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.036201] dmar: RMRR base: 0x000000d6288000 end: 0x000000d629efff
[    0.036203] dmar: RMRR base: 0x000000d7800000 end: 0x000000df9fffff
[    0.036276] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.036277] HPET id 0 under DRHD base 0xfed91000
[    0.036485] Enabled IRQ remapping in x2apic mode
[    0.036487] Enabling x2apic
[    0.036489] Enabled x2apic
[    0.036495] Switched APIC routing to cluster x2apic.
[    0.036973] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.076612] smpboot: CPU0: Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz stepping 09
[    0.183288] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.183295] ... version:                3
[    0.183297] ... bit width:              48
[    0.183298] ... generic registers:      4
[    0.183299] ... value mask:             0000ffffffffffff
[    0.183301] ... max period:             000000007fffffff
[    0.183302] ... fixed-purpose events:   3
[    0.183303] ... event mask:             000000070000000f
[    0.183525] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.183656] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.224904] Brought up 4 CPUs
[    0.224908] smpboot: Total of 4 processors activated (13569.48 BogoMIPS)
[    0.229853] devtmpfs: initialized
[    0.231150] EVM: security.selinux
[    0.231152] EVM: security.SMACK64
[    0.231153] EVM: security.capability
[    0.231208] PM: Registering ACPI NVS region [mem 0xd6eef000-0xd6f9efff] (720896 bytes)
[    0.232527] dummy: 
[    0.232562] RTC time:  3:19:22, date: 08/26/12
[    0.232607] NET: Registered protocol family 16
[    0.232804] ACPI: bus type pci registered
[    0.232888] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.232891] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.243196] PCI: Using configuration type 1 for base access
[    0.244235] bio: create slab <bio-0> at 0
[    0.244325] ACPI: Added _OSI(Module Device)
[    0.244327] ACPI: Added _OSI(Processor Device)
[    0.244329] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.244331] ACPI: Added _OSI(Processor Aggregator Device)
[    0.246246] ACPI: EC: Look up EC in DSDT
[    0.260333] ACPI: Executed 1 blocks of module-level executable AML code
[    0.263735] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.264328] ACPI: SSDT 00000000d6e8d018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.264826] ACPI: Dynamic OEM Table Load:
[    0.264829] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.265185] ACPI: SSDT 00000000d6e8ea98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.265722] ACPI: Dynamic OEM Table Load:
[    0.265725] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.265890] ACPI: SSDT 00000000d6e8cd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.266378] ACPI: Dynamic OEM Table Load:
[    0.266381] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.269330] ACPI: Interpreter enabled
[    0.269334] ACPI: (supports S0 S1 S3 S4 S5)
[    0.269365] ACPI: Using IOAPIC for interrupt routing
[    0.275323] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.275551] ACPI: No dock devices found.
[    0.275555] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.276006] \_SB_.PCI0:_OSC invalid UUID
[    0.276007] _OSC request data:1 8 1f 
[    0.276013] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.276746] PCI host bridge to bus 0000:00
[    0.276750] pci_bus 0000:00: busn_res: [bus 00-3e] is inserted under domain [bus 00-ff]
[    0.276752] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.276755] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.276757] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.276760] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.276762] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.276773] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    0.276822] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    0.276836] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.276844] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.276850] pci 0000:00:02.0: reg 20: [io  0x3000-0x303f]
[    0.276934] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.276965] pci 0000:00:14.0: reg 10: [mem 0xf0700000-0xf070ffff 64bit]
[    0.277072] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.277106] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.277138] pci 0000:00:16.0: reg 10: [mem 0xf0715000-0xf071500f 64bit]
[    0.277250] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.277304] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.277332] pci 0000:00:1a.0: reg 10: [mem 0xf071a000-0xf071a3ff]
[    0.277465] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.277504] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.277526] pci 0000:00:1b.0: reg 10: [mem 0xf0710000-0xf0713fff 64bit]
[    0.277633] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.277666] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.277785] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.277825] pci 0000:00:1c.2: [8086:1e14] type 01 class 0x060400
[    0.277948] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.277987] pci 0000:00:1c.3: [8086:1e16] type 01 class 0x060400
[    0.278106] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.278157] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.278186] pci 0000:00:1d.0: reg 10: [mem 0xf0719000-0xf07193ff]
[    0.278313] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.278348] pci 0000:00:1f.0: [8086:1e57] type 00 class 0x060100
[    0.278512] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    0.278540] pci 0000:00:1f.2: reg 10: [io  0x3098-0x309f]
[    0.278552] pci 0000:00:1f.2: reg 14: [io  0x30bc-0x30bf]
[    0.278564] pci 0000:00:1f.2: reg 18: [io  0x3090-0x3097]
[    0.278576] pci 0000:00:1f.2: reg 1c: [io  0x30b8-0x30bb]
[    0.278588] pci 0000:00:1f.2: reg 20: [io  0x3060-0x307f]
[    0.278600] pci 0000:00:1f.2: reg 24: [mem 0xf0718000-0xf07187ff]
[    0.278680] pci 0000:00:1f.2: PME# supported from D3hot
[    0.278708] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.278731] pci 0000:00:1f.3: reg 10: [mem 0xf0714000-0xf07140ff 64bit]
[    0.278762] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.278879] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-3e]
[    0.278884] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.278961] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-3e]
[    0.279050] pci 0000:02:00.0: [10ec:5289] type 00 class 0xff0000
[    0.279118] pci 0000:02:00.0: reg 10: [mem 0xf0600000-0xf060ffff]
[    0.279733] pci 0000:02:00.0: supports D1 D2
[    0.279735] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.279963] pci 0000:02:00.2: [10ec:8168] type 00 class 0x020000
[    0.280030] pci 0000:02:00.2: reg 10: [io  0x2000-0x20ff]
[    0.280160] pci 0000:02:00.2: reg 18: [mem 0xf0404000-0xf0404fff 64bit pref]
[    0.280240] pci 0000:02:00.2: reg 20: [mem 0xf0400000-0xf0403fff 64bit pref]
[    0.280607] pci 0000:02:00.2: supports D1 D2
[    0.280609] pci 0000:02:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.289321] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.289327] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.289332] pci 0000:00:1c.2:   bridge window [mem 0xf0600000-0xf06fffff]
[    0.289340] pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
[    0.289407] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-3e]
[    0.289453] pci 0000:03:00.0: [168c:0034] type 00 class 0x028000
[    0.289509] pci 0000:03:00.0: reg 10: [mem 0xf0500000-0xf057ffff 64bit]
[    0.289639] pci 0000:03:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    0.289789] pci 0000:03:00.0: supports D1 D2
[    0.289791] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.297250] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.297259] pci 0000:00:1c.3:   bridge window [mem 0xf0500000-0xf05fffff]
[    0.297287] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.297431] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.297470] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.297508] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.297630] \_SB_.PCI0:_OSC invalid UUID
[    0.297631] _OSC request data:1 1f 1f 
[    0.297636]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.297638]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.301112] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    0.301170] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.301230] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.301283] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 10 11 12 14 15) *7
[    0.301336] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.301389] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.301443] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.301495] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    0.301601] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.301608] vgaarb: loaded
[    0.301610] vgaarb: bridge control possible 0000:00:02.0
[    0.301777] SCSI subsystem initialized
[    0.301780] ACPI: bus type scsi registered
[    0.301828] libata version 3.00 loaded.
[    0.301856] ACPI: bus type usb registered
[    0.301878] usbcore: registered new interface driver usbfs
[    0.301888] usbcore: registered new interface driver hub
[    0.301923] usbcore: registered new device driver usb
[    0.302013] PCI: Using ACPI for IRQ routing
[    0.303879] PCI: pci_cache_line_size set to 64 bytes
[    0.303969] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.303971] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.303973] e820: reserve RAM buffer [mem 0xc4eea000-0xc7ffffff]
[    0.303975] e820: reserve RAM buffer [mem 0xd41ff000-0xd7ffffff]
[    0.303977] e820: reserve RAM buffer [mem 0xd7000000-0xd7ffffff]
[    0.303979] e820: reserve RAM buffer [mem 0x19f600000-0x19fffffff]
[    0.304083] NetLabel: Initializing
[    0.304085] NetLabel:  domain hash size = 128
[    0.304086] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.304098] NetLabel:  unlabeled traffic allowed by default
[    0.304165] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.304173] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.306187] Switching to clocksource hpet
[    0.313048] AppArmor: AppArmor Filesystem Enabled
[    0.313077] pnp: PnP ACPI init
[    0.313096] ACPI: bus type pnp registered
[    0.313509] pnp 00:00: [bus 00-3e]
[    0.313513] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.313515] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.313517] pnp 00:00: [io  0x0d00-0xffff window]
[    0.313520] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.313522] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.313524] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.313526] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.313528] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.313530] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.313532] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.313534] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.313537] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.313539] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.313543] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.313545] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.313547] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.313549] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.313551] pnp 00:00: [mem 0xdfa00000-0xfeafffff window]
[    0.313553] pnp 00:00: [mem 0x00010000-0x0001ffff window]
[    0.313626] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.313643] pnp 00:01: [io  0x0000-0x001f]
[    0.313645] pnp 00:01: [io  0x0081-0x0091]
[    0.313647] pnp 00:01: [io  0x0093-0x009f]
[    0.313649] pnp 00:01: [io  0x00c0-0x00df]
[    0.313651] pnp 00:01: [dma 4]
[    0.313676] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.313685] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.313705] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.313793] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.313816] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.313827] pnp 00:04: [io  0x00f0]
[    0.313842] pnp 00:04: [irq 13]
[    0.313863] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.313875] pnp 00:05: [io  0x002e-0x002f]
[    0.313877] pnp 00:05: [io  0x004e-0x004f]
[    0.313879] pnp 00:05: [io  0x0061]
[    0.313881] pnp 00:05: [io  0x0063]
[    0.313882] pnp 00:05: [io  0x0065]
[    0.313884] pnp 00:05: [io  0x0067]
[    0.313886] pnp 00:05: [io  0x0070]
[    0.313888] pnp 00:05: [io  0x0080]
[    0.313890] pnp 00:05: [io  0x0092]
[    0.313891] pnp 00:05: [io  0x00b2-0x00b3]
[    0.313893] pnp 00:05: [io  0x1000-0x100f]
[    0.313895] pnp 00:05: [io  0xffff]
[    0.313897] pnp 00:05: [io  0xffff]
[    0.313899] pnp 00:05: [io  0x0400-0x0453]
[    0.313901] pnp 00:05: [io  0x0458-0x047f]
[    0.313903] pnp 00:05: [io  0x0500-0x057f]
[    0.313905] pnp 00:05: [io  0x0068-0x006f]
[    0.313907] pnp 00:05: [mem 0xfe800000-0xfe80ffff]
[    0.313955] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.313958] system 00:05: [io  0xffff] has been reserved
[    0.313960] system 00:05: [io  0xffff] has been reserved
[    0.313963] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.313965] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.313968] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.313971] system 00:05: [mem 0xfe800000-0xfe80ffff] has been reserved
[    0.313975] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.313984] pnp 00:06: [io  0x0070-0x0077]
[    0.313993] pnp 00:06: [irq 8]
[    0.314014] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.314045] pnp 00:07: [io  0x0454-0x0457]
[    0.314080] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.314084] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.314139] pnp 00:08: [io  0x0060]
[    0.314141] pnp 00:08: [io  0x0064]
[    0.314149] pnp 00:08: [irq 1]
[    0.314173] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.314201] pnp 00:09: [irq 12]
[    0.314229] pnp 00:09: Plug and Play ACPI device, IDs SYN1b5e SYN1b00 SYN0002 PNP0f13 (active)
[    0.314349] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    0.314351] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
[    0.314355] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    0.314357] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    0.314359] pnp 00:0a: [mem 0xf8000000-0xfbffffff]
[    0.314361] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    0.314362] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    0.314364] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    0.314366] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    0.314368] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    0.314370] pnp 00:0a: [mem 0xfffff000-0xffffffff]
[    0.314389] pnp 00:0a: disabling [mem 0xfffff000-0xffffffff] because it overlaps 0000:03:00.0 BAR 6 [mem 0xffff0000-0xffffffff pref]
[    0.314416] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.314419] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.314421] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.314424] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.314426] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.314429] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.314432] system 00:0a: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.314434] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.314437] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    0.314439] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.314442] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.314738] pnp: PnP ACPI: found 11 devices
[    0.314739] ACPI: ACPI bus type pnp unregistered
[    0.321246] pci 0000:03:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    0.321300] pci 0000:00:1c.3: BAR 15: assigned [mem 0xdfa00000-0xdfafffff pref]
[    0.321303] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.321320] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.321324] pci 0000:00:1c.2:   bridge window [io  0x2000-0x2fff]
[    0.321331] pci 0000:00:1c.2:   bridge window [mem 0xf0600000-0xf06fffff]
[    0.321338] pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
[    0.321349] pci 0000:03:00.0: BAR 6: assigned [mem 0xdfa00000-0xdfa0ffff pref]
[    0.321352] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.321359] pci 0000:00:1c.3:   bridge window [mem 0xf0500000-0xf05fffff]
[    0.321365] pci 0000:00:1c.3:   bridge window [mem 0xdfa00000-0xdfafffff pref]
[    0.321414] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.321416] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.321419] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.321421] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfeafffff]
[    0.321424] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.321426] pci_bus 0000:02: resource 1 [mem 0xf0600000-0xf06fffff]
[    0.321428] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf04fffff 64bit pref]
[    0.321431] pci_bus 0000:03: resource 1 [mem 0xf0500000-0xf05fffff]
[    0.321433] pci_bus 0000:03: resource 2 [mem 0xdfa00000-0xdfafffff pref]
[    0.321467] NET: Registered protocol family 2
[    0.322226] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.323699] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.323847] TCP: Hash tables configured (established 524288 bind 65536)
[    0.323865] TCP: reno registered
[    0.323884] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.323925] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.324028] NET: Registered protocol family 1
[    0.324042] pci 0000:00:02.0: Boot video device
[    0.324246] PCI: CLS 64 bytes, default 64
[    0.324297] Trying to unpack rootfs image as initramfs...
[    0.815074] Freeing initrd memory: 20536k freed
[    0.818206] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.818212] software IO TLB [mem 0xd01f7000-0xd41f6fff] (64MB) mapped at [ffff8800d01f7000-ffff8800d41f6fff]
[    0.818702] audit: initializing netlink socket (disabled)
[    0.818721] type=2000 audit(1345951162.700:1): initialized
[    0.853603] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.855485] VFS: Disk quotas dquot_6.5.2
[    0.855529] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.856036] fuse init (API version 7.20)
[    0.856116] msgmni has been set to 11529
[    0.856529] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.856561] io scheduler noop registered
[    0.856563] io scheduler deadline registered (default)
[    0.856591] io scheduler cfq registered
[    0.856864] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.856883] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.856931] intel_idle: MWAIT substates: 0x21120
[    0.856933] intel_idle: v0.4 model 0x3A
[    0.856934] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.857063] ACPI: AC Adapter [ADP1] (on-line)
[    0.857208] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.857239] ACPI: Lid Switch [LID0]
[    0.857279] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.857283] ACPI: Sleep Button [SLPB]
[    0.857320] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.857323] ACPI: Power Button [PWRF]
[    0.857417] ACPI: Requesting acpi_cpufreq
[    0.862840] thermal LNXTHERM:00: registered as thermal_zone0
[    0.862843] ACPI: Thermal Zone [TZS0] (46 C)
[    0.862989] thermal LNXTHERM:01: registered as thermal_zone1
[    0.862991] ACPI: Thermal Zone [TZS1] (37 C)
[    0.863020] GHES: HEST is not enabled!
[    0.863093] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.863872] ACPI: Battery Slot [BAT0] (battery present)
[    0.864572] Linux agpgart interface v0.103
[    0.865994] brd: module loaded
[    0.866693] loop: module loaded
[    0.866798] ahci 0000:00:1f.2: version 3.0
[    0.866887] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
[    0.881550] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x11 impl SATA mode
[    0.881554] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    0.881560] ahci 0000:00:1f.2: setting latency timer to 64
[    0.889965] scsi0 : ahci
[    0.890046] scsi1 : ahci
[    0.890115] scsi2 : ahci
[    0.890181] scsi3 : ahci
[    0.890248] scsi4 : ahci
[    0.890315] scsi5 : ahci
[    0.890359] ata1: SATA max UDMA/133 abar m2048@0xf0718000 port 0xf0718100 irq 42
[    0.890361] ata2: DUMMY
[    0.890363] ata3: DUMMY
[    0.890364] ata4: DUMMY
[    0.890367] ata5: SATA max UDMA/133 abar m2048@0xf0718000 port 0xf0718300 irq 42
[    0.890369] ata6: DUMMY
[    0.890702] libphy: Fixed MDIO Bus: probed
[    0.890743] tun: Universal TUN/TAP device driver, 1.6
[    0.890744] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.890793] PPP generic driver version 2.4.2
[    0.890838] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.890884] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.890888] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.890895] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.894810] ehci_hcd 0000:00:1a.0: debug port 2
[    0.894819] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.894837] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf071a000
[    0.905506] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.905527] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.905529] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.905531] usb usb1: Product: EHCI Host Controller
[    0.905534] usb usb1: Manufacturer: Linux 3.6.0-999-generic ehci_hcd
[    0.905535] usb usb1: SerialNumber: 0000:00:1a.0
[    0.905660] hub 1-0:1.0: USB hub found
[    0.905665] hub 1-0:1.0: 3 ports detected
[    0.905746] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.905750] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.905757] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.909651] ehci_hcd 0000:00:1d.0: debug port 2
[    0.909661] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.909677] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf0719000
[    0.921486] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.921500] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.921502] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.921504] usb usb2: Product: EHCI Host Controller
[    0.921506] usb usb2: Manufacturer: Linux 3.6.0-999-generic ehci_hcd
[    0.921508] usb usb2: SerialNumber: 0000:00:1d.0
[    0.921619] hub 2-0:1.0: USB hub found
[    0.921623] hub 2-0:1.0: 3 ports detected
[    0.921680] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.921695] uhci_hcd: USB Universal Host Controller Interface driver
[    0.921749] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    0.921752] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.921757] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    0.921854] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.921869] xhci_hcd 0000:00:14.0: irq 21, io mem 0xf0700000
[    0.921939] xhci_hcd 0000:00:14.0: irq 43 for MSI/MSI-X
[    0.921990] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.921992] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.921994] usb usb3: Product: xHCI Host Controller
[    0.921996] usb usb3: Manufacturer: Linux 3.6.0-999-generic xhci_hcd
[    0.921998] usb usb3: SerialNumber: 0000:00:14.0
[    0.922080] xHCI xhci_add_endpoint called for root hub
[    0.922082] xHCI xhci_check_bandwidth called for root hub
[    0.922104] hub 3-0:1.0: USB hub found
[    0.922112] hub 3-0:1.0: 4 ports detected
[    0.922167] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.922171] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    0.922193] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    0.922196] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.922198] usb usb4: Product: xHCI Host Controller
[    0.922200] usb usb4: Manufacturer: Linux 3.6.0-999-generic xhci_hcd
[    0.922202] usb usb4: SerialNumber: 0000:00:14.0
[    0.922279] xHCI xhci_add_endpoint called for root hub
[    0.922281] xHCI xhci_check_bandwidth called for root hub
[    0.922301] hub 4-0:1.0: USB hub found
[    0.922309] hub 4-0:1.0: 4 ports detected
[    0.922441] usbcore: registered new interface driver libusual
[    0.922477] i8042: PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.925036] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.925042] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.925170] mousedev: PS/2 mouse device common for all mice
[    0.925321] rtc_cmos 00:06: RTC can wake from S4
[    0.925467] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.925500] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.925574] device-mapper: uevent: version 1.0.3
[    0.925651] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[    0.925766] cpuidle: using governor ladder
[    0.925887] cpuidle: using governor menu
[    0.925889] EFI Variables Facility v0.08 2004-May-17
[    0.926099] ashmem: initialized
[    0.926233] TCP: cubic registered
[    0.926333] NET: Registered protocol family 10
[    0.926509] NET: Registered protocol family 17
[    0.926523] Key type dns_resolver registered
[    0.926799] PM: Hibernation image not present or could not be loaded.
[    0.926811] registered taskstats version 1
[    0.929382] Key type trusted registered
[    0.931510] Key type encrypted registered
[    0.934124]   Magic number: 8:552:311
[    0.934244] rtc_cmos 00:06: setting system clock to 2012-08-26 03:19:23 UTC (1345951163)
[    0.935107] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.935109] EDD information not available.
[    0.946767] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.209224] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.209249] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.210485] ata1.00: ATA-8: Hitachi HTS545050A7E380, GG2OA6C0, max UDMA/133
[    1.210495] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.211848] ata1.00: configured for UDMA/133
[    1.212060] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54505 GG2O PQ: 0 ANSI: 5
[    1.212282] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.212291] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.212297] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.212441] sd 0:0:0:0: [sda] Write Protect is off
[    1.212445] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.212474] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.212786] ata5.00: ATAPI: HL-DT-ST DVDRAM GU61N, 1.00, max UDMA/133
[    1.214242] ata5.00: configured for UDMA/133
[    1.217177] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.234662] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GU61N     1.00 PQ: 0 ANSI: 5
[    1.251328] sr0: scsi3-mmc drive: 24x/8x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.251332] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.251464] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    1.251598] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    1.294551]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[    1.295701] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.296883] Freeing unused kernel memory: 948k freed
[    1.296977] Write protecting the kernel read-only data: 12288k
[    1.300305] Freeing unused kernel memory: 1356k freed
[    1.302823] Freeing unused kernel memory: 1048k freed
[    1.316794] udevd[119]: starting version 175
[    1.339057] [drm] Initialized drm 1.1.0 20060810
[    1.339374] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.339632] r8169 0000:02:00.2: irq 44 for MSI/MSI-X
[    1.340043] r8169 0000:02:00.2: eth0: RTL8411 at 0xffffc90000c76000, 20:6a:8a:88:68:6e, XID 08800800 IRQ 44
[    1.340047] r8169 0000:02:00.2: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    1.343223] wmi: Mapper loaded
[    1.344305] pci 0000:00:00.0: Intel Ivybridge Chipset
[    1.344421] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.345436] pci 0000:00:00.0: detected 131072K stolen memory
[    1.345483] i915 0000:00:02.0: setting latency timer to 64
[    1.349340] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.349345] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.349623] hub 1-1:1.0: USB hub found
[    1.349707] hub 1-1:1.0: 6 ports detected
[    1.389214] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    1.389222] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.389223] [drm] Driver supports precise vblank timestamp query.
[    1.389264] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.460929] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.568784] [drm] failed to retrieve link info, disabling eDP
[    1.593112] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.593127] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.593346] hub 2-1:1.0: USB hub found
[    1.593443] hub 2-1:1.0: 8 ports detected
[    1.760569] usb 3-1: new low-speed USB device number 2 using xhci_hcd
[    1.779787] usb 3-1: New USB device found, idVendor=0461, idProduct=4d0f
[    1.779797] usb 3-1: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    1.779802] usb 3-1: Product: USB Optical Mouse
[    1.780105] usb 3-1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    1.784082] usbcore: registered new interface driver usbhid
[    1.784085] usbhid: USB HID core driver
[    1.816449] tsc: Refined TSC clocksource calibration: 1696.146 MHz
[    1.816453] Switching to clocksource tsc
[    1.892360] usb 3-2: new full-speed USB device number 3 using xhci_hcd
[    1.912944] usb 3-2: New USB device found, idVendor=1532, idProduct=010b
[    1.912954] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.912959] usb 3-2: Product: Razer Arctosa
[    1.912963] usb 3-2: Manufacturer: Razer
[    1.913197] usb 3-2: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
[    2.036053] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    2.084104] usb 3-4: new high-speed USB device number 4 using xhci_hcd
[    2.145863] usb 3-4: New USB device found, idVendor=04f2, idProduct=b336
[    2.145873] usb 3-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.145879] usb 3-4: Product: HD WebCam
[    2.145883] usb 3-4: Manufacturer: HD WebCam
[    2.210795] fbcon: inteldrmfb (fb0) is primary device
[    1.251778] ACPI: Invalid Power Resource to register!
[    2.503708] Console: switching to colour frame buffer device 170x48
[    2.506036] fb0: inteldrmfb frame buffer device
[    2.506037] drm: registered panic notifier
[    2.509249] acpi device:41: registered as cooling_device4
[    2.509451] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.509512] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input4
[    2.509577] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    3.315717] scsi 6:0:0:0: Direct-Access     Android  UMS Composite    0001 PQ: 0 ANSI: 2
[    3.316219] scsi 6:0:0:1: Direct-Access     Android  UMS Composite    0001 PQ: 0 ANSI: 2
[    3.316978] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    3.317100] sd 6:0:0:1: Attached scsi generic sg3 type 0
[    3.321903] sd 6:0:0:1: [sdc] Attached SCSI removable disk
[    3.325083] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[    7.757343] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    9.370049] init: ureadahead main process (363) terminated with status 5
[   12.215175] udevd[432]: starting version 175
[   13.205397] EXT4-fs (sda5): re-mounted. Opts: errors=remount-ro
[   13.344810] lp: driver loaded but no devices found
[   15.401447] ACPI Warning: 0x0000000000000460-0x000000000000047f SystemIO conflicts with Region \PMIO 1 (20120711/utaddress-251)
[   15.401455] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   15.401458] lpc_ich: Resource conflict(s) found affecting iTCO_wdt
[   15.401461] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20120711/utaddress-251)
[   15.401465] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   15.401469] ACPI Warning: 0x0000000000000500-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20120711/utaddress-251)
[   15.401473] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   15.401475] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   15.460398] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x12
[   15.558038] cfg80211: Calling CRDA to update world regulatory domain
[   15.831034] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x12
[   15.832215] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x12
[   15.833297] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x12
[   15.834404] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   15.844131] acer_wmi: Acer Laptop ACPI-WMI Extras
[   15.844142] acer_wmi: Function bitmap for Communication Button: 0x801
[   15.851781] acer_wmi: Brightness must be controlled by acpi video driver
[   15.851889] input: Acer WMI hotkeys as /devices/virtual/input/input5
[   15.852179] input: Acer BMA150 accelerometer as /devices/virtual/input/input6
[   16.101482] mei 0000:00:16.0: setting latency timer to 64
[   16.101544] mei 0000:00:16.0: irq 46 for MSI/MSI-X
[   16.110498] mei 0000:00:16.0: wd: failed to find the client
[   16.299531] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd00123/0x840300/0x126c00, board id: 2134, fw id: 1100738
[   16.333695] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[   16.496658] input: USB Optical Mouse as /devices/pci0000:00/0000:00:14.0/usb3/3-1/3-1:1.0/input/input8
[   16.496985] hid-generic 0003:0461:4D0F.0001: input,hidraw0: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:14.0-1/input0
[   16.497143] input: Razer Razer Arctosa as /devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.0/input/input9
[   16.497438] hid-generic 0003:1532:010B.0002: input,hidraw1: USB HID v1.11 Keyboard [Razer Razer Arctosa] on usb-0000:00:14.0-2/input0
[   16.497775] input: Razer Razer Arctosa as /devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.1/input/input10
[   16.497983] hid-generic 0003:1532:010B.0003: input,hidraw2: USB HID v1.11 Device [Razer Razer Arctosa] on usb-0000:00:14.0-2/input1
[   16.805393] ath: phy0: ASPM enabled: 0x43
[   16.805397] ath: EEPROM regdomain: 0x6a
[   16.805398] ath: EEPROM indicates we should expect a direct regpair map
[   16.805400] ath: Country alpha2 being used: 00
[   16.805401] ath: Regpair used: 0x6a
[   16.805404] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[   16.805406] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.805407] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[   16.805409] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.805410] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[   16.805412] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.805413] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[   16.805414] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.805415] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[   16.805417] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.805418] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[   16.805420] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.805421] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[   16.805422] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.805423] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[   16.805425] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.805426] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[   16.805428] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.805429] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[   16.805430] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.805432] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[   16.805433] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.805434] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
[   16.805436] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.805437] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
[   16.805438] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   16.805440] cfg80211: Disabling freq 2484 MHz as custom regd has no rule that fits a 20 MHz wide channel
[   16.805441] cfg80211: Updating information on frequency 5180 MHz for a 20 MHz width channel with regulatory rule:
[   16.805443] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805444] cfg80211: Updating information on frequency 5200 MHz for a 20 MHz width channel with regulatory rule:
[   16.805445] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805447] cfg80211: Updating information on frequency 5220 MHz for a 20 MHz width channel with regulatory rule:
[   16.805448] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805449] cfg80211: Updating information on frequency 5240 MHz for a 20 MHz width channel with regulatory rule:
[   16.805451] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805452] cfg80211: Updating information on frequency 5260 MHz for a 20 MHz width channel with regulatory rule:
[   16.805453] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805455] cfg80211: Updating information on frequency 5280 MHz for a 20 MHz width channel with regulatory rule:
[   16.805456] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805457] cfg80211: Updating information on frequency 5300 MHz for a 20 MHz width channel with regulatory rule:
[   16.805459] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805460] cfg80211: Updating information on frequency 5320 MHz for a 20 MHz width channel with regulatory rule:
[   16.805462] cfg80211: 5140000 KHz - 5360000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805463] cfg80211: Updating information on frequency 5500 MHz for a 20 MHz width channel with regulatory rule:
[   16.805464] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805466] cfg80211: Updating information on frequency 5520 MHz for a 20 MHz width channel with regulatory rule:
[   16.805467] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805468] cfg80211: Updating information on frequency 5540 MHz for a 20 MHz width channel with regulatory rule:
[   16.805470] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805471] cfg80211: Updating information on frequency 5560 MHz for a 20 MHz width channel with regulatory rule:
[   16.805472] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805474] cfg80211: Updating information on frequency 5580 MHz for a 20 MHz width channel with regulatory rule:
[   16.805475] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805476] cfg80211: Updating information on frequency 5600 MHz for a 20 MHz width channel with regulatory rule:
[   16.805478] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805479] cfg80211: Updating information on frequency 5620 MHz for a 20 MHz width channel with regulatory rule:
[   16.805480] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805482] cfg80211: Updating information on frequency 5640 MHz for a 20 MHz width channel with regulatory rule:
[   16.805483] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805484] cfg80211: Updating information on frequency 5660 MHz for a 20 MHz width channel with regulatory rule:
[   16.805486] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805487] cfg80211: Updating information on frequency 5680 MHz for a 20 MHz width channel with regulatory rule:
[   16.805489] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805490] cfg80211: Updating information on frequency 5700 MHz for a 20 MHz width channel with regulatory rule:
[   16.805491] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805492] cfg80211: Updating information on frequency 5745 MHz for a 20 MHz width channel with regulatory rule:
[   16.805494] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805495] cfg80211: Updating information on frequency 5765 MHz for a 20 MHz width channel with regulatory rule:
[   16.805497] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805498] cfg80211: Updating information on frequency 5785 MHz for a 20 MHz width channel with regulatory rule:
[   16.805499] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805501] cfg80211: Updating information on frequency 5805 MHz for a 20 MHz width channel with regulatory rule:
[   16.805502] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.805503] cfg80211: Updating information on frequency 5825 MHz for a 20 MHz width channel with regulatory rule:
[   16.805505] cfg80211: 5460000 KHz - 5860000 KHz @ 40000 KHz), (N/A mBi, 3000 mBm)
[   16.806079] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[   17.037749] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[   17.037754] cfg80211: World regulatory domain updated:
[   17.037755] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   17.037757] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   17.037758] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   17.037759] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   17.037760] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   17.037761] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   17.098107] ip_tables: (C) 2000-2006 Netfilter Core Team
[   17.121162] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
[   17.121376] Registered led device: ath9k-phy0
[   17.121382] ieee80211 phy0: Atheros AR9462 Rev:2 mem=0xffffc90016300000, irq=19
[   17.252106] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   17.379491] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   17.597670] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   17.774656] type=1400 audit(1345965580.357:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=748 comm="apparmor_parser"
[   17.774728] type=1400 audit(1345965580.357:3): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=796 comm="apparmor_parser"
[   17.774736] type=1400 audit(1345965580.357:4): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=850 comm="apparmor_parser"
[   17.774976] type=1400 audit(1345965580.357:5): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=748 comm="apparmor_parser"
[   17.775122] type=1400 audit(1345965580.357:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=796 comm="apparmor_parser"
[   17.775133] type=1400 audit(1345965580.357:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=850 comm="apparmor_parser"
[   17.775158] type=1400 audit(1345965580.357:8): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=748 comm="apparmor_parser"
[   17.775352] type=1400 audit(1345965580.357:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=796 comm="apparmor_parser"
[   17.775370] type=1400 audit(1345965580.357:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=850 comm="apparmor_parser"
[   18.165207] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   18.165288] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   20.501206] ppdev: user-space parallel port driver
[   20.912565] Bluetooth: Core ver 2.16
[   20.912582] NET: Registered protocol family 31
[   20.912584] Bluetooth: HCI device and connection manager initialized
[   20.912586] Bluetooth: HCI socket layer initialized
[   20.912587] Bluetooth: L2CAP socket layer initialized
[   20.912591] Bluetooth: SCO socket layer initialized
[   20.985037] type=1400 audit(1345965583.569:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=996 comm="apparmor_parser"
[   21.054470] init: failsafe main process (950) killed by TERM signal
[   21.114232] Bluetooth: RFCOMM TTY layer initialized
[   21.114237] Bluetooth: RFCOMM socket layer initialized
[   21.114238] Bluetooth: RFCOMM ver 1.11
[   21.561138] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   21.561142] Bluetooth: BNEP filters: protocol multicast
[   23.170172] audit_printk_skb: 3 callbacks suppressed
[   23.170175] type=1400 audit(1345965585.757:13): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=1085 comm="apparmor_parser"
[   23.170504] type=1400 audit(1345965585.757:14): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1085 comm="apparmor_parser"
[   23.170688] type=1400 audit(1345965585.757:15): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=1085 comm="apparmor_parser"
[   23.172907] type=1400 audit(1345965585.761:16): apparmor="STATUS" operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf" pid=1089 comm="apparmor_parser"
[   23.173257] type=1400 audit(1345965585.761:17): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd" pid=1089 comm="apparmor_parser"
[   23.466735] type=1400 audit(1345965586.057:18): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=1084 comm="apparmor_parser"
[   23.548066] type=1400 audit(1345965586.137:19): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=1091 comm="apparmor_parser"
[   24.071197] type=1400 audit(1345965586.661:20): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/mission-control-5" pid=1088 comm="apparmor_parser"
[   24.071594] type=1400 audit(1345965586.661:21): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/telepathy-*" pid=1088 comm="apparmor_parser"
[   25.097229] type=1400 audit(1345965587.689:22): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince" pid=1086 comm="apparmor_parser"
[   27.420703] r8169 0000:02:00.2: eth0: link down
[   27.420739] r8169 0000:02:00.2: eth0: link down
[   27.420765] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   27.431425] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   29.066646] r8169 0000:02:00.2: eth0: link up
[   29.066666] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   36.375893] wlan0: authenticate with 2c:b0:5d:45:33:58
[   36.380911] wlan0: send auth to 2c:b0:5d:45:33:58 (try 1/3)
[   36.383572] wlan0: authenticated
[   36.387091] wlan0: associate with 2c:b0:5d:45:33:58 (try 1/3)
[   36.390628] wlan0: RX AssocResp from 2c:b0:5d:45:33:58 (capab=0x411 status=0 aid=2)
[   36.390685] wlan0: associated
[   36.390700] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  363.269356] audit_printk_skb: 21 callbacks suppressed
[  556.124086] usbcore: registered new interface driver ath3k

--------------080401080402080303070304
Content-Type: text/plain; charset=UTF-8;
 name="lsusb.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lsusb.txt"


Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         1 Single TT
  bMaxPacketSize0        64
  idVendor           0x8087 Intel Corp.
  idProduct          0x0024 Integrated Rate Matching Hub
  bcdDevice            0.00
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x0009
    Per-port power switching
    Per-port overcurrent protection
    TT think time 8 FS bits
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0001
  Self Powered

Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         1 Single TT
  bMaxPacketSize0        64
  idVendor           0x8087 Intel Corp.
  idProduct          0x0024 Integrated Rate Matching Hub
  bcdDevice            0.00
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval              12
Hub Descriptor:
  bLength              11
  bDescriptorType      41
  nNbrPorts             8
  wHubCharacteristic 0x0009
    Per-port power switching
    Per-port overcurrent protection
    TT think time 8 FS bits
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00 0x00
  PortPwrCtrlMask    0xff 0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
   Port 7: 0000.0100 power
   Port 8: 0000.0100 power
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0001
  Self Powered

Bus 003 Device 006: ID 0461:4d0f Primax Electronics, Ltd 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x0461 Primax Electronics, Ltd
  idProduct          0x4d0f 
  bcdDevice            2.00
  iManufacturer           0 
  iProduct                2 USB Optical Mouse
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower               98mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      2 Mouse
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      71
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0006  1x 6 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

Bus 003 Device 005: ID 1532:010b Razer USA, Ltd 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x1532 Razer USA, Ltd
  idProduct          0x010b 
  bcdDevice            0.03
  iManufacturer           1 Razer
  iProduct                2 Razer Arctosa
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           59
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      54
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      0 None
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.11
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      52
         Report Descriptors: 
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0003  1x 3 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)

Bus 003 Device 004: ID 04f2:b336 Chicony Electronics Co., Ltd 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x04f2 Chicony Electronics Co., Ltd
  idProduct          0xb336 
  bcdDevice           13.08
  iManufacturer           1 HD WebCam
  iProduct                2 HD WebCam
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          727
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass         14 Video
      bFunctionSubClass       3 Video Interface Collection
      bFunctionProtocol       0 
      iFunction               4 HD WebCam
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0 
      iInterface              4 HD WebCam
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.00
        wTotalLength           79
        dwClockFrequency       30.000000MHz
        bInCollection           1
        baInterfaceNr( 0)       1
      VideoControl Interface Descriptor:
        bLength                28
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 6
        guidExtensionCode         {b0d0bb68-a461-834b-90b7-a6215f3c4f70}
        bNumControl            24
        bNrPins                 1
        baSourceID( 0)          2
        bControlSize            3
        bmControls( 0)       0xff
        bmControls( 1)       0xff
        bmControls( 2)       0xff
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                18
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Camera Sensor
        bAssocTerminal          0
        iTerminal               0 
        wObjectiveFocalLengthMin      0
        wObjectiveFocalLengthMax      0
        wOcularFocalLength            0
        bControlSize                  3
        bmControls           0x00000004
          Auto-Exposure Priority
      VideoControl Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
      Warning: Descriptor too short
        bUnitID                 2
        bSourceID               1
        wMaxMultiplier          0
        bControlSize            2
        bmControls     0x0000053f
          Brightness
          Contrast
          Hue
          Saturation
          Sharpness
          Gamma
          Backlight Compensation
          Power Line Frequency
        iProcessing             0 
        bmVideoStandards     0x 9
          None
          SECAM - 625/50
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               2
        iTerminal               0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               7
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              4 HD WebCam
      VideoStreaming Interface Descriptor:
        bLength                            15
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         2
        wTotalLength                      537
        bEndPointAddress                  130
        bmInfo                              0
        bTerminalLink                       3
        bStillCaptureMethod                 1
        bTriggerSupport                     1
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    27
        bmaControls( 1)                    27
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        1
        bNumFrameDescriptors                7
        guidFormat                            {59555932-0000-1000-8000-00aa00389b71}
        bBitsPerPixel                      16
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 2 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x01
          Still image supported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 73728000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x01
          Still image supported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  4608000
        dwMaxBitRate                  9216000
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x01
          Still image supported
        wWidth                            176
        wHeight                           144
        dwMinBitRate                  6082560
        dwMaxBitRate                 12165120
        dwMaxVideoFrameBufferSize       50688
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         4
        bmCapabilities                   0x01
          Still image supported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                 18432000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         5
        bmCapabilities                   0x01
          Still image supported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                 24330240
        dwMaxBitRate                 48660480
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         6
        bmCapabilities                   0x01
          Still image supported
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                147456000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize     1843200
        dwDefaultFrameInterval        1000000
        bFrameIntervalType                  1
        dwFrameInterval( 0)           1000000
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         7
        bmCapabilities                   0x01
          Still image supported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 73728000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
      VideoStreaming Interface Descriptor:
        bLength                            11
        bDescriptorType                    36
        bDescriptorSubtype                  6 (FORMAT_MJPEG)
        bFormatIndex                        2
        bNumFrameDescriptors                7
        bFlags                              1
          Fixed-size samples: Yes
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 1 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         1
        bmCapabilities                   0x01
          Still image supported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                110592000
        dwMaxBitRate                221184000
        dwMaxVideoFrameBufferSize      921600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         2
        bmCapabilities                   0x01
          Still image supported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  6912000
        dwMaxBitRate                 13824000
        dwMaxVideoFrameBufferSize       57600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         3
        bmCapabilities                   0x01
          Still image supported
        wWidth                            176
        wHeight                           144
        dwMinBitRate                  9123840
        dwMaxBitRate                 18247680
        dwMaxVideoFrameBufferSize       76032
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         4
        bmCapabilities                   0x01
          Still image supported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                 27648000
        dwMaxBitRate                 55296000
        dwMaxVideoFrameBufferSize      230400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         5
        bmCapabilities                   0x01
          Still image supported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                 36495360
        dwMaxBitRate                 72990720
        dwMaxVideoFrameBufferSize      304128
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         6
        bmCapabilities                   0x01
          Still image supported
        wWidth                           1280
        wHeight                           720
        dwMinBitRate                331776000
        dwMaxBitRate                663552000
        dwMaxVideoFrameBufferSize     2764800
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                            34
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         7
        bmCapabilities                   0x01
          Still image supported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                110592000
        dwMaxBitRate                221184000
        dwMaxVideoFrameBufferSize      921600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  2
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            666666
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              4 HD WebCam
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              4 HD WebCam
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0c00  2x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              4 HD WebCam
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              4 HD WebCam
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            3.06
  iManufacturer           3 Linux 3.6.0-999-generic ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:1a.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             3
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0503 highspeed power enable connect
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            3.06
  iManufacturer           3 Linux 3.6.0-999-generic ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:1d.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             3
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0503 highspeed power enable connect
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         1 Single TT
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            3.06
  iManufacturer           3 Linux 3.6.0-999-generic xhci_hcd
  iProduct                2 xHCI Host Controller
  iSerial                 1 0000:00:14.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             4
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
    TT think time 8 FS bits
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0303 lowspeed power enable connect
   Port 2: 0000.0103 power enable connect
   Port 3: 0000.0100 power
   Port 4: 0000.0503 highspeed power enable connect
Device Status:     0x0001
  Self Powered

Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         3 
  bMaxPacketSize0         9
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0003 3.0 root hub
  bcdDevice            3.06
  iManufacturer           3 Linux 3.6.0-999-generic xhci_hcd
  iProduct                2 xHCI Host Controller
  iSerial                 1 0000:00:14.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           31
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
        bMaxBurst               0
Hub Descriptor:
  bLength              12
  bDescriptorType      42
  nNbrPorts             4
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  bHubDecLat          0.0 micro seconds
  wHubDelay             0 nano seconds
  DeviceRemovable    0x00
 Hub Port Status:
   Port 1: 0000.02a0 5Gbps power Rx.Detect
   Port 2: 0000.02a0 5Gbps power Rx.Detect
   Port 3: 0000.02a0 5Gbps power Rx.Detect
   Port 4: 0000.02a0 5Gbps power Rx.Detect
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength           15
  bNumDeviceCaps          1
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x00
      Latency Tolerance Messages (LTM) Supported
    wSpeedsSupported   0x0008
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   3
      Lowest fully-functional device speed is SuperSpeed (5Gbps)
    bU1DevExitLat          10 micro seconds
    bU2DevExitLat         512 micro seconds
Device Status:     0x0001
  Self Powered

--------------080401080402080303070304--

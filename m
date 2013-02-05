Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f54.google.com ([209.85.128.54]:52302 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab3BESgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 13:36:35 -0500
Received: by mail-qe0-f54.google.com with SMTP id 1so246385qeb.13
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 10:36:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOAX8-mMsXu5h-7q2EJEc9SehWS=yqAb4YvbfOVBQKhdH+LqTQ@mail.gmail.com>
References: <51102B22.20702@gmail.com>
	<CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com>
	<CAOAX8-mMsXu5h-7q2EJEc9SehWS=yqAb4YvbfOVBQKhdH+LqTQ@mail.gmail.com>
Date: Tue, 5 Feb 2013 19:36:34 +0100
Message-ID: <CAOAX8-kTqmL_pJFnn3UugMcjvLofjGb_JOBDVc1gvUXiFvN52w@mail.gmail.com> (sfid-20130205_193642_903025_E98C3CC9)
Subject: Fwd: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
From: Thomas Rosenkranz <tom.rosary@googlemail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---------- Forwarded message ----------
From: Thomas Rosenkranz <tom.rosary@googlemail.com>
Date: 2013/2/5
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
downstream and upstreamkernel
To: linux-wireless <linux-wireless@vger.kernel.org>



Am 05.02.2013 00:00 schrieb "Thomas Rosenkranz" <tom.rosary@googlemail.com>:


>
> btw. if I do:
> $ sudo modprobe -r 8192cu
> the system crashes
>
> In this case I did a kernel update and fresh installation of the realtek
> driver
>
> here some output
>
>> tommy@Tommy-AIO:~$ modinfo 8192cu | egrep 'versi|filen|819'
>> filename:
>> /lib/modules/3.2.0-37-generic/kernel/drivers/net/wireless/8192cu.ko
>> version:        v3.4.4_xxxx.20120730
>> srcversion:     FBF2DAF9D4C1BB74C28D37F
>> alias:          usb:v0BDAp8191d*dc*dsc*dp*ic*isc*ip*
>> vermagic:       3.2.0-37-generic SMP mod_unload modversions
>> parm:           rtw_chip_version:int
>>
>> tommy@Tommy-AIO:~$ echo 'install 8192cu modprobe --ignore-install 8192cu
>> ; /bin/echo "0bda 819a" > /sys/bus/usb/drivers/rtl8192cu/new_id' | sudo tee
>> /etc/modprobe.d/8192cu.conf
>>
>> install 8192cu modprobe --ignore-install 8192cu ; /bin/echo "0bda 819a" >
>> /sys/bus/usb/drivers/rtl8192cu/new_id
>>
>> tommy@Tommy-AIO:~$ sudo modprobe -v 8192cu
>> install modprobe --ignore-install 8192cu ; /bin/echo "0bda 819a" >
>> /sys/bus/usb/drivers/rtl8192cu/new_id
>> insmod
>> /lib/modules/3.2.0-37-generic/kernel/drivers/net/wireless/8192cu.ko
>>
>> tommy@Tommy-AIO:~$ dmesg
>> [    0.000000] Initializing cgroup subsys cpuset
>> [    0.000000] Initializing cgroup subsys cpu
>> [    0.000000] Linux version 3.2.0-37-generic (buildd@allspice) (gcc
>> version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #58-Ubuntu SMP Thu Jan 24
>> 15:28:10 UTC 2013 (Ubuntu 3.2.0-37.58-generic 3.2.35)
>> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.2.0-37-generic
>> root=UUID=ea1671bb-6d90-4e88-8808-5a5fc1bff71c ro nopat
>> crashkernel=384M-2G:64M,2G-:128M
>> resume=UUID=e4918e2d-1704-43a6-93c0-93235d39768e
>> [    0.000000] KERNEL supported cpus:
>> [    0.000000]   Intel GenuineIntel
>> [    0.000000]   AMD AuthenticAMD
>> [    0.000000]   Centaur CentaurHauls
>> [    0.000000] BIOS-provided physical RAM map:
>> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
>> [    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000de814000 (usable)
>> [    0.000000]  BIOS-e820: 00000000de814000 - 00000000dee13000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000dee13000 - 00000000df093000 (ACPI NVS)
>> [    0.000000]  BIOS-e820: 00000000df093000 - 00000000df098000 (ACPI
>> data)
>> [    0.000000]  BIOS-e820: 00000000df098000 - 00000000df0db000 (ACPI NVS)
>> [    0.000000]  BIOS-e820: 00000000df0db000 - 00000000df4ba000 (usable)
>> [    0.000000]  BIOS-e820: 00000000df4ba000 - 00000000df7f4000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000df7f4000 - 00000000df800000 (usable)
>> [    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed04000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>> [    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
>> [    0.000000]  BIOS-e820: 0000000100000000 - 000000021f000000 (usable)
>> [    0.000000] PAT support disabled.
>> [    0.000000] NX (Execute Disable) protection: active
>> [    0.000000] DMI 2.7 present.
>> [    0.000000] DMI: LENOVO Lenovo A720/ChiefRiver, BIOS E5KT20AUS
>> 03/26/2012
>> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000
>> (usable) ==> (reserved)
>> [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000
>> (usable)
>> [    0.000000] No AGP bridge found
>> [    0.000000] last_pfn = 0x21f000 max_arch_pfn = 0x400000000
>> [    0.000000] MTRR default type: uncachable
>> [    0.000000] MTRR fixed ranges enabled:
>> [    0.000000]   00000-9FFFF write-back
>> [    0.000000]   A0000-BFFFF uncachable
>> [    0.000000]   C0000-CFFFF write-protect
>> [    0.000000]   D0000-E7FFF uncachable
>> [    0.000000]   E8000-FFFFF write-protect
>> [    0.000000] MTRR variable ranges enabled:
>> [    0.000000]   0 base 000000000 mask E00000000 write-back
>> [    0.000000]   1 base 200000000 mask FF0000000 write-back
>> [    0.000000]   2 base 210000000 mask FF8000000 write-back
>> [    0.000000]   3 base 218000000 mask FFC000000 write-back
>> [    0.000000]   4 base 21C000000 mask FFE000000 write-back
>> [    0.000000]   5 base 21E000000 mask FFF000000 write-back
>> [    0.000000]   6 base 0E0000000 mask FE0000000 uncachable
>> [    0.000000]   7 disabled
>> [    0.000000]   8 disabled
>> [    0.000000]   9 disabled
>> [    0.000000] original variable MTRRs
>> [    0.000000] reg 0, base: 0GB, range: 8GB, type WB
>> [    0.000000] reg 1, base: 8GB, range: 256MB, type WB
>> [    0.000000] reg 2, base: 8448MB, range: 128MB, type WB
>> [    0.000000] reg 3, base: 8576MB, range: 64MB, type WB
>> [    0.000000] reg 4, base: 8640MB, range: 32MB, type WB
>> [    0.000000] reg 5, base: 8672MB, range: 16MB, type WB
>> [    0.000000] reg 6, base: 3584MB, range: 512MB, type UC
>> [    0.000000] total RAM covered: 8176M
>> [    0.000000] Found optimal setting for mtrr clean up
>> [    0.000000]  gran_size: 64K chunk_size: 32M num_reg: 6   lose cover
>> RAM: 0G
>> [    0.000000] New variable MTRRs
>> [    0.000000] reg 0, base: 0GB, range: 2GB, type WB
>> [    0.000000] reg 1, base: 2GB, range: 1GB, type WB
>> [    0.000000] reg 2, base: 3GB, range: 512MB, type WB
>> [    0.000000] reg 3, base: 4GB, range: 4GB, type WB
>> [    0.000000] reg 4, base: 8GB, range: 512MB, type WB
>> [    0.000000] reg 5, base: 8688MB, range: 16MB, type UC
>> [    0.000000] e820 update range: 00000000e0000000 - 0000000100000000
>> (usable) ==> (reserved)
>> [    0.000000] last_pfn = 0xdf800 max_arch_pfn = 0x400000000
>> [    0.000000] found SMP MP-table at [ffff8800000fcca0] fcca0
>> [    0.000000] initial memory mapped : 0 - 20000000
>> [    0.000000] Base memory trampoline at [ffff880000098000] 98000 size
>> 20480
>> [    0.000000] init_memory_mapping: 0000000000000000-00000000df800000
>> [    0.000000]  0000000000 - 00df800000 page 2M
>> [    0.000000] kernel direct mapping tables up to df800000 @
>> 1fffb000-20000000
>> [    0.000000] init_memory_mapping: 0000000100000000-000000021f000000
>> [    0.000000]  0100000000 - 021f000000 page 2M
>> [    0.000000] kernel direct mapping tables up to 21f000000 @
>> df7fa000-df800000
>> [    0.000000] RAMDISK: 358de000 - 36c67000
>> [    0.000000] Reserving 128MB of memory at 720MB for crashkernel (System
>> RAM: 8688MB)
>> [    0.000000] ACPI: RSDP 00000000000f0450 00024 (v02 LENOVO)
>> [    0.000000] ACPI: XSDT 00000000df047078 00074 (v01 LENOVO TC-03
>> 00000120 AMI  00010013)
>> [    0.000000] ACPI: FACP 00000000df04ff10 000F4 (v04 LENOVO TC-03
>> 00000120 AMI  00010013)
>> [    0.000000] ACPI: DSDT 00000000df047188 08D85 (v02 LENOVO TC-03
>> 00000120 INTL 20051117)
>> [    0.000000] ACPI: FACS 00000000df091f80 00040
>> [    0.000000] ACPI: APIC 00000000df050008 00092 (v03 LENOVO TC-03
>> 00000120 AMI  00010013)
>> [    0.000000] ACPI: ASF! 00000000df0500a0 000A5 (v32 LENOVO TC-03
>> 00000120 TFSM 000F4240)
>> [    0.000000] ACPI: MCFG 00000000df050148 0003C (v01 LENOVO TC-03
>> 00000120 MSFT 00000097)
>> [    0.000000] ACPI: SLIC 00000000df050188 00176 (v01 LENOVO TC-03
>> 00000120 AMI  00010013)
>> [    0.000000] ACPI: HPET 00000000df050300 00038 (v01 LENOVO TC-03
>> 00000120 AMI. 00000005)
>> [    0.000000] ACPI: SSDT 00000000df050338 0036D (v01 LENOVO TC-03
>> 00000120 INTL 20091112)
>> [    0.000000] ACPI: SSDT 00000000df0506a8 008E4 (v01 LENOVO TC-03
>> 00000120 INTL 20051117)
>> [    0.000000] ACPI: SSDT 00000000df050f90 00A92 (v01 LENOVO TC-03
>> 00000120 INTL 20051117)
>> [    0.000000] ACPI: SSDT 00000000df051a28 01392 (v01 LENOVO TC-03
>> 00000120 INTL 20091112)
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] No NUMA configuration found
>> [    0.000000] Faking a node at 0000000000000000-000000021f000000
>> [    0.000000] Initmem setup node 0 0000000000000000-000000021f000000
>> [    0.000000]   NODE_DATA [000000021effb000 - 000000021effffff]
>> [    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD ->
>> [ffff880216600000-ffff88021e5fffff] on node 0
>> [    0.000000] Zone PFN ranges:
>> [    0.000000]   DMA      0x00000010 -> 0x00001000
>> [    0.000000]   DMA32    0x00001000 -> 0x00100000
>> [    0.000000]   Normal   0x00100000 -> 0x0021f000
>> [    0.000000] Movable zone start PFN for each node
>> [    0.000000] early_node_map[5] active PFN ranges
>> [    0.000000]     0: 0x00000010 -> 0x0000009d
>> [    0.000000]     0: 0x00000100 -> 0x000de814
>> [    0.000000]     0: 0x000df0db -> 0x000df4ba
>> [    0.000000]     0: 0x000df7f4 -> 0x000df800
>> [    0.000000]     0: 0x00100000 -> 0x0021f000
>> [    0.000000] On node 0 totalpages: 2087820
>> [    0.000000]   DMA zone: 64 pages used for memmap
>> [    0.000000]   DMA zone: 5 pages reserved
>> [    0.000000]   DMA zone: 3912 pages, LIFO batch:0
>> [    0.000000]   DMA32 zone: 16320 pages used for memmap
>> [    0.000000]   DMA32 zone: 891967 pages, LIFO batch:31
>> [    0.000000]   Normal zone: 18368 pages used for memmap
>> [    0.000000]   Normal zone: 1157184 pages, LIFO batch:31
>> [    0.000000] ACPI: PM-Timer IO Port: 0x408
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
>> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
>> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI
>> 0-23
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high
>> level)
>> [    0.000000] ACPI: IRQ0 used by override.
>> [    0.000000] ACPI: IRQ2 used by override.
>> [    0.000000] ACPI: IRQ9 used by override.
>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>> [    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
>> [    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
>> [    0.000000] nr_irqs_gsi: 40
>> [    0.000000] PM: Registered nosave memory: 000000000009d000 -
>> 000000000009e000
>> [    0.000000] PM: Registered nosave memory: 000000000009e000 -
>> 00000000000a0000
>> [    0.000000] PM: Registered nosave memory: 00000000000a0000 -
>> 00000000000e0000
>> [    0.000000] PM: Registered nosave memory: 00000000000e0000 -
>> 0000000000100000
>> [    0.000000] PM: Registered nosave memory: 00000000de814000 -
>> 00000000dee13000
>> [    0.000000] PM: Registered nosave memory: 00000000dee13000 -
>> 00000000df093000
>> [    0.000000] PM: Registered nosave memory: 00000000df093000 -
>> 00000000df098000
>> [    0.000000] PM: Registered nosave memory: 00000000df098000 -
>> 00000000df0db000
>> [    0.000000] PM: Registered nosave memory: 00000000df4ba000 -
>> 00000000df7f4000
>> [    0.000000] PM: Registered nosave memory: 00000000df800000 -
>> 00000000f8000000
>> [    0.000000] PM: Registered nosave memory: 00000000f8000000 -
>> 00000000fc000000
>> [    0.000000] PM: Registered nosave memory: 00000000fc000000 -
>> 00000000fec00000
>> [    0.000000] PM: Registered nosave memory: 00000000fec00000 -
>> 00000000fec01000
>> [    0.000000] PM: Registered nosave memory: 00000000fec01000 -
>> 00000000fed00000
>> [    0.000000] PM: Registered nosave memory: 00000000fed00000 -
>> 00000000fed04000
>> [    0.000000] PM: Registered nosave memory: 00000000fed04000 -
>> 00000000fed1c000
>> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 -
>> 00000000fed20000
>> [    0.000000] PM: Registered nosave memory: 00000000fed20000 -
>> 00000000fee00000
>> [    0.000000] PM: Registered nosave memory: 00000000fee00000 -
>> 00000000fee01000
>> [    0.000000] PM: Registered nosave memory: 00000000fee01000 -
>> 00000000ff000000
>> [    0.000000] PM: Registered nosave memory: 00000000ff000000 -
>> 0000000100000000
>> [    0.000000] Allocating PCI resources starting at df800000 (gap:
>> df800000:18800000)
>> [    0.000000] Booting paravirtualized kernel on bare hardware
>> [    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8
>> nr_node_ids:1
>> [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88021ec00000 s83136
>> r8192 d23360 u262144
>> [    0.000000] pcpu-alloc: s83136 r8192 d23360 u262144 alloc=1*2097152
>> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
>> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
>> Total pages: 2053063
>> [    0.000000] Policy zone: Normal
>> [    0.000000] Kernel command line:
>> BOOT_IMAGE=/boot/vmlinuz-3.2.0-37-generic
>> root=UUID=ea1671bb-6d90-4e88-8808-5a5fc1bff71c ro nopat
>> crashkernel=384M-2G:64M,2G-:128M
>> resume=UUID=e4918e2d-1704-43a6-93c0-93235d39768e
>> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
>> [    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
>> [    0.000000] Checking aperture...
>> [    0.000000] No AGP bridge found
>> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
>> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA -
>> bailing!
>> [    0.000000] Memory: 7986328k/8896512k available (6569k kernel code,
>> 545232k absent, 364952k reserved, 6634k data, 924k init)
>> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
>> CPUs=8, Nodes=1
>> [    0.000000] Hierarchical RCU implementation.
>> [    0.000000] RCU dyntick-idle grace-period acceleration is enabled.
>> [    0.000000] NR_IRQS:16640 nr_irqs:744 16
>> [    0.000000] Extended CMOS year: 2000
>> [    0.000000] Console: colour VGA+ 80x25
>> [    0.000000] console [tty0] enabled
>> [    0.000000] allocated 67108864 bytes of page_cgroup
>> [    0.000000] please try 'cgroup_disable=memory' option if you don't
>> want memory cgroups
>> [    0.000000] hpet clockevent registered
>> [    0.000000] Fast TSC calibration using PIT
>> [    0.004000] Detected 2294.705 MHz processor.
>> [    0.000002] Calibrating delay loop (skipped), value calculated using
>> timer frequency.. 4589.41 BogoMIPS (lpj=9178820)
>> [    0.000165] pid_max: default: 32768 minimum: 301
>> [    0.000263] Security Framework initialized
>> [    0.000351] AppArmor: AppArmor initialized
>> [    0.000428] Yama: becoming mindful.
>> [    0.001026] Dentry cache hash table entries: 1048576 (order: 11,
>> 8388608 bytes)
>> [    0.003216] Inode-cache hash table entries: 524288 (order: 10, 4194304
>> bytes)
>> [    0.004225] Mount-cache hash table entries: 256
>> [    0.004396] Initializing cgroup subsys cpuacct
>> [    0.004478] Initializing cgroup subsys memory
>> [    0.004561] Initializing cgroup subsys devices
>> [    0.004641] Initializing cgroup subsys freezer
>> [    0.004719] Initializing cgroup subsys blkio
>> [    0.004799] Initializing cgroup subsys perf_event
>> [    0.004915] CPU: Physical Processor ID: 0
>> [    0.004991] CPU: Processor Core ID: 0
>> [    0.005072] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
>> [    0.005073] ENERGY_PERF_BIAS: View and update with
>> x86_energy_perf_policy(8)
>> [    0.005622] mce: CPU supports 9 MCE banks
>> [    0.005713] CPU0: Thermal monitoring enabled (TM1)
>> [    0.005799] using mwait in idle threads.
>> [    0.007913] ACPI: Core revision 20110623
>> [    0.013690] ftrace: allocating 27033 entries in 107 pages
>> [    0.022699] x2apic not enabled, IRQ remapping init failed
>> [    0.023186] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> [    0.062930] CPU0: Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz stepping
>> 09
>> [    0.168769] Performance Events: PEBS fmt1+, generic architected
>> perfmon, Intel PMU driver.
>> [    0.169021] ... version:                3
>> [    0.169095] ... bit width:              48
>> [    0.169169] ... generic registers:      4
>> [    0.169247] ... value mask:             0000ffffffffffff
>> [    0.169329] ... max period:             000000007fffffff
>> [    0.169406] ... fixed-purpose events:   3
>> [    0.169483] ... event mask:             000000070000000f
>> [    0.169693] NMI watchdog enabled, takes one hw-pmu counter.
>> [    0.169841] Booting Node   0, Processors  #1
>> [    0.169947] smpboot cpu 1: start_ip = 98000
>> [    0.281218] NMI watchdog enabled, takes one hw-pmu counter.
>> [    0.281371]  #2
>> [    0.281425] smpboot cpu 2: start_ip = 98000
>> [    0.389117] NMI watchdog enabled, takes one hw-pmu counter.
>> [    0.389265]  #3
>> [    0.389316] smpboot cpu 3: start_ip = 98000
>> [    0.497104] NMI watchdog enabled, takes one hw-pmu counter.
>> [    0.497254]  #4
>> [    0.497305] smpboot cpu 4: start_ip = 98000
>> [    0.604999] NMI watchdog enabled, takes one hw-pmu counter.
>> [    0.605164]  #5
>> [    0.605214] smpboot cpu 5: start_ip = 98000
>> [    0.720910] NMI watchdog enabled, takes one hw-pmu counter.
>> [    0.721061]  #6
>> [    0.721112] smpboot cpu 6: start_ip = 98000
>> [    0.828901] NMI watchdog enabled, takes one hw-pmu counter.
>> [    0.829051]  #7 Ok.
>> [    0.829123] smpboot cpu 7: start_ip = 98000
>> [    0.936847] NMI watchdog enabled, takes one hw-pmu counter.
>> [    0.936955] Brought up 8 CPUs
>> [    0.937030] Total of 8 processors activated (36715.02 BogoMIPS).
>> [    0.945300] devtmpfs: initialized
>> [    0.946151] EVM: security.selinux
>> [    0.946227] EVM: security.SMACK64
>> [    0.946302] EVM: security.capability
>> [    0.946395] PM: Registering ACPI NVS region at dee13000 (2621440
>> bytes)
>> [    0.946512] PM: Registering ACPI NVS region at df098000 (274432 bytes)
>> [    0.947316] print_constraints: dummy:
>> [    0.947421] RTC time: 23:42:55, date: 02/04/13
>> [    0.947525] NET: Registered protocol family 16
>> [    0.947687] Trying to unpack rootfs image as initramfs...
>> [    0.947691] ACPI FADT declares the system doesn't support PCIe ASPM,
>> so disable it
>> [    0.947693] ACPI: bus type pci registered
>> [    0.947752] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
>> 0xf8000000-0xfbffffff] (base 0xf8000000)
>> [    0.947755] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in
>> E820
>> [    0.954195] PCI: Using configuration type 1 for base access
>> [    0.955073] bio: create slab <bio-0> at 0
>> [    0.955214] ACPI: Added _OSI(Module Device)
>> [    0.955292] ACPI: Added _OSI(Processor Device)
>> [    0.955370] ACPI: Added _OSI(3.0 _SCP Extensions)
>> [    0.955451] ACPI: Added _OSI(Processor Aggregator Device)
>> [    0.956930] ACPI: EC: Look up EC in DSDT
>> [    0.958266] ACPI: Executed 1 blocks of module-level executable AML
>> code
>> [    1.025234] ACPI: SSDT 00000000dedbf018 0083B (v01  PmRef  Cpu0Cst
>> 00003001 INTL 20051117)
>> [    1.025787] ACPI: Dynamic OEM Table Load:
>> [    1.025958] ACPI: SSDT           (null) 0083B (v01  PmRef  Cpu0Cst
>> 00003001 INTL 20051117)
>> [    1.052476] ACPI: SSDT 00000000dedc0a98 00303 (v01  PmRef    ApIst
>> 00003000 INTL 20051117)
>> [    1.053055] ACPI: Dynamic OEM Table Load:
>> [    1.053227] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst
>> 00003000 INTL 20051117)
>> [    1.076341] ACPI: SSDT 00000000dedc2c18 00119 (v01  PmRef    ApCst
>> 00003000 INTL 20051117)
>> [    1.076888] ACPI: Dynamic OEM Table Load:
>> [    1.077058] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst
>> 00003000 INTL 20051117)
>> [    1.101281] ACPI: Interpreter enabled
>> [    1.101361] ACPI: (supports S0 S3 S4 S5)
>> [    1.101642] ACPI: Using IOAPIC for interrupt routing
>> [    1.106718] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data =
>> 0x62
>> [    1.106969] ACPI: No dock devices found.
>> [    1.107046] HEST: Table not found.
>> [    1.107124] PCI: Using host bridge windows from ACPI; if necessary,
>> use "pci=nocrs" and report a bug
>> [    1.107511] \_SB_.PCI0:_OSC invalid UUID
>> [    1.107512] _OSC request data:1 8 1f
>> [    1.107516] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
>> [    1.108026] pci_root PNP0A08:00: host bridge window [io
>> 0x0000-0x0cf7]
>> [    1.108110] pci_root PNP0A08:00: host bridge window [io
>> 0x0d00-0xffff]
>> [    1.108195] pci_root PNP0A08:00: host bridge window [mem
>> 0x000a0000-0x000bffff]
>> [    1.108304] pci_root PNP0A08:00: host bridge window [mem
>> 0x000d0000-0x000d3fff]
>> [    1.108410] pci_root PNP0A08:00: host bridge window [mem
>> 0x000d4000-0x000d7fff]
>> [    1.108517] pci_root PNP0A08:00: host bridge window [mem
>> 0x000d8000-0x000dbfff]
>> [    1.108622] pci_root PNP0A08:00: host bridge window [mem
>> 0x000dc000-0x000dffff]
>> [    1.108729] pci_root PNP0A08:00: host bridge window [mem
>> 0x000e0000-0x000e3fff]
>> [    1.108833] pci_root PNP0A08:00: host bridge window [mem
>> 0x000e4000-0x000e7fff]
>> [    1.108940] pci_root PNP0A08:00: host bridge window [mem
>> 0xe0000000-0xfeafffff]
>> [    1.109055] pci 0000:00:00.0: [8086:0154] type 0 class 0x000600
>> [    1.109092] pci 0000:00:01.0: [8086:0151] type 1 class 0x000604
>> [    1.109123] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
>> [    1.109126] pci 0000:00:01.0: PME# disabled
>> [    1.109167] pci 0000:00:14.0: [8086:1e31] type 0 class 0x000c03
>> [    1.109191] pci 0000:00:14.0: reg 10: [mem 0xf7d00000-0xf7d0ffff
>> 64bit]
>> [    1.109264] pci 0000:00:14.0: PME# supported from D3hot D3cold
>> [    1.109268] pci 0000:00:14.0: PME# disabled
>> [    1.109291] pci 0000:00:16.0: [8086:1e3a] type 0 class 0x000780
>> [    1.109315] pci 0000:00:16.0: reg 10: [mem 0xf7d1a000-0xf7d1a00f
>> 64bit]
>> [    1.109394] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
>> [    1.109398] pci 0000:00:16.0: PME# disabled
>> [    1.109430] pci 0000:00:1a.0: [8086:1e2d] type 0 class 0x000c03
>> [    1.109452] pci 0000:00:1a.0: reg 10: [mem 0xf7d18000-0xf7d183ff]
>> [    1.109544] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
>> [    1.109549] pci 0000:00:1a.0: PME# disabled
>> [    1.109575] pci 0000:00:1b.0: [8086:1e20] type 0 class 0x000403
>> [    1.109590] pci 0000:00:1b.0: reg 10: [mem 0xf7d10000-0xf7d13fff
>> 64bit]
>> [    1.109661] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
>> [    1.109665] pci 0000:00:1b.0: PME# disabled
>> [    1.109688] pci 0000:00:1c.0: [8086:1e10] type 1 class 0x000604
>> [    1.109769] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
>> [    1.109774] pci 0000:00:1c.0: PME# disabled
>> [    1.109798] pci 0000:00:1c.1: [8086:1e12] type 1 class 0x000604
>> [    1.109879] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
>> [    1.109883] pci 0000:00:1c.1: PME# disabled
>> [    1.109909] pci 0000:00:1c.2: [8086:1e14] type 1 class 0x000604
>> [    1.109989] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
>> [    1.109993] pci 0000:00:1c.2: PME# disabled
>> [    1.110027] pci 0000:00:1d.0: [8086:1e26] type 0 class 0x000c03
>> [    1.110049] pci 0000:00:1d.0: reg 10: [mem 0xf7d17000-0xf7d173ff]
>> [    1.110141] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
>> [    1.110146] pci 0000:00:1d.0: PME# disabled
>> [    1.110170] pci 0000:00:1f.0: [8086:1e59] type 0 class 0x000601
>> [    1.110296] pci 0000:00:1f.2: [8086:1e03] type 0 class 0x000106
>> [    1.110315] pci 0000:00:1f.2: reg 10: [io  0xf070-0xf077]
>> [    1.110324] pci 0000:00:1f.2: reg 14: [io  0xf060-0xf063]
>> [    1.110332] pci 0000:00:1f.2: reg 18: [io  0xf050-0xf057]
>> [    1.110341] pci 0000:00:1f.2: reg 1c: [io  0xf040-0xf043]
>> [    1.110349] pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
>> [    1.110358] pci 0000:00:1f.2: reg 24: [mem 0xf7d16000-0xf7d167ff]
>> [    1.110405] pci 0000:00:1f.2: PME# supported from D3hot
>> [    1.110409] pci 0000:00:1f.2: PME# disabled
>> [    1.110427] pci 0000:00:1f.3: [8086:1e22] type 0 class 0x000c05
>> [    1.110443] pci 0000:00:1f.3: reg 10: [mem 0xf7d15000-0xf7d150ff
>> 64bit]
>> [    1.110465] pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
>> [    1.110525] pci 0000:01:00.0: [10de:0de9] type 0 class 0x000300
>> [    1.110535] pci 0000:01:00.0: reg 10: [mem 0xf6000000-0xf6ffffff]
>> [    1.110546] pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit
>> pref]
>> [    1.110557] pci 0000:01:00.0: reg 1c: [mem 0xf0000000-0xf1ffffff 64bit
>> pref]
>> [    1.110565] pci 0000:01:00.0: reg 24: [io  0xe000-0xe07f]
>> [    1.110572] pci 0000:01:00.0: reg 30: [mem 0xf7000000-0xf707ffff pref]
>> [    1.110629] pci 0000:01:00.1: [10de:0bea] type 0 class 0x000403
>> [    1.110639] pci 0000:01:00.1: reg 10: [mem 0xf7080000-0xf7083fff]
>> [    1.116247] pci 0000:00:01.0: PCI bridge to [bus 01-01]
>> [    1.116330] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
>> [    1.116333] pci 0000:00:01.0:   bridge window [mem
>> 0xf6000000-0xf70fffff]
>> [    1.116336] pci 0000:00:01.0:   bridge window [mem
>> 0xe0000000-0xf1ffffff 64bit pref]
>> [    1.116408] pci 0000:02:00.0: [1131:7231] type 0 class 0x000480
>> [    1.116448] pci 0000:02:00.0: reg 10: [mem 0xf7800000-0xf7bfffff
>> 64bit]
>> [    1.116479] pci 0000:02:00.0: reg 18: [mem 0xf7400000-0xf77fffff
>> 64bit]
>> [    1.116646] pci 0000:02:00.0: supports D1 D2
>> [    1.116648] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot
>> [    1.116654] pci 0000:02:00.0: PME# disabled
>> [    1.124247] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
>> [    1.124334] pci 0000:00:1c.0:   bridge window [mem
>> 0xf7400000-0xf7bfffff]
>> [    1.124408] pci 0000:03:00.0: [10ec:8168] type 0 class 0x000200
>> [    1.124429] pci 0000:03:00.0: reg 10: [io  0xd000-0xd0ff]
>> [    1.124464] pci 0000:03:00.0: reg 18: [mem 0xf2104000-0xf2104fff 64bit
>> pref]
>> [    1.124487] pci 0000:03:00.0: reg 20: [mem 0xf2100000-0xf2103fff 64bit
>> pref]
>> [    1.124581] pci 0000:03:00.0: supports D1 D2
>> [    1.124583] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot
>> D3cold
>> [    1.124589] pci 0000:03:00.0: PME# disabled
>> [    1.132241] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
>> [    1.132326] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
>> [    1.132334] pci 0000:00:1c.1:   bridge window [mem
>> 0xf2100000-0xf21fffff 64bit pref]
>> [    1.132458] pci 0000:04:00.0: [10ec:5229] type 0 class 0x00ff00
>> [    1.132525] pci 0000:04:00.0: reg 10: [mem 0xf7c00000-0xf7c00fff]
>> [    1.133017] pci 0000:04:00.0: supports D1 D2
>> [    1.133019] pci 0000:04:00.0: PME# supported from D1 D2 D3hot
>> [    1.133030] pci 0000:04:00.0: PME# disabled
>> [    1.140261] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
>> [    1.140346] pci 0000:00:1c.2:   bridge window [mem
>> 0xf7c00000-0xf7cfffff]
>> [    1.140371] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>> [    1.140478] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
>> [    1.140507] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
>> [    1.140542] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
>> [    1.140577] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
>> [    1.140663] \_SB_.PCI0:_OSC invalid UUID
>> [    1.140664] _OSC request data:1 1f 1f
>> [    1.140668]  pci0000:00: Requesting ACPI _OSC control (0x1d)
>> [    1.140787] \_SB_.PCI0:_OSC invalid UUID
>> [    1.140788] _OSC request data:1 0 1d
>> [    1.140791]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned
>> control mask: 0x1d
>> [    1.140898] ACPI _OSC control for PCIe not granted, disabling ASPM
>> [    1.144339] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14
>> 15)
>> [    1.144976] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14
>> 15)
>> [    1.145610] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 14
>> 15)
>> [    1.146249] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14
>> 15)
>> [    1.146880] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14
>> 15) *0, disabled.
>> [    1.147623] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14
>> 15) *0, disabled.
>> [    1.148374] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14
>> 15)
>> [    1.149008] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14
>> 15)
>> [    1.149694] vgaarb: device added:
>> PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
>> [    1.149804] vgaarb: loaded
>> [    1.149878] vgaarb: bridge control possible 0000:01:00.0
>> [    1.150037] i2c-core: driver [aat2870] using legacy suspend method
>> [    1.150121] i2c-core: driver [aat2870] using legacy resume method
>> [    1.150254] SCSI subsystem initialized
>> [    1.150358] libata version 3.00 loaded.
>> [    1.150393] usbcore: registered new interface driver usbfs
>> [    1.150481] usbcore: registered new interface driver hub
>> [    1.150578] usbcore: registered new device driver usb
>> [    1.150719] PCI: Using ACPI for IRQ routing
>> [    1.152326] PCI: pci_cache_line_size set to 64 bytes
>> [    1.152415] reserve RAM buffer: 000000000009d800 - 000000000009ffff
>> [    1.152417] reserve RAM buffer: 00000000de814000 - 00000000dfffffff
>> [    1.152420] reserve RAM buffer: 00000000df4ba000 - 00000000dfffffff
>> [    1.152422] reserve RAM buffer: 00000000df800000 - 00000000dfffffff
>> [    1.152423] reserve RAM buffer: 000000021f000000 - 000000021fffffff
>> [    1.152503] NetLabel: Initializing
>> [    1.152576] NetLabel:  domain hash size = 128
>> [    1.152652] NetLabel:  protocols = UNLABELED CIPSOv4
>> [    1.152742] NetLabel:  unlabeled traffic allowed by default
>> [    1.152859] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
>> [    1.153363] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
>> [    1.155456] Switching to clocksource hpet
>> [    1.160455] AppArmor: AppArmor Filesystem Enabled
>> [    1.160550] pnp: PnP ACPI init
>> [    1.160632] ACPI: bus type pnp registered
>> [    1.160923] pnp 00:00: [bus 00-3e]
>> [    1.160925] pnp 00:00: [io  0x0000-0x0cf7 window]
>> [    1.160927] pnp 00:00: [io  0x0cf8-0x0cff]
>> [    1.160929] pnp 00:00: [io  0x0d00-0xffff window]
>> [    1.160931] pnp 00:00: [mem 0x000a0000-0x000bffff window]
>> [    1.160933] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
>> [    1.160934] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
>> [    1.160936] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
>> [    1.160938] pnp 00:00: [mem 0x000cc000-0x000cffff window]
>> [    1.160939] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
>> [    1.160941] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
>> [    1.160943] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
>> [    1.160944] pnp 00:00: [mem 0x000dc000-0x000dffff window]
>> [    1.160946] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
>> [    1.160948] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
>> [    1.160949] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
>> [    1.160951] pnp 00:00: [mem 0x000ec000-0x000effff window]
>> [    1.160953] pnp 00:00: [mem 0x000f0000-0x000fffff window]
>> [    1.160956] pnp 00:00: [mem 0xe0000000-0xfeafffff window]
>> [    1.160958] pnp 00:00: [mem 0x00010000-0x0001ffff window]
>> [    1.161010] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03
>> (active)
>> [    1.161030] pnp 00:01: [mem 0xfed40000-0xfed44fff]
>> [    1.161061] system 00:01: [mem 0xfed40000-0xfed44fff] has been
>> reserved
>> [    1.161143] system 00:01: Plug and Play ACPI device, IDs PNP0c01
>> (active)
>> [    1.161153] pnp 00:02: [io  0x0000-0x001f]
>> [    1.161154] pnp 00:02: [io  0x0081-0x0091]
>> [    1.161156] pnp 00:02: [io  0x0093-0x009f]
>> [    1.161157] pnp 00:02: [io  0x00c0-0x00df]
>> [    1.161159] pnp 00:02: [dma 4]
>> [    1.161177] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
>> [    1.161183] pnp 00:03: [mem 0xff000000-0xffffffff]
>> [    1.161199] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
>> [    1.161263] pnp 00:04: [mem 0xfed00000-0xfed003ff]
>> [    1.161280] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
>> [    1.161290] pnp 00:05: [io  0x002e-0x002f]
>> [    1.161291] pnp 00:05: [io  0x004e-0x004f]
>> [    1.161293] pnp 00:05: [io  0x0061]
>> [    1.161294] pnp 00:05: [io  0x0063]
>> [    1.161295] pnp 00:05: [io  0x0065]
>> [    1.161297] pnp 00:05: [io  0x0067]
>> [    1.161298] pnp 00:05: [io  0x0070]
>> [    1.161299] pnp 00:05: [io  0x0080]
>> [    1.161301] pnp 00:05: [io  0x0092]
>> [    1.161302] pnp 00:05: [io  0x00b2-0x00b3]
>> [    1.161303] pnp 00:05: [io  0x0680-0x069f]
>> [    1.161305] pnp 00:05: [io  0x0200-0x020f]
>> [    1.161306] pnp 00:05: [io  0xffff]
>> [    1.161308] pnp 00:05: [io  0xffff]
>> [    1.161309] pnp 00:05: [io  0x0400-0x0453]
>> [    1.161310] pnp 00:05: [io  0x0458-0x047f]
>> [    1.161312] pnp 00:05: [io  0x0500-0x057f]
>> [    1.161313] pnp 00:05: [io  0x164e-0x164f]
>> [    1.161346] system 00:05: [io  0x0680-0x069f] has been reserved
>> [    1.161429] system 00:05: [io  0x0200-0x020f] has been reserved
>> [    1.161512] system 00:05: [io  0xffff] has been reserved
>> [    1.161593] system 00:05: [io  0xffff] has been reserved
>> [    1.161675] system 00:05: [io  0x0400-0x0453] has been reserved
>> [    1.161758] system 00:05: [io  0x0458-0x047f] has been reserved
>> [    1.161841] system 00:05: [io  0x0500-0x057f] has been reserved
>> [    1.161924] system 00:05: [io  0x164e-0x164f] has been reserved
>> [    1.162008] system 00:05: Plug and Play ACPI device, IDs PNP0c02
>> (active)
>> [    1.162015] pnp 00:06: [io  0x0070-0x0077]
>> [    1.162023] pnp 00:06: [irq 8]
>> [    1.162042] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
>> [    1.162063] pnp 00:07: [io  0x0454-0x0457]
>> [    1.162092] system 00:07: [io  0x0454-0x0457] has been reserved
>> [    1.162176] system 00:07: Plug and Play ACPI device, IDs INT3f0d
>> PNP0c02 (active)
>> [    1.162193] pnp 00:08: [io  0x0010-0x001f]
>> [    1.162195] pnp 00:08: [io  0x0022-0x003f]
>> [    1.162196] pnp 00:08: [io  0x0044-0x005f]
>> [    1.162198] pnp 00:08: [io  0x0072-0x007f]
>> [    1.162199] pnp 00:08: [io  0x0080]
>> [    1.162201] pnp 00:08: [io  0x0084-0x0086]
>> [    1.162202] pnp 00:08: [io  0x0088]
>> [    1.162203] pnp 00:08: [io  0x008c-0x008e]
>> [    1.162205] pnp 00:08: [io  0x0090-0x009f]
>> [    1.162206] pnp 00:08: [io  0x00a2-0x00bf]
>> [    1.162208] pnp 00:08: [io  0x00e0-0x00ef]
>> [    1.162210] pnp 00:08: [io  0x04d0-0x04d1]
>> [    1.162240] system 00:08: [io  0x04d0-0x04d1] has been reserved
>> [    1.162322] system 00:08: Plug and Play ACPI device, IDs PNP0c02
>> (active)
>> [    1.162329] pnp 00:09: [io  0x00f0-0x00ff]
>> [    1.162334] pnp 00:09: [irq 13]
>> [    1.162353] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
>> [    1.162543] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
>> [    1.162545] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
>> [    1.162546] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
>> [    1.162548] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
>> [    1.162549] pnp 00:0a: [mem 0xf8000000-0xfbffffff]
>> [    1.162551] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
>> [    1.162552] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
>> [    1.162554] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
>> [    1.162555] pnp 00:0a: [mem 0xff000000-0xffffffff]
>> [    1.162557] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
>> [    1.162558] pnp 00:0a: [mem 0xf2200000-0xf2200fff]
>> [    1.162609] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been
>> reserved
>> [    1.162695] system 00:0a: [mem 0xfed10000-0xfed17fff] has been
>> reserved
>> [    1.162780] system 00:0a: [mem 0xfed18000-0xfed18fff] has been
>> reserved
>> [    1.162863] system 00:0a: [mem 0xfed19000-0xfed19fff] has been
>> reserved
>> [    1.162947] system 00:0a: [mem 0xf8000000-0xfbffffff] has been
>> reserved
>> [    1.163032] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been
>> reserved
>> [    1.163117] system 00:0a: [mem 0xfed90000-0xfed93fff] has been
>> reserved
>> [    1.163199] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been
>> reserved
>> [    1.163285] system 00:0a: [mem 0xff000000-0xffffffff] has been
>> reserved
>> [    1.163369] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be
>> reserved
>> [    1.163453] system 00:0a: [mem 0xf2200000-0xf2200fff] has been
>> reserved
>> [    1.163548] system 00:0a: Plug and Play ACPI device, IDs PNP0c02
>> (active)
>> [    1.163664] pnp: PnP ACPI: found 11 devices
>> [    1.163743] ACPI: ACPI bus type pnp unregistered
>> [    1.170051] PCI: max bus depth: 1 pci_try_num: 2
>> [    1.170081] pci 0000:00:01.0: PCI bridge to [bus 01-01]
>> [    1.170164] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
>> [    1.170249] pci 0000:00:01.0:   bridge window [mem
>> 0xf6000000-0xf70fffff]
>> [    1.170334] pci 0000:00:01.0:   bridge window [mem
>> 0xe0000000-0xf1ffffff 64bit pref]
>> [    1.170442] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
>> [    1.170525] pci 0000:00:1c.0:   bridge window [mem
>> 0xf7400000-0xf7bfffff]
>> [    1.170616] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
>> [    1.170697] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
>> [    1.170787] pci 0000:00:1c.1:   bridge window [mem
>> 0xf2100000-0xf21fffff 64bit pref]
>> [    1.170897] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
>> [    1.170982] pci 0000:00:1c.2:   bridge window [mem
>> 0xf7c00000-0xf7cfffff]
>> [    1.171082] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ
>> 16
>> [    1.171168] pci 0000:00:01.0: setting latency timer to 64
>> [    1.171175] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ
>> 16
>> [    1.171262] pci 0000:00:1c.0: setting latency timer to 64
>> [    1.171272] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ
>> 17
>> [    1.171360] pci 0000:00:1c.1: setting latency timer to 64
>> [    1.171368] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ
>> 18
>> [    1.171456] pci 0000:00:1c.2: setting latency timer to 64
>> [    1.171460] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
>> [    1.171462] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
>> [    1.171464] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
>> [    1.171466] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
>> [    1.171468] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
>> [    1.171469] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
>> [    1.171471] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
>> [    1.171473] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
>> [    1.171475] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
>> [    1.171477] pci_bus 0000:00: resource 13 [mem 0xe0000000-0xfeafffff]
>> [    1.171479] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
>> [    1.171480] pci_bus 0000:01: resource 1 [mem 0xf6000000-0xf70fffff]
>> [    1.171482] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xf1ffffff
>> 64bit pref]
>> [    1.171485] pci_bus 0000:02: resource 1 [mem 0xf7400000-0xf7bfffff]
>> [    1.171486] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
>> [    1.171488] pci_bus 0000:03: resource 2 [mem 0xf2100000-0xf21fffff
>> 64bit pref]
>> [    1.171490] pci_bus 0000:04: resource 1 [mem 0xf7c00000-0xf7cfffff]
>> [    1.171517] NET: Registered protocol family 2
>> [    1.171757] IP route cache hash table entries: 262144 (order: 9,
>> 2097152 bytes)
>> [    1.172505] TCP established hash table entries: 524288 (order: 11,
>> 8388608 bytes)
>> [    1.173635] TCP bind hash table entries: 65536 (order: 8, 1048576
>> bytes)
>> [    1.173834] TCP: Hash tables configured (established 524288 bind
>> 65536)
>> [    1.173918] TCP reno registered
>> [    1.174005] UDP hash table entries: 4096 (order: 5, 131072 bytes)
>> [    1.174115] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
>> [    1.174271] NET: Registered protocol family 1
>> [    1.174368] pci 0000:00:14.0: PCI INT A -> GSI 16 (level, low) -> IRQ
>> 16
>> [    1.176759] pci 0000:00:14.0: PCI INT A disabled
>> [    1.176850] pci 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ
>> 16
>> [    1.195532] pci 0000:00:1a.0: PCI INT A disabled
>> [    1.195635] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ
>> 23
>> [    1.215518] pci 0000:00:1d.0: PCI INT A disabled
>> [    1.215619] pci 0000:01:00.0: Boot video device
>> [    1.215644] PCI: CLS 64 bytes, default 64
>> [    1.215646] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>> [    1.215731] Placing 64MB software IO TLB between ffff8800da814000 -
>> ffff8800de814000
>> [    1.215839] software IO TLB at phys 0xda814000 - 0xde814000
>> [    1.216458] audit: initializing netlink socket (disabled)
>> [    1.216546] type=2000 audit(1360021374.988:1): initialized
>> [    1.239450] HugeTLB registered 2 MB page size, pre-allocated 0 pages
>> [    1.241242] VFS: Disk quotas dquot_6.5.2
>> [    1.241358] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
>> [    1.241813] fuse init (API version 7.17)
>> [    1.241957] msgmni has been set to 15598
>> [    1.247432] Block layer SCSI generic (bsg) driver version 0.4 loaded
>> (major 253)
>> [    1.247570] io scheduler noop registered
>> [    1.247649] io scheduler deadline registered
>> [    1.247752] io scheduler cfq registered (default)
>> [    1.247897] pcieport 0000:00:01.0: setting latency timer to 64
>> [    1.247920] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
>> [    1.248096] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>> [    1.248193] pciehp: PCI Express Hot Plug Controller Driver version:
>> 0.4
>> [    1.248315] intel_idle: MWAIT substates: 0x21120
>> [    1.248317] intel_idle: v0.4 model 0x3A
>> [    1.248318] intel_idle: lapic_timer_reliable_states 0xffffffff
>> [    1.248411] input: Power Button as
>> /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
>> [    1.248522] ACPI: Power Button [PWRB]
>> [    1.248629] input: Power Button as
>> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
>> [    1.248737] ACPI: Power Button [PWRF]
>> [    1.250745] thermal LNXTHERM:00: registered as thermal_zone0
>> [    1.250829] ACPI: Thermal Zone [TZ00] (47 C)
>> [    1.252228] thermal LNXTHERM:01: registered as thermal_zone1
>> [    1.252311] ACPI: Thermal Zone [TZ01] (47 C)
>> [    1.252423] ERST: Table is not found!
>> [    1.252500] GHES: HEST is not enabled!
>> [    1.252629] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
>> [    1.286853] Freeing initrd memory: 20004k freed
>> [    1.463851] Linux agpgart interface v0.103
>> [    1.465049] brd: module loaded
>> [    1.465671] loop: module loaded
>> [    1.465837] ahci 0000:00:1f.2: version 3.0
>> [    1.465855] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ
>> 19
>> [    1.465987] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
>> [    1.479415] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps
>> 0x7 impl SATA mode
>> [    1.479524] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum
>> part ems apst
>> [    1.479634] ahci 0000:00:1f.2: setting latency timer to 64
>> [    1.495756] scsi0 : ahci
>> [    1.495898] scsi1 : ahci
>> [    1.496026] scsi2 : ahci
>> [    1.496154] scsi3 : ahci
>> [    1.496282] scsi4 : ahci
>> [    1.496409] scsi5 : ahci
>> [    1.496734] ata1: SATA max UDMA/133 abar m2048@0xf7d16000 port
>> 0xf7d16100 irq 41
>> [    1.496840] ata2: SATA max UDMA/133 abar m2048@0xf7d16000 port
>> 0xf7d16180 irq 41
>> [    1.496948] ata3: SATA max UDMA/133 abar m2048@0xf7d16000 port
>> 0xf7d16200 irq 41
>> [    1.497054] ata4: DUMMY
>> [    1.497127] ata5: DUMMY
>> [    1.497200] ata6: DUMMY
>> [    1.497530] Fixed MDIO Bus: probed
>> [    1.497619] tun: Universal TUN/TAP device driver, 1.6
>> [    1.497700] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
>> [    1.497818] PPP generic driver version 2.4.2
>> [    1.497968] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>> [    1.498065] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) ->
>> IRQ 16
>> [    1.498163] ehci_hcd 0000:00:1a.0: setting latency timer to 64
>> [    1.498167] ehci_hcd 0000:00:1a.0: EHCI Host Controller
>> [    1.498281] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned
>> bus number 1
>> [    1.498412] ehci_hcd 0000:00:1a.0: debug port 2
>> [    1.502387] ehci_hcd 0000:00:1a.0: cache line size of 64 is not
>> supported
>> [    1.502401] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7d18000
>> [    1.515368] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
>> [    1.515557] hub 1-0:1.0: USB hub found
>> [    1.515637] hub 1-0:1.0: 2 ports detected
>> [    1.515762] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) ->
>> IRQ 23
>> [    1.515859] ehci_hcd 0000:00:1d.0: setting latency timer to 64
>> [    1.515863] ehci_hcd 0000:00:1d.0: EHCI Host Controller
>> [    1.515977] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned
>> bus number 2
>> [    1.516102] ehci_hcd 0000:00:1d.0: debug port 2
>> [    1.520076] ehci_hcd 0000:00:1d.0: cache line size of 64 is not
>> supported
>> [    1.520089] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7d17000
>> [    1.535358] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
>> [    1.535536] hub 2-0:1.0: USB hub found
>> [    1.535614] hub 2-0:1.0: 2 ports detected
>> [    1.535735] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>> [    1.535826] uhci_hcd: USB Universal Host Controller Interface driver
>> [    1.535931] xhci_hcd 0000:00:14.0: PCI INT A -> GSI 16 (level, low) ->
>> IRQ 16
>> [    1.536035] xhci_hcd 0000:00:14.0: setting latency timer to 64
>> [    1.536039] xhci_hcd 0000:00:14.0: xHCI Host Controller
>> [    1.536155] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
>> bus number 3
>> [    1.536344] xhci_hcd 0000:00:14.0: cache line size of 64 is not
>> supported
>> [    1.536348] xhci_hcd 0000:00:14.0: irq 16, io mem 0xf7d00000
>> [    1.536470] xhci_hcd 0000:00:14.0: irq 42 for MSI/MSI-X
>> [    1.536562] xHCI xhci_add_endpoint called for root hub
>> [    1.536563] xHCI xhci_check_bandwidth called for root hub
>> [    1.536582] hub 3-0:1.0: USB hub found
>> [    1.536665] hub 3-0:1.0: 4 ports detected
>> [    1.536785] xhci_hcd 0000:00:14.0: xHCI Host Controller
>> [    1.536896] xhci_hcd 0000:00:14.0: new USB bus registered, assigned
>> bus number 4
>> [    1.537061] xHCI xhci_add_endpoint called for root hub
>> [    1.537063] xHCI xhci_check_bandwidth called for root hub
>> [    1.537080] hub 4-0:1.0: USB hub found
>> [    1.537162] hub 4-0:1.0: 4 ports detected
>> [    1.599365] usbcore: registered new interface driver libusual
>> [    1.599477] i8042: PNP: No PS/2 controller found. Probing ports
>> directly.
>> [    1.602881] serio: i8042 KBD port at 0x60,0x64 irq 1
>> [    1.602966] serio: i8042 AUX port at 0x60,0x64 irq 12
>> [    1.603144] mousedev: PS/2 mouse device common for all mice
>> [    1.603347] rtc_cmos 00:06: RTC can wake from S4
>> [    1.603530] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
>> [    1.603640] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet
>> irqs
>> [    1.603782] device-mapper: uevent: version 1.0.3
>> [    1.603911] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19)
>> initialised: dm-devel@redhat.com
>> [    1.604202] cpuidle: using governor ladder
>> [    1.604567] cpuidle: using governor menu
>> [    1.604644] EFI Variables Facility v0.08 2004-May-17
>> [    1.604880] TCP cubic registered
>> [    1.605026] NET: Registered protocol family 10
>> [    1.605419] NET: Registered protocol family 17
>> [    1.605501] Registering the dns_resolver key type
>> [    1.605697] PM: Checking hibernation image partition
>> UUID=e4918e2d-1704-43a6-93c0-93235d39768e
>> [    1.610263] input: AT Translated Set 2 keyboard as
>> /devices/platform/i8042/serio0/input/input2
>> [    1.815251] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [    1.815355] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [    1.820291] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
>> succeeded
>> [    1.820295] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
>> LOCK) filtered out
>> [    1.820405] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
>> CONFIGURATION OVERLAY) filtered out
>> [    1.823244] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
>> [    1.823835] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
>> succeeded
>> [    1.823839] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
>> LOCK) filtered out
>> [    1.823949] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
>> CONFIGURATION OVERLAY) filtered out
>> [    1.824480] ata2.00: ATA-9: M4-CT128M4SSD3, 04MH, max UDMA/100
>> [    1.824566] ata2.00: 250069680 sectors, multi 16: LBA48 NCQ (depth
>> 31/32), AA
>> [    1.825286] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
>> succeeded
>> [    1.825290] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
>> LOCK) filtered out
>> [    1.825405] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
>> CONFIGURATION OVERLAY) filtered out
>> [    1.825521] ata1.00: ATA-8: WDC WD7500BPVT-24HXZT3, 03.01A03, max
>> UDMA/133
>> [    1.825611] ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth
>> 31/32), AA
>> [    1.825955] ata2.00: configured for UDMA/100
>> [    1.827234] usb 1-1: new high-speed USB device number 2 using ehci_hcd
>> [    1.827539] ata3.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
>> succeeded
>> [    1.827545] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
>> LOCK) filtered out
>> [    1.827654] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
>> CONFIGURATION OVERLAY) filtered out
>> [    1.830173] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
>> succeeded
>> [    1.830176] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
>> LOCK) filtered out
>> [    1.830281] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
>> CONFIGURATION OVERLAY) filtered out
>> [    1.830395] ata3.00: ATAPI: HL-DT-ST BDDVDRW CA30N, QD01, max UDMA/133
>> [    1.835436] ata1.00: configured for UDMA/133
>> [    1.835518] ata3.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
>> succeeded
>> [    1.835522] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
>> LOCK) filtered out
>> [    1.835634] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
>> CONFIGURATION OVERLAY) filtered out
>> [    1.835667] scsi 0:0:0:0: Direct-Access     ATA      WDC WD7500BPVT-2
>> 03.0 PQ: 0 ANSI: 5
>> [    1.835868] sd 0:0:0:0: Attached scsi generic sg0 type 0
>> [    1.835973] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750
>> GB/698 GiB)
>> [    1.836080] sd 0:0:0:0: [sda] 4096-byte physical blocks
>> [    1.836232] scsi 1:0:0:0: Direct-Access     ATA      M4-CT128M4SSD3
>> 04MH PQ: 0 ANSI: 5
>> [    1.836409] sd 0:0:0:0: [sda] Write Protect is off
>> [    1.836473] sd 1:0:0:0: [sdb] 250069680 512-byte logical blocks: (128
>> GB/119 GiB)
>> [    1.836505] sd 1:0:0:0: Attached scsi generic sg1 type 0
>> [    1.836522] sd 1:0:0:0: [sdb] Write Protect is off
>> [    1.836524] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>> [    1.836538] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
>> enabled, doesn't support DPO or FUA
>> [    1.836875] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [    1.836975] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
>> enabled, doesn't support DPO or FUA
>> [    1.837092]  sdb: sdb1 sdb2 sdb3
>> [    1.837633] sd 1:0:0:0: [sdb] Attached SCSI disk
>> [    1.838349] ata3.00: configured for UDMA/133
>> [    1.841874] scsi 2:0:0:0: CD-ROM            HL-DT-ST BDDVDRW CA30N
>> QD01 PQ: 0 ANSI: 5
>> [    1.845428] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
>> xa/form2 cdda tray
>> [    1.845534] cdrom: Uniform CD-ROM driver Revision: 3.20
>> [    1.845742] sr 2:0:0:0: Attached scsi CD-ROM sr0
>> [    1.845833] sr 2:0:0:0: Attached scsi generic sg2 type 5
>> [    1.866172]  sda: sda1 sda2 sda3
>> [    1.867065] sd 0:0:0:0: [sda] Attached SCSI disk
>> [    1.867187] PM: Hibernation image not present or could not be loaded.
>> [    1.867208] registered taskstats version 1
>> [    1.874616]   Magic number: 1:400:756
>> [    1.874707] tty ttyS7: hash matches
>> [    1.874880] rtc_cmos 00:06: setting system clock to 2013-02-04
>> 23:42:56 UTC (1360021376)
>> [    1.876190] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
>> [    1.876271] EDD information not available.
>> [    1.877445] Freeing unused kernel memory: 924k freed
>> [    1.877601] Write protecting the kernel read-only data: 12288k
>> [    1.880792] Freeing unused kernel memory: 1604k freed
>> [    1.883430] Freeing unused kernel memory: 1196k freed
>> [    1.895080] udevd[126]: starting version 175
>> [    1.906173] acpi device:1a: registered as cooling_device8
>> [    1.906321] input: Video Bus as
>> /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:18/LNXVIDEO:00/input/input3
>> [    1.912851] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post:
>> no)
>> [    1.915835] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
>> [    1.915950] r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) ->
>> IRQ 17
>> [    1.916090] r8169 0000:03:00.0: setting latency timer to 64
>> [    1.916181] r8169 0000:03:00.0: irq 43 for MSI/MSI-X
>> [    1.916573] r8169 0000:03:00.0: eth0: RTL8168evl/8111evl at
>> 0xffffc90000c7e000, 04:7d:7b:b5:bd:c0, XID 0c900800 IRQ 43
>> [    1.916696] r8169 0000:03:00.0: eth0: jumbo features [frames: 9200
>> bytes, tx checksumming: ko]
>> [    1.959812] hub 1-1:1.0: USB hub found
>> [    1.960028] hub 1-1:1.0: 6 ports detected
>> [    2.071100] usb 2-1: new high-speed USB device number 2 using ehci_hcd
>> [    2.203683] hub 2-1:1.0: USB hub found
>> [    2.203906] hub 2-1:1.0: 6 ports detected
>> [    2.215026] Refined TSC clocksource calibration: 2294.785 MHz.
>> [    2.215122] Switching to clocksource tsc
>> [    2.370949] usb 3-3: new full-speed USB device number 2 using xhci_hcd
>> [    2.394165] usbcore: registered new interface driver usbhid
>> [    2.394247] usbhid: USB HID core driver
>> [    2.399686] logitech-djreceiver 0003:046D:C52B.0003: hiddev0,hidraw0:
>> USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:14.0-3/input2
>> [    2.403088] input: Logitech Unifying Device. Wireless PID:4017 as
>> /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3:1.2/0003:046D:C52B.0003/input/input4
>> [    2.403385] logitech-djdevice 0003:046D:C52B.0004: input,hidraw1: USB
>> HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:4017] on
>> usb-0000:00:14.0-3:1
>> [    2.463079] usb 1-1.1: new full-speed USB device number 3 using
>> ehci_hcd
>> [    2.557502] hub 1-1.1:1.0: USB hub found
>> [    2.557717] hub 1-1.1:1.0: 3 ports detected
>> [    2.626984] usb 1-1.2: new full-speed USB device number 4 using
>> ehci_hcd
>> [    2.725180] generic-usb 0003:2619:5610.0006: hiddev0,hidraw2: USB HID
>> v1.10 Device [Advanced Silicon S.A.                  CoolTouch(TM) System
>> ] on usb-0000:00:1a.0-1.2/input1
>> [    2.794902] usb 1-1.4: new high-speed USB device number 5 using
>> ehci_hcd
>> [    2.958827] usb 1-1.5: new high-speed USB device number 6 using
>> ehci_hcd
>> [    3.122716] usb 2-1.5: new full-speed USB device number 3 using
>> ehci_hcd
>> [    3.222338] input: Lite-On Technology Corp. Lenovo silver silk
>> (wireless) 2.4G K&M kit as
>> /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/input/input5
>> [    3.222579] generic-usb 0003:17EF:6032.0007: input,hidraw3: USB HID
>> v1.11 Keyboard [Lite-On Technology Corp. Lenovo silver silk (wireless) 2.4G
>> K&M kit] on usb-0000:00:1d.0-1.5/input0
>> [    3.227523] input: Lite-On Technology Corp. Lenovo silver silk
>> (wireless) 2.4G K&M kit as
>> /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.1/input/input6
>> [    3.227815] generic-usb 0003:17EF:6032.0008: input,hiddev0,hidraw4:
>> USB HID v1.11 Device [Lite-On Technology Corp. Lenovo silver silk (wireless)
>> 2.4G K&M kit] on usb-0000:00:1d.0-1.5/input1
>> [    3.229667] input: Lite-On Technology Corp. Lenovo silver silk
>> (wireless) 2.4G K&M kit as
>> /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.2/input/input7
>> [    3.229920] generic-usb 0003:17EF:6032.0009: input,hidraw5: USB HID
>> v1.11 Mouse [Lite-On Technology Corp. Lenovo silver silk (wireless) 2.4G K&M
>> kit] on usb-0000:00:1d.0-1.5/input2
>> [    3.302629] usb 1-1.1.1: new full-speed USB device number 7 using
>> ehci_hcd
>> [    3.399736] input: HID 0a5c:4502 as
>> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/input/input8
>> [    3.399964] generic-usb 0003:0A5C:4502.000A: input,hidraw6: USB HID
>> v1.11 Keyboard [HID 0a5c:4502] on usb-0000:00:1a.0-1.1.1/input0
>> [    3.470563] usb 1-1.1.2: new full-speed USB device number 8 using
>> ehci_hcd
>> [    3.568652] input: HID 0a5c:4503 as
>> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.1/1-1.1.2/1-1.1.2:1.0/input/input9
>> [    3.568876] generic-usb 0003:0A5C:4503.000B: input,hidraw7: USB HID
>> v1.11 Mouse [HID 0a5c:4503] on usb-0000:00:1a.0-1.1.2/input0
>> [    3.638426] usb 1-1.1.3: new full-speed USB device number 9 using
>> ehci_hcd
>> [    3.734597] EXT4-fs (sdb3): INFO: recovery required on readonly
>> filesystem
>> [    3.734621] EXT4-fs (sdb3): write access will be enabled during
>> recovery
>> [    3.735745] EXT4-fs (sdb3): recovery complete
>> [    3.735809] EXT4-fs (sdb3): mounted filesystem with ordered data mode.
>> Opts: (null)
>> [    4.120836] Adding 8396796k swap on /dev/sdb2.  Priority:-1 extents:1
>> across:8396796k SS
>> [    4.155028] ADDRCONF(NETDEV_UP): eth0: link is not ready
>> [    4.163108] udevd[406]: starting version 175
>> [    4.194110] lp: driver loaded but no devices found
>> [    4.235163] EXT4-fs (sdb3): re-mounted. Opts: errors=remount-ro
>> [    4.245271] wmi: Mapper loaded
>> [    4.254460] mei: module is from the staging directory, the quality is
>> unknown, you have been warned.
>> [    4.254733] mei 0000:00:16.0: PCI INT A -> GSI 16 (level, low) -> IRQ
>> 16
>> [    4.254739] mei 0000:00:16.0: setting latency timer to 64
>> [    4.254795] mei 0000:00:16.0: irq 44 for MSI/MSI-X
>> [    4.304140] nvidia: module license 'NVIDIA' taints kernel.
>> [    4.304143] Disabling lock debugging due to kernel taint
>> [    4.306802] Bluetooth: Core ver 2.16
>> [    4.308532] NET: Registered protocol family 31
>> [    4.308536] Bluetooth: HCI device and connection manager initialized
>> [    4.308539] Bluetooth: HCI socket layer initialized
>> [    4.308541] Bluetooth: L2CAP socket layer initialized
>> [    4.308548] Bluetooth: SCO socket layer initialized
>> [    4.333110] input: Advanced Silicon S.A.
>> CoolTouch(TM) System                   as
>> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input10
>> [    4.333328] hid-multitouch 0003:2619:5610.0005: input,hidraw8: USB HID
>> v1.10 Device [Advanced Silicon S.A.                  CoolTouch(TM) System
>> ] on usb-0000:00:1a.0-1.2/input0
>> [    4.337521] Linux video capture interface: v2.00
>> [    4.340386] Bluetooth: Generic Bluetooth USB driver ver 0.6
>> [    4.341558] nvidia 0000:01:00.0: power state changed by ACPI to D0
>> [    4.341571] nvidia 0000:01:00.0: power state changed by ACPI to D0
>> [    4.341601] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) ->
>> IRQ 16
>> [    4.341621] nvidia 0000:01:00.0: setting latency timer to 64
>> [    4.341632] vgaarb: device changed decodes:
>> PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
>> [    4.341772] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  310.14
>> Tue Oct  9 11:52:41 PDT 2012
>> [    4.343377] uvcvideo: Found UVC 1.00 device Lenovo H264 720P Camera
>> (17ef:4820)
>> [    4.344083] usbcore: registered new interface driver btusb
>> [    4.344086] uvcvideo: No streaming interface found for terminal 9.
>> [    4.344134] input: Lenovo H264 720P Camera as
>> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input11
>> [    4.344200] usbcore: registered new interface driver uvcvideo
>> [    4.344202] USB Video Class driver (1.1.1)
>> [    4.380336] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
>> low) -> IRQ 22
>> [    4.380382] snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
>> [    4.380406] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
>> [    4.425111] input: HDA Intel PCH Mic as
>> /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
>> [    4.425198] input: HDA Intel PCH Headphone as
>> /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
>> [    4.425373] snd_hda_intel 0000:01:00.1: PCI INT B -> GSI 17 (level,
>> low) -> IRQ 17
>> [    4.425375] hda_intel: Disabling MSI
>> [    4.425429] snd_hda_intel 0000:01:00.1: setting latency timer to 64
>> [    5.216459] init: failsafe main process (982) killed by TERM signal
>> [    5.237454] HDMI status: Codec=0 Pin=5 Presence_Detect=0 ELD_Valid=0
>> [    5.261442] HDMI status: Codec=1 Pin=5 Presence_Detect=0 ELD_Valid=0
>> [    5.270394] ppdev: user-space parallel port driver
>> [    5.285461] HDMI status: Codec=2 Pin=5 Presence_Detect=0 ELD_Valid=0
>> [    5.309427] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
>> [    5.309548] input: HDA NVidia HDMI/DP,pcm=9 as
>> /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
>> [    5.309644] input: HDA NVidia HDMI/DP,pcm=8 as
>> /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
>> [    5.309750] input: HDA NVidia HDMI/DP,pcm=7 as
>> /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
>> [    5.309847] input: HDA NVidia HDMI/DP,pcm=3 as
>> /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
>> [    5.331530] init: alsa-restore main process (1033) terminated with
>> status 99
>> [    5.347185] Bluetooth: RFCOMM TTY layer initialized
>> [    5.347188] Bluetooth: RFCOMM socket layer initialized
>> [    5.347189] Bluetooth: RFCOMM ver 1.11
>> [    5.349937] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
>> [    5.349939] Bluetooth: BNEP filters: protocol multicast
>> [    5.506343] init: udev-fallback-graphics main process (1135)
>> terminated with status 1
>> [    5.512231] init: kdm main process (1153) killed by TERM signal
>> [    5.514305] r8169 0000:03:00.0: eth0: link down
>> [    5.514593] init: gdm main process (1157) killed by TERM signal
>> [    5.514725] ADDRCONF(NETDEV_UP): eth0: link is not ready
>> [    5.514912] ADDRCONF(NETDEV_UP): eth0: link is not ready
>> [    6.183254] NVRM: GPU at 0000:01:00:
>> GPU-01a21cf4-41d4-a898-dee1-10943c5d4112
>> [   15.440075] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
>> [  183.369324] rtw driver version=v3.4.4_xxxx.20120730
>> [  183.369330] Build at: Feb  4 2013 23:44:44
>> [  183.369400] usbcore: registered new interface driver rtl8192cu
>> [  183.370696] register rtw_netdev_ops to netdev_ops
>> [  183.370702] CHIP TYPE: RTL8188C_8192C
>> [  183.370706]
>> [  183.370707] usb_endpoint_descriptor(0):
>> [  183.370710] bLength=7
>> [  183.370711] bDescriptorType=5
>> [  183.370713] bEndpointAddress=81
>> [  183.370715] wMaxPacketSize=200
>> [  183.370717] bInterval=0
>> [  183.370719] RT_usb_endpoint_is_bulk_in = 1
>> [  183.370721]
>> [  183.370722] usb_endpoint_descriptor(1):
>> [  183.370724] bLength=7
>> [  183.370726] bDescriptorType=5
>> [  183.370727] bEndpointAddress=2
>> [  183.370729] wMaxPacketSize=200
>> [  183.370731] bInterval=0
>> [  183.370733] RT_usb_endpoint_is_bulk_out = 2
>> [  183.370735]
>> [  183.370736] usb_endpoint_descriptor(2):
>> [  183.370738] bLength=7
>> [  183.370739] bDescriptorType=5
>> [  183.370741] bEndpointAddress=3
>> [  183.370743] wMaxPacketSize=200
>> [  183.370744] bInterval=0
>> [  183.370746] RT_usb_endpoint_is_bulk_out = 3
>> [  183.370748]
>> [  183.370749] usb_endpoint_descriptor(3):
>> [  183.370751] bLength=7
>> [  183.370752] bDescriptorType=5
>> [  183.370754] bEndpointAddress=84
>> [  183.370756] wMaxPacketSize=40
>> [  183.370758] bInterval=1
>> [  183.370760] RT_usb_endpoint_is_int_in = 4, Interval = 1
>> [  183.370762] nr_endpoint=4, in_num=2, out_num=2
>> [  183.370764]
>> [  183.370765] USB_SPEED_HIGH
>> [  183.370905] Chip Version ID: VERSION_NORMAL_TSMC_CHIP_88C.
>> [  183.370912] RF_Type is 3!!
>> [  183.371259] EEPROM type is E-FUSE
>> [  183.371263] ====> ReadAdapterInfo8192C
>> [  183.371385] Boot from EFUSE, Autoload OK !
>> [  183.556146] EEPROMVID = 0x0bda
>> [  183.556150] EEPROMPID = 0x819a
>> [  183.556152] EEPROMCustomerID : 0x00
>> [  183.556154] EEPROMSubCustomerID: 0x00
>> [  183.556156] RT_CustomerID: 0x00
>> [  183.556159] _ReadMACAddress MAC Address from EFUSE = 00:1c:7b:a8:a8:f3
>> [  183.556163] EEPROMRegulatory = 0x1
>> [  183.556165] _ReadBoardType(3)
>> [  183.556167] BT Coexistance = disable
>> [  183.556170] RT_ChannelPlan: 0x0a
>> [  183.556172] _ReadPSSetting...bHWPwrPindetect(0)-bHWPowerdown(10)
>> ,bSupportRemoteWakeup(0)
>> [  183.556176] ### PS params=>  power_mgnt(1),usbss_enable(0) ###
>> [  183.556178] ### AntDivCfg(0)
>> [  183.556180] readAdapterInfo_8192CU(): REPLACEMENT = 1
>> [  183.556184] <==== ReadAdapterInfo8192C in 184 ms
>> [  183.556432] rtw_macaddr_cfg MAC Address  = 00:1c:7b:a8:a8:f3
>> [  183.556436] MAC Address from pnetdev->dev_addr= 00:1c:7b:a8:a8:f3
>> [  183.557231] bDriverStopped:1, bSurpriseRemoved:0, bup:0,
>> hw_init_completed:0
>> [  183.571360] bDriverStopped=1
>> [  183.572190] +871x_drv - drv_open, bup=0
>> [  183.576780]  ===> FirmwareDownload91C() fw:Rtl819XFwImageArray_TSMC
>> [  183.576786] FirmwareDownload92C accquire FW from embedded image
>> [  183.576790] fw_ver=v80, fw_subver=0, sig=0x88c0
>> [  183.608627] fw download ok!
>> [  183.608631] Set RF Chip ID to RF_6052 and RF type to 1T1R.
>> [  183.984930] IQK:Start!!!
>> [  183.996309] Path A IQK Success!!
>> [  184.004034] Path A IQK Success!!
>> [  184.008907] IQK: final_candidate is 0
>> [  184.008911] IQK: RegE94=ff RegE9C=d RegEA4=fd RegEAC=3fd RegEB4=0
>> RegEBC=0 RegEC4=0 RegECC=0
>> [  184.008914]  Path A IQ Calibration Success !
>> [  184.122503] pdmpriv->TxPowerTrackControl = 1
>> [  184.127472] MAC Address from REG_MACID = 00:1c:7b:a8:a8:f3
>> [  184.127476] rtl8192cu_hal_init in 556ms
>> [  184.127480] MAC Address = 00:1c:7b:a8:a8:f3
>> [  184.132257] -871x_drv - drv_open, bup=1
>> [  184.133354] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [  184.133824] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [  184.133854] set_mode = IW_MODE_INFRA
>> [  184.150748] [rtw_wx_set_pmkid] IW_PMKSA_FLUSH!
>> [  184.150763] set_mode = IW_MODE_INFRA
>> [  184.193691] [rtw_wx_set_pmkid] IW_PMKSA_FLUSH!
>> [  185.543612] survey done event(25)
>> [  185.593007] IW_SCAN_THIS_ESSID, ssid=nicht dein WLAN, len=15
>> [  186.942758] survey done event(2d)
>> [  186.943996] wpa_set_auth_algs, AUTH_ALG_OPEN_SYSTEM
>> [  186.944003] set_mode = IW_MODE_INFRA
>> [  186.944019]
>> [  186.944020]  wpa_ie(length:22):
>> [  186.944024] 0x30 0x14 0x01 0x00 0x00 0x0f 0xac 0x02
>> [  186.944028] 0x01 0x00 0x00 0x0f 0xac 0x04 0x01 0x00
>> [  186.944031] 0x00 0x0f 0xac 0x02 0x00 0x00 0x00 0x00
>> [  186.944045] =>rtw_wx_set_essid
>> [  186.944047] ssid=nicht dein WLAN, len=15
>> [  186.944052] Set SSID under fw_state=0x00000008
>> [  186.944058] [by_bssid:0][assoc_ssid:nicht dein WLAN][to_roaming:0] new
>> candidate: nicht dein WLAN(00:15:0c:f1:0d:d0) rssi:-32
>> [  186.944077] rtw_select_and_join_from_scanned_queue: candidate: nicht
>> dein WLAN(00:15:0c:f1:0d:d0)
>> [  186.944090] link to new AP
>> [  186.944100] <=rtw_wx_set_essid, ret 0
>> [  186.944110] Set BSSID under fw_state=0x00000088
>> [  187.125476] link to new AP
>> [  187.125484] issue_deauth to 00:15:0c:f1:0d:d0
>> [  187.129338] OnAuthClient
>> [  187.129349] network.SupportedRates[0]=82
>> [  187.129351] network.SupportedRates[1]=84
>> [  187.129353] network.SupportedRates[2]=8B
>> [  187.129356] network.SupportedRates[3]=96
>> [  187.129358] network.SupportedRates[4]=2C
>> [  187.129360] network.SupportedRates[5]=0C
>> [  187.129362] network.SupportedRates[6]=12
>> [  187.129364] network.SupportedRates[7]=18
>> [  187.129366] network.SupportedRates[8]=24
>> [  187.129368] network.SupportedRates[9]=30
>> [  187.129370] network.SupportedRates[10]=48
>> [  187.129372] network.SupportedRates[11]=60
>> [  187.129374] network.SupportedRates[12]=6C
>> [  187.129377] issue_assocreq(): the rate[4]=2C is not supported by STA!
>> [  187.129380] bssrate_len = 12
>> [  187.135954] OnAssocRsp
>> [  187.135977] report_join_res(1)
>> [  187.135983] rtw_joinbss_update_network
>> [  187.135994] rtw_joinbss_update_stainfo
>> [  187.136060] HW_VAR_BASIC_RATE: BrateCfg(0x15d)
>> [  187.137196] HTOnAssocRsp
>> [  187.137334] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> [  187.142408] update raid entry, mask=0x40000fff, arg=0x80
>> [  187.143905] rtl8192c_set_FwJoinBssReport_cmd mstatus(1)
>> [  187.144776] SetFwRsvdPagePkt
>> [  187.144787] Set RSVD page location to Fw.
>> [  187.145453]
>> [  187.145455]  ~~~~stastakey:unicastkey
>> [  187.145524]
>> [  187.145525]  ~~~~stastakey:groupkey
>> [  187.145529] ==> rtw_set_key algorithm(2),keyid(2),key_mask(4)
>> [  187.145903] =>mlmeext_joinbss_event_callback
>> [  187.811595] rx bc/mc packets, to perform sw rtw_tkip_decrypt
>> [  188.141761] rtl8192c_dm_RF_Saving(): RF_Save
>> [  197.538636] wlan0: no IPv6 routers present
>>
>> tommy@Tommy-AIO:~$ lsusb -v -d 0bda:819a
>>
>> Bus 001 Device 006: ID 0bda:819a Realtek Semiconductor Corp.
>> Couldn't open device, some information will be missing
>> Device Descriptor:
>>   bLength                18
>>   bDescriptorType         1
>>   bcdUSB               2.00
>>   bDeviceClass            0 (Defined at Interface level)
>>   bDeviceSubClass         0
>>   bDeviceProtocol         0
>>   bMaxPacketSize0        64
>>   idVendor           0x0bda Realtek Semiconductor Corp.
>>   idProduct          0x819a
>>   bcdDevice            2.00
>>   iManufacturer           1
>>   iProduct                2
>>   iSerial                 3
>>   bNumConfigurations      1
>>   Configuration Descriptor:
>>     bLength                 9
>>     bDescriptorType         2
>>     wTotalLength           46
>>     bNumInterfaces          1
>>     bConfigurationValue     1
>>     iConfiguration          0
>>     bmAttributes         0xa0
>>       (Bus Powered)
>>       Remote Wakeup
>>     MaxPower              500mA
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       0
>>       bNumEndpoints           4
>>       bInterfaceClass       255 Vendor Specific Class
>>       bInterfaceSubClass    255 Vendor Specific Subclass
>>       bInterfaceProtocol    255 Vendor Specific Protocol
>>       iInterface              0
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x81  EP 1 IN
>>         bmAttributes            2
>>           Transfer Type            Bulk
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0200  1x 512 bytes
>>         bInterval               0
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x02  EP 2 OUT
>>         bmAttributes            2
>>           Transfer Type            Bulk
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0200  1x 512 bytes
>>         bInterval               0
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x03  EP 3 OUT
>>         bmAttributes            2
>>           Transfer Type            Bulk
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0200  1x 512 bytes
>>         bInterval               0
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x84  EP 4 IN
>>         bmAttributes            3
>>           Transfer Type            Interrupt
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0040  1x 64 bytes
>>         bInterval               1
>> tommy@Tommy-AIO:~$
>
>
>
> 2013/2/4 Xose Vazquez Perez <xose.vazquez@gmail.com>:
>
> > Larry Finger wrote:
> >
> >> You are likely crashing more than X.
> >>
> >> That is very good evidence that rtl8192cu is *NOT* the correct driver
> >> for that
> >> device. As I recall Xose found that USB ID in a Windows driver, but who
> >> knows
> >> what changes are inside that driver?
> >>
> >> I have what I think is a complete collection of Realtek drivers for
> >> Linux, and
> >> none of them have 0bda:819a as a USB ID.
> >
> > He's using the RTL8188C_8192C_USB_linux driver.
> > Therefore, there are only two possibilities:
> >
> > - it's a 8192_du device, or
> > - it's a 8192_cu device, and there is a bug in rtlwifi.
> >
> >
> > Thomas, could you put "dmesg" output after loading 8192cu.ko (realtek
> > driver) ?
> > and "lsusb -v -d 0bda:819a" output.
>
>
>
>
> 2013/2/4 Xose Vazquez Perez <xose.vazquez@gmail.com>
>>
>> Larry Finger wrote:
>>
>> > You are likely crashing more than X.
>> >
>> > That is very good evidence that rtl8192cu is *NOT* the correct driver
>> > for that
>> > device. As I recall Xose found that USB ID in a Windows driver, but who
>> > knows
>> > what changes are inside that driver?
>> >
>> > I have what I think is a complete collection of Realtek drivers for
>> > Linux, and
>> > none of them have 0bda:819a as a USB ID.
>>
>> He's using the RTL8188C_8192C_USB_linux driver.
>> Therefore, there are only two possibilities:
>>
>> - it's a 8192_du device, or
>> - it's a 8192_cu device, and there is a bug in rtlwifi.
>>
>>
>> Thomas, could you put "dmesg" output after loading 8192cu.ko (realtek
>> driver) ?
>> and "lsusb -v -d 0bda:819a" output.
>
>

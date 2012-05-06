Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:53360 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754211Ab2EFRek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 13:34:40 -0400
From: Markus Herrmann <info@markusherrmann.eu>
To: linux-wireless@vger.kernel.org
Subject: Bugreport ath5k in Kernel 3.2.14
Date: Sun, 06 May 2012 19:34:22 +0200
Message-ID: <1425120.KmgvyefpHd@marcimachina> (sfid-20120506_193446_228137_85642121)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart18562061.WkApBaymq0"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart18562061.WkApBaymq0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

I discovered a bug in the ath5k kernel modul in Kernel 3.2.14 (and also in the 
latest Ubuntu backport modules for this kernel).

If I try to upload larger files (at least several kb), the upload starts, but 
comes to an immediate end. Sometimes it goes again on for some seconds, but 
only to immediatelly halt again. Because of this uploading a file of 1 MB via 
dropbox, firefox or my mail client can take 8+ hours (where I normally have an 
upload rate of 100 kb/s). However, uploading via Ktorrent works fine.

If I use the ath_pci module instead, everything is fine and works normally. 
Hence, I think the bug has to be in the ath5k module.

I attatched three files with more relevant information. One is the 
wpa_supplicant.conf the other one contains the output of the dmsg command and 
the file named Bugreport contains drivername, kernelnumber, iw output, and a 
script I used for the wpa supplicant. If you need more data, please feel free 
to contact me. 

Greetings,

Markus

P.S.: If the bug is fixed and in the fix is in the newest compat-wireless, is 
there an easy way for me to know. Because then I'd switch back from ath_pci to 
ath5k.



--nextPart18562061.WkApBaymq0
Content-Disposition: attachment; filename="wpa_supplicant.conf"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="wpa_supplicant.conf"

<!DOCTYPE busconfig PUBLIC
 "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>
        <policy user="root">
                <allow own="fi.epitest.hostap.WPASupplicant"/>

                <allow send_destination="fi.epitest.hostap.WPASupplicant"/>
                <allow send_interface="fi.epitest.hostap.WPASupplicant"/>

                <allow own="fi.w1.wpa_supplicant1"/>

                <allow send_destination="fi.w1.wpa_supplicant1"/>
                <allow send_interface="fi.w1.wpa_supplicant1"/>
                <allow receive_sender="fi.w1.wpa_supplicant1" receive_type="signal"/>
        </policy>
        <policy group="netdev">
                <allow send_destination="fi.epitest.hostap.WPASupplicant"/>
                <allow send_interface="fi.epitest.hostap.WPASupplicant"/>

                <allow send_destination="fi.w1.wpa_supplicant1"/>
                <allow send_interface="fi.w1.wpa_supplicant1"/>
                <allow receive_sender="fi.w1.wpa_supplicant1" receive_type="signal"/>
        </policy>
        <policy context="default">
                <deny own="fi.epitest.hostap.WPASupplicant"/>
                <deny send_destination="fi.epitest.hostap.WPASupplicant"/>
                <deny send_interface="fi.epitest.hostap.WPASupplicant"/>

                <deny own="fi.w1.wpa_supplicant1"/>
                <deny send_destination="fi.w1.wpa_supplicant1"/>
                <deny send_interface="fi.w1.wpa_supplicant1"/>
                <deny receive_sender="fi.w1.wpa_supplicant1" receive_type="signal"/>
        </policy>
</busconfig>

--nextPart18562061.WkApBaymq0
Content-Disposition: attachment; filename="dmsg"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="dmsg"

[    0.000000]  0100000000 - 023f800000 page 2M
[    0.000000] kernel direct mapping tables up to 23f800000 @ bf7f6000-bf800000
[    0.000000] RAMDISK: 3587c000 - 36c36000
[    0.000000] ACPI: RSDP 00000000000f0420 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000befee068 0004C (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000beff6210 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000befee140 080CF (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf5d4f80 00040
[    0.000000] ACPI: APIC 00000000beff6308 00072 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000beff6380 00102 (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000beff6488 0003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000beff64c8 00038 (v01 ALASKA    A M I 01072009 AMI. 00000004)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000023f800000
[    0.000000] Initmem setup node 0 0000000000000000-000000023f800000
[    0.000000]   NODE_DATA [000000023f7fb000 - 000000023f7fffff]
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880236e00000-ffff88023edfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0023f800
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x000befa3
[    0.000000]     0: 0x000bf5c6 -> 0x000bf5c8
[    0.000000]     0: 0x000bf67c -> 0x000bf800
[    0.000000]     0: 0x00100000 -> 0x0023f800
[    0.000000] On node 0 totalpages: 2091188
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3910 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 762217 pages, LIFO batch:31
[    0.000000]   Normal zone: 20448 pages used for memmap
[    0.000000]   Normal zone: 1288224 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000befa3000 - 00000000beff7000
[    0.000000] PM: Registered nosave memory: 00000000beff7000 - 00000000bf59e000
[    0.000000] PM: Registered nosave memory: 00000000bf59e000 - 00000000bf5af000
[    0.000000] PM: Registered nosave memory: 00000000bf5af000 - 00000000bf5c6000
[    0.000000] PM: Registered nosave memory: 00000000bf5c8000 - 00000000bf5d2000
[    0.000000] PM: Registered nosave memory: 00000000bf5d2000 - 00000000bf5dd000
[    0.000000] PM: Registered nosave memory: 00000000bf5dd000 - 00000000bf639000
[    0.000000] PM: Registered nosave memory: 00000000bf639000 - 00000000bf67c000
[    0.000000] PM: Registered nosave memory: 00000000bf800000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at bf800000 (gap: bf800000:3f51c000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88023f400000 s83072 r8192 d23424 u524288
[    0.000000] pcpu-alloc: s83072 r8192 d23424 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2054351
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.2.0-24-generic root=UUID=097602e7-a147-4548-a51d-e58cd0df9de0 ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8131128k/9428992k available (6566k kernel code, 1064240k absent, 233624k reserved, 6637k data, 920k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:16640 nr_irqs:712 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] vt handoff: transparent VT on vt#7
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 3109.947 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6219.89 BogoMIPS (lpj=12439788)
[    0.000005] pid_max: default: 32768 minimum: 301
[    0.000020] Security Framework initialized
[    0.000030] AppArmor: AppArmor initialized
[    0.000031] Yama: becoming mindful.
[    0.000583] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.001943] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002487] Mount-cache hash table entries: 256
[    0.002563] Initializing cgroup subsys cpuacct
[    0.002566] Initializing cgroup subsys memory
[    0.002571] Initializing cgroup subsys devices
[    0.002573] Initializing cgroup subsys freezer
[    0.002574] Initializing cgroup subsys blkio
[    0.002578] Initializing cgroup subsys perf_event
[    0.002597] CPU: Physical Processor ID: 0
[    0.002598] CPU: Processor Core ID: 0
[    0.002601] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.002602] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.002604] mce: CPU supports 7 MCE banks
[    0.002613] CPU0: Thermal monitoring enabled (TM1)
[    0.002618] using mwait in idle threads.
[    0.004498] ACPI: Core revision 20110623
[    0.114837] ftrace: allocating 27049 entries in 107 pages
[    0.122780] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.162432] CPU0: Intel(R) Core(TM) i3-2100 CPU @ 3.10GHz stepping 07
[    0.268811] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.268815] PEBS disabled due to CPU errata.
[    0.268816] ... version:                3
[    0.268817] ... bit width:              48
[    0.268818] ... generic registers:      4
[    0.268819] ... value mask:             0000ffffffffffff
[    0.268820] ... max period:             000000007fffffff
[    0.268821] ... fixed-purpose events:   3
[    0.268822] ... event mask:             000000070000000f
[    0.268912] NMI watchdog enabled, takes one hw-pmu counter.
[    0.268963] Booting Node   0, Processors  #1
[    0.268965] smpboot cpu 1: start_ip = 96000
[    0.376818] NMI watchdog enabled, takes one hw-pmu counter.
[    0.376882]  #2
[    0.376883] smpboot cpu 2: start_ip = 96000
[    0.484716] NMI watchdog enabled, takes one hw-pmu counter.
[    0.484781]  #3 Ok.
[    0.484782] smpboot cpu 3: start_ip = 96000
[    0.592632] NMI watchdog enabled, takes one hw-pmu counter.
[    0.592656] Brought up 4 CPUs
[    0.592657] Total of 4 processors activated (24880.28 BogoMIPS).
[    0.595513] devtmpfs: initialized
[    0.596110] EVM: security.selinux
[    0.596111] EVM: security.SMACK64
[    0.596111] EVM: security.capability
[    0.596129] PM: Registering ACPI NVS region at befa3000 (344064 bytes)
[    0.596135] PM: Registering ACPI NVS region at bf59e000 (69632 bytes)
[    0.596136] PM: Registering ACPI NVS region at bf5d2000 (45056 bytes)
[    0.596140] PM: Registering ACPI NVS region at bf639000 (274432 bytes)
[    0.596686] print_constraints: dummy: 
[    0.596713] RTC time: 19:03:23, date: 05/06/12
[    0.596734] NET: Registered protocol family 16
[    0.596801] Trying to unpack rootfs image as initramfs...
[    0.596806] ACPI: bus type pci registered
[    0.596848] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.596850] PCI: not using MMCONFIG
[    0.596851] PCI: Using configuration type 1 for base access
[    0.597480] bio: create slab <bio-0> at 0
[    0.597531] ACPI: Added _OSI(Module Device)
[    0.597532] ACPI: Added _OSI(Processor Device)
[    0.597533] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.597535] ACPI: Added _OSI(Processor Aggregator Device)
[    0.598214] ACPI: EC: Look up EC in DSDT
[    0.598858] ACPI: Executed 1 blocks of module-level executable AML code
[    0.600342] ACPI Error: [RAMB] Namespace lookup failure, AE_NOT_FOUND (20110623/psargs-359)
[    0.600347] ACPI Exception: AE_NOT_FOUND, Could not execute arguments for [RAMW] (Region) (20110623/nsinit-349)
[    0.600521] ACPI: SSDT 00000000bf5d3918 003E0 (v01    AMI      IST 00000001 MSFT 03000001)
[    0.600736] ACPI: Dynamic OEM Table Load:
[    0.600738] ACPI: SSDT           (null) 003E0 (v01    AMI      IST 00000001 MSFT 03000001)
[    0.600764] ACPI: SSDT 00000000bf5d2d98 00120 (v01    AMI      CST 00000001 MSFT 03000001)
[    0.600936] ACPI: Dynamic OEM Table Load:
[    0.600938] ACPI: SSDT           (null) 00120 (v01    AMI      CST 00000001 MSFT 03000001)
[    0.601226] ACPI: Interpreter enabled
[    0.601229] ACPI: (supports S0 S1 S3 S4 S5)
[    0.601241] ACPI: Using IOAPIC for interrupt routing
[    0.601257] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
[    0.601294] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
[    0.610831] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.613711] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.613806] ACPI: No dock devices found.
[    0.613808] HEST: Table not found.
[    0.613810] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.613928] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.614059] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.614061] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.614063] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.614064] pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x000dffff]
[    0.614066] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff]
[    0.614069] pci_root PNP0A08:00: ignoring host bridge window [mem 0x000c8000-0x000dffff] (conflicts with Video ROM [mem 0x000c0000-0x000cefff])
[    0.614077] pci 0000:00:00.0: [8086:0100] type 0 class 0x000600
[    0.614106] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    0.614130] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.614133] pci 0000:00:01.0: PME# disabled
[    0.614172] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    0.614194] pci 0000:00:16.0: reg 10: [mem 0xfe704000-0xfe70400f 64bit]
[    0.614264] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.614268] pci 0000:00:16.0: PME# disabled
[    0.614297] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    0.614317] pci 0000:00:1a.0: reg 10: [mem 0xfe703000-0xfe7033ff]
[    0.614403] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.614407] pci 0000:00:1a.0: PME# disabled
[    0.614428] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    0.614502] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.614506] pci 0000:00:1c.0: PME# disabled
[    0.614528] pci 0000:00:1c.1: [8086:1c12] type 1 class 0x000604
[    0.614603] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.614607] pci 0000:00:1c.1: PME# disabled
[    0.614629] pci 0000:00:1c.2: [8086:1c14] type 1 class 0x000604
[    0.614704] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.614707] pci 0000:00:1c.2: PME# disabled
[    0.614730] pci 0000:00:1c.3: [8086:1c16] type 1 class 0x000604
[    0.614805] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.614808] pci 0000:00:1c.3: PME# disabled
[    0.614830] pci 0000:00:1c.4: [8086:1c18] type 1 class 0x000604
[    0.614905] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.614909] pci 0000:00:1c.4: PME# disabled
[    0.614931] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
[    0.615005] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.615009] pci 0000:00:1c.5: PME# disabled
[    0.615031] pci 0000:00:1c.6: [8086:244e] type 1 class 0x000604
[    0.615106] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.615109] pci 0000:00:1c.6: PME# disabled
[    0.615131] pci 0000:00:1c.7: [8086:1c1e] type 1 class 0x000604
[    0.615206] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.615210] pci 0000:00:1c.7: PME# disabled
[    0.615236] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    0.615255] pci 0000:00:1d.0: reg 10: [mem 0xfe702000-0xfe7023ff]
[    0.615340] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.615344] pci 0000:00:1d.0: PME# disabled
[    0.615367] pci 0000:00:1f.0: [8086:1c46] type 0 class 0x000601
[    0.615485] pci 0000:00:1f.2: [8086:1c02] type 0 class 0x000106
[    0.615502] pci 0000:00:1f.2: reg 10: [io  0xf070-0xf077]
[    0.615509] pci 0000:00:1f.2: reg 14: [io  0xf060-0xf063]
[    0.615516] pci 0000:00:1f.2: reg 18: [io  0xf050-0xf057]
[    0.615524] pci 0000:00:1f.2: reg 1c: [io  0xf040-0xf043]
[    0.615531] pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
[    0.615538] pci 0000:00:1f.2: reg 24: [mem 0xfe701000-0xfe7017ff]
[    0.615580] pci 0000:00:1f.2: PME# supported from D3hot
[    0.615583] pci 0000:00:1f.2: PME# disabled
[    0.615600] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    0.615614] pci 0000:00:1f.3: reg 10: [mem 0xfe700000-0xfe7000ff 64bit]
[    0.615634] pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
[    0.615681] pci 0000:01:00.0: [1002:9490] type 0 class 0x000300
[    0.615692] pci 0000:01:00.0: reg 10: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.615700] pci 0000:01:00.0: reg 18: [mem 0xfe620000-0xfe62ffff 64bit]
[    0.615706] pci 0000:01:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.615716] pci 0000:01:00.0: reg 30: [mem 0xfe600000-0xfe61ffff pref]
[    0.615742] pci 0000:01:00.0: supports D1 D2
[    0.615757] pci 0000:01:00.1: [1002:aa38] type 0 class 0x000403
[    0.615767] pci 0000:01:00.1: reg 10: [mem 0xfe630000-0xfe633fff 64bit]
[    0.615815] pci 0000:01:00.1: supports D1 D2
[    0.620551] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.620554] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.620556] pci 0000:00:01.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.620559] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.620602] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.620678] pci 0000:03:00.0: [1033:0194] type 0 class 0x000c03
[    0.620704] pci 0000:03:00.0: reg 10: [mem 0xfe500000-0xfe501fff 64bit]
[    0.620836] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.620841] pci 0000:03:00.0: PME# disabled
[    0.628553] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.628558] pci 0000:00:1c.1:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.628608] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    0.628658] pci 0000:00:1c.3: PCI bridge to [bus 05-05]
[    0.628731] pci 0000:06:00.0: [1033:0194] type 0 class 0x000c03
[    0.628757] pci 0000:06:00.0: reg 10: [mem 0xfe400000-0xfe401fff 64bit]
[    0.628889] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.628894] pci 0000:06:00.0: PME# disabled
[    0.636547] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.636554] pci 0000:00:1c.4:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.636628] pci 0000:07:00.0: [10ec:8168] type 0 class 0x000200
[    0.636648] pci 0000:07:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.636682] pci 0000:07:00.0: reg 18: [mem 0xd0004000-0xd0004fff 64bit pref]
[    0.636703] pci 0000:07:00.0: reg 20: [mem 0xd0000000-0xd0003fff 64bit pref]
[    0.636795] pci 0000:07:00.0: supports D1 D2
[    0.636796] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.636802] pci 0000:07:00.0: PME# disabled
[    0.644543] pci 0000:00:1c.5: PCI bridge to [bus 07-07]
[    0.644548] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.644556] pci 0000:00:1c.5:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.644617] pci 0000:08:00.0: [1b21:1080] type 1 class 0x000604
[    0.644739] pci 0000:00:1c.6: PCI bridge to [bus 08-09] (subtractive decode)
[    0.644743] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    0.644747] pci 0000:00:1c.6:   bridge window [mem 0xfe300000-0xfe3fffff]
[    0.644753] pci 0000:00:1c.6:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.644754] pci 0000:00:1c.6:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.644756] pci 0000:00:1c.6:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.644758] pci 0000:00:1c.6:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    0.644817] pci 0000:09:01.0: [13f6:8788] type 0 class 0x000401
[    0.644848] pci 0000:09:01.0: reg 10: [io  0xc000-0xc0ff]
[    0.644993] pci 0000:09:01.0: supports D1 D2
[    0.645023] pci 0000:09:02.0: [168c:0013] type 0 class 0x000200
[    0.645054] pci 0000:09:02.0: reg 10: [mem 0xfe300000-0xfe30ffff]
[    0.645226] pci 0000:09:03.0: [1106:3044] type 0 class 0x000c00
[    0.645257] pci 0000:09:03.0: reg 10: [mem 0xfe310000-0xfe3107ff]
[    0.645274] pci 0000:09:03.0: reg 14: [io  0xc100-0xc17f]
[    0.645404] pci 0000:09:03.0: supports D2
[    0.645405] pci 0000:09:03.0: PME# supported from D2 D3hot D3cold
[    0.645411] pci 0000:09:03.0: PME# disabled
[    0.645485] pci 0000:08:00.0: PCI bridge to [bus 09-09] (subtractive decode)
[    0.645495] pci 0000:08:00.0:   bridge window [io  0xc000-0xcfff]
[    0.645500] pci 0000:08:00.0:   bridge window [mem 0xfe300000-0xfe3fffff]
[    0.645510] pci 0000:08:00.0:   bridge window [io  0xc000-0xcfff] (subtractive decode)
[    0.645512] pci 0000:08:00.0:   bridge window [mem 0xfe300000-0xfe3fffff] (subtractive decode)
[    0.645513] pci 0000:08:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.645515] pci 0000:08:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.645517] pci 0000:08:00.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.645518] pci 0000:08:00.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.645520] pci 0000:08:00.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.645521] pci 0000:08:00.0:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    0.645593] pci 0000:0a:00.0: [1b4b:9172] type 0 class 0x000106
[    0.645610] pci 0000:0a:00.0: reg 10: [io  0xb040-0xb047]
[    0.645622] pci 0000:0a:00.0: reg 14: [io  0xb030-0xb033]
[    0.645635] pci 0000:0a:00.0: reg 18: [io  0xb020-0xb027]
[    0.645647] pci 0000:0a:00.0: reg 1c: [io  0xb010-0xb013]
[    0.645659] pci 0000:0a:00.0: reg 20: [io  0xb000-0xb00f]
[    0.645672] pci 0000:0a:00.0: reg 24: [mem 0xfe210000-0xfe2101ff]
[    0.645684] pci 0000:0a:00.0: reg 30: [mem 0xfe200000-0xfe20ffff pref]
[    0.645743] pci 0000:0a:00.0: PME# supported from D3hot
[    0.645747] pci 0000:0a:00.0: PME# disabled
[    0.652534] pci 0000:00:1c.7: PCI bridge to [bus 0a-0a]
[    0.652538] pci 0000:00:1c.7:   bridge window [io  0xb000-0xbfff]
[    0.652542] pci 0000:00:1c.7:   bridge window [mem 0xfe200000-0xfe2fffff]
[    0.652587] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.652660] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.652679] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.652696] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.652712] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.652727] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.652743] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.652759] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
[    0.652775] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6._PRT]
[    0.652793] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6.BR24._PRT]
[    0.652829] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX7._PRT]
[    0.652903]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.653030]  pci0000:00: ACPI _OSC control (0x1c) granted
[    0.655605] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.655636] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.655667] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.655695] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.655724] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.655753] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.655781] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.655810] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.655893] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.655897] vgaarb: loaded
[    0.655898] vgaarb: bridge control possible 0000:01:00.0
[    0.655958] i2c-core: driver [aat2870] using legacy suspend method
[    0.655959] i2c-core: driver [aat2870] using legacy resume method
[    0.655996] SCSI subsystem initialized
[    0.656038] libata version 3.00 loaded.
[    0.656066] usbcore: registered new interface driver usbfs
[    0.656074] usbcore: registered new interface driver hub
[    0.656091] usbcore: registered new device driver usb
[    0.656141] PCI: Using ACPI for IRQ routing
[    0.657451] PCI: pci_cache_line_size set to 64 bytes
[    0.657559] reserve RAM buffer: 000000000009b400 - 000000000009ffff 
[    0.657561] reserve RAM buffer: 00000000befa3000 - 00000000bfffffff 
[    0.657563] reserve RAM buffer: 00000000bf5c8000 - 00000000bfffffff 
[    0.657564] reserve RAM buffer: 00000000bf800000 - 00000000bfffffff 
[    0.657566] reserve RAM buffer: 000000023f800000 - 000000023fffffff 
[    0.657627] NetLabel: Initializing
[    0.657628] NetLabel:  domain hash size = 128
[    0.657629] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.657635] NetLabel:  unlabeled traffic allowed by default
[    0.657671] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.657675] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.659687] Switching to clocksource hpet
[    0.663712] AppArmor: AppArmor Filesystem Enabled
[    0.663744] pnp: PnP ACPI init
[    0.663754] ACPI: bus type pnp registered
[    0.663855] pnp 00:00: [bus 00-ff]
[    0.663856] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.663858] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.663859] pnp 00:00: [io  0x0d00-0xffff window]
[    0.663861] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.663862] pnp 00:00: [mem 0x000c8000-0x000dffff window]
[    0.663863] pnp 00:00: [mem 0xc0000000-0xffffffff window]
[    0.663865] pnp 00:00: [mem 0x00000000 window]
[    0.663907] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.663942] pnp 00:01: [mem 0xfed10000-0xfed19fff]
[    0.663943] pnp 00:01: [mem 0xe0000000-0xe3ffffff]
[    0.663944] pnp 00:01: [mem 0xfed90000-0xfed93fff]
[    0.663945] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.663946] pnp 00:01: [mem 0xfee00000-0xfee0ffff]
[    0.663980] system 00:01: [mem 0xfed10000-0xfed19fff] has been reserved
[    0.663981] system 00:01: [mem 0xe0000000-0xe3ffffff] has been reserved
[    0.663983] system 00:01: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.663985] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.663986] system 00:01: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.663988] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.664028] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.664030] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.664032] pnp 00:02: [io  0x0290-0x029f]
[    0.664033] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.664058] system 00:02: [io  0x0290-0x029f] has been reserved
[    0.664060] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.664068] pnp 00:03: [dma 4]
[    0.664069] pnp 00:03: [io  0x0000-0x000f]
[    0.664070] pnp 00:03: [io  0x0081-0x0083]
[    0.664072] pnp 00:03: [io  0x0087]
[    0.664073] pnp 00:03: [io  0x0089-0x008b]
[    0.664074] pnp 00:03: [io  0x008f]
[    0.664075] pnp 00:03: [io  0x00c0-0x00df]
[    0.664087] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.664093] pnp 00:04: [io  0x0070-0x0071]
[    0.664100] pnp 00:04: [irq 8]
[    0.664113] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.664118] pnp 00:05: [io  0x0061]
[    0.664131] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.664140] pnp 00:06: [io  0x0010-0x001f]
[    0.664141] pnp 00:06: [io  0x0022-0x003f]
[    0.664142] pnp 00:06: [io  0x0044-0x005f]
[    0.664144] pnp 00:06: [io  0x0063]
[    0.664145] pnp 00:06: [io  0x0065]
[    0.664146] pnp 00:06: [io  0x0067-0x006f]
[    0.664147] pnp 00:06: [io  0x0072-0x007f]
[    0.664148] pnp 00:06: [io  0x0080]
[    0.664149] pnp 00:06: [io  0x0084-0x0086]
[    0.664150] pnp 00:06: [io  0x0088]
[    0.664151] pnp 00:06: [io  0x008c-0x008e]
[    0.664152] pnp 00:06: [io  0x0090-0x009f]
[    0.664153] pnp 00:06: [io  0x00a2-0x00bf]
[    0.664154] pnp 00:06: [io  0x00e0-0x00ef]
[    0.664155] pnp 00:06: [io  0x04d0-0x04d1]
[    0.664182] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.664184] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.664189] pnp 00:07: [io  0x00f0-0x00ff]
[    0.664193] pnp 00:07: [irq 13]
[    0.664207] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.664370] pnp 00:08: [io  0x03f8-0x03ff]
[    0.664375] pnp 00:08: [irq 4]
[    0.664376] pnp 00:08: [dma 0 disabled]
[    0.664413] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.664504] pnp 00:09: [io  0x0400-0x0453]
[    0.664505] pnp 00:09: [io  0x0458-0x047f]
[    0.664507] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.664508] pnp 00:09: [io  0x0500-0x057f]
[    0.664509] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    0.664510] pnp 00:09: [mem 0xfec00000-0xfecfffff]
[    0.664511] pnp 00:09: [mem 0xfed08000-0xfed08fff]
[    0.664513] pnp 00:09: [mem 0xff000000-0xffffffff]
[    0.664539] system 00:09: [io  0x0400-0x0453] has been reserved
[    0.664541] system 00:09: [io  0x0458-0x047f] has been reserved
[    0.664542] system 00:09: [io  0x0500-0x057f] has been reserved
[    0.664544] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.664546] system 00:09: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.664548] system 00:09: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.664549] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[    0.664551] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.664573] pnp 00:0a: [io  0x0454-0x0457]
[    0.664596] system 00:0a: [io  0x0454-0x0457] has been reserved
[    0.664598] system 00:0a: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.664661] pnp 00:0b: [mem 0xfed00000-0xfed003ff]
[    0.664683] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.664776] pnp: PnP ACPI: found 12 devices
[    0.664777] ACPI: ACPI bus type pnp unregistered
[    0.670960] PCI: max bus depth: 2 pci_try_num: 3
[    0.671036] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.671038] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.671041] pci 0000:00:01.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.671043] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.671046] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.671056] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.671061] pci 0000:00:1c.1:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.671069] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    0.671079] pci 0000:00:1c.3: PCI bridge to [bus 05-05]
[    0.671089] pci 0000:00:1c.4: PCI bridge to [bus 06-06]
[    0.671094] pci 0000:00:1c.4:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.671102] pci 0000:00:1c.5: PCI bridge to [bus 07-07]
[    0.671105] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.671111] pci 0000:00:1c.5:   bridge window [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.671118] pci 0000:08:00.0: PCI bridge to [bus 09-09]
[    0.671121] pci 0000:08:00.0:   bridge window [io  0xc000-0xcfff]
[    0.671129] pci 0000:08:00.0:   bridge window [mem 0xfe300000-0xfe3fffff]
[    0.671142] pci 0000:00:1c.6: PCI bridge to [bus 08-09]
[    0.671145] pci 0000:00:1c.6:   bridge window [io  0xc000-0xcfff]
[    0.671150] pci 0000:00:1c.6:   bridge window [mem 0xfe300000-0xfe3fffff]
[    0.671158] pci 0000:00:1c.7: PCI bridge to [bus 0a-0a]
[    0.671160] pci 0000:00:1c.7:   bridge window [io  0xb000-0xbfff]
[    0.671165] pci 0000:00:1c.7:   bridge window [mem 0xfe200000-0xfe2fffff]
[    0.671184] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.671186] pci 0000:00:01.0: setting latency timer to 64
[    0.671195] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.671198] pci 0000:00:1c.0: setting latency timer to 64
[    0.671205] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.671208] pci 0000:00:1c.1: setting latency timer to 64
[    0.671216] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.671220] pci 0000:00:1c.2: setting latency timer to 64
[    0.671227] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.671231] pci 0000:00:1c.3: setting latency timer to 64
[    0.671237] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.671241] pci 0000:00:1c.4: setting latency timer to 64
[    0.671247] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.671251] pci 0000:00:1c.5: setting latency timer to 64
[    0.671257] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.671260] pci 0000:00:1c.6: setting latency timer to 64
[    0.671267] pci 0000:08:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.671272] pci 0000:08:00.0: setting latency timer to 64
[    0.671280] pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.671283] pci 0000:00:1c.7: setting latency timer to 64
[    0.671287] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.671288] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.671290] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.671291] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
[    0.671293] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.671294] pci_bus 0000:01: resource 1 [mem 0xfe600000-0xfe6fffff]
[    0.671296] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.671297] pci_bus 0000:03: resource 1 [mem 0xfe500000-0xfe5fffff]
[    0.671299] pci_bus 0000:06: resource 1 [mem 0xfe400000-0xfe4fffff]
[    0.671301] pci_bus 0000:07: resource 0 [io  0xd000-0xdfff]
[    0.671302] pci_bus 0000:07: resource 2 [mem 0xd0000000-0xd00fffff 64bit pref]
[    0.671304] pci_bus 0000:08: resource 0 [io  0xc000-0xcfff]
[    0.671305] pci_bus 0000:08: resource 1 [mem 0xfe300000-0xfe3fffff]
[    0.671306] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    0.671308] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    0.671309] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    0.671311] pci_bus 0000:08: resource 7 [mem 0xc0000000-0xffffffff]
[    0.671312] pci_bus 0000:09: resource 0 [io  0xc000-0xcfff]
[    0.671314] pci_bus 0000:09: resource 1 [mem 0xfe300000-0xfe3fffff]
[    0.671315] pci_bus 0000:09: resource 4 [io  0xc000-0xcfff]
[    0.671316] pci_bus 0000:09: resource 5 [mem 0xfe300000-0xfe3fffff]
[    0.671318] pci_bus 0000:09: resource 8 [io  0x0000-0x0cf7]
[    0.671319] pci_bus 0000:09: resource 9 [io  0x0d00-0xffff]
[    0.671320] pci_bus 0000:09: resource 10 [mem 0x000a0000-0x000bffff]
[    0.671322] pci_bus 0000:09: resource 11 [mem 0xc0000000-0xffffffff]
[    0.671323] pci_bus 0000:0a: resource 0 [io  0xb000-0xbfff]
[    0.671325] pci_bus 0000:0a: resource 1 [mem 0xfe200000-0xfe2fffff]
[    0.671346] NET: Registered protocol family 2
[    0.671510] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.672223] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.673244] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.673364] TCP: Hash tables configured (established 524288 bind 65536)
[    0.673365] TCP reno registered
[    0.673376] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.673405] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.673469] NET: Registered protocol family 1
[    0.673494] pci 0000:00:1a.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.799664] pci 0000:00:1a.0: PCI INT A disabled
[    0.799694] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.927563] pci 0000:00:1d.0: PCI INT A disabled
[    0.927577] pci 0000:01:00.0: Boot video device
[    0.927588] pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.927623] pci 0000:03:00.0: PCI INT A disabled
[    0.927633] pci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.927659] pci 0000:06:00.0: PCI INT A disabled
[    0.927681] PCI: CLS 64 bytes, default 64
[    0.927682] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.927684] Placing 64MB software IO TLB between ffff8800bafa3000 - ffff8800befa3000
[    0.927685] software IO TLB at phys 0xbafa3000 - 0xbefa3000
[    0.928015] audit: initializing netlink socket (disabled)
[    0.928022] type=2000 audit(1336331003.664:1): initialized
[    0.952885] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.970445] VFS: Disk quotas dquot_6.5.2
[    0.970478] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.970783] fuse init (API version 7.17)
[    0.970837] msgmni has been set to 15881
[    0.971087] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.971106] io scheduler noop registered
[    0.971107] io scheduler deadline registered
[    0.971127] io scheduler cfq registered (default)
[    0.971198] pcieport 0000:00:01.0: setting latency timer to 64
[    0.971219] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.971262] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.971299] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.971355] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.971393] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
[    0.971450] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.971487] pcieport 0000:00:1c.2: irq 43 for MSI/MSI-X
[    0.971554] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.971592] pcieport 0000:00:1c.3: irq 44 for MSI/MSI-X
[    0.971649] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.971686] pcieport 0000:00:1c.4: irq 45 for MSI/MSI-X
[    0.971743] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.971780] pcieport 0000:00:1c.5: irq 46 for MSI/MSI-X
[    0.971837] pcieport 0000:00:1c.7: setting latency timer to 64
[    0.971874] pcieport 0000:00:1c.7: irq 47 for MSI/MSI-X
[    0.971941] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    0.971942] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.971944] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    0.971946] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    0.971960] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.971964] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.971978] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.971980] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.971984] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.971998] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    0.972001] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    0.972015] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.972019] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.972034] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    0.972035] pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
[    0.972039] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    0.972053] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
[    0.972054] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[    0.972058] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
[    0.972073] pcieport 0000:00:1c.7: Signaling PME through PCIe PME interrupt
[    0.972074] pci 0000:0a:00.0: Signaling PME through PCIe PME interrupt
[    0.972078] pcie_pme 0000:00:1c.7:pcie01: service driver pcie_pme loaded
[    0.972088] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.972103] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.972135] intel_idle: MWAIT substates: 0x1120
[    0.972136] intel_idle: v0.4 model 0x2A
[    0.972137] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.972196] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.972200] ACPI: Power Button [PWRB]
[    0.972226] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.972228] ACPI: Power Button [PWRF]
[    0.984568] ERST: Table is not found!
[    0.984570] GHES: HEST is not enabled!
[    0.984635] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.005060] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.084782] Freeing initrd memory: 20200k freed
[    1.247806] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.291481] Linux agpgart interface v0.103
[    1.292454] brd: module loaded
[    1.292923] loop: module loaded
[    1.292999] ahci 0000:00:1f.2: version 3.0
[    1.293015] ahci 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    1.293050] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
[    1.293090] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1 impl SATA mode
[    1.293092] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    1.293096] ahci 0000:00:1f.2: setting latency timer to 64
[    1.293408] scsi0 : ahci
[    1.293461] scsi1 : ahci
[    1.293505] scsi2 : ahci
[    1.293550] scsi3 : ahci
[    1.293596] scsi4 : ahci
[    1.293640] scsi5 : ahci
[    1.293723] ata1: SATA max UDMA/133 abar m2048@0xfe701000 port 0xfe701100 irq 48
[    1.293725] ata2: DUMMY
[    1.293726] ata3: DUMMY
[    1.293726] ata4: DUMMY
[    1.293727] ata5: DUMMY
[    1.293728] ata6: DUMMY
[    1.293746] ahci 0000:0a:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.293808] ahci 0000:0a:00.0: irq 49 for MSI/MSI-X
[    1.293883] ahci 0000:0a:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    1.293885] ahci 0000:0a:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[    1.293890] ahci 0000:0a:00.0: setting latency timer to 64
[    1.294075] scsi6 : ahci
[    1.294123] scsi7 : ahci
[    1.294153] ata7: SATA max UDMA/133 abar m512@0xfe210000 port 0xfe210100 irq 49
[    1.294156] ata8: SATA max UDMA/133 abar m512@0xfe210000 port 0xfe210180 irq 49
[    1.294371] Fixed MDIO Bus: probed
[    1.294381] tun: Universal TUN/TAP device driver, 1.6
[    1.294382] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.294419] PPP generic driver version 2.4.2
[    1.294483] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.294494] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.294505] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.294508] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.294541] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.294564] ehci_hcd 0000:00:1a.0: debug port 2
[    1.298440] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    1.298451] ehci_hcd 0000:00:1a.0: irq 23, io mem 0xfe703000
[    1.311265] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.311385] hub 1-0:1.0: USB hub found
[    1.311388] hub 1-0:1.0: 2 ports detected
[    1.311434] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.311444] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.311447] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    1.311479] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.311498] ehci_hcd 0000:00:1d.0: debug port 2
[    1.315364] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    1.315367] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfe702000
[    1.327253] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.327363] hub 2-0:1.0: USB hub found
[    1.327365] hub 2-0:1.0: 2 ports detected
[    1.327404] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.327411] uhci_hcd: USB Universal Host Controller Interface driver
[    1.327432] xhci_hcd 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.327445] xhci_hcd 0000:03:00.0: setting latency timer to 64
[    1.327448] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    1.327479] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 3
[    1.327635] xhci_hcd 0000:03:00.0: irq 17, io mem 0xfe500000
[    1.327693] xhci_hcd 0000:03:00.0: irq 50 for MSI/MSI-X
[    1.327696] xhci_hcd 0000:03:00.0: irq 51 for MSI/MSI-X
[    1.327699] xhci_hcd 0000:03:00.0: irq 52 for MSI/MSI-X
[    1.327703] xhci_hcd 0000:03:00.0: irq 53 for MSI/MSI-X
[    1.327707] xhci_hcd 0000:03:00.0: irq 54 for MSI/MSI-X
[    1.327829] xHCI xhci_add_endpoint called for root hub
[    1.327831] xHCI xhci_check_bandwidth called for root hub
[    1.327847] hub 3-0:1.0: USB hub found
[    1.327853] hub 3-0:1.0: 2 ports detected
[    1.327891] xhci_hcd 0000:03:00.0: xHCI Host Controller
[    1.327920] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 4
[    1.331101] xHCI xhci_add_endpoint called for root hub
[    1.331103] xHCI xhci_check_bandwidth called for root hub
[    1.331118] hub 4-0:1.0: USB hub found
[    1.331124] hub 4-0:1.0: 2 ports detected
[    1.387217] xhci_hcd 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.387237] xhci_hcd 0000:06:00.0: setting latency timer to 64
[    1.387242] xhci_hcd 0000:06:00.0: xHCI Host Controller
[    1.387299] xhci_hcd 0000:06:00.0: new USB bus registered, assigned bus number 5
[    1.387454] xhci_hcd 0000:06:00.0: irq 16, io mem 0xfe400000
[    1.387510] xhci_hcd 0000:06:00.0: irq 55 for MSI/MSI-X
[    1.387513] xhci_hcd 0000:06:00.0: irq 56 for MSI/MSI-X
[    1.387517] xhci_hcd 0000:06:00.0: irq 57 for MSI/MSI-X
[    1.387519] xhci_hcd 0000:06:00.0: irq 58 for MSI/MSI-X
[    1.387522] xhci_hcd 0000:06:00.0: irq 59 for MSI/MSI-X
[    1.387643] xHCI xhci_add_endpoint called for root hub
[    1.387645] xHCI xhci_check_bandwidth called for root hub
[    1.387660] hub 5-0:1.0: USB hub found
[    1.387665] hub 5-0:1.0: 2 ports detected
[    1.387701] xhci_hcd 0000:06:00.0: xHCI Host Controller
[    1.387729] xhci_hcd 0000:06:00.0: new USB bus registered, assigned bus number 6
[    1.390922] xHCI xhci_add_endpoint called for root hub
[    1.390923] xHCI xhci_check_bandwidth called for root hub
[    1.390938] hub 6-0:1.0: USB hub found
[    1.390944] hub 6-0:1.0: 2 ports detected
[    1.451207] usbcore: registered new interface driver libusual
[    1.451246] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.453698] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.453702] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.453784] mousedev: PS/2 mouse device common for all mice
[    1.453882] rtc_cmos 00:04: RTC can wake from S4
[    1.453974] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.454000] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.454045] device-mapper: uevent: version 1.0.3
[    1.454091] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
[    1.454154] cpuidle: using governor ladder
[    1.454245] cpuidle: using governor menu
[    1.454246] EFI Variables Facility v0.08 2004-May-17
[    1.454366] TCP cubic registered
[    1.454427] NET: Registered protocol family 10
[    1.454672] NET: Registered protocol family 17
[    1.454680] Registering the dns_resolver key type
[    1.454780] PM: Hibernation image not present or could not be loaded.
[    1.454787] registered taskstats version 1
[    1.467428]   Magic number: 12:970:90
[    1.467517] rtc_cmos 00:04: setting system clock to 2012-05-06 19:03:24 UTC (1336331004)
[    1.467968] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.467969] EDD information not available.
[    1.611111] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.623070] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.665671] ata1.00: ATA-8: OCZ-VERTEX2, 1.11, max UDMA/133
[    1.665676] ata1.00: 117231408 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.715720] ata1.00: configured for UDMA/133
[    1.715963] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX2      1.11 PQ: 0 ANSI: 5
[    1.716105] sd 0:0:0:0: [sda] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[    1.716127] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.716352] sd 0:0:0:0: [sda] Write Protect is off
[    1.716365] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.716477] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.717335]  sda: sda1 sda2 sda3 sda4
[    1.717736] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.755622] hub 1-1:1.0: USB hub found
[    1.755698] hub 1-1:1.0: 6 ports detected
[    1.782965] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.782993] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.786164] ata7.00: ATA-7: SAMSUNG SP2504C, VT100-41, max UDMA7
[    1.786166] ata7.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.786208] ata8.00: ATA-7: SAMSUNG SP2504C, VT100-41, max UDMA7
[    1.786210] ata8.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.808714] ata8.00: configured for UDMA/133
[    1.811679] ata7.00: configured for UDMA/133
[    1.811883] scsi 6:0:0:0: Direct-Access     ATA      SAMSUNG SP2504C  VT10 PQ: 0 ANSI: 5
[    1.811986] sd 6:0:0:0: Attached scsi generic sg1 type 0
[    1.812006] sd 6:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.812082] scsi 7:0:0:0: Direct-Access     ATA      SAMSUNG SP2504C  VT10 PQ: 0 ANSI: 5
[    1.812085] sd 6:0:0:0: [sdb] Write Protect is off
[    1.812087] sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.812114] sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.812171] sd 7:0:0:0: [sdc] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.812179] sd 7:0:0:0: Attached scsi generic sg2 type 0
[    1.812215] sd 7:0:0:0: [sdc] Write Protect is off
[    1.812218] sd 7:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.812266] sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.818393]  sdb: sdb1
[    1.818984] sd 6:0:0:0: [sdb] Attached SCSI disk
[    1.823686]  sdc: sdc1
[    1.824335] sd 7:0:0:0: [sdc] Attached SCSI disk
[    1.825411] Freeing unused kernel memory: 920k freed
[    1.825492] Write protecting the kernel read-only data: 12288k
[    1.828942] Freeing unused kernel memory: 1608k freed
[    1.831611] Freeing unused kernel memory: 1196k freed
[    1.843099] udevd[111]: starting version 175
[    1.862915] wmi: Mapper loaded
[    1.862966] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.862986] r8169 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.863028] r8169 0000:07:00.0: setting latency timer to 64
[    1.863115] r8169 0000:07:00.0: irq 60 for MSI/MSI-X
[    1.863480] r8169 0000:07:00.0: eth0: RTL8168evl/8111evl at 0xffffc90000c7c000, f4:6d:04:ae:a4:50, XID 0c900800 IRQ 60
[    1.863484] r8169 0000:07:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    1.866875] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.873398] firewire_ohci 0000:09:03.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.926827] Refined TSC clocksource calibration: 3110.146 MHz.
[    1.926833] Switching to clocksource tsc
[    1.938850] firewire_ohci: Added fw-ohci device 0000:09:03.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x11
[    2.003427] hub 2-1:1.0: USB hub found
[    2.003496] hub 2-1:1.0: 8 ports detected
[    2.274692] usb 2-1.4: new low-speed USB device number 3 using ehci_hcd
[    2.377465] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/input/input2
[    2.377591] generic-usb 0003:046D:C051.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1.4/input0
[    2.377603] usbcore: registered new interface driver usbhid
[    2.377604] usbhid: USB HID core driver
[    2.402845] hub 2-1:1.0: unable to enumerate USB device on port 6
[    2.438565] firewire_core: created device fw0: GUID 001e8c00004aedda, S400
[    2.474541] usb 2-1.7: new full-speed USB device number 5 using ehci_hcd
[    2.798298] usb 2-1.6: new low-speed USB device number 6 using ehci_hcd
[    2.901616] input: HID 046a:0023 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/input/input3
[    2.901685] cherry 0003:046A:0023.0002: input,hidraw1: USB HID v1.11 Keyboard [HID 046a:0023] on usb-0000:00:1d.0-1.6/input0
[    2.907184] input: HID 046a:0023 as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.1/input/input4
[    2.907296] cherry 0003:046A:0023.0003: input,hidraw2: USB HID v1.11 Device [HID 046a:0023] on usb-0000:00:1d.0-1.6/input1
[    3.171504] vesafb: mode is 1400x1050x32, linelength=5632, pages=0
[    3.171506] vesafb: scrolling: redraw
[    3.171508] vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
[    3.174063] vesafb: framebuffer at 0xc0000000, mapped to 0xffffc90005c00000, using 5824k, total 5824k
[    3.174193] Console: switching to colour frame buffer device 175x65
[    3.174211] fb0: VESA VGA frame buffer device
[    3.581039] EXT4-fs (sda2): INFO: recovery required on readonly filesystem
[    3.581042] EXT4-fs (sda2): write access will be enabled during recovery
[    3.989090] EXT4-fs (sda2): recovery complete
[    3.989189] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    4.230560] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.235439] udevd[367]: starting version 175
[    5.853655] Adding 1951740k swap on /dev/sda1.  Priority:-1 extents:1 across:1951740k SS
[    5.869760] Bluetooth: Core ver 2.16
[    5.869781] NET: Registered protocol family 31
[    5.869783] Bluetooth: HCI device and connection manager initialized
[    5.869785] Bluetooth: HCI socket layer initialized
[    5.869787] Bluetooth: L2CAP socket layer initialized
[    5.869791] Bluetooth: SCO socket layer initialized
[    5.871300] lp: driver loaded but no devices found
[    5.875260] fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
[    5.875264] Disabling lock debugging due to kernel taint
[    5.880098] mei: module is from the staging directory, the quality is unknown, you have been warned.
[    5.881527] mei 0000:00:16.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    5.881547] mei 0000:00:16.0: setting latency timer to 64
[    5.881800] mei 0000:00:16.0: irq 61 for MSI/MSI-X
[    5.883401] asus_wmi: ASUS WMI generic driver loaded
[    5.886938] usbcore: registered new interface driver btusb
[    5.887556] asus_wmi: Initialization: 0x0
[    5.887577] asus_wmi: BIOS WMI version: 0.9
[    5.887612] asus_wmi: SFUN value: 0x0
[    5.892817] input: Eee PC WMI hotkeys as /devices/platform/eeepc-wmi/input/input5
[    5.899203] [fglrx] Maximum main memory to use for locked dma buffers: 7731 MBytes.
[    5.899434] [fglrx]   vendor: 1002 device: 9490 count: 1
[    5.900005] [fglrx] ioport: bar 4, base 0xe000, size: 0x100
[    5.900017] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.900022] pci 0000:01:00.0: setting latency timer to 64
[    5.901018] [fglrx] Kernel PAT support is enabled
[    5.901037] [fglrx] module loaded - fglrx 8.96.4 [Mar 12 2012] with 1 minors
[    5.908368] type=1400 audit(1336323808.940:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=570 comm="apparmor_parser"
[    5.908376] type=1400 audit(1336323808.940:3): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=550 comm="apparmor_parser"
[    5.908698] type=1400 audit(1336323808.940:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=570 comm="apparmor_parser"
[    5.908709] type=1400 audit(1336323808.940:5): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=550 comm="apparmor_parser"
[    5.908889] type=1400 audit(1336323808.940:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=570 comm="apparmor_parser"
[    5.908900] type=1400 audit(1336323808.940:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=550 comm="apparmor_parser"
[    5.931246] cfg80211: Calling CRDA to update world regulatory domain
[    5.940464] ath5k 0000:09:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.940522] ath5k 0000:09:02.0: registered as 'phy0'
[    5.978664] cfg80211: World regulatory domain updated:
[    5.978667] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    5.978670] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.978672] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    5.978675] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    5.978677] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.978679] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.042451] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
[    6.224031] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)
[    6.244082] init: failsafe main process (866) killed by TERM signal
[    6.282157] ppdev: user-space parallel port driver
[    6.290829] Bluetooth: RFCOMM TTY layer initialized
[    6.290837] Bluetooth: RFCOMM socket layer initialized
[    6.290839] Bluetooth: RFCOMM ver 1.11
[    6.290866] type=1400 audit(1336323809.320:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=957 comm="apparmor_parser"
[    6.293111] type=1400 audit(1336323809.324:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=957 comm="apparmor_parser"
[    6.293293] type=1400 audit(1336323809.324:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=957 comm="apparmor_parser"
[    6.296679] type=1400 audit(1336323809.328:11): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=971 comm="apparmor_parser"
[    6.297214] type=1400 audit(1336323809.328:12): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=959 comm="apparmor_parser"
[    6.298410] type=1400 audit(1336323809.328:13): apparmor="STATUS" operation="profile_load" name="/usr/sbin/mysqld" pid=960 comm="apparmor_parser"
[    6.299566] type=1400 audit(1336323809.332:14): apparmor="STATUS" operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf" pid=972 comm="apparmor_parser"
[    6.301713] type=1400 audit(1336323809.332:15): apparmor="STATUS" operation="profile_load" name="/usr/sbin/mysqld-akonadi" pid=969 comm="apparmor_parser"
[    6.302059] type=1400 audit(1336323809.332:16): apparmor="STATUS" operation="profile_load" name="/usr/sbin/mysqld-akonadi///usr/sbin/mysqld" pid=969 comm="apparmor_parser"
[    6.302066] type=1400 audit(1336323809.332:17): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=972 comm="apparmor_parser"
[    6.305545] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    6.305547] Bluetooth: BNEP filters: protocol multicast
[    6.375021] init: alsa-restore main process (1020) terminated with status 19
[    6.556321] r8169 0000:07:00.0: eth0: link down
[    6.557002] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.557335] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.632586] ath: EEPROM regdomain: 0x809c
[    6.632588] ath: EEPROM indicates we should expect a country code
[    6.632590] ath: doing EEPROM country->regdmn map search
[    6.632592] ath: country maps to regdmn code: 0x52
[    6.632593] ath: Country alpha2 being used: CN
[    6.632595] ath: Regpair used: 0x52
[    6.632597] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[    6.632600] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.632602] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[    6.632604] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.632606] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[    6.632609] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.632611] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[    6.632613] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.632615] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[    6.632618] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.632620] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[    6.632623] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.632625] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[    6.632627] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.632629] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[    6.632632] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.632634] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[    6.632636] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.632638] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[    6.632641] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.632643] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[    6.632646] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.632648] cfg80211: Disabling freq 2467 MHz as custom regd has no rule that fits a 20 MHz wide channel
[    6.632650] cfg80211: Disabling freq 2472 MHz as custom regd has no rule that fits a 20 MHz wide channel
[    6.632652] cfg80211: Disabling freq 2484 MHz as custom regd has no rule that fits a 20 MHz wide channel
[    6.632742] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[    6.632746] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.632748] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[    6.632751] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.632753] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[    6.632755] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.632757] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[    6.632760] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.632762] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[    6.632765] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.632767] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[    6.632769] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.632771] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[    6.632774] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.632776] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[    6.632779] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.632781] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[    6.632783] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.632785] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[    6.632788] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.632790] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[    6.632793] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.632795] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
[    6.632797] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    6.632799] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
[    6.632802] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    6.632804] cfg80211: Updating information on frequency 2484 MHz for a 20 MHz width channel with regulatory rule:
[    6.632807] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    6.641484] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    6.642027] ath5k phy0: Atheros AR2414 chip found (MAC: 0x79, PHY: 0x45)
[    6.642062] snd_oxygen 0000:09:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    6.642266] cfg80211: Calling CRDA for country: CN
[    6.648789] fglrx_pci 0000:01:00.0: irq 62 for MSI/MSI-X
[    6.649487] [fglrx] Firegl kernel thread PID: 1184
[    6.649552] [fglrx] Firegl kernel thread PID: 1185
[    6.649615] [fglrx] Firegl kernel thread PID: 1186
[    6.649735] [fglrx] IRQ 62 Enabled
[    6.651941] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[    6.651945] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.651947] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[    6.651950] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.651952] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[    6.651955] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.651957] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[    6.651959] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.651961] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[    6.651964] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.651966] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[    6.651969] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.651971] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[    6.651973] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.651975] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[    6.651978] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.651980] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[    6.651983] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.651985] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[    6.651987] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.651989] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[    6.651992] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.651994] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
[    6.651996] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.651998] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
[    6.652001] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    6.652003] cfg80211: Disabling freq 2484 MHz
[    6.652006] cfg80211: Regulatory domain changed to country: CN
[    6.652007] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    6.652010] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    6.652012] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (N/A, 3000 mBm)
[    6.666353] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    6.667545] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    7.126549] [fglrx] Gart USWC size:1280 M.
[    7.126552] [fglrx] Gart cacheable size:508 M.
[    7.126555] [fglrx] Reserved FB block: Shared offset:0, size:1000000 
[    7.126557] [fglrx] Reserved FB block: Unshared offset:fbfd000, size:403000 
[    7.126558] [fglrx] Reserved FB block: Unshared offset:1fffb000, size:5000 
[    8.414866] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    9.205841] wlan0: direct probe to 7c:4f:b5:c9:8d:d0 (try 1/3)
[    9.209920] wlan0: direct probe responded
[    9.273345] wlan0: authenticate with 7c:4f:b5:c9:8d:d0 (try 1)
[    9.274807] wlan0: authenticated
[    9.274995] wlan0: associate with 7c:4f:b5:c9:8d:d0 (try 1)
[    9.289722] wlan0: RX AssocResp from 7c:4f:b5:c9:8d:d0 (capab=0x411 status=0 aid=2)
[    9.289724] wlan0: associated
[    9.289727] wlan0: moving STA 7c:4f:b5:c9:8d:d0 to state 1
[    9.289728] wlan0: moving STA 7c:4f:b5:c9:8d:d0 to state 2
[    9.290701] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[    9.290763] cfg80211: Calling CRDA for country: DE
[    9.293069] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[    9.293073] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    9.293074] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[    9.293076] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    9.293077] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[    9.293079] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    9.293081] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[    9.293082] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    9.293084] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[    9.293085] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    9.293087] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[    9.293088] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    9.293090] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[    9.293092] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    9.293093] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[    9.293095] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    9.293096] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[    9.293098] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    9.293099] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[    9.293101] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    9.293102] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[    9.293104] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    9.293105] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
[    9.293107] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    9.293108] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
[    9.293110] cfg80211: 2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[    9.293111] cfg80211: Disabling freq 2484 MHz
[    9.293114] cfg80211: Regulatory domain changed to country: DE
[    9.293115] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    9.293116] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    9.293118] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    9.293119] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    9.293121] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[    9.321008] wlan0: moving STA 7c:4f:b5:c9:8d:d0 to state 3
[   20.300954] wlan0: no IPv6 routers present
[   27.238951] ath5k_hw_get_isr: ISR: 0x00000400 IMR: 0x00000000
[  306.890124] ath5k_hw_get_isr: ISR: 0x00000400 IMR: 0x00000000
--nextPart18562061.WkApBaymq0
Content-Disposition: attachment; filename="Bugreport"
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; name="Bugreport"

Kernel 3.2.14 (Ubuntu)
Driver ath5k

iw event -t
1336322632.370287: wlan0 (phy #0): scan started
1336322635.307201: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2=
432 2437 2442 2447 2452 2457 2462 2467 2472,
1336322752.370672: wlan0 (phy #0): scan started
1336322755.307196: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2=
432 2437 2442 2447 2452 2457 2462 2467 2472,
1336322872.369918: wlan0 (phy #0): scan started
1336322875.307250: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2=
432 2437 2442 2447 2452 2457 2462 2467 2472,
1336322992.370116: wlan0 (phy #0): scan started
1336322995.307210: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2=
432 2437 2442 2447 2452 2457 2462 2467 2472,
1336323112.366502: wlan0 (phy #0): scan started
1336323115.307205: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2=
432 2437 2442 2447 2452 2457 2462 2467 2472,
1336323232.369952: wlan0 (phy #0): scan started
1336323235.307200: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2=
432 2437 2442 2447 2452 2457 2462 2467 2472,=20


script for wpa_supplicant:
#!/bin/bash
## WLAN Verbindungsskript
## elektronenblitz63 ubuntuusers.de 2012
## published under GPL v3
##
## Version 1.0.2.2 vom 26.Februar 2012
## Debug-Modus verbessert. Kleinere Fehler beseitigt.
##
## Skript
##
## freie Variablen
##

## Ethernet-Schnittstelle (LAN-Interface)
laniface=3D"eth0"

## Schnittsetllenkonfiguration WLAN-Interface
wlaniface=3D"wlan0"

## Konfiguration der Accesspoints
#
## Accesspoint Konfiguration
# SSID (Name) des WLAN Accesspoints eintragen
ssid=3D"Niedergang"

# MAC-Adresse des WLAN Accesspoints eintragen
mac=3D"7C:4F:B5:C9:8D:D0"

# Einstellungen zur Verschl=C3=BCsselung (WPA1 und/oder WPA2)
# die Vorgabe deckt im Normalfall alle Konfigurationsm=C3=B6glichkeiten=
 ab
# Konfiguration wpa-supplicant
proto=3D"WPA RSN"
key_mgmt=3D"WPA-PSK"
pairwise=3D"TKIP CCMP"
group=3D"TKIP CCMP"

# WEP-Verschl=C3=BCsselung
# Einstellungen zur Verschl=C3=BCsselung (WEP-Zugangsschl=C3=BCssel)
wkey=3D""

# WPA1 - WPA2 - WPA1/2 Verschl=C3=BCsselung
# Zugangskennwort in Klartext (WPA1/2-Zugangsschl=C3=BCssel / PSK)
psk=3D"XXXXXXXXXXXXXXXXXXXXXXXX"

# Treiber f=C3=BCr wpa_supplicant
wpadriver=3D"wext"

## DHCP-Client
dhcpclient=3D"dhclient"

## manuelle DNS (drei DNS Eintr=C3=A4ge, 1xDomain und 1xSearch sind m=C3=
=B6glich) - Startoption -D
# Beispiel:
# dns=3D"nameserver 192.168.178.1 nameserver 192.168.178.1 nameserver 1=
92.168.178.1 domain fritz.box search fritz.box"
dns=3D"nameserver 8.8.4.4 nameserver 8.8.8.8 nameserver 213.73.91.35"=20=


## Pause bevor eine IP-Adresse angefordert wird
## diese Zeit in Sek. bleibt wpa_supplicant f=C3=BCr den Verbindungsauf=
bau
connectsleep=3D15

## Pause in Sekunden f=C3=BCr Konfigurationsparameter
## Vorgabewert 2
configdelay=3D2

## verwendetes Terminalprogramm
# kde > konsole oder xterm
# xfce > mousepad oder xterm
# gnome > gnome-terminal oder xterm
term=3Dxterm

## Konfiguration Debug-Modus
# Dauer des Verbindungsversuchs in Sekunden
debugtime=3D45

# Protokolldatei
debugfile=3D"WLAN_con_debug.txt"

## Ende freie Variablen

## Optionen
D=3D0
H=3D0
d=3D0
w=3D0
f=3D0

while getopts ":hDdwf" OPTION ; do
 case $OPTION in
  D) echo "manueller DNS"; D=3D1;;
  d) echo "WPA-Supplicant im Debug-Modus"; d=3D1;;
  f) echo "WPA-Supplicant im Debug-Modus, Protokolldatei wird angelegt"=
; f=3D1;;
  w) echo "WEP-Verschl=C3=BCsselung aktiviert"; w=3D1;;
  h) echo "Hilfe angefordert"; H=3D1;;
 esac
  done

if [ "$H" =3D "1" ]; then
echo Verwendung: WLAN_con.sh [-start] [-restart] [-stop] [-h] [-D] [-d]=
 [-f] [-w]
echo Syntax:
echo "sudo ./WLAN_con.sh startet mit Standardparametern, wie [-start]"
echo "sudo ./WLAN_con.sh -start -w startet mit Standardparametern und v=
erwendet WEP-Verschl=C3=BCsselung"
echo "sudo ./WLAN_con.sh -restart erneuert die Verbindung =C3=BCber DHC=
P"
echo "sudo ./WLAN_con.sh -d startet im Debug-Modus. Informationen zum V=
erbindungsaufbau werden in einem Terminalfenster angezeigt."
echo "sudo ./WLAN_con.sh -f startet im Debug-Modus. Informationen zum V=
erbindungsaufbau werden in einer Datei gespeichert."
echo "sudo ./WLAN_con.sh -restart -D erneuert die Verbindung =C3=BCber =
DHCP, verwendet manuelle DNS"
echo "sudo ./WLAN_con.sh -stop beendet die WLAN-Verbindung"
echo "Ende"
 exit
fi

echo starte Konfiguration ...
 echo

## Plausibilit=C3=A4tspr=C3=BCfung WEP-Schl=C3=BCssel
keycheck=3D"`echo $wkey | egrep -o [A-Fa-f0-9]`"
 keycheck=3D"`echo $keycheck | tr -d " "`"
  keylenght=3D"`expr length $keycheck | egrep -wo '10|26'`"
   keylenght=3D$[keylenght +1]

if [ $keycheck !=3D $wkey ]; then
 echo "Unzul=C3=A4ssige Zeichen im WEP-Schl=C3=BCssel. [a-f] [A-F] [0-9=
] (hex-Code) sind erlaubt"
  exit
 elif [ $keylenght =3D 1 ]; then
  echo "L=C3=A4nge des gew=C3=A4hlten WEP-Schl=C3=BCssels fehlerhaft, 1=
0 Zeichen (64bit) oder 26 Zeichen (128bit) sind erlaubt"
   exit
fi

## be root if not
test `id -u` -eq 0 || exec sudo "$0" "$@"

if [ "$1" !=3D "-start" ]; then
echo stoppe alle Dienste, und Verbindungen ...

defgw=3D"`route -n | grep UG | awk {'print $2'}`"
 /sbin/route del default gw $defgw $wlaniface
  echo '' | tee /etc/resolv.conf
   killall wpa_supplicant
    sleep $configdelay
     /sbin/ifconfig $wlaniface down

## Restart Network-Manager - beende WLAN-Verbindung
if [ "$1" =3D "-stop" ]; then
 echo
  echo "reaktiviere Network-Manager."
   sleep $configdelay
     service network-manager start
echo "WLAN Konfiguration beendet."
 exit
  fi
 fi

# Konfiguration wpa_supplicant
configfile=3D$home/wpa_supplicant.tmp
ctrliface=3D"ctrl_interface=3D/var/run/wpa_supplicant"
eapolv=3D"eapol_version=3D1"
apscan=3D"ap_scan=3D1"
wpadriver=3Dwext
success=3D0

# Konfiguration
ip link set $laniface down
 ip route del

 service network-manager stop
  sleep 1
   killall wpa_supplicant
    killall $dhcpclient
     sleep $configdelay
      /sbin/ifconfig $wlaniface down
       sleep $configdelay
        /sbin/ifconfig $wlaniface up
         sleep $configdelay

## WLAN-Verbindung vorbereiten
if [ "$w" =3D "0" ]; then
 echo $ctrliface | tee $configfile
  echo $eapolv | tee -a $configfile
   echo $apscan | tee -a $configfile
    echo 'network=3D{' | tee -a $configfile
     echo ssid=3D'"'$ssid'"' | tee -a $configfile
      echo bssid=3D$mac | tee -a $configfile
       echo proto=3D$proto | tee -a $configfile
        echo key_mgmt=3D$key_mgmt | tee -a $configfile
         echo pairwise=3D$pairwise | tee -a $configfile
          echo group=3D$group | tee -a $configfile
           echo psk=3D'"'$psk'"' | tee -a $configfile
            echo '}' | tee -a $configfile
else
 echo $ctrliface | tee $configfile
    echo 'network=3D{' | tee -a $configfile
     echo ssid=3D'"'$ssid'"' | tee -a $configfile
      echo bssid=3D$mac | tee -a $configfile
       echo "key_mgmt=3DNONE" | tee -a $configfile
        echo wep_key0=3D"$wkey" | tee -a $configfile
         echo wep_tx_keyidx=3D0 | tee -a $configfile
          echo '}' | tee -a $configfile
fi

echo "Starte WLAN-Verbindungsaufbau ..."
 echo

# Debug-Modus / Protokollierung
if [ "$f" =3D "1" ]; then
 echo "protokolliere Verbindungsvorgang f=C3=BCr "$debugtime" Sekunden,=
 bitte warten ..."
  echo
   /usr/bin/$term -e "/sbin/wpa_supplicant -i $wlaniface -D $wpadriver =
-c $configfile -d > $debugfile" &> /dev/null &
    sleep $debugtime
     killall wpa_supplicant
  echo "Protokollierung beendet. Informationen wurden in "`pwd`/$debugf=
ile" abgelegt."
 exit
fi

# Debug-Modus / ohne Protokollierung
if [ "$d" =3D "1" ]; then
 /usr/bin/$term -e "/sbin/wpa_supplicant -i $wlaniface -D $wpadriver -c=
 $configfile -d" &> /dev/null &
  echo "Pause, warte auf Verbindung ..."
   echo
    sleep $connectsleep
     echo "Fordere IP-Adresse an ..."
    /sbin/dhclient $wlaniface
 else

# Daemon-Modus
 /sbin/wpa_supplicant -i $wlaniface -D $wpadriver -c $configfile -B
  echo "Pause, warte auf Verbindung ..."
   echo
    sleep $connectsleep
     echo "Fordere IP-Adresse an ..."
      /sbin/dhclient $wlaniface
       sleep $configdelay
fi=20

# manuelle DNS - Startoption -D
if [ "$D" =3D "1" ]; then
echo "setze manuelle DNS"
 echo '# instant_ICS_WLAN_to_LAN.sh' | tee /etc/resolv.conf
  echo $dns | awk {'print $1,$2'} | tee -a /etc/resolv.conf
   echo $dns | awk {'print $3,$4'} | tee -a /etc/resolv.conf
    echo $dns | awk {'print $5,$6'} | tee -a /etc/resolv.conf=20
     echo $dns | awk {'print $7,$8'} | tee -a /etc/resolv.conf
      echo $dns | awk {'print $9,$10'} | tee -a /etc/resolv.conf
 sleep $configdelay
fi

# Ausgabe der Konfiguration. Einstellungen der Schnittstellen,
# Routingtabelle und DNS pr=C3=BCfen

echo "pr=C3=BCfe Konfiguration ..."
 echo
echo "Systemkonfiguration: /etc/resolv.conf"
  /bin/cat /etc/resolv.conf
   /sbin/route -n
echo
 echo Konfiguration WLAN:
  /sbin/ifconfig $wlaniface | egrep 'Link|inet Adresse'
   echo
   /sbin/iwconfig $wlaniface
echo
 echo "Konfiguration beendet"

exit 0
--nextPart18562061.WkApBaymq0--


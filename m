Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:19831 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760351AbYFKPHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 11:07:34 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2148815fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 08:07:31 -0700 (PDT)
Message-ID: <484FEA26.1040305@gmail.com> (sfid-20080611_170859_282786_DFB1915F)
Date: Wed, 11 Jun 2008 18:07:18 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ipw3945-devel@lists.sourceforge.net
Subject: Re: [BUG] iwlwifi 3945 works only with disable_hw_scan=1
Content-Type: multipart/mixed;
 boundary="------------060506070106030406010902"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060506070106030406010902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Maxim Levitsky wrote:
> I recently bought an acer aspire 5720G, and wireless didn't work with
> standard ubuntu 2.6.24 kernel.
> 
> I found that specifying the above option 'fixes' the driver
> but I also noticed that list of available access points shrinks
> to just one (the connected) point.
> 
> Moreover there is a trouble in changing a access point, it just hangs.
> the button that toggles wireless does work, but doesn't blink.
> 
> I then installed latest -git kernel (~ 2.6.26-rc4) and got this:
> 
> * I still have to use disable_hw_scan=1
> * Wireless led works thanks to acer-wmi
> * If I disable wireless with the button, I _can't_ re-enable it unless
>   I reload the module.
> 
> * List of access points doesn't shrink, and I can switch between those points.
> 
> 
> When I omit disable_hw_scan=1, I get errors about REPLY_SCAN_CMD
> I will send detailed debug info later.


dmesg with debug=0x43ffff attached

Anybody know about that bug?


--------------060506070106030406010902
Content-Type: text/plain;
 name="iwlwifi_firmware_log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iwlwifi_firmware_log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.26-rc4-wl (maxim@MOBILE) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #7 SMP PREEMPT Tue Jun 10 20:00:16 IDT 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fcfe000 (usable)
[    0.000000]  BIOS-e820: 000000007fcfe000 - 000000007fd09000 (reserved)
[    0.000000]  BIOS-e820: 000000007fd09000 - 000000007fd52000 (usable)
[    0.000000]  BIOS-e820: 000000007fd52000 - 000000007fd55000 (reserved)
[    0.000000]  BIOS-e820: 000000007fd55000 - 000000007fdbb000 (usable)
[    0.000000]  BIOS-e820: 000000007fdbb000 - 000000007fdbf000 (reserved)
[    0.000000]  BIOS-e820: 000000007fdbf000 - 000000007fe84000 (usable)
[    0.000000]  BIOS-e820: 000000007fe84000 - 000000007febf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007febf000 - 000000007ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] 1150MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at [c00fe1b0] 000fe1b0
[    0.000000] Entering add_active_range(0, 0, 523908) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   523908
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   523908
[    0.000000] On node 0 totalpages: 523908
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2302 pages used for memmap
[    0.000000]   HighMem zone: 292230 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 ACRSYS)
[    0.000000] ACPI: XSDT 7FEFE120, 0064 (r1 ACRSYS ACRPRDCT        1       1000013)
[    0.000000] ACPI: FACP 7FEFD000, 00F4 (r4 ACRSYS ACRPRDCT        1 MSFT  1000013)
[    0.000000] ACPI: DSDT 7FEF4000, 84EA (r1 ACRSYS ACRPRDCT        1 MSFT  1000013)
[    0.000000] ACPI: FACS 7FE89000, 0040
[    0.000000] ACPI: APIC 7FEF3000, 0068 (r2 ACRSYS ACRPRDCT        1 MSFT  1000013)
[    0.000000] ACPI: MCFG 7FEF2000, 003C (r1 ACRSYS ACRPRDCT        1 MSFT  1000013)
[    0.000000] ACPI: SLIC 7FEF1000, 0176 (r1 ACRSYS ACRPRDCT        1 MSFT  1000013)
[    0.000000] ACPI: HPET 7FEF0000, 0038 (r1 ACRSYS ACRPRDCT        1 MSFT  1000013)
[    0.000000] ACPI: SSDT 7FEEF000, 04C4 (r1  PmRef    CpuPm     3000 INTL 20051117)
[    0.000000] ACPI: SSDT 7FEEE000, 0232 (r1  PmRef  Cpu0Tst     3000 INTL 20051117)
[    0.000000] ACPI: SSDT 7FEED000, 00A0 (r1  PmRef  Cpu1Tst     3000 INTL 20051117)
[    0.000000] ACPI: DMI detected: Acer
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 39428 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 2
[    0.628960] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519814
[    0.628960] Kernel command line: root=UUID=bf354417-9873-455d-b81f-39240fe9ca91 ro quiet vga=792 splash i8042.dritek=1 acpi_osi=Linux
[    0.628960] ACPI: Added _OSI(Linux)
[    0.628960] mapped APIC to ffffb000 (fee00000)
[    0.628960] mapped IOAPIC to ffffa000 (fec00000)
[    0.628960] Enabling fast FPU save and restore... done.
[    0.628960] Enabling unmasked SIMD FPU exception support... done.
[    0.628960] Initializing CPU#0
[    0.628960] Preemptible RCU implementation.
[    0.628960] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.628960] Detected 1662.541 MHz processor.
[    0.628960] Console: colour dummy device 80x25
[    0.628960] console [tty0] enabled
[    0.628960] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.628960] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.628960] Memory: 2053864k/2095632k available (2906k kernel code, 40416k reserved, 1333k data, 368k init, 1178056k highmem)
[    0.628960] virtual kernel memory layout:
[    0.628960]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[    0.628960]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.628960]     vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
[    0.628960]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.628960]       .init : 0xc0529000 - 0xc0585000   ( 368 kB)
[    0.628960]       .data : 0xc03d682b - 0xc0523d50   (1333 kB)
[    0.628960]       .text : 0xc0100000 - 0xc03d682b   (2906 kB)
[    0.628960] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.628960] CPA: page pool initialized 1 of 1 pages preallocated
[    0.628960] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.628960] hpet clockevent registered
[    0.708834] Calibrating delay using timer specific routine.. 3329.27 BogoMIPS (lpj=6658555)
[    0.708851] Security Framework initialized
[    0.708858] SELinux:  Disabled at boot.
[    0.708862] Capability LSM initialized
[    0.708873] Mount-cache hash table entries: 512
[    0.708965] Initializing cgroup subsys ns
[    0.708965] Initializing cgroup subsys cpuacct
[    0.708965] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.708965] CPU: L2 cache: 2048K
[    0.708965] CPU: Physical Processor ID: 0
[    0.708965] CPU: Processor Core ID: 0
[    0.708965] Intel machine check architecture supported.
[    0.708965] Intel machine check reporting enabled on CPU#0.
[    0.708965] using mwait in idle threads.
[    0.708965] Checking 'hlt' instruction... OK.
[    0.724966] ACPI: Core revision 20080321
[    0.740967] ENABLING IO-APIC IRQs
[    0.740967] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.780646] CPU0: Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz stepping 0d
[    0.780970] Booting processor 1/1 ip 6000
[    0.788848] Initializing CPU#1
[    0.788848] Calibrating delay using timer specific routine.. 3325.02 BogoMIPS (lpj=6650041)
[    0.788848] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.788848] CPU: L2 cache: 2048K
[    0.788848] CPU: Physical Processor ID: 0
[    0.788848] CPU: Processor Core ID: 1
[    0.788848] Intel machine check architecture supported.
[    0.788848] Intel machine check reporting enabled on CPU#1.
[    0.788848] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.868975] CPU1: Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz stepping 0d
[    0.868975] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.869001] Brought up 2 CPUs
[    0.869004] Total of 2 processors activated (6654.29 BogoMIPS).
[    0.869022] CPU0 attaching sched-domain:
[    0.869025]  domain 0: span 0-1
[    0.869027]   groups: 0 1
[    0.869033] CPU1 attaching sched-domain:
[    0.869035]  domain 0: span 0-1
[    0.869037]   groups: 1 0
[    0.872975] net_namespace: 644 bytes
[    0.872975] NET: Registered protocol family 16
[    0.872976] No dock devices found.
[    0.872976] EISA bus registered
[    0.872976] ACPI: bus type pci registered
[    0.872976] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.872976] PCI: MCFG area at e0000000 reserved in E820
[    0.872976] PCI: Using MMCONFIG for extended config space
[    0.872976] PCI: Using configuration type 1 for base access
[    0.872976] Setting up standard PCI resources
[    0.876976] ACPI: EC: Look up EC in DSDT
[    0.881027] ACPI: BIOS _OSI(Linux) query honored via cmdline
[    0.887781] ACPI: Interpreter enabled
[    0.887785] ACPI: (supports S0 S3 S4 S5)
[    0.889510] ACPI: Using IOAPIC for interrupt routing
[    0.891108] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.961515] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.961515] ACPI: EC: driver started in interrupt mode
[    0.961515] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.961515] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.961515] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.961515] PCI: Transparent bridge - 0000:00:1e.0
[    0.961515] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.961944] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.962128] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.962315] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.962502] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.962700] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.973516] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.973516] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12)
[    0.973516] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.973516] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.973516] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.973516] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[    0.973516] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
[    0.973685] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.977516] ACPI: WMI: Mapper loaded
[    0.977516] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.977516] pnp: PnP ACPI init
[    0.977516] ACPI: bus type pnp registered
[    1.002443] pnp: PnP ACPI: found 10 devices
[    1.002443] ACPI: ACPI bus type pnp unregistered
[    1.002443] SCSI subsystem initialized
[    1.002443] libata version 3.00 loaded.
[    1.002443] PCI: Using ACPI for IRQ routing
[    1.012970] NET: Registered protocol family 8
[    1.012973] NET: Registered protocol family 20
[    1.030375] ACPI: RTC can wake from S4
[    1.054312] system 00:01: ioport range 0x164e-0x164f has been reserved
[    1.054316] system 00:01: ioport range 0x600-0x60f has been reserved
[    1.054319] system 00:01: ioport range 0x610-0x610 has been reserved
[    1.054322] system 00:01: ioport range 0x800-0x80f has been reserved
[    1.054325] system 00:01: ioport range 0x810-0x817 has been reserved
[    1.054329] system 00:01: ioport range 0x400-0x47f has been reserved
[    1.054332] system 00:01: ioport range 0x500-0x53f has been reserved
[    1.054335] system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[    1.054339] system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
[    1.054342] system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
[    1.054346] system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
[    1.054349] system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
[    1.054353] system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
[    1.054356] system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved
[    1.054360] system 00:01: iomem range 0x32000000-0x320000ff could not be reserved
[    1.082445] PCI: Failed to allocate mem resource #6:20000@90000000 for 0000:01:00.0
[    1.082445] PCI: Bridge: 0000:00:01.0
[    1.082445]   IO window: 5000-5fff
[    1.082445]   MEM window: 0x90000000-0x92ffffff
[    1.082445]   PREFETCH window: 0x0000000080000000-0x000000008fffffff
[    1.082445] PCI: Bridge: 0000:00:1c.0
[    1.082445]   IO window: 4000-4fff
[    1.082445]   MEM window: 0x9a300000-0x9b2fffff
[    1.082445]   PREFETCH window: 0x0000000093000000-0x0000000093ffffff
[    1.082445] PCI: Bridge: 0000:00:1c.1
[    1.082445]   IO window: 3000-3fff
[    1.082445]   MEM window: 0x99300000-0x9a2fffff
[    1.082445]   PREFETCH window: 0x0000000094000000-0x0000000094ffffff
[    1.082445] PCI: Bridge: 0000:00:1c.2
[    1.082445]   IO window: 2000-2fff
[    1.082446]   MEM window: 0x98200000-0x992fffff
[    1.082446]   PREFETCH window: 0x0000000095000000-0x0000000095ffffff
[    1.082446] PCI: Bridge: 0000:00:1c.3
[    1.082446]   IO window: 1000-1fff
[    1.082446]   MEM window: 0x97100000-0x981fffff
[    1.082446]   PREFETCH window: 0x0000000096000000-0x0000000096ffffff
[    1.082446] PCI: Bridge: 0000:00:1e.0
[    1.082446]   IO window: disabled.
[    1.082446]   MEM window: 0x97000000-0x970fffff
[    1.082446]   PREFETCH window: disabled.
[    1.082446] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    1.082446] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    1.082446] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    1.082446] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.082446] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[    1.082446] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    1.082446] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[    1.082446] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    1.082446] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[    1.082446] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    1.082446] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    1.082446] NET: Registered protocol family 2
[    1.133357] Switched to high resolution mode on CPU 1
[    1.134995] Switched to high resolution mode on CPU 0
[    1.154112] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    1.154112] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.154112] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    1.154112] TCP: Hash tables configured (established 131072 bind 65536)
[    1.154112] TCP reno registered
[    1.177210] NET: Registered protocol family 1
[    1.177325] checking if image is initramfs... it is
[    2.945221] Freeing initrd memory: 17944k freed
[    2.947568] audit: initializing netlink socket (disabled)
[    2.947568] type=2000 audit(1213206338.312:1): initialized
[    2.951571] highmem bounce pool size: 64 pages
[    2.955568] VFS: Disk quotas dquot_6.5.1
[    2.955568] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.955568] msgmni has been set to 1747 for ipc namespace c04fe5c0
[    2.955568] io scheduler noop registered
[    2.955568] io scheduler anticipatory registered
[    2.955568] io scheduler deadline registered
[    2.955568] io scheduler cfq registered (default)
[    2.955568] pci 0000:01:00.0: Boot video device
[    2.955568] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    2.955568] assign_interrupt_mode Found MSI capability
[    2.955568] Allocate Port Service[0000:00:01.0:pcie00]
[    2.955568] Allocate Port Service[0000:00:01.0:pcie02]
[    2.955568] Allocate Port Service[0000:00:01.0:pcie03]
[    2.955568] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    2.955568] assign_interrupt_mode Found MSI capability
[    2.955568] Allocate Port Service[0000:00:1c.0:pcie00]
[    2.955569] Allocate Port Service[0000:00:1c.0:pcie02]
[    2.955569] Allocate Port Service[0000:00:1c.0:pcie03]
[    2.955569] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    2.955569] assign_interrupt_mode Found MSI capability
[    2.955569] Allocate Port Service[0000:00:1c.1:pcie00]
[    2.955569] Allocate Port Service[0000:00:1c.1:pcie02]
[    2.955569] Allocate Port Service[0000:00:1c.1:pcie03]
[    2.955569] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    2.955569] assign_interrupt_mode Found MSI capability
[    2.955569] Allocate Port Service[0000:00:1c.2:pcie00]
[    2.955569] Allocate Port Service[0000:00:1c.2:pcie02]
[    2.955569] Allocate Port Service[0000:00:1c.2:pcie03]
[    2.955569] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    2.955569] assign_interrupt_mode Found MSI capability
[    2.955569] Allocate Port Service[0000:00:1c.3:pcie00]
[    2.955569] Allocate Port Service[0000:00:1c.3:pcie02]
[    2.955569] Allocate Port Service[0000:00:1c.3:pcie03]
[    2.955569] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.955569] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    2.983568] vesafb: framebuffer at 0x91000000, mapped to 0xf8880000, using 6144k, total 14336k
[    2.983568] vesafb: mode is 1024x768x32, linelength=4096, pages=1
[    2.983568] vesafb: protected mode interface info at c000:b900
[    2.983568] vesafb: pmi: set display start = c00cb963, set palette = c00cb9be
[    2.983568] vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
[    2.983568] vesafb: scrolling: redraw
[    2.983568] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    3.039567] Console: switching to colour frame buffer device 128x48
[    3.091564] fb0: VESA VGA frame buffer device
[    3.096220] ACPI: AC Adapter [AC] (on-line)
[    3.120876] ACPI: Battery Slot [BAT0] (battery absent)
[    3.124816] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    3.124816] ACPI: Power Button (FF) [PWRF]
[    3.124816] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/PNP0C0C:00/input/input1
[    3.124816] ACPI: Power Button (CM) [PWRB]
[    3.124816] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/PNP0C0D:00/input/input2
[    3.124816] ACPI: Lid Switch [LID0]
[    3.124816] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/PNP0C0E:00/input/input3
[    3.124816] ACPI: Sleep Button (CM) [SLPB]
[    3.124816] ACPI: SSDT 7FE88C90, 01EA (r1  PmRef  Cpu0Ist     3000 INTL 20051117)
[    3.124816] ACPI: SSDT 7FE87610, 05D7 (r1  PmRef  Cpu0Cst     3001 INTL 20051117)
[    3.124816] Monitor-Mwait will be used to enter C-1 state
[    3.124816] Monitor-Mwait will be used to enter C-2 state
[    3.124816] Monitor-Mwait will be used to enter C-3 state
[    3.124816] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    3.124816] ACPI: ACPI0007:00 is registered as cooling_device0
[    3.124816] ACPI: Processor [CPU0] (supports 8 throttling states)
[    3.128817] ACPI: SSDT 7FE88F10, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20051117)
[    3.128817] ACPI: SSDT 7FE8AD10, 0083 (r1  PmRef  Cpu1Cst     3000 INTL 20051117)
[    3.128817] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    3.128865] ACPI: ACPI0007:01 is registered as cooling_device1
[    3.128870] ACPI: Processor [CPU1] (supports 8 throttling states)
[    3.151497] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    3.166274] ACPI: Thermal Zone [TZ01] (40 C)
[    3.238273] Non-volatile memory driver v1.2
[    3.238273] brd: module loaded
[    3.238273] loop: module loaded
[    3.238273] nbd: registered device at major 43
[    3.243779] Driver 'sd' needs updating - please use bus_type methods
[    3.243779] Driver 'sr' needs updating - please use bus_type methods
[    3.243779] ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 20 (level, low) -> IRQ 20
[    3.243779] PCI: Setting latency timer of device 0000:07:00.0 to 64
[    3.295777] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[97000000-970007ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    3.301370] video1394: Installed video1394 module
[    3.301370] ieee1394: raw1394: /dev/raw1394 device initialized
[    3.301370] NOTE: The dv1394 driver is unsupported and may be removed in a future Linux release. Use raw1394 instead.
[    3.301370] eth1394: eth0: IPv4 over IEEE 1394 (fw-host0)
[    3.301370] NFTL driver: nftlcore.c $Revision: 1.98 $, nftlmount.c $Revision: 1.41 $
[    3.301370] INFTL: inftlcore.c $Revision: 1.19 $, inftlmount.c $Revision: 1.18 $
[    3.301370] SSFDC read-only Flash Translation layer
[    3.301370] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    3.340270] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.340276] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.344034] mice: PS/2 mouse device common for all mice
[    3.344034] i2c /dev entries driver
[    3.346025] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
[    3.372249] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    3.427242] EISA: Probing bus 0 at eisa.0
[    3.427242] Cannot allocate resource for EISA slot 1
[    3.427242] Cannot allocate resource for EISA slot 2
[    3.427242] Cannot allocate resource for EISA slot 3
[    3.427242] Cannot allocate resource for EISA slot 4
[    3.427242] Cannot allocate resource for EISA slot 5
[    3.427242] Cannot allocate resource for EISA slot 6
[    3.427242] EISA: Detected 0 cards.
[    3.427242] cpuidle: using governor ladder
[    3.427242] cpuidle: using governor menu
[    3.427242] sdhci: Secure Digital Host Controller Interface driver
[    3.427242] sdhci: Copyright(c) Pierre Ossman
[    3.427242] sdhci: SDHCI controller found at 0000:07:00.1 [1180:0822] (rev 22)
[    3.427242] ACPI: PCI Interrupt 0000:07:00.1[B] -> GSI 22 (level, low) -> IRQ 22
[    3.428192] mmc0: Will use DMA mode even though HW doesn't fully claim to support it.
[    3.428200] PCI: Setting latency timer of device 0000:07:00.1 to 64
[    3.424243] Marking TSC unstable due to: TSC halts in idle.
[    3.428264] Registered led device: mmc0
[    3.428287] mmc0: SDHCI at 0x97000b00 irq 22 DMA
[    3.464305] Advanced Linux Sound Architecture Driver Version 1.0.16.
[    3.464308] ALSA device list:
[    3.464310]   No soundcards found.
[    3.464876] Using IPI No-Shortcut mode
[    3.465090] registered taskstats version 1
[    3.465213] /home/maxim/software/kernel/linux-2.6/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    3.465217] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.465219] EDD information not available.
[    3.465261] Freeing unused kernel memory: 368k freed
[    4.187227] Clocksource tsc unstable (delta = -260807719 ns)
[    4.353067] APIC error on CPU0: 00(40)
[    4.632796] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[b64057b700023f7c]
[    4.772237] fuse init (API version 7.9)
[    4.878962] usbcore: registered new interface driver usbfs
[    4.878962] usbcore: registered new interface driver hub
[    4.883158] usbcore: registered new device driver usb
[    4.883158] USB Universal Host Controller Interface driver v3.0
[    4.883158] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[    4.883158] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[    4.883158] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.883158] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.883158] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000060c0
[    4.887470] usb usb1: configuration #1 chosen from 1 choice
[    4.887500] hub 1-0:1.0: USB hub found
[    4.887507] hub 1-0:1.0: 2 ports detected
[    4.937650] APIC error on CPU0: 40(40)
[    4.993744] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[    4.993760] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[    4.993765] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.993791] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    4.993828] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000060a0
[    4.993939] usb usb2: configuration #1 chosen from 1 choice
[    4.993971] hub 2-0:1.0: USB hub found
[    4.993978] hub 2-0:1.0: 2 ports detected
[    5.106060] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[    5.106060] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[    5.106060] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    5.106060] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 3
[    5.110059] ehci_hcd 0000:00:1a.7: debug port 1
[    5.110059] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[    5.110059] ehci_hcd 0000:00:1a.7: irq 18, io mem 0x9b304c00
[    5.126765] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    5.126890] usb usb3: configuration #1 chosen from 1 choice
[    5.126923] hub 3-0:1.0: USB hub found
[    5.126932] hub 3-0:1.0: 4 ports detected
[    5.236005] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    5.236005] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    5.236005] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.236005] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    5.236005] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00006080
[    5.236005] usb usb4: configuration #1 chosen from 1 choice
[    5.236005] hub 4-0:1.0: USB hub found
[    5.236005] hub 4-0:1.0: 2 ports detected
[    5.342535] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    5.342535] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    5.342535] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.342535] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    5.342535] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00006060
[    5.342535] usb usb5: configuration #1 chosen from 1 choice
[    5.342535] hub 5-0:1.0: USB hub found
[    5.342535] hub 5-0:1.0: 2 ports detected
[    5.450248] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    5.450248] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    5.450248] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.450248] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    5.450248] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006040
[    5.450248] usb usb6: configuration #1 chosen from 1 choice
[    5.450248] hub 6-0:1.0: USB hub found
[    5.450248] hub 6-0:1.0: 2 ports detected
[    5.553538] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    5.553538] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    5.553538] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.553538] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
[    5.555539] ehci_hcd 0000:00:1d.7: debug port 1
[    5.555547] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    5.555553] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x9b304800
[    5.573706] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    5.574279] usb usb7: configuration #1 chosen from 1 choice
[    5.574327] hub 7-0:1.0: USB hub found
[    5.574341] hub 7-0:1.0: 6 ports detected
[    5.676529] ata_piix 0000:00:1f.1: version 2.12
[    5.676529] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[    5.676529] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    5.676529] scsi0 : ata_piix
[    5.676529] scsi1 : ata_piix
[    5.676529] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60e0 irq 14
[    5.676529] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60e8 irq 15
[    5.840688] ata1.00: ATAPI: HL-DT-ST DVDRAM GSA-T20N, WP03, max UDMA/33
[    5.856575] ata1.00: configured for UDMA/33
[    5.948734] usb 7-4: new high speed USB device using ehci_hcd and address 2
[    6.046598] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-T20N  WP03 PQ: 0 ANSI: 5
[    6.060169] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    6.060169] Uniform CD-ROM driver Revision: 3.20
[    6.060169] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    6.060169] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    6.060420] ahci 0000:00:1f.2: version 3.0
[    6.060420] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[    6.094890] usb 7-4: configuration #1 chosen from 1 choice
[    6.525684] APIC error on CPU0: 40(40)
[    7.077302] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x3 impl SATA mode
[    7.077309] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
[    7.077319] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    7.081281] scsi2 : ahci
[    7.081281] scsi3 : ahci
[    7.081281] scsi4 : ahci
[    7.081281] ata3: SATA max UDMA/133 abar m2048@0x9b304000 port 0x9b304100 irq 218
[    7.081281] ata4: SATA max UDMA/133 abar m2048@0x9b304000 port 0x9b304180 irq 218
[    7.081281] ata5: DUMMY
[    7.407172] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.407962] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[    7.788416] ata3.00: ATA-8: TOSHIBA MK1646GSX, LB113J, max UDMA/100
[    7.788416] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    7.789908] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[    7.790616] ata3.00: configured for UDMA/100
[    8.109551] ata4: SATA link down (SStatus 0 SControl 300)
[    8.107954] scsi 2:0:0:0: Direct-Access     ATA      TOSHIBA MK1646GS LB11 PQ: 0 ANSI: 5
[    8.107954] sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    8.107954] sd 2:0:0:0: [sda] Write Protect is off
[    8.107954] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    8.107954] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.107954] sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    8.107954] sd 2:0:0:0: [sda] Write Protect is off
[    8.107954] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    8.107954] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.107954]  sda: sda1 sda2 sda3 sda4
[    8.215293] sd 2:0:0:0: [sda] Attached SCSI disk
[    8.215293] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    8.639463] PM: Starting manual resume from disk
[    8.639463] PM: Resume from partition 8:3
[    8.639463] PM: Checking hibernation image.
[    8.639898] PM: Resume from disk failed.
[    8.659499] EXT3-fs: INFO: recovery required on readonly filesystem.
[    8.659499] EXT3-fs: write access will be enabled during recovery.
[    9.879898] EXT3-fs: sda4: orphan cleanup on readonly fs
[    9.879898] ext3_orphan_cleanup: deleting unreferenced inode 2302780
[    9.879898] ext3_orphan_cleanup: deleting unreferenced inode 81941
[    9.879898] EXT3-fs: sda4: 2 orphan inodes deleted
[    9.879898] EXT3-fs: recovery complete.
[    9.879898] kjournald starting.  Commit interval 5 seconds
[    9.908146] EXT3-fs: mounted filesystem with ordered data mode.
[   15.970367] APIC error on CPU0: 40(40)
[   16.579513] nvidia: module license 'NVIDIA' taints kernel.
[   16.738573] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
[   16.738573] iwl3945: Copyright(c) 2003-2008 Intel Corporation
[   16.738573] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[   16.738573] PCI: Setting latency timer of device 0000:06:00.0 to 64
[   16.738573] iwl3945: Detected Intel Wireless WiFi Link 3945BG
[   16.773771] iTCO_vendor_support: vendor-support=0
[   16.824683] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
[   16.824795] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x0460)
[   16.824849] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   16.996859] iwl3945: Tunable channels: 13 802.11bg, 0 802.11a channels
[   17.025722] phy0: Selected rate control algorithm 'iwl-3945-rs'
[   17.031377] acer-wmi: Acer Laptop ACPI-WMI Extras version 0.1
[   17.055173] ACPI: PCI interrupt for device 0000:06:00.0 disabled
[   17.316131] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   17.316144] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   17.316578] NVRM: loading NVIDIA UNIX x86 Kernel Module  173.14.05  Mon May 19 00:06:12 PDT 2008
[   17.697879] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input5
[   17.756691] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[   17.756691] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   17.766922] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input6
[   19.125978] Adding 2923820k swap on /dev/sda3.  Priority:-1 extents:1 across:2923820k
[   27.566350] APIC error on CPU0: 40(40)
[   28.644850] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[   28.645043] EXT3 FS on sda4, internal journal
[   29.669395] ip_tables: (C) 2000-2006 Netfilter Core Team
[   29.842283] sensors[3549]: segfault at 46 ip b7e792cd sp bf8a5d50 error 4 in libc-2.7.so[b7e1f000+149000]
[   29.843635] sensors[3550]: segfault at 46 ip b7ec42cd sp bfaf2fa0 error 4 in libc-2.7.so[b7e6a000+149000]
[   31.193512] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
[   32.951283] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[   32.951283] PM: Writing back config space on device 0000:06:00.0 at offset 1 (was 100002, writing 100006)
[   32.951283] firmware: requesting iwlwifi-3945-1.ucode
[   33.143609] Bluetooth: Core ver 2.11
[   33.145706] NET: Registered protocol family 31
[   33.145984] Bluetooth: HCI device and connection manager initialized
[   33.146308] Bluetooth: HCI socket layer initialized
[   33.196390] Bluetooth: L2CAP ver 2.9
[   33.196390] Bluetooth: L2CAP socket layer initialized
[   33.357103] Bluetooth: RFCOMM socket layer initialized
[   33.357136] Bluetooth: RFCOMM TTY layer initialized
[   33.357140] Bluetooth: RFCOMM ver 1.8
[   35.015773] NET: Registered protocol family 10
[   35.015773] lo: Disabled Privacy Extensions
[   35.019449] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   60.167205] CPU0 attaching NULL sched-domain.
[   60.167215] CPU1 attaching NULL sched-domain.
[   60.168965] CPU0 attaching sched-domain:
[   60.168965]  domain 0: span 0-1
[   60.168965]   groups: 0 1
[   60.168965] CPU1 attaching sched-domain:
[   60.168965]  domain 0: span 0-1
[   60.168965]   groups: 1 0
[   60.714050] NET: Registered protocol family 17
[   61.517941] ACPI: PCI interrupt for device 0000:06:00.0 disabled
[   65.315001] APIC error on CPU0: 40(40)
[   65.789312] APIC error on CPU0: 40(40)
[   84.701358] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[   84.701358] PM: Writing back config space on device 0000:06:00.0 at offset 1 (was 100002, writing 100006)
[   84.778095] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   87.270433] wlan0: Initial auth_alg=0
[   87.270433] wlan0: authenticate with AP 00:1b:9e:d8:77:02
[   87.273477] wlan0: RX authentication from 00:1b:9e:d8:77:02 (alg=0 transaction=2 status=0)
[   87.273477] wlan0: authenticated
[   87.273477] wlan0: associate with AP 00:1b:9e:d8:77:02
[   87.275823] wlan0: RX AssocResp from 00:1b:9e:d8:77:02 (capab=0x411 status=0 aid=1)
[   87.275823] wlan0: associated
[   87.275823] wlan0: switched to short barker preamble (BSSID=00:1b:9e:d8:77:02)
[   87.276185] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   92.713277] APIC error on CPU0: 40(40)
[   97.885625] wlan0: no IPv6 routers present
[  111.766658] wlan0: no IPv6 routers present
[  112.121332] APIC error on CPU0: 40(40)
[  144.876825] APIC error on CPU0: 40(40)
[  158.676958] APIC error on CPU0: 40(40)
[  212.915533] APIC error on CPU0: 40(40)
[  290.079923] APIC error on CPU0: 40(40)
[  290.632507] APIC error on CPU0: 40(40)
[  296.557068] APIC error on CPU0: 40(40)
[  303.989147] APIC error on CPU0: 40(40)
[  305.782793] APIC error on CPU0: 40(40)
[  307.150566] APIC error on CPU0: 40(40)
[  310.248346] APIC error on CPU0: 40(40)
[  310.657006] APIC error on CPU0: 40(40)
[  311.453595] APIC error on CPU0: 40(40)
[  317.468024] APIC error on CPU0: 40(40)
[  321.284080] APIC error on CPU0: 40(40)
[  328.179853] APIC error on CPU0: 40(40)
[  330.127038] APIC error on CPU0: 40(40)
[  332.437435] APIC error on CPU0: 40(40)
[  335.326931] APIC error on CPU0: 40(40)
[  335.881538] APIC error on CPU0: 40(40)
[  337.790227] APIC error on CPU0: 40(40)
[  368.373446] APIC error on CPU0: 40(40)
[  369.809138] APIC error on CPU0: 40(40)
[  374.289855] APIC error on CPU0: 40(40)
[  375.768238] APIC error on CPU0: 40(40)
[  382.440748] APIC error on CPU0: 40(40)
[  383.159443] APIC error on CPU0: 40(40)
[  383.529522] APIC error on CPU0: 40(40)
[  383.906913] APIC error on CPU0: 40(40)
[  384.356990] APIC error on CPU0: 40(40)
[  384.610941] APIC error on CPU0: 40(40)
[  386.305185] APIC error on CPU0: 40(40)
[  386.935949] APIC error on CPU0: 40(40)
[  390.071741] APIC error on CPU0: 40(40)
[  390.403979] APIC error on CPU0: 40(40)
[  391.114519] APIC error on CPU0: 40(40)
[  391.528138] APIC error on CPU0: 40(40)
[  403.677688] APIC error on CPU0: 40(40)
[  404.140181] APIC error on CPU0: 40(40)
[  406.270920] APIC error on CPU0: 40(40)
[  406.927867] APIC error on CPU0: 40(40)
[  418.880757] APIC error on CPU0: 40(40)
[  419.235211] APIC error on CPU0: 40(40)
[  437.974455] APIC error on CPU0: 40(40)
[  438.193878] APIC error on CPU0: 40(40)
[  443.974790] APIC error on CPU0: 40(40)
[  444.177027] APIC error on CPU0: 40(40)
[  479.469645] APIC error on CPU0: 40(40)
[  479.720979] APIC error on CPU0: 40(40)
[  497.925734] APIC error on CPU0: 40(40)
[  498.202985] APIC error on CPU0: 40(40)
[  526.922424] APIC error on CPU0: 40(40)
[  527.607409] APIC error on CPU0: 40(40)
[  715.960235] APIC error on CPU0: 40(40)
[  716.232556] APIC error on CPU0: 40(40)
[  753.480442] APIC error on CPU0: 40(40)
[  753.820830] APIC error on CPU0: 40(40)
[  774.693756] APIC error on CPU0: 40(40)
[  774.867494] APIC error on CPU0: 40(40)
[  815.787137] APIC error on CPU0: 40(40)
[  816.308363] APIC error on CPU0: 40(40)
[  841.546917] APIC error on CPU0: 40(40)
[  842.082173] APIC error on CPU0: 40(40)
[  847.758887] ACPI: PCI interrupt for device 0000:06:00.0 disabled
[  857.924362] APIC error on CPU0: 40(40)
[  859.141021] APIC error on CPU0: 40(40)
[  863.096755] APIC error on CPU0: 40(40)
[  863.468026] APIC error on CPU0: 40(40)
[  872.206205] APIC error on CPU0: 40(40)
[  872.563850] APIC error on CPU0: 40(40)
[  884.523961] APIC error on CPU0: 40(40)
[  884.642784] APIC error on CPU0: 40(40)
[  894.188583] APIC error on CPU0: 40(40)
[  894.546067] APIC error on CPU0: 40(40)
[  899.663115] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
[  899.663115] iwl3945: Copyright(c) 2003-2008 Intel Corporation
[  899.663115] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[  899.663115] PCI: Setting latency timer of device 0000:06:00.0 to 64
[  899.663115] iwl3945: U iwl3945_pci_probe pci_resource_len = 0x00001000
[  899.663115] iwl3945: U iwl3945_pci_probe pci_resource_base = f903c000
[  899.663115] iwl3945: Detected Intel Wireless WiFi Link 3945BG
[  899.663115] iwl3945: U iwl3945_set_rxon_channel Staging channel set to 6 [0]
[  899.743741] iwl3945: U iwl3945_pci_probe MAC address: 00:1b:77:f1:7c:29
[  899.743741] iwl3945: U iwl3945_init_channel_map Initializing regulatory info from EEPROM
[  899.743741] iwl3945: U iwl3945_init_channel_map Parsing data for 56 channels.
[  899.743741] iwl3945: U iwl3945_init_channel_map Ch. 1 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[  899.743813] iwl3945: U iwl3945_init_channel_map Ch. 2 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[  899.744078] iwl3945: U iwl3945_init_channel_map Ch. 3 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[  899.744345] iwl3945: U iwl3945_init_channel_map Ch. 4 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[  899.744611] iwl3945: U iwl3945_init_channel_map Ch. 5 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[  899.747743] iwl3945: U iwl3945_init_channel_map Ch. 6 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[  899.747743] iwl3945: U iwl3945_init_channel_map Ch. 7 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[  899.747743] iwl3945: U iwl3945_init_channel_map Ch. 8 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[  899.747743] iwl3945: U iwl3945_init_channel_map Ch. 9 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[  899.747743] iwl3945: U iwl3945_init_channel_map Ch. 10 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[  899.747743] iwl3945: U iwl3945_init_channel_map Ch. 11 [2.4GHz] VALID IBSS ACTIVE WIDE (0x2b 15dBm): Ad-Hoc supported
[  899.747743] iwl3945: U iwl3945_init_channel_map Ch. 12 [2.4GHz] VALID WIDE (0x21 15dBm): Ad-Hoc not supported
[  899.747743] iwl3945: U iwl3945_init_channel_map Ch. 13 [2.4GHz] VALID WIDE (0x21 15dBm): Ad-Hoc not supported
[  899.747743] iwl3945: U iwl3945_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
[  899.747743] iwl3945: U iwl3945_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
[  899.747743] iwl3945: U iwl3945_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
[  899.747743] iwl3945: U iwl3945_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
[  899.747854] iwl3945: U iwl3945_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
[  899.748064] iwl3945: U iwl3945_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
[  899.748275] iwl3945: U iwl3945_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
[  899.748483] iwl3945: U iwl3945_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
[  899.748694] iwl3945: U iwl3945_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
[  899.751742] iwl3945: U iwl3945_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
[  899.751742] iwl3945: U iwl3945_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
[  899.751743] iwl3945: U iwl3945_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
[  899.752264] iwl3945: U iwl3945_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 36 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 40 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 44 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 48 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 52 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 56 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 60 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 64 Flags 0 [5.2GHz] - No traffic
[  899.755743] iwl3945: U iwl3945_init_channel_map Ch. 100 Flags 0 [5.2GHz] - No traffic
[  899.755818] iwl3945: U iwl3945_init_channel_map Ch. 104 Flags 0 [5.2GHz] - No traffic
[  899.756043] iwl3945: U iwl3945_init_channel_map Ch. 108 Flags 0 [5.2GHz] - No traffic
[  899.756254] iwl3945: U iwl3945_init_channel_map Ch. 112 Flags 0 [5.2GHz] - No traffic
[  899.756463] iwl3945: U iwl3945_init_channel_map Ch. 116 Flags 0 [5.2GHz] - No traffic
[  899.756672] iwl3945: U iwl3945_init_channel_map Ch. 120 Flags 0 [5.2GHz] - No traffic
[  899.759741] iwl3945: U iwl3945_init_channel_map Ch. 124 Flags 0 [5.2GHz] - No traffic
[  899.759742] iwl3945: U iwl3945_init_channel_map Ch. 128 Flags 0 [5.2GHz] - No traffic
[  899.759742] iwl3945: U iwl3945_init_channel_map Ch. 132 Flags 0 [5.2GHz] - No traffic
[  899.760318] iwl3945: U iwl3945_init_channel_map Ch. 136 Flags 0 [5.2GHz] - No traffic
[  899.763744] iwl3945: U iwl3945_init_channel_map Ch. 140 Flags 0 [5.2GHz] - No traffic
[  899.763744] iwl3945: U iwl3945_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
[  899.763744] iwl3945: U iwl3945_init_channel_map Ch. 149 Flags 0 [5.2GHz] - No traffic
[  899.763744] iwl3945: U iwl3945_init_channel_map Ch. 153 Flags 0 [5.2GHz] - No traffic
[  899.763744] iwl3945: U iwl3945_init_channel_map Ch. 157 Flags 0 [5.2GHz] - No traffic
[  899.763744] iwl3945: U iwl3945_init_channel_map Ch. 161 Flags 0 [5.2GHz] - No traffic
[  899.763744] iwl3945: U iwl3945_init_channel_map Ch. 165 Flags 0 [5.2GHz] - No traffic
[  899.763744] iwl3945: U iwl3945_hw_reg_txpower_get_temperature Temperature: 260
[  899.763744] iwl3945: U iwl3945_hw_reg_init_channel_groups Initializing factory calib info from EEPROM
[  899.763744] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 1 mapped to grp 0
[  899.763744] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 1: -22 [260]
[  899.763744] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 2 mapped to grp 0
[  899.763744] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 2: -22 [260]
[  899.763744] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 3 mapped to grp 0
[  899.763744] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 3: -22 [260]
[  899.763744] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 4 mapped to grp 0
[  899.763744] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 4: -22 [260]
[  899.763744] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 5 mapped to grp 0
[  899.763744] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 5: -22 [260]
[  899.763744] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 6 mapped to grp 0
[  899.763744] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 6: -22 [260]
[  899.763744] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 7 mapped to grp 0
[  899.763744] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 7: -22 [260]
[  899.763744] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 8 mapped to grp 0
[  899.763744] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 8: -22 [260]
[  899.763744] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 9 mapped to grp 0
[  899.763744] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 9: -22 [260]
[  899.763744] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 10 mapped to grp 0
[  899.763744] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 10: -22 [260]
[  899.763744] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 11 mapped to grp 0
[  899.763744] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 11: -22 [260]
[  899.763744] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 12 mapped to grp 0
[  899.763744] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 12: -22 [260]
[  899.763744] iwl3945: U iwl3945_hw_reg_get_ch_grp_index Chnl 13 mapped to grp 0
[  899.763744] iwl3945: U iwl3945_txpower_set_from_eeprom Delta index for channel 13: -22 [260]
[  899.763744] iwl3945: U iwl3945_init_geos Channel 1 Freq=2412[2.4GHz] valid flag=00
[  899.763744] iwl3945: U iwl3945_init_geos Channel 2 Freq=2417[2.4GHz] valid flag=00
[  899.763744] iwl3945: U iwl3945_init_geos Channel 3 Freq=2422[2.4GHz] valid flag=00
[  899.763744] iwl3945: U iwl3945_init_geos Channel 4 Freq=2427[2.4GHz] valid flag=00
[  899.763744] iwl3945: U iwl3945_init_geos Channel 5 Freq=2432[2.4GHz] valid flag=00
[  899.763744] iwl3945: U iwl3945_init_geos Channel 6 Freq=2437[2.4GHz] valid flag=00
[  899.763744] iwl3945: U iwl3945_init_geos Channel 7 Freq=2442[2.4GHz] valid flag=00
[  899.763744] iwl3945: U iwl3945_init_geos Channel 8 Freq=2447[2.4GHz] valid flag=00
[  899.763744] iwl3945: U iwl3945_init_geos Channel 9 Freq=2452[2.4GHz] valid flag=00
[  899.763744] iwl3945: U iwl3945_init_geos Channel 10 Freq=2457[2.4GHz] valid flag=00
[  899.763744] iwl3945: U iwl3945_init_geos Channel 11 Freq=2462[2.4GHz] valid flag=00
[  899.763744] iwl3945: U iwl3945_init_geos Channel 12 Freq=2467[2.4GHz] valid flag=06
[  899.763744] iwl3945: U iwl3945_init_geos Channel 13 Freq=2472[2.4GHz] valid flag=06
[  899.763744] iwl3945: Tunable channels: 13 802.11bg, 0 802.11a channels
[  899.775743] phy1: Selected rate control algorithm 'iwl-3945-rs'
[  899.807745] iwl3945: U iwl3945_mac_start enter
[  899.807745] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[  899.807745] firmware: requesting iwlwifi-3945-1.ucode
[  899.827745] iwl3945: U iwl3945_read_ucode Got firmware 'iwlwifi-3945-1.ucode' file (149652 bytes) from disk
[  899.827745] iwl3945: U iwl3945_read_ucode f/w package hdr ucode version = 0x20e0105
[  899.827745] iwl3945: U iwl3945_read_ucode f/w package hdr runtime inst size = 80524
[  899.827745] iwl3945: U iwl3945_read_ucode f/w package hdr runtime data size = 32768
[  899.827745] iwl3945: U iwl3945_read_ucode f/w package hdr init inst size = 2668
[  899.827745] iwl3945: U iwl3945_read_ucode f/w package hdr init data size = 32768
[  899.827745] iwl3945: U iwl3945_read_ucode f/w package hdr boot inst size = 900
[  899.827745] iwl3945: U iwl3945_read_ucode Copying (but not loading) uCode instr len 80524
[  899.827745] iwl3945: U iwl3945_read_ucode uCode instr buf vaddr = 0xec720000, paddr = 0x2c720000
[  899.827745] iwl3945: U iwl3945_read_ucode Copying (but not loading) uCode data len 32768
[  899.827745] iwl3945: U iwl3945_read_ucode Copying (but not loading) init instr len 2668
[  899.827745] iwl3945: U iwl3945_read_ucode Copying (but not loading) init data len 32768
[  899.827745] iwl3945: U iwl3945_read_ucode Copying (but not loading) boot instr len 900
[  899.827745] iwl3945: U iwl3945_power_init_handle Initialize power 
[  899.827745] iwl3945: U iwl3945_power_init_handle adjust power command flags
[  899.827745] iwl3945: U iwl3945_hw_nic_init HW Revision ID = 0x2
[  899.827745] iwl3945: U iwl3945_hw_nic_init 3945 RADIO-MM type
[  899.827745] iwl3945: U iwl3945_hw_nic_init SKU OP mode is basic
[  899.827745] iwl3945: U iwl3945_hw_nic_init 3945ABG revision is 0xF1
[  899.827745] iwl3945: U iwl3945_hw_nic_init Card M type B version is 0x2
[  899.827929] iwl3945: U iwl3945_load_bsm Begin load bsm
[  899.831773] iwl3945: U iwl3945_verify_bsm Begin verify bsm
[  899.831773] iwl3945: U iwl3945_verify_bsm BSM bootstrap uCode image OK
[  899.831773] iwl3945: U iwl3945_load_bsm BSM write complete, poll 1 iterations
[  899.831773] iwl3945: U __iwl3945_up iwl3945 is coming up
[  899.831773] iwl3945: U iwl3945_mac_start Start UP work.
[  899.843748] iwl3945: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
[  899.843748] iwl3945: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
[  899.843748] iwl3945: I iwl3945_rx_reply_alive Initialization Alive received.
[  899.851791] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 900
[  899.851886] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 2668
[  899.852163] iwl3945: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
[  899.852166] iwl3945: U iwl3945_init_alive_start Initialization Alive received.
[  899.852212] iwl3945: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
[  899.856566] iwl3945: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
[  899.856579] iwl3945: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
[  899.856582] iwl3945: I iwl3945_rx_reply_alive Runtime Alive received.
[  899.856625] iwl3945: I iwl3945_disable_events Selected uCode log events may be disabled
[  899.856627] iwl3945: I iwl3945_disable_events   by writing "1"s into disable bitmap
[  899.856630] iwl3945: I iwl3945_disable_events   in SRAM at 0x8015f4, size 47 u32s
[  899.871747] iwl3945: U iwl3945_alive_start Runtime Alive received.
[  899.871747] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 900
[  899.871747] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 2668
[  899.871747] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 80524
[  899.879745] iwl3945: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
[  899.879745] iwl3945: U iwl3945_alive_start RFKILL status: 0x1
[  899.879745] iwl3945: U iwl3945_update_power_cmd Flags value = 0x00000008
[  899.879745] iwl3945: U iwl3945_update_power_cmd Tx timeout = 0
[  899.879745] iwl3945: U iwl3945_update_power_cmd Rx timeout = 0
[  899.879745] iwl3945: U iwl3945_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
[  899.879745] iwl3945: U iwl3945_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 36 bytes at 0[0]:4
[  899.879745] iwl3945: I iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
[  899.879745] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
[  899.879766] iwl3945: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
[  899.880124] iwl3945: U iwl3945_commit_rxon Sending RXON
[  899.880126] * without RXON_FILTER_ASSOC_MSK
[  899.880127] * channel = 1
[  899.880128] * bssid = 00:00:00:00:00:00
[  899.880135] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48 bytes at 2[2]:4
[  899.883742] iwl3945: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
[  899.883742] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 243 dsp 119 rate code 0x0d
[  899.883742] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 243 dsp 119 rate code 0x0f
[  899.883742] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 243 dsp 119 rate code 0x05
[  899.883742] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 243 dsp 119 rate code 0x07
[  899.883742] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 243 dsp 119 rate code 0x09
[  899.883742] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 243 dsp 119 rate code 0x0b
[  899.883742] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 243 dsp 119 rate code 0x01
[  899.883742] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 243 dsp 111 rate code 0x03
[  899.883742] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp 125 rate code 0x0a
[  899.883742] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp 125 rate code 0x14
[  899.883742] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp 125 rate code 0x37
[  899.883742] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 147 dsp 125 rate code 0x6e
[  899.883742] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0403, 56 bytes at 3[3]:4
[  899.883742] iwl3945: I iwl3945_rx_handle r 6 i 5 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
[  899.884364] iwl3945: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
[  899.884373] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68 bytes at 4[4]:4
[  899.884440] iwl3945: I iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
[  899.887743] iwl3945: U iwl3945_send_add_station REPLY_ADD_STA PASSED
[  899.887743] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
[  899.887743] iwl3945: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
[  899.887743] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406, 56 bytes at 6[6]:4
[  899.887743] iwl3945: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
[  899.887743] iwl3945: U iwl3945_hw_reg_txpower_get_temperature Temperature: 92
[  899.887743] iwl3945: U is_temp_calib_needed Getting cooler, delta -168,
[  899.887743] iwl3945: U is_temp_calib_needed Timed thermal calib needed
[  899.887743] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0d
[  899.887743] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0f
[  899.887743] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x05
[  899.887743] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x07
[  899.887743] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x09
[  899.887743] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0b
[  899.887743] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x01
[  899.887743] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 115 rate code 0x03
[  899.887743] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x0a
[  899.887743] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x14
[  899.887743] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x37
[  899.887743] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x6e
[  899.887743] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0407, 56 bytes at 7[7]:4
[  899.890950] iwl3945: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
[  899.893367] iwl3945: U iwl3945_alive_start ALIVE processing complete.
[  899.895089] iwl3945: U iwl3945_mac_start leave
[  899.895089] iwl3945: U iwl3945_mac_add_interface enter: type 2
[  899.895089] iwl3945: U iwl3945_mac_add_interface Set: 00:1b:77:f1:7c:29
[  899.895089] iwl3945: U iwl3945_commit_rxon Sending RXON
[  899.895089] * without RXON_FILTER_ASSOC_MSK
[  899.895089] * channel = 1
[  899.895089] * bssid = 00:00:00:00:00:00
[  899.895089] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0408, 48 bytes at 8[8]:4
[  899.893367] iwl3945: I iwl3945_rx_handle r 11 i 10 No handler needed for REPLY_RXON, 0x10
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0d
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0f
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x05
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x07
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x09
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0b
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x01
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 115 rate code 0x03
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x0a
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x14
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x37
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x6e
[  899.895089] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0409, 56 bytes at 9[9]:4
[  899.895089] iwl3945: I iwl3945_rx_handle r 12 i 11 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
[  899.895089] iwl3945: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
[  899.895089] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040A, 68 bytes at 10[10]:4
[  899.893367] iwl3945: I iwl3945_rx_handle r = 13, i = 12, REPLY_ADD_STA, 0x18
[  899.895089] iwl3945: U iwl3945_send_add_station REPLY_ADD_STA PASSED
[  899.895089] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040B, 56 bytes at 11[11]:4
[  899.895089] iwl3945: I iwl3945_rx_handle r 14 i 13 No handler needed for REPLY_RATE_SCALE, 0x47
[  899.895089] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040C, 56 bytes at 12[12]:4
[  899.893367] iwl3945: I iwl3945_rx_handle r 15 i 14 No handler needed for REPLY_RATE_SCALE, 0x47
[  899.895089] iwl3945: U iwl3945_mac_add_interface leave
[  899.895089] iwl3945: U iwl3945_mac_config_interface bssid: 00:00:00:00:00:00
[  899.895089] iwl3945: U iwl3945_commit_rxon Sending RXON
[  899.895089] * without RXON_FILTER_ASSOC_MSK
[  899.895089] * channel = 1
[  899.895089] * bssid = 00:00:00:00:00:00
[  899.895089] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040D, 48 bytes at 13[13]:4
[  899.895089] iwl3945: I iwl3945_rx_handle r 16 i 15 No handler needed for REPLY_RXON, 0x10
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0d
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0f
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x05
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x07
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x09
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0b
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x01
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 115 rate code 0x03
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x0a
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x14
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x37
[  899.895089] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x6e
[  899.895089] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040E, 56 bytes at 14[14]:4
[  899.893367] iwl3945: I iwl3945_rx_handle r 17 i 16 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
[  899.895089] iwl3945: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
[  899.895089] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040F, 68 bytes at 15[15]:4
[  899.895089] iwl3945: I iwl3945_rx_handle r = 18, i = 17, REPLY_ADD_STA, 0x18
[  899.895089] iwl3945: U iwl3945_send_add_station REPLY_ADD_STA PASSED
[  899.895089] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0410, 56 bytes at 16[16]:4
[  899.893367] iwl3945: I iwl3945_rx_handle r 19 i 18 No handler needed for REPLY_RATE_SCALE, 0x47
[  899.895089] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0411, 56 bytes at 17[17]:4
[  899.895089] iwl3945: I iwl3945_rx_handle r 20 i 19 No handler needed for REPLY_RATE_SCALE, 0x47
[  899.895089] iwl3945: U iwl3945_mac_config_interface leave
[  899.936140] iwl3945: U iwl3945_mac_config enter to channel 1
[  899.936155] iwl3945: U iwl3945_commit_rxon Sending RXON
[  899.936157] * without RXON_FILTER_ASSOC_MSK
[  899.936158] * channel = 1
[  899.936159] * bssid = 00:00:00:00:00:00
[  899.936165] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0412, 48 bytes at 18[18]:4
[  899.936339] iwl3945: I iwl3945_rx_handle r 21 i 20 No handler needed for REPLY_RXON, 0x10
[  899.936359] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0d
[  899.936363] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0f
[  899.936366] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x05
[  899.936369] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x07
[  899.936372] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x09
[  899.936375] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0b
[  899.936379] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x01
[  899.936382] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 115 rate code 0x03
[  899.936385] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x0a
[  899.936388] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x14
[  899.936391] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x37
[  899.936395] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x6e
[  899.936399] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0413, 56 bytes at 19[19]:4
[  899.937371] iwl3945: I iwl3945_rx_handle r 22 i 21 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
[  899.938499] iwl3945: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
[  899.938504] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0414, 68 bytes at 20[20]:4
[  899.938570] iwl3945: I iwl3945_rx_handle r = 23, i = 22, REPLY_ADD_STA, 0x18
[  899.938581] iwl3945: U iwl3945_send_add_station REPLY_ADD_STA PASSED
[  899.938587] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0415, 56 bytes at 21[21]:4
[  899.937371] iwl3945: I iwl3945_rx_handle r 24 i 23 No handler needed for REPLY_RATE_SCALE, 0x47
[  899.939092] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0416, 56 bytes at 22[22]:4
[  899.939092] iwl3945: I iwl3945_rx_handle r 25 i 24 No handler needed for REPLY_RATE_SCALE, 0x47
[  899.939092] iwl3945: U iwl3945_mac_config leave
[  899.939092] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  899.951057] iwl3945: I iwl3945_rx_handle r = 26, i = 25, REPLY_3945_RX, 0x1b
[  900.056217] iwl3945: I iwl3945_rx_handle r = 27, i = 26, REPLY_3945_RX, 0x1b
[  900.162576] iwl3945: I iwl3945_rx_handle r = 28, i = 27, REPLY_3945_RX, 0x1b
[  900.265816] iwl3945: I iwl3945_rx_handle r = 29, i = 28, REPLY_3945_RX, 0x1b
[  900.369813] iwl3945: I iwl3945_rx_handle r = 30, i = 29, REPLY_3945_RX, 0x1b
[  900.474301] iwl3945: I iwl3945_rx_handle r = 31, i = 30, REPLY_3945_RX, 0x1b
[  900.578602] iwl3945: I iwl3945_rx_handle r = 32, i = 31, REPLY_3945_RX, 0x1b
[  900.605371] iwl3945: U iwl3945_mac_hw_scan enter
[  900.605605] iwl3945: U iwl3945_scan_initiate Starting scan...
[  900.605614] iwl3945: U iwl3945_mac_hw_scan leave
[  900.605882] iwl3945: U iwl3945_bg_request_scan Kicking off one indirect scan.
[  900.605882] iwl3945: U iwl3945_get_channels_for_scan Scanning 1 [PASSIVE 120]
[  900.605882] iwl3945: U iwl3945_get_channels_for_scan Scanning 2 [PASSIVE 120]
[  900.606086] iwl3945: U iwl3945_get_channels_for_scan Scanning 3 [PASSIVE 120]
[  900.606285] iwl3945: U iwl3945_get_channels_for_scan Scanning 4 [PASSIVE 120]
[  900.606484] iwl3945: U iwl3945_get_channels_for_scan Scanning 5 [PASSIVE 120]
[  900.606682] iwl3945: U iwl3945_get_channels_for_scan Scanning 6 [PASSIVE 120]
[  900.606882] iwl3945: U iwl3945_get_channels_for_scan Scanning 7 [PASSIVE 120]
[  900.608617] iwl3945: U iwl3945_get_channels_for_scan Scanning 8 [PASSIVE 120]
[  900.608815] iwl3945: U iwl3945_get_channels_for_scan Scanning 9 [PASSIVE 120]
[  900.609013] iwl3945: U iwl3945_get_channels_for_scan Scanning 10 [PASSIVE 120]
[  900.609214] iwl3945: U iwl3945_get_channels_for_scan Scanning 11 [PASSIVE 120]
[  900.609413] iwl3945: U iwl3945_get_channels_for_scan total channels to scan 11 
[  900.609620] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4417, 350 bytes at 23[32]:4
[  900.609933] iwl3945: I iwl3945_rx_handle r = 33, i = 32, REPLY_SCAN_CMD, 0x80
[  900.610798] iwl3945: I iwl3945_rx_handle r = 35, i = 33, STATISTICS_NOTIFICATION, 0x9d
[  900.610807] iwl3945: I iwl3945_rx_handle r = 35, i = 34, SCAN_START_NOTIFICATION, 0x82
[  900.610811] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 1 [802.11bg] (TSF: 0x00000000:000A09FD) - 1 (beacon timer 100722179)
[  900.686927] iwl3945: I iwl3945_rx_handle r = 36, i = 35, REPLY_3945_RX, 0x1b
[  900.742098] iwl3945: I iwl3945_rx_handle r = 37, i = 36, SCAN_RESULTS_NOTIFICATION, 0x83
[  900.742098] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 1 [802.11bg] (TSF: 0x00000000:000BEA10) - 1 elapsed=122899 usec (584872ms since last)
[  900.742098] iwl3945: I iwl3945_rx_handle r = 39, i = 37, STATISTICS_NOTIFICATION, 0x9d
[  900.742098] iwl3945: I iwl3945_rx_handle r = 39, i = 38, SCAN_START_NOTIFICATION, 0x82
[  900.742098] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 2 [802.11bg] (TSF: 0x00000000:000BEE20) - 1 (beacon timer 117477856)
[  900.796556] iwl3945: I iwl3945_rx_handle r = 40, i = 39, REPLY_3945_RX, 0x1b
[  900.865889] iwl3945: I iwl3945_rx_handle r = 41, i = 40, SCAN_RESULTS_NOTIFICATION, 0x83
[  900.865903] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 2 [802.11bg] (TSF: 0x00000000:000DCE36) - 1 elapsed=122902 usec (124ms since last)
[  900.867478] iwl3945: I iwl3945_rx_handle r = 43, i = 41, STATISTICS_NOTIFICATION, 0x9d
[  900.867489] iwl3945: I iwl3945_rx_handle r = 43, i = 42, SCAN_START_NOTIFICATION, 0x82
[  900.867494] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 3 [802.11bg] (TSF: 0x00000000:000DD223) - 1 (beacon timer 134233565)
[  900.899136] iwl3945: I iwl3945_rx_handle r = 44, i = 43, REPLY_3945_RX, 0x1b
[  900.992908] iwl3945: I iwl3945_rx_handle r = 45, i = 44, SCAN_RESULTS_NOTIFICATION, 0x83
[  900.992908] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 3 [802.11bg] (TSF: 0x00000000:000FB23A) - 1 elapsed=122903 usec (124ms since last)
[  900.995107] iwl3945: I iwl3945_rx_handle r = 47, i = 45, STATISTICS_NOTIFICATION, 0x9d
[  900.995118] iwl3945: I iwl3945_rx_handle r = 47, i = 46, SCAN_START_NOTIFICATION, 0x82
[  900.995122] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 4 [802.11bg] (TSF: 0x00000000:000FB66C) - 1 (beacon timer 167868820)
[  901.004721] iwl3945: I iwl3945_rx_handle r = 48, i = 47, REPLY_3945_RX, 0x1b
[  901.105558] iwl3945: I iwl3945_rx_handle r = 49, i = 48, REPLY_3945_RX, 0x1b
[  901.118025] iwl3945: I iwl3945_rx_handle r = 50, i = 49, SCAN_RESULTS_NOTIFICATION, 0x83
[  901.118040] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 4 [802.11bg] (TSF: 0x00000000:00119685) - 2 elapsed=122905 usec (124ms since last)
[  901.119108] iwl3945: I iwl3945_rx_handle r = 52, i = 50, STATISTICS_NOTIFICATION, 0x9d
[  901.119118] iwl3945: I iwl3945_rx_handle r = 52, i = 51, SCAN_START_NOTIFICATION, 0x82
[  901.119123] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 5 [802.11bg] (TSF: 0x00000000:00119AD0) - 1 (beacon timer 184624432)
[  901.136361] iwl3945: I iwl3945_rx_handle r = 53, i = 52, REPLY_3945_RX, 0x1b
[  901.239017] iwl3945: I iwl3945_rx_handle r = 54, i = 53, REPLY_3945_RX, 0x1b
[  901.242024] iwl3945: I iwl3945_rx_handle r = 55, i = 54, SCAN_RESULTS_NOTIFICATION, 0x83
[  901.242032] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 5 [802.11bg] (TSF: 0x00000000:00137AE7) - 2 elapsed=122903 usec (124ms since last)
[  901.243100] iwl3945: I iwl3945_rx_handle r = 57, i = 55, STATISTICS_NOTIFICATION, 0x9d
[  901.243107] iwl3945: I iwl3945_rx_handle r = 57, i = 56, SCAN_START_NOTIFICATION, 0x82
[  901.243111] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 6 [802.11bg] (TSF: 0x00000000:00137EED) - 1 (beacon timer 201380115)
[  901.345548] iwl3945: I iwl3945_rx_handle r = 58, i = 57, REPLY_3945_RX, 0x1b
[  901.369030] iwl3945: I iwl3945_rx_handle r = 59, i = 58, SCAN_RESULTS_NOTIFICATION, 0x83
[  901.369043] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 6 [802.11bg] (TSF: 0x00000000:00155EFC) - 1 elapsed=122895 usec (124ms since last)
[  901.371302] iwl3945: I iwl3945_rx_handle r = 61, i = 59, STATISTICS_NOTIFICATION, 0x9d
[  901.371308] iwl3945: I iwl3945_rx_handle r = 61, i = 60, SCAN_START_NOTIFICATION, 0x82
[  901.371313] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 7 [802.11bg] (TSF: 0x00000000:001563CA) - 1 (beacon timer 218135606)
[  901.448243] iwl3945: I iwl3945_rx_handle r = 62, i = 61, REPLY_3945_RX, 0x1b
[  901.500938] iwl3945: I iwl3945_rx_handle r = 63, i = 62, SCAN_RESULTS_NOTIFICATION, 0x83
[  901.500938] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 7 [802.11bg] (TSF: 0x00000000:001743E3) - 1 elapsed=122905 usec (124ms since last)
[  901.500938] iwl3945: I iwl3945_rx_handle r = 65, i = 63, STATISTICS_NOTIFICATION, 0x9d
[  901.500938] iwl3945: I iwl3945_rx_handle r = 65, i = 64, SCAN_START_NOTIFICATION, 0x82
[  901.500938] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 8 [802.11bg] (TSF: 0x00000000:0017483B) - 1 (beacon timer 234891205)
[  901.521280] iwl3945: I iwl3945_rx_handle r = 66, i = 65, REPLY_3945_RX, 0x1b
[  901.556950] iwl3945: I iwl3945_rx_handle r = 67, i = 66, REPLY_3945_RX, 0x1b
[  901.627376] iwl3945: I iwl3945_rx_handle r = 68, i = 67, REPLY_3945_RX, 0x1b
[  901.628574] iwl3945: I iwl3945_rx_handle r = 69, i = 68, SCAN_RESULTS_NOTIFICATION, 0x83
[  901.628585] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 8 [802.11bg] (TSF: 0x00000000:0019284F) - 3 elapsed=122900 usec (124ms since last)
[  901.629717] iwl3945: I iwl3945_rx_handle r = 71, i = 69, STATISTICS_NOTIFICATION, 0x9d
[  901.629717] iwl3945: I iwl3945_rx_handle r = 71, i = 70, SCAN_START_NOTIFICATION, 0x82
[  901.629717] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 9 [802.11bg] (TSF: 0x00000000:00192C51) - 1 (beacon timer 268526511)
[  901.729717] iwl3945: I iwl3945_rx_handle r = 72, i = 71, REPLY_3945_RX, 0x1b
[  901.751505] iwl3945: I iwl3945_rx_handle r = 73, i = 72, SCAN_RESULTS_NOTIFICATION, 0x83
[  901.751521] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 9 [802.11bg] (TSF: 0x00000000:001B0C69) - 1 elapsed=122904 usec (124ms since last)
[  901.752975] iwl3945: I iwl3945_rx_handle r = 75, i = 73, STATISTICS_NOTIFICATION, 0x9d
[  901.752986] iwl3945: I iwl3945_rx_handle r = 75, i = 74, SCAN_START_NOTIFICATION, 0x82
[  901.752990] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 10 [802.11bg] (TSF: 0x00000000:001B107C) - 1 (beacon timer 285282180)
[  901.831927] iwl3945: I iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
[  901.875442] iwl3945: I iwl3945_rx_handle r = 77, i = 76, SCAN_RESULTS_NOTIFICATION, 0x83
[  901.875453] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 10 [802.11bg] (TSF: 0x00000000:001CF088) - 1 elapsed=122892 usec (124ms since last)
[  901.876794] iwl3945: I iwl3945_rx_handle r = 79, i = 77, STATISTICS_NOTIFICATION, 0x9d
[  901.876801] iwl3945: I iwl3945_rx_handle r = 79, i = 78, SCAN_START_NOTIFICATION, 0x82
[  901.876806] iwl3945: I iwl3945_rx_scan_start_notif Scan start: 11 [802.11bg] (TSF: 0x00000000:001CF44C) - 1 (beacon timer 302037940)
[  901.934337] iwl3945: I iwl3945_rx_handle r = 80, i = 79, REPLY_3945_RX, 0x1b
[  902.000327] iwl3945: I iwl3945_rx_handle r = 81, i = 80, SCAN_RESULTS_NOTIFICATION, 0x83
[  902.000339] iwl3945: I iwl3945_rx_scan_results_notif Scan ch.res: 11 [802.11bg] (TSF: 0x00000000:001ED45D) - 1 elapsed=122897 usec (124ms since last)
[  902.001726] iwl3945: I iwl3945_rx_handle r = 82, i = 81, SCAN_COMPLETE_NOTIFICATION, 0x84
[  902.001733] iwl3945: I iwl3945_rx_scan_complete_notif Scan complete: 11 channels (TSF 0x001ED869:00000000) - 1
[  902.001736] iwl3945: I iwl3945_rx_scan_complete_notif Scan pass on 2.4GHz took 1368ms
[  902.001736] iwl3945: U iwl3945_bg_request_scan Kicking off one indirect scan.
[  902.001736] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4418, 262 bytes at 24[32]:4
[  902.002911] iwl3945: I iwl3945_rx_handle r = 83, i = 82, REPLY_SCAN_CMD, 0x80
[  902.203057] iwl3945: Microcode SW error detected.  Restarting 0x82000008.
[  902.203090] iwl3945: Start IWL Error Log Dump:
[  902.203093] iwl3945: Status: 0x0002A2E4, count: 1
[  902.203096] iwl3945: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
[  902.203167] iwl3945: SYSASSERT     (#5) 0002221641 0x0089A 0x0025E 0x00304 0x0F0C6 75
[  902.203169] 
[  902.203232] iwl3945: Start IWL Event Log Dump: display count 256, wraps 4
[  902.203263] iwl3945: 0001657132	0x000000d9	0106
[  902.203294] iwl3945: 0001657134	0x00000000	0301
[  902.203325] iwl3945: 0001657144	0x00008000	0350
[  902.203355] iwl3945: 0001657185	0x000000d9	0106
[  902.203386] iwl3945: 0001657187	0x00000000	0301
[  902.203416] iwl3945: 0001657197	0x00008000	0350
[  902.203446] iwl3945: 0001678440	0x000000d9	0106
[  902.203476] iwl3945: 0001678442	0x00000000	0302
[  902.203507] iwl3945: 0001678450	0x00008000	0350
[  902.203537] iwl3945: 0001678464	0x000000d9	0106
[  902.203567] iwl3945: 0001678466	0x00000000	0302
[  902.203597] iwl3945: 0001678488	0x00000001	0353
[  902.203628] iwl3945: 0001749478	0x000000d9	0106
[  902.203658] iwl3945: 0001749479	0x00000000	0301
[  902.203688] iwl3945: 0001749859	0x00000000	0356
[  902.203719] iwl3945: 0001750331	0x00000003	0310
[  902.203749] iwl3945: 0001767002	0x000000d9	0106
[  902.203779] iwl3945: 0001767003	0x00000000	0301
[  902.203810] iwl3945: 0001767013	0x00008000	0350
[  902.203840] iwl3945: 0001767039	0x000000d9	0106
[  902.203871] iwl3945: 0001767041	0x00000000	0301
[  902.203902] iwl3945: 0001767048	0x00008000	0350
[  902.203931] iwl3945: 0001767060	0x000000d9	0106
[  902.203931] iwl3945: 0001767062	0x00000000	0301
[  902.203931] iwl3945: 0001767068	0x00008000	0350
[  902.203931] iwl3945: 0001767081	0x000000d9	0106
[  902.203931] iwl3945: 0001767083	0x00000000	0301
[  902.203931] iwl3945: 0001767089	0x00008000	0350
[  902.203931] iwl3945: 0001767102	0x000000d9	0106
[  902.203931] iwl3945: 0001767104	0x00000000	0301
[  902.203931] iwl3945: 0001767108	0x00008000	0350
[  902.203931] iwl3945: 0001767116	0x000000d9	0106
[  902.203931] iwl3945: 0001767118	0x00000000	0301
[  902.203931] iwl3945: 0001767128	0x00008000	0350
[  902.203931] iwl3945: 0001767139	0x000000d9	0106
[  902.203931] iwl3945: 0001767140	0x00000000	0301
[  902.203931] iwl3945: 0001767150	0x00008000	0350
[  902.203931] iwl3945: 0001767167	0x000000d9	0106
[  902.203931] iwl3945: 0001767169	0x00000000	0301
[  902.203931] iwl3945: 0001767179	0x00008000	0350
[  902.203931] iwl3945: 0001767190	0x000000d9	0106
[  902.203931] iwl3945: 0001767192	0x00000000	0301
[  902.203931] iwl3945: 0001767201	0x00008000	0350
[  902.203931] iwl3945: 0001767212	0x000000d9	0106
[  902.203931] iwl3945: 0001767213	0x00000000	0301
[  902.203931] iwl3945: 0001767221	0x00008000	0350
[  902.203931] iwl3945: 0001767234	0x000000d9	0106
[  902.203931] iwl3945: 0001767236	0x00000000	0301
[  902.203931] iwl3945: 0001767246	0x00008000	0350
[  902.203931] iwl3945: 0001768354	0x000000d9	0106
[  902.203931] iwl3945: 0001768356	0x00000000	0302
[  902.203931] iwl3945: 0001768381	0x00000002	0353
[  902.203931] iwl3945: 0001768513	0x000000d9	0106
[  902.203931] iwl3945: 0001768515	0x00000000	0302
[  902.203931] iwl3945: 0001768540	0x00000003	0353
[  902.203931] iwl3945: 0001772648	0x0001e000	0723
[  902.203931] iwl3945: 0001772649	0x00000009	0717
[  902.203931] iwl3945: 0001772651	0x05050500	0706
[  902.203931] iwl3945: 0001772655	0x05000300	0706
[  902.203931] iwl3945: 0001772656	0x05050300	0725
[  902.203931] iwl3945: 0001772657	0x00000000	0710
[  902.203931] iwl3945: 0001772661	0x00000003	0732
[  902.203931] iwl3945: 0001773349	0xffffff67	0454
[  902.203931] iwl3945: 0001773350	0x00000000	0472
[  902.203931] iwl3945: 0001773358	0x00000009	0463
[  902.203931] iwl3945: 0001773362	0x0000000a	0719
[  902.203931] iwl3945: 0001773363	0x03000304	0706
[  902.203931] iwl3945: 0001773384	0x03000304	0725
[  902.203931] iwl3945: 0001773385	0x00000004	0710
[  902.203931] iwl3945: 0001773665	0x0000000a	0463
[  902.203931] iwl3945: 0001773666	0x0000000a	0462
[  902.203931] iwl3945: 0001773682	0x00000003	0733
[  902.203931] iwl3945: 0001773692	0x0000000a	0716
[  902.203931] iwl3945: 0001773694	0x03040400	0706
[  902.203931] iwl3945: 0001773695	0x0000000a	0720
[  902.203931] iwl3945: 0001773696	0x03040400	0725
[  902.203931] iwl3945: 0001773697	0x00000000	0711
[  902.203931] iwl3945: 0001773701	0x04000500	0706
[  902.203931] iwl3945: 0001773715	0x04000500	0725
[  902.203931] iwl3945: 0001773719	0x05000505	0706
[  902.203931] iwl3945: 0001773735	0x05000505	0725
[  902.203931] iwl3945: 0001786965	0x000000d9	0106
[  902.203931] iwl3945: 0001786967	0x00000000	0301
[  902.203931] iwl3945: 0001786977	0x00008000	0350
[  902.203931] iwl3945: 0001787145	0x000000d9	0106
[  902.203931] iwl3945: 0001787147	0x00000000	0301
[  902.203931] iwl3945: 0001787156	0x00008000	0350
[  902.203931] iwl3945: 0001851875	0x000000d9	0106
[  902.203931] iwl3945: 0001851876	0x00000000	0301
[  902.203931] iwl3945: 0001852259	0x00000000	0356
[  902.203931] iwl3945: 0001852731	0x00000003	0310
[  902.203931] iwl3945: 0001866960	0x000000d9	0106
[  902.203931] iwl3945: 0001866961	0x00000000	0302
[  902.203931] iwl3945: 0001866966	0x00008000	0350
[  902.203931] iwl3945: 0001867009	0x000000d9	0106
[  902.203931] iwl3945: 0001867011	0x00000000	0301
[  902.203931] iwl3945: 0001867021	0x00008000	0350
[  902.203931] iwl3945: 0001867082	0x000000d9	0106
[  902.203931] iwl3945: 0001867083	0x00000000	0301
[  902.203931] iwl3945: 0001867089	0x00008000	0350
[  902.203931] iwl3945: 0001867105	0x000000d9	0106
[  902.203931] iwl3945: 0001867107	0x00000000	0301
[  902.203931] iwl3945: 0001867117	0x00008000	0350
[  902.203931] iwl3945: 0001867224	0x000000d9	0106
[  902.203931] iwl3945: 0001867225	0x00000000	0301
[  902.203931] iwl3945: 0001867232	0x00008000	0350
[  902.203931] iwl3945: 0001896583	0x0001e000	0723
[  902.203931] iwl3945: 0001896584	0x0000000a	0717
[  902.203931] iwl3945: 0001896586	0x05050500	0706
[  902.203931] iwl3945: 0001896590	0x05000300	0706
[  902.203931] iwl3945: 0001896591	0x05050300	0725
[  902.203931] iwl3945: 0001896592	0x00000000	0710
[  902.203931] iwl3945: 0001896596	0x00000003	0732
[  902.203931] iwl3945: 0001897284	0xffffff67	0454
[  902.203931] iwl3945: 0001897285	0x00000000	0472
[  902.203931] iwl3945: 0001897293	0x0000000a	0463
[  902.203931] iwl3945: 0001897297	0x0000000b	0719
[  902.203931] iwl3945: 0001897298	0x03000304	0706
[  902.203931] iwl3945: 0001897319	0x03000304	0725
[  902.203931] iwl3945: 0001897320	0x00000004	0710
[  902.203931] iwl3945: 0001897520	0x0000000b	0463
[  902.203931] iwl3945: 0001897522	0x0000000b	0462
[  902.203931] iwl3945: 0001897538	0x00000003	0733
[  902.203931] iwl3945: 0001897547	0x0000000b	0716
[  902.203931] iwl3945: 0001897550	0x03040400	0706
[  902.203931] iwl3945: 0001897551	0x0000000b	0720
[  902.203931] iwl3945: 0001897552	0x03040400	0725
[  902.203931] iwl3945: 0001897553	0x00000000	0711
[  902.203931] iwl3945: 0001897557	0x04000500	0706
[  902.203931] iwl3945: 0001897570	0x04000500	0725
[  902.203931] iwl3945: 0001897574	0x05000505	0706
[  902.203931] iwl3945: 0001897590	0x05000505	0725
[  902.203931] iwl3945: 0001926986	0x000000d9	0106
[  902.203931] iwl3945: 0001926987	0x00000000	0301
[  902.203931] iwl3945: 0001926997	0x00008000	0350
[  902.203931] iwl3945: 0001927025	0x000000d9	0106
[  902.203931] iwl3945: 0001927027	0x00000000	0301
[  902.203931] iwl3945: 0001927036	0x00008000	0350
[  902.203931] iwl3945: 0001927057	0x000000d9	0106
[  902.203931] iwl3945: 0001927059	0x00000000	0301
[  902.203931] iwl3945: 0001927064	0x00008000	0350
[  902.203931] iwl3945: 0001927106	0x000000d9	0106
[  902.203931] iwl3945: 0001927108	0x00000000	0301
[  902.203931] iwl3945: 0001927118	0x00008000	0350
[  902.203931] iwl3945: 0001927129	0x000000d9	0106
[  902.203931] iwl3945: 0001927131	0x00000000	0301
[  902.203931] iwl3945: 0001927141	0x00008000	0350
[  902.203931] iwl3945: 0001927164	0x000000d9	0106
[  902.203931] iwl3945: 0001927166	0x00000000	0301
[  902.203931] iwl3945: 0001927175	0x00008000	0350
[  902.203931] iwl3945: 0001927208	0x000000d9	0106
[  902.203931] iwl3945: 0001927210	0x00000000	0301
[  902.203931] iwl3945: 0001927283	0x00000001	0353
[  902.203931] iwl3945: 0001927292	0x00000000	0352
[  902.203931] iwl3945: 0001935148	0x000000d9	0106
[  902.203931] iwl3945: 0001935149	0x00000000	0301
[  902.203931] iwl3945: 0001935217	0x00000002	0353
[  902.203931] iwl3945: 0001935226	0x00000000	0352
[  902.203931] iwl3945: 0001935321	0x000000d9	0106
[  902.203931] iwl3945: 0001935323	0x00000000	0301
[  902.203931] iwl3945: 0001935397	0x00000003	0353
[  902.203931] iwl3945: 0001935405	0x00000000	0352
[  902.203931] iwl3945: 0001935631	0x000000d9	0106
[  902.203931] iwl3945: 0001935632	0x00000000	0301
[  902.203931] iwl3945: 0001935706	0x00000004	0353
[  902.203931] iwl3945: 0001935715	0x00000000	0352
[  902.203931] iwl3945: 0001946997	0x000000d9	0106
[  902.203931] iwl3945: 0001946999	0x00000000	0301
[  902.203931] iwl3945: 0001947008	0x00008000	0350
[  902.203931] iwl3945: 0001947031	0x000000d9	0106
[  902.203931] iwl3945: 0001947032	0x00000000	0301
[  902.203931] iwl3945: 0001947042	0x00008000	0350
[  902.203931] iwl3945: 0001947072	0x000000d9	0106
[  902.203931] iwl3945: 0001947073	0x00000000	0301
[  902.203931] iwl3945: 0001947080	0x00008000	0350
[  902.203931] iwl3945: 0001947097	0x000000d9	0106
[  902.203931] iwl3945: 0001947099	0x00000000	0301
[  902.203931] iwl3945: 0001947108	0x00008000	0350
[  902.203931] iwl3945: 0001947132	0x000000d9	0106
[  902.203931] iwl3945: 0001947134	0x00000000	0301
[  902.203931] iwl3945: 0001947141	0x00008000	0350
[  902.203931] iwl3945: 0001947166	0x000000d9	0106
[  902.203931] iwl3945: 0001947167	0x00000000	0301
[  902.203931] iwl3945: 0001947177	0x00008000	0350
[  902.203931] iwl3945: 0001947194	0x000000d9	0106
[  902.203931] iwl3945: 0001947196	0x00000000	0301
[  902.203931] iwl3945: 0001947206	0x00008000	0350
[  902.203931] iwl3945: 0001947217	0x000000d9	0106
[  902.203931] iwl3945: 0001947218	0x00000000	0301
[  902.203931] iwl3945: 0001947228	0x00008000	0350
[  902.203931] iwl3945: 0001947245	0x000000d9	0106
[  902.203931] iwl3945: 0001947246	0x00000000	0302
[  902.203931] iwl3945: 0001947286	0x00000001	0353
[  902.203931] iwl3945: 0001954276	0x000000d9	0106
[  902.203931] iwl3945: 0001954277	0x00000000	0301
[  902.203931] iwl3945: 0001954658	0x00000000	0356
[  902.203931] iwl3945: 0001955130	0x00000003	0310
[  902.203931] iwl3945: 0001987040	0x000000d9	0106
[  902.203931] iwl3945: 0001987041	0x00000000	0301
[  902.203931] iwl3945: 0001987050	0x00008000	0350
[  902.203931] iwl3945: 0001987072	0x000000d9	0106
[  902.203931] iwl3945: 0001987074	0x00000000	0301
[  902.203931] iwl3945: 0001987084	0x00008000	0350
[  902.203931] iwl3945: 0001987148	0x000000d9	0106
[  902.203931] iwl3945: 0001987149	0x00000000	0301
[  902.203931] iwl3945: 0001987159	0x00008000	0350
[  902.203931] iwl3945: 0002016969	0x000000d9	0106
[  902.203931] iwl3945: 0002016971	0x00000000	0302
[  902.203931] iwl3945: 0002017014	0x00000002	0353
[  902.203931] iwl3945: 0002017184	0x000000d9	0106
[  902.203931] iwl3945: 0002017185	0x00000000	0301
[  902.203931] iwl3945: 0002017191	0x00008000	0350
[  902.203931] iwl3945: 0002017225	0x000000d9	0106
[  902.203931] iwl3945: 0002017226	0x00000000	0301
[  902.203931] iwl3945: 0002017234	0x00008000	0350
[  902.203931] iwl3945: 0002020444	0x0001e000	0723
[  902.203931] iwl3945: 0002020445	0x0000000b	0717
[  902.203931] iwl3945: 0002020447	0x05050500	0706
[  902.203931] iwl3945: 0002020448	0x05000600	0706
[  902.203931] iwl3945: 0002020449	0x05050600	0725
[  902.203931] iwl3945: 0002020450	0x00000000	0713
[  902.203931] iwl3945: 0002020451	0x00000006	0732
[  902.203931] iwl3945: 0002021088	0xffffff68	0454
[  902.203931] iwl3945: 0002021089	0x00000000	0472
[  902.203931] iwl3945: 0002021097	0x0000000b	0463
[  902.203931] iwl3945: 0002021102	0x00000001	0719
[  902.203931] iwl3945: 0002021155	0x06000604	0706
[  902.203931] iwl3945: 0002021160	0x06000604	0725
[  902.203931] iwl3945: 0002021161	0x00000004	0713
[  902.203931] iwl3945: 0002021445	0x00000001	0463
[  902.203931] iwl3945: 0002021447	0x00000001	0462
[  902.203931] iwl3945: 0002021470	0x00000006	0733
[  902.203931] iwl3945: 0002021471	0x00000001	0720
[  902.203931] iwl3945: 0002021472	0x06040600	0706
[  902.203931] iwl3945: 0002021477	0x06000100	0706
[  902.203931] iwl3945: 0002021479	0x06040100	0725
[  902.203931] iwl3945: 0002021480	0x00000000	0708
[  902.203931] iwl3945: 0002021481	0x00000001	0718
[  902.203931] iwl3945: 0002021486	0x01000000	0706
[  902.203931] iwl3945: 0002021487	0x00000000	0706
[  902.203931] iwl3945: 0002021488	0x44170080	0703
[  902.203931] iwl3945: 0002021598	0x44180080	0401
[  902.203931] iwl3945: 0002021600	0x44180080	0700
[  902.203931] iwl3945: 0002021603	0x00000000	0706
[  902.203931] iwl3945: 0002021611	0x00000000	0452
[  902.203931] iwl3945: 0002021612	0x00000000	0452
[  902.203931] iwl3945: 0002021615	0x00000072	0601
[  902.203931] iwl3945: 0002021622	0x00000100	0706
[  902.203931] iwl3945: 0002021626	0x00000000	0708
[  902.203931] iwl3945: 0002021631	0x01000300	0706
[  902.203931] iwl3945: 0002021640	0x01000300	0725
[  902.203931] iwl3945: 0002021641	0x00000000	0710
[  902.203931] iwl3945: 0002021645	0x00000001	0729
[  902.203931] iwl3945: 0002021646	0x00000003	0732
[  902.203931] iwl3945: 0002221639	0x00000002	0123
[  902.203931] iwl3945: 0002221642	0x00000100	0125
[  902.203931] iwl3945: I iwl3945_print_rx_config_cmd RX CONFIG:
[  902.203931] iwl data: 00000000: 00 1b 77 f1 7c 29 00 00 00 00 00 00 00 00 00 00  ..w.|)..........
[  902.203931] iwl data: 00000010: 00 00 00 00 00 00 00 00 03 00 00 00 15 03 00 00  ................
[  902.203931] iwl data: 00000020: 05 80 00 00 04 00 00 00 01 00 00 00              ............
[  902.203931] iwl3945: I iwl3945_print_rx_config_cmd u16 channel: 0x1
[  902.203931] iwl3945: I iwl3945_print_rx_config_cmd u32 flags: 0x00008005
[  902.203931] iwl3945: I iwl3945_print_rx_config_cmd u32 filter_flags: 0x00000004
[  902.203931] iwl3945: I iwl3945_print_rx_config_cmd u8 dev_type: 0x3
[  902.203931] iwl3945: I iwl3945_print_rx_config_cmd u8 ofdm_basic_rates: 0x15
[  902.203931] iwl3945: I iwl3945_print_rx_config_cmd u8 cck_basic_rates: 0x03
[  902.203931] iwl3945: I iwl3945_print_rx_config_cmd u8[6] node_addr: 00:1b:77:f1:7c:29
[  902.203931] iwl3945: I iwl3945_print_rx_config_cmd u8[6] bssid_addr: 00:00:00:00:00:00
[  902.203931] iwl3945: I iwl3945_print_rx_config_cmd u16 assoc_id: 0x0
[  902.203931] iwl3945: I iwl3945_irq_handle_error Restarting adapter due to uCode error.
[  902.203931] iwl3945: I iwl3945_rx_handle r = 84, i = 83, REPLY_ERROR, 0x02
[  902.203931] iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq 0x4418 ser 0x0000004B
[  902.213689] iwl3945: U __iwl3945_down iwl3945 is going down
[  902.830450] iwl3945: Can't stop Rx DMA.
[  903.839393] iwl3945: U iwl3945_hw_nic_stop_master stop master
[  903.964804] iwl3945: U iwl3945_clear_free_frames 0 frames on pre-allocated heap on clear.
[  903.964824] iwl3945: U iwl3945_power_init_handle Initialize power 
[  903.964834] iwl3945: U iwl3945_power_init_handle adjust power command flags
[  903.964930] iwl3945: U iwl3945_hw_nic_init HW Revision ID = 0x2
[  903.964976] iwl3945: U iwl3945_hw_nic_init 3945 RADIO-MM type
[  903.964984] iwl3945: U iwl3945_hw_nic_init SKU OP mode is basic
[  903.964987] iwl3945: U iwl3945_hw_nic_init 3945ABG revision is 0xF1
[  903.964995] iwl3945: U iwl3945_hw_nic_init Card M type B version is 0x2
[  903.965881] iwl3945: U iwl3945_load_bsm Begin load bsm
[  903.967136] iwl3945: U iwl3945_verify_bsm Begin verify bsm
[  903.968755] iwl3945: U iwl3945_verify_bsm BSM bootstrap uCode image OK
[  903.968755] iwl3945: U iwl3945_load_bsm BSM write complete, poll 1 iterations
[  903.968755] iwl3945: U __iwl3945_up iwl3945 is coming up
[  903.826522] iwl3945: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
[  903.826522] iwl3945: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
[  903.826522] iwl3945: I iwl3945_rx_reply_alive Initialization Alive received.
[  903.988268] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 900
[  903.988268] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 2668
[  903.988268] iwl3945: U iwl3945_verify_ucode Initialize uCode is good in inst SRAM
[  903.988268] iwl3945: U iwl3945_init_alive_start Initialization Alive received.
[  903.988268] iwl3945: U iwl3945_set_ucode_ptrs Runtime uCode pointers are set.
[  903.993418] iwl3945: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
[  903.993418] iwl3945: I iwl3945_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
[  903.993418] iwl3945: I iwl3945_rx_reply_alive Runtime Alive received.
[  903.993418] iwl3945: I iwl3945_disable_events Selected uCode log events may be disabled
[  903.993418] iwl3945: I iwl3945_disable_events   by writing "1"s into disable bitmap
[  903.993418] iwl3945: I iwl3945_disable_events   in SRAM at 0x8015f4, size 47 u32s
[  904.000733] iwl3945: U iwl3945_alive_start Runtime Alive received.
[  904.000733] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 900
[  904.000733] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 2668
[  904.000733] iwl3945: U iwl3945_verify_inst_sparse ucode inst image size is 80524
[  904.000733] iwl3945: U iwl3945_verify_ucode Runtime uCode is good in inst SRAM
[  904.000733] iwl3945: U iwl3945_alive_start RFKILL status: 0x1
[  904.000733] iwl3945: U iwl3945_update_power_cmd Flags value = 0x00000008
[  904.000733] iwl3945: U iwl3945_update_power_cmd Tx timeout = 0
[  904.000733] iwl3945: U iwl3945_update_power_cmd Rx timeout = 0
[  904.000733] iwl3945: U iwl3945_update_power_cmd Sleep interval vector = { 0 , 0 , 0 , 0 , 0 }
[  904.000733] iwl3945: U iwl3945_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 36 bytes at 0[0]:4
[  904.012759] iwl3945: I iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
[  904.000733] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
[  904.000733] iwl3945: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
[  904.000733] iwl3945: U iwl3945_commit_rxon Sending RXON
[  904.000733] * without RXON_FILTER_ASSOC_MSK
[  904.000733] * channel = 1
[  904.000733] * bssid = 00:00:00:00:00:00
[  904.000733] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48 bytes at 2[2]:4
[  904.016735] iwl3945: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0d
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0f
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x05
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x07
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x09
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x0b
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x01
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 115 rate code 0x03
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x0a
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x14
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x37
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 171 dsp 110 rate code 0x6e
[  904.000733] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0403, 56 bytes at 3[3]:4
[  904.000733] iwl3945: I iwl3945_rx_handle r 6 i 5 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
[  904.000733] iwl3945: U iwl3945_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
[  904.000733] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68 bytes at 4[4]:4
[  904.020735] iwl3945: I iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
[  904.000733] iwl3945: U iwl3945_send_add_station REPLY_ADD_STA PASSED
[  904.000733] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
[  904.000733] iwl3945: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
[  904.000733] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406, 56 bytes at 6[6]:4
[  904.030303] iwl3945: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
[  904.000733] iwl3945: U iwl3945_hw_reg_txpower_get_temperature Temperature: 103
[  904.000733] iwl3945: U is_temp_calib_needed Getting warmer, delta 11,
[  904.000733] iwl3945: U is_temp_calib_needed Timed thermal calib needed
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 115 dsp 107 rate code 0x0d
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 115 dsp 107 rate code 0x0f
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 115 dsp 107 rate code 0x05
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 115 dsp 107 rate code 0x07
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 115 dsp 107 rate code 0x09
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 115 dsp 107 rate code 0x0b
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 115 dsp 107 rate code 0x01
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 235 dsp 121 rate code 0x03
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  92 rate code 0x0a
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  92 rate code 0x14
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  92 rate code 0x37
[  904.000733] iwl3945: U iwl3945_hw_reg_send_txpower ch 1:1 rf 203 dsp  92 rate code 0x6e
[  904.000733] iwl3945: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0407, 56 bytes at 7[7]:4
[  904.000733] iwl3945: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
[  904.000733] iwl3945: U iwl3945_alive_start ALIVE processing complete.
[  904.000733] iwl3945: I iwl3945_rx_handle r = 11, i = 10, REPLY_3945_RX, 0x1b
[  904.196012] iwl3945: I iwl3945_rx_handle r = 12, i = 11, REPLY_3945_RX, 0x1b
[  904.000733] iwl3945: I iwl3945_rx_handle r = 13, i = 12, REPLY_3945_RX, 0x1b
[  904.000733] iwl3945: I iwl3945_rx_handle r = 14, i = 13, REPLY_3945_RX, 0x1b
[  904.505066] iwl3945: I iwl3945_rx_handle r = 15, i = 14, REPLY_3945_RX, 0x1b
[  904.609065] iwl3945: I iwl3945_rx_handle r = 16, i = 15, REPLY_3945_RX, 0x1b
[  904.711355] iwl3945: I iwl3945_rx_handle r = 17, i = 16, REPLY_3945_RX, 0x1b
[  904.815206] iwl3945: I iwl3945_rx_handle r = 18, i = 17, REPLY_3945_RX, 0x1b
[  904.920368] iwl3945: I iwl3945_rx_handle r = 19, i = 18, REPLY_3945_RX, 0x1b
[  905.023113] iwl3945: I iwl3945_rx_handle r = 20, i = 19, REPLY_3945_RX, 0x1b
[  905.126662] iwl3945: I iwl3945_rx_handle r = 21, i = 20, REPLY_3945_RX, 0x1b
[  905.227222] iwl3945: I iwl3945_rx_handle r = 22, i = 21, REPLY_3945_RX, 0x1b
[  905.331355] iwl3945: I iwl3945_rx_handle r = 23, i = 22, REPLY_3945_RX, 0x1b
[  905.434947] iwl3945: I iwl3945_rx_handle r = 24, i = 23, REPLY_3945_RX, 0x1b
[  905.539972] iwl3945: I iwl3945_rx_handle r = 25, i = 24, REPLY_3945_RX, 0x1b
[  905.642494] iwl3945: I iwl3945_rx_handle r = 26, i = 25, REPLY_3945_RX, 0x1b
[  905.744482] iwl3945: I iwl3945_rx_handle r = 27, i = 26, REPLY_3945_RX, 0x1b
[  905.849903] iwl3945: I iwl3945_rx_handle r = 28, i = 27, REPLY_3945_RX, 0x1b
[  905.952192] iwl3945: I iwl3945_rx_handle r = 29, i = 28, REPLY_3945_RX, 0x1b
[  906.054561] iwl3945: I iwl3945_rx_handle r = 30, i = 29, REPLY_3945_RX, 0x1b
[  906.157937] iwl3945: I iwl3945_rx_handle r = 31, i = 30, REPLY_3945_RX, 0x1b
[  906.261683] iwl3945: I iwl3945_rx_handle r = 32, i = 31, REPLY_3945_RX, 0x1b
[  906.370057] iwl3945: I iwl3945_rx_handle r = 33, i = 32, REPLY_3945_RX, 0x1b
[  906.470651] iwl3945: I iwl3945_rx_handle r = 34, i = 33, REPLY_3945_RX, 0x1b
[  906.575539] iwl3945: I iwl3945_rx_handle r = 35, i = 34, REPLY_3945_RX, 0x1b
[  906.676958] iwl3945: I iwl3945_rx_handle r = 36, i = 35, REPLY_3945_RX, 0x1b
[  906.781907] iwl3945: I iwl3945_rx_handle r = 37, i = 36, REPLY_3945_RX, 0x1b
[  906.884714] iwl3945: I iwl3945_rx_handle r = 38, i = 37, REPLY_3945_RX, 0x1b
[  906.988825] iwl3945: I iwl3945_rx_handle r = 39, i = 38, REPLY_3945_RX, 0x1b
[  907.095015] iwl3945: I iwl3945_rx_handle r = 40, i = 39, REPLY_3945_RX, 0x1b
[  907.199731] iwl3945: I iwl3945_rx_handle r = 41, i = 40, REPLY_3945_RX, 0x1b
[  907.300281] iwl3945: I iwl3945_rx_handle r = 42, i = 41, REPLY_3945_RX, 0x1b
[  907.404449] iwl3945: I iwl3945_rx_handle r = 43, i = 42, REPLY_3945_RX, 0x1b
[  907.510529] iwl3945: I iwl3945_rx_handle r = 44, i = 43, REPLY_3945_RX, 0x1b
[  907.613230] iwl3945: I iwl3945_rx_handle r = 45, i = 44, REPLY_3945_RX, 0x1b
[  907.717176] iwl3945: I iwl3945_rx_handle r = 46, i = 45, REPLY_3945_RX, 0x1b
[  907.822254] iwl3945: I iwl3945_rx_handle r = 47, i = 46, REPLY_3945_RX, 0x1b
[  907.926898] iwl3945: I iwl3945_rx_handle r = 48, i = 47, REPLY_3945_RX, 0x1b
[  908.029811] iwl3945: I iwl3945_rx_handle r = 49, i = 48, REPLY_3945_RX, 0x1b
[  908.131948] iwl3945: I iwl3945_rx_handle r = 50, i = 49, REPLY_3945_RX, 0x1b
[  908.234352] iwl3945: I iwl3945_rx_handle r = 51, i = 50, REPLY_3945_RX, 0x1b
[  908.337689] iwl3945: I iwl3945_rx_handle r = 52, i = 51, REPLY_3945_RX, 0x1b
[  908.443049] iwl3945: I iwl3945_rx_handle r = 53, i = 52, REPLY_3945_RX, 0x1b
[  908.545376] iwl3945: I iwl3945_rx_handle r = 54, i = 53, REPLY_3945_RX, 0x1b
[  908.648575] iwl3945: I iwl3945_rx_handle r = 55, i = 54, REPLY_3945_RX, 0x1b
[  908.753390] iwl3945: I iwl3945_rx_handle r = 56, i = 55, REPLY_3945_RX, 0x1b
[  908.856486] iwl3945: I iwl3945_rx_handle r = 57, i = 56, REPLY_3945_RX, 0x1b
[  908.964186] iwl3945: I iwl3945_rx_handle r = 58, i = 57, REPLY_3945_RX, 0x1b
[  909.069826] iwl3945: I iwl3945_rx_handle r = 59, i = 58, REPLY_3945_RX, 0x1b
[  909.172541] iwl3945: I iwl3945_rx_handle r = 60, i = 59, REPLY_3945_RX, 0x1b
[  909.275431] iwl3945: I iwl3945_rx_handle r = 61, i = 60, REPLY_3945_RX, 0x1b
[  909.376238] iwl3945: I iwl3945_rx_handle r = 62, i = 61, REPLY_3945_RX, 0x1b
[  909.479541] iwl3945: I iwl3945_rx_handle r = 63, i = 62, REPLY_3945_RX, 0x1b
[  909.582517] iwl3945: I iwl3945_rx_handle r = 64, i = 63, REPLY_3945_RX, 0x1b
[  909.687793] iwl3945: I iwl3945_rx_handle r = 65, i = 64, REPLY_3945_RX, 0x1b
[  909.790581] iwl3945: I iwl3945_rx_handle r = 66, i = 65, REPLY_3945_RX, 0x1b
[  909.895329] iwl3945: I iwl3945_rx_handle r = 67, i = 66, REPLY_3945_RX, 0x1b
[  909.999498] iwl3945: I iwl3945_rx_handle r = 68, i = 67, REPLY_3945_RX, 0x1b
[  910.101545] iwl3945: I iwl3945_rx_handle r = 69, i = 68, REPLY_3945_RX, 0x1b
[  910.206335] iwl3945: I iwl3945_rx_handle r = 70, i = 69, REPLY_3945_RX, 0x1b
[  910.307497] iwl3945: I iwl3945_rx_handle r = 71, i = 70, REPLY_3945_RX, 0x1b
[  910.410841] iwl3945: I iwl3945_rx_handle r = 72, i = 71, REPLY_3945_RX, 0x1b
[  910.513672] iwl3945: I iwl3945_rx_handle r = 73, i = 72, REPLY_3945_RX, 0x1b
[  910.615989] iwl3945: I iwl3945_rx_handle r = 74, i = 73, REPLY_3945_RX, 0x1b
[  910.718323] iwl3945: I iwl3945_rx_handle r = 75, i = 74, REPLY_3945_RX, 0x1b
[  910.824562] iwl3945: I iwl3945_rx_handle r = 76, i = 75, REPLY_3945_RX, 0x1b
[  910.923815] iwl3945: I iwl3945_rx_handle r = 77, i = 76, REPLY_3945_RX, 0x1b
[  911.033872] iwl3945: I iwl3945_rx_handle r = 78, i = 77, REPLY_3945_RX, 0x1b
[  911.137937] iwl3945: I iwl3945_rx_handle r = 79, i = 78, REPLY_3945_RX, 0x1b
[  911.238903] iwl3945: I iwl3945_rx_handle r = 80, i = 79, REPLY_3945_RX, 0x1b
[  911.344156] iwl3945: I iwl3945_rx_handle r = 81, i = 80, REPLY_3945_RX, 0x1b
[  911.450076] iwl3945: I iwl3945_rx_handle r = 82, i = 81, REPLY_3945_RX, 0x1b
[  911.551590] iwl3945: I iwl3945_rx_handle r = 83, i = 82, REPLY_3945_RX, 0x1b
[  911.654853] iwl3945: I iwl3945_rx_handle r = 84, i = 83, REPLY_3945_RX, 0x1b
[  911.758134] iwl3945: I iwl3945_rx_handle r = 85, i = 84, REPLY_3945_RX, 0x1b
[  911.863013] iwl3945: I iwl3945_rx_handle r = 86, i = 85, REPLY_3945_RX, 0x1b
[  911.967679] iwl3945: I iwl3945_rx_handle r = 87, i = 86, REPLY_3945_RX, 0x1b
[  912.072223] iwl3945: I iwl3945_rx_handle r = 88, i = 87, REPLY_3945_RX, 0x1b
[  912.175516] iwl3945: I iwl3945_rx_handle r = 89, i = 88, REPLY_3945_RX, 0x1b
[  912.277575] iwl3945: I iwl3945_rx_handle r = 90, i = 89, REPLY_3945_RX, 0x1b
[  912.383813] iwl3945: I iwl3945_rx_handle r = 91, i = 90, REPLY_3945_RX, 0x1b
[  912.487476] iwl3945: I iwl3945_rx_handle r = 92, i = 91, REPLY_3945_RX, 0x1b
[  912.590888] iwl3945: I iwl3945_rx_handle r = 93, i = 92, REPLY_3945_RX, 0x1b
[  912.695053] iwl3945: I iwl3945_rx_handle r = 94, i = 93, REPLY_3945_RX, 0x1b
[  912.796621] iwl3945: I iwl3945_rx_handle r = 95, i = 94, REPLY_3945_RX, 0x1b
[  912.903619] iwl3945: I iwl3945_rx_handle r = 96, i = 95, REPLY_3945_RX, 0x1b
[  913.003080] iwl3945: I iwl3945_rx_handle r = 97, i = 96, REPLY_3945_RX, 0x1b
[  913.107853] iwl3945: I iwl3945_rx_handle r = 98, i = 97, REPLY_3945_RX, 0x1b
[  913.211077] iwl3945: I iwl3945_rx_handle r = 99, i = 98, REPLY_3945_RX, 0x1b
[  913.312755] iwl3945: I iwl3945_rx_handle r = 100, i = 99, REPLY_3945_RX, 0x1b
[  913.416518] iwl3945: I iwl3945_rx_handle r = 101, i = 100, REPLY_3945_RX, 0x1b
[  913.523089] iwl3945: I iwl3945_rx_handle r = 102, i = 101, REPLY_3945_RX, 0x1b
[  913.623984] iwl3945: I iwl3945_rx_handle r = 103, i = 102, REPLY_3945_RX, 0x1b
[  913.730164] iwl3945: I iwl3945_rx_handle r = 104, i = 103, REPLY_3945_RX, 0x1b
[  913.836261] iwl3945: I iwl3945_rx_handle r = 105, i = 104, REPLY_3945_RX, 0x1b
[  913.944525] iwl3945: I iwl3945_rx_handle r = 106, i = 105, REPLY_3945_RX, 0x1b
[  914.047370] iwl3945: I iwl3945_rx_handle r = 107, i = 106, REPLY_3945_RX, 0x1b
[  914.150645] iwl3945: I iwl3945_rx_handle r = 108, i = 107, REPLY_3945_RX, 0x1b
[  914.254441] iwl3945: I iwl3945_rx_handle r = 109, i = 108, REPLY_3945_RX, 0x1b
[  914.363621] iwl3945: I iwl3945_rx_handle r = 110, i = 109, REPLY_3945_RX, 0x1b
[  914.467996] iwl3945: I iwl3945_rx_handle r = 111, i = 110, REPLY_3945_RX, 0x1b
[  914.571995] iwl3945: I iwl3945_rx_handle r = 112, i = 111, REPLY_3945_RX, 0x1b
[  914.676813] iwl3945: I iwl3945_rx_handle r = 113, i = 112, REPLY_3945_RX, 0x1b
[  914.779387] iwl3945: I iwl3945_rx_handle r = 114, i = 113, REPLY_3945_RX, 0x1b
[  914.881138] iwl3945: I iwl3945_rx_handle r = 115, i = 114, REPLY_3945_RX, 0x1b
[  914.984393] iwl3945: I iwl3945_rx_handle r = 116, i = 115, REPLY_3945_RX, 0x1b
[  915.086927] iwl3945: I iwl3945_rx_handle r = 117, i = 116, REPLY_3945_RX, 0x1b
[  915.191157] iwl3945: I iwl3945_rx_handle r = 118, i = 117, REPLY_3945_RX, 0x1b
[  915.294049] iwl3945: I iwl3945_rx_handle r = 119, i = 118, REPLY_3945_RX, 0x1b
[  915.400184] iwl3945: I iwl3945_rx_handle r = 120, i = 119, REPLY_3945_RX, 0x1b
[  915.500738] iwl3945: I iwl3945_rx_handle r = 121, i = 120, REPLY_3945_RX, 0x1b
[  915.602275] iwl3945: I iwl3945_rx_handle r = 122, i = 121, REPLY_3945_RX, 0x1b
[  915.705612] iwl3945: I iwl3945_rx_handle r = 123, i = 122, REPLY_3945_RX, 0x1b
[  915.807086] iwl3945: I iwl3945_rx_handle r = 124, i = 123, REPLY_3945_RX, 0x1b
[  915.910337] iwl3945: I iwl3945_rx_handle r = 125, i = 124, REPLY_3945_RX, 0x1b
[  916.012725] iwl3945: I iwl3945_rx_handle r = 126, i = 125, REPLY_3945_RX, 0x1b
[  916.115140] iwl3945: I iwl3945_rx_handle r = 127, i = 126, REPLY_3945_RX, 0x1b
[  916.221353] iwl3945: I iwl3945_rx_handle r = 128, i = 127, REPLY_3945_RX, 0x1b
[  916.328488] iwl3945: I iwl3945_rx_handle r = 129, i = 128, REPLY_3945_RX, 0x1b
[  916.432657] iwl3945: I iwl3945_rx_handle r = 130, i = 129, REPLY_3945_RX, 0x1b
[  916.536670] iwl3945: I iwl3945_rx_handle r = 131, i = 130, REPLY_3945_RX, 0x1b
[  916.639058] iwl3945: I iwl3945_rx_handle r = 132, i = 131, REPLY_3945_RX, 0x1b
[  916.744643] iwl3945: I iwl3945_rx_handle r = 133, i = 132, REPLY_3945_RX, 0x1b
[  916.848746] iwl3945: I iwl3945_rx_handle r = 134, i = 133, REPLY_3945_RX, 0x1b
[  916.951552] iwl3945: I iwl3945_rx_handle r = 135, i = 134, REPLY_3945_RX, 0x1b
[  917.055915] iwl3945: I iwl3945_rx_handle r = 136, i = 135, REPLY_3945_RX, 0x1b
[  917.159119] iwl3945: I iwl3945_rx_handle r = 137, i = 136, REPLY_3945_RX, 0x1b
[  917.264287] iwl3945: I iwl3945_rx_handle r = 138, i = 137, REPLY_3945_RX, 0x1b
[  917.366670] iwl3945: I iwl3945_rx_handle r = 139, i = 138, REPLY_3945_RX, 0x1b
[  917.470456] iwl3945: I iwl3945_rx_handle r = 140, i = 139, REPLY_3945_RX, 0x1b
[  917.562126] APIC error on CPU0: 40(40)
[  917.578719] iwl3945: I iwl3945_rx_handle r = 141, i = 140, REPLY_3945_RX, 0x1b
[  917.677882] iwl3945: I iwl3945_rx_handle r = 142, i = 141, REPLY_3945_RX, 0x1b
[  917.782914] iwl3945: I iwl3945_rx_handle r = 143, i = 142, REPLY_3945_RX, 0x1b
[  917.805236] APIC error on CPU0: 40(40)
[  917.886867] iwl3945: I iwl3945_rx_handle r = 144, i = 143, REPLY_3945_RX, 0x1b
[  917.990335] iwl3945: I iwl3945_rx_handle r = 145, i = 144, REPLY_3945_RX, 0x1b
[  918.093254] iwl3945: I iwl3945_rx_handle r = 146, i = 145, REPLY_3945_RX, 0x1b
[  918.200135] iwl3945: I iwl3945_rx_handle r = 147, i = 146, REPLY_3945_RX, 0x1b
[  918.303558] iwl3945: I iwl3945_rx_handle r = 148, i = 147, REPLY_3945_RX, 0x1b
[  918.407554] iwl3945: I iwl3945_rx_handle r = 149, i = 148, REPLY_3945_RX, 0x1b
[  918.510327] iwl3945: I iwl3945_rx_handle r = 150, i = 149, REPLY_3945_RX, 0x1b
[  918.612698] iwl3945: I iwl3945_rx_handle r = 151, i = 150, REPLY_3945_RX, 0x1b
[  918.717753] iwl3945: I iwl3945_rx_handle r = 152, i = 151, REPLY_3945_RX, 0x1b
[  918.821177] iwl3945: I iwl3945_rx_handle r = 153, i = 152, REPLY_3945_RX, 0x1b
[  918.923409] iwl3945: I iwl3945_rx_handle r = 154, i = 153, REPLY_3945_RX, 0x1b
[  919.025810] iwl3945: I iwl3945_rx_handle r = 155, i = 154, REPLY_3945_RX, 0x1b
[  919.129229] iwl3945: I iwl3945_rx_handle r = 156, i = 155, REPLY_3945_RX, 0x1b
[  919.235161] iwl3945: I iwl3945_rx_handle r = 157, i = 156, REPLY_3945_RX, 0x1b
[  919.338217] iwl3945: I iwl3945_rx_handle r = 158, i = 157, REPLY_3945_RX, 0x1b
[  919.440422] iwl3945: I iwl3945_rx_handle r = 159, i = 158, REPLY_3945_RX, 0x1b
[  919.543128] iwl3945: I iwl3945_rx_handle r = 160, i = 159, REPLY_3945_RX, 0x1b
[  919.646116] iwl3945: I iwl3945_rx_handle r = 161, i = 160, REPLY_3945_RX, 0x1b
[  919.748515] iwl3945: I iwl3945_rx_handle r = 162, i = 161, REPLY_3945_RX, 0x1b
[  919.852301] iwl3945: I iwl3945_rx_handle r = 163, i = 162, REPLY_3945_RX, 0x1b
[  919.955427] iwl3945: I iwl3945_rx_handle r = 164, i = 163, REPLY_3945_RX, 0x1b
[  920.061572] iwl3945: I iwl3945_rx_handle r = 165, i = 164, REPLY_3945_RX, 0x1b
[  920.168426] iwl3945: I iwl3945_rx_handle r = 166, i = 165, REPLY_3945_RX, 0x1b
[  920.270509] iwl3945: I iwl3945_rx_handle r = 167, i = 166, REPLY_3945_RX, 0x1b
[  920.375533] iwl3945: I iwl3945_rx_handle r = 168, i = 167, REPLY_3945_RX, 0x1b
[  920.480022] iwl3945: I iwl3945_rx_handle r = 169, i = 168, REPLY_3945_RX, 0x1b
[  920.585277] iwl3945: I iwl3945_rx_handle r = 170, i = 169, REPLY_3945_RX, 0x1b
[  920.688215] iwl3945: I iwl3945_rx_handle r = 171, i = 170, REPLY_3945_RX, 0x1b
[  920.793857] iwl3945: I iwl3945_rx_handle r = 172, i = 171, REPLY_3945_RX, 0x1b

--------------060506070106030406010902--

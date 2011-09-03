Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:25447 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab1ICOKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Sep 2011 10:10:38 -0400
Received: from probook.site
	(dslb-088-065-125-090.pools.arcor-ip.net [88.65.125.90])
	by smtp.strato.de (jimi mo9) (RZmta 26.6)
	with (DHE-RSA-AES256-SHA encrypted) ESMTPA id m0285cn83CajIh
	for <linux-wireless@vger.kernel.org>;
	Sat, 3 Sep 2011 16:10:09 +0200 (MEST)
Date: Sat, 3 Sep 2011 16:10:08 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-wireless@vger.kernel.org
Subject: brcm80211 crashes on HP ProBook 6555b
Message-ID: <20110903141008.GA7071@aepfle.de> (sfid-20110903_161048_781733_81D92B46)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I tried brcm80211 from the current linux-staging tree on a HP Probook 6555b.
Running 'iw wlan0 scan dump' freezes the system, no keyboard input possible, no
response to ping anymore. Earlier versions of the driver showed the same
freeze.
The firmware files are up to date, from linux-firmware.git.

Below is a serial console log from such a freeze.

Has the driver been tested on 64bit?


Olaf

00:00.0 Host bridge: Advanced Micro Devices [AMD] RS880 Host Bridge
00:01.0 PCI bridge: Hewlett-Packard Company Device 9602
00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 0)
00:05.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 1)
00:07.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 3)
00:09.0 PCI bridge: Advanced Micro Devices [AMD] RS780/RS880 PCI to PCI bridge (PCIE port 4)
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode]
00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 41)
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA) (rev 40)
00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller (rev 40)
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40)
00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller
00:16.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
00:16.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Link Control
01:05.0 VGA compatible controller: ATI Technologies Inc M880G [Mobility Radeon HD 4200]
01:05.1 Audio device: ATI Technologies Inc RS880 Audio Device [Radeon HD 4200]
02:00.0 Ethernet controller: Marvell Technology Group Ltd. Yukon Optima 88E8059 [PCIe Gigabit Ethernet Controller with AVB] (rev 11)
03:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller (rev 01)
03:00.1 System peripheral: Ricoh Co Ltd Memory Stick Host Controller (rev 01)
03:00.2 System peripheral: Ricoh Co Ltd Device e852 (rev 01)
03:00.3 FireWire (IEEE 1394): Ricoh Co Ltd FireWire Host Controller (rev 01)
07:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller (rev 01)

07:00.0 0280: 14e4:4727 (rev 01)


[    0.000000] Linux version 3.1.0-rc4-git2-20110903.1332.58-kernel-linux-3_1 (abuild@optiplex) (gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #1 SMP Sat Sep 3 13:36:46 UTC 2011
[    0.000000] Command line: quiet panic=9 sysrq=yes resume=/dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part8 log_buf_len=32M ignore_loglevel console=ttyS0,115200 1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000af6cf000 (usable)
[    0.000000]  BIOS-e820: 00000000af6cf000 - 00000000afdcf000 (reserved)
[    0.000000]  BIOS-e820: 00000000afdcf000 - 00000000afecf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000afecf000 - 00000000afeff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000afeff000 - 00000000aff00000 (usable)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Hewlett-Packard HP ProBook 6555b/1455, BIOS 68DTM Ver. F.09 05/04/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x240000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFE0000000 write-back
[    0.000000]   2 base 0000A0000000 mask FFFFF0000000 write-back
[    0.000000]   3 base 000100000000 mask FFFF00000000 write-back
[    0.000000]   4 base 000200000000 mask FFFFC0000000 write-back
[    0.000000]   5 base 0000FFE00000 mask FFFFFFE00000 write-protect
[    0.000000]   6 base 0000FFF40000 mask FFFFFFFF0000 write-protect
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000240000000 aka 9216M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xaff00 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000aff00000
[    0.000000]  0000000000 - 0080000000 page 1G
[    0.000000]  0080000000 - 00afe00000 page 2M
[    0.000000]  00afe00000 - 00aff00000 page 4k
[    0.000000] kernel direct mapping tables up to aff00000 @ af6cc000-af6cf000
[    0.000000] init_memory_mapping: 0000000100000000-0000000240000000
[    0.000000]  0100000000 - 0240000000 page 1G
[    0.000000] kernel direct mapping tables up to 240000000 @ 23ffff000-240000000
[    0.000000] log_buf_len: 33554432
[    0.000000] early log buf free: 2093431(99%)
[    0.000000] RAMDISK: 374de000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f2a70 00014 (v00 HPQOEM)
[    0.000000] ACPI: RSDT 00000000afefe038 00044 (v01 HPQOEM SLIC-MPC 00000003      01000013)
[    0.000000] ACPI: FACP 00000000afefd000 00074 (v01 HPQOEM 307E     00000003 HP   00000001)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20110623/tbfadt-560)
[    0.000000] ACPI: DSDT 00000000afedd000 1C046 (v01 HPQOEM   SB700  00000001 INTL 20060912)
[    0.000000] ACPI: FACS 00000000afe7e000 00040
[    0.000000] ACPI: APIC 00000000afefc000 00084 (v01 HPQOEM 307E     00000001 HP   00000001)
[    0.000000] ACPI: MCFG 00000000afefb000 0003C (v01 HPQOEM 307E     00000001 HP   00000001)
[    0.000000] ACPI: SLIC 00000000afefa000 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
[    0.000000] ACPI: SSDT 00000000afedc000 0005F (v01 HPQOEM   HPQNLP 00000001 INTL 20060912)
[    0.000000] ACPI: TCPA 00000000afedb000 00032 (v02 HPQOEM 307E     00000000 HP   00000001)
[    0.000000] ACPI: HPET 00000000afeda000 00038 (v01 HPQOEM 307E     00000001 HP   00000001)
[    0.000000] ACPI: SSDT 00000000afed9000 007AD (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0008ffffff] PMD -> [ffff880235a00000-ffff88023d5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00240000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000af6cf
[    0.000000]     0: 0x000afeff -> 0x000aff00
[    0.000000]     0: 0x00100000 -> 0x00240000
[    0.000000] On node 0 totalpages: 2029151
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3914 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 698128 pages, LIFO batch:31
[    0.000000]   Normal zone: 20480 pages used for memmap
[    0.000000]   Normal zone: 1290240 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538301 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 1 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000af6cf000 - 00000000afdcf000
[    0.000000] PM: Registered nosave memory: 00000000afdcf000 - 00000000afecf000
[    0.000000] PM: Registered nosave memory: 00000000afecf000 - 00000000afeff000
[    0.000000] PM: Registered nosave memory: 00000000aff00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fec11000
[    0.000000] PM: Registered nosave memory: 00000000fec11000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at aff00000 (gap: aff00000:30100000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88023dc00000 s74560 r8192 d23744 u524288
[    0.000000] pcpu-alloc: s74560 r8192 d23744 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1992282
[    0.000000] Kernel command line: quiet panic=9 sysrq=yes resume=/dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part8 log_buf_len=32M ignore_loglevel console=ttyS0,115200 1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ a4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ a4000000
[    0.000000] PM: Registered nosave memory: 00000000a4000000 - 00000000a8000000
[    0.000000] Memory: 7787308k/9437184k available (4918k kernel code, 1320580k absent, 329296k reserved, 5768k data, 572k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:512
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2094.647 MHz processor.
[    0.008003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4189.29 BogoMIPS (lpj=8378588)
[    0.016003] pid_max: default: 32768 minimum: 301
[    0.020051] Mount-cache hash table entries: 256
[    0.024152] tseg: 00aff00000
[    0.028004] CPU: Physical Processor ID: 0
[    0.032003] CPU: Processor Core ID: 0
[    0.036004] mce: CPU supports 6 MCE banks
[    0.040011] using AMD E400 aware idle routine
[    0.044699] ACPI: Core revision 20110623
[    0.056331] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.100942] CPU0: AMD Phenom(tm) II N830 Triple-Core Processor stepping 03
[    0.108005] Performance Events: AMD PMU driver.
[    0.108009] ... version:                0
[    0.112007] ... bit width:              48
[    0.116007] ... generic registers:      4
[    0.120007] ... value mask:             0000ffffffffffff
[    0.124008] ... max period:             00007fffffffffff
[    0.128008] ... fixed-purpose events:   0
[    0.132008] ... event mask:             000000000000000f
[    0.136077] MCE: In-kernel MCE decoding enabled.
[    0.140061] Booting Node   0, Processors  #1
[    0.144277] smpboot cpu 1: start_ip = 9a000
[    0.244030] System has AMD C1E enabled
[    0.244060]  #2
[    0.244061] smpboot cpu 2: start_ip = 9a000
[    0.248014] Switch to broadcast mode on CPU1
[    0.336030] Brought up 3 CPUs
[    0.336033] Switch to broadcast mode on CPU2
[    0.340027] Total of 3 processors activated (12568.37 BogoMIPS).
[    0.344483] Switch to broadcast mode on CPU0
[    0.348101] devtmpfs: initialized
[    0.351347] device: 'platform': device_add
[    0.352030] PM: Adding info for No Bus:platform
[    0.356032] bus: 'platform': registered
[    0.360023] Registering sysdev class 'cpu'
[    0.364113] PM: Registering ACPI NVS region at afdcf000 (1048576 bytes)
[    0.368106] NET: Registered protocol family 16
[    0.372029] device class 'bdi': registering
[    0.376029] device class 'pci_bus': registering
[    0.380035] bus: 'pci': registered
[    0.383414] device class 'backlight': registering
[    0.384027] device class 'tty': registering
[    0.388027] device class 'vtconsole': registering
[    0.392029] device: 'vtcon0': device_add
[    0.396031] PM: Adding info for No Bus:vtcon0
[    0.400034] bus: 'i2c': registered
[    0.404027] bus: 'i2c': add driver dummy
[    0.408033] node 0 link 0: io port [0, ffffff]
[    0.412027] TOM: 00000000c0000000 aka 3072M
[    0.416026] Fam 10h mmconf [e0000000, efffffff]
[    0.420027] node 0 link 0: mmio [c0000000, cfffffff]
[    0.424208] node 0 link 0: mmio [d0000000, d62fffff]
[    0.428208] node 0 link 0: mmio [d6300000, d64fffff]
[    0.432208] node 0 link 0: mmio [d6500000, dfffffff]
[    0.436209] node 0 link 0: mmio [e0000000, e0ffffff] ==> none
[    0.440988] node 0 link 0: mmio [e1000000, ffb7ffff] ==> [f0000000, ffb7ffff]
[    0.446380] TOM2: 0000000240000000 aka 9216M
[    0.448028] bus: [00, 1f] on node 0 link 0
[    0.452029] bus: 00 index 0 [io  0x0000-0xffff]
[    0.456029] bus: 00 index 1 [mem 0xc0000000-0xdfffffff]
[    0.460029] bus: 00 index 2 [mem 0xf0000000-0xffffffff]
[    0.464029] bus: 00 index 3 [mem 0x240000000-0xfcffffffff]
[    0.468036] Extended Config Space enabled on 1 nodes
[    0.472058] ACPI: bus type pci registered
[    0.476031] device class 'dmi': registering
[    0.480035] device: 'id': device_add
[    0.483600] PM: Adding info for No Bus:id
[    0.484062] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.488032] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.520261] PCI: Using configuration type 1 for base access
[    0.524038] Registering sys device of class 'cpu'
[    0.528038] Registering sys device 'cpu0'
[    0.532040] Registering sys device of class 'cpu'
[    0.536035] Registering sys device 'cpu1'
[    0.540036] Registering sys device of class 'cpu'
[    0.544035] Registering sys device 'cpu2'
[    0.548037] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.552034] mtrr: probably your BIOS does not setup all CPUs.
[    0.556034] mtrr: corrected configuration.
[    0.564252] device: 'default': device_add
[    0.568045] PM: Adding info for No Bus:default
[    0.572067] bio: create slab <bio-0> at 0
[    0.576050] device class 'block': registering
[    0.580069] device class 'graphics': registering
[    0.584058] ACPI: Added _OSI(Module Device)
[    0.588037] ACPI: Added _OSI(Processor Device)
[    0.592037] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.596037] ACPI: Added _OSI(Processor Aggregator Device)
[    0.601231] ACPI: EC: Look up EC in DSDT
[    0.605296] ACPI: Executed 1 blocks of module-level executable AML code
[    0.732223] ACPI: Interpreter enabled
[    0.732223] ACPI: (supports S0 S3 S4 S5)
[    0.736057] ACPI: Using IOAPIC for interrupt routing
[    0.740223] bus: 'acpi': registered
[    0.744056] bus: 'acpi': add driver power
[    0.748078] device: 'LNXSYSTM:00': device_add
[    0.752060] bus: 'acpi': add device LNXSYSTM:00
[    0.756061] PM: Adding info for acpi:LNXSYSTM:00
[    0.760077] device: 'LNXCPU:00': device_add
[    0.764058] bus: 'acpi': add device LNXCPU:00
[    0.768059] PM: Adding info for acpi:LNXCPU:00
[    0.772067] device: 'LNXCPU:01': device_add
[    0.776054] bus: 'acpi': add device LNXCPU:01
[    0.780060] PM: Adding info for acpi:LNXCPU:01
[    0.784066] device: 'LNXCPU:02': device_add
[    0.788059] bus: 'acpi': add device LNXCPU:02
[    0.792063] PM: Adding info for acpi:LNXCPU:02
[    0.796064] device: 'LNXCPU:03': device_add
[    0.800055] bus: 'acpi': add device LNXCPU:03
[    0.804057] PM: Adding info for acpi:LNXCPU:03
[    0.808083] device: 'device:00': device_add
[    0.812056] bus: 'acpi': add device device:00
[    0.816058] PM: Adding info for acpi:device:00
[    0.820089] device: 'PNP0A03:00': device_add
[    0.824057] bus: 'acpi': add device PNP0A03:00
[    0.828063] PM: Adding info for acpi:PNP0A03:00
[    0.832081] device: 'device:01': device_add
[    0.836057] bus: 'acpi': add device device:01
[    0.840065] PM: Adding info for acpi:device:01
[    0.844081] device: 'device:02': device_add
[    0.848058] bus: 'acpi': add device device:02
[    0.852060] PM: Adding info for acpi:device:02
[    0.856137] device: 'device:03': device_add
[    0.860059] bus: 'acpi': add device device:03
[    0.864061] PM: Adding info for acpi:device:03
[    0.868131] device: 'device:04': device_add
[    0.872060] bus: 'acpi': add device device:04
[    0.876062] PM: Adding info for acpi:device:04
[    0.880130] device: 'device:05': device_add
[    0.884061] bus: 'acpi': add device device:05
[    0.888061] PM: Adding info for acpi:device:05
[    0.892128] device: 'device:06': device_add
[    0.896062] bus: 'acpi': add device device:06
[    0.900063] PM: Adding info for acpi:device:06
[    0.904129] device: 'device:07': device_add
[    0.908063] bus: 'acpi': add device device:07
[    0.912064] PM: Adding info for acpi:device:07
[    0.916131] device: 'device:08': device_add
[    0.920063] bus: 'acpi': add device device:08
[    0.924065] PM: Adding info for acpi:device:08
[    0.928133] device: 'device:09': device_add
[    0.932064] bus: 'acpi': add device device:09
[    0.936064] PM: Adding info for acpi:device:09
[    0.940133] device: 'device:0a': device_add
[    0.944065] bus: 'acpi': add device device:0a
[    0.948070] PM: Adding info for acpi:device:0a
[    0.952132] device: 'device:0b': device_add
[    0.956066] bus: 'acpi': add device device:0b
[    0.960067] PM: Adding info for acpi:device:0b
[    0.964108] device: 'device:0c': device_add
[    0.968071] bus: 'acpi': add device device:0c
[    0.972068] PM: Adding info for acpi:device:0c
[    0.976111] device: 'device:0d': device_add
[    0.980067] bus: 'acpi': add device device:0d
[    0.984073] PM: Adding info for acpi:device:0d
[    0.988130] device: 'device:0e': device_add
[    0.992068] bus: 'acpi': add device device:0e
[    0.996070] PM: Adding info for acpi:device:0e
[    1.000130] device: 'device:0f': device_add
[    1.004069] bus: 'acpi': add device device:0f
[    1.008074] PM: Adding info for acpi:device:0f
[    1.012106] device: 'device:10': device_add
[    1.016069] bus: 'acpi': add device device:10
[    1.020071] PM: Adding info for acpi:device:10
[    1.024128] device: 'device:11': device_add
[    1.028070] bus: 'acpi': add device device:11
[    1.032072] PM: Adding info for acpi:device:11
[    1.036129] device: 'device:12': device_add
[    1.040071] bus: 'acpi': add device device:12
[    1.044073] PM: Adding info for acpi:device:12
[    1.048087] device: 'device:13': device_add
[    1.052071] bus: 'acpi': add device device:13
[    1.056078] PM: Adding info for acpi:device:13
[    1.060086] device: 'device:14': device_add
[    1.064072] bus: 'acpi': add device device:14
[    1.068079] PM: Adding info for acpi:device:14
[    1.072087] device: 'device:15': device_add
[    1.076073] bus: 'acpi': add device device:15
[    1.080079] PM: Adding info for acpi:device:15
[    1.084088] device: 'device:16': device_add
[    1.088073] bus: 'acpi': add device device:16
[    1.092080] PM: Adding info for acpi:device:16
[    1.096089] device: 'device:17': device_add
[    1.100074] bus: 'acpi': add device device:17
[    1.104081] PM: Adding info for acpi:device:17
[    1.108089] device: 'device:18': device_add
[    1.112075] bus: 'acpi': add device device:18
[    1.116083] PM: Adding info for acpi:device:18
[    1.120090] device: 'device:19': device_add
[    1.124076] bus: 'acpi': add device device:19
[    1.128082] PM: Adding info for acpi:device:19
[    1.132099] device: 'LNXPOWER:00': device_add
[    1.136076] bus: 'acpi': add device LNXPOWER:00
[    1.140078] PM: Adding info for acpi:LNXPOWER:00
[    1.144082] bus: 'acpi': driver_probe_device: matched device LNXPOWER:00 with driver power
[    1.148077] bus: 'acpi': really_probe: probing driver power with device LNXPOWER:00
[    1.152094] ACPI: Power Resource [APPR] (off)
[    1.156077] driver: 'LNXPOWER:00': driver_bound: bound to device 'power'
[    1.160082] bus: 'acpi': really_probe: bound device LNXPOWER:00 to driver power
[    1.164142] device: 'device:1a': device_add
[    1.168079] bus: 'acpi': add device device:1a
[    1.172085] PM: Adding info for acpi:device:1a
[    1.176160] device: 'device:1b': device_add
[    1.180080] bus: 'acpi': add device device:1b
[    1.184085] PM: Adding info for acpi:device:1b
[    1.188099] device: 'device:1c': device_add
[    1.192085] bus: 'acpi': add device device:1c
[    1.196083] PM: Adding info for acpi:device:1c
[    1.200095] device: 'device:1d': device_add
[    1.204086] bus: 'acpi': add device device:1d
[    1.208084] PM: Adding info for acpi:device:1d
[    1.212097] device: 'device:1e': device_add
[    1.216086] bus: 'acpi': add device device:1e
[    1.220084] PM: Adding info for acpi:device:1e
[    1.224157] device: 'device:1f': device_add
[    1.228083] bus: 'acpi': add device device:1f
[    1.232085] PM: Adding info for acpi:device:1f
[    1.236101] device: 'device:20': device_add
[    1.240083] bus: 'acpi': add device device:20
[    1.244090] PM: Adding info for acpi:device:20
[    1.248099] device: 'device:21': device_add
[    1.252084] bus: 'acpi': add device device:21
[    1.256090] PM: Adding info for acpi:device:21
[    1.260100] device: 'device:22': device_add
[    1.264084] bus: 'acpi': add device device:22
[    1.268094] PM: Adding info for acpi:device:22
[    1.272111] device: 'device:23': device_add
[    1.276086] bus: 'acpi': add device device:23
[    1.280086] PM: Adding info for acpi:device:23
[    1.284110] device: 'device:24': device_add
[    1.288092] bus: 'acpi': add device device:24
[    1.292089] PM: Adding info for acpi:device:24
[    1.296105] device: 'device:25': device_add
[    1.300087] bus: 'acpi': add device device:25
[    1.304090] PM: Adding info for acpi:device:25
[    1.308102] device: 'device:26': device_add
[    1.312087] bus: 'acpi': add device device:26
[    1.316090] PM: Adding info for acpi:device:26
[    1.320141] device: 'device:27': device_add
[    1.324089] bus: 'acpi': add device device:27
[    1.328091] PM: Adding info for acpi:device:27
[    1.332106] device: 'device:28': device_add
[    1.336098] bus: 'acpi': add device device:28
[    1.340096] PM: Adding info for acpi:device:28
[    1.344106] device: 'device:29': device_add
[    1.348090] bus: 'acpi': add device device:29
[    1.352097] PM: Adding info for acpi:device:29
[    1.356108] device: 'device:2a': device_add
[    1.360090] bus: 'acpi': add device device:2a
[    1.364097] PM: Adding info for acpi:device:2a
[    1.368146] device: 'device:2b': device_add
[    1.372092] bus: 'acpi': add device device:2b
[    1.376094] PM: Adding info for acpi:device:2b
[    1.380107] device: 'device:2c': device_add
[    1.384092] bus: 'acpi': add device device:2c
[    1.388095] PM: Adding info for acpi:device:2c
[    1.392109] device: 'device:2d': device_add
[    1.396093] bus: 'acpi': add device device:2d
[    1.400096] PM: Adding info for acpi:device:2d
[    1.404108] device: 'device:2e': device_add
[    1.408094] bus: 'acpi': add device device:2e
[    1.412103] PM: Adding info for acpi:device:2e
[    1.416112] device: 'device:2f': device_add
[    1.420095] bus: 'acpi': add device device:2f
[    1.424093] PM: Adding info for acpi:device:2f
[    1.428113] device: 'device:30': device_add
[    1.432096] bus: 'acpi': add device device:30
[    1.436098] PM: Adding info for acpi:device:30
[    1.440117] device: 'device:31': device_add
[    1.444096] bus: 'acpi': add device device:31
[    1.448099] PM: Adding info for acpi:device:31
[    1.452133] device: 'PNP0C09:00': device_add
[    1.456097] bus: 'acpi': add device PNP0C09:00
[    1.460102] PM: Adding info for acpi:PNP0C09:00
[    1.464160] device: 'PNP0200:00': device_add
[    1.468093] bus: 'acpi': add device PNP0200:00
[    1.472104] PM: Adding info for acpi:PNP0200:00
[    1.476116] device: 'PNP0C04:00': device_add
[    1.480098] bus: 'acpi': add device PNP0C04:00
[    1.484100] PM: Adding info for acpi:PNP0C04:00
[    1.500242] device: 'IFX0102:00': device_add
[    1.504112] bus: 'acpi': add device IFX0102:00
[    1.508115] PM: Adding info for acpi:IFX0102:00
[    1.512139] device: 'PNP0800:00': device_add
[    1.516101] bus: 'acpi': add device PNP0800:00
[    1.520109] PM: Adding info for acpi:PNP0800:00
[    1.524118] device: 'PNP0000:00': device_add
[    1.528109] bus: 'acpi': add device PNP0000:00
[    1.532104] PM: Adding info for acpi:PNP0000:00
[    1.540117] device: 'PNP0C02:00': device_add
[    1.540117] bus: 'acpi': add device PNP0C02:00
[    1.544109] PM: Adding info for acpi:PNP0C02:00
[    1.548121] device: 'PNP0C01:00': device_add
[    1.556099] bus: 'acpi': add device PNP0C01:00
[    1.556104] PM: Adding info for acpi:PNP0C01:00
[    1.560120] device: 'PNP0B00:00': device_add
[    1.564103] bus: 'acpi': add device PNP0B00:00
[    1.572105] PM: Adding info for acpi:PNP0B00:00
[    1.572121] device: 'PNP0100:00': device_add
[    1.576104] bus: 'acpi': add device PNP0100:00
[    1.580110] PM: Adding info for acpi:PNP0100:00
[    1.588195] device: 'PNP0103:00': device_add
[    1.588195] bus: 'acpi': add device PNP0103:00
[    1.592116] PM: Adding info for acpi:PNP0103:00
[    1.596126] device: 'PNP0A06:00': device_add
[    1.604120] bus: 'acpi': add device PNP0A06:00
[    1.604120] PM: Adding info for acpi:PNP0A06:00
[    1.608345] device: 'LNXPOWER:01': device_add
[    1.612107] bus: 'acpi': add device LNXPOWER:01
[    1.616105] PM: Adding info for acpi:LNXPOWER:01
[    1.624107] bus: 'acpi': driver_probe_device: matched device LNXPOWER:01 with driver power
[    1.624107] bus: 'acpi': really_probe: probing driver power with device LNXPOWER:01
[    1.628153] ACPI: Power Resource [COMP] (on)
[    1.632112] driver: 'LNXPOWER:01': driver_bound: bound to device 'power'
[    1.636107] bus: 'acpi': really_probe: bound device LNXPOWER:01 to driver power
[    1.640184] device: 'PNP0501:00': device_add
[    1.644109] bus: 'acpi': add device PNP0501:00
[    1.648107] PM: Adding info for acpi:PNP0501:00
[    1.652164] device: 'PNP0303:00': device_add
[    1.656110] bus: 'acpi': add device PNP0303:00
[    1.660116] PM: Adding info for acpi:PNP0303:00
[    1.664131] device: 'SYN0178:00': device_add
[    1.668110] bus: 'acpi': add device SYN0178:00
[    1.672113] PM: Adding info for acpi:SYN0178:00
[    1.676127] device: 'device:32': device_add
[    1.680117] bus: 'acpi': add device device:32
[    1.684118] PM: Adding info for acpi:device:32
[    1.688130] device: 'device:33': device_add
[    1.692116] bus: 'acpi': add device device:33
[    1.696111] PM: Adding info for acpi:device:33
[    1.728187] device: 'device:34': device_add
[    1.732125] bus: 'acpi': add device device:34
[    1.736132] PM: Adding info for acpi:device:34
[    1.756178] device: 'device:35': device_add
[    1.760128] bus: 'acpi': add device device:35
[    1.764134] PM: Adding info for acpi:device:35
[    1.792189] device: 'device:36': device_add
[    1.796129] bus: 'acpi': add device device:36
[    1.800136] PM: Adding info for acpi:device:36
[    1.816181] device: 'device:37': device_add
[    1.820131] bus: 'acpi': add device device:37
[    1.824138] PM: Adding info for acpi:device:37
[    1.828147] device: 'device:38': device_add
[    1.832125] bus: 'acpi': add device device:38
[    1.836127] PM: Adding info for acpi:device:38
[    1.840145] device: 'device:39': device_add
[    1.844128] bus: 'acpi': add device device:39
[    1.848134] PM: Adding info for acpi:device:39
[    1.852144] device: 'device:3a': device_add
[    1.856121] bus: 'acpi': add device device:3a
[    1.860129] PM: Adding info for acpi:device:3a
[    1.864141] device: 'device:3b': device_add
[    1.868122] bus: 'acpi': add device device:3b
[    1.872131] PM: Adding info for acpi:device:3b
[    1.876137] device: 'device:3c': device_add
[    1.880123] bus: 'acpi': add device device:3c
[    1.884124] PM: Adding info for acpi:device:3c
[    1.888138] device: 'device:3d': device_add
[    1.892124] bus: 'acpi': add device device:3d
[    1.896131] PM: Adding info for acpi:device:3d
[    1.900139] device: 'device:3e': device_add
[    1.904124] bus: 'acpi': add device device:3e
[    1.908128] PM: Adding info for acpi:device:3e
[    1.912140] device: 'device:3f': device_add
[    1.916125] bus: 'acpi': add device device:3f
[    1.920129] PM: Adding info for acpi:device:3f
[    1.924176] device: 'HPQ0004:00': device_add
[    1.928127] bus: 'acpi': add device HPQ0004:00
[    1.932133] PM: Adding info for acpi:HPQ0004:00
[    1.936263] device: 'PNP0C0A:00': device_add
[    1.940132] bus: 'acpi': add device PNP0C0A:00
[    1.944134] PM: Adding info for acpi:PNP0C0A:00
[    1.948222] device: 'PNP0C0A:01': device_add
[    1.952133] bus: 'acpi': add device PNP0C0A:01
[    1.956134] PM: Adding info for acpi:PNP0C0A:01
[    1.960147] device: 'ACPI0003:00': device_add
[    1.964128] bus: 'acpi': add device ACPI0003:00
[    1.968131] PM: Adding info for acpi:ACPI0003:00
[    1.972145] device: 'PNP0C0E:00': device_add
[    1.976135] bus: 'acpi': add device PNP0C0E:00
[    1.980135] PM: Adding info for acpi:PNP0C0E:00
[    1.984148] device: 'PNP0C0D:00': device_add
[    1.988130] bus: 'acpi': add device PNP0C0D:00
[    1.992133] PM: Adding info for acpi:PNP0C0D:00
[    1.996201] device: 'PNP0C32:00': device_add
[    2.000131] bus: 'acpi': add device PNP0C32:00
[    2.004134] PM: Adding info for acpi:PNP0C32:00
[    2.008183] device: 'PNP0C14:00': device_add
[    2.012131] bus: 'acpi': add device PNP0C14:00
[    2.016135] PM: Adding info for acpi:PNP0C14:00
[    2.020198] device: 'PNP0C0F:00': device_add
[    2.024133] bus: 'acpi': add device PNP0C0F:00
[    2.028138] PM: Adding info for acpi:PNP0C0F:00
[    2.032172] device: 'PNP0C0F:01': device_add
[    2.036134] bus: 'acpi': add device PNP0C0F:01
[    2.040132] PM: Adding info for acpi:PNP0C0F:01
[    2.044173] device: 'PNP0C0F:02': device_add
[    2.048139] bus: 'acpi': add device PNP0C0F:02
[    2.052137] PM: Adding info for acpi:PNP0C0F:02
[    2.056171] device: 'PNP0C0F:03': device_add
[    2.060135] bus: 'acpi': add device PNP0C0F:03
[    2.064138] PM: Adding info for acpi:PNP0C0F:03
[    2.068176] device: 'PNP0C0F:04': device_add
[    2.072136] bus: 'acpi': add device PNP0C0F:04
[    2.076134] PM: Adding info for acpi:PNP0C0F:04
[    2.080173] device: 'PNP0C0F:05': device_add
[    2.084137] bus: 'acpi': add device PNP0C0F:05
[    2.088140] PM: Adding info for acpi:PNP0C0F:05
[    2.092176] device: 'PNP0C0F:06': device_add
[    2.096137] bus: 'acpi': add device PNP0C0F:06
[    2.100140] PM: Adding info for acpi:PNP0C0F:06
[    2.104181] device: 'PNP0C0F:07': device_add
[    2.108138] bus: 'acpi': add device PNP0C0F:07
[    2.112141] PM: Adding info for acpi:PNP0C0F:07
[    2.116173] device: 'device:40': device_add
[    2.120144] bus: 'acpi': add device device:40
[    2.124145] PM: Adding info for acpi:device:40
[    2.128163] device: 'LNXPOWER:02': device_add
[    2.132139] bus: 'acpi': add device LNXPOWER:02
[    2.136142] PM: Adding info for acpi:LNXPOWER:02
[    2.140144] bus: 'acpi': driver_probe_device: matched device LNXPOWER:02 with driver power
[    2.144139] bus: 'acpi': really_probe: probing driver power with device LNXPOWER:02
[    2.148165] ACPI: Power Resource [PFN0] (off)
[    2.152145] driver: 'LNXPOWER:02': driver_bound: bound to device 'power'
[    2.156140] bus: 'acpi': really_probe: bound device LNXPOWER:02 to driver power
[    2.160149] device: 'LNXPOWER:03': device_add
[    2.164145] bus: 'acpi': add device LNXPOWER:03
[    2.168148] PM: Adding info for acpi:LNXPOWER:03
[    2.172144] bus: 'acpi': driver_probe_device: matched device LNXPOWER:03 with driver power
[    2.176136] bus: 'acpi': really_probe: probing driver power with device LNXPOWER:03
[    2.180161] ACPI: Power Resource [PFN1] (off)
[    2.184142] driver: 'LNXPOWER:03': driver_bound: bound to device 'power'
[    2.188142] bus: 'acpi': really_probe: bound device LNXPOWER:03 to driver power
[    2.192147] device: 'LNXPOWER:04': device_add
[    2.196143] bus: 'acpi': add device LNXPOWER:04
[    2.200149] PM: Adding info for acpi:LNXPOWER:04
[    2.204146] bus: 'acpi': driver_probe_device: matched device LNXPOWER:04 with driver power
[    2.208138] bus: 'acpi': really_probe: probing driver power with device LNXPOWER:04
[    2.212160] ACPI: Power Resource [PFN2] (off)
[    2.216144] driver: 'LNXPOWER:04': driver_bound: bound to device 'power'
[    2.220144] bus: 'acpi': really_probe: bound device LNXPOWER:04 to driver power
[    2.224151] device: 'LNXPOWER:05': device_add
[    2.228150] bus: 'acpi': add device LNXPOWER:05
[    2.232152] PM: Adding info for acpi:LNXPOWER:05
[    2.236148] bus: 'acpi': driver_probe_device: matched device LNXPOWER:05 with driver power
[    2.240140] bus: 'acpi': really_probe: probing driver power with device LNXPOWER:05
[    2.244164] ACPI: Power Resource [PFN3] (off)
[    2.248146] driver: 'LNXPOWER:05': driver_bound: bound to device 'power'
[    2.252146] bus: 'acpi': really_probe: bound device LNXPOWER:05 to driver power
[    2.256156] device: 'LNXPOWER:06': device_add
[    2.260147] bus: 'acpi': add device LNXPOWER:06
[    2.264151] PM: Adding info for acpi:LNXPOWER:06
[    2.268150] bus: 'acpi': driver_probe_device: matched device LNXPOWER:06 with driver power
[    2.272142] bus: 'acpi': really_probe: probing driver power with device LNXPOWER:06
[    2.276168] ACPI: Power Resource [PFN4] (off)
[    2.280148] driver: 'LNXPOWER:06': driver_bound: bound to device 'power'
[    2.284148] bus: 'acpi': really_probe: bound device LNXPOWER:06 to driver power
[    2.288185] device: 'PNP0C0B:00': device_add
[    2.292149] bus: 'acpi': add device PNP0C0B:00
[    2.296153] PM: Adding info for acpi:PNP0C0B:00
[    2.300190] device: 'PNP0C0B:01': device_add
[    2.304150] bus: 'acpi': add device PNP0C0B:01
[    2.308151] PM: Adding info for acpi:PNP0C0B:01
[    2.312189] device: 'PNP0C0B:02': device_add
[    2.316151] bus: 'acpi': add device PNP0C0B:02
[    2.320154] PM: Adding info for acpi:PNP0C0B:02
[    2.324190] device: 'PNP0C0B:03': device_add
[    2.328157] bus: 'acpi': add device PNP0C0B:03
[    2.332150] PM: Adding info for acpi:PNP0C0B:03
[    2.336190] device: 'PNP0C0B:04': device_add
[    2.340156] bus: 'acpi': add device PNP0C0B:04
[    2.344156] PM: Adding info for acpi:PNP0C0B:04
[    2.348163] device: 'LNXTHERM:00': device_add
[    2.352159] bus: 'acpi': add device LNXTHERM:00
[    2.356148] PM: Adding info for acpi:LNXTHERM:00
[    2.364174] device: 'LNXTHERM:01': device_add
[    2.368158] bus: 'acpi': add device LNXTHERM:01
[    2.372157] PM: Adding info for acpi:LNXTHERM:01
[    2.376236] device: 'LNXPWRBN:00': device_add
[    2.380154] bus: 'acpi': add device LNXPWRBN:00
[    2.384158] PM: Adding info for acpi:LNXPWRBN:00
[    2.388186] bus: 'acpi': add driver ec
[    2.392171] bus: 'acpi': driver_probe_device: matched device PNP0C09:00 with driver ec
[    2.396150] bus: 'acpi': really_probe: probing driver ec with device PNP0C09:00
[    2.400192] ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    2.404155] driver: 'PNP0C09:00': driver_bound: bound to device 'ec'
[    2.408156] bus: 'acpi': really_probe: bound device PNP0C09:00 to driver ec
[    2.412179] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.416156] bus: 'acpi': add driver pci_root
[    2.420162] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    2.424157] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    2.428243] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.432164] device: 'pci0000:00': device_add
[    2.436172] PM: Adding info for No Bus:pci0000:00
[    2.440158] device: '0000:00': device_add
[    2.444173] PM: Adding info for No Bus:0000:00
[    2.452186] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    2.456159] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    2.460155] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    2.464155] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000c3fff]
[    2.468155] pci_root PNP0A03:00: host bridge window [mem 0x000c4000-0x000c7fff]
[    2.472160] pci_root PNP0A03:00: host bridge window [mem 0x000c8000-0x000cbfff]
[    2.476155] pci_root PNP0A03:00: host bridge window [mem 0x000cc000-0x000cffff]
[    2.480156] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    2.484156] pci_root PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    2.488161] pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    2.492156] pci_root PNP0A03:00: host bridge window [mem 0x000dc000-0x000dffff]
[    2.496157] pci_root PNP0A03:00: host bridge window [mem 0x000e0000-0x000e3fff]
[    2.500157] pci_root PNP0A03:00: host bridge window [mem 0x000e4000-0x000e7fff]
[    2.504162] pci_root PNP0A03:00: host bridge window [mem 0x000e8000-0x000ebfff]
[    2.508157] pci_root PNP0A03:00: host bridge window [mem 0x000ec000-0x000effff]
[    2.512158] pci_root PNP0A03:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    2.516158] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfffdffff]
[    2.520163] pci_root PNP0A03:00: host bridge window [mem 0xffe00000-0xffffffff]
[    2.524169] pci_root PNP0A03:00: host bridge window expanded to [mem 0xf0000000-0xffffffff]; [mem 0xffe00000-0xffffffff] ignored
[    2.528170] pci_root PNP0A03:00: ignoring host bridge window [mem 0x000cc000-0x000cffff] (conflicts with Video ROM [mem 0x000c0000-0x000cedff])
[    2.532164] pci_bus 0000:00: scanning bus
[    2.536178] pci 0000:00:00.0: [1022:9601] type 0 class 0x000600
[    2.540175] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x19
[    2.544184] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x176
[    2.548179] pci 0000:00:00.0: rpm_resume flags 0x0
[    2.552158] pci 0000:00:00.0: rpm_resume returns -13
[    2.552182] pci 0000:00:01.0: [103c:9602] type 1 class 0x000604
[    2.556169] pci 0000:00:01.0: calling quirk_mmio_always_on+0x0/0x19
[    2.560182] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x176
[    2.564169] pci 0000:00:01.0: rpm_resume flags 0x0
[    2.568159] pci 0000:00:01.0: rpm_resume returns -13
[    2.568177] pci 0000:00:04.0: [1022:9604] type 1 class 0x000604
[    2.572168] pci 0000:00:04.0: calling quirk_mmio_always_on+0x0/0x19
[    2.576181] pci 0000:00:04.0: calling quirk_resource_alignment+0x0/0x176
[    2.580169] pci 0000:00:04.0: rpm_resume flags 0x0
[    2.584160] pci 0000:00:04.0: rpm_resume returns -13
[    2.584172] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    2.588172] pci 0000:00:04.0: PME# disabled
[    2.592178] pci 0000:00:05.0: [1022:9605] type 1 class 0x000604
[    2.596168] pci 0000:00:05.0: calling quirk_mmio_always_on+0x0/0x19
[    2.600183] pci 0000:00:05.0: calling quirk_resource_alignment+0x0/0x176
[    2.604170] pci 0000:00:05.0: rpm_resume flags 0x0
[    2.608162] pci 0000:00:05.0: rpm_resume returns -13
[    2.608165] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    2.612164] pci 0000:00:05.0: PME# disabled
[    2.616181] pci 0000:00:07.0: [1022:9607] type 1 class 0x000604
[    2.620176] pci 0000:00:07.0: calling quirk_mmio_always_on+0x0/0x19
[    2.624184] pci 0000:00:07.0: calling quirk_resource_alignment+0x0/0x176
[    2.628171] pci 0000:00:07.0: rpm_resume flags 0x0
[    2.632163] pci 0000:00:07.0: rpm_resume returns -13
[    2.632171] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    2.636169] pci 0000:00:07.0: PME# disabled
[    2.640182] pci 0000:00:09.0: [1022:9608] type 1 class 0x000604
[    2.644171] pci 0000:00:09.0: calling quirk_mmio_always_on+0x0/0x19
[    2.648188] pci 0000:00:09.0: calling quirk_resource_alignment+0x0/0x176
[    2.652176] pci 0000:00:09.0: rpm_resume flags 0x0
[    2.656165] pci 0000:00:09.0: rpm_resume returns -13
[    2.656169] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    2.660167] pci 0000:00:09.0: PME# disabled
[    2.664197] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    2.668177] pci 0000:00:11.0: calling quirk_no_ata_d3+0x0/0x1d
[    2.672168] pci 0000:00:11.0: calling quirk_mmio_always_on+0x0/0x19
[    2.676182] pci 0000:00:11.0: reg 10: [io  0x7018-0x701f]
[    2.680180] pci 0000:00:11.0: reg 14: [io  0x7024-0x7027]
[    2.684176] pci 0000:00:11.0: reg 18: [io  0x7010-0x7017]
[    2.688176] pci 0000:00:11.0: reg 1c: [io  0x7020-0x7023]
[    2.692176] pci 0000:00:11.0: reg 20: [io  0x7000-0x700f]
[    2.696181] pci 0000:00:11.0: reg 24: [mem 0xd650b000-0xd650b3ff]
[    2.700180] pci 0000:00:11.0: calling quirk_resource_alignment+0x0/0x176
[    2.704182] pci 0000:00:11.0: rpm_resume flags 0x0
[    2.708168] pci 0000:00:11.0: rpm_resume returns -13
[    2.708189] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    2.712177] pci 0000:00:12.0: calling quirk_no_ata_d3+0x0/0x1d
[    2.716171] pci 0000:00:12.0: calling quirk_mmio_always_on+0x0/0x19
[    2.720184] pci 0000:00:12.0: reg 10: [mem 0xd650a000-0xd650afff]
[    2.724217] pci 0000:00:12.0: calling quirk_resource_alignment+0x0/0x176
[    2.728178] pci 0000:00:12.0: rpm_resume flags 0x0
[    2.732170] pci 0000:00:12.0: rpm_resume returns -13
[    2.732192] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    2.736179] pci 0000:00:12.2: calling quirk_no_ata_d3+0x0/0x1d
[    2.740173] pci 0000:00:12.2: calling quirk_mmio_always_on+0x0/0x19
[    2.744186] pci 0000:00:12.2: reg 10: [mem 0xd6509000-0xd65090ff]
[    2.748219] pci 0000:00:12.2: calling quirk_resource_alignment+0x0/0x176
[    2.752185] pci 0000:00:12.2: rpm_resume flags 0x0
[    2.756171] pci 0000:00:12.2: rpm_resume returns -13
[    2.756177] pci 0000:00:12.2: supports D1 D2
[    2.760178] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    2.764179] pci 0000:00:12.2: PME# disabled
[    2.768191] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    2.772176] pci 0000:00:13.0: calling quirk_no_ata_d3+0x0/0x1d
[    2.776180] pci 0000:00:13.0: calling quirk_mmio_always_on+0x0/0x19
[    2.780188] pci 0000:00:13.0: reg 10: [mem 0xd6508000-0xd6508fff]
[    2.784221] pci 0000:00:13.0: calling quirk_resource_alignment+0x0/0x176
[    2.788179] pci 0000:00:13.0: rpm_resume flags 0x0
[    2.792173] pci 0000:00:13.0: rpm_resume returns -13
[    2.792198] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    2.796182] pci 0000:00:13.2: calling quirk_no_ata_d3+0x0/0x1d
[    2.800176] pci 0000:00:13.2: calling quirk_mmio_always_on+0x0/0x19
[    2.804189] pci 0000:00:13.2: reg 10: [mem 0xd6507000-0xd65070ff]
[    2.808227] pci 0000:00:13.2: calling quirk_resource_alignment+0x0/0x176
[    2.812189] pci 0000:00:13.2: rpm_resume flags 0x0
[    2.816175] pci 0000:00:13.2: rpm_resume returns -13
[    2.816180] pci 0000:00:13.2: supports D1 D2
[    2.820177] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    2.824183] pci 0000:00:13.2: PME# disabled
[    2.828195] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    2.832180] pci 0000:00:14.0: calling quirk_no_ata_d3+0x0/0x1d
[    2.836179] pci 0000:00:14.0: calling quirk_mmio_always_on+0x0/0x19
[    2.840189] pci 0000:00:14.0: calling sb600_disable_hpet_bar+0x0/0x50
[    2.844237] pci 0000:00:14.0: calling force_disable_hpet_msi+0x0/0x10
[    2.848184] pci 0000:00:14.0: calling quirk_resource_alignment+0x0/0x176
[    2.852181] pci 0000:00:14.0: rpm_resume flags 0x0
[    2.856177] pci 0000:00:14.0: rpm_resume returns -13
[    2.856197] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    2.860184] pci 0000:00:14.2: calling quirk_no_ata_d3+0x0/0x1d
[    2.864180] pci 0000:00:14.2: calling quirk_mmio_always_on+0x0/0x19
[    2.868193] pci 0000:00:14.2: reg 10: [mem 0xd6500000-0xd6503fff 64bit]
[    2.872219] pci 0000:00:14.2: calling quirk_resource_alignment+0x0/0x176
[    2.876194] pci 0000:00:14.2: rpm_resume flags 0x0
[    2.880179] pci 0000:00:14.2: rpm_resume returns -13
[    2.880185] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    2.884183] pci 0000:00:14.2: PME# disabled
[    2.888196] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    2.892183] pci 0000:00:14.3: calling quirk_no_ata_d3+0x0/0x1d
[    2.896182] pci 0000:00:14.3: calling quirk_mmio_always_on+0x0/0x19
[    2.900242] pci 0000:00:14.3: calling quirk_resource_alignment+0x0/0x176
[    2.904189] pci 0000:00:14.3: rpm_resume flags 0x0
[    2.908181] pci 0000:00:14.3: rpm_resume returns -13
[    2.908191] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    2.912185] pci 0000:00:14.4: calling quirk_no_ata_d3+0x0/0x1d
[    2.916184] pci 0000:00:14.4: calling quirk_mmio_always_on+0x0/0x19
[    2.924194] pci 0000:00:14.4: calling quirk_resource_alignment+0x0/0x176
[    2.928185] pci 0000:00:14.4: rpm_resume flags 0x0
[    2.932182] pci 0000:00:14.4: rpm_resume returns -13
[    2.932193] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    2.936186] pci 0000:00:14.5: calling quirk_no_ata_d3+0x0/0x1d
[    2.940185] pci 0000:00:14.5: calling quirk_mmio_always_on+0x0/0x19
[    2.944198] pci 0000:00:14.5: reg 10: [mem 0xd6506000-0xd6506fff]
[    2.948231] pci 0000:00:14.5: calling quirk_resource_alignment+0x0/0x176
[    2.952187] pci 0000:00:14.5: rpm_resume flags 0x0
[    2.956184] pci 0000:00:14.5: rpm_resume returns -13
[    2.956201] pci 0000:00:16.0: [1002:4397] type 0 class 0x000c03
[    2.960188] pci 0000:00:16.0: calling quirk_no_ata_d3+0x0/0x1d
[    2.964187] pci 0000:00:16.0: calling quirk_mmio_always_on+0x0/0x19
[    2.968200] pci 0000:00:16.0: reg 10: [mem 0xd6505000-0xd6505fff]
[    2.972233] pci 0000:00:16.0: calling quirk_resource_alignment+0x0/0x176
[    2.976189] pci 0000:00:16.0: rpm_resume flags 0x0
[    2.980185] pci 0000:00:16.0: rpm_resume returns -13
[    2.980206] pci 0000:00:16.2: [1002:4396] type 0 class 0x000c03
[    2.984199] pci 0000:00:16.2: calling quirk_no_ata_d3+0x0/0x1d
[    2.988191] pci 0000:00:16.2: calling quirk_mmio_always_on+0x0/0x19
[    2.992201] pci 0000:00:16.2: reg 10: [mem 0xd6504000-0xd65040ff]
[    2.996234] pci 0000:00:16.2: calling quirk_resource_alignment+0x0/0x176
[    3.000205] pci 0000:00:16.2: rpm_resume flags 0x0
[    3.004187] pci 0000:00:16.2: rpm_resume returns -13
[    3.004192] pci 0000:00:16.2: supports D1 D2
[    3.008188] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    3.012191] pci 0000:00:16.2: PME# disabled
[    3.016210] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    3.020195] pci 0000:00:18.0: calling quirk_mmio_always_on+0x0/0x19
[    3.024202] pci 0000:00:18.0: calling quirk_resource_alignment+0x0/0x176
[    3.028191] pci 0000:00:18.0: rpm_resume flags 0x0
[    3.032188] pci 0000:00:18.0: rpm_resume returns -13
[    3.032202] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    3.036191] pci 0000:00:18.1: calling quirk_mmio_always_on+0x0/0x19
[    3.040203] pci 0000:00:18.1: calling quirk_resource_alignment+0x0/0x176
[    3.044191] pci 0000:00:18.1: rpm_resume flags 0x0
[    3.048189] pci 0000:00:18.1: rpm_resume returns -13
[    3.048204] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    3.052192] pci 0000:00:18.2: calling quirk_mmio_always_on+0x0/0x19
[    3.056203] pci 0000:00:18.2: calling quirk_resource_alignment+0x0/0x176
[    3.060192] pci 0000:00:18.2: rpm_resume flags 0x0
[    3.064190] pci 0000:00:18.2: rpm_resume returns -13
[    3.064200] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    3.068193] pci 0000:00:18.3: calling quirk_mmio_always_on+0x0/0x19
[    3.072204] pci 0000:00:18.3: calling quirk_resource_alignment+0x0/0x176
[    3.076194] pci 0000:00:18.3: rpm_resume flags 0x0
[    3.080191] pci 0000:00:18.3: rpm_resume returns -13
[    3.080200] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    3.084194] pci 0000:00:18.4: calling quirk_mmio_always_on+0x0/0x19
[    3.088205] pci 0000:00:18.4: calling quirk_resource_alignment+0x0/0x176
[    3.092194] pci 0000:00:18.4: rpm_resume flags 0x0
[    3.096192] pci 0000:00:18.4: rpm_resume returns -13
[    3.096204] pci_bus 0000:00: fixups for bus
[    3.100200] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass 0
[    3.104214] pci_bus 0000:01: scanning bus
[    3.108210] pci 0000:01:05.0: [1002:9712] type 0 class 0x000300
[    3.112203] pci 0000:01:05.0: calling quirk_no_ata_d3+0x0/0x1d
[    3.116196] pci 0000:01:05.0: calling quirk_mmio_always_on+0x0/0x19
[    3.120205] pci 0000:01:05.0: reg 10: [mem 0xc0000000-0xcfffffff pref]
[    3.124199] pci 0000:01:05.0: reg 14: [io  0x6000-0x60ff]
[    3.128199] pci 0000:01:05.0: reg 18: [mem 0xd6400000-0xd640ffff]
[    3.132210] pci 0000:01:05.0: reg 24: [mem 0xd6300000-0xd63fffff]
[    3.136201] pci 0000:01:05.0: calling quirk_resource_alignment+0x0/0x176
[    3.140201] pci 0000:01:05.0: rpm_resume flags 0x0
[    3.144195] pci 0000:01:05.0: rpm_resume returns -13
[    3.144198] pci 0000:01:05.0: supports D1 D2
[    3.148213] pci 0000:01:05.1: [1002:970f] type 0 class 0x000403
[    3.152201] pci 0000:01:05.1: calling quirk_no_ata_d3+0x0/0x1d
[    3.156199] pci 0000:01:05.1: calling quirk_mmio_always_on+0x0/0x19
[    3.160206] pci 0000:01:05.1: reg 10: [mem 0xd6410000-0xd6413fff]
[    3.164216] pci 0000:01:05.1: calling quirk_resource_alignment+0x0/0x176
[    3.168203] pci 0000:01:05.1: rpm_resume flags 0x0
[    3.172197] pci 0000:01:05.1: rpm_resume returns -13
[    3.172200] pci 0000:01:05.1: supports D1 D2
[    3.176231] pci_bus 0000:01: fixups for bus
[    3.180204] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    3.184205] pci 0000:00:01.0:   bridge window [io  0x6000-0x6fff]
[    3.188205] pci 0000:00:01.0:   bridge window [mem 0xd6300000-0xd64fffff]
[    3.192206] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    3.196204] pci_bus 0000:01: bus scan returning with max=01
[    3.200206] pci 0000:00:04.0: scanning [bus 02-02] behind bridge, pass 0
[    3.204223] pci_bus 0000:02: scanning bus
[    3.208285] pci 0000:02:00.0: [11ab:4381] type 0 class 0x000200
[    3.212238] pci 0000:02:00.0: calling quirk_mmio_always_on+0x0/0x19
[    3.216248] pci 0000:02:00.0: reg 10: [mem 0xd5200000-0xd5203fff 64bit]
[    3.220243] pci 0000:02:00.0: reg 18: [io  0x4000-0x40ff]
[    3.224268] pci 0000:02:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    3.228235] pci 0000:02:00.0: calling quirk_resource_alignment+0x0/0x176
[    3.232254] pci 0000:02:00.0: rpm_resume flags 0x0
[    3.236201] pci 0000:02:00.0: rpm_resume returns -13
[    3.236237] pci 0000:02:00.0: supports D1 D2
[    3.240203] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    3.244240] pci 0000:02:00.0: PME# disabled
[    4.256298] pci 0000:00:04.0: ASPM: Could not configure common clock
[    4.260314] pci_bus 0000:02: fixups for bus
[    4.264277] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    4.268280] pci 0000:00:04.0:   bridge window [io  0x4000-0x5fff]
[    4.272278] pci 0000:00:04.0:   bridge window [mem 0xd5200000-0xd62fffff]
[    4.276278] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd0ffffff 64bit pref]
[    4.280277] pci_bus 0000:02: bus scan returning with max=02
[    4.284279] pci 0000:00:05.0: scanning [bus 03-03] behind bridge, pass 0
[    4.288300] pci_bus 0000:03: scanning bus
[    4.292323] pci 0000:03:00.0: [1180:e822] type 0 class 0x000805
[    4.296316] pci 0000:03:00.0: calling quirk_mmio_always_on+0x0/0x19
[    4.300316] pci 0000:03:00.0: reg 10: [mem 0xd4103000-0xd41030ff]
[    4.304357] pci 0000:03:00.0: calling quirk_resource_alignment+0x0/0x176
[    4.308329] pci 0000:03:00.0: rpm_resume flags 0x0
[    4.312268] pci 0000:03:00.0: rpm_resume returns -13
[    4.312313] pci 0000:03:00.0: supports D1 D2
[    4.316275] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    4.320309] pci 0000:03:00.0: PME# disabled
[    4.324337] pci 0000:03:00.1: [1180:e230] type 0 class 0x000880
[    4.328309] pci 0000:03:00.1: calling quirk_mmio_always_on+0x0/0x19
[    4.332318] pci 0000:03:00.1: reg 10: [mem 0xd4102000-0xd41020ff]
[    4.336357] pci 0000:03:00.1: calling quirk_resource_alignment+0x0/0x176
[    4.340321] pci 0000:03:00.1: rpm_resume flags 0x0
[    4.344270] pci 0000:03:00.1: rpm_resume returns -13
[    4.344315] pci 0000:03:00.1: supports D1 D2
[    4.348272] pci 0000:03:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    4.352306] pci 0000:03:00.1: PME# disabled
[    4.356330] pci 0000:03:00.2: [1180:e852] type 0 class 0x000880
[    4.360311] pci 0000:03:00.2: calling quirk_mmio_always_on+0x0/0x19
[    4.364320] pci 0000:03:00.2: reg 10: [mem 0xd4101000-0xd41010ff]
[    4.368360] pci 0000:03:00.2: calling quirk_resource_alignment+0x0/0x176
[    4.372327] pci 0000:03:00.2: rpm_resume flags 0x0
[    4.376272] pci 0000:03:00.2: rpm_resume returns -13
[    4.376317] pci 0000:03:00.2: supports D1 D2
[    4.380274] pci 0000:03:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    4.384308] pci 0000:03:00.2: PME# disabled
[    4.388332] pci 0000:03:00.3: [1180:e832] type 0 class 0x000c00
[    4.392313] pci 0000:03:00.3: calling quirk_mmio_always_on+0x0/0x19
[    4.396322] pci 0000:03:00.3: reg 10: [mem 0xd4100000-0xd41007ff]
[    4.400360] pci 0000:03:00.3: calling quirk_resource_alignment+0x0/0x176
[    4.404325] pci 0000:03:00.3: rpm_resume flags 0x0
[    4.408274] pci 0000:03:00.3: rpm_resume returns -13
[    4.408319] pci 0000:03:00.3: supports D1 D2
[    4.412276] pci 0000:03:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    4.416310] pci 0000:03:00.3: PME# disabled
[    4.432358] pci_bus 0000:03: fixups for bus
[    4.436289] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    4.440290] pci 0000:00:05.0:   bridge window [io  0x3000-0x3fff]
[    4.444288] pci 0000:00:05.0:   bridge window [mem 0xd4100000-0xd51fffff]
[    4.448289] pci 0000:00:05.0:   bridge window [mem 0xd1000000-0xd1ffffff 64bit pref]
[    4.452283] pci_bus 0000:03: bus scan returning with max=03
[    4.456291] pci 0000:00:07.0: scanning [bus 04-06] behind bridge, pass 0
[    4.460311] pci_bus 0000:04: scanning bus
[    4.464289] pci_bus 0000:04: fixups for bus
[    4.468280] pci 0000:00:07.0: PCI bridge to [bus 04-06]
[    4.472284] pci 0000:00:07.0:   bridge window [io  0x2000-0x2fff]
[    4.476281] pci 0000:00:07.0:   bridge window [mem 0xd3100000-0xd40fffff]
[    4.480282] pci 0000:00:07.0:   bridge window [mem 0xd2000000-0xd2ffffff 64bit pref]
[    4.484284] pci_bus 0000:04: bus scan returning with max=04
[    4.488286] pci 0000:00:09.0: scanning [bus 07-07] behind bridge, pass 0
[    4.492307] pci_bus 0000:07: scanning bus
[    4.496339] pci 0000:07:00.0: [14e4:4727] type 0 class 0x000280
[    4.500327] pci 0000:07:00.0: calling quirk_mmio_always_on+0x0/0x19
[    4.504337] pci 0000:07:00.0: reg 10: [mem 0xd3000000-0xd3003fff 64bit]
[    4.508361] pci 0000:07:00.0: calling quirk_resource_alignment+0x0/0x176
[    4.512345] pci 0000:07:00.0: rpm_resume flags 0x0
[    4.516281] pci 0000:07:00.0: rpm_resume returns -13
[    4.516335] pci 0000:07:00.0: supports D1 D2
[    4.532356] pci_bus 0000:07: fixups for bus
[    4.536295] pci 0000:00:09.0: PCI bridge to [bus 07-07]
[    4.540297] pci 0000:00:09.0:   bridge window [mem 0xd3000000-0xd30fffff]
[    4.544296] pci_bus 0000:07: bus scan returning with max=07
[    4.548297] pci 0000:00:14.4: scanning [bus 08-08] behind bridge, pass 0
[    4.552304] pci_bus 0000:08: scanning bus
[    4.556334] pci_bus 0000:08: fixups for bus
[    4.560286] pci 0000:00:14.4: PCI bridge to [bus 08-08] (subtractive decode)
[    4.564290] pci 0000:00:14.4:   bridge window [io  0x1000-0x1fff]
[    4.568297] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    4.572290] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    4.576291] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    4.580287] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000c3fff] (subtractive decode)
[    4.584292] pci 0000:00:14.4:   bridge window [mem 0x000c4000-0x000c7fff] (subtractive decode)
[    4.588287] pci 0000:00:14.4:   bridge window [mem 0x000c8000-0x000cbfff] (subtractive decode)
[    4.592288] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    4.596288] pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    4.600297] pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    4.604292] pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    4.608289] pci 0000:00:14.4:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    4.612289] pci 0000:00:14.4:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
[    4.616294] pci 0000:00:14.4:   bridge window [mem 0x000e8000-0x000ebfff] (subtractive decode)
[    4.620289] pci 0000:00:14.4:   bridge window [mem 0x000ec000-0x000effff] (subtractive decode)
[    4.624290] pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    4.628290] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xffffffff] (subtractive decode)
[    4.632294] pci_bus 0000:08: bus scan returning with max=08
[    4.636300] pci 0000:00:01.0: scanning [bus 01-01] behind bridge, pass 1
[    4.640295] pci 0000:00:04.0: scanning [bus 02-02] behind bridge, pass 1
[    4.644296] pci 0000:00:05.0: scanning [bus 03-03] behind bridge, pass 1
[    4.648296] pci 0000:00:07.0: scanning [bus 04-06] behind bridge, pass 1
[    4.652293] pci 0000:00:09.0: scanning [bus 07-07] behind bridge, pass 1
[    4.656294] pci 0000:00:14.4: scanning [bus 08-08] behind bridge, pass 1
[    4.660296] pci_bus 0000:00: bus scan returning with max=08
[    4.664302] pci 0000:00:04.0: Dev MPS 128 MPSS 128 MRRS 128
[    4.668299] pci 0000:00:04.0: Dev MPS 128 MPSS 128 MRRS 128
[    4.672332] pci 0000:02:00.0: Dev MPS 128 MPSS 128 MRRS 512
[    4.676297] pci_bus 0000:02: Bus MPSS 128
[    4.680339] pci 0000:02:00.0: Dev MPS 128 MPSS 128 MRRS 128
[    4.684298] pci 0000:00:05.0: Dev MPS 128 MPSS 128 MRRS 128
[    4.688295] pci 0000:00:05.0: Dev MPS 128 MPSS 128 MRRS 128
[    4.692332] pci 0000:03:00.0: Dev MPS 128 MPSS 128 MRRS 512
[    4.696299] pci_bus 0000:03: Bus MPSS 128
[    4.700338] pci 0000:03:00.0: Dev MPS 128 MPSS 128 MRRS 128
[    4.704332] pci 0000:03:00.1: Dev MPS 128 MPSS 128 MRRS 512
[    4.708295] pci_bus 0000:03: Bus MPSS 128
[    4.712339] pci 0000:03:00.1: Dev MPS 128 MPSS 128 MRRS 128
[    4.716333] pci 0000:03:00.2: Dev MPS 128 MPSS 128 MRRS 512
[    4.720295] pci_bus 0000:03: Bus MPSS 128
[    4.724335] pci 0000:03:00.2: Dev MPS 128 MPSS 128 MRRS 128
[    4.728335] pci 0000:03:00.3: Dev MPS 128 MPSS 128 MRRS 512
[    4.736301] pci_bus 0000:03: Bus MPSS 128
[    4.740336] pci 0000:03:00.3: Dev MPS 128 MPSS 128 MRRS 128
[    4.744298] pci 0000:00:07.0: Dev MPS 128 MPSS 128 MRRS 128
[    4.748299] pci 0000:00:07.0: Dev MPS 128 MPSS 128 MRRS 128
[    4.752299] pci 0000:00:09.0: Dev MPS 128 MPSS 128 MRRS 128
[    4.756300] pci 0000:00:09.0: Dev MPS 128 MPSS 128 MRRS 128
[    4.760340] pci 0000:07:00.0: Dev MPS 128 MPSS 128 MRRS 128
[    4.764298] pci_bus 0000:07: Bus MPSS 128
[    4.768338] pci 0000:07:00.0: Dev MPS 128 MPSS 128 MRRS 128
[    4.772312] pci_bus 0000:00: on NUMA node 0
[    4.776315] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    4.780488] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    4.784342] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB4_._PRT]
[    4.788348] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
[    4.792339] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB9_._PRT]
[    4.796342] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB7_._PRT]
[    4.800393]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    4.804310]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    4.808305] ACPI _OSC control for PCIe not granted, disabling ASPM
[    4.812312] device: '0000:00:00.0': device_add
[    4.816450] bus: 'pci': add device 0000:00:00.0
[    4.820323] PM: Adding info for pci:0000:00:00.0
[    4.824324] device: '0000:00:01.0': device_add
[    4.828438] bus: 'pci': add device 0000:00:01.0
[    4.832315] PM: Adding info for pci:0000:00:01.0
[    4.836312] device: '0000:00:04.0': device_add
[    4.840436] bus: 'pci': add device 0000:00:04.0
[    4.844322] PM: Adding info for pci:0000:00:04.0
[    4.848313] device: '0000:00:05.0': device_add
[    4.852436] bus: 'pci': add device 0000:00:05.0
[    4.856322] PM: Adding info for pci:0000:00:05.0
[    4.860314] device: '0000:00:07.0': device_add
[    4.864438] bus: 'pci': add device 0000:00:07.0
[    4.868321] PM: Adding info for pci:0000:00:07.0
[    4.872315] device: '0000:00:09.0': device_add
[    4.876437] bus: 'pci': add device 0000:00:09.0
[    4.880321] PM: Adding info for pci:0000:00:09.0
[    4.884316] device: '0000:00:11.0': device_add
[    4.888443] bus: 'pci': add device 0000:00:11.0
[    4.892319] PM: Adding info for pci:0000:00:11.0
[    4.896316] device: '0000:00:12.0': device_add
[    4.900444] bus: 'pci': add device 0000:00:12.0
[    4.904324] PM: Adding info for pci:0000:00:12.0
[    4.908319] device: '0000:00:12.2': device_add
[    4.912446] bus: 'pci': add device 0000:00:12.2
[    4.916324] PM: Adding info for pci:0000:00:12.2
[    4.920318] device: '0000:00:13.0': device_add
[    4.924445] bus: 'pci': add device 0000:00:13.0
[    4.928326] PM: Adding info for pci:0000:00:13.0
[    4.932318] device: '0000:00:13.2': device_add
[    4.936446] bus: 'pci': add device 0000:00:13.2
[    4.940327] PM: Adding info for pci:0000:00:13.2
[    4.944323] device: '0000:00:14.0': device_add
[    4.948447] bus: 'pci': add device 0000:00:14.0
[    4.952324] PM: Adding info for pci:0000:00:14.0
[    4.956324] device: '0000:00:14.2': device_add
[    4.960437] bus: 'pci': add device 0000:00:14.2
[    4.968333] PM: Adding info for pci:0000:00:14.2
[    4.972325] device: '0000:00:14.3': device_add
[    4.976450] bus: 'pci': add device 0000:00:14.3
[    4.980324] PM: Adding info for pci:0000:00:14.3
[    4.984322] device: '0000:00:14.4': device_add
[    4.988445] bus: 'pci': add device 0000:00:14.4
[    4.992326] PM: Adding info for pci:0000:00:14.4
[    4.996322] device: '0000:00:14.5': device_add
[    5.000450] bus: 'pci': add device 0000:00:14.5
[    5.004326] PM: Adding info for pci:0000:00:14.5
[    5.008323] device: '0000:00:16.0': device_add
[    5.012453] bus: 'pci': add device 0000:00:16.0
[    5.016328] PM: Adding info for pci:0000:00:16.0
[    5.020324] device: '0000:00:16.2': device_add
[    5.024452] bus: 'pci': add device 0000:00:16.2
[    5.028340] PM: Adding info for pci:0000:00:16.2
[    5.032325] device: '0000:00:18.0': device_add
[    5.036452] bus: 'pci': add device 0000:00:18.0
[    5.040330] PM: Adding info for pci:0000:00:18.0
[    5.044330] device: '0000:00:18.1': device_add
[    5.052369] bus: 'pci': add device 0000:00:18.1
[    5.056330] PM: Adding info for pci:0000:00:18.1
[    5.060332] device: '0000:00:18.2': device_add
[    5.064453] bus: 'pci': add device 0000:00:18.2
[    5.068331] PM: Adding info for pci:0000:00:18.2
[    5.072331] device: '0000:00:18.3': device_add
[    5.076456] bus: 'pci': add device 0000:00:18.3
[    5.080332] PM: Adding info for pci:0000:00:18.3
[    5.084328] device: '0000:00:18.4': device_add
[    5.088454] bus: 'pci': add device 0000:00:18.4
[    5.092333] PM: Adding info for pci:0000:00:18.4
[    5.096329] device: '0000:01:05.0': device_add
[    5.100342] bus: 'pci': add device 0000:01:05.0
[    5.104331] PM: Adding info for pci:0000:01:05.0
[    5.108333] device: '0000:01:05.1': device_add
[    5.112339] bus: 'pci': add device 0000:01:05.1
[    5.116335] PM: Adding info for pci:0000:01:05.1
[    5.120336] device: '0000:01': device_add
[    5.124337] PM: Adding info for No Bus:0000:01
[    5.128331] device: '0000:02:00.0': device_add
[    5.132339] bus: 'pci': add device 0000:02:00.0
[    5.136340] PM: Adding info for pci:0000:02:00.0
[    5.140336] device: '0000:02': device_add
[    5.144332] PM: Adding info for No Bus:0000:02
[    5.148332] device: '0000:03:00.0': device_add
[    5.152333] bus: 'pci': add device 0000:03:00.0
[    5.156341] PM: Adding info for pci:0000:03:00.0
[    5.160337] device: '0000:03:00.1': device_add
[    5.164333] bus: 'pci': add device 0000:03:00.1
[    5.168339] PM: Adding info for pci:0000:03:00.1
[    5.172333] device: '0000:03:00.2': device_add
[    5.176334] bus: 'pci': add device 0000:03:00.2
[    5.180347] PM: Adding info for pci:0000:03:00.2
[    5.184335] device: '0000:03:00.3': device_add
[    5.188334] bus: 'pci': add device 0000:03:00.3
[    5.192346] PM: Adding info for pci:0000:03:00.3
[    5.196335] device: '0000:03': device_add
[    5.200336] PM: Adding info for No Bus:0000:03
[    5.204336] device: '0000:04': device_add
[    5.208341] PM: Adding info for No Bus:0000:04
[    5.212337] device: '0000:07:00.0': device_add
[    5.216355] bus: 'pci': add device 0000:07:00.0
[    5.220343] PM: Adding info for pci:0000:07:00.0
[    5.224341] device: '0000:07': device_add
[    5.228341] PM: Adding info for No Bus:0000:07
[    5.232337] device: '0000:08': device_add
[    5.236342] PM: Adding info for No Bus:0000:08
[    5.240339] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    5.244338] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    5.248364] bus: 'acpi': add driver pci_link
[    5.252349] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    5.256334] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    5.260377] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    5.266976] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    5.268335] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    5.272335] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    5.276330] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    5.280366] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    5.289717] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    5.292336] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    5.296336] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    5.300332] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    5.308338] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    5.314980] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    5.316337] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    5.320337] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    5.324333] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    5.328366] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    5.337168] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    5.340339] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    5.344339] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    5.348335] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    5.352368] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    5.362771] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    5.364340] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    5.368341] bus: 'acpi': driver_probe_device: matched device PNP0C0F:05 with driver pci_link
[    5.372336] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:05
[    5.376371] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    5.384531] driver: 'PNP0C0F:05': driver_bound: bound to device 'pci_link'
[    5.388342] bus: 'acpi': really_probe: bound device PNP0C0F:05 to driver pci_link
[    5.392342] bus: 'acpi': driver_probe_device: matched device PNP0C0F:06 with driver pci_link
[    5.396338] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:06
[    5.400371] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    5.410236] driver: 'PNP0C0F:06': driver_bound: bound to device 'pci_link'
[    5.412343] bus: 'acpi': really_probe: bound device PNP0C0F:06 to driver pci_link
[    5.416344] bus: 'acpi': driver_probe_device: matched device PNP0C0F:07 with driver pci_link
[    5.420339] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:07
[    5.424370] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0
[    5.430958] driver: 'PNP0C0F:07': driver_bound: bound to device 'pci_link'
[    5.432345] bus: 'acpi': really_probe: bound device PNP0C0F:07 to driver pci_link
[    5.436358] bus: 'pnp': registered
[    5.440355] bus: 'xen-backend': registered
[    5.444354] device class 'misc': registering
[    5.448359] device: 'vga_arbiter': device_add
[    5.456368] PM: Adding info for No Bus:vga_arbiter
[    5.456368] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    5.460353] vgaarb: loaded
[    5.464346] vgaarb: bridge control possible 0000:01:05.0
[    5.468391] device class 'scsi_host': registering
[    5.472366] bus: 'scsi': registered
[    5.476347] device class 'scsi_device': registering
[    5.480355] SCSI subsystem initialized
[    5.484366] device class 'ata_link': registering
[    5.488364] device class 'ata_port': registering
[    5.492347] device class 'ata_device': registering
[    5.496349] libata version 3.00 loaded.
[    5.500353] bus: 'usb': registered
[    5.504348] bus: 'usb': add driver usbfs
[    5.508356] usbcore: registered new interface driver usbfs
[    5.512346] device class 'usb_device': registering
[    5.516354] bus: 'usb': add driver hub
[    5.520351] usbcore: registered new interface driver hub
[    5.524369] bus: 'usb': add driver usb
[    5.528358] usbcore: registered new device driver usb
[    5.532353] bus: 'serio': registered
[    5.536346] device class 'input': registering
[    5.540354] device class 'rtc': registering
[    5.544352] device class 'power_supply': registering
[    5.548357] device class 'hwmon': registering
[    5.552350] device class 'leds': registering
[    5.556353] PCI: Using ACPI for IRQ routing
[    5.571079] PCI: pci_cache_line_size set to 64 bytes
[    5.572368] pci 0000:00:11.0: BAR 0: reserving [io  0x7018-0x701f flags 0x40101] (d=0, p=0)
[    5.576350] pci 0000:00:11.0: BAR 1: reserving [io  0x7024-0x7027 flags 0x40101] (d=0, p=0)
[    5.580350] pci 0000:00:11.0: BAR 2: reserving [io  0x7010-0x7017 flags 0x40101] (d=0, p=0)
[    5.584350] pci 0000:00:11.0: BAR 3: reserving [io  0x7020-0x7023 flags 0x40101] (d=0, p=0)
[    5.588350] pci 0000:00:11.0: BAR 4: reserving [io  0x7000-0x700f flags 0x40101] (d=0, p=0)
[    5.592351] pci 0000:00:11.0: BAR 5: reserving [mem 0xd650b000-0xd650b3ff flags 0x40200] (d=0, p=0)
[    5.596353] pci 0000:00:12.0: BAR 0: reserving [mem 0xd650a000-0xd650afff flags 0x40200] (d=0, p=0)
[    5.600353] pci 0000:00:12.2: BAR 0: reserving [mem 0xd6509000-0xd65090ff flags 0x40200] (d=0, p=0)
[    5.604353] pci 0000:00:13.0: BAR 0: reserving [mem 0xd6508000-0xd6508fff flags 0x40200] (d=0, p=0)
[    5.608354] pci 0000:00:13.2: BAR 0: reserving [mem 0xd6507000-0xd65070ff flags 0x40200] (d=0, p=0)
[    5.612356] pci 0000:00:14.2: BAR 0: reserving [mem 0xd6500000-0xd6503fff flags 0x140204] (d=0, p=0)
[    5.616358] pci 0000:00:14.5: BAR 0: reserving [mem 0xd6506000-0xd6506fff flags 0x40200] (d=0, p=0)
[    5.620354] pci 0000:00:16.0: BAR 0: reserving [mem 0xd6505000-0xd6505fff flags 0x40200] (d=0, p=0)
[    5.624355] pci 0000:00:16.2: BAR 0: reserving [mem 0xd6504000-0xd65040ff flags 0x40200] (d=0, p=0)
[    5.628359] pci 0000:01:05.0: BAR 0: reserving [mem 0xc0000000-0xcfffffff flags 0x42208] (d=0, p=0)
[    5.632353] pci 0000:01:05.0: BAR 1: reserving [io  0x6000-0x60ff flags 0x40101] (d=0, p=0)
[    5.636353] pci 0000:01:05.0: BAR 2: reserving [mem 0xd6400000-0xd640ffff flags 0x40200] (d=0, p=0)
[    5.640354] pci 0000:01:05.0: BAR 5: reserving [mem 0xd6300000-0xd63fffff flags 0x40200] (d=0, p=0)
[    5.644355] pci 0000:01:05.1: BAR 0: reserving [mem 0xd6410000-0xd6413fff flags 0x40200] (d=0, p=0)
[    5.648386] pci 0000:02:00.0: BAR 0: reserving [mem 0xd5200000-0xd5203fff flags 0x140204] (d=0, p=0)
[    5.652354] pci 0000:02:00.0: BAR 2: reserving [io  0x4000-0x40ff flags 0x40101] (d=0, p=0)
[    5.656388] pci 0000:03:00.0: BAR 0: reserving [mem 0xd4103000-0xd41030ff flags 0x40200] (d=0, p=0)
[    5.660388] pci 0000:03:00.1: BAR 0: reserving [mem 0xd4102000-0xd41020ff flags 0x40200] (d=0, p=0)
[    5.664388] pci 0000:03:00.2: BAR 0: reserving [mem 0xd4101000-0xd41010ff flags 0x40200] (d=0, p=0)
[    5.668388] pci 0000:03:00.3: BAR 0: reserving [mem 0xd4100000-0xd41007ff flags 0x40200] (d=0, p=0)
[    5.672392] pci 0000:07:00.0: BAR 0: reserving [mem 0xd3000000-0xd3003fff flags 0x140204] (d=0, p=0)
[    5.676494] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    5.680356] reserve RAM buffer: 00000000af6cf000 - 00000000afffffff 
[    5.684356] reserve RAM buffer: 00000000aff00000 - 00000000afffffff 
[    5.688362] device class 'net': registering
[    5.692373] device: 'lo': device_add
[    5.696383] PM: Adding info for No Bus:lo
[    5.700391] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    5.705256] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    5.713390] Switching to clocksource hpet
[    5.716428] bus: 'pnp': add driver system
[    5.720449] Switched to NOHz mode on CPU #2
[    5.720456] Switched to NOHz mode on CPU #0
[    5.720467] Switched to NOHz mode on CPU #1
[    5.732985] pnp: PnP ACPI init
[    5.736036] device: 'pnp0': device_add
[    5.739768] PM: Adding info for No Bus:pnp0
[    5.743947] ACPI: bus type pnp registered
[    5.748069] pnp 00:00: [bus 00-ff]
[    5.751453] pnp 00:00: [io  0x0000-0x0cf7 window]
[    5.756150] pnp 00:00: [io  0x0d00-0xffff window]
[    5.760841] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    5.766222] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    5.771604] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    5.776985] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    5.782368] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    5.787752] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    5.793134] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    5.798515] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    5.803899] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    5.809280] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    5.814663] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    5.820045] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    5.825426] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    5.830810] pnp 00:00: [mem 0xc0000000-0xdfffffff window]
[    5.836193] pnp 00:00: [mem 0xf0000000-0xfffdffff window]
[    5.841576] pnp 00:00: [io  0x0cf8-0x0cff]
[    5.845662] pnp 00:00: [mem 0xffe00000-0xffffffff]
[    5.850440] device: '00:00': device_add
[    5.854313] bus: 'pnp': add device 00:00
[    5.858231] PM: Adding info for pnp:00:00
[    5.862233] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    5.868816] pnp 00:01: [io  0x0000-0x000f]
[    5.872906] pnp 00:01: [io  0x0081-0x008f]
[    5.876991] pnp 00:01: [io  0x00c0-0x00df]
[    5.881076] pnp 00:01: [dma 4]
[    5.884122] device: '00:01': device_add
[    5.887949] bus: 'pnp': add device 00:01
[    5.891869] PM: Adding info for pnp:00:01
[    5.895871] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    5.902384] pnp 00:02: [io  0x00f0-0x00fe]
[    5.906477] pnp 00:02: [irq 13]
[    5.909611] device: '00:02': device_add
[    5.913450] bus: 'pnp': add device 00:02
[    5.917365] PM: Adding info for pnp:00:02
[    5.921364] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    5.927917] pnp 00:03: [io  0xfe00-0xfe0f]
[    5.932009] pnp 00:03: [io  0xfe80-0xfe8f]
[    5.936091] pnp 00:03: [mem 0xfed40000-0xfed44fff]
[    5.940869] device: '00:03': device_add
[    5.944708] bus: 'pnp': add device 00:03
[    5.948622] PM: Adding info for pnp:00:03
[    5.952622] pnp 00:03: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
[    5.959827] pnp 00:04: [io  0x0061]
[    5.963305] device: '00:04': device_add
[    5.967144] bus: 'pnp': add device 00:04
[    5.971060] PM: Adding info for pnp:00:04
[    5.975061] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    5.981599] pnp 00:05: [io  0x0010-0x001f]
[    5.985685] pnp 00:05: [io  0x002e-0x002f]
[    5.989770] pnp 00:05: [io  0x004e-0x004f]
[    5.993855] pnp 00:05: [io  0x0072-0x0073]
[    5.997938] pnp 00:05: [io  0x0080]
[    6.001415] pnp 00:05: [io  0x00b0-0x00b1]
[    6.005500] pnp 00:05: [io  0x0092]
[    6.008978] pnp 00:05: [io  0x0400-0x04cf]
[    6.013062] pnp 00:05: [io  0x04d0-0x04d1]
[    6.017147] pnp 00:05: [io  0x04d6]
[    6.020627] pnp 00:05: [io  0x0680-0x06ff]
[    6.024711] pnp 00:05: [io  0x077a]
[    6.028190] pnp 00:05: [io  0x0c00-0x0c01]
[    6.032275] pnp 00:05: [io  0x0c14]
[    6.035740] pnp 00:05: [io  0x0c50-0x0c52]
[    6.039831] pnp 00:05: [io  0x0c6c]
[    6.043307] pnp 00:05: [io  0x0c6f]
[    6.046784] pnp 00:05: [io  0x0cd0-0x0cdb]
[    6.050869] pnp 00:05: [io  0x0220-0x0227]
[    6.054954] pnp 00:05: [io  0x0260-0x0273]
[    6.059039] pnp 00:05: [io  0x0800]
[    6.062516] pnp 00:05: [io  0x0804]
[    6.065993] pnp 00:05: [io  0x087f]
[    6.069470] pnp 00:05: [io  0x0cdc-0x0cdf]
[    6.073555] pnp 00:05: [io  0x00b8]
[    6.077035] pnp 00:05: [io  0x0022-0x0023]
[    6.081120] pnp 00:05: [io  0x0b00-0x0b0f]
[    6.085204] pnp 00:05: [io  0x0b20-0x0b3f]
[    6.089289] pnp 00:05: [io  0x0200-0x027f]
[    6.093420] device: '00:05': device_add
[    6.097264] bus: 'pnp': add device 00:05
[    6.101178] PM: Adding info for pnp:00:05
[    6.105178] bus: 'pnp': driver_probe_device: matched device 00:05 with driver system
[    6.112896] bus: 'pnp': really_probe: probing driver system with device 00:05
[    6.120013] system 00:05: [io  0x0400-0x04cf] has been reserved
[    6.125916] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    6.131818] system 00:05: [io  0x04d6] has been reserved
[    6.137114] system 00:05: [io  0x0680-0x06ff] has been reserved
[    6.143017] system 00:05: [io  0x077a] has been reserved
[    6.148312] system 00:05: [io  0x0c00-0x0c01] has been reserved
[    6.154215] system 00:05: [io  0x0c14] has been reserved
[    6.159512] system 00:05: [io  0x0c50-0x0c52] has been reserved
[    6.165413] system 00:05: [io  0x0c6c] has been reserved
[    6.170709] system 00:05: [io  0x0c6f] has been reserved
[    6.176009] system 00:05: [io  0x0cd0-0x0cdb] has been reserved
[    6.181910] system 00:05: [io  0x0220-0x0227] has been reserved
[    6.187811] system 00:05: [io  0x0260-0x0273] has been reserved
[    6.193713] system 00:05: [io  0x0800] has been reserved
[    6.199009] system 00:05: [io  0x0804] has been reserved
[    6.204305] system 00:05: [io  0x087f] has been reserved
[    6.209600] system 00:05: [io  0x0cdc-0x0cdf] has been reserved
[    6.215503] system 00:05: [io  0x0b00-0x0b0f] has been reserved
[    6.221404] system 00:05: [io  0x0b20-0x0b3f] has been reserved
[    6.227308] system 00:05: [io  0x0200-0x027f] could not be reserved
[    6.233556] driver: '00:05': driver_bound: bound to device 'system'
[    6.239803] bus: 'pnp': really_probe: bound device 00:05 to driver system
[    6.246570] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    6.253373] pnp 00:06: [mem 0x00000000-0x0009ffff]
[    6.258150] pnp 00:06: [mem 0x000ec000-0x000fffff]
[    6.262926] pnp 00:06: [mem 0x00100000-0xbfffffff]
[    6.267702] pnp 00:06: [mem 0xe0000000-0xefffffff]
[    6.272478] pnp 00:06: [mem 0xfeb00000-0xfeb00fff]
[    6.277255] pnp 00:06: [mem 0xfec00000-0xfec00fff]
[    6.282031] pnp 00:06: [mem 0xfee00000-0xfee00fff]
[    6.286806] pnp 00:06: [mem 0xffe00000-0xffffffff]
[    6.291605] device: '00:06': device_add
[    6.295445] bus: 'pnp': add device 00:06
[    6.299359] PM: Adding info for pnp:00:06
[    6.303361] bus: 'pnp': driver_probe_device: matched device 00:06 with driver system
[    6.311082] bus: 'pnp': really_probe: probing driver system with device 00:06
[    6.318198] system 00:06: [mem 0x00000000-0x0009ffff] could not be reserved
[    6.325140] system 00:06: [mem 0x000ec000-0x000fffff] could not be reserved
[    6.332082] system 00:06: [mem 0x00100000-0xbfffffff] could not be reserved
[    6.339024] system 00:06: [mem 0xe0000000-0xefffffff] has been reserved
[    6.345618] system 00:06: [mem 0xfeb00000-0xfeb00fff] has been reserved
[    6.352213] system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
[    6.359155] system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
[    6.365749] system 00:06: [mem 0xffe00000-0xffffffff] has been reserved
[    6.372344] driver: '00:06': driver_bound: bound to device 'system'
[    6.378591] bus: 'pnp': really_probe: bound device 00:06 to driver system
[    6.385357] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
[    6.392151] pnp 00:07: [io  0x0070-0x0071]
[    6.396239] pnp 00:07: [irq 8]
[    6.399275] device: '00:07': device_add
[    6.403120] bus: 'pnp': add device 00:07
[    6.407033] PM: Adding info for pnp:00:07
[    6.411036] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    6.417608] pnp 00:08: [mem 0xfed00000-0xfed003ff]
[    6.422386] device: '00:08': device_add
[    6.426227] bus: 'pnp': add device 00:08
[    6.430141] PM: Adding info for pnp:00:08
[    6.434141] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[    6.440997] pnp 00:09: [io  0x03f8-0x03ff]
[    6.445084] pnp 00:09: [irq 4]
[    6.448152] device: '00:09': device_add
[    6.451982] bus: 'pnp': add device 00:09
[    6.455904] PM: Adding info for pnp:00:09
[    6.459904] pnp 00:09: Plug and Play ACPI device, IDs PNP0501 PNP0500 (active)
[    6.467142] pnp 00:0a: [io  0x0060]
[    6.470625] pnp 00:0a: [io  0x0064]
[    6.474105] pnp 00:0a: [irq 1]
[    6.477151] device: '00:0a': device_add
[    6.480994] bus: 'pnp': add device 00:0a
[    6.484908] PM: Adding info for pnp:00:0a
[    6.488908] pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 (active)
[    6.495424] pnp 00:0b: [irq 12]
[    6.498559] device: '00:0b': device_add
[    6.502403] bus: 'pnp': add device 00:0b
[    6.506317] PM: Adding info for pnp:00:0b
[    6.510319] pnp 00:0b: Plug and Play ACPI device, IDs SYN0178 SYN0100 SYN0002 PNP0f13 (active)
[    6.744166] pnp 00:0c: [irq 23]
[    6.747293] device: '00:0c': device_add
[    6.751174] bus: 'pnp': add device 00:0c
[    6.755100] PM: Adding info for pnp:00:0c
[    6.759106] pnp 00:0c: Plug and Play ACPI device, IDs HPQ0004 (active)
[    6.765831] pnp: PnP ACPI: found 13 devices
[    6.770002] ACPI: ACPI bus type pnp unregistered
[    6.774619] device class 'mem': registering
[    6.778798] device: 'mem': device_add
[    6.782509] PM: Adding info for No Bus:mem
[    6.786598] device: 'kmem': device_add
[    6.790387] PM: Adding info for No Bus:kmem
[    6.794563] device: 'null': device_add
[    6.798352] PM: Adding info for No Bus:null
[    6.802525] device: 'port': device_add
[    6.806317] PM: Adding info for No Bus:port
[    6.810492] device: 'zero': device_add
[    6.814280] PM: Adding info for No Bus:zero
[    6.818455] device: 'full': device_add
[    6.822244] PM: Adding info for No Bus:full
[    6.826418] device: 'random': device_add
[    6.830379] PM: Adding info for No Bus:random
[    6.834726] device: 'urandom': device_add
[    6.838778] PM: Adding info for No Bus:urandom
[    6.843213] device: 'kmsg': device_add
[    6.847001] PM: Adding info for No Bus:kmsg
[    6.851174] device: 'oldmem': device_add
[    6.855136] PM: Adding info for No Bus:oldmem
[    6.859482] device: 'tty': device_add
[    6.863187] PM: Adding info for No Bus:tty
[    6.867275] device: 'console': device_add
[    6.871322] PM: Adding info for No Bus:console
[    6.875757] device: 'tty0': device_add
[    6.879548] PM: Adding info for No Bus:tty0
[    6.883722] device class 'vc': registering
[    6.887809] device: 'vcs': device_add
[    6.891512] PM: Adding info for No Bus:vcs
[    6.895599] device: 'vcsa': device_add
[    6.899391] PM: Adding info for No Bus:vcsa
[    6.903566] device: 'vcs1': device_add
[    6.907355] PM: Adding info for No Bus:vcs1
[    6.911529] device: 'vcsa1': device_add
[    6.915404] PM: Adding info for No Bus:vcsa1
[    6.919666] device: 'tty1': device_add
[    6.923455] PM: Adding info for No Bus:tty1
[    6.927629] device: 'tty2': device_add
[    6.931417] PM: Adding info for No Bus:tty2
[    6.935591] device: 'tty3': device_add
[    6.939381] PM: Adding info for No Bus:tty3
[    6.943555] device: 'tty4': device_add
[    6.947346] PM: Adding info for No Bus:tty4
[    6.951519] device: 'tty5': device_add
[    6.955308] PM: Adding info for No Bus:tty5
[    6.959483] device: 'tty6': device_add
[    6.963271] PM: Adding info for No Bus:tty6
[    6.967447] device: 'tty7': device_add
[    6.971237] PM: Adding info for No Bus:tty7
[    6.975411] device: 'tty8': device_add
[    6.979235] PM: Adding info for No Bus:tty8
[    6.983420] device: 'tty9': device_add
[    6.987213] PM: Adding info for No Bus:tty9
[    6.991388] device: 'tty10': device_add
[    6.995264] PM: Adding info for No Bus:tty10
[    6.999524] device: 'tty11': device_add
[    7.003407] PM: Adding info for No Bus:tty11
[    7.007669] device: 'tty12': device_add
[    7.011547] PM: Adding info for No Bus:tty12
[    7.015806] device: 'tty13': device_add
[    7.019682] PM: Adding info for No Bus:tty13
[    7.023943] device: 'tty14': device_add
[    7.027819] PM: Adding info for No Bus:tty14
[    7.032081] device: 'tty15': device_add
[    7.035950] PM: Adding info for No Bus:tty15
[    7.040211] device: 'tty16': device_add
[    7.044087] PM: Adding info for No Bus:tty16
[    7.048348] device: 'tty17': device_add
[    7.052224] PM: Adding info for No Bus:tty17
[    7.056485] device: 'tty18': device_add
[    7.060361] PM: Adding info for No Bus:tty18
[    7.064622] device: 'tty19': device_add
[    7.068500] PM: Adding info for No Bus:tty19
[    7.072760] device: 'tty20': device_add
[    7.076635] PM: Adding info for No Bus:tty20
[    7.080894] device: 'tty21': device_add
[    7.084776] PM: Adding info for No Bus:tty21
[    7.089036] device: 'tty22': device_add
[    7.092912] PM: Adding info for No Bus:tty22
[    7.097171] device: 'tty23': device_add
[    7.101047] PM: Adding info for No Bus:tty23
[    7.105306] device: 'tty24': device_add
[    7.109183] PM: Adding info for No Bus:tty24
[    7.113444] device: 'tty25': device_add
[    7.117321] PM: Adding info for No Bus:tty25
[    7.121580] device: 'tty26': device_add
[    7.125457] PM: Adding info for No Bus:tty26
[    7.129717] device: 'tty27': device_add
[    7.133594] PM: Adding info for No Bus:tty27
[    7.137856] device: 'tty28': device_add
[    7.141733] PM: Adding info for No Bus:tty28
[    7.145992] device: 'tty29': device_add
[    7.149869] PM: Adding info for No Bus:tty29
[    7.154130] device: 'tty30': device_add
[    7.158005] PM: Adding info for No Bus:tty30
[    7.162265] device: 'tty31': device_add
[    7.166142] PM: Adding info for No Bus:tty31
[    7.170402] device: 'tty32': device_add
[    7.174279] PM: Adding info for No Bus:tty32
[    7.178539] device: 'tty33': device_add
[    7.182415] PM: Adding info for No Bus:tty33
[    7.186675] device: 'tty34': device_add
[    7.190561] PM: Adding info for No Bus:tty34
[    7.194824] device: 'tty35': device_add
[    7.198701] PM: Adding info for No Bus:tty35
[    7.202961] device: 'tty36': device_add
[    7.206838] PM: Adding info for No Bus:tty36
[    7.211098] device: 'tty37': device_add
[    7.214975] PM: Adding info for No Bus:tty37
[    7.219237] device: 'tty38': device_add
[    7.223115] PM: Adding info for No Bus:tty38
[    7.227375] device: 'tty39': device_add
[    7.231252] PM: Adding info for No Bus:tty39
[    7.235511] device: 'tty40': device_add
[    7.239390] PM: Adding info for No Bus:tty40
[    7.243649] device: 'tty41': device_add
[    7.247526] PM: Adding info for No Bus:tty41
[    7.251785] device: 'tty42': device_add
[    7.255664] PM: Adding info for No Bus:tty42
[    7.259927] device: 'tty43': device_add
[    7.263803] PM: Adding info for No Bus:tty43
[    7.268065] device: 'tty44': device_add
[    7.271937] PM: Adding info for No Bus:tty44
[    7.276199] device: 'tty45': device_add
[    7.280076] PM: Adding info for No Bus:tty45
[    7.284336] device: 'tty46': device_add
[    7.288214] PM: Adding info for No Bus:tty46
[    7.292474] device: 'tty47': device_add
[    7.296351] PM: Adding info for No Bus:tty47
[    7.300611] device: 'tty48': device_add
[    7.304487] PM: Adding info for No Bus:tty48
[    7.308748] device: 'tty49': device_add
[    7.312625] PM: Adding info for No Bus:tty49
[    7.316886] device: 'tty50': device_add
[    7.320762] PM: Adding info for No Bus:tty50
[    7.325024] device: 'tty51': device_add
[    7.328903] PM: Adding info for No Bus:tty51
[    7.333165] device: 'tty52': device_add
[    7.337042] PM: Adding info for No Bus:tty52
[    7.341302] device: 'tty53': device_add
[    7.345180] PM: Adding info for No Bus:tty53
[    7.349441] device: 'tty54': device_add
[    7.353318] PM: Adding info for No Bus:tty54
[    7.357579] device: 'tty55': device_add
[    7.361458] PM: Adding info for No Bus:tty55
[    7.365718] device: 'tty56': device_add
[    7.369596] PM: Adding info for No Bus:tty56
[    7.373858] device: 'tty57': device_add
[    7.377735] PM: Adding info for No Bus:tty57
[    7.381995] device: 'tty58': device_add
[    7.385872] PM: Adding info for No Bus:tty58
[    7.390132] device: 'tty59': device_add
[    7.394012] PM: Adding info for No Bus:tty59
[    7.398273] device: 'tty60': device_add
[    7.402159] PM: Adding info for No Bus:tty60
[    7.406418] device: 'tty61': device_add
[    7.410299] PM: Adding info for No Bus:tty61
[    7.414561] device: 'tty62': device_add
[    7.418438] PM: Adding info for No Bus:tty62
[    7.422700] device: 'tty63': device_add
[    7.426580] PM: Adding info for No Bus:tty63
[    7.430876] device class 'firmware': registering
[    7.435492] device class 'thermal': registering
[    7.444811] pci 0000:02:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    7.453409] PCI: max bus depth: 1 pci_try_num: 2
[    7.458048] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    7.463262] pci 0000:00:01.0:   bridge window [io  0x6000-0x6fff]
[    7.469343] pci 0000:00:01.0:   bridge window [mem 0xd6300000-0xd64fffff]
[    7.476116] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    7.483846] pci 0000:02:00.0: BAR 6: assigned [mem 0xd0000000-0xd001ffff pref]
[    7.491050] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    7.496266] pci 0000:00:04.0:   bridge window [io  0x4000-0x5fff]
[    7.502348] pci 0000:00:04.0:   bridge window [mem 0xd5200000-0xd62fffff]
[    7.509122] pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd0ffffff 64bit pref]
[    7.516846] pci 0000:00:05.0: PCI bridge to [bus 03-03]
[    7.522056] pci 0000:00:05.0:   bridge window [io  0x3000-0x3fff]
[    7.528141] pci 0000:00:05.0:   bridge window [mem 0xd4100000-0xd51fffff]
[    7.534915] pci 0000:00:05.0:   bridge window [mem 0xd1000000-0xd1ffffff 64bit pref]
[    7.542641] pci 0000:00:07.0: PCI bridge to [bus 04-06]
[    7.547856] pci 0000:00:07.0:   bridge window [io  0x2000-0x2fff]
[    7.553939] pci 0000:00:07.0:   bridge window [mem 0xd3100000-0xd40fffff]
[    7.560712] pci 0000:00:07.0:   bridge window [mem 0xd2000000-0xd2ffffff 64bit pref]
[    7.568438] pci 0000:00:09.0: PCI bridge to [bus 07-07]
[    7.573654] pci 0000:00:09.0:   bridge window [mem 0xd3000000-0xd30fffff]
[    7.580429] pci 0000:00:14.4: PCI bridge to [bus 08-08]
[    7.585644] pci 0000:00:14.4:   bridge window [io  0x1000-0x1fff]
[    7.591741] pci 0000:00:01.0: setting latency timer to 64
[    7.597136] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.603824] pci 0000:00:04.0: setting latency timer to 64
[    7.609216] pci 0000:00:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.615903] pci 0000:00:05.0: setting latency timer to 64
[    7.621294] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    7.627982] pci 0000:00:07.0: setting latency timer to 64
[    7.633373] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    7.640058] pci 0000:00:09.0: setting latency timer to 64
[    7.645452] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    7.651013] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    7.656576] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    7.662830] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    7.669085] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    7.675339] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    7.681594] pci_bus 0000:00: resource 10 [mem 0x000d0000-0x000d3fff]
[    7.687934] pci_bus 0000:00: resource 11 [mem 0x000d4000-0x000d7fff]
[    7.694274] pci_bus 0000:00: resource 12 [mem 0x000d8000-0x000dbfff]
[    7.700614] pci_bus 0000:00: resource 13 [mem 0x000dc000-0x000dffff]
[    7.706955] pci_bus 0000:00: resource 14 [mem 0x000e0000-0x000e3fff]
[    7.713296] pci_bus 0000:00: resource 15 [mem 0x000e4000-0x000e7fff]
[    7.719636] pci_bus 0000:00: resource 16 [mem 0x000e8000-0x000ebfff]
[    7.725977] pci_bus 0000:00: resource 17 [mem 0x000ec000-0x000effff]
[    7.732316] pci_bus 0000:00: resource 18 [mem 0xc0000000-0xdfffffff]
[    7.738656] pci_bus 0000:00: resource 19 [mem 0xf0000000-0xffffffff]
[    7.744997] pci_bus 0000:01: resource 0 [io  0x6000-0x6fff]
[    7.750557] pci_bus 0000:01: resource 1 [mem 0xd6300000-0xd64fffff]
[    7.756812] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
[    7.764018] pci_bus 0000:02: resource 0 [io  0x4000-0x5fff]
[    7.769579] pci_bus 0000:02: resource 1 [mem 0xd5200000-0xd62fffff]
[    7.775830] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xd0ffffff 64bit pref]
[    7.783034] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    7.788594] pci_bus 0000:03: resource 1 [mem 0xd4100000-0xd51fffff]
[    7.794849] pci_bus 0000:03: resource 2 [mem 0xd1000000-0xd1ffffff 64bit pref]
[    7.802055] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    7.807616] pci_bus 0000:04: resource 1 [mem 0xd3100000-0xd40fffff]
[    7.813870] pci_bus 0000:04: resource 2 [mem 0xd2000000-0xd2ffffff 64bit pref]
[    7.821075] pci_bus 0000:07: resource 1 [mem 0xd3000000-0xd30fffff]
[    7.827329] pci_bus 0000:08: resource 0 [io  0x1000-0x1fff]
[    7.832891] pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
[    7.838451] pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
[    7.844009] pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
[    7.850264] pci_bus 0000:08: resource 7 [mem 0x000c0000-0x000c3fff]
[    7.856519] pci_bus 0000:08: resource 8 [mem 0x000c4000-0x000c7fff]
[    7.862772] pci_bus 0000:08: resource 9 [mem 0x000c8000-0x000cbfff]
[    7.869026] pci_bus 0000:08: resource 10 [mem 0x000d0000-0x000d3fff]
[    7.875367] pci_bus 0000:08: resource 11 [mem 0x000d4000-0x000d7fff]
[    7.881707] pci_bus 0000:08: resource 12 [mem 0x000d8000-0x000dbfff]
[    7.888047] pci_bus 0000:08: resource 13 [mem 0x000dc000-0x000dffff]
[    7.894387] pci_bus 0000:08: resource 14 [mem 0x000e0000-0x000e3fff]
[    7.900727] pci_bus 0000:08: resource 15 [mem 0x000e4000-0x000e7fff]
[    7.907067] pci_bus 0000:08: resource 16 [mem 0x000e8000-0x000ebfff]
[    7.913403] pci_bus 0000:08: resource 17 [mem 0x000ec000-0x000effff]
[    7.919744] pci_bus 0000:08: resource 18 [mem 0xc0000000-0xdfffffff]
[    7.926084] pci_bus 0000:08: resource 19 [mem 0xf0000000-0xffffffff]
[    7.932455] NET: Registered protocol family 2
[    7.936846] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    7.944758] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    7.953415] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    7.960435] TCP: Hash tables configured (established 262144 bind 65536)
[    7.967072] TCP reno registered
[    7.970212] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    7.976342] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    7.982961] NET: Registered protocol family 1
[    7.987446] RPC: Registered named UNIX socket transport module.
[    7.993363] RPC: Registered udp transport module.
[    7.998057] RPC: Registered tcp transport module.
[    8.002749] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    8.009179] pci 0000:00:00.0: calling quirk_amd_780_apc_msi+0x0/0x40
[    8.015515] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    8.022371] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.028621] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.035216] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xba
[    8.041034] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.047283] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.053880] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xba
[    8.059697] pci 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.065947] pci 0000:00:04.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.072541] pci 0000:00:04.0: calling pci_fixup_video+0x0/0xba
[    8.078358] pci 0000:00:05.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.084608] pci 0000:00:05.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.091201] pci 0000:00:05.0: calling pci_fixup_video+0x0/0xba
[    8.097018] pci 0000:00:07.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.103268] pci 0000:00:07.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.109861] pci 0000:00:07.0: calling pci_fixup_video+0x0/0xba
[    8.115677] pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.121928] pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.128522] pci 0000:00:09.0: calling pci_fixup_video+0x0/0xba
[    8.134339] pci 0000:00:11.0: calling quirk_msi_intx_disable_ati_bug+0x0/0x47
[    8.141454] pci 0000:00:11.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.147704] pci 0000:00:11.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.154299] pci 0000:00:11.0: calling pci_fixup_video+0x0/0xba
[    8.160116] pci 0000:00:12.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.166366] pci 0000:00:12.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.173004] pci 0000:00:12.0: calling pci_fixup_video+0x0/0xba
[    8.178823] pci 0000:00:12.2: calling quirk_cardbus_legacy+0x0/0x30
[    8.185073] pci 0000:00:12.2: calling quirk_usb_early_handoff+0x0/0x680
[    8.191700] pci 0000:00:12.2: calling pci_fixup_video+0x0/0xba
[    8.197519] pci 0000:00:13.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.203767] pci 0000:00:13.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.210389] pci 0000:00:13.0: calling pci_fixup_video+0x0/0xba
[    8.216209] pci 0000:00:13.2: calling quirk_cardbus_legacy+0x0/0x30
[    8.222457] pci 0000:00:13.2: calling quirk_usb_early_handoff+0x0/0x680
[    8.229082] pci 0000:00:13.2: calling pci_fixup_video+0x0/0xba
[    8.234900] pci 0000:00:14.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.241148] pci 0000:00:14.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.247743] pci 0000:00:14.0: calling pci_fixup_video+0x0/0xba
[    8.253560] pci 0000:00:14.2: calling quirk_cardbus_legacy+0x0/0x30
[    8.259809] pci 0000:00:14.2: calling quirk_usb_early_handoff+0x0/0x680
[    8.266403] pci 0000:00:14.2: calling pci_fixup_video+0x0/0xba
[    8.272219] PCI: CLS mismatch (64 != 32), using 64 bytes
[    8.277518] pci 0000:00:14.3: calling quirk_cardbus_legacy+0x0/0x30
[    8.283767] pci 0000:00:14.3: calling quirk_usb_early_handoff+0x0/0x680
[    8.290361] pci 0000:00:14.3: calling pci_fixup_video+0x0/0xba
[    8.296177] pci 0000:00:14.4: calling quirk_cardbus_legacy+0x0/0x30
[    8.302426] pci 0000:00:14.4: calling quirk_usb_early_handoff+0x0/0x680
[    8.309022] pci 0000:00:14.4: calling pci_fixup_video+0x0/0xba
[    8.314838] pci 0000:00:14.5: calling quirk_cardbus_legacy+0x0/0x30
[    8.321086] pci 0000:00:14.5: calling quirk_usb_early_handoff+0x0/0x680
[    8.327709] pci 0000:00:14.5: calling pci_fixup_video+0x0/0xba
[    8.333527] pci 0000:00:16.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.339775] pci 0000:00:16.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.346397] pci 0000:00:16.0: calling pci_fixup_video+0x0/0xba
[    8.352214] pci 0000:00:16.2: calling quirk_cardbus_legacy+0x0/0x30
[    8.358462] pci 0000:00:16.2: calling quirk_usb_early_handoff+0x0/0x680
[    8.365087] pci 0000:00:16.2: calling pci_fixup_video+0x0/0xba
[    8.370903] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.377151] pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.383746] pci 0000:00:18.0: calling pci_fixup_video+0x0/0xba
[    8.389562] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x30
[    8.395811] pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0x680
[    8.402405] pci 0000:00:18.1: calling pci_fixup_video+0x0/0xba
[    8.408221] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x30
[    8.414470] pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0x680
[    8.421064] pci 0000:00:18.2: calling pci_fixup_video+0x0/0xba
[    8.426880] pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x30
[    8.433129] pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0x680
[    8.439723] pci 0000:00:18.3: calling pci_fixup_video+0x0/0xba
[    8.445540] pci 0000:00:18.4: calling quirk_cardbus_legacy+0x0/0x30
[    8.451789] pci 0000:00:18.4: calling quirk_usb_early_handoff+0x0/0x680
[    8.458383] pci 0000:00:18.4: calling pci_fixup_video+0x0/0xba
[    8.464202] pci 0000:01:05.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.470451] pci 0000:01:05.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.477045] pci 0000:01:05.0: calling pci_fixup_video+0x0/0xba
[    8.482860] pci 0000:01:05.0: Boot video device
[    8.487379] pci 0000:01:05.1: calling quirk_cardbus_legacy+0x0/0x30
[    8.493628] pci 0000:01:05.1: calling quirk_usb_early_handoff+0x0/0x680
[    8.500222] pci 0000:01:05.1: calling pci_fixup_video+0x0/0xba
[    8.506038] pci 0000:02:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.512287] pci 0000:02:00.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.518881] pci 0000:02:00.0: calling pci_fixup_video+0x0/0xba
[    8.524697] pci 0000:03:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.530946] pci 0000:03:00.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.537541] pci 0000:03:00.0: calling pci_fixup_video+0x0/0xba
[    8.543358] pci 0000:03:00.1: calling quirk_cardbus_legacy+0x0/0x30
[    8.549607] pci 0000:03:00.1: calling quirk_usb_early_handoff+0x0/0x680
[    8.556201] pci 0000:03:00.1: calling pci_fixup_video+0x0/0xba
[    8.562017] pci 0000:03:00.2: calling quirk_cardbus_legacy+0x0/0x30
[    8.568266] pci 0000:03:00.2: calling quirk_usb_early_handoff+0x0/0x680
[    8.574862] pci 0000:03:00.2: calling pci_fixup_video+0x0/0xba
[    8.580677] pci 0000:03:00.3: calling quirk_cardbus_legacy+0x0/0x30
[    8.586928] pci 0000:03:00.3: calling quirk_usb_early_handoff+0x0/0x680
[    8.593522] pci 0000:03:00.3: calling pci_fixup_video+0x0/0xba
[    8.599339] pci 0000:07:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    8.605587] pci 0000:07:00.0: calling quirk_usb_early_handoff+0x0/0x680
[    8.612181] pci 0000:07:00.0: calling pci_fixup_video+0x0/0xba
[    8.618030] Unpacking initramfs...
[    8.831313] Freeing initrd memory: 11336k freed
[    8.839180] bus: 'pci': add driver agpgart-amd64
[    8.843863] bus: 'pci': driver_probe_device: matched device 0000:00:00.0 with driver agpgart-amd64
[    8.852815] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:00.0
[    8.861169] bus: 'pci': driver_probe_device: matched device 0000:00:01.0 with driver agpgart-amd64
[    8.870101] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:01.0
[    8.878432] bus: 'pci': driver_probe_device: matched device 0000:00:04.0 with driver agpgart-amd64
[    8.887363] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:04.0
[    8.895696] bus: 'pci': driver_probe_device: matched device 0000:00:05.0 with driver agpgart-amd64
[    8.904627] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:05.0
[    8.912962] bus: 'pci': driver_probe_device: matched device 0000:00:07.0 with driver agpgart-amd64
[    8.921893] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:07.0
[    8.930227] bus: 'pci': driver_probe_device: matched device 0000:00:09.0 with driver agpgart-amd64
[    8.939158] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:09.0
[    8.947494] bus: 'pci': driver_probe_device: matched device 0000:00:11.0 with driver agpgart-amd64
[    8.956429] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:11.0
[    8.964764] bus: 'pci': driver_probe_device: matched device 0000:00:12.0 with driver agpgart-amd64
[    8.973696] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:12.0
[    8.982024] bus: 'pci': driver_probe_device: matched device 0000:00:12.2 with driver agpgart-amd64
[    8.990955] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:12.2
[    8.999290] bus: 'pci': driver_probe_device: matched device 0000:00:13.0 with driver agpgart-amd64
[    9.008222] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:13.0
[    9.016551] bus: 'pci': driver_probe_device: matched device 0000:00:13.2 with driver agpgart-amd64
[    9.025482] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:13.2
[    9.033817] bus: 'pci': driver_probe_device: matched device 0000:00:14.0 with driver agpgart-amd64
[    9.042749] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:14.0
[    9.051079] bus: 'pci': driver_probe_device: matched device 0000:00:14.2 with driver agpgart-amd64
[    9.060010] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:14.2
[    9.068343] bus: 'pci': driver_probe_device: matched device 0000:00:14.3 with driver agpgart-amd64
[    9.077275] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:14.3
[    9.085603] bus: 'pci': driver_probe_device: matched device 0000:00:14.4 with driver agpgart-amd64
[    9.094534] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:14.4
[    9.102865] bus: 'pci': driver_probe_device: matched device 0000:00:14.5 with driver agpgart-amd64
[    9.111796] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:14.5
[    9.120124] bus: 'pci': driver_probe_device: matched device 0000:00:16.0 with driver agpgart-amd64
[    9.129056] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:16.0
[    9.137386] bus: 'pci': driver_probe_device: matched device 0000:00:16.2 with driver agpgart-amd64
[    9.146317] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:16.2
[    9.154653] bus: 'pci': driver_probe_device: matched device 0000:00:18.0 with driver agpgart-amd64
[    9.163584] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:18.0
[    9.171913] bus: 'pci': driver_probe_device: matched device 0000:00:18.1 with driver agpgart-amd64
[    9.180845] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:18.1
[    9.189176] bus: 'pci': driver_probe_device: matched device 0000:00:18.2 with driver agpgart-amd64
[    9.198106] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:18.2
[    9.206435] bus: 'pci': driver_probe_device: matched device 0000:00:18.3 with driver agpgart-amd64
[    9.215367] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:18.3
[    9.223695] bus: 'pci': driver_probe_device: matched device 0000:00:18.4 with driver agpgart-amd64
[    9.232626] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:00:18.4
[    9.240955] bus: 'pci': driver_probe_device: matched device 0000:01:05.0 with driver agpgart-amd64
[    9.249886] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:01:05.0
[    9.258218] bus: 'pci': driver_probe_device: matched device 0000:01:05.1 with driver agpgart-amd64
[    9.267149] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:01:05.1
[    9.275481] bus: 'pci': driver_probe_device: matched device 0000:02:00.0 with driver agpgart-amd64
[    9.284412] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:02:00.0
[    9.292786] bus: 'pci': driver_probe_device: matched device 0000:03:00.0 with driver agpgart-amd64
[    9.301722] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:03:00.0
[    9.310092] bus: 'pci': driver_probe_device: matched device 0000:03:00.1 with driver agpgart-amd64
[    9.319027] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:03:00.1
[    9.327397] bus: 'pci': driver_probe_device: matched device 0000:03:00.2 with driver agpgart-amd64
[    9.336333] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:03:00.2
[    9.344702] bus: 'pci': driver_probe_device: matched device 0000:03:00.3 with driver agpgart-amd64
[    9.353637] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:03:00.3
[    9.362006] bus: 'pci': driver_probe_device: matched device 0000:07:00.0 with driver agpgart-amd64
[    9.370942] bus: 'pci': really_probe: probing driver agpgart-amd64 with device 0000:07:00.0
[    9.379319] bus: 'pci': remove driver agpgart-amd64
[    9.384191] driver: 'agpgart-amd64': driver_release
[    9.389055] PCI-DMA: Disabling AGP.
[    9.396972] PCI-DMA: aperture base @ a4000000 size 65536 KB
[    9.402529] PCI-DMA: using GART IOMMU.
[    9.406268] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    9.415848] Registering sysdev class 'machinecheck'
[    9.420737] Registering sys device of class 'machinecheck'
[    9.426206] Registering sys device 'machinecheck0'
[    9.430991] Registering sys device of class 'machinecheck'
[    9.436460] Registering sys device 'machinecheck1'
[    9.441244] Registering sys device of class 'machinecheck'
[    9.446712] Registering sys device 'machinecheck2'
[    9.451500] device: 'mcelog': device_add
[    9.455491] PM: Adding info for No Bus:mcelog
[    9.459871] Registering platform device 'pcspkr'. Parent at platform
[    9.466212] device: 'pcspkr': device_add
[    9.470125] bus: 'platform': add device pcspkr
[    9.474560] PM: Adding info for platform:pcspkr
[    9.479106] Registering sysdev class 'clocksource'
[    9.483888] Registering sys device of class 'clocksource'
[    9.489271] Registering sys device 'clocksource0'
[    9.493966] bus: 'platform': add driver alarmtimer
[    9.498750] Registering platform device 'alarmtimer'. Parent at platform
[    9.505430] device: 'alarmtimer': device_add
[    9.509689] bus: 'platform': add device alarmtimer
[    9.514467] PM: Adding info for platform:alarmtimer
[    9.519334] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    9.528266] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    9.536594] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    9.543620] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    9.551607] device: 'snapshot': device_add
[    9.555747] PM: Adding info for No Bus:snapshot
[    9.560312] bus: 'event_source': registered
[    9.564488] device: 'cpu': device_add
[    9.568141] bus: 'event_source': add device cpu
[    9.572661] PM: Adding info for event_source:cpu
[    9.577268] device: 'breakpoint': device_add
[    9.581526] bus: 'event_source': add device breakpoint
[    9.586652] PM: Adding info for event_source:breakpoint
[    9.591863] device: 'software': device_add
[    9.595948] bus: 'event_source': add device software
[    9.600899] PM: Adding info for event_source:software
[    9.625474] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    9.631566] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    9.638256] NTFS driver 2.1.30 [Flags: R/O].
[    9.642583] device: 'autofs': device_add
[    9.646561] PM: Adding info for No Bus:autofs
[    9.650911] fuse init (API version 7.17)
[    9.654873] device: 'fuse': device_add
[    9.658667] PM: Adding info for No Bus:fuse
[    9.662845] device class 'cuse': registering
[    9.667109] device: 'cuse': device_add
[    9.670898] PM: Adding info for No Bus:cuse
[    9.675099] msgmni has been set to 15360
[    9.679223] device class 'bsg': registering
[    9.683404] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    9.690776] io scheduler noop registered
[    9.694688] io scheduler deadline registered
[    9.698977] io scheduler cfq registered (default)
[    9.703725] bus: 'pci_express': registered
[    9.707814] bus: 'pci': add driver pcieport
[    9.711987] bus: 'pci': driver_probe_device: matched device 0000:00:01.0 with driver pcieport
[    9.720484] bus: 'pci': really_probe: probing driver pcieport with device 0000:00:01.0
[    9.728386] bus: 'pci': driver_probe_device: matched device 0000:00:04.0 with driver pcieport
[    9.736883] bus: 'pci': really_probe: probing driver pcieport with device 0000:00:04.0
[    9.744783] pcieport 0000:00:04.0: setting latency timer to 64
[    9.750619] pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
[    9.755831] device: '0000:00:04.0:pcie08': device_add
[    9.760871] bus: 'pci_express': add device 0000:00:04.0:pcie08
[    9.766689] PM: Adding info for pci_express:0000:00:04.0:pcie08
[    9.772609] driver: '0000:00:04.0': driver_bound: bound to device 'pcieport'
[    9.779635] bus: 'pci': really_probe: bound device 0000:00:04.0 to driver pcieport
[    9.787182] bus: 'pci': driver_probe_device: matched device 0000:00:05.0 with driver pcieport
[    9.795679] bus: 'pci': really_probe: probing driver pcieport with device 0000:00:05.0
[    9.803575] pcieport 0000:00:05.0: setting latency timer to 64
[    9.809408] pcieport 0000:00:05.0: irq 41 for MSI/MSI-X
[    9.814618] device: '0000:00:05.0:pcie08': device_add
[    9.819654] bus: 'pci_express': add device 0000:00:05.0:pcie08
[    9.825471] PM: Adding info for pci_express:0000:00:05.0:pcie08
[    9.831389] driver: '0000:00:05.0': driver_bound: bound to device 'pcieport'
[    9.838415] bus: 'pci': really_probe: bound device 0000:00:05.0 to driver pcieport
[    9.845960] bus: 'pci': driver_probe_device: matched device 0000:00:07.0 with driver pcieport
[    9.854457] bus: 'pci': really_probe: probing driver pcieport with device 0000:00:07.0
[    9.862354] pcieport 0000:00:07.0: setting latency timer to 64
[    9.868188] pcieport 0000:00:07.0: irq 42 for MSI/MSI-X
[    9.873399] device: '0000:00:07.0:pcie08': device_add
[    9.878435] bus: 'pci_express': add device 0000:00:07.0:pcie08
[    9.884252] PM: Adding info for pci_express:0000:00:07.0:pcie08
[    9.890170] driver: '0000:00:07.0': driver_bound: bound to device 'pcieport'
[    9.897197] bus: 'pci': really_probe: bound device 0000:00:07.0 to driver pcieport
[    9.904744] bus: 'pci': driver_probe_device: matched device 0000:00:09.0 with driver pcieport
[    9.913241] bus: 'pci': really_probe: probing driver pcieport with device 0000:00:09.0
[    9.921140] pcieport 0000:00:09.0: setting latency timer to 64
[    9.926976] pcieport 0000:00:09.0: irq 43 for MSI/MSI-X
[    9.932186] device: '0000:00:09.0:pcie08': device_add
[    9.937222] bus: 'pci_express': add device 0000:00:09.0:pcie08
[    9.943039] PM: Adding info for pci_express:0000:00:09.0:pcie08
[    9.948962] driver: '0000:00:09.0': driver_bound: bound to device 'pcieport'
[    9.955988] bus: 'pci': really_probe: bound device 0000:00:09.0 to driver pcieport
[    9.963544] bus: 'pci_express': add driver aer
[    9.967981] bus: 'pci_express': add driver pcie_pme
[    9.972848] bus: 'pci': add driver ioapic
[    9.976852] device: 'fbcon': device_add
[    9.976859] PM: Adding info for No Bus:fbcon
[    9.984940] bus: 'platform': add driver generic-bl
[    9.989725] Registering platform device 'vesafb.0'. Parent at platform
[    9.996233] device: 'vesafb.0': device_add
[   10.000317] bus: 'platform': add device vesafb.0
[   10.004924] PM: Adding info for platform:vesafb.0
[   10.009618] bus: 'platform': add driver vesafb
[   10.014051] bus: 'platform': driver_probe_device: matched device vesafb.0 with driver vesafb
[   10.022462] bus: 'platform': really_probe: probing driver vesafb with device vesafb.0
[   10.030273] bus: 'platform': remove driver vesafb
[   10.034966] driver: 'vesafb': driver_release
[   10.039224] PM: Removing info for platform:vesafb.0
[   10.044090] bus: 'platform': remove device vesafb.0
[   10.048962] bus: 'acpi': add driver ac
[   10.052718] bus: 'acpi': driver_probe_device: matched device ACPI0003:00 with driver ac
[   10.060697] bus: 'acpi': really_probe: probing driver ac with device ACPI0003:00
[   10.208159] device: 'AC': device_add
[   10.211729] PM: Adding info for No Bus:AC
[   10.312167] ACPI: AC Adapter [AC] (on-line)
[   10.316347] driver: 'ACPI0003:00': driver_bound: bound to device 'ac'
[   10.322773] bus: 'acpi': really_probe: bound device ACPI0003:00 to driver ac
[   10.329828] bus: 'acpi': add driver button
[   10.333942] bus: 'acpi': driver_probe_device: matched device PNP0C0E:00 with driver button
[   10.342187] bus: 'acpi': really_probe: probing driver button with device PNP0C0E:00
[   10.349833] device: 'input0': device_add
[   10.353766] PM: Adding info for No Bus:input0
[   10.358130] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[   10.366288] ACPI: Sleep Button [SLPB]
[   10.369945] driver: 'PNP0C0E:00': driver_bound: bound to device 'button'
[   10.376632] bus: 'acpi': really_probe: bound device PNP0C0E:00 to driver button
[   10.383924] bus: 'acpi': driver_probe_device: matched device PNP0C0D:00 with driver button
[   10.392168] bus: 'acpi': really_probe: probing driver button with device PNP0C0D:00
[   10.399817] device: 'input1': device_add
[   10.403748] PM: Adding info for No Bus:input1
[   10.408108] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[   10.416356] ACPI: Lid Switch [LID]
[   10.419743] driver: 'PNP0C0D:00': driver_bound: bound to device 'button'
[   10.426452] bus: 'acpi': really_probe: bound device PNP0C0D:00 to driver button
[   10.433747] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[   10.442073] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[   10.449811] device: 'input2': device_add
[   10.452076] Refined TSC clocksource calibration: 2094.754 MHz.
[   10.452081] Switching to clocksource tsc
[   10.463454] PM: Adding info for No Bus:input2
[   10.467820] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   10.475196] ACPI: Power Button [PWRF]
[   10.478854] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[   10.485622] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[   10.493003] bus: 'acpi': add driver fan
[   10.496847] bus: 'acpi': driver_probe_device: matched device PNP0C0B:00 with driver fan
[   10.504827] bus: 'acpi': really_probe: probing driver fan with device PNP0C0B:00
[   10.512256] device: 'cooling_device0': device_add
[   10.516951] PM: Adding info for No Bus:cooling_device0
[   10.522081] ACPI: Fan [FAN0] (off)
[   10.525467] driver: 'PNP0C0B:00': driver_bound: bound to device 'fan'
[   10.531884] bus: 'acpi': really_probe: bound device PNP0C0B:00 to driver fan
[   10.538906] bus: 'acpi': driver_probe_device: matched device PNP0C0B:01 with driver fan
[   10.546884] bus: 'acpi': really_probe: probing driver fan with device PNP0C0B:01
[   10.554275] device: 'cooling_device1': device_add
[   10.558965] PM: Adding info for No Bus:cooling_device1
[   10.564088] ACPI: Fan [FAN1] (off)
[   10.567468] driver: 'PNP0C0B:01': driver_bound: bound to device 'fan'
[   10.573891] bus: 'acpi': really_probe: bound device PNP0C0B:01 to driver fan
[   10.580912] bus: 'acpi': driver_probe_device: matched device PNP0C0B:02 with driver fan
[   10.588887] bus: 'acpi': really_probe: probing driver fan with device PNP0C0B:02
[   10.596275] device: 'cooling_device2': device_add
[   10.600965] PM: Adding info for No Bus:cooling_device2
[   10.606088] ACPI: Fan [FAN2] (off)
[   10.609475] driver: 'PNP0C0B:02': driver_bound: bound to device 'fan'
[   10.615891] bus: 'acpi': really_probe: bound device PNP0C0B:02 to driver fan
[   10.622914] bus: 'acpi': driver_probe_device: matched device PNP0C0B:03 with driver fan
[   10.630890] bus: 'acpi': really_probe: probing driver fan with device PNP0C0B:03
[   10.638278] device: 'cooling_device3': device_add
[   10.642967] PM: Adding info for No Bus:cooling_device3
[   10.648091] ACPI: Fan [FAN3] (off)
[   10.651470] driver: 'PNP0C0B:03': driver_bound: bound to device 'fan'
[   10.657893] bus: 'acpi': really_probe: bound device PNP0C0B:03 to driver fan
[   10.664914] bus: 'acpi': driver_probe_device: matched device PNP0C0B:04 with driver fan
[   10.672889] bus: 'acpi': really_probe: probing driver fan with device PNP0C0B:04
[   10.680277] device: 'cooling_device4': device_add
[   10.684966] PM: Adding info for No Bus:cooling_device4
[   10.690089] ACPI: Fan [FAN4] (off)
[   10.693476] driver: 'PNP0C0B:04': driver_bound: bound to device 'fan'
[   10.699892] bus: 'acpi': really_probe: bound device PNP0C0B:04 to driver fan
[   10.706918] ACPI: acpi_idle registered with cpuidle
[   10.711777] bus: 'acpi': add driver processor
[   10.716118] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[   10.724525] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[   10.732345] ACPI: processor limited to max C-state 1
[   10.737304] device: 'cooling_device5': device_add
[   10.741995] PM: Adding info for No Bus:cooling_device5
[   10.747118] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[   10.753968] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[   10.761424] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[   10.769832] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[   10.777643] device: 'cooling_device6': device_add
[   10.782333] PM: Adding info for No Bus:cooling_device6
[   10.787456] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[   10.794307] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[   10.801763] bus: 'acpi': driver_probe_device: matched device LNXCPU:02 with driver processor
[   10.810174] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:02
[   10.817988] device: 'cooling_device7': device_add
[   10.822678] PM: Adding info for No Bus:cooling_device7
[   10.827802] driver: 'LNXCPU:02': driver_bound: bound to device 'processor'
[   10.834652] bus: 'acpi': really_probe: bound device LNXCPU:02 to driver processor
[   10.842107] bus: 'acpi': driver_probe_device: matched device LNXCPU:03 with driver processor
[   10.850515] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:03
[   10.858324] driver: 'LNXCPU:03': driver_bound: bound to device 'processor'
[   10.865174] bus: 'acpi': really_probe: bound device LNXCPU:03 to driver processor
[   10.872669] bus: 'acpi': add driver container
[   10.877020] bus: 'acpi': driver_probe_device: matched device PNP0A06:00 with driver container
[   10.885513] bus: 'acpi': really_probe: probing driver container with device PNP0A06:00
[   10.893403] driver: 'PNP0A06:00': driver_bound: bound to device 'container'
[   10.900339] bus: 'acpi': really_probe: bound device PNP0A06:00 to driver container
[   11.136559] bus: 'acpi': add driver thermal
[   11.140763] bus: 'acpi': driver_probe_device: matched device LNXTHERM:00 with driver thermal
[   11.149171] bus: 'acpi': really_probe: probing driver thermal with device LNXTHERM:00
[   11.158052] device: 'thermal_zone0': device_add
[   11.162614] PM: Adding info for No Bus:thermal_zone0
[   11.167579] device: 'hwmon0': device_add
[   11.171492] PM: Adding info for No Bus:hwmon0
[   11.178764] thermal LNXTHERM:00: registered as thermal_zone0
[   11.184423] ACPI: Thermal Zone [CPUZ] (61 C)
[   11.188678] driver: 'LNXTHERM:00': driver_bound: bound to device 'thermal'
[   11.195528] bus: 'acpi': really_probe: bound device LNXTHERM:00 to driver thermal
[   11.202986] bus: 'acpi': driver_probe_device: matched device LNXTHERM:01 with driver thermal
[   11.211396] bus: 'acpi': really_probe: probing driver thermal with device LNXTHERM:01
[   11.224914] device: 'thermal_zone1': device_add
[   11.229482] PM: Adding info for No Bus:thermal_zone1
[   11.239603] thermal LNXTHERM:01: registered as thermal_zone1
[   11.245253] ACPI: Thermal Zone [TZ3] (30 C)
[   11.249423] driver: 'LNXTHERM:01': driver_bound: bound to device 'thermal'
[   11.256275] bus: 'acpi': really_probe: bound device LNXTHERM:01 to driver thermal
[   11.263767] device: 'ptmx': device_add
[   11.263834] bus: 'acpi': add driver battery
[   11.263862] bus: 'acpi': driver_probe_device: matched device PNP0C0A:00 with driver battery
[   11.263865] bus: 'acpi': really_probe: probing driver battery with device PNP0C0A:00
[   11.287756] PM: Adding info for No Bus:ptmx
[   11.289701] device: 'BAT0': device_add
[   11.289726] PM: Adding info for No Bus:BAT0
[   11.299834] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   11.306173] Registering platform device 'serial8250'. Parent at platform
[   11.312869] device: 'serial8250': device_add
[   11.317142] bus: 'platform': add device serial8250
[   11.320235] ACPI: Battery Slot [BAT0] (battery present)
[   11.320240] driver: 'PNP0C0A:00': driver_bound: bound to device 'battery'
[   11.320243] bus: 'acpi': really_probe: bound device PNP0C0A:00 to driver battery
[   11.320247] bus: 'acpi': driver_probe_device: matched device PNP0C0A:01 with driver battery
[   11.320249] bus: 'acpi': really_probe: probing driver battery with device PNP0C0A:01
[   11.320321] ACPI: Battery Slot [BAT1] (battery absent)
[   11.320323] driver: 'PNP0C0A:01': driver_bound: bound to device 'battery'
[   11.320325] bus: 'acpi': really_probe: bound device PNP0C0A:01 to driver battery
[   11.376537] PM: Adding info for platform:serial8250
[   11.401831] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   11.407819] device: 'ttyS0': device_add
[   11.411686] PM: Adding info for No Bus:ttyS0
[   11.448103] device: 'ttyS1': device_add
[   11.451992] PM: Adding info for No Bus:ttyS1
[   11.512102] device: 'ttyS2': device_add
[   11.515990] PM: Adding info for No Bus:ttyS2
[   11.576102] device: 'ttyS3': device_add
[   11.579994] PM: Adding info for No Bus:ttyS3
[   11.640086] bus: 'platform': add driver serial8250
[   11.644871] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[   11.653799] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[   11.662121] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[   11.669145] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[   11.677130] bus: 'pnp': add driver serial
[   11.681185] bus: 'pnp': driver_probe_device: matched device 00:09 with driver serial
[   11.688905] bus: 'pnp': really_probe: probing driver serial with device 00:09
[   11.696029] device: 'ttyS0': device_unregister
[   11.700455] PM: Removing info for No Bus:ttyS0
[   11.704954] device: 'ttyS0': device_create_release
[   11.730155] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   11.735710] device: 'ttyS0': device_add
[   11.739580] PM: Adding info for No Bus:ttyS0
[   11.804087] driver: '00:09': driver_bound: bound to device 'serial'
[   11.810335] bus: 'pnp': really_probe: bound device 00:09 to driver serial
[   11.817136] bus: 'pci': add driver serial
[   11.821193] device: 'hpet': device_add
[   11.824989] PM: Adding info for No Bus:hpet
[   11.829166] bus: 'acpi': add driver hpet
[   11.833088] bus: 'acpi': driver_probe_device: matched device PNP0103:00 with driver hpet
[   11.841151] bus: 'acpi': really_probe: probing driver hpet with device PNP0103:00
[   11.848725] device: 'nvram': device_add
[   11.852596] PM: Adding info for No Bus:nvram
[   11.856856] Non-volatile memory driver v1.3
[   11.861023] Linux agpgart interface v0.103
[   11.865104] bus: 'pci': add driver agpgart-intel
[   11.869729] device class 'scsi_disk': registering
[   11.874421] bus: 'scsi': add driver sd
[   11.878182] bus: 'scsi': add driver sr
[   11.881921] device class 'scsi_generic': registering
[   11.886878] bus: 'pci': add driver ahci
[   11.890703] bus: 'pci': driver_probe_device: matched device 0000:00:11.0 with driver ahci
[   11.898852] bus: 'pci': really_probe: probing driver ahci with device 0000:00:11.0
[   11.906398] ahci 0000:00:11.0: version 3.0
[   11.910487] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   11.917369] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 5 ports 6 Gbps 0x1f impl SATA mode
[   11.925520] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part sxs 
[   11.934107] device: 'ata1': device_add
[   11.937858] PM: Adding info for No Bus:ata1
[   11.942028] device: 'ata1': device_add
[   11.945767] PM: Adding info for No Bus:ata1
[   11.949945] device: 'link1': device_add
[   11.953776] PM: Adding info for No Bus:link1
[   11.958032] device: 'link1': device_add
[   11.961860] PM: Adding info for No Bus:link1
[   11.966120] device: 'dev1.0': device_add
[   11.970029] PM: Adding info for No Bus:dev1.0
[   11.974368] device: 'dev1.0': device_add
[   11.978280] PM: Adding info for No Bus:dev1.0
[   11.982627] device: 'ata2': device_add
[   11.986364] PM: Adding info for No Bus:ata2
[   11.990531] device: 'ata2': device_add
[   11.994269] PM: Adding info for No Bus:ata2
[   11.998441] device: 'link2': device_add
[   12.002263] PM: Adding info for No Bus:link2
[   12.006516] device: 'link2': device_add
[   12.010341] PM: Adding info for No Bus:link2
[   12.014600] device: 'dev2.0': device_add
[   12.018508] PM: Adding info for No Bus:dev2.0
[   12.022848] device: 'dev2.0': device_add
[   12.026758] PM: Adding info for No Bus:dev2.0
[   12.031104] device: 'ata3': device_add
[   12.034841] PM: Adding info for No Bus:ata3
[   12.039008] device: 'ata3': device_add
[   12.042748] PM: Adding info for No Bus:ata3
[   12.046920] device: 'link3': device_add
[   12.050742] PM: Adding info for No Bus:link3
[   12.054995] device: 'link3': device_add
[   12.058819] PM: Adding info for No Bus:link3
[   12.063078] device: 'dev3.0': device_add
[   12.066987] PM: Adding info for No Bus:dev3.0
[   12.071325] device: 'dev3.0': device_add
[   12.075239] PM: Adding info for No Bus:dev3.0
[   12.079585] device: 'ata4': device_add
[   12.083322] PM: Adding info for No Bus:ata4
[   12.087490] device: 'ata4': device_add
[   12.091228] PM: Adding info for No Bus:ata4
[   12.095400] device: 'link4': device_add
[   12.099222] PM: Adding info for No Bus:link4
[   12.103475] device: 'link4': device_add
[   12.107301] PM: Adding info for No Bus:link4
[   12.111560] device: 'dev4.0': device_add
[   12.115470] PM: Adding info for No Bus:dev4.0
[   12.119811] device: 'dev4.0': device_add
[   12.123722] PM: Adding info for No Bus:dev4.0
[   12.128068] device: 'ata5': device_add
[   12.131796] PM: Adding info for No Bus:ata5
[   12.135969] device: 'ata5': device_add
[   12.139708] PM: Adding info for No Bus:ata5
[   12.143880] device: 'link5': device_add
[   12.147703] PM: Adding info for No Bus:link5
[   12.151957] device: 'link5': device_add
[   12.155781] PM: Adding info for No Bus:link5
[   12.160040] device: 'dev5.0': device_add
[   12.163942] PM: Adding info for No Bus:dev5.0
[   12.168289] device: 'dev5.0': device_add
[   12.172199] PM: Adding info for No Bus:dev5.0
[   12.176626] scsi0 : ahci
[   12.179180] device: 'host0': device_add
[   12.183018] bus: 'scsi': add device host0
[   12.187017] PM: Adding info for scsi:host0
[   12.191109] device: 'host0': device_add
[   12.194943] PM: Adding info for No Bus:host0
[   12.199289] scsi1 : ahci
[   12.201816] device: 'host1': device_add
[   12.205641] bus: 'scsi': add device host1
[   12.209643] PM: Adding info for scsi:host1
[   12.213731] device: 'host1': device_add
[   12.217563] PM: Adding info for No Bus:host1
[   12.221907] scsi2 : ahci
[   12.224434] device: 'host2': device_add
[   12.228260] bus: 'scsi': add device host2
[   12.232257] PM: Adding info for scsi:host2
[   12.236344] device: 'host2': device_add
[   12.240181] PM: Adding info for No Bus:host2
[   12.244529] scsi3 : ahci
[   12.247048] device: 'host3': device_add
[   12.250881] bus: 'scsi': add device host3
[   12.254877] PM: Adding info for scsi:host3
[   12.258964] device: 'host3': device_add
[   12.262796] PM: Adding info for No Bus:host3
[   12.267141] scsi4 : ahci
[   12.269671] device: 'host4': device_add
[   12.273497] bus: 'scsi': add device host4
[   12.277495] PM: Adding info for scsi:host4
[   12.281582] device: 'host4': device_add
[   12.285417] PM: Adding info for No Bus:host4
[   12.289772] ata1: SATA max UDMA/133 abar m1024@0xd650b000 port 0xd650b100 irq 19
[   12.297144] ata2: SATA max UDMA/133 abar m1024@0xd650b000 port 0xd650b180 irq 19
[   12.304515] ata3: SATA max UDMA/133 abar m1024@0xd650b000 port 0xd650b200 irq 19
[   12.311885] ata4: SATA max UDMA/133 abar m1024@0xd650b000 port 0xd650b280 irq 19
[   12.319256] ata5: SATA max UDMA/133 abar m1024@0xd650b000 port 0xd650b300 irq 19
[   12.326635] driver: '0000:00:11.0': driver_bound: bound to device 'ahci'
[   12.326687] scsi host0: rpm_resume flags 0x4
[   12.326691] scsi host0: rpm_resume returns 1
[   12.326722] scsi host1: rpm_resume flags 0x4
[   12.326723] scsi host1: rpm_resume returns 1
[   12.326744] scsi host2: rpm_resume flags 0x4
[   12.326746] scsi host2: rpm_resume returns 1
[   12.326797] scsi host3: rpm_resume flags 0x4
[   12.326800] scsi host3: rpm_resume returns 1
[   12.326844] scsi host4: rpm_resume flags 0x4
[   12.326845] scsi host4: rpm_resume returns 1
[   12.375812] bus: 'pci': really_probe: bound device 0000:00:11.0 to driver ahci
[   12.383037] bus: 'pci': add driver ata_piix
[   12.387219] e1000e: Intel(R) PRO/1000 Network Driver - 1.4.4-k
[   12.393031] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[   12.398928] bus: 'pci': add driver e1000e
[   12.402935] sky2: driver version 1.29
[   12.406581] bus: 'pci': add driver sky2
[   12.410408] bus: 'pci': driver_probe_device: matched device 0000:02:00.0 with driver sky2
[   12.418557] bus: 'pci': really_probe: probing driver sky2 with device 0000:02:00.0
[   12.426144] sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.432984] sky2 0000:02:00.0: setting latency timer to 64
[   12.438545] sky2 0000:02:00.0: Yukon-2 Optima chip revision 1
[   13.150896] sky2 0000:02:00.0: irq 44 for MSI/MSI-X
[   13.155940] device: 'eth0': device_add
[   13.159718] PM: Adding info for No Bus:eth0
[   13.164102] sky2 0000:02:00.0: eth0: addr 1c:c1:de:91:f5:1c
[   13.169661] driver: '0000:02:00.0': driver_bound: bound to device 'sky2'
[   13.176344] bus: 'pci': really_probe: bound device 0000:02:00.0 to driver sky2
[   13.183666] bus: 'firewire': registered
[   13.187494] bus: 'pci': add driver firewire_ohci
[   13.192104] bus: 'pci': driver_probe_device: matched device 0000:03:00.3 with driver firewire_ohci
[   13.201031] bus: 'pci': really_probe: probing driver firewire_ohci with device 0000:03:00.3
[   13.209396] firewire_ohci 0000:03:00.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[   13.217000] firewire_ohci 0000:03:00.3: setting latency timer to 64
[   13.256144] ata3: SATA link down (SStatus 0 SControl 300)
[   13.261546] scsi host2: rpm_suspend flags 0x0
[   13.261599] ata5: SATA link down (SStatus 0 SControl 300)
[   13.261619] scsi host4: rpm_suspend flags 0x0
[   13.261622] scsi host4: rpm_suspend returns 0
[   13.261641] ata4: SATA link down (SStatus 0 SControl 300)
[   13.261661] scsi host3: rpm_suspend flags 0x0
[   13.261664] scsi host3: rpm_suspend returns 0
[   13.284108] firewire_ohci 0000:03:00.3: irq 45 for MSI/MSI-X
[   13.284156] firewire_ohci: Added fw-ohci device 0000:03:00.3, OHCI v1.10, 4 IR + 4 IT contexts, quirks 0x1
[   13.284159] driver: '0000:03:00.3': driver_bound: bound to device 'firewire_ohci'
[   13.284162] bus: 'pci': really_probe: bound device 0000:03:00.3 to driver firewire_ohci
[   13.284194] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   13.284197] bus: 'pci': add driver ehci_hcd
[   13.284203] bus: 'pci': driver_probe_device: matched device 0000:00:12.2 with driver ehci_hcd
[   13.284205] bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:12.2
[   13.284221] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   13.284246] ehci_hcd 0000:00:12.2: setting latency timer to 64
[   13.284249] ehci_hcd 0000:00:12.2: EHCI Host Controller
[   13.284273] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[   13.284284] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   13.284297] QUIRK: Enable AMD PLL fix
[   13.284313] ehci_hcd 0000:00:12.2: debug port 1
[   13.284324] ehci_hcd 0000:00:12.2: enabling Mem-Wr-Inval
[   13.284336] ehci_hcd 0000:00:12.2: irq 17, io mem 0xd6509000
[   13.296044] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[   13.296093] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   13.296095] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.296097] usb usb1: Product: EHCI Host Controller
[   13.296099] usb usb1: Manufacturer: Linux 3.1.0-rc4-git2-20110903.1332.58-kernel-linux-3_1 ehci_hcd
[   13.296101] usb usb1: SerialNumber: 0000:00:12.2
[   13.296103] device: 'usb1': device_add
[   13.296183] bus: 'usb': add device usb1
[   13.296195] PM: Adding info for usb:usb1
[   13.296210] bus: 'usb': driver_probe_device: matched device usb1 with driver usb
[   13.296212] bus: 'usb': really_probe: probing driver usb with device usb1
[   13.296221] device: '1-0:1.0': device_add
[   13.296228] bus: 'usb': add device 1-0:1.0
[   13.296231] PM: Adding info for usb:1-0:1.0
[   13.296240] bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
[   13.296242] bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
[   13.296246] hub 1-0:1.0: USB hub found
[   13.296249] hub 1-0:1.0: 5 ports detected
[   13.296272] driver: '1-0:1.0': driver_bound: bound to device 'hub'
[   13.296274] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
[   13.296277] hub 1-0:1.0: rpm_suspend flags 0x4
[   13.296279] hub 1-0:1.0: rpm_suspend returns 0
[   13.296282] device: 'ep_81': device_add
[   13.296289] PM: Adding info for No Bus:ep_81
[   13.296292] device: 'usbdev1.1': device_add
[   13.296336] PM: Adding info for No Bus:usbdev1.1
[   13.296348] driver: 'usb1': driver_bound: bound to device 'usb'
[   13.296350] bus: 'usb': really_probe: bound device usb1 to driver usb
[   13.296353] device: 'ep_00': device_add
[   13.296361] PM: Adding info for No Bus:ep_00
[   13.296363] usb usb1: rpm_suspend flags 0xc
[   13.296365] usb usb1: rpm_suspend returns -38
[   13.296386] driver: '0000:00:12.2': driver_bound: bound to device 'ehci_hcd'
[   13.296388] bus: 'pci': really_probe: bound device 0000:00:12.2 to driver ehci_hcd
[   13.296392] bus: 'pci': driver_probe_device: matched device 0000:00:13.2 with driver ehci_hcd
[   13.296394] bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:13.2
[   13.296409] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   13.296435] ehci_hcd 0000:00:13.2: setting latency timer to 64
[   13.296438] ehci_hcd 0000:00:13.2: EHCI Host Controller
[   13.296444] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[   13.296454] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   13.296478] ehci_hcd 0000:00:13.2: debug port 1
[   13.296489] ehci_hcd 0000:00:13.2: enabling Mem-Wr-Inval
[   13.296496] ehci_hcd 0000:00:13.2: irq 17, io mem 0xd6507000
[   13.308047] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[   13.308075] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   13.308077] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.308079] usb usb2: Product: EHCI Host Controller
[   13.308081] usb usb2: Manufacturer: Linux 3.1.0-rc4-git2-20110903.1332.58-kernel-linux-3_1 ehci_hcd
[   13.308083] usb usb2: SerialNumber: 0000:00:13.2
[   13.308085] device: 'usb2': device_add
[   13.308153] bus: 'usb': add device usb2
[   13.308165] PM: Adding info for usb:usb2
[   13.308180] bus: 'usb': driver_probe_device: matched device usb2 with driver usb
[   13.308182] bus: 'usb': really_probe: probing driver usb with device usb2
[   13.308192] device: '2-0:1.0': device_add
[   13.308197] bus: 'usb': add device 2-0:1.0
[   13.308199] PM: Adding info for usb:2-0:1.0
[   13.308208] bus: 'usb': driver_probe_device: matched device 2-0:1.0 with driver hub
[   13.308210] bus: 'usb': really_probe: probing driver hub with device 2-0:1.0
[   13.308214] hub 2-0:1.0: USB hub found
[   13.308217] hub 2-0:1.0: 5 ports detected
[   13.308239] driver: '2-0:1.0': driver_bound: bound to device 'hub'
[   13.308241] bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub
[   13.308244] hub 2-0:1.0: rpm_suspend flags 0x4
[   13.308246] hub 2-0:1.0: rpm_suspend returns 0
[   13.308249] device: 'ep_81': device_add
[   13.308255] PM: Adding info for No Bus:ep_81
[   13.308259] device: 'usbdev2.1': device_add
[   13.308303] PM: Adding info for No Bus:usbdev2.1
[   13.308315] driver: 'usb2': driver_bound: bound to device 'usb'
[   13.308317] bus: 'usb': really_probe: bound device usb2 to driver usb
[   13.308320] device: 'ep_00': device_add
[   13.308327] PM: Adding info for No Bus:ep_00
[   13.308329] usb usb2: rpm_suspend flags 0xc
[   13.308331] usb usb2: rpm_suspend returns -38
[   13.308351] driver: '0000:00:13.2': driver_bound: bound to device 'ehci_hcd'
[   13.308354] bus: 'pci': really_probe: bound device 0000:00:13.2 to driver ehci_hcd
[   13.308357] bus: 'pci': driver_probe_device: matched device 0000:00:16.2 with driver ehci_hcd
[   13.308359] bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:16.2
[   13.308374] ehci_hcd 0000:00:16.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   13.308400] ehci_hcd 0000:00:16.2: setting latency timer to 64
[   13.308404] ehci_hcd 0000:00:16.2: EHCI Host Controller
[   13.308410] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 3
[   13.308420] ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[   13.308443] ehci_hcd 0000:00:16.2: debug port 1
[   13.308454] ehci_hcd 0000:00:16.2: enabling Mem-Wr-Inval
[   13.308462] ehci_hcd 0000:00:16.2: irq 17, io mem 0xd6504000
[   13.320048] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[   13.320072] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[   13.320074] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.320076] usb usb3: Product: EHCI Host Controller
[   13.320078] usb usb3: Manufacturer: Linux 3.1.0-rc4-git2-20110903.1332.58-kernel-linux-3_1 ehci_hcd
[   13.320080] usb usb3: SerialNumber: 0000:00:16.2
[   13.320082] device: 'usb3': device_add
[   13.320153] bus: 'usb': add device usb3
[   13.320164] PM: Adding info for usb:usb3
[   13.320179] bus: 'usb': driver_probe_device: matched device usb3 with driver usb
[   13.320181] bus: 'usb': really_probe: probing driver usb with device usb3
[   13.320190] device: '3-0:1.0': device_add
[   13.320195] bus: 'usb': add device 3-0:1.0
[   13.320198] PM: Adding info for usb:3-0:1.0
[   13.320206] bus: 'usb': driver_probe_device: matched device 3-0:1.0 with driver hub
[   13.320208] bus: 'usb': really_probe: probing driver hub with device 3-0:1.0
[   13.320212] hub 3-0:1.0: USB hub found
[   13.320215] hub 3-0:1.0: 4 ports detected
[   13.320233] driver: '3-0:1.0': driver_bound: bound to device 'hub'
[   13.320235] bus: 'usb': really_probe: bound device 3-0:1.0 to driver hub
[   13.320238] hub 3-0:1.0: rpm_suspend flags 0x4
[   13.320240] hub 3-0:1.0: rpm_suspend returns 0
[   13.320243] device: 'ep_81': device_add
[   13.320251] PM: Adding info for No Bus:ep_81
[   13.320254] device: 'usbdev3.1': device_add
[   13.320297] PM: Adding info for No Bus:usbdev3.1
[   13.320309] driver: 'usb3': driver_bound: bound to device 'usb'
[   13.320311] bus: 'usb': really_probe: bound device usb3 to driver usb
[   13.320313] device: 'ep_00': device_add
[   13.320320] PM: Adding info for No Bus:ep_00
[   13.320322] usb usb3: rpm_suspend flags 0xc
[   13.320324] usb usb3: rpm_suspend returns -38
[   13.320344] driver: '0000:00:16.2': driver_bound: bound to device 'ehci_hcd'
[   13.320346] bus: 'pci': really_probe: bound device 0000:00:16.2 to driver ehci_hcd
[   13.320361] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   13.320364] bus: 'pci': add driver ohci_hcd
[   13.320368] bus: 'pci': driver_probe_device: matched device 0000:00:12.0 with driver ohci_hcd
[   13.320370] bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:12.0
[   13.320388] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   13.320412] ohci_hcd 0000:00:12.0: setting latency timer to 64
[   13.320415] ohci_hcd 0000:00:12.0: OHCI Host Controller
[   13.320423] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 4
[   13.320452] ohci_hcd 0000:00:12.0: irq 18, io mem 0xd650a000
[   13.380083] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   13.380086] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.380089] usb usb4: Product: OHCI Host Controller
[   13.380090] usb usb4: Manufacturer: Linux 3.1.0-rc4-git2-20110903.1332.58-kernel-linux-3_1 ohci_hcd
[   13.380092] usb usb4: SerialNumber: 0000:00:12.0
[   13.380094] device: 'usb4': device_add
[   13.380174] bus: 'usb': add device usb4
[   13.380185] PM: Adding info for usb:usb4
[   13.380200] bus: 'usb': driver_probe_device: matched device usb4 with driver usb
[   13.380202] bus: 'usb': really_probe: probing driver usb with device usb4
[   13.380211] device: '4-0:1.0': device_add
[   13.380218] bus: 'usb': add device 4-0:1.0
[   13.380220] PM: Adding info for usb:4-0:1.0
[   13.380229] bus: 'usb': driver_probe_device: matched device 4-0:1.0 with driver hub
[   13.380231] bus: 'usb': really_probe: probing driver hub with device 4-0:1.0
[   13.380235] hub 4-0:1.0: USB hub found
[   13.380242] hub 4-0:1.0: 5 ports detected
[   13.380250] driver: '4-0:1.0': driver_bound: bound to device 'hub'
[   13.380252] bus: 'usb': really_probe: bound device 4-0:1.0 to driver hub
[   13.380255] hub 4-0:1.0: rpm_suspend flags 0x4
[   13.380257] hub 4-0:1.0: rpm_suspend returns 0
[   13.380260] device: 'ep_81': device_add
[   13.380267] PM: Adding info for No Bus:ep_81
[   13.380270] device: 'usbdev4.1': device_add
[   13.380314] PM: Adding info for No Bus:usbdev4.1
[   13.380326] driver: 'usb4': driver_bound: bound to device 'usb'
[   13.380328] bus: 'usb': really_probe: bound device usb4 to driver usb
[   13.380331] device: 'ep_00': device_add
[   13.380339] PM: Adding info for No Bus:ep_00
[   13.380341] usb usb4: rpm_suspend flags 0xc
[   13.380343] usb usb4: rpm_suspend returns -38
[   13.380383] driver: '0000:00:12.0': driver_bound: bound to device 'ohci_hcd'
[   13.380386] bus: 'pci': really_probe: bound device 0000:00:12.0 to driver ohci_hcd
[   13.380389] bus: 'pci': driver_probe_device: matched device 0000:00:13.0 with driver ohci_hcd
[   13.380391] bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:13.0
[   13.380405] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   13.380430] ohci_hcd 0000:00:13.0: setting latency timer to 64
[   13.380433] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   13.380439] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[   13.380458] ohci_hcd 0000:00:13.0: irq 18, io mem 0xd6508000
[   13.428069] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   13.432069] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   13.432641] ata1.00: ATA-8: WDC WD7500BPVT-00HXZT1, 01.01A01, max UDMA/133
[   13.432645] ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[   13.437646] ata1.00: configured for UDMA/133
[   13.437657] scsi host0: rpm_suspend flags 0x0
[   13.437660] scsi host0: rpm_suspend returns 0
[   13.440662] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   13.440665] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.440667] usb usb5: Product: OHCI Host Controller
[   13.440669] usb usb5: Manufacturer: Linux 3.1.0-rc4-git2-20110903.1332.58-kernel-linux-3_1 ohci_hcd
[   13.440671] usb usb5: SerialNumber: 0000:00:13.0
[   13.440673] device: 'usb5': device_add
[   13.440756] bus: 'usb': add device usb5
[   13.440768] PM: Adding info for usb:usb5
[   13.440784] bus: 'usb': driver_probe_device: matched device usb5 with driver usb
[   13.440786] bus: 'usb': really_probe: probing driver usb with device usb5
[   13.440796] device: '5-0:1.0': device_add
[   13.440805] bus: 'usb': add device 5-0:1.0
[   13.440807] PM: Adding info for usb:5-0:1.0
[   13.440817] bus: 'usb': driver_probe_device: matched device 5-0:1.0 with driver hub
[   13.440819] bus: 'usb': really_probe: probing driver hub with device 5-0:1.0
[   13.440823] hub 5-0:1.0: USB hub found
[   13.440831] hub 5-0:1.0: 5 ports detected
[   13.440840] driver: '5-0:1.0': driver_bound: bound to device 'hub'
[   13.440842] bus: 'usb': really_probe: bound device 5-0:1.0 to driver hub
[   13.440845] hub 5-0:1.0: rpm_suspend flags 0x4
[   13.440847] hub 5-0:1.0: rpm_suspend returns 0
[   13.440849] device: 'ep_81': device_add
[   13.440857] PM: Adding info for No Bus:ep_81
[   13.440860] device: 'usbdev5.1': device_add
[   13.440905] PM: Adding info for No Bus:usbdev5.1
[   13.440918] driver: 'usb5': driver_bound: bound to device 'usb'
[   13.440920] bus: 'usb': really_probe: bound device usb5 to driver usb
[   13.440923] device: 'ep_00': device_add
[   13.440931] PM: Adding info for No Bus:ep_00
[   13.440933] usb usb5: rpm_suspend flags 0xc
[   13.440935] usb usb5: rpm_suspend returns -38
[   13.440978] driver: '0000:00:13.0': driver_bound: bound to device 'ohci_hcd'
[   13.440982] bus: 'pci': really_probe: bound device 0000:00:13.0 to driver ohci_hcd
[   13.440985] bus: 'pci': driver_probe_device: matched device 0000:00:14.5 with driver ohci_hcd
[   13.440987] bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:14.5
[   13.441001] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   13.441026] ohci_hcd 0000:00:14.5: setting latency timer to 64
[   13.441030] ohci_hcd 0000:00:14.5: OHCI Host Controller
[   13.441036] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 6
[   13.441060] ohci_hcd 0000:00:14.5: irq 18, io mem 0xd6506000
[   13.442863] ata2.00: ATAPI: hp      DVD RW AD-7586H, KH04, max UDMA/100
[   13.452909] ata2.00: configured for UDMA/100
[   13.453360] scsi host1: rpm_suspend flags 0x0
[   13.453364] scsi host1: rpm_suspend returns 0
[   13.500063] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   13.500066] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.500124] usb usb6: Product: OHCI Host Controller
[   13.500126] usb usb6: Manufacturer: Linux 3.1.0-rc4-git2-20110903.1332.58-kernel-linux-3_1 ohci_hcd
[   13.500128] usb usb6: SerialNumber: 0000:00:14.5
[   13.500130] device: 'usb6': device_add
[   13.500188] bus: 'usb': add device usb6
[   13.500201] PM: Adding info for usb:usb6
[   13.500217] bus: 'usb': driver_probe_device: matched device usb6 with driver usb
[   13.500219] bus: 'usb': really_probe: probing driver usb with device usb6
[   13.500229] device: '6-0:1.0': device_add
[   13.500235] bus: 'usb': add device 6-0:1.0
[   13.500237] PM: Adding info for usb:6-0:1.0
[   13.500247] bus: 'usb': driver_probe_device: matched device 6-0:1.0 with driver hub
[   13.500248] bus: 'usb': really_probe: probing driver hub with device 6-0:1.0
[   13.500253] hub 6-0:1.0: USB hub found
[   13.500260] hub 6-0:1.0: 2 ports detected
[   13.500268] driver: '6-0:1.0': driver_bound: bound to device 'hub'
[   13.500269] bus: 'usb': really_probe: bound device 6-0:1.0 to driver hub
[   13.500272] hub 6-0:1.0: rpm_suspend flags 0x4
[   13.500274] hub 6-0:1.0: rpm_suspend returns 0
[   13.500277] device: 'ep_81': device_add
[   13.500285] PM: Adding info for No Bus:ep_81
[   13.500288] device: 'usbdev6.1': device_add
[   13.500334] PM: Adding info for No Bus:usbdev6.1
[   13.500346] driver: 'usb6': driver_bound: bound to device 'usb'
[   13.500348] bus: 'usb': really_probe: bound device usb6 to driver usb
[   13.500351] device: 'ep_00': device_add
[   13.500358] PM: Adding info for No Bus:ep_00
[   13.500360] usb usb6: rpm_suspend flags 0xc
[   13.500362] usb usb6: rpm_suspend returns -38
[   13.500396] driver: '0000:00:14.5': driver_bound: bound to device 'ohci_hcd'
[   13.500398] bus: 'pci': really_probe: bound device 0000:00:14.5 to driver ohci_hcd
[   13.500401] bus: 'pci': driver_probe_device: matched device 0000:00:16.0 with driver ohci_hcd
[   13.500403] bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:16.0
[   13.500417] ohci_hcd 0000:00:16.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   13.500442] ohci_hcd 0000:00:16.0: setting latency timer to 64
[   13.500445] ohci_hcd 0000:00:16.0: OHCI Host Controller
[   13.500452] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 7
[   13.500474] ohci_hcd 0000:00:16.0: irq 18, io mem 0xd6505000
[   13.560058] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   13.560061] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.560063] usb usb7: Product: OHCI Host Controller
[   13.560065] usb usb7: Manufacturer: Linux 3.1.0-rc4-git2-20110903.1332.58-kernel-linux-3_1 ohci_hcd
[   13.560067] usb usb7: SerialNumber: 0000:00:16.0
[   13.560069] device: 'usb7': device_add
[   13.560131] bus: 'usb': add device usb7
[   13.560143] PM: Adding info for usb:usb7
[   13.560161] bus: 'usb': driver_probe_device: matched device usb7 with driver usb
[   13.560163] bus: 'usb': really_probe: probing driver usb with device usb7
[   13.560173] device: '7-0:1.0': device_add
[   13.560179] bus: 'usb': add device 7-0:1.0
[   13.560182] PM: Adding info for usb:7-0:1.0
[   13.560191] bus: 'usb': driver_probe_device: matched device 7-0:1.0 with driver hub
[   13.560193] bus: 'usb': really_probe: probing driver hub with device 7-0:1.0
[   13.560196] hub 7-0:1.0: USB hub found
[   13.560205] hub 7-0:1.0: 4 ports detected
[   13.560214] driver: '7-0:1.0': driver_bound: bound to device 'hub'
[   13.560216] bus: 'usb': really_probe: bound device 7-0:1.0 to driver hub
[   13.560218] hub 7-0:1.0: rpm_suspend flags 0x4
[   13.560221] hub 7-0:1.0: rpm_suspend returns 0
[   13.560223] device: 'ep_81': device_add
[   13.560231] PM: Adding info for No Bus:ep_81
[   13.560234] device: 'usbdev7.1': device_add
[   13.560279] PM: Adding info for No Bus:usbdev7.1
[   13.560291] driver: 'usb7': driver_bound: bound to device 'usb'
[   13.560292] bus: 'usb': really_probe: bound device usb7 to driver usb
[   13.560295] device: 'ep_00': device_add
[   13.560302] PM: Adding info for No Bus:ep_00
[   13.560304] usb usb7: rpm_suspend flags 0xc
[   13.560306] usb usb7: rpm_suspend returns -38
[   13.560343] driver: '0000:00:16.0': driver_bound: bound to device 'ohci_hcd'
[   13.560345] bus: 'pci': really_probe: bound device 0000:00:16.0 to driver ohci_hcd
[   13.560361] bus: 'pnp': add driver i8042 kbd
[   13.560375] bus: 'pnp': driver_probe_device: matched device 00:0a with driver i8042 kbd
[   13.560377] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:0a
[   13.560381] driver: '00:0a': driver_bound: bound to device 'i8042 kbd'
[   13.560383] bus: 'pnp': really_probe: bound device 00:0a to driver i8042 kbd
[   13.560391] bus: 'pnp': add driver i8042 aux
[   13.560401] bus: 'pnp': driver_probe_device: matched device 00:0b with driver i8042 aux
[   13.560403] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:0b
[   13.560407] driver: '00:0b': driver_bound: bound to device 'i8042 aux'
[   13.560409] bus: 'pnp': really_probe: bound device 00:0b to driver i8042 aux
[   13.560415] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   13.560434] Registering platform device 'i8042'. Parent at platform
[   13.560436] device: 'i8042': device_add
[   13.560440] bus: 'platform': add device i8042
[   13.560444] PM: Adding info for platform:i8042
[   13.560451] bus: 'platform': add driver i8042
[   13.560455] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   13.560457] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   13.562188] i8042: Detected active multiplexing controller, rev 1.1
[   13.562969] serio: i8042 KBD port at 0x60,0x64 irq 1
[   13.562974] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   13.562976] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   13.562979] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   13.562981] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   13.562983] driver: 'i8042': driver_bound: bound to device 'i8042'
[   13.562984] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   13.562991] device: 'mice': device_add
[   13.563008] device: 'serio0': device_add
[   13.563012] bus: 'serio': add device serio0
[   13.563017] PM: Adding info for serio:serio0
[   13.563026] device: 'serio1': device_add
[   13.563029] bus: 'serio': add device serio1
[   13.563036] PM: Adding info for serio:serio1
[   13.563043] device: 'serio2': device_add
[   13.563046] bus: 'serio': add device serio2
[   13.563051] PM: Adding info for serio:serio2
[   13.563057] device: 'serio3': device_add
[   13.563060] bus: 'serio': add device serio3
[   13.563065] PM: Adding info for serio:serio3
[   13.563071] device: 'serio4': device_add
[   13.563075] bus: 'serio': add device serio4
[   13.563080] PM: Adding info for serio:serio4
[   13.563090] PM: Adding info for No Bus:mice
[   13.563097] mousedev: PS/2 mouse device common for all mice
[   13.563101] device: 'event0': device_add
[   13.563146] PM: Adding info for No Bus:event0
[   13.563154] device: 'event1': device_add
[   13.563171] PM: Adding info for No Bus:event1
[   13.563179] device: 'event2': device_add
[   13.563196] PM: Adding info for No Bus:event2
[   13.563206] bus: 'serio': add driver atkbd
[   13.563220] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   13.563222] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   13.563250] bus: 'serio': add driver psmouse
[   13.563281] bus: 'platform': add driver pcspkr
[   13.563285] bus: 'platform': driver_probe_device: matched device pcspkr with driver pcspkr
[   13.563287] bus: 'platform': really_probe: probing driver pcspkr with device pcspkr
[   13.563295] device: 'input3': device_add
[   13.563315] PM: Adding info for No Bus:input3
[   13.563332] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   13.563338] device: 'event3': device_add
[   13.563395] PM: Adding info for No Bus:event3
[   13.563402] driver: 'pcspkr': driver_bound: bound to device 'pcspkr'
[   13.563404] bus: 'platform': really_probe: bound device pcspkr to driver pcspkr
[   13.563412] bus: 'pnp': add driver rtc_cmos
[   13.563419] bus: 'pnp': driver_probe_device: matched device 00:07 with driver rtc_cmos
[   13.563421] bus: 'pnp': really_probe: probing driver rtc_cmos with device 00:07
[   13.563442] rtc_cmos 00:07: RTC can wake from S4
[   13.563523] device: 'rtc0': device_add
[   13.563570] PM: Adding info for No Bus:rtc0
[   13.563581] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   13.563614] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[   13.563616] driver: '00:07': driver_bound: bound to device 'rtc_cmos'
[   13.563618] bus: 'pnp': really_probe: bound device 00:07 to driver rtc_cmos
[   13.563701] device-mapper: uevent: version 1.0.3
[   13.563741] device: 'device-mapper': device_add
[   13.563794] PM: Adding info for No Bus:device-mapper
[   13.563801] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[   13.563836] cpuidle: using governor ladder
[   13.563837] cpuidle: using governor menu
[   13.563912] bus: 'hid': registered
[   13.563915] device class 'hidraw': registering
[   13.563922] bus: 'hid': add driver a4tech
[   13.563929] bus: 'hid': add driver apple
[   13.563937] bus: 'hid': add driver belkin
[   13.563943] bus: 'hid': add driver cherry
[   13.563948] bus: 'hid': add driver chicony
[   13.563954] bus: 'hid': add driver cypress
[   13.563960] bus: 'hid': add driver ezkey
[   13.563965] bus: 'hid': add driver kensington
[   13.563971] bus: 'hid': add driver kye
[   13.563978] bus: 'hid': add driver logitech
[   13.563984] bus: 'hid': add driver microsoft
[   13.563989] bus: 'hid': add driver monterey
[   13.563995] bus: 'hid': add driver generic-usb
[   13.564019] bus: 'usb': add driver usbhid
[   13.564032] usbcore: registered new interface driver usbhid
[   13.564033] usbhid: USB HID core driver
[   13.564067] TCP cubic registered
[   13.564069] NET: Registered protocol family 17
[   13.564081] Registering the dns_resolver key type
[   13.564101] device: 'cpu_dma_latency': device_add
[   13.564144] PM: Adding info for No Bus:cpu_dma_latency
[   13.564151] device: 'network_latency': device_add
[   13.564168] PM: Adding info for No Bus:network_latency
[   13.564175] device: 'network_throughput': device_add
[   13.564201] PM: Adding info for No Bus:network_throughput
[   13.585050] device: 'input4': device_add
[   13.585076] PM: Adding info for No Bus:input4
[   13.585104] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[   13.585113] device: 'event4': device_add
[   13.585168] PM: Adding info for No Bus:event4
[   13.585175] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   13.585178] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[   13.585183] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[   13.585185] bus: 'serio': really_probe: probing driver atkbd with device serio1
[   13.589015] bus: 'serio': driver_probe_device: matched device serio2 with driver atkbd
[   13.589020] bus: 'serio': really_probe: probing driver atkbd with device serio2
[   13.591001] bus: 'serio': driver_probe_device: matched device serio3 with driver atkbd
[   13.591005] bus: 'serio': really_probe: probing driver atkbd with device serio3
[   13.592989] bus: 'serio': driver_probe_device: matched device serio4 with driver atkbd
[   13.592993] bus: 'serio': really_probe: probing driver atkbd with device serio4
[   13.597112] bus: 'serio': driver_probe_device: matched device serio1 with driver psmouse
[   13.597116] bus: 'serio': really_probe: probing driver psmouse with device serio1
[   13.597991] bus: 'serio': driver_probe_device: matched device serio2 with driver psmouse
[   13.597995] bus: 'serio': really_probe: probing driver psmouse with device serio2
[   13.598956] bus: 'serio': driver_probe_device: matched device serio3 with driver psmouse
[   13.598961] bus: 'serio': really_probe: probing driver psmouse with device serio3
[   13.599975] bus: 'serio': driver_probe_device: matched device serio4 with driver psmouse
[   13.599979] bus: 'serio': really_probe: probing driver psmouse with device serio4
[   13.680048] usb 1-5: new high speed USB device number 3 using ehci_hcd
[   13.856185] usb 1-5: New USB device found, idVendor=0461, idProduct=4db6
[   13.856188] usb 1-5: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[   13.856190] usb 1-5: Product: Villem
[   13.856192] usb 1-5: Manufacturer: Primax Electronics Ltd.
[   13.856194] usb 1-5: SerialNumber: PMX01
[   13.856196] device: '1-5': device_add
[   13.856271] bus: 'usb': add device 1-5
[   13.856279] PM: Adding info for usb:1-5
[   13.856295] bus: 'usb': driver_probe_device: matched device 1-5 with driver usb
[   13.856297] bus: 'usb': really_probe: probing driver usb with device 1-5
[   13.856690] device: '1-5:1.0': device_add
[   13.856706] bus: 'usb': add device 1-5:1.0
[   13.856712] PM: Adding info for usb:1-5:1.0
[   13.859207] device: 'ep_83': device_add
[   13.859219] PM: Adding info for No Bus:ep_83
[   13.859221] device: '1-5:1.1': device_add
[   13.859233] bus: 'usb': add device 1-5:1.1
[   13.859238] PM: Adding info for usb:1-5:1.1
[   13.861708] device: 'usbdev1.3': device_add
[   13.861770] PM: Adding info for No Bus:usbdev1.3
[   13.861784] driver: '1-5': driver_bound: bound to device 'usb'
[   13.861786] bus: 'usb': really_probe: bound device 1-5 to driver usb
[   13.861789] device: 'ep_00': device_add
[   13.861797] PM: Adding info for No Bus:ep_00
[   13.861800] usb 1-5: rpm_suspend flags 0xc
[   13.861802] usb 1-5: rpm_suspend returns -38
[   14.144050] usb 4-3: new low speed USB device number 2 using ohci_hcd
[   14.323117] usb 4-3: New USB device found, idVendor=093a, idProduct=2510
[   14.323120] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   14.323122] usb 4-3: Product: USB Optical Mouse
[   14.323124] usb 4-3: Manufacturer: PixArt
[   14.323126] device: '4-3': device_add
[   14.323201] bus: 'usb': add device 4-3
[   14.323209] PM: Adding info for usb:4-3
[   14.323226] bus: 'usb': driver_probe_device: matched device 4-3 with driver usb
[   14.323228] bus: 'usb': really_probe: probing driver usb with device 4-3
[   14.325128] device: '4-3:1.0': device_add
[   14.325147] bus: 'usb': add device 4-3:1.0
[   14.325153] PM: Adding info for usb:4-3:1.0
[   14.325169] bus: 'usb': driver_probe_device: matched device 4-3:1.0 with driver usbhid
[   14.325171] bus: 'usb': really_probe: probing driver usbhid with device 4-3:1.0
[   14.325187] device: '0003:093A:2510.0001': device_add
[   14.325190] bus: 'hid': add device 0003:093A:2510.0001
[   14.325195] PM: Adding info for hid:0003:093A:2510.0001
[   14.325208] bus: 'hid': driver_probe_device: matched device 0003:093A:2510.0001 with driver generic-usb
[   14.325210] bus: 'hid': really_probe: probing driver generic-usb with device 0003:093A:2510.0001
[   14.330241] device: 'input5': device_add
[   14.330267] PM: Adding info for No Bus:input5
[   14.330291] input: PixArt USB Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb4/4-3/4-3:1.0/input/input5
[   14.330296] device: 'mouse0': device_add
[   14.330350] PM: Adding info for No Bus:mouse0
[   14.330358] device: 'event5': device_add
[   14.330375] PM: Adding info for No Bus:event5
[   14.330384] device: 'hidraw0': device_add
[   14.330401] PM: Adding info for No Bus:hidraw0
[   14.330410] generic-usb 0003:093A:2510.0001: input,hidraw0: USB HID v1.11 Mouse [PixArt USB Optical Mouse] on usb-0000:00:12.0-3/input0
[   14.330413] driver: '0003:093A:2510.0001': driver_bound: bound to device 'generic-usb'
[   14.330416] bus: 'hid': really_probe: bound device 0003:093A:2510.0001 to driver generic-usb
[   14.330420] driver: '4-3:1.0': driver_bound: bound to device 'usbhid'
[   14.330422] bus: 'usb': really_probe: bound device 4-3:1.0 to driver usbhid
[   14.330425] usbhid 4-3:1.0: rpm_suspend flags 0x4
[   14.330427] usbhid 4-3:1.0: rpm_suspend returns 0
[   14.330430] device: 'ep_81': device_add
[   14.330438] PM: Adding info for No Bus:ep_81
[   14.330441] device: 'usbdev4.2': device_add
[   14.330483] PM: Adding info for No Bus:usbdev4.2
[   14.330497] driver: '4-3': driver_bound: bound to device 'usb'
[   14.330499] bus: 'usb': really_probe: bound device 4-3 to driver usb
[   14.330502] device: 'ep_00': device_add
[   14.330509] PM: Adding info for No Bus:ep_00
[   14.330510] usb 4-3: rpm_suspend flags 0xc
[   14.330513] usb 4-3: rpm_suspend returns -38
[   14.385791] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1c0b1, caps: 0xd04773/0xa40000/0xa0400
[   14.429263] device: 'input6': device_add
[   14.429293] PM: Adding info for No Bus:input6
[   14.429317] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input6
[   14.429322] device: 'mouse1': device_add
[   14.429377] PM: Adding info for No Bus:mouse1
[   14.429385] device: 'event6': device_add
[   14.429401] PM: Adding info for No Bus:event6
[   14.432416] driver: 'serio4': driver_bound: bound to device 'psmouse'
[   14.432421] bus: 'serio': really_probe: bound device serio4 to driver psmouse
[   14.468053] usb 6-2: new full speed USB device number 2 using ohci_hcd
[   14.645122] usb 6-2: New USB device found, idVendor=138a, idProduct=0007
[   14.645125] usb 6-2: New USB device strings: Mfr=0, Product=0, SerialNumber=1
[   14.645128] usb 6-2: SerialNumber: 21132ee7cc00
[   14.645130] device: '6-2': device_add
[   14.645203] bus: 'usb': add device 6-2
[   14.645211] PM: Adding info for usb:6-2
[   14.645228] bus: 'usb': driver_probe_device: matched device 6-2 with driver usb
[   14.645230] bus: 'usb': really_probe: probing driver usb with device 6-2
[   14.647130] device: '6-2:1.0': device_add
[   14.647140] bus: 'usb': add device 6-2:1.0
[   14.647146] PM: Adding info for usb:6-2:1.0
[   14.647164] device: 'ep_01': device_add
[   14.647175] PM: Adding info for No Bus:ep_01
[   14.647177] device: 'ep_81': device_add
[   14.647184] PM: Adding info for No Bus:ep_81
[   14.647186] device: 'ep_82': device_add
[   14.647192] PM: Adding info for No Bus:ep_82
[   14.647194] device: 'ep_83': device_add
[   14.647201] PM: Adding info for No Bus:ep_83
[   14.647205] device: 'usbdev6.2': device_add
[   14.647251] PM: Adding info for No Bus:usbdev6.2
[   14.647264] driver: '6-2': driver_bound: bound to device 'usb'
[   14.647266] bus: 'usb': really_probe: bound device 6-2 to driver usb
[   14.647270] device: 'ep_00': device_add
[   14.647276] PM: Adding info for No Bus:ep_00
[   14.647279] usb 6-2: rpm_suspend flags 0xc
[   14.647281] usb 6-2: rpm_suspend returns -38
[   16.307019] scsi host2: rpm_suspend returns 0
[   16.307031] scsi target0:0:0: rpm_resume flags 0x4
[   16.307034] scsi target0:0:0: rpm_resume returns -13
[   16.307037] scsi host0: rpm_resume flags 0x4
[   16.307039] ahci 0000:00:11.0: rpm_resume flags 0x0
[   16.307041] ahci 0000:00:11.0: rpm_resume returns 1
[   16.307044] scsi host0: rpm_resume returns 0
[   16.307188] scsi 0:0:0:0: Direct-Access     ATA      WDC WD7500BPVT-0 01.0 PQ: 0 ANSI: 5
[   16.307194] device: 'target0:0:0': device_add
[   16.307201] bus: 'scsi': add device target0:0:0
[   16.307209] PM: Adding info for scsi:target0:0:0
[   16.307222] scsi target0:0:0: rpm_resume flags 0x4
[   16.307224] scsi target0:0:0: rpm_resume returns 1
[   16.307227] scsi 0:0:0:0: rpm_resume flags 0x0
[   16.307228] scsi 0:0:0:0: rpm_resume returns -13
[   16.307230] scsi 0:0:0:0: rpm_resume flags 0x4
[   16.307232] scsi 0:0:0:0: rpm_resume returns 1
[   16.307233] device: '0:0:0:0': device_add
[   16.307244] bus: 'scsi': add device 0:0:0:0
[   16.307248] PM: Adding info for scsi:0:0:0:0
[   16.307254] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sd
[   16.307256] bus: 'scsi': really_probe: probing driver sd with device 0:0:0:0
[   16.307269] device: '0:0:0:0': device_add
[   16.307280] PM: Adding info for No Bus:0:0:0:0
[   16.307294] driver: '0:0:0:0': driver_bound: bound to device 'sd'
[   16.307296] bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
[   16.307299] device: '0:0:0:0': device_add
[   16.307307] PM: Adding info for No Bus:0:0:0:0
[   16.307322] device: 'sg0': device_add
[   16.307369] PM: Adding info for No Bus:sg0
[   16.307387] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   16.307397] device: '0:0:0:0': device_add
[   16.307469] PM: Adding info for No Bus:0:0:0:0
[   16.307475] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[   16.307493] scsi target1:0:0: rpm_resume flags 0x4
[   16.307495] scsi target1:0:0: rpm_resume returns -13
[   16.307498] scsi host1: rpm_resume flags 0x4
[   16.307500] ahci 0000:00:11.0: rpm_resume flags 0x0
[   16.307502] ahci 0000:00:11.0: rpm_resume returns 1
[   16.307504] scsi host1: rpm_resume returns 0
[   16.307537] sd 0:0:0:0: [sda] Write Protect is off
[   16.307539] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   16.307566] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   16.307571] device: '8:0': device_add
[   16.307583] PM: Adding info for No Bus:8:0
[   16.307591] device: 'sda': device_add
[   16.307615] PM: Adding info for No Bus:sda
[   16.307630] sd 0:0:0:0: rpm_resume flags 0x4
[   16.307632] sd 0:0:0:0: rpm_resume returns 1
[   16.309982] scsi 1:0:0:0: CD-ROM            hp       DVD RW AD-7586H  KH04 PQ: 0 ANSI: 5
[   16.309991] device: 'target1:0:0': device_add
[   16.309999] bus: 'scsi': add device target1:0:0
[   16.310007] PM: Adding info for scsi:target1:0:0
[   16.310019] scsi target1:0:0: rpm_resume flags 0x4
[   16.310021] scsi target1:0:0: rpm_resume returns 1
[   16.310023] scsi 1:0:0:0: rpm_resume flags 0x0
[   16.310025] scsi 1:0:0:0: rpm_resume returns -13
[   16.310026] scsi 1:0:0:0: rpm_resume flags 0x4
[   16.310028] scsi 1:0:0:0: rpm_resume returns 1
[   16.310029] device: '1:0:0:0': device_add
[   16.310038] bus: 'scsi': add device 1:0:0:0
[   16.310042] PM: Adding info for scsi:1:0:0:0
[   16.310048] bus: 'scsi': driver_probe_device: matched device 1:0:0:0 with driver sd
[   16.310050] bus: 'scsi': really_probe: probing driver sd with device 1:0:0:0
[   16.310056] bus: 'scsi': driver_probe_device: matched device 1:0:0:0 with driver sr
[   16.310058] bus: 'scsi': really_probe: probing driver sr with device 1:0:0:0
[   16.310385] scsi host1: rpm_resume flags 0x4
[   16.310388] scsi host1: rpm_resume returns 1
[   16.313227] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   16.313230] cdrom: Uniform CD-ROM driver Revision: 3.20
[   16.313237] device: '11:0': device_add
[   16.313254] PM: Adding info for No Bus:11:0
[   16.313265] device: 'sr0': device_add
[   16.313316] PM: Adding info for No Bus:sr0
[   16.313347] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   16.313349] driver: '1:0:0:0': driver_bound: bound to device 'sr'
[   16.313351] bus: 'scsi': really_probe: bound device 1:0:0:0 to driver sr
[   16.313354] device: '1:0:0:0': device_add
[   16.313362] PM: Adding info for No Bus:1:0:0:0
[   16.313377] device: 'sg1': device_add
[   16.313433] PM: Adding info for No Bus:sg1
[   16.313441] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   16.313447] device: '1:0:0:0': device_add
[   16.313467] PM: Adding info for No Bus:1:0:0:0
[   16.682605]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 > sda4
[   16.682623] device: 'sda1': device_add
[   16.682679] PM: Adding info for No Bus:sda1
[   16.682687] device: 'sda2': device_add
[   16.682707] PM: Adding info for No Bus:sda2
[   16.682714] device: 'sda3': device_add
[   16.682731] PM: Adding info for No Bus:sda3
[   16.682737] device: 'sda4': device_add
[   16.682754] PM: Adding info for No Bus:sda4
[   16.682760] device: 'sda5': device_add
[   16.682778] PM: Adding info for No Bus:sda5
[   16.682784] device: 'sda6': device_add
[   16.682800] PM: Adding info for No Bus:sda6
[   16.682806] device: 'sda7': device_add
[   16.682824] PM: Adding info for No Bus:sda7
[   16.682830] device: 'sda8': device_add
[   16.682847] PM: Adding info for No Bus:sda8
[   16.787849] device: 'fw0': device_add
[   16.788119] sd 0:0:0:0: [sda] Attached SCSI disk
[   16.788134] registered taskstats version 1
[   16.800171] rtc_cmos 00:07: setting system clock to 2011-09-03 13:43:52 UTC (1315057432)
[   16.800255] bus: 'firewire': add device fw0
[   16.800265] PM: Adding info for firewire:fw0
[   16.800277] firewire_core: created device fw0: GUID 5566778811223344, S400
[   16.823495] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[   16.830699] Freeing unused kernel memory: 572k freed
[   16.835815] Write protecting the kernel read-only data: 10240k
[   16.846092] Freeing unused kernel memory: 1208k freed
[   16.858857] Freeing unused kernel memory: 2020k freed
doing fast boot
[   16.901542] bus: 'xen': registered
FATAL: Error inserting xen_netfront (/lib/modules/3.1.0-rc4-git2-20110903.1332.58-kernel-linux-3_1/kernel/drivers/net/xen-netfront.ko): No such device
FATAL: Error inserting xen_blkfront (/lib/modules/3.1.0-rc4-git2[   17.037573] udev[84]: starting version 166
-20110903.1332.58-kernel-linux-3_1/kernel/drivers/block/xen-blkfront.ko): No such device
Creating device nodes with udev
[   17.280933] device class 'drm': registering
[   17.282325] scsi host1: rpm_resume flags 0x4
[   17.282329] scsi host1: rpm_resume returns 1
[   17.283652] sd 0:0:0:0: rpm_resume flags 0x4
[   17.283656] sd 0:0:0:0: rpm_resume returns 1
[   17.285135] scsi host1: rpm_resume flags 0x4
[   17.285138] scsi host1: rpm_resume returns 1
[   17.292714] sd 0:0:0:0: rpm_resume flags 0x4
[   17.292718] sd 0:0:0:0: rpm_resume returns 1
[   17.293838] sd 0:0:0:0: rpm_resume flags 0x4
[   17.293841] sd 0:0:0:0: rpm_resume returns 1
[   17.297000] scsi host1: rpm_resume flags 0x4
[   17.297003] scsi host1: rpm_resume returns 1
[   17.303484] sd 0:0:0:0: rpm_resume flags 0x4
[   17.303488] sd 0:0:0:0: rpm_resume returns 1
[   17.314269] scsi host1: rpm_resume flags 0x4
[   17.314272] scsi host1: rpm_resume returns 1
[   17.326158] scsi host1: rpm_resume flags 0x4
[   17.326162] scsi host1: rpm_resume returns 1
[   17.361692] [drm] Initialized drm 1.1.0 20060810
[   17.367246] device: 'ttm': device_add
[   17.370976] PM: Adding info for No Bus:ttm
[   17.379369] [drm] radeon defaulting to kernel modesetting.
[   17.384909] [drm] radeon kernel modesetting enabled.
[   17.389897] bus: 'pci': add driver radeon
[   17.393976] bus: 'pci': driver_probe_device: matched device 0000:01:05.0 with driver radeon
[   17.402336] bus: 'pci': really_probe: probing driver radeon with device 0000:01:05.0
[   17.410107] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   17.417081] radeon 0000:01:05.0: setting latency timer to 64
[   17.422789] device: 'controlD64': device_add
[   17.427164] PM: Adding info for No Bus:controlD64
[   17.431895] device: 'card0': device_add
[   17.435784] PM: Adding info for No Bus:card0
[   17.440058] [drm] initializing kernel modesetting (RS880 0x1002:0x9712 0x103C:0x1455).
[   17.443355] sd 0:0:0:0: rpm_resume flags 0x4
[   17.443359] sd 0:0:0:0: rpm_resume returns 1
[   17.443432] sd 0:0:0:0: rpm_resume flags 0x4
[   17.443436] sd 0:0:0:0: rpm_resume returns 1
[   17.444079] sd 0:0:0:0: rpm_resume flags 0x4
[   17.444082] sd 0:0:0:0: rpm_resume returns 1
[   17.444125] sd 0:0:0:0: rpm_resume flags 0x4
[   17.444129] sd 0:0:0:0: rpm_resume returns 1
[   17.444673] sd 0:0:0:0: rpm_resume flags 0x4
[   17.444676] sd 0:0:0:0: rpm_resume returns 1
[   17.445456] sd 0:0:0:0: rpm_resume flags 0x4
[   17.445460] sd 0:0:0:0: rpm_resume returns 1
[   17.445537] sd 0:0:0:0: rpm_resume flags 0x4
[   17.445541] sd 0:0:0:0: rpm_resume returns 1
[   17.446128] sd 0:0:0:0: rpm_resume flags 0x4
[   17.446131] sd 0:0:0:0: rpm_resume returns 1
[   17.516003] [drm] register mmio base: 0xD6400000
[   17.520603] [drm] register mmio size: 65536
[   17.525414] ATOM BIOS: HP_Timex
[   17.528563] radeon 0000:01:05.0: VRAM: 320M 0x00000000C0000000 - 0x00000000D3FFFFFF (320M used)
[   17.537231] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[   17.544989] [drm] Detected VRAM RAM=320M, BAR=256M
[   17.549776] [drm] RAM width 32bits DDR
[   17.551331] sd 0:0:0:0: rpm_resume flags 0x4
[   17.551334] sd 0:0:0:0: rpm_resume returns 1
[   17.562082] [TTM] Zone  kernel: Available graphics memory: 3934198 kiB.
[   17.568701] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[   17.575302] [TTM] Initializing pool allocator.
[   17.579755] [drm] radeon: 320M of VRAM memory ready
[   17.584619] [drm] radeon: 512M of GTT memory ready.
[   17.589484] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   17.596080] [drm] Driver supports precise vblank timestamp query.
[   17.602171] [drm] radeon: irq initialized.
[   17.606261] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   17.613357] Registering platform device 'radeon_cp.0'. Parent at platform
[   17.620163] device: 'radeon_cp.0': device_add
[   17.624510] bus: 'platform': add device radeon_cp.0
[   17.629377] PM: Adding info for platform:radeon_cp.0
[   17.634344] [drm] Loading RS780 Microcode
[   17.638340] platform radeon_cp.0: firmware: requesting radeon/RS780_pfp.bin
[   17.645278] device: 'radeon_cp.0': device_add
[   17.649624] PM: Adding info for No Bus:radeon_cp.0
[   17.655869] device: 'radeon_cp.0': device_unregister
[   17.660867] PM: Removing info for No Bus:radeon_cp.0
[   17.665846] platform radeon_cp.0: firmware: requesting radeon/RS780_me.bin
[   17.672699] device: 'radeon_cp.0': device_add
[   17.677049] PM: Adding info for No Bus:radeon_cp.0
[   17.683248] device: 'radeon_cp.0': device_unregister
[   17.688206] PM: Removing info for No Bus:radeon_cp.0
[   17.693185] platform radeon_cp.0: firmware: requesting radeon/R600_rlc.bin
[   17.700037] device: 'radeon_cp.0': device_add
[   17.704385] PM: Adding info for No Bus:radeon_cp.0
[   17.710548] device: 'radeon_cp.0': device_unregister
[   17.715549] PM: Removing info for No Bus:radeon_cp.0
[   17.720525] PM: Removing info for platform:radeon_cp.0
[   17.725650] bus: 'platform': remove device radeon_cp.0
[   17.734454] radeon 0000:01:05.0: WB enabled
[   17.766284] sd 0:0:0:0: rpm_resume flags 0x4
[   17.770497] [drm] ring test succeeded in 1 usecs
[   17.770580] [drm] radeon: ib pool ready.
[   17.770635] [drm] ib test succeeded in 0 usecs
[   17.770667] device: 'i2c-0': device_add
[   17.770678] bus: 'i2c': add device i2c-0
[   17.770684] PM: Adding info for i2c:i2c-0
[   17.770704] device: 'i2c-1': device_add
[   17.770707] bus: 'i2c': add device i2c-1
[   17.770713] PM: Adding info for i2c:i2c-1
[   17.770720] device: 'i2c-2': device_add
[   17.770723] bus: 'i2c': add device i2c-2
[   17.770727] PM: Adding info for i2c:i2c-2
[   17.770733] device: 'i2c-3': device_add
[   17.770736] bus: 'i2c': add device i2c-3
[   17.770740] PM: Adding info for i2c:i2c-3
[   17.770746] device: 'i2c-4': device_add
[   17.770749] bus: 'i2c': add device i2c-4
[   17.770753] PM: Adding info for i2c:i2c-4
[   17.770768] device: 'card0-VGA-1': device_add
[   17.770802] PM: Adding info for No Bus:card0-VGA-1
[   17.770821] device: 'card0-LVDS-1': device_add
[   17.770827] PM: Adding info for No Bus:card0-LVDS-1
[   17.770980] device: 'i2c-5': device_add
[   17.770984] bus: 'i2c': add device i2c-5
[   17.770989] PM: Adding info for i2c:i2c-5
[   17.770996] device: 'card0-DP-1': device_add
[   17.771002] PM: Adding info for No Bus:card0-DP-1
[   17.771148] device: 'i2c-6': device_add
[   17.771151] bus: 'i2c': add device i2c-6
[   17.771156] PM: Adding info for i2c:i2c-6
[   17.771163] device: 'card0-DP-2': device_add
[   17.771171] PM: Adding info for No Bus:card0-DP-2
[   17.771183] [drm] Radeon Display Connectors
[   17.771184] [drm] Connector 0:
[   17.771185] [drm]   VGA
[   17.771188] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[   17.771189] [drm]   Encoders:
[   17.771190] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   17.771191] [drm] Connector 1:
[   17.771192] [drm]   LVDS
[   17.771194] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[   17.771195] [drm]   Encoders:
[   17.771197] [drm]     LCD1: INTERNAL_KLDSCP_LVTMA
[   17.771198] [drm] Connector 2:
[   17.771199] [drm]   DisplayPort
[   17.771200] [drm]   HPD1
[   17.771201] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
[   17.771203] [drm]   Encoders:
[   17.771204] [drm]     DFP1: INTERNAL_UNIPHY
[   17.771205] [drm] Connector 3:
[   17.771206] [drm]   DisplayPort
[   17.771207] [drm]   HPD2
[   17.771209] [drm]   DDC: 0x7e20 0x7e20 0x7e24 0x7e24 0x7e28 0x7e28 0x7e2c 0x7e2c
[   17.771210] [drm]   Encoders:
[   17.771211] [drm]     DFP2: INTERNAL_UNIPHY
[   17.781024] [drm] Radeon display connector VGA-1: No monitor connected or invalid EDID
[   17.833932] [drm] Radeon display connector LVDS-1: Found valid EDID
[   17.891694] sd 0:0:0:0: rpm_resume returns 1
[   18.058592] sd 0:0:0:0: rpm_resume flags 0x4
[   18.062364] sd 0:0:0:0: rpm_resume returns 1
[   18.122519] sd 0:0:0:0: rpm_resume flags 0x4
[   18.126411] sd 0:0:0:0: rpm_resume returns 1
[   18.178645] sd 0:0:0:0: rpm_resume flags 0x4
[   18.182527] sd 0:0:0:0: rpm_resume returns 1
[   18.234490] sd 0:0:0:0: rpm_resume flags 0x4
[   18.238401] sd 0:0:0:0: rpm_resume returns 1
[   18.480027] [drm] Radeon display connector DP-1: No monitor connected or invalid EDID
[   18.964026] [drm] Radeon display connector DP-2: No monitor connected or invalid EDID
[   18.972392] [drm] radeon: power management initialized
[   18.985068] sd 0:0:0:0: rpm_resume flags 0x4
[   18.988955] sd 0:0:0:0: rpm_resume returns 1
[   19.033178] sd 0:0:0:0: rpm_resume flags 0x4
[   19.037080] sd 0:0:0:0: rpm_resume returns 1
[   19.043693] sd 0:0:0:0: rpm_resume flags 0x4
[   19.047072] sd 0:0:0:0: rpm_resume returns 1
[   19.057836] sd 0:0:0:0: rpm_resume flags 0x4
[   19.061202] sd 0:0:0:0: rpm_resume returns 1
[   19.066597] sd 0:0:0:0: rpm_resume flags 0x4
[   19.070461] sd 0:0:0:0: rpm_resume returns 1
[   19.077341] sd 0:0:0:0: rpm_resume flags 0x4
[   19.080792] sd 0:0:0:0: rpm_resume returns 1
[   20.033963] [drm] fb mappable at 0xC0141000
[   20.038170] [drm] vram apper at 0xC0000000
[   20.042250] [drm] size 5787648
[   20.045290] [drm] fb depth is 24
[   20.048504] [drm]    pitch is 6400
[   20.051887] device: 'fb0': device_add
[   20.055608] PM: Adding info for No Bus:fb0
[   20.059711] fbcon: radeondrmfb (fb0) is primary device
[   20.064838] device: 'vtcon1': device_add
[   20.064845] PM: Adding info for No Bus:vtcon1
[   20.149540] Console: switching to colour frame buffer device 200x56
[   20.169211] fb0: radeondrmfb frame buffer device
[   20.173810] drm: registered panic notifier
[   20.177895] [drm] Initialized radeon 2.11.0 20080528 for 0000:01:05.0 on minor 0
[   20.185270] driver: '0000:01:05.0': driver_bound: bound to device 'radeon'
[   20.192121] bus: 'pci': really_probe: bound device 0000:01:05.0 to driver radeon
Trying manual resume from /dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R[   20.258055] sd 0:0:0:0: rpm_resume flags 0x4
[   20.260005] sd 0:0:0:0: rpm_resume returns 1
8246-part8
Invoking userspace resume from /dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part8
resume: libgcrypt version: 1.4.6
[   20.293027] sd 0:0:0:0: rpm_resume flags 0x4
[   20.296467] sd 0:0:0:0: rpm_resume returns 1
Trying manual resume from /dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part8
[   20.385015] sd 0:0:0:0: rpm_resume flags 0x4
[   20.388902] sd 0:0:0:0: rpm_resume returns 1
Invoking in-kern[   20.636935] PM: Starting manual resume from disk
el resume from /[   20.642907] sd 0:0:0:0: rpm_resume flags 0x4
[   20.646893] sd 0:0:0:0: rpm_resume returns 1
dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part8
Waiting for device /dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part4 to appear:  ok
fsck from u[   20.667000] sd 0:0:0:0: rpm_resume flags 0x4
[   20.670080] sd 0:0:0:0: rpm_resume returns 1
til-linux 2.19
[   20.676617] sd 0:0:0:0: rpm_resume flags 0x4
[   20.680544] sd 0:0:0:0: rpm_resume returns 1
[/sbin/fsck.ext4 (1) -- /] fsck.ext4 -a /dev/sda4 
WD7500BPVT_11.4: clean, 284831/730112 files, 8407797/11680768 blocks
fsck succeeded. [   20.762305] sd 0:0:0:0: rpm_resume flags 0x4
[   20.765700] sd 0:0:0:0: rpm_resume returns 1
Mounting root device read-write.
Mounting root /dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part4
mount -o rw,acl,user_xattr -t ext4 /dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part4 /root
[   20.799084] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[   20.944623] sd 0:0:0:0: rpm_resume flags 0x4
[   20.948516] sd 0:0:0:0: rpm_resume returns 1
[   20.967575] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr
INIT: version 2.88 booting
System Boot Control: Running /etc/init.d/boot
mounting mandatory file systems ...mount: devpts already mounted or /dev/pts busy
mount: according to mtab, devpts is already mounted on /dev/pts
..done
ERROR: Couldn't mount /mnt/relay: No such device
..done
Starting udevd: ok
[   24.864700] udev[410]: starting version 166
..done
Loading drivers, configuring devices: [   25.358124] kvm: Nested Virtualization enabled
[   25.362563] kvm: Nested Paging enabled
[   25.366373] device: 'kvm': device_add
[   25.370089] PM: Adding info for No Bus:kvm
[   25.407674] device class 'wmi': registering
[   25.411905] bus: 'acpi': add driver wmi
[   25.415746] bus: 'acpi': driver_probe_device: matched device PNP0C14:00 with driver wmi
[   25.423723] bus: 'acpi': really_probe: probing driver wmi with device PNP0C14:00
[   25.431139] device: '5FB7F034-2C63-45E9-BE91-3D44E2C707E4': device_add
[   25.437656] PM: Adding info for No Bus:5FB7F034-2C63-45E9-BE91-3D44E2C707E4
[   25.444610] device: '95F24279-4D7B-4334-9387-ACCDC67EF61C': device_add
[   25.451139] PM: Adding info for No Bus:95F24279-4D7B-4334-9387-ACCDC67EF61C
[   25.458112] device: '2B814318-4BE8-4707-9D84-A190A859B5D0': device_add
[   25.464621] PM: Adding info for No Bus:2B814318-4BE8-4707-9D84-A190A859B5D0
[   25.471590] device: '05901221-D566-11D1-B2F0-00A0C9062910': device_add
[   25.478115] PM: Adding info for No Bus:05901221-D566-11D1-B2F0-00A0C9062910
[   25.478332] bus: 'pnp': add driver tpm_tis
[   25.478340] bus: 'pnp': driver_probe_device: matched device 00:03 with driver tpm_tis
[   25.478343] bus: 'pnp': really_probe: probing driver tpm_tis with device 00:03
[   25.478354] device: 'tpm0': device_add
[   25.478398] PM: Adding info for No Bus:tpm0
[   25.512029] device: '1F4C91EB-DC5C-460B-951D-C7CB9B4B8D5E': device_add
[   25.512038] tpm_tis 00:03: 1.2 TPM (device-id 0xB, rev-id 16)
[   25.524265] PM: Adding info for No Bus:1F4C91EB-DC5C-460B-951D-C7CB9B4B8D5E
[   25.531214] device: '2D114B49-2DFB-4130-B8FE-4A3C09E75133': device_add
[   25.537721] PM: Adding info for No Bus:2D114B49-2DFB-4130-B8FE-4A3C09E75133
[   25.544673] device: '988D08E3-68F4-4C35-AF3E-6A1B8106F83C': device_add
[   25.551182] PM: Adding info for No Bus:988D08E3-68F4-4C35-AF3E-6A1B8106F83C
[   25.558132] device: '14EA9746-CE1F-4098-A0E0-7045CB4DA745': device_add
[   25.564647] PM: Adding info for No Bus:14EA9746-CE1F-4098-A0E0-7045CB4DA745
[   25.571599] device: '322F2028-0F84-4901-988E-015176049E2D': device_add
[   25.578108] PM: Adding info for No Bus:322F2028-0F84-4901-988E-015176049E2D
[   25.585065] device: '8232DE3D-663D-4327-A8F4-E293ADB9BF05': device_add
[   25.591579] PM: Adding info for No Bus:8232DE3D-663D-4327-A8F4-E293ADB9BF05
[   25.598529] device: '8F1F6436-9F42-42C8-BADC-0E9424F20C9A': device_add
[   25.605038] PM: Adding info for No Bus:8F1F6436-9F42-42C8-BADC-0E9424F20C9A
[   25.611987] device: '8F1F6435-9F42-42C8-BADC-0E9424F20C9A': device_add
[   25.618499] PM: Adding info for No Bus:8F1F6435-9F42-42C8-BADC-0E9424F20C9A
[   25.625448] device: '7391A661-223A-47DB-A77A-7BE84C60822D': device_add
[   25.631958] PM: Adding info for No Bus:7391A661-223A-47DB-A77A-7BE84C60822D
[   25.638908] device: 'DF4E63B6-3BBC-4858-9737-C74F82F821F3': device_add
[   25.645417] PM: Adding info for No Bus:DF4E63B6-3BBC-4858-9737-C74F82F821F3
[   25.652367] driver: 'PNP0C14:00': driver_bound: bound to device 'wmi'
[   25.658786] bus: 'acpi': really_probe: bound device PNP0C14:00 to driver wmi
[   25.665825] wmi: Mapper loaded
[   25.724155] driver: '00:03': driver_bound: bound to device 'tpm_tis'
[   25.730493] bus: 'pnp': really_probe: bound device 00:03 to driver tpm_tis
[   25.739315] bus: 'acpi': add driver hp_accel
[   25.743606] bus: 'acpi': driver_probe_device: matched device HPQ0004:00 with driver hp_accel
[   25.749372] bus: 'pnp': add driver tpm_inf_pnp
[   25.756444] bus: 'acpi': really_probe: probing driver hp_accel with device HPQ0004:00
[   25.816235] hp_accel: laptop model unknown, using default axes configuration
[   25.831371] bus: 'mmc': registered
[   25.831430] bus: 'pci': add driver piix4_smbus
[   25.831441] bus: 'pci': driver_probe_device: matched device 0000:00:14.0 with driver piix4_smbus
[   25.831443] bus: 'pci': really_probe: probing driver piix4_smbus with device 0000:00:14.0
[   25.831493] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[   25.831499] device: 'i2c-7': device_add
[   25.831510] bus: 'i2c': add device i2c-7
[   25.831518] PM: Adding info for i2c:i2c-7
[   25.831528] driver: '0000:00:14.0': driver_bound: bound to device 'piix4_smbus'
[   25.831530] bus: 'pci': really_probe: bound device 0000:00:14.0 to driver piix4_smbus
[   25.890257] device class 'mmc_host': registering
[   25.890282] bus: 'sdio': registered
[   25.895598] sdhci: Secure Digital Host Controller Interface driver
[   25.895600] sdhci: Copyright(c) Pierre Ossman
[   25.896494] bus: 'pci': add driver sdhci-pci
[   25.896509] bus: 'pci': driver_probe_device: matched device 0000:03:00.0 with driver sdhci-pci
[   25.896512] bus: 'pci': really_probe: probing driver sdhci-pci with device 0000:03:00.0
[   25.896520] sdhci-pci 0000:03:00.0: SDHCI controller found [1180:e822] (rev 1)
[   25.896568] sdhci-pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   25.898434] sdhci-pci 0000:03:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[   25.898443] sdhci-pci 0000:03:00.0: setting latency timer to 64
[   25.898460] device: 'mmc0::': device_add
[   25.898473] PM: Adding info for No Bus:mmc0::
[   25.898481] Registered led device: mmc0::
[   25.898483] device: 'mmc0': device_add
[   25.898490] PM: Adding info for No Bus:mmc0
[   25.898545] mmc0: SDHCI controller on PCI [0000:03:00.0] using DMA
[   25.898551] driver: '0000:03:00.0': driver_bound: bound to device 'sdhci-pci'
[   25.898553] bus: 'pci': really_probe: bound device 0000:03:00.0 to driver sdhci-pci
[   25.902031] device: 'eth0': device_rename: renaming to 'en0'
[   26.014589] sd 0:0:0:0: rpm_resume flags 0x4
[   26.018021] sd 0:0:0:0: rpm_resume returns 1
[   26.023597] bus: 'pci': add driver k10temp
[   26.027778] bus: 'pci': driver_probe_device: matched device 0000:00:18.3 with driver k10temp
[   26.028341] udev[413]: renamed network interface eth0 to en0
[   26.030747] scsi host1: rpm_resume flags 0x4
[   26.030751] scsi host1: rpm_resume returns 1
[   26.031508] scsi host1: rpm_resume flags 0x4
[   26.031512] scsi host1: rpm_resume returns 1
[   26.054131] scsi host1: rpm_resume flags 0x4
[   26.054135] scsi host1: rpm_resume returns 1
[   26.055597] scsi host1: rpm_resume flags 0x4
[   26.055600] scsi host1: rpm_resume returns 1
[   26.063810] Linux video capture interface: v2.00
[   26.063813] device class 'video4linux': registering
[   26.067249] scsi host1: rpm_resume flags 0x4
[   26.067252] scsi host1: rpm_resume returns 1
[   26.075412] bus: 'usb': add driver uvcvideo
[   26.075426] bus: 'usb': driver_probe_device: matched device 1-5:1.0 with driver uvcvideo
[   26.075428] bus: 'usb': really_probe: probing driver uvcvideo with device 1-5:1.0
[   26.075438] driver: '1-5:1.1': driver_bound: bound to device 'uvcvideo'
[   26.075455] uvcvideo: Found UVC 1.00 device Villem (0461:4db6)
[   26.083068] device: 'video0': device_add
[   26.083156] PM: Adding info for No Bus:video0
[   26.083175] device: 'input7': device_add
[   26.083194] PM: Adding info for No Bus:input7
[   26.083211] input: Villem as /devices/pci0000:00/0000:00:12.2/usb1/1-5/1-5:1.0/input/input7
[   26.083217] device: 'event7': device_add
[   26.084218] PM: Adding info for No Bus:event7
[   26.084242] driver: '1-5:1.0': driver_bound: bound to device 'uvcvideo'
[   26.084245] bus: 'usb': really_probe: bound device 1-5:1.0 to driver uvcvideo
[   26.084249] uvcvideo 1-5:1.0: rpm_suspend flags 0x4
[   26.084255] uvcvideo 1-5:1.0: rpm_suspend returns 0
[   26.084276] usbcore: registered new interface driver uvcvideo
[   26.084278] USB Video Class driver (1.1.1)
[   26.192123] bus: 'pci': really_probe: probing driver k10temp with device 0000:00:18.3
[   26.192141] device: 'hwmon1': device_add
[   26.192153] PM: Adding info for No Bus:hwmon1
[   26.192162] driver: '0000:00:18.3': driver_bound: bound to device 'k10temp'
[   26.192165] bus: 'pci': really_probe: bound device 0000:00:18.3 to driver k10temp
[   26.236286] device class 'sound': registering
[   26.241465] lis3lv02d: 8 bits sensor found
[   26.241477] device: 'input8': device_add
[   26.241504] PM: Adding info for No Bus:input8
[   26.241535] input: HP WMI hotkeys as /devices/virtual/input/input8
[   26.241543] device: 'event8': device_add
[   26.263873] Registering platform device 'lis3lv02d'. Parent at platform
[   26.264078] PM: Adding info for No Bus:event8
[   26.264101] bus: 'platform': add driver hp-wmi
[   26.264120] Registering platform device 'hp-wmi'. Parent at platform
[   26.264122] device: 'hp-wmi': device_add
[   26.264126] bus: 'platform': add device hp-wmi
[   26.264132] PM: Adding info for platform:hp-wmi
[   26.264139] bus: 'platform': driver_probe_device: matched device hp-wmi with driver hp-wmi
[   26.264141] bus: 'platform': really_probe: probing driver hp-wmi with device hp-wmi
[   26.286389] device class 'ieee80211': registering
[   26.286424] Registering platform device 'regulatory.0'. Parent at platform
[   26.286427] device: 'regulatory.0': device_add
[   26.286432] bus: 'platform': add device regulatory.0
[   26.286439] PM: Adding info for platform:regulatory.0
[   26.286462] cfg80211: Calling CRDA to update world regulatory domain
[   26.317593] sd 0:0:0:0: rpm_resume flags 0x4
[   26.317597] sd 0:0:0:0: rpm_resume returns 1
[   26.317761] sd 0:0:0:0: rpm_resume flags 0x4
[   26.317766] sd 0:0:0:0: rpm_resume returns 1
[   26.363493] device: 'lis3lv02d': device_add
[   26.367674] bus: 'platform': add device lis3lv02d
[   26.367682] PM: Adding info for platform:lis3lv02d
[   26.384826] sd 0:0:0:0: rpm_resume flags 0x4
[   26.388317] sd 0:0:0:0: rpm_resume returns 1
[   26.442265] device: 'timer': device_add
[   26.446192] PM: Adding info for No Bus:timer
[   26.584817] driver: 'hp-wmi': driver_bound: bound to device 'hp-wmi'
[   26.591160] bus: 'platform': really_probe: bound device hp-wmi to driver hp-wmi
[   26.620106] device: 'input9': device_add
[   26.624054] PM: Adding info for No Bus:input9
[   26.628427] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input9
[   26.636672] device: 'event9': device_add
[   26.640637] PM: Adding info for No Bus:event9
[   26.644998] device: 'js0': device_add
[   26.648694] PM: Adding info for No Bus:js0
[   26.652805] device: 'freefall': device_add
[   26.656931] PM: Adding info for No Bus:freefall
[   26.661457] device: 'hp::hddprotect': device_add
[   26.662469] cfg80211: World regulatory domain updated:
[   26.662472] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   26.662475] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   26.662478] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   26.662480] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   26.662482] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   26.662485] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   26.693864] brcmsmac: module is from the staging directory, the quality is unknown, you have been warned.
[   26.694428] brcmsmac: Unknown symbol brcmu_pktq_pflush (err 0)
[   26.694437] brcmsmac: Unknown symbol brcmu_chspec_malformed (err 0)
[   26.694446] brcmsmac: Unknown symbol brcmu_pkt_buf_free_skb (err 0)
[   26.694482] brcmsmac: Unknown symbol brcmu_pktq_init (err 0)
[   26.694488] brcmsmac: Unknown symbol brcmu_pktq_penq_head (err 0)
[   26.694527] brcmsmac: Unknown symbol brcmu_chspec_ctlchan (err 0)
[   26.694541] brcmsmac: Unknown symbol brcmu_pktq_pdeq (err 0)
[   26.694550] brcmsmac: Unknown symbol brcmu_pktq_flush (err 0)
[   26.694556] brcmsmac: Unknown symbol brcmu_pktq_peek_tail (err 0)
[   26.694575] brcmsmac: Unknown symbol brcmu_format_hex (err 0)
[   26.694585] brcmsmac: Unknown symbol brcmu_pkttotlen (err 0)
[   26.694591] brcmsmac: Unknown symbol brcmu_bitcount (err 0)
[   26.694603] brcmsmac: Unknown symbol brcmu_pktq_mdeq (err 0)
[   26.694609] brcmsmac: Unknown symbol brcmu_pktq_penq (err 0)
[   26.694615] brcmsmac: Unknown symbol brcmu_pktq_pdeq_tail (err 0)
[   26.694626] brcmsmac: Unknown symbol brcmu_format_flags (err 0)
[   26.694633] brcmsmac: Unknown symbol brcmu_pkt_buf_get_skb (err 0)
[   26.694643] brcmsmac: Unknown symbol brcmu_prpkt (err 0)
[   26.741870] bus: 'pci': add driver snd_hda_intel
[   26.741883] bus: 'pci': driver_probe_device: matched device 0000:00:14.2 with driver snd_hda_intel
[   26.741886] bus: 'pci': really_probe: probing driver snd_hda_intel with device 0000:00:14.2
[   26.747073] snd_hda_intel 0000:00:14.2: power state changed by ACPI to D0
[   26.747083] snd_hda_intel 0000:00:14.2: power state changed by ACPI to D0
[   26.747093] snd_hda_intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   26.876405] PM: Adding info for No Bus:hp::hddprotect
[   26.876414] Registered led device: hp::hddprotect
[   26.876417] driver: 'HPQ0004:00': driver_bound: bound to device 'hp_accel'
[   26.876420] bus: 'acpi': really_probe: bound device HPQ0004:00 to driver hp_accel
[   26.876436] hp_accel: driver loaded
[   27.008180] device: 'card0': device_add
[   27.012034] PM: Adding info for No Bus:card0
[   27.016310] device: 'input10': device_add
[   27.020323] PM: Adding info for No Bus:input10
[   27.024771] input: HDA ATI SB Line In at Sep Rear Jack as /devices/pci0000:00/0000:00:14.2/sound/card0/input10
[   27.034741] device: 'event10': device_add
[   27.038791] PM: Adding info for No Bus:event10
[   27.043231] device: 'input11': device_add
[   27.047242] PM: Adding info for No Bus:input11
[   27.051721] input: HDA ATI SB Mic at Ext Left Jack as /devices/pci0000:00/0000:00:14.2/sound/card0/input11
[   27.061342] device: 'event11': device_add
[   27.065381] PM: Adding info for No Bus:event11
[   27.069820] device: 'input12': device_add
[   27.073826] PM: Adding info for No Bus:input12
[   27.078270] input: HDA ATI SB Line Out at Ext Left Jack as /devices/pci0000:00/0000:00:14.2/sound/card0/input12
[   27.088323] device: 'event12': device_add
[   27.092360] PM: Adding info for No Bus:event12
[   27.096798] device: 'input13': device_add
[   27.100804] PM: Adding info for No Bus:input13
[   27.105252] input: HDA ATI SB HP Out at Sep Rear Jack as /devices/pci0000:00/0000:00:14.2/sound/card0/input13
[   27.115133] device: 'event13': device_add
[   27.119183] PM: Adding info for No Bus:event13
[   27.123623] device: 'pcmC0D0p': device_add
[   27.127747] PM: Adding info for No Bus:pcmC0D0p
[   27.132276] device: 'pcmC0D0c': device_add
[   27.136401] PM: Adding info for No Bus:pcmC0D0c
[   27.140932] device: 'controlC0': device_add
[   27.145146] PM: Adding info for No Bus:controlC0
[   27.149764] driver: '0000:00:14.2': driver_bound: bound to device 'snd_hda_intel'
[   27.157221] bus: 'pci': really_probe: bound device 0000:00:14.2 to driver snd_hda_intel
[   27.165229] bus: 'pci': driver_probe_device: matched device 0000:01:05.1 with driver snd_hda_intel
[   27.174178] bus: 'pci': really_probe: probing driver snd_hda_intel with device 0000:01:05.1
[   27.182514] snd_hda_intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   27.190117] snd_hda_intel 0000:01:05.1: setting latency timer to 64
[   27.300761] device: 'card1': device_add
[   27.304603] PM: Adding info for No Bus:card1
[   27.307730] sd 0:0:0:0: rpm_resume flags 0x4
[   27.307734] sd 0:0:0:0: rpm_resume returns 1
[   27.317384] device: 'pcmC1D3p': device_add
[   27.321529] PM: Adding info for No Bus:pcmC1D3p
[   27.326061] device: 'controlC1': device_add
[   27.330270] PM: Adding info for No Bus:controlC1
[   27.334915] driver: '0000:01:05.1': driver_bound: bound to device 'snd_hda_intel'
[   27.342377] bus: 'pci': really_probe: bound device 0000:01:05.1 to driver snd_hda_intel
[   27.528755] sd 0:0:0:0: rpm_resume flags 0x4
[   27.532418] sd 0:0:0:0: rpm_resume returns 1
[   27.700254] sd 0:0:0:0: rpm_resume flags 0x4
[   27.704005] sd 0:0:0:0: rpm_resume returns 1
[   27.734675] sd 0:0:0:0: rpm_resume flags 0x4
[   27.736213] sd 0:0:0:0: rpm_resume returns 1
[   27.743237] sd 0:0:0:0: rpm_resume flags 0x4
[   27.744005] sd 0:0:0:0: rpm_resume returns 1
[   27.751754] sd 0:0:0:0: rpm_resume flags 0x4
[   27.752000] sd 0:0:0:0: rpm_resume returns 1
[   27.760298] sd 0:0:0:0: rpm_resume flags 0x4
[   27.764001] sd 0:0:0:0: rpm_resume returns 1
[   27.764592] sd 0:0:0:0: rpm_resume flags 0x4
[   27.764596] sd 0:0:0:0: rpm_resume returns 1
[   27.772056] sd 0:0:0:0: rpm_resume flags 0x4
[   27.772059] sd 0:0:0:0: rpm_resume returns 1
[   27.772079] sd 0:0:0:0: rpm_resume flags 0x4
[   27.772082] sd 0:0:0:0: rpm_resume returns 1
[   27.777580] sd 0:0:0:0: rpm_resume flags 0x4
[   27.777583] sd 0:0:0:0: rpm_resume returns 1
[   27.794587] device: 'input14': device_add
[   27.794621] PM: Adding info for No Bus:input14
[   27.794644] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input14
[   27.794650] device: 'event14': device_add
[   27.794688] PM: Adding info for No Bus:event14
[   27.840464] sd 0:0:0:0: rpm_resume flags 0x4
[   27.844251] sd 0:0:0:0: rpm_resume returns 1
[   27.851389] sd 0:0:0:0: rpm_resume flags 0x4
[   27.853658] sd 0:0:0:0: rpm_resume returns 1
[   27.979237] sd 0:0:0:0: rpm_resume flags 0x4
[   27.983120] sd 0:0:0:0: rpm_resume returns 1
[   28.030356] sd 0:0:0:0: rpm_resume flags 0x4
[   28.034260] sd 0:0:0:0: rpm_resume returns 1
[   28.041342] sd 0:0:0:0: rpm_resume flags 0x4
[   28.044004] sd 0:0:0:0: rpm_resume returns 1
[   28.137177] sd 0:0:0:0: rpm_resume flags 0x4
[   28.140005] sd 0:0:0:0: rpm_resume returns 1
[   28.145708] sd 0:0:0:0: rpm_resume flags 0x4
[   28.148001] sd 0:0:0:0: rpm_resume returns 1
[   28.184779] sd 0:0:0:0: rpm_resume flags 0x4
[   28.188659] sd 0:0:0:0: rpm_resume returns 1
[   28.197042] sd 0:0:0:0: rpm_resume flags 0x4
[   28.200005] sd 0:0:0:0: rpm_resume returns 1
[   28.205596] sd 0:0:0:0: rpm_resume flags 0x4
[   28.208005] sd 0:0:0:0: rpm_resume returns 1
[   28.216587] sd 0:0:0:0: rpm_resume flags 0x4
[   28.220006] sd 0:0:0:0: rpm_resume returns 1
[   28.277309] sd 0:0:0:0: rpm_resume flags 0x4
[   28.281199] sd 0:0:0:0: rpm_resume returns 1
[   28.289562] sd 0:0:0:0: rpm_resume flags 0x4
[   28.292004] sd 0:0:0:0: rpm_resume returns 1
[   28.310382] sd 0:0:0:0: rpm_resume flags 0x4
[   28.314264] sd 0:0:0:0: rpm_resume returns 1
[   28.322485] sd 0:0:0:0: rpm_resume flags 0x4
[   28.324784] sd 0:0:0:0: rpm_resume returns 1
..done
Loading required kernel modules
..doneActivating swap-devices in /etc/fstab...
[   28.447012] sd 0:0:0:0: rpm_resume flags 0x4
[   28.450407] sd 0:0:0:0: rpm_resume returns 1
[   28.457522] sd 0:0:0:0: rpm_resume flags 0x4
[   28.461317] sd 0:0:0:0: rpm_resume returns 1
[   28.466863] Adding 8384508k swap on /dev/sda8.  Priority:-1 extents:1 across:8384508k 
..doneSet System Time to the current Hardware Clock..done
Activating device mapper.....done
Setting up hostname 'probook'..done
Setting up loopback interface ..done
[   29.612675] device: 'loop-control': device_add
[   29.617209] PM: Adding info for No Bus:loop-control
[   29.622110] device: '7:0': device_add
[   29.625789] PM: Adding info for No Bus:7:0
[   29.629881] device: 'loop0': device_add
[   29.633747] PM: Adding info for No Bus:loop0
[   29.638064] device: '7:1': device_add
[   29.641739] PM: Adding info for No Bus:7:1
[   29.645829] device: 'loop1': device_add
[   29.649687] PM: Adding info for No Bus:loop1
[   29.653979] device: '7:2': device_add
[   29.657655] PM: Adding info for No Bus:7:2
[   29.661763] device: 'loop2': device_add
[   29.665624] PM: Adding info for No Bus:loop2
[   29.669918] device: '7:3': device_add
[   29.673574] PM: Adding info for No Bus:7:3
[   29.677662] device: 'loop3': device_add
[   29.681520] PM: Adding info for No Bus:loop3
[   29.685812] device: '7:4': device_add
[   29.689467] PM: Adding info for No Bus:7:4
[   29.693575] device: 'loop4': device_add
[   29.697449] PM: Adding info for No Bus:loop4
[   29.701741] device: '7:5': device_add
[   29.705399] PM: Adding info for No Bus:7:5
[   29.709510] device: 'loop5': device_add
[   29.713370] PM: Adding info for No Bus:loop5
[   29.717668] device: '7:6': device_add
[   29.721326] PM: Adding info for No Bus:7:6
[   29.725435] device: 'loop6': device_add
[   29.729307] PM: Adding info for No Bus:loop6
[   29.733618] device: '7:7': device_add
[   29.737291] PM: Adding info for No Bus:7:7
[   29.741392] device: 'loop7': device_add
[   29.745291] PM: Adding info for No Bus:loop7
[   29.749621] device: '7:8': device_add
[   29.753284] PM: Adding info for No Bus:7:8
[   29.757376] device: 'loop8': device_add
[   29.761247] PM: Adding info for No Bus:loop8
[   29.765541] device: '7:9': device_add
[   29.769202] PM: Adding info for No Bus:7:9
[   29.769209] device: 'loop9': device_add
[   29.769239] PM: Adding info for No Bus:loop9
[   29.769273] device: '7:10': device_add
[   29.769281] PM: Adding info for No Bus:7:10
[   29.769286] device: 'loop10': device_add
[   29.769309] PM: Adding info for No Bus:loop10
[   29.769345] device: '7:11': device_add
[   29.769351] PM: Adding info for No Bus:7:11
[   29.769356] device: 'loop11': device_add
[   29.769371] PM: Adding info for No Bus:loop11
[   29.769408] device: '7:12': device_add
[   29.769415] PM: Adding info for No Bus:7:12
[   29.769420] device: 'loop12': device_add
[   29.769438] PM: Adding info for No Bus:loop12
[   29.769474] device: '7:13': device_add
[   29.769688] PM: Adding info for No Bus:7:13
[   29.769694] device: 'loop13': device_add
[   29.769717] PM: Adding info for No Bus:loop13
[   29.769752] device: '7:14': device_add
[   29.769759] PM: Adding info for No Bus:7:14
[   29.769764] device: 'loop14': device_add
[   29.769780] PM: Adding info for No Bus:loop14
[   29.769817] device: '7:15': device_add
[   29.769825] PM: Adding info for No Bus:7:15
[   29.769830] device: 'loop15': device_add
[   29.769844] PM: Adding info for No Bus:loop15
[   29.769881] device: '7:16': device_add
[   29.769888] PM: Adding info for No Bus:7:16
[   29.769893] device: 'loop16': device_add
[   29.769909] PM: Adding info for No Bus:loop16
[   29.769949] device: '7:17': device_add
[   29.769964] PM: Adding info for No Bus:7:17
[   29.769969] device: 'loop17': device_add
[   29.769990] PM: Adding info for No Bus:loop17
[   29.770025] device: '7:18': device_add
[   29.770038] PM: Adding info for No Bus:7:18
[   29.770043] device: 'loop18': device_add
[   29.770060] PM: Adding info for No Bus:loop18
[   29.770102] device: '7:19': device_add
[   29.770108] PM: Adding info for No Bus:7:19
[   29.770113] device: 'loop19': device_add
[   29.770129] PM: Adding info for No Bus:loop19
[   29.770163] device: '7:20': device_add
[   29.770171] PM: Adding info for No Bus:7:20
[   29.770176] device: 'loop20': device_add
[   29.770191] PM: Adding info for No Bus:loop20
[   29.770226] device: '7:21': device_add
[   29.770233] PM: Adding info for No Bus:7:21
[   29.770238] device: 'loop21': device_add
[   29.770257] PM: Adding info for No Bus:loop21
[   29.770298] device: '7:22': device_add
[   29.770305] PM: Adding info for No Bus:7:22
[   29.770310] device: 'loop22': device_add
[   29.772092] PM: Adding info for No Bus:loop22
[   29.772148] device: '7:23': device_add
[   29.772162] PM: Adding info for No Bus:7:23
[   29.772168] device: 'loop23': device_add
[   29.772203] PM: Adding info for No Bus:loop23
[   29.772239] device: '7:24': device_add
[   29.772246] PM: Adding info for No Bus:7:24
[   29.772251] device: 'loop24': device_add
[   29.772268] PM: Adding info for No Bus:loop24
[   29.772302] device: '7:25': device_add
[   29.772310] PM: Adding info for No Bus:7:25
[   29.772315] device: 'loop25': device_add
[   29.772329] PM: Adding info for No Bus:loop25
[   29.772369] device: '7:26': device_add
[   29.772383] PM: Adding info for No Bus:7:26
[   29.772389] device: 'loop26': device_add
[   29.772411] PM: Adding info for No Bus:loop26
[   29.772447] device: '7:27': device_add
[   29.772454] PM: Adding info for No Bus:7:27
[   29.772459] device: 'loop27': device_add
[   29.772474] PM: Adding info for No Bus:loop27
[   29.772512] device: '7:28': device_add
[   29.772519] PM: Adding info for No Bus:7:28
[   29.772524] device: 'loop28': device_add
[   29.772540] PM: Adding info for No Bus:loop28
[   29.772575] device: '7:29': device_add
[   29.772581] PM: Adding info for No Bus:7:29
[   29.772586] device: 'loop29': device_add
[   29.772611] PM: Adding info for No Bus:loop29
[   29.772648] device: '7:30': device_add
[   29.772657] PM: Adding info for No Bus:7:30
[   29.772662] device: 'loop30': device_add
[   29.772677] PM: Adding info for No Bus:loop30
[   29.772717] device: '7:31': device_add
[   29.772726] PM: Adding info for No Bus:7:31
[   29.772731] device: 'loop31': device_add
[   29.773559] PM: Adding info for No Bus:loop31
[   29.773618] device: '7:32': device_add
[   29.773632] PM: Adding info for No Bus:7:32
[   29.773639] device: 'loop32': device_add
[   29.773669] PM: Adding info for No Bus:loop32
[   29.773707] device: '7:33': device_add
[   29.773721] PM: Adding info for No Bus:7:33
[   29.773726] device: 'loop33': device_add
[   29.773744] PM: Adding info for No Bus:loop33
[   29.773781] device: '7:34': device_add
[   29.773788] PM: Adding info for No Bus:7:34
[   29.773792] device: 'loop34': device_add
[   29.773809] PM: Adding info for No Bus:loop34
[   29.773845] device: '7:35': device_add
[   29.773853] PM: Adding info for No Bus:7:35
[   29.773859] device: 'loop35': device_add
[   29.773875] PM: Adding info for No Bus:loop35
[   29.773916] device: '7:36': device_add
[   29.773927] PM: Adding info for No Bus:7:36
[   29.773932] device: 'loop36': device_add
[   29.773953] PM: Adding info for No Bus:loop36
[   29.773991] device: '7:37': device_add
[   29.774002] PM: Adding info for No Bus:7:37
[   29.774008] device: 'loop37': device_add
[   29.774723] PM: Adding info for No Bus:loop37
[   29.774788] device: '7:38': device_add
[   29.774806] PM: Adding info for No Bus:7:38
[   29.774812] device: 'loop38': device_add
[   29.774995] PM: Adding info for No Bus:loop38
[   29.775035] device: '7:39': device_add
[   29.775043] PM: Adding info for No Bus:7:39
[   29.775048] device: 'loop39': device_add
[   29.777567] PM: Adding info for No Bus:loop39
[   29.777633] device: '7:40': device_add
[   29.777653] PM: Adding info for No Bus:7:40
[   29.777660] device: 'loop40': device_add
[   29.779022] PM: Adding info for No Bus:loop40
[   29.779086] device: '7:41': device_add
[   29.779107] PM: Adding info for No Bus:7:41
[   29.779114] device: 'loop41': device_add
[   29.779656] PM: Adding info for No Bus:loop41
[   29.779717] device: '7:42': device_add
[   29.779733] PM: Adding info for No Bus:7:42
[   29.779741] device: 'loop42': device_add
[   29.780383] PM: Adding info for No Bus:loop42
[   29.780458] device: '7:43': device_add
[   29.780474] PM: Adding info for No Bus:7:43
[   29.780481] device: 'loop43': device_add
[   29.781070] PM: Adding info for No Bus:loop43
[   29.781129] device: '7:44': device_add
[   29.781144] PM: Adding info for No Bus:7:44
[   29.781151] device: 'loop44': device_add
[   29.781750] PM: Adding info for No Bus:loop44
[   29.781813] device: '7:45': device_add
[   29.781832] PM: Adding info for No Bus:7:45
[   29.781839] device: 'loop45': device_add
[   29.782959] PM: Adding info for No Bus:loop45
[   29.783029] device: '7:46': device_add
[   29.783051] PM: Adding info for No Bus:7:46
[   29.783058] device: 'loop46': device_add
[   29.783516] PM: Adding info for No Bus:loop46
[   29.783578] device: '7:47': device_add
[   29.783601] PM: Adding info for No Bus:7:47
[   29.783608] device: 'loop47': device_add
[   29.784040] PM: Adding info for No Bus:loop47
[   29.784104] device: '7:48': device_add
[   29.784124] PM: Adding info for No Bus:7:48
[   29.784130] device: 'loop48': device_add
[   29.784553] PM: Adding info for No Bus:loop48
[   29.784612] device: '7:49': device_add
[   29.784631] PM: Adding info for No Bus:7:49
[   29.784637] device: 'loop49': device_add
[   29.785048] PM: Adding info for No Bus:loop49
[   29.785112] device: '7:50': device_add
[   29.785132] PM: Adding info for No Bus:7:50
[   29.785138] device: 'loop50': device_add
[   29.785658] PM: Adding info for No Bus:loop50
[   29.785723] device: '7:51': device_add
[   29.785744] PM: Adding info for No Bus:7:51
[   29.785750] device: 'loop51': device_add
[   29.786815] PM: Adding info for No Bus:loop51
[   29.786888] device: '7:52': device_add
[   29.787228] PM: Adding info for No Bus:7:52
[   29.787248] device: 'loop52': device_add
[   29.787414] PM: Adding info for No Bus:loop52
[   29.787479] device: '7:53': device_add
[   29.787499] PM: Adding info for No Bus:7:53
[   29.787506] device: 'loop53': device_add
[   29.788240] PM: Adding info for No Bus:loop53
[   29.788309] device: '7:54': device_add
[   29.788820] PM: Adding info for No Bus:7:54
[   29.788836] device: 'loop54': device_add
[   29.789555] PM: Adding info for No Bus:loop54
[   29.789621] device: '7:55': device_add
[   29.789641] PM: Adding info for No Bus:7:55
[   29.789648] device: 'loop55': device_add
[   29.791926] PM: Adding info for No Bus:loop55
[   29.791992] device: '7:56': device_add
[   29.792034] PM: Adding info for No Bus:7:56
[   29.792041] device: 'loop56': device_add
[   29.793101] PM: Adding info for No Bus:loop56
[   29.793319] device: '7:57': device_add
[   29.793339] PM: Adding info for No Bus:7:57
[   29.793351] device: 'loop57': device_add
[   29.794483] PM: Adding info for No Bus:loop57
[   29.794549] device: '7:58': device_add
[   29.794572] PM: Adding info for No Bus:7:58
[   29.794579] device: 'loop58': device_add
[   29.795017] PM: Adding info for No Bus:loop58
[   29.795070] device: '7:59': device_add
[   29.795083] PM: Adding info for No Bus:7:59
[   29.795090] device: 'loop59': device_add
[   29.796498] PM: Adding info for No Bus:loop59
[   29.796571] device: '7:60': device_add
[   29.796593] PM: Adding info for No Bus:7:60
[   29.796599] device: 'loop60': device_add
[   29.797367] PM: Adding info for No Bus:loop60
[   29.797436] device: '7:61': device_add
[   29.797457] PM: Adding info for No Bus:7:61
[   29.797464] device: 'loop61': device_add
[   29.798187] PM: Adding info for No Bus:loop61
[   29.798252] device: '7:62': device_add
[   29.798273] PM: Adding info for No Bus:7:62
[   29.798280] device: 'loop62': device_add
[   29.799162] PM: Adding info for No Bus:loop62
[   29.799229] device: '7:63': device_add
[   29.799254] PM: Adding info for No Bus:7:63
[   29.799261] device: 'loop63': device_add
[   29.799881] PM: Adding info for No Bus:loop63
[   29.799922] loop: module loaded
Activating crypto devices using /etc/crypttab ... 
[   31.061417] device: 'vcs2': device_add
[   31.061488] PM: Adding info for No Bus:vcs2
[   31.061502] device: 'vcsa2': device_add
[   31.061533] PM: Adding info for No Bus:vcsa2
[   31.077593] device: 'vcs3': device_add
[   31.077640] PM: Adding info for No Bus:vcs3
[   31.077653] device: 'vcsa3': device_add
[   31.077673] PM: Adding info for No Bus:vcsa3
[   31.093734] device: 'vcs4': device_add
[   31.093781] PM: Adding info for No Bus:vcs4
[   31.093794] device: 'vcsa4': device_add
[   31.093811] PM: Adding info for No Bus:vcsa4
[   31.109867] device: 'vcs5': device_add
[   31.109984] PM: Adding info for No Bus:vcs5
[   31.110009] device: 'vcsa5': device_add
[   31.110072] PM: Adding info for No Bus:vcsa5
[   31.126227] device: 'vcs6': device_add
[   31.126275] PM: Adding info for No Bus:vcs6
[   31.126289] device: 'vcsa6': device_add
[   31.126306] PM: Adding info for No Bus:vcsa6
Loading console font lat9w-16.psfu  -m trivial G0:loadable
..doneLoading keymap i386/qwertz/de-latin1-nodeadkeys.map.gz
..doneStart Unicode mode
..doneUnlocking cr_lvm (/dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part6)
[   31.982852] sd 0:0:0:0: rpm_resume flags 0x4
[   31.986374] sd 0:0:0:0: rpm_resume returns 1
[   32.007842] sd 0:0:0:0: rpm_resume flags 0x4
[   32.011817] sd 0:0:0:0: rpm_resume returns 1
Enter passphrase for /dev/disk/by-id/ata-WDC_WD7500BPVT-00HXZT1_WD-WX61A50R8246-part6: 
[   60.216982] sd 0:0:0:0: rpm_resume flags 0x4
[   60.220000] sd 0:0:0:0: rpm_resume returns 1
[   60.225620] sd 0:0:0:0: rpm_resume flags 0x4
[   60.229526] sd 0:0:0:0: rpm_resume returns 1
[   60.234199] device: '254:0': device_add
[   60.238051] PM: Adding info for No Bus:254:0
[   60.242321] device: 'dm-0': device_add
[   60.246125] PM: Adding info for No Bus:dm-0
[   60.343671] Intel AES-NI instructions are not detected.
[   60.374763] sd 0:0:0:0: rpm_resume flags 0x4
[   60.378701] sd 0:0:0:0: rpm_resume returns 1
[   60.420503] device: '254:0': device_unregister
[   60.424940] PM: Removing info for No Bus:254:0
[   60.429396] device: '254:0': device_create_release
[   60.434180] PM: Removing info for No Bus:dm-0
[   60.568842] sd 0:0:0:0: rpm_resume flags 0x4
[   60.572000] sd 0:0:0:0: rpm_resume returns 1
[   60.577475] sd 0:0:0:0: rpm_resume flags 0x4
[   60.581385] sd 0:0:0:0: rpm_resume returns 1
[   60.586047] device: '254:0': device_add
[   60.589895] PM: Adding info for No Bus:254:0
[   60.594162] device: 'dm-0': device_add
[   60.597960] PM: Adding info for No Bus:dm-0
[   60.643259] sd 0:0:0:0: rpm_resume flags 0x4
[   60.647161] sd 0:0:0:0: rpm_resume returns 1
[   60.654382] sd 0:0:0:0: rpm_resume flags 0x4
[   60.656575] sd 0:0:0:0: rpm_resume returns 1
cr_lvm.....done
Waiting for udev to settle...
Scanning for LVM volume groups...
  Reading all physical volumes. [   60.734403] sd 0:0:0:0: rpm_resume flags 0x4
[   60.736006] sd 0:0:0:0: rpm_resume returns 1
 This may take a[   60.743826] sd 0:0:0:0: rpm_resume flags 0x4
[   60.747781] sd 0:0:0:0: rpm_resume returns 1
 while...
[   60.756620] sd 0:0:0:0: rpm_resume flags 0x4
[   60.760480] sd 0:0:0:0: rpm_resume returns 1
[   60.765196] sd 0:0:0:0: rpm_resume flags 0x4
[   60.769135] sd 0:0:0:0: rpm_resume returns 1
[   60.773723] sd 0:0:0:0: rpm_resume flags 0x4
[   60.777701] sd 0:0:0:0: rpm_resume returns 1
[   60.822177] sd 0:0:0:0: rpm_resume flags 0x4
[   60.826071] sd 0:0:0:0: rpm_resume returns 1
[   60.831076] sd 0:0:0:0: rpm_resume flags 0x4
[   60.834952] sd 0:0:0:0: rpm_resume returns 1
[   60.839616] sd 0:0:0:0: rpm_resume flags 0x4
[   60.843586] sd 0:0:0:0: rpm_resume returns 1
[   60.848133] sd 0:0:0:0: rpm_resume flags 0x4
[   60.852118] sd 0:0:0:0: rpm_resume returns 1
[   60.861716] sd 0:0:0:0: rpm_resume flags 0x4
[   60.865612] sd 0:0:0:0: rpm_resume returns 1
[   60.870553] sd 0:0:0:0: rpm_resume flags 0x4
[   60.874431] sd 0:0:0:0: rpm_resume returns 1
[   60.926580] sd 0:0:0:0: rpm_resume flags 0x4
[   60.930462] sd 0:0:0:0: rpm_resume returns 1
[   60.935124] sd 0:0:0:0: rpm_resume flags 0x4
[   60.939094] sd 0:0:0:0: rpm_resume returns 1
[   60.943643] sd 0:0:0:0: rpm_resume flags 0x4
[   60.947628] sd 0:0:0:0: rpm_resume returns 1
[   60.972138] sd 0:0:0:0: rpm_resume flags 0x4
[   60.976031] sd 0:0:0:0: rpm_resume returns 1
[   60.982920] sd 0:0:0:0: rpm_resume flags 0x4
[   60.986802] sd 0:0:0:0: rpm_resume returns 1
[   60.991464] sd 0:0:0:0: rpm_resume flags 0x4
[   60.995432] sd 0:0:0:0: rpm_resume returns 1
[   60.999980] sd 0:0:0:0: rpm_resume flags 0x4
[   61.003966] sd 0:0:0:0: rpm_resume returns 1
[   61.047791] sd 0:0:0:0: rpm_resume flags 0x4
[   61.052043] sd 0:0:0:0: rpm_resume returns 1
[   61.091074] sd 0:0:0:0: rpm_resume flags 0x4
[   61.094405] sd 0:0:0:0: rpm_resume returns 1
  Found volume group "WD7500BPVT[   61.151414] sd 0:0:0:0: rpm_resume flags 0x4
[   61.154969] sd 0:0:0:0: rpm_resume returns 1
_uncrypted" using metadata type lvm2
  Found volume group "WD7500BPVT_crypted" using metadata type lvm2
Activating LVM volume groups...
[   61.196142] sd 0:0:0:0: rpm_resume flags 0x4
[   61.200008] sd 0:0:0:0: rpm_resume returns 1
[   61.244094] sd 0:0:0:0: rpm_resume flags 0x4
[   61.248011] sd 0:0:0:0: rpm_resume returns 1
[   61.253156] sd 0:0:0:0: rpm_resume flags 0x4
[   61.257059] sd 0:0:0:0: rpm_resume returns 1
[   61.262215] sd 0:0:0:0: rpm_resume flags 0x4
[   61.266119] sd 0:0:0:0: rpm_resume returns 1
[   61.272136] sd 0:0:0:0: rpm_resume flags 0x4
[   61.276005] sd 0:0:0:0: rpm_resume returns 1
[   61.290989] device: '254:1': device_add
[   61.294847] PM: Adding info for No Bus:254:1
[   61.299117] device: 'dm-1': device_add
[   61.302925] PM: Adding info for No Bus:dm-1
[   61.445726] device: '254:2': device_add
[   61.449590] PM: Adding info for No Bus:254:2
[   61.453876] device: 'dm-2': device_add
[   61.454300] PM: Adding info for No Bus:dm-2
  2 logical volume(s) in volume group "WD7500BPVT_uncrypted" now active
[   61.586315] device: '254:3': device_add
[   61.590176] PM: Adding info for No Bus:254:3
[   61.594453] device: 'dm-3': device_add
[   61.598253] PM: Adding info for No Bus:dm-3
[   61.680462] device: '254:4': device_add
[   61.684316] PM: Adding info for No Bus:254:4
[   61.688589] device: 'dm-4': device_add
[   61.692392] PM: Adding info for No Bus:dm-4
  2 logical volume(s) in volume group "WD7500BPVT_crypted" now active
..done
Checking file sy[   61.929233] sd 0:0:0:0: rpm_resume flags 0x4
[   61.932222] sd 0:0:0:0: rpm_resume returns 1
stems...
fsck f[   61.938175] sd 0:0:0:0: rpm_resume flags 0x4
[   61.941830] sd 0:0:0:0: rpm_resume returns 1
rom util-linux 2.19
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /boot/sda2] fsck.ext3 -a /dev/sda2 
[   61.984263] sd 0:0:0:0: rpm_resume flags 0x4
[   61.988003] sd 0:0:0:0: rpm_resume returns 1
[   61.992817] sd 0:0:0:0: rpm_resume flags 0x4
[   61.996772] sd 0:0:0:0: rpm_resume returns 1
WD7500BPVT_boot:[   62.159907] sd 0:0:0:0: rpm_resume flags 0x4
[   62.163742] sd 0:0:0:0: rpm_resume returns 1
 clean, 41/13056[   62.168995] sd 0:0:0:0: rpm_resume flags 0x4
[   62.172001] sd 0:0:0:0: rpm_resume returns 1
0 files, 51936/5[   62.180145] sd 0:0:0:0: rpm_resume flags 0x4
[   62.184006] sd 0:0:0:0: rpm_resume returns 1
22240 blocks
[/[   62.188881] sd 0:0:0:0: rpm_resume flags 0x4
[   62.192790] sd 0:0:0:0: rpm_resume returns 1
sbin/fsck.ext3 (1) -- /dist] fsck.ext3 -a /dev/sda5 
[   62.331662] sd 0:0:0:0: rpm_resume flags 0x4
[   62.335547] sd 0:0:0:0: rpm_resume returns 1
[   62.343821] sd 0:0:0:0: rpm_resume flags 0x4
[   62.346084] sd 0:0:0:0: rpm_resume returns 1
WD7500BPVT_dist: clean, 327023/2[   63.017054] sd 0:0:0:0: rpm_resume flags 0x4
[   63.020414] sd 0:0:0:0: rpm_resume returns 1
6216448 files, 208062334/209716224 blocks
[/sbin/fsck.ext3 (1) -- /olh/maildir] fsck.ext3 -a /dev/mapper/WD7500BPVT_crypted-olh--maildir 
[   63.191944] sd 0:0:0:0: rpm_resume flags 0x4
[   63.195820] sd 0:0:0:0: rpm_resume returns 1
[   63.204084] sd 0:0:0:0: rpm_resume flags 0x4
[   63.208006] sd 0:0:0:0: rpm_resume returns 1
WD7500BPVT_maild: clean, 134271/655360 files, 6207262/10485760 blocks
[/sbin/fsck.ext3 (1) -- /olh/privat] fsck.ext3 -a /dev/mapper/WD7500BPVT_crypted-olh--privat 
WD7500BPVT_priva: clean, 483323/6553600 files, 48288059/52428800 blocks
[/sbin/fsck.ext3 (1) -- /work] fsck.ext3 -a /dev/mapper/WD7500BPVT_uncrypted-work 
WD7500BPVT_work: clean, 1037467/2752512 files, 42278991/44040192 blocks
[/sbin/fsck.ext4 (1) -- /11.4] fsck.ext4 -a /dev/mapper/WD7500BPVT_uncrypted-root 
WD7500BPVT_root: clean, 195049/2752512 files, 5808718/44040192 blocks
..done..done
Mounting local file systems...
[   65.335061] sd 0:0:0:0: rpm_resume flags 0x4
[   65.337677] sd 0:0:0:0: rpm_resume returns 1
[   65.467653] kjournald starting.  Commit interval 5 seconds
[   65.467690] EXT3-fs (sda2): mounted filesystem with ordered data mode
/dev/sda2 on /bo[   65.479695] sd 0:0:0:0: rpm_resume flags 0x4
[   65.483533] sd 0:0:0:0: rpm_resume returns 1
ot/sda2 type ext3 (ro,noatime,acl)
[   65.563416] kjournald starting.  Commit interval 5 seconds
[   65.564444] EXT3-fs (sda5): using internal journal
[   65.564450] EXT3-fs (sda5): mounted filesystem with journal data mode
/dev/sda5 on /dist type ext3 (rw,noatime,data=journal)
[   65.652036] kjournald starting.  Commit interval 5 seconds
[   65.652798] EXT3-fs (dm-3): using internal journal
[   65.652804] EXT3-fs (dm-3): mounted filesystem with journal data mode
/dev/mapper/WD7500BPVT_crypted-olh--maildir on /olh/maildir type ext3 (rw,noatime,data=journal)
[   65.711984] kjournald starting.  Commit interval 5 seconds
[   65.712567] EXT3-fs (dm-4): using internal journal
[   65.712572] EXT3-fs (dm-4): mounted filesystem with journal data mode
/dev/mapper/WD7500BPVT_crypted-olh--privat on /olh/privat type ext3 (rw,noatime,data=journal)
[   65.804383] kjournald starting.  Commit interval 5 seconds
[   65.810408] EXT3-fs (dm-2): using internal journal
[   65.815194] EXT3-fs (dm-2): mounted filesystem with writeback data mode
/dev/mapper/WD7500BPVT_uncrypted-work on /work type ext3 (rw,noatime,data=writeback)
[   65.892373] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
/dev/mapper/WD7500BPVT_uncrypted-root on /11.4 type ext4 (ro)
mount: enabling autoclear loopdev flag
mount: going to use the loop device /dev/loop0
[   66.093561] ISO 9660 Extensions: Microsoft Joliet Level 3
[   66.107623] ISO 9660 Extensions: RRIP_1991A
/dist/iso/sles10/cdn.novell.com/prot/Z4ysu62Q4gw~/SLES-10-SP3-DVD-x86_64-GM-DVD1.iso on /dist/sles10-sp3/x86_64/dvd1 type iso9660 (ro,_netdev)
mount: enabling autoclear loopdev flag
mount: going to use the loop device /dev/loop1
[   66.192049] ISO 9660 Extensions: Microsoft Joliet Level 3
[   66.231867] ISO 9660 Extensions: RRIP_1991A
/dist/iso/sles10/cdn.novell.com/prot/zpFecfuDXqI~/SLE-10-SP3-SDK-DVD-x86_64-GM-DVD1.iso on /dist/sles10-sp3/x86_64/sdk-dvd1 type iso9660 (ro,_netdev)
mount: enabling autoclear loopdev flag
mount: going to use the loop device /dev/loop2
[   66.465821] ISO 9660 Extensions: Microsoft Joliet Level 3
[   66.491138] ISO 9660 Extensions: RRIP_1991A
/dist/iso/sles10/cdn.novell.com/prot/2RH-u2YXFlc~/SLES-10-SP4-DVD-x86_64-GM-DVD1.iso on /dist/sles10-sp4/x86_64/dvd1 type iso9660 (ro,_netdev)
mount: enabling autoclear loopdev flag
mount: going to use the loop device /dev/loop3
[   66.551605] ISO 9660 Extensions: Microsoft Joliet Level 3
[   66.631379] ISO 9660 Extensions: RRIP_1991A
/dist/iso/sles10/cdn.novell.com/prot/JETn_0Tw_XM~/SLE-10-SP4-SDK-DVD-x86_64-GM-DVD1.iso on /dist/sles10-sp4/x86_64/sdk-dvd1 type iso9660 (ro,_netdev)
mount: enabling autoclear loopdev flag
mount: going to use the loop device /dev/loop4
[   66.872098] ISO 9660 Extensions: Microsoft Joliet Level 3
[   66.904450] ISO 9660 Extensions: RRIP_1991A
/dist/iso/sles11/cdn.novell.com/prot/hwRS9NNA004~/SLES-11-DVD-x86_64-GM-DVD1.iso on /dist/sles11/x86_64/dvd1 type iso9660 (ro,_netdev)
mount: enabling autoclear loopdev flag
mount: going to use the loop device /dev/loop5
[   67.279391] ISO 9660 Extensions: Microsoft Joliet Level 3
[   67.325225] ISO 9660 Extensions: RRIP_1991A
/dist/iso/sles11/cdn.novell.com/prot/x4q3cbksW7Q~/SLES-11-SP1-DVD-x86_64-GM-DVD1.iso on /dist/sles11-sp1/x86_64/dvd1 type iso9660 (ro,_netdev)
mount: enabling autoclear loopdev flag
mount: going to use the loop device /dev/loop6
[   67.432098] ISO 9660 Extensions: Microsoft Joliet Level 3
[   67.469247] ISO 9660 Extensions: RRIP_1991A
/dist/iso/sles11/cdn.novell.com/prot/zzeQqpY9nK4~/SLE-11-SP1-SDK-DVD-x86_64-GM-DVD1.iso on /dist/sles11-sp1/x86_64/sdk-dvd1 type iso9660 (ro,_netdev)
mount: enabling autoclear loopdev flag
mount: going to use the loop device /dev/loop7
[   67.700969] ISO 9660 Extensions: Microsoft Joliet Level 3
[   67.735279] ISO 9660 Extensions: RRIP_1991A
/dist/iso/sles11/dist.suse.de/install/SLES-11-SP2-Beta4/SLES-11-SP2-DVD-x86_64-Beta4-DVD1.iso on /dist/sles11-sp2/x86_64/dvd1 type iso9660 (ro,_netdev)
mount: enabling autoclear loopdev flag
mount: going to use the loop device /dev/loop8
[   67.844154] ISO 9660 Extensions: Microsoft Joliet Level 3
[   67.857272] ISO 9660 Extensions: RRIP_1991A
/dist/iso/sles11/dist.suse.de/install/SLE-11-SP2-SDK-Beta4/SLE-11-SP2-SDK-DVD-x86_64-Beta4-DVD1.iso on /dist/sles11-sp2/x86_64/sdk-dvd1 type iso9660 (ro,_netdev)
mount: enabling autoclear loopdev flag
mount: going to use the loop device /dev/loop9
[   68.017891] ISO 9660 Extensions: Microsoft Joliet Level 3
[   68.063155] ISO 9660 Extensions: RRIP_1991A
/dist/iso/11.2/openSUSE-11.2-DVD-x86_64.iso on /dist/11.2/x86_64/dvd1 type iso9660 (ro,_netdev)
mount: enabling autoclear loopdev flag
mount: going to use the loop device /dev/loop10
[   68.210331] ISO 9660 Extensions: Microsoft Joliet Level 3
[   68.241160] ISO 9660 Extensions: RRIP_1991A
/dist/iso/11.3/openSUSE-11.3-DVD-x86_64.iso on /dist/11.3/x86_64/dvd1 type iso9660 (ro,_netdev)
mount: enabling autoclear loopdev flag
mount: going to use the loop device /dev/loop11
[   68.388519] ISO 9660 Extensions: Microsoft Joliet Level 3
[   68.420466] ISO 9660 Extensions: RRIP_1991A
/dist/iso/11.4/openSUSE-11.4-DVD-x86_64.iso on /dist/11.4/x86_64/dvd1 type iso9660 (ro,_netdev)
..doneActivating crypto devices using /etc/crypttab ... 
cr_lvm: already mapped..skipped
[   68.456887] sd 0:0:0:0: rpm_resume flags 0x4
[   68.460008] sd 0:0:0:0: rpm_resume returns 1
Finish udev devi[   68.465499] sd 0:0:0:0: rpm_resume flags 0x4
[   68.469433] sd 0:0:0:0: rpm_resume returns 1
ce configuration[   68.475379] sd 0:0:0:0: rpm_resume flags 0x4
[   68.479323] sd 0:0:0:0: rpm_resume returns 1
: ..done
Settin[   68.485338] sd 0:0:0:0: rpm_resume flags 0x4
[   68.489217] sd 0:0:0:0: rpm_resume returns 1
g current sysctl[   68.495150] sd 0:0:0:0: rpm_resume flags 0x4
[   68.499111] sd 0:0:0:0: rpm_resume returns 1
 status from /etc/sysctl.conf..done
Enabling IP forwarding..done
Creating /var/log/boot.msg
..doneActivating remaining swap-devices in /etc/fstab...
..doneATTENTION: You have modified /etc/resolv.conf.  Leaving it untouched...
You can find my version in /etc/resolv.conf.netconfig ...
ATTENTION: You have modified /etc/named.d/forwarders.conf.  Leaving it untouched...
You can find my version in /etc/named.d/forwarders.conf.netconfig ...
Starting AppArmor Mounting securityfs on /sys/kernel/security ..done
Loading AppArmor module ..failed
System Boot Control: The system has been set up
Failed features: 
[80C
[20Dboot.apparmor
Skipped features: 
[80C
[33Dboot.open-iscsi boot.cycle
System Boot Control: Running /etc/init.d/boot.local
..done
INIT: Entering runlevel: 1
Master Resource Control: previous runlevel: N, switching to runlevel: 1
Master Resource Control: Running /etc/init.d/before.local
..doneLoading console font lat9w-16.psfu  -m trivial G0:loadable
..doneLoading keymap i386/qwertz/de-latin1-nodeadkeys.map.gz
..doneStart Unicode mode
..doneStarting irqbalance ..done
Sending all processes the TERM signal...
..done
Sending all processes the KILL signal...
..done
INIT: Going sin
INIT: Sending processes the TERM signal
Give root password for login: 
probook:~ # eval ` initviocons -e `
[   86.438214] usb 4-3: USB disconnect, device number 2
[   86.443171] device: 'ep_81': device_unregister
[   86.447597] PM: Removing info for No Bus:ep_81
[   86.452040] PM: Removing info for usb:4-3:1.0
[   86.456405] bus: 'usb': remove device 4-3:1.0
[   86.456409] usbhid 4-3:1.0: rpm_resume flags 0x4
[   86.456411] usbhid 4-3:1.0: rpm_resume returns -13
[   86.456416] PM: Removing info for hid:0003:093A:2510.0001
[   86.456421] bus: 'hid': remove device 0003:093A:2510.0001
[   86.456423] generic-usb 0003:093A:2510.0001: rpm_resume flags 0x4
[   86.456425] generic-usb 0003:093A:2510.0001: rpm_resume returns -13
[   86.456432] PM: Removing info for No Bus:mouse0
[   86.508099] PM: Removing info for No Bus:event5
[   86.560094] device: 'input5': device_unregister
[   86.564613] PM: Removing info for No Bus:input5
[   86.569176] device: 'hidraw0': device_unregister
[   86.573780] PM: Removing info for No Bus:hidraw0
[   86.578439] device: 'hidraw0': device_create_release
[   86.583426] device: 'ep_00': device_unregister
[   86.587855] PM: Removing info for No Bus:ep_00
[   86.592292] PM: Removing info for usb:4-3
[   86.596347] bus: 'usb': remove device 4-3
[   86.600342] usb 4-3: rpm_resume flags 0x4
[   86.604327] usb 4-3: rpm_resume returns -13
[   86.608503] device: 'usbdev4.2': device_unregister
[   86.613274] PM: Removing info for No Bus:usbdev4.2
[   86.618095] device: 'usbdev4.2': device_create_release
Probing connected terminal...
Initializing virtual console...
Found an xterm terminal on /dev/console (188 columns x 62 lines).
Use the 'initviocons' command whenever the terminal has been resized.
probook:~ # 
[   88.136109] usb 4-3: new low speed USB device number 3 using ohci_hcd
[   88.299257] usb 4-3: New USB device found, idVendor=093a, idProduct=2510
[   88.305943] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   88.313053] usb 4-3: Product: USB Optical Mouse
[   88.317565] usb 4-3: Manufacturer: PixArt
[   88.321560] device: '4-3': device_add
[   88.325292] bus: 'usb': add device 4-3
[   88.329034] PM: Adding info for usb:4-3
[   88.332875] bus: 'usb': driver_probe_device: matched device 4-3 with driver usb
[   88.340159] bus: 'usb': really_probe: probing driver usb with device 4-3
[   88.347258] device: '4-3:1.0': device_add
[   88.351269] bus: 'usb': add device 4-3:1.0
[   88.355354] PM: Adding info for usb:4-3:1.0
[   88.359543] bus: 'usb': driver_probe_device: matched device 4-3:1.0 with driver usbhid
[   88.367433] bus: 'usb': really_probe: probing driver usbhid with device 4-3:1.0
[   88.374730] device: '0003:093A:2510.0002': device_add
[   88.379765] bus: 'hid': add device 0003:093A:2510.0002
[   88.384889] PM: Adding info for hid:0003:093A:2510.0002
[   88.390113] bus: 'hid': driver_probe_device: matched device 0003:093A:2510.0002 with driver generic-usb
[   88.399476] bus: 'hid': really_probe: probing driver generic-usb with device 0003:093A:2510.0002
[   88.412366] device: 'input15': device_add
[   88.416414] PM: Adding info for No Bus:input15
[   88.420869] input: PixArt USB Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb4/4-3/4-3:1.0/input/input15
[   88.430839] device: 'mouse0': device_add
[   88.434806] PM: Adding info for No Bus:mouse0
[   88.439160] device: 'event5': device_add
[   88.443127] PM: Adding info for No Bus:event5
[   88.447481] device: 'hidraw0': device_add
[   88.451521] PM: Adding info for No Bus:hidraw0
[   88.455972] generic-usb 0003:093A:2510.0002: input,hidraw0: USB HID v1.11 Mouse [PixArt USB Optical Mouse] on usb-0000:00:12.0-3/input0
[   88.455975] driver: '0003:093A:2510.0002': driver_bound: bound to device 'generic-usb'
[   88.455978] bus: 'hid': really_probe: bound device 0003:093A:2510.0002 to driver generic-usb
[   88.455982] driver: '4-3:1.0': driver_bound: bound to device 'usbhid'
[   88.455984] bus: 'usb': really_probe: bound device 4-3:1.0 to driver usbhid
[   88.455987] usbhid 4-3:1.0: rpm_suspend flags 0x4
[   88.455990] usbhid 4-3:1.0: rpm_suspend returns 0
[   88.455993] device: 'ep_81': device_add
[   88.456005] PM: Adding info for No Bus:ep_81
[   88.456009] device: 'usbdev4.3': device_add
[   88.456037] PM: Adding info for No Bus:usbdev4.3
[   88.456050] driver: '4-3': driver_bound: bound to device 'usb'
[   88.456052] bus: 'usb': really_probe: bound device 4-3 to driver usb
[   88.456056] device: 'ep_00': device_add
[   88.456065] PM: Adding info for No Bus:ep_00
[   88.456067] usb 4-3: rpm_suspend flags 0xc
[   88.456069] usb 4-3: rpm_suspend returns -38
probook:~ # umount -vat iso9660
/dev/loop11 has been unmounted
/dev/loop10 has been unmounted
/dev/loop9 has been unmounted
/dev/loop8 has been unmounted
/dev/loop7 has been unmounted
/dev/loop6 has been unmounted
/dev/loop5 has been unmounted
/dev/loop4 has been unmounted
/dev/loop3 has been unmounted
/dev/loop2 has been unmounted
/dev/loop1 has been unmounted
/dev/loop0 has been unmounted
probook:~ # umount -vat ext2
/dev/mapper/WD7500BPVT_uncrypted-work has been unmounted
/dev/mapper/WD7500BPVT_crypted-olh--privat has been unmounted
/dev/mapper/WD7500BPVT_crypted-olh--maildir has been unmounted
/dev/sda5 has been unmounted
/dev/sda2 has been unmounted
probook:~ # insmod /lib/modules/3.1.0-rc4-git2-20110903.1332.58-kernel-linux-3_1/kernel/drivers/staging/brcm80211/brcmutil/brcmutil.ko 
[  117.613286] brcmutil: module is from the staging directory, the quality is unknown, you have been warned.
probook:~ # insmod /lib/modules/3.1.0-rc4-git2-20110903.1332.58-kernel-linux-3_1/kernel/drivers/staging/brcm80211/brcmsmac/brcmsmac.ko 
[  124.214241] brcmsmac: module is from the staging directory, the quality is unknown, you have been warned.
[  124.225158] bus: 'pci': add driver brcmsmac
[  124.229342] bus: 'pci': driver_probe_device: matched device 0000:07:00.0 with driver brcmsmac
[  124.237838] bus: 'pci': really_probe: probing driver brcmsmac with device 0000:07:00.0
[  124.245733] brcmsmac 0000:07:00.0: bus 7 slot 0 func 0 irq 5
[  124.251416] brcmsmac 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  124.258573] brcmsmac 0000:07:00.0: setting latency timer to 64
[  124.264484] brcmsmac 0000:07:00.0: firmware: requesting brcm/bcm43xx-0.fw
[  124.271250] device: '0000:07:00.0': device_add
[  124.275686] PM: Adding info for No Bus:0000:07:00.0
[  124.358379] device: '0000:07:00.0': device_unregister
[  124.363456] PM: Removing info for No Bus:0000:07:00.0
[  124.368523] brcmsmac 0000:07:00.0: firmware: requesting brcm/bcm43xx_hdr-0.fw
[  124.375635] device: '0000:07:00.0': device_add
[  124.380071] PM: Adding info for No Bus:0000:07:00.0
[  124.395696] device: '0000:07:00.0': device_unregister
[  124.400744] PM: Removing info for No Bus:0000:07:00.0
[  124.405901] Found chip type AI (0x13814313)
[  124.418909] Applying 4313 WARs
[  124.422963] device: 'phy0': device_add
[  124.426750] PM: Adding info for No Bus:phy0
[  124.448689] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[  124.455481] device: 'wlan0': device_add
[  124.459351] PM: Adding info for No Bus:wlan0
[  124.463681] driver: '0000:07:00.0': driver_bound: bound to device 'brcmsmac'
[  124.470711] bus: 'pci': really_probe: bound device 0000:07:00.0 to driver brcmsmac
[  124.478288] cfg80211: Calling CRDA for country: US
[  124.486208] cfg80211: Regulatory domain changed to country: US
[  124.492041] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  124.500365] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  124.508254] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[  124.516143] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  124.524031] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  124.531919] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  124.539808] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[31mprobook:~ # iw -h
Usage:	iw [options] command
Options:
	--debug		enable netlink debugging
	--version	show version (0.9.18)
Commands:
	help
	event [-t] [-f]
	list
	phy
	phy <phyname> info
	dev <devname> interface add <name> type <type> [mesh_id <meshid>] [4addr on|off] [flags <flag>*]
	phy <phyname> interface add <name> type <type> [mesh_id <meshid>] [4addr on|off] [flags <flag>*]
	dev <devname> del
	dev <devname> info
	dev
	dev <devname> ibss join <SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] [key d:0:abcde]
	dev <devname> ibss leave
	dev <devname> station dump
	dev <devname> station set <MAC address> vlan <ifindex>
	dev <devname> station set <MAC address> plink_action <open|block>
	dev <devname> station del <MAC address>
	dev <devname> station get <MAC address>
	dev <devname> survey dump
	dev <devname> mpath dump
	dev <devname> mpath set <destination MAC address> next_hop <next hop MAC address>
	dev <devname> mpath new <destination MAC address> next_hop <next hop MAC address>
	dev <devname> mpath del <MAC address>
	dev <devname> mpath get <MAC address>
	dev <devname> scan [-u] [freq <freq>*] [ssid <ssid>*|passive]
	dev <devname> scan trigger [freq <freq>*] [ssid <ssid>*|passive]
	dev <devname> scan dump [-u]
	reg get
	reg set <ISO/IEC 3166-1 alpha2>
	dev <devname> disconnect
	dev <devname> connect [-w] <SSID> [<freq in MHz>] [<bssid>] [key 0:abcde d:1:6162636465]
	dev <devname> link
	dev <devname> get mesh_param <param>
	phy <phyname> set netns <pid>
	phy <phyname> set rts <rts threshold|off>
	phy <phyname> set frag <fragmentation threshold|off>
	dev <devname> set channel <channel> [HT20|HT40+|HT40-]
	phy <phyname> set channel <channel> [HT20|HT40+|HT40-]
	dev <devname> set freq <freq> [HT20|HT40+|HT40-]
	phy <phyname> set freq <freq> [HT20|HT40+|HT40-]
	phy <phyname> set name <new name>
	dev <devname> set type <type>
	dev <devname> set meshid <meshid>
	dev <devname> set monitor <flag>*
	dev <devname> set mesh_param <param> <value>
You can omit the 'phy' or 'dev' if the identification is unique,
e.g. "iw wlan0 info" or "iw phy0 info". (Don't when scripting.)
Do NOT screenscrape this tool, we don't consider its output stable.
probook:~ # iw list
Wiphy phy0
	Band 1:
		HT capabilities: 0x4070
			* 20 MHz operation
			* static SM PS
			* HT-greenfield
			* 20 MHz short GI
			* 40 MHz short GI
			* max A-MSDU len 3839
			* 40 MHz intolerant
		HT A-MPDU factor: 0x0003 (65535 bytes)
		HT A-MPDU density: 0x0006 (8 usec)
		HT MCS set: ff 00 00 00 00 00 00 00 00 00 48 00 01 00 00 00
		HT TX/RX MCS rate indexes supported:
			MCS index 0
			MCS index 1
			MCS index 2
			MCS index 3
			MCS index 4
			MCS index 5
			MCS index 6
			MCS index 7
		Frequencies:
			* 2412 MHz [1] (19.0 dBm)
			* 2417 MHz [2] (19.0 dBm)
			* 2422 MHz [3] (19.0 dBm)
			* 2427 MHz [4] (19.0 dBm)
			* 2432 MHz [5] (19.0 dBm)
			* 2437 MHz [6] (19.0 dBm)
			* 2442 MHz [7] (19.0 dBm)
			* 2447 MHz [8] (19.0 dBm)
			* 2452 MHz [9] (19.0 dBm)
			* 2457 MHz [10] (19.0 dBm)
			* 2462 MHz [11] (19.0 dBm)
			* 2467 MHz [12] (disabled)
			* 2472 MHz [13] (disabled)
			* 2484 MHz [14] (disabled)
		Bitrates (non-HT):
			* 1.0 Mbps
			* 2.0 Mbps (short preamble supported)
			* 5.5 Mbps (short preamble supported)
			* 11.0 Mbps (short preamble supported)
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
	max # scan SSIDs: 4
	Supported interface modes:
		 * managed
		 * monitor
	Supported commands:
		 * new_interface
		 * set_interface
		 * new_key
		 * new_beacon
		 * new_station
		 * new_mpath
		 * set_mesh_params
		 * set_bss
		 * authenticate
		 * associate
		 * deauthenticate
		 * disassociate
		 * join_ibss
		 * Unknown command (68)
		 * Unknown command (55)
		 * Unknown command (57)
		 * Unknown command (59)
		 * Unknown command (67)
		 * set_wiphy_netns
		 * Unknown command (65)
		 * Unknown command (66)
		 * connect
		 * disconnect
probook:~ # 
[0;10m[  148.555291] usb 4-3: USB disconnect, device number 3
[  148.560245] device: 'ep_81': device_unregister
[  148.564672] PM: Removing info for No Bus:ep_81
[  148.569114] PM: Removing info for usb:4-3:1.0
[  148.573461] bus: 'usb': remove device 4-3:1.0
[  148.577802] usbhid 4-3:1.0: rpm_resume flags 0x4
[  148.581799] usbhid 4-3:1.0: rpm_resume returns -13
[  148.587176] PM: Removing info for hid:0003:093A:2510.0002
[  148.592559] bus: 'hid': remove device 0003:093A:2510.0002
[  148.597937] generic-usb 0003:093A:2510.0002: rpm_resume flags 0x4
[  148.601936] generic-usb 0003:093A:2510.0002: rpm_resume returns -13
[  148.610258] PM: Removing info for No Bus:mouse0
[  148.624098] PM: Removing info for No Bus:event5
[  148.640097] device: 'input15': device_unregister
[  148.644707] PM: Removing info for No Bus:input15
[  148.649358] device: 'hidraw0': device_unregister
[  148.653962] PM: Removing info for No Bus:hidraw0
[  148.658620] device: 'hidraw0': device_create_release
[  148.663614] device: 'ep_00': device_unregister
[  148.668045] PM: Removing info for No Bus:ep_00
[  148.672481] PM: Removing info for usb:4-3
[  148.676536] bus: 'usb': remove device 4-3
[  148.680531] usb 4-3: rpm_resume flags 0x4
[  148.684517] usb 4-3: rpm_resume returns -13
[  148.688692] device: 'usbdev4.3': device_unregister
[  148.693463] PM: Removing info for No Bus:usbdev4.3
[  148.698283] device: 'usbdev4.3': device_create_release
[  150.256095] usb 4-3: new low speed USB device number 4 using ohci_hcd
[  150.419235] usb 4-3: New USB device found, idVendor=093a, idProduct=2510
[  150.425922] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  150.433031] usb 4-3: Product: USB Optical Mouse
[  150.437545] usb 4-3: Manufacturer: PixArt
[  150.441537] device: '4-3': device_add
[  150.445269] bus: 'usb': add device 4-3
[  150.449011] PM: Adding info for usb:4-3
[  150.452852] bus: 'usb': driver_probe_device: matched device 4-3 with driver usb
[  150.460136] bus: 'usb': really_probe: probing driver usb with device 4-3
[  150.467249] device: '4-3:1.0': device_add
[  150.471259] bus: 'usb': add device 4-3:1.0
[  150.475344] PM: Adding info for usb:4-3:1.0
[  150.479534] bus: 'usb': driver_probe_device: matched device 4-3:1.0 with driver usbhid
[  150.487424] bus: 'usb': really_probe: probing driver usbhid with device 4-3:1.0
[  150.494724] device: '0003:093A:2510.0003': device_add
[  150.499758] bus: 'hid': add device 0003:093A:2510.0003
[  150.504882] PM: Adding info for hid:0003:093A:2510.0003
[  150.510106] bus: 'hid': driver_probe_device: matched device 0003:093A:2510.0003 with driver generic-usb
[  150.519469] bus: 'hid': really_probe: probing driver generic-usb with device 0003:093A:2510.0003
[  150.532360] device: 'input16': device_add
[  150.536408] PM: Adding info for No Bus:input16
[  150.540863] input: PixArt USB Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb4/4-3/4-3:1.0/input/input16
[  150.550832] device: 'mouse0': device_add
[  150.554799] PM: Adding info for No Bus:mouse0
[  150.559152] device: 'event5': device_add
[  150.563106] PM: Adding info for No Bus:event5
[  150.567461] device: 'hidraw0': device_add
[  150.571501] PM: Adding info for No Bus:hidraw0
[  150.575941] generic-usb 0003:093A:2510.0003: input,hidraw0: USB HID v1.11 Mouse [PixArt USB Optical Mouse] on usb-0000:00:12.0-3/input0
[  150.588073] driver: '0003:093A:2510.0003': driver_bound: bound to device 'generic-usb'
[  150.595962] bus: 'hid': really_probe: bound device 0003:093A:2510.0003 to driver generic-usb
[  150.604372] driver: '4-3:1.0': driver_bound: bound to device 'usbhid'
[  150.610789] bus: 'usb': really_probe: bound device 4-3:1.0 to driver usbhid
[  150.617727] usbhid 4-3:1.0: rpm_suspend flags 0x4
[  150.621725] usbhid 4-3:1.0: rpm_suspend returns 0
[  150.627100] device: 'ep_81': device_add
[  150.630925] PM: Adding info for No Bus:ep_81
[  150.635180] device: 'usbdev4.4': device_add
[  150.639396] PM: Adding info for No Bus:usbdev4.4
[  150.644014] driver: '4-3': driver_bound: bound to device 'usb'
[  150.649824] bus: 'usb': really_probe: bound device 4-3 to driver usb
[  150.656161] device: 'ep_00': device_add
[  150.659979] PM: Adding info for No Bus:ep_00
[  150.664246] usb 4-3: rpm_suspend flags 0xc
[  150.664249] usb 4-3: rpm_suspend returns -38
probook:~ # iw wlan0 info
Interface wlan0
	ifindex 3
	type managed
probook:~ # 
[  210.667314] usb 4-3: USB disconnect, device number 4
[  210.672271] device: 'ep_81': device_unregister
[  210.676696] PM: Removing info for No Bus:ep_81
[  210.681136] PM: Removing info for usb:4-3:1.0
[  210.685483] bus: 'usb': remove device 4-3:1.0
[  210.689822] usbhid 4-3:1.0: rpm_resume flags 0x4
[  210.693820] usbhid 4-3:1.0: rpm_resume returns -13
[  210.699195] PM: Removing info for hid:0003:093A:2510.0003
[  210.704586] bus: 'hid': remove device 0003:093A:2510.0003
[  210.709964] generic-usb 0003:093A:2510.0003: rpm_resume flags 0x4
[  210.713963] generic-usb 0003:093A:2510.0003: rpm_resume returns -13
[  210.722280] PM: Removing info for No Bus:mouse0
[  210.736096] PM: Removing info for No Bus:event5
[  210.752097] device: 'input16': device_unregister
[  210.756705] PM: Removing info for No Bus:input16
[  210.761354] device: 'hidraw0': device_unregister
[  210.765956] PM: Removing info for No Bus:hidraw0
[  210.770616] device: 'hidraw0': device_create_release
[  210.775602] device: 'ep_00': device_unregister
[  210.780034] PM: Removing info for No Bus:ep_00
[  210.784470] PM: Removing info for usb:4-3
[  210.788524] bus: 'usb': remove device 4-3
[  210.792520] usb 4-3: rpm_resume flags 0x4
[  210.796506] usb 4-3: rpm_resume returns -13
[  210.800682] device: 'usbdev4.4': device_unregister
[  210.805455] PM: Removing info for No Bus:usbdev4.4
[  210.810278] device: 'usbdev4.4': device_create_release
[  212.368097] usb 4-3: new low speed USB device number 5 using ohci_hcd
[  212.531245] usb 4-3: New USB device found, idVendor=093a, idProduct=2510
[  212.537931] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  212.545041] usb 4-3: Product: USB Optical Mouse
[  212.549554] usb 4-3: Manufacturer: PixArt
[  212.553549] device: '4-3': device_add
[  212.557274] bus: 'usb': add device 4-3
[  212.561014] PM: Adding info for usb:4-3
[  212.564857] bus: 'usb': driver_probe_device: matched device 4-3 with driver usb
[  212.572141] bus: 'usb': really_probe: probing driver usb with device 4-3
[  212.579243] device: '4-3:1.0': device_add
[  212.583252] bus: 'usb': add device 4-3:1.0
[  212.587337] PM: Adding info for usb:4-3:1.0
[  212.591526] bus: 'usb': driver_probe_device: matched device 4-3:1.0 with driver usbhid
[  212.599414] bus: 'usb': really_probe: probing driver usbhid with device 4-3:1.0
[  212.606712] device: '0003:093A:2510.0004': device_add
[  212.611745] bus: 'hid': add device 0003:093A:2510.0004
[  212.616869] PM: Adding info for hid:0003:093A:2510.0004
[  212.622092] bus: 'hid': driver_probe_device: matched device 0003:093A:2510.0004 with driver generic-usb
[  212.631456] bus: 'hid': really_probe: probing driver generic-usb with device 0003:093A:2510.0004
[  212.644352] device: 'input17': device_add
[  212.648400] PM: Adding info for No Bus:input17
[  212.652854] input: PixArt USB Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb4/4-3/4-3:1.0/input/input17
[  212.662830] device: 'mouse0': device_add
[  212.662893] PM: Adding info for No Bus:mouse0
[  212.662904] device: 'event5': device_add
[  212.662932] PM: Adding info for No Bus:event5
[  212.662942] device: 'hidraw0': device_add
[  212.662957] PM: Adding info for No Bus:hidraw0
[  212.662968] generic-usb 0003:093A:2510.0004: input,hidraw0: USB HID v1.11 Mouse [PixArt USB Optical Mouse] on usb-0000:00:12.0-3/input0
[  212.662971] driver: '0003:093A:2510.0004': driver_bound: bound to device 'generic-usb'
[  212.662973] bus: 'hid': really_probe: bound device 0003:093A:2510.0004 to driver generic-usb
[  212.662977] driver: '4-3:1.0': driver_bound: bound to device 'usbhid'
[  212.662980] bus: 'usb': really_probe: bound device 4-3:1.0 to driver usbhid
[  212.662983] usbhid 4-3:1.0: rpm_suspend flags 0x4
[  212.662985] usbhid 4-3:1.0: rpm_suspend returns 0
[  212.662989] device: 'ep_81': device_add
[  212.662996] PM: Adding info for No Bus:ep_81
[  212.663001] device: 'usbdev4.5': device_add
[  212.663023] PM: Adding info for No Bus:usbdev4.5
[  212.663036] driver: '4-3': driver_bound: bound to device 'usb'
[  212.663038] bus: 'usb': really_probe: bound device 4-3 to driver usb
[  212.663042] device: 'ep_00': device_add
[  212.663050] PM: Adding info for No Bus:ep_00
[  212.663052] usb 4-3: rpm_suspend flags 0xc
[  212.663055] usb 4-3: rpm_suspend returns -38
probook:~ # ifconfig wlan0 up
[  223.353835] ieee80211 phy0: brcms_ops_config: change monitor mode: false (implement)
[  223.361597] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[  223.369624] ieee80211 phy0: wl0: brcms_c_wme_setparams : no-clock
[  223.375703] ieee80211 phy0: wl0: brcms_c_wme_setparams : no-clock
[  223.381781] ieee80211 phy0: wl0: brcms_c_wme_setparams : no-clock
[  223.387859] ieee80211 phy0: wl0: brcms_c_wme_setparams : no-clock
[  223.393934] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
probook:~ # iw wlan0 scan dump
[  232.268106] ieee80211 phy0: ops->tx called while down
[  232.328104] ieee80211 phy0: ops->tx called while down
[  232.388103] ieee80211 phy0: ops->tx called while down
[  232.448103] ieee80211 phy0: ops->tx called while down
[  232.508103] ieee80211 phy0: ops->tx called while down
[  232.568106] ieee80211 phy0: ops->tx called while down
[  232.628103] ieee80211 phy0: ops->tx called while down
[  232.688103] ieee80211 phy0: ops->tx called while down
[  232.748103] ieee80211 phy0: ops->tx called while down
[  232.808103] ieee80211 phy0: ops->tx called while down
[  232.868106] ieee80211 phy0: ops->tx called while down
probook:~ # 
 <freeze>


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:49828 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYCaWcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 18:32:11 -0400
Date: Mon, 31 Mar 2008 23:55:53 +0200
From: maximilian attems <max@stro.at>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ipw3945-devel@lists.sourceforge.net
Subject: iwlwifi page allocation failure oops
Message-ID: <20080331215552.GF11802@stro.at> (sfid-20080331_233217_851994_6CD4DFBF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

have that oops since 2.6.24 after some cycles of suspend to ram.
just happened again with 2.6.25-rc7 on a x61s box
ap is plain unencrypted network.

base[0])
[    0.000000] IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3f000000:b1000000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 35224 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 250967
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda1 ro acpi_sleep=s3_bios 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000004] time.c: Detected 1595.987 MHz processor.
[    0.003100] Console: colour VGA+ 80x25
[    0.003107] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] Memory: 995408k/1022656k available (2205k kernel code, 26852k reserved, 1027k data, 372k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] hpet clockevent registered
[    0.080010] Calibrating delay using timer specific routine.. 3197.81 BogoMIPS (lpj=6395627)
[    0.080266] Security Framework initialized
[    0.080356] SELinux:  Disabled at boot.
[    0.080441] Capability LSM initialized
[    0.080824] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.082241] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.082932] Mount-cache hash table entries: 256
[    0.083311] Initializing cgroup subsys ns
[    0.083398] Initializing cgroup subsys cpuacct
[    0.083523] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.083668] CPU: L2 cache: 4096K
[    0.083754] CPU 0/0 -> Node 0
[    0.083827] CPU: Physical Processor ID: 0
[    0.083904] CPU: Processor Core ID: 0
[    0.084022] CPU0: Thermal monitoring enabled (TM2)
[    0.084106] using mwait in idle threads.
[    0.086384] ACPI: Core revision 20070126
[    0.169289] Using local APIC timer interrupts.
[    0.172013] APIC timer calibration result 12468656
[    0.172018] Detected 12.468 MHz APIC timer.
[    0.172443] Booting processor 1/2 APIC 0x1
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 3192.09 BogoMIPS (lpj=6384187)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 1/1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] Intel(R) Core(TM)2 Duo CPU     L7500  @ 1.60GHz stepping 0a
[    0.265406] checking TSC synchronization [CPU#0 -> CPU#1]:
[    0.268019] Measured 261200 cycles TSC warp between CPUs, turning off TSC clock.
[    0.268019] Marking TSC unstable due to check_tsc_sync_source failed
[    0.268059] Brought up 2 CPUs
[    0.268319] CPU0 attaching sched-domain:
[    0.268324]  domain 0: span 00000003
[    0.268329]   groups: 00000001 00000002
[    0.268336]   domain 1: span 00000003
[    0.268340]    groups: 00000003
[    0.268346] CPU1 attaching sched-domain:
[    0.268350]  domain 0: span 00000003
[    0.268353]   groups: 00000002 00000001
[    0.268360]   domain 1: span 00000003
[    0.268364]    groups: 00000003
[    0.268951] net_namespace: 1016 bytes
[    0.269049] Booting paravirtualized kernel on bare hardware
[    0.272232] NET: Registered protocol family 16
[    0.272780] ACPI: bus type pci registered
[    0.282632] PCI: Using MMCONFIG at f0000000 - f3ffffff
[    0.282728] PCI: Using configuration type 1
[    0.287381] ACPI: EC: EC description table is found, configuring boot EC
[    0.034715] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.318466] ACPI: Interpreter enabled
[    0.318563] ACPI: (supports S0 S3 S4 S5)
[    0.318991] ACPI: Using IOAPIC for interrupt routing
[    0.072446] ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
[    0.072551] ACPI: EC: driver started in poll mode
[    0.073098] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.075981] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.076050] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
[    0.078498] PCI: Transparent bridge - 0000:00:1e.0
[    0.078762] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.079401] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.079762] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.080235] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.090428] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
[    0.091866] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.093275] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.094708] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.096167] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.097597] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.099031] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.100464] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.372758] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.102324] ACPI: Power Resource [PUBS] (on)
[    0.102853] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.103015] pnp: PnP ACPI init
[    0.103119] ACPI: bus type pnp registered
[    0.106712]  00:00: calling quirk 0xffffffff8035b7de: quirk_system_pci_resources+0x0/0x173()
[    0.106844] pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.107017] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.107389]  00:02: calling quirk 0xffffffff8035b7de: quirk_system_pci_resources+0x0/0x173()
[    0.107505] pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.107833] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.107954] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.108086] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.108216] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.108343] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.108474] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.108604] pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    0.110373] pnp 00:0a: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
[    0.114697] pnp: PnP ACPI: found 11 devices
[    0.114796] ACPI: ACPI bus type pnp unregistered
[    0.115300] usbcore: registered new interface driver usbfs
[    0.115519] usbcore: registered new interface driver hub
[    0.116107] usbcore: registered new device driver usb
[    0.116512] PCI: Using ACPI for IRQ routing
[    0.116607] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.132028] NET: Registered protocol family 8
[    0.132123] NET: Registered protocol family 20
[    0.132289] PCI-GART: No AMD northbridge found.
[    0.132396] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
[    0.132802] hpet0: 3 64-bit timers, 14318180 Hz
[    0.133986] ACPI: RTC can wake from S4
[    0.408048] Switched to high resolution mode on CPU 0
[    0.140028] Switched to high resolution mode on CPU 1
[    0.148030] pnp: the driver 'system' has been registered
[    0.148049] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.148150] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.148249] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.148347] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.148448] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.148547] system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
[    0.148646] system 00:00: iomem range 0x0-0x0 could not be reserved
[    0.148744] system 00:00: iomem range 0x0-0x0 could not be reserved
[    0.148844] system 00:00: iomem range 0x0-0x0 could not be reserved
[    0.148944] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    0.149043] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    0.149143] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    0.149247] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    0.149347] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.149447] system 00:00: iomem range 0x100000-0x3effffff could not be reserved
[    0.149558] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
[    0.149671] system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
[    0.149787] system 00:00: driver attached
[    0.149800] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.149902] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.150005] system 00:02: ioport range 0x1180-0x11bf has been reserved
[    0.150105] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.150206] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.150307] system 00:02: ioport range 0x1600-0x165f could not be reserved
[    0.150406] system 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
[    0.150518] system 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
[    0.150631] system 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
[    0.150745] system 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
[    0.150856] system 00:02: iomem range 0xfed19000-0xfed19fff could not be reserved
[    0.150967] system 00:02: iomem range 0xfed45000-0xfed4bfff could not be reserved
[    0.151086] system 00:02: driver attached
[    0.152215] PCI: Bridge: 0000:00:1c.0
[    0.152314]   IO window: 2000-2fff
[    0.152423]   MEM window: 0xf4000000-0xf5ffffff
[    0.152531]   PREFETCH window: 0x00000000f8500000-0x00000000f85fffff
[    0.152647] PCI: Bridge: 0000:00:1c.1
[    0.152743]   IO window: 3000-3fff
[    0.152849]   MEM window: 0xf6000000-0xf7ffffff
[    0.152952]   PREFETCH window: 0x00000000f8600000-0x00000000f86fffff
[    0.153074] PCI: Bus 6, cardbus bridge: 0000:05:00.0
[    0.153172]   IO window: 0x00004000-0x000040ff
[    0.153275]   IO window: 0x00004400-0x000044ff
[    0.153383]   PREFETCH window: 0xd8000000-0xdbffffff
[    0.153487]   MEM window: 0x40000000-0x43ffffff
[    0.153591] PCI: Bridge: 0000:00:1e.0
[    0.153687]   IO window: 4000-7fff
[    0.153793]   MEM window: 0xd4000000-0xd7efffff
[    0.153896]   PREFETCH window: 0x00000000d8000000-0x00000000dbffffff
[    0.154081] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 20
[    0.154275] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.154347] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 21
[    0.154541] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.154573] PCI: Enabling device 0000:00:1e.0 (0005 -> 0007)
[    0.154682] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.154729] ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.154923] PCI: Setting latency timer of device 0000:05:00.0 to 64
[    0.155010] NET: Registered protocol family 2
[    0.196221] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.197437] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    0.199132] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.200062] TCP: Hash tables configured (established 131072 bind 65536)
[    0.200162] TCP reno registered
[    0.212368] checking if image is initramfs... it is
[    1.884724] Freeing initrd memory: 7885k freed
[    1.891986] Simple Boot Flag at 0x35 set to 0x80
[    1.894429] audit: initializing netlink socket (disabled)
[    1.894548] type=2000 audit(1206901680.161:1): initialized
[    1.894969] Total HugeTLB memory allocated, 0
[    1.895337] VFS: Disk quotas dquot_6.5.1
[    1.895497] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.895808] io scheduler noop registered
[    1.895902] io scheduler anticipatory registered
[    1.895996] io scheduler deadline registered
[    1.896163] io scheduler cfq registered (default)
[    1.896277] pci 0000:00:02.0: Boot video device
[    1.896764] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.896910] assign_interrupt_mode Found MSI capability
[    1.897156] Allocate Port Service[0000:00:1c.0:pcie00]
[    1.897256] Allocate Port Service[0000:00:1c.0:pcie02]
[    1.897350] Allocate Port Service[0000:00:1c.0:pcie03]
[    1.897651] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    1.897797] assign_interrupt_mode Found MSI capability
[    1.898032] Allocate Port Service[0000:00:1c.1:pcie00]
[    1.898128] Allocate Port Service[0000:00:1c.1:pcie02]
[    1.898224] Allocate Port Service[0000:00:1c.1:pcie03]
[    1.905326] Real Time Clock Driver v1.12ac
[    1.905595] hpet_resources: 0xfed00000 is busy
[    1.905749] Linux agpgart interface v0.103
[    1.905844] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.906642] pnp: the driver 'serial' has been registered
[    1.907159] isa bounce pool size: 16 pages
[    1.909007] brd: module loaded
[    1.909255] input: Macintosh mouse button emulation as /class/input/input0
[    1.909573] pnp: the driver 'i8042 kbd' has been registered
[    1.909599] i8042 kbd 00:08: driver attached
[    1.909679] pnp: the driver 'i8042 aux' has been registered
[    1.909717] i8042 aux 00:09: driver attached
[    1.909796] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.924132] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.924238] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.940312] mice: PS/2 mouse device common for all mice
[    1.940503] cpuidle: using governor ladder
[    1.940604] cpuidle: using governor menu
[    1.941542] TCP bic registered
[    1.941665] NET: Registered protocol family 1
[    1.941777] NET: Registered protocol family 17
[    1.942208] registered taskstats version 1
[    1.942552] Freeing unused kernel memory: 372k freed
[    1.947094] input: AT Translated Set 2 keyboard as /class/input/input1
[    3.583710] ACPI: SSDT 3E6E1D72, 0282 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
[    3.584818] ACPI: SSDT 3E6E2079, 061E (r1  PmRef  Cpu0Cst      100 INTL 20050513)
[    3.594572] Monitor-Mwait will be used to enter C-1 state
[    3.594579] Monitor-Mwait will be used to enter C-2 state
[    3.594584] Monitor-Mwait will be used to enter C-3 state
[    3.594989] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    3.595094] ACPI: ACPI0007:00 is registered as cooling_device0
[    3.595103] ACPI: Processor [CPU0] (supports 8 throttling states)
[    3.595883] ACPI: SSDT 3E6E1CAA, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
[    3.596712] ACPI: SSDT 3E6E1FF4, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
[    3.361496] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    3.361632] ACPI: ACPI0007:01 is registered as cooling_device1
[    3.361644] ACPI: Processor [CPU1] (supports 8 throttling states)
[    3.366441] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    3.369528] ACPI: Thermal Zone [THM0] (39 C)
[    3.371920] ACPI: LNXTHERM:02 is registered as thermal_zone1
[    3.373466] ACPI: Thermal Zone [THM1] (39 C)
[    3.981017] ACPI: ACPI Dock Station Driver 
[    4.233769] USB Universal Host Controller Interface driver v3.0
[    4.233847] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
[    4.233871] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[    4.233880] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.234141] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.234214] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    4.234473] usb usb1: configuration #1 chosen from 1 choice
[    4.234524] hub 1-0:1.0: USB hub found
[    4.234536] hub 1-0:1.0: 2 ports detected
[    4.340829] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.340840] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.340845] usb usb1: Product: UHCI Host Controller
[    4.340850] usb usb1: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    4.340854] usb usb1: SerialNumber: 0000:00:1a.0
[    4.340947] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[    4.340970] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[    4.340979] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.341086] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    4.341163] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    4.341396] usb usb2: configuration #1 chosen from 1 choice
[    4.341448] hub 2-0:1.0: USB hub found
[    4.341461] hub 2-0:1.0: 2 ports detected
[    4.139310] SCSI subsystem initialized
[    4.387287] Uniform Multi-Platform E-IDE driver
[    4.387295] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    4.190044] libata version 3.00 loaded.
[    4.449875] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.449884] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.449890] usb usb2: Product: UHCI Host Controller
[    4.449894] usb usb2: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    4.449898] usb usb2: SerialNumber: 0000:00:1a.1
[    4.450020] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
[    4.450044] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    4.450053] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.450161] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
[    4.450232] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018a0
[    4.450455] usb usb3: configuration #1 chosen from 1 choice
[    4.450506] hub 3-0:1.0: USB hub found
[    4.450519] hub 3-0:1.0: 2 ports detected
[    4.556838] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.556848] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.556853] usb usb3: Product: UHCI Host Controller
[    4.556857] usb usb3: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    4.556862] usb usb3: SerialNumber: 0000:00:1d.0
[    4.556948] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
[    4.556972] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    4.556981] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.557085] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
[    4.557161] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018c0
[    4.557409] usb usb4: configuration #1 chosen from 1 choice
[    4.557464] hub 4-0:1.0: USB hub found
[    4.557477] hub 4-0:1.0: 2 ports detected
[    4.588693] usb 1-2: new full speed USB device using uhci_hcd and address 2
[    4.656520] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.656527] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.656532] usb usb4: Product: UHCI Host Controller
[    4.656536] usb usb4: Manufacturer: Linux 2.6.25-rc7-amd64 uhci_hcd
[    4.656541] usb usb4: SerialNumber: 0000:00:1d.1
[    4.416151] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
[    4.416185] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[    4.416194] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.416318] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 5
[    4.420285] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[    4.420311] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xf8426c00
[    4.471232] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    4.471466] usb usb5: configuration #1 chosen from 1 choice
[    4.471522] hub 5-0:1.0: USB hub found
[    4.471536] hub 5-0:1.0: 4 ports detected
[    4.503583] usb 1-2: device descriptor read/all, error -71
[    4.574344] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    4.574353] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.574358] usb usb5: Product: EHCI Host Controller
[    4.574363] usb usb5: Manufacturer: Linux 2.6.25-rc7-amd64 ehci_hcd
[    4.574367] usb usb5: SerialNumber: 0000:00:1a.7
[    4.817302] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
[    4.817302] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    4.817302] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.817302] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 6
[    4.818929] ehci_hcd 0000:00:1d.7: debug port 1
[    4.818946] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    4.818971] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf8427000
[    4.837331] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    4.837557] usb usb6: configuration #1 chosen from 1 choice
[    4.837610] hub 6-0:1.0: USB hub found
[    4.837625] hub 6-0:1.0: 4 ports detected
[    4.940711] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[    4.940718] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.940723] usb usb6: Product: EHCI Host Controller
[    4.940728] usb usb6: Manufacturer: Linux 2.6.25-rc7-amd64 ehci_hcd
[    4.940732] usb usb6: SerialNumber: 0000:00:1d.7
[    4.707488] ACPI: PCI Interrupt 0000:05:00.1[B] -> GSI 17 (level, low) -> IRQ 17
[    4.707508] PCI: Setting latency timer of device 0000:05:00.1 to 64
[    4.795210] firewire_ohci: Added fw-ohci device 0000:05:00.1, OHCI version 1.10
[    5.025676] ahci 0000:00:1f.2: version 3.0
[    5.025745] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 16
[    5.189294] usb 1-2: new full speed USB device using uhci_hcd and address 4
[    5.523487] firewire_core: created device fw0: GUID 000ae407232057ed, S400
[    5.360709] usb 1-2: configuration #1 chosen from 1 choice
[    5.362215] usb 1-2: New USB device found, idVendor=0483, idProduct=2016
[    5.362231] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.362336] usb 1-2: Product: Biometric Coprocessor
[    5.362435] usb 1-2: Manufacturer: STMicroelectronics
[    6.023864] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5 Gbps 0x1 impl SATA mode
[    6.023990] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
[    6.024108] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    6.024495] scsi0 : ahci
[    6.025148] scsi1 : ahci
[    6.025720] scsi2 : ahci
[    6.025967] ata1: SATA max UDMA/133 abar m2048@0xf8426000 port 0xf8426100 irq 1277
[    6.026077] ata2: DUMMY
[    6.026167] ata3: DUMMY
[    6.265490] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.500857] ata1.00: ATA-7: ST9120822AS, 3.CLF, max UDMA/100
[    6.500857] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    6.273582] ata1.00: configured for UDMA/100
[    6.506099] scsi 0:0:0:0: Direct-Access     ATA      ST9120822AS      3.CL PQ: 0 ANSI: 5
[    6.506099] ICH8M: IDE controller (0x8086:0x2850 rev 0x03) at  PCI slot 0000:00:1f.1
[    6.506099] ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
[    6.506099] ICH8M: not 100% native mode: will probe irqs later
[    6.506099] ICH8M: IDE port disabled
[    6.506099]     ide0: BM-DMA at 0x18e0-0x18e7, BIOS settings: hda:PIO, hdb:PIO
[    6.506099] Probing IDE interface ide0...
[    6.542043] Driver 'sd' needs updating - please use bus_type methods
[    6.544406] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[    6.544548] sd 0:0:0:0: [sda] Write Protect is off
[    6.544650] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.544707] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.544943] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[    6.545470] sd 0:0:0:0: [sda] Write Protect is off
[    6.545567] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.545632] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.545744]  sda: sda1 sda2 sda3 sda4
[    6.606535] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.316838] device-mapper: uevent: version 1.0.3
[    7.317704] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    8.150566] kjournald starting.  Commit interval 5 seconds
[    8.150566] EXT3-fs: mounted filesystem with ordered data mode.
[   10.345323] Non-volatile memory driver v1.2
[   10.721113] thinkpad_acpi: ThinkPad ACPI Extras v0.19
[   10.721216] thinkpad_acpi: http://ibm-acpi.sf.net/
[   10.721311] thinkpad_acpi: ThinkPad BIOS 7NET25WW (1.06 ), EC 7MHT24WW-1.02
[   10.721409] thinkpad_acpi: Lenovo ThinkPad X61s
[   10.777321] thinkpad_acpi: radio switch found; radios are enabled
[   10.815235] thinkpad_acpi: standard ACPI backlight interface available, not loading native one...
[   10.592892] input: ThinkPad Extra Buttons as /class/input/input2
[   11.167719] agpgart: Detected an Intel 965GM Chipset.
[   11.170135] agpgart: Detected 7676K stolen memory.
[   11.190278] agpgart: AGP aperture is 256M @ 0xe0000000
[   11.244840] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
[   11.244953] e1000e: Copyright (c) 1999-2007 Intel Corporation.
[   11.245166] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[   11.245403] PCI: Setting latency timer of device 0000:00:19.0 to 64
[   11.126161] input: Power Button (FF) as /class/input/input3
[   11.369215] eth0: (PCI Express:2.5GB/s:Width x1) 00:16:d3:3e:31:5c
[   11.369322] eth0: Intel(R) PRO/1000 Network Connection
[   11.369465] eth0: MAC: 4, PHY: 6, PBA No: ffffff-0ff
[   11.184333] ACPI: Power Button (FF) [PWRF]
[   11.184570] input: Lid Switch as /class/input/input4
[   11.455551] ACPI: Lid Switch [LID]
[   11.455785] input: Sleep Button (CM) as /class/input/input5
[   11.514490] ACPI: Sleep Button (CM) [SLPB]
[   12.067621] ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
[   12.067733] ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
[   12.067898] ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Is dependent on dock
[   12.067901] 
[   12.068091] ACPI: Bay [\_SB_.PCI0.IDE0.PRIM.MSTR] Added
[   11.908153] ACPI: AC Adapter [AC] (off-line)
[   11.976154] ACPI: device:03 is registered as cooling_device2
[   11.976751] input: Video Bus as /class/input/input6
[   12.032391] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   12.035790] ACPI: device:08 is registered as cooling_device3
[   12.036342] input: Video Bus as /class/input/input7
[   12.096384] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[   12.408742] ACPI: Battery Slot [BAT0] (battery present)
[   12.303750] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[   12.304007] iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
[   12.304161] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   12.692730] iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.23ks
[   12.692859] iwl4965: Copyright(c) 2003-2007 Intel Corporation
[   12.693126] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   12.693364] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   12.693555] iwl4965: Detected Intel Wireless WiFi Link 4965AGN
[   12.801819] iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
[   12.874378] input: PC Speaker as /class/input/input8
[   12.903580] phy0: Selected rate control algorithm 'iwl-4965-rs'
[   12.979233] sdhci: Secure Digital Host Controller Interface driver
[   12.979346] sdhci: Copyright(c) Pierre Ossman
[   13.584761] ACPI: PCI interrupt for device 0000:03:00.0 disabled
[   13.585721] ACPI: PCI Interrupt 0000:00:1f.3[A] -> GSI 23 (level, low) -> IRQ 23
[   13.586074] sdhci: SDHCI controller found at 0000:05:00.2 [1180:0822] (rev 21)
[   13.586246] ACPI: PCI Interrupt 0000:05:00.2[C] -> GSI 18 (level, low) -> IRQ 18
[   13.586507] sdhc0:slot0: Will use DMA mode even though HW doesn't fully claim to support it.
[   13.586638] PCI: Setting latency timer of device 0000:05:00.2 to 64
[   13.586837] mmc0: SDHCI at 0xd7efe400 irq 18 DMA
[   13.587194] Yenta: CardBus bridge found at 0000:05:00.0 [17aa:20c6]
[   13.715551] Yenta: ISA IRQ mask 0x04b8, PCI irq 16
[   13.715657] Socket status: 30000006
[   13.715755] pcmcia: parent PCI bridge I/O window: 0x4000 - 0x7fff
[   13.715857] pcmcia: parent PCI bridge Memory window: 0xd4000000 - 0xd7efffff
[   13.715964] pcmcia: parent PCI bridge Memory window: 0xd8000000 - 0xdbffffff
[   13.744948] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   13.775584] input: TPPS/2 IBM TrackPoint as /class/input/input9
[   13.922971] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
[   13.922971] hda_intel: probe_mask set to 0x1 for device 17aa:20ac
[   13.922971] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   16.012166] EXT3 FS on sda1, internal journal
[   16.957212] loop: module loaded
[   26.923200] fuse init (API version 7.9)
[   27.019694] kjournald starting.  Commit interval 5 seconds
[   27.191626] EXT3 FS on dm-4, internal journal
[   27.191626] EXT3-fs: mounted filesystem with ordered data mode.
[   27.091256] kjournald starting.  Commit interval 5 seconds
[   27.264837] EXT3 FS on dm-11, internal journal
[   27.265017] EXT3-fs: mounted filesystem with ordered data mode.
[   27.146329] kjournald starting.  Commit interval 5 seconds
[   27.146393] EXT3 FS on dm-5, internal journal
[   27.146393] EXT3-fs: mounted filesystem with ordered data mode.
[   27.164514] kjournald starting.  Commit interval 5 seconds
[   27.164600] EXT3 FS on dm-6, internal journal
[   27.164600] EXT3-fs: mounted filesystem with ordered data mode.
[   27.189944] kjournald starting.  Commit interval 5 seconds
[   27.362796] EXT3 FS on dm-2, internal journal
[   27.362796] EXT3-fs: mounted filesystem with ordered data mode.
[   27.222193] kjournald starting.  Commit interval 5 seconds
[   27.391590] EXT3 FS on dm-3, internal journal
[   27.391590] EXT3-fs: mounted filesystem with ordered data mode.
[   27.258451] kjournald starting.  Commit interval 5 seconds
[   27.427416] EXT3 FS on dm-7, internal journal
[   27.427599] EXT3-fs: mounted filesystem with ordered data mode.
[   27.384144] Adding 1466632k swap on /dev/mapper/sda2_crypt.  Priority:-1 extents:1 across:1466632k
[   32.711215] NET: Registered protocol family 10
[   32.711918] lo: Disabled Privacy Extensions
[   32.712524] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   32.551559] warning: `dnsmasq' uses 32-bit capabilities (legacy support in use)
[   36.159749] input: /usr/sbin/thinkpad-keys as /class/input/input10
[   45.981751] [drm] Initialized drm 1.1.0 20060810
[   45.774996] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[   45.775008] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   45.775144] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   79.182501] CPU0 attaching NULL sched-domain.
[   79.182515] CPU1 attaching NULL sched-domain.
[   79.198199] CPU0 attaching sched-domain:
[   79.198211]  domain 0: span 00000003
[   79.198216]   groups: 00000001 00000002
[   79.198225]   domain 1: span 00000003
[   79.198231]    groups: 00000003
[   79.198239]    domain 2: span 00000003
[   79.198245]     groups: 00000003
[   79.198255] CPU1 attaching sched-domain:
[   79.198259]  domain 0: span 00000003
[   79.198266]   groups: 00000002 00000001
[   79.198277]   domain 1: span 00000003
[   79.198282]    groups: 00000003
[   79.198291]    domain 2: span 00000003
[   79.198297]     groups: 00000003
[  265.894324] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  265.894598] PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 40100102, writing 40100106)
[  265.729358] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  298.433256] Clocksource tsc unstable (delta = -79336210 ns)
[  322.048949] wlan0: Initial auth_alg=0
[  322.048964] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[  322.050807] wlan0: RX authentication from 00:1e:8c:c2:69:11 (alg=0 transaction=2 status=0)
[  322.050816] wlan0: authenticated
[  322.050821] wlan0: associate with AP 00:1e:8c:c2:69:11
[  322.053159] wlan0: RX AssocResp from 00:1e:8c:c2:69:11 (capab=0x401 status=0 aid=2)
[  322.053167] wlan0: associated
[  322.053174] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[  322.053648] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  332.472685] wlan0: no IPv6 routers present
[  680.614734] iwl4965: Radio Frequency Kill Switch is On:
[  680.614734] Kill switch must be turned off for wireless networking to work.
[  931.931997] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[  935.327504] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[ 1119.136540] iwl4965: Radio Frequency Kill Switch is On:
[ 1119.136540] Kill switch must be turned off for wireless networking to work.
[ 2594.120264] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[ 2843.955397] iwl4965: Radio Frequency Kill Switch is On:
[ 2843.955397] Kill switch must be turned off for wireless networking to work.
[ 2953.944849] iwl4965: Radio Frequency Kill Switch is On:
[ 2953.944849] Kill switch must be turned off for wireless networking to work.
[ 8421.117981] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[ 8473.868506] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[ 8435.770170] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[ 9135.681703] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[ 9089.500007] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[13214.668329] CPU0 attaching NULL sched-domain.
[13214.668342] CPU1 attaching NULL sched-domain.
[13214.683599] CPU0 attaching sched-domain:
[13214.683608]  domain 0: span 00000003
[13214.683614]   groups: 00000001 00000002
[13214.683626]   domain 1: span 00000003
[13214.683632]    groups: 00000003
[13214.683641] CPU1 attaching sched-domain:
[13214.683647]  domain 0: span 00000003
[13214.683653]   groups: 00000002 00000001
[13214.683663]   domain 1: span 00000003
[13214.683669]    groups: 00000003
[13158.663582] Monitor-Mwait will be used to enter C-3 state
[14376.798882] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[14458.823214] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[19265.675170] PM: Syncing filesystems ... done.
[19267.116024] Freezing user space processes ... (elapsed 0.00 seconds) done.
[19267.116953] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[19339.014703] ACPI: Preparing to enter system sleep state S3
[19267.133996] Suspending console(s)
[19267.134049] drm_sysfs_suspend
[19267.134698] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[19267.150636] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[19339.043689] sd 0:0:0:0: [sda] Stopping disk
[19341.867386] ACPI handle has no context!
[19341.867425] ACPI: PCI interrupt for device 0000:05:00.2 disabled
[19341.867437] ACPI handle has no context!
[19341.890810] ACPI handle has no context!
[19341.950995] ACPI: PCI interrupt for device 0000:03:00.0 disabled
[19342.003143] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[19272.105840] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[19272.105948] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[19272.125116] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[19272.140851] ACPI: PCI interrupt for device 0000:00:1a.7 disabled
[19272.159439] ACPI: PCI interrupt for device 0000:00:1a.1 disabled
[19272.159545] ACPI: PCI interrupt for device 0000:00:1a.0 disabled
[19272.258080] ACPI: PCI interrupt for device 0000:00:19.0 disabled
[19272.276909] Disabling non-boot CPUs ...
[19272.276927] CPU0 attaching NULL sched-domain.
[19272.276931] CPU1 attaching NULL sched-domain.
[19272.304771] CPU 1 is now offline
[19272.304777] SMP alternatives: switching to UP code
[19272.307276] CPU0 attaching sched-domain:
[19272.307282]  domain 0: span 00000001
[19272.307286]   groups: 00000001
[19272.307684] CPU1 is down
[19272.307876] Extended CMOS year: 2000
[19272.307876] Back to C!
[19272.308310] Extended CMOS year: 2000
[19272.308451] Enabling non-boot CPUs ...
[19272.308727] CPU0 attaching NULL sched-domain.
[19272.317017] SMP alternatives: switching to SMP code
[19272.318890] Booting processor 1/2 APIC 0x1
[19342.206645] Initializing CPU#1
[19342.206645] Calibrating delay using timer specific routine.. 3192.42 BogoMIPS (lpj=6384841)
[19342.206645] CPU: L1 I cache: 32K, L1 D cache: 32K
[19342.206645] CPU: L2 cache: 4096K
[19342.206645] CPU 1/1 -> Node 0
[19342.206645] CPU: Physical Processor ID: 0
[19342.206645] CPU: Processor Core ID: 1
[19342.206645] Intel(R) Core(TM)2 Duo CPU     L7500  @ 1.60GHz stepping 0a
[19272.410206] CPU0 attaching sched-domain:
[19272.410212]  domain 0: span 00000003
[19272.410216]   groups: 00000001 00000002
[19272.410223]   domain 1: span 00000003
[19272.410226]    groups: 00000003
[19272.410232] CPU1 attaching sched-domain:
[19272.410235]  domain 0: span 00000003
[19272.410239]   groups: 00000002 00000001
[19272.410245]   domain 1: span 00000003
[19272.410248]    groups: 00000003
[19342.206645] CPU1 is up
[19342.206658] Switched to high resolution mode on CPU 1
[19342.702692] ACPI: EC: missing OBF confirmation, don't expect it any longer.
[19343.202722] ACPI: EC: missing write data confirmation, don't expect it any longer.
[19343.384037] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 900007, writing 900003)
[19343.397615] PM: Writing back config space on device 0000:00:02.1 at offset 1 (was 900000, writing 900007)
[19343.410881] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[19343.410892] PCI: Setting latency timer of device 0000:00:19.0 to 64
[19343.538926] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
[19343.538937] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[19343.539040] usb usb1: root hub lost power or was reset
[19343.539070] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[19343.539078] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[19343.539161] usb usb2: root hub lost power or was reset
[19343.555318] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
[19343.555328] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[19343.570834] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100106, writing 100102)
[19343.570889] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
[19343.570903] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[19343.570981] PM: Writing back config space on device 0000:00:1c.0 at offset 7 (was 20002020, writing 2020)
[19343.571010] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
[19343.571104] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[19343.571195] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
[19343.571290] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[19343.571302] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
[19343.571313] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[19343.571415] usb usb3: root hub lost power or was reset
[19343.571442] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
[19343.571452] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[19343.571551] usb usb4: root hub lost power or was reset
[19343.587139] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
[19343.587149] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[19343.587324] PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100007)
[19343.587365] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[19343.587535] ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
[19343.602825] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00007, writing 2b00407)
[19343.602922] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[19344.202792] wlan0: No ProbeResp from current AP 00:1e:8c:c2:69:11 - assume out of range
[19344.622861] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[19344.786859] PM: Writing back config space on device 0000:05:00.1 at offset 4 (was 0, writing d7efe800)
[19344.786871] PM: Writing back config space on device 0000:05:00.1 at offset 3 (was 800000, writing 804000)
[19344.786884] PM: Writing back config space on device 0000:05:00.1 at offset 1 (was 2100000, writing 2100006)
[19344.882856] PM: Writing back config space on device 0000:05:00.2 at offset 4 (was 0, writing d7efe400)
[19344.882867] PM: Writing back config space on device 0000:05:00.2 at offset 3 (was 800000, writing 804000)
[19344.882879] PM: Writing back config space on device 0000:05:00.2 at offset 1 (was 2100000, writing 2100006)
[19344.882909] ACPI: PCI Interrupt 0000:05:00.2[C] -> GSI 18 (level, low) -> IRQ 18
[19275.292939] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[19275.294415] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[19275.294422] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[19275.294517] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[19275.294930] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[19275.296957] ata1.00: configured for UDMA/100
[19275.314914] ata1.00: configured for UDMA/100
[19275.314919] ata1: EH complete
[19275.314993] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[19275.315025] sd 0:0:0:0: [sda] Write Protect is off
[19275.315029] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[19275.315078] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[19275.315151] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[19275.315185] sd 0:0:0:0: [sda] Write Protect is off
[19275.315189] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[19275.315248] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[19275.948997] sd 0:0:0:0: [sda] Starting disk
[19275.971329] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[19275.975112] Restarting tasks ... done.
[19276.079689] usb 1-2: USB disconnect, address 4
[19276.323116] usb 1-2: new full speed USB device using uhci_hcd and address 5
[19276.496136] usb 1-2: configuration #1 chosen from 1 choice
[19276.499207] usb 1-2: New USB device found, idVendor=0483, idProduct=2016
[19276.499219] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[19276.499224] usb 1-2: Product: Biometric Coprocessor
[19276.499229] usb 1-2: Manufacturer: STMicroelectronics
[19278.144338] CPU0 attaching NULL sched-domain.
[19278.144354] CPU1 attaching NULL sched-domain.
[19278.166498] CPU0 attaching sched-domain:
[19278.166508]  domain 0: span 00000003
[19278.166514]   groups: 00000001 00000002
[19278.166522]   domain 1: span 00000003
[19278.166526]    groups: 00000003
[19278.166532]    domain 2: span 00000003
[19278.166536]     groups: 00000003
[19278.166543] CPU1 attaching sched-domain:
[19278.166547]  domain 0: span 00000003
[19278.166552]   groups: 00000002 00000001
[19278.166559]   domain 1: span 00000003
[19278.166563]    groups: 00000003
[19278.166568]    domain 2: span 00000003
[19278.166572]     groups: 00000003
[19357.271066] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: None
[19357.271077] eth0: 10/100 speed: disabling TSO
[19357.271542] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[19367.818051] eth0: no IPv6 routers present
[24115.686439] CPU0 attaching NULL sched-domain.
[24115.686453] CPU1 attaching NULL sched-domain.
[24115.702001] CPU0 attaching sched-domain:
[24115.702009]  domain 0: span 00000003
[24115.702015]   groups: 00000001 00000002
[24115.702027]   domain 1: span 00000003
[24115.702034]    groups: 00000003
[24115.702044] CPU1 attaching sched-domain:
[24115.702049]  domain 0: span 00000003
[24115.702055]   groups: 00000002 00000001
[24115.702065]   domain 1: span 00000003
[24115.702071]    groups: 00000003
[26522.694250] kjournald starting.  Commit interval 5 seconds
[26296.358220] EXT3 FS on dm-1, internal journal
[26296.358231] EXT3-fs: mounted filesystem with ordered data mode.
[26524.631748] kjournald starting.  Commit interval 5 seconds
[26298.256278] EXT3 FS on dm-10, internal journal
[26298.256291] EXT3-fs: mounted filesystem with ordered data mode.
[49381.131232] eth0: Link is Down
[49393.671415] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: None
[49393.671427] eth0: 10/100 speed: disabling TSO
[49394.784694] eth0: Link is Down
[49398.113855] eth0: Link is Up 100 Mbps Full Duplex, Flow Control: None
[49398.113866] eth0: 10/100 speed: disabling TSO
[52652.739716] PM: Syncing filesystems ... done.
[52653.725780] eth0: Link is Down
[51665.923022] Freezing user space processes ... (elapsed 0.08 seconds) done.
[51666.008247] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[51666.011360] ACPI: Preparing to enter system sleep state S3
[51666.022650] Suspending console(s)
[51666.030158] drm_sysfs_suspend
[51666.030637] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[51666.046220] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[51666.047444] sd 0:0:0:0: [sda] Stopping disk
[51668.811978] ACPI handle has no context!
[51668.812015] ACPI: PCI interrupt for device 0000:05:00.2 disabled
[51668.812027] ACPI handle has no context!
[51668.835612] ACPI handle has no context!
[51668.899678] ACPI: PCI interrupt for device 0000:03:00.0 disabled
[51668.947799] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[51668.966641] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[51668.966697] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[51668.979867] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[51668.995693] ACPI: PCI interrupt for device 0000:00:1a.7 disabled
[51669.013536] ACPI: PCI interrupt for device 0000:00:1a.1 disabled
[51669.013643] ACPI: PCI interrupt for device 0000:00:1a.0 disabled
[51669.108885] ACPI: PCI interrupt for device 0000:00:19.0 disabled
[51669.123730] Disabling non-boot CPUs ...
[51669.123750] CPU0 attaching NULL sched-domain.
[51669.123754] CPU1 attaching NULL sched-domain.
[51669.239564] CPU 1 is now offline
[51669.239570] SMP alternatives: switching to UP code
[51669.242009] CPU0 attaching sched-domain:
[51669.242015]  domain 0: span 00000001
[51669.242018]   groups: 00000001
[51669.242415] CPU1 is down
[51669.242596] Extended CMOS year: 2000
[51669.242596] Back to C!
[51669.243028] Extended CMOS year: 2000
[51669.243169] Enabling non-boot CPUs ...
[51669.243477] CPU0 attaching NULL sched-domain.
[51669.251849] SMP alternatives: switching to SMP code
[51669.253720] Booting processor 1/2 APIC 0x1
[52661.785182] Initializing CPU#1
[52661.785182] Calibrating delay using timer specific routine.. 3191.83 BogoMIPS (lpj=6383678)
[52661.785182] CPU: L1 I cache: 32K, L1 D cache: 32K
[52661.785182] CPU: L2 cache: 4096K
[52661.785182] CPU 1/1 -> Node 0
[52661.785182] CPU: Physical Processor ID: 0
[52661.785182] CPU: Processor Core ID: 1
[52661.785182] Intel(R) Core(TM)2 Duo CPU     L7500  @ 1.60GHz stepping 0a
[51669.345033] CPU0 attaching sched-domain:
[51669.345038]  domain 0: span 00000003
[51669.345042]   groups: 00000001 00000002
[51669.345049]   domain 1: span 00000003
[51669.345052]    groups: 00000003
[51669.345058] CPU1 attaching sched-domain:
[51669.345061]  domain 0: span 00000003
[51669.345065]   groups: 00000002 00000001
[51669.345071]   domain 1: span 00000003
[51669.345074]    groups: 00000003
[52661.785182] CPU1 is up
[52661.785193] Switched to high resolution mode on CPU 1
[52661.961948] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 900007, writing 900003)
[52661.981273] PM: Writing back config space on device 0000:00:02.1 at offset 1 (was 900000, writing 900007)
[52661.997400] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[52661.997416] PCI: Setting latency timer of device 0000:00:19.0 to 64
[52662.125386] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
[52662.125396] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[52662.125502] usb usb1: root hub lost power or was reset
[52662.125529] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[52662.125536] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[52662.125628] usb usb2: root hub lost power or was reset
[52662.141594] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
[52662.141605] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[52662.157308] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100106, writing 100102)
[52662.157360] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
[52662.157374] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[52662.589482] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
[52662.589573] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[52662.589659] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
[52662.589751] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[52662.589768] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
[52662.589783] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[52662.589884] usb usb3: root hub lost power or was reset
[52662.589921] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
[52662.589932] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[52662.590033] usb usb4: root hub lost power or was reset
[52662.605752] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
[52662.605767] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[52662.605999] PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100007)
[52662.606063] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[52662.606286] ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
[52662.621354] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00007, writing 2b00407)
[52662.621491] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[52663.641365] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[52663.807129] PM: Writing back config space on device 0000:05:00.1 at offset 4 (was 0, writing d7efe800)
[52663.807141] PM: Writing back config space on device 0000:05:00.1 at offset 3 (was 800000, writing 804000)
[52663.807155] PM: Writing back config space on device 0000:05:00.1 at offset 1 (was 2100000, writing 2100006)
[52663.901561] PM: Writing back config space on device 0000:05:00.2 at offset 4 (was 0, writing d7efe400)
[52663.901573] PM: Writing back config space on device 0000:05:00.2 at offset 3 (was 800000, writing 804000)
[52663.901585] PM: Writing back config space on device 0000:05:00.2 at offset 1 (was 2100000, writing 2100006)
[52663.901617] ACPI: PCI Interrupt 0000:05:00.2[C] -> GSI 18 (level, low) -> IRQ 18
[51671.665174] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[51671.667346] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[51671.667354] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[51671.667458] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[51671.667887] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
[51671.671061] ata1.00: configured for UDMA/100
[51671.687586] ata1.00: configured for UDMA/100
[51671.687595] ata1: EH complete
[51671.687684] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[51671.687715] sd 0:0:0:0: [sda] Write Protect is off
[51671.687720] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[51671.687770] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[51671.687822] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[51671.687850] sd 0:0:0:0: [sda] Write Protect is off
[51671.687855] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[51671.687903] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[51672.345730] sd 0:0:0:0: [sda] Starting disk
[51672.372388] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[51672.376157] Restarting tasks ... <6>usb 1-2: USB disconnect, address 5
[51672.398984] done.
[51672.636627] usb 1-2: new full speed USB device using uhci_hcd and address 6
[51672.807666] usb 1-2: configuration #1 chosen from 1 choice
[51672.809301] usb 1-2: New USB device found, idVendor=0483, idProduct=2016
[51672.809301] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[51672.809301] usb 1-2: Product: Biometric Coprocessor
[51672.809301] usb 1-2: Manufacturer: STMicroelectronics
[52673.903227] CPU0 attaching NULL sched-domain.
[52673.903237] CPU1 attaching NULL sched-domain.
[52673.919380] CPU0 attaching sched-domain:
[52673.919385]  domain 0: span 00000003
[52673.919388]   groups: 00000001 00000002
[52673.919393]   domain 1: span 00000003
[52673.919396]    groups: 00000003
[52673.919400]    domain 2: span 00000003
[52673.919403]     groups: 00000003
[52673.919408] CPU1 attaching sched-domain:
[52673.919410]  domain 0: span 00000003
[52673.919413]   groups: 00000002 00000001
[52673.919419]   domain 1: span 00000003
[52673.919422]    groups: 00000003
[52673.919426]    domain 2: span 00000003
[52673.919429]     groups: 00000003
[53444.626302] wlan0: Initial auth_alg=0
[53444.626316] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[53444.630662] wlan0: RX authentication from 00:1e:8c:c2:69:11 (alg=0 transaction=2 status=0)
[53444.630672] wlan0: authenticated
[53444.630678] wlan0: associate with AP 00:1e:8c:c2:69:11
[53444.633006] wlan0: RX ReassocResp from 00:1e:8c:c2:69:11 (capab=0x401 status=0 aid=1)
[53444.633016] wlan0: associated
[53608.945804] wlan0: No ProbeResp from current AP 00:1e:8c:c2:69:11 - assume out of range
[52632.174740] wlan0: Initial auth_alg=0
[52632.174757] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[52632.367792] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[52632.561790] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[52632.754056] wlan0: authentication with AP 00:1e:8c:c2:69:11 timed out
[52690.574896] ACPI: PCI interrupt for device 0000:03:00.0 disabled
[52695.643489] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[52695.643642] PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100102, writing 100106)
[52695.842121] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[53726.399446] wlan0: Initial auth_alg=0
[53726.399460] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[53726.600936] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[53726.798817] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[53726.997283] wlan0: authentication with AP 00:1e:8c:c2:69:11 timed out
[52738.570901] ACPI: PCI interrupt for device 0000:03:00.0 disabled
[52741.838968] iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.23ks
[52741.838980] iwl4965: Copyright(c) 2003-2007 Intel Corporation
[52741.839095] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[52741.839121] PCI: Setting latency timer of device 0000:03:00.0 to 64
[52741.839154] iwl4965: Detected Intel Wireless WiFi Link 4965AGN
[52741.877089] iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
[52741.879232] phy1: Selected rate control algorithm 'iwl-4965-rs'
[53760.096722] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[52747.730476] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[53828.189345] wlan0: Initial auth_alg=0
[53828.189362] wlan0: authenticate with AP 00:1e:8c:c2:69:11
[53828.191175] wlan0: RX authentication from 00:1e:8c:c2:69:11 (alg=0 transaction=2 status=0)
[53828.191186] wlan0: authenticated
[53828.191193] wlan0: associate with AP 00:1e:8c:c2:69:11
[52815.413069] wlan0: RX AssocResp from 00:1e:8c:c2:69:11 (capab=0x401 status=0 aid=1)
[52815.413080] wlan0: associated
[52815.413555] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[52825.392500] wlan0: no IPv6 routers present
[55885.767377] wlan0: switched to long barker preamble (BSSID=00:1e:8c:c2:69:11)
[55892.615043] wlan0: switched to short barker preamble (BSSID=00:1e:8c:c2:69:11)
[57517.579895] usb 6-1: new high speed USB device using ehci_hcd and address 2
[57517.704417] usb 6-1: configuration #1 chosen from 1 choice
[57517.706167] usb 6-1: New USB device found, idVendor=0402, idProduct=5661
[57517.706177] usb 6-1: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[57517.706182] usb 6-1: Product: i.Beat xtension
[57517.706188] usb 6-1: Manufacturer: Trekstor
[57517.706193] usb 6-1: SerialNumber: 00403054202000000165
[57519.306005] Initializing USB Mass Storage driver...
[57519.309917] scsi3 : SCSI emulation for USB Mass Storage devices
[58583.308166] usb-storage: device found at 2
[58583.308175] usb-storage: waiting for device to settle before scanning
[57519.310491] usbcore: registered new interface driver usb-storage
[57519.310500] USB Mass Storage support registered.
[57524.050877] usb-storage: device scan complete
[57524.051586] scsi 3:0:0:0: Direct-Access              i.Beat xtension       PQ: 0 ANSI: 0 CCS
[57524.052178] scsi 3:0:0:1: Direct-Access              SD/MMC CARD           PQ: 0 ANSI: 0 CCS
[57524.057857] sd 3:0:0:0: [sdb] 4082688 512-byte hardware sectors (2090 MB)
[57524.058456] sd 3:0:0:0: [sdb] Write Protect is off
[57524.058468] sd 3:0:0:0: [sdb] Mode Sense: 3b 00 00 00
[57524.058473] sd 3:0:0:0: [sdb] Assuming drive cache: write through
[57524.061200] sd 3:0:0:0: [sdb] 4082688 512-byte hardware sectors (2090 MB)
[57524.061831] sd 3:0:0:0: [sdb] Write Protect is off
[57524.061842] sd 3:0:0:0: [sdb] Mode Sense: 3b 00 00 00
[57524.061847] sd 3:0:0:0: [sdb] Assuming drive cache: write through
[57524.061854]  sdb: sdb1
[57524.063241] sd 3:0:0:0: [sdb] Attached SCSI removable disk
[57524.064825] sd 3:0:0:1: [sdc] Attached SCSI removable disk
[57528.627797] FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[57869.994889] usb 6-1: USB disconnect, address 2
[60771.780346] iwl4965: Radio Frequency Kill Switch is On:
[60771.780346] Kill switch must be turned off for wireless networking to work.
[60771.902680] iwl4965/1: page allocation failure. order:5, mode:0x1024
[60771.902687] Pid: 10936, comm: iwl4965/1 Not tainted 2.6.25-rc7-amd64 #1
[60771.902689] 
[60771.902690] Call Trace:
[60771.902722]  [<ffffffff80276f47>] __alloc_pages+0x2f8/0x311
[60771.902737]  [<ffffffff80211586>] dma_alloc_pages+0xb2/0xf2
[60771.902742]  [<ffffffff80211645>] dma_alloc_coherent+0x7f/0x1d2
[60771.902760]  [<ffffffff88219db1>] :iwl4965:iwl4965_tx_queue_init+0x63/0x1d5
[60771.902778]  [<ffffffff8821e0a1>] :iwl4965:iwl4965_hw_nic_init+0x7a1/0xa88
[60771.902794]  [<ffffffff882114f9>] :iwl4965:__iwl4965_up+0xbd/0x530
[60771.902799]  [<ffffffff8022be91>] __wake_up+0x38/0x4e
[60771.902815]  [<ffffffff88215aa0>] :iwl4965:iwl4965_bg_up+0x2d/0x3c
[60771.902826]  [<ffffffff88215a73>] :iwl4965:iwl4965_bg_up+0x0/0x3c
[60771.902830]  [<ffffffff8024383c>] run_workqueue+0x82/0x111
[60771.902836]  [<ffffffff80244142>] worker_thread+0xd5/0xe0
[60771.902843]  [<ffffffff80246948>] autoremove_wake_function+0x0/0x2e
[60771.902850]  [<ffffffff8024406d>] worker_thread+0x0/0xe0
[60771.902853]  [<ffffffff8024681f>] kthread+0x47/0x74
[60771.902857]  [<ffffffff802302bb>] schedule_tail+0x27/0x5c
[60771.902863]  [<ffffffff8020cf28>] child_rip+0xa/0x12
[60771.902877]  [<ffffffff802467d8>] kthread+0x0/0x74
[60771.902881]  [<ffffffff8020cf1e>] child_rip+0x0/0x12
[60771.902885] 
[60771.902886] Mem-info:
[60771.902888] Node 0 DMA per-cpu:
[60771.902891] CPU    0: hi:    0, btch:   1 usd:   0
[60771.902894] CPU    1: hi:    0, btch:   1 usd:   0
[60771.902896] Node 0 DMA32 per-cpu:
[60771.902898] CPU    0: hi:  186, btch:  31 usd: 137
[60771.902901] CPU    1: hi:  186, btch:  31 usd: 137
[60771.902904] Active:191493 inactive:25155 dirty:1 writeback:1 unstable:0
[60771.902906]  free:2463 slab:8375 mapped:8556 pagetables:3959 bounce:0
[60771.902908] Node 0 DMA free:3908kB min:44kB low:52kB high:64kB active:6956kB inactive:484kB present:11352kB pages_scanned:0 all_unreclaimable? no
[60771.902913] lowmem_reserve[]: 0 969 969 969
[60771.902917] Node 0 DMA32 free:5944kB min:3956kB low:4944kB high:5932kB active:759016kB inactive:100136kB present:992516kB pages_scanned:313 all_unreclaimable? no
[60771.902923] lowmem_reserve[]: 0 0 0 0
[60771.902927] Node 0 DMA: 51*4kB 7*8kB 0*16kB 0*32kB 1*64kB 0*128kB 0*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 3908kB
[60771.902937] Node 0 DMA32: 556*4kB 241*8kB 26*16kB 15*32kB 12*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 5944kB
[60771.902946] 65971 total pagecache pages
[60771.902949] Swap cache: add 679034, delete 630283, find 248830/299812
[60771.902952] Free swap  = 805488kB
[60771.902953] Total swap = 1466632kB
[60771.902955] Free swap:       805480kB
[60771.909004] 255664 pages of RAM
[60771.909006] 4748 reserved pages
[60771.909008] 59139 pages shared
[60771.909009] 48818 pages swap cached
[60771.909012] iwl4965: Tx 13 queue init failed
[60771.909041] iwl4965: Unable to int nic
[59685.357807] wlan0: No ProbeResp from current AP 00:1e:8c:c2:69:11 - assume out of range



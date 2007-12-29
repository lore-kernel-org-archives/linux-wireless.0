Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.238]:39613 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbXL2JnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 04:43:01 -0500
Received: by wx-out-0506.google.com with SMTP id h31so1105658wxd.4
        for <linux-wireless@vger.kernel.org>; Sat, 29 Dec 2007 01:43:01 -0800 (PST)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: linux-wireless@vger.kernel.org
Subject: Warning emited by 2.6.24-rc6-git5
Date: Sat, 29 Dec 2007 09:42:37 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712290942.37396.chris2553@googlemail.com> (sfid-20071229_094310_096852_2D0A533D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Please cc me on any reply - I'm not subscribed.

I've just built and installed 2.6.24-rc6-git5 and noticed the following 
warning when I rebooted.

WARNING: at net/mac80211/rx.c:1486 __ieee80211_rx()
Pid: 0, comm: swapper Not tainted 2.6.24-rc6-git5 #11
 [<dc916f6a>] __ieee80211_rx+0x4da/0x4f0 [mac80211]
 [<c0115021>] enqueue_task_fair+0x21/0x30
 [<c0114dfd>] enqueue_entity+0x3d/0x70
 [<dc908072>] ieee80211_tasklet_handler+0xb2/0xe0 [mac80211]
 [<c01171e2>] enqueue_task+0x12/0x30
 [<c012c32c>] rcu_do_batch+0x1c/0x80
 [<c0120778>] tasklet_action+0x38/0x60
 [<c0120584>] __do_softirq+0x74/0x90
 [<c0105ef6>] do_softirq+0x46/0xc0
 [<c0141db0>] handle_level_irq+0x0/0x100
 [<c0120635>] irq_exit+0x65/0x70
 [<c0105daf>] do_IRQ+0x6f/0xc0
 [<c011440a>] __update_rq_clock+0x1a/0xf0
 [<c01042e3>] common_interrupt+0x23/0x28
 [<c014007b>] do_acct_process+0x16b/0x2f0
 [<c011007b>] acpi_copy_wakeup_routine+0x2b/0x9c
 [<c0219d53>] acpi_processor_idle+0x25b/0x36e
 [<c01020dc>] cpu_idle+0x5c/0x80
 [<c041181b>] start_kernel+0x18b/0x1d0
 [<c0411360>] unknown_bootoption+0x0/0x150


lspci shows my wireless card to be RaLink RT2561/RT61 802.11g PCI. It's a 
Belkin F5D7010. The driver (rt61pci) is built as a module. Despite the 
warning, networking sees to be working OK.

In case it helps, the complete output from dmesg follows (The odd-looking mac 
address for my AP is my alteration)

Linux version 2.6.24-rc6-git5 (chris@linlap) (gcc version 3.3.6) #11 PREEMPT 
Sat Dec 29 09:04:49 UTC 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001bff0000 (usable)
 BIOS-e820: 000000001bff0000 - 000000001bff3800 (reserved)
 BIOS-e820: 000000001bff3800 - 000000001c000000 (ACPI NVS)
447MB LOWMEM available.
Entering add_active_range(0, 0, 114672) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   114672
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   114672
On node 0 totalpages: 114672
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 863 pages used for memmap
  Normal zone: 109713 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F9970, 0014 (r0 COMPAQ)
ACPI: RSDT 1BFF4800, 0028 (r1 COMPAQ RSDB130         1 CPQ         1)
ACPI: FACP 1BFF4828, 0074 (r1 COMPAQ CPQB10F  20010122 CPQ         1)
ACPI: DSDT 1BFF48A0, 8812 (r1 COMPAQ ARMADAE7    10000 MSFT  100000C)
ACPI: FACS 1BFFFE80, 0040
ACPI: PM-Timer IO Port: 0x5008
Allocating PCI resources starting at 20000000 (gap: 1c000000:e4000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 113777
Kernel command line: root=/dev/hda3 ro pci=routeirq noirda
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c043e000 soft=c043d000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 846.322 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 450696k/458688k available (2260k kernel code, 7432k reserved, 872k 
data, 164k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffff6000 - 0xfffff000   (  36 kB)
    vmalloc : 0xdc800000 - 0xffff4000   ( 567 MB)
    lowmem  : 0xc0000000 - 0xdbff0000   ( 447 MB)
      .init : 0xc0411000 - 0xc043a000   ( 164 kB)
      .data : 0xc0335115 - 0xc040f1e0   ( 872 kB)
      .text : 0xc0100000 - 0xc0335115   (2260 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1693.85 BogoMIPS 
(lpj=3387703)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff 00000000 00000000 00000000 
00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040 00000000 
00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: Intel Pentium III (Coppermine) stepping 0a
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0800)
net_namespace: 64 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0478, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [C005] (0000:00)
PCI quirk: region 5000-503f claimed by PIIX4 ACPI
PCI quirk: region 4000-400f claimed by PIIX4 SMB
PIIX4 devres C PIO at 0100-0107
PIIX4 devres I PIO at 00e0-00e3
PIIX4 devres J PIO at 00f8-00fb
ACPI: PCI Interrupt Routing Table [\_SB_.C005._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C005.C012._PRT]
ACPI: PCI Interrupt Link [C17E] (IRQs *11)
ACPI: PCI Interrupt Link [C184] (IRQs 11) *0, disabled.
ACPI: PCI Interrupt Link [C185] (IRQs *11)
ACPI: PCI Interrupt Link [C186] (IRQs *11)
ACPI: Power Resource [C133] (on)
ACPI: Power Resource [C0E5] (on)
ACPI: Power Resource [C19B] (off)
ACPI: Power Resource [C19D] (off)
ACPI: Power Resource [C19F] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: Routing PCI interrupts for all devices because "pci=routeirq" specified
ACPI: PCI Interrupt Link [C17E] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [C17E] -> GSI 11 (level, low) -> 
IRQ 11
ACPI: PCI Interrupt 0000:00:04.1[A] -> Link [C17E] -> GSI 11 (level, low) -> 
IRQ 11
ACPI: PCI Interrupt Link [C186] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [C186] -> GSI 11 (level, low) -> 
IRQ 11
ACPI: PCI Interrupt Link [C185] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [C185] -> GSI 11 (level, low) -> 
IRQ 11
ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [C185] -> GSI 11 (level, low) -> 
IRQ 11
ACPI: PCI Interrupt 0000:00:09.1[A] -> Link [C185] -> GSI 11 (level, low) -> 
IRQ 11
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [C17E] -> GSI 11 (level, low) -> 
IRQ 11
Time: tsc clocksource has been installed.
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0c: ioport range 0x800-0x87f has been reserved
system 00:0c: ioport range 0x4000-0x400f has been reserved
system 00:0c: ioport range 0x5000-0x5063 could not be reserved
system 00:0c: ioport range 0x6004-0x6005 has been reserved
system 00:0c: ioport range 0xf000-0xf0cf has been reserved
system 00:0d: iomem range 0xd1800-0xd3fff has been reserved
system 00:0d: iomem range 0xfff80000-0xffffffff has been reserved
system 00:0e: iomem range 0x0-0x9ffff could not be reserved
system 00:0e: iomem range 0xf0000-0xfffff could not be reserved
system 00:0e: iomem range 0x100000-0x1bffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 2000-2fff
  MEM window: 40000000-410fffff
  PREFETCH window: 30000000-300fffff
PCI: Bus 2, cardbus bridge: 0000:00:04.0
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 20000000-23ffffff
  MEM window: 24000000-27ffffff
PCI: Bus 6, cardbus bridge: 0000:00:04.1
  IO window: 00001800-000018ff
  IO window: 00001c00-00001cff
  PREFETCH window: 28000000-2bffffff
  MEM window: 2c000000-2fffffff
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [C17E] -> GSI 11 (level, low) -> 
IRQ 11
ACPI: PCI Interrupt 0000:00:04.1[A] -> Link [C17E] -> GSI 11 (level, low) -> 
IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
io scheduler noop registered
io scheduler cfq registered (default)
Limiting direct PCI/PCI transfers.
PCI: Firmware left 0000:00:09.0 e100 interrupts enabled, disabling
Boot video device is 0000:01:00.0
ACPI: AC Adapter [C105] (on-line)
ACPI: Battery Slot [C10D] (battery present)
ACPI: Battery Slot [C10E] (battery absent)
input: Power Button (FF) as /devices/virtual/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /devices/virtual/input/input1
ACPI: Sleep Button (CM) [C057]
input: Lid Switch as /devices/virtual/input/input2
ACPI: Lid Switch [C1A5]
ACPI: Fan [C199] (off)
ACPI: Fan [C19C] (off)
ACPI: Fan [C19E] (off)
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [C0BE] (supports 8 throttling states)
ACPI: Thermal Zone [C19A] (49 C)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Switched to NOHz mode on CPU #0
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
agpgart: Detected an Intel 440BX Chipset.
agpgart: AGP aperture is 64M @ 0x50000000
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
00:01: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ACPI: PCI Interrupt 0000:00:09.1[A] -> Link [C185] -> GSI 11 (level, low) -> 
IRQ 11
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller (0x8086:0x7111 rev 0x01) at  PCI slot 0000:00:07.1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x3460-0x3467, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0x3468-0x346f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
Marking TSC unstable due to: possible TSC halt in C2.
Time: acpi_pm clocksource has been installed.
hdb: Compaq DVD-ROM SD-C2402, ATAPI CD/DVD-ROM drive
Clocksource tsc unstable (delta = -3173924566 ns)
hda: HITACHI_DK23BA-20, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Probing IDE interface ide1...
hda: max request size: 128KiB
hda: 39070080 sectors (20003 MB) w/2048KiB Cache, CHS=38760/16/63
hda: cache flushes not supported
 hda: hda1 hda2 hda3 hda4
hdb: ATAPI 24X DVD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20
PNP: PS/2 Controller [PNP0303:C0E2,PNP0f0e:C0E3] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.0.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input3
Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20 19:16:42 
2007 UTC).
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [C185] -> GSI 11 (level, low) -> 
IRQ 11
IBM TrackPoint firmware: 0x0b, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio4/input/input4
input: AT Translated Set 2 keyboard 
as /devices/platform/i8042/serio0/input/input5
es1968: clocking to 48000
ALSA device list:
  #0: ESS ES1978 (Maestro 2E) at 0x3000, irq 11
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 15
Using IPI Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 164k freed
EXT3 FS on hda3, internal journal
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [C186] -> GSI 11 (level, low) -> 
IRQ 11
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x00003440
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
parport_pc 00:04: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
NET: Registered protocol family 23
Yenta: CardBus bridge found at 0000:00:04.0 [0e11:b113]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:04.0, mfunc 0x00000001, devctl 0x64
found SMC SuperIO Chip (devid=0x0a rev=00 base=0x00e0): FDC37N971
smsc_ircc_present: can't get sir_base of 0x3e8
Yenta: ISA IRQ mask 0x0478, PCI irq 11
Socket status: 30000006
Yenta: CardBus bridge found at 0000:00:04.1 [0e11:b113]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:04.1, mfunc 0x00000001, devctl 0x64
Yenta: ISA IRQ mask 0x0478, PCI irq 11
Socket status: 30000020
ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [C185] -> GSI 11 (level, low) -> 
IRQ 11
e100: eth0: e100_probe: addr 0x41280000, irq 11, MAC addr 00:d0:59:37:5c:f9
pccard: CardBus card inserted into slot 1
PCI: Enabling device 0000:06:00.0 (0000 -> 0002)
ACPI: PCI Interrupt 0000:06:00.0[A] -> Link [C17E] -> GSI 11 (level, low) -> 
IRQ 11
PCI: Setting latency timer of device 0000:06:00.0 to 64
phy0: Selected rate control algorithm 'simple'
cs: IO port probe 0xc00-0xcff: clean.
cs: IO port probe 0x800-0x8ff: clean.
cs: IO port probe 0x100-0x4ff: excluding 0x100-0x107
cs: IO port probe 0xa00-0xaff: clean.
cs: IO port probe 0xc00-0xcff: clean.
cs: IO port probe 0x800-0x8ff: clean.
cs: IO port probe 0x100-0x4ff: excluding 0x100-0x107
cs: IO port probe 0xa00-0xaff: clean.
WARNING: at net/mac80211/rx.c:1486 __ieee80211_rx()
Pid: 0, comm: swapper Not tainted 2.6.24-rc6-git5 #11
 [<dc916f6a>] __ieee80211_rx+0x4da/0x4f0 [mac80211]
 [<c0115021>] enqueue_task_fair+0x21/0x30
 [<c0114dfd>] enqueue_entity+0x3d/0x70
 [<dc908072>] ieee80211_tasklet_handler+0xb2/0xe0 [mac80211]
 [<c01171e2>] enqueue_task+0x12/0x30
 [<c012c32c>] rcu_do_batch+0x1c/0x80
 [<c0120778>] tasklet_action+0x38/0x60
 [<c0120584>] __do_softirq+0x74/0x90
 [<c0105ef6>] do_softirq+0x46/0xc0
 [<c0141db0>] handle_level_irq+0x0/0x100
 [<c0120635>] irq_exit+0x65/0x70
 [<c0105daf>] do_IRQ+0x6f/0xc0
 [<c011440a>] __update_rq_clock+0x1a/0xf0
 [<c01042e3>] common_interrupt+0x23/0x28
 [<c014007b>] do_acct_process+0x16b/0x2f0
 [<c011007b>] acpi_copy_wakeup_routine+0x2b/0x9c
 [<c0219d53>] acpi_processor_idle+0x25b/0x36e
 [<c01020dc>] cpu_idle+0x5c/0x80
 [<c041181b>] start_kernel+0x18b/0x1d0
 [<c0411360>] unknown_bootoption+0x0/0x150
 =======================
Adding 498952k swap on /dev/hda4.  Priority:-1 extents:1 across:498952k
wlan0: Initial auth_alg=0
wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
wlan0: RX authentication from XX:XX:XX:XX:XX:XX (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP XX:XX:XX:XX:XX:XX
wlan0: RX AssocResp from XX:XX:XX:XX:XX:XX (capab=0x1 status=0 aid=1)
wlan0: associated
cpufreq: change failed with new_state 0 and result 2
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (7168 buckets, 28672 max)
NET: Unregistered protocol family 23
parport_pc 00:04: disabled
ACPI: PCI interrupt for device 0000:00:09.0 disabled
cpufreq: change failed with new_state 0 and result 2

-- 
Beer is proof that God loves us and wants us to be happy - Benjamin Franklin

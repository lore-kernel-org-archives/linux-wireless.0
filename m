Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.brikks.com ([82.209.166.4]:17987 "EHLO smtp.bredband2.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754098AbYLGOE1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 09:04:27 -0500
Date: Sun, 7 Dec 2008 15:04:20 +0100
From: Mats Johannesson <spamcan1@abrasax.se>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath9k] 2.6.28-rc7-wl Kernel panic when "iwlist ath0 scan" as
 root
Message-ID: <20081207150420.0f688772@loke.fish.not> (sfid-20081207_150432_968415_ED73DD5E)
In-Reply-To: <18747.15541.811292.500184@localhost.localdomain>
References: <20081206113406.734f1d94@loke.fish.not>
	<18746.37273.989918.333164@localhost.localdomain>
	<20081206180537.717d1791@loke.fish.not>
	<18746.48068.593834.660064@localhost.localdomain>
	<20081206202237.578b3783@loke.fish.not>
	<18747.15541.811292.500184@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 7 Dec 2008 08:32:13 +0530 Sujith wrote:
> Mats Johannesson wrote:
> > Sorry to say, no change. After root scan telnet gives "no route to
> > host" and ping just reports 100% packet loss. But iwconfig keeps
> > updating its info regarding link quality and signal strength, like:
> > Link Quality=82/100  Signal level:-42 dBm
> > 
> 
> Which channel are you using ? And is it HT40 ?

I've seen you asking this from other users, and like them I don't know
about that HT-prefix. All i can give you is the configuration of my AP:

_D-Link DIR-655 Access Point_
Security Mode: WPA-Personal
WPA Mode: WPA2 Only
Cipher Type: AES
802.11 Mode : 802.11n only
Wireless Channel : 2.412 GHz - CH 1
Transmission Rate: Best (automatic)
Channel Width: Auto 20/40 MHz

So if it's the channel width you're asking about, then I have no user
control of the 40 MHz. I can only choose 20 MHz or this Auto 20/40 MHz.
The AP calls the shots here...

> Also please post the debug log, you can do 'insmod ath9k
> debug=0x00002000' to get a fair amount of debug information.

Yeah, if I had had CONFIG_ATH9K_DEBUG=y set, yes ;-) OK, ran a new
kernel (using the two patches you posted) and /etc/modprobe.d/options
containing "options ath9k debug=0x00002000". Didn't have the patience
to brush up on manual wifi juggling with all the ifconfig, route,
iwconfig, wpa_supplicant, dhclient options. Just using the system as it
was during the prior runs.

Here's the full log since I have no idea what can be considered
important. Machine is a notebook AMD Athlon(tm) 64 Processor 3400+ with
2 gig memory.

_PCCard D-Link DWA-652_
loke at sleipner:~$ lspci
[...]
02:00.0 Network controller: Atheros Communications, Inc. AR5416
802.11a/b/g/n Wireless PCI Adapter (rev 01)

The max throughput is not good, as you do know. 25 Mbits/sec on a sunny
day with a good driver, 4.7 metres (15.4 feet) from the AP. And yes, I
do have:

CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"

Booted machine at 13:24:23. Pinged local and external machines around
13:25:10. Another ping session at 13:29:00 just to make sure the net
still was ok. "iwlist ath0 scan" around 13:31:00. Tried ping
unsuccessfully after that. Waited another five minutes, but nothing
else showed up in the logs.

/var/log/kern.log:

13:24:23 : Inspecting /boot/System.map-2.6.28-rc7-debug-wl
13:24:23 : Cannot find map file.
13:24:23 : No module symbols loaded - kernel modules not enabled. 
13:24:23 : 000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
13:24:23 : pci 0000:00:0b.0: PME# disabled
13:24:23 : pci 0000:00:0b.1: reg 10 32bit mmio: [0x000000-0x000fff]
13:24:23 : pci 0000:00:0b.1: supports D1 D2
13:24:23 : pci 0000:00:0b.1: PME# supported from D0 D1 D2 D3hot D3cold
13:24:23 : pci 0000:00:0b.1: PME# disabled
13:24:23 : pci 0000:00:0b.2: reg 10 32bit mmio: [0xc0005000-0xc00057ff]
13:24:23 : pci 0000:00:0b.2: reg 14 32bit mmio: [0xc0000000-0xc0003fff]
13:24:23 : pci 0000:00:0b.2: supports D1 D2
13:24:23 : pci 0000:00:0b.2: PME# supported from D0 D1 D2 D3hot
13:24:23 : pci 0000:00:0b.2: PME# disabled
13:24:23 : pci 0000:00:0c.0: reg 10 io port: [0x1000-0x10ff]
13:24:23 : pci 0000:00:0c.0: reg 14 32bit mmio: [0xc0005800-0xc00058ff]
13:24:23 : pci 0000:00:0c.0: reg 30 32bit mmio: [0x000000-0x01ffff]
13:24:23 : pci 0000:00:0c.0: supports D1 D2
13:24:23 : pci 0000:00:0c.0: PME# supported from D1 D2 D3hot D3cold
13:24:23 : pci 0000:00:0c.0: PME# disabled
13:24:23 : pci 0000:00:10.0: reg 20 io port: [0x1c00-0x1c1f]
13:24:23 : pci 0000:00:10.0: supports D1 D2
13:24:23 : pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
13:24:23 : pci 0000:00:10.0: PME# disabled
13:24:23 : pci 0000:00:10.1: reg 20 io port: [0x1c20-0x1c3f]
13:24:23 : pci 0000:00:10.1: supports D1 D2
13:24:23 : pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
13:24:23 : pci 0000:00:10.1: PME# disabled
13:24:23 : pci 0000:00:10.2: reg 20 io port: [0x1c40-0x1c5f]
13:24:23 : pci 0000:00:10.2: supports D1 D2
13:24:23 : pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
13:24:23 : pci 0000:00:10.2: PME# disabled
13:24:23 : pci 0000:00:10.3: reg 10 32bit mmio: [0xc0005c00-0xc0005cff]
13:24:23 : pci 0000:00:10.3: supports D1 D2
13:24:23 : pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
13:24:23 : pci 0000:00:10.3: PME# disabled
13:24:23 : pci 0000:00:11.0: Force enabled HPET at 0xfed00000
13:24:23 : pci 0000:00:11.0: quirk: region 4000-407f claimed by vt8235 PM
13:24:23 : pci 0000:00:11.0: quirk: region 8100-810f claimed by vt8235 SMB
13:24:23 : pci 0000:00:11.1: reg 20 io port: [0x1c60-0x1c6f]
13:24:23 : pci 0000:00:11.5: reg 10 io port: [0x1400-0x14ff]
13:24:23 : pci 0000:00:11.5: supports D1 D2
13:24:23 : pci 0000:01:00.0: reg 10 32bit mmio: [0xc1000000-0xc1ffffff]
13:24:23 : pci 0000:01:00.0: reg 14 32bit mmio: [0xe0000000-0xefffffff]
13:24:23 : pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
13:24:23 : pci 0000:00:01.0: bridge 32bit mmio: [0xc1000000-0xc1ffffff]
13:24:23 : pci 0000:00:01.0: bridge 32bit mmio pref: [0xe0000000-0xefffffff]
13:24:23 : bus 00 -> node 0
13:24:23 : ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
13:24:23 : ACPI: PCI Interrupt Link [ALKA] (IRQs 16 17 18 19 20 21 22 23) *10, disabled.
13:24:23 : ACPI: PCI Interrupt Link [ALKB] (IRQs 16 17 18 19 20 21 22 23) *10, disabled.
13:24:23 : ACPI: PCI Interrupt Link [ALKC] (IRQs 22) *11, disabled.
13:24:23 : ACPI: PCI Interrupt Link [ALKD] (IRQs 21) *11, disabled.
13:24:23 : ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 12 14 15) *10
13:24:23 : ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 12 14 15)
13:24:23 : ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *11 12 14 15)
13:24:23 : ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12 14 15)
13:24:23 : PCI: Using ACPI for IRQ routing
13:24:23 : hpet clockevent registered
13:24:23 : pnp: PnP ACPI init
13:24:23 : ACPI: bus type pnp registered
13:24:23 : pnp: PnP ACPI: found 10 devices
13:24:23 : ACPI: ACPI bus type pnp unregistered
13:24:23 : system 00:05: iomem range 0xe0000-0xfffff could not be reserved
13:24:23 : system 00:05: iomem range 0xfff00000-0xffffffff could not be reserved
13:24:23 : system 00:05: iomem range 0xffee0000-0xffefffff has been reserved
13:24:23 : system 00:05: iomem range 0xfec00000-0xfec00fff has been reserved
13:24:23 : system 00:05: iomem range 0xfee00000-0xfee00fff has been reserved
13:24:23 : system 00:06: ioport range 0x600-0x60f has been reserved
13:24:23 : system 00:06: ioport range 0x1c0-0x1cf has been reserved
13:24:23 : system 00:06: ioport range 0x4d0-0x4d1 has been reserved
13:24:23 : system 00:06: ioport range 0xfe10-0xfe11 has been reserved
13:24:23 : system 00:06: ioport range 0xfe00-0xfe00 has been reserved
13:24:23 : system 00:06: ioport range 0x4000-0x407f has been reserved
13:24:23 : system 00:06: ioport range 0x8100-0x811f could not be reserved
13:24:23 : system 00:06: iomem range 0xfec00000-0xfec00fff has been reserved
13:24:23 : system 00:06: iomem range 0xfee00000-0xfee00fff has been reserved
13:24:23 : pci 0000:01:00.0: BAR 6: can't allocate mem resource [0xf0000000-0xefffffff]
13:24:23 : pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
13:24:23 : pci 0000:00:01.0:   IO window: disabled
13:24:23 : pci 0000:00:01.0:   MEM window: 0xc1000000-0xc1ffffff
13:24:23 : pci 0000:00:01.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
13:24:23 : pci 0000:00:0b.0: CardBus bridge, secondary bus 0000:02
13:24:23 : pci 0000:00:0b.0:   IO window: 0x001800-0x0018ff
13:24:23 : pci 0000:00:0b.0:   IO window: 0x002000-0x0020ff
13:24:23 : pci 0000:00:0b.0:   PREFETCH window: 0x88000000-0x8bffffff
13:24:23 : pci 0000:00:0b.0:   MEM window: 0x8c000000-0x8fffffff
13:24:23 : pci 0000:00:0b.1: CardBus bridge, secondary bus 0000:06
13:24:23 : pci 0000:00:0b.1:   IO window: 0x002400-0x0024ff
13:24:23 : pci 0000:00:0b.1:   IO window: 0x002800-0x0028ff
13:24:23 : pci 0000:00:0b.1:   PREFETCH window: 0x90000000-0x93ffffff
13:24:23 : pci 0000:00:0b.1:   MEM window: 0x94000000-0x97ffffff
13:24:23 : pci 0000:00:01.0: setting latency timer to 64
13:24:23 : pci 0000:00:0b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
13:24:23 : pci 0000:00:0b.0: setting latency timer to 64
13:24:23 : pci 0000:00:0b.1: enabling device (0000 -> 0003)
13:24:23 : pci 0000:00:0b.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
13:24:23 : pci 0000:00:0b.1: setting latency timer to 64
13:24:23 : bus: 00 index 0 io port: [0x00-0xffff]
13:24:23 : bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
13:24:23 : bus: 01 index 0 mmio: [0x0-0x0]
13:24:23 : bus: 01 index 1 mmio: [0xc1000000-0xc1ffffff]
13:24:23 : bus: 01 index 2 mmio: [0xe0000000-0xefffffff]
13:24:23 : bus: 01 index 3 mmio: [0x0-0x0]
13:24:23 : bus: 02 index 0 io port: [0x1800-0x18ff]
13:24:23 : bus: 02 index 1 io port: [0x2000-0x20ff]
13:24:23 : bus: 02 index 2 mmio: [0x88000000-0x8bffffff]
13:24:23 : bus: 02 index 3 mmio: [0x8c000000-0x8fffffff]
13:24:23 : bus: 06 index 0 io port: [0x2400-0x24ff]
13:24:23 : bus: 06 index 1 io port: [0x2800-0x28ff]
13:24:23 : bus: 06 index 2 mmio: [0x90000000-0x93ffffff]
13:24:23 : bus: 06 index 3 mmio: [0x94000000-0x97ffffff]
13:24:23 : NET: Registered protocol family 2
13:24:23 : IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
13:24:23 : TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
13:24:23 : TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
13:24:23 : TCP: Hash tables configured (established 262144 bind 65536)
13:24:23 : TCP reno registered
13:24:23 : NET: Registered protocol family 1
13:24:23 : Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
13:24:23 : msgmni has been set to 4023
13:24:23 : io scheduler noop registered
13:24:23 : io scheduler cfq registered (default)
13:24:23 : PCI: VIA PCI bridge detected.Disabling DAC.
13:24:23 : pci 0000:01:00.0: Boot video device
13:24:23 : Real Time Clock Driver v1.12ac
13:24:23 : parport_pc 00:09: reported by Plug and Play ACPI
13:24:23 : parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
13:24:23 : loop: module loaded
13:24:23 : Uniform Multi-Platform E-IDE driver
13:24:23 : via82cxxx 0000:00:11.1: VIA vt8235 (rev 00) IDE UDMA133
13:24:23 : via82cxxx 0000:00:11.1: IDE controller (0x1106:0x0571 rev 0x06)
13:24:23 : pci 0000:00:11.1: power state changed by ACPI to D0
13:24:23 : pci 0000:00:11.1: can't derive routing for PCI INT A
13:24:23 : via82cxxx 0000:00:11.1: not 100%% native mode: will probe irqs later
13:24:23 :     ide0: BM-DMA at 0x1c60-0x1c67
13:24:23 :     ide1: BM-DMA at 0x1c68-0x1c6f
13:24:23 : Probing IDE interface ide0...
13:24:23 : Switched to high resolution mode on CPU 0
13:24:23 : hda: HTS721010G9AT00, ATA DISK drive
13:24:23 : hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
13:24:23 : hda: UDMA/100 mode selected
13:24:23 : Probing IDE interface ide1...
13:24:23 : hdc: TSSTcorpCD/DVDW TS-L532A, ATAPI CD/DVD-ROM drive
13:24:23 : hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
13:24:23 : hdc: UDMA/33 mode selected
13:24:23 : ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
13:24:23 : isa bounce pool size: 16 pages
13:24:23 : ide1 at 0x170-0x177,0x376 on irq 15
13:24:23 : ide-gd driver 1.18
13:24:23 : hda: max request size: 512KiB
13:24:23 : hda: 195371568 sectors (100030 MB) w/7539KiB Cache, CHS=16383/255/63
13:24:23 : hda: cache flushes supported
13:24:23 :  hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 hda8 hda9 >
13:24:23 : ide-cd driver 5.00
13:24:23 : ide-cd: hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
13:24:23 : Uniform CD-ROM driver Revision: 3.20
13:24:23 : PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
13:24:23 : serio: i8042 KBD port at 0x60,0x64 irq 1
13:24:23 : serio: i8042 AUX port at 0x60,0x64 irq 12
13:24:23 : mice: PS/2 mouse device common for all mice
13:24:23 : input: PC Speaker as /class/input/input0
13:24:23 : cpuidle: using governor ladder
13:24:23 : u32 classifier
13:24:23 :     Actions configured 
13:24:23 : TCP cubic registered
13:24:23 : NET: Registered protocol family 10
13:24:23 : NET: Registered protocol family 17
13:24:23 : NET: Registered protocol family 15
13:24:23 : RPC: Registered udp transport module.
13:24:23 : RPC: Registered tcp transport module.
13:24:23 : input: AT Translated Set 2 keyboard as /class/input/input1
13:24:23 : Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9248b1, caps: 0x904713/0x4000
13:24:23 : input: SynPS/2 Synaptics TouchPad as /class/input/input2
13:24:23 : EXT3-fs: mounted filesystem with ordered data mode.
13:24:23 : VFS: Mounted root (ext3 filesystem) readonly.
13:24:23 : Freeing unused kernel memory: 236k freed
13:24:23 : kjournald starting.  Commit interval 5 seconds
13:24:23 : processor ACPI_CPU:00: registered as cooling_device0
13:24:23 : input: Power Button (FF) as /class/input/input3
13:24:23 : ACPI: Power Button (FF) [PWRF]
13:24:23 : thermal LNXTHERM:01: registered as thermal_zone0
13:24:23 : ACPI: Thermal Zone [THRS] (45 C)
13:24:23 : ACPI: AC Adapter [AC] (on-line)
13:24:23 : input: Lid Switch as /class/input/input4
13:24:23 : ACPI: Lid Switch [LID]
13:24:23 : thermal LNXTHERM:02: registered as thermal_zone1
13:24:23 : yenta_cardbus 0000:00:0b.0: CardBus bridge found [1025:006e]
13:24:23 : yenta_cardbus 0000:00:0b.0: Using CSCINT to route CSC interrupts to PCI
13:24:23 : yenta_cardbus 0000:00:0b.0: Routing CardBus interrupts to PCI
13:24:23 : yenta_cardbus 0000:00:0b.0: TI: mfunc 0x010a1b22, devctl 0x64
13:24:23 : ACPI: Thermal Zone [THRC] (71 C)
13:24:23 : usbcore: registered new interface driver usbfs
13:24:23 : usbcore: registered new interface driver hub
13:24:23 : usbcore: registered new device driver usb
13:24:23 : NET: Registered protocol family 23
13:24:23 : ACPI: Battery Slot [BAT0] (battery present)
13:24:23 : input: Sleep Button (CM) as /class/input/input5
13:24:23 : uhci_hcd: USB Universal Host Controller Interface driver
13:24:23 : ACPI: Sleep Button (CM) [SLPB]
13:24:23 : ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
13:24:23 : Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
13:24:23 : yenta_cardbus 0000:00:0b.0: ISA IRQ mask 0x0c78, PCI irq 17
13:24:23 : yenta_cardbus 0000:00:0b.0: Socket status: 30000820
13:24:23 : r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
13:24:23 : r8169 0000:00:0c.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
13:24:23 : r8169 0000:00:0c.0: PCI: Disallowing DAC for device
13:24:23 : r8169 0000:00:0c.0: no PCI Express capability
13:24:23 : eth0: RTL8169sb/8110sb at 0xffffc2000016c800, 00:0a:e4:a7:30:50, XID 10000000 IRQ 22
13:24:23 : ohci1394 0000:00:0b.2: PCI INT C -> GSI 19 (level, low) -> IRQ 19
13:24:23 : ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[c0005000-c00057ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
13:24:23 : uhci_hcd 0000:00:10.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
13:24:23 : uhci_hcd 0000:00:10.0: UHCI Host Controller
13:24:23 : uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
13:24:23 : uhci_hcd 0000:00:10.0: irq 21, io base 0x00001c00
13:24:23 : usb usb1: configuration #1 chosen from 1 choice
13:24:23 : hub 1-0:1.0: USB hub found
13:24:23 : hub 1-0:1.0: 2 ports detected
13:24:23 : ehci_hcd 0000:00:10.3: PCI INT D -> GSI 21 (level, low) -> IRQ 21
13:24:23 : ehci_hcd 0000:00:10.3: EHCI Host Controller
13:24:23 : ehci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 2
13:24:23 : ehci_hcd 0000:00:10.3: irq 21, io mem 0xc0005c00
13:24:23 : ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00
13:24:23 : usb usb2: configuration #1 chosen from 1 choice
13:24:23 : hub 2-0:1.0: USB hub found
13:24:23 : hub 2-0:1.0: 6 ports detected
13:24:23 : yenta_cardbus 0000:00:0b.1: CardBus bridge found [1025:006e]
13:24:23 : yenta_cardbus 0000:00:0b.1: Using CSCINT to route CSC interrupts to PCI
13:24:23 : yenta_cardbus 0000:00:0b.1: Routing CardBus interrupts to PCI
13:24:23 : yenta_cardbus 0000:00:0b.1: TI: mfunc 0x010a1b22, devctl 0x64
13:24:23 : yenta_cardbus 0000:00:0b.1: ISA IRQ mask 0x0c78, PCI irq 18
13:24:23 : yenta_cardbus 0000:00:0b.1: Socket status: 30000006
13:24:23 : uhci_hcd 0000:00:10.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
13:24:23 : uhci_hcd 0000:00:10.1: UHCI Host Controller
13:24:23 : uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
13:24:23 : uhci_hcd 0000:00:10.1: irq 21, io base 0x00001c20
13:24:23 : usb usb3: configuration #1 chosen from 1 choice
13:24:23 : hub 3-0:1.0: USB hub found
13:24:23 : hub 3-0:1.0: 2 ports detected
13:24:23 : VIA 82xx Audio 0000:00:11.5: power state changed by ACPI to D0
13:24:23 : VIA 82xx Audio 0000:00:11.5: PCI INT C -> GSI 22 (level, low) -> IRQ 22
13:24:23 : VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
13:24:23 : pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
13:24:23 : pci 0000:02:00.0: reg 10 32bit mmio: [0x000000-0x00ffff]
13:24:23 : cfg80211: Using static regulatory domain info
13:24:23 : cfg80211: Regulatory domain: US
13:24:23 : ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
13:24:23 : ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
13:24:23 : ^I(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
13:24:23 : ^I(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
13:24:23 : ^I(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
13:24:23 : ^I(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
13:24:23 : ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
13:24:23 : cfg80211: Calling CRDA for country: US
13:24:23 : ath9k: 0.1
13:24:23 : ath9k 0000:02:00.0: enabling device (0000 -> 0002)
13:24:23 : ath9k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
13:24:23 : uhci_hcd 0000:00:10.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
13:24:23 : uhci_hcd 0000:00:10.2: UHCI Host Controller
13:24:23 : uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
13:24:23 : uhci_hcd 0000:00:10.2: irq 21, io base 0x00001c40
13:24:23 : usb usb4: configuration #1 chosen from 1 choice
13:24:23 : hub 4-0:1.0: USB hub found
13:24:23 : hub 4-0:1.0: 2 ports detected
13:24:23 : ath9k: 2MHz channel: 2412, channelFlags: 0x300e0
13:24:23 : ath9k: 2MHz channel: 2417, channelFlags: 0x300e0
13:24:23 : ath9k: 2MHz channel: 2422, channelFlags: 0x300e0
13:24:23 : ath9k: 2MHz channel: 2427, channelFlags: 0x300e0
13:24:23 : ath9k: 2MHz channel: 2432, channelFlags: 0x700e0
13:24:23 : ath9k: 2MHz channel: 2437, channelFlags: 0x700e0
13:24:23 : ath9k: 2MHz channel: 2442, channelFlags: 0x700e0
13:24:23 : ath9k: 2MHz channel: 2447, channelFlags: 0x500e0
13:24:23 : ath9k: 2MHz channel: 2452, channelFlags: 0x500e0
13:24:23 : ath9k: 2MHz channel: 2457, channelFlags: 0x500e0
13:24:23 : ath9k: 2MHz channel: 2462, channelFlags: 0x500e0
13:24:23 : ath9k: Rate:  1Mbps, ratecode: 27
13:24:23 : ath9k: Rate:  2Mbps, ratecode: 26
13:24:23 : ath9k: Rate:  5Mbps, ratecode: 25
13:24:23 : ath9k: Rate: 11Mbps, ratecode: 24
13:24:23 : ath9k: Rate:  6Mbps, ratecode: 11
13:24:23 : ath9k: Rate:  9Mbps, ratecode: 15
13:24:23 : ath9k: Rate: 12Mbps, ratecode: 10
13:24:23 : ath9k: Rate: 18Mbps, ratecode: 14
13:24:23 : ath9k: Rate: 24Mbps, ratecode:  9
13:24:23 : ath9k: Rate: 36Mbps, ratecode: 13
13:24:23 : ath9k: Rate: 48Mbps, ratecode:  8
13:24:23 : ath9k: Rate: 54Mbps, ratecode: 12
13:24:23 : ath9k: Rate:  6Mbps, ratecode: 11
13:24:23 : ath9k: Rate:  9Mbps, ratecode: 15
13:24:23 : ath9k: Rate: 12Mbps, ratecode: 10
13:24:23 : ath9k: Rate: 18Mbps, ratecode: 14
13:24:23 : ath9k: Rate: 24Mbps, ratecode:  9
13:24:23 : ath9k: Rate: 36Mbps, ratecode: 13
13:24:23 : ath9k: Rate: 48Mbps, ratecode:  8
13:24:23 : ath9k: Rate: 54Mbps, ratecode: 12
13:24:23 : ath9k: tx DMA: 512 buffers 1 desc/buf
13:24:23 : ath9k: tx DMA map: ffff88007c320000 (77824) -> 0 (77824)
13:24:23 : ath9k: beacon DMA: 4 buffers 1 desc/buf
13:24:23 : ath9k: beacon DMA map: ffff88007c259000 (608) -> 0 (608)
13:24:23 : ath9k: cachelsz 64 rxbufsize 3904
13:24:23 : ath9k: rx DMA: 512 buffers 1 desc/buf
13:24:23 : ath9k: rx DMA map: ffff88007ba20000 (77824) -> 0 (77824)
13:24:23 : phy0: Selected rate control algorithm 'ath9k_rate_control'
13:24:23 : Registered led device: ath9k-phy0:radio
13:24:23 : Registered led device: ath9k-phy0:assoc
13:24:23 : Registered led device: ath9k-phy0:tx
13:24:23 : Registered led device: ath9k-phy0:rx
13:24:23 : phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81: mem=0xffffc20000120000, irq=17
13:24:23 : ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000ae40510101a78]
13:24:23 : lp0: using parport0 (interrupt-driven).
13:24:23 : SCSI subsystem initialized
13:24:23 : Adding 2144636k swap on /dev/hda9.  Priority:-1 extents:1 across:2144636k
13:24:23 : EXT3 FS on hda2, internal journal
13:24:23 : kjournald starting.  Commit interval 5 seconds
13:24:23 : EXT3 FS on hda6, internal journal
13:24:23 : EXT3-fs: mounted filesystem with ordered data mode.
13:24:23 : kjournald starting.  Commit interval 5 seconds
13:24:23 : EXT3 FS on hda8, internal journal
13:24:23 : EXT3-fs: mounted filesystem with ordered data mode.
13:24:23 : kjournald starting.  Commit interval 5 seconds
13:24:23 : EXT3 FS on hda5, internal journal
13:24:23 : EXT3-fs: mounted filesystem with ordered data mode.
13:24:23 : kjournald starting.  Commit interval 5 seconds
13:24:23 : EXT3 FS on hda7, internal journal
13:24:23 : EXT3-fs: mounted filesystem with ordered data mode.
13:24:28 : ath9k: Starting driver with initial channel: 2412 MHz
13:24:28 : ath9k: Attach a VAP of type: 2
13:24:28 : ath9k: BSS Changed PREAMBLE 0
13:24:28 : ath9k: BSS Changed CTS PROT 0
13:24:28 : ath9k: Set HW RX filter: 0x0
13:24:28 : ath9k: Set channel: 2412 MHz
13:24:28 : ath9k: tx chmask: 1, rx chmask: 1
13:24:28 : ath9k: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
13:24:28 : ath9k: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
13:24:28 : ath9k: Configure tx [queue/halq] [2/1],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
13:24:28 : ath9k: Configure tx [queue/halq] [3/0],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
13:24:28 : ath9k: Set HW RX filter: 0x0
13:24:28 : ath9k: Set HW RX filter: 0x0
13:24:28 : ADDRCONF(NETDEV_UP): ath0: link is not ready
13:24:28 : ath9k: Set HW RX filter: 0x0
13:24:28 : ath9k: Set HW RX filter: 0x10
13:24:28 : ath9k: Set channel: 2412 MHz
13:24:28 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
13:24:28 : ath9k: Set channel: 2417 MHz
13:24:28 : ath9k: (2412 MHz) -> (2417 MHz), cflags:300e0, chanwidth: 0
13:24:28 : ath9k: Set channel: 2422 MHz
13:24:28 : ath9k: (2417 MHz) -> (2422 MHz), cflags:300e0, chanwidth: 0
13:24:28 : ath9k: Set channel: 2427 MHz
13:24:28 : ath9k: (2422 MHz) -> (2427 MHz), cflags:300e0, chanwidth: 0
13:24:29 : ath9k: Set channel: 2432 MHz
13:24:29 : ath9k: (2427 MHz) -> (2432 MHz), cflags:700e0, chanwidth: 0
13:24:29 : ath9k: Set channel: 2437 MHz
13:24:29 : ath9k: (2432 MHz) -> (2437 MHz), cflags:700e0, chanwidth: 0
13:24:29 : ath9k: Set channel: 2442 MHz
13:24:29 : ath9k: (2437 MHz) -> (2442 MHz), cflags:700e0, chanwidth: 0
13:24:29 : ath9k: Set channel: 2447 MHz
13:24:29 : ath9k: (2442 MHz) -> (2447 MHz), cflags:500e0, chanwidth: 0
13:24:29 : ath9k: Set channel: 2452 MHz
13:24:29 : powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3400+ processors (1 cpu cores) (version 2.20.00)
13:24:29 : powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x2
13:24:29 : powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x6
13:24:29 : powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xa
13:24:29 : powernow-k8:    3 : fid 0x0 (800 MHz), vid 0x12
13:24:29 : powernow-k8: ph2 null fid transition 0xe
13:24:29 : ath9k: (2447 MHz) -> (2452 MHz), cflags:500e0, chanwidth: 0
13:24:29 : Marking TSC unstable due to cpufreq changes
13:24:29 : ath9k: Set channel: 2457 MHz
13:24:29 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
13:24:29 : ath9k: Set channel: 2462 MHz
13:24:29 : ath9k: (2457 MHz) -> (2462 MHz), cflags:500e0, chanwidth: 0
13:24:29 : ath9k: Set channel: 2412 MHz
13:24:29 : ath9k: (2462 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
13:24:29 : ath9k: Set HW RX filter: 0x0
13:24:29 last message repeated 2 times
13:24:29 : ath9k: Detach Interface
13:24:29 : ath9k: Cleaning up
13:24:29 : ath9k: Driver halt
13:24:29 : r8169: eth0: link down
13:24:29 : ADDRCONF(NETDEV_UP): eth0: link is not ready
13:24:29 : ath9k: Starting driver with initial channel: 2412 MHz
13:24:29 : ath9k: Attach a VAP of type: 2
13:24:29 : ath9k: BSS Changed PREAMBLE 0
13:24:29 : ath9k: BSS Changed CTS PROT 0
13:24:29 : ath9k: Set HW RX filter: 0x0
13:24:29 : ath9k: Set channel: 2412 MHz
13:24:29 : ath9k: tx chmask: 1, rx chmask: 1
13:24:29 : ath9k: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
13:24:29 : ath9k: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
13:24:29 : ath9k: Configure tx [queue/halq] [2/1],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
13:24:29 : ath9k: Configure tx [queue/halq] [3/0],  aifs: 2, cw_min: 31, cw_max: 1023, txop: 0
13:24:29 : ath9k: Set HW RX filter: 0x0
13:24:29 : ath9k: Set HW RX filter: 0x0
13:24:29 : ADDRCONF(NETDEV_UP): ath0: link is not ready
13:24:29 : ath9k: Set HW RX filter: 0x0
13:24:29 last message repeated 2 times
13:24:29 : ath9k: Set channel: 2412 MHz
13:24:29 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e2, chanwidth: 0
13:24:29 : ath9k: Set HW RX filter: 0x10
13:24:29 : ath9k: Set channel: 2412 MHz
13:24:30 : ath9k: Set channel: 2417 MHz
13:24:30 : ath9k: (2412 MHz) -> (2417 MHz), cflags:300e0, chanwidth: 0
13:24:30 : ath9k: Set channel: 2422 MHz
13:24:30 : warning: `dhclient' uses 32-bit capabilities (legacy support in use)
13:24:30 : ath9k: (2417 MHz) -> (2422 MHz), cflags:300e0, chanwidth: 0
13:24:30 : ath9k: Set channel: 2427 MHz
13:24:30 : ath9k: (2422 MHz) -> (2427 MHz), cflags:300e0, chanwidth: 0
13:24:30 : ath9k: Set HW RX filter: 0x0
13:24:30 : ath9k: Set HW RX filter: 0x0
13:24:30 : ath9k: Set channel: 2432 MHz
13:24:30 : ath9k: (2427 MHz) -> (2432 MHz), cflags:700e0, chanwidth: 0
13:24:30 : ath9k: Set channel: 2437 MHz
13:24:30 : ath9k: (2432 MHz) -> (2437 MHz), cflags:700e0, chanwidth: 0
13:24:30 : ath9k: Set channel: 2442 MHz
13:24:30 : ath9k: (2437 MHz) -> (2442 MHz), cflags:700e0, chanwidth: 0
13:24:30 : ath9k: Set channel: 2447 MHz
13:24:30 : ath9k: (2442 MHz) -> (2447 MHz), cflags:500e0, chanwidth: 0
13:24:30 : ath9k: Set channel: 2452 MHz
13:24:30 : ath9k: (2447 MHz) -> (2452 MHz), cflags:500e0, chanwidth: 0
13:24:30 : ath9k: Set channel: 2457 MHz
13:24:30 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
13:24:30 : ath9k: Set channel: 2462 MHz
13:24:30 : ath9k: (2457 MHz) -> (2462 MHz), cflags:500e0, chanwidth: 0
13:24:30 : ath9k: Set channel: 2412 MHz
13:24:30 : ath9k: Set channel: 2412 MHz
13:24:30 : ath9k: (2462 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
13:24:30 : ath9k: RX filter 0x0 bssid 00:1b:11:60:7a:3d aid 0x0
13:24:30 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
13:24:30 : ath9k: Set HW RX filter: 0x0
13:24:30 : ath9k: Set channel: 2412 MHz
13:24:30 : ath9k: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min: 15, cw_max: 1023, txop: 0
13:24:30 : ath9k: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min: 15, cw_max: 1023, txop: 0
13:24:30 : ath9k: Configure tx [queue/halq] [2/1],  aifs: 2, cw_min: 15, cw_max: 1023, txop: 0
13:24:30 : ath9k: Configure tx [queue/halq] [3/0],  aifs: 2, cw_min: 15, cw_max: 1023, txop: 0
13:24:30 : ath0: authenticate with AP 00:1b:11:60:7a:3d
13:24:30 : ath0: authenticated
13:24:30 : ath0: associate with AP 00:1b:11:60:7a:3d
13:24:30 : ath0: RX AssocResp from 00:1b:11:60:7a:3d (capab=0x431 status=0 aid=4)
13:24:30 : ath0: associated
13:24:30 : ath9k: Choosing rate table for mode: 10
13:24:30 : ath9k: Configure tx [queue/halq] [2/1],  aifs: 3, cw_min: 15, cw_max: 1023, txop: 0
13:24:30 : ath9k: Configure tx [queue/halq] [3/0],  aifs: 7, cw_min: 15, cw_max: 1023, txop: 0
13:24:30 : ath9k: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min: 7, cw_max: 15, txop: 94
13:24:30 : ath9k: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min: 3, cw_max: 7, txop: 47
13:24:30 : ath9k: tx chmask: 5, rx chmask: 5
13:24:30 : ath9k: BSS Changed PREAMBLE 1
13:24:30 : ath9k: BSS Changed HT, chanwidth: 1
13:24:30 : ath9k: BSS Changed ASSOC 1
13:24:30 : ath9k: Bss Info ASSOC 4
13:24:30 : ath9k: tx chmask: 5, rx chmask: 5
13:24:30 : ath9k: bssid 00:1b:11:60:7a:3d aid 0x4
13:24:30 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 1
13:24:30 : Clocksource tsc unstable (delta = -79390796 ns)
13:24:30 : ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
13:24:30 : ath9k: Set HW RX filter: 0x0
13:24:35 last message repeated 3 times
13:24:41 : ath0: no IPv6 routers present
13:25:24 : ACPI: EC: missing confirmations, switch off interrupt mode.
13:31:02 : ath9k: Set HW RX filter: 0x10
13:31:02 : ath9k: Set channel: 2412 MHz
13:31:02 : ath9k: Set channel: 2417 MHz
13:31:02 : ath9k: (2412 MHz) -> (2417 MHz), cflags:300e0, chanwidth: 0
13:31:02 : ath9k: Set channel: 2422 MHz
13:31:02 : ath9k: (2417 MHz) -> (2422 MHz), cflags:300e0, chanwidth: 0
13:31:02 : ath9k: Set channel: 2427 MHz
13:31:02 : ath9k: (2422 MHz) -> (2427 MHz), cflags:300e0, chanwidth: 0
13:31:02 : ath9k: Set channel: 2432 MHz
13:31:02 : ath9k: (2427 MHz) -> (2432 MHz), cflags:700e0, chanwidth: 0
13:31:02 : ath9k: Set channel: 2437 MHz
13:31:02 : ath9k: (2432 MHz) -> (2437 MHz), cflags:700e0, chanwidth: 0
13:31:03 : ath9k: Set channel: 2442 MHz
13:31:03 : ath9k: (2437 MHz) -> (2442 MHz), cflags:700e0, chanwidth: 0
13:31:03 : ath9k: Set channel: 2447 MHz
13:31:03 : ath9k: (2442 MHz) -> (2447 MHz), cflags:500e0, chanwidth: 0
13:31:03 : ath9k: Set channel: 2452 MHz
13:31:03 : ath9k: (2447 MHz) -> (2452 MHz), cflags:500e0, chanwidth: 0
13:31:03 : ath9k: Set channel: 2457 MHz
13:31:03 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
13:31:03 : ath9k: Set channel: 2462 MHz
13:31:03 : ath9k: (2457 MHz) -> (2462 MHz), cflags:500e0, chanwidth: 0
13:31:03 : ath9k: Set channel: 2412 MHz
13:31:03 : ath9k: (2462 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
13:31:03 : ath9k: Set HW RX filter: 0x0

/Mats

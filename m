Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f182.google.com ([209.85.223.182]:47850 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934118Ab0D3SyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 14:54:08 -0400
Received: by iwn12 with SMTP id 12so608720iwn.15
        for <linux-wireless@vger.kernel.org>; Fri, 30 Apr 2010 11:54:07 -0700 (PDT)
From: Joshua Smith <jesmith@kaon.com>
Content-Type: multipart/mixed; boundary=Apple-Mail-122-48968645
Subject: Issues setting up a 5GHz 802.11N AP
Date: Thu, 29 Apr 2010 13:17:08 -0400
Message-Id: <7F414AFA-E125-40AD-A745-30AEC442B1E8@kaon.com>
To: linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1078)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Apple-Mail-122-48968645
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hello!  I hope this is the right mailing this for this question.  If =
not, please redirect me as you see fit!

I am trying to put together a Linux PC that can act as a 5 GHz 802.11N =
Access Point.  I got a lot of conflicting info in my searches, so I =
figured I'd just buy some hardware and figure out what works.

I am using this kernel:

  Linux vosk 2.6.27.8 #1 SMP Sun Dec 7 08:30:31 i686 Intel(R) Core(TM) =
i7 CPU 930  @ 2.80GHz GenuineIntel GNU/Linux

And I am using compat-wireless 2010-04-26 (complete build).

So far, I have an Intel Wi-Fi Link 6300AGN:

  iwlagn 0000:07:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 =
AGN, REV=3D0x74

An Atheros-based Belkin N1 Wireless ExpressCard:

  phy1: Atheros AR5418 MAC/BB Rev:2 AR2122 RF Rev:81 mem=3D0xf9fa0000, =
irq=3D16

And an RaLink-based Asus PCE-N13 PCI adapter:

  03:00.0 Network controller: RaLink RT2860

When I do 'iw list' for these three cards, I find:

Intel: has 5GHz band, but does not support AP mode
Atheros: supports AP mode, but does not show 5GHz band
RaLink: supports AP mode, but does not show 5GHz band

I think the Intel is correct.  I've found many sources that say this =
chipset simply does not support AP/Master mode.

However, both the Atheros and RaLink claim to support 300Mbps speeds, =
which I believe means they should have some 5Ghz channels, right?

I've attached a couple logs which show details (dmesg and iw list =
output).

Is there a trick to getting these cards to expose their 5GHz channels?

Or, alternately, can you recommend some specific hardware that should =
support AP mode at 5GHz?  USB and/or PCI-E?

Thanks in advance!

-Joshua



--Apple-Mail-122-48968645
Content-Disposition: attachment;
	filename=sager.txt
Content-Type: text/plain;
	name="sager.txt"
Content-Transfer-Encoding: quoted-printable

Script started on Wed Apr 28 14:57:03 2010
root@vosk:~# dmesg
00, f06083ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
PCI: 0000:00:1b.0 reg 10 64bit mmio: [f0600000, f0603fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [1c00, 1c1f]
PCI: 0000:00:1d.1 reg 20 io port: [18e0, 18ff]
PCI: 0000:00:1d.2 reg 20 io port: [18c0, 18df]
PCI: 0000:00:1d.3 reg 20 io port: [18a0, 18bf]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [f0607000, f06073ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
PCI: 0000:00:1f.2 reg 10 io port: [1888, 188f]
PCI: 0000:00:1f.2 reg 14 io port: [183c, 183f]
PCI: 0000:00:1f.2 reg 18 io port: [1880, 1887]
PCI: 0000:00:1f.2 reg 1c io port: [1838, 183b]
PCI: 0000:00:1f.2 reg 20 io port: [1860, 187f]
PCI: 0000:00:1f.2 reg 24 32bit mmio: [f0606000, f06067ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
PCI: 0000:00:1f.3 reg 10 64bit mmio: [f0605000, f06050ff]
PCI: 0000:00:1f.3 reg 20 io port: [1840, 185f]
PCI: 0000:03:00.0 reg 10 32bit mmio: [ce000000, ceffffff]
PCI: 0000:03:00.0 reg 14 64bit mmio: [d0000000, dfffffff]
PCI: 0000:03:00.0 reg 1c 64bit mmio: [cc000000, cdffffff]
PCI: 0000:03:00.0 reg 24 io port: [2000, 207f]
PCI: 0000:03:00.0 reg 30 32bit mmio: [0, 1ffff]
PCI: bridge 0000:00:07.0 io port: [2000, 2fff]
PCI: bridge 0000:00:07.0 32bit mmio: [cc000000, ceffffff]
PCI: bridge 0000:00:07.0 64bit mmio pref: [d0000000, dfffffff]
PCI: 0000:04:00.0 reg 10 64bit mmio: [f0200000, f020ffff]
pci 0000:04:00.0: supports D1
pci 0000:04:00.0: PME# supported from D0 D1 D3hot
pci 0000:04:00.0: PME# disabled
PCI: bridge 0000:00:1c.0 32bit mmio: [f0200000, f02fffff]
PCI: 0000:06:00.0 reg 10 io port: [3000, 30ff]
PCI: 0000:06:00.0 reg 18 64bit mmio: [f0300000, f0300fff]
PCI: 0000:06:00.0 reg 20 64bit mmio: [f0700000, f070ffff]
PCI: 0000:06:00.0 reg 30 32bit mmio: [0, 1ffff]
pci 0000:06:00.0: supports D1
pci 0000:06:00.0: supports D2
pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:06:00.0: PME# disabled
PCI: bridge 0000:00:1c.1 io port: [3000, 3fff]
PCI: bridge 0000:00:1c.1 32bit mmio: [f0300000, f03fffff]
PCI: bridge 0000:00:1c.1 64bit mmio pref: [f0700000, f07fffff]
PCI: 0000:07:00.0 reg 10 64bit mmio: [f0100000, f0101fff]
pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
pci 0000:07:00.0: PME# disabled
PCI: bridge 0000:00:1c.2 32bit mmio: [f0100000, f01fffff]
PCI: 0000:08:00.0 reg 10 32bit mmio: [f0007000, f00077ff]
PCI: 0000:08:00.0 reg 14 32bit mmio: [f0006000, f000607f]
PCI: 0000:08:00.0 reg 20 32bit mmio: [f0005000, f000507f]
PCI: 0000:08:00.0 reg 24 32bit mmio: [f0004000, f000407f]
PCI: 0000:08:00.1 reg 10 32bit mmio: [f0003000, f00030ff]
PCI: 0000:08:00.2 reg 10 32bit mmio: [f0002000, f00020ff]
PCI: 0000:08:00.3 reg 10 32bit mmio: [f0001000, f00010ff]
PCI: bridge 0000:00:1c.3 32bit mmio: [f0000000, f00fffff]
pci 0000:00:1e.0: transparent bridge
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 14 15) *0, =
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 14 15) *0, =
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 6 7 10 11 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x800-0x80f has been reserved
system 00:02: ioport range 0x1000-0x107f has been reserved
system 00:02: ioport range 0x1180-0x11bf has been reserved
system 00:02: ioport range 0xfe00-0xfe00 has been reserved
system 00:02: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:02: iomem range 0xfc000000-0xfcffffff has been reserved
system 00:02: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:02: iomem range 0xfe800000-0xfe9fffff has been reserved
system 00:02: iomem range 0xfeb00000-0xfebfffff has been reserved
system 00:02: iomem range 0xfe710000-0xfe711fff has been reserved
system 00:02: iomem range 0xfed20000-0xfed44fff has been reserved
system 00:02: iomem range 0xfed45000-0xfed8ffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: disabled
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:00:03.0: PCI bridge, secondary bus 0000:02
pci 0000:00:03.0:   IO window: disabled
pci 0000:00:03.0:   MEM window: disabled
pci 0000:00:03.0:   PREFETCH window: disabled
pci 0000:03:00.0: BAR 6: can't allocate mem resource =
[0xe0000000-0xdfffffff]
pci 0000:00:07.0: PCI bridge, secondary bus 0000:03
pci 0000:00:07.0:   IO window: 0x2000-0x2fff
pci 0000:00:07.0:   MEM window: 0xcc000000-0xceffffff
pci 0000:00:07.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: 0xf0200000-0xf02fffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:06
pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
pci 0000:00:1c.1:   MEM window: 0xf0300000-0xf03fffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000f0700000-0x000000f07fffff
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:07
pci 0000:00:1c.2:   IO window: disabled
pci 0000:00:1c.2:   MEM window: 0xf0100000-0xf01fffff
pci 0000:00:1c.2:   PREFETCH window: disabled
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:08
pci 0000:00:1c.3:   IO window: disabled
pci 0000:00:1c.3:   MEM window: 0xf0000000-0xf00fffff
pci 0000:00:1c.3:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:09
pci 0000:00:1c.4:   IO window: disabled
pci 0000:00:1c.4:   MEM window: disabled
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:0a
pci 0000:00:1c.5:   IO window: disabled
pci 0000:00:1c.5:   MEM window: disabled
pci 0000:00:1c.5:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0b
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: disabled
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:01.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:03.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:07.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffff]
bus: 01 index 0 mmio: [0, 0]
bus: 01 index 1 mmio: [0, 0]
bus: 01 index 2 mmio: [0, 0]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 mmio: [0, 0]
bus: 02 index 1 mmio: [0, 0]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 io port: [2000, 2fff]
bus: 03 index 1 mmio: [cc000000, ceffffff]
bus: 03 index 2 mmio: [d0000000, dfffffff]
bus: 03 index 3 mmio: [0, 0]
bus: 04 index 0 mmio: [0, 0]
bus: 04 index 1 mmio: [f0200000, f02fffff]
bus: 04 index 2 mmio: [0, 0]
bus: 04 index 3 mmio: [0, 0]
bus: 06 index 0 io port: [3000, 3fff]
bus: 06 index 1 mmio: [f0300000, f03fffff]
bus: 06 index 2 mmio: [f0700000, f07fffff]
bus: 06 index 3 mmio: [0, 0]
bus: 07 index 0 mmio: [0, 0]
bus: 07 index 1 mmio: [f0100000, f01fffff]
bus: 07 index 2 mmio: [0, 0]
bus: 07 index 3 mmio: [0, 0]
bus: 08 index 0 mmio: [0, 0]
bus: 08 index 1 mmio: [f0000000, f00fffff]
bus: 08 index 2 mmio: [0, 0]
bus: 08 index 3 mmio: [0, 0]
bus: 09 index 0 mmio: [0, 0]
bus: 09 index 1 mmio: [0, 0]
bus: 09 index 2 mmio: [0, 0]
bus: 09 index 3 mmio: [0, 0]
bus: 0a index 0 mmio: [0, 0]
bus: 0a index 1 mmio: [0, 0]
bus: 0a index 2 mmio: [0, 0]
bus: 0a index 3 mmio: [0, 0]
bus: 0b index 0 mmio: [0, 0]
bus: 0b index 1 mmio: [0, 0]
bus: 0b index 2 mmio: [0, 0]
bus: 0b index 3 io port: [0, ffff]
bus: 0b index 4 mmio: [0, ffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...it isn't (no cpio magic); looks like an =
initrd
Freeing initrd memory: 2403k freed
Simple Boot Flag at 0x40 set to 0x1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
NTFS driver 2.1.29 [Flags: R/O].
JFS: nTxBlock =3D 8192, nTxLock =3D 65536
SGI XFS with ACLs, security attributes, large block numbers, no debug =
enabled
SGI XFS Quota Management subsystem
OCFS2 1.5.0
OCFS2 Node Manager 1.5.0
GFS2 (built Dec  7 2008 08:26:41) installed
msgmni has been set to 1722
async_tx: api initialized (sync-only)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:03:00.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pci_express 0000:00:01.0:pcie00: allocate port service
pci_express 0000:00:01.0:pcie01: allocate port service
pcieport-driver 0000:00:03.0: setting latency timer to 64
pcieport-driver 0000:00:03.0: found MSI capability
pci_express 0000:00:03.0:pcie00: allocate port service
pci_express 0000:00:03.0:pcie01: allocate port service
pcieport-driver 0000:00:07.0: setting latency timer to 64
pcieport-driver 0000:00:07.0: found MSI capability
pci_express 0000:00:07.0:pcie00: allocate port service
pci_express 0000:00:07.0:pcie01: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pcieport-driver 0000:00:1c.2: found MSI capability
pci_express 0000:00:1c.2:pcie00: allocate port service
pci_express 0000:00:1c.2:pcie02: allocate port service
pci_express 0000:00:1c.2:pcie03: allocate port service
pcieport-driver 0000:00:1c.3: setting latency timer to 64
pcieport-driver 0000:00:1c.3: found MSI capability
pci_express 0000:00:1c.3:pcie00: allocate port service
pci_express 0000:00:1c.3:pcie02: allocate port service
pci_express 0000:00:1c.3:pcie03: allocate port service
pcieport-driver 0000:00:1c.4: setting latency timer to 64
pcieport-driver 0000:00:1c.4: found MSI capability
pci_express 0000:00:1c.4:pcie00: allocate port service
pci_express 0000:00:1c.4:pcie02: allocate port service
pci_express 0000:00:1c.4:pcie03: allocate port service
pcieport-driver 0000:00:1c.5: setting latency timer to 64
pcieport-driver 0000:00:1c.5: found MSI capability
pci_express 0000:00:1c.5:pcie00: allocate port service
pci_express 0000:00:1c.5:pcie02: allocate port service
pci_express 0000:00:1c.5:pcie03: allocate port service
aer 0000:00:01.0:pcie01: AER service couldn't init device: no _OSC =
support
aer 0000:00:03.0:pcie01: AER service couldn't init device: no _OSC =
support
aer 0000:00:07.0:pcie01: AER service couldn't init device: no _OSC =
support
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: AC Adapter [ADP0] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Lid Switch as /class/input/input2
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input3
ACPI: Sleep Button (CM) [SLPB]
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: CPU1 (power states: C1[C1] C2[C2])
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: CPU2 (power states: C1[C1] C2[C2])
processor ACPI0007:02: registered as cooling_device2
ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI: CPU3 (power states: C1[C1] C2[C2])
processor ACPI0007:03: registered as cooling_device3
ACPI: Processor [CPU3] (supports 8 throttling states)
ACPI: CPU4 (power states: C1[C1] C2[C2])
processor ACPI0007:04: registered as cooling_device4
ACPI: Processor [CPU4] (supports 8 throttling states)
ACPI: CPU5 (power states: C1[C1] C2[C2])
processor ACPI0007:05: registered as cooling_device5
ACPI: Processor [CPU5] (supports 8 throttling states)
ACPI: CPU6 (power states: C1[C1] C2[C2])
processor ACPI0007:06: registered as cooling_device6
ACPI: Processor [CPU6] (supports 8 throttling states)
ACPI: CPU7 (power states: C1[C1] C2[C2])
processor ACPI0007:07: registered as cooling_device7
ACPI: Processor [CPU7] (supports 8 throttling states)
Marking TSC unstable due to possible TSC halt in C2
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (43 C)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
Uniform Multi-Platform E-IDE driver
ide_generic: please use "probe_mask=3D0x3f" module parameter for probing =
all legacy ISA IDE ports
Probing IDE interface ide0...
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide-floppy driver 1.00
Loading iSCSI transport class v2.0-870.
iscsi: registered transport (tcp)
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver 1.1-5[2456]-ms
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
scsi: <fdomain> Detection failed (no card)
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address and IRQ using =
iobase=3D and irq=3D options<6>QLogic Fibre Channel HBA Driver: =
8.02.01-k7
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.2.7
Copyright(c) 2004-2008 Emulex.  All rights reserved.
Failed initialization of WD-7000 SCSI card!
DC390: clustering now enabled by default. If you get problems load
	with "disable_clustering=3D1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
GDT-HA: Storage RAID Controller Driver. Version: 3.05
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.011.
nsp32: loading...
ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
st: Version 20080504, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x31 impl SATA =
mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp pio slum part=20
ahci 0000:00:1f.2: setting latency timer to 64
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
scsi6 : ahci
scsi7 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 irq_stat 0x00000040, connection status changed
ata6: SATA max UDMA/133 abar m2048@0xf0606000 port 0xf0606380 irq 17
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: ST9320421AS, SD13, max UDMA/133
ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATAPI: HL-DT-ST DVDRAM GSA-T50N, RH03, max UDMA/133
ata5.00: configured for UDMA/133
ata6: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      ST9320421AS      SD13 PQ: 0 =
ANSI: 5
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't =
support DPO or FUA
 sda: sda1 sda2
sd 2:0:0:0: [sda] Attached SCSI disk
scsi 6:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-T50N  RH03 PQ: 0 =
ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 6:0:0:0: Attached scsi CD-ROM sr0
I2O subsystem v1.325
i2o: max drivers =3D 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.07
Fusion MPT FC Host driver 3.04.07
Fusion MPT SAS Host driver 3.04.07
ohci1394 0000:08:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ohci1394 0000:08:00.0: setting latency timer to 64
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[19]  =
MMIO=3D[f0007000-f00077ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/4]
usbmon: debugfs is not available
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf0608000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 16, io mem 0xf0607000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
116x: driver isp116x-hcd, 03 Nov 2005
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001c40
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 17, io base 0x00001c20
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 2-2: new high speed USB device using ehci_hcd and address 2
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001c00
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb 2-2: configuration #1 chosen from 1 choice
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018c0
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.3: irq 19, io base 0x000018a0
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
sl811: driver sl811-hcd, 19 May 2005
Initializing USB Mass Storage driver...
scsi8 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
input: AT Translated Set 2 keyboard as /class/input/input4
raid6: int32x1   1211 MB/s
raid6: int32x2   1329 MB/s
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[9ef59000155868ac]
raid6: int32x4    951 MB/s
raid6: int32x8    875 MB/s
raid6: mmxx1     4040 MB/s
raid6: mmxx2     4926 MB/s
raid6: sse1x1    3644 MB/s
raid6: sse1x2    4395 MB/s
raid6: sse2x1    7149 MB/s
raid6: sse2x2    8612 MB/s
raid6: using algorithm sse2x2 (8612 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: =
dm-devel@redhat.com
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Starting balanced_irq
Using IPI No-Shortcut mode
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
RAMDISK: Compressed image found at block 0
EXT4-fs warning (device ram0): ext4_fill_super: extents feature not =
enabled on this filesystem, use tune2fs.

EXT4-fs: ram0: not marked OK to use with test code.
VFS: Mounted root (ext2 filesystem).
Freeing unused kernel memory: 392k freed
squashfs: version 3.4 (2008/08/26) Phillip Lougher
squashfs: LZMA suppport for slax.org by jro
aufs 20081201
fuse init (API version 7.9)
GFS2: Unrecognized block device or mount point /dev/sr0
GFS2: gfs2 mount does not exist
GFS2: Unrecognized block device or mount point /dev/sr0
GFS2: gfs2 mount does not exist
UDF-fs: No partition found (1)
(1912,0):ocfs2_fill_super:624 ERROR: superblock probe failed!
GFS2: Unrecognized block device or mount point /dev/sda
GFS2: gfs2 mount does not exist
UDF-fs: No partition found (1)
(1933,0):ocfs2_fill_super:624 ERROR: superblock probe failed!
GFS2: Unrecognized block device or mount point /dev/sda
GFS2: gfs2 mount does not exist
scsi 8:0:0:0: Direct-Access     Generic  Flash Disk       8.07 PQ: 0 =
ANSI: 2
sd 8:0:0:0: [sdb] 2002944 512-byte hardware sectors (1026 MB)
sd 8:0:0:0: [sdb] Write Protect is off
sd 8:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 8:0:0:0: [sdb] Assuming drive cache: write through
sd 8:0:0:0: [sdb] 2002944 512-byte hardware sectors (1026 MB)
sd 8:0:0:0: [sdb] Write Protect is off
sd 8:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 8:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 8:0:0:0: [sdb] Attached SCSI removable disk
usb-storage: device scan complete
UDF-fs: No VRS found
(2242,6):ocfs2_fill_super:624 ERROR: superblock probe failed!
GFS2: Unrecognized block device or mount point /dev/sdb
GFS2: gfs2 mount does not exist
UDF-fs: No VRS found
(2263,6):ocfs2_fill_super:624 ERROR: superblock probe failed!
GFS2: Unrecognized block device or mount point /dev/sdb
GFS2: gfs2 mount does not exist
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: Unknown model for ALC662, trying auto-probe from BIOS...
sd 2:0:0:0: Attached scsi generic sg0 type 0
sr 6:0:0:0: Attached scsi generic sg1 type 5
sd 8:0:0:0: Attached scsi generic sg2 type 0
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:08:00.1: SDHCI controller found [197b:2382] (rev 0)
sdhci-pci 0000:08:00.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sdhci-pci 0000:08:00.1: setting latency timer to 64
mmc0: SDHCI controller on PCI [0000:08:00.1] using DMA
sdhci-pci 0000:08:00.2: SDHCI controller found [197b:2381] (rev 0)
sdhci-pci 0000:08:00.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sdhci-pci 0000:08:00.2: Refusing to bind to secondary interface.
sdhci-pci 0000:08:00.2: PCI INT A disabled
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
r8169 0000:06:00.0: setting latency timer to 64
r8169 0000:06:00.0: no MSI. Back to INTx.
eth0: RTL8168c/8111c at 0xf8d5a000, 00:90:f5:9e:ac:68, XID 3c4000c0 IRQ =
17
Generic kernel compatibility enabled based on linux-next next-20100113
cfg80211: Calling CRDA to update world regulatory domain
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
iwlagn: Copyright(c) 2003-2010 Intel Corporation
iwlagn 0000:07:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwlagn 0000:07:00.0: setting latency timer to 64
iwlagn 0000:07:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, =
REV=3D0x74
iwlagn 0000:07:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:07:00.0: firmware: requesting iwlwifi-6000-4.ucode
iwlagn 0000:07:00.0: loaded firmware version 9.193.4.1
phy0: Selected rate control algorithm 'iwl-agn-rs'
ath9k 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ath9k 0000:04:00.0: setting latency timer to 64
ath: EEPROM regdomain: 0x10
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: CO
ath: Regpair used: 0x10
phy1: Selected rate control algorithm 'ath9k_rate_control'
Registered led device: ath9k-phy1::radio
Registered led device: ath9k-phy1::assoc
Registered led device: ath9k-phy1::tx
Registered led device: ath9k-phy1::rx
phy1: Atheros AR5418 MAC/BB Rev:2 AR2122 RF Rev:81 mem=3D0xf9fa0000, =
irq=3D16
cfg80211: Calling CRDA for country: CO
input: ImPS/2 Synaptics TouchPad as /class/input/input5
input: PC Speaker as /class/input/input6
ppdev: user-space parallel port driver
lp: driver loaded but no devices found
Linux agpgart interface v0.103
e1000e: Intel(R) PRO/1000 Network Driver - 1.1.2-NAPI
e1000e: Copyright(c) 1999 - 2009 Intel Corporation.
Intel ISA PCIC probe: not found.
Databook TCIC-2 PCMCIA probe: not found.
r8169: eth0: link down
root@vosk:~# iw list
Wiphy phy1
	Band 1:
		Capabilities: 0x104e
			HT20/HT40
			SM Power Save disabled
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 7935 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT TX/RX MCS rate indexes supported: 0-15
		Frequencies:
			* 2412 MHz [1] (20.0 dBm)
			* 2417 MHz [2] (20.0 dBm)
			* 2422 MHz [3] (20.0 dBm)
			* 2427 MHz [4] (20.0 dBm)
			* 2432 MHz [5] (20.0 dBm)
			* 2437 MHz [6] (20.0 dBm)
			* 2442 MHz [7] (20.0 dBm)
			* 2447 MHz [8] (20.0 dBm)
			* 2452 MHz [9] (20.0 dBm)
			* 2457 MHz [10] (20.0 dBm)
			* 2462 MHz [11] (20.0 dBm)
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
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * monitor
		 * mesh point
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
		 * Unknown command (55)
		 * Unknown command (57)
		 * Unknown command (59)
		 * set_wiphy_netns
		 * connect
		 * disconnect
Wiphy phy0
	Band 1:
		Capabilities: 0x872
			HT20/HT40
			Static SM Power Save
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 3839 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT TX/RX MCS rate indexes supported: 0-23, 32
		Frequencies:
			* 2412 MHz [1] (15.0 dBm)
			* 2417 MHz [2] (15.0 dBm)
			* 2422 MHz [3] (15.0 dBm)
			* 2427 MHz [4] (15.0 dBm)
			* 2432 MHz [5] (15.0 dBm)
			* 2437 MHz [6] (15.0 dBm)
			* 2442 MHz [7] (15.0 dBm)
			* 2447 MHz [8] (15.0 dBm)
			* 2452 MHz [9] (15.0 dBm)
			* 2457 MHz [10] (15.0 dBm)
			* 2462 MHz [11] (15.0 dBm)
			* 2467 MHz [12] (15.0 dBm) (passive scanning, no =
IBSS)
			* 2472 MHz [13] (15.0 dBm) (passive scanning, no =
IBSS)
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
	Band 2:
		Capabilities: 0x872
			HT20/HT40
			Static SM Power Save
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 3839 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT TX/RX MCS rate indexes supported: 0-23, 32
		Frequencies:
			* 5180 MHz [36] (15.0 dBm) (passive scanning, no =
IBSS)
			* 5200 MHz [40] (15.0 dBm) (passive scanning, no =
IBSS)
			* 5220 MHz [44] (15.0 dBm) (passive scanning, no =
IBSS)
			* 5240 MHz [48] (15.0 dBm) (passive scanning, no =
IBSS)
			* 5260 MHz [52] (15.0 dBm) (passive scanning, no =
IBSS, radar detection)
			* 5280 MHz [56] (15.0 dBm) (passive scanning, no =
IBSS, radar detection)
			* 5300 MHz [60] (15.0 dBm) (passive scanning, no =
IBSS, radar detection)
			* 5320 MHz [64] (15.0 dBm) (passive scanning, no =
IBSS, radar detection)
			* 5500 MHz [100] (15.0 dBm) (passive scanning, =
no IBSS, radar detection)
			* 5520 MHz [104] (15.0 dBm) (passive scanning, =
no IBSS, radar detection)
			* 5540 MHz [108] (15.0 dBm) (passive scanning, =
no IBSS, radar detection)
			* 5560 MHz [112] (15.0 dBm) (passive scanning, =
no IBSS, radar detection)
			* 5580 MHz [116] (15.0 dBm) (passive scanning, =
no IBSS, radar detection)
			* 5600 MHz [120] (15.0 dBm) (passive scanning, =
no IBSS, radar detection)
			* 5620 MHz [124] (15.0 dBm) (passive scanning, =
no IBSS, radar detection)
			* 5640 MHz [128] (15.0 dBm) (passive scanning, =
no IBSS, radar detection)
			* 5660 MHz [132] (15.0 dBm) (passive scanning, =
no IBSS, radar detection)
			* 5680 MHz [136] (15.0 dBm) (passive scanning, =
no IBSS, radar detection)
			* 5700 MHz [140] (15.0 dBm) (passive scanning, =
no IBSS, radar detection)
			* 5745 MHz [149] (15.0 dBm) (passive scanning, =
no IBSS)
			* 5765 MHz [153] (15.0 dBm) (passive scanning, =
no IBSS)
			* 5785 MHz [157] (15.0 dBm) (passive scanning, =
no IBSS)
			* 5805 MHz [161] (15.0 dBm) (passive scanning, =
no IBSS)
			* 5825 MHz [165] (15.0 dBm) (passive scanning, =
no IBSS)
		Bitrates (non-HT):
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
	max # scan SSIDs: 20
	Supported interface modes:
		 * IBSS
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
		 * Unknown command (55)
		 * Unknown command (57)
		 * Unknown command (59)
		 * set_wiphy_netns
		 * connect
		 * disconnect
root@vosk:~# uname -a
Linux vosk 2.6.27.8 #1 SMP Sun Dec 7 08:30:31 Local time zone must be =
set--see zic m i686 Intel(R) Core(TM) i7 CPU         930  @ 2.80GHz =
GenuineIntel GNU/Linux
root@vosk:~# exit

Script done on Wed Apr 28 14:57:29 2010

--Apple-Mail-122-48968645
Content-Disposition: attachment;
	filename=brick.txt
Content-Type: text/plain;
	name="brick.txt"
Content-Transfer-Encoding: quoted-printable

Script started on Thu Apr 29 03:43:00 2010
root@vosk:~# lspci
00:00.0 Host bridge: Intel Corporation Clarksfield/Lynnfield DMI (rev =
11)
00:03.0 PCI bridge: Intel Corporation Clarksfield/Lynnfield PCI Express =
Root Port 1 (rev 11)
00:08.0 System peripheral: Intel Corporation Clarksfield/Lynnfield =
System Management Registers (rev 11)
00:08.1 System peripheral: Intel Corporation Clarksfield/Lynnfield =
Semaphore and Scratchpad Registers (rev 11)
00:08.2 System peripheral: Intel Corporation Clarksfield/Lynnfield =
System Control and Status Registers (rev 11)
00:08.3 System peripheral: Intel Corporation Clarksfield/Lynnfield =
Miscellaneous Registers (rev 11)
00:10.0 System peripheral: Intel Corporation QPI Link (rev 11)
00:10.1 System peripheral: Intel Corporation QPI Routing and Protocol =
Registers (rev 11)
00:19.0 Ethernet controller: Intel Corporation Unknown device 10f0 (rev =
05)
00:1a.0 USB Controller: Intel Corporation Ibex Peak USB2 Enhanced Host =
Controller (rev 05)
00:1b.0 Audio device: Intel Corporation Ibex Peak High Definition Audio =
(rev 05)
00:1c.0 PCI bridge: Intel Corporation Ibex Peak PCI Express Root Port 1 =
(rev 05)
00:1c.4 PCI bridge: Intel Corporation Ibex Peak PCI Express Root Port 5 =
(rev 05)
00:1c.6 PCI bridge: Intel Corporation Ibex Peak PCI Express Root Port 7 =
(rev 05)
00:1d.0 USB Controller: Intel Corporation Ibex Peak USB2 Enhanced Host =
Controller (rev 05)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a5)
00:1f.0 ISA bridge: Intel Corporation Ibex Peak LPC Interface Controller =
(rev 05)
00:1f.2 IDE interface: Intel Corporation Ibex Peak 4 port SATA IDE =
Controller (rev 05)
00:1f.3 SMBus: Intel Corporation Ibex Peak SMBus Controller (rev 05)
00:1f.5 IDE interface: Intel Corporation Ibex Peak 2 port SATA IDE =
Controller (rev 05)
01:00.0 VGA compatible controller: nVidia Corporation Unknown device =
0615 (rev a2)
03:00.0 Network controller: RaLink RT2860
05:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A =
IEEE-1394a-2000 Controller (PHY/Link)
root@vosk:~# dmesg
000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE =3D=3D> [0000006000 - =
0000007000]
  #3 [0000100000 - 00009f2210]    TEXT DATA BSS =3D=3D> [0000100000 - =
00009f2210]
  #4 [00009f3000 - 00009f7000]    INIT_PG_TABLE =3D=3D> [00009f3000 - =
00009f7000]
  #5 [000009ec00 - 0000100000]    BIOS reserved =3D=3D> [000009ec00 - =
0000100000]
  #6 [0000007000 - 0000008000]          PGTABLE =3D=3D> [0000007000 - =
0000008000]
  #7 [00009f7000 - 0000c4ff44]      NEW RAMDISK =3D=3D> [00009f7000 - =
0000c4ff44]
  #8 [0000008000 - 000000f000]          BOOTMAP =3D=3D> [0000008000 - =
000000f000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00038000
  HighMem  0x00038000 -> 0x000cf800
Movable zone start PFN for each node
early_node_map[6] active PFN ranges
    0: 0x00000000 -> 0x0000008f
    0: 0x00000100 -> 0x000cf671
    0: 0x000cf6bf -> 0x000cf6e5
    0: 0x000cf7bf -> 0x000cf7e8
    0: 0x000cf7f2 -> 0x000cf7f3
    0: 0x000cf7ff -> 0x000cf800
On node 0 totalpages: 849489
free_area_init_node: node 0, pgdat c08ef680, node_mem_map c1000000
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 615378 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a701 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 8 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
PM: Registered nosave memory: 000000000008f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at d4000000 (gap: d0000000:28000000)
PERCPU: Allocating 39324 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 8, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: =
842849
Kernel command line: initrd=3D/boot/initrd.gz ramdisk_size=3D6666 =
root=3D/dev/ram0 rw BOOT_IMAGE=3D/boot/vmlinuz=20
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Extended CMOS year: 2000
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 2800.081 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3357648k/3399680k available (6197k kernel code, 39412k reserved, =
2023k data, 392k init, 2480904k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe18000 - 0xfffff000   (1948 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0913000 - 0xc0975000   ( 392 kB)
      .data : 0xc070d417 - 0xc09070f8   (2023 kB)
      .text : 0xc0100000 - 0xc070d417   (6197 kB)
Checking if this processor honours the WP bit even in supervisor =
mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D8, =
Nodes=3D1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer =
frequency.. 5600.16 BogoMIPS (lpj=3D11200324)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080609
ENABLING IO-APIC IRQs
..TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
CPU0: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5599.98 BogoMIPS =
(lpj=3D11199970)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2/2 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5599.99 BogoMIPS =
(lpj=3D11199990)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3/3 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5600.00 BogoMIPS =
(lpj=3D11200007)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Booting processor 4/4 ip 6000
Initializing CPU#4
Calibrating delay using timer specific routine.. 5599.99 BogoMIPS =
(lpj=3D11199997)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#4.
x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
CPU4: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
checking TSC synchronization [CPU#0 -> CPU#4]: passed.
Booting processor 5/5 ip 6000
Initializing CPU#5
Calibrating delay using timer specific routine.. 5600.00 BogoMIPS =
(lpj=3D11200006)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#5.
x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
CPU5: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
checking TSC synchronization [CPU#0 -> CPU#5]: passed.
Booting processor 6/6 ip 6000
Initializing CPU#6
Calibrating delay using timer specific routine.. 5600.00 BogoMIPS =
(lpj=3D11200001)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#6.
x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
CPU6: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
checking TSC synchronization [CPU#0 -> CPU#6]: passed.
Booting processor 7/7 ip 6000
Initializing CPU#7
Calibrating delay using timer specific routine.. 5599.99 BogoMIPS =
(lpj=3D11199995)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#7.
x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
CPU7: Intel(R) Core(TM) i7 CPU         860  @ 2.80GHz stepping 05
checking TSC synchronization [CPU#0 -> CPU#7]: passed.
Brought up 8 CPUs
Total of 8 processors activated (44800.14 BogoMIPS).
net_namespace: 768 bytes
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  : 10720.000 MB/sec
xor: using function: pIII_sse (10720.000 MB/sec)
NET: Registered protocol family 16
No dock devices found.
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: MCFG area at f8000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
PCI: 0000:00:19.0 reg 10 32bit mmio: [e3200000, e321ffff]
PCI: 0000:00:19.0 reg 14 32bit mmio: [e3224000, e3224fff]
PCI: 0000:00:19.0 reg 18 io port: [2020, 203f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
PCI: 0000:00:1a.0 reg 10 32bit mmio: [e3225400, e32257ff]
pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: PME# disabled
PCI: 0000:00:1b.0 reg 10 64bit mmio: [e3220000, e3223fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.6: PME# disabled
PCI: 0000:00:1d.0 reg 10 32bit mmio: [e3225000, e32253ff]
pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: PME# disabled
PCI: 0000:00:1f.2 reg 10 io port: [2098, 209f]
PCI: 0000:00:1f.2 reg 14 io port: [20ac, 20af]
PCI: 0000:00:1f.2 reg 18 io port: [2090, 2097]
PCI: 0000:00:1f.2 reg 1c io port: [20a8, 20ab]
PCI: 0000:00:1f.2 reg 20 io port: [2070, 207f]
PCI: 0000:00:1f.2 reg 24 io port: [2060, 206f]
PCI: 0000:00:1f.3 reg 10 64bit mmio: [e3225800, e32258ff]
PCI: 0000:00:1f.3 reg 20 io port: [2000, 201f]
PCI: 0000:00:1f.5 reg 10 io port: [2088, 208f]
PCI: 0000:00:1f.5 reg 14 io port: [20a4, 20a7]
PCI: 0000:00:1f.5 reg 18 io port: [2080, 2087]
PCI: 0000:00:1f.5 reg 1c io port: [20a0, 20a3]
PCI: 0000:00:1f.5 reg 20 io port: [2050, 205f]
PCI: 0000:00:1f.5 reg 24 io port: [2040, 204f]
PCI: 0000:01:00.0 reg 10 32bit mmio: [e2000000, e2ffffff]
PCI: 0000:01:00.0 reg 14 64bit mmio: [d0000000, dfffffff]
PCI: 0000:01:00.0 reg 1c 64bit mmio: [e0000000, e1ffffff]
PCI: 0000:01:00.0 reg 24 io port: [1000, 107f]
PCI: 0000:01:00.0 reg 30 32bit mmio: [fffe0000, ffffffff]
PCI: bridge 0000:00:03.0 io port: [1000, 1fff]
PCI: bridge 0000:00:03.0 32bit mmio: [e0000000, e2ffffff]
PCI: bridge 0000:00:03.0 64bit mmio pref: [d0000000, dfffffff]
PCI: 0000:03:00.0 reg 10 32bit mmio: [e3100000, e310ffff]
pci 0000:03:00.0: PME# supported from D0 D3hot
pci 0000:03:00.0: PME# disabled
PCI: bridge 0000:00:1c.4 32bit mmio: [e3100000, e31fffff]
PCI: 0000:05:03.0 reg 10 32bit mmio: [e3004000, e30047ff]
PCI: 0000:05:03.0 reg 14 32bit mmio: [e3000000, e3003fff]
pci 0000:05:03.0: supports D1
pci 0000:05:03.0: supports D2
pci 0000:05:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:05:03.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 32bit mmio: [e3000000, e30fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 *9 10 11 12)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
system 00:01: iomem range 0xf8000000-0xfbffffff could not be reserved
system 00:01: iomem range 0xfeb00000-0xfeb03fff has been reserved
system 00:01: iomem range 0xfed10000-0xfed13fff has been reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed1b000-0xfed1bfff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:01: iomem range 0xfed1a000-0xfed1afff has been reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
system 00:01: iomem range 0xc0000-0xdffff could not be reserved
system 00:01: iomem range 0xe0000-0xfffff could not be reserved
system 00:01: iomem range 0xff000000-0xffffffff could not be reserved
system 00:06: ioport range 0x500-0x57f has been reserved
system 00:06: ioport range 0x400-0x47f has been reserved
system 00:06: ioport range 0x680-0x6ff has been reserved
pci 0000:01:00.0: BAR 6: can't allocate mem resource =
[0xe0000000-0xdfffffff]
pci 0000:00:03.0: PCI bridge, secondary bus 0000:01
pci 0000:00:03.0:   IO window: 0x1000-0x1fff
pci 0000:00:03.0:   MEM window: 0xe0000000-0xe2ffffff
pci 0000:00:03.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.4:   IO window: disabled
pci 0000:00:1c.4:   MEM window: 0xe3100000-0xe31fffff
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1c.6: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.6:   IO window: disabled
pci 0000:00:1c.6:   MEM window: disabled
pci 0000:00:1c.6:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: 0xe3000000-0xe30fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.6: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffff]
bus: 01 index 0 io port: [1000, 1fff]
bus: 01 index 1 mmio: [e0000000, e2ffffff]
bus: 01 index 2 mmio: [d0000000, dfffffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 mmio: [0, 0]
bus: 02 index 1 mmio: [0, 0]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 mmio: [0, 0]
bus: 03 index 1 mmio: [e3100000, e31fffff]
bus: 03 index 2 mmio: [0, 0]
bus: 03 index 3 mmio: [0, 0]
bus: 04 index 0 mmio: [0, 0]
bus: 04 index 1 mmio: [0, 0]
bus: 04 index 2 mmio: [0, 0]
bus: 04 index 3 mmio: [0, 0]
bus: 05 index 0 mmio: [0, 0]
bus: 05 index 1 mmio: [e3000000, e30fffff]
bus: 05 index 2 mmio: [0, 0]
bus: 05 index 3 io port: [0, ffff]
bus: 05 index 4 mmio: [0, ffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...it isn't (no cpio magic); looks like an =
initrd
Freeing initrd memory: 2403k freed
apm: BIOS not found.
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
NTFS driver 2.1.29 [Flags: R/O].
JFS: nTxBlock =3D 8192, nTxLock =3D 65536
SGI XFS with ACLs, security attributes, large block numbers, no debug =
enabled
SGI XFS Quota Management subsystem
OCFS2 1.5.0
OCFS2 Node Manager 1.5.0
GFS2 (built Dec  7 2008 08:26:41) installed
msgmni has been set to 1718
async_tx: api initialized (sync-only)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:03.0: setting latency timer to 64
pcieport-driver 0000:00:03.0: found MSI capability
pci_express 0000:00:03.0:pcie00: allocate port service
pci_express 0000:00:03.0:pcie01: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pcieport-driver 0000:00:1c.4: setting latency timer to 64
pcieport-driver 0000:00:1c.4: found MSI capability
pci_express 0000:00:1c.4:pcie00: allocate port service
pci_express 0000:00:1c.4:pcie02: allocate port service
pcieport-driver 0000:00:1c.6: setting latency timer to 64
pcieport-driver 0000:00:1c.6: found MSI capability
pci_express 0000:00:1c.6:pcie00: allocate port service
pci_express 0000:00:1c.6:pcie02: allocate port service
aer 0000:00:03.0:pcie01: service driver aer loaded
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input1
ACPI: Sleep Button (CM) [SLPB]
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C3[C3])
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: CPU1 (power states: C1[C1] C3[C3])
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: CPU2 (power states: C1[C1] C3[C3])
processor ACPI0007:02: registered as cooling_device2
ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI: CPU3 (power states: C1[C1] C3[C3])
processor ACPI0007:03: registered as cooling_device3
ACPI: Processor [CPU3] (supports 8 throttling states)
ACPI: CPU4 (power states: C1[C1] C3[C3])
processor ACPI0007:04: registered as cooling_device4
ACPI: Processor [CPU4] (supports 8 throttling states)
ACPI: CPU5 (power states: C1[C1] C3[C3])
processor ACPI0007:05: registered as cooling_device5
ACPI: Processor [CPU5] (supports 8 throttling states)
ACPI: CPU6 (power states: C1[C1] C3[C3])
processor ACPI0007:06: registered as cooling_device6
ACPI: Processor [CPU6] (supports 8 throttling states)
ACPI: CPU7 (power states: C1[C1] C3[C3])
processor ACPI0007:07: registered as cooling_device7
ACPI: Processor [CPU7] (supports 8 throttling states)
Marking TSC unstable due to TSC halts in C3
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
Uniform Multi-Platform E-IDE driver
ide_generic: please use "probe_mask=3D0x3f" module parameter for probing =
all legacy ISA IDE ports
Probing IDE interface ide0...
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide-floppy driver 1.00
Loading iSCSI transport class v2.0-870.
iscsi: registered transport (tcp)
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver 1.1-5[2456]-ms
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
scsi: <fdomain> Detection failed (no card)
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address and IRQ using =
iobase=3D and irq=3D options<6>QLogic Fibre Channel HBA Driver: =
8.02.01-k7
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.2.7
Copyright(c) 2004-2008 Emulex.  All rights reserved.
Failed initialization of WD-7000 SCSI card!
DC390: clustering now enabled by default. If you get problems load
	with "disable_clustering=3D1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
GDT-HA: Storage RAID Controller Driver. Version: 3.05
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.011.
nsp32: loading...
ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
st: Version 20080504, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata1: SATA max UDMA/133 cmd 0x2098 ctl 0x20ac bmdma 0x2070 irq 19
ata2: SATA max UDMA/133 cmd 0x2090 ctl 0x20a8 bmdma 0x2078 irq 19
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
ata_piix 0000:00:1f.5: setting latency timer to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata3: SATA max UDMA/133 cmd 0x2088 ctl 0x20a4 bmdma 0x2050 irq 19
ata4: SATA max UDMA/133 cmd 0x2080 ctl 0x20a0 bmdma 0x2058 irq 19
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
I2O subsystem v1.325
i2o: max drivers =3D 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
I2O Block Device OSM v1.325
I2O SCSI Peripheral OSM v1.316
I2O ProcFS OSM v1.316
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SPI Host driver 3.04.07
Fusion MPT FC Host driver 3.04.07
Fusion MPT SAS Host driver 3.04.07
ohci1394 0000:05:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[19]  =
MMIO=3D[e3004000-e30047ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]
usbmon: debugfs is not available
ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ehci_hcd 0000:00:1a.0: setting latency timer to 64
ehci_hcd 0000:00:1a.0: EHCI Host Controller
ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.0: debug port 2
ehci_hcd 0000:00:1a.0: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.0: irq 16, io mem 0xe3225400
ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.0: setting latency timer to 64
ehci_hcd 0000:00:1d.0: EHCI Host Controller
ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.0: debug port 2
ehci_hcd 0000:00:1d.0: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.0: irq 23, io mem 0xe3225000
usb 1-1: new high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb 1-1: configuration #1 chosen from 1 choice
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 6 ports detected
116x: driver isp116x-hcd, 03 Nov 2005
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
sl811: driver sl811-hcd, 19 May 2005
Initializing USB Mass Storage driver...
usb 2-1: new high speed USB device using ehci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 8 ports detected
usb 1-1.1: new low speed USB device using ehci_hcd and address 3
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[009027000254b0f2]
usb 1-1.1: configuration #1 chosen from 1 choice
usb 1-1.4: new high speed USB device using ehci_hcd and address 4
usb 1-1.4: configuration #1 chosen from 1 choice
usb 2-1.4: new low speed USB device using ehci_hcd and address 3
usb 2-1.4: configuration #1 chosen from 1 choice
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
i8042.c: No controller found.
mice: PS/2 mouse device common for all mice
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid6: int32x1   1075 MB/s
raid6: int32x2   1187 MB/s
raid6: int32x4    877 MB/s
raid6: int32x8    805 MB/s
raid6: mmxx1     3532 MB/s
raid6: mmxx2     4413 MB/s
raid6: sse1x1    3231 MB/s
raid6: sse1x2    3938 MB/s
raid6: sse2x1    6437 MB/s
raid6: sse2x2    7789 MB/s
raid6: using algorithm sse2x2 (7789 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: =
dm-devel@redhat.com
usbcore: registered new interface driver hiddev
input: Fellowes Opti mouse3 as /class/input/input2
input: USB HID v1.10 Mouse [Fellowes Opti mouse3] on =
usb-0000:00:1a.0-1.1
input: DELL DELL USB Keyboard as /class/input/input3
input: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on =
usb-0000:00:1d.0-1.4
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Starting balanced_irq
Using IPI No-Shortcut mode
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
RAMDISK: Compressed image found at block 0
EXT4-fs warning (device ram0): ext4_fill_super: extents feature not =
enabled on this filesystem, use tune2fs.

EXT4-fs: ram0: not marked OK to use with test code.
VFS: Mounted root (ext2 filesystem).
Freeing unused kernel memory: 392k freed
squashfs: version 3.4 (2008/08/26) Phillip Lougher
squashfs: LZMA suppport for slax.org by jro
aufs 20081201
fuse init (API version 7.9)
scsi 6:0:0:0: Direct-Access     Generic  Flash Disk       8.07 PQ: 0 =
ANSI: 2
sd 6:0:0:0: [sda] 2002944 512-byte hardware sectors (1026 MB)
sd 6:0:0:0: [sda] Write Protect is off
sd 6:0:0:0: [sda] Mode Sense: 03 00 00 00
sd 6:0:0:0: [sda] Assuming drive cache: write through
sd 6:0:0:0: [sda] 2002944 512-byte hardware sectors (1026 MB)
sd 6:0:0:0: [sda] Write Protect is off
sd 6:0:0:0: [sda] Mode Sense: 03 00 00 00
sd 6:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 6:0:0:0: [sda] Attached SCSI removable disk
usb-storage: device scan complete
UDF-fs: No VRS found
(1908,1):ocfs2_fill_super:624 ERROR: superblock probe failed!
GFS2: Unrecognized block device or mount point /dev/sda
GFS2: gfs2 mount does not exist
UDF-fs: No VRS found
(1929,4):ocfs2_fill_super:624 ERROR: superblock probe failed!
GFS2: Unrecognized block device or mount point /dev/sda
GFS2: gfs2 mount does not exist
e1000e: Intel(R) PRO/1000 Network Driver - 1.1.2-NAPI
e1000e: Copyright(c) 1999 - 2009 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e1000e 0000:00:19.0: setting latency timer to 64
0000:00:19.0: : Failed to initialize MSI interrupts.  Falling back to =
legacy interrupts.
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:27:0e:03:c7:91
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 10, PHY: 0, PBA No: ffffff-0ff
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
Generic kernel compatibility enabled based on linux-next next-20100113
sd 6:0:0:0: Attached scsi generic sg0 type 0
cfg80211: Calling CRDA to update world regulatory domain
rt2800pci 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
rt2800pci 0000:03:00.0: setting latency timer to 64
phy0: Selected rate control algorithm 'minstrel'
Registered led device: rt2800pci-phy0::radio
Registered led device: rt2800pci-phy0::assoc
Registered led device: rt2800pci-phy0::quality
input: PC Speaker as /class/input/input4
lp: driver loaded but no devices found
ppdev: user-space parallel port driver
Linux agpgart interface v0.103
Intel ISA PCIC probe: not found.
Databook TCIC-2 PCMCIA probe: not found.
rt2800pci 0000:03:00.0: firmware: requesting rt2860.bin
phy0 -> rt2800pci_mcu_status: Error - MCU request failed, no response =
from hardware
root@vosk:~# iw list
Wiphy phy0
	Band 1:
		Capabilities: 0x3f2
			HT20/HT40
			Static SM Power Save
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			TX STBC
			RX STBC 3-streams
			Max AMSDU length: 7935 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 2 usec (0x04)
		HT RX MCS rate indexes supported: 0-15, 32
		TX unequal modulation not supported
		HT TX Max spatial streams: 1
		HT TX MCS rate indexes supported may differ
		Frequencies:
			* 2412 MHz [1] (5.0 dBm)
			* 2417 MHz [2] (5.0 dBm)
			* 2422 MHz [3] (5.0 dBm)
			* 2427 MHz [4] (6.0 dBm)
			* 2432 MHz [5] (6.0 dBm)
			* 2437 MHz [6] (7.0 dBm)
			* 2442 MHz [7] (7.0 dBm)
			* 2447 MHz [8] (7.0 dBm)
			* 2452 MHz [9] (8.0 dBm)
			* 2457 MHz [10] (8.0 dBm)
			* 2462 MHz [11] (9.0 dBm)
			* 2467 MHz [12] (9.0 dBm) (passive scanning, no =
IBSS)
			* 2472 MHz [13] (9.0 dBm) (passive scanning, no =
IBSS)
			* 2484 MHz [14] (9.0 dBm) (passive scanning, no =
IBSS)
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
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * WDS
		 * monitor
		 * mesh point
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
		 * Unknown command (55)
		 * Unknown command (57)
		 * Unknown command (59)
		 * set_wiphy_netns
		 * connect
		 * disconnect
root@vosk:~# exit

Script done on Thu Apr 29 03:43:12 2010

--Apple-Mail-122-48968645--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:27352 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837Ab0DYTvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Apr 2010 15:51:03 -0400
Date: Sun, 25 Apr 2010 21:50:58 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: b43 'hardware blocked' but only keyboard/led touch button
Message-ID: <20100425195058.GA12916@frolo.macqel>
References: <20100330192629.GA24060@frolo.macqel> <20100330193129.GA31847@srcf.ucam.org> <20100419115329.GA5306@frolo.macqel> <20100419145107.GB8017@srcf.ucam.org> <20100419150050.GA28290@frolo.macqel> <20100419150627.GA10680@srcf.ucam.org> <20100424054210.GA23836@frolo.macqel> <20100424152107.GA13417@srcf.ucam.org> <20100424195630.GA15053@frolo.macqel> <20100424200218.GA16084@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100424200218.GA16084@srcf.ucam.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Matthew,

On Sat, Apr 24, 2010 at 09:02:18PM +0100, Matthew Garrett wrote:
> On Sat, Apr 24, 2010 at 09:56:30PM +0200, Philippe De Muyter wrote:
> > On Sat, Apr 24, 2010 at 04:21:07PM +0100, Matthew Garrett wrote:
> > > Does this laptop also have bluetooth?
> > 
> > No
> 
> Hm. I have no idea why hitting the key doesn't change the colour then, 
> I'm afraid. On the other hand, it sounds like things are working now? 
> The only thing I can suggest is attempting to clear the CMOS data in the 
> BIOS menu and see if that changes things.

Just some more info :

when I power-on this laptop, the wifi led is red.  The wifi led stays
red while in the bios and in grub and during the very start of linux boot.
It becomes blue simultaneously with the displaying of the following message :

	ACPI: Core revision 20100121

(I started 2.6.34-rc5 with boot_delay=1000 to be sure)

When I touch the wifi led, sometimes I can see it flash red and directly
return to blue, but often I do not see this flash : the led simply remains
blue.

What's the use of having a soft blocking system when one also has a 'hard'
blocking system ?  (and actually sometimes there is also a third one,
because NetworkManager has wirelessEnabled=false in his state file)

Just for completeness about bluetooth, you'll find below the output of
lspci -vnn.

Philippe

00:00.0 Host bridge [0600]: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub [8086:2a40] (rev 07)
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=0a <?>

00:01.0 PCI bridge [0604]: Intel Corporation Mobile 4 Series Chipset PCI Express Graphics Port [8086:2a41] (rev 07) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00007000-00007fff
	Memory behind bridge: da000000-da0fffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
	Capabilities: [88] Subsystem: Hewlett-Packard Company Device [103c:3628]
	Capabilities: [80] Power Management version 3
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [a0] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [140] Root Complex Link
	Kernel driver in use: pcieport

00:1a.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 [8086:2937] (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 80e0 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 [8086:2938] (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at 80c0 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 [8086:293c] (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, medium devsel, latency 0, IRQ 19
	Memory at da105c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device [0403]: Intel Corporation 82801I (ICH9 Family) HD Audio Controller [8086:293e] (rev 03)
	Subsystem: Hewlett-Packard Company dv6-1190en [103c:3628]
	Flags: bus master, fast devsel, latency 0, IRQ 32
	Memory at da100000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Root Complex Link
	Kernel driver in use: HDA Intel

00:1c.0 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 [8086:2940] (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00006000-00006fff
	Memory behind bridge: d9000000-d9ffffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000d0ffffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device [103c:3628]
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport

00:1c.1 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 [8086:2942] (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: d8000000-d8ffffff
	Prefetchable memory behind bridge: 00000000d1000000-00000000d1ffffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device [103c:3628]
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport

00:1c.3 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 [8086:2946] (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: d7000000-d7ffffff
	Prefetchable memory behind bridge: 00000000d2000000-00000000d2ffffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device [103c:3628]
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport

00:1c.4 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 [8086:2948] (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: d6000000-d6ffffff
	Prefetchable memory behind bridge: 00000000d3000000-00000000d3ffffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device [103c:3628]
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport

00:1c.5 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 [8086:294a] (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=07, subordinate=09, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: d5000000-d5ffffff
	Prefetchable memory behind bridge: 00000000d4000000-00000000d4ffffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Hewlett-Packard Company Device [103c:3628]
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport

00:1d.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 [8086:2934] (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, medium devsel, latency 0, IRQ 20
	I/O ports at 80a0 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 [8086:2935] (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 8080 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 [8086:2936] (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 8060 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1d.3 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 [8086:2939] (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 8040 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 [8086:293a] (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, medium devsel, latency 0, IRQ 20
	Memory at da105800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev 93) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=32
	Capabilities: [50] Subsystem: Hewlett-Packard Company Device [103c:3628]

00:1f.0 ISA bridge [0601]: Intel Corporation ICH9M LPC Interface Controller [8086:2919] (rev 03)
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 SATA controller [0106]: Intel Corporation ICH9M/M-E SATA AHCI Controller [8086:2929] (rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: Hewlett-Packard Company dv6-1190en [103c:3628]
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 31
	I/O ports at 8108 [size=8]
	I/O ports at 8114 [size=4]
	I/O ports at 8100 [size=8]
	I/O ports at 8110 [size=4]
	I/O ports at 8020 [size=32]
	Memory at da105000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
	Capabilities: [70] Power Management version 3
	Capabilities: [a8] SATA HBA v1.0
	Capabilities: [b0] PCI Advanced Features
	Kernel driver in use: ahci

00:1f.3 SMBus [0c05]: Intel Corporation 82801I (ICH9 Family) SMBus Controller [8086:2930] (rev 03)
	Subsystem: Hewlett-Packard Company dv6-1190en [103c:3628]
	Flags: medium devsel, IRQ 18
	Memory at da106000 (64-bit, non-prefetchable) [size=256]
	I/O ports at 8000 [size=32]

00:1f.6 Signal processing controller [1180]: Intel Corporation 82801I (ICH9 Family) Thermal Subsystem [8086:2932] (rev 03)
	Subsystem: Hewlett-Packard Company dv6-1190en [103c:3628]
	Flags: fast devsel, IRQ 11
	Memory at da104000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [50] Power Management version 3

01:00.0 VGA compatible controller [0300]: ATI Technologies Inc M96 [Mobility Radeon HD 4650] [1002:9480] (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company ATI Mobility Radeon HD 4650 [dv6-1190en] [103c:3628]
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at c0000000 (32-bit, prefetchable) [size=256M]
	I/O ports at 7000 [size=256]
	Memory at da000000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at da020000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Legacy Endpoint, MSI 00
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>

01:00.1 Audio device [0403]: ATI Technologies Inc RV710/730 [1002:aa38]
	Subsystem: Hewlett-Packard Company ATI RV710/730 [dv6-1190en] [103c:3628]
	Flags: bus master, fast devsel, latency 0, IRQ 33
	Memory at da010000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Legacy Endpoint, MSI 00
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Kernel driver in use: HDA Intel

02:00.0 Network controller [0280]: Broadcom Corporation BCM4312 802.11b/g LP-PHY [14e4:4315] (rev 01)
	Subsystem: Hewlett-Packard Company Device [103c:1508]
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at d9000000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [58] Vendor Specific Information: Len=78 <?>
	Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [d0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [13c] Virtual Channel
	Capabilities: [160] Device Serial Number 00-00-00-ff-ff-00-ff-ff
	Capabilities: [16c] Power Budgeting <?>
	Kernel driver in use: b43-pci-bridge

03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 02)
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, fast devsel, latency 0, IRQ 30
	I/O ports at 5000 [size=256]
	Memory at d1010000 (64-bit, prefetchable) [size=4K]
	Memory at d1000000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at d1020000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
	Capabilities: [70] Express Endpoint, MSI 01
	Capabilities: [b0] MSI-X: Enable- Count=2 Masked-
	Capabilities: [d0] Vital Product Data
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Virtual Channel
	Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: r8169

06:00.0 FireWire (IEEE 1394) [0c00]: JMicron Technology Corp. IEEE 1394 Host Controller [197b:2380] (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at d6000000 (32-bit, non-prefetchable) [size=2K]
	Memory at d6000d00 (32-bit, non-prefetchable) [size=128]
	Memory at d6000c80 (32-bit, non-prefetchable) [size=128]
	Memory at d6000c00 (32-bit, non-prefetchable) [size=128]
	Capabilities: [44] Power Management version 3
	Capabilities: [80] Express Endpoint, MSI 00
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
	Kernel driver in use: ohci1394

06:00.1 System peripheral [0880]: JMicron Technology Corp. SD/MMC Host Controller [197b:2382]
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at d6000b00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
	Capabilities: [80] Express Endpoint, MSI 00
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
	Kernel driver in use: sdhci-pci

06:00.2 SD Host controller [0805]: JMicron Technology Corp. Standard SD Host Controller [197b:2381] (prog-if 01)
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: fast devsel, IRQ 16
	Memory at d6000a00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
	Capabilities: [80] Express Endpoint, MSI 00
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-

06:00.3 System peripheral [0880]: JMicron Technology Corp. MS Host Controller [197b:2383]
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at d6000900 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
	Capabilities: [80] Express Endpoint, MSI 00
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
	Kernel driver in use: jmb38x_ms

06:00.4 System peripheral [0880]: JMicron Technology Corp. xD Host Controller [197b:2384]
	Subsystem: Hewlett-Packard Company Device [103c:3628]
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at d6000800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a4] Power Management version 3
	Capabilities: [80] Express Endpoint, MSI 00
	Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-


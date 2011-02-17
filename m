Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:13550 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1BQQHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 11:07:16 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022160.msg
	for <linux-wireless@vger.kernel.org>; Thu, 17 Feb 2011 18:06:35 +0200
Subject: [RFC] AI support
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Content-Type: text/plain
Date: Thu, 17 Feb 2011 17:58:36 +0200
Message-Id: <1297958316.5623.27.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here is fixed and reworked proposal on introducing AI support with
existing SSB bus codebase. Patches are made agains latest
wireless-testing git as of writing.
http://www.znau.edu.ua/temp/ssb-ai-linux-wireless-testing/2011-02-17-ssb-add-AI-support.tar.bz2

I dont anymore abuse bus abstraction with ops (it was plain wrong as I
see now), just introduced AI over SSB support with appropriate helpers.
Code presented is tested with SSB on PCIE host, plain SSB, AI on
embeddables (for these pmu rev.5/6 and mips74k support patches are
required but that is a whole another story).
Stil looking for testground to test AI code
(014-ssb-add-AI-on-pci-host-support.patch) on PCIE host (ordered some hw
but will get one closely to feb. fall).

Here is dmesg for SSB on PCIE host (BCM4312):
[root@localhost ~]# dmesg | grep -E "[Bb]roadcom|ssb|b43"
b43-pci-bridge 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
b43-pci-bridge 0000:04:00.0: setting latency timer to 64
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F, vendor 0x4243)
ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
ssb: chipcommon status is 0x10
ssb: Found rev 1 PMU (capabilities 0x02A62F01)
ssb: SPROM offset is 0x1000
ssb: SPROM revision 8 detected.
ssb: Sonics Silicon Backplane (SB type) found on PCI device 0000:04:00.0
b43-phy0: Broadcom 4312 WLAN found (core revision 15)
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
Registered led device: b43-phy0::radio
Broadcom 43xx driver loaded [ Features: PNL, Firmware-ID: FW13 ]

Here is dmesg for SSB on embeddable (BCM5354):
root@OpenWrt:/# dmesg | grep -E "[Bb]roadcom|ssb|b4[34]"
CPU revision is: 00029029 (Broadcom BMIPS3300)
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x14, vendor 0x4243)
ssb: Core 1 found: Fast Ethernet (cc 0x806, rev 0x09, vendor 0x4243)
ssb: Core 2 found: MIPS 3302 (cc 0x816, rev 0x08, vendor 0x4243)
ssb: Core 3 found: USB 2.0 Host (cc 0x819, rev 0x02, vendor 0x4243)
ssb: Core 4 found: MEMC SDRAM (cc 0x80F, rev 0x04, vendor 0x4243)
ssb: Core 5 found: IEEE 802.11 (cc 0x812, rev 0x0D, vendor 0x4243)
ssb: Core 6 found: Roboswitch (cc 0x81C, rev 0x02, vendor 0x4243)
ssb: chipcommon status is 0x0
ssb: Found rev 0 PMU (capabilities 0x04A63400)
ssb: Initializing MIPS core...
ssb: set_irq: core 0x0806, irq 4 => 4
ssb: set_irq: core 0x0816, irq 5 => 2
ssb: set_irq: core 0x0812, irq 2 => 5
ssb: after irq reconfiguration
ssb: core 0x0800, irq : 2(S)  3* 4  5  6  D  I
ssb: core 0x0806, irq : 2(S)  3  4* 5  6  D  I
ssb: core 0x0816, irq : 2(S)* 3  4  5  6  D  I
ssb: core 0x0819, irq : 2(S)  3  4  5  6* D  I
ssb: core 0x080f, irq : 2(S)  3  4  5  6  D  I*
ssb: core 0x0812, irq : 2(S)  3  4  5* 6  D  I
ssb: core 0x081c, irq : 2(S)  3  4  5  6  D  I*
ssb: Sonics Silicon Backplane (SB type) found at address 0x18000000
b44: b44.c:v2.0
b44 ssb0:0: eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:90:4c:c0:00:00
b43-phy0: Broadcom 5354 WLAN found (core revision 13)
Broadcom 43xx driver loaded [ Features: P, Firmware-ID: FW13 ]
b44 ssb0:0: eth0: Link is up at 100 Mbps, full duplex
b44 ssb0:0: eth0: Flow control is off for TX and off for RX
b44 ssb0:0: eth0: powering down PHY
b44 ssb0:0: eth0: Link is up at 100 Mbps, full duplex
b44 ssb0:0: eth0: Flow control is off for TX and off for RX
ehci_hcd ssb0:1: SSB EHCI Controller
ehci_hcd ssb0:1: new USB bus registered, assigned bus number 1
ehci_hcd ssb0:1: irq 6, io mem 0x18003800
ehci_hcd ssb0:1: USB 0.0 started, EHCI 1.00

Here is dmesg for AI on embeddable (BCM4716):
root@OpenWrt:/# dmesg | grep -E "ssb|b43|[Bb]roadcom"
ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x1F, vendor 0x04BF)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x11, vendor 0x04BF)
ssb: Core 2 found: Gigabit MAC (cc 0x82D, rev 0x00, vendor 0x04BF)
ssb: Core 3 found: MIPS 74K (cc 0x82C, rev 0x01, vendor 0x04A7)
ssb: Core 4 found: USB 2.0 Host (cc 0x819, rev 0x04, vendor 0x04BF)
ssb: Core 5 found: PCI-E (cc 0x820, rev 0x0E, vendor 0x04BF)
ssb: Core 6 found: DDR1/2 memory controller (cc 0x82E, rev 0x01, vendor 0x04BF)
ssb: Core 7 found: Internal Memory (cc 0x80E, rev 0x07, vendor 0x04BF)
ssb: Core 8 found: I2S (cc 0x834, rev 0x00, vendor 0x04BF)
ssb: Found END of erom after 9 cores
ssb: chipcommon status is 0x800
ssb: Found rev 5 PMU (capabilities 0x11242C05)
ssb: Initializing MIPS core...
ssb: ssb_pmu5_clock: p1=1, p2=1, ndiv=48(0x30), m3=8, fc=960, clock=120
ssb: set_irq: core 0x0812, irq 3 => 3
ssb: set_irq: core 0x082d, irq 4 => 4
ssb: set_irq: core 0x0819, irq 5 => 5
ssb: after irq reconfiguration
ssb: core 0x0800, irq : 2(S)* 3  4  5  6  D  I
ssb: core 0x0812, irq : 2(S)  3* 4  5  6  D  I
ssb: core 0x082d, irq : 2(S)  3  4* 5  6  D  I
ssb: core 0x082c, irq : 2(S)  3  4  5  6  D  I*
ssb: core 0x0819, irq : 2(S)  3  4  5* 6  D  I
ssb: core 0x0820, irq : 2(S)  3  4  5  6* D  I
ssb: core 0x082e, irq : 2(S)* 3  4  5  6  D  I
ssb: core 0x080e, irq : 2(S)  3  4  5  6  D  I*
ssb: core 0x0834, irq : 2(S)* 3  4  5  6  D  I
ssb: Sonics Silicon Backplane (AI type) found at address 0x18000000
ssb: ssb_pmu5_clock: p1=1, p2=1, ndiv=48(0x30), m1=2, fc=960, clock=480
ssb: ssb_pmu5_clock: p1=1, p2=1, ndiv=48(0x30), m3=8, fc=960, clock=120
wl0: Broadcom BCM4329 802.11 Wireless Controller 5.10.56.27
ehci_hcd ssb0:2: SSB EHCI Controller
ehci_hcd ssb0:2: new USB bus registered, assigned bus number 1
ehci_hcd ssb0:2: irq 5, io mem 0x18004000
ehci_hcd ssb0:2: USB 0.0 started, EHCI 1.00

Have nice day,
George



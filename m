Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avasout05.plus.net ([84.93.230.250]:58870 "EHLO
	avasout05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2KSIr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 03:47:26 -0500
Message-ID: <50A9F0B0.9010006@bubblegen.co.uk> (sfid-20121119_094729_953665_5C3A7236)
Date: Mon, 19 Nov 2012 08:41:20 +0000
From: Matthew Lear <matt@bubblegen.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 43228 not initialised by b43
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

I'm running Gentoo with a x86_64 3.6.6 kernel on a Dell latitude 6420. I
have a Broadcom 43288 device which is detected by bcma but nothing
further happens.

Here is the device:

lspci -vnn -d 14e4:



02:00.0 Network controller [0280]: Broadcom Corporation BCM43228
802.11a/b/g/n [14e4:4359]


        Subsystem: Dell Wireless 1530 Half-size Mini PCIe Card
[1028:0011]


        Flags: bus master, fast devsel, latency 0, IRQ 17



        Memory at e2d00000 (64-bit, non-prefetchable) [size=16K]



        Capabilities: [40] Power Management version 3



        Capabilities: [58] Vendor Specific Information: Len=78 <?>



        Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+



        Capabilities: [d0] Express Endpoint, MSI 00



        Capabilities: [100] Advanced Error Reporting



        Capabilities: [13c] Virtual Channel



        Capabilities: [160] Device Serial Number 00-00-f5-ff-ff-39-84-4b



        Capabilities: [16c] Power Budgeting <?>



        Kernel driver in use: bcma-pci-bridge





Here is the output from BCMA:

[    0.703881] bcma: bus0: Found chip with id 0xA8DC, rev 0x00 and
package 0x08
[    0.703971] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id
0x800, rev 0x25, class 0x0)
[    0.704067] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id
0x812, rev 0x1E, class 0x0)
[    0.704190] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820,
rev 0x12, class 0x0)
[    0.704286] bcma: bus0: Core 3 found: SDIO Device (manuf 0x4BF, id
0x829, rev 0x07, class 0x0)
[    0.704500] bcma: bus0: Found rev 10 PMU (capabilities 0x108C260A)
[    0.704505] bcma: bus0: PMU resource config unknown or not needed for
device 0xA8DC
[    0.706504] bcma: bus0: Workarounds unknown or not needed for device
0xA8DC
[    0.714457] bcma: bus0: SPROM offset 0x830
[    0.716642] bcma: bus0: Bus registered


The b43 driver loads (ie prints 'Broadcom 43xx driver loaded [ Features:
PMNLS ]') but then nothing else happens (I'd expect to see some kind of
phy detection for example). It's possible that I could be missing a
kernel config option but I'm fairly certain I'm not.

I realise that the 43228 device is marked as untested in the table on
linux-wireless but I was hoping that it would work with b43.

I've added various debug instrumentation to b43 to try to establish
what's going on but it seems that the only activity is from b43_init().
There is no request to set up the core or load ucode etc.

I'd rather not use the closed source sta driver and the soft/full MAC
drivers don't support this device AFAIK (the STA driver loads and
detects the device but I constantly get crashes in the 80211 sub-sys
when the interface gets accessed).

I'd appreciate any thoughts anyone might have about how I can proceed
with getting wifi working with b43. I've tried a lot of things.
Hopefully there's something I've missed. All help / comments appreciated.

Many thanks,
--  Matt

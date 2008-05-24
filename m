Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ev1s-209-62-40-50.ev1servers.net ([209.62.40.50]:47265 "EHLO
	phx1.phoronix.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbYEXDuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 23:50:07 -0400
Received: from [70.237.120.89] (helo=[192.168.0.100])
	by phx1.phoronix.com with esmtpa (Exim 4.68)
	(envelope-from <michael.larabel@phoronix.com>)
	id 1Jzk2q-0000Mo-4q
	for linux-wireless@vger.kernel.org; Fri, 23 May 2008 22:03:45 -0500
Message-ID: <4837859B.3050100@phoronix.com> (sfid-20080524_055036_080595_DEC70082)
Date: Fri, 23 May 2008 23:03:55 -0400
From: Michael Larabel <michael.larabel@phoronix.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: b43: Radio Hardware Status Disabled
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With a Linksys WUSB600N and NetGear WNDA3100, which both appear to 
utilize a Broadcom 4311 chipset, the radio hardware status always seems 
to get set to disabled immediately after the wireless interface is 
started and are never re-enabled.

This is happening with the b43 driver (found in Linux 2.6.25.3 kernel) 
on Fedora 9. Below is the dmesg and lspci output.

dmesg | grep b43
b43-phy0: Broadcom 4311 WLAN found
b43-phy0 debug: Found PHY: Analog 4, Type 2, Revision 8
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
input: b43-phy0 as /devices/virtual/input/input10
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy0 debug: Chip initialized
b43-phy0 debug: 32-bit DMA initialized
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
Registered led device: b43-phy0::radio
b43-phy0 debug: Wireless interface started
b43-phy0: Radio hardware status changed to DISABLED
b43-phy0 debug: Adding Interface type 2

05:00.0 Network controller [0280]: Broadcom Corporation BCM94311MCG wlan mini-PCI [14e4:4311] (rev 01)
	Subsystem: Dell Unknown device [1028:0007]
	Flags: bus master, fast devsel, latency 0, IRQ 18
	Memory at c0200000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 2
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
	Capabilities: [d0] Express Legacy Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [13c] Virtual Channel <?>
	Kernel driver in use: b43-pci-bridge
	Kernel modules: ssb


Anything to get these cards working?


Michael

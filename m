Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.139]:37189 "EHLO
	smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbcBFAQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 19:16:51 -0500
Received: from [192.168.52.2] (unknown [24.69.201.142])
	by gw.sieb.net (Postfix) with ESMTPSA id B022D20F58
	for <linux-wireless@vger.kernel.org>; Fri,  5 Feb 2016 15:53:42 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Samuel Sieb <samuel@sieb.net>
Subject: BCM43142 doesn't work
Message-ID: <56B53603.4080905@sieb.net> (sfid-20160206_011654_671745_AF115D59)
Date: Fri, 5 Feb 2016 15:53:39 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found a message to this list from 2013 that indicates the BCM43142 
chipset should work:
https://marc.info/?l=linux-wireless&m=137223374523831&w=2

However, what happens is:
Feb 04 11:55:50 localhost kernel: bcma: bus0: Found chip with id 43142, 
rev 0x01 and package 0x08
Feb 04 11:55:50 localhost kernel: bcma: bus0: Core 0 found: ChipCommon 
(manuf 0x4BF, id 0x800, rev 0x28, class 0x0)
Feb 04 11:55:50 localhost kernel: bcma: bus0: Core 1 found: IEEE 802.11 
(manuf 0x4BF, id 0x812, rev 0x21, class 0x0)
Feb 04 11:55:50 localhost kernel: bcma: bus0: Core 2 found: PCIe (manuf 
0x4BF, id 0x820, rev 0x16, class 0x0)
Feb 04 11:55:50 localhost kernel: bcma: bus0: Core 3 found: UNKNOWN 
(manuf 0x43B, id 0x368, rev 0x00, class 0x0)
Feb 04 11:55:50 localhost kernel: bcma: bus0: Bus registered

Nothing else in the logs, no devices created.  Am I missing something 
like firmware?  I would prefer to not have to use a 3rd party driver or 
worse, ndiswrapper.  This is in an HP laptop.

lscpi:
03:00.0 Network controller: Broadcom Corporation BCM43142 802.11b/g/n 
(rev 01)
         DeviceName: Harrier
         Subsystem: Hewlett-Packard Company Device 2230
         Flags: bus master, fast devsel, latency 0, IRQ 38
         Memory at f0c00000 (64-bit, non-prefetchable) [size=32K]
         Capabilities: [40] Power Management version 3
         Capabilities: [58] Vendor Specific Information: Len=78 <?>
         Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
         Capabilities: [d0] Express Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [13c] Virtual Channel
         Capabilities: [160] Device Serial Number <removed>
         Capabilities: [16c] Power Budgeting <?>
         Kernel driver in use: bcma-pci-bridge
         Kernel modules: bcma

03:00.0 0280: 14e4:4365 (rev 01)
         DeviceName: Harrier
         Subsystem: 103c:2230

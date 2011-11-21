Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59117 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab1KUV4v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 16:56:51 -0500
Message-ID: <4ECAC919.4080408@hauke-m.de> (sfid-20111121_225654_336347_4F674807)
Date: Mon, 21 Nov 2011 22:56:41 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: linux-usb@vger.kernel.org,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: bcma USB Host driver
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am thinking on how to implement the usb host driver for the bcma bus
correctly. bcma is the driver for Broadcom's AMBA implementation (see
drivers/bcma/ ) and on SoCs it also provides a core with an USB Host
controller. This USB host controller has an OHCI and an EHCI interface
on different addresses, but it is on core on this bus, just with two
address spaces [0]. For the software developers point of view it is
pretty similar to Braodcoms SSB bus, for which I have the same problem.

The bcma bus driver exposes one device for this core which is
responsibility for EHCI and OHCI at the same time. Now I implemented a
driver for ehci and one for ohci but just one gets registered, because
only one is able to claim this device. I based my work on how it is done
for the ssb bus, which is similar to the bcma bus implementation and
there is already a ohci driver for ssb in the kernel (see
drivers/usb/host/ohci-ssb.c ), but no ehci driver (I want to add that
also, for now we only have some hacky think in OpenWrt).

The Broadcom hardware uses a standard ehci and ohci interface, there are
just some register reads and writes needed at startup to work around
some hardware bugs. In the Braodcom SDK they are registering the USB
core as two PCI device and are using the normal pci drivers.

To provide ehci and ohci at the same time I came up with some solutions:

1. The OHCI driver also initializes the EHCI driver, when it gets load
and is an USB 2.0 device. This is how it is done in OpenWrt and I do not
like it [1].
2. bcma provides two devices with different identification and there are
two independ drivers working with it.
3. bcma handles the usb registration directly and all code goes to
drivers/bcma/
4. Is there some way like a platform device with a memory address which
I could register and which is then handled by the usb system?

Are there any better approaches on how to do this? I do not think I am
the first person with such a problem.

Hauke

[0]:
https://github.com/hauke/openwrt/commit/43e4344b7b8b4d7fb5a6220066effde30cb00501#diff-4
[1]:
https://dev.openwrt.org/browser/trunk/target/linux/brcm47xx/patches-3.0/023-usb_ehci_ohci.patch

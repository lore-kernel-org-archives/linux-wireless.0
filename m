Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:33862 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab1CGXLf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 18:11:35 -0500
Subject: Re: SSB bus driver documentation?
From: Michael Buesch <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
In-Reply-To: <AANLkTikky+cwYO+S_QSebnyQRV9TftbeNZDzVN8EAT_7@mail.gmail.com> (sfid-20110307_233715_836311_FFFFFFFF9FD85835)
References: <AANLkTikky+cwYO+S_QSebnyQRV9TftbeNZDzVN8EAT_7@mail.gmail.com>
	 (sfid-20110307_233715_836311_FFFFFFFF9FD85835)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 00:11:31 +0100
Message-ID: <1299539491.7802.18.camel@marge>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-07 at 23:37 +0100, Rafał Miłecki wrote:
> We have some ssb_modinit, but I don't see it performing scanning bus
> at all.

It just registers the bus type to the kernel.

> For some reason this function is aware of b43 bridge and gige
> driver. GigE driver doesn't seem to be module, while b43 seems to be.

Well, b43-pci-bridge and gige should be standalone
modules. However b43-pci-bridge is so small that it's
not worth it and so it is integrated into ssb module.
gige has some weird dependencies to the mips platform
code, so it can't easily be standalone.

> while b43 uses ssb_device_id.

Well, b43 is the driver for the "wireless" core of an SSB chip (bus).
Therefore it is an ssb_device.

> I have no idea
> what b43 PCI bridge is.

b43-pci-bridge is the driver for the host-pci device
for SSB based PCI cards. Looks like this:

PCI bus -> b43-pci-bridge -> SSB bus -> b43 (ssb_device)


> Flow seems to be ugly, at ssb_modinit we call
> ssb_gige_init which calls out ssb_driver_register.

Well, that's just because we cannot have two module_init
in one module.

> There is some magic
> "ssb_attach_queued_buses", which sounds like SSB (which is bus)
> attaching... buses.

This is just used for embedded devices.
As I already said, this mechanism should be rewritten to use the
standard platform_device mechanism.
However, I doubt it would make it easier to understand. But it
would be more ideomatic.

> I wanted to at least understand when scanning of cores is done. I
> found "ssb_bus_scan", it is called from "ssb_bus_register". This
> function is called from code for every host, for example:
> ssb_bus_pcibus_register. This one seems to be called from
> ssb_pcihost_probe, however pcihost_wrapper is not module itself, it
> does not contains any devices table. This function seems to be
> registered with pci_register_driver from ssb_pcihost_register. That
> one gets called b43_pci_ssb_bridge_init. But damn, I don't remember
> anymore where I was 5 step ago. Not to mention whole code path.

I think you're probably trying to understand the wrong thing here.
If you want to understand kernel booting, you don't walk the code
from physical CPU entry point to forking of the init process.

There's a lot of standard kernel subsystem code involved here,
so it certainly is very hard to "walk" the codepath by hand.

What happens on a PCI card is pretty easy:

SSB (ssb_modinit) registers the "SSB" bustype to the kernel. Now the kernel
knows about the new bustype. No more no less.
B43 registers the driver for the SSB wireless core.
The b43-pci-bridge registers the toplevel PCI driver to the kernel.
If the kernel detects such a device, it probes the driver (pcihost_wrapper).
Which in turn registers the SSB bus. The kernel notices that the SSB bustype
was registered and calls its initialization. Which in turn triggers scanning
of the bus. The scanning discovers the devices and registers the SSB devices
to the kernel. As the b43 driver already registered the SSB wireless core
driver, the kernel matches that against the registered devices and calls
b43 probe if it was found.

> OK, I wrote all that to show you my confusion. I don't think asking
> any single questions will help understanding that. Is there any
> documentation I could read to get any basic understanding of ssb?

No. But you should probably read something about the kernel device
framework. Some book like Linux Device Drivers, perhaps.

> 
> P.S.
> Even one more thing: try to guess by function's name what can it be
> responsible for: "ssb_bus_ssbbus_register". It is used by some
> /arch/mips/bcm47xx/setup.c, but I can not image digging into next
> driver to understand whole architecture :|

That function registers an SSB bus on an embedded system.
It's basically the same thing what b43-pci-bridge does, except
that the bustype is set to a different value and some minor things
are done differently in the init process.

As I said, this should use platform_device mechanism. But it would
make it even harder for you to understand. :D

-- 
Greetings, Michael.


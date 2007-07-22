Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:8716 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbXGVRX7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2007 13:23:59 -0400
Subject: Re: [PATCH 2.6.23 3/3] [wireless] orinoco: create a Kconfig option  for Prism2
From: Pavel Roskin <proski@gnu.org>
To: Faidon Liambotis <paravoid@debian.org>
Cc: linux-wireless@vger.kernel.org, hermes@gibson.dropbear.id.au
In-Reply-To: <20070722131751.GA3009@void.cube.gr>
References: <20070722131751.GA3009@void.cube.gr>
Content-Type: text/plain
Date: Sun, 22 Jul 2007 13:14:13 -0400
Message-Id: <1185124453.3100.49.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-07-22 at 16:17 +0300, Faidon Liambotis wrote:
> Since v2.6.14, Prism 2/2.5/3 devices are better supported using the HostAP
> driver, which was made to work with these exclusively.
> Having the same IDs supported by orinoco too confuses users who have both
> drivers compiled in or as modules who expect hostap to drive the device.
> 
> Telling users to echo to /sys/bus/pci/drivers/*/unbind and bind is not
> exactly user-friendly.
> 
> Create an option to disable support for Prism devices in orinoco driver which
> disabled the IDs for the PCMCIA module and creates a Kconfig dependency for
> the Prism PCI modules.

NAK.

Nortel cards consist of a bridge and a PCMCIA card with Symbol firmware.
Their PCI IDs (0x126c:0x8030 and 0x1562:0x0001) are in hostap_plx, but I
really doubt that hostap_plx would even be able to initialize those
cards properly, given the fact that it lacks Nortel specific code (look
for "118" in orinoco_nortel and hostap_plx).

And even if hostap_plx could initialize the hardware, it would not be
able to use it.  Support for Agere and Symbol firmware in Hostap is
rudimentary at best.  It would not even be able to set WEP.

In any case, since your changes are meant to cut support for Prism to
firmware from Orinoco, it's wrong deceive users and cut support for
Symbol firmware based devices instead.

If you want to pursue this approach, it would be logical to also have an
option for hostap to remove support for non-Prism devices.  Better yet,
it should be removed unconditionally, since it's known to be broken,
unlike support for Prism devices in Orinoco.

Now let's consider PLX bridges.  There is a great variety of them, and
some of them were sold to be used with Orinoco branded cards, i.e. with
Agere firmware.  Some were sold with Prism based cards.  3com branded
cards were likely shipped with cards using Symbol firmware.

It is possible to classify the PCMCIA card by using the PCMCIA
configuration space available through the PLX bridge, but the driver
would be loaded by then.

In case of TMD cards, even PCMCIA configuration space is not available,
so the firmware can only be identified by its version.

Only in case of true PCI cards, orinoco_pci supports the same cards are
hostap_pci.

I think we should consider other approaches:

1) Be careful and only cut the IDs for the devices definitely known to
have been sold with Prism based cards.  In the came time, cut support
for Agere and Symbol based devices from hostap.

2) Add code to Orinoco to hand over the devices found to have Prism
firmware to hostap.  The device would be deinitialized and the bus
specific hostap driver (e.g. hostap_plx) would be called the way it's
called by the kernel then the device ID matches.

3) Make Orinoco use hostap backend for the cards found to have Prism
firmware, i.e. bypass hostap's bus specific modules.  That would require
quite a lot of impedance matching, but it should be possible.

The later approach is perhaps the most ambitious, but I think it's in
the Linux spirit of integrating the drivers rather than keeping them as
separate blobs.

-- 
Regards,
Pavel Roskin

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59421 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbZACLNK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 06:13:10 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: b43 depends on lots of modules
Date: Sat, 3 Jan 2009 12:11:56 +0100
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-wireless@vger.kernel.org
References: <alpine.LSU.2.00.0901030349030.3914@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0901030419390.9193@fbirervta.pbzchgretzou.qr> <495EE775.2010506@lwfinger.net>
In-Reply-To: <495EE775.2010506@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200901031211.56285.mb@bu3sch.de> (sfid-20090103_121313_752506_4D692D77)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 03 January 2009 05:20:05 Larry Finger wrote:
> Jan Engelhardt wrote:
> > 
> > It's because the Kconfig description says SSB is for embedded systems,
> > come thinking WRT54, so I wondered what exactly requires SSB.
> > Is it some bus within the wireless chip itself?
> 
> That isn't quite what Kconfig says, which is
> 
> config SSB
>         tristate "Sonics Silicon Backplane support"
>         depends on SSB_POSSIBLE
>         help
>           Support for the Sonics Silicon Backplane bus.
>           You only need to enable this option, if you are
>           configuring a kernel for an embedded system with
>           this bus.
>           It will be auto-selected if needed in other
>           environments.
> 
>           The module will be called ssb.
> 
>           If unsure, say N.
> 
> 
> The text says that it will be auto-selected if needed for other
> environments, and it will be for PCI-based BCM43XX devices.
> 
> Most, if not all, Broadcom devices consist of several cores of
> different types that are interconnected by a Sonics Silicon Backplane
> (ssb). On a BCM43XX device, two of these will be an IEEE 802.11 core
> plus at least one bus interface. For example, in the BCM4312 now in my
> machine I get
> 
> ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor 0x4243)
> ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F, vendor 0x4243)
> ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
> ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
> 
> As my device does not have a PCMCIA interface, that core is presumably
> not attached, but the other 3 are active.
> 
> Before b43 was developed, all communications between the 802.11 core
> and the PCI bus were handled by bcm43xx; however, that scheme meant
> that code had to be duplicated for 3 different drivers. By splitting
> out that part of the code, b43, b43legacy and b44 can share
> considerable code. That is the module named ssb.

It also meant that bcm43xx wouldn't run on embedded systems, where the
SSB bus is exposed to the other parts of the system.
On a PCI card the SSB bus is inside of the wireless chip only.
On embedded the SSB bus is used as the main system bus.
That's the reason we split it out.

So b43 requires SSB, because b43 is a SSB-device driver. Not a PCI-device driver.
So if you look into the code, you won't find a PCI-id-table, for example.

So yeah, all these dependencies are just normal for a configuration that
enables all options. You can reduce the deps by disabling PCMCMA, LEDS
and/or RFKILL, but I don't see why anybody would really want that anyway.

-- 
Greetings, Michael.

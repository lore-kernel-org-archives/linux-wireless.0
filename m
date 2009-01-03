Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:40414 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbZACEUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 23:20:17 -0500
Message-ID: <495EE775.2010506@lwfinger.net> (sfid-20090103_052026_478708_D338E5A7)
Date: Fri, 02 Jan 2009 22:20:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: b43 depends on lots of modules
References: <alpine.LSU.2.00.0901030349030.3914@fbirervta.pbzchgretzou.qr> <495ED57A.7080101@lwfinger.net> <alpine.LSU.2.00.0901030419390.9193@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0901030419390.9193@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jan Engelhardt wrote:
> 
> It's because the Kconfig description says SSB is for embedded systems,
> come thinking WRT54, so I wondered what exactly requires SSB.
> Is it some bus within the wireless chip itself?

That isn't quite what Kconfig says, which is

config SSB
        tristate "Sonics Silicon Backplane support"
        depends on SSB_POSSIBLE
        help
          Support for the Sonics Silicon Backplane bus.
          You only need to enable this option, if you are
          configuring a kernel for an embedded system with
          this bus.
          It will be auto-selected if needed in other
          environments.

          The module will be called ssb.

          If unsure, say N.


The text says that it will be auto-selected if needed for other
environments, and it will be for PCI-based BCM43XX devices.

Most, if not all, Broadcom devices consist of several cores of
different types that are interconnected by a Sonics Silicon Backplane
(ssb). On a BCM43XX device, two of these will be an IEEE 802.11 core
plus at least one bus interface. For example, in the BCM4312 now in my
machine I get

ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F, vendor 0x4243)
ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)

As my device does not have a PCMCIA interface, that core is presumably
not attached, but the other 3 are active.

Before b43 was developed, all communications between the 802.11 core
and the PCI bus were handled by bcm43xx; however, that scheme meant
that code had to be duplicated for 3 different drivers. By splitting
out that part of the code, b43, b43legacy and b44 can share
considerable code. That is the module named ssb.

Larry


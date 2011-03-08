Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:50353 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1CHLTL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 06:19:11 -0500
Subject: Re: SSB bus driver documentation?
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
In-Reply-To: <AANLkTikVN8QZjYc0jX4zcpO=xUwt4d8mfkPZkPSLvnMe@mail.gmail.com> (sfid-20110308_120113_587954_FFFFFFFFCCCD7736)
References: <AANLkTikky+cwYO+S_QSebnyQRV9TftbeNZDzVN8EAT_7@mail.gmail.com>
	 <1299539491.7802.18.camel@marge>
	 <AANLkTikVN8QZjYc0jX4zcpO=xUwt4d8mfkPZkPSLvnMe@mail.gmail.com>
	 (sfid-20110308_120113_587954_FFFFFFFFCCCD7736)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 12:19:04 +0100
Message-ID: <1299583144.7627.14.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-08 at 12:01 +0100, Rafał Miłecki wrote: 
> OK, today that ssb code makes more sense to me, thanks for help.
> 
> 
> I'd like to ask few more questions:
> 1) In case of PCI host we have b43_pci_bridge that loads ssb. What
> about other hosts? I don't see any IDs table in sdio.c or pcmcia.c.

That part is in b43. b43_pci_bridge is only in SSB, because it is
shared between b43 and b43legacy.

> 2) Could you say a word more about pcihost_wrapper? What is this for?
> I can see we use that in pci bridge. What we can't call
> ssb_bus_pcibus_register directly?

It's just a library of common PCI initialization functions. It's
used from b43_pci_bridge and from b44's PCI init code.

> 3) What is embedded.c?

A collection of functions for embedded devices (SSB without host bus),
only.

> 1) main.c::ssb_modinit
> Hacks for bridge and gige (both being not modules) are not documented.
> New developer have no idea why we call b43_pci_ssb_bridge_init and
> ssb_gige_init. Tracking that calls lead to even more confusion.

Well, it's pretty obvious what those functions do, if you know how
the kernel device driver model works. They register device drivers.
Which is done in the modinit function in almost all drivers.

And I don't think those calls are "hacks". It's pretty standard stuff.

> 2) ssb.h::ssb_bustype
> SSB_BUSTYPE_SSB,
> SSB_BUSTYPE_PCI,
> SSB_BUSTYPE_PCMCIA,
> SSB_BUSTYPE_SDIO,
> I think first define is confusing. Is sounds like SSB being host for
> SSB, or whatever... I think it should be sth like SSB_BUSTYPE_SYSTEM,
> SSB_BUSTYPE_NONE, SSB_BUSTYPE_NATIVE, SSB_BUSTYPE_EMBEDDED, or sth.

Well, SSB_BUSTYPE_NONE probably is the best choice of all of those.

It should actually be SSB_HOSTBUSTYPE_...

But it's probably not worth changing.

> 3) main.c::ssb_ssb_ops
> We keep all host-specific ops in separated files, but not in this
> case. OK, it makes some sense as this one is not for host, but I think
> it makes main.c more complicated and we can not compile SSB without
> it. I think we could build every PC kernel without this, right?

I think your goal was to reduce complexity? Now you want to increase it
just to save some 20 bytes? Could put it into embedded.c, if you
care.

> 4) scan.c::scan_switchcore
> Why we don't have ops->switchcore? We could get rid of that switch
> with simple pointer.

No. scan.c is special in that almost nothing is initialized, yet.
That is why we have custom read and switch core helpers here.

We do _not_ need core switch as an ops pointer, because after scanning
the core switch is _completely_ hidden in the read/write ops
implementations.

> 5) scan.c::scan_read32
> I'm not sure about this yet... but do we need that here? Shouldn't
> scan.c focus on just scanning? It's just one another "offset +=
> current_coreidx * SSB_CORE_SIZE;" calculation.
> 
> 
> I criticized scan.c::scan_read32, but could you say why do we need
> that specific read at all?

Because ops is not usable, yet. The task of scan is to create the
ssb_devices. The ops expect an ssb_device as argument. We can't
pass an ssb_device that we're about to detect.

-- 
Greetings Michael.


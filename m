Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:20462 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab1CRPvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 11:51:03 -0400
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000028865.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 17:49:59 +0200
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
In-Reply-To: <AANLkTi=EeMKNsi9bxNg4RJre-pP=jqcGpbLPNtggSK0N@mail.gmail.com>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	 <1300453433.13499.18.camel@dev.znau.edu.ua>
	 <AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
	 <AANLkTi=EeMKNsi9bxNg4RJre-pP=jqcGpbLPNtggSK0N@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 18 Mar 2011 17:49:52 +0200
Message-Id: <1300463392.13499.110.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 2011/3/18 Rafał Miłecki <zajec5@gmail.com>:
> > What for example about pci.c? Which functions from that file won't be
> > duplicated in totally separated?
> 
> At first I though we will need to duplicate all pci routines like
> ssb_pci_switch_coreidx and ssb_pci_xtal. But now I've checked
> brcm80211 and it seems it reads SPROM even from AI bus-cards.
Btw ssb_pci_xtal is for PCI. PCIE hosts don't need this.

> 
> Do you really want to duplicate all the SPROM code in *totally
> separated* driver for AI?!
> 
Every sb/ai backplane known to me at the moment are featuring the
following hardware design:
System backplane with individual devices on it (called cores)
communicating with the means of agents. The agents for sb are in the
main core registers space, and apart from the core registers for axi.
The backplane itself is "mastered" by buscore device. This is mips core
for embeddables, pci(e) core for pci(e) hosted backplanes, pcmcia core
for backplanes on pcmcia/sdio. Might OCP core is some sort of buscore as
well used to bridge two sb backplanes.
Buscore is responsible for interrupts management, backplane-to-host-bus
operations, agent-to-agent transfers.

Apart from the buscore, there is another "special" device on the
backplane - buscommon. Unlike buscore this one seems to be optional, and
not present on some old pcmcia-hosted backplanes. The buscommon is
responsible for managing bus clocks, can serve uarts, also is a source
of misc. configuration information for the backplane. These buscommons
are chipcommon and extif cores.

Here it would be great to have more technical background on the subject
but unfortunately apart from the staging brcm80211 and GPL packages for
respective embeddables the only open doc on the subject available to me
is www.broadcom.com/collateral/pg/440X-PG02-R.pdf

So software model I see here looks like following:
* Backplane-type handler responsible for
 ~ initial scanning;
 ~ agent-specific operations (core enable/disable, irq flags management,
etc.);

* The bus driver itself responsible for initial detection and assignment
of backplane handler and also managig driver registration/binding/etc
for
 ~ buscommon;
 ~ buscore;
 ~ regular cores;

* Host driver managing:
 ~ requests to the physical address space of backplane;
 ~ host interrupt management;
 ~ host-specific workarounds (ssb_pci_xtal is one of them);

This requires generic interfaces for:
* host (like those ssb_bus_ops which are actually not bus but host ops -
handling not core accesses but physical backplane addresses requests;
iterrupt management ops);
* backplane (scan, enable, disable, irq_flag etc.);
* buscore (backplane irq/errors/etc. management);
* buscommon (backplane clocks/etc. management, capabilities queries);

Buscommon and buscore unlike current ssb model could be separate
drivers. This will help to break apart all that mess of versions
checking and revision-specific processing. This will provide clean way
of obsoleting and removing the support for old hardware and introducing
newer one.
Regular bus core devices thus are to be registered with linux once
buscommon, buscore and host drivers are bound and set up making the bus
operational.
Buscore and buscommon as separate drivers will require some code to be
replicated over close versions but overall I've already tested this
approach with chipcommons with pmu r0, r1 and r5 on pcie and mips hosts
and final drivers' code is clean and manageable unlike all that mess in
hndpmu.c
Same stands for mips/pci host cores.

Well, keep in mind its my own view on the things how they are to be done
right :)

Have nice day,
George



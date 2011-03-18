Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:23024 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab1CRSMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 14:12:53 -0400
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000028900.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 20:11:49 +0200
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <AANLkTi=GggwyGkDB+cBG-G3O2c5WdfjCpb5pk8=3yDKz@mail.gmail.com>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	 <1300453433.13499.18.camel@dev.znau.edu.ua>
	 <AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
	 <AANLkTi=EeMKNsi9bxNg4RJre-pP=jqcGpbLPNtggSK0N@mail.gmail.com>
	 <1300463392.13499.110.camel@dev.znau.edu.ua>
	 <AANLkTi=GggwyGkDB+cBG-G3O2c5WdfjCpb5pk8=3yDKz@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 18 Mar 2011 20:11:57 +0200
Message-Id: <1300471917.14872.28.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 2011/3/18 George Kashperko <george@znau.edu.ua>:
> >> 2011/3/18 Rafał Miłecki <zajec5@gmail.com>:
> >> > What for example about pci.c? Which functions from that file won't be
> >> > duplicated in totally separated?
> >>
> >> At first I though we will need to duplicate all pci routines like
> >> ssb_pci_switch_coreidx and ssb_pci_xtal. But now I've checked
> >> brcm80211 and it seems it reads SPROM even from AI bus-cards.
> > Btw ssb_pci_xtal is for PCI. PCIE hosts don't need this.
> 
> Not even all PCI devices. Just 4306 I believe:
> /* kludge to enable the clock on the 4306 which lacks a slowclock */
> if (bustype == PCI_BUS && !si_ispcie(sii))
> 	si_clkctl_xtal(&sii->pub, XTAL | PLL, ON);
More likely it was introduced with 4306 and was required for all
successor up until pcie.

> Well, OK, it's generally well known already. Maybe I just prefer to
> call "buscore" a "hostcore" and "buscommon" a "chipcommon". I believe
> that are the names we hot used to.
There are number of backplanes with Extif (bcm44xx and bcm4710 e. g.),
while even more with chipcommon. Well, its a matter of taste ofcourse,
just think that naming both chipcommon and ext. interface cores
"chipcommon" could be the source for missunderstandings.

> > So software model I see here looks like following:
> > * Backplane-type handler responsible for
> >  ~ initial scanning;
> >  ~ agent-specific operations (core enable/disable, irq flags management,
> > etc.);
> >
> > * The bus driver itself responsible for initial detection and assignment
> > of backplane handler and also managig driver registration/binding/etc
> > for
> >  ~ buscommon;
> >  ~ buscore;
> >  ~ regular cores;
> >
> > * Host driver managing:
> >  ~ requests to the physical address space of backplane;
> >  ~ host interrupt management;
> >  ~ host-specific workarounds (ssb_pci_xtal is one of them);
> >
> > This requires generic interfaces for:
> > * host (like those ssb_bus_ops which are actually not bus but host ops -
> > handling not core accesses but physical backplane addresses requests;
> > iterrupt management ops);
> > * backplane (scan, enable, disable, irq_flag etc.);
> > * buscore (backplane irq/errors/etc. management);
> > * buscommon (backplane clocks/etc. management, capabilities queries);
> >
> > Buscommon and buscore unlike current ssb model could be separate
> > drivers. This will help to break apart all that mess of versions
> > checking and revision-specific processing. This will provide clean way
> > of obsoleting and removing the support for old hardware and introducing
> > newer one.
> > Regular bus core devices thus are to be registered with linux once
> > buscommon, buscore and host drivers are bound and set up making the bus
> > operational.
> > Buscore and buscommon as separate drivers will require some code to be
> > replicated over close versions but overall I've already tested this
> > approach with chipcommons with pmu r0, r1 and r5 on pcie and mips hosts
> > and final drivers' code is clean and manageable unlike all that mess in
> > hndpmu.c
> > Same stands for mips/pci host cores.
> 
> OK, I generally agree. We can try moving to such a layout. The only
> thing I hate in your view is "obsoleting and removing the support for
> old hardware".
Whats wrong with this one ? :)
The point is - each system part can be obsoleted and removed at some
point. Can and must or should are kinda different ones.
At the moment I see it rather interesting to support as much hardware as
possible with new model. Might I change my mind in lets say 5-6 years.
In either case separate buscommon/buscore drivers each ~10Kb size looks
much more manageable than 40-70Kb monolithick one - take a look at
hndpmu.c or driver_chipcommon.c + driver_chipcommon_pmu.c
The whole purpose of the model I drawn is to fit most (in the best case
all) the existing sb/ai hardware into single well designed abstraction
not requiring model quirks and workarounds unlike current ssb code is.
> 
> Answer me this question, please:
> Why do you think my proposed patch conflicts with layout proposed by you?
> 
> You said you want to have "Backplane-type handler". So according to
> this we will need two drivers/handlers: 1 for scanning SSB and 1 for
> scanning AI. That's what I try to implement. I just want to share some
> functions between the one for SSB and the one for AI.
I dont see here much difference between backplane type handler and
separate sb and ai backplane drivers. Actually its almost the same as in
either case final purpose of backplane (either driver or handler) will
be agent management abstraction with some ops or dedicated bcmb_sb_... /
bcmb_ai_... routines.

> 
> I don't see the point where my patch is in conflict with your idea.
Not your patch, just scan_read32, scan_switchcore, ssb_iounmap,
ssb_ioremap. So far ssb_core_name is fine.
Yet again, ssb code model is core-sentric which is not actually true
from the hardware pint of view. With few workarounds it works fine for
sb. For axi we will have more of these.

scan_read32, scan_switchcore, ssb_iounmap, ssb_ioremap are all
host-driven services. In ssb model host is operating cores and therefore
requires all that switch, scan_read, map, unmap etc. While with model
where host is providing not core but backplane access the only routine
among those above you need is scan_read32 and nothing more (actually you
don't need it too as host ops with read(8|16|32) are completely
sufficient for scanning). The purpose of scan_read32 for ssb model is
that ssb_bus_ops are operating cores which you don't have at the moment
when scanning. With host ops designed as u32 (*read32)(struct host
*host, phys_addr_t addr) host will do what it supposed to - manage its
means of backplane physical access and will have absolutely no need to
break into understanding what the core/sprom/otp/etc. is.

SSB is the great project from all the sides I've looked at it. Just a
perfect solution considering no sources of knowledge for sb other than
reverse engineering. But planning new code with the model based on ssb
will get us back to the point we are - in order to support new hardware
we must introduce new workarounds.

I'm pretty much sure it should be completely separate solution, well
planned and thought of.

Have nice day,
George



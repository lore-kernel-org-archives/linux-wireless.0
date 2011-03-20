Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:53947 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab1CTNI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Mar 2011 09:08:27 -0400
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000029095.msg
	for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 15:07:22 +0200
Subject: Re: new utility kernel module for detecting cores in newer chipsets
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Greg KH <greg@kroah.com>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	George Kashperko <george@znau.edu.ua>
In-Reply-To: <AANLkTim8SHdE8b9_gFLwbeEJM-uDegBDxU+AUJEb_rfc@mail.gmail.com>
References: <op.vslagcb13ri7v4@arend-laptop>
	 <op.vslaxakc3ri7v4@arend-laptop>
	 <AANLkTim8SHdE8b9_gFLwbeEJM-uDegBDxU+AUJEb_rfc@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 20 Mar 2011 15:07:18 +0200
Message-Id: <1300626438.16689.21.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 2011/3/19 Arend van Spriel <arend@broadcom.com>:
> > + mailing lists
> >
> > Hi Greg,
> >
> > There has been several discussion in the community (mainly by b43 and ssb
> > developers, I believe) to add support for chip core interconnect used in
> > newer Broadcom chips.  Our brcm80211 drivers already have this support and
> > we have isolated that functionality in a separate kernel module called
> > brcmaxi to provide it to other drivers. Currently, I have it located under
> > drivers/staging/brcm80211 as I am not sure whether or not its purpose
> > justifies a separate folder (under staging or not).
> >
> > What are your thoughts about this? I would like to know before submitting
> > a patch for this.
> 
> Well, I've this AI support rewritten and isolated here too. It's not
> about having the code but designing it well.
> 
> George Kashperko shared idea of really nice design layout for buses.
> He pointed problems with ssb driver, explained how everything works.
> With his layout it should be easy to support SSB and AI with very
> minimal, if any, additional hacks. Nobody pointed any problems with
> his layout.
Its not just a raw idea. Already implemented it in code. ATM I have bus
glue with three working drivers for chipcommons with pmu r0, r1 and r5,
drivers for mips33k, mips74k and pcie rev.13+ buscommons, embedded and
pcie hosts drivers. Now working on sprom configuration driver.
Still planning for clean glue for PCMCIA/SDIO hosts, some unified
approach for interrupts management and multifunctional pci(e) devices.

And the only one actual problem I faced was not the algorythm for AXI
SROM parsing (which is obvious as soon you figure out the SROM layout
and actually is much simpler and cleaner than that in
brcm80211/utils/aiutils.c)

The problem is technical background information absence for both SB and
AXI. The only truly open doc with SB information is BCM44XX programmers
guide. And for AXI there is nothing at all except staging80211 and
number of GPL'ed firmware sources for embedded routers. Half the time I
spent designing the model was documentation writing which I hate the
most.

Well, I understand its a business model Broadcom tends to run and we
can't do anything with that, but honestly even here I don't really
understand the purpose of "UNPUBLISHED PROPRIETARY" tags in some sources
of GPL'ed firmwares. E. g. etcgmac.c which is the only closed part left
to finally get bcm4716s' supported with openwrt.

> I don't want to have support for AI in 10 places, even if this is
> about staging area.
> 
Agree here completely. The only arguable point here I think could be
that AXI and SB should be different drivers but honestly they are too
much similar softwire-wise to even be placed in separate directories if
only bus managing code model is designed well.

Have nice day,
George



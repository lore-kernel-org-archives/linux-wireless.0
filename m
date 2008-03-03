Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbYCCA6A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 19:58:00 -0500
Subject: Re: Netgear WG311v3 - Marvell 88w8355 "Libertas"
From: Dan Williams <dcbw@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <646765f40803021401i65e31e16v5efd0784bffcc177@mail.gmail.com>
References: <646765f40803020319mf2db1fg9b9a1dde58fcda62@mail.gmail.com>
	 <1204472016.13121.27.camel@localhost.localdomain>
	 <646765f40803021401i65e31e16v5efd0784bffcc177@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 19:55:13 -0500
Message-Id: <1204505713.3070.0.camel@localhost.localdomain> (sfid-20080303_005808_324885_EA9CE725)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-03-03 at 09:01 +1100, Julian Calaby wrote:
> On Mon, Mar 3, 2008 at 2:33 AM, Dan Williams <dcbw@redhat.com> wrote:
> > On Sun, 2008-03-02 at 22:19 +1100, Julian Calaby wrote:
> >  > Hi,
> >  >
> >  > I'm not sure if this is the correct place to ask this, but here goes.
> >  >
> >  > I have recently obtained a Netgear WG311v3 card, under the
> >  > misunderstanding that it was an atheros card. (though I have no idea
> >  > how I managed to do that)
> >  >
> >  > Following some random FAQ, I have this card working reliably, for the
> >  > moment, using ndiswrapper, which is more than suitable for my needs.
> >  >
> >  > However I yearn for more.
> >  >
> >  > I have discovered here:
> >  > http://users.linpro.no/janl/hardware/wifi.html
> >  > that this card appears to use a Marvel 88w8355 "Libertas" chipset.
> >  > However I have not yet confirmed the exact chip used on my card.
> >
> >  I think you mean "88w8335" actually.  The Netgear WG311v3 uses the
> >  Marvell 88w8335 chipset.
> 
> Oh, ok, I stand corrected, I stupidly didn't read the chip (apart from
> noticing the stylised M) before thwacking it into my machine.
> 
> >  > I believe variants of this chip, are supported on SDIO, (8385, 8686)
> >  > USB (8388) and CompactFlash (8385) using the libertas driver.
> >
> >  Correct; the existing Libertas driver (perhaps somewhat mis-named)
> >  supports only the FullMAC variants of the libertas family.
> >
> >  The other, lower-numbered chips in the libertas family (8335, 8310, etc)
> >  are all more softmac parts and not supported by the existing libertas
> >
> > driver.
> 
> Oh.
> 
> That sucks, I'd thought that this was just another Libertas part,
> given the website mentioned above.
> 
> Well, that explains why the "Libertas" parts supported by the current
> kernel require firmware and why the ndiswrapper driver I'm using
> doesn't.

The 8335 still requires firmware.  Lots of the windows drivers embed the
firmware into the .sys or .dll files, whereas on Linux embedding
firmware into the driver is quite frowned upon.

dan

> >  > I can also find no information on a pci version of the libertas
> >  > driver, only a proposal which appeared to go nowhere due to lack of
> >  > documentation. I also cannot find any information on any linux support
> >  > for this card outside of using ndiswrapper.
> >
> >  There's an existing vendor net80211-based driver for the 8335 here:
> >
> >  http://git.infradead.org/?p=users/dwmw2/marvell-db64660-2.6.12.6.git;a=tree;f=drivers/net/wireless/marvell_softap;h=566585b308d53a7006814c77dedae73cc919cbef;hb=HEAD
> >
> >  There's also some reverse-engineered bits here:
> >
> >  http://www.saillard.org/linux/mrv8k/
> >
> >  and the mac80211 port of mrv8k here:
> >
> >  http://david.woodhou.se/mrv.tar.gz
> >
> >  though the last one here panic-ed in the interrupt handler when I tried
> >  it last on 2.6.22.
> 
> Cool! =)
> 
> >  > As such, I am considering reverse engineering the pci interface for
> >  > this chipset, and hopefully linking it up with the existing libertas
> >  > driver.
> >
> >  Don't link up with the existing libertas driver, they are just too
> >  different (softmac vs. fullmac).
> 
> Fair enough, I'll leave that be then.
> 
> >  > I was hoping to use the ndiswrapper driver as a starting point, using
> >  > it as a black box to see how it talks to the PCI card. (possibly
> >  > hacking together a OS level PCI sniffer) and hopefully, what I'll see
> >  > will match up to what's going on in the libertas driver for similar
> >  > tasks, and then I should be able to write the necessary code (or
> >  > specifications) to do this.
> >  >
> >  > I am also concerned about any possible legal ramifications of this
> >  > reverse engineering. Is it all right for me to do this, providing that
> >  > I treat the ndiswrapper driver as a black box? or am I too close to
> >  > non-free code to have my code be untainted?
> >
> >  I'd say first, try to whip the existing mrv8k-mac80211 port into shape
> >  and you probably won't have to worry much about the legal ramifications.
> >  You can look at the GPL-ed vendor driver (from the git I posted) for
> >  pointers about hardware-specific stuff, but after the 8388 driver
> >  experience, I'd strongly advocate writing a driver from scratch (or
> >  basing off mrv8k) and not using existing Marvell vendor drivers as a
> >  starting point.
> 
> Ok, will do. I'm not sure I'm up to writing a full driver, so I'll try
> to get mvr8k working on my box, then probably call back here for help.
> 
> Either way though, thanks for all the info and pointers. I'll check
> them out tonight.
> 
> >  Dan
> 
> Thanks,
> 


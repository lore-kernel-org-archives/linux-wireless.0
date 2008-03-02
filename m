Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbYCBPgY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 10:36:24 -0500
Subject: Re: Netgear WG311v3 - Marvell 88w8355 "Libertas"
From: Dan Williams <dcbw@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <646765f40803020319mf2db1fg9b9a1dde58fcda62@mail.gmail.com>
References: <646765f40803020319mf2db1fg9b9a1dde58fcda62@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 10:33:36 -0500
Message-Id: <1204472016.13121.27.camel@localhost.localdomain> (sfid-20080302_153644_851515_C4F96911)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-03-02 at 22:19 +1100, Julian Calaby wrote:
> Hi,
> 
> I'm not sure if this is the correct place to ask this, but here goes.
> 
> I have recently obtained a Netgear WG311v3 card, under the
> misunderstanding that it was an atheros card. (though I have no idea
> how I managed to do that)
> 
> Following some random FAQ, I have this card working reliably, for the
> moment, using ndiswrapper, which is more than suitable for my needs.
> 
> However I yearn for more.
> 
> I have discovered here:
> http://users.linpro.no/janl/hardware/wifi.html
> that this card appears to use a Marvel 88w8355 "Libertas" chipset.
> However I have not yet confirmed the exact chip used on my card.

I think you mean "88w8335" actually.  The Netgear WG311v3 uses the
Marvell 88w8335 chipset.

> I believe variants of this chip, are supported on SDIO, (8385, 8686)
> USB (8388) and CompactFlash (8385) using the libertas driver.

Correct; the existing Libertas driver (perhaps somewhat mis-named)
supports only the FullMAC variants of the libertas family.

The other, lower-numbered chips in the libertas family (8335, 8310, etc)
are all more softmac parts and not supported by the existing libertas
driver.

> Annoyingly I can find no information on this chip, or anything related
> to it, and I have heard that Marvel has been relatively uninterested
> in supporting these chips on Linux.

Correct; Marvell isn't that interested in supporting the older libertas
family chips in Linux (ie, anything < 8388 actually).  They have
expressed interest in getting their TopDog 802.11n solution working in
Linux however.

> I also note that this chip appears to have been designed exclusively
> for the embedded market, and as such, my card is somewhat rare, which
> has probably contributed to the lack of any interest in a pci driver.
> 
> I can also find no information on a pci version of the libertas
> driver, only a proposal which appeared to go nowhere due to lack of
> documentation. I also cannot find any information on any linux support
> for this card outside of using ndiswrapper.

There's an existing vendor net80211-based driver for the 8335 here:

http://git.infradead.org/?p=users/dwmw2/marvell-db64660-2.6.12.6.git;a=tree;f=drivers/net/wireless/marvell_softap;h=566585b308d53a7006814c77dedae73cc919cbef;hb=HEAD

There's also some reverse-engineered bits here:

http://www.saillard.org/linux/mrv8k/

and the mac80211 port of mrv8k here:

http://david.woodhou.se/mrv.tar.gz

though the last one here panic-ed in the interrupt handler when I tried
it last on 2.6.22.

> As such, I am considering reverse engineering the pci interface for
> this chipset, and hopefully linking it up with the existing libertas
> driver.

Don't link up with the existing libertas driver, they are just too
different (softmac vs. fullmac).

> I was hoping to use the ndiswrapper driver as a starting point, using
> it as a black box to see how it talks to the PCI card. (possibly
> hacking together a OS level PCI sniffer) and hopefully, what I'll see
> will match up to what's going on in the libertas driver for similar
> tasks, and then I should be able to write the necessary code (or
> specifications) to do this.
> 
> I am also concerned about any possible legal ramifications of this
> reverse engineering. Is it all right for me to do this, providing that
> I treat the ndiswrapper driver as a black box? or am I too close to
> non-free code to have my code be untainted?

I'd say first, try to whip the existing mrv8k-mac80211 port into shape
and you probably won't have to worry much about the legal ramifications.
You can look at the GPL-ed vendor driver (from the git I posted) for
pointers about hardware-specific stuff, but after the 8388 driver
experience, I'd strongly advocate writing a driver from scratch (or
basing off mrv8k) and not using existing Marvell vendor drivers as a
starting point.

Dan



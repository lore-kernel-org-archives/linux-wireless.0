Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:60443 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759450AbXHAFzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 01:55:40 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IG7Da-0005vU-Ad
	for linux-wireless@vger.kernel.org; Wed, 01 Aug 2007 01:57:58 -0400
Subject: Re: [PATCH 2.6.23 3/3] [wireless] orinoco: create a Kconfig option  for Prism2
From: Pavel Roskin <proski@gnu.org>
To: Jouni Malinen <j@w1.fi>
Cc: Faidon Liambotis <paravoid@debian.org>,
	linux-wireless@vger.kernel.org, hermes@gibson.dropbear.id.au
In-Reply-To: <20070801033352.GF8403@jm.kir.nu>
References: <20070722131751.GA3009@void.cube.gr>
	 <1185124453.3100.49.camel@mj> <46A5269F.5050504@debian.org>
	 <20070801033352.GF8403@jm.kir.nu>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 01:55:33 -0400
Message-Id: <1185947733.5936.42.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Jouni!

On Tue, 2007-07-31 at 20:33 -0700, Jouni Malinen wrote:

> > >>Create an option to disable support for Prism devices in orinoco driver 
> > >>which
> > >>disabled the IDs for the PCMCIA module and creates a Kconfig dependency 
> > >>for
> > >>the Prism PCI modules.
> 
> This may not be a desirable change from number of reasons if it is
> likely to get enabled by default in builds.

I'm seriously considering dropping orinoco_pci unconditionally.  All
other cards supported by Orinoco are 16-bit PCMCIA cards.  No planned
changes for Orinoco will improve orinoco_pci.

This would also solve the problem with DWL-520 rev E, which is only
supported by HostAP, but which orinoco_pci matches, because it cannot
match a vendor/device combination but exclude a specific
subvendor/subdevice.

As for Prism IDs in orinoco_cs, that's a tough call, because there are a
lot of IDs, and the probability of error is high.

I would probably keep all PCI-brigde drivers (orinoco_plx, orinoco_tmd
and orinoco_nortel).  That hardware is rare, and the users may want to
try both Orinoco and HostAP.

> > >Nortel cards consist of a bridge and a PCMCIA card with Symbol firmware.
> > >Their PCI IDs (0x126c:0x8030 and 0x1562:0x0001) are in hostap_plx, but I
> > >really doubt that hostap_plx would even be able to initialize those
> > >cards properly, given the fact that it lacks Nortel specific code (look
> > >for "118" in orinoco_nortel and hostap_plx).
> 
> Is that special initialization needed for the PLX component or for the
> PC Card?

It's needed for the bridge, but the bridge is not PLX.  It's a
completely different device.  hostap_plx has PLX and TMD support rolled
into one driver, but the Nortel bridge support is not there.

> Can the PC Card be replaced? In other words, if there is even a
> remote change of someone using that card with a Prism2/2.5/3 PC Card,
> there may be use for hostap_plx. If this cannot happen, I don't see any
> point in including the PCI ID for them in hostap_plx.

I think the cards can be replaced.  That's my recollection of the Nortel
emobility picture I saw on eBay.  However, my point is that hostap_plx
lacks the necessary code to initialize the bridge.

>  Obviously, I do
> not have these cards and those have been added based on user reports.

Well, that's the hard part.  I don't know why anyone would want to add
the ID of a card that is not working to hostap.  But it's possible that
the ID came from orinoco_nortel without any testing at all, just because
somebody assumed that hostap_plx would handle it.  Faidon assumed it, so
it's possible someone else could make the same mistake.

> > >If you want to pursue this approach, it would be logical to also have an
> > >option for hostap to remove support for non-Prism devices.  Better yet,
> > >it should be removed unconditionally, since it's known to be broken,
> > >unlike support for Prism devices in Orinoco.
> 
> I don't think there is much interested in spending time in improving the
> current Host AP drivers. I certainly do not have plans on more than
> minimal maintenance. As such, I would object to any kind of unnecessary
> and risky change unless someone else can claim to have done very through
> testing on the end result. If someone wants to spend more time with
> drivers for these old cards, I would suggest looking more into porting
> the drivers to use net/mac80211 (and to the needed changes to mac80211
> to allow this to be done).

OK, I understand.  The situation with Orinoco is similar, although I
hope to find time to make some changes.

> > >It is possible to classify the PCMCIA card by using the PCMCIA
> > >configuration space available through the PLX bridge, but the driver
> > >would be loaded by then.
> 
> Recognizing PC Cards is somewhat complex due to re-use of the IDs
> between various models. This would likely end up being a major task in
> going through all the cards and collecting the version strings from them
> and using that to match the driver..

I didn't really mean to do it.  It was used as a background to better
show the problem with TMD bridges, where CIS is not available at all.

> > >I think we should consider other approaches:
> 
> ...
> 
> 4) Implement a new driver for various hermes-like devices using
> net/mac80211 with support for existing functionality in Host AP and
> orinoco drivers

That's actually a good idea.  The differences between the firmwares
would be rather insignificant, since the devices will have to be dumbed
down to the level of softmac devices that mindlessly send and receive
802.11 frames.

But I cannot promise that I'll be able to do it myself.

> > To be honest, I can't imagine people actively working on either of the 
> > two drivers. The hardware isn't being sold anymore and the technology 
> > (.11b) is two generations behind. And it's not like the drivers aren't 
> > working.
> > OTOH, I'm not watching closely, so may be I'm far off. You know better :)
> 
> I would also think it is difficult to get enough activity for any larger
> change.. These are just not that interesting cards anymore and people
> have better things to do ;-).

Exactly.  Although porting the driver to mac80211 can be an interesting
challenge.

> > So, I'll sent, if you agree, a patch that only disables orinoco_pci and 
> > the PCMCIA IDs. If you know more (a specific ID of a PLX that can 
> > definitely work with hostap) please say so.
> > I'll let Jouni comment on the Agere and Symbol rip from hostap.
> 
> I wouldn't recommend it, i.e., any patch that does not come with a test
> report showing no regressions is likely to get NAK'ed.. Obvious
> one-liner style fixes of removing incorrect IDs is of course welcome,
> but going much beyond that may not be reasonable at this point.

Agreed.

> > I think we should find a solution for now and leave the big plans for 
> > when/if they happen.
> 
> And only if someone actually shows up with enough interest, motivation,
> time, and skills to do this..

I think the handover approach is not "big plans" compared to a mac80211
rewrite.  Although it's "big plans" compared to mindless disabling IDs
without testing or researching the user messages.

-- 
Regards,
Pavel Roskin


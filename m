Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:50439 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbXHADlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 23:41:12 -0400
Date: Tue, 31 Jul 2007 20:33:52 -0700
From: Jouni Malinen <j@w1.fi>
To: Faidon Liambotis <paravoid@debian.org>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	hermes@gibson.dropbear.id.au
Subject: Re: [PATCH 2.6.23 3/3] [wireless] orinoco: create a Kconfig option for Prism2
Message-ID: <20070801033352.GF8403@jm.kir.nu>
References: <20070722131751.GA3009@void.cube.gr> <1185124453.3100.49.camel@mj> <46A5269F.5050504@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46A5269F.5050504@debian.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 24, 2007 at 01:07:27AM +0300, Faidon Liambotis wrote:
> [I'm adding Jouni to Cc to help us :)]

I may have missed some details from the thread, but couple of comments
here anyway..

> Pavel Roskin wrote:
> >On Sun, 2007-07-22 at 16:17 +0300, Faidon Liambotis wrote:
> >>Since v2.6.14, Prism 2/2.5/3 devices are better supported using the HostAP
> >>driver, which was made to work with these exclusively.
> >>Having the same IDs supported by orinoco too confuses users who have both
> >>drivers compiled in or as modules who expect hostap to drive the device.
> >>
> >>Telling users to echo to /sys/bus/pci/drivers/*/unbind and bind is not
> >>exactly user-friendly.
> >>
> >>Create an option to disable support for Prism devices in orinoco driver 
> >>which
> >>disabled the IDs for the PCMCIA module and creates a Kconfig dependency 
> >>for
> >>the Prism PCI modules.

This may not be a desirable change from number of reasons if it is
likely to get enabled by default in builds.

> >Nortel cards consist of a bridge and a PCMCIA card with Symbol firmware.
> >Their PCI IDs (0x126c:0x8030 and 0x1562:0x0001) are in hostap_plx, but I
> >really doubt that hostap_plx would even be able to initialize those
> >cards properly, given the fact that it lacks Nortel specific code (look
> >for "118" in orinoco_nortel and hostap_plx).

Is that special initialization needed for the PLX component or for the
PC Card? Can the PC Card be replaced? In other words, if there is even a
remote change of someone using that card with a Prism2/2.5/3 PC Card,
there may be use for hostap_plx. If this cannot happen, I don't see any
point in including the PCI ID for them in hostap_plx. Obviously, I do
not have these cards and those have been added based on user reports.

> >If you want to pursue this approach, it would be logical to also have an
> >option for hostap to remove support for non-Prism devices.  Better yet,
> >it should be removed unconditionally, since it's known to be broken,
> >unlike support for Prism devices in Orinoco.

I don't think there is much interested in spending time in improving the
current Host AP drivers. I certainly do not have plans on more than
minimal maintenance. As such, I would object to any kind of unnecessary
and risky change unless someone else can claim to have done very through
testing on the end result. If someone wants to spend more time with
drivers for these old cards, I would suggest looking more into porting
the drivers to use net/mac80211 (and to the needed changes to mac80211
to allow this to be done).

> >It is possible to classify the PCMCIA card by using the PCMCIA
> >configuration space available through the PLX bridge, but the driver
> >would be loaded by then.

Recognizing PC Cards is somewhat complex due to re-use of the IDs
between various models. This would likely end up being a major task in
going through all the cards and collecting the version strings from them
and using that to match the driver..

> >I think we should consider other approaches:

...

4) Implement a new driver for various hermes-like devices using
net/mac80211 with support for existing functionality in Host AP and
orinoco drivers

> To be honest, I can't imagine people actively working on either of the 
> two drivers. The hardware isn't being sold anymore and the technology 
> (.11b) is two generations behind. And it's not like the drivers aren't 
> working.
> OTOH, I'm not watching closely, so may be I'm far off. You know better :)

I would also think it is difficult to get enough activity for any larger
change.. These are just not that interesting cards anymore and people
have better things to do ;-).

> So, I'll sent, if you agree, a patch that only disables orinoco_pci and 
> the PCMCIA IDs. If you know more (a specific ID of a PLX that can 
> definitely work with hostap) please say so.
> I'll let Jouni comment on the Agere and Symbol rip from hostap.

I wouldn't recommend it, i.e., any patch that does not come with a test
report showing no regressions is likely to get NAK'ed.. Obvious
one-liner style fixes of removing incorrect IDs is of course welcome,
but going much beyond that may not be reasonable at this point.

> I think we should find a solution for now and leave the big plans for 
> when/if they happen.

And only if someone actually shows up with enough interest, motivation,
time, and skills to do this..

-- 
Jouni Malinen                                            PGP id EFC895FA

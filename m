Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946415AbXBIMqr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 07:46:47 -0500
Subject: Re: How to start with a Marvell driver (non-USB, non-OLPC)
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, marvell8385-devel@linuxtogo.org,
	frankh@marvell.com, rchokshi@marvell.com
In-Reply-To: <200702090858.26294.hs4233@mail.mn-solutions.de>
References: <200702090858.26294.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 07:49:27 -0500
Message-Id: <1171025367.2902.22.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-02-09 at 08:58 +0100, Holger Schurig wrote:
> Hi all !
> 
> This mail is an attempt to get some feedback about the way we 
> should go :-)   "We" are several people interested in 802.11bg 
> cards in Compact-Flash format with an Marvell 8385 (AFAIK) chip. 
> See the list of people at 
> http://projects.linuxtogo.org/projects/marvell8385/   A driver 
> for this cards would be quite nice for PDAs and other embedded 
> Linux systems.
> 
> 
> 
> Two months ago I sent an e-mail to Marvell for support, or at 
> least to put me in contact with the product manager. There was 
> no response. Maybe they don't care for sales.
> 
> However, Marvell released a GPL driver for the OLPC project, 
> which is now in Linux mainline. This driver is for a different 

Actually, it's not in mainline.  It's still being reviewed and hasn't
been merged.

> chip (8388 AFAIK), a different firmware (with Mesh capability) 
> and a different host interface (USB). During the last month the 
> libertas driver got rid of more and more code that applied to 
> non-8388, non-USB, non-mesh-firmware versions of the Libertas 

The only reason code was removed was because nobody was using it.  The
people who review things (rightly) consider dead code a merge blocker.
If you to keep stuff, please speak up.  It's not too late, please join
the libertas-dev mailing list at infradead.org and say what you need.
Patches are even better.

> chip set family. Those cleanups made the in-kernel libertas 
> driver more and more unusable for the cards that I have in mind. 

Again, the cleanups were because the code was unused.  Nobody said
anything about that code being required, and it wasn't required for the
card that the driver currently supports, and the kernel review people
said to drop it.

Kernel people also hate unnecessary hardware abstraction.  At the time
the driver was reviewed, the only supported card type was USB because
nobody stepped up and said they had other cards to support.  Therefore,
pieces of the driver that abstracted the hardware bits got removed.  If
you need to support CF type cards, we should add support for that
hardware rather than making a new driver.

> They did not only clean up, they also added their specific stuff 
> for their mesh solution.

If there's mesh-specific stuff that's _not_ bounded by checks for
mesh-enabled firmware, then please point them out.  Those parts, if any,
should be fixed.

> I think the biggest problem here is the firmware. The OLPC people 
> have a special firmware for their USB dongle, which is not used 
> in other chips, so a driver that has been heavily adapted to 
> this firmware isn't easy to mangle to a different firmware.

No, it really hasn't.  The mesh-specific bits are a separate code path,
and we routinely run non-mesh firmware using this driver.  If there are
places that are missing run-time firmware version checks, then we need
to fix those places.

> So, what I (and several other people, see want to take the OLPC 
> driver, get rid of the USB stuff, add in back stuff that is 
> needed for CF-Card, add mangle and treat this until we get 
> something that is working.

You probably won't get that merged.  If the 8388 OLPC driver and the
8385 CF driver share a lot of code, or if the chips are largely the same
(they are) then there will rightfully be questions about why the same
driver can't handle both chips.  And those questions are correct.

Again, why don't we work together?  We are _not_ intentionally screwing
over anybody else, and if there are pieces that you need, why don't we
put those pieces back in?

> Now, linux-2.6.20 still has Softmac. Some projects, like the 
> bcm43xx, are very lively in the softwac area. d80211 is supposed 
> to come into the kernel since months. I guess it's an endless 
> task?  Will it ever arive?  What 80211 version should we use if 
> our aim is inclusion in the stock kernel?  We don't plan, like 
> so many other project, divide our working time into a year-long 
> maintainance of two 80211 versions.

The problem is that unless you've got a radically different firmware,
you simply cannot use any of the existing 802.11 stacks.  The Marvell
part, and the firmware, are inherently full-mac type devices and cannot
be used with d80211 or ieee80211.

The long and short of it is, please don't start a forked driver, because
you may likely get denied a merge if the driver is too similar to an
existing one.  Or both of us get denied merge and then we have to work
together anyway.

There's _no_ reason we shouldn't all work together.  If you have changes
to the driver, please speak up and post them.  The original libertas
hardware abstraction bits really sucked.  Rewriting them is probably a
better use of your time than working on a forked driver.  If there are
pieces of the libertas driver that are specific to the OLPC firmware, we
need to protect those pieces with runtime checks.  We're happy to do
that.  We've even got some 8388 USB dongles we can send you for testing.

Dan



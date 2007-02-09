Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:29029 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946473AbXBIOZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 09:25:06 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: How to start with a Marvell driver (non-USB, non-OLPC)
Date: Fri, 9 Feb 2007 15:24:52 +0100
Cc: linux-wireless@vger.kernel.org, marvell8385-devel@linuxtogo.org,
	frankh@marvell.com, rchokshi@marvell.com
References: <200702090858.26294.hs4233@mail.mn-solutions.de> <1171025367.2902.22.camel@localhost.localdomain>
In-Reply-To: <1171025367.2902.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200702091524.52389.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I think the biggest problem here is the firmware. The OLPC
> > people have a special firmware for their USB dongle, which
> > is not used in other chips, so a driver that has been
> > heavily adapted to this firmware isn't easy to mangle to a
> > different firmware.
>
> No, it really hasn't.  The mesh-specific bits are a separate
> code path, and we routinely run non-mesh firmware using this
> driver.  If there are places that are missing run-time
> firmware version checks, then we need to fix those places.

In the libertas mailing list someone published the "WLAN Firmware 
Spec v5.1" spec, so I guess that you're now using this firmware. 
But the Windows driver that I got hold on (to extract the 
firmware) all had a 5.0 in their driver name, so I guess they 
have a v5.0 firmware.

But I guess this can be handled with if (fw_version >= 
FW_VERSION_5_1) or something like this.


> Again, why don't we work together?  We are _not_ intentionally
> screwing over anybody else, and if there are pieces that you
> need, why don't we put those pieces back in?

Based on the things you said, I see no reason NOT to work 
together.


> We are _not_ intentionally screwing over anybody else, and if
> there are pieces that you need, why don't we put those pieces
> back in?

I did not say this. I just saw in GIT that you remove misc things 
or discussed the removed of things (e.g. CIS related code), so I 
guessed that you only go into the USB dongle direction. But 
maybe you weren't aware that other WLAN devices with similar 
chips, but different host interface are available.


> The original libertas hardware abstraction bits really sucked.

Did they release them as GPL as well?  Or do you refer to the 
copyrighted driver that is downloadable from some vendors?



I'm already in libertas-dev, so when I have time to look at the 
driver, I'll post some patches there. Rigth now I don't have 
much, e.g. I just put the infrastructure in place so that the 
PCMCIA subsystem detects the card and loads my driver.

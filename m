Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59013 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZCSTOy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 15:14:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: [PATCH] b43: Mask PHY TX error interrupt, if not debugging
Date: Thu, 19 Mar 2009 20:13:44 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200903191927.21868.mb@bu3sch.de> <2CE6D71C-6DB5-41F2-8FFD-C013DC2B9AF6@ing.unibs.it>
In-Reply-To: <2CE6D71C-6DB5-41F2-8FFD-C013DC2B9AF6@ing.unibs.it>
MIME-Version: 1.0
Message-Id: <200903192013.44903.mb@bu3sch.de> (sfid-20090319_201457_531156_73D08C10)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 19 March 2009 20:00:45 Francesco Gringoli wrote:
> some time ago I begin seeing several of these errors, never seen  
> before on one of my host, with both proprietary and open firmwares. As  
> I never noticed those errors before, I wondered if they could be due  
> to some strange frame received by air, something like a frame encoded  
> in CCK but with a broken field that caused the firmware to ack back a  
> frame whose first byte (encoding) didn't match the following inside  
> the plcp. That was obviously not the case, indeed those errors were  
> not even happening on tx tries and surprisingly they were happening  
> also on devices configured in monitor mode.

Well, they _are_ triggered by things going on in the WM. But I think
they are a lot lower level than MAC or PLCP. I think it is related to
the raw modulation.

In the end, I'm pretty sure this is some misconfiguration of some very
low level PHY part. Too bad we don't know about a debugging register
to get more information on _what_ part does trigger the error.

> I finally remembered that the day before starting observing errors, I  
> changed the minipci to pci adapter inside that host, maintaining the  
> same cable and antenna set. Removing the broken adapter stopped PHY  
> errors.

Yeah well. This confirms my thoughts.
There are other ways to voluntarily trigger the errors. For example
try covering the antennae with your bare hands. Try to move the
device to a place with extremely bad signal (Iron beams between them).
Try to move the transceivers very close (20cm) together, so basic rf rules are violated.

This are all pretty reliable ways to trigger these errors.

> After this debug session I have some notes
> - PHY error IRQs are not triggered by the firmware (both open and  
> proprietary) by writing to the IRQ registers

Right. I don't think it's really related to what firmware is running.
It may be the case that some firmware might encourage the errors by some
special timing in code operations, but the firmware does not trigger them.

> - these strange PHY errors are not due to tx tries, they happen also  
> with devices were the tx code has been cut away

Well, I did not see that, so I cannot really comment on this.
I never saw them in monitor mode.

> - PHY errors are triggered by the hardware when the number of bytes  
> requested for transmission do not match the tx information stored in  
> the first four bytes of the plcp, this happens for both frames sent by  
> b43 through dma and frames composed by the firmware. If everything is  

This is correct and known behavior. But this is _not_ what is happening here.

> consistent I never see errors on platforms not affected by noise (as  
> my old VIA or the broken minipci to pci adapter).

Yes, less noise = less errors. That's clearly the case.

> I would say this noise directly affects the irq line, or it triggers  
> the serializer to send out a packet with completely wrong radio/plcp/ 
> mac configuration that causes a PHY tx error.

I don't think it triggers the IRQ line. I'd rather think that some sensitivity
threshold is configured incorrectly, so the PHY will trigger the errors on
completely valid stuff.

So now this is your turn: Which one? :D

-- 
Greetings, Michael.

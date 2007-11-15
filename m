Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41979
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765416AbXKOVuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 16:50:06 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [RFC/T] b43: Implement the BCM94311MCG rev 02 card with a rev 13 802.11 core
Date: Thu, 15 Nov 2007 22:49:12 +0100
Cc: seandarcy2@gmail.com, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
References: <473bdf5e.LS8yn+6u1JmDiT9C%Larry.Finger@lwfinger.net> <200711151138.17468.mb@bu3sch.de> <473C5F98.1050007@lwfinger.net>
In-Reply-To: <473C5F98.1050007@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711152249.12824.mb@bu3sch.de> (sfid-20071115_215011_554735_1C0A44E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 November 2007 16:02:48 Larry Finger wrote:
> >> @@ -695,11 +687,12 @@ static int dmacontroller_setup(struct b4
> >>  			b43_dma_write(ring, B43_DMA32_RXRING,
> >>  				      (ringbase & ~SSB_DMA_TRANSLATION_MASK)
> >>  				      | trans);
> >> -			b43_dma_write(ring, B43_DMA32_RXINDEX, 200);
> >> +			b43_dma_write(ring, B43_DMA32_RXINDEX, ring->nr_slots *
> >> +				      sizeof(struct b43_dmadesc32));
> > 
> > I'm not sure why you do this change.
> 
> It took me a while to figure out where the magic number of 200 came from, and what I needed for the
> 64-bit case. In fact I think the 200 is a bug and should be 0x200. To me, this change makes it clearer.

The 200 is just a random number.
I think we don't really care what the value is. (Except zero, which doesn't
work on some devices).

-- 
Greetings Michael.

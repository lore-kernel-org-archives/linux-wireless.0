Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:37930 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYDPTNz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 15:13:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] b43: Add fastpath to b43_mac_suspend()
Date: Wed, 16 Apr 2008 21:13:05 +0200
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
References: <200804152113.36990.mb@bu3sch.de> <1208370999.11676.60.camel@johannes.berg>
In-Reply-To: <1208370999.11676.60.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804162113.05549.mb@bu3sch.de> (sfid-20080416_201542_770891_9FAF1B20)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 16 April 2008 20:36:39 Johannes Berg wrote:
> On Tue, 2008-04-15 at 21:13 +0200, Michael Buesch wrote:
> > This adds a fastpath for the common workloads to the
> > MAC suspend flushing.
> 
> 
> > @@ -2340,12 +2340,20 @@ static void b43_mac_suspend(struct b43_w
> >  		b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
> >  		b43_write32(dev, B43_MMIO_MACCTL,
> >  			    b43_read32(dev, B43_MMIO_MACCTL)
> >  			    & ~B43_MACCTL_ENABLED);
> >  		/* force pci to flush the write */
> >  		b43_read32(dev, B43_MMIO_MACCTL);
> > +		/* Finally wait for the microcode to flush the fifos. */
> 
> That comment is wrong, the ucode won't flush the FIFOs, it'll just go to
> sleep. If you want it to flush FIFOs you have to set a flush request bit
> somewhere (mac command I think), but you don't actually, you just don't
> want to have it processing stuff.

Ah yeah. Whatever. What was meant it it flushes everything from the host
point of view and goes to sleep. Feel free to remove that comment, John.
(simply remove the line from the patch before applying it).

-- 
Greetings Michael.

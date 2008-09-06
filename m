Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43176 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYIFUHl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 16:07:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43legacy: Fix failure in rate-adjustment mechanism
Date: Sat, 6 Sep 2008 22:07:09 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	bcm43xx-dev@lists.berlios.de,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <48c2cd1a.pA60sTEK0WsW6wtt%Larry.Finger@lwfinger.net> <1220730115.10102.15.camel@johannes.berg> <48C2E13B.9020203@lwfinger.net>
In-Reply-To: <48C2E13B.9020203@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809062207.10158.mb@bu3sch.de> (sfid-20080906_220743_772084_8C92A248)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 06 September 2008 21:59:55 Larry Finger wrote:
> Johannes Berg wrote:
> > 
> > The mechanism depends on the card revision, but according to
> > drivers/net/wireless/b43legacy/dma.c it's always via the dma/pio
> > mechanism for legacy cards:
> > 
> >         if (dev->dev->id.revision < 5) {
> >                 ring = b43legacy_setup_dmaring(dev, 3, 0, type);
> >                 if (!ring)
> >                         goto err_destroy_rx0;
> >                 dma->rx_ring3 = ring;
> >         }
> 
> In the V3 specs, I found
> 
> "Transmit Status
> 
> When this interrupt is set, the retrieve the TransmitStatus. Note that 
> on cores with revision < 5, the last DMA controller or PIO queue can 
> also also get the DMA recieve done interrupt, which also triggers the 
> TransmitStatus retrieval process. The driver should be prepared to 
> deal with both interrupts at any time, on any revision. In AP mode, 
> this interrupt also initiates the sending of powersave responses."
> 
> The implication is that the interrupt will only be generated if we use 
> the last (i.e. #5) DMA controller. As we are only using #3, no 
> interrupts and handle_irq_status() is dead code.

Ok. I'm pretty sure that the current code is correct for the register
mechanism, _however_ it is dead code and will never be called for
b43legacy. So I'd suggest you just do something like this (manually-hacked patch):

Index: wireless-testing/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/xmit.c
+++ wireless-testing/drivers/net/wireless/b43legacy/xmit.c
@@ -629,7 +629,7 @@ void b43legacy_handle_hwtxstatus(struct
.......
+ 	tmp <<= 1;
.......
        status.pm_indicated = !!(tmp & 0x80);
        status.intermediate = !!(tmp & 0x40);
        status.for_ampdu = !!(tmp & 0x20);
        status.acked = !!(tmp & 0x02);
 
        b43legacy_handle_txstatus(dev, &status);
 }


Just leave handle_irq_transmit_status as is.


-- 
Greetings Michael.

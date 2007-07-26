Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50555
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765911AbXGZWoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 18:44:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: A problem with shared interrupts
Date: Fri, 27 Jul 2007 00:42:27 +0200
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46a90082./TQABjOfVYW1o6lY%Larry.Finger@lwfinger.net>
In-Reply-To: <46a90082./TQABjOfVYW1o6lY%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707270042.27917.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 July 2007 22:13:54 Larry Finger wrote:
> Michael,
> 
> When I try the -mb tree on my old i386 notebook, I get an "irq 11: nobody cared"
> message and interrupts for the bcm43xx-mac80211 device are not initialized. The
> code in Linville's tree works. The only difference that seems to be important
> is the code returned when a shared interrupt not intended for us is received.
> By making the changes shown below, both trees now work.
> 
> I recall you having a discussion with someone over some aspect of shared IRQ's,
> but I don't remember the details and I'm too busy (lazy) to go back and look.
> 
> Thanks,
> 
> Larry
> ----
> 
> Index: wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
> ===================================================================
> --- wireless-mb.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
> +++ wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
> @@ -1503,7 +1503,7 @@ static void bcm43xx_interrupt_ack(struct
>  /* Interrupt handler top-half */
>  static irqreturn_t bcm43xx_interrupt_handler(int irq, void *dev_id)
>  {
> -	irqreturn_t ret = IRQ_NONE;
> +	irqreturn_t ret = IRQ_HANDLED;
>  	struct bcm43xx_wldev *dev = dev_id;
>  	u32 reason;
>  
> @@ -1517,7 +1517,6 @@ static irqreturn_t bcm43xx_interrupt_han
>  	reason = bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_REASON);
>  	if (reason == 0xffffffff) /* shared IRQ */
>  		goto out;
> -	ret = IRQ_HANDLED;
>  	reason &= bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_MASK);
>  	if (!reason)
>  		goto out;
> 
> 

I neither think this is the correct solution, nor do I think that this
is the way bcm43xx-softmac does it. This would always return HANDLED, right?
regardless if the IRQ was for bcm43xx or not. I _do_ think that the bug is
in the driver sharing the IRQ with bcm43xx.

-- 
Greetings Michael.

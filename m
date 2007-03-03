Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56868
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030679AbXCCQWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 11:22:51 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix assertion failures in interrupt handler
Date: Sat, 3 Mar 2007 17:21:42 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <45e8609d.Ypw71Z7iN5G3uSmi%Larry.Finger@lwfinger.net>
In-Reply-To: <45e8609d.Ypw71Z7iN5G3uSmi%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703031721.42811.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 02 March 2007 18:36, Larry Finger wrote:
> From: Pavel Roskin <proski@gnu.org>
> 
> In the bcm43xx interrupt handler, sanity checks are wrongly done before the
> verification that the interrupt is for the bcm43xx.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

ACK, I'm sorry for this really stupid bug. ;)

> ---
> 
>  drivers/net/wireless/bcm43xx/bcm43xx_main.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> index 057541f..21d4ecd 100644
> --- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> +++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
> @@ -1858,9 +1858,6 @@ static irqreturn_t bcm43xx_interrupt_handler(int irq, void *dev_id)
>  
>  	spin_lock(&bcm->irq_lock);
>  
> -	assert(bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED);
> -	assert(bcm->current_core->id == BCM43xx_COREID_80211);
> -
>  	reason = bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON);
>  	if (reason == 0xffffffff) {
>  		/* irq not for us (shared irq) */
> @@ -1871,6 +1868,9 @@ static irqreturn_t bcm43xx_interrupt_handler(int irq, void *dev_id)
>  	if (!reason)
>  		goto out;
>  
> +	assert(bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED);
> +	assert(bcm->current_core->id == BCM43xx_COREID_80211);
> +
>  	bcm->dma_reason[0] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA0_REASON)
>  			     & 0x0001DC00;
>  	bcm->dma_reason[1] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA1_REASON)
> 
> ---
> 
> 
> 

-- 
Greetings Michael.

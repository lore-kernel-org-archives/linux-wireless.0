Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47087
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbXKGRb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 12:31:57 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] b43: fix shared IRQ race condition
Date: Wed, 7 Nov 2007 18:31:10 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <20071107181611.23de23f1@morte>
In-Reply-To: <20071107181611.23de23f1@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711071831.10562.mb@bu3sch.de> (sfid-20071107_173201_853145_D76E8F0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 07 November 2007 18:16:11 Stefano Brivio wrote:
> Fix an IRQ race condition in b43. If we call b43_stop_wireless_core(), it
> will set the status of the device to INITIALIZED and the IRQ handler won't
> care any longer about IRQs, thus the kernel will disable the IRQ if it's
> shared (unless we boot it with the 'irqpoll' option). So we must disable
> IRQs before changing the device status.
> 
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> 
> ---
> 
> --- wireless-2.6/drivers/net/wireless/b43/main.c.orig	2007-11-07 17:55:30.553591943 +0100
> +++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-11-07 17:59:23.356020048 +0100
> @@ -2979,6 +2979,16 @@
>  
>  	if (b43_status(dev) < B43_STAT_STARTED)
>  		return;
> +
> +	/* Disable and sync interrupts. We must do this before than
> +	 * setting the status to INITIALIZED, as the interrupt handler
> +	 * won't care about IRQs then. */
> +	spin_lock_irqsave(&wl->irq_lock, flags);
> +	dev->irq_savedstate = b43_interrupt_disable(dev, B43_IRQ_ALL);
> +	b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);	/* flush */
> +	spin_unlock_irqrestore(&wl->irq_lock, flags);
> +	b43_synchronize_irq(dev);
> +
>  	b43_set_status(dev, B43_STAT_INITIALIZED);
>  
>  	mutex_unlock(&wl->mutex);
> @@ -2989,13 +2999,6 @@
>  
>  	ieee80211_stop_queues(wl->hw);	//FIXME this could cause a deadlock, as mac80211 seems buggy.
>  
> -	/* Disable and sync interrupts. */
> -	spin_lock_irqsave(&wl->irq_lock, flags);
> -	dev->irq_savedstate = b43_interrupt_disable(dev, B43_IRQ_ALL);
> -	b43_read32(dev, B43_MMIO_GEN_IRQ_MASK);	/* flush */
> -	spin_unlock_irqrestore(&wl->irq_lock, flags);
> -	b43_synchronize_irq(dev);
> -
>  	b43_mac_suspend(dev);
>  	free_irq(dev->dev->irq, dev);
>  	b43dbg(wl, "Wireless interface stopped\n");
> 
> 

Acked-by: Michael Buesch <mb@bu3sch.de>

-- 
Greetings Michael.

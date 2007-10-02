Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3255 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449AbXJBUiY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 16:38:24 -0400
Date: Tue, 2 Oct 2007 16:20:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] b43: Leds spinlock SMP compilefix
Message-ID: <20071002202053.GB29361@tuxdriver.com> (sfid-20071002_213914_602838_90999A93)
References: <200709300004.36905.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200709300004.36905.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'll just roll this into the "b43: LED triggers support" patch.

Thanks,

John

On Sun, Sep 30, 2007 at 12:04:36AM +0200, Michael Buesch wrote:
> This was missing an address operator.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> Index: wireless-2.6/drivers/net/wireless/b43/leds.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/leds.c	2007-09-29 12:44:08.000000000 +0200
> +++ wireless-2.6/drivers/net/wireless/b43/leds.c	2007-09-30 00:02:18.000000000 +0200
> @@ -37,14 +37,14 @@ static void b43_led_turn_on(struct b43_w
>  	unsigned long flags;
>  	u16 ctl;
>  
> -	spin_lock_irqsave(wl->leds_lock, flags);
> +	spin_lock_irqsave(&wl->leds_lock, flags);
>  	ctl = b43_read16(dev, B43_MMIO_GPIO_CONTROL);
>  	if (activelow)
>  		ctl &= ~(1 << led_index);
>  	else
>  		ctl |= (1 << led_index);
>  	b43_write16(dev, B43_MMIO_GPIO_CONTROL, ctl);
> -	spin_unlock_irqrestore(wl->leds_lock, flags);
> +	spin_unlock_irqrestore(&wl->leds_lock, flags);
>  }
>  
>  static void b43_led_turn_off(struct b43_wldev *dev, u8 led_index,
> @@ -54,14 +54,14 @@ static void b43_led_turn_off(struct b43_
>  	unsigned long flags;
>  	u16 ctl;
>  
> -	spin_lock_irqsave(wl->leds_lock, flags);
> +	spin_lock_irqsave(&wl->leds_lock, flags);
>  	ctl = b43_read16(dev, B43_MMIO_GPIO_CONTROL);
>  	if (activelow)
>  		ctl |= (1 << led_index);
>  	else
>  		ctl &= ~(1 << led_index);
>  	b43_write16(dev, B43_MMIO_GPIO_CONTROL, ctl);
> -	spin_unlock_irqrestore(wl->leds_lock, flags);
> +	spin_unlock_irqrestore(&wl->leds_lock, flags);
>  }
>  
>  /* Callback from the LED subsystem. */

-- 
John W. Linville
linville@tuxdriver.com

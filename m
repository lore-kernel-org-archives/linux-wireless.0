Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56593
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758869AbXK1Pxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 10:53:41 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Simple 'fix' for radio switch LED regression
Date: Wed, 28 Nov 2007 16:52:05 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <474d8b73.cCPCkkSQe1GIVt4H%Larry.Finger@lwfinger.net>
In-Reply-To: <474d8b73.cCPCkkSQe1GIVt4H%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711281652.05627.mb@bu3sch.de> (sfid-20071128_155346_092323_DAE638CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 November 2007 16:38:27 Larry Finger wrote:
> Since addition of the rfkill callback, the LED associated with the off/on
> switch on the radio has not worked because essential data in the rfkill
> structure is missing. When that problem was fixed, difficulties in circular
> locking surfaced. This patch fixes part of the regression in that the LED
> is turned on if the radio switch is on at startup. Adding the code to toggle
> the LED with the switch will be more involved and would likely miss the 2.6.24
> window.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John and Michael,
> 
> I was able to get the full functionality working, but with two significant
> problems: (1) the LED toggled only with a switch off-on sequence, not with
> each switch change and (2) the module would no longer unload cleanly due to
> circular locking. I will be essentually off-line after today, and I hope that
> this hack, which will make the LED appear to work correctly, can be pushed
> into 2.6.24 as it is a fix, but has minimal code impact. Nearly all of the
> changes are needed just to make the LED on routine available to startup.
> Furthermore, I'm certain these changes will be needed when the complete fix
> is available.

That completely shortcuts the "behaviour" logic.
This patch trades one bug for another.
It will get other people upset, because their LEDs don't work as expected anymore.

This is not a showstopper bug and there is no need to introduce dirty
fixes that trade one bug for another.
I'm pretty sure that this patch will break LEDs on my asus card. I didn't
try that, though.

Please don't apply this. We have enough time to develop the correct solution
to this problem.

>  leds.c |    3 +--
>  leds.h |    1 +
>  main.c |    3 +++
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> Index: wireless-2.6/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/main.c
> +++ wireless-2.6/drivers/net/wireless/b43/main.c
> @@ -51,6 +51,7 @@
>  #include "xmit.h"
>  #include "lo.h"
>  #include "pcmcia.h"
> +#include "leds.h"
>  
>  MODULE_DESCRIPTION("Broadcom B43 wireless driver");
>  MODULE_AUTHOR("Martin Langer");
> @@ -2799,6 +2797,8 @@ static int b43_op_config(struct ieee8021
>  	b43_interrupt_enable(dev, savedirqs);
>  	mmiowb();
>  	spin_unlock_irqrestore(&wl->irq_lock, flags);
> +	if (dev->radio_hw_enable)
> +		b43_led_turn_on(dev, 1, 1);
>        out_unlock_mutex:
>  	mutex_unlock(&wl->mutex);
>  
> Index: wireless-2.6/drivers/net/wireless/b43/leds.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/leds.c
> +++ wireless-2.6/drivers/net/wireless/b43/leds.c
> @@ -30,8 +30,7 @@
>  #include "leds.h"
>  
>  
> -static void b43_led_turn_on(struct b43_wldev *dev, u8 led_index,
> -			    bool activelow)
> +void b43_led_turn_on(struct b43_wldev *dev, u8 led_index, bool activelow)
>  {
>  	struct b43_wl *wl = dev->wl;
>  	unsigned long flags;
> Index: wireless-2.6/drivers/net/wireless/b43/leds.h
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/leds.h
> +++ wireless-2.6/drivers/net/wireless/b43/leds.h
> @@ -44,6 +44,7 @@ enum b43_led_behaviour {
>  
>  void b43_leds_init(struct b43_wldev *dev);
>  void b43_leds_exit(struct b43_wldev *dev);
> +void b43_led_turn_on(struct b43_wldev *dev, u8 led_index, bool activelow);
>  
>  
>  #else /* CONFIG_B43_LEDS */
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
> 
> 



-- 
Greetings Michael.

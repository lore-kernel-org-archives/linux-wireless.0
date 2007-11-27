Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57241
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbXK0QOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 11:14:20 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC/T] b43: Fix Radio On/Off LED action
Date: Tue, 27 Nov 2007 17:13:02 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net>
In-Reply-To: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711271713.02698.mb@bu3sch.de> (sfid-20071127_161442_881626_6DFF29BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 November 2007 17:03:57 Larry Finger wrote:
> Since addition of the rfkill callback, the LED associated with the off
> switch on the radio has not worked because essential data in the rfkill
> structure was missing. This hack adds the necessary data and places direct
> calls to turn the leds on/off.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-2.6/drivers/net/wireless/b43/rfkill.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/rfkill.c
> +++ wireless-2.6/drivers/net/wireless/b43/rfkill.c
> @@ -23,6 +23,7 @@
>  */
>  
>  #include "rfkill.h"
> +#include "leds.h"
>  #include "b43.h"
>  
>  
> @@ -57,6 +58,10 @@ static void b43_rfkill_poll(struct input
>  		report_change = 1;
>  		b43info(wl, "Radio hardware status changed to %s\n",
>  			enabled ? "ENABLED" : "DISABLED");
> +		if (enabled)
> +			b43_led_turn_on(dev, 1, 1);
> +		else
> +			b43_led_turn_off(dev, 1, 1);
>  	}
>  	mutex_unlock(&wl->mutex);
>  

This is not how led triggers work.
You are shortcutting the whole thing here. So you could as well
remove the whole rfkill and LEDs code.

Please properly register the LED in the leds code and
add a default LED trigger for the rfkill trigger.
This has several advantages to the user, among the possiblility to
reassign a LED to a different trigger.

> @@ -70,11 +75,13 @@ static int b43_rfkill_soft_toggle(void *
>  	struct b43_wldev *dev = data;
>  	struct b43_wl *wl = dev->wl;
>  	int err = 0;
> +	int lock = mutex_is_locked(&wl->mutex);
>  
>  	if (!wl->rfkill.registered)
>  		return 0;
>  
> -	mutex_lock(&wl->mutex);
> +	if (!lock)
> +		mutex_lock(&wl->mutex);

Nah, it shouldn't be locked by "current" in the first place, here.
(I guess that's what you are trying to check here).
That's what the !registered check above is for.
This !lock check is racy.

>  	B43_WARN_ON(b43_status(dev) < B43_STAT_INITIALIZED);
>  	switch (state) {
>  	case RFKILL_STATE_ON:
> @@ -93,7 +100,8 @@ static int b43_rfkill_soft_toggle(void *
>  		break;
>  	}
>  out_unlock:
> -	mutex_unlock(&wl->mutex);
> +	if (!lock)
> +		mutex_unlock(&wl->mutex);
>  
>  	return err;


-- 
Greetings Michael.

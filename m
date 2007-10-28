Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:19887 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbXJ1MqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 08:46:11 -0400
Received: by ug-out-1314.google.com with SMTP id z38so877053ugc
        for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2007 05:46:09 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] rfkill: Register LED triggers before registering switch
Date: Sun, 28 Oct 2007 14:05:46 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200710281307.54552.mb@bu3sch.de>
In-Reply-To: <200710281307.54552.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710281405.47341.IvDoorn@gmail.com> (sfid-20071028_124615_986813_0D92FF05)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 October 2007, Michael Buesch wrote:
> Registering the switch triggers a LED event, so we must register
> LED triggers before the switch.
> This has a potential to fix a crash, depending on how the device
> driver initializes the rfkill data structure.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

> 
> Index: wireless-2.6/net/rfkill/rfkill.c
> ===================================================================
> --- wireless-2.6.orig/net/rfkill/rfkill.c	2007-10-27 13:28:33.000000000 +0200
> +++ wireless-2.6/net/rfkill/rfkill.c	2007-10-28 12:57:12.000000000 +0100
> @@ -388,19 +388,20 @@ int rfkill_register(struct rfkill *rfkil
>  	if (!rfkill->toggle_radio)
>  		return -EINVAL;
>  
> +	snprintf(dev->bus_id, sizeof(dev->bus_id),
> +		 "rfkill%ld", (long)atomic_inc_return(&rfkill_no) - 1);
> +
> +	rfkill_led_trigger_register(rfkill);
> +
>  	error = rfkill_add_switch(rfkill);
>  	if (error)
>  		return error;
>  
> -	snprintf(dev->bus_id, sizeof(dev->bus_id),
> -		 "rfkill%ld", (long)atomic_inc_return(&rfkill_no) - 1);
> -
>  	error = device_add(dev);
>  	if (error) {
>  		rfkill_remove_switch(rfkill);
>  		return error;
>  	}
> -	rfkill_led_trigger_register(rfkill);
>  
>  	return 0;
>  }
> @@ -416,9 +417,9 @@ EXPORT_SYMBOL(rfkill_register);
>   */
>  void rfkill_unregister(struct rfkill *rfkill)
>  {
> -	rfkill_led_trigger_unregister(rfkill);
>  	device_del(&rfkill->dev);
>  	rfkill_remove_switch(rfkill);
> +	rfkill_led_trigger_unregister(rfkill);
>  	put_device(&rfkill->dev);
>  }
>  EXPORT_SYMBOL(rfkill_unregister);
> 



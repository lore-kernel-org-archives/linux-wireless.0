Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:8746 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYGSMU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 08:20:59 -0400
Received: by nf-out-0910.google.com with SMTP id d3so241273nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2008 05:20:57 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 2/4] rfkill: fix led-trigger unregister order in error unwind
Date: Sat, 19 Jul 2008 14:35:39 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Dmitry Baryshkov <dbaryshkov@gmail.com>
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br> <1216150327-10904-3-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1216150327-10904-3-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807191435.39305.IvDoorn@gmail.com> (sfid-20080719_142101_728822_2D375E8B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 July 2008, Henrique de Moraes Holschuh wrote:
> rfkill needs to unregister the led trigger AFTER a call to
> rfkill_remove_switch(), otherwise it will not update the LED state,
> possibly leaving it ON when it should be OFF.
> 
> To make led-trigger unregistering safer, guard against unregistering a
> trigger twice, and also against issuing trigger events to a led trigger
> that was unregistered.  This makes the error unwind paths more resilient.
> 
> Refer to commit 8a8f1c0437a77cce29c1cb6089f01f22a6d9ca6e,
> "rfkill: Register LED triggers before registering switch".
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 022fe50..fc3a4fd 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -590,8 +590,10 @@ static void rfkill_led_trigger_register(struct rfkill *rfkill)
>  static void rfkill_led_trigger_unregister(struct rfkill *rfkill)
>  {
>  #ifdef CONFIG_RFKILL_LEDS
> -	if (rfkill->led_trigger.name)
> +	if (rfkill->led_trigger.name) {
>  		led_trigger_unregister(&rfkill->led_trigger);
> +		rfkill->led_trigger.name = NULL;
> +	}
>  #endif
>  }
>  
> @@ -627,8 +629,8 @@ int rfkill_register(struct rfkill *rfkill)
>  
>  	error = device_add(dev);
>  	if (error) {
> -		rfkill_led_trigger_unregister(rfkill);
>  		rfkill_remove_switch(rfkill);
> +		rfkill_led_trigger_unregister(rfkill);
>  		return error;
>  	}
>  



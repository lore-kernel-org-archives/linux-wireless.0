Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:33226 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYGVQy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 12:54:58 -0400
Received: by nf-out-0910.google.com with SMTP id d3so708172nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 09:54:57 -0700 (PDT)
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH 2/2] RFKILL: set the status of the leds on activation.
Date: Tue, 22 Jul 2008 19:11:35 +0200
Cc: linux-wireless@vger.kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	akpm@linux-foundation.org
References: <20080722102159.GA32682@doriath.ww600.siemens.net>
In-Reply-To: <20080722102159.GA32682@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807221911.35975.IvDoorn@gmail.com> (sfid-20080722_185500_693354_EE510071)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 22 July 2008, Dmitry Baryshkov wrote:
> Provide default activate function to set the state of the led
> when the led becomes bound to the trigger
> 
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> -- 
>  This patch depends on the patch "leds: make sure led->trigger is set
>  earlier" which was staged in -mm for some time and recently got merged
>  into leds tree.
> ---
>  net/rfkill/rfkill.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index b247677..e9010ff 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -57,6 +57,16 @@ static void rfkill_led_trigger(struct rfkill *rfkill,
>  #endif /* CONFIG_RFKILL_LEDS */
>  }
>  
> +#ifdef CONFIG_RFKILL_LEDS
> +static void rfkill_led_trigger_activate(struct led_classdev *led)
> +{
> +	struct rfkill *rfkill = container_of(led->trigger,
> +			struct rfkill, led_trigger);
> +
> +	rfkill_led_trigger(rfkill, rfkill->state);
> +}
> +#endif /* CONFIG_RFKILL_LEDS */
> +
>  static int rfkill_toggle_radio(struct rfkill *rfkill,
>  				enum rfkill_state state)
>  {
> @@ -357,6 +367,8 @@ static void rfkill_led_trigger_register(struct rfkill *rfkill)
>  
>  	if (!rfkill->led_trigger.name)
>  		rfkill->led_trigger.name = rfkill->dev.bus_id;
> +	if (!rfkill->led_trigger.activate)
> +		rfkill->led_trigger.activate = rfkill_led_trigger_activate;
>  	error = led_trigger_register(&rfkill->led_trigger);
>  	if (error)
>  		rfkill->led_trigger.name = NULL;
> -- 
> 1.5.6.2
> 
> 



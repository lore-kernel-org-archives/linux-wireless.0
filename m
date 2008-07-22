Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:33226 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbYGVQyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 12:54:55 -0400
Received: by nf-out-0910.google.com with SMTP id d3so708172nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 09:54:55 -0700 (PDT)
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH 1/2] RFKILL: allow one to specify led trigger name
Date: Tue, 22 Jul 2008 19:11:34 +0200
Cc: linux-wireless@vger.kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
References: <20080722101737.GA32672@doriath.ww600.siemens.net>
In-Reply-To: <20080722101737.GA32672@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807221911.34273.IvDoorn@gmail.com> (sfid-20080722_185458_231846_FFD22004)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 22 July 2008, Dmitry Baryshkov wrote:
> Allow the rfkill driver to specify led trigger name.
> By default it still defaults to the name of rfkill switch.
> 
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  net/rfkill/rfkill.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
> index 4e10a95..b247677 100644
> --- a/net/rfkill/rfkill.c
> +++ b/net/rfkill/rfkill.c
> @@ -355,7 +355,8 @@ static void rfkill_led_trigger_register(struct rfkill *rfkill)
>  #ifdef CONFIG_RFKILL_LEDS
>  	int error;
>  
> -	rfkill->led_trigger.name = rfkill->dev.bus_id;
> +	if (!rfkill->led_trigger.name)
> +		rfkill->led_trigger.name = rfkill->dev.bus_id;
>  	error = led_trigger_register(&rfkill->led_trigger);
>  	if (error)
>  		rfkill->led_trigger.name = NULL;
> -- 
> 1.5.6.2
> 
> 



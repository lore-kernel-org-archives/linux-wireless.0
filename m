Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53994 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbYGVLUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 07:20:43 -0400
Date: Tue, 22 Jul 2008 08:20:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH 1/2] RFKILL: allow one to specify led trigger name
Message-ID: <20080722112037.GB15136@khazad-dum.debian.net> (sfid-20080722_132046_521781_50D04B53)
References: <20080722101737.GA32672@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080722101737.GA32672@doriath.ww600.siemens.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 22 Jul 2008, Dmitry Baryshkov wrote:
> Allow the rfkill driver to specify led trigger name.
> By default it still defaults to the name of rfkill switch.
> 
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
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

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

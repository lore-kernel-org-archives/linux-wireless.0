Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:43609 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759555AbXEOCtR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2007 22:49:17 -0400
Message-ID: <46491FA6.9050403@garzik.org>
Date: Mon, 14 May 2007 22:49:10 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] eeprom_93cx6: Add comment for 1us delay after pulse
References: <200705142306.01172.IvDoorn@gmail.com>
In-Reply-To: <200705142306.01172.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> This will add a comment for the 1us delay which is taken
> after the pulse has been switched. The 1us delay is based
> on the specifications so that should be made clear.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> ---
> 
> diff --git a/drivers/misc/eeprom_93cx6.c b/drivers/misc/eeprom_93cx6.c
> index a948ddc..8c8b43f 100644
> --- a/drivers/misc/eeprom_93cx6.c
> +++ b/drivers/misc/eeprom_93cx6.c
> @@ -39,6 +39,12 @@ static inline void eeprom_93cx6_pulse_high(struct eeprom_93cx6 *eeprom)
>  {
>  	eeprom->reg_data_clock = 1;
>  	eeprom->register_write(eeprom);
> +
> +	/*
> +	 * Add a short delay for the pulse to work.
> +	 * According to the specifications the minimal time
> +	 * should be 450ns so a 1us delay is sufficient.
> +	 */
>  	udelay(1);
>  }
>  
> @@ -46,6 +52,12 @@ static inline void eeprom_93cx6_pulse_low(struct eeprom_93cx6 *eeprom)
>  {
>  	eeprom->reg_data_clock = 0;
>  	eeprom->register_write(eeprom);
> +
> +	/*
> +	 * Add a short delay for the pulse to work.
> +	 * According to the specifications the minimal time
> +	 * should be 450ns so a 1us delay is sufficient.
> +	 */
>  	udelay(1);

why not ndelay(450)?

	Jeff




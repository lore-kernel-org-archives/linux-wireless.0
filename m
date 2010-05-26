Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48265 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab0EZRaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 13:30:12 -0400
Date: Wed, 26 May 2010 13:18:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com
Subject: Re: [PATCH]wireless:ath9k Disable leds for Apple products.
Message-ID: <20100526171844.GB5823@tuxdriver.com>
References: <1274894056-2866-1-git-send-email-justinmattock@gmail.com>
 <1274894056-2866-2-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1274894056-2866-2-git-send-email-justinmattock@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 26, 2010 at 10:14:16AM -0700, Justin P. Mattock wrote:
> Disable the leds on ath9k for Apple products, since
> there is no leds on any of there machines(or non that I can find!!).
> 
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 

>  void ath_init_leds(struct ath_softc *sc)
>  {
>  	char *trigger;
>  	int ret;
>  
> +	/* Apple has no leds lights for their wireless.  */
> +	if (dmi_check_system(dmi_system_table) > 0)
> +		return -ENODEV;
> +	else
> +
>  	if (AR_SREV_9287(sc->sc_ah))
>  		sc->sc_ah->led_pin = ATH_LED_PIN_9287;
>  	else

Surely we don't need the 'else'.

Does enabling the LEDs on these systems cause any problems?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

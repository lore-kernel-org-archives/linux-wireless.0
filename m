Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:47879 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0LVV3t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 16:29:49 -0500
Subject: Re: [PATCH v2 07/18] wl1271: AP specific RX filter configuration
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1293028057-6212-8-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
	 <1293028057-6212-8-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 23:29:46 +0200
Message-ID: <1293053386.14423.46.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
> Set filters according to the mode of operation.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
> index d67dcff..5f19a40 100644
> --- a/drivers/net/wireless/wl12xx/boot.h
> +++ b/drivers/net/wireless/wl12xx/boot.h
> @@ -69,4 +69,7 @@ struct wl1271_static_data {
>  #define FREF_CLK_POLARITY_BITS 0xfffff8ff
>  #define CLK_REQ_OUTN_SEL       0x700
>  
> +/* Functions from wl1271_main.c */
> +void wl1271_set_default_filters(struct wl1271 *wl);
> +

This is not good.  Can't this be defined in rx.c and rx.h instead?


-- 
Cheers,
Luca.


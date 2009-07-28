Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59473 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbZG1UWQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 16:22:16 -0400
Subject: Re: [PATCH] libertas: Read outside array bounds
From: Dan Williams <dcbw@redhat.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4A6EAFF3.8050502@gmail.com>
References: <4A6EAFF3.8050502@gmail.com>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 16:22:54 -0400
Message-Id: <1248812574.2115.0.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-07-28 at 09:59 +0200, Roel Kluin wrote:
> reads bss->rates[j] before checking bounds of index, and should use
> ARRAY_SIZE to determine the size of the array.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
> index 601b542..6c95af3 100644
> --- a/drivers/net/wireless/libertas/scan.c
> +++ b/drivers/net/wireless/libertas/scan.c
> @@ -5,6 +5,7 @@
>    *  for sending scan commands to the firmware.
>    */
>  #include <linux/types.h>
> +#include <linux/kernel.h>
>  #include <linux/etherdevice.h>
>  #include <linux/if_arp.h>
>  #include <asm/unaligned.h>
> @@ -876,7 +877,7 @@ static inline char *lbs_translate_scan(struct lbs_private *priv,
>  	iwe.u.bitrate.disabled = 0;
>  	iwe.u.bitrate.value = 0;
>  
> -	for (j = 0; bss->rates[j] && (j < sizeof(bss->rates)); j++) {
> +	for (j = 0; j < ARRAY_SIZE(bss->rates) && bss->rates[j]; j++) {
>  		/* Bit rate given in 500 kb/s units */
>  		iwe.u.bitrate.value = bss->rates[j] * 500000;
>  		current_val = iwe_stream_add_value(info, start, current_val,


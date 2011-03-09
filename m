Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:49792 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab1CIIl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 03:41:59 -0500
Received: by mail-fx0-f41.google.com with SMTP id 5so349203fxm.14
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 00:41:57 -0800 (PST)
Subject: Re: [PATCH 08/15] wl12xx: 1281/1283 support - Improve Tx & Rx path
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1299421940-26292-9-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
	 <1299421940-26292-9-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 10:41:48 +0200
Message-ID: <1299660108.1816.95.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-03-06 at 16:32 +0200, Shahar Levi wrote:
> Reduced bus transactions in Tx & Rx path
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---




> diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
> index 919b59f..c95ae19 100644
> --- a/drivers/net/wireless/wl12xx/rx.c
> +++ b/drivers/net/wireless/wl12xx/rx.c

[...]

> @@ -204,7 +211,8 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
>  	 * Write the driver's packet counter to the FW. This is only required
>  	 * for older hardware revisions
>  	 */
> -	if (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION)
> +	if ((wl->chip.id != CHIP_ID_1283_PG20) &&
> +	    (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION))
>  		wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
>  }

The WL12XX_QUIRK_END_OF_TRANSACTION is only enabled for wl127x, so no
need to check that it's not wl128x here.

> @@ -537,7 +550,8 @@ out_ack:
>  		 * Interrupt the firmware with the new packets. This is only
>  		 * required for older hardware revisions
>  		 */
> -		if (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION)
> +		if ((wl->chip.id != CHIP_ID_1283_PG20) &&
> +		    (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION))
>  			wl1271_write32(wl, WL1271_HOST_WR_ACCESS,
>  				       wl->tx_packets_count);
>  

Same thing here.

I'll remove these unnecessary checks.


-- 
Cheers,
Luca.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:65351 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab0K2Mxh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 07:53:37 -0500
Subject: Re: [RFC 2/2] wl12xx: Stop BA session event from device
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1290695964-4208-2-git-send-email-shahar_levi@ti.com>
References: <1290695964-4208-1-git-send-email-shahar_levi@ti.com>
	 <1290695964-4208-2-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 14:53:31 +0200
Message-ID: <1291035211.1673.68.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-25 at 16:39 +0200, ext Shahar Levi wrote:
> Adding new event that close RX BA session in case of periodic BT activity
> limiting WLAN activity.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

[...]

> diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
> index 9815b7b..7cbeb2b 100644
> --- a/drivers/net/wireless/wl12xx/event.c
> +++ b/drivers/net/wireless/wl12xx/event.c
> @@ -174,6 +174,25 @@ static void wl1271_event_rssi_trigger(struct wl1271 *wl,
>  	wl->last_rssi_event = event;
>  }
>  
> +static void wl1271_event_ba_rx_constraint(struct wl1271 *wl,
> +					  struct event_mailbox *mbox)
> +{
> +	u8 tid_index = 0;
> +
> +	wl1271_debug(DEBUG_EVENT, "BA RX constraint event. ba_allowed = %d",
> +		     mbox->ba_allowed);
> +
> +	wl->ba_allowed = mbox->ba_allowed;
> +
> +	if (!wl->ba_rx_bitmap)
> +		return;
> +
> +	for (tid_index = 0; tid_index < CONF_TX_MAX_TID_COUNT; ++tid_index)

Please use the more classic tid_index++ instead.


-- 
Cheers,
Luca.


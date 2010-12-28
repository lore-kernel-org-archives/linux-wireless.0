Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:56583 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab0L1MDq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 07:03:46 -0500
Subject: Re: [PATCH v2 15/18] wl1271: AP mode - encryption support
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1293028057-6212-16-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
	 <1293028057-6212-16-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 14:03:43 +0200
Message-ID: <1293537823.24274.18.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
> Encryption key configuration is different for AP/STA modes.
> 
> AP encryption keys are recorded when the BSS is not started. On BSS
> start they are propagated to the AP (in wl1271_ap_init_hwenc).
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
> index 0662b19..81ba75d 100644
> --- a/drivers/net/wireless/wl12xx/tx.h
> +++ b/drivers/net/wireless/wl12xx/tx.h
> @@ -152,4 +152,8 @@ void wl1271_tx_flush(struct wl1271 *wl);
>  u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
>  u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set);
>  
> +/* Functions from wl1271_main.c */
> +
> +int wl1271_set_default_wep_key(struct wl1271 *wl, u8 id);
> +
>  #endif

Again, same thing.  Can we put this somewhere else?


-- 
Cheers,
Luca.


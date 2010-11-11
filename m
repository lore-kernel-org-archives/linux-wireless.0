Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:19839 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab0KKJfs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 04:35:48 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAB9Zlwm011953
	for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 11:35:47 +0200
Subject: Re: [PATCH 1/2] wl1271: Prevent ad-hoc and active scanning on 11a
 DFS frequencies
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "Oikarinen Juuso (Nokia-MS/Tampere)" <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 11:35:34 +0200
Message-ID: <1289468134.1606.16.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-10 at 11:27 +0100, Oikarinen Juuso (Nokia-MS/Tampere)
wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> The wl1271 does not support radar detection. Hence, prevent ad-hoc and
> active scanning on frequencies requiring DFS.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

This looks good, except for the typo described below.

Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>


> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
> index f5b1d19..eb9f821 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> @@ -335,6 +335,27 @@ out:
>  	return NOTIFY_OK;
>  }
>  
> +static int wl1271_reg_notify(struct wiphy *wiphy,
> +			     struct regulatory_request *request) {
> +	struct ieee80211_supported_band *band;
> +	struct ieee80211_channel *ch;
> +	int i;
> +
> +	band = wiphy->bands[IEEE80211_BAND_5GHZ];
> +	for (i = 0; i < band->n_channels; i++) {
> +		ch = &band->channels[i];
> +		if (ch->flags % IEEE80211_CHAN_DISABLED)

Typo here, should be & instead of %.  I'll fix it myself before
applying, so no need to resend.

-- 
Cheers,
Luca.


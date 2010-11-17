Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38420 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933879Ab0KQGxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 01:53:04 -0500
From: "Gabay, Benzy" <benzyg@ti.com>
To: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>,
	"luciano.coelho@nokia.com" <luciano.coelho@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 17 Nov 2010 00:52:56 -0600
Subject: RE: [PATCH 1/2] wl1271: Prevent ad-hoc and active scanning on 11a
 DFS frequencies
Message-ID: <676FD6AA0F002F49B89E70F0C5EFD22C136DEA03B9@dlee04.ent.ti.com>
References: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juuso,

> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> The wl1271 does not support radar detection. Hence, prevent ad-hoc and
> active scanning on frequencies requiring DFS.

I know it's a bit late but:
Doesn't the fact that your referring here to 1271, which is support 2.4Ghz device only matter here to anyone?
Correct me if I'm wrong here but radar detection was meant only for 5.0Ghz device types. 
Should this patch should be done on 1273 device type or a change in the naming convention should be applied here.


> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271_main.c |   23
> +++++++++++++++++++++++
>  1 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c
> b/drivers/net/wireless/wl12xx/wl1271_main.c
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
> +			continue;
> +
> +		if (ch->flags & IEEE80211_CHAN_RADAR)
> +			ch->flags |= IEEE80211_CHAN_NO_IBSS |
> +				     IEEE80211_CHAN_PASSIVE_SCAN;
> +
> +	}
> +
> +	return 0;
> +}
> +
>  static void wl1271_conf_init(struct wl1271 *wl)
>  {
> 
> @@ -2590,6 +2611,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
>  	wl->hw->queues = 4;
>  	wl->hw->max_rates = 1;
> 
> +	wl->hw->wiphy->reg_notifier = wl1271_reg_notify;
> +
>  	SET_IEEE80211_DEV(wl->hw, wl1271_wl_to_dev(wl));
> 
>  	return 0;
> --
> 1.7.1



=========
Benzy Gabay
Texas Instruments

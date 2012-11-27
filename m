Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33131 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab2K0Nh0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 08:37:26 -0500
Message-ID: <1354023406.950.109.camel@cumari.coelho.fi> (sfid-20121127_143729_514687_18A42AC9)
Subject: Re: [PATCH 14/20] wlcore: restore default channel configuration
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>,
	Victor Goldenshtein <victorg@ti.com>
Date: Tue, 27 Nov 2012 15:36:46 +0200
In-Reply-To: <1353998701-18171-15-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
	 <1353998701-18171-15-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 08:44 +0200, Arik Nemtsov wrote:
> From: Victor Goldenshtein <victorg@ti.com>
> 
> wlcore allocates two static structs wl1271_band_2ghz & wl1271_band_5ghz
> which are used/modified by Reg-Domain e.g. some channel might be marked
> as passive at some point. Make sure we don't keep stale settings around
> if the HW is unregistered/registered during operation.
> 
> [Arik - use Tx-power constant and tweak commit message]
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index e68cd3f..3ced59b 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c

[...]

> @@ -5537,6 +5537,7 @@ wlcore_iface_combinations[] = {
>  
>  static int wl1271_init_ieee80211(struct wl1271 *wl)
>  {
> +	int i;
>  	static const u32 cipher_suites[] = {
>  		WLAN_CIPHER_SUITE_WEP40,
>  		WLAN_CIPHER_SUITE_WEP104,
> @@ -5599,6 +5600,22 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
>  		     ARRAY_SIZE(wl1271_channels_5ghz) >
>  		     WL1271_MAX_CHANNELS);
>  	/*
> +	* clear channel flags from the previous usage
> +	* and restore max_power & max_antenna_gain values.
> +	*/
> +	for (i = 0; i < ARRAY_SIZE(wl1271_channels); i++) {
> +		wl1271_band_2ghz.channels[i].flags = 0;
> +		wl1271_band_2ghz.channels[i].max_power = WLCORE_MAX_TXPWR;
> +		wl1271_band_2ghz.channels[i].max_antenna_gain = 0;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(wl1271_channels_5ghz); i++) {
> +		wl1271_band_5ghz.channels[i].flags = 0;
> +		wl1271_band_5ghz.channels[i].max_power = WLCORE_MAX_TXPWR;
> +		wl1271_band_5ghz.channels[i].max_antenna_gain = 0;
> +	}
> +
> +	/*

This looks a bit hacky, because you must know what values are being
modified by cfg80211.  What if in the future there are more values in
the channel structure that are being modified?

The best would be to have a copy of the struct to pass to cfg80211 when
the hardware is registered and realloc it when we unregister.  That
would be safer and more future-proof, but would use a bit more memory
though.

--
Luca.


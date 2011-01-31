Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab1AaMKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 07:10:32 -0500
Subject: Re: [PATCH] iwlwifi: correct frequency settings
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1296475295-5420-1-git-send-email-sgruszka@redhat.com>
References: <1296475295-5420-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 13:10:26 +0100
Message-ID: <1296475826.3812.24.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 13:01 +0100, Stanislaw Gruszka wrote:
> After commit 59eb21a6504731fc16db4cf9463065dd61093e08
> "cfg80211: Extend channel to frequency mapping for 802.11j"
> we use uninitialized sband->band when assign channel frequencies, what
> results that 5GHz channels have erroneous (zero) center_freq value.
> 
> Patch fixes problem and simplifies code a bit.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thanks!

> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-core.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
> index 92724cb..4ad8938 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -219,16 +219,12 @@ int iwlcore_init_geos(struct iwl_priv *priv)
>  		if (!is_channel_valid(ch))
>  			continue;
>  
> -		if (is_channel_a_band(ch))
> -			sband =  &priv->bands[IEEE80211_BAND_5GHZ];
> -		else
> -			sband =  &priv->bands[IEEE80211_BAND_2GHZ];
> +		sband =  &priv->bands[ch->band];
>  
>  		geo_ch = &sband->channels[sband->n_channels++];
>  
>  		geo_ch->center_freq =
> -				ieee80211_channel_to_frequency(ch->channel,
> -							       sband->band);
> +			ieee80211_channel_to_frequency(ch->channel, ch->band);
>  		geo_ch->max_power = ch->max_power_avg;
>  		geo_ch->max_antenna_gain = 0xff;
>  		geo_ch->hw_value = ch->channel;



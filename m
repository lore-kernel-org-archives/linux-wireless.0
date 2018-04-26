Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52176 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756020AbeDZNoJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 09:44:09 -0400
Subject: Re: [PATCH v1] ath10k: fix band_center_freq handling for VHT160 in
 recent firmwares
To: s.gottschall@dd-wrt.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
References: <20180426094357.24358-1-s.gottschall@dd-wrt.com>
Cc: kvalo@codeaurora.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <19b8766e-d474-31d3-ff38-993498ee670d@candelatech.com> (sfid-20180426_154423_505826_4E4D78E8)
Date: Thu, 26 Apr 2018 06:44:00 -0700
MIME-Version: 1.0
In-Reply-To: <20180426094357.24358-1-s.gottschall@dd-wrt.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/26/2018 02:43 AM, s.gottschall@dd-wrt.com wrote:
> From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>
> starting with firmware 10.4.3.4.x series QCA changed the handling of the channel property band_center_freq1 and band_center_freq2 in vht160 operation mode
> likelly for backward compatiblity with vht80 only capable clients.
> this patch adjusts the handling to get vht160 to work again with official qca firmwares newer than 3.3
> consider that this patch will not work with older firmwares anymore. to avoid undefined behaviour this we disable vht160 capability for outdated firmwares

We should be able to use a feature-flag or otherwise determine if the firmware needs the old or new
API and make the driver able to handle both.

Thanks,
Ben

> ---
>  drivers/net/wireless/ath/ath10k/mac.c |  7 -------
>  drivers/net/wireless/ath/ath10k/wmi.c | 11 ++++++++---
>  2 files changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 5be6386ede8f..d1239d40ac19 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4449,13 +4449,6 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
>  		vht_cap.cap |= val;
>  	}
>
> -	/* Currently the firmware seems to be buggy, don't enable 80+80
> -	 * mode until that's resolved.
> -	 */
> -	if ((ar->vht_cap_info & IEEE80211_VHT_CAP_SHORT_GI_160) &&
> -	    (ar->vht_cap_info & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) == 0)
> -		vht_cap.cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
> -
>  	mcs_map = 0;
>  	for (i = 0; i < 8; i++) {
>  		if ((i < ar->num_rf_chains) && (ar->cfg_tx_chainmask & BIT(i)))
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 2c36256a441d..d78b8857a513 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -1671,13 +1671,18 @@ void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
>  		flags |= WMI_CHAN_FLAG_HT40_PLUS;
>  	if (arg->chan_radar)
>  		flags |= WMI_CHAN_FLAG_DFS;
> -
> +	ch->band_center_freq2 = 0;
>  	ch->mhz = __cpu_to_le32(arg->freq);
>  	ch->band_center_freq1 = __cpu_to_le32(arg->band_center_freq1);
>  	if (arg->mode == MODE_11AC_VHT80_80)
>  		ch->band_center_freq2 = __cpu_to_le32(arg->band_center_freq2);
> -	else
> -		ch->band_center_freq2 = 0;
> +	if (arg->mode == MODE_11AC_VHT160)  {
> +		if (arg->freq < arg->band_center_freq1)
> +			ch->band_center_freq1 = __cpu_to_le32(arg->band_center_freq1 - 40);
> +		else
> +			ch->band_center_freq1 = __cpu_to_le32(arg->band_center_freq1 + 40);		
> +		ch->band_center_freq2 = __cpu_to_le32(arg->band_center_freq1);
> +	}
>  	ch->min_power = arg->min_power;
>  	ch->max_power = arg->max_power;
>  	ch->reg_power = arg->max_reg_power;
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

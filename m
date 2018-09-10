Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39084 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbeIJUnj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 16:43:39 -0400
Subject: Re: [PATCH] ath10k: Add support for configuring management packet
 rate
To: Sriram R <srirrama@codeaurora.org>, ath10k@lists.infradead.org
References: <1536557980-11895-1-git-send-email-srirrama@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <9fde2907-d95a-1953-53ce-e773aca17866@candelatech.com> (sfid-20180910_174901_867520_C23B1FB2)
Date: Mon, 10 Sep 2018 08:48:54 -0700
MIME-Version: 1.0
In-Reply-To: <1536557980-11895-1-git-send-email-srirrama@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/2018 10:39 PM, Sriram R wrote:
> By default the firmware uses 1Mbps and 6Mbps rate for management packets
> in 2G and 5G bands respectively. But when the user selects different
> basic rates from the userspace, we need to send the management
> packets at the lowest basic rate selected by the user.
>
> This change makes use of WMI_VDEV_PARAM_MGMT_RATE param for configuring the
> management packets rate to the firmware.

At least some users like to be able to set the mgt rate to higher rates,
and have been using a debugfs api in my driver patches to do this for some
time.

Maybe you would like to add support for something like this as well?

Thanks,
Ben

>
> Chipsets Tested : QCA988X, QCA9887, QCA9984
> FW Tested 	: 10.2.4-1.0-41, 10.4-3.6.104
>
> Signed-off-by: Sriram R <srirrama@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 45 +++++++++++++++++++++++++++++++++--
>  1 file changed, 43 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 496772d..0b2ca9e 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -157,6 +157,22 @@ u8 ath10k_mac_bitrate_to_idx(const struct ieee80211_supported_band *sband,
>  	return 0;
>  }
>
> +static int ath10k_mac_get_rate_hw_value(int bitrate)
> +{
> +	int i;
> +	u8 hw_value_prefix = 0;
> +
> +	if (ath10k_mac_bitrate_is_cck(bitrate))
> +		hw_value_prefix = WMI_RATE_PREAMBLE_CCK << 6;
> +
> +	for (i = 0; i < sizeof(ath10k_rates); i++) {
> +		if (ath10k_rates[i].bitrate == bitrate)
> +			return hw_value_prefix | ath10k_rates[i].hw_value;
> +	}
> +
> +	return -EINVAL;
> +}
> +
>  static int ath10k_mac_get_max_vht_mcs_map(u16 mcs_map, int nss)
>  {
>  	switch ((mcs_map >> (2 * nss)) & 0x3) {
> @@ -5452,9 +5468,10 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
>  	struct cfg80211_chan_def def;
>  	u32 vdev_param, pdev_param, slottime, preamble;
>  	u16 bitrate, hw_value;
> -	u8 rate;
> -	int rateidx, ret = 0;
> +	u8 rate, basic_rate_idx;
> +	int rateidx, ret = 0, hw_rate_code;
>  	enum nl80211_band band;
> +	const struct ieee80211_supported_band *sband;
>
>  	mutex_lock(&ar->conf_mutex);
>
> @@ -5660,6 +5677,30 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
>  				    arvif->vdev_id,  ret);
>  	}
>
> +	if (changed & BSS_CHANGED_BASIC_RATES) {
> +		if (WARN_ON(ath10k_mac_vif_chan(vif, &def))) {
> +			mutex_unlock(&ar->conf_mutex);
> +			return;
> +		}
> +
> +	sband = ar->hw->wiphy->bands[def.chan->band];
> +	basic_rate_idx = ffs(vif->bss_conf.basic_rates) - 1;
> +	bitrate = sband->bitrates[basic_rate_idx].bitrate;
> +
> +	hw_rate_code = ath10k_mac_get_rate_hw_value(bitrate);
> +	if (hw_rate_code < 0) {
> +		ath10k_warn(ar, "bitrate not supported %d\n", bitrate);
> +		mutex_unlock(&ar->conf_mutex);
> +		return;
> +	}
> +
> +	vdev_param = ar->wmi.vdev_param->mgmt_rate;
> +	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
> +					hw_rate_code);
> +	if (ret)
> +		ath10k_warn(ar, "failed to set mgmt tx rate %d\n", ret);
> +	}
> +
>  	mutex_unlock(&ar->conf_mutex);
>  }
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

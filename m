Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653AbaFIQbf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2014 12:31:35 -0400
Message-ID: <1402331489.7405.2.camel@dcbw.local> (sfid-20140609_183138_953281_9AA48069)
Subject: Re: [PATCH 2/4] rsi: Adding support for 5GHz
From: Dan Williams <dcbw@redhat.com>
To: Jahnavi Meher <jahnavi.meher@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Jahnavi Meher <jahnavi.meher@redpinesignals.com>
Date: Mon, 09 Jun 2014 11:31:29 -0500
In-Reply-To: <1402176137-8485-1-git-send-email-jahnavi.meher@gmail.com>
References: <1402176137-8485-1-git-send-email-jahnavi.meher@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-06-08 at 02:52 +0530, Jahnavi Meher wrote:
> From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
> 
> Adding support for 5GHz.
> 
> Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
> ---
>  drivers/net/wireless/rsi/rsi_91x_mac80211.c |   17 +++++---
>  drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   56 ++++++++++++++++++++++++++-
>  drivers/net/wireless/rsi/rsi_mgmt.h         |    1 +
>  3 files changed, 66 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> index 45bdb99..4700714 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> @@ -723,17 +723,17 @@ static int rsi_mac80211_set_rate_mask(struct ieee80211_hw *hw,
>  {
>  	struct rsi_hw *adapter = hw->priv;
>  	struct rsi_common *common = adapter->priv;
> +	enum ieee80211_band band = hw->conf.chandef.chan->band;
>  
>  	mutex_lock(&common->mutex);
> +	common->fixedrate_mask[band] = 0;
>  
> -	common->fixedrate_mask[IEEE80211_BAND_2GHZ] = 0;
> -
> -	if (mask->control[IEEE80211_BAND_2GHZ].legacy == 0xfff) {
> -		common->fixedrate_mask[IEEE80211_BAND_2GHZ] =
> -			(mask->control[IEEE80211_BAND_2GHZ].ht_mcs[0] << 12);
> +	if (mask->control[band].legacy == 0xfff) {
> +		common->fixedrate_mask[band] =
> +			(mask->control[band].ht_mcs[0] << 12);
>  	} else {
> -		common->fixedrate_mask[IEEE80211_BAND_2GHZ] =
> -			mask->control[IEEE80211_BAND_2GHZ].legacy;
> +		common->fixedrate_mask[band] =
> +			mask->control[band].legacy;
>  	}
>  	mutex_unlock(&common->mutex);
>  
> @@ -980,6 +980,7 @@ int rsi_mac80211_attach(struct rsi_common *common)
>  
>  	hw->max_tx_aggregation_subframes = 6;
>  	rsi_register_rates_channels(adapter, IEEE80211_BAND_2GHZ);
> +	rsi_register_rates_channels(adapter, IEEE80211_BAND_5GHZ);
>  	hw->rate_control_algorithm = "AARF";
>  
>  	SET_IEEE80211_PERM_ADDR(hw, common->mac_addr);
> @@ -997,6 +998,8 @@ int rsi_mac80211_attach(struct rsi_common *common)
>  	wiphy->available_antennas_tx = 1;
>  	wiphy->bands[IEEE80211_BAND_2GHZ] =
>  		&adapter->sbands[IEEE80211_BAND_2GHZ];
> +	wiphy->bands[IEEE80211_BAND_5GHZ] =
> +		&adapter->sbands[IEEE80211_BAND_5GHZ];
>  
>  	status = ieee80211_register_hw(hw);
>  	if (status)
> diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
> index be9f5ca..ab14151 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
> @@ -588,7 +588,13 @@ static int rsi_program_bb_rf(struct rsi_common *common)
>  
>  	mgmt_frame->desc_word[0] = cpu_to_le16(RSI_WIFI_MGMT_Q << 12);
>  	mgmt_frame->desc_word[1] = cpu_to_le16(BBP_PROG_IN_TA);
> -	mgmt_frame->desc_word[4] = cpu_to_le16(common->endpoint << 8);
> +
> +	if (common->band == IEEE80211_BAND_2GHZ)
> +		common->endpoint = 0;
> +	else
> +		common->endpoint = 2;

Here the endpoint is 2 for 5GHz...

> +	mgmt_frame->desc_word[4] = cpu_to_le16(common->endpoint);
>  
>  	if (common->rf_reset) {
>  		mgmt_frame->desc_word[7] =  cpu_to_le16(RF_RESET_ENABLE);
> @@ -827,6 +833,54 @@ static int rsi_send_reset_mac(struct rsi_common *common)
>  }
>  
>  /**
> + * rsi_band_check() - This function programs the band
> + * @common: Pointer to the driver private structure.
> + *
> + * Return: 0 on success, corresponding error code on failure.
> + */
> +int rsi_band_check(struct rsi_common *common)
> +{
> +	struct rsi_hw *adapter = common->priv;
> +	struct ieee80211_hw *hw = adapter->hw;
> +	u8 current_bw = common->channel_width;
> +	struct ieee80211_channel *curchan = hw->conf.chandef.chan;
> +	int status = 0;
> +
> +	if (common->band != curchan->band) {
> +		common->rf_reset = 1;
> +		common->band = curchan->band;
> +
> +		if (common->band == IEEE80211_BAND_2GHZ)
> +			common->endpoint = 0;
> +		else
> +			common->endpoint = 1;

But here it's 1 for 5GHz?  Is that intended or should both these cases
be 2 for 5GHz?  In fact, I don't think you need to set common->endpoint
here, because it just gets overwritten by:

> +		status = rsi_program_bb_rf(common);

which might be why this didn't show up in testing.

Dan

> +		if (status)
> +			return status;
> +	}
> +
> +	if ((hw->conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT) ||
> +	    (hw->conf.chandef.width == NL80211_CHAN_WIDTH_20))
> +		common->channel_width = BW_20MHZ;
> +	else
> +		common->channel_width = BW_40MHZ;
> +
> +	if (current_bw != common->channel_width) {
> +		common->rf_reset = 1;
> +		status = rsi_load_bootup_params(common);
> +		if (status)
> +			return status;
> +
> +		status = rsi_load_radio_caps(common);
> +		if (status)
> +			return status;
> +	}
> +
> +	return status;
> +}
> +
> +/**
>   * rsi_set_channel() - This function programs the channel.
>   * @common: Pointer to the driver private structure.
>   * @channel: Channel value to be set.
> diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
> index 225215a..5470d01 100644
> --- a/drivers/net/wireless/rsi/rsi_mgmt.h
> +++ b/drivers/net/wireless/rsi/rsi_mgmt.h
> @@ -283,4 +283,5 @@ void rsi_core_qos_processor(struct rsi_common *common);
>  void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb);
>  int rsi_send_mgmt_pkt(struct rsi_common *common, struct sk_buff *skb);
>  int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb);
> +int rsi_band_check(struct rsi_common *common);
>  #endif



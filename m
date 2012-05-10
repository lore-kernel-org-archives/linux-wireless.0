Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57967 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2EJKe4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 06:34:56 -0400
Message-ID: <4FAB99CA.7040007@qca.qualcomm.com> (sfid-20120510_123500_162518_F5620289)
Date: Thu, 10 May 2012 13:34:50 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Add support for setting tx rateset.
References: <1336643884-5947-1-git-send-email-bkamatch@qca.qualcomm.com>
In-Reply-To: <1336643884-5947-1-git-send-email-bkamatch@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2012 12:58 PM, Bala Shanmugam wrote:
> Tx legacy and mcs rateset can configured using iw for
> 2.4 and 5 bands.  Add support for the same in driver.
> 
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>

> +static int ath6kl_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
> +				      struct net_device *dev,
> +				      const u8 *addr,
> +				      const struct cfg80211_bitrate_mask *mask)
> +{

Open parenthesis indentation is wrong in multiple places. But I can fix
those when I commit.

> +	struct ath6kl *ar = ath6kl_priv(dev);
> +	struct ath6kl_vif *vif = netdev_priv(dev);
> +	int ret;
> +
> +	ret = ath6kl_wmi_set_bitrate_mask(ar->wmi, vif->fw_vif_idx,
> +				mask);
> +
> +	return ret;

You don't need ret for anything here and can remove that.

> +	if (ar->hw.bitrate == ATH6KL_32BIT_BITRATES) {
> +		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
> +		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[0] = 0xff;
> +	} else if (ar->hw.bitrate == ATH6KL_64BIT_BITRATES) {
> +		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
> +		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[0] = 0xff;
> +		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[1] = 0xff;
> +		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[1] = 0xff;
> +	}

What if hw.bitrate is something else?

> +enum ath6kl_bitrate {
> +	ATH6KL_32BIT_BITRATES,
> +	ATH6KL_64BIT_BITRATES,
> +};
> +
>  struct ath6kl {
>  	struct device *dev;
>  	struct wiphy *wiphy;
> @@ -686,6 +691,7 @@ struct ath6kl {
>  		u32 uarttx_pin;
>  		u32 testscript_addr;
>  		enum wmi_phy_cap cap;
> +		enum ath6kl_bitrate bitrate;

I'm not sure if having an enum for the bitrates is a good idea. I doubt
that we will have anymore than two options for this.

You could add a general "flags" variable instead and 64 bit rate as the
first flag. Most likely we will have more flags in the future. If the
flag is not set, ath6kl will use 32 bit rate variables.

> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> @@ -2599,6 +2599,120 @@ static void ath6kl_wmi_relinquish_implicit_pstream_credits(struct wmi *wmi)
>  	spin_unlock_bh(&wmi->lock);
>  }
>  
> +static int ath6kl_set_bitrate_mask64(struct wmi *wmi, u8 if_idx,
> +		       const struct cfg80211_bitrate_mask *mask)
> +{
> +	u64 *cmd;
> +	struct sk_buff *skb;
> +	int ret, mode, band;
> +	u64 ratemask[IEEE80211_NUM_BANDS];
> +	u64 mcsrate;

You can merge lines:

u64 *cmd, mcsrate, ratemask[IEEE80211_NUM_BANDS];

> +
> +	memset(&ratemask, 0, sizeof(ratemask));
> +	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
> +		/* copy legacy rate mask */
> +		ratemask[band] = mask->control[band].legacy;
> +		if  (band == IEEE80211_BAND_5GHZ)

Extra space after if.

> +			ratemask[band] =
> +				mask->control[band].legacy << 4;
> +
> +		/* copy mcs rate mask */
> +		mcsrate = mask->control[band].mcs[1];
> +		mcsrate <<= 8;
> +		mcsrate |= mask->control[band].mcs[0];
> +		ratemask[band] |= mcsrate << 12;
> +		ratemask[band] |= mcsrate << 28;
> +	}
> +
> +	ath6kl_dbg(ATH6KL_DBG_WMI,
> +			"Ratemask 64 bit: 2.4:%llx 5:%llx\n",
> +			ratemask[0], ratemask[1]);
> +
> +	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd) * WMI_MODE_MAX);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	cmd = (u64 *) skb->data;

No endian support?

Most likely easiest to do that is to first write all the values to a
temporary variable and in the end, before calling ath6kl_wmi_cmd_send(),
do the endian conversion.

> +static int ath6kl_set_bitrate_mask32(struct wmi *wmi, u8 if_idx,
> +		       const struct cfg80211_bitrate_mask *mask)
> +{
> +	u32 *cmd;
> +	struct sk_buff *skb;
> +	int ret, mode, band;
> +	u32 ratemask[IEEE80211_NUM_BANDS];
> +	u32 mcsrate;

You can merge all the u32 declarations.

> +	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd) * WMI_MODE_MAX);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	cmd = (u32 *) skb->data;

Endian support?

> +int ath6kl_wmi_set_bitrate_mask(struct wmi *wmi, u8 if_idx,
> +		       const struct cfg80211_bitrate_mask *mask)
> +{
> +	struct ath6kl *ar = wmi->parent_dev;
> +	int ret = -EINVAL;
> +
> +	if (ar->hw.bitrate == ATH6KL_32BIT_BITRATES)
> +		ret = ath6kl_set_bitrate_mask32(wmi, if_idx, mask);
> +	else if (ar->hw.bitrate == ATH6KL_64BIT_BITRATES)
> +		ret = ath6kl_set_bitrate_mask64(wmi, if_idx, mask);
> +
> +	return ret;
> +}

You don't use ret for anything here and it can be removed.

> +/*
> + * Ratemask for below modes should be passed
> + * to WMI_SET_TX_SELECT_RATES_CMDID.
> + * AR6003 has 32 bit mask for each modes.
> + * First 12 bits for legacy rates, 13 to 20
> + * bits for HT 20 rates and 21 to 28 bits for
> + * HT 40 rates
> + */
> +enum wmi_mode_phy {
> +	WMI_MODE_11A = 0,
> +	WMI_MODE_11G,
> +	WMI_MODE_11B,
> +	WMI_MODE_11GONLY,
> +	WMI_MODE_11A_HT20,
> +	WMI_MODE_11G_HT20,
> +	WMI_MODE_11A_HT40,
> +	WMI_MODE_11G_HT40,
> +	WMI_MODE_MAX
> +};

As we have similar values already before, it's good to add RATES
somewhere here. For example:

enum wmi_rates_mode_phy
WMI_RATES_MODE_11A

Kalle

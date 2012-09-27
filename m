Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52678 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2I0Pxm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 11:53:42 -0400
Message-ID: <5064767F.8050701@qca.qualcomm.com> (sfid-20120927_175344_957120_EF88B002)
Date: Thu, 27 Sep 2012 21:23:35 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Antonio Quartulli <ordex@autistici.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC 1/2] ath9k_htc: Advertize allowed vif combinations
References: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 27 September 2012 09:22 PM, Mohammed Shafi Shajakhan wrote:
> From: Antonio Quartulli <ordex@autistici.org>
>
> Advertize allowed VIFs combinations to the cfg80211 sublayer.
> Other than that, practical tests shown that ath9k_htc devices allow an
> IBSS VIF to coexist with VIF set up on other modes, so advertize
> that to. We can also further add p2p/mesh mode to be advertized
> in the combinations allowed.

Antonio tomorrow evening i will just do a sanity test and send these
stuff as patch. thank you so much for your patience!

>
> Signed-off-by: Antonio Quartulli <ordex@autistici.org>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath9k/htc_drv_init.c |   35 +++++++++++++++++++++++++
>   1 files changed, 35 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> index d98255e..4d65af1 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> @@ -694,6 +694,38 @@ err_hw:
>   	return ret;
>   }
>
> +/*
> + * It is possible to have atmost ATH9K_HTC_MAX_BCN_VIF beaconing interfaces
> + * therefore either we have 1 IBSS + ATH9K_HTC_MAX_BCN_VIF - 1 AP's, or we
> + * have only ATH9K_HTC_MAX_BCN_VIF AP's
> + */
> +
> +static const struct ieee80211_iface_limit if_limits_ibss[] = {
> +	{.max = ATH9K_HTC_MAX_VIF, .types = BIT(NL80211_IFTYPE_STATION)},
> +	{.max = ATH9K_HTC_MAX_VIF - 1, .types = BIT(NL80211_IFTYPE_AP)},
> +	{.max = 1, .types = BIT(NL80211_IFTYPE_ADHOC)},
> +};
> +
> +static const struct ieee80211_iface_limit if_limits_no_ibss[] = {
> +	{.max = ATH9K_HTC_MAX_VIF, .types = BIT(NL80211_IFTYPE_STATION)},
> +	{.max = ATH9K_HTC_MAX_VIF, .types = BIT(NL80211_IFTYPE_AP)},
> +};
> +
> +static const struct ieee80211_iface_combination if_comb[] = {
> +	{.limits = if_limits_ibss,
> +	 .n_limits = ARRAY_SIZE(if_limits_ibss),
> +	 .max_interfaces = ATH9K_HTC_MAX_VIF,
> +	 .num_different_channels = 1,
> +	 .beacon_int_infra_match = true,
> +	},
> +	{.limits = if_limits_no_ibss,
> +	 .n_limits = ARRAY_SIZE(if_limits_no_ibss),
> +	 .max_interfaces = ATH9K_HTC_MAX_VIF,
> +	 .num_different_channels = 1,
> +	 .beacon_int_infra_match = true,
> +	},
> +};
> +
>   static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
>   			       struct ieee80211_hw *hw)
>   {
> @@ -716,6 +748,9 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
>   		BIT(NL80211_IFTYPE_P2P_GO) |
>   		BIT(NL80211_IFTYPE_P2P_CLIENT);
>
> +	hw->wiphy->iface_combinations = if_comb;
> +	hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
> +
>   	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
>
>   	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN |
>


-- 
thanks,
shafi



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3235 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab3KFJyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 04:54:37 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Michal Kazior" <michal.kazior@tieto.com>
Subject: Re: [PATCH 2/3] ath10k: introduce DFS implementation
References: <1383048394-15256-1-git-send-email-marek.puzyniak@tieto.com>
	<1383048394-15256-2-git-send-email-marek.puzyniak@tieto.com>
Date: Wed, 6 Nov 2013 11:54:32 +0200
In-Reply-To: <1383048394-15256-2-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Tue, 29 Oct 2013 13:06:33 +0100")
Message-ID: <877gclua7b.fsf@kamboji.qca.qualcomm.com> (sfid-20131106_105440_983532_599914B9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> Configure interface combination for AP running on channels
> where radar detection is required. It allows only one type
> of interface - AP on DFS channel and limits number of AP
> interfaces to 8. Setup WMI channel flags accordingly to mac
> channel configuration. CAC based on additional monitor vdev
> is started if required for current channel.
>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +static const struct ieee80211_iface_limit ath10k_if_dfs_limits[] = {
> +	{
> +	.max	= 8,
> +	.types	= BIT(NL80211_IFTYPE_AP)
> +	},
> +};
> +
> +static const struct ieee80211_iface_combination ath10k_if_comb[] = {
> +	{
> +		.limits = ath10k_if_limits,
> +		.n_limits = ARRAY_SIZE(ath10k_if_limits),
> +		.max_interfaces = 8,
> +		.num_different_channels = 1,
> +		.beacon_int_infra_match = true,
> +	},
> +	{
> +		.limits = ath10k_if_dfs_limits,
> +		.n_limits = ARRAY_SIZE(ath10k_if_dfs_limits),
> +		.max_interfaces = 8,
> +		.num_different_channels = 1,
> +		.beacon_int_infra_match = true,
> +		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
> +					BIT(NL80211_CHAN_WIDTH_20) |
> +					BIT(NL80211_CHAN_WIDTH_40) |
> +					BIT(NL80211_CHAN_WIDTH_80),
> +	}
>  };
>  
>  static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
> @@ -3531,8 +3667,8 @@ int ath10k_mac_register(struct ath10k *ar)
>  	 */
>  	ar->hw->queues = 4;
>  
> -	ar->hw->wiphy->iface_combinations = &ath10k_if_comb;
> -	ar->hw->wiphy->n_iface_combinations = 1;
> +	ar->hw->wiphy->iface_combinations = ath10k_if_comb;
> +	ar->hw->wiphy->n_iface_combinations = ARRAY_SIZE(ath10k_if_comb);

If ATH10K_DFS_CERTIFIED is disabled should we still enable
radar_detect_widths? Doesn't that enable DFS even it should be disabled?

-- 
Kalle Valo

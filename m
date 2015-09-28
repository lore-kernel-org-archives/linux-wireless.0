Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53064 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933540AbbI1R1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 13:27:50 -0400
Message-ID: <56097882.4090004@codeaurora.org> (sfid-20150928_192753_971365_F0B449B1)
Date: Mon, 28 Sep 2015 10:27:30 -0700
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
CC: ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: only advertise mesh support in raw mode
References: <1443445192-30464-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1443445192-30464-1-git-send-email-me@bobcopeland.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 09/28/2015 05:59 AM, Bob Copeland wrote:
> Rather than always advertising mesh support and then generating
> an error when the user attempts to bring up the device without
> rawmode, only advertise it when available: that is, if the module
> is loaded with rawmode=1, the firmware supports it, and the
> device/firmware supports an AP virtual interface internally.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> Actually, I think this is perhaps worse than just spitting out an
> error on interface up, but I'm sending anyway because it was requested
> a couple of times in review.
>
> The reason this is so ugly is that the structures in question are
> defined const in the API; when also declared const in the driver,
> they go into the .rodata section and the interface limit types
> cannot be changed without causing a fault.  So this patch removes
> const in a bunch of places and adds casts to const where required.
>
> Another approach might be changing cfg80211 to silently remove interface
> types from advertised combinations when the given mode is not also
> in interface_modes, instead of warning and failing registration as it
> does today.  But this would make errors here harder to spot.
>
> Or we can keep it the way it is with the driver failing and showing an
> error on add interface.  I'm okay with any of these approaches really.
I prefer the current design to this new approach because drivers already 
know if it's mesh capable or not at build time, hence adding runtime 
configuration is redundant.
One more thing we have to think about is enabling mesh in only raw mode.
In standard view point, mesh is only available in raw mode on ath10k, 
however ath10k is also able to run mesh in native WiFi mode in current 
mac80211 design since mac80211 handles packets per interface. So that 
mac80211 knows that packets are for mesh without looking at mesh control 
present bit when they come into mesh interface.
Because of the reason allowing mesh in raw mode on ath10k is too much 
strict in my opinion.
>   drivers/net/wireless/ath/ath10k/mac.c | 98
> ++++++++++++++++++++++-------------
>   1 file changed, 63 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
> b/drivers/net/wireless/ath/ath10k/mac.c
> index 20d002c..c689613 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4209,11 +4209,6 @@ static int ath10k_add_interface(struct ieee80211_hw
> *hw,
>   		arvif->vdev_type = WMI_VDEV_TYPE_IBSS;
>   		break;
>   	case NL80211_IFTYPE_MESH_POINT:
> -		if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
> -			ret = -EINVAL;
> -			ath10k_warn(ar, "must load driver with rawmode=1
> to add mesh interfaces\n");
> -			goto err;
> -		}
>   		arvif->vdev_type = WMI_VDEV_TYPE_AP;
>   		break;
>   	case NL80211_IFTYPE_AP:
> @@ -6755,7 +6750,7 @@ void ath10k_mac_destroy(struct ath10k *ar)
>   	ieee80211_free_hw(ar->hw);
>   }
>   
> -static const struct ieee80211_iface_limit ath10k_if_limits[] = {
> +static struct ieee80211_iface_limit ath10k_if_limits[] = {
>   	{
>   	.max	= 8,
>   	.types	= BIT(NL80211_IFTYPE_STATION)
> @@ -6772,23 +6767,17 @@ static const struct ieee80211_iface_limit
> ath10k_if_limits[] = {
>   	{
>   	.max	= 7,
>   	.types	= BIT(NL80211_IFTYPE_AP)
> -#ifdef CONFIG_MAC80211_MESH
> -		| BIT(NL80211_IFTYPE_MESH_POINT)
> -#endif
>   	},
>   };
>   
> -static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
> +static struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
>   	{
>   	.max	= 8,
>   	.types	= BIT(NL80211_IFTYPE_AP)
> -#ifdef CONFIG_MAC80211_MESH
> -		| BIT(NL80211_IFTYPE_MESH_POINT)
> -#endif
>   	},
>   };
>   
> -static const struct ieee80211_iface_combination ath10k_if_comb[] = {
> +static struct ieee80211_iface_combination ath10k_if_comb[] = {
>   	{
>   		.limits = ath10k_if_limits,
>   		.n_limits = ARRAY_SIZE(ath10k_if_limits),
> @@ -6798,7 +6787,7 @@ static const struct ieee80211_iface_combination
> ath10k_if_comb[] = {
>   	},
>   };
>   
> -static const struct ieee80211_iface_combination ath10k_10x_if_comb[] = {
> +static struct ieee80211_iface_combination ath10k_10x_if_comb[] = {
>   	{
>   		.limits = ath10k_10x_if_limits,
>   		.n_limits = ARRAY_SIZE(ath10k_10x_if_limits),
> @@ -6814,7 +6803,7 @@ static const struct ieee80211_iface_combination
> ath10k_10x_if_comb[] = {
>   	},
>   };
>   
> -static const struct ieee80211_iface_limit ath10k_tlv_if_limit[] = {
> +static struct ieee80211_iface_limit ath10k_tlv_if_limit[] = {
>   	{
>   		.max = 2,
>   		.types = BIT(NL80211_IFTYPE_STATION),
> @@ -6822,9 +6811,6 @@ static const struct ieee80211_iface_limit
> ath10k_tlv_if_limit[] = {
>   	{
>   		.max = 2,
>   		.types = BIT(NL80211_IFTYPE_AP) |
> -#ifdef CONFIG_MAC80211_MESH
> -			 BIT(NL80211_IFTYPE_MESH_POINT) |
> -#endif
>   			 BIT(NL80211_IFTYPE_P2P_CLIENT) |
>   			 BIT(NL80211_IFTYPE_P2P_GO),
>   	},
> @@ -6834,7 +6820,7 @@ static const struct ieee80211_iface_limit
> ath10k_tlv_if_limit[] = {
>   	},
>   };
>   
> -static const struct ieee80211_iface_limit ath10k_tlv_qcs_if_limit[] = {
> +static struct ieee80211_iface_limit ath10k_tlv_qcs_if_limit[] = {
>   	{
>   		.max = 2,
>   		.types = BIT(NL80211_IFTYPE_STATION),
> @@ -6846,9 +6832,6 @@ static const struct ieee80211_iface_limit
> ath10k_tlv_qcs_if_limit[] = {
>   	{
>   		.max = 1,
>   		.types = BIT(NL80211_IFTYPE_AP) |
> -#ifdef CONFIG_MAC80211_MESH
> -			 BIT(NL80211_IFTYPE_MESH_POINT) |
> -#endif
>   			 BIT(NL80211_IFTYPE_P2P_GO),
>   	},
>   	{
> @@ -6857,7 +6840,7 @@ static const struct ieee80211_iface_limit
> ath10k_tlv_qcs_if_limit[] = {
>   	},
>   };
>   
> -static const struct ieee80211_iface_limit ath10k_tlv_if_limit_ibss[] = {
> +static struct ieee80211_iface_limit ath10k_tlv_if_limit_ibss[] = {
>   	{
>   		.max = 1,
>   		.types = BIT(NL80211_IFTYPE_STATION),
> @@ -6907,7 +6890,7 @@ static struct ieee80211_iface_combination
> ath10k_tlv_qcs_if_comb[] = {
>   	},
>   };
>   
> -static const struct ieee80211_iface_limit ath10k_10_4_if_limits[] = {
> +static struct ieee80211_iface_limit ath10k_10_4_if_limits[] = {
>   	{
>   		.max = 1,
>   		.types = BIT(NL80211_IFTYPE_STATION),
> @@ -6915,13 +6898,10 @@ static const struct ieee80211_iface_limit
> ath10k_10_4_if_limits[] = {
>   	{
>   		.max	= 16,
>   		.types	= BIT(NL80211_IFTYPE_AP)
> -#ifdef CONFIG_MAC80211_MESH
> -			| BIT(NL80211_IFTYPE_MESH_POINT)
> -#endif
>   	},
>   };
>   
> -static const struct ieee80211_iface_combination ath10k_10_4_if_comb[] = {
> +static struct ieee80211_iface_combination ath10k_10_4_if_comb[] = {
>   	{
>   		.limits = ath10k_10_4_if_limits,
>   		.n_limits = ARRAY_SIZE(ath10k_10_4_if_limits),
> @@ -6937,6 +6917,43 @@ static const struct ieee80211_iface_combination
> ath10k_10_4_if_comb[] = {
>   	},
>   };
>   
> +static
> +void ath10k_if_comb_add_mesh(struct ath10k *ar,
> +			     struct ieee80211_iface_combination *if_comb)
> +{
> +	int i;
> +
> +	for (i = 0; i < if_comb->n_limits; i++) {
> +		struct ieee80211_iface_limit *limit =
> +			(struct ieee80211_iface_limit
> *)&if_comb->limits[i];
> +
> +		/* we can support mesh if we already support AP */
> +		if (limit->types & BIT(NL80211_IFTYPE_AP)) {
> +			limit->types |= BIT(NL80211_IFTYPE_MESH_POINT);
> +			ar->hw->wiphy->interface_modes |=
> +				BIT(NL80211_IFTYPE_MESH_POINT);
> +		}
> +	}
> +}
> +
> +static void ath10k_enable_mesh(struct ath10k *ar)
> +{
> +	int i;
> +
> +	if (!config_enabled(CONFIG_MAC80211_MESH))
> +		return;
> +
> +#define ATH10K_IF_COMB_ADD_MESH(comb_array) \
> +	for (i = 0; i < ARRAY_SIZE(comb_array); i++) \
> +		ath10k_if_comb_add_mesh(ar, &comb_array[i])
> +
> +	ATH10K_IF_COMB_ADD_MESH(ath10k_if_comb);
> +	ATH10K_IF_COMB_ADD_MESH(ath10k_10x_if_comb);
> +	ATH10K_IF_COMB_ADD_MESH(ath10k_tlv_if_comb);
> +	ATH10K_IF_COMB_ADD_MESH(ath10k_tlv_qcs_if_comb);
> +	ATH10K_IF_COMB_ADD_MESH(ath10k_10_4_if_comb);
> +}
> +
>   static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k
> *ar)
>   {
>   	struct ieee80211_sta_vht_cap vht_cap = {0};
> @@ -7142,8 +7159,7 @@ int ath10k_mac_register(struct ath10k *ar)
>   
>   	ar->hw->wiphy->interface_modes =
>   		BIT(NL80211_IFTYPE_STATION) |
> -		BIT(NL80211_IFTYPE_AP) |
> -		BIT(NL80211_IFTYPE_MESH_POINT);
> +		BIT(NL80211_IFTYPE_AP);
>   
>   	ar->hw->wiphy->available_antennas_rx = ar->supp_rx_chainmask;
>   	ar->hw->wiphy->available_antennas_tx = ar->supp_tx_chainmask;
> @@ -7154,6 +7170,9 @@ int ath10k_mac_register(struct ath10k *ar)
>   			BIT(NL80211_IFTYPE_P2P_CLIENT) |
>   			BIT(NL80211_IFTYPE_P2P_GO);
>   
> +	if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
> +		ath10k_enable_mesh(ar);
> +
>   	ieee80211_hw_set(ar->hw, SIGNAL_DBM);
>   	ieee80211_hw_set(ar->hw, SUPPORTS_PS);
>   	ieee80211_hw_set(ar->hw, SUPPORTS_DYNAMIC_PS);
> @@ -7238,7 +7257,9 @@ int ath10k_mac_register(struct ath10k *ar)
>   
>   	switch (ar->wmi.op_version) {
>   	case ATH10K_FW_WMI_OP_VERSION_MAIN:
> -		ar->hw->wiphy->iface_combinations = ath10k_if_comb;
> +		ar->hw->wiphy->iface_combinations =
> +			(const struct ieee80211_iface_combination *)
> +			ath10k_if_comb;
>   		ar->hw->wiphy->n_iface_combinations =
>   			ARRAY_SIZE(ath10k_if_comb);
>   		ar->hw->wiphy->interface_modes |=
> BIT(NL80211_IFTYPE_ADHOC);
> @@ -7246,11 +7267,14 @@ int ath10k_mac_register(struct ath10k *ar)
>   	case ATH10K_FW_WMI_OP_VERSION_TLV:
>   		if (test_bit(WMI_SERVICE_ADAPTIVE_OCS, ar->wmi.svc_map)) {
>   			ar->hw->wiphy->iface_combinations =
> +				(const struct ieee80211_iface_combination
> *)
>   				ath10k_tlv_qcs_if_comb;
>   			ar->hw->wiphy->n_iface_combinations =
>   				ARRAY_SIZE(ath10k_tlv_qcs_if_comb);
>   		} else {
> -			ar->hw->wiphy->iface_combinations =
> ath10k_tlv_if_comb;
> +			ar->hw->wiphy->iface_combinations =
> +				(const struct ieee80211_iface_combination
> *)
> +				ath10k_tlv_if_comb;
>   			ar->hw->wiphy->n_iface_combinations =
>   				ARRAY_SIZE(ath10k_tlv_if_comb);
>   		}
> @@ -7259,12 +7283,16 @@ int ath10k_mac_register(struct ath10k *ar)
>   	case ATH10K_FW_WMI_OP_VERSION_10_1:
>   	case ATH10K_FW_WMI_OP_VERSION_10_2:
>   	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
> -		ar->hw->wiphy->iface_combinations = ath10k_10x_if_comb;
> +		ar->hw->wiphy->iface_combinations =
> +			(const struct ieee80211_iface_combination *)
> +			ath10k_10x_if_comb;
>   		ar->hw->wiphy->n_iface_combinations =
>   			ARRAY_SIZE(ath10k_10x_if_comb);
>   		break;
>   	case ATH10K_FW_WMI_OP_VERSION_10_4:
> -		ar->hw->wiphy->iface_combinations = ath10k_10_4_if_comb;
> +		ar->hw->wiphy->iface_combinations =
> +			(const struct ieee80211_iface_combination *)
> +			ath10k_10_4_if_comb;
>   		ar->hw->wiphy->n_iface_combinations =
>   			ARRAY_SIZE(ath10k_10_4_if_comb);
>   		break;
Thanks,
Peter

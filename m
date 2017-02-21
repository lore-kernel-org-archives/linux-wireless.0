Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:33940 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbdBUKcR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 05:32:17 -0500
Received: by mail-qt0-f171.google.com with SMTP id n21so39871807qta.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 02:32:16 -0800 (PST)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170221100957.30965-1-johannes@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com> (sfid-20170221_113220_491625_D3A414FF)
Date: Tue, 21 Feb 2017 11:32:12 +0100
MIME-Version: 1.0
In-Reply-To: <20170221100957.30965-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21-2-2017 11:09, Johannes Berg wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> Let drivers advertise support for station-mode 4-way handshake
> offloading with a new NL80211_EXT_FEATURE_4WAY_HANDSHAKE_OFFLOAD_STA
> flag.

I find use of the term OFFLOAD a bit redundant as it is implied by its
presence anyway.

> Add a new NL80211_ATTR_PMK attribute that might be passed as part
> of NL80211_CMD_CONNECT command, and contain the PSK (which is the
> PMK, hence the name.)
> 
> The driver/device is assumed to handle the 4-way handshake by
> itself in this case (including key derivations, etc.), instead
> of relying on the supplicant.
> 
> This patch is somewhat based on this one (by Vladimir Kondratiev):
> https://patchwork.kernel.org/patch/1309561/.

It also looks quite like this one we posted a while ago [1]. Our bad
that we did not follow-up :-p

Thanks,
Arend

[1] https://www.spinics.net/lists/linux-wireless/msg129387.html

> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/linux/ieee80211.h    | 1 +
>  include/net/cfg80211.h       | 2 ++
>  include/uapi/linux/nl80211.h | 9 +++++++++
>  net/wireless/nl80211.c       | 8 ++++++++
>  4 files changed, 20 insertions(+)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 6ea381c98aae..2049e983a994 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -2357,6 +2357,7 @@ enum ieee80211_sa_query_action {
>  #define WLAN_MAX_KEY_LEN		32
>  
>  #define WLAN_PMKID_LEN			16
> +#define WLAN_PMK_LEN			32
>  
>  #define WLAN_OUI_WFA			0x506f9a
>  #define WLAN_OUI_TYPE_WFA_P2P		9
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 86c12f85fb53..4ca968927d60 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -643,6 +643,7 @@ struct survey_info {
>   * @wep_keys: static WEP keys, if not NULL points to an array of
>   *	CFG80211_MAX_WEP_KEYS WEP keys
>   * @wep_tx_key: key index (0..3) of the default TX static WEP key
> + * @psk: PSK (for devices supporting 4-way-handshake offload)
>   */
>  struct cfg80211_crypto_settings {
>  	u32 wpa_versions;
> @@ -656,6 +657,7 @@ struct cfg80211_crypto_settings {
>  	bool control_port_no_encrypt;
>  	struct key_params *wep_keys;
>  	int wep_tx_key;
> +	const u8 *psk;
>  };
>  
>  /**
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 9a499b15cfbc..ba102c937750 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -2012,6 +2012,9 @@ enum nl80211_commands {
>   *	u32 attribute with an &enum nl80211_timeout_reason value. This is used,
>   *	e.g., with %NL80211_CMD_CONNECT event.
>   *
> + * @NL80211_ATTR_PMK: PSK for offloaded 4-Way Handshake. Relevant only
> + *	with %NL80211_CMD_CONNECT (for WPA/WPA2-PSK networks).
> + *
>   * @NUM_NL80211_ATTR: total number of nl80211_attrs available
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
> @@ -2423,6 +2426,8 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_TIMEOUT_REASON,
>  
> +	NL80211_ATTR_PMK,
> +
>  	/* add attributes here, update the policy in nl80211.c */
>  
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -4759,6 +4764,9 @@ enum nl80211_feature_flags {
>   * @NL80211_EXT_FEATURE_CQM_RSSI_LIST: With this driver the
>   *	%NL80211_ATTR_CQM_RSSI_THOLD attribute accepts a list of zero or more
>   *	RSSI threshold values to monitor rather than exactly one threshold.
> + * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_OFFLOAD_STA: Device supports
> + *	doing 4-way handshake in station mode (PSK is passed as part
> + *	of the connect command).
>   *
>   * @NUM_NL80211_EXT_FEATURES: number of extended features.
>   * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
> @@ -4778,6 +4786,7 @@ enum nl80211_ext_feature_index {
>  	NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA_CONNECTED,
>  	NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI,
>  	NL80211_EXT_FEATURE_CQM_RSSI_LIST,
> +	NL80211_EXT_FEATURE_4WAY_HANDSHAKE_OFFLOAD_STA,
>  
>  	/* add new features before the definition below */
>  	NUM_NL80211_EXT_FEATURES,
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index d516527fcb8e..34b551edbc4f 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -410,6 +410,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
>  		.len = sizeof(struct nl80211_bss_select_rssi_adjust)
>  	},
>  	[NL80211_ATTR_TIMEOUT_REASON] = { .type = NLA_U32 },
> +	[NL80211_ATTR_PMK] = { .len = WLAN_PMK_LEN },
>  };
>  
>  /* policy for the key attributes */
> @@ -8039,6 +8040,13 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
>  		memcpy(settings->akm_suites, data, len);
>  	}
>  
> +	if (info->attrs[NL80211_ATTR_PMK]) {
> +		if (!wiphy_ext_feature_isset(&rdev->wiphy,
> +					     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_OFFLOAD_STA))
> +			return -EINVAL;
> +		settings->psk = nla_data(info->attrs[NL80211_ATTR_PMK]);
> +	}
> +
>  	return 0;
>  }
>  
> 

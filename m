Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35417 "EHLO
        mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753698AbcI0LYo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 07:24:44 -0400
Received: by mail-pa0-f41.google.com with SMTP id oz2so4788690pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2016 04:24:44 -0700 (PDT)
Subject: Re: [PATCH] nl80211: add key management offload feature
To: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
References: <1474973796-1873-1-git-send-email-akarwar@marvell.com>
 <1474973796-1873-2-git-send-email-akarwar@marvell.com>
Cc: yangzy@marvell.com, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        lihz <lihz@marvell.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <df801822-f23d-e7e3-15c2-1849370fd01f@broadcom.com> (sfid-20160927_132448_932088_4F70258F)
Date: Tue, 27 Sep 2016 13:24:24 +0200
MIME-Version: 1.0
In-Reply-To: <1474973796-1873-2-git-send-email-akarwar@marvell.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-9-2016 12:56, Amitkumar Karwar wrote:
> From: lihz <lihz@marvell.com>

minor thing. Could you use another prefix iso 'nl80211:'. That has
different expectation for me at least, ie. changes in nl80211 api, but
this patch is for hostap repo so 'hostap:' or 'wpa_supp:' would be
better fit here.

Regards,
Arend

> Currently this feature is available under CONFIG_DRIVER_NL80211_QCA
> flag. It makes use of vendor command approach.
> 
> This patch along with a kernel patch is an attempt to make the
> feature generic. psk is downloaded through standard set_key path
> There is an extra handling in ROAM event from driver.
> 
> Signed-off-by: Huazeng Li <lihz@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
>  src/common/defs.h                  |  4 +++-
>  src/common/ieee802_11_defs.h       |  3 +++
>  src/drivers/driver_nl80211.c       | 40 +++++++++++++++++++++++++++++---------
>  src/drivers/driver_nl80211_capa.c  |  4 ++++
>  src/drivers/driver_nl80211_event.c | 17 ++++------------
>  src/drivers/nl80211_copy.h         |  8 ++++++++
>  src/rsn_supp/wpa_ft.c              |  4 ++++
>  7 files changed, 57 insertions(+), 23 deletions(-)
> 
> diff --git a/src/common/defs.h b/src/common/defs.h
> index 4f56794..e9e9692 100644
> --- a/src/common/defs.h
> +++ b/src/common/defs.h
> @@ -148,7 +148,9 @@ enum wpa_alg {
>  	WPA_ALG_CCMP_256,
>  	WPA_ALG_BIP_GMAC_128,
>  	WPA_ALG_BIP_GMAC_256,
> -	WPA_ALG_BIP_CMAC_256
> +	WPA_ALG_BIP_CMAC_256,
> +	WPA_ALG_PMK_R0,
> +	WPA_ALG_PMK_R0_NAME,
>  };
>  
>  /**
> diff --git a/src/common/ieee802_11_defs.h b/src/common/ieee802_11_defs.h
> index 02d2ad7..632374a 100644
> --- a/src/common/ieee802_11_defs.h
> +++ b/src/common/ieee802_11_defs.h
> @@ -1376,6 +1376,9 @@ enum plink_action_field {
>  #define WLAN_CIPHER_SUITE_BIP_CMAC_256	0x000FAC0D
>  
>  #define WLAN_CIPHER_SUITE_SMS4		0x00147201
> +#define WLAN_CIPHER_SUITE_PMK		0x00147202
> +#define WLAN_CIPHER_SUITE_PMK_R0	0x00147203
> +#define WLAN_CIPHER_SUITE_PMK_R0_NAME	0x00147204
>  
>  #define WLAN_CIPHER_SUITE_CKIP		0x00409600
>  #define WLAN_CIPHER_SUITE_CKIP_CMIC	0x00409601
> diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
> index 1210d43..7024b8a 100644
> --- a/src/drivers/driver_nl80211.c
> +++ b/src/drivers/driver_nl80211.c
> @@ -2675,21 +2675,34 @@ static int wpa_driver_nl80211_set_key(const char *ifname, struct i802_bss *bss,
>  	}
>  #endif /* CONFIG_TDLS */
>  
> -#ifdef CONFIG_DRIVER_NL80211_QCA
> -	if (alg == WPA_ALG_PMK &&
> -	    (drv->capa.flags & WPA_DRIVER_FLAGS_KEY_MGMT_OFFLOAD)) {
> -		wpa_printf(MSG_DEBUG, "%s: calling issue_key_mgmt_set_key",
> -			   __func__);
> -		ret = issue_key_mgmt_set_key(drv, key, key_len);
> -		return ret;
> +
> +	if ((alg == WPA_ALG_PMK || alg == WPA_ALG_PMK_R0 ||
> +	     alg == WPA_ALG_PMK_R0_NAME) &&
> +	     (drv->capa.flags & WPA_DRIVER_FLAGS_KEY_MGMT_OFFLOAD)) {
> +		u32 suite;
> +
> +		if (alg == WPA_ALG_PMK_R0)
> +			suite = WLAN_CIPHER_SUITE_PMK_R0;
> +		else if (alg == WPA_ALG_PMK_R0_NAME)
> +			suite = WLAN_CIPHER_SUITE_PMK_R0_NAME;
> +		else if (alg == WPA_ALG_PMK)
> +			suite = WLAN_CIPHER_SUITE_PMK;
> +		if (!suite)
> +			goto fail;
> +		msg = nl80211_ifindex_msg(drv, ifindex, 0, NL80211_CMD_NEW_KEY);
> +		if (!msg ||
> +		    nla_put(msg, NL80211_ATTR_KEY_DATA, key_len, key) ||
> +		    nla_put_u32(msg, NL80211_ATTR_KEY_CIPHER, suite))
> +			goto fail;
> +		wpa_hexdump_key(MSG_DEBUG, "nl80211: KEY_DATA", key, key_len);
>  	}
> -#endif /* CONFIG_DRIVER_NL80211_QCA */
>  
>  	if (alg == WPA_ALG_NONE) {
>  		msg = nl80211_ifindex_msg(drv, ifindex, 0, NL80211_CMD_DEL_KEY);
>  		if (!msg)
>  			return -ENOBUFS;
> -	} else {
> +	} else if (alg != WPA_ALG_PMK && alg != WPA_ALG_PMK_R0 &&
> +		   alg != WPA_ALG_PMK_R0_NAME) {
>  		u32 suite;
>  
>  		suite = wpa_alg_to_cipher_suite(alg, key_len);
> @@ -5137,6 +5150,15 @@ static int wpa_driver_nl80211_associate(
>  
>  		if (wpa_driver_nl80211_set_mode(priv, nlmode) < 0)
>  			return -1;
> +		if (params->req_key_mgmt_offload && params->psk &&
> +		    (params->key_mgmt_suite == WPA_KEY_MGMT_PSK ||
> +		     params->key_mgmt_suite == WPA_KEY_MGMT_PSK_SHA256 ||
> +		     params->key_mgmt_suite == WPA_KEY_MGMT_FT_PSK)) {
> +			wpa_driver_nl80211_set_key(bss->ifname, bss,
> +						   WPA_ALG_PMK,
> +						   NULL, 0, 1, NULL, 0,
> +						   params->psk, 32);
> +		}
>  		return wpa_driver_nl80211_connect(drv, params);
>  	}
>  
> diff --git a/src/drivers/driver_nl80211_capa.c b/src/drivers/driver_nl80211_capa.c
> index 6adc3f6..26bd7bd 100644
> --- a/src/drivers/driver_nl80211_capa.c
> +++ b/src/drivers/driver_nl80211_capa.c
> @@ -362,6 +362,10 @@ static void wiphy_info_ext_feature_flags(struct wiphy_info_data *info,
>  
>  	if (ext_feature_isset(ext_features, len, NL80211_EXT_FEATURE_RRM))
>  		capa->rrm_flags |= WPA_DRIVER_FLAGS_SUPPORT_RRM;
> +
> +	if (ext_feature_isset(nla_data(tb), nla_len(tb),
> +			      NL80211_EXT_FEATURE_KEY_MGMT_OFFLOAD))
> +		capa->flags |= WPA_DRIVER_FLAGS_KEY_MGMT_OFFLOAD;
>  }
>  
>  
> diff --git a/src/drivers/driver_nl80211_event.c b/src/drivers/driver_nl80211_event.c
> index 762e3ac..ae11c2b 100644
> --- a/src/drivers/driver_nl80211_event.c
> +++ b/src/drivers/driver_nl80211_event.c
> @@ -2065,18 +2065,6 @@ static void do_process_drv_event(struct i802_bss *bss, int cmd,
>  	wpa_printf(MSG_DEBUG, "nl80211: Drv Event %d (%s) received for %s",
>  		   cmd, nl80211_command_to_string(cmd), bss->ifname);
>  
> -	if (cmd == NL80211_CMD_ROAM &&
> -	    (drv->capa.flags & WPA_DRIVER_FLAGS_KEY_MGMT_OFFLOAD)) {
> -		/*
> -		 * Device will use roam+auth vendor event to indicate
> -		 * roaming, so ignore the regular roam event.
> -		 */
> -		wpa_printf(MSG_DEBUG,
> -			   "nl80211: Ignore roam event (cmd=%d), device will use vendor event roam+auth",
> -			   cmd);
> -		return;
> -	}
> -
>  	if (drv->ap_scan_as_station != NL80211_IFTYPE_UNSPECIFIED &&
>  	    (cmd == NL80211_CMD_NEW_SCAN_RESULTS ||
>  	     cmd == NL80211_CMD_SCAN_ABORTED)) {
> @@ -2168,7 +2156,10 @@ static void do_process_drv_event(struct i802_bss *bss, int cmd,
>  				   tb[NL80211_ATTR_REQ_IE],
>  				   tb[NL80211_ATTR_RESP_IE],
>  				   tb[NL80211_ATTR_TIMED_OUT],
> -				   NULL, NULL, NULL, NULL, NULL);
> +				   tb[NL80211_ATTR_AUTHORIZED],
> +				   tb[NL80211_KEY_REPLAY_CTR],
> +				   tb[NL80211_KEY_KCK],
> +				   tb[NL80211_KEY_KEK]);
>  		break;
>  	case NL80211_CMD_CH_SWITCH_NOTIFY:
>  		mlme_event_ch_switch(drv,
> diff --git a/src/drivers/nl80211_copy.h b/src/drivers/nl80211_copy.h
> index 2206941..1068ea4 100644
> --- a/src/drivers/nl80211_copy.h
> +++ b/src/drivers/nl80211_copy.h
> @@ -2261,6 +2261,8 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_MESH_PEER_AID,
>  
> +	NL80211_ATTR_AUTHORIZED,
> +
>  	/* add attributes here, update the policy in nl80211.c */
>  
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -3681,6 +3683,9 @@ enum nl80211_key_attributes {
>  	NL80211_KEY_DEFAULT_MGMT,
>  	NL80211_KEY_TYPE,
>  	NL80211_KEY_DEFAULT_TYPES,
> +	NL80211_KEY_REPLAY_CTR,
> +	NL80211_KEY_KCK,
> +	NL80211_KEY_KEK,
>  
>  	/* keep last */
>  	__NL80211_KEY_AFTER_LAST,
> @@ -4551,6 +4556,8 @@ enum nl80211_feature_flags {
>   *	(if available).
>   * @NL80211_EXT_FEATURE_SET_SCAN_DWELL: This driver supports configuration of
>   *	channel dwell time.
> + * @NL80211_EXT_FEATURE_KEY_MGMT_OFFLOAD: This driver supports key management
> + *	offload.
>   *
>   * @NUM_NL80211_EXT_FEATURES: number of extended features.
>   * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
> @@ -4562,6 +4569,7 @@ enum nl80211_ext_feature_index {
>  	NL80211_EXT_FEATURE_SCAN_START_TIME,
>  	NL80211_EXT_FEATURE_BSS_PARENT_TSF,
>  	NL80211_EXT_FEATURE_SET_SCAN_DWELL,
> +	NL80211_EXT_FEATURE_KEY_MGMT_OFFLOAD,
>  
>  	/* add new features before the definition below */
>  	NUM_NL80211_EXT_FEATURES,
> diff --git a/src/rsn_supp/wpa_ft.c b/src/rsn_supp/wpa_ft.c
> index 205793e..7729d32 100644
> --- a/src/rsn_supp/wpa_ft.c
> +++ b/src/rsn_supp/wpa_ft.c
> @@ -37,6 +37,10 @@ int wpa_derive_ptk_ft(struct wpa_sm *sm, const unsigned char *src_addr,
>  	wpa_hexdump_key(MSG_DEBUG, "FT: PMK-R0", sm->pmk_r0, PMK_LEN);
>  	wpa_hexdump(MSG_DEBUG, "FT: PMKR0Name",
>  		    sm->pmk_r0_name, WPA_PMK_NAME_LEN);
> +	wpa_sm_set_key(sm, WPA_ALG_PMK_R0, NULL, 0, 1, NULL,
> +		       0, sm->pmk_r0, PMK_LEN);
> +	wpa_sm_set_key(sm, WPA_ALG_PMK_R0_NAME, NULL, 0, 1, NULL,
> +		       0, sm->pmk_r0_name, WPA_PMK_NAME_LEN);
>  	wpa_derive_pmk_r1(sm->pmk_r0, sm->pmk_r0_name, sm->r1kh_id,
>  			  sm->own_addr, sm->pmk_r1, sm->pmk_r1_name);
>  	wpa_hexdump_key(MSG_DEBUG, "FT: PMK-R1", sm->pmk_r1, PMK_LEN);
> 

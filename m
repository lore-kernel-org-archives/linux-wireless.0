Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47991 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaCUPKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 11:10:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: update regulatory domain settings for 10.x firmware
References: <1394797261-9219-1-git-send-email-marek.puzyniak@tieto.com>
Date: Fri, 21 Mar 2014 17:10:42 +0200
In-Reply-To: <1394797261-9219-1-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Fri, 14 Mar 2014 12:41:01 +0100")
Message-ID: <878us3bn9p.fsf@kamboji.qca.qualcomm.com> (sfid-20140321_161052_517787_8F6F6D05)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> Regulatory domain settings for firmware 10.x has more options
> than main firmware, so handle regulatory domain setup separately
> for both supported firmwares. Fill in additional dfs domain
> parameter according to current regulatory.
> This patch does not solve any known bug. Not handled parameter
> for firmware 10.x was found during code review.
>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>

[...]

> @@ -1730,6 +1730,8 @@ static void ath10k_regd_update(struct ath10k *ar)
>  {
>  	struct reg_dmn_pair_mapping *regpair;
>  	int ret;
> +	enum wmi_dfs_region wmi_dfs_reg = WMI_UNINIT_DFS_DOMAIN;
> +	enum nl80211_dfs_regions nl_dfs_reg;
>  
>  	lockdep_assert_held(&ar->conf_mutex);
>  
> @@ -1739,6 +1741,11 @@ static void ath10k_regd_update(struct ath10k *ar)
>  
>  	regpair = ar->ath_common.regulatory.regpair;
>  
> +	if (config_enabled(CONFIG_ATH10K_DFS_CERTIFIED) && ar->dfs_detector) {
> +		nl_dfs_reg = ar->dfs_detector->region;
> +		wmi_dfs_reg = ath10k_wmi_dfs_region_from_nl80211(nl_dfs_reg);
> +	}

I added else branch here, that way can avoid variable initialisation in
the beginning of the function.

> +enum wmi_dfs_region
> +ath10k_wmi_dfs_region_from_nl80211(enum nl80211_dfs_regions dfs_region)
> +{
> +	switch (dfs_region) {
> +	case NL80211_DFS_UNSET:
> +		return WMI_UNINIT_DFS_DOMAIN;
> +	case NL80211_DFS_FCC:
> +		return WMI_FCC_DFS_DOMAIN;
> +	case NL80211_DFS_ETSI:
> +		return WMI_ETSI_DFS_DOMAIN;
> +	case NL80211_DFS_JP:
> +		return WMI_MKK4_DFS_DOMAIN;
> +	}
> +	return WMI_UNINIT_DFS_DOMAIN;
> +}

I don't see why this should be in wmi.c so I moved it to mac.c.

> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -2185,6 +2185,27 @@ struct wmi_pdev_set_regdomain_cmd {
>  	__le32 conformance_test_limit_5G;
>  } __packed;
>  
> +enum wmi_dfs_region {
> +	/* Uninitialized dfs domain */
> +	WMI_UNINIT_DFS_DOMAIN = 0,
> +	/* FCC3 dfs domain */
> +	WMI_FCC_DFS_DOMAIN = 1,
> +	/* ETSI dfs domain */
> +	WMI_ETSI_DFS_DOMAIN = 2,
> +	/*Japan dfs domain */
> +	WMI_MKK4_DFS_DOMAIN = 3,
> +};
> +
> +struct wmi_pdev_set_regdomain_cmd_10x {
> +	__le32 reg_domain;
> +	__le32 reg_domain_2G;
> +	__le32 reg_domain_5G;
> +	__le32 conformance_test_limit_2G;
> +	__le32 conformance_test_limit_5G;
> +	/* dfs domain from wmi_dfs_region */
> +	__le32 dfs_domain;
> +} __packed;

I added few newlines to these structs.

> @@ -4214,8 +4235,11 @@ int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
>  				const struct wmi_channel_arg *);
>  int ath10k_wmi_pdev_suspend_target(struct ath10k *ar, u32 suspend_opt);
>  int ath10k_wmi_pdev_resume_target(struct ath10k *ar);
> +enum wmi_dfs_region
> +ath10k_wmi_dfs_region_from_nl80211(enum nl80211_dfs_regions dfs_region);

And removed this as the function can be static now.

The modified patch is here, please check my changes:

https://github.com/kvalo/ath/commit/99e45d3191515238d3924704e9203752f47e66d3

-- 
Kalle Valo

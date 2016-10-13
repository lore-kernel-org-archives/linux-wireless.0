Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50339 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754804AbcJMLrH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 07:47:07 -0400
Message-ID: <1476359179.4904.16.camel@sipsolutions.net> (sfid-20161013_134846_406418_5DF3578B)
Subject: Re: [PATCH v10] cfg80211: Provision to allow the support for
 different beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        usdutt@qti.qualcomm.com, amarnath@qca.qualcomm.com
Date: Thu, 13 Oct 2016 13:46:19 +0200
In-Reply-To: <1476277011-6937-1-git-send-email-pkushwah@qti.qualcomm.com>
References: <1476277011-6937-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -421,6 +421,8 @@ static int brcmf_vif_change_validate(struct
> brcmf_cfg80211_info *cfg,
>  		.num_different_channels = 1,
>  		.radar_detect = 0,
>  		.iftype_num = {0},
> +		.beacon_gcd = 0,
> +		.diff_bi = false,
>  	};
>  
>  	list_for_each_entry(pos, &cfg->vif_list, list)
> @@ -446,6 +448,8 @@ static int brcmf_vif_add_validate(struct
> brcmf_cfg80211_info *cfg,
>  		.num_different_channels = 1,
>  		.radar_detect = 0,
>  		.iftype_num = {0},
> +		.beacon_gcd = 0,
> +		.diff_bi = false,
>  	};

You don't need this now, since the default is 0/false, so we don't have
to touch this file. I already removed some of the other useless
initializers in the previous patch, and will edit this out as well - no
need to resend.
 
>  	list_for_each_entry(pos, &cfg->vif_list, list)
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 21bbe44..f0bcd55 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -784,11 +784,15 @@ struct cfg80211_csa_settings {
>   * @iftype_num: array with the numbers of interfaces of each
> interface
>   *	type.  The index is the interface type as specified in
> &enum
>   *	nl80211_iftype.
> + * @beacon_gcd: a value specifying GCD of all beaconing interfaces.
> + * @diff_bi: a flag which denotes beacon intervals are different or
> same.

I think I'll rename both to beacon_* or *_bi, but I don't really like
the difference in naming here.

>   */
>  struct iface_combination_params {
>  	int num_different_channels;
>  	u8 radar_detect;
>  	int iftype_num[NUM_NL80211_IFTYPES];
> +	u32 beacon_gcd;
> +	bool diff_bi;
>  };
>  
>  /**
> @@ -3100,6 +3104,12 @@ struct ieee80211_iface_limit {
>   *	only in special cases.
>   * @radar_detect_widths: bitmap of channel widths supported for
> radar detection
>   * @radar_detect_regions: bitmap of regions supported for radar
> detection
> + * @beacon_int_min_gcd: This interface combination supports
> different
> + *	beacon intervals.
> + *	= 0 - all beacon intervals for different interface must be
> same.
> + *	> 0 - any beacon interval for the interface part of this
> combination AND
> + *	      *GCD* of all beacon intervals from beaconing
> interfaces of this
> + *	      combination must be greator or equal to this value.

typo: greater - will also fix

>   * With this structure the driver can describe which interface
>   * combinations it supports concurrently.
> @@ -3120,7 +3130,7 @@ struct ieee80211_iface_limit {
>   *  };
>   *
>   *
> - * 2. Allow #{AP, P2P-GO} <= 8, channels = 1, 8 total:
> + * 2. Allow #{AP, P2P-GO} <= 8, BI min gcd = 10, channels = 1, 8
> total:
>   *
>   *  struct ieee80211_iface_limit limits2[] = {
>   *	{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) |
> @@ -3131,6 +3141,7 @@ struct ieee80211_iface_limit {
>   *	.n_limits = ARRAY_SIZE(limits2),
>   *	.max_interfaces = 8,
>   *	.num_different_channels = 1,
> + *	.beacon_int_min_gcd = 10,
>   *  };
>   *
>   *
> @@ -3158,6 +3169,7 @@ struct ieee80211_iface_combination {
>  	bool beacon_int_infra_match;
>  	u8 radar_detect_widths;
>  	u8 radar_detect_regions;
> +	u32 beacon_int_min_gcd;
>  };
>  
>  struct ieee80211_txrx_stypes {
> diff --git a/include/uapi/linux/nl80211.h
> b/include/uapi/linux/nl80211.h
> index 56368e9..3c19cca 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -4280,6 +4280,9 @@ enum nl80211_iface_limit_attrs {
>   *	of supported channel widths for radar detection.
>   * @NL80211_IFACE_COMB_RADAR_DETECT_REGIONS: u32 attribute
> containing the bitmap
>   *	of supported regulatory regions for radar detection.
> + * @NL80211_IFACE_COMB_BI_MIN_GCD: u32 attribute specifying the
> minimum GCD of
> + *	different beacon intervals supported by all the interface
> combinations
> + *	in this group (if not present, all beacon interval must
> match).

beacon intervals

>   * @NUM_NL80211_IFACE_COMB: number of attributes
>   * @MAX_NL80211_IFACE_COMB: highest attribute number
>   *
> @@ -4287,8 +4290,8 @@ enum nl80211_iface_limit_attrs {
>   *	limits = [ #{STA} <= 1, #{AP} <= 1 ], matching BI,
> channels = 1, max = 2
>   *	=> allows an AP and a STA that must match BIs
>   *
> - *	numbers = [ #{AP, P2P-GO} <= 8 ], channels = 1, max = 8
> - *	=> allows 8 of AP/GO
> + *	numbers = [ #{AP, P2P-GO} <= 8 ], BI min gcd, channels =
> 1, max = 8,
> + *	=> allows 8 of AP/GO that can have BI gcd >= min gcd
>   *
>   *	numbers = [ #{STA} <= 2 ], channels = 2, max = 2
>   *	=> allows two STAs on different channels
> @@ -4314,6 +4317,7 @@ enum nl80211_if_combination_attrs {
>  	NL80211_IFACE_COMB_NUM_CHANNELS,
>  	NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
>  	NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
> +	NL80211_IFACE_COMB_BI_MIN_GCD,
>  
>  	/* keep last */
>  	NUM_NL80211_IFACE_COMB,
> diff --git a/net/wireless/core.h b/net/wireless/core.h
> index 08d2e94..21e3188 100644
> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -475,7 +475,7 @@ int ieee80211_get_ratemask(struct
> ieee80211_supported_band *sband,
>  			   u32 *mask);
>  
>  int cfg80211_validate_beacon_int(struct cfg80211_registered_device
> *rdev,
> -				 u32 beacon_int);
> +				 enum nl80211_iftype iftype, u32
> beacon_int);
>  
>  void cfg80211_update_iface_num(struct cfg80211_registered_device
> *rdev,
>  			       enum nl80211_iftype iftype, int num);
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index c510810..903cd5a 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -1075,6 +1075,10 @@ static int
> nl80211_put_iface_combinations(struct wiphy *wiphy,
>  		     nla_put_u32(msg,
> NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
>  				c->radar_detect_regions)))
>  			goto nla_put_failure;
> +		if (c->beacon_int_min_gcd &&
> +		    nla_put_u32(msg, NL80211_IFACE_COMB_BI_MIN_GCD,
> +				c->beacon_int_min_gcd))
> +			goto nla_put_failure;
>  
>  		nla_nest_end(msg, nl_combi);
>  	}
> @@ -3803,7 +3807,8 @@ static int nl80211_start_ap(struct sk_buff
> *skb, struct genl_info *info)
>  	params.dtim_period =
>  		nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
>  
> -	err = cfg80211_validate_beacon_int(rdev,
> params.beacon_interval);
> +	err = cfg80211_validate_beacon_int(rdev, dev->ieee80211_ptr-
> >iftype,
> +					   params.beacon_interval);
>  	if (err)
>  		return err;
>  
> @@ -8152,7 +8157,8 @@ static int nl80211_join_ibss(struct sk_buff
> *skb, struct genl_info *info)
>  		ibss.beacon_interval =
>  			nla_get_u32(info-
> >attrs[NL80211_ATTR_BEACON_INTERVAL]);
>  
> -	err = cfg80211_validate_beacon_int(rdev,
> ibss.beacon_interval);
> +	err = cfg80211_validate_beacon_int(rdev,
> NL80211_IFTYPE_ADHOC,
> +					   ibss.beacon_interval);
>  	if (err)
>  		return err;
>  
> @@ -9417,7 +9423,9 @@ static int nl80211_join_mesh(struct sk_buff
> *skb, struct genl_info *info)
>  		setup.beacon_interval =
>  			nla_get_u32(info-
> >attrs[NL80211_ATTR_BEACON_INTERVAL]);
>  
> -		err = cfg80211_validate_beacon_int(rdev,
> setup.beacon_interval);
> +		err = cfg80211_validate_beacon_int(rdev,
> +						   NL80211_IFTYPE_ME
> SH_POINT,
> +						   setup.beacon_inte
> rval);
>  		if (err)
>  			return err;
>  	}
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 0d69b25..3f3d684 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -1559,24 +1559,49 @@ bool
> ieee80211_chandef_to_operating_class(struct cfg80211_chan_def
> *chandef,
>  EXPORT_SYMBOL(ieee80211_chandef_to_operating_class);
>  
>  int cfg80211_validate_beacon_int(struct cfg80211_registered_device
> *rdev,
> +				 enum nl80211_iftype iftype,
>  				 u32 beacon_int)
>  {
>  	struct wireless_dev *wdev;
>  	int res = 0;
> +	u32 bi_prev, tmp_bi;
> +	struct iface_combination_params params = {
> +		.num_different_channels = 0,
> +		.radar_detect = 0,
> +		.iftype_num = {0},
> +		.beacon_gcd = beacon_int,	/* GCD(n) = n */
> +		.diff_bi = false,
> +	};
>  
>  	if (beacon_int < 10 || beacon_int > 10000)
>  		return -EINVAL;
>  
> +	params.iftype_num[iftype] = 1;
> +	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
> +		if (!wdev->beacon_interval)
> +			continue;
> +
> +		params.iftype_num[wdev->iftype]++;
> +	}
> +
>  	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
>  		if (!wdev->beacon_interval)
>  			continue;
>  		if (wdev->beacon_interval != beacon_int) {
> -			res = -EINVAL;
> +			params.diff_bi = true;
> +			/* Get the GCD */
> +			bi_prev = wdev->beacon_interval;
> +			while (bi_prev != 0) {
> +				tmp_bi = bi_prev;
> +				bi_prev = params.beacon_gcd %
> bi_prev;
> +				params.beacon_gcd = tmp_bi;
> +			}
>  			break;
>  		}
>  	}
>  
> -	return res;
> +	res = cfg80211_check_combinations(&rdev->wiphy, &params);
> +	return (res < 0) ? res : 0;
>  }
>  
>  int cfg80211_iter_combinations(struct wiphy *wiphy,
> @@ -1652,6 +1677,14 @@ int cfg80211_iter_combinations(struct wiphy
> *wiphy,
>  		if ((all_iftypes & used_iftypes) != used_iftypes)
>  			goto cont;
>  
> +		if (params->beacon_gcd) {
> +			if (c->beacon_int_min_gcd &&
> +			    params->beacon_gcd < c-
> >beacon_int_min_gcd)
> +				return -EINVAL;
> +			if (!c->beacon_int_min_gcd && params-
> >diff_bi)
> +				goto cont;
> +		}
> 
Otherwise looks good.

johannes

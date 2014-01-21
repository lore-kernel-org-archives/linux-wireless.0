Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36854 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaAUPwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 10:52:38 -0500
Message-ID: <1390319550.6199.59.camel@jlt4.sipsolutions.net> (sfid-20140121_165241_948676_E6152E9E)
Subject: Re: [PATCH 3/3] cfg80211: implement multi-interface CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Jan 2014 16:52:30 +0100
In-Reply-To: <1390226968-18928-4-git-send-email-michal.kazior@tieto.com> (sfid-20140120_151409_031432_70783BAC)
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
	 <1390226968-18928-4-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140120_151409_031432_70783BAC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-20 at 15:09 +0100, Michal Kazior wrote:

> @@ -2583,6 +2588,7 @@ enum wiphy_flags {
>  	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
>  	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
>  	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
> +	WIPHY_FLAG_HAS_MULTI_IF_CHSWITCH	= BIT(24),
>  };

You could probably use an nl80211 feature flag directly, see e.g.
NL80211_FEATURE_HT_IBSS (enum nl80211_feature_flags) and save the code
to set the extra flag attribute.
 
> + * @NL80211_ATTR_CH_SWITCH_IFACES: Nested attribute with channel switch
> + *	settings in each entry (ifindex, frequency, beacon IEs). Also used as a
> + *	device capability flag in nl80211_send_wiphy().

Which would obviously change this.
 
> +int ieee80211_channel_switch(struct wiphy *wiphy,
> +			     struct cfg80211_csa_settings *params,
> +			     int num_params)
> +{
> +	struct ieee80211_sub_if_data *sdata;
> +	int err;
> +
> +	/* multi-vif CSA is not implemented */
> +	if (num_params > 1)
> +		return -EOPNOTSUPP;

The capability flag should be checked in cfg80211, so this shouldn't be
needed?

> +int ieee80211_channel_switch(struct wiphy *wiphy,
> +			     struct cfg80211_csa_settings *params,
> +			     int num_params);

This function can be static now as the other places call the __ version
now. Careful with locking though - you just moved it as well, won't the
callers have to be updated?
 
> @@ -1270,6 +1271,9 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
>  		if ((dev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP) &&
>  		    nla_put_flag(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP))
>  			goto nla_put_failure;
> +		if ((dev->wiphy.flags & WIPHY_FLAG_HAS_MULTI_IF_CHSWITCH) &&
> +		     nla_put_flag(msg, NL80211_ATTR_CH_SWITCH_IFACES))
> +			goto nla_put_failure;
>  		state->split_start++;
>  		if (state->split)
>  			break;

This goes away, which also saves you the trouble of moving it to a
correct place (due to size constraints, we can't increase the amount of
data available to really old iw/wpa_s versions)

> +	/* static variables avoid waste of stack size - this
>  	 * function is called under RTNL lock, so this should not be a problem.
>  	 */
>  	static struct nlattr *csa_attrs[NL80211_ATTR_MAX+1];

Technically we could even just reuse family->attrs since we're also
under genl_lock :)

> -	u8 radar_detect_width = 0;
> +	struct net_device *dev = NULL;
> +	struct wireless_dev *wdev;
>  	int err;
>  	bool need_new_beacon = false;
>  
> -	if (!rdev->ops->channel_switch ||
> -	    !(rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH))
> -		return -EOPNOTSUPP;
> +	ASSERT_RTNL();
> +
> +	if (!attrs[NL80211_ATTR_IFINDEX])
> +		return -EINVAL;

Hmm, shouldn't you use the ifindex from the csa_attrs? Or are you
requiring one to be in the outer data to identify the wiphy? But that
seems odd too, you can just get the wiphy in whatever way by asking the
pre_doit for that?


> +		nla_for_each_nested(attrs,
> +				    info->attrs[NL80211_ATTR_CH_SWITCH_IFACES],
> +				    tmp) {
> +			nla_parse(csa_attrs, NL80211_ATTR_MAX, nla_data(attrs),
> +				  nla_len(attrs), nl80211_policy);

I think nla_parse() can fail, you should check that, otherwise there's
no full validity checking of the attributes contained in it I believe.
 
johannes


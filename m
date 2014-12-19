Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45637 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbaLSJSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 04:18:36 -0500
Message-ID: <1418980707.1889.1.camel@sipsolutions.net> (sfid-20141219_101848_500252_728DEE39)
Subject: Re: [RFC V2] cfg80211: Add feature flag for 4-way handshake offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>
Date: Fri, 19 Dec 2014 10:18:27 +0100
In-Reply-To: <1418935344-22159-1-git-send-email-arend@broadcom.com>
References: <1418935344-22159-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-12-18 at 21:42 +0100, Arend van Spriel wrote:

> +	u8 ext_features[(NUM_NL80211_EXT_FEATURES / 8) + 1];

Should probably use DIV_ROUND_UP() here.

> +static inline bool
> +wiphy_ext_feature_isset(struct wiphy *wiphy,
> +			enum nl80211_ext_feature_index ftidx)
> +{
> +	u8 ft_byte;
> +
> +	ft_byte = wiphy->ext_features[ftidx / 8];
> +	return (ft_byte & BIT(ftidx % 8)) != 0;
> +}

Don't really need != 0 (but doesn't hurt either) since the type
promotion is to bool in the return value.

>  /**
> + * enum nl80211_ext_feature_index - bit index of extended features.
> + *
> + * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE: the device supports 4way handshake
> + */
> +enum nl80211_ext_feature_index {
> +	NL80211_EXT_FEATURE_4WAY_HANDSHAKE,
> +
> +	/* add new features before the definition below */
> +	NUM_NL80211_EXT_FEATURES,
> +	MAX_NL80211_EXT_FEATURES = NUM_NL80211_EXT_FEATURES - 1
> +};

Don't think you need MAX_? Also you should add NUM_ to the documentation
(and MAX_ also if you want to keep it)

> +++ b/net/wireless/nl80211.c
> @@ -1603,6 +1603,11 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
>  		if (nla_put_u32(msg, NL80211_ATTR_FEATURE_FLAGS, features))
>  			goto nla_put_failure;
>  
> +		if (nla_put(msg, NL80211_ATTR_EXT_FEATURES,
> +			    sizeof(rdev->wiphy.ext_features),
> +			    rdev->wiphy.ext_features))
> +			goto nla_put_failure;

I don't think this should go here - I can see how it's tempting to put
it with the feature flags but there's a size limit issue with the wiphy
data on old userspace, so this should go towards the end to deal with
the split data.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36928 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbcHEJDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2016 05:03:12 -0400
Message-ID: <1470387784.2977.30.camel@sipsolutions.net> (sfid-20160805_110316_589014_292F07A4)
Subject: Re: [PATCH] cfg80211: Add support for user configurable beacon data
 rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, ganeshk@qti.qualcomm.com,
	mkalikot@qca.qualcomm.com, amarnath@qca.qualcomm.com
Date: Fri, 05 Aug 2016 11:03:04 +0200
In-Reply-To: <1470371701-13074-1-git-send-email-pkushwah@qti.qualcomm.com>
References: <1470371701-13074-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-08-05 at 10:05 +0530, Purushottam Kushwaha wrote:
> 
> +static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
> +					 struct cfg80211_bitrate_mask *mask);

I think you should move the function instead.

> @@ -3457,6 +3459,11 @@ static int nl80211_start_ap(struct sk_buff
> *skb, struct genl_info *info)
>  	err = cfg80211_validate_beacon_int(rdev,
> params.beacon_interval);
>  	if (err)
>  		return err;
> +	if (info->attrs[NL80211_ATTR_TX_RATES]) {
> +		err = nl80211_parse_tx_bitrate_mask(info,
> &params.beacon_rate);
> +		if (err)
> +			return err;
> +	}

Doesn't this have to check that it actually got information for the
right band?

johannes

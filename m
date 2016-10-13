Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50970 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752150AbcJMNpc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 09:45:32 -0400
Message-ID: <1476361828.4904.18.camel@sipsolutions.net> (sfid-20161013_154605_367770_ECE671B2)
Subject: Re: [PATCH v10] cfg80211: Provision to allow the support for
 different beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        usdutt@qti.qualcomm.com, amarnath@qca.qualcomm.com
Date: Thu, 13 Oct 2016 14:30:28 +0200
In-Reply-To: <1476277011-6937-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20161012_145820_073666_BE102411)
References: <1476277011-6937-1-git-send-email-pkushwah@qti.qualcomm.com>
         (sfid-20161012_145820_073666_BE102411)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-12 at 18:26 +0530, Purushottam Kushwaha wrote:
> This commit provides a mechanism for the host drivers to advertise
> the
> support for different beacon intervals among the respective interface
> combinations in a group, through beacon_int_min_gcd (u32).
> This beacon_int_min_gcd will be compared against GCD of all beaconing
> interfaces of matching combinations.

Applied. I made some more changes, in particular:

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

I removed this, because it would conflict with the other documentation
changes in this area going through the doc tree. I didn't think this
was important enough in the example to break the merge later.

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

I changed that a bit, moving the variables in.

>  			break;

and, more importantly, I removed this break - we need to look at all
interfaces now, not break after the first one with different BI.

>  		}
>  	}
>  
> -	return res;
> +	res = cfg80211_check_combinations(&rdev->wiphy, &params);
> +	return (res < 0) ? res : 0;

removed the res variable too

johannes

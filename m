Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52828 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbcHKNIk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 09:08:40 -0400
Message-ID: <1470920916.12075.15.camel@sipsolutions.net> (sfid-20160811_150843_767640_44A237C9)
Subject: Re: [PATCH v5] cfg80211: Provision to allow the support for
 different beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, amarnath@qca.qualcomm.com,
	djindal@qti.qualcomm.com
Date: Thu, 11 Aug 2016 15:08:36 +0200
In-Reply-To: <1470916154-18821-1-git-send-email-pkushwah@qti.qualcomm.com>
References: <1470916154-18821-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +static bool diff_beacon_interval_supported(struct wiphy *wiphy, u16
> types,
> +					   u32 beacon_int)
> +{
> +	const struct ieee80211_iface_combination *c;
> +	u16 all_types;
> +	int i, j;
> +
> +	for (i = 0; i < wiphy->n_iface_combinations; i++) {
> +		c = &wiphy->iface_combinations[i];
> +
> +		if (!c->diff_beacon_int_gcd ||
> +		    (beacon_int % c->diff_beacon_int_gcd))
> +			continue;
> +
> +		all_types = 0;
> +		for (j = 0; j < c->n_limits; j++)
> +			all_types |= c->limits[j].types;
> +
> +		if (all_types & types)
> +			return true;
> +	}
> +
> +	return false;
> +}

This seems odd. Shouldn't it use cfg80211_iter_combinations()? Might
need some additional helper to understand which interface types are
used right now - seems we mostly moved that to mac80211, but for this
case it should probably stay in cfg80211? Or should it?

johannes

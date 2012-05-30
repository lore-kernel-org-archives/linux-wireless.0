Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2E3Qb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 12:31:59 -0400
Message-ID: <1338395517.4511.29.camel@jlt3.sipsolutions.net> (sfid-20120530_183202_868420_605958F8)
Subject: Re: [PATCH v2 1/2] nl80211/cfg80211: add scan channel times to scan
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 30 May 2012 18:31:57 +0200
In-Reply-To: <1338393559-1792-1-git-send-email-victorg@ti.com>
References: <1338393559-1792-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 18:59 +0300, Victor Goldenshtein wrote:

> +	if (info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]) {
> +		request->min_ch_time =
> +			nla_get_u32(info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]);
> +	}
> +	if (info->attrs[NL80211_ATTR_SCAN_MAX_CH_TIME]) {
> +		request->max_ch_time =
> +			nla_get_u32(info->attrs[NL80211_ATTR_SCAN_MAX_CH_TIME]);
> +		if (request->min_ch_time > request->max_ch_time)
> +			return -EINVAL;
> +	}
> +	if (info->attrs[NL80211_ATTR_SCAN_PSV_MIN_CH_TIME]) {
> +		request->min_passive_ch_time =
> +		    nla_get_u32(info->attrs[NL80211_ATTR_SCAN_PSV_MIN_CH_TIME]);
> +	}
> +	if (info->attrs[NL80211_ATTR_SCAN_PSV_MAX_CH_TIME]) {
> +		request->max_passive_ch_time =
> +		    nla_get_u32(info->attrs[NL80211_ATTR_SCAN_PSV_MAX_CH_TIME]);
> +		if (request->min_passive_ch_time > request->max_passive_ch_time)
> +			return -EINVAL;
> +	}

All of this should probably reject 0 values since they're not valid and
will be overridden -- but to get defaults you can just as well leave it
out completely.

Also, I think you should be forced to specify both min and max if you're
going to specify any at all, because otherwise you can specify a max
that is smaller than the default min and get things completely confused.

johannes


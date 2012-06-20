Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38134 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab2FTHqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:46:14 -0400
Message-ID: <1340178370.4655.22.camel@jlt3.sipsolutions.net> (sfid-20120620_094619_173930_33B74A1D)
Subject: Re: [PATCH v3 1/2] nl80211/cfg80211: add scan channel times to scan
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
Date: Wed, 20 Jun 2012 09:46:10 +0200
In-Reply-To: <1340177634-24568-1-git-send-email-victorg@ti.com>
References: <1340177634-24568-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> + * @NL80211_ATTR_SCAN_PSV_MAX_CH_TIME: Maximum passive scan time (in TUs),
> + *	u32 attribute (similar to @NL80211_ATTR_SCAN_MAX_CH_TIME).
> + *	Note:
> + *	 The above channel time attributes are for the %NL80211_CMD_TRIGGER_SCAN
> + *	 command. The attributes are optional, the driver will use default
> + *	 channel time values if the attribute is not set.
> + *	 If one of the min times will be greater than max or set to zero,
> + *	 -EINVAL will be returned. For the software scan only the min times
> + *	 are relevant.

What if the driver doesn't support the timings?

> +	if (info->attrs[NL80211_ATTR_SCAN_MIN_CH_TIME]) {
> +	if (info->attrs[NL80211_ATTR_SCAN_MAX_CH_TIME]) {
> +	if (info->attrs[NL80211_ATTR_SCAN_PSV_MIN_CH_TIME]) {
> +	if (info->attrs[NL80211_ATTR_SCAN_PSV_MAX_CH_TIME]) {

I think you should ignore the attributes if NL80211_FEATURE_SCAN_TIMES
is not set. That will enforce that anyone implementing it sets the
feature flag correctly, if they ever test their code at all anyway :-)


> +int cfg80211_trigger_scan(struct cfg80211_registered_device *rdev)
> +{
> +	struct cfg80211_scan_request *request;
> +
> +	ASSERT_RDEV_LOCK(rdev);
> +
> +	request = rdev->scan_req;
> +
> +	if (!request)
> +		return -EINVAL;
> +
> +	if (!request->min_passive_ch_time)
> +		request->min_passive_ch_time =
> +		      ieee80211_msec_to_tu(IEEE80211_PSV_CH_TIME_MSEC);
> +	if (!request->min_ch_time)
> +		request->min_ch_time =
> +			ieee80211_msec_to_tu(IEEE80211_CH_TIME_MSEC);

I pointed this out before -- this is problematic. Userspace could
request a max time of 10, and then this would set the min time to 30,
which means min > max which is completely stupid. We should prevent such
settings.

Maybe we need to enforce that if MIN is set, the respective MAX is also
set by userspace. That way, there are no surprises if userspace sets
only MAX but we change the default values at some point.


> @@ -1023,6 +1047,20 @@ int cfg80211_wext_siwscan(struct net_device *dev,
>  		if (wiphy->bands[i])
>  			creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
>  
> +	if (wreq->min_channel_time) {
> +		creq->min_ch_time = wreq->min_channel_time;

are you sure that wext uses TUs?

johannes


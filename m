Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37397 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3JILsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 07:48:31 -0400
Message-ID: <1381319305.14186.7.camel@jlt4.sipsolutions.net> (sfid-20131009_134834_968314_EE307054)
Subject: Re: [PATCH] cfg80211: Pass station supported channel and oper class
 info to kernel
From: Johannes Berg <johannes@sipsolutions.net>
To: Sunil Dutt <c_duttus@qti.qualcomm.com>
Cc: j@w1.fi.com, linux-wireless@vger.kernel.org
Date: Wed, 09 Oct 2013 13:48:25 +0200
In-Reply-To: <1381319011-7714-1-git-send-email-c_duttus@qti.qualcomm.com>
References: <1381319011-7714-1-git-send-email-c_duttus@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +static int nl80211_parse_sta_channel_info(struct genl_info *info,
> +				      struct station_parameters *params)
> +{
> +	if (info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]) {
> +		params->supported_channels =
> +		     nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);
> +		params->supported_channels_len =
> +		     nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_CHANNELS]);
> +		/*
> +		 * Need to include at least One (first channel, number of
> +		 * channels) tuple for each subband.Thus, reject any trailing
> +		 * byte.
> +		 */
> +		if (params->supported_channels_len % 2)
> +			params->supported_channels_len -= 1;
> +	}

That's not 'reject', that's ignore - and you're also not checking that
it's at least 2 bytes long.

> +
> +	if (info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]) {
> +		params->supported_oper_classes =
> +		 nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
> +		params->supported_oper_classes_len =
> +		  nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES]);
> +		/*
> +		 * The value of the Length field of the Supported Operating
> +		 * Classes element is between 2 and 253.
> +		 */
> +		if (params->supported_oper_classes_len < 2 ||
> +		    params->supported_oper_classes_len > 253)
> +			return -EINVAL;

And this would be inconsistent, one is rejected and the other ignored?

Also - you missed sign-off.

johannes


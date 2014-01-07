Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47296 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaAGP7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 10:59:50 -0500
Message-ID: <1389110387.4645.26.camel@jlt4.sipsolutions.net> (sfid-20140107_165953_380826_C571F25A)
Subject: Re: [RFC 2/3] cfg80211: MinChannelTime and MaxChannelTime for scan
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 Jan 2014 16:59:47 +0100
In-Reply-To: <20140106075126.GA31046@w1.fi>
References: <20140106075126.GA31046@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-06 at 09:51 +0200, Jouni Malinen wrote:
> This adds new nl80211 attributes to allow MinChannelTime and
> MaxChannelTime to be specified for scan requests. The parameters can be
> used to control the amount of time spent on each channel during a scan
> as specified in the IEEE Std 802.11-2012 MLME-SCAN.request() primitive.

What are the specific use cases for this? Our driver is likely to muck
around with these in the future, possibly depending on traffic levels
etc., so I wonder what this addresses and whether it can be unified in
some way?

Would you expect these to always be specified, to the point where our
driver no longer has any flexibility in adjusting things internally?

> + * @min_chan_time: MinChannelTime in TUs; time to spend waiting for
> + * PHY-CCA.indication (channel busy) in Active scan; 0 to indicate that driver
> + * default value to be used
> + * @max_chan_time: MaxChannelTime in TUs; time to spend waiting for Beacon or
> + * Probe Response frames; 0 to indicate that driver default value to be used

missing some indentation

> + * @NL80211_ATTR_MIN_CHANNEL_TIME: MinChannelTime - Minimum time (in TU) to
> + *	spend on each channel when scanning (used for active scans). If not
> + *	included, the driver will use its default value. u32 attribute.

What about passive scans?

> +	if (info->attrs[NL80211_ATTR_MIN_CHANNEL_TIME])
> +		request->min_chan_time = nla_get_u32(
> +			info->attrs[NL80211_ATTR_MIN_CHANNEL_TIME]);
> +	if (info->attrs[NL80211_ATTR_MAX_CHANNEL_TIME])
> +		request->max_chan_time = nla_get_u32(
> +			info->attrs[NL80211_ATTR_MAX_CHANNEL_TIME]);
> +	if (request->max_chan_time &&
> +	    request->max_chan_time < request->min_chan_time) {
> +		err = -EINVAL;
> +		goto out_free;
> +	}

If you specify a very long min_chan_time, that's unlikely to please
drivers. Especially if multi-channel mode is implemented, maybe in
conjunction with operating as a GO or a client that wants to hear DTIM
beacons, this might become very complicated.

I'd be really interested in seeing if we can address the use cases here
in a different way that keeps more flexibility in the
driver/firmware/... implementation of scan.

johannes


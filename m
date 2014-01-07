Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaAGP41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 10:56:27 -0500
Message-ID: <1389110184.4645.23.camel@jlt4.sipsolutions.net> (sfid-20140107_165630_816284_0BD2B542)
Subject: Re: [RFC 1/3] cfg80211: Allow BSS hint to be provided for connect
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 Jan 2014 16:56:24 +0100
In-Reply-To: <20140106075102.GA31031@w1.fi>
References: <20140106075102.GA31031@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-06 at 09:51 +0200, Jouni Malinen wrote:
> This clarifies the expected driver behavior on the older
> NL80211_ATTR_MAC and NL80211_ATTR_WIPHY_FREQ attributes and adds a new
> set of similar attributes with _HINT postfix to enable use of a
> recommendation of the initial BSS to choose. This can be helpful for
> some drivers that can avoid an additional full scan on connection
> request if the information is provided to them (user space tools like
> wpa_supplicant already has that information available based on earlier
> scans).
> 
> In addition, this can be used to get more expected behavior for cases
> where a specific BSS should be picked first based on operations like
> Interworking network selection or WPS. These cases were already easily
> addressed with drivers that leave BSS selection to user space, but there
> was no convenient way to do this with drivers that take care of BSS
> selection internally without using the NL80211_ATTR_MAC which is not
> really desired since it is needed for other purposes to force the
> association to remain with the same BSS.

Makes sense.

>  struct cfg80211_connect_params {
>  	struct ieee80211_channel *channel;
> +	struct ieee80211_channel *channel_hint;
>  	u8 *bssid;
> +	u8 *bssid_hint;
>  	u8 *ssid;

Those should probably all be const, but we can do that separately.


>  			return -EINVAL;
> +	} else if (info->attrs[NL80211_ATTR_WIPHY_FREQ_HINT]) {
> +		connect.channel_hint =
> +			ieee80211_get_channel(wiphy,
> +					      nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ_HINT]));
> +		if (!connect.channel_hint ||
> +		    connect.channel_hint->flags & IEEE80211_CHAN_DISABLED)
> +			return -EINVAL;

I'm starting to wonder if this pattern should be abstracted out, but
again, we can do that separately.

johannes


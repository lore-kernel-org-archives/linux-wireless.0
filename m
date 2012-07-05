Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45488 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2GEHkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 03:40:02 -0400
Message-ID: <1341473996.4455.2.camel@jlt3.sipsolutions.net> (sfid-20120705_094006_491427_7FCCABE5)
Subject: Re: [RFC 2/4] cfg80211: support unused HT-cap-per-band configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Jul 2012 09:39:56 +0200
In-Reply-To: <1341417530-9062-3-git-send-email-arik@wizery.com> (sfid-20120704_175900_656383_8C6BE321)
References: <1341417530-9062-1-git-send-email-arik@wizery.com>
	 <1341417530-9062-3-git-send-email-arik@wizery.com>
	 (sfid-20120704_175900_656383_8C6BE321)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-04 at 18:58 +0300, Arik Nemtsov wrote:

>  struct ieee80211_sta_ht_cap {
> +	bool ht_supported; /* this must be first */
>  	u16 cap; /* use IEEE80211_HT_CAP_ */
> -	bool ht_supported;


> -	struct ieee80211_sta_ht_cap ht_cap;
> +	union {
> +		struct ieee80211_sta_ht_cap ht_cap;
> +		bool ht_supported;
> +	};
> +	bool ht_cap_invalid;


Yuck. Why use the union at all? You could just put the ht_cap_invalid
into the ht_cap struct, and it wouldn't even take space, there's
padding :-)


> @@ -30,13 +31,16 @@ rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
>  		 chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
>  		return NULL;
>  
> -	ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
> +	sband = rdev->wiphy.bands[chan->band];
> +	ht_cap = &sband->ht_cap;
>  
>  	if (channel_type != NL80211_CHAN_NO_HT) {
> -		if (!ht_cap->ht_supported)
> +		if (!sband->ht_supported)
>  			return NULL;
>  
> -		if (channel_type != NL80211_CHAN_HT20 &&
> +		/* this check is ignored when per-band HT caps are not used */
> +		if (!sband->ht_cap_invalid &&
> +		    channel_type != NL80211_CHAN_HT20 &&

This is also major confusion, it seems you should roll 2/3 into one
patch?

johannes


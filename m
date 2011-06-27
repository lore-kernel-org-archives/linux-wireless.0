Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38853 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab1F0MmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 08:42:17 -0400
Subject: Re: patch for iw
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1308672087.2656.13.camel@alex-2> (sfid-20110621_180135_800515_518FC79B)
References: <1308671129.2656.4.camel@alex-2>
	 <1308672087.2656.13.camel@alex-2> (sfid-20110621_180135_800515_518FC79B)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 14:42:20 +0200
Message-ID: <1309178540.3911.14.camel@jlt3.sipsolutions.net> (sfid-20110627_144741_587034_2E5E573C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-21 at 18:01 +0200, Alexander Simon wrote:

> @@ -44,6 +45,12 @@ static int join_ibss(struct nl80211_stat
>  	argv++;
>  	argc--;
>  
> +	if (argc && parse_channel_type(argv[0], &htval)) {
> +		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, htval);
> +		argv++;
> +		argc--;
> +	}

> +/*
> + * Convert a string "HT20", "HT40+" or "HT40-" into nl80211
> + * value. Conversion is case insensitive. Returns 1 on success, 0 on error.
> + */
> +
> +int parse_channel_type(const char *str, unsigned int *htval)

That return value isn't the way other functions return their status in
iw, so I won't apply this, it'll just confuse things.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:37847 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754117Ab2FWQDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 12:03:21 -0400
Message-ID: <1340467400.7758.19.camel@joe2Laptop> (sfid-20120623_180323_610174_09BAD2AD)
Subject: Re: [PATCH 4/6] mac80211: clean up debugging
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Sat, 23 Jun 2012 09:03:20 -0700
In-Reply-To: <1340385525-14487-5-git-send-email-johannes@sipsolutions.net>
References: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
	 <1340385525-14487-5-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-22 at 19:18 +0200, Johannes Berg wrote:
[]
> diff --git a/net/mac80211/debug.h b/net/mac80211/debug.h
[]
> +#ifdef CONFIG_MAC80211_IBSS_DEBUG
> +#define MAC80211_IBSS_DEBUG 1
> +#else
> +#define MAC80211_IBSS_DEBUG 0
> +#endif

[ a bunch of these...]

> +#ifdef CONFIG_MAC80211_MLME_DEBUG
> +#define MAC80211_MLME_DEBUG 1
> +#else
> +#define MAC80211_MLME_DEBUG 0
> +#endif

This is kind of ugly using UPPER_CASE globals.

Maybe something like:

extern unsigned int mac80211_debug;

#define MAC80211_DEBUG_IBSS	BIT(0)
...
#define MAC80211_DEBUG_MLME	BIT(x)

and in each appropriate location or with a
static inline somethingorother

#ifdef CONFIG_MAC80211_MLME_DEBUG
	mac80211_debug |= MAC80211_DEBUG_MLME;
#endif


> +#define _sdata_info(sdata, fmt, ...)					\
> +do {									\
> +	pr_info("%s: " fmt,						\
> +		(sdata)->name, ##__VA_ARGS__);				\
> +} while (0)
> +
> +#define _sdata_dbg(print, sdata, fmt, ...)				\
> +do {									\
> +	if (print)							\
> +		pr_debug("%s: " fmt,					\
> +			 (sdata)->name, ##__VA_ARGS__);			\
> +} while (0)
> +
> +#define _sdata_err(sdata, fmt, ...)					\
> +do {									\
> +	pr_debug("%s: " fmt,						\
> +		 (sdata)->name, ##__VA_ARGS__);				\
> +} while (0)
> +
> +#define _wiphy_dbg(print, wiphy, fmt, ...)				\
> +do {									\
> +	if (print)							\
> +		wiphy_dbg((wiphy), fmt, ##__VA_ARGS__);			\
> +} while (0)
> +
> +#define sdata_info(sdata, fmt, ...)					\
> +	_sdata_info(sdata, fmt, ##__VA_ARGS__)
> +#define sdata_err(sdata, fmt, ...)					\
> +	_sdata_err(sdata, fmt, ##__VA_ARGS__)
> +#define sdata_dbg(sdata, fmt, ...)					\
> +	_sdata_dbg(1, sdata, fmt, ##__VA_ARGS__)

Then maybe sdata_dbg become mac80211_dbg()

> +
> +#define ht_dbg(sdata, fmt, ...)						\
> +	_sdata_dbg(MAC80211_HT_DEBUG,					\
> +		   sdata, fmt, ##__VA_ARGS__)


> +
> +#define ht_dbg_ratelimited(sdata, fmt, ...)				\
> +	_sdata_dbg(MAC80211_HT_DEBUG && net_ratelimit(),		\
> +		   sdata, fmt, ##__VA_ARGS__)

[ a bunch more ]

and all these wrappers stay.



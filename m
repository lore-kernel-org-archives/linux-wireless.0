Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab2CFI31 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 03:29:27 -0500
Subject: Re: [PATCH v4 1/2] cfg80211: expose cfg80211_calculate_bitrate()
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
In-Reply-To: <1330990308-15077-1-git-send-email-thomas@cozybit.com> (sfid-20120306_003228_682773_17B3F4DB)
References: <1330990308-15077-1-git-send-email-thomas@cozybit.com>
	 (sfid-20120306_003228_682773_17B3F4DB)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Mar 2012 09:29:25 +0100
Message-ID: <1331022565.3447.2.camel@jlt3.sipsolutions.net> (sfid-20120306_092930_877754_742BA73C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-05 at 15:31 -0800, Thomas Pedersen wrote:
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/net/cfg80211.h |    8 ++++++++
>  net/wireless/util.c    |    1 +
>  2 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 0178c74..64f6181 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3334,6 +3334,14 @@ int cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
>  				 struct ieee80211_channel *chan,
>  				 enum nl80211_channel_type channel_type);
>  
> +/*
> + * cfg80211_calculate_bitrate - calculate actual bitrate (in 100Kbps units)
> + * @rate: given rate_info to calculate bitrate from
> + *
> + * return 0 if MCS index >= 32
> + */
> +u16 cfg80211_calculate_bitrate(struct rate_info *rate);
> +
>  /* Logging, debugging and troubleshooting/diagnostic helpers. */
>  
>  /* wiphy_printk helpers, similar to dev_printk */
> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 9aa9db6..1b7a08d 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -904,6 +904,7 @@ u16 cfg80211_calculate_bitrate(struct rate_info *rate)
>  	/* do NOT round down here */
>  	return (bitrate + 50000) / 100000;
>  }
> +EXPORT_SYMBOL(cfg80211_calculate_bitrate);
>  
>  int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
>  				 u32 beacon_int)



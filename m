Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2ACOUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 09:20:37 -0500
Subject: Re: [PATCH 1/2] nl80211: add support for mcs masks
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <1324304099-18327-2-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1324304099-18327-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1324304099-18327-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Jan 2012 15:20:33 +0100
Message-ID: <1325600433.3316.8.camel@jlt3.sipsolutions.net> (sfid-20120103_152057_976210_B46D1B4C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-19 at 15:14 +0100, Simon Wunderlich wrote:
> Allow to set mcs masks through nl80211. We also allow to set MCS
> rates but no legacy rates (and vice versa).
> 
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
> ---
>  include/linux/nl80211.h |    4 +++
>  include/net/cfg80211.h  |    3 +-
>  net/wireless/nl80211.c  |   54 ++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 58 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index a187606..f1eca8a 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1475,6 +1475,7 @@ enum nl80211_attrs {
>  #define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
>  
>  #define NL80211_MAX_SUPP_RATES			32
> +#define NL80211_MAX_SUPP_HT_RATES		255

That doesn't seem to make a lot of sense, the max is 77 anyway?

> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 150c0ee..4b6ff1c 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1223,8 +1223,7 @@ enum wiphy_params_flags {
>  struct cfg80211_bitrate_mask {
>  	struct {
>  		u32 legacy;
> -		/* TODO: add support for masking MCS rates; e.g.: */
> -		/* u8 mcs[IEEE80211_HT_MCS_MASK_LEN]; */
> +		u8 mcs[IEEE80211_HT_MCS_MASK_LEN];

And if the max above is 255, then this wouldn't be sufficient.

Maybe add

BUILD_BUG_ON(NL80211_MAX_SUPP_HT_RATES > IEEE80211_HT_MCS_MASK_LEN * 8);

somewhere.

> @@ -5352,6 +5382,8 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
>  		sband = rdev->wiphy.bands[i];
>  		mask.control[i].legacy =
>  			sband ? (1 << sband->n_bitrates) - 1 : 0;
> +		memset(&mask.control[i].mcs, sband ? 0xff : 0,
> +		       sizeof(mask.control[i].mcs));
>  	}

Would it make sense to copy the supported ones from the sband rather
than setting a mask that includes more than could possibly be supported?

> @@ -5373,7 +5405,27 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
>  				sband,
>  				nla_data(tb[NL80211_TXRATE_LEGACY]),
>  				nla_len(tb[NL80211_TXRATE_LEGACY]));
> -			if (mask.control[band].legacy == 0)
> +		}
> +		if (tb[NL80211_TXRATE_MCS]) {
> +			if (!ht_rateset_to_mask(sband,
> +				nla_data(tb[NL80211_TXRATE_MCS]),
> +				nla_len(tb[NL80211_TXRATE_MCS]),
> +				mask.control[band].mcs))
> +				return -EINVAL;

Indentation looks strange here.


johannes


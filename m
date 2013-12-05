Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab3LEPmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 10:42:39 -0500
Message-ID: <1386258156.4182.8.camel@jlt4.sipsolutions.net> (sfid-20131205_164255_025867_67654AD4)
Subject: Re: [PATCH v2 3/3] nl80211: add VHT support for set_bitrate_mask
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Date: Thu, 05 Dec 2013 16:42:36 +0100
In-Reply-To: <1386234137-3531-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131205_100230_705131_CB931FCE)
References: <1386234137-3531-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1386234137-3531-3-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131205_100230_705131_CB931FCE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 10:02 +0100, Janusz Dziedzic wrote:

> +	switch (vht_mcs_map & 0x03) {

I think that should be in the caller.

> +	case IEEE80211_VHT_MCS_NOT_SUPPORTED:
> +		break;
> +	case IEEE80211_VHT_MCS_SUPPORT_0_7:
> +		mcs_mask = 0x00FF;
> +		break;
> +	case IEEE80211_VHT_MCS_SUPPORT_0_8:
> +		mcs_mask = 0x01FF;
> +		break;
> +	case IEEE80211_VHT_MCS_SUPPORT_0_9:
> +		mcs_mask = 0x03FF;
> +		break;
> +	}
> +
> +	return mcs_mask;
> +}
> +
> +static void vht_build_mcs_mask(u16 vht_mcs_map,
> +			       u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
> +{
> +	u8 nss;
> +
> +	for (nss = 0; nss < NL80211_VHT_NSS_MAX; nss++) {
> +		vht_mcs_mask[nss] = vht_mcs_map_to_mcs_mask(vht_mcs_map);
> +		vht_mcs_map >>= 2;
> +	}

> @@ -7364,20 +7430,31 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
>  					mask.control[band].ht_mcs))
>  				return -EINVAL;
>  		}
> +		if (tb[NL80211_TXRATE_VHT]) {
> +			if (!vht_set_mcs_mask(
> +					sband,
> +					nla_data(tb[NL80211_TXRATE_VHT]),
> +					mask.control[band].vht_mcs))
> +				return -EINVAL;
> +		}
>  
>  		if (mask.control[band].legacy == 0) {
> -			/* don't allow empty legacy rates if HT
> -			 * is not even supported. */
> -			if (!rdev->wiphy.bands[band]->ht_cap.ht_supported)
> +			/* don't allow empty legacy rates if HT or VHT
> +			 * are not even supported. */

comment style

johannes


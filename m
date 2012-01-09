Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab2AINBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 08:01:23 -0500
Subject: Re: [PATCHv2 1/2] nl80211: add support for mcs masks
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <1325793490-21501-2-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1325793490-21501-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jan 2012 14:01:20 +0100
Message-ID: <1326114080.3451.23.camel@jlt3.sipsolutions.net> (sfid-20120109_140128_783177_4396F58F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-05 at 20:58 +0100, Simon Wunderlich wrote:

> @@ -5413,7 +5451,28 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
>  				sband,
>  				nla_data(tb[NL80211_TXRATE_LEGACY]),
>  				nla_len(tb[NL80211_TXRATE_LEGACY]));
> -			if (mask.control[band].legacy == 0)
> +		}
> +		if (tb[NL80211_TXRATE_MCS]) {
> +			if (!ht_rateset_to_mask(
> +					sband,
> +					nla_data(tb[NL80211_TXRATE_MCS]),
> +					nla_len(tb[NL80211_TXRATE_MCS]),
> +					mask.control[band].mcs))
> +				return -EINVAL;
> +		}
> +
> +		if (mask.control[band].legacy == 0) {
> +			/* don't allow empty legacy rates if HT
> +			 * is not even supported. */
> +			if (!rdev->wiphy.bands[band]->ht_cap.ht_supported)
> +				return -EINVAL;
> +
> +			for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
> +				if (mask.control[band].mcs[i])
> +					break;
> +
> +			/* legacy and mcs rates may not be both empty */
> +			if (i == IEEE80211_HT_MCS_MASK_LEN)
>  				return -EINVAL;

Ok ... what if you now associate to a non-HT AP? I don't really care
what happens as long as we don't hit a ton of warnings?

johannes


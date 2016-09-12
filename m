Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57612 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757742AbcILK0P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 06:26:15 -0400
Message-ID: <1473675973.29016.19.camel@sipsolutions.net> (sfid-20160912_122632_576118_D3327DB2)
Subject: Re: [PATCH v3] cfg80211: Add support to configure a beacon data rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        usdutt@qti.qualcomm.com, amarnath@qca.qualcomm.com
Date: Mon, 12 Sep 2016 12:26:13 +0200
In-Reply-To: <1472814834-2728-1-git-send-email-pkushwah@qti.qualcomm.com>
References: <1472814834-2728-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +static u32 rateset_to_mask(struct ieee80211_supported_band *sband,
> +			   u8 *rates, u8 rates_len)


All of these just move around, right?

> +	if (info->attrs[NL80211_ATTR_TX_RATES]) {
> +		u32 rate, count_ht, count_vht, i;
> +		enum nl80211_band band;
> +
> +		err = nl80211_parse_tx_bitrate_mask(info,
> &params.beacon_rate);
> +		if (err)
> +			return err;
> +
> +		band = params.chandef.chan->band;
> +		rate = params.beacon_rate.control[band].legacy;
> +		/* Allow only one rate */
> +		if (rate) {
> +			if (rate & (rate - 1))
> +				return -EINVAL;
> +		} else {
> +			count_ht = 0;
> +			for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN;
> i++) {
> +				if
> (params.beacon_rate.control[band].ht_mcs[i]) {
> +					count_ht++;
> +					if (count_ht > 1)
> +						return -EINVAL;
> +				}
> +			}
> +			count_vht = 0;
> +			for (i = 0; i < NL80211_VHT_NSS_MAX; i++) {
> +				if
> (params.beacon_rate.control[band].vht_mcs[i]) {
> +					count_vht++;
> +					if (count_vht > 1)
> +						return -EINVAL;
> +				}
> +			}
> +			if (!count_ht && !count_vht)
> +				return -EINVAL;
> +		}
> +	}
> 
I think it would be good to split out this "single rate" thing into a
helper function.

Thanks,
johannes

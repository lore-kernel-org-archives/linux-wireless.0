Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38166 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756845AbcIMSnL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 14:43:11 -0400
Message-ID: <1473792187.5622.7.camel@sipsolutions.net> (sfid-20160913_204314_700998_61829C43)
Subject: Re: [PATCH v4] cfg80211: Add support to configure a beacon data rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        usdutt@qti.qualcomm.com, amarnath@qca.qualcomm.com
Date: Tue, 13 Sep 2016 20:43:07 +0200
In-Reply-To: <1473759726-14425-1-git-send-email-pkushwah@qti.qualcomm.com>
References: <1473759726-14425-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks for the new version. I was going to apply it but while changing
something small - see below - found what I think is another issue?

> +static int validate_beacon_tx_rate(struct cfg80211_ap_settings
> *params)
> +{
> +	u32 rate, count_ht, count_vht, i;
> +	enum nl80211_band band;
> +
> +	band = params->chandef.chan->band;
> +	rate = params->beacon_rate.control[band].legacy;
> +
> +	/* Allow only one rate */
> +	if (rate && (rate & (rate - 1)))
> +		return -EINVAL;

I was going to change that to just
	if (hweight32(rate) > 1)
		return -EINVAL;

I realize that your code is equivalent, but I doubt that we need to be
really efficient here, and IMHO hweight32() is easier to understand.

> +	count_ht = 0;
> +	for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
> +		if (params->beacon_rate.control[band].ht_mcs[i]) {
> +			count_ht++;
> +			if (count_ht > 1)
> +				return -EINVAL;
> +		}
> +	}

But this is where I got confused - this seems wrong, you should be
checking the hweight8() of each of the ht_mcs[i] values?

Similarly, the VHT one, but with hweight16() of course, no?

I was going to move a "if (rate) return -EINVAL;" check into this and
the VHT loop, so that we only need the count_ht && count_vht and the
"all empty" portion of this:

> +	if ((rate && count_ht) ||
> +	    (rate && count_vht) ||
> +	    (count_ht && count_vht) ||
> +	    (!rate && !count_ht && !count_vht))
> +		return -EINVAL;
> +
> +	return 0;
> +}


johannes

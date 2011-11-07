Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1KGJNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 04:13:30 -0500
Subject: Re: [PATCH v4 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320437440-6463-2-git-send-email-greearb@candelatech.com> (sfid-20111104_211114_679516_4CC16ABF)
References: <1320437440-6463-1-git-send-email-greearb@candelatech.com>
	 <1320437440-6463-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111104_211114_679516_4CC16ABF)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 10:13:28 +0100
Message-ID: <1320657208.3993.29.camel@jlt3.sipsolutions.net> (sfid-20111107_101334_899358_B98A39DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 13:10 -0700, greearb@candelatech.com wrote:

> +/*
> + * Stations supporting 802.11n are required to support
> + * at least the first 8 MCS rates.  See section 7.3.2.56.4
> + * and 20.1.1 of the 802.11n spec.
> + */
> +#define IEEE80211_HT_MCS_REQ_RATES_STA		8

I'd prefer if this was a validation on the input from userspace directly
in cfg80211, that way other drivers that want to implement this don't
have to bother.

That probably goes well with the validation of the supported mask that I
asked for.

> +	/* mac80211 allows over-riding some of the ht-capabilities */
> +	local->hw.wiphy->ht_capa_mod_mask =
> +		kzalloc(sizeof(*local->hw.wiphy->ht_capa_mod_mask),
> +			GFP_KERNEL);
> +	if (local->hw.wiphy->ht_capa_mod_mask) {
> +		struct ieee80211_ht_cap *cm = local->hw.wiphy->ht_capa_mod_mask;
> +		u8 *r = (u8 *)(&cm->mcs.rx_mask);
> +		memset(r, 0xff, IEEE80211_HT_MCS_MASK_LEN);
> +		cm->cap_info |= IEEE80211_HT_CAP_MAX_AMSDU;
> +		cm->ampdu_params_info |= IEEE80211_HT_AMPDU_PARM_FACTOR;
> +		cm->ampdu_params_info |= IEEE80211_HT_AMPDU_PARM_DENSITY;
> +	}

Why is this not just a static const that you fill manually? There's
nothing that's not constant here. So e.g.

static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
	.ampdu_params_info = IEEE80211_HT_AMPDU_PARM_FACTOR |
			     IEEE80211_HT_AMPDU_PARM_DENSITY,
	.mcs = {
		.rx_mask = { 0xff, 0xff, 0xff, 0xff, 0xff,
			     0xff, 0xff, 0xff, 0xff, 0xff, },
	},
	/* etc */
};

> @@ -988,6 +1001,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>   fail_wiphy_register:
>  	if (local->wiphy_ciphers_allocated)
>  		kfree(local->hw.wiphy->cipher_suites);
> +	kfree(local->hw.wiphy->ht_capa_mod_mask);
> +	local->hw.wiphy->ht_capa_mod_mask = NULL;

No need for this then obviously.


Looks pretty good overall. This is _much_ more readable than the
previous series. :-)

johannes


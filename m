Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab3BKVvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:51:45 -0500
Message-ID: <1360619500.8738.53.camel@jlt4.sipsolutions.net> (sfid-20130211_225150_405966_92882CDF)
Subject: Re: [PATCH v2 3/3] mac80211/minstrel_ht: add support for using CCK
 rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 22:51:40 +0100
In-Reply-To: <1360589765-58642-3-git-send-email-nbd@openwrt.org>
References: <1360589765-58642-1-git-send-email-nbd@openwrt.org>
	 <1360589765-58642-2-git-send-email-nbd@openwrt.org>
	 <1360589765-58642-3-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied patches 1 and 2 but this one had too many smatch complaints:


> #define CCK_GROUP                                       \
>         {                                               \
>                 .streams = 0,                           \
>                 .duration = {                           \
>                         CCK_DURATION_LIST(false),       \
>                         CCK_DURATION_LIST(true)         \
>                 }                                       \
>         }

This seems to have caused smatch to complain, because after having 

#define MCS_GROUP(_streams, _sgi, _ht40)                                \
        [GROUP_IDX(_streams, _sgi, _ht40)] = {                          \

it couldn't prove that the CCK went into slot 12. Are you sure they go
there for sure, with the different initialization?

> +struct minstrel_rate_stats *
> +minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
> +		      struct ieee80211_tx_rate *rate)
> +{
> +	int group, idx;
> +
> +	if (rate->flags & IEEE80211_TX_RC_MCS) {
> +		group = minstrel_ht_get_group_idx(rate);
> +		idx = rate->idx % MCS_GROUP_RATES;
> +	} else {
> +		group = MINSTREL_CCK_GROUP;
> +
> +		for (idx = 0; idx <= ARRAY_SIZE(mp->cck_rates); idx++)

should be < rather than <=?

> +	if (rate->flags & IEEE80211_TX_RC_MCS);
> +		return true;

ho humm ...

johannes


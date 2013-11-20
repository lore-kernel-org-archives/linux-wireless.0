Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59111 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3KTQrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 11:47:11 -0500
Received: by mail-wi0-f176.google.com with SMTP id f4so7346219wiw.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 08:47:07 -0800 (PST)
Date: Wed, 20 Nov 2013 17:46:33 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [RFC v2] mac80211: minstrel_ht: add basic support for VHT rates
 <= 80MHz
Message-ID: <20131120164633.GD9335@magnum.frso.rivierawaves.com> (sfid-20131120_174715_875862_DEA1FA49)
References: <1384386350-419-1-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1384386350-419-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, Nov 14, 2013 at 12:45:50AM +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> When the new CONFIG_MAC80211_RC_MINSTREL_VHT is not set, there is no
> overhead. When it is and a STA supports some VHT MCSes, we restrict to
> VHT rates for stats readability (though everything is in place to use
> both HT and VHT at the same time (unset vht_only)).
> 
[...]

> +	.duration = {								\
> +		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw,  117,  54,  26)),	\
> +		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw,  234, 108,  52)),	\
> +		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw,  351, 162,  78)),	\
> +		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw,  468, 216, 104)),	\
> +		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw,  702, 324, 156)),	\
> +		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw,  936, 432, 208)),	\
> +		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw, 1053, 486, 234)),	\
> +		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw, 1170, 540, 260)),	\
> +		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw, 1404, 648, 312)),	\
> +		MCS_DURATION(_streams, _sgi, BW2VBPS(_bw, 1560, 720, 346))	\
> +	}									\
> +}
> +
Problem with these is that minstrel_ht computes throughputs with these
"symbol rounded" durations for 1200bytes packets .. which means that
some MCSes yield the same durations.
However, this also occurs with HT and is not specific to this patch.

> +static int
> +minstrel_vht_get_group_idx(struct ieee80211_tx_rate *rate)
> +{
> +	return VHT_GROUP_IDX(ieee80211_rate_get_vht_nss(rate),
> +			     !!(rate->flags & IEEE80211_TX_RC_SHORT_GI),
> +			     !!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) +
> +			     2*!!(rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH));
> +}
> +
Can do better ;).

> +	u16 flags = group->flags;
>  
Independent of this patch but we should change the u32 mcs_group.flags
to u16 then.

>  	mr = minstrel_get_ratestats(mi, index);
>  	if (!mr->retry_updated)
> @@ -633,13 +741,13 @@ minstrel_ht_set_rate(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
>  		ratetbl->rate[offset].count_rts = mr->retry_count_rtscts;
>  	}
>  
> -	if (index / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
> +	if (index / MCS_GROUP_RATES == MINSTREL_CCK_GROUP)
>  		idx = mp->cck_rates[index % ARRAY_SIZE(mp->cck_rates)];
> -		flags = 0;
> -	} else {
> +	else if (flags & IEEE80211_TX_RC_VHT_MCS)
> +		idx = ((group->streams - 1) << 4) |
> +		      ((index % MCS_GROUP_RATES) & 0xF);
> +	else
>  		idx = index % MCS_GROUP_RATES + (group->streams - 1) * 8;
> -		flags = IEEE80211_TX_RC_MCS | group->flags;
> -	}
>  
Could replace such occurences with something like:
{
In rc80211_minstrel_ht.h:
 struct mcs_group {
        u16 flags;
+       s8 ridx[MCS_GROUP_RATES];
...

In rc80211_minstrel_ht.c:
 #define VHT_GROUP(_streams, _sgi, _bw)                                         \
        [VHT_GROUP_IDX(_streams, _sgi, _bw)] = {                                \
        .streams = _streams,                                                    \
+       .ridx = {                                                               \
+               (_streams - 1) << 4 | (0 & 0xF),                                \
+               (_streams - 1) << 4 | (1 & 0xF),                                \
+               (_streams - 1) << 4 | (2 & 0xF),                                \
+               (_streams - 1) << 4 | (3 & 0xF),                                \
+               (_streams - 1) << 4 | (4 & 0xF),                                \
+               (_streams - 1) << 4 | (5 & 0xF),                                \
+               (_streams - 1) << 4 | (6 & 0xF),                                \
+               (_streams - 1) << 4 | (7 & 0xF),                                \
+               (_streams - 1) << 4 | (8 & 0xF),                                \
+               (_streams - 1) << 4 | (9 & 0xF),                                \
+       },                                                                      \
...
	if (index / MCS_GROUP_RATES != MINSTREL_CCK_GROUP)
		idx = group->ridx[index % MCS_GROUP_RATES];
	else
  		idx = mp->cck_rates[index % ARRAY_SIZE(mp->cck_rates)];
}
No need to compute/duplicate the rate indexes.





> diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
[...]
> +		} else if (i >= MINSTREL_VHT_GROUP_0) {
Maybe homogenize with the checks in rc80211_minstrel_ht.c like
if (flags & IEEE80211_TX_RC_VHT_MCS) ...
or better :
switch (flags & (IEEE80211_TX_RC_VHT_MCS | IEEE80211_TX_RC_MCS)) {
case IEEE80211_TX_RC_VHT_MCS:
	...
case IEEE80211_TX_RC_MCS:
	...
default: /* CCK */
	WARN_ON(index / MCS_GROUP_RATES != MINSTREL_CCK_GROUP);
	...
}


 
Karl

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57896 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab1HAJxY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 05:53:24 -0400
Message-ID: <4E36778E.8030308@openwrt.org> (sfid-20110801_115327_158998_789C9A15)
Date: Mon, 01 Aug 2011 11:53:18 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCHv2 2/2] mac80211: Don't use EAPOL frames for rate sampling
References: <1312191173-23963-1-git-send-email-helmut.schaa@googlemail.com> <1312191173-23963-2-git-send-email-helmut.schaa@googlemail.com> <4E367432.60601@openwrt.org> <CAGXE3d_HFFSF6Aspyyq6uCdLPrQ7uCOQNKpFzoOu3cUfEDA-XQ@mail.gmail.com>
In-Reply-To: <CAGXE3d_HFFSF6Aspyyq6uCdLPrQ7uCOQNKpFzoOu3cUfEDA-XQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-01 11:43 AM, Helmut Schaa wrote:
> On Mon, Aug 1, 2011 at 11:38 AM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>  On 2011-08-01 11:32 AM, Helmut Schaa wrote:
>>>
>>>  Signed-off-by: Helmut Schaa<helmut.schaa@googlemail.com>
>>>  ---
>>>
>>>  Haven't done much testing yet but this looks safe to me.
>>>  Helmut
>>>
>>>    net/mac80211/rc80211_minstrel_ht.c |    8 +++++++-
>>>    1 files changed, 7 insertions(+), 1 deletions(-)
>>>
>>>  diff --git a/net/mac80211/rc80211_minstrel_ht.c
>>>  b/net/mac80211/rc80211_minstrel_ht.c
>>>  index 66a1eeb..2158838 100644
>>>  --- a/net/mac80211/rc80211_minstrel_ht.c
>>>  +++ b/net/mac80211/rc80211_minstrel_ht.c
>>>  @@ -608,7 +608,13 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta
>>>  *sta, void *priv_sta,
>>>                  return mac80211_minstrel.get_rate(priv, sta,&msp->legacy,
>>>  txrc);
>>>
>>>          info->flags |= mi->tx_flags;
>>>  -       sample_idx = minstrel_get_sample_rate(mp, mi);
>>>  +
>>>  +       /* Don't use EAPOL frames for sampling on non-mrr hw */
>>>  +       if (mp->hw->max_rates == 1&&
>>>  +           txrc->skb->protocol == cpu_to_be16(ETH_P_PAE))
>>
>>  I think checking for mp->hw->max_rates<  3 would be better here, because
>>  then it also covers the primary rate + fallback rate case (as being used by
>>  b43), which also doesn't include the max_prob_rate in the mrr series.
>
> The mp->hw->max_rates == 2 case is sample_rate ->  max_prob_rate and
> max_tp_rate ->  max_prob_rate at the moment. So, these devices should be fine
> already.
Yeah, you're right.

Acked-by: Felix Fietkau <nbd@openwrt.org>

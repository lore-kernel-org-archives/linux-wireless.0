Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53076 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759956Ab3BHQcr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 11:32:47 -0500
Message-ID: <511528AC.9040707@openwrt.org> (sfid-20130208_173430_212039_993D7080)
Date: Fri, 08 Feb 2013 17:32:44 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Paul Stewart <pstew@google.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/3] mac80211/minstrel_ht: add support for using CCK rates
References: <1360327083-57298-1-git-send-email-nbd@openwrt.org> <1360327083-57298-2-git-send-email-nbd@openwrt.org> <1360327083-57298-3-git-send-email-nbd@openwrt.org> <CAMcMvshNG_S+aJSX+WBXSet2cOeLOfJWQ-OAHhKGGa2BXiOkuw@mail.gmail.com>
In-Reply-To: <CAMcMvshNG_S+aJSX+WBXSet2cOeLOfJWQ-OAHhKGGa2BXiOkuw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-08 5:22 PM, Paul Stewart wrote:
> On Fri, Feb 8, 2013 at 4:38 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>
>> When MCS rates start to get bad in 2.4 GHz because of long range or
>> strong interference, CCK rates can be a lot more robust.
>>
>> This patch adds a pseudo MCS group containing CCK rates (long preamble
>> in the lower 4 slots, short preamble in the upper slots).
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> ---
>>  net/mac80211/rc80211_minstrel.c            |  29 ++++++
>>  net/mac80211/rc80211_minstrel.h            |   2 +
>>  net/mac80211/rc80211_minstrel_ht.c         | 152 +++++++++++++++++++++++++----
>>  net/mac80211/rc80211_minstrel_ht.h         |   5 +-
>>  net/mac80211/rc80211_minstrel_ht_debugfs.c | 109 +++++++++++++--------
>>  5 files changed, 237 insertions(+), 60 deletions(-)
>>
>> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
>> index 8c5acdc..eea45a2 100644
>> --- a/net/mac80211/rc80211_minstrel.c
>> +++ b/net/mac80211/rc80211_minstrel.c
>> @@ -494,6 +494,33 @@ minstrel_free_sta(void *priv, struct ieee80211_sta *sta, void *priv_sta)
>>         kfree(mi);
>>  }
>>
>> +static void
>> +minstrel_init_cck_rates(struct minstrel_priv *mp)
>> +{
>> +       static const int bitrates[4] = { 10, 20, 55, 110 };
>> +       struct ieee80211_supported_band *sband;
>> +       int i, j;
>> +
>> +       sband = mp->hw->wiphy->bands[IEEE80211_BAND_2GHZ];
>> +       if (!sband)
>> +               return;
>> +
>> +       for (i = 0, j = 0; i < sband->n_bitrates; i++) {
>> +               struct ieee80211_rate *rate = &sband->bitrates[i];
>> +
>> +               if (rate->flags & IEEE80211_RATE_ERP_G)
>> +                       continue;
>> +
>> +               for (j = 0; j < ARRAY_SIZE(bitrates); j++) {
>> +                       if (rate->bitrate != bitrates[j])
>> +                               continue;
>> +
>> +                       mp->cck_rates[j] = i;
>> +                       break;
>> +               }
>> +       }
>> +}
>> +
>>  static void *
>>  minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
>>  {
>> @@ -539,6 +566,8 @@ minstrel_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
>>                         S_IRUGO | S_IWUGO, debugfsdir, &mp->fixed_rate_idx);
>>  #endif
>>
>> +       minstrel_init_cck_rates(mp);
>> +
>>         return mp;
>>  }
>>
>> diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
>> index 5d278ec..5ecf757 100644
>> --- a/net/mac80211/rc80211_minstrel.h
>> +++ b/net/mac80211/rc80211_minstrel.h
>> @@ -79,6 +79,8 @@ struct minstrel_priv {
>>         unsigned int lookaround_rate;
>>         unsigned int lookaround_rate_mrr;
>>
>> +       u8 cck_rates[4];
>> +
>>  #ifdef CONFIG_MAC80211_DEBUGFS
>>         /*
>>          * enable fixed rate processing per RC
>> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
>> index 5bb316a..ba32416 100644
>> --- a/net/mac80211/rc80211_minstrel_ht.c
>> +++ b/net/mac80211/rc80211_minstrel_ht.c
>> @@ -1,5 +1,5 @@
>>  /*
>> - * Copyright (C) 2010 Felix Fietkau <nbd@openwrt.org>
>> + * Copyright (C) 2010-2013 Felix Fietkau <nbd@openwrt.org>
>>   *
>>   * This program is free software; you can redistribute it and/or modify
>>   * it under the terms of the GNU General Public License version 2 as
>> @@ -63,6 +63,30 @@
>>         }                                                               \
>>  }
>>
>> +#define CCK_DURATION(_bitrate, _short, _len)           \
>> +       (10 /* SIFS */ +                                \
>> +        (_short ? 72 + 24 : 144 + 48 ) +               \
>> +        (8 * (_len + 4) * 10) / (_bitrate))
>> +
>> +#define CCK_ACK_DURATION(_bitrate, _short)                     \
>> +       (CCK_DURATION((_bitrate > 10 ? 20 : 10), false, 60) +   \
>> +        CCK_DURATION(_bitrate, _short, AVG_PKT_SIZE))
>> +
>> +#define CCK_DURATION_LIST(_short)                      \
>> +       CCK_ACK_DURATION(10, _short),                   \
>> +       CCK_ACK_DURATION(20, _short),                   \
>> +       CCK_ACK_DURATION(55, _short),                   \
>> +       CCK_ACK_DURATION(110, _short)
>> +
>> +#define CCK_GROUP                                      \
>> +       {                                               \
>> +               .streams = 0,                           \
>> +               .duration = {                           \
>> +                       CCK_DURATION_LIST(false),       \
>> +                       CCK_DURATION_LIST(true)         \
>> +               }                                       \
>> +       }
>> +
>>  /*
>>   * To enable sufficiently targeted rate sampling, MCS rates are divided into
>>   * groups, based on the number of streams and flags (HT40, SGI) that they
>> @@ -95,8 +119,13 @@ const struct mcs_group minstrel_mcs_groups[] = {
>>  #if MINSTREL_MAX_STREAMS >= 3
>>         MCS_GROUP(3, 1, 1),
>>  #endif
>> +
>> +       /* must be last */
>> +       CCK_GROUP
>>  };
>>
>> +#define MINSTREL_CCK_GROUP     (ARRAY_SIZE(minstrel_mcs_groups) - 1)
>> +
>>  static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES];
>>
>>  /*
>> @@ -119,6 +148,29 @@ minstrel_ht_get_group_idx(struct ieee80211_tx_rate *rate)
>>                          !!(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH));
>>  }
>>
>> +struct minstrel_rate_stats *
>> +minstrel_ht_get_stats(struct minstrel_priv *mp, struct minstrel_ht_sta *mi,
>> +                     struct ieee80211_tx_rate *rate)
>> +{
>> +       int group, idx;
>> +
>> +       if (rate->flags & IEEE80211_TX_RC_MCS) {
>> +               group = minstrel_ht_get_group_idx(rate);
>> +               idx = rate->idx % MCS_GROUP_RATES;
>> +       } else {
>> +               group = MINSTREL_CCK_GROUP;
>> +
>> +               for (idx = 0; idx <= ARRAY_SIZE(mp->cck_rates); idx++)
>> +                       if (rate->idx == idx)
>> +                               break;
> Either this if statement isn't doing what you think it does (perhaps
> you wanted rate->idx == mp->cck_rates[i]?) or this whole loop could be
> simplified with an if statement?
Right, thanks. By the way, I meant rate->idx == mp->cck_rates[idx].
It happened to work in my tests because both variants are equivalent on
ath9k, but that may not be true for other drivers. :)

- Felix

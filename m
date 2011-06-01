Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:50239 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161739Ab1FAIfa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 04:35:30 -0400
Message-ID: <4DE5F9CE.7080904@neratec.com> (sfid-20110601_103536_792286_7B5C04B7)
Date: Wed, 01 Jun 2011 10:35:26 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "M. A." <jdiq123@googlemail.com>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] Override Minstrel HT RC to set an MCS bitrate (mask)
References: <AANLkTin2ob-EOmY_iqxZbQ98dTA6_vAGsGWrMNKBZTVV@mail.gmail.com>	<AANLkTinRhmByJFoMLsN82ZVfvRa=WOsKVhAcbk8hX2Pv@mail.gmail.com>	<BANLkTinQcXReH8JXFVvmv1LG_7rUog--jg@mail.gmail.com> <BANLkTimv8_GYyMCH_M3Pyv9_5R+wvr8YpA@mail.gmail.com>
In-Reply-To: <BANLkTimv8_GYyMCH_M3Pyv9_5R+wvr8YpA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi M.A.,

I posted a related patch two weeks ago (see. [1]).

It was addressed also to you, since I remembered you were asking for
such a feature. Isn't it doing what it should?


Cheers


[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/70428/

On 05/31/2011 07:06 PM, M. A. wrote:
> Hi all,
> 
> I would be grateful if anyone can advise on setting/masking a fixed
> MCS HT rate (ath9k) at runtime, as I am only able to mask legacy
> rates..
> 
> If this is not yet implemented, can anyone please advise on how to
> implement this as I am in urgent need of this functionality.
> 
> Thank you all in advance!
> 
> 
>> On Tue, Mar 15, 2011 at 5:02 AM, Mohammed Shafi <shafi.ath9k@gmail.com> wrote:
>>> On Tue, Mar 8, 2011 at 11:10 PM, M. A. <jdiq123@googlemail.com> wrote:
>>>> Hi all,
>>>>
>>>> My question is how can I modify Minstrel HT rate control to be able to
>>>> override it (by a boolean or otherwise) to select an MCS or specific
>>>> rate index from user space (such that once set it driver will only try
>>>> sending at that rate until unset then driver will resort back to
>>>> Minstrel RC).
>>>
>>> I don't think we can fix the MCS rate index from user space, may be we
>>> need a hack.
>>> iw  dev <devname> set bitrates [legacy-<2.4|5> <legacy rate in Mbps>*]
>>> and this is only for legacy rates.
>>>
>>>
>>>>
>>>> I have been able to change other kernel parameters at runtime(echo
>>>> /sys/kernel/debug/ieee80211/...) by passing them through (fops) to
>>>> DebugFs. however I am unsure of what parameters to pass through in the
>>>> case of MCS rate fixing and what modifications to the code are
>>>> required to achieve this.
>>>
>>> don't know and I am not sure whether this can be easily done.
>>>
>>>>
>>>>
>>>> Also I have been told that these sections of code facilitate the
>>>> masking of rates;
>>>>
>>>> =========================================================================
>>>> include/net/cfg80211.h: cfg80211_bitrate_mask
>>>> -------------------------------------------------------------------------------------------------------
>>>> /*
>>>>  * cfg80211_bitrate_mask - masks for bitrate control
>>>>  */
>>>> struct cfg80211_bitrate_mask {
>>>>        struct {
>>>>                u32 legacy;
>>>>                /* TODO: add support for masking MCS rates; e.g.: */
>>>>                /* u8 mcs[IEEE80211_HT_MCS_MASK_LEN]; */
>>>>        } control[IEEE80211_NUM_BANDS];
>>>> };
>>>> -------------------------------------------------------------------------------------------------------
>>>> net/mac80211/cfg.c ieee80211_set_bitrate_mask
>>>> -------------------------------------------------------------------------------------------------------
>>>> static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
>>>>                                      struct net_device *dev,
>>>>                                      const u8 *addr,
>>>>                                      const struct cfg80211_bitrate_mask *mask)
>>>> {
>>>>        struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>>>>        struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>>>>        int i;
>>>>
>>>>        /*
>>>>         * This _could_ be supported by providing a hook for
>>>>         * drivers for this function, but at this point it
>>>>         * doesn't seem worth bothering.
>>>>         */
>>>>        if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
>>>>                return -EOPNOTSUPP;
>>>>
>>>>
>>>>        for (i = 0; i < IEEE80211_NUM_BANDS; i++)
>>>>                sdata->rc_rateidx_mask[i] = mask->control[i].legacy;
>>>>
>>>>        return 0;
>>>> }
>>>> -------------------------------------------------------------------------------------------------------
>>>> net/wireless/nl80211.c: nl80211_set_tx_bitrate_mask
>>>> -------------------------------------------------------------------------------------------------------
>>>> static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
>>>>                                       struct genl_info *info)
>>>> {
>>>>        struct nlattr *tb[NL80211_TXRATE_MAX + 1];
>>>>        struct cfg80211_registered_device *rdev = info->user_ptr[0];
>>>>        struct cfg80211_bitrate_mask mask;
>>>>        int rem, i;
>>>>        struct net_device *dev = info->user_ptr[1];
>>>>        struct nlattr *tx_rates;
>>>>        struct ieee80211_supported_band *sband;
>>>>
>>>>        if (info->attrs[NL80211_ATTR_TX_RATES] == NULL)
>>>>                return -EINVAL;
>>>>
>>>>        if (!rdev->ops->set_bitrate_mask)
>>>>                return -EOPNOTSUPP;
>>>>
>>>>        memset(&mask, 0, sizeof(mask));
>>>>        /* Default to all rates enabled */
>>>>        for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
>>>>                sband = rdev->wiphy.bands[i];
>>>>                mask.control[i].legacy =
>>>>                        sband ? (1 << sband->n_bitrates) - 1 : 0;
>>>>        }
>>>>
>>>>        /*
>>>>         * The nested attribute uses enum nl80211_band as the index. This maps
>>>>         * directly to the enum ieee80211_band values used in cfg80211.
>>>>         */
>>>>        nla_for_each_nested(tx_rates, info->attrs[NL80211_ATTR_TX_RATES], rem)
>>>>        {
>>>>                enum ieee80211_band band = nla_type(tx_rates);
>>>>                if (band < 0 || band >= IEEE80211_NUM_BANDS)
>>>>                        return -EINVAL;
>>>>                sband = rdev->wiphy.bands[band];
>>>>                if (sband == NULL)
>>>>                        return -EINVAL;
>>>>                nla_parse(tb, NL80211_TXRATE_MAX, nla_data(tx_rates),
>>>>                          nla_len(tx_rates), nl80211_txattr_policy);
>>>>                if (tb[NL80211_TXRATE_LEGACY]) {
>>>>                        mask.control[band].legacy = rateset_to_mask(
>>>>                                sband,
>>>>                                nla_data(tb[NL80211_TXRATE_LEGACY]),
>>>>                                nla_len(tb[NL80211_TXRATE_LEGACY]));
>>>>                        if (mask.control[band].legacy == 0)
>>>>                                return -EINVAL;
>>>>                }
>>>>        }
>>>>
>>>>        return rdev->ops->set_bitrate_mask(&rdev->wiphy, dev, NULL, &mask);
>>>> }
>>>
>>> As you see everything is for legacy thing and for MCS it's a TODO section.
>>>
>>>> ====================================================================================================================
>>>>
>>>>
>>>> Any help is much appreciated!
>>>>
>>>> Thank you all very much
>>>> _______________________________________________
>>>> ath9k-devel mailing list
>>>> ath9k-devel@lists.ath9k.org
>>>> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>>>>
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


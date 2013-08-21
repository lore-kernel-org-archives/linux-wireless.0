Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:61770 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3HUIgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 04:36:22 -0400
Received: by mail-ve0-f181.google.com with SMTP id jz10so84755veb.26
        for <linux-wireless@vger.kernel.org>; Wed, 21 Aug 2013 01:36:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377032397.13829.40.camel@jlt4.sipsolutions.net>
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
	<1377020479-16935-2-git-send-email-k.eugene.e@gmail.com>
	<1377032397.13829.40.camel@jlt4.sipsolutions.net>
Date: Wed, 21 Aug 2013 10:36:21 +0200
Message-ID: <CAFSJ42ZH3ZJ+-+6wUbqQvaM8D2t6oWqyqkGiGRRx4o2NA60EjA@mail.gmail.com> (sfid-20130821_103630_316599_5548F88F)
Subject: Re: [PATCH 01/16] wcn36xx: Add main.c
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Just a cursory review ...
>

Any review is very welcome;)

>
>> +             .cap = IEEE80211_HT_CAP_GRN_FLD
>> +                     | IEEE80211_HT_CAP_SGI_20
>
> wouldn't that usually be written as
>
> GRN_FLD |
> SGI_20 |
> ...
>
> (multiple similar places)

Will be fixed in the next round.


>> +#ifdef CONFIG_PM
>> +
>> +static const struct wiphy_wowlan_support wowlan_support = {
>> +     .flags = WIPHY_WOWLAN_ANY,
>> +     .n_patterns = 0,
>
> that n_patterns is pretty useless.
>

Will be removed in the next patch set.

>> +#define WCN36XX_SUPPORTED_FILTERS (0)
>> +
>> +static void wcn36xx_configure_filter(struct ieee80211_hw *hw,
>> +                                    unsigned int changed,
>> +                                    unsigned int *total, u64 multicast)
>> +{
>> +     wcn36xx_dbg(WCN36XX_DBG_MAC, "mac configure filter");
>> +
>> +     changed &= WCN36XX_SUPPORTED_FILTERS;
>
> That's pointless

Yes, it is better to remove wcn36xx_configure_filter completely for now.

>> +             if (IEEE80211_KEY_FLAG_PAIRWISE & key_conf->flags) {
>> +                     sta_priv->is_data_encrypted = true;
>> +                     /* Reconfigure bss with encrypt_type */
>> +                     if (NL80211_IFTYPE_STATION == vif->type)
>> +                             wcn36xx_smd_config_bss(wcn,
>> +                                                    vif,
>> +                                                    sta,
>> +                                                    sta->addr,
>> +                                                    true);
>
> It seems to me this should not be here but you should have mac80211 set
> something in e.g. bss_conf that indicates encryption?
>

It's a good idea and I tried to find anything encryption related in
bss_conf but without luck. I do not like this line myself so I would
really appreciate if you can point where exactly in
bss_conf/bss_info_changed information about encryption is located.

>> +     /* Not supported so far*/
>> +     case IEEE80211_AMPDU_TX_STOP_CONT:
>> +             ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
>> +             break;
>> +     case IEEE80211_AMPDU_TX_STOP_FLUSH:
>> +     case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
>> +             break;
>
> You can't just "not support" them - you have to at least stop the
> aggregation session, see the commit that introduced this.
>

Good point. Will fix this in the next round.

>> +     static const u32 cipher_suites[] = {
>> +             WLAN_CIPHER_SUITE_TKIP,
>> +             WLAN_CIPHER_SUITE_CCMP,
>> +     };
>
> You actually don't want to support WEP, not even in software? Otherwise
> just leave this out and mac80211 will add it.

WEP is supported by HW but wcn36xx does not configure it yet. Is that
ok to add HW WEP encryption in nearest future after wcn36xx is pushed
to upstream?

>> +     wcn->hw->wiphy->iface_combinations = &if_comb;
>> +     wcn->hw->wiphy->n_iface_combinations = 1;
>
> Your code with "wcn->current_vif = " etc. *really* doesn't look like you
> support combinations. Are you positive this is OK?

So far wcn36xx supports only one interface at once. But in the nearest
future it will definitely support more than one. So how about keeping
this for future?;)

>> +     wcn->hw->wiphy->max_scan_ssids = 1;
>
> Really? You don't even have hardware scan, so why?
>

Good catch. wcn36xx used to have hw scan but now it is moved to sw
scan. Will remove this completely.

> johannes
>



-- 
Best regards,
Eugene

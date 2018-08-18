Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 7.mo4.mail-out.ovh.net ([178.33.253.54]:37055 "EHLO
        7.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbeHSCgx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 22:36:53 -0400
Received: from player787.ha.ovh.net (unknown [10.109.143.232])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 9492A1957C9
        for <linux-wireless@vger.kernel.org>; Sat, 18 Aug 2018 23:02:00 +0200 (CEST)
Subject: Re: [PATCH v6 2/3] mac80211: Define new driver callback replace_key
To: Denis Kenzior <denkenz@gmail.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <20180814104255.4183-1-alexander@wetzel-home.de>
 <20180814104255.4183-3-alexander@wetzel-home.de>
 <6b36b011-d02e-778b-d7a1-951ab8aee721@gmail.com>
From: Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <43174c6c-5745-ab9b-4adf-a67cce9c0404@wetzel-home.de> (sfid-20180819_012806_296674_2AFBDEE9)
Date: Sat, 18 Aug 2018 23:01:49 +0200
MIME-Version: 1.0
In-Reply-To: <6b36b011-d02e-778b-d7a1-951ab8aee721@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
> Hi Alexander,
> 
> Just minor nitpicks:
> 
>> + * @replace_key: Replace an exiting in use key with a new one while
>> guaranteeing
>> + *     to not leak clear text packets. Implementing this callback
>> will enable
>> + *     mac80211 to announce NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE.
>> + *     Packets already queued must not be send out encrypted with the
>> new key
> send out -> sent out

fixed in local git. Will wait some days for more feedback and then post v7.

>> + *     and packets decoded with the old key must not be handed over
>> to mac80211
>> + *     when the driver is not checking IV/ICV itself once the
>> callback has been
>> + *     completed.
>> + *     Mac80211 will log an error when asked to use replace a PTK key
>> + *     without replace_key but will still perform the then potentially
>> + *     insecure action via set_key for backward compatibility for now.
>> + *
> 
> Not sure this part really belongs in the driver method description?
>
>>    * @update_tkip_key: See the section "Hardware crypto acceleration"
>>    *     This callback will be called in the context of Rx. Called for
>> drivers
>>    *     which set IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
> 
> <snip>
>

I'll update that and move parts of it to the "Hardware crypto
acceleration" DOC section.

>> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
>> index 4fb2709cb527..84cc8005c19a 100644
>> --- a/net/mac80211/main.c
>> +++ b/net/mac80211/main.c
>> @@ -572,9 +572,14 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t
>> priv_data_len,
>>                         NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT);
>>       }
>>   +    if (ops->replace_key)
>> +        wiphy_ext_feature_set(wiphy,
>> +                      NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE);
>> +
>>       if (!ops->set_key)
>>           wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
>>   +
> 
> Stray whitespace?
> 
Yup, the new line makes zero sense. will also be fixed in v7.

>>       if (ops->wake_tx_queue)
>>           wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_TXQS);
>>   
> 
> Regards,
> -Denis

Alexander

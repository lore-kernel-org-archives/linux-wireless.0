Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37377 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbeHULBe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 07:01:34 -0400
Received: by mail-lf1-f66.google.com with SMTP id j8-v6so12881853lfb.4
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2018 00:42:31 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: remove division by size of sizeof(struct
 ieee80211_wmm_rule)
From: =?UTF-8?Q?Grzegorz_Duszy=c5=84ski?= <gfduszynski@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
References: <20180820073705.9683-1-johannes@sipsolutions.net>
 <20180820102710.GA2760@redhat.com>
 <63f44789-11c3-0549-b8b8-cd3b25c40547@gmail.com>
Message-ID: <ab4253e0-e339-e9b2-d9bc-43e8b9592e6e@gmail.com> (sfid-20180821_094234_623763_C3E8272F)
Date: Tue, 21 Aug 2018 09:42:28 +0200
MIME-Version: 1.0
In-Reply-To: <63f44789-11c3-0549-b8b8-cd3b25c40547@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21.08.2018 08:23, Grzegorz Duszyński wrote:
> On 20.08.2018 12:27, Stanislaw Gruszka wrote:
>> On Mon, Aug 20, 2018 at 09:37:05AM +0200, Johannes Berg wrote:
>>> From: Johannes Berg <johannes.berg@intel.com>
>>>
>>> Pointer arithmetic already adjusts by the size of the struct,
>>> so the sizeof() calculation is wrong. This is basically the
>>> same as Colin King's patch for similar code in the iwlwifi
>>> driver.
>>>
>>> Fixes: 230ebaa189af ("cfg80211: read wmm rules from regulatory 
>>> database")
>>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>> ---
>>>   net/wireless/reg.c | 3 +--
>>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>>> index 4fc66a117b7d..283902974fbf 100644
>>> --- a/net/wireless/reg.c
>>> +++ b/net/wireless/reg.c
>>> @@ -452,8 +452,7 @@ reg_copy_regd(const struct ieee80211_regdomain 
>>> *src_regd)
>>>               continue;
>>>             regd->reg_rules[i].wmm_rule = d_wmm +
>>> -            (src_regd->reg_rules[i].wmm_rule - s_wmm) /
>>> -            sizeof(struct ieee80211_wmm_rule);
>>> +            (src_regd->reg_rules[i].wmm_rule - s_wmm);
>>>       }
>>>       return regd;
>>>   }
>> As side note those pointer aritmetics related with rule->wmm_rule is
>> really involuted in various places in reg.c . Seems would be better to
>> just make wmm_rule part of iee80211_reg_rule structure like this:
>>
>> struct ieee80211_reg_rule {
>>          struct ieee80211_freq_range freq_range;
>>          struct ieee80211_power_rule power_rule;
>>          struct ieee80211_wmm_rule wmm_rule;
>>          u32 flags;
>>          u32 dfs_cac_ms;
>> };
>>
>> and use a flag to intdicate wmm_rule is valid. There should be no
>> big memory overhead sice there are only few reg_rules for the regdomain.
>> Or I'm wrong?
>>
>> Regards
>> Stanislaw
>
> Thank you for the patch.
>
> I've applied the patch, but it does not seem to help.
> Spawning second instance of hostapd causes same error as before.
>
> I don't follow why this issue would not occur with single NIC.
> It's not like I am an expert in this field, but those rules should be 
> applied to both interfaces, right?
> Both interfaces use ath10k, that should imply same code path for 
> setting rules.
>

Issue has also been experienced by other Arch user:
https://bbs.archlinux.org/viewtopic.php?pid=1803445#p1803445

User chr0mag also reports that LTS version of Arch kernel does not 
exhibit this issue.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:33197 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbdFUIsa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 04:48:30 -0400
Received: by mail-wr0-f177.google.com with SMTP id r103so125154761wrb.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jun 2017 01:48:30 -0700 (PDT)
Subject: Re: [RFC] mac80211: support non-data TXQs
To: Johannes Berg <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20170620210309.1193-1-johannes@sipsolutions.net>
 <c8637109-0292-23af-8bc6-8a7ba8e19595@quantenna.com>
 <1498028959.4955.1.camel@sipsolutions.net>
 <1498034220.4955.3.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <23cd1255-32a3-84c2-77d1-4cd29bdc81dd@broadcom.com> (sfid-20170621_104836_051158_8F0E9A88)
Date: Wed, 21 Jun 2017 10:48:27 +0200
MIME-Version: 1.0
In-Reply-To: <1498034220.4955.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/21/2017 10:37 AM, Johannes Berg wrote:
> On Wed, 2017-06-21 at 09:09 +0200, Johannes Berg wrote:
>> On Tue, 2017-06-20 at 21:19 -0700, Igor Mitsyanko wrote:
>>
>>>> -	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
>>>> +	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS + 1];
>>>
>>> Isn't that a little confusing? Wouldn't it be better to have a
>>> separate  member for non-data txq and name it accordingly
>>> (something
>>> like  txq_nodata).
>>
>> We do this trick in quite a number of places, so it shouldn't really
>> come as a surprise.
>>
>>> You have to handle it specially in most cases anyway I guess.
>>> With this approach you won't have to replace ARRAY_SIZE(sta->txq)
>>> by IEEE80211_NUM_TIDS anywhere.
>>
>> Yeah, that would indeed be a good reason - I didn't realize the
>> ARRAY_SIZE() when I originally wrote the patch. And yes, I do need to
>> treat it specially - except then if it's separate I also have to
>> initialize it separately, so it's a bit of a trade-off.
> 
> I changed my mind on changing this, the allocation, initialization and
> teardown etc. just gets much more complicated with doing that, needing
> special cases in quite a number of places.

So for the sake of ath{9,10}k and possible future drivers you may want 
to document it clearly in mac80211.h(?), ie. when driver does not want a 
separate non-data txq they should use IEEE80211_NUM_TIDS.

Regards,
Arend

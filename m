Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57803 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750800AbdJRR4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 13:56:55 -0400
Subject: Re: Setting single rate in ath10k broken by "reject/clear user rate
 mask if not usable"
To: Ben Greear <greearb@candelatech.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, kirtika@google.com
References: <13895fa0-3685-dd2b-583d-2d6469d23cfe@candelatech.com>
 <1507708948.1998.15.camel@sipsolutions.net>
 <2c293255-aa79-75a0-1c28-994f864cddf4@candelatech.com>
 <1508312033.2674.9.camel@sipsolutions.net>
 <2ad42671-59c4-80ed-4bca-f874eb53d653@candelatech.com>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <8c2e0e98-f3f4-6e0c-1bf0-43dfa6e97275@rempel-privat.de> (sfid-20171018_195717_918897_D9A0F5BE)
Date: Wed, 18 Oct 2017 19:56:16 +0200
MIME-Version: 1.0
In-Reply-To: <2ad42671-59c4-80ed-4bca-f874eb53d653@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 18.10.2017 um 16:50 schrieb Ben Greear:
> 
> 
> On 10/18/2017 12:33 AM, Johannes Berg wrote:
>> Hi,
>>
>>> The call to set the rate in the driver comes before the error
>>> check.
>>>
>>>     if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
>>>         ret = drv_set_bitrate_mask(local, sdata, mask);
>>>         if (ret) {
>>>             pr_err("%s: drv-set-bitrate-mask had error
>>> return: %d\n",
>>>                    sdata->dev->name, ret);
>>>             return ret;
>>>         }
>>>     }
>>>
>>>     /*
>>>      * If active validate the setting and reject it if it doesn't
>>> leave
>>>      * at least one basic rate usable, since we really have to be
>>> able
>>>      * to send something, and if we're an AP we have to be able to
>>> do
>>>      * so at a basic rate so that all clients can receive it.
>>>      */
>>>     if (rcu_access_pointer(sdata->vif.chanctx_conf) &&
>>>         sdata->vif.bss_conf.chandef.chan) {
>>>         u32 basic_rates = sdata->vif.bss_conf.basic_rates;
>>>         enum nl80211_band band = sdata-
>>>> vif.bss_conf.chandef.chan->band;
>>>
>>>         if (!(mask->control[band].legacy & basic_rates)) {
>>>             #### I changed this code so I could set a
>>> single rate... --Ben
>>>             pr_err("%s:  WARNING: no legacy rates for
>>> band[%d] in set-bitrate-mask.\n",
>>>                    sdata->dev->name, band);
>>>         }
>>>     }
>>
>> Heh, that's just dumb. I guess I'll fix that by putting the test first,
>> no idea how that happened.
>>
>>>>
>>>>> So, I think we should relax this check, at least for ath10k.
>>>>
>>>> Well, yes and no. I don't think we should make ath10k special here,
>>>> and
>>>> this fixes a real problem - namely that you can set up the system
>>>> so
>>>> that you have no usable rates at all, and then you just get a
>>>> WARN_ON
>>>> and start using the lowest possible rate...
>>>
>>> Well, there are a million ways to set up a broken system,
>>
>> True, but this one actually happened in practice, for some reason, and
>> stopping the user from constantly shooting themselves in the foot seems
>> like a good idea to me. Especially if the user (or application) can't
>> really even know what they're getting into.
>>
>> Now, the case in question was _client_ mode, but still.
>>
>>> and setting a single rate has a useful purpose, especially with
>>> ath10k since it has such limited rate-setting capabilities.
>>
>> You're stretching the definition of "useful purpose" a bit here though,
>> you're about the only one who's ever going to need to set a single
>> rate.
> 
> People trying to do regulatory testing want this feature, and other people
> that are not me also like to test with specific rates.  Still a 
> small-ish set
> of people, but bigger than just me at least.

Till now i was interviewing different people who was asking for this for 
ath9k-htc. So I would say we have:
- academical researchers
- testers
- R&D
- exploit and penetration testers
- HAM
- just hackers

As for me, it sounds a s lot.


-- 
Regards,
Oleksij

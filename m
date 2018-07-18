Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51724 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730885AbeGRQiy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jul 2018 12:38:54 -0400
Subject: Re: Setting tx retry count in ath10k
To: Jean-Pierre TOSONI <jp.tosoni@acksys.fr>,
        SEDE <s.deronne@televic.com>,
        Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        ath10k <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <b0f67dd7-dea9-508e-7ad9-f6db3ac88b90@candelatech.com>
 <e9b42b3d-2d03-ca69-5532-fbae08fdec5d@uni-rostock.de>
 <8b9713fe-7573-f009-d002-13df73315898@televic.com>
 <9dd76e58-b514-26f2-2fe9-0c9a7f798054@candelatech.com>
 <AM4PR0101MB2305917B39A84BBE13FDFAD1E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <ea2ff457-e84e-8395-148d-8d90a749a40d@candelatech.com> (sfid-20180718_180024_977565_AC01D24A)
Date: Wed, 18 Jul 2018 09:00:19 -0700
MIME-Version: 1.0
In-Reply-To: <AM4PR0101MB2305917B39A84BBE13FDFAD1E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/18/2018 08:50 AM, Jean-Pierre TOSONI wrote:
> Hi,
>
> We made retries configurable in our mac80211+ath9k system, and we ended with 3 counts:
> 1) short retry count, defaults to 4
> 2) long retrys count, defauts to 7
> 3) software retry count, defaults to 30
> This last one is used separately for each frame in an aggregated frame, since they can be separately acknowledged.

Did you have to change code for #3, and if so, can you share the patch?

I wonder also if retries should be different for different types of data.  For instance,
if someone is using UDP, maybe they don't care so much about lost packets and would
prefer a lower retry count.  Or, maybe IP type-of-service could be taken into account
and retry frames different amounts based on ToS?

Thanks,
Ben

>
> Regards,
> Jean-Pierre
>
>> -----Message d'origine-----
>> De : linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] De la part de
>> Ben Greear
>> Envoyé : mardi 17 juillet 2018 17:08
>> À : SEDE; Benjamin Beichler; ath10k; linux-wireless@vger.kernel.org
>> Objet : Re: Setting tx retry count in ath10k
>>
>>
>>
>> On 07/17/2018 12:56 AM, SEDE wrote:
>>> Hi,
>>>
>>> In the standard, 7 is the default for the short retry count, 4 is well the default for long retry
>> count.
>>>
>>> In ath10k, there is also non_agg_sw_retry_th to control this, will this still be used?
>>> Or what is the difference with rc_num_retries?
>>>
>>> Kind regards,
>>> Sébastien.
>>
>> The ath10k firmware has no idea of long vs short retries, so I just used the
>> long setting.
>>
>> I will investigate that non_agg_sw_retry_th as well, and I did notice my wave-1
>> firmware (at least) uses 15 retries for self-generated frames.  But, in my case,
>> those self-gen frames are not much used anyway since I disable firmware keep-alive.
>>
>> And, I need to see how the mac80211 stack handles its own retries when working
>> with ath10k.
>>
>> Thanks,
>> Ben
>>
>>>
>>>
>>> On 2018-07-17 09:39, Benjamin Beichler wrote:
>>>> Hi,
>>>>
>>>> Am 17.07.2018 um 02:37 schrieb Ben Greear:
>>>>> I spent a bit of time looking into setting the tx retry count in
>>>>> ath10k (wave-1 firmware).  The firmware has support for setting this as
>>>>> a vdev parameter, and it defaults to '2', at least in my wave-1 firmware.
>>>>>
>>>>> I enabled propagating the setting from mac80211, ie:
>>>>> iw phy wiphy0 set retry short 2 long 2
>>>>>
>>>>> And while debugging this, I noticed that mac80211 has a default of
>>>>> 4, but the ath10k firmware has a default of 2.  Now, I am not sure
>>>>> if I should enable setting the retry count since it will change
>>>>> the behaviour even if users don't set anything.
>>>>>
>>>> Maybe I'm wrong, but I have in mind, that 7 retries is the default
>>>> setting of mac80211. Although 2 or even 4 seems to be pretty low for the
>>>> overall retry count, so maybe the values are somehow changed in the
>>>> firmware? From our experiments we know (at least for 802.11n) you need
>>>> for normal operation a retry count of something between 5 - 9, but
>>>> sometimes also 12 or 15 is beneficial.
>>>>
>>>> We use for our experimental setup mainly ath9k cards and rt28xx nics,
>>>> and with them you need definitely more retries.
>>>>
>>>> Nonetheless, I don't think the change from 2 to 4 does really affect the
>>>> behavior in a negative way (if it works as expected).
>>>>
>>>>> Any opinions on this?
>>>>>
>>>>> Thanks,
>>>>> Ben
>>>>>
>>>
>>
>> --
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

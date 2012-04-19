Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20068 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab2DSOnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 10:43:43 -0400
Message-ID: <4F902499.2020902@qca.qualcomm.com> (sfid-20120419_164346_819373_84221344)
Date: Thu, 19 Apr 2012 20:13:37 +0530
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Validate legacy rateset.
References: <1334298173-4132-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120413_082304_815922_B50E6F19) <4F8C5776.6060209@sipsolutions.net> <4F8D24CC.5030205@qca.qualcomm.com> <4F8D7758.6040304@sipsolutions.net> <4F8E592B.6010104@qca.qualcomm.com> <4F8ECEF4.4010507@sipsolutions.net>
In-Reply-To: <4F8ECEF4.4010507@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/18/2012 07:55 PM, Johannes Berg wrote:
> On 4/17/2012 11:03 PM, Bala Shanmugam wrote:
>> On 04/17/2012 07:29 PM, Johannes Berg wrote:
>>> On 4/17/2012 1:07 AM, Bala Shanmugam wrote:
>>>> On 04/16/2012 11:01 PM, Johannes Berg wrote:
>>>>> On 4/12/2012 11:22 PM, Bala Shanmugam wrote:
>>>>>> Legacy rates are not validated while configuring
>>>>>> tx rateset using iw. So below cmd is accepted by nl80211.
>>>>>> sudo iw wlan2 set bitrates legacy-2.4 3
>>>>>>
>>>>>> Validate legacy rates and return
>>>>>> error while configuring improper rates.
>>>>>>
>>>>>> Signed-off-by: Bala Shanmugam<bkamatch@qca.qualcomm.com>
>>>>>> ---
>>>>>> net/wireless/nl80211.c | 2 ++
>>>>>> 1 files changed, 2 insertions(+), 0 deletions(-)
>>>>>>
>>>>>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>>>>>> index e49da27..cc7bef7 100644
>>>>>> --- a/net/wireless/nl80211.c
>>>>>> +++ b/net/wireless/nl80211.c
>>>>>> @@ -5540,6 +5540,8 @@ static int nl80211_set_tx_bitrate_mask(struct
>>>>>> sk_buff *skb,
>>>>>> sband,
>>>>>> nla_data(tb[NL80211_TXRATE_LEGACY]),
>>>>>> nla_len(tb[NL80211_TXRATE_LEGACY]));
>>>>>> + if (mask.control[band].legacy == 0)
>>>>>> + return -EINVAL;
>>>>>
>>>>> I don't think this is right since it would also reject an
>>>>> intentionally empty set.
>>>
>>>> This check comes into picture only when legacy rates are configured.
>>>> For intentionally empty set "if (tb[NL80211_TXRATE_LEGACY])" condition
>>>> will fail and control will not come here. I tested the same.
>>>> With this patch
>>>> "sudo iw wlan0 set bitrates mcs-5 6" executes without any error 
>>>> message.
>>>
>>> However, that means "don't change legacy settings", not "empty legacy
>>> rateset".
>>>
>>> johannes
>> Good catch.
>> I didn't think of below configuration which is to specify empty legacy
>> rateset for 2.4 band.
>> sudo iw wlan0 set bitrates legacy-2.4
>> Correct me if I am wrong.
>>
>> Anyway we need to reject invalid legacy rates and below additional check
>> will allow empty rateset
>> and block invalid rates
>> if (mask.control[band].legacy == 0 && 
>> nla_len(tb[NL80211_TXRATE_LEGACY]))
>> return -EINVAL;
>
> But then you can still say
>
> sudo iw wlan0 set bitrates legacy-2.4 1 2 3 4
>
> and have it be accepted which is wrong as well.
>
> You really should verify every single rate.
>
> johannes

rateset_to_mask function will return zero if it couldn't find any of the 
rates in the rateset
or for empty rateset.
mask.control[band].legacy is return value of rateset_to_mask, so above 
command you mentioned will
not be accepted.  I tested the same.

Regards,
Bala.





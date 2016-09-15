Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16928 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934451AbcION7y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 09:59:54 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 04/21] ath10k: rate-limit packet tx errors
Date: Thu, 15 Sep 2016 13:59:48 +0000
Message-ID: <87sht1b6wc.fsf@kamboji.qca.qualcomm.com> (sfid-20160915_155958_332028_DEF11CF5)
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
        <1462986153-16318-5-git-send-email-greearb@candelatech.com>
        <87wpieefr9.fsf@kamboji.qca.qualcomm.com>       <57D96669.20209@candelatech.com>
In-Reply-To: <57D96669.20209@candelatech.com> (Ben Greear's message of "Wed,
        14 Sep 2016 08:02:01 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 09/14/2016 07:07 AM, Valo, Kalle wrote:
>> greearb@candelatech.com writes:
>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> When firmware crashes, stack can continue to send packets
>>> for a bit, and existing code was spamming logs.
>>>
>>> So, rate-limit the error message for tx failures.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>> ---
>>>   drivers/net/wireless/ath/ath10k/mac.c | 5 +++--
>>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wirele=
ss/ath/ath10k/mac.c
>>> index cd3016d..42cac32 100644
>>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>>> @@ -3432,8 +3432,9 @@ static int ath10k_mac_tx_submit(struct ath10k *ar=
,
>>>   	}
>>>
>>>   	if (ret) {
>>> -		ath10k_warn(ar, "failed to transmit packet, dropping: %d\n",
>>> -			    ret);
>>> +		if (net_ratelimit())
>>> +			ath10k_warn(ar, "failed to transmit packet, dropping: %d\n",
>>> +				    ret);
>>>   		ieee80211_free_txskb(ar->hw, skb);
>>>   	}
>>
>> ath10k_warn() is already rate limited. If there's something wrong then
>> that function should be fixed, not the callers.
>>
>> void ath10k_warn(struct ath10k *ar, const char *fmt, ...)
>> {
>> 	struct va_format vaf =3D {
>> 		.fmt =3D fmt,
>> 	};
>> 	va_list args;
>>
>> 	va_start(args, fmt);
>> 	vaf.va =3D &args;
>> 	dev_warn_ratelimited(ar->dev, "%pV", &vaf);
>> 	trace_ath10k_log_warn(ar, &vaf);
>>
>> 	va_end(args);
>> }
>
> The problem with having the ratelimit here is that you may miss
> rare warnings due to a flood of common warnings.
>
> That is why it is still useful to ratelimit potential floods
> of warnings.

I think this is a common problem in kernel, not specific to ath10k. For
starters you could configure the limits dev_warn_ratelimited() has, not
trying to workaround it in the driver.

> I would like to remove the ratelimit from ath10k_warn eventually.

I think that's not a good idea, it might cause unnecessary host reboots
in problem cases. Rate limitting the messages is much better option.

--=20
Kalle Valo=

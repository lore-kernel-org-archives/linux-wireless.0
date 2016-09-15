Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37770 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbcIOPWj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 11:22:39 -0400
Subject: Re: [PATCH v2 04/21] ath10k: rate-limit packet tx errors
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
 <1462986153-16318-5-git-send-email-greearb@candelatech.com>
 <87wpieefr9.fsf@kamboji.qca.qualcomm.com> <57D96669.20209@candelatech.com>
 <87sht1b6wc.fsf@kamboji.qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <afc73fcc-d6cc-e2b4-33dc-87394b640675@candelatech.com> (sfid-20160915_172259_466792_C4A2BC0C)
Date: Thu, 15 Sep 2016 08:22:37 -0700
MIME-Version: 1.0
In-Reply-To: <87sht1b6wc.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2016 06:59 AM, Valo, Kalle wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> On 09/14/2016 07:07 AM, Valo, Kalle wrote:
>>> greearb@candelatech.com writes:
>>>
>>>> From: Ben Greear <greearb@candelatech.com>
>>>>
>>>> When firmware crashes, stack can continue to send packets
>>>> for a bit, and existing code was spamming logs.
>>>>
>>>> So, rate-limit the error message for tx failures.
>>>>
>>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>>> ---
>>>>   drivers/net/wireless/ath/ath10k/mac.c | 5 +++--
>>>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>>>> index cd3016d..42cac32 100644
>>>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>>>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>>>> @@ -3432,8 +3432,9 @@ static int ath10k_mac_tx_submit(struct ath10k *ar,
>>>>   	}
>>>>
>>>>   	if (ret) {
>>>> -		ath10k_warn(ar, "failed to transmit packet, dropping: %d\n",
>>>> -			    ret);
>>>> +		if (net_ratelimit())
>>>> +			ath10k_warn(ar, "failed to transmit packet, dropping: %d\n",
>>>> +				    ret);
>>>>   		ieee80211_free_txskb(ar->hw, skb);
>>>>   	}
>>>
>>> ath10k_warn() is already rate limited. If there's something wrong then
>>> that function should be fixed, not the callers.
>>>
>>> void ath10k_warn(struct ath10k *ar, const char *fmt, ...)
>>> {
>>> 	struct va_format vaf = {
>>> 		.fmt = fmt,
>>> 	};
>>> 	va_list args;
>>>
>>> 	va_start(args, fmt);
>>> 	vaf.va = &args;
>>> 	dev_warn_ratelimited(ar->dev, "%pV", &vaf);
>>> 	trace_ath10k_log_warn(ar, &vaf);
>>>
>>> 	va_end(args);
>>> }
>>
>> The problem with having the ratelimit here is that you may miss
>> rare warnings due to a flood of common warnings.
>>
>> That is why it is still useful to ratelimit potential floods
>> of warnings.
>
> I think this is a common problem in kernel, not specific to ath10k. For
> starters you could configure the limits dev_warn_ratelimited() has, not
> trying to workaround it in the driver.

I will try to explain this once more.

If you have the ratelimit in a centralized place, then all code that calls it
is rate-limitted with same counter and each call site gets the same priority.

One verbose caller can thus disable logs for the much more rare callers.

My patch pre-filters one of the verbose callers, which lets other more
rare and interesting callers be more likely to print logging messages
that are useful for debugging.

>> I would like to remove the ratelimit from ath10k_warn eventually.
>
> I think that's not a good idea, it might cause unnecessary host reboots
> in problem cases. Rate limitting the messages is much better option.

Ok, but even so, that would be a later patch and that is not a reason
to reject the one I posted.

For what it is worth, I and my users have been running such a patch for years
in various embedded and other systems and it works fine.

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

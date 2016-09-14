Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54754 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763000AbcINPCC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 11:02:02 -0400
Message-ID: <57D96669.20209@candelatech.com> (sfid-20160914_170205_891093_7AC918B4)
Date: Wed, 14 Sep 2016 08:02:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 04/21] ath10k: rate-limit packet tx errors
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com> <1462986153-16318-5-git-send-email-greearb@candelatech.com> <87wpieefr9.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87wpieefr9.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/14/2016 07:07 AM, Valo, Kalle wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> When firmware crashes, stack can continue to send packets
>> for a bit, and existing code was spamming logs.
>>
>> So, rate-limit the error message for tx failures.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/mac.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index cd3016d..42cac32 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -3432,8 +3432,9 @@ static int ath10k_mac_tx_submit(struct ath10k *ar,
>>   	}
>>
>>   	if (ret) {
>> -		ath10k_warn(ar, "failed to transmit packet, dropping: %d\n",
>> -			    ret);
>> +		if (net_ratelimit())
>> +			ath10k_warn(ar, "failed to transmit packet, dropping: %d\n",
>> +				    ret);
>>   		ieee80211_free_txskb(ar->hw, skb);
>>   	}
>
> ath10k_warn() is already rate limited. If there's something wrong then
> that function should be fixed, not the callers.
>
> void ath10k_warn(struct ath10k *ar, const char *fmt, ...)
> {
> 	struct va_format vaf = {
> 		.fmt = fmt,
> 	};
> 	va_list args;
>
> 	va_start(args, fmt);
> 	vaf.va = &args;
> 	dev_warn_ratelimited(ar->dev, "%pV", &vaf);
> 	trace_ath10k_log_warn(ar, &vaf);
>
> 	va_end(args);
> }

The problem with having the ratelimit here is that you may miss
rare warnings due to a flood of common warnings.

That is why it is still useful to ratelimit potential floods
of warnings.

I would like to remove the ratelimit from ath10k_warn eventually.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

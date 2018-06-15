Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35856 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964930AbeFOTi2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 15:38:28 -0400
Received: by mail-lf0-f66.google.com with SMTP id n24-v6so468930lfh.3
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2018 12:38:27 -0700 (PDT)
Subject: Re: [PATCH] ath10k: fix bug in masking of TID value
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
References: <20180615120153.4677-1-erik.stromdahl@gmail.com>
 <878t7g6wbg.fsf@kamboji.qca.qualcomm.com>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <56e67584-366a-0a1a-916d-f75a54ae1d32@gmail.com> (sfid-20180615_213832_440179_61C2AABA)
Date: Fri, 15 Jun 2018 21:38:25 +0200
MIME-Version: 1.0
In-Reply-To: <878t7g6wbg.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On 06/15/2018 02:58 PM, Kalle Valo wrote:
> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
> 
>> Although the TID mask is 0xf, the modulus operation does still not
>> produce identical results as the bitwise and operator.
>>
>> If the TID is 15, the modulus operation will "convert" it to 0, whereas
>> the bitwise and will keep it as 15.
>>
>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/htt_tx.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
>> index 89157c5b5e5f..be5b52aaffa6 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
>> @@ -1056,7 +1056,7 @@ static u8 ath10k_htt_tx_get_tid(struct sk_buff *skb, bool is_eth)
>>   	if (!is_eth && ieee80211_is_mgmt(hdr->frame_control))
>>   		return HTT_DATA_TX_EXT_TID_MGMT;
>>   	else if (cb->flags & ATH10K_SKB_F_QOS)
>> -		return skb->priority % IEEE80211_QOS_CTL_TID_MASK;
>> +		return skb->priority & IEEE80211_QOS_CTL_TID_MASK;
> 
> I guess you just found this during code review? If yes, I'll add that to
> the commit log.
> 
Correct, I kind of stumbled upon it while working with TX bundling for SDIO.

--
Erik

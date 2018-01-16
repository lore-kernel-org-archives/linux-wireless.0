Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39097 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbeAPUMM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 15:12:12 -0500
Received: by mail-wm0-f68.google.com with SMTP id i11so11062844wmf.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jan 2018 12:12:11 -0800 (PST)
Subject: Re: [PATCH v2 05/10] rtlwifi: enable mac80211 fast-tx support
To: Kalle Valo <kvalo@codeaurora.org>, pkshih@realtek.com
References: <20180111070932.9929-1-pkshih@realtek.com>
 <20180111070932.9929-6-pkshih@realtek.com> <871sip24fc.fsf@purkki.adurom.net>
Cc: Larry.Finger@lwfinger.net, yhchuang@realtek.com,
        linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A5E5C99.5020607@broadcom.com> (sfid-20180116_211216_753091_08EEF52B)
Date: Tue, 16 Jan 2018 21:12:09 +0100
MIME-Version: 1.0
In-Reply-To: <871sip24fc.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/16/2018 4:45 PM, Kalle Valo wrote:
> <pkshih@realtek.com> writes:
>
>> From: Ping-Ke Shih <pkshih@realtek.com>
>>
>> To enable the mac80211 fast-tx feature, the hw/driver needs to support
>> dynamic power saving and fragmentation. Since our driver does not
>> need to fragment packet into smaller pieces, we just hook an empty
>> callback of set_frag_threshold to avoid fragmentation in mac80211.
>>
>> After this, the mac80211 will not fragment the packets and can transmit
>> them faster by cache the header information.
>>
>> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>
> [...]
>
>> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
>> @@ -1001,6 +1001,11 @@ static void rtl_op_sta_statistics(struct ieee80211_hw *hw,
>>   	sinfo->filled = 0;
>>   }
>>
>> +static int rtl_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
>> +{
>> +	return -EOPNOTSUPP;
>> +}
>> +
>>   /*
>>    *for mac80211 VO = 0, VI = 1, BE = 2, BK = 3
>>    *for rtl819x  BE = 0, BK = 1, VI = 2, VO = 3
>> @@ -1906,6 +1911,7 @@ const struct ieee80211_ops rtl_ops = {
>>   	.configure_filter = rtl_op_configure_filter,
>>   	.set_key = rtl_op_set_key,
>>   	.sta_statistics = rtl_op_sta_statistics,
>> +	.set_frag_threshold = rtl_op_set_frag_threshold,
>
> This also looks fishy, I guess there's a good reason why mac80211
> requires set_frag_threshold()? To me this is just a workaround for a
> mac80211 test.

When I saw this flying by I had the same feeling. This is clearly not 
how it was intended although you could interpret the comments of the 
.set_frag_threshold() callback and IEEE80211_HW_SUPPORTS_TX_FRAG. 
However, the fragmentation threshold is a user-configurable stack 
parameter as per the standard. This patch effectively kill that option 
for the user although there may be RF conditions in which fragmentation 
can help. Having the user configure a fragmentation threshold of 2346 
also disables fragmentation and allows mac80211 to use cached fastpath.

In short this should be NACK'ed.

Regards,
Arend

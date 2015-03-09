Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46216 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbbCIQ1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 12:27:37 -0400
Received: by wiwh11 with SMTP id h11so12261754wiw.5
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 09:27:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54FDBEE4.8090706@lwfinger.net>
References: <1425913628-6415-1-git-send-email-ap420073@gmail.com>
	<54FDBEE4.8090706@lwfinger.net>
Date: Tue, 10 Mar 2015 01:27:36 +0900
Message-ID: <CAMArcTXsoZSaeuc8-z+nxB4-18dMP5d_BjMPsA86mtoKzt-CDA@mail.gmail.com> (sfid-20150309_172740_950847_921DFACD)
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Remove unnecessary parameter
From: "ap420073 ." <ap420073@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-03-10 0:40 GMT+09:00 Larry Finger <Larry.Finger@lwfinger.net>:
>
> On 03/09/2015 10:07 AM, Taehee Yoo wrote:
>>
>> Remove unnecessary parameter in rtl8192cu/hw.c
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>> ---
>>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>
>
> The patch is OK, but the subject is awful. When I first saw it, I thought that you were removing a module parameter. On inspection, I see that you are removing function arguments from _beacon_function_enable(). Why not say that?
>
> Larry
>
>
>>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>> index 0c20dd7..43b2b20 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>> @@ -1471,8 +1471,7 @@ static void _InitBeaconParameters(struct ieee80211_hw *hw)
>>                 rtl_write_word(rtlpriv, REG_BCNTCFG, 0x66FF);
>>   }
>>
>> -static void _beacon_function_enable(struct ieee80211_hw *hw, bool Enable,
>> -                                   bool Linked)
>> +static void _beacon_function_enable(struct ieee80211_hw *hw)
>>   {
>>         struct rtl_priv *rtlpriv = rtl_priv(hw);
>>
>> @@ -1517,7 +1516,7 @@ void rtl92cu_set_beacon_related_registers(struct ieee80211_hw *hw)
>>                 rtl_write_byte(rtlpriv, REG_RXTSF_OFFSET_CCK, 0x50);
>>                 rtl_write_byte(rtlpriv, REG_RXTSF_OFFSET_OFDM, 0x50);
>>         }
>> -       _beacon_function_enable(hw, true, true);
>> +       _beacon_function_enable(hw);
>>   }
>>
>>   void rtl92cu_set_beacon_interval(struct ieee80211_hw *hw)
>>
>

Apologize that i do not explain this patch.

arguments Enable, Linked is not used in _beacon_function_enable() function.

in vendor driver, that function have same arguments but this is not used.

so i removed this argument.


I think simple code is not need detailed explain.

this is my fault.

from now on i surely say that detailed patch comment.

Thanks for review.

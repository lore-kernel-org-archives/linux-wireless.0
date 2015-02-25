Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53677 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbbBYS7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 13:59:24 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so7348562wid.5
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 10:59:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54EE157D.3050101@lwfinger.net>
References: <1424887133-5670-1-git-send-email-ap420073@gmail.com>
	<54EE157D.3050101@lwfinger.net>
Date: Thu, 26 Feb 2015 03:59:23 +0900
Message-ID: <CAMArcTW+UM62th3CZ-hhmPiH0-hzo4-f6qB2O9q7ktK4tLtuOQ@mail.gmail.com> (sfid-20150225_195928_129614_D6C072B6)
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Add case in rtl92cu_get_hw_reg
From: "ap420073 ." <ap420073@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ap420073 <ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-02-26 3:33 GMT+09:00 Larry Finger <Larry.Finger@lwfinger.net>:
> On 02/25/2015 11:58 AM, Taehee Yoo wrote:
>>
>> rtl_op_stop get wowlan state but rtl92cu_get_hw_reg has not process.
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>
>
> Has this been tested? I am not aware that the RTL8192CU firmware could
> handle WOWLAN.
>
> Larry
>
>
>> ---
>>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>> b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>> index fe4b699..f6ad959 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>> @@ -1589,6 +1589,12 @@ void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8
>> variable, u8 *val)
>>         case HW_VAR_DATA_FILTER:
>>                 *((u16 *) (val)) = rtl_read_word(rtlpriv, REG_RXFLTMAP2);
>>                 break;
>> +       case HAL_DEF_WOWLAN:
>> +               if (ppsc->wo_wlan_mode)
>> +                       *((bool *)(val)) = true;
>> +               else
>> +                       *((bool *)(val)) = false;
>> +               break;
>>         default:
>>                 RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
>>                          "switch case not processed\n");
>>
>

As far as i know, rtl8192cu is not support WOWLAN.
in rtl8192cu, this code is no effect. so, It is care of unnecessary
debug message.

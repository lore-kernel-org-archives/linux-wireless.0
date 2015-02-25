Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:65179 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbbBYTMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 14:12:06 -0500
Received: by mail-ob0-f180.google.com with SMTP id vb8so5964878obc.11
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 11:12:05 -0800 (PST)
Message-ID: <54EE1E83.3040603@lwfinger.net> (sfid-20150225_201210_497617_7E569E32)
Date: Wed, 25 Feb 2015 13:12:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "ap420073 ." <ap420073@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Add case in rtl92cu_get_hw_reg
References: <1424887133-5670-1-git-send-email-ap420073@gmail.com>	<54EE157D.3050101@lwfinger.net> <CAMArcTW+UM62th3CZ-hhmPiH0-hzo4-f6qB2O9q7ktK4tLtuOQ@mail.gmail.com>
In-Reply-To: <CAMArcTW+UM62th3CZ-hhmPiH0-hzo4-f6qB2O9q7ktK4tLtuOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2015 12:59 PM, ap420073 . wrote:
> 2015-02-26 3:33 GMT+09:00 Larry Finger <Larry.Finger@lwfinger.net>:
>> On 02/25/2015 11:58 AM, Taehee Yoo wrote:
>>>
>>> rtl_op_stop get wowlan state but rtl92cu_get_hw_reg has not process.
>>>
>>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>>
>>
>> Has this been tested? I am not aware that the RTL8192CU firmware could
>> handle WOWLAN.
>>
>> Larry
>>
>>
>>> ---
>>>    drivers/net/wireless/rtlwifi/rtl8192cu/hw.c | 6 ++++++
>>>    1 file changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>>> b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>>> index fe4b699..f6ad959 100644
>>> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>>> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
>>> @@ -1589,6 +1589,12 @@ void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8
>>> variable, u8 *val)
>>>          case HW_VAR_DATA_FILTER:
>>>                  *((u16 *) (val)) = rtl_read_word(rtlpriv, REG_RXFLTMAP2);
>>>                  break;
>>> +       case HAL_DEF_WOWLAN:
>>> +               if (ppsc->wo_wlan_mode)
>>> +                       *((bool *)(val)) = true;
>>> +               else
>>> +                       *((bool *)(val)) = false;
>>> +               break;
>>>          default:
>>>                  RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
>>>                           "switch case not processed\n");
>>>
>>
>
> As far as i know, rtl8192cu is not support WOWLAN.
> in rtl8192cu, this code is no effect. so, It is care of unnecessary
> debug message.

That is what I thought. In that case, the new code should be

	case HAL_DEF_WOWLAN:
		break;

Larry


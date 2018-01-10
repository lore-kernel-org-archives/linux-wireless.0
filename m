Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:41439 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752108AbeAJOIP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 09:08:15 -0500
Received: by mail-qk0-f193.google.com with SMTP id a8so23001319qkb.8
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jan 2018 06:08:15 -0800 (PST)
Subject: Re: [PATCH 02/10] rtlwifi: fix scan channel 1 fail after IPS
To: Pkshih <pkshih@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
References: <20180110052002.9544-1-pkshih@realtek.com>
 <20180110052002.9544-3-pkshih@realtek.com> <5A55CB01.5040504@broadcom.com>
 <5B2DA6FDDF928F4E855344EE0A5C39D13BE66622@RTITMBSV07.realtek.com.tw>
Cc: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        =?UTF-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A561E4B.6080105@broadcom.com> (sfid-20180110_150819_462814_A55FACE8)
Date: Wed, 10 Jan 2018 15:08:11 +0100
MIME-Version: 1.0
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D13BE66622@RTITMBSV07.realtek.com.tw>
Content-Type: text/plain; charset=big5
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/10/2018 10:38 AM, Pkshih wrote:
> 
> 
>> -----Original Message-----
>> From: Arend van Spriel [mailto:arend.vanspriel@broadcom.com]
>> Sent: Wednesday, January 10, 2018 4:13 PM
>> To: Pkshih; kvalo@codeaurora.org
>> Cc: Larry.Finger@lwfinger.net; ²ø«Û«Å; linux-wireless@vger.kernel.org
>> Subject: Re: [PATCH 02/10] rtlwifi: fix scan channel 1 fail after IPS
>>
>> On 1/10/2018 6:19 AM, pkshih@realtek.com wrote:
>>> From: Ping-Ke Shih <pkshih@realtek.com>
>>>
>>> If there is no connection, driver will enter IPS state. Meanwhile, it
>>> fails to scan channel 1 by the command 'iw dev wlan0 scan freq 2412',
>>> because hardware channel setting lose after IPS. Thus, restore channel
>>> setting from hw->conf.channel set by last rtl_op_config().
>>>
>>> Signed-off-by: Tim Lee <timlee@realtek.com>
>>
>> You need to add your sob here as well as you are submitting them.
>>
> 
> I'll add it in v2.
> 
>>> ---
>>>    drivers/net/wireless/realtek/rtlwifi/ps.c | 6 ++++++
>>>    1 file changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
>>> index 6a4008845f49..0ffe43772c9a 100644
>>> --- a/drivers/net/wireless/realtek/rtlwifi/ps.c
>>> +++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
>>> @@ -51,6 +51,12 @@ bool rtl_ps_enable_nic(struct ieee80211_hw *hw)
>>>    			&rtlmac->retry_long);
>>>    	RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
>>>
>>> +	/*<2.1> Switch Channel & Bandwidth to last rtl_op_config setting*/
>>
>> Is this type of comment really helpful? To me it seems the callback
>> names provide enough context.
>>
> 
> Do you mean the "<2.1>" isn't needed?
> This is because "<1>, <2>, <3>..." exist in the function, so
> we want to make it to be consistent.

That is not what I mean. I mean why have a comment describing what is
obvious from reading the code itself. So in this example:

On 1/10/2018 6:19 AM, pkshih@realtek.com wrote:
> +	/*<2.1> Switch Channel & Bandwidth to last rtl_op_config setting*/
> +	rtlpriv->cfg->ops->switch_channel(hw);
> +	rtlpriv->cfg->ops->set_channel_access(hw);
> +	rtlpriv->cfg->ops->set_bw_mode(hw,
> +			cfg80211_get_chandef_type(&hw->conf.chandef));
> +
>   	/*<3> Enable Interrupt */
>   	rtlpriv->cfg->ops->enable_interrupt(hw);

the code after the <2.1> comment calls a switch_channel() callback and a
set_bw_mode() callback. In my opinion those names are pretty
self-explanatory for the reader making the comment preceding it only
noise. The same applies to step <3>.

Regards,
Arend

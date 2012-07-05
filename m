Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48513 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2GEU3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 16:29:50 -0400
Received: by yhmm54 with SMTP id m54so8671953yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2012 13:29:49 -0700 (PDT)
Message-ID: <4FF5F939.8070008@lwfinger.net> (sfid-20120705_222959_224450_11ACBC23)
Date: Thu, 05 Jul 2012 15:29:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ivan Ivanich <ivanich@ivanich.org.ua>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Trial change to rtl8192ce used as AP
References: <4FF5F600.9040900@lwfinger.net> <1670791.qBDPst6NTM@ivanich.org.ua>
In-Reply-To: <1670791.qBDPst6NTM@ivanich.org.ua>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/05/2012 03:24 PM, Ivan Ivanich wrote:
> On Четверг, 05-июл-2012 15:16:00 Larry Finger wrote:
>> Ivan,
>>
>> The following patch is suggested by the code-analysis tool cppcheck as the
>> test is always false. As it will not affect STA usage, I have no way to
>> test the change. Could you please do so?
>>
>> Thanks,
>>
>> Larry
>>
>>
>> Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
>> ===================================================================
>> --- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
>> +++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
>> @@ -1097,7 +1097,7 @@ static int _rtl92ce_set_media_status(str
>>
>>    	rtl_write_byte(rtlpriv, (MSR), bt_msr);
>>    	rtlpriv->cfg->ops->led_control(hw, ledaction);
>> -	if ((bt_msr & 0xfc) == MSR_AP)
>> +	if ((bt_msr & 0x03) == MSR_AP)
>>    		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
>>    	else
>>    		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
>
> Yes, compiling now, for some reason it doesn't apply cleanyl so I manualy
> changed this line.
> And what exactly I should test?

Does it affect operation in AP mode? Before this change, the code always wrote 
0x66 to the register. Now it seems that it will write 0 if in AP mode. As I have 
no idea what that register does, I do not know what effect the change will have.

Larry


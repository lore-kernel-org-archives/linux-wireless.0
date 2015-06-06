Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37947 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbbFFE51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 00:57:27 -0400
Received: by wibdq8 with SMTP id dq8so36319044wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 21:57:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5571C21E.1050101@lwfinger.net>
References: <1433512898-30137-1-git-send-email-ap420073@gmail.com>
	<5571C21E.1050101@lwfinger.net>
Date: Sat, 6 Jun 2015 13:57:26 +0900
Message-ID: <CAMArcTV4yDk_BXhVhnWJrNe9Wd+7_HuhuBKTBp_ZhuFPSzfw5w@mail.gmail.com> (sfid-20150606_065733_535879_DFC81B05)
Subject: Re: [PATCH 1/3] rtlwifi: rtl8192cu: remove duplicated routine in _rtl92c_phy_rf6052_config_parafile
From: Taehee Yoo <ap420073@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-06-06 0:37 GMT+09:00 Larry Finger <Larry.Finger@lwfinger.net>:
> On 06/05/2015 09:01 AM, Taehee Yoo wrote:
>>
>> in the _rtl92c_phy_rf6052_config_parafile(), RF90_PATH_A and
>> RF90_PATH_B are same routine. so i remove one of these routine.
>> also the return routine is duplicated. so i remove it.
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>> ---
>>   drivers/net/wireless/rtlwifi/rtl8192cu/rf.c | 4 ----
>>   1 file changed, 4 deletions(-)
>>
>
> The code changes are OK, but the commit message needs some work. The phrase
> "RF90_PATH_A and RF90_PATH_B are same routine" should be changed to "cases
> RF90_PATH_A and RF90_PATH_B call the same routine".
>
> Larry
>
>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
>> b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
>> index b878d56..8ce055c 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
>> @@ -452,9 +452,6 @@ static bool _rtl92c_phy_rf6052_config_parafile(struct
>> ieee80211_hw *hw)
>>                 udelay(1);
>>                 switch (rfpath) {
>>                 case RF90_PATH_A:
>> -                       rtstatus =
>> rtl92cu_phy_config_rf_with_headerfile(hw,
>> -                                       (enum radio_path) rfpath);
>> -                       break;
>>                 case RF90_PATH_B:
>>                         rtstatus =
>> rtl92cu_phy_config_rf_with_headerfile(hw,
>>                                         (enum radio_path) rfpath);
>> @@ -483,7 +480,6 @@ static bool _rtl92c_phy_rf6052_config_parafile(struct
>> ieee80211_hw *hw)
>>                 }
>>         }
>>         RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, "<---\n");
>> -       return rtstatus;
>>   phy_rf_cfg_fail:
>>         return rtstatus;
>>   }
>>
>


Thank you for your review!
I will resend a patch as V2.

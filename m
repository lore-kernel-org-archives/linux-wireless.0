Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33171 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbC1Q6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 12:58:18 -0400
Received: by wgbgs4 with SMTP id gs4so38137117wgb.0
        for <linux-wireless@vger.kernel.org>; Sat, 28 Mar 2015 09:58:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5516DB22.1030202@lwfinger.net>
References: <1427544770-28523-1-git-send-email-ap420073@gmail.com>
	<5516DB22.1030202@lwfinger.net>
Date: Sun, 29 Mar 2015 01:58:17 +0900
Message-ID: <CAMArcTX2Aootn-uCgBDG7-9RaVPYXHYybZALtbTHoQKAp+FT3Q@mail.gmail.com> (sfid-20150328_175824_868757_8246904A)
Subject: Re: [PATCH] rtlwifi: rtl8192c: Change REG_C2HEVT_CLEAR and REG_USTIME_TSF
From: "ap420073 ." <ap420073@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I understand your plan,
thanks a lot for your review.


2015-03-29 1:47 GMT+09:00 Larry Finger <Larry.Finger@lwfinger.net>:
> On 03/28/2015 07:12 AM, Taehee Yoo wrote:
>>
>> in the rtl8192ce/reg.h, REG_C2HEVT_CLEAR register's address is 0x01BF
>> but, vendor driver's address is 0x01AF. so i change 0x01BF to 0x01AF.
>> also in the rtl8192ce/reg.h, 0x0551 is REG_USTIME_TSF, but vendor driver
>> define REG_BCN_CTRL_1. so i change the REG_USTIME_TSF to REG_BCN_CTRL_1.
>>
>> according to r8192c vendor driver, rtl8192c do not use REG_USTIME_TSF.
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>> ---
>>   drivers/net/wireless/rtlwifi/rtl8192ce/reg.h | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>
>
> NACK
>
> In the code, neither REG_C2HEVT_CLEAR nor REG_USTIME_TSF is used by either
> rtl8192ce nor rtl8192cu, thus it does not matter whether the definition
> matches the vendor driver or not. Making this kind of change is just
> churning the source without making any real difference.
>
> Because many of these register definitions are used by all the drivers, my
> plan is to create a reg.h header in rtlwifi and eliminate most or all of the
> headers now associated with each driver. When I do that, I will eliminate
> those definitions that are not used by any driver, but until that part is
> done, I prefer that they be left alone.
>
> Larry
>
>
>>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
>> b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
>> index dc8460c..21c0fc9 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
>> @@ -117,8 +117,8 @@
>>   #define REG_MBIST_DONE                                0x0178
>>   #define REG_MBIST_FAIL                                0x017C
>>   #define REG_C2HEVT_MSG_NORMAL                 0x01A0
>> +#define REG_C2HEVT_CLEAR                       0x01AF
>>   #define REG_C2HEVT_MSG_TEST                   0x01B8
>> -#define REG_C2HEVT_CLEAR                       0x01BF
>>   #define REG_MCUTST_1                          0x01c0
>>   #define REG_FMETHR                            0x01C8
>>   #define REG_HMETFR                            0x01CC
>> @@ -231,7 +231,7 @@
>>   #define REG_RD_NAV_NXT                                0x0544
>>   #define REG_NAV_PROT_LEN                      0x0546
>>   #define REG_BCN_CTRL                          0x0550
>> -#define REG_USTIME_TSF                         0x0551
>> +#define REG_BCN_CTRL_1                         0x0551
>>   #define REG_MBID_NUM                          0x0552
>>   #define REG_DUAL_TSF_RST                      0x0553
>>   #define REG_BCN_INTERVAL                      0x0554
>>
>

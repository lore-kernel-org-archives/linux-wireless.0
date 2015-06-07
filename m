Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34218 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbbFGPS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 11:18:27 -0400
Received: by wgv5 with SMTP id 5so85945418wgv.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2015 08:18:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55745D9E.60504@lwfinger.net>
References: <1433684016-24340-1-git-send-email-ap420073@gmail.com>
	<55745D9E.60504@lwfinger.net>
Date: Mon, 8 Jun 2015 00:18:25 +0900
Message-ID: <CAMArcTVcqiqnoKR0d2=Y+=cOTzTh+07etwOStSrbb9C42yCoqQ@mail.gmail.com> (sfid-20150607_171937_660186_722056F6)
Subject: Re: [PATCH V2] rtlwifi: rtl8192c: Add init codes for "fw_version" and "fw_subversion".
From: Taehee Yoo <ap420073@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-06-08 0:05 GMT+09:00 Larry Finger <Larry.Finger@lwfinger.net>:
> On 06/07/2015 08:33 AM, Taehee Yoo wrote:
>>
>> The variable "fw_version" is used in the _ResetDigitalProcedure1().
>> but It is not initialized. so I add init codes for "fw_version" and
>> "fw_subversion".
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>> ---
>
>
> V2 - Moved new statements into location where header is known to exist.
>
> You should have something like this after the separator (---) in the commit
> message for any resubmission.
>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> Larry
>
>
>>   drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
>> b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
>> index 29983bc..14b819e 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
>> @@ -233,13 +233,14 @@ int rtl92c_download_fw(struct ieee80211_hw *hw)
>>         pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
>>         pfwdata = (u8 *)rtlhal->pfirmware;
>>         fwsize = rtlhal->fwsize;
>> -
>>         if (IS_FW_HEADER_EXIST(pfwheader)) {
>>                 RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
>>                          "Firmware Version(%d),
>> Signature(%#x),Size(%d)\n",
>>                           pfwheader->version, pfwheader->signature,
>>                           (int)sizeof(struct rtl92c_firmware_header));
>>
>> +               rtlhal->fw_version = pfwheader->version;
>> +               rtlhal->fw_subversion = pfwheader->subversion;
>>                 pfwdata = pfwdata + sizeof(struct rtl92c_firmware_header);
>>                 fwsize = fwsize - sizeof(struct rtl92c_firmware_header);
>>         }
>>
>

Thank you for your feedback!
Would i resend it?

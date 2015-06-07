Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34884 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbbFGMMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 08:12:35 -0400
Received: by wiga1 with SMTP id a1so59599503wig.0
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2015 05:12:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55731D53.2020808@lwfinger.net>
References: <1433588537-27853-1-git-send-email-ap420073@gmail.com>
	<55731D53.2020808@lwfinger.net>
Date: Sun, 7 Jun 2015 21:12:34 +0900
Message-ID: <CAMArcTVPY2H6erzOzLhT+z5O=eNfOR7h-_04_GxPhOVmwNv_aw@mail.gmail.com> (sfid-20150607_141239_447504_4EFA67E5)
Subject: Re: [PATCH] rtlwifi: rtl8192c: Add init codes for "fw_version" and "fw_subversion".
From: Taehee Yoo <ap420073@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-06-07 1:18 GMT+09:00 Larry Finger <Larry.Finger@lwfinger.net>:
> On 06/06/2015 06:02 AM, Taehee Yoo wrote:
>>
>> The variable "fw_version" is used in the _ResetDigitalProcedure1().
>> but It is not initialized. so I add init codes for "fw_version" and
>> "fw_subversion".
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>> ---
>>   drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
>> b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
>> index 29983bc..9b5ce28 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
>> @@ -233,6 +233,8 @@ int rtl92c_download_fw(struct ieee80211_hw *hw)
>>         pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
>>         pfwdata = (u8 *)rtlhal->pfirmware;
>>         fwsize = rtlhal->fwsize;
>> +       rtlhal->fw_version = pfwheader->version;
>> +       rtlhal->fw_subversion = pfwheader->subversion;
>>
>>         if (IS_FW_HEADER_EXIST(pfwheader)) {
>>                 RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
>
>
> This patch is not correct. If the firmware does not have a header, then you
> will be changing fw_version and fw_subversion to random bytes from the body
> of the firmware. At present, they are initialized to zero as part of the
> rtl_priv struct. You need to move the two new statements inside the
> IS_FW_HEADER_EXIST test, but before pfwdata is adjusted to remove the
> header.
>
> Larry
>
>

Thank you for your review!
I will resend a patch as V2.

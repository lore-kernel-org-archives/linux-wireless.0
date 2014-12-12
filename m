Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34349 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbaLLWeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 17:34:18 -0500
Received: by mail-wg0-f42.google.com with SMTP id z12so10251275wgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2014 14:34:17 -0800 (PST)
Message-ID: <548B6D66.3090106@konagma.com> (sfid-20141212_233421_669368_D42BADFF)
Date: Fri, 12 Dec 2014 23:34:14 +0100
From: Krzysztof Konopko <kris@konagma.com>
MIME-Version: 1.0
To: Jes Sorensen <Jes.Sorensen@redhat.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warnings
References: <1418336609-10191-1-git-send-email-kris@konagma.com> <wrfj7fxwyeq5.fsf@redhat.com>
In-Reply-To: <wrfj7fxwyeq5.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/14 18:12, Jes Sorensen wrote:
> Krzysztof Konopko <kris@konagma.com> writes:
>> Some struct fields in wifi.h are meant to be __le16 bu were declared as
>> unsigned short.  This was reported by sparse:
>>
>>   rtw_wlan_util.c:538:24: warning: cast to restricted __le16
>>   rtw_wlan_util.c:1544:29: warning: cast to restricted __le16
>>   rtw_wlan_util.c:1546:25: warning: cast to restricted __le16
>>
>> This patch changes declared types of the struct fields involved.
>>
>> Signed-off-by: Krzysztof Konopko <kris@konagma.com>
>> ---
>>  drivers/staging/rtl8723au/include/wifi.h | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8723au/include/wifi.h b/drivers/staging/rtl8723au/include/wifi.h
>> index fd3da3b..8a2adc5 100644
>> --- a/drivers/staging/rtl8723au/include/wifi.h
>> +++ b/drivers/staging/rtl8723au/include/wifi.h
>> @@ -28,7 +28,7 @@
>>  struct AC_param {
>>  	unsigned char		ACI_AIFSN;
>>  	unsigned char		CW;
>> -	unsigned short	TXOP_limit;
>> +	__le16			TXOP_limit;
>>  }  __packed;
>>  
>>  struct WMM_para_element {
>> @@ -39,9 +39,9 @@ struct WMM_para_element {
>>  
>>  struct ADDBA_request {
>>  	unsigned char		dialog_token;
>> -	unsigned short	BA_para_set;
>> +	__le16		BA_para_set;
>>  	unsigned short	BA_timeout_value;
>> -	unsigned short	BA_starting_seqctrl;
>> +	__le16		BA_starting_seqctrl;
>>  }  __packed;
> 
> If you are going to make the struct comply with the on-wire data format,
> be consistent. Don't just change half the elements of the struct - that
> will just lead to confusion.
> 
> Jes
> 

Yes, my change was inconsistent.  Looking at `addba_req` and
`ieee80211_wmm_ac_param` in include/linux/ieee80211.h, all data wider
than 1 byte should be declared as __le.  I'll send through a patch that
makes this change consistently.

Thanks,
Kris

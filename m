Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:33885 "EHLO
	mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbbJBJDg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 05:03:36 -0400
Received: by vkat63 with SMTP id t63so4544278vka.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 02:03:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <560E3A11.2040200@broadcom.com>
References: <1443771681-15540-1-git-send-email-chaehyun.lim@gmail.com>
	<1443771681-15540-8-git-send-email-chaehyun.lim@gmail.com>
	<560E3A11.2040200@broadcom.com>
Date: Fri, 2 Oct 2015 18:03:35 +0900
Message-ID: <CAKV=issQyrWfdL8jPYGbvWcpAqVqNzTn53S1_yCxEGka0desgA@mail.gmail.com> (sfid-20151002_110342_081511_00E41AAC)
Subject: Re: [PATCH V2 08/12] staging: wilc1000: use int instead of int8_t
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	"tony.cho" <tony.cho@atmel.com>, glen.lee@atmel.com,
	leo.kim@atmel.com, linux-wireless <linux-wireless@vger.kernel.org>,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 2, 2015 at 5:02 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 10/02/2015 09:41 AM, Chaehyun Lim wrote:
>>
>> This patch replaces int8_t with int.
>> The int8_t should be int. It's used as an index into an array
>> or -1 for not found.
>
>
> Please consider using bool instead. See my previous emails.

Thank you for your comment.

As said by dan, return value is used for array index in
add_network_to_shadow function.
so it cannot simply changed by bool.

Thanks
Chaehyun Lim

>
> Regards,
> Arend
>
>
>> Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
>> ---
>> V2: replaces s8 with int suggested by dan.
>>
>>   drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>> b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>> index d781003..3c8c2e1 100644
>> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>> @@ -263,9 +263,9 @@ static void clear_duringIP(unsigned long arg)
>>         g_obtainingIP = false;
>>   }
>>
>> -int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void
>> *pUserVoid)
>> +int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void
>> *pUserVoid)
>>   {
>> -       int8_t state = -1;
>> +       int state = -1;
>>         int i;
>>
>>         if (u32LastScannedNtwrksCountShadow == 0) {
>> @@ -288,7 +288,7 @@ int8_t is_network_in_shadow(tstrNetworkInfo
>> *pstrNetworkInfo, void *pUserVoid)
>>
>>   void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void
>> *pUserVoid, void *pJoinParams)
>>   {
>> -       int8_t ap_found = is_network_in_shadow(pstrNetworkInfo,
>> pUserVoid);
>> +       int ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
>>         u32 ap_index = 0;
>>         u8 rssi_index = 0;
>>
>>
>

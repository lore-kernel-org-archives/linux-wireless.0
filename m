Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:15618 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbbJBHt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 03:49:58 -0400
Message-ID: <560E3723.3010800@broadcom.com> (sfid-20151002_095005_059416_71796F81)
Date: Fri, 2 Oct 2015 09:49:55 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Chaehyun Lim <chaehyun.lim@gmail.com>, <gregkh@linuxfoundation.org>
CC: <johnny.kim@atmel.com>, <rachel.kim@atmel.com>,
	<chris.park@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <linux-wireless@vger.kernel.org>,
	<devel@driverdev.osuosl.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 08/12] staging: wilc1000: use s8 instead of int8_t
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com> <1443707039-18433-8-git-send-email-chaehyun.lim@gmail.com> <560E3628.4000105@broadcom.com>
In-Reply-To: <560E3628.4000105@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/02/2015 09:45 AM, Arend van Spriel wrote:
> On 10/01/2015 03:43 PM, Chaehyun Lim wrote:
>> This patch replaces int8_t with s8 that is a preferred type.
>>
>> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
>> ---
>>   drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>> b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>> index d781003..56c97c9 100644
>> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>> @@ -263,9 +263,9 @@ static void clear_duringIP(unsigned long arg)
>>       g_obtainingIP = false;
>>   }
>>
>> -int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void
>> *pUserVoid)
>> +s8 is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void
>> *pUserVoid)
>
> It seems to make more sense to use bool type here.

The memcmp in this function uses magic number 6 comparing BSSIDs. Should 
change that to ETH_ALEN in separate patch.

Regards,
Arend

>>   {
>> -    int8_t state = -1;
>> +    s8 state = -1;
>
> You can actually get rid of the state variable. Just replace the
> statement 'state = i;' by 'return true;' and replace 'return state;' by
> 'return false;'.
>
>>       int i;
>>
>>       if (u32LastScannedNtwrksCountShadow == 0) {
>> @@ -288,7 +288,7 @@ int8_t is_network_in_shadow(tstrNetworkInfo
>> *pstrNetworkInfo, void *pUserVoid)
>>
>>   void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void
>> *pUserVoid, void *pJoinParams)
>>   {
>> -    int8_t ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
>> +    s8 ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
>
> And here as well.
>
> Regards,
> Arend
>
>>       u32 ap_index = 0;
>>       u8 rssi_index = 0;
>>
>>
>


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:4651 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758642AbbLCIUs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 03:20:48 -0500
Message-ID: <565FFC30.10801@atmel.com> (sfid-20151203_092132_778325_4CA74E51)
Date: Thu, 3 Dec 2015 17:24:16 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: "Mario J. Rugiero" <mrugiero@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@driverdev.osuosl.org>, <chris.park@atmel.com>,
	<austin.shin@atmel.com>, <gregkh@linuxfoundation.org>,
	<linux-wireless@vger.kernel.org>, <johnny.kim@atmel.com>,
	<tony.cho@atmel.com>, <leo.kim@atmel.com>
Subject: Re: [PATCH 1/1] staging: cleanup: Fix incompatible type comparison
 in wilc1000/host_interface.c
References: <1448928544-3534-1-git-send-email-mrugiero@gmail.com> <20151202132923.GV18797@mwanda> <565F0A79.90100@gmail.com>
In-Reply-To: <565F0A79.90100@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 12월 03일 00:12, Mario J. Rugiero wrote:
> OK. Since the maintainers are CC'd, I guess I should wait for a 
> clarification about this?

Hi Mario,

The purpose of that is to check if tail is null or not. if it is not null, there is tail
to send, so copy to buff.

regards,
glen lee.

>
> El 02/12/15 a las 10:29, Dan Carpenter escribió:
>> Put v2 in the subject.  Also the subsystem prefix is:
>>
>> [PATCH v3] staging: wilc1000: ...
>>
>> On Mon, Nov 30, 2015 at 09:09:04PM -0300, Mario J. Rugiero wrote:
>>> This patch replaces an "if (ptr > 0)" comparison that seems to be a
>>> confusing way to check for null by a simpler "if (ptr)" check.
>>>
>>> Signed-off-by: Mario J. Rugiero <mrugiero@gmail.com>
>>> ---
>> v2: Remove the != NULL because checkpatch complains.
>>
>>> drivers/staging/wilc1000/host_interface.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/staging/wilc1000/host_interface.c 
>>> b/drivers/staging/wilc1000/host_interface.c
>>> index d5b7725..0c87f6c 100644
>>> --- a/drivers/staging/wilc1000/host_interface.c
>>> +++ b/drivers/staging/wilc1000/host_interface.c
>>> @@ -2270,7 +2270,7 @@ static void Handle_AddBeacon(struct 
>>> host_if_drv *hif_drv,
>>>       *pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 16) & 0xFF);
>>>       *pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 24) & 0xFF);
>>>   -    if (pstrSetBeaconParam->tail > 0)
>>> +    if (pstrSetBeaconParam->tail)
>> Probably the intention was to check if "pstrSetBeaconParam->tail_len 
>> > 0"
>> but I'm not sure.  The wilc1000 maintainers are very responsive though
>> so maybe they will know for sure.
>>
>> regards,
>> dan carpenter
>>
>>
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel


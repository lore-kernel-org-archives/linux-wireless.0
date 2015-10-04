Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:44777 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbJDVGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 17:06:11 -0400
Message-ID: <561194C0.7030102@broadcom.com> (sfid-20151004_230614_927919_3E46C64A)
Date: Sun, 4 Oct 2015 23:06:08 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Chaehyun Lim <chaehyun.lim@gmail.com>,
	<gregkh@linuxfoundation.org>, <johnny.kim@atmel.com>,
	<rachel.kim@atmel.com>, <chris.park@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>
Subject: Re: [PATCH 08/12] staging: wilc1000: use s8 instead of int8_t
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com> <1443707039-18433-8-git-send-email-chaehyun.lim@gmail.com> <560E3628.4000105@broadcom.com> <20151002113701.GN7289@mwanda>
In-Reply-To: <20151002113701.GN7289@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/02/2015 01:37 PM, Dan Carpenter wrote:
> On Fri, Oct 02, 2015 at 09:45:44AM +0200, Arend van Spriel wrote:
>> On 10/01/2015 03:43 PM, Chaehyun Lim wrote:
>>> This patch replaces int8_t with s8 that is a preferred type.
>>>
>>> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
>>> ---
>>>   drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>>> index d781003..56c97c9 100644
>>> --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>>> +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
>>> @@ -263,9 +263,9 @@ static void clear_duringIP(unsigned long arg)
>>>   	g_obtainingIP = false;
>>>   }
>>>
>>> -int8_t is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
>>> +s8 is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
>>
>> It seems to make more sense to use bool type here.
>
> That doesn't work, but you're right that the function is poorly named.

Ah, yes. The return value was assigned to a variable named ap_found so I 
did not look further, but that variable is further down assigned to 
ap_index. Gosh! Been a while since I faced true staging code ;-)

Regards,
Arend

> It could be renamed to get_ap_index_or_something() in a later patch.
> Returning directly is also a good idea.
>
> regards,
> dan carpenter
>


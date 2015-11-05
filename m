Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3225 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031477AbbKECTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 21:19:44 -0500
Message-ID: <563ABD77.2050303@atmel.com> (sfid-20151105_031947_444589_D3BD1097)
Date: Thu, 5 Nov 2015 11:22:47 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <austin.shin@atmel.com>,
	<linux-wireless@vger.kernel.org>, <Nicolas.FERRE@atmel.com>,
	<adel.noureldin@atmel.com>, <tony.cho@atmel.com>,
	<leo.kim@atmel.com>, <adham.abozaeid@atmel.com>
Subject: Re: [PATCH RESEND 12/12] staging: wilc1000: add argument wilc and
 use it instead of g_linux_wlan
References: <1446088732-12301-1-git-send-email-glen.lee@atmel.com> <1446088732-12301-12-git-send-email-glen.lee@atmel.com> <20151104204120.GB15421@kroah.com>
In-Reply-To: <20151104204120.GB15421@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2015년 11월 05일 05:41, Greg KH wrote:
> On Thu, Oct 29, 2015 at 12:18:52PM +0900, Glen Lee wrote:
>> This patch adds new argument wilc to linux_sdio_cmd53 and linux_sdio_cmd52
>> , and use it instead of g_linux_wlan. Pass wilc to the functions as well.
>> The void type wilc will be changed with struct wilc when SDIO and SPI
>> modules are reworked.
>>
>> Signed-off-by: Glen Lee <glen.lee@atmel.com>
>> ---
>>   drivers/staging/wilc1000/linux_wlan_sdio.c |  8 ++--
>>   drivers/staging/wilc1000/linux_wlan_sdio.h |  4 +-
>>   drivers/staging/wilc1000/wilc_sdio.c       | 66 +++++++++++++++---------------
>>   drivers/staging/wilc1000/wilc_wlan_if.h    |  4 +-
>>   4 files changed, 41 insertions(+), 41 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
>> index bf05e22..8150d6f 100644
>> --- a/drivers/staging/wilc1000/linux_wlan_sdio.c
>> +++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
>> @@ -53,9 +53,9 @@ static void wilc_sdio_interrupt(struct sdio_func *func)
>>   }
>>   
>>   
>> -int linux_sdio_cmd52(sdio_cmd52_t *cmd)
>> +int linux_sdio_cmd52(void *wilc, sdio_cmd52_t *cmd)
> Again, why a void *?  Please use the correct type, you know what it is,
> that way you can get rid of horrid stuff like this:
>
>>   {
>> -	struct sdio_func *func = g_linux_wlan->wilc_sdio_func;
>> +	struct sdio_func *func = ((struct wilc*)wilc)->wilc_sdio_func;
> All of those casts should not be needed.

I was planning to change this void type with struct wilc as I commented in changelog.
But as you pointed out, I will do this after fixing current SDIO modules.

Regards,
glen lee.

>
> thanks,
>
> greg k-h


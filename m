Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:22058 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbbJ2B7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 21:59:25 -0400
Message-ID: <56317E2E.1090502@atmel.com> (sfid-20151029_025929_026675_A938EE10)
Date: Thu, 29 Oct 2015 11:02:22 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<austin.shin@atmel.com>, <linux-wireless@vger.kernel.org>,
	<Nicolas.FERRE@atmel.com>, <adel.noureldin@atmel.com>,
	<tony.cho@atmel.com>, <leo.kim@atmel.com>,
	<adham.abozaeid@atmel.com>
Subject: Re: [PATCH 38/80] staging: wilc1000: rename au8Bssid of struct ba_session_info
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com> <1446015640-29398-38-git-send-email-glen.lee@atmel.com> <20151028165606.GB18797@mwanda>
In-Reply-To: <20151028165606.GB18797@mwanda>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 29일 01:56, Dan Carpenter wrote:
> On Wed, Oct 28, 2015 at 03:59:58PM +0900, Glen Lee wrote:
>> From: Leo Kim <leo.kim@atmel.com>
>>
>> This patch renames au8Bssid of struct ba_session_info to bssid
>> to avoid CamelCase naming convention.
>> And, some debug logs modified because 80 ending line over warnings.
>>
>> Signed-off-by: Leo Kim <leo.kim@atmel.com>
>> Signed-off-by: Glen Lee <glen.lee@atmel.com>
>> ---
>>   drivers/staging/wilc1000/host_interface.c | 32 ++++++++++++++++++-------------
>>   drivers/staging/wilc1000/host_interface.h |  2 +-
>>   2 files changed, 20 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
>> index 9ad98fd..48a232f 100644
>> --- a/drivers/staging/wilc1000/host_interface.c
>> +++ b/drivers/staging/wilc1000/host_interface.c
>> @@ -2715,10 +2715,14 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
>>   	int AddbaTimeout = 100;
>>   	char *ptr = NULL;
>>   
>> -	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\nBufferSize == %d\nSessionTimeOut = %d\n",
>> -		strHostIfBASessionInfo->au8Bssid[0],
>> -		strHostIfBASessionInfo->au8Bssid[1],
>> -		strHostIfBASessionInfo->au8Bssid[2],
>> +	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with \
>> +		\nBSSID = %.2x:%.2x:%.2x \
>> +		\nBufferSize == %d \
>> +		\nSessionTimeOut = %d \
>> +		\nTID=%d\n",
>> +		strHostIfBASessionInfo->bssid[0],
>> +		strHostIfBASessionInfo->bssid[1],
>> +		strHostIfBASessionInfo->bssid[2],
>>   		strHostIfBASessionInfo->u16BufferSize,
>>   		strHostIfBASessionInfo->u16SessionTimeout,
>>   		strHostIfBASessionInfo->u8Ted);
> This should be a bunch of printks so that we have the correct debug
> level at the start of each line.

Thank you for your advice.
We will use netdev_xxx print format later with a bunch of prints when the function gets access net_device.
For now, continuation \ will be deleted and will be like,

	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with BSSID = %02x:%02x:%02x TID=%d BufferSize == %d SessionTimeOut = %d\n",
		etc...

> regards,
> dan carpenter
>


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:15055 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbbHSH7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 03:59:21 -0400
Message-ID: <55D43738.7000008@atmel.com> (sfid-20150819_095925_481248_501FE53C)
Date: Wed, 19 Aug 2015 16:58:48 +0900
From: Johnny Kim <johnny.kim@atmel.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Tony Cho <tony.cho@atmel.com>, <devel@driverdev.osuosl.org>,
	<rachel.kim@atmel.com>, <chris.park@atmel.com>,
	<gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
	<jude.lee@atmel.com>, <leo.kim@atmel.com>
Subject: Re: [PATCH 5/5] staging: wilc1000: use id value as argument
References: <1439440883-16061-1-git-send-email-tony.cho@atmel.com> <1439440883-16061-6-git-send-email-tony.cho@atmel.com> <20150813144907.GA4484@mwanda> <55D2A23D.2080209@atmel.com> <20150818091224.GM5558@mwanda>
In-Reply-To: <20150818091224.GM5558@mwanda>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Dan.
On 2015년 08월 18일 18:12, Dan Carpenter wrote:
> On Tue, Aug 18, 2015 at 12:10:53PM +0900, Johnny Kim wrote:
>> Hello Dan.
>>
>> On 2015년 08월 13일 23:49, Dan Carpenter wrote:
>>> On Thu, Aug 13, 2015 at 01:41:23PM +0900, Tony Cho wrote:
>>>> +static u32 get_id_from_handler(tstrWILC_WFIDrv *handler)
>>>> +{
>>>> +	u32 id;
>>>> +
>>>> +	if (!handler)
>>>> +		return 0;
>>>> +
>>>> +	for (id = 0; id < NUM_CONCURRENT_IFC; id++) {
>>>> +		if (wfidrv_list[id] == handler) {
>>>> +			id += 1;
>>>> +			break;
>>>> +		}
>>>> +	}
>>>> +
>>>> +	if (id > NUM_CONCURRENT_IFC)
>>>> +		return 0;
>>>> +	else
>>>> +		return id;
>>>> +}
>>>> +
>>> This still has an off by one bug.  Just use zero offset arrays
>>> throughout.
>>>
>>> static int get_id_from_handler(tstrWILC_WFIDrv *handler)
>>> {
>>> 	int id;
>>>
>>> 	if (!handler)
>>> 		return -ENOBUFS;
>>>
>>> 	for (id = 0; id < NUM_CONCURRENT_IFC; id++) {
>>> 		if (wfidrv_list[id] == handler)
>>> 			return id;
>>> 	}
>>>
>>> 	return -ENOBUFS;
>>> }
>> Thanks for your review. The return value of this function has from 0 till 2.
>> 1 and 2 value is real ID value. only 0 value is reserved to remove a
>> registered id.
>> But I also think that error handling should be added about the
>> overflowed value
>> as your opinion.
> I thought we had created "id" here in this patch so we don't have to
> pass function pointers through a u32 value (which can't fit a 64 bit
> pointer).  What do you mean it is a "real ID value"?  Is it there in
> the hardware spec?
Real ID value means the value mapped to an alive NIC handler.
And when the driver transmits and receives some data frame with chipset,
the ID is used to distinguish the data frame's owner. Just like the driver,
chipset uses the appointed identifier. the data frame always includes the
identifier.
You know, current driver is using 32bit pointer address as the identifier.
So, this patch converts the address value to integer value. As mentioned
earlier, '0' value is the reserved value to terminate an alive NIC handler
and inform it to chipset.
> Anyway, this code is buggy and messy.  Please find a different way to
> write it.

Regards.
Johnny.

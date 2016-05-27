Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51686 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbcE0SYb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 14:24:31 -0400
Subject: Re: [PATCH] staging/wilc1000: fixes kzalloc call
To: Joe Perches <joe@perches.com>, johnny.kim@atmel.com,
	austin.shin@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
References: <1464371477-16965-1-git-send-email-lidza.louina@oracle.com>
 <1464372460.3938.13.camel@perches.com>
From: Lidza Louina <lidza.louina@oracle.com>
Message-ID: <574890E6.4000600@oracle.com> (sfid-20160527_202434_652468_BD93B5F1)
Date: Fri, 27 May 2016 14:24:38 -0400
MIME-Version: 1.0
In-Reply-To: <1464372460.3938.13.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/27/2016 02:07 PM, Joe Perches wrote:
> On Fri, 2016-05-27 at 13:51 -0400, Lidza Louina wrote:
>> The wl pointer was initialized as a pointer to a struct wilc and
>> assigned to a piece of memory the size of the pointer. It should be the
>> size of struct wilc.
> This isn't necessary.
>
> The code in question is:
>
> 	struct wilc *wl;
>
> 	sema_init(&close_exit_sync, 0);
>
> 	wl = kzalloc(sizeof(*wl), GFP_KERNEL);
> 	if (!wl)
> 		return -ENOMEM;
>
> 	*wilc = wl;
>
> so this isn't any real change and the generally desired form for
> allocations from CodingStyle (Chapter 14: Allocating Memory) is:
>
> The preferred form for passing a size of a struct is the following:	p = kmalloc(sizeof(*p), ...);

Ahh, okay. I see that in the documentation. Thanks.

Lidza

>
>> diff --git a/drivers/staging/wilc1000/linux_wlan.c
> []
>> @@ -1260,7 +1260,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
>>   
>>   	sema_init(&close_exit_sync, 0);
>>   
>> -	wl = kzalloc(sizeof(*wl), GFP_KERNEL);
>> +	wl = kzalloc(sizeof(struct wilc), GFP_KERNEL);
>>   	if (!wl)
>>   		return -ENOMEM;


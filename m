Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:49337 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759148AbbJ3IrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 04:47:05 -0400
Message-ID: <56332F3B.5080406@atmel.com> (sfid-20151030_094714_722734_98A66456)
Date: Fri, 30 Oct 2015 17:50:03 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<austin.shin@atmel.com>, <linux-wireless@vger.kernel.org>,
	<Nicolas.FERRE@atmel.com>, <adel.noureldin@atmel.com>,
	<tony.cho@atmel.com>, <leo.kim@atmel.com>,
	<adham.abozaeid@atmel.com>
Subject: Re: [PATCH 17/17] staging: wilc1000: wilc_netdev_init: use wilc instead
 of g_linux_wlan
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com> <1446174642-28570-17-git-send-email-glen.lee@atmel.com> <20151030083544.GD18797@mwanda>
In-Reply-To: <20151030083544.GD18797@mwanda>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 30일 17:35, Dan Carpenter wrote:
> On Fri, Oct 30, 2015 at 12:10:42PM +0900, Glen Lee wrote:
>>   	/*create the common structure*/
>> -	g_linux_wlan = kzalloc(sizeof(*g_linux_wlan), GFP_KERNEL);
>> -	if (!g_linux_wlan)
>> +	wl = kzalloc(sizeof(struct wilc), GFP_KERNEL);
> This introduces a checkpatch.pl warning.  The prefered style is:
>
> 	wl = kzalloc(sizeof(*wl), GFP_KERNEL);
>
> But the larger point is that please use checkpatch.pl.

Thank you for the review, I will use preferred style in v2.

regards,

glen lee

>
> regards,
> dan carpenter
>


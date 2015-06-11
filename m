Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:44026 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751622AbbFKFdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 01:33:42 -0400
Message-ID: <55791DB3.7080205@atmel.com> (sfid-20150611_073401_903550_C49BCCA0)
Date: Thu, 11 Jun 2015 14:33:39 +0900
From: Johnny Kim <johnny.kim@atmel.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<Rachel.kim@atmel.com>, <dean.lee@atmel.com>, <tony.cho@atmel.com>,
	<chris.park@atmel.com>
Subject: Re: [PATCH 1/4] staging: wilc1000: modify data type
References: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com> <1433923607-20927-2-git-send-email-johnny.kim@atmel.com> <20150611004059.GA30902@kroah.com>
In-Reply-To: <20150611004059.GA30902@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2015년 06월 11일 09:40, Greg KH wrote:
> On Wed, Jun 10, 2015 at 05:06:44PM +0900, Johnny Kim wrote:
>> -static int wilc_wlan_cfg_commit(int type, uint32_t drvHandler)
>> +static int wilc_wlan_cfg_commit(int type, size_t drvHandler)
> Shouldn't this just be a void *?  And if so, why not the real function
> pointer instead?
>
> Also, lots of these seem to be just pointers, please use a pointer
> instead of hiding it in a size_t as that's the most portable, and
> correct, way to do it.  No need to hide any function pointers here, this
> isn't Windows :)
>
> thanks,
>
> greg k-h

To replace the integer to the pointer as your counsel, I need a lot of
discussion internally. But I will fix the type and the related things
like your thinking.

I know there is the build warning for 64-bit machine and this driver stays
in BROKEN status on linux-next.
I want to know if the reason is 64bit build warning.

Thanks for your help.

Regards
Johnny

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38585 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757711AbbIVNEZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 09:04:25 -0400
Subject: Re: [PATCH] staging: wicl1000: fix dereference after free in
 wilc_wlan_cleanup()
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
References: <1442917490-26574-1-git-send-email-javier@osg.samsung.com>
 <20150922121600.GA16336@sudip-pc>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tony Cho <tony.cho@atmel.com>, Leo Kim <leo.kim@atmel.com>
Message-ID: <560151D1.40606@osg.samsung.com> (sfid-20150922_150456_327257_0E5114B9)
Date: Tue, 22 Sep 2015 15:04:17 +0200
MIME-Version: 1.0
In-Reply-To: <20150922121600.GA16336@sudip-pc>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Sudip,

Thanks a lot for your feedback.

On 09/22/2015 02:16 PM, Sudip Mukherjee wrote:
> On Tue, Sep 22, 2015 at 12:24:50PM +0200, Javier Martinez Canillas wrote:
>> The wilc_wlan_cleanup() function iterates over the list of transmission
>> buffers freeing all of them and then iterates over the receive buffers
>> list to free all of them as well.
>>
>> But on the receive loop a pointer to struct txq_entry_t is dereferenced
>> instead of the pointer to a struct rxq_entry_t. This not only causes a
>> dereference to a pointer already freed but also leaks the memory in the
>> struct rxq_entry_t buffer.
>>
>> Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> ---
>>
>>  drivers/staging/wilc1000/wilc_wlan.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
>> index 4c25179c2fec..c40f143b00b7 100644
>> --- a/drivers/staging/wilc1000/wilc_wlan.c
>> +++ b/drivers/staging/wilc1000/wilc_wlan.c
>> @@ -1746,7 +1746,7 @@ static void wilc_wlan_cleanup(void)
>>  		if (rqe == NULL)
>>  			break;
>>  #ifdef MEMORY_DYNAMIC
>> -		kfree(tqe->buffer);
>> +		kfree(rqe->buffer);
>>  #endif
> MEMORY_DYNAMIC is only used here and no where else. And buffer was
> allocated in the else part of #ifdef MEMORY_STATIC.
> So you should really be using #ifndef MEMORY_STATIC here instead of
> #ifdef MEMORY_DYNAMIC otherwise memory leak will still remain.
>

You are right that #ifndef MEMORY_STATIC should be used instead to fix
the memory leak. I'll post a v2 changing that as well.

> regards
> sudip
>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America

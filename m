Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nasmtp02.atmel.com ([204.2.163.16]:31094 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751341AbbKMHqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 02:46:07 -0500
Message-ID: <56459602.9060707@atmel.com> (sfid-20151113_084611_632664_31D38D4F)
Date: Fri, 13 Nov 2015 16:49:22 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	<linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/20] staging/wilc1000: pass hif operations through initialization
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de> <1447198960-2760143-16-git-send-email-arnd@arndb.de> <56446475.5090409@atmel.com> <4207649.2OaxOXWCyM@wuerfel>
In-Reply-To: <4207649.2OaxOXWCyM@wuerfel>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 11월 12일 20:39, Arnd Bergmann wrote:
> On Thursday 12 November 2015 19:05:41 glen lee wrote:
>> Hi arnd,
>>
>> I appreciate the patches.
>> I did test this patch series on h/w which is arm based MCU.
>>   From this patch wilc is not working properly. After downloading firmware, the firmware cannot start and it fails.
>> I double check this patch and the previous one(14/20) which works fine.
>> I cannot find the problem in this patch at the moment. I will see if I can find something,
>> and I'd appreciate if you would help with it.
>>
> I've looked at it some more, but didn't find anything obvious, here are some
> possible things I found:
>
>
>>> -struct wilc_hif_func wilc_hif_sdio = {
>>> -	sdio_init,
>>> -	sdio_deinit,
>>> -	sdio_read_reg,
>>> -	sdio_write_reg,
>>> -	sdio_read,
>>> -	sdio_write,
>>> -	sdio_sync,
>>> -	sdio_clear_int,
>>> -	sdio_read_int,
>>> -	sdio_clear_int_ext,
>>> -	sdio_read_size,
>>> -	sdio_write,
>>> -	sdio_read,
>>> -	sdio_sync_ext,
>>> -
>>> -	sdio_set_max_speed,
>>> -	sdio_set_default_speed,
>>> +const struct wilc_hif_func wilc_hif_sdio = {
>>> +	.hif_init = sdio_init,
>>> +	.hif_deinit = sdio_deinit,
>>> +	.hif_read_reg = sdio_read_reg,
>>> +	.hif_write_reg = sdio_write_reg,
>>> +	.hif_block_rx = sdio_read,
>>> +	.hif_block_tx = sdio_write,
>>> +	.hif_sync = sdio_sync,
>>> +	.hif_clear_int = sdio_clear_int,
>>> +	.hif_read_int = sdio_read_int,
>>> +	.hif_clear_int_ext = sdio_clear_int_ext,
>>> +	.hif_read_size = sdio_read_size,
>>> +	.hif_block_rx_ext = sdio_write,
>>> +	.hif_block_tx_ext = sdio_read,

Hi arnd,

I found this. These should be like this. It works fine.
+	.hif_block_tx_ext = sdio_write,
+	.hif_block_rx_ext = sdio_read,

also, wilc_hif_spi need to be fixed together like this.
+	.hif_block_tx_ext = _wilc_spi_write,
+	.hif_block_rx_ext = _wilc_spi_read,

Thank you for all the patches.

regards,
glen lee

>>> +	.hif_sync_ext = sdio_sync_ext,
>>> +	.hif_set_max_bus_speed = sdio_set_max_speed,
>>> +	.hif_set_default_bus_speed = sdio_set_default_speed,
>>>    };
> If the callbacks are not in the same order here, something could
> in theory go wrong. I've tried to verify them by inspection and
> could not find anything here, but you can try reverting this part.
>
>>>    	memset((void *)&g_wlan, 0, sizeof(wilc_wlan_dev_t));
>>>    	g_wlan.io_type = wilc->io_type;
>>> -
>>> -#ifdef WILC_SDIO
>>> -	if (!wilc_hif_sdio.hif_init(wilc, wilc_debug)) {
>>> -		ret = -EIO;
>>> -		goto _fail_;
>>> -	}
>>> -	memcpy((void *)&g_wlan.hif_func, &wilc_hif_sdio,
>>> -	       sizeof(struct wilc_hif_func));
>>> -#else
>>> -	if (!wilc_hif_spi.hif_init(wilc, wilc_debug)) {
>>> +	g_wlan.hif_func = *wilc->ops;
>>> +	if (!g_wlan.hif_func.hif_init(wilc, wilc_debug)) {
>>>    		ret = -EIO;
>>>    		goto _fail_;
>>>    	}
>>> -	memcpy((void *)&g_wlan.hif_func, &wilc_hif_spi,
>>> -	       sizeof(struct wilc_hif_func));
>>> -#endif
> This is the most likely part I found:
>
> doing an assigment instead of memcpy should not make a difference,
> but my new version also called init after copying over the
> operations rather than before. This seemed to be the correct
> order when I did it, but it is a change in behavior that might
> cause problems if some code relies on the hif_func structure
> to be empty at the time that hif_init is called.
>
> 	Arnd


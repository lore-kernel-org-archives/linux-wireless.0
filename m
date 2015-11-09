Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:53230 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbKIIxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 03:53:02 -0500
Message-ID: <56405F71.6090404@atmel.com> (sfid-20151109_095308_362707_C5B4FC18)
Date: Mon, 9 Nov 2015 17:55:13 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Punit Vara <punitvara@gmail.com>, <devel@driverdev.osuosl.org>,
	<chris.park@atmel.com>, <austin.shin@atmel.com>,
	<gregkh@linuxfoundation.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <linux-kernel@vger.kernel.org>,
	<tony.cho@atmel.com>, <leo.kim@atmel.com>
Subject: Re: [PATCH V2] Staging: wilc1000: Fix build break due to undeclared
 *wilc and implicit declaration of init_irq
References: <1447018310-4524-1-git-send-email-punitvara@gmail.com> <20151108215953.GO18797@mwanda> <563FFEEB.1090307@atmel.com> <56405328.4040004@atmel.com> <20151109081842.GR18797@mwanda>
In-Reply-To: <20151109081842.GR18797@mwanda>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2015년 11월 09일 17:18, Dan Carpenter wrote:
> On Mon, Nov 09, 2015 at 05:02:48PM +0900, glen lee wrote:
>> Hi Punit Vara,
>>
>> I cannot find build errors on my build machines.
>>
>> According the log which you have posted before says *wilc is undeclared in the function init_wilc_driver,
>> which means WILC_SPI is selected because one of SPI or SDIO should be chosen at the moment.
>> Hence, struct wilc *wilc should be compiled together.
>> It looks like wilc1000 is compiled without SPI or SDIO.
>>
>> Of course, there are many cases that I don't know, so you could let me know the wilc1000 build configuration?
>>
>> static int __init init_wilc_driver(void)
>> {
>> #ifdef WILC_SPI
> This should be #ifndef WILC_SDIO

I will do this in the next patch series.

>
>> 	struct wilc *wilc;
>> #endif
> But the large question remains of why do we have this variable here any
> way?

As you pointed out, the variable is do-nothing for spi driver for now.
After reworking SPI driver, the wilc will be passed to SPI as spi drive data like we already did in SDIO.

We have done this to remove extern variable g_linux_wlan which is primary structure of wilc1000.
For now it is not used, but need it not to break the build.

static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
{
	struct wilc_sdio *wl_sdio;
	struct wilc *wilc;

	PRINT_D(INIT_DBG, "probe function\n");
	wl_sdio = kzalloc(sizeof(struct wilc_sdio), GFP_KERNEL);
	if (!wl_sdio)
		return -ENOMEM;

	PRINT_D(INIT_DBG, "Initializing netdev\n");
	local_sdio_func = func;
	if (wilc_netdev_init(&wilc)) {
		PRINT_ER("Couldn't initialize netdev\n");
		kfree(wl_sdio);
		return -1;
	}
	wl_sdio->func = func;
	wl_sdio->wilc = wilc;
	sdio_set_drvdata(func, wl_sdio);

regards,
glen lee.

>
> regards,
> dan carpenter
>


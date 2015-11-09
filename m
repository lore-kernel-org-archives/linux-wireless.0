Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34269 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbbKIJFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2015 04:05:47 -0500
MIME-Version: 1.0
In-Reply-To: <56405F71.6090404@atmel.com>
References: <1447018310-4524-1-git-send-email-punitvara@gmail.com>
	<20151108215953.GO18797@mwanda>
	<563FFEEB.1090307@atmel.com>
	<56405328.4040004@atmel.com>
	<20151109081842.GR18797@mwanda>
	<56405F71.6090404@atmel.com>
Date: Mon, 9 Nov 2015 14:35:46 +0530
Message-ID: <CABXAfNJHAWd_ygUbcZXDqwGvaCxM3nA5ibOF4sNwzhA3AP=07g@mail.gmail.com> (sfid-20151109_100618_056162_B919DCCC)
Subject: Re: [PATCH V2] Staging: wilc1000: Fix build break due to undeclared
 *wilc and implicit declaration of init_irq
From: punit vara <punitvara@gmail.com>
To: glen lee <glen.lee@atmel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	devel@driverdev.osuosl.org, chris.park@atmel.com,
	Austin Shin <austin.shin@atmel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	linux-kernel@vger.kernel.org, tony.cho@atmel.com, leo.kim@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 9, 2015 at 2:25 PM, glen lee <glen.lee@atmel.com> wrote:
>
> On 2015년 11월 09일 17:18, Dan Carpenter wrote:
>>
>> On Mon, Nov 09, 2015 at 05:02:48PM +0900, glen lee wrote:
>>>
>>> Hi Punit Vara,
>>>
>>> I cannot find build errors on my build machines.
>>>
>>> According the log which you have posted before says *wilc is undeclared
>>> in the function init_wilc_driver,
>>> which means WILC_SPI is selected because one of SPI or SDIO should be
>>> chosen at the moment.
>>> Hence, struct wilc *wilc should be compiled together.
>>> It looks like wilc1000 is compiled without SPI or SDIO.
>>>
>>> Of course, there are many cases that I don't know, so you could let me
>>> know the wilc1000 build configuration?
>>>
>>> static int __init init_wilc_driver(void)
>>> {
>>> #ifdef WILC_SPI
>>
>> This should be #ifndef WILC_SDIO
>
>
> I will do this in the next patch series.
>
>>
>>>         struct wilc *wilc;
>>> #endif
>>
>> But the large question remains of why do we have this variable here any
>> way?
>
>
> As you pointed out, the variable is do-nothing for spi driver for now.
> After reworking SPI driver, the wilc will be passed to SPI as spi drive data
> like we already did in SDIO.
>
> We have done this to remove extern variable g_linux_wlan which is primary
> structure of wilc1000.
> For now it is not used, but need it not to break the build.
>
> static int linux_sdio_probe(struct sdio_func *func, const struct
> sdio_device_id *id)
> {
>         struct wilc_sdio *wl_sdio;
>         struct wilc *wilc;
>
>         PRINT_D(INIT_DBG, "probe function\n");
>         wl_sdio = kzalloc(sizeof(struct wilc_sdio), GFP_KERNEL);
>         if (!wl_sdio)
>                 return -ENOMEM;
>
>         PRINT_D(INIT_DBG, "Initializing netdev\n");
>         local_sdio_func = func;
>         if (wilc_netdev_init(&wilc)) {
>                 PRINT_ER("Couldn't initialize netdev\n");
>                 kfree(wl_sdio);
>                 return -1;
>         }
>         wl_sdio->func = func;
>         wl_sdio->wilc = wilc;
>         sdio_set_drvdata(func, wl_sdio);
>
> regards,
> glen lee.
>
>>
>> regards,
>> dan carpenter
>>
>
How about this patch @Dan and @glen ,For me it does not create any
build error. For #ifndef WILC_SDIO  that pointer *wilc is not
compiling so that creates the error.

--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -224,7 +224,7 @@ static int dev_state_ev_handler(struct
notifier_block *this, unsigned long event

 }

-#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
+#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO) || (!defined WIC_SDIO)
 static irqreturn_t isr_uh_routine(int irq, void *user_data)
 {
        perInterface_wlan_t *nic;
@@ -264,7 +264,7 @@ irqreturn_t isr_bh_routine(int irq, void *userdata)
        return IRQ_HANDLED;
 }

-#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
+#if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO) || (!defined WILC_SDIO)
 static int init_irq(struct net_device *dev)
 {
        int ret = 0;
@@ -1083,6 +1083,10 @@ static void wlan_deinitialize_threads(struct
net_device *dev)
        }
 }

+#if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
+static int init_irq(struct net_device *dev);
+#endif
+
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 {
        wilc_wlan_inp_t nwi;
@@ -1791,7 +1795,7 @@ int wilc_netdev_init(struct wilc **wilc)
 /*The 1st function called after module inserted*/
 static int __init init_wilc_driver(void)
 {
-#ifdef WILC_SPI
+#if (defined WILC_SPI) || (!defined WILC_SDIO)
        struct wilc *wilc;
 #endif

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56374 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759871Ab0J1RBz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 13:01:55 -0400
Message-ID: <4CC9AC72.40909@ti.com>
Date: Thu, 28 Oct 2010 19:01:38 +0200
From: Shahar Levi <shahar_levi@ti.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH ] wl1271: Change wl12xx Files Names
References: <1288091935-21688-1-git-send-email-shahar_levi@ti.com>	 <1288207558.1698.56.camel@powerslave>  <4CC9A1F5.4010308@ti.com> <1288285263.3414.7.camel@powerslave>
In-Reply-To: <1288285263.3414.7.camel@powerslave>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/2010 07:01 PM, Luciano Coelho wrote:
> Hi Shahar,
Hi Luca,

> On Thu, 2010-10-28 at 18:16 +0200, ext Shahar Levi wrote:
>> On 10/27/2010 09:25 PM, Luciano Coelho wrote:
>>> On Tue, 2010-10-26 at 13:18 +0200, ext Shahar Levi wrote:
>>>> -config WL1271
>>>> -       tristate "TI wl1271 support"
>>>> +config WL127X
>>>> +       tristate "TI wl127x support"make -j10 modules&&  (make modules_install ARCH=arm INSTALL_MOD_PATH=/home/nfs/ )
>>>
>>> Why not use WL12XX and wl12xx here already? Regarding the wl128x stuff,
>>> as I mentioned before, I think it's best if we do the check at runtime
>>> and not in Kconfig.
>> In case the 128x will check at runtime you right.
>> Will be fix in v2, if we will agreed otherwise i will revert.
>
> Yes, as I commented to your wl128x patch, I think we should wait until
> we can do it at runtime, so no need to differentiate in the
> configuration.
>
>
>>>> +wl12xx_spi-objs                = spi.o
>>>> +wl12xx_sdio-objs       = sdio.o
>>>
>>> Here...
>> Will be fix in v2
>
> There's nothing to fix here.  I just pointed out that the modules are
> actually called wl12xx_sdio and wl12xx_spi.  So it's correct here
> already.
Due to the fact it is confusing spi and sdio i renamed spi.c file name 
to wl12xx_spi.c (in v2) and in that case i remove those lines.
The same catch for sdio.c

>>>> -wl1271-$(CONFIG_NL80211_TESTMODE)      += wl1271_testmode.o
>>>> -obj-$(CONFIG_WL1271)   += wl1271.o
>>>> -obj-$(CONFIG_WL1271_SPI)       += wl1271_spi.o
>>>> -obj-$(CONFIG_WL1271_SDIO)      += wl1271_sdio.o
>>>> +wl1271-$(CONFIG_NL80211_TESTMODE)      += testmode.o
>>>> +obj-$(CONFIG_WL127X)                   += wl12xx.o
>>>> +obj-$(CONFIG_WL12XX_SPI)               += wl12xx_spi.o
>>>> +obj-$(CONFIG_WL12XX_SDIO)              += wl12xx_sdio.o
>>>
>>> ...and here, you're using wl12xx_spi and wl12xx_sdio correctly, which
>>> reinforces my comment about calling the modules "spi.ko" and "sdio.ko"
>>> in the Kconfig section ;)
>> Will be fix in v2
>
> Again, nothing to fix here.
you right.

>>>> diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/conf.h
>>>> similarity index 100%
>>>> rename from drivers/net/wireless/wl12xx/wl1271_conf.h
>>>> rename to drivers/net/wireless/wl12xx/conf.h
>>>
>>> You forgot to change this:
>>>
>>> #ifndef __WL1271_CONF_H__
>>>
>>> to:
>>>
>>> #ifndef __WL12XX_CONF_H__
>>>
>>> And the other appearances of __WL1271_CONF_H__ in that file.  This
>>> applies to all header files.
>> we agreed that change will be in second stage.
>> not fix for now.
>
> This is a different thing.  These macros are always directly related to
> the file name.  Keeping it as __WL1271_CONF_H__ here would be confusing,
> since the file is actually called conf.h.  Actually I was wrong when I
> said it should be changed to "__WL12XX_CONF_H__" it should be only
> "__CONF_H__".
Will be fix in v2

>>>> diff --git a/drivers/net/wireless/wl12xx/wl1271_debugfs.h b/drivers/net/wireless/wl12xx/debugfs.h
>>>> similarity index 98%
>>>> rename from drivers/net/wireless/wl12xx/wl1271_debugfs.h
>>>> rename to drivers/net/wireless/wl12xx/debugfs.h
>>>> index 00a45b2..d12bf93 100644
>>>> --- a/drivers/net/wireless/wl12xx/wl1271_debugfs.h
>>>> +++ b/drivers/net/wireless/wl12xx/debugfs.h
>>>> @@ -24,7 +24,7 @@
>>>>    #ifndef WL1271_DEBUGFS_H
>>>>    #define WL1271_DEBUGFS_H
>>>
>>> As mentioned above, this #ifndef and #define needs to be changed too.
>> we agreed that change will be in second stage.
>> not fix for now.
>
> Same as above.  Please fix all the #ifndef and #define in all header
> files to correctly match the file names.
Will be fix in v2

>>>> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/main.c
>>>> similarity index 99%
>>>> rename from drivers/net/wireless/wl12xx/wl1271_main.c
>>>> rename to drivers/net/wireless/wl12xx/main.c
>>>> index 63036b5..dab10a5 100644
>>>> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
>>>> +++ b/drivers/net/wireless/wl12xx/main.c
>>>> @@ -31,20 +31,20 @@
>>>
>>> [...]
>>>
>>>>    #define WL1271_BOOT_RETRIES 3
>>>
>>> Did we agree not to change this stuff for now? Yes, now I remember, it's
>>> better to do it in two steps indeed (ie. do the other changes in a
>>> separate patch).  But I'd rather apply all the patches add once.
>> I believe that patch could stand alone. There isn't any connection
>> between files names and function+defines names.
>
> Yes, no need to change these macros or function names in this patch.
In that case it can be apply alon, is it? ;-)


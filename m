Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58603 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab0IFL4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 07:56:16 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=goLEUqM1XQ__PrGu4=Erw2utaNP4qFmSgRta2@mail.gmail.com>
References: <1283376410-9999-1-git-send-email-ohad@wizery.com>
 <1283376410-9999-4-git-send-email-ohad@wizery.com> <AANLkTi=goLEUqM1XQ__PrGu4=Erw2utaNP4qFmSgRta2@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 6 Sep 2010 14:55:55 +0300
Message-ID: <AANLkTim91620+bmHWewucX5tP8Z-NUkrW2cJYJ+jpMoD@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] wireless: wl12xx: add platform data passing support
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-omap@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Nicolas Pitre <nico@fluxnic.net>,
	Tony Lindgren <tony@atomide.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Ido Yariv <ido@wizery.com>, San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/4 Micha³ Miros³aw <mirqus@gmail.com>:
> 2010/9/1 Ohad Ben-Cohen <ohad@wizery.com>:
>> Add a simple mechanism to pass platform data to the
>> SDIO instances of wl12xx.
>>
>> This way there is no confusion over who owns the 'embedded data',
>> typechecking is preserved, and no possibility for the wrong driver to
>> pick up the data.
>>
>> Originally proposed by Russell King.
>>
>> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
>> ---
>>  drivers/net/wireless/Makefile                      |    2 +
>>  drivers/net/wireless/wl12xx/Kconfig                |    5 ++-
>>  drivers/net/wireless/wl12xx/wl12xx_platform_data.c |   31 ++++++++++++++++++++
>>  include/linux/wl12xx.h                             |    3 ++
>>  4 files changed, 40 insertions(+), 1 deletions(-)
>>  create mode 100644 drivers/net/wireless/wl12xx/wl12xx_platform_data.c
>>
>> diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
>> index 5d4ce4d..85af697 100644
>> --- a/drivers/net/wireless/Makefile
>> +++ b/drivers/net/wireless/Makefile
>> @@ -50,5 +50,7 @@ obj-$(CONFIG_ATH_COMMON)      += ath/
>>  obj-$(CONFIG_MAC80211_HWSIM)   += mac80211_hwsim.o
>>
>>  obj-$(CONFIG_WL12XX)   += wl12xx/
>> +# small builtin driver bit
>> +obj-$(CONFIG_WL12XX_PLATFORM_DATA)     += wl12xx/wl12xx_platform_data.o
>>
>>  obj-$(CONFIG_IWM)      += iwmc3200wifi/
>> diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
>> index 2f98058..4a8bb25 100644
>> --- a/drivers/net/wireless/wl12xx/Kconfig
>> +++ b/drivers/net/wireless/wl12xx/Kconfig
>> @@ -74,4 +74,7 @@ config WL1271_SDIO
>>          If you choose to build a module, it'll be called
>>          wl1271_sdio. Say N if unsure.
>>
>> -
>> +config WL12XX_PLATFORM_DATA
>> +       bool
>> +       depends on WL1271_SDIO != n
>> +       default y
>> diff --git a/drivers/net/wireless/wl12xx/wl12xx_platform_data.c b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
>> new file mode 100644
>> index 0000000..e00973b
>> --- /dev/null
>> +++ b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
>> @@ -0,0 +1,31 @@
>> +#include <linux/module.h>
>> +#include <linux/wl12xx.h>
>> +
>> +static struct wl12xx_platform_data *platform_data;
>> +
>> +int __init wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
>> +{
>> +       if (platform_data)
>> +               return -EBUSY;
>> +       if (!data)
>> +               return -EINVAL;
>> +
>> +       platform_data = kmemdup(data, sizeof(*data), GFP_KERNEL);
>> +       if (!platform_data)
>> +               return -ENOMEM;
>> +
>> +       return 0;
>> +}
>> +
>> +int wl12xx_get_platform_data(struct wl12xx_platform_data *data)
>> +{
>> +       if (!platform_data)
>> +               return -ENODEV;
>> +       if (!data)
>> +               return -EINVAL;
>> +
>> +       memcpy(data, platform_data, sizeof(*data));
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL(wl12xx_get_platform_data);
>> diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
>> index 137ac89..3e33ae1 100644
>> --- a/include/linux/wl12xx.h
>> +++ b/include/linux/wl12xx.h
>> @@ -31,4 +31,7 @@ struct wl12xx_platform_data {
>>        bool use_eeprom;
>>  };
>>
>> +int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
>> +int wl12xx_get_platform_data(struct wl12xx_platform_data *data);
>> +
>>  #endif
>
> Why do you need all that copying? Isn't the data constant?

That was the original proposal from Russell;

AFAICT it's very similar to how platform device resources are handled
- it allows marking the original definition of the data as __initdata
(need to add that) thus freeing up its space after the initialization
phase completes. Later, in some scenarios, it might also allow to free
up the copied data (not done now, but the copying happen only once in
the lifetime of the driver so I'm fine with it).

>
> Best Regards,
> Micha³ Miros³aw
>

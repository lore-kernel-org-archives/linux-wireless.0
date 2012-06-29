Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45705 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab2F2LEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 07:04:51 -0400
Received: by wibhq12 with SMTP id hq12so776370wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2012 04:04:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340966352.6562.17.camel@joe2Laptop>
References: <1340964011-17528-1-git-send-email-zajec5@gmail.com>
	<1340966352.6562.17.camel@joe2Laptop>
Date: Fri, 29 Jun 2012 13:04:50 +0200
Message-ID: <CACna6rwf-uBGYRrNRWTvvSdO-EB7pykd-XOs9AE4UTLoKCHxPw@mail.gmail.com> (sfid-20120629_130455_497915_DA72F898)
Subject: Re: [PATCH] bcma: use custom printing functions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/29 Joe Perches <joe@perches.com>:
> On Fri, 2012-06-29 at 12:00 +0200, Rafał Miłecki wrote:
>> Having bus number printed makes it much easier to anaylze logs on
>> systems with more buses. For example Netgear WNDR4500 has 3 AMBA buses
>> in total, which makes standard log really messy.
>
> Hi again Rafał
>
>> diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
> []
>> @@ -10,6 +10,14 @@
>>
>>  #define BCMA_CORE_SIZE               0x1000
>>
>> +/* We use pr_fmt, so call printk directly */
>> +#define bcma_err(bus, fmt, ...) \
>> +     printk(KERN_ERR KBUILD_MODNAME " bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
>> +#define bcma_warn(bus, fmt, ...) \
>> +     printk(KERN_WARNING KBUILD_MODNAME " bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
>> +#define bcma_info(bus, fmt, ...) \
>> +     printk(KERN_INFO KBUILD_MODNAME " bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
>
> seems fine.
>
>> diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
> []
>> @@ -56,6 +56,7 @@ EXPORT_SYMBOL_GPL(bcma_core_enable);
>>  void bcma_core_set_clockmode(struct bcma_device *core,
>>                            enum bcma_clkmode clkmode)
>>  {
>> +     struct bcma_bus *bus = core->bus;
>
> It seems unnecessary to me to do this assignment here
> and in lots of other places when it's only used once.
>
> It could cause unnecessary stack pressure.
>
>> @@ -75,7 +76,7 @@ void bcma_core_set_clockmode(struct bcma_device *core,
>>                       udelay(10);
>>               }
>>               if (i)
>> -                     pr_err("HT force timeout\n");
>> +                     bcma_err(bus, "HT force timeout\n");
>
> These individual style uses could become
>
>                        bcma_err(core->bus, "HT force timeout\n");
>
> []
>
>> @@ -137,8 +138,8 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
>>                                      | BCMA_CC_CORECTL_UARTCLKEN);
>>               }
>>       } else {
>> -             pr_err("serial not supported on this device ccrev: 0x%x\n",
>> -                    ccrev);
>> +             bcma_err(bus, "serial not supported on this device "
>> +                      "ccrev: 0x%x\n", ccrev);
>
>                bcma_err(cc->core->bus, "serial not supported on this device ccrev: 0x%x\n",
>                         ccrev);
>
> Please don't split format strings.  Ignore 80 column lengths for
> the formats only.
>
> From Documentatation/CodingStyle chapter 2:
>
> The limit on the length of lines is 80 columns and this is a strongly
> preferred limit.
> []
> However, never break user-visible strings such as
> printk messages, because that breaks the ability to grep for them.

Thanks for your comments, I'll fix that.

-- 
Rafał

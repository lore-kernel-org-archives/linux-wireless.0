Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54520 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab2KTVHx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 16:07:53 -0500
Message-ID: <50ABF11E.204@hauke-m.de> (sfid-20121120_220756_504411_89D90599)
Date: Tue, 20 Nov 2012 22:07:42 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: John Crispin <john@phrozen.org>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, florian@openwrt.org,
	zajec5@gmail.com, m@bues.ch
Subject: Re: [PATCH 7/8] ssb: add GPIO driver
References: <1353365877-11131-1-git-send-email-hauke@hauke-m.de> <1353365877-11131-8-git-send-email-hauke@hauke-m.de> <50AB3B6C.4000505@phrozen.org>
In-Reply-To: <50AB3B6C.4000505@phrozen.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/2012 09:12 AM, John Crispin wrote:
> Hi Hauke,
> 
> 
>> +#ifdef CONFIG_SSB_DRIVER_EXTIF
> 
> ...
> 
>> +}
>> +
>> +#else
>> +static int ssb_gpio_extif_init(struct ssb_bus *bus)
>> +{
>> +    return 0;
>> +}
>> +#endif
> 
> ssb_gpio_extif_init() is also defined as a static inline stub in the
> header files. you should drop this definition from the code file
> 
>     John
No, ssb_gpio_extif_init() is only defined in drivers/ssb/driver_gpio.c
and not ssb_private.h, ssb_gpio_init() is defined in ssb_private.h.

Hauke

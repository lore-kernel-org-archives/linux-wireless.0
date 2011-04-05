Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39153 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1DEUPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 16:15:54 -0400
Received: by qwk3 with SMTP id 3so465147qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2011 13:15:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1302032137.3969.10.camel@Joe-Laptop>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	<1302032137.3969.10.camel@Joe-Laptop>
Date: Tue, 5 Apr 2011 22:15:53 +0200
Message-ID: <BANLkTimTmqop-xzFsWr1=2RXv5z6iTre4Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	Arend van Spriel <arend@broadcom.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/5 Joe Perches <joe@perches.com>:
> On Tue, 2011-04-05 at 21:57 +0200, Rafał Miłecki wrote:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>
> Just some trivia.
>
>> diff --git a/drivers/bcmai/b43_pci_ai_bridge.c b/drivers/bcmai/b43_pci_ai_bridge.c
> []
>> +#include <linux/bcmai/bcmai.h>
>> +#include <linux/bcmai/bcmai_regs.h>
>> +#include <linux/pci.h>
>> +
>> +static const struct pci_device_id b43_pci_ai_bridge_tbl[] = {
>
> DEFINE_PCI_DEVICE_TABLE

Thanks, I'll convert.


>> diff --git a/drivers/bcmai/core.c b/drivers/bcmai/core.c
> []
>> +             bcmai_err("Power control not implemented!\n");
> []
>> diff --git a/include/linux/bcmai/bcmai.h b/include/linux/bcmai/bcmai.h
> []
>> +#define bcmai_info(fmt, args...)     printk(KERN_INFO "bcmai: " fmt, ##args)
>> +#ifdef CONFIG_BCMAI_DEBUG
>> +#define bcmai_dbg(fmt, args...)              printk(KERN_DEBUG "bcmai debug: " fmt, ##args)
>> +#else
>> +#define bcmai_dbg(fmt, args...)              do { } while (0)
>> +#endif
>> +#define bcmai_err(fmt, args...)              printk(KERN_ERR "bcmai error: " fmt, ##args)
>
> I think there's very little value in prefixing
> "error" and "debug" in front of equivalent
> KERN_<level> message levels.
>
> I think you might as well just use pr_<level>
> and pr_fmt.

Hm, I've taken this idea from ssb and b43:
[b43err] printk(KERN_ERR "b43-%s ERROR: %pV", ...);
[_pll_init] ssb_printk(KERN_ERR PFX "ERROR: PLL init unknown for...

Some more reviews, please? Should I drop that prefix, is Joe right? Or
is there some official coding-style for such a situations?



>> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> []
>> +/* AI core, see drivers/bcmai/ */
>> +struct bcmai_device_id {
>> +     __u16   manuf;
>> +     __u16   id;
>> +     __u8    rev;
>> +};
>
> Do some of these structs need __packed declarations?

I was reading about __packed long time ago and it was a little tricky
for me. However I don't see anything in mod_devicetable.h using that
__packed. Why should we?

-- 
Rafał

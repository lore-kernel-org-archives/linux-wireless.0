Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 7.mo3.mail-out.ovh.net ([46.105.57.200]:60749 "EHLO
        7.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751710AbdJSLX3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Oct 2017 07:23:29 -0400
Received: from player158.ha.ovh.net (b6.ovh.net [213.186.33.56])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id 5EE51161353
        for <linux-wireless@vger.kernel.org>; Thu, 19 Oct 2017 08:33:57 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 19 Oct 2017 08:33:51 +0200
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: Joe Perches <joe@perches.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcma: use bcma_debug and pr_cont in MIPS driver
In-Reply-To: <1508377091.6806.32.camel@perches.com>
References: <20171016125432.11655-1-zajec5@gmail.com>
 <50b62ff7-40c2-6980-27f8-4776b059800c@hauke-m.de>
 <1508377091.6806.32.camel@perches.com>
Message-ID: <e7eb6c80162d43998386fe2b22814125@milecki.pl> (sfid-20171019_132333_093363_EED41C13)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-10-19 03:38, Joe Perches wrote:
> On Mon, 2017-10-16 at 23:21 +0200, Hauke Mehrtens wrote:
>> On 10/16/2017 02:54 PM, Rafał Miłecki wrote:
>> > From: Rafał Miłecki <rafal@milecki.pl>
>> >
>> > Using bcma_debug gives a device-specific prefix for messages and pr_cont
>> > is a common helper for continuing a line.
>> >
>> > Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> 
>> Acked-By: Hauke Mehrtens <hauke@hauke-m.de>
>> 
>> > ---
>> >  drivers/bcma/driver_mips.c | 7 ++++---
>> >  1 file changed, 4 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
>> > index 89af807cf29c..5904ef1aa624 100644
>> > --- a/drivers/bcma/driver_mips.c
>> > +++ b/drivers/bcma/driver_mips.c
>> > @@ -184,10 +184,11 @@ static void bcma_core_mips_print_irq(struct bcma_device *dev, unsigned int irq)
>> >  {
>> >  	int i;
>> >  	static const char *irq_name[] = {"2(S)", "3", "4", "5", "6", "D", "I"};
>> > -	printk(KERN_DEBUG KBUILD_MODNAME ": core 0x%04x, irq :", dev->id.id);
>> > +
>> > +	bcma_debug(dev->bus, "core 0x%04x, irq :", dev->id.id);
>> >  	for (i = 0; i <= 6; i++)
>> > -		printk(" %s%s", irq_name[i], i == irq ? "*" : " ");
>> > -	printk("\n");
>> > +		pr_cont(" %s%s", irq_name[i], i == irq ? "*" : " ");
>> > +	pr_cont("\n");
>> >  }
>> >
>> >  static void bcma_core_mips_dump_irq(struct bcma_bus *bus)
>> >
> 
> This isn't the same code as it depends on #define DEBUG
> and will not output the first line in most cases.

Oh, I didn't think about bcma_debug (pr_debug) being no_printk indeed.
AFAIU it will indeed make pr_cont default to the KERN_DEFAULT.

I'll try to test your code today or tomorrow, thanks!

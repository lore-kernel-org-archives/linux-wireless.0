Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:41662 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751038AbdJSBiP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 21:38:15 -0400
Message-ID: <1508377091.6806.32.camel@perches.com> (sfid-20171019_033820_107585_FE810CFC)
Subject: Re: [PATCH] bcma: use bcma_debug and pr_cont in MIPS driver
From: Joe Perches <joe@perches.com>
To: Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Wed, 18 Oct 2017 18:38:11 -0700
In-Reply-To: <50b62ff7-40c2-6980-27f8-4776b059800c@hauke-m.de>
References: <20171016125432.11655-1-zajec5@gmail.com>
         <50b62ff7-40c2-6980-27f8-4776b059800c@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-10-16 at 23:21 +0200, Hauke Mehrtens wrote:
> On 10/16/2017 02:54 PM, Rafał Miłecki wrote:
> > From: Rafał Miłecki <rafal@milecki.pl>
> > 
> > Using bcma_debug gives a device-specific prefix for messages and pr_cont
> > is a common helper for continuing a line.
> > 
> > Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> 
> Acked-By: Hauke Mehrtens <hauke@hauke-m.de>
> 
> > ---
> >  drivers/bcma/driver_mips.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
> > index 89af807cf29c..5904ef1aa624 100644
> > --- a/drivers/bcma/driver_mips.c
> > +++ b/drivers/bcma/driver_mips.c
> > @@ -184,10 +184,11 @@ static void bcma_core_mips_print_irq(struct bcma_device *dev, unsigned int irq)
> >  {
> >  	int i;
> >  	static const char *irq_name[] = {"2(S)", "3", "4", "5", "6", "D", "I"};
> > -	printk(KERN_DEBUG KBUILD_MODNAME ": core 0x%04x, irq :", dev->id.id);
> > +
> > +	bcma_debug(dev->bus, "core 0x%04x, irq :", dev->id.id);
> >  	for (i = 0; i <= 6; i++)
> > -		printk(" %s%s", irq_name[i], i == irq ? "*" : " ");
> > -	printk("\n");
> > +		pr_cont(" %s%s", irq_name[i], i == irq ? "*" : " ");
> > +	pr_cont("\n");
> >  }
> >  
> >  static void bcma_core_mips_dump_irq(struct bcma_bus *bus)
> > 

This isn't the same code as it depends on #define DEBUG
and will not output the first line in most cases.

I'd suggest a nack.

Perhaps it'd be better to use a temporary and avoid the
pr_cont uses like:

{
	int i;
	static const char *irq_name[] = {"2(S)", "3", "4", "5", "6", "D", "I"};
	char interrupts[20];
	char *ints = interrupts;

	for (i = 0; i < ARRAY_SIZE(irq_name), i++)
		ints += sprintf(ints, " %s%c", irq_name[i], i == irq ? '*' : ' ');

	bcma_debug(dev->bus, "core 0x04x, irq: %s\n", dev->id.id, interrupts);
}

		

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34722 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbdJSET6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Oct 2017 00:19:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org,
        =?utf-8?Q?Rafa?= =?utf-8?Q?=C5=82_Mi=C5=82ecki?=
        <rafal@milecki.pl>
Subject: Re: [PATCH] bcma: use bcma_debug and pr_cont in MIPS driver
References: <20171016125432.11655-1-zajec5@gmail.com>
        <50b62ff7-40c2-6980-27f8-4776b059800c@hauke-m.de>
        <1508377091.6806.32.camel@perches.com>
Date: Thu, 19 Oct 2017 07:19:52 +0300
In-Reply-To: <1508377091.6806.32.camel@perches.com> (Joe Perches's message of
        "Wed, 18 Oct 2017 18:38:11 -0700")
Message-ID: <87shefojkn.fsf@codeaurora.org> (sfid-20171019_062033_538604_4C9FD2D5)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Mon, 2017-10-16 at 23:21 +0200, Hauke Mehrtens wrote:
>> On 10/16/2017 02:54 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
>> > From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>> >=20
>> > Using bcma_debug gives a device-specific prefix for messages and pr_co=
nt
>> > is a common helper for continuing a line.
>> >=20
>> > Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>=20
>> Acked-By: Hauke Mehrtens <hauke@hauke-m.de>
>>=20
>> > ---
>> >  drivers/bcma/driver_mips.c | 7 ++++---
>> >  1 file changed, 4 insertions(+), 3 deletions(-)
>> >=20
>> > diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
>> > index 89af807cf29c..5904ef1aa624 100644
>> > --- a/drivers/bcma/driver_mips.c
>> > +++ b/drivers/bcma/driver_mips.c
>> > @@ -184,10 +184,11 @@ static void bcma_core_mips_print_irq(struct bcma=
_device *dev, unsigned int irq)
>> >  {
>> >  	int i;
>> >  	static const char *irq_name[] =3D {"2(S)", "3", "4", "5", "6", "D", =
"I"};
>> > -	printk(KERN_DEBUG KBUILD_MODNAME ": core 0x%04x, irq :", dev->id.id);
>> > +
>> > +	bcma_debug(dev->bus, "core 0x%04x, irq :", dev->id.id);
>> >  	for (i =3D 0; i <=3D 6; i++)
>> > -		printk(" %s%s", irq_name[i], i =3D=3D irq ? "*" : " ");
>> > -	printk("\n");
>> > +		pr_cont(" %s%s", irq_name[i], i =3D=3D irq ? "*" : " ");
>> > +	pr_cont("\n");
>> >  }
>> >=20=20
>> >  static void bcma_core_mips_dump_irq(struct bcma_bus *bus)
>> >=20
>
> This isn't the same code as it depends on #define DEBUG
> and will not output the first line in most cases.
>
> I'd suggest a nack.

Too late, I already applied this. Please submit a followup patch if
something needs to be changed.

--=20
Kalle Valo

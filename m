Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4531 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab1DEUhQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 16:37:16 -0400
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	Arend van Spriel <arend@broadcom.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>,
	b43-dev@lists.infradead.org
In-Reply-To: <BANLkTimTmqop-xzFsWr1=2RXv5z6iTre4Q@mail.gmail.com>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	 <1302032137.3969.10.camel@Joe-Laptop>
	 <BANLkTimTmqop-xzFsWr1=2RXv5z6iTre4Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 13:37:14 -0700
Message-ID: <1302035834.3969.27.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-05 at 22:15 +0200, Rafał Miłecki wrote:
> 2011/4/5 Joe Perches <joe@perches.com>:
> > On Tue, 2011-04-05 at 21:57 +0200, Rafał Miłecki wrote:
> >> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> > Just some trivia.
[]
> >> diff --git a/drivers/bcmai/core.c b/drivers/bcmai/core.c
> > []
> >> +             bcmai_err("Power control not implemented!\n");
> > []
> >> diff --git a/include/linux/bcmai/bcmai.h b/include/linux/bcmai/bcmai.h
> > []
> >> +#define bcmai_info(fmt, args...)     printk(KERN_INFO "bcmai: " fmt, ##args)
> >> +#ifdef CONFIG_BCMAI_DEBUG
> >> +#define bcmai_dbg(fmt, args...)              printk(KERN_DEBUG "bcmai debug: " fmt, ##args)
> >> +#else
> >> +#define bcmai_dbg(fmt, args...)              do { } while (0)
> >> +#endif
> >> +#define bcmai_err(fmt, args...)              printk(KERN_ERR "bcmai error: " fmt, ##args)
> > I think there's very little value in prefixing
> > "error" and "debug" in front of equivalent
> > KERN_<level> message levels.
> > I think you might as well just use pr_<level>
> > and pr_fmt.
> Hm, I've taken this idea from ssb and b43:
> [b43err] printk(KERN_ERR "b43-%s ERROR: %pV", ...);

I think that per module extra text based
"error/info/whatnot" prefixes are just unnecessary
duplication to KERN_<level>.

> [_pll_init] ssb_printk(KERN_ERR PFX "ERROR: PLL init unknown for...

[]

I think ssb_printk and CONFIG_SSB_SILENT is not
particularly useful.  I think printk support is
or should be generally enabled or disabled and a
per module on/off just for embedded module size
is unnecessary complexity for almost no benefit.

> is there some official coding-style for such a situations?

There's definitely no mandated coding-style for such things
and I certainly support per module named module_<level>
prefixing where the module passes some struct pointer
or another for things like masking printing of specific
errors or debugging levels.

Like:

#define <modulename>_info(foo, fmt, ...) \
	pr_info("%s: " fmt, foo->info, ##__VA_ARGS__)

or

__attribute__((format (printf, 2, 3)))
int <modulename>_info(struct type, const char *fmt, ...)
{
	int rtn;
	struct va_format vaf;
	va_list args;

	va_start(args, fmt);

        vaf.fmt = fmt;
        vaf.va = &args;

	rtn = pr_info"%s: %pV", type->info, &vaf);

        va_end(args);

	return rtn;
}

> >> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> > []
> >> +/* AI core, see drivers/bcmai/ */
> >> +struct bcmai_device_id {
> >> +     __u16   manuf;
> >> +     __u16   id;
> >> +     __u8    rev;
> >> +};
> >
> > Do some of these structs need __packed declarations?
> 
> I was reading about __packed long time ago and it was a little tricky
> for me. However I don't see anything in mod_devicetable.h using that
> __packed. Why should we?

I didn't look very hard.  If this struct (or any other)
is read directly from some device expecting a contiguous
byte block, then it's likely that it should be declared
"__packed".
 
cheers, Joe


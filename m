Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:58576 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab1BIVLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 16:11:34 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000020105.msg
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 23:10:53 +0200
Subject: Re: SSB AI support code ([RFC4/11] SSB core control and state
	device ops)
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTinC+ijSG=qzzk9OWLGRLsxM0dm12YkERxKbwg6t@mail.gmail.com>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <1297262089.18053.24.camel@dev.znau.edu.ua>
	 <AANLkTinC+ijSG=qzzk9OWLGRLsxM0dm12YkERxKbwg6t@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 09 Feb 2011 23:03:58 +0200
Message-Id: <1297285438.11767.28.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


В Срд, 09/02/2011 в 21:35 +0100, Rafał Miłecki пишет: 
> 2011/2/9 George Kashperko <george@znau.edu.ua>:
> > From: George Kashperko <george@znau.edu.ua>
> >
> > Introduce handlers for SB core control and state flags' management. SB-style
> > buses provide access to these flags at two high octets of TMSLOW and TMSHIGH
> > registers whereas AI-ones implement these flags in two low octets of IOCTRL
> > and IOSTAT registers.
> > Signed-off-by: George Kashperko <george@znau.edu.ua>
> > ---
> >  drivers/ssb/main.c      |   36 ++++++++++++++++++++++++++++++++++++
> >  include/linux/ssb/ssb.h |   14 +++++++++++++-
> >  2 files changed, 49 insertions(+), 1 deletion(-)
> > --- linux-next-20110203.orig/drivers/ssb/main.c 2011-02-07 16:58:50.000000000 +0200
> > +++ linux-next-20110203/drivers/ssb/main.c      2011-02-07 17:07:11.000000000 +0200
> > @@ -1350,6 +1350,40 @@ static u32 ssb_admatch_size_sb(struct ss
> >        return size;
> >  }
> >
> > +static void ssb_core_ctl_flags_sb(struct ssb_device *dev, u32 mask,
> > +                                 u32 val, u32 *res)
> > +{
> > +       u32 tmp;
> > +
> > +       if (mask || val) {
> > +               tmp = (ssb_read32(dev, SSB_TMSLOW) & ~mask) | val;
> > +               ssb_write32(dev, SSB_TMSLOW, tmp);
> > +       }
> 
> Are you going to use that function for just reading SSB_TMSLOW? Why
> won't you use separated function then? Do you need separated function
> for sth so simple as "ssb_read32(dev, SSB_TMSLOW);" at all?
Will answer your question with another question ;)
What would you personally prefer (press "1" or "2" :p)?
1)
if (sb_bus) 
	ssb_write32(dev, (ssb_read32(dev, SSB_TMSLOW) & ~(mask << 16)) | (flags << 16));
else
	ssb_write32(dev, (ssb_read32(dev, SSB_AI_IOCTL) & ~mask) | flags));
2)
ssb_core_ctl_flags(dev, mask, flags, NULL);

> 
> > +       /* readback */
> > +       tmp = ssb_read32(dev, SSB_TMSLOW);
> > +       udelay(1);
> > +
> > +       if (res)
> > +               *res = tmp;
> > +}
> 
> Why are you returning value by writing to pointed place? Can't you
> simply return it? Does returning complicate code so much, it is worth
> using that non-common solution?
> 
If retval would be some memory location or this register accessor will
be used 99% of time just for reading (like ssb_core_state_flags is) I
would just <return retval;> like usual. Declared it in such (don't
really think its complicated, maybe just unusual?) manner just to speed
up things a little bit as io access is somewhat different from direct
(and mostly cached) memory access. This way of doing things changes
almost nothing for SB buses as TMSLOW requires readback to flush changes
posted, whereas readback for SSB_AI_IOCTL is not required and thus
return without reading will save some cpu time.
Not really huge optimisation, I know. Espesially considering how much
often it would be called. If you don't like it feel free to change void
to u32. Personally I dont like that u32 *res anyway ;)

Have nice day,
George



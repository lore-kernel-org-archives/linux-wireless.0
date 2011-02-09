Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:57114 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab1BITdk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 14:33:40 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000020078.msg
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 21:33:03 +0200
Subject: Re: SSB AI support code ([RFC3/11] SSB irqflag device op)
From: George Kashperko <george@znau.edu.ua>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4D52E8A7.3020208@lwfinger.net>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <1297261973.18053.20.camel@dev.znau.edu.ua> <4D52BE92.5070503@lwfinger.net>
	 <1297271450.3361.0.camel@dev.znau.edu.ua> <4D52D358.5050208@lwfinger.net>
	 <1297275805.3361.20.camel@dev.znau.edu.ua>  <4D52E8A7.3020208@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 09 Feb 2011 21:26:06 +0200
Message-Id: <1297279566.5445.2.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On 02/09/2011 12:23 PM, George Kashperko wrote:
> > 
> >> On 02/09/2011 11:10 AM, George Kashperko wrote:
> >>>> On 02/09/2011 08:32 AM, George Kashperko wrote:
> >>>>> From: George Kashperko <george@znau.edu.ua>
> >>>>>
> >>>>> SB- and AI-style buses read irq flags from different locations.
> >>>>> SB-ones read them from TPSFLAG whereas AI-ones from core oob register.
> >>>>> In order to support both SB- and AI-style buses transparently
> >>>>> irq flag accessor is implemented as ssb device op.
> >>>>> Signed-off-by: George Kashperko <george@znau.edu.ua>
> >>>>> ---
> >>>>>  drivers/ssb/driver_mipscore.c       |    2 +-
> >>>>>  drivers/ssb/main.c                  |    1 +
> >>>>>  include/linux/ssb/ssb.h             |    5 +++++
> >>>>>  include/linux/ssb/ssb_driver_mips.h |    1 +
> >>>>>  4 files changed, 8 insertions(+), 1 deletion(-)
> >>>>> --- linux-next-20110203.orig/drivers/ssb/driver_mipscore.c	2011-02-01 05:05:49.000000000 +0200
> >>>>> +++ linux-next-20110203/drivers/ssb/driver_mipscore.c	2011-02-07 16:39:46.000000000 +0200
> >>>>> @@ -47,7 +47,7 @@ static const u32 ipsflag_irq_shift[] = {
> >>>>>  	SSB_IPSFLAG_IRQ4_SHIFT,
> >>>>>  };
> >>>>>  
> >>>>> -static inline u32 ssb_irqflag(struct ssb_device *dev)
> >>>>> +u32 ssb_irqflag_sb(struct ssb_device *dev)
> >>>>>  {
> >>>>>  	u32 tpsflag = ssb_read32(dev, SSB_TPSFLAG);
> >>>>>  	if (tpsflag)
> >>>>> --- linux-next-20110203.orig/drivers/ssb/main.c	2011-02-07 16:35:50.000000000 +0200
> >>>>> +++ linux-next-20110203/drivers/ssb/main.c	2011-02-07 16:49:40.000000000 +0200
> >>>>> @@ -1367,6 +1367,7 @@ static const struct ssb_bus_ops ssb_ssb_
> >>>>>  	.device_disable		= ssb_device_disable_sb,
> >>>>>  	.admatch_base		= ssb_admatch_base_sb,
> >>>>>  	.admatch_size		= ssb_admatch_size_sb,
> >>>>> +	.irqflag		= ssb_irqflag_sb,
> >>>>>  };
> >>>>>  
> >>>>>  static int __init ssb_modinit(void)
> >>>>> --- linux-next-20110203.orig/include/linux/ssb/ssb_driver_mips.h	2011-02-01 05:05:49.000000000 +0200
> >>>>> +++ linux-next-20110203/include/linux/ssb/ssb_driver_mips.h	2011-02-07 16:39:10.000000000 +0200
> >>>>> @@ -29,6 +29,7 @@ extern void ssb_mipscore_init(struct ssb
> >>>>>  extern u32 ssb_cpu_clock(struct ssb_mipscore *mcore);
> >>>>>  
> >>>>>  extern unsigned int ssb_mips_irq(struct ssb_device *dev);
> >>>>> +extern u32 ssb_irqflag_sb(struct ssb_device *dev);
> >>>>>  
> >>>>>  
> >>>>>  #else /* CONFIG_SSB_DRIVER_MIPS */
> >>>>> --- linux-next-20110203.orig/include/linux/ssb/ssb.h	2011-02-07 16:35:50.000000000 +0200
> >>>>> +++ linux-next-20110203/include/linux/ssb/ssb.h	2011-02-07 16:38:34.000000000 +0200
> >>>>> @@ -124,6 +124,7 @@ struct ssb_bus_ops {
> >>>>>  	void (*device_disable)(struct ssb_device *dev, u32 core_specific_flags);
> >>>>>  	u32 (*admatch_base)(struct ssb_device *dev, u32 adm);
> >>>>>  	u32 (*admatch_size)(struct ssb_device *dev, u32 adm);
> >>>>> +	u32 (*irqflag)(struct ssb_device *dev);
> >>>>>  };
> >>>>>  
> >>>>>  
> >>>>> @@ -485,6 +486,10 @@ static inline u32 ssb_admatch_size(struc
> >>>>>  {
> >>>>>  	return dev->ops->admatch_size(dev, adm);
> >>>>>  }
> >>>>> +static inline u32 ssb_irqflag(struct ssb_device *dev)
> >>>>> +{
> >>>>> +	return dev->ops->irqflag(dev);
> >>>>> +}
> >>>>>  
> >>>>>  
> >>>>>  /* The SSB DMA API. Use this API for any DMA operation on the device.
> >>>>>
> >>>>>
> >>>>>
> >>>>> --
> >>>>
> >>>> This one fails to compile with the following error:
> >>>>
> >>>> drivers/ssb/main.c:1370:14: error: ‘ssb_irqflag_sb’ undeclared here (not in a
> >>>> function)
> >>>> make[1]: *** [drivers/ssb/main.o] Error 1
> >>>> make: *** [drivers/ssb/] Error 2
> >>>>
> >>>> Larry
> >>>> --
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> >>>> the body of a message to majordomo@vger.kernel.org
> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>
> >>> Well, might the problem here is again caused with mine wrong post of <[RFC9/11] SSB modify irqflag treatment>
> >>> Could you please remove that one and reaply whole set of patches again.
> >>> Sorry for inconveniences.
> >>
> >> That cannot be the problem with this one. Each patch in a series MUST compile
> >> correctly so that anyone that is bisecting the code always can build a kernel.
> >> The code doesn't necessarily have to work correctly - that would be nice, but it
> >> must compile. #3 fails this test.
> >>
> >> Larry
> >>
> > I do understand this. Every patch among these 11 (actually there are 21
> > patches to get things working with newer Broadcom's socs) I've tested
> > both compiling them and also flashing final images to two boxes -
> > bcm4716 and bcm5354 I own in order to ensure that old things are still
> > working as expected while new things didnt got bricked by changes I
> > made.
> > Just checked 3rd patch again - it applied and compiled cleanly for me,
> > and mine SB-based bcm5354 is still alive after reflash.
> > 
> > ssb_irqflag_sb is declared as extern in ssb_driver_mips.h which is
> > included with ssb.h to main.c
> > Could you please verify if patch applied cleanly ? I'm much surprised
> > here as I can see no reason for <‘ssb_irqflag_sb’ undeclared here> error
> > in main.c other than patch failed to get applied to ssb_driver_mips.h
> 
> It applied cleanly; however, you must consider the possibility that not everyone
> has CONFIG_SSB_DRIVER_MIPS defined. On my x86_64 system, I clearly do not. With
> the following change, it compiled:
> 
> #ifdef CONFIG_SSB_DRIVER_MIPS
>         .irqflag                = ssb_irqflag_sb,
> #endif
> 
> I haven't gone deeply enough into the code to see if that is the correct change,
> or not. If x86 hardware can run AI hardware, then it won't be.
> 
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Ohh lol. Seems im completely burrowed into mips stuff forgetting there
are things apart from mips :)
Will start reviewing code for other arch dependencies right now. Thanks
a lot for pointing it out for me.
There will be completely the same issue with 11th patch as AI code got
the same op struct with unconditional mips irqflag fn.

Are there any other issues with patch applying/compiling left ?

Have nice day,
George



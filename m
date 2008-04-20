Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:1602 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbYDTSUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 14:20:17 -0400
Received: by py-out-1112.google.com with SMTP id u52so2094546pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2008 11:20:17 -0700 (PDT)
From: Filipus Klutiero <chealer@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [Rt2400-devel] rt2x00: cleanup Kconfig help
Date: Sun, 20 Apr 2008 14:20:00 -0400
Cc: rt2400-devel@lists.sourceforge.net
References: <200804121509.56291.chealer@gmail.com> <200804140236.40614.chealer@gmail.com> <200804141333.33128.IvDoorn@gmail.com>
In-Reply-To: <200804141333.33128.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200804201420.00215.chealer@gmail.com> (sfid-20080420_192024_966469_A284501D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le April 14, 2008 07:33:32 am Ivo van Doorn, vous avez =E9crit=A0:
> > > >  	  When compiled as a module, this driver will be called
> > > > "rt2500usb.ko".
> > > >
> > > >  config RT73USB
> > > > -	tristate "Ralink rt73 usb support"
> > > > +	tristate "Ralink RT2571W and RT2671 (USB) support"
> > > >  	depends on RT2X00 && USB
> > > >  	select RT2X00_LIB_USB
> > > >  	select RT2X00_LIB_FIRMWARE
> > > >  	---help---
> > > > -	  This is an experimental driver for the Ralink rt73 wireless=
 chip.
> > > > +	  This is an experimental driver for the RT2571W and RT2671 M=
AC/BBP
> > > > chips. It supports Ralink RT2501USB and RT5201USB wireless chip=
sets.
> > > > When compiled as a module, this driver will be called "rt73usb.=
ko".
> > >
> > > *sigh* you seem to be absolutely sure you want to break any form =
of
> > > consistency in the rt2x00 KConfig entry. So to show how I would l=
ike to
> > > see it I have the following patch. Unless you have objections aga=
inst
> > > below changes I will push this forward.
> >
> > No objection, but note that:
> > * this has both "hardware that feature*s*" and  "hardware that feat=
ure"
>
> I'll fix that.
>
> > * The names of drivers are duplicated and not exactly the same. For
> > example, "This is the experimental rt2500pci driver [...]" vs "[...=
] this
> > driver will be called "rt2500pci.ko"".
>
> I'll change that to:
> This is the experimental rt2500pci driver [...]" vs "[...] the module=
 will
> be called "rt2500pci.ko"".
>
> > Here is the third version of my patch.
>
> NACK
>
> All my complaints about your previous patch still aplies to this new =
one,
> and I am not going to repeat myself over and over again for exactly t=
he
> same.
Certainly not; my last update was specifically to address some of your=20
complaints. Which one(s) did I forget to address?
>
> As for the bug this patch is supposedly going to fix,
> the config option is named:
> 	tristate "Ralink rt2500 usb support"
> How can people confuse that with pci support?
> =DDour patch suggests the confusion is to blame because there is a sp=
ace
> between rt2500 and usb, and that usb isn't capitalized...
It's the text quoted in the bug report which *might* be confusing. Lack=
 of=20
capitalization isn't going to confuse anyone, of course.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

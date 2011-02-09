Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:59068 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab1BIVtK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 16:49:10 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000020124.msg
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 23:48:33 +0200
Subject: Re: SSB AI support code
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 09 Feb 2011 23:41:42 +0200
Message-Id: <1297287702.11978.25.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


В Срд, 09/02/2011 в 22:35 +0100, Rafał Miłecki пишет:
> Switching general discussion to this thread.
> 
> W dniu 9 lutego 2011 22:12 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> > On Wed, 2011-02-09 at 21:58 +0100, Rafał Miłecki wrote:
> >> I don't know, I've doubts about it :/ That flags are quite messy, mask
> >> for them is 0x3FFC0000. Ideally we should shift it by 14 bits, but
> >> that would make writing code harder. Maaaaybe... Michael what do you
> >> think about this?
> >
> > I have no idea.
> > I already expressed my opinion on all this stuff.
> >
> > One thing is for certain: If this is merged, George has to
> > adopt maintainership.
> 
> What about proposed solution? Does it still look ugly for you with
> that pointers to functions? It looks quite fine separated, similarly
> to b43 and PHYs I think. Separated files and structs with pointers.
> 
> George: apart from few simple comparisons on beginning (like detecting
> type of device and determining name in switch), do you need any more
> (many?) tests in general code? Do you have many "if ssb_sb) {} else
> {}"?
> 
In current SB-only linux world ssb code provided services from drivers'
perespective pretty much starts with bus_powerup, device_enable, ....
driver life cycle ... device_disable, bus_powerdown (shortened fn names
for simplification). somewhere between ... and ... inside that driver's
lifecycle it could call _enable again to reset device and so on.
If you take a closer look at device_enable/disable you will see that
those two are pretty much all about reading and writing proper bits to
high 2 bytes of TMSLOW.
TMSLOW (and obviously TMSHIGH as well) are pretty much special. And
first one is so much special that we all use ssb_device_enable instead
of going simple non-obfiscated way of just ssb_read32 and ssb_write32
stuff we need to get that damn chip enabled/disabled/reset :P

Therefore I really dont see the reason why should one use if (ssb_sb)
do_smth_with_sb_ctl_flags(); else do_smth_with_ai_ctl_flags();
constructs instead of just do_smth_with_ctl_flags(); when accessing core
control and state registers which live in high 2 bytes of 0x0F98/0x0F9C
for SB and in low 2 bytes 0x408/0x500 while featuring _absolutely_ the
same bits meaning within that 2 bytes.

Have nice day,
George



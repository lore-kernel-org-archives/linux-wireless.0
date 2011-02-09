Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:59559 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1BIWab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 17:30:31 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000020141.msg
	for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 00:29:53 +0200
Subject: Re: SSB AI support code ([RFC4/11] SSB core control and state
	device ops)
From: George Kashperko <george@znau.edu.ua>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297288959.9734.31.camel@maggie>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <1297262089.18053.24.camel@dev.znau.edu.ua>
	 <AANLkTinC+ijSG=qzzk9OWLGRLsxM0dm12YkERxKbwg6t@mail.gmail.com>
	 <1297285438.11767.28.camel@dev.znau.edu.ua>
	 <AANLkTi=4TTXEQf-ECRBQTBqv-K5u+9yMke88vpwgrmnG@mail.gmail.com>
	 (sfid-20110209_225600_481400_24506838)  <1297288959.9734.31.camel@maggie>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 10 Feb 2011 00:22:59 +0200
Message-Id: <1297290179.11978.61.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


В Срд, 09/02/2011 в 23:02 +0100, Michael Büsch пишет:
> On Wed, 2011-02-09 at 22:55 +0100, Rafał Miłecki wrote: 
> > I aksed about reading, you gave me examples of writing. I want to
> > avoid such a non-readable disasters:
> > u32 tmp;
> > ssb_core_ctl_flags(dev, 0, 0, &tmp);
> 
> A good function name consists of:
> "WHAT is done and WHERE is it done"
> 
> ssb_core_ctl_flags()
> violates both of them. It doesn't specify what is done at all,
> except that it might be something random with ctl flags.
> And it lies about where it does it. It implies that it operates
> on SSB. However, it might operate on SSB or AI.
> 

Well, have nothing to say here.
Tbh things like I see them looks like following.
1. possibility is to "mask" bus differences by dev ops. Obviously you
already have seen these patches. This will cover pretty much everyting
on behalf of end device drivers. Everything _if_ decide on control/state
flags treatment.

2. Make separate bus driver. Not a bad way either I'm sure. But still
device drivers are to manage those control/state flags but this time
with if/elses (or just with sumthing like b43_ctl_flags/b43_state_flags
which will do the same as ssb_core_control_flags atm). Tbh b43_ctl_flags
would be bad name for such a function as donno if it gonna flags >> 16
or not so better do things with plain ssb_read32/ssb_write32 :p
As it would be separate bus there will be few more structs for
ssb_ai_driver_register or whatever, not worse mentinning but still. 

Apart from those flags' location everything else (dma, phy io, etc.)
will be pretty much the same. So the only difference from driver's
perespective here are
1. care control flags
2. care control flags, care bits more bus ops.

>From ssb code prespective for SB bus changes are little to nothing (does
it really matters that alot replacing extern fn1 with static inline
fn1(){ ops->fn_a1 }?) except that there will be 2 more files (ssb_ai.h,
ssb_ai.c 12k length both most of which is EROM scanning code - just take
a look at ssb_ai.c - 180 lines with copyrights and whitespace if you
delete that EROM dancing). Does that 180 lines really worse introducing
whole new bus ? Im not sure honestly but its like I see the things. And
ofcourse I dont insist on this vision.

Have nice day,
George




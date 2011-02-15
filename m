Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:11677 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1BOPN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 10:13:29 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000021567.msg
	for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 17:12:50 +0200
Subject: Re: SSB AI support code ([RFC] v2)
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTi=vp2cCsSJNv1+G2kWxTOL4Y7Tq8TVAMN_cAGQ6@mail.gmail.com>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	 <1297288286.9734.28.camel@maggie>
	 <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
	 <4D5320AA.5020405@lwfinger.net> <1297315457.12795.40.camel@dev.znau.edu.ua>
	 <1297333256.30218.10.camel@maggie>
	 <1297359641.15805.38.camel@dev.znau.edu.ua>
	 <1297361481.30218.31.camel@maggie>
	 <AANLkTi=vp2cCsSJNv1+G2kWxTOL4Y7Tq8TVAMN_cAGQ6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 15 Feb 2011 17:05:15 +0200
Message-Id: <1297782315.29066.16.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> 2011/2/10 Michael Büsch <mb@bu3sch.de>:
> > You're actually abusing the ops structure. The ops structure is meant
> > to abstract the SSB backplane from its host bus. It is _not_ meant
> > to abstract the SSB backplane itself. Your patches mix that up. It's
> > an abstraction layer violation, which my proposal avoids completely.
> 
> After some reading, learning, I think I generally agree with Michael.
> 
> George: I like you consider separated bus driver now. Please let us
> know when you design something!
> 
I've tried-out separate bus driver approach already. Didn't like it at
all tbh. Separate bus driver's .c files made me copy-paste main.c and
scan.c alot any modifications except for &ops pointers. If inlining AI
things with include "bcmai_main.c" "bcmai_scan.c" into main.c/scan.c
makes less copy-pasting and original SSB handlers' exporting but again
changing just &ops in respective handlers makes no sense for me.

Therefore I still think AI-layer buildup over SSB will be good if not
best.

Unfortunately my original code put too much messup into SSB with
overriding ops which was plain wrong as I see now. I've done with fixed
decision which keep bus-abstraction layer intact, overriding just
helpers which behaving different for SSB and AI. Currently its ready to
publish but I want to test it on actual hw before. Already tested on pci
attached SSB on and few embeddables with both SSB and AI. Atm looking
for some pci attached AI to test updated AI code.

Have nice day,
George



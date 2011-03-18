Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:20564 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab1CRP7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 11:59:36 -0400
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000028868.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 17:58:34 +0200
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
In-Reply-To: <AANLkTi=2qBhKfJZ8a2GEgx_4aJL_85FKODUX31BddmN1@mail.gmail.com>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	 <1300453433.13499.18.camel@dev.znau.edu.ua>
	 <AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
	 <1300460342.13499.60.camel@dev.znau.edu.ua>
	 <AANLkTi=2qBhKfJZ8a2GEgx_4aJL_85FKODUX31BddmN1@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 Mar 2011 17:58:45 +0200
Message-Id: <1300463925.13499.118.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 2011/3/18 George Kashperko <george@znau.edu.ua>:
> >> 2011/3/18 George Kashperko <george@znau.edu.ua>:
> >> > Current ssb code ideology isn't really good place to start with support
> >> > for ai backplanes. Its really great to see you willing to get ai
> >> > supported in mainline but I'm sure this should be done apart from the
> >> > ssb code and not even with one as the design decisions origin. Several
> >> > concepts the ssb is based on are not designed to support anything else
> >> > than ocp/sb and will require workarounds to suport ai.
> >> > Thanks to Michael I had a time to think over the possibly code
> >> > abstraction for shared sb and ai support. And while I'm still sure the
> >> > patchwork for ai over ssb support is of good use as some intermediate
> >> > decision to support ai-based hardware in sertain distributions but now I
> >> > support Michael in that such (hopefully) a temporary buildups should not
> >> > be in mainline.
> >>
> >> Please, give some concrete arguments, which part of design does not match AI.
> > SSB design is core-centric, where all the bus activities are made in
> > regard to the cores. This mostly is correct as most of the time
> > bus/drivers code work with cores.
> 
> So finally, is there anything wrong about that?
Nothing wrong as soon as technically imperfect solution is not intended
to be in mainline :) Otherwise my latest AI RFC already ready to merge.

> >> My patch has shown we need to duplicate 40% of SSB's scanning code.
> >> What for example about pci.c? Which functions from that file won't be
> >> duplicated in totally separated?
> >>
> > Going further in extending ssb to support ai will either require the
> > host to be confident of the backplane type and layout (see
> > drivers/staging/brcm80211/utils for the good example of messup it will
> > lead to) or will reguire the backplane-specific code to break into the
> > host code (brcm80211/utils again).
> 
> I don't want to extend ssb, I said that with my patch message. I
> wanted separated drivers sharing some functions, please take a look at
> my comment included in patch. I think we could also create *separated*
> host drivers sharing most of the code.
My english is awful therefore seems we missunderstood each other. I'm
sure I got your point right - you plan to start up the new (bcmb)
project for both sb and ai support.
My point here is - this is great but making design decisions on ssb code
model is wrong.

Have nice day,
George



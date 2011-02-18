Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:62010 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab1BRHs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 02:48:27 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022334.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 09:47:46 +0200
Subject: Re: [RFC] AI support
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
In-Reply-To: <4D5DDCBC.2050501@broadcom.com>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 <4D5DDCBC.2050501@broadcom.com>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 09:39:53 +0200
Message-Id: <1298014793.28946.39.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> This just reinforces what Michael said about name confusion.
> 
> Michael's proposal of separating SSB and AXI, and decoupling the device 
> drivers from the bus routines, is going to be much more maintainable in 
> the long run.  AXI is going to be far more widespread than SSB ever was, 
> and it would be really unfortunate if we carry the SSB baggage forward.
> 
> I've been poking around at disentangling the sb and ai routines in 
> drivers/staging/brcm80211/utils/{aiutils,sbutils,siutils}.c.  I don't 
> have anything to put out for comments yet, but it's enough to convince 
> me that it's the right direction.
> 
> - Henry
> 
Yes, in long run the best might be is to move core management layer out
of SSB, lighten it leaving just bus-management code, then intdroduce AI
bus and might UBUS as well at some point (btw any tips from Broadcom
when we could see it implemented in HW ?). To make life bits easier
there could be some basic bus-level lib as plenty of shared things
between there 2 (or 3?) buses. E. g. let these buses share some common
(de)initialization, identification, parts of core switching code. Let
core-management code exist under any of these buses independently of the
parent bus implementation...

With such approach device (de)initialization, sub-core addressing,
state/control management could be done in dedicated bus-specific
routines or with some common-interface routines abstracting
bus-implementation specific registers management with means of dedicated
ops/helers (whatever it called). First approach in long run will make
drivers to abstract this bus-specific management under some dedicated
routines with if/else's or fn tables. Second approach is generally the
same as already there in AI patches (and again the same as it will be in
dedicated cores drivers' code with first way but replicated for those
cores drivers' who exist on both SSB and AI like it is now for mips,
pcie, w11, etc.).

Yes, AI, lets say, over SBB, makes some confusion and this confusion
could be avoided with separate SSB/AI bus drivers but in current SSB
design state its 99% of copy-pasting SSB code with changing nothing
other than &ops pointers and ssb_ prefixes with something like bcmai_ or
similar which honestly makes no sense to me considering than the goal is
to <avoid confusion>. Pretty much sure there will be even more confusion
than before.

It could take some time to get separate-bus confuse-less design clean
and working, whereas AI-hw not being supported more than year since
introduction will keep unsupported another +- half a year. Well this
isn't actually a problem as well as I dont see a problem with doing that
with making AI support introduced with SSB layer in way I proposed.

Making AI supported with SSB code base doesn't close the way in evolving
SSB and AI code in either direction, isn't it ? Also there is
opportunity offered by Broadcom (see post by Roland Vossen earlier in
the thread) - we could have Broadcom-supplied AI lib module not to touch
SSB code at all but this might will require plenty of bus-abstraction in
b43 and will do hard time for newer AI-based embedabbles, but those aint
supported with newer kernels anyway.

I could get working on separated SSB/AI code in approx mid. march
(unfortunately too short on time till that cause of current work
schedule) if there will be no volunteers or we could work on that
together.

Have nice day,
George



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:49559 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab1BJRs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 12:48:26 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000020428.msg
	for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 19:47:45 +0200
Subject: Re: SSB AI support code ([RFC] v2)
From: George Kashperko <george@znau.edu.ua>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297333256.30218.10.camel@maggie>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	 <1297288286.9734.28.camel@maggie>
	 <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
	 <4D5320AA.5020405@lwfinger.net> <1297315457.12795.40.camel@dev.znau.edu.ua>
	 (sfid-20110210_063153_817778_FFFFFFFFF46A15B5)  <1297333256.30218.10.camel@maggie>
Content-Type: text/plain
Date: Thu, 10 Feb 2011 19:40:41 +0200
Message-Id: <1297359641.15805.38.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Evening.

> On Thu, 2011-02-10 at 07:24 +0200, George Kashperko wrote: 
> > Here is updated patchset for AI support code.
> 
> So this patchset does only contain code for the embedded-AI case.
> There's no support for PCI devices so far. Are you going to
> add this, too? Or does it work with the existing PCI hostcode?
> Otherwise the argument that "brcm80211 can be ported
> to it, too" is foobar.
Well, I was saying about NPhy code from brcm80211 (did I really said
about brcm80211 awhole ? o.o Btw its good idea to try out - will get to
it later when get more free time besides work and actual hw to test it
on)
SSB embedded - yes until I could proove otherwise (pretty much sure it
will require some work on) with getting my hands over some AI-base hw.
Im lacking non-embedded AI hardware to test it on currently. Planning to
make a BOM with few SSB AI pci/pcmcia wireless cards to play around with
but this is for mid-spring when I get more free time for experiments.

> You AI ops seem to be wrong, too:
> 
> +/* Ops for the plain SSB bus without a host-device (no PCI or PCMCIA).
> */
> +static struct ssb_bus_ops ssb_ops_ai = {
> + .read8 = ssb_ssb_read8,
> + .read16 = ssb_ssb_read16,
> + .read32 = ssb_ssb_read32,
> + .write8 = ssb_ssb_write8,
> + .write16 = ssb_ssb_write16,
> + .write32 = ssb_ssb_write32,
> +#ifdef CONFIG_SSB_BLOCKIO
> + .block_read = ssb_ssb_block_read,
> + .block_write = ssb_ssb_block_write,
> +#endif
Nothing wrong here. SSB AI bus does provides individual cores registers'
space access with regular mmio starting at SSB_ENUM_BASE with 0x1000 for
each core pretty much like SSB SB bus does. ssb_ai_(read|write)
accessors read bus-specific core registers from the SSB_AI_BASE again
with 0x1000 per core. Its looks like on SSB AI every core is wrapped by
AI hw therefore wrapper-to-bus regs (bus specific stuff like
control/state) are managed by wrapper io, while core specific registers
(like phy/dma/etc) accessed pretty much the same like for SSB SB.

> You're still calling the SSB-embedded routines. The comment also seems
> wrong. This is not a "plain SSB bus". It's an "AI" bus.
Here would be much appreciated for short comment on your understanding
of "plain SSB" term. Sure this would let us better understand each other
on the topic. Under "plain SSB" I mean SSB AI/SB bus interconnected with
system without intermediate PCI/SDIO/PCMCIA/etc bus - therefore no core
switching required and whole mmio addrspace for all the cores can be
accessed simultaneously. At least it looks as such for me from GPL'ed
sourcecodes from Broadcom. Unfortunately have no other better source of
knowledge of how is it working rather than these sources - that one
bcm5365p.pdf you posted yesterday (btw thanks alot for it - failed
trying to find it in web and finally gave up) is new for me, just
started looking through when catch free time.

> My proposal stays the same: If you want this merged, you'll have to
> maintain it (the whole thing) in the long term.
If this is the only option then sure but with one precaution - mine
background requires me to get working trips sometimes. I cant be online
during hat time due to sertain limitations I cant cover. It newer longs
more than 2-3 days and happens not really often. If this wont make
inconveniences for you then I will do my best to keep the thing working
and developed.

Have nice day,
George



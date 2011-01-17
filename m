Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38099 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1AQLVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 06:21:16 -0500
From: Florian Fainelli <florian@openwrt.org>
To: Michael =?utf-8?q?B=C3=BCsch?= <mb@bu3sch.de>
Subject: Re: Merging SSB and HND/AI support
Date: Mon, 17 Jan 2011 12:20:52 +0100
Cc: Jonas Gorski <jonas.gorski@gmail.com>, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <AANLkTi=GDcy50zsC6=Dgv1-Ty3cYK2qpx9o=q3JdXuCh@mail.gmail.com> <1295261783.24530.3.camel@maggie>
In-Reply-To: <1295261783.24530.3.camel@maggie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101171220.52292.florian@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 17 January 2011 11:56:23 Michael Büsch wrote:
> On Mon, 2011-01-17 at 11:46 +0100, Jonas Gorski wrote:
> > Hello,
> > 
> > I am currently looking into adding support for the newer Broadcom
> > BCM47xx/53xx SoCs. They require having HND/AI support, which probably
> > means merging the current SSB code and the HND/AI code from the
> > brcm80211 driver. Is anyone already working on this?
> > 
> > As far as I can see, there are two possibilities:
> > 
> > a) Merge the HND/AI code into the current SSB code, or
> > 
> > b) add the missing code for SoCs to brcm80211 and replace the SSB code
> > with it.
> 
> Why can't we keep those two platforms separated?

That is also what I am wondering about. Considering that previous BCM47xx 
platforms use a MIPS4k core and newer one use MIPS74k or later, you would not 
be able to build a single kernel for both which takes advantages of compile-
time optimizations targetting MIPS74k. If this ist not a big concern, then 
let's target a single kernel.

> Is there really a lot of shared code between SSB and HND/AI?
> 
> It's true that there's currently a lot of device functionality built
> into ssb. Like pci bridge, mips core, extif, etc...
> If you take all that code out, you're probably not left with anything.
> 
> So why do we need to replace or merge SSB in the first place? Can't
> it co-exist with HND/AI?

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:51407 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab1AQMK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 07:10:29 -0500
Subject: Re: Merging SSB and HND/AI support
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Florian Fainelli <florian@openwrt.org>
Cc: Jonas Gorski <jonas.gorski@gmail.com>, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <201101171220.52292.florian@openwrt.org> (sfid-20110117_122124_233292_51C2DD96)
References: <AANLkTi=GDcy50zsC6=Dgv1-Ty3cYK2qpx9o=q3JdXuCh@mail.gmail.com>
	 <1295261783.24530.3.camel@maggie>  <201101171220.52292.florian@openwrt.org>
	 (sfid-20110117_122124_233292_51C2DD96)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 13:00:09 +0100
Message-ID: <1295265609.24530.25.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-17 at 12:20 +0100, Florian Fainelli wrote: 
> On Monday 17 January 2011 11:56:23 Michael Büsch wrote:
> > On Mon, 2011-01-17 at 11:46 +0100, Jonas Gorski wrote:
> > > Hello,
> > > 
> > > I am currently looking into adding support for the newer Broadcom
> > > BCM47xx/53xx SoCs. They require having HND/AI support, which probably
> > > means merging the current SSB code and the HND/AI code from the
> > > brcm80211 driver. Is anyone already working on this?
> > > 
> > > As far as I can see, there are two possibilities:
> > > 
> > > a) Merge the HND/AI code into the current SSB code, or
> > > 
> > > b) add the missing code for SoCs to brcm80211 and replace the SSB code
> > > with it.
> > 
> > Why can't we keep those two platforms separated?
> 
> That is also what I am wondering about. Considering that previous BCM47xx 
> platforms use a MIPS4k core and newer one use MIPS74k or later, you would not 
> be able to build a single kernel for both which takes advantages of compile-
> time optimizations targetting MIPS74k. If this ist not a big concern, then 
> let's target a single kernel.

Ok, but it should be easily possible to compile both SSB and HND/AI
bus support into one kernel anyway. Nothing prevents drivers from having
an SSB and an HND/AI probe callback.

-- 
Greetings Michael.


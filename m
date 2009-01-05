Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:41752 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZAEPKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 10:10:20 -0500
Date: Mon, 5 Jan 2009 16:24:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Andi Kleen <andi@firstfloor.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
Message-ID: <20090105152410.GT496@one.firstfloor.org> (sfid-20090105_161025_023486_49A3DD07)
References: <20090104174123.GW496@one.firstfloor.org> <49615465.4090604@lwfinger.net> <20090105025302.GF496@one.firstfloor.org> <49618497.50809@lwfinger.net> <20090105050248.GG496@one.firstfloor.org> <496193A6.3040608@lwfinger.net> <20090105054830.GJ496@one.firstfloor.org> <49620BE5.9030507@openwrt.org> <20090105142343.GS496@one.firstfloor.org> <49621C36.70602@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49621C36.70602@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 05, 2009 at 03:41:58PM +0100, Felix Fietkau wrote:
> Andi Kleen wrote:
> > With Larry's patch reverted. Rate is still at 1Mbit/s of course.
> > This is all only with rtl8180, I didn't try everything on the realtek
> > card too. 
> > 
> > -Andi
> > 
> > rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
> > TtP  1         0.9       99.2      100.0          1(  1)         23          32
> >      2         0.0        0.0        0.0          0(  0)          0           0
> >      5.5       0.0        0.0        0.0          0(  0)          0           1
> >     11         0.0        0.0        0.0          0(  0)          0           0
> >      6         0.0        0.0        0.0          0(  0)          0           0
> >      9         0.0        0.0        0.0          0(  0)          0           0
> >     12         0.0        0.0        0.0          0(  0)          0           0
> >     18         0.0        0.0        0.0          0(  0)          0           0
> >     24         0.0        0.0        0.0          0(  0)          0           0
> >     36         0.0        0.0        0.0          0(  0)          0           0
> >     48         0.0        0.0        0.0          0(  0)          0           0
> >     54         0.0        0.0        0.0          0(  0)          0           0
> > 
> > Total packet count::    ideal 25      lookaround 1
> OK, that confirms that Larry's patch was wrong - at least the dump
> looks consistent now.
> Probably the RT2561 and the RTL8180 simply have a lower Tx power and

> thus can't get the signal through the walls as easily as the zd1211rw.

That surprises me because I use a real antenna on them which the zd1211rw
is just itself. Also some laptops with Intel wireless have no trouble
talking through the walls at full rate when I put them on the same position.

Hmm perhaps I should try to find a Windows box and see if it works
there. That would rule out hardware issues.

> If you still think that it's a rate control problem, please try all

I don't know what it is, i just know that it doesn't work and
from the evidence I gathered so far it looks like a Linux software
problem.

> the rates individually and see if one of them works better.

Forcing the rates works somewhat, but the link quality is very poor
(10-15/100) and fluctuates.

-Andi

-- 
ak@linux.intel.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43511 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbYIHMy3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 08:54:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH V2] b43legacy: Fix failure in rate-adjustment mechanism
Date: Mon, 8 Sep 2008 14:53:55 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <48c2fb5a.JqLELi8PJxjxmDaY%Larry.Finger@lwfinger.net> <200809070040.04300.mb@bu3sch.de> <20080908053155.GI4099@kroah.com>
In-Reply-To: <20080908053155.GI4099@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809081453.56241.mb@bu3sch.de> (sfid-20080908_145443_511424_2EADBC28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 September 2008 07:31:55 Greg KH wrote:
> On Sun, Sep 07, 2008 at 12:40:04AM +0200, Michael Buesch wrote:
> > On Saturday 06 September 2008 23:51:22 Larry Finger wrote:
> > > A coding error present since b43legacy was incorporated into the
> > > kernel has prevented the driver from using the rate-setting mechanism
> > > of mac80211. The driver has been forced to remain at a 1 Mb/s rate.
> > > 
> > > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> > > Cc: Stable <stable@kernel.org>		[2.6.26], [2.6.25]
> > 
> > Reviewed-by: Michael Buesch <mb@bu3sch.de>
> > 
> > > ---
> > > 
> > > John,
> > > 
> > > This is a bug, not a regression. I guess under the new rules that it
> > > is 2.6.28 material.
> > 
> > I wonder what the -stable rules are.
> 
> Bug fixes, not new features, it's pretty simple :)

Yeah, well. My concern was:
- We put it into .25-stable and .26-stable, because it's a bugfix.
  That's perfectly fine.
- We do _not_ put it into .27 mainline, because it is just a simple
  bug, but not a regression. Instead we wait for .27-stable.

Doesn't make a lot sense to me. :)

So I'd like to see it in .27, too, despite the strict regressions-only
rule. A general regressions-only rule simply doesn't always make sense, IMO.

-- 
Greetings Michael.

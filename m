Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40524
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbXIOTuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2007 15:50:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] b43legacy: Fix machine check errors for PPC architecture with BCM4306/2
Date: Sat, 15 Sep 2007 21:47:57 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46ec18d6.puwbD1oRuPgUil6/%Larry.Finger@lwfinger.net> <200709152010.07647.mb@bu3sch.de> <46EC2E84.4080901@lwfinger.net>
In-Reply-To: <46EC2E84.4080901@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200709152147.57431.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 15 September 2007 21:12:04 Larry Finger wrote:
> Michael Buesch wrote:
> > On Saturday 15 September 2007 20:07:22 Larry Finger wrote:
> >> Your comments may be correct; however, the fact remains that with a rev 4 BCM4306, the original code
> >> generates many, many machine checks on PPC architecture, and I get reads with all ones on i386
> >> indicating that the read is invalid. These all occur before the firmware is loaded. Making the
> >> "gmode" bit mimic the behavior of the phy_connected variable of bcm43xx gets rid of the problems on
> >> both platforms.
> > 
> > Sure. But if you workaround this like that, you could
> > as well get completely rid of the gmode bit, as you always force it on.
> > But I think that's not what we want. The real fix is simple. See below.
> > 
> > 
> >> If you can suggest a reordering of the initialization that delays PHY setup until the "magic step"
> >> that eliminates this problem is done on/to the ssb backplane, I will be happy to test it. I was
> >> unable to find such a solution.
> > 
> > There is no reordering needed.
> > You just need to find out why phy->gmode was not set.
> > I think it's set based on the have_gphy and have_bphy bits.
> > So you need to look there why one of these is not set. That is the real
> > cause of the issue.
> 
> In the original code, have_gphy was true, and phy->gmode was set. These variables were not the cause.
> 
> In bcm43xx, the second argument to wireless_core_reset controls the value of phy->connected at exit.
> This behavior is missing in the original b43legacy (and in b43). For b43, it seems to have no
> consequence, but for the early PHYs, phy->connected controls when certain registers can be
> read/written and affects the program flow through the phy and radio initialization. The lack of the
> ability to toggle gmode is what leads to the register errors, and this is what my change restores.
> The name could be changed, but that seems more intrusive than necessary.

No, your patch doesn't restore anything. It rips out the gmode logic.
I just want to make sure you understand what you are actually doing there.
the old phy->connected semantics were completely broken. Forget about them.
The problem here is, that at some point phy->gmode is not set, where
it should be set (or the other way around).
So it's not about renaming or something.

With your patch you remove the "gmode" semantics, so you could
as well remove the whole variable and always assume it's set.
But I don't recommend to go that way. I'd suggest you find the
place in the code where phy->gmode is not set but it should be.
_that_ is the place where the real bug is.

Just want to make sure you understand the consequences of your patch.
You remove a feature with that.
If that feature is really needed in legacy; that is another question.
It's needed if you want to drive APHY devices.

-- 
Greetings Michael.

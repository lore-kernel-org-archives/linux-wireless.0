Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:44526 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbXIOTL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2007 15:11:28 -0400
Message-ID: <46EC2E84.4080901@lwfinger.net>
Date: Sat, 15 Sep 2007 14:12:04 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix machine check errors for PPC architecture  with BCM4306/2
References: <46ec18d6.puwbD1oRuPgUil6/%Larry.Finger@lwfinger.net> <200709151948.46667.mb@bu3sch.de> <46EC1F5A.7030800@lwfinger.net> <200709152010.07647.mb@bu3sch.de>
In-Reply-To: <200709152010.07647.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Saturday 15 September 2007 20:07:22 Larry Finger wrote:
>> Your comments may be correct; however, the fact remains that with a rev 4 BCM4306, the original code
>> generates many, many machine checks on PPC architecture, and I get reads with all ones on i386
>> indicating that the read is invalid. These all occur before the firmware is loaded. Making the
>> "gmode" bit mimic the behavior of the phy_connected variable of bcm43xx gets rid of the problems on
>> both platforms.
> 
> Sure. But if you workaround this like that, you could
> as well get completely rid of the gmode bit, as you always force it on.
> But I think that's not what we want. The real fix is simple. See below.
> 
> 
>> If you can suggest a reordering of the initialization that delays PHY setup until the "magic step"
>> that eliminates this problem is done on/to the ssb backplane, I will be happy to test it. I was
>> unable to find such a solution.
> 
> There is no reordering needed.
> You just need to find out why phy->gmode was not set.
> I think it's set based on the have_gphy and have_bphy bits.
> So you need to look there why one of these is not set. That is the real
> cause of the issue.

In the original code, have_gphy was true, and phy->gmode was set. These variables were not the cause.

In bcm43xx, the second argument to wireless_core_reset controls the value of phy->connected at exit.
This behavior is missing in the original b43legacy (and in b43). For b43, it seems to have no
consequence, but for the early PHYs, phy->connected controls when certain registers can be
read/written and affects the program flow through the phy and radio initialization. The lack of the
ability to toggle gmode is what leads to the register errors, and this is what my change restores.
The name could be changed, but that seems more intrusive than necessary.

Larry



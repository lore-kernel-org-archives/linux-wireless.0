Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33597
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbXIOSMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2007 14:12:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43legacy: Fix machine check errors for PPC architecture with BCM4306/2
Date: Sat, 15 Sep 2007 20:10:07 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <46ec18d6.puwbD1oRuPgUil6/%Larry.Finger@lwfinger.net> <200709151948.46667.mb@bu3sch.de> <46EC1F5A.7030800@lwfinger.net>
In-Reply-To: <46EC1F5A.7030800@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709152010.07647.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 15 September 2007 20:07:22 Larry Finger wrote:
> Your comments may be correct; however, the fact remains that with a rev 4 BCM4306, the original code
> generates many, many machine checks on PPC architecture, and I get reads with all ones on i386
> indicating that the read is invalid. These all occur before the firmware is loaded. Making the
> "gmode" bit mimic the behavior of the phy_connected variable of bcm43xx gets rid of the problems on
> both platforms.

Sure. But if you workaround this like that, you could
as well get completely rid of the gmode bit, as you always force it on.
But I think that's not what we want. The real fix is simple. See below.

> The registers that error are not just the extended GPHY registers that caused 
> problems in the past, but all the PHY registers.

Nobody is talking about the extG registers.

> If you can suggest a reordering of the initialization that delays PHY setup until the "magic step"
> that eliminates this problem is done on/to the ssb backplane, I will be happy to test it. I was
> unable to find such a solution.

There is no reordering needed.
You just need to find out why phy->gmode was not set.
I think it's set based on the have_gphy and have_bphy bits.
So you need to look there why one of these is not set. That is the real
cause of the issue.

-- 
Greetings Michael.

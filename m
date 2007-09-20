Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45646
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbXITNCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 09:02:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] b43: Change loglevel of radio-enable message.
Date: Thu, 20 Sep 2007 15:01:22 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200709191858.38634.mb@bu3sch.de> <200709191957.59255.mb@bu3sch.de> <46F26DAA.6070909@lwfinger.net>
In-Reply-To: <46F26DAA.6070909@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709201501.22977.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 September 2007, Larry Finger wrote:
> Michael Buesch wrote:
> > On Wednesday 19 September 2007 19:55:59 Larry Finger wrote:
> >> Michael Buesch wrote:
> >>> Also cleanup the code a bit and remove the inline.
> >>>
> >>> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> >>> @@ -2214,7 +2229,7 @@ static int b43_chip_init(struct b43_wlde
> >>>  	b43_radio_turn_on(dev);
> >>>  	dev->radio_hw_enable = b43_is_hw_radio_enabled(dev);
> >>>  	b43dbg(dev->wl, "Radio %s by hardware\n",           <========================
> >>> -	       (dev->radio_hw_enable == 0) ? "disabled" : "enabled");
> >>> +	       dev->radio_hw_enable ? "enabled" : "disabled");
> >> Shouldn't this one be b43info rather than b43dbg?
> > 
> > No, I think it's really only interesting to see if it changed
> > in operation.
> > If it doesn't work, people will press their rfkill buttons
> > before even noticing this message on init. :)
> 
> I have a suggestion to simplify the whole business of hardware radio control. Why don't we
> unconditionally set radio_hw_enable to one here and dispense with this message? That way, people
> without the rfkill switch will never see a message and those that do will only get messages if their
> switch is off, or if it is toggled.

Great idea, Larry!
I will implement that in an additional patch later.

Thanks.

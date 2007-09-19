Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43860
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763930AbXISSAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 14:00:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] b43: Change loglevel of radio-enable message.
Date: Wed, 19 Sep 2007 19:57:59 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200709191858.38634.mb@bu3sch.de> <46F162AF.9050903@lwfinger.net>
In-Reply-To: <46F162AF.9050903@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200709191957.59255.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 19 September 2007 19:55:59 Larry Finger wrote:
> Michael Buesch wrote:
> > Also cleanup the code a bit and remove the inline.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> > @@ -2214,7 +2229,7 @@ static int b43_chip_init(struct b43_wlde
> >  	b43_radio_turn_on(dev);
> >  	dev->radio_hw_enable = b43_is_hw_radio_enabled(dev);
> >  	b43dbg(dev->wl, "Radio %s by hardware\n",           <========================
> > -	       (dev->radio_hw_enable == 0) ? "disabled" : "enabled");
> > +	       dev->radio_hw_enable ? "enabled" : "disabled");
> 
> Shouldn't this one be b43info rather than b43dbg?

No, I think it's really only interesting to see if it changed
in operation.
If it doesn't work, people will press their rfkill buttons
before even noticing this message on init. :)

-- 
Greetings Michael.

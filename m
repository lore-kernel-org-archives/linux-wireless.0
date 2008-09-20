Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52864 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbYITNKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 09:10:16 -0400
Date: Sat, 20 Sep 2008 10:10:10 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080920131010.GB16430@khazad-dum.debian.net> (sfid-20080920_151023_193763_8B189750)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809182241.00906.IvDoorn@gmail.com> <20080918213657.GY1583@khazad-dum.debian.net> <200809191902.03467.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809191902.03467.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 19 Sep 2008, Ivo van Doorn wrote:
> > Even if that means a need to 
> > get EV_SW SW_WLAN out of Dmitry...  I don't know if rt2x000 wants SW_WLAN or
> > SW_RFKILL_ALL.
> 
> Not sure either, there is no way to determine which of the 2 should be used.

Should be an module parameter or runtime (sysfs?) parameter, then...

> Oh an to make sure I get it completely right this time:
> When I implement the input polldev, I no longer have to use rfkill_force_state() right?

Correct.  It has nothing to do with the rfkill class part of your driver at
all, since there is no effect on the hardware.  It is just an input device
that issues EV_SW events.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

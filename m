Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:36275 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYITNUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 09:20:35 -0400
Received: by ug-out-1314.google.com with SMTP id k3so1146238ugf.37
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2008 06:20:33 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Sat, 20 Sep 2008 15:20:27 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809191902.03467.IvDoorn@gmail.com> <20080920131010.GB16430@khazad-dum.debian.net>
In-Reply-To: <20080920131010.GB16430@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809201520.28717.IvDoorn@gmail.com> (sfid-20080920_152051_725120_63A4D01E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 20 September 2008, Henrique de Moraes Holschuh wrote:
> On Fri, 19 Sep 2008, Ivo van Doorn wrote:
> > > Even if that means a need to 
> > > get EV_SW SW_WLAN out of Dmitry...  I don't know if rt2x000 wants SW_WLAN or
> > > SW_RFKILL_ALL.
> > 
> > Not sure either, there is no way to determine which of the 2 should be used.
> 
> Should be an module parameter or runtime (sysfs?) parameter, then...

Module parameter sounds best, I doubt people would want to change the value
at runtime (when it is just easier to do it at loadtime).

> > Oh an to make sure I get it completely right this time:
> > When I implement the input polldev, I no longer have to use rfkill_force_state() right?
> 
> Correct.  It has nothing to do with the rfkill class part of your driver at
> all, since there is no effect on the hardware.  It is just an input device
> that issues EV_SW events.

Ok, thanks. :)

I'll remove rfkill from rt2x00, implement input_polldev as seperate module,
move rfkill support into mac80211 to make mac80211 drivers automatically
detect the rfkill notifications.

Ivo

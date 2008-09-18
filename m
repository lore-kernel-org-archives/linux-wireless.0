Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51164 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107AbYIROKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 10:10:15 -0400
Date: Thu, 18 Sep 2008 11:10:06 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918141006.GE1583@khazad-dum.debian.net> (sfid-20080918_161018_998563_75EC087F)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181519.12366.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809181519.12366.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> If it is something coming from mac80211, then you do not want
> to send a SOFT_BLOCKED event since that will cause all other radios
> to be switched off simply because the b43 interface has not been
> enabled.

Drivers ARE supposed to be able to set their radio state to their heart's
content, without messing with any other devices.  There are no constraints
to calls to rfkill_force_state(), other than the current issue that it must
not be done from an atomic context.

OTOH, rfkill_force_state() does NOT change anything in the radio, so you
must always call it to match the REAL state of the hardware.

What CAN mess with other radios are INPUT EVENTS.  Which b43 has no business
generating by itself by default, since it is used both on platforms where it
is just a wireless device, and also on platforms where its hardware rfkill
input line is THE only way to know the state of THE hardware slider RFKILL
switch.

And, frankly, it shouldn't be the job of b43 to care to know what platform
is it in.

Now, with Larry's patch, b43 has no input device mess dragging it down
anymore.  So, any platforms that need input events from b43 are to generate
them in userspace, or through a separate kernel module.   We already have
all the APIs needed for that, and they work.

This *DOES* mean the fixed b43 will be noticed by userspace, since it won't
issue KEY_WLAN anymore.   However, that has been broken in rfkill (the
input-polldev stuff) and b43 (use of EV_KEY instead of EV_SW) since day one
anyway, so I personally can't see that as anything but a required bug fix
that userspace would have to adapt to.

If this is much too confusing, I am all ears on how we could improve it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

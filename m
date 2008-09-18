Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48411 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbYIRRiD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:38:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 19:37:38 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <48D25BFE.6020708@lwfinger.net> <200809181553.29140.IvDoorn@gmail.com>
In-Reply-To: <200809181553.29140.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181937.38257.mb@bu3sch.de> (sfid-20080918_193808_138271_8F580029)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008 15:53:28 Ivo van Doorn wrote:
> On Thursday 18 September 2008, Larry Finger wrote:
> > Ivo van Doorn wrote:
> > 
> > > Is dev->phy.radio_on set when mac80211 has send an instruction
> > > to the driver to enable the radio (start() or config() callback)
> > > or does it represent the key state in the hardware?
> > > 
> > > If it is something coming from mac80211, then you do not want
> > > to send a SOFT_BLOCKED event since that will cause all other radios
> > > to be switched off simply because the b43 interface has not been
> > > enabled.
> > > 
> > > Off course when it represents the key state in the hardware then the
> > > code would be fine...
> > 
> > The state comes from mac80211 and is set in the config() callback.
> > 
> > What state should be sent at the point when the hardware block is
> > removed? It seems to me that forcing an UNBLOCKED state gives the
> > wrong result. Perhaps RFKILL does need to have 4 states so that an
> > RFKILL_STATE_HW_UNBLOCKED state can be transmitted.
> 
> When the key is pressed to unblock the device, then simply send state
> RFKILL_STATE_UNBLOCKED to rfkill. That will generate a trigger to the
> driver to enable the radio,

The radio is enabled in _hardware_. There doesn't need to be any trigger.
It's already on. In fact, such a trigger (done through rfkill->toggle callback)
would deadlock wl->mutex with the current patch.

> and at that time you can check if mac80211 
> wants the radio on or not (aka you check dev->phy.radio_on or the mac80211
> config structure).

No!
Software and hardware rfkill states are completely different and _independent_
states on the b43 hardware. You set the software state from the mac80211 callback
no matter what hardware state the device is in. You just have to announce the
state correctly to the rfkill subsystem if mac80211 changed the software
state.

Do not change any software state from within the hardware state change handler.
This will blow up.

-- 
Greetings Michael.

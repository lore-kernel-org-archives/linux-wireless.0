Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:2286 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460AbYIRSGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:06:20 -0400
Received: by ug-out-1314.google.com with SMTP id k3so797093ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 11:06:18 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 20:06:14 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181942.29122.IvDoorn@gmail.com> <200809181953.22746.mb@bu3sch.de>
In-Reply-To: <200809181953.22746.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-Id: <200809182006.14494.IvDoorn@gmail.com> (sfid-20080918_200641_186782_368056BD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Michael Buesch wrote:
> On Thursday 18 September 2008 19:42:28 Ivo van Doorn wrote:
> > On Thursday 18 September 2008, Michael Buesch wrote:
> > > On Thursday 18 September 2008 15:47:42 Larry Finger wrote:
> > > > Ivo van Doorn wrote:
> > > > 
> > > > > Is dev->phy.radio_on set when mac80211 has send an instruction
> > > > > to the driver to enable the radio (start() or config() callback)
> > > > > or does it represent the key state in the hardware?
> > > > > 
> > > > > If it is something coming from mac80211, then you do not want
> > > > > to send a SOFT_BLOCKED event since that will cause all other radios
> > > > > to be switched off simply because the b43 interface has not been
> > > > > enabled.
> > > > > 
> > > > > Off course when it represents the key state in the hardware then the
> > > > > code would be fine...
> > > > 
> > > > The state comes from mac80211 and is set in the config() callback.
> > > > 
> > > > What state should be sent at the point when the hardware block is
> > > > removed? It seems to me that forcing an UNBLOCKED state gives the
> > > > wrong result. Perhaps RFKILL does need to have 4 states so that an
> > > > RFKILL_STATE_HW_UNBLOCKED state can be transmitted.
> > > 
> > > If sw is unblocked, but hw is still blocked, you must not announce
> > > unblocked state to rfkill.
> > 
> > Well from my perspective:
> > Note that 'sw' is the RADIO state as requested by mac80211 and
> > 'hw' is the RFKILL state as indicated by the hardware
> > 
> > radio: block, rfkill: block => BLOCK
> > radio: block, rfkill: unblock => UNBLOCK
> 
> If the radio is physically blocked by the hardware rfkill switch,
> why on earth would we want to announce unblocked state?
> Or did I get your table wrong?

You get the table wrong.
When the user presses the RFKILL key, the RFKILL state is set to unblock.
When the user does 'ifconfig wlan0 up' or 'iwconfig wlan0 txpower on'
then the RADIO state is set to unblock.

>From your mail I understood that your interpretation of the SW RFKILL
was "radio state as requested by mac80211" and HW RFKILL was
"radio state as requested by RFKILL register in b43".

> (Still note that software and hardware states are _independent_ in b43.
> Think of it as two independent bits that can each turn the radio off, where
> the hardware state bit is readonly and is triggered by the hw-button).

I am, and this is what I am trying to preserve in rfkill. That it _does_
differentiate between the 2 states.

Ivo

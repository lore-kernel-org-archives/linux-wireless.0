Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:9156 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbYIRRme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:42:34 -0400
Received: by ey-out-2122.google.com with SMTP id 6so4397eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 10:42:32 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 19:42:28 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <48D25BFE.6020708@lwfinger.net> <200809181934.03026.mb@bu3sch.de>
In-Reply-To: <200809181934.03026.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181942.29122.IvDoorn@gmail.com> (sfid-20080918_194236_689430_7EB36354)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Michael Buesch wrote:
> On Thursday 18 September 2008 15:47:42 Larry Finger wrote:
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
> If sw is unblocked, but hw is still blocked, you must not announce
> unblocked state to rfkill.

Well from my perspective:
Note that 'sw' is the RADIO state as requested by mac80211 and
'hw' is the RFKILL state as indicated by the hardware

radio: block, rfkill: block => BLOCK
radio: block, rfkill: unblock => UNBLOCK
radio: unblock, rfkill: block => BLOCK
radio: unblock, rfkill: unblock => UNBLOCK

Ivo

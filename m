Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47248 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbYIRRe2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:34:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 19:34:02 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181519.12366.IvDoorn@gmail.com> <48D25BFE.6020708@lwfinger.net>
In-Reply-To: <48D25BFE.6020708@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181934.03026.mb@bu3sch.de> (sfid-20080918_193440_877952_05E5DF69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008 15:47:42 Larry Finger wrote:
> Ivo van Doorn wrote:
> 
> > Is dev->phy.radio_on set when mac80211 has send an instruction
> > to the driver to enable the radio (start() or config() callback)
> > or does it represent the key state in the hardware?
> > 
> > If it is something coming from mac80211, then you do not want
> > to send a SOFT_BLOCKED event since that will cause all other radios
> > to be switched off simply because the b43 interface has not been
> > enabled.
> > 
> > Off course when it represents the key state in the hardware then the
> > code would be fine...
> 
> The state comes from mac80211 and is set in the config() callback.
> 
> What state should be sent at the point when the hardware block is
> removed? It seems to me that forcing an UNBLOCKED state gives the
> wrong result. Perhaps RFKILL does need to have 4 states so that an
> RFKILL_STATE_HW_UNBLOCKED state can be transmitted.

If sw is unblocked, but hw is still blocked, you must not announce
unblocked state to rfkill.


-- 
Greetings Michael.

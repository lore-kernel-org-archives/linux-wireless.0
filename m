Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:16419 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022AbYIRSHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:07:03 -0400
Received: by ey-out-2122.google.com with SMTP id 6so8760eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 11:07:01 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 20:06:58 +0200
Cc: Michael Buesch <mb@bu3sch.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181952.15770.IvDoorn@gmail.com> <1221760449.9262.96.camel@johannes.berg>
In-Reply-To: <1221760449.9262.96.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809182006.58620.IvDoorn@gmail.com> (sfid-20080918_200708_853298_120DD2D4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Johannes Berg wrote:
> On Thu, 2008-09-18 at 19:52 +0200, Ivo van Doorn wrote:
> 
> > From rfkill.h:
> > 	RFKILL_STATE_SOFT_BLOCKED = 0,	/* Radio output blocked */
> > 	RFKILL_STATE_UNBLOCKED    = 1,	/* Radio output allowed */
> > 	RFKILL_STATE_HARD_BLOCKED = 2,	/* Output blocked, non-overrideable */
> > 
> > Since b43 has a rfkill mechanism that does switch of the radio when RFKILL is set to BLOCK
> > after a key press, it should send RFKILL_STATE_HARD_BLOCKED because rfkill cannot override
> > it.
> > 
> > rt2x00 hardware does not change the radio state when RFKILL is set to BLOCK after a key press,
> > the state is therefor overridable and it can send RFKILL_STATE_SOFT_BLOCKED to rfkill.
> 
> If rt2x00 has no meaning of "hardware blocked", why is the button not a
> simple input device?

Because I had that discussion with Henrique and that ended with a "it isn't a input device"...

Ivo

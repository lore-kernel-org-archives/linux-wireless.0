Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45806 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753611AbYIROVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 10:21:38 -0400
Date: Thu, 18 Sep 2008 11:21:33 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918142133.GF1583@khazad-dum.debian.net> (sfid-20080918_162142_699631_4CEFE59A)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181519.12366.IvDoorn@gmail.com> <48D25BFE.6020708@lwfinger.net> <200809181553.29140.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809181553.29140.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> On Thursday 18 September 2008, Larry Finger wrote:
> > Ivo van Doorn wrote:
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

The *REAL* state of the hardware.  rfkill_force_state() is used to match the
rfkill idea of the radio state with whatever is REALLY in the hardware.

I guess it would be a damn good idea to make that clear in the docs, I will
send in a patch for that.

> > wrong result. Perhaps RFKILL does need to have 4 states so that an
> > RFKILL_STATE_HW_UNBLOCKED state can be transmitted.

It looks like I need an API that makes the conversion from HW:SW ->
rfkill_state easier...

The problem is that it really boils down to something like this:

static inline enum rfkill_state translate_to_rfkill_state(
		const bool is_any_hw_rfkill_line_active_RIGHT_NOW,
		const bool is_any_sw_rfkill_line_active_RIGHT_NOW) {

	if (is_any_hw_rfkill_line_active_RIGHT_NOW)
		return RFKILL_STATE_HARD_BLOCKED;
	else if (is_any_sw_rfkill_line_active_RIGHT_NOW)
		return RFKILL_STATE_SOFT_BLOCKED;
	else
		return RFKILL_STATE_UNBLOCKED;
}

and send that to rfkill_force_state().

I don't see why we couldn't add a rfkill_translate_and_force_state()
function that does the above and calls rfkill_force_state() on the result.
But I somehow doubt that will really help much.

The key issue seems to be to make it clear to everyone that whatever you use
to synthesize the status you are going to give to rfkill_force_state() must
be the current state of the hardware.

> When the key is pressed to unblock the device, then simply send state
> RFKILL_STATE_UNBLOCKED to rfkill. That will generate a trigger to the

You can only do THAT if the software rfkill lines were also unblocked.  If
any of the software rfkill lines are still active, the transmitter is still
blocked and the correct target state is SOFT_BLOCKED.

In other words: the radio might be double-blocked both in HW and SW.  When
you unblock the HW, you may transition to either SOFT_BLOCKED or UNBLOCKED,
depending on wether the SW rfkill line is still active.

I don't know enough about the mac80211 layer and b43 to know whether
dev->phy.radio_on matches the hardware or not.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

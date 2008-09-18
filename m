Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:38829 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbYIRRwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:52:21 -0400
Received: by nf-out-0910.google.com with SMTP id d3so9098nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 10:52:19 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 19:52:15 +0200
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181624.53050.IvDoorn@gmail.com> <200809181944.10018.mb@bu3sch.de>
In-Reply-To: <200809181944.10018.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-Id: <200809181952.15770.IvDoorn@gmail.com> (sfid-20080918_195224_932237_E9E182C0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Michael Buesch wrote:
> On Thursday 18 September 2008 16:24:52 Ivo van Doorn wrote:
> > On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> > > On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > > > If it is something coming from mac80211, then you do not want
> > > > to send a SOFT_BLOCKED event since that will cause all other radios
> > > > to be switched off simply because the b43 interface has not been
> > > > enabled.
> > > 
> > > Drivers ARE supposed to be able to set their radio state to their heart's
> > > content, without messing with any other devices.  There are no constraints
> > > to calls to rfkill_force_state(), other than the current issue that it must
> > > not be done from an atomic context.
> > 
> > My main point was that when the radio is not enabled because the user
> > did something like "iwconfig wlan0 txpower off" then this is not an rfkill
> > SOFT_BLOCKED event. Since that command has nothing to do with the
> > entire rfkill layer.
> > 
> > When you consider such commands as rfkill events you get wrong behavior
> > because it would trigger a SOFT_BLOCK in rfkill which will be send to all
> > registered drivers who can disable their radio off as well. And that is
> > definately not what you want...
> 
> Well, if that's the definition of the API, we must not force rfkill
> state to anything other than HW_BLOCKED or UNBLOCKED.
> I dunno how the API is defined...

>From rfkill.h:
	RFKILL_STATE_SOFT_BLOCKED = 0,	/* Radio output blocked */
	RFKILL_STATE_UNBLOCKED    = 1,	/* Radio output allowed */
	RFKILL_STATE_HARD_BLOCKED = 2,	/* Output blocked, non-overrideable */

Since b43 has a rfkill mechanism that does switch of the radio when RFKILL is set to BLOCK
after a key press, it should send RFKILL_STATE_HARD_BLOCKED because rfkill cannot override
it.

rt2x00 hardware does not change the radio state when RFKILL is set to BLOCK after a key press,
the state is therefor overridable and it can send RFKILL_STATE_SOFT_BLOCKED to rfkill.

Ivo

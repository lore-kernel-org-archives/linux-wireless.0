Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40379 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755816AbYIROiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 10:38:00 -0400
Date: Thu, 18 Sep 2008 11:37:54 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918143754.GH1583@khazad-dum.debian.net> (sfid-20080918_163817_315503_1A27C52F)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181519.12366.IvDoorn@gmail.com> <20080918141006.GE1583@khazad-dum.debian.net> <200809181624.53050.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809181624.53050.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> > On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > > If it is something coming from mac80211, then you do not want
> > > to send a SOFT_BLOCKED event since that will cause all other radios
> > > to be switched off simply because the b43 interface has not been
> > > enabled.
> > 
> > Drivers ARE supposed to be able to set their radio state to their heart's
> > content, without messing with any other devices.  There are no constraints
> > to calls to rfkill_force_state(), other than the current issue that it must
> > not be done from an atomic context.
> 
> My main point was that when the radio is not enabled because the user
> did something like "iwconfig wlan0 txpower off" then this is not an rfkill
> SOFT_BLOCKED event. Since that command has nothing to do with the
> entire rfkill layer.

We had some threads about it, and I don't recall any real conclusions if we
should have "tx power off" be treated the same way as a software rfkill
block request would, or not.  I believe it ended up as "do whatever you want
in your driver" (i.e. no real conclusion).

So, the rfkill core is not even aware of any tx power changes, unless the
wireless device drivers decides to make it so by actively feeding it new
states through rfkill_force_state() when the tx power changes from off to
something else, and from something else to off.

rfkill will work right whether you do it or not...

> When you consider such commands as rfkill events you get wrong behavior
> because it would trigger a SOFT_BLOCK in rfkill which will be send to all
> registered drivers who can disable their radio off as well. And that is
> definately not what you want...

...because this is incorrect.

No transmitter-specific rfkill events cause this, at least as far as the
rfkill core is concerned.  They are sent to userspace and the notify chain,
yes.  And either userspace or another kernel module might, if it is feeling
wrong on the head, change that event into a request to mess with all radios.

But right now, none will.  rfkill-input only cares about INPUT EVENTS, but
the rfkill core never *issues* any input events, ever.

Unless b43 is still issuing INPUT EVENTS even after the patch?  It
shouldn't.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

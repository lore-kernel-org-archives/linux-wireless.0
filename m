Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55308 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138AbYIRVeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 17:34:50 -0400
Date: Thu, 18 Sep 2008 18:34:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918213442.GX1583@khazad-dum.debian.net> (sfid-20080918_233453_994517_C21C6A69)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181851.59182.IvDoorn@gmail.com> <20080918184709.GN1583@khazad-dum.debian.net> <200809182235.30355.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809182235.30355.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > > > As for the "all configuration changes done in userspace result into new
> > > > events reported to userspace", well, I already explained the bit about set
> > > > txpower off above.  If you mean something else that I did or said, please
> > > > explain.
> > > 
> > > * User a executes command: iwconfig wlan0 txpower off
> > > * Driver for wlan0 switches radio off
> > > * Driver for wlan0 reports SOFT_BLOCKED to rfkill
> > 
> > Ok, then the docs need to make it clear that it should not say SOFT_BLOCKED
> > to rfkill if it is SOFT_BLOCKED *just because* of txpower off.
> 
> Right.
> 
> > And it has to be damn careful to never go out of SOFT_BLOCKED because of a
> > txpower <non-off> if it was SOFT_BLOCKED because of RKFILL, etc.
> 
> Definately, if we are really clear that userspace configuration changes should not
> trigger rfkill events we are also implying this. But it wouldn't hurt to make it extra
> clear. :)

We are not fully sync'd yet :)  I *still* don't understand what this
"userspace configuration changes should not trigger rfkill events" thing.

Do you mean "userspace configuration changes, that are NOT rfkill
configuration changes, should not trigger rfkill events" ?

> > > > > Or should the user now first disable his rfkill-listener daemon before applying
> > > > > configuration actions to his wireless interface just to prevent events from occuring?
> > > > 
> > > > No rfkill-listener daemon should be ever doing something as retarded as
> > > > shutting down all other radios because a single radio was shutdown in a
> > > > general way.
> > > 
> > > Exactly, so why raise it as rfkill event then?
> > 
> > I am confused.  I don't know if I understand what you mean with this.
> > 
> > We generate events when rfkill controllers change state, so that OSD applets
> > can tell you about it.   It can also be used to generate input events in
> > some situations.
> > 
> > We do not generate them ONLY to convert them to input events once in a blue
> > moon.
> > 
> > Indeed, something might still want to shutdown radios because of an specific
> > rfkill event in a specific situation.  That is very different from what you
> > were talking about, at least from my PoV.   That's why I wrote the stuff
> > below:
> 
> I was refering to RFKILL events which would be triggered by the 'iwconfig wlan0 txpower off'
> since those are not RFKILL events (triggered by a RFKILL device when the user presses
> a RFKILL key).

Ah, ok.  I suppose that's what you mean up above as well.  We agree, then.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48940 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195AbYIRTuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 15:50:19 -0400
Date: Thu, 18 Sep 2008 16:50:10 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918195010.GQ1583@khazad-dum.debian.net> (sfid-20080918_215023_682167_BD959F75)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181942.29122.IvDoorn@gmail.com> <1221760169.9262.91.camel@johannes.berg> <200809182002.39497.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809182002.39497.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > rfkill_announce_softstate(OPEN/BLOCKED)
> > rfkill_announce_hardstate(OPEN/BLOCKED)

We could, but it wouldn't help much.  WHEN you are allowed to call these
(well, mostly rfkill_announce_softstat) is the real problem.

And if you are forced to give both soft and hard states at once when you
update the rfkill core state, you guard yourself against stuff messing with
the rfkill state of your hardware behind your driver's back.

> > and all the other junk happens there. And make sure this can be called
> > from interrupts.
> 
> I think that limitation came from the notifier_block functions, but
> Henrique knows more about those details.

No, it would not be that trivial, but it would be doable.   Were that the
only problem, I would have done that already.

The problem is in the locking of rfkill->state, that is, rfkill->mutex.

Changing rfkill->mutex to a spinlock would work, but the issue here is how
much time rfkill->mutex spends locked.  It can stay locked for a while, the
longest path in the rfkill core includes a call to rfkill->get_state() plus
a call to rfkill->toggle_radio().

And we have no idea what get_state() and toggle_radio() might need to do, or
how much time would they take to do it.

If someone could help with it, it would be really nice if we could somehow
make unlocked access to rfkill->state safe...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55859 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754312AbYGSOT7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 10:19:59 -0400
Date: Sat, 19 Jul 2008 11:19:54 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] rfkill: mutex fixes
Message-ID: <20080719141954.GC11269@khazad-dum.debian.net> (sfid-20080719_162008_388807_02BAF38D)
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br> <1216150327-10904-5-git-send-email-hmh@hmh.eng.br> <200807191447.25603.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807191447.25603.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 19 Jul 2008, Ivo van Doorn wrote:
> > @@ -150,7 +150,7 @@ static void update_rfkill_state(struct rfkill *rfkill)
> >   * even if the radio is in RFKILL_STATE_HARD_BLOCKED state, so as to
> >   * give the driver a hint that it should double-BLOCK the transmitter.
> >   *
> > - * Caller must have aquired rfkill_mutex.
> > + * Caller must have acquired rfkill->mutex.
> 
> Should rfkill_toggle_radio() not grab the rfkill->mutex itself?
> At the moment every caller to rfkill_toggle_radio() does:
> 
> 			mutex_lock(&rfkill->mutex);
>  			rfkill_toggle_radio(rfkill, state, 0);
> 			mutex_unlock(&rfkill->mutex);
> 
> without anything in between, so perhaps the safest way would be moving
> the locking requirement into the function.

sysfs attributes need to use mutex_lock_interruptible or
mutex_lock_killable, and I also need it with external locking in some later
patches that I haven't sent yet because I am reviewing them.

> > @@ -521,8 +527,11 @@ static void rfkill_remove_switch(struct rfkill *rfkill)
> >  {
> >  	mutex_lock(&rfkill_mutex);
> >  	list_del_init(&rfkill->node);
> > -	rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
> >  	mutex_unlock(&rfkill_mutex);
> > +
> > +	mutex_lock(&rfkill->mutex);
> > +	rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
> > +	mutex_unlock(&rfkill->mutex);
> 
> Not sure about this one, something tells me it should be something like:
> 
> 	mutex_lock(&rfkill_mutex);
> 	list_del_init(&rfkill->node);
> 
> 	mutex_lock(&rfkill->mutex);
> 	rfkill_toggle_radio(rfkill, RFKILL_STATE_SOFT_BLOCKED, 1);
> 	mutex_unlock(&rfkill->mutex);
> 
> 	mutex_unlock(&rfkill_mutex);

We really shouldn't need the nesting, as once we have deleted something from
the list (which is always iterated and manipulated with rfkill_mutex
locked), nothing that would need the rfkill_mutex will access that rfkill
struct anymore.

Nesting wouldn't hurt anything, though.  If you really feel better with
that nesting in place, I can nest them.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

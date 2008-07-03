Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51585 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752488AbYGCByF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 21:54:05 -0400
Date: Wed, 2 Jul 2008 22:53:55 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, randy.dunlap@oracle.com,
	"John W. Linville" <linville@tuxdriver.com>, fcrespel@gmail.com
Subject: Re: [PATCH] iwlwifi: remove input device and fix rfkill state
Message-ID: <20080703015355.GB20410@khazad-dum.debian.net> (sfid-20080703_103137_154256_2B4981F0)
References: <6cf6b73e0807010849t42de3f3fn68085daca8d8009e@mail.gmail.com> <200807021800.25894.IvDoorn@gmail.com> <20080702184153.GA19949@khazad-dum.debian.net> <200807030031.20202.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807030031.20202.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 03 Jul 2008, Ivo van Doorn wrote:
> On Wednesday 02 July 2008, Henrique de Moraes Holschuh wrote:
> > On Wed, 02 Jul 2008, Ivo van Doorn wrote:
> > > Well actually it isn't that easy, the lock would also be used for the state change
> > > callback function toward the driver. And if that is done under a spinlock, USB
> > > drivers will start complaining since they can't access the hardware under atomic
> > > context...
> > 
> > Would it be worth it to use a hybrid scheme?
> 
> That would be nice if it could be done cleanly.

If it can't be done cleanly, it is best not done at all IMHO...

> > Callbacks and the notify chain would remain in task context, while the
> > locking is changed to spinlocks so that it can also work in interrupt
> > context when needed.   We document better (in the text documentation,
> > include files and kernel-doc) the contextes so that people don't get
> > confused by the code and think that a spinlock means atomic context is OK
> > for these handlers.
> 
> The mutex in the rfkill structure could become a spinlock, but the notifiers
> should probably be switched to the atomic versions as well so they could still
> be used at the current locations.

The kind of stuff we do in the notifiers usually benefits from task context,
I'd rather add a rfkill workqueue and call the notifiers from there when
needed (i.e. when we call from inside rfkill_force_state_atomic).

Other than calling LED triggers, everything else one typically would use the
notifier chain for (sending uevents, sending input evets) is best done from
task context, anyway.

> The global rfkill_mutex could remain a mutex to protect the rfkill list and all
> callback functions.

Yes, we could do that for the rfkill list, but shouldn't all callbacks and
all fields inside a rfkill struct be protected by the rfkill->mutex instead
of by the global mutex?

If a driver wants any more locking so as not to get two of its rfkill
callbacks (when it handles more than one rfkill device) called concurrently,
it is its business to do it.

> Now that I rechecked the code the current approach doesn't seem to protect the
> rfkill_toggle_radio callback function with consistent locking either.
> Sometimes it is called under the rfkill->mutex protection and at other times
> under the global rfkill_mutex.
> Both rfkill_state_store() and rfkill_resume() use the rfkill->mutex while most
> other functions use the global rfkill_mutex. Those 2 will have to switch over to
> the global mutex to prevent problems.

Actually, see above... Shouldn't we protect everything inside a rfkill
struct with rfkill->mutex, and outside stuff with the global mutex?

And I fear we could do better in the rfkill struct refcouting area, too.
The code I submitted does no refcounting, and it exposes the rfkill struct a
lot.  Even under the protection of the mutexes, it was probably unwise for
me to do it that way without some refcounting paranoia.  Especially when
schedule_work is involved...

> > For rfkill_force_state(), we'd either add a flags parameter that can take,
> > e.g., GFP_ATOMIC, to tell us whether it is being called from an interrupt
> > handler or a task context, or we could simply add rfkill_force_state_atomic().
> 
> Neither sound like a good idea, because that would require 2 approaches to lock
> the rfkill structure which could be good cause for race conditions under certain
> situations.

[...]

> > This would be safer (because the state would still be updated synchronously
> > when one calls rfkill_force_state(_atomic)?) than adding a
> > rfkill_schedule_force_state() for drivers to call in interrupt context.
> 
> Couldn't this cause race conditions in toggle_radio updates when 1 driver uses atomic
> context and the other in scheduled context.

Hmm, it could cause deadlocks I think.  task context takes lock.  interrupt
context tries to run, needs lock, keeps spinning forever waiting for it, and
if we are not SMP, task context never has a chance to release the lock, so
we get a deadlock.  Is this correct?

If it is, we better make the atomic path lock-free.  Argh.  This means
rfkill->state (the only thing we care about in the atomic path) would have
to become an atomic variable, and the code changed to cope with its value
being "volatile", so that it can be used in a lockless fashion.

It is doable, I think, although it is quite annoying.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

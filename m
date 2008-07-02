Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:16115 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbYGBW0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 18:26:11 -0400
Received: by nf-out-0910.google.com with SMTP id d3so189996nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jul 2008 15:26:09 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] iwlwifi: remove input device and fix rfkill state
Date: Thu, 3 Jul 2008 00:31:19 +0200
Cc: Zhu Yi <yi.zhu@intel.com>, Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, randy.dunlap@oracle.com,
	"John W. Linville" <linville@tuxdriver.com>, fcrespel@gmail.com
References: <6cf6b73e0807010849t42de3f3fn68085daca8d8009e@mail.gmail.com> <200807021800.25894.IvDoorn@gmail.com> <20080702184153.GA19949@khazad-dum.debian.net>
In-Reply-To: <20080702184153.GA19949@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807030031.20202.IvDoorn@gmail.com> (sfid-20080703_002616_000389_806DD1B9)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 July 2008, Henrique de Moraes Holschuh wrote:
> On Wed, 02 Jul 2008, Ivo van Doorn wrote:
> > Well actually it isn't that easy, the lock would also be used for the state change
> > callback function toward the driver. And if that is done under a spinlock, USB
> > drivers will start complaining since they can't access the hardware under atomic
> > context...
> 
> Would it be worth it to use a hybrid scheme?

That would be nice if it could be done cleanly.

> Callbacks and the notify chain would remain in task context, while the
> locking is changed to spinlocks so that it can also work in interrupt
> context when needed.   We document better (in the text documentation,
> include files and kernel-doc) the contextes so that people don't get
> confused by the code and think that a spinlock means atomic context is OK
> for these handlers.

The mutex in the rfkill structure could become a spinlock, but the notifiers
should probably be switched to the atomic versions as well so they could still
be used at the current locations.

The global rfkill_mutex could remain a mutex to protect the rfkill list and all
callback functions.

Now that I rechecked the code the current approach doesn't seem to protect the
rfkill_toggle_radio callback function with consistent locking either.
Sometimes it is called under the rfkill->mutex protection and at other times
under the global rfkill_mutex.
Both rfkill_state_store() and rfkill_resume() use the rfkill->mutex while most
other functions use the global rfkill_mutex. Those 2 will have to switch over to
the global mutex to prevent problems.

> For rfkill_force_state(), we'd either add a flags parameter that can take,
> e.g., GFP_ATOMIC, to tell us whether it is being called from an interrupt
> handler or a task context, or we could simply add rfkill_force_state_atomic().

Neither sound like a good idea, because that would require 2 approaches to lock
the rfkill structure which could be good cause for race conditions under certain
situations.

> This would be safer (because the state would still be updated synchronously
> when one calls rfkill_force_state(_atomic)?) than adding a
> rfkill_schedule_force_state() for drivers to call in interrupt context.

Couldn't this cause race conditions in toggle_radio updates when 1 driver uses atomic
context and the other in scheduled context.

> So far, the only function I can see that would have to work in
> interrupt/atomic context would be rfkill_force_state_atomic.

Thats correct.

Ivo


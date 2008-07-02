Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34352 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbYGBSl7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 14:41:59 -0400
Date: Wed, 2 Jul 2008 15:41:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, randy.dunlap@oracle.com,
	"John W. Linville" <linville@tuxdriver.com>, fcrespel@gmail.com
Subject: Re: [PATCH] iwlwifi: remove input device and fix rfkill state
Message-ID: <20080702184153.GA19949@khazad-dum.debian.net> (sfid-20080702_204209_962131_62C00753)
References: <6cf6b73e0807010849t42de3f3fn68085daca8d8009e@mail.gmail.com> <1214987135.14590.496.camel@debian.sh.intel.com> <20080702154327.GA11309@khazad-dum.debian.net> <200807021800.25894.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807021800.25894.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 02 Jul 2008, Ivo van Doorn wrote:
> Well actually it isn't that easy, the lock would also be used for the state change
> callback function toward the driver. And if that is done under a spinlock, USB
> drivers will start complaining since they can't access the hardware under atomic
> context...

Would it be worth it to use a hybrid scheme?

Callbacks and the notify chain would remain in task context, while the
locking is changed to spinlocks so that it can also work in interrupt
context when needed.   We document better (in the text documentation,
include files and kernel-doc) the contextes so that people don't get
confused by the code and think that a spinlock means atomic context is OK
for these handlers.

For rfkill_force_state(), we'd either add a flags parameter that can take,
e.g., GFP_ATOMIC, to tell us whether it is being called from an interrupt
handler or a task context, or we could simply add rfkill_force_state_atomic().

This would be safer (because the state would still be updated synchronously
when one calls rfkill_force_state(_atomic)?) than adding a
rfkill_schedule_force_state() for drivers to call in interrupt context.

So far, the only function I can see that would have to work in
interrupt/atomic context would be rfkill_force_state_atomic.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

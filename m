Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:46496 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725AbYGCMtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 08:49:11 -0400
Date: Thu, 3 Jul 2008 09:49:06 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, randy.dunlap@oracle.com,
	"John W. Linville" <linville@tuxdriver.com>, fcrespel@gmail.com
Subject: Re: [PATCH] iwlwifi: remove input device and fix rfkill state
Message-ID: <20080703124906.GC17823@khazad-dum.debian.net> (sfid-20080703_144933_221525_EBD3F9C1)
References: <6cf6b73e0807010849t42de3f3fn68085daca8d8009e@mail.gmail.com> <200807021800.25894.IvDoorn@gmail.com> <20080702184153.GA19949@khazad-dum.debian.net> <200807030031.20202.IvDoorn@gmail.com> <20080703015355.GB20410@khazad-dum.debian.net> <1215054671.14590.555.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1215054671.14590.555.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 03 Jul 2008, Zhu Yi wrote:
> On Wed, 2008-07-02 at 22:53 -0300, Henrique de Moraes Holschuh wrote:
> > Hmm, it could cause deadlocks I think.  task context takes lock.
> > interrupt context tries to run, needs lock, keeps spinning forever
> > waiting for it, and if we are not SMP, task context never has a chance
> > to release the lock, so we get a deadlock.  Is this correct?
> 
> Never heard of spin_lock_irqsave()?

Studying it now...  I did say I was not the right person for the job because
I am still learning all the locks we have :-)

> > If it is, we better make the atomic path lock-free.  Argh.  This means
> > rfkill->state (the only thing we care about in the atomic path) would
> > have to become an atomic variable, and the code changed to cope with
> > its value being "volatile", so that it can be used in a lockless
> > fashion.
> 
> Yup, if protecting rfkill->state is the only intention, a spinlock is
> too heavy. set|clear_bit is enough if organizing the state into bitmaps.
> BTW, read/write 32-bits aligned on x86 is already atomic.

I know rfkill->state is already atomic on x86, and I think it is also atomic
on every other platform Linux supports (I need to check this, since I am not
sure).  However, explicitly making it atomic_t is a damn heavy hint to
anyone using rfkill about how to deal with rfkill->state, and that can be a
big advantage.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

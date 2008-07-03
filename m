Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26360 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbYGCDMv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 23:12:51 -0400
Subject: Re: [PATCH] iwlwifi: remove input device and fix rfkill state
From: Zhu Yi <yi.zhu@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, randy.dunlap@oracle.com,
	"John W. Linville" <linville@tuxdriver.com>, fcrespel@gmail.com
In-Reply-To: <20080703015355.GB20410@khazad-dum.debian.net>
References: <6cf6b73e0807010849t42de3f3fn68085daca8d8009e@mail.gmail.com>
	 <200807021800.25894.IvDoorn@gmail.com>
	 <20080702184153.GA19949@khazad-dum.debian.net>
	 <200807030031.20202.IvDoorn@gmail.com>
	 <20080703015355.GB20410@khazad-dum.debian.net>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 11:11:11 +0800
Message-Id: <1215054671.14590.555.camel@debian.sh.intel.com> (sfid-20080703_085916_676770_9279E849)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-02 at 22:53 -0300, Henrique de Moraes Holschuh wrote:
> Hmm, it could cause deadlocks I think.  task context takes lock.
> interrupt context tries to run, needs lock, keeps spinning forever
> waiting for it, and if we are not SMP, task context never has a chance
> to release the lock, so we get a deadlock.  Is this correct?

Never heard of spin_lock_irqsave()?

> If it is, we better make the atomic path lock-free.  Argh.  This means
> rfkill->state (the only thing we care about in the atomic path) would
> have to become an atomic variable, and the code changed to cope with
> its value being "volatile", so that it can be used in a lockless
> fashion.

Yup, if protecting rfkill->state is the only intention, a spinlock is
too heavy. set|clear_bit is enough if organizing the state into bitmaps.
BTW, read/write 32-bits aligned on x86 is already atomic.

Thanks,
-yi


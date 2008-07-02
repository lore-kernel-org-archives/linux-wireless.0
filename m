Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57190 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbYGBPnd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 11:43:33 -0400
Date: Wed, 2 Jul 2008 12:43:27 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, randy.dunlap@oracle.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, fcrespel@gmail.com
Subject: Re: [PATCH] iwlwifi: remove input device and fix rfkill state
Message-ID: <20080702154327.GA11309@khazad-dum.debian.net> (sfid-20080702_174337_729056_D93A29B8)
References: <6cf6b73e0807010849t42de3f3fn68085daca8d8009e@mail.gmail.com> <20080701165657.GC6962@khazad-dum.debian.net> <1214987135.14590.496.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214987135.14590.496.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 02 Jul 2008, Zhu Yi wrote:
> On Tue, 2008-07-01 at 13:56 -0300, Henrique de Moraes Holschuh wrote:
> > On Tue, 01 Jul 2008, Adel Gadllah wrote:
> > > The calls to iwl|iwl3945_rfkill_set_hw_state() had to be moved
> > because rfkill_force_state() cannot be called from an atomic context.
> 
> Yes, but what your patch changed is not in the atomic context. It is
> just inside the driver's priv->mutex. I don't see any problem if you
> call rfkill_force_state() inside it.
> 
> > Yeah, the joys of mutexes.  If this is going to be a severe annoyance
> > to drivers, I don't see why rfkill could not be changed to use some
> > other locking primitive that does work on atomic contexes.
> 
> Allowing rfkill_force_state() to be called in the atomic context would
> be useful especially for hardware rfkill. Devices (i.e iwl4965) receive
> an interrupt when the hw-rfkill state changes. It's natural to update
> the rfkill state in this context.
> 
> How about protect the rfkill->state by a spinlock and put the
> notifier_call_chain() into a workqueue in the rfkill subsystem?

That shouldn't be a problem.  What are the spinlock primitives I should be
using on rfkill_force_state so that it would be compatible with most drivers
(and not cause issues when called in task context instead of interrupt
context)?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

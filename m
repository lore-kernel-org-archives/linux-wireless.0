Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:51000 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511AbYGBPzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 11:55:42 -0400
Received: by nf-out-0910.google.com with SMTP id d3so132953nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jul 2008 08:55:40 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] iwlwifi: remove input device and fix rfkill state
Date: Wed, 2 Jul 2008 18:00:25 +0200
Cc: Zhu Yi <yi.zhu@intel.com>, Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, randy.dunlap@oracle.com,
	"John W. Linville" <linville@tuxdriver.com>, fcrespel@gmail.com
References: <6cf6b73e0807010849t42de3f3fn68085daca8d8009e@mail.gmail.com> <1214987135.14590.496.camel@debian.sh.intel.com> <20080702154327.GA11309@khazad-dum.debian.net>
In-Reply-To: <20080702154327.GA11309@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807021800.25894.IvDoorn@gmail.com> (sfid-20080702_175629_482980_97F07900)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 July 2008, Henrique de Moraes Holschuh wrote:
> On Wed, 02 Jul 2008, Zhu Yi wrote:
> > On Tue, 2008-07-01 at 13:56 -0300, Henrique de Moraes Holschuh wrote:
> > > On Tue, 01 Jul 2008, Adel Gadllah wrote:
> > > > The calls to iwl|iwl3945_rfkill_set_hw_state() had to be moved
> > > because rfkill_force_state() cannot be called from an atomic context.
> > 
> > Yes, but what your patch changed is not in the atomic context. It is
> > just inside the driver's priv->mutex. I don't see any problem if you
> > call rfkill_force_state() inside it.
> > 
> > > Yeah, the joys of mutexes.  If this is going to be a severe annoyance
> > > to drivers, I don't see why rfkill could not be changed to use some
> > > other locking primitive that does work on atomic contexes.
> > 
> > Allowing rfkill_force_state() to be called in the atomic context would
> > be useful especially for hardware rfkill. Devices (i.e iwl4965) receive
> > an interrupt when the hw-rfkill state changes. It's natural to update
> > the rfkill state in this context.
> > 
> > How about protect the rfkill->state by a spinlock and put the
> > notifier_call_chain() into a workqueue in the rfkill subsystem?
> 
> That shouldn't be a problem.  What are the spinlock primitives I should be
> using on rfkill_force_state so that it would be compatible with most drivers
> (and not cause issues when called in task context instead of interrupt
> context)?

Well actually it isn't that easy, the lock would also be used for the state change
callback function toward the driver. And if that is done under a spinlock, USB
drivers will start complaining since they can't access the hardware under atomic
context...

Ivo

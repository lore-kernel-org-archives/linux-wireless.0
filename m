Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30138 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbYGBI1U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 04:27:20 -0400
Subject: Re: [PATCH] iwlwifi: remove input device and fix rfkill state
From: Zhu Yi <yi.zhu@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, randy.dunlap@oracle.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, fcrespel@gmail.com
In-Reply-To: <20080701165657.GC6962@khazad-dum.debian.net>
References: <6cf6b73e0807010849t42de3f3fn68085daca8d8009e@mail.gmail.com>
	 <20080701165657.GC6962@khazad-dum.debian.net>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 16:25:35 +0800
Message-Id: <1214987135.14590.496.camel@debian.sh.intel.com> (sfid-20080702_102727_267183_2311B9D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-01 at 13:56 -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 01 Jul 2008, Adel Gadllah wrote:
> > The calls to iwl|iwl3945_rfkill_set_hw_state() had to be moved
> because rfkill_force_state() cannot be called from an atomic context.

Yes, but what your patch changed is not in the atomic context. It is
just inside the driver's priv->mutex. I don't see any problem if you
call rfkill_force_state() inside it.

> Yeah, the joys of mutexes.  If this is going to be a severe annoyance
> to drivers, I don't see why rfkill could not be changed to use some
> other locking primitive that does work on atomic contexes.

Allowing rfkill_force_state() to be called in the atomic context would
be useful especially for hardware rfkill. Devices (i.e iwl4965) receive
an interrupt when the hw-rfkill state changes. It's natural to update
the rfkill state in this context.

How about protect the rfkill->state by a spinlock and put the
notifier_call_chain() into a workqueue in the rfkill subsystem?

Thanks,
-yi


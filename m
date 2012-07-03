Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:56492 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755918Ab2GCQ2z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:28:55 -0400
Message-ID: <1341332934.2164.17.camel@joe2Laptop> (sfid-20120703_182901_353228_71D8AB96)
Subject: Re: [PATCH] compat-wireless: fix debugging in iwlwifi
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 03 Jul 2012 09:28:54 -0700
In-Reply-To: <1341332487.20124.7.camel@jlt3.sipsolutions.net>
References: <1341322108.20124.3.camel@jlt3.sipsolutions.net>
	 <CAB=NE6VvJ+rv4mtYMngVg==tDVZpRM2CrGJ3Yc4u7a7ZLwiGOA@mail.gmail.com>
	 <CAB=NE6WDyFS5gK85Lq1uEA5A5HLRhhyVcFT7EQkK0SALG0YF6g@mail.gmail.com>
	 (sfid-20120703_181714_567213_CDA8319F) <1341332487.20124.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-03 at 18:21 +0200, Johannes Berg wrote:
> On Tue, 2012-07-03 at 09:16 -0700, Luis R. Rodriguez wrote:
> > On Tue, Jul 3, 2012 at 8:47 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > > On Tue, Jul 3, 2012 at 6:28 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > >> From: Johannes Berg <johannes.berg@intel.com>
> > >>
> > >> As compat includes linux/device.h well before iwlwifi, the
> > >> definitions from there are used without DEBUG, but iwlwifi
> > >> defines DEBUG to get debug output. Use dev_printk instead
> > >> of dev_dbg to get debugging back.
> > >>
> > >> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > >
> > > Applied and pushed, thanks!
> > 
> > On today's linux-next.git the dev_dbg() changed to dev_err(), I've
> > updated the patch to reflect this.
> 
> Huh, sorry. Please drop this for now -- the patch to change it *from*
> dev_err *to* dev_dbg is only in my iwlwifi-next tree now.

And besides, the concept is wrong.

There's no reason to drop dynamic_debug support by
forcing output to KERN_DEBUG.



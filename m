Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab2GCQV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:21:28 -0400
Message-ID: <1341332487.20124.7.camel@jlt3.sipsolutions.net> (sfid-20120703_182132_301245_D7783388)
Subject: Re: [PATCH] compat-wireless: fix debugging in iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 03 Jul 2012 18:21:27 +0200
In-Reply-To: <CAB=NE6WDyFS5gK85Lq1uEA5A5HLRhhyVcFT7EQkK0SALG0YF6g@mail.gmail.com> (sfid-20120703_181714_567213_CDA8319F)
References: <1341322108.20124.3.camel@jlt3.sipsolutions.net>
	 <CAB=NE6VvJ+rv4mtYMngVg==tDVZpRM2CrGJ3Yc4u7a7ZLwiGOA@mail.gmail.com>
	 <CAB=NE6WDyFS5gK85Lq1uEA5A5HLRhhyVcFT7EQkK0SALG0YF6g@mail.gmail.com>
	 (sfid-20120703_181714_567213_CDA8319F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-03 at 09:16 -0700, Luis R. Rodriguez wrote:
> On Tue, Jul 3, 2012 at 8:47 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> > On Tue, Jul 3, 2012 at 6:28 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >> From: Johannes Berg <johannes.berg@intel.com>
> >>
> >> As compat includes linux/device.h well before iwlwifi, the
> >> definitions from there are used without DEBUG, but iwlwifi
> >> defines DEBUG to get debug output. Use dev_printk instead
> >> of dev_dbg to get debugging back.
> >>
> >> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> >
> > Applied and pushed, thanks!
> 
> On today's linux-next.git the dev_dbg() changed to dev_err(), I've
> updated the patch to reflect this.

Huh, sorry. Please drop this for now -- the patch to change it *from*
dev_err *to* dev_dbg is only in my iwlwifi-next tree now.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12552 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbZA1QRI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 11:17:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 08:17:08 -0800
Date: Wed, 28 Jan 2009 08:16:24 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: add get reg command
Message-ID: <20090128161624.GI6174@tesla> (sfid-20090128_171712_854070_60AE2BC9)
References: <1233111125-7955-1-git-send-email-lrodriguez@atheros.com> <1233137841.3936.2.camel@johannes.local> <20090128144455.GE6174@tesla> <1233154234.4071.26.camel@johannes.local> <20090128152011.GH6174@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090128152011.GH6174@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 07:20:11AM -0800, Luis Rodriguez wrote:
> On Wed, Jan 28, 2009 at 06:50:34AM -0800, Johannes Berg wrote:
> > On Wed, 2009-01-28 at 06:44 -0800, Luis R. Rodriguez wrote:
> > > On Wed, Jan 28, 2009 at 02:17:21AM -0800, Johannes Berg wrote:
> > > > On Tue, 2009-01-27 at 18:52 -0800, Luis R. Rodriguez wrote:
> > > >
> > > > > +       mutex_lock(&cfg80211_drv_mutex);
> > > > > +       regd = reg_get_current_rd();
> > > > > +       mutex_unlock(&cfg80211_drv_mutex);
> > > > > +
> > > > > +       if (!regd)
> > > > > +               goto out;
> > > >
> > > > Any reason you need to copy and can't just build the whole thing under
> > > > lock?
> > >
> > > Glad you asked, we can lock the entire call or we can do the above to
> > > copy. I picked a copy to not let a regular user (get reg can be called
> > > by anyone) abuse the lock as cfg80211_drv_mutex is used in a lot of places,
> > > I guess its silly but other's input on this is appreciated as well. Not sure
> > > if the copy was the best choice.
> >
> > I don't really see much difference between locking to create a copy and
> > locking to create a copy in a different format, do you?
> > Except to create
> > a copy needs to allocate memory which could take even longer.
> 
> Agreed, that's the thing I was not thinking about those two paths I was
> thinking of either using a copy of cfg80211_regdomain for nl80211.c to move
> forward without having to keep cfg80211_drv_mutex *or* having
> reg_get_current_rd() just return cfg80211_regdomain and have the reg_reg
> lock during its entire access.
> 
> I am honestly not sure which is the best approach but I picked a copy
> since I figure having a user do a kmalloc() is less harmless then contending
> the lock more time if he wanted to abuse the system. I also thought about
> using a static regd in place just to copy the cfg80211_regdomain but then
> that would mean having a large static regd with max num rules and I didn't
> like that either. Seemed to me a kmalloc() was in the middle. Let me know
> if you guys have better advice.

Actually nevermind, I see your point now, we would be iterating over 
cfg80211_regdomain anyway, will resend, thanks.

  Luis

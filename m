Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56134 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2LNIcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 03:32:55 -0500
Message-ID: <1355473998.9571.1.camel@jlt4.sipsolutions.net> (sfid-20121214_093302_481604_85E04418)
Subject: Re: [PATCH 5/5] mac80211: optimise roaming time again
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>
Date: Fri, 14 Dec 2012 09:33:18 +0100
In-Reply-To: <CAB3XZEfKKXcy9GFk_fJcnA6y_5uG05gnzCsr1C52P+qT1WYDiw@mail.gmail.com> (sfid-20121214_005747_143101_C5893859)
References: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
	 <1355439573-13206-6-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEcz-qywVdb5OFG38Kdk8Vue4bS8zxAfuKs_FxFGaisd9w@mail.gmail.com>
	 <1355442070.25160.2.camel@jlt4.sipsolutions.net>
	 <CAB3XZEfKKXcy9GFk_fJcnA6y_5uG05gnzCsr1C52P+qT1WYDiw@mail.gmail.com>
	 (sfid-20121214_005747_143101_C5893859)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-14 at 01:57 +0200, Eliad Peller wrote:

> >> > +static inline int sta_info_flush(struct ieee80211_sub_if_data *sdata)
> >> > +{
> >> > +       int ret = sta_info_flush_defer(sdata);
> >> > +
> >> > +       if (ret)
> >> > +               sta_info_flush_cleanup(sdata);
> >> > +
> >> > +       return ret;
> >> > +}
> >> > +
> >>
> >> but i think this is wrong - there might already be stations in the cleanup list.
> >> you should always call sta_info_flush_cleanup.
> >
> > I don't think so? I thought about this for a while, but I see only the
> > case where there are stations being added to the list in the
> > sta_info_flush_defer() call -- then the return value is bigger than zero
> > and when we return, nothing is on the cleanup list.
> >
> > The other case is that there's something on the cleanup list for managed
> > mode, but that only needs to be guaranteed to be cleaned up when the
> > interface goes down (nothing in the destroy calls back to the driver) so
> > there the explicit call to sta_info_flush_cleanup() should be enough?
> >
> well, i didn't delve into the exact use cases, but semantically, after
> calling sta_info_flush(), i'd expect all the vif's stations to get
> flushed.
> this might be redundant right now (as there are no
> sta_info_flush_defer calls followed by sta_info_flush), but it sounds
> more correct to me.

Actually you're right, if a station is deleted explicitly (just before
the AP interface goes down) it still goes on the cleanup list, and if
it's the only one then this patch brings back the bug.

I'll put it back unconditionally.

johannes


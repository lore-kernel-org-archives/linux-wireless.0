Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab2LMXkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 18:40:49 -0500
Message-ID: <1355442070.25160.2.camel@jlt4.sipsolutions.net> (sfid-20121214_004053_056794_D09B588F)
Subject: Re: [PATCH 5/5] mac80211: optimise roaming time again
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>
Date: Fri, 14 Dec 2012 00:41:10 +0100
In-Reply-To: <CAB3XZEcz-qywVdb5OFG38Kdk8Vue4bS8zxAfuKs_FxFGaisd9w@mail.gmail.com> (sfid-20121214_003229_008437_8C84FB76)
References: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
	 <1355439573-13206-6-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEcz-qywVdb5OFG38Kdk8Vue4bS8zxAfuKs_FxFGaisd9w@mail.gmail.com>
	 (sfid-20121214_003229_008437_8C84FB76)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-14 at 01:32 +0200, Eliad Peller wrote:
> On Fri, Dec 14, 2012 at 12:59 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > The last fixes re-added the RCU synchronize penalty
> > on roaming to fix the races. Split up sta_info_flush()
> > now to get rid of that again, and let managed mode
> > (and only it) delay the actual destruction.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> The patchset looks good. thanks for fixing it :)

:)

> > +static inline int sta_info_flush(struct ieee80211_sub_if_data *sdata)
> > +{
> > +       int ret = sta_info_flush_defer(sdata);
> > +
> > +       if (ret)
> > +               sta_info_flush_cleanup(sdata);
> > +
> > +       return ret;
> > +}
> > +
> 
> but i think this is wrong - there might already be stations in the cleanup list.
> you should always call sta_info_flush_cleanup.

I don't think so? I thought about this for a while, but I see only the
case where there are stations being added to the list in the
sta_info_flush_defer() call -- then the return value is bigger than zero
and when we return, nothing is on the cleanup list.

The other case is that there's something on the cleanup list for managed
mode, but that only needs to be guaranteed to be cleaned up when the
interface goes down (nothing in the destroy calls back to the driver) so
there the explicit call to sta_info_flush_cleanup() should be enough?


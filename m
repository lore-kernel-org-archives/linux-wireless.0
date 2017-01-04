Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60362 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750755AbdADKAm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 05:00:42 -0500
Message-ID: <1483523988.15591.9.camel@sipsolutions.net> (sfid-20170104_110105_066698_92B0F82E)
Subject: Re: [RFC] nl80211: allow multiple active scheduled scan requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Dmitry Shmidt <dimitrysh@google.com>
Date: Wed, 04 Jan 2017 10:59:48 +0100
In-Reply-To: <ba1cb1a1-3d27-7421-47ea-a5625a886518@broadcom.com> (sfid-20170103_132539_473762_DA0FB5E7)
References: <1481645071.20412.30.camel@sipsolutions.net>
         <1482315616-4721-1-git-send-email-arend.vanspriel@broadcom.com>
         <1483353841.4596.2.camel@sipsolutions.net>
         <ba1cb1a1-3d27-7421-47ea-a5625a886518@broadcom.com>
         (sfid-20170103_132539_473762_DA0FB5E7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-01-03 at 13:25 +0100, Arend Van Spriel wrote:
> On 2-1-2017 11:44, Johannes Berg wrote:
> > 
> > > +	/*
> > > +	 * allow only one legacy scheduled scan if user-space
> > > +	 * does not indicate multiple scheduled scan support.
> > > +	 */
> > > +	if (!info->attrs[NL80211_ATTR_SCHED_SCAN_MULTI] &&
> > > +	    cfg80211_legacy_sched_scan_active(rdev))
> > >  		return -EINPROGRESS;
> > 
> > That probably doesn't go far enough - if legacy one is active then
> > we
> > probably shouldn't allow a new MULTI one either (or abandon the
> > legacy
> > one) so that older userspace doesn't get confused with multiple
> > notifications from sched scans it didn't start.
> 
> I considered that although not taking the notifications into account.
> Will change it. Abandoning the legacy one would be a behavioral
> change so probably not acceptable, right?

Well, it would be acceptable since it's documented that it's possible
it might stop for any reason. However, we need to prefer something -
always preferring the new sched scan could lead to bounces, so we can
prefer (1) existing, (2) legacy-single type or (3) new-multi type, but
not (4) new sched scan.

I think preferring the existing would probably be best, i.e. refuse
legacy if any sched scan is running, and refuse multi if legacy is
running?

> I guess your remark means this clarifies your earlier question about
> the request id, right?

yeah.

johannes

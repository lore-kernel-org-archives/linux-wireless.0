Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2HBQ0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 12:26:33 -0400
Message-ID: <1343924789.4471.26.camel@jlt3.sipsolutions.net> (sfid-20120802_182637_091996_D5FFE5F5)
Subject: Re: cfg80211_disconnected memory leak
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 02 Aug 2012 18:26:29 +0200
In-Reply-To: <CAMLZHHSVediwHaw3f8s1QYNoc_xV55CEUP7wBQu_on-p8WUQJg@mail.gmail.com> (sfid-20120802_181111_388647_3D9BB914)
References: <CAMLZHHQkv_fHzd89fP7bNow7eL3oX+Duzr5rS5NJfhffqwUv2g@mail.gmail.com>
	 <1343842772.4638.15.camel@jlt3.sipsolutions.net>
	 <CAMLZHHQdBHZa4NBQ3ygKJSHmKL11ERUWDAtMx0-Qh4OzSoN-SA@mail.gmail.com>
	 <1343894552.4458.4.camel@jlt3.sipsolutions.net>
	 <CAMLZHHSVediwHaw3f8s1QYNoc_xV55CEUP7wBQu_on-p8WUQJg@mail.gmail.com>
	 (sfid-20120802_181111_388647_3D9BB914)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-08-02 at 10:11 -0600, Daniel Drake wrote:
> On Thu, Aug 2, 2012 at 2:02 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > Oh, hm. I didn't think it could unregister before we give up our
> > reference, but I guess that makes sense after all.
> >
> > I'm not sure there's an easy way to fix it other than making the driver
> > not call cfg80211_disconnected() in case the disconnect was requested by
> > cfg80211 -- that call isn't needed and will not do anything at all, but
> > I'm not sure how easy that would be in the driver?
> 
> I guess you've considered clearing all the pending work before
> removing a netdev from the rdev's list?

Yes, but we can't just try to flush the workqueue because of locking
concerns in this area.

Hmm. Then again, I think we can call cfg80211_process_wdev_events() from
case NETDEV_UNREGISTER though, probably after removing from the list.
Maybe you could try that?

> I think a driver modification would be easy, if it is the right solution.
> 
> lbs_disconnect() is the function that calls cfg80211_disconnected().
> We only ever call this in 2 contexts:
> 
> 1. From our cfg80211_ops.disconnect handler - you say this isn't needed
> 2. From the netdev ndo_stop handler - I guess it is also not necessary
> to inform cfg80211 that we have disconnected at this point, it is kind
> of obvious..?

In fact, you won't get to ndo_stop without cfg80211 calling
disconnect(), because it does that from NETDEV_GOING_DOWN.

> So completely removing the call to cfg80211_disconnected() may be the
> right option here, is that what you recommend?

I'm not 100% sure about the API in this area right now though, it's been
a while and I never worked much with this API (rather than the mac80211
one with auth/assoc/disassoc/deauth.)

johannes


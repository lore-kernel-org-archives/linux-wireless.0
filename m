Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51834 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2HBQLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 12:11:10 -0400
Received: by qcro28 with SMTP id o28so5468032qcr.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2012 09:11:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343894552.4458.4.camel@jlt3.sipsolutions.net>
References: <CAMLZHHQkv_fHzd89fP7bNow7eL3oX+Duzr5rS5NJfhffqwUv2g@mail.gmail.com>
	<1343842772.4638.15.camel@jlt3.sipsolutions.net>
	<CAMLZHHQdBHZa4NBQ3ygKJSHmKL11ERUWDAtMx0-Qh4OzSoN-SA@mail.gmail.com>
	<1343894552.4458.4.camel@jlt3.sipsolutions.net>
Date: Thu, 2 Aug 2012 10:11:08 -0600
Message-ID: <CAMLZHHSVediwHaw3f8s1QYNoc_xV55CEUP7wBQu_on-p8WUQJg@mail.gmail.com> (sfid-20120802_181115_348574_9FB6E20E)
Subject: Re: cfg80211_disconnected memory leak
From: Daniel Drake <dsd@laptop.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 2, 2012 at 2:02 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Oh, hm. I didn't think it could unregister before we give up our
> reference, but I guess that makes sense after all.
>
> I'm not sure there's an easy way to fix it other than making the driver
> not call cfg80211_disconnected() in case the disconnect was requested by
> cfg80211 -- that call isn't needed and will not do anything at all, but
> I'm not sure how easy that would be in the driver?

I guess you've considered clearing all the pending work before
removing a netdev from the rdev's list?


I think a driver modification would be easy, if it is the right solution.

lbs_disconnect() is the function that calls cfg80211_disconnected().
We only ever call this in 2 contexts:

1. From our cfg80211_ops.disconnect handler - you say this isn't needed
2. From the netdev ndo_stop handler - I guess it is also not necessary
to inform cfg80211 that we have disconnected at this point, it is kind
of obvious..?

So completely removing the call to cfg80211_disconnected() may be the
right option here, is that what you recommend?

Thanks
Daniel

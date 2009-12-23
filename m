Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22029 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZLWTHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 14:07:07 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 11:07:07 -0800
Date: Wed, 23 Dec 2009 11:07:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner
 case
Message-ID: <20091223190704.GH2609@tux>
References: <19248.19829.293087.367661@gargle.gargle.HOWL>
 <20091222155005.GA4385@tux>
 <20091222162055.GC4385@tux>
 <20091222165528.GE4385@tux>
 <20091222175939.GF4385@tux>
 <43e72e890912221716r64ea4542qd747302b536a3156@mail.gmail.com>
 <19249.34294.19925.963051@gargle.gargle.HOWL>
 <43e72e890912221854s5f06a0d2jcfffb1cc8d857347@mail.gmail.com>
 <19249.41596.778604.908714@gargle.gargle.HOWL>
 <20091223183351.GF2609@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20091223183351.GF2609@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 23, 2009 at 10:33:51AM -0800, Luis Rodriguez wrote:
> The issues are as follows:
> 
> 1) We stop TX and flush all packets out, and then call the driver stop().
>    Unfortunately there is a failed assumption that even ieee80211_xmit()
>    would not be called after stopping TX as __ieee80211_suspend() does
>    above.
> 2) Since ieee80211_xmit() is being called even after the driver stop()
>    callback it means mac80211 can potentially schedule work. Now the
>    new rework on the mac80211 workqueue pushes us to WARN when either
>    a driver or mac80211 tried to queue work onto the mac80211 workqueue
>    and we're suspended. A new patch from Johannes futher enhances this
>    to take into consideration resume so that we can allow drivers / mac80211
>    to queue work if we were suspended but now resuming. Even with these
>    checks in place I note that currently we do slip work through after
>    the driver stop() callback is called and before loacl->suspended is
>    set to true. So there seems to be a race here.
> 
> The first issue is not so clear to resolve as although we likely do prevent
> the networking core from calling ieee80211_subif_start_xmit() it doesn't
> mean ieee80211_xmit() internally will not be called by other parts of
> mac80211 and indeed I do believe this is what is happening. I'll try
> pin point the exact spot where this happens though, but I'll note though
> that checking for local->suspended will *not* work since we already know
> some work is being queued *and running!* and it wouldn't have if
> local->suspended was true already.

OK, not bad and pretty obvious too -- the issue is __ieee80211_suspend()
will tear down BA sessions and this does require xmit'ing. The only issue
then becomes that of trying to queue work after a driver stop(), that can
be fixed easily and will send a patch next.

  Luis

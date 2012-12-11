Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:52362 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab2LKHxh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 02:53:37 -0500
Message-ID: <1355212373.3738.119.camel@cumari.coelho.fi> (sfid-20121211_085340_845625_F661F306)
Subject: Re: [PATCH v2] wlcore: use separate HW queue for each AC in each vif
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 11 Dec 2012 09:52:53 +0200
In-Reply-To: <CA+XVXfe7BcG+8_9MTBzxovfoQF81uW-KoSMWdV8sPmY-Dj-mbw@mail.gmail.com>
References: <1354229283-7934-1-git-send-email-arik@wizery.com>
	 <1355153582.3738.53.camel@cumari.coelho.fi>
	 <CA+XVXffLuJuqQJ8Ju5XsipSdkuUBFOx=0ReQJe8Oc7J-5X+B6Q@mail.gmail.com>
	 <1355176215.3738.102.camel@cumari.coelho.fi>
	 <CA+XVXffZgF+rJfgrGbq0+D2Y1gx2VmZ1HziD18r9NNwqQ2BVjA@mail.gmail.com>
	 <1355180983.3738.112.camel@cumari.coelho.fi>
	 <CA+XVXfe7BcG+8_9MTBzxovfoQF81uW-KoSMWdV8sPmY-Dj-mbw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-11 at 09:38 +0200, Arik Nemtsov wrote:
> On Tue, Dec 11, 2012 at 1:09 AM, Luciano Coelho <coelho@ti.com> wrote:
> >
> >> So for instance we want to stop all vifs during recovery, and mark all
> >> with stop reasons. That's also the reason I used the mac80211 global
> >> API for stopping/waking the queues.
> >
> > A "global" ieee80211_iterate_active_interfaces_atomic() would do the
> > same thing. ;)
> >
> > But I agree that it's simpler to set all possible vifs as stopped here.
> 
> Actually your suggestion acts differently in some corner cases.
> Namely, if we stop all vifs and suddenly mac80211 decides to add a
> vif, then the new vif will not be stopped, and we will clear all stop
> reasons for it.

But the new vif should probably not be stopped in this case, if it was
added after we wanted to stop all vifs.  Of course it would probably be
a bug if this happens while we're recovering or suspended.


> Then with my version, we will trigger the the WARN_ON when waking the
> queues. But this corner case is so strange that I would like a WARN_ON
> there to detect it. If we do stumble across it, we can discuss various
> solutions, including changing mac80211..

I agree that a WARN when that happens would be good, because it's most
likely a bug.  With my solution, there are other ways to warn,
obviously.  Maybe it would be clearer to warn if someone tries to add an
interface but the "full stop" is on-going.


> TLDR: Let's keep it the way it is today :)

Ok, but these discussions are good because it makes us think more about
the whole thing.  Especially for me, now that I have a lot of stuff to
catch up with. :)

TDLR: I'll apply the patch with this part as it is.

--
Luca.


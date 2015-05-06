Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57673 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbbEFNPy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 09:15:54 -0400
Message-ID: <1430918151.1954.6.camel@sipsolutions.net> (sfid-20150506_151557_511192_AD6C1CA3)
Subject: Re: [PATCH] mac80211: handle hw roc cancel vs. expiration race
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 06 May 2015 15:15:51 +0200
In-Reply-To: <CAB3XZEe71wE+zPR-knwvrFMjecvddJhVsMWJ9YcHkGa9xW-XZQ@mail.gmail.com> (sfid-20150309_145944_668962_31D825FD)
References: <1425902001-3163-1-git-send-email-eliad@wizery.com>
	 <1425905568.1928.7.camel@sipsolutions.net>
	 <CAB3XZEe71wE+zPR-knwvrFMjecvddJhVsMWJ9YcHkGa9xW-XZQ@mail.gmail.com>
	 (sfid-20150309_145944_668962_31D825FD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To revive an old thread - sorry...

> >> Fix it by cancelling hw_roc_done on roc cancel.
> >> Since hw_roc_done takes local->mtx, temporarily
> >> release it (before re-acquiring it and starting
> >> the next roc if needed).
> >
> > I can't say I like this, and I'm not even sure it doesn't leave a race?
> > After all, the work will not take the RTNL.
> >
> the other way (cancel while hw_roc_done) is protected, since
> ieee80211_cancel_roc() looks for a specific roc cookie.

But you're saying that we rely on RTNL to not modify the list, and the
hw_roc_done work doesn't use the RTNL? Hmm. Are you saying now that it
also checks that it was started? But then why do we even have this
issue?

Or I can see why we have this issue, but perhaps we could fix it by
flushing the work *after* we cancel, so in case the driver was
cancelling at the same time we'd not yet have started the next one?

> > I think the only way to really fix that is to make the driver return the
> > roc pointer or so and then we can either queue a work struct per roc
> > struct, or at least mark the roc struct as driver-destroyed and
> > double-check that in the work function?
> >
> that was my initial implementation. but then i thought it will be
> nicer to implement it in mac80211 and avoid changing all the drivers
> (with the need to save the cookie, etc.)
> do you prefer adding such cookie/pointer param?

How difficult was it for the driver(s)? It seems it would make the code
far easier to reason about, which can only be a good thing. We'd save
the whole race discussion above :)

johannes


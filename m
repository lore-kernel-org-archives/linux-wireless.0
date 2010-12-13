Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:33791 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757593Ab0LMQMD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 11:12:03 -0500
Subject: Re: [RFC v2 0/2] implementation of scheduled scan
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1292012223.3531.32.camel@jlt3.sipsolutions.net>
References: <1291993632-6921-1-git-send-email-luciano.coelho@nokia.com>
	 <1292010802.3531.6.camel@jlt3.sipsolutions.net>
	 <1292012223.3531.32.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 18:13:34 +0200
Message-ID: <1292256814.2951.274.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-10 at 21:17 +0100, ext Johannes Berg wrote:
> On Fri, 2010-12-10 at 20:53 +0100, Johannes Berg wrote:
> > On Fri, 2010-12-10 at 17:07 +0200, luciano.coelho@nokia.com wrote:
> > 
> > > * I kept the return value in the sched_scan_stop chain, because, at least with
> > >   wl12xx, the call can fail (due to OOM for instance).  I think it's cleaner
> > >   this way.
> > 
> > What's going to happen then though? Would it make sense to pre-allocate
> > this at start() time, so it can cleanly stop regardless of what's going
> > on? I can see start() failing, but stop() failing seems a bit hard to
> > work with in wpa_supplicant?
> 
> Actually so the nl80211 interface has to be able to return something
> like "no such operation in progress" or whatever, but I'm not sure about
> the driver interface -- -ENOMEM seems like a stupid failure for stopping
> something, and then the above applies ...

Indeed returning -ENOMEM sounds stupid when trying to clean up
something...

In wl12xx there are two other ways the operation can fail: the stop
command can fail, and in this case we start a hw recovery, so there's no
problem; the stop command can time out, which is not handled.  Maybe the
timeout should also trigger a hw recovery, but that's a different story.

So, the only thing remaining is the OOM.  I guess I'll just have to deal
with it in the driver.  We don't pre-alloc any commands at the moment,
but maybe it will have to be done in this case... Let's see.

I'll change the code so that the driver sched_scan stop interface
returns void.

Regarding the "no such operation in progress", I actually handle that by
simply returning with no error.  Do you think I should return an error
in that case instead?

-- 
Cheers,
Luca.


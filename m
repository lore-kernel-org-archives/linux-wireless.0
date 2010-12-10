Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59495 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab0LJURD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 15:17:03 -0500
Subject: Re: [RFC v2 0/2] implementation of scheduled scan
From: Johannes Berg <johannes@sipsolutions.net>
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1292010802.3531.6.camel@jlt3.sipsolutions.net>
References: <1291993632-6921-1-git-send-email-luciano.coelho@nokia.com>
	 <1292010802.3531.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 21:17:03 +0100
Message-ID: <1292012223.3531.32.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-10 at 20:53 +0100, Johannes Berg wrote:
> On Fri, 2010-12-10 at 17:07 +0200, luciano.coelho@nokia.com wrote:
> 
> > * I kept the return value in the sched_scan_stop chain, because, at least with
> >   wl12xx, the call can fail (due to OOM for instance).  I think it's cleaner
> >   this way.
> 
> What's going to happen then though? Would it make sense to pre-allocate
> this at start() time, so it can cleanly stop regardless of what's going
> on? I can see start() failing, but stop() failing seems a bit hard to
> work with in wpa_supplicant?

Actually so the nl80211 interface has to be able to return something
like "no such operation in progress" or whatever, but I'm not sure about
the driver interface -- -ENOMEM seems like a stupid failure for stopping
something, and then the above applies ...

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47544 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZD2QUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 12:20:11 -0400
Subject: Re: [PATCH] mac80211: tell driver when idle
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241021479.22715.6.camel@johannes.local>
References: <1240997537.593.35.camel@johannes.local>
	 <1241015587.997.76.camel@localhost.localdomain>
	 <1241015999.593.62.camel@johannes.local>
	 <1241018085.4104.4.camel@localhost.localdomain>
	 <1241021479.22715.6.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 09:20:06 -0700
Message-Id: <1241022006.4104.6.camel@localhost.localdomain> (sfid-20090429_182017_972835_DA186205)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > there can be always a situation where this ends up badly. You tell the
> > hardware that it can sleep now, but then you change your mind because
> > userspace finally got its act together. Bad luck.
> 
> Right.
> 
> > My point here is only that if the hardware needs a certain amount of
> > time before it makes sense to sleep, it should just tell mac80211 this
> > and it should be honored.
> 
> I don't really see how that makes sense though. Why would the hardware
> "need[] a certain amount of time before it makes sense to sleep"? How
> would it not make sense to go to sleep whenever possible, right away,
> however long the hardware needs to actually go to sleep then?
> 
> Yes, it's possible that the hardware takes a little while to wake up
> again, but we can only account for that if we can predict when we need
> to wake up again in the future, but we definitely can't. So yes, while
> it doesn't make sense to tell the hw we're idle when we will only be
> idle for 50ms and the hw needs 30 to go into idle and 30 to get out of
> it, I'm not sure how telling it that it needs 30ms will help mac80211.
> Going to idle and coming out of it is meant to be synchronous, so
> mac80211 will always wait for the driver to finish that operation.
> 
> > The default should be that we try how good the hardware can handle
> > mac80211 being aggressive with switching to idle. Maybe auth/assoc is a
> > special case anyway and we should have a sensible timeout value. We
> > could ask userspace to tell use that value when doing auth, but that
> > feels kinda ugly to me.
> 
> Being idle between auth and assoc probably is a special case, yeah. So
> far iwlwifi has handled it just fine for me though, so I'm inclined to
> not worry about it too much. Well, with the race fix...

I am all for just trying and then actually see if hardware falls over,
because we are too aggressive. However you asked about it in the first
place, and got my comment ;)

Regards

Marcel



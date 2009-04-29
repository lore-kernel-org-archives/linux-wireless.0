Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60860 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbZD2POu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 11:14:50 -0400
Subject: Re: [PATCH] mac80211: tell driver when idle
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241015999.593.62.camel@johannes.local>
References: <1240997537.593.35.camel@johannes.local>
	 <1241015587.997.76.camel@localhost.localdomain>
	 <1241015999.593.62.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 08:14:45 -0700
Message-Id: <1241018085.4104.4.camel@localhost.localdomain> (sfid-20090429_171458_742703_C4414F2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > Is it appropriate to go into idle state for a short time when we have
> > > just authenticated, but not associated yet? This happens only with the
> > > userspace SME, because we cannot really know how long it will wait
> > > before asking us to associate. Would going idle after a short timeout
> > > be more appropriate? We may need to revisit this, depending on what
> > > happens.
> > 
> > what about having the hardware set a value for how long something should
> > be idle before you tell it. I am more thinking about some sort penalty
> > value from the hardware that can not do this quickly.
> 
> You're only referring to this case of between auth/assoc, right? I'm not
> sure it makes sense to have this HW dependent, the time between
> auth/assoc really only depend on how fast the SME is. If we first wait a
> bit, because HW advertises some "penalty value", and then the SME is
> just a little bit slower than that value, we'd get an even worse
> situation, no?

there can be always a situation where this ends up badly. You tell the
hardware that it can sleep now, but then you change your mind because
userspace finally got its act together. Bad luck.

My point here is only that if the hardware needs a certain amount of
time before it makes sense to sleep, it should just tell mac80211 this
and it should be honored.

The default should be that we try how good the hardware can handle
mac80211 being aggressive with switching to idle. Maybe auth/assoc is a
special case anyway and we should have a sensible timeout value. We
could ask userspace to tell use that value when doing auth, but that
feels kinda ugly to me.

Regards

Marcel



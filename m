Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:32794 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758856AbXK1RIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 12:08:19 -0500
Message-ID: <474DA081.7030101@lwfinger.net> (sfid-20071128_170822_636037_C9188587)
Date: Wed, 28 Nov 2007 11:08:17 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC/T V2] b43: Fix Radio On/Off LED action
References: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net> <200711281713.02919.mb@bu3sch.de> <474D9A46.1020300@lwfinger.net> <200711281746.56069.mb@bu3sch.de>
In-Reply-To: <200711281746.56069.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Wednesday 28 November 2007 17:41:42 Larry Finger wrote:
>> Michael Buesch wrote:
>>> I think it's a different bug. The backtrace seems corrupted.
>>>
>>> Can you try this patch? There is some circular locking in rfkill.
>> I still get circular locking. The dump is
> 
> Ok.
> 
> b43 init:
> 	mutex_lock(wl->mutex)
> 	rfkill_init()
> 		mutex_lock(rfkill->mutex)
> 
> in operation:
> 	rfkill poll (no locks held)
> 	calls into rfkill
> 	mutex_lock(rfkill->mutex)
> 	b43_rfkill_soft_toggle()
> 		mutex_lock(wl->mutex)
> 
> As you can see the lock ordering of the two mutexes
> is different. The problem is that we cannot easily drop
> the wl->mutex on b43 init, as that would introduce some
> race conditions. This is specific to b43 and rt2x00 most
> likely doesn't have this requirement.
> I'm not sure how to properly fix this.

Your analysis is correct. I wrapped the call to b43_rfkill_init() with an unlock/lock pair of calls
(races be damned) and the circular locking message went away. BTW, that kind of wrapping is already
done for b43_rfkill_exit(). Curious.

Larry

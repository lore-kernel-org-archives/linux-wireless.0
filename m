Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34075
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281AbXK1QsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 11:48:12 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [RFC/T V2] b43: Fix Radio On/Off LED action
Date: Wed, 28 Nov 2007 17:46:55 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net> <200711281713.02919.mb@bu3sch.de> <474D9A46.1020300@lwfinger.net>
In-Reply-To: <474D9A46.1020300@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711281746.56069.mb@bu3sch.de> (sfid-20071128_164816_339209_AE7E50CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 November 2007 17:41:42 Larry Finger wrote:
> Michael Buesch wrote:
> > 
> > I think it's a different bug. The backtrace seems corrupted.
> > 
> > Can you try this patch? There is some circular locking in rfkill.
> 
> I still get circular locking. The dump is

Ok.

b43 init:
	mutex_lock(wl->mutex)
	rfkill_init()
		mutex_lock(rfkill->mutex)

in operation:
	rfkill poll (no locks held)
	calls into rfkill
	mutex_lock(rfkill->mutex)
	b43_rfkill_soft_toggle()
		mutex_lock(wl->mutex)

As you can see the lock ordering of the two mutexes
is different. The problem is that we cannot easily drop
the wl->mutex on b43 init, as that would introduce some
race conditions. This is specific to b43 and rt2x00 most
likely doesn't have this requirement.
I'm not sure how to properly fix this.

-- 
Greetings Michael.

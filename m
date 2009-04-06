Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34672 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882AbZDFL4l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 07:56:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: b43 WARN_ON
Date: Mon, 6 Apr 2009 13:55:58 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <49D97CF5.4040808@lwfinger.net> <200904061212.10398.mb@bu3sch.de> <1239013529.13407.6.camel@johannes.local>
In-Reply-To: <1239013529.13407.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904061355.58533.mb@bu3sch.de> (sfid-20090406_135644_113175_1FC0F302)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 April 2009 12:25:29 Johannes Berg wrote:
> Actually, I think the check is invalid, or rather, rfkill.registered
> needs to be set before registering the rfkill struct.

Would cause a wl->mutex deadlock.

> See, right now, and I'm not entirely happy with this, during
> rfkill_register I call the set_block callback. The reason I'm not really
> happy with that is that I said calling driver -> rfkill -> driver is
> bad, but on the other hand due to locking constraints across the
> subsystems the driver cannot take the same locks around rfkill_register
> as in the callbacks.

Exactly. ;)

> Additionally, the driver must be ready to service rfkill calls _before_
> rfkill_register() is called, everything else results in a race
> condition. Compare with the shared interrupt handlers, for instance.

The driver _is_ ready. It's just not ready to service recursive calls
due to the deadlock. That's what we protect against.

> The reason I call it during rfkill_register is that I need to sync the
> software state to the driver's block state, and that needs to be done
> somewhere. Doing that from a work struct would be possible, but wouldn't
> solve the locking constraints nor would it actually help since
> rfkill_register can potentially sleep, so the work could still be
> executed before rfkill_register returns -- the driver still needs to be
> able to handle rfkill callbacks before rfkill_register returns.

No. The mutex mechanism will make sure there's no deadlock and the scheduler will
schedule the threads in correct order, if you call set_block from the workqueue.
So I think doing the initial set_block from the workqueue asynchronously _would_ solve
the deadlock issue.

> Therefore, the warning is spurious, but because of a driver bug
> elsewhere -- I think the rfkill.registered = 1 assignment should be
> moved up to before rfkill_register() (and be = 0 again if that fails
> unexpectedly); I'll do that in my patch.

As I said. The driver cannot service callbacks while it's registering.
So the registered=1 must remain where it is.

Simply remove the warning, please.

-- 
Greetings, Michael.

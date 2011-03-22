Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1CVPUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 11:20:43 -0400
Subject: Re: [RFC 0/9] add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1299011804-13899-1-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 16:20:42 +0100
Message-ID: <1300807242.3746.47.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this third email, some thoughts about the internal APIs.

For the model 2) that I described, I think the current APIs as
implemented in this patchset are not effective. Remember that in this
model, there's no change to how the chip operates, it just continues
operating as before, while the host is suspended, and has no extra
wakeup conditions, just the regular interrupt.

Things are more complex in the more traditional model, mostly depending
on how we answer the questions I posed in my second email.

However, ultimately I think we should move away from the start/stop
model we've imposed right now. The model makes sense for the case where
the device is shut down, but I think it doesn't make sense at all for
the case where the device stays up, in whatever form.

Just looking at patch 4/9 in Eliad's series that I'm replying to, I
think that it's clear that there's no sense in trying to keep the
mac80211 logic for the wowlan suspend case.

I think what we should do instead is this:
 1) Add suspend/resume ops instead of going through stop/start and all
    the deconfiguration / reconfiguration (of course keep all the
    previous logic for drivers that don't implement suspend.)

 2) Implement more iterators / accessors to allow drivers to get access
    to more information. Some of that might not be necessary since at
    resume in some cases the device might just go and request a restart,
    but in other cases this might be necessary to simplify/avoid book-
    keeping in drivers.

Adding such APIs would allow drivers to be more in control of what
happens at suspend, which given the complexity of how this might work,
with configuring the driver etc.

Thoughts?

johannes


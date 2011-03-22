Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58942 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1CVOqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 10:46:39 -0400
Subject: Re: [RFC 0/9] add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1299011804-13899-1-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 15:46:37 +0100
Message-ID: <1300805197.3746.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let's back up a bit on this and think about the design some more, since
this touches a whole bunch of different things.

First, I think there at least two WoWLAN models:

1) The "traditional" model:

In this model, the device handles many things, there are different
wakeup triggers, for example:
 * magic packet
 * packet pattern
 * connection lost
 * GKT rekeying (although some devices may support this in firmware and
   then don't wake up), or rekeying failure
 * rfkill (?)
 * random other things

These are only available while connected to a (typically exactly one)
AP. Also, importantly, some of these require explicit configuration.

Additionally, some devices may support "network detection", a form of
scanning and waking up the host if certain conditions are met.


However, with that, we also get closer to

2) The "wake whenever there's something to do" model:

I don't have a good name for this, really, but it's what the TI chip
does right now -- it just wakes the host when there's something to do
for it, whatever that might be. It's closer to Android's wake-lock model
in a way I guess., the "network detection" would also be possible to
implement with this in the TI chip since it has such functionality
(which also doesn't depend on going to suspend, unlike ours which
basically cannot be interleaved with other things).


Whichever model is used, however, there will be spurious wakeups. I hope
there's some way of identifying which device woke up the system and then
go to sleep again. I think the only reasonable use case for WoWlan is
with some kind of "suspend manager" that evaluates this information and
puts the system to sleep again as appropriate.

This manager component might also connect to a network after "network
detection" while suspended found something, and then suspend the system
again with new triggers.

johannes



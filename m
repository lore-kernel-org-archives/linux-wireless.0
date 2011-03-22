Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38802 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab1CVPNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 11:13:04 -0400
Subject: Re: [RFC 0/9] add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1299011804-13899-1-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 16:13:02 +0100
Message-ID: <1300806782.3746.41.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the second email, I'll gather some thoughts about userspace APIs.

Regardless of how suspend works, the device may need special
configuration (e.g. wakeup patterns [1], rekeying information or
similar), in our case it even needs special firmware uploaded. Suspend
might also only be possible in certain configurations, like being
associated with exactly one AP, and not while operating as an AP, for
example.

Clearly, there are race conditions here. Say magic packet wakeup is
configured, but we get disconnected by the AP just before suspend. There
will not be a way to honour that trigger now, so I would argue that we
should fail the suspend in that case. The only other alternative is
silently not failing, but then there will be no wakeup trigger at all,
and had the disconnect happened earlier network detection might've been
configured. If it fails, the userspace suspend agent I was talking about
can reconfigure.

However, in this case the userspace agent would also have to completely
deconfigure wowlan triggers before being able to suspend "normally".
Maybe even this distinction has to be under userspace control to allow
it to operate in multiple models.

Back to the unsupported modes though, should those fail suspend as well?
Currently, we simply deconfigure everything during suspend. But once we
have a model of "the connection stays up during suspend", should we
still silently shut down AP mode interfaces and keep the others during
suspend? That seems inconsistent.

Again, the solution might be a suspend agent that will configure the
system in a way that suspend is possible. But how can it tell that
suspend will be possible? Between the different possible models, there
can be a lot of variety. We can expose those, but what will userspace do
with the information? Do we require that it configures the device in a
way that it can suspend, or do we do that in the drivers?


As far as the actual API is concerned, I don't really see any big issues
with it, since we simply set and retrieve triggers. There will be a need
for getting some more information after wakeup, particularly when the
device supports GTK rekeying while asleep.

The bigger questions I have are around the semantic issues I've
outlined. How do we want to treat those?

johannes

[1] incidentally, this might be supported in the "continue operating"
model, by programming filters into the device, which might not be
exposed as host runtime APIs.



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42703 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712Ab1FVNIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 09:08:11 -0400
Subject: Re: [RFC][PATCH v2 3/7] NFC: add nfc generic netlink interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lauro.venancio@openbossa.org, marcio.macedo@openbossa.org,
	Waldemar.Rymarkiewicz@tieto.com
In-Reply-To: <20110622125710.GD22420@sortiz-mobl>
References: <1308592212-5755-1-git-send-email-aloisio.almeida@openbossa.org>
	 <1308592212-5755-4-git-send-email-aloisio.almeida@openbossa.org>
	 <1308728084.3883.9.camel@jlt3.sipsolutions.net>
	 <20110622125710.GD22420@sortiz-mobl>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 15:08:06 +0200
Message-ID: <1308748086.29571.4.camel@jlt3.sipsolutions.net> (sfid-20110622_150814_957049_67AEB1F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-22 at 14:57 +0200, Samuel Ortiz wrote:

> > And this looks like an array. Do you really want to do that? That means
> > lots of reallocations.

> So NFC polling is a bit weird. Whenever you start polling for passive targets,
> the polling results are minimal: You only know that there is _a_ target on a
> particular frequency/modulation. It could be the same as the one you got 5
> minutes ago, or not. To verify it, you'd need to select the target (and put
> all other ones on standby) and start sending specific commands to it (Of
> course, you have a different set of commands per target family...). Only then
> you _may_ read some sort of UID that could help you matching targets from your
> previous poll cycle.
> My point is, when we start polling, we will invalidate all existing targets
> anyway. So a linked list or an array won't make a big difference in that area.

So basically you're saying that you basically get everything at the same
time so you really throw away the old list/array and re-create it.

But from a driver POV, does it really know the number of targets?
Otherwise it'll have to reallocate.

Anyway, all this doesn't matter since it's purely internal, and the
userspace APIs no longer have this limitation, so if this turns out an
issue at some point internal refactoring can easily fix it :-)

johannes


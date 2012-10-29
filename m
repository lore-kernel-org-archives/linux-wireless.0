Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38535 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759511Ab2J2QZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 12:25:58 -0400
Message-ID: <1351527990.10925.35.camel@jlt4.sipsolutions.net> (sfid-20121029_172601_413845_8D9FFEF0)
Subject: Re: [PATCH v2] wireless: Allow registering more than one beacon
 listener.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 29 Oct 2012 17:26:30 +0100
In-Reply-To: <508EAC30.8020600@candelatech.com>
References: <1351288165-24219-1-git-send-email-greearb@candelatech.com>
	  (sfid-20121026_234937_894351_D69F960C) <1351501451.10925.6.camel@jlt4.sipsolutions.net>
	 <508EAC30.8020600@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-29 at 09:17 -0700, Ben Greear wrote:

> >> +	spin_lock_bh(&rdev->beacon_registrations_lock);
> > ...
> >> +	spin_unlock_bh(&rdev->beacon_registrations_lock);
> >
> > I have a feeling this is incorrect, this is called with BHs disabled, so
> > if we disable/enable BHs here we end up with BHs enabled even if the
> > caller wanted them disabled, no?
> >
> > So I suppose unless we need to be able to call this from hard interrupt
> > in some driver (unlikely) we should add a change like this:
> 
> I get confused with the various types of spin-locks,
> and I just copied this code from the mgt frames logic.

Uh, that looks like a bug there as well then?

> I did run some tests and my code seems stable, but I could
> just be getting lucky.

Hmm I guess it depends on the driver, I suppose enabling BHs inside one
doesn't actually do anything, and it would only really matter for
drivers using ieee80211_rx_ni()?

> Do you want me to roll in your changes below and re-submit, or
> do you want to just make the updates?

I can do the update, I guess I'll sort out the mgmt frame part as well.

johannes

